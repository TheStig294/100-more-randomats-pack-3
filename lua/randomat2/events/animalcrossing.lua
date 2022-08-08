local EVENT = {}
EVENT.Title = "New Horizons"
EVENT.Description = "Everyone gets an Animal Crossing playermodel!"
EVENT.id = "animalcrossing"

EVENT.Categories = {"fun", "smallimpact"}

local animalCrossingModels = {"models/catcraze777/animal_crossing/Timmy_acnh/timmy_pm.mdl", "models/catcraze777/animal_crossing/redd_acnh/Redd_PM.mdl", "models/catcraze777/animal_crossing/kk_slider_acnh/kk_slider_PM.mdl", "models/player/player/sherb_pm/sherb_pm.mdl", "models/catcraze777/animal_crossing/kkclue_acnh/Kidcat_Casual_PM.mdl", "models/catcraze777/animal_crossing/Gulliver_acnh/Gulliver_PM.mdl", "models/catcraze777/animal_crossing/cj_acnh/cj_pm.mdl", "models/catcraze777/animal_crossing/cj_acnh/Flick_pm.mdl", "models/catcraze777/animal_crossing/blathers_acnh/blathers_pm.mdl", "models/catcraze777/animal_crossing/blathers_acnh/celeste_pm.mdl", "models/gwladys/digby/digby_player.mdl", "models/gwladys/isabelle/isabelle__player.mdl", "models/croissant/animalcrossing/tomnook/tomnook_pm.mdl"}

local installedModels = {}

for _, model in ipairs(animalCrossingModels) do
    if util.IsValidModel(model) then
        table.insert(installedModels, model)
    end
end

local selectedModels = {}

local function ApplyModel(ply, randomModel)
    local data = {}
    data.model = randomModel

    if randomModel == "models/catcraze777/animal_crossing/Timmy_acnh/timmy_pm.mdl" then
        data.viewOffset = Vector(0, 0, 40)
        ForceSetPlayermodel(ply, data)
    elseif randomModel == "models/catcraze777/animal_crossing/blathers_acnh/celeste_pm.mdl" then
        data.viewOffset = Vector(0, 0, 48)
        ForceSetPlayermodel(ply, data)
    elseif randomModel == "models/gwladys/digby/digby_player.mdl" then
        data.viewOffset = Vector(0, 0, 43)
        ForceSetPlayermodel(ply, data)
    elseif randomModel == "models/gwladys/isabelle/isabelle__player.mdl" then
        data.viewOffset = Vector(0, 0, 45)
        ForceSetPlayermodel(ply, data)
    elseif randomModel == "models/croissant/animalcrossing/tomnook/tomnook_pm.mdl" then
        data.viewOffset = Vector(0, 0, 48)
        ForceSetPlayermodel(ply, data)
    else
        ForceSetPlayermodel(ply, randomModel)
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
        ApplyModel(ply, randomModel)
    end

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            local randomModel = selectedModels[ply]
            ApplyModel(ply, randomModel)
        end)
    end)
end

function EVENT:End()
    ForceResetAllPlayermodels()
    self:ResetAllPlayerScales()
    table.Empty(selectedModels)
end

function EVENT:Condition()
    return not table.IsEmpty(installedModels)
end

Randomat:register(EVENT)