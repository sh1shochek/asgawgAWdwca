-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.RobloxPlus
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.RobloxPlus
-- Decompile time: 15.48 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local MarketplaceService = game:GetService("MarketplaceService");
local PolicyService = game:GetService("PolicyService");
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
local u12 = true;
local u13 = false;
local TweenInfo_new_ret = TweenInfo.new(0.25);
local u14 = { "Distinguished Plus badge", "10% off everything you buy with Kredits", "Plus badge + 3 Fuser Scrolls on join" };

function u1.Locked() -- Line: 26
    -- upvalues: LocalPlayer (copy), u13 (ref), u12 (ref)
    return LocalPlayer.HasRobloxSubscription or (u13 or not u12);
end;

function u1.Refresh() -- Line: 30
    -- upvalues: u1 (copy), u11 (ref), LocalPlayer (copy), u13 (ref), u12 (ref), TweenService (copy), u10 (ref), TweenInfo_new_ret (copy)
    local v15 = u1.Locked();
    u11.Text = LocalPlayer.HasRobloxSubscription and "SUBSCRIBED" or (u13 and "PROCESSING..." or (u12 and "SUBSCRIBE" or "UNAVAILABLE"));
    TweenService:Create(u10.Frame, TweenInfo_new_ret, {
        BackgroundTransparency = v15 and 0.7 or 0.35
    }):Play();
    TweenService:Create(u11, TweenInfo_new_ret, {
        TextTransparency = v15 and 0.4 or 0
    }):Play();
end;

function u1.Draw() -- Line: 39
    -- upvalues: u3 (ref), u10 (ref), u1 (copy), u4 (ref), TweenService (copy), TweenInfo_new_ret (copy), MarketplaceService (copy), LocalPlayer (copy), u13 (ref), PolicyService (copy), u12 (ref)
    u3:Add("SubscribeEnter", u10.MouseEnter:Connect(function() -- Line: 40
        -- upvalues: u1 (ref), u4 (ref), TweenService (ref), u10 (ref), TweenInfo_new_ret (ref)
        if u1.Locked() then
            return;
        end;

        u4.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u10.Frame, TweenInfo_new_ret, {
            BackgroundTransparency = 0.15
        }):Play();
    end));
    u3:Add("SubscribeLeave", u10.MouseLeave:Connect(function() -- Line: 50
        -- upvalues: u1 (ref), TweenService (ref), u10 (ref), TweenInfo_new_ret (ref)
        if u1.Locked() then
            return;
        end;

        TweenService:Create(u10.Frame, TweenInfo_new_ret, {
            BackgroundTransparency = 0.35
        }):Play();
    end));
    u3:Add("SubscribeClick", u10.MouseButton1Click:Connect(function() -- Line: 58
        -- upvalues: u1 (ref), u4 (ref), MarketplaceService (ref), LocalPlayer (ref)
        if u1.Locked() then
            u4.Play("UI.lobby_error");

            return;
        end;

        u4.Play("UI.submenu_click");
        MarketplaceService:PromptRobloxSubscriptionPurchase(LocalPlayer);
    end));
    u3:Add("SubscribeFinished", MarketplaceService.PromptRobloxSubscriptionPurchaseFinished:Connect(function(p16, p17) -- Line: 68
        -- upvalues: LocalPlayer (ref), u13 (ref), u1 (ref)
        if p16 ~= LocalPlayer or not p17 then
            return;
        end;

        u13 = true;
        u1.Refresh();
    end));
    u3:Add("SubscriptionChanged", LocalPlayer:GetPropertyChangedSignal("HasRobloxSubscription"):Connect(function() -- Line: 77
        -- upvalues: u13 (ref), u1 (ref)
        u13 = false;
        u1.Refresh();
    end));
    u1.Refresh();
    task.spawn(function() -- Line: 84
        -- upvalues: PolicyService (ref), LocalPlayer (ref), u12 (ref), u1 (ref)
        local success, result = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer);
        u12 = not success or result.IsEligibleToPurchaseSubscription;
        u1.Refresh();
    end);
end;

function u1.Init(p18) -- Line: 92
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref)
    u2 = p18:GetModule("Gui");
    u3 = p18:GetModule("Maid").new();
    u4 = p18:GetModule("SoundManager");
    u5 = p18:GetModule("ItemManager");
end;

function u1.Start2(p19) -- Line: 99
    -- upvalues: u7 (ref), u2 (ref), u6 (ref), u8 (ref), u1 (copy)
    task.defer(function() -- Line: 100
        -- upvalues: u7 (ref), u2 (ref), u6 (ref), u8 (ref), u1 (ref)
        u7 = u2.GetComponent("Store");
        u6 = u2.GetComponent("Rewards");
        u8 = u6.Tabs:CreatePage("Roblox Plus", 6, false, false);
        u7.StyleKreditsTab(u6.Tabs.Pages["Roblox Plus"].Button);
        u1.new();
        u1.Draw();
    end);
end;

