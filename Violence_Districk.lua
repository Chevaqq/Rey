-- Violence District Script - Made by Cheva
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()

-- ==================== VARIABLES ====================
local isVIP = false
local currentUser = "Unknown"
local isLoggedIn = false
local currentTab = "Main"
local menuOpen = false
local mainMenuGui = nil

local settings = {
	instantHeal = false,
	walkSpeed = 16,
	cameraDistance = 70,
	noSlow = false,
	infiniteBasicStack = false,
	infiniteAbilities = false,
	twistOfFate = false,
	fov = 20,
	fastVault = 1,
	aimPrediction = 1,
	chamsKiller = false,
	chamsSurvivor = false,
	chamsGenerator = false,
	lines = false,
	potatoGraphics = false,
	antiAdmin = false,
	antiFling = false,
	headless = false,
	korblox = false
}

-- ==================== SAVE/LOAD ====================
local function saveSettings()
	local dataFile = "ViolenceDistrictSettings.json"
	-- Simpan ke file lokal (untuk executor yang support)
	if writefile then
		writefile(dataFile, game:GetService("HttpService"):JSONEncode(settings))
	end
end

local function loadSettings()
	local dataFile = "ViolenceDistrictSettings.json"
	if isfile and isfile(dataFile) then
		local data = game:GetService("HttpService"):JSONDecode(readfile(dataFile))
		for k, v in pairs(data) do
			if settings[k] ~= nil then
				settings[k] = v
			end
		end
	end
end

-- ==================== LOADING SCREEN ====================
local function showLoadingScreen()
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "LoadingScreen"
	loadingGui.ResetOnSpawn = false
	loadingGui.ZIndex = 999
	loadingGui.Parent = playerGui

	-- Black Background
	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0
	bg.BorderSizePixel = 0
	bg.Parent = loadingGui

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "LoadingText"
	textLabel.Size = UDim2.new(0, 400, 0, 100)
	textLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "Made by Cheva"
	textLabel.TextSize = 48
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = bg

	-- Add stroke effect
	local textStroke = Instance.new("UIStroke")
	textStroke.Color = Color3.fromRGB(0, 0, 0)
	textStroke.Thickness = 4
	textStroke.Parent = textLabel

	-- Fade in
	textLabel.TextTransparency = 1
	for i = 1, 0, -0.02 do
		textLabel.TextTransparency = i
		wait(0.01)
	end

	-- Hold for 0.5 seconds
	wait(0.5)

	-- Fade out
	for i = 0, 1, 0.02 do
		textLabel.TextTransparency = i
		wait(0.01)
	end

	loadingGui:Destroy()
end

