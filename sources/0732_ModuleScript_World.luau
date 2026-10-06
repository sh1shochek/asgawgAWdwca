-- Decompiled with Potassium's decompiler.

local DestructibleFrame = require(script.Parent.DestructibleFrame);
local Geometry = require(script.Parent.Geometry);
require(script.Parent.TopologyBuilder);
require(script.Parent.Parent.Simulation.Types);
local u1 = {};
u1.__index = u1;

local function stanceTopology(p2, p3) -- Line: 76
    if p3 == "Standing" then
        return p2.Standing;
    end;

    if p3 == "Ducking" then
        return p2.Ducking;
    end;

    error(string.format("unsupported collision stance %s", (tostring(p3))), 3);
end;

local function gridCandidates(p4: any, p5: any, p6: vector, p7: vector) -- Line: 85
    local Scratch = p4.Scratch;
    local v8 = Scratch.Stamp + 1;

    if v8 >= 2147483647 then
        table.clear(Scratch.Seen);
        v8 = 1;
    end;

    Scratch.Stamp = v8;
    p5.Grid:QueryInto(p6, p7, p5.Records, Scratch.Indices, Scratch.Seen, v8, Scratch.Sources, Scratch.Cursors);

    return Scratch.Indices;
end;

local function queryCandidates(p9: any, p10: any, p11: vector, p12: vector) -- Line: 112
    local Scratch = p9.Scratch;
    local BoundsMin = Scratch.BoundsMin;
    local BoundsMax = Scratch.BoundsMax;

    if BoundsMin == nil or (BoundsMax == nil or (p11.X < BoundsMin.X or (p11.Y < BoundsMin.Y or (p11.Z < BoundsMin.Z or (p12.X > BoundsMax.X or (p12.Y > BoundsMax.Y or p12.Z > BoundsMax.Z)))))) then
        local Scratch2 = p9.Scratch;
        local v13 = Scratch2.Stamp + 1;

        if v13 >= 2147483647 then
            table.clear(Scratch2.Seen);
            v13 = 1;
        end;

        Scratch2.Stamp = v13;
        p10.Grid:QueryInto(p11, p12, p10.Records, Scratch2.Indices, Scratch2.Seen, v13, Scratch2.Sources, Scratch2.Cursors);

        return Scratch2.Indices;
    end;

    local v14 = Scratch.BoundsLists[p10];

    if v14 == nil then
        local table_clone = table.clone;
        local Scratch2 = p9.Scratch;
        local v15 = Scratch2.Stamp + 1;

        if v15 >= 2147483647 then
            table.clear(Scratch2.Seen);
            v15 = 1;
        end;

        Scratch2.Stamp = v15;
        p10.Grid:QueryInto(BoundsMin, BoundsMax, p10.Records, Scratch2.Indices, Scratch2.Seen, v15, Scratch2.Sources, Scratch2.Cursors);
        v14 = table_clone(Scratch2.Indices);
        Scratch.BoundsLists[p10] = v14;
    end;

    local Indices = Scratch.Indices;
    table.clear(Indices);
    local Records = p10.Records;
    local v16 = 0;

    for _, v in v14 do
        local v17 = Records[v];
        local AabbMin = v17.AabbMin;
        local AabbMax = v17.AabbMax;

        if p11.X <= AabbMax.X and (p12.X >= AabbMin.X and (p11.Y <= AabbMax.Y and (p12.Y >= AabbMin.Y and (p11.Z <= AabbMax.Z and p12.Z >= AabbMin.Z)))) then
            v16 = v16 + 1;
            Indices[v16] = v;
        end;
    end;

    return Indices;
end;

local function recordIsActive(p18, p19) -- Line: 161
    -- upvalues: DestructibleFrame (copy)
    local DestructibleIndex = p19.DestructibleIndex;

    return DestructibleIndex == nil and true or DestructibleFrame.IsActive(p18, DestructibleIndex);
end;

local function recordIsIgnored(p20, p21) -- Line: 166
    local v22;

    if p21 == nil or p21.Kind ~= p20.Kind then
        v22 = false;
    else
        v22 = p21.SourceId == p20.SourceId;
    end;

    return v22;
