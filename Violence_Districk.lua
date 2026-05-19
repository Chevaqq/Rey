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

-- ==================== LOADING SCREEN ====================
local function showLoadingScreen()
	local loadingGui = Instance.new("ScreenGui")
	loadingGui.Name = "LoadingScreen"
	loadingGui.ResetOnSpawn = false
	loadingGui.Parent = playerGui

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "LoadingText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.BackgroundTransparency = 0
	textLabel.Text = "Made by Cheva"
	textLabel.TextSize = 48
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = loadingGui

	-- Add stroke effect
	local textStroke = Instance.new("UIStroke")
	textStroke.Color = Color3.fromRGB(0, 0, 0)
	textStroke.Thickness = 3
	textStroke.Parent = textLabel

	-- Fade in
	textLabel.TextTransparency = 1
	for i = 1, 0, -0.02 do
		textLabel.TextTransparency = i
		wait(0.025)
	end

	-- Hold for 0.5 seconds
	wait(0.5)

	-- Fade out
	for i = 0, 1, 0.02 do
		textLabel.TextTransparency = i
		wait(0.025)
	end

	loadingGui:Destroy()
end

-- ==================== KEY SCREEN ====================
local function showKeyScreen()
	local keyGui = Instance.new("ScreenGui")
	keyGui.Name = "KeyScreen"
	keyGui.ResetOnSpawn = false
	keyGui.Parent = playerGui

	-- Background
	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0
	bg.Parent = keyGui

	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 100)
	title.Position = UDim2.new(0, 0, 0.2, 0)
	title.BackgroundTransparency = 1
	title.Text = "Violence District"
	title.TextSize = 60
	title.TextColor3 = Color3.fromRGB(100, 150, 255)
	title.Font = Enum.Font.GothamBold
	title.Parent = bg

	-- Key Input
	local keyInput = Instance.new("TextBox")
	keyInput.Name = "KeyInput"
	keyInput.Size = UDim2.new(0, 400, 0, 50)
	keyInput.Position = UDim2.new(0.5, -200, 0.4, 0)
	keyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
	keyInput.BackgroundTransparency = 0.3
	keyInput.TextColor3 = Color3.fromRGB(100, 150, 255)
	keyInput.TextSize = 24
	keyInput.PlaceholderText = "Masukkan Key..."
	keyInput.Font = Enum.Font.Gotham
	keyInput.Parent = bg

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(100, 150, 255)
	stroke.Thickness = 2
	stroke.Parent = keyInput

	-- Info
	local info = Instance.new("TextLabel")
	info.Name = "Info"
	info.Size = UDim2.new(1, 0, 0, 100)
	info.Position = UDim2.new(0, 0, 0.5, 0)
	info.BackgroundTransparency = 1
	info.Text = "VIP: ChevaHub-VIP\nFREE: Cheva"
	info.TextSize = 20
	info.TextColor3 = Color3.fromRGB(200, 200, 200)
	info.Font = Enum.Font.Gotham
	info.Parent = bg

	-- Submit Button
	local submitBtn = Instance.new("TextButton")
	submitBtn.Name = "SubmitBtn"
	submitBtn.Size = UDim2.new(0, 150, 0, 50)
	submitBtn.Position = UDim2.new(0.5, -75, 0.65, 0)
	submitBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
	submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	submitBtn.TextSize = 20
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.Text = "Submit"
	submitBtn.Parent = bg

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(100, 150, 255)
	btnStroke.Thickness = 2
	btnStroke.Parent = submitBtn

	-- Error Message
	local errorMsg = Instance.new("TextLabel")
	errorMsg.Name = "ErrorMsg"
	errorMsg.Size = UDim2.new(1, 0, 0, 50)
	errorMsg.Position = UDim2.new(0, 0, 0.75, 0)
	errorMsg.BackgroundTransparency = 1
	errorMsg.Text = ""
	errorMsg.TextSize = 18
	errorMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
	errorMsg.Font = Enum.Font.GothamBold
	errorMsg.Parent = bg

	-- Submit function
	local function submitKey()
		local key = keyInput.Text
		if key == "ChevaHub-VIP" then
			isVIP = true
			currentUser = "VIP User"
			isLoggedIn = true
			keyGui:Destroy()
		elseif key == "Cheva" then
			isVIP = false
			currentUser = "Free User"
			isLoggedIn = true
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
	menuGui.Parent = playerGui

	-- Background (Rotating clock effect)
	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
	bg.BackgroundTransparency = 0
	bg.Parent = menuGui

	-- Side Panel
	local sidePanel = Instance.new("Frame")
	sidePanel.Name = "SidePanel"
	sidePanel.Size = UDim2.new(0, 250, 1, 0)
	sidePanel.BackgroundColor3 = Color3.fromRGB(15, 20, 50)
	sidePanel.BackgroundTransparency = 0
	sidePanel.Parent = bg

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
		tabBtn.Position = UDim2.new(0, 5, 0, 60 + (i - 1) * 60)
		tabBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
		tabBtn.BackgroundTransparency = 0.3
		tabBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
		tabBtn.TextSize = 18
		tabBtn.Font = Enum.Font.GothamBold
		tabBtn.Text = tabName
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
	userFrame.Size = UDim2.new(1, -10, 0, 60)
	userFrame.Position = UDim2.new(0, 5, 1, -70)
	userFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 70)
	userFrame.BackgroundTransparency = 0.3
	userFrame.Parent = sidePanel

	local userStroke = Instance.new("UIStroke")
	userStroke.Color = Color3.fromRGB(100, 150, 255)
	userStroke.Thickness = 1
	userStroke.Parent = userFrame

	local userLabel = Instance.new("TextLabel")
	userLabel.Name = "UserLabel"
	userLabel.Size = UDim2.new(1, 0, 0.5, 0)
	userLabel.Position = UDim2.new(0, 0, 0, 0)
	userLabel.BackgroundTransparency = 1
	userLabel.Text = currentUser .. " " .. (isVIP and "[VIP]" or "[FREE]")
	userLabel.TextSize = 14
	userLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
	userLabel.Font = Enum.Font.GothamBold
	userLabel.Parent = userFrame

	local logoutBtn = Instance.new("TextButton")
	logoutBtn.Name = "LogoutBtn"
	logoutBtn.Size = UDim2.new(1, 0, 0.5, 0)
	logoutBtn.Position = UDim2.new(0, 0, 0.5, 0)
	logoutBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	logoutBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	logoutBtn.TextSize = 12
	logoutBtn.Font = Enum.Font.GothamBold
	logoutBtn.Text = "Logout"
	logoutBtn.Parent = userFrame

	logoutBtn.MouseButton1Click:Connect(function()
		isLoggedIn = false
		menuGui:Destroy()
		showKeyScreen()
	end)

	-- Content Panel
	local contentPanel = Instance.new("Frame")
	contentPanel.Name = "ContentPanel"
	contentPanel.Size = UDim2.new(1, -250, 1, 0)
	contentPanel.Position = UDim2.new(0, 250, 0, 0)
	contentPanel.BackgroundColor3 = Color3.fromRGB(15, 25, 55)
	contentPanel.BackgroundTransparency = 0
	contentPanel.Parent = bg

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
	scrollFrame.Parent = contentPanel

	-- Function to add toggle
	function addToggle(parent, name, vipOnly)
		if vipOnly and not isVIP then
			local vipLabel = Instance.new("TextLabel")
			vipLabel.Name = name
			vipLabel.Size = UDim2.new(1, 0, 0, 40)
			vipLabel.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
			vipLabel.BackgroundTransparency = 0.5
			vipLabel.Text = name .. " *[VIP ONLY]*"
			vipLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
			vipLabel.TextSize = 16
			vipLabel.Font = Enum.Font.GothamBold
			vipLabel.Parent = parent
			return
		end

		local container = Instance.new("Frame")
		container.Name = name
		container.Size = UDim2.new(1, 0, 0, 45)
		container.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
		container.BackgroundTransparency = 0.3
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
		toggle.Size = UDim2.new(0, 40, 0, 25)
		toggle.Position = UDim2.new(1, -50, 0.5, -12)
		toggle.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
		toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggle.TextSize = 12
		toggle.Font = Enum.Font.GothamBold
		toggle.Text = "OFF"
		toggle.Parent = container

		local toggleStroke = Instance.new("UIStroke")
		toggleStroke.Color = Color3.fromRGB(100, 150, 255)
		toggleStroke.Thickness = 1
		toggleStroke.Parent = toggle

		local settingKey = name:gsub(" ", ""):gsub("%[.*%]", "")
		settingKey = settingKey:sub(1, 1):lower() .. settingKey:sub(2)

		toggle.MouseButton1Click:Connect(function()
			settings[settingKey] = not settings[settingKey]
			toggle.BackgroundColor3 = settings[settingKey] and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(50, 100, 150)
			toggle.Text = settings[settingKey] and "ON" or "OFF"
		end)

		return container
	end

	-- Function to add slider
	function addSlider(parent, name, minVal, maxVal, default)
		local container = Instance.new("Frame")
		container.Name = name
		container.Size = UDim2.new(1, 0, 0, 50)
		container.BackgroundColor3 = Color3.fromRGB(25, 35, 75)
		container.BackgroundTransparency = 0.3
		container.Parent = parent

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(100, 150, 255)
		stroke.Thickness = 1
		stroke.Parent = container

		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(0.5, 0, 0.5, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = Color3.fromRGB(150, 200, 255)
		label.TextSize = 14
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = container

		local valueInput = Instance.new("TextBox")
		valueInput.Name = "ValueInput"
		valueInput.Size = UDim2.new(0.2, 0, 0.5, 0)
		valueInput.Position = UDim2.new(0.75, 0, 0, 0)
		valueInput.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
		valueInput.TextColor3 = Color3.fromRGB(150, 200, 255)
		valueInput.TextSize = 12
		valueInput.Font = Enum.Font.Gotham
		valueInput.Text = tostring(default)
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
			end
		end)

		return container
	end

	-- Update content based on tab
	function updateContentPanel()
		for _, child in pairs(scrollFrame:GetChildren()) do
			child:Destroy()
		end

		if currentTab == "Main" then
			addToggle(scrollFrame, "Instant Heal", false)
		elseif currentTab == "Survivor" then
			addSlider(scrollFrame, "Walk Speed", 0, 100, 16)
			addSlider(scrollFrame, "Camera Distance", 0, 200, 70)
		elseif currentTab == "Killer" then
			addToggle(scrollFrame, "No Slow", false)
			addToggle(scrollFrame, "Infinite Basic Stack", false)
			addToggle(scrollFrame, "Infinite Abilities", true)
		elseif currentTab == "Combat" then
			addToggle(scrollFrame, "Twist Of Fate", false)
			addSlider(scrollFrame, "FOV", 1, 100, 20)
			addSlider(scrollFrame, "Fast Vault", 1, 6, 1)
			addSlider(scrollFrame, "Aim Prediction", 1, 3, 1)
		elseif currentTab == "Visual" then
			addToggle(scrollFrame, "Chams Killer", false)
			addToggle(scrollFrame, "Chams Survivor", false)
			addToggle(scrollFrame, "Chams Generator", false)
			addToggle(scrollFrame, "Lines", false)
		elseif currentTab == "Misc" then
			addToggle(scrollFrame, "Potato Graphics", false)
			addToggle(scrollFrame, "Anti Admin", false)
			addToggle(scrollFrame, "Anti Fling", false)
			addToggle(scrollFrame, "Headless", false)
			addToggle(scrollFrame, "Korblox", false)
		end
	end

	updateContentPanel()

	-- Close/Open Menu with Delete key
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Delete then
			menuOpen = not menuOpen
			menuGui.Enabled = menuOpen
		end
	end)

	return menuGui
end

-- ==================== MAIN EXECUTION ====================
showLoadingScreen()
wait(1)
showKeyScreen()

-- Wait for login
while not isLoggedIn do
	wait(0.1)
end

-- Create main menu
local mainMenu = createMainMenu()
menuOpen = true

print("✓ Violence District Script Loaded!")
print("✓ User: " .. currentUser .. (isVIP and " [VIP]" or " [FREE]"))
print("✓ Press DELETE to toggle menu")
