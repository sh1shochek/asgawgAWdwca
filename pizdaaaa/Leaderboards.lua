-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.Leaderboards
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Analytics.Leaderboards
-- Decompile time: 20.10 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local u2 = {};
local u3 = { {
        Name = "Kredits",
        Title = "KREDITS SPENT",
        Icon = "rbxassetid://138240378050344",
        Hint = "Spend Kredits to claim a spot"
    }, {
        Name = "Robux",
        Title = "ROBUX SPENT",
        Glyph = "",
        Hint = "Robux purchases count toward this board"
    }, {
        Name = "Wins",
        Title = "WINS",
        Icon = "rbxassetid://78249154804993",
        Hint = "Win matches to claim a spot"
    } };
local u4 = { Color3.fromRGB(255, 196, 70), Color3.fromRGB(196, 206, 219), Color3.fromRGB(205, 127, 70) };
local u5 = { "1ST PLACE", "2ND PLACE", "3RD PLACE" };
local Color3_fromRGB_ret = Color3.fromRGB(131, 216, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(110, 110, 118);
local Color3_fromRGB_ret3 = Color3.fromRGB(150, 150, 155);
local u6 = {
    Frame = { "BackgroundTransparency" },
    TextLabel = { "TextTransparency" },
    ImageLabel = { "BackgroundTransparency", "ImageTransparency" },
    UIStroke = { "Transparency" }
};
local TweenInfo_new_ret = TweenInfo.new(0.25);

local function FormatNumber(p7: number) -- Line: 54
    local math_floor_ret = math.floor(p7);

    return tostring(math_floor_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function CaptureFade(p8: userdata) -- Line: 58
    -- upvalues: u6 (copy)
    local v9 = {};

    for _, v in { p8, unpack(p8:GetDescendants()) } do
        local v10 = u6[v.ClassName];

        if v10 then
            local v11 = v;

            for _, v2 in v10 do
                if v11[v2] < 1 then
                    table.insert(v9, { v11, v2, v11[v2] });
                end;
            end;
        end;
    end;

    return v9;
end;

local function FadeIn(p12: any, p13: number) -- Line: 78
    -- upvalues: TweenService (copy)
    local TweenInfo_new_ret2 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, p13);

    for _, v in p12.Fades do
        local v14, v15, v16 = unpack(v);
        v14[v15] = 1;
        TweenService:Create(v14, TweenInfo_new_ret2, {
            [v15] = v16
        }):Play();
    end;

    p12.Holder.Position = UDim2.fromOffset(12, 0);
    TweenService:Create(p12.Holder, TweenInfo_new_ret2, {
        Position = UDim2.new()
    }):Play();
end;

local function Shine(p17: any, p18: number) -- Line: 92
    -- upvalues: TweenService (copy)
    local UIGradient = p17.Holder.Shine.UIGradient;
    UIGradient.Offset = Vector2.new(-1, 0);
    TweenService:Create(UIGradient, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, p18), {
        Offset = Vector2.new(1, 0)
    }):Play();
end;

local function BindHover(p19: userdata, p20: number) -- Line: 101
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy)
    local Holder = p19.Holder;
    local v21, v22;

    if p20 <= 3 then
        v21 = function() -- Line: 107
            -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref)
            TweenService:Create(Holder, TweenInfo_new_ret, {
                BackgroundTransparency = 0.7
            }):Play();
            TweenService:Create(Holder.UIStroke, TweenInfo_new_ret, {
                Transparency = 0.15
            }):Play();
        end;

        v22 = function() -- Line: 112
            -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref)
            TweenService:Create(Holder, TweenInfo_new_ret, {
                BackgroundTransparency = 0.78
            }):Play();
            TweenService:Create(Holder.UIStroke, TweenInfo_new_ret, {
                Transparency = 0.5
            }):Play();
        end;
    else
        local BackgroundTransparency = Holder.BackgroundTransparency;

        v21 = function() -- Line: 119
            -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref)
            TweenService:Create(Holder, TweenInfo_new_ret, {
                BackgroundTransparency = 0.9
            }):Play();
        end;

        v22 = function() -- Line: 123
            -- upvalues: TweenService (ref), Holder (copy), TweenInfo_new_ret (ref), BackgroundTransparency (copy)
            TweenService:Create(Holder, TweenInfo_new_ret, {
                BackgroundTransparency = BackgroundTransparency
            }):Play();
        end;
    end;

    p19.MouseEnter:Connect(v21);
    p19.MouseLeave:Connect(v22);
    p19.SelectionGained:Connect(v21);
    p19.SelectionLost:Connect(v22);
