-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.ProvenTypes);
local ProvenMath = require(script.Parent.Parent.ProvenMath);
local TraceRules = require(script.Parent.TraceRules);
local v1 = {};
local GROUND_PROBE_START_BUMP = TraceRules.GROUND_PROBE_START_BUMP;
local getTraceNormalY = TraceRules.getTraceNormalY;

local function getStandingFloorSupportTrace(p2: vector, p3: any, p4: any) -- Line: 17
    return p3:FloorSupportSweep(p2, p2, "standing", p4.WalkableFloor);
end;

local function isStandingFloorSupportBlocked(p5, p6) -- Line: 21
    -- upvalues: GROUND_PROBE_START_BUMP (copy)
    if not (p5 and (p5.startSolid or p5.allSolid)) then
        return false;
    end;

    local floorPenetrationDepth = p5.floorPenetrationDepth;

    return typeof(floorPenetrationDepth) ~= "number" and true or GROUND_PROBE_START_BUMP + p6.PositionSnapEpsilon < floorPenetrationDepth;
end;

local function isUncrouchSweepHardBlocked(p7, p8) -- Line: 34
    -- upvalues: getTraceNormalY (copy)
    if not p7 then
        return false;
    end;

    if p7.startSolid or (p7.allSolid or p7.fraction < 1) then
        return getTraceNormalY(p7, 1) < p8.WalkableFloor;
    end;

    return false;
end;

local function isWalkablePointOverlap(p9, p10) -- Line: 46
    -- upvalues: getTraceNormalY (copy)
    if p9 and (p9.startSolid or p9.allSolid) then
        return getTraceNormalY(p9, 0) >= p10.WalkableFloor;
    end;

    return false;
end;

local function getUncrouchFloorRecoveryDistance(p11, p12) -- Line: 54
    -- upvalues: GROUND_PROBE_START_BUMP (copy)
    if p11 then
        p11 = p11.floorPenetrationDepth;
    end;

    if typeof(p11) == "number" and p11 > 0 then
        return math.clamp(p11 + p12.PositionSnapEpsilon, p12.PositionSnapEpsilon, 0.08);
    end;

    return math.max(GROUND_PROBE_START_BUMP + p12.PositionSnapEpsilon, p12.PositionSnapEpsilon);
end;

local function testUncrouchStandPosition(p13: vector, p14: vector, p15: any, p16: any) -- Line: 67
    -- upvalues: getTraceNormalY (copy), GROUND_PROBE_START_BUMP (copy)
    local v17 = p15:Sweep(p13, p14, "crouching");
    local v18;

    if v17 and (v17.startSolid or (v17.allSolid or v17.fraction < 1)) then
        v18 = getTraceNormalY(v17, 1) < p16.WalkableFloor;
    else
        v18 = false;
    end;

    if v18 then
        return false, v17, nil, nil;
    end;

    local v19 = p15:PointTest(p14, "standing", true);
    local v20 = p15:FloorSupportSweep(p14, p14, "standing", p16.WalkableFloor);

    if not (v19.startSolid or v19.allSolid) then
        local v21;

        if v20 and (v20.startSolid or v20.allSolid) then
            local floorPenetrationDepth = v20.floorPenetrationDepth;
            v21 = typeof(floorPenetrationDepth) ~= "number" and true or GROUND_PROBE_START_BUMP + p16.PositionSnapEpsilon < floorPenetrationDepth;
        else
            v21 = false;
        end;

        if not v21 then
            return true, v17, v19, v20;
        end;
    end;

    return false, v17, v19, v20;
end;