end;

local function assertPosition(p23: vector, p24: string) -- Line: 170
    -- upvalues: Geometry (copy)
    if not Geometry.IsFiniteVector3(p23) then
        error(string.format("%s must be a finite Vector3", p24));
    end;
end;

local function assertTimeFraction(p25: number) -- Line: 177
    local v26;

    if p25 == p25 and p25 >= 0 then
        v26 = p25 <= 1;
    else
        v26 = false;
    end;

    assert(v26, "collision time fraction must be normalized");
end;

local function assertTimeInterval(p27: number, p28: number) -- Line: 184
    local v29;

    if p27 == p27 and p27 >= 0 then
        v29 = p27 <= 1;
    else
        v29 = false;
    end;

    assert(v29, "collision time fraction must be normalized");
    local v30;

    if p28 == p28 and p28 >= 0 then
        v30 = p28 <= 1;
    else
        v30 = false;
    end;

    assert(v30, "collision time fraction must be normalized");
    assert(p27 <= p28, "collision time interval is reversed");
end;

local function replaceNarrow(p31: any, p32: any, p33: any, p34: any, p35: number, p36: number) -- Line: 191
    if p31 == nil or p32 == nil then
        return true;
    end;

    if p34.StartSolid ~= p32.StartSolid then
        return p34.StartSolid;
    end;

    if p36 < math.abs(p34.Fraction - p32.Fraction) * p35 then
        return p34.Fraction < p32.Fraction;
    end;

    if p33.SourceId ~= p31.SourceId then
        return p33.SourceId < p31.SourceId;
    end;

    if p33.Kind ~= p31.Kind then
        return p33.Kind < p31.Kind;
    end;

    if p33.ElementId ~= p31.ElementId then
        return p33.ElementId < p31.ElementId;
    end;

    if p34.PlaneId ~= p32.PlaneId then
        return p34.PlaneId < p32.PlaneId;
    end;

    if p34.Normal.X ~= p32.Normal.X then
        return p34.Normal.X < p32.Normal.X;
    end;

    if p34.Normal.Y == p32.Normal.Y then
        return p34.Normal.Z < p32.Normal.Z;
    end;

    return p34.Normal.Y < p32.Normal.Y;
end;

local function detailed(p37, p38) -- Line: 231
    local v39 = nil;
    local v40;

    if p37.RecordType == "Hull" then
        v40 = p37.SourceShape;

        for _, v in p37.Planes do
            if v.PlaneId == p38.PlaneId then
                v39 = v.MinkowskiPlaneKind;
                break;
            end;
        end;
    else
        v40 = nil;
    end;

    local v41 = {
        Fraction = p38.Fraction,
        Normal = p38.Normal,
        StartSolid = p38.StartSolid,
        AllSolid = p38.AllSolid,
        PlaneId = p38.PlaneId,
        SourceId = p37.SourceId,
        Kind = p37.Kind,
        DestructibleIndex = p37.DestructibleIndex,
        ElementId = p37.ElementId,
        SurfaceFriction = p37.SurfaceFriction,
        ResolvedPosition = p38.ResolvedPosition,
        PenetrationDepth = p38.PenetrationDepth,
        SourceShape = v40,
        MinkowskiPlaneKind = v39,
        RecordType = p37.RecordType
    };
    local v42;

    if p37.RecordType == "Hull" then
        v42 = p37.Climbable;
    else
        v42 = false;
    end;

    v41.Climbable = v42;
    v41.BuildMode = p37.RecordType ~= "Hull" and "walkMeshTriangle" or p37.BuildMode;
    local v43;

    if p37.RecordType == "Hull" then
        v43 = p37.SourceCFrame;
    else
        v43 = nil;
    end;

    v41.SourceCFrame = v43;
    local v44;

    if p37.RecordType == "Hull" then
        v44 = p37.SourceSize;
    else
        v44 = nil;
    end;

    v41.SourceSize = v44;
    local v45;

    if p37.RecordType == "Hull" then
        v45 = p37.Planes;
    else
        v45 = nil;
    end;

    v41.Planes = v45;

    return v41;
