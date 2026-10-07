-- ReplicatedStorage.Controllers.CharacterController.LocalCharacter
-- Script path: ReplicatedStorage.Controllers.CharacterController.LocalCharacter
-- Decompile time: 10.00 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Character = require(ReplicatedStorage.Classes.Character)
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local Sound = require(ReplicatedStorage.Classes.Sound)
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration)
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Runtime = require(ReplicatedStorage.MovementV2.Client.Runtime)
local Catalog = require(ReplicatedStorage.MovementV2.Collision.Catalog)
local MoverComposer = require(ReplicatedStorage.MovementV2.Client.MoverComposer)
local DiagnosticProtocol = require(ReplicatedStorage.MovementV2.DiagnosticProtocol)
local DoorSwing = require(ReplicatedStorage.MovementV2.DoorSwing)
local MoverTrajectory = require(ReplicatedStorage.MovementV2.MoverTrajectory)
local RootFrame = require(ReplicatedStorage.MovementV2.RootFrame)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local Serial = require(ReplicatedStorage.MovementV2.Serial)
local SpeedProfile = require(ReplicatedStorage.MovementV2.SpeedProfile)
local HitFlinch = require(script.Parent.HitFlinch)
local RemoteCharacters = require(script.Parent.RemoteCharacters)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local NetStatsController = require(ReplicatedStorage.Controllers.NetStatsController)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local LocalPlayer = Players.LocalPlayer
local Controls = require((LocalPlayer:WaitForChild("PlayerScripts")):WaitForChild("PlayerModule")):GetControls()
local u149 = {}
local u150 = nil
local u151 = false
local u152 = false
local u153 = false
local u155 = MoverComposer.new()
local u156 = nil
local u157 = nil
local u158 = false
local u159 = 0
local u160 = {}

local function movementDiagnosticWarning(a1) -- Line: 58
    -- upvalues: DiagnosticProtocol (val), LocalPlayer (val)
    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
        warn(a1)
    end
end

local function movementWeaponWalkSpeed(a1) -- Line: 64
    -- upvalues: u158 (ref), u156 (ref), GetWeaponProperties (val), u157 (ref)
    if not u158 or u156 ~= a1 then
        u156 = a1
        u158 = true
        local v1 = if a1 == nil then nil else GetWeaponProperties(a1)
        u157 = if v1 == nil then nil else if typeof(v1.WalkSpeed) ~= "number" then nil else v1.WalkSpeed
    end
    return u157
end

local function resetMovementInputState() -- Line: 125 -- upvalues: Controls (val)
    local activeController = Controls.activeController
    if activeController == nil then
        return
    end
    activeController.moveVector = Vector3.new(0, 0, 0)
    activeController.backwardValue = 0
    activeController.forwardValue = 0
    activeController.rightValue = 0
    activeController.leftValue = 0
end

local function moveCharacter(a1, a2, a3) -- Line: 137
    -- upvalues: u150 (ref)
    local v1 = u150
    if v1 ~= nil then
        v1:MoveFunction(a2, a3)
    end
end

local function resolveControllerRig(a1) -- Line: 144
    -- upvalues: CharacterResolver (val), CharacterGeneration (val)
    if CharacterResolver.isPlayerCharacter(a1) and CharacterGeneration.Get(a1) ~= nil then
        local v1 = CharacterResolver.resolve(a1)
        if v1 ~= nil and v1.Head ~= nil and v1.Animator ~= nil then
            return v1
        end
        return nil
    end
    return nil
end

