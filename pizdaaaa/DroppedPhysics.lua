-- ReplicatedStorage.Shared.DroppedPhysics
-- Script path: ReplicatedStorage.Shared.DroppedPhysics
-- Decompile time: 21.88 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local SnapshotInterp = require(game:GetService("ReplicatedStorage").Shared.Utility.SnapshotInterp);
local u2 = { Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, 0, 1) };
local u3 = nil;
local u4 = {};
local u5 = { Vector3.new(0, 1, 0), Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1), Vector3.new(0, -1, 0) };
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.RespectCanCollide = false;

local function Support(p10, p11, p12) -- Line: 43
    local vector_dot_ret = vector.dot(p10.XVector, p12);
    local v13 = math.abs(vector_dot_ret) * p11.X;
    local vector_dot_ret2 = vector.dot(p10.YVector, p12);
    local v14 = v13 + math.abs(vector_dot_ret2) * p11.Y;
    local vector_dot_ret3 = vector.dot(p10.ZVector, p12);

    return v14 + math.abs(vector_dot_ret3) * p11.Z;
end;

function u1.InterpolateState(p15, p16, p17, p18) -- Line: 49
    -- upvalues: u9 (ref), SnapshotInterp (copy), u1 (copy)
    p15.Position = vector.lerp(p16.Position, p17.Position, p18);
    p15.Pitch = u9.LerpAngle(p16.Pitch, p17.Pitch, p18);
    p15.Yaw = u9.LerpAngle(p16.Yaw, p17.Yaw, p18);
    p15.Roll = u9.LerpAngle(p16.Roll, p17.Roll, p18);
    p15.Normal = vector.lerp(p16.Normal, p17.Normal, p18);
    p15.OnGround = SnapshotInterp.Snap(p18, p16.OnGround, p17.OnGround) == 1;

    if p16.OnGround == 1 and p17.OnGround == 1 then
        local vector_magnitude_ret = vector.magnitude(p15.Normal);
        local v19 = vector_magnitude_ret > 0.001 and (p15.Normal / vector_magnitude_ret or Vector3.new(0, 1, 0)) or Vector3.new(0, 1, 0);
        local v20 = p15.CollisionBox * 0.5;
        local v21 = {
            Name = p15.Name,
            Pitch = p16.Pitch,
            Yaw = p16.Yaw,
            Roll = p16.Roll,
            Normal = p16.Normal
        };
        local v22 = {
            Name = p15.Name,
            Pitch = p17.Pitch,
            Yaw = p17.Yaw,
            Roll = p17.Roll,
            Normal = p17.Normal
        };
        local Rotation = u1.GetRotation(v21);
        local vector_dot_ret = vector.dot(Rotation.XVector, v19);
        local v23 = math.abs(vector_dot_ret) * v20.X;
        local vector_dot_ret2 = vector.dot(Rotation.YVector, v19);
        local v24 = v23 + math.abs(vector_dot_ret2) * v20.Y;
        local vector_dot_ret3 = vector.dot(Rotation.ZVector, v19);
        local v25 = v24 + math.abs(vector_dot_ret3) * v20.Z;
        local Rotation2 = u1.GetRotation(v22);
        local vector_dot_ret4 = vector.dot(Rotation2.XVector, v19);
        local v26 = math.abs(vector_dot_ret4) * v20.X;
        local vector_dot_ret5 = vector.dot(Rotation2.YVector, v19);
        local v27 = v26 + math.abs(vector_dot_ret5) * v20.Y;
        local vector_dot_ret6 = vector.dot(Rotation2.ZVector, v19);
        local v28 = v25 + (v27 + math.abs(vector_dot_ret6) * v20.Z - v25) * p18;
        local Rotation3 = u1.GetRotation(p15);
        local vector_dot_ret7 = vector.dot(Rotation3.XVector, v19);
        local v29 = math.abs(vector_dot_ret7) * v20.X;
        local vector_dot_ret8 = vector.dot(Rotation3.YVector, v19);
        local v30 = v29 + math.abs(vector_dot_ret8) * v20.Y;
        local vector_dot_ret9 = vector.dot(Rotation3.ZVector, v19);
        local v31 = v30 + math.abs(vector_dot_ret9) * v20.Z - v28;
        local math_max_ret = math.max(0, v31);
        p15.Position = p15.Position + v19 * math_max_ret;
    end;
