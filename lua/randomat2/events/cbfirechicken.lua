local EVENT = {}
EVENT.Title = "Combo: KFC"
EVENT.Description = "Everyone is a chicken + has an amaterasu!"
EVENT.id = "cbfirechicken"

EVENT.Categories = {"largeimpact", "eventtrigger", "item"}

local event1 = "amaterasu"
local event2 = "chickens"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)