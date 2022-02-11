local standardHeightVector = Vector(0, 0, 64)
local standardCrouchedHeightVector = Vector(0, 0, 28)
local playerModels = {}
local remainingModels = {}
local playerColors = {}

local yogsModels = {"models/darthsidius_christmas/emperor_palpatine.mdl", "models/dwarf_christmas/riftdwarf.mdl", "models/darthsidius_christmas/emperor_palpatine.mdl", "models/kermit_christmas/kermit.mdl", "models/left_shark_christmas/left_shark.mdl", "models/lich_king_christmas/lich_king_wow_masked.mdl", "models/mercy_christmas/tfa_ow_mercy.mdl", "models/pcmr_christmas/yahtzee.mdl"}

local EVENT = {}
EVENT.Title = "Jingle Jam"
EVENT.Description = "Everyone gets a Yogscast Christmas playermodel!"
EVENT.id = "jinglejam"

function EVENT:Begin()
    --Adding the colour table to a different table so if more than 12 people are playing, the choosable colours are able to be reset
    table.Add(remainingModels, yogsModels)

    -- Gets all players...
    for i, ply in pairs(player.GetAll()) do
        -- if they're alive and not in spectator mode
        if ply:Alive() and not ply:IsSpec() then
            -- and not a bot (bots do not have the following command, so it's unnecessary)
            if (not ply:IsBot()) then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                ply:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need to wait a second for cl_playermodel_selector_force to take effect (and THEN change model to the Among Us model)
            timer.Simple(1, function()
                -- if the player's viewoffset is different than the standard, then...
                if not (ply:GetViewOffset() == standardHeightVector) then
                    -- So we set their new heights to the default values (which the Duncan model uses)
                    ply:SetViewOffset(standardHeightVector)
                    ply:SetViewOffsetDucked(standardCrouchedHeightVector)
                end

                -- Set player number i (in the table) to their respective model, to be restored at the end of the round
                playerModels[i] = ply:GetModel()
                playerColors[i] = ply:GetPlayerColor()

                -- Resets the choosable colours for everyone's Among Us playermodel if none are left (happens when there are more than 12 players, as there are 12 colours to choose from)
                if remainingModels == {} then
                    table.Add(remainingModels, yogsModels)
                end

                --Chooses a random colour, prevents it from being chosen by anyone else, and sets the player to that colour
                local randomModel = table.Random(remainingModels)
                table.RemoveByValue(remainingModels, randomModel)
                -- Sets their model to the Among Us model
                ply:SetModel(randomModel)
            end)
        end
    end
end

-- when the event ends, reset every player's model
function EVENT:End()
    -- loop through all players
    for k, v in pairs(player.GetAll()) do
        -- if the index k in the table playermodels has a model, then...
        if (playerModels[k] ~= nil) then
            -- we set the player v to the playermodel with index k in the table
            -- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
            -- this does however first reset their viewmodel in the preparing phase (when they respawn)
            -- might be glitchy with pointshop items that allow you to get a viewoffset
            v:SetModel(playerModels[k])
            v:SetPlayerColor(playerColors[k])
        end

        -- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
        v:ConCommand("cl_playermodel_selector_force 1")
        -- clear the model table to avoid setting wrong models (e.g. disconnected players)
        table.Empty(playerModels)
    end
end

function EVENT:Condition()
    local has_models = true

    for _, mdl in ipairs(yogsModels) do
        if not util.IsValidModel(mdl) then
            has_models = false
            break
        end
    end

    return has_models
end

-- register the event in the randomat!
Randomat:register(EVENT)