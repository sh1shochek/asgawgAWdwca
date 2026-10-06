-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.ProvenTypes);
local ProvenMath = require(script.Parent.Parent.ProvenMath);
local Trace = require(script.Parent.Trace);
local TraceRules = require(script.Parent.TraceRules);
local SlideMove = require(script.Parent.SlideMove);
local v1 = {};
local line = Trace.line;
local vector = Trace.vector;
local tryPlayerMove = SlideMove.tryPlayerMove;
local getTraceSurfaceVelocity = TraceRules.getTraceSurfaceVelocity;
local isWalkableGround = TraceRules.isWalkableGround;
local WALL_CONTACT_SEPARATION = SlideMove.WALL_CONTACT_SEPARATION;

local function getViewBasis(p2: number, p3: number?) -- Line: 31
    local v4 = typeof(p3) ~= "number" and 0 or math.clamp(p3, -1, 1);
    local v5 = -math.sin(p2);
    local v6 = -math.cos(p2);
    local Vector3_new_ret = Vector3.new(v5, 0, v6);
    local math_max_ret = math.max(0, 1 - v4 * v4);
    local math_sqrt_ret = math.sqrt(math_max_ret);
    local Vector3_new_ret2 = Vector3.new(Vector3_new_ret.X * math_sqrt_ret, v4, Vector3_new_ret.Z * math_sqrt_ret);

    if Vector3_new_ret2.Magnitude <= 1e-6 then
        Vector3_new_ret2 = Vector3_new_ret;
    end;

    local math_cos_ret = math.cos(p2);
    local v7 = -math.sin(p2);
    local Vector3_new_ret3 = Vector3.new(math_cos_ret, 0, v7);

    return Vector3_new_ret2.Unit, (Vector3_new_ret3.Magnitude <= 1e-6 and Vector3.new(1, 0, 0) or Vector3_new_ret3).Unit;
end;

local function computeLadderVelocity(p8: any, p9: vector, p10: boolean, p11: any) -- Line: 71
    -- upvalues: getViewBasis (copy), vector (copy), line (copy)
    local LadderSpeed = p11.LadderSpeed;

    if p8.Duck or p8.Walk then
        LadderSpeed = LadderSpeed * p11.LadderClimbModifier;
    end;

    local math_clamp_ret = math.clamp(-p8.MoveVector.Y, -1, 1);
    local math_clamp_ret2 = math.clamp(p8.MoveVector.X, -1, 1);
    local v12 = math_clamp_ret * LadderSpeed;
    local v13 = math_clamp_ret2 * LadderSpeed;

    if math.abs(v12) <= 1e-6 and math.abs(v13) <= 1e-6 then
        return Vector3.new(0, 0, 0);
    end;

    local v14, v15 = getViewBasis(p8.LookYaw, p8.VerticalLook);
    local v16 = v14 * v12 + v15 * v13;
    local v17 = (Vector3.new(0, 1, 0)):Cross(p9);
    local v18 = v17.Magnitude <= 1e-6 and Vector3.new(1, 0, 0) or v17.Unit;
    local v19 = p9:Cross(v18);
    local v20 = v16:Dot(p9);
    local v21 = p9 * v20;
    local v22 = v16 - v21;
    local v23 = v19:Dot(v22);
    local v24 = v18:Dot(v22);
    local v25 = v18 * v24 + v21;

    if v25.Magnitude > 1e-6 and v25.Unit:Dot(p9) < p11.LadderDampenAngle then
        v22 = v19 * v23 + v18 * (p11.LadderDampen * v24);
    end;

    local v26 = (v22 - v19 * v20) * p11.LadderLateralScale;

    if p10 and v20 > 0 then
        v26 = v26 + p9 * p11.LadderSpeed;
    end;

    vector("proven.ladderVelocity", Vector3.new(0, 0, 0), v26, v20, 0, line(1));

    return v26;
end;

