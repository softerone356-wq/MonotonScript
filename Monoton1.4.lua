--[[
    [nasok os-by @go8ai]

    MONOTON VISUALS V1.3

    FEATURES
    • Visuals
    • Rage
    • Bunnyhop 1-100
    • Speed
    • Jump Boost
    • Air Jump
    • Noclip
    • Fly — WASD / Mobile joystick
    • China Hat
    • Sakura Aura
    • Sakura / Snow / Stars
    • Fireflies / Hearts
    • Chams
    • ESP Box / Fill / Outline / Health / Corner / Skeleton / Names
    • Green Sky / Aurora
    • Bloom / SunRays / DOF / ColorCorrection
    • Fullbright
    • FOV
    • Sky presets
    • Animation player
    • Config save/load
]]

--========================================================--
-- SERVICES
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--========================================================--
-- CONFIG
--========================================================--

local CFG = {
    Version = "1.3",

    Smooth = true,
    BlurAmount = 8,

    Chams = false,
    ChamsColor = Color3.fromRGB(255, 80, 140),

    ESP = false,
    ESPEnabled = false,
    ESPBox = true,
    ESPFill = false,
    ESPOutline = false,
    ESPHealth = false,
    ESPCorner = false,
    ESPSkeleton = false,
    ESPNames = false,
    ESPTeamCheck = false,
    ESPMaxDistance = 2000,

    SakuraLeaves = false,
    Snow = false,
    Stars = false,
    SakuraAura = false,
    Fireflies = false,
    Hearts = false,

    Night = false,
    NightDarkness = 2,

    GreenSky = false,

    Bloom = false,
    BloomIntensity = 0.8,

    SunRays = false,
    SunRaysIntensity = 0.15,

    DepthOfField = false,
    DOFDistance = 30,

    ColorCorrection = false,

    Fullbright = false,

    FOVEnabled = false,
    FOV = 70,

    JumpBoost = false,
    JumpPower = 60,

    AirJump = false,

    -- Bunnyhop
    Bunnyhop = false,
    BunnyhopPower = 50,

    SpeedHack = false,
    Speed = 35,

    Noclip = false,

    Fly = false,
    FlySpeed = 60,

    Sky = "Galaxy",

    Font = "Gotham",
    AccentName = "Pink",
    AccentColor = Color3.fromRGB(255, 90, 160),

    ChinaHat = false,
    ChinaHatColorName = "Blue",
    ChinaHatRadius = 2.65,
    ChinaHatHeight = 1.65,

    AnimationHack = false,
    AnimationId = "",
    AnimationSpeed = 1,
    AnimationLoop = true,
}

--========================================================--
-- RUNTIME VARIABLES
--========================================================--

local Character
local Humanoid
local Root
local Head

local ChamsObjects = {}
local ESPObjects = {}
local NoclipCache = {}
local AuraObjects = {}
local ParticleObjects = {}

local AnimationTrack = nil

local LastJump = 0
local LastBunnyhop = 0

--========================================================--
-- CHARACTER
--========================================================--

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

--========================================================--
-- ORIGINAL LIGHTING
--========================================================--

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ExposureCompensation = Lighting.ExposureCompensation,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
}

--========================================================--
-- FOLDERS
--========================================================--

local OldFolder = workspace:FindFirstChild("MonotonVisuals_V13")

if OldFolder then
    pcall(function()
        OldFolder:Destroy()
    end)
end

local VisualFolder = Instance.new("Folder")
VisualFolder.Name = "MonotonVisuals_V13"
VisualFolder.Parent = workspace

local ParticleFolder = Instance.new("Folder")
ParticleFolder.Name = "Particles"
ParticleFolder.Parent = VisualFolder

local AuraFolder = Instance.new("Folder")
AuraFolder.Name = "SakuraAura"
AuraFolder.Parent = VisualFolder

local HatFolder = Instance.new("Folder")
HatFolder.Name = "ChinaHats"
HatFolder.Parent = VisualFolder

local AuroraFolder = Instance.new("Folder")
AuroraFolder.Name = "GreenAurora"
AuroraFolder.Parent = VisualFolder

--========================================================--
-- UTILITY
--========================================================--

local function SafeDestroy(Object)
    if Object then
        pcall(function()
            Object:Destroy()
        end)
    end
end

local function GetUIParent()
    if typeof(gethui) == "function" then
        local Success, Result = pcall(gethui)

        if Success and Result then
            return Result
        end
    end

    local Success, CoreGui = pcall(function()
        return game:GetService("CoreGui")
    end)

    if Success and CoreGui then
        return CoreGui
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local GUIParent = GetUIParent()

--========================================================--
-- GUI
--========================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonotonVisualsV13"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GUIParent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 650, 0, 470)
Main.Position = UDim2.new(0.5, -325, 0.5, -235)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = CFG.AccentColor
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

--========================================================--
-- TOP
--========================================================--

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 48)
Top.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MONOTON VISUALS  V1.3"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 190, 1, 0)
SubTitle.Position = UDim2.new(1, -205, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "[nasok os-by @go8ai]"
SubTitle.TextColor3 = CFG.AccentColor
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Right
SubTitle.Parent = Top

--========================================================--
-- DRAG
--========================================================--

do
    local Dragging = false
    local DragStart
    local StartPosition

    Top.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Main.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(Input)
        if not Dragging then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end)
end

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 125, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(17, 17, 21)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 8)
SidePadding.PaddingLeft = UDim.new(0, 7)
SidePadding.PaddingRight = UDim.new(0, 7)
SidePadding.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 3)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

--========================================================--
-- CONTENT
--========================================================--

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -125, 1, -48)
Content.Position = UDim2.new(0, 125, 0, 48)
Content.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Content.BorderSizePixel = 0
Content.Parent = Main

local Pages = {}

local function CreatePage(Name)
    local Page = Instance.new("ScrollingFrame")

    Page.Name = Name
    Page.Size = UDim2.new(1, -18, 1, -18)
    Page.Position = UDim2.new(0, 9, 0, 9)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = CFG.AccentColor
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = false
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 7)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 12)
    Padding.Parent = Page

    Pages[Name] = Page

    return Page
end

local HomePage = CreatePage("Home")
local VisualPage = CreatePage("Visuals")
local RagePage = CreatePage("Rage")
local ModelsPage = CreatePage("Models")
local SettingsPage = CreatePage("Settings")
local ConfigPage = CreatePage("Configs")
local InfoPage = CreatePage("Info")

--========================================================--
-- GUI HELPERS
--========================================================--

local function Label(Parent, Text, Height)
    local Object = Instance.new("TextLabel")

    Object.Size = UDim2.new(1, -10, 0, Height or 25)
    Object.BackgroundTransparency = 1
    Object.Text = Text
    Object.TextColor3 = Color3.fromRGB(220, 220, 225)
    Object.Font = Enum.Font.GothamMedium
    Object.TextSize = 12
    Object.TextXAlignment = Enum.TextXAlignment.Left
    Object.TextWrapped = true
    Object.Parent = Parent

    return Object
end

local function Section(Parent, Text)
    local Object = Instance.new("TextLabel")

    Object.Size = UDim2.new(1, -10, 0, 28)
    Object.BackgroundTransparency = 1
    Object.Text = Text
    Object.TextColor3 = CFG.AccentColor
    Object.Font = Enum.Font.GothamBold
    Object.TextSize = 13
    Object.TextXAlignment = Enum.TextXAlignment.Left
    Object.Parent = Parent

    return Object
end

local function Toggle(Parent, Text, Default, Callback)
    local Holder = Instance.new("Frame")

    Holder.Size = UDim2.new(1, -4, 0, 38)
    Holder.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Holder.BorderSizePixel = 0
    Holder.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Holder

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -60, 1, 0)
    TextLabel.Position = UDim2.new(0, 12, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = Text
    TextLabel.TextColor3 = Color3.fromRGB(225, 225, 230)
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.TextSize = 12
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Holder

    local ButtonObject = Instance.new("TextButton")
    ButtonObject.Size = UDim2.new(0, 38, 0, 20)
    ButtonObject.Position = UDim2.new(1, -48, 0.5, -10)
    ButtonObject.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    ButtonObject.Text = ""
    ButtonObject.AutoButtonColor = false
    ButtonObject.Parent = Holder

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ButtonObject

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 3, 0.5, -7)
    Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 185)
    Circle.BorderSizePixel = 0
    Circle.Parent = ButtonObject

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local State = Default

    local function Render()
        if State then
            ButtonObject.BackgroundColor3 = CFG.AccentColor
            Circle.BackgroundColor3 = Color3.new(1, 1, 1)

            TweenService:Create(
                Circle,
                TweenInfo.new(0.12),
                {
                    Position = UDim2.new(1, -17, 0.5, -7)
                }
            ):Play()
        else
            ButtonObject.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
            Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 185)

            TweenService:Create(
                Circle,
                TweenInfo.new(0.12),
                {
                    Position = UDim2.new(0, 3, 0.5, -7)
                }
            ):Play()
        end
    end

    ButtonObject.MouseButton1Click:Connect(function()
        State = not State

        Render()

        if Callback then
            Callback(State)
        end
    end)

    Render()

    return Holder
end

