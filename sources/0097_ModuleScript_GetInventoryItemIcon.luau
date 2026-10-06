-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local u1 = {
    ["Counter-Terrorists"] = "rbxassetid://120553709154808",
    Terrorists = "rbxassetid://76834532512077"
};
local u2 = {
    Weapon = true,
    Melee = true
};

local function GetSkinRender(p3) -- Line: 27
    -- upvalues: Skins (copy)
    if typeof(p3.Name) ~= "string" then
        return nil;
    end;

    local v4 = (typeof(p3.Skin) ~= "string" or p3.Skin == "") and "Stock" or p3.Skin;
    local SkinInformation = Skins.GetSkinInformation(p3.Name, v4);

    if not SkinInformation then
        return nil;
    end;

    if SkinInformation.wearImages and SkinInformation.wearImages[1] then
        return SkinInformation.wearImages[1].assetId;
    end;

    return SkinInformation.imageAssetId;
end;

return function(p5, p6) -- Line: 45
    -- upvalues: u1 (copy), u2 (copy), GetSkinRender (copy)
    if p5 and p5.Properties then
        return p5.Name == "Smoke Grenade" and typeof(p6) == "string" and u1[p6] or (u2[p5.Properties.Class] and GetSkinRender(p5) or p5.Properties.Icon);
    end;

    return nil;
end;