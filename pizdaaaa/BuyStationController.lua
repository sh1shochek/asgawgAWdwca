-- ReplicatedStorage.Controllers.BuyStationController
-- Script path: ReplicatedStorage.Controllers.BuyStationController
-- Decompile time: 28.13 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local SurvivalBuyRules = require(ReplicatedStorage.Components.Common.SurvivalBuyRules);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Color3_fromRGB_ret = Color3.fromRGB(80, 225, 240);
local NumberSequence_new_ret = NumberSequence.new(1);
local BUY_STATION_ARRIVE_SECONDS = SurvivalBuyRules.BUY_STATION_ARRIVE_SECONDS;
local BUY_STATION_DEPART_SECONDS = SurvivalBuyRules.BUY_STATION_DEPART_SECONDS;
local Color3_fromRGB_ret2 = Color3.fromRGB(225, 250, 255);
local Color3_new_ret = Color3.new(1, 1, 1);
local CFrame_Angles_ret = CFrame.Angles(0, 0, 1.5707963267948966);
local table_freeze_ret = table.freeze({ table.freeze({
        Width = 1,
        Transparency = 0.8
    }), table.freeze({
        Width = 0.62,
        Transparency = 0.7
    }), table.freeze({
        Width = 0.24,
        Transparency = 0.6
    }) });
local table_freeze_ret2 = table.freeze({
    Opened = 0.12,
    Strike = 0.3,
    Grow = 0.25,
    Solid = 0.95,
    Retract = 1,
    Retracted = 1.3,
    SourceGone = 1.45,
    Ring = 0.95,
    RingEnd = 1.5,
    PowerOn = 1.05,
    PowerOnEnd = 1.45
});
local table_freeze_ret3 = table.freeze({
    RingGone = 0.35,
    GlitchEnd = 0.5,
    Source = 0.1,
    Opened = 0.25,
    Strike = 0.45,
    Hologram = 0.45,
    Taken = 1,
    Retracted = 1.2,
    Fade = BUY_STATION_DEPART_SECONDS
});
local u2 = {};
local u3 = {};
local u4 = nil;
local u5 = nil;
local u6 = false;
local u7 = nil;
local u8 = {};
local u9 = {};

local function lerp(p10: number, p11: number, p12: number) -- Line: 258
    return p10 + (p11 - p10) * p12;
end;

local function ramp(p13: number, p14: number, p15: number) -- Line: 263
    return math.clamp((p13 - p14) / (p15 - p14), 0, 1);
end;

local function flickerOff(p16: number, p17: number, p18: number) -- Line: 268
    return math.noise(p16 * 22 + 0.5, p17 * 0.731) > 0.5 - p18;
end;

local function makeRing(p19: userdata, p20: userdata) -- Line: 276
    -- upvalues: SurvivalBuyRules (copy), Color3_fromRGB_ret (copy)
    local v21 = p20.Position.Y - p20.Size.Y / 2;
    local v22 = SurvivalBuyRules.BUY_STATION_RADIUS * 2 * 1.2;
    local Part = Instance.new("Part");
    Part.Name = "BuyStationRing";
    Part.Size = Vector3.new(v22, 0.05, v22);
    Part.CFrame = CFrame.new(p20.Position.X, v21 + 0.03, p20.Position.Z);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    local SurfaceGui = Instance.new("SurfaceGui");
    SurfaceGui.Face = Enum.NormalId.Top;
    SurfaceGui.LightInfluence = 0;
    SurfaceGui.Brightness = 1.3;
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud;
    SurfaceGui.PixelsPerStud = 48;
    SurfaceGui.Enabled = false;
    SurfaceGui.Parent = Part;
    local Frame = Instance.new("Frame");
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.BackgroundColor3 = Color3_fromRGB_ret;
    Frame.BackgroundTransparency = 0.9;
    Frame.BorderSizePixel = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3_fromRGB_ret;
    UIStroke.Thickness = 10;
    UIStroke.Parent = Frame;
    Frame.Parent = SurfaceGui;
    Part.Parent = p19;

    return {
        Part = Part,
        Gui = SurfaceGui,
        Circle = Frame,
        Stroke = UIStroke
    };
end;

local function isRingShown(p23: table) -- Line: 319
    -- upvalues: u6 (ref)
    return u6 and not p23.Departed and p23.RingReveal > 0;
end;

local function setRingReveal(p24: table, p25: number, p26: number) -- Line: 326
    -- upvalues: u6 (ref)
    if p25 == p24.RingReveal and p26 == p24.RingGlow then
        return;
    end;

    p24.RingReveal = p25;
    p24.RingGlow = p26;
    local Ring = p24.Ring;
    local math_clamp_ret = math.clamp(p25, 0, 1);
    local v27 = p25 / 1.2;
    local v28 = v27 * -20;
    Ring.Circle.Size = UDim2.new(v27, v28, v27, v28);
    Ring.Circle.BackgroundTransparency = 1 - math_clamp_ret * 0.09999999999999998;
    Ring.Stroke.Transparency = 1 - math_clamp_ret;
    Ring.Stroke.Thickness = (p26 * 1.5 + 1) * 10;
    Ring.Gui.Brightness = p26 * 3.7 + 1.3;
    Ring.Gui.Enabled = u6 and not p24.Departed and p24.RingReveal > 0;
end;

local function applyEntry(p29: table) -- Line: 344
    -- upvalues: u3 (copy), u6 (ref), NumberSequence_new_ret (copy)
    local v30 = p29.Departed or u3[p29.Model] ~= nil;
    p29.Ring.Gui.Enabled = u6 and not p29.Departed and p29.RingReveal > 0;

    for i, v in p29.Beams do
        local v31;

        if v30 then
            v31 = NumberSequence_new_ret;
        else
            v31 = v;
        end;

        i.Transparency = v31;
    end;

    if p29.Marker then
        p29.Marker.Enabled = u6 and not v30;
    end;
