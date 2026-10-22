-- ReplicatedStorage.Shared.Data.AchievementsData
-- Script path: ReplicatedStorage.Shared.Data.AchievementsData
-- Decompile time: 4.13 ms

-- Decompiled with Potassium's decompiler.

return {
    ["First Blood"] = {
        Description = "Get your first kill",
        Icon = 1084722537,
        Type = "Kills",
        Amount = 1,
        Rewards = { { "Credits", 10 } }
    },
    ["First Game"] = {
        Description = "Get 20 kills",
        Icon = 10511855986,
        Type = "Kills",
        Amount = 20,
        Rewards = { { "Credits", 50 }, { "Item", "AK-47_Stock" } }
    },
    Newgen = {
        Description = "Play for 1 minute",
        Icon = 78447822,
        Type = "Playtime",
        Amount = 5,
        Rewards = { { "Credits", 10 }, { "XP", 10 } }
    },
    Player = {
        Description = "Play for 10 minutes",
        Icon = 469008770,
        Type = "Playtime",
        Amount = 600,
        Rewards = { { "Credits", 50 } }
    }
};