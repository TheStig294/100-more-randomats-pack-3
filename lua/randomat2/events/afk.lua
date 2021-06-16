local EVENT = {}
EVENT.Title = "AFK = Dead"
EVENT.Description = "Being AFK kills you"
EVENT.id = "afk"

function EVENT:Begin()
    -- Set the flag that lets a player be killed by being AFK on all players
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetNWBool("MinimizedKillable", true)
    end

    self:AddHook("Think", function()
        for i, ply in pairs(self:GetAlivePlayers()) do
            timer.Simple(0.1, function()
                -- If a player is 'Minimised' (from another mod), and not already killed in this way, 
                if ply:GetNWBool("Minimized", false) and ply:GetNWBool("MinimizedKillable", false) then
                    -- Kill them
                    ply:Kill()
                    -- Prevent trying to kill them multiple times
                    ply:SetNWBool("MinimizedKillable", false)
                    -- Display a notification to everyone explaining why they died
                    self:SmallNotify(ply:Nick() .. " went AFK")
                end
            end)
        end
    end)

    -- Lets a player be killed again by being AFK on respawning
    self:AddHook("PlayerSpawn", function(ply, transition)
        timer.Simple(0.1, function()
            ply:SetNWBool("MinimizedKillable", true)
        end)
    end)
end

Randomat:register(EVENT)