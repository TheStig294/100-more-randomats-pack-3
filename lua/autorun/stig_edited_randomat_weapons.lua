if engine.ActiveGamemode() == "terrortown" then
    -- Moves the TFA inspect key off of 'C' to not be annoying when opening the buy menu
    if SERVER then
        RunConsoleCommand("sv_tfa_cmenu_key", "21")
    end

    -- Edits all weapons randomats use to be compatible with TTT, if they are installed
    hook.Add("PreRegisterSWEP", "StigRandomatModifiedWeaponsHook", function(SWEP, class)
        if class == "republic_mcbow" then
            SWEP.Base = "weapon_tttbase"
            SWEP.Kind = GenerateNewEquipmentID()
            SWEP.InLoadoutFor = nil
            SWEP.LimitedStock = true
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6
            SWEP.SlotPos = 2
            SWEP.AllowDrop = true

            if CLIENT then
                SWEP.Icon = "materials/entities/ttt_mc_weapon_bow.png"

                SWEP.EquipMenuData = {
                    type = "Weapon",
                    desc = "Become your inner skeleton sniper."
                }
            end
        end

        if class == "minecraft_swep" then
            SWEP.Base = "weapon_tttbase"
            SWEP.Kind = GenerateNewEquipmentID()
            SWEP.InLoadoutFor = nil
            SWEP.LimitedStock = true
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6
            SWEP.SlotPos = 2
            SWEP.AllowDrop = false

            if CLIENT then
                SWEP.PrintName = "Minecraft Block"
                SWEP.Icon = "materials/entities/ttt_minecraft_swep.png"

                SWEP.EquipMenuData = {
                    type = "Weapon",
                    desc = "Place Minecraft blocks! \nPress 'R' to change blocks"
                }
            end

            function SWEP:OnDrop()
                self:Remove()
            end

            function SWEP:ShouldDropOnDie()
                return false
            end
        end

        if class == "weapon_unoreverse" then
            SWEP.Base = "weapon_tttbase"
            SWEP.Kind = GenerateNewEquipmentID()
            SWEP.InLoadoutFor = nil
            SWEP.LimitedStock = true
            SWEP.AutoSpawnable = false
            SWEP.AllowDrop = false

            if CLIENT then
                SWEP.Icon = "vgui/ttt/ttt_uno_reverse.png"

                SWEP.EquipMenuData = {
                    type = "Weapon",
                    desc = "Reflects ALL DAMAGE while held. \nUseable for 3 seconds."
                }
            end

            CreateConVar("ttt_uno_reverse_length", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How many seconds the uno reverse lasts", 0.01)

            hook.Add("TTTEndRound", "StopUnoRemoveHook", function()
                stop_uno_remove = true
            end)

            function SWEP:Deploy()
                stop_uno_remove = false

                if SERVER then
                    timer.Simple(GetConVar("ttt_uno_reverse_length"):GetFloat(), function()
                        if stop_uno_remove == false then
                            self:Remove()
                        end
                    end)
                end

                local deploy_sound = Sound("uno/deflect.wav")

                timer.Simple(0.1, function()
                    if self:IsWeaponVisible() then
                        for i, ply in pairs(player.GetAll()) do
                            ply:EmitSound(deploy_sound)
                        end
                    end
                end)

                self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
                self.Owner:SetNWBool("HasUNOReverse", true)
                self.Owner:SetNWEntity("UNOReverseSwepEnt", self)

                return true
            end
        end
    end)
    -- if class == "tfa_wunderwaffe" then
    --     CreateConVar("ttt_wunderwaffe_ammo", "4", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the wunderwaffe", 0)
    --     CreateConVar("ttt_wunderwaffe_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the wunderwaffe", 0)
    --     -- CreateConVar("ttt_wunderwaffe_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the wunderwaffe", 0, 1)
    --     -- CreateConVar("ttt_wunderwaffe_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the wunderwaffe", 0, 1)
    --     -- CreateConVar("ttt_wunderwaffe_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the wunderwaffe", 0, 1)
    --     -- if GetConVar("ttt_wunderwaffe_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_wunderwaffe_detective"):GetBool() and GetConVar("ttt_wunderwaffe_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_wunderwaffe_detective"):GetBool() == false and GetConVar("ttt_wunderwaffe_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_wunderwaffe_detective"):GetBool() and GetConVar("ttt_wunderwaffe_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_wunderwaffe_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_wunderwaffe_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Powerful lightning rifle that kills in 1 shot! \n\nWatch out for the recoil damage if you shoot it too close!"
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("WUNDERWAFFE DG-2: Shoots a bolt of lightning that one-shot kills!")
    --     end
    -- end
    -- if class == "tfa_wavegun" then
    --     CreateConVar("ttt_wavegun_ammo", "20", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the wavegun", 0)
    --     CreateConVar("ttt_wavegun_clip", "16", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the wavegun", 0)
    --     -- CreateConVar("ttt_wavegun_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the wavegun", 0, 1)
    --     -- CreateConVar("ttt_wavegun_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the wavegun", 0, 1)
    --     -- CreateConVar("ttt_wavegun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the wavegun", 0, 1)
    --     -- if GetConVar("ttt_wavegun_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_wavegun_detective"):GetBool() and GetConVar("ttt_wavegun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_wavegun_detective"):GetBool() == false and GetConVar("ttt_wavegun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_wavegun_detective"):GetBool() and GetConVar("ttt_wavegun_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_wavegun_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_wavegun_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Duel-wield, high-damage laser guns!"
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     SWEP.SlotPos = 2
    --     SWEP.Secondary.DefaultClip = 0
    --     SWEP.Primary.RPM = 125
    --     SWEP.PrintName = "Zap Guns"
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("ZAP GUNS: Duel-wield laser guns, press left or right click to shoot!")
    --     end
    --     function SWEP:FireRocket()
    --         local vm = self:GetOwner():GetViewModel()
    --         local own = self:GetOwner()
    --         local ShotsLeft = self:GetNWInt("ShotsLeft")
    --         if self:GetNWString("dw_state") == "dw" then
    --             if self:Ammo1() == 0 then
    --                 self.ReserveEmpty = true
    --             end
    --             if self:Clip1() == 1 and self.ReserveEmpty then
    --                 self.PrimaryEmpty = true
    --             end
    --             self.OldClip1 = self:Clip1() - 1
    --         end
    --         if SERVER then
    --             if self:GetNWString("dw_state") == "combined" then
    --                 if self:Clip2() == 0 then
    --                     timer.Simple(0.2, function()
    --                         self:Reload()
    --                     end)
    --                     return
    --                 end
    --                 local ang = self:GetOwner():EyeAngles()
    --                 local pos = self:GetOwner():GetShootPos() + self:GetOwner():GetUp() * -8 + self:GetOwner():GetRight() * 8
    --                 if self:GetIronSights() == false then
    --                     pos = self:GetOwner():GetShootPos() + self:GetOwner():GetUp() * -8 + self:GetOwner():GetRight() * 8
    --                 else
    --                     pos = self:GetOwner():GetShootPos() + self:GetOwner():GetUp() * -8
    --                 end
    --                 local orb1 = ents.Create("obj_wgun_proj2")
    --                 self:GetOwner():EmitSound("Weapon_Wavegun.Fire")
    --                 self.Weapon:TakeSecondaryAmmo(1)
    --                 self:GetOwner():ViewPunch(Angle(math.Rand(-0.5, -0.4) * 12, math.Rand(-1, 1), 0))
    --                 if self.Ispackapunched > 0 then
    --                     ParticleEffectAttach("wgun_muzzle_pap", PATTACH_POINT_FOLLOW, self:GetOwner():GetViewModel(), 2)
    --                 else
    --                     ParticleEffectAttach("wgun_muzzle", PATTACH_POINT_FOLLOW, self:GetOwner():GetViewModel(), 2)
    --                 end
    --                 orb1:SetPos(pos)
    --                 orb1:SetAngles(ang)
    --                 orb1.Owner = own
    --                 if self.Ispackapunched == 1 then
    --                     orb1.TrailPCF = "wgun_trail_child_pap"
    --                     orb1.CollidePCF = "wgun_impact_pap"
    --                 else
    --                     orb1.TrailPCF = "wgun1_trail_child"
    --                     orb1.CollidePCF = "wgun_impact"
    --                 end
    --                 orb1:Spawn()
    --                 orb1:Activate()
    --                 local phys = orb1:GetPhysicsObject()
    --                 if IsValid(phys) then
    --                     phys:ApplyForceCenter(self:GetOwner():GetAimVector() * 3500)
    --                 end
    --                 self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
    --                 self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    --                 self:GetOwner():MuzzleFlash()
    --             else
    --                 if ShotsLeft == self.Primary.ClipSize * 0.5 then
    --                     self:EmitSound("Weapon_IRifle.Empty")
    --                     return
    --                 end
    --                 self:GetOwner():EmitSound(self.Primary.Sound)
    --                 local pos = self:GetOwner():GetShootPos() + self:GetOwner():GetForward() * 4 + self:GetOwner():GetUp() * -2 + self:GetOwner():GetRight() * -8
    --                 local orb1 = ents.Create("obj_wgun_proj_modified")
    --                 self:GetOwner():ViewPunch(Angle(math.Rand(-0.5, -0.4), 0, 0))
    --                 self.Weapon:TakePrimaryAmmo(1)
    --                 self:SetNWInt("ShotsLeft", self:GetNWInt("ShotsLeft") + 1)
    --                 orb1:SetPos(pos)
    --                 orb1:SetAngles((self:GetOwner():GetEyeTrace().HitPos - pos):Angle())
    --                 orb1.Owner = own
    --                 if self.Ispackapunched == 1 then
    --                     orb1.TrailPCF = "zgun_trail1"
    --                     orb1.CollidePCF = "rgun1_impact_pap"
    --                 else
    --                     orb1.TrailPCF = "zgun_trail1"
    --                     orb1.CollidePCF = "rgun1_impact_pap"
    --                 end
    --                 orb1:Spawn()
    --                 orb1:Activate()
    --                 local phys = orb1:GetPhysicsObject()
    --                 if IsValid(phys) then
    --                     phys:ApplyForceCenter(self:GetOwner():GetAimVector() * 3500)
    --                 end
    --                 if self:GetIronSights() then
    --                     self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
    --                 else
    --                     self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    --                 end
    --                 self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    --                 self:GetOwner():MuzzleFlash()
    --                 ParticleEffectAttach("mwave_muzzleflash_l", PATTACH_POINT_FOLLOW, vm, 2)
    --             end
    --         end
    --     end
    --     function SWEP:FireRocket2()
    --         local ShotsRight = self:GetNWInt("ShotsRight")
    --         if ShotsRight == self.Primary.ClipSize * 0.5 then
    --             self:EmitSound("Weapon_IRifle.Empty")
    --             return
    --         end
    --         local own = self.Owner
    --         local vm = self.Owner:GetViewModel()
    --         local pos = self.Owner:GetShootPos() + self.Owner:GetForward() * 4 + self.Owner:GetUp() * -2 + self.Owner:GetRight() * 8
    --         local ply = player
    --         if self:GetNWString("dw_state") == "dw" then
    --             if self:Ammo1() == 0 then
    --                 self.ReserveEmpty = true
    --             end
    --             if self:Clip1() == 1 and self.ReserveEmpty then
    --                 self.PrimaryEmpty = true
    --             end
    --             self.OldClip1 = self:Clip1() - 1
    --             if SERVER then
    --                 local orb1 = ents.Create("obj_wgun_proj_modified")
    --                 orb1:SetPos(pos)
    --                 orb1:SetAngles((self.Owner:GetEyeTrace().HitPos - pos):Angle())
    --                 orb1.Owner = own
    --                 if self.Ispackapunched == 1 then
    --                     orb1.TrailPCF = "zgun_trail1"
    --                     orb1.CollidePCF = "rgun1_impact_pap"
    --                 else
    --                     orb1.TrailPCF = "zgun_trail1"
    --                     orb1.CollidePCF = "rgun1_impact_pap"
    --                 end
    --                 orb1:Spawn()
    --                 orb1:Activate()
    --                 local phys = orb1:GetPhysicsObject()
    --                 if IsValid(phys) then
    --                     phys:ApplyForceCenter(self.Owner:GetAimVector() * 3500)
    --                 end
    --             end
    --             self.Weapon:EmitSound(self.Primary.Sound)
    --             self.Weapon:TakePrimaryAmmo(1)
    --             self:SetNWInt("ShotsRight", self:GetNWInt("ShotsRight") + 1)
    --             self.Owner:ViewPunch(Angle(math.Rand(-0.5, -0.4), 0, 0))
    --             self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
    --             self.Owner:SetAnimation(PLAYER_ATTACK1)
    --             ParticleEffectAttach("mwave_muzzleflash_r", PATTACH_POINT_FOLLOW, vm, 1)
    --             --ParticleEffectAttach( "mwave_muzzleflash_r", PATTACH_POINT_FOLLOW, self, 1 )		
    --         end
    --     end
    -- end
    -- if class == "tfa_staff_wind" then
    --     CreateConVar("ttt_windstaff_ammo", "6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the windstaff", 0)
    --     CreateConVar("ttt_windstaff_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the windstaff", 0)
    --     -- CreateConVar("ttt_windstaff_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the windstaff", 0, 1)
    --     -- CreateConVar("ttt_windstaff_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the windstaff", 0, 1)
    --     -- CreateConVar("ttt_windstaff_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the windstaff", 0, 1)
    --     -- if GetConVar("ttt_windstaff_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_windstaff_detective"):GetBool() and GetConVar("ttt_windstaff_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_windstaff_detective"):GetBool() == false and GetConVar("ttt_windstaff_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_windstaff_detective"):GetBool() and GetConVar("ttt_windstaff_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_windstaff_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_windstaff_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shoots shot-range, high damage blasts of air!"
    --     }
    --     SWEP.AutoSpawnable = false
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("STAFF OF WIND: Shoots shot-range, high damage blasts of air!")
    --     end
    --     function SWEP:DoShot(ppos)
    --         if SERVER then
    --             local dummy = ents.Create("obj_windstaff_proj")
    --             dummy:SetPos(self:GetOwner():GetShootPos())
    --             dummy:SetAngles(self:GetOwner():EyeAngles())
    --             dummy:SetOwner(self:GetOwner())
    --             dummy:Spawn()
    --             dummy:Activate()
    --             for k, v in pairs(ents.FindInSphere(ppos, 200)) do
    --                 if v == self:GetOwner() then continue end
    --                 if gamemode.Get("nzombies") and v:IsPlayer() and hook.Run("PlayerShouldTakeDamage", v, self:GetOwner()) then return end
    --                 if gamemode.Get("sandbox") or gamemode.Get("terrortown") and v:IsPlayer() or v:IsNPC() then
    --                     local dmginfo = DamageInfo()
    --                     dmginfo:SetDamage(50)
    --                     dmginfo:SetDamageType(DMG_GENERIC)
    --                     dmginfo:SetAttacker(self:GetOwner())
    --                     dmginfo:SetInflictor(self)
    --                     dmginfo:SetDamageForce((self:GetOwner():GetForward() * 300000) + (self:GetOwner():GetUp() * 300000))
    --                     v:TakeDamageInfo(dmginfo)
    --                 elseif v.Type == "nextbot" then
    --                     local dmginfo2 = DamageInfo()
    --                     dmginfo2:SetDamage(50)
    --                     dmginfo2:SetDamageType(DMG_GENERIC)
    --                     dmginfo2:SetAttacker(self:GetOwner())
    --                     dmginfo2:SetDamageForce((self:GetOwner():GetForward() * 30000) + (self:GetOwner():GetUp() * 30000))
    --                     v:TakeDamageInfo(dmginfo2)
    --                 end
    --             end
    --         end
    --     end
    -- end
    -- if class == "tfa_shrinkray" then
    --     CreateConVar("ttt_shrinkray_ammo", "6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the shrinkray", 0)
    --     CreateConVar("ttt_shrinkray_clip", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the shrinkray", 0)
    --     -- CreateConVar("ttt_shrinkray_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the shrinkray", 0, 1)
    --     -- CreateConVar("ttt_shrinkray_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the shrinkray", 0, 1)
    --     -- CreateConVar("ttt_shrinkray_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the shrinkray", 0, 1)
    --     -- if GetConVar("ttt_shrinkray_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_shrinkray_detective"):GetBool() and GetConVar("ttt_shrinkray_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_shrinkray_detective"):GetBool() == false and GetConVar("ttt_shrinkray_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_shrinkray_detective"):GetBool() and GetConVar("ttt_shrinkray_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_shrinkray_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_shrinkray_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shrinks anyone in a close-range, \nand leaves them with 1 health. \n\nWalk into them to kick them far!"
    --     }
    --     SWEP.PrintName = "The Baby Maker"
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("THE BABY MAKER: Shoots an orb that shrinks anyone shot into a baby! Walking into them kicks them and kills them on landing.")
    --     end
    --     function SWEP:PrimaryAttack()
    --         if self:CanPrimaryAttack() then
    --             SetGlobalEntity("BabyMakerInflictor", self)
    --             self:EmitSound(self.Primary.Sound)
    --             local pos = self.Owner:GetShootPos() + self.Owner:GetForward() * 32
    --             if self.Ispackapunched == 1 then
    --                 ParticleEffectAttach("babygun_muzzle_pap", PATTACH_POINT_FOLLOW, self.Owner:GetViewModel(), 1)
    --                 ParticleEffect("babygun_muzzlesmoke_pap", pos, Angle(0, 0, 0), self.Owner)
    --             else
    --                 ParticleEffectAttach("babygun_muzzle", PATTACH_POINT_FOLLOW, self.Owner:GetViewModel(), 1)
    --                 ParticleEffect("babygun_muzzlesmoke", pos, Angle(0, 0, 0), self.Owner)
    --             end
    --             self.Owner:ViewPunch(Angle(math.Rand(-2, -1.6), 0, 0))
    --             self.Weapon:TakePrimaryAmmo(1)
    --             if SERVER then
    --                 local orb1 = ents.Create("obj_babygun_proj")
    --                 orb1:SetPos(pos)
    --                 orb1:SetAngles(self.Owner:EyeAngles())
    --                 orb1.Owner = self.Owner
    --                 if self.Ispackapunched == 1 then
    --                     orb1.ImpactPCF = "babygun_impact_pap"
    --                     orb1.TrailPCF = "babygun_proj_pap"
    --                     orb1.Timer = 15
    --                 else
    --                     orb1.ImpactPCF = "babygun_impact"
    --                     orb1.TrailPCF = "babygun_proj"
    --                     orb1.Timer = 5
    --                 end
    --                 orb1:Spawn()
    --                 orb1:Activate()
    --             end
    --             self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    --             self.Owner:SetAnimation(PLAYER_ATTACK1)
    --             self:SetNextPrimaryFire(CurTime() + 0.8)
    --         end
    --     end
    -- end
    -- if class == "tfa_vr11" then
    --     CreateConVar("ttt_vr11_ammo", "4", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the vr11", 0)
    --     CreateConVar("ttt_vr11_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the vr11", 0)
    --     -- CreateConVar("ttt_vr11_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the vr11", 0, 1)
    --     -- CreateConVar("ttt_vr11_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the vr11", 0, 1)
    --     -- CreateConVar("ttt_vr11_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the vr11", 0, 1)
    --     -- if GetConVar("ttt_vr11_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_vr11_detective"):GetBool() and GetConVar("ttt_vr11_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_vr11_detective"):GetBool() == false and GetConVar("ttt_vr11_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_vr11_detective"):GetBool() and GetConVar("ttt_vr11_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_vr11_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_vr11_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Anyone you shoot gets the power to instantly kill with ordinary guns!\n\nLasts a limited time."
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         timer.Simple(1, function()
    --             self.Ispackapunched = 1
    --             self.Primary.Damage = self.Primary.Damage * 1
    --             self.Primary.ClipSize = 6
    --             self.Primary.MaxAmmo = 18
    --             self.FireModes = {"Auto"}
    --             return true
    --         end)
    --     end
    -- end
    -- if class == "tfa_wintershowl" then
    --     CreateConVar("ttt_wintershowl_ammo", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the wintershowl", 0)
    --     CreateConVar("ttt_wintershowl_clip", "4", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the wintershowl", 0)
    --     -- CreateConVar("ttt_wintershowl_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the wintershowl", 0, 1)
    --     -- CreateConVar("ttt_wintershowl_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the wintershowl", 0, 1)
    --     -- CreateConVar("ttt_wintershowl_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the wintershowl", 0, 1)
    --     -- if GetConVar("ttt_wintershowl_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_wintershowl_detective"):GetBool() and GetConVar("ttt_wintershowl_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_wintershowl_detective"):GetBool() == false and GetConVar("ttt_wintershowl_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_wintershowl_detective"):GetBool() and GetConVar("ttt_wintershowl_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_wintershowl_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_wintershowl_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shoots a short-range blast of cold air that freezes anyone to death!"
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("WINTER'S HOWL: Shoots a short-range blast of cold air that freezes anyone to death!")
    --     end
    -- end
    -- if class == "tfa_thundergun" then
    --     CreateConVar("ttt_thundergun_ammo", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the thundergun", 0)
    --     CreateConVar("ttt_thundergun_clip", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the thundergun", 0)
    --     -- CreateConVar("ttt_thundergun_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the thundergun", 0, 1)
    --     -- CreateConVar("ttt_thundergun_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the thundergun", 0, 1)
    --     -- CreateConVar("ttt_thundergun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the thundergun", 0, 1)
    --     -- if GetConVar("ttt_thundergun_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_thundergun_detective"):GetBool() and GetConVar("ttt_thundergun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_thundergun_detective"):GetBool() == false and GetConVar("ttt_thundergun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_thundergun_detective"):GetBool() and GetConVar("ttt_thundergun_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_thundergun_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_thundergun_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shoots a massive air blast that kills anyone in a close range."
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("THUNDERGUN: Shoots a massive air blast that kills anyone in a close range!")
    --     end
    --     function SWEP:DoShot(ppos)
    --         if SERVER then
    --             for k, v in pairs(ents.FindInSphere(ppos, 250)) do
    --                 if v == self:GetOwner() then continue end
    --                 --if gamemode.Get("nzombies") and v == self:GetOwner() or v:IsPlayer() then continue end
    --                 if gamemode.Get("nzombies") and v:IsPlayer() and hook.Run("PlayerShouldTakeDamage", v, self:GetOwner()) then return end
    --                 if gamemode.Get("sandbox") or gamemode.Get("terrortown") and v:IsPlayer() or v:IsNPC() then
    --                     local dmginfo = DamageInfo()
    --                     local aim = self:GetOwner():GetAimVector()
    --                     local force = aim * (3 * 750) + Vector(0, 0, 1000)
    --                     timer.Simple(0.1, function()
    --                         dmginfo:SetDamage(2147483646)
    --                         dmginfo:SetDamageType(DMG_SONIC)
    --                         dmginfo:SetAttacker(self:GetOwner())
    --                         dmginfo:SetInflictor(self)
    --                         v:TakeDamageInfo(dmginfo)
    --                     end)
    --                     if v ~= self:GetOwner() then
    --                         if self:GetOwner():IsLineOfSightClear(v) then
    --                             if v:IsNPC() and v:GetMoveType() == 3 then
    --                                 local rag = v:GetRagdollEntity()
    --                                 rag:GetPhysicsObject():SetVelocity(force)
    --                                 print(rag:GetPhysicsObject())
    --                                 v:TakeDamage(math.random(90, 1000), self:GetOwner(), self)
    --                             elseif v:GetMoveType() == MOVETYPE_VPHYSICS then
    --                                 v:GetPhysicsObject():SetVelocity(force)
    --                             else
    --                                 v:SetVelocity(force)
    --                             end
    --                         end
    --                     end
    --                 elseif v.Type == "nextbot" then
    --                     local dmginfo2 = DamageInfo()
    --                     dmginfo2:SetDamage(2147483646)
    --                     dmginfo2:SetDamageType(DMG_SONIC)
    --                     dmginfo2:SetAttacker(self:GetOwner())
    --                     dmginfo2:SetDamageForce((self:GetOwner():GetForward() * 30000) + (self:GetOwner():GetUp() * 30000))
    --                     v:TakeDamageInfo(dmginfo2)
    --                 end
    --             end
    --         end
    --     end
    -- end
    -- if class == "tfa_staff_lightning" then return false end
    -- if class == "tfa_staff_ice" then return false end
    -- if class == "tfa_staff_fire" then return false end
    -- if class == "tfa_sliquifier" then
    --     CreateConVar("ttt_sliquifier_ammo", "6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the sliquifier", 0)
    --     CreateConVar("ttt_sliquifier_clip", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the sliquifier", 0)
    --     -- CreateConVar("ttt_sliquifier_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the sliquifier", 0, 1)
    --     -- CreateConVar("ttt_sliquifier_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the sliquifier", 0, 1)
    --     -- CreateConVar("ttt_sliquifier_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the sliquifier", 0, 1)
    --     -- if GetConVar("ttt_sliquifier_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_sliquifier_detective"):GetBool() and GetConVar("ttt_sliquifier_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_sliquifier_detective"):GetBool() == false and GetConVar("ttt_sliquifier_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_sliquifier_detective"):GetBool() and GetConVar("ttt_sliquifier_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_sliquifier_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_sliquifier_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shoots a gravity affected slime ball, which kills in one shot.\n\nSpread slime on the ground to slip and slide on!"
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("SLIQUIFIER: Shoots slime balls that instantly kill! If you hit someone or the ground, leaves a slippery puddle of slime.")
    --     end
    -- end
    -- if class == "tfa_scavenger" then
    --     CreateConVar("ttt_scavenger_ammo", "4", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the scavenger", 0)
    --     CreateConVar("ttt_scavenger_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the scavenger", 0)
    --     -- CreateConVar("ttt_scavenger_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the scavenger", 0, 1)
    --     -- CreateConVar("ttt_scavenger_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the scavenger", 0, 1)
    --     -- CreateConVar("ttt_scavenger_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the scavenger", 0, 1)
    --     -- if GetConVar("ttt_scavenger_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_scavenger_detective"):GetBool() and GetConVar("ttt_scavenger_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_scavenger_detective"):GetBool() == false and GetConVar("ttt_scavenger_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_scavenger_detective"):GetBool() and GetConVar("ttt_scavenger_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_scavenger_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_scavenger_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "A sniper-rifle that shoots explosives that stick to players.\n\nThey cause a large explosion after a couple seconds."
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     SWEP.ProjectileEntity = "obj_scavenger_proj_modified"
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("SCAVENGER: Shoots an explosive that sticks to players and explodes after a few seconds.")
    --     end
    -- end
    -- if class == "tfa_raygun_mark2" then
    --     CreateConVar("ttt_raygun_mark2_ammo", "24", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the raygun_mark2", 0)
    --     CreateConVar("ttt_raygun_mark2_clip", "21", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the raygun_mark2", 0)
    --     -- CreateConVar("ttt_raygun_mark2_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the raygun_mark2", 0, 1)
    --     -- CreateConVar("ttt_raygun_mark2_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the raygun_mark2", 0, 1)
    --     -- CreateConVar("ttt_raygun_mark2_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the raygun_mark2", 0, 1)
    --     -- if GetConVar("ttt_raygun_mark2_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_raygun_mark2_detective"):GetBool() and GetConVar("ttt_raygun_mark2_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_raygun_mark2_detective"):GetBool() == false and GetConVar("ttt_raygun_mark2_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_raygun_mark2_detective"):GetBool() and GetConVar("ttt_raygun_mark2_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_raygun_mark2_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_raygun_mark2_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shoots a burst-fire of high-damage lasers"
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     SWEP.Primary.Damage = 30
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("RAY GUN MARK II: Shoots a burst-fire of high damage lasers!")
    --     end
    -- end
    -- if class == "tfa_raygun" then
    --     CreateConVar("ttt_raygun_ammo", "24", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the raygun", 0)
    --     CreateConVar("ttt_raygun_clip", "20", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the raygun", 0)
    --     -- CreateConVar("ttt_raygun_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the raygun", 0, 1)
    --     -- CreateConVar("ttt_raygun_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the raygun", 0, 1)
    --     -- CreateConVar("ttt_raygun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the raygun", 0, 1)
    --     -- if GetConVar("ttt_raygun_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_raygun_detective"):GetBool() and GetConVar("ttt_raygun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_raygun_detective"):GetBool() == false and GetConVar("ttt_raygun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_raygun_detective"):GetBool() and GetConVar("ttt_raygun_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_raygun_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_raygun_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shoot high-damage lasers!\n\nDon't shoot too close, else you'll damage yourself."
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("RAYGUN: Shoots high-damage lasers! You take recoil damage if you shoot too close to your target.")
    --     end
    --     function SWEP:PrimaryAttack()
    --         if not self:CanPrimaryAttack() then return end
    --         local own = self:GetOwner()
    --         self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    --         if SERVER then
    --             local orb1 = ents.Create("obj_rgun_proj_modified")
    --             --orb1.Trail = util.SpriteTrail(orb1,1,Color(50,255,50,255),false,32,0,0.75,0.118,"effects/laser_citadel1.vmt")
    --             local pos
    --             --[[local obj,pos = own:LookupAttachment("anim_attachment_RH")
    -- 		if obj != 0 then
    -- 			pos = own:GetAttachment(obj).Pos-own:GetForward()*50 
    -- 		else
    -- 			pos = own:GetShootPos()-own:GetForward()*25 
    -- 		end]]
    --             if self:GetIronSights() then
    --                 pos = own:GetShootPos() + own:GetUp() * -6
    --             elseif (self:GetOwner():KeyDown(IN_FORWARD) or self:GetOwner():KeyDown(IN_BACK) or self:GetOwner():KeyDown(IN_MOVELEFT) or self:GetOwner():KeyDown(IN_MOVERIGHT)) then
    --                 pos = own:GetShootPos() + own:GetUp() * -12 + own:GetRight() * 9
    --             else
    --                 pos = own:GetShootPos() + own:GetUp() * -9 + own:GetRight() * 16
    --             end
    --             orb1:SetPos(pos)
    --             orb1:SetAngles((own:GetEyeTrace().HitPos - pos):Angle())
    --             orb1.Owner = own
    --             if self.Ispackapunched == 1 then
    --                 orb1.TrailPCF = "rgun1_trail_child1_pap"
    --                 orb1.CollidePCF = "rgun1_impact_pap"
    --             else
    --                 orb1.TrailPCF = "rgun1_trail_child1"
    --                 orb1.CollidePCF = "rgun1_impact"
    --             end
    --             orb1:Spawn()
    --             orb1:Activate()
    --         end
    --         self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    --         own:SetAnimation(PLAYER_ATTACK1)
    --         self:TakePrimaryAmmo(1)
    --         self.Weapon:EmitSound("raygun_fire.wav")
    --         self:GetOwner():ViewPunch(Angle(-2, 0))
    --     end
    -- end
    -- if class == "tfa_paralyzer" then return false end
    -- if class == "tfa_jetgun" then
    --     CreateConVar("ttt_jetgun_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the jetgun", 0, 1)
    --     CreateConVar("ttt_jetgun_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the jetgun", 0, 1)
    --     -- CreateConVar("ttt_jetgun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the jetgun", 0, 1)
    --     -- if GetConVar("ttt_jetgun_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_jetgun_detective"):GetBool() and GetConVar("ttt_jetgun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_jetgun_detective"):GetBool() == false and GetConVar("ttt_jetgun_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_jetgun_detective"):GetBool() and GetConVar("ttt_jetgun_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Sucks people in and instantly kills them.\n\nOverheats and explodes if used for too long without cooling down."
    --     }
    --     SWEP.PrintName = "The Jet Gun"
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     local CurTime = CurTime
    --     local mr, mR = math.random, math.Rand
    --     local snd, snd1, explo, hit1, hit2 = SWEP.snd, SWEP.snd1, SWEP.explo, SWEP.hit1, SWEP.hit2
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("THE JET GUN: Sucks people in and instantly kills! Overheats if used for too long.")
    --     end
    --     function SWEP:PrimaryAttack()
    --         if not self:CanPrimaryAttack() then
    --             self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
    --             local o = self:GetOwner()
    --             if not IsValid(o) then
    --                 self:Remove()
    --                 return
    --             end
    --             local prop = ents.Create("prop_physics")
    --             prop:SetModel(self.WorldModel)
    --             prop:SetPos(o:GetShootPos())
    --             prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    --             prop:Spawn()
    --             prop:SetOwner(o)
    --             local timing = mR(1, 3)
    --             prop:Ignite(timing)
    --             local phys = prop:GetPhysicsObject()
    --             if IsValid(phys) then
    --                 local velocity = o:GetForward()
    --                 velocity = velocity * 6000
    --                 velocity = velocity + (VectorRand() * 10)
    --                 phys:ApplyForceCenter(velocity)
    --             end
    --             o:StripWeapon(self:GetClass())
    --             timer.Simple(timing, function()
    --                 local explode = ents.Create("env_explosion")
    --                 explode:SetPos(prop:GetPos())
    --                 explode:SetOwner(prop:GetOwner())
    --                 explode:AddFlags(64)
    --                 explode:SetKeyValue("iMagnitude", mr(60, 140))
    --                 explode:Spawn()
    --                 explode:Fire("Explode", 0, 0)
    --                 explode:EmitSound(explo)
    --                 prop:Remove()
    --             end)
    --             return
    --         elseif self:GetOwner():WaterLevel() > 2 then
    --             self.Weapon:EmitSound(snd1)
    --             self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_EMPTY)
    --             self:SetNextPrimaryFire(CurTime() + 1.5)
    --             return
    --         end
    --         self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    --         if not self.ShutdownSound then
    --             self:EmitSound(Sound(self.Primary.Sound))
    --         end
    --         local del = CurTime()
    --         self.ShutdownSound = del + self.Primary.Delay * 1.5
    --         self:SetNextPrimaryFire(del + self.Primary.Delay)
    --         local o = self:GetOwner()
    --         if o == nil or o == NULL then return end
    --         self:SetAnimFix(false)
    --         o:SetVelocity(o:GetForward() * 30)
    --         o:SetAnimation(PLAYER_ATTACK1)
    --         local tr, sp = o:GetEyeTrace(), o:GetShootPos()
    --         if tr then
    --             local ed, dist = EffectData(), tr.HitPos:Distance(sp)
    --             if dist < 150 then
    --                 ed:SetOrigin(tr.HitPos - o:GetForward() * 16)
    --                 ed:SetMagnitude(dist / 200)
    --             else
    --                 local rr = mr(150, 300)
    --                 ed:SetOrigin(sp + o:GetForward() * rr)
    --                 ed:SetMagnitude(rr / 200)
    --             end
    --             local obj = o:LookupAttachment("anim_attachment_RH")
    --             if obj ~= 0 then
    --                 local pos = o:GetAttachment(obj)
    --                 ed:SetStart(pos.Pos)
    --                 ed:SetEntity(o)
    --             else
    --                 ed:SetStart(sp)
    --                 ed:SetAttachment(1)
    --                 ed:SetEntity(self.Weapon)
    --             end
    --         end
    --         self:TakePrimaryAmmo(1)
    --         local rpm = self:GetRPM()
    --         if rpm < 10 then
    --             self:SetRPM(rpm + 1)
    --         end
    --         local filter = {o}
    --         for i = 0, 7 do
    --             local pos1 = self:GetOwner():GetShootPos()
    --             local ppos1 = pos1 + (self:GetOwner():GetForward() * 0)
    --             if rpm > 5 then
    --                 for k, v in pairs(ents.FindInSphere(ppos1, 10)) do
    --                     local trace = {}
    --                     trace.filter = filter
    --                     trace.start = sp
    --                     trace.mask = MASK_SHOT_HULL
    --                     local ang = o:GetAimVector():Angle()
    --                     ang:RotateAroundAxis(ang:Up(), math.random(-i * 2, i * 2))
    --                     ang:RotateAroundAxis(ang:Right(), math.random(-i * 0.5, i * 0.5))
    --                     local forw = ang:Forward()
    --                     trace.endpos = trace.start + forw * math.random(400, 500)
    --                     local tr = util.TraceLine(trace)
    --                     local ent = tr.Entity
    --                     if IsValid(ent) then
    --                         if ent:IsPlayer() then
    --                             if not hook.Run("PlayerShouldTakeDamage", ent, o) then
    --                                 filter[#filter + 1] = ent
    --                                 continue
    --                             end
    --                         elseif ent:IsNPC() or ent.Type == "nextbot" then
    --                         else
    --                             continue
    --                         end
    --                         local dist = sp:Distance(ent:GetPos())
    --                         if dist > 120 then
    --                             if not ent.m_mass then
    --                                 if ent.Type == "nextbot" then
    --                                     ent.m_mass = 40
    --                                 else
    --                                     local ph = ent:GetPhysicsObject()
    --                                     if IsValid(ph) then
    --                                         ent.m_mass = ph:GetMass()
    --                                     else
    --                                         ent.m_mass = 0
    --                                     end
    --                                 end
    --                             end
    --                             if ent.m_mass ~= 0 then
    --                                 local vel = forw * -mr(10000, 10000) * self:GetRPM() / (dist + 100)
    --                                 if ent.Type == "nextbot" then
    --                                     ent.loco:SetVelocity(vel)
    --                                 else
    --                                     ent:SetVelocity(vel)
    --                                 end
    --                             end
    --                         else
    --                             ent:EmitSound(mr(1, 2) == 1 and hit1 or hit2)
    --                             filter[#filter + 1] = ent
    --                         end
    --                         local a = Vector(-500, 0, 0)
    --                         local pos = self:GetOwner():GetShootPos()
    --                         local ppos = pos + (self:GetOwner():GetForward() * 0)
    --                         for k, v in pairs(ents.FindInSphere(ppos, 55)) do
    --                             if v == self:GetOwner() then continue end
    --                             if gamemode.Get("nzombies") and v:IsPlayer() and hook.Run("PlayerShouldTakeDamage", v, self:GetOwner()) then return end
    --                             local c = v:GetClass()
    --                             if c == "nz_zombie_boss_panzer" then
    --                                 v:TakeDamage(175, self:GetOwner(), self.Weapon)
    --                             end
    --                             for k, v in pairs(ents.FindInSphere(ppos, 45)) do
    --                                 if v:IsNPC() or v.Type == "nextbot" then
    --                                     local dmginfo = DamageInfo()
    --                                     dmginfo:SetDamage(500000000)
    --                                     dmginfo:SetDamageType(DMG_BULLET)
    --                                     dmginfo:SetAttacker(self:GetOwner())
    --                                     dmginfo:SetDamageForce(a)
    --                                     dmginfo2:SetInflictor(self)
    --                                     v:TakeDamageInfo(dmginfo)
    --                                 end
    --                             end
    --                         end
    --                         for k, v in pairs(ents.FindInSphere(ppos, 65)) do
    --                             if gamemode.Get("sandbox") or gamemode.Get("terrortown") and v:IsPlayer() or v:IsNPC() then
    --                                 if v == self:GetOwner() then continue end
    --                                 local dmginfo2 = DamageInfo()
    --                                 dmginfo2:SetDamage(v:Health())
    --                                 dmginfo2:SetDamageType(DMG_BULLET)
    --                                 dmginfo2:SetAttacker(self:GetOwner())
    --                                 dmginfo2:SetInflictor(self)
    --                                 dmginfo2:SetDamageForce(a)
    --                                 v:TakeDamageInfo(dmginfo2)
    --                             end
    --                         end
    --                     end
    --                 end
    --             end
    --         end
    --         local rec = self.Primary.Recoil
    --         o:ViewPunch(Angle(mR(-rec, rec), mR(-rec, rec), 0))
    --         ParticleEffect("jet_muzzle", o:GetShootPos() + o:GetForward() * 60 + o:GetUp() * -10 + o:GetRight() * 10, o:EyeAngles(), o)
    --         ParticleEffect("jetgun_mist2", o:GetPos() + Vector(0, 0, 16), Angle(0, o:GetAngles().y, 0), o)
    --     end
    -- end
    -- if class == "tfa_blundergat" then
    --     CreateConVar("ttt_blundergat_ammo", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the blundergat", 0)
    --     CreateConVar("ttt_blundergat_clip", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the blundergat", 0)
    --     -- CreateConVar("ttt_blundergat_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the blundergat", 0, 1)
    --     -- CreateConVar("ttt_blundergat_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the blundergat", 0, 1)
    --     -- CreateConVar("ttt_blundergat_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the blundergat", 0, 1)
    --     -- if GetConVar("ttt_blundergat_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_blundergat_detective"):GetBool() and GetConVar("ttt_blundergat_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_blundergat_detective"):GetBool() == false and GetConVar("ttt_blundergat_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_blundergat_detective"):GetBool() and GetConVar("ttt_blundergat_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_blundergat_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_blundergat_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "An incredibly powerful shotgun!"
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     SWEP.Primary.Spread = 0.8
    --     SWEP.Primary.IronAccuracy = 0.6
    --     SWEP.Primary.Damage = 50
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("BLUNDERGAT: An incredibly powerful shotgun!")
    --     end
    -- end
    -- if class == "tfa_acidgat" then
    --     CreateConVar("ttt_acidgat_ammo", "9", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the acidgat", 0)
    --     CreateConVar("ttt_acidgat_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the acidgat", 0)
    --     -- CreateConVar("ttt_acidgat_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the acidgat", 0, 1)
    --     -- CreateConVar("ttt_acidgat_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the acidgat", 0, 1)
    --     -- CreateConVar("ttt_acidgat_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the acidgat", 0, 1)
    --     -- if GetConVar("ttt_acidgat_disable"):GetBool() then return false end
    --     -- if GetConVar("ttt_acidgat_detective"):GetBool() and GetConVar("ttt_acidgat_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
    --     -- end
    --     -- if GetConVar("ttt_acidgat_detective"):GetBool() == false and GetConVar("ttt_acidgat_traitor"):GetBool() then
    --     --     SWEP.CanBuy = {ROLE_TRAITOR}
    --     -- end
    --     -- if GetConVar("ttt_acidgat_detective"):GetBool() and GetConVar("ttt_acidgat_traitor"):GetBool() == false then
    --     --     SWEP.CanBuy = {ROLE_DETECTIVE}
    --     -- end
    --     SWEP.Primary.ClipSize = GetConVar("ttt_acidgat_clip"):GetInt()
    --     SWEP.Primary.DefaultClip = GetConVar("ttt_acidgat_ammo"):GetInt()
    --     SWEP.EquipMenuData = {
    --         type = "Wonder Weapon",
    --         desc = "Shoots several explosives that stick to players, and detonate after a couple seconds."
    --     }
    --     SWEP.Kind = WEAPON_EQUIP1
    --     SWEP.AutoSpawnable = false
    --     SWEP.Slot = 6
    --     SWEP.ProjectileEntity = "obj_acidgat_proj_modified"
    --     function SWEP:Equip()
    --         self:GetOwner():ChatPrint("ACID GAT: Shoots a burst of sticky explosives that explode after a delay.")
    --     end
    -- end
    -- if class == "tfa_fusionshotgun" then return false end
    -- if class == "tfa_venomx" then return false end
end