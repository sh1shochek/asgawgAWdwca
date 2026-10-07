-- ReplicatedStorage.MovementV2.DamageTag
-- Script path: ReplicatedStorage.MovementV2.DamageTag
-- Decompile time: 1.56 ms

local Config = require(script.Parent.Config)
local u5 = {}
local u8 = buffer.create(4)
u5.MinimumPredictableTicks = 2
u5.NetworkSafetyTicks = 2
u5.RecoverySeconds = 0.2
u5.RecoveryPerSecond = 1 / u5.RecoverySeconds

local function isFinite(a1) -- Line: 15
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

function u5.isValidModifier(a1) -- Line: 19
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
        v1 = false
        if a1 >= 0 then
            v1 = a1 <= 1
        end
    end
    return v1
end

local function canonicalModifier(a1) -- Line: 23 -- upvalues: u8 (val) -- types: a1: number
    buffer.writef32(u8, 0, a1)
    return (buffer.readf32(u8, 0))
end

function u5.predictableDelayTicks(a1, a2, a3, a4) -- Line: 28
    -- upvalues: u5 (val), Config (val)
    local v1 = false
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
        v1 = a3 > 0
    end
    assert(v1, "damage-tag step must be finite and positive")
    v1 = false
    if a4 % 1 == 0 then
        v1 = u5.MinimumPredictableTicks <= a4
    end
    assert(v1, "invalid damage-tag horizon")
    v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 == a1 then
            v1 = false
            if a1 > (-1 / 0) then
                v1 = a1 < (1 / 0)
            end
        end
    end
    local v2 = if not v1 then 0 else math.max(a1, 0)
    local v3 = false
    if typeof(a2) == "number" then
        v3 = false
        if a2 == a2 then
            v3 = false
            if a2 > (-1 / 0) then
                v3 = a2 < (1 / 0)
            end
        end
    end
    return (math.clamp(
        (if not v3 then 0 else math.max(math.floor(a2), 0)) + math.ceil(v2 / a3 * (1 + Config.CommandClockMaxSlewRatio)) + u5.NetworkSafetyTicks,
        u5.MinimumPredictableTicks,
        a4
    ))
end

function u5.apply(a1, a2) -- Line: 48 -- upvalues: u5 (val), u8 (val) -- types: a1: number, a2: number
    assert(u5.isValidModifier(a1), "invalid current velocity modifier")
    assert(u5.isValidModifier(a2), "invalid incoming velocity modifier")
    local v1 = math.min(a1, a2)
    buffer.writef32(u8, 0, v1)
    return (buffer.readf32(u8, 0))
end

function u5.recover(a1, a2) -- Line: 54 -- upvalues: u5 (val), u8 (val) -- types: a1: number, a2: number
    assert(u5.isValidModifier(a1), "invalid current velocity modifier")
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
        v1 = a2 > 0
    end
    assert(v1, "damage-tag delta must be finite and positive")
    v1 = math.min(a1 + u5.RecoveryPerSecond * a2, 1)
    buffer.writef32(u8, 0, v1)
    return (buffer.readf32(u8, 0))
end

return table.freeze(u5)