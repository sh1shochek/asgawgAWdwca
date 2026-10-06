-- Decompiled with Potassium's decompiler.

local u1 = {
    Jump = 1,
    Duck = 2,
    Walk = 4,
    Scoped = 8,
    ValidMask = 15
};

function u1.isValid(p2) -- Line: 13
    -- upvalues: u1 (copy)
    local v3;

    if typeof(p2) == "number" and (p2 % 1 == 0 and (p2 >= 0 and p2 <= 255)) then
        local bit32_bnot_ret = bit32.bnot(u1.ValidMask);
        v3 = bit32.band(p2, bit32_bnot_ret) == 0;
    else
        v3 = false;
    end;

    return v3;
end;

function u1.has(p4: number, p5: number) -- Line: 21
    return bit32.band(p4, p5) ~= 0;
end;

function u1.with(p6: number, p7: number, p8: boolean) -- Line: 25
    if p8 then
        return bit32.bor(p6, p7);
    end;

    local bit32_bnot_ret = bit32.bnot(p7);

    return bit32.band(p6, bit32_bnot_ret);
end;

return table.freeze(u1);