-- ReplicatedStorage.Database.Components.Common.RecoilPatterns
-- Script path: ReplicatedStorage.Database.Components.Common.RecoilPatterns
-- Decompile time: 2.76 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
require(ReplicatedStorage.Database.Custom.Types)
local SprayPatterns = ReplicatedStorage.Database.Custom.Weapons.SprayPatterns
local u19 = {}

local function quadraticBezier(a1, a2, a3, a4) -- Line: 26
    -- upvalues: 
    local v1 = 1 - a4
    return v1 * v1 * a1 + v1 * 2 * a4 * a2 + a4 * a4 * a3
end

local function cubicBezier(a1, a2, a3, a4, a5) -- Line: 34
    -- upvalues: 
    local v1 = 1 - a5
    local v2 = a5 * a5
    local v3 = v1 * v1
    local v4 = v3 * v1
    local v5 = v2 * a5
    return v4 * a1 + v3 * 3 * a5 * a2 + v1 * 3 * v2 * a3 + v5 * a4
end

local function getPositionOnPath(a1, a2) -- Line: 49 -- types: a1: table, a2: number
    local v1, v2, v3, v4
    if #a1 == 2 then
        return a1[1]:Lerp(a1[2], a2)
    end
    if #a1 == 3 then
        v1 = a1[1]
        v2 = a1[2]
        v3 = a1[3]
        v4 = 1 - a2
        return v4 * v4 * v1 + v4 * 2 * a2 * v2 + a2 * a2 * v3
    end
    if #a1 ~= 4 then
        return Vector2.zero
    end
    v1 = a1[1]
    v2 = a1[2]
    v3 = a1[3]
    v4 = a1[4]
    local v5 = 1 - a2
    local v6 = a2 * a2
    local v7 = v5 * v5
    local v8 = v7 * v5
    local v9 = v6 * a2
    return v8 * v1 + v7 * 3 * a2 * v2 + v5 * 3 * v6 * v3 + v9 * v4
end

local function getKeyframeAtTime(a1, a2) -- Line: 61 -- types: a1: table, a2: number
    local Duration, v1, v2
    local v3 = 0
    for i, v in ipairs(a1) do
        v2 = v3
        Duration = v.Duration
        v3 = v3 + Duration
        if a2 <= v3 then
            v1 = (a2 - v2) / Duration
            return v, (math.clamp(v1, 0, 1))
        end
    end
    return nil, nil
end

local function getSequenceDuration(a1) -- Line: 78 -- types: a1: table
    local v1 = 0
    for i, v in ipairs(a1) do
        v1 = v1 + v.Duration
    end
    return v1
end

local function CreatePattern(a1, a2) -- Line: 91 -- upvalues: SprayPatterns (val) -- types: a1: string
    local Position, Position_2, v1, zero, zero_2
    local FireRate = a2.FireRate
    local Rounds = a2.Rounds
    local v2 = {}
    local v3 = SprayPatterns:FindFirstChild(a1)
    if not v3 then
        warn(string.format("%s has no spray pattern part", a1))
        return nil
    end
    if #v3:GetChildren() < Rounds then
        warn(string.format("%s spray pattern has fewer points than magazine size", a1), Rounds, #v3:GetChildren())
    end
    local v4 = v3[tostring(1)]
    for i = 1, Rounds do
        v1 = v3[tostring(i)]
        zero = Vector2.zero
        zero_2 = Vector2.zero
        if i > 1 then
            Position = ((v4.WorldCFrame:Inverse()) * v3[tostring(i - 1)].WorldCFrame).Position
            zero = Vector2.new(Position.X, Position.Y)
            Position_2 = ((v4.WorldCFrame:Inverse()) * v1.WorldCFrame).Position
            zero_2 = Vector2.new(Position_2.X, Position_2.Y)
        end
        table.insert(v2, {
            Duration = 1 * FireRate,
            EasingStyle = Enum.EasingStyle.Linear,
            EasingDirection = Enum.EasingDirection.In,
            Path = {zero * 0.5, zero_2 * 0.5},
        })
    end
    return v2
end

local function AppendPattern(a1) -- Line: 134
    -- upvalues: u19 (val), CreatePattern (val), getKeyframeAtTime (val), TweenService (val), getPositionOnPath (val)
    u19[a1] = function(a1_2) -- Line: 135
        -- upvalues: CreatePattern (upval), a1 (val), getKeyframeAtTime (upval), TweenService (upval)
        -- upvalues: getPositionOnPath (upval)
        local u4 = CreatePattern(a1, a1_2)
        u22 = 0
        for i, v in ipairs(u4) do
            local u22 = u22 + v.Duration
        end
        return function(a1) -- Line: 140
            -- upvalues: u22 (val), getKeyframeAtTime (upval), u4 (val), TweenService (upval), getPositionOnPath (upval)
            local v1 = math.clamp(a1, 0, u22)
            local v2, v3 = getKeyframeAtTime(u4, v1)
            return (getPositionOnPath(v2.Path, (TweenService:GetValue(v3, v2.EasingStyle, v2.EasingDirection))))
        end
    end
end

for i, v in ipairs(SprayPatterns:GetChildren()) do
    local Name = v.Name

    u19[Name] = function(a1) -- Line: 135
        -- upvalues: CreatePattern (val), Name (val), getKeyframeAtTime (val), TweenService (val)
        -- upvalues: getPositionOnPath (val)
        local u4 = CreatePattern(Name, a1)
        u22 = 0
        for i, v in ipairs(u4) do
            local u22 = u22 + v.Duration
        end
        return function(a1) -- Line: 140
            -- upvalues: u22 (val), getKeyframeAtTime (upval), u4 (val), TweenService (upval), getPositionOnPath (upval)
            local v1 = math.clamp(a1, 0, u22)
            local v2, v3 = getKeyframeAtTime(u4, v1)
            return (getPositionOnPath(v2.Path, (TweenService:GetValue(v3, v2.EasingStyle, v2.EasingDirection))))
        end
    end
end
return u19