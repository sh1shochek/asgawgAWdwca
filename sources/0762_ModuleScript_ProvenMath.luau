-- Decompiled with Potassium's decompiler.

local v1 = {};
local SpeedProfile = require(script.Parent.Parent.SpeedProfile);
local u2 = 0.03125 * SpeedProfile.HammerUnitToStud;
local DefaultBaseSpeed = SpeedProfile.DefaultBaseSpeed;

function v1.approach(p3: number, p4: number, p5: number) -- Line: 10
    if p4 < p3 then
        return math.min(p4 + p5, p3);
    end;

    return math.max(p4 - p5, p3);
end;

function v1.flatten(p6: vector) -- Line: 17
    return Vector3.new(p6.X, 0, p6.Z);
end;

function v1.clipVelocity(p7: vector, p8: vector, p9: number?) -- Line: 21
    -- upvalues: u2 (copy)
    local v10 = p7 - p8 * (p7:Dot(p8) * (p9 or 1));
    local v11 = v10:Dot(p8);

    if v11 <= 0 then
        v10 = v10 - p8 * math.min(v11, -u2);
    end;

    return v10;
end;

function v1.moveVectorToWorld(p12, p13: number) -- Line: 33
    local math_sin_ret = math.sin(p13);
    local math_cos_ret = math.cos(p13);
    local v14 = -p12.Y;
    local X = p12.X;
    local v15 = math_cos_ret * X - math_sin_ret * v14;
    local v16 = -math_sin_ret * X - math_cos_ret * v14;
    local v17 = v15 * v15 + v16 * v16;

    if v17 > 1 then
        local v18 = 1 / math.sqrt(v17);
        v15 = v15 * v18;
        v16 = v16 * v18;
    end;

    return Vector3.new(v15, 0, v16);
end;

function v1.applyFriction(p19: vector, p20: number, p21: number, p22: number, p23: number) -- Line: 52
    local X = p19.X;
    local Z = p19.Z;
    local v24 = X * X + Z * Z;

    if v24 <= 0 then
        return p19;
    end;

    local math_sqrt_ret = math.sqrt(v24);

    if math_sqrt_ret <= 0 then
        return p19;
    end;

    local v25 = math_sqrt_ret - math.max(math_sqrt_ret, p22) * p21 * p23 * p20;
    local math_max_ret = math.max(v25, 0);

    if math_max_ret ~= math_sqrt_ret and math_sqrt_ret > 0 then
        local v26 = math_max_ret / math_sqrt_ret;
        X = X * v26;
        Z = Z * v26;
    end;

    return Vector3.new(X, p19.Y, Z);
end;

function v1.accelerate(p27: vector, p28: vector, p29: number, p30: number, p31: number, p32: number, p33: number) -- Line: 84
    -- upvalues: DefaultBaseSpeed (copy)
    local v34 = p29 - p27:Dot(p28);

    if v34 <= 0 then
        return p27;
    end;

    local v35 = math.max(DefaultBaseSpeed, p29) * p33;

    return p27 + p28 * math.min(p30 * p31 * v35 * p32, v34);
end;

function v1.airAccelerate(p36: vector, p37: vector, p38: number, p39: number, p40: number, p41: number, p42: number) -- Line: 104
    local v43 = math.min(p38, p40) - p36:Dot(p37);

    if v43 <= 0 then
        return p36;
    end;

    local v44 = p39 * p38 * p41 * p42;

    if v43 >= v44 then
        v43 = v44;
    end;

    return p36 + p37 * v43;
end;

function v1.legacyBunnyHopAirAccelerate(p45: vector, p46: vector, p47: number, p48: number, p49: number, p50: number) -- Line: 129
    local math_min_ret = math.min(p47, p49);
    local v51 = math_min_ret - p45:Dot(p46);

    if v51 <= 0 then
        return p45;
    end;

    return p45 + p46 * math.min(p48 * math_min_ret * p50, v51);
end;

function v1.clampHorizontal(p52: vector, p53: number) -- Line: 149
    local X = p52.X;
    local Z = p52.Z;
    local v54 = X * X + Z * Z;

    if p53 * p53 < v54 and v54 > 0 then
        local v55 = p53 / math.sqrt(v54);
        X = X * v55;
        Z = Z * v55;
    end;

    return Vector3.new(X, p52.Y, Z);
end;

function v1.horizontalMagnitude(p56: vector) -- Line: 161
    return math.sqrt(p56.X * p56.X + p56.Z * p56.Z);
end;

function v1.magnitudeSq(p57: vector) -- Line: 165
    return p57.X * p57.X + p57.Y * p57.Y + p57.Z * p57.Z;
end;

function v1.horizontalMagnitudeSq(p58: vector) -- Line: 169
    return p58.X * p58.X + p58.Z * p58.Z;
end;

return v1;