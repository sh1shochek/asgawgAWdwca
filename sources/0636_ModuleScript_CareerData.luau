-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Types);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Signal = require(ReplicatedStorage.Packages.Signal);
local table_freeze_ret = table.freeze({ "CasualDefusal", "CasualHostage", "Deathmatch", "CompetitiveDefusal", "CompetitiveHostage" });
local table_freeze_ret2 = table.freeze({ "Counter-Terrorists", "Terrorists" });
u1.Buckets = table_freeze_ret;
u1.EconomyTiers = table.freeze({ "Pistol", "Eco", "Semi", "Full" });
local table_freeze_ret3 = table.freeze({ "MatchesPlayed", "MatchesWon", "MatchesLost", "MatchesTied", "SecondsPlayed", "RoundsPlayed", "RoundsWon", "RoundsSurvived", "Kills", "Deaths", "Assists", "HeadshotKills", "DamageDealt", "DamageTaken", "CombatScore", "KastRounds", "Clutches", "FlawlessRounds", "AceRounds", "RoundMVPs", "FirstBloods", "Plants", "Defuses", "Rescues", "OvertimeWins" });
local table_freeze_ret4 = table.freeze({ "ShotsFired", "ShotsHit", "HeadHits", "BodyHits", "LegHits" });
local table_freeze_ret5 = table.freeze({ "Kills", "Deaths", "RoundsPlayed", "RoundsWon" });
local table_freeze_ret6 = table.freeze({ "RoundsPlayed", "RoundsWon", "Kills", "Deaths", "DamageDealt", "KastRounds" });
local table_freeze_ret7 = table.freeze({ "Kills", "Damage", "Matches", "RoundsPlayed", "RoundsWon", "RankedRoundsPlayed", "RankedRoundsWon", "CrouchKills", "JumpKills", "BlindKills", "CrouchDamage", "JumpDamage", "BlindDamage", "Assists", "DeadAssists", "ShotsFired", "ShotsHit", "HeadshotHits", "Reloads", "Inspects" });
local table_freeze_ret8 = table.freeze({ "UserId", "AvatarUserId", "Kills", "Deaths", "Assists", "MVPs", "Score", "Money", "BadgeFloat", "CombatScore", "RoundsPlayed", "DamageDealt", "MoneySpent", "FirstBloods", "Plants", "Defuses", "Rescues" });
u1.Changed = Signal.new();
u1.MatchLoaded = Signal.new();
local u2 = nil;
local u3 = {};
local u4 = 0;
local u5 = 0;
local u6 = false;

local function ToNumber(p7) -- Line: 124
    return typeof(p7) == "number" and p7 and p7 or 0;
end;

local function ToText(p8: any, p9: string) -- Line: 130
    return typeof(p8) == "string" and p8 and p8 or p9;
end;

local function ReadNumbers(p10: any, p11: table) -- Line: 137
    local v12 = typeof(p10) == "table" and p10 and p10 or {};
    local v13 = {};

    for _, v in ipairs(p11) do
        local v14 = v12[v];
        v13[v] = typeof(v14) == "number" and v14 and v14 or 0;
    end;

    return v13;
end;

local function AddNumbers(p15: any, p16: any, p17: table) -- Line: 148
    for _, v in ipairs(p17) do
        local v18 = p16[v];
        p15[v] = p15[v] + (typeof(v18) == "number" and v18 and v18 or 0);
    end;
end;

