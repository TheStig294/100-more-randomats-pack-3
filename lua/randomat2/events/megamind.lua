local EVENT = {}
EVENT.Title = "Megamind"
EVENT.ExtDescription = "Everyone changes to a Megamind playermodel"
EVENT.id = "megamind"

EVENT.Categories = {"modelchange", "fun", "smallimpact"}

local megamindModel = "models/player/megamind/megamind.mdl"

function EVENT:Begin()
    for _, ply in ipairs(self:GetAlivePlayers()) do
        Randomat:ForceSetModel(ply, megamindModel)
    end

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            Randomat:ForceSetPlayermodel(ply, megamindModel)
        end)
    end)
end

function EVENT:End()
    Randomat:ForceResetAllPlayermodels()
end

function EVENT:Condition()
    return util.IsValidModel(megamindModel)
end

Randomat:register(EVENT)