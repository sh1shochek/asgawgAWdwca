-- Decompiled with Potassium's decompiler.

local u1 = {
    HammerUnitToStud = 0.075,
    DefaultBaseSpeed = 18.75,
    TopSpeed = 19.5,
    WalkModifier = 0.52,
    CrouchModifier = 0.34,
    HostageCarryingSpeed = 15,
    WeaponSpeeds = table.freeze({
        ["AK-47"] = 16.125,
        AUG = 16.5,
        AWP = 15,
        ["Butterfly Knife"] = 18.75,
        C4 = 18.75,
        ["CT Knife"] = 18.75,
        ["CZ75-Auto"] = 18,
        ["Decoy Grenade"] = 18.375,
        ["Desert Eagle"] = 17.25,
        ["Dual Berettas"] = 18,
        FAMAS = 16.5,
        ["Five-SeveN"] = 18,
        Flashbang = 18.375,
        ["Flip Knife"] = 18.75,
        G3SG1 = 16.125,
        ["Galil AR"] = 16.125,
        ["Glock-18"] = 18,
        ["Gut Knife"] = 18.75,
        ["HE Grenade"] = 18.375,
        ["Incendiary Grenade"] = 18.375,
        Karambit = 18.75,
        LightSaber = 18.75,
        M249 = 14.625,
        ["M4A1-S"] = 16.875,
        M4A4 = 16.875,
        ["M9 Bayonet"] = 18.75,
        ["MAC-10"] = 18,
        ["MAG-7"] = 16.875,
        ["MP5-SD"] = 17.625,
        MP7 = 16.5,
        MP9 = 18,
        Molotov = 18.375,
        Negev = 11.25,
        Nova = 16.5,
        P2000 = 18,
        P250 = 18,
        P90 = 17.25,
        ["PP-Bizon"] = 18,
        ["R8 Revolver"] = 16.5,
        ["SCAR-20"] = 16.125,
        ["SG 553"] = 15.75,
        ["SSG 08"] = 17.25,
        ["Sawed-Off"] = 15.75,
        ["Skeleton Knife"] = 18.75,
        ["Smoke Grenade"] = 18.375,
        ["Stiletto Knife"] = 18.75,
        ["T Knife"] = 18.75,
        ["Tec-9"] = 18,
        ["UMP-45"] = 17.25,
        ["USP-S"] = 18,
        XM1014 = 16.125,
        ["Zeus x27"] = 16.5
    }),
    ScopedSpeeds = table.freeze({
        ["SSG 08"] = 17.25,
        ["SG 553"] = 11.25,
        AWP = 7.5,
        AUG = 11.25,
        ["SCAR-20"] = 9,
        G3SG1 = 9,
        ["R8 Revolver"] = 13.5
    })
};

function u1.resolveWeaponSpeeds(p2: string?, p3: number?) -- Line: 90
    -- upvalues: u1 (copy)
    local v4;

    if p2 == nil then
        v4 = nil;
    else
        v4 = u1.WeaponSpeeds[p2];
    end;

    local v5 = v4 or u1.DefaultBaseSpeed;

    if v4 == nil and (typeof(p3) == "number" and p3 > 0) then
        v5 = p3 * 0.9282178217821783;
    end;

    local math_clamp_ret = math.clamp(v5, 0, u1.TopSpeed);
    local v6;

    if p2 == nil then
        v6 = nil;
    else
        v6 = u1.ScopedSpeeds[p2];
    end;

    return math_clamp_ret, v6 or math_clamp_ret;
end;

function u1.resolveFromWeaponSpeeds(p7: number, p8: number, p9: boolean?, p10: boolean?) -- Line: 101
    -- upvalues: u1 (copy)
    if p9 ~= true then
        p8 = p7;
    end;

    if p10 == true then
        p8 = math.min(p8, u1.HostageCarryingSpeed);
    end;

    return math.clamp(p8, 0, u1.TopSpeed);
end;

function u1.resolve(p11: table) -- Line: 114
    -- upvalues: u1 (copy)
    local v12, v13 = u1.resolveWeaponSpeeds(p11.WeaponName, p11.WeaponWalkSpeed);

    return u1.resolveFromWeaponSpeeds(v12, v13, p11.IsScoped, p11.CarryingHostage);
end;

return table.freeze(u1);