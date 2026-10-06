-- Decompiled with Potassium's decompiler.

local PVSCodec = require(script.Parent.PVSCodec);
local Constants = require(script.Parent.OBJGeometry.Constants);
local StaticGeometryRuntime = require(script.Parent.StaticGeometryRuntime);
local u1 = {};
u1.__index = u1;
local MATRIX_POLICY = Constants.MATRIX_POLICY;
local AUDITED_MATRIX_POLICY = Constants.AUDITED_MATRIX_POLICY;

local function bucketKey(p2: number, p3: number, p4: number) -- Line: 22
    return ((p2 + 65536) * 131072 + (p3 + 65536)) * 131072 + (p4 + 65536);
end;

local function buildSpatialBuckets(p5: any, p6: number) -- Line: 31
    local v7 = {};

    for i, v in ipairs(p5.regions) do
        local v8 = i;
        local v9 = v;

        for i2 = math.floor(v.minimum.X / p6), math.floor(v.maximum.X / p6) do
            local v10 = i2;

            for i3 = math.floor(v9.minimum.Y / p6), math.floor(v9.maximum.Y / p6) do
                local v11 = i3;

                for i4 = math.floor(v9.minimum.Z / p6), math.floor(v9.maximum.Z / p6) do
                    local v12 = ((v10 + 65536) * 131072 + (v11 + 65536)) * 131072 + (i4 + 65536);
                    local v13 = v7[v12];

                    if v13 == nil then
                        v13 = {};
                        v7[v12] = v13;
                    end;

                    v13[#v13 + 1] = v8;
                    local _ = i4;
                end;
            end;
        end;
    end;

    return v7;
end;

function u1.new(p14: userdata, p15: userdata?) -- Line: 70
    -- upvalues: StaticGeometryRuntime (copy), u1 (copy)
    local v16 = {
        TrustedNegatives = false,
        SnapCacheCount = 0,
        SpatialBucketSize = 64,
        SelectionPadding = 8,
        MapRoot = p14,
        StorageRoot = p15 or p14,
        SpatialBuckets = {},
        SnapCaches = {},
        SnapInterned = {},
        StaticGeometry = StaticGeometryRuntime.new(p14, p15)
    };
    local v17 = setmetatable(v16, u1);
    v17:Refresh(true);

    return v17;
end;

function u1.Refresh(p18: any, p19: boolean?) -- Line: 89
    -- upvalues: PVSCodec (copy), MATRIX_POLICY (copy), AUDITED_MATRIX_POLICY (copy), buildSpatialBuckets (copy)
    p18.Data = nil;
    p18.DecodeError = nil;
    p18.TrustedNegatives = false;
    p18.SpatialBuckets = {};
    p18.SnapCaches = {};
    p18.SnapCacheCount = 0;
    p18.SnapInterned = {};
    local v20;

    if p19 then
        v20 = p18.StaticGeometry:IsReady();
    else
        v20 = p18.StaticGeometry:Refresh();
    end;

    local Attribute = p18.MapRoot:GetAttribute("PVSSelectionPadding");

    if typeof(Attribute) == "number" and Attribute == Attribute then
        p18.SelectionPadding = math.clamp(Attribute, 0, 512);
    else
        p18.SelectionPadding = 8;
    end;

    p18.VerticalSelectionPadding = nil;
    local Attribute2 = p18.MapRoot:GetAttribute("PVSLayerHeight");

    if typeof(Attribute2) == "number" and (Attribute2 >= 1 and Attribute2 <= 64) then
        p18.VerticalSelectionPadding = 0.25;
    end;

    local Attribute3 = p18.MapRoot:GetAttribute("PVSAdaptiveCellSize");

    if typeof(Attribute3) == "number" and (Attribute3 >= 1 and Attribute3 <= 64) then
        p18.VerticalSelectionPadding = 0.25;
    end;

    local Attribute4 = p18.StorageRoot:GetAttribute("PVSData");

    if typeof(Attribute4) ~= "string" then
        p18.DecodeError = "MissingPVSData";

        return false;
    end;

    local os_clock_ret = os.clock();
    local success, result = pcall(PVSCodec.decode, Attribute4, function() -- Line: 123, Name: startupCheckpoint
        -- upvalues: os_clock_ret (ref)
        if os.clock() - os_clock_ret >= 0.008 then
            task.wait();
            os_clock_ret = os.clock();
        end;
    end);

    if not success then
        p18.DecodeError = tostring(result);

        return false;
    end;

    local Attribute5 = p18.MapRoot:GetAttribute("PVSBarrierFingerprint");
    local Attribute6 = p18.MapRoot:GetAttribute("PVSBakerVersion");

    if typeof(Attribute6) == "number" and Attribute6 >= 19 then
        local Attribute7 = p18.MapRoot:GetAttribute("PVSMatrixPolicy");

        if Attribute7 ~= MATRIX_POLICY and Attribute7 ~= AUDITED_MATRIX_POLICY then
            p18.DecodeError = "UnsupportedPVSMatrixPolicy";

            return false;
        end;

        if p18.MapRoot:GetAttribute("PVSMatrixMutual") ~= true then
            p18.DecodeError = "MissingMutualVisibilityGuarantee";

            return false;
        end;
    end;

    if not p18.StaticGeometry:IsExactGeometryComplete() then
        if typeof(Attribute5) == "string" then
            if not v20 then
                p18.DecodeError = `BarrierFingerprintError:{p18.StaticGeometry:GetLoadError() or "Unavailable"}`;

                return false;
            end;
        elseif typeof(Attribute6) == "number" and Attribute6 >= 14 then
            p18.DecodeError = "MissingBarrierFingerprint";

            return false;
        end;
    end;

    p18.Data = result;
    local v21;

    if p18.MapRoot:GetAttribute("PVSMatrixPolicy") == AUDITED_MATRIX_POLICY and p18.MapRoot:GetAttribute("PVSMatrixMutual") == true then
        v21 = p18.StaticGeometry:IsExactGeometryComplete();
    else
        v21 = false;
    end;

    p18.TrustedNegatives = v21;
    local v22;

    if #result.regions > 2048 then
        v22 = 8;
    else
        v22 = 64;
    end;

    while true do
        local v23 = 0;

        for _, v in result.regions do
            v23 = v23 + (math.floor(v.maximum.X / v22) - math.floor(v.minimum.X / v22) + 1) * (math.floor(v.maximum.Y / v22) - math.floor(v.minimum.Y / v22) + 1) * (math.floor(v.maximum.Z / v22) - math.floor(v.minimum.Z / v22) + 1);
        end;

        if v23 <= math.max(#result.regions * 16, 65536) then
            p18.SpatialBucketSize = v22;
            p18.SpatialBuckets = buildSpatialBuckets(result, v22);

            return true;
        end;

        v22 = v22 * 2;
    end;
end;

function u1.IsReady(p24) -- Line: 186
    return p24.Data ~= nil;
end;

function u1.TrustsNegatives(p25) -- Line: 190
    local v26;

    if p25.Data == nil then
        v26 = false;
    else
        v26 = p25.TrustedNegatives;
    end;

    return v26;
end;

function u1.GetDecodeError(p27) -- Line: 194
    return p27.DecodeError;
end;

function u1.GetStaticGeometry(p28) -- Line: 198
    return p28.StaticGeometry;
end;

function u1.ClipStaticOrigin(p29: any, p30: vector, p31: vector, p32: number?) -- Line: 202
    return p29.StaticGeometry:ClipOrigin(p30, p31, p32);
end;

function u1.FindCells(p33: any, p34: vector, p35: number?, p36: number?, p37: number?) -- Line: 207
    local Data = p33.Data;

    if Data == nil then
        return {};
    end;

    if p35 == nil then
        p35 = p33.SelectionPadding;
    end;

    local math_clamp_ret = math.clamp(p35, 0, 512);
    local v38;

    if p33.VerticalSelectionPadding == nil then
        v38 = math_clamp_ret;
    else
        v38 = math.min(math_clamp_ret, p33.VerticalSelectionPadding);
    end;

    local v39 = math_clamp_ret + math.max(p36 or 0, 0);
    local v40 = v38 + math.max(p37 or 0, 0);
    local SpatialBucketSize = p33.SpatialBucketSize;
    local math_floor_ret = math.floor((p34.X - v39) / SpatialBucketSize);
    local math_floor_ret2 = math.floor((p34.X + v39) / SpatialBucketSize);
    local math_floor_ret3 = math.floor((p34.Y - v40) / SpatialBucketSize);
    local math_floor_ret4 = math.floor((p34.Y + v40) / SpatialBucketSize);
    local math_floor_ret5 = math.floor((p34.Z - v39) / SpatialBucketSize);
    local math_floor_ret6 = math.floor((p34.Z + v39) / SpatialBucketSize);

    if (math_floor_ret2 - math_floor_ret + 1) * (math_floor_ret4 - math_floor_ret3 + 1) * (math_floor_ret6 - math_floor_ret5 + 1) > #Data.regions then
        local v41 = {};
        local v42 = {};

        for _, v in Data.regions do
            if not (v41[v.cluster] or (p34.X < v.minimum.X - v39 or (p34.X > v.maximum.X + v39 or (p34.Y < v.minimum.Y - v40 or (p34.Y > v.maximum.Y + v40 or (p34.Z < v.minimum.Z - v39 or p34.Z > v.maximum.Z + v39)))))) then
                v41[v.cluster] = true;
                v42[#v42 + 1] = v.cluster;
            end;
        end;

        table.sort(v42);

        return v42;
    end;

    local v43 = {};
    local v44 = {};
    local v45 = {};

    for i = math_floor_ret, math_floor_ret2 do
        local v46 = i;

        for i2 = math_floor_ret3, math_floor_ret4 do
            local v47 = i2;

            for i3 = math_floor_ret5, math_floor_ret6 do
                local v48 = p33.SpatialBuckets[((v46 + 65536) * 131072 + (v47 + 65536)) * 131072 + (i3 + 65536)];
                local v49;

                if v48 == nil then
                    v49 = i3;
                else
                    v49 = i3;

                    for _, v in v48 do
                        if not v44[v] then
                            v44[v] = true;
                            local v50 = Data.regions[v];
                            local v51;

                            if p34.X >= v50.minimum.X - v39 and (p34.X <= v50.maximum.X + v39 and (p34.Y >= v50.minimum.Y - v40 and (p34.Y <= v50.maximum.Y + v40 and p34.Z >= v50.minimum.Z - v39))) then
                                v51 = p34.Z <= v50.maximum.Z + v39;
                            else
                                v51 = false;
                            end;

                            if not v45[v50.cluster] and v51 then
                                v45[v50.cluster] = true;
                                v43[#v43 + 1] = v50.cluster;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    table.sort(v43);

    return v43;
end;

function u1.SnapKey(p52: any, p53: vector) -- Line: 286
    local math_floor_ret = math.floor(p53.X / 1);
    local math_floor_ret2 = math.floor(p53.Y / 0.5);
    local math_floor_ret3 = math.floor(p53.Z / 1);
    local math_abs_ret = math.abs(math_floor_ret);
    local math_abs_ret2 = math.abs(math_floor_ret2);
    local math_abs_ret3 = math.abs(math_floor_ret3);

    if math.max(math_abs_ret, math_abs_ret2, math_abs_ret3) >= 65536 or (math_floor_ret ~= math_floor_ret or (math_floor_ret2 ~= math_floor_ret2 or math_floor_ret3 ~= math_floor_ret3)) then
        return nil;
    end;

    return ((math_floor_ret + 65536) * 131072 + (math_floor_ret2 + 65536)) * 131072 + (math_floor_ret3 + 65536);
end;

function u1.SnapCells(p54: any, p55: vector, p56: number?) -- Line: 297
    local v57 = p54:SnapKey(p55);

    if v57 == nil then
        return p54:FindCells(p55, p56, 1, 0.5);
    end;

    local v58 = p56 == nil and -1 or p56;
    local v59 = p54.SnapCaches[v58];

    if v59 == nil then
        v59 = {};
        p54.SnapCaches[v58] = v59;
    end;

    local v60 = v59[v57];

    if v60 ~= nil then
        return v60;
    end;

    if p54.SnapCacheCount >= 65536 then
        table.clear(p54.SnapCaches);
        table.clear(p54.SnapInterned);
        p54.SnapCacheCount = 0;
        v59 = {};
        p54.SnapCaches[v58] = v59;
    end;

    local v61 = (math.floor(p55.X / 1) + 0.5) * 1;
    local v62 = (math.floor(p55.Y / 0.5) + 0.5) * 0.5;
    local v63 = (math.floor(p55.Z / 1) + 0.5) * 1;
    local v64 = p54:FindCells(Vector3.new(v61, v62, v63), p56, 0.5, 0.25);
    local table_concat_ret = table.concat(v64, ",");
    local v65 = p54.SnapInterned[table_concat_ret];

    if v65 == nil then
        v65 = table.freeze(v64);
        p54.SnapInterned[table_concat_ret] = v65;
    end;

    v59[v57] = v65;
    p54.SnapCacheCount = p54.SnapCacheCount + 1;

    return v65;
end;

local function validCells(p66: table, p67: number) -- Line: 338
    for _, v in p66 do
        if v ~= v or (v % 1 ~= 0 or (v < 1 or p67 < v)) then
            return false;
        end;
    end;

    return true;
end;

function u1.CouldCellsSee(p68: any, p69: table, p70: table) -- Line: 347
    -- upvalues: validCells (copy), PVSCodec (copy)
    local Data = p68.Data;

    if Data == nil or (#p69 == 0 or #p70 == 0) then
        return true;
    end;

    if not (validCells(p69, #Data.cells) and validCells(p70, #Data.cells)) then
        return true;
    end;

    for _, v in ipairs(p69) do
        local v71 = v;

        for _, v2 in ipairs(p70) do
            if PVSCodec.isVisible(Data, v71, v2) then
                return true;
            end;
        end;
    end;

    return false;
end;

function u1.ClassifyCells(p72: any, p73: table, p74: table) -- Line: 368
    return p72:CouldCellsSee(p73, p74) and "VisibleWithoutRuntimeProof" or "NeedsRuntimeOcclusionProof";
end;

return table.freeze(u1);