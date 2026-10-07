-- ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot
-- Script path: ReplicatedStorage.Components.Common.UserInput.EquipInventorySlot
-- Decompile time: 5.73 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)

local function isZeusInventorySpace(a1) -- Line: 13
    return a1.Name == "Zeus x27"
end

local function getSpaceNumber(a1, a2) -- Line: 17 -- types: a1: table, a2: string
    for i, v in ipairs(a1) do
        if v.Identifier == a2 then
            return i
        end
    end
    return 0
end

local function getPreferredSpaceOrder(a1, a2, a3) -- Line: 26 -- types: a1: number, a2: table, a3: function?
    local v1 = {}
    if a1 == 3 then
        for i, v in ipairs(a2) do
            if not (v.Name == "Zeus x27") then
                table.insert(v1, i)
            end
        end
        for i2, i3 in ipairs(a2) do
            if i3.Name == "Zeus x27" then
                table.insert(v1, i2)
            end
        end
        return v1
    end
    local v2 = #a2
    local v3, v4 = a3, a2
    for j = 1, v2 do
        if not v3 or v3(v4[j]) then
            table.insert(v1, j)
        end
    end
    return v1
end

local function getPreferredSpaceNumber(a1, a2, a3, a4) -- Line: 58
    -- upvalues: getPreferredSpaceOrder (val)
    local v1
    local v2 = getPreferredSpaceOrder(a1, a2, a4)
    local v3 = v2[1]
    if not v3 then
        return 0
    end
    if not a3 then
        return v3
    end
    local find = table.find
    for i, v in ipairs(a2) do
        if v.Identifier == a3 then
            v1 = find(v2, i)
            return v1 and v2[v1 + 1] or v3
        end
    end
    v1 = find(v2, 0)
    return v1 and v2[v1 + 1] or v3
end

return function(a1, a2) -- Line: 82
    -- upvalues: InventoryController (val), getPreferredSpaceOrder (val)
    local v1
    local v2 = InventoryController.getCurrentEquipped()
    local v3 = InventoryController.getInventorySlot(a1)
    if not v3 then
        return
    end
    local Identifier = if not v2 then nil else if (v2.Slot or 1) ~= a1 then nil else v2.Identifier
    local _items = v3._items
    local v4 = getPreferredSpaceOrder(a1, _items, a2)
    local v5 = v4[1]
    if not v5 then
        v1 = 0
    elseif Identifier then
        local v6
        local find = table.find
        for i, v in ipairs(_items) do
            if v.Identifier == Identifier then
                v6 = find(v4, i)
                v1 = v6 and v4[v6 + 1] or v5
                if v1 > 0 then
                    InventoryController.equip(a1, v1)
                end
                return
            end
        end
        v6 = find(v4, 0)
        v1 = v6 and v4[v6 + 1] or v5
    else
        v1 = v5
    end
    if v1 > 0 then
        InventoryController.equip(a1, v1)
    end
end