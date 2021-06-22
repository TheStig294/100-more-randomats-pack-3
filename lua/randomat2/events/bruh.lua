local EVENT = {}
EVENT.Title = "Bruh..."
EVENT.Description = "Everyone has a bruh bunker"
EVENT.id = "bruh"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_DETECTIVE, EQUIP_BUNKER).id))
            -- You can't tell when you're given a bruh bunker, so this message is printed to chat
            ply:ChatPrint("You have been given a Bruh Bunker. Taking damage from a player will spawn a bunker around you. ")
            ply.cringealert = true
        end)
    end
end

function EVENT:Condition()
    local has_wep = false

    if isnumber(EQUIP_BUNKER) then
        has_wep = true
    end

    return has_wep
end

Randomat:register(EVENT)