-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local DiagnosticProtocol = require(ReplicatedStorage.MovementV2.DiagnosticProtocol);
local PredictionErrorSmoother = require(ReplicatedStorage.MovementV2.Client.PredictionErrorSmoother);
local v1 = {};

local function emptyNetworkWindow() -- Line: 50
    return {
        DurationSeconds = 0,
        RemoteRxBytes = 0,
        OwnerRxBytes = 0,
        CommandTxBytes = 0,
        RemotePackets = 0,
        OwnerPackets = 0,
        CommandPackets = 0,
        RecoveryPackets = 0,
        FullActorRecords = 0,
        DeltaActorRecords = 0,
        RemovedActorRecords = 0
    };
end;

local u2 = false;
local u3 = nil;
local u4 = {
    DurationSeconds = 0,
    RemoteRxBytes = 0,
    OwnerRxBytes = 0,
    CommandTxBytes = 0,
    RemotePackets = 0,
    OwnerPackets = 0,
    CommandPackets = 0,
    RecoveryPackets = 0,
    FullActorRecords = 0,
    DeltaActorRecords = 0,
    RemovedActorRecords = 0
};
local u5 = {
    DurationSeconds = 0,
    RemoteRxBytes = 0,
    OwnerRxBytes = 0,
    CommandTxBytes = 0,
    RemotePackets = 0,
    OwnerPackets = 0,
    CommandPackets = 0,
    RecoveryPackets = 0,
    FullActorRecords = 0,
    DeltaActorRecords = 0,
    RemovedActorRecords = 0
};
local os_clock_ret = os.clock();
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = 0;
local u10 = 0;
local u11 = 0;
local u12 = nil;
local u13 = 0;

local function resetMovementSession(p14: number) -- Line: 81
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), os_clock_ret (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    u3 = p14;
    u4 = {
        DurationSeconds = 0,
        RemoteRxBytes = 0,
        OwnerRxBytes = 0,
        CommandTxBytes = 0,
        RemotePackets = 0,
        OwnerPackets = 0,
        CommandPackets = 0,
        RecoveryPackets = 0,
        FullActorRecords = 0,
        DeltaActorRecords = 0,
        RemovedActorRecords = 0
    };
    u5 = {
        DurationSeconds = 0,
        RemoteRxBytes = 0,
        OwnerRxBytes = 0,
        CommandTxBytes = 0,
        RemotePackets = 0,
        OwnerPackets = 0,
        CommandPackets = 0,
        RecoveryPackets = 0,
        FullActorRecords = 0,
        DeltaActorRecords = 0,
        RemovedActorRecords = 0
    };
    os_clock_ret = os.clock();
    u6 = 0;
    u7 = 0;
    u8 = 0;
    u9 = 0;
    u10 = 0;
    u11 = 0;
    u12 = nil;
    u13 = 0;
end;

local function networkWindow(p15: number) -- Line: 96
    -- upvalues: os_clock_ret (ref), u4 (ref), u5 (ref)
    local v16 = p15 - os_clock_ret;

    if v16 >= 1 then
        u4.DurationSeconds = v16;
        u5 = u4;
        u4 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        os_clock_ret = p15;
    end;

    return u5;
end;

local function observeGeneration(p17: number) -- Line: 107
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), os_clock_ret (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref)
    if u3 ~= p17 then
        u3 = p17;
        u4 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        u5 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        os_clock_ret = os.clock();
        u6 = 0;
        u7 = 0;
        u8 = 0;
        u9 = 0;
        u10 = 0;
        u11 = 0;
        u12 = nil;
        u13 = 0;
    end;
end;

