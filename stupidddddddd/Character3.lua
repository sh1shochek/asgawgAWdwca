-- ReplicatedStorage.Classes.Character
-- Script path: ReplicatedStorage.Classes.Character
-- Decompile time: 12.13 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local MovementV2 = ReplicatedStorage.MovementV2
local Buttons = require(MovementV2.Buttons)
local JumpInputSampler = require(MovementV2.JumpInputSampler)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local PlayerContacts = require(MovementV2.Simulation.PlayerContacts)
local PredictionErrorSmoother = require(MovementV2.Client.PredictionErrorSmoother)
local Config = require(MovementV2.Simulation.Config)
local State = require(MovementV2.Simulation.State)
local RootFrame = require(MovementV2.RootFrame)
local RuntimeKinematics = require(MovementV2.RuntimeKinematics)
local Signal = require(ReplicatedStorage.Packages.Signal)
local CharacterAnimator = require(script.Classes.CharacterAnimator)
local LocalPlayer = Players.LocalPlayer
local u73 = {}
u73.__index = u73
local u77 = 150 * Config.Default.HammerUnitToStud
local ContactMinDistance = PredictionErrorSmoother.ContactMinDistance

local function smoothStep(a1) -- Line: 48 -- types: a1: number
    local v1 = math.clamp(a1, 0, 1)
    return v1 * v1 * (3 - v1 * 2)
end

local function cameraYawAndPitch() -- Line: 53 -- upvalues: Workspace (val)
    local v1
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera == nil then
        return 0, 0, CFrame.identity
    end
    _, v1 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
    local v2 = CFrame.Angles(0, v1, 0)
    return v1, (math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1)), v2
end

local function finiteHorizontalInput(a1) -- Line: 63 -- types: a1: vector
    if a1.X == a1.X
        and a1.Y == a1.Y
        and a1.Z == a1.Z
        and math.abs(a1.X) ~= (1 / 0)
        and math.abs(a1.Y) ~= (1 / 0)
        and math.abs(a1.Z) ~= (1 / 0) then
        return (Vector3.new(a1.X, 0, a1.Z))
    end
    return (Vector3.new(0, 0, 0))
end

local function shortestAngleDelta(a1, a2) -- Line: 78 -- types: a1: number, a2: number
    return (math.atan2(math.sin(a2 - a1), (math.cos(a2 - a1))))
end

local function applyAutomaticAirStrafe(a1, a2, a3, a4) -- Line: 82
    -- upvalues: UserInputService (val)
    local PreferredInput = UserInputService.PreferredInput
    local v1 = true
    if PreferredInput ~= Enum.PreferredInput.Touch then
        v1 = PreferredInput == Enum.PreferredInput.Gamepad
    end
    if v1 and not a4.OnGround and a4.MovementMode == "Walking" then
        local v2 = math.abs(a1.X)
        if not (v2 > 0.2) then
            v2 = math.atan2(math.sin(a3 - a2), (math.cos(a3 - a2)))
            if (math.abs(v2)) <= 0.00017453292519943296 then
                return a1
            end
            return Vector2.new(if not (v2 < 0) then -1 else 1, a1.Y)
        end
    end
    return a1
end

local function syncCameraPart(a1) -- Line: 109
    local CameraPart = a1.CameraPart
    local HumanoidRootPart = a1.HumanoidRootPart
    if CameraPart.Parent and HumanoidRootPart.Parent then
        local v1 = (Vector3.new(0, 2 + a1.StepCameraOffsetY, 0)) + a1.CameraOffset
        local CameraPartWeld = CameraPart:FindFirstChild("CameraPartWeld")
        if CameraPartWeld ~= nil and CameraPartWeld:IsA("Weld") then
            CameraPartWeld.Part0 = HumanoidRootPart
            CameraPartWeld.Part1 = CameraPart
            CameraPartWeld.C0 = CFrame.new(v1)
            CameraPartWeld.C1 = CFrame.identity
            return
        end
        CameraPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(v1)
        return
    end
end

