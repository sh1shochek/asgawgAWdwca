-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.Duck
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.Duck
-- Decompile time: 7.53 ms

require(script.Parent.Parent.ProvenTypes)
local ProvenMath = require(script.Parent.Parent.ProvenMath)
local TraceRules = require(script.Parent.TraceRules)
local v1 = {}
local GROUND_PROBE_START_BUMP = TraceRules.GROUND_PROBE_START_BUMP
local getTraceNormalY = TraceRules.getTraceNormalY

local function getStandingFloorSupportTrace(a1, a2, a3) -- Line: 17 -- types: a1: vector
    return a2:FloorSupportSweep(a1, a1, "standing", a3.WalkableFloor)
end

local function isStandingFloorSupportBlocked(a1, a2) -- Line: 21 -- upvalues: GROUND_PROBE_START_BUMP (val)
    if not a1 then
        return false
    end
    if not a1.startSolid and not a1.allSolid then
        return false
    end
    local floorPenetrationDepth = a1.floorPenetrationDepth
    if typeof(floorPenetrationDepth) == "number" then
        return GROUND_PROBE_START_BUMP + a2.PositionSnapEpsilon < floorPenetrationDepth
    end
    return true
end

local function isUncrouchSweepHardBlocked(a1, a2) -- Line: 34 -- upvalues: getTraceNormalY (val)
    if not a1 then
        return false
    end
    if not a1.startSolid and not a1.allSolid and not (a1.fraction < 1) then
        return false
    end
    return (getTraceNormalY(a1, 1)) < a2.WalkableFloor
end

local function isWalkablePointOverlap(a1, a2) -- Line: 46 -- upvalues: getTraceNormalY (val)
    if not a1 then
        return false
    end
    if not a1.startSolid and not a1.allSolid then
        return false
    end
    return a2.WalkableFloor <= (getTraceNormalY(a1, 0))
end

local function getUncrouchFloorRecoveryDistance(a1, a2) -- Line: 54 -- upvalues: GROUND_PROBE_START_BUMP (val)
    local floorPenetrationDepth = a1 and a1.floorPenetrationDepth
    if typeof(floorPenetrationDepth) == "number" and floorPenetrationDepth > 0 then
        return (math.clamp(floorPenetrationDepth + a2.PositionSnapEpsilon, a2.PositionSnapEpsilon, 0.08))
    end
    return (math.max(GROUND_PROBE_START_BUMP + a2.PositionSnapEpsilon, a2.PositionSnapEpsilon))
end

local function testUncrouchStandPosition(a1, a2, a3, a4) -- Line: 67
    -- upvalues: getTraceNormalY (val), GROUND_PROBE_START_BUMP (val)
    local v1 = a3:Sweep(a1, a2, "crouching")
    if if not v1 then false else if v1.startSolid or v1.allSolid or v1.fraction < 1 then (getTraceNormalY(v1, 1)) < a4.WalkableFloor else false then
        return false, v1, nil, nil
    end
    local v2 = a3:PointTest(a2, "standing", true)
    local v3 = a3:FloorSupportSweep(a2, a2, "standing", a4.WalkableFloor)
    if not v2.startSolid and not v2.allSolid then
        local v4
        if not v3 then
            v4 = false
        elseif v3.startSolid or v3.allSolid then
            local floorPenetrationDepth = v3.floorPenetrationDepth
            v4 = if typeof(floorPenetrationDepth) ~= "number" then true else GROUND_PROBE_START_BUMP + a4.PositionSnapEpsilon < floorPenetrationDepth
        else
            v4 = false
        end
        if not v4 then
            return true, v1, v2, v3
        end
    end
    return false, v1, v2, v3
end

local function getUncrouchClearance(a1, a2, a3) -- Line: 92
    -- upvalues: getTraceNormalY (val), GROUND_PROBE_START_BUMP (val), testUncrouchStandPosition (val)
    local v1
    local v2 = a1 + Vector3.new(0, (a3.PlayerSizeStanding.Y - a3.PlayerSizeDucking.Y) * 0.5, 0)
    local v3 = a2:Sweep(a1, v2, "crouching")
    local v4 = a2:PointTest(v2, "standing", true)
    local v5 = a2:FloorSupportSweep(v2, v2, "standing", a3.WalkableFloor)
    local v6 = if not v3 then false else if v3.startSolid or v3.allSolid or v3.fraction < 1 then (getTraceNormalY(v3, 1)) < a3.WalkableFloor else false
    local startSolid = v4.startSolid or v4.allSolid
    if not v5 then
        v1 = false
    elseif v5.startSolid or v5.allSolid then
        local floorPenetrationDepth = v5.floorPenetrationDepth
        v1 = if typeof(floorPenetrationDepth) ~= "number" then true else GROUND_PROBE_START_BUMP + a3.PositionSnapEpsilon < floorPenetrationDepth
    else
        v1 = false
    end
    if not v6 then
        if not v1 then
            if not (if not v4 then false else if v4.startSolid or v4.allSolid then a3.WalkableFloor <= (getTraceNormalY(v4, 0)) else false) then
                return v6 or startSolid or v1, v2, v3, v4, v5
            end
        end
        local floorPenetrationDepth_2 = v5 and v5.floorPenetrationDepth
        local v7 = v2 + Vector3.new(
            0,
            if typeof(floorPenetrationDepth_2) ~= "number" or not (floorPenetrationDepth_2 > 0) then math.max(GROUND_PROBE_START_BUMP + a3.PositionSnapEpsilon, a3.PositionSnapEpsilon) else math.clamp(floorPenetrationDepth_2 + a3.PositionSnapEpsilon, a3.PositionSnapEpsilon, 0.08),
            0
        )
        local v8, v9, v10, v11 = testUncrouchStandPosition(a1, v7, a2, a3)
        if v8 then
            return false, v7, v9, v10, v11
        end
    end
    return v6 or startSolid or v1, v2, v3, v4, v5
