-- ReplicatedStorage.GameClient.Gui.HUD.Notification
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Notification
-- Decompile time: 17.45 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
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
local TweenInfo_new_ret = TweenInfo.new(0.2);
local _ = Players.LocalPlayer;
local GameStats = ReplicatedStorage.GameStats;
local u16 = {};
local u17 = {};
local u18 = false;
local u19 = "";
local u20 = nil;
local u21 = false;
local u22 = 0;
local u23 = 0;
local u24 = 0;

function u1.NotifySize(p25: table, p26: string, p27: any) -- Line: 55
    -- upvalues: TweenService (copy), u11 (ref)
    local v28 = string.find(p26, "Challenge", 1, true) ~= nil;

    if string.len(p26) < 35 then
        TweenService:Create(u11, TweenInfo.new(0.2), {
            Size = UDim2.fromScale(1, 1)
        }):Play();
        TweenService:Create(u11.Title, TweenInfo.new(0.25), {
            Size = UDim2.fromScale(1, v28 and 0.5 or 0.6)
        }):Play();

        return;
    end;

    TweenService:Create(u11, TweenInfo.new(0.25), {
        Size = UDim2.fromScale(1, 1.2)
    }):Play();

    if string.len(p26) >= 58 then
        TweenService:Create(u11.Title, TweenInfo.new(0.25), {
            Size = UDim2.fromScale(1, 0.8)
        }):Play();

        return;
    end;

    TweenService:Create(u11.Title, TweenInfo.new(0.25), {
        Size = UDim2.fromScale(1, v28 and 0.5 or 0.6)
    }):Play();
end;

function u1.ShowNotify(p29: table, p30: string) -- Line: 72
    -- upvalues: u11 (ref), u21 (ref), u1 (copy), TweenService (copy)
    u11.Title.Text = p30;

    if u21 then
        u11.Title.Text = p30;
        u1:NotifySize(p30, 35);

        return;
    end;

    u21 = true;
    u11.Visible = true;
    u1:NotifySize(p30, 35);
    task.delay(0.2, function() -- Line: 83
        -- upvalues: TweenService (ref), u11 (ref), u1 (ref)
        TweenService:Create(u11.Flash, TweenInfo.new(0.4), {
            BackgroundTransparency = 1
        }):Play();
        u1.Burst(u11);
    end);
end;

function u1.HideNotify(p31) -- Line: 94
    -- upvalues: u21 (ref), TweenService (copy), u11 (ref)
    if not u21 then
        return;
    end;

    u21 = false;
    TweenService:Create(u11, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play();
    TweenService:Create(u11.Title, TweenInfo.new(0.1), {
        TextTransparency = 1
    }):Play();
    task.delay(0.16, function() -- Line: 106
        -- upvalues: u21 (ref), u11 (ref)
        if not u21 then
            u11.Flash.BackgroundTransparency = 0;
            u11.Title.TextTransparency = 0;
            u11.Visible = false;
        end;
    end);
end;

function u1.BurstColor(p32) -- Line: 117
    -- upvalues: u16 (copy)
    for _, v in u16 do
        v.BackgroundColor3 = p32;
    end;
end;

function u1.Burst(p33: userdata) -- Line: 123
    -- upvalues: u16 (copy), u17 (copy), TweenService (copy)
    for _, v in u16 do
        v.BackgroundTransparency = 0;

        if math.random(1, 2) == 1 then
            v.Size = UDim2.fromScale(math.random() * 0.08, math.random() * 0.4);
        else
            v.Size = UDim2.fromScale(math.random() * 0.05, math.random() * 0.1);
            local UICorner = Instance.new("UICorner");
            UICorner.CornerRadius = UDim.new(1, 0);
            UICorner.Parent = v;
            table.insert(u17, UICorner);
        end;

        v.Position = UDim2.fromScale(math.random(), math.random());
        v.Parent = p33;
        TweenService:Create(v, TweenInfo.new(0.5), {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(math.random() * (1 - v.Size.X.Scale), math.random() * (1 - v.Size.Y.Scale)),
            Size = UDim2.fromScale(math.clamp(v.Size.X.Scale * 0.5, 0, 1 - v.Position.X.Scale), (math.clamp(v.Size.Y.Scale * 0.5, 0, 1 - v.Position.Y.Scale)))
        }):Play();
    end;

    task.delay(0.2, function() -- Line: 154
        -- upvalues: u17 (ref)
        for _, v in u17 do
            v:Destroy();
        end;

        table.clear(u17);
    end);
end;

function u1.SetPickUpVisibility(p34: boolean, p35: string) -- Line: 163
    -- upvalues: u9 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if not p34 then
        TweenService:Create(u9, TweenInfo_new_ret, {
            TextTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.505, 50)
        }):Play();

        return;
    end;

    if p35 ~= nil then
        u9.Text = "<font color=\"rgb(169, 169, 169)\">[E] Pick up <font color=\"rgb(255,255,255)\">" .. p35 .. "</font></font>";
    end;

    TweenService:Create(u9, TweenInfo_new_ret, {
        TextTransparency = 0.2,
        Position = UDim2.new(0.5, 0, 0.5, 50)
    }):Play();