local function Slider(Parent, Text, Minimum, Maximum, Default, Callback)
    local Holder = Instance.new("Frame")

    Holder.Size = UDim2.new(1, -4, 0, 55)
    Holder.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Holder.BorderSizePixel = 0
    Holder.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Holder

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(1, -70, 0, 25)
    Name.Position = UDim2.new(0, 12, 0, 3)
    Name.BackgroundTransparency = 1
    Name.Text = Text
    Name.TextColor3 = Color3.fromRGB(225, 225, 230)
    Name.Font = Enum.Font.GothamMedium
    Name.TextSize = 12
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Holder

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 25)
    ValueLabel.Position = UDim2.new(1, -62, 0, 3)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = CFG.AccentColor
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Holder

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -24, 0, 5)
    Bar.Position = UDim2.new(0, 12, 0, 38)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Bar.BorderSizePixel = 0
    Bar.Parent = Holder

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = CFG.AccentColor
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Dragging = false

    local function SetValue(Value)
        Value = math.clamp(Value, Minimum, Maximum)

        local Alpha =
            (Value - Minimum) /
            (Maximum - Minimum)

        Fill.Size =
            UDim2.new(
                Alpha,
                0,
                1,
                0
            )

        ValueLabel.Text =
            tostring(math.floor(Value * 100) / 100)

        if Callback then
            Callback(Value)
        end
    end

    Bar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true

            local Alpha =
                math.clamp(
                    (
                        Input.Position.X -
                        Bar.AbsolutePosition.X
                    ) /
                    Bar.AbsoluteSize.X,
                    0,
                    1
                )

            SetValue(
                Minimum +
                (Maximum - Minimum) *
                Alpha
            )
        end
    end)

    UIS.InputChanged:Connect(function(Input)
        if not Dragging then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Alpha =
            math.clamp(
                (
                    Input.Position.X -
                    Bar.AbsolutePosition.X
                ) /
                Bar.AbsoluteSize.X,
                0,
                1
            )

        SetValue(
            Minimum +
            (Maximum - Minimum) *
            Alpha
        )
    end)

    UIS.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = false
        end
    end)

    SetValue(Default)

    return Holder
end

local function Button(Parent, Text, Callback)
    local Object = Instance.new("TextButton")

    Object.Size = UDim2.new(1, -4, 0, 38)
    Object.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
    Object.BorderSizePixel = 0
    Object.Text = Text
    Object.TextColor3 = Color3.fromRGB(230, 230, 235)
    Object.Font = Enum.Font.GothamMedium
    Object.TextSize = 12
    Object.AutoButtonColor = false
    Object.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Object

    Object.MouseEnter:Connect(function()
        Object.BackgroundColor3 =
            Color3.fromRGB(35, 35, 42)
    end)

    Object.MouseLeave:Connect(function()
        Object.BackgroundColor3 =
            Color3.fromRGB(25, 25, 31)
    end)

    Object.MouseButton1Click:Connect(function()
        if Callback then
            Callback()
        end
    end)

    return Object
end

local function TextBox(Parent, Placeholder, Default)
    local Object = Instance.new("TextBox")

    Object.Size = UDim2.new(1, -4, 0, 38)
    Object.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Object.BorderSizePixel = 0
    Object.PlaceholderText = Placeholder
    Object.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
    Object.Text = Default or ""
    Object.TextColor3 = Color3.fromRGB(235, 235, 240)
    Object.Font = Enum.Font.GothamMedium
    Object.TextSize = 12
    Object.ClearTextOnFocus = false
    Object.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Object

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.Parent = Object

    return Object
end

--========================================================--
-- TABS
--========================================================--

local function CreateTab(Name, Page)
    local Object = Instance.new("TextButton")

    Object.Size = UDim2.new(1, -4, 0, 34)
    Object.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Object.BorderSizePixel = 0
    Object.Text = Name
    Object.TextColor3 = Color3.fromRGB(190, 190, 198)
    Object.Font = Enum.Font.GothamMedium
    Object.TextSize = 11
    Object.AutoButtonColor = false
    Object.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Object

    Object.MouseButton1Click:Connect(function()
        for _, CurrentPage in pairs(Pages) do
            CurrentPage.Visible = false
        end

        Page.Visible = true

        for _, Child in ipairs(Sidebar:GetChildren()) do
            if Child:IsA("TextButton") then
                Child.BackgroundColor3 =
                    Color3.fromRGB(20, 20, 25)

                Child.TextColor3 =
                    Color3.fromRGB(190, 190, 198)
            end
        end

        Object.BackgroundColor3 = CFG.AccentColor
        Object.TextColor3 = Color3.new(1, 1, 1)
    end)

    return Object
end

local HomeTab = CreateTab("Home", HomePage)
local VisualTab = CreateTab("Visuals", VisualPage)
local RageTab = CreateTab("Rage", RagePage)
local ModelsTab = CreateTab("Models", ModelsPage)
local SettingsTab = CreateTab("Settings", SettingsPage)
local ConfigTab = CreateTab("Configs", ConfigPage)
local InfoTab = CreateTab("Info", InfoPage)

HomePage.Visible = true
HomeTab.BackgroundColor3 = CFG.AccentColor
HomeTab.TextColor3 = Color3.new(1, 1, 1)

--========================================================--
-- HOME
--========================================================--

Section(HomePage, "MONOTON VISUALS")

Label(
    HomePage,
    "Visual / movement utility pack • V1.3",
    28
)

Label(
    HomePage,
    "China Hat — объёмный широкий конус по Minecraft reference №3.",
    35
)

Label(
    HomePage,
    "Green Light работает через небо/Atmosphere/Aurora и не красит весь мир.",
    40
)

Section(HomePage, "Quick")

Button(HomePage, "Open Visuals", function()
    for _, Page in pairs(Pages) do
        Page.Visible = false
    end

    VisualPage.Visible = true
end)

Button(HomePage, "Toggle China Hat", function()
    CFG.ChinaHat = not CFG.ChinaHat
end)

Button(HomePage, "Toggle Bunnyhop", function()
    CFG.Bunnyhop = not CFG.Bunnyhop
end)

--========================================================--
-- VISUALS
--========================================================--

Section(VisualPage, "ESP")

Toggle(VisualPage, "ESP", CFG.ESP, function(Value)
    CFG.ESP = Value
    CFG.ESPEnabled = Value
end)

Toggle(VisualPage, "Box", CFG.ESPBox, function(Value)
    CFG.ESPBox = Value
end)

Toggle(VisualPage, "Fill Box", CFG.ESPFill, function(Value)
    CFG.ESPFill = Value
end)

Toggle(VisualPage, "Outline Box", CFG.ESPOutline, function(Value)
    CFG.ESPOutline = Value
end)

Toggle(VisualPage, "Health", CFG.ESPHealth, function(Value)
    CFG.ESPHealth = Value
end)

Toggle(VisualPage, "Corner", CFG.ESPCorner, function(Value)
    CFG.ESPCorner = Value
end)

Toggle(VisualPage, "Skeleton", CFG.ESPSkeleton, function(Value)
    CFG.ESPSkeleton = Value
end)

Toggle(VisualPage, "Names", CFG.ESPNames, function(Value)
    CFG.ESPNames = Value
end)

Toggle(VisualPage, "Team Check", CFG.ESPTeamCheck, function(Value)
    CFG.ESPTeamCheck = Value
end)

Slider(
    VisualPage,
    "ESP Distance",
    100,
    3000,
    CFG.ESPMaxDistance,
    function(Value)
        CFG.ESPMaxDistance = math.floor(Value)
    end
)

Section(VisualPage, "Player")

Toggle(VisualPage, "Chams", CFG.Chams, function(Value)
    CFG.Chams = Value
end)

Section(VisualPage, "Particles")

Toggle(
    VisualPage,
    "Sakura Leaves",
    CFG.SakuraLeaves,
    function(Value)
        CFG.SakuraLeaves = Value
    end
)

Toggle(VisualPage, "Snow", CFG.Snow, function(Value)
    CFG.Snow = Value
end)

Toggle(VisualPage, "Stars", CFG.Stars, function(Value)
    CFG.Stars = Value
end)

Toggle(
    VisualPage,
    "Sakura Aura",
    CFG.SakuraAura,
    function(Value)
        CFG.SakuraAura = Value
    end
)

Toggle(
    VisualPage,
    "Fireflies",
    CFG.Fireflies,
    function(Value)
        CFG.Fireflies = Value
    end
)

Toggle(
    VisualPage,
    "Hearts",
    CFG.Hearts,
    function(Value)
        CFG.Hearts = Value
    end
)

Section(VisualPage, "Sky")

Toggle(
    VisualPage,
    "Green Light Sky",
    CFG.GreenSky,
    function(Value)
        CFG.GreenSky = Value
    end
)

Toggle(
    VisualPage,
    "Night",
    CFG.Night,
    function(Value)
        CFG.Night = Value
    end
)

Slider(
    VisualPage,
    "Night Darkness",
    0,
    5,
    CFG.NightDarkness,
    function(Value)
        CFG.NightDarkness = Value
    end
)

--========================================================--
-- RAGE
--========================================================--

Section(RagePage, "Movement")

Toggle(
    RagePage,
    "Speed Hack",
    CFG.SpeedHack,
    function(Value)
        CFG.SpeedHack = Value
    end
)

Slider(
    RagePage,
    "Speed",
    16,
    150,
    CFG.Speed,
    function(Value)
        CFG.Speed = math.floor(Value)
    end
)

Toggle(
    RagePage,
    "Jump Boost",
    CFG.JumpBoost,
    function(Value)
        CFG.JumpBoost = Value
    end
)

Slider(
    RagePage,
    "Jump Power",
    30,
    150,
    CFG.JumpPower,
    function(Value)
        CFG.JumpPower = math.floor(Value)
    end
)

Toggle(
    RagePage,
    "Air Jump",
    CFG.AirJump,
    function(Value)
        CFG.AirJump = Value
    end
)

--========================================================--
-- BUNNYHOP
--========================================================--

Section(RagePage, "Bunnyhop")

Toggle(
    RagePage,
    "Bunnyhop",
    CFG.Bunnyhop,
    function(Value)
        CFG.Bunnyhop = Value

        if not Value and Root then
            local Velocity =
                Root.AssemblyLinearVelocity

            Root.AssemblyLinearVelocity =
                Vector3.new(
                    Velocity.X,
                    Velocity.Y,
                    Velocity.Z
                )
        end
    end
)

Slider(
    RagePage,
    "Bunnyhop (1-100)",
    1,
    100,
    CFG.BunnyhopPower,
    function(Value)
        CFG.BunnyhopPower =
            math.clamp(
                math.floor(Value),
                1,
                100
            )
    end
)

