local EVENT = {}
EVENT.Title = "Combo: Yogscast"
EVENT.Description = "Yogs intro + everyone's a yogscast model!"
EVENT.id = "cbyogs"

EVENT.Categories = {"eventtrigger", "largeimpact"}

local event1 = "jinglejam"
local event2 = "welcomeback"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)