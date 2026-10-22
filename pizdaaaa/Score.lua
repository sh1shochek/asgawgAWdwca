-- ReplicatedStorage.GameClient.Gui.HUD.Score
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Score
-- Decompile time: 36.62 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
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
local LocalPlayer = Players.LocalPlayer;
local GameStats = ReplicatedStorage.GameStats;
local u16 = 0;
local TweenInfo_new_ret = TweenInfo.new(0.1);
local Color3_fromRGB_ret = Color3.fromRGB(184, 214, 239);
local Color3_fromRGB_ret2 = Color3.fromRGB(234, 210, 139);
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = nil;
local u23 = false;

function u1.CalculateTeam(p24: string) -- Line: 59
    -- upvalues: u17 (copy)
    local v25 = 0;

    for i in u17 do
        if i:GetAttribute("Team") == p24 then
            v25 = v25 + 1;
        end;
    end;

    return v25;
end;

function u1.RefreshAlive() -- Line: 72
    -- upvalues: u4 (ref), u2 (ref), u1 (copy)
    if not u4.Visible then
        return;
    end;

    local Score = u2.Handler.HUD.Topbar.Score;
    local LeftFrame = u4.MainFrame.LeftFrame;
    LeftFrame.CT.Alive.Text = `Alive: {Score.CT.Alive.TextLabel.Text}/{u1.CalculateTeam("CT")}`;
    LeftFrame.T.Alive.Text = `Alive: {Score.T.Alive.TextLabel.Text}/{u1.CalculateTeam("T")}`;
end;

function u1.ColorUpdate(p26: userdata, p27) -- Line: 84
    for _, child in p26:GetChildren() do
        if child:IsA("TextLabel") then
            child.TextColor3 = p27;
        end;
    end;
end;

function u1.UpdatePing(p28) -- Line: 92
    -- upvalues: u4 (ref), u19 (copy)
    if not (p28 and (u4 and u4.Visible)) then
        return;
    end;

    for _, v in u19 do
        local Attribute = v.User:GetAttribute("PingId");

        if Attribute then
            Attribute = p28[Attribute];
        end;

        if Attribute ~= nil and Attribute ~= v.LastPing then
            local Ping = v.Ping;

            if Ping then
                v.LastPing = Attribute;
                Ping.Text = Attribute;
            end;
        end;
    end;
end;

local function Inside(p29: userdata, p30) -- Line: 116
    local v31 = p30 - p29.AbsolutePosition;
    local v32;

    if v31.X >= 0 and (v31.Y >= 0 and v31.X <= p29.AbsoluteSize.X) then
        v32 = v31.Y <= p29.AbsoluteSize.Y;
    else
        v32 = false;
    end;

    return v32;
end;

function u1.SetMouseOptions(p33: boolean, p34: boolean?) -- Line: 122
    -- upvalues: u10 (ref)
    if p34 == nil then
        p34 = not p33;
    end;

    u10.SetFramePriority("Score", p34);
end;

function u1.SetProfileVisible(p35: boolean) -- Line: 127
    -- upvalues: u7 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    u7.Visible = p35;

    if not p35 then
        TweenService:Create(u7, TweenInfo_new_ret, {
            GroupTransparency = 1
        }):Play();

        return;
    end;

    local Position = u7.Position;
    u7.Position = Position + UDim2.fromOffset(0, 6);
    TweenService:Create(u7, TweenInfo_new_ret, {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(u7, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = Position
    }):Play();
end;

function u1.IsPinned() -- Line: 142
    -- upvalues: u23 (ref)
    return u23;
end;

function u1.Back() -- Line: 146
    -- upvalues: u7 (ref), u1 (copy)
    if not u7.Visible then
        u1.SetScoreVisibility(false);

        return;
    end;

    u1.SetProfileVisible(false);
    u1.ResetButtons();
end;

function u1.ResetButtons() -- Line: 156
    -- upvalues: u18 (copy)
    for _, v in u18 do
        if v then
            v:Destroy();
        end;
    end;
end;

function u1.SetScoreVisibility(p36: boolean) -- Line: 164
    -- upvalues: u4 (ref), TweenService (copy), u2 (ref), u3 (ref), GameStats (copy), u5 (ref), u1 (copy), UserInputService (copy), u7 (ref), u10 (ref), u23 (ref)
    u4.Visible = p36;

    if not p36 then
        u3:Removes("Time", "CT", "T", "CTAlive", "TAlive", "Profile", "Map");
        u23 = false;
        u1.SetMouseOptions(true, false);
        u1.SetProfileVisible(false);
        u1.ResetButtons();

        return;
    end;

    u4.Position = UDim2.fromScale(0.5, 0.515);
    TweenService:Create(u4, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.5)
    }):Play();
    local CT = u2.Handler.HUD.Topbar.Score.CT;
    local T = u2.Handler.HUD.Topbar.Score.T;
    local CT2 = u4.MainFrame.LeftFrame.CT;
    local T2 = u4.MainFrame.LeftFrame.T;
    u3:Add("Time", GameStats:GetAttributeChangedSignal("Time"):Connect(function() -- Line: 180
        -- upvalues: GameStats (ref), u4 (ref)
        local Attribute = GameStats:GetAttribute("Time");
        u4.Top.Time.Text = string.format("%02d:%02d", math.floor(Attribute / 60), Attribute % 60);
    end));
    u4.Top.Title.Text = GameStats:GetAttribute("Gamemode") .. " | " .. GameStats:GetAttribute("Map");
    u3:Add("Map", GameStats:GetAttributeChangedSignal("Map"):Connect(function() -- Line: 190
        -- upvalues: u4 (ref), GameStats (ref)
        u4.Top.Title.Text = GameStats:GetAttribute("Gamemode") .. " | " .. GameStats:GetAttribute("Map");
    end));
    u3:Add("CT", CT:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 196
        -- upvalues: CT2 (copy), CT (copy), u5 (ref)
        CT2.ImageLabel.Score.Label.Text = CT.Text;
        u5.LeftPanel.First.CT.Text = CT.Text;
    end));
    u3:Add("T", T:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 201
        -- upvalues: T2 (copy), T (copy), u5 (ref)
        T2.ImageLabel.Score.Label.Text = T.Text;
        u5.LeftPanel.First.T.Text = T.Text;
    end));
    u3:Add("CTAlive", CT.Alive.TextLabel:GetPropertyChangedSignal("Text"):Connect(u1.RefreshAlive));
    u3:Add("TAlive", T.Alive.TextLabel:GetPropertyChangedSignal("Text"):Connect(u1.RefreshAlive));
    u3:Add("Profile", UserInputService.InputBegan:Connect(function(p37) -- Line: 211
        -- upvalues: u7 (ref), u1 (ref), u10 (ref), u23 (ref)
        if u7.Visible and (p37.UserInputType == Enum.UserInputType.MouseButton1 or p37.UserInputType == Enum.UserInputType.Touch) then
            local Vector2_new_ret = Vector2.new(p37.Position.X, p37.Position.Y);
            local v38 = u7;
            local v39 = Vector2_new_ret - v38.AbsolutePosition;
            local v40;

            if v39.X >= 0 and (v39.Y >= 0 and v39.X <= v38.AbsoluteSize.X) then
                v40 = v39.Y <= v38.AbsoluteSize.Y;
            else
                v40 = false;
            end;

            if not v40 then
                local BarProfile = u7.BarProfile;
                local v41 = Vector2_new_ret - BarProfile.AbsolutePosition;
                local v42;

                if v41.X >= 0 and (v41.Y >= 0 and v41.X <= BarProfile.AbsoluteSize.X) then
                    v42 = v41.Y <= BarProfile.AbsoluteSize.Y;
                else
                    v42 = false;
                end;

                if not v42 then
                    u1.SetProfileVisible(false);
                    u1.ResetButtons();
                end;
            end;
        end;

        if p37.UserInputType == Enum.UserInputType.MouseButton2 then
            if not u10.FramePriority.Score then
                u1.SetMouseOptions(false, true);
            end;
        elseif p37.KeyCode == Enum.KeyCode.ButtonL2 and not u23 then
            u23 = true;
            u1.SetMouseOptions(false, true);
        end;
    end));
    CT2.ImageLabel.Score.Label.Text = CT.Text;
    T2.ImageLabel.Score.Label.Text = T.Text;
    CT2.ImageLabel.Score.Shadow.Text = CT.Text;
    T2.ImageLabel.Score.Shadow.Text = T.Text;
    u1.RefreshAlive();
