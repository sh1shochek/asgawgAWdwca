-- Character (ModuleScript)
-- full path: ReplicatedStorage.Classes.Character

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
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
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
local Vector3_new_ret = Vector3.new(0, -SurvivalDowned.EYE_DROP, 0);
local u2 = 150 * Config.Default.HammerUnitToStud;
local ContactMinDistance = PredictionErrorSmoother.ContactMinDistance;

local function smoothStep(p3: number) -- Line: 53
    local math_clamp_ret = math.clamp(p3, 0, 1);

    return math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2);
end;

local function cameraYawAndPitch() -- Line: 58
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera == nil then
        return 0, 0, CFrame.identity;
    end;

    local _, v4, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
    local CFrame_Angles_ret = CFrame.Angles(0, v4, 0);

    return v4, math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1), CFrame_Angles_ret;
end;

local function finiteHorizontalInput(p5: vector) -- Line: 68
    return (p5.X ~= p5.X or (p5.Y ~= p5.Y or (p5.Z ~= p5.Z or (math.abs(p5.X) == (1 / 0) or (math.abs(p5.Y) == (1 / 0) or math.abs(p5.Z) == (1 / 0)))))) and Vector3.new(0, 0, 0) or Vector3.new(p5.X, 0, p5.Z);
end;

local function shortestAngleDelta(p6: number, p7: number) -- Line: 83
    local math_sin_ret = math.sin(p7 - p6);
    local math_cos_ret = math.cos(p7 - p6);

    return math.atan2(math_sin_ret, math_cos_ret);
end;

local function applyAutomaticAirStrafe(p8, p9: number, p10: number, p11: any) -- Line: 87
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

local function syncCameraPart(p12) -- Line: 114
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

local function approachVisualDuck(p14: number, p15: number, p16: number) -- Line: 132
    local v17 = math.max(p16, 0) * -20;
    local v18 = 1 - math.exp(v17);
    local v19 = p14 + (p15 - p14) * v18;

    if math.abs(p15 - v19) <= 0.001 then
        return p15;
    end;

    return v19;
end;

local function updateCameraOffset(p20: any, p21: number, p22: number?) -- Line: 138
    -- upvalues: RootFrame (copy), SurvivalDowned (copy), LocalPlayer (copy), Vector3_new_ret (copy), syncCameraPart (copy)
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
    local v33 = SurvivalDowned.IsDowned(LocalPlayer) and 1 or 0;
    local v34 = p21 / 0.35;

    if p20.VisualDownedCameraAlpha < v33 then
        p20.VisualDownedCameraAlpha = math.min(v33, p20.VisualDownedCameraAlpha + v34);
    else
        p20.VisualDownedCameraAlpha = math.max(v33, p20.VisualDownedCameraAlpha - v34);
    end;

    local math_clamp_ret3 = math.clamp(p20.VisualDuckAmount, 0, 1);
    local DefaultCameraOffset = p20.DefaultCameraOffset;
    local v35 = DefaultCameraOffset:Lerp(DefaultCameraOffset + p20.CrouchCameraOffset, math_clamp_ret3 * math_clamp_ret3 * (3 - math_clamp_ret3 * 2)) + Vector3.new(0, p20.CameraDuckRootCompensationY, 0);
    local math_clamp_ret4 = math.clamp(p20.VisualPlantCameraAlpha, 0, 1);
    local v36 = v35:Lerp(DefaultCameraOffset + Vector3.new(0, -0.9, 0), math_clamp_ret4 * math_clamp_ret4 * (3 - math_clamp_ret4 * 2));
    local math_clamp_ret5 = math.clamp(p20.VisualDownedCameraAlpha, 0, 1);
    p20.CameraOffset = v36:Lerp(DefaultCameraOffset + Vector3_new_ret, math_clamp_ret5 * math_clamp_ret5 * (3 - math_clamp_ret5 * 2));
    syncCameraPart(p20);
