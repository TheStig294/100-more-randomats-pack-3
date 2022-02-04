local EVENT = {}

CreateConVar("randomat_orubbertree_timer", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given donconnons")

CreateConVar("randomat_orubbertree_strip", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")

CreateConVar("randomat_orubbertree_weaponid", "doncmk2_swep", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

EVENT.Title = "O Rubber Tree..."
EVENT.Description = "Donconnons for all!"
EVENT.id = "orubbertree"

if GetConVar("randomat_orubbertree_strip"):GetBool() then
    EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
end

function EVENT:Begin()
    timer.Create("RandomatORubbertreeTimer", GetConVar("randomat_orubbertree_timer"):GetInt(), 0, function()
        for i, ply in pairs(self:GetAlivePlayers(true)) do
            if table.Count(ply:GetWeapons()) ~= 1 or (table.Count(ply:GetWeapons()) == 1 and ply:GetActiveWeapon():GetClass() ~= "doncmk2_swep") then
                if GetConVar("randomat_orubbertree_strip"):GetBool() then
                    ply:StripWeapons()
                    ply:SetFOV(0, 0.2)
                end

                ply:Give(GetConVar("randomat_orubbertree_weaponid"):GetString())
            end
        end
    end)
end

function EVENT:End()
    timer.Remove("RandomatORubbertreeTimer")
end

function EVENT:Condition()
    return weapons.Get(GetConVar("randomat_orubbertree_weaponid"):GetString()) ~= nil
end

Randomat:register(EVENT)