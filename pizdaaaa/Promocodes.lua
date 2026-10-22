-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Promocodes
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Promocodes
-- Decompile time: 21.41 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
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
local u16 = {};
local u17 = "";
local u18 = false;
local u19 = false;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = {
    [0] = {
        Text = "Successfully Used!",
        Sound = "UI.submenu_click",
        Color = Color3.new(0.470588, 1, 0.513725)
    },
    [1] = {
        Text = "Code doesn\'t exist!",
        Sound = "UI.lobby_error",
        Color = Color3.new(1, 0.235294, 0.247059)
    },
    [2] = {
        Text = "Already Used!",
        Sound = "UI.lobby_error",
        Color = Color3.new(0.992157, 1, 0.419608)
    },
    [3] = {
        Text = "You can\'t use it yet! ",
        Sound = "UI.lobby_error",
        Color = Color3.new(0.992157, 1, 0.419608)
    },
    [4] = {
        Text = "Code is Outdated!",
        Sound = "UI.lobby_error",
        Color = Color3.new(1, 0.235294, 0.247059)
    },
    [5] = {
        Text = "Code out of Uses!",
        Sound = "UI.lobby_error",
        Color = Color3.new(1, 0.235294, 0.247059)
    },
    [6] = {
        Text = "Need more playtime!",
        Sound = "UI.lobby_error",
        Color = Color3.new(1, 0.235294, 0.247059)
    }
};
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.5);
local TweenInfo_new_ret3 = TweenInfo.new(1);

