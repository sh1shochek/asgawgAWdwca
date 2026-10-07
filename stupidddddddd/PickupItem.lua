-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.PickupItem
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.PickupItem
-- Decompile time: 7.95 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips)
local HoverBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb)
local BuyMenuHint = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenuHint)
require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification.Types)
local u94 = UDim2.fromScale(0.9, 0.12)
local u98 = UDim2.fromScale(0.225, 0.054)
local u103 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u104 = nil
local u105 = nil
local u109 = Vector2.new(0.5, 0.5)
local u110 = false
local u111 = nil
local u112 = nil
local u113 = nil

local function computePriority(a1, a2) -- Line: 73 -- upvalues: LocalPlayer (val)
    local Character = LocalPlayer.Character
    if Character and Character.PrimaryPart then
        if a1:GetAttribute("HoveringState") == "Hovering" then
            return true
        end
        if a2:GetAttribute("HoveringState") == "Hovering" or a1:GetAttribute("CanPickup") == false then
            return false
        end
        if a2:GetAttribute("CanPickup") == false then
            return true
        end
        if a1.PrimaryPart and a2.PrimaryPart then
            return (Character.PrimaryPart.Position - a1.PrimaryPart.Position).Magnitude < (Character.PrimaryPart.Position - a2.PrimaryPart.Position).Magnitude
        end
        return false
    end
    return false
end

local function hasHoveredInteractables() -- Line: 99 -- upvalues: CollectionService (val)
    return #CollectionService:GetTagged("IsHoveringInteractable") > 0
end

local function createCard(a1) -- Line: 106 -- upvalues: ReplicatedStorage (val), u109 (ref) -- types: a1: userdata?
    local Notification = ReplicatedStorage.Assets.UI.Notification
    local Keybind = Notification:FindFirstChild("Keybind") or Notification:FindFirstChild("Default")
    if Keybind and Keybind:IsA("GuiObject") then
        local v1 = Keybind:Clone()
        v1.Name = "PickupItem"
        v1.LayoutOrder = -1
        v1.Visible = false
        u109 = v1.AnchorPoint
        if not v1:FindFirstChild("Keybind") and a1 and a1:IsA("ImageButton") then
            local v2 = a1:Clone()
            v2.Name = "Keybind"
            v2.AnchorPoint = Vector2.new(0, 0.5)
            v2.Size = UDim2.fromScale(0.66, 0.66)
            v2.SizeConstraint = Enum.SizeConstraint.RelativeYY
            v2.Parent = v1
        end
        local TextLabel = v1:FindFirstChild("TextLabel")
        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.RichText = true
            TextLabel.TextWrapped = false
        end
        return v1
    end
    warn("[PickupItem]: ReplicatedStorage.Assets.UI.Notification has no \"Keybind\" template")
    return nil
end

local function paintAccent() -- Line: 141 -- upvalues: u105 (ref), GetPreferenceColor (val)
    local v1 = u105
    if not v1 then
        return
    end
    local v2 = GetPreferenceColor()
    v1.Left.BackgroundColor3 = v2
    v1.Right.BackgroundColor3 = v2
end

local function refreshKeybind() -- Line: 152 -- upvalues: u105 (ref), Tips (val)
    local v1 = u105
    local Keybind = v1 and v1:FindFirstChild("Keybind")
    if Keybind and Keybind:IsA("ImageButton") then
        Keybind.Visible = Tips.ApplyBindingToKeybind(Keybind, Tips.ResolveActionBinding("Use"))
        return
    end
end

local function setCardShown(a1) -- Line: 164
    -- upvalues: u105 (ref), u110 (ref), GetPreferenceColor (val), TweenService (val), u103 (val)
    local v1 = u105
    if v1 and a1 ~= u110 then
        u110 = a1
        v1.Visible = a1
        if not a1 then
            return
        end
        local v2 = u105
        if v2 then
            local v3 = GetPreferenceColor()
            v2.Left.BackgroundColor3 = v3
            v2.Right.BackgroundColor3 = v3
        end
        if v1:IsA("CanvasGroup") then
            v1.GroupTransparency = 1
            TweenService:Create(v1, u103, {GroupTransparency = 0}):Play()
        end
        return
    end
