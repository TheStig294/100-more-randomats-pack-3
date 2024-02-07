local EVENT = {}
EVENT.Title = "Combo: Snails vs. snails"
EVENT.Description = "Everyone is a snail + has a snail following them!"
EVENT.id = "cbsnails"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "snails"
local backupEvent1 = "planes"
local event2 = "snailtime"
local snailGunInstalled
local snailPlaneInstalled

function EVENT:Begin()
    if snailGunInstalled then
        Randomat:SilentTriggerEvent(event1)
        Randomat:SilentTriggerEvent(event2)
    elseif snailPlaneInstalled then
        Randomat:SilentTriggerEvent(backupEvent1)
        Randomat:SilentTriggerEvent(event2)
    end
end

function EVENT:Condition()
    snailGunInstalled = weapons.Get("weapon_ttt_killersnail") ~= nil
    snailPlaneInstalled = ConVarExists("ttt_snailplane_music")
    if snailGunInstalled then return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2) end
    if snailPlaneInstalled then return Randomat:CanEventRun(backupEvent1) and Randomat:CanEventRun(event2) end

    return false
end

Randomat:register(EVENT)