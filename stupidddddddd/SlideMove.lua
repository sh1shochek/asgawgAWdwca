-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.SlideMove
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.SlideMove
-- Decompile time: 12.17 ms

require(script.Parent.Parent.ProvenTypes)
local ProvenMath = require(script.Parent.Parent.ProvenMath)
local Trace = require(script.Parent.Trace)
local TraceRules = require(script.Parent.TraceRules)
local v1 = {}
local line = Trace.line
local vector = Trace.vector
local magnitudeSq = ProvenMath.magnitudeSq
local isPointTestBlocked = TraceRules.isPointTestBlocked
local getTraceClipNormal = TraceRules.getTraceClipNormal
local getWallConstraintNormal = TraceRules.getWallConstraintNormal
local isDynamicWallContactRecord = TraceRules.isDynamicWallContactRecord
local isFloorSupportTrace = TraceRules.isFloorSupportTrace
local u31 = {ignoreDynamicPlayerAabbs = true}

local function warmStartStaticWallContact(a1, a2, a3, a4, a5, a6) -- Line: 39
    -- upvalues: getWallConstraintNormal (val), isDynamicWallContactRecord (val), getTraceClipNormal (val)
    -- upvalues: ProvenMath (val)
    if typeof(a3) == "Vector3" and not (a3.Magnitude <= 1e-06) then
        local v1 = getWallConstraintNormal(a3, a5)
        if not (v1.Magnitude <= 1e-06) and not (a5.WalkableFloor <= v1.Y) then
            local Unit = v1.Unit
            local v2 = a4:Sweep(a1, a1 - Unit * 0.005, a6)
            local v3 = nil
            local Unit_2 = nil
            if v2.startSolid or v2.allSolid then
                v3 = "probeEmbedded"
            elseif 1 <= v2.fraction then
                v3 = "wallOutsideRetentionDistance"
            elseif a5.WalkableFloor <= v2.normal.Y then
                v3 = "walkableProbe"
            elseif isDynamicWallContactRecord(v2.hullRecord) then
                v3 = "dynamicWall"
            elseif v2.hullRecord.surfaceVelocity == nil
                or not (a5.PositionSnapEpsilon < v2.hullRecord.surfaceVelocity.Magnitude) then
                Unit_2 = getWallConstraintNormal(getTraceClipNormal(v2, a5), a5)
                if not (Unit_2.Magnitude <= 1e-06) then
                    Unit_2 = Unit_2.Unit
                    if (Unit_2:Dot(Unit)) < 0.995 then
                        v3 = "wallNormalMismatch"
                    end
                else
                    v3 = "invalidProbeNormal"
                end
            else
                v3 = "movingWall"
            end
            local v4 = if Unit_2 == nil then nil else a2:Dot(Unit_2)
            if v3 == nil and v4 ~= nil and a5.VelocityEpsilon < v4 then
                v3 = "clearlySeparating"
            end
            if v3 == nil and Unit_2 ~= nil and v4 ~= nil then
                return ProvenMath.clipVelocity(a2, Unit_2, a5.Overbounce), Unit_2, v2
            end
            return a2, nil, nil
        end
        return a2, nil, nil
    end
    return a2, nil, nil
end

local function constrainVelocityAgainstClipPlanes(a1, a2, a3, a4) -- Line: 100
    -- upvalues: ProvenMath (val)
    local v1, v2
    local v3 = a3
    for i = 1, v3 do
        v1 = ProvenMath.clipVelocity(a1, a2[i], a4.Overbounce)
        v2 = true
        for j = 1, a3 do
            if j ~= i and (v1:Dot(a2[j])) < 0 then
                v2 = false
                break
            end
        end
        if v2 then
            return v1
        end
    end
    if a3 == 2 then
        v3 = a2[1]:Cross(a2[2])
        if 0 < v3.Magnitude then
            local Unit = v3.Unit
            return Unit * a1:Dot(Unit)
        end
    end
    return (Vector3.new(0, 0, 0))
end

local function isPlayerEscapePathClear(a1, a2, a3, a4, a5) -- Line: 134
    -- upvalues: u31 (val), isPointTestBlocked (val)
    if isPointTestBlocked((a4:Sweep(a1, a2, a3, u31))) then
        return false
    end
    if a2.Y < a1.Y - a5.PositionSnapEpsilon
        and isPointTestBlocked((a4:FloorSupportSweep(a1, a2, a3, a5.WalkableFloor))) then
        return false
    end
    return true
end

local function escapeOverlappingBrushes(a1, a2, a3, a4, a5) -- Line: 159
    -- upvalues: isPointTestBlocked (val)
    local hullRecord, v1, v2, v3
    local sourceId = a2
    local Unit = a3
    local v4, v5 = a4, a5
    for i = 1, 6 do
        if Unit.Y < 0 then
            return nil
        end
        v1 = nil
        for j = 1, 32 do
            v2 = a1 + Unit * (j * 0.02)
            v3 = v5:PointTest(v2, v4)
            if not isPointTestBlocked(v3) then
                return v2
            end
            hullRecord = v3.hullRecord
            if hullRecord ~= nil
                and hullRecord.buildMode ~= "dynamicPlayerAabb"
                and hullRecord.allowsPlayerDepenetration ~= false then
                if hullRecord.sourceId == sourceId then
                    continue
                end
                v1 = v2
                sourceId = hullRecord.sourceId
                if 1e-06 < v3.normal.Magnitude then
                    Unit = v3.normal.Unit
                    break
                end
                Unit = Vector3.new(0, 1, 0)
                break
            end
            return nil
        end
        if v1 == nil then
            return nil
        end
    end
    return nil
