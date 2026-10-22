-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.PlaytimeReward
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.PlaytimeReward
-- Decompile time: 31.59 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local GroupService = game:GetService("GroupService");
local AvatarEditorService = game:GetService("AvatarEditorService");
local AdService = game:GetService("AdService");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = { "Playtime", "Ads", "Group" };
local u19 = {};
local u20 = {};
local u21 = {
    Playtime = {},
    Ads = {},
    Group = {}
};
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = "Access";
local u27 = false;
local u28 = {};
local u29 = {
    Text = Color3.fromRGB(232, 232, 232),
    Tab = Color3.fromRGB(131, 216, 255),
    Accent = Color3.fromRGB(131, 216, 255),
    Ready = Color3.fromRGB(129, 255, 120),
    Error = Color3.fromRGB(255, 84, 87),
    Notice = Color3.fromRGB(106, 177, 207),
    Button = Color3.fromRGB(50, 94, 128),
    ButtonHover = Color3.fromRGB(63, 119, 161),
    Claim = Color3.fromRGB(58, 130, 84),
    ClaimHover = Color3.fromRGB(70, 156, 101),
    Disabled = Color3.fromRGB(53, 54, 54),
    Claimed = Color3.fromRGB(40, 40, 48),
    Stroke = Color3.fromRGB(45, 53, 62),
    Bar = Color3.fromRGB(79, 130, 152),
    BarReady = Color3.fromRGB(106, 208, 123),
    BarClaimed = Color3.fromRGB(90, 90, 96)
};
local u30 = {
    Locked = {
        Dim = 0.5,
        AccentTransparency = 0.7,
        Icon = "rbxassetid://107995524735706",
        Color = u29.Disabled,
        Hover = u29.Disabled,
        Accent = u29.Text,
        Bar = u29.Bar
    },
    Action = {
        Dim = 0,
        AccentTransparency = 0,
        Icon = "rbxassetid://138566214762806",
        Color = u29.Button,
        Hover = u29.ButtonHover,
        Accent = u29.Accent,
        Bar = u29.Bar
    },
    Waiting = {
        Dim = 0.5,
        AccentTransparency = 0.7,
        Icon = "rbxassetid://138566214762806",
        Color = u29.Disabled,
        Hover = u29.Disabled,
        Accent = u29.Text,
        Bar = u29.Bar
    },
    Ready = {
        Dim = 0,
        AccentTransparency = 0,
        Icon = "rbxassetid://138566214762806",
        Color = u29.Claim,
        Hover = u29.ClaimHover,
        Accent = u29.Ready,
        Bar = u29.BarReady
    },
    Claimed = {
        Dim = 0.5,
        AccentTransparency = 0,
        Icon = "rbxassetid://138566214762806",
        Faded = true,
        Color = u29.Claimed,
        Hover = u29.Claimed,
        Accent = u29.BarClaimed,
        Bar = u29.BarClaimed
    }
};
local u31 = {
    [Enum.AdAvailabilityResult.PlayerIneligible] = true,
    [Enum.AdAvailabilityResult.DeviceIneligible] = true,
    [Enum.AdAvailabilityResult.PublisherIneligible] = true,
    [Enum.AdAvailabilityResult.ExperienceIneligible] = true
};
local u32 = {
    Access = {
        State = "Action",
        Text = "GIVE ACCESS"
    },
    Join = {
        State = "Action",
        Text = "JOIN"
    },
    Check = {
        State = "Waiting",
        Text = "CHECK"
    },
    Ready = {
        State = "Ready",
        Text = "CLAIM"
    },
    Claimed = {
        State = "Claimed",
        Text = "CLAIMED"
    }
};
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret3 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret4 = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);

local function FormatTime(p33) -- Line: 91
    local DateTime_fromUnixTimestamp_ret = DateTime.fromUnixTimestamp(p33);

    return p33 >= 3600 and DateTime_fromUnixTimestamp_ret:FormatUniversalTime("HH:mm:ss", "en-us") or DateTime_fromUnixTimestamp_ret:FormatUniversalTime("mm:ss", "en-us");
end;

local function Animate(p34: any, p35: userdata, p36: any, p37: boolean) -- Line: 97
    -- upvalues: TweenService (copy)
    if p37 then
        for i, v in p36 do
            p34[i] = v;
        end;

        return;
    end;

    TweenService:Create(p34, p35, p36):Play();
end;

local function HookButton(u38) -- Line: 109
    -- upvalues: u7 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    u38.MouseEnter:Connect(function() -- Line: 110
        -- upvalues: u38 (copy), u7 (ref), TweenService (ref), TweenInfo_new_ret (ref)
        if u38:GetAttribute("Color") == u38:GetAttribute("HoverColor") then
            return;
        end;

        u7.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u38.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = u38:GetAttribute("HoverColor")
        }):Play();
    end);
    u38.MouseLeave:Connect(function() -- Line: 118
        -- upvalues: TweenService (ref), u38 (copy), TweenInfo_new_ret (ref)
        TweenService:Create(u38.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = u38:GetAttribute("Color")
        }):Play();
    end);
end;

