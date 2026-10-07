-- ReplicatedStorage.Controllers.NetStatsController
-- Script path: ReplicatedStorage.Controllers.NetStatsController
-- Decompile time: 12.38 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local DiagnosticProtocol = require(ReplicatedStorage.MovementV2.DiagnosticProtocol)
local PredictionErrorSmoother = require(ReplicatedStorage.MovementV2.Client.PredictionErrorSmoother)
local v1 = {}

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
        RemovedActorRecords = 0,
    }
end

local u22 = false
local u23 = nil
local u24 = {
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
    RemovedActorRecords = 0,
}
local u25 = {
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
    RemovedActorRecords = 0,
}
local u27 = os.clock()
local u28 = 0
local u29 = 0
local u30 = 0
local u31 = 0
local u32 = 0
local u33 = 0
local u34 = nil
local u35 = 0

local function resetMovementSession(a1) -- Line: 81
    -- upvalues: u23 (ref), u24 (ref), u25 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref)
    -- upvalues: u33 (ref), u34 (ref), u35 (ref)
    u23 = a1
    u24 = {
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
        RemovedActorRecords = 0,
    }
    u25 = {
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
        RemovedActorRecords = 0,
    }
    u27 = os.clock()
    u28 = 0
    u29 = 0
    u30 = 0
    u31 = 0
    u32 = 0
    u33 = 0
    u34 = nil
    u35 = 0
end

local function networkWindow(a1) -- Line: 96 -- upvalues: u27 (ref), u24 (ref), u25 (ref) -- types: a1: number
    local v1 = a1 - u27
    if v1 >= 1 then
        u24.DurationSeconds = v1
        u25 = u24
        u24 = {
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
            RemovedActorRecords = 0,
        }
        u27 = a1
    end
    return u25
end

local function observeGeneration(a1) -- Line: 107
    -- upvalues: u23 (ref), u24 (ref), u25 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref)
    -- upvalues: u33 (ref), u34 (ref), u35 (ref)
    if u23 ~= a1 then
        u23 = a1
        u24 = {
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
            RemovedActorRecords = 0,
        }
        u25 = {
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
            RemovedActorRecords = 0,
        }
        u27 = os.clock()
        u28 = 0
        u29 = 0
        u30 = 0
        u31 = 0
        u32 = 0
        u33 = 0
        u34 = nil
        u35 = 0
    end
end

local function updateNetworkDiagnostics(a1) -- Line: 113
    -- upvalues: u27 (ref), u24 (ref), u25 (ref), DiagnosticProtocol (val), LocalPlayer (val), u28 (ref)
    local v1 = a1 - u27
    if v1 >= 1 then
        u24.DurationSeconds = v1
        u25 = u24
        u24 = {
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
            RemovedActorRecords = 0,
        }
        u27 = a1
    end
    local v2 = u25
    v1 = math.max(v2.DurationSeconds, 1)
    local v3 = v2.FullActorRecords + v2.DeltaActorRecords + v2.RemovedActorRecords
    local v4 = if not (v3 > 0) then 0 else v2.RemoteRxBytes / v3
    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer)
        and 5 <= a1 - u28
        and 0 < v2.RemotePackets + v2.OwnerPackets + v2.CommandPackets then
        u28 = a1
        print(string.format(
            "[MovementV2.Network] player=%s remoteRxKiBps=%.3f ownerRxKiBps=%.3f commandTxKiBps=%.3f packets=%d/%d/%d recovery=%d remoteRecords=%d/%d/%d wireBytesPerRecord=%.2f",
            LocalPlayer.Name,
            v2.RemoteRxBytes / v1 / 1024,
            v2.OwnerRxBytes / v1 / 1024,
            v2.CommandTxBytes / v1 / 1024,
            v2.RemotePackets,
            v2.OwnerPackets,
            v2.CommandPackets,
            v2.RecoveryPackets,
            v2.FullActorRecords,
            v2.DeltaActorRecords,
            v2.RemovedActorRecords,
            v4
        ))
    end
end