end;

local function DrawRow(p23: any, p24: any, p25: number) -- Line: 134
    -- upvalues: u4 (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy)
    local Holder = p23.Holder;
    p23.Empty = p24 == nil;

    if p25 > 3 then
        p23.Frame.Visible = p24 ~= nil;
    else
        local v26 = p24 and u4[p25] or Color3_fromRGB_ret2;
        Holder.BackgroundColor3 = v26;
        Holder.UIStroke.Color = v26;
        Holder.Avatar.Vacant.Visible = p24 == nil;
    end;

    if not p24 then
        Holder.Avatar.Image = "";
        Holder.PlayerName.Text = "Unclaimed";
        Holder.PlayerName.TextColor3 = Color3_fromRGB_ret3;
        Holder.Amount.Text = "";

        return;
    end;

    Holder.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={p24.UserId}&w=150&h=150`;
    Holder.PlayerName.Text = p24.Name;
    Holder.PlayerName.TextColor3 = p24.UserId == LocalPlayer.UserId and Color3_fromRGB_ret or Color3.new(1, 1, 1);
    local Amount = Holder.Amount;
    local math_floor_ret = math.floor(p24.Value);
    Amount.Text = tostring(math_floor_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

function u1.Draw() -- Line: 166
    -- upvalues: ReplicatedStorage (copy), HttpService (copy), u2 (copy), DrawRow (copy)
    local Attribute = ReplicatedStorage:GetAttribute("Leaderboards");
    local v27 = Attribute and HttpService:JSONDecode(Attribute) or {};

    for _, v in u2 do
        local v28 = v27[v.Name] or {};
        local v29 = v;

        for i, v2 in v.Rows do
            DrawRow(v2, v28[i], i);
        end;

        v29.Empty.Frame.Visible = #v28 <= 3;
        v29.Empty.Holder.Title.Text = #v28 == 0 and "BE THE FIRST" or "NO ONE ELSE YET";
    end;
end;

function u1.Open() -- Line: 182
    -- upvalues: u2 (copy), FadeIn (copy), Shine (copy)
    for i, v in u2 do
        local v30 = (i - 1) * 0.06;
        v.List.CanvasPosition = Vector2.zero;
        local v31 = v;

        for i2 = 1, 12 do
            FadeIn(v31.Rows[i2], v30 + (i2 - 1) * 0.035);
            local _ = i2;
        end;

        for i2 = 1, 3 do
            local v32 = v31.Rows[i2];
            local v33;

            if v32.Empty then
                v33 = i2;
            else
                Shine(v32, v30 + 0.3 + (i2 - 1) * 0.12);
                v33 = i2;
            end;
        end;

        FadeIn(v31.Empty, v30 + 0.2);
    end;
end;

function u1.new(p34) -- Line: 206
    -- upvalues: u1 (copy), u3 (copy), BindHover (copy), CaptureFade (copy), u2 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Leaderboards";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.9;
    Frame.ClipsDescendants = true;
    Frame.Position = UDim2.fromScale(0.5, 0.0580001);
    Frame.Selectable = true;
    Frame.SelectionGroup = true;
    Frame.Size = UDim2.fromScale(1, 0.94);
    Frame.Visible = false;
    u1.title().Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Main";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.194361);
    Frame2.Size = UDim2.fromScale(0.761979, 0.745084);
    Frame2.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.Padding = UDim.new(0.015, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame2;

    for i, v in u3 do
        local v35 = u1.board(v);
        v35.LayoutOrder = i;
        v35.Parent = Frame2;
        local v36 = {};

        for i2 = 1, 50 do
            local v37 = i2 <= 3 and u1.topRow(i2) or u1.row(i2);
            v37.Parent = i2 <= 3 and v35.Top or v35.List;
            BindHover(v37, i2);
            v36[i2] = {
                Frame = v37,
                Holder = v37.Holder,
                Fades = CaptureFade(v37.Holder)
            };
            local _ = i2;
        end;

        local v38 = {
            Name = v.Name,
            List = v35.List,
            Rows = v36,
            Empty = {
                Frame = v35.Empty,
                Holder = v35.Empty.Holder,
                Fades = CaptureFade(v35.Empty.Holder)
            }
        };
        table.insert(u2, v38);
    end;

    Frame.Parent = p34;

    return Frame;
end;

function u1.title() -- Line: 274
    local Frame = Instance.new("Frame");
    Frame.Name = "Title";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.474851, 0.03);
    Frame.Size = UDim2.fromScale(0.74, 0.14);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0, 1);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0, 1);
    Frame2.Size = UDim2.new(1, 0, 0, 1);
    Frame2.Parent = Frame;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.754098), NumberSequenceKeypoint.new(0.501594, 0.759563), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.0883739, 0.139896);
    TextLabel.Size = UDim2.fromScale(0.3, 0.493098);
    TextLabel.Text = "Leaderboards";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Article";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.0883738, 0.632994);
    TextLabel2.Size = UDim2.fromScale(0.35, 0.221515);
    TextLabel2.Text = "Top 50 players across all servers";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.25;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 10.6;
    UIAspectRatioConstraint.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://77326007502614";
    ImageLabel.Position = UDim2.fromScale(0, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.9, 0.9);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame;

    return Frame;
end;

function u1.board(p39) -- Line: 350
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = p39.Name;
    Frame.BackgroundColor3 = Color3.fromRGB(39, 39, 39);
    Frame.BackgroundTransparency = 0.4;
    Frame.Size = UDim2.fromScale(0.323, 1);
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(184, 184, 184);
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.02, 0);
    UICorner.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Header";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.025);
    Frame2.Size = UDim2.fromScale(0.92, 0.08);
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Thumbnail";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.8;
    Frame3.Position = UDim2.fromScale(0, 0.5);
    Frame3.Size = UDim2.fromScale(1, 1);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame3.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame3;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Color = Color3.new(1, 1, 1);
    UIStroke2.Thickness = 1.5;
    UIStroke2.Transparency = 0.8;
    UIStroke2.Parent = Frame3;
    u1.icon(p39, 0).Parent = Frame3;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.2, 0.02);
    TextLabel.Size = UDim2.fromScale(0.8, 0.55);
    TextLabel.Text = p39.Title;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Article";
    TextLabel2.AnchorPoint = Vector2.new(0, 1);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.2, 0.98);
    TextLabel2.Size = UDim2.fromScale(0.8, 0.3);
    TextLabel2.Text = "TOP 50 PLAYERS";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.5;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Top";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 0.135);
    Frame4.Size = UDim2.fromScale(0.92, 0.3);
    Frame4.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Padding = UDim.new(0.035, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Line";
    Frame5.AnchorPoint = Vector2.new(0.5, 0);
    Frame5.BackgroundColor3 = Color3.fromRGB(184, 184, 184);
    Frame5.BackgroundTransparency = 0.5;
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(0.5, 0.46);
    Frame5.Size = UDim2.new(0.92, 0, 0, 1);
    Frame5.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "List";
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.Position = UDim2.fromScale(0.5, 0.475);
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(184, 184, 184);
    ScrollingFrame.ScrollBarImageTransparency = 0.5;
    ScrollingFrame.ScrollBarThickness = 3;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.Selectable = false;
    ScrollingFrame.Size = UDim2.fromScale(0.94, 0.505);
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    ScrollingFrame.Parent = Frame;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.CellPadding = UDim2.fromOffset(0, 3);
    UIGridLayout.CellSize = UDim2.fromScale(1, 0.115);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = ScrollingFrame;
    u1.empty(p39).Parent = Frame;

    return Frame;
end;

function u1.icon(p40: any, p41: number) -- Line: 479
    local v42;

    if p40.Glyph then
        v42 = Instance.new("TextLabel");
        v42.Text = p40.Glyph;
        v42.TextColor3 = Color3.fromRGB(232, 232, 232);
        v42.TextScaled = true;
        v42.TextTransparency = p41;
    else
        v42 = Instance.new("ImageLabel");
        v42.Image = p40.Icon;
        v42.ImageColor3 = Color3.fromRGB(232, 232, 232);
        v42.ImageTransparency = p41;
        v42.ScaleType = Enum.ScaleType.Fit;
    end;

    v42.Name = "Icon";
    v42.AnchorPoint = Vector2.new(0.5, 0.5);
    v42.BackgroundTransparency = 1;
    v42.Position = UDim2.fromScale(0.5, 0.5);
    v42.Size = UDim2.fromScale(0.6, 0.6);

    return v42;
end;

function u1.empty(p43) -- Line: 505
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Empty";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.475);
    Frame.Size = UDim2.fromScale(0.94, 0.505);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Holder";
    Frame2.BackgroundTransparency = 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Thumbnail";
    Frame3.AnchorPoint = Vector2.new(0.5, 1);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.8;
    Frame3.Position = UDim2.fromScale(0.5, 0.46);
    Frame3.Size = UDim2.fromScale(0.24, 0.24);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame3.Parent = Frame2;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame3;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.85;
    UIStroke.Parent = Frame3;
    u1.icon(p43, 0.5).Parent = Frame3;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel.Position = UDim2.fromScale(0.5, 0.52);
    TextLabel.Size = UDim2.fromScale(0.9, 0.09);
    TextLabel.Text = "BE THE FIRST";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.2;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Hint";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.635);
    TextLabel2.Size = UDim2.fromScale(0.8, 0.065);
    TextLabel2.Text = p43.Hint;
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.5;
    TextLabel2.Parent = Frame2;

    return Frame;
end;

function u1.topRow(p44: number) -- Line: 575
    -- upvalues: u4 (copy), Color3_fromRGB_ret3 (copy), u5 (copy)
    local v45 = u4[p44];
    local Frame = Instance.new("Frame");
    Frame:SetAttribute("Select", true);
    Frame.Name = tostring(p44);
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p44;
    Frame.Size = UDim2.fromScale(1, 0.31);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Holder";
    Frame2.BackgroundColor3 = v45;
    Frame2.BackgroundTransparency = 0.78;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.18, 0);
    UICorner.Parent = Frame2;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = v45;
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame2;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.85) });
    UIGradient.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Badge";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.Position = UDim2.fromScale(0.035, 0.5);
    Frame3.Size = UDim2.fromScale(0.5, 0.5);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame3.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame3;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Color = ColorSequence.new(v45:Lerp(Color3.new(1, 1, 1), 0.45), v45);
    UIGradient2.Rotation = 90;
    UIGradient2.Parent = Frame3;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Rank";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(0.62, 0.62);
    TextLabel.Text = tostring(p44);
    TextLabel.TextColor3 = Color3.fromRGB(30, 30, 32);
    TextLabel.TextScaled = true;
    TextLabel.Parent = Frame3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Avatar";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(59, 59, 59);
    ImageLabel.Image = "";
    ImageLabel.Position = UDim2.fromScale(0.14, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.72, 0.72);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(1, 0);
    UICorner3.Parent = ImageLabel;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Color = v45;
    UIStroke2.Thickness = 1.5;
    UIStroke2.Transparency = 0.2;
    UIStroke2.Parent = ImageLabel;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Vacant";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Text = "?";
    TextLabel2.TextColor3 = Color3_fromRGB_ret3;
    TextLabel2.TextScaled = true;
    TextLabel2.Visible = false;
    TextLabel2.Parent = ImageLabel;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "PlayerName";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.3, 0.18);
    TextLabel3.Size = UDim2.fromScale(0.4, 0.36);
    TextLabel3.Text = "—";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = Frame2;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Place";
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.3, 0.58);
    TextLabel4.Size = UDim2.fromScale(0.4, 0.24);
    TextLabel4.Text = u5[p44];
    TextLabel4.TextColor3 = v45;
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.15;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.Parent = Frame2;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Amount";
    TextLabel5.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.955, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.27, 0.36);
    TextLabel5.Text = "—";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel5.Parent = Frame2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Shine";
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.Size = UDim2.fromScale(1, 1);
    Frame4.ZIndex = 2;
    Frame4.Parent = Frame2;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.CornerRadius = UDim.new(0.18, 0);
    UICorner4.Parent = Frame4;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Offset = Vector2.new(-1, 0);
    UIGradient3.Rotation = 20;
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 1),
        NumberSequenceKeypoint.new(0.5, 0.82),
        NumberSequenceKeypoint.new(0.6, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = Frame4;

    return Frame;
end;

function u1.row(p46: number) -- Line: 755
    local Frame = Instance.new("Frame");
    Frame:SetAttribute("Select", true);
    Frame.Name = tostring(p46);
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p46;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Holder";
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = p46 % 2 == 0 and 0.96 or 1;
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0.2, 0);
    UICorner.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Rank";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.02, 0.5);
    TextLabel.Size = UDim2.fromScale(0.09, 0.4);
    TextLabel.Text = tostring(p46);
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.4;
    TextLabel.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Avatar";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(59, 59, 59);
    ImageLabel.Image = "";
    ImageLabel.Position = UDim2.fromScale(0.13, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.66, 0.66);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Parent = Frame2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = ImageLabel;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "PlayerName";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.235, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.46, 0.38);
    TextLabel2.Text = "—";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame2;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Amount";
    TextLabel3.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.965, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.26, 0.38);
    TextLabel3.Text = "—";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.1;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel3.Parent = Frame2;

    return Frame;
end;

return u1;