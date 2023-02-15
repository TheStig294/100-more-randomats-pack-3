local EVENT = {}
EVENT.Title = "It's just a flesh wound."
EVENT.Description = "Everyone has a flesh wound"
EVENT.id = "fleshwound"

EVENT.Categories = {"item", "biased_innocent", "rolechange", "biased", "largeimpact"}

function EVENT:Begin()
    local new_traitors = {}

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsKillCommandSensitiveRole(ply) then
            self:StripRoleWeapons(ply)
            local isTraitor = Randomat:SetToBasicRole(ply, "Traitor")

            if isTraitor then
                table.insert(new_traitors, ply)
            end
        end

        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(EQUIP_FLSHWND))
            Randomat:CallShopHooks(true, EQUIP_FLSHWND, ply)
        end)
    end

    -- Send message to the traitor team if new traitors joined
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
    SendFullStateUpdate()
end

-- Checking if someone is a role that gets screwed over by the flesh wound using a kill command and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local killCommandSensitiveRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsKillCommandSensitiveRole(ply) then
            killCommandSensitiveRoleExists = true
            break
        end
    end

    return isnumber(EQUIP_FLSHWND) and (Randomat:GetRoundCompletePercent() < 5 or not killCommandSensitiveRoleExists)
end

Randomat:register(EVENT)