end;

local u46 = setmetatable({}, {
    __mode = "k"
});

function u1.new(p47, p48) -- Line: 270
    -- upvalues: DestructibleFrame (copy), u46 (copy), u1 (copy)
    local table_isfrozen_ret = table.isfrozen(p47);
    assert(table_isfrozen_ret, "collision topology must be immutable");
    local v49 = table.isfrozen(p47.Config) and (table.isfrozen(p47.Stats) and table.isfrozen(p47.Standing)) and (table.isfrozen(p47.Standing.Records) and table.isfrozen(p47.Standing.Grid) and (table.isfrozen(p47.Ducking) and table.isfrozen(p47.Ducking.Records))) and table.isfrozen(p47.Ducking.Grid);
    assert(v49, "collision topology contains mutable stance data");
    local table_isfrozen_ret2 = table.isfrozen(p48);
    assert(table_isfrozen_ret2, "destructible frame must be immutable");
    local v50, v51 = DestructibleFrame.Validate(p48.Epoch, p48.Revision, p48.Count, p48.ActiveBits);
    assert(v50, v51);
    local v52;

    if p48.Epoch >= 1 then
        v52 = p48.Epoch <= 65535;
    else
        v52 = false;
    end;

    assert(v52, "destructible-frame epoch must fit non-zero u16");
    assert(p48.Epoch == p47.Epoch, "destructible frame belongs to a different topology epoch");
    assert(p48.Count == p47.DestructibleCount, "destructible frame has the wrong source count");
    local v53 = u46[p47];

    if v53 == nil then
        v53 = {
            Stamp = 0,
            RegionCount = 0,
            Indices = {},
            Seen = {},
            Sources = {},
            Cursors = {},
            BoundsLists = {},
            Regions = {}
        };
        u46[p47] = v53;
    end;

    return table.freeze((setmetatable({
        Topology = p47,
        Destructibles = p48,
        Scratch = v53
    }, u1)));
end;

local u54 = {};

function u1.SetMovementBounds(p55: any, p56: vector, p57: vector) -- Line: 324
    -- upvalues: Geometry (copy)
    if not Geometry.IsFiniteVector3(p56) then
        error(string.format("%s must be a finite Vector3", "movement bounds minimum"));
    end;

    if not Geometry.IsFiniteVector3(p57) then
        error(string.format("%s must be a finite Vector3", "movement bounds maximum"));
    end;

    local Scratch = p55.Scratch;
    local Regions = Scratch.Regions;
    local math_floor_ret = math.floor(p56.X / 1);
    local math_floor_ret2 = math.floor(p56.Y / 1);
    local math_floor_ret3 = math.floor(p56.Z / 1);
    local v58 = math_floor_ret + 32768 + (math_floor_ret2 + 32768) * 65536 + (math_floor_ret3 + 32768) * 65536 * 65536;
    local v59 = Regions[v58];

    if v59 == nil then
        if Scratch.RegionCount >= 512 then
            table.clear(Regions);
            Scratch.RegionCount = 0;
        end;
    else
        local Min = v59.Min;
        local Max = v59.Max;

        if p56.X >= Min.X and (p56.Y >= Min.Y and (p56.Z >= Min.Z and (p57.X <= Max.X and (p57.Y <= Max.Y and p57.Z <= Max.Z)))) then
            local Lists = v59.Lists;
            Scratch.BoundsMin = Min;
            Scratch.BoundsMax = Max;
            Scratch.BoundsLists = Lists;

            return;
        end;
    end;

    if v59 == nil then
        Scratch.RegionCount = Scratch.RegionCount + 1;
    end;

    local v60 = {
        Min = Vector3.new(math_floor_ret * 1, math_floor_ret2 * 1, math_floor_ret3 * 1),
        Max = p57 + Vector3.new(1, 1, 1),
        Lists = {}
    };
    Regions[v58] = v60;
    local Max = v60.Max;
    local Lists = v60.Lists;
    Scratch.BoundsMin = v60.Min;
    Scratch.BoundsMax = Max;
    Scratch.BoundsLists = Lists;