end;

function u1.SetModelBounds(p32) -- Line: 72
    local CFrame2 = p32.Model.PrimaryPart.CFrame;
    p32.Hitboxes = {};
    local v33 = nil;
    local v34 = nil;

    for _, descendant in p32.Model:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanQuery = descendant.Transparency < 1;

            if descendant.CanQuery then
                local v35 = CFrame2:ToObjectSpace(descendant.CFrame);
                local v36 = descendant.Size * 0.5;
                local Hitboxes = p32.Hitboxes;
                local v37 = {
                    CFrame = v35,
                    Half = vector.create(v36.X, v36.Y, v36.Z)
                };
                table.insert(Hitboxes, v37);
                local XVector = v35.XVector;
                local YVector = v35.YVector;
                local ZVector = v35.ZVector;
                local v38 = math.abs(XVector.X) * v36.X + math.abs(YVector.X) * v36.Y + math.abs(ZVector.X) * v36.Z;
                local v39 = math.abs(XVector.Y) * v36.X + math.abs(YVector.Y) * v36.Y + math.abs(ZVector.Y) * v36.Z;
                local v40 = math.abs(XVector.Z) * v36.X + math.abs(YVector.Z) * v36.Y + math.abs(ZVector.Z) * v36.Z;
                local vector_create_ret = vector.create(v38, v39, v40);
                local Position = v35.Position;
                local vector_create_ret2 = vector.create(Position.X, Position.Y, Position.Z);
                local v41 = vector_create_ret2 - vector_create_ret;
                local v42 = vector_create_ret2 + vector_create_ret;

                if v34 then
                    v34 = vector.min(v34, v41) or v41;
                else
                    v34 = v41;
                end;

                if v33 then
                    v33 = vector.max(v33, v42) or v42;
                else
                    v33 = v42;
                end;
            end;
        end;
    end;

    assert(v34 and v33, "Dropped weapon has no visible parts");
    local v43 = (v34 + v33) * 0.5;
    local v44 = v33 - v34;
    p32.BoxCentre = vector.create(v43.X, v43.Y, v43.Z);
    local math_max_ret = math.max(v44.X, 0.01);
    local math_max_ret2 = math.max(v44.Y, 0.01);
    local math_max_ret3 = math.max(v44.Z, 0.01);
    p32.CollisionBox = vector.create(math_max_ret, math_max_ret2, math_max_ret3);
    p32.PickupRadius = vector.magnitude(p32.CollisionBox) * 0.5;
    p32.PickupBounds = nil;
end;

local function RefreshPhysicsConfig() -- Line: 111
    -- upvalues: u4 (copy), u3 (ref)
    u4.Gravity = u3.Get("Physics", "Gravity");
    u4.MaxSpeed = u3.Get("Physics", "MaxSpeed");
    u4.Restitution = u3.Get("Physics", "Restitution");
    u4.Friction = u3.Get("Physics", "Friction");
    u4.GroundNormal = u3.Get("Physics", "GroundNormal");
    u4.SleepSpeed = u3.Get("Physics", "SleepSpeed");
    u4.AngularDamping = u3.Get("Physics", "AngularDamping");
    u4.SettleAngVel = u3.Get("Physics", "SettleAngVel");
    u4.RestRoll = u3.Get("Physics", "RestRoll");
    u4.RollSmooth = u3.Get("Physics", "RollSmooth");
    u4.RestPitch = u3.Get("Physics", "RestPitch");
    u4.BombRestPitch = u3.Get("Physics", "BombRestPitch");
    u4.PredictDistance = u3.Get("Physics", "PredictDistance");
    u4.NormalSmooth = u3.Get("Physics", "NormalSmooth");
    u4.DropBulletImpulse = u3.Get("Weapon", "DropBulletImpulse");
    u4.PushTumble = u3.Get("Weapon", "PushTumble");