Label(
    RagePage,
    "Автоматически прыгает во время движения. 1 = минимальная сила, 100 = максимальная.",
    42
)

--========================================================--
-- OTHER MOVEMENT
--========================================================--

Toggle(
    RagePage,
    "Noclip",
    CFG.Noclip,
    function(Value)
        CFG.Noclip = Value

        if not Value and Character then
            for Part, OriginalValue in pairs(NoclipCache) do
                if Part and Part.Parent then
                    Part.CanCollide = OriginalValue
                end
            end

            table.clear(NoclipCache)
        end
    end
)

Toggle(
    RagePage,
    "Fly",
    CFG.Fly,
    function(Value)
        CFG.Fly = Value

        if not Value and Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.AutoRotate = true

            if Root then
                Root.AssemblyLinearVelocity =
                    Vector3.zero
            end
        end
    end
)

Slider(
    RagePage,
    "Fly Speed",
    10,
    250,
    CFG.FlySpeed,
    function(Value)
        CFG.FlySpeed =
            math.floor(Value)
    end
)

Label(
    RagePage,
    "Fly: WASD / стандартный мобильный joystick. Space = вверх, Ctrl = вниз на ПК.",
    42
)

--========================================================--
-- MODELS
--========================================================--

Section(ModelsPage, "China Hat")

Toggle(
    ModelsPage,
    "China Hat",
    CFG.ChinaHat,
    function(Value)
        CFG.ChinaHat = Value
    end
)

Label(
    ModelsPage,
    "Reference №3 — широкий brim + объёмный высокий конус.",
    38
)

Button(ModelsPage, "BLUE", function()
    CFG.ChinaHatColorName = "Blue"
end)

Button(ModelsPage, "RED", function()
    CFG.ChinaHatColorName = "Red"
end)

Button(ModelsPage, "CYAN", function()
    CFG.ChinaHatColorName = "Cyan"
end)

Button(ModelsPage, "WHITE", function()
    CFG.ChinaHatColorName = "White"
end)

Button(ModelsPage, "BLACK", function()
    CFG.ChinaHatColorName = "Black"
end)

Button(ModelsPage, "ORANGE", function()
    CFG.ChinaHatColorName = "Orange"
end)

Slider(
    ModelsPage,
    "Hat Radius",
    1.8,
    4,
    CFG.ChinaHatRadius,
    function(Value)
        CFG.ChinaHatRadius = Value
    end
)

Slider(
    ModelsPage,
    "Hat Height",
    0.8,
    3,
    CFG.ChinaHatHeight,
    function(Value)
        CFG.ChinaHatHeight = Value
    end
)

--========================================================--
-- SNOW HAT
--========================================================--

Section(ModelsPage, "Snow Hat")

Button(
    ModelsPage,
    "Create Snow Hat",
    function()
        if not Head or not Character then
            return
        end

        SafeDestroy(
            Character:FindFirstChild(
                "MonotonSnowHat"
            )
        )

        local Model = Instance.new("Model")
        Model.Name = "MonotonSnowHat"
        Model.Parent = Character

        local Brim = Instance.new("Part")
        Brim.Name = "Brim"
        Brim.Shape = Enum.PartType.Cylinder
        Brim.Size = Vector3.new(
            1.7,
            0.14,
            1.7
        )
        Brim.Material =
            Enum.Material.SmoothPlastic

        Brim.Color =
            Color3.fromRGB(
                240,
                240,
                245
            )

        Brim.CanCollide = false
        Brim.Massless = true
        Brim.CFrame =
            Head.CFrame *
            CFrame.new(
                0,
                0.65,
                0
            )

        Brim.Parent = Model

        local Weld = Instance.new(
            "WeldConstraint"
        )

        Weld.Part0 = Head
        Weld.Part1 = Brim
        Weld.Parent = Brim

        local TopPart = Instance.new("Part")
        TopPart.Name = "Top"
        TopPart.Shape =
            Enum.PartType.Ball

        TopPart.Size =
            Vector3.new(
                1.05,
                1.05,
                1.05
            )

        TopPart.Material =
            Enum.Material.SmoothPlastic

        TopPart.Color =
            Color3.fromRGB(
                250,
                250,
                255
            )

        TopPart.CanCollide = false
        TopPart.Massless = true
        TopPart.CFrame =
            Head.CFrame *
            CFrame.new(
                0,
                1.05,
                0
            )

        TopPart.Parent = Model

        local Weld2 = Instance.new(
            "WeldConstraint"
        )

        Weld2.Part0 = Head
        Weld2.Part1 = TopPart
        Weld2.Parent = TopPart
    end
)

Button(
    ModelsPage,
    "Remove Snow Hat",
    function()
        if Character then
            SafeDestroy(
                Character:FindFirstChild(
                    "MonotonSnowHat"
                )
            )
        end
    end
)

--========================================================--
-- ANIMATION
--========================================================--

Section(
    ModelsPage,
    "Animation Player"
)

Toggle(
    ModelsPage,
    "Animation Hack",
    CFG.AnimationHack,
    function(Value)
        CFG.AnimationHack = Value
    end
)

local AnimationBox = TextBox(
    ModelsPage,
    "Animation ID",
    CFG.AnimationId
)

AnimationBox.FocusLost:Connect(function()
    CFG.AnimationId =
        AnimationBox.Text
end)

Slider(
    ModelsPage,
    "Animation Speed",
    0.1,
    3,
    CFG.AnimationSpeed,
    function(Value)
        CFG.AnimationSpeed = Value

        if AnimationTrack then
            pcall(function()
                AnimationTrack:AdjustSpeed(
                    Value
                )
            end)
        end
    end
)

Toggle(
    ModelsPage,
    "Loop Animation",
    CFG.AnimationLoop,
    function(Value)
        CFG.AnimationLoop = Value

        if AnimationTrack then
            AnimationTrack.Looped = Value
        end
    end
)

local function PlayAnimation(ID)
    if not Humanoid then
        return
    end

    ID = tostring(ID or "")
    ID = ID:gsub(
        "rbxassetid://",
        ""
    )

    if ID == "" then
        return
    end

    CFG.AnimationId = ID

    local Success, Error =
        pcall(function()

            local Animator =
                Humanoid:FindFirstChildOfClass(
                    "Animator"
                )

            if not Animator then
                Animator =
                    Instance.new(
                        "Animator"
                    )

                Animator.Parent =
                    Humanoid
            end

            if AnimationTrack then
                pcall(function()
                    AnimationTrack:Stop(
                        0.15
                    )

                    AnimationTrack:Destroy()
                end)

                AnimationTrack = nil
            end

            local Animation =
                Instance.new(
                    "Animation"
                )

            Animation.AnimationId =
                "rbxassetid://" .. ID

            local Track =
                Animator:LoadAnimation(
                    Animation
                )

            Track.Priority =
                Enum.AnimationPriority.Action

            Track.Looped =
                CFG.AnimationLoop

            Track:Play(
                0.15,
                1,
                CFG.AnimationSpeed
            )

            AnimationTrack = Track
        end)

    if not Success then
        warn(
            "[MonotonVisuals] Animation:",
            Error
        )
    end
end

Button(
    ModelsPage,
    "Play Animation",
    function()
        PlayAnimation(
            AnimationBox.Text
        )
    end
)

Button(
    ModelsPage,
    "Stop Animation",
    function()
        if AnimationTrack then
            pcall(function()
                AnimationTrack:Stop(
                    0.15
                )

                AnimationTrack:Destroy()
            end)

            AnimationTrack = nil
        end
    end
)

Button(
    ModelsPage,
    "Ninja Run",
    function()
        AnimationBox.Text =
            "656118852"

        PlayAnimation(
            "656118852"
        )
    end
)

Button(
    ModelsPage,
    "Ninja Jump",
    function()
        AnimationBox.Text =
            "656117878"

        PlayAnimation(
            "656117878"
        )
    end
)

Label(
    ModelsPage,
    "Вставь доступный Roblox Animation ID. Ограниченные/закрытые ассеты Roblox сам не даст загрузить.",
    45
)

--========================================================--
-- SETTINGS
--========================================================--

Section(SettingsPage, "Camera")

Toggle(
    SettingsPage,
    "Bloom",
    CFG.Bloom,
    function(Value)
        CFG.Bloom = Value
    end
)

Slider(
    SettingsPage,
    "Bloom Intensity",
    0,
    3,
    CFG.BloomIntensity,
    function(Value)
        CFG.BloomIntensity = Value
    end
)

Toggle(
    SettingsPage,
    "Sun Rays",
    CFG.SunRays,
    function(Value)
        CFG.SunRays = Value
    end
)

Slider(
    SettingsPage,
    "Sun Rays Intensity",
    0,
    1,
    CFG.SunRaysIntensity,
    function(Value)
        CFG.SunRaysIntensity = Value
    end
)

Toggle(
    SettingsPage,
    "Depth Of Field",
    CFG.DepthOfField,
    function(Value)
        CFG.DepthOfField = Value
    end
)

Slider(
    SettingsPage,
    "DOF Distance",
    5,
    150,
    CFG.DOFDistance,
    function(Value)
        CFG.DOFDistance = Value
    end
)

Toggle(
    SettingsPage,
    "Color Correction",
    CFG.ColorCorrection,
    function(Value)
        CFG.ColorCorrection = Value
    end
)

Toggle(
    SettingsPage,
    "Fullbright",
    CFG.Fullbright,
    function(Value)
        CFG.Fullbright = Value
    end
)

Toggle(
    SettingsPage,
    "Custom FOV",
    CFG.FOVEnabled,
    function(Value)
        CFG.FOVEnabled = Value
    end
)

Slider(
    SettingsPage,
    "FOV",
    50,
    120,
    CFG.FOV,
    function(Value)
        CFG.FOV = math.floor(Value)
    end
)

Section(
    SettingsPage,
    "Sky Presets"
)

Button(
    SettingsPage,
    "Galaxy",
    function()
        CFG.Sky = "Galaxy"
    end
)

