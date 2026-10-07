-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.Trace
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.Trace
-- Decompile time: 0.54 ms

local DeterminismTrace = require(script.Parent.Parent.DeterminismTrace)
require(script.Parent.Parent.ProvenTypes)
local v1 = {}
local u13 = nil

function v1.bind(a1) -- Line: 14 -- upvalues: u13 (ref)
    u13 = a1
end

function v1.isActive() -- Line: 18 -- upvalues: u13 (ref)
    return u13 ~= nil
end

function v1.line(a1) -- Line: 22 -- upvalues: u13 (ref) -- types: a1: number
    if u13 == nil then
        return 0
    end
    return debug.info(a1 + 1, "l")
end

function v1.state(a1, a2, a3) -- Line: 30
    -- upvalues: DeterminismTrace (val), u13 (ref)
    DeterminismTrace.checkpoint(u13, a1, a2, nil, nil, nil, "ReplicatedStorage.MovementV2.Simulation.ProvenSimulator", a3)
end

function v1.vector(a1, a2, a3, a4, a5, a6) -- Line: 34
    -- upvalues: DeterminismTrace (val), u13 (ref)
    DeterminismTrace.vector(u13, a1, a2, a3, a4, a5, nil, "ReplicatedStorage.MovementV2.Simulation.ProvenSimulator", a6)
end

return (table.freeze(v1))