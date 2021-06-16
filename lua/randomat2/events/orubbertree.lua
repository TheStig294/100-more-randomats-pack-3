local EVENT = {}

CreateConVar("randomat_orubbertree_timer", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between being given donconnons")
CreateConVar("randomat_orubbertree_strip", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The event strips your other weapons")
CreateConVar("randomat_orubbertree_weaponid", "doncmk2_swep", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Id of the weapon given")


EVENT.Title = "O Rubber Tree..."
EVENT.Description = "Donconnons only!"
EVENT.id = "orubbertree"

function EVENT:Begin()
	timer.Create("RandomatORubbertreeTimer", GetConVar("randomat_orubbertree_timer"):GetInt(), 0, function()
		for i, ply in pairs(self:GetAlivePlayers(true)) do
			if table.Count(ply:GetWeapons()) ~= 1 or (table.Count(ply:GetWeapons()) == 1 and ply:GetActiveWeapon():GetClass() ~= "doncmk2_swep") then
				if GetConVar("randomat_orubbertree_strip"):GetBool() then
					ply:StripWeapons()
				end
				ply:Give(GetConVar("randomat_orubbertree_weaponid"):GetString())
			end
		end
	end)
end

function EVENT:End()
	timer.Remove("RandomatORubbertreeTimer")
end

Randomat:register(EVENT)