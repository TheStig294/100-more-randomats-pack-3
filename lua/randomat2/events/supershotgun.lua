local EVENT = {}
EVENT.Title = "Infinite Super Shotguns For All!"
EVENT.id = "supershotgun"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"item", "largeimpact"}

local defaultSSG = "tfa_doom_ssg"

if weapons.Get(defaultSSG) == nil then
    defaultSSG = "doom_sshotgun_2016"
end

CreateConVar("randomat_supershotgun_weaponid", defaultSSG, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

function EVENT:Begin()
    for _, ent in pairs(ents.GetAll()) do
        if (ent.Base == "weapon_tttbase" or ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY) and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            self:HandleWeaponAddAndSelect(ply, function(active_class, active_kind)
                for _, wep in pairs(ply:GetWeapons()) do
                    if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
                        ply:StripWeapon(wep:GetClass())
                    end
                end

                -- Reset FOV to unscope weapons if they were possibly scoped in
                if active_kind == WEAPON_HEAVY or active_kind == WEAPON_PISTOL then
                    ply:SetFOV(0, 0.2)
                end

                local wep1 = ply:Give(GetConVar("randomat_supershotgun_weaponid"):GetString())
                ply:SelectWeapon(wep1)
                wep1.AllowDrop = false
            end)
        end)
    end

    timer.Simple(1, function()
        self:AddHook("Think", function()
            for _, v in pairs(self:GetAlivePlayers()) do
                if IsValid(v:GetActiveWeapon()) then
                    if v:GetActiveWeapon():GetClass() == GetConVar("randomat_supershotgun_weaponid"):GetString() then
                        v:GetActiveWeapon():SetClip1(v:GetActiveWeapon().Primary.ClipSize)
                    end
                end
            end
        end)
    end)
end

function EVENT:Condition()
    return weapons.Get(GetConVar("randomat_supershotgun_weaponid"):GetString()) ~= nil
end

function EVENT:GetConVars()
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

    return {}, {}, textboxes
end

Randomat:register(EVENT)