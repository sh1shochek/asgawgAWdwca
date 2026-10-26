-- ReplicatedStorage.Controllers.CandyController
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local AssetService = game:GetService("AssetService");
local SoundService = game:GetService("SoundService");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local HordeController = require(ReplicatedStorage.Controllers.HordeController);
local HordeProtocol = require(ReplicatedStorage.Components.Common.HordeProtocol);
local SurvivalCandy = require(ReplicatedStorage.Components.Common.SurvivalCandy);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local SurvivalBuyRules = require(ReplicatedStorage.Components.Common.SurvivalBuyRules);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local ObjectPool = require(ReplicatedStorage.Shared.ObjectPool);
local FarThrottle = require(ReplicatedStorage.Components.Common.FarThrottle);
local script_PickupFeed = require(script.PickupFeed);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = { 26, 32 };
local u3 = { 4, 8 };
local u4 = { 30, 38 };
local u5 = { 4, 8 };
local u6 = { 6.283185307179586, 12.566370614359172 };
local u7 = { 3, 12 };
local table_freeze_ret = table.freeze({ "Characters", HordeProtocol.SHELL_FOLDER, HordeProtocol.HITBOX_FOLDER });
local u8 = {
    CandyCorn = {
        Size = 1.5,
        Weight = 45,
        CenterY = 0.5,
        Trail = ColorSequence.new(Color3.fromRGB(255, 226, 92), Color3.fromRGB(255, 128, 24))
    },
    HardCandy = {
        Size = 1.8,
        Weight = 35,
        CenterY = 0,
        Trail = ColorSequence.new(Color3.fromRGB(176, 120, 255), Color3.fromRGB(255, 140, 40))
    },
    ChocolateBar = {
        Size = 1.7,
        Weight = 20,
        CenterY = 0.5,
        Trail = ColorSequence.new(Color3.fromRGB(255, 160, 70), Color3.fromRGB(110, 62, 34))
    }
};
local LocalPlayer = Players.LocalPlayer;
local Random_new_ret = Random.new();
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = nil;
local u13 = FarThrottle.new();
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u14 = (-1 / 0);
local u15 = {};
local u16 = {};
local u17 = {};
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = false;
local u24 = false;

local function range(p25: table) -- Line: 222
    -- upvalues: Random_new_ret (copy)
    return Random_new_ret:NextNumber(p25[1], p25[2]);
end;

local function now() -- Line: 226
    return os.clock();
end;

local function getDebrisFolder() -- Line: 230
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("Debris") or Workspace;
end;

local function makeFxPart(p26: string) -- Line: 234
    -- upvalues: Workspace (copy)
    local Part = Instance.new("Part");
    Part.Name = p26;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.CollisionGroup = "Debris";
    Part:SetAttribute("PersistentDebris", true);
    Part.Parent = Workspace:FindFirstChild("Debris") or Workspace;

    return Part;
end;

local function makeSound(p27: string, p28: number, p29: userdata, p30: number?) -- Line: 250
    local Sound = Instance.new("Sound");
    Sound.SoundId = p27;
    Sound.Volume = p28;
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
    Sound.RollOffMinDistance = p30 or 8;
    Sound.RollOffMaxDistance = 120;
    Sound.Parent = p29;

    return Sound;
end;

local function makeSparkles(p31: userdata, p32: userdata, p33: number) -- Line: 262
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds";
    ParticleEmitter.Color = p32;
    ParticleEmitter.LightEmission = 1;
    ParticleEmitter.LightInfluence = 0;
    ParticleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, p33), NumberSequenceKeypoint.new(1, 0) });
    ParticleEmitter.Transparency = NumberSequence.new(0.1);
    ParticleEmitter.Lifetime = NumberRange.new(0.35, 0.6);
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.RotSpeed = NumberRange.new(-180, 180);
    ParticleEmitter.Speed = NumberRange.new(0);
    ParticleEmitter.Enabled = false;
    ParticleEmitter.Parent = p31;

    return ParticleEmitter;
end;

