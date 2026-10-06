-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);

local function isZeusInventorySpace(p1) -- Line: 13
    return p1.Name == "Zeus x27";
end;

local function getSpaceNumber(p2: table, p3: string) -- Line: 17
    for i, v in ipairs(p2) do
        if v.Identifier == p3 then
            return i;
        end;
    end;

    return 0;
end;

local function getPreferredSpaceOrder(p4: number, p5: table, p6: function?) -- Line: 26
    local v7 = {};

    if p4 ~= 3 then
        for i = 1, #p5 do
            local v8;

            if p6 and not p6(p5[i]) then
                v8 = i;
            else
                table.insert(v7, i);
                v8 = i;
            end;
        end;

        return v7;
    end;

    for i, v in ipairs(p5) do
        if v.Name ~= "Zeus x27" then
            table.insert(v7, i);
        end;
    end;

    for i, v in ipairs(p5) do
        if v.Name == "Zeus x27" then
            table.insert(v7, i);
        end;
    end;

    return v7;
end;

local function getPreferredSpaceNumber(p9: number, p10: table, p11: string?, p12: function?) -- Line: 58
    -- upvalues: getPreferredSpaceOrder (copy)
    local v13 = getPreferredSpaceOrder(p9, p10, p12);
    local v14 = v13[1];

    if not v14 then
        return 0;
    end;

    if not p11 then
        return v14;
    end;

    local table_find = table.find;
    local v15 = v13;
    local v16 = 0;

    for i, v in ipairs(p10) do
        if v.Identifier == p11 then
            v16 = i;
            break;
        end;
    end;

    local v17 = table_find(v13, v16);

    if v17 then
        v14 = v15[v17 + 1] or v14;
    end;

    return v14;
end;

return function(p18: number, p19: function?) -- Line: 82
    -- upvalues: InventoryController (copy), getPreferredSpaceOrder (copy)
    local CurrentEquipped = InventoryController.getCurrentEquipped();
    local InventorySlot = InventoryController.getInventorySlot(p18);

    if not InventorySlot then
        return;
    end;

    local v20;

    if CurrentEquipped and (CurrentEquipped.Slot or 1) == p18 then
        v20 = CurrentEquipped.Identifier;
    else
        v20 = nil;
    end;

    local _items = InventorySlot._items;
    local v21 = getPreferredSpaceOrder(p18, _items, p19);
    local v22 = v21[1];

    if v22 then
        if v20 then
            local table_find = table.find;
            local v23 = v21;
            local v24 = 0;

            for i, v in ipairs(_items) do
                if v.Identifier == v20 then
                    v24 = i;
                    break;
                end;
            end;

            local v25 = table_find(v21, v24);

            if v25 then
                local v26 = v23[v25 + 1];

                if v26 then
                    v22 = v26;
                end;
            end;
        end;
    else
        v22 = 0;
    end;

    if v22 > 0 then
        InventoryController.equip(p18, v22);
    end;
end;