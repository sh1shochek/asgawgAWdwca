-- ReplicatedStorage.Interface.Screens.Menu.Career.Derive
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.Derive
-- Decompile time: 0.84 ms

local u0 = {}
require(script.Parent.Types)
u0.AccuracyCeiling = 0.4

function u0.Divide(a1, a2) -- Line: 16 -- types: a1: number, a2: number
    if a2 <= 0 then
        return 0
    end
    return a1 / a2
end

function u0.KillDeath(a1) -- Line: 25
    if 0 < a1.Deaths then
        return a1.Kills / a1.Deaths
    end
    return a1.Kills
end

function u0.AverageDamage(a1) -- Line: 31 -- upvalues: u0 (val)
    return u0.Divide(a1.DamageDealt, a1.RoundsPlayed)
end

function u0.CombatScore(a1) -- Line: 37 -- upvalues: u0 (val)
    return u0.Divide(a1.CombatScore, a1.RoundsPlayed)
end

function u0.Kast(a1) -- Line: 43 -- upvalues: u0 (val)
    return u0.Divide(a1.KastRounds, a1.RoundsPlayed)
end

function u0.DamageDelta(a1) -- Line: 50 -- upvalues: u0 (val)
    return u0.Divide(a1.DamageDealt - a1.DamageTaken, a1.RoundsPlayed)
end

function u0.EconomyRating(a1, a2) -- Line: 56 -- upvalues: u0 (val) -- types: a1: number, a2: number
    return u0.Divide(a1, a2) * 1000
end

function u0.ZoneShare(a1, a2) -- Line: 63 -- upvalues: u0 (val) -- types: a1: number, a2: number
    return u0.Divide(a1, a2)
end

function u0.HeatWeight(a1, a2) -- Line: 70 -- upvalues: u0 (val) -- types: a1: number, a2: number
    return (math.clamp(u0.Divide(a1, a2) / u0.AccuracyCeiling, 0, 1))
end

function u0.FavouriteWeapon(a1, a2) -- Line: 78 -- types: a2: string
    local v1 = a1.SideWeaponKills[a2]
    if not v1 then
        return nil, 0
    end
    local v2 = nil
    local v3 = 0
    for k, v in pairs(v1) do
        if v3 < v or v == v3 and v2 and k < v2 then
            v2 = k
            v3 = v
        end
    end
    if v3 <= 0 then
        return nil, 0
    end
    return v2, v3
end

return u0