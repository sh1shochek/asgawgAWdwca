-- ReplicatedStorage.Shared.Data.GamepassesData
-- Script path: ReplicatedStorage.Shared.Data.GamepassesData
-- Decompile time: 15.99 ms

-- Decompiled with Potassium's decompiler.

local table_freeze_ret = table.freeze({
    [1883224613] = {
        DisplayName = "Gamepass Name",
        Name = "Gamepass",
        Credits = 9999,
        GiftId = 3605360387,
        Description = "Gamepass gives players access to many games for one price.",
        Thumbnail = 100429874437897,
        Index = 0,
        LayoutOrder = 0,
        Visible = false,
        Color = Color3.fromRGB(176, 195, 217)
    },
    [1998020814] = {
        DisplayName = "3x Open",
        Name = "3x Open",
        Credits = 2450,
        GiftId = 3714932988,
        Description = "Open up to 3 containers at once.",
        Thumbnail = 121549430051544,
        Index = 1,
        LayoutOrder = 1,
        Visible = true,
        MaxOpen = 3,
        Color = Color3.fromRGB(232, 169, 45)
    },
    [2000000781] = {
        DisplayName = "5x Open",
        Name = "5x Open",
        Credits = 3500,
        GiftId = 3714933008,
        Description = "Open up to 5 containers at once.",
        Thumbnail = 94620624493407,
        Index = 2,
        LayoutOrder = 2,
        Visible = true,
        MaxOpen = 5,
        Upgrade = 1999286805,
        Color = Color3.fromRGB(255, 147, 14)
    },
    [1999286805] = {
        DisplayName = "5x Open",
        Name = "5x Open",
        Credits = 1050,
        GiftId = 3714933056,
        Description = "Open up to 5 containers at once.",
        Thumbnail = 94620624493407,
        Index = 2,
        LayoutOrder = 2,
        Visible = false,
        MaxOpen = 5,
        Requires = 1998020814,
        Color = Color3.fromRGB(255, 147, 14)
    }
});
local table_freeze_ret2 = table.freeze({
    [3714855547] = {
        DisplayName = "Fuser Scroll",
        Name = "Fuser Scroll",
        Description = "Grants 1 Fuser Scroll. Use scrolls to fuse items in the Fuser tab.",
        Thumbnail = 100429874437897,
        Index = 0,
        LayoutOrder = 0,
        Visible = false,
        GiftId = 3714855547,
        Color = Color3.fromRGB(117, 65, 220),
        Items = { { "FuserScrolls", 1 } }
    },
    [3714855841] = {
        DisplayName = "Name Tag",
        Name = "Name Tag",
        Credits = 300,
        Description = "This Name Tag allows you to personalize a weapon with a custom name.",
        Thumbnail = 86541802771206,
        Index = 3,
        LayoutOrder = 3,
        Visible = true,
        GiftId = 3714855841,
        Color = Color3.fromRGB(176, 195, 217),
        Items = { { "Graphic Art", "Name Tag", "Name Tags" } }
    },
    [3714856011] = {
        DisplayName = "KillTrack",
        Name = "KillTrack",
        Description = "Adds a KillTrack counter to one weapon skin. Only kills made by the skin\'s owner are counted.",
        Thumbnail = 117488575054454,
        Index = 4,
        LayoutOrder = 4,
        Visible = true,
        GiftId = 3714856011,
        Color = Color3.fromRGB(106, 177, 207),
        Items = { { "Graphic Art", "KillTrack", "KillTracks" } }
    },
    [3714855926] = {
        DisplayName = "KillTrack Painter",
        Name = "KillTrack Painter",
        Credits = 420,
        Description = "Customizes the display color of any KillTrack counter.",
        Thumbnail = 104546107488678,
        Index = 5,
        LayoutOrder = 5,
        Visible = true,
        GiftId = 3714855926,
        Color = Color3.fromRGB(207, 47, 223),
        Items = { { "Graphic Art", "KillTrack Painter", "KillTracks" } }
    },
    [3714853720] = {
        DisplayName = "KillTrack Remover",
        Name = "KillTrack Remover",
        Credits = 80,
        Description = "Removes a KillTrack counter from one weapon skin.",
        Thumbnail = 92997205249661,
        Index = 6,
        LayoutOrder = 6,
        Visible = true,
        GiftId = 3714853720,
        Color = Color3.fromRGB(221, 74, 73),
        Items = { { "Graphic Art", "KillTrack Remover", "KillTracks" } }
    },
    [3714924554] = {
        DisplayName = "Daily Challenge Reroll",
        Name = "Daily Challenge Reroll",
        Description = "Rerolls all of your daily challenges.",
        Thumbnail = 125190823049365,
        Index = 7,
        LayoutOrder = 7,
        Visible = false,
        GiftId = 3714924554,
        Color = Color3.fromRGB(57, 234, 128),
        Items = { { "ChallengeReroll", "Daily" } }
    },
    [3714924922] = {
        DisplayName = "Weekly Challenge Reroll",
        Name = "Weekly Challenge Reroll",
        Description = "Rerolls all of your weekly challenges.",
        Thumbnail = 125190823049365,
        Index = 8,
        LayoutOrder = 8,
        Visible = false,
        GiftId = 3714924922,
        Color = Color3.fromRGB(57, 234, 128),
        Items = { { "ChallengeReroll", "Weekly" } }
    },
    [3716858171] = {
        DisplayName = "Hourly Challenge Reroll",
        Name = "Hourly Challenge Reroll",
        Description = "Rerolls all of your hourly challenges.",
        Thumbnail = 125190823049365,
        Index = 9,
        LayoutOrder = 9,
        Visible = false,
        GiftId = 3716858171,
        Color = Color3.fromRGB(57, 234, 128),
        Items = { { "ChallengeReroll", "Hourly" } }
    },
    [3716859593] = {
        DisplayName = "Monthly Challenge Reroll",
        Name = "Monthly Challenge Reroll",
        Description = "Rerolls all of your monthly challenges.",
        Thumbnail = 125190823049365,
        Index = 10,
        LayoutOrder = 10,
        Visible = false,
        GiftId = 3716859593,
        Color = Color3.fromRGB(57, 234, 128),
        Items = { { "ChallengeReroll", "Monthly" } }
    },
    [3716863893] = {
        Name = "Advertisement Reward 1",
        Visible = false,
        Items = { { "AdReward", "1" } }
    },
    [3716863904] = {
        Name = "Advertisement Reward 2",
        Visible = false,
        Items = { { "AdReward", "2" } }
    },
    [3716863923] = {
        Name = "Advertisement Reward 3",
        Visible = false,
        Items = { { "AdReward", "3" } }
    },
    [3716863937] = {
        Name = "Advertisement Reward 4",
        Visible = false,
        Items = { { "AdReward", "4" } }
    },
    [3716287207] = {
        Name = "Weeb | Bundle",
        GiftId = 3716287207,
        Items = { { "Item", "AK-47_MyBeloved" }, { "Item", "AWP_Rika" }, { "Item", "USP-S_Sakuliro" }, { "Item", "M4A4_Lycoris Bloom" }, { "Graphic Art", "Anim", "Badges" } }
    },
    [3716287248] = {
        Name = "AK-47 | MyBeloved",
        GiftId = 3716287248,
        Items = { { "Item", "AK-47_MyBeloved" } }
    },
    [3716287273] = {
        Name = "AWP | Rika",
        GiftId = 3716287273,
        Items = { { "Item", "AWP_Rika" } }
    },
    [3716287310] = {
        Name = "USP-S | Sakuliro",
        GiftId = 3716287310,
        Items = { { "Item", "USP-S_Sakuliro" } }
    },
    [3716287348] = {
        Name = "M4A4 | Lycoris Bloom",
        GiftId = 3716287348,
        Items = { { "Item", "M4A4_Lycoris Bloom" } }
    },
    [3716498432] = {
        Name = "Badges | Anim",
        GiftId = 3716498432,
        Items = { { "Graphic Art", "Anim", "Badges" } }
    },
    [3714856081] = {
        Name = "Badges | Rika",
        GiftId = 3714856081,
        Items = { { "Graphic Art", "Rika", "Badges" } }
    },
    [3714856146] = {
        Name = "AWP | Alpha",
        GiftId = 3714856146,
        Items = { { "Item", "AWP_Alpha" } }
    },
    [3714856271] = {
        Name = "Alpha | Bundle",
        GiftId = 3714856271,
        Items = { { "Graphic Art", "Rika", "Badges" }, { "Item", "AWP_Alpha" } }
    },
    [3714856361] = {
        Name = "100 Credits",
        GiftId = 3714856361,
        Items = { { "Credits", 100 } }
    },
    [3714856449] = {
        Name = "220 Credits",
        GiftId = 3714856449,
        Items = { { "Credits", 220 } }
    },
    [3714856623] = {
        Name = "560 Credits",
        GiftId = 3714856623,
        Items = { { "Credits", 560 } }
    },
    [3714856700] = {
        Name = "1150 Credits",
        GiftId = 3714856700,
        Items = { { "Credits", 1150 } }
    },
    [3714856981] = {
        Name = "2350 Credits",
        GiftId = 3714856981,
        Items = { { "Credits", 2350 } }
    },
    [3714857017] = {
        Name = "6000 Credits",
        GiftId = 3714857017,
        Items = { { "Credits", 6000 } }
    },
    [3714857106] = {
        Name = "12500 Credits",
        GiftId = 3714857106,
        Items = { { "Credits", 12500 }, { "Item", "Balisong_Gold" } }
    },
    [3714857221] = {
        Name = "1 Mayhem Case",
        GiftId = 3714857221,
        Items = { { "Container", "Mayhem Case" } }
    },
    [3714857317] = {
        Name = "2 Mayhem Case",
        GiftId = 3714857317,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857414] = {
        Name = "3 Mayhem Case",
        GiftId = 3714857414,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857456] = {
        Name = "4 Mayhem Case",
        GiftId = 3714857456,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857498] = {
        Name = "5 Mayhem Case",
        GiftId = 3714857498,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857532] = {
        Name = "6 Mayhem Case",
        GiftId = 3714857532,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857581] = {
        Name = "7 Mayhem Case",
        GiftId = 3714857581,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857616] = {
        Name = "8 Mayhem Case",
        GiftId = 3714857616,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857680] = {
        Name = "9 Mayhem Case",
        GiftId = 3714857680,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3714857767] = {
        Name = "10 Mayhem Case",
        GiftId = 3714857767,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3715501941] = {
        Name = "25 Mayhem Case",
        GiftId = 3715501941,
        Items = { { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" }, { "Container", "Mayhem Case" } }
    },
    [3715502038] = {
        Name = "50 Mayhem Case",
        GiftId = 3715502038,
        Items = {
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" }
        }
    },
    [3715502145] = {
        Name = "100 Mayhem Case",
        GiftId = 3715502145,
        Items = {
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" },
            { "Container", "Mayhem Case" }
        }
    },
    [3717459729] = {
        Name = "1 Sticker Capsule",
        GiftId = 3717459729,
        Items = { { "Container", "Sticker Capsule" } }
    },
    [3717459781] = {
        Name = "2 Sticker Capsule",
        GiftId = 3717459781,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717459820] = {
        Name = "3 Sticker Capsule",
        GiftId = 3717459820,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717459875] = {
        Name = "4 Sticker Capsule",
        GiftId = 3717459875,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717459897] = {
        Name = "5 Sticker Capsule",
        GiftId = 3717459897,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717459920] = {
        Name = "6 Sticker Capsule",
        GiftId = 3717459920,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717459952] = {
        Name = "7 Sticker Capsule",
        GiftId = 3717459952,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717459976] = {
        Name = "8 Sticker Capsule",
        GiftId = 3717459976,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717460050] = {
        Name = "9 Sticker Capsule",
        GiftId = 3717460050,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717460015] = {
        Name = "10 Sticker Capsule",
        GiftId = 3717460015,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717460109] = {
        Name = "25 Sticker Capsule",
        GiftId = 3717460109,
        Items = { { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" }, { "Container", "Sticker Capsule" } }
    },
    [3717460154] = {
        Name = "50 Sticker Capsule",
        GiftId = 3717460154,
        Items = {
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" }
        }
    },
    [3717460202] = {
        Name = "100 Sticker Capsule",
        GiftId = 3717460202,
        Items = {
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" },
            { "Container", "Sticker Capsule" }
        }
    }
});
local table_freeze_ret3 = table.freeze({
    [3714932988] = {
        Name = "3x Open",
        PassId = 1998020814
    },
    [3714933008] = {
        Name = "5x Open",
        PassId = 2000000781
    },
    [3714933056] = {
        Name = "5x Open",
        PassId = 1999286805
    },
    [3714855841] = {
        Name = "Name Tag",
        PassId = 3714855841
    },
    [3714856011] = {
        Name = "KillTrack",
        PassId = 3714856011
    },
    [3714855926] = {
        Name = "KillTrack Painter",
        PassId = 3714855926
    },
    [3714853720] = {
        Name = "KillTrack Remover",
        PassId = 3714853720
    },
    [3714924554] = {
        Name = "Daily Challenge Reroll",
        PassId = 3714924554
    },
    [3714924922] = {
        Name = "Weekly Challenge Reroll",
        PassId = 3714924922
    },
    [3716858171] = {
        Name = "Hourly Challenge Reroll",
        PassId = 3716858171
    },
    [3716859593] = {
        Name = "Monthly Challenge Reroll",
        PassId = 3716859593
    },
    [3714855547] = {
        Name = "Fuser Scroll",
        PassId = 3714855547
    },
    [3716287207] = {
        Name = "Weeb | Bundle",
        PassId = 3716287207
    },
    [3716287248] = {
        Name = "AK-47 | MyBeloved",
        PassId = 3716287248
    },
    [3716287273] = {
        Name = "AWP | Rika",
        PassId = 3716287273
    },
    [3716287310] = {
        Name = "USP-S | Sakuliro",
        PassId = 3716287310
    },
    [3716287348] = {
        Name = "M4A4 | Lycoris Bloom",
        PassId = 3716287348
    },
    [3716498432] = {
        Name = "Badges | Anim",
        PassId = 3716498432
    },
    [3714856271] = {
        Name = "Alpha | Bundle",
        PassId = 3714856271
    },
    [3714856081] = {
        Name = "Badges | Rika",
        PassId = 3714856081
    },
    [3714856146] = {
        Name = "AWP | Alpha",
        PassId = 3714856146
    },
    [3714856361] = {
        Name = "100 Credits",
        PassId = 3714856361
    },
    [3714856449] = {
        Name = "220 Credits",
        PassId = 3714856449
    },
    [3714856623] = {
        Name = "560 Credits",
        PassId = 3714856623
    },
    [3714856700] = {
        Name = "1150 Credits",
        PassId = 3714856700
    },
    [3714856981] = {
        Name = "2350 Credits",
        PassId = 3714856981
    },
    [3714857017] = {
        Name = "6000 Credits",
        PassId = 3714857017
    },
    [3714857106] = {
        Name = "12500 Credits",
        PassId = 3714857106
    },
    [3714857221] = {
        Name = "1 Mayhem Case",
        PassId = 3714857221
    },
    [3714857317] = {
        Name = "2 Mayhem Case",
        PassId = 3714857317
    },
    [3714857414] = {
        Name = "3 Mayhem Case",
        PassId = 3714857414
    },
    [3714857456] = {
        Name = "4 Mayhem Case",
        PassId = 3714857456
    },
    [3714857498] = {
        Name = "5 Mayhem Case",
        PassId = 3714857498
    },
    [3714857532] = {
        Name = "6 Mayhem Case",
        PassId = 3714857532
    },
    [3714857581] = {
        Name = "7 Mayhem Case",
        PassId = 3714857581
    },
    [3714857616] = {
        Name = "8 Mayhem Case",
        PassId = 3714857616
    },
    [3714857680] = {
        Name = "9 Mayhem Case",
        PassId = 3714857680
    },
    [3714857767] = {
        Name = "10 Mayhem Case",
        PassId = 3714857767
    },
    [3715501941] = {
        Name = "25 Mayhem Case",
        PassId = 3715501941
    },
    [3715502038] = {
        Name = "50 Mayhem Case",
        PassId = 3715502038
    },
    [3715502145] = {
        Name = "100 Mayhem Case",
        PassId = 3715502145
    },
    [3717459729] = {
        Name = "1 Sticker Capsule",
        PassId = 3717459729
    },
    [3717459781] = {
        Name = "2 Sticker Capsule",
        PassId = 3717459781
    },
    [3717459820] = {
        Name = "3 Sticker Capsule",
        PassId = 3717459820
    },
    [3717459875] = {
        Name = "4 Sticker Capsule",
        PassId = 3717459875
    },
    [3717459897] = {
        Name = "5 Sticker Capsule",
        PassId = 3717459897
    },
    [3717459920] = {
        Name = "6 Sticker Capsule",
        PassId = 3717459920
    },
    [3717459952] = {
        Name = "7 Sticker Capsule",
        PassId = 3717459952
    },
    [3717459976] = {
        Name = "8 Sticker Capsule",
        PassId = 3717459976
    },
    [3717460050] = {
        Name = "9 Sticker Capsule",
        PassId = 3717460050
    },
    [3717460015] = {
        Name = "10 Sticker Capsule",
        PassId = 3717460015
    },
    [3717460109] = {
        Name = "25 Sticker Capsule",
        PassId = 3717460109
    },
    [3717460154] = {
        Name = "50 Sticker Capsule",
        PassId = 3717460154
    },
    [3717460202] = {
        Name = "100 Sticker Capsule",
        PassId = 3717460202
    }
});

return table.freeze({
    Gamepasses = table_freeze_ret,
    DevProducts = table_freeze_ret2,
    Gifts = table_freeze_ret3
});