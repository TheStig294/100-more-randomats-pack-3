local EVENT = {}

EVENT.Title = "Muahahaha!"
EVENT.Description = "Everyone can make a deal with the devil..."
EVENT.id = "devildeal"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			ply:Give("ttt_deal_with_the_devil")
		end)
	end
end

Randomat:register(EVENT)