end

local function placeCard(a1) -- Line: 184 -- upvalues: u104 (ref), BuyMenuHint (val), u98 (val), u109 (ref), u94 (val)
    local v1 = u104
    if not v1 then
        return
    end
    local v2 = BuyMenuHint.GetFloatingSlot()
    if v2 then
        a1.Parent = v1
        a1.AnchorPoint = Vector2.new(0.5, 1)
        a1.Position = v2
        a1.Size = u98
        return
    end
    local Notification = v1:FindFirstChild("Notification")
    if Notification then
        a1.Parent = Notification
        a1.AnchorPoint = u109
        a1.Size = u94
    end
end

local function layoutCard(a1) -- Line: 212
    local X = a1.AbsoluteSize.X
    if X <= 0 then
        return
    end
    local TextLabel = a1.TextLabel
    local Keybind = a1:FindFirstChild("Keybind")
    local Visible = false
    if Keybind ~= nil then
        Visible = Keybind:IsA("GuiObject") and Keybind.Visible
    end
    local v1 = if not Visible then 0 else Keybind.AbsoluteSize.X / X
    local v2 = if not Visible then 0 else 0.02
    local v3 = 0.88 - v1 - v2
    TextLabel.Size = UDim2.fromScale(v3, TextLabel.Size.Y.Scale)
    local v4 = math.min(TextLabel.TextBounds.X / X, v3)
    local v5 = 0.5 - (v1 + v2 + v4) / 2
    if Visible then
        Keybind.Position = UDim2.fromScale(v5 + v1 * Keybind.AnchorPoint.X, 0.5)
    end
    TextLabel.Position = UDim2.fromScale(v5 + v1 + v2 + v4 / 2, 0.5)
end

local function shouldRunUpdate() -- Line: 239
    -- upvalues: CharacterResolver (val), LocalPlayer (val), CollectionService (val)
    local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
    if v1 then
        v1 = false
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
        end
    end
    return v1
end

local function stopUpdateConnection() -- Line: 245 -- upvalues: u111 (ref)
    if u111 then
        u111:Disconnect()
        u111 = nil
    end
end

local function syncUpdateConnection() -- Line: 252
    -- upvalues: CharacterResolver (val), LocalPlayer (val), CollectionService (val), u111 (ref)
    -- upvalues: RunServiceController (val), u0 (val), u105 (ref), u110 (ref)
    local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
    if v1 then
        v1 = false
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
        end
    end
    if v1 then
        if u111 then
            return
        end
        u111 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(a1) -- Line: 258
            -- upvalues: CharacterResolver (upval), LocalPlayer (upval), CollectionService (upval), u0 (upval)
            -- upvalues: u105 (upval), u110 (upval), u111 (upval)
            local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
            if v1 then
                v1 = false
                if LocalPlayer:GetAttribute("IsSpectating") ~= true then
                    v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
                end
            end
            if v1 then
                u0.Render(a1)
                return
            end
            v1 = u105
            if v1 and u110 ~= false then
                u110 = false
                v1.Visible = false
            end
            if u111 then
                u111:Disconnect()
                u111 = nil
            end
        end)
        return
    end
    v1 = u105
    if v1 and u110 ~= false then
        u110 = false
        v1.Visible = false
    end
    if u111 then
        u111:Disconnect()
        u111 = nil
    end
end

