if (CLIENT) then
	SWEP.PrintName			= "Spin Attack"
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= false
    SWEP.Icon = "vgui/ttt/icon_spinattack.png"
    SWEP.EquipMenuData = { type = "Weapon", desc = "Click to spin attack." };
end

if (SERVER) then
    resource.AddFile('materials/vgui/ttt/icon_spinattack.png')
    AddCSLuaFile("shared.lua")
    SWEP.Weight             = 5
    SWEP.AutoSwitchTo       = false
    SWEP.AutoSwitchFrom     = false
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1
SWEP.AutoSpawnable = false
SWEP.InLoudableFor = nil
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.HoldType = "normal"

SWEP.Author		= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Click to spin attack"

SWEP.SlotPos = 1

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Spinning = 0

function SWEP:Initialize()
end

function SWEP:Think()
	if (self.Spinning == 1) and (self.StopSpining == 0) then
		self.Owner:SetEyeAngles(Angle(0,self.Owner:EyeAngles().y + 20,0))
		for i, ply in pairs(player.GetAll()) do
			if (self.Owner:GetPos():DistToSqr(ply:GetPos()) < (200*200)) and (ply ~= self.Owner) and ply:Alive() and not ply:IsSpec()  then
				ply:TakeDamage(5, self.Owner, self.Weapon)
			end
		end
	end
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	if SERVER then 
		self.Owner:EmitSound(Sound("whoa/whoa.wav")) 
	end
	
	self.StopSpining = 0
	self.Spinning = 1
	timer.Simple(0.5, function()
		self.StopSpining = 1
	end)
end

function SWEP:Holster()
         return true
end

function SWEP:Deploy()
   self:GetOwner():DrawWorldModel(false)
   self:DrawShadow(false)
   return true
end

function SWEP:DrawHUD()
end

function SWEP:ShouldDrawViewModel()
	return false
end

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:ShouldDropOnDie()
   return false
end