local u189 = Runtime.new({
    PrepareInputFrame = function() -- Line: 153 -- upvalues: u150 (ref)
        local v1 = u150
        if v1 ~= nil then
            v1:PrepareInputFrame()
        end
    end,
    SampleInput = function(a1) -- Line: 159 -- upvalues: u150 (ref)
        local v1 = u150
        if v1 ~= nil then
            return (v1:SampleInput(a1))
        end
        return nil
    end,
    ConsumePendingWeaponSelection = InventoryController.ConsumePendingMovementWeaponSelect,
    GetUnresolvedWeaponSelection = InventoryController.GetUnresolvedMovementWeaponSelectForResend,
    RestorePendingWeaponSelection = InventoryController.RestorePendingMovementWeaponSelect,
    ResolveWeaponSpeedProfile = function(a1) -- Line: 86
        -- upvalues: SpeedProfile (val), InventoryController (val), u158 (ref), u156 (ref), GetWeaponProperties (val)
        -- upvalues: u157 (ref)
        if a1.Identifier == "" and a1.GrenadeThrowIdentifier ~= nil then
            return SpeedProfile.resolveWeaponSpeeds(nil, nil)
        end
        local v1 = InventoryController.peekInventoryItemForMovement(a1.Identifier)
        if v1 ~= nil and typeof(v1.Name) == "string" then
            local resolveWeaponSpeeds = SpeedProfile.resolveWeaponSpeeds
            local Name_3 = v1.Name
            local Name = v1.Name
            if not u158 or u156 ~= Name then
                u156 = Name
                u158 = true
                local v2 = if Name == nil then nil else GetWeaponProperties(Name)
                u157 = if v2 == nil then nil else if typeof(v2.WalkSpeed) ~= "number" then nil else v2.WalkSpeed
            end
            return resolveWeaponSpeeds(Name_3, u157)
        end
        return nil, nil
    end,
    ResolveBaseMoveSpeed = function(a1, a2, a3, a4, a5) -- Line: 97
        -- upvalues: GameState (val), LocalPlayer (val), SpeedProfile (val)
        if GameState.GetStateAtTime(a2) == "Buy Period" then
            return 0
        end
        if LocalPlayer:GetAttribute("IsPlantingBomb") == true then
            local Attribute = LocalPlayer:GetAttribute("BombPlantMovementLockAt")
            local v1 = false
            if typeof(Attribute) == "number" then
                v1 = false
                if Attribute == Attribute then
                    v1 = a2 < Attribute
                end
            end
            if not v1 then
                return 0
            end
        end
        return SpeedProfile.resolveFromWeaponSpeeds(a3, a4, a5, LocalPlayer:GetAttribute("IsCarryingHostage") == true)
    end,
    ResolveScopedState = function() -- Line: 76 -- upvalues: InventoryController (val)
        local v1 = InventoryController.peekCurrentEquippedForMovement()
        local v2 = false
        if v1 ~= nil then
            v2 = true
            if v1.IsAiming ~= true then
                v2 = false
                if v1.Name == "R8 Revolver" then
                    v2 = v1.IsChargeFiring == true
                end
            end
        end
        return v2
    end,
    ResolveMovementDiagnosticContext = function(a1) -- Line: 169 -- upvalues: u150 (ref), GameState (val), LocalPlayer (val)
        local v1 = u150
        local v2 = {
            GameStateAtSnapshot = GameState.GetStateAtTime(a1),
            CurrentGameState = GameState.GetState(),
        }
        local v3 = false
        if v1 ~= nil then
            v3 = v1.IsPlantingBomb == true
        end
        v2.LocalPlanting = v3
        v2.ReplicatedPlanting = LocalPlayer:GetAttribute("IsPlantingBomb") == true
        v2.LocalDefusing = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true
        v2.ReplicatedDefusing = LocalPlayer:GetAttribute("IsDefusingBomb") == true
        v2.ReplicatedRescuing = LocalPlayer:GetAttribute("IsRescuingHostage") == true
        v2.CarryingHostage = LocalPlayer:GetAttribute("IsCarryingHostage") == true
        v2.BombPlantMovementLockAt = LocalPlayer:GetAttribute("BombPlantMovementLockAt")
        return v2
    end,
    ResolveGeneration = function() -- Line: 184 -- upvalues: u150 (ref)
        local v1 = u150
        if v1 ~= nil then
            return v1.Generation
        end
        return nil
    end,
    ResolveMapRoot = function(a1) -- Line: 188 -- upvalues: Catalog (val), Workspace (val)
        return Catalog.FindReplica(a1.TopologyEpoch, a1.TopologyFingerprint) or Workspace:FindFirstChild("Map")
    end,
    CollisionComposer = u155,
    PresentLocal = function(a1, a2, a3, a4) -- Line: 193 -- upvalues: NetStatsController (val), MoverTrajectory (val), u150 (ref)
        NetStatsController.ObservePresentation(a3)
        MoverTrajectory.SetClientPresentationClock(a3.ServerTick, a3.TickFraction or 0)
        local v1 = u150
        if v1 ~= nil then
            v1:Present(a1, a2, a3, a4)
        end
    end,
    PresentRemotes = RemoteCharacters.Present,
    OnStepEvents = function(a1) -- Line: 203 -- upvalues: u150 (ref)
        local v1 = u150
        if v1 ~= nil then
            v1:OnStepEvents(a1)
        end
    end,
    OnOwnerSnapshotReceived = NetStatsController.ObserveOwnerSnapshot,
    OnRemoteSnapshotReceived = NetStatsController.ObserveRemoteSnapshot,
    OnCommandPacketSent = NetStatsController.ObserveCommandPacket,
    OnReconciled = function(a1, a2) -- Line: 212 -- upvalues: NetStatsController (val), u150 (ref)
        NetStatsController.ObserveReconciliation(a1, a2)
        local v1 = u150
        if v1 ~= nil then
            v1:OnReconciled(a1)
        end
    end,
    OnPlayerContactCorrection = function(a1, a2, a3) -- Line: 219 -- upvalues: u150 (ref)
        local v1 = u150
        if v1 ~= nil then
            v1:OnPlayerContactCorrection(a1, a3)
        end
    end,
    OnPredictionHitch = function(a1) -- Line: 225 -- upvalues: NetStatsController (val)
        NetStatsController.ObservePredictionHitch(a1)
    end,
    OnWarning = function(a1) -- Line: 228 -- upvalues: DiagnosticProtocol (val), LocalPlayer (val)
        local v1 = ("[MovementV2] %*"):format(a1)
        if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
            warn(v1)
        end
    end,
})

