-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local HudTarget = require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local u2 = require(ReplicatedStorage.Shared.Janitor).new();
local u3 = 0;
local u4 = nil;
local u5 = nil;

function u1.animateFrame() -- Line: 48
    -- upvalues: u5 (ref), TweenService (copy), Debris (copy)
    local v6 = u5.Amount:Clone();
    v6.TextColor3 = Color3.fromRGB(255, 0, 4);
    v6.ZIndex = u5.ZIndex - 1;
    v6.Parent = u5;
    TweenService:Create(u5.Amount.UIScale, TweenInfo.new(0.07), {
        Scale = 1.1
    }):Play();
    task.wait(0.07);
    TweenService:Create(u5.Amount.UIScale, TweenInfo.new(0.07, Enum.EasingStyle.Elastic), {
        Scale = 1
    }):Play();
    TweenService:Create(v6, TweenInfo.new(0.5), {
        Position = v6.Position + UDim2.fromScale(0, 0.25)
    }):Play();
    TweenService:Create(v6, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play();
    Debris:AddItem(v6, 0.5);
end;

function u1.updateFrame(p7: number, p8: number) -- Line: 62
    -- upvalues: u5 (ref), GetPreferenceColor (copy), TweenService (copy), u3 (ref), u1 (copy)
    if p8 <= 0 then
        return;
    end;

    local v9 = p7 / p8;
    local Amount = u5.Amount;
    local math_ceil_ret = math.ceil(p7);
    Amount.Text = tostring(math_ceil_ret);
    u5.Frame.Bar.BackgroundColor3 = GetPreferenceColor();
    u5.Amount.TextColor3 = GetPreferenceColor();
    u5.Glow.ImageTransparency = 1;
    TweenService:Create(u5.Frame.Bar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(v9, 1)
    }):Play();

    if v9 <= 0.5 then
        u5.Glow.ImageTransparency = math.max((0.5 - v9) * 2, 0.3);
    end;

    if p7 < u3 then
        task.spawn(u1.animateFrame);
    end;

    u3 = p7;
end;

local function updateFromAttributes(p10: userdata) -- Line: 85
    -- upvalues: u1 (copy)
    local Attribute = p10:GetAttribute("Health");
    local Attribute2 = p10:GetAttribute("MaxHealth");

    if typeof(Attribute) == "number" and (typeof(Attribute2) == "number" and Attribute2 > 0) then
        u1.updateFrame(math.max(Attribute, 0), Attribute2);
    end;
end;

local function trackPlayer(u11: userdata) -- Line: 93
    -- upvalues: u2 (copy), u4 (ref), u1 (copy), u3 (ref)
    u2:Cleanup();
    u4 = u11;

    local function update() -- Line: 97
        -- upvalues: u11 (copy), u1 (ref)
        local v12 = u11;
        local Attribute = v12:GetAttribute("Health");
        local Attribute2 = v12:GetAttribute("MaxHealth");

        if typeof(Attribute) == "number" and (typeof(Attribute2) == "number" and Attribute2 > 0) then
            u1.updateFrame(math.max(Attribute, 0), Attribute2);
        end;
    end;

    local Attribute = u11:GetAttribute("Health");
    u3 = typeof(Attribute) ~= "number" and 0 or Attribute;
    u2:Add(u11:GetAttributeChangedSignal("Health"):Connect(update));
    u2:Add(u11:GetAttributeChangedSignal("MaxHealth"):Connect(update));
    local Attribute2 = u11:GetAttribute("Health");
    local Attribute3 = u11:GetAttribute("MaxHealth");

    if typeof(Attribute2) == "number" and (typeof(Attribute3) == "number" and Attribute3 > 0) then
        u1.updateFrame(math.max(Attribute2, 0), Attribute3);
    end;
end;

function u1.Initialize(p13, p14) -- Line: 111
    -- upvalues: u5 (ref), HudTarget (copy), u4 (ref), u1 (copy), DataController (copy), LocalPlayer (copy)
    u5 = p14;
    HudTarget.DisableInput(u5);

    local function refreshPreferenceColor() -- Line: 117
        -- upvalues: u4 (ref), u1 (ref)
        if u4 then
            local v15 = u4;
            local Attribute = v15:GetAttribute("Health");
            local Attribute2 = v15:GetAttribute("MaxHealth");

            if typeof(Attribute) == "number" and (typeof(Attribute2) == "number" and Attribute2 > 0) then
                u1.updateFrame(math.max(Attribute, 0), Attribute2);
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshPreferenceColor);
end;

function u1.Start() -- Line: 128
    -- upvalues: HudTarget (copy), trackPlayer (copy)
    HudTarget.Follow(trackPlayer);
end;

return u1;