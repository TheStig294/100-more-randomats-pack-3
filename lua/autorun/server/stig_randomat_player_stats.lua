-- Stats table is global, so any mod can use it
randomatPlayerStats = {}
local fileContent

-- Create stats file if it doesn't exist
if file.Exists("randomat/playerstats.txt", "DATA") then
    fileContent = file.Read("randomat/playerstats.txt")
    randomatPlayerStats = util.JSONToTable(fileContent) or {}
else
    file.CreateDir("randomat")
    file.Write("randomat/playerstats.txt", randomatPlayerStats)
end

-- Setup all entries for every player as they connect
-- This *should* ensure all players have every needed key in the stats table, so we should never try to index a nil value in the table
hook.Add("PlayerInitialSpawn", "RandomatStatsFillPlayerIDs", function(ply, transition)
    local ID = ply:SteamID()

    if not randomatPlayerStats[ID] then
        randomatPlayerStats[ID] = {}
    end

    if not randomatPlayerStats[ID]["EquipmentItems"] then
        randomatPlayerStats[ID]["EquipmentItems"] = {}
    end
end)

-- Keeps track of the number of times any player has bought any one buy menu item
hook.Add("TTTOrderedEquipment", "RandomatStatsOrderedEquipment", function(ply, equipment, is_item)
    local ID = ply:SteamID()

    -- Passive items are indexed by their print name, if it exists
    if is_item then
        local itemName = GetEquipmentItemById(equipment).name

        if itemName then
            local equipmentCount = randomatPlayerStats[ID]["EquipmentItems"][itemName]

            if equipmentCount then
                equipmentCount = equipmentCount + 1
                randomatPlayerStats[ID]["EquipmentItems"][itemName] = equipmentCount
            else
                randomatPlayerStats[ID]["EquipmentItems"][itemName] = 1
            end
        end
    else
        -- Active items are indexed by their classname, which this hook passes by itself
        local equipmentCount = randomatPlayerStats[ID]["EquipmentItems"][equipment]

        if equipmentCount then
            equipmentCount = equipmentCount + 1
            randomatPlayerStats[ID]["EquipmentItems"][equipment] = equipmentCount
        else
            randomatPlayerStats[ID]["EquipmentItems"][equipment] = 1
        end
    end
end)

-- Record all stats in file when server shuts down/changes maps
hook.Add("ShutDown", "RecordStigRandomatStats", function(winType)
    fileContent = util.TableToJSON(randomatPlayerStats)
    file.Write("randomat/playerstats.txt", fileContent)
end)