-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.ProvenTypes);
local ProvenMath = require(script.Parent.Parent.ProvenMath);
local Trace = require(script.Parent.Trace);
local TraceRules = require(script.Parent.TraceRules);
local SlideMove = require(script.Parent.SlideMove);
local v1 = {};
local line = Trace.line;
local vector = Trace.vector;
local clampHorizontal = ProvenMath.clampHorizontal;
local horizontalMagnitudeSq = ProvenMath.horizontalMagnitudeSq;
local tryPlayerMove = SlideMove.tryPlayerMove;
local GROUND_PROBE_START_BUMP = TraceRules.GROUND_PROBE_START_BUMP;
local isPointTestBlocked = TraceRules.isPointTestBlocked;
local getTraceSurfaceVelocity = TraceRules.getTraceSurfaceVelocity;
local getImpactWallConstraintNormal = TraceRules.getImpactWallConstraintNormal;
local isDynamicWallContactRecord = TraceRules.isDynamicWallContactRecord;
local isFloorSupportTrace = TraceRules.isFloorSupportTrace;
local getResolvedSupportPosition = TraceRules.getResolvedSupportPosition;
local isWalkableGround = TraceRules.isWalkableGround;
local getTraceGroundNormal = TraceRules.getTraceGroundNormal;
local getTraceMinkowskiPlaneKind = TraceRules.getTraceMinkowskiPlaneKind;
local isRampPrimitiveHullRecord = TraceRules.isRampPrimitiveHullRecord;
local supportTraceMatchesPosition = TraceRules.supportTraceMatchesPosition;
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};

local function getClearWalkableSupportFallback(p6: vector, p7: number, p8: string, p9: any, p10: any, p11: boolean?) -- Line: 61
    -- upvalues: GROUND_PROBE_START_BUMP (copy), isWalkableGround (copy), getResolvedSupportPosition (copy), isPointTestBlocked (copy)
    local v12 = p9:WalkableSupportSweep(p6 + Vector3.new(0, GROUND_PROBE_START_BUMP, 0), p6 - Vector3.new(0, p7, 0), p8, p10.WalkableFloor, p11);

    if not isWalkableGround(v12, p10) then
        return nil;
    end;

    if isPointTestBlocked(p9:PointTest(getResolvedSupportPosition(v12, p6), p8)) then
        return nil;
    end;

    return v12;
end;

local function groundProbeWithRetry(p13: vector, p14: number, p15: string, p16: any, p17: any, p18: boolean?, p19: boolean?) -- Line: 89
    -- upvalues: GROUND_PROBE_START_BUMP (copy), isWalkableGround (copy), getClearWalkableSupportFallback (copy)
    local v20 = p16:SupportSweep(p13 + Vector3.new(0, GROUND_PROBE_START_BUMP, 0), p13 - Vector3.new(0, p14, 0), p15, p17.WalkableFloor, p19);
    local v21;

    if v20.startSolid and p18 ~= false then
        local math_max_ret = math.max(GROUND_PROBE_START_BUMP, p14, p17.MaxStepHeight);
        local endPos = p16:Sweep(p13, p13 + Vector3.new(0, math_max_ret, 0), p15).endPos;
        v21 = p16:SupportSweep(endPos, endPos - Vector3.new(0, p14 + math_max_ret, 0), p15, p17.WalkableFloor, p19);

        if v21.startSolid and v21.allSolid then
            v21 = v20;
        end;
    else
        v21 = v20;
    end;

    local v22;

    if isWalkableGround(v21, p17) or v21.normal.Y >= p17.WalkableFloor then
        v22 = v21;
    else
        v22 = getClearWalkableSupportFallback(p13, p14, p15, p16, p17, p19);

        if v22 == nil then
            v22 = v21;
        end;
    end;

    return v22;
end;

local function getHorizontalDistanceSq(p23: vector, p24: vector) -- Line: 140
    local v25 = p24.X - p23.X;
    local v26 = p24.Z - p23.Z;

    return v25 * v25 + v26 * v26;
end;

