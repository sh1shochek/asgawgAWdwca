-- ReplicatedStorage.MovementV2.Collision.DestructibleFrame
-- Script path: ReplicatedStorage.MovementV2.Collision.DestructibleFrame
-- Decompile time: 2.41 ms

local Schema = require(script.Parent.Schema)
local u5 = {}

local function isUInt32(a1) -- Line: 16
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= 4294967295
            end
        end
    end
    return v1
end

local function validateBits(a1, a2) -- Line: 20 -- types: a1: number, a2: string
    local v1 = math.ceil(a1 / 8)
    if #a2 ~= v1 then
        return false, string.format("active bitset has %d bytes; expected %d", #a2, v1)
    end
    local v2 = a1 % 8
    if v2 ~= 0 and v1 > 0 then
        local v3 = string.byte(a2, v1)
        if 2 ^ v2 - 1 < v3 then
            return false, "active bitset has non-zero padding bits"
        end
    end
    return true, nil
end

function u5.Validate(a1, a2, a3, a4) -- Line: 38 -- upvalues: Schema (val), validateBits (val)
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= 4294967295
            end
        end
    end
    if v1 and a1 ~= 0 and not (Schema.MaxEpoch < a1) then
        v1 = false
        if typeof(a2) == "number" then
            v1 = false
            if a2 % 1 == 0 then
                v1 = false
                if a2 >= 0 then
                    v1 = a2 <= 4294967295
                end
            end
        end
        if not v1 then
            return false, "revision must be a u32"
        end
        if typeof(a3) == "number" and a3 % 1 == 0 and not (a3 < 0) and not (Schema.MaxDestructibleCount < a3) then
            if typeof(a4) ~= "string" then
                return false, "active bitset must be a string"
            end
            return validateBits(a3, a4)
        end
        return false, string.format("count must be an integer in [0, %d]", Schema.MaxDestructibleCount)
    end
    return false, "epoch must be a non-zero u16"
end

function u5.New(a1, a2, a3, a4) -- Line: 55
    -- upvalues: u5 (val)
    local v1, v2 = u5.Validate(a1, a2, a3, a4)
    assert(v1, v2)
    return (table.freeze({Epoch = a1, Revision = a2, Count = a3, ActiveBits = a4}))
end

function u5.AllActive(a1, a2, a3) -- Line: 67
    -- upvalues: Schema (val), u5 (val)
    local v1 = false
    if a3 % 1 == 0 then
        v1 = false
        if a3 >= 0 then
            v1 = a3 <= Schema.MaxDestructibleCount
        end
    end
    assert(v1, "invalid destructible count")
    local v2 = math.floor(a3 / 8)
    v1 = a3 % 8
    local v3 = string.rep("ÿ", v2)
    if v1 ~= 0 then
        v3 = v3 .. string.char(2 ^ v1 - 1)
    end
    return u5.New(a1, a2, a3, v3)
end

function u5.IsActive(a1, a2) -- Line: 80 -- types: a1: table, a2: number
    local v1 = false
    if a2 % 1 == 0 then
        v1 = false
        if a2 >= 1 then
            v1 = a2 <= a1.Count
        end
    end
    assert(v1, "destructible index is outside the frame")
    local v2 = a2 - 1
    v1 = math.floor(v2 / 8) + 1
    local v3 = v2 % 8
    return bit32.band(string.byte(a1.ActiveBits, v1), (bit32.lshift(1, v3))) ~= 0
end

return table.freeze(u5)