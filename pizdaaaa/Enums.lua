-- ReplicatedStorage.Shared.Utility.Enums
-- Script path: ReplicatedStorage.Shared.Utility.Enums
-- Decompile time: 15.71 ms

-- Decompiled with Potassium's decompiler.

local v1 = {
    Reason = { "Oops! You bonked your own head!", "You were killed by the Bomb explosion", "killed you with the" },
    PartShape = {
        Enum.PartType.Wedge,
        Enum.PartType.CornerWedge,
        Enum.PartType.Cylinder,
        Enum.PartType.Ball,
        Enum.PartType.Block,
        "Ladder"
    },
    EntityTypes = { "Character", "DroppedWeapon", "Bomb" },
    RoundStates = table.freeze({ "Warmup", "Preparation", "RoundTime", "RoundEnded", "MatchEnded", "BombPlanted", "BombDefused", "BombExploded", "Restart" }),
    SubRoundStates = table.freeze({ "BuyTime", "WarmupBuyTimer", "Nothing" }),
    MatchClasses = table.freeze({
        "Clutch King",
        "Most valuable MVP",
        "Workhorse",
        "Carry",
        "Score Master",
        "Scorer",
        "Valuable Player",
        "Pain Train",
        "Assassin",
        "Sharpshooter",
        "Sniper",
        "Gunslinger",
        "Sidearm",
        "Ace of Aces",
        "Ace in the Hole",
        "Quadkiller",
        "Quad",
        "Trifecta",
        "Triple",
        "Entry Fragger",
        "Quick Draw",
        "Weapons Master",
        "Weapons Trainer",
        "Wall",
        "Interference",
        "Executioner",
        "Fragger",
        "Mercenary",
        "Bounty Hunter",
        "Bullseye",
        "Tenderizer",
        "Assistant",
        "Old Timer",
        "Ancient",
        "Die Hard",
        "Survivalist",
        "Big Spender",
        "Scavenger",
        "Spender",
        "Frugalist",
        "Bruiser",
        "Reservist",
        "Armchair General",
        "Moral Support",
        "Backup Plan",
        "Rear Guard",
        "Participant",
        "Click Bait",
        "Fearless"
    }),
    MatchClassInfo = table.freeze({
        "Clutch kills: %d",
        "MVPs: %d",
        "ADR: %d",
        "ADR: %d",
        "Score: %d",
        "Score: %d",
        "MVPs: %d",
        "Damage: %d",
        "Headshot kills: %d",
        "Sniper kills: %d",
        "Sniper kills: %d",
        "Pistol kills: %d",
        "Pistol kills: %d",
        "Aces: %d",
        "Aces: %d",
        "Quad kills: %d",
        "Quad kills: %d",
        "Triple kills: %d",
        "Triple kills: %d",
        "First kills: %d",
        "First kills: %d",
        "Unique weapons: %d",
        "Unique weapons: %d",
        "Carrier kills: %d",
        "Carrier kills: %d",
        "Kills: %d",
        "Kills: %d",
        "Earnings: $%d",
        "Earnings: $%d",
        "HS Percentage: %d%%",
        "Assists: %d",
        "Assists: %d",
        "Time alive: %ds",
        "Time alive: %ds",
        "Survived: %d",
        "Survived: %d",
        "Spent: $%d",
        "Spent: $%d",
        "Spent: $%d",
        "Spent: $%d",
        "Damage: %d",
        "Bullets dodged: %d",
        "Tactical pings: %d",
        "High fives given: %d",
        "Times blinked: %d",
        "Burgers eaten: %d",
        "Participation points: %d",
        "Deaths: %d",
        "Deaths: %d"
    }),
    MVPReasons = table.freeze({ "MVP: %s for most kills", "MVP: %s for planting the bomb", "MVP: %s for defusing the bomb" }),
    Awards = table.freeze({ "for neutralizing an enemy with the", "for planting the bomb", "for defusing the bomb", "for winning the round", "for loss bonus", "for terminating an enemy\'s kill streak", "for objective completed", "Surviving loss penalty: $0 loss award" }),
    PingTypes = { "Info", "Warning", "Weapon" },
    VotekickReasons = table.freeze({ "Cheating", "Bug Abuse", "Griefing", "Toxicity", "AFK" }),
    StickerSizes = table.freeze({ "Small", "Medium", "Large" }),
    Inputs = { "KeyCode", "UserInputType", "MouseWheel", "None" },
    Keybinds = { "WheelForward", "WheelBackward" }
};