local function getForwardMoveProgress(p27: vector, p28: vector, p29: vector?) -- Line: 146
    return p29 == nil and 0 or (p28.X - p27.X) * p29.X + (p28.Z - p27.Z) * p29.Z;
end;

local function makeGroundMoveChoice(p30: table, p31: vector, p32: vector, p33: vector, p34: boolean, p35: boolean, p36: any, p37: vector?) -- Line: 156
    p30.position = p32;
    p30.velocity = p33;
    p30.collided = p34;
    p30.touchedWall = p35;
    p30.impactTrace = p36;
    local v38 = p32.X - p31.X;
    local v39 = p32.Z - p31.Z;
    p30.horizontalDistanceSq = v38 * v38 + v39 * v39;
    p30.forwardProgress = p37 == nil and 0 or (p32.X - p31.X) * p37.X + (p32.Z - p31.Z) * p37.Z;

    return p30;
end;

local function resolveGroundDriveDirection(p40: vector?, p41: vector, p42: number) -- Line: 176
    local v43 = p42 * p42;

    if p40 ~= nil then
        local X = p40.X;
        local Z = p40.Z;
        local v44 = X * X + Z * Z;

        if v43 < v44 then
            local v45 = 1 / math.sqrt(v44);

            return Vector3.new(X * v45, 0, Z * v45);
        end;
    end;

    local X = p41.X;
    local Z = p41.Z;
    local v46 = X * X + Z * Z;

    if v43 >= v46 then
        return nil;
    end;

    local v47 = 1 / math.sqrt(v46);

    return Vector3.new(X * v47, 0, Z * v47);
end;

local function getStaticWallConstraintNormal(p48: any, p49: vector, p50: any) -- Line: 203
    -- upvalues: isDynamicWallContactRecord (copy), getImpactWallConstraintNormal (copy)
    if p48 == nil then
        return nil;
    end;

    if p48.normal.Y >= p50.WalkableFloor or isDynamicWallContactRecord(p48.hullRecord) then
        return nil;
    end;

    local surfaceVelocity = p48.hullRecord.surfaceVelocity;

    if surfaceVelocity ~= nil and surfaceVelocity.Magnitude > p50.PositionSnapEpsilon then
        return nil;
    end;

    local v51 = getImpactWallConstraintNormal(p48, p50);

    if v51.Magnitude <= p50.PositionSnapEpsilon or (math.abs(v51.Y) > p50.PositionSnapEpsilon or p49:Dot(v51) >= -p50.VelocityEpsilon) then
        return nil;
    end;

    return v51.Unit;
end;

local function getRampAdjacentWallNormal(p52: any, p53: any, p54: vector, p55: any) -- Line: 226
    -- upvalues: getStaticWallConstraintNormal (copy)
    if p53 == nil or (p52 == nil or p52.hullRecord == p53.hullRecord) then
        return nil;
    end;

    return getStaticWallConstraintNormal(p52, p54, p55);
end;

