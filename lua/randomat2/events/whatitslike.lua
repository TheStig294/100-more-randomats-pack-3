local EVENT = {}
util.AddNetworkString("WhatItsLikeRandomatHideNames")
util.AddNetworkString("WhatItsLikeRandomatEnd")
EVENT.Title = ""
EVENT.id = "whatitslike"
EVENT.Description = "Everyone gets someone's playermodel and favourite traitor + detective weapon"
EVENT.AltTitle = "What it's like to be ..."

CreateConVar("randomat_whatitslike_disguise", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Hide player names")

function EVENT:Begin()
    local randomPly = table.Random(player.GetAll())
    -- and we use this to write "It's PLAYERNAME" (taken from suspicion.lua)
    Randomat:EventNotifySilent("What it's like to be " .. randomPly:Nick())
    -- The stats data is recorded from another mod, 'TTT Total Statistics'
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    local stats = util.JSONToTable(data)
    local chosenModel = randomPly:GetModel()
    local chosenViewOffset = randomPly:GetViewOffset()
    local chosenViewOffsetDucked = randomPly:GetViewOffsetDucked()
    local id = randomPly:SteamID()
    -- Get the chosen player's most bought detective/traitor weapon
    local detectiveStats = stats[id]["DetectiveEquipment"]
    local detectiveItemName = table.GetWinningKey(detectiveStats)
    local traitorStats = stats[id]["TraitorEquipment"]
    local traitorItemName = table.GetWinningKey(traitorStats)

    -- Give them their most bought weapon first
    for i, ply in pairs(self:GetAlivePlayers()) do
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

    for k, ply in pairs(player.GetAll()) do
        ForceSetPlayermodel(ply, chosenModel, chosenViewOffset, chosenViewOffsetDucked)

        -- if name disguising is enabled...
        if not CR_VERSION and GetConVar("randomat_whatitslike_disguise"):GetBool() then
            -- Remove their names! Traitors still see names though!				
            ply:SetNWBool("disguised", true)
        end
    end

    if CR_VERSION and GetConVar("randomat_whatitslike_disguise"):GetBool() then
        net.Start("WhatItsLikeRandomatHideNames")
        net.Broadcast()
    end

    -- Sets someone's playermodel again when respawning
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ForceSetPlayermodel(ply, chosenModel, chosenViewOffset, chosenViewOffsetDucked)

            if not CR_VERSION and GetConVar("randomat_whatitslike_disguise"):GetBool() then
                ply:SetNWBool("disguised", true)
            end
        end)
    end)
end

function EVENT:End()
    ForceResetAllPlayermodels()

    if CR_VERSION then
        net.Start("WhatItsLikeRandomatEnd")
        net.Broadcast()
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

    return {}, checks
end

Randomat:register(EVENT)