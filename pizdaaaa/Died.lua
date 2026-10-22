-- ReplicatedStorage.GameClient.Gui.HUD.Died
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Died
-- Decompile time: 15.19 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
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

local function GetOrCreateColorCorrection() -- Line: 31
    -- upvalues: Lighting (copy)
    local ColorCorrectionDied = Lighting:FindFirstChild("ColorCorrectionDied");

    if ColorCorrectionDied then
        return ColorCorrectionDied, false;
    end;

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "ColorCorrectionDied";
    ColorCorrectionEffect.Parent = Lighting;

    return ColorCorrectionEffect, true;
end;

local function FormatDamageLine(p17: string, p18: number, p19: number) -- Line: 43
    return string.format("<font weight=\"SemiBold\" transparency=\"0.5\">%s</font> %d <font weight=\"SemiBold\" transparency=\"0.5\">in</font> %d %s", p17, p18, p19, p19 == 1 and "hit" or "hits");
end;

function u1.Cleanup() -- Line: 50
    -- upvalues: u4 (ref), Lighting (copy)
    u4.LocalFrame.Visible = false;
    u4.GlobalFrame.Visible = false;
    local ColorCorrectionDied = Lighting:FindFirstChild("ColorCorrectionDied");

    if ColorCorrectionDied then
        ColorCorrectionDied:Destroy();
    end;
end;

function u1.UpdatePin(p20, p21) -- Line: 60
    -- upvalues: HttpService (copy), u6 (ref)
    if p20 then
        p20 = p20:GetAttribute("WeaponLoadout");
    end;

    if not p20 then
        return;
    end;

    local v22 = HttpService:JSONDecode(p20).CT["19"];

    if v22 then
        v22 = v22.SkinName;
    end;

    if v22 == "None" then
        p21.BadgeIcon.Visible = false;
        p21.BadgeName.Visible = false;

        return;
    end;

    local Item = u6.GetItem("Badges", v22);
    p21.BadgeIcon.Image = Item.Asset;
    p21.BadgeName.Text = v22;
    p21.BadgeIcon.Visible = true;
    p21.BadgeName.Visible = true;
end;

function u1.LocalUser(p23: string) -- Line: 84
    -- upvalues: u16 (ref), Lighting (copy), u1 (copy), LocalPlayer (copy), u4 (ref), TweenService (copy), u10 (ref), u5 (ref)
    u16 = u16 + 1;
    local u24 = u16;
    local ColorCorrectionDied = Lighting:FindFirstChild("ColorCorrectionDied");
    local u25;

    if ColorCorrectionDied then
        u25 = false;
    else
        ColorCorrectionDied = Instance.new("ColorCorrectionEffect");
        ColorCorrectionDied.Name = "ColorCorrectionDied";
        ColorCorrectionDied.Parent = Lighting;
        u25 = true;
    end;

    local TintColor = ColorCorrectionDied.TintColor;
    u1.UpdatePin(LocalPlayer, u4.LocalFrame.Main.Badge);
    u4.LocalFrame.Main.PlayerFrame.Reason.Text = p23;
    u4.LocalFrame.Position = UDim2.fromScale(0.5, -0.2);
    u4.LocalFrame.Visible = true;
    TweenService:Create(u4.LocalFrame, TweenInfo.new(0.5), {
        Position = UDim2.fromScale(0.5, 0.52)
    }):Play();

    if not (u10.FramePriority.MainMenu or u10.FramePriority.MatchEnd) then
        TweenService:Create(ColorCorrectionDied, TweenInfo.new(0.9), {
            TintColor = Color3.fromRGB(173, 0, 0)
        }):Play();
    end;

    u5:Delay(0.4, function() -- Line: 108
        -- upvalues: u16 (ref), u24 (copy), u10 (ref), TweenService (ref), ColorCorrectionDied (copy), u5 (ref), TintColor (copy), u25 (copy), u4 (ref)
        if u16 ~= u24 then
            return;
        end;

        if not (u10.FramePriority.MainMenu or u10.FramePriority.MatchEnd) then
            TweenService:Create(ColorCorrectionDied, TweenInfo.new(0.3), {
                TintColor = Color3.fromRGB(0, 0, 0)
            }):Play();
        end;

        u5:Delay(3.5, function() -- Line: 120
            -- upvalues: u16 (ref), u24 (ref), u10 (ref), TweenService (ref), ColorCorrectionDied (ref), TintColor (ref), u25 (ref), u4 (ref)
            if u16 ~= u24 then
                return;
            end;

            if not (u10.FramePriority.MainMenu or u10.FramePriority.MatchEnd) then
                TweenService:Create(ColorCorrectionDied, TweenInfo.new(0.5), {
                    TintColor = TintColor
                }):Play();
            end;

            if u25 then
                task.delay(0.5, function() -- Line: 133
                    -- upvalues: ColorCorrectionDied (ref)
                    if ColorCorrectionDied then
                        ColorCorrectionDied:Destroy();
                    end;
                end);
            end;

            u4.LocalFrame.Visible = false;
        end);
    end);
