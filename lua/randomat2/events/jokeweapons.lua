local EVENT = {}
EVENT.Title = "Random joke weapons for all!"
EVENT.id = "jokeweapons"

EVENT.Categories = {"item", "fun", "smallimpact"}

local jokeWeapons = {"ttt_slappers", "wt_writingpad", "equip_airboat", "weapon_ttt_moonball", "weapon_discordgift", "laserpointer", "weapon_ttt_confetti", "weapon_spraymhs"}

local jokeWeaponsInstalled = {}

-- Checks what joke weapons are installed
hook.Add("TTTPrepareRound", "JokeWeaponsInstallCheck", function()
    for i, wep in ipairs(jokeWeapons) do
        if weapons.Get(wep) ~= nil then
            table.insert(jokeWeaponsInstalled, wep)
        end
    end

    hook.Remove("TTTPrepareRound", "JokeWeaponsInstallCheck")
end)

-- Gives all alive players a random joke weapon, from the ones that are installed
function EVENT:Begin()
    for _, ply in pairs(self:GetAlivePlayers()) do
        local jokeWeapon = jokeWeaponsInstalled[math.random(#jokeWeaponsInstalled)]
        ply:Give(jokeWeapon)
        Randomat:CallShopHooks(false, jokeWeapon, ply)
    end
end

-- If there are no joke weapons, don't trigger this event
function EVENT:Condition()
    return not table.IsEmpty(jokeWeaponsInstalled)
end

Randomat:register(EVENT)