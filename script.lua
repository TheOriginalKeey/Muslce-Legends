local SCRIPT_CATALOG = {
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

local function make(parent, className, props)
    local obj = Instance.new(className)
    for key, value in pairs(props) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function getUiParent()
    if type(gethui) == "function" then
        return gethui()
    end
    return game:GetService("CoreGui")
end

local uiParent = getUiParent()
local existing = uiParent:FindFirstChild("KeeyUniversalLoader")
if existing then
    existing:Destroy()
end

local screenGui = make(uiParent, "ScreenGui", {
    Name = "KeeyUniversalLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local main = make(screenGui, "Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(440, 520),
    BackgroundColor3 = Color3.fromRGB(23, 24, 30),
    BorderSizePixel = 0,
})

make(main, "UICorner", { CornerRadius = UDim.new(0, 12) })
make(main, "UIStroke", {
    Color = Color3.fromRGB(108, 178, 255),
    Thickness = 1.2,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
})

local topBar = make(main, "Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Color3.fromRGB(31, 33, 40),
    BorderSizePixel = 0,
})

make(topBar, "UICorner", { CornerRadius = UDim.new(0, 12) })

make(topBar, "TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(1, -80, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "Keey Universal Loader",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 17,
    TextColor3 = Color3.fromRGB(240, 244, 255),
})

local closeBtn = make(topBar, "TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Color3.fromRGB(64, 68, 82),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "X",
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 255, 255),
})
make(closeBtn, "UICorner", { CornerRadius = UDim.new(0, 8) })

local reopenBtn = make(screenGui, "TextButton", {
    Name = "Reopen",
    Visible = false,
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 12, 1, -12),
    Size = UDim2.fromOffset(110, 34),
    BackgroundColor3 = Color3.fromRGB(38, 40, 48),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "Open Loader",
    TextSize = 13,
    TextColor3 = Color3.fromRGB(240, 244, 255),
})
make(reopenBtn, "UICorner", { CornerRadius = UDim.new(0, 10) })
make(reopenBtn, "UIStroke", {
    Color = Color3.fromRGB(108, 178, 255),
    Thickness = 1,
})

local content = make(main, "ScrollingFrame", {
    Name = "Content",
    Position = UDim2.fromOffset(0, 46),
    Size = UDim2.new(1, 0, 1, -46),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 6,
    CanvasSize = UDim2.fromOffset(0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.None,
    ScrollingDirection = Enum.ScrollingDirection.Y,
})

local contentPadding = make(content, "UIPadding", {
    PaddingTop = UDim.new(0, 14),
    PaddingBottom = UDim.new(0, 14),
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
})

local contentLayout = make(content, "UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10),
})

make(content, "TextLabel", {
    LayoutOrder = 1,
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Choose a script from the dropdown, then click Run Selected Script.",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(178, 186, 210),
})

local dropdownWrapper = make(content, "Frame", {
    Name = "DropdownWrapper",
    LayoutOrder = 2,
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundTransparency = 1,
})

local dropdownButton = make(dropdownWrapper, "TextButton", {
    Name = "DropdownButton",
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = Color3.fromRGB(39, 42, 52),
    BorderSizePixel = 0,
    Font = Enum.Font.Gotham,
    Text = "Select Script",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(241, 245, 255),
})
make(dropdownButton, "UICorner", { CornerRadius = UDim.new(0, 8) })

local dropdownPad = make(dropdownButton, "UIPadding", {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
})

