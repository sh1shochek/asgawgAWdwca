-- ReplicatedStorage.MovementV2.DoorSwing
-- Script path: ReplicatedStorage.MovementV2.DoorSwing
-- Decompile time: 0.23 ms

local u0 = {
    OpenAngle = 1.5707963267948966,
    OpenSeconds = 0.35,
    MinSwingSeconds = 0.004166666666666667,
    ClosedAngleEpsilon = 0.05,
    TargetEpsilon = 0.01,
    InteractRange = 15,
}
u0.SwingRate = u0.OpenAngle / u0.OpenSeconds

function u0.durationSeconds(a1) -- Line: 14 -- upvalues: u0 (val) -- types: a1: number
    return (math.max(u0.MinSwingSeconds, a1 / u0.OpenAngle * u0.OpenSeconds))
end

return table.freeze(u0)