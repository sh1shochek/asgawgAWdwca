-- Decompiled with Potassium's decompiler.

local BrushHullBuilder = require(script.Parent.BrushHullBuilder);
require(script.Parent.Catalog);
require(script.Parent.Geometry);
local Schema = require(script.Parent.Schema);
require(script.Parent.TopologyConfig);
local v1 = {};

local function convertPlane(p2: any, p3: table) -- Line: 16
    local v4 = nil;
    local v5 = nil;
    local v6, v7;

    if math.abs(p2.n.Y) <= 0.0001 and #p3 > 0 then
        local Vector3_new_ret = Vector3.new(p2.n.X, 0, p2.n.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            v6 = Vector3_new_ret.Unit;
            v7 = (-1 / 0);

            for _, v in p3 do
                v7 = math.max(v7, v:Dot(v6));
            end;

            if v7 == (-1 / 0) then
                v7 = v5;
                v6 = v4;
            end;
        else
            v7 = v5;
            v6 = v4;
        end;
    else
        v7 = v5;
        v6 = v4;
    end;

    return table.freeze({
        Normal = p2.n,
        Distance = p2.ed,
        PlaneId = p2.planeNum,
        MinkowskiPlaneKind = p2.minkowskiPlaneKind,
        FlatNormal = v6,
        FlatDistance = v7
    });
end;

local function convertRecord(p8: any, p9: any, p10: number) -- Line: 43
    -- upvalues: convertPlane (copy)
    local table_create_ret = table.create(#p8.hull);

    for i, v in p8.hull do
        table_create_ret[i] = convertPlane(v, p8.points);
    end;

    table.freeze(table_create_ret);
    local table_clone_ret = table.clone(p8.points);
    table.freeze(table_clone_ret);
    local v11;

    if p9.Climbable then
        v11 = table_create_ret;
    else
        v11 = table.freeze({});
    end;

    return table.freeze({
        RecordType = "Hull",
        SourceId = p9.SourceId,
        Kind = p9.Kind,
        DestructibleIndex = p9.DestructibleIndex,
        ElementId = p10,
        Climbable = p9.Climbable,
        SurfaceFriction = p8.surfaceFriction,
        Planes = table_create_ret,
        LadderPlanes = v11,
        Points = table_clone_ret,
        BuildMode = p8.buildMode,
        SourceShape = p8.sourceShape,
        SourceCFrame = p8.sourceCFrame,
        SourceSize = p8.sourceSize,
        AabbMin = p8.aabbMin,
        AabbMax = p8.aabbMax
    });
end;

function v1.Build(p12: any, p13: vector, p14: any, p15: number?) -- Line: 73
    -- upvalues: Schema (copy), BrushHullBuilder (copy), convertRecord (copy)
    assert(p12.Kind == Schema.SourceKind.Barrier and true or p12.Kind == Schema.SourceKind.Destructible, "HullBake accepts only Barrier or Destructible sources");
    local v16 = p12.Instance:IsA("BasePart");
    assert(v16, "brush sources must be BaseParts");
    local v17, v18 = BrushHullBuilder.BuildHullRecord(p12.Instance, p13 * 2, p15 or 0);

    return convertRecord(v17, p12, 0), v18;
end;

function v1.FindMergedSourceGroups(p19: table) -- Line: 89
    -- upvalues: Schema (copy), BrushHullBuilder (copy)
    local v20 = {};
    local v21 = {};

    for _, v in p19 do
        if v.Kind == Schema.SourceKind.Barrier and (v.Instance:IsA("BasePart") and not (v.Climbable or v.DisableSeamMerge)) then
            v20[v.Instance] = v;
            v21[#v21 + 1] = v.Instance;
        end;
    end;

    local v22 = {};

    for _, v in BrushHullBuilder.FindMergedPartGroups(v21) do
        local v23 = {};

        for _, v2 in v do
            local v24 = v20[v2];

            if v24 ~= nil then
                v23[#v23 + 1] = v24;
            end;
        end;

        table.sort(v23, function(p25, p26) -- Line: 114
            return p25.SourceId < p26.SourceId;
        end);

        if #v23 >= 2 then
            v22[#v22 + 1] = v23;
        end;
    end;

    table.sort(v22, function(p27, p28) -- Line: 121
        return p27[1].SourceId < p28[1].SourceId;
    end);

    return v22;
end;

function v1.BuildMerged(p29: table, p30: vector, p31: any, p32: number?) -- Line: 127
    -- upvalues: Schema (copy), BrushHullBuilder (copy), convertRecord (copy)
    assert(#p29 >= 2, "merged hull requires at least two sources");
    local table_create_ret = table.create(#p29);

    for i, v in p29 do
        assert(v.Kind == Schema.SourceKind.Barrier, "destructibles cannot be merged");
        local v33 = v.Instance:IsA("BasePart");
        assert(v33, "merged brush sources must be BaseParts");
        table_create_ret[i] = v.Instance;
    end;

    local v34, v35 = BrushHullBuilder.BuildMergedHullRecord(table_create_ret, p30 * 2, p32 or 0);

    return convertRecord(v34, p29[1], 0), v35;
end;

return table.freeze(v1);