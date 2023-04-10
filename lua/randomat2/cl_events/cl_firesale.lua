local iconFrame
local music

local function CreateIcon()
    --Create the frame
    iconFrame = vgui.Create("DFrame")
    --Resolution of the popup image file, so the popup frame is covered by the popup itself
    local xSize = 64
    local ySize = 64
    --Sets the centre of the frame at the centre of the screen
    local pos1 = (ScrW() - xSize) / 2
    local pos2 = (ScrH() - ySize) - (ScrH() / 10)
    iconFrame:SetPos(pos1, pos2)
    iconFrame:SetSize(xSize, ySize)
    --Hide the close button and the frame is completely hidden
    iconFrame:ShowCloseButton(false)
    -- iconFrame:SetVisible(false)
    iconFrame:SetTitle("")
    iconFrame:SetDraggable(false)
    --Placing the popup image on the frame
    iconFrame.Paint = function(self, w, h) end
    local image = vgui.Create("DImage", iconFrame)
    image:SetImage("materials/vgui/ttt/firesale/firesale.png")
    image:SetPos(0, 0)
    image:SetSize(xSize, ySize)
end

local function RemoveIcon()
    if IsValid(iconFrame) then
        iconFrame:Close()
    end
end

net.Receive("FireSaleRandomatBegin", function()
    music = net.ReadBool()

    if music then
        surface.PlaySound("firesale/music.mp3")
    end

    CreateIcon()

    timer.Create("FireSaleIconStartFlash", 23.4, 1, function()
        timer.Create("FireSaleIcon1stFlash", 0.5, 10, function()
            if IsValid(iconFrame) then
                if iconFrame:IsVisible() then
                    iconFrame:SetVisible(false)
                else
                    iconFrame:SetVisible(true)
                end
            end
        end)
    end)

    timer.Create("FireSaleIconStart2ndFlash", 28.4, 1, function()
        timer.Create("FireSaleIcon2stFlash", 0.25, 20, function()
            if IsValid(iconFrame) then
                if iconFrame:IsVisible() then
                    iconFrame:SetVisible(false)
                else
                    iconFrame:SetVisible(true)
                end
            end
        end)
    end)

    timer.Create("FireSaleRemoveIconTimer", 33.4, 1, RemoveIcon)
end)

net.Receive("FireSaleRandomatEnd", function()
    timer.Remove("FireSaleIconStartFlash")
    timer.Remove("FireSaleIcon1stFlash")
    timer.Remove("FireSaleIconStart2ndFlash")
    timer.Remove("FireSaleIcon2stFlash")
    timer.Remove("FireSaleRemoveIconTimer")
    RemoveIcon()

    if music then
        RunConsoleCommand("stopsound")
    end
end)