end;

function u1.ClearMovementBounds(p61) -- Line: 366
    -- upvalues: u54 (copy)
    local Scratch = p61.Scratch;
    Scratch.BoundsMin = nil;
    Scratch.BoundsMax = nil;
    Scratch.BoundsLists = u54;
end;

local function sweepDetailed(p62: any, p63: vector, p64: vector, p65: any, p66: any, p67: number, p68: number, p69: boolean) -- Line: 374
    -- upvalues: Geometry (copy), queryCandidates (copy), DestructibleFrame (copy), replaceNarrow (copy), detailed (copy)
    if not Geometry.IsFiniteVector3(p63) then
        error(string.format("%s must be a finite Vector3", "sweep start"));
    end;

    if not Geometry.IsFiniteVector3(p64) then
        error(string.format("%s must be a finite Vector3", "sweep end"));
    end;

    local v70;

    if p67 == p67 and p67 >= 0 then
        v70 = p67 <= 1;
    else
        v70 = false;
    end;

    assert(v70, "collision time fraction must be normalized");
    local v71;

    if p68 == p68 and p68 >= 0 then
        v71 = p68 <= 1;
    else
        v71 = false;
    end;

    assert(v71, "collision time fraction must be normalized");
    assert(p67 <= p68, "collision time interval is reversed");
    local Magnitude = (p64 - p63).Magnitude;
    local Config = p62.Topology.Config;
    assert(Magnitude <= Config.MaxSweepDistance, "collision sweep exceeds the configured maximum distance");
    local Topology = p62.Topology;
    local v72;

    if p65 == "Standing" then
        v72 = Topology.Standing;
    elseif p65 == "Ducking" then
        v72 = Topology.Ducking;
    else
        error(string.format("unsupported collision stance %s", (tostring(p65))), 3);
        v72 = nil;
    end;

    local v73, v74 = Geometry.SegmentBounds(p63, p64, Config.BroadphasePadding);
    local v75 = nil;
    local v76 = nil;

    for _, v in queryCandidates(p62, v72, v73, v74) do
        local v77 = v72.Records[v];
        local v78;

        if p66 == nil or p66.Kind ~= v77.Kind then
            v78 = false;
        else
            v78 = p66.SourceId == v77.SourceId;
        end;

        if not v78 then
            local DestructibleIndex = v77.DestructibleIndex;

            if (DestructibleIndex == nil and true or DestructibleFrame.IsActive(p62.Destructibles, DestructibleIndex)) and (v77.RecordType ~= "Walkmesh" or p69) then
                local v79;

                if v77.RecordType == "Hull" then
                    v79 = Geometry.SweepConvex(v77, p63, p64, Config);
                else
                    v79 = Geometry.SweepTriangle(v77, p63, p64, Config);
                end;

                if v79 ~= nil and replaceNarrow(v75, v76, v77, v79, Magnitude, Config.HitTieDistance) then
                    v76 = v79;
                    v75 = v77;
                end;
            end;
        end;
    end;

    if v75 and v76 then
        return detailed(v75, v76);
    end;

    return nil;
end;

function u1.SweepDetailed(p80: any, p81: vector, p82: vector, p83: any, p84: any, p85: number, p86: number) -- Line: 414
    -- upvalues: sweepDetailed (copy)
    return sweepDetailed(p80, p81, p82, p83, p84, p85, p86, false);
end;

function u1.SweepWithFloorSupportDetailed(p87: any, p88: vector, p89: vector, p90: any, p91: any, p92: number, p93: number) -- Line: 435
    -- upvalues: sweepDetailed (copy)
    return sweepDetailed(p87, p88, p89, p90, p91, p92, p93, true);
end;

