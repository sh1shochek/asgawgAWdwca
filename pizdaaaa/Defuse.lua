-- ReplicatedStorage.GameClient.Gui.HUD.Defuse
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Defuse
-- Decompile time: 20.18 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("HttpService");
game:GetService("ReplicatedStorage");
local u2 = nil;
local u3 = nil;
local LocalPlayer = Players.LocalPlayer;
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
TweenInfo.new(0.2);
local Color3_fromRGB_ret = Color3.fromRGB(85, 240, 83);
local u12 = 0;

function u1.SetDefualt() -- Line: 40
    -- upvalues: u8 (ref), u9 (ref)
    u8.Rotation = -180;
    u9.Rotation = 0;
end;

function u1.UpdateTimer() -- Line: 45
    -- upvalues: u4 (ref), u7 (ref), u12 (ref), TweenService (copy), u6 (ref), u1 (copy), u5 (ref)
    if u4 then
        u7.Time.Text = string.format("00:%02d:%03d", math.floor(u12), (math.floor(u12 % 1 * 1000)));

        if u12 <= 0 then
            TweenService:Create(u6, TweenInfo.new(0.2), {
                GroupTransparency = 1
            }):Play();
            u1.SetDefualt();
            task.delay(0.2, function() -- Line: 53
                -- upvalues: TweenService (ref), u6 (ref)
                TweenService:Create(u6.Background, TweenInfo.new(0), {
                    GroupColor3 = Color3.fromRGB(240, 85, 83)
                }):Play();
                TweenService:Create(u6.ColorBackground, TweenInfo.new(0), {
                    GroupColor3 = Color3.fromRGB(240, 85, 83)
                }):Play();
            end);
            u4 = false;
            u5 = true;
        end;
    end;
end;

