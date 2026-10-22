-- ReplicatedStorage.Shared.RagdollPhysics
-- Script path: ReplicatedStorage.Shared.RagdollPhysics
-- Decompile time: 23.36 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local table_freeze_ret = table.freeze({ Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1) });
local table_freeze_ret2 = table.freeze({ Vector3.new(0, 1, 0), Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1), Vector3.new(0, -1, 0) });
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = {};
local u7 = nil;

local function RefreshConfig() -- Line: 106
    -- upvalues: u6 (copy), u2 (ref)
    u6.Gravity = u2.Get("Ragdoll", "Gravity");
    u6.MaxVelocity = u2.Get("Ragdoll", "MaxVelocity");
    u6.MaxAngularVelocity = u2.Get("Ragdoll", "MaxAngularVelocity");
    u6.SolverIterations = u2.Get("Ragdoll", "SolverIterations");
    u6.JointFriction = u2.Get("Ragdoll", "JointFriction");
    u6.Restitution = u2.Get("Ragdoll", "Restitution");
    u6.Friction = u2.Get("Ragdoll", "Friction");
    u6.AngularFriction = u2.Get("Ragdoll", "AngularFriction");
    u6.SelfCollision = u2.Get("Ragdoll", "SelfCollision");
    u6.SleepAfterTime = u2.Get("Ragdoll", "SleepAfterTime");
    u6.GroundNormal = u2.Get("Physics", "GroundNormal");
end;

local function RefreshWorldInertia(p8) -- Line: 134
    local Rotation = p8.Rotation;
    local InvInertia = p8.InvInertia;
    local InertiaX = p8.InertiaX;
    local InertiaY = p8.InertiaY;
    local InertiaZ = p8.InertiaZ;

    for i = 1, p8.Count do
        local v9 = Rotation[i];
        local XVector = v9.XVector;
        local YVector = v9.YVector;
        local ZVector = v9.ZVector;
        local v10 = InvInertia[i];
        local X = v10.X;
        local Y = v10.Y;
        local Z = v10.Z;
        InertiaX[i] = XVector * (X * XVector.X) + YVector * (Y * YVector.X) + ZVector * (Z * ZVector.X);
        InertiaY[i] = XVector * (X * XVector.Y) + YVector * (Y * YVector.Y) + ZVector * (Z * ZVector.Y);
        InertiaZ[i] = XVector * (X * XVector.Z) + YVector * (Y * YVector.Z) + ZVector * (Z * ZVector.Z);
        local _ = i;
    end;
end;

local function AngularFromTorque(p11: any, p12: number, p13: vector) -- Line: 153
    local vector_dot_ret = vector.dot(p11.InertiaX[p12], p13);
    local vector_dot_ret2 = vector.dot(p11.InertiaY[p12], p13);
    local vector_dot_ret3 = vector.dot(p11.InertiaZ[p12], p13);

    return vector.create(vector_dot_ret, vector_dot_ret2, vector_dot_ret3);
end;

local function ApplyImpulseAtPosition(p14: any, p15: number, p16: vector, p17: vector) -- Line: 166
    local Velocity = p14.Velocity;
    Velocity[p15] = Velocity[p15] + p16 * p14.InvMass[p15];
    local AngVel = p14.AngVel;
    local v18 = AngVel[p15];
    local vector_cross_ret = vector.cross(p17 - p14.Position[p15], p16);
    local vector_dot_ret = vector.dot(p14.InertiaX[p15], vector_cross_ret);
    local vector_dot_ret2 = vector.dot(p14.InertiaY[p15], vector_cross_ret);
    local vector_dot_ret3 = vector.dot(p14.InertiaZ[p15], vector_cross_ret);
    AngVel[p15] = v18 + vector.create(vector_dot_ret, vector_dot_ret2, vector_dot_ret3);
end;

