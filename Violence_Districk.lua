-- =============================================================================
-- PROJECT: CHEVA HUB - VIOLENCE DISTRICT SUPREME EDITION
-- COMPATIBILITY: Delta Executor Mobile (CoreGui / gethui Bypass)
-- FEATURES: Aimlock (HRP Killer), Chams Killer & Gen (with Progress), Backpack ESP
-- STATUS: ALL FEATURES AUTO-ON / INSTANT ACTIVATION
-- =============================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- State Fitur (Default: ALL ON)
local Config = {
    Aimlock = true,
    ChamsKiller = true,
    ChamsGenerator = true,
    ESPName = true,
    ESPWeapon = true
}

-- Injeksi Antarmuka menggunakan Jalur Proteksi Executor Mobile (Anti-Gagal)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChevaHub_SupremeViolence"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

-- =============================================================================
-- INTERFASE UI (MAIN MENU & OPEN/CLOSE)
-- =============================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 290)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -145)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 120, 255)
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.Text = "CHEVA HUB - VIOLENCE DISTRICT"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 13
Title.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = MainFrame
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TopPadding = Instance.new("Frame")
TopPadding.Size = UDim2.new(1, 0, 0, 35)
TopPadding.BackgroundTransparency = 1
TopPadding.Parent = MainFrame

local function CreateToggle(text, configKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 290, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = MainFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.Code
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 60, 0, 24)
    Btn.Position = UDim2.new(1, -60, 0.5, -12)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = Frame

    local function updateVisual()
        if Config[configKey] then
            Btn.BackgroundColor3 = Color3.fromRGB(15, 50, 15)
            Btn.Text = "ON"
            Btn.TextColor3 = Color3.fromRGB(50, 255, 50)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
            Btn.Text = "OFF"
            Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    Btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        updateVisual()
    end)

    updateVisual()
end

CreateToggle("Aimlock (Lock Killer HRP)", "Aimlock")
CreateToggle("Chams Killer (Red)", "ChamsKiller")
CreateToggle("Chams Generator (Yellow + %)", "ChamsGenerator")
CreateToggle("Show Name ESP", "ESPName")
CreateToggle("Show Weapon (Backpack/Inventory)", "ESPWeapon")

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 24)
ToggleBtn.Text = "CLOSE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 12
ToggleBtn.Parent = ScreenGui

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1.5
ToggleStroke.Color = Color3.fromRGB(0, 120, 255)
ToggleStroke.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleBtn.Text = "OPEN"
        ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 150)
    else
        MainFrame.Visible = true
        ToggleBtn.Text = "CLOSE"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- =============================================================================
-- VISUAL FOV & AIM PREDICTION INDICATOR TEXT (PERSISTENT)
-- =============================================================================
local FOVSize = 70

local FOVRing = Instance.new("Frame")
FOVRing.Size = UDim2.new(0, FOVSize * 2, 0, FOVSize * 2)
FOVRing.Position = UDim2.new(0.5, -FOVSize, 0.5, -FOVSize)
FOVRing.BackgroundTransparency = 1 
FOVRing.Visible = true
FOVRing.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVRing

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.5
FOVStroke.Color = Color3.fromRGB(0, 255, 255)
FOVStroke.Parent = FOVRing

local PredictionLabel = Instance.new("TextLabel")
PredictionLabel.Size = UDim2.new(0, 300, 0, 20)
PredictionLabel.Position = UDim2.new(0.5, -150, 0.5, FOVSize + 5)
PredictionLabel.BackgroundTransparency = 1
PredictionLabel.Text = "Aim Prediction Active (Tracking Killer Movement)"
PredictionLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
PredictionLabel.Font = Enum.Font.Code
PredictionLabel.TextSize = 11
PredictionLabel.Visible = true
PredictionLabel.Parent = ScreenGui

local TextStroke = Instance.new("UIStroke")
TextStroke.Thickness = 1.5
TextStroke.Color = Color3.fromRGB(0, 0, 0)
TextStroke.Parent = PredictionLabel

RunService.RenderStepped:Connect(function()
    FOVRing.Visible = Config.Aimlock
    PredictionLabel.Visible = Config.Aimlock
end)

