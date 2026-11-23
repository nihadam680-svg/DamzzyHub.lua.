--[[
    ╔══════════════════════════════════════╗
    ║         Damzzy.Hub v1.1              ║
    ║   For: Break and Steal an Egg        ║
    ║   Optimized + Loader Notification    ║
    ╚══════════════════════════════════════╝
]]

-- ========== LOADER NOTIFICATION ==========
local CoreGui = game:GetService("CoreGui")

local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "DamzzyLoader"
LoaderGui.ResetOnSpawn = false
LoaderGui.IgnoreGuiInset = true
LoaderGui.DisplayOrder = 999
LoaderGui.Parent = CoreGui

local LoaderFrame = Instance.new("Frame")
LoaderFrame.Parent = LoaderGui
LoaderFrame.Size = UDim2.new(0, 280, 0, 90)
LoaderFrame.Position = UDim2.new(0.5, -140, 0.5, -45)
LoaderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
LoaderFrame.BorderSizePixel = 0

local LF_Corner = Instance.new("UICorner")
LF_Corner.CornerRadius = UDim.new(0, 10)
LF_Corner.Parent = LoaderFrame

local LF_Stroke = Instance.new("UIStroke")
LF_Stroke.Color = Color3.fromRGB(0, 255, 180)
LF_Stroke.Thickness = 2
LF_Stroke.Parent = LoaderFrame

local LF_Title = Instance.new("TextLabel")
LF_Title.Parent = LoaderFrame
LF_Title.Size = UDim2.new(1, 0, 0, 35)
LF_Title.Position = UDim2.new(0, 0, 0, 10)
LF_Title.BackgroundTransparency = 1
LF_Title.Text = "Damzzy.Hub"
LF_Title.TextColor3 = Color3.fromRGB(0, 255, 180)
LF_Title.Font = Enum.Font.GothamBlack
LF_Title.TextSize = 22

local LF_Sub = Instance.new("TextLabel")
LF_Sub.Parent = LoaderFrame
LF_Sub.Size = UDim2.new(1, 0, 0, 18)
LF_Sub.Position = UDim2.new(0, 0, 0, 36)
LF_Sub.BackgroundTransparency = 1
LF_Sub.Text = "Loading script..."
LF_Sub.TextColor3 = Color3.fromRGB(200, 200, 220)
LF_Sub.Font = Enum.Font.Gotham
LF_Sub.TextSize = 11

local LF_BarBG = Instance.new("Frame")
LF_BarBG.Parent = LoaderFrame
LF_BarBG.Size = UDim2.new(1, -30, 0, 5)
LF_BarBG.Position = UDim2.new(0, 15, 0, 65)
LF_BarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
LF_BarBG.BorderSizePixel = 0

local LF_BarBG_C = Instance.new("UICorner")
LF_BarBG_C.CornerRadius = UDim.new(1, 0)
LF_BarBG_C.Parent = LF_BarBG

local LF_Bar = Instance.new("Frame")
LF_Bar.Parent = LF_BarBG
LF_Bar.Size = UDim2.new(0, 0, 1, 0)
LF_Bar.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
LF_Bar.BorderSizePixel = 0

local LF_Bar_C = Instance.new("UICorner")
LF_Bar_C.CornerRadius = UDim.new(1, 0)
LF_Bar_C.Parent = LF_Bar

