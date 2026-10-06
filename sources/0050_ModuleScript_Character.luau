-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local MovementV2 = ReplicatedStorage.MovementV2;
local Buttons = require(MovementV2.Buttons);
local JumpInputSampler = require(MovementV2.JumpInputSampler);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local PlayerContacts = require(MovementV2.Simulation.PlayerContacts);
local PredictionErrorSmoother = require(MovementV2.Client.PredictionErrorSmoother);
local Config = require(MovementV2.Simulation.Config);
local State = require(MovementV2.Simulation.State);
local RootFrame = require(MovementV2.RootFrame);
local RuntimeKinematics = require(MovementV2.RuntimeKinematics);
local Signal = require(ReplicatedStorage.Packages.Signal);
local CharacterAnimator = require(script.Classes.CharacterAnimator);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
u1.__index = u1;
local u2 = 150 * Config.Default.HammerUnitToStud;
local ContactMinDistance = PredictionErrorSmoother.ContactMinDistance;

local function smoothStep(p3: number) -- Line: 48
    local math_clamp_ret = math.clamp(p3, 0, 1);

    return math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2);
end;

local function cameraYawAndPitch() -- Line: 53
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera == nil then
        return 0, 0, CFrame.identity;
    end;

    local _, v4, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
    local CFrame_Angles_ret = CFrame.Angles(0, v4, 0);

    return v4, math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1), CFrame_Angles_ret;
end;

local function finiteHorizontalInput(p5: vector) -- Line: 63
    return (p5.X ~= p5.X or (p5.Y ~= p5.Y or (p5.Z ~= p5.Z or (math.abs(p5.X) == (1 / 0) or (math.abs(p5.Y) == (1 / 0) or math.abs(p5.Z) == (1 / 0)))))) and Vector3.new(0, 0, 0) or Vector3.new(p5.X, 0, p5.Z);
end;

local function shortestAngleDelta(p6: number, p7: number) -- Line: 78
    local math_sin_ret = math.sin(p7 - p6);
    local math_cos_ret = math.cos(p7 - p6);

    return math.atan2(math_sin_ret, math_cos_ret);
end;

local function applyAutomaticAirStrafe(p8, p9: number, p10: number, p11: any) -- Line: 82
    -- upvalues: UserInputService (copy)
    local PreferredInput = UserInputService.PreferredInput;

    if PreferredInput ~= Enum.PreferredInput.Touch and PreferredInput ~= Enum.PreferredInput.Gamepad or (p11.OnGround or (p11.MovementMode ~= "Walking" or math.abs(p8.X) > 0.2)) then
        return p8;
    end;

    local math_sin_ret = math.sin(p10 - p9);
    local math_cos_ret = math.cos(p10 - p9);
    local math_atan2_ret = math.atan2(math_sin_ret, math_cos_ret);

    if math.abs(math_atan2_ret) <= 0.00017453292519943296 then
        return p8;
    end;

    return Vector2.new(math_atan2_ret < 0 and 1 or -1, p8.Y);
end;

local function syncCameraPart(p12) -- Line: 109
    local CameraPart = p12.CameraPart;
    local HumanoidRootPart = p12.HumanoidRootPart;

    if not (CameraPart.Parent and HumanoidRootPart.Parent) then
        return;
    end;

    local v13 = Vector3.new(0, 2 + p12.StepCameraOffsetY, 0) + p12.CameraOffset;
    local CameraPartWeld = CameraPart:FindFirstChild("CameraPartWeld");

    if CameraPartWeld == nil or not CameraPartWeld:IsA("Weld") then
        CameraPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(v13);

        return;
    end;

    CameraPartWeld.Part0 = HumanoidRootPart;
    CameraPartWeld.Part1 = CameraPart;
    CameraPartWeld.C0 = CFrame.new(v13);
    CameraPartWeld.C1 = CFrame.identity;
end;

local function approachVisualDuck(p14: number, p15: number, p16: number) -- Line: 127
    local v17 = math.max(p16, 0) * -20;
    local v18 = 1 - math.exp(v17);
    local v19 = p14 + (p15 - p14) * v18;

    if math.abs(p15 - v19) <= 0.001 then
        return p15;
    end;

    return v19;
end;

