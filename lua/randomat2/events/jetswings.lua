local EVENT = {}
EVENT.Title = "Jets vs. Wings"
EVENT.Description = "Gives someone a jetpack, everyone else a homing pigeon"
EVENT.id = "jetswings"

EVENT.Categories = {"item", "moderateimpact"}

function EVENT:Begin()
    jetpackPlayer = table.Random(self:GetAlivePlayers())

    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            if ply == jetpackPlayer then
                ply:Give("weapon_ttt_jetpackspawner")
                Randomat:CallShopHooks(false, "weapon_ttt_jetpackspawner", ply)
            else
                ply:Give("weapon_ttt_homingpigeon")
                Randomat:CallShopHooks(false, "weapon_ttt_homingpigeon", ply)
            end
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_ttt_jetpackspawner") ~= nil and weapons.Get("weapon_ttt_homingpigeon") ~= nil
end

Randomat:register(EVENT)