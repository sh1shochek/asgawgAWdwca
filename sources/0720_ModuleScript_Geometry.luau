-- Decompiled with Potassium's decompiler.

local TopologyConfig = require(script.Parent.TopologyConfig);
local u10 = {
    IsFiniteVector3 = function(p1) -- Line: 66, Name: IsFiniteVector3
        if typeof(p1) ~= "Vector3" then
            return false;
        end;

        local X = p1.X;
        local Y = p1.Y;
        local Z = p1.Z;
        local v2;

        if X - X == 0 and Y - Y == 0 then
            v2 = Z - Z == 0;
        else
            v2 = false;
        end;

        return v2;
    end,

    Min = function(p3: vector, p4: vector) -- Line: 74, Name: Min
        local math_min_ret = math.min(p3.X, p4.X);
        local math_min_ret2 = math.min(p3.Y, p4.Y);
        local math_min_ret3 = math.min(p3.Z, p4.Z);

        return Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
    end,

    Max = function(p5: vector, p6: vector) -- Line: 78, Name: Max
        local math_max_ret = math.max(p5.X, p6.X);
        local math_max_ret2 = math.max(p5.Y, p6.Y);
        local math_max_ret3 = math.max(p5.Z, p6.Z);

        return Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
    end,

    ExpandBounds = function(p7: vector, p8: vector, p9: vector) -- Line: 82, Name: ExpandBounds
        return p7 - p9, p8 + p9;
    end
};

function u10.SegmentBounds(p11: vector, p12: vector, p13: number) -- Line: 86
    -- upvalues: u10 (copy)
    local Vector3_new_ret = Vector3.new(p13, p13, p13);

    return u10.Min(p11, p12) - Vector3_new_ret, u10.Max(p11, p12) + Vector3_new_ret;
end;

local function movementPlane(p14: table, p15: table, p16: any) -- Line: 91
    local Normal = p15.Normal;

    if Normal.Y >= p16.WalkableFloor or math.abs(Normal.Y) > 0.0001 then
        return Normal, p15.Distance;
    end;

    if p15.FlatNormal ~= nil and p15.FlatDistance ~= nil then
        return p15.FlatNormal, p15.FlatDistance;
    end;

    local Vector3_new_ret = Vector3.new(Normal.X, 0, Normal.Z);

    if Vector3_new_ret.Magnitude <= 1e-6 then
        return Normal, p15.Distance;
    end;

    local Unit = Vector3_new_ret.Unit;
    local v17 = (-1 / 0);

    for _, v in p14.Points or {} do
        v17 = math.max(v17, v:Dot(Unit));
    end;

    if v17 == (-1 / 0) then
        Unit = Normal;
    end;

    if v17 == (-1 / 0) then
        return Unit, p15.Distance;
    end;

    return Unit, v17;
end;

function u10.ContainsConvex(p18: table, p19: vector, p20: number) -- Line: 112
    -- upvalues: TopologyConfig (copy), movementPlane (copy)
    local math_max_ret = math.max(p20, TopologyConfig.Default.BrushEpsilon);

    for _, v in p18.Planes do
        local v21, v22 = movementPlane(p18, v, TopologyConfig.Default);

        if p19:Dot(v21) - v22 >= -math_max_ret then
            return false;
        end;
    end;

    return true;
end;

local function preferPlane(p23: number, p24: table, p25: number, p26: table?, p27: number, p28: any) -- Line: 123
    if p26 == nil then
        return true;
    end;

    if math.abs(p23 - p25) * p27 > p28.BrushEpsilon then
        return p25 < p23;
    end;

    return p24.PlaneId < p26.PlaneId;
end;

