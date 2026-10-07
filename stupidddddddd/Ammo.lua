-- ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo
-- Decompile time: 5.51 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local HudTarget = require(script:WaitForChild("HudTarget"))
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local u66 = nil
local u67 = nil
local u68 = nil
local u69 = nil
local u70 = nil
local u72 = Janitor.new()

local function shouldShowAmmoFrame(a1) -- Line: 47
    local v1 = false
    if a1 ~= nil then
        v1 = false
        if a1.Class == "Weapon" then
            v1 = a1.MuzzleType ~= "Zeus x27"
        end
    end
    return v1
end

function u0.tweenAnimation(a1) -- Line: 53 -- upvalues: u66 (ref), u69 (ref), u67 (ref)
    if u66 == a1.Identifier then
        return
    end
    u66 = a1.Identifier
    u69.Size = UDim2.new(u69.Size.X.Scale, -25, u69.Size.Y.Scale, -25)
    if u67 then
        u67:Play()
    end
end

function u0.updateFrame(a1) -- Line: 65 -- upvalues: u69 (ref), u0 (val), GetPreferenceColor (val), u67 (ref), u70 (ref)
    local Properties = a1.Properties
    local v1 = u69
    local v2 = false
    if Properties ~= nil then
        v2 = false
        if Properties.Class == "Weapon" then
            v2 = Properties.MuzzleType ~= "Zeus x27"
        end
    end
    v1.Visible = v2
    if u69.Visible then
        u0.tweenAnimation(a1)
        local Rounds = a1.Rounds
        local Capacity = a1.Capacity
        u69.Capacity.Amount.Text = tostring(Capacity)
        u69.Rounds.Amount.Text = tostring(Rounds)
        local v3 = GetPreferenceColor()
        u69.Capacity.Amount.TextColor3 = v3
        u69.Rounds.Amount.TextColor3 = v3
        u69.Divider.BackgroundColor3 = v3
        u69.SemiAuto.ImageColor3 = v3
        u69.Auto.ImageColor3 = v3
        local v4 = Rounds / Properties.Rounds
        u69.Rounds.Glow.ImageTransparency = 1
        if v4 <= 0.2 then
            u69.Rounds.Glow.ImageTransparency = math.max(v4, 0.3)
        end
        if Properties.ShootingOptions == "Default" then
            u69.SemiAuto.Visible = not Properties.Automatic
            u69.Auto.Visible = Properties.Automatic
        elseif Properties.ShootingOptions == "Burst" then
            u69.SemiAuto.Visible = a1.AlternativeShootingOption == "Default"
            u69.Auto.Visible = a1.AlternativeShootingOption == "Burst"
        elseif Properties.ShootingOptions == "Revolver" then
            u69.SemiAuto.Visible = false
            u69.Auto.Visible = false
        end
    elseif u67 then
        u67:Cancel()
    end
    v1 = u69
    local Visible = u69.Visible and not u70.Gameplay.Middle.BuyMenu.Visible
    v1.Visible = Visible
end

local function showSpectatedEquipped(a1) -- Line: 105
    -- upvalues: HttpService (val), u69 (ref), GetWeaponProperties (val), u0 (val)
    local v1 = if not a1 then nil else HttpService:JSONDecode(a1)
    if v1 and v1.Name then
        local v2 = {
            AlternativeShootingOption = "Default",
            Properties = GetWeaponProperties(v1.Name),
            Identifier = v1.Identifier or "",
            Rounds = v1.Rounds or 0,
            Capacity = v1.Capacity or 0,
        }
        local Properties = v2.Properties
        local v3 = false
        if Properties ~= nil then
            v3 = false
            if Properties.Class == "Weapon" then
                v3 = Properties.MuzzleType ~= "Zeus x27"
            end
        end
        if v3 then
            u0.updateFrame(v2)
            return
        end
        u69.Visible = false
        return
    end
    u69.Visible = false
end

local function trackPlayerState(a1) -- Line: 128
    -- upvalues: u72 (val), u68 (ref), LocalPlayer (val), RunServiceController (val), InventoryController (val)
    -- upvalues: u70 (ref), u0 (val), showSpectatedEquipped (val)
    u72:Cleanup()
    u68 = a1
    if a1 ~= LocalPlayer then
        u72:Add(((a1:GetAttributeChangedSignal("CurrentEquipped")):Connect(function() -- Line: 163 -- upvalues: showSpectatedEquipped (upval), a1 (val)
            showSpectatedEquipped(a1:GetAttribute("CurrentEquipped"))
        end)))
        showSpectatedEquipped(a1:GetAttribute("CurrentEquipped"))
        return
    end
    local u6 = nil
    local u7 = nil
    local u8 = nil
    local u9 = nil
    local u10 = nil
    u72:Add((RunServiceController.BindToStepped("UI.Ammo.LocalPlayerUpdate", function() -- Line: 139
        -- upvalues: InventoryController (upval), u70 (upval), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref)
        -- upvalues: u0 (upval)
        local v1 = InventoryController.getCurrentEquipped()
        if not v1 then
            return
        end
        local Visible = u70.Gameplay.Middle.BuyMenu.Visible
        if v1.Identifier == u6
            and v1.Rounds == u7
            and v1.Capacity == u8
            and v1.AlternativeShootingOption == u9
            and Visible == u10 then
            return
        end
        u6 = v1.Identifier
        u7 = v1.Rounds
        u8 = v1.Capacity
        u9 = v1.AlternativeShootingOption
        u10 = Visible
        u0.updateFrame(v1)
    end)))
end

function u0.Initialize(a1, a2) -- Line: 170
    -- upvalues: u70 (ref), u69 (ref), u67 (ref), TweenService (val), LocalPlayer (val), u68 (ref), u72 (val)
    -- upvalues: Observers (val), InventoryController (val), u0 (val), DataController (val)
    u70 = a1
    u69 = a2
    u69.Active = false
    u69.AutoLocalize = false
    for i, v in ipairs(u69:GetDescendants()) do
        if v:IsA("GuiObject") then
            v.Active = false
            v.AutoLocalize = false
        end
    end
    u67 = TweenService:Create(u69, TweenInfo.new(0.25), {
        Size = UDim2.fromScale(u69.Size.X.Scale, u69.Size.Y.Scale),
    })
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 188 -- upvalues: u68 (upval), LocalPlayer (upval), u72 (upval)
        if u68 == LocalPlayer then
            u72:Cleanup()
        end
    end)
    Observers.observeProperty(u69.Rounds.Amount, "Text", function() -- Line: 195 -- upvalues: TweenService (upval), u69 (upval)
        local v1 = TweenService:Create(u69.Rounds.Amount.UIScale, TweenInfo.new(0.05), {Scale = 1.2})
        v1:Play()
        v1.Completed:Once(function() -- Line: 198 -- upvalues: TweenService (upval), u69 (upval)
            TweenService:Create(u69.Rounds.Amount.UIScale, TweenInfo.new(0.05, Enum.EasingStyle.Elastic), {Scale = 1}):Play()
        end)
    end)

    local function refreshPreferenceColor() -- Line: 207 -- upvalues: InventoryController (upval), u0 (upval)
        local v1 = InventoryController.getCurrentEquipped()
        if v1 then
            u0.updateFrame(v1)
        end
    end

    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", refreshPreferenceColor)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(refreshPreferenceColor)
end

function u0.Start() -- Line: 219 -- upvalues: HudTarget (val), trackPlayerState (val)
    HudTarget.Follow(trackPlayerState)
end

return u0