local function approachVisualDuck(a1, a2, a3) -- Line: 127 -- types: a1: number, a2: number, a3: number
    local v1 = 1 - (math.exp((math.max(a3, 0)) * -20))
    local v2 = a1 + (a2 - a1) * v1
    if (math.abs(a2 - v2)) <= 0.001 then
        return a2
    end
    return v2
end

local function updateCameraOffset(a1, a2, a3) -- Line: 133
    -- upvalues: RootFrame (val), syncCameraPart (val)
    local v1 = if not a1.IsPlantingBomb then 0 else 1
    local v2 = a2 / 0.12
    if not (a1.VisualPlantCameraAlpha < v1) then
        a1.VisualPlantCameraAlpha = math.max(v1, a1.VisualPlantCameraAlpha - v2)
    else
        a1.VisualPlantCameraAlpha = math.min(v1, a1.VisualPlantCameraAlpha + v2)
    end
    local v3 = math.clamp(a1.MovementState.DuckAmount, 0, 1)
    local VisualDuckAmount = a1.VisualDuckAmount
    local v4 = 1 - (math.exp((math.max(a2, 0)) * -20))
    local v5 = VisualDuckAmount + (v3 - VisualDuckAmount) * v4
    a1.VisualDuckAmount = if not ((math.abs(v3 - v5)) <= 0.001) then v5 else v3
    local v6 = if not a1.MovementState.OnGround then v3 else 0
    local VisualDuckRootAmount = a1.VisualDuckRootAmount
    v5 = 1 - (math.exp((math.max(a2, 0)) * -20))
    local v7 = VisualDuckRootAmount + (v6 - VisualDuckRootAmount) * v5
    a1.VisualDuckRootAmount = if not ((math.abs(v6 - v7)) <= 0.001) then v7 else v6
    local v8 = a3 or RootFrame.getDuckRootVerticalOffset(v3, a1.MovementState.OnGround)
    local getDuckRootVerticalOffset = RootFrame.getDuckRootVerticalOffset
    local v9 = math.clamp(a1.VisualDuckRootAmount, 0, 1)
    a1.CameraDuckRootCompensationY = getDuckRootVerticalOffset(v9 * v9 * (3 - v9 * 2), false) - v8
    v9 = math.clamp(a1.VisualDuckAmount, 0, 1)
    v5 = v9 * v9 * (3 - v9 * 2)
    local DefaultCameraOffset = a1.DefaultCameraOffset
    local v10 = (DefaultCameraOffset:Lerp(DefaultCameraOffset + a1.CrouchCameraOffset, v5)) + (Vector3.new(0, a1.CameraDuckRootCompensationY, 0))
    local v11 = DefaultCameraOffset + Vector3.new(0, -0.8999999761581421, 0)
    local v12 = math.clamp(a1.VisualPlantCameraAlpha, 0, 1)
    a1.CameraOffset = v10:Lerp(v11, v12 * v12 * (3 - v12 * 2))
    syncCameraPart(a1)
end

local function updateStepCameraOffset(a1, a2, a3, a4, a5) -- Line: 161
    -- upvalues: Config (val), u77 (val)
    local StepSmoothRootY = a1.StepSmoothRootY
    local v1 = a1.StepSmoothLastDuckAmount ~= a2.DuckAmount
    local v2 = a1.StepSmoothWasOnGround ~= a2.OnGround
    a1.StepSmoothLastDuckAmount = a2.DuckAmount
    a1.StepSmoothWasOnGround = a2.OnGround
    local MaxStepHeight = Config.Default.MaxStepHeight
    if not a5 and typeof(StepSmoothRootY) == "number" and a2.OnGround and not v2 and not v1 then
        local v3 = math.abs(a3 - StepSmoothRootY)
        if not (MaxStepHeight * 2 < v3) then
            if StepSmoothRootY < a3 then
                StepSmoothRootY = math.max(math.min(StepSmoothRootY + u77 * a4, a3), a3 - MaxStepHeight)
            elseif a3 < StepSmoothRootY then
                StepSmoothRootY = math.min(math.max(StepSmoothRootY - u77 * a4, a3), a3 + MaxStepHeight)
            end
            a1.StepSmoothRootY = StepSmoothRootY
            a1.StepCameraOffsetY = StepSmoothRootY - a3
            return
        end
    end
    a1.StepSmoothRootY = a3
    a1.StepCameraOffsetY = 0