local function updateCameraOffset(p20: any, p21: number, p22: number?) -- Line: 133
    -- upvalues: RootFrame (copy), syncCameraPart (copy)
    local v23 = p20.IsPlantingBomb and 1 or 0;
    local v24 = p21 / 0.12;

    if p20.VisualPlantCameraAlpha < v23 then
        p20.VisualPlantCameraAlpha = math.min(v23, p20.VisualPlantCameraAlpha + v24);
    else
        p20.VisualPlantCameraAlpha = math.max(v23, p20.VisualPlantCameraAlpha - v24);
    end;

    local math_clamp_ret = math.clamp(p20.MovementState.DuckAmount, 0, 1);
    local VisualDuckAmount = p20.VisualDuckAmount;
    local v25 = math.max(p21, 0) * -20;
    local v26 = 1 - math.exp(v25);
    local v27 = VisualDuckAmount + (math_clamp_ret - VisualDuckAmount) * v26;

    if math.abs(math_clamp_ret - v27) <= 0.001 then
        v27 = math_clamp_ret;
    end;

    p20.VisualDuckAmount = v27;
    local v28 = p20.MovementState.OnGround and 0 or math_clamp_ret;
    local VisualDuckRootAmount = p20.VisualDuckRootAmount;
    local v29 = math.max(p21, 0) * -20;
    local v30 = 1 - math.exp(v29);
    local v31 = VisualDuckRootAmount + (v28 - VisualDuckRootAmount) * v30;

    if math.abs(v28 - v31) > 0.001 then
        v28 = v31;
    end;

    p20.VisualDuckRootAmount = v28;
    local v32 = p22 or RootFrame.getDuckRootVerticalOffset(math_clamp_ret, p20.MovementState.OnGround);
    local getDuckRootVerticalOffset = RootFrame.getDuckRootVerticalOffset;
    local math_clamp_ret2 = math.clamp(p20.VisualDuckRootAmount, 0, 1);
    p20.CameraDuckRootCompensationY = getDuckRootVerticalOffset(math_clamp_ret2 * math_clamp_ret2 * (3 - math_clamp_ret2 * 2), false) - v32;
    local math_clamp_ret3 = math.clamp(p20.VisualDuckAmount, 0, 1);
    local DefaultCameraOffset = p20.DefaultCameraOffset;
    local v33 = DefaultCameraOffset:Lerp(DefaultCameraOffset + p20.CrouchCameraOffset, math_clamp_ret3 * math_clamp_ret3 * (3 - math_clamp_ret3 * 2)) + Vector3.new(0, p20.CameraDuckRootCompensationY, 0);
    local math_clamp_ret4 = math.clamp(p20.VisualPlantCameraAlpha, 0, 1);
    p20.CameraOffset = v33:Lerp(DefaultCameraOffset + Vector3.new(0, -0.9, 0), math_clamp_ret4 * math_clamp_ret4 * (3 - math_clamp_ret4 * 2));
    syncCameraPart(p20);
end;

local function updateStepCameraOffset(p34: any, p35: any, p36: number, p37: number, p38: boolean) -- Line: 161
    -- upvalues: Config (copy), u2 (copy)
    local StepSmoothRootY = p34.StepSmoothRootY;
    local v39 = p34.StepSmoothLastDuckAmount ~= p35.DuckAmount;
    local v40 = p34.StepSmoothWasOnGround ~= p35.OnGround;
    p34.StepSmoothLastDuckAmount = p35.DuckAmount;
    p34.StepSmoothWasOnGround = p35.OnGround;
    local MaxStepHeight = Config.Default.MaxStepHeight;

    if p38 or (typeof(StepSmoothRootY) ~= "number" or (not p35.OnGround or (v40 or (v39 or math.abs(p36 - StepSmoothRootY) > MaxStepHeight * 2)))) then
        p34.StepSmoothRootY = p36;
        p34.StepCameraOffsetY = 0;

        return;
    end;

    if StepSmoothRootY < p36 then
        local math_min_ret = math.min(StepSmoothRootY + u2 * p37, p36);
        StepSmoothRootY = math.max(math_min_ret, p36 - MaxStepHeight);
    elseif p36 < StepSmoothRootY then
        local math_max_ret = math.max(StepSmoothRootY - u2 * p37, p36);
        StepSmoothRootY = math.min(math_max_ret, p36 + MaxStepHeight);
    end;

    p34.StepSmoothRootY = StepSmoothRootY;
    p34.StepCameraOffsetY = StepSmoothRootY - p36;
end;

