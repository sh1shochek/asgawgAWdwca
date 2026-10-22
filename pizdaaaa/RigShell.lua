-- ReplicatedStorage.Controllers.HordeController.RigShell
-- Script path: ReplicatedStorage.Controllers.HordeController.RigShell
-- Decompile time: 26.14 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local CharacterAnimator = require(ReplicatedStorage.Classes.Character.Classes.CharacterAnimator);
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local HitFlinch = require(ReplicatedStorage.Controllers.CharacterController.HitFlinch);
local HordeProtocol = require(ReplicatedStorage.Components.Common.HordeProtocol);
local Rig = require(ReplicatedStorage.Classes.Ragdoll.Rig);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Materials = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact.Components.Materials);
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore);
local CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter);
local CreateGrenadeBurst = require(ReplicatedStorage.Components.Common.VFXLibary.CreateGrenadeBurst);
local u1 = {};
local ZOMBIE_CHARACTER_FOLDER = HordeProtocol.ZOMBIE_CHARACTER_FOLDER;
local ARCHETYPE_FOLDERS = HordeProtocol.ARCHETYPE_FOLDERS;
local u2 = ARCHETYPE_FOLDERS[HordeProtocol.ARCHETYPE_NORMAL];
local STATE_ATTACK = HordeProtocol.STATE_ATTACK;
local STATE_STUNNED = HordeProtocol.STATE_STUNNED;
local CFrame_new_ret = CFrame.new(0, 3, 0);
local table_freeze_ret = table.freeze({
    LeftWrist = true,
    RightWrist = true,
    LeftAnkle = true,
    RightAnkle = true
});
local u3 = { HordeProtocol.SHELL_FOLDER, HordeProtocol.HITBOX_FOLDER };
local u4 = {
    Idle = {
        Sound = "Zombie Idle",
        Priority = 1,
        PitchVariation = 0.08
    },
    Pain = {
        Sound = "Zombie Pain",
        Priority = 3,
        PitchVariation = 0.06
    },
    Attack = {
        Sound = "Zombie Attack",
        Priority = 2,
        PitchVariation = 0.03
    }
};
local u5 = {
    [HordeProtocol.ARCHETYPE_NORMAL] = NumberRange.new(0.88, 1.14),
    [HordeProtocol.ARCHETYPE_HEAVY] = NumberRange.new(0.7, 0.86),
    [HordeProtocol.ARCHETYPE_FLAMING] = NumberRange.new(1, 1.22),
    [HordeProtocol.ARCHETYPE_FLAMING_HEAVY] = NumberRange.new(0.7, 0.86)
};
local NumberRange_new_ret = NumberRange.new(5, 12);
local NumberRange_new_ret2 = NumberRange.new(1, 6);
local NumberRange_new_ret3 = NumberRange.new(0.3, 1.2);
local NumberRange_new_ret4 = NumberRange.new(0.85, 1.2);
local u6 = { "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot" };
local u7 = { "T Glove", "CT Glove" };
local u8 = { "Driver Gloves", "Operator Gloves", "Sports Gloves" };
local Color3_fromRGB_ret = Color3.fromRGB(255, 140, 60);
local Random_new_ret = Random.new();
local Random_new_ret2 = Random.new();
local u9 = {};
local Random_new_ret3 = Random.new();
local u10 = 0;
local u11 = 2;
local u12 = {};
local u13 = {};
local u14 = nil;
local u15 = nil;
local u16 = nil;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u17 = {};
local u18 = false;
local u19 = false;
local u20 = {};
local u21 = false;
Skins.ObserveItemStockSchemas(function(p22) -- Line: 331
    -- upvalues: u21 (ref)
    if next(p22) ~= nil then
        u21 = true;
    end;
end);
local u23 = {};

