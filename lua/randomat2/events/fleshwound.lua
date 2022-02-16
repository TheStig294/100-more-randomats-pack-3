local EVENT = {}
EVENT.Title = "It's just a flesh wound."
EVENT.Description = "Everyone has a flesh wound"
EVENT.id = "fleshwound"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        if IsKillCommandSensitiveRole(ply) then
            self:StripRoleWeapons(ply)
            SetToBasicRole(ply)
        end

        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(EQUIP_FLSHWND))
            Randomat:CallShopHooks(true, EQUIP_FLSHWND, ply)
        end)
    end

    SendFullStateUpdate()
end

-- Checking if someone is a role that gets screwed over by the flesh wound using a kill command and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local killCommandSensitiveRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if IsKillCommandSensitiveRole(ply) then
            killCommandSensitiveRoleExists = true
            break
        end
    end

    return isnumber(EQUIP_FLSHWND) and (Randomat:GetRoundCompletePercent() < 5 or not killCommandSensitiveRoleExists)
end

Randomat:register(EVENT)