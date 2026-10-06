-- Decompiled with Potassium's decompiler.

local Config = require(script.Parent.Config);
local ProvenMath = require(script.Parent.ProvenMath);
require(script.Parent.Types);
local u1 = {};

local function endpoint(p2: vector, p3: vector, p4: number) -- Line: 18
    return p2:Lerp(p3, (math.clamp(p4, 0, 1)));
end;

local function normalizedOrUp(p5: vector) -- Line: 22
    local Magnitude = p5.Magnitude;

    return Magnitude <= 0 and Vector3.new(0, 1, 0) or p5 / Magnitude;
end;

local function isWall(p6: vector, p7: number) -- Line: 27
    return math.abs(p6.Y) < p7;
end;

local function validateTimeInterval(p8: number, p9: number) -- Line: 31
    local v10;

    if p8 == p8 and (p9 == p9 and (p8 >= 0 and p8 <= p9)) then
        v10 = p9 <= 1;
    else
        v10 = false;
    end;

    assert(v10, "movement collision time interval must be normalized and ordered");
end;

local function appendPlane(p11: table, p12: vector, p13: number) -- Line: 42
    for _, v in p11 do
        if v:Dot(p12) > 0.999 then
            return true;
        end;
    end;

    if p13 <= #p11 then
        return false;
    end;

    table.insert(p11, p12);

    return true;
end;

local function clearsEveryPlane(p14: vector, p15: table, p16: number) -- Line: 56
    for _, v in p15 do
        if p14:Dot(v) < -p16 then
            return false;
        end;
    end;

    return true;
end;

local function resolvePlanes(p17: vector, p18: table, p19: number) -- Line: 65
    -- upvalues: ProvenMath (copy)
    for _, v in p18 do
        local v20 = ProvenMath.clipVelocity(p17, v);
        local v21 = true;

        for _, v2 in p18 do
            if v20:Dot(v2) < -p19 then
                v21 = false;
                break;
            end;
        end;

        if v21 then
            return v20;
        end;
    end;

    if #p18 == 2 then
        local v22 = p18[1]:Cross(p18[2]);
        local Magnitude = v22.Magnitude;

        if p19 < Magnitude then
            local v23 = v22 / Magnitude;
            local v24 = v23 * p17:Dot(v23);
            local v25 = true;

            for _, v in p18 do
                if v24:Dot(v) < -p19 then
                    v25 = false;
                    break;
                end;
            end;

            if v25 then
                return v24;
            end;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u1.slideMove(p26: vector, p27: vector, p28: number, p29: any, p30: any, p31: any, p32: number, p33: number, p34: any, p35: boolean?) -- Line: 88
    -- upvalues: Config (copy), appendPlane (copy), resolvePlanes (copy)
    local v36;

    if p32 == p32 and (p33 == p33 and (p32 >= 0 and p32 <= p33)) then
        v36 = p33 <= 1;
    else
        v36 = false;
    end;

    assert(v36, "movement collision time interval must be normalized and ordered");
    local v37 = p34 or Config.Default;
    local v38 = p27;
    local v39 = 0;
    local v40 = Vector3.new(0, 0, 0);
    local v41 = false;
    local v42 = false;
    local v43 = {};

    for i = 1, v37.MaxBumps do
        if p28 <= 0 then
            break;
        end;

        local v44 = p26 + p27 * p28;
        local v45;

        if p35 then
            v45 = p30:SweepWithFloorSupport(p26, v44, p29, p31, p32, p33);
        else
            v45 = p30:Sweep(p26, v44, p29, p31, p32, p33);
        end;

        if p35 and (v45.StartSolid or v45.AllSolid) and p27:Dot(v45.Normal) > v37.PositionSnapEpsilon then
            v45 = p30:Sweep(p26, v44, p29, p31, p32, p33);
        end;

        v42 = v42 or v45.StartSolid;

        if v45.AllSolid then
            p27 = Vector3.new(0, 0, 0);
            v41 = true;
            break;
        end;

        local math_clamp_ret = math.clamp(v45.Fraction, 0, 1);
        local v46 = math_clamp_ret > 0 and math_clamp_ret < 0.0001 and 0 or math_clamp_ret;
        v39 = v39 + v46;
        p32 = p32 + (p33 - p32) * v46;

        if v46 > 0 then
            p26 = p26:Lerp(v44, (math.clamp(v46, 0, 1)));
            table.clear(v43);
            v38 = p27;
        end;

        if v46 >= 1 then
            break;
        end;

        v41 = true;
        p28 = p28 * (1 - v46);
        local Normal = v45.Normal;
        local Magnitude = Normal.Magnitude;
        local v47 = Magnitude <= 0 and Vector3.new(0, 1, 0) or Normal / Magnitude;

        if v37.WalkableFloor > math.abs(v47.Y) then
            v40 = v47;
        end;

        if not appendPlane(v43, v47, v37.MaxClipPlanes) then
            p27 = Vector3.new(0, 0, 0);
            break;
        end;

        p27 = resolvePlanes(v38, v43, v37.PlaneEpsilon);

        if p27:Dot(v38) <= 0 then
            p27 = Vector3.new(0, 0, 0);
            break;
        end;

        local _ = i;
    end;

    local v48 = v39 == 0 and Vector3.new(0, 0, 0) or p27;

    return {
        Position = p26,
        Velocity = v48.Magnitude <= v37.VelocityEpsilon and Vector3.new(0, 0, 0) or v48,
        WallNormal = v40,
        Blocked = v41,
        StartSolid = v42,
        TimeFraction = p32
    };
end;

function u1.slideDisplacement(p49: vector, p50: vector, p51: any, p52: any, p53: any, p54: number, p55: number, p56: any) -- Line: 204
    -- upvalues: u1 (copy)
    return u1.slideMove(p49, p50, 1, p51, p52, p53, p54, p55, p56);
end;

return table.freeze(u1);