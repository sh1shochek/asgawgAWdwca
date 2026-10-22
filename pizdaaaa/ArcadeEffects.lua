-- ReplicatedStorage.ClientModules.ArcadeEffects
-- Script path: ReplicatedStorage.ClientModules.ArcadeEffects
-- Decompile time: 26.71 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local Roles = require(ReplicatedStorage.Shared.Roles);

local function IsAuthorized() -- Line: 21
    -- upvalues: LocalPlayer (copy), Roles (copy)
    if LocalPlayer then
        return Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    end;

    return false;
end;

local Characters = workspace:FindFirstChild("Characters");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
u1.State = {
    Outline = false,
    DamageBillboard = false,
    Hitmarker = false,
    RainbowHud = false,
    Hitsound = false,
    ComboMeter = false,
    ViewmodelOutline = false,
    Confetti = false
};
local State = u1.State;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = 0;
local u15 = 0;
local u16 = nil;
local u17 = nil;

local function GetGui() -- Line: 68
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    if not u2 then
        pcall(function() -- Line: 70
            -- upvalues: ReplicatedStorage (ref), u2 (ref)
            local ClientModule = require(ReplicatedStorage.ClientModules.ClientModule);

            if ClientModule and ClientModule.GetModule then
                u2 = ClientModule:GetModule("Gui");
            end;
        end);
    end;

    return u2;
end;

local function GetUIColor() -- Line: 80
    -- upvalues: u3 (ref), u2 (ref), ReplicatedStorage (copy)
    if not u3 then
        if not u2 then
            pcall(function() -- Line: 70
                -- upvalues: ReplicatedStorage (ref), u2 (ref)
                local ClientModule = require(ReplicatedStorage.ClientModules.ClientModule);

                if ClientModule and ClientModule.GetModule then
                    u2 = ClientModule:GetModule("Gui");
                end;
            end);
        end;

        local v18 = u2;

        if v18 and v18.GetComponent then
            u3 = v18.GetComponent("UIColor");
        end;

        if not u3 then
            pcall(function() -- Line: 87
                -- upvalues: u3 (ref), ReplicatedStorage (ref)
                u3 = require(ReplicatedStorage.GameClient.Gui.MainMenu.Utils.UIColor);
            end);
        end;
    end;

    return u3;
end;

local function GetEntities() -- Line: 95
    -- upvalues: u4 (ref), ReplicatedStorage (copy)
    if not u4 then
        pcall(function() -- Line: 97
            -- upvalues: u4 (ref), ReplicatedStorage (ref)
            u4 = require(ReplicatedStorage.GameClient.Entities);
        end);
    end;

    return u4;
end;

local function GetWeaponController() -- Line: 104
    -- upvalues: u6 (ref), ReplicatedStorage (copy)
    if not u6 then
        pcall(function() -- Line: 106
            -- upvalues: ReplicatedStorage (ref), u6 (ref)
            local ClientModule = require(ReplicatedStorage.ClientModules.ClientModule);

            if ClientModule and ClientModule.GetModule then
                u6 = ClientModule:GetModule("WeaponController");
            end;
        end);
    end;

    return u6;
end;

local function GetHUDParent() -- Line: 116
    -- upvalues: u2 (ref), ReplicatedStorage (copy), LocalPlayer (copy)
    if not u2 then
        pcall(function() -- Line: 70
            -- upvalues: ReplicatedStorage (ref), u2 (ref)
            local ClientModule = require(ReplicatedStorage.ClientModules.ClientModule);

            if ClientModule and ClientModule.GetModule then
                u2 = ClientModule:GetModule("Gui");
            end;
        end);
    end;

    local v19 = u2;
    local v20 = v19 and v19.Handler and v19.Handler:FindFirstChild("HUD");

    if v20 then
        v19 = v20;
    elseif v19 then
        v19 = v19.Handler;
    end;

    if not v19 and LocalPlayer then
        v19 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

        if v19 then
            v19 = v19:FindFirstChildWhichIsA("ScreenGui");
        end;
    end;

    return v19;
end;

local function ApplyHighlight(p21: userdata) -- Line: 130
    if not p21:IsA("Model") then
        return;
    end;

    if not p21:FindFirstChild("ArcadeHighlight") then
        local Highlight = Instance.new("Highlight");
        Highlight.Name = "ArcadeHighlight";
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
        Highlight.OutlineColor = Color3.fromRGB(0, 0, 0);
        Highlight.OutlineTransparency = 0;
        Highlight.FillColor = Color3.fromRGB(0, 0, 0);
        Highlight.FillTransparency = 1;
        Highlight.Adornee = p21;
        Highlight.Parent = p21;
    end;
end;

local function RemoveHighlight(p22: userdata) -- Line: 149
    local ArcadeHighlight = p22:FindFirstChild("ArcadeHighlight");

    if ArcadeHighlight then
        ArcadeHighlight:Destroy();
    end;
end;

