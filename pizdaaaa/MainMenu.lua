-- ReplicatedStorage.GameClient.Gui.MainMenu
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu
-- Decompile time: 33.74 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local TextService = game:GetService("TextService");
game:GetService("GuiService");
local LocalPlayer = Players.LocalPlayer;
local workspace_Terrain = workspace.Terrain;
local workspace_CurrentCamera = workspace.CurrentCamera;
local Idle = ReplicatedStorage.Assets.Idle;
local GameStats = ReplicatedStorage.GameStats;
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
local u17 = nil;
local u18 = {};
local u19 = {};
local u20 = {};
local u21 = {};
local u22 = nil;
local u23 = {
    Play = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.20000000298023224, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.8004987835884094, 1),
        NumberSequenceKeypoint.new(1, 1)
    }),
    Loadout = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.05000000074505806, 1),
        NumberSequenceKeypoint.new(0.375, 0),
        NumberSequenceKeypoint.new(0.699999988079071, 1),
        NumberSequenceKeypoint.new(1, 1)
    }),
    Inventory = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.25, 0),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(1, 1)
    }),
    Store = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.30000001192092896, 1),
        NumberSequenceKeypoint.new(0.625, 0),
        NumberSequenceKeypoint.new(0.949999988079071, 0.9940000176429749),
        NumberSequenceKeypoint.new(1, 1)
    }),
    Gamemodes = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(0.75, 0),
        NumberSequenceKeypoint.new(1, 0)
    })
};
local u24 = {
    Play = "UI.mainmenu_press_play",
    Loadout = "UI.mainmenu_press_loadout",
    Inventory = "UI.mainmenu_press_inventory",
    Store = "UI.mainmenu_press_store",
    Gamemodes = "UI.mainmenu_press_gamemodes",
    Rewards = "UI.mainmenu_press_rewards",
    Home = "UI.mainmenu_press_home",
    Settings = "UI.mainmenu_press_settings",
    Analytics = "UI.mainmenu_press_analytics"
};
local u25 = nil;
local u26 = nil;
local u27 = false;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = "de_vertigo";
local u38 = true;
local u39 = nil;

local function GetDesiredSceneName() -- Line: 77
    -- upvalues: ReplicatedStorage (copy), u38 (ref), GameStats (copy), u39 (ref), u37 (ref)
    local MainMenu = ReplicatedStorage.Assets.Scenes.MainMenu;

    if u38 then
        local Attribute = GameStats:GetAttribute("Map");

        if Attribute and MainMenu:FindFirstChild(Attribute) then
            return Attribute;
        end;

        if u39 and MainMenu:FindFirstChild(u39) then
            return u39;
        end;
    end;

    return u37;
end;

local u40 = false;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local TweenInfo_new_ret = TweenInfo.new(0.5);
local TweenInfo_new_ret2 = TweenInfo.new(0.25);
local TweenInfo_new_ret3 = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
TweenInfo.new(0.1);
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = nil;
local u47 = nil;
local u48 = nil;
local u49 = nil;
local u50 = nil;
local u51 = nil;
local u52 = nil;
local u53 = nil;
local u54 = nil;

local function CleanupOldMap() -- Line: 114
    -- upvalues: workspace_Terrain (copy), Lighting (copy)
    local v55 = workspace_Terrain:FindFirstChildOfClass("Clouds");

    if v55 then
        v55:Destroy();
    end;

    for _, child in pairs(Lighting:GetChildren()) do
        child:Destroy();
    end;
end;

local function ApplyTerrain(p56: userdata) -- Line: 128
    -- upvalues: workspace_Terrain (copy)
    local v57 = p56:FindFirstChildOfClass("TerrainRegion");

    if v57 then
        for i, v in v57.MaterialColors:GetAttributes() do
            workspace_Terrain:SetMaterialColor(Enum.Material[i], v);
        end;

        for i, v in v57.WaterProperties:GetAttributes() do
            workspace_Terrain[i] = v;
        end;

        workspace_Terrain:PasteRegion(v57, workspace_Terrain.MaxExtents.Min, true);
    end;
end;

local function ApplyLighting(p58: userdata) -- Line: 144
    -- upvalues: workspace_Terrain (copy), Lighting (copy)
    local v59 = p58:FindFirstChildOfClass("Clouds");

    if v59 then
        v59:Clone().Parent = workspace_Terrain;
    end;

    local LightingSettings = p58:FindFirstChild("LightingSettings");

    if LightingSettings then
        for i, v in LightingSettings:GetAttributes() do
            Lighting[i] = v;
        end;

        for _, child in pairs(LightingSettings:GetChildren()) do
            child:Clone().Parent = Lighting;
        end;
    end;
end;

