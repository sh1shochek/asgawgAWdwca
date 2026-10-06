-- Decompiled with Potassium's decompiler.

local State = require(script.Parent.Parent.Simulation.State);
local v1 = {};
local u2 = State.fieldMask("BaseMoveSpeed");
local u3 = State.fieldMask("VelocityModifier");

local function stateMismatchMask(p4) -- Line: 25
    return typeof(p4.CanonicalStateMismatchMask) ~= "number" and 0 or p4.CanonicalStateMismatchMask;
end;

local function hasBaseMoveSpeedMismatch(p5) -- Line: 29
    -- upvalues: u2 (copy)
    local v6 = typeof(p5.CanonicalStateMismatchMask) ~= "number" and 0 or p5.CanonicalStateMismatchMask;

    return bit32.band(v6, u2) ~= 0;
end;

local function stateNumber(p7: any, p8: string) -- Line: 33
    if typeof(p7) == "table" and typeof(p7[p8]) == "number" then
        return p7[p8];
    end;

    return nil;
end;

local function stateFieldLabel(p9) -- Line: 40
    -- upvalues: State (copy)
    return State.mismatchLabel(typeof(p9.CanonicalStateMismatchMask) ~= "number" and 0 or p9.CanonicalStateMismatchMask);
end;

function v1.classify(p10: any, p11: any, p12: any, p13: table?) -- Line: 44
    -- upvalues: u2 (copy), stateFieldLabel (copy), u3 (copy), State (copy)
    if p10.SynthesizedInput == true then
        return "PacketLossOrCommandGap: authority synthesized missing input; client and server did not simulate identical commands";
    end;

    if (p10.ServerHeldTickCount or 0) > 0 then
        return "CommandStarvation: authority held movement while waiting for an unproven command frontier";
    end;

    if p10.PlayerContactCorrection == true then
        return "RemotePlayerContactPhase: another player\'s causally-late pose affected collision prediction";
    end;

    if p10.ReconciliationMode == "Reanchor" then
        return `PredictionHistoryUnavailable: acknowledged command was absent from the client ring (barrier={p10.ReplayBarrier})`;
    end;

    if (p10.TopologyRevisionDelta or 0) ~= 0 then
        return `TopologyTimelineMismatch: prediction and authority used destructible revisions {p10.TopologyRevisionDelta} apart`;
    end;

    local v14 = typeof(p10.CanonicalStateMismatchMask) ~= "number" and 0 or p10.CanonicalStateMismatchMask;

    if bit32.band(v14, u2) ~= 0 then
        local v15;

        if typeof(p11) == "table" and typeof(p11.BaseMoveSpeed) == "number" then
            v15 = p11.BaseMoveSpeed;
        else
            v15 = nil;
        end;

        local v16;

        if typeof(p12) == "table" and typeof(p12.BaseMoveSpeed) == "number" then
            v16 = p12.BaseMoveSpeed;
        else
            v16 = nil;
        end;

        if v15 ~= nil and v16 ~= nil then
            local v17;

            if v16 <= 0.00001 then
                v17 = v15 > 0.00001;
            else
                v17 = false;
            end;

            local v18;

            if v15 <= 0.00001 then
                v18 = v16 > 0.00001;
            else
                v18 = false;
            end;

            if v17 then
                return p13 ~= nil and (p13.LocalPlanting == true or p13.ReplicatedPlanting == true) and "BombPlantPredictionGap: planting lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed" or (p13 ~= nil and (p13.LocalDefusing == true or p13.ReplicatedDefusing == true) and "DefusePredictionGap: defuse lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed" or (p13 ~= nil and p13.ReplicatedRescuing == true and "HostageRescuePredictionGap: rescue lock was active but the acknowledged client prediction retained nonzero BaseMoveSpeed" or (p13 ~= nil and (p13.GameStateAtSnapshot == "Buy Period" or p13.CurrentGameState == "Buy Period") and "BuyPeriodPredictionGap: freeze time was active but the acknowledged client prediction retained nonzero BaseMoveSpeed" or string.format("MovementLockDivergence: authority BaseMoveSpeed=%.5f while client predicted %.5f; inspect movementLockContext", v16, v15))));
            end;

            if v18 then
                return string.format("MovementUnlockDivergence: client BaseMoveSpeed=%.5f while authority had released to %.5f; inspect movementLockContext", v15, v16);
            end;

            return string.format("BaseMoveSpeedDivergence: client %.5f authority %.5f; fields=%s", v15, v16, stateFieldLabel(p10));
        end;
    end;

    if bit32.band(p10.CanonicalStateMismatchMask or 0, u3) ~= 0 then
        local v19;

        if typeof(p11) == "table" and typeof(p11.VelocityModifier) == "number" then
            v19 = p11.VelocityModifier;
        else
            v19 = nil;
        end;

        local v20;

        if typeof(p12) == "table" and typeof(p12.VelocityModifier) == "number" then
            v20 = p12.VelocityModifier;
        else
            v20 = nil;
        end;

        if v19 ~= nil and v20 ~= nil then
            return string.format("DamageTagTimelineDivergence: client velocity modifier %.6f authority %.6f; the predictable damage event was missing or late", v19, v20);
        end;
    end;

    if (p10.SupportKindMismatch or 0) > 0 or (p10.SupportSourceMismatch or 0) > 0 then
        return "SupportDivergence: client and authority selected different ground/support identity";
    end;

    if (p10.CanonicalStateMismatchCount or 0) > 0 then
        return `DeterministicStateDivergence: identical command anchor differs in {State.mismatchLabel(typeof(p10.CanonicalStateMismatchMask) ~= "number" and 0 or p10.CanonicalStateMismatchMask)}`;
    end;

    if p10.CanonicalSupportMismatch == true then
        return "SupportDivergence: support anchor or motion differs without an accompanying movement-state mismatch";
    end;

    if p10.TailCompared == true then
        local v21 = typeof(p10.TailPosition) ~= "number" and 0 or p10.TailPosition;
        local v22 = typeof(p10.TailVelocity) ~= "number" and 0 or p10.TailVelocity;

        if v21 > 0 or (v22 > 0 or ((p10.TailSupportKindMismatch or 0) > 0 or ((p10.TailSupportSourceMismatch or 0) > 0 or (p10.TailGroundMismatch == true or p10.TailStanceMismatch == true)))) then
            return "ReplayTailDivergence: the authoritative replay changed the live predicted tail";
        end;
    end;

    return "UnclassifiedReconciliation: inspect paired state, support, timing, movement-lock context, and trace evidence";