function u1.SetOutline(p23: boolean) -- Line: 156
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), Characters (ref), u8 (ref), ApplyHighlight (copy)
    local v24;

    if LocalPlayer then
        v24 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v24 = false;
    end;

    if not v24 then
        State.Outline = false;

        return;
    end;

    State.Outline = p23;

    if not Characters then
        Characters = workspace:FindFirstChild("Characters");
    end;

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if not (p23 and Characters) then
        if Characters then
            for _, child in ipairs(Characters:GetChildren()) do
                local ArcadeHighlight = child:FindFirstChild("ArcadeHighlight");

                if ArcadeHighlight then
                    ArcadeHighlight:Destroy();
                end;
            end;
        end;

        return;
    end;

    for _, child in ipairs(Characters:GetChildren()) do
        ApplyHighlight(child);
    end;

    u8 = Characters.ChildAdded:Connect(function(u25) -- Line: 178
        -- upvalues: State (ref), LocalPlayer (ref), Roles (ref), ApplyHighlight (ref)
        if State.Outline then
            local v26;

            if LocalPlayer then
                v26 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
            else
                v26 = false;
            end;

            if v26 then
                task.defer(function() -- Line: 180
                    -- upvalues: ApplyHighlight (ref), u25 (copy)
                    ApplyHighlight(u25);
                end);
            end;
        end;
    end);
end;

local function SpawnDamageBillboard(p27: vector, p28: number, p29: boolean) -- Line: 196
    -- upvalues: State (copy), LocalPlayer (copy), Roles (copy), TweenService (copy), Debris (copy)
    if State.DamageBillboard then
        local v30;

        if LocalPlayer then
            v30 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v30 = false;
        end;

        if v30 and p27 then
            local v31 = (math.random() - 0.5) * 0.8;
            local v32 = 0.4 + math.random() * 0.3;
            local v33 = (math.random() - 0.5) * 0.8;
            local v34 = p27 + Vector3.new(v31, v32, v33);
            local Part = Instance.new("Part");
            Part.Name = "ArcadeDamagePart";
            Part.Size = Vector3.new(0.05, 0.05, 0.05);
            Part.Transparency = 1;
            Part.CanCollide = false;
            Part.CanQuery = false;
            Part.CanTouch = false;
            Part.Anchored = true;
            Part.CFrame = CFrame.new(v34);
            Part.Parent = workspace;
            local BillboardGui = Instance.new("BillboardGui");
            BillboardGui.Name = "DamageBillboard";
            BillboardGui.Adornee = Part;
            BillboardGui.Size = UDim2.fromOffset(110, 40);
            BillboardGui.AlwaysOnTop = true;
            BillboardGui.LightInfluence = 0;
            BillboardGui.MaxDistance = 350;
            BillboardGui.StudsOffset = Vector3.new(0, 0, 0);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "DamageLabel";
            TextLabel.Size = UDim2.fromScale(1, 1);
            TextLabel.BackgroundTransparency = 1;
            local math_round_ret = math.round(p28);
            TextLabel.Text = "-" .. tostring(math_round_ret);
            TextLabel.TextColor3 = p29 and Color3.fromRGB(255, 220, 40) or Color3.fromRGB(255, 60, 60);
            TextLabel.TextScaled = true;
            TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Normal);
            TextLabel.TextTransparency = 0;
            local UIStroke = Instance.new("UIStroke");
            UIStroke.Color = Color3.fromRGB(15, 15, 15);
            UIStroke.Thickness = 2;
            UIStroke.Transparency = 0;
            UIStroke.Parent = TextLabel;
            TextLabel.Parent = BillboardGui;
            BillboardGui.Parent = Part;
            TweenService:Create(BillboardGui, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                StudsOffset = Vector3.new(0, 2.5, 0)
            }):Play();
            task.delay(0.4, function() -- Line: 252
                -- upvalues: TweenService (ref), TextLabel (copy), UIStroke (copy)
                local TweenInfo_new_ret = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                TweenService:Create(TextLabel, TweenInfo_new_ret, {
                    TextTransparency = 1
                }):Play();
                TweenService:Create(UIStroke, TweenInfo_new_ret, {
                    Transparency = 1
                }):Play();
            end);
            Debris:AddItem(Part, 0.95);
        end;
    end;
end;

function u1.SetDamageBillboard(p35: boolean) -- Line: 262
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy)
    local v36;

    if LocalPlayer then
        v36 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v36 = false;
    end;

    if v36 then
        State.DamageBillboard = p35;

        return;
    end;

    State.DamageBillboard = false;
end;