end;

function u1.SetNotifyVisibility(p36: boolean, p37: string?, p38: number?) -- Line: 181
    -- upvalues: u20 (ref), u1 (copy), u18 (ref), u19 (ref)
    if p36 then
        if p38 then
            if u20 then
                task.cancel(u20);
                u20 = nil;
            end;

            u1:ShowNotify(p37);
            u20 = task.delay(p38, function() -- Line: 192
                -- upvalues: u20 (ref), u18 (ref), u1 (ref), u19 (ref)
                u20 = nil;

                if u18 then
                    u1:ShowNotify(u19);

                    return;
                end;

                u1:HideNotify();
            end);

            return;
        end;

        u18 = true;
        u19 = p37 or "";

        if not u20 then
            u1:ShowNotify(u19);
        end;
    else
        u18 = false;
        u19 = "";

        if not u20 then
            u1:HideNotify();
        end;
    end;
end;

function u1.SetBombNotifyVisibility() -- Line: 222
    -- upvalues: u13 (ref), TweenService (copy)
    u13.Visible = true;
    TweenService:Create(u13, TweenInfo.new(0.25), {
        Size = UDim2.fromScale(1, 1.2)
    }):Play();
    task.delay(0.2, function() -- Line: 227
        -- upvalues: TweenService (ref), u13 (ref)
        TweenService:Create(u13.Flash, TweenInfo.new(0.4), {
            BackgroundTransparency = 1
        }):Play();
    end);
    task.delay(6, function() -- Line: 232
        -- upvalues: TweenService (ref), u13 (ref)
        TweenService:Create(u13, TweenInfo.new(0.15), {
            Size = UDim2.new(0, 0, 1, 0)
        }):Play();
        TweenService:Create(u13.Title, TweenInfo.new(0.1), {
            TextTransparency = 1
        }):Play();
        task.delay(0.16, function() -- Line: 236
            -- upvalues: u13 (ref)
            u13.Flash.BackgroundTransparency = 0;
            u13.Title.TextTransparency = 0;
            u13.Visible = false;
        end);
    end);
end;

function u1.State() -- Line: 244
    -- upvalues: GameStats (copy), u1 (copy)
    local Attribute = GameStats:GetAttribute("State");

    if Attribute == "Warmup" then
        u1.SetNotifyVisibility(true, "Warmup");
    else
        u1.SetNotifyVisibility(false);
    end;

    if Attribute == "BombPlanted" then
        u1.SetBombNotifyVisibility();
    end;
end;

local function CurrentWins() -- Line: 260
    -- upvalues: GameStats (copy)
    return GameStats:GetAttribute("CTWins") or 0, GameStats:GetAttribute("TWins") or 0;
end;

local function PlayThen(p39: string, u40: number, u41: function) -- Line: 266
    -- upvalues: u24 (ref), u6 (ref)
    local u42 = u24;
    local u43 = u6.Play(p39);
    task.spawn(function() -- Line: 270
        -- upvalues: u43 (copy), u40 (copy), u42 (copy), u24 (ref), u41 (copy)
        local os_clock_ret = os.clock();

        while u43 and (u43.TimeLength == 0 and (u43.Parent and os.clock() - os_clock_ret < 2)) do
            task.wait();
        end;

        local v44 = (not u43 or u43.TimeLength <= 0) and 2.5 or (u43.TimeLength - u43.TimePosition) / math.max(u43.PlaybackSpeed, 0.01);
        task.wait(math.max(v44, 0) + u40);

        if u42 == u24 then
            u41();
        end;
    end);