end

v1.WALL_CONTACT_SEPARATION = 0.001
v1.WALL_RECOVERY_SEPARATION = 0.02

function v1.tryPlayerMove(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) -- Line: 283
    -- upvalues: warmStartStaticWallContact (val), vector (val), line (val), magnitudeSq (val)
    -- upvalues: isFloorSupportTrace (val), getTraceClipNormal (val), ProvenMath (val), isPointTestBlocked (val)
    -- upvalues: constrainVelocityAgainstClipPlanes (val)
    local v1, v2, v3, v4, v5, v6, v7, v8
    local endPos_2 = a1
    local v9 = false
    local v10 = false
    local v11 = nil
    local v12 = nil
    local v13 = nil
    local v14 = a3
    local v15 = a2
    local v16 = a2
    local v17 = a8 or table.create(a5.MaxClipPlanes)
    table.clear(v17)
    local v18 = 0
    local v19 = 0
    local v20 = a5.PositionSnapEpsilon * a5.PositionSnapEpsilon
    local v21, v22, v23 = warmStartStaticWallContact(endPos_2, a2, a10, a4, a5, a6)
    local v24 = v21
    local v25 = v23
    vector("proven.tryPlayerMove.warmStart", endPos_2, v24, 0, 0, line(1))
    if v22 ~= nil then
        v10 = true
        v11 = v25
        v12 = v25
        v15 = v24
        v16 = v24
    end
    v21 = 0
    v22 = 0
    v23 = 0
    local v26, v27, v28 = a7, a6, a4
    while v21 < 4 do
        v21 = v21 + 1
        if magnitudeSq(v24) <= v20 or v14 <= 0 then
            break
        end
        v1 = v24 * v14
        if magnitudeSq(v1) <= v20 then
            break
        end
        v2 = if v26 ~= true then v28:Sweep(endPos_2, endPos_2 + v1, v27) else v28:SweepWithFloorSupport(endPos_2, endPos_2 + v1, v27)
        if v26 == true and isFloorSupportTrace(v2) then
            if v2.startSolid then
                if v7.PositionSnapEpsilon < (v24:Dot(v2.normal)) then
                    v2 = v28:Sweep(endPos_2, endPos_2 + v1, v27)
                end
            elseif v2.allSolid and v7.PositionSnapEpsilon < (v24:Dot(v2.normal)) then
                v2 = v28:Sweep(endPos_2, endPos_2 + v1, v27)
            end
        end
        if v8 ~= nil then
            if v8 == "ground" then
                if 0.0001 < v2.fraction and v28.CanonicalizeExpandedBlockCornerTrace ~= nil then
                    v28:CanonicalizeExpandedBlockCornerTrace(v2, v1, v27, v8)
                end
            elseif v7.VelocityEpsilon < v24.Y
                and 0.0001 < v2.fraction
                and v28.CanonicalizeExpandedBlockCornerTrace ~= nil then
                v28:CanonicalizeExpandedBlockCornerTrace(v2, v1, v27, v8)
            end
        end
        if 0 < v2.fraction and v2.fraction < 0.0001 then
            v2.fraction = 0
        end
        v19 = v19 + v2.fraction
        vector(
            "proven.tryPlayerMove.sweepResult",
            v2.endPos,
            v24,
            v2.fraction,
            not (v2.hullRecord == nil) and v2.hullRecord.sourceId or 0,
            line(1)
        )
        if not v2.allSolid then
            if 0 < v2.fraction then
                endPos_2 = v2.endPos
                v16 = v24
                table.clear(v17)
                v18 = 0
            end
            vector("proven.tryPlayerMove.positionAdvance", endPos_2, v24, v2.fraction, 0, line(1))
            if 1 <= v2.fraction then
                break
            end
            v9 = true
            v11 = v2
            v14 = math.max(0, v14 - v14 * v2.fraction)
            if not (v2.normal.Y < v7.WalkableFloor) then
                v13 = v2
            else
                v10 = true
                v12 = v2
            end
            v3 = getTraceClipNormal(v2, v7)
            if magnitudeSq(v3) <= v20 then
                v24 = Vector3.new(0, 0, 0)
                break
            end
            if v2.fraction == 0 and not v2.startSolid and v2.normal.Y < v7.WalkableFloor then
                endPos_2 = endPos_2 + v3 * 0.001
            end
            if v2.fraction == 0 and not v2.startSolid then
                v4 = v24:Dot(v3)
                if -v7.VelocityEpsilon <= v4 then
                    v24 = ProvenMath.clipVelocity(v24, v3, v7.Overbounce)
                    v16 = v24
                    vector("proven.tryPlayerMove.grazingClip", endPos_2, v24, v2.fraction, 0, line(1))
                    if v22 < 2 then
                        v22 = v22 + 1
                        v21 = v21 - 1
                    end
                    continue
                end
            end
            if v7.MaxClipPlanes <= v18 then
                v24 = Vector3.new(0, 0, 0)
                break
            end
            v18 = v18 + 1
            v17[v18] = v3
            v24 = constrainVelocityAgainstClipPlanes(v16, v17, v18, v7)
            vector("proven.tryPlayerMove.clipPlanes", endPos_2, v24, v2.fraction, v18, line(1))
            if not (magnitudeSq(v24) <= v20) and not ((v24:Dot(v15)) <= 0) then
                continue
            end
            v24 = Vector3.new(0, 0, 0)
            break
        else
            v11 = v2
            if not (v2.normal.Y < v7.WalkableFloor) then
                return endPos_2, Vector3.new(0, 0, 0), true, v10, v11, v12, v2
            else
                v3 = getTraceClipNormal(v2, v7)
                v4 = endPos_2 + v3 * 0.02
                v5 = ProvenMath.clipVelocity(v24, v3, v7.Overbounce)
                v6 = nil
                if v23 >= 1 then
                    v6 = "recoveryBudgetExhausted"
                elseif magnitudeSq(v3) <= v20 then
                    v6 = "invalidNormal"
                elseif isPointTestBlocked(v28:PointTest(v4, v27)) then
                    v6 = "queryPositionBlocked"
                elseif magnitudeSq(v5) <= v20 then
                    v6 = "recoveredVelocityTooSmall"
                elseif (v5:Dot(v15)) <= 0 then
                    v6 = "recoveredVelocityReversed"
                end
                if v6 ~= nil then
                    return endPos_2, Vector3.new(0, 0, 0), true, true, v11, v2, v13
                else
                    v23 = v23 + 1
                    v9 = true
                    vector("proven.tryPlayerMove.allSolidRecovery", v4, v5, v2.fraction, 0, line(1))
                end
            end
        end
    end
    if v19 == 0 then
        v24 = Vector3.new(0, 0, 0)
    end
    vector("proven.tryPlayerMove.final", endPos_2, v24, v19, v18, line(1))
    return endPos_2, v24, v9, v10, v11, v12, v13