end;

function u1.User(p26: string, p27: string, p28: string, p29: string, p30: number, p31: number, p32: number, p33: number) -- Line: 145
    -- upvalues: u16 (ref), Lighting (copy), Players (copy), u14 (ref), u13 (ref), u1 (copy), u4 (ref), u10 (ref), TweenService (copy), u5 (ref)
    u16 = u16 + 1;
    local u34 = u16;
    local ColorCorrectionDied = Lighting:FindFirstChild("ColorCorrectionDied");
    local u35;

    if ColorCorrectionDied then
        u35 = false;
    else
        ColorCorrectionDied = Instance.new("ColorCorrectionEffect");
        ColorCorrectionDied.Name = "ColorCorrectionDied";
        ColorCorrectionDied.Parent = Lighting;
        u35 = true;
    end;

    local TintColor = ColorCorrectionDied.TintColor;
    local PlayerByUserId = Players:GetPlayerByUserId(p28);
    local v36 = u14.GetWeaponSkin(p27, p29) or u14.GetWeaponSkin(p27, "Stock");
    local v37 = u13[v36.Rarity];
    u1.UpdatePin(PlayerByUserId, u4.GlobalFrame.Main.Badge);
    u4.GlobalFrame.Main.PlayerFrame.Reason.Text = `<font color="rgb(220, 28, 32)">{p26} </font><font color="rgb({math.round(v37.R * 255)},{math.round(v37.G * 255)},{math.round(v37.B * 255)})">{p27} | {p29}</font>`;
    u4.GlobalFrame.Position = UDim2.fromScale(0.5, -0.2);
    u4.GlobalFrame.WeaponFrame.Image = `rbxassetid://{v36.Thumbnail}`;
    u4.GlobalFrame.Main.PlayerFrame.Icon.Image = `rbxthumb://type=AvatarHeadShot&id={p28}&w=420&h=420`;
    local TextDamageGiven = u4.GlobalFrame.Main.DamageGiven.TextDamageGiven;
    local TextDamageTaken = u4.GlobalFrame.Main.DamageTaken.TextDamageTaken;
    TextDamageGiven.RichText = true;
    TextDamageTaken.RichText = true;

    if p32 and p32 > 0 then
        local v38 = p33 or 0;
        TextDamageGiven.Text = string.format("<font weight=\"SemiBold\" transparency=\"0.5\">%s</font> %d <font weight=\"SemiBold\" transparency=\"0.5\">in</font> %d %s", "Damage given:", p32, v38, v38 == 1 and "hit" or "hits");
    else
        TextDamageGiven.Text = string.format(
            "<font weight=\"SemiBold\" transparency=\"0.5\">%s</font> %d <font weight=\"SemiBold\" transparency=\"0.5\">in</font> %d %s",
            "Damage given:",
            0,
            0,
            "hits"
        );
    end;

    if p30 and p30 > 0 then
        local v39 = p31 or 0;
        TextDamageTaken.Text = string.format("<font weight=\"SemiBold\" transparency=\"0.5\">%s</font> %d <font weight=\"SemiBold\" transparency=\"0.5\">in</font> %d %s", "Damage taken:", p30, v39, v39 == 1 and "hit" or "hits");
    else
        TextDamageTaken.Text = string.format(
            "<font weight=\"SemiBold\" transparency=\"0.5\">%s</font> %d <font weight=\"SemiBold\" transparency=\"0.5\">in</font> %d %s",
            "Damage taken:",
            0,
            0,
            "hits"
        );
    end;

    if PlayerByUserId then
        u4.GlobalFrame.Main.PlayerFrame.PlayerName.Text = PlayerByUserId.Name;
    end;

    local u40 = (u10.FramePriority.MainMenu or u10.FramePriority.MatchEnd) and true or nil;

    if not u40 then
        TweenService:Create(ColorCorrectionDied, TweenInfo.new(0.9), {
            TintColor = Color3.fromRGB(173, 0, 0)
        }):Play();
    end;

    u4.GlobalFrame.Visible = true;
    TweenService:Create(u4.GlobalFrame, TweenInfo.new(0.5), {
        Position = UDim2.fromScale(0.5, 0.52)
    }):Play();
    u5:Delay(0.4, function() -- Line: 204
        -- upvalues: u16 (ref), u34 (copy), u10 (ref), u40 (ref), TweenService (ref), ColorCorrectionDied (copy), u5 (ref), TintColor (copy), u35 (copy), u4 (ref)
        if u16 ~= u34 then
            return;
        end;

        if u10.FramePriority.MainMenu or u10.FramePriority.MatchEnd then
            u40 = true;
        end;

        if not u40 then
            TweenService:Create(ColorCorrectionDied, TweenInfo.new(0.3), {
                TintColor = Color3.fromRGB(0, 0, 0)
            }):Play();
        end;

        u5:Delay(3.5, function() -- Line: 215
            -- upvalues: u16 (ref), u34 (ref), u10 (ref), u40 (ref), TweenService (ref), ColorCorrectionDied (ref), TintColor (ref), u35 (ref), u4 (ref)
            if u16 ~= u34 then
                return;
            end;

            if u10.FramePriority.MainMenu or u10.FramePriority.MatchEnd then
                u40 = true;
            end;

            if not u40 then
                TweenService:Create(ColorCorrectionDied, TweenInfo.new(0.5), {
                    TintColor = TintColor
                }):Play();
            end;

            if u35 then
                task.delay(0.5, function() -- Line: 227
                    -- upvalues: ColorCorrectionDied (ref)
                    if ColorCorrectionDied then
                        ColorCorrectionDied:Destroy();
                    end;
                end);
            end;

            u4.GlobalFrame.Visible = false;
        end);
    end);
