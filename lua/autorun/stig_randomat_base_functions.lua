--Disabling fg addon's chat message to clear up chat box for randomat alerts (if installed)
RunConsoleCommand("ttt_fgaddons_textmessage", "0")
local randomatRandomSeed = GetGlobalBool("RandomatRandomisationSeeding", true)

--Seeding random numbers in Garry's Mod to help with the same randomats being picked over and over, running only once
if randomatRandomSeed then
    math.randomseed(os.time())

    -- Pre-emptively calculating unused random numbers to improve the randomness when math.random() is actually used
    for i = 1, 2000 do
        math.random()
    end

    -- Now disabling math.randomseed for everyone else so the good randomness just built up isn't reset
    function math.randomseed(seed)
    end

    randomatRandomSeed = false
end

--Renaming print names of weapons the same way as 'TTT Total Statistics' for compatibility
local function RenameWeps(name)
    if name == "sipistol_name" then
        return "Silenced Pistol"
    elseif name == "knife_name" then
        return "Knife"
    elseif name == "newton_name" then
        return "Newton Launcher"
    elseif name == "tele_name" then
        return "Teleporter"
    elseif name == "hstation_name" then
        return "Health Station"
    elseif name == "flare_name" then
        return "Flare Gun"
    elseif name == "decoy_name" then
        return "Decoy"
    elseif name == "radio_name" then
        return "Radio"
    elseif name == "polter_name" then
        return "Poltergeist"
    elseif name == "vis_name" then
        return "Visualizer"
    elseif name == "defuser_name" then
        return "Defuser"
    elseif name == "stungun_name" then
        return "UMP Prototype"
    elseif name == "binoc_name" then
        return "Binoculars"
    elseif name == "item_radar" then
        return "Radar"
    elseif name == "item_armor" then
        return "Body Armor"
    elseif name == "item_disg" then
        return "Disguiser"
    elseif name == "dragon_elites_name" then
        return "Dragon Elites"
    elseif name == "silenced_m4a1_name" then
        return "Silenced M4A1"
    elseif name == "slam_name" then
        return "M4 SLAM"
    elseif name == "jihad_bomb_name" then
        return "Jihad Bomb"
    elseif name == "item_slashercloak" then
        --custom mods friends and I made ;)
        return "Slasher Cloak"
    elseif name == "heartbeat_monitor_name" then
        return "Heartbeat Monitor"
    else
        return name
    end
end

if SERVER then
    util.AddNetworkString("RandomatDetectiveWeaponsList")
    util.AddNetworkString("RandomatTraitorWeaponsList")
    util.AddNetworkString("Randomat_SendDetectiveEquipmentName")
    util.AddNetworkString("Randomat_SendTraitorEquipmentName")
    util.AddNetworkString("Randomat_DoneSendingDetectiveItems")
    util.AddNetworkString("Randomat_DoneSendingTraitorItems")
    local detectiveBuyable = {}
    local traitorBuyable = {}

    --At the start of the first round of a map, ask the first connected client for the printnames of all detective and traitor weapons
    --Used by randomats that use 'TTT Total Statistics'
    --Needed since 'TTT Total Statistics' stores weapon stats identifying weapons by printnames, not classnames
    hook.Add("TTTBeginRound", "RandomatInitialClientQueries", function()
        net.Start("RandomatDetectiveWeaponsList")
        net.Send(Entity(1))
        net.Start("RandomatTraitorWeaponsList")
        net.Send(Entity(1))
        hook.Remove("TTTBeginRound", "RandomatInitialClientQueries")
    end)

    local doneDetectiveItems = false

    net.Receive("Randomat_SendDetectiveEquipmentName", function(len, ply)
        tbl = string.Split(net.ReadString(), ",")
        local name = RenameWeps(tbl[1])
        detectiveBuyable[tbl[2]] = name
    end)

    net.Receive("Randomat_DoneSendingDetectiveItems", function()
        doneDetectiveItems = true
    end)

    local doneTraitorItems = false

    net.Receive("Randomat_SendTraitorEquipmentName", function(len, ply)
        tbl = string.Split(net.ReadString(), ",")
        local name = RenameWeps(tbl[1])
        traitorBuyable[tbl[2]] = name
    end)

    net.Receive("Randomat_DoneSendingTraitorItems", function()
        doneTraitorItems = true
    end)

    function GetDetectiveBuyable()
        return detectiveBuyable
    end

    function GetTraitorBuyable()
        return traitorBuyable
    end

    function DoneSendingDetectiveTraitorBuyable()
        return doneDetectiveItems and doneTraitorItems
    end

    -- Disabling all events that are disabled by default once (So they can be turned back on if you still want them)
    hook.Add("TTTPrepareRound", "RandomatDisableEventsOnce", function()
        if not file.Exists("randomat/disabled_events.txt", "DATA") then
            file.Write("randomat/disabled_events.txt")
        end

        local readFile = file.Read("randomat/disabled_events.txt", "DATA")
        local disabledEvents = string.Explode("\n", readFile)
        local eventsToDisable = {}

        for id, event in pairs(Randomat.Events) do
            if event.IsEnabled == false then
                table.insert(eventsToDisable, id)

                if not table.HasValue(disabledEvents, id) then
                    RunConsoleCommand("ttt_randomat_" .. id, "0")
                    table.insert(disabledEvents, id)
                end
            end
        end

        file.Write("randomat/disabled_events.txt", table.concat(disabledEvents, "\n"))
        hook.Remove("TTTPrepareRound", "RandomatDisableEventsOnce")
    end)
