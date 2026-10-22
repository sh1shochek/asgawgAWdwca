-- ReplicatedStorage.Shared.TattleSeal
-- Script path: ReplicatedStorage.Shared.TattleSeal
-- Decompile time: 10.70 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    PROTOCOL = "a0171d",
    CHALLENGE_ATTRIBUTE = "RelayTag",
    CHALLENGES = table.freeze({
        table.freeze({
            Name = "Canaries",
            Bit = 128
        }),
        table.freeze({
            Name = "Hooks",
            Bit = 1
        }),
        table.freeze({
            Name = "Instances",
            Bit = 512
        }),
        table.freeze({
            Name = "Libraries",
            Bit = 256
        }),
        table.freeze({
            Name = "Gui",
            Bit = 64
        }),
        table.freeze({
            Name = "Environment",
            Bit = 64
        }),
        table.freeze({
            Name = "World",
            Bit = 16384
        }),
        table.freeze({
            Name = "Self",
            Bit = 1
        })
    })
};

local function Mix(p2: number, p3: number) -- Line: 55
    local bit32_bxor_ret = bit32.bxor(p2, p3);
    local bit32_lshift_ret = bit32.lshift(bit32_bxor_ret, 6);
    local bit32_bxor_ret2 = bit32.bxor(bit32_bxor_ret, bit32_lshift_ret);
    local bit32_rshift_ret = bit32.rshift(bit32_bxor_ret2, 21);
    local bit32_bxor_ret3 = bit32.bxor(bit32_bxor_ret2, bit32_rshift_ret);
    local bit32_lshift_ret2 = bit32.lshift(bit32_bxor_ret3, 7);

    return bit32.bxor(bit32_bxor_ret3, bit32_lshift_ret2);
end;

local function Fold(p4: number, p5: number, p6: number, p7: number, p8: number, p9: number) -- Line: 63
    local bit32_bxor_ret = bit32.bxor(p8, 4266460911);
    local bit32_bxor_ret2 = bit32.bxor(p4, bit32_bxor_ret);
    local bit32_lshift_ret = bit32.lshift(bit32_bxor_ret2, 6);
    local bit32_bxor_ret3 = bit32.bxor(bit32_bxor_ret2, bit32_lshift_ret);
    local bit32_rshift_ret = bit32.rshift(bit32_bxor_ret3, 21);
    local bit32_bxor_ret4 = bit32.bxor(bit32_bxor_ret3, bit32_rshift_ret);
    local bit32_lshift_ret2 = bit32.lshift(bit32_bxor_ret4, 7);
    local bit32_bxor_ret5 = bit32.bxor(bit32_bxor_ret4, bit32_lshift_ret2);
    local bit32_bxor_ret6 = bit32.bxor(p9, 1479621860);
    local bit32_bxor_ret7 = bit32.bxor(bit32_bxor_ret5, bit32_bxor_ret6);
    local bit32_lshift_ret3 = bit32.lshift(bit32_bxor_ret7, 6);
    local bit32_bxor_ret8 = bit32.bxor(bit32_bxor_ret7, bit32_lshift_ret3);
    local bit32_rshift_ret2 = bit32.rshift(bit32_bxor_ret8, 21);
    local bit32_bxor_ret9 = bit32.bxor(bit32_bxor_ret8, bit32_rshift_ret2);
    local bit32_lshift_ret4 = bit32.lshift(bit32_bxor_ret9, 7);
    local bit32_bxor_ret10 = bit32.bxor(bit32_bxor_ret9, bit32_lshift_ret4);
    local bit32_bxor_ret11 = bit32.bxor(p5, 2997021376);
    local bit32_bxor_ret12 = bit32.bxor(bit32_bxor_ret10, bit32_bxor_ret11);
    local bit32_lshift_ret5 = bit32.lshift(bit32_bxor_ret12, 6);
    local bit32_bxor_ret13 = bit32.bxor(bit32_bxor_ret12, bit32_lshift_ret5);
    local bit32_rshift_ret3 = bit32.rshift(bit32_bxor_ret13, 21);
    local bit32_bxor_ret14 = bit32.bxor(bit32_bxor_ret13, bit32_rshift_ret3);
    local bit32_lshift_ret6 = bit32.lshift(bit32_bxor_ret14, 7);
    local bit32_bxor_ret15 = bit32.bxor(bit32_bxor_ret14, bit32_lshift_ret6);
    local bit32_bxor_ret16 = bit32.bxor(p7, 3107043835);
    local bit32_bxor_ret17 = bit32.bxor(bit32_bxor_ret15, bit32_bxor_ret16);
    local bit32_lshift_ret7 = bit32.lshift(bit32_bxor_ret17, 6);
    local bit32_bxor_ret18 = bit32.bxor(bit32_bxor_ret17, bit32_lshift_ret7);
    local bit32_rshift_ret4 = bit32.rshift(bit32_bxor_ret18, 21);
    local bit32_bxor_ret19 = bit32.bxor(bit32_bxor_ret18, bit32_rshift_ret4);
    local bit32_lshift_ret8 = bit32.lshift(bit32_bxor_ret19, 7);
    local bit32_bxor_ret20 = bit32.bxor(bit32_bxor_ret19, bit32_lshift_ret8);
    local bit32_bxor_ret21 = bit32.bxor(p6, 964284217);
    local bit32_bxor_ret22 = bit32.bxor(bit32_bxor_ret20, bit32_bxor_ret21);
    local bit32_lshift_ret9 = bit32.lshift(bit32_bxor_ret22, 6);
    local bit32_bxor_ret23 = bit32.bxor(bit32_bxor_ret22, bit32_lshift_ret9);
    local bit32_rshift_ret5 = bit32.rshift(bit32_bxor_ret23, 21);
    local bit32_bxor_ret24 = bit32.bxor(bit32_bxor_ret23, bit32_rshift_ret5);
    local bit32_lshift_ret10 = bit32.lshift(bit32_bxor_ret24, 7);

    return bit32.bxor(bit32_bxor_ret24, bit32_lshift_ret10);