local function EnsureHitmarkerUI() -- Line: 274
    -- upvalues: u9 (ref), GetHUDParent (copy)
    if u9 and u9.Parent then
        return u9;
    end;

    local v37 = GetHUDParent();

    if not v37 then
        return nil;
    end;

    u9 = Instance.new("Frame");
    u9.Name = "ArcadeHitmarker";
    u9.AnchorPoint = Vector2.new(0.5, 0.5);
    u9.Position = UDim2.fromScale(0.5, 0.5);
    u9.Size = UDim2.fromOffset(36, 36);
    u9.BackgroundTransparency = 1;
    u9.Visible = false;
    u9.ZIndex = 30;
    local v38 = {
        {
            Rot = 45,
            Pos = UDim2.new(0.5, -8, 0.5, -8)
        },
        {
            Rot = -45,
            Pos = UDim2.new(0.5, 8, 0.5, -8)
        },
        {
            Rot = -45,
            Pos = UDim2.new(0.5, -8, 0.5, 8)
        },
        {
            Rot = 45,
            Pos = UDim2.new(0.5, 8, 0.5, 8)
        }
    };

    for i, v in ipairs(v38) do
        local Frame = Instance.new("Frame");
        Frame.Name = "Tick" .. i;
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = v.Pos;
        Frame.Size = UDim2.fromOffset(8, 2.5);
        Frame.Rotation = v.Rot;
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Frame.BorderSizePixel = 0;
        Frame.BackgroundTransparency = 1;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3.fromRGB(0, 0, 0);
        UIStroke.Thickness = 1;
        UIStroke.Transparency = 1;
        UIStroke.Parent = Frame;
        Frame.Parent = u9;
    end;

    u9.Parent = v37;

    return u9;
end;

local function TriggerHitmarker(p39: boolean) -- Line: 324
    -- upvalues: State (copy), LocalPlayer (copy), Roles (copy), EnsureHitmarkerUI (copy), TweenService (copy)
    if State.Hitmarker then
        local v40;

        if LocalPlayer then
            v40 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v40 = false;
        end;

        if v40 then
            local u41 = EnsureHitmarkerUI();

            if not u41 then
                return;
            end;

            local v42 = p39 and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 255, 255);

            for _, child in ipairs(u41:GetChildren()) do
                if child:IsA("Frame") then
                    child.BackgroundColor3 = v42;
                    child.BackgroundTransparency = 0;
                    local v43 = child:FindFirstChildOfClass("UIStroke");

                    if v43 then
                        v43.Transparency = 0;
                    end;
                end;
            end;

            u41.Visible = true;
            u41.Size = UDim2.fromOffset(46, 46);
            TweenService:Create(u41, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(36, 36)
            }):Play();
            task.delay(0.04, function() -- Line: 352
                -- upvalues: u41 (copy), TweenService (ref)
                for _, child in ipairs(u41:GetChildren()) do
                    if child:IsA("Frame") then
                        local TweenInfo_new_ret = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                        TweenService:Create(child, TweenInfo_new_ret, {
                            BackgroundTransparency = 1
                        }):Play();
                        local v44 = child:FindFirstChildOfClass("UIStroke");

                        if v44 then
                            TweenService:Create(v44, TweenInfo_new_ret, {
                                Transparency = 1
                            }):Play();
                        end;
                    end;
                end;

                task.delay(0.22, function() -- Line: 364
                    -- upvalues: u41 (ref)
                    if u41 and u41.Visible then
                        u41.Visible = false;
                    end;
                end);
            end);
        end;
    end;
end;

function u1.SetHitmarker(p45: boolean) -- Line: 372
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), u9 (ref)
    local v46;

    if LocalPlayer then
        v46 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v46 = false;
    end;

    if v46 then
        State.Hitmarker = p45;

        if not p45 and u9 then
            u9.Visible = false;
        end;

        return;
    end;

    State.Hitmarker = false;

    if u9 then
        u9.Visible = false;
    end;
end;

function u1.SetRainbowHud(p47: boolean) -- Line: 388
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), u7 (ref), GetUIColor (copy), RunService (copy), u1 (copy)
    local v48;

    if LocalPlayer then
        v48 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v48 = false;
    end;

    if not v48 then
        State.RainbowHud = false;

        if u7 then
            u7:Disconnect();
            u7 = nil;
        end;

        return;
    end;

    State.RainbowHud = p47;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if p47 then
        local u49 = GetUIColor();
        u7 = RunService.RenderStepped:Connect(function() -- Line: 407
            -- upvalues: LocalPlayer (ref), Roles (ref), u1 (ref), u49 (copy)
            local v50;

            if LocalPlayer then
                v50 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
            else
                v50 = false;
            end;

            if not v50 then
                u1.SetRainbowHud(false);

                return;
            end;

            local v51 = os.clock() * 0.4 % 1;
            local Color3_fromHSV_ret = Color3.fromHSV(v51, 0.85, 1);

            if u49 then
                u49.SetHudColor(Color3_fromHSV_ret);
            end;
        end);

        return;
    end;

    local v52 = GetUIColor();

    if v52 then
        v52.ResetHudColor();
    end;
end;

local function PlayHitSound() -- Line: 430
    -- upvalues: State (copy), LocalPlayer (copy), Roles (copy), u10 (ref), ReplicatedStorage (copy), SoundService (copy)
    if State.Hitsound then
        local v53;

        if LocalPlayer then
            v53 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v53 = false;
        end;

        if v53 then
            if not (u10 and u10.Parent) then
                u10 = Instance.new("Sound");
                u10.Name = "ArcadeHitSound";
                u10.SoundId = "rbxassetid://77082587278347";
                u10.Volume = 1;
                u10.SoundGroup = require(ReplicatedStorage.Shared.Managers.SoundManager).GetGroup("SFX");
                u10.Parent = SoundService;
            end;

            u10.TimePosition = 0;
            u10:Play();
        end;
    end;
