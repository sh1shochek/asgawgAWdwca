-- ReplicatedStorage.MovementV2.Collision.Geometry
-- Script path: ReplicatedStorage.MovementV2.Collision.Geometry
-- Decompile time: 6.32 ms

local TopologyConfig = require(script.Parent.TopologyConfig)
local u5 = {}

function u5.IsFiniteVector3(a1) -- Line: 66
    if typeof(a1) ~= "Vector3" then
        return false
    end
    local X = a1.X
    local Y = a1.Y
    local Z = a1.Z
    local v1 = false
    if X - X == 0 then
        v1 = false
        if Y - Y == 0 then
            v1 = Z - Z == 0
        end
    end
    return v1
end

function u5.Min(a1, a2) -- Line: 74 -- types: a1: vector, a2: vector
    return (Vector3.new(math.min(a1.X, a2.X), math.min(a1.Y, a2.Y), (math.min(a1.Z, a2.Z))))
end

function u5.Max(a1, a2) -- Line: 78 -- types: a1: vector, a2: vector
    return (Vector3.new(math.max(a1.X, a2.X), math.max(a1.Y, a2.Y), (math.max(a1.Z, a2.Z))))
end

function u5.ExpandBounds(a1, a2, a3) -- Line: 82 -- types: a1: vector, a2: vector, a3: vector
    return a1 - a3, a2 + a3
end

function u5.SegmentBounds(a1, a2, a3) -- Line: 86 -- upvalues: u5 (val) -- types: a1: vector, a2: vector, a3: number
    local v1 = Vector3.new(a3, a3, a3)
    return u5.Min(a1, a2) - v1, u5.Max(a1, a2) + v1
end

local function movementPlane(a1, a2, a3) -- Line: 91 -- types: a1: table, a2: table
    local Normal = a2.Normal
    if not (a3.WalkableFloor <= Normal.Y) then
        local v1 = math.abs(Normal.Y)
        if not (v1 > 0.0001) then
            if a2.FlatNormal ~= nil and a2.FlatDistance ~= nil then
                return a2.FlatNormal, a2.FlatDistance
            end
            v1 = Vector3.new(Normal.X, 0, Normal.Z)
            if v1.Magnitude <= 1e-06 then
                return Normal, a2.Distance
            end
            local Unit = v1.Unit
            local v2 = (-1 / 0)
            for i, j in a1.Points or {} do
                v2 = math.max(v2, (j:Dot(Unit)))
            end
            local v3 = if v2 ~= (-1 / 0) then Unit else Normal
            if v2 == (-1 / 0) then
                return v3, a2.Distance
            end
            return v3, v2
        end
    end
    return Normal, a2.Distance
end

function u5.ContainsConvex(a1, a2, a3) -- Line: 112
    -- upvalues: TopologyConfig (val), movementPlane (val)
    local v1, v2, v3
    local v4 = math.max(a3, TopologyConfig.Default.BrushEpsilon)
    for i, j in a1.Planes do
        v3, v1 = movementPlane(a1, j, TopologyConfig.Default)
        v2 = a2:Dot(v3) - v1
        if -v4 <= v2 then
            return false
        end
    end
    return true
end

local function preferPlane(a1, a2, a3, a4, a5, a6) -- Line: 123
    -- upvalues: 
    if a4 == nil then
        return true
    end
    if a6.BrushEpsilon < math.abs(a1 - a3) * a5 then
        return a3 < a1
    end
    return a2.PlaneId < a4.PlaneId
end