local function sweepConvexInternal(p29: table, p30: vector, p31: vector, p32: any, p33: number?, p34: boolean?) -- Line: 141
    -- upvalues: movementPlane (copy)
    local v35 = p31 - p30;
    local Magnitude = v35.Magnitude;
    local v36 = (p33 == nil or p34 == false) and 0 or p32.SupportEdgeOwnershipTolerance;
    local v37 = (-1 / 0);
    local v38 = nil;
    local v39 = false;
    local v40 = nil;
    local v41 = -1;
    local v42 = (-1 / 0);
    local v43 = 1;
    local v44 = false;
    local v45 = nil;
    local v46 = nil;

    for _, v in p29.Planes do
        local v47, v48 = movementPlane(p29, v, p32);
        local v49 = p30:Dot(v47) - v48;
        local v50 = v49 + v35:Dot(v47);

        if v36 > 0 and v47.Y < p33 then
            v49 = v49 - v36;
            v50 = v50 - v36;
        end;

        if v37 + p32.BrushEpsilon < v49 or math.abs(v49 - v37) <= p32.BrushEpsilon and (v38 == nil or v.PlaneId < v38.PlaneId) then
            v46 = v47;
            v38 = v;
        end;

        v37 = math.max(v37, v49);
        v42 = math.max(v42, v50);
        v44 = v44 or v49 > 0;
        v39 = v39 or v50 > 0;

        if v49 > 0 and v50 > 0 then
            return nil;
        end;

        if v49 > 0 or v50 > 0 then
            if v50 < v49 then
                local math_max_ret = math.max(0, (v49 - p32.BrushEpsilon) / (v49 - v50));
                local v51;

                if v40 == nil then
                    v51 = true;
                elseif math.abs(math_max_ret - v41) * Magnitude > p32.BrushEpsilon then
                    v51 = v41 < math_max_ret;
                else
                    v51 = v.PlaneId < v40.PlaneId;
                end;

                if v51 then
                    v40 = v;
                else
                    v47 = v45;
                end;

                v41 = math.max(v41, math_max_ret);
                v45 = v47;
            else
                local math_min_ret = math.min(1, (v49 + p32.BrushEpsilon) / (v49 - v50));
                v43 = math.min(v43, math_min_ret);
            end;
        end;
    end;

    if v44 then
        return v40 ~= nil and (v41 >= 0 and v43 > v41) and {
            StartSolid = false,
            AllSolid = false,
            ResolvedPosition = nil,
            PenetrationDepth = nil,
            Fraction = math.max(0, v41),
            Normal = v45 or v40.Normal,
            PlaneId = v40.PlaneId
        } or nil;
    end;

    local v52 = v46 or Vector3.new(0, 1, 0);

    if v39 and (v37 < v42 and (p32.ContactEpsilon < Magnitude and v35.Unit:Dot(v52) > 0.25)) then
        return nil;
    end;

    local v53 = {
        Fraction = 0,
        StartSolid = true,
        ResolvedPosition = nil,
        PenetrationDepth = nil,
        Normal = v52
    };
    v53.AllSolid = not v39 and v42 < v37;
    v53.PlaneId = v38 == nil and 0 or v38.PlaneId;

    return v53;
end;

function u10.SweepConvex(p54: table, p55: vector, p56: vector, p57: any) -- Line: 243
    -- upvalues: sweepConvexInternal (copy)
    return sweepConvexInternal(p54, p55, p56, p57, nil, nil);
end;

function u10.SweepConvexSupport(p58: table, p59: vector, p60: vector, p61: number, p62: boolean, p63: any) -- Line: 252
    -- upvalues: sweepConvexInternal (copy)
    return sweepConvexInternal(p58, p59, p60, p63, p61, p62);
end;

local function insideTriangleEdge(p64: vector, p65: vector, p66: vector, p67: vector, p68: number) -- Line: 263
    local v69 = p66 - p65;
    local Magnitude = v69.Magnitude;

    return Magnitude <= 1e-6 and true or v69:Cross(p64 - p65):Dot(p67) >= -math.max(p68, Magnitude * p68);
end;

