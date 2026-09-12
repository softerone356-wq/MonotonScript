--========================================================--
-- MONOTON VISUALS V1.3
-- OLD MENU + NEW FEATURES
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
if not LP then return end

--========================================================--
-- CONFIG
--========================================================--

local DEFAULTS = {
    Smooth = false,
    BlurAmount = 50,

    Chams = false,
    ChamsColor = {255,185,215},

    ESP = false,
    ESPBox = true,
    ESPFill = false,
    ESPOutline = false,
    ESPHealth = false,
    ESPCorner = false,
    ESPSkeleton = false,
    ESPName = false,
    ESPDistance = false,
    ESPTeamCheck = false,
    ESPMaxDistance = 2000,

    SakuraLeaves = false,
    Snow = false,
    Stars = false,

    SakuraAura = false,
    SakuraAuraRadius = 3,
    SakuraAuraCount = 12,

    Night = false,
    NightDarkness = 35,

    JumpBoost = false,
    JumpPower = 50,

    AirJump = false,

    SpeedHack = false,
    Speed = 16,

    Noclip = false,

    Fly = false,
    FlySpeed = 60,

    ChinaHat = false,

    AnimationHack = false,
    AnimationID = "",
    AnimationSpeed = 1,

    Sky = "Default",

    Font = "Gotham",

    AccentName = "Pink",
    AccentColor = {255,185,215}
}

local CFG = {}

for k,v in pairs(DEFAULTS) do
    CFG[k] = v
end

--========================================================--
-- COLORS
--========================================================--

local BLACK = Color3.fromRGB(5,5,7)
local DARK = Color3.fromRGB(10,10,13)
local DARK2 = Color3.fromRGB(17,17,21)
local DARK3 = Color3.fromRGB(28,28,34)

local WHITE = Color3.fromRGB(245,245,248)
local GRAY = Color3.fromRGB(145,145,155)

local ACCENTS = {
    Pink = Color3.fromRGB(255,185,215),
    Purple = Color3.fromRGB(190,150,255),
    Blue = Color3.fromRGB(125,180,255),
    Cyan = Color3.fromRGB(100,235,235),
    Green = Color3.fromRGB(130,235,165),
    Red = Color3.fromRGB(255,110,125),
    Orange = Color3.fromRGB(255,175,100),
    White = Color3.fromRGB(245,245,245)
}

local FONTS = {
    Gotham = Enum.Font.Gotham,
    GothamBold = Enum.Font.GothamBold,
    GothamBlack = Enum.Font.GothamBlack,
    SourceSans = Enum.Font.SourceSans,
    SourceSansBold = Enum.Font.SourceSansBold,
    Code = Enum.Font.Code,
    SciFi = Enum.Font.SciFi,
    Arcade = Enum.Font.Arcade,
    Fantasy = Enum.Font.Fantasy
}

--========================================================--
-- SAFE
--========================================================--

local function Safe(fn,...)
    return pcall(fn,...)
end

local function RGBToColor(tbl)
    if type(tbl) ~= "table" then
        return Color3.fromRGB(255,185,215)
    end

    return Color3.fromRGB(
        tonumber(tbl[1]) or 255,
        tonumber(tbl[2]) or 185,
        tonumber(tbl[3]) or 215
    )
end

local function ColorToRGB(c)
    return {
        math.floor(c.R * 255),
        math.floor(c.G * 255),
        math.floor(c.B * 255)
    }
end

local function GetAccent()
    return RGBToColor(CFG.AccentColor)
end

local function SetAccent(color)
    CFG.AccentColor = ColorToRGB(color)
end

--========================================================--
-- FILE SYSTEM
--========================================================--

local HAS_FILE =
    type(readfile) == "function"
    and type(writefile) == "function"
    and type(isfile) == "function"

local HAS_FOLDER =
    type(makefolder) == "function"

local BASE_FOLDER = "MonotonVisuals"
local CONFIG_FOLDER = BASE_FOLDER .. "/Configs"

if HAS_FOLDER then
    pcall(function()
        makefolder(BASE_FOLDER)
    end)

    pcall(function()
        makefolder(CONFIG_FOLDER)
    end)
end

local function FileName(name)
    return CONFIG_FOLDER .. "/" .. name .. ".json"
end

local function SaveConfig(name)
    if not HAS_FILE then
        return false
    end

    local ok,data = pcall(function()
        return HttpService:JSONEncode(CFG)
    end)

    if not ok then
        return false
    end

    return pcall(function()
        writefile(FileName(name),data)
    end)
end

local function LoadConfig(name)
    if not HAS_FILE then
        return false
    end

    if not isfile(FileName(name)) then
        return false
    end

    local ok,raw = pcall(function()
        return readfile(FileName(name))
    end)

    if not ok then
        return false
    end

    local ok2,data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)

    if not ok2 or type(data) ~= "table" then
        return false
    end

    for key,value in pairs(DEFAULTS) do
        CFG[key] = data[key] ~= nil and data[key] or value
    end

    return true
end

local function DeleteConfig(name)
    if not HAS_FILE then
        return false
    end

    if not isfile(FileName(name)) then
        return false
    end

    return pcall(function()
        delfile(FileName(name))
    end)
end

--========================================================--
-- GUI PARENT
--========================================================--

local function GetParent()
    local p

    pcall(function()
        if type(gethui) == "function" then
            p = gethui()
        end
    end)

    if p then
        return p
    end

    pcall(function()
        p = game:GetService("CoreGui")
    end)

    if p then
        return p
    end

    return LP:WaitForChild("PlayerGui")
end

local PARENT = GetParent()

pcall(function()
    local old = PARENT:FindFirstChild("MonotonVisuals")
    if old then
        old:Destroy()
    end
end)

--========================================================--
-- INSTANCE HELPERS
--========================================================--

local function New(class,props,parent)
    local obj = Instance.new(class)

    for k,v in pairs(props or {}) do
        pcall(function()
            obj[k] = v
        end)
    end

    if parent then
        obj.Parent = parent
    end

    return obj
end

local function Corner(obj,radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius)
    c.Parent = obj
end

local function AddStroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = GetAccent()
    s.Transparency = .72
    s.Thickness = 1
    s.Parent = obj
    return s
end

local function Tween(obj,time,props)
    pcall(function()
        TweenService:Create(
            obj,
            TweenInfo.new(
                time or .35,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            props
        ):Play()
    end)
end

--========================================================--
-- SCREEN GUI
--========================================================--

local GUI = New(
    "ScreenGui",
    {
        Name = "MonotonVisuals",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 999999,
        Enabled = true
    },
    PARENT
)

--========================================================--
-- LICENSE
--========================================================--

local PERMANENT_KEY = "t.me/monotonvisuals"
local KEY_FILE = BASE_FOLDER .. "/License.txt"
local HasLicense = false

if HAS_FILE then
    pcall(function()
        if isfile(KEY_FILE) then
            HasLicense = readfile(KEY_FILE) == PERMANENT_KEY
        end
    end)
end

--========================================================--
-- KEY WINDOW
--========================================================--

local KeyFrame = New(
    "Frame",
    {
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),
        Size = UDim2.fromOffset(400,245),
        BackgroundColor3 = DARK,
        BorderSizePixel = 0,
        Visible = not HasLicense,
        ZIndex = 5000
    },
    GUI
)

Corner(KeyFrame,16)
AddStroke(KeyFrame)

New(
    "TextLabel",
    {
        Position = UDim2.fromOffset(25,20),
        Size = UDim2.new(1,-50,0,30),
        BackgroundTransparency = 1,
        Text = "MONOTON VISUALS",
        TextColor3 = WHITE,
        TextSize = 21,
        Font = FONTS.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5001
    },
    KeyFrame
)

New(
    "TextLabel",
    {
        Position = UDim2.fromOffset(25,52),
        Size = UDim2.new(1,-50,0,22),
        BackgroundTransparency = 1,
        Text = "Permanent activation",
        TextColor3 = GRAY,
        TextSize = 12,
        Font = FONTS.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5001
    },
    KeyFrame
)

local KeyBox = New(
    "TextBox",
    {
        Position = UDim2.fromOffset(25,88),
        Size = UDim2.new(1,-50,0,42),
        BackgroundColor3 = DARK2,
        BorderSizePixel = 0,
        PlaceholderText = "Enter permanent key",
        PlaceholderColor3 = GRAY,
        Text = "",
        TextColor3 = WHITE,
        TextSize = 13,
        Font = FONTS.Gotham,
        ClearTextOnFocus = false,
        ZIndex = 5002
    },
    KeyFrame
)

