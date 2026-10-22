-- ReplicatedStorage.GameClient.Gui.HUD.Vote
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Vote
-- Decompile time: 13.12 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local HttpService = game:GetService("HttpService");
local ContextActionService = game:GetService("ContextActionService");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = 0;
local u11 = 0;
local Votekick = ReplicatedStorage.Votekick;
local _ = Players.LocalPlayer;
local _ = ReplicatedStorage.GameStats;
TweenInfo.new(0.1);
local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
Color3.fromRGB(184, 214, 239);
Color3.fromRGB(234, 210, 139);

function u1.Init(p12) -- Line: 53
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref)
    u2 = p12:GetModule("Gui");
    u3 = p12:GetModule("Maid").new();
    u5 = p12:GetModule("Network");
    u6 = p12:GetModule("SoundManager");
    u7 = p12:GetModule("GetUserPlatform");
end;

local function Pop(p13: userdata) -- Line: 61
    -- upvalues: TweenService (copy), TweenInfo_new_ret2 (copy)
    p13.UIScale.Scale = 1.25;
    TweenService:Create(p13.UIScale, TweenInfo_new_ret2, {
        Scale = 1
    }):Play();
end;

local function UpdateVoteSounds() -- Line: 66
    -- upvalues: u9 (ref), Votekick (copy), u10 (ref), u6 (ref), u11 (ref)
    if not u9 then
        return;
    end;

    local v14 = Votekick:GetAttribute("Yes") or 0;
    local v15 = Votekick:GetAttribute("No") or 0;

    if u10 < v14 then
        u6.Play("Vote.Cast.Yes");
    end;

    if u11 < v15 then
        u6.Play("Vote.Cast.No");
    end;

    u10 = v14;
    u11 = v15;
end;

local function Cast(p16, p17, p18) -- Line: 78
    -- upvalues: u8 (ref), u5 (ref), ContextActionService (copy)
    if p17 ~= Enum.UserInputState.Begin or u8.Navigating() then
        return Enum.ContextActionResult.Pass;
    end;

    u5.Gui.Votekick.Fire(p18.KeyCode == Enum.KeyCode.DPadLeft);
    ContextActionService:UnbindAction("Votekick");

    return Enum.ContextActionResult.Sink;
end;