local function updateNetworkDiagnostics(p18: number) -- Line: 113
    -- upvalues: os_clock_ret (ref), u4 (ref), u5 (ref), DiagnosticProtocol (copy), LocalPlayer (copy), u6 (ref)
    local v19 = p18 - os_clock_ret;

    if v19 >= 1 then
        u4.DurationSeconds = v19;
        u5 = u4;
        u4 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        os_clock_ret = p18;
    end;

    local v20 = u5;
    local math_max_ret = math.max(v20.DurationSeconds, 1);
    local v21 = v20.FullActorRecords + v20.DeltaActorRecords + v20.RemovedActorRecords;
    local v22 = v21 <= 0 and 0 or v20.RemoteRxBytes / v21;

    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and (p18 - u6 >= 5 and v20.RemotePackets + v20.OwnerPackets + v20.CommandPackets > 0) then
        u6 = p18;
        print(string.format("[MovementV2.Network] player=%s remoteRxKiBps=%.3f ownerRxKiBps=%.3f commandTxKiBps=%.3f packets=%d/%d/%d recovery=%d remoteRecords=%d/%d/%d wireBytesPerRecord=%.2f", LocalPlayer.Name, v20.RemoteRxBytes / math_max_ret / 1024, v20.OwnerRxBytes / math_max_ret / 1024, v20.CommandTxBytes / math_max_ret / 1024, v20.RemotePackets, v20.OwnerPackets, v20.CommandPackets, v20.RecoveryPackets, v20.FullActorRecords, v20.DeltaActorRecords, v20.RemovedActorRecords, v22));
    end;
end;

function v1.ObserveOwnerSnapshot(p23: number, p24: number, p25: any) -- Line: 145
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), os_clock_ret (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), updateNetworkDiagnostics (copy)
    if u3 ~= p23 then
        u3 = p23;
        u4 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        u5 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        os_clock_ret = os.clock();
        u6 = 0;
        u7 = 0;
        u8 = 0;
        u9 = 0;
        u10 = 0;
        u11 = 0;
        u12 = nil;
        u13 = 0;
    end;

    if p25 ~= nil and typeof(p25.Bytes) == "number" then
        local v26 = u4;
        v26.OwnerRxBytes = v26.OwnerRxBytes + math.max(0, p25.Bytes);
        local v27 = u4;
        v27.OwnerPackets = v27.OwnerPackets + 1;
    end;

    updateNetworkDiagnostics(os.clock());
end;

function v1.ObserveRemoteSnapshot(p28: number, p29: number, p30: any) -- Line: 155
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), os_clock_ret (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), updateNetworkDiagnostics (copy)
    if u3 ~= p28 then
        u3 = p28;
        u4 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        u5 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        os_clock_ret = os.clock();
        u6 = 0;
        u7 = 0;
        u8 = 0;
        u9 = 0;
        u10 = 0;
        u11 = 0;
        u12 = nil;
        u13 = 0;
    end;

    if p30 ~= nil and typeof(p30.Bytes) == "number" then
        local v31 = u4;
        v31.RemoteRxBytes = v31.RemoteRxBytes + math.max(0, p30.Bytes);
        local v32 = u4;
        v32.RemotePackets = v32.RemotePackets + 1;
        local v33 = u4;
        v33.FullActorRecords = v33.FullActorRecords + (p30.FullActorCount or 0);
        local v34 = u4;
        v34.DeltaActorRecords = v34.DeltaActorRecords + (p30.DeltaActorCount or 0);
        local v35 = u4;
        v35.RemovedActorRecords = v35.RemovedActorRecords + (p30.RemovedActorCount or 0);
    end;

    updateNetworkDiagnostics(os.clock());
end;

function v1.ObserveCommandPacket(p36: number, p37: number, p38: boolean) -- Line: 167
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), os_clock_ret (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), updateNetworkDiagnostics (copy)
    if u3 ~= p36 then
        u3 = p36;
        u4 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        u5 = {
            DurationSeconds = 0,
            RemoteRxBytes = 0,
            OwnerRxBytes = 0,
            CommandTxBytes = 0,
            RemotePackets = 0,
            OwnerPackets = 0,
            CommandPackets = 0,
            RecoveryPackets = 0,
            FullActorRecords = 0,
            DeltaActorRecords = 0,
            RemovedActorRecords = 0
        };
        os_clock_ret = os.clock();
        u6 = 0;
        u7 = 0;
        u8 = 0;
        u9 = 0;
        u10 = 0;
        u11 = 0;
        u12 = nil;
        u13 = 0;
    end;

    local v39 = u4;
    v39.CommandTxBytes = v39.CommandTxBytes + math.max(0, p37);
    local v40 = u4;
    v40.CommandPackets = v40.CommandPackets + 1;

    if p38 then
        local v41 = u4;
        v41.RecoveryPackets = v41.RecoveryPackets + 1;
    end;

    updateNetworkDiagnostics(os.clock());