function v1.ObserveOwnerSnapshot(a1, a2, a3) -- Line: 145
    -- upvalues: u23 (ref), u24 (ref), u25 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref)
    -- upvalues: u33 (ref), u34 (ref), u35 (ref), updateNetworkDiagnostics (val)
    if u23 ~= a1 then
        u23 = a1
        u24 = {
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
            RemovedActorRecords = 0,
        }
        u25 = {
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
            RemovedActorRecords = 0,
        }
        u27 = os.clock()
        u28 = 0
        u29 = 0
        u30 = 0
        u31 = 0
        u32 = 0
        u33 = 0
        u34 = nil
        u35 = 0
    end
    if a3 ~= nil and typeof(a3.Bytes) == "number" then
        local v1 = u24
        v1.OwnerRxBytes = v1.OwnerRxBytes + math.max(0, a3.Bytes)
        v1 = u24
        v1.OwnerPackets = v1.OwnerPackets + 1
    end
    updateNetworkDiagnostics(os.clock())
end

function v1.ObserveRemoteSnapshot(a1, a2, a3) -- Line: 155
    -- upvalues: u23 (ref), u24 (ref), u25 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref)
    -- upvalues: u33 (ref), u34 (ref), u35 (ref), updateNetworkDiagnostics (val)
    if u23 ~= a1 then
        u23 = a1
        u24 = {
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
            RemovedActorRecords = 0,
        }
        u25 = {
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
            RemovedActorRecords = 0,
        }
        u27 = os.clock()
        u28 = 0
        u29 = 0
        u30 = 0
        u31 = 0
        u32 = 0
        u33 = 0
        u34 = nil
        u35 = 0
    end
    if a3 ~= nil and typeof(a3.Bytes) == "number" then
        local v1 = u24
        v1.RemoteRxBytes = v1.RemoteRxBytes + math.max(0, a3.Bytes)
        v1 = u24
        v1.RemotePackets = v1.RemotePackets + 1
        v1 = u24
        v1.FullActorRecords = v1.FullActorRecords + (a3.FullActorCount or 0)
        v1 = u24
        v1.DeltaActorRecords = v1.DeltaActorRecords + (a3.DeltaActorCount or 0)
        v1 = u24
        v1.RemovedActorRecords = v1.RemovedActorRecords + (a3.RemovedActorCount or 0)
    end
    updateNetworkDiagnostics(os.clock())
end

function v1.ObserveCommandPacket(a1, a2, a3) -- Line: 167
    -- upvalues: u23 (ref), u24 (ref), u25 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref)
    -- upvalues: u33 (ref), u34 (ref), u35 (ref), updateNetworkDiagnostics (val)
    if u23 ~= a1 then
        u23 = a1
        u24 = {
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
            RemovedActorRecords = 0,
        }
        u25 = {
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
            RemovedActorRecords = 0,
        }
        u27 = os.clock()
        u28 = 0
        u29 = 0
        u30 = 0
        u31 = 0
        u32 = 0
        u33 = 0
        u34 = nil
        u35 = 0
    end
    local v1 = u24
    v1.CommandTxBytes = v1.CommandTxBytes + math.max(0, a2)
    v1 = u24
    v1.CommandPackets = v1.CommandPackets + 1
    if a3 then
        v1 = u24
        v1.RecoveryPackets = v1.RecoveryPackets + 1
    end
    updateNetworkDiagnostics(os.clock())
end

