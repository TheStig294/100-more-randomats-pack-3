local thirdPersonWasOn = false

net.Receive("ThirdPersonRandomat", function()
	thirdPersonWasOn = GetConVar("thirdperson_etp"):GetBool()
	
	LocalPlayer():ConCommand("thirdperson_etp 1")
	
	hook.Add("PlayerBindPress", "DisableThirdpersonToggle", function(ply, bind, pressed)
		if ( string.find( bind, "thirdperson_enhanced_toggle" ) ) then
			ply:PrintMessage(HUD_PRINTCENTER, "Third person toggle is disabled")
			return true
		end
	end)
	
	hook.Add("Think", "ThirdPersonRandomatFailsafe", function()
		if not GetConVar("thirdperson_etp"):GetBool() then
			GetConVar("thirdperson_etp"):SetBool(true)
		end
	end)
end)

net.Receive("ThirdPersonRandomatEnd", function()
	hook.Remove("PlayerBindPress", "DisableThirdpersonToggle")
	hook.Remove("Think", "ThirdPersonRandomatFailsafe")
	
	if thirdPersonWasOn == false then
		LocalPlayer():ConCommand("thirdperson_etp 0")
	end
	
end)