end;

function v1.ObserveReconciliation(p42, p43) -- Line: 177
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), os_clock_ret (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), PredictionErrorSmoother (copy), DiagnosticProtocol (copy), LocalPlayer (copy)
    local Mapping = p43.Mapping;

    if Mapping ~= nil then
        local Generation = Mapping.Generation;

        if u3 ~= Generation then
            u3 = Generation;
            u4 = {
                DurationSeconds = 0,
                RemoteRxBytes = 0,
                OwnerRxBytes = 0,
                CommandTxBytes = 0,
                RemotePackets = 0,
                OwnerPackets = 0,
                CommandPackets = 0,
                RecoveryPackets = 0,
                FullActorRecords = 0,
                DeltaActorRecords = 0,
                RemovedActorRecords = 0
            };
            u5 = {
                DurationSeconds = 0,
                RemoteRxBytes = 0,
                OwnerRxBytes = 0,
                CommandTxBytes = 0,
                RemotePackets = 0,
                OwnerPackets = 0,
                CommandPackets = 0,
                RecoveryPackets = 0,
                FullActorRecords = 0,
                DeltaActorRecords = 0,
                RemovedActorRecords = 0
            };
            os_clock_ret = os.clock();
            u6 = 0;
            u7 = 0;
            u8 = 0;
            u9 = 0;
            u10 = 0;
            u11 = 0;
            u12 = nil;
            u13 = 0;
        end;
    end;

    local v44 = p42.ReconciliationMode ~= "Reuse";
    local v45;

    if v44 then
        if p42.ComparedAtAck == true then
            v45 = (p42.Position >= 0.01 or (p42.Velocity >= 0.1 or (p42.SupportAnchor >= 0.01 or (p42.SupportVelocity >= 0.1 or p42.SupportKindMismatch > 0)))) and true or p42.SupportSourceMismatch > 0;
        else
            v45 = false;
        end;
    else
        v45 = v44;
    end;

    if v44 then
        if p42.ComparedAtAck == true then
            v44 = v45 or ((p42.LookYaw >= 0.004363323129985824 or (p42.VerticalLook >= 0.004363323129985824 or p42.DuckAmount >= 0.01)) and true or p42.Stamina >= 0.01);
        else
            v44 = false;
        end;
    end;

    local v46;

    if p42.TailCompared == true then
        v46 = (p42.TailPosition >= 0.01 or (p42.TailVelocity >= 0.1 or (p42.TailSupportAnchor >= 0.01 or (p42.TailSupportVelocity >= 0.1 or (p42.TailSupportKindMismatch > 0 or (p42.TailSupportSourceMismatch > 0 or p42.TailGroundMismatch == true)))))) and true or p42.TailStanceMismatch == true;
    else
        v46 = false;
    end;

    local v47 = v44 or v46;

    if v47 then
        u7 = u7 + 1;
    end;

    local v48;

    if p42.TailCompared == true then
        v48 = PredictionErrorSmoother.isHardSnapCorrection(p42);
    else
        v48 = false;
    end;

    if v48 then
        u9 = u9 + 1;
    end;

    local v49 = bit32.band(p42.CanonicalStateMismatchMask or 0, 4071648) ~= 0;
    local v50 = p42.SynthesizedInput == true and true or (p42.ServerHeldTickCount or 0) > 0;
    local v51 = p42.PlayerContactCorrection == true;
    local v52 = v44 and not v50 and not v51 or (v46 and not ((p42.ReplayBarrier == "AcceptedWorldChange" or p42.ReplayBarrier == "MoverRevision") and true or p42.ReplayBarrier == "DestructibleRevision" or v50) and not v51 or (v49 or (p42.SupportKindMismatch > 0 and true or p42.SupportSourceMismatch > 0)));

    if v52 then
        u8 = u8 + 1;
    end;

    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and (v47 or (v52 or v48)) then
        warn(string.format("[MovementV2.LocalCounter] player=%s correction=%s desync=%s snap=%s totals=%d/%d/%d generation=%s tick=%s mode=%s barrier=%s replay=%d held=%d synth=%s contact=%s mismatch=0x%X ackPos=%.8f ackVel=%.8f tailPos=%.8f tailVel=%.8f tailTickDelta=%d tailGround=%s tailStance=%s supportMismatch=%d/%d tailSupportMismatch=%d/%d", LocalPlayer.Name, tostring(v47), tostring(v52), tostring(v48), u7, u8, u9, Mapping == nil and "nil" or tostring(Mapping.Generation), tostring(p43.ServerTick), tostring(p42.ReconciliationMode), tostring(p42.ReplayBarrier), p42.ReplayCount or 0, p42.ServerHeldTickCount or 0, tostring(p42.SynthesizedInput == true), tostring(p42.PlayerContactCorrection == true), p42.CanonicalStateMismatchMask or 0, p42.Position or 0, p42.Velocity or 0, p42.TailPosition or 0, p42.TailVelocity or 0, p42.TailServerTickDelta or 0, tostring(p42.TailGroundMismatch == true), tostring(p42.TailStanceMismatch == true), p42.SupportKindMismatch or 0, p42.SupportSourceMismatch or 0, p42.TailSupportKindMismatch or 0, p42.TailSupportSourceMismatch or 0));
    end;
