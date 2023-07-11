local EVENT = {}
EVENT.Title = "Combo: Snails vs. snails"
EVENT.Description = "Everyone is a snail + has a snail following them!"
EVENT.id = "cbsnails"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "snails"
local event2 = "snailtime"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2) and weapons.Get("weapon_ttt_killersnail") ~= nil
end

Randomat:register(EVENT)