end

-- Returns whether or not the current map has a navmesh. Used for randomats that use ai-based weapons that need a navmesh to work, such as the guard dog or killer snail randomats
function MapHasAI()
    return file.Exists("maps/" .. game.GetMap() .. ".nav", "GAME")
end

-- Takes 2 players and checks if they are on the same team, checking one team at a time
function IsSameTeam(attacker, victim)
    if (Randomat:IsInnocentTeam(attacker, false) and Randomat:IsInnocentTeam(victim, false)) or (Randomat:IsTraitorTeam(attacker) and Randomat:IsTraitorTeam(victim)) or (Randomat:IsMonsterTeam(attacker) and Randomat:IsMonsterTeam(victim)) then
        return true
    else
        return false
    end
end

function IsBuyableItem(role, wep, includeWepsExist, excludeWepsExist)
    --when player buys an item, first check if its on the SWEP list
    local classname = wep.ClassName
    local id = wep.id

    if isstring(classname) and wep.CanBuy then
        -- Also take into account the weapon exclude and include lists from Custom Roles, if they exist
        if includeWepsExist then
            for i, includedWep in ipairs(WEPS.BuyableWeapons[role]) do
                if classname == includedWep then return true end
            end
        end

        if excludeWepsExist then
            for i, excludedWep in ipairs(WEPS.ExcludeWeapons[role]) do
                if classname == excludedWep then return false end
            end
        end

        if table.HasValue(wep.CanBuy, role) then return true end
        --if its not on the SWEP list, then check the equipment item menu for the role
    elseif isnumber(id) then
        id = tonumber(id)

        if includeWepsExist then
            for i, includedWep in ipairs(WEPS.BuyableWeapons[role]) do
                if id == includedWep then return true end
            end
        end

        if excludeWepsExist then
            for i, excludedWep in ipairs(WEPS.ExcludeWeapons[role]) do
                if id == excludedWep then return false end
            end
        end

        return true
    end

    return false
end

-- Functions to set/reset playermodels without having to deal with networking
-- Other than avoiding jankyness with the timing of net messages, 
-- this function ensures playermodel changing randomats reset players to their actual playermodels
-- when multiple playermodel changing randomats trigger in one round
function GetPlayerModelData(ply)
    local data = {}
    data.model = ply:GetModel()
    data.viewOffset = ply:GetViewOffset()
    data.viewOffsetDucked = ply:GetViewOffsetDucked()
    data.playerColor = ply:GetPlayerColor()
    data.skin = ply:GetSkin()
    data.bodyGroups = ply:GetBodyGroups()
    data.bodygroupValues = {}

    for _, value in ipairs(ply:GetBodyGroups()) do
        data.bodygroupValues[value.id] = ply:GetBodygroup(value.id)
    end

    return data
