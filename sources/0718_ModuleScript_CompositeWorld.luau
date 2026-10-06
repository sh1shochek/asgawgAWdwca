-- Decompiled with Potassium's decompiler.

local Enums = require(script.Parent.Parent.Enums);
require(script.Parent.Parent.Simulation.Types);
local Geometry = require(script.Parent.Geometry);
local MoverFrame = require(script.Parent.MoverFrame);
local MoverProxyCache = require(script.Parent.MoverProxyCache);
require(script.Parent.TopologyConfig);
require(script.Parent.World);
local u1 = {};
u1.__index = u1;

local function isFiniteNumber(p2) -- Line: 68
    local v3;

    if typeof(p2) == "number" and (p2 == p2 and p2 > (-1 / 0)) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

local function assertPosition(p4: vector, p5: string) -- Line: 72
    -- upvalues: Geometry (copy)
    if not Geometry.IsFiniteVector3(p4) then
        error(string.format("%s must be a finite Vector3", p5));
    end;
end;

local function assertTimeFraction(p6: number) -- Line: 78
    local v7;

    if typeof(p6) == "number" and (p6 == p6 and p6 > (-1 / 0)) then
        v7 = p6 < (1 / 0);
    else
        v7 = false;
    end;

    if v7 then
        if p6 >= 0 then
            v7 = p6 <= 1;
        else
            v7 = false;
        end;
    end;

    assert(v7, "collision time fraction must be normalized");
end;

local function assertTimeInterval(p8: number, p9: number) -- Line: 85
    local v10;

    if typeof(p8) == "number" and (p8 == p8 and p8 > (-1 / 0)) then
        v10 = p8 < (1 / 0);
    else
        v10 = false;
    end;

    if v10 then
        if p8 >= 0 then
            v10 = p8 <= 1;
        else
            v10 = false;
        end;
    end;

    assert(v10, "collision time fraction must be normalized");
    local v11;

    if typeof(p9) == "number" and (p9 == p9 and p9 > (-1 / 0)) then
        v11 = p9 < (1 / 0);
    else
        v11 = false;
    end;

    if v11 then
        if p9 >= 0 then
            v11 = p9 <= 1;
        else
            v11 = false;
        end;
    end;

    assert(v11, "collision time fraction must be normalized");
    assert(p8 <= p9, "collision time interval is reversed");
end;

local function identityLess(p12: table, p13: table) -- Line: 91
    if p12.SourceId ~= p13.SourceId then
        return p12.SourceId < p13.SourceId;
    end;

    if p12.Kind ~= p13.Kind then
        return p12.Kind < p13.Kind;
    end;

    if p12.ElementId == p13.ElementId then
        return p12.PlaneId < p13.PlaneId;
    end;

    return p12.ElementId < p13.ElementId;
end;

local function shouldReplace(p14: table?, p15: table, p16: vector) -- Line: 104
    if p14 == nil then
        return true;
    end;

    if p15.StartSolid ~= p14.StartSolid then
        return p15.StartSolid;
    end;

    if math.abs(p15.Fraction - p14.Fraction) > 1e-9 then
        return p15.Fraction < p14.Fraction;
    end;

    local v17 = -p16:Dot(p15.Normal);
    local v18 = -p16:Dot(p14.Normal);

    if math.abs(v17 - v18) > 1e-9 then
        return v18 < v17;
    end;

    if p15.SourceId ~= p14.SourceId then
        return p15.SourceId < p14.SourceId;
    end;

    if p15.Kind ~= p14.Kind then
        return p15.Kind < p14.Kind;
    end;

    if p15.ElementId == p14.ElementId then
        return p15.PlaneId < p14.PlaneId;
    end;

    return p15.ElementId < p14.ElementId;
end;

