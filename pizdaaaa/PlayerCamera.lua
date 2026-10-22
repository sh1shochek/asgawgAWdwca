-- ReplicatedStorage.GameClient.CameraController.CameraTypes.PlayerCamera
-- Script path: ReplicatedStorage.GameClient.CameraController.CameraTypes.PlayerCamera
-- Decompile time: 4.47 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 1;
local u7 = nil;
local u8 = 0;
local u9 = nil;
local u10 = nil;

local function CalculateViewBob(p11, p12, p13) -- Line: 27
    -- upvalues: u10 (ref), u7 (ref), u9 (ref), u8 (ref)
    if p11 ~= u10 then
        u10 = p11;
        u7 = nil;
        u9 = nil;
    end;

    if p12.OnGround and (p13 and (not p13.OnGround and p12.CurrentFrame ~= u9)) then
        local FallingVelocity = p13.FallingVelocity;
        u9 = p12.CurrentFrame;

        if FallingVelocity > 0.6940000000000001 and FallingVelocity <= 71.0656 then
            u7 = os.clock();
            u8 = FallingVelocity;
        end;
    end;

    if not u7 then
        return 0;
    end;

    local v14 = (os.clock() - u7) / 0.15;

    if v14 < 1.5 then
        return -((0.1 / (u8 / 0.0694) + 2.4) * (v14 * v14 * (3 - 2 * v14))) * 0.0694;
    end;

    u7 = nil;

    return 0;
end;

function u1.RefreshRecoilConfig() -- Line: 67
    -- upvalues: u6 (ref), u3 (ref)
    u6 = u3.Get("Weapon", "RecoilScale") * (u3.Get("Weapon", "HitboxRecoilScale") or 1) * u3.Get("Weapon", "ViewRecoilTracking");
end;

function u1.Update(p15: table, p16, p17: any, p18: number, p19: number, p20: number, p21: number) -- Line: 73
    -- upvalues: u2 (ref), u5 (ref), u6 (ref), u4 (ref), CalculateViewBob (copy)
    local MisPredictionOffset = p17:GetMisPredictionOffset();
    local PreviousSimulation = p17.PreviousSimulation;
    local Simulation = p17.Simulation;
    local Position = Simulation.Position;
    local StepUp = Simulation.StepUp;
    local CameraOffset = Simulation.CameraOffset;
    local Height = Simulation.Height;
    local AccumulatedTime = u2.GetAccumulatedTime();
    local math_clamp_ret = math.clamp(AccumulatedTime, 0, p21);
    local v22 = u5.DecayViewPunchAngle(Simulation.ViewPunchAngle, math_clamp_ret);
    local v23 = u5.DecayAimPunchAngle(Simulation.AimPunchAngle, Simulation.AimPunchAngleVel, math_clamp_ret);
    Simulation.RenderAimPunchAngle = v23;

    if PreviousSimulation then
        local Position2 = PreviousSimulation.Position;

        if vector.magnitude(Position2 - Position) < 5 then
            local v24 = u2.GetAccumulatedTime() / p21;
            Position = vector.lerp(Position2, Position, v24);
            StepUp = math.lerp(PreviousSimulation.StepUp, StepUp, v24);
            CameraOffset = math.lerp(PreviousSimulation.CameraOffset, CameraOffset, v24);
            Height = math.lerp(PreviousSimulation.Height, Height, v24);
        end;
    end;

    local v25 = v23 * u6 + v22;
    local v26 = u4.GetRecoilAssistMultiplier() or 0;

    if v26 ~= 0 then
        v25 = v25 * (1 - v26);
    end;

    local v27 = -p18 + math.rad(v25.X);
    local math_clamp_ret2 = math.clamp(v27, -1.5707963267948966, 1.5707963267948966);
    local v28 = CalculateViewBob(p17, Simulation, PreviousSimulation);

    return CFrame.fromEulerAnglesYXZ(math_clamp_ret2, p19 + math.rad(v25.Y), (math.rad(v25.Z))) + (Position + Vector3.new(0, 1, 0) * (CameraOffset + StepUp + Height + v28) + MisPredictionOffset);
end;

function u1.Init(p29) -- Line: 137
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u1 (copy)
    u2 = p29:GetModule("Tick");
    u3 = p29:GetModule("GameConfiguration");
    u4 = p29:GetModule("MobileAimAssist");
    u5 = p29:GetModule("Camera");
    u1.RefreshRecoilConfig();
    u3.Updated:Connect(u1.RefreshRecoilConfig);
end;

function u1.Start(p30) -- Line: 147
    -- upvalues: u1 (copy)
    u1.RefreshRecoilConfig();
end;

return u1;