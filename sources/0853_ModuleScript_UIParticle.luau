-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = 0;
local u2 = {};
u2.__index = u2;
local u3 = {};
u3.__index = u3;
local u4 = {};
local u5 = nil;

local function rotate(p6, p7: number) -- Line: 75
    local math_rad_ret = math.rad(p7);
    local math_sin_ret = math.sin(math_rad_ret);
    local math_cos_ret = math.cos(math_rad_ret);

    return Vector2.new(math_cos_ret * p6.X - math_sin_ret * p6.Y, math_sin_ret * p6.X + math_cos_ret * p6.Y);
end;

local function alphaBetween(p8: number, p9: number, p10: number) -- Line: 83
    return p9 <= p8 and 1 or math.clamp((p10 - p8) / (p9 - p8), 0, 1);
end;

local function evalColor(p11: any, p12: number) -- Line: 91
    if typeof(p11) ~= "ColorSequence" then
        return p11;
    end;

    if p12 <= 0 then
        return p11.Keypoints[1].Value;
    end;

    if p12 >= 1 then
        return p11.Keypoints[#p11.Keypoints].Value;
    end;

    for i = 1, #p11.Keypoints - 1 do
        local v13 = p11.Keypoints[i];
        local v14 = p11.Keypoints[i + 1];

        if v13.Time <= p12 and p12 < v14.Time then
            return v13.Value:Lerp(v14.Value, (p12 - v13.Time) / (v14.Time - v13.Time));
        end;

        local _ = i;
    end;

    return p11.Keypoints[#p11.Keypoints].Value;
end;

local function evalNumber(p15: any, p16: number) -- Line: 117
    if typeof(p15) ~= "NumberSequence" then
        return p15;
    end;

    if p16 <= 0 then
        return p15.Keypoints[1].Value;
    end;

    if p16 >= 1 then
        return p15.Keypoints[#p15.Keypoints].Value;
    end;

    for i = 1, #p15.Keypoints - 1 do
        local v17 = p15.Keypoints[i];
        local v18 = p15.Keypoints[i + 1];

        if v17.Time <= p16 and p16 < v18.Time then
            return (v18.Value - v17.Value) * ((p16 - v17.Time) / (v18.Time - v17.Time)) + v17.Value;
        end;

        local _ = i;
    end;

    return p15.Keypoints[#p15.Keypoints].Value;
end;

local function sampleNumber(p19) -- Line: 143
    local v20 = typeof(p19);

    if v20 == "NumberRange" then
        return math.random() * (p19.Max - p19.Min) + p19.Min;
    end;

    if v20 ~= "NumberSequence" then
        return p19;
    end;

    local Value = p19.Keypoints[1].Value;
    local Value2 = p19.Keypoints[#p19.Keypoints].Value;

    return math.random() * (Value2 - Value) + Value;
end;

local function getSpreadAngle(p21) -- Line: 160
    -- upvalues: sampleNumber (copy)
    if typeof(p21) == "NumberRange" then
        return sampleNumber(p21);
    end;

    return p21 == 0 and 0 or math.random() * p21 - p21 / 2;
end;

local function getDirectionVector(p22: string, p23: number) -- Line: 173
    if p22 == "Bottom" then
        return Vector2.new(0, p23);
    end;

    if p22 == "Left" then
        return Vector2.new(-p23, 0);
    end;

    if p22 == "Right" then
        return Vector2.new(p23, 0);
    end;

    return Vector2.new(0, -p23);
end;

local function getSpawnPosition(p24: userdata, p25: string) -- Line: 185
    local AbsoluteSize = p24.AbsoluteSize;

    if p25 == "Fill" then
        return Vector2.new(math.random() * AbsoluteSize.X, math.random() * AbsoluteSize.Y);
    end;

    return Vector2.new(AbsoluteSize.X / 2, AbsoluteSize.Y / 2);
end;

local function applyVisual(p26: userdata, p27, p28: number, p29: number, p30: number, p31, p32: number) -- Line: 195
    p26.Size = UDim2.fromOffset(math.max(0, p29), (math.max(0, p30)));
    p26.Position = UDim2.fromOffset(p31.X, p31.Y);
    p26.Rotation = p32;

    if not (p26:IsA("ImageLabel") or p26:IsA("ImageButton")) then
        if p26:IsA("CanvasGroup") then
            p26.GroupColor3 = p27;
            p26.GroupTransparency = p28;
        end;

        return;
    end;

    p26.ImageColor3 = p27;
    p26.ImageTransparency = p28;
end;

local function stepEmitter(p33: table, p34: number) -- Line: 219
    -- upvalues: u1 (ref), u2 (copy)
    if not p33.Enabled then
        return;
    end;

    if p33.UpdateInterval > 0 then
        p33.__updateAccumulator = p33.__updateAccumulator + p34;

        if p33.__updateAccumulator < p33.UpdateInterval then
            return;
        end;

        p34 = p33.__updateAccumulator;
        p33.__updateAccumulator = 0;
    end;

    p33.__elapsedTime = p33.__elapsedTime + p34;

    for i = #p33.particles, 1, -1 do
        local v35 = p33.particles[i];
        local v36;

        if v35.isDead then
            table.remove(p33.particles, i);
            v36 = i;
        else
            v35:Update(p34);
            v36 = i;
        end;
    end;

    if p33.Rate <= 0 then
        return;
    end;

    local v37 = 1 / p33.Rate;

    while v37 <= p33.__elapsedTime do
        if #p33.particles >= p33.MaxParticles or u1 >= 180 then
            p33.__elapsedTime = 0;

            return;
        end;

        table.insert(p33.particles, u2.new(p33));
        p33.__elapsedTime = p33.__elapsedTime - v37;
    end;
end;

local function stopHeartbeatIfIdle() -- Line: 263
    -- upvalues: u5 (ref), u4 (copy)
    if u5 and next(u4) == nil then
        u5:Disconnect();
        u5 = nil;
    end;
end;

local function startHeartbeat() -- Line: 270
    -- upvalues: u5 (ref), RunService (copy), u4 (copy), stepEmitter (copy)
    if u5 then
        return;
    end;

    u5 = RunService.Heartbeat:Connect(function(p38) -- Line: 275
        -- upvalues: u4 (ref), stepEmitter (ref), u5 (ref)
        for i in pairs(u4) do
            if i.__dead then
                u4[i] = nil;
            else
                stepEmitter(i, p38);
            end;
        end;

        if u5 and next(u4) == nil then
            u5:Disconnect();
            u5 = nil;
        end;
    end);
end;

local function acquireElement(p39: table) -- Line: 288
    return table.remove(p39.__pool) or p39.Element:Clone();
end;

local function releaseElement(p40: table, p41: userdata) -- Line: 297
    p41.Parent = nil;

    if #p40.__pool < p40.MaxParticles then
        table.insert(p40.__pool, p41);

        return;
    end;

    p41:Destroy();
end;

function u2.new(p42: table) -- Line: 308
    -- upvalues: getSpawnPosition (copy), sampleNumber (copy), applyVisual (copy), u2 (copy), getDirectionVector (copy), u1 (ref)
    local v43 = table.remove(p42.__pool) or p42.Element:Clone();
    local v44 = getSpawnPosition(p42.Hook, p42.EmitterMode);
    local v45 = sampleNumber(p42.Speed);
    local SpreadAngle = p42.SpreadAngle;
    local v46;

    if typeof(SpreadAngle) == "NumberRange" then
        v46 = sampleNumber(SpreadAngle);
    else
        v46 = SpreadAngle == 0 and 0 or math.random() * SpreadAngle - SpreadAngle / 2;
    end;

    local v47 = sampleNumber(p42.Rotation);
    local Color = p42.Color;

    if typeof(Color) == "ColorSequence" then
        Color = Color.Keypoints[1].Value;
    end;

    local Transparency = p42.Transparency;

    if typeof(Transparency) == "NumberSequence" then
        Transparency = Transparency.Keypoints[1].Value;
    end;

    local X = p42.Size.X;

    if typeof(X) == "NumberSequence" then
        X = X.Keypoints[1].Value;
    end;

    local Y = p42.Size.Y;

    if typeof(Y) == "NumberSequence" then
        Y = Y.Keypoints[1].Value;
    end;

    v43.Name = "UIParticle";
    v43.AnchorPoint = Vector2.new(0.5, 0.5);
    v43.BackgroundTransparency = 1;
    v43.ZIndex = p42.Hook.ZIndex + p42.ZOffset;
    applyVisual(v43, Color, Transparency, X, Y, v44, v47);
    v43.Parent = p42.Hook;

    if p42.PreSpawn then
        p42.PreSpawn(v43);
    end;

    local v48 = setmetatable({}, u2);
    v48.Element = v43;
    v48.Position = v44;
    local v49 = getDirectionVector(p42.EmissionDirection, v45);
    local math_rad_ret = math.rad(v46);
    local math_sin_ret = math.sin(math_rad_ret);
    local math_cos_ret = math.cos(math_rad_ret);
    v48.Velocity = Vector2.new(math_cos_ret * v49.X - math_sin_ret * v49.Y, math_sin_ret * v49.X + math_cos_ret * v49.Y);
    v48.Acceleration = p42.Acceleration;
    v48.Drag = p42.Drag;
    v48.Age = 0;
    v48.MaxAge = sampleNumber(p42.Lifetime);
    v48.Size = p42.Size;
    v48.Color = p42.Color;
    v48.Transparency = p42.Transparency;
    v48.RotSpeed = sampleNumber(p42.RotSpeed);
    v48.isDead = false;
    v48._emitter = p42;
    v48._rotation = v47;
    u1 = u1 + 1;

    return v48;
end;

function u2.Update(p50: table, p51: number) -- Line: 351
    -- upvalues: evalNumber (copy), evalColor (copy), applyVisual (copy)
    if p50.Age >= p50.MaxAge and p50.MaxAge > 0 then
        p50:Destroy();

        return;
    end;

    p50.Age = p50.Age + p51;
    local MaxAge = p50.MaxAge;
    local v52 = MaxAge <= 0 and 1 or math.clamp((p50.Age - 0) / (MaxAge - 0), 0, 1);
    local v53 = evalNumber(p50.Size.X, v52);
    local v54 = evalNumber(p50.Size.Y, v52);
    local v55 = evalColor(p50.Color, v52);
    local v56 = evalNumber(p50.Transparency, v52);

    if p50.Drag > 0 then
        local math_max_ret = math.max(0, 1 - p50.Drag * p51);
        p50.Velocity = p50.Velocity * math_max_ret;
    end;

    p50.Velocity = p50.Velocity + p50.Acceleration * p51;
    p50.Position = p50.Position + p50.Velocity * p51;
    p50._rotation = p50._rotation + p50.RotSpeed * p51;
    applyVisual(p50.Element, v55, v56, v53, v54, p50.Position, p50._rotation);
    local _emitter = p50._emitter;

    if _emitter.OnUpdate then
        _emitter.OnUpdate(p50.Element);
    end;
end;

function u2.Destroy(p57) -- Line: 382
    -- upvalues: u1 (ref)
    if p57.isDead then
        return;
    end;

    p57.isDead = true;
    u1 = math.max(0, u1 - 1);
    local _emitter = p57._emitter;

    if not _emitter or _emitter.__dead then
        p57.Element:Destroy();

        return;
    end;

    local Element = p57.Element;
    Element.Parent = nil;

    if #_emitter.__pool < _emitter.MaxParticles then
        table.insert(_emitter.__pool, Element);

        return;
    end;

    Element:Destroy();
end;

function u3.new(p58: userdata, p59: userdata) -- Line: 398
    -- upvalues: u3 (copy)
    local v60 = setmetatable({}, u3);
    v60.particles = {};
    v60.Enabled = false;
    v60.Element = p59;
    v60.Hook = p58;
    v60.Rate = 20;
    v60.Color = Color3.new(1, 1, 1);
    v60.Size = {
        X = NumberSequence.new(12),
        Y = NumberSequence.new(12)
    };
    v60.Transparency = NumberSequence.new(0);
    v60.ZOffset = 0;
    v60.Speed = NumberRange.new(150, 500);
    v60.SpreadAngle = NumberRange.new(-15, 15);
    v60.RotSpeed = NumberRange.new(0);
    v60.Lifetime = NumberRange.new(5, 10);
    v60.Acceleration = Vector2.new(0, -500);
    v60.Drag = 0;
    v60.Rotation = 0;
    v60.EmissionDirection = "Top";
    v60.EmitterMode = "Point";
    v60.MaxParticles = 24;
    v60.UpdateInterval = 0;
    v60.PreSpawn = nil;
    v60.OnUpdate = nil;
    v60.__dead = false;
    v60.__elapsedTime = 0;
    v60.__updateAccumulator = 0;
    v60.__pool = {};
    v60.__runServiceConnection = nil;
    v60.Emit = u3.Emit;
    v60.SetEnabled = u3.SetEnabled;
    v60.Destroy = u3.Destroy;

    return v60;
end;

function u3.fromEmitter3D(p61: userdata, p62: userdata, p63: number?) -- Line: 437
    -- upvalues: u3 (copy)
    local v64 = p63 or 1;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p62.Texture;
    ImageLabel.Size = UDim2.fromOffset(1, 1);
    local v65 = u3.new(p61, ImageLabel);
    v65.Rate = p62.Rate;
    v65.Color = p62.Color;
    v65.Size = {
        X = p62.Size,
        Y = p62.Size
    };
    v65.Transparency = p62.Transparency;
    v65.ZOffset = p62.ZOffset;
    v65.Speed = NumberRange.new(p62.Speed.Min * v64, p62.Speed.Max * v64);
    v65.SpreadAngle = NumberRange.new(p62.SpreadAngle.X, p62.SpreadAngle.Y);
    v65.RotSpeed = p62.RotSpeed;
    v65.Lifetime = p62.Lifetime;
    v65.Acceleration = Vector2.new(p62.Acceleration.X * v64, p62.Acceleration.Y * v64);
    v65.EmitterMode = p62.ShapeStyle == Enum.ParticleEmitterShapeStyle.Volume and "Fill" or "Point";

    return v65;
end;

function u3.Emit(p66: table, p67: number) -- Line: 463
    -- upvalues: u1 (ref), u2 (copy)
    for i = 1, p67 do
        if #p66.particles >= p66.MaxParticles or u1 >= 180 then
            break;
        end;

        table.insert(p66.particles, u2.new(p66));
        local _ = i;
    end;
end;

function u3.SetEnabled(p68: table, p69: boolean) -- Line: 477
    -- upvalues: u4 (copy), u5 (ref), RunService (copy), stepEmitter (copy)
    if p68.__dead then
        return;
    end;

    local v70 = p69 == true;

    if p68.Enabled == v70 then
        if v70 then
            u4[p68] = true;

            if u5 then
                return;
            end;

            u5 = RunService.Heartbeat:Connect(function(p71) -- Line: 275
                -- upvalues: u4 (ref), stepEmitter (ref), u5 (ref)
                for i in pairs(u4) do
                    if i.__dead then
                        u4[i] = nil;
                    else
                        stepEmitter(i, p71);
                    end;
                end;

                if u5 and next(u4) == nil then
                    u5:Disconnect();
                    u5 = nil;
                end;
            end);
        end;

        return;
    end;

    p68.Enabled = v70;

    if v70 then
        u4[p68] = true;

        if u5 then
            return;
        end;

        u5 = RunService.Heartbeat:Connect(function(p72) -- Line: 275
            -- upvalues: u4 (ref), stepEmitter (ref), u5 (ref)
            for i in pairs(u4) do
                if i.__dead then
                    u4[i] = nil;
                else
                    stepEmitter(i, p72);
                end;
            end;

            if u5 and next(u4) == nil then
                u5:Disconnect();
                u5 = nil;
            end;
        end);

        return;
    end;

    u4[p68] = nil;

    for i = #p68.particles, 1, -1 do
        p68.particles[i]:Destroy();
        table.remove(p68.particles, i);
        local _ = i;
    end;

    if u5 and next(u4) == nil then
        u5:Disconnect();
        u5 = nil;
    end;
end;

function u3.Destroy(p73) -- Line: 509
    -- upvalues: u4 (copy), u5 (ref)
    if p73.__dead then
        return;
    end;

    p73.__dead = true;
    p73.Enabled = false;
    u4[p73] = nil;

    if u5 and next(u4) == nil then
        u5:Disconnect();
        u5 = nil;
    end;

    for _, v in ipairs(p73.particles) do
        v:Destroy();
    end;

    table.clear(p73.particles);

    for _, v in ipairs(p73.__pool) do
        v:Destroy();
    end;

    table.clear(p73.__pool);
end;

return u3;