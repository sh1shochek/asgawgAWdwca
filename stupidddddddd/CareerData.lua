-- ReplicatedStorage.Interface.Screens.Menu.Career.CareerData
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.CareerData
-- Decompile time: 8.93 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script.Parent.Types)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Signal = require(ReplicatedStorage.Packages.Signal)
local u27 = table.freeze({"CasualDefusal", "CasualHostage", "Deathmatch", "CompetitiveDefusal", "CompetitiveHostage"})
local u32 = table.freeze({"Counter-Terrorists", "Terrorists"})
u0.Buckets = u27
u0.EconomyTiers = table.freeze({"Pistol", "Eco", "Semi", "Full"})
local u67 = table.freeze({
    "MatchesPlayed",
    "MatchesWon",
    "MatchesLost",
    "MatchesTied",
    "SecondsPlayed",
    "RoundsPlayed",
    "RoundsWon",
    "RoundsSurvived",
    "Kills",
    "Deaths",
    "Assists",
    "HeadshotKills",
    "DamageDealt",
    "DamageTaken",
    "CombatScore",
    "KastRounds",
    "Clutches",
    "FlawlessRounds",
    "AceRounds",
    "RoundMVPs",
    "FirstBloods",
    "Plants",
    "Defuses",
    "Rescues",
    "OvertimeWins",
})
local u75 = table.freeze({"ShotsFired", "ShotsHit", "HeadHits", "BodyHits", "LegHits"})
local u82 = table.freeze({"Kills", "Deaths", "RoundsPlayed", "RoundsWon"})
local u91 = table.freeze({"RoundsPlayed", "RoundsWon", "Kills", "Deaths", "DamageDealt", "KastRounds"})
local u114 = table.freeze({
    "Kills",
    "Damage",
    "Matches",
    "RoundsPlayed",
    "RoundsWon",
    "RankedRoundsPlayed",
    "RankedRoundsWon",
    "CrouchKills",
    "JumpKills",
    "BlindKills",
    "CrouchDamage",
    "JumpDamage",
    "BlindDamage",
    "Assists",
    "DeadAssists",
    "ShotsFired",
    "ShotsHit",
    "HeadshotHits",
    "Reloads",
    "Inspects",
})
local u134 = table.freeze({
    "UserId",
    "AvatarUserId",
    "Kills",
    "Deaths",
    "Assists",
    "MVPs",
    "Score",
    "Money",
    "BadgeFloat",
    "CombatScore",
    "RoundsPlayed",
    "DamageDealt",
    "MoneySpent",
    "FirstBloods",
    "Plants",
    "Defuses",
    "Rescues",
})
u0.Changed = Signal.new()
u0.MatchLoaded = Signal.new()
local u139 = nil
local u140 = {}
local u141 = 0
local u142 = 0
local u143 = false

local function ToNumber(a1) -- Line: 124
    return not (typeof(a1) ~= "number") and a1 or 0
end

local function ToText(a1, a2) -- Line: 130 -- types: a2: string
    return not (typeof(a1) ~= "string") and a1 or a2
end

local function ReadNumbers(a1, a2) -- Line: 137 -- types: a2: table
    local v1, v2
    local v3 = not (typeof(a1) ~= "table") and a1 or {}
    local v4 = {}
    for i, v in ipairs(a2) do
        v1 = v3[v]
        v2 = not (typeof(v1) ~= "number") and v1 or 0
        v4[v] = v2
    end
    return v4
end

local function AddNumbers(a1, a2, a3) -- Line: 148 -- types: a3: table
    local v1, v2, v3
    local v4, v5 = a1, a2
    for i, v in ipairs(a3) do
        v2 = v4[v]
        v1 = v5[v]
        v3 = not (typeof(v1) ~= "number") and v1 or 0
        v4[v] = v2 + v3
    end
end

