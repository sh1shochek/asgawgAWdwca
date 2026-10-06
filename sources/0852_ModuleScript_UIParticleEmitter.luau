-- Decompiled with Potassium's decompiler.

local script_UIParticle = require(script.UIParticle);
local u1 = {};
u1.__index = u1;

local function toSize2D(p2) -- Line: 39
    return {
        X = p2,
        Y = p2
    };
end;

local function createParticleElement(p3: string) -- Line: 46
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Particle";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p3;
    ImageLabel.Size = UDim2.fromOffset(1, 1);

    return ImageLabel;
end;

local function syncRuntime(p4: table) -- Line: 56
    local _runtimeEmitter = p4._runtimeEmitter;

    if not _runtimeEmitter then
        return;
    end;

    _runtimeEmitter.Rate = p4.Rate;
    _runtimeEmitter.Color = p4.Color;
    local Size = p4.Size;
    _runtimeEmitter.Size = {
        X = Size,
        Y = Size
    };
    _runtimeEmitter.Transparency = p4.Transparency;
    _runtimeEmitter.ZOffset = p4.ZOffset;
    _runtimeEmitter.Speed = p4.Speed;
    _runtimeEmitter.SpreadAngle = p4.SpreadAngle;
    _runtimeEmitter.RotSpeed = p4.RotSpeed;
    _runtimeEmitter.Lifetime = p4.Lifetime;
    _runtimeEmitter.Acceleration = p4.Acceleration;
    _runtimeEmitter.Drag = p4.Drag;
    _runtimeEmitter.Rotation = p4.Rotation;
    _runtimeEmitter.EmissionDirection = p4.EmissionDirection;
    _runtimeEmitter.EmitterMode = p4.EmitterMode or "Fill";
    _runtimeEmitter.MaxParticles = p4.MaxParticles or 24;
    _runtimeEmitter.UpdateInterval = p4.UpdateInterval or 0;
    _runtimeEmitter.OnUpdate = p4.OnUpdate;

    if p4._particleElement then
        p4._particleElement.Image = p4.Texture;
    end;
end;

function u1.SetParent(p5: table, p6: userdata?) -- Line: 85
    -- upvalues: script_UIParticle (copy), syncRuntime (copy)
    if p5._runtimeEmitter then
        p5._runtimeEmitter:Destroy();
        p5._runtimeEmitter = nil;
    end;

    p5.Parent = p6;

    if not p6 then
        return;
    end;

    local Texture = p5.Texture;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Particle";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = Texture;
    ImageLabel.Size = UDim2.fromOffset(1, 1);
    local v7 = script_UIParticle.new(p6, ImageLabel);
    p5._particleElement = ImageLabel;
    p5._runtimeEmitter = v7;
    syncRuntime(p5);
    local SetEnabled = v7.SetEnabled;

    if typeof(SetEnabled) == "function" then
        SetEnabled(v7, true);
    else
        v7.Enabled = true;
    end;

    local v8 = p5.MaxParticles or 24;

    if p5.Rate > 0 and v8 > 0 then
        local math_floor_ret = math.floor(p5.Rate / 4);
        local math_max_ret = math.max(1, math_floor_ret);
        v7:Emit((math.min(v8, math_max_ret)));
    end;
end;

function u1.Emit(p9: table, p10: number) -- Line: 118
    -- upvalues: syncRuntime (copy)
    if p9._runtimeEmitter then
        syncRuntime(p9);
        p9._runtimeEmitter:Emit(p10);
    end;
end;

function u1.Update(p11: table, p12: number) -- Line: 125
    -- upvalues: syncRuntime (copy)
    syncRuntime(p11);
end;

function u1.SetEnabled(p13: table, p14: boolean) -- Line: 129
    local _runtimeEmitter = p13._runtimeEmitter;

    if not _runtimeEmitter then
        return;
    end;

    local SetEnabled = _runtimeEmitter.SetEnabled;

    if typeof(SetEnabled) == "function" then
        SetEnabled(_runtimeEmitter, p14 == true);

        return;
    end;

    _runtimeEmitter.Enabled = p14 == true;
end;

function u1.Destroy(p15: table) -- Line: 145
    if p15._runtimeEmitter then
        p15._runtimeEmitter:Destroy();
        p15._runtimeEmitter = nil;
    end;

    if p15._particleElement then
        p15._particleElement:Destroy();
        p15._particleElement = nil;
    end;

    p15.Parent = nil;
end;

function u1.new() -- Line: 159
    -- upvalues: u1 (copy)
    local v16 = setmetatable({}, u1);
    v16.Color = Color3.new(1, 1, 1);
    v16.Size = NumberSequence.new(12);
    v16.Transparency = NumberSequence.new(0);
    v16.Texture = "";
    v16.EmissionDirection = "Top";
    v16.Lifetime = NumberRange.new(1);
    v16.Rate = 20;
    v16.Rotation = 0;
    v16.RotSpeed = 0;
    v16.Speed = 0;
    v16.SpreadAngle = 0;
    v16.Acceleration = Vector2.zero;
    v16.Drag = 0;
    v16.ZOffset = 0;
    v16.EmitterMode = nil;
    v16.MaxParticles = nil;
    v16.UpdateInterval = nil;
    v16.OnUpdate = nil;
    v16._runtimeEmitter = nil;
    v16._particleElement = nil;
    v16.SetParent = u1.SetParent;
    v16.SetEnabled = u1.SetEnabled;
    v16.Emit = u1.Emit;
    v16.Update = u1.Update;
    v16.Destroy = u1.Destroy;

    return v16;
end;

return u1;