local function sweepResult(p94: table?) -- Line: 457
    return p94 == nil and {
        Fraction = 1,
        Normal = Vector3.new(0, 1, 0),
        StartSolid = false,
        AllSolid = false
    } or {
        SurfaceVelocity = Vector3.new(0, 0, 0),
        Fraction = p94.Fraction,
        Normal = p94.Normal,
        StartSolid = p94.StartSolid,
        AllSolid = p94.AllSolid,
        SourceId = p94.SourceId,
        Kind = p94.Kind,
        SourceShape = p94.SourceShape,
        MinkowskiPlaneKind = p94.MinkowskiPlaneKind,
        RecordType = p94.RecordType,
        Climbable = p94.Climbable,
        BuildMode = p94.BuildMode,
        SourceCFrame = p94.SourceCFrame,
        SourceSize = p94.SourceSize,
        Planes = p94.Planes,
        PlaneId = p94.PlaneId,
        SurfaceFriction = p94.SurfaceFriction,
        ResolvedPosition = p94.ResolvedPosition,
        PenetrationDepth = p94.PenetrationDepth
    };
end;

function u1.Sweep(p95: any, p96: vector, p97: vector, p98: any, p99: any, p100: number, p101: number) -- Line: 489
    -- upvalues: sweepResult (copy)
    return sweepResult(p95:SweepDetailed(p96, p97, p98, p99, p100, p101));
end;

function u1.SweepWithFloorSupport(p102: any, p103: vector, p104: vector, p105: any, p106: any, p107: number, p108: number) -- Line: 503
    -- upvalues: sweepResult (copy)
    return sweepResult(p102:SweepWithFloorSupportDetailed(p103, p104, p105, p106, p107, p108));
end;

function u1.IsClear(p109: any, p110: vector, p111: any, p112: number) -- Line: 524
    -- upvalues: Geometry (copy), queryCandidates (copy), DestructibleFrame (copy)
    if not Geometry.IsFiniteVector3(p110) then
        error(string.format("%s must be a finite Vector3", "clearance position"));
    end;

    local v113;

    if p112 == p112 and p112 >= 0 then
        v113 = p112 <= 1;
    else
        v113 = false;
    end;

    assert(v113, "collision time fraction must be normalized");
    local Config = p109.Topology.Config;
    local Topology = p109.Topology;
    local v114;

    if p111 == "Standing" then
        v114 = Topology.Standing;
    elseif p111 == "Ducking" then
        v114 = Topology.Ducking;
    else
        error(string.format("unsupported collision stance %s", (tostring(p111))), 3);
        v114 = nil;
    end;

    local Vector3_new_ret = Vector3.new(Config.BroadphasePadding, Config.BroadphasePadding, Config.BroadphasePadding);

    for _, v in queryCandidates(p109, v114, p110 - Vector3_new_ret, p110 + Vector3_new_ret) do
        local v115 = v114.Records[v];

        if v115.RecordType == "Hull" then
            local DestructibleIndex = v115.DestructibleIndex;

            if (DestructibleIndex == nil and true or DestructibleFrame.IsActive(p109.Destructibles, DestructibleIndex)) and Geometry.ContainsConvex(v115, p110, Config.ContactEpsilon) then
                return false;
            end;
        end;
    end;

    return true;
end;

function u1.CanMove(p116: any, p117: vector, p118: vector, p119: any, p120: any, p121: number, p122: number) -- Line: 545
    local v123 = p116:SweepDetailed(p117, p118, p119, p120, p121, p122);
    local v124;

    if v123 == nil then
        v124 = p116:IsClear(p118, p119, p122);
    else
        v124 = not v123.StartSolid;

        if v124 then
            if v123.Fraction >= 1 then
                v124 = p116:IsClear(p118, p119, p122);
            else
                v124 = false;
            end;
        end;
    end;

    return v124;
end;