local function ReadBucket(a1) -- Line: 156
    -- upvalues: ReadNumbers (val), u67 (val), u75 (val), u32 (val), u82 (val), u0 (val), u91 (val), u114 (val)
    local Economy, Sides, v1, v2, v3, v4
    local v5 = not (typeof(a1) ~= "table") and a1 or {}
    local v6 = ReadNumbers(v5, u67)
    v6.Accuracy = ReadNumbers(v5.Accuracy, u75)
    v6.Sides = {}
    v6.SideWeaponKills = {}
    v6.Weapons = {}
    v6.Economy = {}
    for i, v in ipairs(u32) do
        Sides = v6.Sides
        v1 = false
        if typeof(v5.Sides) == "table" then
            v1 = v5.Sides[v]
        end
        Sides[v] = (ReadNumbers(v1, u82))
        v3 = {}
        v4 = false
        if typeof(v5.SideWeaponKills) == "table" then
            v4 = v5.SideWeaponKills[v]
        end
        if typeof(v4) == "table" then
            for k, i2 in pairs(v4) do
                if typeof(k) == "string" then
                    v2 = not (typeof(i2) ~= "number") and i2 or 0
                    v3[k] = v2
                end
            end
        end
        v6.SideWeaponKills[v] = v3
    end
    for i3, j in ipairs(u0.EconomyTiers) do
        Economy = v6.Economy
        v1 = false
        if typeof(v5.Economy) == "table" then
            v1 = v5.Economy[j]
        end
        Economy[j] = (ReadNumbers(v1, u91))
    end
    if typeof(v5.Weapons) == "table" then
        for k2, k3 in pairs(v5.Weapons) do
            if typeof(k2) == "string" and typeof(k3) == "table" then
                v6.Weapons[k2] = (ReadNumbers(k3, u114))
            end
        end
    end
    return v6
end

local function AddBucket(a1, a2) -- Line: 198
    -- upvalues: AddNumbers (val), u67 (val), u75 (val), u32 (val), u82 (val), u0 (val), u91 (val), ReadNumbers (val)
    -- upvalues: u114 (val)
    local v1, v2
    AddNumbers(a1, a2, u67)
    AddNumbers(a1.Accuracy, a2.Accuracy, u75)
    local v3, v4 = a1, a2
    for i, v in ipairs(u32) do
        AddNumbers(v3.Sides[v], v4.Sides[v], u82)
        for k, i2 in pairs(v4.SideWeaponKills[v]) do
            v1 = v3.SideWeaponKills[v]
            v1[k] = (v3.SideWeaponKills[v][k] or 0) + i2
        end
    end
    for i3, j in ipairs(u0.EconomyTiers) do
        AddNumbers(v3.Economy[j], v4.Economy[j], u91)
    end
    for k2, k3 in pairs(v4.Weapons) do
        v2 = v3.Weapons[k2]
        if v2 then
            AddNumbers(v2, k3, u114)
        else
            v3.Weapons[k2] = (ReadNumbers(k3, u114))
        end
    end
end

local function ReadMatchPlayer(a1) -- Line: 225 -- upvalues: ReadNumbers (val), u134 (val)
    local v1 = not (typeof(a1) ~= "table") and a1 or {}
    local v2 = ReadNumbers(v1, u134)
    local Username = v1.Username
    v2.Username = not (typeof(Username) ~= "string") and Username or ""
    local DisplayName = v1.DisplayName
    local Username_2 = v2.Username
    v2.DisplayName = not (typeof(DisplayName) ~= "string") and DisplayName or Username_2
    local Team = v1.Team
    v2.Team = not (typeof(Team) ~= "string") and Team or ""
    local BadgeSkin = v1.BadgeSkin
    v2.BadgeSkin = not (typeof(BadgeSkin) ~= "string") and BadgeSkin or ""
    v2.Disconnected = v1.Disconnected == true
    return v2
end

