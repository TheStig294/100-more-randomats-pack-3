-- For some reason, although all of these functions has the ability to pass an inflictor though them, this weapon never set one.
-- This has been modified to pass the inflictor though all of the functions this weapon goes through, before the player finally takes the damage
-- This allows this weapon to respect roles such as the jester winning on dying, or the phantom haunting the attacking player
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
util.AddNetworkString("FreezeSWEP")
local mat = "effects/freeze_overlayeffect01"
local FreezeColor = Color(100, 150, 255)
local dmgtype = bit.bor(DMG_GENERIC, DMG_REMOVENORAGDOLL)

local function unfreeze(ent, kill, inf, stack)
    ent:SetMaterial(ent.m_Material)

    if ent:IsPlayer() then
        ent:Freeze(false)
        net.Start("FreezeSWEP")
        net.WriteUInt(0, 1)
        net.WriteUInt(1, 1)
        net.Send(ent)
    elseif ent:IsNPC() then
        ent:SetSchedule(SCHED_WAKE_ANGRY)
    elseif ent.Type == "nextbot" then
        ent.BehaveUpdate = ent.m_BehaveUpdate
        ent.m_BehaveUpdate = nil
    end

    local effectdata = EffectData()
    effectdata:SetOrigin(ent:LocalToWorld(ent:OBBCenter()))
    local scale = 4 + math.Rand(-0.25, 1.25)
    local po = ent:GetPhysicsObject()

    if IsValid(po) then
        scale = scale + po:GetMass() * 0.001
    end

    effectdata:SetScale(scale)
    effectdata:SetMagnitude(2)
    util.Effect("GlassImpact", effectdata, true, true)
    local d = DamageInfo()

    if stack then
        ent.m_Freeze = false
    end

    if IsValid(kill) and kill:Health() > 0 then
        d:SetDamage(ent:Health() + 1)
        d:SetAttacker(kill)
        d:SetInflictor(inf)
        d:SetDamageType(dmgtype)
        ent:TakeDamageInfo(d)
        ent.m_Freeze = false
    else
        if kill:Health() <= 0 then
            local b = DamageInfo()
            b:SetDamage(ent:Health() + 1)
            b:SetAttacker(ent)
            b:SetInflictor(inf)
            ent:TakeDamageInfo(b)
        end
    end
end

local UnFreeze = {}
local pairs, IsValid, CurTime = pairs, IsValid, CurTime

hook.Add("Tick", "UnfreezeEnts", function()
    for k, v in pairs(UnFreeze) do
        if not IsValid(k) then
            UnFreeze[k] = nil
        elseif v[1] <= CurTime() then
            unfreeze(k, v[2], v[3])
        end
    end
end)

hook.Add("CreateEntityRagdoll", "FreezeRagdollRemove", function(ent, rag)
    if IsValid(ent) and ent.m_Freeze then
        rag:Remove()
    end
end)

hook.Add("PostPlayerDeath", "FreezeRagdollRemovePlayer", function(ply)
    if ply.m_Freeze then
        local rag = ply:GetRagdollEntity()

        if IsValid(rag) then
            rag:Remove()
        end
    end
end)

local function_origin, world = function() end, Entity(0)

hook.Add("EntityTakeDamage", "DealWithDamage", function(ent, dmg)
    if ent.m_Freeze then
        dmg:ScaleDamage(math.Rand(1.5, 2.25))

        if dmg:GetDamage() > ent:Health() then
            dmg:ScaleDamage(100)
            local effectdata = EffectData()
            effectdata:SetOrigin(ent:LocalToWorld(ent:OBBCenter()))
            local force = dmg:GetDamageForce()
            effectdata:SetNormal(force:GetNormalized())
            effectdata:SetEntity(ent)
            effectdata:SetDamageType(dmgtype)
            local scale, po = 1, ent:GetPhysicsObject()

            if IsValid(po) then
                scale = scale + po:GetMass() / 50
            end

            local tb = UnFreeze[ent]

            if tb then
                unfreeze(ent, tb[2], tb[3], true)
            else
                unfreeze(ent, world, world, true)
            end

            UnFreeze[ent] = nil
            effectdata:SetScale(scale)

            local randomsounds1 = {Sound("weapons/shatter.wav"), Sound("weapons/shatter1.wav"), Sound("weapons/shatter3.wav")}

            local randomSound1 = table.Random(randomsounds1)
            ent:EmitSound(randomSound1)

            if not ent:IsPlayer() then
                net.Start("FreezeSWEP")
                net.WriteUInt(1, 1)
                net.WriteUInt(ent:EntIndex(), 16)
                net.Broadcast()
            end
        end
    end
end)

local behaveupdate = function(self)
    self:SetPlaybackRate(0.25)
end

function SWEP:FreezeFunc(ent, kil, inf, type)
    UnFreeze[ent] = {CurTime() + math.random(3, 5), kil, inf}

    if ent.m_Freeze then return end

    if type == 0 then
        ent:Freeze(true)
        net.Start("FreezeSWEP")
        net.WriteUInt(0, 1)
        net.WriteUInt(0, 1)
        net.Send(ent)
    elseif type == 1 then
        ent:StopMoving()
        ent:SetSchedule(SCHED_NPC_FREEZE)
    elseif type == 2 then
        ent.m_BehaveUpdate = ent.BehaveUpdate
        ent.BehaveUpdate = behaveupdate
    end

    ent.m_Material = ent:GetMaterial()
    ent:SetMaterial(mat)

    local randomSound2 = {Sound("weapons/freeze0.wav"), Sound("weapons/freeze1.wav"), Sound("weapons/freeze2.wav")}

    local randomSound2 = table.Random(randomSound2)
    ent:EmitSound(randomSound2)
    ent.m_Freeze = true
end

function SWEP:FreezeObject(ent, kil, inf)
    if ent:IsNPC() then
        ent:SetPlaybackRate(0.25)

        if ent:Health() < 25 then
            self:FreezeFunc(ent, kil, inf, 1)
        end
    end

    if ent:IsPlayer() then
        ent:SetRunSpeed(25)

        timer.Simple(3, function()
            ent:SetRunSpeed(100)
        end)

        if ent:Health() < 75 then
            self:FreezeFunc(ent, kil, inf, 0)
        end
    elseif ent.Type == "nextbot" then
        ent.loco:SetDesiredSpeed(25)

        if ent:Health() < 75 then
            self:FreezeFunc(ent, kil, inf, 2)
        else
            return
        end
    end
end

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Think2()
    BaseClass.Think2(self)
    local pos = self.Owner:GetPos()

    for k, v in pairs(ents.FindInSphere(pos, 20)) do
        if v.Type == "nextbot" and v.m_Freeze then
            local freezedmg = DamageInfo()
            freezedmg:SetDamage(v:Health())
            freezedmg:SetDamageType(DMG_BULLET)
            freezedmg:SetAttacker(self.Owner)
            v:TakeDamageInfo(freezedmg)
        end
    end
end