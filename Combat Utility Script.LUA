local awful = ...  -- Assuming awful is already initialized in your project
local ui, settings = awful.UI:New("Combat Utility Script", {
    title = "Combat Utility Script",
    show = true,
    colors = {
        title = {255, 50, 50, 1},  -- Red Title
        primary = {255, 255, 255, 1},  -- White primary text
        accent = {255, 50, 50, 1},  -- Red accent color
        background = {21, 21, 21, 0.8},  -- Dark background
    }
})

-- Create the placeholder categories in the UI
local category1 = ui:Tab("Category 1")  -- Placeholder for Category 1
local category2 = ui:Tab("Category 2")  -- Placeholder for Category 2
local category3 = ui:Tab("Category 3")  -- Placeholder for Category 3
local category4 = ui:Tab("Category 4")  -- Placeholder for Category 4
local category5 = ui:Tab("Category 5")  -- Placeholder for Category 5

-- Category 1 checkbox to enable/disable ESP
category1:Checkbox({
    text = "Enable Target ESP",
    var = "enableTargetESP",
    default = true,
    tooltip = "Enable drawing of 3D Box, line, and name ESP for the currently targeted player."
})

-- Draw function for the ESP
local function drawTargetESP()
    -- Check if the feature is enabled in the UI
    if not settings.enableTargetESP then return end

    local player = awful.player  -- Your active player
    local target = awful.target  -- Currently targeted unit

    if target and target.exists then
        local draw = awful.Draw

        -- Draw a 3D box around the target in red
        draw(function(d)
            d:SetWidth(2)  -- Set the line width
            d:SetColor(1, 0, 0, 1)  -- Set color to red (RGBA)

            -- Draw the 3D box at the target's position
            d:Box(target.x, target.y, target.z, 2, 2, 2)
            
            -- Draw a line from the player to the target
            d:Line(player.x, player.y, player.z, target.x, target.y, target.z)
            
            -- Draw the target's name above the 3D box
            d:SetColor(1, 0, 0, 1)  -- Set text color to red
            local namePositionZ = target.z + 2.5  -- Offset above the 3D box
            d:Text(target.name, "GameFontNormal", target.x, target.y, namePositionZ)
        end)
    end
end

-- Attach the drawing function to Awful's onTick callback
awful.onTick(drawTargetESP)