end;

function u1.SetHitsound(p54: boolean) -- Line: 448
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy)
    local v55;

    if LocalPlayer then
        v55 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v55 = false;
    end;

    if v55 then
        State.Hitsound = p54;

        return;
    end;

    State.Hitsound = false;
end;

local function EnsureComboUI() -- Line: 460
    -- upvalues: u11 (ref), GetHUDParent (copy)
    if u11 and u11.Parent then
        return u11;
    end;

    local v56 = GetHUDParent();

    if not v56 then
        return nil;
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "ArcadeComboMeter";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.new(0.5, 0, 0.28, 0);
    Frame.Size = UDim2.fromOffset(220, 56);
    Frame.BackgroundTransparency = 1;
    Frame.Visible = false;
    Frame.ZIndex = 30;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "ComboText";
    TextLabel.Size = UDim2.new(1, 0, 0, 36);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "x2 COMBO!";
    TextLabel.TextColor3 = Color3.fromRGB(0, 240, 255);
    TextLabel.TextScaled = true;
    TextLabel.FontFace = Font.new("rbxassetid://12187375422", Enum.FontWeight.Heavy, Enum.FontStyle.Italic);
    TextLabel.ZIndex = 31;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(10, 10, 15);
    UIStroke.Thickness = 2.5;
    UIStroke.Parent = TextLabel;
    TextLabel.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "TimerBarBg";
    Frame2.Size = UDim2.new(0.7, 0, 0, 4);
    Frame2.Position = UDim2.new(0.15, 0, 0, 42);
    Frame2.BackgroundColor3 = Color3.fromRGB(20, 25, 35);
    Frame2.BorderSizePixel = 0;
    Frame2.ZIndex = 31;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "TimerBarFill";
    Frame3.Size = UDim2.new(1, 0, 1, 0);
    Frame3.BackgroundColor3 = Color3.fromRGB(0, 240, 255);
    Frame3.BorderSizePixel = 0;
    Frame3.ZIndex = 32;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(1, 0);
    UICorner2.Parent = Frame3;
    Frame3.Parent = Frame2;
    Frame2.Parent = Frame;
    Frame.Parent = v56;
    u11 = Frame;

    return Frame;
end;

local function TriggerComboKill() -- Line: 525
    -- upvalues: State (copy), LocalPlayer (copy), Roles (copy), u14 (ref), u15 (ref), EnsureComboUI (copy), TweenService (copy)
    if State.ComboMeter then
        local v57;

        if LocalPlayer then
            v57 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v57 = false;
        end;

        if v57 then
            u14 = u14 + 1;
            u15 = 5;
            local v58 = EnsureComboUI();

            if not v58 then
                return;
            end;

            local ComboText = v58:FindFirstChild("ComboText");
            local TimerBarFill = v58:FindFirstChild("TimerBarFill", true);
            local string_format_ret = string.format("x%d COMBO!", u14);
            local Color3_fromRGB_ret = Color3.fromRGB(0, 240, 255);

            if u14 == 1 then
                Color3_fromRGB_ret = Color3.fromRGB(0, 240, 255);
                string_format_ret = "KILL!";
            elseif u14 == 2 then
                Color3_fromRGB_ret = Color3.fromRGB(0, 240, 255);
                string_format_ret = "x2 DOUBLE KILL!";
            elseif u14 == 3 then
                Color3_fromRGB_ret = Color3.fromRGB(255, 215, 30);
                string_format_ret = "x3 MULTI KILL!";
            elseif u14 == 4 then
                Color3_fromRGB_ret = Color3.fromRGB(255, 120, 20);
                string_format_ret = "x4 ULTRA KILL!";
            elseif u14 >= 5 then
                string_format_ret = string.format("x%d UNSTOPPABLE!", u14);
                Color3_fromRGB_ret = Color3.fromRGB(255, 40, 180);
            end;

            if ComboText and ComboText:IsA("TextLabel") then
                ComboText.Text = string_format_ret;
                ComboText.TextColor3 = Color3_fromRGB_ret;
                ComboText.TextTransparency = 0;
            end;

            if TimerBarFill and TimerBarFill:IsA("Frame") then
                TimerBarFill.BackgroundColor3 = Color3_fromRGB_ret;
            end;

            v58.Visible = true;
            v58.Size = UDim2.fromOffset(260, 66);
            TweenService:Create(v58, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(220, 56)
            }):Play();
        end;
    end;
end;

