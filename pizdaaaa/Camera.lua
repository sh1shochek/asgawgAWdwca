-- ReplicatedStorage.Shared.Simulation.Camera
-- Script path: ReplicatedStorage.Shared.Simulation.Camera
-- Decompile time: 12.86 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
local u3 = nil;

function u1.DecayAimPunchAngle(p4: vector, p5: vector, p6: number) -- Line: 20
    -- upvalues: u3 (ref), u2 (ref)
    if not u3.CFG.CameraAimPunch then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    if vector.dot(p4, p4) == 0 and vector.dot(p5, p5) == 0 then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v7 = p6 * 0.5;
    local v8 = u2.DecayAngles(p4, u3.CFG.RecoilDecayExponetial, u3.CFG.RecoilDecayLinear, p6) + p5 * v7;
    local v9 = p5 * math.exp(p6 * -u3.CFG.RecoilVelocityDecay);
    local v10 = v8 + v9 * v7;
    local v11 = vector.dot(v10, v10) < 0.0001 and Vector3.new(0, 0, 0) or v10;

    if vector.dot(v9, v9) < 0.0001 then
        return v11, Vector3.new(0, 0, 0);
    end;

    return v11, v9;
end;

function u1.DecayViewPunchAngle(p12: vector, p13: number) -- Line: 42
    -- upvalues: u3 (ref), u2 (ref)
    if not u3.CFG.CameraViewPunch then
        return Vector3.new(0, 0, 0);
    end;

    if vector.dot(p12, p12) == 0 then
        return Vector3.new(0, 0, 0);
    end;

    local v14 = u2.DecayAngles(p12, u3.CFG.ViewPunchDecay, 0, p13);

    return vector.dot(v14, v14) < 0.0001 and Vector3.new(0, 0, 0) or v14;
end;

function u1.KickBack(p15: any, p16: number, p17: number) -- Line: 60
    -- upvalues: u3 (ref)
    local math_rad_ret = math.rad(p16);
    local math_sin_ret = math.sin(math_rad_ret);
    local math_cos_ret = math.cos(math_rad_ret);
    p15.AimPunchAngleVel = p15.AimPunchAngleVel + vector.create(math_cos_ret * p17, -math_sin_ret * p17, 0);
    local v18 = p17 * u3.CFG.RecoilViewPunchExtra;
    p15.ViewPunchAngle = p15.ViewPunchAngle + vector.create(math_cos_ret * v18, -math_sin_ret * v18, 0);
end;

function u1.UpdatePunchAngles(p19, p20) -- Line: 72
    -- upvalues: u1 (copy)
    if p19.SeenAimPunch then
        p19.SeenAimPunch = u1.DecayAimPunchAngle(p19.SeenAimPunch, p19.AimPunchAngleVel, p20);
    end;

    if p19.ViewPunchAngle == Vector3.new(0, 0, 0) and (p19.AimPunchAngle == Vector3.new(0, 0, 0) and p19.AimPunchAngleVel == Vector3.new(0, 0, 0)) then
        return;
    end;

    p19.ViewPunchAngle = u1.DecayViewPunchAngle(p19.ViewPunchAngle, p20);
    local v21, v22 = u1.DecayAimPunchAngle(p19.AimPunchAngle, p19.AimPunchAngleVel, p20);
    p19.AimPunchAngle = v21;
    p19.AimPunchAngleVel = v22;
end;

function u1.BuildShotCFrame(p23: any, p24: boolean?) -- Line: 111
    -- upvalues: u3 (ref)
    local v25 = p24 == false and Vector3.new(0, 0, 0) or (p23.SeenAimPunch or p23.AimPunchAngle) * u3.CFG.RecoilScale;

    return CFrame.fromEulerAnglesYXZ(-p23.Pitch + math.rad(v25.X), p23.Yaw + math.rad(v25.Y), (math.rad(v25.Z))) + (p23.Position + Vector3.new(0, 1, 0) * (p23.CameraOffset + p23.Height));
end;

function u1.BuildCameraCFrame(p26: any, p27: boolean, p28: boolean) -- Line: 120
    -- upvalues: u3 (ref), u2 (ref)
    local ViewPunchAngle = p26.ViewPunchAngle;
    local CFG = u3.CFG;
    local v29 = p26.AimPunchAngle * (p27 and (CFG.RecoilScale * (p28 and (CFG.ViewRecoilTracking or 1) or 1) or 1) or 1) + ViewPunchAngle;
    local v30 = v29.Z + u2.CalculateRoll(p26.Yaw + math.rad(ViewPunchAngle.Y), p26.Velocity, CFG.ViewPunchRollAngle, CFG.ViewPunchRollSpeed);
    local v31 = -p26.Pitch + math.rad(v29.X);
    local math_clamp_ret = math.clamp(v31, -1.5707963267948966, 1.5707963267948966);

    return CFrame.fromEulerAnglesYXZ(math_clamp_ret, p26.Yaw + math.rad(v29.Y), (math.rad(v30))) + (p26.Position + Vector3.new(0, 1, 0) * (p26.CameraOffset + p26.Height));
end;

function u1.AddStepUp(p32: any, p33: number) -- Line: 150
    local Y = p32.Constants.StepSize.Y;
    p32.StepUp = math.clamp(p32.StepUp + p33, -Y, Y);
end;

function u1.DecayStepUp(p34: any, p35: number) -- Line: 164
    -- upvalues: u2 (ref)
    if p34.StepUp == 0 then
        return;
    end;

    p34.StepUp = u2.Friction(p34.StepUp, 0.05, p35);

    if math.abs(p34.StepUp) < 0.00001 then
        p34.StepUp = 0;
    end;
end;

function u1.SetDuckedEyeOffset(p36) -- Line: 185
    -- upvalues: u2 (ref), u3 (ref)
    local v37 = u2.SimpleSpline(p36.DuckAmount);
    p36.CameraOffset = p36.Constants.StandCameraOffset - u3.CollisionHeightDelta * v37;
end;

function u1.Init(p38) -- Line: 195
    -- upvalues: u2 (ref), u3 (ref)
    u2 = p38:GetModule("Math");
    u3 = p38:GetModule("Config");
end;

return u1;