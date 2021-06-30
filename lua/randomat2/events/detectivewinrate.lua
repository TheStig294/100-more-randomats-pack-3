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
        if stats[ply:SteamID()]["DetectiveWins"] ~= nil then
            detectiveStats[stats[ply:SteamID()]["DetectiveWins"] / stats[ply:SteamID()]["DetectiveRounds"]] = ply:Nick()
        else
            detectiveStats[stats[ply:SteamID()]["detectiveWins"] / stats[ply:SteamID()]["detectiveRounds"]] = ply:Nick()
        end
    end

    -- Grabbing the Steam nickname of the player with the highest detective winrate
    local bestDetectiveTable = table.GetKeys(detectiveStats)
    table.sort(bestDetectiveTable)
    local bestDetectiveWinRate = bestDetectiveTable[#bestDetectiveTable]
    local bestDetectiveNickname = detectiveStats[bestDetectiveWinRate]
    local detectiveChanged = false

    -- Turn a current detective into an innocent, if there is one
    for i, ply in pairs(self:GetAlivePlayers()) do
        if ply:GetRole() == ROLE_DETECTIVE and detectiveChanged == false then
            Randomat:SetRole(ply, ROLE_INNOCENT)
            self:StripRoleWeapons(ply)
            SendFullStateUpdate()
            detectiveChanged = true
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
            traitorChanged = false
        end
    end

    --Notifying everyone of the detective's winrate
    timer.Simple(5, function()
        self:SmallNotify(bestDetectiveNickname .. " is the detective with a " .. math.Round(bestDetectiveWinRate * 100) .. "% win rate!")
    end)
end

function EVENT:Condition()
    -- Trigger when 'TTT Total Statistics' is installed
    return file.Exists("gamemodes/terrortown/entities/entities/ttt_total_statistics/init.lua", "THIRDPARTY")
end

Randomat:register(EVENT)