end;

function u1.TeamUpdate(p43: string, p44: userdata, p45: userdata) -- Line: 249
    -- upvalues: u4 (ref), LocalPlayer (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u1 (copy)
    p45.Parent = u4.MainFrame.Main[p43];

    if p44 ~= LocalPlayer then
        if p43 == "CT" then
            p45.Icon.UIStroke.Color = Color3_fromRGB_ret;
        else
            p45.Icon.UIStroke.Color = Color3_fromRGB_ret2;
        end;
    end;

    if p43 == "CT" then
        u1.ColorUpdate(p45, Color3_fromRGB_ret);

        return;
    end;

    u1.ColorUpdate(p45, Color3_fromRGB_ret2);
end;

function u1.UserMoneyUI(p46: userdata, p47: userdata, p48: userdata, p49: number) -- Line: 267
    if p46 ~= "Spectator" and p47 ~= p46 then
        p48.Visible = false;

        return;
    end;

    if p49 and p49 <= 0 then
        return;
    end;

    p48.Visible = true;
end;

function u1.UserDefuseKitUI(p50: userdata, p51: userdata, p52: userdata, p53: boolean?) -- Line: 280
    if (p50 == "Spectator" or p51 == p50) and p53 then
        p52.Visible = true;

        return;
    end;

    p52.Visible = false;
end;

function u1.User(u54: userdata) -- Line: 288
    -- upvalues: u1 (copy), LocalPlayer (copy), GameStats (copy), u15 (ref), u3 (ref), u7 (ref), u22 (ref), u14 (ref), u13 (ref), u11 (ref), GuiService (copy), u17 (copy), u19 (copy)
    local u55 = u1.newUser();
    local UserId = u54.UserId;
    local u56 = u54:GetAttribute("Team") or "Spectator";
    local Attribute = LocalPlayer:GetAttribute("Team");
    local Attribute2 = GameStats:GetAttribute("State");
    local Health = u15.GetHealth(u54);
    local Money = u55.Money;
    local DefuseKit = u55:FindFirstChild("DefuseKit");
    u55.Name = u54.UserId;
    u55.Icon.Image = `rbxthumb://type=AvatarHeadShot&id={UserId}&w=420&h=420`;
    u55.PlayerName.Text = u54.Name;
    u1.TeamUpdate(u56, u54, u55);
    u1.UpdatePin(u54, u55);
    Money.Text = u54:GetAttribute("Cash") or "0";
    u1.UserMoneyUI(Attribute, u56, Money, u54:GetAttribute("Cash"));

    if DefuseKit then
        u1.UserDefuseKitUI(Attribute, u56, DefuseKit, u54:GetAttribute("DefuseKit"));
    end;

    if u54:GetAttribute("Kills") ~= nil then
        u55.Kills.Text = u54:GetAttribute("Kills");
        u55.LayoutOrder = -u54:GetAttribute("Kills");
    end;

    if u54:GetAttribute("Deaths") ~= nil then
        u55.Deaths.Text = u54:GetAttribute("Deaths");
    end;

    if u54:GetAttribute("Assists") ~= nil then
        u55.Assists.Text = u54:GetAttribute("Assists");
    end;

    if u54:GetAttribute("AllDMG") ~= nil then
        local AllDMG = u55.AllDMG;
        local Attribute3 = u54:GetAttribute("AllDMG");
        AllDMG.Text = math.floor(Attribute3);
    end;

    if u54:GetAttribute("HeadshotPct") ~= nil then
        u55.Headshots.Text = (u54:GetAttribute("HeadshotPct") or 0 .. "%") .. "%";
    end;

    if Health <= 0 then
        u55.GroupTransparency = 0.8;
    end;

    u3:Add(`{UserId}_Team`, u54:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 347
        -- upvalues: u56 (ref), u54 (copy), Attribute (ref), LocalPlayer (ref), u1 (ref), u55 (copy), Money (copy), DefuseKit (copy)
        u56 = u54:GetAttribute("Team") or "Spectator";
        Attribute = LocalPlayer:GetAttribute("Team");
        u1.TeamUpdate(u56, u54, u55);
        u1.RefreshAlive();
        u1.UserMoneyUI(Attribute, u56, Money, u54:GetAttribute("Cash"));

        if DefuseKit then
            u1.UserDefuseKitUI(Attribute, u56, DefuseKit, u54:GetAttribute("DefuseKit"));
        end;
    end));
    u3:Add(`{UserId}_DefuseKit`, u54:GetAttributeChangedSignal("DefuseKit"):Connect(function() -- Line: 361
        -- upvalues: DefuseKit (copy), u1 (ref), Attribute (ref), u56 (ref), u54 (copy)
        if DefuseKit then
            u1.UserDefuseKitUI(Attribute, u56, DefuseKit, u54:GetAttribute("DefuseKit"));
        end;
    end));
    u3:Add(`{UserId}_WeaponLoadout`, u54:GetAttributeChangedSignal("WeaponLoadout"):Connect(function() -- Line: 367
        -- upvalues: u1 (ref), u54 (copy), u55 (copy)
        u1.UpdatePin(u54, u55);
    end));
    u3:Add(`{UserId}_Cash`, u54:GetAttributeChangedSignal("Cash"):Connect(function() -- Line: 371
        -- upvalues: u55 (copy), u54 (copy)
        u55.Money.Text = u54:GetAttribute("Cash");
    end));
    u3:Add(`{UserId}_Kills`, u54:GetAttributeChangedSignal("Kills"):Connect(function() -- Line: 375
        -- upvalues: u55 (copy), u54 (copy)
        u55.Kills.Text = u54:GetAttribute("Kills");
        u55.LayoutOrder = -u54:GetAttribute("Kills");
    end));
    u3:Add(`{UserId}_Deaths`, u54:GetAttributeChangedSignal("Deaths"):Connect(function() -- Line: 380
        -- upvalues: u55 (copy), u54 (copy)
        u55.Deaths.Text = u54:GetAttribute("Deaths");
    end));
    u3:Add(`{UserId}_Assists`, u54:GetAttributeChangedSignal("Assists"):Connect(function() -- Line: 384
        -- upvalues: u55 (copy), u54 (copy)
        u55.Assists.Text = u54:GetAttribute("Assists");
    end));
    u3:Add(`{UserId}_AllDMG`, u54:GetAttributeChangedSignal("AllDMG"):Connect(function() -- Line: 388
        -- upvalues: u55 (copy), u54 (copy)
        local AllDMG = u55.AllDMG;
        local Attribute3 = u54:GetAttribute("AllDMG");
        AllDMG.Text = math.floor(Attribute3);
    end));
    u3:Add(`{UserId}_Headshots`, u54:GetAttributeChangedSignal("HeadshotPct"):Connect(function() -- Line: 392
        -- upvalues: u55 (copy), u54 (copy)
        u55.Headshots.Text = (u54:GetAttribute("HeadshotPct") or "0%") .. "%";
    end));
    u3:Add(`{UserId}_Healths`, u15.OnHealthUpdate:Connect(function(p57, p58) -- Line: 396
        -- upvalues: UserId (copy), Health (ref), u55 (copy)
        if p57 ~= UserId then
            return;
        end;

        Health = p58;

        if not Health then
            return;
        end;

        if Health <= 0 then
            u55.GroupTransparency = 0.8;

            return;
        end;

        u55.GroupTransparency = 0;
    end));
    u3:Add(`{UserId}_State`, GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 418
        -- upvalues: Attribute2 (ref), u55 (copy), GameStats (ref)
        if Attribute2 == "Warmup" or Attribute2 == "Restart" then
            u55.Headshots.Text = "0%";
            u55.AllDMG.Text = "0";
            u55.Deaths.Text = "0";
            u55.Kills.Text = "0";
            u55.Assists.Text = "0";
        end;

        Attribute2 = GameStats:GetAttribute("State");
    end));

    if u54 ~= LocalPlayer then
        u3:Add(`{u54}_LocalTeam`, LocalPlayer:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 434
            -- upvalues: Attribute (ref), LocalPlayer (ref), u1 (ref), u56 (ref), Money (copy), u54 (copy), DefuseKit (copy)
            Attribute = LocalPlayer:GetAttribute("Team");
            u1.UserMoneyUI(Attribute, u56, Money, u54:GetAttribute("Cash"));

            if DefuseKit then
                u1.UserDefuseKitUI(Attribute, u56, DefuseKit, u54:GetAttribute("DefuseKit"));
            end;
        end));
    end;

    local Mouse = LocalPlayer:GetMouse();
    u3:Add(`{UserId}_Click`, u55.CL.MouseButton1Click:Connect(function() -- Line: 450
        -- upvalues: u1 (ref), u7 (ref), UserId (copy), u54 (copy), u55 (copy), u22 (ref), LocalPlayer (ref), u14 (ref), u13 (ref), u11 (ref), GuiService (ref), Mouse (copy)
        u1.ResetButtons();
        u7.ImageLabelProfile.Image = `rbxthumb://type=AvatarHeadShot&id={UserId}&w=420&h=420`;
        u7.TitleProfile.Text = u54.Name;
        u1.UpdatePin(u54, u55);
        u1.UpdatePin(u54, u7.ImageLabelProfile);
        u22 = u54;
        u1.UpdateProfilePins(u54);
        u1.newButton("Vote Kick", "138287828889172", function() -- Line: 467
            -- upvalues: u54 (ref), LocalPlayer (ref), u14 (ref), u1 (ref), u7 (ref), u13 (ref), u11 (ref)
            if u54 == LocalPlayer then
                MenuNotification:Create("You can\'t kick yourself", Color3.fromRGB(255, 151, 153));

                return;
            end;

            if ((u14 and u14.Get("PlayerStats") or {}).Playtime or 0) < 3600 then
                MenuNotification:Create("You need at least 1 hour of playtime to call a votekick", Color3.fromRGB(255, 151, 153));

                return;
            end;

            u1.ResetButtons();
            u7.TitleProfile.Text = `Kick player: {u54.Name}?`;

            for i, v in u13.VotekickReasons do
                u1.newReason(v, i, function() -- Line: 491
                    -- upvalues: u11 (ref), u54 (ref), i (copy), u1 (ref)
                    u11.Gui.VotekickPlayer.Fire({
                        UserId = u54.UserId,
                        Reason = i
                    });
                    u1.SetProfileVisible(false);
                    u1.ResetButtons();
                end);
            end;
        end);
        u1.newButton("Copy VM Offset", "127723829978984", function() -- Line: 503
            -- upvalues: u54 (ref), LocalPlayer (ref), u11 (ref)
            if u54 == LocalPlayer then
                MenuNotification:Create("You can\'t copy your own viewmodel offset", Color3.fromRGB(255, 151, 153));

                return;
            end;

            u11.Gui.CopyViewmodel.Fire(u54.UserId);
        end);
        u1.newButton("Copy Crosshair", "100348281496893", function() -- Line: 512
            -- upvalues: u54 (ref), LocalPlayer (ref), u11 (ref)
            if u54 == LocalPlayer then
                MenuNotification:Create("You can\'t copy your own crosshair", Color3.fromRGB(255, 151, 153));

                return;
            end;

            u11.Gui.CopyCrosshair.Fire(u54.UserId);
        end);

        if GuiService.SelectedObject == u55.CL then
            local v59 = u55.CL.AbsolutePosition - u7.Parent.AbsolutePosition;
            u7.Position = UDim2.fromOffset(v59.X + u55.CL.AbsoluteSize.X * 0.3, (math.min(v59.Y + u55.CL.AbsoluteSize.Y, u7.Parent.AbsoluteSize.Y - u7.AbsoluteSize.Y)));
        else
            u7.Position = UDim2.fromOffset(Mouse.X + 10, Mouse.Y);
        end;

        u1.SetProfileVisible(true);
    end));
    u17[u54] = {
        ScoreUI = u55
    };
    local v60 = {
        LastPing = nil,
        UI = u55,
        User = u54,
        Ping = u55:FindFirstChild("Ping")
    };
    table.insert(u19, v60);