local function isClimbableTrace(p27, p28) -- Line: 132
    local v29;

    if p27 then
        v29 = p27.hullRecord;
    else
        v29 = p27;
    end;

    if v29 == nil or v29.climbable ~= true then
        return false;
    end;

    return p27.normal.Y < p28.WalkableFloor;
end;

local function considerLadderTrace(p30: any, p31: vector, p32: any, p33: any) -- Line: 141
    local v34;

    if p32 then
        v34 = p32.hullRecord;
    else
        v34 = p32;
    end;

    local v35;

    if v34 == nil or v34.climbable ~= true then
        v35 = false;
    else
        v35 = p32.normal.Y < p33.WalkableFloor;
    end;

    if not v35 then
        return p30;
    end;

    if p30 == nil then
        return p32;
    end;

    local Magnitude = (p30.endPos - p31).Magnitude;
    local Magnitude2 = (p32.endPos - p31).Magnitude;

    if Magnitude2 + p33.PositionSnapEpsilon < Magnitude then
        return p32;
    end;

    if math.abs(Magnitude2 - Magnitude) <= p33.PositionSnapEpsilon then
        local v36;

        if p30 == nil then
            v36 = Vector3.new(0, 0, 1);
        else
            local Vector3_new_ret = Vector3.new(p30.normal.X, 0, p30.normal.Z);
            v36 = Vector3_new_ret.Magnitude <= 1e-6 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;
        end;

        local v37;

        if p32 == nil then
            v37 = Vector3.new(0, 0, 1);
        else
            local Vector3_new_ret = Vector3.new(p32.normal.X, 0, p32.normal.Z);
            v37 = Vector3_new_ret.Magnitude <= 1e-6 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;
        end;

        if v37.Y < v36.Y then
            return p32;
        end;
    end;

    return p30;
end;

