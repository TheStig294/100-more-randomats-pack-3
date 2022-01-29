local EVENT = {}
EVENT.Title = "Careful where you look..."
EVENT.Description = "Everyone has an amaterasu"
EVENT.id = "amaterasu"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("ttt_amaterasu")
            Randomat:CallShopHooks(false, "ttt_amaterasu", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("ttt_amaterasu") ~= nil
end

Randomat:register(EVENT)