local function Collect(u39, p40) -- Line: 123
    -- upvalues: u25 (ref), u1 (copy)
    local u41 = {
        Entry = u39
    };
    u39.Pending = true;
    u25 = u41;
    task.delay(p40, function() -- Line: 129
        -- upvalues: u25 (ref), u41 (copy), u39 (copy), u1 (ref)
        if u25 ~= u41 then
            return;
        end;

        u25 = nil;
        u39.Pending = false;
        u1.UpdateAll();
    end);
end;

function u1.DrawCategories() -- Line: 141
    -- upvalues: u18 (copy), u1 (copy), u19 (copy), u4 (ref), u22 (ref), u7 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    for i, v in u18 do
        local u42 = u1.categoryButton(v, i);
        u19[v] = u42;
        u4:Add(`{v}MouseEnter`, u42.MouseEnter:Connect(function() -- Line: 147
            -- upvalues: u22 (ref), v (copy), u7 (ref), TweenService (ref), u42 (copy), TweenInfo_new_ret (ref)
            if u22 == v then
                return;
            end;

            u7.Play("UI.submenu_dropdown_rollover");
            TweenService:Create(u42, TweenInfo_new_ret, {
                BackgroundTransparency = 0.9
            }):Play();
        end));
        u4:Add(`{v}MouseLeave`, u42.MouseLeave:Connect(function() -- Line: 155
            -- upvalues: TweenService (ref), u42 (copy), TweenInfo_new_ret (ref)
            TweenService:Create(u42, TweenInfo_new_ret, {
                BackgroundTransparency = 1
            }):Play();
        end));
        u4:Add(`{v}Button1Click`, u42.MouseButton1Click:Connect(function() -- Line: 159
            -- upvalues: u22 (ref), v (copy), u7 (ref), u1 (ref)
            if u22 == v then
                return;
            end;

            u7.Play("UI.submenu_click");
            u1.SelectCategory(v);
        end));
    end;
end;

function u1.SelectCategory(p43) -- Line: 169
    -- upvalues: u22 (ref), u19 (copy), TweenService (copy), TweenInfo_new_ret (copy), u29 (copy), u20 (copy), u12 (ref), TweenInfo_new_ret3 (copy), u21 (copy), u1 (copy)
    u22 = p43;

    for i, v in u19 do
        TweenService:Create(v, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
        TweenService:Create(v.Title, TweenInfo_new_ret, {
            TextColor3 = i == p43 and u29.Tab or Color3.new(1, 1, 1)
        }):Play();
    end;

    for i, v in u20 do
        v.Visible = i == p43;
    end;

    TweenService:Create(u12, TweenInfo_new_ret3, {
        Position = u19[p43].Position
    }):Play();

    for _, v in u21[p43] do
        local Holder = v.Holder;
        Holder.GroupTransparency = 1;
        Holder.Position = UDim2.fromScale(0.5, 0.56);
        task.delay((v.Card.LayoutOrder - 1) * 0.05, function() -- Line: 189
            -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret3 (ref)
            TweenService:Create(Holder, TweenInfo_new_ret3, {
                GroupTransparency = 0,
                Position = UDim2.fromScale(0.5, 0.5)
            }):Play();
        end);
    end;

    if p43 == "Ads" then
        task.spawn(u1.CheckAds);
    elseif p43 == "Group" then
        task.spawn(u1.UpdateGroup);
    end;

    u1.UpdateInfo();
end;

function u1.DrawPlaytime() -- Line: 203
    -- upvalues: u1 (copy), u20 (copy), u3 (ref), u7 (ref), Collect (copy), u5 (ref)
    for i = 1, 8 do
        local v44 = tostring(i);
        local entry = u1.entry;
        local Playtime = u20.Playtime;
        local Time = u3.Rewards[v44].Time;
        local DateTime_fromUnixTimestamp_ret = DateTime.fromUnixTimestamp(Time);
        local u45 = entry(Playtime, v44, i, 0.235, Time >= 3600 and DateTime_fromUnixTimestamp_ret:FormatUniversalTime("HH:mm:ss", "en-us") or DateTime_fromUnixTimestamp_ret:FormatUniversalTime("mm:ss", "en-us"), `{u3.Rewards[v44].XRewards}x REWARD`, true);
        u1.widen(u45.Holder);
        u45.Holder.Claim.MouseButton1Click:Connect(function() -- Line: 210
            -- upvalues: u45 (copy), u7 (ref), Collect (ref), u5 (ref), i (copy)
            if u45.Pending or u45.State ~= "Ready" then
                return;
            end;

            u7.Play("UI.submenu_click");
            Collect(u45, 10);
            u5.Gui.ClaimPlaytimeReward.Fire(i);
        end);
        local _ = i;
    end;
end;

function u1.DrawAds() -- Line: 221
    -- upvalues: u3 (ref), u1 (copy), u20 (copy), u23 (ref), u7 (ref), Collect (copy), u5 (ref), u9 (ref), u29 (copy)
    for i, v in u3.Advertisement do
        local u46 = tonumber(i);
        local u47 = u1.entry(u20.Ads, i, u46, 0.23, `AD #{i}`, `{v.XRewards}x REWARD`, false);
        u47.Holder.Claim.MouseButton1Click:Connect(function() -- Line: 226
            -- upvalues: u47 (copy), u23 (ref), i (copy), u7 (ref), u1 (ref), Collect (ref), u5 (ref), u46 (copy), u9 (ref), u29 (ref)
            if u47.Pending or u23[`Ad{i}`] then
                return;
            end;

            u7.Play("UI.submenu_click");
            u47.Pending = true;
            u1.UpdateAds();

            if u1.CheckAds() then
                Collect(u47, 90);
                u5.Gui.WatchAdReward.Fire(u46);

                return;
            end;

            u47.Pending = false;
            u1.UpdateAds();
            u7.Play("UI.lobby_error");
            u9:Create("No ads available right now", u29.Error);
        end);
    end;
end;

function u1.DrawGroup() -- Line: 250
    -- upvalues: u1 (copy), u20 (copy), u3 (ref), u26 (ref), u7 (ref), Collect (copy), u5 (ref), AvatarEditorService (copy), LocalPlayer (copy), GroupService (copy)
    local u48 = u1.entry(u20.Group, "9", 1, 0.23, "GROUP", `{u3.Rewards["9"].XRewards}x REWARD`, false);
    u48.Card.AnchorPoint = Vector2.new(1, 0);
    u48.Card.Position = UDim2.fromScale(0.47, 0);
    u48.Holder.Claim.MouseButton1Click:Connect(function() -- Line: 256
        -- upvalues: u48 (copy), u26 (ref), u7 (ref), Collect (ref), u5 (ref), u1 (ref), AvatarEditorService (ref), LocalPlayer (ref), GroupService (ref)
        if u48.Pending then
            return;
        end;

        if u26 == "Ready" then
            u7.Play("UI.submenu_click");
            Collect(u48, 10);
            u5.Gui.ClaimPlaytimeReward.Fire(9);

            return;
        end;

        if u26 ~= "Access" then
            if u26 == "Join" then
                u7.Play("UI.submenu_click");
                local success, result = pcall(function() -- Line: 287
                    -- upvalues: LocalPlayer (ref), GroupService (ref)
                    if LocalPlayer:IsInGroup(35706237) then
                        return Enum.GroupMembershipStatus.Joined;
                    end;

                    return GroupService:PromptJoinAsync(35706237);
                end);

                if success then
                    success = result == Enum.GroupMembershipStatus.Joined and true or result == Enum.GroupMembershipStatus.AlreadyMember;
                end;

                u1.UpdateGroup(success, success);
            end;

            return;
        end;

        u7.Play("UI.submenu_click");
        u26 = "Check";
        u1.UpdateGroupCard();
        local success, result = pcall(function() -- Line: 270
            -- upvalues: AvatarEditorService (ref)
            AvatarEditorService:PromptAllowInventoryReadAccess();

            if AvatarEditorService:GetFavoriteAsync(game.PlaceId, Enum.AvatarItemType.Asset) == true then
                return true;
            end;

            AvatarEditorService:PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true);
            AvatarEditorService.PromptSetFavoriteCompleted:Wait();

            return AvatarEditorService:GetFavoriteAsync(game.PlaceId, Enum.AvatarItemType.Asset);
        end);
        u1.UpdateGroup(success and result);
    end);