function u1.new(u41: userdata, p42: userdata) -- Line: 199
    -- upvalues: CharacterResolver (copy), CharacterGeneration (copy), Workspace (copy), State (copy), RootFrame (copy), Janitor (copy), LocalPlayer (copy), CharacterAnimator (copy), Signal (copy), u1 (copy), RuntimeKinematics (copy), updateCameraOffset (copy)
    local CameraPart = CharacterResolver.getCameraPart(u41);
    local v43 = `{u41:GetFullName()} has no CameraPart`;
    local v44 = assert(CameraPart, v43);
    local v45 = CharacterGeneration.Get(u41);
    local v46 = assert(v45, "local shell has no CharacterGeneration");
    local CurrentCamera = Workspace.CurrentCamera;
    local v47, v48;

    if CurrentCamera == nil then
        local _ = CFrame.identity;
        v47 = 0;
        v48 = 0;
    else
        local v49, v50;
        v49, v47, v50 = CurrentCamera.CFrame:ToEulerAnglesYXZ();
        CFrame.Angles(0, v47, 0);
        v48 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
    end;

    local v51 = State.new(RootFrame.rootToSimulationPosition(p42.Position, "Standing"), nil, select(2, p42.CFrame:ToEulerAnglesYXZ()), 0);
    local v52 = {
        Janitor = Janitor.new(),
        Character = u41,
        Player = LocalPlayer,
        Generation = v46,
        HumanoidRootPart = p42,
        CameraPart = v44,
        CharacterAnimator = CharacterAnimator.new(u41),
        MovementState = v51,
        Support = State.noneSupport(),
        GlobalVelocity = Vector3.new(0, 0, 0),
        GlobalDirection = Vector3.new(0, 0, 0),
        LatestMoveVector = Vector2.zero,
        PreviousFrameMoveVector = Vector2.zero,
        CurrentFrameMoveVector = Vector2.zero,
        PreviousFrameLookYaw = v47,
        CurrentFrameLookYaw = v47,
        LastSampledLookYaw = v47,
        CurrentFrameVerticalLook = v48,
        InputFramePrepared = false,
        CrouchInputDown = false,
        JumpInputDown = false,
        JumpPulsePending = false,
        JumpPulseNeedsRelease = false,
        IsWalking = false,
        IsCrouching = false,
        IsClimbing = false,
        IsJumping = false,
        IsPlantingBomb = false,
        OnGround = true,
        DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0),
        CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0),
        CameraOffset = Vector3.new(0, 0, 0),
        VisualDuckAmount = v51.DuckAmount,
        VisualDuckRootAmount = 0,
        CameraDuckRootCompensationY = 0,
        VisualPlantCameraAlpha = 0,
        StepSmoothRootY = p42.Position.Y,
        StepSmoothLastDuckAmount = v51.DuckAmount,
        StepSmoothWasOnGround = v51.OnGround,
        StepCameraOffsetY = 0,
        LastPresentedAt = os.clock(),
        LastExactPresentationTick = nil,
        SnapNextPresentation = true,
        PredictionErrorOffset = Vector3.new(0, 0, 0),
        PredictionErrorElapsedSeconds = 0,
        PreservePredictionPresentation = false,
        PendingPredictionPositionDelta = Vector3.new(0, 0, 0),
        IsDestroyed = false,
        Crouching = Signal.new(),
        Climbing = Signal.new(),
        Walking = Signal.new(),
        Landed = Signal.new()
    };
    local u53 = setmetatable(v52, u1);
    u53.CharacterAnimator.Player = LocalPlayer;
    p42.Anchored = true;
    p42.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p42.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    u53.Janitor:Add(u53.Crouching);
    u53.Janitor:Add(u53.Climbing);
    u53.Janitor:Add(u53.Walking);
    u53.Janitor:Add(u53.Landed);
    u53.Janitor:Add(function() -- Line: 274
        -- upvalues: u53 (copy), RuntimeKinematics (ref), u41 (copy)
        u53.CharacterAnimator:destroy();
        RuntimeKinematics.clear(u41);
    end);
    u53.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("DefaultCameraOffset"):Connect(function() -- Line: 278
        -- upvalues: u53 (copy), LocalPlayer (ref)
        u53.DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0);
    end));
    u53.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("CrouchCameraOffset"):Connect(function() -- Line: 281
        -- upvalues: u53 (copy), LocalPlayer (ref)
        u53.CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0);
    end));
    updateCameraOffset(u53, 0);
    RuntimeKinematics.write(u41, Vector3.new(0, 0, 0), true, p42.Position);

    return u53;