end;

function u1.Challenge(p10: number) -- Line: 79
    -- upvalues: u1 (copy)
    if p10 == 0 then
        return nil;
    end;

    return u1.CHALLENGES[p10 % #u1.CHALLENGES + 1];
end;

function u1.Expected(p11: number) -- Line: 88
    -- upvalues: u1 (copy)
    local v12 = u1.Challenge(p11);

    return v12 and v12.Bit or 0;
end;

function u1.Seed(p13: string, p14: number) -- Line: 94
    local bit32_bxor_ret = bit32.bxor(3376506168, p14 % 4294967296);
    local bit32_lshift_ret = bit32.lshift(bit32_bxor_ret, 6);
    local bit32_bxor_ret2 = bit32.bxor(bit32_bxor_ret, bit32_lshift_ret);
    local bit32_rshift_ret = bit32.rshift(bit32_bxor_ret2, 21);
    local bit32_bxor_ret3 = bit32.bxor(bit32_bxor_ret2, bit32_rshift_ret);
    local bit32_lshift_ret2 = bit32.lshift(bit32_bxor_ret3, 7);
    local bit32_bxor_ret4 = bit32.bxor(bit32_bxor_ret3, bit32_lshift_ret2);
    local string_gsub_ret = string.gsub(p13, "[0%-]", "");

    for i = 1, #string_gsub_ret do
        local string_byte_ret = string.byte(string_gsub_ret, i);
        local bit32_bxor_ret5 = bit32.bxor(bit32_bxor_ret4, string_byte_ret);
        local bit32_lshift_ret3 = bit32.lshift(bit32_bxor_ret5, 6);
        local bit32_bxor_ret6 = bit32.bxor(bit32_bxor_ret5, bit32_lshift_ret3);
        local bit32_rshift_ret2 = bit32.rshift(bit32_bxor_ret6, 21);
        local bit32_bxor_ret7 = bit32.bxor(bit32_bxor_ret6, bit32_rshift_ret2);
        local bit32_lshift_ret4 = bit32.lshift(bit32_bxor_ret7, 7);
        bit32_bxor_ret4 = bit32.bxor(bit32_bxor_ret7, bit32_lshift_ret4);
        local _ = i;
    end;

    return bit32_bxor_ret4;
end;

function u1.Seal(p15: number, p16: number, p17: number, p18: number, p19: number, p20: number) -- Line: 108
    -- upvalues: Fold (copy)
    return Fold(p15, p16, p17, p18, p19, p20);
end;

return u1;