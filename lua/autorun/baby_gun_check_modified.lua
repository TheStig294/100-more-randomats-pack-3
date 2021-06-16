-- This entire lua file is dedicated to fixing the infamous Baby Maker glitch
-- The saga of fixing this is finally over, for your own sanity, it's best you don't touch this lua file...
-- (Unless absolutely necessary)
hook.Add("TTTEndRound", "BabyMakerTTTReset", function()
    timer.Simple(0.1, function()
        -- The problem was "IsBaby" was left to "true", after a player had respawned, causing all sorts of crazy shenanigans
        -- So, at the end of every round of TTT, everyone has the flags set by the Baby Maker to false, as a fail-safe
        for i, ply in pairs(player.GetAll()) do
            ply:SetNWString("BabyOnGround", "false")
            ply:SetNWString("IsBaby", "false")
        end
    end)
end)

-- The hook has been renamed so that it isn't overridden by the old hook
hook.Add("Think", "KickBabyGunCheckModified", function()
    local babykicker = nil
    -- Removing the old hook every tick may be overkill, but after so many attempts at fixing this bug I wanted revenge...
    hook.Remove("Think", "KickBabyGunCheck")

    -- This part behaved just fine, it constantly checks if a baby player needs to be kicked into the air
    for k, v in pairs(player.GetAll()) do
        for a, b in pairs(ents.FindInSphere(v:GetPos(), 35)) do
            if b:IsNPC() or scripted_ents.GetType(b:GetClass()) == "nextbot" or b:IsPlayer() and v ~= b then
                if b:GetNWString("ShouldKickBaby") == "true" then
                    local aim = v:GetAimVector()
                    local force = aim * (3 * 500)

                    if SERVER then
                        if b:IsNPC() or scripted_ents.GetType(b:GetClass()) == "nextbot" or b:IsPlayer() then
                            local OldBoneScale = b:GetModelScale()

                            if b:GetNWString("CanAddVelocity") == "true" then
                                local tr = v:GetEyeTrace()
                                local shot_length = tr.HitPos:Length()
                                local multiplyscale = math.random(1500, 3000)

                                local kickSoundTable = {"weapons/zmb/mini/kicked/zmb_mini_kicked01.wav", "weapons/zmb/mini/kicked/zmb_mini_kicked02.wav", "weapons/zmb/mini/kicked/zmb_mini_kicked03.wav", "weapons/zmb/mini/kicked/zmb_mini_kicked04.wav"}

                                b:EmitSound(kickSoundTable[math.random(1, table.Count(kickSoundTable))])

                                timer.Simple(0.1, function()
                                    b:SetNWString("BabyOnGround", "true")
                                end)

                                b:SetNWString("CanAddVelocity", "false")

                                if scripted_ents.GetType(b:GetClass()) == "nextbot" then
                                    local dmg = DamageInfo()
                                    dmg:SetDamage(b:Health())
                                    dmg:SetAttacker(v)
                                    dmg:SetDamageForce(Vector(aim.x * multiplyscale * 3, aim.y * multiplyscale * 3, math.random(4000, 7000)))
                                    b:SetPos(b:GetPos() + Vector(0, 0, 32))

                                    timer.Simple(0.1, function()
                                        if SERVER then
                                            b:TakeDamageInfo(dmg)
                                        end
                                    end)
                                else
                                    b:SetVelocity(Vector(aim.x * multiplyscale, aim.y * multiplyscale, math.random(200, 350)))
                                    b:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                                    b:SetLocalAngularVelocity(Angle(math.random(250, 500), math.random(0, 5), 0))
                                end
                            end
                        end
                    end
                end
            end
        end

        -- But this was the problem, the part that checks whether a kicked player has hit the ground, and must be killed
        for c, d in pairs(ents.GetAll()) do
            if IsValid(v) and IsValid(d) and d:IsOnGround() and d:GetNWString("BabyOnGround") == "true" and d:GetNWString("IsBaby") == "true" then
                local dpos = d:GetPos()

                if SERVER and (d:IsNPC() or scripted_ents.GetType(d:GetClass()) == "nextbot" or d:IsPlayer()) then
                    if IsValid(d) and d:Alive() then
                        local dmg = DamageInfo()
                        dmg:SetDamage(d:Health())
                        dmg:SetAttacker(v)
                        -- Set the damage type to club (crowbar) so jesters aren't immune to this weapon
                        dmg:SetDamageType(DMG_CLUB)

                        -- A damage inflictor was needed so that this weapon respects role effects, such as the phantom haunting, or the jester winning when killed
                        if IsValid(GetGlobalEntity("BabyMakerInflictor")) then
                            dmg:SetInflictor(GetGlobalEntity("BabyMakerInflictor"))
                        end

                        -- Probably overkill, but TakeDamageInfo() was being called on the client in the original weapon, at the least causing lua errors
                        if SERVER then
                            d:TakeDamageInfo(dmg)
                            d:Remove()
                        end
                    end
                end

                local babyDieTable = {"weapons/zmb/mini/squashed/zmb_mini_squashed01.wav", "weapons/zmb/mini/squashed/zmb_mini_squashed02.wav", "weapons/zmb/mini/squashed/zmb_mini_squashed03.wav", "weapons/zmb/mini/squashed/zmb_mini_squashed04.wav"}

                d:EmitSound(babyDieTable[math.random(1, table.Count(babyDieTable))])
                local startp = dpos

                local traceinfo = {
                    start = startp,
                    endpos = startp - Vector(0, 0, 50),
                    filter = ent,
                    mask = MASK_NPCWORLDSTATIC
                }

                local trace = util.TraceLine(traceinfo)
                local todecal1 = trace.HitPos + trace.HitNormal
                local todecal2 = trace.HitPos - trace.HitNormal
                util.Decal("Blood", todecal1, todecal2)

                if SERVER then
                    local gib = ents.Create("ent_gib")
                    gib:SetPos(dpos + Vector(0, 0, 1))
                    gib:Spawn()
                    local phys = gib:GetPhysicsObject()

                    if (phys:IsValid()) then
                        phys:SetVelocity(Vector(math.random(-50, 50), math.random(-50, 50), 150) * math.random(2, 3))
                    end
                end

                -- Other than removing the old hook, this is the part that really helped finally fix the bug,
                -- Setting the player's IsBaby flag to false, now that the player should have died and no longer be a baby
                d:SetNWString("IsBaby", "false")
            end
        end
    end
end)