function u1.Start(p19) -- Line: 89
    -- upvalues: u8 (ref), u2 (ref), u4 (ref), u1 (copy), Votekick (copy), u9 (ref), u6 (ref), ContextActionService (copy), TweenService (copy), u3 (ref), HttpService (copy), u10 (ref), u11 (ref), UpdateVoteSounds (copy), Players (copy), u7 (ref), TweenInfo_new_ret (copy), Cast (copy), UserInputService (copy), u5 (ref), TweenInfo_new_ret2 (copy)
    u8 = u2.GetComponent("Gamepad");
    u4 = u1.new();
    Votekick:GetAttributeChangedSignal("Event"):Connect(function(p20) -- Line: 93
        -- upvalues: Votekick (ref), u9 (ref), u6 (ref), ContextActionService (ref), TweenService (ref), u4 (ref), u3 (ref), HttpService (ref), u10 (ref), u11 (ref), UpdateVoteSounds (ref), Players (ref), u7 (ref), TweenInfo_new_ret (ref), Cast (ref), UserInputService (ref), u5 (ref)
        local Attribute = Votekick:GetAttribute("Event");
        local v21 = nil;

        if Attribute == nil then
            if u9 then
                u6.Play(Votekick:GetAttribute("Outcome") == "Passed" and "Vote.Passed" or "Vote.Failed");
                u9 = false;
            end;

            ContextActionService:UnbindAction("Votekick");
            TweenService:Create(u4, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = UDim2.fromScale(-0.15, 0.5)
            }):Play();
            task.delay(0.5, function() -- Line: 105
                -- upvalues: u4 (ref), u3 (ref)
                u4.Visible = false;
                u3:Cleanup();
            end);

            return;
        end;

        if Attribute ~= nil then
            v21 = HttpService:JSONDecode(Attribute);
            u9 = true;
            u10 = 0;
            u11 = 0;
            u6.Play("Vote.Created");
            UpdateVoteSounds();
        end;

        local PlayerByUserId = Players:GetPlayerByUserId(v21.ToKick);
        local PlayerByUserId2 = Players:GetPlayerByUserId(v21.KickBy);
        u4.KickPlayer.Text = "Kick player: " .. (PlayerByUserId and PlayerByUserId.Name or Players:GetNameFromUserIdAsync(v21.ToKick)) .. "?";
        u4.Top.Icon.VoteBy.Text = "Vote by: " .. (PlayerByUserId2 and PlayerByUserId2.Name or Players:GetNameFromUserIdAsync(v21.KickBy));
        u4.Reason.Text = `Reason: {v21.Reason}`;
        local v22 = u7() == "Console";
        u4.YesTitle.Text = v22 and "D-Pad Left for YES" or "F1 for YES";
        u4.NoTitle.Text = v22 and "D-Pad Right for NO" or "F2 for NO";
        u4.Visible = true;
        TweenService:Create(u4, TweenInfo_new_ret, {
            Position = UDim2.fromScale(0.01, 0.5)
        }):Play();
        ContextActionService:BindActionAtPriority("Votekick", Cast, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight);
        u3:Add("Inputs", UserInputService.InputBegan:Connect(function(p23, p24) -- Line: 140
            -- upvalues: u5 (ref)
            if p24 then
                return;
            end;

            if p23.KeyCode == Enum.KeyCode.F1 then
                u5.Gui.Votekick.Fire(true);
            end;

            if p23.KeyCode == Enum.KeyCode.F2 then
                u5.Gui.Votekick.Fire(false);
            end;
        end));
    end);
    Votekick:GetAttributeChangedSignal("Yes"):Connect(function(p25) -- Line: 159
        -- upvalues: Votekick (ref), u4 (ref), TweenService (ref), TweenInfo_new_ret2 (ref)
        if Votekick:GetAttribute("Yes") then
            u4.Yes.Amount.Text = Votekick:GetAttribute("Yes");
            local Yes = u4.Yes;
            Yes.UIScale.Scale = 1.25;
            TweenService:Create(Yes.UIScale, TweenInfo_new_ret2, {
                Scale = 1
            }):Play();
        end;
    end);
    Votekick:GetAttributeChangedSignal("No"):Connect(function(p26) -- Line: 168
        -- upvalues: Votekick (ref), u4 (ref), TweenService (ref), TweenInfo_new_ret2 (ref)
        if Votekick:GetAttribute("No") then
            u4.No.Amount.Text = Votekick:GetAttribute("No");
            local No = u4.No;
            No.UIScale.Scale = 1.25;
            TweenService:Create(No.UIScale, TweenInfo_new_ret2, {
                Scale = 1
            }):Play();
        end;
    end);
    Votekick:GetAttributeChangedSignal("Yes"):Connect(UpdateVoteSounds);
    Votekick:GetAttributeChangedSignal("No"):Connect(UpdateVoteSounds);
end;