end;

function u1.Announce(p45: string?) -- Line: 302
    -- upvalues: u24 (ref), u22 (ref), u23 (ref), GameStats (copy), u6 (ref)
    if p45 == "Warmup" or p45 == "Preparation" then
        u24 = u24 + 1;
        local v46 = GameStats:GetAttribute("CTWins") or 0;
        local v47 = GameStats:GetAttribute("TWins") or 0;
        u22 = v46;
        u23 = v47;

        return;
    end;

    if p45 == "BombPlanted" then
        u6.Play("Radio.BombPlanted");

        return;
    end;

    if p45 ~= "BombDefused" then
        if p45 == "BombExploded" then
            u6.Play("Radio.TERWin");

            return;
        end;

        if p45 == "RoundEnded" then
            local u48 = u24;
            task.spawn(function() -- Line: 324
                -- upvalues: GameStats (ref), u22 (ref), u23 (ref), u48 (copy), u24 (ref), u6 (ref)
                local os_clock_ret = os.clock();
                local v49 = GameStats:GetAttribute("CTWins") or 0;
                local v50 = GameStats:GetAttribute("TWins") or 0;

                while v49 <= u22 and (v50 <= u23 and os.clock() - os_clock_ret < 1) do
                    task.wait();
                    v49 = GameStats:GetAttribute("CTWins") or 0;
                    v50 = GameStats:GetAttribute("TWins") or 0;
                end;

                if u48 ~= u24 then
                    return;
                end;

                if u22 < v49 then
                    u6.Play("Radio.CTWin");

                    return;
                end;

                if u23 < v50 then
                    u6.Play("Radio.TERWin");

                    return;
                end;

                u6.Play("Radio.RoundDraw");
            end);
        end;

        return;
    end;

    u24 = u24 + 1;

    local function u51() -- Line: 312
        -- upvalues: u6 (ref)
        u6.Play("Radio.CTWin");
    end;

    local u52 = u24;
    local u53 = u6.Play("Radio.BombDefused");
    local u54 = 0.3;
    task.spawn(function() -- Line: 270
        -- upvalues: u53 (copy), u54 (copy), u52 (copy), u24 (ref), u51 (copy)
        local os_clock_ret = os.clock();

        while u53 and (u53.TimeLength == 0 and (u53.Parent and os.clock() - os_clock_ret < 2)) do
            task.wait();
        end;

        local v55 = (not u53 or u53.TimeLength <= 0) and 2.5 or (u53.TimeLength - u53.TimePosition) / math.max(u53.PlaybackSpeed, 0.01);
        task.wait(math.max(v55, 0) + u54);

        if u52 == u24 then
            u51();
        end;
    end);
end;

