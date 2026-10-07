-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.GroundMove
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.GroundMove
-- Decompile time: 21.30 ms

require(script.Parent.Parent.ProvenTypes)
local ProvenMath = require(script.Parent.Parent.ProvenMath)
local Trace = require(script.Parent.Trace)
local TraceRules = require(script.Parent.TraceRules)
local SlideMove = require(script.Parent.SlideMove)
local v1 = {}
local line = Trace.line
local vector = Trace.vector
local clampHorizontal = ProvenMath.clampHorizontal
local horizontalMagnitudeSq = ProvenMath.horizontalMagnitudeSq
local tryPlayerMove = SlideMove.tryPlayerMove
local GROUND_PROBE_START_BUMP = TraceRules.GROUND_PROBE_START_BUMP
local isPointTestBlocked = TraceRules.isPointTestBlocked
local getTraceSurfaceVelocity = TraceRules.getTraceSurfaceVelocity
local getImpactWallConstraintNormal = TraceRules.getImpactWallConstraintNormal
local isDynamicWallContactRecord = TraceRules.isDynamicWallContactRecord
local isFloorSupportTrace = TraceRules.isFloorSupportTrace
local getResolvedSupportPosition = TraceRules.getResolvedSupportPosition
local isWalkableGround = TraceRules.isWalkableGround
local getTraceGroundNormal = TraceRules.getTraceGroundNormal
local getTraceMinkowskiPlaneKind = TraceRules.getTraceMinkowskiPlaneKind
local isRampPrimitiveHullRecord = TraceRules.isRampPrimitiveHullRecord
local supportTraceMatchesPosition = TraceRules.supportTraceMatchesPosition
local u45 = {}
local u46 = {}
local u47 = {}
local u48 = {}

local function getClearWalkableSupportFallback(a1, a2, a3, a4, a5, a6) -- Line: 61
    -- upvalues: GROUND_PROBE_START_BUMP (val), isWalkableGround (val), getResolvedSupportPosition (val)
    -- upvalues: isPointTestBlocked (val)
    local v1 = a4:WalkableSupportSweep(a1 + Vector3.new(0, GROUND_PROBE_START_BUMP, 0), a1 - Vector3.new(0, a2, 0), a3, a5.WalkableFloor, a6)
    if not isWalkableGround(v1, a5) or isPointTestBlocked(a4:PointTest(getResolvedSupportPosition(v1, a1), a3)) then
        return nil
    end
    return v1
end

local function groundProbeWithRetry(a1, a2, a3, a4, a5, a6, a7) -- Line: 89
    -- upvalues: GROUND_PROBE_START_BUMP (val), isWalkableGround (val), getClearWalkableSupportFallback (val)
    local v1
    local v2 = a4:SupportSweep(a1 + Vector3.new(0, GROUND_PROBE_START_BUMP, 0), a1 - Vector3.new(0, a2, 0), a3, a5.WalkableFloor, a7)
    if v2.startSolid and a6 ~= false then
        v1 = math.max(GROUND_PROBE_START_BUMP, a2, a5.MaxStepHeight)
        local endPos = a4:Sweep(a1, a1 + Vector3.new(0, v1, 0), a3).endPos
        local v3 = a4:SupportSweep(endPos, endPos - Vector3.new(0, a2 + v1, 0), a3, a5.WalkableFloor, a7)
        if not v3.startSolid or not v3.allSolid then
            v2 = v3
        end
    end
    if not isWalkableGround(v2, a5) and v2.normal.Y < a5.WalkableFloor then
        v1 = getClearWalkableSupportFallback(a1, a2, a3, a4, a5, a7)
        if v1 ~= nil then
            v2 = v1
        end
    end
    return v2
end

local function getHorizontalDistanceSq(a1, a2) -- Line: 140 -- types: a1: vector, a2: vector
    local v1 = a2.X - a1.X
    local v2 = a2.Z - a1.Z
    return v1 * v1 + v2 * v2
end

