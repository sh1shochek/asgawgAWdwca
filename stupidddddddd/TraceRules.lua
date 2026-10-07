-- ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.TraceRules
-- Script path: ReplicatedStorage.MovementV2.Simulation.ProvenSimulator.TraceRules
-- Decompile time: 5.29 ms

require(script.Parent.Parent.ProvenTypes)
local v1 = {GROUND_PROBE_START_BUMP = 0.03}

local function getWallClipNormal(a1, a2) -- Line: 24 -- types: a1: vector
    if a2.WalkableFloor <= a1.Y then
        return a1
    end
    if 0.0001 < (math.abs(a1.Y)) then
        return a1
    end
    local v1 = Vector3.new(a1.X, 0, a1.Z)
    if v1.Magnitude <= 1e-06 then
        return a1
    end
    return v1.Unit
end

local function getTraceCylinderAxis(a1) -- Line: 40
    local hullRecord = a1 and a1.hullRecord
    if hullRecord and hullRecord.sourceShape == "Cylinder" then
        local sourceCFrame = hullRecord.sourceCFrame
        if typeof(sourceCFrame) == "CFrame" then
            return sourceCFrame.RightVector
        end
        return nil
    end
    return nil
end

local function isCylinderWalkableGroundTrace(a1, a2) -- Line: 151
    if a1 and not (1 <= a1.fraction) and not (a1.normal.Y < a2.WalkableFloor) then
        local hullRecord = a1.hullRecord
        if hullRecord ~= nil and hullRecord.sourceShape == "Cylinder" then
            local RightVector
            local hullRecord_2 = a1 and a1.hullRecord
            if not hullRecord_2 then
                RightVector = nil
            elseif hullRecord_2.sourceShape == "Cylinder" then
                local sourceCFrame = hullRecord_2.sourceCFrame
                RightVector = if typeof(sourceCFrame) ~= "CFrame" then nil else sourceCFrame.RightVector
            else
                RightVector = nil
            end
            if RightVector ~= nil and not (RightVector.Magnitude <= 1e-06) then
                local Unit = RightVector.Unit
                if (math.abs(Unit.Y)) < a2.WalkableFloor then
                    return true
                end
                return 0.85 <= (math.abs((a1.normal:Dot(Unit))))
            end
            return false
        end
        return true
    end
    return false
end

function v1.getTraceNormalY(a1, a2) -- Line: 14 -- types: a2: number
    if a1 ~= nil then
        return a1.normal.Y
    end
    return a2
end

function v1.isPointTestBlocked(a1) -- Line: 19
    return a1.startSolid or a1.allSolid or a1.fraction ~= 1
end

function v1.getTraceClipNormal(a1, a2) -- Line: 52
    local normal = a1.normal
    if normal.Y < a2.WalkableFloor then
        local v1 = normal
        if a2.WalkableFloor <= v1.Y then
            return v1
        end
        if 0.0001 < (math.abs(v1.Y)) then
            return v1
        end
        local v2 = Vector3.new(v1.X, 0, v1.Z)
        if v2.Magnitude <= 1e-06 then
            return v1
        end
        normal = v2.Unit
    end
    return normal
end

function v1.getWallConstraintNormal(a1, a2) -- Line: 61 -- types: a1: vector
    local Unit = a1
    if Unit.Y < a2.WalkableFloor then
        local v1 = Unit
        if a2.WalkableFloor <= v1.Y then
            return v1
        end
        if 0.0001 < (math.abs(v1.Y)) then
            return v1
        end
        local v2 = Vector3.new(v1.X, 0, v1.Z)
        if v2.Magnitude <= 1e-06 then
            return v1
        end
        Unit = v2.Unit
    end
    return Unit
end

function v1.getTraceSurfaceVelocity(a1) -- Line: 70
    local hullRecord = a1.hullRecord
    if hullRecord then
        return hullRecord.surfaceVelocity
    end
    return (Vector3.new(0, 0, 0))
end

function v1.getTraceSurfaceFriction(a1, a2) -- Line: 75
    local hullRecord = a1.hullRecord
    if hullRecord then
        return hullRecord.surfaceFriction
    end
    return a2.SurfaceFrictionDefault
end

function v1.getImpactWallConstraintNormal(a1, a2) -- Line: 80
    if a1 and not (a2.WalkableFloor <= a1.normal.Y) then
        local v1, v2
        local normal_2 = a1.normal
        if normal_2.Y < a2.WalkableFloor then
            v1 = normal_2
            if not (a2.WalkableFloor <= v1.Y) then
                v2 = math.abs(v1.Y)
                if not (v2 > 0.0001) then
                    v2 = Vector3.new(v1.X, 0, v1.Z)
                    normal_2 = if not (v2.Magnitude <= 1e-06) then v2.Unit else v1
                else
                    normal_2 = v1
                end
            else
                normal_2 = v1
            end
        end
        local Unit = normal_2
        if Unit.Y < a2.WalkableFloor then
            v1 = Unit
            if a2.WalkableFloor <= v1.Y then
                return v1
            end
            if 0.0001 < (math.abs(v1.Y)) then
                return v1
            end
            v2 = Vector3.new(v1.X, 0, v1.Z)
            if v2.Magnitude <= 1e-06 then
                return v1
            end
            Unit = v2.Unit
        end
        return Unit
    end
    return (Vector3.new(0, 0, 0))
end

function v1.isDynamicWallContactRecord(a1) -- Line: 88
    if a1 == nil then
        return true
    end
    local buildMode = a1.buildMode
    local v1 = false
    if typeof(buildMode) == "string" then
        v1 = string.sub(buildMode, 1, 7) == "dynamic"
    end
    return v1
end

