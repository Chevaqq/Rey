--[[ 
    VIOLENCE DISTRICT SCRIPT
    Made by Cheva
    Version 1.0
    For Delta Executor
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local CurrentPlayer = Players.LocalPlayer
local PlayerGui = CurrentPlayer:WaitForChild("PlayerGui")

-- Script Config
local CONFIG = {
    VIP_KEYS = {"ChevaHub-VIP"},
    FREE_KEYS = {"Cheva"},
    MENU_TOGGLE_KEY = Enum.KeyCode.Delete,
}

-- User Session
local UserSession = {
    IsAuthenticated = false,
    IsVIP = false,
    Username = CurrentPlayer.Name,
    FeatureSettings = {},
}

-- Features State
local Features = {
    Main = {
        InstantHeal = false,
    },
    Survivor = {
        WalkSpeed = 16,
        CameraDistance = 70,
    },
    Killer = {
        NoSlow = false,
        InfiniteBasicStack = false,
        InfiniteAbilities = false,
    },
    Combat = {
        TwistOfFate = false,
        FOV = 20,
        FastVault = false,
        FastVaultSpeed = 1,
        AimPrediction = 1,
    },
    Visual = {
        ChamsKiller = false,
        ChamsSurvivor = false,
        ChamsGenerator = false,
        Lines = false,
    },
    Misc = {
        PotatoGraphics = false,
        AntiAdmin = false,
        AntiFling = false,
        Headless = false,
        Korblox = false,
    },
}

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function CreateOutlineText(text, size)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextSize = size
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = false
    label.Font = Enum.Font.GothamBold
    
    -- Outline effect using stroke
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Parent = label
    
    return label
end

local function CreateLoadingScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.Parent = screenGui
    
    local titleLabel = CreateOutlineText("Made by Cheva", 60)
    titleLabel.Size = UDim2.new(0, 400, 0, 100)
    titleLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
    titleLabel.Parent = background
    
    -- Fade in animation (0.5s)
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.InOut
    )
    
    titleLabel.TextTransparency = 1
    local fadeinTween = TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0})
    fadeinTween:Play()
    
    wait(2)
    
    -- Fade out animation (0.5s)
    local fadeoutTween = TweenService:Create(titleLabel, tweenInfo, {TextTransparency = 1})
    fadeoutTween:Play()
    fadeoutTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

local function SaveSettings()
    UserSession.FeatureSettings = Features
    print("[Violence District] Settings saved!")
end

local function LoadSettings()
    if UserSession.FeatureSettings and next(UserSession.FeatureSettings) then
        Features = UserSession.FeatureSettings
        print("[Violence District] Settings loaded!")
    end
end

-- ============================================
-- KEY AUTHENTICATION UI
-- ============================================

local function CreateKeyAuthScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeyAuth"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    background.BorderSizePixel = 0
    background.Parent = screenGui
    
    -- Rotating clock animation background
    local clockFrame = Instance.new("Frame")
    clockFrame.Size = UDim2.new(1, 0, 1, 0)
    clockFrame.BackgroundTransparency = 1
    clockFrame.Parent = background
    
    local titleLabel = CreateOutlineText("VIOLENCE DISTRICT", 50)
    titleLabel.Size = UDim2.new(0, 500, 0, 80)
    titleLabel.Position = UDim2.new(0.5, -250, 0.3, -40)
    titleLabel.Parent = background
    
    -- Key input frame
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 300, 0, 150)
    keyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    keyFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    keyFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    keyFrame.BorderSizePixel = 2
    keyFrame.Parent = background
    
    local keyLabel = CreateOutlineText("Enter Key:", 20)
    keyLabel.Size = UDim2.new(1, 0, 0, 30)
    keyLabel.Position = UDim2.new(0, 10, 0, 10)
    keyLabel.Parent = keyFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 0, 40)
    textBox.Position = UDim2.new(0, 10, 0, 50)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    textBox.BorderColor3 = Color3.fromRGB(0, 150, 255)
    textBox.TextColor3 = Color3.fromRGB(0, 200, 255)
    textBox.TextSize = 18
    textBox.Font = Enum.Font.Gotham
    textBox.PlaceholderText = "Paste key here..."
    textBox.Parent = keyFrame
    
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(1, -20, 0, 40)
    submitButton.Position = UDim2.new(0, 10, 0, 100)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    submitButton.BorderSizePixel = 0
    submitButton.Text = "SUBMIT"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.TextSize = 16
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Parent = keyFrame
    
    local function ValidateKey(key)
        for _, vipKey in ipairs(CONFIG.VIP_KEYS) do
            if key == vipKey then
                UserSession.IsVIP = true
                UserSession.IsAuthenticated = true
                screenGui:Destroy()
                LoadSettings()
                CreateMainMenu()
                return
            end
        end
        
        for _, freeKey in ipairs(CONFIG.FREE_KEYS) do
            if key == freeKey then
                UserSession.IsVIP = false
                UserSession.IsAuthenticated = true
                screenGui:Destroy()
                LoadSettings()
                CreateMainMenu()
                return
            end
        end
        
        textBox.Text = ""
        textBox.PlaceholderText = "Invalid Key! Try again..."
    end
    
    submitButton.MouseButton1Click:Connect(function()
        ValidateKey(textBox.Text)
    end)
    
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ValidateKey(textBox.Text)
        end
    end)
    
    textBox:CaptureFocus()
