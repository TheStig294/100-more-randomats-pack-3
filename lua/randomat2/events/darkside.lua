local EVENT = {}
EVENT.Title = "Join the dark side!"
EVENT.Description = "Lightsabers for all!"
EVENT.id = "darkside"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("weapon_ttt_traitor_lightsaber")
            Randomat:CallShopHooks(false, "weapon_ttt_traitor_lightsaber", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_ttt_traitor_lightsaber") ~= nil
end

Randomat:register(EVENT)