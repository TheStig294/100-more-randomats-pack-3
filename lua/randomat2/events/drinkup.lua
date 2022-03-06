local EVENT = {}
EVENT.Title = "Drink up!"
EVENT.Description = "Everyone gets a random COD Zombies perk bottle"
EVENT.id = "drinkup"

EVENT.Categories = {"item", "smallimpact"}

local perks = {}

hook.Add("TTTPrepareRound", "RandomatDrinkupGetPerkBottleIDs", function()
    local EQUIP_DOUBLETAP = EQUIP_DOUBLETAP or -1
    local EQUIP_JUGGERNOG = EQUIP_JUGGERNOG or -1
    local EQUIP_PHD = EQUIP_PHD or -1
    local EQUIP_SPEEDCOLA = EQUIP_SPEEDCOLA or EQUIP_SPEED or -1
    local EQUIP_STAMINUP = EQUIP_STAMINUP or -1

    perks = {EQUIP_DOUBLETAP, EQUIP_JUGGERNOG, EQUIP_PHD, EQUIP_SPEEDCOLA, EQUIP_STAMINUP}

    hook.Remove("TTTPrepareRound", "RandomatDrinkupGetPerkBottleIDs")
end)

function EVENT:Begin()
    for k, ply in pairs(self:GetAlivePlayers()) do
        local perk = perks[math.random(1, #perks)]
        ply:GiveEquipmentItem(tonumber(perk))
        Randomat:CallShopHooks(true, perk, ply)
    end
end

function EVENT:Condition()
    local has_perk_bottles = true

    for _, perk in ipairs(perks) do
        if perk == -1 then
            has_perk_bottles = false
            break
        end
    end

    return has_perk_bottles
end

Randomat:register(EVENT)