function u1.new() -- Line: 113
    -- upvalues: u9 (ref), u5 (ref), u14 (copy), u10 (ref), u11 (ref), u8 (ref)
    u9 = Instance.new("Frame");
    u9.Name = "Main";
    u9.AnchorPoint = Vector2.new(0.5, 0.5);
    u9.BackgroundColor3 = Color3.fromRGB(108, 108, 108);
    u9.BackgroundTransparency = 0.95;
    u9.Position = UDim2.fromScale(0.5, 0.5);
    u9.Size = UDim2.fromScale(0.5, 0.56);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 4);
    UICorner.Parent = u9;
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
    UIStroke.Parent = u9;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.8;
    UIAspectRatioConstraint.Parent = u9;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "DOTS";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://91991932054752";
    ImageLabel.ImageColor3 = Color3.fromRGB(140, 140, 140);
    ImageLabel.ImageTransparency = 0.5;
    ImageLabel.LayoutOrder = -1;
    ImageLabel.ScaleType = Enum.ScaleType.Tile;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.TileSize = UDim2.fromOffset(512, 512);
    ImageLabel.ZIndex = -1;
    ImageLabel.Parent = u9;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Badge";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = u5.GetItem("Badges", "Golden Plus").Asset;
    ImageLabel2.Position = UDim2.fromScale(0.19, 0.43);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = u9;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "BadgeName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.19, 0.79);
    TextLabel.Size = UDim2.fromScale(0.3, 0.065);
    TextLabel.Text = "DISTINGUISHED PLUS";
    TextLabel.TextColor3 = Color3.fromRGB(255, 223, 149);
    TextLabel.TextScaled = true;
    TextLabel.Parent = u9;
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(232, 232, 232);
    Frame.BackgroundTransparency = 0.5;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.38, 0.5);
    Frame.Size = UDim2.new(0, 2, 0.8, 0);
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = 90;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.199789, 0),
        NumberSequenceKeypoint.new(0.800211, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame;
    Frame.Parent = u9;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.42, 0.1);
    TextLabel2.Size = UDim2.fromScale(0.53, 0.14);
    TextLabel2.Text = "ROBLOX PLUS";
    TextLabel2.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = u9;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.42, 0.255);
    TextLabel3.Size = UDim2.fromScale(0.53, 0.075);
    TextLabel3.Text = "Subscribe and get the golden badge.";
    TextLabel3.TextColor3 = Color3.fromRGB(175, 231, 255);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.2;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = u9;

    for i, v in u14 do
        local TextLabel4 = Instance.new("TextLabel");
        TextLabel4.Name = "Perk";
        TextLabel4.BackgroundTransparency = 1;
        TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
        TextLabel4.Position = UDim2.fromScale(0.42, 0.4 + (i - 1) * 0.09);
        TextLabel4.Size = UDim2.fromScale(0.53, 0.065);
        TextLabel4.Text = `•  {v}`;
        TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
        TextLabel4.TextScaled = true;
        TextLabel4.TextTransparency = 0.15;
        TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel4.Parent = u9;
    end;

    u10 = Instance.new("TextButton");
    u10.Name = "Submit";
    u10.AutoButtonColor = false;
    u10.BackgroundTransparency = 1;
    u10.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    u10.Position = UDim2.fromScale(0.42, 0.72);
    u10.Size = UDim2.fromScale(0.27, 0.15);
    u10.Text = "";
    u10.TextColor3 = Color3.new();
    u10.TextSize = 14;
    u10.TextTransparency = 1;
    u10.ZIndex = 2;
    u11 = Instance.new("TextLabel");
    u11.Name = "Title";
    u11.AnchorPoint = Vector2.new(0.5, 0.5);
    u11.BackgroundTransparency = 1;
    u11.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u11.Position = UDim2.new(0.5, 0, 0.5, 1);
    u11.Size = UDim2.fromScale(0.7, 0.5);
    u11.Text = "SUBSCRIBE";
    u11.TextColor3 = Color3.new(1, 1, 1);
    u11.TextScaled = true;
    u11.ZIndex = 5;
    u11.Parent = u10;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 228, 160)), ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 180, 90)) });
    UIGradient3.Rotation = 90;
    UIGradient3.Parent = u11;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Shadow";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://186491278";
    ImageLabel3.ImageTransparency = 0.64;
    ImageLabel3.LayoutOrder = -1;
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Slice;
    ImageLabel3.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel3.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel3.ZIndex = -9999;
    ImageLabel3.Parent = u10;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(120, 95, 45);
    Frame2.BackgroundTransparency = 0.35;
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(1, 1);
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.Parent = Frame2;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Color = Color3.fromRGB(255, 210, 120);
    UIStroke2.Transparency = 0.55;
    UIStroke2.Parent = Frame2;
    Frame2.Parent = u10;
    u10.Parent = u9;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Disclaimer";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.715, 0.795);
    Frame3.Size = UDim2.fromScale(0.24, 0.05);
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "MainText";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.15, 0.5);
    TextLabel4.Size = UDim2.fromScale(0.85, 0.8);
    TextLabel4.Text = "Billed monthly by Roblox.";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextTransparency = 0.25;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame3;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "IconInfo";
    ImageLabel4.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://80205853195967";
    ImageLabel4.Position = UDim2.fromScale(0, 0.5);
    ImageLabel4.Size = UDim2.fromScale(1, 1);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.Parent = Frame3;
    Frame3.Parent = u9;
    u9.Parent = u8;
end;

return u1;