end;

function u1.UpdatePin(p61, p62) -- Line: 557
    -- upvalues: HttpService (copy), u8 (ref)
    local Attribute = p61:GetAttribute("WeaponLoadout");

    if not Attribute then
        return;
    end;

    local v63 = HttpService:JSONDecode(Attribute).CT["19"];

    if v63 then
        v63 = v63.SkinName;
    end;

    if v63 and v63 ~= "None" then
        local Item = u8.GetItem("Badges", v63);

        if Item then
            p62.Pin.Image = Item.Asset;
            p62.Pin.Visible = true;
        end;
    else
        p62.Pin.Visible = false;
    end;
end;

function u1.UpdateProfilePins(p64, p65) -- Line: 581
    -- upvalues: u7 (ref), u13 (ref), u8 (ref), u1 (copy), LocalPlayer (copy), u12 (ref), u11 (ref)
    for _, child in u7.Pins:GetChildren() do
        if child:IsA("ImageLabel") or child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    if p65 then
        for _, v in p65 do
            local v66 = u13.Items.Badges[v];
            local v67;

            if v66 then
                v67 = u8.GetItem("Badges", v66);
            else
                v67 = v66;
            end;

            if v67 and v66 ~= "None" then
                u1.newPin(v67.Asset);
            end;
        end;

        return;
    end;

    if p64 ~= LocalPlayer then
        if u11.Gui.RequestProfileBadges then
            u11.Gui.RequestProfileBadges.Fire(p64.UserId);
        end;

        return;
    end;

    local v68 = u12.Get();
    local v69 = v68 and v68["Graphic Art"] and v68["Graphic Art"].Badges;

    if not v69 then
        return;
    end;

    for i, _ in v69 do
        if i ~= "None" then
            local Item = u8.GetItem("Badges", i);

            if Item then
                u1.newPin(Item.Asset);
            end;
        end;
    end;
end;

function u1.newPin(p70: string) -- Line: 626
    -- upvalues: u7 (ref)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Pin";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p70;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = u7.Pins;

    return ImageLabel;
end;

function u1.UserLeft(p71) -- Line: 638
    -- upvalues: u17 (copy), u3 (ref), u19 (copy), u1 (copy)
    local v72 = u17[p71];

    if not v72 then
        return;
    end;

    local UserId = p71.UserId;
    u3:Removes(`{UserId}_Team`, `{UserId}_WeaponLoadout`, `{UserId}_Cash`, `{UserId}_DefuseKit`, `{UserId}_Kills`, `{UserId}_Deaths`, `{UserId}_Assists`, `{UserId}_AllDMG`, `{UserId}_Headshots`, `{UserId}_Click`, `{UserId}_State`, `{UserId}_Healths`, (`{p71}_LocalTeam`));

    for i = #u19, 1, -1 do
        if u19[i].UI == v72.ScoreUI then
            table.remove(u19, i);
            break;
        end;

        local _ = i;
    end;

    v72.ScoreUI:Destroy();
    u17[p71] = nil;
    u1.RefreshAlive();
end;

function u1.HandleWin(p73: string) -- Line: 666
    -- upvalues: GameStats (copy), u16 (ref), u21 (copy)
    if GameStats:GetAttribute(p73 .. "Wins") == 0 then
        return;
    end;

    u16 = u16 + 1;
    local v74 = u21["Round" .. u16][p73];

    if v74 then
        v74.Visible = true;
    end;
end;

function u1.StreakTeam(p75: string, p76: string, p77) -- Line: 680
    -- upvalues: GameStats (copy), u20 (copy)
    local Attribute = GameStats:GetAttribute(p75 .. "LoseStreak");

    if GameStats:GetAttribute(p75 .. "LoseStreak") == 0 then
        return;
    end;

    local v78 = u20[p75 .. Attribute];

    if v78 then
        v78.BackgroundTransparency = 0;
        v78.BackgroundColor3 = p77;
    end;
end;

function u1.Init(p79) -- Line: 697
    -- upvalues: u2 (ref), u3 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u15 (ref)
    u2 = p79:GetModule("Gui");
    u3 = p79:GetModule("Maid").new();
    u8 = p79:GetModule("ItemManager");
    u9 = p79:GetModule("ClientModule");
    u10 = p79:GetModule("BindsController");
    u11 = p79:GetModule("Network");
    u12 = p79:GetModule("InventoryData");
    u13 = p79:GetModule("Enums");
    u14 = p79:GetModule("ProfileData");
    u15 = p79:GetModule("Entities");
end;