end;

local function updateStepCameraOffset(p37: any, p38: any, p39: number, p40: number, p41: boolean) -- Line: 175
    -- upvalues: Config (copy), u2 (copy)
    local StepSmoothRootY = p37.StepSmoothRootY;
    local v42 = p37.StepSmoothLastDuckAmount ~= p38.DuckAmount;
    local v43 = p37.StepSmoothWasOnGround ~= p38.OnGround;
    p37.StepSmoothLastDuckAmount = p38.DuckAmount;
    p37.StepSmoothWasOnGround = p38.OnGround;
    local MaxStepHeight = Config.Default.MaxStepHeight;

    if p41 or (typeof(StepSmoothRootY) ~= "number" or (not p38.OnGround or (v43 or (v42 or math.abs(p39 - StepSmoothRootY) > MaxStepHeight * 2)))) then
        p37.StepSmoothRootY = p39;
        p37.StepCameraOffsetY = 0;

        return;
    end;

    if StepSmoothRootY < p39 then
        local math_min_ret = math.min(StepSmoothRootY + u2 * p40, p39);
        StepSmoothRootY = math.max(math_min_ret, p39 - MaxStepHeight);
    elseif p39 < StepSmoothRootY then
        local math_max_ret = math.max(StepSmoothRootY - u2 * p40, p39);
        StepSmoothRootY = math.min(math_max_ret, p39 + MaxStepHeight);
    end;

    p37.StepSmoothRootY = StepSmoothRootY;
    p37.StepCameraOffsetY = StepSmoothRootY - p39;
end;

function u1.new(u44: userdata, p45: userdata) -- Line: 213
    -- upvalues: CharacterResolver (copy), CharacterGeneration (copy), Workspace (copy), State (copy), RootFrame (copy), Janitor (copy), LocalPlayer (copy), CharacterAnimator (copy), Signal (copy), u1 (copy), RuntimeKinematics (copy), updateCameraOffset (copy)
    local CameraPart = CharacterResolver.getCameraPart(u44);
    local v46 = `{u44:GetFullName()} has no CameraPart`;
    local v47 = assert(CameraPart, v46);
    local v48 = CharacterGeneration.Get(u44);
    local v49 = assert(v48, "local shell has no CharacterGeneration");
    local CurrentCamera = Workspace.CurrentCamera;
    local v50, v51;

    if CurrentCamera == nil then
        local _ = CFrame.identity;
        v50 = 0;
        v51 = 0;
    else
        local v52, v53;
        v52, v51, v53 = CurrentCamera.CFrame:ToEulerAnglesYXZ();
        CFrame.Angles(0, v51, 0);
        v50 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
    end;

    local v54 = State.new(RootFrame.rootToSimulationPosition(p45.Position, "Standing"), nil, select(2, p45.CFrame:ToEulerAnglesYXZ()), 0);
    local v55 = {
        Janitor = Janitor.new(),
        Character = u44,
        Player = LocalPlayer,
        Generation = v49,
        HumanoidRootPart = p45,
        CameraPart = v47,
        CharacterAnimator = CharacterAnimator.new(u44),
        MovementState = v54,
        Support = State.noneSupport(),
        GlobalVelocity = Vector3.new(0, 0, 0),
        GlobalDirection = Vector3.new(0, 0, 0),
        LatestMoveVector = Vector2.zero,
        PreviousFrameMoveVector = Vector2.zero,
        CurrentFrameMoveVector = Vector2.zero,
        PreviousFrameLookYaw = v51,
        CurrentFrameLookYaw = v51,
        LastSampledLookYaw = v51,
        CurrentFrameVerticalLook = v50,
        InputFramePrepared = false,
        CrouchInputDown = false,
        JumpInputDown = false,
        JumpPulsePending = false,
        JumpPulseNeedsRelease = false,
        IsWalking = false,
        IsSprinting = false,
        IsCrouching = false,
        IsClimbing = false,
        IsJumping = false,
        IsPlantingBomb = false,
        OnGround = true,
        DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0),
        CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0),
        CameraOffset = Vector3.new(0, 0, 0),
        VisualDuckAmount = v54.DuckAmount,
        VisualDuckRootAmount = 0,
        CameraDuckRootCompensationY = 0,
        VisualPlantCameraAlpha = 0,
        VisualDownedCameraAlpha = 0,
        StepSmoothRootY = p45.Position.Y,
        StepSmoothLastDuckAmount = v54.DuckAmount,
        StepSmoothWasOnGround = v54.OnGround,
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
    local u56 = setmetatable(v55, u1);
    u56.CharacterAnimator.Player = LocalPlayer;
    p45.Anchored = true;
    p45.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p45.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    u56.Janitor:Add(u56.Crouching);
    u56.Janitor:Add(u56.Climbing);
    u56.Janitor:Add(u56.Walking);
    u56.Janitor:Add(u56.Landed);
    u56.Janitor:Add(function() -- Line: 290
        -- upvalues: u56 (copy), RuntimeKinematics (ref), u44 (copy)
        u56.CharacterAnimator:destroy();
        RuntimeKinematics.clear(u44);
    end);
    u56.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("DefaultCameraOffset"):Connect(function() -- Line: 294
        -- upvalues: u56 (copy), LocalPlayer (ref)
        u56.DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0);
    end));
    u56.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("CrouchCameraOffset"):Connect(function() -- Line: 297
        -- upvalues: u56 (copy), LocalPlayer (ref)
        u56.CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0);
    end));
    updateCameraOffset(u56, 0);
    RuntimeKinematics.write(u44, Vector3.new(0, 0, 0), true, p45.Position);

    return u56;
