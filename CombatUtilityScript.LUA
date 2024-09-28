local awful = ...  -- Assuming awful is already initialized in your project

-- Create or load the configuration for the script using the new file name
local config = awful.NewConfig("CombatUtilityScript")

-- Create the UI with saved settings loaded from `awful-config.json`
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

-- Category 1 checkbox to enable/disable different ESP components
category1:Checkbox({
    text = "Enable Target ESP",
    var = "enableTargetESP",
    default = config.savedVar and config.savedVar.enableTargetESP or true,
    tooltip = "Enable drawing of ESP features for the currently targeted player."
})

category1:Checkbox({
    text = "Draw 3D Box",
    var = "draw3DBox",
    default = config.savedVar and config.savedVar.draw3DBox or true,
    tooltip = "Draw a 3D box around the target."
})

category1:Checkbox({
    text = "Draw Line to Target",
    var = "drawLine",
    default = config.savedVar and config.savedVar.drawLine or true,
    tooltip = "Draw a line from the player to the target."
})

category1:Checkbox({
    text = "Draw Name ESP",
    var = "drawName",
    default = config.savedVar and config.savedVar.drawName or true,
    tooltip = "Display the name of the target above the 3D box."
})

-- Save settings back to config on change
local function saveSettings()
    config.savedVar = settings
end

-- Hook into checkbox changes to save settings automatically
ui:Hook("CheckboxChanged", saveSettings)

-- Draw function for the ESP
local function drawTargetESP()
    -- Check if the feature is enabled in the UI
    if not settings.enableTargetESP then return end

    local player = awful.player  -- Your active player
    local target = awful.target  -- Currently targeted unit

    if target and target.exists then
        local draw = awful.Draw

        -- Draw a 3D box around the target if enabled
        if settings.draw3DBox then
            draw(function(d)
                d:SetWidth(2)  -- Set the line width
                d:SetColor(1, 0, 0, 1)  -- Set color to red (RGBA)
                d:Box(target.x, target.y, target.z, 2, 2, 2)  -- Draw 3D box at the target's position
            end)
        end

        -- Draw a line from the player to the target if enabled
        if settings.drawLine then
            draw(function(d)
                d:SetWidth(2)  -- Set the line width
                d:SetColor(1, 0, 0, 1)  -- Set color to red (RGBA)
                d:Line(player.x, player.y, player.z, target.x, target.y, target.z)  -- Draw line to the target
            end)
        end

        -- Draw the target's name above the 3D box if enabled
        if settings.drawName then
            draw(function(d)
                d:SetColor(1, 0, 0, 1)  -- Set text color to red
                local namePositionZ = target.z + 2.5  -- Offset above the 3D box
                d:Text(target.name, "GameFontNormal", target.x, target.y, namePositionZ)  -- Draw name ESP
            end)
        end
    end
end

-- Attach the drawing function to Awful's onTick callback
awful.onTick(drawTargetESP)