local dropdownList = make(dropdownWrapper, "ScrollingFrame", {
    Name = "DropdownList",
    Visible = false,
    Position = UDim2.fromOffset(0, 46),
    Size = UDim2.new(1, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(32, 35, 43),
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

local statusLabel = make(content, "TextLabel", {
    LayoutOrder = 3,
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundColor3 = Color3.fromRGB(34, 36, 44),
    BorderSizePixel = 0,
    Font = Enum.Font.Gotham,
    Text = "Status: Ready",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextWrapped = true,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(161, 227, 188),
})
make(statusLabel, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(statusLabel, "UIPadding", {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
})

local runButton = make(content, "TextButton", {
    LayoutOrder = 4,
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = Color3.fromRGB(70, 126, 210),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "Run Selected Script",
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255, 255, 255),
})
make(runButton, "UICorner", { CornerRadius = UDim.new(0, 8) })

make(content, "TextLabel", {
    LayoutOrder = 5,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Add a custom script so it appears in the dropdown:",
    TextXAlignment = Enum.TextXAlignment.Left,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(178, 186, 210),
})

local nameBox = make(content, "TextBox", {
    LayoutOrder = 6,
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = Color3.fromRGB(39, 42, 52),
    BorderSizePixel = 0,
    PlaceholderText = "Script Name (example: Boss Farm)",
    Font = Enum.Font.Gotham,
    Text = "",
    TextSize = 13,
    TextColor3 = Color3.fromRGB(236, 241, 255),
    PlaceholderColor3 = Color3.fromRGB(144, 151, 172),
    ClearTextOnFocus = false,
})
make(nameBox, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(nameBox, "UIPadding", { PaddingLeft = UDim.new(0, 10) })

local urlBox = make(content, "TextBox", {
    LayoutOrder = 7,
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = Color3.fromRGB(39, 42, 52),
    BorderSizePixel = 0,
    PlaceholderText = "Script URL (https://...)",
    Font = Enum.Font.Gotham,
    Text = "",
    TextSize = 13,
    TextColor3 = Color3.fromRGB(236, 241, 255),
    PlaceholderColor3 = Color3.fromRGB(144, 151, 172),
    ClearTextOnFocus = false,
})
make(urlBox, "UICorner", { CornerRadius = UDim.new(0, 8) })
make(urlBox, "UIPadding", { PaddingLeft = UDim.new(0, 10) })

local addButton = make(content, "TextButton", {
    LayoutOrder = 8,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(52, 56, 68),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "Add Script To Dropdown",
    TextSize = 13,
    TextColor3 = Color3.fromRGB(240, 244, 255),
})
make(addButton, "UICorner", { CornerRadius = UDim.new(0, 8) })

make(content, "TextLabel", {
    LayoutOrder = 9,
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Tip: You can close the loader with X and reopen it with the Open Loader button.",
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(161, 167, 185),
})

local selectedIndex = 1
local isDropdownOpen = false
local isRunning = false

local function setStatus(text, isError)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = isError and Color3.fromRGB(255, 141, 141) or Color3.fromRGB(161, 227, 188)
end

local function updateContentCanvas()
    content.CanvasSize = UDim2.fromOffset(0, contentLayout.AbsoluteContentSize.Y + 24)
end

local function updateDropdownCanvas()
    dropdownList.CanvasSize = UDim2.fromOffset(0, dropdownLayout.AbsoluteContentSize.Y + 8)
end

local function setDropdownOpen(open)
    isDropdownOpen = open
    dropdownList.Visible = open

    if open then
        local targetHeight = math.min(170, (#SCRIPT_CATALOG * 30) + 8)
        dropdownList.Size = UDim2.new(1, 0, 0, targetHeight)
        dropdownWrapper.Size = UDim2.new(1, 0, 0, 46 + targetHeight)
    else
        dropdownList.Size = UDim2.new(1, 0, 0, 0)
        dropdownWrapper.Size = UDim2.new(1, 0, 0, 42)
    end

    updateContentCanvas()
end

local function updateDropdownButtonText()
    local current = SCRIPT_CATALOG[selectedIndex]
    if current then
        dropdownButton.Text = current.name .. "  v"
    else
        dropdownButton.Text = "Select Script  v"
    end
end

local function refreshDropdownItems()
    for _, child in ipairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for index, item in ipairs(SCRIPT_CATALOG) do
        local itemButton = make(dropdownList, "TextButton", {
            LayoutOrder = index,
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = Color3.fromRGB(45, 49, 61),
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = item.name,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(237, 241, 255),
        })
        make(itemButton, "UICorner", { CornerRadius = UDim.new(0, 6) })
        make(itemButton, "UIPadding", { PaddingLeft = UDim.new(0, 8) })

        itemButton.MouseButton1Click:Connect(function()
            selectedIndex = index
            updateDropdownButtonText()
            setDropdownOpen(false)
        end)
    end

    updateDropdownCanvas()
end

local function runSelectedScript()
    if isRunning then
        setStatus("A script is already running. Please wait.", true)
        return
    end

    local selected = SCRIPT_CATALOG[selectedIndex]
    if not selected then
        setStatus("No script selected.", true)
        return
    end

    isRunning = true
    runButton.Text = "Running..."

    task.spawn(function()
        setStatus("Downloading " .. selected.name .. "...", false)

        local okDownload, source = pcall(function()
            return game:HttpGet(selected.url, true)
        end)

        if (not okDownload) or type(source) ~= "string" or source == "" then
            setStatus("Download failed for " .. selected.name, true)
            warn("[Loader] Download failed for", selected.name)
            isRunning = false
            runButton.Text = "Run Selected Script"
            return
        end

        local chunk, compileErr = loadstring(source)
        if type(chunk) ~= "function" then
            setStatus("Compile error in " .. selected.name .. ": " .. tostring(compileErr), true)
            warn("[Loader] Compile error in", selected.name, compileErr)
            isRunning = false
            runButton.Text = "Run Selected Script"
            return
        end

        setStatus("Executing " .. selected.name .. "...", false)
        local okRun, runErr = pcall(chunk)

        if okRun then
            setStatus("Loaded " .. selected.name .. " successfully.", false)
            warn("[Loader] Loaded", selected.name)
        else
            setStatus("Runtime error in " .. selected.name .. ": " .. tostring(runErr), true)
            warn("[Loader] Runtime error in", selected.name, runErr)
        end

        isRunning = false
        runButton.Text = "Run Selected Script"
    end)
end

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContentCanvas)
dropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDropdownCanvas)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    reopenBtn.Visible = true
end)

reopenBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    reopenBtn.Visible = false
end)

dropdownButton.MouseButton1Click:Connect(function()
    setDropdownOpen(not isDropdownOpen)
end)

addButton.MouseButton1Click:Connect(function()
    local customName = (nameBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local customUrl = (urlBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")

    if customName == "" or customUrl == "" then
        setStatus("Enter both a script name and a URL.", true)
        return
    end

    if not customUrl:lower():match("^https?://") then
        setStatus("URL must start with http:// or https://", true)
        return
    end

    table.insert(SCRIPT_CATALOG, {
        name = customName,
        url = customUrl,
    })

    selectedIndex = #SCRIPT_CATALOG
    nameBox.Text = ""
    urlBox.Text = ""

    refreshDropdownItems()
    updateDropdownButtonText()
    setStatus("Added " .. customName .. " to dropdown.", false)
end)

runButton.MouseButton1Click:Connect(runSelectedScript)

-- Drag support for top bar.
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart
local startPos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end)

refreshDropdownItems()
updateDropdownButtonText()
setDropdownOpen(false)
updateContentCanvas()
setStatus("Ready", false)