end;

function u1.UpdateAll() -- Line: 302
    -- upvalues: u1 (copy)
    u1.UpdatePlaytime();
    u1.UpdateAds();
    u1.UpdateGroupCard();
    u1.UpdateInfo();
end;

function u1.Paint(p49: any, p50: any, p51: any, p52: boolean) -- Line: 309
    -- upvalues: u30 (copy), TweenInfo_new_ret (copy), TweenService (copy), u29 (copy)
    local v53 = u30[p50];
    local Holder = p49.Holder;
    local Claim = Holder.Claim;
    p49.State = p50;
    Claim.Title.Text = p51;
    Claim:SetAttribute("Color", v53.Color);
    Claim:SetAttribute("HoverColor", v53.Hover);
    Holder.Icon.Image = v53.Icon;
    local Frame = Claim.Frame;
    local v54 = TweenInfo_new_ret;
    local v55 = {
        BackgroundColor3 = v53.Color
    };

    if p52 then
        for i, v in v55 do
            Frame[i] = v;
        end;
    else
        TweenService:Create(Frame, v54, v55):Play();
    end;

    local Title = Claim.Title;
    local v56 = TweenInfo_new_ret;
    local v57 = {
        TextTransparency = v53.Dim
    };

    if p52 then
        for i, v in v57 do
            Title[i] = v;
        end;
    else
        TweenService:Create(Title, v56, v57):Play();
    end;

    local Accent = Holder.Accent;
    local v58 = TweenInfo_new_ret;
    local v59 = {
        BackgroundColor3 = v53.Accent,
        BackgroundTransparency = v53.AccentTransparency
    };

    if p52 then
        for i, v in v59 do
            Accent[i] = v;
        end;
    else
        TweenService:Create(Accent, v58, v59):Play();
    end;

    local Top = Holder.Top;
    local v60 = TweenInfo_new_ret;
    local v61 = {
        TextTransparency = v53.Faded and 0.5 or 0
    };

    if p52 then
        for i, v in v61 do
            Top[i] = v;
        end;
    else
        TweenService:Create(Top, v60, v61):Play();
    end;

    local Sub = Holder.Sub;
    local v62 = TweenInfo_new_ret;
    local v63 = {
        TextTransparency = v53.Faded and 0.6 or 0.2
    };

    if p52 then
        for i, v in v63 do
            Sub[i] = v;
        end;
    else
        TweenService:Create(Sub, v62, v63):Play();
    end;

    local Icon = Holder.Icon;
    local v64 = TweenInfo_new_ret;
    local v65 = {
        ImageTransparency = v53.Faded and 0.4 or 0
    };

    if p52 then
        for i, v in v65 do
            Icon[i] = v;
        end;
    else
        TweenService:Create(Icon, v64, v65):Play();
    end;

    if p50 == "Ready" then
        local UIStroke = Holder.UIStroke;
        local v66 = TweenInfo_new_ret;
        local v67 = {
            Color = u29.Ready
        };

        if p52 then
            for i, v in v67 do
                UIStroke[i] = v;
            end;
        else
            TweenService:Create(UIStroke, v66, v67):Play();
        end;

        if p49.Pulse.PlaybackState ~= Enum.PlaybackState.Playing then
            Holder.UIStroke.Transparency = 0;
            p49.Pulse:Play();
        end;
    else
        p49.Pulse:Cancel();
        local UIStroke = Holder.UIStroke;
        local v68 = {
            Transparency = 0.3,
            Color = u29.Stroke
        };

        if p52 then
            for i, v in v68 do
                UIStroke[i] = v;
            end;

            return;
        end;

        TweenService:Create(UIStroke, TweenInfo_new_ret, v68):Play();
    end;
