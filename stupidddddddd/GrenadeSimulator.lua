-- ReplicatedStorage.Shared.GrenadeSimulator
-- Script path: ReplicatedStorage.Shared.GrenadeSimulator
-- Decompile time: 6.18 ms

local u0 = {}
u0.Constants = {
    GRENADE_ELASTICITY = 0.4,
    FLOOR_NORMAL_THRESHOLD = 0.7,
    FIXED_TIMESTEP = 0.0078125,
    GRAVITY = Vector3.new(0, -23.83333396911621, 0),
    THROW_UPWARD_BIAS_FAR = 0.06,
    THROW_UPWARD_BIAS_NEAR = 0.04,
    THROW_FORWARD_OFFSET = 1.35,
    THROW_HEIGHT_OFFSET = 2.4,
    MAX_SIMULATION_TIME = 10,
}

function u0.createInitialState(a1, a2, a3, a4, a5, a6) -- Line: 159
    -- upvalues: 
    local v1, v2
    local v3 = ((if a3 ~= "Far" then 0 else 1) * 0.7 + 0.3) * 57.29166666666667 * a5 * 0.58
    local v4 = if not (5 < a4.Y) then 1 else 1
    local v5 = a1
    if v2 then
        v5 = a1 + Vector3.new(0, 0, 0)
    end
    local v6 = if not v2 then Vector3.new(0, a4.Y * 2 * 0.58, 0) else Vector3.new(0, 20, 0)
    local Unit = a2
    if v2 then
        Unit = Vector3.new(a2.X * v4, a2.Y, a2.Z * v4).Unit
    end
    local v7 = Unit * v3 + v6
    v7 = v7 + (Vector3.new(a2.X * (if not v2 then 1 else v4), a2.Y, a2.Z * v1).Unit * v3 * 0.15 + Vector3.new(0, a5 * 6.5 * 0.58, 0))
    local v8 = if not v2 then 50 else (a2.Y - 0.4) * 20 + 62
    if v8 < v7.Magnitude then
        v7 = v7.Unit * v8
    end
    local v9 = v7 + (Vector3.new(a4.X, 0, a4.Z)) * 1.5 * v4
    local v10 = math.floor(a6 * 1000) % 1000
    return {
        simulationTime = 0,
        bounceCount = 0,
        isGrounded = false,
        isAtRest = false,
        hasTouched = false,
        accumulatedTime = 0,
        position = v5,
        velocity = v9,
        angularVelocity = Vector3.new(v10 % 11 - 5, math.floor(v10 / 11) % 13 - 6, (math.floor(v10 / 143)) % 11 - 5),
        timestamp = a6,
        isJumpThrow = v2,
    }
end

function u0.createConfig(a1, a2, a3, a4, a5, a6) -- Line: 246
    -- upvalues: 
    return {
        restitution = 0.4,
        maxBounces = 20,
        radius = a1,
        fuseTime = a4,
        minimumFuseTime = a5,
        explodeOnFloorImpact = a6,
        rangeScale = a2,
        isNearThrow = a3,
    }
end

function u0.detectCollision(a1, a2, a3, a4) -- Line: 269 -- types: a1: vector, a2: vector, a3: number, a4: userdata
    local v1, v2
    local v3 = a2 - a1
    local Magnitude = v3.Magnitude
    if Magnitude < 0.001 then
        return nil
    end
    local v4 = a3 * 0.01
    local v5 = {
        Vector3.new(v4, 0, 0),
        Vector3.new(-v4, 0, 0),
        Vector3.new(0, v4, 0),
        Vector3.new(0, -v4, 0),
        Vector3.new(0, 0, v4),
        (Vector3.new(0, 0, -v4)),
    }
    local v6 = nil
    local Distance = (1 / 0)
    local v7 = Vector3.new(0, 0, 0)
    local v8 = workspace:Raycast(a1, v3, a4)
    if v8 and v8.Distance < Distance then
        v6 = v8
        Distance = v8.Distance
        v7 = Vector3.new(0, 0, 0)
    end
    for i, j in v5 do
        v1 = a1 + j
        v2 = workspace:Raycast(v1, v3, a4)
        if v2 and v2.Distance < Distance then
            v6 = v2
            Distance = v2.Distance
            v7 = j
        end
    end
    if not v6 then
        return nil
    end
    local v9 = v6.Position - v7
    local Magnitude_2 = (v9 - a1).Magnitude
    if Magnitude + v4 + 0.1 < Magnitude_2 then
        return nil
    end
    local Instance = v6.Instance
    local Parent = Instance.Parent
    v1 = false
    if Parent ~= nil then
        v1 = Parent:IsA("Model") and Parent:GetAttribute("CharacterType") == "PlayerCustomCharacter"
    end
    v2 = Parent and Parent:HasTag("BreakableGlass") or Instance:HasTag("BreakableGlass")
    return {
        hit = true,
        position = v9,
        normal = v6.Normal,
        distance = Magnitude_2,
        instance = Instance,
        isPlayer = v1,
        isGlass = v2,
    }
