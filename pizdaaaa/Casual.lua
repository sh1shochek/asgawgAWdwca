-- ReplicatedStorage.Shared.Data.GamemodesConfig.Casual
-- Script path: ReplicatedStorage.Shared.Data.GamemodesConfig.Casual
-- Decompile time: 3.55 ms

-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 4
    local RoundStatesNum = p1.RoundStatesNum;
    local SubRoundStatesNum = p1.SubRoundStatesNum;

    return {
        Timers = {
            [RoundStatesNum.Warmup] = 60,
            [RoundStatesNum.Preparation] = 5,
            [RoundStatesNum.RoundTime] = 135,
            [RoundStatesNum.RoundEnded] = 5,
            [RoundStatesNum.MatchEnded] = 20,
            [RoundStatesNum.BombPlanted] = 40,
            [RoundStatesNum.BombDefused] = 5,
            [RoundStatesNum.BombExploded] = 5,
            [RoundStatesNum.Restart] = 1
        },
        SubTimers = {
            [SubRoundStatesNum.BuyTime] = 45,
            [SubRoundStatesNum.WarmupBuyTimer] = -1,
            [SubRoundStatesNum.Nothing] = 0
        },
        MapPool = { "de_vertigo", "de_seaside", "de_dust2" },
        RoundsToWin = 8,
        MaxRounds = 15,
        GrenadeLimits = {
            MaxGrenades = 3,
            Molotov = 1,
            ["Incendiary Grenade"] = 1,
            Flashbang = 2,
            ["HE Grenade"] = 1,
            ["Smoke Grenade"] = 1,
            ["Decoy Grenade"] = 1
        },
        MoneySettings = {
            MaxMoney = 10000,
            DefaultMoney = 1000,
            WarmupMoney = 10000,
            BombDefuse = 300,
            BombPlant = 300,
            TeamElimination = {
                CT = 2700,
                T = 2700
            },
            TimeWin = {
                CT = 2700,
                T = 0
            },
            BombDefused = {
                CT = 2700,
                T = 0
            },
            BombExploded = {
                CT = 0,
                T = 2700
            },
            LoseStreaks = { {
                    CT = 1400,
                    T = 1400,
                    BombReward = 800
                }, {
                    CT = 1900,
                    T = 1900,
                    BombReward = 800
                }, {
                    CT = 2400,
                    T = 2400,
                    BombReward = 800
                }, {
                    CT = 2900,
                    T = 2900,
                    BombReward = 800
                }, {
                    CT = 3400,
                    T = 3400,
                    BombReward = 800
                } }
        },
        KreditsAward = {
            Win = 30,
            Loss = 15,
            MVP = 5,
            MVPCap = 3,
            MinimumPlayerAmount = 4,
            MinimumDamage = 50,
            MinimumRoundsPlay = 3
        },
        FreeArmor = true,
        FreeDefuseKit = true,
        SpawnProtectionTime = 3,
        KillAwardMultiplier = 0.5
    };
end;