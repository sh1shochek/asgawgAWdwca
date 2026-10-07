-- ReplicatedStorage.Controllers.InputController.Actions.LastWeaponUsed
-- Script path: ReplicatedStorage.Controllers.InputController.Actions.LastWeaponUsed
-- Decompile time: 0.98 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Parent.Parent.Types)
local LocalPlayer = Players.LocalPlayer
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local InspectController = require(ReplicatedStorage.Controllers.InspectController)

local function equipFallback() -- Line: 23 -- upvalues: InventoryController (val)
    local v1 = InventoryController.getCurrentInventory()
    local v2 = InventoryController.getCurrentEquipped()
    if v1 and v2 then
        local Slot = nil
        local v3 = nil
        for i, v in ipairs(v1) do
            for i2, i3 in ipairs(v._items) do
                if i3.Identifier ~= v2.Identifier then
                    Slot = i3.Slot
                    v3 = i2
                    break
                end
            end
        end
        if Slot and v3 then
            InventoryController.equip(Slot, v3)
        end
        return
    end
end

return table.freeze({
    Name = "Last Weapon Used",
    Group = "Gameplay",
    Category = "Weapon Keys",
    Callback = function(a1, a2) -- Line: 47
        -- upvalues: LocalPlayer (val), CaseSceneController (val), BlackMarketSceneController (val)
        -- upvalues: InspectController (val), InventoryController (val), equipFallback (val)
        if not LocalPlayer:GetAttribute("IsPlayerChatting") and a1 == Enum.UserInputState.Begin then
            if not CaseSceneController.IsActive()
                and not BlackMarketSceneController.IsActive()
                and not InspectController.IsActive() then
                local v1, v2
                local v3 = InventoryController.getPreviousEquipped()
                if not v3 then
                    equipFallback()
                    return
                end
                _, v1, v2 = InventoryController.getInventoryItemFromLoadout(v3.Identifier)
                if v1 and v2 then
                    InventoryController.equip(v1, v2)
                end
                return
            end
            return
        end
    end,
})