Button(
    SettingsPage,
    "Black Hole",
    function()
        CFG.Sky = "Black Hole"
    end
)

Button(
    SettingsPage,
    "Black",
    function()
        CFG.Sky = "Black"
    end
)

Button(
    SettingsPage,
    "Northern",
    function()
        CFG.Sky = "Northern"
        CFG.GreenSky = true
    end
)

--========================================================--
-- CONFIGS
--========================================================--

Section(
    ConfigPage,
    "Configs"
)

local ConfigNameBox =
    TextBox(
        ConfigPage,
        "Config name",
        "Default"
    )

local ConfigStatus =
    Label(
        ConfigPage,
        "Status: ready",
        28
    )

pcall(function()
    if typeof(makefolder) == "function" then
        if not isfolder(
            "MonotonVisuals"
        ) then
            makefolder(
                "MonotonVisuals"
            )
        end
    end
end)

local function GetConfigPath()
    local Name =
        tostring(
            ConfigNameBox.Text
            or "Default"
        )

    if Name == "" then
        Name = "Default"
    end

    return
        "MonotonVisuals/" ..
        Name ..
        ".json"
end

local function SerializeConfig()
    local Data = {}

    for Key, Value in pairs(CFG) do
        if typeof(Value) == "Color3" then

            Data[Key] = {
                __color = true,
                R = Value.R,
                G = Value.G,
                B = Value.B
            }

        elseif typeof(Value) ~= "function"
            and typeof(Value) ~= "Instance"
            and typeof(Value) ~= "userdata" then

            Data[Key] = Value
        end
    end

    return Data
end

local function ApplyConfig(Data)
    if type(Data) ~= "table" then
        return
    end

    for Key, Value in pairs(Data) do
        if type(Value) == "table"
            and Value.__color then

            CFG[Key] =
                Color3.new(
                    Value.R or 1,
                    Value.G or 1,
                    Value.B or 1
                )
        else
            CFG[Key] = Value
        end
    end
end

Button(
    ConfigPage,
    "Save Config",
    function()

        local Success = false
        local Data =
            SerializeConfig()

        local Encoded

        pcall(function()
            Encoded =
                HttpService:JSONEncode(
                    Data
                )
        end)

        if Encoded
            and typeof(writefile) == "function" then

            pcall(function()
                writefile(
                    GetConfigPath(),
                    Encoded
                )

                Success = true
            end)
        end

        if Success then
            ConfigStatus.Text =
                "Status: saved"
        else
            ConfigStatus.Text =
                "Status: file API unavailable"
        end
    end
)

Button(
    ConfigPage,
    "Load Config",
    function()

        local Success = false
        local Data

        pcall(function()

            if typeof(readfile) == "function"
                and typeof(isfile) == "function"
                and isfile(
                    GetConfigPath()
                ) then

                local Raw =
                    readfile(
                        GetConfigPath()
                    )

                Data =
                    HttpService:JSONDecode(
                        Raw
                    )

                Success = true
            end
        end)

        if Success and Data then
            ApplyConfig(Data)

            ConfigStatus.Text =
                "Status: loaded"
        else
            ConfigStatus.Text =
                "Status: config not found"
        end
    end
)

Button(
    ConfigPage,
    "Delete Config",
    function()

        local Success = false

        pcall(function()

            if typeof(delfile) == "function"
                and typeof(isfile) == "function"
                and isfile(
                    GetConfigPath()
                ) then

                delfile(
                    GetConfigPath()
                )

                Success = true
            end
        end)

        if Success then
            ConfigStatus.Text =
                "Status: deleted"
        else
            ConfigStatus.Text =
                "Status: delete failed"
        end
    end
)

--========================================================--
-- INFO
--========================================================--

Section(
    InfoPage,
    "MONOTON VISUALS V1.3"
)

Label(
    InfoPage,
    "[nasok os-by @go8ai]",
    30
)

Label(
    InfoPage,
    "China Hat reference №3 — широкий объёмный синий конус.",
    35
)

Label(
    InfoPage,
    "Fly использует стандартный Humanoid.MoveDirection, поэтому работает с мобильным joystick.",
    45
)

Label(
    InfoPage,
    "Green Light изменяет только sky/atmosphere effect, без окрашивания Ambient всего мира.",
    45
)

Label(
    InfoPage,
    "Rage → Bunnyhop: автоматические прыжки при движении, сила 1-100.",
    45
)

--========================================================--
-- CHINA HAT
--========================================================--

local HatColors = {
    Blue =
        Color3.fromRGB(
            40,
            100,
            255
        ),

    Red =
        Color3.fromRGB(
            220,
            45,
            55
        ),

    Cyan =
        Color3.fromRGB(
            30,
            220,
            230
        ),

    White =
        Color3.fromRGB(
            245,
            245,
            245
        ),

    Black =
        Color3.fromRGB(
            20,
            20,
            24
        ),

    Orange =
        Color3.fromRGB(
            255,
            130,
            35
        ),
}

local function GetHatColor()
    return
        HatColors[
            CFG.ChinaHatColorName
        ]
        or HatColors.Blue
end

local function ClearChinaHat()
    local Current =
        HatFolder:FindFirstChild(
            LocalPlayer.Name
        )

    if Current then
        Current:Destroy()
    end
end

local function CreateHatPart(
    Name,
    Parent,
    Size,
    CFrameObject,
    Color
)
    local Part =
        Instance.new("Part")

    Part.Name = Name
    Part.Size = Size
    Part.CFrame = CFrameObject
    Part.Color = Color

    Part.Material =
        Enum.Material.SmoothPlastic

    Part.Anchored = false
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Massless = true

    Part.TopSurface =
        Enum.SurfaceType.Smooth

    Part.BottomSurface =
        Enum.SurfaceType.Smooth

    Part.Parent = Parent

    return Part
end

local function CreateChinaHat()
    ClearChinaHat()

    if not CFG.ChinaHat then
        return
    end

    if not Head or not Character then
        return
    end

    local Model =
        Instance.new("Model")

    Model.Name =
        LocalPlayer.Name

    Model.Parent =
        HatFolder

    local Color =
        GetHatColor()

    -- BRIM
    local Brim =
        CreateHatPart(
            "WideBrim",
            Model,
            Vector3.new(
                CFG.ChinaHatRadius * 2,
                0.12,
                CFG.ChinaHatRadius * 2
            ),
            Head.CFrame *
                CFrame.new(
                    0,
                    0.56,
                    0
                ),
            Color
        )

    Brim.Shape =
        Enum.PartType.Cylinder

    local BrimWeld =
        Instance.new(
            "WeldConstraint"
        )

    BrimWeld.Part0 = Head
    BrimWeld.Part1 = Brim
    BrimWeld.Parent = Brim

    -- CONE
    local Layers = 34

    local ConeHeight =
        CFG.ChinaHatHeight

    local BaseRadius =
        CFG.ChinaHatRadius *
        0.91

    local LayerThickness =
        math.max(
            ConeHeight /
                Layers *
                1.45,
            0.045
        )

    for Index = 1, Layers do

        local Alpha =
            (Index - 1) /
            (Layers - 1)

        local Radius =
            BaseRadius *
            ((1 - Alpha) ^ 0.96)

        Radius =
            math.max(
                Radius,
                0.045
            )

        local Y =
            0.63 +
            Alpha *
            ConeHeight

        local Layer =
            CreateHatPart(
                "ConeLayer_" ..
                    Index,
                Model,
                Vector3.new(
                    Radius * 2,
                    LayerThickness,
                    Radius * 2
                ),
                Head.CFrame *
                    CFrame.new(
                        0,
                        Y,
                        0
                    ),
                Color
            )

        Layer.Shape =
            Enum.PartType.Cylinder

        local Weld =
            Instance.new(
                "WeldConstraint"
            )

        Weld.Part0 = Head
        Weld.Part1 = Layer
        Weld.Parent = Layer
    end

    -- APEX
    local Apex =
        CreateHatPart(
            "Apex",
            Model,
            Vector3.new(
                0.12,
                0.18,
                0.12
            ),
            Head.CFrame *
                CFrame.new(
                    0,
                    0.63 +
                        ConeHeight +
                        0.06,
                    0
                ),
            Color
        )

    Apex.Shape =
        Enum.PartType.Ball

    local ApexWeld =
        Instance.new(
            "WeldConstraint"
        )

    ApexWeld.Part0 = Head
    ApexWeld.Part1 = Apex
    ApexWeld.Parent = Apex
end

--========================================================--
-- CHAMS
--========================================================--

local function RemoveChams(Player)
    local Object =
        ChamsObjects[Player]

    if Object then
        SafeDestroy(Object)
        ChamsObjects[Player] = nil
    end
end

local function ApplyChams(Player)
    if Player == LocalPlayer then
        return
    end

    local Target =
        Player.Character

    if not Target then
        return
    end

    if ChamsObjects[Player] then
        local Existing =
            ChamsObjects[Player]

        if Existing.Adornee ==
            Target then

            Existing.FillColor =
                CFG.ChamsColor

            Existing.OutlineColor =
                CFG.AccentColor

            return
        end

        RemoveChams(Player)
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MonotonChams"

    Highlight.Adornee =
        Target

    Highlight.FillColor =
        CFG.ChamsColor

    Highlight.OutlineColor =
        CFG.AccentColor

    Highlight.FillTransparency =
        0.55

    Highlight.OutlineTransparency =
        0

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.Parent =
        Target

    ChamsObjects[Player] =
        Highlight
end

local function UpdateChams()
    for _, Player in ipairs(
        Players:GetPlayers()
    ) do

        if Player ~= LocalPlayer then

            if CFG.Chams then
                ApplyChams(Player)
            else
                RemoveChams(Player)
            end
        end
    end
end

--========================================================--
-- ESP
--========================================================--

local DrawingAvailable =
    typeof(Drawing) == "table"
    or typeof(Drawing) == "userdata"
    or typeof(Drawing) == "function"

