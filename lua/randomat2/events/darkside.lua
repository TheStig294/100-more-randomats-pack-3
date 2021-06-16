local EVENT = {}

EVENT.Title = "Join the dark side!"
EVENT.Description = "Lightsabers for all!"
EVENT.id = "darkside"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			ply:Give("weapon_ttt_traitor_lightsaber")
		end)
	end
end

Randomat:register(EVENT)
