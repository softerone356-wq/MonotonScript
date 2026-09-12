--[[
    MONOTON VISUALS V1.3
    Mobile + PC
    -------------------------
    Visuals
    - Chams
    - ESP Box
    - ESP Fill
    - ESP Outline
    - ESP Health
    - ESP Corner
    - ESP Skeleton
    - Sakura Aura
    - Snow
    - Stars
    - Green Light Sky

    Movement
    - Speed
    - Jump
    - Air Jump
    - Noclip
    - Fly
        PC: WASD + Space + LeftControl
        Mobile: Roblox Thumbstick + jump/down buttons

    Models
    - Small Snow Hat
    - China Hat

    Animation
    - Animation ID
    - Loop
    - Speed
    - Play / Stop
    - Catalog search hook
--]]

--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==============================================================
-- CONFIG
--==============================================================

local CFG = {
    Version = "1.3",

    Accent = Color3.fromRGB(190, 95, 255),
    Accent2 = Color3.fromRGB(255, 125, 210),

    Chams = false,

    ESPEnabled = false,
    ESPBox = true,
    ESPFill = false,
    ESPOutline = true,
    ESPHealth = false,
    ESPCorner = false,
    ESPSkeleton = false,
    ESPNames = true,
    ESPDistance = true,
    ESPTeamCheck = false,
    ESPMaxDistance = 2000,

    SakuraLeaves = false,
    Snow = false,
    Stars = false,
    SakuraAura = false,

    SakuraAuraRadius = 3.2,
    SakuraAuraCount = 14,

    Night = false,
    GreenSky = false,

    SpeedHack = false,
    Speed = 24,

    JumpBoost = false,
    JumpPower = 75,

    AirJump = false,

    Noclip = false,

    Fly = false,
    FlySpeed = 65,

    SnowHat = false,
    ChinaHat = false,

    AnimationHack = false,
    AnimationId = "",
    AnimationLoop = true,
    AnimationSpeed = 1,
}

--==============================================================
-- CHARACTER
--==============================================================

local Character
local Humanoid
local Root
local Head

local function RefreshCharacter()
    Character = LocalPlayer.Character

    if not Character then
        Humanoid = nil
        Root = nil
        Head = nil
        return
    end

    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    Root = Character:FindFirstChild("HumanoidRootPart")
    Head = Character:FindFirstChild("Head")
end

RefreshCharacter()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    RefreshCharacter()
end)

--==============================================================
-- GUI
--==============================================================

local Existing = game:GetService("CoreGui"):FindFirstChild("MonotonVisuals")

if Existing then
    Existing:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "MonotonVisuals"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    Gui.Parent = gethui()
end)

if not Gui.Parent then
    Gui.Parent = game:GetService("CoreGui")
end

--==============================================================
-- COLORS
--==============================================================

local BG = Color3.fromRGB(10, 9, 16)
local BG2 = Color3.fromRGB(17, 15, 25)
local BG3 = Color3.fromRGB(25, 22, 36)

--==============================================================
-- MAIN WINDOW
--==============================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(720, 470)
Main.Position = UDim2.new(0.5, -360, 0.5, -235)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CFG.Accent
MainStroke.Transparency = 0.35
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

--==============================================================
-- TOP BAR
--==============================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 65)
Top.BackgroundColor3 = BG2
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(22, 9)
Title.Size = UDim2.fromOffset(300, 28)
Title.Font = Enum.Font.GothamBold
Title.Text = "MONOTON"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local SubTitle = Instance.new("TextLabel")
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.fromOffset(23, 35)
SubTitle.Size = UDim2.fromOffset(400, 20)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "VISUALS  •  V1.3"
SubTitle.TextColor3 = CFG.Accent2
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Top

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.AnchorPoint = Vector2.new(1, 0.5)
Status.Position = UDim2.new(1, -22, 0.5, 0)
Status.Size = UDim2.fromOffset(180, 25)
Status.Font = Enum.Font.GothamMedium
Status.Text = "●  MONOTON ONLINE"
Status.TextColor3 = Color3.fromRGB(100,255,160)
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Right
Status.Parent = Top

--==============================================================
-- SIDEBAR
--==============================================================

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(10, 75)
Sidebar.Size = UDim2.fromOffset(155, 385)
Sidebar.BackgroundColor3 = BG2
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 10)
SidePadding.PaddingLeft = UDim.new(0, 8)
SidePadding.PaddingRight = UDim.new(0, 8)
SidePadding.Parent = Sidebar

local Pages = {}
local CurrentPage

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Position = UDim2.fromOffset(175, 75)
    Page.Size = UDim2.new(1, -185, 1, -85)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = CFG.Accent
    Page.CanvasSize = UDim2.new()
    Page.Visible = false
    Page.Parent = Main

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 15
        )
    end)

    Pages[name] = Page

    return Page
end

local function CreateTab(name, page)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = BG3
    Button.BackgroundTransparency = 1
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamMedium
    Button.Text = "   " .. name
    Button.TextColor3 = Color3.fromRGB(180,175,195)
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.AutoButtonColor = false
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(function()

        for _, p in pairs(Pages) do
            p.Visible = false
        end

        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 1
                b.TextColor3 = Color3.fromRGB(180,175,195)
            end
        end

        page.Visible = true
        Button.BackgroundTransparency = 0
        Button.BackgroundColor3 = BG3
        Button.TextColor3 = Color3.new(1,1,1)

        CurrentPage = page
    end)

    return Button
end

--==============================================================
-- CONTROLS
--==============================================================

local function Section(parent, text)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -8, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextColor3 = CFG.Accent2
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    return Label
end

local function Toggle(parent, text, value, callback)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -8, 0, 42)
    Button.BackgroundColor3 = BG2
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Text = ""
    Button.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(14, 0)
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(230,225,240)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Indicator = Instance.new("Frame")
    Indicator.AnchorPoint = Vector2.new(1, 0.5)
    Indicator.Position = UDim2.new(1, -12, 0.5, 0)
    Indicator.Size = UDim2.fromOffset(38, 20)
    Indicator.BackgroundColor3 = Color3.fromRGB(40,37,50)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Button

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(14, 14)
    Dot.Position = UDim2.fromOffset(3, 3)
    Dot.BorderSizePixel = 0
    Dot.Parent = Indicator

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local State = value

    local function Render()

        if State then
            Indicator.BackgroundColor3 = CFG.Accent
            Dot.Position = UDim2.new(1, -17, 0, 3)
            Dot.BackgroundColor3 = Color3.new(1,1,1)
        else
            Indicator.BackgroundColor3 = Color3.fromRGB(40,37,50)
            Dot.Position = UDim2.fromOffset(3,3)
            Dot.BackgroundColor3 = Color3.fromRGB(130,125,140)
        end
    end

    Button.MouseButton1Click:Connect(function()
        State = not State
        Render()
        callback(State)
    end)

    Render()

    return Button