end;

function u1.MatchesGeneration(p57: table, p58: number) -- Line: 306
    -- upvalues: CharacterGeneration (copy)
    local v59 = not p57.IsDestroyed;

    if v59 then
        if p57.Character.Parent == nil or (p57.Character:GetAttribute("Dead") == true or p57.Generation ~= p58) then
            v59 = false;
        else
            v59 = CharacterGeneration.Get(p57.Character) == p58;
        end;
    end;

    return v59;
end;

function u1.MoveFunction(p60: table, p61: vector, p62: boolean) -- Line: 314
    -- upvalues: Workspace (copy), finiteHorizontalInput (copy)
    if p60.IsDestroyed then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;
    local v63;

    if CurrentCamera == nil then
        v63 = CFrame.identity;
    else
        local _, v64, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
        v63 = CFrame.Angles(0, v64, 0);
        math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
    end;

    local v65 = finiteHorizontalInput(p61);

    if not p62 then
        v65 = v63:VectorToObjectSpace(v65);
    end;

    local math_clamp_ret = math.clamp(v65.X, -1, 1);
    local math_clamp_ret2 = math.clamp(v65.Z, -1, 1);
    local Vector3_new_ret2 = Vector3.new(math_clamp_ret, 0, math_clamp_ret2);
    p60.GlobalDirection = v63:VectorToWorldSpace(Vector3_new_ret2);
    p60.LatestMoveVector = Vector2.new(Vector3_new_ret2.X, Vector3_new_ret2.Z);
end;