function u1.SetComboMeter(p59: boolean) -- Line: 576
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), u12 (ref), u13 (ref), u11 (ref), u14 (ref), u15 (ref), TriggerComboKill (copy), RunService (copy), u1 (copy), TweenService (copy)
    local v60;

    if LocalPlayer then
        v60 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v60 = false;
    end;

    if not v60 then
        State.ComboMeter = false;

        if u12 then
            u12:Disconnect();
            u12 = nil;
        end;

        if u13 then
            u13:Disconnect();
            u13 = nil;
        end;

        if u11 then
            u11:Destroy();
            u11 = nil;
        end;

        u14 = 0;

        return;
    end;

    State.ComboMeter = p59;

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    if u13 then
        u13:Disconnect();
        u13 = nil;
    end;

    if not p59 then
        if u11 then
            u11:Destroy();
            u11 = nil;
        end;

        u14 = 0;

        return;
    end;

    u14 = 0;
    u15 = 0;

    if LocalPlayer then
        u13 = LocalPlayer:GetAttributeChangedSignal("Kills"):Connect(function() -- Line: 596
            -- upvalues: LocalPlayer (ref), Roles (ref), State (ref), TriggerComboKill (ref)
            local v61;

            if LocalPlayer then
                v61 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
            else
                v61 = false;
            end;

            if v61 and State.ComboMeter then
                TriggerComboKill();
            end;
        end);
    end;

    u12 = RunService.RenderStepped:Connect(function(p62) -- Line: 603
        -- upvalues: LocalPlayer (ref), Roles (ref), State (ref), u1 (ref), u15 (ref), u11 (ref), u14 (ref), TweenService (ref)
        local v63;

        if LocalPlayer then
            v63 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v63 = false;
        end;

        if v63 and State.ComboMeter then
            if u15 > 0 then
                u15 = math.max(0, u15 - p62);

                if u11 and u11.Visible then
                    local TimerBarFill = u11:FindFirstChild("TimerBarFill", true);

                    if TimerBarFill and TimerBarFill:IsA("Frame") then
                        TimerBarFill.Size = UDim2.new(math.clamp(u15 / 5, 0, 1), 0, 1, 0);

                        return;
                    end;
                end;
            elseif u14 > 0 then
                u14 = 0;

                if u11 and u11.Visible then
                    TweenService:Create(u11, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Size = UDim2.fromOffset(180, 44)
                    }):Play();
                    task.delay(0.25, function() -- Line: 624
                        -- upvalues: u11 (ref), u15 (ref)
                        if u11 and u15 <= 0 then
                            u11.Visible = false;
                            u11.Size = UDim2.fromOffset(220, 56);
                        end;
                    end);
                end;
            end;

            return;
        end;

        u1.SetComboMeter(false);
    end);
end;

local function ApplyViewmodelHighlight(p64: userdata) -- Line: 646
    if not (p64 and p64:IsA("Model")) then
        return;
    end;

    if not p64:FindFirstChild("ArcadeViewmodelHighlight") then
        local Highlight = Instance.new("Highlight");
        Highlight.Name = "ArcadeViewmodelHighlight";
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
        Highlight.OutlineColor = Color3.fromRGB(0, 0, 0);
        Highlight.OutlineTransparency = 0;
        Highlight.FillColor = Color3.fromRGB(0, 0, 0);
        Highlight.FillTransparency = 1;
        Highlight.Adornee = p64;
        Highlight.Parent = p64;
    end;
end;

local function RemoveViewmodelHighlights() -- Line: 665
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        for _, child in ipairs(workspace_CurrentCamera:GetChildren()) do
            if child:IsA("Model") then
                local ArcadeViewmodelHighlight = child:FindFirstChild("ArcadeViewmodelHighlight");

                if ArcadeViewmodelHighlight then
                    ArcadeViewmodelHighlight:Destroy();
                end;
            end;
        end;
    end;

    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") and child.Name:find("Viewmodel") then
            local ArcadeViewmodelHighlight = child:FindFirstChild("ArcadeViewmodelHighlight");

            if ArcadeViewmodelHighlight then
                ArcadeViewmodelHighlight:Destroy();
            end;
        end;
    end;
end;

local function ScanAndHighlightViewmodels() -- Line: 683
    -- upvalues: State (copy), LocalPlayer (copy), Roles (copy), ApplyViewmodelHighlight (copy)
    if State.ViewmodelOutline then
        local v65;

        if LocalPlayer then
            v65 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v65 = false;
        end;

        if v65 then
            local workspace_CurrentCamera = workspace.CurrentCamera;

            if workspace_CurrentCamera then
                for _, child in ipairs(workspace_CurrentCamera:GetChildren()) do
                    if child:IsA("Model") then
                        ApplyViewmodelHighlight(child);
                    end;
                end;
            end;
        end;
    end;
end;

