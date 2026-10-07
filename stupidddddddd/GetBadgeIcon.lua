-- ReplicatedStorage.Components.Common.GetBadgeIcon
-- Script path: ReplicatedStorage.Components.Common.GetBadgeIcon
-- Decompile time: 0.69 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
return function(a1, a2) -- Line: 18 -- upvalues: DataController (val), Skins (val) -- types: a1: userdata
    if not a1:IsA("Player") then
        return ""
    end
    local v1, v2 = DataController.Get(a1, "Loadout", "Inventory")
    if v1 and v2 then
        local v3 = v1[a2]
        if v3 and v3.Equipped then
            local v4 = v3.Equipped["Equipped Badge"]
            if v4 and v4 ~= "" then
                local v5 = nil
                for i, v in ipairs(v2) do
                    if v._id == v4 then
                        v5 = v
                        break
                    end
                end
                if not v5 then
                    return ""
                end
                local v6 = Skins.GetSkinInformation(v5.Name, v5.Skin)
                if not v6 then
                    return ""
                end
                return Skins.GetWearImageForFloat(v6, v5.Float or 0.9999) or v6.imageAssetId or ""
            end
            return ""
        end
        return ""
    end
    return ""
end