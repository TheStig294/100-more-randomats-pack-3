local EVENT = {}

EVENT.Title = "Gotta buy 'em all!"
EVENT.Description = "Gives a weapon you haven't bought, or reward for buying them all!"
EVENT.id = "buyemall"

buyEmAllTriggeredOnce = false

function EVENT:Begin()
	buyEmAllTriggeredOnce = true
	
	local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
	if data == nil then
		timer.Simple(5, function()
			EVENT:SmallNotify("[TTT] Total Statistics not installed... Randomat can't trigger")
		end)
		return
	else
		stats = util.JSONToTable(data)
	end
	
	local detectiveBuyableKeyed = GetDetectiveBuyable()
	local traitorBuyableKeyed = GetTraitorBuyable()
	local boughtEmAllPlayers = {}
	local detectiveBuyable = table.ClearKeys(detectiveBuyableKeyed)
	local traitorBuyable = table.ClearKeys(traitorBuyableKeyed)
	
	for i, ply in pairs(player.GetAll()) do
		timer.Simple(0.1, function()
			id = ply:SteamID()
			nickname = ply:Nick()
			
			detectiveStats = stats[id]["DetectiveEquipment"]
			traitorStats = stats[id]["TraitorEquipment"]
			detectiveBought = table.GetKeys(detectiveStats)
			traitorBought = table.GetKeys(traitorStats)
			
			detectiveBuyableCount = #detectiveBuyable
			traitorBuyableCount = #traitorBuyable
			
			for k = 1, #detectiveBought do
				table.RemoveByValue(detectiveBuyable, detectiveBought[k])
			end
			
			for k = 1, #traitorBought do
				table.RemoveByValue(traitorBuyable, traitorBought[k])
			end
			
			boughtAllTraitor = false
			boughtAllDetective = false
			if table.IsEmpty(traitorBuyable)then
				ply:ChatPrint("Congrats! You have bought every traitor item, your health has been doubled!")
				ply:SetMaxHealth(ply:GetMaxHealth() * 2)
				ply:SetHealth(ply:GetMaxHealth())
			else
				PrintToGive(traitorBuyable[ math.random( #traitorBuyable ) ], ply)
				ply:ChatPrint("You haven't bought every traitor item at least once. \n(" .. math.Round((#traitorBought / traitorBuyableCount) * 100) .. "% complete)")
			end
			
			if table.IsEmpty(detectiveBuyable)then
				ply:ChatPrint("Congrats! You have bought every detective item, your health has been doubled!")
				ply:SetMaxHealth(ply:GetMaxHealth() * 2)
				ply:SetHealth(ply:GetMaxHealth())
			else
				PrintToGive(detectiveBuyable[ math.random( #detectiveBuyable ) ], ply)
				ply:ChatPrint("You haven't bought every detective item at least once. \n(" .. math.Round((#detectiveBought / detectiveBuyableCount) * 100) .. "% complete)")
			end
			
			if boughtAllTraitor and boughtAllDetective then
				ply:ChatPrint("Congrats! You bought em all! You get to choose every randomat until the next map! \n(Unless you have to take turns with anyone else that has bought em all)")
				table.insert(boughtEmAllPlayers, ply)
			end
		end)
	end
	
	if table.IsEmpty(boughtEmAllPlayers) == false then
		hook.Add("TTTEndRound", "BoughtEmAllRandomatOn", function()
			GetConVar("ttt_randomat_auto"):SetBool(true)
			GetConVar("randomat_choose_vote"):SetBool(true)
		end)
		hook.Add("TTTPrepareRound", "BoughtEmAllRandomatOff", function()
			GetConVar("ttt_randomat_auto"):SetBool(false)
			GetConVar("randomat_choose_vote"):SetBool(false)
		end)
		hook.Add("TTTBeginRound", "BoughtEmAllRandomat", function()
			Randomat:TriggerEvent("choose", table.Random(boughtEmAllPlayers))
		end)
	end
end

function EVENT:Condition()
    if triggeredOnce then return false end
end

Randomat:register(EVENT)