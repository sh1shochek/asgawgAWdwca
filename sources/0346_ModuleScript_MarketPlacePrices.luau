-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.Database.Custom.Types);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local u2 = false;
local u3 = nil;
local u4 = {};

local function GetWearNameFromFloat(p5: string, p6: string, p7: number) -- Line: 25
    -- upvalues: Skins (copy)
    local SkinInformation = Skins.GetSkinInformation(p5, p6);

    if SkinInformation then
        SkinInformation = Skins.GetWearNameForFloat(SkinInformation, p7);
    end;

    return SkinInformation;
end;

local function WaitForMarketPlacePrices() -- Line: 32
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    while not u2 do
        ReplicatedStorage:GetAttributeChangedSignal("MarketPlacePrices"):Wait();
    end;
end;

local function GetItemKey(p8: string, p9: string) -- Line: 38
    return `{p8}\0{p9}`;
end;

local function UpdateMarketPlacePrices(p10: string) -- Line: 42
    -- upvalues: u3 (ref), HttpService (copy), u4 (copy), u2 (ref)
    u3 = HttpService:JSONDecode(p10);
    table.clear(u4);

    for _, v in u3.items do
        u4[`{v.itemName}\0{v.itemSkin}`] = v;
    end;

    u2 = true;
end;

function u1.GetItemPrice(p11: string, p12: string, p13: number, p14: any) -- Line: 54
    -- upvalues: Skins (copy), u1 (copy)
    local SkinInformation = Skins.GetSkinInformation(p11, p12);

    if SkinInformation then
        SkinInformation = Skins.GetWearNameForFloat(SkinInformation, p13);
    end;

    local MarketPlaceItem = u1.GetMarketPlaceItem(p11, p12);

    if MarketPlaceItem and SkinInformation then
        return (p14 and MarketPlaceItem.statTrack or MarketPlaceItem.standard)[SkinInformation];
    end;

    return nil;
end;

function u1.GetMarketPlaceItem(p15: string, p16: string) -- Line: 70
    -- upvalues: WaitForMarketPlacePrices (copy), u4 (copy)
    WaitForMarketPlacePrices();

    return u4[`{p15}\0{p16}`];
end;

local function SyncMarketPlacePrices() -- Line: 78
    -- upvalues: ReplicatedStorage (copy), UpdateMarketPlacePrices (copy)
    local Attribute = ReplicatedStorage:GetAttribute("MarketPlacePrices");

    if typeof(Attribute) == "string" then
        UpdateMarketPlacePrices(Attribute);
    end;
end;

local Attribute = ReplicatedStorage:GetAttribute("MarketPlacePrices");

if typeof(Attribute) == "string" then
    UpdateMarketPlacePrices(Attribute);
end;

ReplicatedStorage:GetAttributeChangedSignal("MarketPlacePrices"):Connect(SyncMarketPlacePrices);

return u1;