local function endpointDetailed(p19: any, p20: vector, p21: vector, p22: number, p23: vector, p24: boolean, p25: boolean, p26: number) -- Line: 122
    -- upvalues: Enums (copy), MoverFrame (copy)
    local Record = p19.Record;
    local math_clamp_ret = math.clamp(p22, 0, 1);
    local v27 = p20:Lerp(p21, math_clamp_ret);

    return {
        DestructibleIndex = nil,
        ElementId = 0,
        SourceShape = "Block",
        RecordType = "Hull",
        BuildMode = "dynamicMoverObb",
        Fraction = math_clamp_ret,
        Normal = p23,
        StartSolid = p24,
        AllSolid = p25,
        PlaneId = p26,
        SourceId = Record.Id,
        Kind = Enums.SupportKind.Mover,
        SurfaceFriction = Record.SurfaceFriction,
        SurfaceVelocity = MoverFrame.VelocityAtPoint(Record, v27, 1),
        SourceCFrame = Record.CFrame,
        SourceSize = Record.Size
    };
end;

local function staticDetailed(p28) -- Line: 155
    return {
        SurfaceVelocity = Vector3.new(0, 0, 0),
        Fraction = p28.Fraction,
        Normal = p28.Normal,
        StartSolid = p28.StartSolid,
        AllSolid = p28.AllSolid,
        PlaneId = p28.PlaneId,
        SourceId = p28.SourceId,
        Kind = p28.Kind,
        DestructibleIndex = p28.DestructibleIndex,
        ElementId = p28.ElementId,
        SurfaceFriction = p28.SurfaceFriction,
        ResolvedPosition = p28.ResolvedPosition,
        PenetrationDepth = p28.PenetrationDepth,
        SourceShape = p28.SourceShape,
        MinkowskiPlaneKind = p28.MinkowskiPlaneKind,
        RecordType = p28.RecordType,
        Climbable = p28.Climbable,
        BuildMode = p28.BuildMode,
        SourceCFrame = p28.SourceCFrame,
        SourceSize = p28.SourceSize,
        Planes = p28.Planes
    };
end;

local function sweepResult(p29: table?) -- Line: 182
    return p29 == nil and {
        Fraction = 1,
        Normal = Vector3.new(0, 1, 0),
        StartSolid = false,
        AllSolid = false
    } or {
        Fraction = p29.Fraction,
        Normal = p29.Normal,
        StartSolid = p29.StartSolid,
        AllSolid = p29.AllSolid,
        SourceId = p29.SourceId,
        Kind = p29.Kind,
        SourceShape = p29.SourceShape,
        MinkowskiPlaneKind = p29.MinkowskiPlaneKind,
        RecordType = p29.RecordType,
        Climbable = p29.Climbable,
        BuildMode = p29.BuildMode,
        SourceCFrame = p29.SourceCFrame,
        SourceSize = p29.SourceSize,
        Planes = p29.Planes,
        PlaneId = p29.PlaneId,
        SurfaceFriction = p29.SurfaceFriction,
        SurfaceVelocity = p29.SurfaceVelocity,
        ResolvedPosition = p29.ResolvedPosition,
        PenetrationDepth = p29.PenetrationDepth
    };
end;

local function ignoredMover(p30, p31) -- Line: 214
    -- upvalues: Enums (copy)
    local v32;

    if p31 == nil or p31.Kind ~= Enums.SupportKind.Mover then
        v32 = false;
    else
        v32 = p31.SourceId == p30.Id;
    end;

    return v32;
end;

local function assertCurrentPoseInterval(p33: number, p34: number) -- Line: 220
    local v35;

    if p33 == 1 then
        v35 = p34 == 1;
    else
        v35 = false;
    end;

    assert(v35, "mover collision supports only the committed current-pose time fraction 1");
end;