function u1.Start(p80) -- Line: 710
    -- upvalues: u2 (ref), u4 (ref), u1 (copy), u5 (ref), u6 (ref), u7 (ref), Players (copy), u11 (ref), u22 (ref), u12 (ref), LocalPlayer (copy), HttpService (copy), GameStats (copy), u16 (ref), u21 (copy), u20 (copy)
    MenuNotification = u2.GetComponent("MenuNotification");
    u4 = u1.new();
    local v81, v82 = u1.centerui();
    u5 = v81;
    u6 = v82;
    u7 = u1.newProfile();
    u5.Parent = u4.MainFrame;

    for _, v in Players:GetPlayers() do
        u1.User(v);
    end;

    Players.PlayerAdded:Connect(function(p83) -- Line: 721
        -- upvalues: u1 (ref)
        u1.User(p83);
    end);
    Players.PlayerRemoving:Connect(function(p84) -- Line: 725
        -- upvalues: u1 (ref)
        u1.UserLeft(p84);
    end);
    local ProfileBadges = u11.Gui.ProfileBadges;

    if ProfileBadges then
        ProfileBadges.On(function(p85, p86) -- Line: 731
            -- upvalues: u22 (ref), u7 (ref), u1 (ref)
            if u22 and (u22.UserId == p85 and u7.Visible) then
                u1.UpdateProfilePins(u22, p86);
            end;
        end);
    else
        warn("[Score] Regenerate Blink with RequestProfileBadges and ProfileBadges to show other players\' pins");
    end;

    u12.Updated:Connect(function() -- Line: 741
        -- upvalues: u7 (ref), LocalPlayer (ref), HttpService (ref), u1 (ref)
        local v87 = u7.Visible and LocalPlayer:GetAttribute("WeaponLoadout");

        if v87 then
            local success, result = pcall(HttpService.JSONDecode, HttpService, v87);

            if success and result then
                if result.CT then
                    local _ = result.CT["19"];
                end;

                if u7.TitleProfile.Text == LocalPlayer.Name then
                    u1.UpdateProfilePins(LocalPlayer);
                end;
            end;
        end;
    end);
    GameStats:GetAttributeChangedSignal("CTWins"):Connect(function() -- Line: 759
        -- upvalues: u1 (ref)
        u1.HandleWin("CT");
    end);
    GameStats:GetAttributeChangedSignal("TWins"):Connect(function() -- Line: 763
        -- upvalues: u1 (ref)
        u1.HandleWin("T");
    end);
    GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 767
        -- upvalues: GameStats (ref), u16 (ref), u21 (ref), u20 (ref)
        if GameStats:GetAttribute("State") == "Restart" then
            u16 = 0;

            for _, v in u21 do
                v.CT.Visible = false;
                v.T.Visible = false;
            end;

            if u20 then
                for _, v in u20 do
                    v.BackgroundTransparency = 0.5;
                    v.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                end;
            end;
        end;
    end);

    for i = 1, 23 do
        local v88 = u1.newRound();
        v88.Name = `Round{i}`;
        v88.LayoutOrder = i;
        v88.Parent = u6;

        if i % 5 == 0 then
            v88.Number.Visible = true;
            v88.Number.Text = tostring(i);
        end;

        if i <= 8 then
            v88.Line.BackgroundTransparency = 0.9;
        end;

        u21[v88.Name] = v88;
        local _ = i;
    end;

    GameStats:GetAttributeChangedSignal("CTLoseStreak"):Connect(function() -- Line: 810
        -- upvalues: u1 (ref)
        u1.StreakTeam("CT", 0, Color3.fromRGB(172, 195, 220));
    end);
    GameStats:GetAttributeChangedSignal("TLoseStreak"):Connect(function() -- Line: 814
        -- upvalues: u1 (ref)
        u1.StreakTeam("T", 0, Color3.fromRGB(255, 203, 107));
    end);
end;