end

function u73.new(a1, a2) -- Line: 199
    -- upvalues: CharacterResolver (val), CharacterGeneration (val), Workspace (val), State (val), RootFrame (val)
    -- upvalues: Janitor (val), LocalPlayer (val), CharacterAnimator (val), Signal (val), u73 (val)
    -- upvalues: RuntimeKinematics (val), updateCameraOffset (val)
    local v1, v2, v3
    local v4 = assert(CharacterResolver.getCameraPart(a1), (("%* has no CameraPart"):format((a1:GetFullName()))))
    local v5 = assert(CharacterGeneration.Get(a1), "local shell has no CharacterGeneration")
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera ~= nil then
        _, v3 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
        CFrame.Angles(0, v3, 0)
        v1 = v3
        v2 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1)
    else
        v1 = 0
        v2 = 0
        local identity = CFrame.identity
    end
    local v6 = State.new(RootFrame.rootToSimulationPosition(a2.Position, "Standing"), nil, select(2, a2.CFrame:ToEulerAnglesYXZ()), 0)
    v3 = {
        Janitor = Janitor.new(),
        Character = a1,
        Player = LocalPlayer,
        Generation = v5,
        HumanoidRootPart = a2,
        CameraPart = v4,
        CharacterAnimator = CharacterAnimator.new(a1),
        MovementState = v6,
        Support = State.noneSupport(),
        GlobalVelocity = Vector3.new(0, 0, 0),
        GlobalDirection = Vector3.new(0, 0, 0),
        LatestMoveVector = Vector2.zero,
        PreviousFrameMoveVector = Vector2.zero,
        CurrentFrameMoveVector = Vector2.zero,
        PreviousFrameLookYaw = v1,
        CurrentFrameLookYaw = v1,
        LastSampledLookYaw = v1,
        CurrentFrameVerticalLook = v2,
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
        DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15000000596046448, 0),
        CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.399999976158142, 0),
        CameraOffset = Vector3.new(0, 0, 0),
        VisualDuckAmount = v6.DuckAmount,
        VisualDuckRootAmount = 0,
        CameraDuckRootCompensationY = 0,
        VisualPlantCameraAlpha = 0,
        StepSmoothRootY = a2.Position.Y,
        StepSmoothLastDuckAmount = v6.DuckAmount,
        StepSmoothWasOnGround = v6.OnGround,
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
        Landed = Signal.new(),
    }
    local u143 = setmetatable(v3, u73)
    u143.CharacterAnimator.Player = LocalPlayer
    a2.Anchored = true
    a2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    a2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    u143.Janitor:Add(u143.Crouching)
    u143.Janitor:Add(u143.Climbing)
    u143.Janitor:Add(u143.Walking)
    u143.Janitor:Add(u143.Landed)
    u143.Janitor:Add(function() -- Line: 274 -- upvalues: u143 (val), RuntimeKinematics (upval), a1 (val)
        u143.CharacterAnimator:destroy()
        RuntimeKinematics.clear(a1)
    end)
    u143.Janitor:Add(((LocalPlayer:GetAttributeChangedSignal("DefaultCameraOffset")):Connect(function() -- Line: 278 -- upvalues: u143 (val), LocalPlayer (upval)
        u143.DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15000000596046448, 0)
    end)))
    u143.Janitor:Add(((LocalPlayer:GetAttributeChangedSignal("CrouchCameraOffset")):Connect(function() -- Line: 281 -- upvalues: u143 (val), LocalPlayer (upval)
        u143.CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.399999976158142, 0)
    end)))
    updateCameraOffset(u143, 0)
    RuntimeKinematics.write(a1, Vector3.new(0, 0, 0), true, a2.Position)
    return u143
