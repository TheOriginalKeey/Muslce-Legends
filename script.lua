local BUILTIN_SCRIPTS = {
    {
        name = "DxD (Farm)",
        url = "https://codeberg.org/vdvedvegbgeb/vdvedvegbgeb/raw/branch/main/DxD.lua",
    },
    {
        name = "KxK (Fight)",
        url = "https://codeberg.org/vdvedvegbgeb/vdvedvegbgeb/raw/branch/main/KxK.lua",
    },
    {
        name = "Keey Main",
        url = "https://raw.githubusercontent.com/TheOriginalKeey/Muslce-Legends/main/keey-main.lua",
    },
    {
        name = "Yummy Duck",
        url = "https://raw.githubusercontent.com/googlyeyed1/yummy-duck/refs/heads/main/yummy%20duck",
    },
}

local SCRIPT_CATALOG = {}
for _, entry in ipairs(BUILTIN_SCRIPTS) do
    table.insert(SCRIPT_CATALOG, {
        name = entry.name,
        url = entry.url,
        builtin = true,
    })
end

local function make(parent, className, props)
    local obj = Instance.new(className)
    for key, value in pairs(props) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function trim(value)
    return (value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function getUiParent()
    if type(gethui) == "function" then
        return gethui()
    end
    return game:GetService("CoreGui")
end

local function friendlyRuntimeMessage(entryName, errText)
    local lowerErr = string.lower(errText)

    if entryName == "KxK (Fight)" and string.find(lowerErr, "parent property of localscript is locked", 1, true) then
        return "KxK failed: this KxK build is trying to parent a locked LocalScript (imgui)."
    end

    if entryName == "DxD (Farm)" and string.find(lowerErr, "attempt to index nil", 1, true) then
        return "DxD failed: script expected objects that do not exist in this server/game state."
    end

    return "Runtime error in " .. entryName .. ": " .. errText
end

local uiParent = getUiParent()
local existing = uiParent:FindFirstChild("KeeyUniversalLoader")
if existing then
    existing:Destroy()
end

local OPEN_SIZE = Vector2.new(360, 340)
local COLLAPSED_SIZE = Vector2.new(360, 52)

local screenGui = make(uiParent, "ScreenGui", {
    Name = "KeeyUniversalLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local main = make(screenGui, "Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.52),
    Size = UDim2.fromOffset(OPEN_SIZE.X, OPEN_SIZE.Y),
    BackgroundColor3 = Color3.fromRGB(13, 10, 22),
    BorderSizePixel = 0,
})
make(main, "UICorner", { CornerRadius = UDim.new(0, 12) })
make(main, "UIStroke", {
    Color = Color3.fromRGB(178, 80, 255),
    Thickness = 1.6,
})

local topBar = make(main, "Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = Color3.fromRGB(58, 12, 100),
    BorderSizePixel = 0,
})
make(topBar, "UICorner", { CornerRadius = UDim.new(0, 12) })

make(topBar, "TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 4),
    Size = UDim2.new(1, -110, 0, 24),
    Font = Enum.Font.GothamBold,
    Text = "Keey Loader",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(255, 248, 255),
})

make(topBar, "TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 28),
    Size = UDim2.new(1, -120, 0, 18),
    Font = Enum.Font.Gotham,
    Text = "Choose your script to execute",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(218, 188, 255),
})

local collapseBtn = make(topBar, "TextButton", {
    Name = "Collapse",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -48, 0.5, 0),
    Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = Color3.fromRGB(98, 35, 158),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "^",
    TextSize = 15,
    TextColor3 = Color3.fromRGB(255, 255, 255),
})
make(collapseBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })

local closeBtn = make(topBar, "TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -14, 0.5, 0),
    Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = Color3.fromRGB(172, 32, 88),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "X",
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 255, 255),
})
make(closeBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })

-- Transparent drag handle covers the title area (left of the buttons) so
-- clicks there always register for dragging even though labels are transparent.
local dragHandle = make(topBar, "TextButton", {
    Name = "DragHandle",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, -108, 1, 0),
    Text = "",
    ZIndex = 2,
    AutoButtonColor = false,
})

