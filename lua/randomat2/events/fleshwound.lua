local EVENT = {}
EVENT.Title = "It's just a flesh wound."
EVENT.Description = "Everyone has a flesh wound"
EVENT.id = "fleshwound"

EVENT.Categories = {"item", "biased_innocent", "rolechange", "biased", "largeimpact"}

function EVENT:Begin()
    local _, _, new_traitors = Randomat:BalanceTeams()

    for _, ply in ipairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(EQUIP_FLSHWND))
            Randomat:CallShopHooks(true, EQUIP_FLSHWND, ply)
        end)
    end

    -- Send message to the traitor team if new traitors joined
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
end

function EVENT:Condition()
    return isnumber(EQUIP_FLSHWND)
end

Randomat:register(EVENT)