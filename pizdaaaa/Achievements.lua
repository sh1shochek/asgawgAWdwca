-- ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Achievements
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.SideSection.Rewards.Achievements
-- Decompile time: 19.91 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("HttpService");
local RunService = game:GetService("RunService");
local _ = Players.LocalPlayer;
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
local TweenInfo_new_ret = TweenInfo.new(0.25);
local TweenInfo_new_ret2 = TweenInfo.new(0.5);
TweenInfo.new(1);
local u17 = nil;
local u18 = nil;

function u1.Draw() -- Line: 34
    -- upvalues: u3 (ref), u13 (ref), u1 (copy), u7 (ref), u8 (ref), u16 (ref), u4 (ref), u10 (ref), u11 (ref), TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), RunService (copy), u15 (ref), u5 (ref), u18 (ref), u17 (ref), u14 (ref)
    local v19 = 0;
    local v20 = 0;

    for i, v in u3 do
        local v21 = u13:FindFirstChild(i);
        local u22, u23;

        if v21 then
            u4:Removes(`{i}MouseEnter`, `{i}MouseLeave`, (`{i}Button1Click`));
            u22 = i;
            u23 = v;
        else
            v21 = u1.achievementFrame(i, v.Description, (`rbxassetid://{v.Icon}`));
            u22 = i;
            u23 = v;

            for _, v2 in v.Rewards do
                local v24, v25 = unpack(v2);

                if v24 == "Credits" then
                    u1.rewardFrame(v21.Rewards, `rbxassetid://{138240378050344}`, `{v25}`, UDim2.fromScale(0.8, 0.8));
                elseif v24 == "XP" then
                    u1.rewardFrame(v21.Rewards, `rbxassetid://{73202452975271}`, `{v25}`, UDim2.fromScale(0.8, 0.8));
                elseif v24 == "Item" or (v24 == "Container" or v24 == "Graphic Art") then
                    local v26, v27 = unpack(v25:split("_"));
                    local v28 = u7.GetItem(v26, v27) or u8.GetWeaponSkin(v26, v27);
                    local v29 = (u7.GetCategory(v26) or u16.Get(v26)).DisplayName or v26;
                    local v30 = v28.DisplayName or v27;
                    u1.rewardFrame(v21.Rewards, `rbxassetid://{v28.Thumbnail}`, `{v29} | {v30}`, UDim2.fromScale(1.6, 0.8));
                end;
            end;
        end;

        local v31 = u10[u23.Type];
        local Amount = u23.Amount;
        local Claim = v21.Claim;
        local UIGradient = v21.UIGradient;
        local Title = Claim.Title;
        local ProgressBar = v21.ProgressBar;

        if Amount > v31 then
            ProgressBar.Title.Text = `{v31}/{Amount}`;
            ProgressBar.Bar.Size = UDim2.fromScale(math.clamp(v31 / Amount, 0, 1), 1);
            UIGradient.Enabled = true;
            UIGradient.Rotation = 270;
            ProgressBar.Visible = true;
            Claim.Visible = false;
            v21.LayoutOrder = 0;
            v20 = v20 + 1;
            v21.Visible = true;
            v21.Parent = u13;
        end;

        local Frame = Claim.Frame;

        if u11[u22] then
            TweenService:Create(Title, TweenInfo_new_ret, {
                TextTransparency = 1
            }):Play();
            TweenService:Create(Frame, TweenInfo_new_ret2, {
                BackgroundColor3 = Color3.fromRGB(31, 59, 80)
            }):Play();
            task.delay(0.25, function() -- Line: 83
                -- upvalues: Title (copy), TweenService (ref), TweenInfo_new_ret (ref)
                Title.Text = "Claimed";
                Title.UIGradient.Enabled = true;
                TweenService:Create(Title, TweenInfo_new_ret, {
                    TextTransparency = 0
                }):Play();
            end);
            UIGradient.Enabled = true;
            UIGradient.Rotation = 90;
            UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255));
            task.spawn(function() -- Line: 96
                -- upvalues: u22 (copy), u4 (ref), RunService (ref), UIGradient (copy)
                local os_clock_ret = os.clock();
                local u32 = `{u22}_ShineAnim`;
                u4:Add(u32, RunService.Heartbeat:Connect(function() -- Line: 100
                    -- upvalues: os_clock_ret (copy), UIGradient (ref), u4 (ref), u32 (copy)
                    local v33 = os.clock() - os_clock_ret;
                    local math_min_ret = math.min(v33, 1);
                    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255):Lerp(Color3.fromRGB(80, 80, 80), (math.clamp(math_min_ret * 2, 0, 1)))), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) });

                    if math_min_ret * 2 >= 1 then
                        u4:Remove(u32);
                    end;
                end));
            end);
            v21.LayoutOrder = 2;
            v19 = v19 + 1;
            v20 = v20 + 1;
        else
            UIGradient.Enabled = false;
            u4:Add(`{u22}MouseEnter`, Claim.MouseEnter:Connect(function() -- Line: 126
                -- upvalues: TweenService (ref), Frame (copy), TweenInfo_new_ret (ref)
                TweenService:Create(Frame, TweenInfo_new_ret, {
                    BackgroundColor3 = Color3.fromRGB(63, 119, 161)
                }):Play();
            end));
            u4:Add(`{u22}MouseLeave`, Claim.MouseLeave:Connect(function() -- Line: 129
                -- upvalues: TweenService (ref), Frame (copy), TweenInfo_new_ret (ref)
                TweenService:Create(Frame, TweenInfo_new_ret, {
                    BackgroundColor3 = Color3.fromRGB(50, 94, 128)
                }):Play();
            end));
            u4:Add(`{u22}Button1Click`, Claim.MouseButton1Click:Connect(function() -- Line: 132
                -- upvalues: u15 (ref), u5 (ref), u22 (copy), u18 (ref), u23 (copy)
                u15.Play("UI.submenu_click");
                u5.Gui.ClaimAchievementReward.Fire(u22);
                u18.RewardsNotifications(u23.Rewards);
            end));
            u17.AddNotice("Rewards");
            Title.Text = "Claim";
            Claim.Frame.BackgroundColor3 = Color3.fromRGB(50, 94, 128);
            Title.UIGradient.Enabled = false;
            UIGradient.Enabled = false;
            ProgressBar.Visible = false;
            Claim.Visible = true;
            v21.LayoutOrder = 1;
            v20 = v20 + 1;
            v21.Visible = true;
            v21.Parent = u13;
        end;
    end;

    u14.Text = `{v19}/{v20} Completed`;
