local EVENT = {}
EVENT.Title = "Combo: Uh-oh"
EVENT.Description = "Innocents freeze every 30 secs + RELEASE THE SNAILS!"
EVENT.id = "cbsnailsfreeze"

EVENT.Categories = {"biased_traitor", "biased", "eventtrigger", "moderateimpact"}

local event1 = "freeze"
local event2 = "snails"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)