-- ==================== KEY SCREEN ====================
local function showKeyScreen()
	local keyGui = Instance.new("ScreenGui")
	keyGui.Name = "KeyScreen"
	keyGui.ResetOnSpawn = false
	keyGui.ZIndex = 998
	keyGui.Parent = playerGui

	-- Background
	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
	bg.BackgroundTransparency = 0
	bg.BorderSizePixel = 0
	bg.Parent = keyGui

	-- Main Container (Centered, Medium Size)
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 500, 0, 400)
	container.Position = UDim2.new(0.5, -250, 0.5, -200)
	container.BackgroundColor3 = Color3.fromRGB(15, 25, 55)
	container.BackgroundTransparency = 0
	container.BorderSizePixel = 0
	container.Parent = bg

	local containerStroke = Instance.new("UIStroke")
	containerStroke.Color = Color3.fromRGB(100, 150, 255)
	containerStroke.Thickness = 3
	containerStroke.Parent = container

	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 80)
	title.Position = UDim2.new(0, 0, 0, 20)
	title.BackgroundTransparency = 1
	title.Text = "Violence District"
	title.TextSize = 48
	title.TextColor3 = Color3.fromRGB(100, 150, 255)
	title.Font = Enum.Font.GothamBold
	title.Parent = container

	-- Key Input
	local keyInput = Instance.new("TextBox")
	keyInput.Name = "KeyInput"
	keyInput.Size = UDim2.new(0, 350, 0, 50)
	keyInput.Position = UDim2.new(0.5, -175, 0, 120)
	keyInput.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
	keyInput.BackgroundTransparency = 0.2
	keyInput.TextColor3 = Color3.fromRGB(100, 150, 255)
	keyInput.TextSize = 24
	keyInput.PlaceholderText = "Masukkan Key..."
	keyInput.Font = Enum.Font.Gotham
	keyInput.BorderSizePixel = 0
	keyInput.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 150, 255)
	stroke.Thickness = 2
	stroke.Parent = keyInput

	-- Info
	local info = Instance.new("TextLabel")
	info.Name = "Info"
	info.Size = UDim2.new(1, 0, 0, 80)
	info.Position = UDim2.new(0, 0, 0, 180)
	info.BackgroundTransparency = 1
	info.Text = "VIP: ChevaHub-VIP\nFREE: Cheva"
	info.TextSize = 18
	info.TextColor3 = Color3.fromRGB(200, 200, 200)
	info.Font = Enum.Font.Gotham
	info.Parent = container

	-- Submit Button
	local submitBtn = Instance.new("TextButton")
	submitBtn.Name = "SubmitBtn"
	submitBtn.Size = UDim2.new(0, 150, 0, 45)
	submitBtn.Position = UDim2.new(0.5, -75, 0, 280)
	submitBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
	submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	submitBtn.TextSize = 20
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.Text = "Submit"
	submitBtn.BorderSizePixel = 0
	submitBtn.Parent = container

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(100, 150, 255)
	btnStroke.Thickness = 2
	btnStroke.Parent = submitBtn

	-- Error Message
	local errorMsg = Instance.new("TextLabel")
	errorMsg.Name = "ErrorMsg"
	errorMsg.Size = UDim2.new(1, 0, 0, 50)
	errorMsg.Position = UDim2.new(0, 0, 0, 340)
	errorMsg.BackgroundTransparency = 1
	errorMsg.Text = ""
	errorMsg.TextSize = 16
	errorMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
	errorMsg.Font = Enum.Font.GothamBold
	errorMsg.Parent = container

	-- Submit function
	local function submitKey()
		local key = keyInput.Text
		if key == "ChevaHub-VIP" then
			isVIP = true
			currentUser = "VIP User"
			isLoggedIn = true
			loadSettings()
			keyGui:Destroy()
		elseif key == "Cheva" then
			isVIP = false
			currentUser = "Free User"
			isLoggedIn = true
			loadSettings()
			keyGui:Destroy()
		else
			errorMsg.Text = "Key salah!"
			wait(2)
			errorMsg.Text = ""
		end
	end

	submitBtn.MouseButton1Click:Connect(submitKey)
	keyInput.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			submitKey()
		end
	end)
end