function u1.SetViewmodelOutline(p66: boolean) -- Line: 698
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), RemoveViewmodelHighlights (copy), u16 (ref), u17 (ref), ScanAndHighlightViewmodels (copy), ApplyViewmodelHighlight (copy), u6 (ref), ReplicatedStorage (copy)
    local v67;

    if LocalPlayer then
        v67 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v67 = false;
    end;

    if v67 then
        State.ViewmodelOutline = p66;

        if u16 then
            u16:Disconnect();
            u16 = nil;
        end;

        if u17 then
            u17:Disconnect();
            u17 = nil;
        end;

        if p66 then
            ScanAndHighlightViewmodels();
            local workspace_CurrentCamera = workspace.CurrentCamera;

            if workspace_CurrentCamera then
                u16 = workspace_CurrentCamera.ChildAdded:Connect(function(u68) -- Line: 717
                    -- upvalues: State (ref), LocalPlayer (ref), Roles (ref), ApplyViewmodelHighlight (ref)
                    if State.ViewmodelOutline then
                        local v69;

                        if LocalPlayer then
                            v69 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
                        else
                            v69 = false;
                        end;

                        if v69 and u68:IsA("Model") then
                            task.defer(function() -- Line: 719
                                -- upvalues: ApplyViewmodelHighlight (ref), u68 (copy)
                                ApplyViewmodelHighlight(u68);
                            end);
                        end;
                    end;
                end);
            end;

            if not u6 then
                pcall(function() -- Line: 106
                    -- upvalues: ReplicatedStorage (ref), u6 (ref)
                    local ClientModule = require(ReplicatedStorage.ClientModules.ClientModule);

                    if ClientModule and ClientModule.GetModule then
                        u6 = ClientModule:GetModule("WeaponController");
                    end;
                end);
            end;

            local v70 = u6;

            if v70 and v70.OnWeaponChanged then
                u17 = v70.OnWeaponChanged:Connect(function(u71) -- Line: 728
                    -- upvalues: State (ref), LocalPlayer (ref), Roles (ref), ApplyViewmodelHighlight (ref)
                    if State.ViewmodelOutline then
                        local v72;

                        if LocalPlayer then
                            v72 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
                        else
                            v72 = false;
                        end;

                        if v72 and (u71 and u71.Viewmodel) then
                            task.defer(function() -- Line: 730
                                -- upvalues: ApplyViewmodelHighlight (ref), u71 (copy)
                                ApplyViewmodelHighlight(u71.Viewmodel);
                            end);
                        end;
                    end;
                end);

                return;
            end;
        else
            RemoveViewmodelHighlights();
        end;

        return;
    end;

    State.ViewmodelOutline = false;
    RemoveViewmodelHighlights();

    if u16 then
        u16:Disconnect();
        u16 = nil;
    end;

    if u17 then
        u17:Disconnect();
        u17 = nil;
    end;
end;

local u73 = {
    Color3.fromRGB(255, 60, 120),
    Color3.fromRGB(255, 220, 40),
    Color3.fromRGB(0, 240, 255),
    Color3.fromRGB(100, 255, 70),
    Color3.fromRGB(255, 140, 0),
    Color3.fromRGB(180, 80, 255)
};

local function SpawnHeadshotConfetti(p74: vector) -- Line: 754
    -- upvalues: State (copy), LocalPlayer (copy), Roles (copy), u73 (copy), TweenService (copy), Debris (copy)
    if State.Confetti then
        local v75;

        if LocalPlayer then
            v75 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v75 = false;
        end;

        if v75 and p74 then
            for i = 1, 16 do
                local Part = Instance.new("Part");
                Part.Name = "ArcadeConfetti";
                Part.Size = Vector3.new(0.15, 0.15, 0.02);
                Part.Material = Enum.Material.Neon;
                Part.Color = u73[math.random(1, #u73)];
                Part.CFrame = CFrame.new(p74) * CFrame.Angles(math.random() * 6.28, math.random() * 6.28, math.random() * 6.28);
                Part.Anchored = false;
                Part.CanCollide = false;
                Part.CanTouch = false;
                Part.CanQuery = false;
                Part.Massless = true;
                local v76 = (math.random() - 0.5) * 20;
                local math_random_ret = math.random(10, 22);
                local v77 = (math.random() - 0.5) * 20;
                Part.AssemblyLinearVelocity = Vector3.new(v76, math_random_ret, v77);
                local math_random_ret2 = math.random(-15, 15);
                local math_random_ret3 = math.random(-15, 15);
                Part.AssemblyAngularVelocity = Vector3.new(math_random_ret2, math_random_ret3, math.random(-15, 15));
                Part.Parent = workspace;
                task.delay(0.5, function() -- Line: 781
                    -- upvalues: Part (copy), TweenService (ref)
                    if Part and Part.Parent then
                        TweenService:Create(Part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Transparency = 1
                        }):Play();
                    end;
                end);
                Debris:AddItem(Part, 0.9);
                local _ = i;
            end;
        end;
    end;
end;

function u1.SetConfetti(p78: boolean) -- Line: 794
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy)
    local v79;

    if LocalPlayer then
        v79 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v79 = false;
    end;

    if v79 then
        State.Confetti = p78;

        return;
    end;

    State.Confetti = false;
end;