end;

function u1.ClipVelocity(p45: vector, p46: vector, p47: number) -- Line: 133
    local vector_dot_ret = vector.dot(p45, p46);

    if vector_dot_ret >= 0 then
        return p45;
    end;

    local v48 = p45 - p46 * (vector_dot_ret * (p47 + 1));
    local vector_dot_ret2 = vector.dot(v48, p46);

    if vector_dot_ret2 < 0 then
        v48 = v48 - p46 * math.min(vector_dot_ret2, -0.03125);
    end;

    return v48;
end;

local function IsFree(p49: any, p50: vector, p51) -- Line: 156
    -- upvalues: u7 (ref)
    return not u7.BoxSolid(p50, p49.CollisionBox, p51);
end;

local function TryUnstuck(p52: any, p53) -- Line: 160
    -- upvalues: u5 (copy), u7 (ref)
    for i = 0.1, 2, 0.1 do
        local v54 = i;

        for _, v in u5 do
            local v55 = p52.Position + v * v54;

            if not u7.BoxSolid(v55, p52.CollisionBox, p53) then
                p52.Position = v55;

                return true;
            end;
        end;
    end;

    return false;
end;

local function ApplyFriction(p56: any, p57: number, p58: vector?) -- Line: 178
    -- upvalues: u4 (copy)
    if not p56.OnGround then
        return;
    end;

    if (p58 == nil or p58.Y > 0.999) and p56.Velocity.Y ~= 0 then
        p56.Velocity = p56.Velocity * Vector3.new(1, 0, 1);
    end;

    local vector_magnitude_ret = vector.magnitude(p56.Velocity);

    if vector_magnitude_ret > 0 then
        p56.Velocity = p56.Velocity * (math.max(0, vector_magnitude_ret - vector_magnitude_ret * u4.Friction * p57) / vector_magnitude_ret);
    end;
end;

local function ApplyGravity(p59, p60) -- Line: 207
    -- upvalues: u4 (copy)
    p59.Velocity = p59.Velocity - Vector3.new(0, 1, 0) * (u4.Gravity * p60);
end;

function u1.GetRestPitch(p61) -- Line: 212
    -- upvalues: u4 (copy)
    return p61.Name == "Bomb" and u4.BombRestPitch or u4.RestPitch;
end;

local function PredictTimeToImpact(p62) -- Line: 221
    -- upvalues: u4 (copy), u7 (ref), u1 (copy)
    local Velocity = p62.Velocity;
    local Gravity = u4.Gravity;
    local v63 = u7.SweepBox(p62.Position, p62.Position - Vector3.new(0, 1, 0) * (u4.PredictDistance or 60), p62.CollisionBox, u1.GetRotation(p62));

    if v63.Fraction >= 1 or (v63.AllSolid or v63.Normal.Y <= u4.GroundNormal) then
        return nil, nil;
    end;

    local v64 = p62.Position.Y - v63.EndPosition.Y;

    if v64 <= 0 then
        return 0, v63.Normal;
    end;

    local Y = Velocity.Y;
    local v65 = Y * Y + 2 * Gravity * v64;

    if v65 < 0 then
        return nil, nil;
    end;

    return (Y + math.sqrt(v65)) / Gravity, v63.Normal;
end;

