-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.Matches
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.Matches
-- Decompile time: 29.30 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local u2 = nil;
local LocalPlayer = Players.LocalPlayer;
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
local u19 = {};
local u20 = {
    Overview = "MatchesOverview",
    Scoreboard = "MatchesScoreboard",
    Timeline = "MatchesTimeline",
    WeaponStats = "MatchesWeaponStats"
};

local function FormatPlaytime(p21: number) -- Line: 44
    local v22 = p21 // 3600;
    local v23 = p21 % 3600 // 60;

    if v22 <= 0 then
        return `{v23}m`;
    end;

    if v23 > 0 then
        return `{v22}h {v23}m`;
    end;

    return `{v22}h`;
end;

local function FormatTimeAgo(p24: number?) -- Line: 59
    if not p24 or typeof(p24) ~= "number" then
        return "just now";
    end;

    local v25 = os.time() - p24;
    local math_max_ret = math.max(0, v25);

    if math_max_ret < 60 then
        return "just now";
    end;

    if math_max_ret < 3600 then
        return `{math_max_ret // 60} min ago`;
    end;

    if math_max_ret < 86400 then
        return `{math_max_ret // 3600}h ago`;
    end;

    return `{math_max_ret // 86400}d ago`;
end;

local TweenInfo_new_ret = TweenInfo.new(0.25);
local Color3_fromRGB_ret = Color3.fromRGB(133, 200, 129);
local Color3_fromRGB_ret2 = Color3.fromRGB(236, 83, 84);

local function Ratio(p26: number, p27: number) -- Line: 84
    return string.format("%.1f", p26 / math.max(1, p27));
end;

local function SetText(p28: userdata, p29: any) -- Line: 88
    p28.Text = tostring(p29);
end;

local function ClearList(p30) -- Line: 92
    for _, child in p30:GetChildren() do
        if child:IsA("Frame") or (child:IsA("ImageButton") or child:IsA("TextLabel")) then
            child:Destroy();
        end;
    end;
end;

local function LocalPlayerRow(p31) -- Line: 100
    -- upvalues: LocalPlayer (copy)
    local v32 = tostring(LocalPlayer.UserId);

    for _, v in p31.Players do
        if v.UserId == v32 then
            return v;
        end;
    end;

    return nil;
end;

local function Highlight() -- Line: 112
    -- upvalues: u12 (ref), u14 (ref), TweenService (copy), TweenInfo_new_ret (copy)
    if not u12 then
        return;
    end;

    for _, child in u12:GetChildren() do
        if child:IsA("Frame") and child:GetAttribute("MatchIndex") then
            TweenService:Create(child, TweenInfo_new_ret, {
                BackgroundTransparency = child:GetAttribute("MatchIndex") == u14 and 0.5 or 0.8
            }):Play();
        end;
    end;
end;