end;

function u1.Update() -- Line: 174
    -- upvalues: u3 (ref), u11 (ref), u13 (ref), u10 (ref), u4 (ref), u15 (ref), TweenService (copy), TweenInfo_new_ret (copy), u5 (ref), u18 (ref), u17 (ref)
    for i, v in u3 do
        if not u11[i] then
            local v34 = u13:FindFirstChild(i);
            local v35 = u10[v.Type];
            local Amount = v.Amount;
            local Claim = v34.Claim;
            local Frame = Claim.Frame;
            local Title = Claim.Title;
            local ProgressBar = v34.ProgressBar;

            if Amount <= v35 and ProgressBar.Visible then
                u4:Add(`{i}MouseEnter`, Claim.MouseEnter:Connect(function() -- Line: 190
                    -- upvalues: u15 (ref), TweenService (ref), Frame (copy), TweenInfo_new_ret (ref)
                    u15.Play("UI.submenu_dropdown_rollover");
                    TweenService:Create(Frame, TweenInfo_new_ret, {
                        BackgroundColor3 = Color3.fromRGB(63, 119, 161)
                    }):Play();
                end));
                u4:Add(`{i}MouseLeave`, Claim.MouseLeave:Connect(function() -- Line: 195
                    -- upvalues: TweenService (ref), Frame (copy), TweenInfo_new_ret (ref)
                    TweenService:Create(Frame, TweenInfo_new_ret, {
                        BackgroundColor3 = Color3.fromRGB(50, 94, 128)
                    }):Play();
                end));
                u4:Add(`{i}Button1Click`, Claim.MouseButton1Click:Connect(function() -- Line: 198
                    -- upvalues: u15 (ref), u5 (ref), i (copy), u18 (ref), v (copy)
                    u15.Play("UI.submenu_click");
                    u5.Gui.ClaimAchievementReward.Fire(i);
                    u18.RewardsNotifications(v.Rewards);
                end));
                u17.AddNotice("Rewards");
                Title.Text = "Claim";
                Frame.BackgroundColor3 = Color3.fromRGB(50, 94, 128);
                Title.UIGradient.Enabled = false;
                ProgressBar.Visible = false;
                Claim.Visible = true;
                v34.LayoutOrder = 1;
            else
                ProgressBar.Title.Text = `{v35}/{Amount}`;
                ProgressBar.Bar.Size = UDim2.fromScale(math.clamp(v35 / Amount, 0, 1), 1);
                ProgressBar.Visible = true;
                Claim.Visible = false;
                v34.LayoutOrder = 0;
            end;
        end;
    end;