local function UpdateRotations(p66, p67) -- Line: 253
    -- upvalues: PredictTimeToImpact (copy), u4 (copy), u9 (ref)
    local v68 = p66.AngVel or Vector3.new(0, 0, 0);
    local v69;

    if p66.OnGround or p66.Sleeping then
        local v70 = p66.Name == "Bomb" and u4.BombRestPitch or u4.RestPitch;

        if not p66.TargetRoll then
            local v71 = p66.Name == "Bomb" and 0 or u4.RestRoll;

            if p66.Name ~= "Bomb" then
                local v72 = u9.DeltaAngle(p66.Roll, u4.RestRoll);
                local math_abs_ret = math.abs(v72);
                local v73 = u9.DeltaAngle(p66.Roll, -u4.RestRoll);

                if math.abs(v73) < math_abs_ret then
                    v71 = -u4.RestRoll;
                end;
            end;

            p66.TargetRoll = v71;
        end;

        local TargetRoll = p66.TargetRoll;
        local v74 = 1 - math.exp(-u4.RollSmooth * p67);
        p66.Pitch = u9.LerpAngle(p66.Pitch, v70, v74);
        p66.Roll = u9.LerpAngle(p66.Roll, TargetRoll, v74);
        p66.Yaw = p66.Yaw + v68.Y * p67;
        local v75 = p66.Name == "Bomb" and Vector3.new(0, 1, 0) or (p66.TargetNormal or (p66.Normal or Vector3.new(0, 1, 0)));
        local v76 = 1 - math.exp(-u4.NormalSmooth * p67);
        local vector_lerp_ret = vector.lerp(p66.Normal or Vector3.new(0, 1, 0), v75, v76);
        local vector_magnitude_ret = vector.magnitude(vector_lerp_ret);
        p66.Normal = vector_magnitude_ret > 0.001 and vector_lerp_ret / vector_magnitude_ret or Vector3.new(0, 1, 0);
        v69 = v68 * math.exp(-(u4.AngularDamping * 2) * p67);
        local vector_dot_ret = vector.dot(p66.Normal, v75);

        if vector.magnitude(v69) < u4.SettleAngVel or p66.Sleeping then
            v69 = p66.Sleeping and Vector3.new(0, 0, 0) or v69;

            if p66.Sleeping then
                local v77 = u9.DeltaAngle(p66.Pitch, v70);

                if math.abs(v77) < 0.01 then
                    local v78 = u9.DeltaAngle(p66.Roll, TargetRoll);

                    if math.abs(v78) < 0.01 and vector_dot_ret > 0.99 then
                        p66.Pitch = v70;
                        p66.Roll = TargetRoll;
                        p66.Normal = v75;
                        p66.Resting = true;
                    end;
                end;
            end;
        end;
    else
        local v79, v80 = PredictTimeToImpact(p66);

        if v79 and v79 <= 0.125 then
            local v81 = p66.Name == "Bomb" and u4.BombRestPitch or u4.RestPitch;

            if not p66.TargetRoll then
                local v82 = p66.Name == "Bomb" and 0 or u4.RestRoll;

                if p66.Name ~= "Bomb" then
                    local v83 = u9.DeltaAngle(p66.Roll, u4.RestRoll);
                    local math_abs_ret = math.abs(v83);
                    local v84 = u9.DeltaAngle(p66.Roll, -u4.RestRoll);

                    if math.abs(v84) < math_abs_ret then
                        v82 = -u4.RestRoll;
                    end;
                end;

                p66.TargetRoll = v82;
            end;

            local TargetRoll = p66.TargetRoll;
            local math_max_ret = math.max(p67, v79);
            local math_clamp_ret = math.clamp(p67 / math_max_ret, 0, 1);
            p66.Pitch = u9.LerpAngle(p66.Pitch, v81, math_clamp_ret);
            p66.Roll = u9.LerpAngle(p66.Roll, TargetRoll, math_clamp_ret);
            p66.Yaw = p66.Yaw + v68.Y * p67;

            if v80 and p66.Name ~= "Bomb" then
                local vector_lerp_ret = vector.lerp(p66.Normal or Vector3.new(0, 1, 0), v80, math_clamp_ret);
                local vector_magnitude_ret = vector.magnitude(vector_lerp_ret);
                p66.Normal = vector_magnitude_ret > 0.001 and vector_lerp_ret / vector_magnitude_ret or Vector3.new(0, 1, 0);
            end;

            local math_exp_ret = math.exp(-p67 / math_max_ret * 3);
            local math_exp_ret2 = math.exp(-u4.AngularDamping * p67);
            v69 = vector.create(v68.X * math_exp_ret, v68.Y * math_exp_ret2, v68.Z * math_exp_ret);
        else
            p66.TargetRoll = nil;
            p66.TargetNormal = nil;
            p66.Pitch = p66.Pitch + v68.X * p67;
            p66.Yaw = p66.Yaw + v68.Y * p67;
            p66.Roll = p66.Roll + v68.Z * p67;

            if p66.Normal and p66.Name ~= "Bomb" then
                local v85 = 1 - math.exp(-u4.NormalSmooth * p67);
                local vector_lerp_ret = vector.lerp(p66.Normal, Vector3.new(0, 1, 0), v85);
                local vector_magnitude_ret = vector.magnitude(vector_lerp_ret);
                p66.Normal = vector_magnitude_ret > 0.001 and vector_lerp_ret / vector_magnitude_ret or Vector3.new(0, 1, 0);
            end;

            v69 = v68 * math.exp(-u4.AngularDamping * p67);
        end;
    end;

    p66.AngVel = v69;