function u1.new(p36: any, p37: any, p38: table) -- Line: 227
    -- upvalues: u1 (copy)
    local table_isfrozen_ret = table.isfrozen(p36);
    assert(table_isfrozen_ret, "static collision world must be immutable");
    local v39 = table.isfrozen(p37) and table.isfrozen(p37.Records) and table.isfrozen(p37.ById);
    assert(v39, "mover frame must be immutable");

    for _, v in p37.Records do
        local table_isfrozen_ret2 = table.isfrozen(v);
        assert(table_isfrozen_ret2, "mover frame contains a mutable record");
    end;

    local v40;

    if p38 == nil then
        v40 = false;
    else
        v40 = p38.Cache ~= nil;
    end;

    assert(v40, "mover world requires an instance-owned proxy cache");
    local Cache = p38.Cache;
    Cache:BeginComposition();
    local table_create_ret = table.create(#p37.Records);

    for i, v in p37.Records do
        table_create_ret[i] = Cache:BindEndpoint(v, p36.Topology.Config);
    end;

    table.freeze(table_create_ret);

    return table.freeze((setmetatable({
        Static = p36,
        Movers = p37,
        EndpointMovers = table_create_ret,
        Config = p36.Topology.Config
    }, u1)));
end;

function u1.SweepMoversDetailed(p41: any, p42: vector, p43: vector, p44: any, p45: any, p46: number, p47: number) -- Line: 252
    -- upvalues: Geometry (copy), Enums (copy), MoverProxyCache (copy), endpointDetailed (copy), shouldReplace (copy)
    if not Geometry.IsFiniteVector3(p42) then
        error(string.format("%s must be a finite Vector3", "mover sweep start"));
    end;

    if not Geometry.IsFiniteVector3(p43) then
        error(string.format("%s must be a finite Vector3", "mover sweep end"));
    end;

    local v48;

    if typeof(p46) == "number" and (p46 == p46 and p46 > (-1 / 0)) then
        v48 = p46 < (1 / 0);
    else
        v48 = false;
    end;

    if v48 then
        if p46 >= 0 then
            v48 = p46 <= 1;
        else
            v48 = false;
        end;
    end;

    assert(v48, "collision time fraction must be normalized");
    local v49;

    if typeof(p47) == "number" and (p47 == p47 and p47 > (-1 / 0)) then
        v49 = p47 < (1 / 0);
    else
        v49 = false;
    end;

    if v49 then
        if p47 >= 0 then
            v49 = p47 <= 1;
        else
            v49 = false;
        end;
    end;

    assert(v49, "collision time fraction must be normalized");
    assert(p46 <= p47, "collision time interval is reversed");
    local v50;

    if p46 == 1 then
        v50 = p47 == 1;
    else
        v50 = false;
    end;

    assert(v50, "mover collision supports only the committed current-pose time fraction 1");
    local v51 = p43 - p42;
    local v52 = nil;

    for _, v in p41.EndpointMovers do
        local Record = v.Record;
        local v53;

        if p45 == nil or p45.Kind ~= Enums.SupportKind.Mover then
            v53 = false;
        else
            v53 = p45.SourceId == Record.Id;
        end;

        if not v53 then
            local v54, v55, v56, v57, v58 = MoverProxyCache.SweepEndpoint(v, p42, p43, p44, p41.Config);

            if v54 ~= nil then
                local v59 = endpointDetailed(v, p42, p43, v54, v55, v56, v57, v58);

                if shouldReplace(v52, v59, v51) then
                    v52 = v59;
                end;
            end;
        end;
    end;

    return v52;
end;

function u1.SweepDetailed(p60: any, p61: vector, p62: vector, p63: any, p64: any, p65: number, p66: number) -- Line: 284
    -- upvalues: Geometry (copy), staticDetailed (copy), shouldReplace (copy)
    if not Geometry.IsFiniteVector3(p61) then
        error(string.format("%s must be a finite Vector3", "composite sweep start"));
    end;

    if not Geometry.IsFiniteVector3(p62) then
        error(string.format("%s must be a finite Vector3", "composite sweep end"));
    end;

    local v67;

    if typeof(p65) == "number" and (p65 == p65 and p65 > (-1 / 0)) then
        v67 = p65 < (1 / 0);
    else
        v67 = false;
    end;

    if v67 then
        if p65 >= 0 then
            v67 = p65 <= 1;
        else
            v67 = false;
        end;
    end;

    assert(v67, "collision time fraction must be normalized");
    local v68;

    if typeof(p66) == "number" and (p66 == p66 and p66 > (-1 / 0)) then
        v68 = p66 < (1 / 0);
    else
        v68 = false;
    end;

    if v68 then
        if p66 >= 0 then
            v68 = p66 <= 1;
        else
            v68 = false;
        end;
    end;

    assert(v68, "collision time fraction must be normalized");
    assert(p65 <= p66, "collision time interval is reversed");
    local v69 = p62 - p61;
    local v70 = p60.Static:SweepDetailed(p61, p62, p63, p64, p65, p66);
    local v71;

    if v70 == nil then
        v71 = nil;
    else
        v71 = staticDetailed(v70);
    end;

    local v72 = p60:SweepMoversDetailed(p61, p62, p63, p64, p65, p66);

    if v72 == nil then
        v72 = v71;
    elseif not shouldReplace(v71, v72, v69) then
        v72 = v71;
    end;

    return v72;
end;

function u1.Sweep(p73: any, p74: vector, p75: vector, p76: any, p77: any, p78: number, p79: number) -- Line: 308
    -- upvalues: sweepResult (copy)
    return sweepResult(p73:SweepDetailed(p74, p75, p76, p77, p78, p79));
end;

function u1.SweepWithFloorSupportDetailed(p80: any, p81: vector, p82: vector, p83: any, p84: any, p85: number, p86: number) -- Line: 322
    -- upvalues: Geometry (copy), staticDetailed (copy), shouldReplace (copy)
    if not Geometry.IsFiniteVector3(p81) then
        error(string.format("%s must be a finite Vector3", "composite floor sweep start"));
    end;

    if not Geometry.IsFiniteVector3(p82) then
        error(string.format("%s must be a finite Vector3", "composite floor sweep end"));
    end;

    local v87;

    if typeof(p85) == "number" and (p85 == p85 and p85 > (-1 / 0)) then
        v87 = p85 < (1 / 0);
    else
        v87 = false;
    end;

    if v87 then
        if p85 >= 0 then
            v87 = p85 <= 1;
        else
            v87 = false;
        end;
    end;

    assert(v87, "collision time fraction must be normalized");
    local v88;

    if typeof(p86) == "number" and (p86 == p86 and p86 > (-1 / 0)) then
        v88 = p86 < (1 / 0);
    else
        v88 = false;
    end;

    if v88 then
        if p86 >= 0 then
            v88 = p86 <= 1;
        else
            v88 = false;
        end;
    end;

    assert(v88, "collision time fraction must be normalized");
    assert(p85 <= p86, "collision time interval is reversed");
    local v89 = p82 - p81;
    local v90 = p80.Static:SweepWithFloorSupportDetailed(p81, p82, p83, p84, p85, p86);
    local v91;

    if v90 == nil then
        v91 = nil;
    else
        v91 = staticDetailed(v90);
    end;

    local v92 = p80:SweepMoversDetailed(p81, p82, p83, p84, p85, p86);

    if v92 == nil then
        v92 = v91;
    elseif not shouldReplace(v91, v92, v89) then
        v92 = v91;
    end;

    return v92;
end;

function u1.SweepWithFloorSupport(p93: any, p94: vector, p95: vector, p96: any, p97: any, p98: number, p99: number) -- Line: 352
    -- upvalues: sweepResult (copy)
    return sweepResult(p93:SweepWithFloorSupportDetailed(p94, p95, p96, p97, p98, p99));
end;

local function moversAreClear(p100: any, p101: vector, p102: any) -- Line: 373
    -- upvalues: MoverProxyCache (copy)
    for _, v in p100.EndpointMovers do
        if MoverProxyCache.ContainsEndpoint(v, p101, p102, p100.Config) then
            return false;
        end;
    end;

    return true;
end;

function u1.IsClear(p103: any, p104: vector, p105: any, p106: number) -- Line: 382
    -- upvalues: Geometry (copy), moversAreClear (copy)
    if not Geometry.IsFiniteVector3(p104) then
        error(string.format("%s must be a finite Vector3", "composite clearance position"));
    end;

    local v107;

    if typeof(p106) == "number" and (p106 == p106 and p106 > (-1 / 0)) then
        v107 = p106 < (1 / 0);
    else
        v107 = false;
    end;

    if v107 then
        if p106 >= 0 then
            v107 = p106 <= 1;
        else
            v107 = false;
        end;
    end;

    assert(v107, "collision time fraction must be normalized");
    local v108;

    if p106 == 1 then
        v108 = p106 == 1;
    else
        v108 = false;
    end;

    assert(v108, "mover collision supports only the committed current-pose time fraction 1");
    local v109 = p103.Static:IsClear(p104, p105, p106) and moversAreClear(p103, p104, p105);

    return v109;
end;

function u1.CanMove(p110: any, p111: vector, p112: vector, p113: any, p114: any, p115: number, p116: number) -- Line: 389
    -- upvalues: Geometry (copy), shouldReplace (copy)
    if not Geometry.IsFiniteVector3(p111) then
        error(string.format("%s must be a finite Vector3", "composite sweep start"));
    end;

    if not Geometry.IsFiniteVector3(p112) then
        error(string.format("%s must be a finite Vector3", "composite sweep end"));
    end;

    local v117;

    if typeof(p115) == "number" and (p115 == p115 and p115 > (-1 / 0)) then
        v117 = p115 < (1 / 0);
    else
        v117 = false;
    end;

    if v117 then
        if p115 >= 0 then
            v117 = p115 <= 1;
        else
            v117 = false;
        end;
    end;

    assert(v117, "collision time fraction must be normalized");
    local v118;

    if typeof(p116) == "number" and (p116 == p116 and p116 > (-1 / 0)) then
        v118 = p116 < (1 / 0);
    else
        v118 = false;
    end;

    if v118 then
        if p116 >= 0 then
            v118 = p116 <= 1;
        else
            v118 = false;
        end;
    end;

    assert(v118, "collision time fraction must be normalized");
    assert(p115 <= p116, "collision time interval is reversed");
    local v119 = p110.Static:SweepDetailed(p111, p112, p113, p114, p115, p116);
    local v120 = p110:SweepMoversDetailed(p111, p112, p113, p114, p115, p116);

    if v120 == nil then
        v120 = v119;
    elseif not shouldReplace(v119, v120, p112 - p111) then
        v120 = v119;
    end;

    local v121;

    if v120 == nil then
        v121 = p110:IsClear(p112, p113, p116);
    else
        v121 = not v120.StartSolid;

        if v121 then
            if v120.Fraction >= 1 then
                v121 = p110:IsClear(p112, p113, p116);
            else
                v121 = false;
            end;
        end;
    end;

    return v121;
end;

local function groundIdentityLess(p122: number, p123: number, p124: any) -- Line: 414
    if p123 == p124.Support.SourceId then
        return p122 < p124.Support.Kind;
    end;

    return p123 < p124.Support.SourceId;
end;

function u1.FindGround(p125: any, p126: vector, p127: any, p128: number, p129: number, p130: any) -- Line: 421
    -- upvalues: Geometry (copy), MoverProxyCache (copy), Enums (copy), MoverFrame (copy), moversAreClear (copy)
    if not Geometry.IsFiniteVector3(p126) then
        error(string.format("%s must be a finite Vector3", "composite ground position"));
    end;

    local v131;

    if typeof(p129) == "number" and (p129 == p129 and p129 > (-1 / 0)) then
        v131 = p129 < (1 / 0);
    else
        v131 = false;
    end;

    if v131 then
        if p129 >= 0 then
            v131 = p129 <= 1;
        else
            v131 = false;
        end;
    end;

    assert(v131, "collision time fraction must be normalized");
    local v132;

    if p129 == 1 then
        v132 = p129 == 1;
    else
        v132 = false;
    end;

    assert(v132, "mover collision supports only the committed current-pose time fraction 1");
    local v133;

    if typeof(p128) == "number" and (p128 == p128 and p128 > (-1 / 0)) then
        v133 = p128 < (1 / 0);
    else
        v133 = false;
    end;

    if v133 then
        if p128 >= 0 then
            v133 = p128 <= p125.Config.MaxSweepDistance;
        else
            v133 = false;
        end;
    end;

    assert(v133, "invalid ground distance");
    local v134 = p125.Static:FindGround(p126, p127, p128, p129, p130);
    local v135 = v134 == nil and (1 / 0) or p126.Y - v134.Position.Y;
    local math_min_ret = math.min(p125.Config.GroundProbeStartBump, p125.Config.MaxSweepDistance - p128);
    local v136 = p126 + Vector3.new(0, math_min_ret, 0);
    local math_min_ret2 = math.min(p128 + p125.Config.ContactEpsilon, p125.Config.MaxSweepDistance);
    local v137 = p126 - Vector3.new(0, math_min_ret2, 0);
    local v138 = v134;

    for _, v in p125.EndpointMovers do
        local v139, v140, v141 = MoverProxyCache.SweepEndpoint(v, v136, v137, p127, p125.Config);

        if v139 ~= nil and (not v141 and v140.Y >= p125.Config.WalkableFloor) then
            local v142 = v136:Lerp(v137, v139);
            local v143 = p126.Y - v142.Y;
            local Record = v.Record;
            local v144 = v134 == nil and true or v143 < v135 - p125.Config.HitTieDistance;

            if not (v144 or (v134 == nil or math.abs(v143 - v135) > p125.Config.HitTieDistance)) then
                if math.abs(v140.Y - v134.Normal.Y) > 1e-9 then
                    v144 = v140.Y > v134.Normal.Y;
                else
                    local Mover = Enums.SupportKind.Mover;
                    local Id = Record.Id;

                    if Id == v134.Support.SourceId then
                        v144 = Mover < v134.Support.Kind;
                    else
                        v144 = Id < v134.Support.SourceId;
                    end;
                end;
            end;

            if v144 then
                v134 = {
                    Position = v142,
                    Normal = v140,
                    SurfaceFriction = Record.SurfaceFriction,
                    Support = {
                        Kind = Enums.SupportKind.Mover,
                        SourceId = Record.Id,
                        Anchor = Record.CFrame:PointToObjectSpace(v142),
                        Velocity = MoverFrame.VelocityAtPoint(Record, v142, 1)
                    }
                };
                v135 = v143;
            end;
        end;
    end;

    if v134 ~= nil then
        if v134 ~= v138 and not p125.Static:IsClear(v134.Position, p127, p129) then
            return nil;
        end;

        if not moversAreClear(p125, v134.Position, p127) then
            return nil;
        end;
    end;

    return v134;
end;

function u1.FindLadder(p145: any, p146: vector, p147: any, p148: number, p149: number) -- Line: 488
    local v150;

    if p149 == 1 then
        v150 = p149 == 1;
    else
        v150 = false;
    end;

    assert(v150, "mover collision supports only the committed current-pose time fraction 1");

    return p145.Static:FindLadder(p146, p147, p148, p149);
end;

function u1.FindMoverPush(p151: any, p152: vector, p153: any, p154: number, p155: number) -- Line: 501
    -- upvalues: Geometry (copy), MoverProxyCache (copy)
    if not Geometry.IsFiniteVector3(p152) then
        error(string.format("%s must be a finite Vector3", "mover push position"));
    end;

    local v156;

    if p153 == "Ducking" then
        v156 = p151.Config.DuckingHalfSize;
    else
        v156 = p151.Config.StandingHalfSize;
    end;

    local Magnitude = v156.Magnitude;

    for _, v in p151.EndpointMovers do
        local Record = v.Record;

        if Record.Id > p154 and (Record.Pushes and Record.PreviousCFrame ~= Record.CFrame) then
            local v157 = Record.BoundingRadius + Magnitude;
            local v158 = p152 - Record.CFrame.Position;

            if v158:Dot(v158) <= v157 * v157 then
                local v159 = (Record.CFrame * Record.PreviousCFrame:Inverse()):PointToWorldSpace(p152) - p152;
                local Magnitude2 = v159.Magnitude;

                if Magnitude2 > p151.Config.ContactEpsilon then
                    local v160 = v159 / Magnitude2;
                    local v161, v162 = MoverProxyCache.PushExitDistances(v, p152, v160, p153, p151.Config, p155);

                    if v161 ~= nil and (v161 ~= (1 / 0) and v162 >= v161) then
                        return Record.Id, v160 * math.max(Magnitude2, v161);
                    end;
                end;
            end;
        end;
    end;

    return nil, Vector3.new(0, 0, 0);
end;

function u1.PenetratesMover(p163: any, p164: number, p165: vector, p166: any) -- Line: 536
    -- upvalues: MoverProxyCache (copy)
    for _, v in p163.EndpointMovers do
        if v.Record.Id == p164 then
            return MoverProxyCache.PenetratesEndpoint(v, p165, p166, p163.Config);
        end;
    end;

    return false;
end;

function u1.SetMovementBounds(p167: any, p168: vector, p169: vector) -- Line: 545
    p167.Static:SetMovementBounds(p168, p169);
end;

function u1.ClearMovementBounds(p170) -- Line: 549
    p170.Static:ClearMovementBounds();
end;

return table.freeze(u1);