local EVENT = {}
EVENT.Title = "Death isn't the end..."
EVENT.Description = "Everyone has a demonic possession"
EVENT.id = "possession"

EVENT.Categories = {"item", "biased", "largeimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(EQUIP_DEMONIC_POSSESSION))
            Randomat:CallShopHooks(true, EQUIP_DEMONIC_POSSESSION, ply)
        end)
    end
end

function EVENT:Condition()
    return isnumber(EQUIP_DEMONIC_POSSESSION)
end

Randomat:register(EVENT)