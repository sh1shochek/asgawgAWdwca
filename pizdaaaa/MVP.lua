-- ReplicatedStorage.GameClient.Gui.HUD.MVP
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.MVP
-- Decompile time: 14.03 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local LocalPlayer = Players.LocalPlayer;
local _ = ReplicatedStorage.GameStats;
local LocalPlayer2 = Players.LocalPlayer;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
TweenInfo.new(0.2);
local u12 = {
    CT = Color3.fromRGB(184, 214, 239),
    T = Color3.fromRGB(234, 210, 139),
    Spectator = Color3.fromRGB(255, 255, 255)
};
local u13 = {};
local u14 = {};
local u15 = {};

function u1.Burst(p16: userdata, p17) -- Line: 53
    -- upvalues: u13 (copy), u15 (copy), TweenService (copy)
    for _, v in u13 do
        v.BackgroundTransparency = 0;
        v.BackgroundColor3 = p17;

        if math.random(1, 2) == 1 then
            v.Size = UDim2.fromScale(math.random() * 0.08, math.random() * 0.3);
        else
            v.Size = UDim2.fromScale(math.random() * 0.05, math.random() * 0.05);
            local UICorner = Instance.new("UICorner");
            UICorner.CornerRadius = UDim.new(1, 0);
            UICorner.Parent = v;
            table.insert(u15, UICorner);
        end;

        v.Position = UDim2.fromScale(math.random(), math.random());
        v.Parent = p16;
        TweenService:Create(v, TweenInfo.new(1), {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(math.random(), math.random()),
            Size = UDim2.new(v.Size.X.Scale * 0.5, v.Size.X.Offset * 0.5, v.Size.Y.Scale * 0.5, v.Size.Y.Offset * 0.5)
        }):Play();
    end;
end;

function u1.SetColor(p18) -- Line: 80
    -- upvalues: u9 (ref), u10 (ref)
    u9.Article.TextColor3 = p18;
    u9.PineTree1.TextColor3 = p18;
    u9.PineTree2.TextColor3 = p18;
    u9.ColorBackground.GroupColor3 = p18;
    u10.Note.BackgroundColor3 = p18;
    u10.PlayerName.TextColor3 = p18;
    u10.Background.GroupColor3 = p18;
    u10.Background.Frame.Frame.BackgroundColor3 = p18;
end;

function u1.Cleaning() -- Line: 92
    -- upvalues: u9 (ref)
    u9.PineTree1.Position = UDim2.fromScale(0, 0.5);
    u9.PineTree2.Position = UDim2.fromScale(1, 0.5);
    u9.Flash.BackgroundTransparency = 0;
end;

function u1.SetWon(u19: string, p20: string) -- Line: 98
    -- upvalues: u8 (ref), u12 (copy), LocalPlayer (copy), u1 (copy), u9 (ref), u14 (copy), TweenService (copy), u11 (ref), u10 (ref), u15 (copy)
    u8.Visible = true;
    local u21 = u12[LocalPlayer:GetAttribute("Team")];

    if u19 == "WON" then
        u1.SetColor(u21);
        u9.Article.Text = "ROUND WON";
    elseif u19 == "LOSS" then
        u1.SetColor(Color3.fromRGB(250, 60, 45));
        u9.Article.Text = "ROUND LOSS";
    end;

    if p20 ~= nil then
        task.spawn(function() -- Line: 117
            -- upvalues: u8 (ref), u14 (ref), TweenService (ref)
            while task.wait(0.8) and u8.Visible do
                for _, v in u14 do
                    if v:IsA("Frame") then
                        TweenService:Create(v, TweenInfo.new(0.5), {
                            BackgroundTransparency = 0.5 + math.random()
                        }):Play();
                    end;
                end;
            end;
        end);
    end;

    TweenService:Create(u9, TweenInfo.new(0.15), {
        Size = UDim2.fromScale(1, 1)
    }):Play();
    u11:Delay(0.15, function() -- Line: 138
        -- upvalues: TweenService (ref), u9 (ref), u19 (copy), u1 (ref), u21 (copy)
        TweenService:Create(u9.Flash, TweenInfo.new(0.35), {
            BackgroundTransparency = 1
        }):Play();

        if u19 == "WON" then
            u1.Burst(u9, u21);
        elseif u19 == "LOSS" then
            u1.Burst(u9, Color3.fromRGB(250, 60, 45));
        end;

        TweenService:Create(u9.PineTree1, TweenInfo.new(0.55), {
            Position = UDim2.fromScale(0.05, 0.5)
        }):Play();
        TweenService:Create(u9.PineTree2, TweenInfo.new(0.55), {
            Position = UDim2.fromScale(0.95, 0.5)
        }):Play();
    end);

    if p20 ~= nil then
        u11:Delay(1, function() -- Line: 156
            -- upvalues: TweenService (ref), u9 (ref), u10 (ref)
            TweenService:Create(u9.Note, TweenInfo.new(0.35), {
                TextTransparency = 0
            }):Play();
            TweenService:Create(u10, TweenInfo.new(0.35), {
                Size = UDim2.fromScale(1.5, 1)
            }):Play();
        end);
    end;

    u11:Delay(8, function() -- Line: 162
        -- upvalues: TweenService (ref), u10 (ref), u9 (ref), u11 (ref), u8 (ref), u15 (ref), u1 (ref)
        TweenService:Create(u10, TweenInfo.new(0.2), {
            Size = UDim2.fromScale(0, 1)
        }):Play();
        TweenService:Create(u9, TweenInfo.new(0.2), {
            Size = UDim2.fromScale(0, 1)
        }):Play();
        u11:Delay(0.2, function() -- Line: 168
            -- upvalues: u8 (ref), u15 (ref), u1 (ref)
            u8.Visible = false;

            for _, v in u15 do
                v:Destroy();
            end;

            table.clear(u15);
            u1.Cleaning();
        end);
    end);
