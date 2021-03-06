local EVENT = {}
EVENT.Title = "Bruh..."
EVENT.Description = "Everyone has a bruh bunker"
EVENT.id = "bruh"

EVENT.Categories = {"item", "biased_innocent", "biased", "moderateimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(EQUIP_BUNKER))
            Randomat:CallShopHooks(true, EQUIP_BUNKER, ply)
            -- You can't tell when you're given a bruh bunker, so this message is printed to chat
            ply:ChatPrint("You have been given a Bruh Bunker. Taking damage from a player will spawn a bunker around you. ")
        end)
    end
end

function EVENT:Condition()
    return isnumber(EQUIP_BUNKER)
end

Randomat:register(EVENT)