local EVENT = {}
EVENT.Title = "Sudden Death?"
EVENT.Description = "Infinite super shotguns for all!"
EVENT.id = "supershotgun"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
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

                local wep1 = ply:Give("doom_sshotgun_2016")
                ply:SelectWeapon(wep1)
                wep1.AllowDrop = false
            end)
        end)
    end

    timer.Simple(1, function()
        self:AddHook("Think", function()
            for _, v in pairs(self:GetAlivePlayers()) do
                if IsValid(v:GetActiveWeapon()) then
                    if v:GetActiveWeapon():GetClass() == "doom_sshotgun_2016" then
                        v:GetActiveWeapon():SetClip1(v:GetActiveWeapon().Primary.ClipSize)
                    end
                end
            end
        end)
    end)
end

function EVENT:Condition()
    return weapons.Get("doom_sshotgun_2016") ~= nil
end

Randomat:register(EVENT)