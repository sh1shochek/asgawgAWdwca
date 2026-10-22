-- ReplicatedStorage.GameClient.Gui.HUD.Tooltips
-- Script path: ReplicatedStorage.GameClient.Gui.HUD.Tooltips
-- Decompile time: 10.44 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
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
local u11 = 0;
local u12 = true;
local TweenInfo_new_ret = TweenInfo.new(2);
local TweenInfo_new_ret2 = TweenInfo.new(0.5);
local u13 = { { "Buymenu", "Buy Menu" }, { "Weapon Fire", "Fire" }, { "Weapon Alt Function", "Aim / Alt Fire" }, { "Weapon Reload", "Reload" }, { "Weapon Inspect", "Inspect" }, { "Character Use", "Interact / Plant" }, { "Character Walk", "Walk" }, { "Character Jump", "Jump" }, { "Character Duck", "Crouch" }, { "Scoreboard", "Scoreboard" }, { "MainMenu", "Main Menu" } };
local u14 = { { "Spectate Mode", "Change Mode" }, { "Spectate Next", "Next" }, { "Spectate Previous", "Previous" }, { "MainMenu", "Main Menu" }, { "Team Selection", "Team Selection" } };
local u15 = { { "Spectate Mode", "Change Mode" }, { "Spectate Next", "Next" }, { "Freecam Up", "Up" }, { "Freecam Down", "Down" }, { "Freecam Walk", "Slow" }, { "Freecam Up Speed", "Faster" }, { "Freecam Down Speed", "Slower" }, { "Freecam Field Of View Increase", "Zoom Out" }, { "Freecam Field Of View Decrease", "Zoom In" }, { "MainMenu", "Main Menu" } };
local u16 = {
    MouseButton1 = "M1",
    MouseButton2 = "M2",
    MouseButton3 = "M3",
    LeftControl = "CTRL",
    LeftShift = "SHIFT",
    ButtonSelect = "SELECT",
    ButtonStart = "START"
};

local function GetVisibleBinds(p17, p18, p19) -- Line: 73
    -- upvalues: u12 (ref), u8 (ref), u13 (copy), u5 (ref), u15 (copy), u14 (copy)
    if not u12 then
        return;
    end;

    if u8() == "Console" then
        if p18 ~= "MatchEnded" and p18 ~= "Restart" then
            return p19 and u13 or (u5.GetState() and u15 or u14);
        end;

        return;
    end;

    if p17 then
        return;
    end;

    if p19 then
        return p18 == "Preparation" and u13 or nil;
    end;

    if p18 ~= "MatchEnded" and p18 ~= "Restart" then
        return u14;
    end;
end;

local function CurrentBinds() -- Line: 91
    -- upvalues: GetVisibleBinds (copy), LocalPlayer (copy), GameStats (copy), u3 (ref)
    return GetVisibleBinds(LocalPlayer:GetAttribute("HasCompletedMatch"), GameStats:GetAttribute("State"), u3.IsAlive());
end;

local function FormatBind(p20) -- Line: 99
    -- upvalues: u16 (copy)
    if not p20 then
        return "UNBOUND";
    end;

    if typeof(p20) == "EnumItem" then
        p20 = p20.Name or p20;
    end;

    return u16[p20] or string.upper(string.gsub(p20, "^Button", ""));
end;

local function GetDefaultBind(p21, p22) -- Line: 108
    -- upvalues: u7 (ref)
    local v23 = u7.GetData().Controls[p21][p22].Default[1];

    if v23[1] == "None" then
        return nil;
    end;

    return Enum[v23[1]][v23[2]];
end;

