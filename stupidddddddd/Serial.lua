-- ReplicatedStorage.MovementV2.Serial
-- Script path: ReplicatedStorage.MovementV2.Serial
-- Decompile time: 0.65 ms

local u0 = {UInt16Max = 65535, UInt32Max = 4294967295}

function u0.isUInt16(a1) -- Line: 13 -- upvalues: u0 (val)
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= u0.UInt16Max
            end
        end
    end
    return v1
end

function u0.isNonZeroUInt16(a1) -- Line: 17 -- upvalues: u0 (val)
    return u0.isUInt16(a1) and a1 > 0
end

function u0.isUInt32(a1) -- Line: 21 -- upvalues: u0 (val)
    local v1 = false
    if typeof(a1) == "number" then
        v1 = false
        if a1 % 1 == 0 then
            v1 = false
            if a1 >= 0 then
                v1 = a1 <= u0.UInt32Max
            end
        end
    end
    return v1
end

function u0.deltaUInt32(a1, a2) -- Line: 26 -- types: a1: number, a2: number
    local v1 = (a1 - a2) % 4294967296
    if v1 >= 2147483648 then
        v1 = v1 - 4294967296
    end
    return v1
end

function u0.deltaUInt16(a1, a2) -- Line: 35 -- types: a1: number, a2: number
    local v1 = (a1 - a2) % 65536
    if v1 >= 32768 then
        v1 = v1 - 65536
    end
    return v1
end

function u0.addUInt32(a1, a2) -- Line: 43 -- types: a1: number, a2: number
    return (a1 + a2) % 4294967296
end

function u0.isNewerUInt32(a1, a2) -- Line: 47 -- upvalues: u0 (val) -- types: a1: number, a2: number
    return u0.isUInt32(a1) and u0.isUInt32(a2) and 0 < (u0.deltaUInt32(a1, a2))
end

return table.freeze(u0)