-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);

local function getSpaceNumber(p1: table, p2: string) -- Line: 10
    for i, v in ipairs(p1) do
        if v.Identifier == p2 then
            return i;
        end;
    end;

    return 0;
end;

return function() -- Line: 22
    -- upvalues: InventoryController (copy)
    local CurrentEquipped = InventoryController.getCurrentEquipped();

    if not CurrentEquipped then
        return;
    end;

    local v3 = CurrentEquipped.Slot or 1;
    local InventorySlot = InventoryController.getInventorySlot(v3);
    local Identifier = CurrentEquipped.Identifier;
    local v4 = 0;

    for i, v in ipairs(InventorySlot._items) do
        if v.Identifier == Identifier then
            v4 = i;
            break;
        end;
    end;

    if v4 < #InventorySlot._items then
        InventoryController.equip(v3, v4 + 1);

        return;
    end;

    local CurrentInventory = InventoryController.getCurrentInventory();
    local v5 = v3;

    for i = 1, #CurrentInventory do
        if #CurrentInventory[i]._items > 0 and v3 < i then
            v3 = i;
            break;
        end;

        local _ = i;
    end;

    if v3 == v5 then
        for i = 1, #CurrentInventory do
            if #CurrentInventory[i]._items > 0 and i < v3 then
                v3 = i;
                break;
            end;

            local _ = i;
        end;
    end;

    InventoryController.equip(v3, 1);
end;