end;

function u1.MatchesGeneration(p54: table, p55: number) -- Line: 290
    -- upvalues: CharacterGeneration (copy)
    local v56 = not p54.IsDestroyed;

    if v56 then
        if p54.Character.Parent == nil or (p54.Character:GetAttribute("Dead") == true or p54.Generation ~= p55) then
            v56 = false;
        else
            v56 = CharacterGeneration.Get(p54.Character) == p55;
        end;
    end;

    return v56;
end;

function u1.MoveFunction(p57: table, p58: vector, p59: boolean) -- Line: 298
    -- upvalues: Workspace (copy), finiteHorizontalInput (copy)
    if p57.IsDestroyed then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;
    local v60;

    if CurrentCamera == nil then
        v60 = CFrame.identity;
    else
        local _, v61, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
        v60 = CFrame.Angles(0, v61, 0);
        math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
    end;

    local v62 = finiteHorizontalInput(p58);

    if not p59 then
        v62 = v60:VectorToObjectSpace(v62);
    end;

    local math_clamp_ret = math.clamp(v62.X, -1, 1);
    local math_clamp_ret2 = math.clamp(v62.Z, -1, 1);
    local Vector3_new_ret = Vector3.new(math_clamp_ret, 0, math_clamp_ret2);
    p57.GlobalDirection = v60:VectorToWorldSpace(Vector3_new_ret);
    p57.LatestMoveVector = Vector2.new(Vector3_new_ret.X, Vector3_new_ret.Z);
end;

function u1.PrepareInputFrame(p63) -- Line: 311
    -- upvalues: Workspace (copy)
    if p63.IsDestroyed then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;
    local v64, v65;

    if CurrentCamera == nil then
        local _ = CFrame.identity;
        v64 = 0;
        v65 = 0;
    else
        local v66, v67;
        v66, v64, v67 = CurrentCamera.CFrame:ToEulerAnglesYXZ();
        CFrame.Angles(0, v64, 0);
        v65 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
    end;

    if p63.InputFramePrepared then
        p63.PreviousFrameMoveVector = p63.CurrentFrameMoveVector;
        p63.CurrentFrameMoveVector = p63.LatestMoveVector;
        p63.PreviousFrameLookYaw = p63.CurrentFrameLookYaw;
        p63.CurrentFrameLookYaw = v64;
        p63.CurrentFrameVerticalLook = v65;

        return;
    end;

    p63.PreviousFrameMoveVector = p63.LatestMoveVector;
    p63.CurrentFrameMoveVector = p63.LatestMoveVector;
    p63.PreviousFrameLookYaw = v64;
    p63.CurrentFrameLookYaw = v64;
    p63.CurrentFrameVerticalLook = v65;
    p63.InputFramePrepared = true;
end;

function u1.ToggleWalkState(p68: table, p69: boolean) -- Line: 332
    if p68.IsWalking == p69 then
        return;
    end;

    p68.IsWalking = p69;
    p68.Walking:Fire(p69);
end;

function u1.ToggleCrouchInput(p70: table, p71: boolean) -- Line: 340
    p70.CrouchInputDown = p71;
end;

function u1.SetJumpInput(p72: table, p73: boolean?) -- Line: 344
    if p73 == nil then
        p72.JumpPulsePending = true;

        return;
    end;

    p72.JumpInputDown = p73;
end;

function u1.PlantBomb(p74) -- Line: 352
    p74.IsPlantingBomb = true;
end;

function u1.CancelBombPlant(p75) -- Line: 356
    p75.IsPlantingBomb = false;
end;