end

local function Slider(parent, text, min, max, value, callback)

    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, -8, 0, 58)
    Holder.BackgroundColor3 = BG2
    Holder.BorderSizePixel = 0
    Holder.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Holder

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(14, 6)
    Label.Size = UDim2.new(1, -90, 0, 20)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(225,220,235)
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Holder

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -70, 0, 6)
    ValueLabel.Size = UDim2.fromOffset(55, 20)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextColor3 = CFG.Accent2
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Holder

    local Bar = Instance.new("Frame")
    Bar.Position = UDim2.fromOffset(14, 36)
    Bar.Size = UDim2.new(1, -28, 0, 5)
    Bar.BackgroundColor3 = Color3.fromRGB(42,39,52)
    Bar.BorderSizePixel = 0
    Bar.Parent = Holder

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1,0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0,0,1,0)
    Fill.BackgroundColor3 = CFG.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1,0)
    FillCorner.Parent = Fill

    local function Set(v)

        v = math.clamp(v,min,max)

        local alpha = (v-min)/(max-min)

        Fill.Size = UDim2.new(alpha,0,1,0)
        ValueLabel.Text = tostring(math.floor(v))

        callback(v)
    end

    local dragging = false

    local function Input(input)

        local x = math.clamp(
            input.Position.X - Bar.AbsolutePosition.X,
            0,
            Bar.AbsoluteSize.X
        )

        local alpha = x / Bar.AbsoluteSize.X

        Set(min + (max-min)*alpha)
    end

    Bar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            Input(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)

        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

                Input(input)
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    Set(value)

    return Holder
end

local function Button(parent, text, callback)

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -8, 0, 40)
    B.BackgroundColor3 = BG3
    B.BorderSizePixel = 0
    B.Font = Enum.Font.GothamBold
    B.Text = text
    B.TextColor3 = Color3.new(1,1,1)
    B.TextSize = 11
    B.AutoButtonColor = false
    B.Parent = parent

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,9)
    C.Parent = B

    B.MouseEnter:Connect(function()
        B.BackgroundColor3 = CFG.Accent
    end)

    B.MouseLeave:Connect(function()
        B.BackgroundColor3 = BG3
    end)

    B.MouseButton1Click:Connect(callback)

    return B
end

local function TextBox(parent, placeholder, text)

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(1, -8, 0, 42)
    Box.BackgroundColor3 = BG2
    Box.BorderSizePixel = 0
    Box.Font = Enum.Font.Gotham
    Box.PlaceholderText = placeholder
    Box.PlaceholderColor3 = Color3.fromRGB(110,105,120)
    Box.Text = text or ""
    Box.TextColor3 = Color3.new(1,1,1)
    Box.TextSize = 11
    Box.ClearTextOnFocus = false
    Box.Parent = parent

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,9)
    C.Parent = Box

    local P = Instance.new("UIPadding")
    P.PaddingLeft = UDim.new(0,13)
    P.PaddingRight = UDim.new(0,13)
    P.Parent = Box

    return Box
end

--==============================================================
-- PAGES
--==============================================================

local Home = CreatePage("Home")
local Visuals = CreatePage("Visuals")
local Movement = CreatePage("Movement")
local Models = CreatePage("Models")
local Animation = CreatePage("Animation")
local Settings = CreatePage("Settings")

CreateTab("HOME", Home)
CreateTab("VISUALS", Visuals)
CreateTab("MOVEMENT", Movement)
CreateTab("MODELS", Models)
CreateTab("ANIMATION", Animation)
CreateTab("SETTINGS", Settings)

--==============================================================
-- HOME
--==============================================================

Section(Home,"MONOTON VISUALS")

local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1,-8,0,70)
Welcome.BackgroundColor3 = BG2
Welcome.BorderSizePixel = 0
Welcome.Font = Enum.Font.Gotham
Welcome.Text =
    "Welcome to Monoton Visuals V1.3\n\n" ..
    "Optimized for PC + mobile."
Welcome.TextColor3 = Color3.fromRGB(210,205,220)
Welcome.TextSize = 12
Welcome.TextWrapped = true
Welcome.TextXAlignment = Enum.TextXAlignment.Left
Welcome.Parent = Home

local WC = Instance.new("UICorner")
WC.CornerRadius = UDim.new(0,10)
WC.Parent = Welcome

local WP = Instance.new("UIPadding")
WP.PaddingLeft = UDim.new(0,16)
WP.Parent = Welcome

Section(Home,"QUICK STATUS")

Toggle(Home,"ESP",CFG.ESPEnabled,function(v)
    CFG.ESPEnabled = v
end)

Toggle(Home,"Fly",CFG.Fly,function(v)
    CFG.Fly = v
end)

Toggle(Home,"Noclip",CFG.Noclip,function(v)
    CFG.Noclip = v
end)

Toggle(Home,"China Hat",CFG.ChinaHat,function(v)
    CFG.ChinaHat = v
end)

--==============================================================
-- VISUALS
--==============================================================

Section(Visuals,"PLAYER ESP")

Toggle(Visuals,"Enable ESP",CFG.ESPEnabled,function(v)
    CFG.ESPEnabled = v
end)

Toggle(Visuals,"Box",CFG.ESPBox,function(v)
    CFG.ESPBox = v
end)

Toggle(Visuals,"Fill Box",CFG.ESPFill,function(v)
    CFG.ESPFill = v
end)

Toggle(Visuals,"Outline Box",CFG.ESPOutline,function(v)
    CFG.ESPOutline = v
end)

Toggle(Visuals,"Health",CFG.ESPHealth,function(v)
    CFG.ESPHealth = v
end)

Toggle(Visuals,"Corner Box",CFG.ESPCorner,function(v)
    CFG.ESPCorner = v
end)

Toggle(Visuals,"Skeleton",CFG.ESPSkeleton,function(v)
    CFG.ESPSkeleton = v
end)

Toggle(Visuals,"Names",CFG.ESPNames,function(v)
    CFG.ESPNames = v
end)

Toggle(Visuals,"Distance",CFG.ESPDistance,function(v)
    CFG.ESPDistance = v
end)

Toggle(Visuals,"Team Check",CFG.ESPTeamCheck,function(v)
    CFG.ESPTeamCheck = v
end)

Slider(
    Visuals,
    "ESP Distance",
    100,
    5000,
    CFG.ESPMaxDistance,
    function(v)
        CFG.ESPMaxDistance = v
    end
)

Section(Visuals,"WORLD")

Toggle(Visuals,"Sakura Leaves",CFG.SakuraLeaves,function(v)
    CFG.SakuraLeaves = v
end)

Toggle(Visuals,"Snow",CFG.Snow,function(v)
    CFG.Snow = v
end)

Toggle(Visuals,"Stars",CFG.Stars,function(v)
    CFG.Stars = v
end)

