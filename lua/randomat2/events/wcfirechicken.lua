local EVENT = {}
EVENT.Title = "Wombo Combo: Rocket Chickens"
EVENT.Description = "Everyone is a chicken + has an amaterasu!"
EVENT.id = "wcfirechicken"

EVENT.Categories = {"item", "largeimpact", "biased_traitor", "biased"}

function EVENT:Begin()
    Randomat:SilentTriggerEvent("amaterasu")
    Randomat:SilentTriggerEvent("chickens")
end

function EVENT:Condition()
    return Randomat:CanEventRun("amaterasu") and Randomat:CanEventRun("chickens")
end

Randomat:register(EVENT)