function u1.SampleInput(p76, p77) -- Line: 360
    -- upvalues: applyAutomaticAirStrafe (copy), Buttons (copy), JumpInputSampler (copy)
    if not p76:MatchesGeneration(p77.Mapping.Generation) then
        return nil;
    end;

    local math_clamp_ret = math.clamp(p77.FrameSampleAlpha or 1, 0, 1);
    local PreviousFrameMoveVector = p76.PreviousFrameMoveVector;
    local CurrentFrameMoveVector = p76.CurrentFrameMoveVector;

    if math.sign(PreviousFrameMoveVector.X) ~= math.sign(CurrentFrameMoveVector.X) and true or math.sign(PreviousFrameMoveVector.Y) ~= math.sign(CurrentFrameMoveVector.Y) then
        if math_clamp_ret < 0.5 then
            CurrentFrameMoveVector = PreviousFrameMoveVector;
        end;
    else
        CurrentFrameMoveVector = PreviousFrameMoveVector:Lerp(CurrentFrameMoveVector, math_clamp_ret);
    end;

    local PreviousFrameLookYaw = p76.PreviousFrameLookYaw;
    local PreviousFrameLookYaw2 = p76.PreviousFrameLookYaw;
    local CurrentFrameLookYaw = p76.CurrentFrameLookYaw;
    local math_sin_ret = math.sin(CurrentFrameLookYaw - PreviousFrameLookYaw2);
    local math_cos_ret = math.cos(CurrentFrameLookYaw - PreviousFrameLookYaw2);
    local v78 = PreviousFrameLookYaw + math.atan2(math_sin_ret, math_cos_ret) * math_clamp_ret;
    local v79 = applyAutomaticAirStrafe(CurrentFrameMoveVector, p76.LastSampledLookYaw, v78, p77.State);
    p76.LastSampledLookYaw = v78;
    local v80 = Buttons.with(0, Buttons.Walk, p76.IsWalking);
    local v81 = Buttons.with(v80, Buttons.Duck, p76.CrouchInputDown);
    local v82, v83, v84 = JumpInputSampler.sample(p76.JumpInputDown, p76.JumpPulsePending, p76.JumpPulseNeedsRelease);
    p76.JumpPulsePending = v83;
    p76.JumpPulseNeedsRelease = v84;
    local v85 = Buttons.with(v81, Buttons.Jump, v82);

    return {
        Move = v79,
        LookYaw = v78,
        VerticalLook = p76.CurrentFrameVerticalLook,
        Buttons = v85
    };
end;

function u1.Present(p86, p87, p88, p89, p90) -- Line: 392
    -- upvalues: RootFrame (copy), PredictionErrorSmoother (copy), updateStepCameraOffset (copy), PlayerContacts (copy), RuntimeKinematics (copy), updateCameraOffset (copy)
    local Mapping = p89.Mapping;
    local v91;

    if Mapping == nil then
        v91 = p86.Generation;
    else
        v91 = Mapping.Generation;
    end;

    if not p86:MatchesGeneration(v91) then
        return;
    end;

    local os_clock_ret = os.clock();
    local math_clamp_ret = math.clamp(os_clock_ret - p86.LastPresentedAt, 0, 0.1);
    p86.LastPresentedAt = os_clock_ret;
    local v92 = RootFrame.cframe(p87);
    local v93 = RootFrame.cframe(p90 or p87);
    local SnapNextPresentation = p86.SnapNextPresentation;

    if SnapNextPresentation then
        p86.LastExactPresentationTick = p89.ServerTick;
    end;

    local v94;

    if SnapNextPresentation then
        v94 = SnapNextPresentation;
    elseif p86.LastExactPresentationTick == nil then
        v94 = false;
    else
        v94 = p89.ServerTick == p86.LastExactPresentationTick;
    end;

    local math_clamp_ret2 = math.clamp(p89.TickFraction or 0, 0, 1);
    local v95;

    if v94 then
        v95 = v92;
    else
        v95 = v93:Lerp(v92, math_clamp_ret2);
    end;

    if not v94 then
        p86.LastExactPresentationTick = nil;
    end;

    p86.SnapNextPresentation = false;
    local v96 = p86.PreservePredictionPresentation == true;
    p86.PreservePredictionPresentation = false;
    local PendingPredictionPositionDelta = p86.PendingPredictionPositionDelta;
    p86.PendingPredictionPositionDelta = Vector3.new(0, 0, 0);

    if v94 then
        p86.PredictionErrorOffset = Vector3.new(0, 0, 0);
        p86.PredictionErrorElapsedSeconds = 0;
    elseif v96 then
        local v97 = PredictionErrorSmoother.remainingOffset(p86.PredictionErrorOffset, p86.PredictionErrorElapsedSeconds) - PendingPredictionPositionDelta;
        p86.PredictionErrorOffset = PredictionErrorSmoother.clampOffset(v97);
        p86.PredictionErrorElapsedSeconds = 0;
    end;

    local v98 = PredictionErrorSmoother.remainingOffset(p86.PredictionErrorOffset, p86.PredictionErrorElapsedSeconds);

    if not v94 and v98.Magnitude > PredictionErrorSmoother.Epsilon then
        v95 = v95 + v98;
        p86.PredictionErrorElapsedSeconds = p86.PredictionErrorElapsedSeconds + math_clamp_ret;

        if PredictionErrorSmoother.remainingOffset(p86.PredictionErrorOffset, p86.PredictionErrorElapsedSeconds).Magnitude <= PredictionErrorSmoother.Epsilon then
            p86.PredictionErrorOffset = Vector3.new(0, 0, 0);
            p86.PredictionErrorElapsedSeconds = 0;
        end;
    end;

    updateStepCameraOffset(p86, p87, v95.Position.Y, math_clamp_ret, SnapNextPresentation);
    p86.HumanoidRootPart.CFrame = v95;
    p86.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p86.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    local v99 = PlayerContacts.toWorldVelocity(p87.Velocity, p88);
    p86.MovementState = p87;
    p86.Support = p88;
    p86.GlobalVelocity = Vector3.new(v99.X, 0, v99.Z);
    p86.OnGround = p87.OnGround;
    p86.IsJumping = not p87.OnGround and v99.Y > 0;
    local v100 = p87.DuckAmount > 0.5;

    if v100 ~= p86.IsCrouching then
        p86.IsCrouching = v100;
        p86.Crouching:Fire(v100);
    end;

    local v101 = p87.MovementMode == "Ladder";

    if v101 ~= p86.IsClimbing then
        p86.IsClimbing = v101;
        p86.Climbing:Fire(v101);
    end;

    RuntimeKinematics.write(p86.Character, v99, p87.OnGround, v92.Position);
    p86.CharacterAnimator:updateLocomotion(v99, p87.OnGround, v100, v101);
    local v102 = p90 or p87;
    local DuckRootVerticalOffset = RootFrame.getDuckRootVerticalOffset(v102.DuckAmount, v102.OnGround);
    local DuckRootVerticalOffset2 = RootFrame.getDuckRootVerticalOffset(p87.DuckAmount, p87.OnGround);

    if not v94 then
        DuckRootVerticalOffset2 = DuckRootVerticalOffset + (DuckRootVerticalOffset2 - DuckRootVerticalOffset) * math_clamp_ret2;
    end;

    updateCameraOffset(p86, math_clamp_ret, DuckRootVerticalOffset2);
