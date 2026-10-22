-- ReplicatedStorage.Controllers.Observers.Game.LampFlicker
-- Script path: ReplicatedStorage.Controllers.Observers.Game.LampFlicker
-- Decompile time: 4.46 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Color3_fromRGB_ret = Color3.fromRGB(40, 36, 34);
local u1 = {};
local u2 = nil;
local Random_new_ret = Random.new();

local function queueStep(p3: table, p4: number, p5: number) -- Line: 49
    table.insert(p3.StepIntensities, p4);
    table.insert(p3.StepDurations, p5);
end;

local function queueCycle(p6: table) -- Line: 56
    -- upvalues: Random_new_ret (copy)
    table.clear(p6.StepIntensities);
    table.clear(p6.StepDurations);
    p6.StepIndex = 0;

    for i = 1, Random_new_ret:NextInteger(10, 60) do
        local v7 = Random_new_ret:NextNumber(0.85, 1);
        table.insert(p6.StepIntensities, v7);
        table.insert(p6.StepDurations, 0.05);
        local _ = i;
    end;

    for i = 1, Random_new_ret:NextInteger(2, 8) do
        local v8 = Random_new_ret:NextNumber(0, 0.15);
        local v9 = Random_new_ret:NextNumber(0.03, 0.15);
        table.insert(p6.StepIntensities, v8);
        table.insert(p6.StepDurations, v9);
        local v10 = Random_new_ret:NextNumber(0.4, 1);
        local v11 = Random_new_ret:NextNumber(0.02, 0.1);
        table.insert(p6.StepIntensities, v10);
        table.insert(p6.StepDurations, v11);
        local _ = i;
    end;

    if Random_new_ret:NextNumber() < 0.35 then
        local v12 = Random_new_ret:NextNumber(0.8, 3.5);
        table.insert(p6.StepIntensities, 0);
        table.insert(p6.StepDurations, v12);
    end;
end;

local function applyIntensity(p13: table, p14: number) -- Line: 78
    -- upvalues: Color3_fromRGB_ret (copy)
    for i, v in p13.Lights do
        v.Brightness = p13.BaseBrightness[i] * p14;
    end;

    local Bulb = p13.Bulb;

    if not Bulb then
        return;
    end;

    Bulb.Color = Color3_fromRGB_ret:Lerp(p13.OnColor, p14);
    local v15;

    if p14 > 0.15 then
        v15 = Enum.Material.Neon;
    else
        v15 = Enum.Material.SmoothPlastic;
    end;

    if v15 ~= p13.Material then
        p13.Material = v15;
        Bulb.Material = v15;
    end;
end;

local function restoreLamp(p16: table) -- Line: 97
    for i, v in p16.Lights do
        v.Brightness = p16.BaseBrightness[i];
    end;

    local Bulb = p16.Bulb;

    if Bulb then
        Bulb.Color = p16.OnColor;
        Bulb.Material = p16.AuthoredMaterial;
    end;
end;

local function isNearCamera(p17: vector?, p18: table) -- Line: 110
    local Bulb = p18.Bulb;
    local v19;

    if p17 == nil or Bulb == nil then
        v19 = false;
    else
        v19 = (p17 - Bulb.Position).Magnitude < 250;
    end;

    return v19;
end;

local function stopHeartbeatIfIdle() -- Line: 117
    -- upvalues: u1 (copy), u2 (ref)
    if next(u1) == nil and u2 then
        u2:Disconnect();
        u2 = nil;
    end;
end;

local function stepLamps(p20: number) -- Line: 126
    -- upvalues: Workspace (copy), u1 (copy), queueCycle (copy), applyIntensity (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CFrame.Position;
    end;

    for _, v in u1 do
        v.StepRemaining = v.StepRemaining - p20;

        if v.StepRemaining <= 0 then
            local Bulb = v.Bulb;
            local v21;

            if CurrentCamera == nil or Bulb == nil then
                v21 = false;
            else
                v21 = (CurrentCamera - Bulb.Position).Magnitude < 250;
            end;

            if v21 then
                v.StepIndex = v.StepIndex + 1;

                if v.StepIndex > #v.StepIntensities then
                    queueCycle(v);
                    v.StepIndex = 1;
                end;

                applyIntensity(v, v.StepIntensities[v.StepIndex]);
                v.StepRemaining = v.StepDurations[v.StepIndex];
            else
                v.StepRemaining = 1;
            end;
        end;
    end;
end;

local function ensureHeartbeat() -- Line: 153
    -- upvalues: u2 (ref), RunServiceController (copy), stepLamps (copy)
    if u2 then
        return;
    end;

    u2 = RunServiceController.BindToHeartbeat("Observers.Game.LampFlicker.Update", stepLamps);
end;

local function setBulb(p22: table, p23: userdata) -- Line: 162
    p22.Bulb = p23;
    p22.OnColor = p23.Color;
    p22.AuthoredMaterial = p23.Material;
    p22.Material = p23.Material;
end;

return Observers.observeTag("LampFlicker", function(u24: userdata) -- Line: 172
    -- upvalues: GraphicsQualityController (copy), Janitor (copy), Color3_fromRGB_ret (copy), Random_new_ret (copy), u1 (copy), u2 (ref), RunServiceController (copy), stepLamps (copy)
    return GraphicsQualityController.RunAnimatedProp(function() -- Line: 174
        -- upvalues: Janitor (ref), Color3_fromRGB_ret (ref), Random_new_ret (ref), u24 (copy), u1 (ref), u2 (ref), RunServiceController (ref), stepLamps (ref)
        local u25 = Janitor.new();
        local u26 = {
            Bulb = nil,
            StepIndex = 0,
            OnColor = Color3_fromRGB_ret,
            AuthoredMaterial = Enum.Material.Neon,
            Material = Enum.Material.Neon,
            Lights = {},
            BaseBrightness = {},
            StepIntensities = {},
            StepDurations = {},
            StepRemaining = Random_new_ret:NextNumber(0, 2)
        };

        local function onDescendant(p27: userdata) -- Line: 191
            -- upvalues: u26 (copy)
            if u26.Bulb or (p27.Name ~= "light" or not p27:IsA("BasePart")) then
                if p27:IsA("Light") and (u26.Bulb and p27:IsDescendantOf(u26.Bulb)) then
                    table.insert(u26.Lights, p27);
                    table.insert(u26.BaseBrightness, p27.Brightness);
                end;

                return;
            end;

            local v28 = u26;
            v28.Bulb = p27;
            v28.OnColor = p27.Color;
            v28.AuthoredMaterial = p27.Material;
            v28.Material = p27.Material;
        end;

        for _, descendant in u24:GetDescendants() do
            onDescendant(descendant);
        end;

        u25:Add(u24.DescendantAdded:Connect(onDescendant));
        u1[u24] = u26;

        if not u2 then
            u2 = RunServiceController.BindToHeartbeat("Observers.Game.LampFlicker.Update", stepLamps);
        end;

        return function() -- Line: 209
            -- upvalues: u25 (copy), u1 (ref), u24 (ref), u26 (copy), u2 (ref)
            u25:Destroy();
            u1[u24] = nil;
            local v29 = u26;

            for i, v in v29.Lights do
                v.Brightness = v29.BaseBrightness[i];
            end;

            local Bulb = v29.Bulb;

            if Bulb then
                Bulb.Color = v29.OnColor;
                Bulb.Material = v29.AuthoredMaterial;
            end;

            if next(u1) == nil and u2 then
                u2:Disconnect();
                u2 = nil;
            end;
        end;
    end);
end, { Workspace });