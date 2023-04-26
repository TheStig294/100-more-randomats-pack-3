local EVENT = {}
EVENT.Title = "Meow!"
EVENT.Description = "Infinite cat guns for all!"
EVENT.id = "catgun"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"item", "smallimpact"}

local batModel = "models/weapons/gamefreak/w_nessbat.mdl"

if batModel then
    EVENT.Title = "Bat with a cat!"
    EVENT.Description = "Everyone's a bat, with only a cat!"
    table.insert(EVENT.Categories, 1, "modelchange")
end

local bats = {}

-- Changes a player into a bat...
local function SetBatModel(ent)
    ent:SetNoDraw(true)
    local bat = ents.Create("prop_dynamic")
    bat:SetModel(batModel)
    bat:SetPos(ent:GetPos())
    bat:SetAngles(Angle(90, 0, 0))
    bat:SetParent(ent)
    bat:Spawn()
    bat:PhysWake()
    bats[ent] = bat
end

function EVENT:Begin()
    if util.IsValidModel(batModel) then
        bats = {}

        -- Sets everyone's model to a bat
        for _, ply in ipairs(self:GetAlivePlayers()) do
            SetBatModel(ply)
        end

        -- Sets a player's model to a bat if they respawn
        self:AddHook("PlayerSpawn", function(ply)
            timer.Simple(1, function()
                SetBatModel(ply)
            end)
        end)

        -- Set corpses to a bat model
        self:AddHook("TTTOnCorpseCreated", function(corpse)
            SetBatModel(corpse)
        end)

        -- Remove parented bat models when players die
        self:AddHook("PostPlayerDeath", function(ply)
            bats[ply]:Remove()
            bats[ply] = nil
        end)
    end

    -- Remove all floor weapons
    for _, ent in pairs(ents.GetAll()) do
        if ent.AutoSpawnable then
            ent:Remove()
        end
    end

    -- Gived everyone an undroppable catgun
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            self:HandleWeaponAddAndSelect(ply, function(active_class, active_kind)
                for _, wep in pairs(ply:GetWeapons()) do
                    if wep.Kind == WEAPON_HEAVY then
                        ply:StripWeapon(wep:GetClass())
                    end
                end

                -- Reset FOV to unscope weapons if they were possibly scoped in
                ply:SetFOV(0, 0.2)
                local catgun = ply:Give("weapon_catgun")
                ply:SelectWeapon("weapon_catgun")
                catgun.AllowDrop = false
            end)
        end)
    end

    -- Give the catgun infinite ammo
    timer.Simple(1, function()
        self:AddHook("Think", function()
            for _, v in pairs(self:GetAlivePlayers()) do
                if IsValid(v:GetActiveWeapon()) and v:GetActiveWeapon():GetClass() == "weapon_catgun" then
                    v:GetActiveWeapon():SetClip1(v:GetActiveWeapon().Primary.ClipSize)
                end
            end
        end)
    end)
end

-- Undo changing everyone to bats if the bat model exists
function EVENT:End()
    if util.IsValidModel(batModel) then
        for _, ply in ipairs(player.GetAll()) do
            ply:SetNoDraw(false)
        end

        for _, bat in pairs(bats) do
            if IsValid(bat) then
                bat:Remove()
            end
        end
    end
end

-- Only run if the catgun exists
function EVENT:Condition()
    return weapons.Get("weapon_catgun") ~= nil
end

Randomat:register(EVENT)