end;

function u1.UpdatePlaytime(p69: boolean) -- Line: 342
    -- upvalues: u21 (copy), u3 (ref), u24 (ref), u23 (ref), u1 (copy), TweenService (copy), TweenInfo_new_ret2 (copy), u30 (copy), u28 (copy), u9 (ref), u29 (copy)
    for i, v in u21.Playtime do
        local v70 = u3.Rewards[i];
        local v71 = v70.Time - u24;
        local v72 = u23[i] and "Claimed" or (v71 <= 0 and "Ready" or "Locked");
        local Paint = u1.Paint;
        local v73;

        if v72 == "Locked" then
            local DateTime_fromUnixTimestamp_ret = DateTime.fromUnixTimestamp(v71);
            v73 = v71 >= 3600 and DateTime_fromUnixTimestamp_ret:FormatUniversalTime("HH:mm:ss", "en-us") or DateTime_fromUnixTimestamp_ret:FormatUniversalTime("mm:ss", "en-us") or (v72 == "Ready" and "CLAIM" or "CLAIMED");
        else
            v73 = v72 == "Ready" and "CLAIM" or "CLAIMED";
        end;

        Paint(v, v72, v73, p69);
        TweenService:Create(v.Holder.ProgressBar.Bar, TweenInfo_new_ret2, {
            Size = UDim2.fromScale(math.clamp(u24 / v70.Time, 0, 1), 1),
            BackgroundColor3 = u30[v72].Bar
        }):Play();

        if v72 == "Ready" and not u28[i] then
            u28[i] = true;
            u9:Create("Playtime Reward Available!", u29.Ready);
        end;
    end;

    u1.UpdateNotices();
end;

function u1.UpdateAds(p74: boolean) -- Line: 364
    -- upvalues: u21 (copy), u23 (ref), u1 (copy), u27 (ref)
    for i, v in u21.Ads do
        if u23[`Ad{i}`] then
            u1.Paint(v, "Claimed", "CLAIMED", p74);
        elseif v.Pending then
            u1.Paint(v, "Waiting", "WATCHING", p74);
        elseif u27 then
            u1.Paint(v, "Action", "WATCH", p74);
        else
            u1.Paint(v, "Waiting", "UNAVAILABLE", p74);
        end;
    end;

    u1.UpdateNotices();
end;

function u1.UpdateGroupCard(p75: boolean) -- Line: 380
    -- upvalues: u32 (copy), u23 (ref), u26 (ref), u1 (copy), u21 (copy), u28 (copy), u9 (ref), u29 (copy)
    local v76 = u32[u23["9"] and "Claimed" or u26];
    u1.Paint(u21.Group["9"], v76.State, v76.Text, p75);

    if v76.State == "Ready" and not u28["9"] then
        u28["9"] = true;
        u9:Create("Playtime Reward Available!", u29.Ready);
    end;

    u1.UpdateNotices();
end;

function u1.UpdateGroup(u77: boolean, p78: boolean?) -- Line: 393
    -- upvalues: AvatarEditorService (copy), u26 (ref), LocalPlayer (copy), u1 (copy)
    local success, result = pcall(function() -- Line: 394
        -- upvalues: u77 (copy), AvatarEditorService (ref)
        if u77 then
            AvatarEditorService:PromptAllowInventoryReadAccess();
        end;

        return AvatarEditorService:GetFavoriteAsync(game.PlaceId, Enum.AvatarItemType.Asset);
    end);

    if success then
        success = result == true;
    end;

    u26 = success and ((p78 or LocalPlayer:IsInGroup(35706237)) and "Ready" or "Join") or "Access";
    u1.UpdateGroupCard();