end

local function getDuckSpeedFromState(a1, a2) -- Line: 120
    return (math.clamp(a1.DuckFatigueLevel / 10, 0, a2.DuckSpeedIdeal))
end

local function setDuckSpeedOnState(a1, a2, a3) -- Line: 125 -- types: a2: number
    a1.DuckFatigueLevel = math.clamp(a2, 0, a3.DuckSpeedIdeal) * 10
end

local function getDuckJumpCenterShift(a1, a2) -- Line: 134 -- types: a1: number
    return (a2.PlayerSizeStanding.Y - a2.PlayerSizeDucking.Y) * a2.DuckJumpOriginShiftFraction * math.clamp(a1, 0, 1)
end

local function applyDuckJumpCenterShift(a1, a2, a3, a4) -- Line: 139 -- types: a2: number
    local v1 = (a4.PlayerSizeStanding.Y - a4.PlayerSizeDucking.Y) * a4.DuckJumpOriginShiftFraction * math.clamp(a2, 0, 1)
    local DuckAmount = a1.DuckAmount
    local v2 = (a4.PlayerSizeStanding.Y - a4.PlayerSizeDucking.Y) * a4.DuckJumpOriginShiftFraction * math.clamp(DuckAmount, 0, 1) - v1
    if (math.abs(v2)) <= a4.PositionSnapEpsilon then
        return
    end
    if v2 < 0 and a1.Velocity.Y <= a4.VelocityEpsilon then
        return
    end
    local Position = a1.Position
    local v3 = Position + Vector3.new(0, v2, 0)
    local v4 = if not (v2 < 0) then a3:Sweep(Position, v3, if not (0.999 <= a1.DuckAmount) then "standing" else "crouching") else a3:SweepWithFloorSupport(Position, v3, if not (0.999 <= a1.DuckAmount) then "standing" else "crouching")
    if not v4.startSolid and not v4.allSolid then
        a1.Position = v4.endPos
        return
    end
end

local function isAirUncrouchBlocked(a1, a2, a3, a4) -- Line: 170
    -- upvalues: GROUND_PROBE_START_BUMP (val)
    local v1 = a3:PointTest(a1, "standing", true)
    if not v1.startSolid and not v1.allSolid then
        local v2
        local v3 = a3:FloorSupportSweep(a1, a1, "standing", a4.WalkableFloor)
        if not v3 then
            v2 = false
        elseif v3.startSolid or v3.allSolid then
            local floorPenetrationDepth = v3.floorPenetrationDepth
            v2 = if typeof(floorPenetrationDepth) ~= "number" then true else GROUND_PROBE_START_BUMP + a4.PositionSnapEpsilon < floorPenetrationDepth
        else
            v2 = false
        end
        if v2 then
            return true
        end
        v2 = (a4.PlayerSizeStanding.Y - a4.PlayerSizeDucking.Y) * a4.DuckJumpOriginShiftFraction * 0 - (a4.PlayerSizeStanding.Y - a4.PlayerSizeDucking.Y) * a4.DuckJumpOriginShiftFraction * math.clamp(a2, 0, 1)
        if not (a4.PositionSnapEpsilon < (math.abs(v2))) then
            return false
        end
        v3 = a1 + Vector3.new(0, v2, 0)
        local v4 = a3:FloorSupportSweep(a1, v3, "standing", a4.WalkableFloor)
        if not v4.startSolid and not v4.allSolid and not (v4.fraction < 1) then
            local v5 = a3:PointTest(v3, "standing", true)
            if not v5.startSolid and not v5.allSolid then
                local v6
                local v7 = a3:FloorSupportSweep(v3, v3, "standing", a4.WalkableFloor)
                if not v7 then
                    v6 = false
                elseif v7.startSolid or v7.allSolid then
                    local floorPenetrationDepth_2 = v7.floorPenetrationDepth
                    v6 = if typeof(floorPenetrationDepth_2) ~= "number" then true else GROUND_PROBE_START_BUMP + a4.PositionSnapEpsilon < floorPenetrationDepth_2
                else
                    v6 = false
                end
                if v6 then
                    return true
                end
                return false
            end
            return true
        end
        return true
    end
    return true
