-- ReplicatedStorage.Shared.FOW.PVS
-- Script path: ReplicatedStorage.Shared.FOW.PVS
-- Decompile time: 10.66 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Blob = require(script.Parent.Blob);
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = 0;
local u6 = "no map loaded yet";
local u7 = 0;

local function Refuse(p8: string) -- Line: 69
    -- upvalues: u6 (ref)
    u6 = p8;
    warn("[PVS] no cell culling: " .. p8);

    return nil;
end;

local function Parse(p9: buffer, p10: string?) -- Line: 85
    local v11 = buffer.readstring(p9, 0, 4) == "PVS4";
    assert(v11, "чужой блоб (нужен PVS4, перепеки cells)");
    local buffer_readf32_ret = buffer.readf32(p9, 4);
    local buffer_readf32_ret2 = buffer.readf32(p9, 8);
    local buffer_readf32_ret3 = buffer.readf32(p9, 12);
    local vector_create_ret = vector.create(buffer_readf32_ret, buffer_readf32_ret2, buffer_readf32_ret3);
    local buffer_readf32_ret4 = buffer.readf32(p9, 16);
    local buffer_readu32_ret = buffer.readu32(p9, 20);
    local buffer_readu32_ret2 = buffer.readu32(p9, 24);
    local buffer_readu32_ret3 = buffer.readu32(p9, 28);
    local buffer_readu32_ret4 = buffer.readu32(p9, 32);
    local buffer_readu32_ret5 = buffer.readu32(p9, 36);
    local buffer_readu32_ret6 = buffer.readu32(p9, 40);
    local buffer_readu32_ret7 = buffer.readu32(p9, 44);
    local buffer_readu32_ret8 = buffer.readu32(p9, 48);
    local v12 = buffer_readu32_ret * buffer_readu32_ret2 * buffer_readu32_ret3;
    local v13;

    if v12 > 0 then
        v13 = v12 <= 16777216;
    else
        v13 = false;
    end;

    assert(v13, "invalid grid size");
    local v14;

    if buffer_readf32_ret4 > 0 then
        v14 = buffer_readf32_ret4 < (1 / 0);
    else
        v14 = false;
    end;

    assert(v14, "invalid cell size");
    assert(buffer_readu32_ret4 <= buffer_readu32_ret5 * 8, "set width does not cover the targets");
    local v15 = buffer_readu32_ret6 * buffer_readu32_ret5 + 52 + (buffer_readu32_ret7 + buffer_readu32_ret8) * 8 <= buffer.len(p9);
    assert(v15, "truncated blob");
    local buffer_create_ret = buffer.create(v12 * 4);
    local buffer_create_ret2 = buffer.create((buffer_readu32_ret4 + 1) * 4);
    local buffer_create_ret3 = buffer.create((buffer_readu32_ret4 + 1) * 24);

    for i = 0, buffer_readu32_ret4 do
        buffer.writef32(buffer_create_ret3, i * 24 + 0, (1 / 0));
        buffer.writef32(buffer_create_ret3, i * 24 + 12 + 0, (-1 / 0));
        buffer.writef32(buffer_create_ret3, i * 24 + 4, (1 / 0));
        buffer.writef32(buffer_create_ret3, i * 24 + 12 + 4, (-1 / 0));
        buffer.writef32(buffer_create_ret3, i * 24 + 8, (1 / 0));
        buffer.writef32(buffer_create_ret3, i * 24 + 12 + 8, (-1 / 0));
        local _ = i;
    end;

    local v16 = buffer_readu32_ret6 * buffer_readu32_ret5 + 52 + buffer_readu32_ret7 * 8;
    local v17 = 0;

    for i = 1, buffer_readu32_ret8 do
        local buffer_readu32_ret9 = buffer.readu32(p9, v16);
        local buffer_readu32_ret10 = buffer.readu32(p9, v16 + 4);
        v16 = v16 + 8;
        local v18;

        if buffer_readu32_ret10 == 4294967295 then
            v17 = v17 + buffer_readu32_ret9;
            v18 = i;
        else
            local v19 = buffer_readu32_ret10 + 1;
            local v20 = v19 * 24;
            v18 = i;

            for i2 = 1, buffer_readu32_ret9 do
                buffer.writeu32(buffer_create_ret, v17 * 4, v19);
                local v21 = v17 % buffer_readu32_ret;
                local v22 = v17 // buffer_readu32_ret % buffer_readu32_ret2;
                local v23 = v17 // (buffer_readu32_ret * buffer_readu32_ret2);

                if v21 < buffer.readf32(buffer_create_ret3, v20) then
                    buffer.writef32(buffer_create_ret3, v20, v21);
                end;

                if v22 < buffer.readf32(buffer_create_ret3, v20 + 4) then
                    buffer.writef32(buffer_create_ret3, v20 + 4, v22);
                end;

                if v23 < buffer.readf32(buffer_create_ret3, v20 + 8) then
                    buffer.writef32(buffer_create_ret3, v20 + 8, v23);
                end;

                if buffer.readf32(buffer_create_ret3, v20 + 12) < v21 then
                    buffer.writef32(buffer_create_ret3, v20 + 12, v21);
                end;

                if buffer.readf32(buffer_create_ret3, v20 + 16) < v22 then
                    buffer.writef32(buffer_create_ret3, v20 + 16, v22);
                end;

                if buffer.readf32(buffer_create_ret3, v20 + 20) < v23 then
                    buffer.writef32(buffer_create_ret3, v20 + 20, v23);
                end;

                v17 = v17 + 1;
                local _ = i2;
            end;
        end;
    end;

    assert(v17 == v12, "target band does not cover the grid");
    local v24 = buffer_readu32_ret6 * buffer_readu32_ret5 + 52;
    local v25 = 0;

    for i = 1, buffer_readu32_ret7 do
        local buffer_readu32_ret9 = buffer.readu32(p9, v24);
        local buffer_readu32_ret10 = buffer.readu32(p9, v24 + 4);
        v24 = v24 + 8;
        local v26;

        if buffer_readu32_ret10 == 0 then
            v25 = v25 + buffer_readu32_ret9;
            v26 = i;
        else
            v26 = i;

            for i2 = 1, buffer_readu32_ret9 do
                local buffer_readu32_ret11 = buffer.readu32(buffer_create_ret, v25 * 4);

                if buffer_readu32_ret11 ~= 0 then
                    buffer.writeu32(buffer_create_ret2, buffer_readu32_ret11 * 4, buffer_readu32_ret10 * buffer_readu32_ret5 + 52);
                end;

                v25 = v25 + 1;
                local _ = i2;
            end;
        end;
    end;

    assert(v25 == v12, "set band does not cover the grid");

    return {
        Blob = p9,
        Rows = buffer_create_ret,
        SetOffsetOf = buffer_create_ret2,
        CountX = buffer_readu32_ret,
        CountY = buffer_readu32_ret2,
        CountZ = buffer_readu32_ret3,
        CountXY = buffer_readu32_ret * buffer_readu32_ret2,
        GridMin = vector_create_ret,
        GridMinX = vector_create_ret.X,
        GridMinY = vector_create_ret.Y,
        GridMinZ = vector_create_ret.Z,
        InvCell = 1 / buffer_readf32_ret4,
        Cell = vector.create(buffer_readf32_ret4, buffer_readf32_ret4, buffer_readf32_ret4),
        Kept = buffer_readu32_ret4,
        SetBytes = buffer_readu32_ret5,
        Sets = buffer_readu32_ret6,
        Index = {
            GetBounds = function(p27: number) -- Line: 219, Name: GetBounds
                -- upvalues: buffer_readu32_ret4 (copy), buffer_create_ret3 (copy), vector_create_ret (copy), buffer_readf32_ret4 (copy)
                if type(p27) ~= "number" or (p27 < 1 or buffer_readu32_ret4 < p27) then
                    return nil;
                end;

                local v28 = p27 * 24;
                local buffer_readf32_ret5 = buffer.readf32(buffer_create_ret3, v28);
                local buffer_readf32_ret6 = buffer.readf32(buffer_create_ret3, v28 + 12);

                if buffer_readf32_ret6 < buffer_readf32_ret5 then
                    return nil;
                end;

                local v29 = vector_create_ret.X + buffer_readf32_ret5 * buffer_readf32_ret4;
                local v30 = vector_create_ret.Y + buffer.readf32(buffer_create_ret3, v28 + 4) * buffer_readf32_ret4;
                local v31 = vector_create_ret.Z + buffer.readf32(buffer_create_ret3, v28 + 8) * buffer_readf32_ret4;
                local Vector3_new_ret = Vector3.new(v29, v30, v31);
                local v32 = vector_create_ret.X + (buffer_readf32_ret6 + 1) * buffer_readf32_ret4;
                local v33 = vector_create_ret.Y + (buffer.readf32(buffer_create_ret3, v28 + 16) + 1) * buffer_readf32_ret4;
                local v34 = vector_create_ret.Z + (buffer.readf32(buffer_create_ret3, v28 + 20) + 1) * buffer_readf32_ret4;

                return Vector3_new_ret, Vector3.new(v32, v33, v34);
            end
        },
        Metadata = {
            Format = "pvs3",
            MapName = p10,
            CellCount = v12,
            Kept = buffer_readu32_ret4,
            Sets = buffer_readu32_ret6,
            Cell = vector.create(buffer_readf32_ret4, buffer_readf32_ret4, buffer_readf32_ret4),
            GridMin = vector_create_ret,
            Bytes = buffer.len(p9)
        }
    };
