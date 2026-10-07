-- ReplicatedStorage.Components.Common.UserInput.EquipSlotRight
-- Script path: ReplicatedStorage.Components.Common.UserInput.EquipSlotRight
-- Decompile time: 2.03 ms

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
    local v1, v2, v3, v4
    local v5 = InventoryController.getCurrentEquipped()
    if not v5 then
        return
    end
    local v6 = v5.Slot or 1
    local v7 = InventoryController.getInventorySlot(v6)
    local _items = v7._items
    local Identifier = v5.Identifier
    for i, v in ipairs(_items) do
        if v.Identifier == Identifier then
            v1 = i
            if v1 < #v7._items then
                InventoryController.equip(v6, v1 + 1)
                return
            end
            v2 = InventoryController.getCurrentInventory()
            v3 = v6
            v4 = #v2
            for i2 = 1, v4 do
                if #v2[i2]._items > 0 and v3 < i2 then
                    v3 = i2
                    break
                end
            end
            if v3 == v6 then
                v4 = #v2
                for j = 1, v4 do
                    if #v2[j]._items > 0 and j < v3 then
                        v3 = j
                        break
                    end
                end
            end
            InventoryController.equip(v3, 1)
            return
        end
    end
    v1 = 0
    if v1 < #v7._items then
        InventoryController.equip(v6, v1 + 1)
        return
    end
    v2 = InventoryController.getCurrentInventory()
    v3 = v6
    v4 = #v2
    for k = 1, v4 do
        if #v2[k]._items > 0 and v3 < k then
            v3 = k
            break
        end
    end
    if v3 == v6 then
        v4 = #v2
        for n = 1, v4 do
            if #v2[n]._items > 0 and n < v3 then
                v3 = n
                break
            end
        end
    end
    InventoryController.equip(v3, 1)
end