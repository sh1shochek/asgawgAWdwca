-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local InventoryCharmUtils = require(ReplicatedStorage.Shared.InventoryCharmUtils);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local table_freeze_ret = table.freeze({
    Stock = true,
    Default = true
});

return function(p1: table) -- Line: 13
    -- upvalues: InventoryCharmUtils (copy), table_freeze_ret (copy), Skins (copy)
    local TradeContext = InventoryCharmUtils.GetTradeContext(p1);
    local v2 = {};

    for _, v in p1 do
        if table_freeze_ret[v.Skin] ~= true and (Skins.HasSkinTextures(v.Name, v.Skin) and InventoryCharmUtils.IsTradeableItem(v, TradeContext)) then
            table.insert(v2, v);
        end;
    end;

    return InventoryCharmUtils.ResolveCharmReferences(v2, TradeContext);
end;