end;

function u1.CheckAds() -- Line: 409
    -- upvalues: AdService (copy), u27 (ref), u31 (copy), u18 (copy), u1 (copy)
    local success, result = pcall(AdService.GetAdAvailabilityNowAsync, AdService, Enum.AdFormat.RewardedVideo);
    local v79;

    if success then
        v79 = result.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable;
    else
        v79 = success;
    end;

    u27 = v79;

    if success and (u31[result.AdAvailabilityResult] and table.find(u18, "Ads")) then
        u1.HideAds();
    end;

    u1.UpdateAds();

    return u27;
end;

function u1.HideAds() -- Line: 423
    -- upvalues: u18 (copy), u19 (copy), u22 (ref), u1 (copy)
    table.remove(u18, table.find(u18, "Ads"));
    u19.Ads.Visible = false;

    if u22 == "Ads" then
        u1.SelectCategory(u18[1]);
    end;

    u1.LayoutCategories();
end;

function u1.LayoutCategories() -- Line: 435
    -- upvalues: u18 (copy), TweenService (copy), u11 (ref), TweenInfo_new_ret3 (copy), u19 (copy), u12 (ref), u22 (ref)
    local v80 = #u18;
    TweenService:Create(u11, TweenInfo_new_ret3, {
        Size = UDim2.fromScale(v80 * 0.14, 0.07)
    }):Play();

    for i, v in u18 do
        local v81 = u19[v];
        v81.Position = UDim2.fromScale((i - 1) / v80, 0);
        v81.Size = UDim2.fromScale(1 / v80, 1);
    end;

    u12.Size = UDim2.fromScale(1 / v80, 1);
    u12.Position = u19[u22].Position;
end;

function u1.UpdateNotices() -- Line: 451
    -- upvalues: u21 (copy), u19 (copy), TweenService (copy), TweenInfo_new_ret (copy), u8 (ref)
    local v82 = {
        Playtime = false,
        Ads = false,
        Group = false
    };

    for i, v in u21 do
        local v83 = i;

        for _, v2 in v do
            local v84 = v82[v83];

            if not v84 then
                if v2.State == "Ready" then
                    v84 = true;
                elseif v83 == "Ads" then
                    v84 = v2.State == "Action";
                else
                    v84 = false;
                end;
            end;

            v82[v83] = v84;
        end;
    end;

    for i, v in u19 do
        TweenService:Create(v.Dot, TweenInfo_new_ret, {
            BackgroundTransparency = v82[i] and 0 or 1
        }):Play();
    end;

    if v82.Playtime or v82.Group then
        u8.AddNotice("Rewards");
    end;
end;

function u1.UpdateInfo() -- Line: 473
    -- upvalues: u22 (ref), u13 (ref), u24 (ref), u3 (ref), u23 (ref), u14 (ref)
    if u22 == "Playtime" then
        local v85 = u24;
        local DateTime_fromUnixTimestamp_ret = DateTime.fromUnixTimestamp(v85);
        u13.Text = `PLAYTIME {v85 >= 3600 and DateTime_fromUnixTimestamp_ret:FormatUniversalTime("HH:mm:ss", "en-us") or DateTime_fromUnixTimestamp_ret:FormatUniversalTime("mm:ss", "en-us")}`;
    elseif u22 == "Ads" then
        local v86 = 0;
        local v87 = 0;

        for i in u3.Advertisement do
            v86 = v86 + 1;
            v87 = v87 + (u23[`Ad{i}`] and 1 or 0);
        end;

        u13.Text = `{v87}/{v86} WATCHED`;
    else
        u13.Text = "DAILY BONUS";
    end;

    u14.Text = `RESETS IN {DateTime.fromUnixTimestamp(86400 - DateTime.now().UnixTimestamp % 86400):FormatUniversalTime("HH:mm:ss", "en-us")}`;
end;

function u1.DrawOdds() -- Line: 492
    -- upvalues: u3 (ref), u1 (copy)
    for i, v in u3.Odds do
        local v88 = {};

        for _, v2 in v.PossibleRewards do
            local v89 = tostring(v2[2]);
            table.insert(v88, v89);
        end;

        u1.oddChip(i, (`<b>{table.concat(v88, ", ")}</b>  <font transparency="0.5">{v.Percents}%</font>`));
    end;
end;

function u1.Init(p90) -- Line: 506
    -- upvalues: u2 (ref), u4 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u9 (ref)
    u2 = p90:GetModule("Gui");
    u4 = p90:GetModule("Maid").new();
    u3 = p90:GetModule("PlaytimeRewardsData");
    u5 = p90:GetModule("Network");
    u6 = p90:GetModule("ProfileData");
    u7 = p90:GetModule("SoundManager");
    u9 = u2.GetComponent("MenuNotification");
end;

