-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.DeathmatchHealth
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.DeathmatchHealth
-- Decompile time: 2.84 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Sound = require(ReplicatedStorage.Classes.Sound)
local Router = require(ReplicatedStorage.Database.Security.Router)
local CurrentCamera = workspace.CurrentCamera
local u22 = nil
local u23 = nil
local u24 = 0
local u25 = 0

local function animateCross(a1) -- Line: 47 -- upvalues: u23 (ref), u22 (ref), TweenService (val) -- types: a1: number
    local u4 = u23:Clone()
    local u9 = 0.6 + math.random() * 0.4
    local Size = u23.Size

    local function scaledSize(a1) -- Line: 53 -- upvalues: Size (val) -- types: a1: number
        return UDim2.fromScale(Size.X.Scale * a1, Size.Y.Scale * a1)
    end

    local v1 = if not (math.random() < 0.5) then 1 else -1
    local v2 = math.random() ^ 0.5 * 0.44
    local v3 = 0.5 + v1 * v2
    local v4 = (math.clamp((v2 - 0.15) / 0.29000000000000004, 0, 1) * 0.3 + 0.3) * (0.9 + math.random() * 0.2)
    local u45 = {}
    u45[1] = {Label = u4, Authored = u23.ImageTransparency}
    for i, j in u4:GetDescendants() do
        if j:IsA("ImageLabel") then
            table.insert(u45, {Label = j, Authored = j.ImageTransparency})
        end
    end
    u4.Name = "Cross"
    u4.Visible = true
    u4.AnchorPoint = Vector2.new(0.5, 0.5)
    u4.Size = UDim2.fromScale(0, 0)
    u4.Position = UDim2.fromScale(v3, 1.04)
    u4.Rotation = (math.random() - 0.5) * 24
    for k, n in u45 do
        n.Label.ImageTransparency = 1
    end
    u4.Parent = u22
    local v5 = TweenService
    local v6 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local v7 = {}
    local v8 = u9 * 1.25
    v7.Size = UDim2.fromScale(Size.X.Scale * v8, Size.Y.Scale * v8)
    v5:Create(u4, v6, v7):Play()
    for m, i5 in u45 do
        TweenService:Create(
            i5.Label,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {ImageTransparency = i5.Authored}
        ):Play()
    end
    task.delay(0.12, function() -- Line: 104 -- upvalues: TweenService (upval), u4 (val), u9 (val), Size (val)
        local v1 = TweenService
        local v2 = u4
        local v3 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v4 = {}
        local v5 = u9
        v4.Size = UDim2.fromScale(Size.X.Scale * v5, Size.Y.Scale * v5)
        v1:Create(v2, v3, v4):Play()
    end)
    TweenService:Create(u4, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(v3 + (math.random() - 0.5) * 2 * 0.04, 1.04 - v4),
        Rotation = u4.Rotation + (math.random() - 0.5) * 30,
    }):Play()
    task.delay(0.54, function() -- Line: 118 -- upvalues: TweenService (upval), u4 (val), u9 (val), Size (val), u45 (val)
        local v1 = TweenService
        local v2 = u4
        local v3 = TweenInfo.new(0.66, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v4 = {}
        local v5 = u9 * 0.6
        v4.Size = UDim2.fromScale(Size.X.Scale * v5, Size.Y.Scale * v5)
        v1:Create(v2, v3, v4):Play()
        for i, j in u45 do
            TweenService:Create(j.Label, TweenInfo.new(0.66, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
        end
    end)
    task.delay(1.3, function() -- Line: 129 -- upvalues: u4 (val)
        u4:Destroy()
    end)
end

local function ExecuteHPClaimBonus() -- Line: 134
    -- upvalues: u25 (ref), u22 (ref), TweenService (val), u24 (ref), Sound (val), CurrentCamera (val)
    -- upvalues: animateCross (val)
    u25 = u25 + 1
    local u2 = u25
    if not u22.Visible then
        u22.BackgroundTransparency = 1
        u22.Visible = true
    end
    TweenService:Create(u22, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = u24}):Play()
    ;(Sound.new("Deathmatch")):playOneTime({Name = "Deathmatch HP Bonus", Parent = CurrentCamera})
    for i = 1, 10 do
        task.delay((i - 1) * 0.05, animateCross, i)
    end
    task.delay(0.99, function() -- Line: 165 -- upvalues: u25 (upval), u2 (val), TweenService (upval), u22 (upval)
        if u25 ~= u2 then
            return
        end
        local v1 = TweenService:Create(u22, TweenInfo.new(0.66, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        v1.Completed:Once(function() -- Line: 171 -- upvalues: u25 (upval), u2 (upval), u22 (upval)
            if u25 == u2 then
                u22.Visible = false
            end
        end)
        v1:Play()
    end)
end

function v1.Initialize(a1, a2) -- Line: 183 -- upvalues: u23 (ref), u22 (ref), u24 (ref)
    u23 = a2:WaitForChild("Template")
    u23.Visible = false
    u22 = a2
    u24 = a2.BackgroundTransparency
    u22.BackgroundTransparency = 1
    u22.Visible = false
end

function v1.Start() -- Line: 193 -- upvalues: Router (val), ExecuteHPClaimBonus (val)
    Router.observerRouter("DeathmatchHealthClaimed", ExecuteHPClaimBonus)
end

return v1