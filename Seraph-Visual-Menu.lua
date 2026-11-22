-- mod made by seraph
-- SERAPH | KONTRA VISUAL MENU
-- Visual-only client interface. No gameplay automation, exploit, or anti-cheat bypass.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then return end

local playerGui = player:WaitForChild("PlayerGui")
local previous = playerGui:FindFirstChild("SeraphVisualMenu")
if previous then previous:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "SeraphVisualMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local black = Color3.fromRGB(12, 12, 14)
local panel = Color3.fromRGB(22, 22, 25)
local muted = Color3.fromRGB(115, 115, 122)
local white = Color3.fromRGB(240, 240, 242)

local window = make("Frame", {
    Name = "Window",
    Size = UDim2.fromOffset(430, 292),
    Position = UDim2.new(0.5, -215, 0.5, -146),
    BackgroundColor3 = black,
    BorderSizePixel = 0
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, window)
make("UIStroke", {Color = Color3.fromRGB(70, 70, 76), Transparency = 0.15, Thickness = 1}, window)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = panel,
    BorderSizePixel = 0
}, window)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, top)
make("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = panel,
    BorderSizePixel = 0
}, top)

make("TextLabel", {
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.fromOffset(16, 0),
    BackgroundTransparency = 1,
    Text = "SERAPH  /  KONTRA",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = make("TextButton", {
    Size = UDim2.fromOffset(30, 28),
    Position = UDim2.new(1, -40, 0, 10),
    BackgroundColor3 = Color3.fromRGB(48, 48, 53),
    Text = "×",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 19,
    BorderSizePixel = 0,
    AutoButtonColor = false
}, top)
make("UICorner", {CornerRadius = UDim.new(0, 7)}, close)

local body = make("Frame", {
    Size = UDim2.new(1, -28, 1, -64),
    Position = UDim2.fromOffset(14, 56),
    BackgroundTransparency = 1
}, window)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "VISUAL SETTINGS",
    TextColor3 = muted,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, body)

local fpsEnabled = false
local crosshairEnabled = false
local compactEnabled = false
local fpsLabel
local crosshair
local closed = false
local renderConnection

fpsLabel = make("TextLabel", {
    Size = UDim2.fromOffset(112, 27),
    Position = UDim2.fromOffset(14, 14),
    BackgroundColor3 = black,
    Text = "FPS  0",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    Visible = false,
    BorderSizePixel = 0
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 6)}, fpsLabel)
make("UIStroke", {Color = Color3.fromRGB(75, 75, 80), Thickness = 1}, fpsLabel)

crosshair = make("TextLabel", {
    Size = UDim2.fromOffset(40, 40),
    Position = UDim2.new(0.5, -20, 0.5, -20),
    BackgroundTransparency = 1,
    Text = "+",
    TextColor3 = white,
    TextStrokeTransparency = 0.25,
    Font = Enum.Font.GothamBold,
    TextSize = 27,
    Visible = false
}, gui)

local function addToggle(label, y, initial, callback)
    local row = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 42),
        Position = UDim2.fromOffset(0, y),
        BackgroundColor3 = panel,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    }, body)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, row)

    make("TextLabel", {
        Size = UDim2.new(1, -72, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = white,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local track = make("Frame", {
        Size = UDim2.fromOffset(36, 20),
        Position = UDim2.new(1, -48, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(58, 58, 64),
        BorderSizePixel = 0
    }, row)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, track)

    local knob = make("Frame", {
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = white,
        BorderSizePixel = 0
    }, track)
    make("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)

    local state = initial == true
    local function paint(instant)
        local info = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local trackColor = state and Color3.fromRGB(205, 205, 210) or Color3.fromRGB(58, 58, 64)
        local knobPosition = state and UDim2.fromOffset(19, 3) or UDim2.fromOffset(3, 3)
        if instant then
            track.BackgroundColor3 = trackColor
            knob.Position = knobPosition
        else
            TweenService:Create(track, info, {BackgroundColor3 = trackColor}):Play()
            TweenService:Create(knob, info, {Position = knobPosition}):Play()
        end
    end
    paint(true)

    row.Activated:Connect(function()
        state = not state
        paint(false)
        callback(state)
    end)
    return row
end

addToggle("Screen Crosshair", 29, false, function(value)
    crosshairEnabled = value
    crosshair.Visible = value
end)

addToggle("FPS Counter", 79, false, function(value)
    fpsEnabled = value
    fpsLabel.Visible = value
end)

addToggle("Compact Window", 129, false, function(value)
    compactEnabled = value
    local target = value and UDim2.fromOffset(430, 242) or UDim2.fromOffset(430, 292)
    TweenService:Create(window, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = target
    }):Play()
end)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 1, -18),
    BackgroundTransparency = 1,
    Text = "SERAPH PROJECT  •  VISUAL EDITION",
    TextColor3 = muted,
    Font = Enum.Font.Gotham,
    TextSize = 9
}, body)

local frameCount = 0
local elapsed = 0
renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
    if closed then return end
    frameCount += 1
    elapsed += deltaTime
    if elapsed >= 1 then
        fpsLabel.Text = "FPS  " .. tostring(frameCount)
        frameCount = 0
        elapsed = 0
    end
end)

-- Drag the window using its title bar.
local dragging = false
local dragInput
local dragStart
local startPosition

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position
        dragInput = input
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

close.Activated:Connect(function()
    if closed then return end
    closed = true
    if renderConnection then renderConnection:Disconnect() end
    gui:Destroy()
end)

print("[SERAPH] Visual menu loaded.")
