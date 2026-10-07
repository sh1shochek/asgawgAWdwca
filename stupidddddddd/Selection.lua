-- ReplicatedStorage.Interface.Screens.Menu.Career.Selection
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.Selection
-- Decompile time: 0.42 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
u0.Changed = require(ReplicatedStorage.Packages.Signal).new()
u0.Order = table.freeze({"All", "CasualDefusal", "CasualHostage", "Deathmatch", "CompetitiveDefusal", "CompetitiveHostage"})
u0.Names = table.freeze({
    All = "All Gamemodes",
    CasualDefusal = "Bomb Defusal - Casual",
    CasualHostage = "Hostage Rescue - Casual",
    Deathmatch = "Deathmatch",
    CompetitiveDefusal = "Bomb Defusal - Competitive",
    CompetitiveHostage = "Hostage Rescue - Competitive",
})
u0.Headings = table.freeze({
    All = "LIFETIME STATS",
    CasualDefusal = "CASUAL DEFUSAL STATS",
    CasualHostage = "CASUAL HOSTAGE STATS",
    Deathmatch = "DEATHMATCH STATS",
    CompetitiveDefusal = "COMPETITIVE DEFUSAL STATS",
    CompetitiveHostage = "COMPETITIVE HOSTAGE STATS",
})

function u0.HasRounds(a1) -- Line: 44 -- types: a1: string
    return a1 ~= "Deathmatch"
end

local u28 = "All"

function u0.Get() -- Line: 54 -- upvalues: u28 (ref)
    return u28
end

function u0.Set(a1) -- Line: 60 -- upvalues: u28 (ref), u0 (val) -- types: a1: string
    if u28 ~= a1 and u0.Names[a1] ~= nil then
        u28 = a1
        u0.Changed:Fire(a1)
        return
    end
end

return u0