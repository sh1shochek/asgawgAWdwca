-- ReplicatedStorage.Database.Custom.GameStats.Missions.Get 15 Assists
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Missions.Get 15 Assists
-- Decompile time: 1.25 ms

-- Decompiled with Potassium's decompiler.

return table.freeze({
    MissionId = "Get 15 Assists",
    DisplayName = "Get 15 Assists In Bomb Defusal Or Hostage Rescue",
    Target = 15,
    Type = "daily",
    Category = "assists",
    Gamemodes = { "Bomb Defusal", "Hostage Rescue" },
    Rewards = { {
            type = "Credits",
            amount = 26
        } }
});