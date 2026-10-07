-- ReplicatedStorage.Components.Common.UserInput.EquipSlotLeft
-- Script path: ReplicatedStorage.Components.Common.UserInput.EquipSlotLeft
-- Decompile time: 1.43 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)

local function getSpaceNumber(a1, a2) -- Line: 10 -- types: a1: table, a2: string
    for i, v in ipairs(a1) do
        if v.Identifier == a2 then
            return i
        end
    end
    return 0
end

return function() -- Line: 22 -- upvalues: InventoryController (val)
    local v1, v2, v3
    local v4 = InventoryController.getCurrentEquipped()
    if not v4 then
        return
    end
    local v5 = v4.Slot or 1
    local _items = (InventoryController.getInventorySlot(v5))._items
    local Identifier = v4.Identifier
    for i, v in ipairs(_items) do
        if v.Identifier == Identifier then
            v1 = i
            if v1 > 1 then
                InventoryController.equip(v5, v1 - 1)
                return
            end
            v2 = InventoryController.getCurrentInventory()
            v3 = v5
            for i2 = #v2, 1, -1 do
                if #v2[i2]._items > 0 and i2 < v3 then
                    v3 = i2
                    break
                end
            end
            if v3 == v5 then
                for j = #v2, 1, -1 do
                    if #v2[j]._items > 0 and v3 < j then
                        v3 = j
                    end
                end
            end
            InventoryController.equip(v3, #(InventoryController.getInventorySlot(v3))._items)
            return
        end
    end
    v1 = 0
    if v1 > 1 then
        InventoryController.equip(v5, v1 - 1)
        return
    end
    v2 = InventoryController.getCurrentInventory()
    v3 = v5
    for k = #v2, 1, -1 do
        if #v2[k]._items > 0 and k < v3 then
            v3 = k
            break
        end
    end
    if v3 == v5 then
        for n = #v2, 1, -1 do
            if #v2[n]._items > 0 and v3 < n then
                v3 = n
            end
        end
    end
    InventoryController.equip(v3, #(InventoryController.getInventorySlot(v3))._items)
end