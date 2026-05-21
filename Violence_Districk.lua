-- =============================================================================
-- PROJECT: CHEVA HUB - VIOLENCE DISTRICT SPECIAL EDITION
-- COMPATIBILITY: Delta Executor Mobile (CoreGui / gethui Bypass)
-- FEATURES: Aimlock (Killer Only), Chams Killer (Red Full), FOV Center Ring (Size 70)
-- STATUS: ALL FEATURES AUTO-ON / INSTANT ACTIVATION
-- =============================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Membuat ScreenGui Utama menggunakan jalur proteksi bypass executor
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChevaHub_ViolenceSpecial"
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
-- FEATURE 1: FOV CENTER RING (STATIS DI TENGAH, TRANSPARAN)
-- =============================================================================
local FOVSize = 70

local FOVRing = Instance.new("Frame")
FOVRing.Size = UDim2.new(0, FOVSize * 2, 0, FOVSize * 2)
FOVRing.Position = UDim2.new(0.5, -FOVSize, 0.5, -FOVSize)
FOVRing.BackgroundTransparency = 1 -- Tengahnya bolong / transparan total
FOVRing.Visible = true
FOVRing.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0) -- Membuat frame menjadi lingkaran sempurna
FOVCorner.Parent = FOVRing

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 2
FOVStroke.Color = Color3.fromRGB(0, 255, 255) -- Warna garis tepi (Cyan neon)
FOVStroke.Parent = FOVRing


-- =============================================================================
-- FEATURE 2: CHAMS KILLER (RED FULL) & AIMLOCK CORE ENGINE
-- =============================================================================
local function IsKiller(model)
    -- Memeriksa tanda-tanda karakter tersebut adalah killer di Violence District
    if model:IsA("Model") and model ~= LocalPlayer.Character then
        if string.find(string.lower(model.Name), "killer") or model:FindFirstChild("Knife") or model:FindFirstChild("Weapon") then
            return true
        end
    end
    return false
end

local function ApplyVisualAndLogic()
    local Camera = Workspace.CurrentCamera
    local ClosestKiller = nil
    local ShortestDistance = math.huge

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if IsKiller(obj) then
                -- 1. CHAMS KILLER (Aplikasi Warna Merah)
                local foundHighlight = obj:FindFirstChild("ChevaKillerCham")
                if not foundHighlight then
                    local High = Instance.new("Highlight")
                    High.Name = "ChevaKillerCham"
                    High.FillColor = Color3.fromRGB(255, 0, 0) -- Merah Penuh
                    High.FillTransparency = 0.4
                    High.OutlineColor = Color3.fromRGB(255, 255, 255)
                    High.OutlineTransparency = 0.2
                    High.Adornee = obj
                    High.Parent = obj
                end

                -- Logika mencari killer terdekat untuk Aimlock
                local rootPart = obj.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    -- Menghitung jarak dari posisi karakter ke tengah layar (pusat FOV)
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if magnitude <= FOVSize and magnitude < ShortestDistance then
                        ClosestKiller = rootPart
                        ShortestDistance = magnitude
                    end
                end
            end
        end
    end

    -- 2. AIMLOCK (Kamera langsung mengunci target Killer terdekat di dalam FOV)
    if ClosestKiller then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, ClosestKiller.Position)
    end
end

-- Menjalankan semua fungsi secara konstan setiap frame (Auto-On)
RunService.RenderStepped:Connect(function()
    pcall(ApplyVisualAndLogic)
end)

-- Notifikasi tanda skrip aktif
local Notif = Instance.new("TextLabel")
Notif.Size = UDim2.new(0, 300, 0, 40)
Notif.Position = UDim2.new(0.5, -150, 0.1, 0)
Notif.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Notif.TextColor3 = Color3.fromRGB(0, 255, 150)
Notif.Text = "[CHEVA HUB] Special Features Loaded & ON!"
Notif.Font = Enum.Font.Code
Notif.TextSize = 12
Notif.Parent = ScreenGui
local NotifStroke = Instance.new("UIStroke")
NotifStroke.Color = Color3.fromRGB(0, 200, 255)
NotifStroke.Parent = Notif

task.delay(3.5, function()
    Notif:Destroy()
end)