local function sweepConvexInternal(a1, a2, a3, a4, a5, a6) -- Line: 141
    -- upvalues: movementPlane (val)
    local v1, v2, v3, v4, v5
    local v6 = a3 - a2
    local Magnitude = v6.Magnitude
    local v7 = -1
    local v8 = 1
    local v9 = false
    local v10 = false
    local v11 = (-1 / 0)
    local v12 = (-1 / 0)
    local v13 = nil
    local v14 = nil
    local v15 = nil
    local v16 = nil
    local SupportEdgeOwnershipTolerance = if a5 == nil then 0 else if a6 == false then 0 else a4.SupportEdgeOwnershipTolerance
    local v17 = nil
    local v18 = nil
    for i, j in a1.Planes, v17, v18 do
        v1, v2 = movementPlane(a1, j, a4)
        v3 = a2:Dot(v1) - v2
        v4 = v3 + v6:Dot(v1)
        if SupportEdgeOwnershipTolerance > 0 and v1.Y < a5 then
            v3 = v3 - SupportEdgeOwnershipTolerance
            v4 = v4 - SupportEdgeOwnershipTolerance
        end
        if v11 + a4.BrushEpsilon < v3 then
            v15 = j
            v16 = v1
        elseif (math.abs(v3 - v11)) <= a4.BrushEpsilon then
            if v15 == nil or j.PlaneId < v15.PlaneId then
                v15 = j
                v16 = v1
            end
        end
        v11 = math.max(v11, v3)
        v12 = math.max(v12, v4)
        v9 = v9 or v3 > 0
        v5 = v10 or v4 > 0
        v10 = v5
        if v3 > 0 and v4 > 0 then
            return nil
        end
        if v3 > 0 or v4 > 0 then
            if not (v4 < v3) then
                v8 = math.min(v8, (math.min(1, (v3 + a4.BrushEpsilon) / (v3 - v4))))
            else
                v5 = math.max(0, (v3 - a4.BrushEpsilon) / (v3 - v4))
                if if v13 ~= nil then if not (a4.BrushEpsilon < math.abs(v5 - v7) * Magnitude) then j.PlaneId < v13.PlaneId else v7 < v5 else true then
                    v13 = j
                    v14 = v1
                end
                v7 = math.max(v7, v5)
            end
        end
    end
    if v9 then
        if v13 ~= nil and not (v7 < 0) and not (v8 <= v7) then
            return {
                StartSolid = false,
                AllSolid = false,
                Fraction = math.max(0, v7),
                Normal = v14 or v13.Normal,
                PlaneId = v13.PlaneId,
            }
        end
        return nil
    end
    local v19 = v16 or Vector3.new(0, 1, 0)
    if v10 and v11 < v12 and a4.ContactEpsilon < Magnitude and 0.25 < (v6.Unit:Dot(v19)) then
        return nil
    end
    return {
        Fraction = 0,
        StartSolid = true,
        Normal = v19,
        AllSolid = not v10 and v12 < v11,
        PlaneId = if v15 == nil then 0 else v15.PlaneId,
    }
end

function u5.SweepConvex(a1, a2, a3, a4) -- Line: 243
    -- upvalues: sweepConvexInternal (val)
    return (sweepConvexInternal(a1, a2, a3, a4, nil, nil))
end

function u5.SweepConvexSupport(a1, a2, a3, a4, a5, a6) -- Line: 252
    -- upvalues: sweepConvexInternal (val)
    return (sweepConvexInternal(a1, a2, a3, a6, a4, a5))
end

local function insideTriangleEdge(a1, a2, a3, a4, a5) -- Line: 263
    -- upvalues: 
    local v1 = a3 - a2
    local Magnitude = v1.Magnitude
    if Magnitude <= 1e-06 then
        return true
    end
    local v2 = (v1:Cross(a1 - a2)):Dot(a4)
    return -math.max(a5, Magnitude * a5) <= v2
end