function u1.Draw() -- Line: 50
    -- upvalues: u4 (ref), u11 (ref), u22 (ref), TweenService (copy), TweenInfo_new_ret (copy), u18 (ref), u1 (copy), u10 (ref), u12 (ref), u16 (ref), u5 (ref), u20 (ref), u14 (ref), u19 (ref), u13 (ref), u17 (ref), u7 (ref), u3 (ref), u15 (ref), u21 (ref), u25 (copy), HttpService (copy), u23 (ref), LocalPlayer (copy)
    u4:Removes(
        "InputButtonClick",
        "InputButtonMouseEnter",
        "InputButtonMouseLeave",
        "StarClick",
        "StarMouseEnter",
        "StarMouseLeave"
    );
    u4:Add("InputButtonMouseEnter", u11.MouseEnter:Connect(function() -- Line: 53
        -- upvalues: u22 (ref), TweenService (ref), u11 (ref), TweenInfo_new_ret (ref)
        u22.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u11.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(63, 119, 161)
        }):Play();
    end));
    u4:Add("InputButtonMouseLeave", u11.MouseLeave:Connect(function() -- Line: 59
        -- upvalues: TweenService (ref), u11 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u11.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(50, 94, 128)
        }):Play();
    end));
    u4:Add("InputButtonClick", u11.MouseButton1Click:Connect(function() -- Line: 63
        -- upvalues: u18 (ref), u1 (ref), u10 (ref), u12 (ref), u16 (ref), u22 (ref), u5 (ref), u20 (ref)
        if u18 then
            u1.Message(u10, "Cooldown!", Color3.new(0.356863, 0.356863, 0.356863));

            return;
        end;

        local Text = u12.Text;

        if not Text or Text == "" then
            return;
        end;

        if u16[Text] then
            u22.Play("UI.lobby_error");
            u1.Message(u10, "Already Used!", Color3.new(0.992157, 1, 0.419608));
        else
            u5.Gui.UsePromocode.Fire(Text);
            u20 = Text;
        end;

        u18 = true;
        task.delay(4.5, function() -- Line: 86
            -- upvalues: u18 (ref)
            u18 = false;
        end);
    end));
    u4:Add("StarMouseEnter", u14.MouseEnter:Connect(function() -- Line: 91
        -- upvalues: u22 (ref), TweenService (ref), u14 (ref), TweenInfo_new_ret (ref)
        u22.Play("UI.submenu_dropdown_rollover");
        TweenService:Create(u14.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(63, 119, 161)
        }):Play();
    end));
    u4:Add("StarMouseLeave", u14.MouseLeave:Connect(function() -- Line: 97
        -- upvalues: TweenService (ref), u14 (ref), TweenInfo_new_ret (ref)
        TweenService:Create(u14.Frame, TweenInfo_new_ret, {
            BackgroundColor3 = Color3.fromRGB(50, 94, 128)
        }):Play();
    end));
    u4:Add("StarClick", u14.MouseButton1Click:Connect(function() -- Line: 101
        -- upvalues: u19 (ref), u1 (ref), u13 (ref), u17 (ref), u22 (ref), u7 (ref), u3 (ref), u15 (ref), u5 (ref), u21 (ref)
        if u19 then
            u1.Message(u13, "Cooldown!", Color3.new(0.356863, 0.356863, 0.356863));

            return;
        end;

        if u17 and u17 ~= "" then
            u22.Play("UI.lobby_error");
            u1.Message(u13, "Already Used!", Color3.new(0.992157, 1, 0.419608));

            return;
        end;

        if ((u7.Get("PlayerStats") or {}).Playtime or 0) < (u3 and u3.RequiredPlaytime or 3600) then
            u22.Play("UI.lobby_error");
            u1.Message(u13, "Need 1h playtime!", Color3.new(1, 0.235294, 0.247059));

            return;
        end;

        local string_upper_ret = string.upper(u15.Text);

        if u3 and u3.Codes and u3.Codes[string_upper_ret] then
            u5.Gui.UseStarCode.Fire(string_upper_ret);
            u21 = string_upper_ret;
        else
            u22.Play("UI.lobby_error");
            u1.Message(u13, "Code doesn\'t exist!", Color3.new(1, 0.235294, 0.247059));
        end;

        u19 = true;
        task.delay(4.5, function() -- Line: 140
            -- upvalues: u19 (ref)
            u19 = false;
        end);
    end));
    u16 = u7.Get("UsedCodes") or {};
    u7.Changed("UsedCodes"):Connect(function(p26) -- Line: 146
        -- upvalues: u16 (ref)
        u16 = p26 or {};
    end);
    u17 = u7.Get("UsedStarCode") or "";

    if u17 ~= "" then
        u15.Text = u17;
    end;

    u7.Changed("UsedStarCode"):Connect(function(p27) -- Line: 155
        -- upvalues: u17 (ref), u15 (ref)
        u17 = p27 or "";

        if u17 ~= "" then
            u15.Text = u17;
        end;
    end);

    local function OnPromocodeResult(p28) -- Line: 162
        -- upvalues: u25 (ref), u22 (ref), u1 (ref), u10 (ref), HttpService (ref), u23 (ref)
        if not p28 then
            return;
        end;

        local v29 = u25[p28.Status];

        if v29 then
            if v29.Sound then
                u22.Play(v29.Sound);
            end;

            u1.Message(u10, p28.Message or v29.Text, v29.Color);
        end;

        if p28.Status == 0 and p28.Rewards then
            local success, result = pcall(HttpService.JSONDecode, HttpService, p28.Rewards);

            if success and result then
                u23.RewardsNotifications(result);
            end;
        end;
    end;

    if u5.Gui.PromocodeResult then
        u5.Gui.PromocodeResult.On(OnPromocodeResult);
    end;

    LocalPlayer:GetAttributeChangedSignal("CodeUsed"):Connect(function() -- Line: 186
        -- upvalues: LocalPlayer (ref), HttpService (ref), OnPromocodeResult (copy)
        local Attribute = LocalPlayer:GetAttribute("CodeUsed");

        if typeof(Attribute) ~= "string" then
            return;
        end;

        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute);

        if success then
            OnPromocodeResult(result);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("StarCodeUsed"):Connect(function() -- Line: 198
        -- upvalues: LocalPlayer (ref), u22 (ref), u1 (ref), u13 (ref), u3 (ref), u23 (ref)
        local Attribute = LocalPlayer:GetAttribute("StarCodeUsed");

        if Attribute == nil then
            return;
        end;

        if not Attribute then
            u22.Play("UI.lobby_error");
            u1.Message(u13, "Already Used!", Color3.new(1, 0.235294, 0.247059));

            return;
        end;

        u22.Play("UI.submenu_click");
        u1.Message(u13, "Successfully Used!", Color3.new(0.470588, 1, 0.513725));
        u23.RewardsNotifications({
            { "Container", u3 and u3.LatestCase or "Mayhem Case" }
        });
    end);
end;

function u1.Message(u30, p31, p32) -- Line: 218
    -- upvalues: TweenService (copy), TweenInfo_new_ret2 (copy), TweenInfo_new_ret3 (copy)
    u30.TextTransparency = 1;
    u30.Text = p31;
    u30.TextColor3 = p32;
    TweenService:Create(u30, TweenInfo_new_ret2, {
        TextTransparency = 0.2
    }):Play();
    task.delay(3, function() -- Line: 225
        -- upvalues: TweenService (ref), u30 (copy), TweenInfo_new_ret3 (ref)
        TweenService:Create(u30, TweenInfo_new_ret3, {
            TextTransparency = 1
        }):Play();
    end);
end;