function u1.AddButton(u60, p61, p62, p63) -- Line: 165
    -- upvalues: u54 (ref), u12 (ref), u18 (copy), u25 (ref), u19 (copy), u1 (copy), TweenService (copy), TweenInfo_new_ret (copy), u3 (ref), TweenInfo_new_ret2 (copy), u5 (ref), TweenInfo_new_ret3 (copy), u20 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = u60;
    TextButton.Font = Enum.Font.Oswald;
    TextButton.Active = true;
    TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.BackgroundTransparency = 1;
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextButton.BorderSizePixel = 0;
    TextButton.Position = p63;
    TextButton.Selectable = true;
    TextButton.Size = p62;

    if u54 then
        local v64 = {
            Inventory = UDim2.fromScale(0.28, 0.012),
            Loadout = UDim2.fromScale(0.39, 0.012),
            Play = UDim2.fromScale(0.5, 0.01),
            Store = UDim2.fromScale(0.61, 0.012),
            Gamemodes = UDim2.fromScale(0.72, 0.012)
        };
        local v65 = {
            Inventory = UDim2.fromScale(0.065, 0.058),
            Loadout = UDim2.fromScale(0.065, 0.058),
            Play = UDim2.fromScale(0.068, 0.062),
            Store = UDim2.fromScale(0.065, 0.058),
            Gamemodes = UDim2.fromScale(0.072, 0.058)
        };
        TextButton.Position = v64[u60] or UDim2.new(p63.X.Scale, p63.X.Offset, 0.012, 0);
        TextButton.Size = v65[u60] or UDim2.new(p62.X.Scale * 0.9, 0, 0.058, 0);
    end;

    TextButton.AnchorPoint = Vector2.new(0.5, 0);
    TextButton.ZIndex = 343;
    TextButton.Text = u60:upper();
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextScaled = true;
    TextButton.TextSize = 62;
    TextButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 255);
    TextButton.TextWrapped = true;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(136, 136, 136)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) });
    UIGradient.Offset = Vector2.new(0, 0.699999988);
    UIGradient.Rotation = 90;
    UIGradient.Parent = TextButton;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Parent = TextButton;
    TextButton.Parent = u12;
    u18[u60] = TextButton;
    local v67 = {
        Activate = function() -- Line: 229, Name: Activate
            -- upvalues: u25 (ref), u19 (ref), u60 (copy), u1 (ref), TextButton (copy), TweenService (ref), UIGradient (copy), TweenInfo_new_ret (ref)
            local v66 = u25;

            if v66 == u19[u60] then
                return;
            end;

            if v66 ~= nil then
                u1.DeactivateTab(u60);
            end;

            u1.ActivateTab(u60, TextButton);
            TweenService:Create(UIGradient, TweenInfo_new_ret, {
                Offset = Vector2.new(0, 0.7)
            }):Play();
        end
    };
    u3:Add(`{u60}_MouseEnter`, TextButton.MouseEnter:Connect(function() -- Line: 244
        -- upvalues: u25 (ref), u19 (ref), u60 (copy), TweenService (ref), UIGradient (copy), TweenInfo_new_ret2 (ref), u5 (ref)
        if u25 == u19[u60] then
            return;
        end;

        TweenService:Create(UIGradient, TweenInfo_new_ret2, {
            Offset = Vector2.new(0, 0.25)
        }):Play();
        u5.Play("UI.mainmenu_rollover");
    end));
    u3:Add(`{u60}_MouseLeave`, TextButton.MouseLeave:Connect(function() -- Line: 254
        -- upvalues: TweenService (ref), UIScale (copy), TweenInfo_new_ret3 (ref), u25 (ref), u19 (ref), u60 (copy), UIGradient (copy), TweenInfo_new_ret2 (ref)
        TweenService:Create(UIScale, TweenInfo_new_ret3, {
            Scale = 1
        }):Play();

        if u25 == u19[u60] then
            return;
        end;

        TweenService:Create(UIGradient, TweenInfo_new_ret2, {
            Offset = Vector2.new(0, 0.7)
        }):Play();
    end));
    u3:Add(`{u60}_Click`, TextButton.MouseButton1Click:Connect(v67.Activate));
    u20[u60] = v67.Activate;

    return v67;
end;

function u1.AddSideButton(u68, p69, p70, p71) -- Line: 278
    -- upvalues: u54 (ref), u14 (ref), u18 (copy), u25 (ref), u19 (copy), u1 (copy), u3 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), u5 (ref), u20 (copy)
    local ImageButton = Instance.new("ImageButton");
    local ImageLabel = Instance.new("ImageLabel");
    local UICorner = Instance.new("UICorner");
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0);
    ImageButton.BorderSizePixel = 0;
    ImageButton.Size = u54 and UDim2.new(1.15, 0, 1.15, 0) or UDim2.new(1, 0, 1, 0);
    ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageButton.AutoButtonColor = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.LayoutOrder = p71;
    ImageLabel.ImageColor3 = u68 == "Home" and Color3.fromRGB(131, 216, 255) or Color3.fromRGB(255, 255, 255);
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0);
    ImageLabel.Size = u54 and UDim2.new(0.9, 0, 0.9, 0) or UDim2.new(0.800000012, 0, 0.800000012, 0);
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    ImageLabel.Image = p70;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Parent = ImageButton;
    UICorner.CornerRadius = UDim.new(0.100000001, 0);
    UICorner.Parent = ImageButton;
    ImageButton.Parent = u14;
    u18[u68] = ImageButton;
    local v73 = {
        Activate = function() -- Line: 314, Name: Activate
            -- upvalues: u25 (ref), u19 (ref), u68 (copy), u1 (ref), ImageButton (copy)
            local v72 = u25;

            if v72 == u19[u68] then
                return;
            end;

            if v72 ~= nil then
                u1.DeactivateTab(u68);
            end;

            u1.ActivateTab(u68, ImageButton);
        end
    };
    local _ = ImageLabel.Size;
    u3:Add(`{u68}_MouseEnter`, ImageButton.MouseEnter:Connect(function() -- Line: 329
        -- upvalues: u25 (ref), u19 (ref), u68 (copy), TweenService (ref), ImageButton (copy), TweenInfo_new_ret2 (ref), u5 (ref), u1 (ref)
        if u25 == u19[u68] then
            return;
        end;

        TweenService:Create(ImageButton, TweenInfo_new_ret2, {
            BackgroundTransparency = 0.8
        }):Play();
        u5.Play("UI.mainmenu_rollover");
        u1.UpdateHover(true, ImageButton, u68, 2);
    end));
    u3:Add(`{u68}_MouseLeave`, ImageButton.MouseLeave:Connect(function() -- Line: 340
        -- upvalues: TweenService (ref), ImageButton (copy), TweenInfo_new_ret2 (ref), u1 (ref)
        TweenService:Create(ImageButton, TweenInfo_new_ret2, {
            BackgroundTransparency = 1
        }):Play();
        u1.UpdateHover();
    end));
    u3:Add(`{u68}_Click`, ImageButton.MouseButton1Click:Connect(v73.Activate));
    u20[u68] = v73.Activate;

    return v73;
end;

function u1.AddTab(p74) -- Line: 354
    -- upvalues: u54 (ref), u15 (ref), u19 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = p74;
    Frame.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    Frame.BackgroundTransparency = 0.95;
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.new(-1, 0, u54 and 0.082 or 0.058, 0);
    Frame.Size = UDim2.new(1, 0, u54 and 0.918 or 0.941, 0);
    Frame.Visible = false;
    Frame.Parent = u15;
    u19[p74] = Frame;

    return Frame;
end;

function u1.GetCurrentTab() -- Line: 377
    -- upvalues: u25 (ref)
    return u25;
end;

function u1.OpenTab(p75: string) -- Line: 381
    -- upvalues: u20 (copy)
    u20[p75]();
end;

