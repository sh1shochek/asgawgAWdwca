-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local HudTarget = require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget);
local LocalPlayer = Players.LocalPlayer;
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = nil;
local u3 = Janitor.new();

local function ParseArmorAttribute(u4) -- Line: 39
    -- upvalues: HttpService (copy)
    if typeof(u4) ~= "string" or u4 == "" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 44
        -- upvalues: HttpService (ref), u4 (copy)
        return HttpService:JSONDecode(u4);
    end);

    return success and typeof(result) == "table" and {
        Type = tostring(result.Type or ""),
        Health = tonumber(result.Health) or 0
    } or nil;
end;

local function UpdateArmorUIFromAttribute(p5) -- Line: 57
    -- upvalues: ParseArmorAttribute (copy), u2 (ref), u1 (copy)
    local v6 = ParseArmorAttribute(p5);
    local v7;

    if v6 == nil then
        v7 = false;
    else
        v7 = v6.Health > 0;
    end;

    u2.Visible = v7;

    if v7 and v6 then
        u1.updateFrame(v6);
    end;
end;

function u1.updateFrame(p8) -- Line: 67
    -- upvalues: GetPreferenceColor (copy), u2 (ref)
    local v9 = GetPreferenceColor();
    u2.Helmet.Visible = p8.Type == "Kevlar + Helmet";
    local Amount = u2.Amount;
    local math_round_ret = math.round(p8.Health);
    Amount.Text = tostring(math_round_ret);
    u2.Helmet.ImageColor3 = v9;
    u2.Amount.TextColor3 = v9;
    u2.Armor.ImageColor3 = v9;
end;

local function updateArmorFromPlayer(p10: userdata) -- Line: 79
    -- upvalues: u3 (copy), Observers (copy), UpdateArmorUIFromAttribute (copy), ParseArmorAttribute (copy), u2 (ref), u1 (copy)
    u3:Cleanup();
    u3:Add(Observers.observeAttribute(p10, "Armor", UpdateArmorUIFromAttribute));
    local v11 = ParseArmorAttribute((p10:GetAttribute("Armor")));
    local v12;

    if v11 == nil then
        v12 = false;
    else
        v12 = v11.Health > 0;
    end;

    u2.Visible = v12;

    if v12 and v11 then
        u1.updateFrame(v11);
    end;
end;

function u1.Initialize(p13, p14) -- Line: 86
    -- upvalues: u2 (ref), HudTarget (copy), LocalPlayer (copy), ParseArmorAttribute (copy), u1 (copy), DataController (copy)
    u2 = p14;
    HudTarget.DisableInput(u2);

    local function refreshPreferenceColor() -- Line: 92
        -- upvalues: LocalPlayer (ref), ParseArmorAttribute (ref), u1 (ref)
        local v15 = ParseArmorAttribute((LocalPlayer:GetAttribute("Armor")));

        if v15 and v15.Health > 0 then
            u1.updateFrame(v15);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshPreferenceColor);
end;

function u1.Start() -- Line: 105
    -- upvalues: HudTarget (copy), updateArmorFromPlayer (copy)
    HudTarget.Follow(updateArmorFromPlayer);
end;

return u1;