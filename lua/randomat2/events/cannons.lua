local cannonInstalled = false
local PHDInstalled = false
local PAPInstalled = false

hook.Add("InitPostEntity", "CannonsRandomatCheckInstalled", function()
    cannonInstalled = weapons.Get("weapon_ttt_artillery") ~= nil
    PHDInstalled = EQUIP_PHD ~= nil
    PAPInstalled = TTTPAP ~= nil
end)

local function GetDescription()
    local desc = "Everyone gets an"

    if PAPInstalled then
        desc = desc .. " upgraded"
    end

    desc = desc .. " artillery cannon"

    if PHDInstalled then
        desc = desc .. " or PHD Flopper"
    end

    desc = desc .. "!"

    return desc
end

local EVENT = {}
EVENT.Title = "Let's play the 1812 Overture"
EVENT.Description = GetDescription()
EVENT.id = "cannons"

EVENT.Categories = {"item", "largeimpact", "biased_traitor", "biased"}

function EVENT:Begin()
    self.Description = GetDescription()

    -- "true" means player table is shuffled
    for _, ply in ipairs(self:GetAlivePlayers(true)) do
        -- Make it more likely to get a cannon than PHD flopper
        if PHDInstalled and math.random() < 0.4 then
            ply:GiveEquipmentItem(tonumber(EQUIP_PHD))
            Randomat:CallShopHooks(true, EQUIP_PHD, ply)
        else
            local cannon = ply:Give("weapon_ttt_artillery")
            Randomat:CallShopHooks(false, "weapon_ttt_artillery", ply)

            if PAPInstalled then
                TTTPAP:ApplyUpgrade(cannon, TTTPAP:SelectUpgrade(cannon))
            end
        end
    end
end

function EVENT:Condition()
    return cannonInstalled
end

Randomat:register(EVENT)