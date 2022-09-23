local EVENT = {}
EVENT.Title = "Combo: Wibbly wobbly timey wimey"
EVENT.Description = "Everyone gets a time manipulator + gravity changer!"
EVENT.id = "cbtimegravity"

EVENT.Categories = {"item", "eventtrigger", "largeimpact"}

local event1 = "timemanipulator"
local event2 = "gravitychanger"

function EVENT:Begin()
    Randomat:SilentTriggerEvent(event1)
    Randomat:SilentTriggerEvent(event2)
end

function EVENT:Condition()
    return Randomat:CanEventRun(event1) and Randomat:CanEventRun(event2)
end

Randomat:register(EVENT)