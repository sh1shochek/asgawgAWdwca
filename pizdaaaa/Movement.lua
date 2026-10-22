-- ReplicatedStorage.Shared.Simulation.Movement
-- Script path: ReplicatedStorage.Shared.Simulation.Movement
-- Decompile time: 25.05 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function ClampAxis(p2: number, p3: number) -- Line: 49
    return math.clamp(p2 == p2 and p2 and p2 or 0, -p3, p3);
end;

require(script.Parent.Collision);
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;

local function AirAcceleration(p9: any, p10: vector, p11: number, p12: number) -- Line: 60
    local v13 = math.min(p9.Constants.MaxAirStrafeSpeed, p11) - vector.dot(p9.Velocity, p10);

    if v13 <= 0 then
        return;
    end;

    local math_min_ret = math.min(v13, p9.Constants.AirAcceleration * p11 * p12 * (p9.AirFrictionReduced and 0.65 or 1));
    p9.Velocity = p9.Velocity + math_min_ret * p10;
end;

local function PreventBunnyJumping(p14) -- Line: 76
    -- upvalues: u6 (ref)
    local v15 = 18.044 * u6.CFG.BunnyHopMaxSpeedFactor;

    if v15 <= 0 then
        return;
    end;

    local vector_dot_ret = vector.dot(p14.Velocity, p14.Velocity);

    if vector_dot_ret <= v15 * v15 then
        return;
    end;

    p14.Velocity = p14.Velocity * (v15 / math.sqrt(vector_dot_ret));
end;

local function HasTwoStageScope(p16) -- Line: 96
    local AltFunction = p16.Data.AltFunction;

    return AltFunction and (AltFunction.Zoom and AltFunction.Zoom.Second) and true or false;
end;

local function Accelerate(p17: any, p18: vector, p19: number, p20: number) -- Line: 102
    -- upvalues: u6 (ref)
    local CurrentWeapon = p17.CurrentWeapon;
    local vector_dot_ret = vector.dot(p17.Velocity, p18);
    local v21 = p19 - vector_dot_ret;

    if v21 <= 0 then
        return;
    end;

    local math_max_ret = math.max(0, vector_dot_ret);
    local Constants = p17.Constants;
    local v22 = CurrentWeapon and (CurrentWeapon.Data.Speed[CurrentWeapon.Mode] or 17.35) or 17.35;
    local DuckHeld = p17.DuckHeld;
    local v23 = p17.Walk and not DuckHeld;
    local v24 = CurrentWeapon and CurrentWeapon.ZoomLevel;

    if v24 then
        if CurrentWeapon.ZoomLevel > 0 then
            local AltFunction = CurrentWeapon.Data.AltFunction;
            v24 = (AltFunction and (AltFunction.Zoom and AltFunction.Zoom.Second) and true or false) and v22 * Constants.WalkModifier < 7.634;
        else
            v24 = false;
        end;
    end;

    local math_max_ret2 = math.max(17.35, p19);
    local math_min_ret = math.min(1, v22 / 17.35);
    local v25 = math_max_ret2 * math_min_ret;

    if not (DuckHeld or v23) or v24 then
        math_max_ret2 = math_max_ret2 * math_min_ret;
    end;

    if v24 then
        math_max_ret2 = math_max_ret2 * u6.CFG.ScopedAccelerationScale;
    end;

    if DuckHeld then
        if not v24 then
            math_max_ret2 = math_max_ret2 * Constants.DuckModifier;
        end;

        v25 = v25 * Constants.DuckModifier;
    end;

    local Acceleration = Constants.Acceleration;

    if v23 then
        if not v24 then
            math_max_ret2 = math_max_ret2 * Constants.WalkModifier;
        end;

        local v26 = v25 * Constants.WalkModifier - 0.347;

        if v26 < math_max_ret then
            Acceleration = Acceleration * math.clamp(1 - (math_max_ret - v26) / 0.347, 0, 1);
        end;
    end;

    local math_min_ret2 = math.min(v21, Acceleration * p20 * math_max_ret2);
    p17.Velocity = p17.Velocity + math_min_ret2 * p18;
end;

local function Friction(p27: any, p28: number) -- Line: 173
    local vector_dot_ret = vector.dot(p27.Velocity, p27.Velocity);

    if vector_dot_ret < 0.000048163600000000014 then
        return;
    end;

    local Constants = p27.Constants;
    local math_sqrt_ret = math.sqrt(vector_dot_ret);
    local v29;

    if math_sqrt_ret < Constants.StopSpeed then
        v29 = Constants.StopSpeed or math_sqrt_ret;
    else
        v29 = math_sqrt_ret;
    end;

    p27.Velocity = p27.Velocity * (math.max(0, math_sqrt_ret - v29 * Constants.Friction * p28) / math_sqrt_ret);