end;

function u1.UpdatePin(p22, p23) -- Line: 182
    -- upvalues: HttpService (copy), u6 (ref)
    local Attribute = p22:GetAttribute("WeaponLoadout");

    if not Attribute then
        return;
    end;

    local v24 = HttpService:JSONDecode(Attribute).CT["19"];

    if v24 then
        v24 = v24.SkinName;
    end;

    if v24 == "None" then
        p23.Pin.Visible = false;

        return;
    end;

    local Item = u6.GetItem("Badges", v24);
    p23.Pin.Image = Item.Asset;
    p23.Pin.Visible = true;
end;

function u1.Init(p25) -- Line: 204
    -- upvalues: u2 (ref), u3 (ref), u11 (ref), u7 (ref), u5 (ref), u6 (ref)
    u2 = p25:GetModule("Gui");
    u3 = p25:GetModule("Maid").new();
    u11 = p25:GetModule("Threads");
    u7 = p25:GetModule("Network");
    u5 = p25:GetModule("Enums");
    u6 = p25:GetModule("ItemManager");
end;

function u1.Start(p26) -- Line: 213
    -- upvalues: u8 (ref), u1 (copy), u9 (ref), u10 (ref), u13 (copy), LocalPlayer2 (copy), u4 (ref), u7 (ref), Players (copy), u5 (ref)
    u8 = u1.new();
    u9 = u8.MainFrame;
    u10 = u8.DownFrame;

    for i = 1, 100 do
        local Frame = Instance.new("Frame");
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Frame.BorderSizePixel = 0;
        Frame.ZIndex = 10;
        table.insert(u13, Frame);
        local _ = i;
    end;

    LocalPlayer2:GetAttributeChangedSignal("Team"):Connect(function() -- Line: 231
        -- upvalues: u4 (ref), LocalPlayer2 (ref)
        u4 = LocalPlayer2:GetAttribute("Team");
    end);
    u7.Gui.MVPUpdate.On(function(p27) -- Line: 235
        -- upvalues: u9 (ref), Players (ref), u5 (ref), u10 (ref), u1 (ref), u4 (ref)
        u9.Note.Text = p27.FunFact;
        local v28;

        if p27.MVPUserid then
            local PlayerByUserId = Players:GetPlayerByUserId(p27.MVPUserid);
            local v29 = PlayerByUserId and (PlayerByUserId.Name or "Unknown") or "Unknown";
            u10.Note.Text = string.format(u5.MVPReasons[p27.MVPReason] or "MVP: %s", v29);
            u10.Icon.Image = `rbxthumb://type=AvatarHeadShot&id={p27.MVPUserid}&w=420&h=420`;
            u10.PlayerName.Text = v29;

            if PlayerByUserId then
                u1.UpdatePin(PlayerByUserId, u10.Icon);
                v28 = true;
            else
                v28 = true;
            end;
        else
            v28 = false;
        end;

        if u5.Teams[p27.WinningTeam] == u4 then
            u1.SetWon("WON", v28);

            return;
        end;

        u1.SetWon("LOSS", v28);
    end);
