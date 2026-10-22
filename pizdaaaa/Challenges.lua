-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Challenges
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Challenges
-- Decompile time: 33.43 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local MarketplaceService = game:GetService("MarketplaceService");
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
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = {};
local u25 = {};
local u26 = {};
local u27 = {
    Text = Color3.fromRGB(232, 232, 232),
    Tab = Color3.fromRGB(131, 216, 255),
    Accent = Color3.fromRGB(131, 216, 255),
    Ready = Color3.fromRGB(129, 255, 120),
    Gold = Color3.fromRGB(255, 200, 111),
    Warning = Color3.fromRGB(255, 189, 74),
    Error = Color3.fromRGB(255, 84, 87),
    Success = Color3.fromRGB(116, 255, 132),
    Notice = Color3.fromRGB(106, 177, 207),
    Button = Color3.fromRGB(50, 94, 128),
    ButtonHover = Color3.fromRGB(63, 119, 161),
    Claim = Color3.fromRGB(58, 130, 84),
    ClaimHover = Color3.fromRGB(70, 156, 101),
    Abandon = Color3.fromRGB(166, 26, 35),
    AbandonHover = Color3.fromRGB(200, 31, 43),
    Disabled = Color3.fromRGB(53, 54, 54),
    Claimed = Color3.fromRGB(40, 40, 48),
    Stroke = Color3.fromRGB(45, 53, 62),
    Bar = Color3.fromRGB(96, 158, 186),
    BarReady = Color3.fromRGB(106, 208, 123),
    BarClaimed = Color3.fromRGB(90, 90, 96)
};
local u28 = {
    Idle = {
        Title = "START",
        Dim = 0,
        Color = u27.Button,
        Hover = u27.ButtonHover,
        Accent = u27.Text,
        Bar = u27.Bar
    },
    Active = {
        Title = "CLAIM",
        Dim = 0.5,
        Color = u27.Disabled,
        Hover = u27.Disabled,
        Accent = u27.Accent,
        Bar = u27.Bar
    },
    Ready = {
        Title = "CLAIM",
        Dim = 0,
        Color = u27.Claim,
        Hover = u27.ClaimHover,
        Accent = u27.Ready,
        Bar = u27.BarReady
    },
    Claimed = {
        Title = "CLAIMED",
        Dim = 0.5,
        Color = u27.Claimed,
        Hover = u27.Claimed,
        Accent = u27.BarClaimed,
        Bar = u27.BarClaimed
    },
    Locked = {
        Title = "PREMIUM",
        Dim = 0.5,
        Color = u27.Disabled,
        Hover = u27.Disabled,
        Accent = u27.Gold,
        Bar = u27.Bar
    }
};
local u29 = {
    Full = {
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.94),
        Size = UDim2.fromScale(0.86, 0.12)
    },
    Split = {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.fromScale(0.93, 0.94),
        Size = UDim2.fromScale(0.42, 0.12)
    }
};
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret3 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret4 = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local TweenInfo_new_ret5 = TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 1.4);

local function GetState(p30, p31) -- Line: 72
    -- upvalues: u6 (ref)
    return p30.completed and "Claimed" or (p30.isPremium and not u6.Get("Battlepass").Premium and "Locked" or (p30.chosen and (p30.progress >= p31.Amount and "Ready" or "Active") or "Idle"));
end;

local function ChosenCount(p32) -- Line: 84
    -- upvalues: u22 (ref)
    local v33 = 0;

    for _, v in u22[p32] do
        v33 = v33 + (v.chosen and 1 or 0);
    end;

    return v33;
end;

local function HasReady(p34) -- Line: 94
    -- upvalues: u22 (ref), u5 (ref), u6 (ref)
    for _, v in u22[p34] do
        local v35 = u5[p34][v.name];

        if (v.completed and "Claimed" or (v.isPremium and not u6.Get("Battlepass").Premium and "Locked" or (v.chosen and (v.progress >= v35.Amount and "Ready" or "Active") or "Idle"))) == "Ready" then
            return true;
        end;
    end;

    return false;
end;

local function CanStart(p36) -- Line: 104
    -- upvalues: u22 (ref), u5 (ref), u6 (ref)
    local v37 = 0;

    for _, v in u22[p36] do
        v37 = v37 + (v.chosen and 1 or 0);
    end;

    if u5.Challenges[p36].Limit <= v37 then
        return false;
    end;

    for _, v in u22[p36] do
        local v38 = u5[p36][v.name];

        if (v.completed and "Claimed" or (v.isPremium and not u6.Get("Battlepass").Premium and "Locked" or (v.chosen and (v.progress >= v38.Amount and "Ready" or "Active") or "Idle"))) == "Idle" then
            return true;
        end;
    end;

    return false;
