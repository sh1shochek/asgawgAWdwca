-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Parent.Config);
require(script.Parent.Parent.Types);
local CommandClockMaxSlewRatio = Config.CommandClockMaxSlewRatio;
local u1 = {};
u1.__index = u1;

local function isFinite(p2) -- Line: 51
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function u1.new(p4: any, p5: boolean?) -- Line: 55
    -- upvalues: u1 (copy)
    local v6 = type(p4) == "table";
    assert(v6, "derived config is required");
    local v7 = p4.CommandClockWindowTicks / p4.SimulationHz;
    local v8 = math.ceil(v7 / (p4.OwnerSnapshotEveryTicks / p4.SimulationHz)) + 4;
    local math_max_ret = math.max(4, v8);
    local v9 = {
        _head = 0,
        _count = 0,
        _rate = 1,
        _errorTicks = 0,
        _config = p4,
        _targetDepth = p4.CommandBufferTargetTicks,
        _windowSeconds = v7,
        _samples = table.create(math_max_ret),
        _capacity = math_max_ret,
        _enabled = p5 ~= false
    };

    return setmetatable(v9, u1);
end;

function u1.reset(p10) -- Line: 74
    p10._head = 0;
    p10._count = 0;
    p10._rate = 1;
    p10._worstDepth = nil;
    p10._bestDepth = nil;
    p10._errorTicks = 0;
    table.clear(p10._samples);
end;

local function prune(p11: any, p12: number) -- Line: 84
    local v13 = p12 - p11._windowSeconds;

    while p11._count > 0 do
        local v14 = p11._samples[p11._head % p11._capacity + 1];

        if v14 == nil or v13 <= v14.AtSeconds then
            break;
        end;

        p11._head = (p11._head + 1) % p11._capacity;
        p11._count = p11._count - 1;
    end;
end;

local function recompute(p15) -- Line: 96
    -- upvalues: CommandClockMaxSlewRatio (copy)
    if p15._count == 0 then
        p15._worstDepth = nil;
        p15._bestDepth = nil;
        p15._errorTicks = 0;
        p15._rate = 1;

        return;
    end;

    local v16 = nil;
    local v17 = nil;
    local v18 = 0;

    for i = 0, p15._count - 1 do
        local v19 = p15._samples[(p15._head + i) % p15._capacity + 1];
        local v20;

        if v19 == nil then
            v20 = i;
        else
            if v16 == nil or v19.Depth < v16 then
                v16 = v19.Depth;
            end;

            if v17 == nil or v17 < v19.Depth then
                v17 = v19.Depth;
            end;

            if v19.Depth < p15._targetDepth then
                v18 = v18 + 1;
                v20 = i;
            else
                v20 = i;
            end;
        end;
    end;

    p15._worstDepth = v16;
    p15._bestDepth = v17;

    if v16 == nil or v17 == nil then
        p15._errorTicks = 0;
        p15._rate = 1;

        return;
    end;

    local _targetDepth = p15._targetDepth;
    local v21 = 0;

    if _targetDepth + 0.5 < v16 then
        v21 = v16 - (_targetDepth + 0.5);
    elseif v16 < _targetDepth - 0.5 and v18 >= 2 then
        v21 = v16 - _targetDepth;
    end;

    p15._errorTicks = v21;

    if not p15._enabled or v21 == 0 then
        p15._rate = 1;

        return;
    end;

    local v22 = 1 - v21 / math.max(1, p15._windowSeconds * p15._config.SimulationHz);
    p15._rate = math.clamp(v22, 1 - CommandClockMaxSlewRatio, 1 + CommandClockMaxSlewRatio);
end;

function u1.observe(p23: table, p24: number, p25: number) -- Line: 151
    -- upvalues: prune (copy), recompute (copy)
    local v26;

    if typeof(p24) == "number" and (p24 == p24 and p24 > (-1 / 0)) then
        v26 = p24 < (1 / 0);
    else
        v26 = false;
    end;

    assert(v26, "invalid command buffer depth");
    local v27;

    if typeof(p25) == "number" and (p25 == p25 and p25 > (-1 / 0)) then
        v27 = p25 < (1 / 0);
    else
        v27 = false;
    end;

    if v27 then
        v27 = p25 >= 0;
    end;

    assert(v27, "invalid command clock time");
    prune(p23, p25);

    if p23._count >= p23._capacity then
        p23._head = (p23._head + 1) % p23._capacity;
        p23._count = p23._count - 1;
    end;

    local v28 = (p23._head + p23._count) % p23._capacity + 1;
    local v29 = p23._samples[v28];

    if v29 == nil then
        p23._samples[v28] = {
            Depth = p24,
            AtSeconds = p25
        };
    else
        v29.Depth = p24;
        v29.AtSeconds = p25;
    end;

    p23._count = p23._count + 1;
    recompute(p23);
end;

function u1.rate(p30: table, p31: number) -- Line: 173
    -- upvalues: prune (copy), recompute (copy)
    local v32;

    if typeof(p31) == "number" and (p31 == p31 and p31 > (-1 / 0)) then
        v32 = p31 < (1 / 0);
    else
        v32 = false;
    end;

    if v32 then
        v32 = p31 >= 0;
    end;

    assert(v32, "invalid command clock time");
    prune(p30, p31);
    recompute(p30);

    return p30._rate;
end;

function u1.diagnostics(p33) -- Line: 180
    return table.freeze({
        Rate = p33._rate,
        WorstDepth = p33._worstDepth,
        BestDepth = p33._bestDepth,
        TargetDepth = p33._targetDepth,
        ErrorTicks = p33._errorTicks,
        SampleCount = p33._count
    });
end;

return table.freeze(u1);