local function tryWalkableRampSupportMove(p56: table, p57: vector, p58: vector, p59: number, p60: any, p61: any, p62: string, p63: any, p64: any, p65: vector?) -- Line: 238
    -- upvalues: getTraceGroundNormal (copy), isWalkableGround (copy), isRampPrimitiveHullRecord (copy), getTraceMinkowskiPlaneKind (copy), getStaticWallConstraintNormal (copy), ProvenMath (copy), horizontalMagnitudeSq (copy), isDynamicWallContactRecord (copy), getResolvedSupportPosition (copy), isPointTestBlocked (copy)
    local v66 = getTraceGroundNormal(p63);

    if v66 == nil then
        return nil, nil, false;
    end;

    local v67 = isWalkableGround(p63, p61);
    local v68 = false;
    local v69 = false;
    local v70 = nil;
    local hullRecord = p63.hullRecord;

    if v67 then
        if v66.Y >= 1 - p61.PositionSnapEpsilon then
            return nil, nil, false;
        end;
    elseif isRampPrimitiveHullRecord(hullRecord) and getTraceMinkowskiPlaneKind(p63) == "playerAxis" then
        local Vector3_new_ret = Vector3.new(v66.X, 0, v66.Z);

        if Vector3_new_ret.Magnitude <= p61.PositionSnapEpsilon then
            return nil, nil, false;
        end;

        v70 = Vector3_new_ret.Unit;

        if Vector3.new(p58.X, 0, p58.Z):Dot(v70) >= -p61.PositionSnapEpsilon then
            return nil, nil, false;
        end;

        v68 = true;
    else
        if p63 ~= p64 or getStaticWallConstraintNormal(p64, p58, p61) == nil then
            return nil, nil, false;
        end;

        v69 = true;
    end;

    local v71 = nil;
    local v72;

    if v67 then
        if p63 == nil or (p64 == nil or p64.hullRecord == p63.hullRecord) then
            v72 = nil;
        else
            v72 = getStaticWallConstraintNormal(p64, p58, p61);
        end;
    elseif v69 then
        v72 = getStaticWallConstraintNormal(p64, p58, p61);
    else
        v72 = nil;
    end;

    local v73;

    if v72 == nil then
        p64 = v71;
        v73 = p58;
    else
        v73 = ProvenMath.clipVelocity(p58, v72, p61.Overbounce);
    end;

    local v74 = Vector3.new(v73.X, 0, v73.Z) * p59;

    if horizontalMagnitudeSq(v74) <= p61.PositionSnapEpsilon * p61.PositionSnapEpsilon then
        return nil, nil, false;
    end;

    local v75 = p61.MaxStepHeight + p61.PositionSnapEpsilon;
    local v76 = p57 + v74;
    local v77 = v76 + Vector3.new(0, v75, 0);
    local v78 = p60:SupportSweep(v77, v76, p62, p61.WalkableFloor);
    local v79;

    if isWalkableGround(v78, p61) or (not v67 or v72 ~= nil) then
        v79 = v72;
    else
        if p63 == nil or (v78 == nil or v78.hullRecord == p63.hullRecord) then
            v79 = nil;
        else
            v79 = getStaticWallConstraintNormal(v78, p58, p61);
        end;

        if v79 == nil then
            v79 = v72;
        else
            v73 = ProvenMath.clipVelocity(p58, v79, p61.Overbounce);
            v76 = p57 + Vector3.new(v73.X, 0, v73.Z) * p59;
            v77 = v76 + Vector3.new(0, v75, 0);
            p64 = v78;
        end;
    end;

    if not isWalkableGround(v78, p61) and v79 ~= nil then
        v78 = p60:WalkableSupportSweep(v77, v76, p62, p61.WalkableFloor);
    end;

    if not isWalkableGround(v78, p61) then
        return nil, v78, false;
    end;

    local v80 = getTraceGroundNormal(v78);

    if v80 == nil then
        return nil, v78, false;
    end;

    if v69 then
        local hullRecord2 = v78.hullRecord;
        local v81;

        if hullRecord2 == nil then
            v81 = nil;
        else
            v81 = hullRecord2.surfaceVelocity;
        end;

        if v80.Y >= 1 - p61.PositionSnapEpsilon or (hullRecord2 == nil or (isDynamicWallContactRecord(hullRecord2) or v81 ~= nil and v81.Magnitude > p61.PositionSnapEpsilon)) then
            return nil, v78, false;
        end;

        local v82;

        if v78 == nil or (p64 == nil or p64.hullRecord == v78.hullRecord) then
            v82 = nil;
        else
            v82 = getStaticWallConstraintNormal(p64, p58, p61);
        end;

        if v82 == nil then
            return nil, v78, false;
        end;
    elseif v68 then
        local hullRecord2 = v78.hullRecord;
        local Vector3_new_ret = Vector3.new(v80.X, 0, v80.Z);

        if hullRecord2 ~= hullRecord or (getTraceMinkowskiPlaneKind(v78) ~= "sourceFace" or (Vector3_new_ret.Magnitude <= p61.PositionSnapEpsilon or (v70 == nil or v70:Dot(Vector3_new_ret.Unit) < 0.5))) then
            return nil, v78, false;
        end;
    elseif v66:Dot(v80.Unit) < 0.98 then
        return nil, v78, false;
    end;

    local v83 = getResolvedSupportPosition(v78, v77);
    local v84 = v83.Y - p57.Y;

    if v84 < -p61.PositionSnapEpsilon or v75 < v84 then
        return nil, v78, false;
    end;

    if isPointTestBlocked((p60:PointTest(v83, p62))) then
        return nil, v78, false;
    end;

    p56.position = v83;
    p56.velocity = v73;
    p56.collided = p64 ~= nil;
    p56.touchedWall = p64 ~= nil;
    p56.impactTrace = p64 or v78;
    local v85 = v83.X - p57.X;
    local v86 = v83.Z - p57.Z;
    p56.horizontalDistanceSq = v85 * v85 + v86 * v86;
    p56.forwardProgress = p65 == nil and 0 or (v83.X - p57.X) * p65.X + (v83.Z - p57.Z) * p65.Z;

    return p56, v78, v68;