end;

local function ResetIn(p39) -- Line: 118
    local DateTime_now_ret = DateTime.now();
    local UnixTimestamp = DateTime_now_ret.UnixTimestamp;

    if p39 == "Hourly" then
        return 3600 - UnixTimestamp % 3600;
    end;

    if p39 == "Daily" then
        return 86400 - UnixTimestamp % 86400;
    end;

    if p39 == "Weekly" then
        return 604800 - UnixTimestamp % 604800;
    end;

    local v40 = DateTime_now_ret:ToUniversalTime();

    return DateTime.fromUniversalTime(v40.Year + v40.Month // 12, v40.Month % 12 + 1, 1).UnixTimestamp - UnixTimestamp;
end;

local function FormatTime(p41) -- Line: 135
    local v42 = {};

    for _, v in {
        { "d", p41 // 86400 },
        { "h", p41 // 3600 % 24 },
        { "m", p41 // 60 % 60 },
        { "s", p41 % 60 }
    } do
        if #v42 > 0 or (v[2] > 0 or v[1] == "s") then
            local v43 = `{v[2]}{v[1]}`;
            table.insert(v42, v43);
        end;
    end;

    return table.concat(v42, " ");
end;

local function AbandonFocus(p44: any, p45: boolean) -- Line: 153
    p44:SetAttribute("NoSelect", not p45);
    p44.Selectable = p45;
end;

local function Animate(p46: any, p47: userdata, p48: any, p49: boolean) -- Line: 158
    -- upvalues: TweenService (copy)
    if p49 then
        for i, v in p48 do
            p46[i] = v;
        end;

        return;
    end;

    TweenService:Create(p46, p47, p48):Play();
end;

local function Paint(p50: any, p51, p52, p53: boolean) -- Line: 170
    -- upvalues: TweenInfo_new_ret (copy), TweenService (copy)
    p50:SetAttribute("Color", p51);
    p50:SetAttribute("HoverColor", p52);
    local Frame = p50.Frame;
    local v54 = {
        BackgroundColor3 = p51
    };

    if p53 then
        for i, v in v54 do
            Frame[i] = v;
        end;

        return;
    end;

    TweenService:Create(Frame, TweenInfo_new_ret, v54):Play();
end;

local function HookButton(u55) -- Line: 177
    -- upvalues: u10 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    u55.MouseEnter:Connect(function() -- Line: 178
        -- upvalues: u55 (copy), u10 (ref), TweenService (ref), TweenInfo_new_ret (ref)
        if u55:GetAttribute("NoSelect") or u55:GetAttribute("Color") == u55:GetAttribute("HoverColor") then
            return;
        end;

        u10.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u55.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = u55:GetAttribute("HoverColor")
        }):Play();
    end);
    u55.MouseLeave:Connect(function() -- Line: 186
        -- upvalues: TweenService (ref), u55 (copy), TweenInfo_new_ret (ref)
        TweenService:Create(u55.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = u55:GetAttribute("Color")
        }):Play();
    end);
end;

function u1.DrawCategories() -- Line: 193
    -- upvalues: u24 (copy), u1 (copy), u25 (copy), u3 (ref), u23 (ref), u10 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    for i, v in u24 do
        local u56 = u1.categoryButton(v, i);
        u25[v] = u56;
        u3:Add(`{v}MouseEnter`, u56.MouseEnter:Connect(function() -- Line: 199
            -- upvalues: u23 (ref), v (copy), u10 (ref), TweenService (ref), u56 (copy), TweenInfo_new_ret (ref)
            if u23 == v then
                return;
            end;

            u10.Play("UI.submenu_dropdown_rollover");
            TweenService:Create(u56, TweenInfo_new_ret, {
                BackgroundTransparency = 0.9
            }):Play();
        end));
        u3:Add(`{v}MouseLeave`, u56.MouseLeave:Connect(function() -- Line: 207
            -- upvalues: TweenService (ref), u56 (copy), TweenInfo_new_ret (ref)
            TweenService:Create(u56, TweenInfo_new_ret, {
                BackgroundTransparency = 1
            }):Play();
        end));
        u3:Add(`{v}Button1Click`, u56.MouseButton1Click:Connect(function() -- Line: 211
            -- upvalues: u23 (ref), v (copy), u10 (ref), u1 (ref)
            if u23 == v then
                return;
            end;

            u10.Play("UI.submenu_click");
            u1.SelectCategory(v);
        end));
    end;
end;

function u1.DrawReroll() -- Line: 221
    -- upvalues: u3 (ref), u20 (ref), u10 (ref), TweenService (copy), TweenInfo_new_ret (copy), u27 (copy), MarketplaceService (copy), LocalPlayer (copy), u5 (ref), u23 (ref)
    u3:Add("RerollMouseEnter", u20.MouseEnter:Connect(function() -- Line: 222
        -- upvalues: u10 (ref), TweenService (ref), u20 (ref), TweenInfo_new_ret (ref), u27 (ref)
        u10.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u20, TweenInfo_new_ret, {
            BackgroundColor3 = u27.ButtonHover
        }):Play();
    end));
    u3:Add("RerollMouseLeave", u20.MouseLeave:Connect(function() -- Line: 228
        -- upvalues: TweenService (ref), u20 (ref), TweenInfo_new_ret (ref), u27 (ref)
        TweenService:Create(u20, TweenInfo_new_ret, {
            BackgroundColor3 = u27.Button
        }):Play();
    end));
    u3:Add("RerollClick", u20.MouseButton1Click:Connect(function() -- Line: 232
        -- upvalues: u10 (ref), MarketplaceService (ref), LocalPlayer (ref), u5 (ref), u23 (ref)
        u10.Play("UI.submenu_dropdown_option_select");
        MarketplaceService:PromptProductPurchase(LocalPlayer, u5.Challenges[u23].RerollProduct);
    end));
