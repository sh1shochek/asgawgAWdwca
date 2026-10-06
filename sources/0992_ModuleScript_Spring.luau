-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local math_exp = math.exp;
local math_sin = math.sin;
local math_cos = math.cos;
local math_sqrt = math.sqrt;

function u1.new(p2, p3, p4) -- Line: 21
    -- upvalues: u1 (copy)
    local v5 = type(p2) == "number";
    assert(v5, "damping ratio must be a number");
    local v6 = type(p3) == "number";
    assert(v6, "frequency must be a number");
    assert(p2 * p3 >= 0, "Spring does not converge");

    return setmetatable({
        d = p2,
        f = p3 * 0.2,
        g = p4,
        p = p4,
        v = p4 * 0
    }, u1);
end;

function u1.setDampingRatio(p7: table, p8: number) -- Line: 35
    p7.d = p8;
end;

function u1.setFrequency(p9: table, p10: number) -- Line: 39
    p9.f = p10 * 0.2;
end;

function u1.setGoal(p11, p12) -- Line: 43
    p11.g = p12;
end;

function u1.getGoal(p13) -- Line: 47
    return p13.g;
end;

function u1.setPosition(p14, p15) -- Line: 51
    p14.p = p15;
end;

function u1.getPosition(p16) -- Line: 55
    return p16.p;
end;

function u1.getVelocity(p17) -- Line: 59
    return p17.v / 0.2;
end;

function u1.impulse(p18, p19) -- Line: 63
    p18.v = p18.v + p19 * 0.2;
end;

function u1.reset(p20, p21) -- Line: 67
    p20.g = p21;
    p20.p = p20.g;
    p20.v = p20.g * 0;
end;

function u1.update(p22, p23) -- Line: 73
    -- upvalues: math_exp (copy), math_sqrt (copy), math_cos (copy), math_sin (copy)
    local d = p22.d;
    local v24 = p22.f * 2 * 3.141592653589793;
    local g = p22.g;
    local v = p22.v;
    local v25 = p22.p - g;
    local v26 = math_exp(-d * v24 * p23);
    local v27, v28;

    if d == 1 then
        v27 = (v25 * (1 + v24 * p23) + v * p23) * v26 + g;
        v28 = (v * (1 - v24 * p23) - v25 * (v24 * v24 * p23)) * v26;
    elseif d < 1 then
        local v29 = math_sqrt(1 - d * d);
        local v30 = math_cos(v24 * v29 * p23);
        local v31 = math_sin(v24 * v29 * p23);
        local v32;

        if v29 > 0.0001 then
            v32 = v31 / v29;
        else
            local v33 = p23 * v24;
            v32 = v33 + (v33 * v33 * (v29 * v29) * (v29 * v29) / 20 - v29 * v29) * (v33 * v33 * v33) / 6;
        end;

        local v34;

        if v24 * v29 > 0.0001 then
            v34 = v31 / (v24 * v29);
        else
            local v35 = v24 * v29;
            v34 = p23 + (p23 * p23 * (v35 * v35) * (v35 * v35) / 20 - v35 * v35) * (p23 * p23 * p23) / 6;
        end;

        v27 = (v25 * (v30 + d * v32) + v * v34) * v26 + g;
        v28 = (v * (v30 - v32 * d) - v25 * (v32 * v24)) * v26;
    else
        local v36 = math_sqrt(d * d - 1);
        local v37 = -v24 * (d - v36);
        local v38 = -v24 * (d + v36);
        local v39 = (v - v25 * v37) / (2 * v24 * v36);
        local v40 = (v25 - v39) * math_exp(v37 * p23);
        local v41 = v39 * math_exp(v38 * p23);
        v27 = v40 + v41 + g;
        v28 = v40 * v37 + v41 * v38;
    end;

    p22.p = v27;
    p22.v = v28;

    return v27;
end;

return u1;