end;

function u1.Unload() -- Line: 263
    -- upvalues: u5 (ref), u2 (ref), u3 (ref), u6 (ref)
    u5 = u5 + 1;
    u2 = nil;
    u3 = nil;
    u6 = "unloaded";
end;

function u1.Load(u35: string?) -- Line: 277
    -- upvalues: u4 (ref), u3 (ref), u2 (ref), u1 (copy), Blob (copy), u6 (ref), u5 (ref), Parse (copy), u7 (ref)
    if u4 or u3 == u35 and u2 then
        return u2;
    end;

    u1.Unload();
    local u36 = Blob.Folder(u35, "PVSCells");

    if not u36 then
        local v37 = "no " .. "PVSCells" .. " for " .. tostring(u35);
        u6 = v37;
        warn("[PVS] no cell culling: " .. v37);

        return nil;
    end;

    u4 = true;
    u6 = "loading";
    local u38 = u5;
    task.spawn(function() -- Line: 297
        -- upvalues: Blob (ref), u36 (copy), Parse (ref), u35 (copy), u4 (ref), u38 (copy), u5 (ref), u6 (ref), u2 (ref), u3 (ref), u7 (ref)
        local os_clock_ret = os.clock();
        local success, result = pcall(function() -- Line: 299
            -- upvalues: Blob (ref), u36 (ref), Parse (ref), u35 (ref)
            local v39 = Blob.Chunks(u36);
            assert(#v39 > 0, "PVSCells is empty");

            return Parse(Blob.Decode(v39), u35);
        end);
        u4 = false;

        if u38 ~= u5 then
            return;
        end;

        if not success then
            local v40 = tostring(result);
            u6 = v40;
            warn("[PVS] no cell culling: " .. v40);

            return;
        end;

        u2 = result;
        u3 = u35;
        local v41 = os.clock() - os_clock_ret;
        u6 = "loaded pvs4";
        u7 = v41;
    end);

    return nil;
end;

function u1.Get() -- Line: 330
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.GetMapName() -- Line: 331
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.Cell(p42: any, p43: vector) -- Line: 333
    if not p42 then
        return nil;
    end;

    local math_floor_ret = math.floor((p43.X - p42.GridMinX) * p42.InvCell);
    local math_floor_ret2 = math.floor((p43.Y - p42.GridMinY) * p42.InvCell);
    local math_floor_ret3 = math.floor((p43.Z - p42.GridMinZ) * p42.InvCell);

    if math_floor_ret < 0 or (math_floor_ret2 < 0 or (math_floor_ret3 < 0 or (p42.CountX <= math_floor_ret or (p42.CountY <= math_floor_ret2 or p42.CountZ <= math_floor_ret3)))) then
        return nil;
    end;

    local buffer_readu32_ret = buffer.readu32(p42.Rows, (math_floor_ret + p42.CountX * math_floor_ret2 + p42.CountXY * math_floor_ret3) * 4);

    if buffer_readu32_ret == 0 then
        return nil;
    end;

    return buffer_readu32_ret;
end;

function u1.Visible(p44: any, p45: number?, p46: number?) -- Line: 351
    if not (p44 and (p45 and p46)) then
        return true;
    end;

    if p45 < 1 or (p44.Kept < p45 or (p46 < 1 or p44.Kept < p46)) then
        return true;
    end;

    local v47 = p46 - 1;
    local buffer_readu32_ret = buffer.readu32(p44.SetOffsetOf, p45 * 4);
    local buffer_readu8_ret = buffer.readu8(p44.Blob, buffer_readu32_ret + v47 // 8);
    local bit32_lshift_ret = bit32.lshift(1, v47 % 8);

    return bit32.band(buffer_readu8_ret, bit32_lshift_ret) ~= 0;
end;

function u1.VisibleBetween(p48: any, p49: vector, p50: vector) -- Line: 367
    -- upvalues: u1 (copy)
    return u1.Visible(p48, u1.Cell(p48, p49), u1.Cell(p48, p50));
end;

function u1.ClipAlong(p51: any, p52: vector, p53: vector) -- Line: 384
    -- upvalues: u1 (copy)
    local v54 = u1.Cell(p51, p52);

    if not v54 then
        return p52;
    end;

    local v55 = p53 - p52;
    local v56 = vector.magnitude(v55) * p51.InvCell * 2;
    local math_ceil_ret = math.ceil(v56);
    local v57 = p52;

    for i = 1, math_ceil_ret do
        local v58 = p52 + v55 * (i / math_ceil_ret);
        local v59 = u1.Cell(p51, v58);

        if not (v59 and (v59 == v54 or u1.Visible(p51, v54, v59))) then
            break;
        end;

        v57 = v58;
        local _ = i;
    end;

    return v57;
end;

function u1.VisibleTarget(p60: any, p61: number?, p62: vector, p63: number?) -- Line: 428
    if not (p60 and (p61 and (p63 and (p63 >= 0 and (p63 == p63 and p63 ~= (1 / 0)))))) then
        return true;
    end;

    local math_floor_ret = math.floor((p62.X - p60.GridMinX) * p60.InvCell);
    local math_floor_ret2 = math.floor((p62.Y - p60.GridMinY) * p60.InvCell);
    local math_floor_ret3 = math.floor((p62.Z - p60.GridMinZ) * p60.InvCell);

    if math_floor_ret < 0 or (math_floor_ret2 < 0 or (math_floor_ret3 < 0 or (p60.CountX <= math_floor_ret or (p60.CountY <= math_floor_ret2 or p60.CountZ <= math_floor_ret3)))) then
        return true;
    end;

    local buffer_readu32_ret = buffer.readu32(p60.Rows, (math_floor_ret + p60.CountX * math_floor_ret2 + p60.CountXY * math_floor_ret3) * 4);

    if buffer_readu32_ret == 0 or (p61 < 1 or (p60.Kept < p61 or p60.Kept < buffer_readu32_ret)) then
        return true;
    end;

    local v64 = buffer_readu32_ret - 1;
    local buffer_readu32_ret2 = buffer.readu32(p60.SetOffsetOf, p61 * 4);
    local buffer_readu8_ret = buffer.readu8(p60.Blob, buffer_readu32_ret2 + v64 // 8);
    local bit32_lshift_ret = bit32.lshift(1, v64 % 8);

    return bit32.band(buffer_readu8_ret, bit32_lshift_ret) ~= 0;
end;

function u1.Status() -- Line: 452
    -- upvalues: u2 (ref), u3 (ref), u6 (ref), u7 (ref)
    local v65 = u2 and u2.Metadata or {};

    return table.freeze({
        Loaded = u2 ~= nil,
        MapName = u3,
        Reason = u6,
        Bytes = v65.Bytes or 0,
        LoadSeconds = u7,
        CellCount = v65.CellCount,
        Kept = v65.Kept,
        Sets = v65.Sets,
        Cell = v65.Cell,
        GridMin = v65.GridMin,
        Format = v65.Format
    });
end;

function u1.StatusText() -- Line: 461
    -- upvalues: u1 (copy)
    local v66 = u1.Status();

    if v66.Loaded then
        return string.format("Cell PVS: %s -- %d cells of %d walkable, %d sets, cell %.0f studs, %.2f MB, %.0f ms; target bounds checked at runtime", v66.MapName, v66.Kept, v66.CellCount, v66.Sets, v66.Cell.X, v66.Bytes / 1048576, v66.LoadSeconds * 1000);
    end;

    return "FOW PVS: none loaded (" .. v66.Reason .. ")";
end;

return table.freeze(u1);