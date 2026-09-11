--========================================================--
-- MONOTON VISUALS V1.0
-- FULL STABLE FIX
--========================================================--

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer

if not LP then
    return
end

--========================================================--
-- CONFIG
--========================================================--

local CFG = {
    Smooth = false,
    SmoothAmount = 50,

    Chams = false,
    ChamsColor = Color3.fromRGB(255, 185, 215),

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

    Sky = "Default"
}

--========================================================--
-- COLORS
--========================================================--

local BLACK = Color3.fromRGB(6, 6, 8)
local DARK = Color3.fromRGB(12, 12, 15)
local DARK2 = Color3.fromRGB(18, 18, 22)
local DARK3 = Color3.fromRGB(27, 27, 32)

local WHITE = Color3.fromRGB(245, 245, 248)
local GRAY = Color3.fromRGB(145, 145, 155)

local PINK = Color3.fromRGB(255, 185, 215)
local PINK2 = Color3.fromRGB(255, 210, 230)

--========================================================--
-- SAFE CALL
--========================================================--

local function Safe(fn, ...)
    local args = {...}

    return pcall(function()
        return fn(table.unpack(args))
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

    local pg = LP:FindFirstChildOfClass("PlayerGui")

    if pg then
        return pg
    end

    return LP:WaitForChild("PlayerGui", 10)
end

local GUI_PARENT = GetParent()

if not GUI_PARENT then
    return
end

--========================================================--
-- DESTROY OLD VERSION
--========================================================--

pcall(function()

    for _, parent in ipairs({
        GUI_PARENT,
        LP:FindFirstChildOfClass("PlayerGui")
    }) do

        if parent then

            local old = parent:FindFirstChild(
                "MonotonVisuals"
            )

            if old then
                old:Destroy()
            end

        end

    end

end)

--========================================================--
-- INSTANCE HELPER
--========================================================--

local function New(class, properties, parent)

    local obj = Instance.new(class)

    for property, value in pairs(properties or {}) do

        pcall(function()
            obj[property] = value
        end)

    end

    if parent then

        local ok = pcall(function()
            obj.Parent = parent
        end)

        if not ok then
            obj:Destroy()
            return nil
        end

    end

    return obj
end

local function Corner(obj, radius)

    if not obj then
        return
    end

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj

end

local function Stroke(
    obj,
    color,
    transparency,
    thickness
)

    if not obj then
        return
    end

    local s = Instance.new("UIStroke")

    s.Color = color or PINK
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1

    s.Parent = obj

end

local function Tween(
    obj,
    time,
    properties
)

    if not obj then
        return
    end

    pcall(function()

        TweenService:Create(
            obj,
            TweenInfo.new(
                time or 0.4,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            properties
        ):Play()

    end)

end

--========================================================--
-- SCREEN GUI
-- IMPORTANT: CREATED BEFORE ANY FEATURES
--========================================================--

local GUI = New(
    "ScreenGui",
    {
        Name = "MonotonVisuals",

        ResetOnSpawn = false,

        IgnoreGuiInset = true,

        ZIndexBehavior =
            Enum.ZIndexBehavior.Global,

        DisplayOrder = 999999,

        Enabled = true
    },
    GUI_PARENT
)

if not GUI then
    return
end

--========================================================--
-- KEY SYSTEM
--========================================================--

local KEY = "Free"
local KEY_TIME = 90 * 60 * 60
local KEY_FILE = "MonotonVisuals_Key.txt"

local FileAPI = {
    Read = type(readfile) == "function",
    Write = type(writefile) == "function",
    IsFile = type(isfile) == "function"
}

local Activation = nil

local function LoadKey()

    if not (
        FileAPI.Read
        and
        FileAPI.IsFile
    ) then
        return nil
    end

    local ok, value = pcall(function()

        if isfile(KEY_FILE) then

            local data = readfile(KEY_FILE)

            return tonumber(data)

        end

        return nil

    end)

    if ok then
        return value
    end

    return nil
end

local function SaveKey(timestamp)

    if not (
        FileAPI.Write
    ) then
        return
    end

    pcall(function()

        writefile(
            KEY_FILE,
            tostring(timestamp)
        )

    end)

end

Activation = LoadKey()

local function KeyActive()

    if not Activation then
        return false
    end

    local elapsed =
        os.time() - Activation

    return elapsed >= 0
        and elapsed < KEY_TIME
end

local function RemainingHours()

    if not Activation then
        return 0
    end

    local remaining =
        KEY_TIME -
        (os.time() - Activation)

    if remaining <= 0 then
        return 0
    end

    return math.floor(
        remaining / 3600
    )
end

--========================================================--
-- KEY GUI
--========================================================--

local KeyFrame = New(
    "Frame",
    {
        Name = "KeyFrame",

        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        Position =
            UDim2.fromScale(
                0.5,
                0.5
            ),

        Size =
            UDim2.fromOffset(
                390,
                245
            ),

        BackgroundColor3 = DARK,

        BorderSizePixel = 0,

        Visible = not KeyActive(),

        ZIndex = 5000
    },
    GUI
)

Corner(KeyFrame, 16)
Stroke(
    KeyFrame,
    PINK,
    0.65,
    1
)

-- watermark

New(
    "TextLabel",
    {
        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        Position =
            UDim2.fromScale(
                0.5,
                0.55
            ),

        Size =
            UDim2.fromScale(
                1,
                1
            ),

        BackgroundTransparency = 1,

        Text = "MONOTON",

        TextColor3 = PINK,

        TextTransparency = 0.94,

        TextSize = 55,

        Font =
            Enum.Font.GothamBlack,

        ZIndex = 5001
    },
    KeyFrame
)

New(
    "TextLabel",
    {
        Position =
            UDim2.fromOffset(
                24,
                20
            ),

        Size =
            UDim2.new(
                1,
                -48,
                0,
                30
            ),

        BackgroundTransparency = 1,

        Text = "MONOTON VISUALS",

        TextColor3 = WHITE,

        TextSize = 20,

        Font =
            Enum.Font.GothamBold,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 5002
    },
    KeyFrame
)

New(
    "TextLabel",
    {
        Position =
            UDim2.fromOffset(
                25,
                52
            ),

        Size =
            UDim2.new(
                1,
                -50,
                0,
                22
            ),

        BackgroundTransparency = 1,

        Text =
            "90 hour activation system",

        TextColor3 = GRAY,

        TextSize = 12,

        Font =
            Enum.Font.Gotham,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 5002
    },
    KeyFrame
)

local KeyBox = New(
    "TextBox",
    {
        Position =
            UDim2.fromOffset(
                24,
                88
            ),

        Size =
            UDim2.new(
                1,
                -48,
                0,
                43
            ),

        BackgroundColor3 = DARK2,

        BorderSizePixel = 0,

        PlaceholderText =
            "Enter key",

        PlaceholderColor3 =
            GRAY,

        Text = "",

        TextColor3 = WHITE,

        TextSize = 13,

        Font =
            Enum.Font.Gotham,

        ClearTextOnFocus = false,

        ZIndex = 5003
    },
    KeyFrame
)

Corner(KeyBox, 9)

Stroke(
    KeyBox,
    PINK,
    0.8,
    1
)

local KeyButton = New(
    "TextButton",
    {
        Position =
            UDim2.fromOffset(
                24,
                141
            ),

        Size =
            UDim2.new(
                1,
                -48,
                0,
                40
            ),

        BackgroundColor3 = PINK,

        BorderSizePixel = 0,

        Text = "ACTIVATE",

        TextColor3 = BLACK,

        TextSize = 13,

        Font =
            Enum.Font.GothamBold,

        AutoButtonColor = false,

        ZIndex = 5003
    },
    KeyFrame
)

Corner(KeyButton, 9)

local KeyStatus = New(
    "TextLabel",
    {
        Position =
            UDim2.fromOffset(
                24,
                188
            ),

        Size =
            UDim2.new(
                1,
                -48,
                0,
                22
            ),

        BackgroundTransparency = 1,

        Text =
            FileAPI.Read
            and
            "Key: Free • 90 hours • saved"
            or
            "Key: Free • 90 hours • session",

        TextColor3 = GRAY,

        TextSize = 11,

        Font =
            Enum.Font.Gotham,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 5003
    },
    KeyFrame
)

--========================================================--
-- MAIN GUI
--========================================================--

local Main = New(
    "Frame",
    {
        Name = "Main",

        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        Position =
            UDim2.fromScale(
                0.5,
                0.5
            ),

        Size =
            UDim2.fromOffset(
                520,
                330
            ),

        BackgroundColor3 = DARK,

        BorderSizePixel = 0,

        Visible = false,

        ZIndex = 100
    },
    GUI
)

Corner(Main, 15)

Stroke(
    Main,
    PINK,
    0.72,
    1
)

--========================================================--
-- WATERMARK
--========================================================--

New(
    "TextLabel",
    {
        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        Position =
            UDim2.fromScale(
                0.69,
                0.60
            ),

        Size =
            UDim2.new(
                0.75,
                0,
                0,
                90
            ),

        BackgroundTransparency = 1,

        Text =
            "MonotonVisuals v1.0",

        TextColor3 = PINK,

        TextTransparency = 0.93,

        TextSize = 38,

        Font =
            Enum.Font.GothamBlack,

        Rotation = -8,

        ZIndex = 100
    },
    Main
)

--========================================================--
-- HEADER
--========================================================--

New(
    "TextLabel",
    {
        Position =
            UDim2.fromOffset(
                18,
                13
            ),

        Size =
            UDim2.fromOffset(
                300,
                28
            ),

        BackgroundTransparency = 1,

        Text = "MONOTON",

        TextColor3 = WHITE,

        TextSize = 21,

        Font =
            Enum.Font.GothamBold,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 110
    },
    Main
)

New(
    "TextLabel",
    {
        Position =
            UDim2.fromOffset(
                19,
                40
            ),

        Size =
            UDim2.fromOffset(
                100,
                18
            ),

        BackgroundTransparency = 1,

        Text = "VISUALS V1.0",

        TextColor3 = PINK,

        TextSize = 10,

        Font =
            Enum.Font.GothamBold,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 110
    },
    Main
)

local CloseButton = New(
    "TextButton",
    {
        Position =
            UDim2.new(
                1,
                -43,
                0,
                14
            ),

        Size =
            UDim2.fromOffset(
                30,
                30
            ),

        BackgroundColor3 = DARK2,

        BorderSizePixel = 0,

        Text = "×",

        TextColor3 = GRAY,

        TextSize = 20,

        Font =
            Enum.Font.Gotham,

        AutoButtonColor = false,

        ZIndex = 110
    },
    Main
)

Corner(CloseButton, 8)

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar = New(
    "Frame",
    {
        Position =
            UDim2.fromOffset(
                12,
                72
            ),

        Size =
            UDim2.fromOffset(
                130,
                245
            ),

        BackgroundColor3 = BLACK,

        BorderSizePixel = 0,

        ZIndex = 110
    },
    Main
)

Corner(Sidebar, 11)

local Tabs = {
    "Home",
    "Visuals",
    "Rage",
    "Models",
    "Settings",
    "Info"
}

local TabButtons = {}

for i, name in ipairs(Tabs) do

    local button = New(
        "TextButton",
        {
            Position =
                UDim2.fromOffset(
                    7,
                    7 + (i - 1) * 38
                ),

            Size =
                UDim2.new(
                    1,
                    -14,
                    0,
                    32
                ),

            BackgroundColor3 = DARK2,

            BorderSizePixel = 0,

            Text = name,

            TextColor3 = GRAY,

            TextSize = 13,

            Font =
                Enum.Font.GothamMedium,

            AutoButtonColor = false,

            ZIndex = 111
        },
        Sidebar
    )

    Corner(button, 7)

    TabButtons[name] = button
end

--========================================================--
-- CONTENT
--========================================================--

local Content = New(
    "Frame",
    {
        Position =
            UDim2.fromOffset(
                150,
                72
            ),

        Size =
            UDim2.new(
                1,
                -162,
                1,
                -84
            ),

        BackgroundColor3 =
            Color3.fromRGB(
                17,
                17,
                20
            ),

        BorderSizePixel = 0,

        ZIndex = 110
    },
    Main
)

Corner(Content, 11)

local PageHolder = New(
    "Frame",
    {
        Position =
            UDim2.fromOffset(
                10,
                10
            ),

        Size =
            UDim2.new(
                1,
                -20,
                1,
                -20
            ),

        BackgroundTransparency = 1,

        ZIndex = 111
    },
    Content
)

--========================================================--
-- PAGES
--========================================================--

local Pages = {}

local function CreatePage(name)

    local page = New(
        "ScrollingFrame",
        {
            Name = name,

            Size =
                UDim2.fromScale(
                    1,
                    1
                ),

            BackgroundTransparency = 1,

            BorderSizePixel = 0,

            ScrollBarThickness = 2,

            ScrollBarImageColor3 = PINK,

            CanvasSize =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                ),

            Visible = false,

            ZIndex = 112
        },
        PageHolder
    )

    local layout = New(
        "UIListLayout",
        {
            Padding =
                UDim.new(
                    0,
                    8
                ),

            SortOrder =
                Enum.SortOrder.LayoutOrder
        },
        page
    )

    layout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(function()

        page.CanvasSize =
            UDim2.new(
                0,
                0,
                0,
                layout.AbsoluteContentSize.Y + 10
            )

    end)

    Pages[name] = page

    return page
end

local Home = CreatePage("Home")
local Visuals = CreatePage("Visuals")
local Rage = CreatePage("Rage")
local Models = CreatePage("Models")
local Settings = CreatePage("Settings")
local Info = CreatePage("Info")

--========================================================--
-- COMPONENTS
--========================================================--

local function Label(
    parent,
    text,
    height
)

    return New(
        "TextLabel",
        {
            Size =
                UDim2.new(
                    1,
                    -4,
                    0,
                    height or 28
                ),

            BackgroundTransparency = 1,

            Text = text,

            TextColor3 = WHITE,

            TextSize = 13,

            Font =
                Enum.Font.GothamMedium,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            ZIndex = 113
        },
        parent
    )
end

local function Section(
    parent,
    text
)

    local x =
        Label(
            parent,
            text,
            26
        )

    x.TextColor3 = PINK
    x.TextSize = 12
    x.Font = Enum.Font.GothamBold

end

local function Toggle(
    parent,
    text,
    value,
    callback
)

    local holder = New(
        "Frame",
        {
            Size =
                UDim2.new(
                    1,
                    -4,
                    0,
                    40
                ),

            BackgroundColor3 = DARK2,

            BorderSizePixel = 0,

            ZIndex = 113
        },
        parent
    )

    Corner(holder, 8)

    New(
        "TextLabel",
        {
            Position =
                UDim2.fromOffset(
                    12,
                    0
                ),

            Size =
                UDim2.new(
                    1,
                    -65,
                    1,
                    0
                ),

            BackgroundTransparency = 1,

            Text = text,

            TextColor3 = WHITE,

            TextSize = 13,

            Font =
                Enum.Font.Gotham,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            ZIndex = 114
        },
        holder
    )

    local switch = New(
        "TextButton",
        {
            Position =
                UDim2.new(
                    1,
                    -48,
                    0.5,
                    -11
                ),

            Size =
                UDim2.fromOffset(
                    38,
                    22
                ),

            BackgroundColor3 =
                value
                and PINK
                or
                DARK3,

            BorderSizePixel = 0,

            Text = "",

            AutoButtonColor = false,

            ZIndex = 114
        },
        holder
    )

    Corner(switch, 12)

    local state = value

    switch.Activated:Connect(function()

        state = not state

        Tween(
            switch,
            0.35,
            {
                BackgroundColor3 =
                    state
                    and PINK
                    or
                    DARK3
            }
        )

        pcall(
            callback,
            state
        )

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

    local holder = New(
        "Frame",
        {
            Size =
                UDim2.new(
                    1,
                    -4,
                    0,
                    58
                ),

            BackgroundColor3 = DARK2,

            BorderSizePixel = 0,

            ZIndex = 113
        },
        parent
    )

    Corner(holder, 8)

    New(
        "TextLabel",
        {
            Position =
                UDim2.fromOffset(
                    12,
                    5
                ),

            Size =
                UDim2.new(
                    1,
                    -65,
                    0,
                    20
                ),

            BackgroundTransparency = 1,

            Text = text,

            TextColor3 = WHITE,

            TextSize = 12,

            Font =
                Enum.Font.Gotham,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            ZIndex = 114
        },
        holder
    )

    local valueLabel = New(
        "TextLabel",
        {
            Position =
                UDim2.new(
                    1,
                    -58,
                    0,
                    5
                ),

            Size =
                UDim2.fromOffset(
                    48,
                    20
                ),

            BackgroundTransparency = 1,

            Text = tostring(default),

            TextColor3 = PINK,

            TextSize = 12,

            Font =
                Enum.Font.GothamBold,

            TextXAlignment =
                Enum.TextXAlignment.Right,

            ZIndex = 114
        },
        holder
    )

    local bar = New(
        "Frame",
        {
            Position =
                UDim2.fromOffset(
                    12,
                    35
                ),

            Size =
                UDim2.new(
                    1,
                    -24,
                    0,
                    5
                ),

            BackgroundColor3 =
                DARK3,

            BorderSizePixel = 0,

            ZIndex = 114
        },
        holder
    )

    Corner(bar, 5)

    local fill = New(
        "Frame",
        {
            Size =
                UDim2.new(
                    (
                        default - min
                    ) /
                    (
                        max - min
                    ),
                    0,
                    1,
                    0
                ),

            BackgroundColor3 = PINK,

            BorderSizePixel = 0,

            ZIndex = 115
        },
        bar
    )

    Corner(fill, 5)

    local dragging = false

    local function Set(value)

        value =
            math.clamp(
                value,
                min,
                max
            )

        local percent =
            (
                value - min
            ) /
            (
                max - min
            )

        fill.Size =
            UDim2.new(
                percent,
                0,
                1,
                0
            )

        valueLabel.Text =
            tostring(
                math.floor(value)
            )

        pcall(
            callback,
            value
        )

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
                (
                    max - min
                ) *
                (
                    x /
                    bar.AbsoluteSize.X
                )
            )

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

            local x =
                math.clamp(
                    input.Position.X -
                    bar.AbsolutePosition.X,
                    0,
                    bar.AbsoluteSize.X
                )

            Set(
                min +
                (
                    max - min
                ) *
                (
                    x /
                    bar.AbsoluteSize.X
                )
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

local function Button(
    parent,
    text,
    callback
)

    local button = New(
        "TextButton",
        {
            Size =
                UDim2.new(
                    1,
                    -4,
                    0,
                    40
                ),

            BackgroundColor3 = DARK2,

            BorderSizePixel = 0,

            Text = text,

            TextColor3 = WHITE,

            TextSize = 13,

            Font =
                Enum.Font.GothamMedium,

            AutoButtonColor = false,

            ZIndex = 113
        },
        parent
    )

    Corner(button, 8)

    button.Activated:Connect(function()

        pcall(callback)

    end)

end

--========================================================--
-- HOME PAGE
--========================================================--

Section(
    Home,
    "MONOTON VISUALS"
)

Label(
    Home,
    "Clean black / white / soft pink interface",
    28
)

Label(
    Home,
    "Version 1.0",
    25
)

Label(
    Home,
    KeyActive()
    and
    (
        "Key active • " ..
        tostring(
            RemainingHours()
        ) ..
        "h remaining"
    )
    or
    "Key inactive",
    25
)

--========================================================--
-- VISUALS PAGE
--========================================================--

Section(
    Visuals,
    "MOTION"
)

Toggle(
    Visuals,
    "Motion Blur",
    false,
    function(v)
        CFG.Smooth = v
    end
)

Slider(
    Visuals,
    "Blur Amount",
    0,
    100,
    50,
    function(v)
        CFG.SmoothAmount = v
    end
)

Section(
    Visuals,
    "PLAYER"
)

Toggle(
    Visuals,
    "Chams Fill",
    false,
    function(v)
        CFG.Chams = v
    end
)

Toggle(
    Visuals,
    "ESP Box",
    false,
    function(v)
        CFG.ESP = v
    end
)

Section(
    Visuals,
    "EFFECTS"
)

Toggle(
    Visuals,
    "Sakura Leaves",
    false,
    function(v)
        CFG.SakuraLeaves = v
    end
)

Toggle(
    Visuals,
    "Snow",
    false,
    function(v)
        CFG.Snow = v
    end
)

Toggle(
    Visuals,
    "Stars",
    false,
    function(v)
        CFG.Stars = v
    end
)

Toggle(
    Visuals,
    "Sakura Aura",
    false,
    function(v)
        CFG.SakuraAura = v
    end
)

Section(
    Visuals,
    "NIGHT"
)

Toggle(
    Visuals,
    "Night Mode",
    false,
    function(v)
        CFG.Night = v
    end
)

Slider(
    Visuals,
    "Darkness",
    0,
    100,
    35,
    function(v)
        CFG.NightDarkness = v
    end
)

Section(
    Visuals,
    "SKY"
)

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
    "Black",
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

--========================================================--
-- RAGE PAGE
--========================================================--

Section(
    Rage,
    "MOVEMENT"
)

Toggle(
    Rage,
    "Jump Boost",
    false,
    function(v)
        CFG.JumpBoost = v
    end
)

Slider(
    Rage,
    "Jump Power",
    50,
    150,
    50,
    function(v)
        CFG.JumpPower = v
    end
)

Toggle(
    Rage,
    "Air Jump",
    false,
    function(v)
        CFG.AirJump = v
    end
)

Toggle(
    Rage,
    "Speed Hack",
    false,
    function(v)
        CFG.SpeedHack = v
    end
)

Slider(
    Rage,
    "Speed",
    16,
    150,
    16,
    function(v)
        CFG.Speed = v
    end
)

--========================================================--
-- MODELS
--========================================================--

Section(
    Models,
    "MODELS"
)

Button(
    Models,
    "Tung Model",
    function()

        -- intentionally isolated:
        -- model loader can vary by executor.
        -- GUI will NOT break if unavailable.

        local ok, fn =
            pcall(function()
                return loadstring(
                    game:HttpGet(
                        "https://raw.githubusercontent.com/"
                    )
                )
            end)

        -- no external model dependency
        -- to keep the main GUI stable.

    end
)

Label(
    Models,
    "Tung Model ID: 94088572446024",
    25
)

--========================================================--
-- SETTINGS
--========================================================--

Section(
    Settings,
    "MENU"
)

Button(
    Settings,
    "Reset Menu Position",
    function()

        Main.Position =
            UDim2.fromScale(
                0.5,
                0.5
            )

    end
)

Button(
    Settings,
    "Close Menu",
    function()

        Main.Visible = false

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
    "MonotonVisuals v1.0",
    28
)

Label(
    Info,
    "Free • 90 hour key",
    25
)

Label(
    Info,
    "Motion Blur does not modify camera sensitivity",
    30
)

Label(
    Info,
    "Sakura / Snow / Stars / Chams / ESP",
    28
)

--========================================================--
-- M BUTTON
--========================================================--

local M = New(
    "TextButton",
    {
        Name = "MonotonM",

        Position =
            UDim2.new(
                0,
                22,
                0.5,
                -29
            ),

        Size =
            UDim2.fromOffset(
                58,
                58
            ),

        BackgroundColor3 = BLACK,

        BorderSizePixel = 0,

        Text = "M",

        TextColor3 = PINK,

        TextSize = 27,

        Font =
            Enum.Font.GothamBold,

        AutoButtonColor = false,

        Active = true,

        Visible = KeyActive(),

        ZIndex = 3000
    },
    GUI
)

Corner(M, 17)

Stroke(
    M,
    PINK,
    0.2,
    1.5
)

--========================================================--
-- PAGE SYSTEM
--========================================================--

local function ShowPage(name)

    for pageName, page in pairs(Pages) do
        page.Visible =
            pageName == name
    end

    for tabName, button in pairs(TabButtons) do

        if tabName == name then

            button.BackgroundColor3 =
                Color3.fromRGB(
                    43,
                    29,
                    36
                )

            button.TextColor3 = PINK

        else

            button.BackgroundColor3 =
                DARK2

            button.TextColor3 =
                GRAY

        end

    end

end

for name, button in pairs(TabButtons) do

    button.Activated:Connect(function()
        ShowPage(name)
    end)

end

ShowPage("Home")

--========================================================--
-- MENU OPEN / CLOSE
--========================================================--

local function OpenMenu()

    if not Main then
        return
    end

    Main.Visible = true

    Main.Size =
        UDim2.fromOffset(
            500,
            315
        )

    Tween(
        Main,
        0.45,
        {
            Size =
                UDim2.fromOffset(
                    520,
                    330
                )
        }
    )

end

local function CloseMenu()

    if not Main then
        return
    end

    Main.Visible = false

end

M.Activated:Connect(function()

    if Main.Visible then
        CloseMenu()
    else
        OpenMenu()
    end

end)

CloseButton.Activated:Connect(function()
    CloseMenu()
end)

--========================================================--
-- DRAG M
--========================================================--

local Dragging = false
local DragStart = nil
local StartPosition = nil

M.InputBegan:Connect(function(input)

    if
        input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or
        input.UserInputType ==
        Enum.UserInputType.Touch
    then

        Dragging = true

        DragStart =
            input.Position

        StartPosition =
            M.Position

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

        Dragging = false

    end

end)

UIS.InputChanged:Connect(function(input)

    if not Dragging then
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
            DragStart

        M.Position =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset +
                    delta.X,

                StartPosition.Y.Scale,
                StartPosition.Y.Offset +
                    delta.Y
            )

    end

end)

--========================================================--
-- KEY ACTIVATION
--========================================================--

local function Activate()

    local input =
        tostring(
            KeyBox.Text or ""
        )

    input =
        input:gsub(
            "^%s+",
            ""
        ):gsub(
            "%s+$",
            ""
        )

    if input ~= KEY then

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

    Activation =
        os.time()

    SaveKey(
        Activation
    )

    KeyStatus.Text =
        "Activated successfully"

    KeyStatus.TextColor3 =
        PINK

    task.wait(0.35)

    KeyFrame.Visible = false
    Main.Visible = false
    M.Visible = true

    OpenMenu()

end

KeyButton.Activated:Connect(
    Activate
)

KeyBox.FocusLost:Connect(
    function(enter)

        if enter then
            Activate()
        end

    end
)

--========================================================--
-- VISUAL EFFECT OBJECTS
--========================================================--

local ChamsFolder = New(
    "Folder",
    {
        Name = "MonotonChams"
    },
    GUI
)

local ESPFolder = New(
    "Folder",
    {
        Name = "MonotonESP"
    },
    GUI
)

local EffectsFolder = New(
    "Folder",
    {
        Name = "MonotonEffects"
    },
    workspace
)

--========================================================--
-- CHAMS
--========================================================--

local function UpdateChams()

    if not ChamsFolder then
        return
    end

    if not CFG.Chams then

        for _, x in ipairs(
            ChamsFolder:GetChildren()
        ) do
            x:Destroy()
        end

        return
    end

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if
            player ~= LP
            and
            player.Character
        then

            local character =
                player.Character

            if not ChamsFolder:
                FindFirstChild(
                    character.Name
                )
            then

                local h =
                    Instance.new(
                        "Highlight"
                    )

                h.Name =
                    character.Name

                h.Adornee =
                    character

                h.FillColor =
                    CFG.ChamsColor

                h.FillTransparency =
                    0

                h.OutlineTransparency =
                    1

                h.DepthMode =
                    Enum.HighlightDepthMode.AlwaysOnTop

                h.Parent =
                    ChamsFolder

            end

        end

    end

end

--========================================================--
-- ESP
--========================================================--

local function UpdateESP()

    if not CFG.ESP then

        for _, x in ipairs(
            ESPFolder:GetChildren()
        ) do
            x:Destroy()
        end

        return
    end

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if
            player ~= LP
            and
            player.Character
        then

            local character =
                player.Character

            local root =
                character:
                FindFirstChild(
                    "HumanoidRootPart"
                )

            if
                root
                and
                not ESPFolder:
                    FindFirstChild(
                        character.Name
                    )
            then

                local box =
                    Instance.new(
                        "BoxHandleAdornment"
                    )

                box.Name =
                    character.Name

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

                box.Color3 =
                    PINK

                box.Transparency =
                    0.35

                box.Parent =
                    ESPFolder

            end

        end

    end

end

--========================================================--
-- NIGHT MODE
--========================================================--

local Original = {
    Brightness =
        Lighting.Brightness,

    Exposure =
        Lighting.ExposureCompensation,

    Ambient =
        Lighting.Ambient,

    Outdoor =
        Lighting.OutdoorAmbient
}

local function UpdateNight()

    if CFG.Night then

        local amount =
            CFG.NightDarkness /
            100

        Lighting.Brightness =
            math.max(
                0.1,
                Original.Brightness *
                (
                    1 -
                    amount *
                    0.9
                )
            )

        Lighting.ExposureCompensation =
            Original.Exposure -
            amount *
            1.5

        Lighting.Ambient =
            Color3.fromRGB(
                35,
                35,
                40
            )

        Lighting.OutdoorAmbient =
            Color3.fromRGB(
                35,
                35,
                40
            )

    else

        Lighting.Brightness =
            Original.Brightness

        Lighting.ExposureCompensation =
            Original.Exposure

        Lighting.Ambient =
            Original.Ambient

        Lighting.OutdoorAmbient =
            Original.Outdoor

    end

end

--========================================================--
-- MOTION BLUR
--========================================================--

local Blur = Lighting:FindFirstChild(
    "MonotonMotionBlur"
)

if Blur then
    Blur:Destroy()
end

Blur = Instance.new(
    "BlurEffect"
)

Blur.Name =
    "MonotonMotionBlur"

Blur.Size = 0

Blur.Enabled = false

Blur.Parent =
    Lighting

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

        BlurValue =
            BlurValue +
            (0 - BlurValue) *
            math.clamp(
                dt * 10,
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

    local current =
        camera.CFrame.LookVector

    if not LastLook then

        LastLook = current
        return

    end

    local dot =
        math.clamp(
            LastLook:Dot(
                current
            ),
            -1,
            1
        )

    local angle =
        math.acos(dot)

    local power =
        CFG.SmoothAmount /
        100

    local target =
        math.clamp(
            angle *
            180 *
            power *
            2,
            0,
            24
        )

    BlurValue =
        BlurValue +
        (
            target -
            BlurValue
        ) *
        math.clamp(
            dt * 12,
            0,
            1
        )

    Blur.Size =
        BlurValue

    LastLook =
        current

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

local LastSky = nil

local function RemoveSky()

    for _, obj in ipairs(
        Lighting:GetChildren()
    ) do

        if
            obj.Name ==
            "MonotonSky"
            or
            obj.Name ==
            "MonotonAtmosphere"
        then

            pcall(function()
                obj:Destroy()
            end)

        end

    end

end

local function CreateSky(
    textures
)

    RemoveSky()

    local sky =
        Instance.new("Sky")

    sky.Name =
        "MonotonSky"

    sky.SkyboxBk =
        textures[1]

    sky.SkyboxDn =
        textures[2]

    sky.SkyboxFt =
        textures[3]

    sky.SkyboxLf =
        textures[4]

    sky.SkyboxRt =
        textures[5]

    sky.SkyboxUp =
        textures[6]

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

        RemoveSky()

    elseif CFG.Sky ==
        "Galaxy"
    then

        CreateSky(
            Galaxy
        )

    elseif CFG.Sky ==
        "Black Hole"
    then

        CreateSky(
            Galaxy
        )

        local a =
            Instance.new(
                "Atmosphere"
            )

        a.Name =
            "MonotonAtmosphere"

        a.Density =
            0.5

        a.Haze =
            2

        a.Glare =
            0.25

        a.Color =
            Color3.fromRGB(
                75,
                35,
                95
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

        CreateSky(
            Galaxy
        )

        local a =
            Instance.new(
                "Atmosphere"
            )

        a.Name =
            "MonotonAtmosphere"

        a.Density =
            0.25

        a.Haze =
            0.8

        a.Glare =
            0.3

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

        -- Completely dark atmosphere.
        -- This is intentionally independent
        -- from Night Mode.

        RemoveSky()

        local a =
            Instance.new(
                "Atmosphere"
            )

        a.Name =
            "MonotonAtmosphere"

        a.Density =
            1

        a.Haze =
            10

        a.Glare =
            0

        a.Color =
            Color3.fromRGB(
                0,
                0,
                0
            )

        a.Decay =
            Color3.fromRGB(
                0,
                0,
                0
            )

        a.Parent =
            Lighting

    end

end

--========================================================--
-- EFFECT PARTICLES
--========================================================--

local ParticleGui = New(
    "Frame",
    {
        Name = "ParticleLayer",

        Size =
            UDim2.fromScale(
                1,
                1
            ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ZIndex = 20
    },
    GUI
)

local Particles = {}

for i = 1, 35 do

    local p = New(
        "Frame",
        {
            Size =
                UDim2.fromOffset(
                    5,
                    5
                ),

            Position =
                UDim2.new(
                    math.random(),
                    0,
                    math.random(),
                    0
                ),

            BackgroundColor3 = PINK,

            BackgroundTransparency =
                0.15,

            BorderSizePixel = 0,

            Visible = false,

            ZIndex = 21
        },
        ParticleGui
    )

    Corner(p, 20)

    table.insert(
        Particles,
        p
    )

end

local function UpdateParticles(dt)

    local mode = nil

    if CFG.Snow then
        mode = "Snow"
    elseif CFG.SakuraLeaves then
        mode = "Sakura"
    elseif CFG.Stars then
        mode = "Stars"
    end

    for i, p in ipairs(
        Particles
    ) do

        p.Visible =
            mode ~= nil

        if mode ==
            "Snow"
        then

            p.BackgroundColor3 =
                WHITE

            p.Size =
                UDim2.fromOffset(
                    3 + (i % 4),
                    3 + (i % 4)
                )

            p.Position =
                UDim2.new(
                    p.Position.X.Scale +
                    math.sin(
                        tick() +
                        i
                    ) *
                    0.0001,

                    0,

                    p.Position.Y.Scale +
                    dt *
                    0.05,

                    0
                )

        elseif mode ==
            "Sakura"
        then

            p.BackgroundColor3 =
                i % 2 == 0
                and PINK
                or
                PINK2

            p.Size =
                UDim2.fromOffset(
                    9,
                    5
                )

            p.Position =
                UDim2.new(
                    p.Position.X.Scale +
                    math.sin(
                        tick() *
                        0.8 +
                        i
                    ) *
                    0.0003,

                    0,

                    p.Position.Y.Scale +
                    dt *
                    0.025,

                    0
                )

        elseif mode ==
            "Stars"
        then

            p.BackgroundColor3 =
                WHITE

            p.Size =
                UDim2.fromOffset(
                    2 + (i % 2),
                    2 + (i % 2)
                )

            p.BackgroundTransparency =
                0.2 +
                math.abs(
                    math.sin(
                        tick() *
                        2 +
                        i
                    )
                ) *
                0.6

        end

        if p.Position.Y.Scale > 1.05 then

            p.Position =
                UDim2.new(
                    math.random(),
                    0,
                    -0.05,
                    0
                )

        end

    end

end

--========================================================--
-- SAKURA AURA
--========================================================--

local SakuraFolder = New(
    "Folder",
    {
        Name = "MonotonSakura"
    },
    EffectsFolder
)

local Sakura = {}

local function ClearSakura()

    for _, x in ipairs(Sakura) do

        pcall(function()
            x:Destroy()
        end)

    end

    table.clear(Sakura)

end

local function CreateSakura()

    ClearSakura()

    if not CFG.SakuraAura then
        return
    end

    for i = 1, 14 do

        local p =
            Instance.new(
                "Part"
            )

        p.Name =
            "SakuraPetal"

        p.Anchored = true

        p.CanCollide = false
        p.CanTouch = false
        p.CanQuery = false

        p.Material =
            Enum.Material.Neon

        p.Color =
            i % 2 == 0
            and PINK
            or
            PINK2

        p.Size =
            Vector3.new(
                0.3,
                0.06,
                0.2
            )

        p.Parent =
            SakuraFolder

        table.insert(
            Sakura,
            p
        )

    end

end

local function UpdateSakura()

    if not CFG.SakuraAura then

        if #Sakura > 0 then
            ClearSakura()
        end

        return
    end

    if #Sakura == 0 then
        CreateSakura()
    end

    local char =
        LP.Character

    local root =
        char
        and
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return
    end

    local t = tick()

    for i, p in ipairs(Sakura) do

        local angle =
            t * 0.8 +
            i * 0.45

        local radius =
            2.2 +
            math.sin(
                t * 1.2 + i
            ) *
            0.35

        local y =
            1.2 +
            math.sin(
                t * 1.5 + i
            ) *
            1.1

        p.CFrame =
            root.CFrame *
            CFrame.new(
                math.cos(angle) *
                    radius,

                y,

                math.sin(angle) *
                    radius
            ) *
            CFrame.Angles(
                0,
                angle,
                math.sin(
                    t + i
                )
            )

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

        hum.WalkSpeed = 16

    end

    if CFG.JumpBoost then

        pcall(function()

            hum.UseJumpPower =
                true

            hum.JumpPower =
                CFG.JumpPower

        end)

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
-- CHARACTER RESET
--========================================================--

LP.CharacterAdded:Connect(function()

    task.wait(1)

    pcall(
        UpdateMovement
    )

end)

--========================================================--
-- MAIN LOOP
--========================================================--

local UpdateTimer = 0

RunService.RenderStepped:Connect(
    function(dt)

        -- IMPORTANT:
        -- Every subsystem is isolated.
        -- One broken feature cannot kill GUI.

        pcall(function()
            UpdateBlur(dt)
        end)

        pcall(function()
            UpdateNight()
        end)

        pcall(function()
            UpdateParticles(dt)
        end)

        pcall(function()
            UpdateSakura()
        end)

        UpdateTimer =
            UpdateTimer + dt

        if UpdateTimer >= 0.35 then

            UpdateTimer = 0

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

    end
)

--========================================================--
-- FINAL VISIBILITY
--========================================================--

GUI.Enabled = true

if KeyActive() then

    KeyFrame.Visible = false
    Main.Visible = false
    M.Visible = true

else

    KeyFrame.Visible = true
    Main.Visible = false
    M.Visible = false

end

print(
    "[MonotonVisuals] GUI loaded"
)

print(
    "[MonotonVisuals] Key: Free"
)

print(
    "[MonotonVisuals] Duration: 90 hours"
)

print(
    "[MonotonVisuals] Stable loader enabled"
)