function u1.CycleTab(p76: number) -- Line: 385
    -- upvalues: u18 (copy), u20 (copy), u25 (ref)
    local v77 = {};

    for i, v in u18 do
        if v.Visible and u20[i] then
            table.insert(v77, i);
        end;
    end;

    table.sort(v77, function(p78, p79) -- Line: 394
        -- upvalues: u18 (ref)
        return u18[p78].AbsolutePosition.X < u18[p79].AbsolutePosition.X;
    end);
    u20[v77[((table.find(v77, u25.Name) or 1) + p76 - 1) % #v77 + 1]]();
end;

function u1.ActivateTab(p80, p81) -- Line: 403
    -- upvalues: u19 (copy), u25 (ref), u26 (ref), u5 (ref), u24 (copy), u54 (ref), TweenService (copy), TweenInfo_new_ret (copy), Lighting (copy), u33 (ref), u13 (ref), u18 (copy), TweenInfo_new_ret3 (copy), u17 (ref), u23 (copy), u16 (ref)
    local u82 = u19[p80];
    local v83 = u25;
    u25 = u82;

    if u26 and u82.Name ~= "Home" then
        u26.Visible = u26 == u82;
        u26 = nil;
    end;

    u5.Play(u24[p80]);
    u82.Visible = true;
    local u84 = u54 and 0.082 or 0.058;

    if v83 and v83.Name == "Home" then
        u82.Position = UDim2.new(-1, 0, u84, 0);
        TweenService:Create(u82, TweenInfo_new_ret, {
            Position = UDim2.new(0, 0, u84, 0)
        }):Play();
        TweenService:Create(Lighting.UI_Blur, TweenInfo_new_ret, {
            Size = 72
        }):Play();
        u33.Enabled("RightFrame", false);
        u33.Enabled("Bundle", false);
        u33.Enabled("Balisong", false);
        u33.Enabled("Upgrader", false);
        u33.Enabled("News", false);
        u33.Enabled("Rewards", false);
        u13.Position = UDim2.new(-1, 0, 0, 0);
        TweenService:Create(u13, TweenInfo_new_ret, {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play();
    elseif u82.Name == "Home" then
        task.delay(0.15, function() -- Line: 440
            -- upvalues: u25 (ref), u82 (copy), u84 (copy)
            if u25 ~= u82 then
                return;
            end;

            u82.Position = UDim2.new(0, 0, u84, 0);
            u82.Visible = true;
        end);
    else
        u82.Position = UDim2.new(0.03 * (v83 and u18[v83.Name].AbsolutePosition.X > p81.AbsolutePosition.X and -1 or 1), 0, u84, 0);
        u82.Visible = true;
        TweenService:Create(u82, TweenInfo_new_ret3, {
            Position = UDim2.new(0, 0, u84, 0)
        }):Play();
    end;

    if p81:FindFirstChild("Notice") then
        p81.Notice:Destroy();
    end;

    if p81:IsA("ImageButton") then
        TweenService:Create(p81.ImageLabel, TweenInfo_new_ret, {
            ImageColor3 = Color3.fromRGB(131, 216, 255)
        }):Play();
        u17.Transparency = u23.Play;
        TweenService:Create(u16, TweenInfo_new_ret, {
            GroupColor3 = Color3.fromRGB(255, 255, 255)
        }):Play();

        return;
    end;

    TweenService:Create(p81, TweenInfo_new_ret, {
        TextTransparency = 0,
        TextColor3 = Color3.fromRGB(131, 216, 255)
    }):Play();
    u17.Transparency = u23[u82.Name];
    TweenService:Create(u16, TweenInfo_new_ret, {
        GroupColor3 = Color3.fromRGB(131, 216, 255)
    }):Play();
end;

function u1.DeactivateTab(p85) -- Line: 474
    -- upvalues: u25 (ref), u42 (ref), u46 (ref), u47 (ref), u2 (ref), u6 (ref), TweenService (copy), TweenInfo_new_ret2 (copy), Lighting (copy), TweenInfo_new_ret (copy), u33 (ref), u45 (ref), u13 (ref), u26 (ref), u18 (copy)
    local u86 = u25;

    if u42 then
        u42.Close();
    end;

    if u46 then
        u46.Close(true);
    end;

    if u86.Name == "Inventory" then
        u47.CloseStickerApply(true);
    end;

    if u2.Handler:FindFirstChild("Dropdown") then
        u6.DropDeactive("GLOBAL");
    end;

    if p85 == "Home" then
        u86.Position = UDim2.new(0, 0, 0.058, 0);
        TweenService:Create(u86, TweenInfo_new_ret2, {
            Position = UDim2.new(-1, 0, 0.058, 0)
        }):Play();
        TweenService:Create(Lighting.UI_Blur, TweenInfo_new_ret, {
            Size = 0
        }):Play();
        u33.Enabled("RightFrame", true);

        if u45 and u45.RefreshBlur then
            u45.RefreshBlur();
        else
            u33.Enabled("Bundle", true);
        end;

        u33.Enabled("News", true);
        u13.Position = UDim2.new(0, 0, 0, 0);
        TweenService:Create(u13, TweenInfo_new_ret2, {
            Position = UDim2.new(-1, 0, 0, 0)
        }):Play();
        u26 = u86;
        task.delay(0.25, function() -- Line: 520
            -- upvalues: u26 (ref), u86 (copy)
            if u26 ~= u86 then
                return;
            end;

            u86.Visible = false;
            u26 = nil;
        end);
    else
        u86.Position = UDim2.new(0, 0, 0.058, 0);
        u86.Visible = false;
    end;

    local v87 = u18[u25.Name];

    if v87 then
        if v87:IsA("ImageButton") then
            TweenService:Create(v87.ImageLabel, TweenInfo_new_ret, {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }):Play();

            return;
        end;

        TweenService:Create(v87, TweenInfo_new_ret, {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play();
    end;
end;

function u1.UpdateHover(p88, p89, p90, p91) -- Line: 544
    -- upvalues: TextService (copy), u12 (ref), TweenService (copy), TweenInfo_new_ret3 (copy)
    if not p88 then
        TweenService:Create(HoverUI, TweenInfo.new(0.25), {
            GroupTransparency = 1
        }):Play();
        HoverUI.Size = UDim2.fromScale(0.0542232, 0.0413847);

        return;
    end;

    local v92 = TextService:GetTextSize(p90, 20, Enum.Font.Gotham, Vector2.new((1 / 0), 0)).X / HoverUI.Parent.AbsoluteSize.X;
    HoverUI.Size = UDim2.new(v92, 0, 0.0413847, 0);
    HoverUI.TextLabel.Text = p90;
    local AbsolutePosition = p89.AbsolutePosition;
    local AbsoluteSize = p89.AbsoluteSize;
    local HoverUI_AbsoluteSize = HoverUI.AbsoluteSize;
    local v93 = nil;
    local v94 = nil;

    if p91 == 1 then
        v93 = AbsolutePosition.X + AbsoluteSize.X / 2 - HoverUI_AbsoluteSize.X / 2;
        v94 = AbsolutePosition.Y - HoverUI_AbsoluteSize.Y - 10;
    elseif p91 == 2 then
        v93 = AbsolutePosition.X + AbsoluteSize.X / 2 - HoverUI_AbsoluteSize.X / 2;
        v94 = AbsolutePosition.Y + AbsoluteSize.Y * 2 + HoverUI_AbsoluteSize.Y;
    elseif p91 == 3 then
        v93 = AbsolutePosition.X + AbsoluteSize.X + 10;
        v94 = AbsolutePosition.Y + AbsoluteSize.Y / 2 - HoverUI_AbsoluteSize.Y / 2;
    elseif p91 == 4 then
        v93 = AbsolutePosition.X - HoverUI_AbsoluteSize.X - 10;
        v94 = AbsolutePosition.Y + AbsoluteSize.Y / 2 - HoverUI_AbsoluteSize.Y / 2;
    end;

    local UDim2_fromOffset_ret = UDim2.fromOffset(v93, v94 - (u12:GetAttribute("TopInset") or 0));
    HoverUI.Position = UDim2_fromOffset_ret - UDim2.fromOffset(0, 6);
    TweenService:Create(HoverUI, TweenInfo.new(0.25), {
        GroupTransparency = 0
    }):Play();
    TweenService:Create(HoverUI, TweenInfo_new_ret3, {
        Position = UDim2_fromOffset_ret
    }):Play();
end;

function u1.AddNotice(p95) -- Line: 596
    -- upvalues: u25 (ref), u18 (copy), u1 (copy)
    if u25 and u25.Name == p95 then
        return;
    end;

    local v96 = u18[p95];

    if v96 then
        if v96:FindFirstChild("Notice") then
            return;
        end;

        if v96:IsA("ImageButton") then
            u1.notice(v96, false);

            return;
        end;

        if v96:IsA("TextButton") then
            u1.notice(v96, true);
        end;
    end;
end;

local CFrame_identity = CFrame.identity;

function u1.Visible(p97) -- Line: 617
    -- upvalues: u27 (ref), u34 (ref), CleanupOldMap (copy), u28 (ref), u22 (ref), workspace_Terrain (copy), Lighting (copy), ReplicatedStorage (copy), u38 (ref), GameStats (copy), u39 (ref), u37 (ref), u1 (copy), CFrame_identity (ref), workspace_CurrentCamera (copy), u30 (ref), ApplyLighting (copy), u7 (ref), u25 (ref), u33 (ref), u4 (ref), UserInputService (copy), u3 (ref), u54 (ref), u2 (ref), RunService (copy), u12 (ref), u32 (ref), RaycastParams_new_ret (copy), u11 (ref), u5 (ref), u21 (copy), TweenService (copy), TweenInfo_new_ret (copy), u13 (ref), u53 (ref), u40 (ref), u48 (ref), u52 (ref), u45 (ref), u29 (ref), u44 (ref), u50 (ref), u42 (ref), u46 (ref), u49 (ref), u31 (ref), u10 (ref), u9 (ref), u8 (ref), LocalPlayer (copy), u36 (ref), u43 (ref), u41 (ref)
    local v98 = u27;
    u27 = p97 or not u27;

    if v98 and u27 then
        return;
    end;

    u34.SetFramePriority("MainMenu", u27);
    CleanupOldMap();

    if u28 then
        u28:Stop();
        u28:Destroy();
    end;

    if u22 then
        pcall(task.cancel, u22);
        u22 = nil;
    end;

    local v99 = workspace_Terrain:FindFirstChildOfClass("Clouds");

    if v99 then
        v99:Destroy();
    end;

    for _, child in pairs(Lighting:GetChildren()) do
        child:Destroy();
    end;

    if not u27 then
        u44.Close();
        u50.Close();
        u42.Close();
        u46.Close(true);
        u49.Visible(false, true, true);
        u30.Parent = ReplicatedStorage;

        if u31 then
            ApplyLighting(u31);
            u7.OverrideEverything();
        end;

        if not u40 then
            if u10.IsSpectating() then
                local CurrentMode = u10.GetCurrentMode();

                if CurrentMode == "FirstPerson" then
                    u4.SetTarget(nil);
                    u4.SetZoom(0);
                    u4.SetFOVAmount(u4.GetSettingsFieldOfView());
                else
                    local v100 = CurrentMode == "ThirdPerson" and u10.GetSpectateTargetModel();

                    if v100 then
                        u9.SetTarget(v100.PrimaryPart);
                        u4.SetZoom(10);
                        u4.SetTarget(3);
                    end;
                end;
            elseif u8.IsAlive() and LocalPlayer:GetAttribute("Team") ~= "Spectator" then
                u4.SetTarget(1);
                u4.SetFOVAmount(u4.GetSettingsFieldOfView());
            else
                u4.SetTarget(2);

                if u36.GetState() then
                    u36.Begin(CFrame_identity);
                else
                    u36.Begin();
                end;
            end;
        end;

        u3:Removes("MouseMovement", "PreRender", "ClickOnNose");
        u52.ClearBundle(true);
        u45.ClearBundle(true);
        u43.SetVisible(true);
        u41.Visible(false);
        u12.Visible = false;
        u13.Visible = false;

        if u40 then
            u48.Visible(true);

            return;
        end;

        u53.Visible = true;

        return;
    end;

    local MainMenu = ReplicatedStorage.Assets.Scenes.MainMenu;
    local v101;

    if u38 then
        v101 = GameStats:GetAttribute("Map");

        if not (v101 and MainMenu:FindFirstChild(v101)) then
            if u39 and MainMenu:FindFirstChild(u39) then
                v101 = u39;
            else
                v101 = u37;
            end;
        end;
    else
        v101 = u37;
    end;

    if v101 and v101 ~= u39 then
        u1.UpdateScene(v101);
    end;

    CFrame_identity = workspace_CurrentCamera.CFrame;
    u30.Parent = workspace;
    ApplyLighting(u30);
    u7.OverrideEverything(false);

    if u25 then
        if u25.Name == "Home" then
            Lighting.UI_Blur.Size = 0;
            u33.Enabled("RightFrame", true);
            u33.Enabled("Bundle", true);
            u33.Enabled("News", true);
            u33.Enabled("Rewards", true);
        else
            Lighting.UI_Blur.Size = 72;
            u33.Enabled("RightFrame", false);
            u33.Enabled("Bundle", false);
            u33.Enabled("News", false);
            u33.Enabled("Rewards", false);
        end;
    end;

    u4.SetTarget(u30.Camera);
    u4.SetFOVAmount(65);
    local u102 = (-1 / 0);
    local u103 = Vector3.new(0, 0, 0);
    local MouseLocation = UserInputService:GetMouseLocation();
    u3:Add("MouseMovement", UserInputService.InputChanged:Connect(function(p104) -- Line: 694
        -- upvalues: MouseLocation (ref), u54 (ref), UserInputService (ref), u2 (ref), u103 (ref)
        if p104.UserInputType ~= Enum.UserInputType.MouseMovement and p104.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        MouseLocation = u54 and p104.Position or UserInputService:GetMouseLocation();
        local v105 = ((MouseLocation.X / u2.Handler.AbsoluteSize.X - 0.5) * 0.5 + 0.5 - 0.5) * 1.57;
        local math_sin_ret = math.sin(v105);
        local v106 = math.cos(v105) - 1;
        u103 = Vector3.new(math_sin_ret, 0, v106);
    end));
    u3:Add("PreRender", RunService.PreRender:Connect(function(p107) -- Line: 709
        -- upvalues: u12 (ref), u2 (ref), u30 (ref), u32 (ref), u103 (ref), u33 (ref), workspace_CurrentCamera (ref), MouseLocation (ref), u102 (ref)
        if not u12.Visible then
            return;
        end;

        if u2 and (u2.Handler and (u2.Handler:FindFirstChild("Inspect") and u2.Handler.Inspect.Visible)) then
            return;
        end;

        if u2 and (u2.Handler and (u2.Handler:FindFirstChild("CaseInspect") and u2.Handler.CaseInspect.Visible)) then
            return;
        end;

        u30.Camera.CFrame = u30.Camera.CFrame:Lerp(u32 * CFrame.new(u103), p107);
        u33.Update();
        local v108 = workspace_CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y);
        local v109 = v108.Origin + v108.Direction * 100;
        local v110 = (Torso.CFrame + Torso.CFrame:ToObjectSpace(Rig.Head.CFrame).Position):PointToObjectSpace(v109);
        local math_atan2_ret = math.atan2(-v110.X, v110.Z);
        local math_sqrt_ret = math.sqrt(v110.X ^ 2 + v110.Z ^ 2);
        local math_atan2_ret2 = math.atan2(v110.Y, math_sqrt_ret);
        local CFrame_Angles_ret = CFrame.Angles(0.08726646259971647, 0, -0.4014257279586958);
        local math_clamp_ret = math.clamp(math_atan2_ret, -1.3962634015954636, 1.3962634015954636);
        local math_clamp_ret2 = math.clamp(math_atan2_ret2, -0, 0.3490658503988659);
        local v111;

        if os.clock() - u102 < 3 then
            CFrame_Angles_ret = CFrame.identity;
            math_clamp_ret2 = 0;
            math_clamp_ret = 0;
            v111 = 0.01;
        else
            v111 = 0.1;
        end;

        Neck.C0 = Neck.C0:Lerp(originalC0 * CFrame_Angles_ret * CFrame.Angles(-math_clamp_ret2, 0, math_clamp_ret), v111);
    end));
    u3:Add("ClickOnNose", UserInputService.InputBegan:Connect(function(p112) -- Line: 758
        -- upvalues: u25 (ref), u102 (ref), workspace_CurrentCamera (ref), MouseLocation (ref), RaycastParams_new_ret (ref), u11 (ref), u5 (ref)
        if u25 and u25.Name ~= "Home" then
            return;
        end;

        if os.clock() - u102 < 5 then
            return;
        end;

        if p112.UserInputType ~= Enum.UserInputType.MouseButton1 and p112.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local v113 = workspace_CurrentCamera:ViewportPointToRay(MouseLocation.X, MouseLocation.Y);

        if not workspace:Raycast(v113.Origin, v113.Direction * 100, RaycastParams_new_ret) then
            return;
        end;

        local v114 = math.random(1, 100) == 1;

        if v114 then
            u11:Create("USE CODE \"FNAF\"", Color3.fromRGB(85, 62, 51));
        end;

        task.delay(0.1, function() -- Line: 784
            NoseAnimation:Play();
        end);
        u5.Play(v114 and "UI.fnafnose" or "UI.fnafnosereal");
        u102 = os.clock();
    end));
    u22 = task.defer(function() -- Line: 794
        -- upvalues: u12 (ref), u21 (ref), TweenService (ref), TweenInfo_new_ret (ref)
        while task.wait(0.85) and u12.Visible do
            for _, v in u21 do
                TweenService:Create(v, TweenInfo_new_ret, {
                    BackgroundTransparency = 0.85 + math.random() * 0.2
                }):Play();
            end;
        end;
    end);
    u12.Visible = true;
    u13.Visible = true;
    u53.Visible = false;

    if u40 then
        u48.Visible(false);
    end;

    if u52 and u52.UpdateBundle then
        u52.UpdateBundle();
    end;

    if u45 and u45.UpdateBundle then
        u45.UpdateBundle();
    end;

    u28 = u5.Play("UI.background_music", {
        Looped = true,
        Volume = u29
    });
end;

function u1.UpdateScene(p115) -- Line: 896
    -- upvalues: ReplicatedStorage (copy), u30 (ref), u39 (ref), u37 (ref), u32 (ref), CleanupOldMap (copy), ApplyLighting (copy), u7 (ref), u25 (ref), Lighting (copy), u4 (ref), Idle (copy), RaycastParams_new_ret (copy)
    local MainMenu = ReplicatedStorage.Assets.Scenes.MainMenu;
    local v116 = MainMenu:FindFirstChild(p115);

    if not v116 then
        if u30 and (u39 and MainMenu:FindFirstChild(u39)) then
            return;
        end;

        v116 = MainMenu:FindFirstChild(u37) or (MainMenu:FindFirstChild("de_vertigo") or MainMenu:GetChildren()[1]);

        if not v116 then
            return;
        end;

        p115 = v116.Name;
    end;

    if u30 then
        u30:Destroy();
    end;

    u39 = p115;
    u30 = v116:Clone();
    Rig = u30.Rig.Rig;
    u32 = u30.Camera.CFrame;
    CleanupOldMap();
    ApplyLighting(u30);
    u7.OverrideEverything(false);

    if u25 and (u25.Name ~= "Home" and Lighting:FindFirstChild("UI_Blur")) then
        Lighting.UI_Blur.Size = 72;
    end;

    u30.Parent = workspace;
    u30.Name = "Scene";
    u4.SetTarget(u30.Camera);
    Torso = Rig.Torso;
    Neck = Torso.Neck;
    originalC0 = Neck.C0;
    Neck:SetAttribute("OriginalC0", originalC0);
    Idle.AnimationId = "rbxassetid://130867004744889";
    local v117 = Rig.AnimationController.Animator:LoadAnimation(Idle);
    v117.Priority = Enum.AnimationPriority.Action;
    v117.Looped = true;
    v117:Play();
    Idle.AnimationId = "rbxassetid://98533282495937";
    NoseAnimation = Rig.AnimationController.Animator:LoadAnimation(Idle);
    NoseAnimation.Priority = Enum.AnimationPriority.Action2;
    NoseAnimation.Looped = false;
    RaycastParams_new_ret.FilterDescendantsInstances = { Rig.Head };
end;

local function IsInspectOpen() -- Line: 956
    -- upvalues: u46 (ref), u42 (ref), u2 (ref)
    if u46 and (u46.IsOpen and u46.IsOpen() or u46.IsBusy()) then
        return true;
    end;

    if u42 and (u42.IsOpen and u42.IsOpen() or u42.IsBusy()) then
        return true;
    end;

    if u2 and u2.Handler then
        if u2.Handler:FindFirstChild("Inspect") and u2.Handler.Inspect.Visible then
            return true;
        end;

        if u2.Handler:FindFirstChild("CaseInspect") and u2.Handler.CaseInspect.Visible then
            return true;
        end;
    end;

    return false;
end;

function u1.CheckSceneUpdate() -- Line: 974
    -- upvalues: u38 (ref), u27 (ref), IsInspectOpen (copy), ReplicatedStorage (copy), GameStats (copy), u39 (ref), u37 (ref), u1 (copy)
    if u38 and (u27 and not IsInspectOpen()) then
        local MainMenu = ReplicatedStorage.Assets.Scenes.MainMenu;
        local v118;

        if u38 then
            v118 = GameStats:GetAttribute("Map");

            if not (v118 and MainMenu:FindFirstChild(v118)) then
                if u39 and MainMenu:FindFirstChild(u39) then
                    v118 = u39;
                else
                    v118 = u37;
                end;
            end;
        else
            v118 = u37;
        end;

        if v118 and v118 ~= u39 then
            u1.UpdateScene(v118);
        end;
    end;
end;

function u1.GetCameraCFrame() -- Line: 983
    -- upvalues: u32 (ref)
    return u32;
end;

function u1.ResetRigNeck() -- Line: 987
    if Neck and originalC0 then
        Neck.C0 = originalC0;
    end;
end;

function u1.Draw() -- Line: 993
    -- upvalues: ReplicatedStorage (copy), u38 (ref), GameStats (copy), u39 (ref), u37 (ref), u1 (copy), u31 (ref), u7 (ref), u34 (ref), ApplyLighting (copy), IsInspectOpen (copy), CleanupOldMap (copy), u12 (ref), u40 (ref)
    local MainMenu = ReplicatedStorage.Assets.Scenes.MainMenu;
    local v119;

    if u38 then
        v119 = GameStats:GetAttribute("Map");

        if not (v119 and MainMenu:FindFirstChild(v119)) then
            if u39 and MainMenu:FindFirstChild(u39) then
                v119 = u39;
            else
                v119 = u37;
            end;
        end;
    else
        v119 = u37;
    end;

    u1.UpdateScene(v119);

    if workspace:FindFirstChild("Map") then
        u31 = workspace:WaitForChild("Map", 5);
    end;

    u7.OnMapAdded:Connect(function(p120) -- Line: 1007
        -- upvalues: u31 (ref), u34 (ref), ApplyLighting (ref), u7 (ref), u38 (ref), IsInspectOpen (ref), ReplicatedStorage (ref), GameStats (ref), u39 (ref), u37 (ref), u1 (ref)
        if p120.Name == "Map" then
            u31 = p120;

            if not u34.FramePriority.MainMenu then
                ApplyLighting(u31);
                u7.OverrideEverything();

                return;
            end;

            if u38 and not IsInspectOpen() then
                local MainMenu2 = ReplicatedStorage.Assets.Scenes.MainMenu;
                local v121;

                if u38 then
                    v121 = GameStats:GetAttribute("Map");

                    if not (v121 and MainMenu2:FindFirstChild(v121)) then
                        if u39 and MainMenu2:FindFirstChild(u39) then
                            v121 = u39;
                        else
                            v121 = u37;
                        end;
                    end;
                else
                    v121 = u37;
                end;

                if v121 and v121 ~= u39 then
                    u1.UpdateScene(v121);
                end;
            end;
        end;
    end);
    u7.OnMapRemove:Connect(function(p122) -- Line: 1024
        -- upvalues: u34 (ref), CleanupOldMap (ref)
        if not u34.FramePriority.MainMenu then
            CleanupOldMap();
        end;
    end);
    GameStats:GetAttributeChangedSignal("Map"):Connect(function() -- Line: 1030
        -- upvalues: u38 (ref), u12 (ref), IsInspectOpen (ref), ReplicatedStorage (ref), GameStats (ref), u39 (ref), u37 (ref), u1 (ref)
        if u38 and (u12 and (u12.Visible and not IsInspectOpen())) then
            local MainMenu2 = ReplicatedStorage.Assets.Scenes.MainMenu;
            local v123;

            if u38 then
                v123 = GameStats:GetAttribute("Map");

                if not (v123 and MainMenu2:FindFirstChild(v123)) then
                    if u39 and MainMenu2:FindFirstChild(u39) then
                        v123 = u39;
                    else
                        v123 = u37;
                    end;
                end;
            else
                v123 = u37;
            end;

            if v123 and v123 ~= u39 then
                u1.UpdateScene(v123);
            end;
        end;
    end);
    u40 = GameStats:GetAttribute("State") == "MatchEnded";
    GameStats:GetAttributeChangedSignal("State"):Connect(function() -- Line: 1040
        -- upvalues: u40 (ref), GameStats (ref)
        u40 = GameStats:GetAttribute("State") == "MatchEnded";
    end);
end;

function u1.Init(p124) -- Line: 1047
    -- upvalues: u2 (ref), u5 (ref), u29 (ref), u3 (ref), u4 (ref), u33 (ref), u6 (ref), u34 (ref), u7 (ref), u35 (ref), u36 (ref), u8 (ref), u10 (ref), u9 (ref), u54 (ref), u12 (ref), u53 (ref), u13 (ref), u1 (copy)
    u2 = p124:GetModule("Gui");
    u5 = p124:GetModule("SoundManager");
    u29 = p124:GetModule("SettingsData").GetData().Audio["Volume & Sound"]["Main Menu Volume"].Default;
    u3 = p124:GetModule("Maid").new();
    u4 = p124:GetModule("CameraController");
    u33 = p124:GetModule("Blur");
    u6 = p124:GetModule("Settings");
    u34 = p124:GetModule("BindsController");
    u7 = p124:GetModule("NewMapAdded");
    u35 = p124:GetModule("GetUserPlatform");
    u36 = p124:GetModule("Freecam");
    u8 = p124:GetModule("CharacterController");
    u10 = p124:GetModule("Spectate");
    u9 = p124:GetModule("FollowCamera");
    u54 = u35() == "Mobile";
    local Handler = u2.Handler;
    u12 = Handler.MainMenu;
    u53 = Handler.HUD;
    u13 = Handler.DOTS;
    u1.new();
    u1.hover();
    u1.Draw();
end;

function u1.Start(p125) -- Line: 1097
    -- upvalues: u46 (ref), u2 (ref), u42 (ref), u49 (ref), u47 (ref), u51 (ref), u29 (ref), u28 (ref), u38 (ref), u12 (ref), IsInspectOpen (copy), ReplicatedStorage (copy), GameStats (copy), u39 (ref), u37 (ref), u1 (copy), u11 (ref), u43 (ref), u41 (ref), u48 (ref), u52 (ref), u45 (ref), u50 (ref), u44 (ref)
    u46 = u2.GetComponent("Inspect");
    u42 = u2.GetComponent("CaseInspect");
    u49 = u2.GetComponent("MobileButtons");
    u47 = u2.GetComponent("Inventory");
    u51 = u2.GetComponent("Settings");
    local Audio = u51:GetPlayerSettings().Audio;
    u29 = Audio and Audio["Volume & Sound"]["Main Menu Volume"] or u29;
    u51:AddConnection("Audio", "Volume & Sound", "Main Menu Volume", function(p126) -- Line: 1105
        -- upvalues: u29 (ref), u28 (ref)
        u29 = p126;

        if u28 then
            u28.Volume = p126;
        end;
    end);
    u51:AddConnection("Game", "HUD & UI", "Use Current Map Scene", function(p127) -- Line: 1111
        -- upvalues: u38 (ref), u12 (ref), IsInspectOpen (ref), ReplicatedStorage (ref), GameStats (ref), u39 (ref), u37 (ref), u1 (ref)
        u38 = p127;

        if u12 and (u12.Visible and not IsInspectOpen()) then
            local MainMenu = ReplicatedStorage.Assets.Scenes.MainMenu;
            local v128;

            if u38 then
                v128 = GameStats:GetAttribute("Map");

                if not (v128 and MainMenu:FindFirstChild(v128)) then
                    if u39 and MainMenu:FindFirstChild(u39) then
                        v128 = u39;
                    else
                        v128 = u37;
                    end;
                end;
            else
                v128 = u37;
            end;

            if v128 and v128 ~= u39 then
                u1.UpdateScene(v128);
            end;
        end;
    end);
    u51:AddConnection("Game", "HUD & UI", "Main Menu Map Scene", function(p129) -- Line: 1120
        -- upvalues: u37 (ref), u12 (ref), IsInspectOpen (ref), ReplicatedStorage (ref), u38 (ref), GameStats (ref), u39 (ref), u1 (ref)
        u37 = p129;

        if u12 and (u12.Visible and not IsInspectOpen()) then
            local MainMenu = ReplicatedStorage.Assets.Scenes.MainMenu;
            local v130;

            if u38 then
                v130 = GameStats:GetAttribute("Map");

                if not (v130 and MainMenu:FindFirstChild(v130)) then
                    if u39 and MainMenu:FindFirstChild(u39) then
                        v130 = u39;
                    else
                        v130 = u37;
                    end;
                end;
            else
                v130 = u37;
            end;

            if v130 and v130 ~= u39 then
                u1.UpdateScene(v130);

                return;
            end;

            if not u38 then
                u1.UpdateScene(p129);
            end;
        end;
    end);
    u11 = u2.GetComponent("MenuNotification");
    u43 = u2.GetComponent("Crosshair");
    u41 = u2.GetComponent("Buymenu");
    u48 = u2.GetComponent("MatchEnd");
    u52 = u2.GetComponent("Store");
    u45 = u2.GetComponent("Home");
    u50 = u2.GetComponent("Notify");
    u44 = u2.GetComponent("Gift");
    u1.Visible(true);
end;

function u1.new() -- Line: 1146
    -- upvalues: u54 (ref), u14 (ref), u16 (ref), u17 (ref), u21 (copy), u12 (ref), u15 (ref)
    local Folder = Instance.new("Folder");
    Folder.Name = "TopBar";
    local ImageLabel = Instance.new("ImageLabel");
    local UIGradient = Instance.new("UIGradient");
    ImageLabel.Name = "TopFrame";
    ImageLabel.BackgroundColor3 = Color3.fromRGB(108, 108, 108);
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Size = u54 and UDim2.new(1.00052106, 0, 0.082, 0) or UDim2.new(1.00052106, 0, 0.0592592582, 0);
    ImageLabel.ZIndex = 3;
    ImageLabel.ScaleType = Enum.ScaleType.Crop;
    ImageLabel.Parent = Folder;
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(49, 58, 68)),
        ColorSequenceKeypoint.new(0.1, Color3.fromRGB(54, 64, 78)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(62, 71, 82)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(74, 86, 97)),
        ColorSequenceKeypoint.new(0.69, Color3.fromRGB(71, 80, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 57, 63))
    });
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.03), NumberSequenceKeypoint.new(1, 0.03) });
    UIGradient.Parent = ImageLabel;
    u14 = Instance.new("Frame");
    local UIPadding = Instance.new("UIPadding");
    local UIListLayout = Instance.new("UIListLayout");
    u14.Name = "Left";
    u14.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u14.BackgroundTransparency = 1;
    u14.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u14.BorderSizePixel = 0;
    u14.Size = UDim2.new(1, 0, 1, 0);
    u14.Position = u54 and UDim2.new(0, -30, 0, 0) or UDim2.new(0, 0, 0, 0);
    u14.Parent = ImageLabel;
    UIPadding.PaddingBottom = UDim.new(0.200000003, 0);
    UIPadding.PaddingLeft = UDim.new(0.00499999989, 0);
    UIPadding.PaddingRight = UDim.new(0.00499999989, 0);
    UIPadding.PaddingTop = UDim.new(0.200000003, 0);
    UIPadding.Parent = u14;
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.Padding = UDim.new(0.00499999989, 0);
    UIListLayout.Parent = u14;
    local Folder2 = Instance.new("Folder");
    Folder2.Name = "TopFrameLines";
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BackgroundTransparency = 0.5;
    Frame.BorderColor3 = Color3.new();
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(0.47, 0.5);
    Frame.Size = UDim2.new(0, 1, 0.4, 0);
    Frame.Parent = Folder2;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Frame";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame2.BackgroundTransparency = 0.5;
    Frame2.BorderColor3 = Color3.new();
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(0.53, 0.5);
    Frame2.Size = UDim2.new(0, 1, 0.4, 0);
    Frame2.Parent = Folder2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Frame";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame3.BackgroundTransparency = 0.5;
    Frame3.BorderColor3 = Color3.new();
    Frame3.BorderSizePixel = 0;
    Frame3.Position = UDim2.fromScale(0.41, 0.5);
    Frame3.Size = UDim2.new(0, 1, 0.3, 0);
    Frame3.Parent = Folder2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Frame";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame4.BackgroundTransparency = 0.5;
    Frame4.BorderColor3 = Color3.new();
    Frame4.BorderSizePixel = 0;
    Frame4.Position = UDim2.fromScale(0.59, 0.5);
    Frame4.Size = UDim2.new(0, 1, 0.3, 0);
    Frame4.Parent = Folder2;
    Folder2.Parent = ImageLabel;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "Lines";
    Frame5.BackgroundTransparency = 1;
    Frame5.ClipsDescendants = true;
    Frame5.Size = u54 and UDim2.fromScale(1, 0.082) or UDim2.fromScale(1, 0.058);
    Frame5.ZIndex = 3;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Name = "LinesImageLabel";
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Image = "rbxassetid://118256082193795";
    ImageLabel2.ImageTransparency = 0.85;
    ImageLabel2.ScaleType = Enum.ScaleType.Tile;
    ImageLabel2.Size = UDim2.fromScale(1, 8.944);
    ImageLabel2.TileSize = UDim2.fromScale(0.3, 1);
    ImageLabel2.Parent = Frame5;
    Frame5.Parent = Folder;
    u16 = Instance.new("CanvasGroup");
    u16.Name = "Fade";
    u16.AnchorPoint = Vector2.new(0.5, 0);
    u16.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    u16.BackgroundTransparency = 1;
    u16.BorderColor3 = Color3.fromRGB(0, 0, 0);
    u16.BorderSizePixel = 0;
    u16.Position = UDim2.new(0.5, 0, 0, 0);
    u16.Size = u54 and UDim2.new(0.35, 0, 0.082, 0) or UDim2.new(0.300000012, 0, 0.0579999983, 0);
    u16.ZIndex = 3;
    u16.Parent = Folder;
    u17 = Instance.new("UIGradient");
    u17.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.20000000298023224, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.8004987835884094, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    u17.Parent = u16;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    local UIGridLayout = Instance.new("UIGridLayout");
    local UIAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint");
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIGridLayout.CellPadding = UDim2.new(0.00350000011, 0, 0.0350000001, 0);
    UIGridLayout.CellSize = UDim2.new(0.280000001, 0, 0.280000001, 0);
    UIGridLayout.FillDirectionMaxCells = 0;
    UIGridLayout.Parent = u16;
    UIAspectRatioConstraint2.Parent = UIGridLayout;
    UIAspectRatioConstraint.Parent = u16;
    UIAspectRatioConstraint.AspectRatio = 12;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;

    for i = 1, 108 do
        local Frame6 = Instance.new("Frame");
        Frame6.Name = "Blocks";
        Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Frame6.BorderColor3 = Color3.fromRGB(0, 0, 0);
        Frame6.BorderSizePixel = 0;
        Frame6.Parent = u16;
        u21[i] = Frame6;
        local _ = i;
    end;

    Folder.Parent = u12;
    u15 = Instance.new("Folder");
    u15.Name = "HolderTabs";
    u15.Parent = u12;
