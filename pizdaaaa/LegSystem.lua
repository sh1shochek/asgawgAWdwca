-- ReplicatedStorage.Shared.LegSystem
-- Script path: ReplicatedStorage.Shared.LegSystem
-- Decompile time: 57.94 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = {};
local u4 = nil;

local function BlendJoint(p5, p6, p7: number) -- Line: 65
    if p5 == p6 or p7 >= 1 then
        return p6;
    end;

    if p7 <= 0 then
        return p5;
    end;

    return p5:Lerp(p6, p7);
end;

local function Snap(p8: number, p9: number) -- Line: 71
    if math.abs(p8 - p9) < 0.0001 then
        p8 = p9 or p8;
    end;

    return p8;
end;

local u10 = { {
        UpperLeg = "LeftUpperLeg",
        LowerLeg = "LeftLowerLeg",
        Foot = "LeftFoot",
        HipMotor = "LeftHip",
        KneeMotor = "LeftKnee",
        AnkleMotor = "LeftAnkle"
    }, {
        UpperLeg = "RightUpperLeg",
        LowerLeg = "RightLowerLeg",
        Foot = "RightFoot",
        HipMotor = "RightHip",
        KneeMotor = "RightKnee",
        AnkleMotor = "RightAnkle"
    } };
local u11 = {
    StepDistance = 1.4,
    StepHeight = 0.4,
    StepDuration = 0.24,
    StepLead = 0.12,
    MaxPlantYaw = 0.6981317007977318,
    MaxBodyDrop = 1.25,
    BodyDropSpeed = 12,
    TeleportDistance = 8,
    MinNormalY = 0.45,
    JumpTuck = 0.7,
    JumpTuckSpeed = 14,
    LandDrop = 0.5,
    LandSpeed = 30,
    LandInTime = 0.07,
    LandOutTime = 0.22,
    DuckDrop = 1.25,
    DuckSpeed = 5.2,
    DuckStepScale = 0.6,
    LadderReach = 1,
    ClimbFootReach = 0.85,
    ClimbTuck = 0.35,
    ClimbStepOut = 0.3,
    IdleStagger = 0.4,
    IdleToeOut = 0.3490658503988659,
    Stride = 4.4,
    CrouchStride = 2.6,
    MinCadence = 1.5,
    ClimbStride = 1.32
};
local u12 = {
    StepDistance = true,
    StepDuration = true,
    MaxPlantYaw = true,
    MaxBodyDrop = true,
    BodyDropSpeed = true,
    TeleportDistance = true,
    RaycastDistance = true,
    DuckSpeed = true,
    DuckStepScale = true,
    LadderReach = true,
    ClimbFootReach = true,
    ClimbTuck = true,
    JumpTuckSpeed = true,
    LandSpeed = true,
    LandInTime = true,
    LandOutTime = true,
    Stride = true,
    CrouchStride = true,
    ClimbStride = true,
    MinCadence = true
};
local u13 = { "UpperLeg", "LowerLeg", "Foot", "HipMotor", "KneeMotor", "AnkleMotor" };

local function DeltaAngle(p14: number, p15: number) -- Line: 168
    local v16 = (p15 - p14) % 6.283185307179586;

    if v16 > 3.141592653589793 then
        v16 = v16 - 6.283185307179586;
    end;

    return v16;
end;

local function YawOf(p17) -- Line: 179
    local LookVector = p17.LookVector;

    return math.atan2(-LookVector.X, -LookVector.Z);
end;

local function SurfaceAlignedCF(p18: vector, p19: vector, p20: vector, p21: vector) -- Line: 193
    local v22 = p19 * vector.dot(p20, p19) - p20;

    if vector.magnitude(v22) < 0.001 then
        v22 = p19 * vector.dot(p21, p19) - p21;
    end;

    local vector_normalize_ret = vector.normalize(v22);

    return CFrame.fromMatrix(p18, vector.cross(p19, vector_normalize_ret), p19, vector_normalize_ret);
end;

local function SolveTwoBoneIK(p23: vector, p24: vector, p25: vector, p26: vector, p27: number, p28: number) -- Line: 233
    local v29 = p24 - p23;
    local vector_magnitude_ret = vector.magnitude(v29);

    if vector_magnitude_ret < 0.0001 then
        return nil;
    end;

    local v30 = -v29 / vector_magnitude_ret;
    local v31 = v30 * vector.dot(p25, v30) - p25;

    if vector.magnitude(v31) < 0.001 then
        v31 = v30 * vector.dot(p26, v30) - p26;

        if vector.magnitude(v31) < 0.001 then
            return nil;
        end;
    end;

    local vector_normalize_ret = vector.normalize(v31);
    local v32 = math.abs(p27 - p28) + 0.001;
    local math_clamp_ret = math.clamp(vector_magnitude_ret, v32, p27 + p28 - 0.001);
    local math_clamp_ret2 = math.clamp((p27 * p27 + math_clamp_ret * math_clamp_ret - p28 * p28) / (p27 * 2 * math_clamp_ret), -1, 1);
    local math_acos_ret = math.acos(math_clamp_ret2);
    local math_clamp_ret3 = math.clamp((p27 * p27 + p28 * p28 - math_clamp_ret * math_clamp_ret) / (p27 * 2 * p28), -1, 1);
    local v33 = 3.141592653589793 - math.acos(math_clamp_ret3);

    return CFrame.fromMatrix(p23, vector.cross(v30, vector_normalize_ret), v30, vector_normalize_ret) * CFrame.Angles(math_acos_ret, 0, 0), v33;
end;

local function PlantableHit(p34: any, p35: number, p36: number) -- Line: 276
    local v37;

    if p34 == nil or p35 > p34.Normal.Y then
        v37 = false;
    else
        v37 = p34.Position.Y <= p36 - 1;
    end;

    return v37;
end;

local function ProjectOntoPlane(p38: vector, p39: vector, p40: vector) -- Line: 294
    return vector.create(p38.X, p39.Y + ((p39.X - p38.X) * p40.X + (p39.Z - p38.Z) * p40.Z) / p40.Y, p38.Z);
end;

local function AnimPelvisInRoot(p41, p42, p43: table) -- Line: 331
    return p41 * (p43.Root or CFrame.identity) * p42;
end;

local function AnimSoleCF(p44: any, p45, p46: table) -- Line: 334
    local CFrame_identity = CFrame.identity;

    return p45 * p44.HipC0 * (p46[p44.HipName] or CFrame_identity) * p44.HipC1Inverse * p44.KneeC0 * (p46[p44.KneeName] or CFrame_identity) * p44.KneeC1Inverse * p44.AnkleC0 * (p46[p44.AnkleName] or CFrame_identity) * p44.SoleOffset;
end;

local u47 = setmetatable({}, {
    __mode = "k"
});
local u48 = { "HipC0", "HipC1Inverse", "KneeC0", "KneeC1Inverse", "AnkleC0", "SoleOffset", "HipName", "KneeName", "AnkleName" };

local function MeasurementGeometry(p49) -- Line: 352
    -- upvalues: u48 (copy)
    local v50 = { p49.RootC0, p49.RootC1Inverse };

    for _, v in p49.Legs do
        local v51 = v;

        for _, v2 in u48 do
            table.insert(v50, v51[v2]);
        end;
    end;

    return v50;
end;

local function SameGeometry(p52, p53) -- Line: 362
    if #p52 ~= #p53 then
        return false;
    end;

    for i, v in p52 do
        if v ~= p53[i] then
            return false;
        end;
    end;

    return true;
end;

