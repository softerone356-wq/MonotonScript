--========================================================--
-- MONOTON VISUALS V1.1
-- FULL REBUILD
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

    SakuraLeaves = false,
    Snow = false,
    Stars = false,
    SakuraAura = false,

    Night = false,
    NightDarkness = 35,

    JumpBoost = false,
    JumpPower = 50,

    AirJump = false,

    SpeedHack = false,
    Speed = 16,

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

    local ok, data = pcall(function()
        return HttpService:JSONEncode(CFG)
    end)

    if not ok then
        return false
    end

    local success = pcall(function()
        writefile(FileName(name), data)
    end)

    return success
end

local function LoadConfig(name)

    if not HAS_FILE then
        return false
    end

    if not isfile(FileName(name)) then
        return false
    end

    local ok, raw = pcall(function()
        return readfile(FileName(name))
    end)

    if not ok then
        return false
    end

    local ok2, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)

    if not ok2 or type(data) ~= "table" then
        return false
    end

    for key, value in pairs(DEFAULTS) do

        if data[key] ~= nil then
            CFG[key] = data[key]
        else
            CFG[key] = value
        end

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

    local ok = pcall(function()
        delfile(FileName(name))
    end)

    return ok
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

--========================================================--
-- OLD GUI
--========================================================--

pcall(function()

    local old = PARENT:FindFirstChild(
        "MonotonVisuals"
    )

    if old then
        old:Destroy()
    end

end)

--========================================================--
-- INSTANCE
--========================================================--

local function New(class, props, parent)

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

local function Corner(obj, radius)

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,radius)
    c.Parent = obj

end

local function AddStroke(obj)

    local s = Instance.new("UIStroke")
    s.Color = GetAccent()
    s.Transparency = 0.72
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
-- PERMANENT KEY
--========================================================--

local PERMANENT_KEY = "t.me/monotonvisuals"

local KEY_FILE =
    BASE_FOLDER .. "/License.txt"

local HasLicense = false