local function buildFx() -- Line: 283
    -- upvalues: Workspace (copy), makeSparkles (copy), u18 (ref), u19 (ref), u20 (ref), u21 (ref), SoundService (copy), u22 (ref), ContentProvider (copy)
    local Part = Instance.new("Part");
    Part.Name = "CandyBurst";
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0.2, 0.2, 0.2);
    Part.CollisionGroup = "Debris";
    Part:SetAttribute("PersistentDebris", true);
    Part.Parent = Workspace:FindFirstChild("Debris") or Workspace;
    local Attachment = Instance.new("Attachment");
    Attachment.Parent = Part;
    local v34 = makeSparkles(Attachment, ColorSequence.new(Color3.fromRGB(255, 236, 190)), 1.4);
    v34.Name = "Stars";
    v34.Speed = NumberRange.new(4, 10);
    v34.SpreadAngle = Vector2.new(180, 180);
    v34.Drag = 4;
    local ParticleEmitter = Instance.new("ParticleEmitter");
    ParticleEmitter.Name = "Confetti";
    ParticleEmitter.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 136, 28)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 90, 255)) });
    ParticleEmitter.LightEmission = 0.3;
    ParticleEmitter.Size = NumberSequence.new(0.18, 0.05);
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1);
    ParticleEmitter.Speed = NumberRange.new(10, 18);
    ParticleEmitter.SpreadAngle = Vector2.new(60, 60);
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top;
    ParticleEmitter.Acceleration = Vector3.new(0, -40, 0);
    ParticleEmitter.Drag = 2;
    ParticleEmitter.Rotation = NumberRange.new(0, 360);
    ParticleEmitter.RotSpeed = NumberRange.new(-400, 400);
    ParticleEmitter.Enabled = false;
    ParticleEmitter.Parent = Attachment;
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://9126072453";
    Sound.Volume = 1.2;
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
    Sound.RollOffMinDistance = 25;
    Sound.RollOffMaxDistance = 120;
    Sound.Parent = Part;
    Sound.Name = "Burst";
    u18 = Part;
    u19 = v34;
    u20 = ParticleEmitter;
    u21 = Sound;
    local u35 = { Part };
    local Sound2 = Instance.new("Sound");
    Sound2.SoundId = "rbxassetid://15675012262";
    Sound2.Volume = 0.6;
    Sound2.Parent = SoundService;
    u22 = Sound2;
    u35[#u35 + 1] = Sound2;
    task.spawn(function() -- Line: 322
        -- upvalues: ContentProvider (ref), u35 (copy)
        pcall(ContentProvider.PreloadAsync, ContentProvider, u35);
    end);
end;

local function getSourcePart(u36: string) -- Line: 328
    -- upvalues: ReplicatedStorage (copy), SurvivalCandy (copy), AssetService (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild(SurvivalCandy.TEMPLATE_FOLDER);
    end;

    if Assets then
        Assets = Assets:FindFirstChild(u36);
    end;

    if Assets and Assets:IsA("MeshPart") then
        return Assets:Clone();
    end;

    local success, result = pcall(function() -- Line: 335
        -- upvalues: AssetService (ref), SurvivalCandy (ref), u36 (copy)
        return AssetService:CreateMeshPartAsync(Content.fromAssetId(SurvivalCandy.MESH_IDS[u36]));
    end);

    if success and result then
        result.TextureID = `rbxassetid://{SurvivalCandy.COLOR_MAP_ID}`;

        return result;
    end;

    warn((`[CandyController] no template for {u36}: {result}`));

    return nil;
end;

local function resetPart(p37) -- Line: 346
    p37.Trail.Enabled = false;
    p37.Glint.Enabled = false;
    p37.Transparency = 0;
end;

local function buildTemplate(p38: string) -- Line: 352
    -- upvalues: u8 (copy), getSourcePart (copy), makeSparkles (copy), u10 (copy)
    local v39 = u8[p38];
    local v40 = getSourcePart(p38);

    if not v40 then
        return nil;
    end;

    local Size = v40.Size;
    local v41 = v39.Size / math.max(Size.X, Size.Y, Size.Z);
    v40.Name = `Candy{p38}`;
    v40.Size = Size * v41;
    v40.Anchored = true;
    v40.CanCollide = false;
    v40.CanQuery = false;
    v40.CanTouch = false;
    v40.CastShadow = true;
    v40.CollisionGroup = "Debris";
    v40.Massless = true;
    local v42 = v40.Size.Y * v39.CenterY;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "TrailTop";
    Attachment.Position = Vector3.new(0, v42 + 0.22, 0);
    Attachment.Parent = v40;
    local Attachment2 = Instance.new("Attachment");
    Attachment2.Name = "TrailBottom";
    Attachment2.Position = Vector3.new(0, v42 - 0.22, 0);
    Attachment2.Parent = v40;
    local Trail = Instance.new("Trail");
    Trail.Name = "Trail";
    Trail.Attachment0 = Attachment;
    Trail.Attachment1 = Attachment2;
    Trail.FaceCamera = true;
    Trail.Lifetime = 0.35;
    Trail.MinLength = 0.05;
    Trail.WidthScale = NumberSequence.new(1, 0);
    Trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(0.6, 0.6), NumberSequenceKeypoint.new(1, 1) });
    Trail.LightEmission = 0.6;
    Trail.LightInfluence = 0;
    Trail.Color = v39.Trail;
    Trail.Enabled = false;
    Trail.Parent = v40;
    local v43 = makeSparkles(v40, ColorSequence.new(Color3.fromRGB(255, 244, 214)), 0.8);
    v43.Name = "Glint";
    v43.Rate = 0.7;
    v43.LockedToPart = true;
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://9126073644";
    Sound.Volume = 1.1;
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
    Sound.RollOffMinDistance = 25;
    Sound.RollOffMaxDistance = 120;
    Sound.Parent = v40;
    Sound.Name = "Pop";
    u10[p38] = v40.Size;

    return v40;
end;

local function buildPools() -- Line: 409
    -- upvalues: u8 (copy), buildTemplate (copy), u9 (copy), ObjectPool (copy), resetPart (copy), ContentProvider (copy), script_PickupFeed (copy), u23 (ref)
    for i in u8 do
        local u44 = buildTemplate(i);

        if u44 then
            u9[i] = ObjectPool.new(u44, {
                InitialSize = 6,
                MaxRetained = 40,
                Reset = resetPart
            });
            task.spawn(function() -- Line: 415
                -- upvalues: ContentProvider (ref), u44 (copy)
                pcall(ContentProvider.PreloadAsync, ContentProvider, { u44.Pop });
            end);
        end;
    end;

    script_PickupFeed.Preload();
    u23 = next(u9) ~= nil;
end;

local function pickKind() -- Line: 424
    -- upvalues: u8 (copy), u9 (copy), Random_new_ret (copy)
    local v45 = 0;

    for i, v in u8 do
        if u9[i] then
            v45 = v45 + v.Weight;
        end;
    end;

    local v46 = Random_new_ret:NextNumber() * v45;

    for i, v in u8 do
        if u9[i] then
            v46 = v46 - v.Weight;

            if v46 <= 0 then
                return i;
            end;
        end;
    end;

    return next(u9);
end;