local function getUncrouchClearance(p22: vector, p23: any, p24: any) -- Line: 92
    -- upvalues: getTraceNormalY (copy), GROUND_PROBE_START_BUMP (copy), testUncrouchStandPosition (copy)
    local v25 = p22 + Vector3.new(0, (p24.PlayerSizeStanding.Y - p24.PlayerSizeDucking.Y) * 0.5, 0);
    local v26 = p23:Sweep(p22, v25, "crouching");
    local v27 = p23:PointTest(v25, "standing", true);
    local v28 = p23:FloorSupportSweep(v25, v25, "standing", p24.WalkableFloor);
    local v29;

    if v26 and (v26.startSolid or (v26.allSolid or v26.fraction < 1)) then
        v29 = getTraceNormalY(v26, 1) < p24.WalkableFloor;
    else
        v29 = false;
    end;

    local v30 = v27.startSolid or v27.allSolid;
    local v31;

    if v28 and (v28.startSolid or v28.allSolid) then
        local floorPenetrationDepth = v28.floorPenetrationDepth;
        v31 = typeof(floorPenetrationDepth) ~= "number" and true or GROUND_PROBE_START_BUMP + p24.PositionSnapEpsilon < floorPenetrationDepth;
    else
        v31 = false;
    end;

    if not v29 then
        local v32, v33, v34, v35, v36, v37, v38;

        if v31 then
            if v28 then
                v32 = v28.floorPenetrationDepth;
            else
                v32 = v28;
            end;

            if typeof(v32) == "number" and v32 > 0 then
                v33 = math.clamp(v32 + p24.PositionSnapEpsilon, p24.PositionSnapEpsilon, 0.08);
            else
                v33 = math.max(GROUND_PROBE_START_BUMP + p24.PositionSnapEpsilon, p24.PositionSnapEpsilon);
            end;

            v34 = v25 + Vector3.new(0, v33, 0);
            v35, v36, v37, v38 = testUncrouchStandPosition(p22, v34, p23, p24);

            if v35 then
                return false, v34, v36, v37, v38;
            end;
        else
            local v39;

            if v27 and (v27.startSolid or v27.allSolid) then
                v39 = getTraceNormalY(v27, 0) >= p24.WalkableFloor;
            else
                v39 = false;
            end;

            if v39 then
                if v28 then
                    v32 = v28.floorPenetrationDepth;
                else
                    v32 = v28;
                end;

                if typeof(v32) == "number" and v32 > 0 then
                    v33 = math.clamp(v32 + p24.PositionSnapEpsilon, p24.PositionSnapEpsilon, 0.08);
                else
                    v33 = math.max(GROUND_PROBE_START_BUMP + p24.PositionSnapEpsilon, p24.PositionSnapEpsilon);
                end;

                v34 = v25 + Vector3.new(0, v33, 0);
                v35, v36, v37, v38 = testUncrouchStandPosition(p22, v34, p23, p24);

                if v35 then
                    return false, v34, v36, v37, v38;
                end;
            end;
        end;
    end;

    return v29 or (v30 or v31), v25, v26, v27, v28;
end;

local function getDuckSpeedFromState(p40, p41) -- Line: 120
    return math.clamp(p40.DuckFatigueLevel / 10, 0, p41.DuckSpeedIdeal);
end;

local function setDuckSpeedOnState(p42: any, p43: number, p44: any) -- Line: 125
    p42.DuckFatigueLevel = math.clamp(p43, 0, p44.DuckSpeedIdeal) * 10;
end;

local function getDuckJumpCenterShift(p45: number, p46: any) -- Line: 134
    return (p46.PlayerSizeStanding.Y - p46.PlayerSizeDucking.Y) * p46.DuckJumpOriginShiftFraction * math.clamp(p45, 0, 1);
end;

