-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Sift = require(ReplicatedStorage.Packages.Sift);
local u1 = { "_id", "Type", "Name", "Skin", "Rarity", "OriginalOwner" };
local u2 = { "LastTradeAt", "CreatedAt" };
local u3 = { "OriginalOwner", "Owner", "Origin", "GlobalMarketPlaceListingReference" };

return function(p4) -- Line: 9
    -- upvalues: Sift (copy), u1 (copy), u2 (copy), u3 (copy)
    if typeof(p4) ~= "table" then
        return p4;
    end;

    local v5 = Sift.Dictionary.copyDeep(p4);

    for _, v in u1 do
        if typeof(v5[v]) == "number" then
            v5[v] = tostring(v5[v]);
        end;
    end;

    local MetaData = v5.MetaData;

    if typeof(MetaData) == "table" then
        for _, v in u2 do
            if typeof(MetaData[v]) == "string" then
                MetaData[v] = tonumber(MetaData[v]);
            end;
        end;

        if MetaData.GlobalMarketPlaceListingReference == false then
            MetaData.GlobalMarketPlaceListingReference = nil;
        end;

        for _, v in u3 do
            if typeof(MetaData[v]) == "number" then
                MetaData[v] = tostring(MetaData[v]);
            end;
        end;
    end;

    return v5;
end;