end;

local function stayOnGround(p87: vector, p88: string, p89: any, p90: any) -- Line: 388
    -- upvalues: groundProbeWithRetry (copy), isWalkableGround (copy), getResolvedSupportPosition (copy), GROUND_PROBE_START_BUMP (copy), isPointTestBlocked (copy)
    local v91 = groundProbeWithRetry(p87, p90.MaxStepHeight, p88, p89, p90, true);

    if not isWalkableGround(v91, p90) then
        if v91 and v91.normal.Y < p90.WalkableFloor then
            local Vector3_new_ret = Vector3.new(0, p90.MaxStepHeight, 0);
            local v92 = p89:FloorSupportSweep(p87 + Vector3.new(0, GROUND_PROBE_START_BUMP, 0), p87 - Vector3_new_ret, p88, p90.WalkableFloor);

            if isWalkableGround(v92, p90) then
                local v93 = getResolvedSupportPosition(v92, p87);

                if not isPointTestBlocked(p89:PointTest(v93, p88)) then
                    return v93, v92;
                end;

                if not isPointTestBlocked(p89:PointTest(p87, p88)) then
                    v92.endPos = p87;

                    return p87, v92;
                end;
            end;
        end;

        return p87, nil;
    end;

    local v94 = getResolvedSupportPosition(v91, p87);

    if math.abs(p87.Y - v94.Y) > p90.PositionSnapEpsilon then
        return v94, v91;
    end;

    return p87, v91;
end;

