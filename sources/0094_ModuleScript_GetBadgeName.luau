-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);

return function(p1: userdata, p2: any) -- Line: 19
    -- upvalues: DataController (copy), Skins (copy), GetSkinDisplayName (copy)
    if not p1:IsA("Player") then
        return "";
    end;

    local v3, v4 = DataController.Get(p1, "Loadout", "Inventory");

    if not (v3 and v4) then
        return "";
    end;

    local v5 = v3[p2];

    if not (v5 and v5.Equipped) then
        return "";
    end;

    local v6 = v5.Equipped["Equipped Badge"];

    if not v6 or v6 == "" then
        return "";
    end;

    local v7 = nil;

    for _, v in ipairs(v4) do
        if v._id == v6 then
            v7 = v;
            break;
        end;
    end;

    return not v7 and "" or (not Skins.GetSkinInformation(v7.Name, v7.Skin) and "" or GetSkinDisplayName.GetSkinDisplayName(v7.Skin));
end;