end;

function u1.SelectCategory(p57) -- Line: 238
    -- upvalues: u23 (ref), u25 (copy), TweenService (copy), TweenInfo_new_ret (copy), u27 (copy), u17 (ref), TweenInfo_new_ret3 (copy), u20 (ref), u5 (ref), u1 (copy)
    u23 = p57;

    for i, v in u25 do
        TweenService:Create(v, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        }):Play();
        TweenService:Create(v.Title, TweenInfo_new_ret, {
            TextColor3 = i == p57 and u27.Tab or Color3.new(1, 1, 1)
        }):Play();
    end;

    TweenService:Create(u17, TweenInfo_new_ret3, {
        Position = u25[p57].Position
    }):Play();
    u20.Visible = u5.Challenges[p57].RerollProduct ~= nil;
    u1.DrawCards();
    u1.UpdateTimer();
end;

function u1.Refresh() -- Line: 254
    -- upvalues: u22 (ref), u23 (ref), u26 (copy), u1 (copy)
    for i, v in u22[u23] do
        if not u26[i] or u26[i].Name ~= v.name then
            u1.DrawCards();

            return;
        end;
    end;

    u1.UpdateCards();
end;

function u1.DrawCards() -- Line: 266
    -- upvalues: u26 (copy), u23 (ref), u22 (ref), u5 (ref), u1 (copy), TweenService (copy), TweenInfo_new_ret4 (copy), TweenInfo_new_ret5 (copy), TweenInfo_new_ret3 (copy)
    for _, v in u26 do
        v.Pulse:Cancel();
        v.Shine:Cancel();
        v.Card:Destroy();
    end;

    table.clear(u26);
    local v58 = u23;

    for i, v in u22[v58] do
        local v59 = u5[v58][v.name];
        local v60 = tonumber(i);
        local v61 = u1.card(v.name, v59.Description, v60);
        local Holder = v61.Holder;
        u1.DrawRewards(Holder.Rewards, v59.Rewards);
        local v62 = {
            Pending = false,
            Card = v61,
            Name = v.name,
            Pulse = TweenService:Create(Holder.UIStroke, TweenInfo_new_ret4, {
                Transparency = 0.75
            }),
            Shine = TweenService:Create(Holder.ProgressBar.Bar.UIGradient, TweenInfo_new_ret5, {
                Offset = Vector2.new(1, 0)
            })
        };
        u26[i] = v62;
        u1.BindCard(v58, i, v62);
        Holder.GroupTransparency = 1;
        Holder.Position = UDim2.fromScale(0.5, 0.56);
        task.delay((v60 - 1) * 0.06, function() -- Line: 301
            -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret3 (ref)
            TweenService:Create(Holder, TweenInfo_new_ret3, {
                GroupTransparency = 0,
                Position = UDim2.fromScale(0.5, 0.5)
            }):Play();
        end);
    end;

    u1.ScaleText();
    u1.UpdateCards(true);
end;

