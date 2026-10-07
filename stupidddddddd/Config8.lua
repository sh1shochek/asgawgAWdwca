-- ReplicatedStorage.MovementV2.Config
-- Script path: ReplicatedStorage.MovementV2.Config
-- Decompile time: 6.06 ms

require(script.Parent.Types)
local u5 = {
    DefaultSimulationHz = 60,
    MinSimulationHz = 20,
    MaxSimulationHz = 240,
    CommandClockMaxSlewRatio = 0.1,
    MaxCommandsPerTick = 2,
    DoorCollisionDebugEnabled = false,
}
u5.PolicySeconds = table.freeze({
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
    CommandClockWindow = 1,
})

local function isFinite(a1) -- Line: 66
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    return v1
end

local function horizonTicks(a1, a2) -- Line: 70 -- types: a1: number, a2: number
    return (math.max(1, (math.ceil(a1 * a2))))
end

local function targetTicks(a1, a2) -- Line: 75 -- types: a1: number, a2: number
    return (math.max(0, a1 * a2))
end

local function cadenceTicks(a1, a2) -- Line: 79 -- types: a1: number, a2: number
    return (math.max(1, (math.floor(a1 * a2))))
end

function u5.derive(a1) -- Line: 84 -- upvalues: u5 (val) -- types: a1: number?
    local DefaultSimulationHz = a1 or u5.DefaultSimulationHz
    local v1 = false
    if typeof(DefaultSimulationHz) == "number" then
        v1 = false
        if DefaultSimulationHz == DefaultSimulationHz then
            v1 = false
            if DefaultSimulationHz > (-1 / 0) then
                v1 = DefaultSimulationHz < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = false
        if DefaultSimulationHz % 1 == 0 then
            v1 = false
            if u5.MinSimulationHz <= DefaultSimulationHz then
                v1 = DefaultSimulationHz <= u5.MaxSimulationHz
            end
        end
    end
    assert(v1, "MovementV2 simulation Hz must be an integer from 20 through 240")
    local PolicySeconds = u5.PolicySeconds
    v1 = math.max(1, (math.ceil(PolicySeconds.TargetRedundantHistory * DefaultSimulationHz)))
    local v2 = math.max(1, (math.ceil(PolicySeconds.MaxNewCommandSpan * DefaultSimulationHz)))
    local v3 = math.max(1, (math.ceil(PolicySeconds.CommandHistory * DefaultSimulationHz)))
    local v4 = math.max(1, (math.ceil(PolicySeconds.MaxPendingCommandLead * DefaultSimulationHz)))
    local v5 = math.max(1, (math.ceil(PolicySeconds.CommandLeadResync * DefaultSimulationHz)))
    local v6 = math.max(1, (math.ceil(PolicySeconds.CommandBuffer * DefaultSimulationHz)))
    local v7 = math.max(1, (math.ceil(PolicySeconds.SynthesizedInputHold * DefaultSimulationHz)))
    local v8 = math.max(1, (math.ceil(PolicySeconds.SynthesizedInputDecay * DefaultSimulationHz)))
    local v9 = math.max(1, (math.ceil(PolicySeconds.PredictionReplay * DefaultSimulationHz)))
    local v10 = math.max(1, (math.ceil(PolicySeconds.MaxPredictionFrame * DefaultSimulationHz)))
    local v11 = math.max(1, (math.ceil(PolicySeconds.CommandCatchUpBank * DefaultSimulationHz)))
    local v12 = math.max(0, PolicySeconds.CommandBufferTarget * DefaultSimulationHz)
    local v13 = math.max(1, (math.ceil(PolicySeconds.CommandClockWindow * DefaultSimulationHz)))
    assert(v4 <= v3, "command history must cover the accepted serial lead")
    assert(v4 <= v9, "prediction replay must cover the accepted serial lead")
    assert(v5 <= v4, "accepted serial lead must cover command resync")
    assert(v6 < v5, "command resync must exceed the startup jitter buffer")
    assert(v6 <= v4, "accepted serial lead must cover the command buffer")
    assert(v7 + v8 <= v9, "input-loss recovery must fit inside prediction replay retention")
    assert(u5.MaxCommandsPerTick <= v11, "catch-up bank must cover at least one full catch-up tick")
    assert(v11 <= v4, "catch-up bank must stay inside the accepted serial lead")
    assert(v12 <= v6, "steady-state buffer target must not exceed the startup jitter reservoir")
    return (table.freeze({
        SimulationHz = DefaultSimulationHz,
        StepSeconds = 1 / DefaultSimulationHz,
        CommandHistoryTicks = v3,
        MaxPendingCommandLeadTicks = v4,
        CommandLeadResyncTicks = v5,
        CommandBufferTicks = v6,
        SynthesizedInputHoldTicks = v7,
        SynthesizedInputDecayTicks = v8,
        PredictionReplayTicks = v9,
        OwnerSnapshotEveryTicks = math.max(1, (math.floor(PolicySeconds.OwnerSnapshotPeriod * DefaultSimulationHz))),
        CommandPacketEveryTicks = math.max(1, (math.floor(PolicySeconds.CommandPacketPeriod * DefaultSimulationHz))),
        RemoteSnapshotEveryTicks = math.max(1, (math.floor(PolicySeconds.RemoteSnapshotPeriod * DefaultSimulationHz))),
        RemoteBaselineTicks = math.max(1, (math.ceil(PolicySeconds.RemoteBaselinePeriod * DefaultSimulationHz))),
        RemoteHistoryTicks = math.max(1, (math.ceil(PolicySeconds.RemoteHistory * DefaultSimulationHz))),
        RenderInterpolationTicks = math.max(1, (math.ceil(PolicySeconds.RenderInterpolation * DefaultSimulationHz))),
        MaxRemoteExtrapolationTicks = math.max(1, (math.ceil(PolicySeconds.MaxRemoteExtrapolation * DefaultSimulationHz))),
        TargetRedundantCommandCount = v1,
        MaxNewCommandsPerPacket = v2,
        MaxCommandsPerPacket = v1 + v2,
        MaxPredictionFrameTicks = v10,
        PredictionAccumulatorTicks = v10 + 1,
        CommandCatchUpBankTicks = v11,
        CommandBufferTargetTicks = v12,
        CommandClockWindowTicks = v13,
    }))
end

u5.Default = u5.derive(u5.DefaultSimulationHz)
assert(u5.Default.RenderInterpolationTicks == 2, "default remote interpolation must remain at the authored wall-time delay")
assert(
    u5.PolicySeconds.TargetRedundantHistory <= u5.Default.TargetRedundantCommandCount / u5.Default.SimulationHz,
    "default redundancy must cover the authored loss horizon"
)
assert(
    u5.Default.MaxPredictionFrameTicks < u5.Default.PredictionAccumulatorTicks,
    "prediction accumulator must carry a whole admitted frame plus its remainder"
)
return table.freeze(u5)