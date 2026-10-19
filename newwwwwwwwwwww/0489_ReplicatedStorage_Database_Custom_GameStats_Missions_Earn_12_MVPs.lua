-- Earn 12 MVPs (ModuleScript)
-- full path: ReplicatedStorage.Database.Custom.GameStats.Missions.Earn 12 MVPs

-- Decompiled with Potassium's decompiler.

return table.freeze({
    MissionId = "Earn 12 MVPs",
    DisplayName = "Earn 12 MVPs In Bomb Defusal Or Hostage Rescue",
    Target = 12,
    Type = "daily",
    Category = "mvp",
    Gamemodes = { "Bomb Defusal", "Hostage Rescue" },
    Rewards = { {
            type = "Credits",
            amount = 26
        } }
});