Corner(KeyBox,9)
AddStroke(KeyBox)

local KeyButton = New(
    "TextButton",
    {
        Position = UDim2.fromOffset(25,142),
        Size = UDim2.new(1,-50,0,40),
        BackgroundColor3 = GetAccent(),
        BorderSizePixel = 0,
        Text = "ACTIVATE",
        TextColor3 = BLACK,
        TextSize = 13,
        Font = FONTS.GothamBold,
        AutoButtonColor = false,
        ZIndex = 5002
    },
    KeyFrame
)

Corner(KeyButton,9)

local KeyStatus = New(
    "TextLabel",
    {
        Position = UDim2.fromOffset(25,192),
        Size = UDim2.new(1,-50,0,20),
        BackgroundTransparency = 1,
        Text = "Permanent key required",
        TextColor3 = GRAY,
        TextSize = 11,
        Font = FONTS.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5002
    },
    KeyFrame
)

--========================================================--
-- MAIN OLD MENU
--========================================================--

local Main = New(
    "Frame",
    {
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),
        Size = UDim2.fromOffset(530,345),
        BackgroundColor3 = DARK,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100
    },
    GUI
)

Corner(Main,15)

local MainStroke = AddStroke(Main)

New(
    "TextLabel",
    {
        AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.68,.60),
        Size = UDim2.new(.8,0,0,90),
        BackgroundTransparency = 1,
        Text = "MonotonVisuals",
        TextColor3 = GetAccent(),
        TextTransparency = .94,
        TextSize = 43,
        Font = FONTS.GothamBlack,
        Rotation = -8,
        ZIndex = 100
    },
    Main
)

local Header = New(
    "TextLabel",
    {
        Position = UDim2.fromOffset(18,13),
        Size = UDim2.fromOffset(300,28),
        BackgroundTransparency = 1,
        Text = "MONOTON",
        TextColor3 = WHITE,
        TextSize = 21,
        Font = FONTS.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 110
    },
    Main
)

local VersionLabel = New(
    "TextLabel",
    {
        Position = UDim2.fromOffset(19,40),
        Size = UDim2.fromOffset(180,18),
        BackgroundTransparency = 1,
        Text = "VISUALS V1.3",
        TextColor3 = GetAccent(),
        TextSize = 10,
        Font = FONTS.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 110
    },
    Main
)

local Close = New(
    "TextButton",
    {
        Position = UDim2.new(1,-43,0,14),
        Size = UDim2.fromOffset(30,30),
        BackgroundColor3 = DARK2,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = GRAY,
        TextSize = 20,
        Font = FONTS.Gotham,
        AutoButtonColor = false,
        ZIndex = 110
    },
    Main
)

Corner(Close,8)

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar = New(
    "Frame",
    {
        Position = UDim2.fromOffset(12,72),
        Size = UDim2.fromOffset(135,258),
        BackgroundColor3 = BLACK,
        BorderSizePixel = 0,
        ZIndex = 110
    },
    Main
)

Corner(Sidebar,11)

local Tabs = {
    "Home",
    "Visuals",
    "Rage",
    "Models",
    "Settings",
    "Configs",
    "Info"
}

local TabButtons = {}

for i,name in ipairs(Tabs) do
    local button = New(
        "TextButton",
        {
            Position = UDim2.fromOffset(7,7+(i-1)*34),
            Size = UDim2.new(1,-14,0,29),
            BackgroundColor3 = DARK2,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = GRAY,
            TextSize = 12,
            Font = FONTS.Gotham,
            AutoButtonColor = false,
            ZIndex = 111
        },
        Sidebar
    )

    Corner(button,7)
    TabButtons[name] = button
end

--========================================================--
-- CONTENT
--========================================================--

local Content = New(
    "Frame",
    {
        Position = UDim2.fromOffset(157,72),
        Size = UDim2.new(1,-169,1,-84),
        BackgroundColor3 = Color3.fromRGB(16,16,19),
        BorderSizePixel = 0,
        ZIndex = 110
    },
    Main
)

Corner(Content,11)

local Holder = New(
    "Frame",
    {
        Position = UDim2.fromOffset(10,10),
        Size = UDim2.new(1,-20,1,-20),
        BackgroundTransparency = 1,
        ZIndex = 111
    },
    Content
)

--========================================================--
-- PAGES
--========================================================--

local Pages = {}

local function Page(name)
    local p = New(
        "ScrollingFrame",
        {
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = GetAccent(),
            CanvasSize = UDim2.new(0,0,0,0),
            Visible = false,
            ZIndex = 112
        },
        Holder
    )

    local layout = New(
        "UIListLayout",
        {
            Padding = UDim.new(0,7),
            SortOrder = Enum.SortOrder.LayoutOrder
        },
        p
    )

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(
            0,0,0,
            layout.AbsoluteContentSize.Y+10
        )
    end)

    Pages[name] = p
    return p
end

local Home = Page("Home")
local Visuals = Page("Visuals")
local Rage = Page("Rage")
local Models = Page("Models")
local Settings = Page("Settings")
local Configs = Page("Configs")
local Info = Page("Info")

--========================================================--
-- UI HELPERS
--========================================================--

local function Label(parent,text,height)
    return New(
        "TextLabel",
        {
            Size = UDim2.new(1,-4,0,height or 27),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = WHITE,
            TextSize = 12,
            Font = FONTS.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 113
        },
        parent
    )
end

local function Section(parent,text)
    local l = Label(parent,text,25)
    l.TextColor3 = GetAccent()
    l.TextSize = 11
    l.Font = FONTS.GothamBold
    return l
end

