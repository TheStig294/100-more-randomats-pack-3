local EVENT = {}

EVENT.Title = "It's time to go third-person!"
EVENT.Description = "Everyone is forced to stay in third-person"
EVENT.id = "thirdperson"

util.AddNetworkString( "ThirdPersonRandomat" )
util.AddNetworkString( "ThirdPersonRandomatEnd" )

SetGlobalBool("RandomatThirdPerson", false)

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

Randomat:register(EVENT)