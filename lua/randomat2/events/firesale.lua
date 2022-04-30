local EVENT = {}
EVENT.Title = "Fire Sale"
EVENT.Description = "Get to a box! Quick!"
EVENT.id = "firesale"

EVENT.Categories = {"item", "entityspawn", "moderateimpact"}

util.AddNetworkString("FireSaleRandomatBegin")
util.AddNetworkString("FireSaleRandomatEnd")

local wonderWeapons = {"tfa_wunderwaffe", "tfa_wavegun", "tfa_staff_wind", "tfa_shrinkray", "tfa_vr11", "tfa_wintershowl", "tfa_thundergun", "tfa_staff_lightning", "tfa_sliquifier", "tfa_scavenger", "tfa_raygun_mark2", "tfa_raygun", "tfa_jetgun", "tfa_blundergat", "tfa_acidgat"}

local ogBoxFile

function EVENT:Begin()
    net.Start("FireSaleRandomatBegin")
    net.Broadcast()
    -- Modifying the weapons that appear in the mystery box
    -- Adding all floor weapons
    local boxWeapons = {}
    ogBoxFile = file.Read("codzombies/mysterybox.txt")

    for _, wep in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(wep)

        if classname and wep.AutoSpawnable then
            table.insert(boxWeapons, classname)
        end
    end

    -- Adding all wonder weapons that are installed
    for _, classname in ipairs(wonderWeapons) do
        if weapons.Get(classname) ~= nil then
            table.insert(boxWeapons, classname)
        end
    end

    local boxFile = "\n\n\n" .. table.concat(boxWeapons, "\n")
    file.CreateDir("codzombies")
    file.Write("codzombies/mysterybox.txt", boxFile)
    -- Get every player's position so the boxes aren't spawned too close to a player
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
                -- 100 * 100 = 10,000, so any boxes closer than 100 source units to the player are too close to be placed
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

    if ogBoxFile then
        file.CreateDir("codzombies")
        file.Write("codzombies/mysterybox.txt", ogBoxFile)
    end
end

function EVENT:Condition()
    return scripted_ents.Get("zombies_mysterybox")
end

Randomat:register(EVENT)