end;

local function ProjectVelocity(p86, p87) -- Line: 368
    -- upvalues: u1 (copy), u7 (ref), TryUnstuck (copy), u4 (copy)
    local Rotation = u1.GetRotation(p86);
    p86.OnGround = false;
    local v88 = nil;

    for i = 1, 4 do
        if p87 <= 0 or vector.dot(p86.Velocity, p86.Velocity) < 0.0001 then
            break;
        end;

        local v89 = u7.SweepBox(p86.Position, p86.Position + p86.Velocity * p87, p86.CollisionBox, Rotation);

        if v89.AllSolid then
            p86.Velocity = Vector3.new(0, 0, 0);

            if p86.OnGround or p86.TargetNormal then
                p86.OnGround = true;

                return p86.TargetNormal or v88;
            end;

            if TryUnstuck(p86, Rotation) then
                p86.Velocity = Vector3.new(0, 0, 0);
                p86.Stucked = false;
            else
                p86.Velocity = Vector3.new(0, 0, 0);
                p86.Normal = p86.TargetNormal or (p86.Normal or Vector3.new(0, 1, 0));
                p86.Resting = true;
                p86.Stucked = true;
            end;

            return p86.TargetNormal or v88;
        end;

        p86.Stucked = false;

        if v89.Fraction >= 1 then
            p86.Position = v89.EndPosition;

            return v88;
        end;

        local Normal = v89.Normal;
        p86.Position = v89.EndPosition + Normal * 0.005;
        p87 = p87 * (1 - v89.Fraction);

        if Normal.Y > u4.GroundNormal then
            p86.OnGround = true;
            v88 = Normal;
        end;

        local Velocity = p86.Velocity;
        local Restitution = u4.Restitution;
        local vector_dot_ret = vector.dot(Velocity, Normal);

        if vector_dot_ret < 0 then
            Velocity = Velocity - Normal * (vector_dot_ret * (Restitution + 1));
            local vector_dot_ret2 = vector.dot(Velocity, Normal);

            if vector_dot_ret2 < 0 then
                Velocity = Velocity - Normal * math.min(vector_dot_ret2, -0.03125);
            end;
        end;

        p86.Velocity = Velocity;
        local _ = i;
    end;

    return v88;
end;