Toggle(Visuals,"Sakura Aura",CFG.SakuraAura,function(v)
    CFG.SakuraAura = v
end)

Slider(
    Visuals,
    "Aura Radius",
    1,
    8,
    CFG.SakuraAuraRadius,
    function(v)
        CFG.SakuraAuraRadius = v
    end
)

Slider(
    Visuals,
    "Aura Petals",
    4,
    30,
    CFG.SakuraAuraCount,
    function(v)
        CFG.SakuraAuraCount = v
    end
)

Toggle(Visuals,"Green Light Sky",CFG.GreenSky,function(v)
    CFG.GreenSky = v
end)

Toggle(Visuals,"Night",CFG.Night,function(v)
    CFG.Night = v
end)

--==============================================================
-- MOVEMENT
--==============================================================

Section(Movement,"MOVEMENT")

Toggle(Movement,"Speed Hack",CFG.SpeedHack,function(v)
    CFG.SpeedHack = v
end)

Slider(
    Movement,
    "Walk Speed",
    16,
    120,
    CFG.Speed,
    function(v)
        CFG.Speed = v
    end
)

Toggle(Movement,"Jump Boost",CFG.JumpBoost,function(v)
    CFG.JumpBoost = v
end)

Slider(
    Movement,
    "Jump Power",
    50,
    150,
    CFG.JumpPower,
    function(v)
        CFG.JumpPower = v
    end
)

Toggle(Movement,"Air Jump",CFG.AirJump,function(v)
    CFG.AirJump = v
end)

Toggle(Movement,"Noclip",CFG.Noclip,function(v)
    CFG.Noclip = v
end)

Toggle(Movement,"Fly",CFG.Fly,function(v)
    CFG.Fly = v

    if not v and Root then
        Root.AssemblyLinearVelocity =
            Vector3.new(
                Root.AssemblyLinearVelocity.X,
                0,
                Root.AssemblyLinearVelocity.Z
            )

        if Humanoid then
            Humanoid.PlatformStand = false
        end
    end
end)

Slider(
    Movement,
    "Fly Speed",
    10,
    200,
    CFG.FlySpeed,
    function(v)
        CFG.FlySpeed = v
    end
)

--==============================================================
-- MODELS
--==============================================================

Section(Models,"HATS")

Toggle(Models,"Small Snow Hat",CFG.SnowHat,function(v)
    CFG.SnowHat = v
end)

Toggle(Models,"China Hat",CFG.ChinaHat,function(v)
    CFG.ChinaHat = v
end)

--==============================================================
-- ANIMATION
--==============================================================

Section(Animation,"ANIMATION HACK")

local AnimationIdBox = TextBox(
    Animation,
    "Animation ID / rbxassetid://...",
    CFG.AnimationId
)

AnimationIdBox.FocusLost:Connect(function()
    CFG.AnimationId = AnimationIdBox.Text
end)

Toggle(Animation,"Enable Animation",CFG.AnimationHack,function(v)
    CFG.AnimationHack = v
end)

Toggle(Animation,"Loop",CFG.AnimationLoop,function(v)
    CFG.AnimationLoop = v
end)

Slider(
    Animation,
    "Animation Speed",
    1,
    300,
    math.floor(CFG.AnimationSpeed * 100),
    function(v)
        CFG.AnimationSpeed = v / 100
    end
)

--==============================================================
-- ANIMATION PLAYER
--==============================================================

local CurrentAnimationTrack

local function StopAnimation()

    if CurrentAnimationTrack then
        pcall(function()
            CurrentAnimationTrack:Stop(0.15)
            CurrentAnimationTrack:Destroy()
        end)

        CurrentAnimationTrack = nil
    end
end

local function PlayAnimation(id)

    StopAnimation()

    RefreshCharacter()

    if not Humanoid then
        return false
    end

    id = tostring(id or ""):match("%d+")

    if not id then
        return false
    end

    local Animator = Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    local Anim = Instance.new("Animation")
    Anim.AnimationId = "rbxassetid://" .. id

    local success, track = pcall(function()
        return Animator:LoadAnimation(Anim)
    end)

    if not success or not track then
        Anim:Destroy()
        return false
    end

    track.Priority = Enum.AnimationPriority.Action
    track.Looped = CFG.AnimationLoop

    track:Play(
        0.15,
        1,
        CFG.AnimationSpeed
    )

    CurrentAnimationTrack = track

    return true
end

Button(Animation,"PLAY ANIMATION",function()

    CFG.AnimationId = AnimationIdBox.Text

    if CFG.AnimationId ~= "" then
        PlayAnimation(CFG.AnimationId)
    end
end)

Button(Animation,"STOP ANIMATION",function()
    StopAnimation()
end)

--==============================================================
-- CATALOG SEARCH
--==============================================================

Section(Animation,"PUBLIC CATALOG SEARCH")

local SearchBox = TextBox(
    Animation,
    "Search animation name...",
    ""
)

local CatalogStatus = Instance.new("TextLabel")
CatalogStatus.Size = UDim2.new(1,-8,0,30)
CatalogStatus.BackgroundTransparency = 1
CatalogStatus.Font = Enum.Font.Gotham
CatalogStatus.Text = "Search requires an executor HTTP request function."
CatalogStatus.TextColor3 = Color3.fromRGB(145,140,160)
CatalogStatus.TextSize = 10
CatalogStatus.TextXAlignment = Enum.TextXAlignment.Left
CatalogStatus.Parent = Animation

local CatalogResults = Instance.new("Frame")
CatalogResults.Size = UDim2.new(1,-8,0,1)
CatalogResults.BackgroundTransparency = 1
CatalogResults.Parent = Animation

local CRLayout = Instance.new("UIListLayout")
CRLayout.Padding = UDim.new(0,5)
CRLayout.Parent = CatalogResults

local function GetRequestFunction()

    if syn and syn.request then
        return syn.request
    end

    if http and http.request then
        return http.request
    end

    if request then
        return request
    end

    if http_request then
        return http_request
    end

    return nil
end

