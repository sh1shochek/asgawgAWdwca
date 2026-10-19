-- Survival (ModuleScript)
-- full path: ReplicatedStorage.Database.Custom.GameStats.Gamemodes.Survival

-- Decompiled with Potassium's decompiler.

return table.freeze({
    Maps = { "Stronghold" },
    Prices = {
        ["HE Grenade"] = 600,
        Flashbang = 400,
        ["Decoy Grenade"] = 100,
        Molotov = 750,
        ["Incendiary Grenade"] = 750,
        Kevlar = 1000,
        ["Kevlar + Helmet"] = 1600,
        Helmet = 600,
        ["SSG 08"] = 3200,
        ["Galil AR"] = 3500,
        FAMAS = 3600,
        ["M4A1-S"] = 4000,
        ["AK-47"] = 4200,
        M4A4 = 4200,
        ["SG 553"] = 4500,
        AUG = 4500,
        Nova = 5000,
        ["Sawed-Off"] = 5000,
        ["MAG-7"] = 5500,
        Negev = 6000,
        XM1014 = 6500,
        AWP = 8000
    },
    HordeWeapons = {
        AWP = {
            PiercesHorde = true,
            DamagePerPart = {
                Head = 1600,
                Torso = 400
            }
        }
    },
    UnsoldItems = {
        ["Smoke Grenade"] = true
    },
    SurvivalOnlyEquipment = {
        Health = true,
        Ammo = true
    }
});