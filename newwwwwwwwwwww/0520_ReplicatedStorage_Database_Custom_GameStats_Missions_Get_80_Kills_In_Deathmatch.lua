-- Get 80 Kills In Deathmatch (ModuleScript)
-- full path: ReplicatedStorage.Database.Custom.GameStats.Missions.Get 80 Kills In Deathmatch

-- Decompiled with Potassium's decompiler.

return table.freeze({
    MissionId = "Get 80 Kills In Deathmatch",
    Target = 80,
    Type = "daily",
    Category = "kills",
    Gamemodes = { "Deathmatch" },
    Rewards = { {
            type = "Credits",
            amount = 24
        } }
});