end;

local function track(p32: table, p33: userdata) -- Line: 358
    if p33:IsA("Beam") then
        if not p32.Beams[p33] then
            p32.Beams[p33] = p33.Transparency;
        end;
    else
        if p33:IsA("SurfaceGui") and p33.Name == "AmmoScreen" then
            p33.Enabled = false;

            return;
        end;

        if p33:IsA("BillboardGui") and p33.Name == "BillboardGui" then
            p32.Marker = p33;

            return;
        end;

        if p33:IsA("TextLabel") and p33.Name == "Distance" then
            p32.MarkerDistance = p33;
        end;
    end;
end;

local function updateMarkers() -- Line: 373
    -- upvalues: Workspace (copy), u2 (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local Position = CurrentCamera.CFrame.Position;

    for _, v in u2 do
        local MarkerDistance = v.MarkerDistance;

        if MarkerDistance and (v.Marker and v.Marker.Enabled) then
            local math_round_ret = math.round((v.Anchor.Position - Position).Magnitude);

            if math_round_ret ~= v.MarkerStuds then
                v.MarkerStuds = math_round_ret;
                MarkerDistance.Text = `{math_round_ret}m`;
            end;
        end;
    end;
end;

local function recordDescendant(p34: table, p35: userdata) -- Line: 398
    -- upvalues: Color3_fromRGB_ret (copy)
    if not p35:IsA("BasePart") or p35.Transparency >= 1 then
        if p35:IsA("Decal") then
            p34.Decals[p35] = p35.Transparency;

            if p34.Hologram then
                p35.Transparency = 1;
            end;
        end;

        return;
    end;

    local Parts = p34.Parts;
    local v36 = {
        Part = p35,
        Offset = p34.Anchor:ToObjectSpace(p35.CFrame),
        Size = p35.Size,
        Material = p35.Material,
        Color = p35.Color,
        Neon = p35.Material == Enum.Material.Neon
    };
    table.insert(Parts, v36);

    if p34.Hologram then
        p35.Material = Enum.Material.ForceField;
        p35.Color = Color3_fromRGB_ret;
    end;

    p35.LocalTransparencyModifier = p34.Transparency or 0;
end;

local function poseMachine(p37: table, p38: number, p39: number, p40: vector) -- Line: 424
    -- upvalues: u8 (copy), u9 (copy), Workspace (copy)
    local Vector3_new_ret = Vector3.new(p38, p39, p38);
    table.clear(u8);
    table.clear(u9);

    for i, v in p37.Parts do
        local Rotation = v.Offset.Rotation;
        v.Part.Size = v.Size * Vector3.new((Rotation.XVector * Vector3_new_ret).Magnitude, (Rotation.YVector * Vector3_new_ret).Magnitude, (Rotation.ZVector * Vector3_new_ret).Magnitude);
        u8[i] = v.Part;
        u9[i] = p37.Anchor * (Rotation + v.Offset.Position * Vector3_new_ret + p40);
    end;

    Workspace:BulkMoveTo(u8, u9, Enum.BulkMoveMode.FireCFrameChanged);
end;

local function setHologram(p41: table, p42: boolean) -- Line: 443
    -- upvalues: Color3_fromRGB_ret (copy)
    p41.Hologram = p42;

    for _, v in p41.Parts do
        local v43;

        if p42 then
            v43 = Enum.Material.ForceField;
        else
            v43 = v.Material;
        end;

        v.Part.Material = v43;
        local v44;

        if p42 then
            v44 = Color3_fromRGB_ret;
        else
            v44 = v.Color;
        end;

        v.Part.Color = v44;
    end;

    for i, v in p41.Decals do
        i.Transparency = p42 and 1 or v;
    end;
end;

local function setMachineTransparency(p45: table, p46: number, p47: number?, p48: number?) -- Line: 457
    local v49;

    if p47 == nil then
        v49 = false;
    else
        v49 = p48 ~= nil;
    end;

    if not v49 and p45.Transparency == p46 then
        return;
    end;

    local v50;

    if v49 then
        v50 = nil;
    else
        v50 = p46;
    end;

    p45.Transparency = v50;

    for i, v in p45.Parts do
        local v51;

        if p47 == nil or p48 == nil then
            v51 = false;
        else
            v51 = math.noise(p47 * 22 + 0.5, i * 0.731) > 0.5 - p48;
        end;

        v.Part.LocalTransparencyModifier = v51 and 0.55 or p46;
    end;
end;

local function flickerNeon(p52: table, p53: number, p54: number) -- Line: 470
    p52.Transparency = nil;

    for i, v in p52.Parts do
        if v.Neon then
            v.Part.LocalTransparencyModifier = p54 > 0 and (math.noise(p53 * 22 + 0.5, i * 0.731) > 0.5 - p54 and 1 or 0) or 0;
        end;
    end;
end;

local function restoreMachine(p55: table) -- Line: 480
    -- upvalues: setHologram (copy), poseMachine (copy)
    setHologram(p55, false);
    poseMachine(p55, 1, 1, Vector3.new(0, 0, 0));

    if p55.Transparency == 0 then
        return;
    end;

    p55.Transparency = 0;

    for _, v in p55.Parts do
        v.Part.LocalTransparencyModifier = 0;
    end;
end;

local function effectPart(p56: string, p57: userdata, p58) -- Line: 488
    local Part = Instance.new("Part");
    Part.Name = p56;
    Part.Shape = Enum.PartType.Cylinder;
    Part.Material = Enum.Material.Neon;
    Part.Color = p58;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Parent = p57;

    return Part;
end;

local function placeDisc(p59: userdata, p60, p61: number) -- Line: 506
    -- upvalues: CFrame_Angles_ret (copy)
    local math_max_ret = math.max(p61, 0.05);
    p59.Size = Vector3.new(0.08, math_max_ret, math_max_ret);
    p59.CFrame = p60 * CFrame.new(0, 0.04, 0) * CFrame_Angles_ret;
end;

local function makeEmitter(p62: userdata, p63: string) -- Line: 512
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = p63;
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds";
    ParticleEmitter.Rate = 0;
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box;
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume;
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top;
    ParticleEmitter.LightEmission = 1;
    ParticleEmitter.LightInfluence = 0;
    ParticleEmitter.Brightness = 3;
    ParticleEmitter.Color = ColorSequence.new(Color3_fromRGB_ret2, Color3_fromRGB_ret);
    ParticleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0.05) });
    ParticleEmitter.Parent = p62;

    return ParticleEmitter;