local reopenBtn = make(screenGui, "TextButton", {
    Name = "Reopen",
    Visible = false,
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 12, 1, -12),
    Size = UDim2.fromOffset(124, 34),
    BackgroundColor3 = Color3.fromRGB(42, 20, 72),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "Open Loader",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(244, 236, 255),
})
make(reopenBtn, "UICorner", { CornerRadius = UDim.new(0, 10) })
make(reopenBtn, "UIStroke", {
    Color = Color3.fromRGB(129, 82, 255),
    Thickness = 1,
})

local body = make(main, "ScrollingFrame", {
    Name = "Body",
    Position = UDim2.fromOffset(0, 52),
    Size = UDim2.new(1, 0, 1, -52),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 6,
    CanvasSize = UDim2.fromOffset(0, 0),
    ScrollingDirection = Enum.ScrollingDirection.Y,
})

make(body, "UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
})

local bodyLayout = make(body, "UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
})

local dropdownWrapper = make(body, "Frame", {
    Name = "DropdownWrapper",
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
})

local dropdownBtn = make(dropdownWrapper, "TextButton", {
    Name = "DropdownButton",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(55, 30, 88),
    BorderSizePixel = 0,
    Font = Enum.Font.Gotham,
    Text = "Select Script  v",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(245, 241, 255),
})
make(dropdownBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(dropdownBtn, "UIPadding", { PaddingLeft = UDim.new(0, 10) })

local dropdownList = make(dropdownWrapper, "ScrollingFrame", {
    Name = "DropdownList",
    Visible = false,
    Position = UDim2.fromOffset(0, 44),
    Size = UDim2.new(1, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(32, 20, 52),
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    CanvasSize = UDim2.fromOffset(0, 0),
})
make(dropdownList, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(dropdownList, "UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
})

local dropdownLayout = make(dropdownList, "UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
})

local runSelectedBtn = make(body, "TextButton", {
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(128, 52, 220),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "Run Selected Script",
    TextSize = 13,
    TextColor3 = Color3.fromRGB(255, 255, 255),
})
make(runSelectedBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(runSelectedBtn, "UIStroke", { Color = Color3.fromRGB(200, 140, 255), Thickness = 1 })

local statusLabel = make(body, "TextLabel", {
    LayoutOrder = 3,
    Size = UDim2.new(1, 0, 0, 64),
    BackgroundColor3 = Color3.fromRGB(20, 14, 34),
    BorderSizePixel = 0,
    Font = Enum.Font.Gotham,
    Text = "Status: Ready",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(174, 243, 186),
})
make(statusLabel, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(statusLabel, "UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
})

make(body, "TextLabel", {
    LayoutOrder = 4,
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Quick launch (4 built-in scripts)",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(195, 173, 238),
})

local quickList = make(body, "ScrollingFrame", {
    Name = "QuickList",
    LayoutOrder = 5,
    Size = UDim2.new(1, 0, 0, 110),
    BackgroundColor3 = Color3.fromRGB(22, 15, 38),
    BorderSizePixel = 0,
    ScrollBarThickness = 5,
    CanvasSize = UDim2.fromOffset(0, 0),
})
make(quickList, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(quickList, "UIPadding", {
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 5),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5),
})

local quickLayout = make(quickList, "UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
})

make(body, "TextLabel", {
    LayoutOrder = 6,
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Add custom script",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(195, 173, 238),
})

