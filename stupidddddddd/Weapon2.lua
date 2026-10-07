-- ReplicatedStorage.Controllers.Observers.Game.WeaponDropped.Weapon
-- Script path: ReplicatedStorage.Controllers.Observers.Game.WeaponDropped.Weapon
-- Decompile time: 7.69 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local CenterScreenRaycast = require(ReplicatedStorage.Components.Common.CenterScreenRaycast)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Grenades = require(ReplicatedStorage.Database.Custom.GameStats.Grenades)
local LocalPlayer = Players.LocalPlayer
local u78 = {ProximityRange = 6, HoverRange = 10}
local u79 = {}
local u80 = 0
local u81 = nil
local u82 = nil
local u83 = {}

local function UpdateHoveredInstance() -- Line: 50 -- upvalues: u81 (ref), CenterScreenRaycast (val)
    u81 = CenterScreenRaycast.GetInstance(10)
end

local function StopSharedHeartbeatIfIdle() -- Line: 54 -- upvalues: u80 (ref), u82 (ref), u81 (ref)
    if u80 <= 0 and u82 then
        u82:Disconnect()
        u82 = nil
        u81 = nil
    end
end

local function EnsureSharedHeartbeat() -- Line: 62
    -- upvalues: u82 (ref), RunServiceController (val), u80 (ref), u81 (ref), CenterScreenRaycast (val), u78 (val)
    -- upvalues: u79 (val)
    if u82 then
        return
    end
    u82 = RunServiceController.BindToHeartbeat("Observers.Game.WeaponDropped.Update", function(a1) -- Line: 67
        -- upvalues: u80 (upval), u82 (upval), u81 (upval), CenterScreenRaycast (upval), u78 (upval), u79 (upval)
        if not (u80 <= 0) then
            u81 = CenterScreenRaycast.GetInstance(u78.HoverRange)
            for k in pairs(u79) do
                if k.Model.PrimaryPart then
                    k:updateState(a1)
                end
            end
            return
        end
        if u80 <= 0 and u82 then
            u82:Disconnect()
            u82 = nil
            u81 = nil
        end
    end)
end

local function ReserveAutoPickupSlot(a1) -- Line: 83 -- upvalues: u83 (val) -- types: a1: number
    local u2 = os.clock()
    local v1 = u83[a1]
    if v1 and u2 - v1 < 1 then
        return false
    end
    u83[a1] = u2
    task.delay(1, function() -- Line: 91 -- upvalues: u83 (upval), a1 (val), u2 (val)
        if u83[a1] == u2 then
            u83[a1] = nil
        end
    end)
    return true
end

local function HasReachedDuplicateLimit(a1, a2) -- Line: 116 -- upvalues: Grenades (val) -- types: a2: string
    local v1 = Grenades[a2]
    if not v1 then
        return false
    end
    local v2 = 0
    if a1 then
        for i, v in ipairs(a1._items) do
            if v.Name == a2 then
                v2 = v2 + 1
            end
        end
    end
    return v1 <= v2
end

function u0:autoPickup() -- Line: 136
    -- upvalues: GetWeaponProperties (val), NumberSlots (val), InventoryController (val), Grenades (val), u83 (val)
    -- upvalues: Skins (val), Rarities (val), LocalPlayer (val), Router (val), Remotes (val)
    local v1, v2
    local Attribute = self.Model:GetAttribute("Weapon")
    if not Attribute then
        return
    end
    local v3 = GetWeaponProperties(Attribute)
    if not v3 then
        return
    end
    local u11 = NumberSlots[v3.Slot]
    if not u11 then
        return
    end
    local v4 = InventoryController.getInventorySlot(u11)
    local v5 = Grenades[Attribute]
    if v5 then
        v2 = 0
        if v4 then
            for i, v in ipairs(v4._items) do
                if v.Name == Attribute then
                    v2 = v2 + 1
                end
            end
        end
        v1 = v5 <= v2
    else
        v1 = false
    end
    if v1 then
        return
    end
    if v4 and #v4._items < v4._settings._strict_slot_space and self.Model:GetAttribute("CanPickup") then
        if not self.SentPickupRequest then
            local u64 = os.clock()
            local v6 = u83[u11]
            if not v6 or not (u64 - v6 < 1) then
                u83[u11] = u64
                task.delay(1, function() -- Line: 91 -- upvalues: u83 (upval), u11 (val), u64 (val)
                    if u83[u11] == u64 then
                        u83[u11] = nil
                    end
                end)
                v5 = true
            else
                v5 = false
            end
            if v5 then
                self.SentPickupRequest = true
                task.delay(1, function() -- Line: 163 -- upvalues: self (val)
                    self.SentPickupRequest = false
                end)
                v5 = Skins.GetSkinInformation(self.Weapon, self.Skin)
                assert(v5, "Skin data not found for weapon: " .. self.Weapon .. " and skin: " .. self.Skin)
                v2 = Rarities[v5.rarity]
                v6 = math.floor(v2.Color.R * 255)
                local v7 = math.floor(v2.Color.G * 255)
                local v8 = math.floor(v2.Color.B * 255)
                if self.Weapon == "C4" and LocalPlayer:GetAttribute("Team") ~= "Terrorists" then
                    return
                end
                Router.broadcastRouter("CreateNotification", "Item Picked Up", ("You picked up a <font color = \"rgb(%*, %*, %*)\"><b>%* | %*</b></font>"):format(
                    v6,
                    v7,
                    v8,
                    if not self.Weapon:find("Zeus") then self.Weapon else "Taser",
                    self.Skin
                ), 2)
                Remotes.Inventory.PickupWeapon.Send({AllowAutoEquip = false, Identity = self.Model.Name})
                return
            end
        end
        return
    end
