-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
require(script.Parent.Parent.Types);
require(script.Parent.PlayerHullClearance);
local DeterminismTrace = require(script.Parent.DeterminismTrace);
local u1 = {};
u1.__index = u1;

local function currentStance(p2: string) -- Line: 13
    return p2 == "crouching" and "Ducking" or "Standing";
end;

local function newTrace(p3) -- Line: 18
    local TracePool = p3.TracePool;

    if TracePool == nil then
        return {};
    end;

    local v4 = p3.TracesUsed + 1;
    p3.TracesUsed = v4;
    local v5 = TracePool[v4];

    if v5 == nil then
        v5 = {};
        TracePool[v4] = v5;
    end;

    return v5;
end;

local function newRecord(p6) -- Line: 33
    local RecordPool = p6.RecordPool;

    if RecordPool == nil then
        return {};
    end;

    local v7 = p6.RecordsUsed + 1;
    p6.RecordsUsed = v7;
    local v8 = RecordPool[v7];

    if v8 == nil then
        v8 = {};
        RecordPool[v7] = v8;
    end;

    return v8;
end;

local function writeTrace(p9: any, p10: number, p11: vector, p12: vector, p13: boolean, p14: boolean, p15: any, p16: any, p17: any, p18: any) -- Line: 48
    p9.fraction = p10;
    p9.endPos = p11;
    p9.normal = p12;
    p9.startSolid = p13;
    p9.allSolid = p14;
    p9.planeNum = p15;
    p9.minkowskiPlaneKind = p16;
    p9.hullRecord = p17;
    p9.floorPenetrationDepth = p18;

    return p9;
end;

local function emptyTrace(p19: any, p20: vector) -- Line: 67
    -- upvalues: newTrace (copy)
    local v21 = newTrace(p19);
    v21.fraction = 1;
    v21.endPos = p20;
    v21.normal = Vector3.new(0, 0, 0);
    v21.startSolid = false;
    v21.allSolid = false;
    v21.planeNum = nil;
    v21.minkowskiPlaneKind = nil;
    v21.hullRecord = nil;
    v21.floorPenetrationDepth = nil;

    return v21;
end;

local function minkowskiPlaneKind(p22) -- Line: 71
    if p22.MinkowskiPlaneKind ~= nil then
        return p22.MinkowskiPlaneKind;
    end;

    if p22.Planes == nil or p22.PlaneId == nil then
        return nil;
    end;

    for _, v in p22.Planes do
        if v.PlaneId == p22.PlaneId then
            return v.MinkowskiPlaneKind;
        end;
    end;

    return nil;
end;

local function hullRecord(p23: any, p24: any, p25: vector?, p26: vector?) -- Line: 87
    -- upvalues: newRecord (copy), Enums (copy)
    if p24.SourceId == nil then
        return nil;
    end;

    local RecordType = p24.RecordType;
    local Kind = p24.Kind;
    local v27 = newRecord(p23);
    v27.sourceId = p24.SourceId;
    v27.kind = Kind;
    v27.sourceShape = p24.SourceShape;
    v27.buildMode = p24.BuildMode or (RecordType == "Walkmesh" and "walkMeshTriangle" or (Kind == Enums.SupportKind.Mover and "dynamicMoverObb" or (Kind == Enums.SupportKind.Player and "dynamicPlayerAabb" or nil)));
    v27.climbable = p24.Climbable == true;
    v27.sourceCFrame = p24.SourceCFrame;
    v27.sourceSize = p24.SourceSize;
    v27.surfaceVelocity = p25 or Vector3.new(0, 0, 0);
    v27.surfaceFriction = p24.SurfaceFriction or 1;
    v27.supportAnchor = p26;
    v27.isFloorSupport = RecordType == "Walkmesh" and true or Kind == Enums.SupportKind.Walkmesh;
    v27.allowsPlayerDepenetration = Kind ~= Enums.SupportKind.Mover;

    return v27;
end;

