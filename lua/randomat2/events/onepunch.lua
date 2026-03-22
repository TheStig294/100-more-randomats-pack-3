local EVENT = {}
EVENT.Title = "One Puuuuunch!"
EVENT.Description = "Everyone gets the One Punch fists!"
EVENT.id = "onepunch"

EVENT.Categories = {"item", "largeimpact"}

function EVENT:Begin()
    for _, ply in player.Iterator() do
        if not ply:Alive() or ply:IsSpec() then continue end

        timer.Simple(0.1, function()
            ply:Give("weapon_ttt_one_punch")
            Randomat:CallShopHooks(false, "weapon_ttt_one_punch", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_ttt_one_punch") ~= nil
end

Randomat:register(EVENT)