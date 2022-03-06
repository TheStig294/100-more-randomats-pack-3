local EVENT = {}
EVENT.Title = "Muahahaha!"
EVENT.Description = "Everyone can make a deal with the devil..."
EVENT.id = "devildeal"

EVENT.Categories = {"item", "smallimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("ttt_deal_with_the_devil")
            Randomat:CallShopHooks(false, "ttt_deal_with_the_devil", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("ttt_deal_with_the_devil") ~= nil
end

Randomat:register(EVENT)