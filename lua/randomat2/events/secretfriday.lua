local EVENT = {}
EVENT.Title = "Secret Friday Update"
EVENT.id = "secretfriday"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"item", "biased_innocent", "biased", "largeimpact"}

local blockInstalled = false
local bowInstalled = false

local function GetDescription()
    local desc = "Everyone gets a "

    if weapons.Get("minecraft_swep") and weapons.Get("republic_mcbow") then
        desc = desc .. "minecraft bow and block (Press 'R' to change block)"
    elseif weapons.Get("minecraft_swep") then
        desc = desc .. "minecraft block (Press 'R' to change block)"
    elseif weapons.Get("republic_mcbow") then
        desc = desc .. "minecraft bow"
    else
        return
    end

    return desc
end

hook.Add("InitPostEntity", "RandomatSecretFridayDescription", function()
    blockInstalled = weapons.Get("minecraft_swep") ~= nil
    bowInstalled = weapons.Get("republic_mcbow") ~= nil
    EVENT.Description = GetDescription()
end)

function EVENT:Begin()
    self.Description = GetDescription()

    for _, ply in pairs(self:GetAlivePlayers()) do
        if blockInstalled then
            ply:Give("minecraft_swep")
            Randomat:CallShopHooks(false, "minecraft_swep", ply)
        end

        if bowInstalled then
            ply:Give("republic_mcbow")
            Randomat:CallShopHooks(false, "republic_mcbow", ply)
        end
    end
end

function EVENT:Condition()
    return blockInstalled or bowInstalled
end

Randomat:register(EVENT)