function u1.new() -- Line: 183
    -- upvalues: u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Votekick";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.BackgroundColor3 = Color3.new();
    Frame.BackgroundTransparency = 0.4;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(-0.15, 0.5);
    Frame.Size = UDim2.fromScale(0.15, 0.2);
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Top";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BackgroundTransparency = 0.75;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0);
    Frame2.Size = UDim2.fromScale(1, 0.3);
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91904010582471";
    ImageLabel.Position = UDim2.fromScale(0.05, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.7, 0.7);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "VoteBy";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1.2, 0.5);
    TextLabel.Size = UDim2.fromScale(4.49048, 0.85);
    TextLabel.Text = "Vote by: WhyNotMyUsername";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextTransparency = 0.25;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = ImageLabel;
    ImageLabel.Parent = Frame2;
    Frame2.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.3;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "KickPlayer";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.05, 0.45);
    TextLabel2.Size = UDim2.fromScale(0.6, 0.2);
    TextLabel2.Text = "Kick player: WhyNotMyUsername?";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.25;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Reason";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.05, 0.63);
    TextLabel3.Size = UDim2.fromScale(0.6, 0.12);
    TextLabel3.Text = "Reason: Cheating";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.25;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Yes";
    ImageLabel2.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://99157199431047";
    ImageLabel2.ImageColor3 = Color3.fromRGB(25, 128, 25);
    ImageLabel2.ImageTransparency = 0.1;
    ImageLabel2.Position = UDim2.fromScale(0.9, 0.42);
    ImageLabel2.Size = UDim2.fromScale(0.18, 0.18);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Amount";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(1, 0.5);
    TextLabel4.Size = UDim2.fromScale(0.5, 1);
    TextLabel4.Text = "0";
    TextLabel4.TextColor3 = Color3.fromRGB(25, 128, 25);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.1;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = ImageLabel2;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = ImageLabel2;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.15, 0);
    UICorner.BottomRightRadius = UDim.new(0.15, 0);
    UICorner.CornerRadius = UDim.new(0.15, 0);
    UICorner.TopLeftRadius = UDim.new(0.15, 0);
    UICorner.TopRightRadius = UDim.new(0.15, 0);
    UICorner.Parent = ImageLabel2;
    ImageLabel2.Parent = Frame;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "No";
    ImageLabel3.AnchorPoint = Vector2.new(1, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://102055170425759";
    ImageLabel3.ImageColor3 = Color3.fromRGB(254, 35, 35);
    ImageLabel3.ImageTransparency = 0.1;
    ImageLabel3.Position = UDim2.fromScale(0.9, 0.62);
    ImageLabel3.Size = UDim2.fromScale(0.18, 0.18);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Amount";
    TextLabel5.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(1, 0.5);
    TextLabel5.Size = UDim2.fromScale(0.5, 1);
    TextLabel5.Text = "0";
    TextLabel5.TextColor3 = Color3.fromRGB(254, 35, 35);
    TextLabel5.TextScaled = true;
    TextLabel5.TextTransparency = 0.1;
    TextLabel5.ZIndex = 9;
    TextLabel5.Parent = ImageLabel3;
    local UIScale2 = Instance.new("UIScale");
    UIScale2.Name = "UIScale";
    UIScale2.Parent = ImageLabel3;
    ImageLabel3.Parent = Frame;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "YesTitle";
    TextLabel6.AnchorPoint = Vector2.new(0, 1);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.05, 0.95);
    TextLabel6.RichText = true;
    TextLabel6.Size = UDim2.fromScale(0.5, 0.1);
    TextLabel6.Text = "F1 for YES";
    TextLabel6.TextColor3 = Color3.new(1, 1, 1);
    TextLabel6.TextScaled = true;
    TextLabel6.TextTransparency = 0.25;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.Parent = Frame;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "NoTitle";
    TextLabel7.AnchorPoint = Vector2.new(1, 1);
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.Position = UDim2.fromScale(0.95, 0.95);
    TextLabel7.RichText = true;
    TextLabel7.Size = UDim2.fromScale(0.5, 0.1);
    TextLabel7.Text = "F2 for NO";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 0.25;
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel7.Parent = Frame;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "DOTS";
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://91991932054752";
    ImageLabel4.ImageColor3 = Color3.new();
    ImageLabel4.ImageTransparency = 0.5;
    ImageLabel4.LayoutOrder = -1;
    ImageLabel4.ScaleType = Enum.ScaleType.Tile;
    ImageLabel4.Size = UDim2.fromScale(1, 1);
    ImageLabel4.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel4.ZIndex = -1;
    ImageLabel4.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

return u1;