local function ReadMatch(a1) -- Line: 240 -- upvalues: ReadMatchPlayer (val)
    local v1 = not (typeof(a1) ~= "table") and a1 or {}
    local v2 = {}
    if typeof(v1.Players) == "table" then
        for i, v in ipairs(v1.Players) do
            table.insert(v2, (ReadMatchPlayer(v)))
        end
    end
    local v3 = {}
    local MatchId = v1.MatchId
    v3.MatchId = not (typeof(MatchId) ~= "string") and MatchId or ""
    local CompletedAt = v1.CompletedAt
    v3.CompletedAt = not (typeof(CompletedAt) ~= "number") and CompletedAt or 0
    local Map = v1.Map
    v3.Map = not (typeof(Map) ~= "string") and Map or ""
    local Gamemode = v1.Gamemode
    v3.Gamemode = not (typeof(Gamemode) ~= "string") and Gamemode or ""
    local ServerGamemode = v1.ServerGamemode
    v3.ServerGamemode = not (typeof(ServerGamemode) ~= "string") and ServerGamemode or ""
    local Bucket = v1.Bucket
    v3.Bucket = not (typeof(Bucket) ~= "string") and Bucket or ""
    local Duration = v1.Duration
    v3.Duration = not (typeof(Duration) ~= "number") and Duration or 0
    local Team = v1.Team
    v3.Team = not (typeof(Team) ~= "string") and Team or ""
    local Result = v1.Result
    v3.Result = not (typeof(Result) ~= "string") and Result or "Draw"
    local CTScore = v1.CTScore
    v3.CTScore = not (typeof(CTScore) ~= "number") and CTScore or 0
    local TScore = v1.TScore
    v3.TScore = not (typeof(TScore) ~= "number") and TScore or 0
    local RoundCount = v1.RoundCount
    v3.RoundCount = not (typeof(RoundCount) ~= "number") and RoundCount or 0
    v3.Players = v2
    return v3
end

local function ReadCareerData(a1) -- Line: 269 -- upvalues: u27 (val), ReadBucket (val), ReadMatch (val)
    local v1
    local v2 = not (typeof(a1) ~= "table") and a1 or {}
    local v3 = {}
    for i, v in ipairs(u27) do
        v1 = false
        if typeof(v2.Buckets) == "table" then
            v1 = v2.Buckets[v]
        end
        v3[v] = (ReadBucket(v1))
    end
    local v4 = {}
    if typeof(v2.Matches) == "table" then
        for i2, i3 in ipairs(v2.Matches) do
            table.insert(v4, (ReadMatch(i3)))
        end
    end
    local v5 = {}
    local SchemaVersion = v2.SchemaVersion
    v5.SchemaVersion = not (typeof(SchemaVersion) ~= "number") and SchemaVersion or 0
    v5.Buckets = v3
    v5.Matches = v4
    return v5
end

local function ReadHitZones(a1) -- Line: 294 -- upvalues: ReadNumbers (val)
    return (ReadNumbers(a1, {"Head", "Body", "Legs"}))
end