local function ReadBucket(p19) -- Line: 156
    -- upvalues: ReadNumbers (copy), table_freeze_ret3 (copy), table_freeze_ret4 (copy), table_freeze_ret2 (copy), table_freeze_ret5 (copy), u1 (copy), table_freeze_ret6 (copy), table_freeze_ret7 (copy)
    local v20 = typeof(p19) == "table" and p19 and p19 or {};
    local v21 = ReadNumbers(v20, table_freeze_ret3);
    v21.Accuracy = ReadNumbers(v20.Accuracy, table_freeze_ret4);
    v21.Sides = {};
    v21.SideWeaponKills = {};
    v21.Weapons = {};
    v21.Economy = {};

    for _, v in ipairs(table_freeze_ret2) do
        local Sides = v21.Sides;
        local v22;

        if typeof(v20.Sides) == "table" then
            v22 = v20.Sides[v];
        else
            v22 = false;
        end;

        Sides[v] = ReadNumbers(v22, table_freeze_ret5);
        local v23 = {};
        local v24;

        if typeof(v20.SideWeaponKills) == "table" then
            v24 = v20.SideWeaponKills[v];
        else
            v24 = false;
        end;

        local v25;

        if typeof(v24) == "table" then
            v25 = v;

            for i, v2 in pairs(v24) do
                if typeof(i) == "string" then
                    v23[i] = typeof(v2) == "number" and v2 and v2 or 0;
                end;
            end;
        else
            v25 = v;
        end;

        v21.SideWeaponKills[v25] = v23;
    end;

    for _, v in ipairs(u1.EconomyTiers) do
        local Economy = v21.Economy;
        local v26;

        if typeof(v20.Economy) == "table" then
            v26 = v20.Economy[v];
        else
            v26 = false;
        end;

        Economy[v] = ReadNumbers(v26, table_freeze_ret6);
    end;

    if typeof(v20.Weapons) == "table" then
        for i, v in pairs(v20.Weapons) do
            if typeof(i) == "string" and typeof(v) == "table" then
                v21.Weapons[i] = ReadNumbers(v, table_freeze_ret7);
            end;
        end;
    end;

    return v21;
end;

local function AddBucket(p27, p28) -- Line: 198
    -- upvalues: AddNumbers (copy), table_freeze_ret3 (copy), table_freeze_ret4 (copy), table_freeze_ret2 (copy), table_freeze_ret5 (copy), u1 (copy), table_freeze_ret6 (copy), ReadNumbers (copy), table_freeze_ret7 (copy)
    AddNumbers(p27, p28, table_freeze_ret3);
    AddNumbers(p27.Accuracy, p28.Accuracy, table_freeze_ret4);

    for _, v in ipairs(table_freeze_ret2) do
        AddNumbers(p27.Sides[v], p28.Sides[v], table_freeze_ret5);
        local v29 = v;

        for i, v2 in pairs(p28.SideWeaponKills[v]) do
            p27.SideWeaponKills[v29][i] = (p27.SideWeaponKills[v29][i] or 0) + v2;
        end;
    end;

    for _, v in ipairs(u1.EconomyTiers) do
        AddNumbers(p27.Economy[v], p28.Economy[v], table_freeze_ret6);
    end;

    for i, v in pairs(p28.Weapons) do
        local v30 = p27.Weapons[i];

        if v30 then
            AddNumbers(v30, v, table_freeze_ret7);
        else
            p27.Weapons[i] = ReadNumbers(v, table_freeze_ret7);
        end;
    end;
end;

local function ReadMatchPlayer(p31) -- Line: 225
    -- upvalues: ReadNumbers (copy), table_freeze_ret8 (copy)
    local v32 = typeof(p31) == "table" and p31 and p31 or {};
    local v33 = ReadNumbers(v32, table_freeze_ret8);
    local Username = v32.Username;
    v33.Username = typeof(Username) == "string" and Username and Username or "";
    local DisplayName = v32.DisplayName;
    local Username2 = v33.Username;
    v33.DisplayName = typeof(DisplayName) == "string" and DisplayName and DisplayName or Username2;
    local Team = v32.Team;
    v33.Team = typeof(Team) == "string" and Team and Team or "";
    local BadgeSkin = v32.BadgeSkin;
    v33.BadgeSkin = typeof(BadgeSkin) == "string" and BadgeSkin and BadgeSkin or "";
    v33.Disconnected = v32.Disconnected == true;

    return v33;
end;

