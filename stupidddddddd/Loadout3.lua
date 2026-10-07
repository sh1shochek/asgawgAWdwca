-- ReplicatedStorage.Classes.Loadout
-- Script path: ReplicatedStorage.Classes.Loadout
-- Decompile time: 2.16 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local LocalPlayer = Players.LocalPlayer
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots)
local Grenade = require(ReplicatedStorage.Components.Grenade)
local Weapon = require(ReplicatedStorage.Components.Weapon)
local Melee = require(ReplicatedStorage.Components.Melee)
local C4 = require(ReplicatedStorage.Components.C4)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local u64 = {Grenade = Grenade, Weapon = Weapon, Melee = Melee, C4 = C4}

function u0:setCurrentEquipped(a2) -- Line: 50
    self.PreviousEquipped = self.CurrentEquipped
    self.CurrentEquipped = a2
end

function u0.getNextInventorySlotFromPriority(a1) -- Line: 57 -- upvalues: NumberSlots (val)
    local v1
    local v2 = nil
    local v3 = -1
    for i, v in ipairs(a1.Inventory) do
        v1 = NumberSlots.Priorities[i] or 0
        if #v._items >= 1 and v3 < v1 then
            v2 = i
        end
    end
    return v2
end

function u0:getInventoryItemFromLoadout(a2) -- Line: 72 -- types: a2: string
    local v1 = nil
    local v2 = nil
    local v3 = nil
    for i, v in ipairs(self.Inventory) do
        for i2, i3 in ipairs(v._items) do
            if i3.Identifier == v4 then
                v3 = i2
                v1 = i3
                v2 = i
                break
            end
        end
    end
    return v1, v2, v3
end

function u0.removeInventoryItem(a1, a2) -- Line: 90 -- types: a2: string
    local v1, v2, v3 = a1:getInventoryItemFromLoadout(a2)
    local v4 = v1 and a1.Inventory[v2]
    if not v4 then
        return
    end
    table.remove(v4._items, v3)
    if a1.CurrentEquipped == v1 then
        a1:setCurrentEquipped(nil)
    end
    v1:destroy()
end

function u0.grantPlayerInventoryItem(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) -- Line: 105
    -- upvalues: GetWeaponProperties (val), u64 (val), LocalPlayer (val)
    local v1 = a1.Inventory[a2]
    assert(v1, (("%* does not exist in player inventory"):format(a2)))
    local v2 = GetWeaponProperties(a5)
    assert(v2, (("Client couldn't find weapon properties for \"%*\""):format(a5)))
    local v3 = u64[v2.Class]
    assert(v3, (("Client couldn't find weapon component for \"%*\""):format(a5)))
    debug.profilebegin("Loadout.grantPlayerInventoryItem")
    debug.profilebegin("Loadout.grantPlayerInventoryItem.Component.new")
    local success, result = pcall(v3.new, LocalPlayer, a3, a4, a2, a5, a6, a7, a8, a9, a10, a11, a12, a13)
    debug.profileend()
    if not success then
        debug.profileend()
        error(result, 2)
    end
    debug.profilebegin("Loadout.grantPlayerInventoryItem.InsertAndCleanup")
    table.insert(v1._items, result)
    a1.Janitor:Add(function() -- Line: 157 -- upvalues: result (val)
        if result and getmetatable(result) and not result.IsDestroyed then
            result:destroy()
        end
    end)
    debug.profileend()
    debug.profileend()
end

function u0.new(a1) -- Line: 169
    -- upvalues: u0 (val), Janitor (val), RunServiceController (val), CharacterResolver (val), LocalPlayer (val)
    debug.profilebegin("Loadout.new")
    local u7 = setmetatable({}, u0)
    u7.Janitor = Janitor.new()
    u7.IsDestroyed = false
    u7.Inventory = a1
    u7.Janitor:Add((RunServiceController.BindToRenderStep("Classes.Loadout.RenderEquippedViewmodel", function(a1) -- Line: 175 -- upvalues: u7 (val), CharacterResolver (upval), LocalPlayer (upval) -- types: a1: number
        if u7.IsDestroyed then
            return
        end
        local v1 = CharacterResolver.getPlayerCharacter(LocalPlayer)
        if v1 and v1:GetAttribute("Dead") then
            return
        end
        if u7.CurrentEquipped and u7.CurrentEquipped.Viewmodel.IsEquipped then
            debug.profilebegin("Loadout.RenderEquippedViewmodel")
            u7.CurrentEquipped.Viewmodel:render(a1)
            debug.profileend()
        end
    end)))
    debug.profileend()
    return u7
end

function u0:destroy() -- Line: 201
    if self.IsDestroyed then
        return
    end
    debug.profilebegin("Loadout.destroy")
    self.IsDestroyed = true
    if self.CurrentEquipped then
        if self.CurrentEquipped.unequip then
            self.CurrentEquipped:unequip()
        end
        if self.CurrentEquipped.destroy and not self.CurrentEquipped.IsDestroyed then
            self.CurrentEquipped:destroy()
        end
        self.CurrentEquipped = nil
    end
    if self.PreviousEquipped then
        if self.PreviousEquipped.destroy and not self.PreviousEquipped.IsDestroyed then
            self.PreviousEquipped:destroy()
        end
        self.PreviousEquipped = nil
    end
    if self.Inventory then
        for i, v in ipairs(self.Inventory) do
            if v._items then
                table.clear(v._items)
            end
        end
    end
    self.Janitor:Destroy()
    self.Janitor = nil
    self.Inventory = nil
    debug.profileend()
end

return u0