local function stepMove(p95: vector, p96: vector, p97: number, p98: any, p99: any, p100: string, p101: vector?, p102: table?) -- Line: 430
    -- upvalues: horizontalMagnitudeSq (copy), resolveGroundDriveDirection (copy), tryPlayerMove (copy), u2 (copy), u5 (copy), tryWalkableRampSupportMove (copy), u3 (copy), isWalkableGround (copy), getResolvedSupportPosition (copy), isFloorSupportTrace (copy), isPointTestBlocked (copy), u4 (copy)
    local Vector3_new_ret = Vector3.new(p96.X, 0, p96.Z);
    local v103 = horizontalMagnitudeSq(Vector3_new_ret);
    local v104 = resolveGroundDriveDirection(p101, Vector3_new_ret, p99.PositionSnapEpsilon);
    local v105, v106, v107, v108, v109, v110, v111 = tryPlayerMove(p95, p96, p97, p98, p99, p100, false, p102, "ground");
    local v112 = u2;
    v112.position = v105;
    v112.velocity = v106;
    v112.collided = v107;
    v112.touchedWall = v108;
    v112.impactTrace = v109;
    local v113 = v105.X - p95.X;
    local v114 = v105.Z - p95.Z;
    v112.horizontalDistanceSq = v113 * v113 + v114 * v114;
    v112.forwardProgress = v104 == nil and 0 or (v105.X - p95.X) * v104.X + (v105.Z - p95.Z) * v104.Z;
    local v115 = u5;
    v115.choice = v112;
    v115.direct = v112;
    v115.step = nil;
    v115.supportTrace = nil;
    v115.stepVerticalDelta = 0;
    v115.usedStep = false;
    local v116 = nil;
    local v117 = nil;
    local v118, v119;

    if v107 then
        v118, v119 = tryWalkableRampSupportMove(u3, p95, p96, p97, p98, p99, p100, v111 or v109, v110, v104);

        if v118 == nil then
            v119 = v117;
            v118 = v116;
        else
            v115.choice = v118;
            v115.supportTrace = v119;

            if not v118.touchedWall then
                return v115;
            end;
        end;
    else
        v119 = v117;
        v118 = v116;
    end;

    if not v107 then
        return v115;
    end;

    if v103 <= p99.PositionSnapEpsilon * p99.PositionSnapEpsilon then
        return v115;
    end;

    local Vector3_new_ret2 = Vector3.new(0, p99.MaxStepHeight + p99.PositionSnapEpsilon, 0);
    local v120 = true;
    local v121 = p98:Sweep(p95, p95 + Vector3_new_ret2, p100);
    local v122;

    if v121.startSolid or v121.allSolid then
        v122 = p95;
    else
        v122 = v121.endPos;
    end;

    local v123 = nil;
    local v124 = 0;
    local v125 = p99.PositionSnapEpsilon * p99.PositionSnapEpsilon;
    local v126, v127, v128, v129, v130 = tryPlayerMove(v122, Vector3_new_ret, p97, p98, p99, p100, false, p102);
    local v131 = p98:SupportSweep(v126, v126 - Vector3_new_ret2, p100, p99.WalkableFloor);
    local v132;

    if isWalkableGround(v131, p99) or v131.normal.Y >= p99.WalkableFloor then
        v132 = v131;
    else
        v132 = p98:WalkableSupportSweep(v126, v126 - Vector3_new_ret2, p100, p99.WalkableFloor);

        if not isWalkableGround(v132, p99) then
            v132 = v131;
        end;
    end;

    local v133;

    if isWalkableGround(v132, p99) then
        local v134 = getResolvedSupportPosition(v132, v126);
        local v135 = v134.Y - p95.Y;

        if p99.MaxStepHeight + p99.PositionSnapEpsilon < v135 then
            v124 = v135;
            v133 = v132;
        else
            local v136;

            if isFloorSupportTrace(v132) then
                v124 = v135;
                v136 = v134;
                v133 = v132;
            else
                v133 = p98:FloorSupportSweep(v126, v126 - Vector3_new_ret2, p100, p99.WalkableFloor);

                if isWalkableGround(v133, p99) then
                    v136 = getResolvedSupportPosition(v133, v126);
                    v124 = v136.Y - p95.Y;
                    local v137 = v136.Y - v134.Y;

                    if v136.Y + p99.PositionSnapEpsilon < v134.Y then
                        v120 = not isPointTestBlocked(p98:PointTest(v136, p100));
                    end;

                    if v120 and (v124 ~= nil and (v137 ~= nil and v137 >= -0.02)) then
                        if v124 > p99.MaxStepHeight + p99.PositionSnapEpsilon then
                            v124 = v135;
                            v136 = v134;
                            v133 = v132;
                        end;
                    else
                        v124 = v135;
                        v136 = v134;
                        v133 = v132;
                    end;
                else
                    v124 = v135;
                    v136 = v134;
                    v133 = v132;
                end;
            end;

            if not isPointTestBlocked(p98:PointTest(v136, p100)) then
                v123 = u4;
                local Vector3_new_ret3 = Vector3.new(v127.X, p96.Y, v127.Z);
                v123.position = v136;
                v123.velocity = Vector3_new_ret3;
                v123.collided = v128;
                v123.touchedWall = v129;
                v123.impactTrace = v130;
                local v138 = v136.X - p95.X;
                local v139 = v136.Z - p95.Z;
                v123.horizontalDistanceSq = v138 * v138 + v139 * v139;
                v123.forwardProgress = v104 == nil and 0 or (v136.X - p95.X) * v104.X + (v136.Z - p95.Z) * v104.Z;
            end;
        end;
    else
        v133 = v132;
    end;

    if v123 ~= nil then
        v115.step = v123;
        v115.stepVerticalDelta = v124;
        local v140 = v118 or v112;
        local v141;

        if v118 == nil then
            v141 = v123.horizontalDistanceSq + v125 >= v140.horizontalDistanceSq;
        else
            v141 = v123.forwardProgress > v140.forwardProgress + p99.PositionSnapEpsilon;
        end;

        local v142;

        if v118 == nil then
            v142 = false;
        else
            v142 = math.abs(v123.forwardProgress - v140.forwardProgress) <= p99.PositionSnapEpsilon;
        end;

        if v142 then
            v142 = v123.horizontalDistanceSq + v125 >= v140.horizontalDistanceSq;
        end;

        if v141 or v142 then
            v115.choice = v123;
            v115.usedStep = true;
            v115.supportTrace = v133;
        end;
    end;

    if v118 ~= nil and not v115.usedStep then
        v115.choice = v118;
        v115.supportTrace = v119;
    end;

    return v115;
