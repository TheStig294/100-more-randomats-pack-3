local EVENT = {}
EVENT.Title = "Am I a jester or a traitor?"
EVENT.Description = "There is a jester, and a traitor with a maclunkey gun!"
EVENT.id = "maclunkey"

EVENT.Categories = {"rolechange", "item", "moderateimpact"}

function EVENT:Begin()
    local givenMaclunkey = false
    local jesterAlreadyExists = false

    for _, ply in ipairs(self:GetAlivePlayers(true)) do
        if Randomat:IsTraitorTeam(ply) and not givenMaclunkey then
            local wep = ply:Give("maclunkey")
            -- Some arbitrary number so the traitor always receives the maclunkey gun
            wep.Kind = 6516

            timer.Simple(5, function()
                local message = "You won't deal damage until you use/drop your maclunkey gun!"
                ply:PrintMessage(HUD_PRINTTALK, message)
                ply:PrintMessage(HUD_PRINTCENTER, message)

                timer.Simple(2, function()
                    ply:PrintMessage(HUD_PRINTCENTER, message)
                end)
            end)
        elseif Randomat:IsJesterTeam(ply) then
            jesterAlreadyExists = true
            local message = "You're now a jester!"
            ply:PrintMessage(HUD_PRINTTALK, message)
            ply:PrintMessage(HUD_PRINTCENTER, message)

            timer.Simple(2, function()
                ply:PrintMessage(HUD_PRINTCENTER, message)
            end)

            Randomat:SetRole(ply, ROLE_JESTER)
            self:StripRoleWeapons(ply)
        end
    end

    if not jesterAlreadyExists then
        for _, ply in ipairs(self:GetAlivePlayers(true)) do
            if Randomat:IsInnocentTeam(ply, true) then
                Randomat:SetRole(ply, ROLE_JESTER)
                self:StripRoleWeapons(ply)
                break
            end
        end
    end

    SendFullStateUpdate()
end

function EVENT:Condition()
    local isTraitor = false
    local isInnocent = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsTraitorTeam(ply) then
            isTraitor = true
        elseif Randomat:IsInnocentTeam(ply, true) then
            isInnocent = true
        end

        if isTraitor and isInnocent then break end
    end

    return isTraitor and isInnocent and weapons.Get("maclunkey") ~= nil and ConVarExists("ttt_jester_enabled")
end

Randomat:register(EVENT)