local function ReadMatch(p34) -- Line: 240
    -- upvalues: ReadMatchPlayer (copy)
    local v35 = typeof(p34) == "table" and p34 and p34 or {};
    local v36 = {};

    if typeof(v35.Players) == "table" then
        for _, v in ipairs(v35.Players) do
            local v37 = ReadMatchPlayer(v);
            table.insert(v36, v37);
        end;
    end;

    local v38 = {};
    local MatchId = v35.MatchId;
    v38.MatchId = typeof(MatchId) == "string" and MatchId and MatchId or "";
    local CompletedAt = v35.CompletedAt;
    v38.CompletedAt = typeof(CompletedAt) == "number" and CompletedAt and CompletedAt or 0;
    local Map = v35.Map;
    v38.Map = typeof(Map) == "string" and Map and Map or "";
    local Gamemode = v35.Gamemode;
    v38.Gamemode = typeof(Gamemode) == "string" and Gamemode and Gamemode or "";
    local ServerGamemode = v35.ServerGamemode;
    v38.ServerGamemode = typeof(ServerGamemode) == "string" and ServerGamemode and ServerGamemode or "";
    local Bucket = v35.Bucket;
    v38.Bucket = typeof(Bucket) == "string" and Bucket and Bucket or "";
    local Duration = v35.Duration;
    v38.Duration = typeof(Duration) == "number" and Duration and Duration or 0;
    local Team = v35.Team;
    v38.Team = typeof(Team) == "string" and Team and Team or "";
    local Result = v35.Result;
    v38.Result = typeof(Result) == "string" and Result and Result or "Draw";
    local CTScore = v35.CTScore;
    v38.CTScore = typeof(CTScore) == "number" and CTScore and CTScore or 0;
    local TScore = v35.TScore;
    v38.TScore = typeof(TScore) == "number" and TScore and TScore or 0;
    local RoundCount = v35.RoundCount;
    v38.RoundCount = typeof(RoundCount) == "number" and RoundCount and RoundCount or 0;
    v38.Players = v36;

    return v38;
end;

local function ReadCareerData(p39) -- Line: 269
    -- upvalues: table_freeze_ret (copy), ReadBucket (copy), ReadMatch (copy)
    local v40 = typeof(p39) == "table" and p39 and p39 or {};
    local v41 = {};

    for _, v in ipairs(table_freeze_ret) do
        local v42;

        if typeof(v40.Buckets) == "table" then
            v42 = v40.Buckets[v];
        else
            v42 = false;
        end;

        v41[v] = ReadBucket(v42);
    end;

    local v43 = {};

    if typeof(v40.Matches) == "table" then
        for _, v in ipairs(v40.Matches) do
            local v44 = ReadMatch(v);
            table.insert(v43, v44);
        end;
    end;

    local v45 = {};
    local SchemaVersion = v40.SchemaVersion;
    v45.SchemaVersion = typeof(SchemaVersion) == "number" and SchemaVersion and SchemaVersion or 0;
    v45.Buckets = v41;
    v45.Matches = v43;

    return v45;
end;

local function ReadHitZones(p46) -- Line: 294
    -- upvalues: ReadNumbers (copy)
    return ReadNumbers(p46, { "Head", "Body", "Legs" });
end;

