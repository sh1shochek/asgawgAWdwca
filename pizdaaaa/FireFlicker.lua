-- ReplicatedStorage.Controllers.Observers.Game.FireFlicker
-- Script path: ReplicatedStorage.Controllers.Observers.Game.FireFlicker
-- Decompile time: 4.68 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GraphicsQualityController = require(ReplicatedStorage.Controllers.GraphicsQualityController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Color3_fromRGB_ret = Color3.fromRGB(255, 170, 95);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 96, 32);
local u1 = {};
local u2 = nil;
local u3 = 0;

local function getLightPosition(p4: userdata) -- Line: 60
    local Parent = p4.Parent;

    if Parent and Parent:IsA("Attachment") then
        return Parent.WorldPosition;
    end;

    if Parent and Parent:IsA("BasePart") then
        return Parent.Position;
    end;

    return nil;
end;

local function addLight(p5: table, p6: userdata, p7: userdata?) -- Line: 72
    local Parent = p6.Parent;

    if not (p7 and (Parent ~= p7 and (Parent and Parent:IsA("BasePart")))) then
        Parent = nil;
    end;

    local Lights = p5.Lights;
    local v8 = {
        Light = p6,
        BaseBrightness = p6.Brightness,
        BaseColor = p6.Color,
        Seed = math.random() * 100,
        Holder = Parent
    };

    if Parent then
        Parent = Parent.CFrame;
    end;

    v8.HolderCFrame = Parent;
    table.insert(Lights, v8);
    local Parent2 = p6.Parent;
    local v9;

    if Parent2 and Parent2:IsA("Attachment") then
        v9 = Parent2.WorldPosition;
    elseif Parent2 and Parent2:IsA("BasePart") then
        v9 = Parent2.Position;
    else
        v9 = nil;
    end;

    if v9 then
        p5.PositionSum = p5.PositionSum + v9;
        p5.PositionCount = p5.PositionCount + 1;
        p5.Centre = p5.PositionSum / p5.PositionCount;
    end;
end;

local function addCoal(p10: table, p11: userdata) -- Line: 95
    local Coals = p10.Coals;
    local v12 = {
        Appearance = p11,
        BaseEmissive = p11.Parent:GetAttribute("BaseEmissive") or p11.EmissiveStrength,
        AuthoredEmissive = p11.EmissiveStrength,
        Seed = math.random() * 100
    };
    table.insert(Coals, v12);
end;

local function restoreFire(p13: table) -- Line: 107
    for _, v in p13.Lights do
        v.Light.Brightness = v.BaseBrightness;
        v.Light.Color = v.BaseColor;

        if v.Holder and v.HolderCFrame then
            v.Holder.CFrame = v.HolderCFrame;
        end;
    end;

    for _, v in p13.Coals do
        v.Appearance.EmissiveStrength = v.AuthoredEmissive;
    end;
end;

local function stopHeartbeatIfIdle() -- Line: 122
    -- upvalues: u1 (copy), u2 (ref), u3 (ref)
    if next(u1) == nil then
        if u2 then
            u2:Disconnect();
            u2 = nil;
        end;

        u3 = 0;
    end;
end;