local function Toggle(parent,text,default,callback)
    local frame = New(
        "Frame",
        {
            Size = UDim2.new(1,-4,0,39),
            BackgroundColor3 = DARK2,
            BorderSizePixel = 0,
            ZIndex = 113
        },
        parent
    )

    Corner(frame,8)

    New(
        "TextLabel",
        {
            Position = UDim2.fromOffset(12,0),
            Size = UDim2.new(1,-65,1,0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = WHITE,
            TextSize = 12,
            Font = FONTS.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 114
        },
        frame
    )

    local sw = New(
        "TextButton",
        {
            Position = UDim2.new(1,-48,.5,-11),
            Size = UDim2.fromOffset(38,22),
            BackgroundColor3 = default and GetAccent() or DARK3,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 114
        },
        frame
    )

    Corner(sw,12)

    local state = default

    sw.Activated:Connect(function()
        state = not state

        Tween(sw,.2,{
            BackgroundColor3 = state and GetAccent() or DARK3
        })

        pcall(callback,state)
    end)

    return sw
end

local function Slider(parent,text,min,max,default,callback)
    local frame = New(
        "Frame",
        {
            Size = UDim2.new(1,-4,0,57),
            BackgroundColor3 = DARK2,
            BorderSizePixel = 0,
            ZIndex = 113
        },
        parent
    )

    Corner(frame,8)

    New(
        "TextLabel",
        {
            Position = UDim2.fromOffset(12,5),
            Size = UDim2.new(1,-65,0,20),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = WHITE,
            TextSize = 11,
            Font = FONTS.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 114
        },
        frame
    )

    local val = New(
        "TextLabel",
        {
            Position = UDim2.new(1,-55,0,5),
            Size = UDim2.fromOffset(45,20),
            BackgroundTransparency = 1,
            Text = tostring(default),
            TextColor3 = GetAccent(),
            TextSize = 11,
            Font = FONTS.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 114
        },
        frame
    )

    local bar = New(
        "Frame",
        {
            Position = UDim2.fromOffset(12,35),
            Size = UDim2.new(1,-24,0,5),
            BackgroundColor3 = DARK3,
            BorderSizePixel = 0,
            ZIndex = 114
        },
        frame
    )

    Corner(bar,5)

    local pct = math.clamp((default-min)/(max-min),0,1)

    local fill = New(
        "Frame",
        {
            Size = UDim2.new(pct,0,1,0),
            BackgroundColor3 = GetAccent(),
            BorderSizePixel = 0,
            ZIndex = 115
        },
        bar
    )

    Corner(fill,5)

    local dragging = false

    local function Set(v)
        v = math.clamp(v,min,max)

        local p = (v-min)/(max-min)

        fill.Size = UDim2.new(p,0,1,0)
        val.Text = tostring(math.floor(v))

        pcall(callback,v)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true

            local x = math.clamp(
                input.Position.X-bar.AbsolutePosition.X,
                0,
                bar.AbsoluteSize.X
            )

            Set(min+(max-min)*(x/bar.AbsoluteSize.X))
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            local x = math.clamp(
                input.Position.X-bar.AbsolutePosition.X,
                0,
                bar.AbsoluteSize.X
            )

            Set(min+(max-min)*(x/bar.AbsoluteSize.X))
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function Button(parent,text,callback)
    local b = New(
        "TextButton",
        {
            Size = UDim2.new(1,-4,0,39),
            BackgroundColor3 = DARK2,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = WHITE,
            TextSize = 12,
            Font = FONTS.Gotham,
            AutoButtonColor = false,
            ZIndex = 113
        },
        parent
    )

    Corner(b,8)

    b.Activated:Connect(function()
        pcall(callback)
    end)

    return b
end

local function TextBox(parent,placeholder,default)
    local box = New(
        "TextBox",
        {
            Size = UDim2.new(1,-4,0,40),
            BackgroundColor3 = DARK2,
            BorderSizePixel = 0,
            PlaceholderText = placeholder,
            PlaceholderColor3 = GRAY,
            Text = default or "",
            TextColor3 = WHITE,
            TextSize = 12,
            Font = FONTS.Gotham,
            ClearTextOnFocus = false,
            ZIndex = 113
        },
        parent
    )

    Corner(box,8)
    return box
end

--========================================================--
-- HOME
--========================================================--

Section(Home,"MONOTON VISUALS")

Label(Home,"Black / white / custom accent interface",25)
Label(Home,"Permanent license enabled",25)
Label(Home,"V1.3 • Visual Effects + Movement",25)
Label(Home,"ESP / Fly / Noclip / China Hat / Animation",25)

--========================================================--
-- VISUALS
--========================================================--

Section(Visuals,"MOTION")

Toggle(
    Visuals,
    "Motion Blur",
    CFG.Smooth,
    function(v)
        CFG.Smooth = v
    end
)

Slider(
    Visuals,
    "Blur Amount",
    0,
    100,
    CFG.BlurAmount,
    function(v)
        CFG.BlurAmount = v
    end
)

Section(Visuals,"PLAYER")

Toggle(
    Visuals,
    "Chams Fill",
    CFG.Chams,
    function(v)
        CFG.Chams = v
    end
)

Toggle(
    Visuals,
    "ESP",
    CFG.ESP,
    function(v)
        CFG.ESP = v
    end
)

Toggle(
    Visuals,
    "Box",
    CFG.ESPBox,
    function(v)
        CFG.ESPBox = v
    end
)

Toggle(
    Visuals,
    "Fill Box",
    CFG.ESPFill,
    function(v)
        CFG.ESPFill = v
    end
)

Toggle(
    Visuals,
    "Outline Box",
    CFG.ESPOutline,
    function(v)
        CFG.ESPOutline = v
    end
)

Toggle(
    Visuals,
    "Health",
    CFG.ESPHealth,
    function(v)
        CFG.ESPHealth = v
    end
)

Toggle(
    Visuals,
    "Corner Box",
    CFG.ESPCorner,
    function(v)
        CFG.ESPCorner = v
    end
)

Toggle(
    Visuals,
    "Skeleton",
    CFG.ESPSkeleton,
    function(v)
        CFG.ESPSkeleton = v
    end
)

Toggle(
    Visuals,
    "Player Name",
    CFG.ESPName,
    function(v)
        CFG.ESPName = v
    end
)

Toggle(
    Visuals,
    "Distance",
    CFG.ESPDistance,
    function(v)
        CFG.ESPDistance = v
    end
)

Toggle(
    Visuals,
    "Team Check",
    CFG.ESPTeamCheck,
    function(v)
        CFG.ESPTeamCheck = v
    end
)

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

Section(Visuals,"WORLD EFFECTS")

Toggle(
    Visuals,
    "Sakura Leaves",
    CFG.SakuraLeaves,
    function(v)
        CFG.SakuraLeaves = v
    end
)

Toggle(
    Visuals,
    "Snow",
    CFG.Snow,
    function(v)
        CFG.Snow = v
    end
)

Toggle(
    Visuals,
    "Stars",
    CFG.Stars,
    function(v)
        CFG.Stars = v
    end
)

Toggle(
    Visuals,
    "Sakura Aura",
    CFG.SakuraAura,
    function(v)
        CFG.SakuraAura = v
    end
)

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

Section(Visuals,"SKY")

Button(Visuals,"Galaxy",function()
    CFG.Sky = "Galaxy"
end)

Button(Visuals,"Black Hole",function()
    CFG.Sky = "Black Hole"
end)

Button(Visuals,"Black Sky",function()
    CFG.Sky = "Black"
end)

Button(Visuals,"Northern Green Lights",function()
    CFG.Sky = "Northern"
end)

Button(Visuals,"Default Sky",function()
    CFG.Sky = "Default"
end)

Section(Visuals,"NIGHT")

Toggle(
    Visuals,
    "Night Mode",
    CFG.Night,
    function(v)
        CFG.Night = v
    end
)

Slider(
    Visuals,
    "Darkness",
    0,
    100,
    CFG.NightDarkness,
    function(v)
        CFG.NightDarkness = v
    end
)

--========================================================--
-- RAGE
--========================================================--

Section(Rage,"MOVEMENT")

Toggle(
    Rage,
    "Jump Boost",
    CFG.JumpBoost,
    function(v)
        CFG.JumpBoost = v
    end
)

Slider(
    Rage,
    "Jump Power",
    50,
    150,
    CFG.JumpPower,
    function(v)
        CFG.JumpPower = v
    end
)

Toggle(
    Rage,
    "Air Jump",
    CFG.AirJump,
    function(v)
        CFG.AirJump = v
    end
)

Toggle(
    Rage,
    "Speed Hack",
    CFG.SpeedHack,
    function(v)
        CFG.SpeedHack = v
    end
)

Slider(
    Rage,
    "Speed",
    16,
    150,
    CFG.Speed,
    function(v)
        CFG.Speed = v
    end
)

Toggle(
    Rage,
    "Noclip",
    CFG.Noclip,
    function(v)
        CFG.Noclip = v
    end
)

Section(Rage,"FLY")

Label(
    Rage,
    "PC: WASD • Mobile: Roblox joystick • Camera controls height",
    32
)

Toggle(
    Rage,
    "Fly",
    CFG.Fly,
    function(v)
        CFG.Fly = v
    end
)

Slider(
    Rage,
    "Fly Speed",
    10,
    200,
    CFG.FlySpeed,
    function(v)
        CFG.FlySpeed = v
    end
)

Label(
    Rage,
    "No ▲ / ▼ / OFF control panel. Look up/down to change height.",
    30
)

--========================================================--
-- MODELS
--========================================================--

Section(Models,"WINTER MODELS")

Label(
    Models,
    "3D accessories",
    24
)

local ModelFolder = New(
    "Folder",
    {
        Name = "MonotonModels"
    },
    workspace
)

local SnowHatModel = nil
local ChinaHatModel = nil

local function RemoveSnowHat()
    if SnowHatModel then
        pcall(function()
            SnowHatModel:Destroy()
        end)
        SnowHatModel = nil
    end
end

local function CreatePart(model,name,size,color,material,cf)
    local p = Instance.new("Part")

    p.Name = name
    p.Size = size
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = false
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Massless = true
    p.CFrame = cf
    p.Parent = model

    return p
end

local function WeldToHead(part,head)
    local w = Instance.new("WeldConstraint")
    w.Part0 = part
    w.Part1 = head
    w.Parent = part
end

local function CreateSnowHat()
    RemoveSnowHat()

    local char = LP.Character
    local head = char and char:FindFirstChild("Head")

    if not head then return end

    local model = Instance.new("Model")
    model.Name = "MonotonSnowHat"
    model.Parent = ModelFolder

    -- smaller than V1.1
    local base = CreatePart(
        model,
        "SnowHatBase",
        Vector3.new(1.35,.42,1.35),
        Color3.fromRGB(235,235,240),
        Enum.Material.Fabric,
        head.CFrame*CFrame.new(0,.55,0)
    )

    WeldToHead(base,head)

    local brim = CreatePart(
        model,
        "SnowHatBrim",
        Vector3.new(1.75,.10,1.75),
        Color3.fromRGB(220,220,225),
        Enum.Material.Fabric,
        head.CFrame*CFrame.new(0,.38,0)
    )

    WeldToHead(brim,head)

    local pom = CreatePart(
        model,
        "SnowPom",
        Vector3.new(.32,.32,.32),
        Color3.fromRGB(250,250,255),
        Enum.Material.Fabric,
        head.CFrame*CFrame.new(0,1.05,0)
    )

    pom.Shape = Enum.PartType.Ball
    WeldToHead(pom,head)

    SnowHatModel = model
end

Button(
    Models,
    "Snow Hat",
    function()
        if SnowHatModel then
            RemoveSnowHat()
        else
            CreateSnowHat()
        end
    end
)

Label(
    Models,
    "Reduced winter hat • attached to head",
    28
)

--========================================================--
-- CHINA HAT
--========================================================--

Section(
    Models,
    "CHINA HAT"
)

Label(
    Models,
    "Wide conical hat • photo style",
    28
)

local function RemoveChinaHat()
    if ChinaHatModel then
        pcall(function()
            ChinaHatModel:Destroy()
        end)
        ChinaHatModel = nil
    end
end

local function CreateChinaHat()
    RemoveChinaHat()

    local char = LP.Character
    local head = char and char:FindFirstChild("Head")

    if not head then return end

    local model = Instance.new("Model")
    model.Name = "MonotonChinaHat"
    model.Parent = ModelFolder

    local hatColor = GetAccent()

    -- wide flat brim
    local brim = CreatePart(
        model,
        "ChinaHatBrim",
        Vector3.new(2.75,.12,2.75),
        hatColor,
        Enum.Material.SmoothPlastic,
        head.CFrame*CFrame.new(0,.53,0)
    )

    brim.Shape = Enum.PartType.Cylinder
    WeldToHead(brim,head)

    -- cone made from stacked thin cylinders
    local levels = 10

    for i = 1,levels do
        local t = (i-1)/(levels-1)

        local diameter = 2.35-(2.05*t)
        local y = .59+(1.42*t)

        local ring = CreatePart(
            model,
            "ChinaHatCone_"..i,
            Vector3.new(
                diameter,
                .14,
                diameter
            ),
            hatColor,
            Enum.Material.SmoothPlastic,
            head.CFrame*CFrame.new(0,y,0)
        )

        ring.Shape = Enum.PartType.Cylinder
        WeldToHead(ring,head)
    end

    -- small top
    local top = CreatePart(
        model,
        "ChinaHatTip",
        Vector3.new(.22,.18,.22),
        hatColor,
        Enum.Material.SmoothPlastic,
        head.CFrame*CFrame.new(0,2.02,0)
    )

    top.Shape = Enum.PartType.Cylinder
    WeldToHead(top,head)

    -- thin decorative band
    local band = CreatePart(
        model,
        "ChinaHatBand",
        Vector3.new(1.12,.08,1.12),
        Color3.fromRGB(255,205,70),
        Enum.Material.SmoothPlastic,
        head.CFrame*CFrame.new(0,.91,0)
    )

    band.Shape = Enum.PartType.Cylinder
    WeldToHead(band,head)

    ChinaHatModel = model
end

Button(
    Models,
    "China Hat",
    function()
        if ChinaHatModel then
            RemoveChinaHat()
        else
            CreateChinaHat()
        end
    end
)

--========================================================--
-- ANIMATION
--========================================================--

Section(
    Models,
    "ANIMATION HACK"
)

Label(
    Models,
    "Enter any Roblox animation asset ID",
    25
)

local AnimationBox = TextBox(
    Models,
    "Animation ID / Catalog ID",
    CFG.AnimationID
)

local CurrentAnimationTrack = nil

local function StopAnimation()
    if CurrentAnimationTrack then
        pcall(function()
            CurrentAnimationTrack:Stop(.15)
            CurrentAnimationTrack:Destroy()
        end)
        CurrentAnimationTrack = nil
    end
end

local function GetAnimator()
    local char = LP.Character
    if not char then return nil end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end

    local animator = hum:FindFirstChildOfClass("Animator")

    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end

    return animator
end

local function PlayAnimation(id)
    id = tostring(id or ""):gsub("%D","")

    if id == "" then
        return false
    end

    local animator = GetAnimator()
    if not animator then
        return false
    end

    StopAnimation()

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://"..id

    local ok,track = pcall(function()
        return animator:LoadAnimation(animation)
    end)

    animation:Destroy()

    if not ok or not track then
        return false
    end

    track.Looped = true
    track.Priority = Enum.AnimationPriority.Action
    track:Play(.15,1,CFG.AnimationSpeed)

    CurrentAnimationTrack = track
    CFG.AnimationID = id
    CFG.AnimationHack = true

    return true
end

Toggle(
    Models,
    "Animation Hack",
    CFG.AnimationHack,
    function(v)
        CFG.AnimationHack = v

        if not v then
            StopAnimation()
        elseif AnimationBox.Text ~= "" then
            PlayAnimation(AnimationBox.Text)
        end
    end
)

Button(
    Models,
    "Play Catalog Animation",
    function()
        PlayAnimation(AnimationBox.Text)
    end
)

Slider(
    Models,
    "Animation Speed",
    1,
    30,
    CFG.AnimationSpeed,
    function(v)
        CFG.AnimationSpeed = v

        if CurrentAnimationTrack then
            pcall(function()
                CurrentAnimationTrack:AdjustSpeed(v)
            end)
        end
    end
)

Section(
    Models,
    "ANIMATION PRESETS"
)

local AnimationPresets = {
    ["R15 Idle"] = "507766388",
    ["R15 Walk"] = "507777826",
    ["R15 Run"] = "507767714",
    ["R15 Jump"] = "507765000",
    ["R15 Fall"] = "507767968",
    ["R15 Climb"] = "507765644",
    ["R15 Swim"] = "507784897"
}

for name,id in pairs(AnimationPresets) do
    Button(
        Models,
        name,
        function()
            AnimationBox.Text = id
            PlayAnimation(id)
        end
    )
end

--========================================================--
-- SETTINGS
--========================================================--

Section(Settings,"FONT")

local FontStatus = Label(
    Settings,
    "Current: "..CFG.Font,
    27
)

for name,_ in pairs(FONTS) do
    Button(
        Settings,
        name,
        function()
            CFG.Font = name
            FontStatus.Text = "Current: "..name
        end
    )
end

Section(Settings,"ACCENT PALETTE")

local AccentStatus = Label(
    Settings,
    "Current: "..CFG.AccentName,
    27
)

for name,color in pairs(ACCENTS) do
    Button(
        Settings,
        name,
        function()
            CFG.AccentName = name
            SetAccent(color)
            AccentStatus.Text = "Current: "..name
        end
    )
end

Section(Settings,"CUSTOM RGB")

Slider(
    Settings,
    "Accent Red",
    0,
    255,
    CFG.AccentColor[1],
    function(v)
        CFG.AccentColor[1] = math.floor(v)
    end
)

Slider(
    Settings,
    "Accent Green",
    0,
    255,
    CFG.AccentColor[2],
    function(v)
        CFG.AccentColor[2] = math.floor(v)
    end
)

Slider(
    Settings,
    "Accent Blue",
    0,
    255,
    CFG.AccentColor[3],
    function(v)
        CFG.AccentColor[3] = math.floor(v)
    end
)

--========================================================--
-- CONFIGS
--========================================================--

Section(Configs,"CONFIG MANAGER")

Label(
    Configs,
    HAS_FILE and
    "File system detected" or
    "Executor file system unavailable",
    27
)

local ConfigName = TextBox(
    Configs,
    "Config name",
    ""
)

Button(
    Configs,
    "Save Config",
    function()
        local name = ConfigName.Text
        if name ~= "" then
            if SaveConfig(name) then
                ConfigName.Text = ""
            end
        end
    end
)

Button(
    Configs,
    "Load Config",
    function()
        local name = ConfigName.Text
        if name ~= "" then
            LoadConfig(name)
        end
    end
)

Button(
    Configs,
    "Delete Config",
    function()
        local name = ConfigName.Text
        if name ~= "" then
            DeleteConfig(name)
        end
    end
)

Button(
    Configs,
    "Save Current As Default",
    function()
        SaveConfig("Default")
    end
)

Button(
    Configs,
    "Load Default",
    function()
        LoadConfig("Default")
    end
)

--========================================================--
-- INFO
--========================================================--

Section(Info,"MONOTON VISUALS")

Label(Info,"MonotonVisuals v1.3",26)
Label(Info,"Permanent license system",26)
Label(Info,"3D Sakura / Snow / Stars",26)
Label(Info,"ESP Box / Fill / Outline / Health",26)
Label(Info,"Corner / Skeleton / Name / Distance",26)
Label(Info,"Noclip + Fly",26)
Label(Info,"China Hat",26)
Label(Info,"Catalog Animation Player",26)

--========================================================--
-- M BUTTON
--========================================================--

local M = New(
    "TextButton",
    {
        Position = UDim2.new(0,22,.5,-29),
        Size = UDim2.fromOffset(58,58),
        BackgroundColor3 = BLACK,
        BorderSizePixel = 0,
        Text = "M",
        TextColor3 = GetAccent(),
        TextSize = 27,
        Font = FONTS.GothamBold,
        AutoButtonColor = false,
        Active = true,
        Visible = HasLicense,
        ZIndex = 3000
    },
    GUI
)

Corner(M,17)

local MStroke = AddStroke(M)

--========================================================--
-- PAGE SWITCH
--========================================================--

local function ShowPage(name)
    for pageName,page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for tabName,button in pairs(TabButtons) do
        if tabName == name then
            button.BackgroundColor3 = Color3.fromRGB(40,28,35)
            button.TextColor3 = GetAccent()
        else
            button.BackgroundColor3 = DARK2
            button.TextColor3 = GRAY
        end
    end
end

for name,button in pairs(TabButtons) do
    button.Activated:Connect(function()
        ShowPage(name)
    end)
end

ShowPage("Home")

--========================================================--
-- MENU
--========================================================--

local function OpenMenu()
    Main.Visible = true

    Main.Size = UDim2.fromOffset(500,325)

    Tween(
        Main,
        .4,
        {
            Size = UDim2.fromOffset(530,345)
        }
    )
end

local function CloseMenu()
    Main.Visible = false
end

M.Activated:Connect(function()
    if Main.Visible then
        CloseMenu()
    else
        OpenMenu()
    end
end)

Close.Activated:Connect(CloseMenu)

--========================================================--
-- DRAG M
--========================================================--

local dragging = false
local dragStart
local startPos

M.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = M.Position
    end
end)