local function SolveJointPoint(p19, p20) -- Line: 187
    -- upvalues: table_freeze_ret (copy)
    local Parent = p20.Parent;
    local Child = p20.Child;
    local ParentArm = p20.ParentArm;
    local ChildArm = p20.ChildArm;
    local ParentAngular = p20.ParentAngular;
    local ChildAngular = p20.ChildAngular;
    local v21 = p19.InvMass[Parent];
    local v22 = p19.InvMass[Child];
    local Velocity = p19.Velocity;
    local AngVel = p19.AngVel;

    for i, v in table_freeze_ret do
        local v23 = p20.EffectiveMass[i];

        if v23 > 1e-8 then
            local v24 = Velocity[Child] + vector.cross(AngVel[Child], ChildArm) - (Velocity[Parent] + vector.cross(AngVel[Parent], ParentArm));
            local v25 = -vector.dot(v24, v) / v23;
            Velocity[Child] = Velocity[Child] + v * (v25 * v22);
            AngVel[Child] = AngVel[Child] + ChildAngular[i] * v25;
            Velocity[Parent] = Velocity[Parent] - v * (v25 * v21);
            AngVel[Parent] = AngVel[Parent] - ParentAngular[i] * v25;
        end;
    end;
end;

local function LimitViolation(p26, p27) -- Line: 240
    local v28 = p26.Rotation[p27.Parent] * p27.RestRotation;
    local v29, v30 = v28:ToObjectSpace(p26.Rotation[p27.Child]):ToAxisAngle();
    local v31 = v29 * v30;
    local math_clamp_ret = math.clamp(v31.X, p27.MinX, p27.MaxX);
    local math_clamp_ret2 = math.clamp(v31.Y, p27.MinY, p27.MaxY);
    local math_clamp_ret3 = math.clamp(v31.Z, p27.MinZ, p27.MaxZ);
    local v32 = vector.create(math_clamp_ret, math_clamp_ret2, math_clamp_ret3) - v31;
    local vector_magnitude_ret = vector.magnitude(v32);

    if vector_magnitude_ret < 0.0001 then
        return nil, 0;
    end;

    return v28:VectorToWorldSpace(v32 / vector_magnitude_ret), vector_magnitude_ret;
end;

local function PrepareJoint(p33: any, p34: any, p35: number) -- Line: 280
    -- upvalues: table_freeze_ret (copy), LimitViolation (copy)
    local Parent = p34.Parent;
    local Child = p34.Child;
    local v36 = p33.Rotation[Parent]:VectorToWorldSpace(p34.ParentAnchor);
    local v37 = p33.Rotation[Child]:VectorToWorldSpace(p34.ChildAnchor);
    p34.ParentArm = v36;
    p34.ChildArm = v37;
    local v38 = p33.InvMass[Parent];
    local v39 = p33.InvMass[Child];
    local ParentAngular = p34.ParentAngular;
    local ChildAngular = p34.ChildAngular;

    for i, v in table_freeze_ret do
        local vector_cross_ret = vector.cross(v36, v);
        local vector_dot_ret = vector.dot(p33.InertiaX[Parent], vector_cross_ret);
        local vector_dot_ret2 = vector.dot(p33.InertiaY[Parent], vector_cross_ret);
        local vector_dot_ret3 = vector.dot(p33.InertiaZ[Parent], vector_cross_ret);
        local vector_create_ret = vector.create(vector_dot_ret, vector_dot_ret2, vector_dot_ret3);
        local vector_cross_ret2 = vector.cross(v37, v);
        local vector_dot_ret4 = vector.dot(p33.InertiaX[Child], vector_cross_ret2);
        local vector_dot_ret5 = vector.dot(p33.InertiaY[Child], vector_cross_ret2);
        local vector_dot_ret6 = vector.dot(p33.InertiaZ[Child], vector_cross_ret2);
        local vector_create_ret2 = vector.create(vector_dot_ret4, vector_dot_ret5, vector_dot_ret6);
        ParentAngular[i] = vector_create_ret;
        ChildAngular[i] = vector_create_ret2;
        local EffectiveMass = p34.EffectiveMass;
        local vector_cross_ret3 = vector.cross(vector_create_ret, v36);
        local v40 = v38 + vector.dot(v, vector_cross_ret3);
        local vector_cross_ret4 = vector.cross(vector_create_ret2, v37);
        EffectiveMass[i] = v40 + (v39 + vector.dot(v, vector_cross_ret4));
    end;

    local v41, v42 = LimitViolation(p33, p34);
    p34.LimitAxis = v41;
    p34.LimitTarget = v41 and math.min(v42 * 0.3 / p35, 30) or 0;