-- ==================== MAIN MENU ====================
local function createMainMenu()
	local menuGui = Instance.new("ScreenGui")
	menuGui.Name = "MainMenu"
	menuGui.ResetOnSpawn = false
	menuGui.ZIndex = 100
	menuGui.Parent = playerGui

	-- Main Container (Centered, Medium Size)
	local mainContainer = Instance.new("Frame")
	mainContainer.Name = "MainContainer"
	mainContainer.Size = UDim2.new(0, 900, 0, 600)
	mainContainer.Position = UDim2.new(0.5, -450, 0.5, -300)
	mainContainer.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
	mainContainer.BackgroundTransparency = 0
	mainContainer.BorderSizePixel = 0
	mainContainer.Parent = menuGui

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(100, 150, 255)
	mainStroke.Thickness = 3
	mainStroke.Parent = mainContainer

	-- Side Panel
	local sidePanel = Instance.new("Frame")
	sidePanel.Name = "SidePanel"
	sidePanel.Size = UDim2.new(0, 250, 1, 0)
	sidePanel.Position = UDim2.new(0, 0, 0, 0)
	sidePanel.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
	sidePanel.BackgroundTransparency = 0
	sidePanel.BorderSizePixel = 0
	sidePanel.Parent = mainContainer

	local sidePanelStroke = Instance.new("UIStroke")
	sidePanelStroke.Color = Color3.fromRGB(100, 150, 255)
	sidePanelStroke.Thickness = 2
	sidePanelStroke.Parent = sidePanel

	-- Tabs
	local tabs = {"Main", "Survivor", "Killer", "Combat", "Visual", "Misc"}
	local tabButtons = {}

	for i, tabName in ipairs(tabs) do
		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = tabName
		tabBtn.Size = UDim2.new(1, -10, 0, 50)
		tabBtn.Position = UDim2.new(0, 5, 0, 20 + (i - 1) * 55)
		tabBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
		tabBtn.BackgroundTransparency = 0.3
		tabBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
		tabBtn.TextSize = 16
		tabBtn.Font = Enum.Font.GothamBold
		tabBtn.Text = tabName
		tabBtn.BorderSizePixel = 0
		tabBtn.Parent = sidePanel

		local tabStroke = Instance.new("UIStroke")
		tabStroke.Color = Color3.fromRGB(100, 150, 255)
		tabStroke.Thickness = 1
		tabStroke.Parent = tabBtn

		tabBtn.MouseButton1Click:Connect(function()
			currentTab = tabName
			updateContentPanel()
		end)

		tabButtons[tabName] = tabBtn
	end

	-- User Info (Bottom Left)
	local userFrame = Instance.new("Frame")
	userFrame.Name = "UserFrame"
	userFrame.Size = UDim2.new(1, -10, 0, 100)
	userFrame.Position = UDim2.new(0, 5, 1, -110)
	userFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
	userFrame.BackgroundTransparency = 0.3
	userFrame.BorderSizePixel = 0
	userFrame.Parent = sidePanel

	local userStroke = Instance.new("UIStroke")
	userStroke.Color = Color3.fromRGB(100, 150, 255)
	userStroke.Thickness = 1
	userStroke.Parent = userFrame

	-- User Label
	local userLabel = Instance.new("TextLabel")
	userLabel.Name = "UserLabel"
	userLabel.Size = UDim2.new(1, 0, 0.4, 0)
	userLabel.Position = UDim2.new(0, 5, 0, 5)
	userLabel.BackgroundTransparency = 1
	userLabel.Text = currentUser .. " " .. (isVIP and "[VIP]" or "[FREE]")
	userLabel.TextSize = 14
	userLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
	userLabel.Font = Enum.Font.GothamBold
	userLabel.TextXAlignment = Enum.TextXAlignment.Left
	userLabel.Parent = userFrame

	-- Logout Button
	local logoutBtn = Instance.new("TextButton")
	logoutBtn.Name = "LogoutBtn"
	logoutBtn.Size = UDim2.new(1, -10, 0, 40)
	logoutBtn.Position = UDim2.new(0, 5, 0, 50)
	logoutBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	logoutBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	logoutBtn.TextSize = 14
	logoutBtn.Font = Enum.Font.GothamBold
	logoutBtn.Text = "Logout"
	logoutBtn.BorderSizePixel = 0
	logoutBtn.Parent = userFrame

	logoutBtn.MouseButton1Click:Connect(function()
		isLoggedIn = false
		menuGui:Destroy()
		wait(0.5)
		showKeyScreen()
	end)

	-- Content Panel
	local contentPanel = Instance.new("Frame")
	contentPanel.Name = "ContentPanel"
	contentPanel.Size = UDim2.new(1, -250, 1, 0)
	contentPanel.Position = UDim2.new(0, 250, 0, 0)
	contentPanel.BackgroundColor3 = Color3.fromRGB(15, 25, 55)
	contentPanel.BackgroundTransparency = 0
	contentPanel.BorderSizePixel = 0
	contentPanel.Parent = mainContainer

	local contentStroke = Instance.new("UIStroke")
	contentStroke.Color = Color3.fromRGB(100, 150, 255)
	contentStroke.Thickness = 2
	contentStroke.Parent = contentPanel

	-- Scroll
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Size = UDim2.new(1, -20, 1, -20)
	scrollFrame.Position = UDim2.new(0, 10, 0, 10)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.Parent = contentPanel

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = scrollFrame

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
	end)

	-- Function to add toggle
	function addToggle(parent, name, vipOnly)
		if vipOnly and not isVIP then
			local vipLabel = Instance.new("TextLabel")
			vipLabel.Name = name
			vipLabel.Size = UDim2.new(1, 0, 0, 45)
			vipLabel.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
			vipLabel.BackgroundTransparency = 0.5
			vipLabel.BorderSizePixel = 0
			vipLabel.Text = name .. " *[VIP ONLY]*"
			vipLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
			vipLabel.TextSize = 16
			vipLabel.Font = Enum.Font.GothamBold
			vipLabel.Parent = parent
			return
		end

		local container = Instance.new("Frame")
		container.Name = name
		container.Size = UDim2.new(1, 0, 0, 50)
		container.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
		container.BackgroundTransparency = 0.3
		container.BorderSizePixel = 0
		container.Parent = parent

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(100, 150, 255)
		stroke.Thickness = 1
		stroke.Parent = container

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, -50, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = Color3.fromRGB(150, 200, 255)
		label.TextSize = 16
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = container

		local toggle = Instance.new("TextButton")
		toggle.Name = "Toggle"
		toggle.Size = UDim2.new(0, 45, 0, 28)
		toggle.Position = UDim2.new(1, -55, 0.5, -14)
		toggle.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
		toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggle.TextSize = 12
		toggle.Font = Enum.Font.GothamBold
		toggle.Text = "OFF"
		toggle.BorderSizePixel = 0
		toggle.Parent = container

		local toggleStroke = Instance.new("UIStroke")
		toggleStroke.Color = Color3.fromRGB(100, 150, 255)
		toggleStroke.Thickness = 1
		toggleStroke.Parent = toggle

		local settingKey = name:gsub(" ", ""):gsub("%[.*%]", "")
		settingKey = settingKey:sub(1, 1):lower() .. settingKey:sub(2)

		-- Initialize with saved state
		if settings[settingKey] then
			toggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
			toggle.Text = "ON"
		end

		toggle.MouseButton1Click:Connect(function()
			settings[settingKey] = not settings[settingKey]
			toggle.BackgroundColor3 = settings[settingKey] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 100, 150)
			toggle.Text = settings[settingKey] and "ON" or "OFF"
			executeFeature(settingKey, settings[settingKey])
			saveSettings()
		end)

		return container
	end

	-- Function to add slider
	function addSlider(parent, name, minVal, maxVal, default)
		local container = Instance.new("Frame")
		container.Name = name
		container.Size = UDim2.new(1, 0, 0, 60)
		container.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
		container.BackgroundTransparency = 0.3
		container.BorderSizePixel = 0
		container.Parent = parent

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(100, 150, 255)
		stroke.Thickness = 1
		stroke.Parent = container

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, 0, 0.5, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = Color3.fromRGB(150, 200, 255)
		label.TextSize = 14
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = container

		local valueInput = Instance.new("TextBox")
		valueInput.Name = "ValueInput"
		valueInput.Size = UDim2.new(0, 80, 0, 30)
		valueInput.Position = UDim2.new(1, -90, 0.5, -15)
		valueInput.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
		valueInput.TextColor3 = Color3.fromRGB(150, 200, 255)
		valueInput.TextSize = 12
		valueInput.Font = Enum.Font.Gotham
		valueInput.Text = tostring(settings[name:gsub(" ", ""):gsub("%[.*%]", ""):sub(1, 1):lower() .. name:gsub(" ", ""):gsub("%[.*%]", ""):sub(2)] or default)
		valueInput.BorderSizePixel = 0
		valueInput.Parent = container

		local inputStroke = Instance.new("UIStroke")
		inputStroke.Color = Color3.fromRGB(100, 150, 255)
		inputStroke.Thickness = 1
		inputStroke.Parent = valueInput

		local settingKey = name:gsub(" ", ""):gsub("%[.*%]", "")
		settingKey = settingKey:sub(1, 1):lower() .. settingKey:sub(2)

		valueInput.FocusLost:Connect(function()
			local val = tonumber(valueInput.Text)
			if val then
				val = math.clamp(val, minVal, maxVal)
				settings[settingKey] = val
				valueInput.Text = tostring(val)
				executeFeature(settingKey, val)
				saveSettings()
			end
		end)

		return container
	end

	-- Function to add prediction selector
	function addPredictionSelector(parent, name)
		local container = Instance.new("Frame")
		container.Name = name
		container.Size = UDim2.new(1, 0, 0, 50)
		container.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
		container.BackgroundTransparency = 0.3
		container.BorderSizePixel = 0
		container.Parent = parent

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(100, 150, 255)
		stroke.Thickness = 1
		stroke.Parent = container

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(0.6, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = Color3.fromRGB(150, 200, 255)
		label.TextSize = 16
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = container

		local modeBtn = Instance.new("TextButton")
		modeBtn.Name = "ModeBtn"
		modeBtn.Size = UDim2.new(0, 80, 0, 28)
		modeBtn.Position = UDim2.new(1, -90, 0.5, -14)
		modeBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
		modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		modeBtn.TextSize = 14
		modeBtn.Font = Enum.Font.GothamBold
		modeBtn.Text = "Mode: " .. settings.aimPrediction
		modeBtn.BorderSizePixel = 0
		modeBtn.Parent = container

		local btnStroke = Instance.new("UIStroke")
		btnStroke.Color = Color3.fromRGB(100, 150, 255)
		btnStroke.Thickness = 1
		btnStroke.Parent = modeBtn

		modeBtn.MouseButton1Click:Connect(function()
			settings.aimPrediction = settings.aimPrediction % 3 + 1
			modeBtn.Text = "Mode: " .. settings.aimPrediction
			saveSettings()
		end)

		return container
	end

	-- Execute Feature Function
	function executeFeature(featureKey, value)
		if featureKey == "instantHeal" and value then
			print("✓ Instant Heal: AKTIF")
		elseif featureKey == "walkSpeed" then
			print("✓ Walk Speed diset ke: " .. value)
		elseif featureKey == "cameraDistance" then
			print("✓ Camera Distance diset ke: " .. value)
		elseif featureKey == "noSlow" and value then
			print("✓ No Slow: AKTIF")
		elseif featureKey == "infiniteBasicStack" and value then
			print("✓ Infinite Basic Stack: AKTIF")
		elseif featureKey == "infiniteAbilities" and value then
			print("✓ Infinite Abilities: AKTIF")
		elseif featureKey == "twistOfFate" and value then
			print("✓ Twist Of Fate: AKTIF")
		elseif featureKey == "fov" then
			print("✓ FOV diset ke: " .. value)
		elseif featureKey == "fastVault" then
			print("✓ Fast Vault diset ke: " .. value)
		elseif featureKey == "chamsKiller" and value then
			print("✓ Chams Killer: AKTIF")
		elseif featureKey == "chamsSurvivor" and value then
			print("✓ Chams Survivor: AKTIF")
		elseif featureKey == "chamsGenerator" and value then
			print("✓ Chams Generator: AKTIF")
		elseif featureKey == "lines" and value then
			print("✓ Lines: AKTIF")
		elseif featureKey == "potatoGraphics" and value then
			print("✓ Potato Graphics: AKTIF")
		elseif featureKey == "antiAdmin" and value then
			print("✓ Anti Admin: AKTIF")
		elseif featureKey == "antiFling" and value then
			print("✓ Anti Fling: AKTIF")
		elseif featureKey == "headless" and value then
			print("✓ Headless: AKTIF")
		elseif featureKey == "korblox" and value then
			print("✓ Korblox: AKTIF")
		end
	end

	-- Update content based on tab
	function updateContentPanel()
		for _, child in pairs(scrollFrame:GetChildren()) do
			if child:IsA("Frame") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end

		if currentTab == "Main" then
			addToggle(scrollFrame, "Instant Heal", false)
		else