end

function u73:MatchesGeneration(a2) -- Line: 290 -- upvalues: CharacterGeneration (val) -- types: self: table, a2: number
    local v1 = not self.IsDestroyed
    if v1 then
        v1 = false
        if self.Character.Parent ~= nil then
            v1 = false
            if self.Character:GetAttribute("Dead") ~= true then
                v1 = false
                if self.Generation == a2 then
                    v1 = CharacterGeneration.Get(self.Character) == a2
                end
            end
        end
    end
    return v1
end

function u73.MoveFunction(a1, a2, a3) -- Line: 298
    -- upvalues: Workspace (val), finiteHorizontalInput (val)
    local identity, v1
    if a1.IsDestroyed then
        return
    end
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera ~= nil then
        local v2
        _, v2 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
        local v3 = CFrame.Angles(0, v2, 0)
        local v4 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1)
        identity = v3
    else
        identity = CFrame.identity
    end
    local v5 = finiteHorizontalInput(a2)
    v1 = Vector3.new(math.clamp((if not a3 then identity:VectorToObjectSpace(v5) else v5).X, -1, 1), 0, (math.clamp(v1.Z, -1, 1)))
    a1.GlobalDirection = identity:VectorToWorldSpace(v1)
    a1.LatestMoveVector = Vector2.new(v1.X, v1.Z)
end

function u73.PrepareInputFrame(a1) -- Line: 311 -- upvalues: Workspace (val)
    local v1, v2
    if a1.IsDestroyed then
        return
    end
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera ~= nil then
        local v3
        _, v3 = CurrentCamera.CFrame:ToEulerAnglesYXZ()
        CFrame.Angles(0, v3, 0)
        v1 = v3
        v2 = math.clamp(CurrentCamera.CFrame.LookVector.Y, -1, 1)
    else
        v1 = 0
        v2 = 0
        local identity = CFrame.identity
    end
    if a1.InputFramePrepared then
        a1.PreviousFrameMoveVector = a1.CurrentFrameMoveVector
        a1.CurrentFrameMoveVector = a1.LatestMoveVector
        a1.PreviousFrameLookYaw = a1.CurrentFrameLookYaw
        a1.CurrentFrameLookYaw = v1
        a1.CurrentFrameVerticalLook = v2
        return
    end
    a1.PreviousFrameMoveVector = a1.LatestMoveVector
    a1.CurrentFrameMoveVector = a1.LatestMoveVector
    a1.PreviousFrameLookYaw = v1
    a1.CurrentFrameLookYaw = v1
    a1.CurrentFrameVerticalLook = v2
    a1.InputFramePrepared = true
end

function u73.ToggleWalkState(a1, a2) -- Line: 332 -- types: a1: table, a2: boolean
    if a1.IsWalking == a2 then
        return
    end
    a1.IsWalking = a2
    a1.Walking:Fire(a2)
end

function u73.ToggleCrouchInput(a1, a2) -- Line: 340 -- types: a1: table, a2: boolean
    a1.CrouchInputDown = a2
end

function u73.SetJumpInput(a1, a2) -- Line: 344 -- types: a1: table, a2: boolean?
    if a2 == nil then
        a1.JumpPulsePending = true
        return
    end
    a1.JumpInputDown = a2
end

function u73.PlantBomb(a1) -- Line: 352
    a1.IsPlantingBomb = true
end

function u73.CancelBombPlant(a1) -- Line: 356
    a1.IsPlantingBomb = false
end