local function groundWinner(p125: any, p126: any, p127: any, p128: vector, p129: vector, p130: boolean) -- Line: 561
    -- upvalues: Geometry (copy), queryCandidates (copy), DestructibleFrame (copy), replaceNarrow (copy)
    local Magnitude = (p129 - p128).Magnitude;
    local v131, v132 = Geometry.SegmentBounds(p128, p129, p127.BroadphasePadding);
    local v133 = nil;
    local v134 = nil;

    for _, v in queryCandidates(p125, p126, v131, v132) do
        local v135 = p126.Records[v];
        local DestructibleIndex = v135.DestructibleIndex;

        if DestructibleIndex == nil and true or DestructibleFrame.IsActive(p125.Destructibles, DestructibleIndex) then
            local v136;

            if v135.RecordType == "Hull" then
                v136 = Geometry.SweepConvexSupport(v135, p128, p129, p127.WalkableFloor, p130, p127);
            else
                v136 = Geometry.SweepTriangleSupport(v135, p128, p129, p127);
            end;

            if v136 ~= nil and (v136.Normal.Y >= p127.WalkableFloor and replaceNarrow(v133, v134, v135, v136, Magnitude, p127.HitTieDistance)) then
                v134 = v136;
                v133 = v135;
            end;
        end;
    end;

    return v133, v134;
end;

function u1.FindGround(p137: any, p138: vector, p139: any, p140: number, p141: number, p142: any) -- Line: 600
    -- upvalues: Geometry (copy), groundWinner (copy)
    if not Geometry.IsFiniteVector3(p138) then
        error(string.format("%s must be a finite Vector3", "ground-query position"));
    end;

    local v143;

    if p141 == p141 and p141 >= 0 then
        v143 = p141 <= 1;
    else
        v143 = false;
    end;

    assert(v143, "collision time fraction must be normalized");
    local v144;

    if p140 == p140 and p140 >= 0 then
        v144 = p140 <= p137.Topology.Config.MaxSweepDistance;
    else
        v144 = false;
    end;

    assert(v144, "invalid ground distance");
    local Config = p137.Topology.Config;
    local Topology = p137.Topology;
    local v145;

    if p139 == "Standing" then
        v145 = Topology.Standing;
    elseif p139 == "Ducking" then
        v145 = Topology.Ducking;
    else
        error(string.format("unsupported collision stance %s", (tostring(p139))), 3);
        v145 = nil;
    end;

    local math_min_ret = math.min(Config.GroundProbeStartBump, Config.MaxSweepDistance - p140);
    local v146 = p138 + Vector3.new(0, math_min_ret, 0);
    local v147 = p138 - Vector3.new(0, p140, 0);
    local v148, v149 = groundWinner(p137, v145, Config, v146, v147, p142 ~= nil);
    local v150, v151, v152, v153;

    if v149 == nil or (not v149.StartSolid or v149.ResolvedPosition ~= nil) then
        v150 = v146;
        v151 = v147;
        v152 = v148;
        v153 = v149;
    else
        local math_max_ret = math.max(math_min_ret, p140, Config.FloorStartSolidRecoveryDepth - Config.FloorContactEpsilon);
        v150 = p138 + Vector3.new(0, math_max_ret, 0);
        local v154 = p137:SweepDetailed(p138, v150, p139, nil, p141, p141);

        if v154 ~= nil then
            if v154.StartSolid then
                v150 = p138;
            else
                v150 = p138:Lerp(v150, v154.Fraction);
            end;
        end;

        v151 = v150 - Vector3.new(0, p140 + math_max_ret, 0);
        v152, v153 = groundWinner(p137, v145, Config, v150, v151, false);

        if v153 == nil then
            v150 = v146;
            v151 = v147;
            v152 = v148;
            v153 = v149;
        elseif v153.AllSolid then
            v150 = v146;
            v151 = v147;
            v152 = v148;
            v153 = v149;
        end;
    end;

    if v153 == nil or v152 == nil then
        return nil;
    end;

    local ResolvedPosition = v153.ResolvedPosition;

    if ResolvedPosition then
        p138 = ResolvedPosition;
    elseif not v153.StartSolid then
        p138 = v150:Lerp(v151, v153.Fraction);
    end;

    return p137:IsClear(p138, p139, p141) and {
        Position = p138,
        Normal = v153.Normal,
        SurfaceFriction = v152.SurfaceFriction,
        Support = {
            Velocity = Vector3.new(0, 0, 0),
            Kind = v152.Kind,
            SourceId = v152.SourceId,
            Anchor = p138
        }
    } or nil;