end

function v1.getStance(a1) -- Line: 130
    if 0.999 <= a1.DuckAmount then
        return "crouching"
    end
    return "standing"
end

v1.getUncrouchClearance = getUncrouchClearance

function v1.applyDuckStateForStep(a1, a2, a3, a4, a5, a6) -- Line: 208
    -- upvalues: ProvenMath (val), isAirUncrouchBlocked (val), getUncrouchClearance (val)
    -- upvalues: applyDuckJumpCenterShift (val)
    local v1, v2, v3
    local v4 = math.clamp(a2.DuckAmount, 0, 1)
    local v5 = a2.DuckHeld == true
    local Duck = a3.Duck and not v5
    local v6 = not a3.Duck and v5
    local v7 = not a2.OnGround and a2.MovementType ~= "Ladder"
    local v8 = v4 >= 0.999
    local v9 = nil
    local v10 = math.max(a6.TimeToDuckMsecs, 1)
    local v11 = math.max(a6.TimeToUnDuckMsecs, 1)
    local v12 = math.clamp(a2.DuckFatigueLevel / 10, 0, a6.DuckSpeedIdeal)
    local v13 = math.max(0, a2.DuckFatigueTimerMsecs - a4 * 1000)
    v12 = ProvenMath.approach(
        a6.DuckSpeedIdeal,
        v12,
        a4 * (if v4 <= 0 then a6.DuckSpeedFastRecoveryRate else if not (v4 >= 1) then a6.DuckSpeedRecoveryRate else a6.DuckSpeedFastRecoveryRate)
    )
    if Duck or v6 then
        v12 = math.max(0, v12 - a6.DuckSpamPenalty)
    end
    local v14 = a3.Duck == true
    if v14 and v12 < a6.DuckSpamMinSpeed then
        v14 = false
    end
    if v14 and v4 <= 0.75 and v13 > 0 then
        v14 = false
    end
    a1.DuckAmount = v4
    a1.IsDucking = false
    if not v14 then
        v1 = false
        if v4 > 0 then
            if not v8 or not v7 then
                if v8 then
                    v2, v3 = getUncrouchClearance(a1.Position, a5, a6)
                    if not v2 then
                        v9 = v3
                    else
                        v1 = true
                        a1.DuckAmount = 1
                        a1.IsDucking = false
                    end
                end
            elseif isAirUncrouchBlocked(a1.Position, v4, a5, a6) then
                v1 = true
                a1.DuckAmount = 1
                a1.IsDucking = false
            end
            if not v1 then
                if not v7 then
                    a1.DuckAmount = math.max(0, v4 - a4 * (math.max(a6.DuckSpeedUnduckMinimum, v12)))
                else
                    a1.DuckAmount = 0
                end
                a1.IsDucking = 0 < a1.DuckAmount
            end
        end
    else
        if v7 then
            a1.DuckAmount = 1
        elseif v4 < 1 then
            a1.DuckAmount = math.min(1, v4 + a4 * v12 * a6.DuckSpeedDuckMultiplier)
        end
        if 0.999 <= a1.DuckAmount then
            a1.DuckAmount = 1
            a1.IsDucking = false
        elseif v4 < a1.DuckAmount then
            a1.IsDucking = true
        end
    end
    if v4 < 1 and 1 <= a1.DuckAmount then
        v13 = math.max(v13, a6.TimeBetweenDucksMsecs)
    end
    a1.DuckFatigueTimerMsecs = v13
    a1.DuckFatigueLevel = math.clamp(v12, 0, a6.DuckSpeedIdeal) * 10
    v1 = if not v14 then a1.DuckAmount * v11 else (1 - a1.DuckAmount) * v10
    a1.DuckTimeMsecs = v1
    v1 = if not (0.999 <= a2.DuckAmount) then "standing" else "crouching"
    v2 = if not (0.999 <= a1.DuckAmount) then "standing" else "crouching"
    if v7 then
        applyDuckJumpCenterShift(a1, v4, a5, a6)
    end
    if a2.OnGround and v1 ~= v2 then
        v3 = (a6.PlayerSizeStanding.Y - a6.PlayerSizeDucking.Y) * 0.5
        if v2 == "crouching" then
            a1.Position = a1.Position - Vector3.new(0, v3, 0)
            return
        end
        a1.Position = assert(v9, "grounded uncrouch requires clearance")
    end
end

return table.freeze(v1)