local function fromSweep(p28: any, p29: vector, p30: vector, p31: any) -- Line: 114
    -- upvalues: newTrace (copy), minkowskiPlaneKind (copy), hullRecord (copy)
    if p31.Fraction >= 1 and not (p31.StartSolid or p31.AllSolid) then
        local v32 = newTrace(p28);
        v32.fraction = 1;
        v32.endPos = p30;
        v32.normal = Vector3.new(0, 0, 0);
        v32.startSolid = false;
        v32.allSolid = false;
        v32.planeNum = nil;
        v32.minkowskiPlaneKind = nil;
        v32.hullRecord = nil;
        v32.floorPenetrationDepth = nil;

        return v32;
    end;

    local math_clamp_ret = math.clamp(p31.Fraction, 0, 1);
    local ResolvedPosition = p31.ResolvedPosition;

    if typeof(ResolvedPosition) ~= "Vector3" then
        ResolvedPosition = p29:Lerp(p30, math_clamp_ret);
    end;

    local v33 = minkowskiPlaneKind(p31);
    local v34 = hullRecord(p28, p31, p31.SurfaceVelocity, nil);
    local v35 = newTrace(p28);
    local Normal = p31.Normal;
    local StartSolid = p31.StartSolid;
    local AllSolid = p31.AllSolid;
    local PlaneId = p31.PlaneId;
    local PenetrationDepth = p31.PenetrationDepth;
    v35.fraction = math_clamp_ret;
    v35.endPos = ResolvedPosition;
    v35.normal = Normal;
    v35.startSolid = StartSolid;
    v35.allSolid = AllSolid;
    v35.planeNum = PlaneId;
    v35.minkowskiPlaneKind = v33;
    v35.hullRecord = v34;
    v35.floorPenetrationDepth = PenetrationDepth;

    return v35;
end;

local u36 = {};

local function fromGround(p37: any, p38: vector, p39: vector, p40: any) -- Line: 142
    -- upvalues: newTrace (copy), u36 (copy), Enums (copy), hullRecord (copy)
    if p40 == nil then
        local v41 = newTrace(p37);
        v41.fraction = 1;
        v41.endPos = p39;
        v41.normal = Vector3.new(0, 0, 0);
        v41.startSolid = false;
        v41.allSolid = false;
        v41.planeNum = nil;
        v41.minkowskiPlaneKind = nil;
        v41.hullRecord = nil;
        v41.floorPenetrationDepth = nil;

        return v41;
    end;

    local v42 = p39 - p38;
    local v43 = v42:Dot(v42);
    local v44;

    if v43 > 1e-12 then
        local v45 = (p40.Position - p38):Dot(v42) / v43;
        v44 = math.clamp(v45, 0, 0.999999);
    else
        v44 = 0;
    end;

    local Support = p40.Support;
    local v46 = u36;
    table.clear(v46);
    v46.SourceId = Support.SourceId;
    v46.Kind = Support.Kind;
    v46.RecordType = Support.Kind == Enums.SupportKind.Walkmesh and "Walkmesh" or "Hull";
    v46.BuildMode = Support.Kind == Enums.SupportKind.Walkmesh and "walkMeshTriangle" or (Support.Kind == Enums.SupportKind.Mover and "dynamicMoverObb" or (Support.Kind == Enums.SupportKind.Player and "dynamicPlayerAabb" or nil));
    v46.SurfaceFriction = p40.SurfaceFriction;
    local v47 = hullRecord(p37, v46, Support.Velocity, Support.Anchor);
    local v48 = newTrace(p37);
    local Position = p40.Position;
    local Normal = p40.Normal;
    v48.fraction = v44;
    v48.endPos = Position;
    v48.normal = Normal;
    v48.startSolid = false;
    v48.allSolid = false;
    v48.planeNum = nil;
    v48.minkowskiPlaneKind = nil;
    v48.hullRecord = v47;
    v48.floorPenetrationDepth = nil;

    return v48;
end;

