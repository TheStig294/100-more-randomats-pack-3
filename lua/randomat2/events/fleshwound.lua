local EVENT = {}
EVENT.Title = "It's just a flesh wound."
EVENT.Description = "Everyone has a flesh wound"
EVENT.id = "fleshwound"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(EQUIP_FLSHWND))
            Randomat:CallShopHooks(true, EQUIP_FLSHWND, ply)
        end)
    end
end

function EVENT:Condition()
    return isnumber(EQUIP_FLSHWND)
end

Randomat:register(EVENT)