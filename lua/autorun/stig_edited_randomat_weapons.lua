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

        if class == "tfa_wunderwaffe" then
            CreateConVar("ttt_wunderwaffe_ammo", "4", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the wunderwaffe", 0)

            CreateConVar("ttt_wunderwaffe_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the wunderwaffe", 0)

            -- CreateConVar("ttt_wunderwaffe_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the wunderwaffe", 0, 1)
            -- CreateConVar("ttt_wunderwaffe_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the wunderwaffe", 0, 1)
            CreateConVar("ttt_wunderwaffe_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the wunderwaffe", 0, 1)

            CreateConVar("ttt_wunderwaffe_damage", "1000", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the wunderwaffe", 0)

            if GetConVar("ttt_wunderwaffe_disable"):GetBool() then return false end
            -- if GetConVar("ttt_wunderwaffe_detective"):GetBool() and GetConVar("ttt_wunderwaffe_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_wunderwaffe_detective"):GetBool() == false and GetConVar("ttt_wunderwaffe_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_wunderwaffe_detective"):GetBool() and GetConVar("ttt_wunderwaffe_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_wunderwaffe_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_wunderwaffe_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Powerful lightning rifle that kills in 1 shot! \n\nWill kill you as well if you shoot it too close!"
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("WUNDERWAFFE DG-2: Shoots a bolt of lightning that instantly kills!")
            end

            hook.Add("EntityTakeDamage", "WunderwaffeDamageHack", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "wunderwaffe_entity_ball" and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():HasWeapon("tfa_wunderwaffe") then
                    dmg:SetInflictor(dmg:GetAttacker():GetWeapon("tfa_wunderwaffe"))
                    dmg:SetDamage(GetConVar("ttt_wunderwaffe_damage"):GetFloat())
                    dmg:SetDamageType(DMG_SONIC)
                end
            end)
        end

        if class == "tfa_wavegun" then
            CreateConVar("ttt_wavegun_ammo", "20", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the wavegun", 0)

            CreateConVar("ttt_wavegun_clip", "16", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the wavegun", 0)

            -- CreateConVar("ttt_wavegun_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the wavegun", 0, 1)
            -- CreateConVar("ttt_wavegun_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the wavegun", 0, 1)
            CreateConVar("ttt_wavegun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the wavegun", 0, 1)

            CreateConVar("ttt_wavegun_damage", "20", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the wavegun, will be multiplied by 2, e.g. set this to 20, = 40 damage", 0)

            if GetConVar("ttt_wavegun_disable"):GetBool() then return false end
            -- if GetConVar("ttt_wavegun_detective"):GetBool() and GetConVar("ttt_wavegun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_wavegun_detective"):GetBool() == false and GetConVar("ttt_wavegun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_wavegun_detective"):GetBool() and GetConVar("ttt_wavegun_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_wavegun_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_wavegun_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Duel-wield, high-damage laser guns!"
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6
            SWEP.SlotPos = 2
            SWEP.Secondary.DefaultClip = 0
            SWEP.Primary.RPM = 125
            SWEP.PrintName = "Zap Guns"

            function SWEP:Equip()
                self:GetOwner():ChatPrint("ZAP GUNS: Duel-wield laser guns, press left or right click to shoot!")
            end

            hook.Add("EntityTakeDamage", "WaveGunDamageHack", function(ent, dmg)
                if dmg:GetDamageType() == DMG_SHOCK and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():GetActiveWeapon() ~= NULL and dmg:GetAttacker():GetActiveWeapon():GetClass() == "tfa_wavegun" then
                    dmg:SetInflictor(dmg:GetAttacker():GetActiveWeapon())
                    dmg:SetDamage(GetConVar("ttt_wavegun_damage"):GetFloat())
                    dmg:SetDamageType(DMG_SONIC)
                end
            end)
        end

        if class == "tfa_staff_wind" then
            CreateConVar("ttt_windstaff_ammo", "6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the windstaff", 0)

            CreateConVar("ttt_windstaff_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the windstaff", 0)

            -- CreateConVar("ttt_windstaff_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the windstaff", 0, 1)
            -- CreateConVar("ttt_windstaff_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the windstaff", 0, 1)
            CreateConVar("ttt_windstaff_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the windstaff", 0, 1)

            CreateConVar("ttt_windstaff_damage", "50", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the windstaff, attacks at a longer range deal 1/2 damage", 0)

            if GetConVar("ttt_windstaff_disable"):GetBool() then return false end
            -- if GetConVar("ttt_windstaff_detective"):GetBool() and GetConVar("ttt_windstaff_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_windstaff_detective"):GetBool() == false and GetConVar("ttt_windstaff_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_windstaff_detective"):GetBool() and GetConVar("ttt_windstaff_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_windstaff_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_windstaff_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoots short-range, high damage blasts of air!"
            -- }
            SWEP.AutoSpawnable = false
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("STAFF OF WIND: Shoots short-range, high damage blasts of air!")
            end

            hook.Add("EntityTakeDamage", "WindstaffDamageHackLongRange", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "obj_windstaff_proj" and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():HasWeapon("tfa_staff_wind") then
                    dmg:SetInflictor(dmg:GetAttacker():GetWeapon("tfa_staff_wind"))
                    dmg:SetDamage(GetConVar("ttt_windstaff_damage"):GetFloat() / 2)
                    dmg:SetDamageType(DMG_BLAST)
                end
            end)

            hook.Add("EntityTakeDamage", "WindstaffDamageHackShortRange", function(ent, dmg)
                if dmg:GetDamageType() == DMG_GENERIC and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():GetActiveWeapon() ~= NULL and dmg:GetAttacker():GetActiveWeapon():GetClass() == "tfa_staff_wind" then
                    dmg:SetInflictor(dmg:GetAttacker():GetActiveWeapon())
                    dmg:SetDamage(GetConVar("ttt_windstaff_damage"):GetFloat() / 2)
                    dmg:SetDamageType(DMG_BLAST)
                end
            end)
        end

        if class == "tfa_shrinkray" then
            CreateConVar("ttt_shrinkray_ammo", "6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the shrinkray", 0)

            CreateConVar("ttt_shrinkray_clip", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the shrinkray", 0)

            -- CreateConVar("ttt_shrinkray_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the shrinkray", 0, 1)
            -- CreateConVar("ttt_shrinkray_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the shrinkray", 0, 1)
            CreateConVar("ttt_shrinkray_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the shrinkray", 0, 1)

            if GetConVar("ttt_shrinkray_disable"):GetBool() then return false end
            -- if GetConVar("ttt_shrinkray_detective"):GetBool() and GetConVar("ttt_shrinkray_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_shrinkray_detective"):GetBool() == false and GetConVar("ttt_shrinkray_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_shrinkray_detective"):GetBool() and GetConVar("ttt_shrinkray_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_shrinkray_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_shrinkray_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoots an orb that shrinks anyone it hits!\nThis reduces them to 1 health. \n\nWalking into anyone while shrunk kills them."
            -- }
            SWEP.PrintName = "The Baby Maker"
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6
            RunConsoleCommand("nz_shrinkray_shrinkplayers", "1")

            function SWEP:Equip()
                self:GetOwner():ChatPrint("THE BABY MAKER: Shoots an orb that shrinks anyone it hits!\nThis reduces them to 1 health. Walking into anyone while shrunk kills them.")
            end

            hook.Add("EntityTakeDamage", "BabyMakerDamageHack", function(ent, dmg)
                if ent:GetNWBool("IsBaby") then
                    local attacker = dmg:GetAttacker()
                    dmg:SetDamageType(DMG_CLUB)
                    dmg:SetAttacker(attacker)
                    dmg:SetDamage(ent:Health() + 1000)

                    if attacker:IsPlayer() and attacker:HasWeapon("tfa_shrinkray") then
                        dmg:SetInflictor(attacker:GetWeapon("tfa_shrinkray"))
                    end

                    timer.Simple(0, function()
                        hook.Add("Think", "BabyMakerRespawnFix" .. ent:EntIndex(), function()
                            if ent ~= NULL then
                                ent:SetNWBool("IsBaby", false)
                                ent:SetNWBool("ShouldKickBaby", false)
                                ent:SetNWBool("BabyOnGround", false)
                                timer.Remove("BabyHitGround" .. ent:EntIndex())

                                if ent:Alive() and not ent:IsSpec() then
                                    hook.Remove("Think", "BabyMakerRespawnFix" .. ent:EntIndex())
                                    ent:SetModelScale(1)

                                    if ent:LookupBone("ValveBiped.Bip01_Head1") ~= nil then
                                        ent:ManipulateBoneScale(ent:LookupBone("ValveBiped.Bip01_Head1"), Vector(1, 1, 1))
                                    end
                                end
                            end
                        end)
                    end)
                end
            end)
        end

        if class == "tfa_vr11" then
            CreateConVar("ttt_vr11_ammo", "4", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the vr11", 0)

            CreateConVar("ttt_vr11_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the vr11", 0)

            -- CreateConVar("ttt_vr11_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the vr11", 0, 1)
            -- CreateConVar("ttt_vr11_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the vr11", 0, 1)
            CreateConVar("ttt_vr11_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the vr11", 0, 1)

            if GetConVar("ttt_vr11_disable"):GetBool() then return false end
            -- if GetConVar("ttt_vr11_detective"):GetBool() and GetConVar("ttt_vr11_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_vr11_detective"):GetBool() == false and GetConVar("ttt_vr11_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_vr11_detective"):GetBool() and GetConVar("ttt_vr11_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_vr11_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_vr11_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Anyone you shoot gets the power to instantly kill with ordinary guns!\n\nLasts a limited time."
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("VR-11: Anyone you shoot gets the power to instantly kill with ordinary guns! Lasts a limited time.")

                timer.Simple(1, function()
                    self:OnPaP()
                end)
            end
        end

        if class == "tfa_wintershowl" then
            CreateConVar("ttt_wintershowl_ammo", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the wintershowl", 0)

            CreateConVar("ttt_wintershowl_clip", "4", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the wintershowl", 0)

            -- CreateConVar("ttt_wintershowl_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the wintershowl", 0, 1)
            -- CreateConVar("ttt_wintershowl_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the wintershowl", 0, 1)
            CreateConVar("ttt_wintershowl_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the wintershowl", 0, 1)

            if GetConVar("ttt_wintershowl_disable"):GetBool() then return false end
            -- if GetConVar("ttt_wintershowl_detective"):GetBool() and GetConVar("ttt_wintershowl_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_wintershowl_detective"):GetBool() == false and GetConVar("ttt_wintershowl_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_wintershowl_detective"):GetBool() and GetConVar("ttt_wintershowl_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_wintershowl_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_wintershowl_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoots a short-range blast of cold air that freezes people solid and kills after a couple seconds."
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("WINTER'S HOWL: Shoots a short-range blast of cold air that freezes anyone to death!")
            end

            RunConsoleCommand("wintershowl_freezeplayers", "1")

            hook.Add("EntityTakeDamage", "WintershowlDamageHack", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "tfa_wintershowl" and ent ~= NULL and ent:IsPlayer() then
                    timer.Simple(0.1, function()
                        ent:Freeze(true)
                    end)

                    timer.Simple(6, function()
                        ent:Freeze(false)
                    end)
                end
            end)
        end

        if class == "tfa_thundergun" then
            CreateConVar("ttt_thundergun_ammo", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the thundergun", 0)

            CreateConVar("ttt_thundergun_clip", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the thundergun", 0)

            -- CreateConVar("ttt_thundergun_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the thundergun", 0, 1)
            -- CreateConVar("ttt_thundergun_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the thundergun", 0, 1)
            CreateConVar("ttt_thundergun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the thundergun", 0, 1)

            CreateConVar("ttt_thundergun_damage", "1000", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the thundergun", 0)

            if GetConVar("ttt_thundergun_disable"):GetBool() then return false end
            -- if GetConVar("ttt_thundergun_detective"):GetBool() and GetConVar("ttt_thundergun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_thundergun_detective"):GetBool() == false and GetConVar("ttt_thundergun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_thundergun_detective"):GetBool() and GetConVar("ttt_thundergun_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_thundergun_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_thundergun_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoots a massive air blast that kills anyone in a close range."
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("THUNDERGUN: Shoots a massive air blast that kills anyone in a close range!")
            end

            hook.Add("EntityTakeDamage", "ThundergunDamageHack", function(ent, dmg)
                if dmg:GetDamageType() == DMG_SONIC and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():GetActiveWeapon() ~= NULL and dmg:GetAttacker():GetActiveWeapon():GetClass() == "tfa_thundergun" then
                    dmg:SetInflictor(dmg:GetAttacker():GetActiveWeapon())
                    dmg:SetDamage(GetConVar("ttt_thundergun_damage"):GetFloat())
                    dmg:SetDamageType(DMG_BLAST)
                end
            end)
        end

        if class == "tfa_staff_lightning" then
            CreateConVar("ttt_lightningstaff_ammo", "16", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the lightningstaff", 0)

            CreateConVar("ttt_lightningstaff_clip", "12", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the lightningstaff", 0)

            -- CreateConVar("ttt_lightningstaff_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the lightningstaff", 0, 1)
            -- CreateConVar("ttt_lightningstaff_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the lightningstaff", 0, 1)
            CreateConVar("ttt_lightningstaff_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the lightningstaff", 0, 1)

            CreateConVar("ttt_lightningstaff_damage", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the lightningstaff", 0)

            if GetConVar("ttt_lightningstaff_disable"):GetBool() then return false end
            -- if GetConVar("ttt_lightningstaff_detective"):GetBool() and GetConVar("ttt_lightningstaff_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_lightningstaff_detective"):GetBool() == false and GetConVar("ttt_lightningstaff_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_lightningstaff_detective"):GetBool() and GetConVar("ttt_lightningstaff_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_lightningstaff_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_lightningstaff_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Rapidly shoots plasma balls!"
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("STAFF OF LIGHTNING: Rapidly shoots plasma balls!")
            end

            hook.Add("EntityTakeDamage", "LightningStaffDamageHack", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "obj_lstaff_proj" and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():HasWeapon("tfa_staff_lightning") then
                    dmg:SetInflictor(dmg:GetAttacker():GetWeapon("tfa_staff_lightning"))
                    dmg:SetDamage(GetConVar("ttt_lightningstaff_damage"):GetFloat())
                end
            end)
        end

        if class == "tfa_staff_ice" then return false end
        if class == "tfa_staff_fire" then return false end

        if class == "tfa_sliquifier" then
            CreateConVar("ttt_sliquifier_ammo", "6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the sliquifier", 0)

            CreateConVar("ttt_sliquifier_clip", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the sliquifier", 0)

            -- CreateConVar("ttt_sliquifier_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the sliquifier", 0, 1)
            -- CreateConVar("ttt_sliquifier_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the sliquifier", 0, 1)
            CreateConVar("ttt_sliquifier_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the sliquifier", 0, 1)

            CreateConVar("ttt_sliquifier_damage", "1000", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the sliquifier", 0)

            if GetConVar("ttt_sliquifier_disable"):GetBool() then return false end
            -- if GetConVar("ttt_sliquifier_detective"):GetBool() and GetConVar("ttt_sliquifier_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_sliquifier_detective"):GetBool() == false and GetConVar("ttt_sliquifier_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_sliquifier_detective"):GetBool() and GetConVar("ttt_sliquifier_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_sliquifier_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_sliquifier_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoots slime balls that instantly kill!\n\nIf you hit someone or the ground, leaves a slippery puddle of slime."
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("SLIQUIFIER: Shoots slime balls that instantly kill! If you hit someone or the ground, leaves a slippery puddle of slime.")
            end

            hook.Add("EntityTakeDamage", "SliquifierDamageHackLongRange", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "sliquifier_proj" and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():HasWeapon("tfa_sliquifier") then
                    dmg:SetInflictor(dmg:GetAttacker():GetWeapon("tfa_sliquifier"))
                    dmg:SetDamage(GetConVar("ttt_sliquifier_damage"):GetFloat())
                end
            end)
        end

        if class == "tfa_scavenger" then
            CreateConVar("ttt_scavenger_ammo", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the scavenger", 0)

            CreateConVar("ttt_scavenger_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the scavenger", 0)

            -- CreateConVar("ttt_scavenger_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the scavenger", 0, 1)
            -- CreateConVar("ttt_scavenger_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the scavenger", 0, 1)
            CreateConVar("ttt_scavenger_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the scavenger", 0, 1)

            CreateConVar("ttt_scavenger_damage", "1000", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the scavenger", 0)

            if GetConVar("ttt_scavenger_disable"):GetBool() then return false end
            -- if GetConVar("ttt_scavenger_detective"):GetBool() and GetConVar("ttt_scavenger_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_scavenger_detective"):GetBool() == false and GetConVar("ttt_scavenger_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_scavenger_detective"):GetBool() and GetConVar("ttt_scavenger_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_scavenger_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_scavenger_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "A sniper-rifle that shoots a delayed explosive that blows up after a couple seconds.\n\nThe explosive sticks to players."
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("SCAVENGER: Shoots an explosive that sticks to players and explodes after a few seconds.")
            end

            hook.Add("EntityTakeDamage", "ScavengerDamageHack", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "obj_scavenger_proj" and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():HasWeapon("tfa_scavenger") then
                    dmg:SetInflictor(dmg:GetAttacker():GetWeapon("tfa_scavenger"))
                    dmg:SetDamage(GetConVar("ttt_scavenger_damage"):GetFloat())
                end
            end)
        end

        if class == "tfa_raygun_mark2" then
            CreateConVar("ttt_raygun_mark2_ammo", "24", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the raygun_mark2", 0)

            CreateConVar("ttt_raygun_mark2_clip", "21", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the raygun_mark2", 0)

            -- CreateConVar("ttt_raygun_mark2_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the raygun_mark2", 0, 1)
            -- CreateConVar("ttt_raygun_mark2_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the raygun_mark2", 0, 1)
            CreateConVar("ttt_raygun_mark2_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the raygun_mark2", 0, 1)

            CreateConVar("ttt_raygun_mark2_damage", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the raygun_mark2", 0)

            if GetConVar("ttt_raygun_mark2_disable"):GetBool() then return false end
            -- if GetConVar("ttt_raygun_mark2_detective"):GetBool() and GetConVar("ttt_raygun_mark2_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_raygun_mark2_detective"):GetBool() == false and GetConVar("ttt_raygun_mark2_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_raygun_mark2_detective"):GetBool() and GetConVar("ttt_raygun_mark2_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_raygun_mark2_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_raygun_mark2_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoots a burst-fire of high-damage lasers"
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6
            SWEP.Primary.Damage = GetConVar("ttt_raygun_mark2_damage"):GetFloat()

            function SWEP:Equip()
                self:GetOwner():ChatPrint("RAY GUN MARK II: Shoots a burst-fire of high damage lasers!")
            end
        end

        if class == "tfa_raygun" then
            CreateConVar("ttt_raygun_ammo", "24", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the raygun", 0)

            CreateConVar("ttt_raygun_clip", "20", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the raygun", 0)

            -- CreateConVar("ttt_raygun_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the raygun", 0, 1)
            -- CreateConVar("ttt_raygun_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the raygun", 0, 1)
            CreateConVar("ttt_raygun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the raygun", 0, 1)

            CreateConVar("ttt_raygun_damage", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the raygun", 0)

            if GetConVar("ttt_raygun_disable"):GetBool() then return false end
            -- if GetConVar("ttt_raygun_detective"):GetBool() and GetConVar("ttt_raygun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_raygun_detective"):GetBool() == false and GetConVar("ttt_raygun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_raygun_detective"):GetBool() and GetConVar("ttt_raygun_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_raygun_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_raygun_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoot high-damage lasers!\n\nDon't shoot too close, else you'll damage yourself."
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("RAYGUN: Shoots high-damage lasers! You take recoil damage if you shoot too close to your target.")
            end

            hook.Add("EntityTakeDamage", "RayGunDamageHack", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "obj_rgun_proj" and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():HasWeapon("tfa_raygun") then
                    dmg:SetInflictor(dmg:GetAttacker():GetWeapon("tfa_raygun"))
                    dmg:SetDamage(GetConVar("ttt_raygun_damage"):GetFloat() / 2)
                    dmg:SetDamageType(DMG_SONIC)
                end
            end)
        end

        if class == "tfa_paralyzer" then return false end

        if class == "tfa_jetgun" then
            -- CreateConVar("ttt_jetgun_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the jetgun", 0, 1)
            -- CreateConVar("ttt_jetgun_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the jetgun", 0, 1)
            CreateConVar("ttt_jetgun_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the jetgun", 0, 1)

            if GetConVar("ttt_jetgun_disable"):GetBool() then return false end
            -- if GetConVar("ttt_jetgun_detective"):GetBool() and GetConVar("ttt_jetgun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_jetgun_detective"):GetBool() == false and GetConVar("ttt_jetgun_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_jetgun_detective"):GetBool() and GetConVar("ttt_jetgun_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Sucks people in and instantly kills them.\n\nOverheats and explodes if used for too long without cooling down."
            -- }
            SWEP.PrintName = "The Jet Gun"
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("THE JET GUN: Sucks people in and instantly kills! Overheats if used for too long.")
                self:GetOwner():SetAmmo(160, "Coolant")

                hook.Add("KeyPress", "JetGunStartupSound", function(ply, key)
                    if ply:GetActiveWeapon() ~= NULL and ply:GetActiveWeapon():GetClass() == "tfa_jetgun" and key == IN_ATTACK then
                        ply:EmitSound("weapons/jetgun/rattle/jetgun_rattle_start.mp3", 75, 100, 1, CHAN_WEAPON)
                    end
                end)
            end

            function SWEP:PreDrop()
                timer.Remove(self:GetOwner():EntIndex() .. "jetgun_reload")
            end
        end

        if class == "tfa_blundergat" then
            CreateConVar("ttt_blundergat_ammo", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the blundergat", 0)

            CreateConVar("ttt_blundergat_clip", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the blundergat", 0)

            -- CreateConVar("ttt_blundergat_detective", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the blundergat", 0, 1)
            -- CreateConVar("ttt_blundergat_traitor", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the blundergat", 0, 1)
            CreateConVar("ttt_blundergat_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the blundergat", 0, 1)

            CreateConVar("ttt_blundergat_damage", "50", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the blundergat, per bullet", 0)

            if GetConVar("ttt_blundergat_disable"):GetBool() then return false end
            -- if GetConVar("ttt_blundergat_detective"):GetBool() and GetConVar("ttt_blundergat_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_blundergat_detective"):GetBool() == false and GetConVar("ttt_blundergat_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_blundergat_detective"):GetBool() and GetConVar("ttt_blundergat_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_blundergat_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_blundergat_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "An incredibly powerful shotgun!"
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6
            SWEP.Primary.Spread = 0.8
            SWEP.Primary.IronAccuracy = 0.6
            SWEP.Primary.Damage = GetConVar("ttt_blundergat_damage"):GetFloat()

            function SWEP:Equip()
                self:GetOwner():ChatPrint("BLUNDERGAT: An incredibly powerful shotgun!")
            end
        end

        if class == "tfa_acidgat" then
            CreateConVar("ttt_acidgat_ammo", "9", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Starting ammo of the acidgat", 0)

            CreateConVar("ttt_acidgat_clip", "3", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Magazine size of the acidgat", 0)

            -- CreateConVar("ttt_acidgat_detective", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a detective can by the acidgat", 0, 1)
            -- CreateConVar("ttt_acidgat_traitor", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a traitor can by the acidgat", 0, 1)
            CreateConVar("ttt_acidgat_disable", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Disable the acidgat", 0, 1)

            CreateConVar("ttt_acidgat_damage", "40", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the acidgat, per explosive (x3)", 0)

            if GetConVar("ttt_acidgat_disable"):GetBool() then return false end
            -- if GetConVar("ttt_acidgat_detective"):GetBool() and GetConVar("ttt_acidgat_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
            -- end
            -- if GetConVar("ttt_acidgat_detective"):GetBool() == false and GetConVar("ttt_acidgat_traitor"):GetBool() then
            --     SWEP.CanBuy = {ROLE_TRAITOR}
            -- end
            -- if GetConVar("ttt_acidgat_detective"):GetBool() and GetConVar("ttt_acidgat_traitor"):GetBool() == false then
            --     SWEP.CanBuy = {ROLE_DETECTIVE}
            -- end
            SWEP.Primary.ClipSize = GetConVar("ttt_acidgat_clip"):GetInt()
            SWEP.Primary.DefaultClip = GetConVar("ttt_acidgat_ammo"):GetInt()
            -- SWEP.EquipMenuData = {
            --     type = "Wonder Weapon",
            --     desc = "Shoots several explosives that stick to players, and detonate after a couple seconds."
            -- }
            SWEP.Kind = WEAPON_EQUIP1
            SWEP.AutoSpawnable = false
            SWEP.Slot = 6

            function SWEP:Equip()
                self:GetOwner():ChatPrint("ACID GAT: Shoots a burst of sticky explosives that explode after a delay.")
            end

            hook.Add("EntityTakeDamage", "AcidgatDamageHack", function(ent, dmg)
                if dmg:GetInflictor() ~= NULL and dmg:GetInflictor():GetClass() == "obj_acidgat_proj" and dmg:GetAttacker() ~= NULL and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():HasWeapon("tfa_acidgat") then
                    dmg:SetInflictor(dmg:GetAttacker():GetWeapon("tfa_acidgat"))
                    dmg:SetDamage(GetConVar("ttt_acidgat_damage"):GetFloat())
                    dmg:SetDamageType(DMG_BLAST)
                end
            end)
        end
    end)
end