end;

function u1.ClampVelocity(p30) -- Line: 190
    local Velocity = p30.Velocity;
    local MaxVelocity = p30.Constants.MaxVelocity;

    if vector.dot(Velocity, Velocity) <= MaxVelocity * MaxVelocity then
        return;
    end;

    local X = Velocity.X;
    local math_clamp_ret = math.clamp(X == X and X and X or 0, -MaxVelocity, MaxVelocity);
    local Y = Velocity.Y;
    local math_clamp_ret2 = math.clamp(Y == Y and Y and Y or 0, -MaxVelocity, MaxVelocity);
    local Z = Velocity.Z;
    local math_clamp_ret3 = math.clamp(Z == Z and Z and Z or 0, -MaxVelocity, MaxVelocity);
    p30.Velocity = vector.create(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
end;

function u1.StartGravity(p31: any, p32: number) -- Line: 219
    p31.Velocity = p31.Velocity - Vector3.new(0, 1, 0) * (p31.Constants.Gravity * p32 * 0.5);
end;

function u1.FinishGravity(p33: any, p34: number) -- Line: 223
    p33.Velocity = p33.Velocity - Vector3.new(0, 1, 0) * (p33.Constants.Gravity * p34 * 0.5);
end;

function u1.CheckJumpButton(p35: any, p36: number) -- Line: 234
    -- upvalues: u7 (ref), u6 (ref), u1 (copy)
    local Constants = p35.Constants;
    local v37 = false;
    local v38 = false;
    local StandingPart = p35.StandingPart;

    if StandingPart then
        StandingPart = StandingPart.Parent;
    end;

    if StandingPart then
        StandingPart = tonumber(StandingPart.Name);
    end;

    if StandingPart then
        local Entity = u7.GetEntity("Character", StandingPart);

        if Entity then
            v37 = true;

            if Entity.OnGround == false then
                v38 = true;
            else
                v38 = false;
            end;
        end;
    end;

    p35.OnGround = false;
    p35.StandingPart = nil;

    if not u6.CFG.EnableBunnyHop then
        local v39 = 18.044 * u6.CFG.BunnyHopMaxSpeedFactor;

        if v39 > 0 then
            local vector_dot_ret = vector.dot(p35.Velocity, p35.Velocity);

            if vector_dot_ret > v39 * v39 then
                p35.Velocity = p35.Velocity * (v39 / math.sqrt(vector_dot_ret));
            end;
        end;
    end;

    local Velocity = p35.Velocity;
    local JumpImpulse = Constants.JumpImpulse;
    local Y = Velocity.Y;

    if v38 then
        JumpImpulse = 0;
    elseif not (p35.Ducking or (u1.HasDuckFlag(p35) or v37)) then
        JumpImpulse = Y + JumpImpulse;
    end;

    if p35.Stamina > 0 then
        JumpImpulse = JumpImpulse * math.clamp(1 - p35.Stamina * 0.01, 0, 1);
    end;

    local v40 = JumpImpulse - Constants.Gravity * p36 * 0.275;
    p35.Velocity = vector.create(Velocity.X, v40, Velocity.Z);
    p35.Stamina = math.clamp(p35.Stamina + Constants.StaminaJumpCost * (v40 - Y), 0, Constants.StaminaMax);
end;

function u1.CheckFalling(p41) -- Line: 311
    -- upvalues: u6 (ref)
    if p41.Noclip then
        p41.FallingVelocity = 0;

        return;
    end;

    local FallingVelocity = p41.FallingVelocity;

    if not p41.OnGround or FallingVelocity <= 0 then
        return;
    end;

    local Constants = p41.Constants;
    p41.Stamina = math.clamp(p41.Stamina + Constants.StaminaLandCost * FallingVelocity, 0, Constants.StaminaMax);

    if p41.Health then
        local v42 = FallingVelocity * math.sqrt(55.52 / Constants.Gravity);

        if v42 > 40.252 and u6.CFG.FallDamage then
            local v43 = (v42 - 40.252) * 3.430767119527926;

            if v43 > 0 then
                p41.Health:Fire(v43);
            end;
        end;
    end;

    if u6.CFG.CameraViewPunch then
        local ViewPunchAngle = p41.ViewPunchAngle;
        local v44;

        if FallingVelocity >= 24.29 then
            local math_max_ret = math.max(ViewPunchAngle.X, -8);
            ViewPunchAngle = vector.create(math_max_ret, ViewPunchAngle.Y, -(FallingVelocity - 40.252) * 0.18731988472622477);
            v44 = true;
        else
            v44 = false;
        end;

        if FallingVelocity > 1.1104 and FallingVelocity <= 71.065 then
            local v45 = -math.max(FallingVelocity * 0.01440922190201729, 0.75);
            ViewPunchAngle = vector.create(v45, ViewPunchAngle.Y, ViewPunchAngle.Z);
            v44 = true;
        end;

        if v44 then
            p41.ViewPunchAngle = ViewPunchAngle;
        end;
    end;

    if p41.CurrentWeapon then
        p41.CurrentWeapon:OnLand(p41);
    end;

    p41.FallingVelocity = 0;
end;

function u1.WalkMove(p46: any, p47: vector, p48: number, p49: number) -- Line: 377
    -- upvalues: Accelerate (copy)
    local vector_dot_ret = vector.dot(p46.Velocity, p46.Velocity);

    if vector_dot_ret >= 0.000048163600000000014 then
        local Constants = p46.Constants;
        local math_sqrt_ret = math.sqrt(vector_dot_ret);
        local v50;

        if math_sqrt_ret < Constants.StopSpeed then
            v50 = Constants.StopSpeed or math_sqrt_ret;
        else
            v50 = math_sqrt_ret;
        end;

        p46.Velocity = p46.Velocity * (math.max(0, math_sqrt_ret - v50 * Constants.Friction * p49) / math_sqrt_ret);
    end;

    if p48 then
        Accelerate(p46, p47, p48, p49);
    end;

    local CroppedMaxSpeed = p46.CroppedMaxSpeed;
    local vector_dot_ret2 = vector.dot(p46.Velocity, p46.Velocity);

    if CroppedMaxSpeed * CroppedMaxSpeed < vector_dot_ret2 then
        p46.Velocity = p46.Velocity * (CroppedMaxSpeed / math.sqrt(vector_dot_ret2));
    end;

    if vector.dot(p46.Velocity, p46.Velocity) < 0.00481636 then
        p46.Velocity = Vector3.new(0, 0, 0);
    end;

    p46.HasWalkMovedSinceLastJump = true;
end;

function u1.AirMove(p51: any, p52: vector, p53: number, p54: number) -- Line: 402
    if p53 then
        local v55 = math.min(p51.Constants.MaxAirStrafeSpeed, p53) - vector.dot(p51.Velocity, p52);

        if v55 <= 0 then
            return;
        end;

        local math_min_ret = math.min(v55, p51.Constants.AirAcceleration * p53 * p54 * (p51.AirFrictionReduced and 0.65 or 1));
        p51.Velocity = p51.Velocity + math_min_ret * p52;
    end;
end;

function u1.FullNoClipMove(p56: any, p57: number) -- Line: 416
    if p57 <= 0 then
        return;
    end;

    local v58 = 5;
    local v59 = p56.Constants.MaxSpeed or 20.044;

    if p56.Walk then
        v58 = v58 / 2;
    end;

    local v60 = v59 * v58;
    local v61 = -p56.CurrentMoveZ * v59 * v58;
    local v62 = p56.CurrentMoveX * v59 * v58;
    local v63 = ((p56.WannaJumpButton and 1 or 0) + (p56.WannaDuck and -1 or 0)) * v59 * v58;
    local CFrame_fromEulerAnglesYXZ_ret = CFrame.fromEulerAnglesYXZ(-p56.Pitch, p56.Yaw, 0);
    local v64 = CFrame_fromEulerAnglesYXZ_ret.LookVector * v61 + CFrame_fromEulerAnglesYXZ_ret.RightVector * v62 + Vector3.new(0, 1, 0) * v63;
    local vector_magnitude_ret = vector.magnitude(v64);
    local v65 = vector_magnitude_ret <= 0 and Vector3.new(0, 0, 0) or v64 / vector_magnitude_ret;

    if v60 < vector_magnitude_ret then
        local _ = v64 * (v60 / vector_magnitude_ret);
        vector_magnitude_ret = v60;
    end;

    if vector_magnitude_ret > 0 then
        local v66 = vector_magnitude_ret - vector.dot(p56.Velocity, v65);

        if v66 > 0 then
            local math_max_ret = math.max(17.35, vector_magnitude_ret);
            local math_min_ret = math.min(v66, p57 * 5 * math_max_ret);
            p56.Velocity = p56.Velocity + v65 * math_min_ret;
        end;
    end;

    local vector_magnitude_ret2 = vector.magnitude(p56.Velocity);

    if vector_magnitude_ret2 < 0.07 then
        p56.Velocity = Vector3.new(0, 0, 0);

        return;
    end;

    local v67;

    if vector_magnitude_ret2 < v60 / 4 then
        v67 = v60 / 4 or vector_magnitude_ret2;
    else
        v67 = vector_magnitude_ret2;
    end;

    local math_max_ret = math.max(0, vector_magnitude_ret2 - v67 * (p56.Constants.Friction or 5.2) * p57);
    p56.Velocity = p56.Velocity * (math_max_ret / vector_magnitude_ret2);
end;

function u1.LadderMove(p68: any, p69: vector, p70: number, p71: number, p72: boolean, p73: boolean) -- Line: 484
    -- upvalues: u4 (ref), u6 (ref)
    local v74 = u4.SweepLadders(p68.Position, p68.Position + p69 * (p68.Climbing and p68.Constants.LadderRangeClimbing or p68.Constants.LadderRangeGrab), p68.Ducked);

    if v74 then
        if v74.Fraction == 1 or (not v74.Climbable or v74.Normal.Y == 1) then
            local v75 = false;

            if p68.HasWalkMovedSinceLastJump and not (p68.Climbing or (p68.OnGround or (p68.Velocity.Y > 0 or (p68.Velocity.Y <= -50 or (p68.Velocity.X == 0 or p68.Velocity.Z == 0))))) then
                local vector_normalize_ret = vector.normalize(p68.Velocity);
                local v76 = u4.Sweep(p68.Position - Vector3.new(0, 1, 0) * p68.Constants.LadderEdgeGrabHeightDelta, p68.Position - vector_normalize_ret * p68.Constants.LadderEdgeGrabDistance, p68.Ducked);

                if v76.Fraction ~= 1 and (v76.Climbable and v76.Normal.Y ~= 1) then
                    p68.LadderNormal = v76.Normal;
                    p68.Velocity = Vector3.new(0, 0, 0);
                    p68.Position = v76.EndPosition;
                    p68.Climbing = true;
                    v75 = true;
                end;
            end;

            if not v75 then
                p68.Climbing = false;

                return;
            end;
        else
            p68.LadderNormal = v74.Normal;
        end;

        if not p68.Climbing then
            p68.IgnoreLadderJumpTime = p68.CurrentFrame + u6.CFG.LadderIgnoreJumpTicks;

            if p68.IgnoreLadderJumpTime >= 256 then
                p68.IgnoreLadderJumpTime = p68.IgnoreLadderJumpTime - 256;
            end;

            p68.Climbing = true;
        end;

        local v77 = (p68.CurrentFrame - p68.IgnoreLadderJumpTime) % 256;
        local v78;

        if v77 > 0 then
            v78 = v77 < 128;
        else
            v78 = false;
        end;

        if v78 then
            p68.IgnoreLadderJumpTime = (p68.CurrentFrame - 1) % 256;
        end;

        if p68.WannaJumpButton then
            if v78 then
                p68.Velocity = p68.LadderNormal * p68.Constants.LadderJumpOffSpeed;
                p68.Climbing = false;
            end;
        else
            if p70 == 0 and p71 == 0 then
                p68.Velocity = Vector3.new(0, 0, 0);

                return;
            end;

            local Constants = p68.Constants;
            local Yaw = p68.Yaw;
            local Pitch = p68.Pitch;
            local math_cos_ret = math.cos(Yaw);
            local math_sin_ret = math.sin(Yaw);
            local math_cos_ret2 = math.cos(Pitch);
            local math_sin_ret2 = math.sin(Pitch);
            local v79 = Constants.LadderSpeed * ((p72 or p73) and (Constants.LadderModifier or 1) or 1);
            local v80 = p71 * v79;
            local v81 = p70 * v79;
            local vector_create_ret = vector.create(v80 * (math_cos_ret2 * math_sin_ret) + v81 * math_cos_ret, v80 * math_sin_ret2, v80 * (math_cos_ret2 * math_cos_ret) - v81 * math_sin_ret);
            local LadderNormal = p68.LadderNormal;
            local vector_cross_ret = vector.cross(Vector3.new(0, 1, 0), LadderNormal);
            local vector_normalize_ret = vector.normalize(vector_cross_ret);
            local vector_dot_ret = vector.dot(vector_create_ret, LadderNormal);
            local v82 = LadderNormal * vector_dot_ret;
            local v83 = vector_create_ret - v82;
            local vector_dot_ret2 = vector.dot(Vector3.new(0, 1, 0), v83);
            local vector_dot_ret3 = vector.dot(vector_normalize_ret, v83);
            local vector_normalize_ret2 = vector.normalize(vector_normalize_ret * vector_dot_ret3 + v82);

            if vector.dot(vector_normalize_ret2, LadderNormal) < Constants.LadderAngle then
                v83 = Vector3.new(0, 1, 0) * vector_dot_ret2 + vector_normalize_ret * Constants.LadderDampen * vector_dot_ret3;
            end;

            p68.Velocity = v83 - vector_dot_ret * Vector3.new(0, 1, 0);

            if Constants.LadderSpeedScale > 0 then
                p68.Velocity = p68.Velocity * Constants.LadderSpeedScale;
            end;

            if p68.OnGround and vector_dot_ret > 0 then
                p68.Velocity = p68.Velocity + v79 * LadderNormal;
            end;
        end;
    else
        p68.Climbing = false;
    end;
end;

function u1.CanUnduck(p84) -- Line: 605
    -- upvalues: u6 (ref), u4 (ref)
    if p84.Noclip then
        return true;
    end;

    if not p84.Ducked then
        return true;
    end;

    if u6.CFG.UnduckHeadroomCacheSkip and (p84.LastUnduckResult == true and p84.LastUnduckCheckPos) then
        local v85 = p84.Position - p84.LastUnduckCheckPos;

        if vector.dot(v85, v85) < 0.0001 then
            return true;
        end;
    end;

    local v86 = u4.Sweep(p84.Position, p84.Position + u6.CollisionHeightDeltaVector, p84.Ducked);

    if v86.StartSolid or (v86.Fraction ~= 1 or v86.AllSolid) then
        p84.LastUnduckCheckPos = p84.Position;
        p84.LastUnduckResult = false;

        return false;
    end;

    if not (p84.OnGround or p84.Climbing) then
        local v87 = u4.Sweep(p84.Position, p84.Position - u6.CollisionHeightDeltaVector * 0.5, p84.Ducked);

        if v87.StartSolid or (v87.AllSolid or v87.Fraction ~= 1) then
            p84.LastUnduckCheckPos = p84.Position;
            p84.LastUnduckResult = false;

            return false;
        end;
    end;

    p84.LastUnduckCheckPos = p84.Position;
    p84.LastUnduckResult = true;

    return true;
end;

function u1.GetDuckSpeedModifier(p88) -- Line: 649
    return p88.Constants.DuckModifier * p88.DuckAmount + (1 - p88.DuckAmount);
end;

function u1.FinishDuck(p89) -- Line: 653
    -- upvalues: u6 (ref), u8 (ref)
    p89.Height = u6.CollisionHeightDelta * 0.5;

    if not p89.Ducked and (p89.OnGround or p89.Climbing) then
        p89.Position = p89.Position - u6.CollisionHeightDeltaVector * 0.5;
    end;

    p89.Ducking = false;
    p89.Ducked = true;
    p89.DuckFlag = true;
    p89.DuckCooldown = p89.Constants.DuckCooldown;
    p89.DuckAmount = 1;
    u8.SetDuckedEyeOffset(p89);
    p89:CategorizePosition(true);

    if p89.OnGround and not p89.Climbing then
        p89.Velocity = p89.Velocity * Vector3.new(1, 0, 1);
    end;
end;

function u1.FinishUnduck(p90) -- Line: 676
    -- upvalues: u6 (ref), u8 (ref)
    p90.Height = 0;

    if p90.Ducked and (p90.OnGround or p90.Climbing) then
        p90.Position = p90.Position + u6.CollisionHeightDeltaVector * 0.5;
    end;

    p90.Ducked = false;
    p90.Ducking = false;
    p90.DuckFlag = false;
    p90.DuckAmount = 0;
    u8.SetDuckedEyeOffset(p90);
    p90:CategorizePosition(true);

    if p90.OnGround and not p90.Climbing then
        p90.Velocity = p90.Velocity * Vector3.new(1, 0, 1);
    end;
end;

function u1.HasDuckFlag(p91) -- Line: 711
    return p91.DuckFlag == true;
end;

function u1.DuckingEnabled(p92) -- Line: 720
    -- upvalues: u1 (copy)
    if p92.DuckSpeed < 1.5 then
        return false;
    end;

    return u1.HasDuckFlag(p92) or p92.DuckCooldown <= 0;
end;

function u1.Duck(p93: any, p94: boolean, p95: number) -- Line: 735
    -- upvalues: u1 (copy), u5 (ref), u8 (ref), u6 (ref)
    local Constants = p93.Constants;
    local MaxDuckSpeed = Constants.MaxDuckSpeed;

    if p93.DuckCooldown > 0 then
        p93.DuckCooldown = math.max(0, p93.DuckCooldown - p95);
    end;

    if not (p94 or (p93.LastDuck or (p93.Planting or (p93.Ducking or (p93.Ducked or (p93.DuckAmount ~= 0 or MaxDuckSpeed > p93.DuckSpeed)))))) then
        p93.LastFullCrouchPosition = p93.Position * Vector3.new(1, 0, 1);
        p93.DuckPressed = false;

        return;
    end;

    if p94 ~= p93.LastDuck then
        p93.DuckSpeed = math.max(0, p93.DuckSpeed - Constants.DuckSpeedPenalty);
    end;

    p93.LastDuck = p94;
    local v96 = p94 and u1.DuckingEnabled(p93) or p93.Planting;
    p93.DuckSpeed = u5.Approach(MaxDuckSpeed, p93.DuckSpeed, Constants.DuckSpeedRecoveryRate * p95);

    if MaxDuckSpeed <= p93.DuckSpeed then
        p93.LastFullCrouchPosition = p93.Position * Vector3.new(1, 0, 1);
    elseif p93.DuckAmount <= 0 or p93.DuckAmount >= 1 then
        local v97 = p93.Position * Vector3.new(1, 0, 1) - p93.LastFullCrouchPosition;
        local DuckSpeedFastRecoveryDistance = Constants.DuckSpeedFastRecoveryDistance;

        if vector.dot(v97, v97) > DuckSpeedFastRecoveryDistance * DuckSpeedFastRecoveryDistance then
            p93.DuckSpeed = u5.Approach(MaxDuckSpeed, p93.DuckSpeed, Constants.DuckSpeedFastRecoveryRate * p95);
        end;
    end;

    if v96 or p93.DuckAmount <= 0 then
        if v96 and p93.DuckAmount < 1 then
            p93.Ducking = true;
        end;
    else
        p93.Ducking = true;
    end;

    local v98 = p93.Defusing and 0.4 or 1;

    if v96 and p93.Ducking then
        p93.DuckAmount = u5.Approach(1, p93.DuckAmount, p93.DuckSpeed * 0.8 * v98 * p95);

        if p93.DuckAmount >= 1 or not p93.OnGround then
            u1.FinishDuck(p93);
        else
            u8.SetDuckedEyeOffset(p93);
        end;
    end;

    if not v96 and p93.Ducking then
        if u1.CanUnduck(p93) then
            local v99 = math.max(Constants.MinDuckSpeed, p93.DuckSpeed) * v98;
            p93.DuckAmount = u5.Approach(0, p93.DuckAmount, v99 * p95);

            if p93.Ducked and p93.OnGround then
                p93.Position = p93.Position + u6.CollisionHeightDeltaVector * 0.5;
                p93.Height = 0;
                p93.Ducked = false;
            end;

            if p93.DuckAmount <= 0 or not p93.OnGround then
                u1.FinishUnduck(p93);
            else
                u8.SetDuckedEyeOffset(p93);
            end;

            if p93.DuckAmount <= 0.75 then
                p93.DuckFlag = false;
            end;
        else
            p93.Height = u6.CollisionHeightDelta * 0.5;
            p93.Ducking = false;
            p93.Ducked = true;
            p93.DuckFlag = true;
            p93.DuckAmount = 1;
            u8.SetDuckedEyeOffset(p93);
        end;
    end;

    p93.DuckPressed = v96;
    p93.DuckHeld = v96 or (p93.Ducking or p93.Ducked);
end;

function u1.Init(p100) -- Line: 846
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    u4 = p100:GetModule("CollisionModule");
    u5 = p100:GetModule("Math");
    u6 = p100:GetModule("Config");
    u7 = p100:GetModule("Entities");
    u8 = p100:GetModule("Camera");
end;

return u1;