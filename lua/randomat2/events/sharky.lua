local EVENT = {}

EVENT.Title = "Sharky and Palp!"
EVENT.Description = "Puts someone with their best traitor partner"
EVENT.id = "sharky"

function EVENT:Begin()
	local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
	if data == nil then
		timer.Simple(5, function()
			self:SmallNotify("[TTT] Total Statistics not installed... Randomat can't trigger")
		end)
		return
	else
		stats = util.JSONToTable(data)
		math.randomseed(os.time())
	end
	
	chosenTraitor = table.Random(self:GetAlivePlayers())
	id = chosenTraitor:SteamID()
	nickname = chosenTraitor:Nick()
	
	traitorStats = stats[id]["TraitorPartners"]
	
	traitorWinRates = {}
	
	for i, ply in pairs(self:GetAlivePlayers()) do
		if ply:SteamID() ~= id then
			traitorWinRates[traitorStats[ply:SteamID()]["Wins"] / traitorStats[ply:SteamID()]["Rounds"]] = ply:Nick()
		end
	end
	
	bestTraitorWinRateTable = table.GetKeys(traitorWinRates)
	table.sort(bestTraitorWinRateTable)
	bestTraitorWinRate = bestTraitorWinRateTable[#bestTraitorWinRateTable]
	bestTraitorNickname = traitorWinRates[bestTraitorWinRate]
	
	traitorCount = 0
	for i, ply in pairs(self:GetAlivePlayers()) do
		if ply:Nick() == nickname or ply:Nick() == bestTraitorNickname then
			self:StripRoleWeapons(ply)
			Randomat:SetRole(ply, ROLE_TRAITOR)
			ply:SetCredits(GetConVar("ttt_credits_starting"):GetInt())
			SendFullStateUpdate()
			traitorCount = traitorCount + 1
		else
			self:StripRoleWeapons(ply)
			Randomat:SetRole(ply, ROLE_INNOCENT)
			SendFullStateUpdate()
		end
	end
	
	timer.Simple(5, function()
		self:SmallNotify("The traitors have a " .. math.Round(bestTraitorWinRate * 100) .. "% win rate!")
	end)
end

function EVENT:Condition()
	traitorCount = 0
	for i, ply in pairs(self:GetAlivePlayers()) do
		if ply:GetRole() == ROLE_TRAITOR or ply:GetRole() == ROLE_ASSASIN or ply:GetRole() == ROLE_HYPNOTIST or ply:GetRole() == ROLE_VAMPIRE then
			traitorCount = traitorCount + 1
		end
	end
	
	if traitorCount < 2 then
		return false
	else
		return true
	end
end

Randomat:register(EVENT)