local function ClearCatalog()

    for _, child in ipairs(CatalogResults:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

local function SearchCatalog(query)

    ClearCatalog()

    local req = GetRequestFunction()

    if not req then
        CatalogStatus.Text =
            "HTTP request API not available. Paste an Animation ID manually."

        return
    end

    CatalogStatus.Text = "Searching catalog..."

    task.spawn(function()

        local encoded = HttpService:UrlEncode(query)

        local url =
            "https://catalog.roblox.com/v1/search/items/details" ..
            "?Keyword=" .. encoded ..
            "&Limit=30"

        local ok, response = pcall(function()
            return req({
                Url = url,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Roblox/WinInet"
                }
            })
        end)

        if not ok or not response then
            CatalogStatus.Text = "Catalog request failed."
            return
        end

        local body = response.Body

        local decodedOk, data = pcall(function()
            return HttpService:JSONDecode(body)
        end)

        if not decodedOk or not data then
            CatalogStatus.Text = "Invalid catalog response."
            return
        end

        local results = data.data or {}

        CatalogStatus.Text =
            "Results: " .. tostring(#results)

        for _, item in ipairs(results) do

            local assetId = item.id
            local name = item.name or ("Animation " .. tostring(assetId))

            local B = Instance.new("TextButton")

            B.Size = UDim2.new(1,0,0,38)
            B.BackgroundColor3 = BG2
            B.BorderSizePixel = 0
            B.Font = Enum.Font.GothamMedium
            B.Text =
                "  " ..
                tostring(name) ..
                "   [" ..
                tostring(assetId) ..
                "]"

            B.TextColor3 = Color3.fromRGB(220,215,230)
            B.TextSize = 10
            B.TextXAlignment = Enum.TextXAlignment.Left
            B.Parent = CatalogResults

            local C = Instance.new("UICorner")
            C.CornerRadius = UDim.new(0,8)
            C.Parent = B

            B.MouseButton1Click:Connect(function()

                CFG.AnimationId = tostring(assetId)

                AnimationIdBox.Text =
                    tostring(assetId)

                CatalogStatus.Text =
                    "Selected: " .. tostring(name)

            end)
        end
    end)
end

Button(Animation,"SEARCH CATALOG",function()

    local query = SearchBox.Text

    if query == "" then
        CatalogStatus.Text = "Enter a search term."
        return
    end

    SearchCatalog(query)
end)

--==============================================================
-- SETTINGS
--==============================================================

Section(Settings,"MONOTON VISUALS")

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1,-8,0,40)
VersionLabel.BackgroundColor3 = BG2
VersionLabel.BorderSizePixel = 0
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.Text =
    "MONOTON VISUALS V1.3\nMobile / PC Edition"
VersionLabel.TextColor3 = Color3.new(1,1,1)
VersionLabel.TextSize = 12
VersionLabel.Parent = Settings

local VC = Instance.new("UICorner")
VC.CornerRadius = UDim.new(0,9)
VC.Parent = VersionLabel

--==============================================================
-- CHINA HAT
--==============================================================

local ChinaHatModel
local ChinaHatParts = {}

local function RemoveChinaHat()

    if ChinaHatModel then
        ChinaHatModel:Destroy()
        ChinaHatModel = nil
    end

    table.clear(ChinaHatParts)
end

local function MakeChinaPart(
    parent,
    name,
    size,
    color,
    shape
)

    local P = Instance.new("Part")

    P.Name = name
    P.Size = size
    P.Color = color
    P.Material = Enum.Material.SmoothPlastic
    P.Shape = shape or Enum.PartType.Block

    P.CanCollide = false
    P.CanTouch = false
    P.CanQuery = false
    P.CastShadow = false

    P.TopSurface = Enum.SurfaceType.Smooth
    P.BottomSurface = Enum.SurfaceType.Smooth

    P.Parent = parent

    table.insert(ChinaHatParts,P)

    return P
end

local function WeldPart(part, head, offset)

    local W = Instance.new("Weld")

    W.Part0 = head
    W.Part1 = part
    W.C0 = offset

    W.Parent = part

    return W
end

local function CreateChinaHat()

    RemoveChinaHat()
    RefreshCharacter()

    if not CFG.ChinaHat or not Head then
        return
    end

    ChinaHatModel = Instance.new("Model")
    ChinaHatModel.Name = "MonotonChinaHat"
    ChinaHatModel.Parent = Character

    local purple = Color3.fromRGB(205,105,235)
    local highlight = Color3.fromRGB(255,215,120)

    -- Wide brim
    local Brim = MakeChinaPart(
        ChinaHatModel,
        "Brim",
        Vector3.new(2.35,0.12,2.35),
        purple,
        Enum.PartType.Cylinder
    )

    WeldPart(
        Brim,
        Head,
        CFrame.new(0,0.47,0)
    )

    -- Smooth visual cone
    local segments = 24

    for i = 1,segments do

        local a = (i-1)/(segments-1)

        -- Smooth nonlinear taper
        local diameter =
            2.04 * (1-a)^0.82
            + 0.08

        local y =
            0.53
            + a * 1.42

        local P = MakeChinaPart(
            ChinaHatModel,
            "Cone_" .. i,
            Vector3.new(
                diameter,
                0.075,
                diameter
            ),
            purple,
            Enum.PartType.Cylinder
        )

        WeldPart(
            P,
            Head,
            CFrame.new(0,y,0)
        )
    end

    -- Gold band
    local Band = MakeChinaPart(
        ChinaHatModel,
        "Band",
        Vector3.new(0.95,0.075,0.95),
        highlight,
        Enum.PartType.Cylinder
    )

    Band.Material = Enum.Material.Metal

    WeldPart(
        Band,
        Head,
        CFrame.new(0,1.02,0)
    )

    -- Tip
    local Tip = MakeChinaPart(
        ChinaHatModel,
        "Tip",
        Vector3.new(0.15,0.09,0.15),
        highlight,
        Enum.PartType.Cylinder
    )

    Tip.Material = Enum.Material.Metal

    WeldPart(
        Tip,
        Head,
        CFrame.new(0,1.98,0)
    )

    local H = Instance.new("Highlight")

    H.Name = "ChinaHatHighlight"
    H.Adornee = ChinaHatModel
    H.FillColor = purple
    H.FillTransparency = 0.82
    H.OutlineColor = highlight
    H.OutlineTransparency = 0.3
    H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    H.Parent = ChinaHatModel
end

--==============================================================
-- SAKURA AURA
--==============================================================

local AuraFolder
local AuraParts = {}

local function ClearAura()

    if AuraFolder then
        AuraFolder:Destroy()
        AuraFolder = nil
    end

    table.clear(AuraParts)
end

local function CreateAura()

    ClearAura()

    if not CFG.SakuraAura then
        return
    end

    RefreshCharacter()

    if not Root then
        return
    end

    AuraFolder = Instance.new("Folder")
    AuraFolder.Name = "MonotonSakuraAura"
    AuraFolder.Parent = workspace

    for i = 1,CFG.SakuraAuraCount do

        local Petal = Instance.new("Part")

        Petal.Name = "SakuraPetal"
        Petal.Size = Vector3.new(0.18,0.04,0.38)

        Petal.Color =
            i % 2 == 0
            and Color3.fromRGB(255,160,210)
            or Color3.fromRGB(255,205,230)

        Petal.Material = Enum.Material.Neon

        Petal.Anchored = true
        Petal.CanCollide = false
        Petal.CanTouch = false
        Petal.CanQuery = false

        Petal.Parent = AuraFolder

        table.insert(AuraParts,Petal)
    end
end

--==============================================================
-- WORLD PARTICLES
--==============================================================