function u1.BindCard(u63, u64, u65) -- Line: 310
    -- upvalues: HookButton (copy), TweenService (copy), TweenInfo_new_ret (copy), u22 (ref), u5 (ref), u6 (ref), u10 (ref), u12 (ref), u27 (copy), u4 (ref), u14 (ref), u13 (ref)
    local Card = u65.Card;
    local Holder = Card.Holder;
    local Claim = Holder.Claim;
    local Abandon = Holder.Abandon;
    HookButton(Claim);
    HookButton(Abandon);
    Card.MouseEnter:Connect(function() -- Line: 318
        -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Holder, TweenInfo_new_ret, {
            BackgroundTransparency = 0.84
        }):Play();
    end);
    Card.MouseLeave:Connect(function() -- Line: 322
        -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref)
        TweenService:Create(Holder, TweenInfo_new_ret, {
            BackgroundTransparency = 0.9
        }):Play();
    end);
    Claim.MouseButton1Click:Connect(function() -- Line: 326
        -- upvalues: u65 (copy), u22 (ref), u63 (copy), u64 (copy), u5 (ref), u6 (ref), u10 (ref), u12 (ref), u27 (ref), u4 (ref), u14 (ref)
        if u65.Pending then
            return;
        end;

        local v66 = u22[u63][u64];
        local v67 = u5[u63][v66.name];
        local v68 = v66.completed and "Claimed" or (v66.isPremium and not u6.Get("Battlepass").Premium and "Locked" or (v66.chosen and (v66.progress >= v67.Amount and "Ready" or "Active") or "Idle"));

        if v68 ~= "Idle" then
            if v68 == "Ready" then
                u65.Pending = true;
                u10.Play("UI.submenu_click");
                u4.Gui.ClaimChallengeReward.Fire({
                    Category = u63,
                    Index = tonumber(u64)
                });
                u14.RewardsNotifications(v67.Rewards);
            end;

            return;
        end;

        local v69 = 0;

        for _, v in u22[u63] do
            v69 = v69 + (v.chosen and 1 or 0);
        end;

        if u5.Challenges[u63].Limit <= v69 then
            u10.Play("UI.lobby_error");
            u12:Create("Reached the limit of selected challenges", u27.Error);

            return;
        end;

        u65.Pending = true;
        u10.Play("UI.submenu_click");
        u4.Gui.StartChallenge.Fire({
            Category = u63,
            Index = tonumber(u64)
        });
    end);
    Abandon.MouseButton1Click:Connect(function() -- Line: 361
        -- upvalues: Abandon (copy), u10 (ref), u13 (ref), u4 (ref), u63 (copy), u64 (copy), u12 (ref), u27 (ref)
        if Abandon:GetAttribute("NoSelect") then
            return;
        end;

        u10.Play("UI.submenu_dropdown_option_select");
        u13:Create("Challenge Abandon", "Are you sure you want to abandon challenge?", function() -- Line: 366
            -- upvalues: u4 (ref), u63 (ref), u64 (ref), u12 (ref), u27 (ref)
            u4.Gui.AbandonChallenge.Fire({
                Category = u63,
                Index = tonumber(u64)
            });
            u12:Create("Successfully abandoned challenge!", u27.Success);
        end);
    end);
end;

function u1.UpdateCards(p70: boolean) -- Line: 377
    -- upvalues: u5 (ref), u23 (ref), u22 (ref), u18 (ref), u26 (copy), u1 (copy)
    local Limit = u5.Challenges[u23].Limit;
    local v71 = 0;

    for _, v in u22[u23] do
        v71 = v71 + (v.chosen and 1 or 0);
    end;

    u18.Text = `{v71}/{Limit} CHOSEN`;

    for i, v in u26 do
        u1.UpdateCard(i, v, Limit <= v71, p70);
    end;

    u1.UpdateNotices();
end;