function u1.PrepareInputFrame(p66) -- Line: 327
    -- upvalues: Workspace (copy)
    if p66.IsDestroyed then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;
    local v67, v68;

    if CurrentCamera == nil then
        local _ = CFrame.identity;
        v67 = 0;
        v68 = 0;
    else
        local v69, v70;
        v69, v67, v70 = CurrentCamera.CFrame:ToEulerAnglesYXZ();
        CFrame.Angles(0, v67, 0);
        v68 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1);
    end;

    if p66.InputFramePrepared then
        p66.PreviousFrameMoveVector = p66.CurrentFrameMoveVector;
        p66.CurrentFrameMoveVector = p66.LatestMoveVector;
        p66.PreviousFrameLookYaw = p66.CurrentFrameLookYaw;
        p66.CurrentFrameLookYaw = v67;
        p66.CurrentFrameVerticalLook = v68;

        return;
    end;

    p66.PreviousFrameMoveVector = p66.LatestMoveVector;
    p66.CurrentFrameMoveVector = p66.LatestMoveVector;
    p66.PreviousFrameLookYaw = v67;
    p66.CurrentFrameLookYaw = v67;
    p66.CurrentFrameVerticalLook = v68;
    p66.InputFramePrepared = true;
end;

function u1.ToggleWalkState(p71: table, p72: boolean) -- Line: 348
    if p71.IsWalking == p72 then
        return;
    end;

    p71.IsWalking = p72;
    p71.Walking:Fire(p72);
end;

function u1.ToggleSprintState(p73: table, p74: boolean) -- Line: 356
    p73.IsSprinting = p74;
end;

function u1.ToggleCrouchInput(p75: table, p76: boolean) -- Line: 360
    p75.CrouchInputDown = p76;
end;

function u1.SetJumpInput(p77: table, p78: boolean?) -- Line: 364
    if p78 == nil then
        p77.JumpPulsePending = true;

        return;
    end;

    p77.JumpInputDown = p78;
end;

function u1.PlantBomb(p79) -- Line: 372
    p79.IsPlantingBomb = true;
end;

function u1.CancelBombPlant(p80) -- Line: 376
    p80.IsPlantingBomb = false;
end;

function u1.SampleInput(p81, p82) -- Line: 380
    -- upvalues: applyAutomaticAirStrafe (copy), SurvivalDowned (copy), LocalPlayer (copy), Buttons (copy), IsSurvivalMode (copy), JumpInputSampler (copy)
    if not p81:MatchesGeneration(p82.Mapping.Generation) then
        return nil;
    end;

    local math_clamp_ret = math.clamp(p82.FrameSampleAlpha or 1, 0, 1);
    local PreviousFrameMoveVector = p81.PreviousFrameMoveVector;
    local CurrentFrameMoveVector = p81.CurrentFrameMoveVector;

    if math.sign(PreviousFrameMoveVector.X) ~= math.sign(CurrentFrameMoveVector.X) and true or math.sign(PreviousFrameMoveVector.Y) ~= math.sign(CurrentFrameMoveVector.Y) then
        if math_clamp_ret < 0.5 then
            CurrentFrameMoveVector = PreviousFrameMoveVector;
        end;
    else
        CurrentFrameMoveVector = PreviousFrameMoveVector:Lerp(CurrentFrameMoveVector, math_clamp_ret);
    end;

    local PreviousFrameLookYaw = p81.PreviousFrameLookYaw;
    local PreviousFrameLookYaw2 = p81.PreviousFrameLookYaw;
    local CurrentFrameLookYaw = p81.CurrentFrameLookYaw;
    local math_sin_ret = math.sin(CurrentFrameLookYaw - PreviousFrameLookYaw2);
    local math_cos_ret = math.cos(CurrentFrameLookYaw - PreviousFrameLookYaw2);
    local v83 = PreviousFrameLookYaw + math.atan2(math_sin_ret, math_cos_ret) * math_clamp_ret;
    local v84 = applyAutomaticAirStrafe(CurrentFrameMoveVector, p81.LastSampledLookYaw, v83, p82.State);
    p81.LastSampledLookYaw = v83;
    local v85 = SurvivalDowned.IsDowned(LocalPlayer);
    local v86 = Buttons.with(0, Buttons.Walk, p81.IsWalking);
    local with = Buttons.with;
    local Sprint = Buttons.Sprint;
    local v87;

    if p81.IsSprinting == true then
        v87 = not v85 and IsSurvivalMode();
    else
        v87 = false;
    end;

    local v88 = with(v86, Sprint, v87);
    local v89;

    if p81.CrouchInputDown == true then
        v89 = not v85;
    else
        v89 = false;
    end;

    local v90 = Buttons.with(v88, Buttons.Duck, v89);
    local v91, v92, v93 = JumpInputSampler.sample(p81.JumpInputDown, p81.JumpPulsePending, p81.JumpPulseNeedsRelease);
    p81.JumpPulsePending = v92;
    p81.JumpPulseNeedsRelease = v93;
    local v94;

    if v91 == true then
        v94 = not v85;
    else
        v94 = false;
    end;

    local v95 = Buttons.with(v90, Buttons.Jump, v94);

    return {
        Move = v84,
        LookYaw = v83,
        VerticalLook = p81.CurrentFrameVerticalLook,
        Buttons = v95
    };