end

-- ============================================
-- MAIN MENU UI
-- ============================================

local MenuOpen = false
local CurrentTab = "Main"

local function CreateMainMenu()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainMenu"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 100
    screenGui.Parent = PlayerGui
    
    -- Main Menu Frame
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 500, 0, 600)
    menuFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    menuFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    menuFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    menuFrame.BorderSizePixel = 2
    menuFrame.Parent = screenGui
    
    -- Corner radius effect
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = menuFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    header.BorderSizePixel = 0
    header.Parent = menuFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header
    
    local titleText = CreateOutlineText("VIOLENCE DISTRICT", 24)
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Parent = header
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        MenuOpen = false
        screenGui:Destroy()
    end)
    
    -- Tab buttons
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 50)
    tabFrame.Position = UDim2.new(0, 0, 0, 50)
    tabFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = menuFrame
    
    local tabs = {"Main", "Survivor", "Killer", "Combat", "Visual", "Misc"}
    local tabButtons = {}
    
    local function CreateTabButton(tabName, index)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1/6, -2, 1, 0)
        button.Position = UDim2.new((index-1)/6, (index-1)*2, 0, 0)
        button.BackgroundColor3 = CurrentTab == tabName and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(30, 40, 60)
        button.BorderSizePixel = 0
        button.Text = tabName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.GothamBold
        button.Parent = tabFrame
        
        button.MouseButton1Click:Connect(function()
            CurrentTab = tabName
            screenGui:Destroy()
            CreateMainMenu()
        end)
        
        table.insert(tabButtons, button)
    end
    
    for i, tabName in ipairs(tabs) do
        CreateTabButton(tabName, i)
    end
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -150)
    contentFrame.Position = UDim2.new(0, 0, 0, 100)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = menuFrame
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    scrollingFrame.Parent = contentFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollingFrame
    
    -- Load tab content
    if CurrentTab == "Main" then
        LoadMainTab(scrollingFrame)
    elseif CurrentTab == "Survivor" then
        LoadSurvivorTab(scrollingFrame)
    elseif CurrentTab == "Killer" then
        LoadKillerTab(scrollingFrame)
    elseif CurrentTab == "Combat" then
        LoadCombatTab(scrollingFrame)
    elseif CurrentTab == "Visual" then
        LoadVisualTab(scrollingFrame)
    elseif CurrentTab == "Misc" then
        LoadMiscTab(scrollingFrame)
    end
    
    -- Bottom bar with user info
    local bottomFrame = Instance.new("Frame")
    bottomFrame.Size = UDim2.new(1, 0, 0, 50)
    bottomFrame.Position = UDim2.new(0, 0, 1, -50)
    bottomFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
    bottomFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    bottomFrame.BorderSizePixel = 2
    bottomFrame.Parent = menuFrame
    
    local avatarLabel = Instance.new("ImageLabel")
    avatarLabel.Size = UDim2.new(0, 40, 0, 40)
    avatarLabel.Position = UDim2.new(0, 5, 0.5, -20)
    avatarLabel.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    avatarLabel.BorderSizePixel = 1
    avatarLabel.BorderColor3 = Color3.fromRGB(0, 150, 255)
    avatarLabel.Image = Players:GetUserThumbnailAsync(CurrentPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    avatarLabel.Parent = bottomFrame
    
    local userLabel = CreateOutlineText(UserSession.Username .. (UserSession.IsVIP and " [VIP]" or " [FREE]"), 16)
    userLabel.Size = UDim2.new(0, 200, 0, 40)
    userLabel.Position = UDim2.new(0, 50, 0, 5)
    userLabel.Parent = bottomFrame
    
    -- Logout button
    local logoutButton = Instance.new("TextButton")
    logoutButton.Size = UDim2.new(0, 80, 0, 40)
    logoutButton.Position = UDim2.new(1, -85, 0, 5)
    logoutButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    logoutButton.BorderSizePixel = 0
    logoutButton.Text = "LOGOUT"
    logoutButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoutButton.TextSize = 12
    logoutButton.Font = Enum.Font.GothamBold
    logoutButton.Parent = bottomFrame
    
    local logoutCorner = Instance.new("UICorner")
    logoutCorner.CornerRadius = UDim.new(0, 5)
    logoutCorner.Parent = logoutButton
    
    logoutButton.MouseButton1Click:Connect(function()
        UserSession.IsAuthenticated = false
        UserSession.IsVIP = false
        screenGui:Destroy()
        CreateKeyAuthScreen()
    end)
    
    MenuOpen = true
end

-- ============================================
-- TAB CONTENT LOADERS
-- ============================================

function LoadMainTab(parent)
    local function CreateToggle(featureName, defaultState, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 40)
        container.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
        container.BorderColor3 = Color3.fromRGB(0, 150, 255)
        container.BorderSizePixel = 1
        container.Parent = parent
        
        local label = CreateOutlineText(featureName, 16)
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 30)
        toggle.Position = UDim2.new(1, -55, 0.5, -15)
        toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        toggle.BorderSizePixel = 0
        toggle.Text = defaultState and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 12
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = container
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 5)
        toggleCorner.Parent = toggle
        
        local state = defaultState
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
            toggle.Text = state and "ON" or "OFF"
            callback(state)
        end)
    end
    
    CreateToggle("Instant Heal", Features.Main.InstantHeal, function(state)
        Features.Main.InstantHeal = state
        if state then
            -- Implement instant heal feature
        end
    end)