local nameBox = make(body, "TextBox", {
    LayoutOrder = 7,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(42, 28, 66),
    BorderSizePixel = 0,
    PlaceholderText = "Script Name",
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    Text = "",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(241, 236, 255),
    PlaceholderColor3 = Color3.fromRGB(160, 149, 187),
})
make(nameBox, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(nameBox, "UIPadding", { PaddingLeft = UDim.new(0, 10) })

local urlBox = make(body, "TextBox", {
    LayoutOrder = 8,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(42, 28, 66),
    BorderSizePixel = 0,
    PlaceholderText = "Script URL (https://...)",
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    Text = "",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(241, 236, 255),
    PlaceholderColor3 = Color3.fromRGB(160, 149, 187),
})
make(urlBox, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(urlBox, "UIPadding", { PaddingLeft = UDim.new(0, 10) })

local addBtn = make(body, "TextButton", {
    LayoutOrder = 9,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = Color3.fromRGB(80, 42, 138),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "Add Script To Loader",
    TextSize = 12,
    TextColor3 = Color3.fromRGB(255, 255, 255),
})
make(addBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })

make(body, "TextLabel", {
    LayoutOrder = 10,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Tip: Use ^ to collapse (dropup) and v to expand (dropdown).",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(155, 147, 175),
})

local selectedIndex = 1
local isCollapsed = false
local isDropdownOpen = false

local function setStatus(message, isError)
    statusLabel.Text = "Status: " .. message
    statusLabel.TextColor3 = isError and Color3.fromRGB(255, 138, 138) or Color3.fromRGB(174, 243, 186)
end

local function updateBodyCanvas()
    body.CanvasSize = UDim2.fromOffset(0, bodyLayout.AbsoluteContentSize.Y + 18)
end

local function updateDropdownCanvas()
    dropdownList.CanvasSize = UDim2.fromOffset(0, dropdownLayout.AbsoluteContentSize.Y + 8)
end

local function updateQuickCanvas()
    quickList.CanvasSize = UDim2.fromOffset(0, quickLayout.AbsoluteContentSize.Y + 8)
end

local function setDropdownOpen(open)
    isDropdownOpen = open
    dropdownList.Visible = open

    if open then
        local targetHeight = math.min(130, (#SCRIPT_CATALOG * 28) + 8)
        dropdownList.Size = UDim2.new(1, 0, 0, targetHeight)
        dropdownWrapper.Size = UDim2.new(1, 0, 0, 44 + targetHeight)
    else
        dropdownList.Size = UDim2.new(1, 0, 0, 0)
        dropdownWrapper.Size = UDim2.new(1, 0, 0, 40)
    end

    updateBodyCanvas()
end

local function setCollapsed(collapsed)
    isCollapsed = collapsed
    body.Visible = not collapsed

    if collapsed then
        main.Size = UDim2.fromOffset(COLLAPSED_SIZE.X, COLLAPSED_SIZE.Y)
        collapseBtn.Text = "v"
        setDropdownOpen(false)
    else
        main.Size = UDim2.fromOffset(OPEN_SIZE.X, OPEN_SIZE.Y)
        collapseBtn.Text = "^"
        updateBodyCanvas()
    end
end

local function updateDropdownButtonText()
    local selected = SCRIPT_CATALOG[selectedIndex]
    if selected then
        dropdownBtn.Text = selected.name .. "  v"
    else
        dropdownBtn.Text = "Select Script  v"
    end
end

-- Clear getgenv loop flags so previously running DxD/KxK/Keey loops stop.
local function stopPreviousScript()
    local env = type(getgenv) == "function" and getgenv() or nil
    if not env then return end
    env._InfiniteDxD = false
    env._InfiniteKxK = false
    env._AutoRepFarmEnabled = false
    env._AutoRepFarmLoop = nil
    env.zamanbaslaticisi = false
end

local function runEntry(entry)
    if not entry or type(entry.url) ~= "string" or entry.url == "" then
        setStatus("Invalid script entry.", true)
        return
    end

    stopPreviousScript()
    setStatus("Downloading " .. entry.name .. "...", false)

    task.spawn(function()
        local okDownload, source = pcall(function()
            return game:HttpGet(entry.url, true)
        end)

        if (not okDownload) or type(source) ~= "string" or source == "" then
            if entry.name == "Keey Main" then
                setStatus("Download failed for Keey Main. Upload keey-main.lua to GitHub main branch.", true)
            else
                setStatus("Download failed for " .. entry.name .. ".", true)
            end
            warn("[Loader] Download failed for", entry.name)
            return
        end

        local chunk, compileErr = loadstring(source)
        if type(chunk) ~= "function" then
            setStatus("Compile error in " .. entry.name .. ": " .. tostring(compileErr), true)
            warn("[Loader] Compile error in", entry.name, compileErr)
            return
        end

        setStatus("Executing " .. entry.name .. "...", false)

        task.spawn(function()
            local okRun, runErr = xpcall(chunk, function(err)
                return tostring(err)
            end)

            if okRun then
                setStatus("Started " .. entry.name .. " successfully.", false)
                warn("[Loader] Started", entry.name)
            else
                local humanMessage = friendlyRuntimeMessage(entry.name, tostring(runErr))
                setStatus(humanMessage, true)
                warn("[Loader] Runtime error in", entry.name, runErr)
            end
        end)
    end)
end

local function refreshDropdownItems()
    for _, child in ipairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for idx, entry in ipairs(SCRIPT_CATALOG) do
        local optionBtn = make(dropdownList, "TextButton", {
            LayoutOrder = idx,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = Color3.fromRGB(62, 40, 96),
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = entry.name,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(245, 239, 255),
        })
        make(optionBtn, "UICorner", { CornerRadius = UDim.new(0, 6) })
        make(optionBtn, "UIPadding", { PaddingLeft = UDim.new(0, 8) })

        optionBtn.MouseButton1Click:Connect(function()
            selectedIndex = idx
            updateDropdownButtonText()
            setDropdownOpen(false)
        end)
    end

    updateDropdownCanvas()
end

local function refreshQuickButtons()
    for _, child in ipairs(quickList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for idx, entry in ipairs(SCRIPT_CATALOG) do
        local quickBtn = make(quickList, "TextButton", {
            LayoutOrder = idx,
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = Color3.fromRGB(72, 42, 118),
            BorderSizePixel = 0,
            Font = Enum.Font.GothamBold,
            Text = "Execute " .. entry.name,
            TextSize = 11,
            TextColor3 = Color3.fromRGB(255, 248, 255),
        })
        make(quickBtn, "UICorner", { CornerRadius = UDim.new(0, 6) })

        quickBtn.MouseButton1Click:Connect(function()
            selectedIndex = idx
            updateDropdownButtonText()
            runEntry(entry)
        end)
    end

    updateQuickCanvas()
end

runSelectedBtn.MouseButton1Click:Connect(function()
    runEntry(SCRIPT_CATALOG[selectedIndex])
end)

addBtn.MouseButton1Click:Connect(function()
    local customName = trim(nameBox.Text)
    local customUrl = trim(urlBox.Text)

    if customName == "" or customUrl == "" then
        setStatus("Enter both custom script name and URL.", true)
        return
    end

    if not customUrl:lower():match("^https?://") then
        setStatus("URL must start with http:// or https://", true)
        return
    end

    table.insert(SCRIPT_CATALOG, {
        name = customName,
        url = customUrl,
        builtin = false,
    })

    selectedIndex = #SCRIPT_CATALOG
    nameBox.Text = ""
    urlBox.Text = ""

    refreshDropdownItems()
    refreshQuickButtons()
    updateDropdownButtonText()
    setStatus("Added " .. customName .. " to loader.", false)
end)

dropdownBtn.MouseButton1Click:Connect(function()
    if isCollapsed then
        setCollapsed(false)
    end
    setDropdownOpen(not isDropdownOpen)
end)

collapseBtn.MouseButton1Click:Connect(function()
    setCollapsed(not isCollapsed)
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    reopenBtn.Visible = true
end)

reopenBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    reopenBtn.Visible = false
end)

bodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateBodyCanvas)
dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDropdownCanvas)
quickLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateQuickCanvas)

-- Drag: use dedicated dragHandle button so collapse/close buttons don't eat input.
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart
local startPos

local function startDrag()
    dragging = true
    dragStart = UserInputService:GetMouseLocation()
    startPos = main.Position
end

dragHandle.MouseButton1Down:Connect(startDrag)

-- Also allow starting drag on touch.
dragHandle.TouchLongPress:Connect(startDrag)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local mouse = UserInputService:GetMouseLocation()
    local delta = mouse - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end)

refreshDropdownItems()
refreshQuickButtons()
updateDropdownButtonText()
setDropdownOpen(false)
setCollapsed(false)
updateBodyCanvas()
setStatus("Ready", false)
