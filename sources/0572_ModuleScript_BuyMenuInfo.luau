-- Decompiled with Potassium's decompiler.

local table_freeze_ret = table.freeze({
    Color3.fromRGB(72, 193, 66),
    Color3.fromRGB(227, 202, 14),
    Color3.fromRGB(193, 144, 66),
    Color3.fromRGB(208, 62, 65)
});

local function row(p1: number, p2: string, p3: string) -- Line: 20
    return {
        Stars = p1,
        Info = p2,
        Tip = p3
    };
end;

return table.freeze({
    StarColorsByTier = table_freeze_ret,
    Weapons = table.freeze({
        ["AK-47"] = {
            Stars = 4,
            Info = "The classic, accurate, and deadly workhorse",
            Tip = "Consider in full buy rounds"
        },
        AUG = {
            Stars = 3,
            Info = "An optional scope for exceptional accuracy",
            Tip = "Consider in full buy rounds"
        },
        AWP = {
            Stars = 3,
            Info = "Devastating power for the confident sniper",
            Tip = "Consider in full buy rounds"
        },
        ["Decoy Grenade"] = {
            Stars = 3,
            Info = "Mimics a weapon firing sound",
            Tip = "Throw early to confuse the enemy"
        },
        ["Defuse Kit"] = {
            Stars = 1,
            Info = "Cut your defusing time in half",
            Tip = "Don\'t be a loser, buy a defuser!"
        },
        ["Desert Eagle"] = {
            Stars = 4,
            Info = "A lethal headshot at any range",
            Tip = "Consider in eco rounds"
        },
        ["Dual Berettas"] = {
            Stars = 2,
            Info = "Two rapid-fire pistols for the price of one",
            Tip = "Consider in the first round of the half"
        },
        FAMAS = {
            Stars = 3,
            Info = "Cheap but effective against armored enemies",
            Tip = "Consider in force buy rounds"
        },
        ["Five-SeveN"] = {
            Stars = 2,
            Info = "Power, speed, and precision for a price",
            Tip = "Consider in eco rounds"
        },
        Flashbang = {
            Stars = 4,
            Info = "Blinds/deafens nearby players",
            Tip = "Throw prior to an attack"
        },
        ["Galil AR"] = {
            Stars = 3,
            Info = "Cheap but effective against armored enemies",
            Tip = "Consider in force buy rounds"
        },
        ["Glock-18"] = {
            Stars = 2,
            Info = "Deadly up close, just a nuisance at range",
            Tip = "Consider in the first round of the half"
        },
        ["HE Grenade"] = {
            Stars = 3,
            Info = "Deal damage or clear smoke grenades",
            Tip = "Use with discretion"
        },
        ["Incendiary Grenade"] = {
            Stars = 3,
            Info = "Stifles enemy attacks with fire",
            Tip = "Throw at the first sign of trouble"
        },
        Kevlar = {
            Stars = 1,
            Info = "Protects everything but your head",
            Tip = "Consider in the first round of each half"
        },
        ["Kevlar + Helmet"] = {
            Stars = 1,
            Info = "Survive all but the most lethal bullets",
            Tip = "Consider in full buy and force buy rounds"
        },
        ["M4A1-S"] = {
            Stars = 3,
            Info = "Precise, silent, tracer-free",
            Tip = "Consider in full buy rounds"
        },
        M4A4 = {
            Stars = 3,
            Info = "Good accuracy, with ammo to spare",
            Tip = "Consider in full buy rounds"
        },
        ["MAC-10"] = {
            Stars = 1,
            Info = "A run and gun tool for breaching bombsites",
            Tip = "Consider in the first three rounds of the half"
        },
        ["MAG-7"] = {
            Stars = 2,
            Info = "Take the enemy by surprise, reload, repeat!",
            Tip = "Consider in force buy rounds"
        },
        MP9 = {
            Stars = 1,
            Info = "A burst of damage to deny an enemy rush",
            Tip = "Consider in the first three rounds of the half"
        },
        Molotov = {
            Stars = 3,
            Info = "Clears out hiding spots with fire",
            Tip = "Throw before attacking a bombsite"
        },
        Negev = {
            Stars = 4,
            Info = "Pin-point suppressive fire to buy some time",
            Tip = "Consider in force buy rounds"
        },
        Nova = {
            Stars = 2,
            Info = "Versatile shotgun for close quarter combat",
            Tip = "Consider in force buy rounds"
        },
        P250 = {
            Stars = 1,
            Info = "A popular, if modest, damage upgrade",
            Tip = "Consider in eco rounds"
        },
        P90 = {
            Stars = 1,
            Info = "An endless bullet hose bested only by rifles",
            Tip = "Consider in full buy rounds"
        },
        ["R8 Revolver"] = {
            Stars = 4,
            Info = "Deals massive damage after a short delay",
            Tip = "Consider in eco rounds"
        },
        ["Rescue Kit"] = {
            Stars = 1,
            Info = "Cut rescue time when freeing hostages",
            Tip = "Buy on Hostage Rescue as Counter-Terrorist"
        },
        ["SG 553"] = {
            Stars = 3,
            Info = "A lethal weapon made deadlier with a scope",
            Tip = "Consider in full buy rounds"
        },
        ["SSG 08"] = {
            Stars = 4,
            Info = "Light and powerful long-distance damage dealer",
            Tip = "Consider in force buy rounds"
        },
        ["Sawed-Off"] = {
            Stars = 2,
            Info = "High powered shotgun for close engagements",
            Tip = "Consider in force buy rounds"
        },
        ["Smoke Grenade"] = {
            Stars = 3,
            Info = "Creates a large smoke cloud",
            Tip = "Throw to cut off enemy line of sight"
        },
        ["Tec-9"] = {
            Stars = 3,
            Info = "Highly mobile, effective at range and up close",
            Tip = "Consider in eco rounds"
        },
        ["USP-S"] = {
            Stars = 2,
            Info = "Precise, silent, and (somewhat) deadly",
            Tip = "Consider in the first round of the half"
        },
        XM1014 = {
            Stars = 1,
            Info = "A full-auto rapid-fire monster",
            Tip = "Consider in force buy rounds"
        },
        ["Zeus x27"] = {
            Stars = 4,
            Info = "A rechargeable one shot kill at short range",
            Tip = "Attempt at your own risk"
        }
    }),

    GetStarColor = function(p4: number) -- Line: 64, Name: getStarColor
        -- upvalues: table_freeze_ret (copy)
        return table_freeze_ret[p4];
    end
});