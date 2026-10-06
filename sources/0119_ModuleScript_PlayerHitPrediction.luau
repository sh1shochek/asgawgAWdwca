-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};

local function prune(p3: number) -- Line: 21
    -- upvalues: u2 (copy)
    while u2[1] and p3 - u2[1].CreatedAt > 1 do
        table.remove(u2, 1);
    end;
end;

function v1.Record(p4: number, p5: number, p6: string, p7: vector) -- Line: 27
    -- upvalues: prune (copy), u2 (copy)
    local os_clock_ret = os.clock();
    prune(os_clock_ret);

    if #u2 >= 64 then
        table.remove(u2, 1);
    end;

    u2[#u2 + 1] = {
        ShotSeq = p4,
        VictimUserId = p5,
        HitPartName = p6,
        Position = p7,
        CreatedAt = os_clock_ret
    };
end;

function v1.Consume(p8: number, p9: number, p10: string, p11: vector) -- Line: 42
    -- upvalues: prune (copy), u2 (copy)
    prune(os.clock());

    for i, v in u2 do
        if v.ShotSeq == p8 and (v.VictimUserId == p9 and (v.HitPartName == p10 and (v.Position - p11).Magnitude <= 6)) then
            table.remove(u2, i);

            return true;
        end;
    end;

    return false;
end;

return table.freeze(v1);