local EVENT = {}

CreateConVar("randomat_homerun_timer", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given bats")

CreateConVar("randomat_homerun_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")

CreateConVar("randomat_homerun_weaponid", "weapon_ttt_homebat", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

EVENT.Title = "Home Run!"
EVENT.Description = "Homerun bats only!"
EVENT.id = "homerun"

if GetConVar("randomat_homerun_strip"):GetBool() then
    EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
end

function EVENT:Begin()
    timer.Create("RandomatHomeRunTimer", GetConVar("randomat_homerun_timer"):GetInt(), 0, function()
        for i, ply in pairs(self:GetAlivePlayers(true)) do
            if table.Count(ply:GetWeapons()) ~= 1 or (table.Count(ply:GetWeapons()) == 1 and ply:GetActiveWeapon():GetClass() ~= "weapon_ttt_homebat") then
                if GetConVar("randomat_homerun_strip"):GetBool() then
                    ply:StripWeapons()
                end

                ply:Give(GetConVar("randomat_homerun_weaponid"):GetString())
            end
        end
    end)
end

function EVENT:End()
    timer.Remove("RandomatHomeRunTimer")
end

function EVENT:Condition()
    return weapons.Get(GetConVar("randomat_homerun_weaponid"):GetString()) ~= nil
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"timer"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

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