function u1.Start2(p91) -- Line: 516
    -- upvalues: u8 (ref), u2 (ref), u10 (ref), u24 (ref), u6 (ref), u23 (ref), u1 (copy), u18 (copy), u25 (ref)
    u8 = u2.GetComponent("MainMenu");
    u10 = u2.GetComponent("Rewards").Tabs:CreatePage("Playtime Rewards", 3, false, false);
    u24 = u6.Get("Playtime");
    u23 = u6.Get("PlaytimeRewardsCollected");
    u1.new();
    u1.DrawCategories();
    u1.DrawPlaytime();
    u1.DrawAds();
    u1.DrawGroup();
    u1.DrawOdds();
    u1.UpdatePlaytime(true);
    u1.UpdateAds(true);
    u1.UpdateGroupCard(true);
    u1.SelectCategory(u18[1]);
    u1.HideAds();
    u6.Changed("Playtime"):Connect(function(p92) -- Line: 536
        -- upvalues: u24 (ref), u1 (ref)
        u24 = p92;
        u1.UpdatePlaytime();
        u1.UpdateInfo();
    end);
    u6.Changed("PlaytimeRewardsCollected"):Connect(function(p93) -- Line: 543
        -- upvalues: u23 (ref), u25 (ref), u1 (ref)
        u23 = p93;

        if u25 then
            u25.Entry.Pending = false;
            u25 = nil;
        end;

        u1.UpdateAll();
        task.spawn(u1.UpdateGroup);
    end);
    task.spawn(u1.UpdateGroup);
    task.spawn(function() -- Line: 558
        -- upvalues: u10 (ref), u1 (ref)
        while task.wait(1) do
            if u10.Visible then
                u1.UpdateInfo();
            end;
        end;
    end);
end;

