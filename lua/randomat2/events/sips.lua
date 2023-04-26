local EVENT = {}
EVENT.Title = "Sips sends his regards"
EVENT.id = "sips"

EVENT.Categories = {"modelchange", "fun", "smallimpact"}

local canadaModels = {"models/sentry/canuccop/sentrycanarcmpmale6pm.mdl", "models/sentry/canuccop/sentrycanarcmpmale7pm.mdl", "models/sentry/canuccop/sentrycanarcmpmale8pm.mdl", "models/sentry/canuccop/sentrycanarcmpmale9pm.mdl"}

local installedModels = {}

for _, model in ipairs(canadaModels) do
    if util.IsValidModel(model) then
        table.insert(installedModels, model)
    end
end

local selectedModels = {}

function EVENT:Begin()
    local remainingModels = {}
    --Adding the playermodels table to a different table so if more than 8 people are playing, the choosable models are able to be reset
    table.Add(remainingModels, installedModels)

    for i, ply in pairs(player.GetAll()) do
        -- Resets the choosable models for everyone's playermodel if none are left (happens when there are more than 8 players, as there are 8 playermodels to choose from)
        if table.IsEmpty(remainingModels) then
            table.Add(remainingModels, installedModels)
        end

        --Chooses a random model, prevents it from being chosen by anyone else, and sets the player to that model
        local randomModel = table.Random(remainingModels)
        table.RemoveByValue(remainingModels, randomModel)
        selectedModels[ply] = randomModel
        Randomat:ForceSetPlayermodel(ply, randomModel)
    end

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            local randomModel = selectedModels[ply]
            Randomat:ForceSetPlayermodel(ply, randomModel)
        end)
    end)
end

function EVENT:End()
    Randomat:ForceResetAllPlayermodels()
    table.Empty(selectedModels)
end

function EVENT:Condition()
    return not table.IsEmpty(installedModels)
end

Randomat:register(EVENT)