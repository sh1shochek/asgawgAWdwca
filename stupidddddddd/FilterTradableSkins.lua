-- ReplicatedStorage.Shared.FilterTradableSkins
-- Script path: ReplicatedStorage.Shared.FilterTradableSkins
-- Decompile time: 0.43 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local InventoryCharmUtils = require(ReplicatedStorage.Shared.InventoryCharmUtils)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local u22 = table.freeze({Stock = true, Default = true})
return function(a1) -- Line: 13 -- upvalues: InventoryCharmUtils (val), u22 (val), Skins (val) -- types: a1: table
    local v1 = InventoryCharmUtils.GetTradeContext(a1)
    local v2 = {}
    for i, j in a1 do
        if u22[j.Skin] ~= true
            and Skins.HasSkinTextures(j.Name, j.Skin)
            and InventoryCharmUtils.IsTradeableItem(j, v1) then
            table.insert(v2, j)
        end
    end
    return InventoryCharmUtils.ResolveCharmReferences(v2, v1)
end