end

function LoadSurvivorTab(parent)
    local function CreateSlider(featureName, min, max, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 60)
        container.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
        container.BorderColor3 = Color3.fromRGB(0, 150, 255)
        container.BorderSizePixel = 1
        container.Parent = parent
        
        local label = CreateOutlineText(featureName, 16)
        label.Size = UDim2.new(1, -10, 0, 20)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0, 60, 0, 25)
        inputBox.Position = UDim2.new(1, -65, 0, 5)
        inputBox.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
        inputBox.BorderColor3 = Color3.fromRGB(0, 150, 255)
        inputBox.TextColor3 = Color3.fromRGB(0, 200, 255)
        inputBox.Text = tostring(default)
        inputBox.TextSize = 14
        inputBox.Font = Enum.Font.Gotham
        inputBox.Parent = container
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, -10, 0, 5)
        sliderBar.Position = UDim2.new(0, 5, 0, 35)
        sliderBar.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
        sliderBar.BorderColor3 = Color3.fromRGB(0, 150, 255)
        sliderBar.BorderSizePixel = 1
        sliderBar.Parent = container
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        fill.BorderSizePixel = 0
        fill.Parent = sliderBar
        
        inputBox.FocusLost:Connect(function()
            local value = tonumber(inputBox.Text) or default
            value = math.clamp(value, min, max)
            inputBox.Text = tostring(value)
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            callback(value)
        end)
    end
    
    CreateSlider("Walk Speed", 10, 50, Features.Survivor.WalkSpeed, function(value)
        Features.Survivor.WalkSpeed = value
    end)
    
    CreateSlider("Camera Distance", 50, 200, Features.Survivor.CameraDistance, function(value)
        Features.Survivor.CameraDistance = value
    end)
end

function LoadKillerTab(parent)
    local function CreateToggle(featureName, defaultState, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -10, 0, 40)
        container.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
        container.BorderColor3 = Color3.fromRGB(0, 150, 255)
        container.BorderSizePixel = 1
        container.Parent = parent
        
        local label = CreateOutlineText(featureName, 16)
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 30)
        toggle.Position = UDim2.new(1, -55, 0.5, -15)
        toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        toggle.BorderSizePixel = 0
        toggle.Text = defaultState and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 12
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = container
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 5)
        toggleCorner.Parent = toggle
        
        local state = defaultState
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
            toggle.Text = state and "ON" or "OFF"
            callback(state)
        end)
    end
    
    CreateToggle("No Slow", Features.Killer.NoSlow, function(state)
        Features.Killer.NoSlow = state
    end)
    
    CreateToggle("Infinite Basic Stack", Features.Killer.InfiniteBasicStack, fu
