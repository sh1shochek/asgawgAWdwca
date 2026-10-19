-- IntroAtmosphere (ModuleScript)
-- full path: ReplicatedStorage.Cutscenes.TutorialIntro.IntroAtmosphere

-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local u1 = {};
u1.__index = u1;
u1.TEXTURES = { "rbxassetid://901813002", "rbxassetid://87378350610127" };
local u2 = {
    A = { 7, 9, 0.16, 0 },
    B = { 13, 9, 0.22, 0 },
    C = { 13, 10, 0.2, 0 },
    D = { 6, 14, 0.12, 0 }
};
local u3 = {
    Contrast = 0.08,
    Saturation = -0.05,
    Tint = Color3.fromRGB(255, 238, 218)
};
local u4 = { Vector2.new(-3.5, 11.5), Vector2.new(2.5, 7.5), Vector2.new(5.5, 12.5) };
local Color3_fromRGB_ret = Color3.fromRGB(255, 214, 166);
local u5 = { Vector3.new(3.5, 0.5, 8), Vector3.new(-3.5, 0.5, 8) };

local function smoother(p6: number) -- Line: 45
    local math_clamp_ret = math.clamp(p6, 0, 1);

    return math_clamp_ret * math_clamp_ret * math_clamp_ret * (math_clamp_ret * (math_clamp_ret * 6 - 15) + 10);
end;

local function invisiblePart(p7: string, p8: vector, p9: userdata) -- Line: 50
    local Part = Instance.new("Part");
    Part.Name = p7;
    Part.Size = p8;
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Parent = p9;

    return Part;
end;

local function numbers(p10: table) -- Line: 64
    local v11 = {};

    for _, v in p10 do
        table.insert(v11, NumberSequenceKeypoint.new(v[1], v[2], v[3] or 0));
    end;

    return NumberSequence.new(v11);
end;

local function motes(p12: userdata, p13: number, p14: number) -- Line: 72
    -- upvalues: numbers (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = "Motes";
    ParticleEmitter.Texture = "rbxassetid://901813002";
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box;
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume;
    ParticleEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward;
    ParticleEmitter.Rate = p13;
    ParticleEmitter.Lifetime = NumberRange.new(5, 8);
    ParticleEmitter.Size = numbers({ { 0, 0.05, 0.02 }, { 1, 0.05, 0.02 } });
    ParticleEmitter.Transparency = numbers({ { 0, 1 }, { 0.2, 0.35, 0.15 }, { 0.8, 0.45, 0.15 }, { 1, 1 } });
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 228, 186));
    ParticleEmitter.LightEmission = p14;
    ParticleEmitter.LightInfluence = 0.3;
    ParticleEmitter.Speed = NumberRange.new(0.04, 0.22);
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180);
    ParticleEmitter.Drag = 0.6;
    ParticleEmitter.Acceleration = Vector3.new(0.05, 0.03, 0);
    ParticleEmitter.RotSpeed = NumberRange.new(-30, 30);
    ParticleEmitter.Parent = p12;

    return ParticleEmitter;
end;

local function puffs(p15: userdata, p16: string) -- Line: 95
    -- upvalues: numbers (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = p16;
    ParticleEmitter.Texture = "rbxassetid://87378350610127";
    ParticleEmitter.Rate = 0;
    ParticleEmitter.Lifetime = NumberRange.new(1.4, 2.4);
    ParticleEmitter.Size = numbers({ { 0, 1.2, 0.4 }, { 1, 5, 1 } });
    ParticleEmitter.Transparency = numbers({ { 0, 1 }, { 0.1, 0.72 }, { 1, 1 } });
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(206, 184, 148));
    ParticleEmitter.LightEmission = 0.05;
    ParticleEmitter.LightInfluence = 0.9;
    ParticleEmitter.Speed = NumberRange.new(1.2, 3);
    ParticleEmitter.SpreadAngle = Vector2.new(30, 30);
    ParticleEmitter.EmissionDirection = Enum.NormalId.Back;
    ParticleEmitter.Acceleration = Vector3.new(0, 0.7, 0);
    ParticleEmitter.Drag = 1.4;
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.RotSpeed = NumberRange.new(-25, 25);
    ParticleEmitter.Parent = p15;

    return ParticleEmitter;