local function NewDrawing(Type)
    if not DrawingAvailable then
        return nil
    end

    local Success, Object =
        pcall(function()
            return Drawing.new(Type)
        end)

    if Success then
        return Object
    end

    return nil
end

local function HideDrawing(Object)
    if Object then
        pcall(function()
            Object.Visible = false
        end)
    end
end

local function RemoveESP(Player)
    local Data =
        ESPObjects[Player]

    if not Data then
        return
    end

    for _, Object in pairs(Data) do

        if type(Object) == "table" then

            for _, SubObject in pairs(Object) do
                HideDrawing(SubObject)

                pcall(function()
                    SubObject:Remove()
                end)
            end

        else

            HideDrawing(Object)

            pcall(function()
                Object:Remove()
            end)
        end
    end

    ESPObjects[Player] = nil
end

local function CreateESP(Player)
    if Player == LocalPlayer then
        return
    end

    if ESPObjects[Player] then
        return
    end

    local Data = {}

    Data.Box = {}
    Data.Outline = {}
    Data.Corner = {}
    Data.Skeleton = {}

    for Index = 1, 4 do
        Data.Box[Index] =
            NewDrawing("Line")

        Data.Outline[Index] =
            NewDrawing("Line")
    end

    for Index = 1, 8 do
        Data.Corner[Index] =
            NewDrawing("Line")
    end

    for Index = 1, 14 do
        Data.Skeleton[Index] =
            NewDrawing("Line")
    end

    Data.Fill =
        NewDrawing("Square")

    Data.HealthBackground =
        NewDrawing("Line")

    Data.Health =
        NewDrawing("Line")

    Data.Name =
        NewDrawing("Text")

    if Data.Fill then
        Data.Fill.Filled = true
        Data.Fill.Transparency = 0.75
    end

    if Data.Name then
        Data.Name.Center = true
        Data.Name.Outline = true
        Data.Name.Size = 13
    end

    ESPObjects[Player] =
        Data
end

local function SetLine(
    Line,
    From,
    To,
    Visible,
    Color,
    Thickness
)
    if not Line then
        return
    end

    Line.From = From
    Line.To = To
    Line.Visible = Visible
    Line.Color = Color
    Line.Thickness =
        Thickness or 1
end

local R15Skeleton = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},

    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},

    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},

    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},

    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
}

local R6Skeleton = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

local function GetBodyPart(
    Target,
    Name
)
    return Target:FindFirstChild(
        Name
    )
end

local function GetScreenBounds(
    Target
)
    local Success,
        BoxCFrame,
        Size =
        pcall(function()
            return Target:GetBoundingBox()
        end)

    if not Success then
        return nil
    end

    local Half = Size / 2

    local Corners = {
        Vector3.new(
            -Half.X,
            -Half.Y,
            -Half.Z
        ),

        Vector3.new(
            -Half.X,
            -Half.Y,
            Half.Z
        ),

        Vector3.new(
            -Half.X,
            Half.Y,
            -Half.Z
        ),

        Vector3.new(
            -Half.X,
            Half.Y,
            Half.Z
        ),

        Vector3.new(
            Half.X,
            -Half.Y,
            -Half.Z
        ),

        Vector3.new(
            Half.X,
            -Half.Y,
            Half.Z
        ),

        Vector3.new(
            Half.X,
            Half.Y,
            -Half.Z
        ),

        Vector3.new(
            Half.X,
            Half.Y,
            Half.Z
        ),
    }

    local MinX = math.huge
    local MinY = math.huge
    local MaxX = -math.huge
    local MaxY = -math.huge

    local AnyVisible = false

    for _, Offset in ipairs(Corners) do

        local WorldPosition =
            BoxCFrame:PointToWorldSpace(
                Offset
            )

        local ScreenPosition,
            Visible =
            Camera:WorldToViewportPoint(
                WorldPosition
            )

        if Visible then
            AnyVisible = true
        end

        MinX =
            math.min(
                MinX,
                ScreenPosition.X
            )

        MinY =
            math.min(
                MinY,
                ScreenPosition.Y
            )

        MaxX =
            math.max(
                MaxX,
                ScreenPosition.X
            )

        MaxY =
            math.max(
                MaxY,
                ScreenPosition.Y
            )
    end

    if not AnyVisible then
        return nil
    end

    return {
        MinX = MinX,
        MinY = MinY,
        MaxX = MaxX,
        MaxY = MaxY,

        Width =
            MaxX - MinX,

        Height =
            MaxY - MinY,

        Center =
            Vector2.new(
                (MinX + MaxX) / 2,
                (MinY + MaxY) / 2
            )
    }
end

local function UpdateESP()
    for Player, Data in pairs(
        ESPObjects
    ) do

        local Target =
            Player.Character

        local TargetRoot =
            Target
            and Target:FindFirstChild(
                "HumanoidRootPart"
            )

        local TargetHumanoid =
            Target
            and Target:FindFirstChildOfClass(
                "Humanoid"
            )

        local Valid = true

        if not CFG.ESP
            or not CFG.ESPEnabled then

            Valid = false
        end

        if not Target
            or not TargetRoot
            or not TargetHumanoid
            or TargetHumanoid.Health <= 0 then

            Valid = false
        end

        if Valid
            and CFG.ESPTeamCheck then

            if Player.Team ~= nil
                and LocalPlayer.Team ~= nil
                and Player.Team ==
                    LocalPlayer.Team then

                Valid = false
            end
        end

        if Valid and Root then

            local Distance =
                (
                    TargetRoot.Position -
                    Root.Position
                ).Magnitude

            if Distance >
                CFG.ESPMaxDistance then

                Valid = false
            end
        end

        if not Valid then

            for _, Object in pairs(Data) do

                if type(Object) == "table" then

                    for _, SubObject in pairs(Object) do
                        HideDrawing(SubObject)
                    end

                else
                    HideDrawing(Object)
                end
            end

            continue
        end

        local Bounds =
            GetScreenBounds(
                Target
            )

        if not Bounds then

            for _, Object in pairs(Data) do

                if type(Object) == "table" then

                    for _, SubObject in pairs(Object) do
                        HideDrawing(SubObject)
                    end

                else
                    HideDrawing(Object)
                end
            end

            continue
        end

        local X =
            Bounds.MinX

        local Y =
            Bounds.MinY

        local W =
            Bounds.Width

        local H =
            Bounds.Height

        local Color =
            CFG.AccentColor

        -- BOX
        if CFG.ESPBox then

            SetLine(
                Data.Box[1],
                Vector2.new(
                    X,
                    Y
                ),
                Vector2.new(
                    X + W,
                    Y
                ),
                true,
                Color,
                1.5
            )

            SetLine(
                Data.Box[2],
                Vector2.new(
                    X + W,
                    Y
                ),
                Vector2.new(
                    X + W,
                    Y + H
                ),
                true,
                Color,
                1.5
            )

            SetLine(
                Data.Box[3],
                Vector2.new(
                    X + W,
                    Y + H
                ),
                Vector2.new(
                    X,
                    Y + H
                ),
                true,
                Color,
                1.5
            )

            SetLine(
                Data.Box[4],
                Vector2.new(
                    X,
                    Y + H
                ),
                Vector2.new(
                    X,
                    Y
                ),
                true,
                Color,
                1.5
            )

        else

            for _, Line in ipairs(
                Data.Box
            ) do
                HideDrawing(Line)
            end
        end

        -- OUTLINE
        if CFG.ESPOutline then

            local Pad = 2

            SetLine(
                Data.Outline[1],
                Vector2.new(
                    X - Pad,
                    Y - Pad
                ),
                Vector2.new(
                    X + W + Pad,
                    Y - Pad
                ),
                true,
                Color3.new(0, 0, 0),
                3
            )

            SetLine(
                Data.Outline[2],
                Vector2.new(
                    X + W + Pad,
                    Y - Pad
                ),
                Vector2.new(
                    X + W + Pad,
                    Y + H + Pad
                ),
                true,
                Color3.new(0, 0, 0),
                3
            )

            SetLine(
                Data.Outline[3],
                Vector2.new(
                    X + W + Pad,
                    Y + H + Pad
                ),
                Vector2.new(
                    X - Pad,
                    Y + H + Pad
                ),
                true,
                Color3.new(0, 0, 0),
                3
            )

            SetLine(
                Data.Outline[4],
                Vector2.new(
                    X - Pad,
                    Y + H + Pad
                ),
                Vector2.new(
                    X - Pad,
                    Y - Pad
                ),
                true,
                Color3.new(0, 0, 0),
                3
            )

        else

            for _, Line in ipairs(
                Data.Outline
            ) do
                HideDrawing(Line)
            end
        end

        -- FILL
        if Data.Fill then

            Data.Fill.Position =
                Vector2.new(
                    X,
                    Y
                )

            Data.Fill.Size =
                Vector2.new(
                    W,
                    H
                )

            Data.Fill.Color =
                Color

            Data.Fill.Visible =
                CFG.ESPFill
        end

        -- CORNERS
        if CFG.ESPCorner then

            local Length =
                math.min(
                    W,
                    H
                ) * 0.25

            SetLine(
                Data.Corner[1],
                Vector2.new(
                    X,
                    Y
                ),
                Vector2.new(
                    X + Length,
                    Y
                ),
                true,
                Color,
                2
            )

            SetLine(
                Data.Corner[2],
                Vector2.new(
                    X,
                    Y
                ),
                Vector2.new(
                    X,
                    Y + Length
                ),
                true,
                Color,
                2
            )

            SetLine(
                Data.Corner[3],
                Vector2.new(
                    X + W,
                    Y
                ),
                Vector2.new(
                    X + W - Length,
                    Y
                ),
                true,
                Color,
                2
            )

            SetLine(
                Data.Corner[4],
                Vector2.new(
                    X + W,
                    Y
                ),
                Vector2.new(
                    X + W,
                    Y + Length
                ),
                true,
                Color,
                2
            )

            SetLine(
                Data.Corner[5],
                Vector2.new(
                    X,
                    Y + H
                ),
                Vector2.new(
                    X + Length,
                    Y + H
                ),
                true,
                Color,
                2
            )

            SetLine(
                Data.Corner[6],
                Vector2.new(
                    X,
                    Y + H
                ),
                Vector2.new(
                    X,
                    Y + H - Length
                ),
                true,
                Color,
                2
            )

            SetLine(
                Data.Corner[7],
                Vector2.new(
                    X + W,
                    Y + H
                ),
                Vector2.new(
                    X + W - Length,
                    Y + H
                ),
                true,
                Color,
                2
            )

            SetLine(
                Data.Corner[8],
                Vector2.new(
                    X + W,
                    Y + H
                ),
                Vector2.new(
                    X + W,
                    Y + H - Length
                ),
                true,
                Color,
                2
            )

        else

            for _, Line in ipairs(
                Data.Corner
            ) do
                HideDrawing(Line)
            end
        end

        -- HEALTH
        if Data.Health
            and Data.HealthBackground then

            local HealthPercent =
                math.clamp(
                    TargetHumanoid.Health /
                        math.max(
                            TargetHumanoid.MaxHealth,
                            1
                        ),
                    0,
                    1
                )

            local HealthX =
                X - 6

            SetLine(
                Data.HealthBackground,
                Vector2.new(
                    HealthX,
                    Y + H
                ),
                Vector2.new(
                    HealthX,
                    Y
                ),
                CFG.ESPHealth,
                Color3.new(0, 0, 0),
                3
            )

            SetLine(
                Data.Health,
                Vector2.new(
                    HealthX,
                    Y + H
                ),
                Vector2.new(
                    HealthX,
                    Y + H -
                        H *
                        HealthPercent
                ),
                CFG.ESPHealth,
                Color3.fromRGB(
                    math.floor(
                        255 *
                        (1 - HealthPercent)
                    ),
                    math.floor(
                        255 *
                        HealthPercent
                    ),
                    40
                ),
                2
            )
        end

        -- NAME
        if Data.Name then

            Data.Name.Text =
                Player.DisplayName

            Data.Name.Position =
                Vector2.new(
                    Bounds.Center.X,
                    Y - 17
                )

            Data.Name.Color =
                Color

            Data.Name.Visible =
                CFG.ESPNames
        end

        -- SKELETON
        if CFG.ESPSkeleton then

            local Pairs

            if TargetHumanoid.RigType ==
                Enum.HumanoidRigType.R15 then

                Pairs =
                    R15Skeleton
            else
                Pairs =
                    R6Skeleton
            end

            for Index = 1, 14 do

                local Pair =
                    Pairs[Index]

                local Line =
                    Data.Skeleton[Index]

                if Pair and Line then

                    local A =
                        GetBodyPart(
                            Target,
                            Pair[1]
                        )

                    local B =
                        GetBodyPart(
                            Target,
                            Pair[2]
                        )

                    if A and B then

                        local AP,
                            AVisible =
                            Camera:WorldToViewportPoint(
                                A.Position
                            )

                        local BP,
                            BVisible =
                            Camera:WorldToViewportPoint(
                                B.Position
                            )

                        SetLine(
                            Line,
                            Vector2.new(
                                AP.X,
                                AP.Y
                            ),
                            Vector2.new(
                                BP.X,
                                BP.Y
                            ),
                            AVisible or BVisible,
                            Color,
                            1.2
                        )
                    else
                        HideDrawing(Line)
                    end
                end
            end

        else

            for _, Line in ipairs(
                Data.Skeleton
            ) do
                HideDrawing(Line)
            end
        end
    end
