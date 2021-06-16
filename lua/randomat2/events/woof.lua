local EVENT = {}

EVENT.Title = "Woof Woof!"
EVENT.Description = "Everyone gets a guard dog summoner, press 'R' while selected"
EVENT.id = "woof"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			ply:Give("weapon_ttt_guard_dog")
		end)
	end
end

function EVENT:Condition()
	local mapHasAI = MapHasAI()
	return mapHasAI
end

Randomat:register(EVENT)