end;

function u1.Init(p36) -- Line: 230
    -- upvalues: u2 (ref), u4 (ref), u3 (ref), u5 (ref), u9 (ref), u6 (ref), u7 (ref), u8 (ref), u15 (ref), u16 (ref)
    u2 = p36:GetModule("Gui");
    u4 = p36:GetModule("Maid").new();
    u3 = p36:GetModule("AchievementsData");
    u5 = p36:GetModule("Network");
    u9 = p36:GetModule("ProfileData");
    u6 = p36:GetModule("RarityColors");
    u7 = p36:GetModule("ItemManager");
    u8 = p36:GetModule("SkinManager");
    u15 = p36:GetModule("SoundManager");
    u16 = p36:GetModule("WeaponManager");
end;

function u1.Start2(p37) -- Line: 244
    -- upvalues: u17 (ref), u2 (ref), u18 (ref), u12 (ref), u1 (copy), u10 (ref), u9 (ref), u11 (ref)
    u17 = u2.GetComponent("MainMenu");
    u18 = u2.GetComponent("Rewards");
    u12 = u18.Tabs:CreatePage("Achievements", 4, false, false);
    u1.new();
    u10 = u9.Get("PlayerStats");
    u9.Changed("PlayerStats"):Connect(function(p38) -- Line: 252
        -- upvalues: u10 (ref), u1 (ref)
        u10 = p38;
        u1.Update();
    end);
    u11 = u9.Get("CollectedAchievements");
    u9.Changed("CollectedAchievements"):Connect(function(p39) -- Line: 259
        -- upvalues: u11 (ref), u1 (ref)
        u11 = p39;
        u1.Draw();
    end);
    u1.Draw();
end;