function u73.SampleInput(a1, a2) -- Line: 360
    -- upvalues: applyAutomaticAirStrafe (val), Buttons (val), JumpInputSampler (val)
    if not a1:MatchesGeneration(a2.Mapping.Generation) then
        return nil
    end
    local v1 = math.clamp(a2.FrameSampleAlpha or 1, 0, 1)
    local PreviousFrameMoveVector = a1.PreviousFrameMoveVector
    local CurrentFrameMoveVector = a1.CurrentFrameMoveVector
    local v2 = true
    if (math.sign(PreviousFrameMoveVector.X)) == math.sign(CurrentFrameMoveVector.X) then
        v2 = (math.sign(PreviousFrameMoveVector.Y)) ~= math.sign(CurrentFrameMoveVector.Y)
    end
    local PreviousFrameLookYaw = a1.PreviousFrameLookYaw
    local PreviousFrameLookYaw_2 = a1.PreviousFrameLookYaw
    local CurrentFrameLookYaw = a1.CurrentFrameLookYaw
    local v3 = PreviousFrameLookYaw + math.atan2(math.sin(CurrentFrameLookYaw - PreviousFrameLookYaw_2), (math.cos(CurrentFrameLookYaw - PreviousFrameLookYaw_2))) * v1
    local v4 = applyAutomaticAirStrafe(
        if not v2 then PreviousFrameMoveVector:Lerp(CurrentFrameMoveVector, v1) else if not (v1 < 0.5) then CurrentFrameMoveVector else PreviousFrameMoveVector,
        a1.LastSampledLookYaw,
        v3,
        a2.State
    )
    a1.LastSampledLookYaw = v3
    local v5 = Buttons.with(Buttons.with(0, Buttons.Walk, a1.IsWalking), Buttons.Duck, a1.CrouchInputDown)
    local v6, v7, v8 = JumpInputSampler.sample(a1.JumpInputDown, a1.JumpPulsePending, a1.JumpPulseNeedsRelease)
    a1.JumpPulsePending = v7
    a1.JumpPulseNeedsRelease = v8
    v5 = Buttons.with(v5, Buttons.Jump, v6)
    return {Move = v4, LookYaw = v3, VerticalLook = a1.CurrentFrameVerticalLook, Buttons = v5}
end

function u73.Present(a1, a2, a3, a4, a5) -- Line: 392
    -- upvalues: RootFrame (val), PredictionErrorSmoother (val), updateStepCameraOffset (val), PlayerContacts (val)
    -- upvalues: RuntimeKinematics (val), updateCameraOffset (val)
    local Mapping = a4.Mapping
    local Generation = if Mapping == nil then a1.Generation else Mapping.Generation
    if not a1:MatchesGeneration(Generation) then
        return
    end
    local v1 = os.clock()
    local v2 = math.clamp(v1 - a1.LastPresentedAt, 0, 0.1)
    a1.LastPresentedAt = v1
    local v3 = RootFrame.cframe(a2)
    local v4 = RootFrame.cframe(a5 or a2)
    local SnapNextPresentation = a1.SnapNextPresentation
    if SnapNextPresentation then
        a1.LastExactPresentationTick = a4.ServerTick
    end
    local v5 = SnapNextPresentation
    if not v5 then
        v5 = false
        if a1.LastExactPresentationTick ~= nil then
            v5 = a4.ServerTick == a1.LastExactPresentationTick
        end
    end
    local v6 = math.clamp(a4.TickFraction or 0, 0, 1)
    local v7 = if not v5 then v4:Lerp(v3, v6) else v3
    if not v5 then
        a1.LastExactPresentationTick = nil
    end
    a1.SnapNextPresentation = false
    local v8 = a1.PreservePredictionPresentation == true
    a1.PreservePredictionPresentation = false
    local PendingPredictionPositionDelta = a1.PendingPredictionPositionDelta
    a1.PendingPredictionPositionDelta = Vector3.new(0, 0, 0)
    if v5 then
        a1.PredictionErrorOffset = Vector3.new(0, 0, 0)
        a1.PredictionErrorElapsedSeconds = 0
    elseif v8 then
        a1.PredictionErrorOffset = PredictionErrorSmoother.clampOffset(PredictionErrorSmoother.remainingOffset(a1.PredictionErrorOffset, a1.PredictionErrorElapsedSeconds) - PendingPredictionPositionDelta)
        a1.PredictionErrorElapsedSeconds = 0
    end
    local v9 = PredictionErrorSmoother.remainingOffset(a1.PredictionErrorOffset, a1.PredictionErrorElapsedSeconds)
    if not v5 and PredictionErrorSmoother.Epsilon < v9.Magnitude then
        v7 = v7 + v9
        a1.PredictionErrorElapsedSeconds = a1.PredictionErrorElapsedSeconds + v2
        if PredictionErrorSmoother.remainingOffset(a1.PredictionErrorOffset, a1.PredictionErrorElapsedSeconds).Magnitude <= PredictionErrorSmoother.Epsilon then
            a1.PredictionErrorOffset = Vector3.new(0, 0, 0)
            a1.PredictionErrorElapsedSeconds = 0
        end
    end
    updateStepCameraOffset(a1, a2, v7.Position.Y, v2, SnapNextPresentation)
    a1.HumanoidRootPart.CFrame = v7
    a1.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    a1.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    local v10 = PlayerContacts.toWorldVelocity(a2.Velocity, a3)
    a1.MovementState = a2
    a1.Support = a3
    a1.GlobalVelocity = Vector3.new(v10.X, 0, v10.Z)
    a1.OnGround = a2.OnGround
    a1.IsJumping = not a2.OnGround and 0 < v10.Y
    local v11 = 0.5 < a2.DuckAmount
    if v11 ~= a1.IsCrouching then
        a1.IsCrouching = v11
        a1.Crouching:Fire(v11)
    end
    local v12 = a2.MovementMode == "Ladder"
    if v12 ~= a1.IsClimbing then
        a1.IsClimbing = v12
        a1.Climbing:Fire(v12)
    end
    RuntimeKinematics.write(a1.Character, v10, a2.OnGround, v3.Position)
    a1.CharacterAnimator:updateLocomotion(v10, a2.OnGround, v11, v12)
    local v13 = a5 or a2
    local v14 = RootFrame.getDuckRootVerticalOffset(v13.DuckAmount, v13.OnGround)
    local v15 = RootFrame.getDuckRootVerticalOffset(a2.DuckAmount, a2.OnGround)
    updateCameraOffset(a1, v2, if not v5 then v14 + (v15 - v14) * v6 else v15)