end;

function u1.new(p17: table) -- Line: 124
    -- upvalues: u1 (copy), motes (copy), u5 (copy), puffs (copy), numbers (copy), Lighting (copy), u4 (copy), Color3_fromRGB_ret (copy)
    local v18 = setmetatable({}, u1);
    v18.Events = p17.Data.Events;
    v18.Camera = p17.Camera;
    v18.Folder = p17.Folder;
    local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect");
    DepthOfFieldEffect.Name = "TutorialIntroFocus";
    DepthOfFieldEffect.Parent = p17.Camera;
    v18.Focus = DepthOfFieldEffect;
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "TutorialIntroGrade";
    ColorCorrectionEffect.Parent = p17.Camera;
    v18.Grade = ColorCorrectionEffect;
    local Folder = p17.Folder;
    local Part = Instance.new("Part");
    Part.Name = "BedDust";
    Part.Size = Vector3.new(7, 5.6, 13);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Parent = Folder;
    v18.BedDust = Part;
    v18.BedLocal = CFrame.new(0, 6, 2.2);
    local v19 = motes(Part, 14, 0.45);
    v19.LockedToPart = true;
    v18.BedMotes = v19;
    v18.WheelDust = {};

    for i, v in u5 do
        local Folder2 = p17.Folder;
        local Part2 = Instance.new("Part");
        Part2.Name = "WheelDust" .. i;
        Part2.Size = Vector3.new(0.6, 0.2, 0.6);
        Part2.Transparency = 1;
        Part2.Anchored = true;
        Part2.CanCollide = false;
        Part2.CanQuery = false;
        Part2.CanTouch = false;
        Part2.CastShadow = false;
        Part2.Parent = Folder2;
        local WheelDust = v18.WheelDust;
        local v20 = {
            Part = Part2,
            Local = CFrame.new(v),
            Emitter = puffs(Part2, "Dust")
        };
        table.insert(WheelDust, v20);
    end;

    local Folder2 = p17.Folder;
    local Part2 = Instance.new("Part");
    Part2.Name = "LandingDust";
    Part2.Size = Vector3.new(1.4, 0.2, 1.4);
    Part2.Transparency = 1;
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CanQuery = false;
    Part2.CanTouch = false;
    Part2.CastShadow = false;
    Part2.Parent = Folder2;
    local v21 = puffs(Part2, "Puffs");
    v21.EmissionDirection = Enum.NormalId.Top;
    v21.SpreadAngle = Vector2.new(75, 75);
    v21.Speed = NumberRange.new(2.5, 5);
    v21.Lifetime = NumberRange.new(0.9, 1.6);
    v21.Size = numbers({ { 0, 0.8, 0.3 }, { 1, 3.2, 0.6 } });
    v21.Acceleration = Vector3.new(0, -1.5, 0);
    v21.Drag = 3;
    v18.Landing = Part2;
    v18.LandingPuffs = v21;
    v18.Landed = {};
    local v22 = -(p17.SunDirection or Lighting:GetSunDirection());
    v18.ShaftParts = {};
    v18.ShaftBeams = {};
    v18.ShaftMotes = nil;

    if v22.Z > 0.2 and v22.Y < 0 then
        local v23 = 33 / v22.Z;
        local Folder3 = p17.Folder;
        local Part3 = Instance.new("Part");
        Part3.Name = "SunShaft";
        Part3.Size = Vector3.new(0.2, 0.2, 0.2);
        Part3.Transparency = 1;
        Part3.Anchored = true;
        Part3.CanCollide = false;
        Part3.CanQuery = false;
        Part3.CanTouch = false;
        Part3.CastShadow = false;
        Part3.Parent = Folder3;
        Part3.CFrame = CFrame.new(0, 0, -126);
        table.insert(v18.ShaftParts, Part3);

        for i, v in u4 do
            local Attachment = Instance.new("Attachment");
            Attachment.Parent = Part3;
            Attachment.WorldPosition = Vector3.new(v.X, v.Y, -128);
            local Attachment2 = Instance.new("Attachment");
            Attachment2.Parent = Part3;
            Attachment2.WorldPosition = Attachment.WorldPosition + v22 * v23;
            local Beam = Instance.new("Beam");
            Beam.Name = "Shaft" .. i;
            Beam.Attachment0 = Attachment;
            Beam.Attachment1 = Attachment2;
            Beam.Texture = "rbxassetid://901813002";
            Beam.TextureMode = Enum.TextureMode.Stretch;
            Beam.TextureLength = 1;
            Beam.FaceCamera = true;
            Beam.Width0 = 5 + i;
            Beam.Width1 = 7 + i;
            Beam.LightEmission = 1;
            Beam.LightInfluence = 0;
            Beam.Color = ColorSequence.new(Color3_fromRGB_ret);
            Beam.Segments = 1;
            Beam.Enabled = false;
            Beam.Parent = Part3;
            table.insert(v18.ShaftBeams, Beam);
        end;

        local Vector3_new_ret = Vector3.new(14, 9, v23);
        local Folder4 = p17.Folder;
        local Part4 = Instance.new("Part");
        Part4.Name = "ShaftDust";
        Part4.Size = Vector3_new_ret;
        Part4.Transparency = 1;
        Part4.Anchored = true;
        Part4.CanCollide = false;
        Part4.CanQuery = false;
        Part4.CanTouch = false;
        Part4.CastShadow = false;
        Part4.Parent = Folder4;
        local v24 = Vector3.new(1, 7, -126) + v22 * (v23 / 2);
        Part4.CFrame = CFrame.lookAt(v24, v24 + v22);
        table.insert(v18.ShaftParts, Part4);
        local v25 = motes(Part4, 0, 0.5);
        v25.LightInfluence = 0;
        v25.Size = numbers({ { 0, 0.05, 0.02 }, { 1, 0.05, 0.02 } });
        v25.Transparency = numbers({ { 0, 1 }, { 0.25, 0.55, 0.15 }, { 0.75, 0.6, 0.15 }, { 1, 1 } });
        v18.ShaftMotes = v25;
    end;

    v18.ShaftOn = false;
    v18.LastTruck = nil;
    v18.Speed = 0;

    return v18;