local function clearPendingDoorUses() -- Line: 233 -- upvalues: u160 (val), u189 (val)
    for i, j in u160 do
        u189:rejectDoorPrediction(j.MoverId, j.Revision)
    end
    table.clear(u160)
end

local function requestCurrentMapping() -- Line: 240
    -- upvalues: u150 (ref), u153 (ref), u189 (val), DiagnosticProtocol (val), LocalPlayer (val)
    local v1 = u150
    if u153 and v1 ~= nil then
        local v2, v3 = u189:requestMapping(v1.Generation)
        if not v2 then
            local v4 = ("[MovementV2] could not request mapping for generation %*: %*"):format(v1.Generation, v3 or "Unknown")
            if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
                warn(v4)
            end
        end
        return
    end
end

local function characterAdded(a1, a2) -- Line: 253
    -- upvalues: Ragdoll (val), RuntimeKinematics (val), u150 (ref), Controls (val), CaseSceneController (val)
    -- upvalues: BlackMarketSceneController (val), Workspace (val), LocalPlayer (val), Character (val)
    -- upvalues: CameraController (val), u153 (ref), u189 (val), DiagnosticProtocol (val), u160 (val)
    -- upvalues: InventoryController (val)
    local v1
    local RootPart = a2.RootPart
    if a1:GetAttribute("Dead") == true then
        Ragdoll.ActivateCharacter(a1, RuntimeKinematics.getVelocity(a1, RootPart))
        return nil
    end
    assert(u150 == nil, "local character rebound before the previous binding was cleaned up")
    local activeController = Controls.activeController
    if activeController ~= nil then
        activeController.moveVector = Vector3.new(0, 0, 0)
        activeController.backwardValue = 0
        activeController.forwardValue = 0
        activeController.rightValue = 0
        activeController.leftValue = 0
    end
    RootPart.Anchored = true
    RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    if not CaseSceneController.IsActive() and not BlackMarketSceneController.IsActive() then
        local CurrentCamera = Workspace.CurrentCamera
        if CurrentCamera ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.CameraSubject = a2.CameraPart
        end
    end
    LocalPlayer.ReplicationFocus = RootPart
    local u57 = Character.new(a1, RootPart)
    u150 = u57
    u57.Janitor:Add((u57.Landed:Connect(function(a1, a2) -- Line: 277 -- upvalues: CameraController (upval) -- types: a1: number?, a2: number?
        CameraController.OnLanded(a1, a2)
    end)))
    local v2 = u150
    if u153 and v2 ~= nil then
        local v3, v4 = u189:requestMapping(v2.Generation)
        if not v3 then
            v1 = ("[MovementV2] could not request mapping for generation %*: %*"):format(v2.Generation, v4 or "Unknown")
            if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
                warn(v1)
            end
        end
    end
    local u88 = false
    local u89 = nil

    local function cleanup() -- Line: 284
        -- upvalues: u88 (ref), u89 (ref), u150 (upval), u57 (val), u160 (upval), u189 (upval), LocalPlayer (upval)
        -- upvalues: a1 (val), Workspace (upval), InventoryController (upval)
        if u88 then
            return
        end
        u88 = true
        if u89 ~= nil then
            u89:Disconnect()
        end
        if u150 ~= u57 then
            return
        end
        for i, j in u160 do
            u189:rejectDoorPrediction(j.MoverId, j.Revision)
        end
        table.clear(u160)
        local Generation = u57.Generation
        u189:retireGeneration(Generation)
        u150 = nil
        u57:Destroy()
        task.defer(function() -- Line: 301
            -- upvalues: LocalPlayer (upval), a1 (upval), Workspace (upval), InventoryController (upval)
            -- upvalues: Generation (val)
            local v1 = false
            if LocalPlayer.Character == a1 then
                v1 = a1:IsDescendantOf(Workspace) and a1:GetAttribute("Dead") ~= true
            end
            if not v1 then
                InventoryController.CleanupCurrentLoadout(Generation)
            end
        end)
    end

    v1 = (a1:GetAttributeChangedSignal("Dead")):Connect(function() -- Line: 311 -- upvalues: a1 (val), Ragdoll (upval), RuntimeKinematics (upval), RootPart (val), cleanup (val)
        if a1:GetAttribute("Dead") == true then
            Ragdoll.ActivateCharacter(a1, RuntimeKinematics.getVelocity(a1, RootPart))
            cleanup()
        end
    end)
    task.spawn(function() -- Line: 318 -- upvalues: a1 (val), Ragdoll (upval)
        if a1.Parent ~= nil and a1:GetAttribute("Dead") ~= true then
            local success, result = pcall(Ragdoll.PrepareCharacter, a1)
            if not success then
                warn((("[LocalCharacter] Ragdoll preparation failed: %*"):format(result)))
            end
        end
    end)
    return cleanup
