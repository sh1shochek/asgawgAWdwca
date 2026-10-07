-- ReplicatedStorage.MovementV2.Client.CorrectionDiagnostics
-- Script path: ReplicatedStorage.MovementV2.Client.CorrectionDiagnostics
-- Decompile time: 4.21 ms

local State = require(script.Parent.Parent.Simulation.State)
local v1 = {}
local BaseMoveSpeed = State.fieldMask("BaseMoveSpeed")
local VelocityModifier = State.fieldMask("VelocityModifier")

local function stateMismatchMask(a1) -- Line: 25
    if typeof(a1.CanonicalStateMismatchMask) == "number" then
        return a1.CanonicalStateMismatchMask
    end
    return 0
end

local function hasBaseMoveSpeedMismatch(a1) -- Line: 29 -- upvalues: BaseMoveSpeed (val)
    return bit32.band(if typeof(a1.CanonicalStateMismatchMask) ~= "number" then 0 else a1.CanonicalStateMismatchMask, BaseMoveSpeed) ~= 0
end

local function stateNumber(a1, a2) -- Line: 33 -- types: a2: string
    if typeof(a1) == "table" and typeof(a1[a2]) == "number" then
        return a1[a2]
    end
    return nil
end

local function stateFieldLabel(a1) -- Line: 40 -- upvalues: State (val)
    return State.mismatchLabel(if typeof(a1.CanonicalStateMismatchMask) ~= "number" then 0 else a1.CanonicalStateMismatchMask)
end

function v1.classify(a1, a2, a3, a4) -- Line: 44
    -- upvalues: BaseMoveSpeed (val), stateFieldLabel (val), VelocityModifier (val), State (val)
    if a1.SynthesizedInput == true then
        return "PacketLossOrCommandGap: authority synthesized missing input; client and server did not simulate identical commands"
    end
    if 0 < (a1.ServerHeldTickCount or 0) then
        return "CommandStarvation: authority held movement while waiting for an unproven command frontier"
    end
    if a1.PlayerContactCorrection == true then
        return "RemotePlayerContactPhase: another player's causally-late pose affected collision prediction"
    end
    if a1.ReconciliationMode == "Reanchor" then
        return (("PredictionHistoryUnavailable: acknowledged command was absent from the client ring (barrier=%*)"):format(a1.ReplayBarrier))
    end
    if (a1.TopologyRevisionDelta or 0) ~= 0 then
        return (("TopologyTimelineMismatch: prediction and authority used destructible revisions %* apart"):format(a1.TopologyRevisionDelta))
    end
    if bit32.band(if typeof(a1.CanonicalStateMismatchMask) ~= "number" then 0 else a1.CanonicalStateMismatchMask, BaseMoveSpeed) ~= 0 then
        local BaseMoveSpeed_3 = if typeof(a2) ~= "table" then nil else if typeof(a2.BaseMoveSpeed) == "number" then a2.BaseMoveSpeed else nil
        local BaseMoveSpeed_5 = if typeof(a3) ~= "table" then nil else if typeof(a3.BaseMoveSpeed) == "number" then a3.BaseMoveSpeed else nil
        if BaseMoveSpeed_3 ~= nil and BaseMoveSpeed_5 ~= nil then
            local v1 = false
            if BaseMoveSpeed_5 <= 1e-05 then
                v1 = BaseMoveSpeed_3 > 1e-05
            end
            local v2 = false
            if BaseMoveSpeed_3 <= 1e-05 then
                v2 = BaseMoveSpeed_5 > 1e-05
            end
            if not v1 then
                if v2 then
                    return string.format(
                        "MovementUnlockDivergence: client BaseMoveSpeed=%.5f while authority had released to %.5f; inspect movementLockContext",
                        BaseMoveSpeed_3,
                        BaseMoveSpeed_5
                    )
                end
                return string.format(
                    "BaseMoveSpeedDivergence: client %.5f authority %.5f; fields=%s",
                    BaseMoveSpeed_3,
                    BaseMoveSpeed_5,
                    stateFieldLabel(a1)
                )
            end
            if a4 == nil then
                if a4 ~= nil then
                    if a4.LocalDefusing ~= true and a4.ReplicatedDefusing ~= true then
                        if a4 ~= nil and a4.ReplicatedRescuing == true then
                            return "HostageRescuePredictionGap: rescue lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                        end
                        if a4 == nil then
                            return string.format(
                                "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                                BaseMoveSpeed_5,
                                BaseMoveSpeed_3
                            )
                        end
                        if a4.GameStateAtSnapshot ~= "Buy Period" and a4.CurrentGameState ~= "Buy Period" then
                            return string.format(
                                "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                                BaseMoveSpeed_5,
                                BaseMoveSpeed_3
                            )
                        end
                        return "BuyPeriodPredictionGap: freeze time was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                    end
                    return "DefusePredictionGap: defuse lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                end
                if a4 ~= nil and a4.ReplicatedRescuing == true then
                    return "HostageRescuePredictionGap: rescue lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                end
                if a4 ~= nil then
                    if a4.GameStateAtSnapshot ~= "Buy Period" and a4.CurrentGameState ~= "Buy Period" then
                        return string.format(
                            "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                            BaseMoveSpeed_5,
                            BaseMoveSpeed_3
                        )
                    end
                    return "BuyPeriodPredictionGap: freeze time was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                end
                return string.format(
                    "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                    BaseMoveSpeed_5,
                    BaseMoveSpeed_3
                )
            end
            if a4.LocalPlanting ~= true and a4.ReplicatedPlanting ~= true then
                if a4 == nil then
                    if a4 ~= nil and a4.ReplicatedRescuing == true then
                        return "HostageRescuePredictionGap: rescue lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                    end
                    if a4 ~= nil then
                        if a4.GameStateAtSnapshot ~= "Buy Period" and a4.CurrentGameState ~= "Buy Period" then
                            return string.format(
                                "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                                BaseMoveSpeed_5,
                                BaseMoveSpeed_3
                            )
                        end
                        return "BuyPeriodPredictionGap: freeze time was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                    end
                    return string.format(
                        "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                        BaseMoveSpeed_5,
                        BaseMoveSpeed_3
                    )
                end
                if a4.LocalDefusing ~= true and a4.ReplicatedDefusing ~= true then
                    if a4 ~= nil and a4.ReplicatedRescuing == true then
                        return "HostageRescuePredictionGap: rescue lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                    end
                    if a4 == nil then
                        return string.format(
                            "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                            BaseMoveSpeed_5,
                            BaseMoveSpeed_3
                        )
                    end
                    if a4.GameStateAtSnapshot ~= "Buy Period" and a4.CurrentGameState ~= "Buy Period" then
                        return string.format(
                            "MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext",
                            BaseMoveSpeed_5,
                            BaseMoveSpeed_3
                        )
                    end
                    return "BuyPeriodPredictionGap: freeze time was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
                end
                return "DefusePredictionGap: defuse lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
            end
            return "BombPlantPredictionGap: planting lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed"
        end
    end
    if bit32.band(a1.CanonicalStateMismatchMask or 0, VelocityModifier) ~= 0 then
        local VelocityModifier_3 = if typeof(a2) ~= "table" then nil else if typeof(a2.VelocityModifier) == "number" then a2.VelocityModifier else nil
        local VelocityModifier_5 = if typeof(a3) ~= "table" then nil else if typeof(a3.VelocityModifier) == "number" then a3.VelocityModifier else nil
        if VelocityModifier_3 ~= nil and VelocityModifier_5 ~= nil then
            return string.format(
                "DamageTagTimelineDivergence: client velocity modifier %.6f authority %.6f; the predictable damage event was missing or late",
                VelocityModifier_3,
                VelocityModifier_5
            )
        end
    end
    if not (0 < (a1.SupportKindMismatch or 0)) and not (0 < (a1.SupportSourceMismatch or 0)) then
        if 0 < (a1.CanonicalStateMismatchCount or 0) then
            local mismatchLabel = State.mismatchLabel
            return (("DeterministicStateDivergence: identical command anchor differs in %*"):format((mismatchLabel(if typeof(a1.CanonicalStateMismatchMask) ~= "number" then 0 else a1.CanonicalStateMismatchMask))))
        end
        if a1.CanonicalSupportMismatch == true then
            return "SupportDivergence: support anchor or motion differs without an accompanying movement-state mismatch"
        end
        if a1.TailCompared ~= true then
            return "UnclassifiedReconciliation: inspect paired state, support, timing, movement-lock context, and trace evidence"
        end
        local TailPosition_2 = if typeof(a1.TailPosition) ~= "number" then 0 else a1.TailPosition
        local TailVelocity_2 = if typeof(a1.TailVelocity) ~= "number" then 0 else a1.TailVelocity
        if not (TailPosition_2 > 0)
            and not (TailVelocity_2 > 0)
            and not (0 < (a1.TailSupportKindMismatch or 0))
            and not (0 < (a1.TailSupportSourceMismatch or 0))
            and a1.TailGroundMismatch ~= true
            and a1.TailStanceMismatch ~= true then
            return "UnclassifiedReconciliation: inspect paired state, support, timing, movement-lock context, and trace evidence"
        end
        return "ReplayTailDivergence: the authoritative replay changed the live predicted tail"
    end
    return "SupportDivergence: client and authority selected different ground/support identity"