-- =============================================================================
-- HELPER ENGINE: ROLE FILTER & BACKPACK INVENTORY SCANNER
-- =============================================================================
local function IsKiller(model)
    if model:IsA("Model") then
        if string.find(string.lower(model.Name), "killer") or model:FindFirstChild("Knife") or model:FindFirstChild("Weapon") then
            return true
        end
    end
    return false
end

local function GetAllItemsFromBackpack(player, model)
    local items = {}
    
    -- Ambil dari tas (Backpack) jika ada objek playernya
    if player and player:FindFirstChild("Backpack") then
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then table.insert(items, tool.Name) end
        end
    end
    
    -- Ambil juga yang sedang dipegang di tangan karakter saat ini
    for _, tool in ipairs(model:GetChildren()) do
        if tool:IsA("Tool") then table.insert(items, tool.Name) end
    end
    
    if #items > 0 then
        return table.concat(items, ", ")
    else
        return "Empty Hands"
    end
end

-- =============================================================================
-- CORE LOOP PROCESSING (CHAMS, BACKPACK ESP, GENERATOR TRACKER, AIMLOCK HRP)
-- =============================================================================
local function ProcessGameLogic()
    local Camera = Workspace.CurrentCamera
    local ClosestKiller = nil
    local ShortestDistance = math.huge

    -- PART 1: PLAYER & CHARACTER CORE LOOP (Chams Killer, Name, Backpack ESP)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local pl = Players:GetPlayerFromCharacter(obj)
            local rootPart = obj.HumanoidRootPart
            local head = obj:FindFirstChild("Head")

            if head then
                -- 1. CHAMS KILLER (RED FULL)
                local foundHighlight = obj:FindFirstChild("ChevaKillerCham")
                if Config.ChamsKiller and IsKiller(obj) and obj ~= LocalPlayer.Character then
                    if not foundHighlight then
                        local High = Instance.new("Highlight")
                        High.Name = "ChevaKillerCham"
                        High.FillColor = Color3.fromRGB(255, 0, 0)
                        High.FillTransparency = 0.4
                        High.OutlineColor = Color3.fromRGB(255, 255, 255)
                        High.Adornee = obj
                        High.Parent = obj
                    end
                else
                    if foundHighlight then foundHighlight:Destroy() end
                end

                -- 2. ADVANCED BILLBOARD GUI ESP (NAME + BACKPACK WEAPONS)
                local foundBillboard = obj:FindFirstChild("ChevaAdvancedESP")
                if (Config.ESPName or Config.ESPWeapon) then
                    if not foundBillboard then
                        local Billboard = Instance.new("BillboardGui")
                        Billboard.Name = "ChevaAdvancedESP"
                        Billboard.Size = UDim2.new(0, 220, 0, 50)
                        Billboard.AlwaysOnTop = true
                        Billboard.Adornee = head
                        Billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)
                        Billboard.Parent = obj

                        local NameTag = Instance.new("TextLabel")
                        NameTag.Name = "NameTag"
                        NameTag.Size = UDim2.new(1, 0, 0, 20)
                        NameTag.BackgroundTransparency = 1
                        NameTag.Font = Enum.Font.Code
                        NameTag.TextSize = 12
                        NameTag.Parent = Billboard
                        Instance.new("UIStroke", NameTag).Color = Color3.fromRGB(0, 0, 0)

                        local WeaponTag = Instance.new("TextLabel")
                        WeaponTag.Name = "WeaponTag"
                        WeaponTag.Size = UDim2.new(1, 0, 0, 20)
                        WeaponTag.Position = UDim2.new(0, 0, 0, 22)
                        WeaponTag.BackgroundTransparency = 1
                        WeaponTag.Font = Enum.Font.Code
                        WeaponTag.TextSize = 11
                        WeaponTag.Parent = Billboard
                        Instance.new("UIStroke", WeaponTag).Color = Color3.fromRGB(0, 0, 0)
                    else
                        local baseName = pl and pl.Name or obj.Name
                        local rolePrefix = IsKiller(obj) and "[KILLER] " or "[SURVIVOR] "
                        
                        if obj == LocalPlayer.Character then
                            baseName = "YOU (" .. baseName .. ")"
                        end

                        foundBillboard.NameTag.Text = Config.ESPName and (rolePrefix .. baseName) or ""
                        foundBillboard.NameTag.TextColor3 = IsKiller(obj) and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 100)

                        -- DETEKSI BACKPACK (Tetap terbaca biarpun tidak di-equip)
                        local backpackItems = GetAllItemsFromBackpack(pl, obj)
                        foundBillboard.WeaponTag.Text = Config.ESPWeapon and ("Holding: " .. backpackItems) or ""
                        foundBillboard.WeaponTag.TextColor3 = Color3.fromRGB(255, 220, 50)
                    end
                else
                    if foundBillboard then foundBillboard:Destroy() end
                end
            end

            -- 3. AIMLOCK LOCK ON TARGET (MENGUNCI HUMANOIDROOTPART KILLER)
            if Config.Aimlock and IsKiller(obj) and obj ~= LocalPlayer.Character then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if magnitude <= FOVSize and magnitude < ShortestDistance then
                        ClosestKiller = obj
                        ShortestDistance = magnitude
                    end
                end
            end
        end

        -- PART 2: GENERATOR RADAR LOOP (Chams Kuning + Progress Tracker)
        if obj:IsA("Model") and string.find(string.lower(obj.Name), "generator") then
            -- Chams Kuning Full
            local genHighlight = obj:FindFirstChild("ChevaGenCham")
            if Config.ChamsGenerator then
                if not genHighlight then
                    local High = Instance.new("Highlight")
                    High.Name = "ChevaGenCham"
                    High.FillColor = Color3.fromRGB(255, 255, 0) -- Kuning Full
                    High.FillTransparency = 0.4
                    High.OutlineColor = Color3.fromRGB(255, 255, 255)
                    High.Adornee = obj
                    High.Parent = obj
                end
            else
                if genHighlight then genHighlight:Destroy() end
            end

            -- Mengambil Nilai Progress Generator (mencari intValue/numberValue progress di dalam model)
            local progressValue = obj:FindFirstChild("Progress") or obj:FindFirstChild("ProgressValue")
            local currentPercent = "0%"
            if progressValue then
                currentPercent = tostring(math.floor(progressValue.Value)) .. "%"
            end

            -- Membuat Text Progress Di Atas Generator
            local genBillboard = obj:FindFirstChild("ChevaGenProgress")
            if Config.ChamsGenerator then
                if not genBillboard then
                    local Billboard = Instance.new("BillboardGui")
                    Billboard.Name = "ChevaGenProgress"
                    Billboard.Size = UDim2.new(0, 150, 0, 30)
                    Billboard.AlwaysOnTop = true
                    Billboard.ExtentsOffset = Vector3.new(0, 4, 0)
                    Billboard.Parent = obj

                    local ProgressTag = Instance.new("TextLabel")
                    ProgressTag.Name = "ProgressTag"
                    ProgressTag.Size = UDim2.new(1, 0, 1, 0)
                    ProgressTag.BackgroundTransparency = 1
                    ProgressTag.Font = Enum.Font.Code
                    ProgressTag.TextSize = 13
                    ProgressTag.TextColor3 = Color3.fromRGB(255, 255, 50)
                    ProgressTag.Parent = Billboard
                    Instance.new("UIStroke", ProgressTag).Color = Color3.fromRGB(0, 0, 0)
                else
                    genBillboard.ProgressTag.Text = "GENERATOR: " .. currentPercent
                end
            else
                if genBillboard then genBillboard:Destroy() end
            end
        end
    end

    -- EKSEKUSI AIM PREDICTION PADA HUMANOIDROOTPART TARGET
    if ClosestKiller and Config.Aimlock then
        local targetRoot = ClosestKiller.HumanoidRootPart
        local pingSimulationOffset = 0.165 
        local predictedPosition = targetRoot.Position + (targetRoot.Velocity * pingSimulationOffset)
        
        -- Mengunci kamera ke titik prediksi HumanoidRootPart Killer
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPosition)
    end
end

-- Render loop konstan tanpa drop frame
RunService.RenderStepped:Connect(function()
    pcall(ProcessGameLogic)
end)
