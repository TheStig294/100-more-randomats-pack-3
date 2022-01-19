local EVENT = {}
EVENT.Title = "100% Detective Winrate"
EVENT.Description = "Whoever has the highest detective winrate is now the detective!"
EVENT.id = "detectivewinrate"

function EVENT:Begin()
    -- The stats data is recorded from another mod, 'TTT Total Statistics'
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    local stats = util.JSONToTable(data)
    local detectiveStats = {}

    -- Grabbing everyone's detective winrate, 'Detective' is capitalised in the old version of TTT Total Statistics
    for i, ply in pairs(self:GetAlivePlayers()) do
        -- And check detective rounds are not 0 so we're not dividing by 0
        if stats[ply:SteamID()] and stats[ply:SteamID()]["DetectiveWins"] and stats[ply:SteamID()]["DetectiveRounds"] ~= 0 then
            detectiveStats[stats[ply:SteamID()]["DetectiveWins"] / stats[ply:SteamID()]["DetectiveRounds"]] = ply:Nick()
        elseif stats[ply:SteamID()] and stats[ply:SteamID()]["detectiveWins"] and stats[ply:SteamID()]["detectiveRounds"] ~= 0 then
            detectiveStats[stats[ply:SteamID()]["detectiveWins"] / stats[ply:SteamID()]["detectiveRounds"]] = ply:Nick()
        end
    end

    -- Grabbing the Steam nickname of the player with the highest detective winrate
    local bestDetectiveTable = table.GetKeys(detectiveStats)
    table.sort(bestDetectiveTable)
    local bestDetectiveWinRate = bestDetectiveTable[#bestDetectiveTable]
    local bestDetectiveNickname = detectiveStats[bestDetectiveWinRate]

    -- Turn a current detective into an innocent, if there is one
    for i, ply in pairs(self:GetAlivePlayers()) do
        if Randomat:IsGoodDetectiveLike(ply) then
            Randomat:SetRole(ply, ROLE_INNOCENT)
            self:StripRoleWeapons(ply)
            SendFullStateUpdate()
            break
        end
    end

    local traitorChanged = false

    -- Make the player with the highest winrate a detective
    for i, ply in pairs(self:GetAlivePlayers()) do
        if ply:Nick() == bestDetectiveNickname then
            if Randomat:IsTraitorTeam(ply) then
                traitorChanged = true
            end

            Randomat:SetRole(ply, ROLE_DETECTIVE)
            self:StripRoleWeapons(ply)
            ply:SetCredits(GetConVar("ttt_det_credits_starting"):GetInt())
            SendFullStateUpdate()
        end
    end

    -- If a traitor was made the detective, change a random non-traitor, non-detective into traitor
    for i, ply in pairs(self:GetAlivePlayers(true)) do
        if traitorChanged and not Randomat:IsTraitorTeam(ply) and not Randomat:IsDetectiveLike(ply) then
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetCredits(GetConVar("ttt_credits_starting"):GetInt())
            SendFullStateUpdate()
            break
        end
    end

    --Notifying everyone of the detective's winrate
    timer.Simple(5, function()
        self:SmallNotify(bestDetectiveNickname .. " is the detective with a " .. math.Round(bestDetectiveWinRate * 100) .. "% win rate!")
    end)
end

function EVENT:Condition()
    -- First check the stats mod is installed
    if not file.Exists("gamemodes/terrortown/entities/entities/ttt_total_statistics/init.lua", "THIRDPARTY") then return false end
    -- Next check the stats file actually exists
    if not file.Exists("ttt/ttt_total_statistics/stats.txt", "DATA") then return false end
    -- Next check the stats this randomat uses exist
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    local stats = util.JSONToTable(data)
    local validStatsPlayers = self:GetAlivePlayers()

    -- Getting a table of all players with valid stats
    for i, ply in pairs(self:GetAlivePlayers()) do
        local invalidStats = false

        if not (stats[ply:SteamID()]) then
            invalidStats = true
        end

        if not ((stats[ply:SteamID()]["DetectiveWins"] and stats[ply:SteamID()]["DetectiveRounds"]) or (stats[ply:SteamID()]["detectiveWins"] and stats[ply:SteamID()]["detectiveRounds"])) then
            invalidStats = true
        end

        if stats[ply:SteamID()]["DetectiveRounds"] == 0 or stats[ply:SteamID()]["detectiveRounds"] == 0 then
            invalidStats = true
        end

        if invalidStats then
            table.RemoveByValue(validStatsPlayers, ply)
        end
    end
    -- So long as SOMEONE has a valid detective winrate, this event can run

    return not table.IsEmpty(validStatsPlayers)
end

Randomat:register(EVENT)