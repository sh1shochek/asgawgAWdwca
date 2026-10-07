-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Money
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Money
-- Decompile time: 2.37 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local HudTarget = require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Spring = require(ReplicatedStorage.Shared.Spring)
local u61 = Janitor.new()
local u66 = Spring.new(1, 8, 0)
local u67 = nil
local u68 = nil
local u69 = nil
local u70 = nil

local function commaNumber(a1) -- Line: 60 -- types: a1: number
    return tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function getTargetPlayer() -- Line: 64 -- upvalues: LocalPlayer (val), SpectateController (val)
    if LocalPlayer:GetAttribute("IsSpectating") then
        local v1 = SpectateController.GetPlayer()
        if v1 and v1 ~= LocalPlayer then
            return v1
        end
    end
    return LocalPlayer
end

local function refreshPreferenceColor() -- Line: 74 -- upvalues: GetPreferenceColor (val), u69 (ref), u70 (ref)
    local v1 = GetPreferenceColor()
    if u69 == v1 then
        return
    end
    u69 = v1
    if u70 then
        u70.Amount.TextColor3 = v1
    end
end

function u0.CreatePlayerObserver(a1) -- Line: 89
    -- upvalues: u61 (val), u67 (ref), u66 (val), Observers (val)
    u61:Cleanup()
    u67 = a1
    local v1 = tonumber((a1:GetAttribute("Money")))
    if v1 then
        u66:setGoal(v1)
    end

    local function noop() end

    u61:Add((Observers.observeAttribute(a1, "Money", function(a1_2) -- Line: 100 -- upvalues: u67 (upval), a1 (val), noop (val), u66 (upval)
        if u67 ~= a1 then
            return noop
        end
        local v1 = tonumber(a1_2)
        if v1 then
            u66:setGoal(v1)
        end
        return noop
    end)))
end

local function refreshTrackedPlayer() -- Line: 113
    -- upvalues: LocalPlayer (val), SpectateController (val), u67 (ref), u0 (val)
    local v1
    if not LocalPlayer:GetAttribute("IsSpectating") then
        v1 = LocalPlayer
    else
        local v2 = SpectateController.GetPlayer()
        v1 = if not v2 then LocalPlayer else if v2 == LocalPlayer then LocalPlayer else v2
    end
    if u67 == v1 then
        return
    end
    u0.CreatePlayerObserver(v1)
end

function u0.Initialize(a1, a2) -- Line: 124
    -- upvalues: u70 (ref), HudTarget (val), LocalPlayer (val), refreshTrackedPlayer (val), refreshPreferenceColor (val)
    -- upvalues: DataController (val), GetPreferenceColor (val), u69 (ref)
    u70 = a2
    HudTarget.DisableInput(u70)
    LocalPlayer.CharacterAdded:Connect(refreshTrackedPlayer)
    LocalPlayer.CharacterRemoving:Connect(refreshTrackedPlayer)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(refreshPreferenceColor)
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor)
    local v1 = GetPreferenceColor()
    if u69 == v1 then
        return
    end
    u69 = v1
    if u70 then
        u70.Amount.TextColor3 = v1
    end
end

function u0.Start() -- Line: 135
    -- upvalues: LocalPlayer (val), refreshTrackedPlayer (val), SpectateController (val), u67 (ref), u0 (val)
    -- upvalues: RunServiceController (val), u66 (val), u68 (ref), u70 (ref), IsInBuyArea (val), Router (val)
    local v1
    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(refreshTrackedPlayer)
    SpectateController.ListenToSpectate:Connect(refreshTrackedPlayer)
    if not LocalPlayer:GetAttribute("IsSpectating") then
        v1 = LocalPlayer
    else
        local v2 = SpectateController.GetPlayer()
        v1 = if not v2 then LocalPlayer else if v2 == LocalPlayer then LocalPlayer else v2
    end
    if u67 ~= v1 then
        u0.CreatePlayerObserver(v1)
    end
    local u32 = nil
    local u33 = (1 / 0)
    RunServiceController.BindToHeartbeat("UI.Money.Update", function(a1) -- Line: 143
        -- upvalues: u66 (upval), u32 (ref), u68 (upval), u70 (upval), LocalPlayer (upval), u33 (ref)
        -- upvalues: IsInBuyArea (upval), Router (upval)
        local v1 = math.round((u66:getPosition()))
        if v1 ~= u32 then
            u32 = v1
            local v2 = "$" .. tostring(v1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
            if v2 ~= u68 then
                u68 = v2
                u70.Amount.Text = v2
            end
        end
        u66:update(a1)
        if not LocalPlayer:GetAttribute("BuyMenu") then
            u33 = (1 / 0)
            if u70.Buy.Visible then
                u70.Buy.Visible = false
            end
            return
        end
        u33 = u33 + a1
        if u33 < 0.1 then
            return
        end
        u33 = 0
        local Visible = u70.Buy.Visible
        local v3 = IsInBuyArea(LocalPlayer)
        if Visible ~= v3 then
            u70.Buy.Visible = v3
        end
        if Visible and not v3 then
            Router.broadcastRouter("CreateNotification", "You have left the buy zone", "You have left the buy zone", 2)
            return
        end
    end)
end

return u0