function v1.isFloorSupportTrace(a1) -- Line: 96
    local hullRecord = a1 and a1.hullRecord
    if not hullRecord then
        return false
    end
    if hullRecord.isFloorSupport == true then
        return true
    end
    local buildMode = hullRecord.buildMode
    local v1 = true
    if buildMode ~= "floorGridCell" then
        v1 = true
        if buildMode ~= "floorGridPatch" then
            v1 = true
            if buildMode ~= "walkMeshTriangle" then
                v1 = buildMode == "walkMeshCell"
            end
        end
    end
    return v1
end

function v1.isDynamicPlayerSupportTrace(a1) -- Line: 113
    local hullRecord = if a1 == nil then nil else a1.hullRecord
    local v1 = false
    if hullRecord ~= nil then
        v1 = hullRecord.buildMode == "dynamicPlayerAabb"
    end
    return v1
end

function v1.isRecoverableFloorSupportTrace(a1, a2, a3) -- Line: 118 -- types: a3: number
    local v1
    local hullRecord = a1 and a1.hullRecord
    if not hullRecord then
        v1 = false
    elseif hullRecord.isFloorSupport ~= true then
        local buildMode = hullRecord.buildMode
        v1 = true
        if buildMode ~= "floorGridCell" then
            v1 = true
            if buildMode ~= "floorGridPatch" then
                v1 = true
                if buildMode ~= "walkMeshTriangle" then
                    v1 = buildMode == "walkMeshCell"
                end
            end
        end
    else
        v1 = true
    end
    if v1 and not (a1.normal.Y < a2.WalkableFloor) then
        local floorPenetrationDepth = a1.floorPenetrationDepth
        if typeof(floorPenetrationDepth) ~= "number" then
            return false
        end
        return floorPenetrationDepth <= a3
    end
    return false
end

function v1.getResolvedSupportPosition(a1, a2) -- Line: 135 -- types: a2: vector
    local v1
    if not a1 then
        return a2
    end
    local hullRecord = a1 and a1.hullRecord
    if not hullRecord then
        v1 = false
    elseif hullRecord.isFloorSupport ~= true then
        local buildMode = hullRecord.buildMode
        v1 = true
        if buildMode ~= "floorGridCell" then
            v1 = true
            if buildMode ~= "floorGridPatch" then
                v1 = true
                if buildMode ~= "walkMeshTriangle" then
                    v1 = buildMode == "walkMeshCell"
                end
            end
        end
    else
        v1 = true
    end
    if v1 then
        return a1.endPos
    end
    if not a1.startSolid and not a1.allSolid then
        return a1.endPos
    end
    return a2
end

function v1.isWalkableGround(a1, a2) -- Line: 175 -- upvalues: isCylinderWalkableGroundTrace (val)
    return (isCylinderWalkableGroundTrace(a1, a2))
end

function v1.getTraceGroundNormal(a1) -- Line: 180
    if a1 ~= nil and 1e-06 < a1.normal.Magnitude then
        return a1.normal
    end
    return nil
end

function v1.getTraceMinkowskiPlaneKind(a1) -- Line: 189
    if a1 ~= nil then
        return a1.minkowskiPlaneKind
    end
    return nil
end

function v1.isRampPrimitiveHullRecord(a1) -- Line: 193
    local v1 = false
    if a1 ~= nil then
        if a1.buildMode ~= "primitiveLocalHullPlanes" then
            v1 = a1.buildMode == "authoredHullPlanes"
        else
            v1 = true
            if a1.sourceShape ~= "Wedge" then
                v1 = true
                if a1.sourceShape ~= "CornerWedge" then
                    v1 = a1.buildMode == "authoredHullPlanes"
                end
            end
        end
    end
    return v1
end

function v1.getLandingSnapDistance(a1, a2) -- Line: 204 -- types: a1: vector
    if not a2 then
        return (1 / 0)
    end
    local v1 = a1 - a2.endPos
    local normal = if a2 == nil then nil else if not (1e-06 < a2.normal.Magnitude) then nil else a2.normal
    if normal then
        return (math.max(0, (v1:Dot(normal.Unit))))
    end
    return (math.max(0, v1.Y))
end

function v1.shouldRejectAirLanding(a1, a2, a3, a4, a5) -- Line: 219
    -- upvalues: 
    if a2 and 1e-06 < a2.Magnitude then
        local v1 = a1:Dot(a2.Unit)
        if a3 <= a4 then
            return a5 < v1
        end
        return -a5 < v1
    end
    return a5 < a1.Y
end

function v1.supportTraceMatchesPosition(a1, a2, a3) -- Line: 238
    -- upvalues: isCylinderWalkableGroundTrace (val)
    local endPos, v1
    if not isCylinderWalkableGroundTrace(a1, a3) then
        return false
    end
    if a1 then
        local hullRecord = a1 and a1.hullRecord
        if not hullRecord then
            v1 = false
        elseif hullRecord.isFloorSupport ~= true then
            local buildMode = hullRecord.buildMode
            v1 = true
            if buildMode ~= "floorGridCell" then
                v1 = true
                if buildMode ~= "floorGridPatch" then
                    v1 = true
                    if buildMode ~= "walkMeshTriangle" then
                        v1 = buildMode == "walkMeshCell"
                    end
                end
            end
        else
            v1 = true
        end
        endPos = if not v1 then if a1.startSolid then a2 else if not a1.allSolid then a1.endPos else a2 else a1.endPos
    else
        endPos = a2
    end
    v1 = endPos.X - a2.X
    local v2 = endPos.Y - a2.Y
    local v3 = endPos.Z - a2.Z
    local v4 = a3.PositionSnapEpsilon * a3.PositionSnapEpsilon
    return v1 * v1 + v2 * v2 + v3 * v3 <= v4
end

return table.freeze(v1)