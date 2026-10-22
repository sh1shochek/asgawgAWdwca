-- ReplicatedStorage.Shared.Data.ChallengesData
-- Script path: ReplicatedStorage.Shared.Data.ChallengesData
-- Decompile time: 9.80 ms

-- Decompiled with Potassium's decompiler.

return {
    Challenges = {
        Hourly = {
            Order = 1,
            Free = 4,
            Premium = 0,
            Limit = 2,
            RerollProduct = 3716858171
        },
        Daily = {
            Order = 2,
            Free = 4,
            Premium = 0,
            Limit = 2,
            RerollProduct = 3714924554
        },
        Weekly = {
            Order = 3,
            Free = 4,
            Premium = 0,
            Limit = 2,
            RerollProduct = 3714924922
        },
        Monthly = {
            Order = 4,
            Free = 4,
            Premium = 0,
            Limit = 1,
            RerollProduct = 3716859593
        }
    },
    Hourly = {
        ["Quick Draw"] = {
            Description = "Get 5 kills",
            Type = "Kills",
            Amount = 5,
            Rewards = { { "Credits", 3 } }
        },
        Sharpshooter = {
            Description = "Get 2 headshot kills",
            Type = "Kills",
            Amount = 2,
            Headshot = true,
            Rewards = { { "Credits", 4 } }
        },
        ["Round Winner"] = {
            Description = "Win 3 rounds",
            Type = "RoundsWon",
            Amount = 3,
            Rewards = { { "Credits", 3 } }
        },
        Survivor = {
            Description = "Survive 2 rounds",
            Type = "RoundsSurvived",
            Amount = 2,
            Rewards = { { "Credits", 3 } }
        },
        ["Team Player"] = {
            Description = "Get 2 assists",
            Type = "Assists",
            Amount = 2,
            Rewards = { { "Credits", 3 } }
        },
        ["Damage Dealer"] = {
            Description = "Deal 500 damage",
            Type = "Damage",
            Amount = 500,
            Rewards = { { "Credits", 3 } }
        },
        Spotlight = {
            Description = "Earn a round MVP",
            Type = "MVPs",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        },
        ["Pistol Round"] = {
            Description = "Get 2 pistol kills",
            Type = "Kills",
            Amount = 2,
            Class = "Pistol",
            Rewards = { { "Credits", 4 } }
        },
        Rifleman = {
            Description = "Get 3 rifle kills",
            Type = "Kills",
            Amount = 3,
            Class = "Rifle",
            Rewards = { { "Credits", 4 } }
        },
        ["Double Up"] = {
            Description = "Get a double kill",
            Type = "DoubleKills",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        },
        ["First Contact"] = {
            Description = "Get the first kill of a round",
            Type = "EntryKills",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        },
        Planted = {
            Description = "Plant the bomb",
            Type = "BombPlants",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        },
        ["Clean Sweep"] = {
            Description = "Win a round without losing a teammate",
            Type = "FlawlessRounds",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        },
        ["Close Range"] = {
            Description = "Get 2 SMG kills",
            Type = "Kills",
            Amount = 2,
            Class = "SMG",
            Rewards = { { "Credits", 3 } }
        },
        ["Pump Action"] = {
            Description = "Get 2 shotgun kills",
            Type = "Kills",
            Amount = 2,
            Class = "Shotgun",
            Rewards = { { "Credits", 4 } }
        },
        Scout = {
            Description = "Get a sniper kill",
            Type = "Kills",
            Amount = 1,
            Class = "Sniper",
            Rewards = { { "Credits", 4 } }
        },
        Stab = {
            Description = "Get a knife kill",
            Type = "Kills",
            Amount = 1,
            Class = "Melee",
            Rewards = { { "Credits", 4 } }
        },
        Defender = {
            Description = "Defuse the bomb",
            Type = "BombDefuses",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        },
        ["Low Blow"] = {
            Description = "Get a kill with less than 25 HP",
            Type = "LowHealthKills",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        },
        Intercept = {
            Description = "Kill the bomb carrier",
            Type = "BombCarrierKills",
            Amount = 1,
            Rewards = { { "Credits", 4 } }
        }
    },
    Daily = {
        ["Warm Up"] = {
            Description = "Get 10 kills",
            Type = "Kills",
            Amount = 10,
            Rewards = { { "Credits", 5 } }
        },
        Bloodbath = {
            Description = "Get 20 kills",
            Type = "Kills",
            Amount = 20,
            Rewards = { { "Credits", 10 } }
        },
        Victory = {
            Description = "Win a match",
            Type = "Wins",
            Amount = 1,
            Rewards = { { "Credits", 8 } }
        },
        ["Winning Streak"] = {
            Description = "Win 2 matches",
            Type = "Wins",
            Amount = 2,
            Rewards = { { "Credits", 13 } }
        },
        Regular = {
            Description = "Play 2 matches",
            Type = "Matches",
            Amount = 2,
            Rewards = { { "Credits", 8 } }
        },
        ["Round Up"] = {
            Description = "Win 8 rounds",
            Type = "RoundsWon",
            Amount = 8,
            Rewards = { { "Credits", 5 } }
        },
        ["Still Standing"] = {
            Description = "Survive 5 rounds",
            Type = "RoundsSurvived",
            Amount = 5,
            Rewards = { { "Credits", 5 } }
        },
        ["Helping Hand"] = {
            Description = "Get 5 assists",
            Type = "Assists",
            Amount = 5,
            Rewards = { { "Credits", 5 } }
        },
        ["Heavy Hitter"] = {
            Description = "Deal 1500 damage",
            Type = "Damage",
            Amount = 1500,
            Rewards = { { "Credits", 8 } }
        },
        Headhunter = {
            Description = "Get 5 headshot kills",
            Type = "Kills",
            Amount = 5,
            Headshot = true,
            Rewards = { { "Credits", 8 } }
        },
        ["Most Valuable"] = {
            Description = "Earn 2 round MVPs",
            Type = "MVPs",
            Amount = 2,
            Rewards = { { "Credits", 10 } }
        },
        Demolition = {
            Description = "Plant the bomb 2 times",
            Type = "BombPlants",
            Amount = 2,
            Rewards = { { "Credits", 8 } }
        },
        ["Wire Cutter"] = {
            Description = "Defuse the bomb",
            Type = "BombDefuses",
            Amount = 1,
            Rewards = { { "Credits", 8 } }
        },
        ["Double Trouble"] = {
            Description = "Get 3 double kills",
            Type = "DoubleKills",
            Amount = 3,
            Rewards = { { "Credits", 10 } }
        },
        ["Triple Threat"] = {
            Description = "Get a triple kill",
            Type = "TripleKills",
            Amount = 1,
            Rewards = { { "Credits", 10 } }
        },
        ["Quad Damage"] = {
            Description = "Get a quad kill",
            Type = "QuadKills",
            Amount = 1,
            Rewards = { { "Credits", 18 } }
        },
        ["Opening Pick"] = {
            Description = "Get the first kill of the round 2 times",
            Type = "EntryKills",
            Amount = 2,
            Rewards = { { "Credits", 10 } }
        },
        ["Last Man Standing"] = {
            Description = "Win a round as the last one alive on your team",
            Type = "Clutches",
            Amount = 1,
            Rewards = { { "Credits", 15 } }
        },
        Flawless = {
            Description = "Win 2 rounds without losing a teammate",
            Type = "FlawlessRounds",
            Amount = 2,
            Rewards = { { "Credits", 10 } }
        },
        ["Close Call"] = {
            Description = "Get 2 kills with less than 25 HP",
            Type = "LowHealthKills",
            Amount = 2,
            Rewards = { { "Credits", 10 } }
        },
        ["Carrier Down"] = {
            Description = "Kill the bomb carrier 2 times",
            Type = "BombCarrierKills",
            Amount = 2,
            Rewards = { { "Credits", 10 } }
        },
        Denied = {
            Description = "Kill an enemy while they are defusing",
            Type = "DefuserKills",
            Amount = 1,
            Rewards = { { "Credits", 15 } }
        },
        Sidearm = {
            Description = "Get 5 pistol kills",
            Type = "Kills",
            Amount = 5,
            Class = "Pistol",
            Rewards = { { "Credits", 8 } }
        },
        ["Spray Control"] = {
            Description = "Get 8 rifle kills",
            Type = "Kills",
            Amount = 8,
            Class = "Rifle",
            Rewards = { { "Credits", 8 } }
        },
        ["Run And Gun"] = {
            Description = "Get 6 SMG kills",
            Type = "Kills",
            Amount = 6,
            Class = "SMG",
            Rewards = { { "Credits", 8 } }
        },
        ["Close Quarters"] = {
            Description = "Get 4 shotgun kills",
            Type = "Kills",
            Amount = 4,
            Class = "Shotgun",
            Rewards = { { "Credits", 10 } }
        },
        ["Scoped In"] = {
            Description = "Get 4 sniper kills",
            Type = "Kills",
            Amount = 4,
            Class = "Sniper",
            Rewards = { { "Credits", 10 } }
        },
        ["Knife Party"] = {
            Description = "Get 2 knife kills",
            Type = "Kills",
            Amount = 2,
            Class = "Melee",
            Rewards = { { "Credits", 15 } }
        },
        Kalashnikov = {
            Description = "Get 6 kills with the AK-47",
            Type = "Kills",
            Amount = 6,
            Weapon = "AK-47",
            Rewards = { { "Credits", 8 } }
        },
        ["Four Four"] = {
            Description = "Get 6 kills with the M4A4",
            Type = "Kills",
            Amount = 6,
            Weapon = "M4A4",
            Rewards = { { "Credits", 8 } }
        },
        ["Hand Cannon"] = {
            Description = "Get 3 kills with the Desert Eagle",
            Type = "Kills",
            Amount = 3,
            Weapon = "Desert Eagle",
            Rewards = { { "Credits", 10 } }
        },
        ["One Shot"] = {
            Description = "Get 3 kills with the AWP",
            Type = "Kills",
            Amount = 3,
            Weapon = "AWP",
            Rewards = { { "Credits", 10 } }
        },
        Wallbanger = {
            Description = "Get 2 kills through a wall",
            Type = "Kills",
            Amount = 2,
            Wallbang = true,
            Rewards = { { "Credits", 13 } }
        },
        ["Jump Shot"] = {
            Description = "Get 2 kills while airborne",
            Type = "Kills",
            Amount = 2,
            Airborne = true,
            Rewards = { { "Credits", 15 } }
        },
        ["No Scope"] = {
            Description = "Get a no-scope sniper kill",
            Type = "Kills",
            Amount = 1,
            NoScope = true,
            Rewards = { { "Credits", 18 } }
        },
        Pinpoint = {
            Description = "Get 10 headshot kills",
            Type = "Kills",
            Amount = 10,
            Headshot = true,
            Rewards = { { "Credits", 10 } }
        },
        Marathon = {
            Description = "Play 4 matches",
            Type = "Matches",
            Amount = 4,
            Rewards = { { "Credits", 13 } }
        },
        ["Hold The Line"] = {
            Description = "Win 5 rounds as a Counter-Terrorist",
            Type = "RoundsWon",
            Amount = 5,
            Team = "CT",
            Rewards = { { "Credits", 8 } }
        },
        Detonator = {
            Description = "Win 5 rounds as a Terrorist",
            Type = "RoundsWon",
            Amount = 5,
            Team = "T",
            Rewards = { { "Credits", 8 } }
        },
        ["Mow Down"] = {
            Description = "Deal 3000 damage",
            Type = "Damage",
            Amount = 3000,
            Rewards = { { "Credits", 10 } }
        },
        ["Support Role"] = {
            Description = "Get 10 assists",
            Type = "Assists",
            Amount = 10,
            Rewards = { { "Credits", 10 } }
        },
        ["Peek-A-Boo"] = {
            Description = "Get a headshot kill through a wall",
            Type = "Kills",
            Amount = 1,
            Wallbang = true,
            Headshot = true,
            Rewards = { { "Credits", 13 } }
        },
        ["Air Strike"] = {
            Description = "Get a headshot kill while airborne",
            Type = "Kills",
            Amount = 1,
            Airborne = true,
            Headshot = true,
            Rewards = { { "Credits", 15 } }
        },
        ["Dust Off"] = {
            Description = "Win a match on Dust II",
            Type = "Wins",
            Amount = 1,
            Map = "de_dust2",
            Rewards = { { "Credits", 8 } }
        },
        ["Shore Leave"] = {
            Description = "Win a match on Seaside",
            Type = "Wins",
            Amount = 1,
            Map = "de_seaside",
            Rewards = { { "Credits", 8 } }
        },
        Skyscraper = {
            Description = "Win a match on Vertigo",
            Type = "Wins",
            Amount = 1,
            Map = "de_vertigo",
            Rewards = { { "Credits", 8 } }
        }
    },
    Weekly = {
        Champion = {
            Description = "Win 8 matches",
            Type = "Wins",
            Amount = 8,
            Rewards = { { "Credits", 75 } }
        },
        Dedicated = {
            Description = "Play 15 matches",
            Type = "Matches",
            Amount = 15,
            Rewards = { { "Credits", 55 } }
        },
        Centurion = {
            Description = "Get 175 kills",
            Type = "Kills",
            Amount = 175,
            Rewards = { { "Credits", 75 } }
        },
        Headmaster = {
            Description = "Get 70 headshot kills",
            Type = "Kills",
            Amount = 70,
            Headshot = true,
            Rewards = { { "Credits", 75 } }
        },
        Conqueror = {
            Description = "Win 80 rounds",
            Type = "RoundsWon",
            Amount = 80,
            Rewards = { { "Credits", 55 } }
        },
        ["Wrecking Ball"] = {
            Description = "Deal 25000 damage",
            Type = "Damage",
            Amount = 25000,
            Rewards = { { "Credits", 75 } }
        },
        Untouchable = {
            Description = "Survive 65 rounds",
            Type = "RoundsSurvived",
            Amount = 65,
            Rewards = { { "Credits", 55 } }
        },
        Ace = {
            Description = "Get 2 aces (5 kills in one round)",
            Type = "Aces",
            Amount = 2,
            Rewards = { { "Credits", 85 } }
        },
        ["Multi Killer"] = {
            Description = "Get 25 double kills",
            Type = "DoubleKills",
            Amount = 25,
            Rewards = { { "Credits", 55 } }
        },
        Rampage = {
            Description = "Get 6 triple kills",
            Type = "TripleKills",
            Amount = 6,
            Rewards = { { "Credits", 75 } }
        },
        ["Ice Cold"] = {
            Description = "Win 5 rounds as the last one alive on your team",
            Type = "Clutches",
            Amount = 5,
            Rewards = { { "Credits", 85 } }
        },
        ["First Strike"] = {
            Description = "Get the first kill of the round 20 times",
            Type = "EntryKills",
            Amount = 20,
            Rewards = { { "Credits", 75 } }
        },
        ["Star Player"] = {
            Description = "Earn 18 round MVPs",
            Type = "MVPs",
            Amount = 18,
            Rewards = { { "Credits", 75 } }
        },
        ["Bomb Expert"] = {
            Description = "Plant the bomb 15 times",
            Type = "BombPlants",
            Amount = 15,
            Rewards = { { "Credits", 55 } }
        },
        ["Defuse Master"] = {
            Description = "Defuse the bomb 8 times",
            Type = "BombDefuses",
            Amount = 8,
            Rewards = { { "Credits", 55 } }
        },
        ["Perfect Team"] = {
            Description = "Win 15 rounds without losing a teammate",
            Type = "FlawlessRounds",
            Amount = 15,
            Rewards = { { "Credits", 55 } }
        },
        ["Iron Will"] = {
            Description = "Get 15 kills with less than 25 HP",
            Type = "LowHealthKills",
            Amount = 15,
            Rewards = { { "Credits", 75 } }
        },
        Bodyguard = {
            Description = "Kill the bomb carrier 15 times",
            Type = "BombCarrierKills",
            Amount = 15,
            Rewards = { { "Credits", 55 } }
        },
        ["Last Word"] = {
            Description = "Kill 8 enemies while they are defusing",
            Type = "DefuserKills",
            Amount = 8,
            Rewards = { { "Credits", 85 } }
        },
        Butcher = {
            Description = "Get 15 knife kills",
            Type = "Kills",
            Amount = 15,
            Class = "Melee",
            Rewards = { { "Credits", 85 } }
        },
        Marksman = {
            Description = "Get 40 sniper kills",
            Type = "Kills",
            Amount = 40,
            Class = "Sniper",
            Rewards = { { "Credits", 75 } }
        },
        Pistoleer = {
            Description = "Get 50 pistol kills",
            Type = "Kills",
            Amount = 50,
            Class = "Pistol",
            Rewards = { { "Credits", 55 } }
        },
        Buzzsaw = {
            Description = "Get 50 SMG kills",
            Type = "Kills",
            Amount = 50,
            Class = "SMG",
            Rewards = { { "Credits", 55 } }
        },
        Boomstick = {
            Description = "Get 35 shotgun kills",
            Type = "Kills",
            Amount = 35,
            Class = "Shotgun",
            Rewards = { { "Credits", 75 } }
        },
        ["AK Mastery"] = {
            Description = "Get 80 kills with the AK-47",
            Type = "Kills",
            Amount = 80,
            Weapon = "AK-47",
            Rewards = { { "Credits", 75 } }
        },
        ["M4 Mastery"] = {
            Description = "Get 80 kills with the M4A4",
            Type = "Kills",
            Amount = 80,
            Weapon = "M4A4",
            Rewards = { { "Credits", 75 } }
        },
        ["AWP Mastery"] = {
            Description = "Get 40 kills with the AWP",
            Type = "Kills",
            Amount = 40,
            Weapon = "AWP",
            Rewards = { { "Credits", 75 } }
        },
        ["Deagle Mastery"] = {
            Description = "Get 35 kills with the Desert Eagle",
            Type = "Kills",
            Amount = 35,
            Weapon = "Desert Eagle",
            Rewards = { { "Credits", 75 } }
        },
        ["Wall Breaker"] = {
            Description = "Get 18 kills through a wall",
            Type = "Kills",
            Amount = 18,
            Wallbang = true,
            Rewards = { { "Credits", 75 } }
        },
        ["Sky High"] = {
            Description = "Get 12 kills while airborne",
            Type = "Kills",
            Amount = 12,
            Airborne = true,
            Rewards = { { "Credits", 85 } }
        },
        Trickshot = {
            Description = "Get 8 no-scope sniper kills",
            Type = "Kills",
            Amount = 8,
            NoScope = true,
            Rewards = { { "Credits", 110 } }
        },
        Terrorist = {
            Description = "Win 45 rounds as a Terrorist",
            Type = "RoundsWon",
            Amount = 45,
            Team = "T",
            Rewards = { { "Credits", 55 } }
        },
        ["Counter-Terrorist"] = {
            Description = "Win 45 rounds as a Counter-Terrorist",
            Type = "RoundsWon",
            Amount = 45,
            Team = "CT",
            Rewards = { { "Credits", 55 } }
        },
        ["Dust Devil"] = {
            Description = "Win 3 matches on Dust II",
            Type = "Wins",
            Amount = 3,
            Map = "de_dust2",
            Rewards = { { "Credits", 75 } }
        },
        ["Sea Breeze"] = {
            Description = "Win 3 matches on Seaside",
            Type = "Wins",
            Amount = 3,
            Map = "de_seaside",
            Rewards = { { "Credits", 75 } }
        },
        ["High Ground"] = {
            Description = "Win 3 matches on Vertigo",
            Type = "Wins",
            Amount = 3,
            Map = "de_vertigo",
            Rewards = { { "Credits", 75 } }
        },
        Executioner = {
            Description = "Get 50 rifle headshot kills",
            Type = "Kills",
            Amount = 50,
            Class = "Rifle",
            Headshot = true,
            Rewards = { { "Credits", 75 } }
        },
        ["Iron Sights"] = {
            Description = "Get 25 pistol headshot kills",
            Type = "Kills",
            Amount = 25,
            Class = "Pistol",
            Headshot = true,
            Rewards = { { "Credits", 75 } }
        },
        Quadruple = {
            Description = "Get 2 quad kills",
            Type = "QuadKills",
            Amount = 2,
            Rewards = { { "Credits", 85 } }
        },
        Wingman = {
            Description = "Get 40 assists",
            Type = "Assists",
            Amount = 40,
            Rewards = { { "Credits", 55 } }
        },
        ["Air Raid"] = {
            Description = "Get 5 headshot kills while airborne",
            Type = "Kills",
            Amount = 5,
            Airborne = true,
            Headshot = true,
            Rewards = { { "Credits", 110 } }
        },
        Ghost = {
            Description = "Get 8 headshot kills through a wall",
            Type = "Kills",
            Amount = 8,
            Wallbang = true,
            Headshot = true,
            Rewards = { { "Credits", 110 } }
        }
    },
    Monthly = {
        Veteran = {
            Description = "Play 120 matches",
            Type = "Matches",
            Amount = 120,
            Rewards = { { "Credits", 220 } }
        },
        Conquest = {
            Description = "Win 60 matches",
            Type = "Wins",
            Amount = 60,
            Rewards = { { "Credits", 290 } }
        },
        Massacre = {
            Description = "Get 1500 kills",
            Type = "Kills",
            Amount = 1500,
            Rewards = { { "Credits", 255 } }
        },
        Precision = {
            Description = "Get 600 headshot kills",
            Type = "Kills",
            Amount = 600,
            Headshot = true,
            Rewards = { { "Credits", 290 } }
        },
        Warlord = {
            Description = "Win 700 rounds",
            Type = "RoundsWon",
            Amount = 700,
            Rewards = { { "Credits", 220 } }
        },
        Devastator = {
            Description = "Deal 250000 damage",
            Type = "Damage",
            Amount = 250000,
            Rewards = { { "Credits", 255 } }
        },
        Unbreakable = {
            Description = "Survive 550 rounds",
            Type = "RoundsSurvived",
            Amount = 550,
            Rewards = { { "Credits", 220 } }
        },
        Legend = {
            Description = "Earn 150 round MVPs",
            Type = "MVPs",
            Amount = 150,
            Rewards = { { "Credits", 290 } }
        },
        ["Ace Collector"] = {
            Description = "Get 15 aces",
            Type = "Aces",
            Amount = 15,
            Rewards = { { "Credits", 360 } }
        },
        ["Clutch King"] = {
            Description = "Win 40 rounds as the last one alive on your team",
            Type = "Clutches",
            Amount = 40,
            Rewards = { { "Credits", 320 } }
        },
        ["Opening Act"] = {
            Description = "Get the first kill of the round 175 times",
            Type = "EntryKills",
            Amount = 175,
            Rewards = { { "Credits", 255 } }
        },
        ["Demolitions Expert"] = {
            Description = "Plant the bomb 120 times",
            Type = "BombPlants",
            Amount = 120,
            Rewards = { { "Credits", 220 } }
        },
        ["Defuse Specialist"] = {
            Description = "Defuse the bomb 60 times",
            Type = "BombDefuses",
            Amount = 60,
            Rewards = { { "Credits", 220 } }
        },
        ["Blade Master"] = {
            Description = "Get 100 knife kills",
            Type = "Kills",
            Amount = 100,
            Class = "Melee",
            Rewards = { { "Credits", 360 } }
        },
        ["Sniper Elite"] = {
            Description = "Get 300 sniper kills",
            Type = "Kills",
            Amount = 300,
            Class = "Sniper",
            Rewards = { { "Credits", 290 } }
        },
        ["Through The Wall"] = {
            Description = "Get 120 kills through a wall",
            Type = "Kills",
            Amount = 120,
            Wallbang = true,
            Rewards = { { "Credits", 290 } }
        },
        Phantom = {
            Description = "Get 60 no-scope sniper kills",
            Type = "Kills",
            Amount = 60,
            NoScope = true,
            Rewards = { { "Credits", 395 } }
        },
        ["Assist King"] = {
            Description = "Get 300 assists",
            Type = "Assists",
            Amount = 300,
            Rewards = { { "Credits", 220 } }
        },
        ["Double Vision"] = {
            Description = "Get 150 double kills",
            Type = "DoubleKills",
            Amount = 150,
            Rewards = { { "Credits", 255 } }
        },
        ["Triple Crown"] = {
            Description = "Get 40 triple kills",
            Type = "TripleKills",
            Amount = 40,
            Rewards = { { "Credits", 290 } }
        },
        ["Quad Squad"] = {
            Description = "Get 15 quad kills",
            Type = "QuadKills",
            Amount = 15,
            Rewards = { { "Credits", 320 } }
        },
        ["Flawless Victory"] = {
            Description = "Win 100 rounds without losing a teammate",
            Type = "FlawlessRounds",
            Amount = 100,
            Rewards = { { "Credits", 290 } }
        },
        Hunter = {
            Description = "Kill the bomb carrier 100 times",
            Type = "BombCarrierKills",
            Amount = 100,
            Rewards = { { "Credits", 255 } }
        },
        ["Iron Nerves"] = {
            Description = "Get 75 kills with less than 25 HP",
            Type = "LowHealthKills",
            Amount = 75,
            Rewards = { { "Credits", 290 } }
        },
        ["Rifle Specialist"] = {
            Description = "Get 500 rifle kills",
            Type = "Kills",
            Amount = 500,
            Class = "Rifle",
            Rewards = { { "Credits", 290 } }
        },
        ["Deagle Legend"] = {
            Description = "Get 100 headshot kills with the Desert Eagle",
            Type = "Kills",
            Amount = 100,
            Weapon = "Desert Eagle",
            Headshot = true,
            Rewards = { { "Credits", 320 } }
        },
        ["Dust II Regular"] = {
            Description = "Win 15 matches on Dust II",
            Type = "Wins",
            Amount = 15,
            Map = "de_dust2",
            Rewards = { { "Credits", 290 } }
        },
        ["Seaside Regular"] = {
            Description = "Win 15 matches on Seaside",
            Type = "Wins",
            Amount = 15,
            Map = "de_seaside",
            Rewards = { { "Credits", 290 } }
        },
        ["Vertigo Regular"] = {
            Description = "Win 15 matches on Vertigo",
            Type = "Wins",
            Amount = 15,
            Map = "de_vertigo",
            Rewards = { { "Credits", 290 } }
        }
    }
};