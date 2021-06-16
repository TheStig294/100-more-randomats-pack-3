local EVENT = {}

EVENT.Title = "Everyone has their favourites"
EVENT.Description = "Gives your most bought traitor + detective item, unless they take the same slot"
EVENT.id = "favourites"

function EVENT:Begin()
	local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
	if data == nil then
		timer.Simple(5, function()
			self:SmallNotify("[TTT] Total Statistics not installed... Randomat can't trigger")
		end)
		return
	else
		stats = util.JSONToTable(data)
	end
	
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			id = ply:SteamID()
			nickname = ply:Nick()
			
			detectiveStats = stats[id]["DetectiveEquipment"]
			detectiveItemName = table.GetWinningKey(detectiveStats)
			
			
			traitorStats = stats[id]["TraitorEquipment"]
			traitorItemName = table.GetWinningKey(traitorStats)
		
			if detectiveStats[detectiveItemName] >= traitorStats[traitorItemName] then
				PrintToGive(detectiveItemName, ply)
				PrintToGive(traitorItemName, ply)
			else
				PrintToGive(traitorItemName, ply)
				PrintToGive(detectiveItemName, ply)
			end
		end)
	end
end

Randomat:register(EVENT)
