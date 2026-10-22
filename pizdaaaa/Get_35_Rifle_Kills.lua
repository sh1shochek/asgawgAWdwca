-- ReplicatedStorage.Database.Custom.GameStats.Missions.Get 35 Rifle Kills
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Missions.Get 35 Rifle Kills
-- Decompile time: 5.14 ms

-- Decompiled with Potassium's decompiler.

return table.freeze({
    MissionId = "Get 35 Rifle Kills",
    DisplayName = "Get 35 Rifle Kills In Bomb Defusal Or Hostage Rescue",
    Target = 35,
    Type = "daily",
    Category = "rifle_kills",
    Gamemodes = { "Bomb Defusal", "Hostage Rescue" },
    Rewards = { {
            type = "Credits",
            amount = 22
        } }
});