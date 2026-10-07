-- ReplicatedStorage.MovementV2.Collision.WalkmeshBake
-- Script path: ReplicatedStorage.MovementV2.Collision.WalkmeshBake
-- Decompile time: 2.95 ms

require(script.Parent.Catalog)
local Geometry = require(script.Parent.Geometry)
local Schema = require(script.Parent.Schema)
require(script.Parent.TopologyConfig)
local v1 = {}

local function triangleBounds(a1, a2, a3) -- Line: 14
    -- upvalues: Geometry (val)
    return (Geometry.Min(Geometry.Min(a1, a2), a3)), Geometry.Max(Geometry.Max(a1, a2), a3)
end

function v1.Build(a1, a2, a3) -- Line: 18 -- upvalues: Schema (val), Geometry (val) -- types: a2: vector
    local Magnitude, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
    assert(a1.Kind == Schema.SourceKind.Walkmesh, "WalkmeshBake accepts only Walkmesh sources")
    local v11 = assert(a1.Walkmesh, "walkmesh source is missing decoded mesh data")
    local CFrame = a1.Geometry.CFrame
    local v12 = table.create(v11.VertexCount)
    for i, j in v11.Vertices do
        v12[i] = (CFrame:PointToWorldSpace(j))
    end
    local v13 = {}
    local v14 = 0
    local Triangles = v11.Triangles
    local v15 = nil
    local v16 = nil
    local v17, v18, v19 = a3, a2, a1
    for k, n in Triangles, v15, v16 do
        v1 = v12[n.A]
        v2 = v12[n.B]
        v3 = v12[n.C]
        v4 = (v2 - v1):Cross(v3 - v1)
        Magnitude = v4.Magnitude
        if not (Magnitude <= v17.PlaneNormalEpsilon) then
            v4 = v4 / Magnitude
            if v4.Y < 0 then
                v5 = v3
                v3 = v2
                v2 = v5
                v4 = -v4
            end
            v5 = Vector3.new(0, v18.Y, 0)
            v6 = v1 + v5
            v7 = v2 + v5
            v8 = v3 + v5
            v9, v10 = Geometry.ExpandBounds(
                Geometry.Min(Geometry.Min(v6, v7), v8),
                Geometry.Max(Geometry.Max(v6, v7), v8),
                v18 + Vector3.new(v17.WalkmeshBoundsPadding, v17.WalkmeshBoundsPadding, v17.WalkmeshBoundsPadding)
            )
            v13[#v13 + 1] = (table.freeze({
                RecordType = "Walkmesh",
                SourceId = v19.SourceId,
                Kind = v19.Kind,
                ElementId = k,
                SurfaceFriction = v17.SurfaceFriction,
                A = v6,
                B = v7,
                C = v8,
                Normal = v4,
                Distance = v6:Dot(v4),
                AabbMin = v9,
                AabbMax = v10,
            }))
        else
            v14 = v14 + 1
        end
    end
    table.freeze(v13)
    return v13, v14
end

return table.freeze(v1)