function u1.new() -- Line: 270
    -- upvalues: u13 (ref), u14 (ref), u12 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.fromRGB(108, 108, 108);
    Frame.BackgroundTransparency = 0.95;
    Frame.Position = UDim2.fromScale(0.5, 0.508313);
    Frame.Size = UDim2.fromScale(0.5, 0.9);
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.005, 0);
    UICorner.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://118256082193795";
    ImageLabel.ImageColor3 = Color3.fromRGB(118, 127, 128);
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Crop;
    ImageLabel.Size = UDim2.new(1, 4, 1, 4);
    ImageLabel.ZIndex = -1;
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
    UIGradient.Parent = ImageLabel;
    ImageLabel.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(118, 127, 128);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0.7;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(49, 58, 68)),
        ColorSequenceKeypoint.new(0.0986159, Color3.fromRGB(54, 64, 78)),
        ColorSequenceKeypoint.new(0.32699, Color3.fromRGB(62, 71, 82)),
        ColorSequenceKeypoint.new(0.548443, Color3.fromRGB(74, 86, 97)),
        ColorSequenceKeypoint.new(0.685121, Color3.fromRGB(71, 80, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 57, 63))
    });
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.03), NumberSequenceKeypoint.new(1, 0.03) });
    UIGradient2.Parent = UIStroke;
    UIStroke.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.25);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.0404447);
    TextLabel.Size = UDim2.fromScale(0.8, 0.0795424);
    TextLabel.Text = "ACHIEVEMENTS";
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
    Frame2.Position = UDim2.fromScale(0.5, 0.1);
    Frame2.Size = UDim2.new(0.8, 0, 0, 2);
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.199789, 0),
        NumberSequenceKeypoint.new(0.800211, 0),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient3.Parent = Frame2;
    Frame2.Parent = Frame;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "DOTS";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://91991932054752";
    ImageLabel2.ImageColor3 = Color3.fromRGB(140, 140, 140);
    ImageLabel2.ImageTransparency = 0.5;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel2.ScaleType = Enum.ScaleType.Tile;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel2.ZIndex = -1;
    ImageLabel2.Parent = Frame;
    u13 = Instance.new("ScrollingFrame");
    u13.Name = "List";
    u13.Active = true;
    u13.AnchorPoint = Vector2.new(0.5, 0);
    u13.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    u13.BackgroundTransparency = 1;
    u13.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    u13.Position = UDim2.fromScale(0.5, 0.14);
    u13.ScrollBarImageTransparency = 0.2;
    u13.ScrollBarThickness = 2;
    u13.Size = UDim2.fromScale(0.98, 0.85);
    u13.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    u13.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    u13.BorderSizePixel = 0;
    local UIGridLayout = Instance.new("UIGridLayout");
    UIGridLayout.Name = "UIGridLayout";
    UIGridLayout.CellPadding = UDim2.fromScale(1, 0.08);
    UIGridLayout.CellSize = UDim2.fromScale(1, 0.18);
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.Parent = u13;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0.01, 0);
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.Parent = u13;
    u13.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.new();
    Frame3.BackgroundTransparency = 0.95;
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.fromScale(0.98, 0.98);
    Frame3.ZIndex = -1;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.005, 0);
    UICorner2.Parent = Frame3;
    Frame3.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 1.09;
    UIAspectRatioConstraint.Parent = Frame;
    u14 = Instance.new("TextLabel");
    u14.Name = "Amount";
    u14.AnchorPoint = Vector2.new(0.5, 0.25);
    u14.BackgroundTransparency = 1;
    u14.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    u14.Position = UDim2.fromScale(0.5, 0.11);
    u14.Size = UDim2.fromScale(0.8, 0.03);
    u14.Text = "9/120";
    u14.TextColor3 = Color3.fromRGB(232, 232, 232);
    u14.TextScaled = true;
    u14.Parent = Frame;
    Frame.Parent = u12;
end;