end;

function u1.Init(p41) -- Line: 239
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u15 (ref), u11 (ref), u14 (ref), u13 (ref), u10 (ref)
    u2 = p41:GetModule("Gui");
    u3 = p41:GetModule("Maid").new();
    u5 = p41:GetModule("Threads");
    u6 = p41:GetModule("ItemManager");
    u7 = p41:GetModule("Network");
    u8 = p41:GetModule("Enums");
    u9 = p41:GetModule("CameraController");
    u15 = p41:GetModule("WeaponManager");
    u11 = p41:GetModule("CharacterController");
    u14 = p41:GetModule("SkinManager");
    u13 = p41:GetModule("RarityColors");
    u10 = p41:GetModule("BindsController");
end;

function u1.Start(p42) -- Line: 254
    -- upvalues: u4 (ref), u1 (copy), u12 (ref), u2 (ref), u7 (ref), GameStats (copy), u10 (ref), LocalPlayer (copy), u8 (ref), u9 (ref), u11 (ref), u16 (ref)
    u4 = u1.new();
    u12 = u2.GetComponent("Haptics");
    u7.Gui.DiedUpdate.On(function(p43) -- Line: 258
        -- upvalues: u12 (ref), GameStats (ref), u10 (ref), LocalPlayer (ref), u1 (ref), u8 (ref), u9 (ref)
        u12.Death();
        local Attribute = GameStats:GetAttribute("State");

        if Attribute == "Warmup" or Attribute == "MatchEnded" then
            return;
        end;

        if u10.FramePriority.MainMenu or u10.FramePriority.MatchEnd then
            return;
        end;

        if p43.Killer == LocalPlayer.UserId then
            u1.LocalUser(u8.Reason[p43.Reason]);

            return;
        end;

        u9.StartDeathCam(p43.DeathPosition, p43.KillerIdentifier);
        u1.User(u8.Reason[p43.Reason], u8.Weapons[p43.Weapon], p43.Killer, p43.WeaponSkin, p43.DamageTaken, p43.HitsTaken, p43.DamageGiven, p43.HitsGiven);
    end);
    u11.OnCharacterSpawn:Connect(function(p44) -- Line: 279
        -- upvalues: u16 (ref), u1 (ref)
        u16 = u16 + 1;
        u1.Cleanup();
    end);

    local function OnStateChanged() -- Line: 284
        -- upvalues: GameStats (ref), u16 (ref), u1 (ref)
        if GameStats:GetAttribute("State") == "MatchEnded" then
            u16 = u16 + 1;
            u1.Cleanup();
        end;
    end;

    GameStats:GetAttributeChangedSignal("State"):Connect(OnStateChanged);

    if GameStats:GetAttribute("State") == "MatchEnded" then
        u16 = u16 + 1;
        u1.Cleanup();
    end;
