-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Character = require(ReplicatedStorage.Classes.Character);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);
local Sound = require(ReplicatedStorage.Classes.Sound);
local CharacterGeneration = require(ReplicatedStorage.Components.Common.CharacterGeneration);
local ClientCharacterPresentation = require(ReplicatedStorage.Components.Common.ClientCharacterPresentation);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Runtime = require(ReplicatedStorage.MovementV2.Client.Runtime);
local Catalog = require(ReplicatedStorage.MovementV2.Collision.Catalog);
local MoverComposer = require(ReplicatedStorage.MovementV2.Client.MoverComposer);
local DiagnosticProtocol = require(ReplicatedStorage.MovementV2.DiagnosticProtocol);
local DoorSwing = require(ReplicatedStorage.MovementV2.DoorSwing);
local MoverTrajectory = require(ReplicatedStorage.MovementV2.MoverTrajectory);
local RootFrame = require(ReplicatedStorage.MovementV2.RootFrame);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local Serial = require(ReplicatedStorage.MovementV2.Serial);
local SpeedProfile = require(ReplicatedStorage.MovementV2.SpeedProfile);
local HitFlinch = require(script.Parent.HitFlinch);
local RemoteCharacters = require(script.Parent.RemoteCharacters);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local NetStatsController = require(ReplicatedStorage.Controllers.NetStatsController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local LocalPlayer = Players.LocalPlayer;
local Controls = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls();
local u1 = {};
local u2 = nil;
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = MoverComposer.new();
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = 0;
local u11 = {};

local function movementDiagnosticWarning(p12: string) -- Line: 58
    -- upvalues: DiagnosticProtocol (copy), LocalPlayer (copy)
    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
        warn(p12);
    end;
end;

local function movementWeaponWalkSpeed(p13: string?) -- Line: 64
    -- upvalues: u9 (ref), u7 (ref), GetWeaponProperties (copy), u8 (ref)
    if not u9 or u7 ~= p13 then
        u7 = p13;
        u9 = true;
        local v14;

        if p13 == nil then
            v14 = nil;
        else
            v14 = GetWeaponProperties(p13);
        end;

        local v15;

        if v14 == nil or typeof(v14.WalkSpeed) ~= "number" then
            v15 = nil;
        else
            v15 = v14.WalkSpeed;
        end;

        u8 = v15;
    end;

    return u8;
end;

local function resetMovementInputState() -- Line: 125
    -- upvalues: Controls (copy)
    local activeController = Controls.activeController;

    if activeController == nil then
        return;
    end;

    activeController.moveVector = Vector3.new(0, 0, 0);
    activeController.backwardValue = 0;
    activeController.forwardValue = 0;
    activeController.rightValue = 0;
    activeController.leftValue = 0;
end;

local function moveCharacter(p16: userdata?, p17: vector, p18: boolean) -- Line: 137
    -- upvalues: u2 (ref)
    local v19 = u2;

    if v19 ~= nil then
        v19:MoveFunction(p17, p18);
    end;
end;

local function resolveControllerRig(p20: userdata) -- Line: 144
    -- upvalues: CharacterResolver (copy), CharacterGeneration (copy)
    if not CharacterResolver.isPlayerCharacter(p20) or CharacterGeneration.Get(p20) == nil then
        return nil;
    end;

    local v21 = CharacterResolver.resolve(p20);

    if v21 == nil or (v21.Head == nil or v21.Animator == nil) then
        return nil;
    end;

    return v21;
end;

local u60 = Runtime.new({
    PrepareInputFrame = function() -- Line: 153, Name: PrepareInputFrame
        -- upvalues: u2 (ref)
        local v22 = u2;

        if v22 ~= nil then
            v22:PrepareInputFrame();
        end;
    end,

    SampleInput = function(p23) -- Line: 159, Name: SampleInput
        -- upvalues: u2 (ref)
        local v24 = u2;

        if v24 == nil then
            return nil;
        end;

        return v24:SampleInput(p23);
    end,

    ConsumePendingWeaponSelection = InventoryController.ConsumePendingMovementWeaponSelect,
    GetUnresolvedWeaponSelection = InventoryController.GetUnresolvedMovementWeaponSelectForResend,
    RestorePendingWeaponSelection = InventoryController.RestorePendingMovementWeaponSelect,

    ResolveWeaponSpeedProfile = function(p25) -- Line: 86, Name: resolveWeaponSpeedProfile
        -- upvalues: SpeedProfile (copy), InventoryController (copy), u9 (ref), u7 (ref), GetWeaponProperties (copy), u8 (ref)
        if p25.Identifier == "" and p25.GrenadeThrowIdentifier ~= nil then
            return SpeedProfile.resolveWeaponSpeeds(nil, nil);
        end;

        local v26 = InventoryController.peekInventoryItemForMovement(p25.Identifier);

        if v26 == nil or typeof(v26.Name) ~= "string" then
            return nil, nil;
        end;

        local resolveWeaponSpeeds = SpeedProfile.resolveWeaponSpeeds;
        local Name = v26.Name;
        local Name2 = v26.Name;

        if not u9 or u7 ~= Name2 then
            u7 = Name2;
            u9 = true;
            local v27;

            if Name2 == nil then
                v27 = nil;
            else
                v27 = GetWeaponProperties(Name2);
            end;

            local v28;

            if v27 == nil or typeof(v27.WalkSpeed) ~= "number" then
                v28 = nil;
            else
                v28 = v27.WalkSpeed;
            end;

            u8 = v28;
        end;

        return resolveWeaponSpeeds(Name, u8);
    end,

    ResolveBaseMoveSpeed = function(p29: number, p30: number, p31: number, p32: number, p33: boolean) -- Line: 97, Name: resolveBaseMoveSpeed
        -- upvalues: GameState (copy), LocalPlayer (copy), SpeedProfile (copy)
        if GameState.GetStateAtTime(p30) == "Buy Period" then
            return 0;
        end;

        if LocalPlayer:GetAttribute("IsPlantingBomb") == true then
            local Attribute = LocalPlayer:GetAttribute("BombPlantMovementLockAt");
            local v34;

            if typeof(Attribute) == "number" and Attribute == Attribute then
                v34 = p30 < Attribute;
            else
                v34 = false;
            end;

            if not v34 then
                return 0;
            end;
        end;

        return SpeedProfile.resolveFromWeaponSpeeds(p31, p32, p33, LocalPlayer:GetAttribute("IsCarryingHostage") == true);
    end,

    ResolveScopedState = function() -- Line: 76, Name: resolveScopedState
        -- upvalues: InventoryController (copy)
        local v35 = InventoryController.peekCurrentEquippedForMovement();
        local v36;

        if v35 == nil then
            v36 = false;
        elseif v35.IsAiming == true then
            v36 = true;
        elseif v35.Name == "R8 Revolver" then
            v36 = v35.IsChargeFiring == true;
        else
            v36 = false;
        end;

        return v36;
    end,

    ResolveMovementDiagnosticContext = function(p37) -- Line: 169, Name: ResolveMovementDiagnosticContext
        -- upvalues: u2 (ref), GameState (copy), LocalPlayer (copy)
        local v38 = u2;
        local v39 = {
            GameStateAtSnapshot = GameState.GetStateAtTime(p37),
            CurrentGameState = GameState.GetState()
        };
        local v40;

        if v38 == nil then
            v40 = false;
        else
            v40 = v38.IsPlantingBomb == true;
        end;

        v39.LocalPlanting = v40;
        v39.ReplicatedPlanting = LocalPlayer:GetAttribute("IsPlantingBomb") == true;
        v39.LocalDefusing = LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true;
        v39.ReplicatedDefusing = LocalPlayer:GetAttribute("IsDefusingBomb") == true;
        v39.ReplicatedRescuing = LocalPlayer:GetAttribute("IsRescuingHostage") == true;
        v39.CarryingHostage = LocalPlayer:GetAttribute("IsCarryingHostage") == true;
        v39.BombPlantMovementLockAt = LocalPlayer:GetAttribute("BombPlantMovementLockAt");

        return v39;
    end,

    ResolveGeneration = function() -- Line: 184, Name: ResolveGeneration
        -- upvalues: u2 (ref)
        local v41 = u2;

        if v41 == nil then
            return nil;
        end;

        return v41.Generation;
    end,

    ResolveMapRoot = function(p42) -- Line: 188, Name: ResolveMapRoot
        -- upvalues: Catalog (copy), Workspace (copy)
        return Catalog.FindReplica(p42.TopologyEpoch, p42.TopologyFingerprint) or Workspace:FindFirstChild("Map");
    end,

    CollisionComposer = u6,

    PresentLocal = function(p43, p44, p45, p46) -- Line: 193, Name: PresentLocal
        -- upvalues: NetStatsController (copy), MoverTrajectory (copy), u2 (ref)
        NetStatsController.ObservePresentation(p45);
        MoverTrajectory.SetClientPresentationClock(p45.ServerTick, p45.TickFraction or 0);
        local v47 = u2;

        if v47 ~= nil then
            v47:Present(p43, p44, p45, p46);
        end;
    end,

    PresentRemotes = RemoteCharacters.Present,

    OnStepEvents = function(p48) -- Line: 203, Name: OnStepEvents
        -- upvalues: u2 (ref)
        local v49 = u2;

        if v49 ~= nil then
            v49:OnStepEvents(p48);
        end;
    end,

    OnOwnerSnapshotReceived = NetStatsController.ObserveOwnerSnapshot,
    OnRemoteSnapshotReceived = NetStatsController.ObserveRemoteSnapshot,
    OnCommandPacketSent = NetStatsController.ObserveCommandPacket,

    OnReconciled = function(p50, p51) -- Line: 212, Name: OnReconciled
        -- upvalues: NetStatsController (copy), u2 (ref)
        NetStatsController.ObserveReconciliation(p50, p51);
        local v52 = u2;

        if v52 ~= nil then
            v52:OnReconciled(p50);
        end;
    end,

    OnPlayerContactCorrection = function(p53, p54, p55) -- Line: 219, Name: OnPlayerContactCorrection
        -- upvalues: u2 (ref)
        local v56 = u2;

        if v56 ~= nil then
            v56:OnPlayerContactCorrection(p53, p55);
        end;
    end,

    OnPredictionHitch = function(p57) -- Line: 225, Name: OnPredictionHitch
        -- upvalues: NetStatsController (copy)
        NetStatsController.ObservePredictionHitch(p57);
    end,

    OnWarning = function(p58) -- Line: 228, Name: OnWarning
        -- upvalues: DiagnosticProtocol (copy), LocalPlayer (copy)
        local v59 = `[MovementV2] {p58}`;

        if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
            warn(v59);
        end;
    end
});

local function clearPendingDoorUses() -- Line: 233
    -- upvalues: u11 (copy), u60 (copy)
    for _, v in u11 do
        u60:rejectDoorPrediction(v.MoverId, v.Revision);
    end;

    table.clear(u11);
end;

local function requestCurrentMapping() -- Line: 240
    -- upvalues: u2 (ref), u5 (ref), u60 (copy), DiagnosticProtocol (copy), LocalPlayer (copy)
    local v61 = u2;

    if not u5 or v61 == nil then
        return;
    end;

    local v62, v63 = u60:requestMapping(v61.Generation);

    if not v62 then
        local v64 = `[MovementV2] could not request mapping for generation {v61.Generation}: {v63 or "Unknown"}`;

        if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
            warn(v64);
        end;
    end;
end;

local function characterAdded(u65: userdata, p66: any) -- Line: 253
    -- upvalues: Ragdoll (copy), RuntimeKinematics (copy), u2 (ref), Controls (copy), CaseSceneController (copy), BlackMarketSceneController (copy), Workspace (copy), LocalPlayer (copy), Character (copy), CameraController (copy), u5 (ref), u60 (copy), DiagnosticProtocol (copy), u11 (copy), InventoryController (copy)
    local RootPart = p66.RootPart;

    if u65:GetAttribute("Dead") == true then
        Ragdoll.ActivateCharacter(u65, RuntimeKinematics.getVelocity(u65, RootPart));

        return nil;
    end;

    assert(u2 == nil, "local character rebound before the previous binding was cleaned up");
    local activeController = Controls.activeController;

    if activeController ~= nil then
        activeController.moveVector = Vector3.new(0, 0, 0);
        activeController.backwardValue = 0;
        activeController.forwardValue = 0;
        activeController.rightValue = 0;
        activeController.leftValue = 0;
    end;

    RootPart.Anchored = true;
    RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

    if not (CaseSceneController.IsActive() or BlackMarketSceneController.IsActive()) then
        local CurrentCamera = Workspace.CurrentCamera;

        if CurrentCamera ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Custom;
            CurrentCamera.CameraSubject = p66.CameraPart;
        end;
    end;

    LocalPlayer.ReplicationFocus = RootPart;
    local u67 = Character.new(u65, RootPart);
    u2 = u67;
    u67.Janitor:Add(u67.Landed:Connect(function(p68: number?, p69: number?) -- Line: 277
        -- upvalues: CameraController (ref)
        CameraController.OnLanded(p68, p69);
    end));
    local v70 = u2;

    if u5 and v70 ~= nil then
        local v71, v72 = u60:requestMapping(v70.Generation);

        if not v71 then
            local v73 = `[MovementV2] could not request mapping for generation {v70.Generation}: {v72 or "Unknown"}`;

            if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
                warn(v73);
            end;
        end;
    end;

    local u74 = false;
    local u75 = nil;

    local function cleanup() -- Line: 284
        -- upvalues: u74 (ref), u75 (ref), u2 (ref), u67 (copy), u11 (ref), u60 (ref), LocalPlayer (ref), u65 (copy), Workspace (ref), InventoryController (ref)
        if u74 then
            return;
        end;

        u74 = true;

        if u75 ~= nil then
            u75:Disconnect();
        end;

        if u2 ~= u67 then
            return;
        end;

        for _, v in u11 do
            u60:rejectDoorPrediction(v.MoverId, v.Revision);
        end;

        table.clear(u11);
        local Generation = u67.Generation;
        u60:retireGeneration(Generation);
        u2 = nil;
        u67:Destroy();
        task.defer(function() -- Line: 301
            -- upvalues: LocalPlayer (ref), u65 (ref), Workspace (ref), InventoryController (ref), Generation (copy)
            local v76;

            if LocalPlayer.Character == u65 then
                v76 = u65:IsDescendantOf(Workspace) and u65:GetAttribute("Dead") ~= true;
            else
                v76 = false;
            end;

            if not v76 then
                InventoryController.CleanupCurrentLoadout(Generation);
            end;
        end);
    end;

    u75 = u65:GetAttributeChangedSignal("Dead"):Connect(function() -- Line: 311
        -- upvalues: u65 (copy), Ragdoll (ref), RuntimeKinematics (ref), RootPart (copy), cleanup (copy)
        if u65:GetAttribute("Dead") == true then
            Ragdoll.ActivateCharacter(u65, RuntimeKinematics.getVelocity(u65, RootPart));
            cleanup();
        end;
    end);
    task.spawn(function() -- Line: 318
        -- upvalues: u65 (copy), Ragdoll (ref)
        if u65.Parent ~= nil and u65:GetAttribute("Dead") ~= true then
            local success, result = pcall(Ragdoll.PrepareCharacter, u65);

            if not success then
                warn((`[LocalCharacter] Ragdoll preparation failed: {result}`));
            end;
        end;
    end);

    return cleanup;
end;

local function observeCharacterReady(u77: userdata) -- Line: 329
    -- upvalues: resolveControllerRig (copy), CharacterGeneration (copy), characterAdded (copy)
    local u78 = nil;
    local u79 = nil;
    local u80 = nil;
    local u81 = nil;
    local u82 = false;
    local u83 = false;
    local u84 = false;

    local function unbind() -- Line: 338
        -- upvalues: u78 (ref), u79 (ref), u80 (ref), u81 (ref)
        local v85 = u78;
        u78 = nil;
        u79 = nil;
        u80 = nil;
        u81 = nil;

        if v85 ~= nil then
            v85();
        end;
    end;

    local function refreshBinding() -- Line: 349
        -- upvalues: u83 (ref), resolveControllerRig (ref), u77 (copy), CharacterGeneration (ref), u78 (ref), u79 (ref), u80 (ref), u81 (ref), u82 (ref), characterAdded (ref)
        if u83 then
            return;
        end;

        local v86 = resolveControllerRig(u77);
        local v87 = CharacterGeneration.Get(u77);

        if u77.Parent == nil or (v86 == nil or v87 == nil) then
            local v88 = u78;
            u78 = nil;
            u79 = nil;
            u80 = nil;
            u81 = nil;

            if v88 ~= nil then
                v88();
            end;

            return;
        end;

        if u77:GetAttribute("Dead") == true then
            local v89 = u78;
            u78 = nil;
            u79 = nil;
            u80 = nil;
            u81 = nil;

            if v89 ~= nil then
                v89();
            end;

            if not u82 then
                u82 = true;
                characterAdded(u77, v86);
            end;

            return;
        end;

        u82 = false;

        if u78 ~= nil and (u79 == v87 and (u80 == v86.RootPart and u81 == v86.Animator)) then
            return;
        end;

        local v90 = u78;
        u78 = nil;
        u79 = nil;
        u80 = nil;
        u81 = nil;

        if v90 ~= nil then
            v90();
        end;

        u78 = characterAdded(u77, v86);

        if u78 ~= nil then
            u79 = v87;
            u80 = v86.RootPart;
            u81 = v86.Animator;
        end;
    end;

    local function queueRefresh() -- Line: 386
        -- upvalues: u84 (ref), u83 (ref), refreshBinding (copy)
        if u84 or u83 then
            return;
        end;

        u84 = true;
        task.defer(function() -- Line: 391
            -- upvalues: u84 (ref), refreshBinding (ref)
            u84 = false;
            refreshBinding();
        end);
    end;

    local u91 = {
        u77.DescendantAdded:Connect(refreshBinding),
        u77.DescendantRemoving:Connect(queueRefresh),
        u77:GetAttributeChangedSignal("CharacterType"):Connect(refreshBinding),
        u77:GetAttributeChangedSignal(CharacterGeneration.AttributeName):Connect(refreshBinding),
        u77:GetAttributeChangedSignal("Dead"):Connect(refreshBinding)
    };
    refreshBinding();

    return function() -- Line: 406
        -- upvalues: u83 (ref), u91 (copy), u78 (ref), u79 (ref), u80 (ref), u81 (ref)
        u83 = true;

        for _, v in u91 do
            v:Disconnect();
        end;

        table.clear(u91);
        local v92 = u78;
        u78 = nil;
        u79 = nil;
        u80 = nil;
        u81 = nil;

        if v92 ~= nil then
            v92();
        end;
    end;
end;

function u1.getCurrentCharacter() -- Line: 416
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.GetMovementRuntimeStatus() -- Line: 421
    -- upvalues: u60 (copy)
    return u60:getStatus();
end;

function u1.GetRemoteViewTick() -- Line: 425
    -- upvalues: u60 (copy)
    return u60:getRemoteViewTick();
end;

function u1.GetWalkState() -- Line: 429
    -- upvalues: u2 (ref)
    local v93;

    if u2 == nil then
        v93 = false;
    else
        v93 = u2.IsWalking;
    end;

    return v93;
end;

function u1.GetCrouchState() -- Line: 433
    -- upvalues: u2 (ref)
    local v94;

    if u2 == nil then
        v94 = false;
    else
        v94 = u2.IsCrouching;
    end;

    return v94;
end;

function u1.walk(p95: boolean) -- Line: 437
    -- upvalues: u2 (ref)
    if u2 ~= nil then
        u2:ToggleWalkState(p95);
    end;
end;

function u1.crouch(p96: boolean) -- Line: 443
    -- upvalues: u2 (ref)
    if u2 ~= nil then
        u2:ToggleCrouchInput(p96);
    end;
end;

function u1.jump(p97: boolean?) -- Line: 449
    -- upvalues: u2 (ref)
    if u2 ~= nil then
        u2:SetJumpInput(p97);
    end;
end;

function u1.PlantBomb() -- Line: 455
    -- upvalues: u2 (ref)
    if u2 ~= nil then
        u2:PlantBomb();
    end;
end;

function u1.CancelBombPlant() -- Line: 461
    -- upvalues: u2 (ref)
    if u2 ~= nil then
        u2:CancelBombPlant();
    end;
end;

function u1.IsDoorInUseRange(p98: userdata) -- Line: 468
    -- upvalues: u60 (copy), RootFrame (copy), DoorSwing (copy)
    local PredictedState = u60:getPredictedState();
    local Attribute = p98:GetAttribute("DoorClosedPivot");

    if PredictedState == nil or typeof(Attribute) ~= "CFrame" then
        return false;
    end;

    return (RootFrame.cframe(PredictedState).Position - Attribute.Position).Magnitude <= DoorSwing.InteractRange;
end;

function u1.PredictDoorUse(u99: userdata) -- Line: 477
    -- upvalues: u60 (copy), u6 (copy), u10 (ref), Serial (copy), u11 (copy)
    if u99:GetAttribute("CanOpen") == false then
        return nil, "DoorLocked";
    end;

    local Mapping = u60:getMapping();
    local PredictedState, _, v100 = u60:getPredictedState();

    if Mapping == nil or (PredictedState == nil or v100 == nil) then
        return nil, "MovementPredictionUnavailable";
    end;

    local u101, v102 = u6:PredictDoorUse(u99, PredictedState.Position, v100, Mapping.SimulationHz);

    if u101 == nil then
        return nil, v102;
    end;

    local u103 = u10;
    u10 = Serial.addUInt32(u10, 1);
    u11[u103] = {
        Model = u99,
        MoverId = u101.MoverId,
        Revision = u101.Revision
    };
    task.delay(1, function() -- Line: 496
        -- upvalues: u11 (ref), u103 (copy), u99 (copy), u101 (copy), u60 (ref)
        local v104 = u11[u103];

        if v104 == nil or (v104.Model ~= u99 or v104.Revision ~= u101.Revision) then
            return;
        end;

        u11[u103] = nil;
        u60:rejectDoorPrediction(v104.MoverId, v104.Revision);
    end);

    return {
        ServerTick = u101.ServerTick,
        TargetAngle = u101.TargetAngle,
        RequestId = u103
    }, nil;
end;

function u1.Initialize() -- Line: 507
    -- upvalues: u3 (ref), Controls (copy), moveCharacter (copy), u60 (copy), u5 (ref), ClientCharacterPresentation (copy), Remotes (copy), u11 (copy), DiagnosticProtocol (copy), LocalPlayer (copy), CharacterResolver (copy), observeCharacterReady (copy), u2 (ref), Sound (copy), Players (copy), HitFlinch (copy)
    if u3 then
        return;
    end;

    u3 = true;
    Controls.moveFunction = moveCharacter;
    u60:start();
    u5 = true;
    ClientCharacterPresentation.ObserveLocalPlayer();
    Remotes.BreakableDoor.Resolved.Listen(function(p105) -- Line: 518
        -- upvalues: u11 (ref), u60 (ref), DiagnosticProtocol (ref), LocalPlayer (ref)
        local v106 = u11[p105.RequestId];

        if v106 == nil or p105.Model ~= v106.Model then
            return;
        end;

        u11[p105.RequestId] = nil;

        if p105.Accepted then
            return;
        end;

        local v107, v108 = u60:rejectDoorPrediction(v106.MoverId, v106.Revision);

        if not v107 then
            local v109 = `[MovementV2] could not reject speculative door use: {v108 or "Unknown"}`;

            if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
                warn(v109);
            end;
        end;
    end);
    CharacterResolver.observeCharacter(LocalPlayer, function(p110) -- Line: 533
        -- upvalues: observeCharacterReady (ref)
        if p110 == nil then
            return nil;
        end;

        return observeCharacterReady(p110);
    end);
    Remotes.Character.CharacterDamaged.Listen(function(p111) -- Line: 537
        -- upvalues: LocalPlayer (ref), u2 (ref), Sound (ref), Players (ref), HitFlinch (ref)
        if p111.VictimUserId == LocalPlayer.UserId then
            if u2 ~= nil then
                Sound.new("Character"):playOneTime({
                    Name = "Character Damaged",
                    Parent = LocalPlayer.PlayerGui
                });
            end;

            return;
        end;

        if p111.Melee == true or p111.Direction == nil then
            return;
        end;

        local PlayerByUserId = Players:GetPlayerByUserId(p111.VictimUserId);
        local v112;

        if PlayerByUserId == nil then
            v112 = nil;
        else
            v112 = PlayerByUserId.Character;
        end;

        if v112 ~= nil then
            if p111.Headshot == true then
                HitFlinch.flickHead(v112, p111.Direction);

                return;
            end;

            HitFlinch.flinchBody(v112, p111.Direction);
        end;
    end);
end;

function u1.Start() -- Line: 562
    -- upvalues: u4 (ref), Router (copy), u1 (copy)
    if u4 then
        return;
    end;

    u4 = true;
    Router.observerRouter("Plant Bomb", u1.PlantBomb);
    Router.observerRouter("Cancel Bomb Plant", u1.CancelBombPlant);
    Router.observerRouter("GetCurrentCharacter", u1.getCurrentCharacter);
    Router.observerRouter("GetRemoteViewTick", u1.GetRemoteViewTick);
end;

return u1;