end;

local function SolveJointLimits(p43, p44) -- Line: 311
    local LimitAxis = p44.LimitAxis;

    if not LimitAxis then
        return;
    end;

    local Parent = p44.Parent;
    local Child = p44.Child;
    local LimitTarget = p44.LimitTarget;
    local vector_dot_ret = vector.dot(p43.AngVel[Child] - p43.AngVel[Parent], LimitAxis);

    if LimitTarget <= vector_dot_ret then
        return;
    end;

    local v45 = p43.ScalarInvInertia[Parent];
    local v46 = p43.ScalarInvInertia[Child];
    local v47 = v45 + v46;

    if v47 <= 1e-8 then
        return;
    end;

    local v48 = LimitAxis * (LimitTarget - vector_dot_ret);
    local AngVel = p43.AngVel;
    AngVel[Child] = AngVel[Child] + v48 * (v46 / v47);
    local AngVel2 = p43.AngVel;
    AngVel2[Parent] = AngVel2[Parent] - v48 * (v45 / v47);
end;

local function ProjectJointPoint(p49, p50) -- Line: 345
    local Parent = p50.Parent;
    local Child = p50.Child;
    local v51 = p49.Position[Child] + p50.ChildArm - (p49.Position[Parent] + p50.ParentArm);
    local v52 = p49.Grounded[Parent] and v51.Y < 0 and 0 or p49.InvMass[Parent];
    local v53 = p49.Grounded[Child] and v51.Y > 0 and 0 or p49.InvMass[Child];
    local v54 = v52 + v53;

    if v54 <= 1e-8 then
        return;
    end;

    local Position = p49.Position;
    Position[Parent] = Position[Parent] + v51 * (v52 / v54);
    local Position2 = p49.Position;
    Position2[Child] = Position2[Child] - v51 * (v53 / v54);
end;

local function SolveJointFriction(p55: any, p56: any, p57: number) -- Line: 396
    -- upvalues: u6 (copy)
    local v58 = p56.Friction * u6.JointFriction;

    if v58 <= 0 then
        return;
    end;

    local Parent = p56.Parent;
    local Child = p56.Child;
    local v59 = p55.ScalarInvInertia[Parent];
    local v60 = p55.ScalarInvInertia[Child];
    local v61 = v59 + v60;

    if v61 <= 1e-8 then
        return;
    end;

    local v62 = (p55.AngVel[Child] - p55.AngVel[Parent]) * (1 - math.exp(-v58 * p57));
    local AngVel = p55.AngVel;
    AngVel[Child] = AngVel[Child] - v62 * (v60 / v61);
    local AngVel2 = p55.AngVel;
    AngVel2[Parent] = AngVel2[Parent] + v62 * (v59 / v61);
end;

local function TryUnstuck(p63: any, p64: number) -- Line: 420
    -- upvalues: table_freeze_ret2 (copy), u3 (ref)
    local v65 = p63.Size[p64];
    local v66 = p63.Rotation[p64];

    for i = 0.1, 6, 0.1 do
        local v67 = i;

        for _, v in table_freeze_ret2 do
            local v68 = p63.Position[p64] + v * v67;

            if not u3.BoxSolid(v68, v65, v66) then
                p63.Position[p64] = v68;

                return true;
            end;
        end;
    end;

    return false;
end;