function u1.DevMessage(p56: number, p57: string, p58: string, p59: number) -- Line: 348
    -- upvalues: u15 (ref), TweenService (copy)
    local u60 = u15.NewMessage:Clone();
    u60.AutomaticSize = Enum.AutomaticSize.X;
    local X = workspace.CurrentCamera.ViewportSize.X;
    local _ = X / 1920;
    u60.MessageText.Text = p57 .. ": " .. p58;
    u60.DevIcon.Image = `rbxthumb://type=AvatarHeadShot&id={p56}&w=420&h=420`;
    u60.Parent = u15;
    u60.MessageText.Size = UDim2.new(0, u60.MessageText.TextBounds.X + 999, 0.9, 0);
    u60.MessageText.Size = UDim2.new(0, u60.MessageText.TextBounds.X + 4, 0.9, 0);
    u60.Visible = true;
    local v61 = 0;

    for _, child in ipairs(u60:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local v62;

            if child:IsA("TextLabel") then
                v62 = child.TextBounds.X + 4;
            else
                v62 = child.Size.X.Offset;

                if v62 == 0 then
                    v62 = child.Size.Y.Offset;
                end;
            end;

            v61 = v61 + (v62 + 5);
        end;
    end;

    u60.Size = UDim2.new(0, math.min(v61, X * 0.25), 0.16, 0);
    TweenService:Create(u60, TweenInfo.new(0.3), {
        GroupTransparency = 0
    }):Play();
    task.delay(p59, function() -- Line: 394
        -- upvalues: TweenService (ref), u60 (copy)
        TweenService:Create(u60, TweenInfo.new(0.3), {
            GroupTransparency = 1
        }):Play();
        task.delay(0.3, function() -- Line: 397
            -- upvalues: TweenService (ref), u60 (ref)
            TweenService:Create(u60, TweenInfo.new(0.15), {
                Size = UDim2.new(u60.Size.X.Scale, u60.Size.X.Offset, 0, 0)
            }):Play();
            task.wait(0.15);
            u60:Destroy();
        end);
    end);
end;

function u1.Init(p63) -- Line: 411
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u7 (ref), u8 (ref), u6 (ref)
    u2 = p63:GetModule("Gui");
    u3 = p63:GetModule("Maid").new();
    u4 = p63:GetModule("Network");
    u5 = p63:GetModule("Enums");
    u7 = p63:GetModule("ChallengesData");
    u8 = p63:GetModule("ProfileData");
    u6 = p63:GetModule("SoundManager");
end;

function u1.Start(p64) -- Line: 421
    -- upvalues: u9 (ref), u1 (copy), u10 (ref), u12 (ref), u11 (ref), u15 (ref), u13 (ref), u14 (ref), u22 (ref), u23 (ref), GameStats (copy), u4 (ref), ReplicatedStorage (copy), u8 (ref), u7 (ref), u16 (copy)
    u9 = u1.pickup();
    u10 = u1.holder();
    u12 = u1:secondNotify();
    u11 = u1.mainNotify();
    u11.Parent = u10;
    u15 = u1.globalnotify();
    u13 = u12.bombnoti;
    u14 = u12.matchnoti;
    local v65 = GameStats:GetAttribute("CTWins") or 0;
    local v66 = GameStats:GetAttribute("TWins") or 0;
    u22 = v65;
    u23 = v66;
    GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 438
        -- upvalues: u1 (ref), GameStats (ref)
        u1.State();
        u1.Announce(GameStats:GetAttribute("State"));
    end);
    u4.Gui.GlobalMessage.On(function(p67) -- Line: 445
        -- upvalues: u1 (ref), ReplicatedStorage (ref)
        u1.DevMessage(p67.SenderID, p67.Sender, p67.Text, ReplicatedStorage:GetAttribute("GlobalMessageDuration"));
    end);
    local u68 = u8.Get("Challenges");
    u8.Changed("Challenges"):Connect(function(p69) -- Line: 453
        -- upvalues: u68 (ref), u7 (ref), u1 (ref)
        if not p69 then
            return;
        end;

        if u68 then
            for i, v in p69 do
                if type(v) == "table" and u7[i] then
                    local v70 = u68[i];
                    local v71 = i;

                    for i2, v2 in v do
                        if v2.chosen and not v2.completed then
                            local v72;

                            if v70 then
                                v72 = v70[i2];
                            else
                                v72 = v70;
                            end;

                            local v73 = u7[v71][v2.name];

                            if v73 and (v72 and (v72.name == v2.name and (v72.progress < v73.Amount and v2.progress >= v73.Amount))) then
                                u1.SetNotifyVisibility(true, `Challenge Completed: {v2.name}`, 4);
                            end;
                        end;
                    end;
                end;
            end;
        end;

        u68 = p69;
    end);
    task.delay(1, function() -- Line: 490
        -- upvalues: u16 (ref)
        for i = 1, 30 do
            local Frame = Instance.new("Frame");
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = 10;
            Frame.BackgroundTransparency = math.random(0.4, 1);
            table.insert(u16, Frame);
            task.wait(0.05);
            local _ = i;
        end;
    end);
end;

function u1.pickup() -- Line: 506
    -- upvalues: u2 (ref)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "PickUp";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 1;
    TextLabel.Position = UDim2.new(0.5, 0, 0.505, 50);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(0.25, 0.025);
    TextLabel.Text = "<font color=\"rgb(169, 169, 169)\">[E] Swap for <font color=\"rgb(255,255,255)\">WEAPON</font></font>";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextSize = 18;
    TextLabel.TextTransparency = 1;
    TextLabel.TextWrapped = true;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel.Parent = u2.Handler.HUD;

    return TextLabel;
end;

