-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local HudTarget = require(script:WaitForChild("HudTarget"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = Janitor.new();

local function shouldShowAmmoFrame(p8) -- Line: 47
    local v9;

    if p8 == nil or p8.Class ~= "Weapon" then
        v9 = false;
    else
        v9 = p8.MuzzleType ~= "Zeus x27";
    end;

    return v9;
end;

function u1.tweenAnimation(p10) -- Line: 53
    -- upvalues: u2 (ref), u5 (ref), u3 (ref)
    if u2 == p10.Identifier then
        return;
    end;

    u2 = p10.Identifier;
    u5.Size = UDim2.new(u5.Size.X.Scale, -25, u5.Size.Y.Scale, -25);

    if u3 then
        u3:Play();
    end;
end;

function u1.updateFrame(p11) -- Line: 65
    -- upvalues: u5 (ref), u1 (copy), GetPreferenceColor (copy), u3 (ref), u6 (ref)
    local Properties = p11.Properties;
    local v12;

    if Properties == nil or Properties.Class ~= "Weapon" then
        v12 = false;
    else
        v12 = Properties.MuzzleType ~= "Zeus x27";
    end;

    u5.Visible = v12;

    if u5.Visible then
        u1.tweenAnimation(p11);
        local Rounds = p11.Rounds;
        u5.Capacity.Amount.Text = tostring(p11.Capacity);
        u5.Rounds.Amount.Text = tostring(Rounds);
        local v13 = GetPreferenceColor();
        u5.Capacity.Amount.TextColor3 = v13;
        u5.Rounds.Amount.TextColor3 = v13;
        u5.Divider.BackgroundColor3 = v13;
        u5.SemiAuto.ImageColor3 = v13;
        u5.Auto.ImageColor3 = v13;
        local v14 = Rounds / Properties.Rounds;
        u5.Rounds.Glow.ImageTransparency = 1;

        if v14 <= 0.2 then
            u5.Rounds.Glow.ImageTransparency = math.max(v14, 0.3);
        end;

        if Properties.ShootingOptions == "Default" then
            u5.SemiAuto.Visible = not Properties.Automatic;
            u5.Auto.Visible = Properties.Automatic;
        elseif Properties.ShootingOptions == "Burst" then
            u5.SemiAuto.Visible = p11.AlternativeShootingOption == "Default";
            u5.Auto.Visible = p11.AlternativeShootingOption == "Burst";
        elseif Properties.ShootingOptions == "Revolver" then
            u5.SemiAuto.Visible = false;
            u5.Auto.Visible = false;
        end;
    elseif u3 then
        u3:Cancel();
    end;

    u5.Visible = u5.Visible and not u6.Gameplay.Middle.BuyMenu.Visible;
end;

local function showSpectatedEquipped(p15) -- Line: 105
    -- upvalues: HttpService (copy), u5 (ref), GetWeaponProperties (copy), u1 (copy)
    local v16;

    if p15 then
        v16 = HttpService:JSONDecode(p15);
    else
        v16 = nil;
    end;

    if not (v16 and v16.Name) then
        u5.Visible = false;

        return;
    end;

    local v17 = {
        AlternativeShootingOption = "Default",
        Properties = GetWeaponProperties(v16.Name),
        Identifier = v16.Identifier or "",
        Rounds = v16.Rounds or 0,
        Capacity = v16.Capacity or 0
    };
    local Properties = v17.Properties;
    local v18;

    if Properties == nil or Properties.Class ~= "Weapon" then
        v18 = false;
    else
        v18 = Properties.MuzzleType ~= "Zeus x27";
    end;

    if v18 then
        u1.updateFrame(v17);

        return;
    end;

    u5.Visible = false;
end;

local function trackPlayerState(u19: userdata) -- Line: 128
    -- upvalues: u7 (copy), u4 (ref), LocalPlayer (copy), RunServiceController (copy), InventoryController (copy), u6 (ref), u1 (copy), showSpectatedEquipped (copy)
    u7:Cleanup();
    u4 = u19;

    if u19 ~= LocalPlayer then
        u7:Add(u19:GetAttributeChangedSignal("CurrentEquipped"):Connect(function() -- Line: 163
            -- upvalues: showSpectatedEquipped (ref), u19 (copy)
            showSpectatedEquipped(u19:GetAttribute("CurrentEquipped"));
        end));
        showSpectatedEquipped(u19:GetAttribute("CurrentEquipped"));

        return;
    end;

    local u20 = nil;
    local u21 = nil;
    local u22 = nil;
    local u23 = nil;
    local u24 = nil;
    u7:Add(RunServiceController.BindToStepped("UI.Ammo.LocalPlayerUpdate", function() -- Line: 139
        -- upvalues: InventoryController (ref), u6 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u1 (ref)
        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if not CurrentEquipped then
            return;
        end;

        local Visible = u6.Gameplay.Middle.BuyMenu.Visible;

        if CurrentEquipped.Identifier == u20 and (CurrentEquipped.Rounds == u21 and (CurrentEquipped.Capacity == u22 and (CurrentEquipped.AlternativeShootingOption == u23 and Visible == u24))) then
            return;
        end;

        u20 = CurrentEquipped.Identifier;
        u21 = CurrentEquipped.Rounds;
        u22 = CurrentEquipped.Capacity;
        u23 = CurrentEquipped.AlternativeShootingOption;
        u24 = Visible;
        u1.updateFrame(CurrentEquipped);
    end));
end;

function u1.Initialize(p25, p26) -- Line: 170
    -- upvalues: u6 (ref), u5 (ref), u3 (ref), TweenService (copy), LocalPlayer (copy), u4 (ref), u7 (copy), Observers (copy), InventoryController (copy), u1 (copy), DataController (copy)
    u6 = p25;
    u5 = p26;
    u5.Active = false;
    u5.AutoLocalize = false;

    for _, descendant in ipairs(u5:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.Active = false;
            descendant.AutoLocalize = false;
        end;
    end;

    u3 = TweenService:Create(u5, TweenInfo.new(0.25), {
        Size = UDim2.fromScale(u5.Size.X.Scale, u5.Size.Y.Scale)
    });
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 188
        -- upvalues: u4 (ref), LocalPlayer (ref), u7 (ref)
        if u4 == LocalPlayer then
            u7:Cleanup();
        end;
    end);
    Observers.observeProperty(u5.Rounds.Amount, "Text", function() -- Line: 195
        -- upvalues: TweenService (ref), u5 (ref)
        local v27 = TweenService:Create(u5.Rounds.Amount.UIScale, TweenInfo.new(0.05), {
            Scale = 1.2
        });
        v27:Play();
        v27.Completed:Once(function() -- Line: 198
            -- upvalues: TweenService (ref), u5 (ref)
            TweenService:Create(u5.Rounds.Amount.UIScale, TweenInfo.new(0.05, Enum.EasingStyle.Elastic), {
                Scale = 1
            }):Play();
        end);
    end);

    local function refreshPreferenceColor() -- Line: 207
        -- upvalues: InventoryController (ref), u1 (ref)
        local CurrentEquipped = InventoryController.getCurrentEquipped();

        if CurrentEquipped then
            u1.updateFrame(CurrentEquipped);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshPreferenceColor);
end;

function u1.Start() -- Line: 219
    -- upvalues: HudTarget (copy), trackPlayerState (copy)
    HudTarget.Follow(trackPlayerState);
end;

return u1;