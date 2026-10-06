-- Decompiled with Potassium's decompiler.

local u1 = {};

local function finite(p2: number) -- Line: 15
    local v3;

    if p2 == p2 and p2 > (-1 / 0) then
        v3 = p2 < (1 / 0);
    else
        v3 = false;
    end;

    return v3;
end;

function u1.isFiniteVector(p4) -- Line: 19
    local v5;

    if typeof(p4) == "Vector3" then
        local X = p4.X;

        if X == X and X > (-1 / 0) then
            v5 = X < (1 / 0);
        else
            v5 = false;
        end;

        if v5 then
            local Y = p4.Y;

            if Y == Y and Y > (-1 / 0) then
                v5 = Y < (1 / 0);
            else
                v5 = false;
            end;

            if v5 then
                local Z = p4.Z;

                if Z == Z and Z > (-1 / 0) then
                    v5 = Z < (1 / 0);
                else
                    v5 = false;
                end;
            end;
        end;
    else
        v5 = false;
    end;

    return v5;
end;

local function clipAxis(p6: number, p7: number, p8: number, p9: number, p10: number, p11: number) -- Line: 23
    if math.abs(p7) <= 1e-9 then
        if p6 < p8 or p9 < p6 then
            return nil, nil;
        end;

        return p10, p11;
    end;

    local v12 = 1 / p7;
    local v13 = (p8 - p6) * v12;
    local v14 = (p9 - p6) * v12;

    if v14 >= v13 then
        local v15 = v13;
        v13 = v14;
        v14 = v15;
    end;

    local math_max_ret = math.max(p10, v14);
    local math_min_ret = math.min(p11, v13);

    if math_min_ret < math_max_ret then
        return nil, nil;
    end;

    return math_max_ret, math_min_ret;
end;

function u1.segmentAABBInterval(p16: vector, p17: vector, p18: vector, p19: vector) -- Line: 52
    -- upvalues: u1 (copy), clipAxis (copy)
    if not (u1.isFiniteVector(p16) and (u1.isFiniteVector(p17) and (u1.isFiniteVector(p18) and (u1.isFiniteVector(p19) and (p18.X <= p19.X and (p18.Y <= p19.Y and p18.Z <= p19.Z)))))) then
        return nil, nil;
    end;

    local v20 = p17 - p16;
    local X = p16.X;
    local X2 = v20.X;
    local X3 = p18.X;
    local X4 = p19.X;
    local v21 = 0;
    local v22 = 1;

    if math.abs(X2) <= 1e-9 then
        if X < X3 or X4 < X then
            v21 = nil;
            v22 = nil;
        end;
    else
        local v23 = 1 / X2;
        local v24 = (X3 - X) * v23;
        local v25 = (X4 - X) * v23;

        if v25 >= v24 then
            local v26 = v24;
            v24 = v25;
            v25 = v26;
        end;

        v21 = math.max(v21, v25);
        v22 = math.min(v22, v24);

        if v22 < v21 then
            v21 = nil;
            v22 = nil;
        end;
    end;

    if v21 == nil or v22 == nil then
        return nil, nil;
    end;

    local Y = p16.Y;
    local Y2 = v20.Y;
    local Y3 = p18.Y;
    local Y4 = p19.Y;

    if math.abs(Y2) <= 1e-9 then
        if Y < Y3 or Y4 < Y then
            v21 = nil;
            v22 = nil;
        end;
    else
        local v27 = 1 / Y2;
        local v28 = (Y3 - Y) * v27;
        local v29 = (Y4 - Y) * v27;

        if v29 >= v28 then
            local v30 = v28;
            v28 = v29;
            v29 = v30;
        end;

        v21 = math.max(v21, v29);
        v22 = math.min(v22, v28);

        if v22 < v21 then
            v21 = nil;
            v22 = nil;
        end;
    end;

    if v21 == nil or v22 == nil then
        return nil, nil;
    end;

    return clipAxis(p16.Z, v20.Z, p18.Z, p19.Z, v21, v22);
end;

