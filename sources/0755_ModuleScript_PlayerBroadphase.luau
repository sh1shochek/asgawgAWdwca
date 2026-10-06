-- Decompiled with Potassium's decompiler.

local Quantization = require(script.Parent.Parent.Quantization);
local Serial = require(script.Parent.Parent.Serial);
local u1 = {};
u1.__index = u1;
u1.DefaultCellSize = 8;

local function cellCoordinate(p2: number, p3: number) -- Line: 23
    return math.floor(p2 / p3);
end;

local function removeFromCell(p4: any, p5: number, p6: number, p7: number) -- Line: 27
    local v8 = p4._cells[p6];

    if v8 == nil then
        return;
    end;

    local v9 = v8[p7];

    if v9 == nil then
        return;
    end;

    v9[p5] = nil;

    if next(v9) == nil then
        v8[p7] = nil;

        if next(v8) == nil then
            p4._cells[p6] = nil;
        end;
    end;
end;

function u1.new(p10: number?) -- Line: 45
    -- upvalues: u1 (copy)
    local v11 = p10 or u1.DefaultCellSize;
    local v12;

    if type(v11) == "number" and (v11 == v11 and v11 > 0) then
        v12 = v11 < (1 / 0);
    else
        v12 = false;
    end;

    assert(v12, "invalid player broadphase cell size");

    return setmetatable({
        _cellSize = v11,
        _cells = {},
        _cellXById = {},
        _cellZById = {},
        _queryScratch = {}
    }, u1);
end;

function u1.clear(p13) -- Line: 63
    table.clear(p13._cells);
    table.clear(p13._cellXById);
    table.clear(p13._cellZById);
    table.clear(p13._queryScratch);
end;

function u1.remove(p14: table, p15: number) -- Line: 70
    local v16 = p14._cellXById[p15];
    local v17 = p14._cellZById[p15];

    if v16 == nil or v17 == nil then
        return;
    end;

    local v18 = p14._cells[v16];

    if v18 ~= nil then
        local v19 = v18[v17];

        if v19 ~= nil then
            v19[p15] = nil;

            if next(v19) == nil then
                v18[v17] = nil;

                if next(v18) == nil then
                    p14._cells[v16] = nil;
                end;
            end;
        end;
    end;

    p14._cellXById[p15] = nil;
    p14._cellZById[p15] = nil;
end;

function u1.upsert(p20: table, p21: number, p22: vector) -- Line: 81
    -- upvalues: Serial (copy), Quantization (copy)
    local v23 = Serial.isUInt32(p21) and p21 > 0;
    assert(v23, "player broadphase ID must be a non-zero u32");
    local v24 = Quantization.isFiniteVector3(p22);
    assert(v24, "invalid player broadphase position");
    local math_floor_ret = math.floor(p22.X / p20._cellSize);
    local math_floor_ret2 = math.floor(p22.Z / p20._cellSize);
    local v25 = p20._cellXById[p21];
    local v26 = p20._cellZById[p21];

    if v25 == math_floor_ret and v26 == math_floor_ret2 then
        return;
    end;

    if v25 ~= nil and v26 ~= nil then
        local v27 = p20._cells[v25];

        if v27 ~= nil then
            local v28 = v27[v26];

            if v28 ~= nil then
                v28[p21] = nil;

                if next(v28) == nil then
                    v27[v26] = nil;

                    if next(v27) == nil then
                        p20._cells[v25] = nil;
                    end;
                end;
            end;
        end;
    end;

    local v29 = p20._cells[math_floor_ret];

    if v29 == nil then
        v29 = {};
        p20._cells[math_floor_ret] = v29;
    end;

    local v30 = v29[math_floor_ret2];

    if v30 == nil then
        v30 = {};
        v29[math_floor_ret2] = v30;
    end;

    v30[p21] = true;
    p20._cellXById[p21] = math_floor_ret;
    p20._cellZById[p21] = math_floor_ret2;
end;

function u1.query(p31: table, p32: vector, p33: vector, p34: table?) -- Line: 110
    -- upvalues: Quantization (copy)
    local v35 = Quantization.isFiniteVector3(p32) and Quantization.isFiniteVector3(p33);
    assert(v35, "invalid query bounds");
    local v36;

    if p32.X <= p33.X then
        v36 = p32.Z <= p33.Z;
    else
        v36 = false;
    end;

    assert(v36, "inverted player broadphase bounds");
    local v37 = p34 or p31._queryScratch;
    table.clear(v37);
    local math_floor_ret = math.floor(p32.X / p31._cellSize);
    local math_floor_ret2 = math.floor(p33.X / p31._cellSize);
    local math_floor_ret3 = math.floor(p32.Z / p31._cellSize);
    local math_floor_ret4 = math.floor(p33.Z / p31._cellSize);

    for i = math_floor_ret, math_floor_ret2 do
        local v38 = p31._cells[i];
        local v39;

        if v38 == nil then
            v39 = i;
        else
            v39 = i;

            for i2 = math_floor_ret3, math_floor_ret4 do
                local v40 = v38[i2];
                local v41;

                if v40 == nil then
                    v41 = i2;
                else
                    v41 = i2;

                    for i3 in v40 do
                        v37[#v37 + 1] = i3;
                    end;
                end;
            end;
        end;
    end;

    table.sort(v37);

    return v37;
end;

return table.freeze(u1);