end;

function v1.ObservePresentation(p53) -- Line: 280
    -- upvalues: DiagnosticProtocol (copy), LocalPlayer (copy), u12 (ref), u11 (ref), u13 (ref)
    if not DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
        return;
    end;

    local v54 = p53.LocalPlayerContactCritical == true;
    local v55 = u12;
    u12 = v54;

    if v55 == nil or v55 == v54 then
        return;
    end;

    u11 = u11 + 1;
    local os_clock_ret2 = os.clock();

    if os_clock_ret2 - u13 >= 0.25 then
        u13 = os_clock_ret2;
        print(string.format("[MovementV2.Client] PRESENTATION collisionRoot=%s tick=%s fraction=%.4f status=%s reason=%s modeSwitches=%d", v54 and "exact" or "interpolated", p53.ServerTick == nil and "nil" or tostring(p53.ServerTick), p53.TickFraction or 0, tostring(p53.Status), tostring(p53.Reason), u11));
    end;
end;

function v1.ObservePredictionHitch(p56) -- Line: 308
    -- upvalues: u10 (ref), DiagnosticProtocol (copy), LocalPlayer (copy)
    u10 = u10 + 1;

    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
        warn(string.format("[MovementV2.LocalCounter] player=%s hitch=true total=%d tick=%s frameMs=%.3f discardedMs=%.3f backlogBeforeMs=%.3f backlogAfterMs=%.3f drained=%d guaranteed=%d hardCap=%d predictionWorkMs=%.3f ownerAgeMs=%.3f status=%s", LocalPlayer.Name, u10, tostring(p56.ServerTick), (p56.FrameSeconds or 0) * 1000, (p56.DiscardedSeconds or 0) * 1000, (p56.BacklogBeforeSeconds or 0) * 1000, (p56.BacklogAfterSeconds or 0) * 1000, p56.StepsDrained or 0, p56.GuaranteedStepBudget or 0, p56.StepBudget or 0, (p56.PredictionWorkSeconds or 0) * 1000, (p56.OwnerSnapshotAgeSeconds or 0) * 1000, (tostring(p56.Status))));
    end;
end;

function v1.Initialize() -- Line: 332
    -- upvalues: u2 (ref), LocalPlayer (copy)
    if u2 then
        return;
    end;

    u2 = true;
    local v57 = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    local v58;

    if v57 == nil then
        v58 = nil;
    else
        v58 = v57:FindFirstChild("TemporaryNetStats", true);
    end;

    if v58 ~= nil then
        v58:Destroy();
    end;
end;

return v1;