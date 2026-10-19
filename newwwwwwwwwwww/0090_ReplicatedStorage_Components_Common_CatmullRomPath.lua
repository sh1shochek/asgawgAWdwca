-- CatmullRomPath (ModuleScript)
-- full path: ReplicatedStorage.Components.Common.CatmullRomPath

-- Decompiled with Potassium's decompiler.

local v1 = {};

local function straightDistance(p2: vector, p3: vector) -- Line: 29
    return (p2 - p3).Magnitude;
end;

local function knotGap(p4: function, p5: number, p6: vector, p7: vector) -- Line: 33
    local v8 = p4(p6, p7) ^ p5;

    return math.max(v8, 0.0001);
end;

function v1.spline(p9: table, p10: table) -- Line: 41
    -- upvalues: straightDistance (copy)
    local v11 = #p9;

    if v11 < 2 then
        return p9;
    end;

    local v12 = p10.Distance or straightDistance;
    local Alpha = p10.Alpha;
    local v13 = { p9[1] };

    for i = 1, v11 - 1 do
        local v14 = p9[i];
        local v15 = p9[i + 1];
        local v16;

        if i > 1 then
            v16 = p9[i - 1];
        else
            v16 = v14 + (v14 - v15);
        end;

        local v17;

        if i + 2 <= v11 then
            v17 = p9[i + 2];
        else
            v17 = v15 + (v15 - v14);
        end;

        local v18 = v12(v16, v14) ^ Alpha;
        local math_max_ret = math.max(v18, 0.0001);
        local v19 = v12(v14, v15) ^ Alpha;
        local v20 = math_max_ret + math.max(v19, 0.0001);
        local v21 = v12(v15, v17) ^ Alpha;
        local v22 = v20 + math.max(v21, 0.0001);
        local SamplesPerSpan = p10.SamplesPerSpan;

        if not SamplesPerSpan then
            local v23 = v12(v14, v15) / (p10.Step or 1);
            local math_ceil_ret = math.ceil(v23);
            SamplesPerSpan = math.max(1, math_ceil_ret);
        end;

        local _ = i;

        for i2 = 1, SamplesPerSpan do
            local v24 = math_max_ret + (v20 - math_max_ret) * (i2 / SamplesPerSpan);
            local v25 = v14 * ((v20 - v24) / (v20 - math_max_ret)) + v15 * ((v24 - math_max_ret) / (v20 - math_max_ret));
            table.insert(v13, ((v16 * ((math_max_ret - v24) / math_max_ret) + v14 * (v24 / math_max_ret)) * ((v20 - v24) / v20) + v25 * (v24 / v20)) * ((v20 - v24) / (v20 - math_max_ret)) + (v25 * ((v22 - v24) / (v22 - math_max_ret)) + (v15 * ((v22 - v24) / (v22 - v20)) + v17 * ((v24 - v20) / (v22 - v20))) * ((v24 - math_max_ret) / (v22 - math_max_ret))) * ((v24 - math_max_ret) / (v20 - math_max_ret)));
            local _ = i2;
        end;
    end;

    return v13;
end;

function v1.resample(p26: table, p27: number, p28: function?, p29: table?) -- Line: 73
    -- upvalues: straightDistance (copy)
    local v30 = p28 or straightDistance;
    local v31 = { p26[1] };
    local v32 = p29 and { p29[1] } or {};
    local v33 = 0;
    local v34 = 0;

    for i = 2, #p26 do
        local v35 = p26[i - 1];
        local v36 = p26[i];
        local v37 = v30(v35, v36);
        local v38;

        if v37 < 0.001 then
            v38 = i;
        else
            local v39 = p27 - v33;
            v38 = i;

            while v39 <= v37 do
                table.insert(v31, v35:Lerp(v36, v39 / v37));

                if p29 then
                    table.insert(v32, p29[v38 - 1]:Lerp(p29[v38], v39 / v37));
                end;

                v39 = v39 + p27;
            end;

            v33 = v37 - (v39 - p27);
            v34 = v34 + v37;
        end;
    end;

    if v30(v31[#v31], p26[#p26]) > 0.01 then
        table.insert(v31, p26[#p26]);

        if p29 then
            table.insert(v32, p29[#p29]);
        end;
    end;

    return v31, v34, v32;
end;

function v1.locate(p40: number, p41: number, p42: number) -- Line: 112
    local v43 = p42 / p41 + 1;
    local math_floor_ret = math.floor(v43);
    local math_clamp_ret = math.clamp(math_floor_ret, 1, p40);

    return math_clamp_ret, math.min(math_clamp_ret + 1, p40), v43 - math.floor(v43);
end;

return v1;