end

function v1.escapeStartSolid(a1, a2, a3) -- Line: 206
    -- upvalues: isPlayerEscapePathClear (val), escapeOverlappingBrushes (val)
    local startSolid, startSolid_2, v1, v2, v3, v4, v5, v6, v7, v8, v9
    local v10 = a3:PointTest(a1, a2)
    if not v10.startSolid and not v10.allSolid then
        return nil
    end
    local hullRecord = v10.hullRecord
    if hullRecord ~= nil and hullRecord.allowsPlayerDepenetration == false then
        return nil
    end
    local normal = v10.normal
    local Unit = if not (1e-06 < normal.Magnitude) then Vector3.new(0, 1, 0) else normal.Unit
    local Config = a3.Config
    local v11 = false
    if hullRecord ~= nil then
        v11 = hullRecord.buildMode == "dynamicPlayerAabb"
    end
    local sourceId = if hullRecord == nil then nil else hullRecord.sourceId
    local v12 = v11 and (math.abs(Unit.Y)) < Config.WalkableFloor
    local v13 = 0
    local v14, v15, v16 = a1, a2, a3
    for i = 1, 32 do
        v1 = i * 0.02
        v2 = v14 + Unit * v1
        v3 = v16:PointTest(v2, v15)
        startSolid = v3.startSolid or v3.allSolid
        if not startSolid and (not v11 or isPlayerEscapePathClear(v14, v2, v15, v16, Config)) then
            if not v12 then
                return v2
            end
            v4 = v13
            v5 = v1
            v6 = v2
            while true do
                if not (Config.PositionSnapEpsilon < v5 - v4) then
                    break
                end
                v7 = (v4 + v5) * 0.5
                v8 = v14 + Unit * v7
                v9 = v16:PointTest(v8, v15)
                startSolid_2 = v9.startSolid or v9.allSolid
                if not startSolid_2 and isPlayerEscapePathClear(v14, v8, v15, v16, Config) then
                    v6 = v8
                end
            end
            return v6
        end
    end
    if Unit.Y < 0.9 then
        local startSolid_3
        for j = 1, 32 do
            v1 = v14 + Vector3.new(0, j * 0.02, 0)
            v2 = v16:PointTest(v1, v15)
            startSolid_3 = v2.startSolid or v2.allSolid
            if not startSolid_3 and (not v11 or isPlayerEscapePathClear(v14, v1, v15, v16, Config)) then
                return v1
            end
        end
    end
    if not v11 and sourceId ~= nil then
        return (escapeOverlappingBrushes(v14, sourceId, Unit, v15, v16))
    end
    return nil
end

return table.freeze(v1)