local function ReadMatchDetails(a1) -- Line: 300 -- upvalues: ReadNumbers (val)
    local v1, v2, v3
    local v4 = not (typeof(a1) ~= "table") and a1 or {}
    local v5 = {}
    if typeof(v4.Rounds) == "table" then
        local Armor, Equip, Round, Weapon, WinType, Winner, v6, v7
        for i, v in ipairs(v4.Rounds) do
            if typeof(v) == "table" then
                v7 = {}
                if typeof(v.Players) == "table" then
                    for i2, i3 in ipairs(v.Players) do
                        v6 = ReadNumbers(i3, {"UserId", "Kills", "Assists", "Deaths", "CombatScore", "MoneySpent"})
                        Equip = i3.Equip
                        v6.Equip = not (typeof(Equip) ~= "string") and Equip or ""
                        Armor = i3.Armor
                        v6.Armor = not (typeof(Armor) ~= "string") and Armor or "No Armor"
                        v6.Survived = i3.Survived == true
                        table.insert(v7, v6)
                    end
                end
                v3 = {}
                if typeof(v.Events) == "table" then
                    for i4, j in ipairs(v.Events) do
                        v2 = ReadNumbers(j, {"Time", "Killer", "Victim", "Distance"})
                        Weapon = j.Weapon
                        v2.Weapon = not (typeof(Weapon) ~= "string") and Weapon or ""
                        v2.Headshot = j.Headshot == true
                        table.insert(v3, v2)
                    end
                end
                v1 = {}
                Round = v.Round
                v1.Round = not (typeof(Round) ~= "number") and Round or 0
                Winner = v.Winner
                v1.Winner = not (typeof(Winner) ~= "string") and Winner or ""
                WinType = v.WinType
                v1.WinType = not (typeof(WinType) ~= "string") and WinType or "Elimination"
                v1.Players = v7
                v1.Events = v3
                table.insert(v5, v1)
            end
        end
    end
    local v8 = {}
    if typeof(v4.Duels) == "table" then
        local Assists, AvatarUserId, BadgeFloat, BadgeSkin, Deaths, DisplayName, Distance, EnemyArmor, EnemyWeapon, Kills, Outcome, Round_2, Team, UserId, Username, Username_2, YourArmor, YourWeapon, v9
        for i5, k in ipairs(v4.Duels) do
            if typeof(k) == "table" then
                v3 = {}
                if typeof(k.Fights) == "table" then
                    for i6, n in ipairs(k.Fights) do
                        v9 = {}
                        Round_2 = n.Round
                        v9.Round = not (typeof(Round_2) ~= "number") and Round_2 or 0
                        v9.RoundWon = n.RoundWon == true
                        Outcome = n.Outcome
                        v9.Outcome = not (typeof(Outcome) ~= "string") and Outcome or "None"
                        YourWeapon = n.YourWeapon
                        v9.YourWeapon = not (typeof(YourWeapon) ~= "string") and YourWeapon or ""
                        YourArmor = n.YourArmor
                        v9.YourArmor = not (typeof(YourArmor) ~= "string") and YourArmor or "No Armor"
                        EnemyWeapon = n.EnemyWeapon
                        v9.EnemyWeapon = not (typeof(EnemyWeapon) ~= "string") and EnemyWeapon or ""
                        EnemyArmor = n.EnemyArmor
                        v9.EnemyArmor = not (typeof(EnemyArmor) ~= "string") and EnemyArmor or "No Armor"
                        Distance = n.Distance
                        v9.Distance = not (typeof(Distance) ~= "number") and Distance or 0
                        v9.DamageDealt = ReadNumbers(n.DamageDealt, {"Head", "Body", "Legs"})
                        v9.DamageTaken = ReadNumbers(n.DamageTaken, {"Head", "Body", "Legs"})
                        table.insert(v3, v9)
                    end
                end
                v1 = {}
                UserId = k.UserId
                v1.UserId = not (typeof(UserId) ~= "number") and UserId or 0
                AvatarUserId = k.AvatarUserId
                v1.AvatarUserId = not (typeof(AvatarUserId) ~= "number") and AvatarUserId or 0
                Username = k.Username
                v1.Username = not (typeof(Username) ~= "string") and Username or ""
                DisplayName = k.DisplayName
                Username_2 = k.Username
                v2 = not (typeof(Username_2) ~= "string") and Username_2 or ""
                v1.DisplayName = not (typeof(DisplayName) ~= "string") and DisplayName or v2
                Team = k.Team
                v1.Team = not (typeof(Team) ~= "string") and Team or ""
                BadgeSkin = k.BadgeSkin
                v1.BadgeSkin = not (typeof(BadgeSkin) ~= "string") and BadgeSkin or ""
                BadgeFloat = k.BadgeFloat
                v1.BadgeFloat = not (typeof(BadgeFloat) ~= "number") and BadgeFloat or 0
                Kills = k.Kills
                v1.Kills = not (typeof(Kills) ~= "number") and Kills or 0
                Deaths = k.Deaths
                v1.Deaths = not (typeof(Deaths) ~= "number") and Deaths or 0
                Assists = k.Assists
                v1.Assists = not (typeof(Assists) ~= "number") and Assists or 0
                v1.Fights = v3
                table.insert(v8, v1)
            end
        end
    end
    local v10 = {}
    local MatchId = v4.MatchId
    v10.MatchId = not (typeof(MatchId) ~= "string") and MatchId or ""
    v10.Rounds = v5
    v10.Duels = v8
    return v10
