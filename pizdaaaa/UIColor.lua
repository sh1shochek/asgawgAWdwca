-- ReplicatedStorage.GameClient.Gui.MainMenu.Utils.UIColor
-- Script path: ReplicatedStorage.GameClient.Gui.MainMenu.Utils.UIColor
-- Decompile time: 7.00 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = {
    CT = Color3.fromRGB(184, 214, 239),
    T = Color3.fromRGB(234, 210, 139),
    Spectator = Color3.fromRGB(255, 255, 255)
};
local u6 = "Team Color";
local u7 = { 255, 255, 255 };
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local u8 = workspace;
local u9 = "";
local u10 = nil;

function u1.SetHudColor(p11) -- Line: 32
    -- upvalues: Color3_fromRGB_ret (ref), u2 (ref), u5 (copy), u9 (ref), u4 (ref), u10 (ref)
    if p11 then
        Color3_fromRGB_ret = p11;
    end;

    local HUD = u2.Handler.HUD;
    local Down = HUD.Down;
    local StoredAmmo = Down.Ammo.StoredAmmo;
    local Circle = Down.Circle;
    local Health = Down.Health;
    local Shield = Down.Shield;
    local Frame = Down.Spectating.ColorBackground.Main.Frame;
    local Radar = HUD.Radar;
    local Frame2 = HUD.Money.Frame;
    local Inventory = HUD.Inventory;
    local downNoti = HUD.Notifications.downNoti;
    local v12 = Color3_fromRGB_ret;
    Down.Ammo.AmmoLeftText.TextColor3 = v12;
    StoredAmmo.AmmoRightText.TextColor3 = v12;
    StoredAmmo.AmmoIcon.ImageColor3 = v12;
    StoredAmmo.AmmoLine.BackgroundColor3 = v12;
    Circle.LeftLine.BackgroundColor3 = v12;
    Circle.RightLine.BackgroundColor3 = v12;
    Circle.CircleStroke.Color = u5[u9];
    Circle.TeamIcon.ImageColor3 = u5[u9];
    Circle.CircleBlur.ImageColor3 = u5[u9];
    Health.HealthText.TextColor3 = v12;
    Health.HealthLine.HealthBar.BackgroundColor3 = v12;
    Shield.Armor.ImageColor3 = v12;
    Shield.ArmorHelmet.ImageColor3 = v12;
    Shield.ArmorText.TextColor3 = v12;
    Frame.Left.Color.BackgroundColor3 = v12;
    Frame.Right.Color.BackgroundColor3 = v12;
    Radar.UIStroke.Color = v12;
    Radar.Location.TextColor3 = v12;

    for _, descendant in Frame2:GetDescendants() do
        if descendant:IsA("TextLabel") then
            descendant.TextColor3 = v12;
        end;
    end;

    Inventory.Melee.Weapon.ImageColor3 = v12;
    Inventory.Secondary.Weapon.ImageColor3 = v12;
    Inventory.Primary.Weapon.ImageColor3 = v12;
    Inventory.Bomb.Weapon.ImageColor3 = v12;
    downNoti.Title.TextColor3 = v12;
    downNoti.ColorBackground.Main.Frame.Left.Color.BackgroundColor3 = v12;
    downNoti.ColorBackground.Main.Frame.Right.Color.BackgroundColor3 = v12;
    downNoti.DOTS.ImageColor3 = v12;
    u4.BurstColor(v12);
    u10.CardsColor(v12);
end;

function u1.ResetHudColor() -- Line: 120
    -- upvalues: u6 (ref), Color3_fromRGB_ret (ref), u5 (copy), u9 (ref), u7 (ref), u1 (copy)
    if u6 == "Team Color" then
        Color3_fromRGB_ret = u5[u9] or Color3.fromRGB(255, 255, 255);
    else
        Color3_fromRGB_ret = Color3.fromRGB(unpack(u7));
    end;

    u1.SetHudColor(Color3_fromRGB_ret);
end;

function u1.SetUser(p13: userdata) -- Line: 129
    -- upvalues: u9 (ref), u8 (ref), LocalPlayer (copy), u3 (ref), u6 (ref), u7 (ref), Color3_fromRGB_ret (ref), u5 (copy), u1 (copy)
    local Attribute = p13:GetAttribute("Team");

    if u9 == Attribute and u8 == p13 then
        return;
    end;

    u8 = p13;
    u9 = Attribute;
    local v14 = u8 == LocalPlayer and u3:GetPlayerSettings() or u3.GetSettingsFromPlayer(u8);

    if not v14 then
        warn("No Settings for", p13);

        return;
    end;

    local v15 = v14.Game["HUD & UI"];
    u6 = v15["HUD Color Style"];
    u7 = v15["HUD Color"];

    if u6 == "Team Color" then
        Color3_fromRGB_ret = u5[u9];
    else
        Color3_fromRGB_ret = Color3.fromRGB(unpack(u7));
    end;

    u1.SetHudColor();
end;

function u1.GetHudColor() -- Line: 160
    -- upvalues: Color3_fromRGB_ret (ref)
    return Color3_fromRGB_ret;
end;

local u16 = false;

function u1.Init(p17) -- Line: 165
    -- upvalues: u2 (ref), u3 (ref), u10 (ref), u4 (ref), u8 (ref), LocalPlayer (copy), u6 (ref), Color3_fromRGB_ret (ref), u5 (copy), u9 (ref), u7 (ref), u16 (ref), u1 (copy)
    u2 = p17:GetModule("Gui");
    u3 = u2.GetComponent("Settings");
    u10 = u2.GetComponent("Down");
    u4 = u2.GetComponent("Notification");
    u3:AddPlayerConnection("Game", "HUD & UI", "HUD Color Style", function(p18) -- Line: 172
        -- upvalues: u8 (ref), LocalPlayer (ref), u6 (ref), Color3_fromRGB_ret (ref), u5 (ref), u9 (ref), u7 (ref), u16 (ref), u1 (ref)
        if u8 ~= LocalPlayer then
            return;
        end;

        u6 = p18;

        if u6 == "Team Color" then
            Color3_fromRGB_ret = u5[u9];
        else
            Color3_fromRGB_ret = Color3.fromRGB(unpack(u7));
        end;

        if u16 then
            u1.SetHudColor(Color3_fromRGB_ret);
        end;
    end);
    u3:AddPlayerConnection("Game", "HUD & UI", "HUD Color", function(p19) -- Line: 190
        -- upvalues: u8 (ref), LocalPlayer (ref), u7 (ref), u6 (ref), Color3_fromRGB_ret (ref), u16 (ref), u1 (ref)
        if u8 ~= LocalPlayer then
            return;
        end;

        u7 = p19;

        if u6 == "Team Color" then
            return;
        end;

        Color3_fromRGB_ret = Color3.fromRGB(unpack(u7));

        if u16 then
            u1.SetHudColor(Color3_fromRGB_ret);
        end;
    end);
end;

function u1.Start2(p20) -- Line: 209
    -- upvalues: u16 (ref)
    u16 = true;
end;

return u1;