end

local playermodelData = {}

hook.Add("TTTBeginRound", "RandomatGetBeginPlayermodels", function()
    for _, ply in ipairs(player.GetAll()) do
        playermodelData[ply] = GetPlayerModelData(ply)
    end
end)

function ForceSetPlayermodel(ply, data)
    if IsPlayer(ply) then
        -- If just a model by itself is passed, just set the model and leave it at that
        if not istable(data) then
            if (not isstring(data)) or not util.IsValidModel(data) then return end
            FindMetaTable("Entity").SetModel(ply, data)

            return
        end

        -- Else, set everything that's in the data table
        if util.IsValidModel(data.model) then
            FindMetaTable("Entity").SetModel(ply, data.model)
        end

        if data.playerColor then
            ply:SetPlayerColor(data.playerColor)
        end

        if data.skin then
            ply:SetSkin(data.skin)
        end

        if data.bodyGroups then
            for _, value in pairs(data.bodyGroups) do
                ply:SetBodygroup(value.id, data.bodygroupValues[value.id])
            end
        elseif data.bodygroupValues then
            for id = 0, #data.bodygroupValues do
                ply:SetBodygroup(id, data.bodygroupValues[id])
            end
        end

        timer.Simple(0.1, function()
            if data.viewOffset then
                ply:SetViewOffset(data.viewOffset)
            else
                ply:SetViewOffset(Vector(0, 0, 64))
            end

            if data.viewOffsetDucked then
                ply:SetViewOffsetDucked(data.viewOffsetDucked)
            else
                ply:SetViewOffsetDucked(Vector(0, 0, 28))
            end
        end)
    end
end

function ForceResetAllPlayermodels()
    for _, ply in ipairs(player.GetAll()) do
        if playermodelData[ply] then
            ForceSetPlayermodel(ply, playermodelData[ply])
        end
    end
end

function SetToBasicRole(ply)
    if Randomat:IsTraitorTeam(ply) then
        Randomat:SetRole(ply, ROLE_TRAITOR)
    elseif Randomat:IsGoodDetectiveLike(ply) then
        Randomat:SetRole(ply, ROLE_DETECTIVE)
    else
        Randomat:SetRole(ply, ROLE_INNOCENT)
    end

    ply:Give("weapon_zm_improvised")
    ply:Give("weapon_zm_carry")
    ply:Give("weapon_ttt_unarmed")
end

function IsBodyDependentRole(ply)
    local role = ply:GetRole()
    if role == ROLE_PARASITE and ConVarExists("ttt_parasite_respawn_mode") and GetConVar("ttt_parasite_respawn_mode"):GetInt() == 1 then return true end

    return role == ROLE_MADSCIENTIST or role == ROLE_HYPNOTIST or role == ROLE_BODYSNATCHER or role == ROLE_PARAMEDIC or role == ROLE_PHANTOM or role == ROLE_TAXIDERMIST
end

function IsMeleeDamageRole(ply)
    local role = ply:GetRole()

    return role == ROLE_ZOMBIE or role == ROLE_KILLER or role == ROLE_MADSCIENTIST
end

function IsKillCommandSensitiveRole(ply)
    local role = ply:GetRole()

    return role == ROLE_MADSCIENTIST or role == ROLE_ZOMBIE or role == ROLE_PARASITE or role == ROLE_REVENGER or role == ROLE_PHANTOM
end

function MapHasProps()
    local propCount = table.Count(ents.FindByClass("prop_physics*")) + table.Count(ents.FindByClass("prop_dynamic"))

    return propCount > 5
end