local function refreshFilter(p47: number) -- Line: 443
    -- upvalues: u14 (ref), GetRayIgnore (copy), table_freeze_ret (copy), Workspace (copy), RaycastParams_new_ret (copy)
    if p47 - u14 < 1 then
        return;
    end;

    u14 = p47;
    local v48 = GetRayIgnore();

    for _, v in table_freeze_ret do
        local v49 = Workspace:FindFirstChild(v);

        if v49 then
            v48[#v48 + 1] = v49;
        end;
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v48;
end;

local function floatFrame(p50: table, p51: vector, p52: number) -- Line: 460
    local v53 = p52 + p50.FloatPhase;
    local v54 = math.sin(v53 * 0.6 * 2 * 3.141592653589793) * 0.25;
    local v55 = v53 * 2.6179938779914944;

    return CFrame.new(p51 + Vector3.new(0, v54, 0)) * CFrame.Angles(0, v55, 0) * CFrame.Angles(0.3141592653589793, 0, 0) * CFrame.Angles(0, v53 * 2.0943951023931953 - v55, 0);
end;

local function applyFrame(p56: table, p57) -- Line: 470
    p56.Rotation = p57.Rotation;
    p56.Position = p57.Position;
end;

local function getRoot() -- Line: 475
    -- upvalues: CharacterResolver (copy)
    local RootPart = CharacterResolver.getRootPart(CharacterResolver.getLocalCharacter());

    if RootPart then
        return RootPart.Position;
    end;

    return nil;
end;

local function canCollect() -- Line: 480
    -- upvalues: CharacterResolver (copy), LocalPlayer (copy), SurvivalDowned (copy)
    local v58 = CharacterResolver.isAlivePlayer(LocalPlayer) and not SurvivalDowned.IsDowned(LocalPlayer);

    return v58;
end;

local function setState(p59: table, p60: string, p61: number) -- Line: 484
    p59.State = p60;
    p59.StateAt = p61;
end;

local function release(p62: number) -- Line: 489
    -- upvalues: u11 (copy), u9 (copy)
    local v63 = u11[p62];
    u11[p62] = u11[#u11];
    u11[#u11] = nil;
    local v64 = u9[v63.Kind];
    v63.Part.Size = v63.BaseSize;

    if v64 then
        v64:Release(v63.Part, v63.Lease);

        return;
    end;

    v63.Part:Destroy();
end;

local function startMagnet(p65: table, p66: number) -- Line: 502
    p65.Velocity = p65.Velocity * 0.3 + Vector3.new(0, 12, 0);
    p65.MagnetAt = p66;
    p65.Part.Transparency = 0;
    p65.Part.Glint.Enabled = false;
    p65.Part.Trail.Enabled = true;
    p65.State = "Magnet";
    p65.StateAt = p66;
end;

local function handOff(p67: number) -- Line: 512
    -- upvalues: u11 (copy), u15 (copy), script_PickupFeed (copy), u9 (copy)
    local v68 = u11[p67];

    if not v68.Vacuum then
        u15[v68.Drop] = bit32.bor(u15[v68.Drop] or 0, v68.Bit);
    end;

    script_PickupFeed.Collect();
    local v69 = u11[p67];
    u11[p67] = u11[#u11];
    u11[#u11] = nil;
    local v70 = u9[v69.Kind];
    v69.Part.Size = v69.BaseSize;

    if v70 then
        v70:Release(v69.Part, v69.Lease);

        return;
    end;

    v69.Part:Destroy();
end;

local function flushClaims() -- Line: 521
    -- upvalues: u15 (copy), Remotes (copy)
    for i, v in u15 do
        Remotes.Survival.CollectCandy.Send({
            Drop = i,
            Mask = v
        });
    end;

    table.clear(u15);
end;

local function floatHeight(p71: table) -- Line: 529
    local BaseSize = p71.BaseSize;

    return math.max(BaseSize.X, BaseSize.Y, BaseSize.Z) * 0.5 + 0.6;
end;

local function startSettle(p72: table, p73: number) -- Line: 534
    p72.SettleFrom = CFrame.new(p72.Position) * p72.Rotation;
    p72.Velocity = Vector3.new(0, 0, 0);
    p72.Part.Trail.Enabled = false;
    p72.State = "Settle";
    p72.StateAt = p73;
end;

local function land(p74: table, p75, p76: number) -- Line: 542
    local Position = p75.Position;
    local BaseSize = p74.BaseSize;
    local v77 = math.max(BaseSize.X, BaseSize.Y, BaseSize.Z) * 0.5 + 0.6;
    p74.FloatCenter = Position + Vector3.new(0, v77, 0);
    p74.SettleFrom = CFrame.new(p74.Position) * p74.Rotation;
    p74.Velocity = Vector3.new(0, 0, 0);
    p74.Part.Trail.Enabled = false;
    p74.State = "Settle";
    p74.StateAt = p76;
end;

local function floorUnder(p78: vector, p79: number) -- Line: 548
    -- upvalues: Workspace (copy), RaycastParams_new_ret (copy)
    local v80 = Workspace:Raycast(p78, Vector3.new(0, -p79, 0), RaycastParams_new_ret);

    if v80 and v80.Normal.Y >= 0.6 then
        return v80;
    end;

    return nil;
end;

local function tryBrake(p81: table, p82: number) -- Line: 556
    -- upvalues: Workspace (copy), RaycastParams_new_ret (copy)
    local Position = p81.Position;
    local Velocity = p81.Velocity;
    local v83 = -Velocity.Y;

    if v83 <= 0 then
        return false;
    end;

    local BaseSize = p81.BaseSize;
    local v84 = math.max(BaseSize.X, BaseSize.Y, BaseSize.Z) * 0.5 + 0.6;
    local v85 = v84 + v83 * v83 / 320 + 1;
    local v86 = Workspace:Raycast(Position, Vector3.new(0, -v85, 0), RaycastParams_new_ret);

    if not v86 or v86.Normal.Y < 0.6 then
        v86 = nil;
    end;

    if not v86 then
        return false;
    end;

    local v87 = Position.Y - (v86.Position.Y + v84);

    if v87 <= 0 then
        p81.FloatCenter = Vector3.new(Position.X, v86.Position.Y + v84, Position.Z);
        p81.SettleFrom = CFrame.new(p81.Position) * p81.Rotation;
        p81.Velocity = Vector3.new(0, 0, 0);
        p81.Part.Trail.Enabled = false;
        p81.State = "Settle";
        p81.StateAt = p82;

        return true;
    end;

    if v83 * v83 / (2 * v87) < 160 then
        return false;
    end;

    local v88 = Position + Velocity * (v87 / v83);
    local Vector3_new_ret = Vector3.new(v88.X, Position.Y, v88.Z);
    local v89 = -(v85 + math.abs(v88.Y - Position.Y));
    local v90 = Workspace:Raycast(Vector3_new_ret, Vector3.new(0, v89, 0), RaycastParams_new_ret);

    if not v90 or v90.Normal.Y < 0.6 then
        v90 = nil;
    end;

    if v90 then
        v87 = Position.Y - (v90.Position.Y + v84);

        if v87 <= 0 then
            return false;
        end;
    end;

    local v91 = 2 * v87 / v83;
    local v92 = Position + Velocity * (v91 / 2);

    if Workspace:Raycast(Position, v92 - Position, RaycastParams_new_ret) then
        return false;
    end;

    p81.FloatCenter = v92;
    p81.BrakeFrom = Position;
    p81.BrakeVelocity = Velocity;
    p81.BrakeSeconds = v91;
    p81.State = "Brake";
    p81.StateAt = p82;

    return true;
end;

local function stepBrake(p93: table, p94: number, p95: number) -- Line: 601
    local BrakeSeconds = p93.BrakeSeconds;
    local math_min_ret = math.min(p95 - p93.StateAt, BrakeSeconds);
    p93.Position = p93.BrakeFrom + p93.BrakeVelocity * (math_min_ret - math_min_ret * math_min_ret / (BrakeSeconds * 2));
    p93.Velocity = p93.BrakeVelocity * (1 - math_min_ret / BrakeSeconds);
    p93.Rotation = CFrame.fromAxisAngle(p93.SpinAxis, p93.SpinSpeed * (1 - math_min_ret / BrakeSeconds) * p94) * p93.Rotation;

    return BrakeSeconds <= math_min_ret;
end;

local function stepFlight(p96: table, p97: number, p98: number) -- Line: 613
    -- upvalues: Workspace (copy), RaycastParams_new_ret (copy), tryBrake (copy)
    local Velocity = p96.Velocity;
    local v99 = Velocity - Vector3.new(0, p97 * 90, 0);
    local v100 = (Velocity + v99) * 0.5 * p97;
    p96.Velocity = v99;
    p96.Rotation = CFrame.fromAxisAngle(p96.SpinAxis, p96.SpinSpeed * p97) * p96.Rotation;
    local Magnitude = v100.Magnitude;

    if Magnitude < 0.0001 then
        return;
    end;

    local v101 = Workspace:Raycast(p96.Position, v100.Unit * (Magnitude + 0.3), RaycastParams_new_ret);

    if v101 then
        local Normal = v101.Normal;
        local v102 = p96.Velocity:Dot(Normal);

        if Normal.Y >= 0.6 then
            p96.Bounces = p96.Bounces + 1;
            local v103 = -v102 * 0.35;

            if p96.Bounces > 2 or v103 < 6 then
                local Position = v101.Position;
                local BaseSize = p96.BaseSize;
                local v104 = math.max(BaseSize.X, BaseSize.Y, BaseSize.Z) * 0.5 + 0.6;
                p96.FloatCenter = Position + Vector3.new(0, v104, 0);
                p96.SettleFrom = CFrame.new(p96.Position) * p96.Rotation;
                p96.Velocity = Vector3.new(0, 0, 0);
                p96.Part.Trail.Enabled = false;
                p96.State = "Settle";
                p96.StateAt = p98;

                return;
            end;

            p96.Velocity = (p96.Velocity - Normal * v102) * 0.6 + Normal * v103;
            p96.SpinSpeed = p96.SpinSpeed * 0.6;
        else
            p96.Velocity = (p96.Velocity - Normal * v102 * 1.4) * 0.8;
        end;

        p96.Position = v101.Position + Normal * 0.3;

        return;
    end;

    p96.Position = p96.Position + v100;

    if p96.Position.Y >= p96.Origin.Y - 60 then
        tryBrake(p96, p98);

        return;
    end;

    p96.Velocity = p96.Velocity * 0.3 + Vector3.new(0, 12, 0);
    p96.MagnetAt = p98;
    p96.Part.Transparency = 0;
    p96.Part.Glint.Enabled = false;
    p96.Part.Trail.Enabled = true;
    p96.State = "Magnet";
    p96.StateAt = p98;
end;

local function stepMagnet(p105: table, p106: number, p107: number) -- Line: 653
    -- upvalues: Workspace (copy)
    local v108 = p107 - p105.MagnetAt;

    if v108 >= 0.14 then
        return true;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        local v109 = CurrentCamera.CFrame.Position - p105.Position;

        if v109.Magnitude > 0.001 then
            p105.Velocity = p105.Velocity + v109.Unit * 150 * p106;
        end;
    end;

    p105.Position = p105.Position + p105.Velocity * p106;
    p105.Rotation = CFrame.fromAxisAngle(p105.SpinAxis, p105.SpinSpeed * 1.5 * p106) * p105.Rotation;
    local v110 = math.min(v108 / 0.14, 1) * 3.141592653589793 / 2;
    p105.Scale = math.sin(v110) * 0.19999999999999996 + 1;

    return false;
end;

local function inMagnetRange(p111: table, p112: vector) -- Line: 671
    -- upvalues: SurvivalCandy (copy)
    local v113 = p111.Position - p112;
    local v114;

    if math.abs(v113.Y) <= SurvivalCandy.MAGNET_VERTICAL then
        v114 = Vector2.new(v113.X, v113.Z).Magnitude <= SurvivalCandy.MAGNET_RADIUS;
    else
        v114 = false;
    end;

    return v114;
end;

local function update(p115: number) -- Line: 677
    -- upvalues: refreshFilter (copy), CharacterResolver (copy), LocalPlayer (copy), SurvivalDowned (copy), u16 (copy), u17 (copy), u13 (copy), u11 (copy), u9 (copy), u8 (copy), Workspace (copy), stepFlight (copy), SurvivalCandy (copy), stepBrake (copy), floatFrame (copy), u7 (copy), stepMagnet (copy), u15 (copy), script_PickupFeed (copy), flushClaims (copy), u12 (ref)
    local os_clock_ret = os.clock();
    refreshFilter(os_clock_ret);
    local RootPart = CharacterResolver.getRootPart(CharacterResolver.getLocalCharacter());
    local v116;

    if RootPart then
        v116 = RootPart.Position;
    else
        v116 = nil;
    end;

    local v117;

    if v116 == nil then
        v117 = false;
    else
        v117 = CharacterResolver.isAlivePlayer(LocalPlayer) and not SurvivalDowned.IsDowned(LocalPlayer);
    end;

    table.clear(u16);
    table.clear(u17);
    u13:Begin();
    local v118 = 1;

    while true do
        local v119, v120, v121, v122;
        local v119, v118, v120, v121, v122;
        local v123 = 0;

        while true do
            if v123 == 0 then
                v123 = -1;

                while true do
                    if v118 > #u11 then
                        if #u16 > 0 then
                            Workspace:BulkMoveTo(u16, u17, Enum.BulkMoveMode.FireCFrameChanged);
                        end;

                        flushClaims();

                        if #u11 == 0 and u12 then
                            u12:Disconnect();
                            u12 = nil;
                        end;

                        return;
                    end;

                    v120 = u11[v118];
                    v119 = v120.Part;
                    v121 = v120.State;
                    v122 = false;

                    if v121 == "Wait" or v119.Parent ~= nil then
                        break;
                    end;

                    local v124 = u11[v118];
                    u11[v118] = u11[#u11];
                    u11[#u11] = nil;
                    local v125 = u9[v124.Kind];
                    v124.Part.Size = v124.BaseSize;

                    if v125 then
                        v125:Release(v124.Part, v124.Lease);
                    else
                        v124.Part:Destroy();
                    end;
                end;

                if v121 ~= "Wait" then
                    v123 = 2;
                    continue;
                end;

                if v120.LaunchAt <= os_clock_ret then
                    local v126 = v120.BaseSize.Y * u8[v120.Kind].CenterY;
                    v119.CFrame = CFrame.new(v120.Position) * v120.Rotation * CFrame.new(0, -v126, 0);
                    v119.Parent = Workspace:FindFirstChild("Debris") or Workspace;
                    v119.Trail:Clear();
                    v119.Trail.Enabled = true;
                    v120.State = "Fly";
                    v120.StateAt = os_clock_ret;

                    if v120.Vacuum then
                        v120.Velocity = v120.Velocity * 0.3 + Vector3.new(0, 12, 0);
                        v120.MagnetAt = os_clock_ret;
                        v120.Part.Transparency = 0;
                        v120.Part.Glint.Enabled = false;
                        v120.Part.Trail.Enabled = true;
                        v120.State = "Magnet";
                        v120.StateAt = os_clock_ret;
                    else
                        v119.Pop.PlaybackSpeed = v120.Pitch;
                        v119.Pop:Play();
                    end;
                end;

                v123 = 1;
                continue;
            elseif v123 == 1 then
                v123 = -1;

                if v120.State ~= "Wait" and not v122 then
                    local v127 = v120.BaseSize * v120.Scale;

                    if v119.Size ~= v127 then
                        v119.Size = v127;
                    end;

                    u16[#u16 + 1] = v119;
                    local v128 = v127.Y * u8[v120.Kind].CenterY;
                    u17[#u17 + 1] = CFrame.new(v120.Position) * v120.Rotation * CFrame.new(0, -v128, 0);
                end;

                v118 = v118 + 1;
                v123 = 0;
                continue;
            elseif v123 == 2 then
                v123 = -1;

                if v121 == "Fly" then
                    stepFlight(v120, p115, os_clock_ret);

                    if v120.State == "Fly" and (v117 and (v116 and (os_clock_ret - v120.StateAt >= 0.35 and v120.Velocity.Y < 0))) then
                        local v129 = v120.Position - v116;
                        local v130;

                        if math.abs(v129.Y) <= SurvivalCandy.MAGNET_VERTICAL then
                            v130 = Vector2.new(v129.X, v129.Z).Magnitude <= SurvivalCandy.MAGNET_RADIUS;
                        else
                            v130 = false;
                        end;

                        if v130 then
                            v120.Velocity = v120.Velocity * 0.3 + Vector3.new(0, 12, 0);
                            v120.MagnetAt = os_clock_ret;
                            v120.Part.Transparency = 0;
                            v120.Part.Glint.Enabled = false;
                            v120.Part.Trail.Enabled = true;
                            v120.State = "Magnet";
                            v120.StateAt = os_clock_ret;
                        end;
                    end;

                    v123 = 1;
                    continue;
                end;

                if v121 == "Brake" then
                    if stepBrake(v120, p115, os_clock_ret) then
                        v120.SettleFrom = CFrame.new(v120.Position) * v120.Rotation;
                        v120.Velocity = Vector3.new(0, 0, 0);
                        v120.Part.Trail.Enabled = false;
                        v120.State = "Settle";
                        v120.StateAt = os_clock_ret;
                    end;

                    if v117 and v116 then
                        local v131 = v120.Position - v116;
                        local v132;

                        if math.abs(v131.Y) <= SurvivalCandy.MAGNET_VERTICAL then
                            v132 = Vector2.new(v131.X, v131.Z).Magnitude <= SurvivalCandy.MAGNET_RADIUS;
                        else
                            v132 = false;
                        end;

                        if v132 then
                            v120.Velocity = v120.Velocity * 0.3 + Vector3.new(0, 12, 0);
                            v120.MagnetAt = os_clock_ret;
                            v120.Part.Transparency = 0;
                            v120.Part.Glint.Enabled = false;
                            v120.Part.Trail.Enabled = true;
                            v120.State = "Magnet";
                            v120.StateAt = os_clock_ret;
                        end;
                    end;

                    v123 = 1;
                    continue;
                end;

                if v121 == "Settle" then
                    local math_clamp_ret = math.clamp((os_clock_ret - v120.StateAt) / 0.45, 0, 1);
                    local v133 = v120.SettleFrom:Lerp(floatFrame(v120, v120.FloatCenter, os_clock_ret), math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2));
                    v120.Rotation = v133.Rotation;
                    v120.Position = v133.Position;

                    if math_clamp_ret >= 1 then
                        v119.Glint.Enabled = true;
                        v120.State = "Rest";
                        v120.StateAt = os_clock_ret;
                    end;

                    if v117 and v116 then
                        local v134 = v120.Position - v116;
                        local v135;

                        if math.abs(v134.Y) <= SurvivalCandy.MAGNET_VERTICAL then
                            v135 = Vector2.new(v134.X, v134.Z).Magnitude <= SurvivalCandy.MAGNET_RADIUS;
                        else
                            v135 = false;
                        end;

                        if v135 then
                            v120.Velocity = v120.Velocity * 0.3 + Vector3.new(0, 12, 0);
                            v120.MagnetAt = os_clock_ret;
                            v120.Part.Transparency = 0;
                            v120.Part.Glint.Enabled = false;
                            v120.Part.Trail.Enabled = true;
                            v120.State = "Magnet";
                            v120.StateAt = os_clock_ret;
                        end;
                    end;

                    v123 = 1;
                    continue;
                end;

                if v121 == "Rest" then
                    local FloatCenter = v120.FloatCenter;
                    v122 = u13:Skips(FloatCenter, v118);

                    if not v122 then
                        local v136 = floatFrame(v120, FloatCenter, os_clock_ret);
                        v120.Rotation = v136.Rotation;
                        v120.Position = v136.Position;
                    end;

                    if v117 and v116 then
                        local v137 = v120.Position - v116;
                        local v138;

                        if math.abs(v137.Y) <= SurvivalCandy.MAGNET_VERTICAL then
                            v138 = Vector2.new(v137.X, v137.Z).Magnitude <= SurvivalCandy.MAGNET_RADIUS;
                        else
                            v138 = false;
                        end;

                        if v138 then
                            v120.Velocity = v120.Velocity * 0.3 + Vector3.new(0, 12, 0);
                            v120.MagnetAt = os_clock_ret;
                            v120.Part.Transparency = 0;
                            v120.Part.Glint.Enabled = false;
                            v120.Part.Trail.Enabled = true;
                            v120.State = "Magnet";
                            v120.StateAt = os_clock_ret;
                        elseif v120.ExpiresAt <= os_clock_ret then
                            v119.Glint.Enabled = false;
                            v119.Transparency = 0;
                            v120.State = "Shrink";
                            v120.StateAt = os_clock_ret;
                        elseif v120.ExpiresAt - 5 <= os_clock_ret then
                            v119.Transparency = (os_clock_ret - (v120.ExpiresAt - 5)) * (u7[1] + (u7[2] - u7[1]) * (1 - (v120.ExpiresAt - os_clock_ret) / 5)) % 1 < 0.5 and 0 or 0.75;
                        end;
                    elseif v120.ExpiresAt <= os_clock_ret then
                        v119.Glint.Enabled = false;
                        v119.Transparency = 0;
                        v120.State = "Shrink";
                        v120.StateAt = os_clock_ret;
                    elseif v120.ExpiresAt - 5 <= os_clock_ret then
                        v119.Transparency = (os_clock_ret - (v120.ExpiresAt - 5)) * (u7[1] + (u7[2] - u7[1]) * (1 - (v120.ExpiresAt - os_clock_ret) / 5)) % 1 < 0.5 and 0 or 0.75;
                    end;

                    v123 = 1;
                    continue;
                end;

                if v121 == "Shrink" then
                    local FloatCenter = v120.FloatCenter;

                    if FloatCenter then
                        local v139 = floatFrame(v120, FloatCenter, os_clock_ret);
                        v120.Rotation = v139.Rotation;
                        v120.Position = v139.Position;
                    end;

                    local v140 = (os_clock_ret - v120.StateAt) / 0.25;
                    v120.Scale = math.max(1 - v140, 0);

                    if v140 < 1 then
                        v123 = 1;
                        continue;
                    end;

                    local v141 = u11[v118];
                    u11[v118] = u11[#u11];
                    u11[#u11] = nil;
                    local v142 = u9[v141.Kind];
                    v141.Part.Size = v141.BaseSize;

                    if v142 then
                        v142:Release(v141.Part, v141.Lease);
                    else
                        v141.Part:Destroy();
                    end;
                else
                    if v121 ~= "Magnet" or not stepMagnet(v120, p115, os_clock_ret) then
                        v123 = 1;
                        continue;
                    end;

                    local v143 = u11[v118];

                    if not v143.Vacuum then
                        u15[v143.Drop] = bit32.bor(u15[v143.Drop] or 0, v143.Bit);
                    end;

                    script_PickupFeed.Collect();
                    local v144 = u11[v118];
                    u11[v118] = u11[#u11];
                    u11[#u11] = nil;
                    local v145 = u9[v144.Kind];
                    v144.Part.Size = v144.BaseSize;

                    if v145 then
                        v145:Release(v144.Part, v144.Lease);
                    else
                        v144.Part:Destroy();
                    end;
                end;

                break;
            else
                break;
            end;
        end;
    end;
end;

local function ensureBinding() -- Line: 804
    -- upvalues: u12 (ref), RunServiceController (copy), update (copy)
    if not u12 then
        u12 = RunServiceController.BindToRenderSteppedEvent("Survival.Candy", update);
    end;
end;

local function byExpiry(p146: table, p147: table) -- Line: 810
    return p146.ExpiresAt < p147.ExpiresAt;
end;

local function trimOverflow(p148: number) -- Line: 815
    -- upvalues: u11 (copy), byExpiry (copy)
    local v149 = #u11 - 60;

    if v149 <= 0 then
        return;
    end;

    local v150 = {};

    for _, v in u11 do
        if v.State == "Rest" and v.ExpiresAt > p148 + 1.5 then
            v150[#v150 + 1] = v;
        end;
    end;

    table.sort(v150, byExpiry);

    for i = 1, math.min(v149, #v150) do
        v150[i].ExpiresAt = p148 + 1.5;
        local _ = i;
    end;
end;

local function spawnDrop(p151: table) -- Line: 834
    -- upvalues: u23 (ref), HordeController (copy), u18 (ref), u19 (ref), u20 (ref), u21 (ref), Random_new_ret (copy), u4 (copy), u2 (copy), u5 (copy), u3 (copy), SurvivalCandy (copy), u9 (copy), pickKind (copy), u11 (copy), script_PickupFeed (copy), u6 (copy), u10 (copy), trimOverflow (copy), u12 (ref), RunServiceController (copy), update (copy)
    if not u23 then
        return;
    end;

    debug.profilebegin("Survival.Candy.Drop");
    local os_clock_ret = os.clock();
    local Origin = p151.Origin;
    local BodyPosition = HordeController.GetBodyPosition(p151.Zombie);

    if BodyPosition then
        if (BodyPosition - Origin).Magnitude > 6 then
            BodyPosition = Origin;
        end;
    else
        BodyPosition = Origin;
    end;

    local v152 = u18;
    local v153 = u19;
    local v154 = u20;
    local v155 = u21;

    if v152 and (v153 and (v154 and v155)) then
        v152.CFrame = CFrame.new(BodyPosition);
        v153:Emit(p151.Heavy and 14 or 8);
        v154:Emit(p151.Heavy and 24 or 12);
        v155.PlaybackSpeed = Random_new_ret:NextNumber(1, 1.08);
        v155.TimePosition = 0.25;
        v155:Play();
    end;

    local v156;

    if p151.Heavy then
        v156 = u4;
    else
        v156 = u2;
    end;

    local v157;

    if p151.Heavy then
        v157 = u5;
    else
        v157 = u3;
    end;

    local Direction = p151.Direction;

    for i = 1, math.min(p151.Count, SurvivalCandy.MAX_PIECES) do
        local v158 = p151.Heavy and (i == 1 and u9.ChocolateBar) and "ChocolateBar" or pickKind();
        local v159, v160 = u9[v158]:Acquire();
        v159.Trail.Enabled = false;
        v159.Glint.Enabled = false;
        v159.Transparency = 0;
        local v161 = Random_new_ret:NextNumber(0, 6.283185307179586);
        local v162 = Random_new_ret:NextNumber(v157[1], v157[2]);
        local v163 = math.cos(v161) * v162;
        local v164 = Random_new_ret:NextNumber(v156[1], v156[2]);
        local v165 = math.sin(v161) * v162;
        local v166 = Vector3.new(v163, v164, v165) + Direction * (v162 * 0.2 + 1.5);
        local v167 = Random_new_ret:NextUnitVector();
        local v168 = {
            State = "Wait",
            Bounces = 0,
            SettleFrom = nil,
            FloatCenter = nil,
            BrakeFrom = Vector3.new(0, 0, 0),
            BrakeVelocity = Vector3.new(0, 0, 0),
            BrakeSeconds = 0,
            Scale = 1,
            Vacuum = false,
            MagnetAt = 0,
            Kind = v158,
            Part = v159,
            Lease = v160,
            Drop = p151.Drop,
            Bit = bit32.lshift(1, i - 1),
            StateAt = os_clock_ret,
            LaunchAt = os_clock_ret + (i - 1) * 0.035,
            Pitch = script_PickupFeed.LadderPitch(i - 1),
            ExpiresAt = os_clock_ret + SurvivalCandy.LIFETIME,
            Origin = BodyPosition,
            Position = BodyPosition + Random_new_ret:NextUnitVector() * 0.3,
            Velocity = v166,
            Rotation = CFrame.fromAxisAngle(Random_new_ret:NextUnitVector(), Random_new_ret:NextNumber(0, 6.283185307179586)),
            SpinAxis = v167
        };
        local v169 = u6;
        v168.SpinSpeed = Random_new_ret:NextNumber(v169[1], v169[2]);
        v168.FloatPhase = Random_new_ret:NextNumber(0, 10);
        v168.BaseSize = u10[v158];
        u11[#u11 + 1] = v168;
        local _ = i;
    end;

    trimOverflow(os_clock_ret);

    if not u12 then
        u12 = RunServiceController.BindToRenderSteppedEvent("Survival.Candy", update);
    end;

    debug.profileend();
end;

local function vacuum() -- Line: 903
    -- upvalues: Workspace (copy), CharacterResolver (copy), u11 (copy), u22 (ref), u12 (ref), RunServiceController (copy), update (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local RootPart = CharacterResolver.getRootPart(CharacterResolver.getLocalCharacter());
    local u170;

    if RootPart then
        u170 = RootPart.Position;
    else
        u170 = nil;
    end;

    if not u170 then
        if CurrentCamera then
            u170 = CurrentCamera.CFrame.Position;
        else
            u170 = nil;
        end;
    end;

    if not u170 then
        return;
    end;

    local v171 = {};

    for _, v in u11 do
        if v.State ~= "Magnet" and v.State ~= "Shrink" then
            v.Vacuum = true;
            v171[#v171 + 1] = v;
        end;
    end;

    if #v171 == 0 then
        return;
    end;

    table.sort(v171, function(p172, p173) -- Line: 919
        -- upvalues: u170 (copy)
        return (p172.Position - u170).Magnitude < (p173.Position - u170).Magnitude;
    end);

    for i, v in v171 do
        if v.State ~= "Wait" then
            task.delay((i - 1) * 0.05, function() -- Line: 926
                -- upvalues: u11 (ref), v (copy)
                if table.find(u11, v) and (v.State ~= "Magnet" and v.State ~= "Shrink") then
                    local v174 = v;
                    local os_clock_ret = os.clock();
                    v174.Velocity = v174.Velocity * 0.3 + Vector3.new(0, 12, 0);
                    v174.MagnetAt = os_clock_ret;
                    v174.Part.Transparency = 0;
                    v174.Part.Glint.Enabled = false;
                    v174.Part.Trail.Enabled = true;
                    v174.State = "Magnet";
                    v174.StateAt = os_clock_ret;
                end;
            end);
        end;
    end;

    local v175 = u22;

    if v175 then
        v175:Play();
    end;

    if not u12 then
        u12 = RunServiceController.BindToRenderSteppedEvent("Survival.Candy", update);
    end;
end;

local function clearAll() -- Line: 939
    -- upvalues: u11 (copy), u9 (copy), u15 (copy), script_PickupFeed (copy)
    while #u11 > 0 do
        local v176 = #u11;
        local v177 = u11[v176];
        u11[v176] = u11[#u11];
        u11[#u11] = nil;
        local v178 = u9[v177.Kind];
        v177.Part.Size = v177.BaseSize;

        if v178 then
            v178:Release(v177.Part, v177.Lease);
        else
            v177.Part:Destroy();
        end;
    end;

    table.clear(u15);
    script_PickupFeed.Clear();
end;

local function buildOnceInSurvival() -- Line: 947
    -- upvalues: u24 (ref), SurvivalBuyRules (copy), buildFx (copy), buildPools (copy)
    if u24 or not SurvivalBuyRules.IsSurvival() then
        return;
    end;

    u24 = true;
    task.spawn(function() -- Line: 952
        -- upvalues: buildFx (ref), buildPools (ref)
        buildFx();
        buildPools();
    end);
end;

function v1.GetPieceCount() -- Line: 961
    -- upvalues: u11 (copy)
    return #u11;
end;

function v1.Start() -- Line: 968
    -- upvalues: u24 (ref), SurvivalBuyRules (copy), buildFx (copy), buildPools (copy), Remotes (copy), spawnDrop (copy), vacuum (copy), Workspace (copy), clearAll (copy)
    if not u24 and SurvivalBuyRules.IsSurvival() then
        u24 = true;
        task.spawn(function() -- Line: 952
            -- upvalues: buildFx (ref), buildPools (ref)
            buildFx();
            buildPools();
        end);
    end;

    Remotes.Survival.CandyDrop.Listen(function(p179: table) -- Line: 970
        -- upvalues: SurvivalBuyRules (ref), spawnDrop (ref)
        if type(p179) == "table" and SurvivalBuyRules.IsSurvival() then
            task.delay(0.12, spawnDrop, p179);
        end;
    end);
    Remotes.Survival.CandyVacuum.Listen(vacuum);
    Workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 976
        -- upvalues: SurvivalBuyRules (ref), clearAll (ref), u24 (ref), buildFx (ref), buildPools (ref)
        if not SurvivalBuyRules.IsSurvival() then
            clearAll();
        end;

        if not u24 then
            if not SurvivalBuyRules.IsSurvival() then
                return;
            end;

            u24 = true;
            task.spawn(function() -- Line: 952
                -- upvalues: buildFx (ref), buildPools (ref)
                buildFx();
                buildPools();
            end);
        end;
    end);
end;

return v1;