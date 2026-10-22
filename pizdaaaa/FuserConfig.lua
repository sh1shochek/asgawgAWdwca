-- ReplicatedStorage.Shared.Data.FuserConfig
-- Script path: ReplicatedStorage.Shared.Data.FuserConfig
-- Decompile time: 4.89 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    MaxChance = 60,
    CashbackRate = 0.1,
    CashbackCap = 1500
};

function u1.CalculateChance(p2: number?, p3: number?) -- Line: 14
    -- upvalues: u1 (copy)
    if not p3 or p3 <= 0 then
        return 0;
    end;

    if not p2 or p2 <= 0 then
        return 0;
    end;

    local v4 = math.floor(p2 / p3 * 10000) / 100;

    return math.clamp(v4, 0, u1.MaxChance);
end;

function u1.CalculateCashback(p5: number?) -- Line: 25
    -- upvalues: u1 (copy)
    if not p5 or p5 <= 0 then
        return 0;
    end;

    local math_floor_ret = math.floor(p5 * u1.CashbackRate);
    local math_max_ret = math.max(1, math_floor_ret);

    return math.clamp(math_max_ret, 1, u1.CashbackCap);
end;

table.freeze(u1);

return u1;