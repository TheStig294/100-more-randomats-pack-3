local EVENT = {}
EVENT.Title = "Sharky and Palp!"
EVENT.Description = "Puts someone with their best traitor partner"
EVENT.id = "sharky"

function EVENT:Begin()
    -- The stats data is recorded from another mod, 'TTT Total Statistics'
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    local stats = util.JSONToTable(data)
    local chosenTraitor = table.Random(self:GetAlivePlayers())
    local id = chosenTraitor:SteamID()
    local nickname = chosenTraitor:Nick()

    -- Compatibility with original stats mod, and the one made for Noxx's custom roles
    if IsValid(stats[id]["TraitorPartners"]) ~= nil then
        traitorStats = stats[id]["TraitorPartners"]
    else
        traitorStats = stats[id]["traitorPartners"]
    end

    local traitorWinRates = {}

    -- Getting the winrates of everyone but the chosen player, while they were partnered with the chosen player
    for i, ply in pairs(self:GetAlivePlayers()) do
        if ply:SteamID() ~= id then
            traitorWinRates[traitorStats[ply:SteamID()]["Wins"] / traitorStats[ply:SteamID()]["Rounds"]] = ply:Nick()
        end
    end

    -- Finding the chosen player's best partner
    local bestTraitorWinRateTable = table.GetKeys(traitorWinRates)
    table.sort(bestTraitorWinRateTable)
    local bestTraitorWinRate = bestTraitorWinRateTable[#bestTraitorWinRateTable]
    local bestTraitorNickname = traitorWinRates[bestTraitorWinRate]
    -- Counting the number of traitors so that number is preserved after the chosen player and their worst partner are made traitors
    local traitorCount = 0

    for i, ply in pairs(self:GetAlivePlayers()) do
        if Randomat:IsTraitorTeam(ply) then
            traitorCount = traitorCount + 1
        end
    end

    -- Setting the chosen player and their best partner to be the traitors
    for i, ply in pairs(self:GetAlivePlayers()) do
        if ply:Nick() == nickname or ply:Nick() == bestTraitorNickname then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetCredits(GetConVar("ttt_credits_starting"):GetInt())
            SendFullStateUpdate()
            traitorCount = traitorCount + 1
        else
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
            SendFullStateUpdate()
        end
    end

    -- Randomly choosing non-traitors to be the remaining traitors
    for i, ply in pairs(self:GetAlivePlayers(true)) do
        if traitorCount > 2 and Randomat:IsTraitorTeam(ply) == false then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetCredits(GetConVar("ttt_credits_starting"):GetInt())
            SendFullStateUpdate()
            traitorCount = traitorCount - 1
        end
    end

    -- Displaying the traitors' winrate
    timer.Simple(5, function()
        self:SmallNotify("The traitors have a " .. math.Round(bestTraitorWinRate * 100) .. "% win rate!")
    end)
end

function EVENT:Condition()
    local traitorCount = 0

    for i, ply in pairs(self:GetAlivePlayers()) do
        if Randomat:IsTraitorTeam(ply) then
            traitorCount = traitorCount + 1
        end
    end
    -- Trigger when there is more than 1 traitor, and 'TTT Total Statistics' is installed

    return traitorCount > 1 and file.Exists("gamemodes/terrortown/entities/entities/ttt_total_statistics/init.lua", "THIRDPARTY")
end

Randomat:register(EVENT)