function u1.new() -- Line: 821
    -- upvalues: u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Scoreboard";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = 2;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.75, 0.675);
    Frame.ZIndex = 3;
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Top";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.500227, 0);
    Frame2.Size = UDim2.fromScale(0.949546, 0.08);
    Frame2.ZIndex = 2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.055, 0.45);
    TextLabel.Size = UDim2.fromScale(0.45, 0.4);
    TextLabel.Text = "Competitive | Mirage";
    TextLabel.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.8;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 3;
    TextLabel.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.400000006);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://137704842858058";
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.Position = UDim2.fromScale(0.01, 0.6);
    ImageLabel.Size = UDim2.fromScale(0.045, 0.45);
    ImageLabel.ZIndex = 3;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = ImageLabel;
    ImageLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Time";
    TextLabel2.AnchorPoint = Vector2.new(1, 0);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel2.Position = UDim2.fromScale(1, 0.45);
    TextLabel2.Size = UDim2.fromScale(0.45, 0.4);
    TextLabel2.Text = "0:00:00";
    TextLabel2.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.8;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.ZIndex = 3;
    TextLabel2.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Line";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.8;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 1);
    Frame3.Size = UDim2.new(1, 0, 0, 1);
    Frame3.ZIndex = 2;
    Frame3.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "MainFrame";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 0.125);
    Frame4.Size = UDim2.fromScale(0.95, 0.85);
    Frame4.ZIndex = 2;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Main";
    Frame5.AnchorPoint = Vector2.new(1, 0);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(1, 0);
    Frame5.Size = UDim2.fromScale(0.9, 1);
    Frame5.ZIndex = 3;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Head";
    Frame6.AutoLocalize = false;
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0, 0.01);
    Frame6.Size = UDim2.fromScale(1, 0.04);
    Frame6.ZIndex = 4;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Ping";
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://18302896182";
    ImageLabel2.ImageTransparency = 0.1;
    ImageLabel2.Position = UDim2.fromScale(0.05, 0.5);
    ImageLabel2.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel2.Visible = false;
    ImageLabel2.ZIndex = 5;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.Parent = ImageLabel2;
    ImageLabel2.Parent = Frame6;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(1, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.075, 0.8);
    TextLabel3.Text = "DMG";
    TextLabel3.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.3;
    TextLabel3.ZIndex = 3;
    TextLabel3.Parent = Frame6;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.925, 0.5);
    TextLabel4.Size = UDim2.fromScale(0.075, 0.8);
    TextLabel4.Text = "HS%";
    TextLabel4.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.3;
    TextLabel4.ZIndex = 3;
    TextLabel4.Parent = Frame6;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.85, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.075, 0.8);
    TextLabel5.Text = "Assists";
    TextLabel5.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel5.TextScaled = true;
    TextLabel5.TextTransparency = 0.3;
    TextLabel5.ZIndex = 3;
    TextLabel5.Parent = Frame6;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Title";
    TextLabel6.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.775, 0.5);
    TextLabel6.Size = UDim2.fromScale(0.075, 0.8);
    TextLabel6.Text = "Deaths";
    TextLabel6.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel6.TextScaled = true;
    TextLabel6.TextTransparency = 0.3;
    TextLabel6.ZIndex = 3;
    TextLabel6.Parent = Frame6;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Title";
    TextLabel7.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.7, 0.5);
    TextLabel7.Size = UDim2.fromScale(0.075, 0.8);
    TextLabel7.Text = "Kills";
    TextLabel7.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 0.3;
    TextLabel7.ZIndex = 3;
    TextLabel7.Parent = Frame6;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Title";
    TextLabel8.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.625, 0.5);
    TextLabel8.Size = UDim2.fromScale(0.075, 0.8);
    TextLabel8.Text = "Money";
    TextLabel8.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel8.TextScaled = true;
    TextLabel8.TextTransparency = 0.3;
    TextLabel8.ZIndex = 3;
    TextLabel8.Parent = Frame6;
    Frame6.Parent = Frame5;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "CT";
    Frame7.AutoLocalize = false;
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(4.88876e-8, 0.0500001);
    Frame7.Size = UDim2.fromScale(1, 0.278116);
    Frame7.ZIndex = 4;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Spectator";
    Frame8.AutoLocalize = false;
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(4.88876e-8, 0.0500001);
    Frame8.Size = UDim2.fromScale(1, 0.278116);
    Frame8.ZIndex = 4;
    Frame8.Visible = false;
    Frame8.Parent = Frame5;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.new();
    UIGridLayout.CellSize = UDim2.fromScale(1, 0.143);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = Frame7;
    Frame7.Parent = Frame5;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "T";
    Frame9.AutoLocalize = false;
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(4.88876e-8, 0.6);
    Frame9.Size = UDim2.fromScale(1, 0.278116);
    Frame9.ZIndex = 4;
    local UIGridLayout2 = Instance.new("UIGridLayout");
    UIGridLayout2.Name = "UIGridLayout";
    UIGridLayout2.CellPadding = UDim2.new();
    UIGridLayout2.CellSize = UDim2.fromScale(1, 0.143);
    UIGridLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout2.Parent = Frame9;
    Frame9.Parent = Frame5;
    Frame5.Parent = Frame4;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "LeftFrame";
    Frame10.AutoLocalize = false;
    Frame10.BackgroundTransparency = 1;
    Frame10.Position = UDim2.fromScale(-0.01, 0);
    Frame10.Size = UDim2.fromScale(0.11, 1);
    Frame10.ZIndex = 3;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "CT";
    Frame11.AutoLocalize = false;
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(0, 0.05);
    Frame11.Size = UDim2.fromScale(1, 0.3);
    Frame11.ZIndex = 4;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "ImageLabel";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://134307766291506";
    ImageLabel3.ImageTransparency = 0.6;
    ImageLabel3.Position = UDim2.fromScale(0.5, 0);
    ImageLabel3.Size = UDim2.fromScale(0.8, 0.8);
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Score";
    Frame12.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame12.AutoLocalize = false;
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(0.5, 0.5);
    Frame12.Size = UDim2.fromScale(1, 1);
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "Label";
    TextLabel9.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel9.AutoLocalize = false;
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.LayoutOrder = 2;
    TextLabel9.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel9.Size = UDim2.fromScale(1, 1);
    TextLabel9.Text = "0";
    TextLabel9.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel9.TextScaled = true;
    TextLabel9.ZIndex = 10;
    TextLabel9.Parent = Frame12;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "Shadow";
    TextLabel10.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel10.AutoLocalize = false;
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.new(0.5, 2, 0.5, 2);
    TextLabel10.Size = UDim2.fromScale(1, 1);
    TextLabel10.Text = "0";
    TextLabel10.TextColor3 = Color3.new();
    TextLabel10.TextScaled = true;
    TextLabel10.TextTransparency = 0.8;
    TextLabel10.ZIndex = 9;
    TextLabel10.Parent = Frame12;
    Frame12.Parent = ImageLabel3;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint3.Parent = ImageLabel3;
    ImageLabel3.Parent = Frame11;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Title";
    Frame13.AnchorPoint = Vector2.new(0.5, 0);
    Frame13.AutoLocalize = false;
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(0.5, 0.544617);
    Frame13.Size = UDim2.fromScale(1, 0.25);
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "Label";
    TextLabel11.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel11.AutoLocalize = false;
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel11.LayoutOrder = 2;
    TextLabel11.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel11.Size = UDim2.fromScale(0.8, 1);
    TextLabel11.Text = "COUNTER-TERRORISTS";
    TextLabel11.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel11.TextScaled = true;
    TextLabel11.ZIndex = 10;
    TextLabel11.Parent = Frame13;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "Shadow";
    TextLabel12.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel12.AutoLocalize = false;
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.new(0.5, 1, 0.5, 1);
    TextLabel12.Size = UDim2.fromScale(0.8, 1);
    TextLabel12.Text = "COUNTER-TERRORISTS";
    TextLabel12.TextColor3 = Color3.new();
    TextLabel12.TextScaled = true;
    TextLabel12.TextTransparency = 0.25;
    TextLabel12.ZIndex = 9;
    TextLabel12.Parent = Frame13;
    Frame13.Parent = Frame11;
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "Alive";
    TextLabel13.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel13.AutoLocalize = false;
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel13.LayoutOrder = 2;
    TextLabel13.Position = UDim2.fromScale(0.5, 0.869508);
    TextLabel13.Size = UDim2.fromScale(0.5, 0.124781);
    TextLabel13.Text = "Alive: 0/0";
    TextLabel13.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel13.TextScaled = true;
    TextLabel13.TextTransparency = 0.5;
    TextLabel13.ZIndex = 10;
    TextLabel13.Parent = Frame11;
    Frame11.Parent = Frame10;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "T";
    Frame14.AutoLocalize = false;
    Frame14.BackgroundTransparency = 1;
    Frame14.Position = UDim2.fromScale(0, 0.6);
    Frame14.Size = UDim2.fromScale(1, 0.3);
    Frame14.ZIndex = 4;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "ImageLabel";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel4.AutoLocalize = false;
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://118442564192259";
    ImageLabel4.ImageTransparency = 0.6;
    ImageLabel4.Position = UDim2.fromScale(0.5, 0);
    ImageLabel4.Size = UDim2.fromScale(0.8, 0.8);
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Score";
    Frame15.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame15.AutoLocalize = false;
    Frame15.BackgroundTransparency = 1;
    Frame15.Position = UDim2.fromScale(0.5, 0.5);
    Frame15.Size = UDim2.fromScale(1, 1);
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "Label";
    TextLabel14.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel14.AutoLocalize = false;
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel14.LayoutOrder = 2;
    TextLabel14.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel14.Size = UDim2.fromScale(1, 1);
    TextLabel14.Text = "0";
    TextLabel14.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel14.TextScaled = true;
    TextLabel14.ZIndex = 10;
    TextLabel14.Parent = Frame15;
    local TextLabel15 = Instance.new("TextLabel");
    TextLabel15.Name = "Shadow";
    TextLabel15.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel15.AutoLocalize = false;
    TextLabel15.BackgroundTransparency = 1;
    TextLabel15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel15.Position = UDim2.new(0.5, 2, 0.5, 2);
    TextLabel15.Size = UDim2.fromScale(1, 1);
    TextLabel15.Text = "0";
    TextLabel15.TextColor3 = Color3.new();
    TextLabel15.TextScaled = true;
    TextLabel15.TextTransparency = 0.8;
    TextLabel15.ZIndex = 9;
    TextLabel15.Parent = Frame15;
    Frame15.Parent = ImageLabel4;
    local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint4.Parent = ImageLabel4;
    ImageLabel4.Parent = Frame14;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Title";
    Frame16.AnchorPoint = Vector2.new(0.5, 0);
    Frame16.AutoLocalize = false;
    Frame16.BackgroundTransparency = 1;
    Frame16.Position = UDim2.fromScale(0.5, 0.544617);
    Frame16.Size = UDim2.fromScale(1, 0.25);
    local TextLabel16 = Instance.new("TextLabel");
    TextLabel16.Name = "Label";
    TextLabel16.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel16.AutoLocalize = false;
    TextLabel16.BackgroundTransparency = 1;
    TextLabel16.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel16.LayoutOrder = 2;
    TextLabel16.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel16.RichText = true;
    TextLabel16.Size = UDim2.fromScale(0.8, 1);
    TextLabel16.Text = "TERRORISTS";
    TextLabel16.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel16.TextScaled = true;
    TextLabel16.ZIndex = 10;
    TextLabel16.Parent = Frame16;
    local TextLabel17 = Instance.new("TextLabel");
    TextLabel17.Name = "Shadow";
    TextLabel17.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel17.AutoLocalize = false;
    TextLabel17.BackgroundTransparency = 1;
    TextLabel17.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel17.Position = UDim2.new(0.5, 1, 0.5, 1);
    TextLabel17.Size = UDim2.fromScale(0.8, 1);
    TextLabel17.Text = "TERRORISTS";
    TextLabel17.TextColor3 = Color3.new();
    TextLabel17.TextScaled = true;
    TextLabel17.TextTransparency = 0.25;
    TextLabel17.ZIndex = 9;
    TextLabel17.Parent = Frame16;
    Frame16.Parent = Frame14;
    local TextLabel18 = Instance.new("TextLabel");
    TextLabel18.Name = "Alive";
    TextLabel18.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel18.AutoLocalize = false;
    TextLabel18.BackgroundTransparency = 1;
    TextLabel18.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel18.LayoutOrder = 2;
    TextLabel18.Position = UDim2.fromScale(0.5, 0.869508);
    TextLabel18.Size = UDim2.fromScale(0.5, 0.124781);
    TextLabel18.Text = "Alive: 0/0";
    TextLabel18.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel18.TextScaled = true;
    TextLabel18.TextTransparency = 0.5;
    TextLabel18.ZIndex = 10;
    TextLabel18.Parent = Frame14;
    Frame14.Parent = Frame10;
    Frame10.Parent = Frame4;
    Frame4.Parent = Frame;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Blur";
    ImageLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.ClipsDescendants = true;
    ImageLabel5.Image = "rbxassetid://108060254555731";
    ImageLabel5.ImageColor3 = Color3.fromRGB(159, 159, 159);
    ImageLabel5.ImageTransparency = 0.8;
    ImageLabel5.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel5.Size = UDim2.fromScale(1, 1);
    ImageLabel5.ZIndex = 0;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Blur";
    ImageButton:SetAttribute("NoSelect", true);
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://17293653421";
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ZIndex = 0;
    ImageButton.Parent = ImageLabel5;
    ImageLabel5.Parent = Frame;
    local TextLabel19 = Instance.new("TextLabel");
    TextLabel19.Name = "Tip";
    TextLabel19.AnchorPoint = Vector2.new(1, 1);
    TextLabel19.AutoLocalize = false;
    TextLabel19.BackgroundTransparency = 1;
    TextLabel19.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel19.Position = UDim2.fromScale(0.95, 0.975);
    TextLabel19.Size = UDim2.fromScale(0.1, 0.0298726);
    TextLabel19.Text = "[MOUSE2] Enable Cursor";
    TextLabel19.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel19.TextScaled = true;
    TextLabel19.TextTransparency = 0.5;
    TextLabel19.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel19.ZIndex = 3;
    TextLabel19.Parent = Frame;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "DOTS";
    ImageLabel6.BackgroundColor3 = Color3.new();
    ImageLabel6.BackgroundTransparency = 0.2;
    ImageLabel6.BorderColor3 = Color3.new();
    ImageLabel6.BorderSizePixel = 0;
    ImageLabel6.Image = "rbxassetid://91991932054752";
    ImageLabel6.ImageColor3 = Color3.new();
    ImageLabel6.ImageTransparency = 0.5;
    ImageLabel6.LayoutOrder = -1;
    ImageLabel6.ScaleType = Enum.ScaleType.Tile;
    ImageLabel6.Size = UDim2.fromScale(1, 1);
    ImageLabel6.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel6.ZIndex = -1;
    ImageLabel6.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(26, 26, 26);
    UIStroke.Transparency = 0.29;
    UIStroke.Parent = Frame;
    local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint5.AspectRatio = 1.5;
    UIAspectRatioConstraint5.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