local WorldFolder = Instance.new("Folder")
WorldFolder.Name = "MonotonWorld"
WorldFolder.Parent = workspace

local WorldParticles = {}

local function ClearWorldParticles()

    for _,p in ipairs(WorldParticles) do
        if p and p.Parent then
            p:Destroy()
        end
    end

    table.clear(WorldParticles)
end

local function SpawnWorldParticles()

    ClearWorldParticles()

    if not Root then
        return
    end

    local enabled =
        CFG.Snow
        or CFG.SakuraLeaves
        or CFG.Stars

    if not enabled then
        return
    end

    for i = 1,45 do

        local P = Instance.new("Part")

        P.Anchored = true
        P.CanCollide = false
        P.CanTouch = false
        P.CanQuery = false
        P.CastShadow = false

        local typeId = i % 3

        if CFG.SakuraLeaves and typeId == 0 then

            P.Size = Vector3.new(0.16,0.04,0.28)
            P.Color = Color3.fromRGB(255,170,215)
            P.Material = Enum.Material.Neon

        elseif CFG.Snow and typeId == 1 then

            P.Shape = Enum.PartType.Ball
            P.Size = Vector3.new(0.14,0.14,0.14)
            P.Color = Color3.new(1,1,1)
            P.Material = Enum.Material.SmoothPlastic

        elseif CFG.Stars then

            P.Shape = Enum.PartType.Ball
            P.Size = Vector3.new(0.07,0.07,0.07)
            P.Color = Color3.fromRGB(255,235,150)
            P.Material = Enum.Material.Neon

        else
            P:Destroy()
            continue
        end

        P.Position =
            Root.Position
            + Vector3.new(
                math.random(-35,35),
                math.random(6,18),
                math.random(-35,35)
            )

        P.Parent = WorldFolder

        table.insert(WorldParticles,{
            Part = P,
            Speed =
                CFG.Snow and 7
                or CFG.SakuraLeaves and 4
                or 1.2
        })
    end
end

--==============================================================
-- GREEN SKY
--==============================================================

local GreenAtmosphere
local GreenColorCorrection
local OriginalLighting = {}

OriginalLighting.Ambient = Lighting.Ambient
OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
OriginalLighting.ColorShiftTop = Lighting.ColorShift_Top
OriginalLighting.ColorShiftBottom = Lighting.ColorShift_Bottom

local function UpdateGreenSky()

    if CFG.GreenSky then

        if not GreenAtmosphere then

            GreenAtmosphere = Instance.new("Atmosphere")
            GreenAtmosphere.Name = "MonotonGreenAtmosphere"
            GreenAtmosphere.Color = Color3.fromRGB(80,255,150)
            GreenAtmosphere.Decay = Color3.fromRGB(5,90,45)
            GreenAtmosphere.Density = 0.32
            GreenAtmosphere.Haze = 1.6
            GreenAtmosphere.Glare = 0.35
            GreenAtmosphere.Parent = Lighting
        end

        if not GreenColorCorrection then

            GreenColorCorrection =
                Instance.new("ColorCorrectionEffect")

            GreenColorCorrection.Name =
                "MonotonGreenColor"

            GreenColorCorrection.TintColor =
                Color3.fromRGB(120,255,170)

            GreenColorCorrection.Saturation = 0.2
            GreenColorCorrection.Contrast = 0.12
            GreenColorCorrection.Brightness = 0.05

            GreenColorCorrection.Parent = Lighting
        end

        Lighting.Ambient =
            Color3.fromRGB(35,110,65)

        Lighting.OutdoorAmbient =
            Color3.fromRGB(20,85,45)

        Lighting.ColorShift_Top =
            Color3.fromRGB(70,255,125)

        Lighting.ColorShift_Bottom =
            Color3.fromRGB(10,80,35)

    else

        if GreenAtmosphere then
            GreenAtmosphere:Destroy()
            GreenAtmosphere = nil
        end

        if GreenColorCorrection then
            GreenColorCorrection:Destroy()
            GreenColorCorrection = nil
        end

        Lighting.Ambient =
            OriginalLighting.Ambient

        Lighting.OutdoorAmbient =
            OriginalLighting.OutdoorAmbient

        Lighting.ColorShift_Top =
            OriginalLighting.ColorShiftTop

        Lighting.ColorShift_Bottom =
            OriginalLighting.ColorShiftBottom
    end
end

--==============================================================
-- NOCLIP
--==============================================================

local NoclipCache = {}

local function UpdateNoclip()

    RefreshCharacter()

    if not Character then
        return
    end

    if CFG.Noclip then

        for _,obj in ipairs(Character:GetDescendants()) do

            if obj:IsA("BasePart") then

                if NoclipCache[obj] == nil then
                    NoclipCache[obj] = obj.CanCollide
                end

                obj.CanCollide = false
            end
        end

    else

        for part,state in pairs(NoclipCache) do

            if part and part.Parent then
                part.CanCollide = state
            end
        end

        table.clear(NoclipCache)
    end
end

--==============================================================
-- MOBILE + PC FLY
--==============================================================

local FlyY = 0

local function GetMobileDirection()

    if not Humanoid then
        return Vector3.zero
    end

    local move = Humanoid.MoveDirection

    if move.Magnitude > 0 then
        return move
    end

    return Vector3.zero
end

local function GetPCDirection()

    local forward = Camera.CFrame.LookVector
    local right = Camera.CFrame.RightVector

    forward =
        Vector3.new(
            forward.X,
            0,
            forward.Z
        )

    right =
        Vector3.new(
            right.X,
            0,
            right.Z
        )

    if forward.Magnitude > 0 then
        forward = forward.Unit
    end

    if right.Magnitude > 0 then
        right = right.Unit
    end

    local move = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then
        move += forward
    end

    if UIS:IsKeyDown(Enum.KeyCode.S) then
        move -= forward
    end

    if UIS:IsKeyDown(Enum.KeyCode.D) then
        move += right
    end

    if UIS:IsKeyDown(Enum.KeyCode.A) then
        move -= right
    end

    if UIS:IsKeyDown(Enum.KeyCode.Space) then
        move += Vector3.yAxis
    end

    if UIS:IsKeyDown(Enum.KeyCode.LeftControl)
    or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
        move -= Vector3.yAxis
    end

    return move
end

local function UpdateFly()

    RefreshCharacter()

    if not CFG.Fly or not Root or not Humanoid then
        if Humanoid then
            Humanoid.PlatformStand = false
        end

        return
    end

    Humanoid.PlatformStand = true

    local direction

    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
        direction = GetMobileDirection()

        -- Mobile vertical control:
        -- jump button = up
        -- LeftShift/keyboard remains available on hybrid devices
        if Humanoid.Jump then
            direction += Vector3.yAxis
        end
    else
        direction = GetPCDirection()
    end

    if direction.Magnitude > 1 then
        direction = direction.Unit
    end

    Root.AssemblyLinearVelocity =
        direction * CFG.FlySpeed
