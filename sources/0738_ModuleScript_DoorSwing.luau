-- Decompiled with Potassium's decompiler.

local u1 = {
    OpenAngle = 1.5707963267948966,
    OpenSeconds = 0.35,
    MinSwingSeconds = 0.004166666666666667,
    ClosedAngleEpsilon = 0.05,
    TargetEpsilon = 0.01,
    InteractRange = 15
};
u1.SwingRate = u1.OpenAngle / u1.OpenSeconds;

function u1.durationSeconds(p2: number) -- Line: 14
    -- upvalues: u1 (copy)
    return math.max(u1.MinSwingSeconds, p2 / u1.OpenAngle * u1.OpenSeconds);
end;

return table.freeze(u1);