end

local function observeCharacterReady(a1) -- Line: 329
    -- upvalues: resolveControllerRig (val), CharacterGeneration (val), characterAdded (val)
    local u1 = nil
    local u2 = nil
    local u3 = nil
    local u4 = nil
    local u5 = false
    local u6 = false
    local u7 = false

    local function unbind() -- Line: 338 -- upvalues: u1 (ref), u2 (ref), u3 (ref), u4 (ref)
        local v1 = u1
        u1 = nil
        u2 = nil
        u3 = nil
        u4 = nil
        if v1 ~= nil then
            v1()
        end
    end

    local function refreshBinding() -- Line: 349
        -- upvalues: u6 (ref), resolveControllerRig (upval), a1 (val), CharacterGeneration (upval), u1 (ref), u2 (ref)
        -- upvalues: u3 (ref), u4 (ref), u5 (ref), characterAdded (upval)
        local v1
        if u6 then
            return
        end
        local v2 = resolveControllerRig(a1)
        local v3 = CharacterGeneration.Get(a1)
        if a1.Parent ~= nil and v2 ~= nil and v3 ~= nil then
            if a1:GetAttribute("Dead") == true then
                v1 = u1
                u1 = nil
                u2 = nil
                u3 = nil
                u4 = nil
                if v1 ~= nil then
                    v1()
                end
                if not u5 then
                    u5 = true
                    characterAdded(a1, v2)
                end
                return
            end
            u5 = false
            if u1 ~= nil and u2 == v3 and u3 == v2.RootPart and u4 == v2.Animator then
                return
            end
            v1 = u1
            u1 = nil
            u2 = nil
            u3 = nil
            u4 = nil
            if v1 ~= nil then
                v1()
            end
            u1 = characterAdded(a1, v2)
            if u1 ~= nil then
                u2 = v3
                u3 = v2.RootPart
                u4 = v2.Animator
            end
            return
        end
        v1 = u1
        u1 = nil
        u2 = nil
        u3 = nil
        u4 = nil
        if v1 ~= nil then
            v1()
        end
    end

    local u11 = {}
    local v1 = a1.DescendantAdded:Connect(refreshBinding)
    local v2 = a1.DescendantRemoving:Connect(function() -- Line: 386 -- upvalues: u7 (ref), u6 (ref), refreshBinding (val)
        if not u7 and not u6 then
            u7 = true
            task.defer(function() -- Line: 391 -- upvalues: u7 (upval), refreshBinding (upval)
                u7 = false
                refreshBinding()
            end)
            return
        end
    end)
    local v3 = (a1:GetAttributeChangedSignal("CharacterType")):Connect(refreshBinding)
    local v4 = (a1:GetAttributeChangedSignal(CharacterGeneration.AttributeName)):Connect(refreshBinding)
    local AttributeChangedSignal_3 = a1:GetAttributeChangedSignal("Dead")
    u11[1] = v1
    u11[2] = v2
    u11[3] = v3
    u11[4] = v4
    u11[5] = AttributeChangedSignal_3:Connect(refreshBinding)
    refreshBinding()
    return function() -- Line: 406 -- upvalues: u6 (ref), u11 (val), u1 (ref), u2 (ref), u3 (ref), u4 (ref)
        u6 = true
        for i, j in u11 do
            j:Disconnect()
        end
        table.clear(u11)
        local v1 = u1
        u1 = nil
        u2 = nil
        u3 = nil
        u4 = nil
        if v1 ~= nil then
            v1()
        end
    end
