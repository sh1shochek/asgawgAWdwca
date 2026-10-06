-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);

return function(p1: userdata, p2: any) -- Line: 18
    -- upvalues: DataController (copy), Skins (copy)
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

    if not v7 then
        return "";
    end;

    local SkinInformation = Skins.GetSkinInformation(v7.Name, v7.Skin);

    return SkinInformation and (Skins.GetWearImageForFloat(SkinInformation, v7.Float or 0.9999) or SkinInformation.imageAssetId or "") or "";
end;