function u1.SetAll(p80: boolean) -- Line: 806
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), u1 (copy)
    local v81;

    if LocalPlayer then
        v81 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v81 = false;
    end;

    if v81 then
        u1.SetOutline(p80);
        u1.SetDamageBillboard(p80);
        u1.SetHitmarker(p80);
        u1.SetRainbowHud(p80);
        u1.SetHitsound(p80);
        u1.SetComboMeter(p80);
        u1.SetViewmodelOutline(p80);
        u1.SetConfetti(p80);

        return;
    end;

    State.Outline = false;
    State.DamageBillboard = false;
    State.Hitmarker = false;
    State.RainbowHud = false;
    State.Hitsound = false;
    State.ComboMeter = false;
    State.ViewmodelOutline = false;
    State.Confetti = false;
end;

function u1.ProcessHits(p82, p83) -- Line: 833
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), u4 (ref), ReplicatedStorage (copy), Players (copy), SpawnHeadshotConfetti (copy), SpawnDamageBillboard (copy), TriggerHitmarker (copy), PlayHitSound (copy)
    if p83 and next(p83) then
        local v84;

        if LocalPlayer then
            v84 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
        else
            v84 = false;
        end;

        if v84 then
            if not (State.DamageBillboard or (State.Hitmarker or (State.Hitsound or State.Confetti))) then
                return;
            end;

            if not u4 then
                pcall(function() -- Line: 97
                    -- upvalues: u4 (ref), ReplicatedStorage (ref)
                    u4 = require(ReplicatedStorage.GameClient.Entities);
                end);
            end;

            local v85 = u4;
            local v86 = LocalPlayer and LocalPlayer:GetAttribute("Team");
            local v87 = false;
            local v88 = false;

            for i, v in pairs(p83) do
                local v89;

                if v85 then
                    v89 = v85.GetEntity("Character", i);
                else
                    v89 = v85;
                end;

                if v89 then
                    local UserId = v89.UserId;

                    if UserId then
                        if UserId == 0 then
                            UserId = false;
                        else
                            UserId = Players:GetPlayerByUserId(UserId);
                        end;
                    end;

                    if not (UserId and UserId == LocalPlayer or v89.Data and v89.Data.Team == v86) then
                        for _, v2 in ipairs(v[1] and v and v or { v }) do
                            local Object = v2.Object;

                            if Object then
                                Object = Object.Name;
                            end;

                            local v90;

                            if Object == "Head" then
                                v90 = v2.DamageType ~= "Slash";
                            else
                                v90 = false;
                            end;

                            local v91 = v2.Damage or 25;
                            local Position = v2.Position;

                            if typeof(Position) == "vector" then
                                Position = Vector3.new(Position.X, Position.Y, Position.Z);
                            elseif not Position and v89.Position then
                                local Position2 = v89.Position;
                                Position = Vector3.new(Position2.X, Position2.Y + 1.5, Position2.Z);
                            end;

                            v87 = true;

                            if v90 then
                                v88 = true;

                                if State.Confetti and Position then
                                    SpawnHeadshotConfetti(Position);
                                end;
                            end;

                            if State.DamageBillboard and Position then
                                SpawnDamageBillboard(Position, v91, v90);
                            end;
                        end;
                    end;
                end;
            end;

            if v87 then
                if State.Hitmarker then
                    TriggerHitmarker(v88);
                end;

                if State.Hitsound then
                    PlayHitSound();
                end;
            end;
        end;
    end;
end;

