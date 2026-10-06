-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Parent.Simulation.Config);
local u1 = {
    MaxSeconds = 0.2,
    MinSpeed = 150 * Config.Default.HammerUnitToStud,
    MaxDistance = 64 * Config.Default.HammerUnitToStud,
    Epsilon = 0.0001,
    ContactMinDistance = Config.Default.MaxBaseMoveSpeed * 0.03333333333333333
};

local function finiteNonnegative(p2) -- Line: 15
    return (typeof(p2) ~= "number" or (p2 ~= p2 or (p2 < 0 or p2 == (1 / 0)))) and 0 or p2;
end;

function u1.clampOffset(p3: vector) -- Line: 22
    -- upvalues: u1 (copy)
    local Magnitude = p3.Magnitude;

    if Magnitude <= u1.Epsilon then
        return Vector3.new(0, 0, 0);
    end;

    if u1.MaxDistance < Magnitude then
        return p3.Unit * u1.MaxDistance;
    end;

    return p3;
end;

function u1.remainingOffset(p4: vector, p5: number) -- Line: 33
    -- upvalues: u1 (copy)
    local Magnitude = p4.Magnitude;

    if Magnitude <= u1.Epsilon then
        return Vector3.new(0, 0, 0);
    end;

    local v6 = (typeof(p5) ~= "number" or (p5 ~= p5 or (p5 < 0 or p5 == (1 / 0)))) and 0 or p5;
    local v7 = Magnitude - math.max(v6 * u1.MinSpeed, v6 / u1.MaxSeconds * Magnitude);
    local math_max_ret = math.max(v7, 0);

    return u1.Epsilon >= math_max_ret and Vector3.new(0, 0, 0) or p4.Unit * math_max_ret;
end;

function u1.isHardSnapCorrection(p8) -- Line: 48
    -- upvalues: u1 (copy)
    local ReconciliationMode = p8.ReconciliationMode;

    return ReconciliationMode == "Initial" and true or (ReconciliationMode == "Reanchor" and p8.TailCompared ~= true and true or (typeof(p8.TailPosition) ~= "number" and 0 or p8.TailPosition) > u1.MaxDistance);
end;

return table.freeze(u1);