local function ValidateConfig(p54) -- Line: 372
    -- upvalues: u11 (copy), u13 (copy), u12 (copy)
    if p54 ~= nil and typeof(p54) ~= "table" then
        error("LegSystem.new: \'config\' must be a table or nil, got " .. typeof(p54), 3);
    end;

    if p54 and (p54.CrouchFolder and not p54.WalkFolder) then
        error(
            "LegSystem.new: config.CrouchFolder needs config.WalkFolder — the crouch set blends over the walk set, it is not a standalone gait",
            3
        );
    end;

    local table_clone_ret = table.clone(u11);

    for i, v in p54 or {} do
        local v55, v56;

        if i == "RaycastParams" then
            if typeof(v) == "RaycastParams" then
                v55 = v;
                v56 = i;
            else
                error("LegSystem.new: config.RaycastParams must be a RaycastParams object", 3);
                v55 = v;
                v56 = i;
            end;
        elseif i == "WalkFolder" or (i == "CrouchFolder" or i == "ClimbFolder") then
            if typeof(v) == "Instance" then
                v55 = v;
                v56 = i;
            else
                error("LegSystem.new: config." .. i .. " must be an Instance (a folder of KeyframeSequences)", 3);
                v55 = v;
                v56 = i;
            end;
        elseif i == "Legs" then
            if typeof(v) ~= "table" or #v == 0 then
                error("LegSystem.new: config.Legs must be a non-empty array of leg descriptors", 3);
            end;

            v55 = v;
            v56 = i;

            for i2, v2 in v do
                local v57 = i2;
                local v58 = v2;

                for _, v3 in u13 do
                    if typeof(v58) ~= "table" or typeof(v58[v3]) ~= "string" then
                        error(string.format("LegSystem.new: config.Legs[%s] is missing string field \'%s\'", tostring(v57), v3), 3);
                    end;
                end;
            end;
        elseif u11[i] == nil and i ~= "RaycastDistance" then
            error(string.format("LegSystem.new: unknown config key \'%s\'", (tostring(i))), 3);
            v55 = v;
            v56 = i;
        else
            if typeof(v) ~= "number" then
                error(string.format("LegSystem.new: config.%s must be a number, got %s", i, (typeof(v))), 3);
            end;

            if u12[i] and v <= 0 then
                error(string.format("LegSystem.new: config.%s must be > 0 (got %s)", i, (tostring(v))), 3);
            end;

            if (i == "StepHeight" or (i == "StepLead" or (i == "MinNormalY" or (i == "DuckDrop" or (i == "JumpTuck" or (i == "LandDrop" or i == "ClimbStepOut")))))) and v < 0 then
                error(string.format("LegSystem.new: config.%s must be >= 0 (got %s)", i, (tostring(v))), 3);
                v55 = v;
                v56 = i;
            else
                v55 = v;
                v56 = i;
            end;
        end;

        table_clone_ret[v56] = v55;
    end;

    return table_clone_ret;
end;