end

function u149.getCurrentCharacter() -- Line: 416 -- upvalues: u150 (ref)
    return u150
end

function u149.GetMovementRuntimeStatus() -- Line: 421 -- upvalues: u189 (val)
    return u189:getStatus()
end

function u149.GetRemoteViewTick() -- Line: 425 -- upvalues: u189 (val)
    return u189:getRemoteViewTick()
end

function u149.GetWalkState() -- Line: 429 -- upvalues: u150 (ref)
    local IsWalking = false
    if u150 ~= nil then
        IsWalking = u150.IsWalking
    end
    return IsWalking
end

function u149.GetCrouchState() -- Line: 433 -- upvalues: u150 (ref)
    local IsCrouching = false
    if u150 ~= nil then
        IsCrouching = u150.IsCrouching
    end
    return IsCrouching
end

function u149.walk(a1) -- Line: 437 -- upvalues: u150 (ref) -- types: a1: boolean
    if u150 ~= nil then
        u150:ToggleWalkState(a1)
    end
end

function u149.crouch(a1) -- Line: 443 -- upvalues: u150 (ref) -- types: a1: boolean
    if u150 ~= nil then
        u150:ToggleCrouchInput(a1)
    end
end

function u149.jump(a1) -- Line: 449 -- upvalues: u150 (ref) -- types: a1: boolean?
    if u150 ~= nil then
        u150:SetJumpInput(a1)
    end
end

function u149.PlantBomb() -- Line: 455 -- upvalues: u150 (ref)
    if u150 ~= nil then
        u150:PlantBomb()
    end
end

function u149.CancelBombPlant() -- Line: 461 -- upvalues: u150 (ref)
    if u150 ~= nil then
        u150:CancelBombPlant()
    end
end

function u149.IsDoorInUseRange(a1) -- Line: 468
    -- upvalues: u189 (val), RootFrame (val), DoorSwing (val)
    local v1 = u189:getPredictedState()
    local Attribute = a1:GetAttribute("DoorClosedPivot")
    if v1 ~= nil and typeof(Attribute) == "CFrame" then
        return (RootFrame.cframe(v1).Position - Attribute.Position).Magnitude <= DoorSwing.InteractRange
    end
    return false
end

