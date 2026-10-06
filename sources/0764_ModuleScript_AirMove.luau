-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.ProvenTypes);
local ProvenMath = require(script.Parent.Parent.ProvenMath);
local Trace = require(script.Parent.Trace);
local TraceRules = require(script.Parent.TraceRules);
local SlideMove = require(script.Parent.SlideMove);
local Duck = require(script.Parent.Duck);
local v1 = {};
local line = Trace.line;
local vector = Trace.vector;
local clampHorizontal = ProvenMath.clampHorizontal;
local tryPlayerMove = SlideMove.tryPlayerMove;
local getUncrouchClearance = Duck.getUncrouchClearance;
local GROUND_PROBE_START_BUMP = TraceRules.GROUND_PROBE_START_BUMP;
local isPointTestBlocked = TraceRules.isPointTestBlocked;
local getTraceClipNormal = TraceRules.getTraceClipNormal;
local isDynamicPlayerSupportTrace = TraceRules.isDynamicPlayerSupportTrace;
local getResolvedSupportPosition = TraceRules.getResolvedSupportPosition;
local isWalkableGround = TraceRules.isWalkableGround;

local function tryAirLedgeAssist(p2: vector, p3: vector, p4: number, p5: any, p6: any, p7: string, p8: boolean, p9: vector, p10: vector, p11: boolean, p12: any, p13: table?) -- Line: 29
    -- upvalues: getTraceClipNormal (copy), isPointTestBlocked (copy), tryPlayerMove (copy), GROUND_PROBE_START_BUMP (copy), isWalkableGround (copy), isDynamicPlayerSupportTrace (copy), getResolvedSupportPosition (copy), getUncrouchClearance (copy)
    local AutoJumpLedgeAssistHeight = p6.AutoJumpLedgeAssistHeight;
    local AutoJumpLedgeAssistLiftSpeed = p6.AutoJumpLedgeAssistLiftSpeed;

    if AutoJumpLedgeAssistHeight <= p6.PositionSnapEpsilon or (AutoJumpLedgeAssistLiftSpeed <= p6.PositionSnapEpsilon or not (p11 and (p12 ~= nil and p12.normal.Y < p6.WalkableFloor))) then
        return p9, p10, false;
    end;

    if math.abs(p3.Y) > p6.GroundClearVelocity then
        return p9, p10, false;
    end;

    local Vector3_new_ret = Vector3.new(p3.X, 0, p3.Z);

    if Vector3_new_ret.Magnitude <= p6.VelocityEpsilon then
        return p9, p10, false;
    end;

    local v14 = getTraceClipNormal(p12, p6);
    local Vector3_new_ret2 = Vector3.new(v14.X, 0, v14.Z);

    if Vector3_new_ret2.Magnitude <= p6.PositionSnapEpsilon then
        return p9, p10, false;
    end;

    local Unit = Vector3_new_ret2.Unit;

    if Vector3_new_ret:Dot(Unit) >= -p6.VelocityEpsilon then
        return p9, p10, false;
    end;

    local v15 = p5:Sweep(p2, p2 + Vector3.new(0, AutoJumpLedgeAssistHeight, 0), p7);

    if v15.startSolid or (v15.allSolid or (v15.fraction < 1 - p6.PositionSnapEpsilon or isPointTestBlocked(p5:PointTest(v15.endPos, p7)))) then
        return p9, p10, false;
    end;

    local v16 = tryPlayerMove(v15.endPos, p3, p4, p5, p6, p7, false, p13, "risingAir");
    local v17 = -(p9 - p2):Dot(Unit);

    if -(v16 - p2):Dot(Unit) <= v17 + p6.PositionSnapEpsilon then
        return p9, p10, false;
    end;

    local v18 = AutoJumpLedgeAssistHeight + math.abs(p3.Y * p4) + p6.GroundProbeDistance + GROUND_PROBE_START_BUMP;
    local v19 = v16 - Vector3.new(0, v18, 0);
    local v20 = p5:SupportSweep(v16, v19, p7, p6.WalkableFloor);

    if not isWalkableGround(v20, p6) and v20.normal.Y < p6.WalkableFloor then
        v20 = p5:WalkableSupportSweep(v16, v19, p7, p6.WalkableFloor);
    end;

    if not isWalkableGround(v20, p6) or isDynamicPlayerSupportTrace(v20) then
        return p9, p10, false;
    end;

    local v21 = getResolvedSupportPosition(v20, v16);
    local v22 = v21.Y - (p2 + p3 * p4).Y;

    if v22 <= p6.PositionSnapEpsilon or AutoJumpLedgeAssistHeight + p6.PositionSnapEpsilon < v22 then
        return p9, p10, false;
    end;

    if isPointTestBlocked(p5:PointTest(v21, p7)) then
        return p9, p10, false;
    end;

    if p8 and getUncrouchClearance(v21, p5, p6) then
        return p9, p10, false;
    end;

    local v23 = math.clamp(v22 / AutoJumpLedgeAssistHeight, 0, 1) * 0.35 + 0.65;
    local math_min_ret = math.min(v22 + p6.PositionSnapEpsilon, AutoJumpLedgeAssistLiftSpeed * v23 * p4);
    local v24 = p5:Sweep(p9, p9 + Vector3.new(0, math_min_ret, 0), p7);

    if v24.startSolid or (v24.allSolid or (v24.fraction < 1 - p6.PositionSnapEpsilon or isPointTestBlocked(p5:PointTest(v24.endPos, p7)))) then
        return p9, p10, false;
    end;

    local Vector3_new_ret3 = Vector3.new(p3.X, 0, p3.Z);

    return v24.endPos, Vector3_new_ret3, true;
end;

function v1.airMove(p25: vector, p26: vector, p27: vector, p28: number, p29: number, p30: any, p31: any, p32: string, p33: boolean, p34: boolean, p35: number, p36: vector?, p37: table?) -- Line: 157
    -- upvalues: ProvenMath (copy), vector (copy), line (copy), clampHorizontal (copy), tryPlayerMove (copy), tryAirLedgeAssist (copy)
    if p31.PositionSnapEpsilon < p28 then
        if p31.BunnyHopAirAccelerate > 0 and p31.BunnyHopAirSpeedCap > p31.PositionSnapEpsilon then
            p26 = ProvenMath.legacyBunnyHopAirAccelerate(p26, p27, p28, p31.BunnyHopAirAccelerate, p31.BunnyHopAirSpeedCap, p29);
        else
            p26 = ProvenMath.airAccelerate(p26, p27, p28, p31.AirAccelerate, p31.AirSpeedCap, p29, p35);
        end;

        vector("proven.airMove.accelerate", p25, p26, p28, 0, line(1));
    end;

    if p31.BunnyHopSpeedCap > 0 then
        p26 = clampHorizontal(p26, p31.BunnyHopSpeedCap);
    end;

    local v38, v39, v40, v41, v42, v43 = tryPlayerMove(p25, p26, p29, p30, p31, p32, true, p37, "risingAir", p36);

    if p33 then
        v38, v39 = tryAirLedgeAssist(p25, p26, p29, p30, p31, p32, p34, v38, v39, v41, v43, p37);
    end;

    vector("proven.airMove.final", v38, v39, 0, v40 and 1 or 0, line(1));

    return v38, v39, v40, v41, v42;
end;

return table.freeze(v1);