function u1.new() -- Line: 569
    -- upvalues: u11 (ref), u12 (ref), u18 (copy), u13 (ref), u14 (ref), u15 (ref), u20 (copy), u17 (ref), u16 (ref), u10 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(108, 108, 108);
    Frame.BackgroundTransparency = 0.95;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.65, 0.78);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 4);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(118, 127, 128);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.7;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(49, 58, 68)),
        ColorSequenceKeypoint.new(0.0986159, Color3.fromRGB(54, 64, 78)),
        ColorSequenceKeypoint.new(0.32699, Color3.fromRGB(62, 71, 82)),
        ColorSequenceKeypoint.new(0.548443, Color3.fromRGB(74, 86, 97)),
        ColorSequenceKeypoint.new(0.685121, Color3.fromRGB(71, 80, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 57, 63))
    });
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.03), NumberSequenceKeypoint.new(1, 0.03) });
    UIGradient.Parent = UIStroke;
    UIStroke.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.05);
    TextLabel.Size = UDim2.fromScale(0.8, 0.1);
    TextLabel.Text = "PLAYTIME REWARDS";
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(232, 232, 232);
    Frame2.BackgroundTransparency = 0.5;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0.135);
    Frame2.Size = UDim2.new(0.8, 0, 0, 2);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.199789, 0),
        NumberSequenceKeypoint.new(0.800211, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame2;
    Frame2.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Tip";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.15);
    TextLabel2.Size = UDim2.fromScale(0.8, 0.04);
    TextLabel2.Text = "Play to accumulate playtime, rewards reset daily";
    TextLabel2.TextColor3 = Color3.fromRGB(175, 231, 255);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.2;
    TextLabel2.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.fromRGB(140, 140, 140);
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.fromOffset(512, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.62;
    UIAspectRatioConstraint.Parent = Frame;
    u11 = Instance.new("Frame");
    u11.Name = "Categories";
    u11.AnchorPoint = Vector2.new(0.5, 0);
    u11.BackgroundColor3 = Color3.new();
    u11.BackgroundTransparency = 0.8;
    u11.Position = UDim2.fromScale(0.5, 0.225);
    u11.Size = UDim2.fromScale(0.42, 0.07);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.2, 0);
    UICorner2.Parent = u11;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.fromRGB(232, 232, 232);
    UIStroke2.Thickness = 1;
    UIStroke2.Transparency = 0.85;
    UIStroke2.Parent = u11;
    u12 = Instance.new("Frame");
    u12.Name = "Indicator";
    u12.BackgroundTransparency = 1;
    u12.Size = UDim2.fromScale(1 / #u18, 1);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Fill";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.fromRGB(131, 216, 255);
    Frame3.BackgroundTransparency = 0.5;
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.new(1, -6, 1, -6);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.2, 0);
    UICorner3.Parent = Frame3;
    Frame3.Parent = u12;
    u12.Parent = u11;
    u11.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Info";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 0.325);
    Frame4.Size = UDim2.fromScale(0.92, 0.055);
    u13 = Instance.new("TextLabel");
    u13.Name = "Info";
    u13.AnchorPoint = Vector2.new(0, 0.5);
    u13.BackgroundTransparency = 1;
    u13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    u13.Position = UDim2.fromScale(0, 0.5);
    u13.Size = UDim2.fromScale(0.45, 0.75);
    u13.Text = "PLAYTIME 00:00";
    u13.TextColor3 = Color3.fromRGB(232, 232, 232);
    u13.TextScaled = true;
    u13.TextXAlignment = Enum.TextXAlignment.Left;
    u13.Parent = Frame4;
    u14 = Instance.new("TextLabel");
    u14.Name = "UpdateIn";
    u14.AnchorPoint = Vector2.new(1, 0.5);
    u14.BackgroundTransparency = 1;
    u14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    u14.Position = UDim2.fromScale(1, 0.5);
    u14.Size = UDim2.fromScale(0.45, 0.75);
    u14.Text = "RESETS IN 00:00:00";
    u14.TextColor3 = Color3.fromRGB(232, 232, 232);
    u14.TextScaled = true;
    u14.TextXAlignment = Enum.TextXAlignment.Right;
    u14.Parent = Frame4;
    Frame4.Parent = Frame;
    u15 = Instance.new("Frame");
    u15.Name = "Pages";
    u15.AnchorPoint = Vector2.new(0.5, 0);
    u15.BackgroundTransparency = 1;
    u15.Position = UDim2.fromScale(0.5, 0.405);
    u15.Size = UDim2.fromScale(0.92, 0.47);

    for _, v in u18 do
        local Frame5 = Instance.new("Frame");
        Frame5.Name = v;
        Frame5.BackgroundTransparency = 1;
        Frame5.Size = UDim2.fromScale(1, 1);
        Frame5.Visible = false;

        if v == "Playtime" then
            local UIGridLayout = Instance.new("UIGridLayout");
            UIGridLayout.Name = "UIGridLayout";
            UIGridLayout.CellPadding = UDim2.fromScale(0.02, 0.06);
            UIGridLayout.CellSize = UDim2.fromScale(0.235, 0.47);
            UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
            UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
            UIGridLayout.Parent = Frame5;
        elseif v == "Ads" then
            local UIListLayout = Instance.new("UIListLayout");
            UIListLayout.Name = "UIListLayout";
            UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            UIListLayout.Padding = UDim.new(0.025, 0);
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
            UIListLayout.Parent = Frame5;
        end;

        u20[v] = Frame5;
        Frame5.Parent = u15;
    end;

    u17 = Instance.new("TextLabel");
    u17.Name = "Tip";
    u17.AnchorPoint = Vector2.new(0, 0.5);
    u17.BackgroundTransparency = 1;
    u17.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u17.Position = UDim2.fromScale(0.52, 0.5);
    u17.RichText = true;
    u17.Size = UDim2.fromScale(0.36, 0.45);
    u17.Text = "<font color=\"rgb(255, 189, 74)\">JOIN THE GROUP</font> and <font color=\"rgb(255, 189, 74)\">LIKE</font> + <font color=\"rgb(255, 189, 74)\">FAVOURITE</font> to get FREE DAILY REWARD!";
    u17.TextColor3 = Color3.fromRGB(232, 232, 232);
    u17.TextScaled = true;
    u17.TextWrapped = true;
    u17.TextXAlignment = Enum.TextXAlignment.Left;
    u17.Parent = u20.Group;
    u15.Parent = Frame;
    u16 = Instance.new("Frame");
    u16.Name = "Odds";
    u16.AnchorPoint = Vector2.new(0.5, 0);
    u16.BackgroundTransparency = 1;
    u16.Position = UDim2.fromScale(0.5, 0.9);
    u16.Size = UDim2.fromScale(0.92, 0.05);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.012, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = u16;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.LayoutOrder = 0;
    TextLabel3.Size = UDim2.fromScale(0.1, 0.8);
    TextLabel3.Text = "REWARDS:";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.Parent = u16;
    u16.Parent = Frame;
    Frame.Parent = u10;
end;

function u1.categoryButton(p94, p95) -- Line: 864
    -- upvalues: u18 (copy), u29 (copy), u11 (ref)
    local v96 = #u18;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p94;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Position = UDim2.fromScale((p95 - 1) / v96, 0);
    TextButton.Size = UDim2.fromScale(1 / v96, 1);
    TextButton.Text = "";
    TextButton.TextTransparency = 1;
    TextButton.ZIndex = 2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.8, 0.42);
    TextLabel.Text = p94:upper();
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 5;
    TextLabel.Parent = TextButton;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.2, 0);
    UICorner.Parent = TextButton;
    local Frame = Instance.new("Frame");
    Frame.Name = "Dot";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.BackgroundColor3 = u29.Notice;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.97, 0.15);
    Frame.Size = UDim2.fromScale(0.2, 0.2);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame.ZIndex = 5;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame;
    Frame.Parent = TextButton;
    TextButton.Parent = u11;

    return TextButton;
end;

function u1.entry(p97, p98, p99, p100, p101, p102, p103) -- Line: 923
    -- upvalues: u1 (copy), TweenService (copy), TweenInfo_new_ret4 (copy), u21 (copy), HookButton (copy), TweenInfo_new_ret (copy)
    local v104 = u1.card(p97, p99, p100, p101, p102, p103);
    local Holder = v104.Holder;
    local v105 = {
        Pending = false,
        State = "Locked",
        Card = v104,
        Holder = Holder,
        Pulse = TweenService:Create(Holder.UIStroke, TweenInfo_new_ret4, {
            Transparency = 0.75
        })
    };
    u21[p97.Name][p98] = v105;
    HookButton(Holder.Claim);
    v104.MouseEnter:Connect(function() -- Line: 939
        -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Holder, TweenInfo_new_ret, {
            BackgroundTransparency = 0.84
        }):Play();
    end);
    v104.MouseLeave:Connect(function() -- Line: 943
        -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Holder, TweenInfo_new_ret, {
            BackgroundTransparency = 0.9
        }):Play();
    end);

    return v105;
