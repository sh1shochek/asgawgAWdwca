-- ReplicatedStorage.GameClient.AnalyticsData
-- Script path: ReplicatedStorage.GameClient.AnalyticsData
-- Decompile time: 7.11 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = {
    WeaponStats = {},
    GamemodePlaytime = {},
    Matches = {}
};
local u6 = {};

function u1.Get() -- Line: 24
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.GetMatch(p7: number) -- Line: 28
    -- upvalues: u6 (copy)
    return u6[p7];
end;

function u1.RequestMatch(p8: number) -- Line: 32
    -- upvalues: u6 (copy), u1 (copy), u2 (ref)
    local v9 = u6[p8];

    if v9 then
        u1.MatchReceived:Fire(p8, v9);

        return;
    end;

    if not u2.Gui.RequestMatch then
        return;
    end;

    u2.Gui.RequestMatch.Fire(p8);
end;

function u1.Init(p10) -- Line: 50
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u1 (copy)
    u2 = p10:GetModule("Network");
    u3 = p10:GetModule("Signal");
    u4 = p10:GetModule("MatchCodec");
    u1.Updated = u3.new();
    u1.MatchReceived = u3.new();
end;

function u1.Start2(p11) -- Line: 59
    -- upvalues: u2 (ref), u5 (ref), u4 (ref), u1 (copy), u6 (copy)
    if not u2.Gui.AnalyticsUpdate then
        return;
    end;

    u2.Gui.AnalyticsUpdate.On(function(p12) -- Line: 64
        -- upvalues: u5 (ref), u4 (ref), u1 (ref)
        if not p12 then
            return;
        end;

        u5 = u4.UnpackAnalytics(p12);
        u1.Updated:Fire(u5);
    end);
    u2.Gui.MatchData.On(function(p13, p14) -- Line: 74
        -- upvalues: u4 (ref), u6 (ref), u1 (ref)
        local v15 = u4.UnpackMatch(p14);

        if not v15 then
            return;
        end;

        u6[p13] = v15;
        u1.MatchReceived:Fire(p13, v15);
    end);
end;

return u1;