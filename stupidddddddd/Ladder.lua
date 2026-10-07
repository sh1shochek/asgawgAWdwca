-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.Ladder
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.Ladder
-- Decompile time: 5.84 ms

require(script.Parent.Parent.ProvenTypes)
local ProvenMath = require(script.Parent.Parent.ProvenMath)
local Trace = require(script.Parent.Trace)
local TraceRules = require(script.Parent.TraceRules)
local SlideMove = require(script.Parent.SlideMove)
local v1 = {}
local line = Trace.line
local vector = Trace.vector
local tryPlayerMove = SlideMove.tryPlayerMove
local getTraceSurfaceVelocity = TraceRules.getTraceSurfaceVelocity
local isWalkableGround = TraceRules.isWalkableGround
local WALL_CONTACT_SEPARATION = SlideMove.WALL_CONTACT_SEPARATION

local function getViewBasis(a1, a2) -- Line: 31 -- types: a1: number, a2: number?
    local v1 = 0
    if typeof(a2) == "number" then
        v1 = math.clamp(a2, -1, 1)
    end
    local v2 = Vector3.new(-math.sin(a1), 0, -(math.cos(a1)))
    local v3 = math.sqrt((math.max(0, 1 - v1 * v1)))
    local v4 = Vector3.new(v2.X * v3, v1, v2.Z * v3)
    if v4.Magnitude <= 1e-06 then
        v4 = v2
    end
    local v5 = Vector3.new(math.cos(a1), 0, -(math.sin(a1)))
    if v5.Magnitude <= 1e-06 then
        v5 = Vector3.new(1, 0, 0)
    end
    return v4.Unit, v5.Unit
end

local function computeLadderVelocity(a1, a2, a3, a4) -- Line: 71
    -- upvalues: getViewBasis (val), vector (val), line (val)
    local Unit
    local LadderSpeed = a4.LadderSpeed
    if a1.Duck or a1.Walk then
        LadderSpeed = LadderSpeed * a4.LadderClimbModifier
    end
    local v1 = math.clamp(-a1.MoveVector.Y, -1, 1)
    local v2 = math.clamp(a1.MoveVector.X, -1, 1)
    local v3 = v1 * LadderSpeed
    local v4 = v2 * LadderSpeed
    if (math.abs(v3)) <= 1e-06 and (math.abs(v4)) <= 1e-06 then
        return (Vector3.new(0, 0, 0))
    end
    local v5, v6 = getViewBasis(a1.LookYaw, a1.VerticalLook)
    local v7 = v5 * v3 + v6 * v4
    local v8 = Vector3.new(0, 1, 0):Cross(a2)
    local v9 = a2:Cross(if not (v8.Magnitude <= 1e-06) then v8.Unit else Vector3.new(1, 0, 0))
    local v10 = v7:Dot(a2)
    local v11 = a2 * v10
    local v12 = v7 - v11
    local v13 = v9:Dot(v12)
    local v14 = Unit:Dot(v12)
    local v15 = Unit * v14 + v11
    if 1e-06 < v15.Magnitude and (v15.Unit:Dot(a2)) < a4.LadderDampenAngle then
        v12 = v9 * v13 + Unit * (a4.LadderDampen * v14)
    end
    local v16 = (v12 - v9 * v10) * a4.LadderLateralScale
    if a3 and v10 > 0 then
        v16 = v16 + a2 * a4.LadderSpeed
    end
    vector("proven.ladderVelocity", Vector3.new(0, 0, 0), v16, v10, 0, line(1))
    return v16
end

local function isClimbableTrace(a1, a2) -- Line: 132
    local hullRecord = a1 and a1.hullRecord
    if hullRecord ~= nil and hullRecord.climbable == true then
        return a1.normal.Y < a2.WalkableFloor
    end
    return false
end

local function considerLadderTrace(a1, a2, a3, a4) -- Line: 141 -- types: a2: vector
    local hullRecord = a3 and a3.hullRecord
    if not (if hullRecord == nil then false else if hullRecord.climbable == true then a3.normal.Y < a4.WalkableFloor else false) then
        return a1
    end
    if a1 == nil then
        return a3
    end
    local Magnitude = (a1.endPos - a2).Magnitude
    local Magnitude_2 = (a3.endPos - a2).Magnitude
    if Magnitude_2 + a4.PositionSnapEpsilon < Magnitude then
        return a3
    end
    if (math.abs(Magnitude_2 - Magnitude)) <= a4.PositionSnapEpsilon then
        local Unit, Unit_2
        if a1 == nil then
            Unit = Vector3.new(0, 0, 1)
        else
            local v1 = Vector3.new(a1.normal.X, 0, a1.normal.Z)
            Unit = if not (1e-06 < v1.Magnitude) then Vector3.new(0, 0, 1) else v1.Unit
        end
        if a3 == nil then
            Unit_2 = Vector3.new(0, 0, 1)
        else
            local v2 = Vector3.new(a3.normal.X, 0, a3.normal.Z)
            Unit_2 = if not (1e-06 < v2.Magnitude) then Vector3.new(0, 0, 1) else v2.Unit
        end
        if Unit_2.Y < Unit.Y then
            return a3
        end
    end
    return a1
end

