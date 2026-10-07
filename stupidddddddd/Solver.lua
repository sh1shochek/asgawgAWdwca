-- ReplicatedStorage.MovementV2.Simulation.Solver
-- Script path: ReplicatedStorage.MovementV2.Simulation.Solver
-- Decompile time: 4.20 ms

local Config = require(script.Parent.Config)
local ProvenMath = require(script.Parent.ProvenMath)
require(script.Parent.Types)
local u15 = {}

local function endpoint(a1, a2, a3) -- Line: 18 -- types: a1: vector, a2: vector, a3: number
    return a1:Lerp(a2, (math.clamp(a3, 0, 1)))
end

local function normalizedOrUp(a1) -- Line: 22 -- types: a1: vector
    local Magnitude = a1.Magnitude
    if Magnitude > 0 then
        return a1 / Magnitude
    end
    return (Vector3.new(0, 1, 0))
end

local function isWall(a1, a2) -- Line: 27 -- types: a1: vector, a2: number
    return math.abs(a1.Y) < a2
end

local function validateTimeInterval(a1, a2) -- Line: 31 -- types: a1: number, a2: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a2 == a2 then
            v1 = false
            if a1 >= 0 then
                v1 = false
                if a1 <= a2 then
                    v1 = a2 <= 1
                end
            end
        end
    end
    assert(v1, "movement collision time interval must be normalized and ordered")
end

local function appendPlane(a1, a2, a3) -- Line: 42 -- types: a1: table, a2: vector, a3: number
    for i, j in a1 do
        if 0.999 < (j:Dot(a2)) then
            return true
        end
    end
    if a3 <= #a1 then
        return false
    end
    table.insert(a1, a2)
    return true
end

local function clearsEveryPlane(a1, a2, a3) -- Line: 56 -- types: a1: vector, a2: table, a3: number
    for i, j in a2 do
        if (a1:Dot(j)) < -a3 then
            return false
        end
    end
    return true
end

local function resolvePlanes(a1, a2, a3) -- Line: 65
    -- upvalues: ProvenMath (val)
    local v1
    local v2 = a2
    local v3 = nil
    local v4 = nil
    local v5, v6, v7 = a2, a3, a1
    for i, j in v2, v3, v4 do
        v1 = ProvenMath.clipVelocity(v7, j)
        for k, n in v5 do
            if (v1:Dot(n)) < -v6 then
                if false then
                    return v1
                end
                break
            end
        end
        if true then
            return v1
        end
    end
    if #v5 == 2 then
        v2 = v5[1]:Cross(v5[2])
        local Magnitude = v2.Magnitude
        if v6 < Magnitude then
            v2 = v2 / Magnitude
            v4 = v2 * v7:Dot(v2)
            for m, i5 in v5 do
                if (v4:Dot(i5)) < -v6 then
                    if false then
                        return v4
                    end
                    return (Vector3.new(0, 0, 0))
                end
            end
            if true then
                return v4
            end
        end
    end
    return (Vector3.new(0, 0, 0))
end

function u15.slideMove(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 88
    -- upvalues: Config (val), appendPlane (val), resolvePlanes (val)
    local Magnitude, Normal_2, WalkableFloor, v1, v2, v3, v4, v5
    local v6 = false
    if a7 == a7 then
        v6 = false
        if a8 == a8 then
            v6 = false
            if a7 >= 0 then
                v6 = false
                if a7 <= a8 then
                    v6 = a8 <= 1
                end
            end
        end
    end
    assert(v6, "movement collision time interval must be normalized and ordered")
    local Default = a9 or Config.Default
    v6 = a3
    local v7 = a7
    local v8 = a1
    local v9 = a2
    local v10 = a2
    local v11 = {}
    local v12 = Vector3.new(0, 0, 0)
    local v13 = false
    local v14 = false
    local v15 = 0
    local MaxBumps = Default.MaxBumps
    local v16, v17, v18, v19, v20 = a10, a4, a6, a8, a5
    for i = 1, MaxBumps do
        if v6 <= 0 then
            break
        end
        v1 = v8 + v9 * v6
        v2 = if not v16 then v20:Sweep(v8, v1, v17, v18, v7, v19) else v20:SweepWithFloorSupport(v8, v1, v17, v18, v7, v19)
        if v16 then
            if v2.StartSolid then
                if Default.PositionSnapEpsilon < (v9:Dot(v2.Normal)) then
                    v2 = v20:Sweep(v8, v1, v17, v18, v7, v19)
                end
            elseif v2.AllSolid and Default.PositionSnapEpsilon < (v9:Dot(v2.Normal)) then
                v2 = v20:Sweep(v8, v1, v17, v18, v7, v19)
            end
        end
        v14 = v14 or v2.StartSolid
        if v2.AllSolid then
            v13 = true
            v9 = Vector3.new(0, 0, 0)
            break
        end
        v3 = math.clamp(v2.Fraction, 0, 1)
        if v3 > 0 and v3 < 0.0001 then
            v3 = 0
        end
        v15 = v15 + v3
        v7 = v7 + (v19 - v7) * v3
        if v3 > 0 then
            v8 = v8:Lerp(v1, (math.clamp(v3, 0, 1)))
            v10 = v9
            table.clear(v11)
        end
        if v3 >= 1 then
            break
        end
        v13 = true
        v6 = v6 * (1 - v3)
        Normal_2 = v2.Normal
        Magnitude = Normal_2.Magnitude
        v4 = if not (Magnitude > 0) then Vector3.new(0, 1, 0) else Normal_2 / Magnitude
        WalkableFloor = Default.WalkableFloor
        if math.abs(v4.Y) < WalkableFloor then
            v12 = v4
        end
        if not appendPlane(v11, v4, Default.MaxClipPlanes)
            or ((resolvePlanes(v10, v11, Default.PlaneEpsilon)):Dot(v10)) <= 0 then
            v9 = Vector3.new(0, 0, 0)
            break
        end
        v9 = v5
    end
    if v15 == 0 then
        v9 = Vector3.new(0, 0, 0)
    end
    if v9.Magnitude <= Default.VelocityEpsilon then
        v9 = Vector3.new(0, 0, 0)
    end
    return {
        Position = v8,
        Velocity = v9,
        WallNormal = v12,
        Blocked = v13,
        StartSolid = v14,
        TimeFraction = v7,
    }
end

function u15.slideDisplacement(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 204
    -- upvalues: u15 (val)
    return u15.slideMove(a1, a2, 1, a3, a4, a5, a6, a7, a8)
end

return table.freeze(u15)