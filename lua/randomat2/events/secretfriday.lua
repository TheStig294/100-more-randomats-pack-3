local EVENT = {}
EVENT.Title = "Secret Friday Update"
EVENT.Description = "Everyone gets a minecraft bow and block (Press 'R' to change block)"
EVENT.id = "secretfriday"
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

                local wep1 = ply:Give("republic_mcbow")
                local wep2 = ply:Give("minecraft_swep")
                wep1.AllowDrop = false
                wep2.AllowDrop = false
            end)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("republic_mcbow") ~= nil and has_weapons.Get("minecraft_swep") ~= nil
end

Randomat:register(EVENT)