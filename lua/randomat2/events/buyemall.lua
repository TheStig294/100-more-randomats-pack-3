local EVENT = {}
EVENT.Title = "Gotta buy 'em all!"
EVENT.Description = "Gives a weapon you haven't bought, or a special reward for buying them all!"
EVENT.id = "buyemall"
-- Let this randomat trigger again at the start of a new map
local notTriggered = true

function EVENT:Begin()
    -- This randomat can only trigger once per map
    notTriggered = false
    local data = file.Read("ttt/ttt_total_statistics/stats.txt", "DATA")
    local stats = util.JSONToTable(data)
    -- Functionality of GetDetectiveBuyable() and GetTraitorBuyable() can be found in stig_randomat_base_functions.lua and stig_randomat_client_functions.lua
    local detectiveBuyableKeyed = GetDetectiveBuyable()
    local traitorBuyableKeyed = GetTraitorBuyable()
    local detectiveBuyable = table.ClearKeys(detectiveBuyableKeyed)
    local traitorBuyable = table.ClearKeys(traitorBuyableKeyed)
    -- Get the no. of detective/traitor weapons, used for the percentage complete printed to chat
    local detectiveBuyableCount = #detectiveBuyable
    local traitorBuyableCount = #traitorBuyable
    local boughtEmAllPlayers = {}

    for i, ply in pairs(self:GetPlayers()) do
        local boughtAllDetective = false
        local boughtAllTraitor = false
        -- Use SteamID(), not SteamID64() as that's how players are indexed in the stats data file
        local id = ply:SteamID()
        -- Grab tables of all detective/traitor items the player has ever bought
        local detectiveBought = table.GetKeys(stats[id]["DetectiveEquipment"])
        local traitorBought = table.GetKeys(stats[id]["TraitorEquipment"])

        -- Remove all bought weapons from the possible list of weapons to give out
        for k = 1, #detectiveBought do
            table.RemoveByValue(detectiveBuyable, detectiveBought[k])
        end

        for k = 1, #traitorBought do
            table.RemoveByValue(traitorBuyable, traitorBought[k])
        end

        -- Check if the player has bought all of either detective or traitor items at least once
        if table.IsEmpty(detectiveBuyable) then
            boughtAllDetective = true
        end

        if table.IsEmpty(traitorBuyable) then
            boughtAllTraitor = true
        end

        if boughtAllDetective and boughtAllTraitor then
            table.insert(boughtEmAllPlayers, ply)
            ply:ChatPrint("==CONGRATS! YOU BOUGHT 'EM ALL!==\nYou get to choose randomats at the start of each round!")

            timer.Simple(5, function()
                Randomat:SmallNotify("Someone has bought 'em all!")
            end)
        elseif boughtAllDetective and not boughtAllTraitor then
            ply:SetMaxHealth(ply:GetMaxHealth() * 2)
            ply:SetHealth(ply:GetMaxHealth())
            ply:ChatPrint("Congrats! You have bought every detective item, your health has been doubled!")
            -- Give them a traitor weapon they haven't bought before
            -- PrintToGive() takes a weapon's print name, a player and gives them the weapon, found in stig_randomat_base_functions.lua
            PrintToGive(traitorBuyable[math.random(#traitorBuyable)], ply)
            ply:ChatPrint("However, you haven't bought every traitor item at least once. \n(" .. math.Round((#traitorBought / traitorBuyableCount) * 100) .. "% complete)\nBuy them all for the REAL reward...")
        elseif not boughtAllDetective and boughtAllTraitor then
            ply:SetMaxHealth(ply:GetMaxHealth() * 2)
            ply:SetHealth(ply:GetMaxHealth())
            ply:ChatPrint("Congrats! You have bought every traitor item, your health has been doubled!")
            -- Give them a traitor weapon they haven't bought before
            PrintToGive(detectiveBuyable[math.random(#detectiveBuyable)], ply)
            ply:ChatPrint("You haven't bought every detective item at least once. \n(" .. math.Round((#detectiveBought / detectiveBuyableCount) * 100) .. "% complete)\nBuy them all for the REAL reward...")
        else
            -- If the player hasn't bought every detective nor traitor item at least once, give them a random detective and traitor item they haven't bought before
            PrintToGive(detectiveBuyable[math.random(#detectiveBuyable)], ply)
            PrintToGive(traitorBuyable[math.random(#traitorBuyable)], ply)
            ply:ChatPrint("(Detective items: " .. math.Round((#detectiveBought / detectiveBuyableCount) * 100) .. "% complete)\n(Traitor items: " .. math.Round((#traitorBought / traitorBuyableCount) * 100) .. "% complete)")
        end
    end

    local autoRandomat = GetConVar("ttt_randomat_auto"):GetBool()
    local choices = GetConVar("randomat_choose_choices"):GetInt()
    local vote = GetConVar("randomat_choose_vote"):GetBool()

    if table.IsEmpty(boughtEmAllPlayers) == false then
        GetConVar("ttt_randomat_auto"):SetBool(false)
        GetConVar("randomat_choose_choices"):SetInt(5)
        -- Only allow the player who the randomat triggers off of to choose randomats
        GetConVar("randomat_choose_vote"):SetBool(false)

        -- At the start of every round, for the rest of the current map, a random player that bought every weapon gets to choose the randomat for that round
        hook.Add("TTTBeginRound", "BoughtEmAllRandomat", function()
            Randomat:SilentTriggerEvent("choose", table.Random(boughtEmAllPlayers))
        end)

        -- Once the map is changing or the server is being shut down, all convars are reset
        hook.Add("ShutDown", "BoughtEmAllConVarReset", function()
            GetConVar("ttt_randomat_auto"):SetBool(autoRandomat)
            GetConVar("randomat_choose_choices"):SetInt(choices)
            GetConVar("randomat_choose_vote"):SetBool(vote)
        end)
    end
end

function EVENT:Condition()
    -- This event is reliant on 'Choose an Event!' existing and being turned on and 'TTT Total Statistics' being installed
    return notTriggered and Randomat:CanEventRun("choose") and file.Exists("gamemodes/terrortown/entities/entities/ttt_total_statistics/init.lua", "THIRDPARTY")
end

Randomat:register(EVENT)