function u1.segmentSphereInterval(p31: vector, p32: vector, p33: vector, p34: number) -- Line: 82
    -- upvalues: u1 (copy)
    if u1.isFiniteVector(p31) and (u1.isFiniteVector(p32) and u1.isFiniteVector(p33)) then
        local v35;

        if p34 == p34 and p34 > (-1 / 0) then
            v35 = p34 < (1 / 0);
        else
            v35 = false;
        end;

        if v35 and p34 > 0 then
            local v36 = p32 - p31;
            local v37 = v36:Dot(v36);

            if v37 <= 1e-6 then
                if (p31 - p33).Magnitude <= p34 then
                    return 0, 1;
                end;

                return nil, nil;
            end;

            local v38 = p31 - p33;
            local v39 = 2 * v38:Dot(v36);
            local v40 = v38:Dot(v38) - p34 * p34;
            local v41 = v39 * v39 - 4 * v37 * v40;

            if v41 < 0 then
                return nil, nil;
            end;

            local math_sqrt_ret = math.sqrt(v41);
            local v42 = (-v39 - math_sqrt_ret) / (2 * v37);
            local v43 = (-v39 + math_sqrt_ret) / (2 * v37);
            local math_min_ret = math.min(v42, v43);
            local math_max_ret = math.max(0, math_min_ret);
            local math_max_ret2 = math.max(v42, v43);
            local math_min_ret2 = math.min(1, math_max_ret2);

            if math_min_ret2 < math_max_ret then
                return nil, nil;
            end;

            return math_max_ret, math_min_ret2;
        end;
    end;

    return nil, nil;
end;

local function mergedIntervals(p44: table) -- Line: 125
    local v45 = {};

    for _, v in p44 do
        local math_clamp_ret = math.clamp(v.minimum, 0, 1);
        local math_clamp_ret2 = math.clamp(v.maximum, 0, 1);
        local v46;

        if math_clamp_ret == math_clamp_ret and math_clamp_ret > (-1 / 0) then
            v46 = math_clamp_ret < (1 / 0);
        else
            v46 = false;
        end;

        if v46 then
            local v47;

            if math_clamp_ret2 == math_clamp_ret2 and math_clamp_ret2 > (-1 / 0) then
                v47 = math_clamp_ret2 < (1 / 0);
            else
                v47 = false;
            end;

            if v47 and math_clamp_ret < math_clamp_ret2 then
                v45[#v45 + 1] = {
                    minimum = math_clamp_ret,
                    maximum = math_clamp_ret2
                };
            end;
        end;
    end;

    if #v45 <= 1 then
        return v45;
    end;

    table.sort(v45, function(p48, p49) -- Line: 137
        if p48.minimum == p49.minimum then
            return p48.maximum < p49.maximum;
        end;

        return p48.minimum < p49.minimum;
    end);
    local v50 = { v45[1] };

    for i = 2, #v45 do
        local v51 = v45[i];
        local v52 = v50[#v50];
        local v53;

        if v51.minimum <= v52.maximum + 1e-6 then
            v52.maximum = math.max(v52.maximum, v51.maximum);
            v53 = i;
        else
            v50[#v50 + 1] = v51;
            v53 = i;
        end;
    end;

    return v50;
end;

function u1.uncoveredUnionLength(p54: table, p55: table) -- Line: 158
    -- upvalues: mergedIntervals (copy)
    local v56 = mergedIntervals(p54);

    if #v56 == 0 then
        return 0;
    end;

    local v57 = mergedIntervals(p55);

    if #v57 == 0 then
        local v58 = 0;

        for _, v in v56 do
            v58 = v58 + (v.maximum - v.minimum);
        end;

        return v58;
    end;

    local v59 = 1;
    local v60 = 0;

    for _, v in v56 do
        local minimum = v.minimum;
        local v61 = v;

        while v59 <= #v57 and v57[v59].maximum <= minimum do
            v59 = v59 + 1;
        end;

        local v62 = v59;

        while v62 <= #v57 and v57[v62].minimum < v61.maximum do
            local v63 = v57[v62];

            if minimum < v63.minimum then
                v60 = v60 + (math.min(v63.minimum, v61.maximum) - minimum);
            end;

            minimum = math.max(minimum, v63.maximum);

            if v61.maximum <= minimum then
                break;
            end;

            v62 = v62 + 1;
        end;

        if minimum < v61.maximum then
            v60 = v60 + (v61.maximum - minimum);
        end;
    end;

    return math.max(v60, 0);
end;

return table.freeze(u1);