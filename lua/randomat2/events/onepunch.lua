local EVENT = {}
EVENT.Title = "One Puuuuunch!"
EVENT.Description = "Everyone gets the One Punch fists!"
EVENT.id = "onepunch"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("one_punch_skin")
            Randomat:CallShopHooks(false, "one_punch_skin", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("one_punch_skin") ~= nil
end

Randomat:register(EVENT)