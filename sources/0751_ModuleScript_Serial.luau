-- Decompiled with Potassium's decompiler.

local u1 = {
    UInt16Max = 65535,
    UInt32Max = 4294967295
};

function u1.isUInt16(p2) -- Line: 13
    -- upvalues: u1 (copy)
    local v3;

    if typeof(p2) == "number" and (p2 % 1 == 0 and p2 >= 0) then
        v3 = p2 <= u1.UInt16Max;
    else
        v3 = false;
    end;

    return v3;
end;

function u1.isNonZeroUInt16(p4) -- Line: 17
    -- upvalues: u1 (copy)
    local v5 = u1.isUInt16(p4) and p4 > 0;

    return v5;
end;

function u1.isUInt32(p6) -- Line: 21
    -- upvalues: u1 (copy)
    local v7;

    if typeof(p6) == "number" and (p6 % 1 == 0 and p6 >= 0) then
        v7 = p6 <= u1.UInt32Max;
    else
        v7 = false;
    end;

    return v7;
end;

function u1.deltaUInt32(p8: number, p9: number) -- Line: 26
    local v10 = (p8 - p9) % 4294967296;

    if v10 >= 2147483648 then
        v10 = v10 - 4294967296;
    end;

    return v10;
end;

function u1.deltaUInt16(p11: number, p12: number) -- Line: 35
    local v13 = (p11 - p12) % 65536;

    if v13 >= 32768 then
        v13 = v13 - 65536;
    end;

    return v13;
end;

function u1.addUInt32(p14: number, p15: number) -- Line: 43
    return (p14 + p15) % 4294967296;
end;

function u1.isNewerUInt32(p16: number, p17: number) -- Line: 47
    -- upvalues: u1 (copy)
    local v18 = u1.isUInt32(p16) and u1.isUInt32(p17) and u1.deltaUInt32(p16, p17) > 0;

    return v18;
end;

return table.freeze(u1);