local function CollideWorld(p69: any, p70: number, p71: number) -- Line: 444
    -- upvalues: u3 (ref), TryUnstuck (copy), u6 (copy), u7 (ref)
    local v72 = p69.Rotation[p70];
    local v73 = p69.Size[p70];
    local v74 = p69.Half[p70];
    local v75 = false;
    local v76 = nil;
    local v77 = nil;
    local v78 = nil;

    for i = 1, 4 do
        local v79 = p69.Velocity[p70];

        if p71 <= 0 or vector.dot(v79, v79) < 0.0001 then
            break;
        end;

        local v80 = p69.Position[p70];
        local v81 = u3.SweepBox(v80, v80 + v79 * p71, v73, v72);

        if v81.AllSolid then
            if not p69.Stuck[p70] and TryUnstuck(p69, p70) then
                p69.Velocity[p70] = Vector3.new(0, 0, 0);

                return v75;
            end;

            p69.Stuck[p70] = true;
            p69.Velocity[p70] = Vector3.new(0, 0, 0);
            p69.AngVel[p70] = Vector3.new(0, 0, 0);

            return true;
        end;

        p69.Stuck[p70] = nil;
        p69.Position[p70] = v81.EndPosition;

        if v81.Fraction >= 1 then
            break;
        end;

        p71 = p71 * (1 - v81.Fraction);
        local Normal = v81.Normal;
        v75 = Normal.Y > u6.GroundNormal and true or v75;
        local v82 = -vector.dot(v79, Normal);

        if p69.ImpactSpeed < v82 then
            p69.ImpactSpeed = v82;
            p69.ImpactPosition = p69.Position[p70];
        end;

        local v83 = u7(v79, Normal, u6.Restitution);
        p69.Velocity[p70] = v83;

        if not v76 then
            v76 = v72.XVector;
            v77 = v72.YVector;
            v78 = v72.ZVector;
        end;

        local vector_dot_ret = vector.dot(Normal, v76);
        local v84 = math.abs(vector_dot_ret) * v74.X;
        local vector_dot_ret2 = vector.dot(Normal, v77);
        local v85 = v84 + math.abs(vector_dot_ret2) * v74.Y;
        local vector_dot_ret3 = vector.dot(Normal, v78);
        local v86 = v85 + math.abs(vector_dot_ret3) * v74.Z;
        local AngVel = p69.AngVel;
        local v87 = AngVel[p70];
        local vector_cross_ret = vector.cross(-Normal * v86, (v83 - v79) * p69.Mass[p70]);
        local vector_dot_ret4 = vector.dot(p69.InertiaX[p70], vector_cross_ret);
        local vector_dot_ret5 = vector.dot(p69.InertiaY[p70], vector_cross_ret);
        local vector_dot_ret6 = vector.dot(p69.InertiaZ[p70], vector_cross_ret);
        AngVel[p70] = v87 + vector.create(vector_dot_ret4, vector_dot_ret5, vector_dot_ret6);
        local _ = i;
    end;

    return v75;
end;

local function CollideSelf(p88) -- Line: 543
    local PairA = p88.PairA;
    local PairB = p88.PairB;
    local PairMinimum = p88.PairMinimum;
    local Position = p88.Position;
    local Velocity = p88.Velocity;
    local InvMass = p88.InvMass;

    for i = 1, #PairA do
        local v89 = PairA[i];
        local v90 = PairB[i];
        local v91 = Position[v90] - Position[v89];
        local vector_dot_ret = vector.dot(v91, v91);
        local v92 = PairMinimum[i];
        local v93;

        if v92 * v92 <= vector_dot_ret or vector_dot_ret < 1e-8 then
            v93 = i;
        else
            local v94 = InvMass[v89];
            local v95 = InvMass[v90];
            local v96 = v94 + v95;

            if v96 <= 1e-8 then
                v93 = i;
            else
                local math_sqrt_ret = math.sqrt(vector_dot_ret);
                local v97 = v91 / math_sqrt_ret;
                local v98 = v92 - math_sqrt_ret;
                Position[v89] = Position[v89] - v97 * (v98 * (v94 / v96));
                Position[v90] = Position[v90] + v97 * (v98 * (v95 / v96));
                local vector_dot_ret2 = vector.dot(Velocity[v90] - Velocity[v89], v97);

                if vector_dot_ret2 < 0 then
                    local v99 = -vector_dot_ret2 / v96;
                    Velocity[v89] = Velocity[v89] - v97 * (v99 * v94);
                    Velocity[v90] = Velocity[v90] + v97 * (v99 * v95);
                    v93 = i;
                else
                    v93 = i;
                end;
            end;
        end;
    end;
