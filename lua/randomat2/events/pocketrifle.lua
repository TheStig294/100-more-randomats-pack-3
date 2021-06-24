local EVENT = {}
EVENT.Title = "That's no pocket rifle..."
EVENT.Description = "Innocents get a pocket rifle, traitors get a star wars blaster"
EVENT.id = "pocketrifle"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            self:HandleWeaponAddAndSelect(ply, function(active_class, active_kind)
                for _, wep in pairs(ply:GetWeapons()) do
                    if wep.Kind == WEAPON_PISTOL then
                        ply:StripWeapon(wep:GetClass())
                    end
                end

                -- Reset FOV to unscope weapons if they were possibly scoped in
                if active_kind == WEAPON_PISTOL then
                    ply:SetFOV(0, 0.2)
                end

                if ply:GetRole() == ROLE_INNOCENT or ply:GetRole() == ROLE_DETECTIVE or ply:GetRole() == ROLE_GLITCH or ply:GetRole() == ROLE_PHANTOM or ply:GetRole() == ROLE_MERCENARY then
                    wep1 = ply:Give("weapon_rp_pocket")

                    timer.Simple(0.5, function()
                        ply:SelectWeapon(wep1)
                    end)

                    wep1.AllowDrop = false
                end

                if ply:GetRole() == ROLE_TRAITOR or ply:GetRole() == ROLE_HYPNOTIST or ply:GetRole() == ROLE_ASSASIN or ply:GetRole() == ROLE_VAMPIRE or ply:GetRole() == ROLE_KILLER then
                    wep2 = ply:Give("weapon_752_dl44")

                    timer.Simple(0.5, function()
                        ply:SelectWeapon(wep2)
                    end)

                    wep2.AllowDrop = false
                end
            end)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_rp_pocket") ~= nil and has_weapons.Get("weapon_752_dl44") ~= nil
end

Randomat:register(EVENT)