function u1.centerui() -- Line: 1488
    -- upvalues: u20 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "CenterFrame";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.39);
    Frame.Size = UDim2.fromScale(1, 0.2);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Main";
    Frame2.AnchorPoint = Vector2.new(1, 0.5);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(1, 0.5);
    Frame2.Size = UDim2.fromScale(0.85, 1);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "LossBonus";
    Frame3.AnchorPoint = Vector2.new(1, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(1, 0.5);
    Frame3.Size = UDim2.fromScale(0.102257, 1);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Rounds";
    Frame4.AnchorPoint = Vector2.new(0, 0.5);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.08, 0.5);
    Frame4.Size = UDim2.fromScale(0.65, 1);
    Frame4.Parent = Frame2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "abc";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.Padding = UDim.new(0.005, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "LineTemplate";
    Frame5.AnchorPoint = Vector2.new(0, 0.5);
    Frame5.BackgroundTransparency = 1;
    Frame5.LayoutOrder = 9;
    Frame5.Size = UDim2.fromScale(0.04, 0.8);
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Line";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BackgroundTransparency = 0.9;
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(0.09, 0.8);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "dgb";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.05, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.95, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame6;
    Frame6.Parent = Frame5;
    Frame5.Parent = Frame4;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.LayoutOrder = 2;
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(1, 0.2);
    TextLabel.Text = "Loss Bonus";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.25;
    TextLabel.ZIndex = 10;
    TextLabel.Parent = Frame3;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "CT";
    Frame7.AnchorPoint = Vector2.new(0.5, 0);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.5, 0.1);
    Frame7.Size = UDim2.fromScale(1, 0.25);
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "CT1";
    Frame8.AnchorPoint = Vector2.new(0, 1);
    Frame8.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame8.BackgroundTransparency = 0.5;
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.LayoutOrder = 1;
    Frame8.Position = UDim2.fromScale(0, 1);
    Frame8.Size = UDim2.fromScale(0.2, 0.1);
    Frame8.Parent = Frame7;
    u20[Frame8.Name] = Frame8;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.Padding = UDim.new(0.045, 0);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout2.Parent = Frame7;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "CT2";
    Frame9.AnchorPoint = Vector2.new(0, 1);
    Frame9.BackgroundColor3 = Color3.new();
    Frame9.BackgroundTransparency = 0.5;
    Frame9.BorderColor3 = Color3.new();
    Frame9.BorderSizePixel = 0;
    Frame9.LayoutOrder = 2;
    Frame9.Position = UDim2.fromScale(0, 1);
    Frame9.Size = UDim2.fromScale(0.2, 0.1);
    Frame9.Parent = Frame7;
    u20[Frame9.Name] = Frame9;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "CT3";
    Frame10.AnchorPoint = Vector2.new(0, 1);
    Frame10.BackgroundColor3 = Color3.new();
    Frame10.BackgroundTransparency = 0.5;
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.LayoutOrder = 3;
    Frame10.Position = UDim2.fromScale(0, 1);
    Frame10.Size = UDim2.fromScale(0.2, 0.1);
    Frame10.Parent = Frame7;
    u20[Frame10.Name] = Frame10;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "CT4";
    Frame11.AnchorPoint = Vector2.new(0, 1);
    Frame11.BackgroundColor3 = Color3.new();
    Frame11.BackgroundTransparency = 0.5;
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.LayoutOrder = 4;
    Frame11.Position = UDim2.fromScale(0, 1);
    Frame11.Size = UDim2.fromScale(0.2, 0.1);
    Frame11.Parent = Frame7;
    u20[Frame11.Name] = Frame11;
    Frame7.Parent = Frame3;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "T";
    Frame12.AnchorPoint = Vector2.new(0.5, 1);
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(0.5, 0.9);
    Frame12.Size = UDim2.fromScale(1, 0.25);
    local UIListLayout3 = Instance.new("UIListLayout");
    UIListLayout3.Name = "UIListLayout";
    UIListLayout3.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout3.Padding = UDim.new(0.045, 0);
    UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout3.Parent = Frame12;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "T1";
    Frame13.AnchorPoint = Vector2.new(0, 1);
    Frame13.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame13.BackgroundTransparency = 0.5;
    Frame13.BorderColor3 = Color3.new();
    Frame13.BorderSizePixel = 0;
    Frame13.LayoutOrder = 1;
    Frame13.Position = UDim2.fromScale(0, 1);
    Frame13.Size = UDim2.fromScale(0.2, 0.1);
    Frame13.Parent = Frame12;
    u20[Frame13.Name] = Frame13;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "T2";
    Frame14.AnchorPoint = Vector2.new(0, 1);
    Frame14.BackgroundColor3 = Color3.new();
    Frame14.BackgroundTransparency = 0.5;
    Frame14.BorderColor3 = Color3.new();
    Frame14.BorderSizePixel = 0;
    Frame14.LayoutOrder = 2;
    Frame14.Position = UDim2.fromScale(0, 1);
    Frame14.Size = UDim2.fromScale(0.2, 0.1);
    Frame14.Parent = Frame12;
    u20[Frame14.Name] = Frame14;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "T3";
    Frame15.AnchorPoint = Vector2.new(0, 1);
    Frame15.BackgroundColor3 = Color3.new();
    Frame15.BackgroundTransparency = 0.5;
    Frame15.BorderColor3 = Color3.new();
    Frame15.BorderSizePixel = 0;
    Frame15.LayoutOrder = 3;
    Frame15.Position = UDim2.fromScale(0, 1);
    Frame15.Size = UDim2.fromScale(0.2, 0.1);
    Frame15.Parent = Frame12;
    u20[Frame15.Name] = Frame15;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "T4";
    Frame16.AnchorPoint = Vector2.new(0, 1);
    Frame16.BackgroundColor3 = Color3.new();
    Frame16.BackgroundTransparency = 0.5;
    Frame16.BorderColor3 = Color3.new();
    Frame16.BorderSizePixel = 0;
    Frame16.LayoutOrder = 4;
    Frame16.Position = UDim2.fromScale(0, 1);
    Frame16.Size = UDim2.fromScale(0.2, 0.1);
    Frame16.Parent = Frame12;
    u20[Frame16.Name] = Frame16;
    Frame12.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "LeftPanel";
    Frame17.AnchorPoint = Vector2.new(0, 0.5);
    Frame17.BackgroundTransparency = 1;
    Frame17.Position = UDim2.fromScale(0, 0.5);
    Frame17.Size = UDim2.fromScale(0.1, 1);
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "First";
    Frame18.AnchorPoint = Vector2.new(0, 0.5);
    Frame18.BackgroundTransparency = 1;
    Frame18.Position = UDim2.fromScale(0.2, 0.5);
    Frame18.Size = UDim2.fromScale(0.2, 0.75);
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.LayoutOrder = 2;
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.RichText = true;
    TextLabel2.Size = UDim2.fromScale(1, 0.25);
    TextLabel2.Text = "1st";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.25;
    TextLabel2.ZIndex = 10;
    TextLabel2.Parent = Frame18;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "CT";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.LayoutOrder = 2;
    TextLabel3.Position = UDim2.fromScale(0.5, 0);
    TextLabel3.RichText = true;
    TextLabel3.Size = UDim2.fromScale(1, 0.25);
    TextLabel3.Text = "0";
    TextLabel3.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 10;
    TextLabel3.Parent = Frame18;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "T";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.LayoutOrder = 2;
    TextLabel4.Position = UDim2.fromScale(0.5, 1);
    TextLabel4.RichText = true;
    TextLabel4.Size = UDim2.fromScale(1, 0.25);
    TextLabel4.Text = "0";
    TextLabel4.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 10;
    TextLabel4.Parent = Frame18;
    Frame18.Parent = Frame17;
    local UIListLayout4 = Instance.new("UIListLayout");
    UIListLayout4.Name = "UIListLayout";
    UIListLayout4.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout4.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout4.Padding = UDim.new(0.2, 0);
    UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout4.Parent = Frame17;
    Frame17.Parent = Frame;

    return Frame, Frame4;
