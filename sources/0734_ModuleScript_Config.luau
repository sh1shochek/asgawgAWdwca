-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);
local u1 = {
    DefaultSimulationHz = 60,
    MinSimulationHz = 20,
    MaxSimulationHz = 240,
    CommandClockMaxSlewRatio = 0.1,
    MaxCommandsPerTick = 2,
    DoorCollisionDebugEnabled = false,
    PolicySeconds = table.freeze({
        CommandHistory = 2.5,
        MaxPendingCommandLead = 2.5,
        CommandLeadResync = 1,
        CommandBuffer = 0.05,
        SynthesizedInputHold = 0.05,
        SynthesizedInputDecay = 0.1,
        PredictionReplay = 2.5,
        OwnerSnapshotPeriod = 0.041666666666666664,
        CommandPacketPeriod = 0.016666666666666666,
        RemoteSnapshotPeriod = 0.016666666666666666,
        RemoteBaselinePeriod = 0.125,
        RemoteHistory = 0.25,
        RenderInterpolation = 0.03125,
        MaxRemoteExtrapolation = 0.1,
        TargetRedundantHistory = 0.05,
        MaxNewCommandSpan = 0.1,
        MaxPredictionFrame = 0.1,
        CommandCatchUpBank = 0.25,
        CommandBufferTarget = 0.004,
        CommandClockWindow = 1
    })
};

local function isFinite(p2) -- Line: 66
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function horizonTicks(p4: number, p5: number) -- Line: 70
    local math_ceil_ret = math.ceil(p4 * p5);

    return math.max(1, math_ceil_ret);
end;

local function targetTicks(p6: number, p7: number) -- Line: 75
    return math.max(0, p6 * p7);
end;

local function cadenceTicks(p8: number, p9: number) -- Line: 79
    local math_floor_ret = math.floor(p8 * p9);

    return math.max(1, math_floor_ret);
end;