local function getVariants(p24: userdata, p25: string) -- Line: 345
    -- upvalues: u12 (copy), ZOMBIE_CHARACTER_FOLDER (copy)
    local v26 = u12[p25];

    if v26 then
        return v26;
    end;

    local v27 = {};
    local v28 = p24:FindFirstChild(ZOMBIE_CHARACTER_FOLDER);

    if v28 then
        v28 = v28:FindFirstChild(p25);
    end;

    if v28 then
        for _, child in v28:GetChildren() do
            if child:IsA("Model") then
                v27[#v27 + 1] = child;
            end;
        end;
    end;

    u12[p25] = v27;

    return v27;
end;

local function isR6Style() -- Line: 364
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute("HordeRigStyle") ~= "R15";
end;

local function getArchetypeVariants(p29: number) -- Line: 370
    -- upvalues: ReplicatedStorage (copy), ARCHETYPE_FOLDERS (copy), u2 (copy), Workspace (copy), getVariants (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Characters");
    end;

    if not Assets then
        return {};
    end;

    local v30 = ARCHETYPE_FOLDERS[p29] or u2;

    for _, v in Workspace:GetAttribute("HordeRigStyle") ~= "R15" and { "R6", "" } or { "" } do
        local v31 = getVariants(Assets, v30 .. v);

        if #v31 == 0 and v30 ~= u2 then
            v31 = getVariants(Assets, u2 .. v);
        end;

        if #v31 > 0 then
            return v31;
        end;
    end;

    return {};
end;

local function findCharacterTemplate(p32: number, p33: number) -- Line: 392
    -- upvalues: getArchetypeVariants (copy)
    local v34 = getArchetypeVariants(p32);

    if #v34 > 0 then
        return v34[p33 % #v34 + 1];
    end;

    return nil;
end;

local function byName(p35: userdata, p36: userdata) -- Line: 400
    return p35.Name < p36.Name;
end;

local function getZombieAnimations(p37: boolean) -- Line: 405
    -- upvalues: u13 (copy), ReplicatedStorage (copy), byName (copy)
    local v38 = u13[p37];

    if v38 then
        return v38;
    end;

    local v39 = {
        Idle = nil,
        Jump = nil,
        Trip = nil,
        Walks = {},
        Attacks = {}
    };
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("CharacterAnimations");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("Zombie");
    end;

    if Assets and p37 then
        Assets = Assets:FindFirstChild("R6");
    end;

    if Assets then
        for _, child in Assets:GetChildren() do
            if child:IsA("Animation") then
                local Name = child.Name;

                if Name == "Idle" then
                    v39.Idle = child;
                elseif Name == "Jump" then
                    v39.Jump = child;
                elseif Name == "Trip" then
                    v39.Trip = child;
                elseif Name == "ZombieWalk" or string.sub(Name, 1, 5) == "Chase" then
                    v39.Walks[#v39.Walks + 1] = child;
                elseif string.sub(Name, 1, 6) == "Attack" then
                    v39.Attacks[#v39.Attacks + 1] = child;
                end;
            end;
        end;

        table.sort(v39.Walks, byName);
        table.sort(v39.Attacks, byName);
    end;

    local v40 = "ReplicatedStorage.Assets.CharacterAnimations.Zombie";

    if p37 then
        v40 = v40 .. ".R6";
    end;

    if #v39.Walks == 0 then
        warn((`[Horde] {v40} has no ZombieWalk or Chase* clip; zombies walk like humans`));
    end;

    if #v39.Attacks == 0 then
        warn((`[Horde] {v40} has no Attack* clips; zombies bite without an animation`));
    end;

    u13[p37] = v39;

    return v39;
end;

local function configureParts(p41: userdata) -- Line: 453
    for _, descendant in p41:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = descendant.Name ~= "CameraPart";
        end;
    end;
end;

local function recordParts(p42: userdata, p43: userdata) -- Line: 464
    local CFrame2 = p43.CFrame;
    local v44 = {};
    local v45 = {};

    for _, descendant in p42:GetDescendants() do
        if descendant:IsA("BasePart") then
            v44[#v44 + 1] = descendant;
            v45[#v45 + 1] = {
                Anchored = descendant.Anchored,
                CanCollide = descendant.CanCollide,
                CanQuery = descendant.CanQuery,
                CanTouch = descendant.CanTouch,
                Massless = descendant.Massless,
                CollisionGroup = descendant.CollisionGroup,
                Pose = CFrame2:ToObjectSpace(descendant.CFrame)
            };
        end;
    end;

    return v44, v45;
end;

local function registerAnimations(p46: any, p47: table) -- Line: 488
    -- upvalues: ReplicatedStorage (copy), Random_new_ret3 (copy)
    local v48 = {};
    local CharacterAnimations = ReplicatedStorage.Assets:FindFirstChild("CharacterAnimations");
    local Idle = p47.Idle;

    if not Idle then
        if CharacterAnimations then
            Idle = CharacterAnimations:FindFirstChild("CharacterIdle");
        else
            Idle = CharacterAnimations;
        end;
    end;

    if Idle and Idle:IsA("Animation") then
        p46:register("CharacterIdle", Idle);
    end;

    if CharacterAnimations then
        CharacterAnimations = CharacterAnimations:FindFirstChild("Movement");
    end;

    local Jump = p47.Jump;

    if not Jump then
        if CharacterAnimations then
            Jump = CharacterAnimations:FindFirstChild("Jump");
        else
            Jump = CharacterAnimations;
        end;
    end;

    if Jump and Jump:IsA("Animation") then
        p46:register("Jump", Jump);
    end;

    local Walks = p47.Walks;
    local v49;

    if #Walks > 0 then
        v49 = Walks[Random_new_ret3:NextInteger(1, #Walks)];
    else
        v49 = nil;
    end;

    if CharacterAnimations then
        CharacterAnimations = CharacterAnimations:FindFirstChild("Walking");
    end;

    if CharacterAnimations then
        for _, child in CharacterAnimations:GetChildren() do
            if child:IsA("Animation") then
                p46:register(child.Name, v49 or child);
            end;
        end;
    end;

    for _, v in p47.Attacks do
        p46:register(v.Name, v);
        v48[#v48 + 1] = v.Name;
    end;

    if p47.Trip then
        p46:register("Trip", p47.Trip);
    end;

    return v48;
end;

local function castFloor(p50: vector, p51: number) -- Line: 524
    -- upvalues: GetRayIgnore (copy), u3 (copy), Workspace (copy), RaycastParams_new_ret (copy)
    local v52 = GetRayIgnore();

    for _, v in u3 do
        local v53 = Workspace:FindFirstChild(v);

        if v53 then
            v52[#v52 + 1] = v53;
        end;
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v52;
    local v54 = Workspace:Raycast(p50 + Vector3.new(0, 1, 0), Vector3.new(0, -(p51 + 1), 0), RaycastParams_new_ret);

    if v54 and v54.Normal.Y > 0.7 then
        return v54;
    end;

    return nil;
end;

local function probeFloorMaterial(p55: table, p56: vector, p57: number) -- Line: 544
    -- upvalues: castFloor (copy)
    if p57 - p55.FloorProbedAt < 0.5 then
        return p55.FloorMaterial;
    end;

    p55.FloorProbedAt = p57;
    local v58 = castFloor(p56, 3.5);

    if v58 then
        p55.FloorMaterial = v58.Material.Name;
    end;

    return p55.FloorMaterial;
end;

local function pickFinish(p59: string) -- Line: 557
    -- upvalues: Skins (copy), Random_new_ret3 (copy)
    local v60 = {};
    local AllSkinsForWeapon = Skins.GetAllSkinsForWeapon(p59);

    if AllSkinsForWeapon then
        for _, v in AllSkinsForWeapon do
            if v.isEnabled ~= false and v.skin ~= "Stock" then
                v60[#v60 + 1] = v;
            end;
        end;
    end;

    if #v60 == 0 then
        return "Stock", 0;
    end;

    local v61 = v60[Random_new_ret3:NextInteger(1, #v60)];
    local floatRange = v61.floatRange;
    local math_max_ret = math.max(floatRange.min, 0.45);
    local math_min_ret = math.min(math_max_ret, floatRange.max);

    return v61.skin, Random_new_ret3:NextNumber(math_min_ret, floatRange.max);
end;

local function dress(u62: userdata) -- Line: 578
    -- upvalues: u7 (copy), Random_new_ret3 (copy), u8 (copy), pickFinish (copy), Skins (copy), AttachGlovesToCharacter (copy)
    local v63 = u7[Random_new_ret3:NextInteger(1, #u7)];
    local v64 = "Stock";
    local v65 = 0;
    local v66, v67, v68;

    if Random_new_ret3:NextNumber() < 0.45 then
        v66 = u8[Random_new_ret3:NextInteger(1, #u8)];
        v67, v68 = pickFinish(v66);

        if v67 == "Stock" then
            v68 = v65;
            v67 = v64;
            v66 = v63;
        end;
    else
        v68 = v65;
        v67 = v64;
        v66 = v63;
    end;

    local success, result = pcall(Skins.GetCharacterGloves, v66, v67, v68);

    if not (success and result) then
        return;
    end;

    local success2, result2 = pcall(function() -- Line: 592
        -- upvalues: AttachGlovesToCharacter (ref), result (copy), u62 (copy)
        AttachGlovesToCharacter(result:GetChildren(), u62, u62, {
            collisionGroup = "Debris"
        });
    end);

    if not success2 then
        warn((`[Horde] gloves failed on {u62.Name}: {result2}`));
    end;

    result:Destroy();
end;

local function findHitPart(p69: userdata, p70: vector?, p71: string?, p72: boolean) -- Line: 603
    -- upvalues: u6 (copy)
    local v73 = p69:FindFirstChild((p72 or p71 == "Head") and "Head" or "UpperTorso");

    if not (v73 and v73:IsA("BasePart")) then
        v73 = nil;
    end;

    if not p70 then
        return v73;
    end;

    local v74 = (1 / 0);
    local v75 = nil;

    for _, v in u6 do
        local v76 = p69:FindFirstChild(v);

        if v76 and (v76:IsA("BasePart") and not v76.Anchored) then
            local v77 = v76.CFrame:PointToObjectSpace(p70);
            local v78 = v76.Size / 2;
            local v79 = math.abs(v77.X) - v78.X;
            local math_max_ret = math.max(v79, 0);
            local v80 = math.abs(v77.Y) - v78.Y;
            local math_max_ret2 = math.max(v80, 0);
            local v81 = math.abs(v77.Z) - v78.Z;
            local math_max_ret3 = math.max(v81, 0);
            local Magnitude = Vector3.new(math_max_ret, math_max_ret2, math_max_ret3).Magnitude;

            if Magnitude < v74 then
                v75 = v76;
                v74 = Magnitude;
            end;
        end;
    end;

    return v75 or v73;
end;

local function clampOnto(p82: userdata, p83: vector) -- Line: 633
    local v84 = p82.CFrame:PointToObjectSpace(p83);
    local v85 = p82.Size / 2;
    local CFrame2 = p82.CFrame;
    local math_clamp_ret = math.clamp(v84.X, -v85.X, v85.X);
    local math_clamp_ret2 = math.clamp(v84.Y, -v85.Y, v85.Y);
    local math_clamp_ret3 = math.clamp(v84.Z, -v85.Z, v85.Z);

    return CFrame2:PointToWorldSpace((Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3)));
end;

local function throwBody(p86: userdata, p87: vector, p88: boolean, p89: vector?, p90: string?) -- Line: 645
    -- upvalues: Random_new_ret2 (copy), NumberRange_new_ret4 (copy), findHitPart (copy), clampOnto (copy)
    local v91 = Random_new_ret2:NextNumber(NumberRange_new_ret4.Min, NumberRange_new_ret4.Max);
    local UpperTorso = p86:FindFirstChild("UpperTorso");

    if not (UpperTorso and UpperTorso:IsA("BasePart")) then
        UpperTorso = nil;
    end;

    local v92 = findHitPart(p86, p89, p90, p88);
    local v93;

    if p88 and (v92 and v92.Name == "Head") then
        v93 = true;
        v92 = UpperTorso or v92;
    else
        v93 = false;
    end;

    local v94 = p87 * (v93 and 8 or 7) * v91 + Vector3.new(0, 5, 0);

    for _, child in p86:GetChildren() do
        if child:IsA("BasePart") and (not child.Anchored and child ~= v92) then
            child:ApplyImpulse(v94 * child.Mass);
        end;
    end;

    local v95 = (p88 and 26 or 24) * v91;

    if v92 then
        local v96 = clampOnto(v92, p89 or v92.Position);
        local v97 = p87 * v95 * v92.Mass;

        if v93 then
            v92:ApplyImpulse(v97 * 0.6);
            v92:ApplyImpulseAtPosition(v97 * 0.4, v96);
        else
            v92:ApplyImpulseAtPosition(v97, v96);
        end;
    end;

    if UpperTorso and (not UpperTorso.Anchored and UpperTorso ~= v92) then
        local v98 = clampOnto(UpperTorso, p89 or UpperTorso.Position);
        UpperTorso:ApplyImpulseAtPosition(p87 * v95 * 0.9 * UpperTorso.Mass, v98);
    end;
end;

local function popHead(p99: table) -- Line: 687
    -- upvalues: u9 (copy)
    local v100 = p99.HeadParts[1];

    if not v100 or p99.HeadHidden then
        return;
    end;

    u9[#u9 + 1] = v100;

    for _, v in p99.HeadLooks do
        v.Instance.Transparency = 1;
    end;

    for _, v in p99.HeadParts do
        if v.CanCollide then
            v.CanCollide = false;
        end;
    end;

    p99.HeadHidden = true;
end;

local function findHeadParts(p101: userdata) -- Line: 706
    local Head = p101:FindFirstChild("Head");

    if not (Head and Head:IsA("BasePart")) then
        return {};
    end;

    local v102 = { Head };

    for _, descendant in p101:GetDescendants() do
        if descendant:IsA("WeldConstraint") or (descendant:IsA("Weld") or descendant:IsA("Motor6D")) then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;

            if Part0 == Head then
                Part0 = Part1;
            elseif Part1 ~= Head then
                Part0 = nil;
            end;

            if Part0 and (Part0:IsA("BasePart") and (Part0.Parent ~= Head and Part0.Name ~= "UpperTorso")) then
                v102[#v102 + 1] = Part0;
            end;
        end;
    end;

    return v102;
end;

local function findHeadLooks(p103: table) -- Line: 725
    local u104 = {};

    local function add(p105: userdata) -- Line: 727
        -- upvalues: u104 (copy)
        if (p105:IsA("BasePart") or p105:IsA("Decal")) and p105.Transparency < 1 then
            u104[#u104 + 1] = {
                Instance = p105,
                Transparency = p105.Transparency
            };
        end;
    end;

    for _, v in p103 do
        add(v);

        for _, descendant in v:GetDescendants() do
            add(descendant);
        end;
    end;

    return u104;
end;

local function build(p106: userdata) -- Line: 743
    -- upvalues: ClientCharacterPresentation (copy), CharacterResolver (copy), configureParts (copy), Rig (copy), u21 (ref), dress (copy), u20 (copy), table_freeze_ret (copy), recordParts (copy), findHeadParts (copy), findHeadLooks (copy), HordeProtocol (copy)
    local v107 = p106:Clone();
    ClientCharacterPresentation.PrepareRuntimeRig(v107);
    local RootPart = CharacterResolver.getRootPart(v107);
    local v108 = assert(RootPart, "character rig has no HumanoidRootPart");
    configureParts(v107);
    pcall(Rig.Prepare, v107);

    if u21 then
        dress(v107);
    end;

    local v109 = Rig.IsR6(v107);

    for _, descendant in v107:GetDescendants() do
        if descendant:IsA("Vector3Value") or (descendant:IsA("Sound") or descendant:IsA("NoCollisionConstraint")) then
            descendant:Destroy();
        elseif v109 and (descendant:IsA("MeshPart") and (descendant.HasSkinnedMesh and not u20[p106])) then
            u20[p106] = true;
            warn((`[Horde] {p106.Name} has a skinned mesh ({descendant.Name}): its zombies render through FastCluster`));
        end;
    end;

    Rig.MatchPreparedMass(v107);
    Rig.StagePooled(v107, table_freeze_ret);
    local v110, v111 = recordParts(v107, v108);
    local CFrame2 = v108.CFrame;
    local v112 = {};
    local v113 = {};

    for _, child in v107:GetChildren() do
        if child:IsA("BasePart") and not child:HasTag("CharacterAccessory") then
            v112[#v112 + 1] = child;
            v113[#v113 + 1] = CFrame2:ToObjectSpace(child.CFrame);
        end;
    end;

    local v114 = findHeadParts(v107);

    return {
        Id = 0,
        Template = p106,
        Model = v107,
        Root = v108,
        Parts = v110,
        PartStates = v111,
        BodyParts = v112,
        BodyPoses = v113,
        HeadParts = v114,
        HeadLooks = findHeadLooks(v114),
        HeadHidden = false,
        Broken = false,
        SinkParts = {},
        SinkFrames = {},
        Animator = nil,
        AttackNames = {},
        LastAnimationAt = (-1 / 0),
        NextSwingAt = 0,
        SwingIndex = 0,
        FloorMaterial = "Concrete",
        FloorProbedAt = (-1 / 0),
        State = HordeProtocol.STATE_IDLE,
        Dead = false,
        Frozen = false,
        StunHeld = false,
        Ragdolled = false,
        LastVelocity = Vector3.new(0, 0, 0),
        Voice = nil,
        VoicePriority = 0,
        VoiceStartedAt = (-1 / 0),
        VoiceSound = nil,
        StepSound = nil,
        NextGrowlAt = 0,
        VoicePitch = 1,
        Flaming = false,
        Flames = {},
        Crackle = nil
    };
end;

local function getGrenadeParticles(p115: string) -- Line: 822
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("GrenadeParticles");
    end;

    if Assets then
        Assets = Assets:FindFirstChild(p115);
    end;

    return Assets;
end;

local function scaleSequence(p116: userdata, p117: number) -- Line: 828
    local v118 = {};

    for i, v in p116.Keypoints do
        v118[i] = NumberSequenceKeypoint.new(v.Time, v.Value * p117, v.Envelope * p117);
    end;

    return NumberSequence.new(v118);
end;

local function ignite(p119: table) -- Line: 838
    -- upvalues: ReplicatedStorage (copy), scaleSequence (copy), Color3_fromRGB_ret (copy), u16 (ref), Sound (copy)
    local Flames = p119.Flames;

    if #Flames == 0 then
        local v120 = p119.Model:FindFirstChild("UpperTorso", true) or p119.Root;
        local Assets = ReplicatedStorage:FindFirstChild("Assets");

        if Assets then
            Assets = Assets:FindFirstChild("GrenadeParticles");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("InnerFire");
        end;

        if Assets then
            Assets = Assets:FindFirstChild("Fire 3");
        end;

        if Assets and Assets:IsA("ParticleEmitter") then
            local v121 = Assets:Clone();
            v121.Size = scaleSequence(v121.Size, 0.5);
            v121.Shape = Enum.ParticleEmitterShape.Box;
            v121.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume;
            v121.LockedToPart = false;
            v121.Enabled = false;
            v121.Parent = v120;
            Flames[#Flames + 1] = v121;
        end;

        local PointLight = Instance.new("PointLight");
        PointLight.Color = Color3_fromRGB_ret;
        PointLight.Brightness = 2;
        PointLight.Range = 12;
        PointLight.Shadows = false;
        PointLight.Enabled = false;
        PointLight.Parent = v120;
        Flames[#Flames + 1] = PointLight;
    end;

    for _, v in Flames do
        v.Enabled = true;
    end;

    local v122 = u16;

    if not v122 then
        v122 = Sound.new("Grenade");
        u16 = v122;
    end;

    local Crackle = p119.Crackle;

    if not Crackle or Crackle.Parent ~= p119.Root then
        Crackle = Instance.new("Sound");
        Crackle.Name = "Flames";
        Crackle.Parent = p119.Root;
        p119.Crackle = Crackle;
    end;

    if v122:playOn(Crackle, "Flames", 0.4) then
        Crackle.Looped = true;
    end;
end;

local function extinguish(p123: table) -- Line: 887
    for _, v in p123.Flames do
        if v.Enabled then
            v.Enabled = false;
        end;
    end;

    local Crackle = p123.Crackle;

    if Crackle then
        Crackle:Stop();
    end;
end;

local function getAllTemplates() -- Line: 900
    -- upvalues: ARCHETYPE_FOLDERS (copy), getArchetypeVariants (copy)
    local v124 = {};

    for i in ARCHETYPE_FOLDERS do
        for _, v in getArchetypeVariants(i) do
            if not table.find(v124, v) then
                v124[#v124 + 1] = v;
            end;
        end;
    end;

    return v124;
end;

function u1.Refill() -- Line: 917
    -- upvalues: u18 (ref), u19 (ref), u21 (ref), getAllTemplates (copy), u17 (copy), build (copy)
    u18 = true;

    if u19 then
        return;
    end;

    u19 = true;
    task.spawn(function() -- Line: 923
        -- upvalues: u18 (ref), u21 (ref), getAllTemplates (ref), u17 (ref), build (ref), u19 (ref)
        while u18 and not u21 do
            task.wait(0.5);
        end;

        for _, v in getAllTemplates() do
            local v125 = u17[v];
            local v126;

            if v125 then
                v126 = v;
            else
                v125 = {};
                u17[v] = v125;
                v126 = v;
            end;

            while u18 and #v125 < 8 do
                local v127 = build(v126);

                if not u18 then
                    v127.Model:Destroy();
                    break;
                end;

                v125[#v125 + 1] = v127;
                task.wait();
            end;
        end;

        u19 = false;
    end);
end;

function u1.ClearPool() -- Line: 948
    -- upvalues: u18 (ref), u17 (copy), u23 (copy)
    u18 = false;

    for _, v in u17 do
        for _, v2 in v do
            v2.Model:Destroy();
        end;
    end;

    table.clear(u17);

    for _, v in u23 do
        v.Shell.Model:Destroy();
    end;

    table.clear(u23);
end;

local function restore(p128: table, p129, p130: boolean) -- Line: 965
    -- upvalues: Rig (copy), Workspace (copy)
    local Model = p128.Model;

    if p128.Ragdolled then
        Rig.Deactivate(Model);
    end;

    if p128.HeadHidden then
        for _, v in p128.HeadLooks do
            v.Instance.Transparency = v.Transparency;
        end;

        p128.HeadHidden = false;
    end;

    for _, v in p128.Flames do
        if v.Enabled then
            v.Enabled = false;
        end;
    end;

    local Crackle = p128.Crackle;

    if Crackle then
        Crackle:Stop();
    end;

    p128.Flaming = false;

    if p128.VoiceSound then
        p128.VoiceSound:Stop();
    end;

    if p128.StepSound then
        p128.StepSound:Stop();
    end;

    if p130 then
        local BodyParts = p128.BodyParts;
        local table_create_ret = table.create(#BodyParts);

        for i, v in BodyParts do
            if not v.Anchored then
                v.Anchored = true;
            end;

            table_create_ret[i] = p129 * p128.BodyPoses[i];
        end;

        Workspace:BulkMoveTo(BodyParts, table_create_ret, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    for i, v in p128.Parts do
        local v131 = p128.PartStates[i];

        if v.Anchored ~= v131.Anchored then
            v.Anchored = v131.Anchored;
        end;

        if v.CanCollide ~= v131.CanCollide then
            v.CanCollide = v131.CanCollide;
        end;

        if v.CanQuery ~= v131.CanQuery then
            v.CanQuery = v131.CanQuery;
        end;

        if v.CanTouch ~= v131.CanTouch then
            v.CanTouch = v131.CanTouch;
        end;

        if v.Massless ~= v131.Massless then
            v.Massless = v131.Massless;
        end;

        if v.CollisionGroup ~= v131.CollisionGroup then
            v.CollisionGroup = v131.CollisionGroup;
        end;

        if not p130 then
            v.CFrame = p129 * v131.Pose;
            v.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            v.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;

    p128.Ragdolled = false;
    p128.Voice = nil;
    table.clear(p128.SinkParts);
    table.clear(p128.SinkFrames);
end;

local function takeBuried(p132: userdata, p133: number) -- Line: 1031
    -- upvalues: u23 (copy), getArchetypeVariants (copy)
    if #u23 == 0 then
        return nil;
    end;

    local v134 = getArchetypeVariants(p133);
    local v135 = nil;

    for i, v in u23 do
        local Template = v.Shell.Template;

        if Template == p132 then
            table.remove(u23, i);

            return v.Shell;
        end;

        if not v135 and table.find(v134, Template) then
            v135 = i;
        end;
    end;

    if v135 then
        return table.remove(u23, v135).Shell;
    end;

    return nil;
end;

local function rise(p136: table, p137) -- Line: 1054
    -- upvalues: restore (copy)
    restore(p136, p137, true);
end;

function u1.Acquire(p138: number, p139: number, p140: vector, p141: userdata) -- Line: 1060
    -- upvalues: getArchetypeVariants (copy), ZOMBIE_CHARACTER_FOLDER (copy), takeBuried (copy), CFrame_new_ret (copy), restore (copy), u17 (copy), build (copy), HordeProtocol (copy), CharacterAnimator (copy), registerAnimations (copy), getZombieAnimations (copy), Rig (copy), u5 (copy), Random_new_ret (copy), NumberRange_new_ret2 (copy), ignite (copy), u1 (copy)
    local v142 = getArchetypeVariants(p139);
    local v143;

    if #v142 > 0 then
        v143 = v142[p138 % #v142 + 1];
    else
        v143 = nil;
    end;

    local v144 = `no zombie rig under ReplicatedStorage.Assets.Characters.{ZOMBIE_CHARACTER_FOLDER} to build a zombie from`;
    local v145 = assert(v143, v144);
    local v146 = takeBuried(v145, p139);

    if v146 then
        restore(v146, CFrame.new(p140) * CFrame_new_ret, true);
    else
        local v147 = u17[v145];

        if v147 and #v147 > 0 then
            v146 = table.remove(v147);
        else
            v146 = build(v145);
        end;
    end;

    local Model = v146.Model;
    Model.Name = HordeProtocol.modelName(p138);
    Model:SetAttribute(HordeProtocol.ID_ATTRIBUTE, p138);

    if Model.Parent ~= p141 then
        Model:PivotTo(CFrame.new(p140) * CFrame_new_ret * v146.Root.CFrame:ToObjectSpace(Model:GetPivot()));
        Model.Parent = p141;
    end;

    if not v146.Animator then
        local v148 = CharacterAnimator.new(Model, {
            SkipBaseAnimations = true
        });
        v146.Animator = v148;
        v146.AttackNames = registerAnimations(v148, (getZombieAnimations(Rig.IsR6(Model))));
    end;

    local v149 = u5[p139] or u5[HordeProtocol.ARCHETYPE_NORMAL];
    v146.Id = p138;
    v146.LastAnimationAt = (-1 / 0);
    v146.NextSwingAt = 0;
    v146.SwingIndex = 0;
    v146.FloorProbedAt = (-1 / 0);
    v146.State = HordeProtocol.STATE_IDLE;
    v146.Dead = false;
    v146.Frozen = false;
    v146.StunHeld = false;
    v146.Ragdolled = false;
    v146.LastVelocity = Vector3.new(0, 0, 0);
    v146.Voice = nil;
    v146.VoicePriority = 0;
    v146.VoiceStartedAt = (-1 / 0);
    v146.NextGrowlAt = os.clock() + Random_new_ret:NextNumber(NumberRange_new_ret2.Min, NumberRange_new_ret2.Max);
    v146.VoicePitch = Random_new_ret:NextNumber(v149.Min, v149.Max);
    v146.Flaming = HordeProtocol.ARCHETYPE_BURSTS[p139] == true;

    if v146.Flaming then
        ignite(v146);
    end;

    u1.Refill();

    return v146;
end;

function u1.RootFrame(p150: vector, p151: number, p152: number, p153: number) -- Line: 1115
    -- upvalues: CFrame_new_ret (copy)
    return CFrame.new(p150.X, p150.Y - p153, p150.Z) * CFrame.Angles(0, p151, p152 * 1.3962634015954636) * CFrame_new_ret;
end;

function u1.Vocalize(p154: table, p155: string, p156: boolean?, p157: number?, p158: boolean?) -- Line: 1122
    -- upvalues: u11 (ref), u4 (copy), u15 (ref), Sound (copy), Random_new_ret (copy)
    local Root = p154.Root;

    if not Root.Parent then
        return false;
    end;

    if u11 <= 0 and not p158 then
        return false;
    end;

    local v159 = u4[p155];
    local Voice = p154.Voice;

    if Voice and (Voice.Parent and (Voice.IsPlaying or not Voice.IsLoaded)) then
        if not p156 and v159.Priority <= p154.VoicePriority then
            return false;
        end;

        if p155 == "Pain" and (p157 == nil and os.clock() - p154.VoiceStartedAt < 0.3) then
            return false;
        end;

        Voice:Stop();
    end;

    local v160 = u15;

    if not v160 then
        v160 = Sound.new("Survival");
        u15 = v160;
    end;

    local VoiceSound = p154.VoiceSound;

    if not VoiceSound or VoiceSound.Parent ~= Root then
        VoiceSound = Instance.new("Sound");
        VoiceSound.Name = "Voice";
        VoiceSound.Parent = Root;
        p154.VoiceSound = VoiceSound;
    end;

    local PitchVariation = v159.PitchVariation;
    VoiceSound.PlaybackSpeed = (p157 or 1) * p154.VoicePitch * (1 + Random_new_ret:NextNumber(-PitchVariation, PitchVariation));

    if not v160:playOn(VoiceSound, v159.Sound) then
        return false;
    end;

    u11 = u11 - 1;
    p154.Voice = VoiceSound;
    p154.VoicePriority = v159.Priority;
    p154.VoiceStartedAt = os.clock();

    return true;
end;

function u1.Pain(p161: table) -- Line: 1172
    -- upvalues: u1 (copy)
    u1.Vocalize(p161, "Pain", true);
end;

function u1.DeathCry(p162: table) -- Line: 1178
    -- upvalues: u1 (copy)
    u1.Vocalize(p162, "Pain", true, 0.8, true);
end;

local function stepLocomotion(p163: table, p164: any, p165: number, p166: vector, p167: boolean) -- Line: 1183
    if p165 - p163.LastAnimationAt < 0.06666666666666667 then
        return;
    end;

    local v168 = p166 * Vector3.new(1, 0, 1);
    local Magnitude = v168.Magnitude;
    p164:updateLocomotion(Magnitude < 0.6 and Vector3.new(0, 0, 0) or v168 * (math.max(Magnitude / 9, 1) * 16 / Magnitude), not p167, false, false);
    p163.LastAnimationAt = p165;
end;

function u1.Animate(p169: table, p170: number, p171: vector, p172: boolean) -- Line: 1206
    -- upvalues: STATE_STUNNED (copy), u10 (ref), STATE_ATTACK (copy), u1 (copy), Random_new_ret (copy), NumberRange_new_ret (copy), NumberRange_new_ret3 (copy)
    local Animator = p169.Animator;

    if not Animator or (p169.Dead or p169.Frozen) then
        return;
    end;

    local v173 = Animator.Animations.Trip and true or false;

    if p169.State == STATE_STUNNED then
        if not p169.StunHeld then
            p169.StunHeld = true;

            if v173 then
                Animator:play("Trip", 0.1);
            else
                Animator:freezeAnimations();
            end;
        end;

        if v173 then
            if p170 - p169.LastAnimationAt < 0.06666666666666667 then
                return;
            end;

            local v174 = Vector3.new(0, 0, 0) * Vector3.new(1, 0, 1);
            local Magnitude = v174.Magnitude;
            Animator:updateLocomotion(Magnitude < 0.6 and Vector3.new(0, 0, 0) or v174 * (math.max(Magnitude / 9, 1) * 16 / Magnitude), true, false, false);
            p169.LastAnimationAt = p170;
        end;

        return;
    end;

    if p169.StunHeld then
        p169.StunHeld = false;

        if not v173 then
            Animator:stopAnimations(0);
            p169.LastAnimationAt = (-1 / 0);
        end;
    end;

    if p169.NextGrowlAt <= p170 then
        if u10 <= p170 and p169.State ~= STATE_ATTACK then
            if u1.Vocalize(p169, "Idle") then
                u10 = p170 + 0.4;
            end;

            p169.NextGrowlAt = p170 + Random_new_ret:NextNumber(NumberRange_new_ret.Min, NumberRange_new_ret.Max);
        else
            p169.NextGrowlAt = p170 + Random_new_ret:NextNumber(NumberRange_new_ret3.Min, NumberRange_new_ret3.Max);
        end;
    end;

    if p170 - p169.LastAnimationAt >= 0.06666666666666667 then
        local v175 = p171 * Vector3.new(1, 0, 1);
        local Magnitude = v175.Magnitude;
        Animator:updateLocomotion(Magnitude < 0.6 and Vector3.new(0, 0, 0) or v175 * (math.max(Magnitude / 9, 1) * 16 / Magnitude), not p172, false, false);
        p169.LastAnimationAt = p170;
    end;

    if p169.State == STATE_ATTACK and p169.NextSwingAt <= p170 then
        local AttackNames = p169.AttackNames;

        if #AttackNames > 0 then
            p169.SwingIndex = p169.SwingIndex % #AttackNames + 1;
            Animator:playAction(AttackNames[p169.SwingIndex]);
        end;

        u1.Vocalize(p169, "Attack");
        p169.NextSwingAt = p170 + 1.1;
    end;
end;

function u1.SetFrozen(p176: table, p177: boolean) -- Line: 1259
    p176.Frozen = p177;
    local Animator = p176.Animator;

    if not Animator then
        return;
    end;

    if p177 then
        Animator:freezeAnimations();

        return;
    end;

    Animator:stopAnimations(0);
    p176.LastAnimationAt = (-1 / 0);
    p176.StunHeld = false;
end;

function u1.Flinch(p178: table, p179: boolean?, p180: vector?) -- Line: 1278
    -- upvalues: HitFlinch (copy)
    if p179 then
        HitFlinch.flickHead(p178.Model, p180);

        return;
    end;

    HitFlinch.flinchBody(p178.Model, p180);
end;

function u1.FloorHeight(p181: vector, p182: number) -- Line: 1287
    -- upvalues: castFloor (copy)
    local v183 = castFloor(p181, p182);

    if v183 then
        return v183.Position.Y;
    end;

    return nil;
end;

function u1.Footstep(p184: table, p185: vector, p186: number) -- Line: 1292
    -- upvalues: u14 (ref), Sound (copy), castFloor (copy), Materials (copy)
    local v187 = u14;

    if not v187 then
        v187 = Sound.new("FloorSounds");
        u14 = v187;
    end;

    local Sounds = v187.Sounds;

    if not Sounds then
        return;
    end;

    local v188;

    if p186 - p184.FloorProbedAt < 0.5 then
        v188 = p184.FloorMaterial;
    else
        p184.FloorProbedAt = p186;
        local v189 = castFloor(p185, 3.5);

        if v189 then
            p184.FloorMaterial = v189.Material.Name;
        end;

        v188 = p184.FloorMaterial;
    end;

    if not Sounds:FindFirstChild(v188) then
        v188 = Materials[v188] or "Ground";

        if not Sounds:FindFirstChild(v188) then
            return;
        end;
    end;

    local StepSound = p184.StepSound;

    if not StepSound or StepSound.Parent ~= p184.Root then
        StepSound = Instance.new("Sound");
        StepSound.Name = "Step";
        StepSound.Parent = p184.Root;
        p184.StepSound = StepSound;
    end;

    v187:playOn(StepSound, v188, 0.8);
end;

function u1.Ragdoll(p190: table, p191: boolean?, p192: vector?, p193: vector?, p194: string?) -- Line: 1326
    -- upvalues: Rig (copy), throwBody (copy), popHead (copy)
    local Model = p190.Model;

    if not Model.Parent then
        return false;
    end;

    if p190.Animator then
        p190.Animator:stopAnimations(0);
    end;

    local success, result = pcall(Rig.Activate, Model, nil, p190.LastVelocity, 0.5, 1);

    if not (success and result) then
        warn((`[Horde] ragdoll failed for zombie {p190.Id}: {success and "activation returned false" or tostring(result)}`));
        p190.Broken = true;

        return false;
    end;

    p190.Ragdolled = true;
    local v195;

    if p192 and p192.Magnitude > 0.001 then
        v195 = p192.Unit;
    else
        v195 = nil;
    end;

    if v195 then
        local v196 = v195 * Vector3.new(1, 0, 1);

        if v196.Magnitude < 0.1 then
            v196 = -p190.Root.CFrame.LookVector * Vector3.new(1, 0, 1);
        end;

        throwBody(Model, (v196.Unit + Vector3.new(0, 0.15, 0)).Unit, p191 == true, p193, p194);
    end;

    if p191 then
        debug.profilebegin("Horde.PopHead");
        popHead(p190);
        debug.profileend();
    end;

    return true;
end;

function u1.StepEffects() -- Line: 1366
    -- upvalues: u11 (ref), u9 (copy), CreateImpact (copy)
    u11 = 2;
    local table_remove_ret = table.remove(u9, 1);

    if table_remove_ret then
        debug.profilebegin("Horde.HeadshotBlood");
        pcall(CreateImpact, table_remove_ret, "Blood Splatter", table_remove_ret.Position, Vector3.new(0, 1, 0), false, false, false, nil, false, false, false, true);
        debug.profileend();
    end;
end;

function u1.Burst(p197: table) -- Line: 1379
    -- upvalues: ReplicatedStorage (copy), CreateGrenadeBurst (copy)
    if not p197.Flaming then
        return;
    end;

    p197.Flaming = false;
    local Position = p197.Root.Position;

    for _, v in p197.Flames do
        if v.Enabled then
            v.Enabled = false;
        end;
    end;

    local Crackle = p197.Crackle;

    if Crackle then
        Crackle:Stop();
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("GrenadeParticles");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("HE Grenade");
    end;

    if not (Assets and (Assets:IsA("BasePart") and p197.Model.Parent)) then
        return;
    end;

    CreateGrenadeBurst(Assets, Position, "HE Grenade");
end;

function u1.Retire(p198: table) -- Line: 1396
    if p198.Animator then
        p198.Animator:stopAnimations(0);
    end;
end;

local function dropAnimator(p199: table) -- Line: 1403
    if p199.Animator then
        p199.Animator:destroy();
        p199.Animator = nil;
    end;
end;

function u1.Destroy(p200: table) -- Line: 1410
    if p200.Animator then
        p200.Animator:destroy();
        p200.Animator = nil;
    end;

    p200.Model:Destroy();
end;

function u1.Recycle(p201: table) -- Line: 1418
    -- upvalues: u17 (copy), u18 (ref), restore (copy)
    if p201.Animator then
        p201.Animator:destroy();
        p201.Animator = nil;
    end;

    local Model = p201.Model;
    local v202 = u17[p201.Template];

    if not v202 then
        v202 = {};
        u17[p201.Template] = v202;
    end;

    if p201.Broken or (not u18 or #v202 >= 40) then
        Model:Destroy();

        return;
    end;

    Model.Parent = nil;
    restore(p201, p201.Root.CFrame, false);
    v202[#v202 + 1] = p201;
end;

function u1.Bury(p203: table, p204: number) -- Line: 1437
    -- upvalues: u18 (ref), u23 (copy), u1 (copy), HordeProtocol (copy)
    if p203.Broken or not (u18 and (#u23 < 10 and p203.Model.Parent)) then
        return false;
    end;

    u1.Retire(p203);
    p203.Model:SetAttribute(HordeProtocol.ID_ATTRIBUTE, nil);
    p203.Model.Name = "Buried";
    u23[#u23 + 1] = {
        Shell = p203,
        At = p204
    };

    return true;
end;

function u1.EvictBuried(p205: number) -- Line: 1449
    -- upvalues: u23 (copy), u1 (copy)
    local v206 = u23[1];

    if not v206 or p205 - v206.At < 8 then
        return false;
    end;

    table.remove(u23, 1);
    u1.Recycle(v206.Shell);

    return true;
end;

function u1.HasBuried() -- Line: 1459
    -- upvalues: u23 (copy)
    return #u23 > 0;
end;

function u1.BeginSink(p207: table) -- Line: 1467
    -- upvalues: Workspace (copy)
    local SinkParts = p207.SinkParts;
    local SinkFrames = p207.SinkFrames;
    table.clear(SinkParts);
    table.clear(SinkFrames);

    for _, v in p207.BodyParts do
        if v:IsDescendantOf(Workspace) then
            if not v.Anchored then
                v.Anchored = true;
            end;

            SinkParts[#SinkParts + 1] = v;
            SinkFrames[#SinkFrames + 1] = v.CFrame;
        end;
    end;
end;

function u1.AppendSink(p208: table, p209: number, p210: table, p211: table) -- Line: 1483
    local Vector3_new_ret = Vector3.new(0, -p209, 0);
    local SinkFrames = p208.SinkFrames;

    for i, v in p208.SinkParts do
        local v212 = #p210 + 1;
        local v213 = SinkFrames[i] + Vector3_new_ret;
        p210[v212] = v;
        p211[v212] = v213;
    end;
end;

return u1;