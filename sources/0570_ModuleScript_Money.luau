-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local HudTarget = require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local u2 = Janitor.new();
local u3 = Spring.new(1, 8, 0);
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;

local function commaNumber(p8: number) -- Line: 60
    return tostring(p8):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function getTargetPlayer() -- Line: 64
    -- upvalues: LocalPlayer (copy), SpectateController (copy)
    if LocalPlayer:GetAttribute("IsSpectating") then
        local Player = SpectateController.GetPlayer();

        if Player and Player ~= LocalPlayer then
            return Player;
        end;
    end;

    return LocalPlayer;
end;

local function refreshPreferenceColor() -- Line: 74
    -- upvalues: GetPreferenceColor (copy), u6 (ref), u7 (ref)
    local v9 = GetPreferenceColor();

    if u6 == v9 then
        return;
    end;

    u6 = v9;

    if u7 then
        u7.Amount.TextColor3 = v9;
    end;
end;

function u1.CreatePlayerObserver(u10: userdata) -- Line: 89
    -- upvalues: u2 (copy), u4 (ref), u3 (copy), Observers (copy)
    u2:Cleanup();
    u4 = u10;
    local v11 = tonumber(u10:GetAttribute("Money"));

    if v11 then
        u3:setGoal(v11);
    end;

    local function noop() -- Line: 98
    end;

    u2:Add(Observers.observeAttribute(u10, "Money", function(p12) -- Line: 100
        -- upvalues: u4 (ref), u10 (copy), noop (copy), u3 (ref)
        if u4 ~= u10 then
            return noop;
        end;

        local v13 = tonumber(p12);

        if v13 then
            u3:setGoal(v13);
        end;

        return noop;
    end));
end;

local function refreshTrackedPlayer() -- Line: 113
    -- upvalues: LocalPlayer (copy), SpectateController (copy), u4 (ref), u1 (copy)
    local v14;

    if LocalPlayer:GetAttribute("IsSpectating") then
        v14 = SpectateController.GetPlayer();

        if not v14 or v14 == LocalPlayer then
            v14 = LocalPlayer;
        end;
    else
        v14 = LocalPlayer;
    end;

    if u4 == v14 then
        return;
    end;

    u1.CreatePlayerObserver(v14);
end;

function u1.Initialize(p15, p16) -- Line: 124
    -- upvalues: u7 (ref), HudTarget (copy), LocalPlayer (copy), refreshTrackedPlayer (copy), refreshPreferenceColor (copy), DataController (copy), GetPreferenceColor (copy), u6 (ref)
    u7 = p16;
    HudTarget.DisableInput(u7);
    LocalPlayer.CharacterAdded:Connect(refreshTrackedPlayer);
    LocalPlayer.CharacterRemoving:Connect(refreshTrackedPlayer);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(refreshPreferenceColor);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor);
    local v17 = GetPreferenceColor();

    if u6 == v17 then
        return;
    end;

    u6 = v17;

    if u7 then
        u7.Amount.TextColor3 = v17;
    end;
end;

function u1.Start() -- Line: 135
    -- upvalues: LocalPlayer (copy), refreshTrackedPlayer (copy), SpectateController (copy), u4 (ref), u1 (copy), RunServiceController (copy), u3 (copy), u5 (ref), u7 (ref), IsInBuyArea (copy), Router (copy)
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(refreshTrackedPlayer);
    SpectateController.ListenToSpectate:Connect(refreshTrackedPlayer);
    local v18;

    if LocalPlayer:GetAttribute("IsSpectating") then
        v18 = SpectateController.GetPlayer();

        if not v18 or v18 == LocalPlayer then
            v18 = LocalPlayer;
        end;
    else
        v18 = LocalPlayer;
    end;

    if u4 ~= v18 then
        u1.CreatePlayerObserver(v18);
    end;

    local u19 = nil;
    local u20 = (1 / 0);
    RunServiceController.BindToHeartbeat("UI.Money.Update", function(p21: number) -- Line: 143
        -- upvalues: u3 (ref), u19 (ref), u5 (ref), u7 (ref), LocalPlayer (ref), u20 (ref), IsInBuyArea (ref), Router (ref)
        local Position = u3:getPosition();
        local math_round_ret = math.round(Position);

        if math_round_ret ~= u19 then
            u19 = math_round_ret;
            local v22 = "$" .. tostring(math_round_ret):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");

            if v22 ~= u5 then
                u5 = v22;
                u7.Amount.Text = v22;
            end;
        end;

        u3:update(p21);

        if LocalPlayer:GetAttribute("BuyMenu") then
            u20 = u20 + p21;

            if u20 < 0.1 then
                return;
            end;

            u20 = 0;
            local Visible = u7.Buy.Visible;
            local v23 = IsInBuyArea(LocalPlayer);

            if Visible ~= v23 then
                u7.Buy.Visible = v23;
            end;

            if Visible and not v23 then
                Router.broadcastRouter("CreateNotification", "You have left the buy zone", "You have left the buy zone", 2);
            end;
        else
            u20 = (1 / 0);

            if u7.Buy.Visible then
                u7.Buy.Visible = false;
            end;
        end;
    end);
end;

return u1;