function u1.Step(p90: any, p91: number) -- Line: 435
    -- upvalues: u4 (copy), ProjectVelocity (copy), ApplyFriction (copy), u1 (copy), UpdateRotations (copy), u7 (ref)
    if not (p90.Stucked or p90.Resting) then
        if not p90.Sleeping then
            p90.Velocity = p90.Velocity - Vector3.new(0, 1, 0) * (u4.Gravity * p91);
            local vector_magnitude_ret = vector.magnitude(p90.Velocity);

            if u4.MaxSpeed < vector_magnitude_ret then
                p90.Velocity = p90.Velocity * (u4.MaxSpeed / vector_magnitude_ret);
            end;

            local v92 = ProjectVelocity(p90, p91);

            if v92 then
                p90.TargetNormal = v92;
            end;

            ApplyFriction(p90, p91, v92);

            if p90.OnGround and vector.magnitude(p90.Velocity) < u4.SleepSpeed then
                p90.Velocity = Vector3.new(0, 0, 0);
                p90.Sleeping = true;
            end;
        end;

        local Pitch = p90.Pitch;
        local Yaw = p90.Yaw;
        local Roll = p90.Roll;
        local Normal = p90.Normal;
        local Rotation = u1.GetRotation(p90);
        UpdateRotations(p90, p91);

        if p90.Pitch == Pitch and (p90.Yaw == Yaw and (p90.Roll == Roll and p90.Normal == Normal)) then
            return;
        end;

        local Rotation2 = u1.GetRotation(p90);
        local Position = p90.Position;

        if p90.OnGround and p90.TargetNormal then
            local TargetNormal = p90.TargetNormal;
            local v93 = p90.CollisionBox * 0.5;
            local vector_dot_ret = vector.dot(Rotation2.XVector, TargetNormal);
            local v94 = math.abs(vector_dot_ret) * v93.X;
            local vector_dot_ret2 = vector.dot(Rotation2.YVector, TargetNormal);
            local v95 = v94 + math.abs(vector_dot_ret2) * v93.Y;
            local vector_dot_ret3 = vector.dot(Rotation2.ZVector, TargetNormal);
            local v96 = v95 + math.abs(vector_dot_ret3) * v93.Z;
            local vector_dot_ret4 = vector.dot(Rotation.XVector, TargetNormal);
            local v97 = math.abs(vector_dot_ret4) * v93.X;
            local vector_dot_ret5 = vector.dot(Rotation.YVector, TargetNormal);
            local v98 = v97 + math.abs(vector_dot_ret5) * v93.Y;
            local vector_dot_ret6 = vector.dot(Rotation.ZVector, TargetNormal);
            local v99 = v96 - (v98 + math.abs(vector_dot_ret6) * v93.Z);
            Position = Position + TargetNormal * v99;

            if v99 < 0 then
                Rotation = Rotation2;
            end;
        end;

        local v100;

        if Position == p90.Position then
            v100 = false;
        else
            v100 = u7.SweepBox(p90.Position, Position, p90.CollisionBox, Rotation);
        end;

        if not (v100 and (v100.AllSolid or v100.Fraction < 1) or u7.BoxSolid(Position, p90.CollisionBox, Rotation2)) then
            p90.Position = Position;

            return;
        end;

        p90.Pitch = Pitch;
        p90.Yaw = Yaw;
        p90.Roll = Roll;
        p90.Normal = Normal;
        p90.Resting = false;
    end;
end;

function u1.GetRotation(p101) -- Line: 493
    -- upvalues: u4 (copy)
    if p101.Name == "Bomb" then
        return CFrame.fromEulerAnglesYXZ(u4.BombRestPitch, p101.Yaw, p101.Roll);
    end;

    local v102 = p101.Normal or Vector3.new(0, 1, 0);
    local vector_magnitude_ret = vector.magnitude(v102);
    local v103 = vector_magnitude_ret <= 0.001 and Vector3.new(0, 1, 0) or v102 / vector_magnitude_ret;
    local vector_cross_ret = vector.cross(Vector3.new(0, 1, 0), v103);
    local vector_magnitude_ret2 = vector.magnitude(vector_cross_ret);

    if vector_magnitude_ret2 <= 0.001 then
        return CFrame.Angles(p101.Pitch, p101.Yaw, p101.Roll);
    end;

    local vector_dot_ret = vector.dot(Vector3.new(0, 1, 0), v103);
    local math_clamp_ret = math.clamp(vector_dot_ret, -1, 1);

    return CFrame.fromAxisAngle(vector_cross_ret / vector_magnitude_ret2, (math.acos(math_clamp_ret))) * CFrame.Angles(p101.Pitch, p101.Yaw, p101.Roll);