end;

local function scalarLabel(p23) -- Line: 150
    if p23 == nil then
        return "nil";
    end;

    if typeof(p23) == "number" then
        return (p23 ~= p23 or math.abs(p23) >= (1 / 0)) and "invalid" or string.format("%.6f", p23);
    end;

    if typeof(p23) == "boolean" then
        return tostring(p23);
    end;

    return string.gsub(tostring(p23), "%s+", "_");
end;

function v1.formatMovementLockContext(p24: table?, p25: number) -- Line: 163
    -- upvalues: scalarLabel (copy)
    if p24 == nil then
        return string.format("movementLockContext snapshotServerTime=%.6f unavailable=true", p25);
    end;

    return string.format("movementLockContext snapshotServerTime=%.6f gameStateAtSnapshot=%s gameStateNow=%s localPlantingNow=%s replicatedPlantingNow=%s plantLockAt=%s localDefusingNow=%s replicatedDefusingNow=%s replicatedRescuingNow=%s carryingHostageNow=%s", p25, scalarLabel(p24.GameStateAtSnapshot), scalarLabel(p24.CurrentGameState), scalarLabel(p24.LocalPlanting), scalarLabel(p24.ReplicatedPlanting), scalarLabel(p24.BombPlantMovementLockAt), scalarLabel(p24.LocalDefusing), scalarLabel(p24.ReplicatedDefusing), scalarLabel(p24.ReplicatedRescuing), scalarLabel(p24.CarryingHostage));
end;

return table.freeze(v1);