end;

local function shotAt(p26: any, p27: number) -- Line: 221
    return p26.ShotD <= p27 and "D" or (p26.ShotC <= p27 and "C" or (p26.ShotB <= p27 and "B" or "A"));
end;

function u1.Update(p28: table, p29: number, p30: number, p31, p32, p33: table) -- Line: 233
    -- upvalues: u2 (copy), u3 (copy)
    local Events = p28.Events;
    local math_clamp_ret = math.clamp((p29 - Events.LetterboxRetract[1]) / (Events.LetterboxRetract[2] - Events.LetterboxRetract[1]), 0, 1);
    local v34 = 1 - math_clamp_ret * math_clamp_ret * math_clamp_ret * (math_clamp_ret * (math_clamp_ret * 6 - 15) + 10);
    local v35 = u2[Events.ShotD <= p29 and "D" or (Events.ShotC <= p29 and "C" or (Events.ShotB <= p29 and "B" or "A"))];
    p28.Focus.FocusDistance = v35[1];
    p28.Focus.InFocusRadius = v35[2];
    p28.Focus.FarIntensity = v35[3] * v34;
    p28.Focus.NearIntensity = v35[4] * v34;
    p28.Focus.Enabled = v34 > 0.001;
    p28.Grade.Contrast = u3.Contrast * v34;
    p28.Grade.Saturation = u3.Saturation * v34;
    p28.Grade.TintColor = Color3.new(1, 1, 1):Lerp(u3.Tint, v34);
    p28.Grade.Enabled = v34 > 0.001;
    local Position = p32.Position;

    if p28.LastTruck and p30 > 0 then
        p28.Speed = p28.Speed + ((Position - p28.LastTruck).Magnitude / p30 - p28.Speed) * math.min(1, p30 * 8);
    end;

    p28.LastTruck = Position;
    p28.BedDust.CFrame = p31 * p28.BedLocal;
    local math_clamp_ret2 = math.clamp(p28.Speed / 14, 0, 1);

    for _, v in p28.WheelDust do
        v.Part.CFrame = p32 * v.Local;
        v.Emitter.Rate = math_clamp_ret2 * 16;
    end;

    if Events.ShotB <= p29 then
        for i, v in p33 do
            if not p28.Landed[i] and v.Position.Y < 3.3 then
                p28.Landed[i] = true;
                p28.Landing.CFrame = CFrame.new(v.Position.X, 0.15, v.Position.Z);
                p28.LandingPuffs:Emit(12);
            end;
        end;
    end;

    local v36;

    if Events.ShotB <= p29 then
        local math_clamp_ret3 = math.clamp((p29 - Events.ShotD) / 0.75, 0, 1);
        v36 = 1 - math_clamp_ret3 * math_clamp_ret3 * math_clamp_ret3 * (math_clamp_ret3 * (math_clamp_ret3 * 6 - 15) + 10);
    else
        v36 = 0;
    end;

    if v36 > 0 and not p28.ShaftOn then
        p28.ShaftOn = true;

        if p28.ShaftMotes then
            p28.ShaftMotes.Rate = 9;
            p28.ShaftMotes:Emit(45);
        end;
    elseif v36 <= 0 and (p28.ShaftOn and Events.ShotD <= p29) then
        p28.ShaftOn = false;

        if p28.ShaftMotes then
            p28.ShaftMotes.Rate = 0;
            p28.ShaftMotes:Clear();
        end;
    end;

    for i, v in p28.ShaftBeams do
        v.Enabled = v36 > 0;
        local v37 = 1 - (1 - (0.84 + 0.03 * i)) * v36;
        v.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, v37),
            NumberSequenceKeypoint.new(0.65, 1 - (1 - v37) * 0.8),
            NumberSequenceKeypoint.new(1, 1)
        });
    end;