local function ReadMatchDetails(p47) -- Line: 300
    -- upvalues: ReadNumbers (copy)
    local v48 = typeof(p47) == "table" and p47 and p47 or {};
    local v49 = {};

    if typeof(v48.Rounds) == "table" then
        for _, v in ipairs(v48.Rounds) do
            if typeof(v) == "table" then
                local v50 = {};
                local v51;

                if typeof(v.Players) == "table" then
                    v51 = v;

                    for _, v2 in ipairs(v.Players) do
                        local v52 = ReadNumbers(v2, { "UserId", "Kills", "Assists", "Deaths", "CombatScore", "MoneySpent" });
                        local Equip = v2.Equip;
                        v52.Equip = typeof(Equip) == "string" and Equip and Equip or "";
                        local Armor = v2.Armor;
                        v52.Armor = typeof(Armor) == "string" and Armor and Armor or "No Armor";
                        v52.Survived = v2.Survived == true;
                        table.insert(v50, v52);
                    end;
                else
                    v51 = v;
                end;

                local v53 = {};

                if typeof(v51.Events) == "table" then
                    for _, v2 in ipairs(v51.Events) do
                        local v54 = ReadNumbers(v2, { "Time", "Killer", "Victim", "Distance" });
                        local Weapon = v2.Weapon;
                        v54.Weapon = typeof(Weapon) == "string" and Weapon and Weapon or "";
                        v54.Headshot = v2.Headshot == true;
                        table.insert(v53, v54);
                    end;
                end;

                local v55 = {};
                local Round = v51.Round;
                v55.Round = typeof(Round) == "number" and Round and Round or 0;
                local Winner = v51.Winner;
                v55.Winner = typeof(Winner) == "string" and Winner and Winner or "";
                local WinType = v51.WinType;
                v55.WinType = typeof(WinType) == "string" and WinType and WinType or "Elimination";
                v55.Players = v50;
                v55.Events = v53;
                table.insert(v49, v55);
            end;
        end;
    end;

    local v56 = {};

    if typeof(v48.Duels) == "table" then
        for _, v in ipairs(v48.Duels) do
            if typeof(v) == "table" then
                local v57 = {};
                local v58;

                if typeof(v.Fights) == "table" then
                    v58 = v;

                    for _, v2 in ipairs(v.Fights) do
                        local v59 = {};
                        local Round = v2.Round;
                        v59.Round = typeof(Round) == "number" and Round and Round or 0;
                        v59.RoundWon = v2.RoundWon == true;
                        local Outcome = v2.Outcome;
                        v59.Outcome = typeof(Outcome) == "string" and Outcome and Outcome or "None";
                        local YourWeapon = v2.YourWeapon;
                        v59.YourWeapon = typeof(YourWeapon) == "string" and YourWeapon and YourWeapon or "";
                        local YourArmor = v2.YourArmor;
                        v59.YourArmor = typeof(YourArmor) == "string" and YourArmor and YourArmor or "No Armor";
                        local EnemyWeapon = v2.EnemyWeapon;
                        v59.EnemyWeapon = typeof(EnemyWeapon) == "string" and EnemyWeapon and EnemyWeapon or "";
                        local EnemyArmor = v2.EnemyArmor;
                        v59.EnemyArmor = typeof(EnemyArmor) == "string" and EnemyArmor and EnemyArmor or "No Armor";
                        local Distance = v2.Distance;
                        v59.Distance = typeof(Distance) == "number" and Distance and Distance or 0;
                        v59.DamageDealt = ReadNumbers(v2.DamageDealt, { "Head", "Body", "Legs" });
                        v59.DamageTaken = ReadNumbers(v2.DamageTaken, { "Head", "Body", "Legs" });
                        table.insert(v57, v59);
                    end;
                else
                    v58 = v;
                end;

                local v60 = {};
                local UserId = v58.UserId;
                v60.UserId = typeof(UserId) == "number" and UserId and UserId or 0;
                local AvatarUserId = v58.AvatarUserId;
                v60.AvatarUserId = typeof(AvatarUserId) == "number" and AvatarUserId and AvatarUserId or 0;
                local Username = v58.Username;
                v60.Username = typeof(Username) == "string" and Username and Username or "";
                local DisplayName = v58.DisplayName;
                local Username2 = v58.Username;
                local v61 = typeof(Username2) == "string" and Username2 and Username2 or "";
                v60.DisplayName = typeof(DisplayName) == "string" and DisplayName and DisplayName or v61;
                local Team = v58.Team;
                v60.Team = typeof(Team) == "string" and Team and Team or "";
                local BadgeSkin = v58.BadgeSkin;
                v60.BadgeSkin = typeof(BadgeSkin) == "string" and BadgeSkin and BadgeSkin or "";
                local BadgeFloat = v58.BadgeFloat;
                v60.BadgeFloat = typeof(BadgeFloat) == "number" and BadgeFloat and BadgeFloat or 0;
                local Kills = v58.Kills;
                v60.Kills = typeof(Kills) == "number" and Kills and Kills or 0;
                local Deaths = v58.Deaths;
                v60.Deaths = typeof(Deaths) == "number" and Deaths and Deaths or 0;
                local Assists = v58.Assists;
                v60.Assists = typeof(Assists) == "number" and Assists and Assists or 0;
                v60.Fights = v57;
                table.insert(v56, v60);
            end;
        end;
    end;

    local v62 = {};
    local MatchId = v48.MatchId;
    v62.MatchId = typeof(MatchId) == "string" and MatchId and MatchId or "";
    v62.Rounds = v49;
    v62.Duels = v56;

    return v62;