local function groundQuery(p49: any, p50: vector, p51: vector, p52: string, p53: boolean) -- Line: 167
    -- upvalues: fromGround (copy), DeterminismTrace (copy)
    local v54 = p50 - Vector3.new(0, p49.Config.GroundProbeStartBump or 0.03, 0);
    local math_max_ret = math.max(0, v54.Y - p51.Y);
    local GroundBases = p49.GroundBases;

    if GroundBases == nil then
        GroundBases = {};
        p49.GroundBases = GroundBases;
        p49.GroundDistances = {};
        p49.GroundStances = {};
        p49.GroundRecoveries = {};
        p49.GroundResults = {};
        p49.GroundCount = 0;
    end;

    local GroundDistances = p49.GroundDistances;
    local GroundStances = p49.GroundStances;
    local GroundRecoveries = p49.GroundRecoveries;
    local GroundResults = p49.GroundResults;
    local v55 = p52 == "crouching" and "Ducking" or "Standing";
    local v56 = false;
    local v57 = nil;

    for i = 1, p49.GroundCount do
        if GroundBases[i] == v54 and (GroundDistances[i] == math_max_ret and (GroundStances[i] == v55 and GroundRecoveries[i] == p53)) then
            v57 = GroundResults[i];
            v56 = true;
            break;
        end;

        local _ = i;
    end;

    if not v56 then
        local v58;

        if p53 then
            v58 = p49.RecoverySupport;
        else
            v58 = nil;
        end;

        v57 = p49.Query:FindGround(v54, v55, math_max_ret, 1, v58);
        local v59 = p49.GroundCount + 1;
        p49.GroundCount = v59;
        GroundBases[v59] = v54;
        GroundDistances[v59] = math_max_ret;
        GroundStances[v59] = v55;
        GroundRecoveries[v59] = p53;
        GroundResults[v59] = v57;
    end;

    if p50.X ~= p50.X or (p50.Y ~= p50.Y or (p50.Z ~= p50.Z or (p51.X ~= p51.X or (p51.Y ~= p51.Y or p51.Z ~= p51.Z)))) then
        error(string.format("proven simulator issued a non-finite ground query: %s -> %s", tostring(p50), (tostring(p51))), 2);
    end;

    local v60 = fromGround(p49, p50, p51, v57);
    DeterminismTrace.collision(p49.Trace, "collision.findGround", p50, p51, v60, 3);

    return v60;
end;

local function retainedPlayerGroundQuery(p61: any, p62: vector, p63: vector, p64: string) -- Line: 238
    -- upvalues: fromGround (copy), DeterminismTrace (copy)
    local FindPlayerGround = p61.Query.FindPlayerGround;

    if FindPlayerGround == nil then
        return nil;
    end;

    local v65 = p62 - Vector3.new(0, p61.Config.GroundProbeStartBump or 0.03, 0);
    local math_max_ret = math.max(0, v65.Y - p63.Y);
    local v66 = FindPlayerGround(p61.Query, v65, p64 == "crouching" and "Ducking" or "Standing", math_max_ret);

    if v66 == nil then
        return nil;
    end;

    local v67 = fromGround(p61, p62, p63, v66);
    DeterminismTrace.collision(p61.Trace, "collision.findPlayerGround", p62, p63, v67, 3);

    return v67;
end;

function u1.new(p68: any, p69: any, p70: any, p71: any, p72: vector?, p73: any) -- Line: 255
    -- upvalues: u1 (copy)
    return setmetatable({
        Query = p68,
        Config = p69,
        RecoverySupport = p70,
        Trace = p71,
        RetainedGroundSurfaceVelocity = p72,
        PlayerStanceProbe = p73
    }, u1);
end;

local u74 = nil;

function u1.acquire(p75: any, p76: any, p77: any, p78: any, p79: vector?, p80: any) -- Line: 276
    -- upvalues: u1 (copy), u74 (ref)
    if p78 ~= nil then
        return u1.new(p75, p76, p77, p78, p79, p80);
    end;

    local v81 = u74;

    if v81 == nil then
        v81 = u1.new(p75, p76, p77, nil, p79, p80);
        v81.TracePool = {};
        v81.RecordPool = {};
        u74 = v81;
    end;

    v81.Query = p75;
    v81.Config = p76;
    v81.RecoverySupport = p77;
    v81.Trace = nil;
    v81.RetainedGroundSurfaceVelocity = p79;
    v81.PlayerStanceProbe = p80;
    v81.TracesUsed = 0;
    v81.RecordsUsed = 0;
    v81.SweepCount = 0;
    v81.GroundCount = 0;

    return v81;
end;

function u1.GetRetainedGroundSurfaceVelocity(p82) -- Line: 315
    return p82.RetainedGroundSurfaceVelocity;
end;

