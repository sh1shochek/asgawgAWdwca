-- ReplicatedStorage.Controllers.Observers.Game.Television
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Television
-- Decompile time: 1.67 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController)

local function getNoiseInstances(a1) -- Line: 15 -- types: a1: userdata
    local v1 = {}
    local Screen = a1:FindFirstChild("Screen")
    if Screen then
        for i, v in ipairs(Screen:GetChildren()) do
            if v.Name == "Noise" then
                table.insert(v1, v)
            end
        end
    end
    return v1
end

local function updateScreen(a1) -- Line: 28 -- types: a1: table
    local fromRGB, v1, v2
    for i, v in ipairs(a1) do
        v1 = math.random()
        v.Transparency = math.clamp(v1, 0.2, 0.7)
        fromRGB = Color3.fromRGB
        v1 = 192 + math.random(-10, 10)
        v2 = 216 + math.random(-10, 10)
        v.Color3 = fromRGB(v1, v2, 255 + math.random(-10, 10))
    end
end

local function breakScreen(a1) -- Line: 42 -- upvalues: TweenService (val) -- types: a1: userdata
    local Screen = a1:FindFirstChild("Screen")
    if not Screen then
        return
    end
    TweenService:Create(Screen, TweenInfo.new(2.15), {Color = Color3.fromRGB(0, 0, 0)}):Play()
    local PointLight = Screen.ScreenLight.PointLight
    for i = 1, 8 do
        PointLight.Enabled = not PointLight.Enabled
        task.wait(math.random(1, 4) / 10)
    end
    PointLight.Enabled = false
    for i2, v in ipairs(Screen:GetChildren()) do
        if v.Name == "Noise" then
            v.Transparency = 1
        end
    end
end

return Observers.observeTag("Television", function(a1) -- Line: 68
    -- upvalues: getNoiseInstances (val), GraphicsQualityController (val), RunServiceController (val)
    -- upvalues: updateScreen (val), Observers (val), breakScreen (val)
    local u1 = 0
    if not a1:IsDescendantOf(workspace) then
        return
    end
    local u8 = getNoiseInstances(a1)
    local u12 = GraphicsQualityController.RunAnimatedProp(function() -- Line: 76 -- upvalues: RunServiceController (upval), u1 (ref), a1 (val), updateScreen (upval), u8 (val)
        local v1 = RunServiceController.CreateBindingName("Observers.Game.Television.Noise")
        local u8_2 = RunServiceController.BindToHeartbeat(v1, function(a1_2) -- Line: 78 -- upvalues: u1 (upval), a1 (upval), updateScreen (upval), u8 (upval) -- types: a1_2: number
            u1 = u1 + a1_2
            if u1 >= 0.05 then
                u1 = u1 % 0.05
                if a1:IsDescendantOf(workspace) then
                    updateScreen(u8)
                end
            end
        end)
        return function() -- Line: 87 -- upvalues: u8_2 (val)
            if u8_2.Connected then
                u8_2:Disconnect()
            end
        end
    end)

    local function stopNoise() -- Line: 94 -- upvalues: u12 (val)
        if u12 then
            u12()
        end
    end

    local u19 = Observers.observeAttribute(a1, "Broken", function(a1_2) -- Line: 100 -- upvalues: breakScreen (upval), a1 (val), u12 (val)
        breakScreen(a1)
        if u12 then
            u12()
        end
    end)
    return function() -- Line: 104 -- upvalues: u19 (val), u12 (val)
        u19()
        if u12 then
            u12()
        end
    end
end)