function u10.TriangleContactContains(p70: table, p71: vector, p72: number) -- Line: 278
    local A = p70.A;
    local Normal = p70.Normal;
    local v73 = p70.B - A;
    local Magnitude = v73.Magnitude;
    local v74 = Magnitude <= 1e-6 and true or v73:Cross(p71 - A):Dot(Normal) >= -math.max(p72, Magnitude * p72);

    if v74 then
        local B = p70.B;
        local Normal2 = p70.Normal;
        local v75 = p70.C - B;
        local Magnitude2 = v75.Magnitude;
        v74 = Magnitude2 <= 1e-6 and true or v75:Cross(p71 - B):Dot(Normal2) >= -math.max(p72, Magnitude2 * p72);

        if v74 then
            local C = p70.C;
            local Normal3 = p70.Normal;
            local v76 = p70.A - C;
            local Magnitude3 = v76.Magnitude;

            if Magnitude3 <= 1e-6 then
                return true;
            end;

            v74 = v76:Cross(p71 - C):Dot(Normal3) >= -math.max(p72, Magnitude3 * p72);
        end;
    end;

    return v74;
end;

local function sweepTriangleInternal(p77: table, p78: vector, p79: vector, p80: any, p81: boolean) -- Line: 284
    -- upvalues: u10 (copy)
    local v82 = p78:Dot(p77.Normal) - p77.Distance;
    local v83 = p79:Dot(p77.Normal) - p77.Distance;

    if v82 < -p80.FloorContactEpsilon then
        if -v82 > p80.FloorStartSolidRecoveryDepth then
            return nil;
        end;

        local v84 = p78 - p77.Normal * v82;

        return u10.TriangleContactContains(p77, v84, p80.FloorTriangleEdgeSlop) and {
            Fraction = 0,
            StartSolid = true,
            PlaneId = 1,
            Normal = p77.Normal,
            AllSolid = v83 < -p80.FloorContactEpsilon,
            ResolvedPosition = v84,
            PenetrationDepth = -v82
        } or nil;
    end;

    local v85;

    if p81 then
        if p80.FloorSupportContactEpsilon < v83 then
            return nil;
        end;

        local v86 = v82 - v83;

        if math.abs(v86) > 1e-6 and v83 <= 0 then
            local math_min_ret = math.min(0.999999, v82 / v86);
            v85 = math.max(0, math_min_ret);
        else
            v85 = 0.999999;
        end;
    else
        if -p80.FloorContactEpsilon <= v83 then
            return nil;
        end;

        local v87 = v82 - v83;

        if math.abs(v87) <= 1e-6 then
            return nil;
        end;

        local math_min_ret = math.min(1, v82 / v87);
        v85 = math.max(0, math_min_ret);
    end;

    local v88 = p78:Lerp(p79, v85);
    local v89 = v88 - p77.Normal * (v88:Dot(p77.Normal) - p77.Distance);

    if not u10.TriangleContactContains(p77, v89, p80.FloorTriangleEdgeSlop) then
        return nil;
    end;

    local v90 = {
        StartSolid = false,
        AllSolid = false,
        PlaneId = 1,
        ResolvedPosition = nil,
        Fraction = v85,
        Normal = p77.Normal
    };
    local v91;

    if p81 and v83 < 0 then
        v91 = -v83;
    else
        v91 = nil;
    end;

    v90.PenetrationDepth = v91;

    return v90;
end;

function u10.SweepTriangle(p92: table, p93: vector, p94: vector, p95: any) -- Line: 350
    -- upvalues: sweepTriangleInternal (copy)
    return sweepTriangleInternal(p92, p93, p94, p95, false);
end;

function u10.SweepTriangleSupport(p96: table, p97: vector, p98: vector, p99: any) -- Line: 359
    -- upvalues: sweepTriangleInternal (copy)
    return sweepTriangleInternal(p96, p97, p98, p99, true);
end;

return table.freeze(u10);