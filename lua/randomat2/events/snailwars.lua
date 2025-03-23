local EVENT = {}
CreateConVar("randomat_snailwars_weaponid", "weapon_ttt_freezegun", FCVAR_NONE, "Id of the freeze gun weapon given")
EVENT.Title = "Snail Wars"
EVENT.Description = "Everyone has a snail gun + freeze gun"
EVENT.id = "snailwars"

EVENT.Categories = {"item", "smallimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            if (ply:GetRole() ~= ROLE_JESTER) and (ply:GetRole() ~= ROLE_SWAPPER) then
                ply:Give(GetConVar("randomat_snailwars_weaponid"):GetString())
                Randomat:CallShopHooks(false, GetConVar("randomat_snailwars_weaponid"):GetString(), ply)
                ply:Give("weapon_ttt_killersnail")
                Randomat:CallShopHooks(false, "weapon_ttt_killersnail", ply)
            end
        end)
    end
end

function EVENT:Condition()
    return Randomat:MapHasAI() and GetConVar("randomat_snailwars_weaponid"):GetString() ~= nil and weapons.Get("weapon_ttt_killersnail") ~= nil
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