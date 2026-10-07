-- ReplicatedStorage.Shared.Spring
-- Script path: ReplicatedStorage.Shared.Spring
-- Decompile time: 2.19 ms

local u0 = {}
u0.__index = u0
local exp = math.exp
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt

function u0.new(a1, a2, a3) -- Line: 21 -- upvalues: u0 (val)
    assert(type(a1) == "number", "damping ratio must be a number")
    assert(type(a2) == "number", "frequency must be a number")
    assert(0 <= a1 * a2, "Spring does not converge")
    return (setmetatable({
        d = a1,
        f = a2 * 0.2,
        g = a3,
        p = a3,
        v = a3 * 0,
    }, u0))
end

function u0.setDampingRatio(a1, a2) -- Line: 35 -- types: a1: table, a2: number
    a1.d = a2
end

function u0.setFrequency(a1, a2) -- Line: 39 -- types: a1: table, a2: number
    a1.f = a2 * 0.2
end

function u0.setGoal(a1, a2) -- Line: 43
    a1.g = a2
end

function u0.getGoal(a1) -- Line: 47
    return a1.g
end

function u0.setPosition(a1, a2) -- Line: 51
    a1.p = a2
end

function u0.getPosition(a1) -- Line: 55
    return a1.p
end

function u0.getVelocity(a1) -- Line: 59
    return a1.v / 0.2
end

function u0.impulse(a1, a2) -- Line: 63
    a1.v = a1.v + a2 * 0.2
end

function u0.reset(a1, a2) -- Line: 67
    a1.g = a2
    a1.p = a1.g
    a1.v = a1.g * 0
end

function u0.update(a1, a2) -- Line: 73 -- upvalues: exp (val), sqrt (val), cos (val), sin (val)
    local v1, v2
    local d = a1.d
    local v3 = a1.f * 2 * 3.141592653589793
    local g = a1.g
    local p = a1.p
    local v = a1.v
    local v4 = p - g
    local v5 = exp(-d * v3 * a2)
    if d == 1 then
        v2 = (v4 * (1 + v3 * a2) + v * a2) * v5 + g
        v1 = (v * (1 - v3 * a2) - v4 * (v3 * v3 * a2)) * v5
    else
        local v6, v7, v8, v9, v10
        if not (d < 1) then
            v6 = sqrt(d * d - 1)
            v7 = -v3 * (d - v6)
            v8 = -v3 * (d + v6)
            v9 = (v - v4 * v7) / (2 * v3 * v6)
            v10 = (v4 - v9) * exp(v7 * a2)
            local v11 = v9 * exp(v8 * a2)
            v2 = v10 + v11 + g
            v1 = v10 * v7 + v11 * v8
        else
            local v12
            v6 = sqrt(1 - d * d)
            v7 = cos(v3 * v6 * a2)
            v8 = sin(v3 * v6 * a2)
            if not (v6 > 0.0001) then
                v12 = a2 * v3
                v9 = v12 + (v12 * v12 * (v6 * v6) * (v6 * v6) / 20 - v6 * v6) * (v12 * v12 * v12) / 6
            else
                v9 = v8 / v6
            end
            if not (0.0001 < v3 * v6) then
                v10 = v3 * v6
                v12 = a2 + (a2 * a2 * (v10 * v10) * (v10 * v10) / 20 - v10 * v10) * (a2 * a2 * a2) / 6
            else
                v12 = v8 / (v3 * v6)
            end
            v2 = (v4 * (v7 + d * v9) + v * v12) * v5 + g
            v1 = (v * (v7 - v9 * d) - v4 * (v9 * v3)) * v5
        end
    end
    a1.p = v2
    a1.v = v1
    return v2
end

return u0