-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Armor
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Armor
-- Decompile time: 1.59 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local HudTarget = require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget)
local LocalPlayer = Players.LocalPlayer
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local u47 = nil
local u49 = Janitor.new()

local function ParseArmorAttribute(a1) -- Line: 39 -- upvalues: HttpService (val)
    if typeof(a1) == "string" and a1 ~= "" then
        local success, result = pcall(function() -- Line: 44 -- upvalues: HttpService (upval), a1 (val)
            return HttpService:JSONDecode(a1)
        end)
        if success and typeof(result) == "table" then
            return {
                Type = tostring(result.Type or ""),
                Health = tonumber(result.Health) or 0,
            }
        end
        return nil
    end
    return nil
end

local function UpdateArmorUIFromAttribute(a1) -- Line: 57 -- upvalues: ParseArmorAttribute (val), u47 (ref), u0 (val)
    local v1 = ParseArmorAttribute(a1)
    local v2 = false
    if v1 ~= nil then
        v2 = 0 < v1.Health
    end
    u47.Visible = v2
    if v2 and v1 then
        u0.updateFrame(v1)
    end
end

function u0.updateFrame(a1) -- Line: 67 -- upvalues: GetPreferenceColor (val), u47 (ref)
    local v1 = GetPreferenceColor()
    u47.Helmet.Visible = a1.Type == "Kevlar + Helmet"
    u47.Amount.Text = tostring((math.round(a1.Health)))
    u47.Helmet.ImageColor3 = v1
    u47.Amount.TextColor3 = v1
    u47.Armor.ImageColor3 = v1
end

local function updateArmorFromPlayer(a1) -- Line: 79
    -- upvalues: u49 (val), Observers (val), UpdateArmorUIFromAttribute (val), ParseArmorAttribute (val), u47 (ref)
    -- upvalues: u0 (val)
    u49:Cleanup()
    u49:Add((Observers.observeAttribute(a1, "Armor", UpdateArmorUIFromAttribute)))
    local v1 = ParseArmorAttribute((a1:GetAttribute("Armor")))
    local v2 = false
    if v1 ~= nil then
        v2 = 0 < v1.Health
    end
    u47.Visible = v2
    if v2 and v1 then
        u0.updateFrame(v1)
    end
end

function u0.Initialize(a1, a2) -- Line: 86
    -- upvalues: u47 (ref), HudTarget (val), LocalPlayer (val), ParseArmorAttribute (val), u0 (val)
    -- upvalues: DataController (val)
    HudTarget.DisableInput(a2)

    local function refreshPreferenceColor() -- Line: 92
        -- upvalues: LocalPlayer (upval), ParseArmorAttribute (upval), u0 (upval)
        local Attribute = LocalPlayer:GetAttribute("Armor")
        local v1 = ParseArmorAttribute(Attribute)
        if v1 and 0 < v1.Health then
            u0.updateFrame(v1)
        end
    end

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(refreshPreferenceColor)
end

function u0.Start() -- Line: 105 -- upvalues: HudTarget (val), updateArmorFromPlayer (val)
    HudTarget.Follow(updateArmorFromPlayer)
end

return u0