local EVENT = {}
EVENT.Title = "Sharky and also Palp!"
EVENT.Description = "Puts someone with their best traitor partner!"
EVENT.id = "sharky2"

function EVENT:Begin()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = randomatPlayerStats
    local chosenTraitor

    for _, ply in pairs(self:GetAlivePlayers(true)) do
        local ID = ply:SteamID()

        if stats[ID] and (stats[ID]["TraitorPartners"] or stats[ID]["traitorPartners"]) then
            chosenTraitor = ply
            break
        end
    end

    local ID = chosenTraitor:SteamID()
    local nickname = chosenTraitor:Nick()
    local traitorStats

    -- Compatibility with original stats mod, and the one made for Noxx's custom roles
    if stats[ID]["TraitorPartners"] ~= nil then
        traitorStats = stats[ID]["TraitorPartners"]
    else
        traitorStats = stats[ID]["traitorPartners"]
    end

    local traitorWinRates = {}

    -- Getting the winrates of everyone but the chosen player, while they were partnered with the chosen player
    for i, ply in pairs(self:GetAlivePlayers()) do
        local plyID = ply:SteamID()

        if traitorStats[plyID] and plyID ~= ID then
            traitorWinRates[traitorStats[plyID]["Wins"] / traitorStats[plyID]["Rounds"]] = ply:Nick()
        end
    end

    -- Finding the chosen player's best partner
    local bestTraitorWinRateTable = table.GetKeys(traitorWinRates)
    table.sort(bestTraitorWinRateTable)
    local bestTraitorWinRate = bestTraitorWinRateTable[#bestTraitorWinRateTable]
    local bestTraitorNickname = traitorWinRates[bestTraitorWinRate]
    -- Counting the number of traitors so that number is preserved after the chosen player and their worst partner are made traitors
    local traitorCount = 0

    for _, ply in pairs(self:GetAlivePlayers()) do
        if Randomat:IsTraitorTeam(ply) then
            traitorCount = traitorCount + 1
        end
    end

    -- Setting the chosen player and their best partner to be the traitors
    for _, ply in pairs(self:GetAlivePlayers()) do
        if ply:Nick() == nickname or ply:Nick() == bestTraitorNickname then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            ply:SetCredits(GetConVar("ttt_credits_starting"):GetInt())
            SendFullStateUpdate()
        else
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
            SendFullStateUpdate()
        end
    end

    -- Randomly choosing non-traitors to be the remaining traitors
    for _, ply in pairs(self:GetAlivePlayers(true)) do
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

Randomat:register(EVENT)