-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Config);
local u1 = {};
local buffer_create_ret = buffer.create(4);
u1.MinimumPredictableTicks = 2;
u1.NetworkSafetyTicks = 2;
u1.RecoverySeconds = 0.2;
u1.RecoveryPerSecond = 1 / u1.RecoverySeconds;

local function isFinite(p2) -- Line: 15
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function u1.isValidModifier(p4) -- Line: 19
    local v5;

    if typeof(p4) == "number" and (p4 == p4 and p4 > (-1 / 0)) then
        v5 = p4 < (1 / 0);
    else
        v5 = false;
    end;

    if v5 then
        if p4 >= 0 then
            v5 = p4 <= 1;
        else
            v5 = false;
        end;
    end;

    return v5;
end;

local function canonicalModifier(p6: number) -- Line: 23
    -- upvalues: buffer_create_ret (copy)
    buffer.writef32(buffer_create_ret, 0, p6);

    return buffer.readf32(buffer_create_ret, 0);
end;

function u1.predictableDelayTicks(p7: any, p8: any, p9: number, p10: number) -- Line: 28
    -- upvalues: u1 (copy), Config (copy)
    local v11;

    if typeof(p9) == "number" and (p9 == p9 and p9 > (-1 / 0)) then
        v11 = p9 < (1 / 0);
    else
        v11 = false;
    end;

    if v11 then
        v11 = p9 > 0;
    end;

    assert(v11, "damage-tag step must be finite and positive");
    local v12;

    if p10 % 1 == 0 then
        v12 = u1.MinimumPredictableTicks <= p10;
    else
        v12 = false;
    end;

    assert(v12, "invalid damage-tag horizon");
    local v13;

    if typeof(p7) == "number" and (p7 == p7 and p7 > (-1 / 0)) then
        v13 = p7 < (1 / 0);
    else
        v13 = false;
    end;

    local v14 = not v13 and 0 or math.max(p7, 0);
    local v15;

    if typeof(p8) == "number" and (p8 == p8 and p8 > (-1 / 0)) then
        v15 = p8 < (1 / 0);
    else
        v15 = false;
    end;

    local v16;

    if v15 then
        local math_floor_ret = math.floor(p8);
        v16 = math.max(math_floor_ret, 0);
    else
        v16 = 0;
    end;

    local v17 = v16 + math.ceil(v14 / p9 * (1 + Config.CommandClockMaxSlewRatio)) + u1.NetworkSafetyTicks;

    return math.clamp(v17, u1.MinimumPredictableTicks, p10);
end;

function u1.apply(p18: number, p19: number) -- Line: 48
    -- upvalues: u1 (copy), buffer_create_ret (copy)
    local v20 = u1.isValidModifier(p18);
    assert(v20, "invalid current velocity modifier");
    local v21 = u1.isValidModifier(p19);
    assert(v21, "invalid incoming velocity modifier");
    local math_min_ret = math.min(p18, p19);
    buffer.writef32(buffer_create_ret, 0, math_min_ret);

    return buffer.readf32(buffer_create_ret, 0);
end;

function u1.recover(p22: number, p23: number) -- Line: 54
    -- upvalues: u1 (copy), buffer_create_ret (copy)
    local v24 = u1.isValidModifier(p22);
    assert(v24, "invalid current velocity modifier");
    local v25;

    if typeof(p23) == "number" and (p23 == p23 and p23 > (-1 / 0)) then
        v25 = p23 < (1 / 0);
    else
        v25 = false;
    end;

    if v25 then
        v25 = p23 > 0;
    end;

    assert(v25, "damage-tag delta must be finite and positive");
    local math_min_ret = math.min(p22 + u1.RecoveryPerSecond * p23, 1);
    buffer.writef32(buffer_create_ret, 0, math_min_ret);

    return buffer.readf32(buffer_create_ret, 0);
end;

return table.freeze(u1);