end;

local function makeConeRing(p64: userdata, p65: string) -- Line: 538
    -- upvalues: Color3_fromRGB_ret2 (copy)
    local Part = Instance.new("Part");
    Part.Name = p65;
    Part.Size = Vector3.new(1, 0.05, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;

    for _, v in { Enum.NormalId.Top, Enum.NormalId.Bottom } do
        local SurfaceGui = Instance.new("SurfaceGui");
        SurfaceGui.Face = v;
        SurfaceGui.LightInfluence = 0;
        SurfaceGui.Brightness = 3;
        SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud;
        SurfaceGui.PixelsPerStud = 48;
        SurfaceGui.Parent = Part;
        local Frame = Instance.new("Frame");
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromScale(0.5, 0.5);
        Frame.Size = UDim2.new(1, -16, 1, -16);
        Frame.BackgroundTransparency = 1;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0.5, 0);
        UICorner.Parent = Frame;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3_fromRGB_ret2;
        UIStroke.Thickness = 8;
        UIStroke.Transparency = 1;
        UIStroke.Parent = Frame;
        Frame.Parent = SurfaceGui;
    end;

    Part.Parent = p64;
end;

local function buildEffectTemplate() -- Line: 579
    -- upvalues: Color3_fromRGB_ret2 (copy), table_freeze_ret (copy), Color3_fromRGB_ret (copy), makeConeRing (copy), makeEmitter (copy), Color3_new_ret (copy)
    local Folder = Instance.new("Folder");
    Folder.Name = "BuyStationBeam";
    local Part = Instance.new("Part");
    Part.Name = "Source";
    Part.Shape = Enum.PartType.Cylinder;
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3_fromRGB_ret2;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Parent = Folder;
    Part.Shape = Enum.PartType.Ball;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "Apex";
    Attachment.Parent = Part;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Name = "ConeFoot";
    Attachment2.Parent = Part;

    for i, v in table_freeze_ret do
        local Beam = Instance.new("Beam");
        Beam.Name = `Cone{i}`;
        Beam.Attachment0 = Attachment;
        Beam.Attachment1 = Attachment2;
        Beam.FaceCamera = true;
        Beam.Segments = 1;
        Beam.LightEmission = 1;
        Beam.LightInfluence = 0;
        Beam.Brightness = 2;
        local v66;

        if i == #table_freeze_ret then
            v66 = Color3_fromRGB_ret2;
        else
            v66 = Color3_fromRGB_ret;
        end;

        Beam.Color = ColorSequence.new(v66);
        Beam.Transparency = NumberSequence.new(1);
        Beam.Width0 = 0.5 * v.Width;
        Beam.Width1 = 0.5 * v.Width;
        Beam.Parent = Part;
    end;

    makeConeRing(Folder, (`ConeRing{1}`));
    makeConeRing(Folder, (`ConeRing{2}`));
    makeConeRing(Folder, (`ConeRing{3}`));
    local Part2 = Instance.new("Part");
    Part2.Name = "Pool";
    Part2.Shape = Enum.PartType.Cylinder;
    Part2.Material = Enum.Material.Neon;
    Part2.Color = Color3_fromRGB_ret;
    Part2.Transparency = 1;
    Part2.Size = Vector3.new(1, 1, 1);
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CanQuery = false;
    Part2.CanTouch = false;
    Part2.CastShadow = false;
    Part2.Parent = Folder;
    local Part3 = Instance.new("Part");
    Part3.Name = "Shockwave";
    Part3.Shape = Enum.PartType.Cylinder;
    Part3.Material = Enum.Material.Neon;
    Part3.Color = Color3_fromRGB_ret;
    Part3.Transparency = 1;
    Part3.Size = Vector3.new(1, 1, 1);
    Part3.Anchored = true;
    Part3.CanCollide = false;
    Part3.CanQuery = false;
    Part3.CanTouch = false;
    Part3.CastShadow = false;
    Part3.Parent = Folder;
    local Part4 = Instance.new("Part");
    Part4.Name = "Base";
    Part4.Size = Vector3.new(6.6, 0.2, 6.6);
    Part4.Transparency = 1;
    Part4.Anchored = true;
    Part4.CanCollide = false;
    Part4.CanQuery = false;
    Part4.CanTouch = false;
    Part4.CastShadow = false;
    Part4.Parent = Folder;
    local Attachment3 = Instance.new("Attachment");
    Attachment3.Name = "LightAttachment";
    Attachment3.Position = Vector3.new(0, 3, 0);
    Attachment3.Parent = Part4;
    local PointLight = Instance.new("PointLight");
    PointLight.Color = Color3_fromRGB_ret;
    PointLight.Range = 20;
    PointLight.Brightness = 0;
    PointLight.Shadows = false;
    PointLight.Parent = Attachment3;
    local v67 = makeEmitter(Part, "Fall");
    v67.EmissionDirection = Enum.NormalId.Bottom;
    v67.SpreadAngle = Vector2.new(12.907408671265838, 12.907408671265838);
    v67.Speed = NumberRange.new(18, 26);
    v67.Lifetime = NumberRange.new(0.9230769230769231, 1.3333333333333333);
    local v68 = makeEmitter(Part4, "Rise");
    v68.Lifetime = NumberRange.new(0.8, 1.4);
    v68.Speed = NumberRange.new(10, 18);
    v68.SpreadAngle = Vector2.new(4, 4);
    local v69 = makeEmitter(Part4, "Sparks");
    v69.Lifetime = NumberRange.new(0.35, 0.9);
    v69.Speed = NumberRange.new(16, 34);
    v69.SpreadAngle = Vector2.new(80, 80);
    v69.Acceleration = Vector3.new(0, -35, 0);
    v69.Drag = 3;
    v69.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 0.05) });
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "Flash";
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.FillColor = Color3_new_ret;
    Highlight.OutlineColor = Color3_fromRGB_ret;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.Parent = Folder;

    return Folder;
