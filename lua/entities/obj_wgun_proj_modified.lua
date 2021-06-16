ENT.Base = "obj_wgun_proj"

function ENT:OnCollide(ent, hitpos)
    if self.DoRemove then return end
    if self.Owner == ent then return true end
    self.DoRemove = true
    self.Effect:SetParent(NULL)
    SafeRemoveEntityDelayed(self.Effect, 1)
    self.Effect:Fire("Stop")
    self.Effect:Fire("Kill")
    self:PhysicsDestroy()
    SafeRemoveEntityDelayed(self, 0)
    self:NextThink(CurTime())
    local d = DamageInfo()
    d:SetDamage(40)
    d:SetAttacker(self.Owner)
    d:SetInflictor(self)
    d:SetDamageType(DMG_SHOCK)

    if ent ~= self.Owner then
        ent:TakeDamageInfo(d)
    end

    ParticleEffect(self.CollidePCF, hitpos, self:GetAngles())
    self:EmitSound(self.CollideSND)

    return true
end