end

function u0.checkGrounded(a1, a2) -- Line: 352 -- types: a1: vector, a2: userdata
    local v1 = workspace:Raycast(a1, Vector3.new(0, -0.20000000298023224, 0), a2)
    if v1 then
        return true, v1.Normal
    end
    return false, nil
end

local function PhysicsClipVelocity(a1, a2, a3) -- Line: 367 -- types: a1: vector, a2: vector, a3: number
    local v1 = a1:Dot(a2) * a3
    local v2 = a1.X - a2.X * v1
    local v3 = a1.Y - a2.Y * v1
    local v4 = a1.Z - a2.Z * v1
    if (math.abs(v2)) < 0.0076388888888888895 then
        v2 = 0
    end
    if (math.abs(v3)) < 0.0076388888888888895 then
        v3 = 0
    end
    if (math.abs(v4)) < 0.0076388888888888895 then
        v4 = 0
    end
    return (Vector3.new(v2, v3, v4))
end

function u0.integrate(a1, a2, a3, a4) -- Line: 391 -- types: a1: vector, a2: vector, a3: number, a4: boolean
    if a4 then
        return a1 + a2 * a3, a2
    end
    local v1 = a2.Y - a3 * 23.83333396911621
    local v2 = (a2.Y + v1) / 2
    local v3 = Vector3.new(a2.X * a3, v2 * a3, a2.Z * a3)
    local v4 = Vector3.new(a2.X, v1, a2.Z)
    return a1 + v3, v4
end

function u0.calculateBounce(a1, a2, a3, a4) -- Line: 421
    -- upvalues: PhysicsClipVelocity (val)
    local v1 = table.clone(a3)
    v1.bounceCount = a3.bounceCount + 1
    v1.hasTouched = true
    local v2 = math.clamp((if not a3.isJumpThrow then 0.4 else 0.32) * (if not a4 then 1 else 0.3), 0, 0.9)
    local v3 = PhysicsClipVelocity(a1, a2, 2) * v2
    if 0.7 < a2.Y and (v3:Dot(v3)) < 2.3341049382716053 then
        return Vector3.new(0, 0, 0), v1
    end
    return v3, v1
end

function u0.shouldStop(a1, a2, a3) -- Line: 455 -- types: a1: vector, a2: boolean, a3: boolean
    if a2 and a3 then
        return (a1:Dot(a1)) < 2.3341049382716053
    end
    return false
end

local function newEvent(a1, a2, a3, a4, a5) -- Line: 473
    -- upvalues: 
    return {
        type = a1,
        timestamp = a2.timestamp + a3.simulationTime,
        position = a3.position,
        normal = a4,
        velocity = a5,
        bounceCount = a3.bounceCount,
    }
end

