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
end