end

local function Deliver(a1) -- Line: 399 -- upvalues: u139 (ref), ReadCareerData (val), u0 (val)
    u139 = ReadCareerData(a1)
    u0.Changed:Fire(u139)
end

local function DeliverMatch(a1) -- Line: 406 -- upvalues: ReadMatchDetails (val), u140 (val), u0 (val)
    local v1 = ReadMatchDetails(a1)
    if v1.MatchId == "" then
        return
    end
    u140[v1.MatchId] = v1
    u0.MatchLoaded:Fire(v1)
end

function u0.Get() -- Line: 419 -- upvalues: u139 (ref)
    return u139
end

function u0.IsLoaded() -- Line: 425 -- upvalues: u139 (ref)
    return u139 ~= nil
end

function u0.GetBucket(a1) -- Line: 432
    -- upvalues: u139 (ref), ReadBucket (val), u27 (val), AddBucket (val)
    local v1
    local v2 = u139
    if not v2 then
        return (ReadBucket(nil))
    end
    if a1 ~= "All" then
        return v2.Buckets[a1] or ReadBucket(nil)
    end
    local v3 = ReadBucket(nil)
    for i, v in ipairs(u27) do
        v1 = v2.Buckets[v]
        if v1 then
            AddBucket(v3, v1)
        end
    end
    return v3
end

function u0.GetMatch(a1) -- Line: 455 -- upvalues: u139 (ref) -- types: a1: string
    local v1 = u139
    if not v1 then
        return nil
    end
    for i, v in ipairs(v1.Matches) do
        if v.MatchId == a1 then
            return v
        end
    end
    return nil
end

function u0.GetMatchDetails(a1) -- Line: 472 -- upvalues: u140 (val) -- types: a1: string
    return u140[a1]
end

function u0.Request() -- Line: 479 -- upvalues: u141 (ref), Remotes (val)
    local v1 = os.clock()
    if v1 - u141 < 2 then
        return
    end
    u141 = v1
    Remotes.Career.RequestStatistics.Send()
end

function u0.RequestMatchDetails(a1) -- Line: 492 -- upvalues: u140 (val), u142 (ref), Remotes (val) -- types: a1: string
    if a1 ~= "" and not u140[a1] then
        local v1 = os.clock()
        if v1 - u142 < 0.5 then
            task.delay(0.5, function() -- Line: 499 -- upvalues: u140 (upval), a1 (val), u142 (upval), Remotes (upval)
                if not u140[a1] then
                    u142 = os.clock()
                    Remotes.Career.RequestMatchDetails.Send(a1)
                end
            end)
            return
        end
        u142 = v1
        Remotes.Career.RequestMatchDetails.Send(a1)
        return
    end
end

function u0.Listen() -- Line: 514
    -- upvalues: u143 (ref), Remotes (val), Deliver (val), ReadMatchDetails (val), u140 (val), u0 (val)
    if u143 then
        return
    end
    u143 = true
    Remotes.Career.Statistics.Listen(Deliver)
    Remotes.Career.MatchDetails.Listen(function(a1) -- Line: 522 -- upvalues: ReadMatchDetails (upval), u140 (upval), u0 (upval)
        local v1 = ReadMatchDetails(a1)
        if v1.MatchId == "" then
            return
        end
        u140[v1.MatchId] = v1
        u0.MatchLoaded:Fire(v1)
    end)
end

return u0