function u1.new(u59: userdata, p60: table?) -- Line: 433
    -- upvalues: ValidateConfig (copy), u1 (copy), u10 (copy), u2 (copy), MeasurementGeometry (copy), u47 (copy)
    if typeof(u59) ~= "Instance" or not u59:IsA("Model") then
        error("LegSystem.new: \'character\' must be a Model, got " .. typeof(u59), 2);
    end;

    local v61 = ValidateConfig(p60);
    local v62 = u59:FindFirstChild("HumanoidRootPart") or u59.PrimaryPart;

    if not (v62 and v62:IsA("BasePart")) then
        warn("LegSystem: no HumanoidRootPart/PrimaryPart on \'" .. u59.Name .. "\' — leg system disabled");

        return nil;
    end;

    local LowerTorso = u59:FindFirstChild("LowerTorso");

    if LowerTorso then
        LowerTorso = LowerTorso:FindFirstChild("Root");
    end;

    if not (LowerTorso and LowerTorso:IsA("Motor6D")) then
        warn("LegSystem: no LowerTorso.Root Motor6D on \'" .. u59.Name .. "\' — leg system disabled");

        return nil;
    end;

    local u63 = setmetatable({}, u1);
    u63.Character = u59;
    u63.Root = v62;
    u63.RootMotor = LowerTorso;
    u63.RootC0 = LowerTorso.C0;
    u63.RootC0Inverse = u63.RootC0:Inverse();
    u63.RootC1Inverse = LowerTorso.C1:Inverse();
    u63.Config = v61;
    u63.Legs = {};
    u63.DuckAmount = 0;
    u63.LandTime = nil;
    u63.AirFallSpeed = 0;
    u63.WasGrounded = true;
    u63.IdleBlend = 0;
    u63.PoseWalk = {
        Pose = {},
        From = {},
        Out = {}
    };
    u63.PoseCrouch = {
        Pose = {},
        From = {},
        Out = {}
    };
    u63.PoseRest = {};
    u63.PoseClimb = {};
    u63.SoleScratch = {};
    u63.ClimbPhase = 0;
    u63.WasClimbing = false;
    u63.LastClock = os.clock();
    u63.LastRootPosition = nil;
    u63.LastSteppedIndex = 0;
    u63.Destroyed = false;
    u63.GroundCastTime = 0;
    u63.CastGroundThisFrame = true;
    local v64 = u63.RootC0 * u63.RootC1Inverse;
    local v65 = false;
    local v66 = 0;

    for _, v in v61.Legs or u10 do
        local v67 = u59:FindFirstChild(v.UpperLeg);
        local v68 = u59:FindFirstChild(v.LowerLeg);
        local v69 = u59:FindFirstChild(v.Foot);

        if not (v67 and (v68 and (v69 and v69:IsA("BasePart")))) then
            warn("LegSystem: missing leg parts (" .. v.UpperLeg .. "/" .. v.LowerLeg .. "/" .. v.Foot .. ") on \'" .. u59.Name .. "\' — leg system disabled");

            return nil;
        end;

        local v70 = v67:FindFirstChild(v.HipMotor);
        local v71 = v68:FindFirstChild(v.KneeMotor);
        local v72 = v69:FindFirstChild(v.AnkleMotor);

        if not (v70 and (v70:IsA("Motor6D") and (v71 and (v71:IsA("Motor6D") and (v72 and v72:IsA("Motor6D")))))) then
            warn("LegSystem: missing leg Motor6Ds (" .. v.HipMotor .. "/" .. v.KneeMotor .. "/" .. v.AnkleMotor .. ") on \'" .. u59.Name .. "\' — leg system disabled");

            return nil;
        end;

        local v73 = v71.C0.Position - v70.C1.Position;
        local v74 = v72.C0.Position - v71.C1.Position;
        local vector_magnitude_ret = vector.magnitude(v73);
        local vector_magnitude_ret2 = vector.magnitude(v74);

        if vector_magnitude_ret < 0.05 or vector_magnitude_ret2 < 0.05 then
            warn("LegSystem: degenerate bone lengths on \'" .. v.UpperLeg .. "\' — leg system disabled");

            return nil;
        end;

        if not v65 then
            local _, v75 = v70.C1:ToAxisAngle();
            local vector_normalize_ret = vector.normalize(v73);

            if vector.dot(vector_normalize_ret, Vector3.new(0, -1, 0)) < 0.98 then
                warn("LegSystem: \'" .. u59.Name .. "\' deviates from standard R15 leg geometry; IK may look wrong");
                v65 = true;
            else
                local vector_normalize_ret2 = vector.normalize(v74);

                if vector.dot(vector_normalize_ret2, Vector3.new(0, -1, 0)) < 0.98 or math.abs(v75) > 0.1 then
                    warn("LegSystem: \'" .. u59.Name .. "\' deviates from standard R15 leg geometry; IK may look wrong");
                    v65 = true;
                end;
            end;
        end;

        local math_max_ret = math.max(v72.C1.Position.Y + v69.Size.Y * 0.5, 0);
        local Position = (v64 * v70.C0).Position;
        local Legs = u63.Legs;
        local v76 = {
            HipMotor = v70,
            KneeMotor = v71,
            AnkleMotor = v72,
            HipC0 = v70.C0,
            KneeC0 = v71.C0,
            AnkleC0 = v72.C0,
            HipC0Inverse = v70.C0:Inverse(),
            KneeC0Inverse = v71.C0:Inverse(),
            AnkleC0Inverse = v72.C0:Inverse(),
            AnkleTranslation = CFrame.new(v72.C0.Position),
            SoleOffset = CFrame.new(0, -math_max_ret, 0),
            HipC1Inverse = v70.C1:Inverse(),
            KneeC1Inverse = v71.C1:Inverse(),
            HipName = v.HipMotor,
            KneeName = v.KneeMotor,
            AnkleName = v.AnkleMotor,
            L1 = vector_magnitude_ret,
            L2 = vector_magnitude_ret2,
            AnkleToSole = math_max_ret,
            HipInRoot = Position,
            RestSoleOffset = CFrame.new(Position.X, Position.Y - vector_magnitude_ret - vector_magnitude_ret2 - math_max_ret, Position.Z),
            State = "Dangle",
            PlantCF = nil,
            PlantYaw = 0,
            SwingStartCF = nil,
            SwingTargetCF = nil,
            SwingT = 0,
            SwingDuration = v61.StepDuration,
            CurrentCF = nil,
            IdealCF = nil,
            DangleCF = nil
        };
        table.insert(Legs, v76);
        v66 = math.max(v66, vector_magnitude_ret + vector_magnitude_ret2 + math_max_ret);
    end;

    u63.RayLength = v61.RaycastDistance or v66 + v61.MaxBodyDrop + 3;
    u63.RayDirection = Vector3.new(0, -1, 0) * u63.RayLength;
    u63.LowerTorsoInRoot = v64;
    u2[u63.RootMotor] = u63.RootC0;

    for _, v in u63.Legs do
        u2[v.HipMotor] = v.HipC0;
        u2[v.KneeMotor] = v.KneeC0;
        u2[v.AnkleMotor] = v.AnkleC0;
    end;

    if v61.WalkFolder or v61.ClimbFolder then
        local KeyframeWalk = require(script.Parent.KeyframeWalk);
        local u77 = MeasurementGeometry(u63);

        local function BakeSet(p78: userdata, p79: string) -- Line: 674
            -- upvalues: KeyframeWalk (copy), u59 (copy), u47 (ref), u77 (copy), u63 (copy)
            local v80 = KeyframeWalk.Bake(p78);

            if not v80 then
                warn("LegSystem: " .. p79 .. " anims failed to bake on \'" .. u59.Name .. "\'");

                return nil;
            end;

            local v81 = u47[v80];

            if v81 then
                local v82 = u77;
                local Geometry = v81.Geometry;
                local v83;

                if #v82 == #Geometry then
                    v83 = true;

                    for i, v in v82 do
                        if v ~= Geometry[i] then
                            v83 = false;
                            break;
                        end;
                    end;
                else
                    v83 = false;
                end;

                if v83 then
                    return v81.Set;
                end;
            end;

            local v84 = {};

            for i, v in u63.Legs do
                local v85 = v;
                local v86 = (1 / 0);

                for _, v2 in v80 do
                    for _, v3 in v2 do
                        local CFrame_identity = CFrame.identity;
                        v86 = math.min(v86, (u63.RootC0 * (v3.Root or CFrame.identity) * u63.RootC1Inverse * v85.HipC0 * (v3[v85.HipName] or CFrame_identity) * v85.HipC1Inverse * v85.KneeC0 * (v3[v85.KneeName] or CFrame_identity) * v85.KneeC1Inverse * v85.AnkleC0 * (v3[v85.AnkleName] or CFrame_identity) * v85.SoleOffset).Position.Y);
                    end;
                end;

                v84[i] = v86;
            end;

            local v87 = (1 / 0);
            local v88 = 0;
            local v89 = 0;

            for i in u63.Legs do
                v87 = math.min(v87, v84[i]);
            end;

            local v90 = {};

            for i, v in v80 do
                local v91 = 0;

                for _, v2 in v do
                    v88 = v88 + (u63.RootC0 * (v2.Root or CFrame.identity) * u63.RootC1Inverse).Position.Y;
                    v91 = v91 + (v2.Root or CFrame.identity).Position.Y;
                    v89 = v89 + 1;
                end;

                v90[i] = {
                    {
                        Root = CFrame.new(0, v91 / #v, 0)
                    }
                };
            end;

            local v92 = {
                Anims = v80,
                GroundY = v84,
                RestAnims = v90,
                StanceY = v88 / v89 - v87
            };
            u47[v80] = {
                Geometry = u77,
                Set = v92
            };

            return v92;
        end;

        u63.KeyframeWalk = KeyframeWalk;

        if v61.WalkFolder then
            u63.AnimWalk = BakeSet(v61.WalkFolder, "walk");

            if u63.AnimWalk then
                if v61.CrouchFolder then
                    u63.AnimCrouch = BakeSet(v61.CrouchFolder, "crouch");
                end;
            else
                warn("LegSystem: falling back to the procedural gait on \'" .. u59.Name .. "\'");
            end;
        end;

        if u63.AnimWalk then
            local RestAnims = u63.AnimWalk.RestAnims;
            u63.StandRoot = CFrame.new(0, (RestAnims[1][1].Root.Position.Y + RestAnims[5][1].Root.Position.Y) * 0.5, 0);
        end;

        if u63.AnimWalk and u63.AnimCrouch then
            u63.DuckDrop = u63.AnimWalk.StanceY - u63.AnimCrouch.StanceY;

            if u63.DuckDrop <= 0 then
                warn(("LegSystem: crouch set stands no lower than the walk set (%.3f studs) on \'%s\' — using Config.DuckDrop"):format(u63.DuckDrop, u59.Name));
                u63.DuckDrop = v61.DuckDrop;
            end;
        end;

        if v61.ClimbFolder then
            u63.AnimClimb = BakeSet(v61.ClimbFolder, "climb");
        end;
    end;

    u63.DuckDrop = u63.DuckDrop or v61.DuckDrop;
    u63.Phase = 0;
    u63.WalkBlend = 0;
    u63.AnimPelvis = CFrame.identity;
    u63.AnimCrouchShare = 0;

    if v61.RaycastParams then
        u63.RayParams = v61.RaycastParams;

        return u63;
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map:FindFirstChild("Geometry") };
    RaycastParams_new_ret.RespectCanCollide = false;
    u63.RayParams = RaycastParams_new_ret;

    return u63;
end;

function u1.ComputeClimbAnchor(p93: table, p94: any, p95, p96: vector) -- Line: 883
    local Config = p93.Config;
    local v97 = p95 * p94.HipInRoot;
    local v98 = p95.Position - p96 * Config.LadderReach;
    local vector_dot_ret = vector.dot(v97 - v98, p96);

    if vector_dot_ret < 0.0001 then
        return nil;
    end;

    local vector_cross_ret = vector.cross(Vector3.new(0, 1, 0), p96);
    local v99, v100;

    if vector.magnitude(vector_cross_ret) > 0.0001 then
        v99 = vector.normalize(vector_cross_ret);
        local vector_dot_ret2 = vector.dot(p95.RightVector, v99);

        if math.abs(vector_dot_ret2) < 0.0001 then
            vector_dot_ret2 = vector.dot(p95.LookVector, v99);
        end;

        local math_abs_ret = math.abs(p94.HipInRoot.X);

        if p94.HipInRoot.X * vector_dot_ret2 < 0 then
            math_abs_ret = -math_abs_ret or math_abs_ret;
        end;

        v100 = math_abs_ret - vector.dot(v97 - v98, v99);
    else
        v100 = 0;
        v99 = Vector3.new(0, 0, 0);
    end;

    local v101 = (p94.L1 + p94.L2) * Config.ClimbFootReach;
    local math_max_ret = math.max(v101 * v101 - vector_dot_ret * vector_dot_ret - v100 * v100, 0);
    local math_sqrt_ret = math.sqrt(math_max_ret);

    return v97 - p96 * vector_dot_ret + v99 * v100, math_sqrt_ret;
end;