function u1.UpdateCard(p72: any, p73: any, p74: boolean, p75: boolean) -- Line: 390
    -- upvalues: u22 (ref), u23 (ref), u5 (ref), u6 (ref), u28 (copy), TweenService (copy), TweenInfo_new_ret2 (copy), Paint (copy), u27 (copy), TweenInfo_new_ret (copy), u29 (copy)
    local v76 = u22[u23][p72];
    local v77 = u5[u23][v76.name];
    local v78 = v76.completed and "Claimed" or (v76.isPremium and not u6.Get("Battlepass").Premium and "Locked" or (v76.chosen and (v76.progress >= v77.Amount and "Ready" or "Active") or "Idle"));
    local v79 = u28[v78];

    if v78 ~= "Idle" then
        p74 = false;
    end;

    local Holder = p73.Card.Holder;
    local Claim = Holder.Claim;
    local Abandon = Holder.Abandon;
    local ProgressBar = Holder.ProgressBar;
    local v80 = v78 == "Active";
    local v81 = v78 == "Claimed" and true or v78 == "Locked";
    p73.Pending = false;
    ProgressBar.Title.Text = `{v76.progress}/{v77.Amount}`;
    TweenService:Create(ProgressBar.Bar, TweenInfo_new_ret2, {
        Size = UDim2.fromScale(math.clamp(v76.progress / v77.Amount, 0, 1), 1),
        BackgroundColor3 = v79.Bar
    }):Play();
    Claim.Title.Text = v79.Title;
    Paint(Claim, p74 and u27.Disabled or v79.Color, p74 and u27.Disabled or v79.Hover, p75);
    local Title = Claim.Title;
    local v82 = TweenInfo_new_ret;
    local v83 = {
        TextTransparency = p74 and 0.5 or v79.Dim
    };

    if p75 then
        for i, v in v83 do
            Title[i] = v;
        end;
    else
        TweenService:Create(Title, v82, v83):Play();
    end;

    local v84 = TweenInfo_new_ret;
    local v85 = v80 and u29.Split or u29.Full;

    if p75 then
        for i, v in v85 do
            Claim[i] = v;
        end;
    else
        TweenService:Create(Claim, v84, v85):Play();
    end;

    local Frame = Abandon.Frame;
    local v86 = TweenInfo_new_ret;
    local v87 = {
        BackgroundTransparency = v80 and 0 or 1
    };

    if p75 then
        for i, v in v87 do
            Frame[i] = v;
        end;
    else
        TweenService:Create(Frame, v86, v87):Play();
    end;

    local Title2 = Abandon.Title;
    local v88 = TweenInfo_new_ret;
    local v89 = {
        TextTransparency = v80 and 0 or 1
    };

    if p75 then
        for i, v in v89 do
            Title2[i] = v;
        end;
    else
        TweenService:Create(Title2, v88, v89):Play();
    end;

    local Shadow = Abandon.Shadow;
    local v90 = TweenInfo_new_ret;
    local v91 = {
        ImageTransparency = v80 and 0.64 or 1
    };

    if p75 then
        for i, v in v91 do
            Shadow[i] = v;
        end;
    else
        TweenService:Create(Shadow, v90, v91):Play();
    end;

    Abandon:SetAttribute("NoSelect", not v80);
    Abandon.Selectable = v80;
    local Accent = Holder.Accent;
    local v92 = TweenInfo_new_ret;
    local v93 = {
        BackgroundColor3 = v79.Accent,
        BackgroundTransparency = v78 == "Idle" and 0.7 or 0
    };

    if p75 then
        for i, v in v93 do
            Accent[i] = v;
        end;
    else
        TweenService:Create(Accent, v92, v93):Play();
    end;

    local ChallengeName = Holder.ChallengeName;
    local v94 = TweenInfo_new_ret;
    local v95 = {
        TextTransparency = v81 and 0.5 or 0
    };

    if p75 then
        for i, v in v95 do
            ChallengeName[i] = v;
        end;
    else
        TweenService:Create(ChallengeName, v94, v95):Play();
    end;

    local Description = Holder.Description;
    local v96 = TweenInfo_new_ret;
    local v97 = {
        TextTransparency = v81 and 0.6 or 0.2
    };

    if p75 then
        for i, v in v97 do
            Description[i] = v;
        end;
    else
        TweenService:Create(Description, v96, v97):Play();
    end;

    Holder.Locked.Visible = v78 == "Locked";

    if v78 == "Ready" then
        local UIStroke = Holder.UIStroke;
        local v98 = TweenInfo_new_ret;
        local v99 = {
            Color = u27.Ready
        };

        if p75 then
            for i, v in v99 do
                UIStroke[i] = v;
            end;
        else
            TweenService:Create(UIStroke, v98, v99):Play();
        end;

        if p73.Pulse.PlaybackState ~= Enum.PlaybackState.Playing then
            Holder.UIStroke.Transparency = 0;
            p73.Pulse:Play();
        end;
    else
        p73.Pulse:Cancel();
        local UIStroke = Holder.UIStroke;
        local v100 = TweenInfo_new_ret;
        local v101 = {
            Transparency = 0.3,
            Color = u27.Stroke
        };

        if p75 then
            for i, v in v101 do
                UIStroke[i] = v;
            end;
        else
            TweenService:Create(UIStroke, v100, v101):Play();
        end;
    end;

    ProgressBar.Bar.UIGradient.Enabled = v80;

    if v80 then
        if p73.Shine.PlaybackState ~= Enum.PlaybackState.Playing then
            ProgressBar.Bar.UIGradient.Offset = Vector2.new(-1, 0);
            p73.Shine:Play();
        end;
    else
        p73.Shine:Cancel();
    end;
end;

function u1.UpdateNotices() -- Line: 450
    -- upvalues: u25 (copy), HasReady (copy), TweenService (copy), TweenInfo_new_ret (copy), CanStart (copy), u11 (ref)
    local v102 = false;

    for i, v in u25 do
        local v103 = HasReady(i);
        TweenService:Create(v.Dot, TweenInfo_new_ret, {
            BackgroundTransparency = (v103 or CanStart(i)) and 0 or 1
        }):Play();
        v102 = v102 or v103;
    end;

    if v102 then
        u11.AddNotice("Rewards");
    end;
