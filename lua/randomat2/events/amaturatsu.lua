local EVENT = {}
EVENT.Title = "Careful where you look..."
EVENT.Description = "Everyone has an amaterasu"
EVENT.id = "amaterasu"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:Give("ttt_amaterasu")
        end)
    end
end

function EVENT:Condition()
    local has_wep = false

    if weapons.Get("ttt_amaterasu") ~= nil then
        has_wep = true
    end

    return has_wep
end

Randomat:register(EVENT)