local EVENT = {}
EVENT.Title = "Fire Sale"
EVENT.Description = "Get to a box, quick!"
EVENT.id = "firesale"

EVENT.Categories = {"biased_traitor", "biased", "item", "entityspawn", "moderateimpact"}

local musicCvar = CreateConVar("randomat_firesale_music", 1, FCVAR_ARCHIVE, "Whether music plays while event is active", 0, 1)
util.AddNetworkString("FireSaleRandomatBegin")
util.AddNetworkString("FireSaleRandomatEnd")

local wonderWeapons = {"tfa_wunderwaffe", "tfa_wavegun", "tfa_staff_wind", "tfa_shrinkray", "tfa_vr11", "tfa_wintershowl", "tfa_thundergun", "tfa_staff_lightning", "tfa_sliquifier", "tfa_scavenger", "tfa_raygun_mark2", "tfa_raygun", "tfa_jetgun", "tfa_blundergat", "tfa_acidgat"}

local ogBoxFile
local boxes = {}

function EVENT:Begin()
    -- If the current map is a cod zombies map, use it's actual mystery box spawn locations!
    local zmSpawns = {}

    zmSpawns.nz_kino_der_toten = {
        {Vector(-1054, 1485, 104), Angle(0, 0, 0)},
        {Vector(-1297, 532, -61), Angle(0, 180, 0)},
        {Vector(-1065, -433, 16), Angle(0, 180, 0)},
        {Vector(739, 360, -80), Angle(0, 0, 0)},
        {Vector(612, 2333, -75), Angle(0, 90, 0)},
        {Vector(2251, 1833, -75), Angle(0, 180, 0)},
        {Vector(2696, 1233, -75), Angle(0, 90, 0)},
        {Vector(1827, -404, 266), Angle(0, 0, 0)},
        {Vector(606, -398, 196), Angle(0, 90, 0)}
    }

    zmSpawns.nz_moon = {
        {Vector(-3839, 179, -238), Angle(0, 180, 0)},
        {Vector(-1270, 1374, -258), Angle(0, 0, 0)},
        {Vector(-80, 460, -615), Angle(0, -90, 0)}
    }

    zmSpawns.nz_tranzit2 = {
        {Vector(290, 144, 0), Angle(0, -90, 0)},
        {Vector(-19, -1175, 128), Angle(0, 180, 0)},
        {Vector(-5578, -4151, -303), Angle(0, 90, 0)},
        {Vector(-4056, 5112, 192), Angle(0, -153, 0)},
        {Vector(4135, 5899, -111), Angle(0, 90, 0)},
        {Vector(7573, -2943, 0), Angle(0, -90, 0)}
    }

    zmSpawns.nz_nacht_der_untoten = {
        {Vector(-432, -450, -815), Angle(0, -52, 0)}
    }

    zmSpawns.nz_der_riese_waw = {
        {Vector(-1046, -1955, 8), Angle(0, -90, 0)},
        {Vector(-1250, -2041, 148), Angle(0, 0, 0)},
        {Vector(32, -3012, 232), Angle(0, 180, 0)},
        {Vector(621, -2049, 10), Angle(0, -90, 0)},
        {Vector(1260, 590, 124), Angle(0, -90, 0)},
        {Vector(678, -224, 8), Angle(0, 180, 0)}
    }

    zmSpawns.nz_motd = {
        {Vector(-711, -980, -231), Angle(0, 180, 0)},
        {Vector(2247, -1202, 208), Angle(0, 90, 0)},
        {Vector(-1572, -4823, -1359), Angle(0, -90, 0)},
        {Vector(-1372, -1522, 0), Angle(0, 0, 0)},
        {Vector(1830, -517, 0), Angle(0, 90, 0)}
    }

    local zombiesMaps = table.GetKeys(zmSpawns)
    local zombiesMap = nil

    for _, map in ipairs(zombiesMaps) do
        if game.GetMap() == map then
            zombiesMap = game.GetMap()
        end
    end

    -- Playing fire sale music and displaying the icon
    net.Start("FireSaleRandomatBegin")
    net.WriteBool(musicCvar:GetBool())
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
    local playerAndBoxPositions = {}
    local boxCount = 0
    local boxCap = #self:GetAlivePlayers()

    for _, ply in ipairs(self:GetAlivePlayers()) do
        table.insert(playerAndBoxPositions, ply:GetPos())
    end

    if zombiesMap then
        for _, posData in ipairs(zmSpawns[zombiesMap]) do
            local box = ents.Create("zombies_mysterybox")
            box:SetPos(posData[1])
            box:SetAngles(posData[2])
            -- Stops the box from removing itself until the fire sale timer is up
            box:SetNWBool("PreventRemove", true)
            box:Spawn()
            box:Arrive()
            table.insert(boxes, box)
        end
    else
        for _, ent in ipairs(ents.GetAll()) do
            local classname = ent:GetClass()
            local pos = ent:GetPos()
            local infoEnt = string.StartWith(classname, "info_")

            -- Using the positions of weapon, ammo and player spawns
            if (string.StartWith(classname, "weapon_") or string.StartWith(classname, "item_") or infoEnt) and not IsValid(ent:GetParent()) and boxCount <= boxCap then
                local tooClose = false

                for _, entPos in ipairs(playerAndBoxPositions) do
                    -- 100 * 100 = 10,000, so any boxes closer than 100 source units to the player are too close to be placed
                    if pos == entPos or math.DistanceSqr(pos.x, pos.y, entPos.x, entPos.y) < 10000 then
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

                    -- Stops the box from removing itself until the fire sale timer is up
                    box:SetNWBool("PreventRemove", true)
                    box:Spawn()
                    box:Arrive()
                    table.insert(boxes, box)
                    table.insert(playerAndBoxPositions, pos)
                end
            end
        end
    end

    -- Strips weapons taking up the same slot as the box weapon when the player goes to pick it up
    -- Else, the player is given nothing when they try to pick up something
    self:AddHook("PlayerUse", function(ply, ent)
        if ent.ClassName == "zombies_box_weapon" then
            local classname = ent:GetNWString("weapon_class", 0)
            local boxWep = weapons.Get(classname)

            for _, wep in ipairs(ply:GetWeapons()) do
                if wep.ClassName and wep.Kind and boxWep.Kind and wep.Kind == boxWep.Kind then
                    ply:StripWeapon(wep.ClassName)
                end
            end
        end
    end)

    -- After 34.4 seconds, the fire sale is over and players can finish their current spin before all boxes are removed
    timer.Create("FireSaleRandomatTimer", 34.4, 1, function()
        for _, box in ipairs(boxes) do
            box:SetNWBool("PreventRemove", false)
        end

        self:AddHook("Think", function()
            for _, box in ipairs(boxes) do
                if IsValid(box) and box:GetNWBool("CanUse") then
                    box:Remove()
                end
            end
        end)
    end)
end

function EVENT:End()
    -- Stopping the music and removing the icon if they're still there
    net.Start("FireSaleRandomatEnd")
    net.Broadcast()
    timer.Remove("FireSaleRandomatTimer")

    -- Remove all boxes and weapons in boxes
    for _, box in ipairs(boxes) do
        if IsValid(box) then
            box:Remove()
        end
    end

    for _, ent in ipairs(ents.FindByClass("zombies_box_weapon")) do
        ent:Remove()
    end

    -- Resetting the box weapons to what they were
    if ogBoxFile then
        file.CreateDir("codzombies")
        file.Write("codzombies/mysterybox.txt", ogBoxFile)
    end

    table.Empty(boxes)
end

-- This event doesn't necessarily need the wonder weapons to work, just the mystery box itself
function EVENT:Condition()
    return scripted_ents.Get("zombies_mysterybox")
end

function EVENT:GetConVars()
    local checks = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return {}, checks
end

Randomat:register(EVENT)