end;

local function CheckSettle(p100: any, p101: number) -- Line: 593
    -- upvalues: u5 (ref), u6 (copy)
    p100.SimulationTime = p100.SimulationTime + p101;
    local v102 = p100.Position[p100.Root];
    local math_clamp_ret = math.clamp(u5.SleepTolerance * (p100.SimulationTime - p100.AwakeTime), u5.SleepTolerance, u5.SleepToleranceMax);
    local v103 = v102 - p100.LastOrigin;

    if math_clamp_ret < math.abs(v103.X) or (math_clamp_ret < math.abs(v103.Y) or math_clamp_ret < math.abs(v103.Z)) then
        p100.LastOriginChangeTime = p100.SimulationTime;
        p100.LastOrigin = v102;

        return;
    end;

    if p100.SimulationTime - p100.LastOriginChangeTime < u6.SleepAfterTime then
        return;
    end;

    for i = 1, p100.Count do
        p100.Velocity[i] = Vector3.new(0, 0, 0);
        p100.AngVel[i] = Vector3.new(0, 0, 0);
        local _ = i;
    end;

    p100.Sleeping = true;
end;

local function Substep(p104: any, p105: number) -- Line: 624
    -- upvalues: u6 (copy), RefreshWorldInertia (copy), PrepareJoint (copy), SolveJointPoint (copy), SolveJointLimits (copy), SolveJointFriction (copy), CollideWorld (copy), CollideSelf (copy), ProjectJointPoint (copy), CheckSettle (copy)
    local Count = p104.Count;
    local v106 = Vector3.new(0, 1, 0) * (u6.Gravity * p105);

    for i = 1, Count do
        local Velocity = p104.Velocity;
        Velocity[i] = Velocity[i] - v106;
        local _ = i;
    end;

    local Joints = p104.Joints;
    RefreshWorldInertia(p104);

    for _, v in Joints do
        PrepareJoint(p104, v, p105);
    end;

    for i = 1, u6.SolverIterations do
        local _ = i;

        for _, v in Joints do
            SolveJointPoint(p104, v);
            SolveJointLimits(p104, v);
        end;
    end;

    for _, v in Joints do
        SolveJointFriction(p104, v, p105);
    end;

    local MaxVelocity = u6.MaxVelocity;
    local MaxAngularVelocity = u6.MaxAngularVelocity;
    local v107 = MaxVelocity * MaxVelocity;
    local v108 = MaxAngularVelocity * MaxAngularVelocity;

    for i = 1, Count do
        local v109 = p104.Velocity[i];
        local vector_dot_ret = vector.dot(v109, v109);

        if v107 < vector_dot_ret then
            p104.Velocity[i] = v109 * (MaxVelocity / math.sqrt(vector_dot_ret));
        end;

        local v110 = p104.AngVel[i];
        local vector_dot_ret2 = vector.dot(v110, v110);
        local v111;

        if v108 < vector_dot_ret2 then
            p104.AngVel[i] = v110 * (MaxAngularVelocity / math.sqrt(vector_dot_ret2));
            v111 = i;
        else
            v111 = i;
        end;
    end;

    local math_max_ret = math.max(0, 1 - u6.Friction * p105);
    local math_exp_ret = math.exp(-u6.AngularFriction * p105);
    local Grounded = p104.Grounded;

    for i = 1, Count do
        local v112 = CollideWorld(p104, i, p105);
        Grounded[i] = v112;
        local v113;

        if v112 then
            local v114 = p104.Velocity[i] * Vector3.new(1, 0, 1);

            if vector.dot(v114, v114) > 0 then
                p104.Velocity[i] = v114 * math_max_ret;
            end;

            local AngVel = p104.AngVel;
            AngVel[i] = AngVel[i] * math_exp_ret;
            v113 = i;
        else
            v113 = i;
        end;
    end;

    if u6.SelfCollision then
        CollideSelf(p104);
    end;

    for i = 1, Count do
        local v115 = p104.AngVel[i];
        local vector_dot_ret = vector.dot(v115, v115);
        local v116;

        if vector_dot_ret > 1e-8 then
            local math_sqrt_ret = math.sqrt(vector_dot_ret);
            p104.Rotation[i] = CFrame.fromAxisAngle(v115 / math_sqrt_ret, math_sqrt_ret * p105) * p104.Rotation[i];
            v116 = i;
        else
            v116 = i;
        end;
    end;

    for _, v in Joints do
        v.ParentArm = p104.Rotation[v.Parent]:VectorToWorldSpace(v.ParentAnchor);
        v.ChildArm = p104.Rotation[v.Child]:VectorToWorldSpace(v.ChildAnchor);
    end;

    for i = 1, 3 do
        local _ = i;

        for _, v in Joints do
            ProjectJointPoint(p104, v);
        end;
    end;

    CheckSettle(p104, p105);
