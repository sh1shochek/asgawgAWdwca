-- ReplicatedStorage.MovementV2.Collision.HullBake
-- Script path: ReplicatedStorage.MovementV2.Collision.HullBake
-- Decompile time: 2.03 ms

local BrushHullBuilder = require(script.Parent.BrushHullBuilder)
require(script.Parent.Catalog)
require(script.Parent.Geometry)
local Schema = require(script.Parent.Schema)
require(script.Parent.TopologyConfig)
local v1 = {}

local function convertPlane(a1, a2) -- Line: 16 -- types: a2: table
    local v1 = nil
    local v2 = nil
    local v3 = math.abs(a1.n.Y)
    if v3 <= 0.0001 and #a2 > 0 then
        v3 = Vector3.new(a1.n.X, 0, a1.n.Z)
        if 1e-06 < v3.Magnitude then
            local Unit = v3.Unit
            local v4 = (-1 / 0)
            for i, j in a2 do
                v4 = math.max(v4, (j:Dot(Unit)))
            end
            if v4 ~= (-1 / 0) then
                v1 = Unit
                v2 = v4
            end
        end
    end
    return (table.freeze({
        Normal = a1.n,
        Distance = a1.ed,
        PlaneId = a1.planeNum,
        MinkowskiPlaneKind = a1.minkowskiPlaneKind,
        FlatNormal = v1,
        FlatDistance = v2,
    }))
end

local function convertRecord(a1, a2, a3) -- Line: 43 -- upvalues: convertPlane (val) -- types: a3: number
    local v1 = table.create(#a1.hull)
    for i, j in a1.hull do
        v1[i] = (convertPlane(j, a1.points))
    end
    table.freeze(v1)
    local v2 = table.clone(a1.points)
    table.freeze(v2)
    return (table.freeze({
        RecordType = "Hull",
        SourceId = a2.SourceId,
        Kind = a2.Kind,
        DestructibleIndex = a2.DestructibleIndex,
        ElementId = a3,
        Climbable = a2.Climbable,
        SurfaceFriction = a1.surfaceFriction,
        Planes = v1,
        LadderPlanes = if not a2.Climbable then table.freeze({}) else v1,
        Points = v2,
        BuildMode = a1.buildMode,
        SourceShape = a1.sourceShape,
        SourceCFrame = a1.sourceCFrame,
        SourceSize = a1.sourceSize,
        AabbMin = a1.aabbMin,
        AabbMax = a1.aabbMax,
    }))
end

function v1.Build(a1, a2, a3, a4) -- Line: 73
    -- upvalues: Schema (val), BrushHullBuilder (val), convertRecord (val)
    local v1
    local v2 = true
    if a1.Kind ~= Schema.SourceKind.Barrier then
        v2 = a1.Kind == Schema.SourceKind.Destructible
    end
    assert(v2, "HullBake accepts only Barrier or Destructible sources")
    assert(a1.Instance:IsA("BasePart"), "brush sources must be BaseParts")
    v1, v2 = BrushHullBuilder.BuildHullRecord(a1.Instance, a2 * 2, a4 or 0)
    return (convertRecord(v1, a1, 0)), v2
end

function v1.FindMergedSourceGroups(a1) -- Line: 89 -- upvalues: Schema (val), BrushHullBuilder (val) -- types: a1: table
    local v1, v2
    local v3 = {}
    local v4 = {}
    for i, j in a1 do
        if j.Kind == Schema.SourceKind.Barrier
            and j.Instance:IsA("BasePart")
            and not j.Climbable
            and not j.DisableSeamMerge then
            v3[j.Instance] = j
            v4[#v4 + 1] = j.Instance
        end
    end
    local v5 = {}
    local v6 = (BrushHullBuilder.FindMergedPartGroups(v4))
    local v7 = nil
    local v8 = nil
    for k, n in v6, v7, v8 do
        v1 = {}
        for m, i5 in n do
            v2 = v3[i5]
            if v2 ~= nil then
                v1[#v1 + 1] = v2
            end
        end
        table.sort(v1, function(a1, a2) -- Line: 114
            return a1.SourceId < a2.SourceId
        end)
        if #v1 >= 2 then
            v5[#v5 + 1] = v1
        end
    end
    table.sort(v5, function(a1, a2) -- Line: 121
        return a1[1].SourceId < a2[1].SourceId
    end)
    return v5
end

function v1.BuildMerged(a1, a2, a3, a4) -- Line: 127
    -- upvalues: Schema (val), BrushHullBuilder (val), convertRecord (val)
    local v1
    assert(#a1 >= 2, "merged hull requires at least two sources")
    local v2 = table.create(#a1)
    local v3 = nil
    local v4 = nil
    local v5, v6, v7 = a2, a4, a1
    for i, j in a1, v3, v4 do
        assert(j.Kind == Schema.SourceKind.Barrier, "destructibles cannot be merged")
        assert(j.Instance:IsA("BasePart"), "merged brush sources must be BaseParts")
        v2[i] = j.Instance
    end
    v1, v3 = BrushHullBuilder.BuildMergedHullRecord(v2, v5 * 2, v6 or 0)
    return (convertRecord(v1, v7[1], 0)), v3
end

return table.freeze(v1)