M.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position-dragStart

        M.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset+delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset+delta.Y
        )
    end
end)

--========================================================--
-- LICENSE ACTIVATION
--========================================================--

local function ActivateLicense()
    local value = tostring(KeyBox.Text or "")

    value = value:gsub("^%s+",""):gsub("%s+$","")

    if value ~= PERMANENT_KEY then
        KeyStatus.Text = "Invalid key"
        KeyStatus.TextColor3 =
            Color3.fromRGB(255,100,120)
        return
    end

    HasLicense = true

    if HAS_FILE then
        pcall(function()
            writefile(KEY_FILE,PERMANENT_KEY)
        end)
    end

    KeyStatus.Text =
        "Permanent activation successful"

    KeyStatus.TextColor3 = GetAccent()

    task.wait(.3)

    KeyFrame.Visible = false
    M.Visible = true

    OpenMenu()
end

KeyButton.Activated:Connect(ActivateLicense)

KeyBox.FocusLost:Connect(function(enter)
    if enter then
        ActivateLicense()
    end
end)

--========================================================--
-- WORLD FX
--========================================================--

local WorldFX = workspace:FindFirstChild("MonotonWorldFX")

if WorldFX then
    WorldFX:Destroy()
end

WorldFX = Instance.new("Folder")
WorldFX.Name = "MonotonWorldFX"
WorldFX.Parent = workspace

