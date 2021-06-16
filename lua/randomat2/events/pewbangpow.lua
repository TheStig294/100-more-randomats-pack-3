local EVENT = {}

EVENT.Title = "Pew! Bang! Pow!"
EVENT.Description = "Pew guns and finger guns for all!"
EVENT.id = "pewbangpow"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			self:HandleWeaponAddAndSelect(ply, function(active_class, active_kind)
				for _, wep in pairs(ply:GetWeapons()) do
					if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
						ply:StripWeapon(wep:GetClass())
					end
				end

				-- Reset FOV to unscope weapons if they were possibly scoped in
				if active_kind == WEAPON_HEAVY or active_kind == WEAPON_PISTOL then
					ply:SetFOV(0, 0.2)
				end
			end)
		
			math.randomseed(os.time() + i)
			if math.random() < 0.5 then
				ply:Give("custom_pewgun")
			else
				ply:Give("fingergun")
			end
		end)
	end
end

Randomat:register(EVENT)