function u1.DrawMatchTop(p33) -- Line: 129
    -- upvalues: LocalPlayer (copy), u6 (ref), u8 (ref), u11 (ref), FormatTimeAgo (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local Winner = p33.Winner;
    local v34 = tostring(LocalPlayer.UserId);
    local v35 = nil;

    for _, v in p33.Players do
        if v.UserId == v34 then
            v35 = v;
            break;
        end;
    end;

    local v36;

    if v35 then
        if Winner == 0 then
            v36 = false;
        else
            v36 = v35.Team == Winner;
        end;
    else
        v36 = v35;
    end;

    local v37 = u6.Gamemodes[p33.Gamemode];
    local v38;

    if v37 then
        v38 = u8.Modes[v37];
    else
        v38 = v37;
    end;

    local v39 = u6.Maps[p33.Map];
    local v40;

    if v39 then
        v40 = u8.Maps[v39];
    else
        v40 = v39;
    end;

    u11.Thumbnail.Icon.Image = u8 and u8.getIcon and u8.getIcon(v37) or (v38 and (v38.Icon or (`rbxassetid://{v38.Thumbnail}` or "rbxassetid://0")) or "rbxassetid://0");
    u11.GamemodeName.Text = (v37 or "Unknown"):upper();
    u11.Time.Text = FormatTimeAgo(p33.Timestamp or p33.Time);

    if v35 == nil then
        u11.Frame.State.Text = "MATCH";
        u11.Frame.State.TextColor3 = Color3.fromRGB(221, 221, 221);
    elseif v36 then
        u11.Frame.State.Text = "VICTORY";
        u11.Frame.State.TextColor3 = Color3_fromRGB_ret;
    else
        u11.Frame.State.Text = "DEFEAT";
        u11.Frame.State.TextColor3 = Color3_fromRGB_ret2;
    end;

    u11.Frame.CT.Text = tostring(p33.CTScore);
    u11.Frame.T.Text = tostring(p33.TScore);
    u11.Map.Amount.Text = v40 and v40.Name or (v39 or "Unknown");
    local Amount = u11.MatchDuration.Amount;
    local Duration = p33.Duration;
    local v41 = Duration // 3600;
    local v42 = Duration % 3600 // 60;
    local v43;

    if v41 > 0 then
        if v42 > 0 then
            v43 = `{v41}h {v42}m`;
        else
            v43 = `{v41}h`;
        end;
    else
        v43 = `{v42}m`;
    end;

    Amount.Text = v43;
end;

function u1.DrawMatch(u44) -- Line: 162
    -- upvalues: u15 (ref), u1 (copy), u3 (ref), u16 (ref), u18 (ref)
    u15 = u44;
    u1.DrawMatchTop(u44);

    local function Safe(p45, p46) -- Line: 167
        -- upvalues: u44 (copy)
        local success, result = pcall(p46, u44);

        if not success then
            warn((`[Analytics] {p45} failed: {result}`));
        end;
    end;

    local DrawMatchOverview = u3.GetComponent("MatchesOverview").DrawMatchOverview;
    local success, result = pcall(DrawMatchOverview, u44);

    if not success then
        warn((`[Analytics] Overview failed: {result}`));
    end;

    local DrawScoreboard = u3.GetComponent("MatchesScoreboard").DrawScoreboard;
    local success2, result2 = pcall(DrawScoreboard, u44);

    if not success2 then
        warn((`[Analytics] Scoreboard failed: {result2}`));
    end;

    local DrawTimeline = u3.GetComponent("MatchesTimeline").DrawTimeline;
    local success3, result3 = pcall(DrawTimeline, u44);

    if not success3 then
        warn((`[Analytics] Timeline failed: {result3}`));
    end;

    local DrawWeaponStats = u3.GetComponent("MatchesWeaponStats").DrawWeaponStats;
    local success4, result4 = pcall(DrawWeaponStats, u44);

    if not success4 then
        warn((`[Analytics] WeaponStats failed: {result4}`));
    end;

    u16.Reveal(u18, 0);
    u1.RevealPage();
end;

function u1.RevealPage() -- Line: 184
    -- upvalues: u20 (copy), u10 (ref), u3 (ref)
    for i, v in u20 do
        if u10[i].Visible then
            u3.GetComponent(v).Reveal();
        end;
    end;
end;

function u1.Open() -- Line: 192
    -- upvalues: u16 (ref), u17 (ref), u18 (ref), u19 (copy), Highlight (copy)
    u16.Reveal(u17, 0);
    u16.Reveal(u18, 0.05);
    u16.RevealAll(u19, 0.1, 0.035, 12);
    Highlight();
end;

function u1.SelectMatch(p47: number) -- Line: 200
    -- upvalues: u14 (ref), Highlight (copy), u7 (ref)
    u14 = p47;
    Highlight();
    u7.RequestMatch(p47);
end;

function u1.OnMatchReceived(p48: number, p49: any) -- Line: 208
    -- upvalues: u14 (ref), u1 (copy), u12 (ref)
    if p48 == u14 then
        u1.DrawMatch(p49);
    end;

    if u12 then
        local v50 = u12:FindFirstChild((tostring(p48)));

        if v50 and (v50:FindFirstChild("Score") and v50.Score:FindFirstChild("Amount")) then
            local v51 = p49.CTScore or 0;
            local v52 = p49.TScore or 0;
            v50.Score.Amount.RichText = true;
            v50.Score.Amount.Text = `<font color="rgb(172, 195, 220)">{v51}</font> - <font color="rgb(255, 203, 107)">{v52}</font>`;
        end;
    end;
end;

function u1.DrawPicker(p53) -- Line: 224
    -- upvalues: u12 (ref), u5 (ref), u19 (copy), u16 (ref), u1 (copy), u6 (ref), u8 (ref), FormatTimeAgo (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u4 (ref), u14 (ref), TweenService (copy), TweenInfo_new_ret (copy), u2 (ref)
    local v54 = u12;
    local Matches = p53.Matches;
    u5:Cleanup();

    for _, child in v54:GetChildren() do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy();
        end;
    end;

    table.clear(u19);

    if #Matches ~= 0 then
        u1.SetInfoVisible(true);

        for i, v in Matches do
            local u55 = u1.pickerRow();
            u55.Name = tostring(v.Index);
            u55.LayoutOrder = i;
            local v56 = u6.Gamemodes[v.Gamemode];
            local v57;

            if v56 then
                v57 = u8.Modes[v56];
            else
                v57 = v56;
            end;

            u55.GamemodeName.Text = v56 or "Unknown";
            u55.Time.Text = FormatTimeAgo(v.Time or v.Timestamp);
            u55.Thumbnail.Icon.Image = u8 and (u8.getIcon and u8.getIcon(v56)) or (v57 and (v57.Icon or (`rbxassetid://{v57.Thumbnail}` or "rbxassetid://0")) or "rbxassetid://0");
            local v58 = v.Result == 1;
            u55.Result.Amount.Text = v58 and "WIN" or "LOSE";
            u55.Result.Amount.TextColor3 = v58 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
            local v59 = v.Kills or 0;
            local v60 = v.Deaths or 0;
            local v61 = v59 / math.max(1, v60);
            u55.KD.Amount.Text = string.format("%.1f", v59 / math.max(1, v60));
            u55.KD.Amount.TextColor3 = v61 < 1 and Color3_fromRGB_ret2 or Color3_fromRGB_ret;
            local v62 = v.CTScore or 0;
            local v63 = v.TScore or 0;
            u55.Score.Amount.RichText = true;
            u55.Score.Amount.Text = `<font color="rgb(172, 195, 220)">{v62}</font> - <font color="rgb(255, 203, 107)">{v63}</font>`;
            u55:SetAttribute("MatchIndex", v.Index);
            table.insert(u19, u16.Capture(u55));
            u5:Add(`Picker_{v.Index}_InputBegan`, u55.InputBegan:Connect(function(p64) -- Line: 292
                -- upvalues: u4 (ref), u1 (ref), v (copy)
                if p64.UserInputType == Enum.UserInputType.MouseButton1 or p64.UserInputType == Enum.UserInputType.Touch then
                    u4.Play("UI.mainmenu_rollover");
                    u1.SelectMatch(v.Index);
                end;
            end));

            local function Enter() -- Line: 299
                -- upvalues: u14 (ref), v (copy), TweenService (ref), u55 (copy), TweenInfo_new_ret (ref)
                if u14 == v.Index then
                    return;
                end;

                TweenService:Create(u55, TweenInfo_new_ret, {
                    BackgroundTransparency = 0.65
                }):Play();
            end;

            local function Leave() -- Line: 309
                -- upvalues: u14 (ref), v (copy), TweenService (ref), u55 (copy), TweenInfo_new_ret (ref)
                if u14 == v.Index then
                    return;
                end;

                TweenService:Create(u55, TweenInfo_new_ret, {
                    BackgroundTransparency = 0.8
                }):Play();
            end;

            u5:Add(`Picker_{v.Index}_MouseEnter`, u55.MouseEnter:Connect(Enter));
            u5:Add(`Picker_{v.Index}_MouseLeave`, u55.MouseLeave:Connect(Leave));
            u5:Add(`Picker_{v.Index}_SelectionGained`, u55.SelectionGained:Connect(Enter));
            u5:Add(`Picker_{v.Index}_SelectionLost`, u55.SelectionLost:Connect(Leave));
            u2.Bind(u55, function() -- Line: 324
                -- upvalues: u4 (ref), u1 (ref), v (copy)
                u4.Play("UI.mainmenu_rollover");
                u1.SelectMatch(v.Index);
            end);
            u55.Parent = v54;
        end;

        u1.SelectMatch(Matches[1].Index);

        return;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Empty";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.fromScale(1, 0.15);
    TextLabel.Font = Enum.Font.Oswald;
    TextLabel.Text = "No matches played yet";
    TextLabel.TextColor3 = Color3.fromRGB(160, 160, 163);
    TextLabel.TextScaled = true;
    table.insert(u19, u16.Capture(TextLabel));
    TextLabel.Parent = v54;
    u1.SetInfoVisible(false);
end;

function u1.ClearInitial() -- Line: 335
    -- upvalues: u10 (ref), ClearList (copy), u5 (ref), u3 (ref), u1 (copy)
    local Timeline = u10.Timeline;
    ClearList(Timeline.Rounds.UnderHolder);
    ClearList(Timeline.Scoreboard.CT.List);
    ClearList(Timeline.Scoreboard.T.List);
    ClearList(Timeline.Timeline.List);
    u5:Cleanup();
    u3.GetComponent("MatchesTimeline").Cleanup();
    u1.SetInfoVisible(false);
end;

function u1.Cleanup() -- Line: 349
    -- upvalues: u5 (ref), u3 (ref)
    u5:Cleanup();
    u3.GetComponent("MatchesTimeline").Cleanup();
end;

function u1.SetInfoVisible(p65: boolean) -- Line: 354
    -- upvalues: u13 (ref), u10 (ref)
    if u13 then
        u13.Visible = p65;
    end;

    if not p65 and u10 then
        for _, child in u10:GetChildren() do
            if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                child.Visible = false;
            end;
        end;
    end;
end;

function u1.GetSelected() -- Line: 370
    -- upvalues: u14 (ref)
    return u14;
end;

function u1.Init(p66) -- Line: 374
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u16 (ref), u2 (ref)
    u3 = p66:GetModule("Gui");
    u4 = p66:GetModule("SoundManager");
    u5 = p66:GetModule("Maid").new();
    u6 = p66:GetModule("Enums");
    u7 = p66:GetModule("AnalyticsData");
    u8 = p66:GetModule("GamemodesData");
    u16 = u3.GetComponent("AnalyticsMotion");
    u2 = u3.GetComponent("Gamepad");
end;

function u1.new(p67) -- Line: 388
    -- upvalues: u9 (ref), u13 (ref), u10 (ref), u11 (ref), u12 (ref), u17 (ref), u16 (ref), u18 (ref), u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Matches";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.9;
    Frame.ClipsDescendants = true;
    Frame.Position = UDim2.fromScale(0.5, 0.116);
    Frame.Selectable = true;
    Frame.SelectionGroup = true;
    Frame.Size = UDim2.fromScale(1, 0.882);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Main";
    Frame2.Active = true;
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.0337009);
    Frame2.Selectable = true;
    Frame2.SelectionGroup = true;
    Frame2.Size = UDim2.fromScale(0.9, 0.94507);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Matches";
    Frame3.BackgroundColor3 = Color3.fromRGB(39, 39, 39);
    Frame3.BackgroundTransparency = 0.4;
    Frame3.LayoutOrder = 1;
    Frame3.Position = UDim2.fromScale(-4.92835e-8, 4.85125e-8);
    Frame3.Size = UDim2.fromScale(0.265, 1);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(184, 184, 184);
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame3;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.01, 0);
    UICorner.BottomRightRadius = UDim.new(0.01, 0);
    UICorner.CornerRadius = UDim.new(0.01, 0);
    UICorner.TopLeftRadius = UDim.new(0.01, 0);
    UICorner.TopRightRadius = UDim.new(0.01, 0);
    UICorner.Parent = Frame3;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.5, 0.0191889);
    TextLabel.Size = UDim2.fromScale(0.93, 0.0376973);
    TextLabel.Text = "RECENT MATCHES";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 343;
    TextLabel.Parent = Frame3;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Frame";
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 1);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.fromScale(0, 1);
    ScrollingFrame.Position = UDim2.fromScale(0.5, 1);
    ScrollingFrame.ScrollBarThickness = 8;
    ScrollingFrame.Selectable = false;
    ScrollingFrame.Size = UDim2.fromScale(1, 0.93215);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0.02, 0);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.Parent = ScrollingFrame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.BackgroundColor3 = Color3.fromRGB(113, 147, 189);
    Frame4.BackgroundTransparency = 0.8;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Size = UDim2.fromScale(1, 0.1);
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Line";
    Frame5.AnchorPoint = Vector2.new(0.5, 0);
    Frame5.BackgroundColor3 = Color3.fromRGB(184, 184, 184);
    Frame5.BackgroundTransparency = 0.5;
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.LayoutOrder = 2;
    Frame5.Position = UDim2.fromScale(0.5, 0);
    Frame5.Size = UDim2.new(1, 0, 0, 1);
    Frame5.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Thumbnail";
    Frame6.AnchorPoint = Vector2.new(0, 0.5);
    Frame6.BackgroundColor3 = Color3.fromRGB(173, 173, 173);
    Frame6.BackgroundTransparency = 0.8;
    Frame6.Position = UDim2.fromScale(0.02, 0.5);
    Frame6.Size = UDim2.fromScale(0.6, 0.6);
    Frame6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner2.BottomRightRadius = UDim.new(0.2, 0);
    UICorner2.CornerRadius = UDim.new(0.2, 0);
    UICorner2.TopLeftRadius = UDim.new(0.2, 0);
    UICorner2.TopRightRadius = UDim.new(0.2, 0);
    UICorner2.Parent = Frame6;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.ImageColor3 = Color3.fromRGB(220, 220, 220);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel.Parent = Frame6;
    Frame6.Parent = Frame4;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "GamemodeName";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.14, 0.2);
    TextLabel2.Size = UDim2.fromScale(0.255461, 0.35);
    TextLabel2.Text = "Casual";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextTransparency = 0.25;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = Frame4;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Time";
    TextLabel3.AnchorPoint = Vector2.new(0, 1);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.14, 0.8);
    TextLabel3.Size = UDim2.fromScale(0.255461, 0.3);
    TextLabel3.Text = "2 min ago";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextTransparency = 0.5;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = Frame4;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Result";
    Frame7.AnchorPoint = Vector2.new(1, 0.5);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0.975, 0.5);
    Frame7.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel4.Size = UDim2.fromScale(1, 0.419072);
    TextLabel4.Text = "RESULT";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextTransparency = 0.25;
    TextLabel4.ZIndex = 343;
    TextLabel4.Parent = Frame7;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Amount";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel5.Size = UDim2.fromScale(1, 0.419072);
    TextLabel5.Text = "WIN";
    TextLabel5.TextColor3 = Color3.fromRGB(133, 200, 129);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel5.ZIndex = 343;
    TextLabel5.Parent = Frame7;
    Frame7.Parent = Frame4;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "KD";
    Frame8.AnchorPoint = Vector2.new(1, 0.5);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0.775, 0.5);
    Frame8.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Title";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel6.Size = UDim2.fromScale(1, 0.419072);
    TextLabel6.Text = "KD";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel6.TextTransparency = 0.25;
    TextLabel6.ZIndex = 343;
    TextLabel6.Parent = Frame8;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Amount";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel7.Size = UDim2.fromScale(1, 0.419072);
    TextLabel7.Text = "1.4";
    TextLabel7.TextColor3 = Color3.fromRGB(133, 200, 129);
    TextLabel7.TextScaled = true;
    TextLabel7.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel7.ZIndex = 343;
    TextLabel7.Parent = Frame8;
    Frame8.Parent = Frame4;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Score";
    Frame9.AnchorPoint = Vector2.new(1, 0.5);
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0.575, 0.5);
    Frame9.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Title";
    TextLabel8.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel8.Size = UDim2.fromScale(1, 0.419072);
    TextLabel8.Text = "SCORE";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel8.TextTransparency = 0.25;
    TextLabel8.ZIndex = 343;
    TextLabel8.Parent = Frame9;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "Amount";
    TextLabel9.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel9.RichText = true;
    TextLabel9.Size = UDim2.fromScale(1, 0.419072);
    TextLabel9.Text = "<font color=\"rgb(172, 195, 220)\">11</font> - <font color=\"rgb(255, 203, 107)\">62</font>";
    TextLabel9.TextColor3 = Color3.fromRGB(200, 200, 200);
    TextLabel9.TextScaled = true;
    TextLabel9.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel9.ZIndex = 343;
    TextLabel9.Parent = Frame9;
    Frame9.Parent = Frame4;
    Frame4.Parent = ScrollingFrame;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.new();
    UIGridLayout.CellSize = UDim2.fromScale(1, 0.09);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = ScrollingFrame;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Frame";
    Frame10.BackgroundTransparency = 1;
    Frame10.Size = UDim2.fromScale(1, 0.1);
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Line";
    Frame11.AnchorPoint = Vector2.new(0.5, 0);
    Frame11.BackgroundColor3 = Color3.fromRGB(184, 184, 184);
    Frame11.BackgroundTransparency = 0.5;
    Frame11.BorderColor3 = Color3.new();
    Frame11.BorderSizePixel = 0;
    Frame11.LayoutOrder = 2;
    Frame11.Position = UDim2.fromScale(0.5, 0);
    Frame11.Size = UDim2.new(1, 0, 0, 1);
    Frame11.Parent = Frame10;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Thumbnail";
    Frame12.AnchorPoint = Vector2.new(0, 0.5);
    Frame12.BackgroundColor3 = Color3.fromRGB(173, 173, 173);
    Frame12.BackgroundTransparency = 0.8;
    Frame12.Position = UDim2.fromScale(0.02, 0.5);
    Frame12.Size = UDim2.fromScale(0.6, 0.6);
    Frame12.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner3.BottomRightRadius = UDim.new(0.2, 0);
    UICorner3.CornerRadius = UDim.new(0.2, 0);
    UICorner3.TopLeftRadius = UDim.new(0.2, 0);
    UICorner3.TopRightRadius = UDim.new(0.2, 0);
    UICorner3.Parent = Frame12;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Icon";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://100429874437897";
    ImageLabel2.ImageColor3 = Color3.fromRGB(220, 220, 220);
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel2.Parent = Frame12;
    Frame12.Parent = Frame10;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "GamemodeName";
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0.14, 0.2);
    TextLabel10.Size = UDim2.fromScale(0.255461, 0.35);
    TextLabel10.Text = "Casual";
    TextLabel10.TextColor3 = Color3.new(1, 1, 1);
    TextLabel10.TextScaled = true;
    TextLabel10.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel10.TextTransparency = 0.25;
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel10.ZIndex = 343;
    TextLabel10.Parent = Frame10;
    local TextLabel11 = Instance.new("TextLabel");
    TextLabel11.Name = "Time";
    TextLabel11.AnchorPoint = Vector2.new(0, 1);
    TextLabel11.BackgroundTransparency = 1;
    TextLabel11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel11.Position = UDim2.fromScale(0.14, 0.8);
    TextLabel11.Size = UDim2.fromScale(0.255461, 0.3);
    TextLabel11.Text = "2 min ago";
    TextLabel11.TextColor3 = Color3.new(1, 1, 1);
    TextLabel11.TextScaled = true;
    TextLabel11.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel11.TextTransparency = 0.5;
    TextLabel11.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel11.ZIndex = 343;
    TextLabel11.Parent = Frame10;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Result";
    Frame13.AnchorPoint = Vector2.new(1, 0.5);
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(0.975, 0.5);
    Frame13.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel12 = Instance.new("TextLabel");
    TextLabel12.Name = "Title";
    TextLabel12.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel12.BackgroundTransparency = 1;
    TextLabel12.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel12.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel12.Size = UDim2.fromScale(1, 0.419072);
    TextLabel12.Text = "RESULT";
    TextLabel12.TextColor3 = Color3.new(1, 1, 1);
    TextLabel12.TextScaled = true;
    TextLabel12.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel12.TextTransparency = 0.25;
    TextLabel12.ZIndex = 343;
    TextLabel12.Parent = Frame13;
    local TextLabel13 = Instance.new("TextLabel");
    TextLabel13.Name = "Amount";
    TextLabel13.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel13.BackgroundTransparency = 1;
    TextLabel13.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel13.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel13.Size = UDim2.fromScale(1, 0.419072);
    TextLabel13.Text = "LOSE";
    TextLabel13.TextColor3 = Color3.fromRGB(236, 83, 84);
    TextLabel13.TextScaled = true;
    TextLabel13.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel13.ZIndex = 343;
    TextLabel13.Parent = Frame13;
    Frame13.Parent = Frame10;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "KD";
    Frame14.AnchorPoint = Vector2.new(1, 0.5);
    Frame14.BackgroundTransparency = 1;
    Frame14.Position = UDim2.fromScale(0.775, 0.5);
    Frame14.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel14 = Instance.new("TextLabel");
    TextLabel14.Name = "Title";
    TextLabel14.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel14.BackgroundTransparency = 1;
    TextLabel14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel14.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel14.Size = UDim2.fromScale(1, 0.419072);
    TextLabel14.Text = "KD";
    TextLabel14.TextColor3 = Color3.new(1, 1, 1);
    TextLabel14.TextScaled = true;
    TextLabel14.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel14.TextTransparency = 0.25;
    TextLabel14.ZIndex = 343;
    TextLabel14.Parent = Frame14;
    local TextLabel15 = Instance.new("TextLabel");
    TextLabel15.Name = "Amount";
    TextLabel15.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel15.BackgroundTransparency = 1;
    TextLabel15.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel15.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel15.Size = UDim2.fromScale(1, 0.419072);
    TextLabel15.Text = "0.6";
    TextLabel15.TextColor3 = Color3.fromRGB(236, 83, 84);
    TextLabel15.TextScaled = true;
    TextLabel15.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel15.ZIndex = 343;
    TextLabel15.Parent = Frame14;
    Frame14.Parent = Frame10;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Score";
    Frame15.AnchorPoint = Vector2.new(1, 0.5);
    Frame15.BackgroundTransparency = 1;
    Frame15.Position = UDim2.fromScale(0.575, 0.5);
    Frame15.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel16 = Instance.new("TextLabel");
    TextLabel16.Name = "Title";
    TextLabel16.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel16.BackgroundTransparency = 1;
    TextLabel16.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel16.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel16.Size = UDim2.fromScale(1, 0.419072);
    TextLabel16.Text = "SCORE";
    TextLabel16.TextColor3 = Color3.new(1, 1, 1);
    TextLabel16.TextScaled = true;
    TextLabel16.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel16.TextTransparency = 0.25;
    TextLabel16.ZIndex = 343;
    TextLabel16.Parent = Frame15;
    local TextLabel17 = Instance.new("TextLabel");
    TextLabel17.Name = "Amount";
    TextLabel17.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel17.BackgroundTransparency = 1;
    TextLabel17.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel17.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel17.RichText = true;
    TextLabel17.Size = UDim2.fromScale(1, 0.419072);
    TextLabel17.Text = "<font color=\"rgb(172, 195, 220)\">11</font> - <font color=\"rgb(255, 203, 107)\">62</font>";
    TextLabel17.TextColor3 = Color3.fromRGB(200, 200, 200);
    TextLabel17.TextScaled = true;
    TextLabel17.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel17.ZIndex = 343;
    TextLabel17.Parent = Frame15;
    Frame15.Parent = Frame10;
    Frame10.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame3;
    Frame3.Parent = Frame2;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Info";
    Frame16.AnchorPoint = Vector2.new(1, 0);
    Frame16.BackgroundColor3 = Color3.fromRGB(39, 39, 39);
    Frame16.BackgroundTransparency = 0.4;
    Frame16.LayoutOrder = 1;
    Frame16.Position = UDim2.fromScale(1, 0);
    Frame16.Size = UDim2.fromScale(0.723309, 1);
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.fromRGB(184, 184, 184);
    UIStroke2.Transparency = 0.5;
    UIStroke2.Parent = Frame16;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.BottomLeftRadius = UDim.new(0.01, 0);
    UICorner4.BottomRightRadius = UDim.new(0.01, 0);
    UICorner4.CornerRadius = UDim.new(0.01, 0);
    UICorner4.TopLeftRadius = UDim.new(0.01, 0);
    UICorner4.TopRightRadius = UDim.new(0.01, 0);
    UICorner4.Parent = Frame16;
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Main";
    Frame17.AnchorPoint = Vector2.new(0, 1);
    Frame17.BackgroundColor3 = Color3.new();
    Frame17.BackgroundTransparency = 0.85;
    Frame17.BorderColor3 = Color3.new();
    Frame17.BorderSizePixel = 0;
    Frame17.Position = UDim2.fromScale(0, 1);
    Frame17.Size = UDim2.fromScale(1, 0.878);
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "Line";
    Frame18.AnchorPoint = Vector2.new(0.5, 0);
    Frame18.BackgroundColor3 = Color3.fromRGB(184, 184, 184);
    Frame18.BackgroundTransparency = 0.5;
    Frame18.BorderColor3 = Color3.new();
    Frame18.BorderSizePixel = 0;
    Frame18.LayoutOrder = 2;
    Frame18.Position = UDim2.fromScale(0.5, 0);
    Frame18.Size = UDim2.new(1, 0, 0, 1);
    Frame18.Parent = Frame17;
    Frame17.Parent = Frame16;
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "Top";
    Frame19.BackgroundTransparency = 1;
    Frame19.Size = UDim2.fromScale(1, 0.122);
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Thumbnail";
    Frame20.AnchorPoint = Vector2.new(0, 0.5);
    Frame20.BackgroundColor3 = Color3.fromRGB(173, 173, 173);
    Frame20.BackgroundTransparency = 0.8;
    Frame20.Position = UDim2.fromScale(0.02, 0.5);
    Frame20.Size = UDim2.fromScale(0.6, 0.6);
    Frame20.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner5.BottomRightRadius = UDim.new(0.2, 0);
    UICorner5.CornerRadius = UDim.new(0.2, 0);
    UICorner5.TopLeftRadius = UDim.new(0.2, 0);
    UICorner5.TopRightRadius = UDim.new(0.2, 0);
    UICorner5.Parent = Frame20;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Icon";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://100429874437897";
    ImageLabel3.ImageColor3 = Color3.fromRGB(220, 220, 220);
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel3.Parent = Frame20;
    Frame20.Parent = Frame19;
    local TextLabel18 = Instance.new("TextLabel");
    TextLabel18.Name = "GamemodeName";
    TextLabel18.BackgroundTransparency = 1;
    TextLabel18.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel18.Position = UDim2.fromScale(0.09, 0.2);
    TextLabel18.Size = UDim2.fromScale(0.2, 0.35);
    TextLabel18.Text = "CASUAL";
    TextLabel18.TextColor3 = Color3.new(1, 1, 1);
    TextLabel18.TextScaled = true;
    TextLabel18.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel18.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel18.ZIndex = 343;
    TextLabel18.Parent = Frame19;
    local TextLabel19 = Instance.new("TextLabel");
    TextLabel19.Name = "Time";
    TextLabel19.BackgroundTransparency = 1;
    TextLabel19.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel19.Position = UDim2.fromScale(0.09, 0.568689);
    TextLabel19.Size = UDim2.fromScale(0.25, 0.23);
    TextLabel19.Text = "2 min ago";
    TextLabel19.TextColor3 = Color3.new(1, 1, 1);
    TextLabel19.TextScaled = true;
    TextLabel19.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel19.TextTransparency = 0.5;
    TextLabel19.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel19.ZIndex = 343;
    TextLabel19.Parent = Frame19;
    local Frame21 = Instance.new("Frame");
    Frame21.Name = "Frame";
    Frame21.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame21.BackgroundTransparency = 1;
    Frame21.Position = UDim2.fromScale(0.45, 0.5);
    Frame21.Size = UDim2.fromScale(0.249851, 1);
    local TextLabel20 = Instance.new("TextLabel");
    TextLabel20.Name = "State";
    TextLabel20.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel20.BackgroundTransparency = 1;
    TextLabel20.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel20.Position = UDim2.fromScale(0.5, 0.18);
    TextLabel20.Size = UDim2.fromScale(1, 0.3);
    TextLabel20.Text = "VICTORY";
    TextLabel20.TextColor3 = Color3.fromRGB(133, 200, 129);
    TextLabel20.TextScaled = true;
    TextLabel20.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel20.ZIndex = 343;
    TextLabel20.Parent = Frame21;
    local TextLabel21 = Instance.new("TextLabel");
    TextLabel21.Name = "Separate";
    TextLabel21.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel21.BackgroundTransparency = 1;
    TextLabel21.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel21.Position = UDim2.fromScale(0.5, 0.55);
    TextLabel21.Size = UDim2.fromScale(1, 0.25);
    TextLabel21.Text = ":";
    TextLabel21.TextColor3 = Color3.fromRGB(200, 200, 200);
    TextLabel21.TextScaled = true;
    TextLabel21.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel21.ZIndex = 343;
    TextLabel21.Parent = Frame21;
    local TextLabel22 = Instance.new("TextLabel");
    TextLabel22.Name = "CT";
    TextLabel22.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel22.BackgroundTransparency = 1;
    TextLabel22.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel22.Position = UDim2.fromScale(0.5, 0.48);
    TextLabel22.Size = UDim2.fromScale(0.75, 0.42);
    TextLabel22.Text = "11";
    TextLabel22.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel22.TextScaled = true;
    TextLabel22.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel22.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel22.ZIndex = 343;
    TextLabel22.Parent = Frame21;
    local TextLabel23 = Instance.new("TextLabel");
    TextLabel23.Name = "T";
    TextLabel23.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel23.BackgroundTransparency = 1;
    TextLabel23.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel23.Position = UDim2.fromScale(0.5, 0.48);
    TextLabel23.Size = UDim2.fromScale(0.75, 0.42);
    TextLabel23.Text = "62";
    TextLabel23.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel23.TextScaled = true;
    TextLabel23.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel23.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel23.ZIndex = 343;
    TextLabel23.Parent = Frame21;
    Frame21.Parent = Frame19;
    local Frame22 = Instance.new("Frame");
    Frame22.Name = "Map";
    Frame22.AnchorPoint = Vector2.new(1, 0.5);
    Frame22.BackgroundTransparency = 1;
    Frame22.Position = UDim2.fromScale(0.975, 0.5);
    Frame22.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel24 = Instance.new("TextLabel");
    TextLabel24.Name = "Title";
    TextLabel24.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel24.BackgroundTransparency = 1;
    TextLabel24.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel24.Position = UDim2.fromScale(0.5, 0.2);
    TextLabel24.Size = UDim2.fromScale(1, 0.280928);
    TextLabel24.Text = "MAP";
    TextLabel24.TextColor3 = Color3.new(1, 1, 1);
    TextLabel24.TextScaled = true;
    TextLabel24.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel24.TextTransparency = 0.25;
    TextLabel24.ZIndex = 343;
    TextLabel24.Parent = Frame22;
    local TextLabel25 = Instance.new("TextLabel");
    TextLabel25.Name = "Amount";
    TextLabel25.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel25.BackgroundTransparency = 1;
    TextLabel25.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel25.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel25.Size = UDim2.fromScale(1, 0.419072);
    TextLabel25.Text = "Dust II";
    TextLabel25.TextColor3 = Color3.new(1, 1, 1);
    TextLabel25.TextScaled = true;
    TextLabel25.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel25.ZIndex = 343;
    TextLabel25.Parent = Frame22;
    Frame22.Parent = Frame19;
    local Frame23 = Instance.new("Frame");
    Frame23.Name = "MatchDuration";
    Frame23.AnchorPoint = Vector2.new(1, 0.5);
    Frame23.BackgroundTransparency = 1;
    Frame23.Position = UDim2.fromScale(0.825, 0.5);
    Frame23.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel26 = Instance.new("TextLabel");
    TextLabel26.Name = "Title";
    TextLabel26.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel26.BackgroundTransparency = 1;
    TextLabel26.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel26.Position = UDim2.fromScale(0.5, 0.2);
    TextLabel26.Size = UDim2.fromScale(1, 0.280928);
    TextLabel26.Text = "MATCH DURATION";
    TextLabel26.TextColor3 = Color3.new(1, 1, 1);
    TextLabel26.TextScaled = true;
    TextLabel26.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel26.TextTransparency = 0.25;
    TextLabel26.ZIndex = 343;
    TextLabel26.Parent = Frame23;
    local TextLabel27 = Instance.new("TextLabel");
    TextLabel27.Name = "Amount";
    TextLabel27.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel27.BackgroundTransparency = 1;
    TextLabel27.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel27.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel27.Size = UDim2.fromScale(1, 0.419072);
    TextLabel27.Text = "12m 48s";
    TextLabel27.TextColor3 = Color3.new(1, 1, 1);
    TextLabel27.TextScaled = true;
    TextLabel27.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel27.ZIndex = 343;
    TextLabel27.Parent = Frame23;
    Frame23.Parent = Frame19;
    Frame19.Parent = Frame16;
    Frame16.Parent = Frame2;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.92;
    UIAspectRatioConstraint.Parent = Frame2;
    Frame2.Parent = Frame;
    u9 = Frame;
    u13 = Frame.Main.Info;
    u10 = Frame.Main.Info.Main;
    u11 = Frame.Main.Info.Top;
    u12 = Frame.Main.Matches.Frame;
    u17 = u16.Capture(Frame.Main.Matches);
    u18 = u16.Capture(u11);
    u13.Visible = false;
    u1.Info = u13;
    u1.MatchPages = u10;
    Frame.Parent = p67;

    return Frame;
