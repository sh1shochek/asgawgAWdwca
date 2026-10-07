-- ReplicatedStorage.MovementV2.RuntimeKinematics
-- Script path: ReplicatedStorage.MovementV2.RuntimeKinematics
-- Decompile time: 0.71 ms

local u0 = {}
local u4 = setmetatable({}, {__mode = "k"})

function u0.write(a1, a2, a3, a4) -- Line: 15
    -- upvalues: u4 (val)
    if a1 == nil then
        return
    end
    local v1 = u4[a1]
    if v1 == nil then
        u4[a1] = {Velocity = a2, OnGround = a3, Position = a4}
        return
    end
    v1.Velocity = a2
    v1.OnGround = a3
    v1.Position = a4
end

function u0.clear(a1) -- Line: 35 -- upvalues: u4 (val) -- types: a1: userdata?
    if a1 ~= nil then
        u4[a1] = nil
    end
end

function u0.read(a1) -- Line: 41 -- upvalues: u4 (val) -- types: a1: userdata?
    if a1 == nil then
        return nil
    end
    return u4[a1]
end

function u0.getVelocity(a1, a2) -- Line: 45 -- upvalues: u0 (val) -- types: a1: userdata?, a2: userdata?
    local v1 = u0.read(a1)
    if v1 ~= nil then
        return v1.Velocity, true
    end
    if a2 ~= nil then
        return a2.AssemblyLinearVelocity, false
    end
    return Vector3.new(0, 0, 0), false
end

function u0.getPosition(a1, a2) -- Line: 58 -- upvalues: u0 (val) -- types: a1: userdata?, a2: userdata?
    local v1 = u0.read(a1)
    if v1 ~= nil and v1.Position ~= nil then
        return v1.Position, true
    end
    if a2 ~= nil then
        return a2.Position, false
    end
    return Vector3.new(0, 0, 0), false
end

function u0.isOnGround(a1) -- Line: 71 -- upvalues: u0 (val) -- types: a1: userdata?
    local v1 = u0.read(a1)
    if v1 ~= nil then
        return v1.OnGround, true
    end
    return false, false
end

function u0.resolve(a1, a2) -- Line: 80 -- upvalues: u0 (val) -- types: a1: userdata?, a2: userdata?
    local v1, v2 = u0.getVelocity(a1, a2)
    local v3, v4 = u0.isOnGround(a1)
    local v5 = Vector3.new(v1.X, 0, v1.Z)
    return v1, v5, v5.Magnitude, v1.Y, v3, v2 or v4
end

return table.freeze(u0)