local TweenService = game:GetService("TweenService")
TweenService:Create(LF_Bar, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.wait(1)
TweenService:Create(LoaderFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
for _, child in ipairs(LoaderFrame:GetDescendants()) do
    if child:IsA("TextLabel") then
        TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    elseif child:IsA("Frame") then
        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    end
end
task.wait(0.35)
LoaderGui:Destroy()

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ========== KONFIGURASI ==========
local Config = {
    AutoBreakEgg = false,
    AutoCollect = false,
    AutoSell = false,
    SelectedBreakArea = nil,
    SafeZonePosition = Vector3.new(0, 50, 0),
    SellDelay = 1,
    CollectRadius = 50,
}

-- ========== CACHE ==========
local EggCache = {}
local SellPadCache = nil

local function RefreshEggCache()
    EggCache = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = string.lower(obj.Name)
            if n:find("egg") and not n:find("steal") then
                table.insert(EggCache, obj)
            end
        end
    end
end

local function FindSellPad()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = string.lower(obj.Name)
            if n:find("sell") or n:find("shop") or n:find("cashier") then
                SellPadCache = obj
                return obj
            end
        end
    end
    return nil
end

task.spawn(function()
    RefreshEggCache()
    FindSellPad()
end)

if game.CoreGui:FindFirstChild("DamzzyHub") then
    game.CoreGui.DamzzyHub:Destroy()
end

-- ========== GUI UTAMA ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DamzzyHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 100, 0, 35)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "Damzzy.Hub"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 255, 180)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 180)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 220))
})
HeaderGradient.Rotation = 90
HeaderGradient.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Damzzy.Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Header
SubTitle.Size = UDim2.new(1, -100, 0, 15)
SubTitle.Position = UDim2.new(0, 15, 0, 25)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Break and Steal an Egg"
SubTitle.TextColor3 = Color3.fromRGB(200, 255, 240)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = Header
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -70, 0, 8)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 180)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)

local Padding = Instance.new("UIPadding")
Padding.Parent = ScrollFrame
Padding.PaddingTop = UDim.new(0, 5)
Padding.PaddingLeft = UDim.new(0, 5)
Padding.PaddingRight = UDim.new(0, 5)

-- ========== HELPER ==========
local function CreateToggle(name, text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Parent = ScrollFrame
    Toggle.Size = UDim2.new(1, -10, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Toggle.BorderSizePixel = 0
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Toggle

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(60, 60, 80)
    Stroke.Thickness = 1
    Stroke.Parent = Toggle

    local Label = Instance.new("TextLabel")
    Label.Parent = Toggle
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("Frame")
    Switch.Parent = Toggle
    Switch.Size = UDim2.new(0, 45, 0, 22)
    Switch.Position = UDim2.new(1, -55, 0.5, -11)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Switch.BorderSizePixel = 0

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(1, 0)
    SC.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Parent = Switch
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 2, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(1, 0)
    KC.Parent = Knob

    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 150)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 255, 180)}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 80)}):Play()
        end
        if callback then callback(enabled) end
    end)
    return Toggle
end

local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = ScrollFrame
    Btn.Size = UDim2.new(1, -10, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.AutoButtonColor = false

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Btn

    local S = Instance.new("UIStroke")
    S.Color = Color3.fromRGB(60, 60, 80)
    S.Thickness = 1
    S.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return Btn
end

local function CreateSection(text)
    local Section = Instance.new("TextLabel")
    Section.Parent = ScrollFrame
    Section.Size = UDim2.new(1, -10, 0, 25)
    Section.BackgroundTransparency = 1
    Section.Text = "▸ " .. text
    Section.TextColor3 = Color3.fromRGB(0, 255, 180)
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 12
    Section.TextXAlignment = Enum.TextXAlignment.Left
    return Section
end

local function CreateTextBox(placeholder, defaultText, callback)
    local TB = Instance.new("TextBox")
    TB.Parent = ScrollFrame
    TB.Size = UDim2.new(1, -10, 0, 38)
    TB.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TB.BorderSizePixel = 0
    TB.Text = defaultText or ""
    TB.PlaceholderText = placeholder
    TB.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    TB.TextColor3 = Color3.fromRGB(220, 220, 220)
    TB.Font = Enum.Font.Gotham
    TB.TextSize = 12
    TB.ClearTextOnFocus = false

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = TB

    TB.FocusLost:Connect(function()
        if callback then callback(TB.Text) end
    end)
    return TB
end

-- ========== FUNGSI UTAMA ==========
local function GetHRP()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function AutoBreakEgg()
    task.spawn(function()
        while Config.AutoBreakEgg do
            task.wait(0.15)
            local hrp = GetHRP()
            if not hrp then continue end

            if Config.SelectedBreakArea and Config.SelectedBreakArea.Parent then
                hrp.CFrame = CFrame.new(Config.SelectedBreakArea.Position + Vector3.new(0, 3, 0))
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new())
                end)
            else
                if #EggCache == 0 then RefreshEggCache() end
                local nearest, dist = nil, math.huge
                for _, egg in ipairs(EggCache) do
                    if egg.Parent then
                        local d = (egg.Position - hrp.Position).Magnitude
                        if d < dist then nearest = egg; dist = d end
                    end
                end
                if nearest then
                    hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new())
                    end)
                end
            end
        end
    end)
