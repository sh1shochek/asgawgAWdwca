-- ReplicatedStorage.Shared.Managers.SoundManager.Attenuation
-- Script path: ReplicatedStorage.Shared.Managers.SoundManager.Attenuation
-- Decompile time: 11.65 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};

local function Gain(p2: number, p3: number) -- Line: 33
    local v4 = p3 * (10 ^ ((60 - p2) / 20) / 36) * 10 ^ (p3 / 1200 * 4 / 20);
    local v5 = v4 <= 0.1 and 10 or 1 / v4;

    if v5 > 0.5 then
        local math_min_ret = math.min(p2, 140);
        local v6 = math_min_ret <= 90 and 2.5 or (math_min_ret - 90) / 50 * -1.7 + 2.5;
        v5 = 1 - 1 / (-1 / (0.5 ^ v6 * -0.5) * v5 ^ v6);
    end;

    if v5 < 0.01 then
        v5 = math.max((2 - v4 * 0.01) * 0.01, 0);
    end;

    return v5;
end;

local u7 = {};

function u1.Curve(p8: number) -- Line: 65
    -- upvalues: u7 (copy), Gain (copy)
    local v9 = u7[p8];

    if v9 then
        return v9;
    end;

    local v10 = 1;
    local v11 = { 1 };

    for i = 1, 32 do
        local v12 = Gain(p8, v10 * 14.40922190201729);
        v11[v10] = v12;

        if v12 <= 0 then
            break;
        end;

        v10 = v10 * 1.25;
        local _ = i;
    end;

    v11[v10] = v11[v10] or 0;
    u7[p8] = v11;

    return v11;
end;

local u13 = {};

local function GetDistances(p14) -- Line: 98
    -- upvalues: u13 (copy), u1 (copy)
    local v15 = u13[p14];

    if not v15 then
        v15 = {};

        for i in u1.Curve(p14) do
            table.insert(v15, i);
        end;

        table.sort(v15);
        u13[p14] = v15;
    end;

    return v15;
end;

function u1.MaximumDistance(p16: number) -- Line: 109
    -- upvalues: GetDistances (copy)
    local v17 = GetDistances(p16);

    return v17[#v17];
end;

function u1.AudibleRadius(p18: number, p19: number) -- Line: 115
    -- upvalues: u1 (copy), GetDistances (copy)
    if p18 == 0 or p19 <= 0.0375 then
        return 0;
    end;

    local v20 = u1.Curve(p18);
    local v21 = p19;
    local v22 = 0;

    for _, v in GetDistances(p18) do
        local v23 = v20[v] * p19;

        if v23 <= 0.0375 then
            return v22 + (v - v22) * (v21 - 0.0375) / (v21 - v23);
        end;

        v21 = v23;
        v22 = v;
    end;

    return 0;
end;

function u1.AudibleCurveSource(p24: number, p25: number) -- Line: 139
    -- upvalues: u1 (copy)
    local v26 = u1.AudibleRadius(p24, p25);
    local v27 = {
        [v26] = 0
    };

    for i, v in u1.Curve(p24) do
        if i < v26 then
            v27[i] = v * (1 - (i / v26) ^ 7);
        end;
    end;

    return v27;
end;

local u28 = {};

function u1.Inverse(p29: number, p30: number, p31: number) -- Line: 160
    return p31 < p29 and 0 or math.min(1, p30 / p29);
end;

function u1.InverseCurve(p32: number, p33: number) -- Line: 168
    -- upvalues: u28 (copy), u1 (copy)
    local v34 = u28[p32];
    local v35;

    if v34 then
        v35 = v34[p33];
    else
        v35 = v34;
    end;

    if v35 then
        return v35;
    end;

    local v36 = {
        [0] = 1,
        [p33 + 0.01] = 0
    };

    if p33 <= p32 then
        v36[p33] = 1;
    else
        for i = 0, 16 do
            local v37 = p32 + (p33 - p32) * (i / 16) ^ 2;
            v36[v37] = u1.Inverse(v37, p32, p33);
            local _ = i;
        end;
    end;

    u28[p32] = v34 or {};
    u28[p32][p33] = v36;

    return v36;
end;

return u1;