end;

function u1.new() -- Line: 269
    -- upvalues: u14 (copy), u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "TeamWon";
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.5, 0.15);
    Frame.Size = UDim2.fromScale(0.3, 0.1);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "DownFrame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 1.2);
    Frame2.Size = UDim2.fromScale(0, 1);
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "Background";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 1);
    CanvasGroup.AutoLocalize = false;
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, 1);
    CanvasGroup.Size = UDim2.fromScale(1, 1);
    CanvasGroup.ZIndex = 0;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0);
    Frame3.AutoLocalize = false;
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.5, 0);
    Frame3.Size = UDim2.fromScale(0.98, 1);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(0.5, 0);
    Frame4.AutoLocalize = false;
    Frame4.BackgroundColor3 = Color3.fromRGB(255, 203, 107);
    Frame4.BackgroundTransparency = 0.65;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.5, 0);
    Frame4.Size = UDim2.fromScale(0.98, 1);
    Frame4.Parent = Frame3;
    Frame3.Parent = CanvasGroup;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.025, 1),
        NumberSequenceKeypoint.new(0.15, 0.25),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.85, 0.25),
        NumberSequenceKeypoint.new(0.975, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = CanvasGroup;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Cubes";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.AutoLocalize = false;
    Frame5.BackgroundTransparency = 1;
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.fromScale(0.98, 1);
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(0.005, 0.035);
    UIGridLayout.CellSize = UDim2.fromScale(0.1, 0.2);
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.Parent = UIGridLayout;
    UIGridLayout.Parent = Frame5;

    for i = 1, 150 do
        local Frame6 = Instance.new("Frame");
        Frame6.Name = "Frame";
        Frame6.AutoLocalize = false;
        Frame6.BackgroundTransparency = 0.6 + math.random();
        Frame6.Size = UDim2.fromOffset(100, 100);
        Frame6.Parent = Frame5;
        table.insert(u14, Frame6);
        local _ = i;
    end;

    Frame5.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://18333524065";
    ImageLabel.ImageColor3 = Color3.fromRGB(255, 203, 107);
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel.Visible = false;
    ImageLabel.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame2;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Icon";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxthumb://type=AvatarHeadShot&id=2994385561&w=420&h=420";
    ImageButton.Position = UDim2.fromScale(0.2, 0.5);
    ImageButton.Size = UDim2.fromScale(0.8, 0.8);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.ZIndex = 2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Pin";
    ImageLabel2.AnchorPoint = Vector2.new(1, 1);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://100429874437897";
    ImageLabel2.Position = UDim2.fromScale(1, 1);
    ImageLabel2.Size = UDim2.fromScale(0.35, 0.35);
    ImageLabel2.Parent = ImageButton;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint2.Parent = ImageButton;
    ImageButton.Parent = Frame2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Note";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel.BorderColor3 = Color3.fromRGB(27, 42, 53);
    TextLabel.BorderSizePixel = 0;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.325, 0.35);
    TextLabel.Size = UDim2.fromScale(0.5, 0.25);
    TextLabel.Text = "MVP: WhyNotMyUsername for most kills";
    TextLabel.TextColor3 = Color3.new();
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 9;
    local UIAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint3.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint3.AspectRatio = 15;
    UIAspectRatioConstraint3.Parent = TextLabel;
    TextLabel.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "PlayerName";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    TextLabel2.Position = UDim2.fromScale(0.325, 0.7);
    TextLabel2.Size = UDim2.fromScale(0.5, 0.3);
    TextLabel2.Text = "WhyNotMyUsername";
    TextLabel2.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.ZIndex = 9;
    local UIAspectRatioConstraint4 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint4.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint4.AspectRatio = 15;
    UIAspectRatioConstraint4.Parent = TextLabel2;
    TextLabel2.Parent = Frame2;
    Frame2.Parent = Frame;
    local UIAspectRatioConstraint5 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint5.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint5.AspectRatio = 5;
    UIAspectRatioConstraint5.Parent = Frame;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "MainFrame";
    Frame6.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame6.AutoLocalize = false;
    Frame6.BackgroundColor3 = Color3.new();
    Frame6.BackgroundTransparency = 0.4;
    Frame6.Position = UDim2.fromScale(0.5, 0.5);
    Frame6.Size = UDim2.fromScale(0, 1);
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Article";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.LineHeight = 0.31;
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel3.RichText = true;
    TextLabel3.Size = UDim2.fromScale(0.75, 0.9);
    TextLabel3.Text = "ROUND WON";
    TextLabel3.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTruncate = Enum.TextTruncate.SplitWord;
    TextLabel3.ZIndex = 9;
    TextLabel3.Parent = Frame6;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Note";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 1);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.new(0.5, 0, 1, -2);
    TextLabel4.Size = UDim2.fromScale(1, 0.2);
    TextLabel4.Text = "Player WhyNotMyUsername killed 5 enemies";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextTransparency = 1;
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame6;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "PineTree1";
    TextLabel5.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.065, 1);
    TextLabel5.Text = "»";
    TextLabel5.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel5.TextScaled = true;
    TextLabel5.ZIndex = 9;
    TextLabel5.Parent = Frame6;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "PineTree2";
    TextLabel6.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(1, 0.5);
    TextLabel6.Size = UDim2.fromScale(0.065, 1);
    TextLabel6.Text = "«";
    TextLabel6.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel6.TextScaled = true;
    TextLabel6.ZIndex = 9;
    TextLabel6.Parent = Frame6;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Flash";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.AutoLocalize = false;
    Frame7.BackgroundTransparency = 0;
    Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame7.Position = UDim2.fromScale(0.5, 0.5);
    Frame7.Size = UDim2.fromScale(1, 1);
    Frame7.ZIndex = 10;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.025, 0);
    UICorner.Parent = Frame7;
    Frame7.Parent = Frame6;
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "ColorBackground";
    CanvasGroup2.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup2.AutoLocalize = false;
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.GroupColor3 = Color3.fromRGB(255, 203, 107);
    CanvasGroup2.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup2.Size = UDim2.fromScale(2, 2);
    CanvasGroup2.ZIndex = 0;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Main";
    Frame8.AnchorPoint = Vector2.new(0, 0.5);
    Frame8.AutoLocalize = false;
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.fromScale(0, 0.5);
    Frame8.Size = UDim2.fromScale(1, 0.5);
    Frame8.ZIndex = -1;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Frame";
    Frame9.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame9.AutoLocalize = false;
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0.5, 0.5);
    Frame9.Size = UDim2.fromScale(0.5, 1);
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Left";
    Frame10.AnchorPoint = Vector2.new(1, 0);
    Frame10.AutoLocalize = false;
    Frame10.BackgroundTransparency = 1;
    Frame10.ClipsDescendants = true;
    Frame10.Size = UDim2.fromScale(0.1, 1);
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Color";
    Frame11.AutoLocalize = false;
    Frame11.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame11.ClipsDescendants = true;
    Frame11.Position = UDim2.fromScale(0.9, 0);
    Frame11.Size = UDim2.fromScale(10, 1);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = Frame11;
    Frame11.Parent = Frame10;
    Frame10.Parent = Frame9;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Right";
    Frame12.AutoLocalize = false;
    Frame12.BackgroundTransparency = 1;
    Frame12.ClipsDescendants = true;
    Frame12.Position = UDim2.fromScale(1, 0);
    Frame12.Size = UDim2.fromScale(0.1, 1);
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Color";
    Frame13.AnchorPoint = Vector2.new(1, 0);
    Frame13.AutoLocalize = false;
    Frame13.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame13.ClipsDescendants = true;
    Frame13.Position = UDim2.fromScale(0.1, 0);
    Frame13.Size = UDim2.fromScale(10, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.Parent = Frame13;
    Frame13.Parent = Frame12;
    Frame12.Parent = Frame9;
    Frame9.Parent = Frame8;
    Frame8.Parent = CanvasGroup2;
    CanvasGroup2.Parent = Frame6;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.025, 0);
    UICorner4.Parent = Frame6;
    Frame6.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

return u1;