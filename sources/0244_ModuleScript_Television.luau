-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController);

local function getNoiseInstances(p1: userdata) -- Line: 15
    local v2 = {};
    local Screen = p1:FindFirstChild("Screen");

    if Screen then
        for _, child in ipairs(Screen:GetChildren()) do
            if child.Name == "Noise" then
                table.insert(v2, child);
            end;
        end;
    end;

    return v2;
end;

local function updateScreen(p3: table) -- Line: 28
    for _, v in ipairs(p3) do
        local math_random_ret = math.random();
        v.Transparency = math.clamp(math_random_ret, 0.2, 0.7);
        v.Color3 = Color3.fromRGB(192 + math.random(-10, 10), 216 + math.random(-10, 10), 255 + math.random(-10, 10));
    end;
end;

local function breakScreen(p4: userdata) -- Line: 42
    -- upvalues: TweenService (copy)
    local Screen = p4:FindFirstChild("Screen");

    if not Screen then
        return;
    end;

    TweenService:Create(Screen, TweenInfo.new(2.15), {
        Color = Color3.fromRGB(0, 0, 0)
    }):Play();
    local PointLight = Screen.ScreenLight.PointLight;

    for i = 1, 8 do
        PointLight.Enabled = not PointLight.Enabled;
        task.wait(math.random(1, 4) / 10);
        local _ = i;
    end;

    PointLight.Enabled = false;

    for _, child in ipairs(Screen:GetChildren()) do
        if child.Name == "Noise" then
            child.Transparency = 1;
        end;
    end;
end;

return Observers.observeTag("Television", function(u5: userdata) -- Line: 68
    -- upvalues: getNoiseInstances (copy), GraphicsQualityController (copy), RunServiceController (copy), updateScreen (copy), Observers (copy), breakScreen (copy)
    local u6 = 0;

    if u5:IsDescendantOf(workspace) then
        local u7 = getNoiseInstances(u5);
        local u11 = GraphicsQualityController.RunAnimatedProp(function() -- Line: 76
            -- upvalues: RunServiceController (ref), u6 (ref), u5 (copy), updateScreen (ref), u7 (copy)
            local v8 = RunServiceController.CreateBindingName("Observers.Game.Television.Noise");
            local u10 = RunServiceController.BindToHeartbeat(v8, function(p9: number) -- Line: 78
                -- upvalues: u6 (ref), u5 (ref), updateScreen (ref), u7 (ref)
                u6 = u6 + p9;

                if u6 >= 0.05 then
                    u6 = u6 % 0.05;

                    if u5:IsDescendantOf(workspace) then
                        updateScreen(u7);
                    end;
                end;
            end);

            return function() -- Line: 87
                -- upvalues: u10 (copy)
                if u10.Connected then
                    u10:Disconnect();
                end;
            end;
        end);

        local function stopNoise() -- Line: 94
            -- upvalues: u11 (copy)
            if u11 then
                u11();
            end;
        end;

        local u13 = Observers.observeAttribute(u5, "Broken", function(p12) -- Line: 100
            -- upvalues: breakScreen (ref), u5 (copy), u11 (copy)
            breakScreen(u5);

            if u11 then
                u11();
            end;
        end);

        return function() -- Line: 104
            -- upvalues: u13 (copy), u11 (copy)
            u13();

            if u11 then
                u11();
            end;
        end;
    end;
end);