local function applyDuckJumpCenterShift(p47: any, p48: number, p49: any, p50: any) -- Line: 139
    local v51 = (p50.PlayerSizeStanding.Y - p50.PlayerSizeDucking.Y) * p50.DuckJumpOriginShiftFraction * math.clamp(p48, 0, 1);
    local v52 = (p50.PlayerSizeStanding.Y - p50.PlayerSizeDucking.Y) * p50.DuckJumpOriginShiftFraction * math.clamp(p47.DuckAmount, 0, 1) - v51;

    if math.abs(v52) <= p50.PositionSnapEpsilon then
        return;
    end;

    if v52 < 0 and p47.Velocity.Y <= p50.VelocityEpsilon then
        return;
    end;

    local Position = p47.Position;
    local v53 = Position + Vector3.new(0, v52, 0);
    local v54;

    if v52 < 0 then
        v54 = p49:SweepWithFloorSupport(Position, v53, p47.DuckAmount >= 0.999 and "crouching" or "standing");
    else
        v54 = p49:Sweep(Position, v53, p47.DuckAmount >= 0.999 and "crouching" or "standing");
    end;

    if v54.startSolid or v54.allSolid then
        return;
    end;

    p47.Position = v54.endPos;
end;

local function isAirUncrouchBlocked(p55: vector, p56: number, p57: any, p58: any) -- Line: 170
    -- upvalues: GROUND_PROBE_START_BUMP (copy)
    local v59 = p57:PointTest(p55, "standing", true);

    if v59.startSolid or v59.allSolid then
        return true;
    end;

    local v60 = p57:FloorSupportSweep(p55, p55, "standing", p58.WalkableFloor);
    local v61;

    if v60 and (v60.startSolid or v60.allSolid) then
        local floorPenetrationDepth = v60.floorPenetrationDepth;
        v61 = typeof(floorPenetrationDepth) ~= "number" and true or GROUND_PROBE_START_BUMP + p58.PositionSnapEpsilon < floorPenetrationDepth;
    else
        v61 = false;
    end;

    if v61 then
        return true;
    end;

    local v62 = (p58.PlayerSizeStanding.Y - p58.PlayerSizeDucking.Y) * p58.DuckJumpOriginShiftFraction * 0 - (p58.PlayerSizeStanding.Y - p58.PlayerSizeDucking.Y) * p58.DuckJumpOriginShiftFraction * math.clamp(p56, 0, 1);

    if math.abs(v62) > p58.PositionSnapEpsilon then
        local v63 = p55 + Vector3.new(0, v62, 0);
        local v64 = p57:FloorSupportSweep(p55, v63, "standing", p58.WalkableFloor);

        if v64.startSolid or (v64.allSolid or v64.fraction < 1) then
            return true;
        end;

        local v65 = p57:PointTest(v63, "standing", true);

        if v65.startSolid or v65.allSolid then
            return true;
        end;

        local v66 = p57:FloorSupportSweep(v63, v63, "standing", p58.WalkableFloor);
        local v67;

        if v66 and (v66.startSolid or v66.allSolid) then
            local floorPenetrationDepth = v66.floorPenetrationDepth;
            v67 = typeof(floorPenetrationDepth) ~= "number" and true or GROUND_PROBE_START_BUMP + p58.PositionSnapEpsilon < floorPenetrationDepth;
        else
            v67 = false;
        end;

        if v67 then
            return true;
        end;
    end;

    return false;
end;

function v1.getStance(p68) -- Line: 130
    return p68.DuckAmount >= 0.999 and "crouching" or "standing";
end;

v1.getUncrouchClearance = getUncrouchClearance;