function GiveEquipmentByIdOrClass(ply, equipment, wepKind)
    local weapon = weapons.Get(equipment)
    local is_item = not weapon

    if is_item then
        local detectiveItem = false
        local traitorItem = false

        for _, equ in ipairs(EquipmentItems[ROLE_DETECTIVE]) do
            if equ.name == equipment then
                if equ.id then
                    detectiveItem = true
                    equipment = equ.id
                end

                break
            end
        end

        if not detectiveItem then
            for _, equ in ipairs(EquipmentItems[ROLE_TRAITOR]) do
                if equ.name == equipment then
                    if equ.id then
                        traitorItem = true
                        equipment = equ.id
                    end

                    break
                end
            end
        end

        -- If the item can't be found, give them a radar as a fallback
        if not (detectiveItem or traitorItem) then
            equipment = EQUIP_RADAR
        end

        equipment = math.floor(tonumber(equipment))
        ply:GiveEquipmentItem(equipment)
    else
        -- If a weapon is already taking up the slot of the weapon we're trying to give, change the slot it takes up! (If we want that, i.e. wepKind is defined)
        if wepKind then
            for _, wep in ipairs(ply:GetWeapons()) do
                if wep.Kind and weapon.Kind and wep.Kind == weapon.Kind then
                    wep.Kind = wepKind
                end
            end
        end

        ply:Give(equipment)
    end

    timer.Simple(1, function()
        -- Calls all expected shop hooks for things like greying out icons in the player's shop
        Randomat:CallShopHooks(is_item, equipment, ply)

        -- For some reason this just does not get called when the radar is given...
        -- So we're just going to call it here so the radar automatically starts scanning when given
        if equipment == EQUIP_RADAR then
            ply:ConCommand("ttt_radar_scan")
        end
    end)

    timer.Simple(5, function()
        -- Number indexes in non-sequential tables are actually strings, so we need to convert passive item IDs to strings
        -- if we are to use the detective/traitor buyable tables from lua/autorun/stig_randomat_base_functions.lua
        equipment = tostring(equipment)
        local detectiveBuyable = GetDetectiveBuyable()
        local traitorBuyable = GetTraitorBuyable()
        local name = detectiveBuyable[equipment] or traitorBuyable[equipment] or "item"
        ply:ChatPrint("You received a " .. name .. "!")
    end)
end

function SpectatorRandomatAlert(ply, EVENT)
    ply:PrintMessage(HUD_PRINTCENTER, "Spectator Randomat Active!")
    local title = EVENT.Title or EVENT.AltTitle or "A spectator randomat"
    local desc = EVENT.Description or EVENT.ExtDescription or ""
    ply:PrintMessage(HUD_PRINTTALK, "'" .. title .. "' is active!\n" .. desc)

    timer.Simple(2, function()
        ply:PrintMessage(HUD_PRINTCENTER, "Spectator Randomat Active!")

        timer.Create("SpectatorRandomatAlert" .. ply:SteamID64(), 2, 2, function()
            if desc ~= "" then
                ply:PrintMessage(HUD_PRINTCENTER, desc)
            else
                ply:PrintMessage(HUD_PRINTCENTER, title)
            end
        end)
    end)
end

function DisableRoundEndSounds()
    -- Disables round end sounds mod and 'Ending Flair' event
    -- So events that that play sounds at the end of the round can do so without overlapping with other sounds/music
    SetGlobalBool("StopEndingFlairRandomat", true)
    local roundEndSounds = false

    if ConVarExists("ttt_roundendsounds") and GetConVar("ttt_roundendsounds"):GetBool() then
        GetConVar("ttt_roundendsounds"):SetBool(false)
        roundEndSounds = true
    end

    hook.Add("TTTEndRound", "RandomatReenableRoundEndSounds", function()
        -- Re-enable round end sounds and 'Ending Flair' event
        timer.Simple(1, function()
            SetGlobalBool("StopEndingFlairRandomat", false)

            -- Don't turn on round end sounds if they weren't on already
            if roundEndSounds then
                GetConVar("ttt_roundendsounds"):SetBool(true)
            end
        end)
    end)
end