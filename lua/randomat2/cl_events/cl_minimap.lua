net.Receive("MinimapRandomatToggle", function()
    local activate = net.ReadBool()

    if GMinimap then
        if activate then
            GMinimap.Config.terrainLighting = true
            GMinimap:Activate()
        else
            GMinimap:Deactivate()

            if GMinimap.Config.enable then
                GMinimap.Config.enable = false
                GMinimap.Config:Save()
            end
        end
    end
end)