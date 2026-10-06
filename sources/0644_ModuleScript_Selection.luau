-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
u1.Changed = require(ReplicatedStorage.Packages.Signal).new();
u1.Order = table.freeze({ "All", "CasualDefusal", "CasualHostage", "Deathmatch", "CompetitiveDefusal", "CompetitiveHostage" });
u1.Names = table.freeze({
    All = "All Gamemodes",
    CasualDefusal = "Bomb Defusal - Casual",
    CasualHostage = "Hostage Rescue - Casual",
    Deathmatch = "Deathmatch",
    CompetitiveDefusal = "Bomb Defusal - Competitive",
    CompetitiveHostage = "Hostage Rescue - Competitive"
});
u1.Headings = table.freeze({
    All = "LIFETIME STATS",
    CasualDefusal = "CASUAL DEFUSAL STATS",
    CasualHostage = "CASUAL HOSTAGE STATS",
    Deathmatch = "DEATHMATCH STATS",
    CompetitiveDefusal = "COMPETITIVE DEFUSAL STATS",
    CompetitiveHostage = "COMPETITIVE HOSTAGE STATS"
});

function u1.HasRounds(p2: string) -- Line: 44
    return p2 ~= "Deathmatch";
end;

local u3 = "All";

function u1.Get() -- Line: 54
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.Set(p4: string) -- Line: 60
    -- upvalues: u3 (ref), u1 (copy)
    if u3 == p4 or u1.Names[p4] == nil then
        return;
    end;

    u3 = p4;
    u1.Changed:Fire(p4);
end;

return u1;