end;

function u1.newUser() -- Line: 1816
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Player";
    CanvasGroup.GroupTransparency = 0;
    CanvasGroup.GroupColor3 = Color3.fromRGB(255, 255, 255);
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(152, 152, 152);
    CanvasGroup.BackgroundTransparency = 0.7;
    CanvasGroup.BorderColor3 = Color3.new();
    CanvasGroup.BorderSizePixel = 0;
    CanvasGroup.Size = UDim2.fromOffset(100, 100);
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "CL";
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ZIndex = 9999;
    ImageButton.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Ping";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0, 0.5);
    TextLabel.Size = UDim2.fromScale(0.055, 0.95);
    TextLabel.Text = "";
    TextLabel.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.Visible = true;
    TextLabel.ZIndex = 5;
    TextLabel.Parent = CanvasGroup;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "PlayerName";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.14, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.2, 0.95);
    TextLabel2.Text = "WhyNotMyUsername";
    TextLabel2.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 5;
    TextLabel2.Parent = CanvasGroup;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Money";
    TextLabel3.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.625, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.075, 0.95);
    TextLabel3.Text = "0";
    TextLabel3.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 5;
    TextLabel3.Parent = CanvasGroup;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Kills";
    TextLabel4.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.7, 0.5);
    TextLabel4.Size = UDim2.fromScale(0.075, 0.95);
    TextLabel4.Text = "0";
    TextLabel4.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 5;
    TextLabel4.Parent = CanvasGroup;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Headshots";
    TextLabel5.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.925, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.075, 0.95);
    TextLabel5.Text = "0";
    TextLabel5.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel5.TextScaled = true;
    TextLabel5.ZIndex = 5;
    TextLabel5.Parent = CanvasGroup;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Deaths";
    TextLabel6.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.775, 0.5);
    TextLabel6.Size = UDim2.fromScale(0.075, 0.95);
    TextLabel6.Text = "0";
    TextLabel6.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel6.TextScaled = true;
    TextLabel6.ZIndex = 5;
    TextLabel6.Parent = CanvasGroup;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Assists";
    TextLabel7.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.85, 0.5);
    TextLabel7.Size = UDim2.fromScale(0.075, 0.95);
    TextLabel7.Text = "0";
    TextLabel7.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel7.TextScaled = true;
    TextLabel7.ZIndex = 5;
    TextLabel7.Parent = CanvasGroup;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "AllDMG";
    TextLabel8.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(1, 0.5);
    TextLabel8.Size = UDim2.fromScale(0.075, 0.95);
    TextLabel8.Text = "0";
    TextLabel8.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel8.TextScaled = true;
    TextLabel8.ZIndex = 5;
    TextLabel8.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Pin";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.Position = UDim2.fromScale(0.08, 0);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = ImageLabel;
    ImageLabel.Parent = CanvasGroup;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Icon";
    ImageButton2:SetAttribute("NoSelect", true);
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.AutoLocalize = false;
    ImageButton2.BackgroundColor3 = Color3.new();
    ImageButton2.BorderColor3 = Color3.new();
    ImageButton2.BorderSizePixel = 0;
    ImageButton2.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    ImageButton2.Position = UDim2.fromScale(0.1, 0.5);
    ImageButton2.Size = UDim2.fromScale(0.9, 0.9);
    ImageButton2.ZIndex = 2;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Parent = ImageButton2;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.Parent = ImageButton2;
    ImageButton2.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "BG";
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "TItle";
    TextLabel9.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel9.AutoLocalize = false;
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.7, 0.5);
    TextLabel9.Size = UDim2.fromScale(0.075, 1);
    TextLabel9.Text = "";
    TextLabel9.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel9.TextScaled = true;
    TextLabel9.ZIndex = 5;
    TextLabel9.Parent = Frame;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "TItle";
    TextLabel10.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel10.AutoLocalize = false;
    TextLabel10.BackgroundColor3 = Color3.new(1, 1, 1);
    TextLabel10.BackgroundTransparency = 0.9;
    TextLabel10.BorderColor3 = Color3.fromRGB(27, 42, 53);
    TextLabel10.BorderSizePixel = 0;
    TextLabel10.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0.775, 0.5);
    TextLabel10.Size = UDim2.fromScale(0.075, 1);
    TextLabel10.Text = "";
    TextLabel10.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel10.TextScaled = true;
    TextLabel10.ZIndex = 5;
    TextLabel10.Parent = Frame;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "TItle";
    TextLabel11.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel11.AutoLocalize = false;
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel11.Position = UDim2.fromScale(0.85, 0.5);
    TextLabel11.Size = UDim2.fromScale(0.075, 1);
    TextLabel11.Text = "";
    TextLabel11.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel11.TextScaled = true;
    TextLabel11.ZIndex = 5;
    TextLabel11.Parent = Frame;
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "TItle";
    TextLabel12.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel12.AutoLocalize = false;
    TextLabel12.BackgroundColor3 = Color3.new(1, 1, 1);
    TextLabel12.BackgroundTransparency = 0.9;
    TextLabel12.BorderSizePixel = 0;
    TextLabel12.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(0.625, 0.5);
    TextLabel12.Size = UDim2.fromScale(0.075, 1);
    TextLabel12.Text = "";
    TextLabel12.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel12.TextScaled = true;
    TextLabel12.ZIndex = 5;
    TextLabel12.Parent = Frame;
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "TItle";
    TextLabel13.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel13.AutoLocalize = false;
    TextLabel13.BackgroundColor3 = Color3.new(1, 1, 1);
    TextLabel13.BackgroundTransparency = 0.85;
    TextLabel13.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel13.Position = UDim2.fromScale(1, 0.5);
    TextLabel13.Size = UDim2.fromScale(0.075, 1);
    TextLabel13.Text = "";
    TextLabel13.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel13.TextScaled = true;
    TextLabel13.ZIndex = 5;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 2);
    UICorner.Parent = TextLabel13;
    TextLabel13.Parent = Frame;
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "TItle";
    TextLabel14.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel14.AutoLocalize = false;
    TextLabel14.BackgroundColor3 = Color3.new(1, 1, 1);
    TextLabel14.BackgroundTransparency = 0.9;
    TextLabel14.BorderColor3 = Color3.fromRGB(27, 42, 53);
    TextLabel14.BorderSizePixel = 0;
    TextLabel14.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel14.Position = UDim2.fromScale(0.925, 0.5);
    TextLabel14.Size = UDim2.fromScale(0.075, 1);
    TextLabel14.Text = "";
    TextLabel14.TextColor3 = Color3.fromRGB(255, 248, 248);
    TextLabel14.TextScaled = true;
    TextLabel14.ZIndex = 5;
    TextLabel14.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Rank";
    ImageLabel2.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://100429874437897";
    ImageLabel2.Position = UDim2.fromScale(0.55, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.075, 0.95);
    ImageLabel2.Parent = CanvasGroup;
    ImageLabel2.Visible = false;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "DefuseKit";
    ImageLabel3.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://95244952063725";
    ImageLabel3.ImageColor3 = Color3.fromRGB(172, 195, 220);
    ImageLabel3.Position = UDim2.fromScale(0.005, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Visible = false;
    ImageLabel3.ZIndex = 5;
    ImageLabel3.Parent = CanvasGroup;

    return CanvasGroup;
end;

function u1.newRound() -- Line: 2186
    local Frame = Instance.new("Frame");
    Frame.Name = "Round";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = 1;
    Frame.Size = UDim2.fromScale(0.04, 0.8);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.98;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 0.025);
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "T";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.BackgroundColor3 = Color3.fromRGB(255, 203, 107);
    Frame3.BackgroundTransparency = 0.6;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 0.54);
    Frame3.Size = UDim2.fromScale(1, 0.275);
    Frame3.Visible = false;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://18348431657";
    ImageLabel.ImageColor3 = Color3.fromRGB(255, 203, 107);
    ImageLabel.ImageTransparency = 0.2;
    ImageLabel.Position = UDim2.fromScale(0.52, 0.8);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.7, 0.8);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel.Parent = Frame3;
    Frame3.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "CT";
    Frame4.AnchorPoint = Vector2.new(0.5, 1);
    Frame4.BackgroundColor3 = Color3.fromRGB(172, 195, 220);
    Frame4.BackgroundTransparency = 0.6;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 0.45);
    Frame4.Size = UDim2.fromScale(1, 0.275);
    Frame4.Visible = false;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 270;
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    UIGradient2.Parent = Frame4;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://18348431657";
    ImageLabel2.ImageColor3 = Color3.fromRGB(172, 195, 220);
    ImageLabel2.ImageTransparency = 0.2;
    ImageLabel2.Position = UDim2.fromScale(0.52, 0.2);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.7, 0.8);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel2.Parent = Frame4;
    Frame4.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Number";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 2;
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    TextLabel.Text = "5";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.6;
    TextLabel.Visible = false;
    TextLabel.ZIndex = 10;
    TextLabel.Parent = Frame;

    return Frame;