end

local function AutoCollect()
    task.spawn(function()
        while Config.AutoCollect do
            task.wait(0.3)
            local hrp = GetHRP()
            if not hrp then continue end

            local nearest, dist = nil, Config.CollectRadius
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") then
                    local n = string.lower(obj.Name)
                    if n:find("coin") or n:find("cash") or n:find("money") or n:find("drop") then
                        local d = (obj.Position - hrp.Position).Magnitude
                        if d < dist then nearest = obj; dist = d end
                    end
                end
            end

            if nearest then
                hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
                task.wait(0.1)
            else
                hrp.CFrame = CFrame.new(Config.SafeZonePosition)
            end
        end
    end)
end

local function AutoSell()
    task.spawn(function()
        while Config.AutoSell do
            task.wait(Config.SellDelay)
            if not SellPadCache or not SellPadCache.Parent then
                FindSellPad()
            end
            if SellPadCache then
                local hrp = GetHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(SellPadCache.Position + Vector3.new(0, 3, 0))
                    task.wait(0.4)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new())
                    end)
                end
            end
        end
    end)
end

local function SelectBreakArea()
    if #EggCache == 0 then RefreshEggCache() end
    if #EggCache == 0 then
        local err = Instance.new("TextLabel")
        err.Parent = ScreenGui
        err.Size = UDim2.new(0, 250, 0, 40)
        err.Position = UDim2.new(0.5, -125, 0, 60)
        err.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        err.Text = "Tidak ada egg ditemukan!"
        err.TextColor3 = Color3.new(1, 1, 1)
        err.Font = Enum.Font.GothamBold
        err.TextSize = 12
        task.delay(2, function() err:Destroy() end)
        return
    end

    if game.CoreGui:FindFirstChild("Damzzy_AreaSelector") then
        game.CoreGui.Damzzy_AreaSelector:Destroy()
    end

    local SelectorGui = Instance.new("ScreenGui")
    SelectorGui.Name = "Damzzy_AreaSelector"
    SelectorGui.ResetOnSpawn = false
    SelectorGui.Parent = game.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Parent = SelectorGui
    Frame.Size = UDim2.new(0, 320, 0, 400)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -200)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Frame.BorderSizePixel = 0

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 10)
    FC.Parent = Frame

    local FS = Instance.new("UIStroke")
    FS.Color = Color3.fromRGB(0, 255, 180)
    FS.Thickness = 2
    FS.Parent = Frame

    local FTitle = Instance.new("TextLabel")
    FTitle.Parent = Frame
    FTitle.Size = UDim2.new(1, 0, 0, 40)
    FTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    FTitle.Text = "Pilih Egg Target"
    FTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
    FTitle.Font = Enum.Font.GothamBold
    FTitle.TextSize = 15

    local FC2 = Instance.new("UICorner")
    FC2.CornerRadius = UDim.new(0, 10)
    FC2.Parent = FTitle

    local CloseSel = Instance.new("TextButton")
    CloseSel.Parent = FTitle
    CloseSel.Size = UDim2.new(0, 30, 0, 30)
    CloseSel.Position = UDim2.new(1, -35, 0, 5)
    CloseSel.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseSel.Text = "X"
    CloseSel.TextColor3 = Color3.new(1, 1, 1)
    CloseSel.Font = Enum.Font.GothamBold
    CloseSel.BorderSizePixel = 0

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(0, 6)
    CC.Parent = CloseSel

    CloseSel.MouseButton1Click:Connect(function() SelectorGui:Destroy() end)

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Parent = Frame
    Scroll.Size = UDim2.new(1, -20, 1, -55)
    Scroll.Position = UDim2.new(0, 10, 0, 45)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 180)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, #EggCache * 
