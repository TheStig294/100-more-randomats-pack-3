local EVENT = {}
EVENT.Title = "Reach for the sky..."
EVENT.Description = "Jetpacks for all!"
EVENT.id = "jetpack"

EVENT.Categories = {"item", "largeimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("weapon_ttt_jetpackspawner")
            Randomat:CallShopHooks(false, "weapon_ttt_jetpackspawner", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_ttt_jetpackspawner") ~= nil
end

Randomat:register(EVENT)