function u1.ResolveGroundTrace(p83: table, p84: any, p85: vector) -- Line: 320
    -- upvalues: Enums (copy)
    local v86;

    if p84 == nil then
        v86 = nil;
    else
        v86 = p84.hullRecord;
    end;

    if v86 == nil or (typeof(v86.kind) ~= "number" or typeof(v86.sourceId) ~= "number") then
        return nil;
    end;

    if v86.kind == Enums.SupportKind.None or v86.sourceId == 0 then
        return nil;
    end;

    local supportAnchor = v86.supportAnchor;

    if typeof(supportAnchor) ~= "Vector3" then
        if v86.kind == Enums.SupportKind.Mover and typeof(v86.sourceCFrame) == "CFrame" then
            supportAnchor = v86.sourceCFrame:PointToObjectSpace(p85);
        else
            supportAnchor = p85;
        end;
    end;

    local v87 = typeof(v86.surfaceVelocity) ~= "Vector3" and Vector3.new(0, 0, 0) or v86.surfaceVelocity;

    return {
        Position = p85,
        Normal = p84.normal,
        SurfaceFriction = v86.surfaceFriction or p83.Config.SurfaceFrictionDefault,
        Support = {
            Kind = v86.kind,
            SourceId = v86.sourceId,
            Anchor = supportAnchor,
            Velocity = v87
        }
    };
end;

local function sweepTrace(p88: any, p89: string, p90: string, p91: vector, p92: vector, p93: string) -- Line: 349
    -- upvalues: newTrace (copy), fromSweep (copy)
    local Query = p88.Query;
    local v94 = Query[p89];

    if v94 == nil then
        return fromSweep(p88, p91, p92, Query[p90](Query, p91, p92, p93 == "crouching" and "Ducking" or "Standing", nil, 1, 1));
    end;

    local v95 = p93 == "crouching" and "Ducking" or "Standing";
    local SweepNames = p88.SweepNames;

    if SweepNames == nil then
        SweepNames = {};
        p88.SweepNames = SweepNames;
        p88.SweepStarts = {};
        p88.SweepFinishes = {};
        p88.SweepStances = {};
        p88.SweepHits = {};
        p88.SweepCount = 0;
    end;

    local SweepStarts = p88.SweepStarts;
    local SweepFinishes = p88.SweepFinishes;
    local SweepStances = p88.SweepStances;
    local SweepHits = p88.SweepHits;
    local v96 = false;
    local v97 = nil;

    for i = 1, p88.SweepCount do
        if SweepNames[i] == p89 and (SweepStarts[i] == p91 and (SweepFinishes[i] == p92 and SweepStances[i] == v95)) then
            v97 = SweepHits[i];
            v96 = true;
            break;
        end;

        local _ = i;
    end;

    if not v96 then
        v97 = v94(Query, p91, p92, v95, nil, 1, 1);
        local v98 = p88.SweepCount + 1;
        p88.SweepCount = v98;
        SweepNames[v98] = p89;
        SweepStarts[v98] = p91;
        SweepFinishes[v98] = p92;
        SweepStances[v98] = v95;
        SweepHits[v98] = v97;
    end;

    if v97 ~= nil then
        return fromSweep(p88, p91, p92, v97);
    end;

    local v99 = newTrace(p88);
    v99.fraction = 1;
    v99.endPos = p92;
    v99.normal = Vector3.new(0, 0, 0);
    v99.startSolid = false;
    v99.allSolid = false;
    v99.planeNum = nil;
    v99.minkowskiPlaneKind = nil;
    v99.hullRecord = nil;
    v99.floorPenetrationDepth = nil;

    return v99;
end;

function u1.Sweep(p100: table, p101: vector, p102: vector, p103: string, p104: any) -- Line: 399
    -- upvalues: sweepTrace (copy), DeterminismTrace (copy)
    local v105 = sweepTrace(p100, "SweepDetailed", "Sweep", p101, p102, p103);
    DeterminismTrace.collision(p100.Trace, "collision.sweep", p101, p102, v105, 3);

    return v105;
end;

function u1.SweepWithFloorSupport(p106: table, p107: vector, p108: vector, p109: string) -- Line: 405
    -- upvalues: sweepTrace (copy), DeterminismTrace (copy)
    local v110 = sweepTrace(p106, "SweepWithFloorSupportDetailed", "SweepWithFloorSupport", p107, p108, p109);
    DeterminismTrace.collision(p106.Trace, "collision.sweepWithFloor", p107, p108, v110, 3);

    return v110;
end;

