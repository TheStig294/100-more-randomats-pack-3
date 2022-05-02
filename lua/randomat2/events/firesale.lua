local EVENT = {}
EVENT.Title = "Fire Sale"
EVENT.Description = "Get to a box, quick!"
EVENT.id = "firesale"

EVENT.Categories = {"biased_traitor", "biased", "item", "entityspawn", "moderateimpact"}

util.AddNetworkString("FireSaleRandomatBegin")
util.AddNetworkString("FireSaleRandomatEnd")

local wonderWeapons = {"tfa_wunderwaffe", "tfa_wavegun", "tfa_staff_wind", "tfa_shrinkray", "tfa_vr11", "tfa_wintershowl", "tfa_thundergun", "tfa_staff_lightning", "tfa_sliquifier", "tfa_scavenger", "tfa_raygun_mark2", "tfa_raygun", "tfa_jetgun", "tfa_blundergat", "tfa_acidgat"}

local ogBoxFile
local boxes = {}

function EVENT:Begin()
    -- Playing fire sale music and displaying the icon
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
    local playerAndBoxPositions = {}
    local boxCount = 0
    local playerCount = #self:GetAlivePlayers()

    for _, ply in ipairs(self:GetAlivePlayers()) do
        table.insert(playerAndBoxPositions, ply:GetPos())
    end

    for _, ent in ipairs(ents.GetAll()) do
        local classname = ent:GetClass()
        local pos = ent:GetPos()
        local infoEnt = string.StartWith(classname, "info_")

        -- Using the positions of weapon, ammo and player spawns
        if (string.StartWith(classname, "weapon_") or string.StartWith(classname, "item_") or infoEnt) and not IsValid(ent:GetParent()) and boxCount <= playerCount then
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
                -- Stops the box from removing itself until the fire sale timer is up
                box:SetNWString("PreventRemove", "true")
                box:SetPos(pos + Vector(0, 0, 5))

                -- Don't remove player spawn points
                if not infoEnt then
                    ent:Remove()
                end

                box:Spawn()
                box:Arrive()
                table.insert(boxes, box)
                table.insert(playerAndBoxPositions, pos)
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
            box:SetNWString("PreventRemove", "false")
        end

        self:AddHook("Think", function()
            for _, box in ipairs(boxes) do
                if IsValid(box) and box:GetNWString("CanUse", "false") == "true" then
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

Randomat:register(EVENT)