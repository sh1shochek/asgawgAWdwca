-- Decompiled with Potassium's decompiler.

local u1 = {};
require(script.Parent.Types);
u1.AccuracyCeiling = 0.4;

function u1.Divide(p2: number, p3: number) -- Line: 16
    return p3 <= 0 and 0 or p2 / p3;
end;

function u1.KillDeath(p4) -- Line: 25
    if p4.Deaths > 0 then
        return p4.Kills / p4.Deaths;
    end;

    return p4.Kills;
end;

function u1.AverageDamage(p5) -- Line: 31
    -- upvalues: u1 (copy)
    return u1.Divide(p5.DamageDealt, p5.RoundsPlayed);
end;

function u1.CombatScore(p6) -- Line: 37
    -- upvalues: u1 (copy)
    return u1.Divide(p6.CombatScore, p6.RoundsPlayed);
end;

function u1.Kast(p7) -- Line: 43
    -- upvalues: u1 (copy)
    return u1.Divide(p7.KastRounds, p7.RoundsPlayed);
end;

function u1.DamageDelta(p8) -- Line: 50
    -- upvalues: u1 (copy)
    return u1.Divide(p8.DamageDealt - p8.DamageTaken, p8.RoundsPlayed);
end;

function u1.EconomyRating(p9: number, p10: number) -- Line: 56
    -- upvalues: u1 (copy)
    return u1.Divide(p9, p10) * 1000;
end;

function u1.ZoneShare(p11: number, p12: number) -- Line: 63
    -- upvalues: u1 (copy)
    return u1.Divide(p11, p12);
end;

function u1.HeatWeight(p13: number, p14: number) -- Line: 70
    -- upvalues: u1 (copy)
    local v15 = u1.Divide(p13, p14) / u1.AccuracyCeiling;

    return math.clamp(v15, 0, 1);
end;

function u1.FavouriteWeapon(p16: any, p17: string) -- Line: 78
    local v18 = p16.SideWeaponKills[p17];

    if not v18 then
        return nil, 0;
    end;

    local v19 = 0;
    local v20 = nil;

    for i, v in pairs(v18) do
        if v19 < v or v == v19 and (v20 and i < v20) then
            v20 = i;
            v19 = v;
        end;
    end;

    if v19 <= 0 then
        return nil, 0;
    end;

    return v20, v19;
end;

return u1;