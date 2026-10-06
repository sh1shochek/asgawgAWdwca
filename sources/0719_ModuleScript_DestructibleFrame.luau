-- Decompiled with Potassium's decompiler.

local Schema = require(script.Parent.Schema);
local u1 = {};

local function isUInt32(p2) -- Line: 16
    local v3;

    if typeof(p2) == "number" and (p2 % 1 == 0 and p2 >= 0) then
        v3 = p2 <= 4294967295;
    else
        v3 = false;
    end;

    return v3;
end;

local function validateBits(p4: number, p5: string) -- Line: 20
    local math_ceil_ret = math.ceil(p4 / 8);

    if #p5 ~= math_ceil_ret then
        return false, string.format("active bitset has %d bytes; expected %d", #p5, math_ceil_ret);
    end;

    local v6 = p4 % 8;

    if v6 == 0 or (math_ceil_ret <= 0 or string.byte(p5, math_ceil_ret) <= 2 ^ v6 - 1) then
        return true, nil;
    end;

    return false, "active bitset has non-zero padding bits";
end;

function u1.Validate(p7, p8, p9, p10) -- Line: 38
    -- upvalues: Schema (copy), validateBits (copy)
    local v11;

    if typeof(p7) == "number" and (p7 % 1 == 0 and p7 >= 0) then
        v11 = p7 <= 4294967295;
    else
        v11 = false;
    end;

    if not (v11 and (p7 ~= 0 and Schema.MaxEpoch >= p7)) then
        return false, "epoch must be a non-zero u16";
    end;

    local v12;

    if typeof(p8) == "number" and (p8 % 1 == 0 and p8 >= 0) then
        v12 = p8 <= 4294967295;
    else
        v12 = false;
    end;

    if not v12 then
        return false, "revision must be a u32";
    end;

    if typeof(p9) ~= "number" or (p9 % 1 ~= 0 or (p9 < 0 or Schema.MaxDestructibleCount < p9)) then
        return false, string.format("count must be an integer in [0, %d]", Schema.MaxDestructibleCount);
    end;

    if typeof(p10) == "string" then
        return validateBits(p9, p10);
    end;

    return false, "active bitset must be a string";
end;

function u1.New(p13: number, p14: number, p15: number, p16: string) -- Line: 55
    -- upvalues: u1 (copy)
    local v17, v18 = u1.Validate(p13, p14, p15, p16);
    assert(v17, v18);

    return table.freeze({
        Epoch = p13,
        Revision = p14,
        Count = p15,
        ActiveBits = p16
    });
end;

function u1.AllActive(p19: number, p20: number, p21: number) -- Line: 67
    -- upvalues: Schema (copy), u1 (copy)
    local v22;

    if p21 % 1 == 0 and p21 >= 0 then
        v22 = p21 <= Schema.MaxDestructibleCount;
    else
        v22 = false;
    end;

    assert(v22, "invalid destructible count");
    local math_floor_ret = math.floor(p21 / 8);
    local v23 = p21 % 8;
    local string_rep_ret = string.rep("\255", math_floor_ret);

    if v23 ~= 0 then
        string_rep_ret = string_rep_ret .. string.char(2 ^ v23 - 1);
    end;

    return u1.New(p19, p20, p21, string_rep_ret);
end;

function u1.IsActive(p24: table, p25: number) -- Line: 80
    local v26;

    if p25 % 1 == 0 and p25 >= 1 then
        v26 = p25 <= p24.Count;
    else
        v26 = false;
    end;

    assert(v26, "destructible index is outside the frame");
    local v27 = p25 - 1;
    local v28 = math.floor(v27 / 8) + 1;
    local string_byte_ret = string.byte(p24.ActiveBits, v28);
    local bit32_lshift_ret = bit32.lshift(1, v27 % 8);

    return bit32.band(string_byte_ret, bit32_lshift_ret) ~= 0;
end;

return table.freeze(u1);