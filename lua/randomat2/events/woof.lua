local EVENT = {}
EVENT.Title = "Woof Woof!"
EVENT.Description = "Everyone gets a guard dog summoner, press 'R' while selected"
EVENT.id = "woof"

EVENT.Categories = {"item", "smallimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("weapon_ttt_guard_dog")
            Randomat:CallShopHooks(false, "weapon_ttt_guard_dog", ply)
        end)
    end
end

function EVENT:Condition()
    local mapHasAI = MapHasAI()

    return mapHasAI and weapons.Get("weapon_ttt_guard_dog") ~= nil
end

Randomat:register(EVENT)