-- Decompiled with Potassium's decompiler.

require(script.Parent.Catalog);
require(script.Parent.Geometry);
local HullBake = require(script.Parent.HullBake);
local Schema = require(script.Parent.Schema);
local SpatialGrid = require(script.Parent.SpatialGrid);
local TopologyConfig = require(script.Parent.TopologyConfig);
local WalkmeshBake = require(script.Parent.WalkmeshBake);
require(script.Parent.Parent.Simulation.Config);
local v1 = {};

local function buildStanceRecords(p2: any, p3: vector, p4: any, p5: table, p6: function?) -- Line: 46
    -- upvalues: HullBake (copy), Schema (copy), WalkmeshBake (copy)
    local v7 = 0;
    local v8 = 0;
    local v9 = {};
    local v10 = {};
    local v11 = 0;
    local v12 = 0;
    local v13 = 0;

    for _, v in p5 do
        local v14;
        v14, v8 = HullBake.BuildMerged(v, p3, p4, v8);
        v9[#v9 + 1] = v14;

        for _, v2 in v do
            v10[v2.SourceId] = true;
            v7 = v7 + 1;
        end;

        if p6 ~= nil then
            p6();
        end;
    end;

    for _, v in p2.Sources do
        assert(v11 < v.SourceId, "catalog sources must be strictly ordered by SourceId");
        v11 = v.SourceId;

        if not v10[v.SourceId] then
            if v.Kind == Schema.SourceKind.Barrier or v.Kind == Schema.SourceKind.Destructible then
                v7 = v7 + 1;
                local v15;
                v15, v8 = HullBake.Build(v, p3, p4, v8);
                v9[#v9 + 1] = v15;

                if p6 ~= nil then
                    p6();
                end;
            elseif v.Kind == Schema.SourceKind.Walkmesh then
                v12 = v12 + 1;
                local v16, v17 = WalkmeshBake.Build(v, p3, p4);
                v13 = v13 + v17;

                for _, v2 in v16 do
                    v9[#v9 + 1] = v2;
                end;
            else
                error(string.format("catalog source %d has unsupported kind %s", v.SourceId, (tostring(v.Kind))));
            end;
        end;
    end;

    table.freeze(v9);

    return v9, v7, v12, v13;
end;

local function assertPairedRecords(p18: table, p19: table) -- Line: 105
    assert(#p18 == #p19, "standing/ducking collision record counts must match");

    for i, v in p18 do
        local v20 = p19[i];
        local v21;

        if v.RecordType == v20.RecordType and (v.SourceId == v20.SourceId and (v.Kind == v20.Kind and v.DestructibleIndex == v20.DestructibleIndex)) then
            v21 = v.ElementId == v20.ElementId;
        else
            v21 = false;
        end;

        assert(v21, "standing/ducking collision record order must match");
    end;
end;

v1.LargeSourceCount = 4000;

function v1.createFrameYielder(u22: number) -- Line: 123
    local os_clock_ret = os.clock();

    return function() -- Line: 125
        -- upvalues: os_clock_ret (ref), u22 (copy)
        if u22 <= os.clock() - os_clock_ret then
            task.wait();
            os_clock_ret = os.clock();
        end;
    end;
end;

function v1.Build(p23: any, p24: any, p25: any, p26: function?) -- Line: 134
    -- upvalues: TopologyConfig (copy), HullBake (copy), buildStanceRecords (copy), assertPairedRecords (copy), SpatialGrid (copy)
    local v27;

    if p23.Manifest.Epoch >= 1 then
        v27 = p23.Manifest.Epoch <= 65535;
    else
        v27 = false;
    end;

    assert(v27, "collision epoch must fit non-zero u16");
    assert(p23.Manifest.SourceCount == #p23.Sources, "catalog source count changed after validation");
    assert(p23.Manifest.SourceCount > 0, "MovementV2 map has no Barrier, Destructible, or Walkmesh sources");
    local v28 = TopologyConfig.Resolve(p24, p25);
    local v29 = HullBake.FindMergedSourceGroups(p23.Sources);
    local v30, v31, v32, v33 = buildStanceRecords(p23, v28.StandingHalfSize, v28, v29, p26);
    local v34, v35, v36, v37 = buildStanceRecords(p23, v28.DuckingHalfSize, v28, v29, p26);
    local v38;

    if v31 == v35 and v32 == v36 then
        v38 = v33 == v37;
    else
        v38 = false;
    end;

    assert(v38);
    local v39;

    if #v30 > 0 then
        v39 = #v34 > 0;
    else
        v39 = false;
    end;

    assert(v39, "MovementV2 map produced no usable Barrier, Destructible, or Walkmesh collision records");
    assertPairedRecords(v30, v34);
    local v40 = false;

    for _, v in v30 do
        if v.RecordType == "Hull" and v.Climbable then
            v40 = true;
            break;
        end;
    end;

    local v41 = SpatialGrid.Build(v30, v28.CellSize, v28.MaxCellsPerRecord, v34);
    table.freeze(v41);
    local table_freeze_ret = table.freeze({
        Records = v30,
        Grid = v41
    });
    local table_freeze_ret2 = table.freeze({
        Records = v34,
        Grid = v41
    });
    local table_freeze_ret3 = table.freeze({
        HullSourceCount = v31,
        WalkmeshSourceCount = v32,
        StandingRecordCount = #v30,
        DuckingRecordCount = #v34,
        SkippedWalkmeshTriangleCount = v33
    });

    return table.freeze({
        Epoch = p23.Manifest.Epoch,
        Fingerprint = p23.Manifest.Fingerprint,
        SourceCount = p23.Manifest.SourceCount,
        DestructibleCount = p23.Manifest.DestructibleCount,
        HasClimbable = v40,
        Config = v28,
        Standing = table_freeze_ret,
        Ducking = table_freeze_ret2,
        Stats = table_freeze_ret3
    });
end;

return table.freeze(v1);