end

--========================================================--
-- PLAYER ESP CONNECTIONS
--========================================================--

for _, Player in ipairs(
    Players:GetPlayers()
) do

    if Player ~= LocalPlayer then
        CreateESP(Player)

        Player.CharacterAdded:Connect(
            function()
                task.wait(0.5)
                CreateESP(Player)
            end
        )
    end
end

Players.PlayerAdded:Connect(
    function(Player)

        CreateESP(Player)

        Player.CharacterAdded:Connect(
            function()
                task.wait(0.5)
                CreateESP(Player)
            end
        )
    end
)

Players.PlayerRemoving:Connect(
    function(Player)

        RemoveESP(Player)
        RemoveChams(Player)
    end
)

--========================================================--
-- WORLD EFFECTS
--========================================================--

local BloomEffect =
    Instance.new("BloomEffect")

BloomEffect.Name =
    "MonotonBloom"

BloomEffect.Enabled = false
BloomEffect.Intensity =
    CFG.BloomIntensity

BloomEffect.Size = 24
BloomEffect.Threshold = 0.8
BloomEffect.Parent = Lighting

local SunRaysEffect =
    Instance.new("SunRaysEffect")

SunRaysEffect.Name =
    "MonotonSunRays"

SunRaysEffect.Enabled = false
SunRaysEffect.Intensity =
    CFG.SunRaysIntensity

SunRaysEffect.Spread = 0.8
SunRaysEffect.Parent = Lighting

local DOFEffect =
    Instance.new(
        "DepthOfFieldEffect"
    )

DOFEffect.Name =
    "MonotonDOF"

DOFEffect.Enabled = false
DOFEffect.FocusDistance =
    CFG.DOFDistance

DOFEffect.InFocusRadius = 25
DOFEffect.NearIntensity = 0.1
DOFEffect.FarIntensity = 0.35
DOFEffect.Parent = Lighting

local ColorEffect =
    Instance.new(
        "ColorCorrectionEffect"
    )

ColorEffect.Name =
    "MonotonColorCorrection"

ColorEffect.Enabled = false
ColorEffect.Brightness = 0.03
ColorEffect.Contrast = 0.08
ColorEffect.Saturation = 0.15
ColorEffect.TintColor =
    Color3.fromRGB(
        255,
        235,
        245
    )

ColorEffect.Parent =
    Lighting

local Atmosphere =
    Lighting:FindFirstChild(
        "MonotonAtmosphere"
    )

if not Atmosphere then
    Atmosphere =
        Instance.new(
            "Atmosphere"
        )

    Atmosphere.Name =
        "MonotonAtmosphere"

    Atmosphere.Parent =
        Lighting
end

local OriginalAtmosphere = {
    Density =
        Atmosphere.Density,

    Haze =
        Atmosphere.Haze,

    Glare =
        Atmosphere.Glare,

    Color =
        Atmosphere.Color,

    Decay =
        Atmosphere.Decay,
}

--========================================================--
-- GREEN AURORA
--========================================================--

local function ClearAurora()
    for _, Object in ipairs(
        AuroraFolder:GetChildren()
    ) do

        SafeDestroy(Object)
    end
end

local function CreateAuroraBeam(Index)
    local APart =
        Instance.new("Part")

    APart.Name =
        "AuroraA_" .. Index

    APart.Anchored = true
    APart.CanCollide = false
    APart.CanTouch = false
    APart.CanQuery = false
    APart.Transparency = 1
    APart.Size =
        Vector3.new(
            1,
            1,
            1
        )

    APart.Parent =
        AuroraFolder

    local BPart =
        APart:Clone()

    BPart.Name =
        "AuroraB_" .. Index

    BPart.Parent =
        AuroraFolder

    local Attachment0 =
        Instance.new(
            "Attachment"
        )

    Attachment0.Parent =
        APart

    local Attachment1 =
        Instance.new(
            "Attachment"
        )

    Attachment1.Parent =
        BPart

    local Beam =
        Instance.new("Beam")

    Beam.Name =
        "AuroraBeam_" .. Index

    Beam.Attachment0 =
        Attachment0

    Beam.Attachment1 =
        Attachment1

    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.Segments = 24
    Beam.Width0 = 8
    Beam.Width1 = 13
    Beam.CurveSize0 = 12
    Beam.CurveSize1 = -15

    Beam.Transparency =
        NumberSequence.new({
            NumberSequenceKeypoint.new(
                0,
                0.72
            ),

            NumberSequenceKeypoint.new(
                0.5,
                0.42
            ),

            NumberSequenceKeypoint.new(
                1,
                0.78
            ),
        })

    Beam.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(
                    20,
                    255,
                    150
                )
            ),

            ColorSequenceKeypoint.new(
                0.5,
                Color3.fromRGB(
                    80,
                    255,
                    210
                )
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(
                    30,
                    180,
                    130
                )
            ),
        })

    Beam.Parent =
        APart

    return {
        A = APart,
        B = BPart,
        Index = Index
    }
end

local AuroraObjects = {}

for Index = 1, 6 do
    local Object =
        CreateAuroraBeam(Index)

    if Object then
        table.insert(
            AuroraObjects,
            Object
        )
    end
end

local function UpdateAurora()
    if not Root then
        return
    end

    if not CFG.GreenSky then

        for _, Object in ipairs(
            AuroraObjects
        ) do

            Object.A.Transparency = 1
            Object.B.Transparency = 1
        end

        return
    end

    local Base =
        Root.Position

    local Time =
        os.clock()

    for Index, Object in ipairs(
        AuroraObjects
    ) do

        local OffsetX =
            math.sin(
                Time * 0.18 +
                Index
            ) * 25

        local OffsetZ =
            math.cos(
                Time * 0.15 +
                Index * 1.4
            ) * 20

        local Height =
            75 +
            Index * 7

        Object.A.CFrame =
            CFrame.new(
                Base +
                    Vector3.new(
                        OffsetX - 65,
                        Height,
                        OffsetZ
                    )
            )

        Object.B.CFrame =
            CFrame.new(
                Base +
                    Vector3.new(
                        OffsetX + 65,
                        Height +
                            math.sin(
                                Time * 0.25 +
                                Index
                            ) * 8,
                        OffsetZ + 20
                    )
            )

        Object.A.Transparency = 0
        Object.B.Transparency = 0
    end
end

--========================================================--
-- SKY
--========================================================--

local SkyObject =
    Lighting:FindFirstChild(
        "MonotonSky"
    )

if not SkyObject then

    SkyObject =
        Instance.new("Sky")

    SkyObject.Name =
        "MonotonSky"

    SkyObject.Parent =
        Lighting
