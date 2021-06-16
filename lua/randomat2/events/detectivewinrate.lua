local EVENT = {}

EVENT.Title = "100% Detective Winrate"
EVENT.Description = "Whoever has the highest detective winrate is now the detective!"
EVENT.id = "detectivewinrate"

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
	
	detectiveStats = {}
	for i, ply in pairs(self:GetAlivePlayers()) do
		detectiveStats[stats[ply:SteamID()]["DetectiveWins"]/stats[ply:SteamID()]["DetectiveRounds"]] = ply:Nick()
	end
		
	
	bestDetectiveTable = table.GetKeys(detectiveStats)
	table.sort(bestDetectiveTable)
	bestDetectiveWinRate = bestDetectiveTable[#bestDetectiveTable]
	bestDetectiveNickname = detectiveStats[bestDetectiveWinRate]
	
	--removing detective
	for i, ply in pairs(self:GetAlivePlayers()) do
		if ply:GetRole() == ROLE_DETECTIVE then
			self:StripRoleWeapons(ply)
			Randomat:SetRole(ply, ROLE_INNOCENT)
			SendFullStateUpdate()
		end
	end
	
	--setting detective to best detective
	for i, ply in pairs(self:GetAlivePlayers()) do
		if ply:Nick() == bestDetectiveNickname then
			self:StripRoleWeapons(ply)
			Randomat:SetRole(ply, ROLE_DETECTIVE)
			ply:SetCredits(GetConVar("ttt_det_credits_starting"):GetInt())
			SendFullStateUpdate()
		end
	end
	
	--counting no. of traitors to check if detective was a traitor
	traitorCount = 0
	for i, ply in pairs(self:GetAlivePlayers()) do
		if ply:GetRole() == ROLE_TRAITOR or ply:GetRole() == ROLE_ASSASIN or ply:GetRole() == ROLE_HYPNOTIST or ply:GetRole() == ROLE_VAMPIRE then
			traitorCount = traitorCount + 1
		end
	end
	
	--if less than 2 traitors, set a random innocents, other than the detective, into traitors until we have 2 
	for i, ply in pairs(self:GetAlivePlayers()) do
		if (traitorCount < 2) and (ply:GetRole() == ROLE_INNOCENT or ply:GetRole() == ROLE_MERCENARY or ply:GetRole() == ROLE_PHANTOM or ply:GetRole() == ROLE_GLITCH) then
			Randomat:SetRole(ply, ROLE_TRAITOR)
			ply:SetCredits(GetConVar("ttt_credits_starting"):GetInt())
			SendFullStateUpdate()
			traitorCount = traitorCount + 1
		end
	end
	
	--Notifying everyone of the detective's winrate
	timer.Simple(5, function()
		self:SmallNotify(bestDetectiveNickname.. " is the detective with a " .. math.Round(bestDetectiveWinRate * 100) .. "% win rate!")
	end)
end

function EVENT:Condition()
	local isDetective = false
	if player.GetCount() < GetConVar("ttt_detective_min_players"):GetInt() then
		isDetective = true
	end
	return isDetective
end

Randomat:register(EVENT)