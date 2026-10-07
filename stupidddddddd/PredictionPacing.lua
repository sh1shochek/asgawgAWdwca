-- ReplicatedStorage.MovementV2.Client.PredictionPacing
-- Script path: ReplicatedStorage.MovementV2.Client.PredictionPacing
-- Decompile time: 1.18 ms

require(script.Parent.Parent.Types)
local v1 = {}

local function isFinite(a1) -- Line: 37
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

function v1.policyFromConfig(a1) -- Line: 41
    return table.freeze({
        WorkCeilingFraction = 0.5,
        MinimumSteps = 2,
        StepSeconds = a1.StepSeconds,
        MaxFrameSeconds = a1.MaxPredictionFrameTicks * a1.StepSeconds,
        MaxAccumulatorSeconds = a1.PredictionAccumulatorTicks * a1.StepSeconds,
        MaxSteps = a1.PredictionAccumulatorTicks,
    })
end

function v1.plan(a1, a2, a3, a4) -- Line: 53 -- types: a1: number, a2: number, a3: table, a4: number?
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
    if v1 then
        v1 = a1 >= 0
    end
    assert(v1, "invalid prediction accumulator")
    v1 = false
    if typeof(a2) == "number" then
        v1 = false
        if a2 == a2 then
            v1 = false
            if a2 > (-1 / 0) then
                v1 = a2 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = a2 >= 0
    end
    assert(v1, "invalid frame delta")
    local v2 = a4 or 1
    local v3 = false
    if typeof(v2) == "number" then
        v3 = false
        if v2 == v2 then
            v3 = false
            if v2 > (-1 / 0) then
                v3 = v2 < (1 / 0)
            end
        end
    end
    if v3 then
        v3 = v2 > 0
    end
    assert(v3, "invalid command clock rate")
    v1 = math.min(a2, a3.MaxFrameSeconds)
    v3 = math.max(a2 - v1, 0)
    local v4 = v1 * v2
    local v5 = a1 + v4
    local v6 = math.min(v5, a3.MaxAccumulatorSeconds)
    local v7 = math.max(v5 - a3.MaxAccumulatorSeconds, 0)
    local v8 = math.min(a3.MaxSteps, (math.max(1, (math.ceil(v4 / a3.StepSeconds)))))
    return {
        AdmittedSeconds = v1,
        DiscardedSeconds = v3 + v7,
        AccumulatorSeconds = v6,
        BacklogBeforeSeconds = v6,
        GuaranteedSteps = v8,
        MaxSteps = a3.MaxSteps,
        WorkCeilingSeconds = v1 * a3.WorkCeilingFraction,
        MinimumSteps = math.min(a3.MinimumSteps, v8),
    }
end

return table.freeze(v1)