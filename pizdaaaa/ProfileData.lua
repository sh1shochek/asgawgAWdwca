-- ReplicatedStorage.GameClient.ProfileData
-- Script path: ReplicatedStorage.GameClient.ProfileData
-- Decompile time: 6.93 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = {
    Credits = 0,
    Playtime = 0,
    UsedStarCode = "",
    PlayerStats = {},
    PlaytimeRewardsCollected = {},
    UsedCodes = {},
    CollectedAchievements = {},
    Gamepasses = {},
    Challenges = {
        Hour = 0,
        Week = 0,
        WeekDay = 0,
        Month = 0,
        Hourly = {},
        Daily = {},
        Weekly = {},
        Monthly = {}
    },
    Battlepass = {
        Season = 1,
        Premium = false,
        XP = 0,
        Rewards = {
            Free = {},
            Premium = {}
        }
    }
};
local u5 = {};
local u6 = {};
local u7 = {};

function v1.Get(p8) -- Line: 50
    -- upvalues: u4 (copy)
    return u4[p8];
end;

function v1.Changed(p9) -- Line: 54
    -- upvalues: u5 (copy)
    return u5[p9];
end;

function v1.SetPaused(p10: string, p11: boolean) -- Line: 58
    -- upvalues: u6 (copy), u7 (copy), u4 (copy), u5 (copy)
    u6[p10] = p11;

    if not p11 and u7[p10] ~= nil then
        local v12 = u7[p10];
        u7[p10] = nil;
        u4[p10] = v12;
        u5[p10]:Fire(v12);
    end;
end;

function v1.IsPaused(p13: string) -- Line: 69
    -- upvalues: u6 (copy)
    return u6[p13] == true;
end;

function v1.Init(p14) -- Line: 75
    -- upvalues: u2 (ref), u3 (ref), u4 (copy), u5 (copy), u6 (copy), u7 (copy)
    u2 = p14:GetModule("Network");
    u3 = p14:GetModule("Signal");

    for i in u4 do
        u5[i] = u3.new();
    end;

    local function Bind(u15, p16) -- Line: 83
        -- upvalues: u6 (ref), u7 (ref), u4 (ref), u5 (ref)
        p16.On(function(p17) -- Line: 84
            -- upvalues: u6 (ref), u15 (copy), u7 (ref), u4 (ref), u5 (ref)
            if u6[u15] then
                u7[u15] = p17;

                return;
            end;

            u4[u15] = p17;
            u5[u15]:Fire(p17);
        end);
    end;

    local u18 = "PlayerStats";
    u2.Gui.PlayerStatsUpdate.On(function(p19) -- Line: 84
        -- upvalues: u6 (ref), u18 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u18] then
            u7[u18] = p19;

            return;
        end;

        u4[u18] = p19;
        u5[u18]:Fire(p19);
    end);
    local u20 = "Credits";
    u2.Gui.CreditsUpdate.On(function(p21) -- Line: 84
        -- upvalues: u6 (ref), u20 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u20] then
            u7[u20] = p21;

            return;
        end;

        u4[u20] = p21;
        u5[u20]:Fire(p21);
    end);
    local u22 = "Playtime";
    u2.Gui.PlaytimeUpdate.On(function(p23) -- Line: 84
        -- upvalues: u6 (ref), u22 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u22] then
            u7[u22] = p23;

            return;
        end;

        u4[u22] = p23;
        u5[u22]:Fire(p23);
    end);
    local u24 = "PlaytimeRewardsCollected";
    u2.Gui.PlaytimeRewardsCollectedUpdate.On(function(p25) -- Line: 84
        -- upvalues: u6 (ref), u24 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u24] then
            u7[u24] = p25;

            return;
        end;

        u4[u24] = p25;
        u5[u24]:Fire(p25);
    end);
    local u26 = "UsedCodes";
    u2.Gui.UsedCodesUpdate.On(function(p27) -- Line: 84
        -- upvalues: u6 (ref), u26 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u26] then
            u7[u26] = p27;

            return;
        end;

        u4[u26] = p27;
        u5[u26]:Fire(p27);
    end);
    local u28 = "UsedStarCode";
    u2.Gui.UsedStarCodeUpdate.On(function(p29) -- Line: 84
        -- upvalues: u6 (ref), u28 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u28] then
            u7[u28] = p29;

            return;
        end;

        u4[u28] = p29;
        u5[u28]:Fire(p29);
    end);
    local u30 = "UsedStarCode";
    u2.Gui.UsedStarCodeUpdate.On(function(p31) -- Line: 84
        -- upvalues: u6 (ref), u30 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u30] then
            u7[u30] = p31;

            return;
        end;

        u4[u30] = p31;
        u5[u30]:Fire(p31);
    end);
    local u32 = "CollectedAchievements";
    u2.Gui.CollectedAchievementsUpdate.On(function(p33) -- Line: 84
        -- upvalues: u6 (ref), u32 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u32] then
            u7[u32] = p33;

            return;
        end;

        u4[u32] = p33;
        u5[u32]:Fire(p33);
    end);
    local u34 = "Gamepasses";
    u2.Gui.GamepassesUpdate.On(function(p35) -- Line: 84
        -- upvalues: u6 (ref), u34 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u34] then
            u7[u34] = p35;

            return;
        end;

        u4[u34] = p35;
        u5[u34]:Fire(p35);
    end);
    local u36 = "Challenges";
    u2.Gui.ChallengesUpdate.On(function(p37) -- Line: 84
        -- upvalues: u6 (ref), u36 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u36] then
            u7[u36] = p37;

            return;
        end;

        u4[u36] = p37;
        u5[u36]:Fire(p37);
    end);
    local u38 = "Battlepass";
    u2.Gui.BattlepassUpdate.On(function(p39) -- Line: 84
        -- upvalues: u6 (ref), u38 (copy), u7 (ref), u4 (ref), u5 (ref)
        if u6[u38] then
            u7[u38] = p39;

            return;
        end;

        u4[u38] = p39;
        u5[u38]:Fire(p39);
    end);
end;

return v1;