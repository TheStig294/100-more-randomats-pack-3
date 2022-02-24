local EVENT = {}

CreateConVar("randomat_favourites2_given_items_count", "2", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How many most bought items to give out", 1, 10)

local function GetDescription()
    local count = GetConVar("randomat_favourites2_given_items_count"):GetInt()

    if count == 1 then
        return "Everyone gets their most bought item!"
    else
        return "Everyone gets their " .. GetConVar("randomat_favourites2_given_items_count"):GetInt() .. " most bought items!"
    end
end

EVENT.Title = "Everyone really has their favourites"
EVENT.Description = GetDescription()
EVENT.id = "favourites2"

function EVENT:Begin()
    self.Description = GetDescription()
    -- The stats data is recorded from another lua file, lua/autorun/server/stig_randomat_player_stats.lua
    local stats = randomatPlayerStats

    for _, ply in pairs(self:GetAlivePlayers()) do
        local ID = util.SteamIDFrom64(ply:SteamID64())
        local equipmentStats = table.Copy(stats[ID]["EquipmentItems"])
        -- Set every player's buy count of the radar and body armour to 1 to prevent these from always being a player's most bought item
        -- Also effectively sets the player's most bought item to the body armour and radar as a fail-safe if the player has never bought anything before
        equipmentStats["item_radar"] = 1
        equipmentStats["item_armor"] = 1
        local wepKind = 10
        local itemCount = math.min(GetConVar("randomat_favourites2_given_items_count"):GetInt(), table.Count(equipmentStats))

        for i = 1, itemCount do
            local mostBoughtItem = table.GetWinningKey(equipmentStats)
            equipmentStats[mostBoughtItem] = 0
            local is_item = weapons.Get(mostBoughtItem) == nil

            if is_item then
                local detectiveItem = false
                local traitorItem = false

                for _, equipment in ipairs(EquipmentItems[ROLE_DETECTIVE]) do
                    if equipment.name == mostBoughtItem then
                        if equipment.id then
                            detectiveItem = true
                            mostBoughtItem = equipment.id
                        end

                        break
                    end
                end

                if not detectiveItem then
                    for _, equipment in ipairs(EquipmentItems[ROLE_TRAITOR]) do
                        if equipment.name == mostBoughtItem then
                            if equipment.id then
                                traitorItem = true
                                mostBoughtItem = equipment.id
                            end

                            break
                        end
                    end
                end

                -- If the item can't be found, give them a radar as a fallback
                if not (detectiveItem or traitorItem) then
                    mostBoughtItem = EQUIP_RADAR
                end

                mostBoughtItem = math.floor(tonumber(mostBoughtItem))
                ply:GiveEquipmentItem(mostBoughtItem)
            else
                local wep = ply:Give(mostBoughtItem)
                -- Giving all weapons a unique weapon kind so players can always get all weapons
                wep.Kind = wepKind
                wepKind = wepKind + 1
            end

            local detectiveBuyable = GetDetectiveBuyable()
            local traitorBuyable = GetTraitorBuyable()

            timer.Simple(0.1, function()
                -- Calls all expected shop hooks for things like automatically starting the radar if a player was given one,
                -- and greying out icons in the player's shop
                Randomat:CallShopHooks(is_item, mostBoughtItem, ply)
                -- Number indexes in non-sequential tables are actually strings, so we need to convert passive item IDs to strings
                -- if we are to use the detective/traitor buyable tables from lua/autorun/stig_randomat_base_functions.lua
                mostBoughtItem = tostring(mostBoughtItem)
                local name = detectiveBuyable[mostBoughtItem] or traitorBuyable[mostBoughtItem] or "item"
                ply:ChatPrint("You received a " .. name .. "!")
            end)
        end
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"given_items_count"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)
            convar:Revert()

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)