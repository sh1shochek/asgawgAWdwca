-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);
local v1 = {};

local function isFinite(p2) -- Line: 37
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function v1.policyFromConfig(p4) -- Line: 41
    return table.freeze({
        WorkCeilingFraction = 0.5,
        MinimumSteps = 2,
        StepSeconds = p4.StepSeconds,
        MaxFrameSeconds = p4.MaxPredictionFrameTicks * p4.StepSeconds,
        MaxAccumulatorSeconds = p4.PredictionAccumulatorTicks * p4.StepSeconds,
        MaxSteps = p4.PredictionAccumulatorTicks
    });
end;

function v1.plan(p5: number, p6: number, p7: table, p8: number?) -- Line: 53
    local v9;

    if typeof(p5) == "number" and (p5 == p5 and p5 > (-1 / 0)) then
        v9 = p5 < (1 / 0);
    else
        v9 = false;
    end;

    if v9 then
        v9 = p5 >= 0;
    end;

    assert(v9, "invalid prediction accumulator");
    local v10;

    if typeof(p6) == "number" and (p6 == p6 and p6 > (-1 / 0)) then
        v10 = p6 < (1 / 0);
    else
        v10 = false;
    end;

    if v10 then
        v10 = p6 >= 0;
    end;

    assert(v10, "invalid frame delta");
    local v11 = p8 or 1;
    local v12;

    if typeof(v11) == "number" and (v11 == v11 and v11 > (-1 / 0)) then
        v12 = v11 < (1 / 0);
    else
        v12 = false;
    end;

    if v12 then
        v12 = v11 > 0;
    end;

    assert(v12, "invalid command clock rate");
    local math_min_ret = math.min(p6, p7.MaxFrameSeconds);
    local math_max_ret = math.max(p6 - math_min_ret, 0);
    local v13 = math_min_ret * v11;
    local v14 = p5 + v13;
    local math_min_ret2 = math.min(v14, p7.MaxAccumulatorSeconds);
    local math_max_ret2 = math.max(v14 - p7.MaxAccumulatorSeconds, 0);
    local MaxSteps = p7.MaxSteps;
    local math_ceil_ret = math.ceil(v13 / p7.StepSeconds);
    local math_max_ret3 = math.max(1, math_ceil_ret);
    local math_min_ret3 = math.min(MaxSteps, math_max_ret3);

    return {
        AdmittedSeconds = math_min_ret,
        DiscardedSeconds = math_max_ret + math_max_ret2,
        AccumulatorSeconds = math_min_ret2,
        BacklogBeforeSeconds = math_min_ret2,
        GuaranteedSteps = math_min_ret3,
        MaxSteps = p7.MaxSteps,
        WorkCeilingSeconds = math_min_ret * p7.WorkCeilingFraction,
        MinimumSteps = math.min(p7.MinimumSteps, math_min_ret3)
    };
end;

return table.freeze(v1);