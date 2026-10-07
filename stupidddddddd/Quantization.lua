-- ReplicatedStorage.MovementV2.Quantization
-- Script path: ReplicatedStorage.MovementV2.Quantization
-- Decompile time: 1.98 ms

local u0 = {}

function u0.isFinite(a1) -- Line: 10
    local v1 = false
    if typeof(a1) == "number" then
        v1 = a1 - a1 == 0
    end
    return v1
end

function u0.isFiniteVector2(a1) -- Line: 14
    if typeof(a1) ~= "Vector2" then
        return false
    end
    local X = a1.X
    local Y = a1.Y
    local v1 = false
    if X - X == 0 then
        v1 = Y - Y == 0
    end
    return v1
end

function u0.isFiniteVector3(a1) -- Line: 22
    if typeof(a1) ~= "Vector3" then
        return false
    end
    local X = a1.X
    local Y = a1.Y
    local Z = a1.Z
    local v1 = false
    if X - X == 0 then
        v1 = false
        if Y - Y == 0 then
            v1 = Z - Z == 0
        end
    end
    return v1
end

function u0.isVector3Within(a1, a2) -- Line: 30 -- upvalues: u0 (val) -- types: a2: number
    local v1 = u0.isFiniteVector3(a1)
    if v1 then
        v1 = false
        if math.abs(a1.X) <= a2 then
            v1 = false
            if math.abs(a1.Y) <= a2 then
                v1 = math.abs(a1.Z) <= a2
            end
        end
    end
    return v1
end

function u0.writeVector3F32(a1, a2, a3) -- Line: 38 -- types: a1: buffer, a2: number, a3: vector
    local X = a3.X
    buffer.writef32(a1, a2, X)
    local v1 = a2 + 4
    local Y = a3.Y
    buffer.writef32(a1, v1, Y)
    v1 = a2 + 8
    local Z = a3.Z
    buffer.writef32(a1, v1, Z)
    return a2 + 12
end

function u0.readVector3F32(a1, a2) -- Line: 45 -- types: a1: buffer, a2: number
    local v1 = buffer.readf32(a1, a2)
    local v2 = a2 + 4
    local v3 = buffer.readf32(a1, v2)
    local v4 = a2 + 8
    return (Vector3.new(v1, v3, (buffer.readf32(a1, v4)))), a2 + 12
end

function u0.canonicalMove(a1) -- Line: 54 -- types: a1: userdata
    return Vector2.new(math.clamp(a1.X, -1, 1), (math.clamp(a1.Y, -1, 1)))
end

function u0.quantizeSignedUnit(a1) -- Line: 59 -- types: a1: number
    return (math.clamp(math.round((math.clamp(a1, -1, 1)) * 127), -127, 127))
end

function u0.dequantizeSignedUnit(a1) -- Line: 63 -- types: a1: number
    return (math.clamp(a1 / 127, -1, 1))
end

function u0.quantizeYaw(a1) -- Line: 67 -- types: a1: number
    return math.round(a1 % 6.283185307179586 / 6.283185307179586 * 65536) % 65536
end

function u0.dequantizeYaw(a1) -- Line: 72 -- types: a1: number
    local v1 = a1 / 65536 * 6.283185307179586
    if v1 >= 3.141592653589793 then
        return v1 - 6.283185307179586
    end
    return v1
end

function u0.quantizeUnitByte(a1) -- Line: 77 -- types: a1: number
    return (math.clamp(math.round((math.clamp(a1, 0, 1)) * 255), 0, 255))
end

function u0.dequantizeUnitByte(a1) -- Line: 81 -- types: a1: number
    return (math.clamp(a1 / 255, 0, 1))
end

function u0.quantizeNormal(a1) -- Line: 85 -- types: a1: vector
    local Unit
    return (math.round((if not (1e-08 < a1.Magnitude) then Vector3.new(0, 0, 0) else a1.Unit).X * 32767)), (math.round(Unit.Y * 32767)), (math.round(Unit.Z * 32767))
end

function u0.dequantizeNormal(a1, a2, a3) -- Line: 90 -- types: a1: number, a2: number, a3: number
    local v1 = Vector3.new(a1 / 32767, a2 / 32767, a3 / 32767)
    if 1e-08 < v1.Magnitude then
        return v1.Unit
    end
    return (Vector3.new(0, 0, 0))
end

return table.freeze(u0)