end;

function u1.GetCFrame(p104) -- Line: 521
    -- upvalues: u1 (copy)
    return CFrame.new(p104.Position) * u1.GetRotation(p104) * CFrame.new(-(p104.BoxCentre or Vector3.new(0, 0, 0)));
end;

function u1.RayHitsWeapon(p105: any, p106: any, p107: any, p108: any, p109: any, p110: number?) -- Line: 531
    -- upvalues: u1 (copy), u8 (ref), RaycastParams_new_ret (copy)
    local CFrame2 = u1.GetCFrame(p109 or p105);
    local v111 = p110 and (p110 > 0 and vector.create(p110, p110, p110)) or nil;

    for _, v in p105.Hitboxes do
        local v112 = CFrame2 * v.CFrame;
        local v113 = v112:PointToObjectSpace(p106);
        local v114 = v112:VectorToObjectSpace(p107);
        local v115 = v111 and v.Half + v111 or v.Half;

        if u8.RayHitsBox(v113.X, v113.Y, v113.Z, v114.X, v114.Y, v114.Z, -v115, v115, p108) then
            if v111 then
                return true;
            end;

            local CFrame3 = p105.Model.PrimaryPart.CFrame;
            local v116 = CFrame3:PointToWorldSpace(CFrame2:PointToObjectSpace(p106));
            local v117 = CFrame3:VectorToWorldSpace(CFrame2:VectorToObjectSpace(p107));
            RaycastParams_new_ret.FilterDescendantsInstances = { p105.Model };

            return workspace:Raycast(v116, v117 * p108, RaycastParams_new_ret) ~= nil;
        end;
    end;

    return false;
end;

local function Separated(p118, p119, p120, p121, p122) -- Line: 553
    local v123 = math.abs(p118.X) * p120.X + math.abs(p118.Y) * p120.Y + math.abs(p118.Z) * p120.Z;
    local vector_dot_ret = vector.dot(p119, p118);
    local math_abs_ret = math.abs(vector_dot_ret);
    local vector_dot_ret2 = vector.dot(p121.XVector, p118);
    local v124 = math.abs(vector_dot_ret2) * p122.X;
    local vector_dot_ret3 = vector.dot(p121.YVector, p118);
    local v125 = v124 + math.abs(vector_dot_ret3) * p122.Y;
    local vector_dot_ret4 = vector.dot(p121.ZVector, p118);

    return v123 + (v125 + math.abs(vector_dot_ret4) * p122.Z) + 0.00001 < math_abs_ret;
end;

