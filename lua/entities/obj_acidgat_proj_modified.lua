ENT.Base = "obj_acidgat_proj"

function ENT:Explosion()
	if CLIENT then return end
	ParticleEffect("acidgat_explode",self:GetPos(),Angle(0,0,0),nil)
	--ParticleEffect("slipgun_impact_pap",self:GetPos(),Angle(0,0,0),nil)
	self:EmitSound("weapons/blundergat/acidgat_explo-0"..math.random(1,4)..".mp3", 360, 100)
	util.ScreenShake(self.Entity:GetPos(), 1000, 255, 0.3, 500)
	local dmg = math.random(150, 2000)
	if self.Upgraded then
		dmg = math.random(1500, 7500)
	end
	self:Remove()
	for k,v in pairs(ents.FindInSphere(self.Entity:GetPos(),128)) do
		local ppos = v:GetPos()
		local dmginfo = DamageInfo()
			dmginfo:SetDamageType( DMG_ACID ) 
			dmginfo:SetInflictor(self.Entity)
			dmginfo:SetAttacker( self.Owner )
		if (v:IsPlayer() and hook.Run("PlayerShouldTakeDamage",v,self.Owner)) then
			dmginfo:SetDamage(1000)
			v:TakeDamageInfo(dmginfo)
			v:SetVelocity((self:GetPos()-ppos)*3)
		else
			if v:IsNPC() or v.Type == "nextbot" then
				dmginfo:SetDamage(dmg)
				v:TakeDamageInfo(dmginfo)
			else
				dmginfo:SetDamage(dmg)
				v:TakeDamageInfo(dmginfo)
			end
		end
	end
end   