function u0.step(a1, a2, a3, a4) -- Line: 490
    -- upvalues: u0 (val)
    local v1, v2, v3
    local v4 = table.clone(a1)
    v4.simulationTime = a1.simulationTime + a4
    if 10 <= v4.simulationTime then
        v4.isAtRest = true
        local velocity = v4.velocity
        return v4, {
            type = "timeout",
            normal = Vector3.new(0, 1, 0),
            timestamp = a1.timestamp + v4.simulationTime,
            position = v4.position,
            velocity = velocity,
            bounceCount = v4.bounceCount,
        }
    end
    if a2.fuseTime and a2.fuseTime <= v4.simulationTime then
        v4.isAtRest = true
        local velocity_2 = v4.velocity
        return v4, {
            type = "fuse",
            normal = Vector3.new(0, 1, 0),
            timestamp = a1.timestamp + v4.simulationTime,
            position = v4.position,
            velocity = velocity_2,
            bounceCount = v4.bounceCount,
        }
    end
    if a2.maxBounces <= a1.bounceCount then
        v4.isAtRest = true
        v4.velocity = Vector3.new(0, 0, 0)
        return v4, {
            type = "rest",
            normal = Vector3.new(0, 1, 0),
            velocity = Vector3.new(0, 0, 0),
            timestamp = a1.timestamp + v4.simulationTime,
            position = v4.position,
            bounceCount = v4.bounceCount,
        }
    end
    local position = v4.position
    local v5, v6 = u0.integrate(v4.position, v4.velocity, a4, v4.isGrounded)
    local v7 = u0.detectCollision(position, v5, a2.radius, a3)
    if not v7 then
        v4.position = v5
        v4.velocity = v6
        v1, v2 = u0.checkGrounded(v4.position, a3)
        v4.isGrounded = v1
        if u0.shouldStop(v4.velocity, v1, v4.hasTouched) then
            if (not a2.minimumFuseTime or a2.minimumFuseTime <= v4.simulationTime) and not a2.fuseTime then
                v4.isAtRest = true
                v4.velocity = Vector3.new(0, 0, 0)
                v4.angularVelocity = Vector3.new(0, 0, 0)
                return v4, {
                    type = "rest",
                    velocity = Vector3.new(0, 0, 0),
                    timestamp = a1.timestamp + v4.simulationTime,
                    position = v4.position,
                    normal = v2 or Vector3.new(0, 1, 0),
                    bounceCount = v4.bounceCount,
                }
            end
        end
        return v4, nil
    end
    v2, v3 = u0.calculateBounce(v6, v7.normal, v4, v7.isPlayer)
    v4 = v3
    v4.position = v7.position + v7.normal * 0.05
    v4.velocity = v2
    v2 = 0.7 < v7.normal.Y
    if a2.explodeOnFloorImpact and v2 then
        if not a2.minimumFuseTime or a2.minimumFuseTime <= v4.simulationTime then
            v4.isAtRest = true
            local normal = v7.normal
            local velocity_3 = v4.velocity
            return v4, {
                type = "floor_impact",
                timestamp = a1.timestamp + v4.simulationTime,
                position = v4.position,
                normal = normal,
                velocity = velocity_3,
                bounceCount = v4.bounceCount,
            }
        end
    end
    local normal_2 = v7.normal
    local velocity_4 = v4.velocity
    local v8 = {
        type = "bounce",
        timestamp = a1.timestamp + v4.simulationTime,
        position = v4.position,
        normal = normal_2,
        velocity = velocity_4,
        bounceCount = v4.bounceCount,
    }
    v1, v2 = u0.checkGrounded(v4.position, a3)
    v4.isGrounded = v1
    if u0.shouldStop(v4.velocity, v1, v4.hasTouched) then
        if (not a2.minimumFuseTime or a2.minimumFuseTime <= v4.simulationTime) and not a2.fuseTime then
            v4.isAtRest = true
            v4.velocity = Vector3.new(0, 0, 0)
            v4.angularVelocity = Vector3.new(0, 0, 0)
            return v4, {
                type = "rest",
                velocity = Vector3.new(0, 0, 0),
                timestamp = a1.timestamp + v4.simulationTime,
                position = v4.position,
                normal = v2 or Vector3.new(0, 1, 0),
                bounceCount = v4.bounceCount,
            }
        end
    end
    return v4, v8
end

function u0.simulate(a1, a2, a3, a4) -- Line: 581
    -- upvalues: u0 (val)
    local v1, v2, v3, v4
    if a1.isAtRest then
        if not a2.fuseTime then
            return {state = a1, events = {}}
        end
        v1 = table.clone(a1)
        v1.simulationTime = a1.simulationTime + a4
        if a2.fuseTime <= v1.simulationTime then
            return {
                state = v1,
                events = {
                    {
                        type = "fuse",
                        normal = Vector3.new(0, 1, 0),
                        timestamp = a1.timestamp + v1.simulationTime,
                        position = v1.position,
                        velocity = v1.velocity,
                        bounceCount = v1.bounceCount,
                    },
                },
            }
        end
        return {state = v1, events = {}}
    end
    v1 = table.clone(a1)
    v1.accumulatedTime = a1.accumulatedTime + a4
    if 0.1 < v1.accumulatedTime then
        v1.accumulatedTime = 0.1
    end
    local v5 = {}
    local v6 = 0
    local v7, v8 = a2, a3
    while 0.0078125 <= v1.accumulatedTime do
        if not (v6 < 16) then
            break
        end
        v6 = v6 + 1
        v1.accumulatedTime = v1.accumulatedTime - 0.0078125
        v3, v4 = u0.step(v1, v7, v8, 0.0078125)
        v2 = v4
        if v2 then
            table.insert(v5, v2)
        end
        if v3.isAtRest then
            break
        end
    end
    return {state = v1, events = v5}
end

function u0.calculateThrowParameters(a1, a2, a3, a4) -- Line: 657
    -- upvalues: 
    local v1
    local v2 = (if not (a3 == "Near") then 0.06 else 0.04) * math.clamp(a4, 0.8, 1.2)
    local v3 = 1.35
    local v4 = 2.4
    if not v1 then
        v4 = v4 + 0.1
    else
        v3 = v3 * 0.55
        v4 = v4 * 0.8
        v2 = v2 + 0.08
    end
    local Unit = (a2 + Vector3.new(0, v2, 0)).Unit
    local v5 = Vector3.new(a2.X, 0, a2.Z)
    if v5.Magnitude < 0.01 then
        v5 = Vector3.new(0, 0, -1)
    end
    return a1 + v5.Unit * v3 + Vector3.new(0, v4, 0), Unit
end

return u0