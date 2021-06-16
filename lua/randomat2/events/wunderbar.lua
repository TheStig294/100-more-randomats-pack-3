local EVENT = {}

EVENT.Title = "Wunderbar!"
EVENT.Description = "Everyone gets a COD Zombies wonder weapon!"
EVENT.id = "wunderbar"

local wonderWeapons = {
	"tfa_acidgat", 
	"tfa_blundergat", 
	"tfa_jetgun", 
	"tfa_raygun", 
	"tfa_raygun_mark2", 
	"tfa_scavenger", 
	"tfa_shrinkray", 
	"tfa_sliquifier", 
	"tfa_staff_wind", 
	"tfa_thundergun", 
	"tfa_vr11", 
	"tfa_wavegun", 
	"tfa_wintershowl", 
	"tfa_wunderwaffe"
}

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			ply:Give(wonderWeapons[math.random( #wonderWeapons )])
		end)
	end
end

Randomat:register(EVENT)