end;

function u1.pickerRow() -- Line: 1391
    local Frame = Instance.new("Frame");
    Frame:SetAttribute("Select", true);
    Frame.Name = "Frame";
    Frame.BackgroundColor3 = Color3.fromRGB(113, 147, 189);
    Frame.BackgroundTransparency = 0.8;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 0.1);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundColor3 = Color3.fromRGB(184, 184, 184);
    Frame2.BackgroundTransparency = 0.5;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.LayoutOrder = 2;
    Frame2.Position = UDim2.fromScale(0.5, 0);
    Frame2.Size = UDim2.new(1, 0, 0, 1);
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Thumbnail";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundColor3 = Color3.fromRGB(173, 173, 173);
    Frame3.BackgroundTransparency = 0.8;
    Frame3.Position = UDim2.fromScale(0.02, 0.5);
    Frame3.Size = UDim2.fromScale(0.6, 0.6);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.2, 0);
    UICorner.BottomRightRadius = UDim.new(0.2, 0);
    UICorner.CornerRadius = UDim.new(0.2, 0);
    UICorner.TopLeftRadius = UDim.new(0.2, 0);
    UICorner.TopRightRadius = UDim.new(0.2, 0);
    UICorner.Parent = Frame3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://100429874437897";
    ImageLabel.ImageColor3 = Color3.fromRGB(220, 220, 220);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel.Parent = Frame3;
    Frame3.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "GamemodeName";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.14, 0.2);
    TextLabel.Size = UDim2.fromScale(0.255461, 0.35);
    TextLabel.Text = "Casual";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextTransparency = 0.25;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.ZIndex = 343;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Time";
    TextLabel2.AnchorPoint = Vector2.new(0, 1);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.14, 0.8);
    TextLabel2.Size = UDim2.fromScale(0.255461, 0.3);
    TextLabel2.Text = "2 min ago";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextTransparency = 0.5;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 343;
    TextLabel2.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Result";
    Frame4.AnchorPoint = Vector2.new(1, 0.5);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.975, 0.5);
    Frame4.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel3.Size = UDim2.fromScale(1, 0.419072);
    TextLabel3.Text = "RESULT";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextTransparency = 0.25;
    TextLabel3.ZIndex = 343;
    TextLabel3.Parent = Frame4;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Amount";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel4.Size = UDim2.fromScale(1, 0.419072);
    TextLabel4.Text = "WIN";
    TextLabel4.TextColor3 = Color3.fromRGB(133, 200, 129);
    TextLabel4.TextScaled = true;
    TextLabel4.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.ZIndex = 343;
    TextLabel4.Parent = Frame4;
    Frame4.Parent = Frame;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "KD";
    Frame5.AnchorPoint = Vector2.new(1, 0.5);
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.775, 0.5);
    Frame5.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel5.Size = UDim2.fromScale(1, 0.419072);
    TextLabel5.Text = "KD";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel5.TextTransparency = 0.25;
    TextLabel5.ZIndex = 343;
    TextLabel5.Parent = Frame5;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Amount";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel6.Size = UDim2.fromScale(1, 0.419072);
    TextLabel6.Text = "1.4";
    TextLabel6.TextColor3 = Color3.fromRGB(133, 200, 129);
    TextLabel6.TextScaled = true;
    TextLabel6.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel6.ZIndex = 343;
    TextLabel6.Parent = Frame5;
    Frame5.Parent = Frame;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Score";
    Frame6.AnchorPoint = Vector2.new(1, 0.5);
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0.575, 0.5);
    Frame6.Size = UDim2.fromScale(0.125, 0.8);
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Title";
    TextLabel7.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.5, 0.130928);
    TextLabel7.Size = UDim2.fromScale(1, 0.419072);
    TextLabel7.Text = "SCORE";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel7.TextTransparency = 0.25;
    TextLabel7.ZIndex = 343;
    TextLabel7.Parent = Frame6;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "Amount";
    TextLabel8.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.5, 0.9);
    TextLabel8.RichText = true;
    TextLabel8.Size = UDim2.fromScale(1, 0.419072);
    TextLabel8.Text = "<font color=\"rgb(172, 195, 220)\">11</font> - <font color=\"rgb(255, 203, 107)\">62</font>";
    TextLabel8.TextColor3 = Color3.fromRGB(200, 200, 200);
    TextLabel8.TextScaled = true;
    TextLabel8.TextStrokeColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel8.ZIndex = 343;
    TextLabel8.Parent = Frame6;
    Frame6.Parent = Frame;

    return Frame;
end;

return u1;