CreateConVar("randomat_snailtime_health", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Player health as a snail", 1, 100)

local EVENT = {}
EVENT.Title = "Snail Time!"
EVENT.Description = "Everyone is transformed a snail and set to " .. GetConVar("randomat_snailtime_health"):GetInt() .. " health"
EVENT.id = "snailtime"

local snailModels = {"models/TSBB/Animals/Snail.mdl", "models/TSBB/Animals/Snail2.mdl", "models/TSBB/Animals/Snail3.mdl"}

local snailTimeTriggered = false
local maxHealth = {}

function EVENT:Begin()
    snailTimeTriggered = true
    self.Description = "Everyone is transformed a snail and set to " .. GetConVar("randomat_snailtime_health"):GetInt() .. " health"
    local hp = GetConVar("randomat_snailtime_health"):GetFloat()
    local sc = 0.1 -- player scale factor
    local sp = 0.5 -- player speed factor
    local playerModels = {}
    maxHealth = {}

    for k, ply in pairs(player.GetAll()) do
        local snailModel = snailModels[math.random(1, #snailModels)]
        playerModels[ply] = snailModel
        maxHealth[ply] = ply:GetMaxHealth()
        ForceSetPlayermodel(ply, snailModel)
    end

    -- Caps player HP
    timer.Create("RdmtSnailsHp", 1, 0, function()
        for _, ply in ipairs(self:GetAlivePlayers()) do
            if ply:Health() > math.floor(hp) then
                ply:SetHealth(math.floor(hp))
            end

            ply:SetMaxHealth(math.floor(hp))
        end
    end)

    -- Scales the player speed on clients
    for k, ply in pairs(player.GetAll()) do
        net.Start("RdmtSetSpeedMultiplier")
        net.WriteFloat(sp)
        net.WriteString("RdmtSnailsSpeed")
        net.Send(ply)
    end

    -- Scales the player speed on the server
    self:AddHook("TTTSpeedMultiplier", function(ply, mults)
        if not ply:Alive() or ply:IsSpec() then return end
        table.insert(mults, sp)
    end)

    -- Sets a player's model to a snail if they respawn
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            if playerModels[ply] then
                ForceSetPlayermodel(ply, playerModels[ply])
            end
        end)
    end)

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
    if snailTimeTriggered then
        snailTimeTriggered = false
        ForceResetAllPlayermodels()
        hook.Remove("Think", "SnailTimeThink")
        timer.Remove("RdmtSnailsHp")
        -- Reset the player speed on the client
        net.Start("RdmtRemoveSpeedMultiplier")
        net.WriteString("RdmtSnailsSpeed")
        net.Broadcast()

        -- Resetting player hitbox, ability to climb stairs...
        for _, ply in pairs(player.GetAll()) do
            ply:ResetHull()
            ply:SetStepSize(18)
            ply:DrawWorldModel(true)

            if maxHealth[ply] then
                ply:SetMaxHealth(maxHealth[ply])
                ply:SetHealth(maxHealth[ply])
            end
        end
    end
end

function EVENT:Condition()
    local modelsExist = true

    for i, model in ipairs(snailModels) do
        if not util.IsValidModel(model) then
            modelsExist = false
            break
        end
    end

    return modelsExist
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"health"}) do
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