end;

local u155 = setmetatable({}, {
    __mode = "k"
});

local function climbableIndices(p156) -- Line: 664
    -- upvalues: u155 (copy)
    local v157 = u155[p156];

    if v157 == nil then
        v157 = {};

        for i, v in p156.Records do
            if v.RecordType == "Hull" and v.Climbable then
                v157[#v157 + 1] = i;
            end;
        end;

        u155[p156] = v157;
    end;

    return v157;
end;

local function ladderFaceContains(p158: any, p159: vector, p160: number) -- Line: 678
    for _, v in p158.Planes do
        if p160 < p159:Dot(v.Normal) - v.Distance then
            return false;
        end;
    end;

    return true;
end;

function u1.FindLadder(p161: any, p162: vector, p163: any, p164: number, p165: number) -- Line: 687
    -- upvalues: Geometry (copy), climbableIndices (copy), DestructibleFrame (copy), ladderFaceContains (copy)
    if not Geometry.IsFiniteVector3(p162) then
        error(string.format("%s must be a finite Vector3", "ladder-query position"));
    end;

    local v166;

    if p165 == p165 and p165 >= 0 then
        v166 = p165 <= 1;
    else
        v166 = false;
    end;

    assert(v166, "collision time fraction must be normalized");
    local v167;

    if p164 == p164 and p164 >= 0 then
        v167 = p164 <= p161.Topology.Config.MaxSweepDistance;
    else
        v167 = false;
    end;

    assert(v167, "invalid ladder distance");
    local Config = p161.Topology.Config;
    local Topology = p161.Topology;
    local v168;

    if p163 == "Standing" then
        v168 = Topology.Standing;
    elseif p163 == "Ducking" then
        v168 = Topology.Ducking;
    else
        error(string.format("unsupported collision stance %s", (tostring(p163))), 3);
        v168 = nil;
    end;

    if p161.Topology.HasClimbable == false then
        return nil;
    end;

    local Vector3_new_ret = Vector3.new(p164, p164, p164);
    local v169 = p162 - Vector3_new_ret;
    local v170 = p162 + Vector3_new_ret;
    local v171 = nil;
    local v172 = (1 / 0);
    local v173 = nil;

    for _, v in climbableIndices(v168) do
        local v174 = v168.Records[v];
        local AabbMin = v174.AabbMin;
        local AabbMax = v174.AabbMax;

        if v169.X <= AabbMax.X and (v170.X >= AabbMin.X and (v169.Y <= AabbMax.Y and (v170.Y >= AabbMin.Y and (v169.Z <= AabbMax.Z and v170.Z >= AabbMin.Z)))) then
            local DestructibleIndex = v174.DestructibleIndex;

            if DestructibleIndex == nil and true or DestructibleFrame.IsActive(p161.Destructibles, DestructibleIndex) then
                for _, v2 in v174.LadderPlanes do
                    if math.abs(v2.Normal.Y) < Config.WalkableFloor then
                        local v175 = p162:Dot(v2.Normal) - v2.Distance;

                        if v175 >= -Config.ContactEpsilon and (p164 + Config.ContactEpsilon >= v175 and ladderFaceContains(v174, p162 - v2.Normal * v175, Config.ContactEpsilon)) then
                            local math_max_ret = math.max(v175, 0);

                            if math_max_ret < v172 - Config.HitTieDistance or math.abs(math_max_ret - v172) <= Config.HitTieDistance and (v173 == nil or (v174.SourceId < v173.SourceId or v174.SourceId == v173.SourceId and (v171 ~= nil and v2.PlaneId < v171.PlaneId))) then
                                v172 = math_max_ret;
                                v171 = v2;
                                v173 = v174;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v173 ~= nil and v171 ~= nil and {
        Velocity = Vector3.new(0, 0, 0),
        Normal = v171.Normal,
        SourceId = v173.SourceId,
        Kind = v173.Kind
    } or nil;
end;

return table.freeze(u1);