end;

function u1.OnStepEvents(p103, p104) -- Line: 485
    if p104.Jumped then
        p103.CharacterAnimator:noteJumpEvent();
    end;

    if p104.Landed then
        local v105 = typeof(p104.ImpactVelocityY) ~= "number" and 0 or p104.ImpactVelocityY;
        p103.Landed:Fire(math.max(0, -v105), p103.MovementState.DuckAmount);
    end;
end;

function u1.OnReconciled(p106, p107) -- Line: 495
    -- upvalues: PredictionErrorSmoother (copy)
    if not PredictionErrorSmoother.isHardSnapCorrection(p107) then
        if typeof(p107.PresentationPositionDelta) == "Vector3" and p107.PresentationPositionDelta.Magnitude > PredictionErrorSmoother.Epsilon then
            p106.PendingPredictionPositionDelta = p106.PendingPredictionPositionDelta + p107.PresentationPositionDelta;
            p106.PreservePredictionPresentation = true;
        end;

        return;
    end;

    p106.SnapNextPresentation = true;
    p106.PreservePredictionPresentation = false;
    p106.PendingPredictionPositionDelta = Vector3.new(0, 0, 0);
    p106.PredictionErrorOffset = Vector3.new(0, 0, 0);
    p106.PredictionErrorElapsedSeconds = 0;
    p106.StepSmoothRootY = nil;
    p106.StepCameraOffsetY = 0;
end;

function u1.OnPlayerContactCorrection(p108: table, p109: number, p110: vector) -- Line: 513
    -- upvalues: ContactMinDistance (copy)
    if ContactMinDistance < p109 then
        p108.PreservePredictionPresentation = true;
        p108.PendingPredictionPositionDelta = p108.PendingPredictionPositionDelta + p110;
    end;
end;

function u1.Destroy(p111) -- Line: 521
    if p111.IsDestroyed then
        return;
    end;

    p111.IsDestroyed = true;
    p111.Janitor:Destroy();
end;

return u1;