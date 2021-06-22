local EVENT = {}
EVENT.Title = "Random Deathmatch"
EVENT.Description = "Infinite free kill guns only!"
EVENT.id = "rdm"

function EVENT:Begin()
    for k, ply in pairs(self:GetAlivePlayers(true)) do
        if ply:GetRole() == ROLE_SWAPPER then
            swapper = ply
            Randomat:SetRole(swapper, ROLE_INNOCENT)
            SendFullStateUpdate()
        end

        if ply:GetRole() == ROLE_JESTER then
            jester = ply
            Randomat:SetRole(jester, ROLE_INNOCENT)
            SendFullStateUpdate()
        end
    end

    for _, ent in pairs(ents.GetAll()) do
        if (ent.Base == "weapon_tttbase" or ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY) and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            self:HandleWeaponAddAndSelect(ply, function(active_class, active_kind)
                for _, wep in pairs(ply:GetWeapons()) do
                    if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                        ply:StripWeapon(wep:GetClass())
                    end
                end

                -- Reset FOV to unscope weapons if they were possibly scoped in
                if active_kind == WEAPON_HEAVY or active_kind == WEAPON_PISTOL then
                    ply:SetFOV(0, 0.2)
                end

                local wep1 = ply:Give("weapon_rp_railgun")
                ply:SelectWeapon(wep1)
                wep1.AllowDrop = false
            end)
        end)
    end

    timer.Simple(1, function()
        self:AddHook("Think", function()
            for _, v in pairs(self:GetAlivePlayers()) do
                if IsValid(v:GetActiveWeapon()) then
                    if v:GetActiveWeapon():GetClass() == "weapon_rp_railgun" then
                        v:GetActiveWeapon():SetClip1(v:GetActiveWeapon().Primary.ClipSize)
                    end
                end
            end
        end)
    end)
end

function EVENT:Condition()
    if (Randomat:IsEventActive("reload") or Randomat:IsEventActive("prophunt") or Randomat:IsEventActive("harpoon") or Randomat:IsEventActive("slam")) or (not ConVarExists("ttt_rp_railgun_sound")) then
        return false
    else
        return true
    end
end

Randomat:register(EVENT)