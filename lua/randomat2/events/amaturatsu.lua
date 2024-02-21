local EVENT = {}
EVENT.Title = "Careful where you look..."
EVENT.Description = "Everyone has an Amaterasu!"
EVENT.id = "amaterasu"

EVENT.Categories = {"item", "largeimpact", "biased_traitor", "biased"}

local activeItemInstalled = false

function EVENT:Begin()
    if EQUIP_AMATERASU then
        for _, ply in pairs(self:GetAlivePlayers()) do
            ply:GiveEquipmentItem(tonumber(EQUIP_AMATERASU))
            Randomat:CallShopHooks(true, EQUIP_AMATERASU, ply)
            ply:ChatPrint("You have been given an Amaterasu. The next player you look at will be set on fire!")
        end
    elseif activeItemInstalled then
        for _, ply in pairs(self:GetAlivePlayers()) do
            ply:Give("ttt_amaterasu")
            Randomat:CallShopHooks(false, "ttt_amaterasu", ply)
        end
    end
end

function EVENT:Condition()
    if weapons.Get("ttt_amaterasu") ~= nil then
        activeItemInstalled = true
    end

    return EQUIP_AMATERASU or activeItemInstalled
end

Randomat:register(EVENT)