function u1.UpdateClimbAnim(p102: table, p103: number, p104, p105: vector, p106: number) -- Line: 1009
    local Config = p102.Config;

    if not p102.WasClimbing then
        p102.ClimbPhase = 0;
    end;

    if math.abs(p106) < 0.5 then
        local v107 = math.floor(p102.ClimbPhase * 2 + 0.5) * 0.5;
        p102.ClimbPhase = p102.ClimbPhase + (v107 - p102.ClimbPhase) * math.min(p103 * 8, 1);
    else
        p102.ClimbPhase = (p102.ClimbPhase + p106 * p103 / Config.ClimbStride) % 1;
    end;

    local v108 = p102.KeyframeWalk.SampleAt(p102.AnimClimb.Anims, 1, p102.ClimbPhase, p102.PoseClimb);
    local v109 = p104.Position - p105 * Config.LadderReach;
    local LowerTorsoInRoot = p102.LowerTorsoInRoot;
    local SoleScratch = p102.SoleScratch;
    local v110 = (1 / 0);

    for i, v in p102.Legs do
        local CFrame_identity = CFrame.identity;
        local v111 = p104 * (LowerTorsoInRoot * v.HipC0 * (v108[v.HipName] or CFrame_identity) * v.HipC1Inverse * v.KneeC0 * (v108[v.KneeName] or CFrame_identity) * v.KneeC1Inverse * v.AnkleC0 * (v108[v.AnkleName] or CFrame_identity) * v.SoleOffset);
        SoleScratch[i] = v111;
        local vector_dot_ret = vector.dot(v111.Position - v109, p105);
        v110 = math.min(v110, vector_dot_ret);
    end;

    for i, v in p102.Legs do
        v.State = "Climb";
        v.PlantCF = nil;
        v.CurrentCF = SoleScratch[i] - p105 * v110;
    end;
end;

function u1.UpdateClimb(p112: table, p113: number, p114, p115: vector, p116: number) -- Line: 1068
    local Config = p112.Config;

    if p112.AnimClimb then
        return p112:UpdateClimbAnim(p113, p114, p115, p116);
    end;

    for _, v in p112.Legs do
        local v117, v118 = p112:ComputeClimbAnchor(v, p114, p115);
        v.ClimbAnchor = v117;
        v.ClimbMaxVertical = v118;
    end;

    local v119 = (p112.Legs[1].ClimbMaxVertical or 0) * (1 - Config.ClimbTuck);

    if not p112.WasClimbing then
        p112.ClimbPhase = 0;
    end;

    if math.abs(p116) < 0.5 or v119 < 0.0001 then
        local v120 = math.floor(p112.ClimbPhase * 2 + 0.5) * 0.5;
        p112.ClimbPhase = p112.ClimbPhase + (v120 - p112.ClimbPhase) * math.min(p113 * 8, 1);
    else
        p112.ClimbPhase = p112.ClimbPhase + p116 * p113 / (2 * v119);
    end;

    local v121 = #p112.Legs;

    for i, v in p112.Legs do
        v.State = "Climb";
        v.PlantCF = nil;

        if v.ClimbAnchor then
            local v122 = -v.ClimbMaxVertical;
            local v123 = v122 * Config.ClimbTuck;
            local v124 = (p112.ClimbPhase + (i - 1) / v121) % 1;
            local v125, v126;

            if v124 < 0.5 then
                v125 = v123 + (v122 - v123) * (v124 * 2);
                v126 = 0;
            else
                local v127 = (v124 - 0.5) * 2;
                v125 = v122 + (v123 - v122) * (v127 * v127 * (3 - 2 * v127));
                v126 = Config.ClimbStepOut * 4 * v127 * (1 - v127);
            end;

            local v128 = v.ClimbAnchor + Vector3.new(0, 1, 0) * v125 + p115 * v126;
            local LookVector = p114.LookVector;
            local v129 = p115 * vector.dot(Vector3.new(0, 1, 0), p115) - Vector3.new(0, 1, 0);

            if vector.magnitude(v129) < 0.001 then
                v129 = p115 * vector.dot(LookVector, p115) - LookVector;
            end;

            local vector_normalize_ret = vector.normalize(v129);
            v.CurrentCF = CFrame.fromMatrix(v128, vector.cross(p115, vector_normalize_ret), p115, vector_normalize_ret);
        end;
    end;
end;

function u1.ComputeIdealPlant(p130: table, p131: any, p132, p133: vector) -- Line: 1141
    -- upvalues: SurfaceAlignedCF (copy)
    local Config = p130.Config;
    local v134 = p131.HipInRoot.X < 0 and -1 or 1;
    local v135 = p132 * vector.create(p131.HipInRoot.X, 0, p131.HipInRoot.Z) + p132.LookVector * (-v134 * Config.IdleStagger * p130.IdleBlend);
    local v136 = (p133 - Vector3.new(0, 1, 0) * p133.Y) * Config.StepLead;
    local vector_magnitude_ret = vector.magnitude(v136);

    if p131.L1 < vector_magnitude_ret then
        v136 = v136 * (p131.L1 / vector_magnitude_ret);
    end;

    local v137 = v135 + v136 + Vector3.new(0, 1, 0);
    local v138, v139;

    if p130.CastGroundThisFrame then
        local v140 = workspace:Raycast(v137, p130.RayDirection, p130.RayParams);
        p131.PlantRayOrigin = v137;
        p131.PlantHit = v140;
        local Y = p132.Position.Y;
        local v141;

        if v140 == nil or Config.MinNormalY > v140.Normal.Y then
            v141 = false;
        else
            v141 = v140.Position.Y <= Y - 1;
        end;

        if not v141 then
            p131.PlantPlanePoint = nil;

            return nil;
        end;

        v138 = v140.Position;
        v139 = v140.Normal;
        p131.PlantPlanePoint = v138;
        p131.PlantPlaneNormal = v139;
    else
        local PlantPlanePoint = p131.PlantPlanePoint;
        v139 = p131.PlantPlaneNormal;

        if not PlantPlanePoint then
            return nil;
        end;

        v138 = vector.create(v137.X, PlantPlanePoint.Y + ((PlantPlanePoint.X - v137.X) * v139.X + (PlantPlanePoint.Z - v137.Z) * v139.Z) / v139.Y, v137.Z);
    end;

    local LookVector = p132.LookVector;

    if p130.IdleBlend ~= 0 then
        LookVector = CFrame.Angles(0, -v134 * Config.IdleToeOut * p130.IdleBlend, 0) * LookVector;
    end;

    return SurfaceAlignedCF(v138, v139, LookVector, p132.RightVector);
end;