end

--==============================================================
-- SPEED / JUMP
--==============================================================

local function UpdateMovement()

    RefreshCharacter()

    if not Humanoid then
        return
    end

    if CFG.SpeedHack then
        Humanoid.WalkSpeed = CFG.Speed
    else
        Humanoid.WalkSpeed = 16
    end

    if CFG.JumpBoost then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = CFG.JumpPower
    else
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = 50
    end
end

--==============================================================
-- AIR JUMP
--==============================================================

local LastAirJump = 0

UIS.JumpRequest:Connect(function()

    if not CFG.AirJump then
        return
    end

    RefreshCharacter()

    if not Humanoid or not Root then
        return
    end

    local state = Humanoid:GetState()

    if state == Enum.HumanoidStateType.Freefall
    or state == Enum.HumanoidStateType.Jumping then

        if os.clock() - LastAirJump > 0.12 then

            LastAirJump = os.clock()

            Root.AssemblyLinearVelocity =
                Vector3.new(
                    Root.AssemblyLinearVelocity.X,
                    CFG.JumpPower,
                    Root.AssemblyLinearVelocity.Z
                )
        end
    end
end)

--==============================================================
-- CHAMS
--==============================================================

local Chams = {}

local function UpdateChams()

    for player,highlight in pairs(Chams) do

        if not player.Parent then
            highlight:Destroy()
            Chams[player] = nil
            continue
        end

        local character = player.Character

        if CFG.Chams and character then

            if not highlight.Parent then
                highlight.Parent = character
            end

            highlight.Adornee = character
            highlight.Enabled = true

        else
            highlight.Enabled = false
        end
    end

    for _,player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer and not Chams[player] then

            local H = Instance.new("Highlight")

            H.Name = "MonotonChams"
            H.FillColor = CFG.Accent
            H.OutlineColor = CFG.Accent2
            H.FillTransparency = 0.55
            H.OutlineTransparency = 0
            H.DepthMode =
                Enum.HighlightDepthMode.AlwaysOnTop

            H.Parent = player.Character or workspace

            Chams[player] = H
        end
    end
end

Players.PlayerRemoving:Connect(function(player)

    if Chams[player] then
        Chams[player]:Destroy()
        Chams[player] = nil
    end
end)

--==============================================================
-- DRAWING ESP
--==============================================================

local HasDrawing =
    typeof(Drawing) == "table"
    and type(Drawing.new) == "function"

local ESP = {}

local function NewLine()
    local l = Drawing.new("Line")
    l.Visible = false
    l.Thickness = 1.5
    l.Color = CFG.Accent
    return l
end

local function NewSquare()
    local s = Drawing.new("Square")
    s.Visible = false
    s.Thickness = 1.5
    s.Color = CFG.Accent
    return s
end

local function NewText()
    local t = Drawing.new("Text")
    t.Visible = false
    t.Center = true
    t.Outline = true
    t.Font = 2
    t.Size = 13
    t.Color = Color3.new(1,1,1)
    return t
end

local function CreateESP(player)

    if not HasDrawing then
        return
    end

    local E = {
        Box = {},
        Outline = {},
        Corner = {},
        Skeleton = {},
        Fill = NewSquare(),
        HealthBG = NewLine(),
        Health = NewLine(),
        Name = NewText(),
        Distance = NewText(),
    }

    for i = 1,4 do
        E.Box[i] = NewLine()
        E.Outline[i] = NewLine()
    end

    for i = 1,8 do
        E.Corner[i] = NewLine()
    end

    for i = 1,14 do
        E.Skeleton[i] = NewLine()
    end

    ESP[player] = E
end

local function HideESP(E)

    if not E then
        return
    end

    for _,obj in pairs(E) do

        if typeof(obj) == "table" then
            for _,line in pairs(obj) do
                line.Visible = false
            end
        else
            obj.Visible = false
        end
    end
end

local function GetBounds(character)

    local cf,size = character:GetBoundingBox()

    local corners = {}

    for x = -1,1,2 do
        for y = -1,1,2 do
            for z = -1,1,2 do

                table.insert(
                    corners,
                    cf:PointToWorldSpace(
                        Vector3.new(
                            size.X*x/2,
                            size.Y*y/2,
                            size.Z*z/2
                        )
                    )
                )
            end
        end
    end

    local minX = math.huge
    local minY = math.huge
    local maxX = -math.huge
    local maxY = -math.huge

    local visible = false

    for _,point in ipairs(corners) do

        local p,onScreen =
            Camera:WorldToViewportPoint(point)

        if p.Z > 0 then

            visible = true

            minX = math.min(minX,p.X)
            minY = math.min(minY,p.Y)
            maxX = math.max(maxX,p.X)
            maxY = math.max(maxY,p.Y)
        end
    end

    if not visible then
        return
    end

    return minX,minY,maxX,maxY
end

