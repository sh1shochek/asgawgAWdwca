-- ReplicatedStorage.GameClient.ParticleHandler
-- Script path: ReplicatedStorage.GameClient.ParticleHandler
-- Decompile time: 16.53 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("Debris");
local _ = game:GetService("Players").LocalPlayer;
local SoundManager = require(ReplicatedStorage.Shared.Managers.SoundManager);
local Surfaces = SoundManager.Surfaces;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = {};

local function RefreshConfig() -- Line: 29
    -- upvalues: u8 (copy), u2 (ref)
    u8.TimeScale = u2.Get("Game", "TimeScale");
end;

local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local workspace_Terrain = workspace.Terrain;
local _ = workspace.CurrentCamera;
local _ = ReplicatedStorage.GameStats;
local Particles = ReplicatedStorage.Assets.Particles;
local Tracer = Particles.Tracer;
local MuzzleFlash = Particles.MuzzleFlash;
local BulletSmoke = Particles.BulletSmoke;
local BloodSplatter = Particles.BloodSplatter;
local u15 = {
    Tracers = false,
    MuzzleFlashes = false
};
local u16 = {
    BulletHoles = true,
    MaximumBulletHoles = 128,
    BulletHoleLifetime = true,
    MaximumBulletHoleLifetime = 30
};
local u17 = {
    SurfaceMarks = true,
    Impacts = true,
    Blood = false
};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.IgnoreWater = true;
local CFrame_new_ret = CFrame.new(0, 0.285, 0);
local CFrame_new_ret2 = CFrame.new(0, -0.285, 0);
local u18 = {};
local u19 = nil;

local function StepTracers(p20) -- Line: 87
    -- upvalues: u18 (copy), CFrame_new_ret (copy), CFrame_new_ret2 (copy), u19 (ref)
    for i = #u18, 1, -1 do
        local v21 = u18[i];
        local v22;

        if v21.elapsed == nil then
            v21.elapsed = 0;
            v22 = i;
        else
            v21.elapsed = v21.elapsed + p20;

            if v21.elapsed >= v21.expires then
                v21.Tracer:Destroy();
                local v23 = #u18;
                u18[i] = u18[v23];
                u18[v23] = nil;
                v22 = i;
            else
                local v24 = v21.start:Lerp(v21.target, (math.min(v21.elapsed / v21.lifetime, 1)));
                v21.Part1.CFrame = v24 * CFrame_new_ret;
                v21.Part2.CFrame = v24 * CFrame_new_ret2;
                v22 = i;
            end;
        end;
    end;

    if #u18 == 0 then
        u19:Disconnect();
        u19 = nil;
    end;
end;

local u25 = {
    Default = "rbxassetid://87507735806927",
    Material = {
        Wood = { "rbxassetid://87659515490518", "rbxassetid://101915109043750" },
        Concrete = { "rbxassetid://78546082618660", "rbxassetid://87507735806927" },
        Plaster = { "rbxassetid://108835987855164", "rbxassetid://87507735806927" },
        Metal = { "rbxassetid://83068272314605", "rbxassetid://122211898626623" },
        Cardboard = { "rbxassetid://110547880835144" },
        Fabric = { "rbxassetid://110547880835144" },
        Glass = { "rbxassetid://71433690867627" },
        Plastic = { "rbxassetid://72855905361736" },
        SmoothPlastic = { "rbxassetid://72855905361736" }
    },
    Knife = { "rbxassetid://101063443263460", "rbxassetid://70927029012419", "rbxassetid://131587436632767" }
};
local u26 = {
    Wood = "Wood",
    WoodPlanks = "Wood",
    Concrete = "Concrete",
    Plaster = "Concrete",
    Asphalt = "Concrete",
    Pebble = "Concrete",
    Brick = "Concrete",
    Cardboard = "Dirt",
    Sand = "Dirt",
    Grass = "Dirt",
    Ground = "Dirt",
    Metal = "Metal",
    Glass = "Glass",
    Plastic = "Metal",
    SmoothPlastic = "Metal",
    Ice = "Metal"
};
local u27 = {
    ["Impacts.Concrete.ConcreteImpactBullet"] = 0.5,
    ["Impacts.Concrete.RockImpactHard"] = 0.5,
    ["Impacts.Concrete.RockImpactSoft"] = 0.5,
    ["Impacts.Metal.MetalSolidImpactBullet"] = 0.5,
    ["Impacts.Metal.MetalBoxImpactBullet"] = 0.5,
    ["Impacts.Metal.MetalBarrelImpactHard"] = 0.5,
    ["Impacts.Surfaces.TileImpactBullet"] = 0.5,
    ["Impacts.Glass.GlassImpactBullet"] = 0.3,
    ["Impacts.Cardboard.CardboardBoxImpactBullet"] = 0.3
};
local Names = Surfaces.Names;
local u28 = {};
local u29 = {};

