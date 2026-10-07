-- ReplicatedStorage.Database.Custom.GameStats.Grenades
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Grenades
-- Decompile time: 0.26 ms

local v1 = game:GetService("RunService"):IsStudio()
return table.freeze({
    ["Decoy Grenade"] = if not v1 then 1 else 99,
    ["Smoke Grenade"] = if not v1 then 1 else 99,
    ["HE Grenade"] = if not v1 then 1 else 99,
    Flashbang = if not v1 then 2 else 99,
    Molotov = if not v1 then 1 else 99,
    ["Incendiary Grenade"] = if not v1 then 1 else 99,
})