end

local SkyPresets = {

    Galaxy = {
        SkyboxBk =
            "rbxassetid://159454299",

        SkyboxDn =
            "rbxassetid://159454296",

        SkyboxFt =
            "rbxassetid://159454293",

        SkyboxLf =
            "rbxassetid://159454286",

        SkyboxRt =
            "rbxassetid://159454300",

        SkyboxUp =
            "rbxassetid://159454288",
    },

    ["Black Hole"] = {
        SkyboxBk =
            "rbxassetid://166745942",

        SkyboxDn =
            "rbxassetid://166745942",

        SkyboxFt =
            "rbxassetid://166745942",

        SkyboxLf =
            "rbxassetid://166745942",

        SkyboxRt =
            "rbxassetid://166745942",

        SkyboxUp =
            "rbxassetid://166745942",
    },

    Black = {
        SkyboxBk = "",
        SkyboxDn = "",
        SkyboxFt = "",
        SkyboxLf = "",
        SkyboxRt = "",
        SkyboxUp = "",
    },

    Northern = {
        SkyboxBk =
            "rbxassetid://12064107",

        SkyboxDn =
            "rbxassetid://12064152",

        SkyboxFt =
            "rbxassetid://12064121",

        SkyboxLf =
            "rbxassetid://12064118",

        SkyboxRt =
            "rbxassetid://12064131",

        SkyboxUp =
            "rbxassetid://12064127",
    },
}

local function ApplySky(Name)
    local Data =
        SkyPresets[Name]

    if not Data then
        return
    end

    for Property, Value in pairs(
        Data
    ) do

        pcall(function()
            SkyObject[Property] =
                Value
        end)
    end
end

--========================================================--
-- PARTICLES
--========================================================--

local function CreateVisualParticle(
    Type
)
    if not Root then
        return
    end

    local Part =
        Instance.new("Part")

    Part.Name = Type
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Material =
        Enum.Material.Neon

    Part.Size =
        Vector3.new(
            0.12,
            0.12,
            0.12
        )

    if Type == "Sakura" then

        Part.Size =
            Vector3.new(
                0.2,
                0.07,
                0.2
            )

        Part.Color =
            Color3.fromRGB(
                255,
                125,
                190
            )

    elseif Type == "Snow" then

        Part.Shape =
            Enum.PartType.Ball

        Part.Size =
            Vector3.new(
                0.16,
                0.16,
                0.16
            )

        Part.Color =
            Color3.fromRGB(
                245,
                250,
                255
            )

    elseif Type == "Star" then

        Part.Shape =
            Enum.PartType.Ball

        Part.Size =
            Vector3.new(
                0.09,
                0.09,
                0.09
            )

        Part.Color =
            Color3.fromRGB(
                255,
                255,
                190
            )

    elseif Type == "Firefly" then

        Part.Shape =
            Enum.PartType.Ball

        Part.Size =
            Vector3.new(
                0.11,
                0.11,
                0.11
            )

        Part.Color =
            Color3.fromRGB(
                160,
                255,
                100
            )

    elseif Type == "Heart" then

        Part.Size =
            Vector3.new(
                0.16,
                0.16,
                0.05
            )

        Part.Color =
            Color3.fromRGB(
                255,
                60,
                120
            )
    end

    Part.Position =
        Root.Position +
        Vector3.new(
            math.random(-35, 35),
            math.random(6, 16),
            math.random(-35, 35)
        )

    Part.Parent =
        ParticleFolder

    table.insert(
        ParticleObjects,
        Part
    )

    return Part
end

for _ = 1, 35 do
    CreateVisualParticle(
        "Sakura"
    )
end

for _ = 1, 30 do
    CreateVisualParticle(
        "Snow"
    )
end

for _ = 1, 30 do
    CreateVisualParticle(
        "Star"
    )
end

for _ = 1, 20 do
    CreateVisualParticle(
        "Firefly"
    )
end

for _ = 1, 12 do
    CreateVisualParticle(
        "Heart"
    )
end

--========================================================--
-- SAKURA AURA
--========================================================--

local function ClearAura()
    for _, Object in ipairs(
        AuraObjects
    ) do
        SafeDestroy(Object)
    end

    table.clear(
        AuraObjects
    )
end

local function CreateAura()
    ClearAura()

    if not Root then
        return
    end

    for Index = 1, 14 do

        local Petal =
            Instance.new("Part")

        Petal.Name =
            "SakuraPetal"

        Petal.Anchored = true
        Petal.CanCollide = false
        Petal.CanTouch = false
        Petal.CanQuery = false

        Petal.Material =
            Enum.Material.Neon

        Petal.Color =
            Color3.fromRGB(
                255,
                100,
                175
            )

        Petal.Size =
            Vector3.new(
                0.35,
                0.08,
                0.18
            )

        Petal.Parent =
            AuraFolder

        table.insert(
            AuraObjects,
            Petal
        )
    end
end

local function UpdateAura()
    if not CFG.SakuraAura then

        for _, Object in ipairs(
            AuraObjects
        ) do
            Object.Transparency = 1
        end

        return
    end

    if not Root then
        return
    end

    if #AuraObjects == 0 then
        CreateAura()
    end

    local Time =
        os.clock()

    for Index, Petal in ipairs(
        AuraObjects
    ) do

        local Alpha =
            (
                Index /
                #AuraObjects
            ) *
            math.pi *
            2

        local Angle =
            Alpha +
            Time * 0.8

        local Radius = 2.7

        local Height =
            1.5 +
            math.sin(
                Time * 2 +
                Index
            ) * 0.45

        local Position =
            Root.Position +
            Vector3.new(
                math.cos(Angle) *
                    Radius,

                Height,

                math.sin(Angle) *
                    Radius
            )

        Petal.CFrame =
            CFrame.new(
                Position
            ) *
            CFrame.Angles(
                0,
                -Angle,
                math.sin(
                    Time * 2 +
                    Index
                ) * 0.4
            )

        Petal.Transparency =
            0.05 +
            math.abs(
                math.sin(
                    Time * 2 +
                    Index
                )
            ) * 0.25
    end
end

--========================================================--
-- NOCLIP
--========================================================--

local function UpdateNoclip()
    if not Character then
        return
    end

    for _, Object in ipairs(
        Character:GetDescendants()
    ) do

        if Object:IsA("BasePart") then

            if CFG.Noclip then

                if NoclipCache[Object] ==
                    nil then

                    NoclipCache[Object] =
                        Object.CanCollide
                end

                Object.CanCollide = false

            else

                if NoclipCache[Object] ~=
                    nil then

                    Object.CanCollide =
                        NoclipCache[Object]

                    NoclipCache[Object] =
                        nil
                end
            end
        end
    end
end

--========================================================--
-- FLY
--========================================================--

local function GetFlyDirection()
    if not Humanoid
        or not Camera then

        return Vector3.zero
    end

    local MoveDirection =
        Humanoid.MoveDirection

    local Direction =
        Vector3.zero

    if MoveDirection.Magnitude >
        0.01 then

        local Look =
            Camera.CFrame.LookVector

        local Right =
            Camera.CFrame.RightVector

        local FlatForward =
            Vector3.new(
                Look.X,
                0,
                Look.Z
            )

        local FlatRight =
            Vector3.new(
                Right.X,
                0,
                Right.Z
            )

        if FlatForward.Magnitude > 0 then
            FlatForward =
                FlatForward.Unit
        end

        if FlatRight.Magnitude > 0 then
            FlatRight =
                FlatRight.Unit
        end

        local X =
            MoveDirection:Dot(
                FlatRight
            )

        local Z =
            MoveDirection:Dot(
                FlatForward
            )

        Direction =
            FlatRight * X +
            Camera.CFrame.LookVector *
                Z
    end

    if UIS:IsKeyDown(
        Enum.KeyCode.Space
    ) then

        Direction +=
            Vector3.new(
                0,
                1,
                0
            )
    end

    if UIS:IsKeyDown(
        Enum.KeyCode.LeftControl
    )
        or UIS:IsKeyDown(
            Enum.KeyCode.RightControl
        ) then

        Direction -=
            Vector3.new(
                0,
                1,
                0
            )
    end

    if Direction.Magnitude > 1 then
        Direction =
            Direction.Unit
    end

    return Direction
end

local function UpdateFly()
    if not Humanoid
        or not Root then
        return
    end

    if not CFG.Fly then
        return
    end

    Humanoid.PlatformStand = true
    Humanoid.AutoRotate = false

    local Direction =
        GetFlyDirection()

    Root.AssemblyLinearVelocity =
        Direction *
        CFG.FlySpeed
end

--========================================================--
-- AIR JUMP
--========================================================--

UIS.JumpRequest:Connect(
    function()

        if not CFG.AirJump then
            return
        end

        if not Humanoid
            or not Root then
            return
        end

        if Humanoid.Health <= 0 then
            return
        end

        if os.clock() - LastJump <
            0.12 then

            return
        end

        LastJump =
            os.clock()

        Humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

        local Velocity =
            Root.AssemblyLinearVelocity

        Root.AssemblyLinearVelocity =
            Vector3.new(
                Velocity.X,
                CFG.JumpPower,
                Velocity.Z
            )
    end
)

--========================================================--
-- BUNNYHOP ENGINE
--========================================================--

local function DoBunnyhop()
    if not CFG.Bunnyhop then
        return
    end

    if not Humanoid
        or not Root then
        return
    end

    if Humanoid.Health <= 0 then
        return
    end

    -- Не вмешиваемся в fly
    if CFG.Fly then
        return
    end

    local MoveDirection =
        Humanoid.MoveDirection

    -- Прыгаем только когда игрок движется
    if MoveDirection.Magnitude <
        0.05 then

        return
    end

    local State =
        Humanoid:GetState()

    local Grounded =
        State ==
            Enum.HumanoidStateType.Running
        or State ==
            Enum.HumanoidStateType.Landed
        or State ==
            Enum.HumanoidStateType.RunningNoPhysics

    if not Grounded then
        return
    end

    -- Небольшой debounce,
    -- чтобы не спамить ChangeState
    if os.clock() -
        LastBunnyhop < 0.08 then

        return
    end

    LastBunnyhop =
        os.clock()

    Humanoid:ChangeState(
        Enum.HumanoidStateType.Jumping
    )

    local Velocity =
        Root.AssemblyLinearVelocity

    Root.AssemblyLinearVelocity =
        Vector3.new(
            Velocity.X,
            CFG.BunnyhopPower,
            Velocity.Z
        )
