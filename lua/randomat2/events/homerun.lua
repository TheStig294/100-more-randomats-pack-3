local EVENT = {}

CreateConVar("randomat_homerun_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")

CreateConVar("randomat_homerun_weaponid", "weapon_ttt_homebat", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

EVENT.Title = "Home Run!"
EVENT.Description = "Homerun bats only!"
EVENT.id = "homerun"

if GetConVar("randomat_homerun_strip"):GetBool() then
    EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
end

function EVENT:Begin()
    self:AddHook("Think", function()
        for i, ply in pairs(self:GetAlivePlayers()) do
            local activeWeapon = ply:GetActiveWeapon()

            if #ply:GetWeapons() ~= 1 or (IsValid(activeWeapon) and activeWeapon:GetClass() ~= GetConVar("randomat_homerun_weaponid"):GetString()) then
                if GetConVar("randomat_homerun_strip"):GetBool() then
                    ply:StripWeapons()
                end

                local givenBat = ply:Give(GetConVar("randomat_homerun_weaponid"):GetString())

                if givenBat then
                    givenBat.AllowDrop = false
                end
            end

            if IsValid(activeWeapon) and activeWeapon:GetClass() == GetConVar("randomat_homerun_weaponid"):GetString() then
                activeWeapon:SetClip1(activeWeapon.Primary.ClipSize)
            end
        end
    end)

    self:AddHook("PlayerCanPickupWeapon", function(ply, wep)
        if not GetConVar("randomat_homerun_strip"):GetBool() then return end

        return IsValid(wep) and (WEPS.GetClass(wep) == GetConVar("randomat_homerun_weaponid"):GetString() or wep.CanBuy ~= nil)
    end)

    self:AddHook("TTTOrderedEquipment", function(ply, equipment, is_item)
        if is_item or not GetConVar("randomat_homerun_strip"):GetBool() then return end
        ply:AddCredits(1)
        ply:PrintMessage(HUD_PRINTCENTER, "Passive items only!")
        ply:ChatPrint("You can only buy passive items during " .. self.Title .. "\nYour credit has been refunded.")
    end)
end

function EVENT:Condition()
    return weapons.Get(GetConVar("randomat_homerun_weaponid"):GetString()) ~= nil
end

function EVENT:GetConVars()
    local checks = {}

    for _, v in ipairs({"strip"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    local textboxes = {}

    for _, v in ipairs({"weaponid"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(textboxes, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks, textboxes
end

Randomat:register(EVENT)