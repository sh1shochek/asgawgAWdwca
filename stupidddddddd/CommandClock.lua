-- ReplicatedStorage.MovementV2.Client.CommandClock
-- Script path: ReplicatedStorage.MovementV2.Client.CommandClock
-- Decompile time: 2.38 ms

local Config = require(script.Parent.Parent.Config)
require(script.Parent.Parent.Types)
local CommandClockMaxSlewRatio = Config.CommandClockMaxSlewRatio
local u13 = {}
u13.__index = u13

local function isFinite(a1) -- Line: 51
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

function u13.new(a1, a2) -- Line: 55 -- upvalues: u13 (val) -- types: a2: boolean?
    assert(type(a1) == "table", "derived config is required")
    local v1 = a1.CommandClockWindowTicks / a1.SimulationHz
    local v2 = math.max(4, (math.ceil(v1 / (a1.OwnerSnapshotEveryTicks / a1.SimulationHz))) + 4)
    return (setmetatable({
        _head = 0,
        _count = 0,
        _rate = 1,
        _errorTicks = 0,
        _config = a1,
        _targetDepth = a1.CommandBufferTargetTicks,
        _windowSeconds = v1,
        _samples = table.create(v2),
        _capacity = v2,
        _enabled = a2 ~= false,
    }, u13))
end

function u13.reset(a1) -- Line: 74
    a1._head = 0
    a1._count = 0
    a1._rate = 1
    a1._worstDepth = nil
    a1._bestDepth = nil
    a1._errorTicks = 0
    table.clear(a1._samples)
end

local function prune(a1, a2) -- Line: 84 -- types: a2: number
    local v1
    local v2 = a2 - a1._windowSeconds
    while 0 < a1._count do
        v1 = a1._samples[a1._head % a1._capacity + 1]
        if v1 == nil or v2 <= v1.AtSeconds then
            break
        end
        a1._head = (a1._head + 1) % a1._capacity
        a1._count = a1._count - 1
    end
end

local function recompute(a1) -- Line: 96 -- upvalues: CommandClockMaxSlewRatio (val)
    local v1
    if a1._count == 0 then
        a1._worstDepth = nil
        a1._bestDepth = nil
        a1._errorTicks = 0
        a1._rate = 1
        return
    end
    local Depth = nil
    local Depth_2 = nil
    local v2 = 0
    local v3 = a1._count - 1
    for i = 0, v3 do
        v1 = a1._samples[(a1._head + i) % a1._capacity + 1]
        if v1 ~= nil then
            if Depth == nil or v1.Depth < Depth then
                Depth = v1.Depth
            end
            if Depth_2 == nil or Depth_2 < v1.Depth then
                Depth_2 = v1.Depth
            end
            if v1.Depth < a1._targetDepth then
                v2 = v2 + 1
            end
        end
    end
    a1._worstDepth = Depth
    a1._bestDepth = Depth_2
    if Depth ~= nil and Depth_2 ~= nil then
        local _targetDepth = a1._targetDepth
        local v4 = 0
        if _targetDepth + 0.5 < Depth then
            v4 = Depth - (_targetDepth + 0.5)
        elseif Depth < _targetDepth - 0.5 and v2 >= 2 then
            v4 = Depth - _targetDepth
        end
        a1._errorTicks = v4
        if a1._enabled and v4 ~= 0 then
            a1._rate = math.clamp(
                1 - v4 / math.max(1, a1._windowSeconds * a1._config.SimulationHz),
                1 - CommandClockMaxSlewRatio,
                1 + CommandClockMaxSlewRatio
            )
            return
        end
        a1._rate = 1
        return
    end
    a1._errorTicks = 0
    a1._rate = 1
end

function u13.observe(a1, a2, a3) -- Line: 151
    -- upvalues: prune (val), recompute (val)
    local v1 = false
    if typeof(a2) == "number" then
        v1 = false
        if a2 == a2 then
            v1 = false
            if a2 > (-1 / 0) then
                v1 = a2 < (1 / 0)
            end
        end
    end
    assert(v1, "invalid command buffer depth")
    v1 = false
    if typeof(a3) == "number" then
        v1 = false
        if a3 == a3 then
            v1 = false
            if a3 > (-1 / 0) then
                v1 = a3 < (1 / 0)
            end
        end
    end
    if v1 then
        v1 = a3 >= 0
    end
    assert(v1, "invalid command clock time")
    prune(a1, a3)
    if a1._capacity <= a1._count then
        a1._head = (a1._head + 1) % a1._capacity
        a1._count = a1._count - 1
    end
    local v2 = (a1._head + a1._count) % a1._capacity + 1
    v1 = a1._samples[v2]
    if v1 ~= nil then
        v1.Depth = a2
        v1.AtSeconds = a3
    else
        a1._samples[v2] = {Depth = a2, AtSeconds = a3}
    end
    a1._count = a1._count + 1
    recompute(a1)
end

function u13.rate(a1, a2) -- Line: 173 -- upvalues: prune (val), recompute (val) -- types: a1: table, a2: number
    local v1 = false
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
    assert(v1, "invalid command clock time")
    prune(a1, a2)
    recompute(a1)
    return a1._rate
end

function u13.diagnostics(a1) -- Line: 180
    return table.freeze({
        Rate = a1._rate,
        WorstDepth = a1._worstDepth,
        BestDepth = a1._bestDepth,
        TargetDepth = a1._targetDepth,
        ErrorTicks = a1._errorTicks,
        SampleCount = a1._count,
    })
end

return table.freeze(u13)