-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics
-- Decompile time: 7.91 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;

function u1.Update() -- Line: 23
    -- upvalues: u1 (copy), u2 (ref), u6 (ref), u7 (ref)
    if not u1.Built then
        return;
    end;

    local Component = u2.GetComponent("Overview");
    local Component2 = u2.GetComponent("Matches");
    local v9 = u6.Get("PlayerStats");
    local v10 = u7.Get();
    Component.DrawProfile();
    Component.DrawStats(v9);
    Component.DrawFavouriteWeapon(v10);
    Component.DrawRecentMatches(v10);
    Component.DrawPlaytimeGraph(v10);
    Component2.DrawPicker(v10);
end;

function u1.Draw() -- Line: 42
    -- upvalues: u1 (copy)
    u1.Update();
end;

function u1.Cleanup() -- Line: 46
    -- upvalues: u3 (ref), u2 (ref)
    u3:Cleanup();
    u2.GetComponent("Matches").Cleanup();
end;

function u1.Init(p11) -- Line: 53
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u6 (ref), u7 (ref)
    u2 = p11:GetModule("Gui");
    u3 = p11:GetModule("Maid").new();
    u4 = u2.GetComponent("Tabs");
    u6 = p11:GetModule("ProfileData");
    u7 = p11:GetModule("AnalyticsData");
end;

