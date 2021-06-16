-- the normal viewmodel offsets a playermodel's view is
local standardHeightVector = Vector(0, 0, 64)
local standardCrouchedHeightVector = Vector(0, 0, 28)

local playerModels = {}

local EVENT = {}

EVENT.Title = ""
EVENT.id = "whatitslike"
EVENT.Description = "Everyone gets someone's playermodel and favourite traitor + detective weapon"
EVENT.AltTitle = "What it's like to be ..."

CreateConVar("randomat_whatitslike_disguise", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Player names hidden when randomat is active.")


function EVENT:Begin()
	randomatWhatItsLikeSetPlayerLikeness()
end

function randomatWhatItsLikeSetPlayerLikeness()
	
	-- We chose a random player out of all players (thanks google)
	--local randomPly = Entity(1)
	local randomPly = table.Random(player.GetAll())
	
	-- Now we save that player's model like this...
	local chosenModel = randomPly:GetModel()
	
	-- and we use this to write "It's PLAYERNAME" (taken from suspicion.lua)
	Randomat:EventNotifySilent("What it's like to be " .. randomPly:Nick())
	
	local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
	if data == nil then
		timer.Simple(5, function()
			EVENT:SmallNotify("[TTT] Total Statistics not installed... Randomat can't trigger")
		end)
		return
	else
		stats = util.JSONToTable(data)
	end
	
	id = randomPly:SteamID()
	
	detectiveStats = stats[id]["DetectiveEquipment"]
	detectiveItemName = table.GetWinningKey(detectiveStats)
	
	
	traitorStats = stats[id]["TraitorEquipment"]
	traitorItemName = table.GetWinningKey(traitorStats)
	
	for i, ply in pairs(EVENT:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			if detectiveStats[detectiveItemName] >= traitorStats[traitorItemName] then
				PrintToGive(detectiveItemName, ply)
				PrintToGive(traitorItemName, ply)
			else
				PrintToGive(traitorItemName, ply)
				PrintToGive(detectiveItemName, ply)
			end
		end)
	end
	
	-- Gets all players...
	for k, v in pairs(player.GetAll()) do
		-- if they're alive and not in spectator mode
		if v:Alive() and not v:IsSpec() then
			-- and not a bot (bots do not have the following command, so it's unnecessary)
			if(!v:IsBot()) then
				-- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
				v:ConCommand("cl_playermodel_selector_force 0")
			end

			-- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
			timer.Simple(1, function()
				
				-- if the player's viewoffset is different than the standard, then...
				if !(v:GetViewOffset() == standardHeightVector) then
						
						-- So we set their new heights to the default values (which the Duncan model uses)
						v:SetViewOffset(standardHeightVector)
						v:SetViewOffsetDucked(standardCrouchedHeightVector)
				end
				
				-- Set player number K (in the table) to their respective model
				playerModels[k] = v:GetModel()

				-- Sets their model to chosenModel
				v:SetModel(chosenModel)
				
				-- if name disguising is enabled...
				if GetConVar("randomat_whatitslike_disguise"):GetBool() then
				
					-- Remove their names! Traitors still see names though!				
					v:SetNWBool("disguised", true)
				end
			end)
		end
	end
end

-- when the event ends, reset every player's model
function EVENT:End()
	-- loop through all players
	for k, v in pairs(player.GetAll()) do
		-- if the index k in the table playermodels has a model, then...
		if (playerModels[k] != nil) then
		
			-- we set the player v to the playermodel with index k in the table
			-- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
			-- this does however first reset their viewmodel in the preparing phase (when they respawn)
			-- might be glitchy with pointshop items that allow you to get a viewoffset
			v:SetModel(playerModels[k])
		end
		
		
		-- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
		v:ConCommand("cl_playermodel_selector_force 1")
		
		-- clear the model table to avoid setting wrong models (e.g. disconnected players)
		table.Empty(playerModels)
	end
	
	
end

function EVENT:GetConVars()
    local checks = {}
    for _, v in pairs({"disguise"}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return checks
end

-- register the event in the randomat!
Randomat:register(EVENT)