end;

local function makeEffect(p70: table) -- Line: 669
    -- upvalues: u7 (ref), buildEffectTemplate (copy), table_freeze_ret (copy), Workspace (copy)
    local v71 = u7 or buildEffectTemplate();
    u7 = v71;
    local v72 = v71:Clone();
    local Source = v72.Source;
    Source.CFrame = p70.Anchor * CFrame.new(0, 24, 0);
    local v73 = {};

    for i in table_freeze_ret do
        local v74 = Source:FindFirstChild((`Cone{i}`));
        table.insert(v73, v74);
    end;

    local v75 = {};

    for i = 1, 3 do
        local v76 = v72:FindFirstChild((`ConeRing{i}`));
        local _ = i;
        local v77 = {};

        for _, descendant in v76:GetDescendants() do
            if descendant:IsA("UIStroke") then
                table.insert(v77, descendant);
            end;
        end;

        table.insert(v75, {
            Part = v76,
            Strokes = v77
        });
    end;

    local Base = v72.Base;
    Base.CFrame = p70.Anchor * CFrame.new(0, 0.1, 0);
    v72.Flash.Adornee = p70.Model;
    v72.Parent = Workspace:FindFirstChild("Debris") or Workspace;

    return {
        Folder = v72,
        Source = Source,
        Cone = v73,
        ConeFoot = Source.ConeFoot,
        ConeRings = v75,
        Pool = v72.Pool,
        Shockwave = v72.Shockwave,
        Light = Base.LightAttachment.PointLight,
        Fall = Source.Fall,
        Rise = Base.Rise,
        Sparks = Base.Sparks,
        Flash = v72.Flash
    };
end;

local function placeSource(p78: table, p79: number, p80: number) -- Line: 712
    local Source = p78.Effect.Source;
    Source.Size = Vector3.new(1, 1, 1) * math.max(p79 * 1.8, 0.05);
    Source.CFrame = p78.Entry.Anchor * CFrame.new(0, p80 + 24, 0);
    Source.Transparency = p79 > 0 and 0 or 1;
end;

local function shapeCone(p81: table, p82: number, p83: number, p84: number, p85: boolean) -- Line: 722
    -- upvalues: table_freeze_ret (copy), CFrame_Angles_ret (copy)
    local Effect = p81.Effect;
    local Anchor = p81.Entry.Anchor;
    local ConeFoot = Effect.ConeFoot;
    local v86 = -math.max(p83 * 24, 0.05);
    ConeFoot.Position = Vector3.new(0, v86, 0);
    local v87 = p83 * 10.5 + 0.5;

    for i, v in table_freeze_ret do
        local v88 = Effect.Cone[i];
        v88.Width0 = 0.5 * v.Width;
        v88.Width1 = v87 * v.Width;
        local v89 = 1 - (1 - v.Transparency) * p84;
        v88.Transparency = NumberSequence.new(v89, 1 - (1 - v89) * 0.55);
    end;

    for i, v in Effect.ConeRings do
        local v90 = (p82 * 1.4 + i / 3) % 1;

        if p85 then
            v90 = 1 - v90;
        end;

        local v91;

        if v90 <= p83 then
            v91 = p84 > 0;
        else
            v91 = false;
        end;

        local v92 = not v91 and 0 or math.sin(3.141592653589793 * v90) * p84;
        local math_max_ret = math.max(v90 * 11, 0.3);
        v.Part.Size = Vector3.new(math_max_ret, 0.05, math_max_ret);
        v.Part.CFrame = Anchor * CFrame.new(0, (1 - v90) * 24, 0);

        for _, v2 in v.Strokes do
            v2.Transparency = 1 - v92 * 0.65;
        end;
    end;

    local math_clamp_ret = math.clamp((p83 - 0.85) / 0.15, 0, 1);
    local Pool = Effect.Pool;
    local math_max_ret = math.max(p83 * 11, 0.05);
    Pool.Size = Vector3.new(0.08, math_max_ret, math_max_ret);
    Pool.CFrame = Anchor * CFrame.new(0, 0.04, 0) * CFrame_Angles_ret;
    Effect.Pool.Transparency = 1 - math_clamp_ret * 0.18000000000000005 * p84;
end;