function u1.OverlapsBox(p126, p127, p128) -- Line: 559
    -- upvalues: u4 (copy), u1 (copy), u2 (copy), Separated (copy)
    local v129 = p126.Position - p127;
    local v130 = p126.PickupRadius or vector.magnitude(p126.CollisionBox) * 0.5;

    if math.abs(v129.X) > p128.X + v130 + 0.00001 or (math.abs(v129.Y) > p128.Y + v130 + 0.00001 or math.abs(v129.Z) > p128.Z + v130 + 0.00001) then
        return false;
    end;

    local PickupBounds = p126.PickupBounds;

    if not PickupBounds then
        PickupBounds = {
            Boxes = {}
        };
        p126.PickupBounds = PickupBounds;
    end;

    if PickupBounds.Position ~= p126.Position or (PickupBounds.Pitch ~= p126.Pitch or (PickupBounds.Yaw ~= p126.Yaw or (PickupBounds.Roll ~= p126.Roll or (PickupBounds.Normal ~= p126.Normal or (PickupBounds.Hitboxes ~= p126.Hitboxes or (PickupBounds.BoxCentre ~= p126.BoxCentre or PickupBounds.BombRestPitch ~= u4.BombRestPitch)))))) then
        local CFrame2 = u1.GetCFrame(p126);

        for i, v in p126.Hitboxes do
            local v131 = CFrame2 * v.CFrame;
            local v132 = PickupBounds.Boxes[i] or {};
            local Half = v.Half;
            v132.Frame = v131;
            v132.Half = Half;
            local YVector = v131.YVector;
            local ZVector = v131.ZVector;
            v132.X = v131.XVector;
            v132.Y = YVector;
            v132.Z = ZVector;
            PickupBounds.Boxes[i] = v132;
        end;

        local Pitch = p126.Pitch;
        local Yaw = p126.Yaw;
        PickupBounds.Position = p126.Position;
        PickupBounds.Pitch = Pitch;
        PickupBounds.Yaw = Yaw;
        local Normal = p126.Normal;
        local Hitboxes = p126.Hitboxes;
        PickupBounds.Roll = p126.Roll;
        PickupBounds.Normal = Normal;
        PickupBounds.Hitboxes = Hitboxes;
        local BombRestPitch = u4.BombRestPitch;
        PickupBounds.BoxCentre = p126.BoxCentre;
        PickupBounds.BombRestPitch = BombRestPitch;
    end;

    for i = 1, #p126.Hitboxes do
        local v133 = PickupBounds.Boxes[i];
        local Frame = v133.Frame;
        local Position = Frame.Position;
        local v134 = vector.create(Position.X, Position.Y, Position.Z) - p127;
        local _ = i;
        local v135 = false;

        for _, v in u2 do
            if Separated(v, v134, p128, Frame, v133.Half) then
                v135 = true;
                break;
            end;
        end;

        if not v135 then
            for i2 = 1, 3 do
                local v136 = i2 == 1 and v133.X or (i2 == 2 and v133.Y or v133.Z);

                if Separated(v136, v134, p128, Frame, v133.Half) then
                    v135 = true;
                end;

                local _ = i2;

                for _, v in u2 do
                    if Separated(vector.cross(v136, v), v134, p128, Frame, v133.Half) then
                        v135 = true;
                        break;
                    end;
                end;

                if v135 then
                    break;
                end;
            end;

            if not v135 then
                return true;
            end;
        end;
    end;

    return false;
end;

function u1.PushDroppedWeapons(p137: any, p138: vector, p139: vector, p140: number, p141: number?) -- Line: 625
    -- upvalues: u4 (copy), u6 (ref), u1 (copy)
    if not p137 then
        return;
    end;

    local DropBulletImpulse = u4.DropBulletImpulse;
    local v142 = Vector3.new(0, 1, 0) * (DropBulletImpulse * 0.4);
    local PushTumble = u4.PushTumble;

    for _, v in p137 do
        if v.Name ~= "Bomb" then
            local v143;

            if p141 then
                local _, _, _, v144 = u6.GetStateAtTime(v, p141);
                v143 = v144 or v;
            else
                v143 = v;
            end;

            if u1.RayHitsWeapon(v, p138, p139, p140, v143) then
                v.Velocity = v.Velocity + (p139 * DropBulletImpulse + v142);
                local v145 = v.AngVel or Vector3.new(0, 0, 0);
                local v146 = (math.random() - 0.5) * (2 * PushTumble);
                local v147 = (math.random() - 0.5) * (2 * PushTumble);
                local v148 = (math.random() - 0.5) * (2 * PushTumble);
                v.AngVel = v145 + vector.create(v146, v147, v148);
                v.TargetRoll = nil;
                v.TargetNormal = nil;
                v.Resting = false;
                v.Sleeping = false;
                v.OnGround = false;
            end;
        end;
    end;
end;

function u1.Init(p149) -- Line: 667
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u3 (ref), u9 (ref), RefreshPhysicsConfig (copy)
    u6 = p149:GetModule("Entities");
    u7 = p149:GetModule("CollisionModule");
    u8 = p149:GetModule("CollisionMath");
    u3 = p149:GetModule("GameConfiguration");
    u9 = p149:GetModule("Math");
    RefreshPhysicsConfig();
    u3.Updated:Connect(RefreshPhysicsConfig);
end;

return u1;