local EVENT = {}
EVENT.Title = "Combo: \"Why aren't you dead?\""
EVENT.Description = "Infinite super shotguns + delayed damage!"
EVENT.id = "cbdelayshotguns"

EVENT.Categories = {"item", "eventtrigger", "largeimpact"}

local event1 = "delayedreaction"
local event2 = "supershotgun"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)