local function getForwardMoveProgress(a1, a2, a3) -- Line: 146 -- types: a1: vector, a2: vector, a3: vector?
    if a3 == nil then
        return 0
    end
    local v1 = a2.X - a1.X
    local v2 = a2.Z - a1.Z
    return v1 * a3.X + v2 * a3.Z
end

local function makeGroundMoveChoice(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 156
    -- upvalues: 
    local v1
    a1.position = a3
    a1.velocity = a4
    a1.collided = a5
    a1.touchedWall = a6
    a1.impactTrace = a7
    local v2 = a3.X - a2.X
    local v3 = a3.Z - a2.Z
    a1.horizontalDistanceSq = v2 * v2 + v3 * v3
    if a8 ~= nil then
        v2 = a3.X - a2.X
        v3 = a3.Z - a2.Z
        v1 = v2 * a8.X + v3 * a8.Z
    else
        v1 = 0
    end
    a1.forwardProgress = v1
    return a1
end

local function resolveGroundDriveDirection(a1, a2, a3) -- Line: 176 -- types: a1: vector?, a2: vector, a3: number
    local v1, v2
    local v3 = a3 * a3
    if a1 ~= nil then
        local X = a1.X
        local Z = a1.Z
        v1 = X * X + Z * Z
        if v3 < v1 then
            v2 = 1 / math.sqrt(v1)
            return (Vector3.new(X * v2, 0, Z * v2))
        end
    end
    local X_2 = a2.X
    local Z_2 = a2.Z
    v1 = X_2 * X_2 + Z_2 * Z_2
    if not (v3 < v1) then
        return nil
    end
    v2 = 1 / math.sqrt(v1)
    return (Vector3.new(X_2 * v2, 0, Z_2 * v2))
end

local function getStaticWallConstraintNormal(a1, a2, a3) -- Line: 203
    -- upvalues: isDynamicWallContactRecord (val), getImpactWallConstraintNormal (val)
    if a1 == nil then
        return nil
    end
    if not (a3.WalkableFloor <= a1.normal.Y) and not isDynamicWallContactRecord(a1.hullRecord) then
        local surfaceVelocity = a1.hullRecord.surfaceVelocity
        if surfaceVelocity ~= nil and a3.PositionSnapEpsilon < surfaceVelocity.Magnitude then
            return nil
        end
        local v1 = getImpactWallConstraintNormal(a1, a3)
        if not (v1.Magnitude <= a3.PositionSnapEpsilon) then
            local v2 = math.abs(v1.Y)
            if not (a3.PositionSnapEpsilon < v2) then
                v2 = a2:Dot(v1)
                if not (-a3.VelocityEpsilon <= v2) then
                    return v1.Unit
                end
            end
        end
        return nil
    end
    return nil
end

local function getRampAdjacentWallNormal(a1, a2, a3, a4) -- Line: 226
    -- upvalues: getStaticWallConstraintNormal (val)
    if a2 ~= nil and a1 ~= nil and a1.hullRecord ~= a2.hullRecord then
        return (getStaticWallConstraintNormal(a1, a3, a4))
    end
    return nil
end

local function tryWalkableRampSupportMove(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 238
    -- upvalues: getTraceGroundNormal (val), isWalkableGround (val), isRampPrimitiveHullRecord (val)
    -- upvalues: getTraceMinkowskiPlaneKind (val), getStaticWallConstraintNormal (val), ProvenMath (val)
    -- upvalues: horizontalMagnitudeSq (val), isDynamicWallContactRecord (val), getResolvedSupportPosition (val)
    -- upvalues: isPointTestBlocked (val)
    local Unit, WalkableFloor, Y, Y_2, hullRecord, hullRecord_2, hullRecord_3, surfaceVelocity, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21
    local dispatch = 0
    while true do
        if dispatch < 44 then
            if dispatch < 22 then
                if dispatch < 11 then
                    if dispatch < 6 then
                        if dispatch < 2 then
                            if not (dispatch < 1) then
                                return nil, nil, false
                            end
                            v1 = getTraceGroundNormal(a8)
                            dispatch = if v1 ~= nil then 2 else 1
                        elseif dispatch < 3 then
                            v2 = isWalkableGround(a8, a6)
                            hullRecord = a8.hullRecord
                        else
                            if not (dispatch < 4) then
                                return nil, nil, false
                            end
                            Y = v1.Y
                            dispatch = if not (1 - a6.PositionSnapEpsilon <= Y) then 17 else 4
                        end
                    elseif dispatch < 8 then
                        dispatch = if dispatch < 7 then if not isRampPrimitiveHullRecord(hullRecord) then 13 else 7 else if getTraceMinkowskiPlaneKind(a8) ~= "playerAxis" then 13 else 8
                    elseif dispatch < 9 then
                        dispatch = if not ((Vector3.new(v1.X, 0, v1.Z)).Magnitude <= a6.PositionSnapEpsilon) then 10 else 9
                    elseif dispatch < 10 then
                        return nil, nil, false
                    else
                        Unit = v4.Unit
                        v5 = (Vector3.new(a3.X, 0, a3.Z)):Dot(Unit)
                        dispatch = if not (-a6.PositionSnapEpsilon <= v5) then 12 else 11
                    end
                elseif dispatch < 16 then
                    if dispatch < 13 then
                        if dispatch < 12 then
                            return nil, nil, false
                        end
                    elseif dispatch < 14 then
                        dispatch = if a8 ~= a9 then 15 else 14
                    else
                        if not (dispatch < 15) then
                            return nil, nil, false
                        end
                        dispatch = if getStaticWallConstraintNormal(a9, a3, a6) ~= nil then 16 else 15
                    end
                elseif dispatch < 19 then
                    if not (dispatch < 17) then
                        if not (dispatch < 18) then
                            dispatch = if a8 == nil then 21 else 19
                        end
                    end
                elseif dispatch < 20 then
                    dispatch = if a9 == nil then 21 else 20
                elseif dispatch < 21 then
                    dispatch = if a9.hullRecord ~= a8.hullRecord then 22 else 21
                end
            elseif dispatch < 33 then
                if dispatch < 27 then
                    if dispatch < 24 then
                        if dispatch < 23 then
                            v7 = getStaticWallConstraintNormal(a9, a3, a6)
                        end
                    elseif dispatch < 25 then
                        v7 = getStaticWallConstraintNormal(a9, a3, a6)
                    elseif not (dispatch < 26) then
                        dispatch = if v7 == nil then 28 else 27
                    end
                elseif dispatch < 30 then
                    if dispatch < 28 then
                        v5 = ProvenMath.clipVelocity(a3, v7, a6.Overbounce)
                    else
                        if not (dispatch < 29) then
                            return nil, nil, false
                        end
                        dispatch = if not ((horizontalMagnitudeSq(Vector3.new(v5.X, 0, v5.Z) * a4)) <= a6.PositionSnapEpsilon * a6.PositionSnapEpsilon) then 30 else 29
                    end
                elseif dispatch < 31 then
                    v9 = a6.MaxStepHeight + a6.PositionSnapEpsilon
                    v10 = a2 + v8
                    WalkableFloor = a6.WalkableFloor
                    v12 = a5:SupportSweep(v10 + Vector3.new(0, v9, 0), v10, a7, WalkableFloor)
                    dispatch = if isWalkableGround(v12, a6) then 40 else 31
                else
                    dispatch = if dispatch < 32 then if not v2 then 40 else 32 else if v7 ~= nil then 40 else 33
                end
            elseif dispatch < 38 then
                if dispatch < 35 then
                    dispatch = if dispatch < 34 then if a8 == nil then 36 else 34 else if v12 == nil then 36 else 35
                elseif dispatch < 36 then
                    dispatch = if v12.hullRecord ~= a8.hullRecord then 37 else 36
                else
                    v13 = if dispatch < 37 then nil else getStaticWallConstraintNormal(v12, a3, a6)
                end
            elseif dispatch < 41 then
                if dispatch < 39 then
                    dispatch = if v13 == nil then 40 else 39
                elseif dispatch < 40 then
                    v5 = ProvenMath.clipVelocity(a3, v13, a6.Overbounce)
                    v10 = a2 + Vector3.new(v5.X, 0, v5.Z) * a4
                    v11 = v10 + Vector3.new(0, v9, 0)
                else
                    dispatch = if isWalkableGround(v12, a6) then 43 else 41
                end
            elseif dispatch < 42 then
                dispatch = if v7 == nil then 43 else 42
            elseif dispatch < 43 then
                v12 = a5:WalkableSupportSweep(v11, v10, a7, a6.WalkableFloor)
            else
                dispatch = if isWalkableGround(v12, a6) then 45 else 44
            end
        elseif dispatch < 66 then
            if dispatch < 54 then
                if dispatch < 49 then
                    if dispatch < 46 then
                        if dispatch < 45 then
                            return nil, v12, false
                        else
                            v13 = getTraceGroundNormal(v12)
                            dispatch = if v13 ~= nil then 47 else 46
                        end
                    elseif dispatch < 47 then
                        return nil, v12, false
                    elseif not (dispatch < 48) then
                        hullRecord_2 = v12.hullRecord
                        dispatch = if hullRecord_2 == nil then 50 else 49
                    end
                elseif dispatch < 51 then
                    surfaceVelocity = if dispatch < 50 then hullRecord_2.surfaceVelocity else nil
                elseif dispatch < 52 then
                    Y_2 = v13.Y
                    dispatch = if 1 - a6.PositionSnapEpsilon <= Y_2 then 62 else 52
                else
                    dispatch = if dispatch < 53 then if hullRecord_2 == nil then 62 else 53 else if isDynamicWallContactRecord(hullRecord_2) then 62 else 54
                end
            elseif dispatch < 59 then
                dispatch = if not (dispatch < 56) then if dispatch < 57 then if v12 == nil then 59 else 57 else if dispatch < 58 then if v6 == nil then 59 else 58 else if v6.hullRecord ~= v12.hullRecord then 60 else 59 else if dispatch < 55 then if surfaceVelocity == nil then 56 else 55 else if a6.PositionSnapEpsilon < surfaceVelocity.Magnitude then 62 else 56
            elseif dispatch < 62 then
                if not (dispatch < 60) then
                    if dispatch < 61 then
                        v16 = getStaticWallConstraintNormal(v6, a3, a6)
                    else
                        dispatch = if v16 ~= nil then 74 else 62
                    end
                end
            elseif dispatch < 64 then
                return nil, v12, false
            elseif not (dispatch < 65) then
                hullRecord_3 = v12.hullRecord
                v15 = Vector3.new(v13.X, 0, v13.Z)
                dispatch = if hullRecord_3 ~= hullRecord then 70 else 66
            end
        elseif dispatch < 78 then
            if dispatch < 72 then
                if dispatch < 68 then
                    dispatch = if dispatch < 67 then if getTraceMinkowskiPlaneKind(v12) ~= "sourceFace" then 70 else 67 else if v15.Magnitude <= a6.PositionSnapEpsilon then 70 else 68
                elseif dispatch < 69 then
                    dispatch = if Unit == nil then 70 else 69
                else
                    if not (dispatch < 70) then
                        return nil, v12, false
                    end
                    dispatch = if not ((Unit:Dot(v15.Unit)) < 0.5) then 74 else 70
                end
            elseif dispatch < 75 then
                if dispatch < 73 then
                    dispatch = if not ((v1:Dot(v13.Unit)) < 0.98) then 74 else 73
                elseif dispatch < 74 then
                    return nil, v12, false
                else
                    v14 = getResolvedSupportPosition(v12, v11)
                    v15 = v14.Y - a2.Y
                    dispatch = if v15 < -a6.PositionSnapEpsilon then 76 else 75
                end
            elseif dispatch < 76 then
                dispatch = if not (v9 < v15) then 77 else 76
            elseif dispatch < 77 then
                return nil, v12, false
            else
                dispatch = if not isPointTestBlocked((a5:PointTest(v14, a7))) then 79 else 78
            end
        elseif dispatch < 83 then
            if dispatch < 80 then
                if dispatch < 79 then
                    return nil, v12, false
                else
                    dispatch = if v6 ~= nil then 81 else 80
                end
            elseif not (dispatch < 81) then
                if not (dispatch < 82) then
                    dispatch = if v6 ~= nil then 84 else 83
                end
            end
        elseif dispatch < 86 then
            if not (dispatch < 84) then
                if not (dispatch < 85) then
                    a1.position = v14
                    a1.velocity = v5
                    a1.collided = v17
                    a1.touchedWall = v18
                    a1.impactTrace = v6 or v12
                    v20 = v14.X - a2.X
                    v21 = v14.Z - a2.Z
                    a1.horizontalDistanceSq = v20 * v20 + v21 * v21
                    dispatch = if a10 ~= nil then 87 else 86
                end
            end
        elseif not (dispatch < 87) then
            if not (dispatch < 88) then
                a1.forwardProgress = v19
                return a1, v12, v3
            end
            v20 = v14.X - a2.X
            v21 = v14.Z - a2.Z
            v19 = v20 * a10.X + v21 * a10.Z
        end
    end
end

local function stayOnGround(a1, a2, a3, a4) -- Line: 388
    -- upvalues: groundProbeWithRetry (val), isWalkableGround (val), getResolvedSupportPosition (val)
    -- upvalues: GROUND_PROBE_START_BUMP (val), isPointTestBlocked (val)
    local v1
    local v2 = groundProbeWithRetry(a1, a4.MaxStepHeight, a2, a3, a4, true)
    if isWalkableGround(v2, a4) then
        v1 = getResolvedSupportPosition(v2, a1)
        if a4.PositionSnapEpsilon < (math.abs(a1.Y - v1.Y)) then
            return v1, v2
        end
        return a1, v2
    end
    if v2 and v2.normal.Y < a4.WalkableFloor then
        v1 = Vector3.new(0, a4.MaxStepHeight, 0)
        local v3 = a3:FloorSupportSweep(a1 + Vector3.new(0, GROUND_PROBE_START_BUMP, 0), a1 - v1, a2, a4.WalkableFloor)
        if isWalkableGround(v3, a4) then
            local v4 = getResolvedSupportPosition(v3, a1)
            if not isPointTestBlocked(a3:PointTest(v4, a2)) then
                return v4, v3
            end
            if not isPointTestBlocked(a3:PointTest(a1, a2)) then
                v3.endPos = a1
                return a1, v3
            end
        end
    end
    return a1, nil
end

local function stepMove(a1, a2, a3, a4, a5, a6, a7, a8) -- Line: 430
    -- upvalues: horizontalMagnitudeSq (val), resolveGroundDriveDirection (val), tryPlayerMove (val), u45 (val)
    -- upvalues: u48 (val), tryWalkableRampSupportMove (val), u46 (val), isWalkableGround (val)
    -- upvalues: getResolvedSupportPosition (val), isFloorSupportTrace (val), isPointTestBlocked (val), u47 (val)
    local v1, v2, v3, v4, v5, v6
    local v7 = Vector3.new(a2.X, 0, a2.Z)
    local v8 = horizontalMagnitudeSq(v7)
    local v9 = resolveGroundDriveDirection(a7, v7, a5.PositionSnapEpsilon)
    local v10, v11, v12, v13, v14, v15, v16 = tryPlayerMove(a1, a2, a3, a4, a5, a6, false, a8, "ground")
    local v17 = u45
    v17.position = v10
    v17.velocity = v11
    v17.collided = v12
    v17.touchedWall = v13
    v17.impactTrace = v14
    local v18 = v10.X - a1.X
    local v19 = v10.Z - a1.Z
    v17.horizontalDistanceSq = v18 * v18 + v19 * v19
    if v9 ~= nil then
        v18 = v10.X - a1.X
        v19 = v10.Z - a1.Z
        v1 = v18 * v9.X + v19 * v9.Z
    else
        v1 = 0
    end
    v17.forwardProgress = v1
    v1 = u48
    v1.choice = v17
    v1.direct = v17
    v1.step = nil
    v1.supportTrace = nil
    v1.stepVerticalDelta = 0
    v1.usedStep = false
    v18 = nil
    v19 = nil
    if v12 then
        local v20
        v20, v2 = tryWalkableRampSupportMove(u46, a1, a2, a3, a4, a5, a6, v16 or v14, v15, v9)
        if v20 ~= nil then
            v1.choice = v20
            v1.supportTrace = v2
            if not v20.touchedWall then
                return v1
            else
                v18 = v20
                v19 = v2
            end
        end
    end
    if not v12 or v8 <= a5.PositionSnapEpsilon * a5.PositionSnapEpsilon then
        return v1
    end
    v2 = Vector3.new(0, a5.MaxStepHeight + a5.PositionSnapEpsilon, 0)
    local v21 = true
    local v22 = a4:Sweep(a1, a1 + v2, a6)
    local startSolid = v22.startSolid or v22.allSolid
    local endPos = a1
    if not startSolid then
        endPos = v22.endPos
    end
    local v23 = nil
    local v24 = 0
    local v25 = a5.PositionSnapEpsilon * a5.PositionSnapEpsilon
    local v26, v27, v28, v29, v30 = tryPlayerMove(endPos, v7, a3, a4, a5, a6, false, a8)
    local v31 = a4:SupportSweep(v26, v26 - v2, a6, a5.WalkableFloor)
    if not isWalkableGround(v31, a5) and v31.normal.Y < a5.WalkableFloor then
        v3 = a4:WalkableSupportSweep(v26, v26 - v2, a6, a5.WalkableFloor)
        if isWalkableGround(v3, a5) then
            v31 = v3
        end
    end
    if isWalkableGround(v31, a5) then
        v3 = getResolvedSupportPosition(v31, v26)
        v24 = v3.Y - a1.Y
        if not (a5.MaxStepHeight + a5.PositionSnapEpsilon < v24) then
            if not isFloorSupportTrace(v31) then
                v4 = a4:FloorSupportSweep(v26, v26 - v2, a6, a5.WalkableFloor)
                if isWalkableGround(v4, a5) then
                    v5 = getResolvedSupportPosition(v4, v26)
                    local v32 = v5.Y - a1.Y
                    local v33 = v5.Y - v3.Y
                    if v5.Y + a5.PositionSnapEpsilon < v3.Y then
                        v21 = not isPointTestBlocked(a4:PointTest(v5, a6))
                    end
                    if v21
                        and v32 ~= nil
                        and v33 ~= nil
                        and v33 >= -0.02
                        and v32 <= a5.MaxStepHeight + a5.PositionSnapEpsilon then
                        v31 = v4
                        v3 = v5
                        v24 = v32
                    end
                end
            end
            if not isPointTestBlocked(a4:PointTest(v3, a6)) then
                v23 = u47
                v5 = Vector3.new(v27.X, a2.Y, v27.Z)
                v23.position = v3
                v23.velocity = v5
                v23.collided = v28
                v23.touchedWall = v29
                v23.impactTrace = v30
                local v34 = v3.X - a1.X
                local v35 = v3.Z - a1.Z
                v23.horizontalDistanceSq = v34 * v34 + v35 * v35
                if v9 ~= nil then
                    v34 = v3.X - a1.X
                    v35 = v3.Z - a1.Z
                    v6 = v34 * v9.X + v35 * v9.Z
                else
                    v6 = 0
                end
                v23.forwardProgress = v6
            end
        end
    end
    if v23 ~= nil then
        v1.step = v23
        v1.stepVerticalDelta = v24
        v3 = v18 or v17
        if v18 == nil then
            v4 = v3.horizontalDistanceSq <= v23.horizontalDistanceSq + v25
        else
            local forwardProgress = v23.forwardProgress
            v4 = v3.forwardProgress + a5.PositionSnapEpsilon < forwardProgress
        end
        v5 = false
        if v18 ~= nil then
            v5 = (math.abs(v23.forwardProgress - v3.forwardProgress)) <= a5.PositionSnapEpsilon
        end
        v6 = v5 and v3.horizontalDistanceSq <= v23.horizontalDistanceSq + v25
        if v4 or v6 then
            v1.choice = v23
            v1.usedStep = true
            v1.supportTrace = v31
        end
    end
    if v18 ~= nil and not v1.usedStep then
        v1.choice = v18
        v1.supportTrace = v19
    end
    return v1
end

v1.groundProbeWithRetry = groundProbeWithRetry

function v1.walkMove(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 621
    -- upvalues: ProvenMath (val), vector (val), line (val), clampHorizontal (val), stepMove (val)
    -- upvalues: supportTraceMatchesPosition (val), stayOnGround (val)
    local v1
    local v2 = ProvenMath.applyFriction(a2 - a10, a6, a8.Friction, a8.StopSpeed, a11)
    vector("proven.walkMove.friction", a1, v2, a4, 0, line(1))
    if a8.PositionSnapEpsilon < a4 then
        v2 = ProvenMath.accelerate(v2, a3, a4, a8.GroundAccelerate, a6, a11, a12)
        vector("proven.walkMove.accelerate", a1, v2, a4, 0, line(1))
    end
    v2 = clampHorizontal(v2, a5)
    vector("proven.walkMove.speedClamp", a1, v2, a5, 0, line(1))
    local v3 = v2 + a10
    local v4 = stepMove(a1, v3, a6, a7, a8, a9, if not (a8.PositionSnapEpsilon < a4) then nil else a3, a13)
    local position = v4.choice.position
    vector(
        "proven.walkMove.stepChoice",
        v4.choice.position,
        v4.choice.velocity,
        v4.stepVerticalDelta,
        if not v4.usedStep then 0 else 1,
        line(1)
    )
    local supportTrace = v4.supportTrace
    if supportTrace == nil
        or supportTrace.startSolid
        or supportTrace.allSolid
        or not supportTraceMatchesPosition(supportTrace, position, a8) then
        local v5, v6 = stayOnGround(position, a9, a7, a8)
        position = v5
        v1 = v6
    else
        v1 = supportTrace
    end
    local velocity_2 = v4.choice.velocity
    vector("proven.walkMove.stayOnGround", position, velocity_2, 0, 0, line(1))
    local v7 = velocity_2 - a10
    return position, velocity_2, v7, v3, v4, v1 or v4.supportTrace, v4.choice.collided, v4.choice.touchedWall, v4.choice.impactTrace
end

function v1.getGroundSupportVelocity(a1, a2, a3, a4) -- Line: 707
    -- upvalues: groundProbeWithRetry (val), isWalkableGround (val), getTraceSurfaceVelocity (val)
    local v1
    local GetRetainedGroundSurfaceVelocity = a3.GetRetainedGroundSurfaceVelocity
    if GetRetainedGroundSurfaceVelocity ~= nil then
        v1 = GetRetainedGroundSurfaceVelocity(a3)
        if typeof(v1) == "Vector3" then
            return v1, nil
        end
    end
    v1 = math.max(a4.GroundProbeDistance, a4.MaxStepHeight)
    if a3:HasUniformGroundSurfaces(a1, a2, v1) then
        return Vector3.new(0, 0, 0), nil
    end
    local v2 = groundProbeWithRetry(a1, v1, a2, a3, a4, true)
    if isWalkableGround(v2, a4) then
        return (getTraceSurfaceVelocity(v2)), v2
    end
    return Vector3.new(0, 0, 0), nil
end

return table.freeze(v1)