end

local function scalarLabel(a1) -- Line: 150
    if a1 == nil then
        return "nil"
    end
    if typeof(a1) ~= "number" then
        if typeof(a1) == "boolean" then
            return (tostring(a1))
        end
        return string.gsub(tostring(a1), "%s+", "_")
    end
    if a1 == a1 and (math.abs(a1)) < (1 / 0) then
        return (string.format("%.6f", a1))
    end
    return "invalid"
end

function v1.formatMovementLockContext(a1, a2) -- Line: 163
    -- upvalues: scalarLabel (val)
    if a1 == nil then
        return string.format("movementLockContext snapshotServerTime=%.6f unavailable=true", a2)
    end
    return string.format(
        "movementLockContext snapshotServerTime=%.6f gameStateAtSnapshot=%s gameStateNow=%s localPlantingNow=%s replicatedPlantingNow=%s plantLockAt=%s localDefusingNow=%s replicatedDefusingNow=%s replicatedRescuingNow=%s carryingHostageNow=%s",
        a2,
        scalarLabel(a1.GameStateAtSnapshot),
        scalarLabel(a1.CurrentGameState),
        scalarLabel(a1.LocalPlanting),
        scalarLabel(a1.ReplicatedPlanting),
        scalarLabel(a1.BombPlantMovementLockAt),
        scalarLabel(a1.LocalDefusing),
        scalarLabel(a1.ReplicatedDefusing),
        scalarLabel(a1.ReplicatedRescuing),
        scalarLabel(a1.CarryingHostage)
    )
end

return table.freeze(v1)