end;

function u1.newProfile() -- Line: 2301
    -- upvalues: u2 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Profile";
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(39, 39, 39);
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.LayoutOrder = 23632;
    CanvasGroup.Position = UDim2.fromScale(0.387009, 0.3035);
    CanvasGroup.Size = UDim2.fromScale(0.4, 0.2);
    CanvasGroup.Visible = false;
    CanvasGroup.ZIndex = 236236;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectProfile";
    UIAspectRatioConstraint.AspectRatio = 2;
    UIAspectRatioConstraint.Parent = CanvasGroup;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICornerProfile";
    UICorner.BottomLeftRadius = UDim.new(0.015, 0);
    UICorner.BottomRightRadius = UDim.new(0.015, 0);
    UICorner.CornerRadius = UDim.new(0.015, 0);
    UICorner.TopLeftRadius = UDim.new(0.015, 0);
    UICorner.TopRightRadius = UDim.new(0.015, 0);
    UICorner.Parent = CanvasGroup;
    local Frame = Instance.new("Frame");
    Frame.Name = "BarProfile";
    Frame.AnchorPoint = Vector2.new(0, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(27, 27, 27);
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0, 1);
    Frame.Size = UDim2.fromScale(1, 0.4);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayoutProfile";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.025, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPaddingProfile";
    UIPadding.PaddingBottom = UDim.new(0.1, 0);
    UIPadding.PaddingTop = UDim.new(0.1, 0);
    UIPadding.Parent = Frame;
    local Folder = Instance.new("Folder");
    Folder.Name = "Folder";
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "LineProfile";
    Frame2.AnchorPoint = Vector2.new(0, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(160, 160, 163);
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(-1.36239e-7, -0.1);
    Frame2.Size = UDim2.new(1, 0, 0, 1);
    Frame2.ZIndex = 5;
    Frame2.Parent = Folder;
    Folder.Parent = Frame;
    Frame.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabelProfile";
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BorderColor3 = Color3.new();
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    ImageLabel.Position = UDim2.fromScale(0.05, 0.1);
    ImageLabel.Size = UDim2.fromScale(0.2, 0.2);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Pin";
    ImageLabel2.AnchorPoint = Vector2.new(0.200000003, 0.400000006);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.ZIndex = 2;
    ImageLabel2.Parent = ImageLabel;
    ImageLabel.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TitleProfile";
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.3, 0.15);
    TextLabel.Size = UDim2.fromScale(0.6, 0.15);
    TextLabel.Text = "WhyNotMyUsername";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 5;
    TextLabel.Parent = CanvasGroup;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Pins";
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.3, 0.3);
    Frame3.Size = UDim2.fromScale(0.6, 0.2);
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = Frame3;
    Frame3.Parent = CanvasGroup;
    CanvasGroup.Parent = u2.Handler.HUD;

    return CanvasGroup;
end;

function u1.newButton(p89: string, p90: string, u91: any) -- Line: 2422
    -- upvalues: u7 (ref), u3 (ref), TweenService (copy), u18 (copy)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Button";
    ImageButton.Active = false;
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageButton.BackgroundTransparency = 0.8;
    ImageButton.Size = UDim2.fromScale(0.2, 1);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.05, 0);
    UICorner.BottomRightRadius = UDim.new(0.05, 0);
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.TopLeftRadius = UDim.new(0.05, 0);
    UICorner.TopRightRadius = UDim.new(0.05, 0);
    UICorner.Parent = ImageButton;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = `rbxassetid://{p90}`;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.4);
    ImageLabel.Size = UDim2.fromScale(0.6, 0.6);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = ImageButton;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.85);
    TextLabel.Size = UDim2.fromScale(0.9, 0.25);
    TextLabel.Text = p89 or "";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 5;
    TextLabel.Parent = ImageButton;
    ImageButton.Parent = u7.BarProfile;
    u3:Add(p89 .. "_Enter", ImageButton.MouseEnter:Connect(function() -- Line: 2470
        -- upvalues: TweenService (ref), ImageButton (copy)
        TweenService:Create(ImageButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.65
        }):Play();
    end));
    u3:Add(p89 .. "_Leave", ImageButton.MouseLeave:Connect(function() -- Line: 2474
        -- upvalues: TweenService (ref), ImageButton (copy)
        TweenService:Create(ImageButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.8
        }):Play();
    end));
    u3:Add(p89 .. "_Down", ImageButton.MouseButton1Down:Connect(function() -- Line: 2478
        -- upvalues: TweenService (ref), ImageButton (copy)
        TweenService:Create(ImageButton, TweenInfo.new(0.07), {
            BackgroundTransparency = 0.5
        }):Play();
    end));
    u3:Add(p89 .. "_Up", ImageButton.MouseButton1Up:Connect(function() -- Line: 2482
        -- upvalues: TweenService (ref), ImageButton (copy)
        TweenService:Create(ImageButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.65
        }):Play();
    end));
    u3:Add(p89, ImageButton.MouseButton1Click:Connect(function() -- Line: 2486
        -- upvalues: u91 (copy)
        u91();
    end));
    table.insert(u18, ImageButton);

    return ImageButton;
end;

function u1.newReason(p92: string, p93: number, p94: any) -- Line: 2495
    -- upvalues: u1 (copy)
    local v95 = u1.newButton(p92, "", p94);
    v95.Icon:Destroy();
    v95.LayoutOrder = p93;
    v95.Size = UDim2.fromScale(0.17, 1);
    v95.Title.Position = UDim2.fromScale(0.5, 0.5);
    v95.Title.Size = UDim2.fromScale(0.86, 0.4);

    return v95;
end;

return u1;