function v1.applyDuckStateForStep(p69: any, p70: any, p71: any, p72: number, p73: any, p74: any) -- Line: 208
    -- upvalues: ProvenMath (copy), isAirUncrouchBlocked (copy), getUncrouchClearance (copy), applyDuckJumpCenterShift (copy)
    local math_clamp_ret = math.clamp(p70.DuckAmount, 0, 1);
    local v75 = p70.DuckHeld == true;
    local v76 = p71.Duck and not v75;
    local v77 = not p71.Duck and v75;
    local v78 = not p70.OnGround and p70.MovementType ~= "Ladder";
    local v79 = math_clamp_ret >= 0.999;
    local v80 = nil;
    local math_max_ret = math.max(p74.TimeToDuckMsecs, 1);
    local math_max_ret2 = math.max(p74.TimeToUnDuckMsecs, 1);
    local math_clamp_ret2 = math.clamp(p70.DuckFatigueLevel / 10, 0, p74.DuckSpeedIdeal);
    local math_max_ret3 = math.max(0, p70.DuckFatigueTimerMsecs - p72 * 1000);
    local v81;

    if math_clamp_ret <= 0 or math_clamp_ret >= 1 then
        v81 = p74.DuckSpeedFastRecoveryRate;
    else
        v81 = p74.DuckSpeedRecoveryRate;
    end;

    local v82 = ProvenMath.approach(p74.DuckSpeedIdeal, math_clamp_ret2, p72 * v81);

    if v76 or v77 then
        v82 = math.max(0, v82 - p74.DuckSpamPenalty);
    end;

    local v83 = p71.Duck == true;

    if v83 and v82 < p74.DuckSpamMinSpeed then
        v83 = false;
    end;

    if v83 and (math_clamp_ret <= 0.75 and math_max_ret3 > 0) then
        v83 = false;
    end;

    p69.DuckAmount = math_clamp_ret;
    p69.IsDucking = false;

    if v83 then
        if v78 then
            p69.DuckAmount = 1;
        elseif math_clamp_ret < 1 then
            p69.DuckAmount = math.min(1, math_clamp_ret + p72 * v82 * p74.DuckSpeedDuckMultiplier);
        end;

        if p69.DuckAmount >= 0.999 then
            p69.DuckAmount = 1;
            p69.IsDucking = false;
        elseif math_clamp_ret < p69.DuckAmount then
            p69.IsDucking = true;
        end;
    else
        local v84 = false;

        if math_clamp_ret > 0 then
            if v79 and v78 then
                if isAirUncrouchBlocked(p69.Position, math_clamp_ret, p73, p74) then
                    p69.DuckAmount = 1;
                    p69.IsDucking = false;
                    v84 = true;
                end;
            elseif v79 then
                local v85, v86 = getUncrouchClearance(p69.Position, p73, p74);

                if v85 then
                    p69.DuckAmount = 1;
                    p69.IsDucking = false;
                    v84 = true;
                else
                    v80 = v86;
                end;
            end;

            if not v84 then
                if v78 then
                    p69.DuckAmount = 0;
                else
                    local v87 = math_clamp_ret - p72 * math.max(p74.DuckSpeedUnduckMinimum, v82);
                    p69.DuckAmount = math.max(0, v87);
                end;

                p69.IsDucking = p69.DuckAmount > 0;
            end;
        end;
    end;

    if math_clamp_ret < 1 and p69.DuckAmount >= 1 then
        math_max_ret3 = math.max(math_max_ret3, p74.TimeBetweenDucksMsecs);
    end;

    p69.DuckFatigueTimerMsecs = math_max_ret3;
    p69.DuckFatigueLevel = math.clamp(v82, 0, p74.DuckSpeedIdeal) * 10;
    local v88;

    if v83 then
        v88 = (1 - p69.DuckAmount) * math_max_ret;
    else
        v88 = p69.DuckAmount * math_max_ret2;
    end;

    p69.DuckTimeMsecs = v88;
    local v89 = p70.DuckAmount >= 0.999 and "crouching" or "standing";
    local v90 = p69.DuckAmount >= 0.999 and "crouching" or "standing";

    if v78 then
        applyDuckJumpCenterShift(p69, math_clamp_ret, p73, p74);
    end;

    if p70.OnGround and v89 ~= v90 then
        local v91 = (p74.PlayerSizeStanding.Y - p74.PlayerSizeDucking.Y) * 0.5;

        if v90 == "crouching" then
            p69.Position = p69.Position - Vector3.new(0, v91, 0);

            return;
        end;

        p69.Position = assert(v80, "grounded uncrouch requires clearance");
    end;
end;

return table.freeze(v1);