local function scaleParticleSize(p30, p31) -- Line: 192
    if p31 == 1 then
        return;
    end;

    local Keypoints = p30.Size.Keypoints;
    local table_create_ret = table.create(#Keypoints);

    for i, v in Keypoints do
        table_create_ret[i] = NumberSequenceKeypoint.new(v.Time, v.Value * p31, v.Envelope * p31);
    end;

    p30.Size = NumberSequence.new(table_create_ret);
end;

local function raycast(p32, p33) -- Line: 213
    -- upvalues: RaycastParams_new_ret (copy)
    return workspace:Raycast(p32, p33, RaycastParams_new_ret);
end;

local function GetTextureForPart(p34, p35) -- Line: 219
    -- upvalues: u25 (copy)
    if p34 then
        local Knife = u25.Knife;

        return Knife[math.random(1, #Knife)];
    end;

    if p35 then
        p35 = u25.Material[p35];
    end;

    if p35 then
        return p35[math.random(1, #p35)];
    end;

    return u25.Default;
end;

local function NewHolePart() -- Line: 236
    local Part = Instance.new("Part");
    Part.Name = "BulletHole";
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.Anchored = true;
    local Decal = Instance.new("Decal");
    Decal.Face = Enum.NormalId.Front;
    Decal.Transparency = 0.5;
    Decal.Parent = Part;

    return Part;
end;

local function CreatePartBulletHole(p36: vector, p37: vector, p38: any, p39: any, p40: any) -- Line: 253
    -- upvalues: u25 (copy)
    local v41 = math.random(35, 45) / 100;
    local Part = Instance.new("Part");
    Part.Name = "BulletHole";
    Part.Transparency = 1;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.Anchored = true;
    local Decal = Instance.new("Decal");
    Decal.Face = Enum.NormalId.Front;
    Decal.Transparency = 0.5;
    Decal.Parent = Part;
    Part.Size = vector.create(v41, v41, 0.05);
    local CFrame_lookAt_ret = CFrame.lookAt(p36, p36 + p37);
    local CFrame_Angles = CFrame.Angles;
    local v42;

    if p38 then
        v42 = 0;
    else
        local math_random_ret = math.random(0, 360);
        v42 = math.rad(math_random_ret);
    end;

    Part.CFrame = CFrame_lookAt_ret * CFrame_Angles(0, 0, v42);
    local Decal2 = Part.Decal;
    local v43;

    if p38 then
        local Knife = u25.Knife;
        v43 = Knife[math.random(1, #Knife)];
    else
        if p39 then
            p39 = u25.Material[p39];
        end;

        if p39 then
            v43 = p39[math.random(1, #p39)];
        else
            v43 = u25.Default;
        end;
    end;

    Decal2.Texture = v43;

    if p38 or not p40 then
        p40 = Color3.new(1, 1, 1);
    end;

    Decal2.Color3 = p40;
    Part.Parent = workspace.Terrain;

    return Part;
end;

local function RemoveBulletHole(p44: any, p45: number?) -- Line: 274
    -- upvalues: u29 (copy), u28 (copy)
    local v46 = u29[p44];

    if v46 then
        u29[p44] = nil;
        task.cancel(v46);
    end;

    local v47 = p45 or table.find(u28, p44);

    if v47 then
        table.remove(u28, v47);
    end;

    p44:Destroy();
end;

local function ExpireHole(p48) -- Line: 297
    -- upvalues: u29 (copy), RemoveBulletHole (copy)
    u29[p48] = nil;
    RemoveBulletHole(p48);
end;

local function EnforceBulletHoleLimit() -- Line: 303
    -- upvalues: u16 (copy), u28 (copy), RemoveBulletHole (copy)
    if not u16.BulletHoles then
        return;
    end;

    while #u28 > u16.MaximumBulletHoles do
        RemoveBulletHole(u28[1], 1);
    end;
end;

function u1.ClearBulletHoles() -- Line: 314
    -- upvalues: u28 (copy), RemoveBulletHole (copy)
    for i = #u28, 1, -1 do
        RemoveBulletHole(u28[i], i);
        local _ = i;
    end;
end;

function u1.CreateBloodSplatter(p49, p50) -- Line: 349
    -- upvalues: RaycastParams_new_ret (copy), BloodSplatter (copy), workspace_Terrain (copy), u3 (ref)
    local v51 = workspace:Raycast(p49, -p50 * 5, RaycastParams_new_ret) or workspace:Raycast(p49, Vector3.new(0, -10, 0), RaycastParams_new_ret);

    if not v51 then
        return;
    end;

    local Normal = v51.Normal;
    local Position = v51.Position;

    if not (Normal and Position) then
        return;
    end;

    local v52 = BloodSplatter:Clone();
    v52.CFrame = CFrame.new(Position, Position + Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
    v52.Parent = workspace_Terrain;

    for _, descendant in v52:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.LockedToPart = true;
            descendant:Emit(descendant:GetAttribute("EmitCount"));
        end;
    end;

    u3:Delay(5, v52.Destroy, v52);
end;

function u1.CreateBulletSmoke(p53, p54, p55, p56, p57, p58) -- Line: 384
    -- upvalues: u26 (copy), u1 (copy), BulletSmoke (copy), workspace_Terrain (copy), u3 (ref)
    local v59 = p55 and u26[p55] or "Default";

    if p57 then
        if p58 then
            u1.CreateBulletSmoke(p53, p54, "Metal", nil, false, true);
            v59 = "Blood";
        else
            v59 = "Blood";
        end;
    end;

    local v60 = BulletSmoke[v59]:Clone();
    v60.CFrame = CFrame.new(p53, p53 + p54);
    v60.Parent = workspace_Terrain;
    local v61 = p56 and not (p57 or p58) and ColorSequence.new(p56);

    for _, descendant in v60:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            if v61 then
                descendant.Color = v61;
            end;

            descendant:Emit(descendant:GetAttribute("EmitCount"));
        end;
    end;

    u3:Delay(1, v60.Destroy, v60);
end;

function u1.PlayBulletImpact(p62) -- Line: 426
    -- upvalues: Names (copy), Surfaces (copy), SoundManager (copy), u27 (copy)
    if p62.IsCharacter then
        return;
    end;

    local Bullet = Surfaces.Get(Names[p62.Material]).Bullet;
    SoundManager.Play(Bullet, {
        Position = p62.Position
    });
    local v63 = u27[Bullet];

    if v63 and math.random() < v63 then
        SoundManager.Play("Other.Debris", {
            Position = p62.Position
        });
    end;
end;

function u1.PlayPainSound(p64: string?, p65: boolean, p66: boolean, p67: string?) -- Line: 448
    -- upvalues: u6 (ref), SoundManager (copy)
    local v68, v69 = u6.PainSoundKeys(p64, p65, p66, p67);
    SoundManager.Play(v68);

    if v69 then
        SoundManager.Play(v69);
    end;
end;

function u1.CreateBulletHole(p70) -- Line: 458
    -- upvalues: u5 (ref), Names (copy), u17 (copy), u1 (copy), u7 (ref), CreatePartBulletHole (copy), u28 (copy), u16 (copy), RemoveBulletHole (copy), u29 (copy), u8 (copy), ExpireHole (copy)
    if not u5:VisiblePoint(p70.Position, 1) then
        return;
    end;

    local v71 = Names[p70.Material];

    if p70.IsCharacter then
        if u17.Impacts then
            if u17.Blood then
                u1.CreateBulletSmoke(p70.Position, p70.Normal, v71, p70.Color, true, p70.HasHelmet);
            elseif p70.HasHelmet then
                u1.CreateBulletSmoke(p70.Position, p70.Normal, "Metal", nil, false, true);
            end;
        end;

        if u17.Blood then
            u1.CreateBloodSplatter(p70.Position, p70.Normal);
        end;

        return;
    end;

    if u17.Impacts then
        u1.CreateBulletSmoke(p70.Position, p70.Normal, v71, p70.Color, false, p70.HasHelmet);
    end;

    if not u17.SurfaceMarks or u7.Contains(p70.Position) then
        return;
    end;

    local v72 = CreatePartBulletHole(p70.Position, p70.Normal, p70.Knife, v71, p70.Color);
    table.insert(u28, v72);

    if u16.BulletHoles then
        while #u28 > u16.MaximumBulletHoles do
            RemoveBulletHole(u28[1], 1);
        end;
    end;

    if u16.BulletHoleLifetime then
        u29[v72] = task.delay(u16.MaximumBulletHoleLifetime / u8.TimeScale, ExpireHole, v72);
    end;
end;

function u1.CreateTracer(p73, p74) -- Line: 505
    -- upvalues: u15 (copy), Tracer (copy), CFrame_new_ret (copy), CFrame_new_ret2 (copy), u18 (copy), u19 (ref), RunService (copy), StepTracers (copy)
    if u15.Tracers then
        return;
    end;

    local v75 = Tracer:Clone();
    local StartPosition = p73.StartPosition;
    local EndPosition = p73.EndPosition;
    local vector_magnitude_ret = vector.magnitude(EndPosition - StartPosition);
    local v76 = StartPosition + (EndPosition - StartPosition) * (math.min(0.15, vector_magnitude_ret) / math.max(vector_magnitude_ret, 0.001));
    local v77 = (vector_magnitude_ret - math.min(0.15, vector_magnitude_ret)) / 600;
    v75.Lifetime = 0.05;
    local CFrame_lookAt_ret = CFrame.lookAt(v76, EndPosition);
    local CFrame_new_ret3 = CFrame.new(EndPosition, 2 * EndPosition - v76);
    v75["1"].CFrame = CFrame_lookAt_ret * CFrame_new_ret;
    v75["2"].CFrame = CFrame_lookAt_ret * CFrame_new_ret2;
    v75.Parent = workspace;
    table.insert(u18, {
        Tracer = v75,
        Part1 = v75["1"],
        Part2 = v75["2"],
        start = CFrame_lookAt_ret,
        target = CFrame_new_ret3,
        lifetime = v77,
        expires = v77 + v75.Lifetime
    });

    if not u19 then
        u19 = RunService.PostSimulation:Connect(StepTracers);
    end;
end;

function u1.CreateMuzzleFlash(p78, p79, p80) -- Line: 544
    -- upvalues: u15 (copy), u5 (ref), MuzzleFlash (copy), scaleParticleSize (copy), u3 (ref)
    if u15.MuzzleFlashes then
        return;
    end;

    if not u5:VisiblePoint(p78.Position, 1) then
        return;
    end;

    local v81 = MuzzleFlash[p79 or "Default"]:Clone();
    v81.Parent = p78;

    for _, descendant in v81:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            scaleParticleSize(descendant, p80 and 1 or 0.15);
            descendant.LockedToPart = true;
            descendant:Emit(descendant:GetAttribute("EmitCount"));
        end;
    end;

    u3:Delay(0.1, v81.Destroy, v81);
end;

local function GetCharacterMuzzle(p82) -- Line: 575
    -- upvalues: u10 (ref), u13 (ref)
    if p82 then
        p82 = u10.GetEntity("Character", p82);
    end;

    local v83;

    if p82 then
        v83 = p82.CharacterCurrentWeapon;
    else
        v83 = p82;
    end;

    if p82 then
        p82 = p82.CurrentWeaponModel;
    end;

    if v83 and p82 then
        local v84 = u13.Get(v83.Name);

        if v84 then
            v84 = v84.Data;
        end;

        local v85;

        if v84 then
            v85 = v84.AltFunction;
        else
            v85 = v84;
        end;

        if v85 then
            if v85.Name == "Silencer" then
                v85 = v83.Mode == 1;
            else
                v85 = false;
            end;
        end;

        local v86;

        if v83.Name == "Dual Berettas" then
            v86 = (v83.Ammo or 0) % 2 == 1;
        else
            v86 = false;
        end;

        local v87 = p82:FindFirstChild(v85 and "SilencerMuzzle" or (v86 and "LeftMuzzle" or "Muzzle"));

        if v85 then
            return v87, "Silencer";
        end;

        if v84 then
            v84 = v84.Muzzle;
        end;

        return v87, v84;
    end;
end;

function u1.Init(p88) -- Line: 596
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u12 (ref), u13 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (copy), RefreshConfig (copy), u9 (ref), u10 (ref), u11 (ref), u14 (ref), RaycastParams_new_ret (copy)
    u2 = p88:GetModule("GameConfiguration");
    u3 = p88:GetModule("Threads");
    u4 = p88:GetModule("Network");
    u12 = p88:GetModule("Enums");
    u13 = p88:GetModule("WeaponManager");
    u5 = p88:GetModule("FrustumCuller").Shared();
    u6 = p88:GetModule("DamageCalculation");
    u7 = p88:GetModule("Breakables");
    u8.TimeScale = u2.Get("Game", "TimeScale");
    u2.Updated:Connect(RefreshConfig);
    u9 = p88:GetModule("Gui");
    u10 = p88:GetModule("Entities");
    u11 = p88:GetModule("Spectate");
    u14 = p88:GetModule("NewMapAdded");

    if workspace:FindFirstChild("Map") then
        local Map = workspace:FindFirstChild("Map");

        if Map then
            Map = Map:FindFirstChild("Geometry");
        end;

        RaycastParams_new_ret.FilterDescendantsInstances = Map and { Map } or {};
    end;
end;

function u1.Start(p89) -- Line: 620
    -- upvalues: u14 (ref), RaycastParams_new_ret (copy), u4 (ref), u1 (copy), SoundManager (copy), u11 (ref), GetCharacterMuzzle (copy), u9 (ref), u15 (copy), u16 (copy), u28 (copy), RemoveBulletHole (copy), u17 (copy)
    u14.OnMapAdded:Connect(function(p90) -- Line: 621
        -- upvalues: RaycastParams_new_ret (ref)
        RaycastParams_new_ret.FilterDescendantsInstances = { p90.Geometry };
    end);
    u4.Particles.CreateBulletHole.On(function(p91) -- Line: 625
        -- upvalues: u1 (ref)
        for _, v in p91 do
            u1.PlayBulletImpact(v);
            u1.CreateBulletHole(v);
        end;
    end);
    u4.PlaySoundOnPosition.On(function(p92, p93) -- Line: 641
        -- upvalues: SoundManager (ref)
        local v94 = SoundManager.Unpack(p92);

        if v94 then
            local Play = SoundManager.Play;
            local v95 = {};

            if p93 == Vector3.new(0, 0, 0) then
                p93 = nil;
            end;

            v95.Position = p93;
            Play(v94, v95);
        end;
    end);
    u4.Particles.CreateTracer.On(function(p96) -- Line: 649
        -- upvalues: u11 (ref), GetCharacterMuzzle (ref), u1 (ref)
        local v97 = {};

        for _, v in p96 do
            local Identifier = v.Identifier;

            if not u11.IsFirstPersonTarget(Identifier) then
                local v98 = v97[Identifier];

                if v98 == nil then
                    local v99, v100 = GetCharacterMuzzle(Identifier);
                    v98 = v99 and {
                        Part = v99,
                        Name = v100
                    } or false;
                    v97[Identifier] = v98;

                    if v98 then
                        u1.CreateMuzzleFlash(v98.Part, v98.Name, true);
                    end;
                end;

                if v98 then
                    v.StartPosition = v98.Part.CFrame.Position;
                    u1.CreateTracer(v);
                end;
            end;
        end;
    end);
    local Component = u9.GetComponent("Settings");
    Component:AddConnection("Game", "Graphics & Visuals", "Remove Tracers", function(p101) -- Line: 686
        -- upvalues: u15 (ref)
        u15.Tracers = p101;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Remove Muzzle Flash", function(p102) -- Line: 689
        -- upvalues: u15 (ref)
        u15.MuzzleFlashes = p102;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Limit Bullet Holes", function(p103) -- Line: 692
        -- upvalues: u16 (ref), u28 (ref), RemoveBulletHole (ref)
        u16.BulletHoles = p103;

        if not u16.BulletHoles then
            return;
        end;

        while #u28 > u16.MaximumBulletHoles do
            RemoveBulletHole(u28[1], 1);
        end;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Maximum Bullet Holes", function(p104) -- Line: 696
        -- upvalues: u16 (ref), u28 (ref), RemoveBulletHole (ref)
        u16.MaximumBulletHoles = math.floor(p104);

        if not u16.BulletHoles then
            return;
        end;

        while #u28 > u16.MaximumBulletHoles do
            RemoveBulletHole(u28[1], 1);
        end;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Limit Bullet Hole Lifetime", function(p105) -- Line: 700
        -- upvalues: u16 (ref)
        u16.BulletHoleLifetime = p105;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Maximum Bullet Hole Lifetime", function(p106) -- Line: 703
        -- upvalues: u16 (ref)
        u16.MaximumBulletHoleLifetime = p106;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Surface Marks", function(p107) -- Line: 706
        -- upvalues: u17 (ref)
        u17.SurfaceMarks = p107;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Impact Smoke & Sparks", function(p108) -- Line: 709
        -- upvalues: u17 (ref)
        u17.Impacts = p108;
    end);
    Component:AddConnection("Game", "Graphics & Visuals", "Blood", function(p109) -- Line: 712
        -- upvalues: u17 (ref)
        u17.Blood = p109;
    end);
    local PlayerSettings = Component:GetPlayerSettings();
    local v110 = PlayerSettings.Game and PlayerSettings.Game["Graphics & Visuals"];

    if v110 then
        u16.BulletHoles = v110["Limit Bullet Holes"];
        u16.MaximumBulletHoles = math.floor(v110["Maximum Bullet Holes"]);
        u16.BulletHoleLifetime = v110["Limit Bullet Hole Lifetime"];
        u16.MaximumBulletHoleLifetime = v110["Maximum Bullet Hole Lifetime"];
        u17.SurfaceMarks = v110["Surface Marks"];
        u17.Impacts = v110["Impact Smoke & Sparks"];
        u17.Blood = v110.Blood;
    end;
end;

return u1;