local function trackCharacter(a1) -- Line: 275
    -- upvalues: u112 (ref), u113 (ref), syncUpdateConnection (val), CharacterResolver (val), LocalPlayer (val)
    -- upvalues: CollectionService (val), u111 (ref), RunServiceController (val), u0 (val), u105 (ref), u110 (ref)
    if u112 then
        u112:Disconnect()
        u112 = nil
    end
    if u113 then
        u113:Disconnect()
        u113 = nil
    end
    if a1 then
        u112 = (a1:GetAttributeChangedSignal("Dead")):Connect(syncUpdateConnection)
        u113 = a1.ChildAdded:Connect(function(a1) -- Line: 287
            -- upvalues: CharacterResolver (upval), LocalPlayer (upval), CollectionService (upval), u111 (upval)
            -- upvalues: RunServiceController (upval), u0 (upval), u105 (upval), u110 (upval)
            if a1:IsA("Humanoid") then
                local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
                if v1 then
                    v1 = false
                    if LocalPlayer:GetAttribute("IsSpectating") ~= true then
                        v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
                    end
                end
                if v1 then
                    if u111 then
                        return
                    end
                    u111 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(a1) -- Line: 258
                        -- upvalues: CharacterResolver (upval), LocalPlayer (upval), CollectionService (upval)
                        -- upvalues: u0 (upval), u105 (upval), u110 (upval), u111 (upval)
                        local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
                        if v1 then
                            v1 = false
                            if LocalPlayer:GetAttribute("IsSpectating") ~= true then
                                v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
                            end
                        end
                        if v1 then
                            u0.Render(a1)
                            return
                        end
                        v1 = u105
                        if v1 and u110 ~= false then
                            u110 = false
                            v1.Visible = false
                        end
                        if u111 then
                            u111:Disconnect()
                            u111 = nil
                        end
                    end)
                    return
                end
                v1 = u105
                if v1 and u110 ~= false then
                    u110 = false
                    v1.Visible = false
                end
                if u111 then
                    u111:Disconnect()
                    u111 = nil
                end
            end
        end)
    end
    local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
    if v1 then
        v1 = false
        if LocalPlayer:GetAttribute("IsSpectating") ~= true then
            v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
        end
    end
    if v1 then
        if u111 then
            return
        end
        u111 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(a1) -- Line: 258
            -- upvalues: CharacterResolver (upval), LocalPlayer (upval), CollectionService (upval), u0 (upval)
            -- upvalues: u105 (upval), u110 (upval), u111 (upval)
            local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
            if v1 then
                v1 = false
                if LocalPlayer:GetAttribute("IsSpectating") ~= true then
                    v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
                end
            end
            if v1 then
                u0.Render(a1)
                return
            end
            v1 = u105
            if v1 and u110 ~= false then
                u110 = false
                v1.Visible = false
            end
            if u111 then
                u111:Disconnect()
                u111 = nil
            end
        end)
        return
    end
    v1 = u105
    if v1 and u110 ~= false then
        u110 = false
        v1.Visible = false
    end
    if u111 then
        u111:Disconnect()
        u111 = nil
    end
end

function u0.Render(a1) -- Line: 300
    -- upvalues: u105 (ref), HoverBomb (val), u110 (ref), CollectionService (val), computePriority (val)
    -- upvalues: GetSkinDisplayName (val), Skins (val), Rarities (val), u104 (ref), BuyMenuHint (val), u98 (val)
    -- upvalues: u109 (ref), u94 (val), setCardShown (val), layoutCard (val)
    local v1 = u105
    if not v1 then
        return
    end
    if HoverBomb.GetHoverState() then
        local v2 = u105
        if v2 then
            if u110 == false then
                return
            end
            u110 = false
            v2.Visible = false
        end
        return
    end
    local Tagged = CollectionService:GetTagged("IsHoveringInteractable")
    table.sort(Tagged, computePriority)
    local v3 = Tagged[1]
    if not v3 then
        local v4 = u105
        if v4 then
            if u110 == false then
                return
            end
            u110 = false
            v4.Visible = false
        end
        return
    end
    local Attribute = v3:GetAttribute("Weapon")
    local Attribute_2 = v3:GetAttribute("Skin")
    local v5 = GetSkinDisplayName(Attribute_2)
    local Attribute_3 = v3:GetAttribute("NameTag")
    local v6 = GetSkinDisplayName.FormatNameLabelText(GetSkinDisplayName.GetWeaponDisplayName(Attribute, Attribute_3), Attribute_3)
    local v7 = Skins.GetSkinInformation(Attribute, Attribute_2)
    assert(v7, "Skin data not found for weapon: " .. Attribute .. " and skin: " .. Attribute_2)
    local v8 = Rarities[v7.rarity]
    local v9 = math.floor(v8.Color.R * 255)
    local v10 = math.floor(v8.Color.G * 255)
    local v11 = math.floor(v8.Color.B * 255)
    v1.TextLabel.Text = ("Swap for <font color = \"rgb(%*, %*, %*)\"><b>%* | %*</b></font>"):format(v9, v10, v11, v6, v5)
    local v12 = u104
    if v12 then
        local v13 = BuyMenuHint.GetFloatingSlot()
        if not v13 then
            local Notification = v12:FindFirstChild("Notification")
            if Notification then
                v1.Parent = Notification
                v1.AnchorPoint = u109
                v1.Size = u94
            end
        else
            v1.Parent = v12
            v1.AnchorPoint = Vector2.new(0.5, 1)
            v1.Position = v13
            v1.Size = u98
        end
    end
    setCardShown(true)
    layoutCard(v1)
