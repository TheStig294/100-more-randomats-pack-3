local yogsModels = {"models/darthsidius_christmas/emperor_palpatine.mdl", "models/dwarf_christmas/riftdwarf.mdl", "models/darthsidius_christmas/emperor_palpatine.mdl", "models/kermit_christmas/kermit.mdl", "models/left_shark_christmas/left_shark.mdl", "models/lich_king_christmas/lich_king_wow_masked.mdl", "models/mercy_christmas/tfa_ow_mercy.mdl", "models/pcmr_christmas/yahtzee.mdl"}

local EVENT = {}
EVENT.Title = "Jingle Jam"
EVENT.Description = "Everyone gets a Yogscast Christmas playermodel!"
EVENT.id = "jinglejam"

EVENT.Categories = {"fun", "smallimpact"}

local selectedModels = {}

function EVENT:Begin()
    local remainingModels = {}
    --Adding the playermodels table to a different table so if more than 8 people are playing, the choosable models are able to be reset
    table.Add(remainingModels, yogsModels)

    for i, ply in pairs(player.GetAll()) do
        -- Resets the choosable models for everyone's playermodel if none are left (happens when there are more than 8 players, as there are 8 playermodels to choose from)
        if remainingModels == {} then
            table.Add(remainingModels, yogsModels)
        end

        --Chooses a random model, prevents it from being chosen by anyone else, and sets the player to that model
        local randomModel = table.Random(remainingModels)
        table.RemoveByValue(remainingModels, randomModel)
        selectedModels[ply] = randomModel
        ForceSetPlayermodel(ply, randomModel)
    end

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            local randomModel = selectedModels[ply]
            ForceSetPlayermodel(ply, randomModel)
        end)
    end)
end

function EVENT:End()
    ForceResetAllPlayermodels()
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

Randomat:register(EVENT)