end;

function u1.Present(p96, p97, p98, p99, p100) -- Line: 416
    -- upvalues: RootFrame (copy), PredictionErrorSmoother (copy), updateStepCameraOffset (copy), PlayerContacts (copy), RuntimeKinematics (copy), updateCameraOffset (copy)
    local Mapping = p99.Mapping;
    local v101;

    if Mapping == nil then
        v101 = p96.Generation;
    else
        v101 = Mapping.Generation;
    end;

    if not p96:MatchesGeneration(v101) then
        return;
    end;

    local os_clock_ret = os.clock();
    local math_clamp_ret = math.clamp(os_clock_ret - p96.LastPresentedAt, 0, 0.1);
    p96.LastPresentedAt = os_clock_ret;
    local v102 = RootFrame.cframe(p97);
    local v103 = RootFrame.cframe(p100 or p97);
    local SnapNextPresentation = p96.SnapNextPresentation;

    if SnapNextPresentation then
        p96.LastExactPresentationTick = p99.ServerTick;
    end;

    local v104;

    if SnapNextPresentation then
        v104 = SnapNextPresentation;
    elseif p96.LastExactPresentationTick == nil then
        v104 = false;
    else
        v104 = p99.ServerTick == p96.LastExactPresentationTick;
    end;

    local math_clamp_ret2 = math.clamp(p99.TickFraction or 0, 0, 1);
    local v105;

    if v104 then
        v105 = v102;
    else
        v105 = v103:Lerp(v102, math_clamp_ret2);
    end;

    if not v104 then
        p96.LastExactPresentationTick = nil;
    end;

    p96.SnapNextPresentation = false;
    local v106 = p96.PreservePredictionPresentation == true;
    p96.PreservePredictionPresentation = false;
    local PendingPredictionPositionDelta = p96.PendingPredictionPositionDelta;
    p96.PendingPredictionPositionDelta = Vector3.new(0, 0, 0);

    if v104 then
        p96.PredictionErrorOffset = Vector3.new(0, 0, 0);
        p96.PredictionErrorElapsedSeconds = 0;
    elseif v106 then
        local v107 = PredictionErrorSmoother.remainingOffset(p96.PredictionErrorOffset, p96.PredictionErrorElapsedSeconds) - PendingPredictionPositionDelta;
        p96.PredictionErrorOffset = PredictionErrorSmoother.clampOffset(v107);
        p96.PredictionErrorElapsedSeconds = 0;
    end;

    local v108 = PredictionErrorSmoother.remainingOffset(p96.PredictionErrorOffset, p96.PredictionErrorElapsedSeconds);

    if not v104 and v108.Magnitude > PredictionErrorSmoother.Epsilon then
        v105 = v105 + v108;
        p96.PredictionErrorElapsedSeconds = p96.PredictionErrorElapsedSeconds + math_clamp_ret;

        if PredictionErrorSmoother.remainingOffset(p96.PredictionErrorOffset, p96.PredictionErrorElapsedSeconds).Magnitude <= PredictionErrorSmoother.Epsilon then
            p96.PredictionErrorOffset = Vector3.new(0, 0, 0);
            p96.PredictionErrorElapsedSeconds = 0;
        end;
    end;

    updateStepCameraOffset(p96, p97, v105.Position.Y, math_clamp_ret, SnapNextPresentation);
    p96.HumanoidRootPart.CFrame = v105;
    p96.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p96.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    local v109 = PlayerContacts.toWorldVelocity(p97.Velocity, p98);
    p96.MovementState = p97;
    p96.Support = p98;
    p96.GlobalVelocity = Vector3.new(v109.X, 0, v109.Z);
    p96.OnGround = p97.OnGround;
    p96.IsJumping = not p97.OnGround and v109.Y > 0;
    local v110 = p97.DuckAmount > 0.5;

    if v110 ~= p96.IsCrouching then
        p96.IsCrouching = v110;
        p96.Crouching:Fire(v110);
    end;

    local v111 = p97.MovementMode == "Ladder";

    if v111 ~= p96.IsClimbing then
        p96.IsClimbing = v111;
        p96.Climbing:Fire(v111);
    end;

    RuntimeKinematics.write(p96.Character, v109, p97.OnGround, v102.Position);
    p96.CharacterAnimator:updateLocomotion(v109, p97.OnGround, v110, v111);
    local v112 = p100 or p97;
    local DuckRootVerticalOffset = RootFrame.getDuckRootVerticalOffset(v112.DuckAmount, v112.OnGround);
    local DuckRootVerticalOffset2 = RootFrame.getDuckRootVerticalOffset(p97.DuckAmount, p97.OnGround);

    if not v104 then
        DuckRootVerticalOffset2 = DuckRootVerticalOffset + (DuckRootVerticalOffset2 - DuckRootVerticalOffset) * math_clamp_ret2;
    end;

    updateCameraOffset(p96, math_clamp_ret, DuckRootVerticalOffset2);
