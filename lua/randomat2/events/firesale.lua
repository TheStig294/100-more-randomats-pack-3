local EVENT = {}
EVENT.Title = "Fire Sale"
EVENT.Description = "Get to a box! Quick!"
EVENT.id = "firesale"

EVENT.Categories = {"item", "entityspawn", "moderateimpact"}

util.AddNetworkString("FireSaleRandomatBegin")
util.AddNetworkString("FireSaleRandomatEnd")

function EVENT:Begin()
    net.Start("FireSaleRandomatBegin")
    net.Broadcast()
end

function EVENT:End()
    net.Start("FireSaleRandomatEnd")
    net.Broadcast()
end

Randomat:register(EVENT)