local function findLadderTrace(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 171
    -- upvalues: considerLadderTrace (val)
    local v1
    if not a3:HasClimbableNear(a1, a2, a7 + a4.PositionSnapEpsilon) then
        return nil
    end
    local u42 = nil

    local function traceDirection(a1_2) -- Line: 187
        -- upvalues: a3 (val), a1 (val), a7 (val), a2 (val), u42 (ref), considerLadderTrace (upval), a4 (val)
        local v1 = a3:Sweep(a1, a1 + a1_2 * a7, a2)
        u42 = considerLadderTrace(u42, a1, v1, a4)
    end

    if typeof(a6) == "Vector3" then
        v1 = Vector3.new(a6.X, 0, a6.Z)
        if 1e-06 < v1.Magnitude then
            local v2 = a3:Sweep(a1, a1 - v1.Unit * a7, a2)
            u42 = considerLadderTrace(u42, a1, v2, a4)
            if u42 ~= nil then
                return u42
            end
        end
    end
    if typeof(a5) == "Vector3" then
        v1 = Vector3.new(a5.X, 0, a5.Z)
        if 1e-06 < v1.Magnitude then
            local v3 = a3:Sweep(a1, a1 + v1.Unit * a7, a2)
            u42 = (considerLadderTrace(u42, a1, v3, a4))
            return u42
        end
    end
    if a8 then
        return nil
    end
    v1 = a3:Sweep(a1, a1 + Vector3.new(1, 0, 0) * a7, a2)
    u42 = considerLadderTrace(u42, a1, v1, a4)
    v1 = a3:Sweep(a1, a1 + Vector3.new(-1, -0, -0) * a7, a2)
    u42 = considerLadderTrace(u42, a1, v1, a4)
    v1 = a3:Sweep(a1, a1 + Vector3.new(0, 0, 1) * a7, a2)
    u42 = considerLadderTrace(u42, a1, v1, a4)
    v1 = a3:Sweep(a1, a1 + Vector3.new(-0, -0, -1) * a7, a2)
    u42 = (considerLadderTrace(u42, a1, v1, a4))
    return u42
end

function v1.getLadderNormal(a1, a2) -- Line: 52 -- types: a2: vector?
    local v1
    if a1 ~= nil then
        v1 = Vector3.new(a1.normal.X, 0, a1.normal.Z)
        if 1e-06 < v1.Magnitude then
            return v1.Unit
        end
    end
    if typeof(a2) == "Vector3" then
        v1 = Vector3.new(a2.X, 0, a2.Z)
        if 1e-06 < v1.Magnitude then
            return v1.Unit
        end
    end
    return (Vector3.new(0, 0, 1))
end

v1.findLadderTrace = findLadderTrace

function v1.simulateLadderMove(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 225
    -- upvalues: getTraceSurfaceVelocity (val), computeLadderVelocity (val), tryPlayerMove (val), isWalkableGround (val)
    -- upvalues: findLadderTrace (val), ProvenMath (val), WALL_CONTACT_SEPARATION (val)
    local Unit, Unit_2, v1, v2, v3, v4, v5, v6
    if a7 ~= nil then
        v1 = Vector3.new(a7.normal.X, 0, a7.normal.Z)
        if 1e-06 < v1.Magnitude then
            Unit = v1.Unit
        elseif typeof(a8) ~= "Vector3" then
            Unit = Vector3.new(0, 0, 1)
        else
            v1 = Vector3.new(a8.X, 0, a8.Z)
            Unit = if not (1e-06 < v1.Magnitude) then Vector3.new(0, 0, 1) else v1.Unit
        end
    elseif typeof(a8) ~= "Vector3" then
        Unit = Vector3.new(0, 0, 1)
    else
        v1 = Vector3.new(a8.X, 0, a8.Z)
        Unit = if not (1e-06 < v1.Magnitude) then Vector3.new(0, 0, 1) else v1.Unit
    end
    v1 = getTraceSurfaceVelocity(a7)
    local v7 = computeLadderVelocity(a2, Unit, a9, a5)
    local v8 = v7.Y < -a5.PositionSnapEpsilon
    v2, v3, _, v4, v5 = tryPlayerMove(a1, v7 + v1, a3, a4, a5, a6, v8, a10)
    if v8 and isWalkableGround(v5, a5) then
        return {
            detached = true,
            position = v2,
            velocity = v3,
            impactTrace = v5,
            touchedWall = v4,
        }
    end
    local v9 = findLadderTrace(v2, a6, a4, a5, ProvenMath.flatten(v3), Unit, a5.LadderDetachDistance, false)
    if v9 == nil then
        return {
            detached = true,
            position = v2,
            velocity = v3,
            impactTrace = v5,
            touchedWall = v4,
        }
    end
    if v9 ~= nil then
        v6 = Vector3.new(v9.normal.X, 0, v9.normal.Z)
        if 1e-06 < v6.Magnitude then
            Unit_2 = v6.Unit
        elseif typeof(Unit) ~= "Vector3" then
            Unit_2 = Vector3.new(0, 0, 1)
        else
            v6 = Vector3.new(Unit.X, 0, Unit.Z)
            Unit_2 = if not (1e-06 < v6.Magnitude) then Vector3.new(0, 0, 1) else v6.Unit
        end
    elseif typeof(Unit) ~= "Vector3" then
        Unit_2 = Vector3.new(0, 0, 1)
    else
        v6 = Vector3.new(Unit.X, 0, Unit.Z)
        Unit_2 = if not (1e-06 < v6.Magnitude) then Vector3.new(0, 0, 1) else v6.Unit
    end
    v6 = getTraceSurfaceVelocity(v9)
    local v10 = v3 - v1
    local v11 = v10:Dot(Unit_2)
    if v11 ~= 0 then
        v10 = v10 - Unit_2 * v11
    end
    v3 = v10 + v6
    return {
        detached = false,
        position = v9.endPos + Unit_2 * math.max(a5.PositionSnapEpsilon, WALL_CONTACT_SEPARATION),
        velocity = v3,
        contactTrace = v9,
        impactTrace = v5 or v9,
        touchedWall = v4,
    }
end

return table.freeze(v1)