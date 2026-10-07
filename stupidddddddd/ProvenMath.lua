-- ReplicatedStorage.MovementV2.Simulation.ProvenMath
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenMath
-- Decompile time: 1.83 ms

local v1 = {}
local SpeedProfile = require(script.Parent.Parent.SpeedProfile)
local u9 = 0.03125 * SpeedProfile.HammerUnitToStud
local DefaultBaseSpeed = SpeedProfile.DefaultBaseSpeed

function v1.approach(a1, a2, a3) -- Line: 10 -- types: a1: number, a2: number, a3: number
    if a2 < a1 then
        return (math.min(a2 + a3, a1))
    end
    return (math.max(a2 - a3, a1))
end

function v1.flatten(a1) -- Line: 17 -- types: a1: vector
    return (Vector3.new(a1.X, 0, a1.Z))
end

function v1.clipVelocity(a1, a2, a3) -- Line: 21 -- upvalues: u9 (val) -- types: a1: vector, a2: vector, a3: number?
    local v1 = a1 - a2 * ((a1:Dot(a2)) * (a3 or 1))
    local v2 = v1:Dot(a2)
    if v2 <= 0 then
        v1 = v1 - a2 * math.min(v2, -u9)
    end
    return v1
end

function v1.moveVectorToWorld(a1, a2) -- Line: 33 -- types: a1: userdata, a2: number
    local v1 = math.sin(a2)
    local v2 = math.cos(a2)
    local v3 = -a1.Y
    local X = a1.X
    local v4 = v2 * X - v1 * v3
    local v5 = -v1 * X - v2 * v3
    local v6 = v4 * v4 + v5 * v5
    if v6 > 1 then
        local v7 = 1 / math.sqrt(v6)
        v4 = v4 * v7
        v5 = v5 * v7
    end
    return (Vector3.new(v4, 0, v5))
end

function v1.applyFriction(a1, a2, a3, a4, a5) -- Line: 52
    -- upvalues: 
    local X = a1.X
    local Z = a1.Z
    local v1 = X * X + Z * Z
    if v1 <= 0 then
        return a1
    end
    local v2 = math.sqrt(v1)
    if v2 <= 0 then
        return a1
    end
    local v3 = math.max(v2 - (math.max(v2, a4)) * a3 * a5 * a2, 0)
    if v3 ~= v2 and v2 > 0 then
        local v4 = v3 / v2
        X = X * v4
        Z = Z * v4
    end
    return (Vector3.new(X, a1.Y, Z))
end

function v1.accelerate(a1, a2, a3, a4, a5, a6, a7) -- Line: 84
    -- upvalues: DefaultBaseSpeed (val)
    local v1 = a3 - a1:Dot(a2)
    if v1 <= 0 then
        return a1
    end
    local v2 = (math.max(DefaultBaseSpeed, a3)) * a7
    return a1 + a2 * math.min(a4 * a5 * v2 * a6, v1)
end

function v1.airAccelerate(a1, a2, a3, a4, a5, a6, a7) -- Line: 104
    -- upvalues: 
    local v1 = (math.min(a3, a5)) - a1:Dot(a2)
    if v1 <= 0 then
        return a1
    end
    local v2 = a4 * a3 * a6 * a7
    if v1 < v2 then
        v2 = v1
    end
    return a1 + a2 * v2
end

function v1.legacyBunnyHopAirAccelerate(a1, a2, a3, a4, a5, a6) -- Line: 129
    -- upvalues: 
    local v1 = math.min(a3, a5)
    local v2 = v1 - a1:Dot(a2)
    if v2 <= 0 then
        return a1
    end
    return a1 + a2 * math.min(a4 * v1 * a6, v2)
end

function v1.clampHorizontal(a1, a2) -- Line: 149 -- types: a1: vector, a2: number
    local X = a1.X
    local Z = a1.Z
    local v1 = X * X + Z * Z
    if a2 * a2 < v1 and v1 > 0 then
        local v2 = a2 / math.sqrt(v1)
        X = X * v2
        Z = Z * v2
    end
    return (Vector3.new(X, a1.Y, Z))
end

function v1.horizontalMagnitude(a1) -- Line: 161 -- types: a1: vector
    return (math.sqrt(a1.X * a1.X + a1.Z * a1.Z))
end

function v1.magnitudeSq(a1) -- Line: 165 -- types: a1: vector
    return a1.X * a1.X + a1.Y * a1.Y + a1.Z * a1.Z
end

function v1.horizontalMagnitudeSq(a1) -- Line: 169 -- types: a1: vector
    return a1.X * a1.X + a1.Z * a1.Z
end

return v1