local WorldParticles = {}
local ParticlePositions = {}

local function ClearWorldParticles()
    for _,obj in ipairs(WorldParticles) do
        pcall(function()
            obj:Destroy()
        end)
        ParticlePositions[obj] = nil
    end

    table.clear(WorldParticles)
end

local function CreatePetal()
    local p = Instance.new("Part")

    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Material = Enum.Material.SmoothPlastic
    p.Color = GetAccent()
    p.Size = Vector3.new(.25,.07,.45)
    p.Parent = WorldFX

    p:SetAttribute("Type","Sakura")
    p:SetAttribute("Offset",math.random())

    table.insert(WorldParticles,p)
end

local function CreateSnowflake()
    local model = Instance.new("Model")
    model.Name = "Snowflake"
    model.Parent = WorldFX

    local center = Instance.new("Part")
    center.Anchored = true
    center.CanCollide = false
    center.CanTouch = false
    center.CanQuery = false
    center.Transparency = 1
    center.Size = Vector3.new(.1,.1,.1)
    center.Parent = model

    for i=1,6 do
        local arm = Instance.new("Part")

        arm.Anchored = true
        arm.CanCollide = false
        arm.CanTouch = false
        arm.CanQuery = false

        arm.Material = Enum.Material.Neon
        arm.Color = WHITE
        arm.Size = Vector3.new(.06,.06,.65)
        arm.Parent = model

        arm:SetAttribute("Arm",i)
    end

    model.PrimaryPart = center
    model:SetAttribute("Type","Snow")
    model:SetAttribute("Offset",math.random())

    table.insert(WorldParticles,model)
end

local function CreateStar()
    local model = Instance.new("Model")
    model.Name = "Star"
    model.Parent = WorldFX

    local center = Instance.new("Part")

    center.Anchored = true
    center.CanCollide = false
    center.CanTouch = false
    center.CanQuery = false
    center.Transparency = 1
    center.Size = Vector3.new(.1,.1,.1)
    center.Parent = model

    for i=1,4 do
        local arm = Instance.new("Part")

        arm.Anchored = true
        arm.CanCollide = false
        arm.CanTouch = false
        arm.CanQuery = false

        arm.Material = Enum.Material.Neon
        arm.Color = WHITE
        arm.Size = Vector3.new(.035,.035,.55)
        arm.Parent = model

        arm:SetAttribute("Arm",i)
    end

    model.PrimaryPart = center
    model:SetAttribute("Type","Stars")
    model:SetAttribute("Offset",math.random())

    table.insert(WorldParticles,model)
end

local LastParticleMode = ""

local function GetParticleMode()
    if CFG.Snow then
        return "Snow"
    end

    if CFG.Stars then
        return "Stars"
    end

    if CFG.SakuraLeaves then
        return "Sakura"
    end

    return ""
end

local function RandomWorldPosition()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root then
        return Vector3.zero
    end

    -- FIX: much lower than V1.1
    return root.Position + Vector3.new(
        math.random(-40,40),
        math.random(7,18),
        math.random(-40,40)
    )
end

local function RebuildWorldParticles()
    local mode = GetParticleMode()

    if mode == LastParticleMode then
        return
    end

    LastParticleMode = mode

    ClearWorldParticles()

    if mode == "" then
        return
    end

    for i=1,34 do
        if mode == "Snow" then
            CreateSnowflake()
        elseif mode == "Stars" then
            CreateStar()
        elseif mode == "Sakura" then
            CreatePetal()
        end
    end

    for _,obj in ipairs(WorldParticles) do
        ParticlePositions[obj] = RandomWorldPosition()
    end
end

local function UpdateWorldParticles(dt)
    RebuildWorldParticles()

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local now = os.clock()

    for _,obj in ipairs(WorldParticles) do
        if not obj.Parent then
            continue
        end

        local pos = ParticlePositions[obj]

        if not pos then
            pos = RandomWorldPosition()
        end

        local offset = obj:GetAttribute("Offset") or 0
        local mode = obj:GetAttribute("Type")

        if mode == "Sakura" then

            pos += Vector3.new(
                math.sin(now+offset*20)*.35*dt,
                -4.5*dt,
                math.cos(now*.7+offset*10)*.25*dt
            )

            obj.CFrame =
                CFrame.new(pos) *
                CFrame.Angles(
                    now+offset,
                    now*.6,
                    now*.8
                )

        elseif mode == "Snow" then

            pos += Vector3.new(
                math.sin(now*.6+offset*20)*.3*dt,
                -7*dt,
                math.cos(now*.5+offset*20)*.3*dt
            )

            local model = obj

            if model.PrimaryPart then
                model:PivotTo(CFrame.new(pos))

                for _,arm in ipairs(model:GetChildren()) do
                    if arm:IsA("BasePart")
                    and arm ~= model.PrimaryPart then

                        local n = arm:GetAttribute("Arm") or 1

                        arm.CFrame =
                            CFrame.new(pos) *
                            CFrame.Angles(
                                0,
                                math.rad(n*30),
                                math.rad(90)
                            )
                    end
                end
            end

        elseif mode == "Stars" then

            pos += Vector3.new(
                math.sin(now+offset*20)*.1*dt,
                -.8*dt,
                math.cos(now*.7+offset*20)*.1*dt
            )

            local model = obj

            if model.PrimaryPart then
                model:PivotTo(CFrame.new(pos))

                for _,arm in ipairs(model:GetChildren()) do
                    if arm:IsA("BasePart")
                    and arm ~= model.PrimaryPart then

                        local n = arm:GetAttribute("Arm") or 1
                        local rotation = math.rad((n-1)*45)

                        arm.CFrame =
                            CFrame.new(pos) *
                            CFrame.Angles(0,rotation,0)
                    end
                end
            end
        end

        ParticlePositions[obj] = pos

        if
            (pos-root.Position).Y < -4
            or
            (pos-root.Position).Magnitude > 70
        then
            ParticlePositions[obj] = RandomWorldPosition()
        end
    end
