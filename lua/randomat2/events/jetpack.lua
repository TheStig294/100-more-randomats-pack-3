local EVENT = {}

EVENT.Title = "Reach for the sky..."
EVENT.Description = "Jetpacks for all!"
EVENT.id = "jetpack"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			ply:Give("weapon_ttt_jetpackspawner")
		end)
	end
end

Randomat:register(EVENT)
