-- ReplicatedStorage.Shared.Simulation.State
-- Script path: ReplicatedStorage.Shared.Simulation.State
-- Decompile time: 7.58 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = game:GetService("RunService"):IsServer();

function u1.WriteState(p3, p4) -- Line: 16
    -- upvalues: u2 (copy), u1 (copy)
    local CameraOffset = p3.CameraOffset;
    local Height = p3.Height;

    if u2 then
        CameraOffset = math.floor(CameraOffset * 100);
        Height = Height * 1000;
    end;

    local v5 = p4 or {};
    v5.LastDuck = p3.LastDuck;
    v5.Ducked = p3.Ducked;
    v5.Ducking = p3.Ducking;
    v5.DuckFlag = p3.DuckFlag;
    v5.DuckSpeed = p3.DuckSpeed;
    v5.DuckAmount = p3.DuckAmount;
    v5.DuckCooldown = p3.DuckCooldown;
    v5.LastFullCrouchPosition = p3.LastFullCrouchPosition;
    v5.Position = p3.Position;
    v5.Velocity = p3.Velocity;
    local math_map_ret = math.map(p3.Yaw, -3.141592653589793, 3.141592653589793, 0, 65535);
    v5.Yaw = math.floor(math_map_ret);
    local math_map_ret2 = math.map(p3.Pitch, -1.55334, 1.55334, 0, 65535);
    v5.Pitch = math.floor(math_map_ret2);
    v5.StepUp = p3.StepUp;
    v5.Stamina = p3.Stamina;
    v5.FallingVelocity = p3.FallingVelocity;
    v5.OnGround = p3.OnGround;
    v5.AirFrictionReduced = p3.AirFrictionReduced;
    v5.WasGround = p3.WasGround;
    v5.DoJump = p3.DoJump;
    v5.WannaJump = p3.WannaJump;
    v5.PerfectBhopChain = p3.PerfectBhopChain;
    v5.Climbing = p3.Climbing;
    v5.LadderNormal = p3.LadderNormal;
    v5.IgnoreLadderJumpTime = p3.IgnoreLadderJumpTime;
    v5.HasWalkMovedSinceLastJump = p3.HasWalkMovedSinceLastJump;
    v5.IsWalking = p3.IsWalking;
    v5.CurrentFrame = p3.CurrentFrame;
    v5.StepDownFrameSkip = p3.StepDownFrameSkip;
    v5.SkipMovementPhysics = p3.SkipMovementPhysics;
    v5.CameraOffset = CameraOffset;
    v5.Height = Height;
    v5.ViewPunchAngle = p3.ViewPunchAngle;
    v5.AimPunchAngle = p3.AimPunchAngle;
    v5.AimPunchAngleVel = p3.AimPunchAngleVel;
    v5.Planting = p3.Planting;
    v5.Defusing = p3.Defusing;
    v5.DefuseTimer = p3.DefuseTimer;
    v5.ArmorValue = math.floor(p3.ArmorValue);
    v5.HasHelmet = p3.HasHelmet;
    v5.HitPoints = p3.HitPoints;
    v5.FlinchStack = p3.FlinchStack;
    v5.VelocityModifier = p3.VelocityModifier;
    v5.PendingVelocityModifier = p3.PendingVelocityModifier;
    v5.PendingVelocityModifierTicks = p3.PendingVelocityModifierTicks;
    v5.Speed = p3.Constants.Speed;
    v5.HasDefuseKit = p3.HasDefuseKit;

    return u1.Scheme:QuantizeState(v5);
end;

u1.Scheme = nil;

function u1.ReadState(p6, p7) -- Line: 102
    -- upvalues: u1 (copy)
    for i, v in p7 do
        local v8;

        if i == "CameraOffset" then
            v8 = v / 100;
        elseif i == "Height" then
            v8 = v / 1000;
        elseif i == "Pitch" then
            v8 = math.map(v, 0, 65535, -1.55334, 1.55334);
        elseif i == "Yaw" then
            v8 = math.map(v, 0, 65535, -3.141592653589793, 3.141592653589793);
        else
            v8 = v;
        end;

        if i == "Speed" then
            p6.Constants.Speed = v8;
        else
            if typeof(v8) == "table" then
                v8 = u1.ReadState(p6, v8) or v8;
            end;

            p6[i] = v8;
        end;
    end;
end;

return u1;