function u1.achievementFrame(p40, p41, p42) -- Line: 460
    -- upvalues: u13 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = p40;
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.75;
    Frame.Visible = false;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "AchievementName";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 6.21775e-7);
    TextLabel.Size = UDim2.fromScale(0.4, 0.3);
    TextLabel.Text = p40;
    TextLabel.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 10;
    TextLabel.Parent = Frame;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Description";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.16, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.475, 0.3);
    TextLabel2.Text = p41;
    TextLabel2.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel2.TextScaled = true;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient.Rotation = 270;
    UIGradient.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Rewards";
    Frame2.AnchorPoint = Vector2.new(1, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.99, 0.018);
    Frame2.Size = UDim2.fromScale(0.95, 0.95);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame2.ZIndex = 2;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.065, 0);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Icon";
    Frame3.BackgroundColor3 = Color3.fromRGB(162, 162, 162);
    Frame3.BackgroundTransparency = 0.5;
    Frame3.ClipsDescendants = true;
    Frame3.Position = UDim2.fromScale(0.0025, 0.018);
    Frame3.Size = UDim2.fromScale(0.95, 0.95);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame3.ZIndex = 2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.05, 0);
    UICorner2.Parent = Frame3;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(232, 232, 232);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.025;
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p42;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Parent = Frame3;
    Frame3.Parent = Frame;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "ProgressBar";
    Frame4.Active = true;
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0.5, 1);
    Frame4.Size = UDim2.fromScale(0.6, 0.25);
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Title";
    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel3.Size = UDim2.fromScale(0.5, 1);
    TextLabel3.Text = "5/10";
    TextLabel3.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 5;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(159, 159, 159)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient2.Enabled = false;
    UIGradient2.Rotation = 90;
    UIGradient2.Parent = TextLabel3;
    TextLabel3.Parent = Frame4;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "Shadow";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://186491278";
    ImageLabel2.ImageTransparency = 0.64;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Slice;
    ImageLabel2.Size = UDim2.new(1, 15, 1, 15);
    ImageLabel2.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel2.ZIndex = -9999;
    ImageLabel2.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Background";
    Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame5.BackgroundColor3 = Color3.fromRGB(50, 50, 50);
    Frame5.Position = UDim2.fromScale(0.5, 0.5);
    Frame5.Size = UDim2.fromScale(1, 1);
    Frame5.ZIndex = -1;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.1, 2);
    UICorner3.Parent = Frame5;
    Frame5.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Bar";
    Frame6.AnchorPoint = Vector2.new(0, 0.5);
    Frame6.BackgroundColor3 = Color3.fromRGB(128, 128, 128);
    Frame6.Position = UDim2.fromScale(-1.98691e-6, 0.5);
    Frame6.Size = UDim2.fromScale(0.500002, 1);
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.1, 0);
    UICorner4.Parent = Frame6;
    Frame6.Parent = Frame4;
    Frame4.Parent = Frame;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "Claim";
    TextButton.AnchorPoint = Vector2.new(0.5, 1);
    TextButton.AutoButtonColor = false;
    TextButton.BackgroundTransparency = 1;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
    TextButton.Position = UDim2.fromScale(0.5, 1.17412);
    TextButton.Size = UDim2.fromScale(0.25, 0.341684);
    TextButton.Text = "";
    TextButton.TextColor3 = Color3.new();
    TextButton.TextSize = 14;
    TextButton.TextTransparency = 1;
    TextButton.Visible = false;
    TextButton.ZIndex = 2;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Title";
    TextLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.new(0.5, 0, 0.5, 1);
    TextLabel4.Size = UDim2.fromScale(0.5, 0.8);
    TextLabel4.Text = "CLAIM";
    TextLabel4.TextColor3 = Color3.fromRGB(232, 232, 232);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 5;
    TextLabel4.Parent = TextButton;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(159, 159, 159)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient3.Enabled = false;
    UIGradient3.Rotation = 90;
    UIGradient3.Parent = TextLabel4;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Shadow";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://186491278";
    ImageLabel3.ImageTransparency = 0.64;
    ImageLabel3.LayoutOrder = -1;
    ImageLabel3.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel3.ScaleType = Enum.ScaleType.Slice;
    ImageLabel3.Size = UDim2.new(1, 15, 1, 15);
    ImageLabel3.SliceCenter = Rect.new(48, 48, 48, 48);
    ImageLabel3.ZIndex = -9999;
    ImageLabel3.Parent = TextButton;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame7.BackgroundColor3 = Color3.fromRGB(50, 94, 128);
    Frame7.Position = UDim2.fromScale(0.5, 0.5);
    Frame7.Size = UDim2.fromScale(1, 1);
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICorner";
    UICorner5.CornerRadius = UDim.new(0.1, 0);
    UICorner5.Parent = Frame7;
    Frame7.Parent = TextButton;
    TextButton.Parent = Frame;
    Frame.Visible = true;
    Frame.Parent = u13;

    return Frame;
end;

function u1.rewardFrame(p43, p44, p45, p46) -- Line: 728
    local Frame = Instance.new("Frame");
    Frame.Name = "RewardFrame";
    Frame.BackgroundColor3 = Color3.fromRGB(162, 162, 162);
    Frame.BackgroundTransparency = 0.5;
    Frame.Position = UDim2.fromScale(0.0025, 0.018);
    Frame.Size = p46;
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame.Visible = false;
    Frame.ZIndex = 2;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.05, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.Color = Color3.fromRGB(232, 232, 232);
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke.Thickness = 0.025;
    UIStroke.Transparency = 0.5;
    UIStroke.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p44;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 1);
    TextLabel.Size = UDim2.fromScale(1, 0.4);
    TextLabel.Text = p45;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Name = "UIStroke";
    UIStroke2.Color = Color3.fromRGB(232, 232, 232);
    UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
    UIStroke2.Thickness = 0.025;
    UIStroke2.Transparency = 0.5;
    UIStroke2.Parent = TextLabel;
    TextLabel.Parent = Frame;
    Frame.Visible = true;
    Frame.Parent = p43;

    return Frame;
end;

return u1;