function u1.UpdateWalk(u142: table, p143: number, p144, p145: vector, p146: number, p147: boolean) -- Line: 1224
    local Config = u142.Config;
    local v148;

    if p147 then
        v148 = p146 > 0.5;
    else
        v148 = p147;
    end;

    local v149 = u142.AnimCrouch == nil and 0 or (u142.DuckAmount or 0);

    if v148 then
        u142.Phase = (u142.Phase + math.max(p146 / (Config.Stride + (Config.CrouchStride - Config.Stride) * v149), Config.MinCadence) * p143) % 1;
    else
        u142.Phase = (u142.Phase + ((0.5 - u142.Phase) % 1 - 0.5) * (1 - math.exp(-p143 * 14))) % 1;

        if math.min(u142.Phase, 1 - u142.Phase) < 0.0001 then
            u142.Phase = 0;
        end;
    end;

    local v150 = p147 and (math.max(v148 and 1 or 0, v149) or 0) or 0;
    u142.WalkBlend = u142.WalkBlend + (v150 - u142.WalkBlend) * (1 - math.exp(-p143 * 12));
    local WalkBlend = u142.WalkBlend;

    if math.abs(WalkBlend - v150) < 0.0001 then
        WalkBlend = v150 or WalkBlend;
    end;

    u142.WalkBlend = WalkBlend;
    local v151 = p147 and u142.StandRoot or CFrame.identity;

    if u142.WalkBlend < 0.001 then
        u142.AnimPelvis = v151;
        u142.AnimCrouchShare = 0;

        return;
    end;

    local CFrame_identity = CFrame.identity;

    if p147 then
        local v152 = u142.WishX or 0;
        local v153 = u142.WishZ or -1;

        if not (u142.RestRoot and (u142.RestWishX == v152 and u142.RestWishZ == v153)) then
            u142.RestRoot = u142.KeyframeWalk.SamplePose(u142.AnimWalk.RestAnims, 0, v152, v153, u142.PoseRest).Root or CFrame.identity;
            u142.RestWishX = v152;
            u142.RestWishZ = v153;
        end;

        CFrame_identity = u142.RestRoot;
    end;

    local v154 = p146 > 0.0001 and (p144:VectorToObjectSpace((p145 - Vector3.new(0, 1, 0) * p145.Y) / p146) or Vector3.new(0, 0, -1)) or Vector3.new(0, 0, -1);
    local KeyframeWalk = u142.KeyframeWalk;

    if u142.WishX then
        local math_atan2_ret = math.atan2(u142.WishX, -u142.WishZ);
        local v155 = (math.atan2(v154.X, -v154.Z) - math_atan2_ret) % 6.283185307179586;

        if v155 > 3.141592653589793 then
            v155 = v155 - 6.283185307179586;
        end;

        if math.abs(v155) > 1.8849555921538759 then
            if u142.TurnT and u142.TurnT < 1 then
                math_atan2_ret = u142.TurnFrom or math_atan2_ret;
            end;

            u142.TurnFrom = math_atan2_ret;
            u142.TurnT = 0;
            local Z = v154.Z;
            u142.WishX = v154.X;
            u142.WishZ = Z;
        else
            local v156, v157 = KeyframeWalk.DampWish(u142.WishX, u142.WishZ, v154.X, v154.Z, p143);
            u142.WishX = v156;
            u142.WishZ = v157;
        end;
    else
        local Z = v154.Z;
        u142.WishX = v154.X;
        u142.WishZ = Z;
    end;

    local u158;

    if u142.TurnT and u142.TurnT < 1 then
        u158 = u142.TurnT or nil;
    else
        u158 = nil;
    end;

    if u158 then
        u142.TurnT = math.min(u142.TurnT + p143 * 9, 1);
        u158 = u158 * u158 * (3 - 2 * u158);
    end;

    local u159, u160;

    if u158 then
        u159 = math.sin(u142.TurnFrom);
        u160 = -math.cos(u142.TurnFrom);
    else
        u159 = nil;
        u160 = nil;
    end;

    local AnimWalk = u142.AnimWalk;
    local AnimCrouch = u142.AnimCrouch;

    local function SampleTurned(p161, p162) -- Line: 1355
        -- upvalues: KeyframeWalk (copy), u142 (copy), u158 (ref), u159 (ref), u160 (ref)
        local v163 = KeyframeWalk.SamplePose(p161, u142.Phase, u142.WishX, u142.WishZ, p162.Pose);

        if not u158 then
            return v163;
        end;

        KeyframeWalk.SamplePose(p161, u142.Phase, u159, u160, p162.From);

        return KeyframeWalk.BlendPoses(p162.From, v163, u158, p162.Out);
    end;

    local v164;

    if v149 < 1 then
        v164 = SampleTurned(AnimWalk.Anims, u142.PoseWalk) or nil;
    else
        v164 = nil;
    end;

    local v165;

    if v149 > 0 then
        v165 = SampleTurned(AnimCrouch.Anims, u142.PoseCrouch) or nil;
    else
        v165 = nil;
    end;

    local v166;

    if v164 then
        v166 = u142.RootC0 * (v164.Root or CFrame.identity) * u142.RootC1Inverse;
    else
        v166 = v164;
    end;

    local v167;

    if v165 then
        v167 = u142.RootC0 * (v165.Root or CFrame.identity) * u142.RootC1Inverse;
    else
        v167 = v165;
    end;

    local CFrame_identity2 = CFrame.identity;
    local v168 = v164 and v164.Root;

    if not v168 then
        if v165 then
            v168 = v165.Root or CFrame_identity2;
        else
            v168 = CFrame_identity2;
        end;
    end;

    if v165 and v164 then
        v168 = v168:Lerp(v165.Root or CFrame_identity2, v149);
    end;

    u142.AnimPelvis = CFrame.new(v151:Lerp(v168 + (v151.Position - CFrame_identity.Position), u142.WalkBlend).Position);
    u142.AnimCrouchShare = v165 and (u142.WalkBlend or 0) or 0;
    local Y = p144.Position.Y;

    for i, v in u142.Legs do
        local v169 = v164 or v165;
        local CFrame_identity3 = CFrame.identity;
        local v170 = (v166 or v167) * v.HipC0 * (v169[v.HipName] or CFrame_identity3) * v.HipC1Inverse * v.KneeC0 * (v169[v.KneeName] or CFrame_identity3) * v.KneeC1Inverse * v.AnkleC0 * (v169[v.AnkleName] or CFrame_identity3) * v.SoleOffset;
        local math_max_ret = math.max(v170.Position.Y - (v164 and AnimWalk and AnimWalk or AnimCrouch).GroundY[i], 0);

        if v165 and v164 then
            local CFrame_identity4 = CFrame.identity;
            local v171 = v167 * v.HipC0 * (v165[v.HipName] or CFrame_identity4) * v.HipC1Inverse * v.KneeC0 * (v165[v.KneeName] or CFrame_identity4) * v.KneeC1Inverse * v.AnkleC0 * (v165[v.AnkleName] or CFrame_identity4) * v.SoleOffset;
            v170 = v170:Lerp(v171, v149);
            math_max_ret = math_max_ret + (math.max(v171.Position.Y - AnimCrouch.GroundY[i], 0) - math_max_ret) * v149;
        end;

        local v172 = p144 * v170;
        local vector_create_ret = vector.create(v172.Position.X, Y + 1, v172.Position.Z);
        local v173 = nil;
        local v174 = nil;

        if u142.CastGroundThisFrame then
            local PlantRayOrigin = v.PlantRayOrigin;
            local v175;

            if u142.AuthoredOnly or (not PlantRayOrigin or vector_create_ret ~= PlantRayOrigin) then
                v175 = workspace:Raycast(vector_create_ret, u142.RayDirection, u142.RayParams);
            else
                v175 = v.PlantHit;
            end;

            local v176;

            if v175 == nil or Config.MinNormalY > v175.Normal.Y then
                v176 = false;
            else
                v176 = v175.Position.Y <= Y - 1;
            end;

            if v176 then
                v173 = v175.Position;
                v174 = v175.Normal;
            end;

            v.WalkHit = v175;
            v.WalkPlanePoint = v173;
            v.WalkPlaneNormal = v174;
        elseif v.WalkPlanePoint then
            v174 = v.WalkPlaneNormal;
            local WalkPlanePoint = v.WalkPlanePoint;
            v173 = vector.create(vector_create_ret.X, WalkPlanePoint.Y + ((WalkPlanePoint.X - vector_create_ret.X) * v174.X + (WalkPlanePoint.Z - vector_create_ret.Z) * v174.Z) / v174.Y, vector_create_ret.Z);
        end;

        if v173 then
            local LookVector = v172.LookVector;
            local RightVector = p144.RightVector;
            local v177 = v174 * vector.dot(LookVector, v174) - LookVector;

            if vector.magnitude(v177) < 0.001 then
                v177 = v174 * vector.dot(RightVector, v174) - RightVector;
            end;

            local vector_normalize_ret = vector.normalize(v177);
            v172 = CFrame.fromMatrix(v173 + v174 * math_max_ret, vector.cross(v174, vector_normalize_ret), v174, vector_normalize_ret);
        end;

        if u142.AuthoredOnly then
            local v178;

            if v173 then
                v178 = v172 - v174 * math_max_ret or nil;
            else
                v178 = nil;
            end;

            v.PlantCF = v178;
            v.State = v173 and "Planted" or "Dangle";
            v.DangleCF = nil;
        end;

        local CurrentCF = v.CurrentCF;
        local WalkBlend2 = u142.WalkBlend;

        if CurrentCF == v172 or WalkBlend2 >= 1 then
            CurrentCF = v172;
        elseif WalkBlend2 > 0 then
            CurrentCF = CurrentCF:Lerp(v172, WalkBlend2);
        end;

        v.CurrentCF = CurrentCF;
    end;
