-- [[ GUI CREATION ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local OpenCloseBtn = Instance.new("TextButton")

-- Parent ke CoreGui biar nggak gampang kehapus kalau kamu mati/reset
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tombol Open/Close (Kecil di pinggir layar)
OpenCloseBtn.Name = "OpenCloseBtn"
OpenCloseBtn.Parent = ScreenGui
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
OpenCloseBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenCloseBtn.Size = UDim2.new(0, 80, 0, 35)
OpenCloseBtn.Font = Enum.Font.SourceSansBold
OpenCloseBtn.Text = "Menu"
OpenCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenCloseBtn.TextSize = 14
OpenCloseBtn.BorderSizePixel = 0

-- UI Corner untuk mempercantik tombol
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = OpenCloseBtn

-- Menu Utama (Frame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Visible = false -- Mulai dengan tersembunyi
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Biar menunya bisa digeser di layar Delta

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = MainFrame

-- Judul Menu
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA GODMODE"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.TextSize = 18

-- Tombol ON/OFF God Mode
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (OFF)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 45)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "God Mode: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
ToggleBtn.BorderSizePixel = 0

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = ToggleBtn

-- [[ FUNCTIONALITY ]]
local player = game:GetService("Players").LocalPlayer
local godModeEnabled = false
local connection

-- Fungsi inti God Mode
local function enableGodMode()
    if connection then connection:Disconnect() end
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if godModeEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Isi darah penuh terus-menerus
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                
                -- Mematikan fungsi mati bawaan Roblox
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                
                -- Cegah mati karena jatuh ke Void (di bawah map)
                if player.Character.PrimaryPart and player.Character.PrimaryPart.Position.Y < -500 then
                    player.Character.PrimaryPart.CFrame = CFrame.new(0, 50, 0) -- Teleport balik ke atas map
                end
            end
        end
    end)
end

local function disableGodMode()
    if connection then connection:Disconnect() end
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
end

-- Logic Klik Tombol ON/OFF
ToggleBtn.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        ToggleBtn.Text = "God Mode: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau (ON)
        enableGodMode()
    else
        ToggleBtn.Text = "God Mode: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (OFF)
        disableGodMode()
    end
end)

-- Logic Klik Tombol Open/Close Menu
OpenCloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Reset script otomatis pas karakter kamu respawn/ganti map
player.CharacterAdded:Connect(function()
    if godModeEnabled then
        task.wait(0.5) -- Tunggu karakter nge-load sempurna
        enableGodMode()
    end
end)
