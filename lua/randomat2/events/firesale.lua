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
    -- Get every player's position so the traps aren't spawned too close to a player
    local playerPositions = {}
    local boxCount = 0
    local playerCount = #self:GetAlivePlayers()

    for _, ply in ipairs(self:GetAlivePlayers()) do
        table.insert(playerPositions, ply:GetPos())
    end

    for _, ent in ipairs(ents.GetAll()) do
        local classname = ent:GetClass()
        local pos = ent:GetPos()
        local infoEnt = string.StartWith(classname, "info_")

        -- Using the positions of weapon, ammo and player spawns
        if (string.StartWith(classname, "weapon_") or string.StartWith(classname, "item_") or infoEnt) and not IsValid(ent:GetParent()) and boxCount <= playerCount then
            local tooClose = false

            for _, plyPos in ipairs(playerPositions) do
                -- 100 * 100 = 10,000, so any traps closer than 100 source units to the player are too close to be placed
                if math.DistanceSqr(pos.x, pos.y, plyPos.x, plyPos.y) < 10000 then
                    tooClose = true
                    break
                end
            end

            if not tooClose then
                boxCount = boxCount + 1
                local box = ents.Create("zombies_mysterybox")
                box:SetPos(pos + Vector(0, 0, 5))

                -- Don't remove player spawn points
                if not infoEnt then
                    ent:Remove()
                end

                box:Spawn()
                box:Arrive()
            end
        end
    end
end

function EVENT:End()
    net.Start("FireSaleRandomatEnd")
    net.Broadcast()
end

function EVENT:Condition()
    return scripted_ents.Get("zombies_mysterybox")
end

Randomat:register(EVENT)