function u1.derive(p10: number?) -- Line: 84
    -- upvalues: u1 (copy)
    local v11 = p10 or u1.DefaultSimulationHz;
    local v12;

    if typeof(v11) == "number" and (v11 == v11 and v11 > (-1 / 0)) then
        v12 = v11 < (1 / 0);
    else
        v12 = false;
    end;

    if v12 then
        if v11 % 1 == 0 and u1.MinSimulationHz <= v11 then
            v12 = v11 <= u1.MaxSimulationHz;
        else
            v12 = false;
        end;
    end;

    assert(v12, "MovementV2 simulation Hz must be an integer from 20 through 240");
    local PolicySeconds = u1.PolicySeconds;
    local math_ceil_ret = math.ceil(PolicySeconds.TargetRedundantHistory * v11);
    local math_max_ret = math.max(1, math_ceil_ret);
    local math_ceil_ret2 = math.ceil(PolicySeconds.MaxNewCommandSpan * v11);
    local math_max_ret2 = math.max(1, math_ceil_ret2);
    local math_ceil_ret3 = math.ceil(PolicySeconds.CommandHistory * v11);
    local math_max_ret3 = math.max(1, math_ceil_ret3);
    local math_ceil_ret4 = math.ceil(PolicySeconds.MaxPendingCommandLead * v11);
    local math_max_ret4 = math.max(1, math_ceil_ret4);
    local math_ceil_ret5 = math.ceil(PolicySeconds.CommandLeadResync * v11);
    local math_max_ret5 = math.max(1, math_ceil_ret5);
    local math_ceil_ret6 = math.ceil(PolicySeconds.CommandBuffer * v11);
    local math_max_ret6 = math.max(1, math_ceil_ret6);
    local math_ceil_ret7 = math.ceil(PolicySeconds.SynthesizedInputHold * v11);
    local math_max_ret7 = math.max(1, math_ceil_ret7);
    local math_ceil_ret8 = math.ceil(PolicySeconds.SynthesizedInputDecay * v11);
    local math_max_ret8 = math.max(1, math_ceil_ret8);
    local math_ceil_ret9 = math.ceil(PolicySeconds.PredictionReplay * v11);
    local math_max_ret9 = math.max(1, math_ceil_ret9);
    local math_ceil_ret10 = math.ceil(PolicySeconds.MaxPredictionFrame * v11);
    local math_max_ret10 = math.max(1, math_ceil_ret10);
    local math_ceil_ret11 = math.ceil(PolicySeconds.CommandCatchUpBank * v11);
    local math_max_ret11 = math.max(1, math_ceil_ret11);
    local math_max_ret12 = math.max(0, PolicySeconds.CommandBufferTarget * v11);
    local math_ceil_ret12 = math.ceil(PolicySeconds.CommandClockWindow * v11);
    local math_max_ret13 = math.max(1, math_ceil_ret12);
    assert(math_max_ret4 <= math_max_ret3, "command history must cover the accepted serial lead");
    assert(math_max_ret4 <= math_max_ret9, "prediction replay must cover the accepted serial lead");
    assert(math_max_ret5 <= math_max_ret4, "accepted serial lead must cover command resync");
    assert(math_max_ret6 < math_max_ret5, "command resync must exceed the startup jitter buffer");
    assert(math_max_ret6 <= math_max_ret4, "accepted serial lead must cover the command buffer");
    assert(math_max_ret7 + math_max_ret8 <= math_max_ret9, "input-loss recovery must fit inside prediction replay retention");
    assert(u1.MaxCommandsPerTick <= math_max_ret11, "catch-up bank must cover at least one full catch-up tick");
    assert(math_max_ret11 <= math_max_ret4, "catch-up bank must stay inside the accepted serial lead");
    assert(math_max_ret12 <= math_max_ret6, "steady-state buffer target must not exceed the startup jitter reservoir");
    local table_freeze = table.freeze;
    local v13 = {
        SimulationHz = v11,
        StepSeconds = 1 / v11,
        CommandHistoryTicks = math_max_ret3,
        MaxPendingCommandLeadTicks = math_max_ret4,
        CommandLeadResyncTicks = math_max_ret5,
        CommandBufferTicks = math_max_ret6,
        SynthesizedInputHoldTicks = math_max_ret7,
        SynthesizedInputDecayTicks = math_max_ret8,
        PredictionReplayTicks = math_max_ret9
    };
    local math_floor_ret = math.floor(PolicySeconds.OwnerSnapshotPeriod * v11);
    v13.OwnerSnapshotEveryTicks = math.max(1, math_floor_ret);
    local math_floor_ret2 = math.floor(PolicySeconds.CommandPacketPeriod * v11);
    v13.CommandPacketEveryTicks = math.max(1, math_floor_ret2);
    local math_floor_ret3 = math.floor(PolicySeconds.RemoteSnapshotPeriod * v11);
    v13.RemoteSnapshotEveryTicks = math.max(1, math_floor_ret3);
    local math_ceil_ret13 = math.ceil(PolicySeconds.RemoteBaselinePeriod * v11);
    v13.RemoteBaselineTicks = math.max(1, math_ceil_ret13);
    local math_ceil_ret14 = math.ceil(PolicySeconds.RemoteHistory * v11);
    v13.RemoteHistoryTicks = math.max(1, math_ceil_ret14);
    local math_ceil_ret15 = math.ceil(PolicySeconds.RenderInterpolation * v11);
    v13.RenderInterpolationTicks = math.max(1, math_ceil_ret15);
    local math_ceil_ret16 = math.ceil(PolicySeconds.MaxRemoteExtrapolation * v11);
    v13.MaxRemoteExtrapolationTicks = math.max(1, math_ceil_ret16);
    v13.TargetRedundantCommandCount = math_max_ret;
    v13.MaxNewCommandsPerPacket = math_max_ret2;
    v13.MaxCommandsPerPacket = math_max_ret + math_max_ret2;
    v13.MaxPredictionFrameTicks = math_max_ret10;
    v13.PredictionAccumulatorTicks = math_max_ret10 + 1;
    v13.CommandCatchUpBankTicks = math_max_ret11;
    v13.CommandBufferTargetTicks = math_max_ret12;
    v13.CommandClockWindowTicks = math_max_ret13;

    return table_freeze(v13);
end;

u1.Default = u1.derive(u1.DefaultSimulationHz);
assert(u1.Default.RenderInterpolationTicks == 2, "default remote interpolation must remain at the authored wall-time delay");
assert(u1.Default.TargetRedundantCommandCount / u1.Default.SimulationHz >= u1.PolicySeconds.TargetRedundantHistory, "default redundancy must cover the authored loss horizon");
assert(u1.Default.PredictionAccumulatorTicks > u1.Default.MaxPredictionFrameTicks, "prediction accumulator must carry a whole admitted frame plus its remainder");

return table.freeze(u1);