function u1.holder() -- Line: 532
    -- upvalues: u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Notifications";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.8);
    Frame.Size = UDim2.fromScale(0.2, 0.1);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 7.79;
    UIAspectRatioConstraint.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.1, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

function u1.mainNotify() -- Line: 559
    local Frame = Instance.new("Frame");
    Frame.Name = "downNoti";
    Frame.AutoLocalize = false;
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.6;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(0, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 0.6);
    TextLabel.Text = "You cannot drop your Knife";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTruncate = Enum.TextTruncate.SplitWord;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Flash";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.ZIndex = 5;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame2;
    Frame2.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundColor3 = Color3.new();
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "ColorBackground";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundTransparency = 1;
    Frame3.ClipsDescendants = true;
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.fromScale(2, 2);
    Frame3.ZIndex = 0;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Main";
    Frame4.AnchorPoint = Vector2.new(0, 0.5);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0, 0.5);
    Frame4.Size = UDim2.fromScale(1, 0.5);
    Frame4.ZIndex = -1;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Frame";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.fromScale(0.5, 1);
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Left";
    Frame6.AnchorPoint = Vector2.new(1, 0);
    Frame6.AutoLocalize = false;
    Frame6.BackgroundTransparency = 1;
    Frame6.ClipsDescendants = true;
    Frame6.Size = UDim2.fromScale(0.1, 1);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Color";
    Frame7.AutoLocalize = false;
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.ClipsDescendants = true;
    Frame7.Position = UDim2.new(1, -3, 0, 0);
    Frame7.Size = UDim2.fromScale(10, 1);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = Frame7;
    Frame7.Parent = Frame6;
    Frame6.Parent = Frame5;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Right";
    Frame8.AutoLocalize = false;
    Frame8.BackgroundTransparency = 1;
    Frame8.ClipsDescendants = true;
    Frame8.Position = UDim2.fromScale(1, 0);
    Frame8.Size = UDim2.fromScale(0.1, 1);
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Color";
    Frame9.AnchorPoint = Vector2.new(1, 0);
    Frame9.AutoLocalize = false;
    Frame9.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame9.ClipsDescendants = true;
    Frame9.Position = UDim2.fromOffset(3, 0);
    Frame9.Size = UDim2.fromScale(10, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = Frame9;
    Frame9.Parent = Frame8;
    Frame8.Parent = Frame5;
    Frame5.Parent = Frame4;
    Frame4.Parent = Frame3;
    Frame3.Parent = Frame;

    return Frame;
end;

function u1.secondNotify(p74) -- Line: 704
    -- upvalues: u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Notifications2";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.8);
    Frame.Size = UDim2.fromScale(0.2, 0.1);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 7.79;
    UIAspectRatioConstraint.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.1, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "bombnoti";
    Frame2.AutoLocalize = false;
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BackgroundTransparency = 0.6;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.LayoutOrder = 1;
    Frame2.Position = UDim2.fromScale(0, -1.90034e-6);
    Frame2.Size = UDim2.fromScale(0, 1.2);
    Frame2.Visible = false;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(1, 0.8);
    TextLabel.Text = "The bomb has been planted\n40 seconds till detonation";
    TextLabel.TextColor3 = Color3.fromRGB(234, 234, 234);
    TextLabel.TextScaled = true;
    TextLabel.TextTruncate = Enum.TextTruncate.SplitWord;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Flash";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.fromScale(1, 1);
    Frame3.ZIndex = 5;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner.BottomRightRadius = UDim.new(0.1, 0);
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.TopLeftRadius = UDim.new(0.1, 0);
    UICorner.TopRightRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame3;
    Frame3.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.fromRGB(234, 210, 139);
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = Frame2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "ColorBackground";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundTransparency = 1;
    Frame4.ClipsDescendants = true;
    Frame4.Position = UDim2.fromScale(0.5, 0.5);
    Frame4.Size = UDim2.fromScale(2, 2);
    Frame4.ZIndex = 0;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Main";
    Frame5.AnchorPoint = Vector2.new(0, 0.5);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0, 0.5);
    Frame5.Size = UDim2.fromScale(1, 0.5);
    Frame5.ZIndex = -1;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Frame";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.AutoLocalize = false;
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(0.5, 1);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Left";
    Frame7.AnchorPoint = Vector2.new(1, 0);
    Frame7.AutoLocalize = false;
    Frame7.BackgroundTransparency = 1;
    Frame7.ClipsDescendants = true;
    Frame7.Size = UDim2.fromScale(0.1, 1);
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Color";
    Frame8.AutoLocalize = false;
    Frame8.BackgroundColor3 = Color3.fromRGB(234, 76, 76);
    Frame8.ClipsDescendants = true;
    Frame8.Position = UDim2.new(1, -3, 0, 0);
    Frame8.Size = UDim2.fromScale(10, 1);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner2.BottomRightRadius = UDim.new(0.1, 0);
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.TopLeftRadius = UDim.new(0.1, 0);
    UICorner2.TopRightRadius = UDim.new(0.1, 0);
    UICorner2.Parent = Frame8;
    Frame8.Parent = Frame7;
    Frame7.Parent = Frame6;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Right";
    Frame9.AutoLocalize = false;
    Frame9.BackgroundTransparency = 1;
    Frame9.ClipsDescendants = true;
    Frame9.Position = UDim2.fromScale(1, 0);
    Frame9.Size = UDim2.fromScale(0.1, 1);
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Color";
    Frame10.AnchorPoint = Vector2.new(1, 0);
    Frame10.AutoLocalize = false;
    Frame10.BackgroundColor3 = Color3.fromRGB(234, 76, 76);
    Frame10.ClipsDescendants = true;
    Frame10.Position = UDim2.fromOffset(3, 0);
    Frame10.Size = UDim2.fromScale(10, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner3.BottomRightRadius = UDim.new(0.1, 0);
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.TopLeftRadius = UDim.new(0.1, 0);
    UICorner3.TopRightRadius = UDim.new(0.1, 0);
    UICorner3.Parent = Frame10;
    Frame10.Parent = Frame9;
    Frame9.Parent = Frame6;
    Frame6.Parent = Frame5;
    Frame5.Parent = Frame4;
    Frame4.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "template";
    Frame11.AutoLocalize = false;
    Frame11.BackgroundTransparency = 1;
    Frame11.LayoutOrder = 2;
    Frame11.Position = UDim2.fromScale(0, -1.90034e-6);
    Frame11.Size = UDim2.fromScale(1, 1.2);
    Frame11.Parent = Frame;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "matchnoti";
    Frame12.AutoLocalize = false;
    Frame12.BackgroundColor3 = Color3.new();
    Frame12.BackgroundTransparency = 0.6;
    Frame12.BorderColor3 = Color3.new();
    Frame12.BorderSizePixel = 0;
    Frame12.Position = UDim2.fromScale(0, -1.90034e-6);
    Frame12.Size = UDim2.fromScale(0, 1);
    Frame12.Visible = false;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(1, 0.6);
    TextLabel2.Text = "Warmup";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTruncate = Enum.TextTruncate.SplitWord;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Frame12;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Flash";
    Frame13.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame13.AutoLocalize = false;
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(0.5, 0.5);
    Frame13.Size = UDim2.fromScale(1, 1);
    Frame13.ZIndex = 5;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner4.BottomRightRadius = UDim.new(0.1, 0);
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.TopLeftRadius = UDim.new(0.1, 0);
    UICorner4.TopRightRadius = UDim.new(0.1, 0);
    UICorner4.Parent = Frame13;
    Frame13.Parent = Frame12;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "DOTS";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://91991932054752";
    ImageLabel2.ImageColor3 = Color3.fromRGB(234, 210, 139);
    ImageLabel2.ImageTransparency = 0.8;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.ScaleType = Enum.ScaleType.Tile;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel2.ZIndex = -1;
    ImageLabel2.Parent = Frame12;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "ColorBackground";
    Frame14.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame14.AutoLocalize = false;
    Frame14.BackgroundTransparency = 1;
    Frame14.ClipsDescendants = true;
    Frame14.Position = UDim2.fromScale(0.5, 0.5);
    Frame14.Size = UDim2.fromScale(2, 2);
    Frame14.ZIndex = 0;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Main";
    Frame15.AnchorPoint = Vector2.new(0, 0.5);
    Frame15.AutoLocalize = false;
    Frame15.BackgroundTransparency = 1;
    Frame15.Position = UDim2.fromScale(0, 0.5);
    Frame15.Size = UDim2.fromScale(1, 0.5);
    Frame15.ZIndex = -1;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Frame";
    Frame16.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame16.AutoLocalize = false;
    Frame16.BackgroundTransparency = 1;
    Frame16.Position = UDim2.fromScale(0.5, 0.5);
    Frame16.Size = UDim2.fromScale(0.5, 1);
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Left";
    Frame17.AnchorPoint = Vector2.new(1, 0);
    Frame17.AutoLocalize = false;
    Frame17.BackgroundTransparency = 1;
    Frame17.ClipsDescendants = true;
    Frame17.Size = UDim2.fromScale(0.1, 1);
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "Color";
    Frame18.AutoLocalize = false;
    Frame18.BackgroundColor3 = Color3.fromRGB(234, 210, 139);
    Frame18.ClipsDescendants = true;
    Frame18.Position = UDim2.new(1, -3, 0, 0);
    Frame18.Size = UDim2.fromScale(10, 1);
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner5.BottomRightRadius = UDim.new(0.1, 0);
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.TopLeftRadius = UDim.new(0.1, 0);
    UICorner5.TopRightRadius = UDim.new(0.1, 0);
    UICorner5.Parent = Frame18;
    Frame18.Parent = Frame17;
    Frame17.Parent = Frame16;
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "Right";
    Frame19.AutoLocalize = false;
    Frame19.BackgroundTransparency = 1;
    Frame19.ClipsDescendants = true;
    Frame19.Position = UDim2.fromScale(1, 0);
    Frame19.Size = UDim2.fromScale(0.1, 1);
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Color";
    Frame20.AnchorPoint = Vector2.new(1, 0);
    Frame20.AutoLocalize = false;
    Frame20.BackgroundColor3 = Color3.fromRGB(234, 210, 139);
    Frame20.ClipsDescendants = true;
    Frame20.Position = UDim2.fromOffset(3, 0);
    Frame20.Size = UDim2.fromScale(10, 1);
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICorner";
    UICorner6.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner6.BottomRightRadius = UDim.new(0.1, 0);
    UICorner6.CornerRadius = UDim.new(0.1, 0);
    UICorner6.TopLeftRadius = UDim.new(0.1, 0);
    UICorner6.TopRightRadius = UDim.new(0.1, 0);
    UICorner6.Parent = Frame20;
    Frame20.Parent = Frame19;
    Frame19.Parent = Frame16;
    Frame16.Parent = Frame15;
    Frame15.Parent = Frame14;
    Frame14.Parent = Frame12;
    Frame12.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

function u1.globalnotify() -- Line: 1056
    -- upvalues: u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Global";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(1, 0.095);
    Frame.Size = UDim2.fromScale(1, 0.2);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.025, 0);
    UIPadding.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.015, 3);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "NewMessage";
    CanvasGroup.AutoLocalize = false;
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(61, 70, 91);
    CanvasGroup.BackgroundTransparency = 0.25;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(-0.168789, 0.194327);
    CanvasGroup.Size = UDim2.new(0, 700, 0.16, 0);
    CanvasGroup.Visible = false;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout2.Padding = UDim.new(0, 3);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout2.Parent = CanvasGroup;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0.02, 0);
    UIPadding2.PaddingLeft = UDim.new(0, 8);
    UIPadding2.PaddingRight = UDim.new(0, 8);
    UIPadding2.PaddingTop = UDim.new(0.02, 0);
    UIPadding2.Parent = CanvasGroup;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(214, 0, 0);
    UIStroke.Thickness = 2;
    UIStroke.Transparency = 1;
    UIStroke.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "MessageText";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 1;
    TextLabel.Position = UDim2.fromScale(0, 0.5);
    TextLabel.Size = UDim2.new(0, 135, 0.9, 0);
    TextLabel.Text = "Phantom4_K: TEST";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = CanvasGroup;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner.BottomRightRadius = UDim.new(0.1, 0);
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.TopLeftRadius = UDim.new(0.1, 0);
    UICorner.TopRightRadius = UDim.new(0.1, 0);
    UICorner.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DevIcon";
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=1695750998&w=420&h=420";
    ImageLabel.Position = UDim2.fromOffset(-30, 0);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.ZIndex = 21;
    ImageLabel.Parent = CanvasGroup;
    Frame.Parent = u2.Handler.HUD;
    CanvasGroup.Parent = Frame;

    return Frame;
end;

return u1;