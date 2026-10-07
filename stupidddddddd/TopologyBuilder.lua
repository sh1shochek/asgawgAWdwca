-- ReplicatedStorage.MovementV2.Collision.TopologyBuilder
-- Script path: ReplicatedStorage.MovementV2.Collision.TopologyBuilder
-- Decompile time: 2.81 ms

require(script.Parent.Catalog)
require(script.Parent.Geometry)
local HullBake = require(script.Parent.HullBake)
local Schema = require(script.Parent.Schema)
local SpatialGrid = require(script.Parent.SpatialGrid)
local TopologyConfig = require(script.Parent.TopologyConfig)
local WalkmeshBake = require(script.Parent.WalkmeshBake)
require(script.Parent.Parent.Simulation.Config)
local v1 = {}

local function buildStanceRecords(a1, a2, a3, a4, a5) -- Line: 46
    -- upvalues: HullBake (val), Schema (val), WalkmeshBake (val)
    local v1, v2, v3
    local v4 = {}
    local v5 = 0
    local v6 = 0
    local v7 = 0
    local SourceId = 0
    local v8 = 0
    local v9 = {}
    local v10 = nil
    local v11 = nil
    local v12, v13, v14, v15 = a1, a2, a3, a5
    for i, j in a4, v10, v11 do
        v2, v3 = HullBake.BuildMerged(j, v13, v14, v8)
        v8 = v3
        v4[#v4 + 1] = v2
        for k, n in j do
            v9[n.SourceId] = true
            v5 = v5 + 1
        end
        if v15 ~= nil then
            v15()
        end
    end
    v10 = nil
    v11 = nil
    for m, i5 in v12.Sources, v10, v11 do
        assert(SourceId < i5.SourceId, "catalog sources must be strictly ordered by SourceId")
        SourceId = i5.SourceId
        if not v9[i5.SourceId] then
            if i5.Kind == Schema.SourceKind.Barrier or i5.Kind == Schema.SourceKind.Destructible then
                v5 = v5 + 1
                v2, v3 = HullBake.Build(i5, v13, v14, v8)
                v4[#v4 + 1] = v2
                if v15 ~= nil then
                    v15()
                end
            elseif i5.Kind ~= Schema.SourceKind.Walkmesh then
                error(string.format("catalog source %d has unsupported kind %s", i5.SourceId, (tostring(i5.Kind))))
            else
                v6 = v6 + 1
                v1, v2 = WalkmeshBake.Build(i5, v13, v14)
                v7 = v7 + v2
                for i6, i7 in v1 do
                    v4[#v4 + 1] = i7
                end
            end
        end
    end
    table.freeze(v4)
    return v4, v5, v6, v7
end

local function assertPairedRecords(a1, a2) -- Line: 105 -- types: a1: table, a2: table
    local v1, v2
    assert(#a1 == #a2, "standing/ducking collision record counts must match")
    local v3 = nil
    local v4 = nil
    for i, j in a1, v3, v4 do
        v1 = a2[i]
        v2 = false
        if j.RecordType == v1.RecordType then
            v2 = false
            if j.SourceId == v1.SourceId then
                v2 = false
                if j.Kind == v1.Kind then
                    v2 = false
                    if j.DestructibleIndex == v1.DestructibleIndex then
                        v2 = j.ElementId == v1.ElementId
                    end
                end
            end
        end
        assert(v2, "standing/ducking collision record order must match")
    end
end

v1.LargeSourceCount = 4000

function v1.createFrameYielder(a1) -- Line: 123 -- types: a1: number
    local u2 = os.clock()
    return function() -- Line: 125 -- upvalues: u2 (ref), a1 (val)
        if a1 <= os.clock() - u2 then
            task.wait()
            u2 = os.clock()
        end
    end
end

function v1.Build(a1, a2, a3, a4) -- Line: 134
    -- upvalues: TopologyConfig (val), HullBake (val), buildStanceRecords (val), assertPairedRecords (val)
    -- upvalues: SpatialGrid (val)
    local v1 = false
    if 1 <= a1.Manifest.Epoch then
        v1 = a1.Manifest.Epoch <= 65535
    end
    assert(v1, "collision epoch must fit non-zero u16")
    assert(a1.Manifest.SourceCount == #a1.Sources, "catalog source count changed after validation")
    assert(0 < a1.Manifest.SourceCount, "MovementV2 map has no Barrier, Destructible, or Walkmesh sources")
    local v2 = TopologyConfig.Resolve(a2, a3)
    v1 = HullBake.FindMergedSourceGroups(a1.Sources)
    local v3, v4, v5, v6 = buildStanceRecords(a1, v2.StandingHalfSize, v2, v1, a4)
    local v7, v8, v9, v10 = buildStanceRecords(a1, v2.DuckingHalfSize, v2, v1, a4)
    local v11 = false
    if v4 == v8 then
        v11 = false
        if v5 == v9 then
            v11 = v6 == v10
        end
    end
    assert(v11)
    v11 = false
    if #v3 > 0 then
        v11 = #v7 > 0
    end
    assert(v11, "MovementV2 map produced no usable Barrier, Destructible, or Walkmesh collision records")
    assertPairedRecords(v3, v7)
    local v12 = false
    for i, j in v3 do
        if j.RecordType == "Hull" and j.Climbable then
            v12 = true
            break
        end
    end
    v11 = SpatialGrid.Build(v3, v2.CellSize, v2.MaxCellsPerRecord, v7)
    table.freeze(v11)
    return (table.freeze({
        Epoch = a1.Manifest.Epoch,
        Fingerprint = a1.Manifest.Fingerprint,
        SourceCount = a1.Manifest.SourceCount,
        DestructibleCount = a1.Manifest.DestructibleCount,
        HasClimbable = v12,
        Config = v2,
        Standing = table.freeze({Records = v3, Grid = v11}),
        Ducking = table.freeze({Records = v7, Grid = v11}),
        Stats = table.freeze({
            HullSourceCount = v4,
            WalkmeshSourceCount = v5,
            StandingRecordCount = #v3,
            DuckingRecordCount = #v7,
            SkippedWalkmeshTriangleCount = v6,
        }),
    }))
end

return table.freeze(v1)