function u5.TriangleContactContains(a1, a2, a3) -- Line: 278 -- types: a1: table, a2: vector, a3: number
    local v1, v2
    local A = a1.A
    local B = a1.B
    local Normal = a1.Normal
    local v3 = B - A
    local Magnitude = v3.Magnitude
    if not (Magnitude <= 1e-06) then
        v2 = (v3:Cross(a2 - A)):Dot(Normal)
        v1 = -math.max(a3, Magnitude * a3) <= v2
    else
        v1 = true
    end
    if v1 then
        local B_2 = a1.B
        local C = a1.C
        local Normal_2 = a1.Normal
        v3 = C - B_2
        local Magnitude_2 = v3.Magnitude
        if not (Magnitude_2 <= 1e-06) then
            v2 = (v3:Cross(a2 - B_2)):Dot(Normal_2)
            v1 = -math.max(a3, Magnitude_2 * a3) <= v2
        else
            v1 = true
        end
        if v1 then
            local C_2 = a1.C
            local A_2 = a1.A
            local Normal_3 = a1.Normal
            v3 = A_2 - C_2
            local Magnitude_3 = v3.Magnitude
            if Magnitude_3 <= 1e-06 then
                return true
            end
            v2 = (v3:Cross(a2 - C_2)):Dot(Normal_3)
            v1 = -math.max(a3, Magnitude_3 * a3) <= v2
        end
    end
    return v1
end

local function sweepTriangleInternal(a1, a2, a3, a4, a5) -- Line: 284
    -- upvalues: u5 (val)
    local v1, v2, v3
    local v4 = (a2:Dot(a1.Normal)) - a1.Distance
    local v5 = (a3:Dot(a1.Normal)) - a1.Distance
    if v4 < -a4.FloorContactEpsilon then
        if a4.FloorStartSolidRecoveryDepth < -v4 then
            return nil
        end
        v2 = a2 - a1.Normal * v4
        if not u5.TriangleContactContains(a1, v2, a4.FloorTriangleEdgeSlop) then
            return nil
        end
        return {
            Fraction = 0,
            StartSolid = true,
            PlaneId = 1,
            Normal = a1.Normal,
            AllSolid = v5 < -a4.FloorContactEpsilon,
            ResolvedPosition = v2,
            PenetrationDepth = -v4,
        }
    end
    if not a5 then
        if -a4.FloorContactEpsilon <= v5 then
            return nil
        end
        v3 = v4 - v5
        if (math.abs(v3)) <= 1e-06 then
            return nil
        end
        v3 = a2:Lerp(a3, (math.max(0, (math.min(1, v4 / v3)))))
        if not u5.TriangleContactContains(a1, v3 - a1.Normal * ((v3:Dot(a1.Normal)) - a1.Distance), a4.FloorTriangleEdgeSlop) then
            return nil
        end
        v1 = {
            StartSolid = false,
            AllSolid = false,
            PlaneId = 1,
            Fraction = v2,
            Normal = a1.Normal,
        }
        v1.PenetrationDepth = if not a5 then nil else if not (v5 < 0) then nil else -v5
        return v1
    end
    if a4.FloorSupportContactEpsilon < v5 then
        return nil
    end
    v3 = v4 - v5
    v2 = 0.999999
    if 1e-06 < (math.abs(v3)) and v5 <= 0 then
        v2 = math.max(0, (math.min(0.999999, v4 / v3)))
    end
    v3 = a2:Lerp(a3, v2)
    if not u5.TriangleContactContains(a1, v3 - a1.Normal * ((v3:Dot(a1.Normal)) - a1.Distance), a4.FloorTriangleEdgeSlop) then
        return nil
    end
    v1 = {
        StartSolid = false,
        AllSolid = false,
        PlaneId = 1,
        Fraction = v2,
        Normal = a1.Normal,
    }
    v1.PenetrationDepth = if not a5 then nil else if not (v5 < 0) then nil else -v5
    return v1
end

function u5.SweepTriangle(a1, a2, a3, a4) -- Line: 350
    -- upvalues: sweepTriangleInternal (val)
    return (sweepTriangleInternal(a1, a2, a3, a4, false))
end

function u5.SweepTriangleSupport(a1, a2, a3, a4) -- Line: 359
    -- upvalues: sweepTriangleInternal (val)
    return (sweepTriangleInternal(a1, a2, a3, a4, true))
end

return table.freeze(u5)