for _, v in Enum.KeyCode:GetEnumItems() do
    local Name = v.Name;

    if not Name:find("World") then
        table.insert(v1.Keybinds, Name);
    end;
end;

for _, v in Enum.UserInputType:GetEnumItems() do
    table.insert(v1.Keybinds, v.Name);
end;

table.sort(v1.Keybinds, function(p2, p3) -- Line: 217
    return p2:lower() < p3:lower();
end);
v1.Rarity = { "Stock", "Mil-Spec", "Restricted", "Classified", "Covert", "Exceeding Rare", "Contraband", "Event", "Special", "Unknown", "Private" };
v1.Teams = table.freeze({ "CT", "T", "Spectator" });
v1.PlayerColors = table.freeze({
    Color3.fromRGB(242, 218, 50),
    Color3.fromRGB(156, 68, 214),
    Color3.fromRGB(52, 178, 51),
    Color3.fromRGB(85, 170, 255),
    Color3.fromRGB(245, 130, 32)
});
v1.PlayerColorNames = table.freeze({ "Yellow", "Purple", "Green", "Blue", "Orange" });
v1.Tiers = { "1", "5", "10", "15", "20" };
v1.Passes = { "Premium", "PremiumPlus" };
v1.Loadout = {
    [0] = "StartingPistol_1",
    [1] = "OtherPistols_1",
    [2] = "OtherPistols_2",
    [3] = "OtherPistols_3",
    [4] = "OtherPistols_4",
    [5] = "MidTier_1",
    [6] = "MidTier_2",
    [7] = "MidTier_3",
    [8] = "MidTier_4",
    [9] = "MidTier_5",
    [10] = "Rifles_1",
    [11] = "Rifles_2",
    [12] = "Rifles_3",
    [13] = "Rifles_4",
    [14] = "Rifles_5",
    [15] = "Agents",
    [16] = "Gloves",
    [17] = "Melee",
    [18] = "Music Kits",
    [19] = "Badges",
    [20] = "Graffiti",
    [21] = "Bomb"
};
v1.InventoryCategories = {
    [0] = "Equipment",
    [1] = "Graphic Art",
    [2] = "Containers"
};
v1.ItemCategories = {
    [0] = "Agents",
    [1] = "Charms",
    [2] = "Graffiti",
    [3] = "Containers",
    [4] = "Stickers",
    [5] = "Badges"
};
v1.SettingsTab = { "Game", "Controls", "Audio", "Maps" };
v1.SettingsPage = { "Crosshair", "Gameplay", "Viewmodel", "Graphics & Visuals", "HUD & UI", "Radar", "Sensitivity", "Keybinds", "Mobile Controls", "Controller Binds", "Volume & Sound", "de_dust2", "de_vertigo", "de_mirage", "de_seaside", "Mobile Buttons" };
v1.SettingsDropdown = {
    [1] = "Circle",
    [2] = "Dynamic",
    [3] = "Square",
    [4] = "Static",
    [5] = "Team Color",
    [6] = "No Texture",
    [7] = "Remove Bloom",
    [8] = "No Shadows",
    [9] = "Default",
    [10] = "Retro",
    [11] = "Pips",
    [12] = "Names",
    [13] = "Health",
    [14] = "Equipment",
    [15] = "Remove Fan Animation",
    [16] = "Left",
    [17] = "Right",
    [18] = "Hold",
    [19] = "Toggle",
    [20] = "Repeat Disabled",
    [21] = "Repeat Enabled",
    [22] = "Highest",
    [23] = "Weapon Textures",
    [24] = "Character Textures",
    [25] = "Glove Textures",
    [26] = "Accessory Textures",
    [27] = "Remove Water Animation",
    [28] = "Remove Window Reflectance",
    [29] = "Remove Window Transparency",
    [30] = "Center",
    [31] = "Off",
    [32] = "1: Text",
    [33] = "2: Detailed Text",
    [34] = "Weapon Bar",
    [35] = "Swipe Button",
    [36] = "Number Buttons",
    [37] = "Classic",
    [38] = "Fixed",
    [39] = "Button",
    [40] = "Zone",
    [41] = "Both",
    [42] = "Pulse",
    [43] = "Auto Hide",
    [44] = "Preset 1",
    [45] = "Preset 2",
    [46] = "Preset 3",
    [47] = "Preset 4",
    [48] = "Preset 5",
    [49] = "Selection",
    [50] = "Cursor",
    [101] = "de_seaside",
    [102] = "de_vertigo",
    [103] = "de_dust2",
    [104] = "de_mirage",
    [105] = "All"
};
v1.MatchResult = table.freeze({ "WIN", "LOSS", "TIE" });
v1.Hitboxes = table.freeze({ "Head", "Body", "Arms", "Legs" });
v1.TimelineEvents = table.freeze({ "RoundStart", "Kill", "BombPlant", "BombDefuse", "BombExplode", "RoundEnd", "Ace" });
v1.Gamemodes = table.freeze({ "Casual", "Competitive", "HNS" });
v1.Maps = table.freeze({ "de_seaside", "de_vertigo", "de_dust2", "de_mirage" });
v1.Countries = table.freeze({
    "AD",
    "AE",
    "AF",
    "AG",
    "AI",
    "AL",
    "AM",
    "AO",
    "AQ",
    "AR",
    "AS",
    "AT",
    "AU",
    "AW",
    "AX",
    "AZ",
    "BA",
    "BB",
    "BD",
    "BE",
    "BF",
    "BG",
    "BH",
    "BI",
    "BJ",
    "BL",
    "BM",
    "BN",
    "BO",
    "BQ",
    "BR",
    "BS",
    "BT",
    "BV",
    "BW",
    "BY",
    "BZ",
    "CA",
    "CC",
    "CD",
    "CF",
    "CG",
    "CH",
    "CI",
    "CK",
    "CL",
    "CM",
    "CN",
    "CO",
    "CR",
    "CU",
    "CV",
    "CW",
    "CX",
    "CY",
    "CZ",
    "DE",
    "DJ",
    "DK",
    "DM",
    "DO",
    "DZ",
    "EC",
    "EE",
    "EG",
    "EH",
    "ER",
    "ES",
    "ET",
    "FI",
    "FJ",
    "FK",
    "FM",
    "FO",
    "FR",
    "GA",
    "GB",
    "GD",
    "GE",
    "GF",
    "GG",
    "GH",
    "GI",
    "GL",
    "GM",
    "GN",
    "GP",
    "GQ",
    "GR",
    "GS",
    "GT",
    "GU",
    "GW",
    "GY",
    "HK",
    "HM",
    "HN",
    "HR",
    "HT",
    "HU",
    "ID",
    "IE",
    "IL",
    "IM",
    "IN",
    "IO",
    "IQ",
    "IR",
    "IS",
    "IT",
    "JE",
    "JM",
    "JO",
    "JP",
    "KE",
    "KG",
    "KH",
    "KI",
    "KM",
    "KN",
    "KP",
    "KR",
    "KW",
    "KY",
    "KZ",
    "LA",
    "LB",
    "LC",
    "LI",
    "LK",
    "LR",
    "LS",
    "LT",
    "LU",
    "LV",
    "LY",
    "MA",
    "MC",
    "MD",
    "ME",
    "MF",
    "MG",
    "MH",
    "MK",
    "ML",
    "MM",
    "MN",
    "MO",
    "MP",
    "MQ",
    "MR",
    "MS",
    "MT",
    "MU",
    "MV",
    "MW",
    "MX",
    "MY",
    "MZ",
    "NA",
    "NC",
    "NE",
    "NF",
    "NG",
    "NI",
    "NL",
    "NO",
    "NP",
    "NR",
    "NU",
    "NZ",
    "OM",
    "PA",
    "PE",
    "PF",
    "PG",
    "PH",
    "PK",
    "PL",
    "PM",
    "PN",
    "PR",
    "PS",
    "PT",
    "PW",
    "PY",
    "QA",
    "RE",
    "RO",
    "RS",
    "RU",
    "RW",
    "SA",
    "SB",
    "SC",
    "SD",
    "SE",
    "SG",
    "SH",
    "SI",
    "SJ",
    "SK",
    "SL",
    "SM",
    "SN",
    "SO",
    "SR",
    "SS",
    "ST",
    "SV",
    "SX",
    "SY",
    "SZ",
    "TC",
    "TD",
    "TF",
    "TG",
    "TH",
    "TJ",
    "TK",
    "TL",
    "TM",
    "TN",
    "TO",
    "TR",
    "TT",
    "TV",
    "TW",
    "TZ",
    "UA",
    "UG",
    "UM",
    "US",
    "UY",
    "UZ",
    "VA",
    "VC",
    "VE",
    "VG",
    "VI",
    "VN",
    "VU",
    "WF",
    "WS",
    "XK",
    "YE",
    "YT",
    "ZA",
    "ZM",
    "ZW"
});
local v4 = {};

