-- ReplicatedStorage.MovementV2.Client.PredictionErrorSmoother
-- Script path: ReplicatedStorage.MovementV2.Client.PredictionErrorSmoother
-- Decompile time: 0.79 ms

local Config = require(script.Parent.Parent.Simulation.Config)
local u7 = {MaxSeconds = 0.2}
u7.MinSpeed = 150 * Config.Default.HammerUnitToStud
u7.MaxDistance = 64 * Config.Default.HammerUnitToStud
u7.Epsilon = 0.0001
u7.ContactMinDistance = Config.Default.MaxBaseMoveSpeed * 0.03333333333333333

local function finiteNonnegative(a1) -- Line: 15
    if typeof(a1) == "number" and a1 == a1 and not (a1 < 0) and a1 ~= (1 / 0) then
        return a1
    end
    return 0
end

function u7.clampOffset(a1) -- Line: 22 -- upvalues: u7 (val) -- types: a1: vector
    local Magnitude = a1.Magnitude
    if Magnitude <= u7.Epsilon then
        return (Vector3.new(0, 0, 0))
    end
    if u7.MaxDistance < Magnitude then
        return a1.Unit * u7.MaxDistance
    end
    return a1
end

function u7.remainingOffset(a1, a2) -- Line: 33 -- upvalues: u7 (val) -- types: a1: vector, a2: number
    local v1
    local Magnitude = a1.Magnitude
    if Magnitude <= u7.Epsilon then
        return (Vector3.new(0, 0, 0))
    end
    local v2 = math.max(Magnitude - (math.max(
        (if typeof(a2) ~= "number" then 0 else if a2 ~= a2 then 0 else if a2 < 0 then 0 else if a2 ~= (1 / 0) then a2 else 0) * u7.MinSpeed,
        v1 / u7.MaxSeconds * Magnitude
    )), 0)
    if u7.Epsilon < v2 then
        return a1.Unit * v2
    end
    return (Vector3.new(0, 0, 0))
end

function u7.isHardSnapCorrection(a1) -- Line: 48 -- upvalues: u7 (val)
    local ReconciliationMode = a1.ReconciliationMode
    if ReconciliationMode == "Initial" then
        return true
    end
    if ReconciliationMode == "Reanchor" and a1.TailCompared ~= true then
        return true
    end
    return u7.MaxDistance < (if typeof(a1.TailPosition) ~= "number" then 0 else a1.TailPosition)
end

return table.freeze(u7)