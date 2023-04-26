local EVENT = {}
EVENT.Title = "Gotta catch 'em all!"
EVENT.Description = "Everyone gets a Pokemon playermodel!"
EVENT.id = "catchemall"

EVENT.Categories = {"modelchange", "fun", "smallimpact"}

local pokemonModels = {"models/pokemon/legends_arceus/akari.mdl", "models/player/custom/Blaziken/Blaziken_pm.mdl", "models/player/mrmariobros222/cynthia.mdl", "models/player/deci/deci_pm/deci.mdl", "models/jp/pokemon/ethan/ethan_player.mdl", "models/player/custom/Garchomp/Garchomp_pm.mdl", "models/gengarplayer/gengarplayer.mdl", "models/guzma/group13/tale_13.mdl", "models/player/may/may.mdl", "models/player/pikachu_lebray.mdl", "models/pokemon/Zinnia.mdl", "models/player/red.mdl", "models/player/mewtwo_james.mdl", "models/player/custom/Sceptile/Sceptile_pm.mdl", "models/pokemon/sneasel/sneasel_reference.mdl", "models/pokemon/spinda/spinda_player.mdl", "models/player/custom/Swampert/Swampert_pm.mdl", "models/player/custom/Swampert/SHINY Swampert_pm.mdl", "models/pokemon/weavile/weavile_reference.mdl", "models/player/captainPawn/ssbuincineroar.mdl", "models/player/genetic/mewtwo.mdl", "models/player/pokemon/dialga_pm/Dialga_pm.mdl", "models/player/mrmariobros222/brendan.mdl"}

local installedModels = {}

for _, model in ipairs(pokemonModels) do
    if util.IsValidModel(model) then
        table.insert(installedModels, model)
    end
end

local selectedModels = {}

local function SetPokemonModel(ply, randomModel)
    if randomModel == "models/pokemon/Zinnia.mdl" then
        local data = {}
        data.model = "models/pokemon/Zinnia.mdl"

        data.bodygroupValues = {
            [0] = 0,
            [1] = 1
        }

        Randomat:ForceSetPlayermodel(ply, data)
    elseif randomModel == "models/player/red.mdl" then
        local data = {}
        data.model = "models/player/red.mdl"
        data.playerColor = Color(214, 38, 38):ToVector()
        Randomat:ForceSetPlayermodel(ply, data)
    else
        Randomat:ForceSetPlayermodel(ply, randomModel)
    end
end

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
        SetPokemonModel(ply, randomModel)
    end

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            local randomModel = selectedModels[ply]
            SetPokemonModel(ply, randomModel)
        end)
    end)
end

function EVENT:End()
    Randomat:ForceResetAllPlayermodels()
    self:ResetAllPlayerScales()
    table.Empty(selectedModels)
end

function EVENT:Condition()
    return not table.IsEmpty(installedModels)
end

Randomat:register(EVENT)