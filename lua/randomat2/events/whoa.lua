local standardHeightVector = Vector(0, 0, 64)
local standardCrouchedHeightVector = Vector(0, 0, 28)
local playerModels = {}
local EVENT = {}

CreateConVar("randomat_whoa_timer", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given spin attacks")

CreateConVar("randomat_whoa_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")

CreateConVar("randomat_whoa_weaponid", "weapon_ttt_whoa_randomat", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")

EVENT.Title = "Whoa!"
EVENT.Description = "Everyone is Crash Bandicoot and can only spin attack!"
EVENT.id = "whoa"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

function EVENT:HandleRoleWeapons(ply)
    -- Convert all bad guys to traitors so we don't have to worry about fighting with special weapon replacement logic
    if Randomat:IsTraitorTeam(ply) or Randomat:IsMonsterTeam(ply) or ply:GetRole() == ROLE_KILLER then
        Randomat:SetRole(ply, ROLE_TRAITOR)
        self:StripRoleWeapons(ply)

        return true
    end

    return false
end

function EVENT:Begin()
    -- Gets all players...
    for k, v in pairs(player.GetAll()) do
        if v:GetRole() == ROLE_JESTER or v:GetRole() == ROLE_SWAPPER then
            Randomat:SetRole(v, ROLE_INNOCENT)
        end

        -- if they're alive and not in spectator mode
        if v:Alive() and not v:IsSpec() then
            -- and not a bot (bots do not have the following command, so it's unnecessary)
            if (not v:IsBot()) then
                -- We need to disable cl_playermodel_selector_force, because it messes with SetModel, we'll reset it when the event ends
                v:ConCommand("cl_playermodel_selector_force 0")
            end

            -- we need  to wait a second for cl_playermodel_selector_force to take effect (and THEN change model)
            timer.Simple(1, function()
                -- if the player's viewoffset is different than the standard, then...
                if not (v:GetViewOffset() == standardHeightVector) then
                    -- So we set their new heights to the default values (which the Duncan model uses)
                    v:SetViewOffset(standardHeightVector)
                    v:SetViewOffsetDucked(standardCrouchedHeightVector)
                end

                -- Set player number K (in the table) to their respective model
                playerModels[k] = v:GetModel()
                -- Sets their model to chosenModel
                v:SetModel("models/bandicoot/bandicoot.mdl")
            end)
        end
    end

    for _, v in pairs(self.GetAlivePlayers()) do
        self:HandleRoleWeapons(v)
    end

    SendFullStateUpdate()

    timer.Create("RandomatWhoaTimer", GetConVar("randomat_whoa_timer"):GetInt(), 0, function()
        local weaponid = GetConVar("randomat_whoa_weaponid"):GetString()
        local updated = false

        for _, ply in pairs(self:GetAlivePlayers()) do
            if GetConVar("randomat_whoa_strip"):GetBool() then
                for _, wep in pairs(ply:GetWeapons()) do
                    local weaponclass = WEPS.GetClass(wep)

                    if weaponclass ~= weaponid then
                        ply:StripWeapon(weaponclass)
                    end
                end

                -- Reset FOV to unscope
                ply:SetFOV(0, 0.2)
            end

            if not ply:HasWeapon(weaponid) then
                ply:Give(weaponid)
            end

            -- Workaround the case where people can respawn as Zombies while this is running
            updated = updated or self:HandleRoleWeapons(ply)
        end

        -- If anyone's role changed, send the update
        if updated then
            SendFullStateUpdate()
        end
    end)

    self:AddHook("PlayerCanPickupWeapon", function(ply, wep)
        if not GetConVar("randomat_whoa_strip"):GetBool() then return end

        return IsValid(wep) and WEPS.GetClass(wep) == GetConVar("randomat_whoa_weaponid"):GetString()
    end)
end

function EVENT:End()
    timer.Remove("RandomatWhoaTimer")

    -- loop through all players
    for k, v in pairs(player.GetAll()) do
        -- if the index k in the table playermodels has a model, then...
        if (playerModels[k] ~= nil) then
            -- we set the player v to the playermodel with index k in the table
            -- this should invoke the viewheight script from the models and fix viewoffsets (e.g. Zoey's model) 
            -- this does however first reset their viewmodel in the preparing phase (when they respawn)
            -- might be glitchy with pointshop items that allow you to get a viewoffset
            v:SetModel(playerModels[k])
        end

        -- we reset the cl_playermodel_selector_force to 1, otherwise TTT will reset their playermodels on a new round start (to default models!)
        v:ConCommand("cl_playermodel_selector_force 1")
        -- clear the model table to avoid setting wrong models (e.g. disconnected players)
        table.Empty(playerModels)
    end
end

function EVENT:Condition()
    if Randomat:IsEventActive("slam") or Randomat:IsEventActive("prophunt") or Randomat:IsEventActive("grave") then return false end
    if not file.Exists("models/bandicoot/bandicoot.mdl", "THIRDPARTY") then return false end
    local weaponid = GetConVar("randomat_whoa_weaponid"):GetString()

    return util.WeaponForClass(weaponid) ~= nil
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"timer"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    local checks = {}

    for _, v in pairs({"strip"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    local textboxes = {}

    for _, v in pairs({"weaponid"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(textboxes, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks, textboxes
end

Randomat:register(EVENT)