local EVENT = {}

EVENT.Title = "Meow!"
EVENT.Description = "Infinite cat guns for all!"
EVENT.id = "meow"

function EVENT:Begin()
    for _, ent in pairs(ents.GetAll()) do
        if ent.Kind == WEAPON_HEAVY and ent.AutoSpawnable then
            ent:Remove()
        end
    end

	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			self:HandleWeaponAddAndSelect(ply, function(active_class, active_kind)
				for _, wep in pairs(ply:GetWeapons()) do
					if wep.Kind == WEAPON_HEAVY then
						ply:StripWeapon(wep:GetClass())
					end
				end

				-- Reset FOV to unscope weapons if they were possibly scoped in
				if active_kind == WEAPON_HEAVY then
					ply:SetFOV(0, 0.2)
				end

				local wep1 = ply:Give("weapon_catgun")
				
				ply:SelectWeapon(wep1)
				wep1.AllowDrop = false
			end)
		end)
	end
	
	timer.Simple(1, function()
		self:AddHook("Think", function()
			for _, v in pairs(self:GetAlivePlayers()) do
				if IsValid(v:GetActiveWeapon()) then
					if v:GetActiveWeapon():GetClass() == "weapon_catgun" then
						v:GetActiveWeapon():SetClip1(v:GetActiveWeapon().Primary.ClipSize)
					end
				end
			end
		end)
	end)
end

function EVENT:Condition()
    return not Randomat:IsEventActive("reload") and not Randomat:IsEventActive("prophunt") and not Randomat:IsEventActive("harpoon") and not Randomat:IsEventActive("slam")
end

Randomat:register(EVENT)