end;

function u1.card(p106, p107, p108, p109, p110, p111) -- Line: 950
    -- upvalues: u29 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = tostring(p107);
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p107;
    Frame.Size = UDim2.fromScale(p108, 1);
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Holder";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.BackgroundColor3 = Color3.new();
    CanvasGroup.BackgroundTransparency = 0.9;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.04, 0);
    UICorner.Parent = CanvasGroup;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(45, 53, 62);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.3;
    UIStroke.Parent = CanvasGroup;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Accent";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundColor3 = Color3.fromRGB(232, 232, 232);
    Frame2.BackgroundTransparency = 0.7;
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0);
    Frame2.Size = UDim2.new(0.7, 0, 0, 2);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame2;
    Frame2.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Top";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.05);
    TextLabel.Size = UDim2.fromScale(0.9, 0.11);
    TextLabel.Text = p109;
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://107995524735706";
    ImageLabel.Position = UDim2.fromScale(0.5, 0.38);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.3, 0.3);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = CanvasGroup;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Sub";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.58);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.075);
    TextLabel2.Text = p110;
    TextLabel2.TextColor3 = Color3.fromRGB(175, 231, 255);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.2;
    TextLabel2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "ProgressBar";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.73);
    Frame3.Size = UDim2.fromScale(0.84, 0.035);
    Frame3.Visible = p111;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Background";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
    Frame4.BackgroundTransparency = 0.3;
    Frame4.Position = UDim2.fromScale(0.5, 0.5);
    Frame4.Size = UDim2.fromScale(1, 1);
    Frame4.ZIndex = -1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.5, 0);
    UICorner2.Parent = Frame4;
    Frame4.Parent = Frame3;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Bar";
    Frame5.AnchorPoint = Vector2.new(0, 0.5);
    Frame5.BackgroundColor3 = u29.Bar;
    Frame5.Position = UDim2.fromScale(0, 0.5);
    Frame5.Size = UDim2.fromScale(0, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.5, 0);
    UICorner3.Parent = Frame5;
    Frame5.Parent = Frame3;
    Frame3.Parent = CanvasGroup;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Claim";
    TextButton.AnchorPoint = Vector2.new(0.5, 1);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Position = UDim2.fromScale(0.5, 0.94);
    TextButton.Size = UDim2.fromScale(0.84, 0.13);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.TextTransparency = 1;
    TextButton.ZIndex = 3;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel3.Size = UDim2.fromScale(0.86, 0.55);
    TextLabel3.Text = "CLAIM";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 5;
    TextLabel3.Parent = TextButton;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Shadow";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://186491278";
    ImageLabel2.ImageTransparency = 0.64;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Slice;
    ImageLabel2.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel2.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel2.ZIndex = -9999;
    ImageLabel2.Parent = TextButton;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Frame";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundColor3 = Color3.fromRGB(53, 54, 54);
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(1, 1);
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = Frame6;
    Frame6.Parent = TextButton;
    TextButton.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    Frame.Parent = p106;

    return Frame;
end;

function u1.widen(p112) -- Line: 1150
    p112.Top.AnchorPoint = Vector2.new(0, 0);
    p112.Top.Position = UDim2.fromScale(0.42, 0.1);
    p112.Top.Size = UDim2.fromScale(0.52, 0.2);
    p112.Top.TextXAlignment = Enum.TextXAlignment.Left;
    p112.Icon.Position = UDim2.fromScale(0.21, 0.38);
    p112.Icon.Size = UDim2.fromScale(0.5, 0.5);
    p112.Sub.AnchorPoint = Vector2.new(0, 0);
    p112.Sub.Position = UDim2.fromScale(0.42, 0.33);
    p112.Sub.Size = UDim2.fromScale(0.52, 0.13);
    p112.Sub.TextXAlignment = Enum.TextXAlignment.Left;
    p112.ProgressBar.AnchorPoint = Vector2.new(0, 0.5);
    p112.ProgressBar.Position = UDim2.fromScale(0.42, 0.58);
    p112.ProgressBar.Size = UDim2.fromScale(0.52, 0.06);
    p112.Claim.Position = UDim2.fromScale(0.5, 0.92);
    p112.Claim.Size = UDim2.fromScale(0.88, 0.22);
end;

function u1.oddChip(p113, p114) -- Line: 1172
    -- upvalues: u16 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Odd";
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.8;
    Frame.LayoutOrder = p113;
    Frame.Size = UDim2.fromScale(0.12, 1);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.25, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(232, 232, 232);
    UIStroke.Thickness = 1;
    UIStroke.Transparency = 0.85;
    UIStroke.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://138240378050344";
    ImageLabel.Position = UDim2.fromScale(0.08, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.65, 0.65);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Label";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.3, 0.5);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(0.62, 0.7);
    TextLabel.Text = p114;
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    Frame.Parent = u16;

    return Frame;
end;

return u1;