end

--========================================================--
-- SAKURA AURA
--========================================================--

local AuraFolder = Instance.new("Folder")
AuraFolder.Name = "MonotonSakuraAura"
AuraFolder.Parent = workspace

local AuraParts = {}

local function ClearAura()
    for _,part in ipairs(AuraParts) do
        pcall(function()
            part:Destroy()
        end)
    end

    table.clear(AuraParts)
end

local function RebuildAura()
    ClearAura()

    if not CFG.SakuraAura then
        return
    end

    for i=1,CFG.SakuraAuraCount do
        local p = Instance.new("Part")

        p.Name = "SakuraAuraPetal"
        p.Anchored = true
        p.CanCollide = false
        p.CanTouch = false
        p.CanQuery = false
        p.Material = Enum.Material.Neon
        p.Color = GetAccent()
        p.Size = Vector3.new(.18,.045,.38)
        p.Parent = AuraFolder

        table.insert(AuraParts,p)
    end
end

local LastAuraCount = 0
local LastAuraState = false

local function UpdateAura()
    if
        LastAuraCount ~= CFG.SakuraAuraCount
        or
        LastAuraState ~= CFG.SakuraAura
    then

        LastAuraCount = CFG.SakuraAuraCount
        LastAuraState = CFG.SakuraAura

        RebuildAura()
    end

    if not CFG.SakuraAura then
        return
    end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local now = os.clock()
    local count = #AuraParts

    for i,petal in ipairs(AuraParts) do
        local angle =
            now*1.5+
            ((i-1)/math.max(count,1))*math.pi*2

        local radius =
            CFG.SakuraAuraRadius+
            math.sin(now*2+i)*.25

        local y =
            .8+
            math.sin(now*2+i)*.35

        local pos =
            root.Position+
            Vector3.new(
                math.cos(angle)*radius,
                y,
                math.sin(angle)*radius
            )

        petal.CFrame =
            CFrame.new(pos) *
            CFrame.Angles(
                math.sin(now+i),
                angle,
                math.cos(now+i)
            )

        petal.Color = GetAccent()
    end
end

--========================================================--
-- CHAMS
--========================================================--

local ChamsFolder = Instance.new("Folder")
ChamsFolder.Name = "MonotonChams"
ChamsFolder.Parent = workspace

local function UpdateChams()
    if not CFG.Chams then
        for _,obj in ipairs(ChamsFolder:GetChildren()) do
            obj:Destroy()
        end
        return
    end

    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then

            local char = player.Character
            local existing =
                ChamsFolder:FindFirstChild(player.Name)

            if not existing then
                local h = Instance.new("Highlight")

                h.Name = player.Name
                h.Adornee = char
                h.FillColor = GetAccent()
                h.FillTransparency = 0
                h.OutlineTransparency = 1
                h.DepthMode =
                    Enum.HighlightDepthMode.AlwaysOnTop

                h.Parent = ChamsFolder
            else
                existing.FillColor = GetAccent()
                existing.Adornee = char
            end
        end
    end
end

--========================================================--
-- ESP DRAWING
--========================================================--

local HAS_DRAWING =
    type(Drawing) == "table"
    and type(Drawing.new) == "function"

local ESPObjects = {}

local SkeletonR15 = {
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
    {"RightLowerLeg","RightFoot"}
}

local SkeletonR6 = {
    {"Head","Torso"},
    {"Torso","Left Arm"},
    {"Left Arm","Left Leg"},
    {"Torso","Right Arm"},
    {"Right Arm","Right Leg"},
    {"Torso","Left Leg"},
    {"Torso","Right Leg"}
}

local function NewDrawing(class)
    local ok,obj = pcall(function()
        return Drawing.new(class)
    end)

    if ok then
        return obj
    end
end

local function NewLine()
    local l = NewDrawing("Line")

    if l then
        l.Thickness = 1
        l.Transparency = 1
        l.Visible = false
    end

    return l
end

local function NewSquare()
    local s = NewDrawing("Square")

    if s then
        s.Thickness = 1
        s.Transparency = 1
        s.Filled = false
        s.Visible = false
    end

    return s
end

local function NewText()
    local t = NewDrawing("Text")

    if t then
        t.Size = 13
        t.Center = true
        t.Outline = true
        t.Transparency = 1
        t.Visible = false
    end

    return t
end

local function HideESP(data)
    if not data then return end

    for _,obj in pairs(data) do
        if typeof(obj) == "table" then
            for _,v in pairs(obj) do
                if typeof(v) == "table" then
                    for _,x in pairs(v) do
                        if x then
                            pcall(function()
                                x.Visible = false
                            end)
                        end
                    end
                elseif v then
                    pcall(function()
                        v.Visible = false
                    end)
                end
            end
        elseif obj then
            pcall(function()
                obj.Visible = false
            end)
        end
    end
end

local function CreateESP(player)
    if not HAS_DRAWING then
        return nil
    end

    if ESPObjects[player] then
        return ESPObjects[player]
    end

    local data = {
        box = {},
        outline = {},
        corners = {},
        skeleton = {},
        fill = NewSquare(),
        healthBG = NewLine(),
        health = NewLine(),
        name = NewText(),
        distance = NewText()
    }

    for i=1,4 do
        data.box[i] = NewLine()
        data.outline[i] = NewLine()
    end

    for i=1,8 do
        data.corners[i] = NewLine()
    end

    for i=1,14 do
        data.skeleton[i] = NewLine()
    end

    ESPObjects[player] = data

    return data
end

local function RemoveESP(player)
    local data = ESPObjects[player]

    if not data then return end

    local function Destroy(v)
        if typeof(v) == "table" then
            for _,x in pairs(v) do
                Destroy(x)
            end
        elseif v then
            pcall(function()
                v:Remove()
            end)
        end
    end

    Destroy(data)
    ESPObjects[player] = nil
end

local function ProjectBox(character,camera)
    local cf,size = character:GetBoundingBox()

    local hx = size.X/2
    local hy = size.Y/2
    local hz = size.Z/2

    local corners = {
        Vector3.new(-hx,-hy,-hz),
        Vector3.new(-hx,-hy,hz),
        Vector3.new(-hx,hy,-hz),
        Vector3.new(-hx,hy,hz),
        Vector3.new(hx,-hy,-hz),
        Vector3.new(hx,-hy,hz),
        Vector3.new(hx,hy,-hz),
        Vector3.new(hx,hy,hz)
    }

    local minX = math.huge
    local minY = math.huge
    local maxX = -math.huge
    local maxY = -math.huge

    local visible = false

    for _,corner in ipairs(corners) do
        local p,onScreen =
            camera:WorldToViewportPoint(
                cf:PointToWorldSpace(corner)
            )

        if p.Z > 0 then
            minX = math.min(minX,p.X)
            minY = math.min(minY,p.Y)
            maxX = math.max(maxX,p.X)
            maxY = math.max(maxY,p.Y)

            if onScreen then
                visible = true
            end
        end
    end

    if minX == math.huge then
        return nil
    end

    return minX,minY,maxX,maxY,visible
end

local function SetLine(line,from,to,color,thickness,visible)
    if not line then return end

    line.From = from
    line.To = to
    line.Color = color
    line.Thickness = thickness or 1
    line.Visible = visible
end