end;

function u1.UpdateTimer() -- Line: 466
    -- upvalues: ResetIn (copy), u23 (ref), u19 (ref), FormatTime (copy), u27 (copy)
    local v104 = ResetIn(u23);
    u19.Text = `RESETS IN {FormatTime(v104)}`;
    u19.TextColor3 = v104 <= 60 and u27.Warning or u27.Text;
end;

function u1.ScaleText() -- Line: 473
    -- upvalues: u21 (ref), u26 (copy)
    local math_floor_ret = math.floor(u21.AbsoluteSize.Y * 0.06);
    local math_max_ret = math.max(1, math_floor_ret);

    for _, v in u26 do
        v.Card.Holder.Description.UITextSizeConstraint.MaxTextSize = math_max_ret;
    end;
end;

function u1.DrawRewards(p105, p106) -- Line: 481
    -- upvalues: u1 (copy), u7 (ref), u8 (ref), u9 (ref)
    for _, v in p106 do
        local v107, v108 = unpack(v);

        if v107 == "Credits" then
            u1.rewardFrame(p105, `rbxassetid://{138240378050344}`, `{v108}`, UDim2.fromScale(1, 1));
        elseif v107 == "XP" then
            u1.rewardFrame(p105, `rbxassetid://{73202452975271}`, `{v108}`, UDim2.fromScale(1, 1));
        elseif v107 == "Item" or (v107 == "Container" or v107 == "Graphic Art") then
            local v109, v110 = unpack(v108:split("_"));
            local v111 = u7.GetItem(v109, v110) or u8.GetWeaponSkin(v109, v110);
            local v112 = (u7.GetCategory(v109) or u9.Get(v109)).DisplayName or v109;
            local v113 = v111.DisplayName or v110;
            u1.rewardFrame(p105, `rbxassetid://{v111.Thumbnail}`, `{v112} | {v113}`, UDim2.fromScale(1.6, 1));
        end;
    end;
end;

function u1.Init(p114) -- Line: 505
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u4 (ref), u6 (ref), u7 (ref), u8 (ref), u10 (ref), u9 (ref)
    u2 = p114:GetModule("Gui");
    u3 = p114:GetModule("Maid").new();
    u5 = p114:GetModule("ChallengesData");
    u4 = p114:GetModule("Network");
    u6 = p114:GetModule("ProfileData");
    u7 = p114:GetModule("ItemManager");
    u8 = p114:GetModule("SkinManager");
    u10 = p114:GetModule("SoundManager");
    u9 = p114:GetModule("WeaponManager");
end;

function u1.Start2(p115) -- Line: 517
    -- upvalues: u11 (ref), u2 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u5 (ref), u24 (copy), u22 (ref), u6 (ref), u1 (copy), u3 (ref), u21 (ref)
    u11 = u2.GetComponent("MainMenu");
    u12 = u2.GetComponent("MenuNotification");
    u13 = u2.GetComponent("Notify");
    u14 = u2.GetComponent("Rewards");
    u15 = u14.Tabs:CreatePage("Challenges", 2, false, false);

    for i in u5.Challenges do
        table.insert(u24, i);
    end;

    table.sort(u24, function(p116, p117) -- Line: 528
        -- upvalues: u5 (ref)
        return u5.Challenges[p116].Order < u5.Challenges[p117].Order;
    end);
    u22 = u6.Get("Challenges");
    u1.new();
    u1.DrawCategories();
    u1.DrawReroll();
    u1.SelectCategory(u24[1]);
    u6.Changed("Challenges"):Connect(function(p118) -- Line: 539
        -- upvalues: u22 (ref), u1 (ref)
        u22 = p118;
        u1.Refresh();
    end);
    u3:Add("CardsResize", u21:GetPropertyChangedSignal("AbsoluteSize"):Connect(u1.ScaleText));
    task.spawn(function() -- Line: 547
        -- upvalues: u15 (ref), u1 (ref)
        while task.wait(1) do
            if u15.Visible then
                u1.UpdateTimer();
            end;
        end;
    end);
end;

