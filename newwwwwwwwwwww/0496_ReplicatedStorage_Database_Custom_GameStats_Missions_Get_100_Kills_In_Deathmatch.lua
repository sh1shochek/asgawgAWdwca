-- Get 100 Kills In Deathmatch (ModuleScript)
-- full path: ReplicatedStorage.Database.Custom.GameStats.Missions.Get 100 Kills In Deathmatch

-- Decompiled with Potassium's decompiler.

return table.freeze({
    MissionId = "Get 100 Kills In Deathmatch",
    Target = 100,
    Type = "weekly",
    Category = "kills",
    Gamemodes = { "Deathmatch" },
    Rewards = { {
            type = "Credits",
            amount = 90
        } }
});