end

function u0:updateState(a2) -- Line: 190
    -- upvalues: u81 (ref), CharacterResolver (val), LocalPlayer (val), DataController (val), GetWeaponProperties (val)
    self.AlphaTime = self.AlphaTime + a2
    local v1 = u81
    local v2 = false
    if v1 ~= nil then
        v2 = v1:IsDescendantOf(self.Model)
    end
    local v3 = v2 and "Hovering"
    local v4 = CharacterResolver.getLocalCharacter()
    local PrimaryPart = v4 and v4.PrimaryPart
    if PrimaryPart and (PrimaryPart.Position - self.Model.PrimaryPart.Position).Magnitude <= 6 then
        v3 = v3 or "Proximity"
    end
    if self.Weapon == "C4" then
        local Attribute = LocalPlayer:GetAttribute("Team")
        if 1 <= self.AlphaTime then
            local FlashingLight = self.Model.Weapon:FindFirstChild("FlashingLight")
            self.AlphaTime = 0
            if FlashingLight then
                FlashingLight.Attachment.PointLight.Enabled = not FlashingLight.Attachment.PointLight.Enabled
                FlashingLight.Attachment.PointLight.Color = Color3.fromRGB(255, 255, 15)
                FlashingLight.Attachment.PointLight.Brightness = 5
            end
        end
        if Attribute ~= "Terrorists" then
            v3 = false
        end
    end
    local v5 = if v3 == "Hovering" then v3 or nil else not (v3 ~= "Proximity") and v3 or nil
    if self.LastHoveringState ~= v5 then
        self.LastHoveringState = v5
        self.Model:SetAttribute("HoveringState", v5)
    end
    local v6 = v5 ~= nil
    if self.IsInteractableTagged ~= v6 then
        self.IsInteractableTagged = v6
        if not v6 then
            self.Model:RemoveTag("IsHoveringInteractable")
        else
            self.Model:AddTag("IsHoveringInteractable")
        end
    end
    if v5 == "Proximity" then
        local v7 = DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Pickup Dropped Weapons")
        local v8 = GetWeaponProperties(self.Weapon)
        local Slot = v8 and v8.Slot
        local v9 = true
        if Slot ~= "Grenade" then
            v9 = Slot == "C4"
        end
        if v7 ~= false or v9 then
            self:autoPickup()
        end
    end
end

function u0.new(a1) -- Line: 255
    -- upvalues: u0 (val), u79 (val), u80 (ref), u82 (ref), RunServiceController (val), u81 (ref)
    -- upvalues: CenterScreenRaycast (val), u78 (val)
    local v1 = setmetatable({}, u0)
    v1.Model = a1
    v1.AlphaTime = 0
    v1.Weapon = v1.Model:GetAttribute("Weapon")
    v1.Skin = v1.Model:GetAttribute("Skin")
    v1.SentPickupRequest = false
    v1.IsInteractableTagged = false
    u79[v1] = true
    u80 = u80 + 1
    if u82 then
        return v1
    end
    u82 = RunServiceController.BindToHeartbeat("Observers.Game.WeaponDropped.Update", function(a1) -- Line: 67
        -- upvalues: u80 (upval), u82 (upval), u81 (upval), CenterScreenRaycast (upval), u78 (upval), u79 (upval)
        if not (u80 <= 0) then
            u81 = CenterScreenRaycast.GetInstance(u78.HoverRange)
            for k in pairs(u79) do
                if k.Model.PrimaryPart then
                    k:updateState(a1)
                end
            end
            return
        end
        if u80 <= 0 and u82 then
            u82:Disconnect()
            u82 = nil
            u81 = nil
        end
    end)
    return v1
end

function u0.destroy(a1) -- Line: 273 -- upvalues: u79 (val), u80 (ref), u82 (ref), u81 (ref)
    if u79[a1] then
        u79[a1] = nil
        u80 = u80 - 1
        if u80 <= 0 and u82 then
            u82:Disconnect()
            u82 = nil
            u81 = nil
        end
    end
    if a1.IsInteractableTagged then
        a1.Model:RemoveTag("IsHoveringInteractable")
        a1.IsInteractableTagged = false
    end
    if a1.LastHoveringState ~= nil then
        a1.Model:SetAttribute("HoveringState", nil)
        a1.LastHoveringState = nil
    end
end

return u0