end;

function u1.Update(p179: table, p180: number?, p181, p182: vector?, p183: boolean?, p184: vector?, p185: number?, p186: number?) -- Line: 1504
    -- upvalues: SolveTwoBoneIK (copy)
    if p179.Destroyed or not p179.Character.Parent then
        return;
    end;

    if not p179.RootMotor.Parent then
        p179.NewRootMotorC0 = nil;

        return;
    end;

    local v187 = p179.SnapNext == true;
    p179.SnapNext = nil;
    local os_clock_ret = os.clock();
    local v188 = p180 or os_clock_ret - p179.LastClock;
    p179.LastClock = os_clock_ret;
    local math_min_ret = math.min(v188, 0.1);

    if math_min_ret <= 0 then
        return;
    end;

    local Config = p179.Config;
    local v189 = p181 or p179.Root.CFrame;
    local Position = v189.Position;
    local v190;

    if p179.LastRootPosition then
        v190 = vector.magnitude(Position - p179.LastRootPosition) > Config.TeleportDistance and true or v187;

        if not p182 then
            p182 = v190 and Vector3.new(0, 0, 0) or (Position - p179.LastRootPosition) / math_min_ret;
        end;
    else
        v190 = v187;
    end;

    local v191 = p182 or Vector3.new(0, 0, 0);
    p179.LastRootPosition = Position;
    local v192;

    if p183 == false or (p184 ~= nil or (vector.magnitude(v191) >= 0.0001 or p179.LastRootCF ~= v189)) then
        v192 = false;
    else
        v192 = p179.DuckAmount == math.clamp(p185 or 0, 0, 1);
    end;

    p179.LastRootCF = v189;

    if p179.Settled and v192 then
        local v193 = true;

        for _, v in p179.Legs do
            local Support = v.Support;

            if Support and (not Support.Parent or Support.CFrame ~= v.SupportCF) then
                v193 = false;
                break;
            end;
        end;

        p179.SleepTime = (p179.SleepTime or 0) + math_min_ret;

        if v193 and p179.SleepTime < 0.25 then
            return;
        end;
    end;

    p179.Settled = false;
    p179.SleepTime = 0;

    if v192 then
        p179.GroundCastTime = 0;
    end;

    local math_max_ret = math.max(p186 or 0, 0);

    if math_max_ret > 0 then
        p179.GroundCastTime = p179.GroundCastTime - math_min_ret;
    else
        p179.GroundCastTime = 0;
    end;

    local v194;

    if p179.GroundCastTime <= 0 then
        v194 = true;
    else
        v194 = v190 or p183 ~= false and not p179.WasGrounded or p179.WasClimbing and p184 == nil;
    end;

    if v194 then
        p179.GroundCastTime = math_max_ret;
    end;

    p179.CastGroundThisFrame = v194;
    local v195;

    if v190 then
        v195 = math.clamp(p185 or 0, 0, 1);
    else
        local DuckAmount = p179.DuckAmount;
        local v196 = math.clamp(p185 or 0, 0, 1) - p179.DuckAmount;
        v195 = DuckAmount + math.clamp(v196, -math_min_ret * Config.DuckSpeed, math_min_ret * Config.DuckSpeed);
    end;

    p179.DuckAmount = v195;
    local v197 = p183 ~= false;

    if v190 then
        p179.AirFallSpeed = 0;
        p179.LandTime = nil;
    elseif v197 then
        if not p179.WasGrounded then
            p179.LandTime = 0;
            p179.AirFallSpeed = 0;
        end;
    else
        p179.AirFallSpeed = math.max(p179.AirFallSpeed, -v191.Y);
    end;

    p179.WasGrounded = v197;

    if p179.LandTime then
        p179.LandTime = p179.LandTime + math_min_ret;

        if p179.LandTime > Config.LandInTime + Config.LandOutTime then
            p179.LandTime = nil;
        end;
    end;

    local v198;

    if p184 == nil then
        v198 = false;
    else
        v198 = vector.magnitude(p184) > 0.5;
    end;

    if v198 then
        v198 = not v197 or p179.WasClimbing and math.abs(v191.Y) > 0.5;
    end;

    if v198 then
        p184 = vector.normalize(p184);
    end;

    if p179.WasClimbing and not v198 then
        for _, v in p179.Legs do
            v.State = "Dangle";
            v.PlantCF = nil;
        end;
    end;

    local LookVector = v189.LookVector;
    local math_atan2_ret = math.atan2(-LookVector.X, -LookVector.Z);
    local v199 = vector.magnitude(v191 - Vector3.new(0, 1, 0) * v191.Y) * 0.65;
    local v200 = Config.StepDistance * (1 - p179.DuckAmount * (1 - Config.DuckStepScale));
    local v201 = math.clamp(v191.Y / Config.JumpTuckSpeed, 0, 1) * Config.JumpTuck - p179.DuckAmount * p179.DuckDrop;
    local math_max_ret2 = math.max(v201, 0);
    local v202 = v199 < 0.5 and (v197 and not v198) and 1 or 0;
    p179.IdleBlend = p179.IdleBlend + (v202 - p179.IdleBlend) * math.min(math_min_ret * 6, 1);
    local IdleBlend = p179.IdleBlend;

    if math.abs(IdleBlend - v202) < 0.0001 then
        IdleBlend = v202 or IdleBlend;
    end;

    p179.IdleBlend = IdleBlend;

    if v199 < 0.5 then
        v200 = math.min(v200, 0.15);
    end;

    local AuthoredOnly = p179.AuthoredOnly;
    local v203;

    if p179.AnimWalk == nil then
        v203 = false;
    else
        v203 = v197 and not v198;

        if v203 then
            if p179.WalkBlend == 1 then
                if v199 > 0.5 then
                    v203 = true;
                elseif p179.AnimCrouch == nil then
                    v203 = false;
                else
                    v203 = p179.DuckAmount == 1;
                end;
            else
                v203 = false;
            end;
        end;
    end;

    p179.AuthoredOnly = v203;

    for _, v in p179.Legs do
        local v204;

        if v197 and not (v198 or p179.AuthoredOnly) then
            v204 = p179:ComputeIdealPlant(v, v189, v191) or nil;
        else
            v204 = nil;
        end;

        v.IdealCF = v204;
        v.CurrentCF = v.CurrentCF or v189 * v.RestSoleOffset;

        if AuthoredOnly and not p179.AuthoredOnly then
            v.PlantCF = v.CurrentCF;
            v.PlantYaw = math_atan2_ret;
            v.State = "Planted";
        end;
    end;

    if v198 then
        p179:UpdateClimb(math_min_ret, v189, p184, v191.Y * 0.33);
    elseif not p179.AuthoredOnly then
        if v197 then
            local v205 = false;

            for _, v in p179.Legs do
                if v.IdealCF then
                    if v.State == "Dangle" or (v190 or v.State == "Planted" and vector.magnitude(v.PlantCF.Position - v.IdealCF.Position) > Config.TeleportDistance) then
                        if p179.WasClimbing and not v190 then
                            v.State = "Swinging";
                            v.SwingStartCF = v.CurrentCF;
                            v.SwingTargetCF = v.IdealCF;
                            v.SwingT = 0;
                            v.SwingDuration = Config.StepDuration;
                        else
                            v.State = "Planted";
                            v.PlantCF = v.IdealCF;
                            v.PlantYaw = math_atan2_ret;
                            v.CurrentCF = v.IdealCF;
                        end;
                    end;
                elseif v.State == "Planted" and vector.magnitude(v.PlantCF.Position - v189 * v.HipInRoot) > v.L1 + v.L2 + v.AnkleToSole then
                    v.State = "Dangle";
                    v.PlantCF = nil;
                end;

                v205 = v205 or v.State == "Swinging";
            end;

            if not v205 then
                local v206 = v200;
                local v207 = nil;

                for i, v in p179.Legs do
                    if v.State == "Planted" and v.IdealCF then
                        local vector_magnitude_ret = vector.magnitude(v.PlantCF.Position - v.IdealCF.Position);
                        local v208 = (math_atan2_ret - v.PlantYaw) % 6.283185307179586;

                        if v208 > 3.141592653589793 then
                            v208 = v208 - 6.283185307179586;
                        end;

                        local v209 = math.abs(v208) / Config.MaxPlantYaw * v200;
                        local math_max_ret3 = math.max(vector_magnitude_ret, v209);

                        if i == p179.LastSteppedIndex then
                            math_max_ret3 = math_max_ret3 * 0.85;
                        end;

                        if v206 < math_max_ret3 then
                            v207 = i;
                            v206 = math_max_ret3;
                        end;
                    end;
                end;

                if v207 then
                    local v210 = p179.Legs[v207];
                    v210.State = "Swinging";
                    v210.SwingStartCF = v210.CurrentCF;
                    v210.SwingTargetCF = v210.IdealCF;
                    v210.SwingT = 0;
                    local v211 = Config.StepDuration * (8 / math.max(v199, 8));
                    v210.SwingDuration = math.clamp(v211, 0.08, Config.StepDuration);
                    p179.LastSteppedIndex = v207;
                end;
            end;
        else
            for _, v in p179.Legs do
                v.State = "Dangle";
                v.PlantCF = nil;
            end;
        end;
    end;

    p179.WasClimbing = v198;

    if not p179.AuthoredOnly then
        for _, v in p179.Legs do
            if v.State ~= "Dangle" then
                v.DangleCF = nil;
            end;

            if v.State == "Swinging" then
                if v.IdealCF then
                    v.SwingTargetCF = v.IdealCF;
                end;

                v.SwingT = math.min(v.SwingT + math_min_ret / v.SwingDuration, 1);

                if v.SwingT >= 1 then
                    v.State = "Planted";
                    v.PlantCF = v.SwingTargetCF;
                    v.PlantYaw = math_atan2_ret;
                    v.CurrentCF = v.PlantCF;
                else
                    local SwingT = v.SwingT;
                    local v212 = SwingT * SwingT * (3 - 2 * SwingT);
                    local v213 = vector.lerp(v.SwingStartCF.Position, v.SwingTargetCF.Position, v212) + v.SwingTargetCF.UpVector * (Config.StepHeight * 4 * SwingT * (1 - SwingT));
                    v.CurrentCF = CFrame.new(v213) * v.SwingStartCF.Rotation:Lerp(v.SwingTargetCF.Rotation, v212);
                end;
            elseif v.State == "Planted" then
                v.CurrentCF = v.PlantCF;
            elseif v.State == "Dangle" then
                v.DangleCF = (v.DangleCF or v189:ToObjectSpace(v.CurrentCF)):Lerp(v.RestSoleOffset + Vector3.new(0, 1, 0) * math_max_ret2, 1 - math.exp(-math_min_ret * 10));
                v.CurrentCF = v189 * v.DangleCF;
            end;
        end;
    end;

    if p179.AnimWalk then
        if v197 then
            v197 = not v198;
        end;

        p179:UpdateWalk(math_min_ret, v189, v191, v199, v197);
    end;

    local v214 = p179.DuckAmount * p179.DuckDrop * (1 - p179.AnimCrouchShare);
    p179.OldRootMotorC0 = p179.NewRootMotorC0 or p179.RootMotor.C0;
    p179.NewRootMotorC0 = (p179.RootC0 - Vector3.new(0, 1, 0) * v214) * (p179.AnimPelvis or CFrame.identity);
    local v215 = v189 * p179.NewRootMotorC0 * p179.RootC1Inverse;
    local v216 = v198 and -p184 or v189.LookVector;
    local UpVector = v189.UpVector;

    for _, v in p179.Legs do
        if v.HipMotor.Parent and (v.KneeMotor.Parent and v.AnkleMotor.Parent) then
            local CurrentCF = v.CurrentCF;
            local v217, v218 = SolveTwoBoneIK(v215 * v.HipC0.Position, CurrentCF.Position + CurrentCF.UpVector * v.AnkleToSole, v216, UpVector, v.L1, v.L2);

            if v217 then
                v.OldHipC0 = v.NewHipC0 or v.HipMotor.C0;
                v.OldKneeC0 = v.NewKneeC0 or v.KneeMotor.C0;
                v.OldAnkleC0 = v.NewAnkleC0 or v.AnkleMotor.C0;
                v.NewHipC0 = v215:ToObjectSpace(v217);
                local CFrame_Angles_ret = CFrame.Angles(-v218, 0, 0);
                v.NewKneeC0 = v.KneeC0 * CFrame_Angles_ret;
                v.NewAnkleC0 = v.AnkleTranslation * ((v217.Rotation * CFrame_Angles_ret):Inverse() * CurrentCF.Rotation);
            end;
        else
            v.NewHipC0 = nil;
        end;
    end;

    if v187 then
        p179.OldRootMotorC0 = p179.NewRootMotorC0;

        for _, v in p179.Legs do
            local NewKneeC0 = v.NewKneeC0;
            local NewAnkleC0 = v.NewAnkleC0;
            v.OldHipC0 = v.NewHipC0;
            v.OldKneeC0 = NewKneeC0;
            v.OldAnkleC0 = NewAnkleC0;
        end;
    end;

    local v219 = v192 and not p179.LandTime;

    if v219 then
        if p179.IdleBlend == 1 and (p179.Phase == 0 and (not p179.TurnT or p179.TurnT >= 1)) then
            v219 = p179.OldRootMotorC0 == p179.NewRootMotorC0;
        else
            v219 = false;
        end;
    end;

    if v219 then
        for _, v in p179.Legs do
            local v220;

            if p179.AuthoredOnly then
                v220 = v.WalkHit;
            else
                v220 = v.PlantHit;
            end;

            local v221;

            if v220 then
                v221 = v220.Instance;
            else
                v221 = v220;
            end;

            if not (v221 and (v221:IsA("BasePart") and v221)) then
                v221 = nil;
            end;

            v.Support = v221;
            v.SupportCF = v.Support and v.Support.CFrame;

            if v219 then
                if v.State == "Planted" and v220 ~= nil then
                    v219 = not v.Support or v.Support.Anchored;

                    if v219 then
                        if v.NewHipC0 == nil or (v.OldHipC0 ~= v.NewHipC0 or v.OldKneeC0 ~= v.NewKneeC0) then
                            v219 = false;
                        else
                            v219 = v.OldAnkleC0 == v.NewAnkleC0;
                        end;
                    end;
                else
                    v219 = false;
                end;
            end;
        end;
    end;

    p179.Settled = v219;