end;

function u1.Shake(p38: table, u39: number) -- Line: 303
    if p38.Events.ShotB <= u39 then
        return CFrame.identity;
    end;

    local math_clamp_ret = math.clamp(p38.Speed / 14, 0.2, 1);

    local function n(p40: number, p41: number) -- Line: 309
        -- upvalues: u39 (copy)
        return math.noise(u39 * p40, p41, 0.5) + 0.35 * math.noise(u39 * 1.3, p41 + 7, 0.25);
    end;

    return CFrame.new(math_clamp_ret * 0.01600000075995922 * (math.noise(u39 * 9, 1, 0.5) + 0.35 * math.noise(u39 * 1.3, 8, 0.25)), math_clamp_ret * 0.026000000536441803 * (math.noise(u39 * 11, 2, 0.5) + 0.35 * math.noise(u39 * 1.3, 9, 0.25)), 0) * CFrame.Angles(math_clamp_ret * 0.0035000001080334187 * (math.noise(u39 * 8, 3, 0.5) + 0.35 * math.noise(u39 * 1.3, 10, 0.25)), math_clamp_ret * 0.002199999988079071 * (math.noise(u39 * 7, 4, 0.5) + 0.35 * math.noise(u39 * 1.3, 11, 0.25)), math_clamp_ret * 0.0044999998062849045 * (math.noise(u39 * 10, 5, 0.5) + 0.35 * math.noise(u39 * 1.3, 12, 0.25)));
end;

function u1.Destroy(p42) -- Line: 317
    p42.Focus:Destroy();
    p42.Grade:Destroy();
end;

return u1;