local EVENT = {}
EVENT.Title = "Hack the planet!"
EVENT.Description = "Everyone has a command prompt"
EVENT.id = "hack"

EVENT.Categories = {"item", "smallimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("ttt_cmdpmpt")
            Randomat:CallShopHooks(false, "ttt_cmdpmpt", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("ttt_cmdpmpt") ~= nil
end

Randomat:register(EVENT)