end;

local function WriteC0(p222: userdata, p223, p224, p225: number, p226) -- Line: 2116
    -- upvalues: u2 (copy), u3 (copy)
    if p223 == p224 or p225 >= 1 then
        p223 = p224;
    elseif p225 > 0 then
        p223 = p223:Lerp(p224, p225);
    end;

    if u2[p222] ~= p223 then
        if p226 then
            u3[p222] = p226 * p223;
        else
            p222.C0 = p223;
        end;

        u2[p222] = p223;
    end;

    return p223;
end;

function u1.EnableTransforms(p227) -- Line: 2131
    -- upvalues: u4 (ref), u3 (copy)
    p227.UseTransforms = true;

    if not u4 then
        u4 = game:GetService("RunService").PreSimulation:Connect(function() -- Line: 2134
            -- upvalues: u3 (ref)
            for i, v in u3 do
                i.Transform = v;
                u3[i] = nil;
            end;
        end);
    end;
end;

function u1.Snap(p228) -- Line: 2164
    p228.SnapNext = true;
end;

function u1.Apply(p229: table, p230: number?, p231: table?) -- Line: 2168
    -- upvalues: u2 (copy), u3 (copy)
    if p229.PoseOutput ~= p231 then
        if p229.PoseOutput then
            table.clear(p229.PoseOutput);
        end;

        if p231 then
            table.clear(p231);
        end;

        p229.PoseOutput = p231;
    end;

    if p229.Destroyed or not p229.Character.Parent then
        if p231 then
            table.clear(p231);
        end;

        return;
    end;

    local NewRootMotorC0 = p229.NewRootMotorC0;

    if not NewRootMotorC0 then
        if p231 then
            table.clear(p231);
        end;

        return;
    end;

    local math_clamp_ret = math.clamp(p230 or 1, 0, 1);

    if p231 then
        local RootMotor = p229.RootMotor;
        local OldRootMotorC0 = p229.OldRootMotorC0;

        if OldRootMotorC0 == NewRootMotorC0 or math_clamp_ret >= 1 then
            OldRootMotorC0 = NewRootMotorC0;
        elseif math_clamp_ret > 0 then
            OldRootMotorC0 = OldRootMotorC0:Lerp(NewRootMotorC0, math_clamp_ret);
        end;

        p231[RootMotor] = OldRootMotorC0;
    else
        local RootMotor = p229.RootMotor;
        local OldRootMotorC0 = p229.OldRootMotorC0;
        local v232;

        if p229.UseTransforms then
            v232 = p229.RootC0Inverse or nil;
        else
            v232 = nil;
        end;

        if OldRootMotorC0 == NewRootMotorC0 or math_clamp_ret >= 1 then
            OldRootMotorC0 = NewRootMotorC0;
        elseif math_clamp_ret > 0 then
            OldRootMotorC0 = OldRootMotorC0:Lerp(NewRootMotorC0, math_clamp_ret);
        end;

        if u2[RootMotor] ~= OldRootMotorC0 then
            if v232 then
                u3[RootMotor] = v232 * OldRootMotorC0;
            else
                RootMotor.C0 = OldRootMotorC0;
            end;

            u2[RootMotor] = OldRootMotorC0;
        end;
    end;

    for _, v in p229.Legs do
        local NewHipC0 = v.NewHipC0;

        if NewHipC0 then
            if p231 then
                local HipMotor = v.HipMotor;
                local OldHipC0 = v.OldHipC0;

                if OldHipC0 == NewHipC0 or math_clamp_ret >= 1 then
                    OldHipC0 = NewHipC0;
                elseif math_clamp_ret > 0 then
                    OldHipC0 = OldHipC0:Lerp(NewHipC0, math_clamp_ret);
                end;

                p231[HipMotor] = OldHipC0;
                local KneeMotor = v.KneeMotor;
                local OldKneeC0 = v.OldKneeC0;
                local NewKneeC0 = v.NewKneeC0;

                if OldKneeC0 == NewKneeC0 or math_clamp_ret >= 1 then
                    OldKneeC0 = NewKneeC0;
                elseif math_clamp_ret > 0 then
                    OldKneeC0 = OldKneeC0:Lerp(NewKneeC0, math_clamp_ret);
                end;

                p231[KneeMotor] = OldKneeC0;
                local AnkleMotor = v.AnkleMotor;
                local OldAnkleC0 = v.OldAnkleC0;
                local NewAnkleC0 = v.NewAnkleC0;

                if OldAnkleC0 == NewAnkleC0 or math_clamp_ret >= 1 then
                    OldAnkleC0 = NewAnkleC0;
                elseif math_clamp_ret > 0 then
                    OldAnkleC0 = OldAnkleC0:Lerp(NewAnkleC0, math_clamp_ret);
                end;

                p231[AnkleMotor] = OldAnkleC0;
            else
                local HipMotor = v.HipMotor;
                local OldHipC0 = v.OldHipC0;
                local v233;

                if p229.UseTransforms then
                    v233 = v.HipC0Inverse or nil;
                else
                    v233 = nil;
                end;

                if OldHipC0 == NewHipC0 or math_clamp_ret >= 1 then
                    OldHipC0 = NewHipC0;
                elseif math_clamp_ret > 0 then
                    OldHipC0 = OldHipC0:Lerp(NewHipC0, math_clamp_ret);
                end;

                if u2[HipMotor] ~= OldHipC0 then
                    if v233 then
                        u3[HipMotor] = v233 * OldHipC0;
                    else
                        HipMotor.C0 = OldHipC0;
                    end;

                    u2[HipMotor] = OldHipC0;
                end;

                local KneeMotor = v.KneeMotor;
                local OldKneeC0 = v.OldKneeC0;
                local NewKneeC0 = v.NewKneeC0;
                local v234;

                if p229.UseTransforms then
                    v234 = v.KneeC0Inverse or nil;
                else
                    v234 = nil;
                end;

                if OldKneeC0 == NewKneeC0 or math_clamp_ret >= 1 then
                    OldKneeC0 = NewKneeC0;
                elseif math_clamp_ret > 0 then
                    OldKneeC0 = OldKneeC0:Lerp(NewKneeC0, math_clamp_ret);
                end;

                if u2[KneeMotor] ~= OldKneeC0 then
                    if v234 then
                        u3[KneeMotor] = v234 * OldKneeC0;
                    else
                        KneeMotor.C0 = OldKneeC0;
                    end;

                    u2[KneeMotor] = OldKneeC0;
                end;

                local AnkleMotor = v.AnkleMotor;
                local OldAnkleC0 = v.OldAnkleC0;
                local NewAnkleC0 = v.NewAnkleC0;
                local v235 = p229.UseTransforms and v.AnkleC0Inverse or nil;

                if OldAnkleC0 == NewAnkleC0 or math_clamp_ret >= 1 then
                    OldAnkleC0 = NewAnkleC0;
                elseif math_clamp_ret > 0 then
                    OldAnkleC0 = OldAnkleC0:Lerp(NewAnkleC0, math_clamp_ret);
                end;

                if u2[AnkleMotor] ~= OldAnkleC0 then
                    if v235 then
                        u3[AnkleMotor] = v235 * OldAnkleC0;
                    else
                        AnkleMotor.C0 = OldAnkleC0;
                    end;

                    u2[AnkleMotor] = OldAnkleC0;
                end;
            end;
        elseif p231 then
            local KneeMotor = v.KneeMotor;
            local AnkleMotor = v.AnkleMotor;
            p231[v.HipMotor] = nil;
            p231[KneeMotor] = nil;
            p231[AnkleMotor] = nil;
        end;
    end;