function u1.Init(p33) -- Line: 232
    -- upvalues: u2 (ref), u4 (ref), u3 (ref), u5 (ref), u7 (ref), u6 (ref), u22 (ref)
    u2 = p33:GetModule("Gui");
    u4 = p33:GetModule("Maid").new();
    u3 = p33:GetModule("StarCodesData");
    u5 = p33:GetModule("Network");
    u7 = p33:GetModule("ProfileData");
    u6 = p33:GetModule("RarityColors");
    u22 = p33:GetModule("SoundManager");
end;

function u1.Start2(p34) -- Line: 242
    -- upvalues: u8 (ref), u2 (ref), u24 (ref), u23 (ref), u9 (ref), u1 (copy)
    u8 = u2.GetComponent("MenuNotification");
    u24 = u2.GetComponent("Store");
    u23 = u2.GetComponent("Rewards");
    u9 = u23.Tabs:CreatePage("Promocodes", 5, false, false);
    u24.CreditsLabel(u9.Parent.Parent.Page);
    u1.new();
    u1.Draw();
end;

function u1.new() -- Line: 257
    -- upvalues: u10 (ref), u12 (ref), u11 (ref), u15 (ref), u14 (ref), u13 (ref), u9 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(108, 108, 108);
    Frame.BackgroundTransparency = 0.95;
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.fromScale(0.5, 0.75);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0, 4);
    UICorner.BottomRightRadius = UDim.new(0, 4);
    UICorner.CornerRadius = UDim.new(0, 4);
    UICorner.TopLeftRadius = UDim.new(0, 4);
    UICorner.TopRightRadius = UDim.new(0, 4);
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
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Line";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.fromRGB(232, 232, 232);
    Frame2.BackgroundTransparency = 0.5;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.5, 0.475);
    Frame2.Size = UDim2.new(0.9, 0, 0, 2);
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
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Promocodes";
    Frame3.BackgroundTransparency = 1;
    Frame3.Size = UDim2.fromScale(1, 0.475);
    u10 = Instance.new("TextLabel");
    u10.Name = "Message";
    u10.AnchorPoint = Vector2.new(0.5, 1);
    u10.BackgroundTransparency = 1;
    u10.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u10.Position = UDim2.fromScale(0.5, 1);
    u10.Size = UDim2.fromScale(0.5, 0.0654873);
    u10.Text = "Correct!";
    u10.TextColor3 = Color3.fromRGB(106, 208, 123);
    u10.TextScaled = true;
    u10.TextTransparency = 1;
    u10.TextYAlignment = Enum.TextYAlignment.Top;
    u10.Parent = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "TextBox";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.fromRGB(162, 162, 162);
    Frame4.BackgroundTransparency = 0.5;
    Frame4.ClipsDescendants = true;
    Frame4.Position = UDim2.fromScale(0.5, 0.525);
    Frame4.Size = UDim2.fromScale(0.6, 0.18);
    Frame4.ZIndex = 2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner2.BottomRightRadius = UDim.new(0.1, 0);
    UICorner2.CornerRadius = UDim.new(0.1, 0);
    UICorner2.TopLeftRadius = UDim.new(0.1, 0);
    UICorner2.TopRightRadius = UDim.new(0.1, 0);
    UICorner2.Parent = Frame4;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.BorderStrokePosition = Enum.BorderStrokePosition.Center;
    UIStroke2.Color = Color3.fromRGB(232, 232, 232);
    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke2.Thickness = 0.05;
    UIStroke2.Transparency = 0.5;
    UIStroke2.Parent = Frame4;
    u12 = Instance.new("TextBox");
    u12.Name = "TextBox";
    u12.Active = true;
    u12.AnchorPoint = Vector2.new(0.5, 0.5);
    u12.BackgroundTransparency = 1;
    u12.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    u12.LayoutOrder = 1;
    u12.PlaceholderColor3 = Color3.fromRGB(232, 232, 232);
    u12.PlaceholderText = "ENTER CODE";
    u12.Position = UDim2.fromScale(0.5, 0.5);
    u12.Selectable = false;
    u12.Size = UDim2.fromScale(0.925, 0.65);
    u12.Text = "";
    u12.TextColor3 = Color3.fromRGB(232, 232, 232);
    u12.TextScaled = true;
    u12.TextTransparency = 0.5;
    u12.TextXAlignment = Enum.TextXAlignment.Left;
    u12.Parent = Frame4;
    Frame4.Parent = Frame3;
    u11 = Instance.new("TextButton");
    u11.Name = "Submit";
    u11.AnchorPoint = Vector2.new(0.5, 0.5);
    u11.AutoButtonColor = false;
    u11.BackgroundTransparency = 1;
    u11.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    u11.Position = UDim2.fromScale(0.5, 0.8);
    u11.Size = UDim2.fromScale(0.25, 0.2);
    u11.Text = "";
    u11.TextColor3 = Color3.new();
    u11.TextSize = 14;
    u11.TextTransparency = 1;
    u11.ZIndex = 2;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel.Size = UDim2.fromScale(0.5, 0.8);
    TextLabel.Text = "SUBMIT";
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 5;
    TextLabel.Parent = u11;
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
    ImageLabel.Parent = u11;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Frame";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.BackgroundColor3 = Color3.fromRGB(50, 94, 128);
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.fromScale(1, 1);
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner3.BottomRightRadius = UDim.new(0.1, 0);
    UICorner3.CornerRadius = UDim.new(0.1, 0);
    UICorner3.TopLeftRadius = UDim.new(0.1, 0);
    UICorner3.TopRightRadius = UDim.new(0.1, 0);
    UICorner3.Parent = Frame5;
    Frame5.Parent = u11;
    u11.Parent = Frame3;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Title";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.126);
    TextLabel2.Size = UDim2.fromScale(0.55, 0.165);
    TextLabel2.Text = "PROMOCODES";
    TextLabel2.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame3;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.5, 0.285);
    TextLabel3.Size = UDim2.fromScale(0.55, 0.09);
    TextLabel3.Text = "Enter a promocode to get free rewards.";
    TextLabel3.TextColor3 = Color3.fromRGB(175, 231, 255);
    TextLabel3.TextScaled = true;
    TextLabel3.TextTransparency = 0.2;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.Parent = Frame3;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.AnchorPoint = Vector2.new(0, 0.25);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://119276666158135";
    ImageLabel2.ImageColor3 = Color3.fromRGB(131, 216, 255);
    ImageLabel2.Position = UDim2.fromScale(0.08, 0.15);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.3, 0.3);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.Parent = Frame3;
    Frame3.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.24;
    UIAspectRatioConstraint.Parent = Frame;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "DOTS";
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://91991932054752";
    ImageLabel3.ImageColor3 = Color3.fromRGB(140, 140, 140);
    ImageLabel3.ImageTransparency = 0.5;
    ImageLabel3.LayoutOrder = -1;
    ImageLabel3.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel3.ScaleType = Enum.ScaleType.Tile;
    ImageLabel3.Size = UDim2.fromScale(1, 1);
    ImageLabel3.TileSize = UDim2.fromOffset(512, 512);
    ImageLabel3.ZIndex = -1;
    ImageLabel3.Parent = Frame;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "StarCode";
    Frame6.BackgroundTransparency = 1;
    Frame6.Position = UDim2.fromScale(0, 0.475);
    Frame6.Size = UDim2.fromScale(1, 0.5);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "TextBox";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundColor3 = Color3.fromRGB(162, 162, 162);
    Frame7.BackgroundTransparency = 0.5;
    Frame7.ClipsDescendants = true;
    Frame7.Position = UDim2.fromScale(0.5, 0.55);
    Frame7.Size = UDim2.fromScale(0.6, 0.172);
    Frame7.ZIndex = 2;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner4.BottomRightRadius = UDim.new(0.1, 0);
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.TopLeftRadius = UDim.new(0.1, 0);
    UICorner4.TopRightRadius = UDim.new(0.1, 0);
    UICorner4.Parent = Frame7;
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Name = "UIStroke";
    UIStroke3.BorderStrokePosition = Enum.BorderStrokePosition.Center;
    UIStroke3.Color = Color3.fromRGB(232, 232, 232);
    UIStroke3.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke3.Thickness = 0.05;
    UIStroke3.Transparency = 0.5;
    UIStroke3.Parent = Frame7;
    u15 = Instance.new("TextBox");
    u15.Name = "TextBox";
    u15.Active = true;
    u15.AnchorPoint = Vector2.new(0.5, 0.5);
    u15.BackgroundTransparency = 1;
    u15.CursorPosition = -1;
    u15.FontFace = Font.new("rbxasset://fonts/families/Oswald.json");
    u15.LayoutOrder = 1;
    u15.PlaceholderColor3 = Color3.fromRGB(232, 232, 232);
    u15.PlaceholderText = "ENTER STARCODE";
    u15.Position = UDim2.fromScale(0.5, 0.5);
    u15.Selectable = false;
    u15.Size = UDim2.fromScale(0.925, 0.65);
    u15.Text = "";
    u15.TextColor3 = Color3.fromRGB(232, 232, 232);
    u15.TextScaled = true;
    u15.TextTransparency = 0.5;
    u15.TextXAlignment = Enum.TextXAlignment.Left;
    u15.Parent = Frame7;
    Frame7.Parent = Frame6;
    u14 = Instance.new("TextButton");
    u14.Name = "Submit";
    u14.AnchorPoint = Vector2.new(0.5, 0.5);
    u14.AutoButtonColor = false;
    u14.BackgroundTransparency = 1;
    u14.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    u14.Position = UDim2.fromScale(0.5, 0.82);
    u14.Size = UDim2.fromScale(0.25, 0.2);
    u14.Text = "";
    u14.TextColor3 = Color3.new();
    u14.TextSize = 14;
    u14.TextTransparency = 1;
    u14.ZIndex = 2;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel4.Size = UDim2.fromScale(0.5, 0.8);
    TextLabel4.Text = "SUBMIT";
    TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 5;
    TextLabel4.Parent = u14;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Shadow";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://186491278";
    ImageLabel4.ImageTransparency = 0.64;
    ImageLabel4.LayoutOrder = -1;
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.ScaleType = Enum.ScaleType.Slice;
    ImageLabel4.Size = UDim2.new(1, 30, 1, 30);
    ImageLabel4.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel4.ZIndex = -9999;
    ImageLabel4.Parent = u14;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Frame";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundColor3 = Color3.fromRGB(50, 94, 128);
    Frame8.Position = UDim2.fromScale(0.5, 0.5);
    Frame8.Size = UDim2.fromScale(1, 1);
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner5.BottomRightRadius = UDim.new(0.1, 0);
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.TopLeftRadius = UDim.new(0.1, 0);
    UICorner5.TopRightRadius = UDim.new(0.1, 0);
    UICorner5.Parent = Frame8;
    Frame8.Parent = u14;
    u14.Parent = Frame6;
    u13 = Instance.new("TextLabel");
    u13.Name = "Message";
    u13.AnchorPoint = Vector2.new(0.5, 1);
    u13.BackgroundTransparency = 1;
    u13.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    u13.Position = UDim2.fromScale(0.5, 0.98);
    u13.Size = UDim2.fromScale(0.5, 0.0654873);
    u13.Text = "Correct!";
    u13.TextColor3 = Color3.fromRGB(106, 208, 123);
    u13.TextScaled = true;
    u13.TextTransparency = 1;
    u13.TextYAlignment = Enum.TextYAlignment.Top;
    u13.Parent = Frame6;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "Title";
    TextLabel5.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.5, 0.1);
    TextLabel5.Size = UDim2.fromScale(0.55, 0.15);
    TextLabel5.Text = "STARCODE";
    TextLabel5.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.Parent = Frame6;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "Title";
    TextLabel6.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.fromScale(0.5, 0.26);
    TextLabel6.Size = UDim2.fromScale(0.55, 0.175);
    TextLabel6.Text = "Support your favorite content creator. Enter their StarCode once and get a case + they receive credits.";
    TextLabel6.TextColor3 = Color3.fromRGB(175, 231, 255);
    TextLabel6.TextScaled = true;
    TextLabel6.TextTransparency = 0.2;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.Parent = Frame6;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "ImageLabel";
    ImageLabel5.AnchorPoint = Vector2.new(0, 0.25);
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://90718157172286";
    ImageLabel5.ImageColor3 = Color3.fromRGB(131, 216, 255);
    ImageLabel5.Position = UDim2.fromScale(0.08, 0.15);
    ImageLabel5.ScaleType = Enum.ScaleType.Fit;
    ImageLabel5.Size = UDim2.fromScale(0.3, 0.271);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.Parent = Frame6;
    Frame6.Parent = Frame;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Disclaimer";
    Frame9.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0.5, 0.97);
    Frame9.Size = UDim2.fromScale(0.6, 0.04);
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "MainText";
    TextLabel7.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel7.LayoutOrder = 4;
    TextLabel7.Position = UDim2.fromScale(0.08, 0.499999);
    TextLabel7.RichText = true;
    TextLabel7.Size = UDim2.fromScale(1, 0.8);
    TextLabel7.Text = "Star code can only be used once and for one content creator.";
    TextLabel7.TextColor3 = Color3.new(1, 1, 1);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 0.25;
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel7.ZIndex = 9;
    TextLabel7.Parent = Frame9;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "IconInfo";
    ImageLabel6.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://80205853195967";
    ImageLabel6.Position = UDim2.fromScale(0, 0.5);
    ImageLabel6.Size = UDim2.fromScale(1, 1);
    ImageLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel6.Parent = Frame9;
    Frame9.Parent = Frame;
    Frame.Parent = u9;
end;

return u1;