-- ReplicatedStorage.GameClient.CameraController.CameraTypes.Freecam
-- Script path: ReplicatedStorage.GameClient.CameraController.CameraTypes.Freecam
-- Decompile time: 4.64 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = Vector3.new(0, 0, 0);
local u3 = Vector3.new(0, 0, 0);
local u4 = false;
local u5 = 16;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = 0;
local u10 = 0;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = false;
local u18 = nil;

function v1.Begin(p19) -- Line: 42
    -- upvalues: u17 (ref), u11 (ref), u10 (ref), u2 (ref), u13 (ref), u18 (ref)
    if u17 then
        if p19 then
            u11.SetCameraCFrame(p19);
        end;

        return;
    end;

    u11.SetTarget(2);
    u11.SetZoom(0);
    u10 = u11.GetFieldOfView();
    u17 = true;
    u2 = Vector3.new(0, 0, 0);

    if p19 then
        u11.SetCameraCFrame(p19);

        return;
    end;

    if not u13.IsAlive() then
        local RandomSpawn = u18.GetRandomSpawn();

        if RandomSpawn then
            u11.SetCameraCFrame(RandomSpawn.CFrame);
        end;

        return;
    end;

    local Simulation = u13.GetCharacter().Simulation;
    local Position = Simulation.Position;
    local StepUp = Simulation.StepUp;
    local CameraOffset = Simulation.CameraOffset;
    local Height = Simulation.Height;
    local Angles, v20 = u11.GetAngles();
    u11.SetCameraCFrame(CFrame.fromEulerAnglesYXZ(-v20, Angles, 0) + (Position + Vector3.new(0, 1, 0) * (CameraOffset + StepUp + Height)));
end;

function v1.End() -- Line: 88
    -- upvalues: u17 (ref)
    if not u17 then
        return;
    end;

    u17 = false;
end;

function v1.Update(p21: table, p22, p23: number, p24: number, p25: number) -- Line: 96
    -- upvalues: u17 (ref), u14 (ref), u2 (ref), u16 (ref), u12 (ref), u3 (ref), u5 (ref), u9 (ref), u8 (ref), u4 (ref), u6 (ref), u7 (ref), u10 (ref), u11 (ref)
    if not u17 then
        return p22;
    end;

    local LookVector = p22.LookVector;
    local RightVector = p22.RightVector;
    local UpVector = p22.UpVector;
    local ControllerMove = u14.GetControllerMove();
    local v26 = u2 + (u16 and u16.GetMoveVector() or Vector3.new(0, 0, 0));

    if ControllerMove.Magnitude >= 0.15 and not u12.HasFramePriority() then
        v26 = v26 + vector.create(ControllerMove.X, 0, -ControllerMove.Y);
    end;

    local v27 = LookVector * -v26.Z + RightVector * v26.X + UpVector * v26.Y;
    local vector_magnitude_ret = vector.magnitude(v27);

    if vector_magnitude_ret > 1 then
        v27 = v27 / vector_magnitude_ret;
    end;

    local math_clamp_ret = math.clamp(p25 / 0.1, 0, 1);
    u3 = vector.lerp(u3, v27, math_clamp_ret);
    u5 = math.clamp(u5 + p25 * 20 * (u9 + u8), 1, 100);
    local v28 = CFrame.fromEulerAnglesYXZ(-p23, p24, 0) + (p22.Position + (u6 ~= 0 and p22.LookVector * 6 * -u6 or u3 * (u5 * (u4 and 0.5 or 1) * p25)));
    u6 = 0;

    if u7 ~= 0 then
        if u10 <= 0 then
            u10 = u11.GetFieldOfView();
        end;

        local v29 = math.clamp(u10, 1, 120) * 0.5;
        local math_rad_ret = math.rad(v29);
        local v30 = 0.836784045145287 / math.tan(math_rad_ret);
        local v31 = u11.GetFieldOfView() + u7 * 1 * 2.5 * 450 * (p25 / v30);
        u10 = math.clamp(v31, 1, 120);
        u11.SetFOVAmount(u10);
        u7 = 0;
    end;

    return v28;
end;

function v1.SetFreecamMoveDirection(p32: number, p33: number, p34: number) -- Line: 147
    -- upvalues: u2 (ref)
    u2 = vector.create(p32, p33, p34);
end;

function v1.SetFreecamShift(p35: boolean) -- Line: 151
    -- upvalues: u4 (ref)
    u4 = p35;
end;

function v1.SetFreecamMouseWheelPosition(p36: number) -- Line: 155
    -- upvalues: u6 (ref)
    u6 = p36;
end;

function v1.SetFreecamMouseWheelPosition2(p37: number) -- Line: 159
    -- upvalues: u7 (ref)
    u7 = p37;
end;

function v1.SetFreecamUpSpeedKey(p38: number) -- Line: 164
    -- upvalues: u8 (ref)
    u8 = p38;
end;

function v1.SetFreecamDownSpeedKey(p39: number) -- Line: 168
    -- upvalues: u9 (ref)
    u9 = p39;
end;

function v1.GetState() -- Line: 172
    -- upvalues: u17 (ref)
    return u17;
end;

function v1.Init(p40) -- Line: 178
    -- upvalues: u11 (ref), u12 (ref), u18 (ref), u13 (ref), u14 (ref), u15 (ref)
    u11 = p40:GetModule("CameraController");
    u12 = p40:GetModule("BindsController");
    u18 = p40:GetModule("NewMapAdded");
    u13 = p40:GetModule("CharacterController");
    u14 = p40:GetModule("CharacterInput");
    u15 = p40:GetModule("Gui");
end;

function v1.Start(p41) -- Line: 187
    -- upvalues: u16 (ref), u15 (ref)
    u16 = u15.GetComponent("MobileControls");
end;

return v1;