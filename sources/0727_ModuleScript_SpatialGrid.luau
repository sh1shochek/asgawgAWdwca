-- Decompiled with Potassium's decompiler.

local Geometry = require(script.Parent.Geometry);
local u1 = {};
u1.__index = u1;

local function cellRange(p2: vector, p3: vector, p4: number) -- Line: 20
    return math.floor(p2.X / p4), math.floor(p3.X / p4), math.floor(p2.Z / p4), math.floor(p3.Z / p4);
end;

function u1.Build(p5: table, p6: number, p7: number, p8: table?) -- Line: 27
    -- upvalues: Geometry (copy), u1 (copy)
    assert(p6 > 0, "spatial-grid cell size must be positive");
    local v9;

    if p7 >= 1 then
        v9 = p7 % 1 == 0;
    else
        v9 = false;
    end;

    assert(v9, "invalid oversized-record threshold");
    assert(p8 == nil and true or #p8 == #p5, "paired spatial-grid records must have equal counts");
    local v10 = {};
    local v11 = {};

    for i, v in p5 do
        local AabbMin = v.AabbMin;
        local AabbMax = v.AabbMax;
        local v12;

        if p8 == nil then
            v12 = nil;
        else
            v12 = p8[i];
        end;

        if v12 ~= nil then
            AabbMin = Geometry.Min(AabbMin, v12.AabbMin);
            AabbMax = Geometry.Max(AabbMax, v12.AabbMax);
        end;

        local math_floor_ret = math.floor(AabbMin.X / p6);
        local math_floor_ret2 = math.floor(AabbMax.X / p6);
        local math_floor_ret3 = math.floor(AabbMin.Z / p6);
        local math_floor_ret4 = math.floor(AabbMax.Z / p6);

        if p7 < (math_floor_ret2 - math_floor_ret + 1) * (math_floor_ret4 - math_floor_ret3 + 1) then
            v10[#v10 + 1] = i;
        else
            local v13 = i;

            for i2 = math_floor_ret, math_floor_ret2 do
                local v14 = v11[i2];

                if v14 == nil then
                    v14 = {};
                    v11[i2] = v14;
                end;

                local _ = i2;

                for i3 = math_floor_ret3, math_floor_ret4 do
                    local v15 = v14[i3];

                    if v15 == nil then
                        v15 = {};
                        v14[i3] = v15;
                    end;

                    v15[#v15 + 1] = v13;
                    local _ = i3;
                end;
            end;
        end;
    end;

    for _, v in v11 do
        for _, v2 in v do
            table.freeze(v2);
        end;

        table.freeze(v);
    end;

    table.freeze(v11);
    table.freeze(v10);

    return setmetatable({
        CellSize = p6,
        Cells = v11,
        Oversized = v10
    }, u1);
end;

function u1.QueryInto(p16: any, p17: vector, p18: vector, p19: table, p20: table, p21: table, p22: number, p23: table?, p24: table?) -- Line: 86
    local v25;

    if p22 % 1 == 0 then
        v25 = p22 > 0;
    else
        v25 = false;
    end;

    assert(v25, "spatial-grid query stamp must be a positive integer");
    local CellSize = p16.CellSize;
    local math_floor_ret = math.floor(p17.X / CellSize);
    local math_floor_ret2 = math.floor(p18.X / CellSize);
    local math_floor_ret3 = math.floor(p17.Z / CellSize);
    local math_floor_ret4 = math.floor(p18.Z / CellSize);
    table.clear(p20);
    local v26 = p23 or {};
    table.clear(v26);

    if #p16.Oversized > 0 then
        v26[#v26 + 1] = p16.Oversized;
    end;

    for i = math_floor_ret, math_floor_ret2 do
        local v27 = p16.Cells[i];
        local v28;

        if v27 == nil then
            v28 = i;
        else
            v28 = i;

            for i2 = math_floor_ret3, math_floor_ret4 do
                local v29 = v27[i2];
                local v30;

                if v29 == nil then
                    v30 = i2;
                else
                    v26[#v26 + 1] = v29;
                    v30 = i2;
                end;
            end;
        end;
    end;

    local v31 = #v26;
    local X = p17.X;
    local Y = p17.Y;
    local Z = p17.Z;
    local X2 = p18.X;
    local Y2 = p18.Y;
    local Z2 = p18.Z;
    local v32 = 0;

    if v31 == 1 then
        for _, v in v26[1] do
            local v33 = p19[v];
            local AabbMin = v33.AabbMin;
            local AabbMax = v33.AabbMax;

            if X <= AabbMax.X and (AabbMin.X <= X2 and (Y <= AabbMax.Y and (AabbMin.Y <= Y2 and (Z <= AabbMax.Z and AabbMin.Z <= Z2)))) then
                v32 = v32 + 1;
                p20[v32] = v;
            end;
        end;

        return;
    end;

    if v31 ~= 2 then
        for _, v in v26 do
            for _, v2 in v do
                if p21[v2] ~= p22 then
                    p21[v2] = p22;
                    local v34 = p19[v2];
                    local AabbMin = v34.AabbMin;
                    local AabbMax = v34.AabbMax;

                    if X <= AabbMax.X and (AabbMin.X <= X2 and (Y <= AabbMax.Y and (AabbMin.Y <= Y2 and (Z <= AabbMax.Z and AabbMin.Z <= Z2)))) then
                        v32 = v32 + 1;
                        p20[v32] = v2;
                    end;
                end;
            end;
        end;

        table.sort(p20);

        return;
    end;

    local v35 = v26[1];
    local v36 = v26[2];
    local v37 = v35[1];
    local v38 = v36[1];
    local v39 = 1;
    local v40 = 1;

    while v37 ~= nil or v38 ~= nil do
        local v41;

        if v38 == nil or v37 ~= nil and v37 < v38 then
            v39 = v39 + 1;
            v41 = v35[v39];
        elseif v37 == nil or v38 < v37 then
            v40 = v40 + 1;
            v41 = v37;
            v37 = v38;
            v38 = v36[v40];
        else
            v39 = v39 + 1;
            v40 = v40 + 1;
            v41 = v35[v39];
            v38 = v36[v40];
        end;

        local v42 = p19[v37];
        local AabbMin = v42.AabbMin;
        local AabbMax = v42.AabbMax;

        if X <= AabbMax.X and (AabbMin.X <= X2 and (Y <= AabbMax.Y and (AabbMin.Y <= Y2 and (Z <= AabbMax.Z and AabbMin.Z <= Z2)))) then
            v32 = v32 + 1;
            p20[v32] = v37;
        end;

        v37 = v41;
    end;
end;

return table.freeze(u1);