local function stepFires(p14: number) -- Line: 134
    -- upvalues: u3 (ref), Workspace (copy), u1 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    u3 = u3 + p14;

    if u3 < 0.03333333333333333 then
        return;
    end;

    u3 = 0;
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local Position = CurrentCamera.CFrame.Position;
    local os_clock_ret = os.clock();
    local v15 = math.noise(os_clock_ret * 1.1, 0.3) * 0.5 + math.noise(os_clock_ret * 3.7, 1.7) * 0.3;

    for _, v in u1 do
        if (Position - v.Centre).Magnitude <= 300 then
            for _, v2 in v.Coals do
                local v16 = 0.8 + v15 * 0.25 + math.noise(os_clock_ret * 0.7, v2.Seed) * 0.35;
                local math_clamp_ret = math.clamp(v16, 0.45, 1.3);
                v2.Appearance.EmissiveStrength = v2.BaseEmissive * math_clamp_ret;
            end;

            for _, v2 in v.Lights do
                local Seed = v2.Seed;
                local v17 = 1 + v15 * 0.45 + math.noise(os_clock_ret * 8.3, Seed) * 0.25;
                local math_clamp_ret = math.clamp(v17, 0.55, 1.4);
                local Light = v2.Light;
                Light.Brightness = v2.BaseBrightness * math_clamp_ret;
                Light.Color = Color3_fromRGB_ret2:Lerp(Color3_fromRGB_ret, (math.clamp((math_clamp_ret - 0.6) / 0.7, 0, 1)));
                local Holder = v2.Holder;
                local HolderCFrame = v2.HolderCFrame;

                if Holder and HolderCFrame then
                    local math_noise_ret = math.noise(os_clock_ret * 2.1, Seed, 1);
                    local v18 = math.noise(os_clock_ret * 2.6, Seed, 2) * 0.6;
                    Holder.CFrame = HolderCFrame + Vector3.new(math_noise_ret, v18, math.noise(os_clock_ret * 2.3, Seed, 3)) * 0.35;
                end;
            end;
        end;
    end;
end;

local function ensureHeartbeat() -- Line: 182
    -- upvalues: u2 (ref), RunServiceController (copy), stepFires (copy)
    if u2 then
        return;
    end;

    u2 = RunServiceController.BindToHeartbeat("Observers.Game.FireFlicker.Update", stepFires);
end;

local function observeFireModel(u19: userdata, u20: table, p21: any) -- Line: 191
    -- upvalues: addLight (copy), addCoal (copy)
    local function onDescendant(p22: userdata) -- Line: 192
        -- upvalues: addLight (ref), u20 (copy), u19 (copy), addCoal (ref)
        if p22:IsA("Light") and not p22:HasTag("FireFlicker") then
            addLight(u20, p22, u19);

            return;
        end;

        if p22:IsA("SurfaceAppearance") then
            local Parent = p22.Parent;

            if Parent then
                Parent = Parent.Parent;
            end;

            if Parent and (Parent.Name == "CoalBeds" and Parent.Parent == u19) then
                addCoal(u20, p22);
            end;
        end;
    end;

    for _, descendant in u19:GetDescendants() do
        onDescendant(descendant);
    end;

    p21:Add(u19.DescendantAdded:Connect(onDescendant));
end;

return Observers.observeTag("FireFlicker", function(u23: userdata) -- Line: 215
    -- upvalues: GraphicsQualityController (copy), Janitor (copy), addLight (copy), observeFireModel (copy), u1 (copy), u2 (ref), RunServiceController (copy), stepFires (copy), restoreFire (copy), u3 (ref)
    return GraphicsQualityController.RunAnimatedProp(function() -- Line: 217
        -- upvalues: Janitor (ref), u23 (copy), addLight (ref), observeFireModel (ref), u1 (ref), u2 (ref), RunServiceController (ref), stepFires (ref), restoreFire (ref), u3 (ref)
        local u24 = Janitor.new();
        local u25 = {
            Centre = Vector3.new(0, 0, 0),
            PositionSum = Vector3.new(0, 0, 0),
            PositionCount = 0,
            Lights = {},
            Coals = {}
        };

        if u23:IsA("Light") then
            addLight(u25, u23, nil);
        else
            observeFireModel(u23, u25, u24);
        end;

        u1[u23] = u25;

        if not u2 then
            u2 = RunServiceController.BindToHeartbeat("Observers.Game.FireFlicker.Update", stepFires);
        end;

        return function() -- Line: 236
            -- upvalues: u24 (copy), u1 (ref), u23 (ref), restoreFire (ref), u25 (copy), u2 (ref), u3 (ref)
            u24:Destroy();
            u1[u23] = nil;
            restoreFire(u25);

            if next(u1) == nil then
                if u2 then
                    u2:Disconnect();
                    u2 = nil;
                end;

                u3 = 0;
            end;
        end;
    end);
end, { Workspace });