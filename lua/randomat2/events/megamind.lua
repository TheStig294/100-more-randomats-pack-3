local EVENT = {}
EVENT.Title = "Megamind"
EVENT.ExtDescription = "Everyone changes to a Megamind playermodel"
EVENT.id = "megamind"

EVENT.Categories = {"modelchange", "fun", "smallimpact"}

local megamindModel = "models/player/megamind/megamind.mdl"

function EVENT:Begin()
    for _, ply in player.Iterator() do
        if not ply:Alive() or ply:IsSpec() then continue end
        Randomat:ForceSetPlayermodel(ply, megamindModel)
    end

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            Randomat:ForceSetPlayermodel(ply, megamindModel)
        end)
    end)
end

function EVENT:End(isActive)
    if isActive then
        Randomat:ForceResetAllPlayermodels()
    end
end

function EVENT:Condition()
    return util.IsValidModel(megamindModel)
end

Randomat:register(EVENT)