end

function u73.OnStepEvents(a1, a2) -- Line: 485
    if a2.Jumped then
        a1.CharacterAnimator:noteJumpEvent()
    end
    if a2.Landed then
        a1.Landed:Fire(
            math.max(0, -(if typeof(a2.ImpactVelocityY) ~= "number" then 0 else a2.ImpactVelocityY)),
            a1.MovementState.DuckAmount
        )
    end
end

function u73.OnReconciled(a1, a2) -- Line: 495 -- upvalues: PredictionErrorSmoother (val)
    if not PredictionErrorSmoother.isHardSnapCorrection(a2) then
        if typeof(a2.PresentationPositionDelta) == "Vector3"
            and PredictionErrorSmoother.Epsilon < a2.PresentationPositionDelta.Magnitude then
            a1.PendingPredictionPositionDelta = a1.PendingPredictionPositionDelta + a2.PresentationPositionDelta
            a1.PreservePredictionPresentation = true
        end
        return
    end
    a1.SnapNextPresentation = true
    a1.PreservePredictionPresentation = false
    a1.PendingPredictionPositionDelta = Vector3.new(0, 0, 0)
    a1.PredictionErrorOffset = Vector3.new(0, 0, 0)
    a1.PredictionErrorElapsedSeconds = 0
    a1.StepSmoothRootY = nil
    a1.StepCameraOffsetY = 0
end

function u73.OnPlayerContactCorrection(a1, a2, a3) -- Line: 513
    -- upvalues: ContactMinDistance (val)
    if ContactMinDistance < a2 then
        a1.PreservePredictionPresentation = true
        a1.PendingPredictionPositionDelta = a1.PendingPredictionPositionDelta + a3
    end
end

function u73:Destroy() -- Line: 521
    if self.IsDestroyed then
        return
    end
    self.IsDestroyed = true
    self.Janitor:Destroy()
end

return u73