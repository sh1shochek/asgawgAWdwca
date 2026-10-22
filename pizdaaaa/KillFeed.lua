-- ReplicatedStorage.GameClient.Gui.HUD.KillFeed
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.KillFeed
-- Decompile time: 16.67 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("HttpService");
game:GetService("ReplicatedStorage");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local Color3_fromRGB_ret = Color3.fromRGB(184, 214, 239);
local Color3_fromRGB_ret2 = Color3.fromRGB(234, 210, 139);

function u1.NewKill(p9: boolean, p10: boolean, p11: boolean, p12: boolean, p13: boolean, p14: string, p15: string, p16: number, p17: number, p18: string, p19: number?) -- Line: 33
    -- upvalues: u4 (ref), u7 (ref), u6 (ref), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Players (copy), u8 (ref), TweenService (copy)
    local u20 = u4.KillFrame:Clone();
    u20.AutomaticSize = Enum.AutomaticSize.X;
    local X = workspace.CurrentCamera.ViewportSize.X;
    local _ = X / 1920;
    u20.Flashed.Visible = p9 or false;
    u20.Freefall.Visible = p10 or false;
    u20.Headshot.Visible = p11 or false;
    u20.NoScope.Visible = p12 or false;
    u20.Wallbang.Visible = p13 or false;
    u20.Weapon.Visible = true;
    u20.SelfKill.Visible = false;
    u20.Space.Visible = false;
    u20.UIStroke.Transparency = 1;

    if p17 then
        local IconHorizontal = u7.Get(u6.Weapons[p17]).GuiInformation.IconHorizontal;
        u20.Weapon.Image = `rbxassetid://{IconHorizontal}`;

        if IconHorizontal == 137019640976200 then
            u20.Weapon.ScaleType = Enum.ScaleType.Fit;
            u20.Weapon.Size = UDim2.new(1, 0, 1, 0);
        else
            u20.Weapon.ScaleType = Enum.ScaleType.Crop;
            u20.Weapon.Size = UDim2.new(2.5, 0, 1, 0);
        end;
    end;

    u20.Victim.Text = p14;

    if p18 and (p18 ~= "" and (p15 ~= p14 and p18 ~= p15)) then
        u20.Killer.Text = `{p15} <font color="rgb(255,255,255)">+</font> {p18}`;
    else
        u20.Killer.Text = p15;
    end;

    if p15 == p14 then
        u20.Weapon.Visible = false;
        u20.SelfKill.Visible = true;
        u20.Victim.TextColor3 = u6.Teams[p16] == "CT" and Color3_fromRGB_ret or Color3_fromRGB_ret2;
        u20.Killer.TextColor3 = u6.Teams[p16] == "CT" and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    else
        if p19 then
            p19 = u6.Teams[p19];
        end;

        if p19 then
            u20.Victim.TextColor3 = p19 == "CT" and Color3_fromRGB_ret or Color3_fromRGB_ret2;
        else
            u20.Victim.TextColor3 = u6.Teams[p16] == "CT" and Color3_fromRGB_ret2 or Color3_fromRGB_ret;
        end;

        u20.Killer.TextColor3 = u6.Teams[p16] == "CT" and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    end;

    if (p15 == Players.LocalPlayer.Name or p18 == Players.LocalPlayer.Name) and p15 ~= p14 then
        u20.UIStroke.Transparency = 0;
    end;

    if p14 == Players.LocalPlayer.Name then
        u20.BackgroundColor3 = Color3.fromRGB(58, 7, 7);
    end;

    if p15 == Players.LocalPlayer.Name and p15 ~= p14 then
        u8.Play("Kill", p11 and 1 or 0.75);
    end;

    u20.Parent = u4;
    u20.Victim.Size = UDim2.new(0, u20.Victim.TextBounds.X + 4, 0.9, 0);
    u20.Killer.Size = UDim2.new(0, u20.Killer.TextBounds.X + 999, 0.9, 0);
    u20.Killer.Size = UDim2.new(0, u20.Killer.TextBounds.X + 4, 0.9, 0);
    u20.Visible = true;
    local v21 = 0;

    for _, child in ipairs(u20:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local v22;

            if child:IsA("TextLabel") then
                v22 = child.TextBounds.X + 4;
            else
                v22 = child.Size.X.Offset;

                if v22 == 0 then
                    v22 = child.Size.Y.Offset;
                end;
            end;

            v21 = v21 + (v22 + 5);
        end;
    end;

    u20.Size = UDim2.new(0, math.min(v21, X * 0.25), 0.16, 0);
    u20.UIScale.Scale = 0.85;
    TweenService:Create(u20, TweenInfo.new(0.3), {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(u20.UIScale, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();
    task.delay(5, function() -- Line: 151
        -- upvalues: TweenService (ref), u20 (copy)
        TweenService:Create(u20, TweenInfo.new(0.3), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u20.UIStroke, TweenInfo.new(0.05), {
            Transparency = 1
        }):Play();
        task.delay(0.3, function() -- Line: 155
            -- upvalues: TweenService (ref), u20 (ref)
            TweenService:Create(u20, TweenInfo.new(0.15), {
                Size = UDim2.new(u20.Size.X.Scale, u20.Size.X.Offset, 0, 0)
            }):Play();
            task.wait(0.15);
            u20:Destroy();
        end);
    end);
end;

function u1.Init(p23) -- Line: 169
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u7 (ref)
    u2 = p23:GetModule("Gui");
    u3 = p23:GetModule("Maid").new();
    u5 = p23:GetModule("Network");
    u6 = p23:GetModule("Enums");
    u7 = p23:GetModule("WeaponManager");
end;

function u1.Start(p24) -- Line: 177
    -- upvalues: u4 (ref), u1 (copy), u8 (ref), u2 (ref), u5 (ref)
    u4 = u1.new();
    u8 = u2.GetComponent("Haptics");
    u5.Gui.KillfeedUpdate.On(function(p25) -- Line: 181
        -- upvalues: u1 (ref)
        u1.NewKill(false, p25.Freefall, p25.Headshot, p25.NoScope, p25.Penetration, p25.Victim, p25.Killer, p25.KillerTeam, p25.WeaponEnum, p25.Assist, p25.VictimTeam);
    end);
end;

function u1.new() -- Line: 200
    -- upvalues: u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "Killfeed";
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.AutoLocalize = false;
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(1, 0.065);
    Frame.Size = UDim2.fromScale(0.5, 0.2);
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingRight = UDim.new(0.01, 0);
    UIPadding.PaddingTop = UDim.new(0.025, 0);
    UIPadding.Parent = Frame;
    local CanvasGroup = Instance.new("CanvasGroup");
    CanvasGroup.Name = "KillFrame";
    CanvasGroup.AutoLocalize = false;
    CanvasGroup.BackgroundColor3 = Color3.new();
    CanvasGroup.BackgroundTransparency = 0.25;
    CanvasGroup.GroupTransparency = 1;
    CanvasGroup.Position = UDim2.fromScale(-0.168789, 0.194327);
    CanvasGroup.Size = UDim2.new(0, 700, 0.16, 0);
    CanvasGroup.Visible = false;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0, 3);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = CanvasGroup;
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
    UIStroke.Transparency = 0.2;
    UIStroke.Parent = CanvasGroup;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = CanvasGroup;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Headshot";
    ImageLabel.AutoLocalize = false;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = "rbxassetid://118453876716328";
    ImageLabel.LayoutOrder = 52;
    ImageLabel.Position = UDim2.fromOffset(70, 2);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.ZIndex = 21;
    ImageLabel.Parent = CanvasGroup;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "SelfKill";
    ImageLabel2.AutoLocalize = false;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://113983104555396";
    ImageLabel2.LayoutOrder = 52;
    ImageLabel2.Position = UDim2.fromOffset(70, 2);
    ImageLabel2.ScaleType = Enum.ScaleType.Fit;
    ImageLabel2.Size = UDim2.fromScale(0.75, 0.75);
    ImageLabel2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel2.ZIndex = 21;
    ImageLabel2.Parent = CanvasGroup;
    local ImageLabel3 = Instance.new("ImageLabel");
    ImageLabel3.Name = "Space";
    ImageLabel3.AutoLocalize = false;
    ImageLabel3.BackgroundTransparency = 1;
    ImageLabel3.Image = "";
    ImageLabel3.LayoutOrder = 1;
    ImageLabel3.Position = UDim2.fromOffset(70, 2);
    ImageLabel3.ScaleType = Enum.ScaleType.Fit;
    ImageLabel3.Size = UDim2.fromScale(0.3, 1);
    ImageLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel3.ZIndex = 21;
    ImageLabel3.Parent = CanvasGroup;
    local ImageLabel4 = Instance.new("ImageLabel");
    ImageLabel4.Name = "Wallbang";
    ImageLabel4.AutoLocalize = false;
    ImageLabel4.BackgroundTransparency = 1;
    ImageLabel4.Image = "rbxassetid://106657340976013";
    ImageLabel4.LayoutOrder = 51;
    ImageLabel4.Position = UDim2.fromOffset(70, 2);
    ImageLabel4.ScaleType = Enum.ScaleType.Fit;
    ImageLabel4.Selectable = true;
    ImageLabel4.Size = UDim2.fromScale(1, 1);
    ImageLabel4.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel4.ZIndex = 21;
    ImageLabel4.Parent = CanvasGroup;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Assist";
    TextLabel.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel.AutoLocalize = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.LayoutOrder = 2;
    TextLabel.Position = UDim2.fromScale(0, 0.5);
    TextLabel.Size = UDim2.new(0, 130, 0.9, 0);
    TextLabel.Text = "WhyNotMyUsername";
    TextLabel.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel.TextScaled = true;
    TextLabel.ZIndex = 9;
    TextLabel.Parent = CanvasGroup;
    TextLabel.Visible = false;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "Killer";
    TextLabel2.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel2.AutoLocalize = false;
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.RichText = true;
    TextLabel2.Position = UDim2.fromScale(0, 0.5);
    TextLabel2.Size = UDim2.new(0, 130, 0.9, 0);
    TextLabel2.Text = "WhyNotMyUsername";
    TextLabel2.TextColor3 = Color3.fromRGB(255, 203, 107);
    TextLabel2.TextScaled = true;
    TextLabel2.ZIndex = 9;
    TextLabel2.Parent = CanvasGroup;
    local TextLabel3 = Instance.new("TextLabel");
    TextLabel3.Name = "Plus";
    TextLabel3.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel3.AutoLocalize = false;
    TextLabel3.BackgroundTransparency = 1;
    TextLabel3.FontFace = Font.new("rbxassetid://12187375422");
    TextLabel3.LayoutOrder = 1;
    TextLabel3.Position = UDim2.fromScale(0, 0.5);
    TextLabel3.Size = UDim2.new(0, 20, 0.9, 0);
    TextLabel3.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel3.Text = "+";
    TextLabel3.TextColor3 = Color3.new(1, 1, 1);
    TextLabel3.TextScaled = true;
    TextLabel3.ZIndex = 9;
    TextLabel3.Parent = CanvasGroup;
    TextLabel3.Visible = false;
    local TextLabel4 = Instance.new("TextLabel");
    TextLabel4.Name = "Victim";
    TextLabel4.AnchorPoint = Vector2.new(0, 0.5);
    TextLabel4.AutoLocalize = false;
    TextLabel4.BackgroundTransparency = 1;
    TextLabel4.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel4.LayoutOrder = 100;
    TextLabel4.Position = UDim2.fromScale(0, 0.5);
    TextLabel4.Size = UDim2.new(0, 130, 0.9, 0);
    TextLabel4.Text = "WhyNotMyUsername";
    TextLabel4.TextColor3 = Color3.fromRGB(172, 195, 220);
    TextLabel4.TextScaled = true;
    TextLabel4.ZIndex = 9;
    TextLabel4.Parent = CanvasGroup;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.Parent = CanvasGroup;
    local ImageLabel5 = Instance.new("ImageLabel");
    ImageLabel5.Name = "Flashed";
    ImageLabel5.AutoLocalize = false;
    ImageLabel5.BackgroundTransparency = 1;
    ImageLabel5.Image = "rbxassetid://114727075797815";
    ImageLabel5.LayoutOrder = 52;
    ImageLabel5.Position = UDim2.fromOffset(-30, 0);
    ImageLabel5.ScaleType = Enum.ScaleType.Fit;
    ImageLabel5.Size = UDim2.fromScale(1, 1);
    ImageLabel5.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel5.ZIndex = 21;
    ImageLabel5.Parent = CanvasGroup;
    local ImageLabel6 = Instance.new("ImageLabel");
    ImageLabel6.Name = "NoScope";
    ImageLabel6.AutoLocalize = false;
    ImageLabel6.BackgroundTransparency = 1;
    ImageLabel6.Image = "rbxassetid://95859249899866";
    ImageLabel6.LayoutOrder = 51;
    ImageLabel6.Position = UDim2.fromOffset(70, 2);
    ImageLabel6.ScaleType = Enum.ScaleType.Fit;
    ImageLabel6.Size = UDim2.fromScale(1, 1);
    ImageLabel6.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel6.ZIndex = 21;
    ImageLabel6.Parent = CanvasGroup;
    local ImageLabel7 = Instance.new("ImageLabel");
    ImageLabel7.Name = "Freefall";
    ImageLabel7.AutoLocalize = false;
    ImageLabel7.BackgroundTransparency = 1;
    ImageLabel7.Image = "rbxassetid://82128272126728";
    ImageLabel7.LayoutOrder = 48;
    ImageLabel7.Position = UDim2.fromOffset(70, 2);
    ImageLabel7.ScaleType = Enum.ScaleType.Fit;
    ImageLabel7.Selectable = true;
    ImageLabel7.Size = UDim2.fromScale(1, 1);
    ImageLabel7.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel7.ZIndex = 21;
    ImageLabel7.Parent = CanvasGroup;
    local ImageLabel8 = Instance.new("ImageLabel");
    ImageLabel8.Name = "Weapon";
    ImageLabel8.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel8.AutoLocalize = false;
    ImageLabel8.BackgroundTransparency = 1;
    ImageLabel8.Image = "rbxassetid://100429874437897";
    ImageLabel8.LayoutOrder = 50;
    ImageLabel8.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel8.ScaleType = Enum.ScaleType.Crop;
    ImageLabel8.Size = UDim2.fromScale(2.5, 1);
    ImageLabel8.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel8.TileSize = UDim2.fromScale(2, 1);
    ImageLabel8.ZIndex = 9;
    ImageLabel8.Parent = CanvasGroup;
    CanvasGroup.Parent = Frame;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout2.Padding = UDim.new(0.015, 3);
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 3.8;
    UIAspectRatioConstraint.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

return u1;