end

function u0.Initialize(a1, a2) -- Line: 345
    -- upvalues: u104 (ref), u105 (ref), createCard (val), CollectionService (val), syncUpdateConnection (val)
    -- upvalues: LocalPlayer (val), trackCharacter (val), u112 (ref), u113 (ref), CharacterResolver (val), u111 (ref)
    -- upvalues: RunServiceController (val), u0 (val), u110 (ref), DataController (val), refreshKeybind (val)
    -- upvalues: UserInputService (val), Tips (val), paintAccent (val)
    u104 = a2.Parent
    a2.Visible = false
    u105 = createCard(a2:FindFirstChild("Keybind"))
    ;(CollectionService:GetInstanceAddedSignal("IsHoveringInteractable")):Connect(syncUpdateConnection)
    ;(CollectionService:GetInstanceRemovedSignal("IsHoveringInteractable")):Connect(syncUpdateConnection)
    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(syncUpdateConnection)
    LocalPlayer.CharacterAdded:Connect(trackCharacter)
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 355
        -- upvalues: u112 (upval), u113 (upval), CharacterResolver (upval), LocalPlayer (upval)
        -- upvalues: CollectionService (upval), u111 (upval), RunServiceController (upval), u0 (upval), u105 (upval)
        -- upvalues: u110 (upval)
        if u112 then
            u112:Disconnect()
            u112 = nil
        end
        if u113 then
            u113:Disconnect()
            u113 = nil
        end
        local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
        if v1 then
            v1 = false
            if LocalPlayer:GetAttribute("IsSpectating") ~= true then
                v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
            end
        end
        if v1 then
            if u111 then
                return
            end
            u111 = RunServiceController.BindToHeartbeat("UI.PickupItem.Update", function(a1) -- Line: 258
                -- upvalues: CharacterResolver (upval), LocalPlayer (upval), CollectionService (upval), u0 (upval)
                -- upvalues: u105 (upval), u110 (upval), u111 (upval)
                local v1 = CharacterResolver.isAliveCharacter(LocalPlayer.Character)
                if v1 then
                    v1 = false
                    if LocalPlayer:GetAttribute("IsSpectating") ~= true then
                        v1 = #CollectionService:GetTagged("IsHoveringInteractable") > 0
                    end
                end
                if v1 then
                    u0.Render(a1)
                    return
                end
                v1 = u105
                if v1 and u110 ~= false then
                    u110 = false
                    v1.Visible = false
                end
                if u111 then
                    u111:Disconnect()
                    u111 = nil
                end
            end)
            return
        end
        v1 = u105
        if v1 and u110 ~= false then
            u110 = false
            v1.Visible = false
        end
        if u111 then
            u111:Disconnect()
            u111 = nil
        end
    end)
    trackCharacter(LocalPlayer.Character)
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", refreshKeybind)
    ;(UserInputService:GetPropertyChangedSignal("PreferredInput")):Connect(refreshKeybind)
    local v1 = u105
    local Keybind = v1 and v1:FindFirstChild("Keybind")
    if Keybind and Keybind:IsA("ImageButton") then
        Keybind.Visible = Tips.ApplyBindingToKeybind(Keybind, Tips.ResolveActionBinding("Use"))
    end
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", paintAccent)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(paintAccent)
end

return u0