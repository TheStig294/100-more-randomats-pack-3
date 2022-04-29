local EVENT = {}
EVENT.Title = "War of Words"
EVENT.Description = "Everyone gets a deathnote!"
EVENT.id = "deathnote"

EVENT.Categories = {"item", "largeimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("death_note_ttt")
            Randomat:CallShopHooks(false, "death_note_ttt", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("death_note_ttt") ~= nil
end

Randomat:register(EVENT)