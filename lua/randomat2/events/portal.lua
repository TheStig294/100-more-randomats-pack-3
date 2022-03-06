local EVENT = {}
EVENT.Title = "Now, you're thinking with portals."
EVENT.Description = "Everyone gets a portal gun"
EVENT.id = "portal"

EVENT.Categories = {"item", "smallimpact"}

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers(true)) do
        ply:Give("weapon_portalgun")
        Randomat:CallShopHooks(false, "weapon_portalgun", ply)
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_portalgun") ~= nil
end

Randomat:register(EVENT)