function v1.ObserveReconciliation(a1, a2) -- Line: 177
    -- upvalues: u23 (ref), u24 (ref), u25 (ref), u27 (ref), u28 (ref), u29 (ref), u30 (ref), u31 (ref), u32 (ref)
    -- upvalues: u33 (ref), u34 (ref), u35 (ref), PredictionErrorSmoother (val), DiagnosticProtocol (val)
    -- upvalues: LocalPlayer (val)
    local v1, v2
    local Mapping = a2.Mapping
    if Mapping ~= nil then
        local Generation = Mapping.Generation
        if u23 ~= Generation then
            u23 = Generation
            u24 = {
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
                RemovedActorRecords = 0,
            }
            u25 = {
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
                RemovedActorRecords = 0,
            }
            u27 = os.clock()
            u28 = 0
            u29 = 0
            u30 = 0
            u31 = 0
            u32 = 0
            u33 = 0
            u34 = nil
            u35 = 0
        end
    end
    local v3 = a1.ReconciliationMode ~= "Reuse"
    if v3 then
        v3 = false
        if a1.ComparedAtAck == true then
            v3 = true
            if not (0.01 <= a1.Position) then
                v3 = true
                if not (0.1 <= a1.Velocity) then
                    v3 = true
                    if not (0.01 <= a1.SupportAnchor) then
                        v3 = true
                        if not (0.1 <= a1.SupportVelocity) then
                            v3 = true
                            if not (0 < a1.SupportKindMismatch) then
                                v3 = 0 < a1.SupportSourceMismatch
                            end
                        end
                    end
                end
            end
        end
    end
    local v4 = v2
    if v4 then
        v4 = false
        if a1.ComparedAtAck == true then
            v4 = v3
            if not v4 then
                v4 = true
                if not (0.004363323129985824 <= a1.LookYaw) then
                    v4 = true
                    if not (0.004363323129985824 <= a1.VerticalLook) then
                        v4 = true
                        if not (0.01 <= a1.DuckAmount) then
                            v4 = 0.01 <= a1.Stamina
                        end
                    end
                end
            end
        end
    end
    local v5 = false
    if a1.TailCompared == true then
        v5 = true
        if not (0.01 <= a1.TailPosition) then
            v5 = true
            if not (0.1 <= a1.TailVelocity) then
                v5 = true
                if not (0.01 <= a1.TailSupportAnchor) then
                    v5 = true
                    if not (0.1 <= a1.TailSupportVelocity) then
                        v5 = true
                        if not (0 < a1.TailSupportKindMismatch) then
                            v5 = true
                            if not (0 < a1.TailSupportSourceMismatch) then
                                v5 = true
                                if a1.TailGroundMismatch ~= true then
                                    v5 = a1.TailStanceMismatch == true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local v6 = v4 or v5
    if v6 then
        u29 = u29 + 1
    end
    local v7 = false
    if a1.TailCompared == true then
        v7 = PredictionErrorSmoother.isHardSnapCorrection(a1)
    end
    if v7 then
        u31 = u31 + 1
    end
    local v8 = bit32.band(a1.CanonicalStateMismatchMask or 0, 4071648) ~= 0
    local v9 = true
    if a1.ReplayBarrier ~= "AcceptedWorldChange" then
        v9 = true
        if a1.ReplayBarrier ~= "MoverRevision" then
            v9 = a1.ReplayBarrier == "DestructibleRevision"
        end
    end
    local v10 = true
    if a1.SynthesizedInput ~= true then
        v10 = 0 < (a1.ServerHeldTickCount or 0)
    end
    local v11 = a1.PlayerContactCorrection == true
    if not v4 then
        if not v5 or v9 or v10 then
            v1 = v8
            if not v1 then
                v1 = true
                if not (0 < a1.SupportKindMismatch) then
                    v1 = 0 < a1.SupportSourceMismatch
                end
            end
        else
            v1 = not v11
            if not v1 then
                v1 = v8
                if not v1 then
                    v1 = true
                    if not (0 < a1.SupportKindMismatch) then
                        v1 = 0 < a1.SupportSourceMismatch
                    end
                end
            end
        end
    elseif not v10 then
        v1 = not v11
        if not v1 then
            if not v5 or v9 or v10 then
                v1 = v8
                if not v1 then
                    v1 = true
                    if not (0 < a1.SupportKindMismatch) then
                        v1 = 0 < a1.SupportSourceMismatch
                    end
                end
            else
                v1 = not v11
                if not v1 then
                    v1 = v8
                    if not v1 then
                        v1 = true
                        if not (0 < a1.SupportKindMismatch) then
                            v1 = 0 < a1.SupportSourceMismatch
                        end
                    end
                end
            end
        end
    elseif not v5 or v9 or v10 then
        v1 = v8
        if not v1 then
            v1 = true
            if not (0 < a1.SupportKindMismatch) then
                v1 = 0 < a1.SupportSourceMismatch
            end
        end
    else
        v1 = not v11
        if not v1 then
            v1 = v8
            if not v1 then
                v1 = true
                if not (0 < a1.SupportKindMismatch) then
                    v1 = 0 < a1.SupportSourceMismatch
                end
            end
        end
    end
    if v1 then
        u30 = u30 + 1
    end
    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
        if v6 or v1 or v7 then
            local v12 = warn
            local format = string.format
            local Name = LocalPlayer.Name
            local v13 = tostring(v6)
            local v14 = tostring(v1)
            local v15 = tostring(v7)
            local v16 = if Mapping ~= nil then tostring(Mapping.Generation) else "nil"
            local v17 = tostring(a2.ServerTick)
            local v18 = tostring(a1.ReconciliationMode)
            local v19 = tostring(a1.ReplayBarrier)
            local v20 = a1.ReplayCount or 0
            local v21 = a1.ServerHeldTickCount or 0
            local v22 = tostring(a1.SynthesizedInput == true)
            local v23 = tostring(a1.PlayerContactCorrection == true)
            local v24 = a1.CanonicalStateMismatchMask or 0
            local v25 = a1.Position or 0
            local v26 = a1.Velocity or 0
            local v27 = a1.TailPosition or 0
            local v28 = a1.TailVelocity or 0
            local v29 = a1.TailServerTickDelta or 0
            local v30 = tostring(a1.TailGroundMismatch == true)
            local v31 = tostring(a1.TailStanceMismatch == true)
            local v32 = a1.SupportKindMismatch or 0
            local v33 = a1.SupportSourceMismatch or 0
            local v34 = a1.TailSupportKindMismatch or 0
            v12(format(
                "[MovementV2.LocalCounter] player=%s correction=%s desync=%s snap=%s totals=%d/%d/%d generation=%s tick=%s mode=%s barrier=%s replay=%d held=%d synth=%s contact=%s mismatch=0x%X ackPos=%.8f ackVel=%.8f tailPos=%.8f tailVel=%.8f tailTickDelta=%d tailGround=%s tailStance=%s supportMismatch=%d/%d tailSupportMismatch=%d/%d",
                Name,
                v13,
                v14,
                v15,
                u29,
                u30,
                u31,
                v16,
                v17,
                v18,
                v19,
                v20,
                v21,
                v22,
                v23,
                v24,
                v25,
                v26,
                v27,
                v28,
                v29,
                v30,
                v31,
                v32,
                v33,
                v34,
                a1.TailSupportSourceMismatch or 0
            ))
        end
    end