local SkeletonPairs = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},

    {"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"LeftLowerArm","LeftHand"},

    {"UpperTorso","RightUpperArm"},
    {"RightUpperArm","RightLowerArm"},
    {"RightLowerArm","RightHand"},

    {"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},

    {"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},
    {"RightLowerLeg","RightFoot"},
}

local function UpdateSkeleton(E,character)

    for i,pair in ipairs(SkeletonPairs) do

        local a = character:FindFirstChild(pair[1])
        local b = character:FindFirstChild(pair[2])

        if a and b then

            local pa,oka =
                Camera:WorldToViewportPoint(a.Position)

            local pb,okb =
                Camera:WorldToViewportPoint(b.Position)

            if oka and okb and pa.Z > 0 and pb.Z > 0 then

                E.Skeleton[i].From =
                    Vector2.new(pa.X,pa.Y)

                E.Skeleton[i].To =
                    Vector2.new(pb.X,pb.Y)

                E.Skeleton[i].Visible =
                    CFG.ESPSkeleton
            else
                E.Skeleton[i].Visible = false
            end
        else
            E.Skeleton[i].Visible = false
        end
    end

    for i = #SkeletonPairs+1,#E.Skeleton do
        E.Skeleton[i].Visible = false
    end
end

local function UpdateESP()

    if not HasDrawing then
        return
    end

    for _,player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer then

            if not ESP[player] then
                CreateESP(player)
            end

            local E = ESP[player]

            local character = player.Character
            local humanoid =
                character and character:FindFirstChildOfClass("Humanoid")

            local root =
                character and character:FindFirstChild("HumanoidRootPart")

            local skip = false

            if not CFG.ESPEnabled then
                skip = true
            end

            if not character or not humanoid or not root then
                skip = true
            end

            if CFG.ESPTeamCheck
            and player.Team
            and LocalPlayer.Team
            and player.Team == LocalPlayer.Team then

                skip = true
            end

            if root and Root then

                local distance =
                    (root.Position - Root.Position).Magnitude

                if distance > CFG.ESPMaxDistance then
                    skip = true
                end
            end

            if skip then

                HideESP(E)

            else

                local x1,y1,x2,y2 =
                    GetBounds(character)

                if not x1 then

                    HideESP(E)

                else

                    local width = x2-x1
                    local height = y2-y1

                    -- Box
                    local points = {
                        Vector2.new(x1,y1),
                        Vector2.new(x2,y1),
                        Vector2.new(x2,y2),
                        Vector2.new(x1,y2),
                    }

                    for i = 1,4 do

                        local nextI =
                            i == 4 and 1 or i+1

                        E.Box[i].From = points[i]
                        E.Box[i].To = points[nextI]
                        E.Box[i].Visible = CFG.ESPBox

                        E.Box[i].Color = CFG.Accent
                    end

                    -- Fill
                    E.Fill.Position =
                        Vector2.new(x1,y1)

                    E.Fill.Size =
                        Vector2.new(width,height)

                    E.Fill.Color = CFG.Accent
                    E.Fill.Transparency = 0.12
                    E.Fill.Filled = true
                    E.Fill.Visible = CFG.ESPFill

                    -- Outline
                    for i = 1,4 do

                        local nextI =
                            i == 4 and 1 or i+1

                        E.Outline[i].From = points[i]
                        E.Outline[i].To = points[nextI]

                        E.Outline[i].Thickness = 4
                        E.Outline[i].Color =
                            Color3.new(0,0,0)

                        E.Outline[i].Visible =
                            CFG.ESPOutline

                        E.Box[i].Thickness = 1.5
                    end

                    -- Corner
                    local corner = math.min(
                        width*0.25,
                        height*0.2,
                        25
                    )

                    local cornerLines = {
                        {Vector2.new(x1,y1),Vector2.new(x1+corner,y1)},
                        {Vector2.new(x1,y1),Vector2.new(x1,y1+corner)},

                        {Vector2.new(x2,y1),Vector2.new(x2-corner,y1)},
                        {Vector2.new(x2,y1),Vector2.new(x2,y1+corner)},

                        {Vector2.new(x1,y2),Vector2.new(x1+corner,y2)},
                        {Vector2.new(x1,y2),Vector2.new(x1,y2-corner)},

                        {Vector2.new(x2,y2),Vector2.new(x2-corner,y2)},
                        {Vector2.new(x2,y2),Vector2.new(x2,y2-corner)},
                    }

                    for i,data in ipairs(cornerLines) do

                        E.Corner[i].From = data[1]
                        E.Corner[i].To = data[2]
                        E.Corner[i].Visible =
                            CFG.ESPCorner

                        E.Corner[i].Color =
                            CFG.Accent2
                    end

                    -- Health
                    local health =
                        math.clamp(
                            humanoid.Health /
                            math.max(humanoid.MaxHealth,1),
                            0,
                            1
                        )

                    E.HealthBG.From =
                        Vector2.new(x1-6,y2)

                    E.HealthBG.To =
                        Vector2.new(x1-6,y1)

                    E.HealthBG.Color =
                        Color3.new(0,0,0)

                    E.HealthBG.Thickness = 4

                    E.HealthBG.Visible =
                        CFG.ESPHealth

                    E.Health.From =
                        Vector2.new(
                            x1-6,
                            y2
                        )

                    E.Health.To =
                        Vector2.new(
                            x1-6,
                            y2 - height*health
                        )

                    E.Health.Color =
                        Color3.fromRGB(
                            255*(1-health),
                            255*health,
                            80
                        )

                    E.Health.Thickness = 2

                    E.Health.Visible =
                        CFG.ESPHealth

                    -- Name
                    E.Name.Text =
                        player.DisplayName

                    E.Name.Position =
                        Vector2.new(
                            (x1+x2)/2,
                            y1-17
                        )

                    E.Name.Color =
                        CFG.Accent2

                    E.Name.Visible =
                        CFG.ESPNames

                    -- Distance
                    if Root then

                        local distance =
                            math.floor(
                                (root.Position-Root.Position).Magnitude
                            )

                        E.Distance.Text =
                            "[" .. tostring(distance) .. "m]"

                        E.Distance.Position =
                            Vector2.new(
                                (x1+x2)/2,
                                y2+3
                            )

                        E.Distance.Visible =
                            CFG.ESPDistance
                    end

                    UpdateSkeleton(E,character)
                end
            end
        end
    end
end

--==============================================================
-- ESP CLEANUP
--==============================================================

Players.PlayerRemoving:Connect(function(player)

    local E = ESP[player]

    if E then

        for _,obj in pairs(E) do

            if typeof(obj) == "table" then

                for _,line in pairs(obj) do
                    pcall(function()
                        line:Remove()
                    end)
                end

            else
                pcall(function()
                    obj:Remove()
                end)
            end
        end

        ESP[player] = nil
    end
end)

--==============================================================
-- RENDER LOOP
--==============================================================

local AuraTime = 0
local ParticleTimer = 0

RunService.RenderStepped:Connect(function(dt)

    RefreshCharacter()

    -- Movement
    UpdateMovement()

    -- Fly
    UpdateFly()

    -- Noclip
    UpdateNoclip()

    -- Chams
    UpdateChams()

    -- ESP
    UpdateESP()

    -- Green Sky
    UpdateGreenSky()

    -- Sakura Aura
    if CFG.SakuraAura then

        if not AuraFolder then
            CreateAura()
        end

        AuraTime += dt

        if Root then

            for i,petal in ipairs(AuraParts) do

                local angle =
                    AuraTime * 1.5
                    + (i/#AuraParts)*math.pi*2

                local radius =
                    CFG.SakuraAuraRadius

                local y =
                    0.7
                    + math.sin(
                        AuraTime*2+i
                    )*0.3

                petal.CFrame =
                    Root.CFrame
                    * CFrame.new(
                        math.cos(angle)*radius,
                        y,
                        math.sin(angle)*radius
                    )
                    * CFrame.Angles(
                        0,
                        -angle,
                        math.sin(angle)*0.5
                    )
            end
        end

    elseif AuraFolder then
        ClearAura()
    end

    -- World particles
    ParticleTimer += dt

    if ParticleTimer > 2 then

        ParticleTimer = 0

        local needParticles =
            CFG.Snow
            or CFG.SakuraLeaves
            or CFG.Stars

        if needParticles then
            if #WorldParticles == 0 then
                SpawnWorldParticles()
            end
        else
            ClearWorldParticles()
        end
    end

    if Root then

        for _,data in ipairs(WorldParticles) do

            local p = data.Part

            if p and p.Parent then

                p.Position -=
                    Vector3.new(
                        0,
                        data.Speed*dt,
                        0
                    )

                -- Much lower than the old version.
                if p.Position.Y <
                    Root.Position.Y - 4 then

                    p.Position =
                        Root.Position
                        + Vector3.new(
                            math.random(-35,35),
                            math.random(10,18),
                            math.random(-35,35)
                        )
                end
            end
        end
    end
end)

--==============================================================
-- CHARACTER EVENTS
--==============================================================

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(0.7)

    RefreshCharacter()

    if CFG.ChinaHat then
        CreateChinaHat()
    end

    if CFG.SakuraAura then
        CreateAura()
    end

    if CFG.Snow
    or CFG.SakuraLeaves
    or CFG.Stars then

        SpawnWorldParticles()
    end
end)

--==============================================================
-- CHINA HAT REFRESH
--==============================================================

task.spawn(function()

    local oldState = false

    while Gui.Parent do

        task.wait(0.25)

        if CFG.ChinaHat ~= oldState then

            oldState = CFG.ChinaHat

            if CFG.ChinaHat then
                CreateChinaHat()
            else
                RemoveChinaHat()
            end
        end
    end
end)

--==============================================================
-- ANIMATION RESPAWN
--==============================================================

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(1)

    if CFG.AnimationHack
    and CFG.AnimationId ~= "" then

        PlayAnimation(CFG.AnimationId)
    end
end)

--==============================================================
-- MOBILE FLY UI
--==============================================================

local MobileFly = Instance.new("Frame")

MobileFly.Name = "MobileFly"
MobileFly.Size = UDim2.fromOffset(130,110)
MobileFly.Position = UDim2.new(1,-150,1,-140)
MobileFly.BackgroundColor3 = BG2
MobileFly.BackgroundTransparency = 0.12
MobileFly.BorderSizePixel = 0
MobileFly.Visible =
    UIS.TouchEnabled

MobileFly.Parent = Gui

local MCorner = Instance.new("UICorner")
MCorner.CornerRadius = UDim.new(0,14)
MCorner.Parent = MobileFly

local MStroke = Instance.new("UIStroke")
MStroke.Color = CFG.Accent
MStroke.Transparency = 0.4
MStroke.Parent = MobileFly

local FlyUp = Instance.new("TextButton")
FlyUp.Size = UDim2.fromOffset(52,42)
FlyUp.Position = UDim2.fromOffset(8,8)
FlyUp.BackgroundColor3 = BG3
FlyUp.Text = "▲"
FlyUp.Font = Enum.Font.GothamBold
FlyUp.TextSize = 18
FlyUp.TextColor3 = Color3.new(1,1,1)
FlyUp.BorderSizePixel = 0
FlyUp.Parent = MobileFly

local FUC = Instance.new("UICorner")
FUC.CornerRadius = UDim.new(0,10)
FUC.Parent = FlyUp

local FlyDown = Instance.new("TextButton")
FlyDown.Size = UDim2.fromOffset(52,42)
FlyDown.Position = UDim2.fromOffset(70,8)
FlyDown.BackgroundColor3 = BG3
FlyDown.Text = "▼"
FlyDown.Font = Enum.Font.GothamBold
FlyDown.TextSize = 18
FlyDown.TextColor3 = Color3.new(1,1,1)
FlyDown.BorderSizePixel = 0
FlyDown.Parent = MobileFly

local FDC = Instance.new("UICorner")
FDC.CornerRadius = UDim.new(0,10)
FDC.Parent = FlyDown

local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(1,-16,0,38)
FlyToggle.Position = UDim2.fromOffset(8,60)
FlyToggle.BackgroundColor3 = BG3
FlyToggle.Text = "FLY: OFF"
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.TextSize = 10
FlyToggle.TextColor3 = Color3.new(1,1,1)
FlyToggle.BorderSizePixel = 0
FlyToggle.Parent = MobileFly

local FTC = Instance.new("UICorner")
FTC.CornerRadius = UDim.new(0,9)
FTC.Parent = FlyToggle

FlyUp.MouseButton1Down:Connect(function()
    FlyY = 1
end)

FlyUp.MouseButton1Up:Connect(function()
    FlyY = 0
end)

FlyDown.MouseButton1Down:Connect(function()
    FlyY = -1
end)

FlyDown.MouseButton1Up:Connect(function()
    FlyY = 0
end)

FlyToggle.MouseButton1Click:Connect(function()

    CFG.Fly = not CFG.Fly

    FlyToggle.Text =
        CFG.Fly
        and "FLY: ON"
        or "FLY: OFF"
end)

--==============================================================
-- MOBILE VERTICAL FLY
--==============================================================

RunService.RenderStepped:Connect(function()

    if not CFG.Fly then
        return
    end

    if not UIS.TouchEnabled then
        return
    end

    if not Root then
        return
    end

    local velocity = Root.AssemblyLinearVelocity

    Root.AssemblyLinearVelocity =
        Vector3.new(
            velocity.X,
            FlyY * CFG.FlySpeed,
            velocity.Z
        )
end)

--==============================================================
-- MENU DRAG
--==============================================================

local dragging = false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        local delta =
            input.Position - dragStart

        Main.Position =
            UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
    end
end)

