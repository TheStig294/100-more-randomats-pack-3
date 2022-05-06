local EVENT = {}
EVENT.Title = "Air Raid"
EVENT.Description = "Everyone gets a gravity changer!"
EVENT.id = "gravitychanger"

EVENT.Categories = {"item", "largeimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            -- Yup, the gravity changer's classname is just "manipulator"...
            ply:Give("manipulator")
            Randomat:CallShopHooks(false, "manipulator", ply)
        end)
    end
end

function EVENT:Condition()
    return weapons.Get("manipulator") ~= nil
end

Randomat:register(EVENT)