function u1.Start(p12) -- Line: 62
    -- upvalues: u5 (ref), u2 (ref), u8 (ref), u1 (copy), u4 (ref), u7 (ref), u3 (ref), u6 (ref), LocalPlayer (copy), ReplicatedStorage (copy)
    u5 = u2.GetComponent("MainMenu");
    local Component = u2.GetComponent("Overview");
    local Component2 = u2.GetComponent("Matches");
    local Component3 = u2.GetComponent("Leaderboards");
    local Component4 = u2.GetComponent("ContainerAnalytics");
    u8 = u5.AddTab("Analytics");
    u5.AddSideButton("Analytics", u8, "rbxassetid://77326007502614", 10);
    local u13 = u1.new(u8);
    Component.new(u13);
    local u14 = Component3.new(u13);
    local u15 = Component4.new(u13);
    local u16 = Component2.new(u13);
    local MatchPages = Component2.MatchPages;
    u2.GetComponent("MatchesOverview").new(MatchPages);
    u2.GetComponent("MatchesScoreboard").new(MatchPages);
    u2.GetComponent("MatchesTimeline").new(MatchPages);
    u2.GetComponent("MatchesWeaponStats").new(MatchPages);
    Component2.ClearInitial();
    u13.Overview.Visible = false;
    u16.Visible = false;
    local v17 = u4:CreateTab(u8);
    u1.Tabs = v17;
    v17:CreatePage("Overview", 1, false, false, nil, false, function() -- Line: 100
        -- upvalues: u16 (copy), Component (copy)
        u16.Visible = false;
        Component.Open();
    end, u13.Overview);

    local function OpenMatches() -- Line: 105
        -- upvalues: u16 (copy), u7 (ref), Component2 (copy)
        u16.Visible = true;
        local v18 = u7.Get();

        if v18 and (v18.Matches and #v18.Matches == 0) then
            Component2.SetInfoVisible(false);
        end;
    end;

    local function OpenMatchPage(u19: string) -- Line: 114
        -- upvalues: u16 (copy), u7 (ref), Component2 (copy), u2 (ref)
        return function() -- Line: 115
            -- upvalues: u16 (ref), u7 (ref), Component2 (ref), u2 (ref), u19 (copy)
            u16.Visible = true;
            local v20 = u7.Get();

            if v20 and (v20.Matches and #v20.Matches == 0) then
                Component2.SetInfoVisible(false);
            end;

            u2.GetComponent(u19).Reveal();
        end;
    end;

    local v22 = v17:CreatePage("Matches", 2, true, false, nil, false, function() -- Line: 121
        -- upvalues: u16 (copy), u7 (ref), Component2 (copy)
        u16.Visible = true;
        local v21 = u7.Get();

        if v21 and (v21.Matches and #v21.Matches == 0) then
            Component2.SetInfoVisible(false);
        end;

        Component2.Open();
    end);
    local u23 = "MatchesOverview";
    v17:CreatePage("Overview", 3, false, true, v22, false, function() -- Line: 115
        -- upvalues: u16 (copy), u7 (ref), Component2 (copy), u2 (ref), u23 (copy)
        u16.Visible = true;
        local v24 = u7.Get();

        if v24 and (v24.Matches and #v24.Matches == 0) then
            Component2.SetInfoVisible(false);
        end;

        u2.GetComponent(u23).Reveal();
    end, MatchPages.Overview);
    local u25 = "MatchesScoreboard";
    v17:CreatePage("Scoreboard", 4, false, true, v22, false, function() -- Line: 115
        -- upvalues: u16 (copy), u7 (ref), Component2 (copy), u2 (ref), u25 (copy)
        u16.Visible = true;
        local v26 = u7.Get();

        if v26 and (v26.Matches and #v26.Matches == 0) then
            Component2.SetInfoVisible(false);
        end;

        u2.GetComponent(u25).Reveal();
    end, MatchPages.Scoreboard);
    local u27 = "MatchesTimeline";
    v17:CreatePage("Timeline", 5, false, true, v22, false, function() -- Line: 115
        -- upvalues: u16 (copy), u7 (ref), Component2 (copy), u2 (ref), u27 (copy)
        u16.Visible = true;
        local v28 = u7.Get();

        if v28 and (v28.Matches and #v28.Matches == 0) then
            Component2.SetInfoVisible(false);
        end;

        u2.GetComponent(u27).Reveal();
    end, MatchPages.Timeline);
    local u29 = "MatchesWeaponStats";
    v17:CreatePage("Weapon Stats", 6, false, true, v22, false, function() -- Line: 115
        -- upvalues: u16 (copy), u7 (ref), Component2 (copy), u2 (ref), u29 (copy)
        u16.Visible = true;
        local v30 = u7.Get();

        if v30 and (v30.Matches and #v30.Matches == 0) then
            Component2.SetInfoVisible(false);
        end;

        u2.GetComponent(u29).Reveal();
    end, MatchPages.WeaponStats);
    v17:CreatePage("Leaderboards", 7, false, false, nil, false, function() -- Line: 131
        -- upvalues: u16 (copy), Component3 (copy)
        u16.Visible = false;
        Component3.Open();
    end, u14);
    v17:CreatePage("Containers", 8, false, false, nil, false, function() -- Line: 136
        -- upvalues: u16 (copy), Component4 (copy)
        u16.Visible = false;
        Component4.Open();
    end, u15);
    u3:Add("StatsChanged", u6.Changed("PlayerStats"):Connect(u1.Update));
    u3:Add("AnalyticsChanged", u7.Updated:Connect(u1.Update));
    u3:Add("LoadoutChanged", LocalPlayer:GetAttributeChangedSignal("WeaponLoadout"):Connect(Component.DrawProfile));
    u3:Add("MatchReceived", u7.MatchReceived:Connect(function(p31, p32) -- Line: 146
        -- upvalues: Component2 (copy)
        Component2.OnMatchReceived(p31, p32);
    end));
    u3:Add("LeaderboardsChanged", ReplicatedStorage:GetAttributeChangedSignal("Leaderboards"):Connect(Component3.Draw));
    u3:Add("ContainerStatsChanged", LocalPlayer:GetAttributeChangedSignal("ContainerStats"):Connect(Component4.Draw));
    u3:Add("AnalyticsOpened", u8:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 151
        -- upvalues: u8 (ref), u13 (copy), Component (copy), u16 (copy), Component2 (copy), u14 (copy), Component3 (copy), u15 (copy), Component4 (copy)
        if u8.Visible and u13.Overview.Visible then
            Component.Open();
        end;

        if u8.Visible and u16.Visible then
            Component2.Open();
            Component2.RevealPage();
        end;

        if u8.Visible and u14.Visible then
            Component3.Open();
        end;

        if u8.Visible and u15.Visible then
            Component4.Open();
        end;
    end));
    Component3.Draw();
    Component4.Draw();
    u1.Built = true;
    u1.Draw();
end;

function u1.new(p33) -- Line: 180
    -- upvalues: u8 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "PlayerStats";
    Frame.Active = true;
    Frame.BackgroundTransparency = 1;
    Frame.ClipsDescendants = true;
    Frame.Selectable = true;
    Frame.SelectionGroup = true;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.Parent = p33 or u8;

    return Frame;
end;

return u1;