local function UpdateESP()
    if not HAS_DRAWING then
        return
    end

    for _,player in ipairs(Players:GetPlayers()) do
        if player == LP then
            continue
        end

        local data = CreateESP(player)

        if not CFG.ESP then
            HideESP(data)
            continue
        end

        local char = player.Character
        local hum =
            char and char:FindFirstChildOfClass("Humanoid")
        local root =
            char and char:FindFirstChild("HumanoidRootPart")

        if not char or not hum or not root then
            HideESP(data)
            continue
        end

        if CFG.ESPTeamCheck
        and LP.Team
        and player.Team == LP.Team then

            HideESP(data)
            continue
        end

        local camera = workspace.CurrentCamera

        if not camera then
            HideESP(data)
            continue
        end

        local distance =
            (camera.CFrame.Position-root.Position).Magnitude

        if distance > CFG.ESPMaxDistance then
            HideESP(data)
            continue
        end

        local minX,minY,maxX,maxY,visible =
            ProjectBox(char,camera)

        if not minX or not visible then
            HideESP(data)
            continue
        end

        local accent = GetAccent()

        local width = maxX-minX
        local height = maxY-minY

        local tl = Vector2.new(minX,minY)
        local tr = Vector2.new(maxX,minY)
        local bl = Vector2.new(minX,maxY)
        local br = Vector2.new(maxX,maxY)

        -- BOX
        for _,line in ipairs(data.box) do
            line.Visible = false
        end

        if CFG.ESPBox then
            SetLine(data.box[1],tl,tr,accent,1,true)
            SetLine(data.box[2],tr,br,accent,1,true)
            SetLine(data.box[3],br,bl,accent,1,true)
            SetLine(data.box[4],bl,tl,accent,1,true)
        end

        -- FILL
        if data.fill then
            data.fill.Position = tl
            data.fill.Size = Vector2.new(width,height)
            data.fill.Color = accent
            data.fill.Transparency = .12
            data.fill.Filled = true
            data.fill.Visible = CFG.ESPFill
        end

        -- OUTLINE
        for _,line in ipairs(data.outline) do
            line.Visible = false
        end

        if CFG.ESPOutline then
            SetLine(data.outline[1],tl,tr,BLACK,3,true)
            SetLine(data.outline[2],tr,br,BLACK,3,true)
            SetLine(data.outline[3],br,bl,BLACK,3,true)
            SetLine(data.outline[4],bl,tl,BLACK,3,true)
        end

        -- CORNERS
        for _,line in ipairs(data.corners) do
            line.Visible = false
        end

        if CFG.ESPCorner then
            local cw = width*.25
            local ch = height*.20

            SetLine(
                data.corners[1],
                tl,
                tl+Vector2.new(cw,0),
                accent,2,true
            )

            SetLine(
                data.corners[2],
                tl,
                tl+Vector2.new(0,ch),
                accent,2,true
            )

            SetLine(
                data.corners[3],
                tr,
                tr-Vector2.new(cw,0),
                accent,2,true
            )

            SetLine(
                data.corners[4],
                tr,
                tr+Vector2.new(0,ch),
                accent,2,true
            )

            SetLine(
                data.corners[5],
                bl,
                bl+Vector2.new(cw,0),
                accent,2,true
            )

            SetLine(
                data.corners[6],
                bl,
                bl-Vector2.new(0,ch),
                accent,2,true
            )

            SetLine(
                data.corners[7],
                br,
                br-Vector2.new(cw,0),
                accent,2,true
            )

            SetLine(
                data.corners[8],
                br,
                br-Vector2.new(0,ch),
                accent,2,true
            )
        end

        -- HEALTH
        if data.healthBG then
            SetLine(
                data.healthBG,
                Vector2.new(minX-5,maxY),
                Vector2.new(minX-5,minY),
                BLACK,4,CFG.ESPHealth
            )

            local healthPct =
                math.clamp(
                    hum.Health/math.max(hum.MaxHealth,1),
                    0,
                    1
                )

            local hy =
                maxY-height*healthPct

            SetLine(
                data.health,
                Vector2.new(minX-5,maxY),
                Vector2.new(minX-5,hy),
                Color3.fromRGB(
                    255*(1-healthPct),
                    255*healthPct,
                    70
                ),
                2,
                CFG.ESPHealth
            )
        end

        -- NAME
        if data.name then
            data.name.Text = player.DisplayName
            data.name.Position =
                Vector2.new(
                    (minX+maxX)/2,
                    minY-17
                )
            data.name.Color = accent
            data.name.Visible = CFG.ESPName
        end

        -- DISTANCE
        if data.distance then
            data.distance.Text =
                math.floor(distance).."m"

            data.distance.Position =
                Vector2.new(
                    (minX+maxX)/2,
                    maxY+4
                )

            data.distance.Color = WHITE
            data.distance.Visible = CFG.ESPDistance
        end

        -- SKELETON
        for _,line in ipairs(data.skeleton) do
            line.Visible = false
        end

        if CFG.ESPSkeleton then
            local pairsList =
                char:FindFirstChild("UpperTorso")
                and SkeletonR15
                or SkeletonR6

            for i,pair in ipairs(pairsList) do
                local a = char:FindFirstChild(pair[1])
                local b = char:FindFirstChild(pair[2])

                if a and b and data.skeleton[i] then
                    local pa,oa =
                        camera:WorldToViewportPoint(a.Position)

                    local pb,ob =
                        camera:WorldToViewportPoint(b.Position)

                    if pa.Z > 0 and pb.Z > 0 then
                        SetLine(
                            data.skeleton[i],
                            Vector2.new(pa.X,pa.Y),
                            Vector2.new(pb.X,pb.Y),
                            accent,
                            1,
                            oa or ob
                        )
                    end
                end
            end
        end
    end
end

Players.PlayerRemoving:Connect(RemoveESP)

--========================================================--
-- NIGHT
--========================================================--

local OriginalBrightness = Lighting.Brightness
local OriginalExposure = Lighting.ExposureCompensation
local OriginalAmbient = Lighting.Ambient
local OriginalOutdoor = Lighting.OutdoorAmbient

local function UpdateNight()
    if CFG.Night then
        local amount = CFG.NightDarkness/100

        Lighting.Brightness =
            math.max(
                .05,
                OriginalBrightness*(1-amount*.9)
            )

        Lighting.ExposureCompensation =
            OriginalExposure-amount*1.5

        Lighting.Ambient =
            Color3.fromRGB(25,25,30)

        Lighting.OutdoorAmbient =
            Color3.fromRGB(25,25,30)
    else
        Lighting.Brightness = OriginalBrightness
        Lighting.ExposureCompensation = OriginalExposure
        Lighting.Ambient = OriginalAmbient
        Lighting.OutdoorAmbient = OriginalOutdoor
    end
end

--========================================================--
-- MOTION BLUR
--========================================================--

local Blur =
    Lighting:FindFirstChild("MonotonMotionBlur")

if Blur then
    Blur:Destroy()
end

Blur = Instance.new("BlurEffect")
Blur.Name = "MonotonMotionBlur"
Blur.Size = 0
Blur.Enabled = false
Blur.Parent = Lighting

local LastLook = nil
local BlurValue = 0

local function UpdateBlur(dt)
    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    if not CFG.Smooth then
        Blur.Enabled = false

        BlurValue +=
            (0-BlurValue)*
            math.clamp(dt*10,0,1)

        Blur.Size = BlurValue
        LastLook = camera.CFrame.LookVector
        return
    end

    Blur.Enabled = true

    local look = camera.CFrame.LookVector

    if not LastLook then
        LastLook = look
        return
    end

    local dot =
        math.clamp(
            LastLook:Dot(look),
            -1,
            1
        )

    local angle = math.acos(dot)

    local strength =
        CFG.BlurAmount/100

    local target =
        math.clamp(
            angle*180*strength*2,
            0,
            24
        )

    BlurValue +=
        (target-BlurValue)*
        math.clamp(dt*12,0,1)

    Blur.Size = BlurValue
    LastLook = look
end

--========================================================--
-- SKY
--========================================================--

local Galaxy = {
    "rbxassetid://159454299",
    "rbxassetid://159454296",
    "rbxassetid://159454293",
    "rbxassetid://159454286",
    "rbxassetid://159454300",
    "rbxassetid://159454288"
}

local LastSky = ""

local function ClearSky()
    for _,obj in ipairs(Lighting:GetChildren()) do
        if
            obj.Name == "MonotonSky"
            or obj.Name == "MonotonAtmosphere"
            or obj.Name == "MonotonGreenTint"
            or obj.Name == "MonotonBloom"
        then
            obj:Destroy()
        end
    end
end

local function MakeSky(textures)
    ClearSky()

    local sky = Instance.new("Sky")

    sky.Name = "MonotonSky"

    sky.SkyboxBk = textures[1]
    sky.SkyboxDn = textures[2]
    sky.SkyboxFt = textures[3]
    sky.SkyboxLf = textures[4]
    sky.SkyboxRt = textures[5]
    sky.SkyboxUp = textures[6]

    sky.CelestialBodiesShown = false
    sky.Parent = Lighting