function u1.Fade(p24) -- Line: 121
    -- upvalues: u11 (ref), u9 (ref), TweenInfo_new_ret2 (copy), TweenInfo_new_ret (copy), TweenService (copy)
    u11 = u11 + 1;
    local u25 = u11;

    if p24 then
        u9.Visible = true;
    end;

    for _, child in u9:GetChildren() do
        if child:IsA("Frame") and child.Visible then
            local Title = child.Title;
            local Bind = child.Bind;
            local BindTitle = Bind.BindTitle;
            local Icon = Bind.Icon;

            if p24 then
                Title.TextTransparency = 1;
                Bind.BackgroundTransparency = 1;
                BindTitle.TextTransparency = 1;
                Icon.ImageTransparency = 1;
            end;

            local v26 = p24 and 0 or 1;
            local v27 = p24 and TweenInfo_new_ret2 or TweenInfo_new_ret;
            TweenService:Create(Title, v27, {
                TextTransparency = v26
            }):Play();
            TweenService:Create(Bind, v27, {
                BackgroundTransparency = 0.8 + 0.2 * v26
            }):Play();
            TweenService:Create(BindTitle, v27, {
                TextTransparency = v26
            }):Play();
            TweenService:Create(Icon, v27, {
                ImageTransparency = v26
            }):Play();
        end;
    end;

    if not p24 then
        task.delay(2, function() -- Line: 155
            -- upvalues: u11 (ref), u25 (copy), u9 (ref)
            if u11 == u25 then
                u9.Visible = false;
            end;
        end);
    end;
end;

function u1.Draw(p28) -- Line: 163
    -- upvalues: u9 (ref), u8 (ref), u6 (ref), u7 (ref), u16 (copy), UserInputService (copy), u1 (copy)
    local v29 = {};

    for _, child in u9:GetChildren() do
        if child:IsA("Frame") then
            table.insert(v29, child);
        end;
    end;

    local v30 = u8() == "Console" and "Controller Binds" or "Keybinds";
    local Controls = u6:GetPlayerSettings().Controls;
    local v31 = Controls and (Controls[v30] or {}) or {};

    for i, v in p28 do
        local v32 = v31[v[1]];
        local v33 = v32 and (v32[1] or v32[2]);

        if not v33 then
            local v34 = v[1];
            local v35 = u7.GetData().Controls[v30][v34].Default[1];

            if v35[1] == "None" then
                v33 = nil;
            else
                v33 = Enum[v35[1]][v35[2]];
            end;
        end;

        local v36;

        if v33 then
            local v37;

            if typeof(v33) == "EnumItem" then
                v37 = v33.Name or v33;
            else
                v37 = v33;
            end;

            v36 = u16[v37] or string.upper(string.gsub(v37, "^Button", ""));
        else
            v36 = "UNBOUND";
        end;

        local v38 = v30 == "Controller Binds" and typeof(v33) == "EnumItem" and (UserInputService:GetImageForKeyCode(v33) or "") or "";
        local v39 = v[2];
        local v40 = v29[i];

        if v40 then
            v40.LayoutOrder = i;
            v40.Title.Text = v39;
            v40.Bind.BindTitle.Text = v36;
            v40.Visible = true;
        else
            v40 = u1.tooltipTemplate(v36, v39, i);
            v40.Parent = u9;
        end;

        v40.Bind.Icon.Image = v38;
        v40.Bind.Icon.Visible = v38 ~= "";
        v40.Bind.BindTitle.Visible = v38 == "";
    end;

    for i = #p28 + 1, #v29 do
        v29[i].Visible = false;
        local _ = i;
    end;
end;

function u1.Update() -- Line: 203
    -- upvalues: GetVisibleBinds (copy), LocalPlayer (copy), GameStats (copy), u3 (ref), u10 (ref), u1 (copy), u9 (ref)
    local v41 = GetVisibleBinds(LocalPlayer:GetAttribute("HasCompletedMatch"), GameStats:GetAttribute("State"), u3.IsAlive());
    u10 = v41;

    if not v41 then
        if u9.Visible then
            u1.Fade(false);
        end;

        return;
    end;

    u1.Draw(v41);
    u1.Fade(true);
end;

function u1.Init(p42) -- Line: 218
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u7 (ref), u8 (ref)
    u2 = p42:GetModule("Gui");
    u3 = p42:GetModule("CharacterController");
    u4 = p42:GetModule("CameraController");
    u5 = p42:GetModule("Freecam");
    u7 = p42:GetModule("SettingsData");
    u8 = p42:GetModule("GetUserPlatform");
end;