function u1.SupportSweep(p111: table, p112: vector, p113: vector, p114: string, p115: number?, p116: boolean?) -- Line: 412
    -- upvalues: retainedPlayerGroundQuery (copy), groundQuery (copy)
    local v117 = retainedPlayerGroundQuery(p111, p112, p113, p114);

    if v117 ~= nil then
        return v117;
    end;

    local v118 = p111:SweepWithFloorSupport(p112, p113, p114);

    if v118.fraction < 1 and (p115 == nil or p115 <= v118.normal.Y) then
        return v118;
    end;

    local v119 = groundQuery(p111, p112, p113, p114, p116 == true);

    if v119.fraction < 1 then
        return v119;
    end;

    return v118;
end;

function u1.WalkableSupportSweep(p120: table, p121: vector, p122: vector, p123: string, p124: number, p125: boolean?) -- Line: 434
    -- upvalues: retainedPlayerGroundQuery (copy), groundQuery (copy)
    local v126 = retainedPlayerGroundQuery(p120, p121, p122, p123);

    if v126 == nil then
        return groundQuery(p120, p121, p122, p123, p125 == true);
    end;

    return v126;
end;

function u1.FloorSupportSweep(p127: table, p128: vector, p129: vector, p130: string, p131: number?) -- Line: 448
    -- upvalues: groundQuery (copy), newTrace (copy)
    local v132 = groundQuery(p127, p128, p129, p130, false);
    local hullRecord2 = v132.hullRecord;

    if hullRecord2 ~= nil and hullRecord2.isFloorSupport == true then
        return v132;
    end;

    local v133 = newTrace(p127);
    v133.fraction = 1;
    v133.endPos = p129;
    v133.normal = Vector3.new(0, 0, 0);
    v133.startSolid = false;
    v133.allSolid = false;
    v133.planeNum = nil;
    v133.minkowskiPlaneKind = nil;
    v133.hullRecord = nil;
    v133.floorPenetrationDepth = nil;

    return v133;
end;

function u1.PointTest(p134: table, p135: vector, p136: string, p137: boolean?) -- Line: 462
    -- upvalues: newTrace (copy), hullRecord (copy), Enums (copy), DeterminismTrace (copy)
    local v138 = p134:Sweep(p135, p135, p136);
    local PlayerStanceProbe = p134.PlayerStanceProbe;

    if p137 ~= true or (PlayerStanceProbe == nil or (v138.startSolid or v138.allSolid)) then
        return v138;
    end;

    local v139 = PlayerStanceProbe(p135, p136 == "crouching" and "Ducking" or "Standing");

    if v139 ~= nil then
        v138 = newTrace(p134);
        v138.fraction = 1;
        v138.endPos = p135;
        v138.normal = Vector3.new(0, 0, 0);
        v138.startSolid = false;
        v138.allSolid = false;
        v138.planeNum = nil;
        v138.minkowskiPlaneKind = nil;
        v138.hullRecord = nil;
        v138.floorPenetrationDepth = nil;
        v138.fraction = 0;
        v138.startSolid = true;
        v138.allSolid = true;
        v138.hullRecord = hullRecord(p134, {
            SourceId = v139,
            Kind = Enums.SupportKind.Player
        }, nil, nil);
        DeterminismTrace.collision(p134.Trace, "collision.playerStanceClearance", p135, p135, v138, 3);
    end;

    return v138;
end;

function u1.BeginStepBounds(p140: table, p141: vector, p142: vector, p143: number, p144: number) -- Line: 481
    local Query = p140.Query;

    if Query.SetMovementBounds == nil then
        return;
    end;

    local Config = p140.Config;
    local v145 = (p142.Magnitude + p143) * p144 + 1.5;
    local v146 = v145 + math.max(Config.MaxStepHeight, Config.GroundProbeDistance);
    local Vector3_new_ret = Vector3.new(v145, v146, v145);
    Query:SetMovementBounds(p141 - Vector3_new_ret, p141 + Vector3_new_ret);
end;

function u1.HasUniformGroundSurfaces(p147: table, p148: vector, p149: string, p150: number) -- Line: 498
    return false;
end;

function u1.HasClimbableNear(p151: table, p152: vector, p153: string, p154: number) -- Line: 506
    local FindLadder = p151.Query.FindLadder;
    local v155;

    if FindLadder == nil then
        v155 = false;
    else
        v155 = FindLadder(p151.Query, p152, p153 == "crouching" and "Ducking" or "Standing", p154, 1) ~= nil;
    end;

    return v155;
end;

function u1.CanonicalizeExpandedBlockCornerTrace(p156: table, p157: any, p158: vector, p159: string) -- Line: 511
    return p157;
end;

return table.freeze(u1);