end;

function u1.OnStepEvents(p113, p114) -- Line: 509
    if p114.Jumped then
        p113.CharacterAnimator:noteJumpEvent();
    end;

    if p114.Landed then
        local v115 = typeof(p114.ImpactVelocityY) ~= "number" and 0 or p114.ImpactVelocityY;
        p113.Landed:Fire(math.max(0, -v115), p113.MovementState.DuckAmount);
    end;
end;

function u1.OnReconciled(p116, p117) -- Line: 519
    -- upvalues: PredictionErrorSmoother (copy)
    if not PredictionErrorSmoother.isHardSnapCorrection(p117) then
        if typeof(p117.PresentationPositionDelta) == "Vector3" and p117.PresentationPositionDelta.Magnitude > PredictionErrorSmoother.Epsilon then
            p116.PendingPredictionPositionDelta = p116.PendingPredictionPositionDelta + p117.PresentationPositionDelta;
            p116.PreservePredictionPresentation = true;
        end;

        return;
    end;

    p116.SnapNextPresentation = true;
    p116.PreservePredictionPresentation = false;
    p116.PendingPredictionPositionDelta = Vector3.new(0, 0, 0);
    p116.PredictionErrorOffset = Vector3.new(0, 0, 0);
    p116.PredictionErrorElapsedSeconds = 0;
    p116.StepSmoothRootY = nil;
    p116.StepCameraOffsetY = 0;
end;

function u1.OnPlayerContactCorrection(p118: table, p119: number, p120: vector) -- Line: 537
    -- upvalues: ContactMinDistance (copy)
    if ContactMinDistance < p119 then
        p118.PreservePredictionPresentation = true;
        p118.PendingPredictionPositionDelta = p118.PendingPredictionPositionDelta + p120;
    end;
end;

function u1.Destroy(p121) -- Line: 545
    if p121.IsDestroyed then
        return;
    end;

    p121.IsDestroyed = true;
    p121.Janitor:Destroy();
end;

return u1;