function u1.new() -- Line: 558
    -- upvalues: u16 (ref), u17 (ref), u24 (copy), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u15 (ref)
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
    TextLabel.Text = "CHALLENGES";
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
    TextLabel2.Text = "Complete challenges to earn free credits";
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
    u16 = Instance.new("Frame");
    u16.Name = "Categories";
    u16.AnchorPoint = Vector2.new(0.5, 0);
    u16.BackgroundColor3 = Color3.new();
    u16.BackgroundTransparency = 0.8;
    u16.Position = UDim2.fromScale(0.5, 0.225);
    u16.Size = UDim2.fromScale(0.56, 0.07);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.2, 0);
    UICorner2.Parent = u16;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.fromRGB(232, 232, 232);
    UIStroke2.Thickness = 1;
    UIStroke2.Transparency = 0.85;
    UIStroke2.Parent = u16;
    u17 = Instance.new("Frame");
    u17.Name = "Indicator";
    u17.BackgroundTransparency = 1;
    u17.Size = UDim2.fromScale(1 / #u24, 1);
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
    Frame3.Parent = u17;
    u17.Parent = u16;
    u16.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Info";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 0.325);
    Frame4.Size = UDim2.fromScale(0.92, 0.055);
    u18 = Instance.new("TextLabel");
    u18.Name = "Chosen";
    u18.AnchorPoint = Vector2.new(0, 0.5);
    u18.BackgroundTransparency = 1;
    u18.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    u18.Position = UDim2.fromScale(0, 0.5);
    u18.Size = UDim2.fromScale(0.3, 0.75);
    u18.Text = "0/1 CHOSEN";
    u18.TextColor3 = Color3.fromRGB(232, 232, 232);
    u18.TextScaled = true;
    u18.TextXAlignment = Enum.TextXAlignment.Left;
    u18.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Right";
    Frame5.AnchorPoint = Vector2.new(1, 0.5);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(1, 0.5);
    Frame5.Size = UDim2.fromScale(0.6, 1);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0, 8);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame5;
    u19 = Instance.new("TextLabel");
    u19.Name = "UpdateIn";
    u19.BackgroundTransparency = 1;
    u19.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    u19.LayoutOrder = 1;
    u19.Size = UDim2.fromScale(0.8, 0.75);
    u19.Text = "RESETS IN 00:00:00";
    u19.TextColor3 = Color3.fromRGB(232, 232, 232);
    u19.TextScaled = true;
    u19.TextXAlignment = Enum.TextXAlignment.Right;
    u19.Parent = Frame5;
    u20 = Instance.new("ImageButton");
    u20.Name = "Reroll";
    u20.AutoButtonColor = false;
    u20.BackgroundColor3 = Color3.fromRGB(50, 94, 128);
    u20.LayoutOrder = 2;
    u20.Size = UDim2.fromScale(1, 1);
    u20.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.2, 0);
    UICorner4.Parent = u20;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://125190823049365";
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel2.Parent = u20;
    u20.Parent = Frame5;
    Frame5.Parent = Frame4;
    Frame4.Parent = Frame;
    u21 = Instance.new("Frame");
    u21.Name = "Cards";
    u21.AnchorPoint = Vector2.new(0.5, 0);
    u21.BackgroundTransparency = 1;
    u21.Position = UDim2.fromScale(0.5, 0.405);
    u21.Size = UDim2.fromScale(0.92, 0.55);
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout2.Padding = UDim.new(0.025, 0);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = u21;
    u21.Parent = Frame;
    Frame.Parent = u15;
end;

function u1.categoryButton(p119, p120) -- Line: 819
    -- upvalues: u24 (copy), u27 (copy), u16 (ref)
    local v121 = #u24;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p119;
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundColor3 = Color3.new(1, 1, 1);
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Position = UDim2.fromScale((p120 - 1) / v121, 0);
    TextButton.Size = UDim2.fromScale(1 / v121, 1);
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
    TextLabel.Text = p119:upper();
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
    Frame.BackgroundColor3 = u27.Notice;
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
    TextButton.Parent = u16;

    return TextButton;
end;

