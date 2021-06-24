local EVENT = {}
EVENT.Title = "Now, you're thinking with portals."
EVENT.Description = "Everyone gets a portal gun"
EVENT.id = "portal"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers(true)) do
        ply:Give("weapon_portalgun")
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_portalgun") ~= nil
end

Randomat:register(EVENT)