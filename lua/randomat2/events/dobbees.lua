local EVENT = {}
util.AddNetworkString("RdmtSpecDobbeessBegin")
util.AddNetworkString("RdmtSpecDobbeessEnd")
EVENT.Title = "RISE FROM YOUR... Dobbees?"
EVENT.Description = "When you die, you come back as a T-Posing \"dobbee\""
EVENT.id = "dobbees"

EVENT.Categories = {"spectator", "entityspawn", "moderateimpact"}

local function SetSpectatorValues(p)
    local pos = p:GetPos()
    local ang = p:EyeAngles()
    p:Spectate(OBS_MODE_ROAMING)
    p:SpectateEntity(nil)
    p:SetPos(pos)
    p:SetEyeAngles(ang)
end

local engineSound = Sound("NPC_Manhack.EngineSound1")
local bladeSound = Sound("NPC_Manhack.BladeSound")
local bees = {}

local function CreateBee(p)
    local bee = ents.Create("prop_dynamic")
    bee:SetModel("models/models/konnie/dobby/dobby.mdl")
    bee:SetPos(p:GetPos())
    bee:SetNotSolid(true)
    bee:SetNWBool("RdmtSpecDobbees", true)
    bee:Spawn()
    bee:EmitSound(engineSound)
    bee:EmitSound(bladeSound)
    bees[p:SteamID64()] = bee
end

local dead = {}

local function SetupBee(p)
    -- Haunting phantoms and infecting parasites shouldn't be bees
    if p:GetNWBool("Haunting", false) or p:GetNWBool("Infecting", false) then return end
    dead[p:SteamID64()] = true
    SetSpectatorValues(p)
    CreateBee(p)
end

local function DestroyBee(b)
    b:StopSound(engineSound)
    b:StopSound(bladeSound)
    b:Remove()
end

local function StopBee(ply)
    if not IsValid(ply) then return end
    local sid = ply:SteamID64()
    dead[sid] = false

    if IsValid(bees[sid]) then
        DestroyBee(bees[sid])
    end

    bees[sid] = nil
    timer.Remove("RdmtSpecDobbeessStart_" .. sid)
end

function EVENT:Begin()
    bees = {}
    dead = {}
    net.Start("RdmtSpecDobbeessBegin")
    net.Broadcast()

    for _, p in ipairs(self:GetDeadPlayers()) do
        SetupBee(p)
    end

    self:AddHook("KeyPress", function(ply, key)
        if not IsValid(ply) then return end
        if ply.propspec then return end
        if dead[ply:SteamID64()] then return false end
    end)

    self:AddHook("PlayerSpawn", StopBee)
    self:AddHook("PlayerDisconnected", StopBee)

    self:AddHook("PlayerDeath", function(victim, entity, killer)
        if not IsValid(victim) then return end

        timer.Create("RdmtSpecDobbeessStart_" .. victim:SteamID64(), 1, 1, function()
            SetupBee(victim)
        end)
    end)

    self:AddHook("FinishMove", function(ply, mv)
        if not IsValid(ply) or not ply:IsSpec() then return end
        local bee = bees[ply:SteamID64()]
        if not IsValid(bee) then return end
        local ang = mv:GetAngles()
        bee:SetPos(mv:GetOrigin() + ang:Forward() * 20)
        bee:SetAngles(ang)
    end)
end

function EVENT:End()
    for _, b in pairs(bees) do
        if IsValid(b) then
            DestroyBee(b)
        end
    end

    for _, p in pairs(player.GetAll()) do
        timer.Remove("RdmtSpecDobbeessStart_" .. p:SteamID64())
    end

    table.Empty(bees)
    table.Empty(dead)
    net.Start("RdmtSpecDobbeessEnd")
    net.Broadcast()
end

function EVENT:Condition()
    return util.IsValidModel("models/models/konnie/dobby/dobby.mdl")
end

Randomat:register(EVENT)