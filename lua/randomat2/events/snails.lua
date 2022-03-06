local EVENT = {}
EVENT.Title = "RELEASE THE SNAILS!"
EVENT.Description = "Spawns snails that follow players around, killing you if they reach you"
EVENT.id = "snails"

EVENT.Categories = {"moderateimpact"}

CreateConVar("randomat_snails_cap", 12, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum number of snails spawned", 0, 15)

CreateConVar("randomat_snails_delay", 0.5, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Delay before snails are spawned", 0.1, 2.0)

CreateConVar("randomat_snails_music", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Music plays while randomat is active")

function EVENT:Begin()
    local cap = GetConVar("randomat_snails_cap"):GetInt()
    local plys = self:GetAlivePlayers()
    local player_index = 1
    local count = 0

    if GetConVar("randomat_snails_music"):GetBool() then
        for i, ply in pairs(player.GetAll()) do
            timer.Simple(2, function()
                ply:ConCommand("stopsound")
            end)

            timer.Simple(5, function()
                ply:EmitSound(Sound("killer_snail/killer_snail_loop.wav"))
            end)

            timer.Simple(34, function()
                ply:StopSound(Sound("killer_snail/killer_snail_loop.wav"))
            end)
        end
    end

    timer.Create("SnailTimer", GetConVar("randomat_snails_delay"):GetFloat(), 0, function()
        if plys[player_index] ~= nil then
            -- Get the first alive player
            local ply = plys[player_index]

            while not ply:Alive() or ply:IsSpec() do
                player_index = player_index + 1
                ply = plys[player_index]
            end

            -- Spawn a Snail if we have a cap and we haven't bypassed it
            if count < cap or cap == 0 then
                local ent = ents.Create("killer_snail")
                ent:SetEnemy(ply)
                ent:SetPos(ply:GetAimVector())
                ent:Spawn()
                ent:DropToFloor()
                count = count + 1
            end

            -- Move to the next player
            player_index = player_index + 1
        end
    end)
end

function EVENT:End()
    timer.Remove("SnailTimer")
end

function EVENT:Condition()
    local mapHasAI = MapHasAI()

    return mapHasAI and weapons.Get("weapon_ttt_killersnail") ~= nil
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"cap", "delay"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = v == "delay" and 1 or 0
            })
        end
    end

    local checks = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

Randomat:register(EVENT)