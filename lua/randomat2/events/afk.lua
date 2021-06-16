local EVENT = {}

EVENT.Title = "AFK = Dead"
EVENT.Description = "Being AFK kills you"
EVENT.id = "afk"

function EVENT:Begin()
	hook.Add("Think", "AFKKillThink", function()
		for i, ply in pairs(self:GetAlivePlayers()) do
			timer.Simple(0.1, function()
				if ply:GetNWBool("Minimized", false) and ply:GetNWBool("MinimizedKill", false) == false then
					ply:Kill()
					ply:SetNWBool("MinimizedKill", true)
					self:SmallNotify(ply:Nick() .. " went AFK")
				end
			end)
		end
	end)
	
	hook.Add("PlayerSpawn", "AFKKillRespawnCheck", function(ply, transition)
		timer.Simple(0.1, function()
			ply:SetNWBool("MinimizedKill", false)
		end)
	end)
end

function EVENT:End()
	for i, ply in pairs(player.GetAll()) do
		ply:SetNWBool("MinimizedKill", false)
	end
	hook.Remove("Think", "AFKKillThink")
	hook.Remove("PlayerSpawn", "AFKKillRespawnCheck")
end

Randomat:register(EVENT)