end

local function MakeGreenTint()
    local cc = Instance.new("ColorCorrectionEffect")

    cc.Name = "MonotonGreenTint"
    cc.TintColor =
        Color3.fromRGB(110,255,155)

    cc.Saturation = .22
    cc.Contrast = .12
    cc.Brightness = .04
    cc.Parent = Lighting

    local bloom = Instance.new("BloomEffect")

    bloom.Name = "MonotonBloom"
    bloom.Intensity = .35
    bloom.Size = 24
    bloom.Threshold = .75
    bloom.Parent = Lighting
end

local function UpdateSky()
    if LastSky == CFG.Sky then
        return
    end

    LastSky = CFG.Sky

    ClearSky()

    if CFG.Sky == "Default" then

        return

    elseif CFG.Sky == "Galaxy" then

        MakeSky(Galaxy)

    elseif CFG.Sky == "Black Hole" then

        MakeSky(Galaxy)

        local a = Instance.new("Atmosphere")

        a.Name = "MonotonAtmosphere"
        a.Density = .5
        a.Haze = 2
        a.Glare = .25
        a.Color = Color3.fromRGB(70,35,90)
        a.Decay = Color3.fromRGB(10,5,15)

        a.Parent = Lighting

    elseif CFG.Sky == "Northern" then

        MakeSky(Galaxy)

        local a = Instance.new("Atmosphere")

        a.Name = "MonotonAtmosphere"

        -- stronger green than V1.1
        a.Density = .42
        a.Haze = 1.8
        a.Glare = .5

        a.Color =
            Color3.fromRGB(
                70,
                255,
                135
            )

        a.Decay =
            Color3.fromRGB(
                0,
                105,
                45
            )

        a.Parent = Lighting

        MakeGreenTint()

        Lighting.Ambient =
            Color3.fromRGB(35,100,55)

        Lighting.OutdoorAmbient =
            Color3.fromRGB(25,90,45)

        Lighting.ColorShift_Top =
            Color3.fromRGB(65,190,95)

        Lighting.ColorShift_Bottom =
            Color3.fromRGB(10,70,30)

    elseif CFG.Sky == "Black" then

        local a = Instance.new("Atmosphere")

        a.Name = "MonotonAtmosphere"

        a.Density = 1
        a.Haze = 10
        a.Glare = 0

        a.Color = Color3.new(0,0,0)
        a.Decay = Color3.new(0,0,0)

        a.Parent = Lighting
    end
end

--========================================================--
-- MOVEMENT
--========================================================--

local NoclipCache = {}

local function UpdateNoclip()
    local char = LP.Character

    if not char then
        return
    end

    if CFG.Noclip then

        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then

                if NoclipCache[obj] == nil then
                    NoclipCache[obj] = obj.CanCollide
                end

                obj.CanCollide = false
            end
        end

    else

        for part,value in pairs(NoclipCache) do
            if part and part.Parent then
                part.CanCollide = value
            end
        end

        table.clear(NoclipCache)
    end
end

local function UpdateMovement()
    local char = LP.Character

    if not char then
        return
    end

    local hum =
        char:FindFirstChildOfClass("Humanoid")

    if not hum then
        return
    end

    if CFG.SpeedHack then
        hum.WalkSpeed = CFG.Speed
    else
        hum.WalkSpeed = 16
    end

    if CFG.JumpBoost then
        hum.UseJumpPower = true
        hum.JumpPower = CFG.JumpPower
    end

    UpdateNoclip()
end

--========================================================--
-- FLY
--========================================================--

local function GetFlyDirection()
    local char = LP.Character

    if not char then
        return Vector3.zero
    end

    local hum =
        char:FindFirstChildOfClass("Humanoid")

    local camera = workspace.CurrentCamera

    if not hum or not camera then
        return Vector3.zero
    end

    -- Roblox joystick / keyboard both end up here.
    local move = hum.MoveDirection

    if move.Magnitude <= .01 then
        return Vector3.zero
    end

    -- Camera-relative forward/right.
    local camLook = camera.CFrame.LookVector
    local camRight = camera.CFrame.RightVector

    local flatLook =
        Vector3.new(
            camLook.X,
            0,
            camLook.Z
        )

    local flatRight =
        Vector3.new(
            camRight.X,
            0,
            camRight.Z
        )

    if flatLook.Magnitude < .01 then
        flatLook = Vector3.new(0,0,-1)
    else
        flatLook = flatLook.Unit
    end

    if flatRight.Magnitude < .01 then
        flatRight = Vector3.new(1,0,0)
    else
        flatRight = flatRight.Unit
    end

    -- Determine joystick/keyboard input relative to camera.
    local forwardAmount =
        move:Dot(flatLook)

    local rightAmount =
        move:Dot(flatRight)

    local horizontal =
        flatLook*forwardAmount+
        flatRight*rightAmount

    -- Camera pitch controls altitude.
    -- Looking up + moving forward = rise.
    -- Looking down + moving forward = descend.
    local vertical =
        forwardAmount*camLook.Y

    local result =
        horizontal+
        Vector3.new(
            0,
            vertical,
            0
        )

    if result.Magnitude > 1 then
        result = result.Unit
    end

    return result
end

local function UpdateFly()
    local char = LP.Character

    if not char then
        return
    end

    local hum =
        char:FindFirstChildOfClass("Humanoid")

    local root =
        char:FindFirstChild("HumanoidRootPart")

    if not hum or not root then
        return
    end

    if not CFG.Fly then
        if hum.PlatformStand then
            hum.PlatformStand = false
        end
        return
    end

    hum.PlatformStand = true

    local direction = GetFlyDirection()

    root.AssemblyLinearVelocity =
        direction*CFG.FlySpeed
end

--========================================================--
-- AIR JUMP
--========================================================--

UIS.JumpRequest:Connect(function()
    if not CFG.AirJump then
        return
    end

    local char = LP.Character

    local root =
        char and
        char:FindFirstChild("HumanoidRootPart")

    if root then
        local vel = root.AssemblyLinearVelocity

        root.AssemblyLinearVelocity =
            Vector3.new(
                vel.X,
                CFG.JumpPower,
                vel.Z
            )
    end
end)

--========================================================--
-- CHARACTER
--========================================================--

LP.CharacterAdded:Connect(function()
    task.wait(1)

    RemoveSnowHat()
    RemoveChinaHat()

    StopAnimation()

    if CFG.AnimationHack
    and CFG.AnimationID ~= "" then
        task.wait(.5)
        PlayAnimation(CFG.AnimationID)
    end

    pcall(UpdateMovement)
end)

--========================================================--
-- FONT / ACCENT
--========================================================--

local function ApplyVisualSettings()
    local font =
        FONTS[CFG.Font]
        or FONTS.Gotham

    for _,obj in ipairs(GUI:GetDescendants()) do

        if obj:IsA("TextLabel")
        or obj:IsA("TextButton")
        or obj:IsA("TextBox") then

            pcall(function()
                obj.Font = font
            end)
        end
    end

    local accent = GetAccent()

    MainStroke.Color = accent
    MStroke.Color = accent

    for _,obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("UIStroke") then
            obj.Color = accent
        end
    end

    VersionLabel.TextColor3 = accent
end

--========================================================--
-- MAIN LOOP
--========================================================--

local timer = 0
local refresh = 0

RunService.RenderStepped:Connect(function(dt)

    pcall(function()
        UpdateBlur(dt)
    end)

    pcall(function()
        UpdateNight()
    end)

    pcall(function()
        UpdateWorldParticles(dt)
    end)

    pcall(function()
        UpdateAura()
    end)

    pcall(function()
        UpdateFly()
    end)

    timer += dt

    if timer >= .15 then
        timer = 0

        pcall(UpdateMovement)
        pcall(UpdateChams)
        pcall(UpdateESP)
        pcall(UpdateSky)
    end

    refresh += dt

    if refresh >= 1 then
        refresh = 0

        pcall(ApplyVisualSettings)

        -- keep models synced with character
        if CFG.ChinaHat and not ChinaHatModel then
            pcall(CreateChinaHat)
        end
    end
end)

--========================================================--
-- FINAL STATE
--========================================================--

GUI.Enabled = true

if HasLicense then
    KeyFrame.Visible = false
    M.Visible = true
else
    KeyFrame.Visible = true
    M.Visible = false
end

print("[MonotonVisuals] V1.3 loaded")
print("[MonotonVisuals] Old menu preserved")
print("[MonotonVisuals] China Hat / Fly / ESP / Noclip / Animation ready")