end;

function v1.ApplyDeathForce(p117: any, p118: vector, p119: number?) -- Line: 760
    if not (p119 and p117.Position[p119]) then
        p119 = p117.Root;
    end;

    local v120 = p117.Position[p119];
    local Velocity = p117.Velocity;
    Velocity[p119] = Velocity[p119] + p118 * p117.InvMass[p119];
    local AngVel = p117.AngVel;
    local v121 = AngVel[p119];
    local vector_cross_ret = vector.cross(v120 - p117.Position[p119], p118);
    local vector_dot_ret = vector.dot(p117.InertiaX[p119], vector_cross_ret);
    local vector_dot_ret2 = vector.dot(p117.InertiaY[p119], vector_cross_ret);
    local vector_dot_ret3 = vector.dot(p117.InertiaZ[p119], vector_cross_ret);
    AngVel[p119] = v121 + vector.create(vector_dot_ret, vector_dot_ret2, vector_dot_ret3);
    local v122 = p117.Position[p119];
    local TotalMass = p117.TotalMass;

    for i = 1, p117.Count do
        local v123;

        if i == p119 then
            v123 = i;
        else
            local v124 = p118 * (p117.Mass[i] / TotalMass);
            local Velocity2 = p117.Velocity;
            Velocity2[i] = Velocity2[i] + v124 * p117.InvMass[i];
            local AngVel2 = p117.AngVel;
            local v125 = AngVel2[i];
            local vector_cross_ret2 = vector.cross(v122 - p117.Position[i], v124);
            local vector_dot_ret4 = vector.dot(p117.InertiaX[i], vector_cross_ret2);
            local vector_dot_ret5 = vector.dot(p117.InertiaY[i], vector_cross_ret2);
            local vector_dot_ret6 = vector.dot(p117.InertiaZ[i], vector_cross_ret2);
            AngVel2[i] = v125 + vector.create(vector_dot_ret4, vector_dot_ret5, vector_dot_ret6);
            v123 = i;
        end;
    end;
end;

function v1.ApplyLaunchVelocity(p126: any, p127: vector) -- Line: 785
    -- upvalues: u5 (ref)
    local vector_magnitude_ret = vector.magnitude(p127);

    if u5.LaunchVelocityClamp < vector_magnitude_ret then
        p127 = p127 * (u5.LaunchVelocityClamp / vector_magnitude_ret);
    end;

    for i = 1, p126.Count do
        local Velocity = p126.Velocity;
        Velocity[i] = Velocity[i] + p127;
        local _ = i;
    end;
end;

