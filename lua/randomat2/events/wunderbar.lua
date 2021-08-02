local EVENT = {}
EVENT.Title = "Wunderbar!"
EVENT.Description = "Does nothing, this event is disabled"
-- EVENT.Description = "Everyone gets a COD Zombies wonder weapon!"
EVENT.id = "wunderbar"

-- local wonderWeapons = {"tfa_acidgat", "tfa_blundergat", "tfa_jetgun", "tfa_raygun", "tfa_raygun_mark2", "tfa_scavenger", "tfa_shrinkray", "tfa_sliquifier", "tfa_staff_wind", "tfa_thundergun", "tfa_vr11", "tfa_wavegun", "tfa_wintershowl", "tfa_wunderwaffe"}
-- local wonderWeaponsActive = {}
-- hook.Add("TTTPrepareRound", "WonderWeaponsInstallCheck", function()
--     for i, wep in ipairs(wonderWeapons) do
--         if weapons.Get(wep) ~= nil then
--             table.insert(wonderWeaponsActive, wep)
--         end
--     end
--     hook.Remove("TTTPrepareRound", "WonderWeaponsInstallCheck")
-- end)
function EVENT:Begin()
    -- for i, ply in pairs(self:GetAlivePlayers()) do
    --     timer.Simple(0.1, function()
    --         ply:Give(wonderWeaponsActive[math.random(#wonderWeaponsActive)])
    --     end)
    -- end
    timer.Simple(5, function()
        Randomat:SmallNotify("This event is disabled, triggering another")
    end)

    timer.Simple(10, function()
        RunConsoleCommand("ttt_randomat_triggerrandom")
    end)
end

function EVENT:Condition()
    -- if #wonderWeaponsActive == 1 then return false end
    -- return not table.IsEmpty(wonderWeaponsActive)
    return false
end

Randomat:register(EVENT)