local function findLadderTrace(u38: vector, u39: string, u40: any, u41: any, p42: vector?, p43: vector?, u44: number, p45: boolean) -- Line: 171
    -- upvalues: considerLadderTrace (copy)
    if not u40:HasClimbableNear(u38, u39, u44 + u41.PositionSnapEpsilon) then
        return nil;
    end;

    local u46 = nil;

    local function traceDirection(p47: vector) -- Line: 187
        -- upvalues: u40 (copy), u38 (copy), u44 (copy), u39 (copy), u46 (ref), considerLadderTrace (ref), u41 (copy)
        u46 = considerLadderTrace(u46, u38, u40:Sweep(u38, u38 + p47 * u44, u39), u41);
    end;

    if typeof(p43) == "Vector3" then
        local Vector3_new_ret = Vector3.new(p43.X, 0, p43.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            u46 = considerLadderTrace(u46, u38, u40:Sweep(u38, u38 - Vector3_new_ret.Unit * u44, u39), u41);

            if u46 ~= nil then
                return u46;
            end;
        end;
    end;

    if typeof(p42) == "Vector3" then
        local Vector3_new_ret = Vector3.new(p42.X, 0, p42.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            u46 = considerLadderTrace(u46, u38, u40:Sweep(u38, u38 + Vector3_new_ret.Unit * u44, u39), u41);

            return u46;
        end;
    end;

    if p45 then
        return nil;
    end;

    u46 = considerLadderTrace(u46, u38, u40:Sweep(u38, u38 + Vector3.new(1, 0, 0) * u44, u39), u41);
    u46 = considerLadderTrace(u46, u38, u40:Sweep(u38, u38 + Vector3.new(-1, -0, -0) * u44, u39), u41);
    u46 = considerLadderTrace(u46, u38, u40:Sweep(u38, u38 + Vector3.new(0, 0, 1) * u44, u39), u41);
    u46 = considerLadderTrace(u46, u38, u40:Sweep(u38, u38 + Vector3.new(-0, -0, -1) * u44, u39), u41);

    return u46;
end;

function v1.getLadderNormal(p48: any, p49: vector?) -- Line: 52
    if p48 ~= nil then
        local Vector3_new_ret = Vector3.new(p48.normal.X, 0, p48.normal.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            return Vector3_new_ret.Unit;
        end;
    end;

    if typeof(p49) == "Vector3" then
        local Vector3_new_ret = Vector3.new(p49.X, 0, p49.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            return Vector3_new_ret.Unit;
        end;
    end;

    return Vector3.new(0, 0, 1);
end;

v1.findLadderTrace = findLadderTrace;

function v1.simulateLadderMove(p50: vector, p51: any, p52: number, p53: any, p54: any, p55: string, p56: any, p57: vector?, p58: boolean, p59: table?) -- Line: 225
    -- upvalues: getTraceSurfaceVelocity (copy), computeLadderVelocity (copy), tryPlayerMove (copy), isWalkableGround (copy), findLadderTrace (copy), ProvenMath (copy), WALL_CONTACT_SEPARATION (copy)
    local v60, v61;

    if p56 == nil then
        if typeof(p57) == "Vector3" then
            v60 = Vector3.new(p57.X, 0, p57.Z);
            v61 = v60.Magnitude <= 1e-6 and Vector3.new(0, 0, 1) or v60.Unit;
        else
            v61 = Vector3.new(0, 0, 1);
        end;
    else
        local Vector3_new_ret = Vector3.new(p56.normal.X, 0, p56.normal.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            v61 = Vector3_new_ret.Unit;
        elseif typeof(p57) == "Vector3" then
            v60 = Vector3.new(p57.X, 0, p57.Z);
            v61 = v60.Magnitude <= 1e-6 and Vector3.new(0, 0, 1) or v60.Unit;
        else
            v61 = Vector3.new(0, 0, 1);
        end;
    end;

    local v62 = getTraceSurfaceVelocity(p56);
    local v63 = computeLadderVelocity(p51, v61, p58, p54);
    local v64 = v63.Y < -p54.PositionSnapEpsilon;
    local v65, v66, _, v67, v68 = tryPlayerMove(p50, v63 + v62, p52, p53, p54, p55, v64, p59);

    if v64 and isWalkableGround(v68, p54) then
        return {
            contactTrace = nil,
            detached = true,
            position = v65,
            velocity = v66,
            impactTrace = v68,
            touchedWall = v67
        };
    end;

    local v69 = findLadderTrace(v65, p55, p53, p54, ProvenMath.flatten(v66), v61, p54.LadderDetachDistance, false);

    if v69 == nil then
        return {
            contactTrace = nil,
            detached = true,
            position = v65,
            velocity = v66,
            impactTrace = v68,
            touchedWall = v67
        };
    end;

    local v70, v71;

    if v69 == nil then
        if typeof(v61) == "Vector3" then
            v70 = Vector3.new(v61.X, 0, v61.Z);
            v71 = v70.Magnitude <= 1e-6 and Vector3.new(0, 0, 1) or v70.Unit;
        else
            v71 = Vector3.new(0, 0, 1);
        end;
    else
        local Vector3_new_ret = Vector3.new(v69.normal.X, 0, v69.normal.Z);

        if Vector3_new_ret.Magnitude > 1e-6 then
            v71 = Vector3_new_ret.Unit;
        elseif typeof(v61) == "Vector3" then
            v70 = Vector3.new(v61.X, 0, v61.Z);
            v71 = v70.Magnitude <= 1e-6 and Vector3.new(0, 0, 1) or v70.Unit;
        else
            v71 = Vector3.new(0, 0, 1);
        end;
    end;

    local v72 = getTraceSurfaceVelocity(v69);
    local v73 = v66 - v62;
    local v74 = v73:Dot(v71);

    if v74 ~= 0 then
        v73 = v73 - v71 * v74;
    end;

    return {
        detached = false,
        position = v69.endPos + v71 * math.max(p54.PositionSnapEpsilon, WALL_CONTACT_SEPARATION),
        velocity = v73 + v72,
        contactTrace = v69,
        impactTrace = v68 or v69,
        touchedWall = v67
    };
end;

return table.freeze(v1);