end

function v1.ObservePresentation(a1) -- Line: 280
    -- upvalues: DiagnosticProtocol (val), LocalPlayer (val), u34 (ref), u33 (ref), u35 (ref)
    if not DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
        return
    end
    local v1 = a1.LocalPlayerContactCritical == true
    local v2 = u34
    u34 = v1
    if v2 ~= nil and v2 ~= v1 then
        u33 = u33 + 1
        local v3 = os.clock()
        if v3 - u35 >= 0.25 then
            u35 = v3
            print(string.format(
                "[MovementV2.Client] PRESENTATION collisionRoot=%s tick=%s fraction=%.4f status=%s reason=%s modeSwitches=%d",
                if not v1 then "interpolated" else "exact",
                if a1.ServerTick ~= nil then tostring(a1.ServerTick) else "nil",
                a1.TickFraction or 0,
                tostring(a1.Status),
                tostring(a1.Reason),
                u33
            ))
        end
        return
    end
end

function v1.ObservePredictionHitch(a1) -- Line: 308 -- upvalues: u32 (ref), DiagnosticProtocol (val), LocalPlayer (val)
    u32 = u32 + 1
    if DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) then
        warn(string.format(
            "[MovementV2.LocalCounter] player=%s hitch=true total=%d tick=%s frameMs=%.3f discardedMs=%.3f backlogBeforeMs=%.3f backlogAfterMs=%.3f drained=%d guaranteed=%d hardCap=%d predictionWorkMs=%.3f ownerAgeMs=%.3f status=%s",
            LocalPlayer.Name,
            u32,
            tostring(a1.ServerTick),
            (a1.FrameSeconds or 0) * 1000,
            (a1.DiscardedSeconds or 0) * 1000,
            (a1.BacklogBeforeSeconds or 0) * 1000,
            (a1.BacklogAfterSeconds or 0) * 1000,
            a1.StepsDrained or 0,
            a1.GuaranteedStepBudget or 0,
            a1.StepBudget or 0,
            (a1.PredictionWorkSeconds or 0) * 1000,
            (a1.OwnerSnapshotAgeSeconds or 0) * 1000,
            (tostring(a1.Status))
        ))
    end
end

function v1.Initialize() -- Line: 332 -- upvalues: u22 (ref), LocalPlayer (val)
    if u22 then
        return
    end
    u22 = true
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local TemporaryNetStats = if PlayerGui ~= nil then PlayerGui:FindFirstChild("TemporaryNetStats", true) else nil
    if TemporaryNetStats ~= nil then
        TemporaryNetStats:Destroy()
    end
end

return v1