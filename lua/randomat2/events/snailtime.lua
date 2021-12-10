local standardHeightVector = Vector(0, 0, 64)
local standardCrouchedHeightVector = Vector(0, 0, 28)
local playerModels = {}

local snailModels = {"models/TSBB/Animals/Snail.mdl", "models/TSBB/Animals/Snail2.mdl", "models/TSBB/Animals/Snail3.mdl"}

local EVENT = {}

CreateConVar("randomat_snailtime_health", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Player health as a snail", 1, 100)

EVENT.Title = "Snail Time!"
EVENT.Description = "Everyone is transformed a snail and set to 1 health"
EVENT.id = "snailtime"
local snaitTimeTriggered = false

function EVENT:Begin()
    snaitTimeTriggered = true
    local hp = GetConVar("randomat_snailtime_health"):GetFloat()

    -- Gets all players...
    for k, v in pairs(player.GetAll()) do
        -- if they're alive and not in spectator mode
        if v:Alive() and not v:IsSpec() then
            -- and not a bot (bots do not have the following command, so it's unnecessary)
            if (not v:IsBot()) then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                v:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
            timer.Simple(0.1, function()
                -- Set player number K (in the table) to their respective model
                playerModels[k] = v:GetModel()
                -- Sets their model to chosenModel
                v:SetModel(table.Random(snailModels))
                local oldmax = v:GetMaxHealth()
                v:SetMaxHealth(hp)
                v:SetHealth(math.Clamp(hp * v:Health() / oldmax, 1, hp))
                v:SetWalkSpeed(100)
                initialRunSpeed = v:GetRunSpeed()
                v:SetRunSpeed(100)
            end)
        end
    end

    local sc = 0.1 --scale factor

    hook.Add("Think", "SnailTimeThink", function()
        for k, ply in pairs(player.GetAll()) do
            ply:SetStepSize(18 * sc)
            ply:SetViewOffset(Vector(0, 0, 64) * sc)
            ply:SetViewOffsetDucked(Vector(0, 0, 32) * sc)
            ply:SetHull(Vector(-16, -16, 0) * sc * 3, Vector(16, 16, 72) * sc * 3)
            ply:SetHullDuck(Vector(-16, -16, 0) * sc * 3, Vector(16, 16, 36) * sc * 3)
            ply:DrawWorldModel(false)
        end
    end)
end

-- when the event ends, reset every player's model
function EVENT:End()
    if snaitTimeTriggered then
        snaitTimeTriggered = false
        hook.Remove("Think", "SnailTimeThink")

        -- loop through all players
        for k, v in pairs(player.GetAll()) do
            -- if the index k in the table playermodels has a model, then...
            if (playerModels[k] ~= nil) then
                -- we set the player v to the playermodel with index k in the table
                -- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
                -- this does however first reset their viewmodel in the preparing phase (when they respawn)
                -- might be glitchy with pointshop items that allow you to get a viewoffset
                v:SetModel(playerModels[k])
            end

            -- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
            v:ConCommand("cl_playermodel_selector_force 1")
            v:DrawWorldModel(true)
            v:SetWalkSpeed(200)
            v:SetRunSpeed(initialRunSpeed)
            -- clear the model table to avoid setting wrong models (e.g. disconnected players)
            table.Empty(playerModels)
        end

        hook.Add("TTTPrepareRound", "SnailRandomatFix", function()
            for k, ply in pairs(player.GetAll()) do
                ply:SetModelScale(1, 0)
                ply:SetViewOffset(Vector(0, 0, 64))
                ply:SetViewOffsetDucked(Vector(0, 0, 32))
                ply:ResetHull()
                ply:SetStepSize(18)
            end

            hook.Remove("TTTPrepareRound", "SnailRandomatFix")
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_ttt_killersnail") ~= nil
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"time"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

-- register the event in the randomat!
Randomat:register(EVENT)