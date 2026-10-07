-- ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateDashboardCard
-- Script path: ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateDashboardCard
-- Decompile time: 4.20 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Router = require(ReplicatedStorage.Database.Security.Router)
local GuiShown = require(script.Parent.GuiShown)
local u24 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u29 = Color3.fromRGB(255, 196, 77)
local u35 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
local u42 = TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local u47 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u54 = TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local u59 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local u60 = {{4, 0.85}, {8, 0.94}}

local function multiplyUDim2(a1, a2) -- Line: 26 -- types: a1: userdata, a2: number
    return UDim2.new(a1.X.Scale * a2, a1.X.Offset, a1.Y.Scale * a2, a1.Y.Offset)
end

local function createGlowStroke(a1, a2, a3) -- Line: 32
    -- upvalues: u29 (val)
    local Frame = Instance.new("Frame")
    Frame.Name = "Glow"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 3
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "GlowStroke"
    UIStroke.Color = u29
    UIStroke.Thickness = a2
    UIStroke.Transparency = a3
    UIStroke.Parent = Frame
    Frame.Parent = a1
    return UIStroke
end

local function createGlowInstances(a1) -- Line: 53
    -- upvalues: createGlowStroke (val), u29 (val), TweenService (val), u35 (val), u60 (val)
    local v1 = createGlowStroke(a1, 1.5, 0.3)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, u29),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 190)),
        (ColorSequenceKeypoint.new(1, u29)),
    })
    UIGradient.Parent = v1
    local v2 = TweenService:Create(UIGradient, u35, {Rotation = 360})
    local v3 = {}
    for i, v in ipairs(u60) do
        table.insert(v3, (createGlowStroke(a1, v[1], v[2])))
    end
    return v1, v3, v2
end

local function createShineSweep(a1) -- Line: 76 -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = "Shine"
    Frame.Active = false
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 150
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = 20
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(0.6, 1),
        (NumberSequenceKeypoint.new(1, 1)),
    })
    UIGradient.Offset = Vector2.new(-1, 0)
    UIGradient.Parent = Frame
    Frame.Parent = a1
    return UIGradient
end

local function setupCardEffects(a1, a2) -- Line: 104
    -- upvalues: createGlowInstances (val), u60 (val), TweenService (val), u42 (val), u47 (val), u54 (val)
    -- upvalues: GuiShown (val), createShineSweep (val), u59 (val)
    local v1, v2, v3, v4, v5
    local v6, v7, u6 = createGlowInstances(a1)
    local u7 = {}
    for i, v in ipairs(v7) do
        v1 = u60[i][2]
        v3 = TweenService
        v4 = u42
        v5 = {Transparency = v1 - 0.08}
        v3 = v3:Create(v, v4, v5)
        table.insert(u7, v3)
    end
    local u20 = {}
    u20[1] = TweenService:Create(v6, u47, {Transparency = 0, Thickness = 2})
    local u29 = {}
    u29[1] = TweenService:Create(v6, u47, {Transparency = 0.3, Thickness = 1.5})
    for i2, i3 in ipairs(v7) do
        v2 = u60[i2][2]
        table.insert(u20, (TweenService:Create(i3, u47, {Transparency = 1})))
        table.insert(u29, (TweenService:Create(i3, u47, {Transparency = v2})))
    end
    local u50 = false
    a2.MouseEnter:Connect(function() -- Line: 128 -- upvalues: u50 (ref), u7 (val), u20 (val)
        u50 = true
        for i, v in ipairs(u7) do
            v:Cancel()
            u20[i + 1]:Play()
        end
        u20[1]:Play()
    end)
    a2.MouseLeave:Connect(function() -- Line: 136 -- upvalues: u50 (ref), u29 (val)
        u50 = false
        for i, v in ipairs(u29) do
            v:Play()
        end
    end)
    local u65 = false
    u29[1].Completed:Connect(function() -- Line: 144 -- upvalues: u65 (ref), u50 (ref), u7 (val)
        if u65 and not u50 then
            for i, v in ipairs(u7) do
                v:Play()
            end
        end
    end)
    local Discount = a1:FindFirstChild("Discount")
    local Discount_2 = Discount and Discount:FindFirstChild("Discount")
    local u92 = if not Discount_2 then nil else TweenService:Create(Discount_2, u54, {Rotation = Discount_2.Rotation + 4})
    GuiShown.Observe(a1, function(a1) -- Line: 159 -- upvalues: u65 (ref), u50 (ref), u7 (val), u6 (val), u92 (val) -- types: a1: boolean
        local v1
        table.insert(if not u50 then table.clone(u7) else {}, u6)
        if u92 then
            table.insert(v1, u92)
        end
        for i, j in v1 do
            if not a1 then
                j:Pause()
            else
                j:Play()
            end
        end
    end)
    local u112 = createShineSweep(a1)
    task.spawn(function() -- Line: 177 -- upvalues: TweenService (upval), u112 (val), u59 (upval), a1 (val), u65 (ref)
        local v1 = TweenService:Create(u112, u59, {Offset = Vector2.new(1, 0)})
        while a1.Parent do
            if u65 then
                v1:Play()
                v1.Completed:Wait()
                u112.Offset = Vector2.new(-1, 0)
            end
            task.wait(2.5)
        end
    end)
end

return function(a1, a2) -- Line: 195
    -- upvalues: setupCardEffects (val), TweenService (val), u24 (val), Router (val)
    setupCardEffects(a1, a2)
    local Size = a1.Size
    local u25 = TweenService:Create(a1, u24, {
        Size = UDim2.new(Size.X.Scale * 0.9, Size.X.Offset, Size.Y.Scale * 0.9, Size.Y.Offset),
    })
    local u44 = TweenService:Create(a1, u24, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset),
    })
    local u63 = TweenService:Create(a1, u24, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset),
    })
    local u82 = TweenService:Create(a1, u24, {
        Size = UDim2.new(Size.X.Scale * 1, Size.X.Offset, Size.Y.Scale * 1, Size.Y.Offset),
    })
    a2.MouseEnter:Connect(function() -- Line: 204 -- upvalues: Router (upval), u63 (val)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
        u63:Play()
    end)
    a2.MouseLeave:Connect(function() -- Line: 208 -- upvalues: u82 (val)
        u82:Play()
    end)
    a2.MouseButton1Down:Connect(function() -- Line: 211 -- upvalues: Router (upval), u25 (val)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u25:Play()
    end)
    a2.MouseButton1Up:Connect(function() -- Line: 215 -- upvalues: u44 (val)
        u44:Play()
    end)
end