end;

function u1.Destroy(u236) -- Line: 2231
    -- upvalues: u2 (copy), u3 (copy)
    if u236.Destroyed then
        return;
    end;

    u236.Destroyed = true;

    if u236.PoseOutput then
        table.clear(u236.PoseOutput);
        u236.PoseOutput = nil;
    end;

    u2[u236.RootMotor] = nil;
    u3[u236.RootMotor] = nil;

    for _, v in u236.Legs do
        u2[v.HipMotor] = nil;
        u2[v.KneeMotor] = nil;
        u2[v.AnkleMotor] = nil;
        u3[v.HipMotor] = nil;
        u3[v.KneeMotor] = nil;
        u3[v.AnkleMotor] = nil;
    end;

    pcall(function() -- Line: 2260
        -- upvalues: u236 (copy)
        u236.RootMotor.C0 = u236.RootC0;

        if u236.UseTransforms then
            u236.RootMotor.Transform = CFrame.identity;
        end;

        for _, v in u236.Legs do
            v.HipMotor.C0 = v.HipC0;
            v.KneeMotor.C0 = v.KneeC0;
            v.AnkleMotor.C0 = v.AnkleC0;

            if u236.UseTransforms then
                v.HipMotor.Transform = CFrame.identity;
                v.KneeMotor.Transform = CFrame.identity;
                v.AnkleMotor.Transform = CFrame.identity;
            end;
        end;
    end);
    table.clear(u236.Legs);
end;

return u1;