for i, v in v1 do
    v4[i] = v;
end;

for i, v in v4 do
    local table_create_ret = table.create(#v);

    for i2, v2 in v do
        table_create_ret[v2] = i2;
    end;

    v1[i .. "Num"] = table.freeze(table_create_ret);
end;

table.clear(v4);
v1.HitboxGroups = table.freeze({
    Head = 1,
    UpperTorso = 2,
    LowerTorso = 2,
    LeftUpperArm = 3,
    LeftLowerArm = 3,
    LeftHand = 3,
    RightUpperArm = 3,
    RightLowerArm = 3,
    RightHand = 3,
    LeftUpperLeg = 4,
    LeftLowerLeg = 4,
    LeftFoot = 4,
    RightUpperLeg = 4,
    RightLowerLeg = 4,
    RightFoot = 4
});
v1.MaterialPenetrationData = {
    [Enum.Material.Plastic] = {
        PenetrationModifier = 0.75
    },
    [Enum.Material.SmoothPlastic] = {
        PenetrationModifier = 0.75
    },
    [Enum.Material.Neon] = {
        PenetrationModifier = 0.9
    },
    [Enum.Material.Wood] = {
        PenetrationModifier = 0.9
    },
    [Enum.Material.WoodPlanks] = {
        PenetrationModifier = 0.85
    },
    [Enum.Material.Marble] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Basalt] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Slate] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.CrackedLava] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Concrete] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Limestone] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Granite] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Pavement] = {
        PenetrationModifier = 0.55
    },
    [Enum.Material.Brick] = {
        PenetrationModifier = 0.47
    },
    [Enum.Material.Pebble] = {
        PenetrationModifier = 0.4
    },
    [Enum.Material.Cobblestone] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Rock] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.Sandstone] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.CorrodedMetal] = {
        PenetrationModifier = 0.5
    },
    [Enum.Material.DiamondPlate] = {
        PenetrationModifier = 0.4
    },
    [Enum.Material.Foil] = {
        PenetrationModifier = 0.9
    },
    [Enum.Material.Metal] = {
        PenetrationModifier = 0.4
    },
    [Enum.Material.Grass] = {
        PenetrationModifier = 0.6
    },
    [Enum.Material.LeafyGrass] = {
        PenetrationModifier = 0.6
    },
    [Enum.Material.Sand] = {
        PenetrationModifier = 0.3
    },
    [Enum.Material.Fabric] = {
        PenetrationModifier = 0.75
    },
    [Enum.Material.Snow] = {
        PenetrationModifier = 0.85
    },
    [Enum.Material.Mud] = {
        PenetrationModifier = 0.6
    },
    [Enum.Material.Ground] = {
        PenetrationModifier = 0.6
    },
    [Enum.Material.Asphalt] = {
        PenetrationModifier = 0.55
    },
    [Enum.Material.Salt] = {
        PenetrationModifier = 0.7
    },
    [Enum.Material.Ice] = {
        PenetrationModifier = 0.75
    },
    [Enum.Material.Glacier] = {
        PenetrationModifier = 0.75
    },
    [Enum.Material.Glass] = {
        PenetrationModifier = 0.99
    },
    [Enum.Material.ForceField] = {
        PenetrationModifier = 0.01
    },
    [Enum.Material.Air] = {
        PenetrationModifier = 1
    },
    [Enum.Material.Water] = {
        PenetrationModifier = 0.3
    },
    [Enum.Material.Cardboard] = {
        PenetrationModifier = 0.95
    },
    [Enum.Material.Carpet] = {
        PenetrationModifier = 0.75
    },
    [Enum.Material.CeramicTiles] = {
        PenetrationModifier = 0.7
    },
    [Enum.Material.ClayRoofTiles] = {
        PenetrationModifier = 0.95
    },
    [Enum.Material.RoofShingles] = {
        PenetrationModifier = 0.6
    },
    [Enum.Material.Leather] = {
        PenetrationModifier = 0.75
    },
    [Enum.Material.Plaster] = {
        PenetrationModifier = 0.7
    },
    [Enum.Material.Rubber] = {
        PenetrationModifier = 0.85
    },
    Default = {
        PenetrationModifier = 0.5
    }
};
local v5 = {
    Material = Enum.Material.Glass,
    PenetrationModifier = 0.99,
    Impact = Enum.Material.Metal
};
v1.MaterialVariantPenetrationData = {
    Asphalt_2022Base = {
        Material = Enum.Material.Asphalt
    },
    Asphalt_2022Base_Organic = {
        Material = Enum.Material.Asphalt
    },
    Brick_LegacyBase = {
        Material = Enum.Material.Brick
    },
    Brick_MoreBreak_Base_1 = {
        Material = Enum.Material.Brick
    },
    Brick_MoreBreak_Base_2 = {
        Material = Enum.Material.Brick
    },
    Brick_MoreBreak_Base_3 = {
        Material = Enum.Material.Brick
    },
    downBrick = {
        Material = Enum.Material.Brick
    },
    downBrick2 = {
        Material = Enum.Material.Brick
    },
    Cardboard_2022Base = {
        Material = Enum.Material.Cardboard
    },
    Cardboard_2022Base_Organic = {
        Material = Enum.Material.Cardboard
    },
    Cardboard_Big_Organic = {
        Material = Enum.Material.Cardboard
    },
    Carpet_2022Base_Organic = {
        Material = Enum.Material.Carpet
    },
    CeramicTiles_2022Base_x12 = {
        Material = Enum.Material.CeramicTiles
    },
    CeramicTiles_2022Base_x30 = {
        Material = Enum.Material.CeramicTiles
    },
    ClayRoofTiles_2022Base = {
        Material = Enum.Material.ClayRoofTiles
    },
    Concrete_2022Base = {
        Material = Enum.Material.Concrete
    },
    Concrete_2022Base_Organic = {
        Material = Enum.Material.Concrete
    },
    Concrete_LegacyBase = {
        Material = Enum.Material.Concrete
    },
    Concrete_LegacyBase_Organic = {
        Material = Enum.Material.Concrete
    },
    CorrodedMetal_2022Base_Organic = {
        Material = Enum.Material.CorrodedMetal
    },
    DiamondPlate_LegacyBase = {
        Material = Enum.Material.DiamondPlate
    },
    Foil_LegacyBase = {
        Material = Enum.Material.Foil
    },
    Foil_LegacyBase_Organic2 = {
        Material = Enum.Material.Foil
    },
    Glacier_2022Base = {
        Material = Enum.Material.Glacier
    },
    Glacier_2022Base_Organic = {
        Material = Enum.Material.Glacier
    },
    Glass_2022Base = {
        Material = Enum.Material.Glass
    },
    Granite_LegacyBase_Organic = {
        Material = Enum.Material.Granite
    },
    Grass_2022Base_Organic = {
        Material = Enum.Material.Grass
    },
    Grass_LegacyBase_Organic_x8 = {
        Material = Enum.Material.Grass
    },
    Grass_LegacyBase_Organic_x64 = {
        Material = Enum.Material.Grass
    },
    Marble_LegacyBase = {
        Material = Enum.Material.Marble
    },
    Marble_LegacyBase_Organic = {
        Material = Enum.Material.Marble
    },
    Metal_2022Base = {
        Material = Enum.Material.Metal
    },
    Metal_2022Base_Organic = {
        Material = Enum.Material.Metal
    },
    Metal_LegacyBase = {
        Material = Enum.Material.Metal
    },
    Metal_LegacyBase_Organic = {
        Material = Enum.Material.Metal
    },
    Pebble_LegacyBase = {
        Material = Enum.Material.Pebble
    },
    RoofShingles_2022Base = {
        Material = Enum.Material.RoofShingles
    },
    Sand_2022Base = {
        Material = Enum.Material.Sand
    },
    Snow_2022Base_Organic = {
        Material = Enum.Material.Snow
    },
    Wood_LegacyBase = {
        Material = Enum.Material.Wood
    },
    Wood_LegacyBase_x14 = {
        Material = Enum.Material.Wood
    },
    Wood_LegacyBase_Organic = {
        Material = Enum.Material.Wood
    },
    Wood_LegacyBase_Organic_x14 = {
        Material = Enum.Material.Wood
    },
    BoxesWood_LegacyBase_Organic_x14 = {
        Material = Enum.Material.Wood
    },
    WoodPlanks_2022Base = {
        Material = Enum.Material.WoodPlanks
    },
    WoodPlanks_2022Base_x5 = {
        Material = Enum.Material.WoodPlanks
    },
    WoodPlanks_2022Base_x6_5 = {
        Material = Enum.Material.WoodPlanks
    },
    WoodPlanks_2022Base_small = {
        Material = Enum.Material.WoodPlanks
    },
    WoodPlanks_2022Base_small2 = {
        Material = Enum.Material.WoodPlanks
    },
    Fence = v5,
    Net = v5,
    Nwo = v5,
    setka = {
        Material = Enum.Material.Glass,
        PenetrationModifier = 0.95,
        Impact = Enum.Material.Metal
    }
};

for i = 1, 40 do
    v1.MaterialVariantPenetrationData["WaterFrame" .. i] = {
        Material = Enum.Material.Water
    };
    local _ = i;
end;

v1.PayLocked = 128;

return v1;