-- ReplicatedStorage.Database.Custom.GameStats.NumberSlots
-- Script path: ReplicatedStorage.Database.Custom.GameStats.NumberSlots
-- Decompile time: 0.21 ms

game:GetService("ReplicatedStorage")
return (table.freeze({
    Primary = 1,
    Secondary = 2,
    Melee = 3,
    Grenade = 4,
    C4 = 5,
    Priorities = {3, 2, 0, 1, 1},
}))