function u1.card(p122, p123, p124) -- Line: 878
    -- upvalues: u27 (copy), u21 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = p122;
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p124;
    Frame.Size = UDim2.fromScale(0.23, 1);
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
    TextLabel.Name = "ChallengeName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.055);
    TextLabel.Size = UDim2.fromScale(0.88, 0.11);
    TextLabel.Text = p122;
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.Parent = CanvasGroup;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Description";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.175);
    TextLabel2.Size = UDim2.fromScale(0.86, 0.15);
    TextLabel2.Text = p123;
    TextLabel2.TextColor3 = Color3.fromRGB(175, 231, 255);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.2;
    TextLabel2.TextWrapped = true;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.Name = "UITextSizeConstraint";
    UITextSizeConstraint.Parent = TextLabel2;
    TextLabel2.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Rewards";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.36);
    Frame3.Size = UDim2.fromScale(0.9, 0.25);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.04, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame3;
    Frame3.Parent = CanvasGroup;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "ProgressBar";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 0.715);
    Frame4.Size = UDim2.fromScale(0.86, 0.07);
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Background";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
    Frame5.BackgroundTransparency = 0.3;
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.fromScale(1, 1);
    Frame5.ZIndex = -1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.5, 0);
    UICorner2.Parent = Frame5;
    Frame5.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Bar";
    Frame6.AnchorPoint = Vector2.new(0, 0.5);
    Frame6.BackgroundColor3 = u27.Bar;
    Frame6.Position = UDim2.fromScale(0, 0.5);
    Frame6.Size = UDim2.fromScale(0, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.5, 0);
    UICorner3.Parent = Frame6;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 210, 210)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(210, 210, 210)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(210, 210, 210)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210))
    });
    UIGradient2.Enabled = false;
    UIGradient2.Offset = Vector2.new(-1, 0);
    UIGradient2.Parent = Frame6;
    Frame6.Parent = Frame4;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.6, 0.8);
    TextLabel3.Text = "0/0";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 5;
    TextLabel3.Parent = Frame4;
    Frame4.Parent = CanvasGroup;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Claim";
    TextButton.AnchorPoint = Vector2.new(0.5, 1);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Position = UDim2.fromScale(0.5, 0.94);
    TextButton.Size = UDim2.fromScale(0.86, 0.12);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.TextTransparency = 1;
    TextButton.ZIndex = 3;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel4.Size = UDim2.fromScale(0.8, 0.55);
    TextLabel4.Text = "START";
    TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 5;
    TextLabel4.Parent = TextButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Shadow";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://186491278";
    ImageLabel.ImageTransparency = 0.64;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Slice;
    ImageLabel.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel.ZIndex = -9999;
    ImageLabel.Parent = TextButton;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundColor3 = Color3.fromRGB(50, 94, 128);
    Frame7.Position = UDim2.fromScale(0.5, 0.5);
    Frame7.Size = UDim2.fromScale(1, 1);
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = Frame7;
    Frame7.Parent = TextButton;
    TextButton.Parent = CanvasGroup;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = "Abandon";
    TextButton2.AnchorPoint = Vector2.new(0, 1);
    TextButton2.AutoButtonColor = false;
    TextButton2.BackgroundTransparency = 1;
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton2.Position = UDim2.fromScale(0.07, 0.94);
    TextButton2.Selectable = false;
    TextButton2.Size = UDim2.fromScale(0.42, 0.12);
    TextButton2.Text = "";
    TextButton2.TextColor3 = Color3.new();
    TextButton2.TextSize = 14;
    TextButton2.TextTransparency = 1;
    TextButton2.ZIndex = 2;
    TextButton2:SetAttribute("NoSelect", true);
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel5.Size = UDim2.fromScale(0.8, 0.55);
    TextLabel5.Text = "ABANDON";
    TextLabel5.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel5.TextScaled = true;
    TextLabel5.TextTransparency = 1;
    TextLabel5.ZIndex = 5;
    TextLabel5.Parent = TextButton2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Shadow";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://186491278";
    ImageLabel2.ImageTransparency = 1;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Slice;
    ImageLabel2.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel2.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel2.ZIndex = -9999;
    ImageLabel2.Parent = TextButton2;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Frame";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundColor3 = Color3.fromRGB(166, 26, 35);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.5, 0.5);
    Frame8.Size = UDim2.fromScale(1, 1);
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = Frame8;
    Frame8.Parent = TextButton2;
    TextButton2:SetAttribute("Color", u27.Abandon);
    TextButton2:SetAttribute("HoverColor", u27.AbandonHover);
    TextButton2.Parent = CanvasGroup;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Locked";
    ImageLabel3.AnchorPoint = Vector2.new(1, 0);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://108829592125034";
    ImageLabel3.ImageColor3 = Color3.fromRGB(232, 232, 232);
    ImageLabel3.Position = UDim2.fromScale(0.95, 0.04);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.1, 0.1);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel3.Visible = false;
    ImageLabel3.ZIndex = 4;
    ImageLabel3.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    Frame.Parent = u21;

    return Frame;
end;

function u1.rewardFrame(p125, p126, p127, p128) -- Line: 1201
    local Frame = Instance.new("Frame");
    Frame.Name = "RewardFrame";
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.8;
    Frame.Size = p128;
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.12, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(232, 232, 232);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.02;
    UIStroke.Transparency = 0.85;
    UIStroke.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p126;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.42);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.62, 0.62);
    ImageLabel.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.96);
    TextLabel.Size = UDim2.fromScale(0.9, 0.26);
    TextLabel.Text = p127;
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.Parent = Frame;
    Frame.Parent = p125;

    return Frame;
end;

return u1;