end;

function u1.hover() -- Line: 1317
    -- upvalues: u12 (ref)
    HoverUI = Instance.new("CanvasGroup");
    HoverUI.Name = "HoverUI";
    HoverUI.BackgroundColor3 = Color3.fromRGB(17, 17, 19);
    HoverUI.BackgroundTransparency = 0.25;
    HoverUI.Position = UDim2.fromScale(0.909802, 0.05539);
    HoverUI.Size = UDim2.fromScale(0.0542232, 0.0413847);
    HoverUI.AnchorPoint = Vector2.new(0, 0);
    HoverUI.GroupTransparency = 1;
    HoverUI.ZIndex = 100;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0, 5);
    UICorner.Parent = HoverUI;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.new(1, -10, 1, -20);
    TextLabel.Text = "Home";
    TextLabel.TextColor3 = Color3.fromRGB(223, 223, 223);
    TextLabel.TextScaled = true;
    TextLabel.Parent = HoverUI;
    HoverUI.Parent = u12;
end;

function u1.notice(p131, p132) -- Line: 1352
    -- upvalues: TweenService (copy), TweenInfo_new_ret3 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Notice";
    Frame.AnchorPoint = Vector2.new(0.5, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeXX;

    if p132 then
        Frame.Position = UDim2.fromScale(0.5, 1.15);
        Frame.Size = UDim2.fromScale(0.15, 0.15);
    else
        Frame.Position = UDim2.fromScale(0.5, 1.2);
        Frame.Size = UDim2.fromScale(0.5, 0.5);
    end;

    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.BottomLeftRadius = UDim.new(0.1, 0);
    UICorner.BottomRightRadius = UDim.new(0.1, 0);
    UICorner.CornerRadius = UDim.new(0.1, 0);
    UICorner.TopLeftRadius = UDim.new(0.1, 0);
    UICorner.TopRightRadius = UDim.new(0.1, 0);
    UICorner.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(0.5, 0.45);
    TextLabel.Size = UDim2.fromScale(0.9, 0.9);
    TextLabel.Text = "!";
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.new(1, 1, 1);
    TextLabel.ZIndex = 343;
    TextLabel.Parent = Frame;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 125, 49)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 125, 49)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 171, 26)) });
    UIGradient.Rotation = 45;
    UIGradient.Parent = Frame;
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "UIScale";
    UIScale.Scale = 0;
    UIScale.Parent = Frame;
    Frame.Parent = p131;
    TweenService:Create(UIScale, TweenInfo_new_ret3, {
        Scale = 1
    }):Play();
end;

return u1;