end;

local function Deliver(p63) -- Line: 399
    -- upvalues: u2 (ref), ReadCareerData (copy), u1 (copy)
    u2 = ReadCareerData(p63);
    u1.Changed:Fire(u2);
end;

local function DeliverMatch(p64) -- Line: 406
    -- upvalues: ReadMatchDetails (copy), u3 (copy), u1 (copy)
    local v65 = ReadMatchDetails(p64);

    if v65.MatchId == "" then
        return;
    end;

    u3[v65.MatchId] = v65;
    u1.MatchLoaded:Fire(v65);
end;

function u1.Get() -- Line: 419
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.IsLoaded() -- Line: 425
    -- upvalues: u2 (ref)
    return u2 ~= nil;
end;

function u1.GetBucket(p66: string) -- Line: 432
    -- upvalues: u2 (ref), ReadBucket (copy), table_freeze_ret (copy), AddBucket (copy)
    local v67 = u2;

    if not v67 then
        return ReadBucket(nil);
    end;

    if p66 ~= "All" then
        return v67.Buckets[p66] or ReadBucket(nil);
    end;

    local v68 = ReadBucket(nil);

    for _, v in ipairs(table_freeze_ret) do
        local v69 = v67.Buckets[v];

        if v69 then
            AddBucket(v68, v69);
        end;
    end;

    return v68;
end;

function u1.GetMatch(p70: string) -- Line: 455
    -- upvalues: u2 (ref)
    local v71 = u2;

    if not v71 then
        return nil;
    end;

    for _, v in ipairs(v71.Matches) do
        if v.MatchId == p70 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetMatchDetails(p72: string) -- Line: 472
    -- upvalues: u3 (copy)
    return u3[p72];
end;

function u1.Request() -- Line: 479
    -- upvalues: u4 (ref), Remotes (copy)
    local os_clock_ret = os.clock();

    if os_clock_ret - u4 < 2 then
        return;
    end;

    u4 = os_clock_ret;
    Remotes.Career.RequestStatistics.Send();
end;

function u1.RequestMatchDetails(u73: string) -- Line: 492
    -- upvalues: u3 (copy), u5 (ref), Remotes (copy)
    if u73 == "" or u3[u73] then
        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - u5 < 0.5 then
        task.delay(0.5, function() -- Line: 499
            -- upvalues: u3 (ref), u73 (copy), u5 (ref), Remotes (ref)
            if not u3[u73] then
                u5 = os.clock();
                Remotes.Career.RequestMatchDetails.Send(u73);
            end;
        end);

        return;
    end;

    u5 = os_clock_ret;
    Remotes.Career.RequestMatchDetails.Send(u73);
end;

function u1.Listen() -- Line: 514
    -- upvalues: u6 (ref), Remotes (copy), Deliver (copy), ReadMatchDetails (copy), u3 (copy), u1 (copy)
    if u6 then
        return;
    end;

    u6 = true;
    Remotes.Career.Statistics.Listen(Deliver);
    Remotes.Career.MatchDetails.Listen(function(p74) -- Line: 522
        -- upvalues: ReadMatchDetails (ref), u3 (ref), u1 (ref)
        local v75 = ReadMatchDetails(p74);

        if v75.MatchId == "" then
            return;
        end;

        u3[v75.MatchId] = v75;
        u1.MatchLoaded:Fire(v75);
    end);
end;

return u1;