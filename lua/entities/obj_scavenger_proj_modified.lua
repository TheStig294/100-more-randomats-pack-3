-- Editing only what's absolutely necessary to change the damage, and set an inflictor on this weapon
ENT.Base = "obj_scavenger_proj"

function ENT:Explosion()
    if CLIENT then return end

    if IsValid(self.Owner) and self.Owner:HasWeapon("tfa_scavenger") and self.Owner:GetWeapon("tfa_scavenger").Ispackapunched == 1 then
        self:EmitSound("weapons/ubersniper/ubersniper_explode_pap.wav", 360, 100)
        ParticleEffect("ubersniper_pap_base", self:GetPos(), Angle(0, 0, 0), nil)
    else
        self:EmitSound("weapons/ubersniper/ubersniper_explode.wav", 360, 100)
        ParticleEffect("ubersniper_explosion_base", self:GetPos(), Angle(0, 0, 0), nil)
    end

    util.ScreenShake(self.Entity:GetPos(), 1000, 255, 0.3, 500)
    self:Remove()

    for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), 256)) do
        local ppos = v:GetPos()
        local dmginfo = DamageInfo()

        if (v:IsPlayer() and hook.Run("PlayerShouldTakeDamage", v, self.Owner)) then
            dmginfo:SetDamage(1000)
            dmginfo:SetDamageType(DMG_BLAST)
            dmginfo:SetInflictor(self.Entity)
            dmginfo:SetAttacker(self.Owner)
            v:TakeDamageInfo(dmginfo)

            if string.find(v:GetClass(), "romero") then
                v:TakeDamage(v.health / 15, self.Owner, self.Weapon)
            end
        else
            v:TakeDamage(1000, self.Owner, self.Entity)
        end
    end
end