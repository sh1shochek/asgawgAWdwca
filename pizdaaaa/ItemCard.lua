-- ReplicatedStorage.Components.Common.ItemCard
-- Script path: ReplicatedStorage.Components.Common.ItemCard
-- Decompile time: 4.19 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local GetWeaponProperties = require(script.Parent.GetWeaponProperties);
local GetSkinDisplayName = require(script.Parent.GetSkinDisplayName);
local GetResolvedSkinInformation = require(script.Parent.GetResolvedSkinInformation);
local ApplyWearAndSerialBadges = require(script.Parent.ApplyWearAndSerialBadges);
local ItemEquipment = require(script.Parent.ItemEquipment);
local u2 = {
    ["Charm Capsule"] = "Charm Pack",
    Package = "Package"
};

local function findCharmItem(p3) -- Line: 33
    -- upvalues: DataController (copy), Players (copy)
    if type(p3) == "table" then
        p3 = p3._id;
    elseif type(p3) ~= "string" then
        p3 = nil;
    end;

    if not p3 then
        return nil;
    end;

    for _, v in DataController.Get(Players.LocalPlayer, "Inventory") or {} do
        if v._id == p3 and v.Type == "Charm" then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetIconImage(p4: any, p5: any, p6: boolean) -- Line: 54
    -- upvalues: Skins (copy)
    if not p5 then
        return "";
    end;

    if p6 then
        return p5.imageAssetId or "";
    end;

    if p4.Type ~= "Charm" then
        return Skins.GetWearImageForFloat(p5, p4.Float or 0.9999) or p5.imageAssetId or "";
    end;

    local Pattern = p4.Pattern;

    if Pattern and p5.charmImages then
        for _, v in ipairs(p5.charmImages) do
            if v.pattern == Pattern then
                return v.assetId;
            end;
        end;
    end;

    return p5.imageAssetId or "";
end;

function u1.GetDisplayName(p7: any, p8: any, p9: boolean) -- Line: 79
    -- upvalues: GetSkinDisplayName (copy), u2 (copy)
    local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(p7.Name, p7.NameTag);
    local v10 = p9 and p8.caseType and u2[p8.caseType] or p9 and p8.caseType;

    if v10 then
        WeaponDisplayName = v10;
    elseif p7.StatTrack then
        WeaponDisplayName = "KillTrak™ " .. WeaponDisplayName or WeaponDisplayName;
    end;

    return (p7.Type == "Melee" and "★ " or "") .. WeaponDisplayName;
end;

function u1.SyncCharm(p11, p12) -- Line: 93
    -- upvalues: findCharmItem (copy), GetResolvedSkinInformation (copy), u1 (copy)
    local Charm = p11.ItemContent:FindFirstChild("Charm");

    if not (Charm and Charm:IsA("ImageLabel")) then
        return;
    end;

    local v13;

    if p12.Type == "Weapon" then
        v13 = findCharmItem(p12.Charm);
    else
        v13 = nil;
    end;

    local v14;

    if v13 then
        v14 = GetResolvedSkinInformation(v13.Name, v13.Skin);
    else
        v14 = v13;
    end;

    local v15 = not v14 and "" or u1.GetIconImage(v13, v14, false);
    Charm.Image = v15;
    Charm.Visible = v15 ~= "";
end;

function u1.Fill(p16: any, p17: any, p18: any, p19: boolean) -- Line: 108
    -- upvalues: Rarities (copy), u1 (copy), GetWeaponProperties (copy), ApplyWearAndSerialBadges (copy), GetSkinDisplayName (copy), ItemEquipment (copy)
    local ItemContent = p16.ItemContent;
    ItemContent.Rarity.BackgroundColor3 = Rarities[p19 and p18.caseRarity or p18.rarity].Color;
    local Icon = ItemContent.Content.Icon;
    Icon.Image = u1.GetIconImage(p17, p18, p19);
    local v20 = GetWeaponProperties(p17.Name);

    if v20 then
        v20 = v20.InventoryIconData;
    end;

    if v20 then
        Icon.ScaleType = v20.ScaleType or Icon.ScaleType;
        Icon.Size = v20.Size or Icon.Size;
    end;

    u1.SyncCharm(p16, p17);
    ApplyWearAndSerialBadges(p16, p17, p18);
    GetSkinDisplayName.ApplyNameLabel(p16.Bottom.Footer.WeaponName, u1.GetDisplayName(p17, p18, p19), p17.NameTag);
    p16.Bottom.Footer.SkinName.Text = GetSkinDisplayName(p19 and p18.skin or (p17.Skin or ""));
    ItemEquipment.UpdateStatusFrame(p16, p17._id);
end;

return u1;