function u1.Start(p43) -- Line: 227
    -- upvalues: u6 (ref), u2 (ref), u9 (ref), u1 (copy), u12 (ref), GameStats (copy), LocalPlayer (copy), UserInputService (copy), u3 (ref), u4 (ref), GetVisibleBinds (copy), u10 (ref), u13 (copy), u14 (copy), u15 (copy)
    u6 = u2.GetComponent("Settings");
    u9 = u1.new();
    local PlayerSettings = u6:GetPlayerSettings();
    local v44 = PlayerSettings.Game and PlayerSettings.Game["HUD & UI"];
    u12 = not v44 or v44["Show Tooltips"] ~= false;
    GameStats:GetAttributeChangedSignal("State"):Connect(u1.Update);
    LocalPlayer:GetAttributeChangedSignal("HasCompletedMatch"):Connect(u1.Update);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(u1.Update);
    u3.OnCharacterSpawn:Connect(function() -- Line: 239
        -- upvalues: u1 (ref)
        task.defer(u1.Update);
    end);
    u3.OnCharacterDestroy:Connect(function() -- Line: 242
        -- upvalues: u1 (ref)
        task.defer(u1.Update);
    end);
    u4.CameraTargetUpdate:Connect(function() -- Line: 245
        -- upvalues: GetVisibleBinds (ref), LocalPlayer (ref), GameStats (ref), u3 (ref), u10 (ref), u1 (ref)
        task.defer(function() -- Line: 246
            -- upvalues: GetVisibleBinds (ref), LocalPlayer (ref), GameStats (ref), u3 (ref), u10 (ref), u1 (ref)
            if GetVisibleBinds(LocalPlayer:GetAttribute("HasCompletedMatch"), GameStats:GetAttribute("State"), u3.IsAlive()) ~= u10 then
                u1.Update();
            end;
        end);
    end);
    u6:AddConnection("Game", "HUD & UI", "Show Tooltips", function(p45) -- Line: 252
        -- upvalues: u12 (ref), u1 (ref)
        u12 = p45;
        u1.Update();
    end);

    for _, v in { u13, u14, u15 } do
        for _, v2 in v do
            u6:AddConnection("Controls", "Keybinds", v2[1], u1.Update);
            u6:AddConnection("Controls", "Controller Binds", v2[1], u1.Update);
        end;
    end;

    u1.Update();
end;

function u1.new() -- Line: 269
    -- upvalues: u2 (ref)
    local Frame = Instance.new("Frame");
    Frame.Name = "ToolTip";
    Frame.AnchorPoint = Vector2.new(1, 0.5);
    Frame.BackgroundTransparency = 1;
    Frame.Position = UDim2.fromScale(0.99, 0.5);
    Frame.Size = UDim2.fromScale(0.0867896, 0.0429333);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.Parent = Frame;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
    UIAspectRatioConstraint.AspectRatio = 3.66;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
    UIAspectRatioConstraint.Parent = Frame;
    Frame.Parent = u2.Handler.HUD;

    return Frame;
end;

function u1.tooltipTemplate(p46, p47, p48) -- Line: 295
    local Frame = Instance.new("Frame");
    Frame.Name = "TooltipTemplate";
    Frame.BackgroundTransparency = 1;
    Frame.LayoutOrder = p48;
    Frame.Size = UDim2.fromScale(1, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Title";
    TextLabel.AnchorPoint = Vector2.new(1, 0.5);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Position = UDim2.fromScale(1, 0.5);
    TextLabel.Size = UDim2.fromScale(0.72, 0.5);
    TextLabel.Text = p47;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.TextScaled = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Bind";
    Frame2.AnchorPoint = Vector2.new(0, 0.5);
    Frame2.BackgroundColor3 = Color3.new();
    Frame2.BackgroundTransparency = 0.8;
    Frame2.Position = UDim2.fromScale(0, 0.5);
    Frame2.Size = UDim2.fromScale(0.8, 0.8);
    Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    Frame2.Parent = Frame;
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(0.125, 0);
    UICorner.Parent = Frame2;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "BindTitle";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel2.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel2.Size = UDim2.fromScale(0.9, 0.7);
    TextLabel2.Text = p46;
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextScaled = true;
    TextLabel2.Parent = Frame2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(0.85, 0.85);
    ImageLabel.Visible = false;
    ImageLabel.Parent = Frame2;

    return Frame;
end;

return u1;