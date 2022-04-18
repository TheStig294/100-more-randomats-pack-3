local EVENT = {}
EVENT.Title = "It's time to go third-person!"
EVENT.Description = "Everyone is forced to stay in third-person"
EVENT.id = "thirdperson"

EVENT.Categories = {"largeimpact"}

util.AddNetworkString("ThirdPersonRandomat")
util.AddNetworkString("ThirdPersonRandomatEnd")
util.AddNetworkString("ThirdPersonRandomatCheck")
SetGlobalBool("RandomatThirdPerson", false)
local thirdpersonRandomat = false
local thirdpersonExists = false

hook.Add("TTTPrepareRound", "ThirdPersonCheck", function()
    net.Start("ThirdPersonRandomatCheck")
    net.Send(Entity(1))
    hook.Remove("TTTPrepareRound", "ThirdPersonCheck")
end)

net.Receive("ThirdPersonRandomatCheck", function()
    thirdpersonExists = true
end)

function EVENT:Begin()
    thirdpersonRandomat = true
    SetGlobalBool("RandomatThirdPerson", true)
    net.Start("ThirdPersonRandomat")
    net.Broadcast()
end

function EVENT:End()
    if thirdpersonRandomat then
        SetGlobalBool("RandomatThirdPerson", false)
        net.Start("ThirdPersonRandomatEnd")
        net.Broadcast()
        thirdpersonRandomat = false
    end
end

function EVENT:Condition()
    return thirdpersonExists
end

Randomat:register(EVENT)