end;

function u1.new() -- Line: 296
    -- upvalues: LocalPlayer (copy), u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "ui";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.ZIndex = 99;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "LocalFrame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0);
    Frame2.BackgroundTransparency = 1;
    Frame2.Position = UDim2.fromScale(0.5, 0.52);
    Frame2.Size = UDim2.fromScale(0.225, 0.114);
    Frame2.Visible = false;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 3.122;
    UIAspectRatioConstraint.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Blur";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://108060254555731";
    ImageLabel.ImageColor3 = Color3.new();
    ImageLabel.ImageTransparency = 0.8;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.ZIndex = 0;
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "Blur2";
    ImageButton.Active = false;
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton.AutoButtonColor = false;
    ImageButton.AutoLocalize = false;
    ImageButton.BackgroundColor3 = Color3.fromRGB(53, 53, 53);
    ImageButton.BackgroundTransparency = 0.15;
    ImageButton.BorderColor3 = Color3.new();
    ImageButton.BorderSizePixel = 0;
    ImageButton.Image = "rbxassetid://17293653421";
    ImageButton.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton.Size = UDim2.fromScale(1, 1);
    ImageButton.ZIndex = 0;
    ImageButton.Parent = ImageLabel;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "DOTS";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://91991932054752";
    ImageLabel2.ImageColor3 = Color3.new();
    ImageLabel2.ImageTransparency = 0.8;
    ImageLabel2.LayoutOrder = -1;
    ImageLabel2.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel2.ScaleType = Enum.ScaleType.Tile;
    ImageLabel2.Size = UDim2.fromScale(1, 1);
    ImageLabel2.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel2.ZIndex = -1;
    ImageLabel2.Parent = ImageLabel;
    ImageLabel.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Main";
    Frame3.BackgroundTransparency = 1;
    Frame3.Size = UDim2.fromScale(1, 1);
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "PlayerFrame";
    Frame4.BackgroundTransparency = 1;
    Frame4.Position = UDim2.fromScale(0, 0.218);
    Frame4.Size = UDim2.fromScale(1, 0.682);
    Frame4.ZIndex = 5;
    local ImageButton2 = Instance.new("ImageButton");
    ImageButton2.Name = "Icon";
    ImageButton2.Active = false;
    ImageButton2.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton2.AutoButtonColor = false;
    ImageButton2.AutoLocalize = false;
    ImageButton2.BackgroundColor3 = Color3.new();
    ImageButton2.Image = `rbxthumb://type=AvatarHeadShot&id={LocalPlayer.UserId}&w=420&h=420`;
    ImageButton2.Position = UDim2.fromScale(0.025, 0.5);
    ImageButton2.Size = UDim2.fromScale(0.8, 0.8);
    ImageButton2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton2.ZIndex = 2;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 4);
    UICorner.Parent = ImageButton2;
    ImageButton2.Parent = Frame4;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "PlayerName";
    TextLabel.AnchorPoint = Vector2.new(0, 1);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.new(0.2, 5, 0.52, 0);
    TextLabel.Size = UDim2.fromScale(0.75, 0.3);
    TextLabel.Text = LocalPlayer.Name;
    TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = Frame4;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Reason";
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Italic);
    TextLabel2.Position = UDim2.new(0.2, 5, 0.5, 0);
    TextLabel2.Size = UDim2.fromScale(0.75, 0.26);
    TextLabel2.Text = "You burned to death";
    TextLabel2.TextColor3 = Color3.fromRGB(220, 28, 32);
    TextLabel2.TextScaled = true;
    TextLabel2.TextTransparency = 0.1;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Line";
    Frame5.AnchorPoint = Vector2.new(0, 1);
    Frame5.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame5.BorderColor3 = Color3.new();
    Frame5.BorderSizePixel = 0;
    Frame5.Position = UDim2.fromScale(0, 1);
    Frame5.Size = UDim2.new(1, 0, 0, 3);
    Frame5.Visible = false;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient.Rotation = 90;
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.6), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame5;
    Frame5.Parent = Frame4;
    Frame4.Parent = Frame3;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "Badge";
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame6.BorderColor3 = Color3.new();
    Frame6.BorderSizePixel = 0;
    Frame6.Size = UDim2.new(1, 0, 0.156, 2);
    Frame6.ZIndex = 10;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "UIGradient";
    UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1) });
    UIGradient2.Parent = Frame6;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "BadgeIcon";
    ImageLabel3.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "rbxassetid://100429874437897";
    ImageLabel3.Position = UDim2.fromScale(0, -0.2);
    ImageLabel3.Size = UDim2.fromScale(3, 3);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.Parent = Frame6;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "BadgeName";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel3.Position = UDim2.fromScale(0.08, 0.5);
    TextLabel3.Size = UDim2.fromScale(0.5, 1);
    TextLabel3.Text = "Loyalty Badge";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel3.ZIndex = 9;
    TextLabel3.Parent = Frame6;
    Frame6.Parent = Frame3;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "DamageTaken";
    Frame7.AnchorPoint = Vector2.new(0, 1);
    Frame7.BackgroundTransparency = 1;
    Frame7.Position = UDim2.fromScale(0, 0.83);
    Frame7.Size = UDim2.fromScale(1, 0.17);
    Frame7.Visible = false;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "Line";
    Frame8.AnchorPoint = Vector2.new(0, 1);
    Frame8.BackgroundColor3 = Color3.fromRGB(255, 42, 46);
    Frame8.BorderColor3 = Color3.new();
    Frame8.BorderSizePixel = 0;
    Frame8.Position = UDim2.fromScale(0, 1);
    Frame8.Size = UDim2.new(1, 0, 0, 3);
    Frame8.Parent = Frame7;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "TextDamageTaken";
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.Position = UDim2.fromScale(0.025, 0);
    TextLabel4.RichText = true;
    TextLabel4.Size = UDim2.fromScale(0.9, 0.8);
    TextLabel4.Text = "<font weight=\"SemiBold\" transparency=\"0.5\">Damage taken:</font > 100 <font weight=\"SemiBold\" transparency=\"0.5\">in</font > 2 hits";
    TextLabel4.TextColor3 = Color3.new(1, 1, 1);
    TextLabel4.TextScaled = true;
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel4.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = Frame7;
    Frame7.Parent = Frame3;
    local Frame9 = Instance.new("Frame");
    Frame9.Name = "DamageGiven";
    Frame9.AnchorPoint = Vector2.new(0, 1);
    Frame9.BackgroundTransparency = 1;
    Frame9.Position = UDim2.fromScale(0, 1);
    Frame9.Size = UDim2.fromScale(1, 0.17);
    Frame9.Visible = false;
    local Frame10 = Instance.new("Frame");
    Frame10.Name = "Line";
    Frame10.AnchorPoint = Vector2.new(0, 1);
    Frame10.BackgroundColor3 = Color3.fromRGB(35, 138, 12);
    Frame10.BorderColor3 = Color3.new();
    Frame10.BorderSizePixel = 0;
    Frame10.Position = UDim2.fromScale(0, 1);
    Frame10.Size = UDim2.new(1, 0, 0, 3);
    Frame10.Parent = Frame9;
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.Name = "TextDamageGiven";
    TextLabel5.AutoLocalize = false;
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel5.Position = UDim2.fromScale(0.025, 0);
    TextLabel5.RichText = true;
    TextLabel5.Size = UDim2.fromScale(0.9, 0.8);
    TextLabel5.Text = "<font weight=\"SemiBold\" transparency=\"0.5\">Damage given:</font > 100 <font weight=\"SemiBold\" transparency=\"0.5\">in</font > 2 hits";
    TextLabel5.TextColor3 = Color3.new(1, 1, 1);
    TextLabel5.TextScaled = true;
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel5.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel5.ZIndex = 9;
    TextLabel5.Parent = Frame9;
    Frame9.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = Frame;
    local Frame11 = Instance.new("Frame");
    Frame11.Name = "GlobalFrame";
    Frame11.AnchorPoint = Vector2.new(0.5, 0);
    Frame11.BackgroundTransparency = 1;
    Frame11.Position = UDim2.fromScale(0.5, 0.52);
    Frame11.Size = UDim2.fromScale(0.275, 0.14);
    Frame11.Visible = false;
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint2.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint2.AspectRatio = 3.56;
    UIAspectRatioConstraint2.Parent = Frame11;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Blur";
    ImageLabel4.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://108060254555731";
    ImageLabel4.ImageColor3 = Color3.new();
    ImageLabel4.ImageTransparency = 0.8;
    ImageLabel4.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel4.Size = UDim2.fromScale(1, 1);
    ImageLabel4.ZIndex = 0;
    local ImageButton3 = Instance.new("ImageButton");
    ImageButton3.Name = "Blur2";
    ImageButton3.Active = false;
    ImageButton3.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageButton3.AutoButtonColor = false;
    ImageButton3.AutoLocalize = false;
    ImageButton3.BackgroundColor3 = Color3.fromRGB(53, 53, 53);
    ImageButton3.BackgroundTransparency = 0.15;
    ImageButton3.BorderColor3 = Color3.new();
    ImageButton3.BorderSizePixel = 0;
    ImageButton3.Image = "rbxassetid://17293653421";
    ImageButton3.Position = UDim2.fromScale(0.5, 0.5);
    ImageButton3.Size = UDim2.fromScale(1, 1);
    ImageButton3.ZIndex = 0;
    ImageButton3.Parent = ImageLabel4;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "DOTS";
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://91991932054752";
    ImageLabel5.ImageColor3 = Color3.new();
    ImageLabel5.ImageTransparency = 0.8;
    ImageLabel5.LayoutOrder = -1;
    ImageLabel5.Position = UDim2.fromScale(0, 0.00185185);
    ImageLabel5.ScaleType = Enum.ScaleType.Tile;
    ImageLabel5.Size = UDim2.fromScale(1, 1);
    ImageLabel5.TileSize = UDim2.new(0, 512, 0, 512);
    ImageLabel5.ZIndex = -1;
    ImageLabel5.Parent = ImageLabel4;
    ImageLabel4.Parent = Frame11;
    local Frame12 = Instance.new("Frame");
    Frame12.Name = "Main";
    Frame12.BackgroundTransparency = 1;
    Frame12.Size = UDim2.fromScale(0.727, 1);
    local Frame13 = Instance.new("Frame");
    Frame13.Name = "PlayerFrame";
    Frame13.BackgroundTransparency = 1;
    Frame13.Position = UDim2.fromScale(0, 0.12);
    Frame13.Size = UDim2.fromScale(1, 0.54);
    Frame13.ZIndex = 5;
    local ImageButton4 = Instance.new("ImageButton");
    ImageButton4.Name = "Icon";
    ImageButton4.Active = false;
    ImageButton4.AnchorPoint = Vector2.new(0, 0.5);
    ImageButton4.AutoButtonColor = false;
    ImageButton4.AutoLocalize = false;
    ImageButton4.BackgroundColor3 = Color3.new();
    ImageButton4.Image = `rbxthumb://type=AvatarHeadShot&id={LocalPlayer.UserId}&w=420&h=420`;
    ImageButton4.Position = UDim2.fromScale(0.025, 0.5);
    ImageButton4.Size = UDim2.fromScale(0.8, 0.8);
    ImageButton4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton4.ZIndex = 2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.Name = "UICorner";
    UICorner2.CornerRadius = UDim.new(0, 4);
    UICorner2.Parent = ImageButton4;
    ImageButton4.Parent = Frame13;
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.Name = "PlayerName";
    TextLabel6.AnchorPoint = Vector2.new(0, 1);
    TextLabel6.AutoLocalize = false;
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
    TextLabel6.Position = UDim2.new(0.2, 5, 0.52, 0);
    TextLabel6.Size = UDim2.fromScale(0.75, 0.3);
    TextLabel6.Text = LocalPlayer.Name;
    TextLabel6.TextColor3 = Color3.fromRGB(220, 220, 220);
    TextLabel6.TextScaled = true;
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel6.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel6.ZIndex = 9;
    TextLabel6.Parent = Frame13;
    local TextLabel7 = Instance.new("TextLabel");
    TextLabel7.Name = "Reason";
    TextLabel7.AutoLocalize = false;
    TextLabel7.BackgroundTransparency = 1;
    TextLabel7.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Italic);
    TextLabel7.Position = UDim2.new(0.2, 5, 0.5, 0);
    TextLabel7.Size = UDim2.fromScale(0.75, 0.26);
    TextLabel7.Text = "You burned to death";
    TextLabel7.TextColor3 = Color3.fromRGB(220, 28, 32);
    TextLabel7.TextScaled = true;
    TextLabel7.TextTransparency = 0.1;
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel7.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel7.ZIndex = 9;
    TextLabel7.RichText = true;
    TextLabel7.Parent = Frame13;
    local Frame14 = Instance.new("Frame");
    Frame14.Name = "Line";
    Frame14.AnchorPoint = Vector2.new(0, 1);
    Frame14.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame14.BorderColor3 = Color3.new();
    Frame14.BorderSizePixel = 0;
    Frame14.Position = UDim2.fromScale(0, 1);
    Frame14.Size = UDim2.new(1, 0, 0, 3);
    local UIGradient3 = Instance.new("UIGradient");
    UIGradient3.Name = "UIGradient";
    UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient3.Rotation = 90;
    UIGradient3.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.6), NumberSequenceKeypoint.new(1, 1) });
    UIGradient3.Parent = Frame14;
    Frame14.Parent = Frame13;
    Frame13.Parent = Frame12;
    local Frame15 = Instance.new("Frame");
    Frame15.Name = "Badge";
    Frame15.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame15.BorderColor3 = Color3.new();
    Frame15.BorderSizePixel = 0;
    Frame15.Size = UDim2.new(1, 0, 0.12, 2);
    Frame15.ZIndex = 10;
    local UIGradient4 = Instance.new("UIGradient");
    UIGradient4.Name = "UIGradient";
    UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient4.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1) });
    UIGradient4.Parent = Frame15;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "BadgeIcon";
    ImageLabel6.AnchorPoint = Vector2.new(0.5, 0);
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://100429874437897";
    ImageLabel6.Position = UDim2.fromScale(0, -0.2);
    ImageLabel6.Size = UDim2.fromScale(3, 3);
    ImageLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel6.Parent = Frame15;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.Name = "BadgeName";
    TextLabel8.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel8.AutoLocalize = false;
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    TextLabel8.Position = UDim2.fromScale(0.08, 0.5);
    TextLabel8.Size = UDim2.fromScale(0.5, 1);
    TextLabel8.Text = "Loyalty Badge";
    TextLabel8.TextColor3 = Color3.new(1, 1, 1);
    TextLabel8.TextScaled = true;
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel8.ZIndex = 9;
    TextLabel8.Parent = Frame15;
    Frame15.Parent = Frame12;
    local Frame16 = Instance.new("Frame");
    Frame16.Name = "DamageTaken";
    Frame16.AnchorPoint = Vector2.new(0, 1);
    Frame16.BackgroundTransparency = 1;
    Frame16.Position = UDim2.fromScale(0, 0.83);
    Frame16.Size = UDim2.fromScale(1, 0.17);
    local Frame17 = Instance.new("Frame");
    Frame17.Name = "Line";
    Frame17.AnchorPoint = Vector2.new(0, 1);
    Frame17.BackgroundColor3 = Color3.fromRGB(255, 42, 46);
    Frame17.BorderColor3 = Color3.new();
    Frame17.BorderSizePixel = 0;
    Frame17.Position = UDim2.fromScale(0, 1);
    Frame17.Size = UDim2.new(1, 0, 0, 3);
    Frame17.Parent = Frame16;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "TextDamageTaken";
    TextLabel9.AutoLocalize = false;
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel9.Position = UDim2.fromScale(0.025, 0);
    TextLabel9.RichText = true;
    TextLabel9.Size = UDim2.fromScale(0.9, 0.8);
    TextLabel9.Text = "<font weight=\"SemiBold\" transparency=\"0.5\">Damage taken:</font > 100 <font weight=\"SemiBold\" transparency=\"0.5\">in</font > 2 hits";
    TextLabel9.TextColor3 = Color3.new(1, 1, 1);
    TextLabel9.TextScaled = true;
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel9.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel9.ZIndex = 9;
    TextLabel9.Parent = Frame16;
    Frame16.Parent = Frame12;
    local Frame18 = Instance.new("Frame");
    Frame18.Name = "DamageGiven";
    Frame18.AnchorPoint = Vector2.new(0, 1);
    Frame18.BackgroundTransparency = 1;
    Frame18.Position = UDim2.fromScale(0, 1);
    Frame18.Size = UDim2.fromScale(1, 0.17);
    local Frame19 = Instance.new("Frame");
    Frame19.Name = "Line";
    Frame19.AnchorPoint = Vector2.new(0, 1);
    Frame19.BackgroundColor3 = Color3.fromRGB(35, 138, 12);
    Frame19.BorderColor3 = Color3.new();
    Frame19.BorderSizePixel = 0;
    Frame19.Position = UDim2.fromScale(0, 1);
    Frame19.Size = UDim2.new(1, 0, 0, 3);
    Frame19.Parent = Frame18;
    local TextLabel10 = Instance.new("TextLabel");
    TextLabel10.Name = "TextDamageGiven";
    TextLabel10.AutoLocalize = false;
    TextLabel10.BackgroundTransparency = 1;
    TextLabel10.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel10.Position = UDim2.fromScale(0.025, 0);
    TextLabel10.RichText = true;
    TextLabel10.Size = UDim2.fromScale(0.9, 0.8);
    TextLabel10.Text = "<font weight=\"SemiBold\" transparency=\"0.5\">Damage given:</font > 100 <font weight=\"SemiBold\" transparency=\"0.5\">in</font > 2 hits";
    TextLabel10.TextColor3 = Color3.new(1, 1, 1);
    TextLabel10.TextScaled = true;
    TextLabel10.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel10.TextYAlignment = Enum.TextYAlignment.Bottom;
    TextLabel10.ZIndex = 9;
    TextLabel10.Parent = Frame18;
    Frame18.Parent = Frame12;
    Frame12.Parent = Frame11;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "WeaponFrame";
    ImageLabel7.AnchorPoint = Vector2.new(1, 0);
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://100429874437897";
    ImageLabel7.Position = UDim2.fromScale(1, 0);
    ImageLabel7.ScaleType = Enum.ScaleType.Fit;
    ImageLabel7.Size = UDim2.fromScale(0.275, 1);
    local Frame20 = Instance.new("Frame");
    Frame20.Name = "Line";
    Frame20.AnchorPoint = Vector2.new(0, 1);
    Frame20.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame20.BorderColor3 = Color3.new();
    Frame20.BorderSizePixel = 0;
    Frame20.Position = UDim2.fromScale(0, 1);
    Frame20.Size = UDim2.new(0, 3, 1, 0);
    local UIGradient5 = Instance.new("UIGradient");
    UIGradient5.Name = "UIGradient";
    UIGradient5.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) });
    UIGradient5.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.6), NumberSequenceKeypoint.new(1, 1) });
    UIGradient5.Parent = Frame20;
    Frame20.Parent = ImageLabel7;
    ImageLabel7.Parent = Frame11;
    Frame11.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

return u1;