end

--========================================================--
-- MOVEMENT
--========================================================--

local function UpdateMovement()
    if not Humanoid then
        return
    end

    if CFG.SpeedHack
        and not CFG.Fly then

        Humanoid.WalkSpeed =
            CFG.Speed
    else

        if not CFG.Fly then
            Humanoid.WalkSpeed = 16
        end
    end

    if CFG.JumpBoost then

        Humanoid.UseJumpPower = true

        Humanoid.JumpPower =
            CFG.JumpPower

    elseif not CFG.Bunnyhop then

        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = 50
    end
end

--========================================================--
-- EFFECTS
--========================================================--

local function UpdateEffects()
    BloomEffect.Enabled =
        CFG.Bloom

    BloomEffect.Intensity =
        CFG.BloomIntensity

    SunRaysEffect.Enabled =
        CFG.SunRays

    SunRaysEffect.Intensity =
        CFG.SunRaysIntensity

    DOFEffect.Enabled =
        CFG.DepthOfField

    DOFEffect.FocusDistance =
        CFG.DOFDistance

    ColorEffect.Enabled =
        CFG.ColorCorrection

    Camera =
        workspace.CurrentCamera

    if Camera then

        if CFG.FOVEnabled then
            Camera.FieldOfView =
                CFG.FOV
        else
            Camera.FieldOfView = 70
        end
    end

    -- FULLBRIGHT
    if CFG.Fullbright then

        Lighting.Brightness = 2

        Lighting.ExposureCompensation =
            0.5

        Lighting.Ambient =
            Color3.fromRGB(
                180,
                180,
                180
            )

        Lighting.OutdoorAmbient =
            Color3.fromRGB(
                180,
                180,
                180
            )

    elseif not CFG.Night then

        Lighting.Brightness =
            OriginalLighting.Brightness

        Lighting.ExposureCompensation =
            OriginalLighting.ExposureCompensation

        Lighting.Ambient =
            OriginalLighting.Ambient

        Lighting.OutdoorAmbient =
            OriginalLighting.OutdoorAmbient
    end

    -- NIGHT
    if CFG.Night then

        Lighting.ClockTime = 0

        if not CFG.Fullbright then

            Lighting.Brightness =
                math.max(
                    0.1,
                    2 -
                        CFG.NightDarkness
                )
        end

    elseif not CFG.Fullbright then

        Lighting.ClockTime =
            OriginalLighting.ClockTime
    end

    -- GREEN SKY
    if CFG.GreenSky then

        -- НЕ меняем Ambient.
        -- Поэтому земля/мир не становится зелёным.

        Atmosphere.Density =
            0.18

        Atmosphere.Haze =
            1.2

        Atmosphere.Glare =
            0.35

        Atmosphere.Color =
            Color3.fromRGB(
                40,
                255,
                160
            )

        Atmosphere.Decay =
            Color3.fromRGB(
                0,
                90,
                55
            )

    else

        Atmosphere.Density =
            OriginalAtmosphere.Density

        Atmosphere.Haze =
            OriginalAtmosphere.Haze

        Atmosphere.Glare =
            OriginalAtmosphere.Glare

        Atmosphere.Color =
            OriginalAtmosphere.Color

        Atmosphere.Decay =
            OriginalAtmosphere.Decay
    end
end

--========================================================--
-- PARTICLES UPDATE
--========================================================--

local function UpdateParticles()
    if not Root then
        return
    end

    local Time =
        os.clock()

    for _, Part in ipairs(
        ParticleObjects
    ) do

        if not Part
            or not Part.Parent then
            continue
        end

        local Type =
            Part.Name

        local Allowed = false

        if Type == "Sakura"
            and CFG.SakuraLeaves then

            Allowed = true

        elseif Type == "Snow"
            and CFG.Snow then

            Allowed = true

        elseif Type == "Star"
            and CFG.Stars then

            Allowed = true

        elseif Type == "Firefly"
            and CFG.Fireflies then

            Allowed = true

        elseif Type == "Heart"
            and CFG.Hearts then

            Allowed = true
        end

        if not Allowed then

            Part.Transparency = 1

            continue
        end

        Part.Transparency = 0

        local Distance =
            (
                Part.Position -
                Root.Position
            ).Magnitude

        if Distance > 70
            or Part.Position.Y <
                Root.Position.Y - 5
            or Part.Position.Y >
                Root.Position.Y + 30 then

            Part.Position =
                Root.Position +
                Vector3.new(
                    math.random(
                        -35,
                        35
                    ),

                    math.random(
                        6,
                        16
                    ),

                    math.random(
                        -35,
                        35
                    )
                )
        end

        if Type == "Sakura" then

            Part.Position +=
                Vector3.new(
                    math.sin(
                        Time * 1.7 +
                        _
                    ) * 0.01,

                    -0.064,

                    math.cos(
                        Time * 1.2
                    ) * 0.01
                )

            Part.CFrame *=
                CFrame.Angles(
                    0,
                    0.03,
                    0.016
                )

        elseif Type == "Snow" then

            Part.Position +=
                Vector3.new(
                    math.sin(
                        Time * 1.2
                    ) * 0.008,

                    -0.112,

                    math.cos(
                        Time * 1.5
                    ) * 0.008
                )

        elseif Type == "Star" then

            Part.Position +=
                Vector3.new(
                    0,
                    -0.013,
                    0
                )

            local Pulse =
                0.5 +
                math.abs(
                    math.sin(
                        Time * 2
                    )
                ) *
                0.5

            Part.Transparency =
                1 - Pulse

        elseif Type == "Firefly" then

            Part.Position +=
                Vector3.new(
                    math.sin(
                        Time * 2.2
                    ) * 0.02,

                    math.cos(
                        Time * 1.8
                    ) * 0.02,

                    math.sin(
                        Time * 1.4
                    ) * 0.02
                )

            Part.Transparency =
                0.15 +
                math.abs(
                    math.sin(
                        Time * 3
                    )
                ) *
                0.6

        elseif Type == "Heart" then

            Part.Position +=
                Vector3.new(
                    math.sin(
                        Time * 1.5
                    ) * 0.01,

                    0.019,

                    math.cos(
                        Time * 1.2
                    ) * 0.01
                )

            Part.Transparency =
                0.2 +
                math.abs(
                    math.sin(
                        Time * 2
                    )
                ) *
                0.4
        end
    end
end

--========================================================--
-- CHARACTER ADDED
--========================================================--

LocalPlayer.CharacterAdded:Connect(
    function(NewCharacter)

        Character =
            NewCharacter

        task.wait(0.5)

        RefreshCharacter()

        table.clear(
            NoclipCache
        )

        ClearAura()
        ClearChinaHat()

        if CFG.ChinaHat then
            task.wait(0.2)
            CreateChinaHat()
        end

        if CFG.SakuraAura then
            CreateAura()
        end
    end
)

--========================================================--
-- MAIN LOOP
--========================================================--

local LastHatState = false
local LastHatColor = ""
local LastHatRadius = 0
local LastHatHeight = 0

local LastSky = ""

RunService.RenderStepped:Connect(
    function()

        RefreshCharacter()

        -- China Hat
        if CFG.ChinaHat ~=
                LastHatState

            or CFG.ChinaHatColorName ~=
                LastHatColor

            or CFG.ChinaHatRadius ~=
                LastHatRadius

            or CFG.ChinaHatHeight ~=
                LastHatHeight then

            CreateChinaHat()

            LastHatState =
                CFG.ChinaHat

            LastHatColor =
                CFG.ChinaHatColorName

            LastHatRadius =
                CFG.ChinaHatRadius

            LastHatHeight =
                CFG.ChinaHatHeight
        end

        -- Sky
        if CFG.Sky ~= LastSky then

            ApplySky(
                CFG.Sky
            )

            LastSky =
                CFG.Sky
        end

        UpdateFly()
        UpdateNoclip()
        UpdateMovement()

        UpdateParticles()
        UpdateAura()
        UpdateAurora()

        UpdateEffects()

        UpdateESP()
    end
)

--========================================================--
-- HEARTBEAT
--========================================================--

RunService.Heartbeat:Connect(
    function()

        if CFG.Chams then
            UpdateChams()
        else

            for Player in pairs(
                ChamsObjects
            ) do

                RemoveChams(
                    Player
                )
            end
        end

        -- Bunnyhop отдельно от RenderStepped
        DoBunnyhop()
    end
)

--========================================================--
-- INITIAL
--========================================================--

ApplySky(
    CFG.Sky
)

if CFG.SakuraAura then
    CreateAura()
end

if CFG.ChinaHat then

    task.delay(
        0.5,
        CreateChinaHat
    )
end

for _, Player in ipairs(
    Players:GetPlayers()
) do

    if Player ~= LocalPlayer then
        CreateESP(Player)
    end
end

--========================================================--
-- INSERT KEY
--========================================================--

UIS.InputBegan:Connect(
    function(Input, Processed)

        if Processed then
            return
        end

        if Input.KeyCode ==
            Enum.KeyCode.Insert then

            Main.Visible =
                not Main.Visible
        end
    end
)

--========================================================--
-- FINAL
--========================================================--

print(
    "======================================"
)

print(
    " MONOTON VISUALS V1.3"
)

print(
    " [nasok os-by @go8ai]"
)

print(
    " Bunnyhop: 1-100"
)

print(
    " Loaded successfully"
)

print(
    "======================================"
)
