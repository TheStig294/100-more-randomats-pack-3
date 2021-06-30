local EVENT = {}
EVENT.Title = "Everyone has their favourites"
EVENT.Description = "Gives your most bought traitor + detective item, unless they take the same slot"
EVENT.id = "favourites"

function EVENT:Begin()
    -- The stats data is recorded from another mod, 'TTT Total Statistics'
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    local stats = util.JSONToTable(data)

    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            local id = ply:SteamID()
            local detectiveStats = stats[id]["DetectiveEquipment"]
            local traitorStats = stats[id]["TraitorEquipment"]
            -- Set every player's buy count of the radar and body armour to 0 to prevent these from always being a player's most bought item
            -- Also effectively sets the player's most bought item to the body armour as a fail-safe if the player has never bought anything before
            detectiveStats["Radar"] = 0
            detectiveStats["Body Armor"] = 0
            traitorStats["Radar"] = 0
            traitorStats["Body Armor"] = 0
            -- Gets the print name of their most bought traitor and detective item
            local detectiveItemName = table.GetWinningKey(detectiveStats)
            local traitorItemName = table.GetWinningKey(traitorStats)

            -- The most bought item between the detective and traitor equipment is given first
            if detectiveStats[detectiveItemName] >= traitorStats[traitorItemName] then
                PrintToGive(detectiveItemName, ply)

                -- If they're about to be given the body armour a second time, give them the radar instead
                if detectiveItemName == "Body Armor" and traitorItemName == "Body Armor" then
                    PrintToGive("Radar", ply)
                else
                    PrintToGive(traitorItemName, ply)
                end
            else
                PrintToGive(traitorItemName, ply)

                if traitorItemName == "Body Armor" and detectiveItemName == "Body Armor" then
                    PrintToGive("Radar", ply)
                else
                    PrintToGive(detectiveItemName, ply)
                end
            end
        end)
    end
end

function EVENT:Condition()
    -- Trigger when 'TTT Total Statistics' is installed
    return file.Exists("gamemodes/terrortown/entities/entities/ttt_total_statistics/init.lua", "THIRDPARTY")
end

Randomat:register(EVENT)