end;

v1.groundProbeWithRetry = groundProbeWithRetry;

function v1.walkMove(p143: vector, p144: vector, p145: vector, p146: number, p147: number, p148: number, p149: any, p150: any, p151: string, p152: vector, p153: number, p154: number, p155: table?) -- Line: 621
    -- upvalues: ProvenMath (copy), vector (copy), line (copy), clampHorizontal (copy), stepMove (copy), supportTraceMatchesPosition (copy), stayOnGround (copy)
    local v156 = ProvenMath.applyFriction(p144 - p152, p148, p150.Friction, p150.StopSpeed, p153);
    vector("proven.walkMove.friction", p143, v156, p146, 0, line(1));

    if p150.PositionSnapEpsilon < p146 then
        v156 = ProvenMath.accelerate(v156, p145, p146, p150.GroundAccelerate, p148, p153, p154);
        vector("proven.walkMove.accelerate", p143, v156, p146, 0, line(1));
    end;

    local v157 = clampHorizontal(v156, p147);
    vector("proven.walkMove.speedClamp", p143, v157, p147, 0, line(1));
    local v158 = v157 + p152;

    if p150.PositionSnapEpsilon >= p146 then
        p145 = nil;
    end;

    local v159 = stepMove(p143, v158, p148, p149, p150, p151, p145, p155);
    local position = v159.choice.position;
    vector("proven.walkMove.stepChoice", v159.choice.position, v159.choice.velocity, v159.stepVerticalDelta, v159.usedStep and 1 or 0, line(1));
    local supportTrace = v159.supportTrace;

    if supportTrace == nil or (supportTrace.startSolid or (supportTrace.allSolid or not supportTraceMatchesPosition(supportTrace, position, p150))) then
        position, supportTrace = stayOnGround(position, p151, p149, p150);
    end;

    local velocity = v159.choice.velocity;
    vector("proven.walkMove.stayOnGround", position, velocity, 0, 0, line(1));

    return position, velocity, velocity - p152, v158, v159, supportTrace or v159.supportTrace, v159.choice.collided, v159.choice.touchedWall, v159.choice.impactTrace;
end;

function v1.getGroundSupportVelocity(p160: vector, p161: string, p162: any, p163: any) -- Line: 707
    -- upvalues: groundProbeWithRetry (copy), isWalkableGround (copy), getTraceSurfaceVelocity (copy)
    local GetRetainedGroundSurfaceVelocity = p162.GetRetainedGroundSurfaceVelocity;

    if GetRetainedGroundSurfaceVelocity ~= nil then
        local v164 = GetRetainedGroundSurfaceVelocity(p162);

        if typeof(v164) == "Vector3" then
            return v164, nil;
        end;
    end;

    local math_max_ret = math.max(p163.GroundProbeDistance, p163.MaxStepHeight);

    if p162:HasUniformGroundSurfaces(p160, p161, math_max_ret) then
        return Vector3.new(0, 0, 0), nil;
    end;

    local v165 = groundProbeWithRetry(p160, math_max_ret, p161, p162, p163, true);

    if isWalkableGround(v165, p163) then
        return getTraceSurfaceVelocity(v165), v165;
    end;

    return Vector3.new(0, 0, 0), nil;
end;

return table.freeze(v1);