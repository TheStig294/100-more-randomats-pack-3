local EVENT = {}
EVENT.Title = "Minimap: Activated"
EVENT.id = "minimap"

EVENT.Categories = {"largeimpact"}

util.AddNetworkString("MinimapRandomatToggle")

function EVENT:Begin()
    net.Start("MinimapRandomatToggle")
    -- Writing a bool here rather than having 2 different network strings saves on using an extra network string slot
    net.WriteBool(true)
    net.Broadcast()
end

function EVENT:End()
    net.Start("MinimapRandomatToggle")
    net.WriteBool(false)
    net.Broadcast()
end

function EVENT:Condition()
    return istable(GMinimap)
end

Randomat:register(EVENT)