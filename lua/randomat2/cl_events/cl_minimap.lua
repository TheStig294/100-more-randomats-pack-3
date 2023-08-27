net.Receive("MinimapRandomatToggle", function()
    local activate = net.ReadBool()

    if GMinimap then
        if activate then
            GMinimap.Config.terrainLighting = true
            GMinimap:Activate()
        else
            GMinimap:Deactivate()
        end
    end
end)