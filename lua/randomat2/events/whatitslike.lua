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
    local randomPly = table.Random(player.GetAll())
    -- and we use this to write "It's PLAYERNAME" (taken from suspicion.lua)
    Randomat:EventNotifySilent("What it's like to be " .. randomPly:Nick())
    -- The stats data is recorded from another mod, 'TTT Total Statistics'
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    local stats = util.JSONToTable(data)
    local chosenModel = randomPly:GetModel()
    local id = randomPly:SteamID()
    -- Get the chosen player's most bought detective/traitor weapon
    local detectiveStats = stats[id]["DetectiveEquipment"]
    local detectiveItemName = table.GetWinningKey(detectiveStats)
    local traitorStats = stats[id]["TraitorEquipment"]
    local traitorItemName = table.GetWinningKey(traitorStats)

    -- Give them their most bought weapon first
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

    for k, v in pairs(player.GetAll()) do
        if v:Alive() and not v:IsSpec() then
            -- bots do not have the following command, so it's unnecessary
            if (not v:IsBot()) then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                v:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
            timer.Simple(1, function()
                if not (v:GetViewOffset() == standardHeightVector) then
                    v:SetViewOffset(standardHeightVector)
                    v:SetViewOffsetDucked(standardCrouchedHeightVector)
                end

                -- Set player number K (in the table) to their respective model and set everyone to the chosen player's model
                playerModels[k] = v:GetModel()
                v:SetModel(chosenModel)

                if GetConVar("randomat_whatitslike_disguise"):GetBool() then
                    -- Remove names! Traitors still see names though!				
                    v:SetNWBool("disguised", true)
                end
            end)
        end
    end

    -- Sets someone's playermodel again when respawning, as force playermodel is off
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ply:SetModel(chosenModel)
        end)
    end)
end

function EVENT:End()
    for k, v in pairs(player.GetAll()) do
        if (playerModels[k] ~= nil) then
            v:SetModel(playerModels[k])
        end

        -- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
        v:ConCommand("cl_playermodel_selector_force 1")
        -- clear the model table to avoid setting wrong models (e.g. disconnected players)
        table.Empty(playerModels)
    end
end

function EVENT:Condition()
    -- Trigger when 'TTT Total Statistics' is installed
    return file.Exists("gamemodes/terrortown/entities/entities/ttt_total_statistics/init.lua", "THIRDPARTY")
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

Randomat:register(EVENT)