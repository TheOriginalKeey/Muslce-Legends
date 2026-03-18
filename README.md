local DXD_URL = "https://codeberg.org/vdvedvegbgeb/vdvedvegbgeb/raw/branch/main/DxD.lua"
local KXK_URL = "https://codeberg.org/vdvedvegbgeb/vdvedvegbgeb/raw/branch/main/KxK.lua"
local KEEY_URL = "https://raw.githubusercontent.com/TheOriginalKeey/Muslce-Legends/main/keey-main.lua"
local YUMMY_DUCK_URL = "https://raw.githubusercontent.com/googlyeyed1/yummy-duck/refs/heads/main/yummy%20duck"

local uiParent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")

local function safeLoad(name, url, statusLabel)
	statusLabel.Text = "Loading " .. name .. "..."

	local okGet, source = pcall(function()
		return game:HttpGet(url, true)
	end)

	if not okGet or type(source) ~= "string" or source == "" then
		statusLabel.Text = "Failed to download " .. name
		warn("[Keey Loader] Download failed for", name, url)
		return
	end

	local okRun, errRun = pcall(function()
		loadstring(source)()
	end)

	if okRun then
		statusLabel.Text = "Loaded " .. name
	else
		statusLabel.Text = "Runtime error in " .. name
		warn("[Keey Loader] Runtime error for", name, errRun)
	end
end

local function makeButton(parent, text)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 34)
	button.BackgroundColor3 = Color3.fromRGB(126, 31, 194)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BorderSizePixel = 0
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = text
	button.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button

	return button
end

local gui = Instance.new("ScreenGui")
gui.Name = "KeeyUniversalLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = uiParent

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 380, 0, 280)
frame.Position = UDim2.new(0.5, -190, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(13, 2, 20)
frame.BorderSizePixel = 0
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(126, 31, 194)
stroke.Thickness = 1
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 34)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Keey Loader"
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(126, 31, 194)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -24, 0, 20)
info.Position = UDim2.new(0, 12, 0, 44)
info.BackgroundTransparency = 1
info.TextXAlignment = Enum.TextXAlignment.Left
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.Text = "Pick one script to execute"
info.Parent = frame

local buttons = Instance.new("Frame")
buttons.Size = UDim2.new(1, -24, 0, 156)
buttons.Position = UDim2.new(0, 12, 0, 70)
buttons.BackgroundTransparency = 1
buttons.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = buttons

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 20)
status.Position = UDim2.new(0, 12, 1, -30)
status.BackgroundTransparency = 1
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = "Ready"
status.Parent = frame

local dxdBtn = makeButton(buttons, "DxD (Farm)")
local kxkBtn = makeButton(buttons, "KxK (Fight)")
local keeyBtn = makeButton(buttons, "Keey Main")
local duckBtn = makeButton(buttons, "Yummy Duck")

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

dxdBtn.MouseButton1Click:Connect(function()
	task.spawn(safeLoad, "DxD", DXD_URL, status)
end)

kxkBtn.MouseButton1Click:Connect(function()
	task.spawn(safeLoad, "KxK", KXK_URL, status)
end)

keeyBtn.MouseButton1Click:Connect(function()
	task.spawn(safeLoad, "Keey Main", KEEY_URL, status)
end)

duckBtn.MouseButton1Click:Connect(function()
	task.spawn(safeLoad, "Yummy Duck", YUMMY_DUCK_URL, status)
end)

-- Drag support
local dragging = false
local dragInput
local dragStart
local startPos
local UIS = game:GetService("UserInputService")

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
 