function u1.Enable(p13: boolean) -- Line: 64
    -- upvalues: u4 (ref), u5 (ref), u12 (ref), u1 (copy), TweenService (copy), u6 (ref), Color3_fromRGB_ret (copy), u8 (ref), u9 (ref), u7 (ref)
    if not p13 then
        if not u4 then
            return;
        end;

        local Position = u6.Position;
        u4 = false;

        for i = 1, 5 do
            TweenService:Create(u6, TweenInfo.new(0.03), {
                Position = Position + UDim2.fromOffset(i % 2 == 0 and 6 or -6, 0)
            }):Play();
            task.wait(0.02);
            local _ = i;
        end;

        TweenService:Create(u6, TweenInfo.new(0.05), {
            Position = Position
        }):Play();
        task.delay(0.5, function() -- Line: 105
            -- upvalues: u4 (ref), TweenService (ref), u6 (ref)
            if u4 then
                return;
            end;

            TweenService:Create(u6, TweenInfo.new(0.2), {
                GroupTransparency = 1
            }):Play();
            TweenService:Create(u6.Background, TweenInfo.new(0), {
                GroupColor3 = Color3.fromRGB(240, 85, 83)
            }):Play();
            TweenService:Create(u6.ColorBackground, TweenInfo.new(0), {
                GroupColor3 = Color3.fromRGB(240, 85, 83)
            }):Play();
        end);

        return;
    end;

    if u4 or (u5 or u12 <= 0) then
        return;
    end;

    u4 = true;
    u1.SetDefualt();
    TweenService:Create(u6, TweenInfo.new(0.1), {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(u6.Background, TweenInfo.new(u12), {
        GroupColor3 = Color3_fromRGB_ret
    }):Play();
    TweenService:Create(u6.ColorBackground, TweenInfo.new(u12), {
        GroupColor3 = Color3_fromRGB_ret
    }):Play();
    TweenService:Create(u8, TweenInfo.new(u12), {
        Rotation = 0
    }):Play();
    TweenService:Create(u9, TweenInfo.new(u12), {
        Rotation = -180
    }):Play();
    u7.Time.Text = `00:{u12}:000`;
end;

function u1.Init(p14) -- Line: 122
    -- upvalues: u2 (ref), u3 (ref), u11 (ref)
    u2 = p14:GetModule("Gui");
    u3 = p14:GetModule("Maid").new();
    CharacterController = p14:GetModule("CharacterController");
    u11 = p14:GetModule("Threads");
end;

function u1.Start(p15) -- Line: 129
    -- upvalues: u6 (ref), u1 (copy), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u5 (ref), u3 (ref), u12 (ref)
    u6 = u1.new();
    u7 = u6.Main;
    u8 = u6.Background.Main.Frame.Frame.Left.Frame.UIGradient;
    u9 = u6.Background.Main.Frame.Frame.Right.Frame.UIGradient;
    u10 = u6.Background.Main.Frame.UIGradientF1;
    CharacterController.OnCharacterSpawn:Connect(function(p16) -- Line: 141
        -- upvalues: u5 (ref), u3 (ref), u12 (ref), u1 (ref)
        u5 = false;
        u3:Add("Defuse", p16.Simulation.DefuseUpdate:Connect(function(p17, p18) -- Line: 144
            -- upvalues: u5 (ref), u12 (ref), u1 (ref)
            if not p17 then
                u5 = false;
            end;

            u12 = p18;
            u1.Enable(p17, p18);
            u1.UpdateTimer();
        end));
    end);
    CharacterController.OnCharacterDestroy:Connect(function(p19) -- Line: 155
        -- upvalues: u1 (ref), u3 (ref)
        u1.Enable(false);
        u3:Cleanup();
    end);
end;

function u1.new() -- Line: 163
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "BombDefuse";
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup.AutoLocalize = false;
    CanvasGroup.BackgroundTransparency = 1;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.7);
    CanvasGroup.Size = UDim2.fromScale(0.6, 0.24);
    local CanvasGroup2 = Instance.new("CanvasGroup");
    CanvasGroup2.Name = "Background";
    CanvasGroup2.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup2.AutoLocalize = false;
    CanvasGroup2.BackgroundTransparency = 1;
    CanvasGroup2.GroupColor3 = Color3.fromRGB(255, 32, 32);
    CanvasGroup2.GroupTransparency = 0.33;
    CanvasGroup2.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup2.Size = UDim2.fromScale(1, 1);
    CanvasGroup2.ZIndex = 0;
    local Frame = Instance.new("Frame");
    Frame.Name = "Main";
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0, 0.5);
    Frame.Size = UDim2.fromScale(1, 0.5);
    Frame.ZIndex = -1;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.AutoLocalize = false;
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.Position = UDim2.fromScale(0.5, 0.5);
    Frame2.Size = UDim2.fromScale(0.5, 1);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.BackgroundTransparency = 1;
    Frame3.Position = UDim2.fromScale(0.1, 0.5);
    Frame3.Size = UDim2.fromScale(0.8, 0.8);
    Frame3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Right";
    Frame4.AnchorPoint = Vector2.new(1, 0);
    Frame4.BackgroundTransparency = 1;
    Frame4.ClipsDescendants = true;
    Frame4.Position = UDim2.fromScale(1, 0);
    Frame4.Size = UDim2.fromScale(0.5, 1);
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Frame";
    Frame5.AnchorPoint = Vector2.new(1, 0);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.Position = UDim2.fromScale(1, 0);
    Frame5.Size = UDim2.fromScale(1, 1);
    Frame5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.5, 0);
    UICorner.Parent = Frame5;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame5;
    Frame5.Parent = Frame4;
    Frame4.Parent = Frame3;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Left";
    Frame6.BackgroundTransparency = 1;
    Frame6.ClipsDescendants = true;
    Frame6.Size = UDim2.fromScale(0.5, 1);
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "Frame";
    Frame7.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame7.Size = UDim2.fromScale(1, 1);
    Frame7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0.5, 0);
    UICorner2.Parent = Frame7;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Rotation = -180;
    UIGradient2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.501, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient2.Parent = Frame7;
    Frame7.Parent = Frame6;
    Frame6.Parent = Frame3;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Center";
    Frame8.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame8.BackgroundColor3 = Color3.new();
    Frame8.Position = UDim2.fromScale(0.5, 0.5);
    Frame8.Size = UDim2.fromScale(0.85, 0.85);
    Frame8.ZIndex = 2;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.Name = "UICorner";
    UICorner3.CornerRadius = UDim.new(0.5, 0);
    UICorner3.Parent = Frame8;
    Frame8.Parent = Frame3;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "Background";
    Frame9.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame9.BackgroundColor3 = Color3.new();
    Frame9.BackgroundTransparency = 0.6;
    Frame9.Position = UDim2.fromScale(0.5, 0.5);
    Frame9.Size = UDim2.fromScale(1, 1);
    Frame9.ZIndex = 0;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.Name = "UICorner";
    UICorner4.CornerRadius = UDim.new(0.5, 0);
    UICorner4.Parent = Frame9;
    Frame9.Parent = Frame3;
    Frame3.Parent = Frame2;
    local UICorner5 = Instance.new("UICorner");
    UICorner5.Name = "UICornerF";
    UICorner5.CornerRadius = UDim.new(0.04, 0);
    UICorner5.Parent = Frame2;
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradientF1";
    UIGradient3.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.287197, Color3.fromRGB(70, 70, 70)),
        ColorSequenceKeypoint.new(0.489619, Color3.new()),
        ColorSequenceKeypoint.new(0.685121, Color3.fromRGB(70, 70, 70)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    });
    UIGradient3.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.299465, 0),
        NumberSequenceKeypoint.new(0.5, 0.120219),
        NumberSequenceKeypoint.new(0.700535, 0),
        NumberSequenceKeypoint.new(1, 0)
    });
    UIGradient3.Parent = Frame2;
    Frame2.Parent = Frame;
    Frame.Parent = CanvasGroup2;
    CanvasGroup2.Parent = CanvasGroup;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraintF";
    UIAspectRatioConstraint.AspectRatio = 4.2;
    UIAspectRatioConstraint.Parent = CanvasGroup;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Main";
    Frame10.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame10.BackgroundTransparency = 1;
    Frame10.ClipsDescendants = true;
    Frame10.Position = UDim2.fromScale(0.5, 0.5);
    Frame10.Size = UDim2.fromScale(0.5, 0.5);
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "Flash";
    Frame11.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame11.AutoLocalize = false;
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(0.5, 0.5);
    Frame11.Size = UDim2.fromScale(0.5, 0.5);
    Frame11.ZIndex = 5;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.Name = "UICornerF";
    UICorner6.CornerRadius = UDim.new(0.1, 0);
    UICorner6.Parent = Frame11;
    Frame11.Parent = Frame10;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ImageLabel";
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://99302422432592";
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.1, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.8, 0.8);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "ImageLabel";
    ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://99302422432592";
    ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(1.6, 0.8);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeXX;
    ImageLabel2.Parent = ImageLabel;
    ImageLabel.Parent = Frame10;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(1, 0);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.9, 0.1);
    TextLabel.RichText = true;
    TextLabel.Size = UDim2.fromScale(0.6, 0.18);
    TextLabel.Text = `{LocalPlayer.Name} is defusing the bomb.`;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame10;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Time";
    TextLabel2.AnchorPoint = Vector2.new(1, 1);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.9, 0.85);
    TextLabel2.RichText = true;
    TextLabel2.Size = UDim2.fromScale(0.4, 0.2);
    TextLabel2.Text = "00:00.000";
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.3;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Frame10;
    Frame10.Parent = CanvasGroup;
    local CanvasGroup3 = Instance.new("CanvasGroup");
    CanvasGroup3.Name = "ColorBackground";
    CanvasGroup3.AnchorPoint = Vector2.new(0.5, 0.5);
    CanvasGroup3.AutoLocalize = false;
    CanvasGroup3.BackgroundTransparency = 1;
    CanvasGroup3.GroupColor3 = Color3.fromRGB(255, 32, 32);
    CanvasGroup3.Position = UDim2.fromScale(0.5, 0.5);
    CanvasGroup3.Size = UDim2.new(1, -2, 1, 0);
    CanvasGroup3.ZIndex = 0;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Main";
    Frame12.AnchorPoint = Vector2.new(0, 0.5);
    Frame12.AutoLocalize = false;
    Frame12.BackgroundTransparency = 1;
    Frame12.Position = UDim2.fromScale(0, 0.5);
    Frame12.Size = UDim2.fromScale(1, 0.5);
    Frame12.ZIndex = -1;
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "Frame";
    Frame13.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame13.AutoLocalize = false;
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(0.5, 0.5);
    Frame13.Size = UDim2.fromScale(0.5, 1);
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Left";
    Frame14.AnchorPoint = Vector2.new(1, 0);
    Frame14.AutoLocalize = false;
    Frame14.BackgroundTransparency = 1;
    Frame14.ClipsDescendants = true;
    Frame14.Size = UDim2.fromScale(0.1, 1);
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Color";
    Frame15.AutoLocalize = false;
    Frame15.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame15.ClipsDescendants = true;
    Frame15.Position = UDim2.fromScale(0.9, 0);
    Frame15.Size = UDim2.fromScale(10, 1);
    local UICorner7 = Instance.new("UICorner");
    UICorner7.Name = "UICorner";
    UICorner7.CornerRadius = UDim.new(0.1, 0);
    UICorner7.Parent = Frame15;
    Frame15.Parent = Frame14;
    Frame14.Parent = Frame13;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "Right";
    Frame16.AutoLocalize = false;
    Frame16.BackgroundTransparency = 1;
    Frame16.ClipsDescendants = true;
    Frame16.Position = UDim2.fromScale(1, 0);
    Frame16.Size = UDim2.fromScale(0.1, 1);
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Color";
    Frame17.AnchorPoint = Vector2.new(1, 0);
    Frame17.AutoLocalize = false;
    Frame17.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame17.ClipsDescendants = true;
    Frame17.Position = UDim2.fromScale(0.1, 0);
    Frame17.Size = UDim2.fromScale(10, 1);
    local UICorner8 = Instance.new("UICorner");
    UICorner8.Name = "UICorner";
    UICorner8.CornerRadius = UDim.new(0.1, 0);
    UICorner8.Parent = Frame17;
    Frame17.Parent = Frame16;
    Frame16.Parent = Frame13;
    Frame13.Parent = Frame12;
    Frame12.Parent = CanvasGroup3;
    CanvasGroup3.Parent = CanvasGroup;
    CanvasGroup.Parent = u2.Handler.HUD;

    return CanvasGroup;
end;

return u1;