UIS.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = false
    end
end)

--==============================================================
-- OPEN / CLOSE
--==============================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.fromOffset(50,50)
OpenButton.Position = UDim2.fromOffset(20,20)
OpenButton.BackgroundColor3 = BG2
OpenButton.Text = "M"
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 18
OpenButton.TextColor3 = CFG.Accent2
OpenButton.BorderSizePixel = 0
OpenButton.Parent = Gui

local OCorner = Instance.new("UICorner")
OCorner.CornerRadius = UDim.new(0,14)
OCorner.Parent = OpenButton

OpenButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--==============================================================
-- DEFAULT PAGE
--==============================================================

Pages.Home.Visible = true
CurrentPage = Pages.Home

for _,b in ipairs(Sidebar:GetChildren()) do
    if b:IsA("TextButton") then
        b.BackgroundTransparency = 1
        b.TextColor3 = Color3.fromRGB(180,175,195)
    end
end

-- First tab
local FirstTab

for _,b in ipairs(Sidebar:GetChildren()) do
    if b:IsA("TextButton") then
        FirstTab = b
        break
    end
end

if FirstTab then
    FirstTab.BackgroundTransparency = 0
    FirstTab.BackgroundColor3 = BG3
    FirstTab.TextColor3 = Color3.new(1,1,1)
end

--==============================================================
-- INITIAL
--==============================================================

task.spawn(function()

    task.wait(1)

    RefreshCharacter()

    if CFG.ChinaHat then
        CreateChinaHat()
    end

    if CFG.SakuraAura then
        CreateAura()
    end

    if CFG.Snow
    or CFG.SakuraLeaves
    or CFG.Stars then

        SpawnWorldParticles()
    end
end)

print(
    "[MonotonVisuals] V1.3 loaded | PC + Mobile"
)