function v1.new(p128: table, p129: table?) -- Line: 803
    -- upvalues: u5 (ref), RefreshWorldInertia (copy)
    local v130 = {
        Count = 0,
        Root = 1,
        TotalMass = 0,
        Parts = {},
        Size = {},
        Half = {},
        Radius = {},
        Position = {},
        Rotation = {},
        PreviousPosition = {},
        PreviousRotation = {},
        Velocity = {},
        AngVel = {},
        Mass = {},
        InvMass = {},
        InvInertia = {},
        ScalarInvInertia = {},
        Grounded = {},
        Stuck = {},
        InertiaX = {},
        InertiaY = {},
        InertiaZ = {},
        PairA = {},
        PairB = {},
        PairMinimum = {},
        Joints = {},
        JointOfChild = {},
        NoCollide = {},
        Resolved = {},
        SimulationTime = 0,
        AwakeTime = 0,
        LastOriginChangeTime = 0,
        LastOrigin = Vector3.new(0, 0, 0),
        Sleeping = false,
        Interpolating = false,
        Accumulator = u5.Timestep,
        ImpactSpeed = 0,
        ImpactPosition = Vector3.new(0, 0, 0)
    };
    local v131 = {};
    local v132 = {};
    local v133 = 0;

    for _, v in u5.LimbOrder do
        local v134 = p128[v];

        if v134 then
            local v135 = v130.Count + 1;
            v130.Count = v135;
            v131[v] = v135;
            local Size = v134.Size;
            local CFrame2 = v134.CFrame;
            v130.Parts[v135] = v134;
            v130.Size[v135] = Size;
            v130.Half[v135] = Size * 0.5;
            v130.Position[v135] = CFrame2.Position;
            v130.Rotation[v135] = CFrame2.Rotation;
            v130.PreviousPosition[v135] = CFrame2.Position;
            v130.PreviousRotation[v135] = CFrame2.Rotation;
            v130.Velocity[v135] = Vector3.new(0, 0, 0);
            v130.AngVel[v135] = Vector3.new(0, 0, 0);
            v130.Radius[v135] = math.min(Size.X, Size.Y, Size.Z) * 0.5;
            local v136 = Size.X * Size.Y * Size.Z;
            v132[v135] = v136;
            v133 = v133 + v136;

            if v == u5.RootLimb then
                v130.Root = v135;
            end;
        end;
    end;

    if v130.Count == 0 then
        return nil;
    end;

    local Inertia = u5.Inertia;

    for i = 1, v130.Count do
        local math_max_ret = math.max(v132[i] / v133 * u5.TotalMass, u5.MinLimbMass);
        local v137 = v130.Size[i];
        local v138 = v137.X * v137.X;
        local v139 = v137.Y * v137.Y;
        local v140 = v137.Z * v137.Z;
        local v141 = math_max_ret * Inertia / 12;
        local v142 = v141 * (v139 + v140);
        local v143 = v141 * (v138 + v140);
        local v144 = v141 * (v138 + v139);
        v130.Mass[i] = math_max_ret;
        v130.InvMass[i] = 1 / math_max_ret;
        v130.InvInertia[i] = vector.create(1 / v142, 1 / v143, 1 / v144);
        v130.ScalarInvInertia[i] = (1 / v142 + 1 / v143 + 1 / v144) / 3;
        v130.TotalMass = v130.TotalMass + math_max_ret;
        local _ = i;
    end;

    for _, v in u5.Joints do
        local v145 = v131[v.Parent];
        local v146 = v131[v.Child];

        if v145 and v146 then
            local v147 = CFrame.new(v130.Position[v145]) * v130.Rotation[v145];
            local v148 = CFrame.new(v130.Position[v146]) * v130.Rotation[v146];
            local v149 = v148:PointToWorldSpace(p129 and p129[v.Child] or v.Pivot * v130.Size[v146]);
            local X = v.X;
            local Y = v.Y;
            local Z = v.Z;
            local v150 = (X[3] + Y[3] + Z[3]) / 3 * 0.2;
            local v151 = {
                Parent = v145,
                Child = v146,
                ParentAnchor = v147:PointToObjectSpace(v149),
                ChildAnchor = v148:PointToObjectSpace(v149),
                RestRotation = v130.Rotation[v145]:Inverse() * v130.Rotation[v146],
                MinX = math.rad(X[1]),
                MaxX = math.rad(X[2]),
                MinY = math.rad(Y[1]),
                MaxY = math.rad(Y[2]),
                MinZ = math.rad(Z[1]),
                MaxZ = math.rad(Z[2]),
                Friction = v150,
                EffectiveMass = {},
                ParentAngular = {},
                ChildAngular = {}
            };
            table.insert(v130.Joints, v151);
            v130.JointOfChild[v146] = v151;
            v130.NoCollide[math.min(v145, v146) * 32 + math.max(v145, v146)] = true;
        end;
    end;

    local PairA = v130.PairA;
    local PairB = v130.PairB;
    local PairMinimum = v130.PairMinimum;
    local NoCollide = v130.NoCollide;
    local v152 = 0;

    for i = 1, v130.Count - 1 do
        local v153 = i;

        for i2 = i + 1, v130.Count do
            local v154;

            if NoCollide[v153 * 32 + i2] then
                v154 = i2;
            else
                v152 = v152 + 1;
                PairA[v152] = v153;
                PairB[v152] = i2;
                PairMinimum[v152] = v130.Radius[v153] + v130.Radius[i2];
                v154 = i2;
            end;
        end;
    end;

    RefreshWorldInertia(v130);
    v130.LastOrigin = v130.Position[v130.Root];

    return v130;