function u1.HandleCommand(p92: table) -- Line: 906
    -- upvalues: LocalPlayer (copy), Roles (copy), State (copy), u1 (copy)
    local v93;

    if LocalPlayer then
        v93 = Roles.IsDeveloper(LocalPlayer.UserId) or Roles.IsStar(LocalPlayer.UserId);
    else
        v93 = false;
    end;

    if not v93 then
        return "sv_arcade: Access denied. Developer or Star role required.", false;
    end;

    local v94 = p92[1];
    local v95 = p92[2];

    local function ParseBool(p96, p97) -- Line: 914
        if p96 == nil then
            return p97;
        end;

        if typeof(p96) == "boolean" then
            return p96;
        end;

        if typeof(p96) == "number" then
            return p96 ~= 0;
        end;

        local v98 = tostring(p96):lower();

        if v98 == "1" or (v98 == "true" or (v98 == "on" or v98 == "yes")) then
            return true;
        end;

        if v98 == "0" or (v98 == "false" or (v98 == "off" or v98 == "no")) then
            return false;
        end;

        return p97;
    end;

    local function AllActive() -- Line: 924
        -- upvalues: State (ref)
        return State.Outline and (State.DamageBillboard and State.Hitmarker) and (State.RainbowHud and State.Hitsound and (State.ComboMeter and State.ViewmodelOutline)) and State.Confetti;
    end;

    local function FormatStatus() -- Line: 929
        -- upvalues: State (ref)
        return string.format("sv_arcade status:\n  outline: %s\n  damage: %s\n  hitmarker: %s\n  rainbow: %s\n  hitsound: %s\n  combo: %s\n  viewmodel: %s\n  confetti: %s", State.Outline and "ON" or "off", State.DamageBillboard and "ON" or "off", State.Hitmarker and "ON" or "off", State.RainbowHud and "ON" or "off", State.Hitsound and "ON" or "off", State.ComboMeter and "ON" or "off", State.ViewmodelOutline and "ON" or "off", State.Confetti and "ON" or "off");
    end;

    if v94 == nil then
        local v99 = not (State.Outline and (State.DamageBillboard and State.Hitmarker) and (State.RainbowHud and State.Hitsound and (State.ComboMeter and State.ViewmodelOutline)) and State.Confetti);
        u1.SetAll(v99);

        return string.format("sv_arcade: all %s\n%s", v99 and "ENABLED" or "DISABLED", FormatStatus()), true;
    end;

    local v100 = tostring(v94):lower();

    if v100 == "all" then
        local v101 = ParseBool(v95, not (State.Outline and (State.DamageBillboard and State.Hitmarker) and (State.RainbowHud and State.Hitsound and (State.ComboMeter and State.ViewmodelOutline)) and State.Confetti));
        u1.SetAll(v101);

        return string.format("sv_arcade all = %s\n%s", v101 and "1 (ON)" or "0 (OFF)", FormatStatus()), true;
    end;

    if v100 == "1" or (v100 == "true" or v100 == "on") then
        u1.SetAll(true);

        return string.format("sv_arcade: all ENABLED\n%s", FormatStatus()), true;
    end;

    if v100 == "0" or (v100 == "false" or v100 == "off") then
        u1.SetAll(false);

        return string.format("sv_arcade: all DISABLED\n%s", FormatStatus()), true;
    end;

    if v100 == "outline" or (v100 == "outlines" or (v100 == "highlight" or v100 == "highlights")) then
        local v102 = ParseBool(v95, not State.Outline);
        u1.SetOutline(v102);

        return string.format("sv_arcade outline = %s", v102 and "1 (ON)" or "0 (OFF)"), true;
    end;

    if v100 == "damage" or (v100 == "damagenumbers" or (v100 == "billboard" or v100 == "damage_numbers")) then
        local v103 = ParseBool(v95, not State.DamageBillboard);
        u1.SetDamageBillboard(v103);

        return string.format("sv_arcade damage = %s", v103 and "1 (ON)" or "0 (OFF)"), true;
    end;

    if v100 == "hitmarker" or (v100 == "crosshair" or v100 == "marker") then
        local v104 = ParseBool(v95, not State.Hitmarker);
        u1.SetHitmarker(v104);

        return string.format("sv_arcade hitmarker = %s", v104 and "1 (ON)" or "0 (OFF)"), true;
    end;

    if v100 == "rainbow" or (v100 == "hud" or (v100 == "rainbowhud" or v100 == "rainbow_hud")) then
        local v105 = ParseBool(v95, not State.RainbowHud);
        u1.SetRainbowHud(v105);

        return string.format("sv_arcade rainbow = %s", v105 and "1 (ON)" or "0 (OFF)"), true;
    end;

    if v100 == "hitsound" or (v100 == "sound" or v100 == "audio") then
        local v106 = ParseBool(v95, not State.Hitsound);
        u1.SetHitsound(v106);

        return string.format("sv_arcade hitsound = %s", v106 and "1 (ON)" or "0 (OFF)"), true;
    end;

    if v100 == "combo" or (v100 == "combometer" or (v100 == "multikill" or v100 == "streak")) then
        local v107 = ParseBool(v95, not State.ComboMeter);
        u1.SetComboMeter(v107);

        return string.format("sv_arcade combo = %s", v107 and "1 (ON)" or "0 (OFF)"), true;
    end;

    if v100 == "viewmodel" or (v100 == "vm" or (v100 == "viewmodeloutline" or v100 == "vmoutline")) then
        local v108 = ParseBool(v95, not State.ViewmodelOutline);
        u1.SetViewmodelOutline(v108);

        return string.format("sv_arcade viewmodel = %s", v108 and "1 (ON)" or "0 (OFF)"), true;
    end;

    if v100 ~= "confetti" and (v100 ~= "headshot" and v100 ~= "headshotconfetti") then
        if v100 == "status" then
            return FormatStatus(), true;
        end;

        return string.format("sv_arcade: unknown option \'%s\'. Options: all, outline, damage, hitmarker, rainbow, hitsound, combo, viewmodel, confetti, 0, 1", (tostring(v94))), false;
    end;

    local v109 = ParseBool(v95, not State.Confetti);
    u1.SetConfetti(v109);

    return string.format("sv_arcade confetti = %s", v109 and "1 (ON)" or "0 (OFF)"), true;
end;

function u1.Init(p110) -- Line: 1004
    -- upvalues: u2 (ref), u4 (ref), u5 (ref), u6 (ref)
    u2 = p110:GetModule("Gui");
    u4 = p110:GetModule("Entities");
    u5 = p110:GetModule("CharacterController");
    u6 = p110:GetModule("WeaponController");
end;

function u1.Start(p111) -- Line: 1011
    -- upvalues: Characters (ref)
    if not Characters then
        Characters = workspace:FindFirstChild("Characters");
    end;
end;

return u1;