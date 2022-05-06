local EVENT = {}
EVENT.Title = "The Slow-mo Guys"
EVENT.Description = "Everyone gets a time manipulator"
EVENT.id = "timemanipulator"

EVENT.Categories = {"item", "moderateimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("weapons_ttt_time_manipulator")
            Randomat:CallShopHooks(false, "weapons_ttt_time_manipulator", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("weapons_ttt_time_manipulator") ~= nil
end

Randomat:register(EVENT)