end;

function v1.Step(p155: any, p156: number) -- Line: 996
    -- upvalues: u5 (ref), Substep (copy)
    local Timestep = u5.Timestep;

    if p155.Sleeping then
        if p155.Interpolating then
            p155.Accumulator = math.min(p155.Accumulator + p156, Timestep);
        end;

        return;
    end;

    p155.Accumulator = p155.Accumulator + p156;

    if p155.Accumulator < Timestep then
        return;
    end;

    local math_floor_ret = math.floor(p155.Accumulator / Timestep);
    local math_min_ret = math.min(math_floor_ret, 6);
    p155.Accumulator = p155.Accumulator % Timestep;

    for i = 1, math_min_ret do
        local _ = i;

        for i2 = 1, p155.Count do
            p155.PreviousPosition[i2] = p155.Position[i2];
            p155.PreviousRotation[i2] = p155.Rotation[i2];
            local _ = i2;
        end;

        Substep(p155, Timestep);

        if p155.Sleeping then
            break;
        end;
    end;

    p155.Interpolating = true;
end;

function v1.GetCFrames(p157: any, p158: table, p159: table, p160: number) -- Line: 1052
    -- upvalues: u5 (ref)
    local Resolved = p157.Resolved;
    local v161 = p157.Interpolating and (math.min(p157.Accumulator / u5.Timestep, 1) or 1) or 1;

    for i = 1, p157.Count do
        local v162 = p157.PreviousRotation[i]:Lerp(p157.Rotation[i], v161);
        local vector_lerp_ret = vector.lerp(p157.PreviousPosition[i], p157.Position[i], v161);
        local v163 = p157.JointOfChild[i];

        if v163 then
            vector_lerp_ret = Resolved[v163.Parent]:PointToWorldSpace(v163.ParentAnchor) - v162:VectorToWorldSpace(v163.ChildAnchor);
        end;

        local v164 = v162 + vector_lerp_ret;
        Resolved[i] = v164;
        p160 = p160 + 1;
        p158[p160] = p157.Parts[i];
        p159[p160] = v164;
        local _ = i;
    end;

    if p157.Sleeping and v161 >= 1 then
        p157.Interpolating = false;
    end;

    return p160;
end;

function v1.Init(p165) -- Line: 1100
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u7 (ref), RefreshConfig (copy)
    u2 = p165:GetModule("GameConfiguration");
    u3 = p165:GetModule("CollisionModule");
    u4 = p165:GetModule("DroppedPhysics");
    u5 = p165:GetModule("RagdollData");
    u7 = u4.ClipVelocity;
    RefreshConfig();
    u2.Updated:Connect(RefreshConfig);
end;

function v1.Start(p166) -- Line: 1113
end;

return v1;