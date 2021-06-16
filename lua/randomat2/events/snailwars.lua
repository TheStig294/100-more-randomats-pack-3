local EVENT = {}

EVENT.Title = "Snail Wars"
EVENT.Description = "Everyone has a snail gun + freeze gun"
EVENT.id = "snailwars"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			if (ply:GetRole() ~= ROLE_JESTER) and (ply:GetRole() ~= ROLE_SWAPPER) then
				ply:Give("weapon_ttt_freezegun")
				ply:Give("weapon_ttt_killersnail")
			end
		end)
	end
end

function EVENT:Condition()
	local mapHasAI = MapHasAI()
	return mapHasAI
end

Randomat:register(EVENT)