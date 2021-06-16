local thirdPersonWasOn = false

net.Receive("ThirdPersonRandomat", function()
    -- Get whether the player was already in third person
    thirdPersonWasOn = GetConVar("thirdperson_etp"):GetBool()
    -- Force the player into third person
    LocalPlayer():ConCommand("thirdperson_etp 1")

    -- When the player presses a keybind,
    hook.Add("PlayerBindPress", "DisableThirdpersonToggle", function(ply, bind, pressed)
        -- And that key is bound to toggling the third person perspective,
        if (string.find(bind, "thirdperson_enhanced_toggle")) then
            -- Tell the player they cannot toggle third person
            ply:PrintMessage(HUD_PRINTCENTER, "Third person toggle is disabled")
            -- And prevent them from toggling it from this keybind

            return true
        end
    end)

    -- Constantly check,
    hook.Add("Think", "ThirdPersonRandomatFailsafe", function()
        -- If ever the player is somehow able to go back to first person,
        if not GetConVar("thirdperson_etp"):GetBool() then
            -- Set them back to third person
            GetConVar("thirdperson_etp"):SetBool(true)
        end
    end)
end)

net.Receive("ThirdPersonRandomatEnd", function()
    -- Let the player press their third person toggle keybind again
    hook.Remove("PlayerBindPress", "DisableThirdpersonToggle")
    -- Stop forcing the player to third person
    hook.Remove("Think", "ThirdPersonRandomatFailsafe")

    -- If the player was not already in third-person,
    if thirdPersonWasOn == false then
        -- Set the player back to first-person
        LocalPlayer():ConCommand("thirdperson_etp 0")
    end
end)