local function stepShockwave(p93: table, p94: number, p95: number) -- Line: 756
    -- upvalues: TweenService (copy), CFrame_Angles_ret (copy)
    local math_clamp_ret = math.clamp((p94 - p95) / (p95 + 0.5 - p95), 0, 1);
    local Shockwave = p93.Effect.Shockwave;

    if p94 < p95 or math_clamp_ret >= 1 then
        Shockwave.Transparency = 1;

        return;
    end;

    local Value = TweenService:GetValue(math_clamp_ret, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
    local Anchor = p93.Entry.Anchor;
    local math_max_ret = math.max(Value * 16 + 2, 0.05);
    Shockwave.Size = Vector3.new(0.08, math_max_ret, math_max_ret);
    Shockwave.CFrame = Anchor * CFrame.new(0, 0.04, 0) * CFrame_Angles_ret;
    Shockwave.Transparency = math_clamp_ret * 0.5 + 0.5;
end;

local function playSound(p96: table, p97: string) -- Line: 768
    -- upvalues: Sound (copy)
    Sound.new("Survival"):PlaySoundAtPosition({
        Class = "Survival",
        Position = (p96.Entry.Anchor * CFrame.new(0, 3, 0)).Position,
        Name = p97
    });
end;

local function beat(p98: table, p99: string, p100: number, p101: number) -- Line: 777
    if p100 < p101 or p98.Fired[p99] then
        return false;
    end;

    p98.Fired[p99] = true;

    return true;
end;

local function stepArrive(p102: table, p103: number) -- Line: 787
    -- upvalues: playSound (copy), table_freeze_ret2 (copy), TweenService (copy), shapeCone (copy), stepShockwave (copy), setHologram (copy), poseMachine (copy), flickerNeon (copy), setRingReveal (copy)
    local Entry = p102.Entry;
    local Effect = p102.Effect;
    local v104;

    if p103 < 0 or p102.Fired.Sound then
        v104 = false;
    else
        p102.Fired.Sound = true;
        v104 = true;
    end;

    if v104 then
        playSound(p102, "Buy Station Arrive");
    end;

    local math_clamp_ret = math.clamp((p103 - 0) / (table_freeze_ret2.Opened - 0), 0, 1);
    local Retracted = table_freeze_ret2.Retracted;
    local math_clamp_ret2 = math.clamp((p103 - Retracted) / (table_freeze_ret2.SourceGone - Retracted), 0, 1);
    local v105;

    if math_clamp_ret2 > 0 then
        v105 = (1 - TweenService:GetValue(math_clamp_ret2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)) * 1.15;
    else
        v105 = TweenService:GetValue(math_clamp_ret, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
    end;

    local Source = p102.Effect.Source;
    Source.Size = Vector3.new(1, 1, 1) * math.max(v105 * 1.8, 0.05);
    Source.CFrame = p102.Entry.Anchor * CFrame.new(0, 24, 0);
    Source.Transparency = v105 > 0 and 0 or 1;
    local Opened = table_freeze_ret2.Opened;
    local math_clamp_ret3 = math.clamp((p103 - Opened) / (table_freeze_ret2.Strike - Opened), 0, 1);
    local Retract = table_freeze_ret2.Retract;
    local math_clamp_ret4 = math.clamp((p103 - Retract) / (table_freeze_ret2.Retracted - Retract), 0, 1);
    local v106;

    if p103 < table_freeze_ret2.Retract then
        v106 = TweenService:GetValue(math_clamp_ret3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
    else
        v106 = 1 - TweenService:GetValue(math_clamp_ret4, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
    end;

    shapeCone(p102, p103, v106, 1, false);
    stepShockwave(p102, p103, table_freeze_ret2.Strike);
    local Strike = table_freeze_ret2.Strike;
    local v107 = math.clamp((p103 - Strike) / (table_freeze_ret2.Strike + 0.25 - Strike), 0, 1) * -3.5 + 6;
    local v108;

    if p103 < table_freeze_ret2.Strike then
        v108 = 2.5 * v106;
    else
        v108 = v107 * v106;
    end;

    Effect.Light.Brightness = v108;
    Effect.Fall.Rate = table_freeze_ret2.Opened <= p103 and p103 < table_freeze_ret2.Solid and 60 or 0;
    local v109;

    if p103 < table_freeze_ret2.Strike or p102.Fired.Impact then
        v109 = false;
    else
        p102.Fired.Impact = true;
        v109 = true;
    end;

    if v109 then
        Effect.Sparks:Emit(55);
    end;

    if p103 < table_freeze_ret2.Grow then
        if Entry.Transparency ~= 1 then
            Entry.Transparency = 1;

            for _, v in Entry.Parts do
                v.Part.LocalTransparencyModifier = 1;
            end;
        end;
    elseif p103 < table_freeze_ret2.Solid then
        local v110;

        if p103 < table_freeze_ret2.Grow or p102.Fired.Hologram then
            v110 = false;
        else
            p102.Fired.Hologram = true;
            v110 = true;
        end;

        if v110 then
            setHologram(Entry, true);
        end;

        local Grow = table_freeze_ret2.Grow;
        local math_clamp_ret5 = math.clamp((p103 - Grow) / (table_freeze_ret2.Solid - Grow), 0, 1);
        local Value = TweenService:GetValue(math_clamp_ret5, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
        local Value2 = TweenService:GetValue(math_clamp_ret5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);
        poseMachine(Entry, Value * 0.95 + 0.05, Value * -0.6000000000000001 + 1.6, (Vector3.new(0, 8 * (1 - Value2), 0)));
        local v111 = p103 ~= nil;

        if v111 or Entry.Transparency ~= 0 then
            Entry.Transparency = not v111 and 0 or nil;

            for i, v in Entry.Parts do
                local v112;

                if p103 == nil then
                    v112 = false;
                else
                    v112 = math.noise(p103 * 22 + 0.5, i * 0.731) > 0.35;
                end;

                v.Part.LocalTransparencyModifier = v112 and 0.55 or 0;
            end;
        end;
    else
        local v113;

        if p103 < table_freeze_ret2.Solid or p102.Fired.Solid then
            v113 = false;
        else
            p102.Fired.Solid = true;
            v113 = true;
        end;

        if v113 then
            setHologram(Entry, false);
            poseMachine(Entry, 1, 1, Vector3.new(0, 0, 0));

            if Entry.Transparency ~= 0 then
                Entry.Transparency = 0;

                for _, v in Entry.Parts do
                    v.Part.LocalTransparencyModifier = 0;
                end;
            end;

            Effect.Sparks:Emit(20);
        end;

        local Solid = table_freeze_ret2.Solid;
        local math_clamp_ret5 = math.clamp((p103 - Solid) / (table_freeze_ret2.Solid + 0.4 - Solid), 0, 1);
        Effect.Flash.FillTransparency = math_clamp_ret5 * 0.9 + 0.1;
        Effect.Flash.OutlineTransparency = math_clamp_ret5 * 1 + 0;
        flickerNeon(Entry, p103, table_freeze_ret2.PowerOn <= p103 and p103 < table_freeze_ret2.PowerOnEnd and 0.45 or 0);
    end;

    local Ring = table_freeze_ret2.Ring;
    local math_clamp_ret5 = math.clamp((p103 - Ring) / (table_freeze_ret2.RingEnd - Ring), 0, 1);
    local Value = TweenService:GetValue(math_clamp_ret5, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
    setRingReveal(Entry, math_clamp_ret5 <= 0 and 0 or Value, 1 - math_clamp_ret5);
end;

local function stepDepart(p114: table, p115: number) -- Line: 847
    -- upvalues: playSound (copy), table_freeze_ret3 (copy), setRingReveal (copy), TweenService (copy), poseMachine (copy), flickerNeon (copy), setHologram (copy), shapeCone (copy), stepShockwave (copy)
    local Entry = p114.Entry;
    local Effect = p114.Effect;
    local v116 = Entry.Model.Parent ~= nil;
    local v117;

    if p115 < 0 or p114.Fired.Glitch then
        v117 = false;
    else
        p114.Fired.Glitch = true;
        v117 = true;
    end;

    if v117 then
        playSound(p114, "Buy Station Glitch");
        Effect.Sparks:Emit(10);
    end;

    local v118;

    if p115 < table_freeze_ret3.GlitchEnd * 0.5 or p114.Fired.Crackle then
        v118 = false;
    else
        p114.Fired.Crackle = true;
        v118 = true;
    end;

    if v118 then
        Effect.Sparks:Emit(10);
    end;

    if v116 then
        local math_clamp_ret = math.clamp((p115 - 0) / (table_freeze_ret3.RingGone - 0), 0, 1);
        setRingReveal(Entry, 1 - TweenService:GetValue(math_clamp_ret, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), math_clamp_ret);
    end;

    if v116 and p115 < table_freeze_ret3.Taken then
        if p115 < table_freeze_ret3.Hologram then
            local v119 = math.clamp((p115 - 0) / (table_freeze_ret3.GlitchEnd * 0.5 - 0), 0, 1) * 0.1;
            local math_noise_ret = math.noise(p115 * 30, 1.7);
            poseMachine(Entry, 1, 1, Vector3.new(math_noise_ret, 0, math.noise(p115 * 30, 4.2)) * v119 * 2);
            flickerNeon(Entry, p115, 0.35);
        else
            local v120;

            if p115 < table_freeze_ret3.Hologram or p114.Fired.Hologram then
                v120 = false;
            else
                p114.Fired.Hologram = true;
                v120 = true;
            end;

            if v120 then
                setHologram(Entry, true);
            end;

            local Hologram = table_freeze_ret3.Hologram;
            local Value = TweenService:GetValue(math.clamp((p115 - Hologram) / (table_freeze_ret3.Taken - Hologram), 0, 1), Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
            poseMachine(Entry, Value * -0.95 + 1, Value * 0.6000000000000001 + 1, (Vector3.new(0, 16 * Value, 0)));
            local v121 = p115 ~= nil;

            if v121 or Entry.Transparency ~= 0 then
                Entry.Transparency = not v121 and 0 or nil;

                for i, v in Entry.Parts do
                    local v122;

                    if p115 == nil then
                        v122 = false;
                    else
                        v122 = math.noise(p115 * 22 + 0.5, i * 0.731) > 0.35;
                    end;

                    v.Part.LocalTransparencyModifier = v122 and 0.55 or 0;
                end;
            end;
        end;

        local Hologram = table_freeze_ret3.Hologram;
        local math_clamp_ret = math.clamp((p115 - Hologram) / (table_freeze_ret3.Hologram + 0.25 - Hologram), 0, 1);
        Effect.Flash.FillTransparency = p115 < table_freeze_ret3.Hologram and 1 or math_clamp_ret * 0.8 + 0.2;
        Effect.Flash.OutlineTransparency = p115 < table_freeze_ret3.Hologram and 1 or math_clamp_ret * 1 + 0;
    else
        local v123;

        if p115 < table_freeze_ret3.Taken or p114.Fired.Taken then
            v123 = false;
        else
            p114.Fired.Taken = true;
            v123 = true;
        end;

        if v123 then
            if v116 and Entry.Transparency ~= 1 then
                Entry.Transparency = 1;

                for _, v in Entry.Parts do
                    v.Part.LocalTransparencyModifier = 1;
                end;
            end;

            Effect.Flash.FillTransparency = 1;
            Effect.Flash.OutlineTransparency = 1;
            playSound(p114, "Buy Station Depart");
        end;
    end;

    local v124 = math.max(p115 - table_freeze_ret3.Retracted, 0) * 260;
    local Source = table_freeze_ret3.Source;
    local math_clamp_ret = math.clamp((p115 - Source) / (table_freeze_ret3.Opened - Source), 0, 1);
    local v125;

    if p115 < table_freeze_ret3.Taken then
        v125 = TweenService:GetValue(math_clamp_ret, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
    else
        local Taken = table_freeze_ret3.Taken;
        v125 = math.clamp((p115 - Taken) / (table_freeze_ret3.Fade - Taken), 0, 1) * -1.1 + 1.5;
    end;

    local v126 = p115 < table_freeze_ret3.Source and 0 or v125;
    local Source2 = p114.Effect.Source;
    Source2.Size = Vector3.new(1, 1, 1) * math.max(v126 * 1.8, 0.05);
    Source2.CFrame = p114.Entry.Anchor * CFrame.new(0, v124 + 24, 0);
    Source2.Transparency = v126 > 0 and 0 or 1;
    local Source3 = Effect.Source;
    local v127;

    if p115 < table_freeze_ret3.Source then
        v127 = 1;
    else
        local Retracted = table_freeze_ret3.Retracted;
        v127 = math.clamp((p115 - Retracted) / (table_freeze_ret3.Fade - Retracted), 0, 1);
    end;

    Source3.Transparency = v127;
    local Opened = table_freeze_ret3.Opened;
    local math_clamp_ret2 = math.clamp((p115 - Opened) / (table_freeze_ret3.Strike - Opened), 0, 1);
    local Taken = table_freeze_ret3.Taken;
    local math_clamp_ret3 = math.clamp((p115 - Taken) / (table_freeze_ret3.Retracted - Taken), 0, 1);
    local v128;

    if p115 < table_freeze_ret3.Taken then
        v128 = TweenService:GetValue(math_clamp_ret2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
    else
        v128 = 1 - TweenService:GetValue(math_clamp_ret3, Enum.EasingStyle.Cubic, Enum.EasingDirection.In);
    end;

    shapeCone(p114, p115, v128, 1, true);
    stepShockwave(p114, p115, table_freeze_ret3.Strike);
    local v129;

    if p115 < table_freeze_ret3.Strike or p114.Fired.Impact then
        v129 = false;
    else
        p114.Fired.Impact = true;
        v129 = true;
    end;

    if v129 then
        Effect.Sparks:Emit(45);
    end;

    local Light = Effect.Light;
    local v130;

    if p115 < table_freeze_ret3.Taken then
        v130 = 2.5 * v128;
    else
        local Taken2 = table_freeze_ret3.Taken;
        v130 = (math.clamp((p115 - Taken2) / (table_freeze_ret3.Retracted - Taken2), 0, 1) * -6 + 6) * v128;
    end;

    Light.Brightness = v130;
    Effect.Rise.Rate = table_freeze_ret3.Strike <= p115 and p115 < table_freeze_ret3.Taken and 60 or 0;
end;

local function stopAnimation(p131: userdata) -- Line: 925
    -- upvalues: u3 (copy), u4 (ref), u2 (copy), applyEntry (copy)
    local v132 = u3[p131];

    if not v132 then
        return;
    end;

    u3[p131] = nil;
    v132.Effect.Folder:Destroy();

    if next(u3) == nil and u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    if u2[p131] then
        applyEntry(v132.Entry);
    end;
end;

local function finishAnimation(p133: table) -- Line: 941
    -- upvalues: setHologram (copy), poseMachine (copy), setRingReveal (copy), stopAnimation (copy)
    local Entry = p133.Entry;

    if p133.Kind == "arrive" then
        setHologram(Entry, false);
        poseMachine(Entry, 1, 1, Vector3.new(0, 0, 0));

        if Entry.Transparency ~= 0 then
            Entry.Transparency = 0;

            for _, v in Entry.Parts do
                v.Part.LocalTransparencyModifier = 0;
            end;
        end;

        setRingReveal(Entry, 1, 0);
    else
        Entry.Departed = true;

        if Entry.Model.Parent and Entry.Transparency ~= 1 then
            Entry.Transparency = 1;

            for _, v in Entry.Parts do
                v.Part.LocalTransparencyModifier = 1;
            end;
        end;
    end;

    stopAnimation(Entry.Model);
end;

local function animate() -- Line: 955
    -- upvalues: Workspace (copy), u3 (copy), BUY_STATION_ARRIVE_SECONDS (copy), BUY_STATION_DEPART_SECONDS (copy), finishAnimation (copy), stepArrive (copy), stepDepart (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow();

    for _, v in u3 do
        local v134 = ServerTimeNow - v.StartedAt;
        local v135;

        if v.Kind == "arrive" then
            v135 = BUY_STATION_ARRIVE_SECONDS;
        else
            v135 = BUY_STATION_DEPART_SECONDS;
        end;

        if v135 <= v134 then
            finishAnimation(v);
        elseif v.Kind == "arrive" then
            stepArrive(v, (math.max(v134, 0)));
        else
            stepDepart(v, (math.max(v134, 0)));
        end;
    end;
end;

local function startAnimation(p136: table, p137: string, p138: number) -- Line: 971
    -- upvalues: u3 (copy), finishAnimation (copy), BUY_STATION_ARRIVE_SECONDS (copy), BUY_STATION_DEPART_SECONDS (copy), Workspace (copy), applyEntry (copy), makeEffect (copy), setRingReveal (copy), u4 (ref), RunServiceController (copy), animate (copy)
    local Model = p136.Model;
    local v139 = u3[Model];

    if v139 then
        if v139.Kind == p137 then
            return;
        end;

        finishAnimation(v139);
    end;

    local v140;

    if p137 == "arrive" then
        v140 = BUY_STATION_ARRIVE_SECONDS;
    else
        v140 = BUY_STATION_DEPART_SECONDS;
    end;

    if v140 <= Workspace:GetServerTimeNow() - p138 then
        if p137 == "depart" then
            p136.Departed = true;

            if p136.Transparency ~= 1 then
                p136.Transparency = 1;

                for _, v in p136.Parts do
                    v.Part.LocalTransparencyModifier = 1;
                end;
            end;

            applyEntry(p136);
        end;

        return;
    end;

    u3[Model] = {
        Kind = p137,
        Entry = p136,
        StartedAt = p138,
        Effect = makeEffect(p136),
        Fired = {}
    };

    if p137 == "arrive" then
        if p136.Transparency ~= 1 then
            p136.Transparency = 1;

            for _, v in p136.Parts do
                v.Part.LocalTransparencyModifier = 1;
            end;
        end;

        setRingReveal(p136, 0, 0);
    end;

    if not u4 then
        u4 = RunServiceController.BindToRenderSteppedEvent("BuyStationController.Animate", animate);
    end;

    applyEntry(p136);
end;

local function readStamps(p141: table) -- Line: 1007
    -- upvalues: SurvivalBuyRules (copy), startAnimation (copy)
    local Attribute = p141.Model:GetAttribute(SurvivalBuyRules.BUY_STATION_DEPARTED_ATTRIBUTE);

    if typeof(Attribute) == "number" then
        startAnimation(p141, "depart", Attribute);

        return;
    end;

    local Attribute2 = p141.Model:GetAttribute(SurvivalBuyRules.BUY_STATION_ARRIVED_ATTRIBUTE);

    if typeof(Attribute2) == "number" then
        startAnimation(p141, "arrive", Attribute2);
    end;
end;

local function watch(u142: userdata, p143: any) -- Line: 1022
    -- upvalues: makeRing (copy), setRingReveal (copy), recordDescendant (copy), track (copy), applyEntry (copy), u2 (copy), u5 (ref), RunServiceController (copy), updateMarkers (copy), u3 (copy), stopAnimation (copy), SurvivalBuyRules (copy), readStamps (copy)
    local v144 = u142.PrimaryPart or u142:WaitForChild("Hitbox", 30);

    if not (v144 and (v144:IsA("BasePart") and u142.Parent)) then
        return;
    end;

    local u145 = {
        Departed = false,
        RingReveal = 1,
        Hologram = false,
        Transparency = 0,
        Model = u142,
        Ring = makeRing(u142, v144),
        Beams = {},
        Anchor = v144.CFrame * CFrame.new(0, -v144.Size.Y / 2, 0),
        Parts = {},
        Decals = {}
    };
    setRingReveal(u145, 1, 0);

    for _, descendant in u142:GetDescendants() do
        recordDescendant(u145, descendant);
    end;

    p143:Add(u145.Ring.Part);
    p143:Add(u142.DescendantAdded:Connect(function(p146) -- Line: 1044
        -- upvalues: recordDescendant (ref), u145 (copy), track (ref), applyEntry (ref)
        recordDescendant(u145, p146);
        track(u145, p146);
        applyEntry(u145);
    end));

    for _, descendant in u142:GetDescendants() do
        track(u145, descendant);
    end;

    u2[u142] = u145;

    if not u5 then
        u5 = RunServiceController.BindToRenderSteppedEvent("BuyStationController.Marker", updateMarkers);
    end;

    p143:Add(function() -- Line: 1056
        -- upvalues: u2 (ref), u142 (copy), u5 (ref), u3 (ref), stopAnimation (ref)
        u2[u142] = nil;

        if next(u2) == nil and u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        local v147 = u3[u142];

        if v147 and v147.Kind ~= "depart" then
            stopAnimation(u142);
        end;
    end, true);
    p143:Add(u142:GetAttributeChangedSignal(SurvivalBuyRules.BUY_STATION_DEPARTED_ATTRIBUTE):Connect(function() -- Line: 1069
        -- upvalues: readStamps (ref), u145 (copy)
        readStamps(u145);
    end));
    applyEntry(u145);
    readStamps(u145);
end;

local function observeStation(p148: userdata) -- Line: 1078
    -- upvalues: Janitor (copy), watch (copy)
    if not p148:IsA("Model") then
        return nil;
    end;

    local u149 = Janitor.new();
    u149:Add(task.spawn(watch, p148, u149), true);

    return function() -- Line: 1084
        -- upvalues: u149 (copy)
        u149:Destroy();
    end;
end;

local function setOpen(p150: boolean) -- Line: 1091
    -- upvalues: u6 (ref), u2 (copy), applyEntry (copy)
    if p150 == u6 then
        return;
    end;

    u6 = p150;

    for _, v in u2 do
        applyEntry(v);
    end;
end;

function v1.Start() -- Line: 1104
    -- upvalues: Observers (copy), SurvivalBuyRules (copy), observeStation (copy), Workspace (copy), GameState (copy), u6 (ref), u2 (copy), applyEntry (copy)
    Observers.observeTag(SurvivalBuyRules.BUY_STATION_TAG, observeStation, { Workspace });
    GameState.ListenToState(function(p151, p152) -- Line: 1106
        -- upvalues: u6 (ref), u2 (ref), applyEntry (ref)
        local v153 = p152 == "Round In Progress";

        if v153 == u6 then
            return;
        end;

        u6 = v153;

        for _, v in u2 do
            applyEntry(v);
        end;
    end);
end;

return v1;