-- ReplicatedStorage.Shared.DamageCalculation
-- Script path: ReplicatedStorage.Shared.DamageCalculation
-- Decompile time: 11.45 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
local u3 = {};

local function RefreshConfig() -- Line: 26
    -- upvalues: u3 (copy), u2 (ref)
    u3.HitboxArmorApply = u2.Get("Damage", "HitboxArmorApply");
    u3.ArmorBonusMultiplier = u2.Get("Damage", "ArmorBonusMultiplier");
    u3.ArmorRatioDivisor = u2.Get("Damage", "ArmorRatioDivisor");
end;

function u1.CalculateArmorDamage(p4: number, p5: number, p6: number, p7: number) -- Line: 36
    local v8 = (p4 - p4 * p6) * p7;
    local v9, v10;

    if p5 < v8 then
        v9 = p4 - p5 / p7;
        v10 = 0;
    else
        v10 = p5 - (v8 < 0 and 1 or v8);
        v9 = p4 * p6;
    end;

    return v9, v10;
end;

function u1.ApplyArmor(p11: number, p12: string?, p13: number?, p14: boolean?, p15: number?) -- Line: 67
    -- upvalues: u3 (copy), u1 (copy)
    local v16 = p13 or 0;
    local v17 = p14 or false;
    local v18 = false;

    if p12 and v16 > 0 then
        local HitboxArmorApply = u3.HitboxArmorApply;

        if HitboxArmorApply and (HitboxArmorApply.ApplyArmor[p12] and (not HitboxArmorApply.RequireHelmet[p12] or v17)) then
            v18 = true;
            local v19;
            p11, v19 = u1.CalculateArmorDamage(p11, v16, u3.ArmorRatioDivisor * (p15 or 1), u3.ArmorBonusMultiplier);
            v16 = math.floor(v19);

            if v16 <= 0 then
                v16 = 0;
                v17 = false;
            end;
        end;
    end;

    return math.floor(p11), v16, v17, v18;
end;

function u1.PainSoundKeys(p20: string?, p21: boolean, p22: boolean, p23: string?) -- Line: 116
    if p20 ~= "Head" or p23 == "Slash" then
        return p21 and "Misc.Kevlar" or "Misc.PlayerDamagebody", nil;
    end;

    if p22 then
        return "Misc.HeadshotArmorE", "Misc.HeadshotArmorFlesh";
    end;

    return "Misc.HeadshotNoarmor", nil;
end;

function u1.Init(p24) -- Line: 130
    -- upvalues: u2 (ref), u3 (copy), RefreshConfig (copy)
    u2 = p24:GetModule("GameConfiguration");
    u3.HitboxArmorApply = u2.Get("Damage", "HitboxArmorApply");
    u3.ArmorBonusMultiplier = u2.Get("Damage", "ArmorBonusMultiplier");
    u3.ArmorRatioDivisor = u2.Get("Damage", "ArmorRatioDivisor");
    u2.Updated:Connect(RefreshConfig);
end;

return u1;