local EVENT = {}
EVENT.Title = "Gotta buy 'em all!"
EVENT.Description = "Gives a weapon you haven't bought, or reward for buying them all!"
EVENT.id = "buyemall"
-- Let this randomat trigger again at the start of a new map
local notTriggered = true

function EVENT:Begin()
    -- This randomat can only trigger once per map
    notTriggered = false
    -- Getting the stats recorded by 'TTT Total Statistics'
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    stats = util.JSONToTable(data)
    -- Getting useable lists of all the buyable detective and traitor weapons
    local detectiveBuyableKeyed = GetDetectiveBuyable()
    local traitorBuyableKeyed = GetTraitorBuyable()
    local detectiveBuyable = table.ClearKeys(detectiveBuyableKeyed)
    local traitorBuyable = table.ClearKeys(traitorBuyableKeyed)
    -- Finally, reset the table of players that have bought every weapon at least once
    local boughtEmAllPlayers = {}

    for i, ply in pairs(self:GetPlayers()) do
        timer.Simple(0.1, function()
            local id = ply:SteamID()
            local detectiveStats = stats[id]["DetectiveEquipment"]
            local traitorStats = stats[id]["TraitorEquipment"]
            local detectiveBought = table.GetKeys(detectiveStats)
            local traitorBought = table.GetKeys(traitorStats)
            local detectiveBuyableCount = #detectiveBuyable
            local traitorBuyableCount = #traitorBuyable

            for k = 1, #detectiveBought do
                table.RemoveByValue(detectiveBuyable, detectiveBought[k])
            end

            for k = 1, #traitorBought do
                table.RemoveByValue(traitorBuyable, traitorBought[k])
            end

            boughtAllTraitor = false
            boughtAllDetective = false

            if table.IsEmpty(traitorBuyable) then
                ply:ChatPrint("Congrats! You have bought every traitor item, your health has been doubled!")
                ply:SetMaxHealth(ply:GetMaxHealth() * 2)
                ply:SetHealth(ply:GetMaxHealth())
            else
                PrintToGive(traitorBuyable[math.random(#traitorBuyable)], ply)
                ply:ChatPrint("You haven't bought every traitor item at least once. \n(" .. math.Round((#traitorBought / traitorBuyableCount) * 100) .. "% complete)")
            end

            if table.IsEmpty(detectiveBuyable) then
                ply:ChatPrint("Congrats! You have bought every detective item, your health has been doubled!")
                ply:SetMaxHealth(ply:GetMaxHealth() * 2)
                ply:SetHealth(ply:GetMaxHealth())
            else
                PrintToGive(detectiveBuyable[math.random(#detectiveBuyable)], ply)
                ply:ChatPrint("You haven't bought every detective item at least once. \n(" .. math.Round((#detectiveBought / detectiveBuyableCount) * 100) .. "% complete)")
            end

            if boughtAllTraitor and boughtAllDetective then
                ply:ChatPrint("Congrats! You bought em all! You get to choose every randomat until the next map! \n(Unless you have to take turns with anyone else that has bought em all)")
                table.insert(boughtEmAllPlayers, ply)
            end
        end)
    end

    if table.IsEmpty(boughtEmAllPlayers) == false then
        hook.Add("TTTEndRound", "BoughtEmAllRandomatOn", function()
            GetConVar("ttt_randomat_auto"):SetBool(true)
            GetConVar("randomat_choose_vote"):SetBool(true)
        end)

        hook.Add("TTTPrepareRound", "BoughtEmAllRandomatOff", function()
            GetConVar("ttt_randomat_auto"):SetBool(false)
            GetConVar("randomat_choose_vote"):SetBool(false)
        end)

        hook.Add("TTTBeginRound", "BoughtEmAllRandomat", function()
            Randomat:TriggerEvent("choose", table.Random(boughtEmAllPlayers))
        end)
    end
end

function EVENT:Condition()
    local has_data = true

    if file.Read("ttt/ttt_total_statistics/stats.txt", "DATA") == nil then
        has_data = false
    end

    return notTriggered and has_data
end

Randomat:register(EVENT)