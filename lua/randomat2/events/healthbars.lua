local EVENT = {}
EVENT.Title = "Spider Mod"
EVENT.Description = "When you look at someone, you see a health bar above them!"
EVENT.id = "healthbars"

EVENT.Categories = {"smallimpact"}

function EVENT:Begin()
    GetConVar("sv_SyntTarget_enabled"):SetBool(true)
end

function EVENT:End()
    -- Only disable the healthbar mod if this event is enabled
    -- EVENT:End() is called on round prepare and round begin, which is why this condition is necessary
    if ConVarExists("sv_SyntTarget_enabled") and GetConVar("ttt_randomat_" .. self.id):GetBool() then
        GetConVar("sv_SyntTarget_enabled"):SetBool(false)
    end
end

function EVENT:Condition()
    return ConVarExists("sv_SyntTarget_enabled")
end

Randomat:register(EVENT)