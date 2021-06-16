local perks = {
	"ttt_perk_doubletap",
	"ttt_perk_juggernog",
	"ttt_perk_phd",
	"ttt_perk_speed",
	"ttt_perk_staminup"
}

local EVENT = {}

EVENT.Title = "Drink up!"
EVENT.Description = "Everyone gets a random zombies perk"
EVENT.id = "drinkup"

function EVENT:Begin()
	-- Gets all players...
	for k, ply in pairs(self:GetAlivePlayers()) do
		ply:Give(table.Random(perks))
	end
end

Randomat:register(EVENT)