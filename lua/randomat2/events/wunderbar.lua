local EVENT = {}
EVENT.Title = "Wunderbar!"
EVENT.Description = "Everyone gets a COD Zombies wonder weapon!"
EVENT.id = "wunderbar"

local wonderWeapons = {"tfa_acidgat", "tfa_blundergat", "tfa_jetgun", "tfa_raygun", "tfa_raygun_mark2", "tfa_scavenger", "tfa_shrinkray", "tfa_sliquifier", "tfa_staff_wind", "tfa_thundergun", "tfa_vr11", "tfa_wavegun", "tfa_wintershowl", "tfa_wunderwaffe", "tfa_staff_lightning"}

local wonderWeaponsActive = {}

-- Checks what wonder weapons are installed and not disabled
hook.Add("TTTPrepareRound", "WonderWeaponsInstallCheck", function()
    for i, wep in ipairs(wonderWeapons) do
        if weapons.Get(wep) ~= nil then
            table.insert(wonderWeaponsActive, wep)
        end
    end

    hook.Remove("TTTPrepareRound", "WonderWeaponsInstallCheck")
end)

-- Gives all alive players a random wonder weapon, from the ones that are active
function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            local wonderWeapon = wonderWeaponsActive[math.random(#wonderWeaponsActive)]
            ply:Give(wonderWeapon)
            Randomat:CallShopHooks(false, wonderWeapon, ply)
        end)
    end
end

-- If there are no wonder weapons, don't trigger this event
function EVENT:Condition()
    return not table.IsEmpty(wonderWeaponsActive)
end

Randomat:register(EVENT)