if HAS_FILE then

    pcall(function()

        if isfile(KEY_FILE) then

            local value =
                readfile(KEY_FILE)

            if value ==
                PERMANENT_KEY
            then
                HasLicense = true
            end

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
-- MAIN
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

--========================================================--
-- BACKGROUND WATERMARK
--========================================================--

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

--========================================================--
-- HEADER
--========================================================--

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

New(
    "TextLabel",
    {
        Position = UDim2.fromOffset(19,40),
        Size = UDim2.fromOffset(150,18),
        BackgroundTransparency = 1,
        Text = "VISUALS V1.1",
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
            Position = UDim2.fromOffset(
                7,
                7 + (i-1)*34
            ),
            Size = UDim2.new(1,-14,0,29),
            BackgroundColor3 = DARK2,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = GRAY,
            TextSize = 12,
            Font = FONTS.GothamMedium,
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
-- PAGE SYSTEM
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

    layout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(function()

        p.CanvasSize =
            UDim2.new(
                0,0,
                0,
                layout.AbsoluteContentSize.Y + 10
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

    local l = Label(
        parent,
        text,
        25
    )

    l.TextColor3 = GetAccent()
    l.TextSize = 11
    l.Font = FONTS.GothamBold

end

local function Toggle(
    parent,
    text,
    default,
    callback
)

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
            BackgroundColor3 =
                default and GetAccent() or DARK3,
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

        Tween(
            sw,
            .25,
            {
                BackgroundColor3 =
                    state and GetAccent() or DARK3
            }
        )

        pcall(callback,state)

    end)

end

local function Slider(
    parent,
    text,
    min,
    max,
    default,
    callback
)

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

    local fill = New(
        "Frame",
        {
            Size = UDim2.new(
                (default-min)/(max-min),
                0,
                1,
                0
            ),
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

        local pct =
            (v-min)/(max-min)

        fill.Size =
            UDim2.new(
                pct,0,1,0
            )

        val.Text =
            tostring(
                math.floor(v)
            )

        pcall(callback,v)

    end

    bar.InputBegan:Connect(function(input)

        if
            input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            dragging = true

            local x =
                math.clamp(
                    input.Position.X -
                    bar.AbsolutePosition.X,
                    0,
                    bar.AbsoluteSize.X
                )

            Set(
                min +
                (max-min) *
                (x/bar.AbsoluteSize.X)
            )

        end

    end)

    UIS.InputChanged:Connect(function(input)

        if not dragging then return end

        if
            input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

            local x =
                math.clamp(
                    input.Position.X -
                    bar.AbsolutePosition.X,
                    0,
                    bar.AbsoluteSize.X
                )

            Set(
                min +
                (max-min) *
                (x/bar.AbsoluteSize.X)
            )

        end

    end)

    UIS.InputEnded:Connect(function(input)

        if
            input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch
        then

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
            Font = FONTS.GothamMedium,
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

--========================================================--
-- HOME
--========================================================--

Section(Home,"MONOTON VISUALS")

Label(
    Home,
    "Black / white / custom accent interface",
    25
)

Label(
    Home,
    "Permanent license enabled",
    25
)

Label(
    Home,
    "V1.1 • Visual Effects",
    25
)

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
    "ESP Box",
    CFG.ESP,
    function(v)
        CFG.ESP = v
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

Section(Visuals,"SKY")

Button(
    Visuals,
    "Galaxy",
    function()
        CFG.Sky = "Galaxy"
    end
)

Button(
    Visuals,
    "Black Hole",
    function()
        CFG.Sky = "Black Hole"
    end
)

Button(
    Visuals,
    "Black Sky",
    function()
        CFG.Sky = "Black"
    end
)

Button(
    Visuals,
    "Northern Green Lights",
    function()
        CFG.Sky = "Northern"
    end
)

Button(
    Visuals,
    "Default Sky",
    function()
        CFG.Sky = "Default"
    end
)

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

--========================================================--
-- MODELS
--========================================================--

Section(
    Models,
    "WINTER MODELS"
)

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

local function RemoveSnowHat()

    if SnowHatModel then

        pcall(function()
            SnowHatModel:Destroy()
        end)

        SnowHatModel = nil

    end

end

local function CreateSnowHat()

    RemoveSnowHat()

    local character =
        LP.Character

    if not character then
        return
    end

    local head =
        character:FindFirstChild("Head")

    if not head then
        return
    end

    local model =
        Instance.new("Model")

    model.Name =
        "MonotonSnowHat"

    model.Parent =
        ModelFolder

    local base =
        Instance.new("Part")

    base.Name =
        "SnowHatBase"

    base.Anchored = false
    base.CanCollide = false
    base.CanTouch = false
    base.CanQuery = false

    base.Material =
        Enum.Material.Fabric

    base.Color =
        Color3.fromRGB(
            235,
            235,
            240
        )

    base.Size =
        Vector3.new(
            1.9,
            .65,
            1.9
        )

    base.CFrame =
        head.CFrame *
        CFrame.new(
            0,
            .72,
            0
        )

    base.Parent =
        model

    local weld =
        Instance.new("WeldConstraint")

    weld.Part0 =
        base

    weld.Part1 =
        head

    weld.Parent =
        base

    local brim =
        Instance.new("Part")

    brim.Name =
        "SnowHatBrim"

    brim.Anchored = false
    brim.CanCollide = false
    brim.CanTouch = false
    brim.CanQuery = false

    brim.Material =
        Enum.Material.Fabric

    brim.Color =
        Color3.fromRGB(
            220,
            220,
            225
        )

    brim.Size =
        Vector3.new(
            2.45,
            .18,
            2.45
        )

    brim.CFrame =
        head.CFrame *
        CFrame.new(
            0,
            .42,
            0
        )

    brim.Parent =
        model

    local weld2 =
        Instance.new("WeldConstraint")

    weld2.Part0 =
        brim

    weld2.Part1 =
        head

    weld2.Parent =
        brim

    local pom =
        Instance.new("Part")

    pom.Name =
        "SnowPom"

    pom.Shape =
        Enum.PartType.Ball

    pom.Anchored = false
    pom.CanCollide = false
    pom.CanTouch = false
    pom.CanQuery = false

    pom.Material =
        Enum.Material.Fabric

    pom.Color =
        Color3.fromRGB(
            250,
            250,
            255
        )

    pom.Size =
        Vector3.new(
            .48,
            .48,
            .48
        )

    pom.CFrame =
        head.CFrame *
        CFrame.new(
            0,
            1.35,
            0
        )

    pom.Parent =
        model

    local weld3 =
        Instance.new("WeldConstraint")

    weld3.Part0 =
        pom

    weld3.Part1 =
        head

    weld3.Parent =
        pom

    SnowHatModel =
        model

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
    "Soft 3D winter hat • attached to head",
    28
)

--========================================================--
-- SETTINGS
--========================================================--

Section(
    Settings,
    "FONT"
)

local FontStatus = Label(
    Settings,
    "Current: " .. CFG.Font,
    27
)

for name,_ in pairs(FONTS) do

    Button(
        Settings,
        name,
        function()

            CFG.Font = name

            FontStatus.Text =
                "Current: " ..
                name

        end
    )

end

Section(
    Settings,
    "ACCENT PALETTE"
)

local AccentStatus = Label(
    Settings,
    "Current: " .. CFG.AccentName,
    27
)

for name,color in pairs(ACCENTS) do

    Button(
        Settings,
        name,
        function()

            CFG.AccentName =
                name

            SetAccent(color)

            AccentStatus.Text =
                "Current: " ..
                name

        end
    )

end

Section(
    Settings,
    "CUSTOM RGB"
)

Slider(
    Settings,
    "Accent Red",
    0,
    255,
    CFG.AccentColor[1],
    function(v)

        CFG.AccentColor[1] =
            math.floor(v)

    end
)

Slider(
    Settings,
    "Accent Green",
    0,
    255,
    CFG.AccentColor[2],
    function(v)

        CFG.AccentColor[2] =
            math.floor(v)

    end
)

Slider(
    Settings,
    "Accent Blue",
    0,
    255,
    CFG.AccentColor[3],
    function(v)

        CFG.AccentColor[3] =
            math.floor(v)

    end
)

--========================================================--
-- CONFIG PAGE
--========================================================--

Section(
    Configs,
    "CONFIG MANAGER"
)

Label(
    Configs,
    HAS_FILE
    and
    "File system detected"
    or
    "Executor file system unavailable",
    27
)

local ConfigName = New(
    "TextBox",
    {
        Size = UDim2.new(1,-4,0,40),
        BackgroundColor3 = DARK2,
        BorderSizePixel = 0,
        PlaceholderText = "Config name",
        PlaceholderColor3 = GRAY,
        Text = "",
        TextColor3 = WHITE,
        TextSize = 12,
        Font = FONTS.Gotham,
        ClearTextOnFocus = false,
        ZIndex = 113
    },
    Configs
)

Corner(ConfigName,8)

Button(
    Configs,
    "Save Config",
    function()

        local name =
            ConfigName.Text

        if name == "" then
            return
        end

        if SaveConfig(name) then

            ConfigName.Text = ""

        end

    end
)

Button(
    Configs,
    "Load Config",
    function()

        local name =
            ConfigName.Text

        if name == "" then
            return
        end

        if LoadConfig(name) then

            -- settings loaded

        end

    end
)

Button(
    Configs,
    "Delete Config",
    function()

        local name =
            ConfigName.Text

        if name == "" then
            return
        end

        DeleteConfig(name)

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

Section(
    Info,
    "MONOTON VISUALS"
)

Label(
    Info,
    "MonotonVisuals v1.1",
    26
)

Label(
    Info,
    "Permanent license system",
    26
)

Label(
    Info,
    "World particles are 3D",
    26
)

Label(
    Info,
    "Sakura / Snow / Stars",
    26
)

Label(
    Info,
    "No Tung Model",
    26
)

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
        page.Visible =
            pageName == name
    end

    for tabName,button in pairs(TabButtons) do

        if tabName == name then

            button.BackgroundColor3 =
                Color3.fromRGB(40,28,35)

            button.TextColor3 =
                GetAccent()

        else

            button.BackgroundColor3 =
                DARK2

            button.TextColor3 =
                GRAY

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

    Main.Size =
        UDim2.fromOffset(
            500,
            325
        )

    Tween(
        Main,
        .4,
        {
            Size =
                UDim2.fromOffset(
                    530,
                    345
                )
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

Close.Activated:Connect(
    CloseMenu
)

--========================================================--
-- DRAG M
--========================================================--

local dragging = false
local dragStart
local startPos

M.InputBegan:Connect(function(input)

    if
        input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or
        input.UserInputType ==
        Enum.UserInputType.Touch
    then

        dragging = true
        dragStart = input.Position
        startPos = M.Position

    end

end)

M.InputEnded:Connect(function(input)

    if
        input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or
        input.UserInputType ==
        Enum.UserInputType.Touch
    then

        dragging = false

    end

end)

UIS.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if
        input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or
        input.UserInputType ==
        Enum.UserInputType.Touch
    then

        local delta =
            input.Position -
            dragStart

        M.Position =
            UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )

    end

end)

--========================================================--
-- LICENSE
--========================================================--

local function ActivateLicense()

    local value =
        tostring(KeyBox.Text or "")

    value =
        value:gsub("^%s+","")
        :gsub("%s+$","")

    if value ~= PERMANENT_KEY then

        KeyStatus.Text =
            "Invalid key"

        KeyStatus.TextColor3 =
            Color3.fromRGB(
                255,
                100,
                120
            )

        return

    end

    HasLicense = true

    if HAS_FILE then

        pcall(function()

            writefile(
                KEY_FILE,
                PERMANENT_KEY
            )

        end)

    end

    KeyStatus.Text =
        "Permanent activation successful"

    KeyStatus.TextColor3 =
        GetAccent()

    task.wait(.3)

    KeyFrame.Visible = false
    M.Visible = true

    OpenMenu()

end

KeyButton.Activated:Connect(
    ActivateLicense
)

KeyBox.FocusLost:Connect(
    function(enter)

        if enter then
            ActivateLicense()
        end

    end
)

--========================================================--
-- WORLD EFFECT FOLDER
--========================================================--

local WorldFX = workspace:FindFirstChild(
    "MonotonWorldFX"
)

if WorldFX then
    WorldFX:Destroy()
end

WorldFX = Instance.new("Folder")
WorldFX.Name = "MonotonWorldFX"
WorldFX.Parent = workspace

--========================================================--
-- 3D PARTICLES
--========================================================--

local WorldParticles = {}

local function ClearWorldParticles()

    for _,obj in ipairs(WorldParticles) do

        pcall(function()
            obj:Destroy()
        end)

    end

    table.clear(WorldParticles)

end

local function CreatePetal()

    local p =
        Instance.new("Part")

    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false

    p.Material =
        Enum.Material.SmoothPlastic

    p.Color =
        GetAccent()

    p.Size =
        Vector3.new(
            .25,
            .07,
            .45
        )

    p.Parent =
        WorldFX

    p:SetAttribute(
        "Type",
        "Sakura"
    )

    p:SetAttribute(
        "Offset",
        math.random()
    )

    table.insert(
        WorldParticles,
        p
    )

end

local function CreateSnowflake()

    local model =
        Instance.new("Model")

    model.Name =
        "Snowflake"

    model.Parent =
        WorldFX

    local center =
        Instance.new("Part")

    center.Anchored = true
    center.CanCollide = false
    center.CanTouch = false
    center.CanQuery = false

    center.Transparency = 1

    center.Size =
        Vector3.new(
            .1,.1,.1
        )

    center.Parent =
        model

    for i = 1,6 do

        local arm =
            Instance.new("Part")

        arm.Anchored = true
        arm.CanCollide = false
        arm.CanTouch = false
        arm.CanQuery = false

        arm.Material =
            Enum.Material.Neon

        arm.Color =
            WHITE

        arm.Size =
            Vector3.new(
                .06,
                .06,
                .65
            )

        arm.Parent =
            model

        arm:SetAttribute(
            "Arm",
            i
        )

    end

    model.PrimaryPart =
        center

    model:SetAttribute(
        "Type",
        "Snow"
    )

    model:SetAttribute(
        "Offset",
        math.random()
    )

    table.insert(
        WorldParticles,
        model
    )

end

local function CreateStar()

    local model =
        Instance.new("Model")

    model.Name =
        "Star"

    model.Parent =
        WorldFX

    local center =
        Instance.new("Part")

    center.Anchored = true
    center.CanCollide = false
    center.CanTouch = false
    center.CanQuery = false

    center.Transparency = 1

    center.Size =
        Vector3.new(
            .1,.1,.1
        )

    center.Parent =
        model

    for i = 1,4 do

        local arm =
            Instance.new("Part")

        arm.Anchored = true
        arm.CanCollide = false
        arm.CanTouch = false
        arm.CanQuery = false

        arm.Material =
            Enum.Material.Neon

        arm.Color =
            WHITE

        arm.Size =
            Vector3.new(
                .035,
                .035,
                .55
            )

        arm.Parent =
            model

        arm:SetAttribute(
            "Arm",
            i
        )

    end

    model.PrimaryPart =
        center

    model:SetAttribute(
        "Type",
        "Stars"
    )

    model:SetAttribute(
        "Offset",
        math.random()
    )

    table.insert(
        WorldParticles,
        model
    )

end

--========================================================--
-- REBUILD WORLD PARTICLES
--========================================================--

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

local function RebuildWorldParticles()

    local mode =
        GetParticleMode()

    if mode ==
        LastParticleMode
    then
        return
    end

    LastParticleMode =
        mode

    ClearWorldParticles()

    if mode == "" then
        return
    end

    local amount = 34

    for i = 1,amount do

        if mode == "Snow" then

            CreateSnowflake()

        elseif mode == "Stars" then

            CreateStar()

        elseif mode == "Sakura" then

            CreatePetal()

        end

    end

end

--========================================================--
-- UPDATE WORLD PARTICLES
--========================================================--

local function GetRoot()

    local char =
        LP.Character

    if not char then
        return nil
    end

    return char:FindFirstChild(
        "HumanoidRootPart"
    )
end

local function RandomWorldPosition()

    local root =
        GetRoot()

    if not root then
        return Vector3.zero
    end

    return root.Position +
        Vector3.new(
            math.random(-55,55),
            math.random(20,50),
            math.random(-55,55)
        )
end

local ParticlePositions = {}

local function InitializeParticlePositions()

    for _,obj in ipairs(WorldParticles) do

        ParticlePositions[obj] =
            RandomWorldPosition()

    end

end

local function UpdateWorldParticles(dt)

    RebuildWorldParticles()

    local root =
        GetRoot()

    if not root then
        return
    end

    for _,obj in ipairs(WorldParticles) do

        if not obj.Parent then
            continue
        end

        local pos =
            ParticlePositions[obj]

        if not pos then

            pos =
                RandomWorldPosition()

            ParticlePositions[obj] =
                pos

        end

        local offset =
            obj:GetAttribute(
                "Offset"
            )
            or 0

        local mode =
            obj:GetAttribute(
                "Type"
            )

        if mode ==
            "Sakura"
        then

            pos =
                pos +
                Vector3.new(
                    math.sin(
                        tick() +
                        offset * 20
                    ) * .35 * dt,
                    -5 * dt,
                    math.cos(
                        tick() * .7 +
                        offset * 10
                    ) * .25 * dt
                )

            obj.CFrame =
                CFrame.new(pos) *
                CFrame.Angles(
                    tick() + offset,
                    tick() * .6,
                    tick() * .8
                )

        elseif mode ==
            "Snow"
        then

            pos =
                pos +
                Vector3.new(
                    math.sin(
                        tick()*.6 +
                        offset*20
                    ) * .3 * dt,
                    -4 * dt,
                    math.cos(
                        tick()*.5 +
                        offset*20
                    ) * .3 * dt
                )

            local model =
                obj

            if model.PrimaryPart then

                model:SetPrimaryPartCFrame(
                    CFrame.new(pos)
                )

                for _,arm in ipairs(
                    model:GetChildren()
                ) do

                    if arm:IsA("BasePart")
                    and arm ~= model.PrimaryPart
                    then

                        local n =
                            arm:GetAttribute(
                                "Arm"
                            ) or 1

                        arm.CFrame =
                            CFrame.new(pos) *
                            CFrame.Angles(
                                0,
                                math.rad(
                                    n * 30
                                ),
                                math.rad(
                                    90
                                )
                            )

                    end

                end

            end

        elseif mode ==
            "Stars"
        then

            pos =
                pos +
                Vector3.new(
                    math.sin(
                        tick() +
                        offset*20
                    ) * .1 * dt,
                    -2.2 * dt,
                    math.cos(
                        tick()*.7 +
                        offset*20
                    ) * .1 * dt
                )

            local model =
                obj

            if model.PrimaryPart then

                model:SetPrimaryPartCFrame(
                    CFrame.new(pos)
                )

                for _,arm in ipairs(
                    model:GetChildren()
                ) do

                    if arm:IsA("BasePart")
                    and arm ~= model.PrimaryPart
                    then

                        local n =
                            arm:GetAttribute(
                                "Arm"
                            ) or 1

                        local rotation =
                            math.rad(
                                (n-1)*45
                            )

                        arm.CFrame =
                            CFrame.new(pos) *
                            CFrame.Angles(
                                0,
                                rotation,
                                0
                            )

                    end

                end

            end

        end

        ParticlePositions[obj] =
            pos

        if
            (pos - root.Position).Y
            < -5
        then

            ParticlePositions[obj] =
                RandomWorldPosition()

        end

    end

end

--========================================================--
-- CHAMS
--========================================================--

local ChamsFolder = Instance.new(
    "Folder"
)

ChamsFolder.Name =
    "MonotonChams"

ChamsFolder.Parent =
    workspace

local function UpdateChams()

    if not CFG.Chams then

        for _,obj in ipairs(
            ChamsFolder:GetChildren()
        ) do

            obj:Destroy()

        end

        return
    end

    for _,player in ipairs(
        Players:GetPlayers()
    ) do

        if
            player ~= LP
            and
            player.Character
        then

            local char =
                player.Character

            local existing =
                ChamsFolder:
                FindFirstChild(
                    player.Name
                )

            if not existing then

                local h =
                    Instance.new(
                        "Highlight"
                    )

                h.Name =
                    player.Name

                h.Adornee =
                    char

                h.FillColor =
                    GetAccent()

                h.FillTransparency =
                    0

                h.OutlineTransparency =
                    1

                h.DepthMode =
                    Enum.HighlightDepthMode.AlwaysOnTop

                h.Parent =
                    ChamsFolder

            else

                existing.FillColor =
                    GetAccent()

            end

        end

    end

end

--========================================================--
-- ESP
--========================================================--

local ESPFolder = Instance.new(
    "Folder"
)

ESPFolder.Name =
    "MonotonESP"

ESPFolder.Parent =
    workspace

local function UpdateESP()

    if not CFG.ESP then

        for _,obj in ipairs(
            ESPFolder:GetChildren()
        ) do
            obj:Destroy()
        end

        return
    end

    for _,player in ipairs(
        Players:GetPlayers()
    ) do

        if
            player ~= LP
            and
            player.Character
        then

            local root =
                player.Character:
                FindFirstChild(
                    "HumanoidRootPart"
                )

            if root then

                local box =
                    ESPFolder:
                    FindFirstChild(
                        player.Name
                    )

                if not box then

                    box =
                        Instance.new(
                            "BoxHandleAdornment"
                        )

                    box.Name =
                        player.Name

                    box.Adornee =
                        root

                    box.AlwaysOnTop =
                        true

                    box.ZIndex =
                        5

                    box.Size =
                        Vector3.new(
                            4,
                            6,
                            2
                        )

                    box.Transparency =
                        .35

                    box.Parent =
                        ESPFolder

                end

                box.Color3 =
                    GetAccent()

            end

        end

    end

end

--========================================================--
-- NIGHT
--========================================================--

local OriginalBrightness =
    Lighting.Brightness

local OriginalExposure =
    Lighting.ExposureCompensation

local OriginalAmbient =
    Lighting.Ambient

local OriginalOutdoor =
    Lighting.OutdoorAmbient

local function UpdateNight()

    if CFG.Night then

        local amount =
            CFG.NightDarkness /
            100

        Lighting.Brightness =
            math.max(
                .05,
                OriginalBrightness *
                (1 - amount*.9)
            )

        Lighting.ExposureCompensation =
            OriginalExposure -
            amount*1.5

        Lighting.Ambient =
            Color3.fromRGB(
                25,
                25,
                30
            )

        Lighting.OutdoorAmbient =
            Color3.fromRGB(
                25,
                25,
                30
            )

    else

        Lighting.Brightness =
            OriginalBrightness

        Lighting.ExposureCompensation =
            OriginalExposure

        Lighting.Ambient =
            OriginalAmbient

        Lighting.OutdoorAmbient =
            OriginalOutdoor

    end

end

--========================================================--
-- BLUR
--========================================================--

local Blur =
    Lighting:FindFirstChild(
        "MonotonMotionBlur"
    )

if Blur then
    Blur:Destroy()
end

Blur =
    Instance.new(
        "BlurEffect"
    )

Blur.Name =
    "MonotonMotionBlur"

Blur.Size = 0
Blur.Enabled = false
Blur.Parent = Lighting

local LastLook = nil
local BlurValue = 0

local function UpdateBlur(dt)

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    if not CFG.Smooth then

        Blur.Enabled = false

        BlurValue +=
            (0 - BlurValue) *
            math.clamp(
                dt*10,
                0,
                1
            )

        Blur.Size =
            BlurValue

        LastLook =
            camera.CFrame.LookVector

        return
    end

    Blur.Enabled = true

    local look =
        camera.CFrame.LookVector

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

    local angle =
        math.acos(dot)

    local strength =
        CFG.BlurAmount /
        100

    local target =
        math.clamp(
            angle *
            180 *
            strength *
            2,
            0,
            24
        )

    BlurValue +=
        (target-BlurValue) *
        math.clamp(
            dt*12,
            0,
            1
        )

    Blur.Size =
        BlurValue

    LastLook =
        look

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

    for _,obj in ipairs(
        Lighting:GetChildren()
    ) do

        if
            obj.Name ==
            "MonotonSky"
            or
            obj.Name ==
            "MonotonAtmosphere"
        then

            obj:Destroy()

        end

    end

end

local function MakeSky(textures)

    ClearSky()

    local sky =
        Instance.new("Sky")

    sky.Name =
        "MonotonSky"

    sky.SkyboxBk = textures[1]
    sky.SkyboxDn = textures[2]
    sky.SkyboxFt = textures[3]
    sky.SkyboxLf = textures[4]
    sky.SkyboxRt = textures[5]
    sky.SkyboxUp = textures[6]

    sky.CelestialBodiesShown =
        false

    sky.Parent =
        Lighting

end

local function UpdateSky()

    if LastSky ==
        CFG.Sky
    then
        return
    end

    LastSky =
        CFG.Sky

    if CFG.Sky ==
        "Default"
    then

        ClearSky()

    elseif CFG.Sky ==
        "Galaxy"
    then

        MakeSky(Galaxy)

    elseif CFG.Sky ==
        "Black Hole"
    then

        MakeSky(Galaxy)

        local a =
            Instance.new(
                "Atmosphere"
            )

        a.Name =
            "MonotonAtmosphere"

        a.Density = .5
        a.Haze = 2
        a.Glare = .25

        a.Color =
            Color3.fromRGB(
                70,
                35,
                90
            )

        a.Decay =
            Color3.fromRGB(
                10,
                5,
                15
            )

        a.Parent =
            Lighting

    elseif CFG.Sky ==
        "Northern"
    then

        MakeSky(Galaxy)

        local a =
            Instance.new(
                "Atmosphere"
            )

        a.Name =
            "MonotonAtmosphere"

        a.Density = .22
        a.Haze = .8
        a.Glare = .35

        a.Color =
            Color3.fromRGB(
                70,
                220,
                145
            )

        a.Decay =
            Color3.fromRGB(
                5,
                50,
                30
            )

        a.Parent =
            Lighting

    elseif CFG.Sky ==
        "Black"
    then

        ClearSky()

        local a =
            Instance.new(
                "Atmosphere"
            )

        a.Name =
            "MonotonAtmosphere"

        a.Density = 1
        a.Haze = 10
        a.Glare = 0

        a.Color =
            Color3.new(0,0,0)

        a.Decay =
            Color3.new(0,0,0)

        a.Parent =
            Lighting

    end

end

--========================================================--
-- MOVEMENT
--========================================================--

local function UpdateMovement()

    local char =
        LP.Character

    if not char then
        return
    end

    local hum =
        char:
        FindFirstChildOfClass(
            "Humanoid"
        )

    if not hum then
        return
    end

    if CFG.SpeedHack then

        hum.WalkSpeed =
            CFG.Speed

    else

        hum.WalkSpeed =
            16

    end

    if CFG.JumpBoost then

        hum.UseJumpPower =
            true

        hum.JumpPower =
            CFG.JumpPower

    end

end

UIS.JumpRequest:Connect(function()

    if not CFG.AirJump then
        return
    end

    local char =
        LP.Character

    local root =
        char
        and
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if root then

        root.AssemblyLinearVelocity =
            Vector3.new(
                root.AssemblyLinearVelocity.X,
                CFG.JumpPower,
                root.AssemblyLinearVelocity.Z
            )

    end

end)

--========================================================--
-- CHARACTER
--========================================================--

LP.CharacterAdded:Connect(function()

    task.wait(1)

    if SnowHatModel then
        RemoveSnowHat()
    end

    pcall(UpdateMovement)

end)

--========================================================--
-- FONT / ACCENT REFRESH
--========================================================--

local function ApplyVisualSettings()

    local font =
        FONTS[CFG.Font]
        or
        FONTS.Gotham

    for _,obj in ipairs(
        GUI:GetDescendants()
    ) do

        if obj:IsA(
            "TextLabel"
        )
        or obj:IsA(
            "TextButton"
        )
        or obj:IsA(
            "TextBox"
        )
        then

            pcall(function()
                obj.Font = font
            end)

        end

    end

    local accent =
        GetAccent()

    MainStroke.Color =
        accent

    MStroke.Color =
        accent

    for _,obj in ipairs(
        GUI:GetDescendants()
    ) do

        if obj:IsA(
            "UIStroke"
        ) then

            obj.Color =
                accent

        end

    end

end

--========================================================--
-- MAIN LOOP
--========================================================--

local timer = 0
local refresh = 0

RunService.RenderStepped:Connect(
    function(dt)

        pcall(function()
            UpdateBlur(dt)
        end)

        pcall(function()
            UpdateNight()
        end)

        pcall(function()
            UpdateWorldParticles(dt)
        end)

        timer += dt

        if timer >= .3 then

            timer = 0

            pcall(function()
                UpdateMovement()
            end)

            pcall(function()
                UpdateChams()
            end)

            pcall(function()
                UpdateESP()
            end)

            pcall(function()
                UpdateSky()
            end)

        end

        refresh += dt

        if refresh >= 1 then

            refresh = 0

            pcall(function()
                ApplyVisualSettings()
            end)

        end

    end
)

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

print(
    "[MonotonVisuals] V1.1 loaded"
)

print(
    "[MonotonVisuals] Permanent key system ready"
)
