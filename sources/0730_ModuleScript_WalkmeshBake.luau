-- Decompiled with Potassium's decompiler.

require(script.Parent.Catalog);
local Geometry = require(script.Parent.Geometry);
local Schema = require(script.Parent.Schema);
require(script.Parent.TopologyConfig);
local v1 = {};

local function triangleBounds(p2: vector, p3: vector, p4: vector) -- Line: 14
    -- upvalues: Geometry (copy)
    return Geometry.Min(Geometry.Min(p2, p3), p4), Geometry.Max(Geometry.Max(p2, p3), p4);
end;

function v1.Build(p5: any, p6: vector, p7: any) -- Line: 18
    -- upvalues: Schema (copy), Geometry (copy)
    assert(p5.Kind == Schema.SourceKind.Walkmesh, "WalkmeshBake accepts only Walkmesh sources");
    local v8 = assert(p5.Walkmesh, "walkmesh source is missing decoded mesh data");
    local CFrame = p5.Geometry.CFrame;
    local table_create_ret = table.create(v8.VertexCount);

    for i, v in v8.Vertices do
        table_create_ret[i] = CFrame:PointToWorldSpace(v);
    end;

    local v9 = 0;
    local v10 = {};

    for i, v in v8.Triangles do
        local v11 = table_create_ret[v.A];
        local v12 = table_create_ret[v.B];
        local v13 = table_create_ret[v.C];
        local v14 = (v12 - v11):Cross(v13 - v11);
        local Magnitude = v14.Magnitude;

        if Magnitude <= p7.PlaneNormalEpsilon then
            v9 = v9 + 1;
        else
            local v15 = v14 / Magnitude;

            if v15.Y < 0 then
                v15 = -v15;
            else
                local v16 = v12;
                v12 = v13;
                v13 = v16;
            end;

            local Vector3_new_ret = Vector3.new(0, p6.Y, 0);
            local v17 = v11 + Vector3_new_ret;
            local v18 = v13 + Vector3_new_ret;
            local v19 = v12 + Vector3_new_ret;
            local v20 = Geometry.Min(Geometry.Min(v17, v18), v19);
            local v21 = Geometry.Max(Geometry.Max(v17, v18), v19);
            local v22, v23 = Geometry.ExpandBounds(v20, v21, p6 + Vector3.new(p7.WalkmeshBoundsPadding, p7.WalkmeshBoundsPadding, p7.WalkmeshBoundsPadding));
            v10[#v10 + 1] = table.freeze({
                RecordType = "Walkmesh",
                DestructibleIndex = nil,
                SourceId = p5.SourceId,
                Kind = p5.Kind,
                ElementId = i,
                SurfaceFriction = p7.SurfaceFriction,
                A = v17,
                B = v18,
                C = v19,
                Normal = v15,
                Distance = v17:Dot(v15),
                AabbMin = v22,
                AabbMax = v23
            });
        end;
    end;

    table.freeze(v10);

    return v10, v9;
end;

return table.freeze(v1);