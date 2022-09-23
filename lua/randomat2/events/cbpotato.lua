local EVENT = {}
EVENT.Title = "Combo: Sonic Potato!"
EVENT.Description = "Pass on the hot potato or explode + while you have it you're super fast!"
EVENT.id = "cbpotato"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "potato"
local event2 = "burdens"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)