function u149:PredictDoorUse() -- Line: 477
    -- upvalues: u189 (val), u155 (val), u159 (ref), Serial (val), u160 (val)
    local v1, v2
    if self:GetAttribute("CanOpen") == false then
        return nil, "DoorLocked"
    end
    local v3 = u189:getMapping()
    v1, _, v2 = u189:getPredictedState()
    if v3 ~= nil and v1 ~= nil and v2 ~= nil then
        local u24, v4 = u155:PredictDoorUse(self, v1.Position, v2, v3.SimulationHz)
        if u24 == nil then
            return nil, v4
        end
        local u28 = u159
        u159 = Serial.addUInt32(u159, 1)
        u160[u28] = {Model = self, MoverId = u24.MoverId, Revision = u24.Revision}
        task.delay(1, function() -- Line: 496 -- upvalues: u160 (upval), u28 (val), self (val), u24 (val), u189 (upval)
            local v1 = u160[u28]
            if v1 ~= nil and v1.Model == self and v1.Revision == u24.Revision then
                u160[u28] = nil
                u189:rejectDoorPrediction(v1.MoverId, v1.Revision)
                return
            end
        end)
        return {ServerTick = u24.ServerTick, TargetAngle = u24.TargetAngle, RequestId = u28}, nil
    end
    return nil, "MovementPredictionUnavailable"
end

function u149.Initialize() -- Line: 507
    -- upvalues: u151 (ref), Controls (val), moveCharacter (val), u189 (val), u153 (ref)
    -- upvalues: ClientCharacterPresentation (val), Remotes (val), u160 (val), DiagnosticProtocol (val)
    -- upvalues: LocalPlayer (val), CharacterResolver (val), observeCharacterReady (val), u150 (ref), Sound (val)
    -- upvalues: Players (val), HitFlinch (val)
    if u151 then
        return
    end
    u151 = true
    Controls.moveFunction = moveCharacter
    u189:start()
    u153 = true
    ClientCharacterPresentation.ObserveLocalPlayer()
    Remotes.BreakableDoor.Resolved.Listen(function(a1) -- Line: 518 -- upvalues: u160 (upval), u189 (upval), DiagnosticProtocol (upval), LocalPlayer (upval)
        local v1 = u160[a1.RequestId]
        if v1 ~= nil and a1.Model == v1.Model then
            u160[a1.RequestId] = nil
            if a1.Accepted then
                return
            end
            local v2, v3 = u189:rejectDoorPrediction(v1.MoverId, v1.Revision)
            if not v2 then
                local v4 = ("[MovementV2] could not reject speculative door use: %*"):format(v3 or "Unknown")
                if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
                    warn(v4)
                end
            end
            return
        end
    end)
    CharacterResolver.observeCharacter(LocalPlayer, function(a1) -- Line: 533 -- upvalues: observeCharacterReady (upval)
        if a1 ~= nil then
            return (observeCharacterReady(a1))
        end
        return nil
    end)
    Remotes.Character.CharacterDamaged.Listen(function(a1) -- Line: 537
        -- upvalues: LocalPlayer (upval), u150 (upval), Sound (upval), Players (upval), HitFlinch (upval)
        if a1.VictimUserId == LocalPlayer.UserId then
            if u150 ~= nil then
                (Sound.new("Character")):playOneTime({Name = "Character Damaged", Parent = LocalPlayer.PlayerGui})
            end
            return
        end
        if a1.Melee ~= true and a1.Direction ~= nil then
            local PlayerByUserId = Players:GetPlayerByUserId(a1.VictimUserId)
            local Character_2 = if PlayerByUserId == nil then nil else PlayerByUserId.Character
            if Character_2 ~= nil then
                if a1.Headshot == true then
                    HitFlinch.flickHead(Character_2, a1.Direction)
                    return
                end
                HitFlinch.flinchBody(Character_2, a1.Direction)
            end
            return
        end
    end)
end

function u149.Start() -- Line: 562 -- upvalues: u152 (ref), Router (val), u149 (val)
    if u152 then
        return
    end
    u152 = true
    Router.observerRouter("Plant Bomb", u149.PlantBomb)
    Router.observerRouter("Cancel Bomb Plant", u149.CancelBombPlant)
    Router.observerRouter("GetCurrentCharacter", u149.getCurrentCharacter)
    Router.observerRouter("GetRemoteViewTick", u149.GetRemoteViewTick)
end

return u149