-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
require(ReplicatedStorage.Database.Custom.Types);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local table_freeze_ret = table.freeze({
    Stock = 0,
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5,
    Forbidden = 6
});
local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = {};
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = 0;
local u14 = {};
local u15 = {
    Visible = false
};
local LocalPlayer = Players.LocalPlayer;

local function setHoverVisible(p16: boolean) -- Line: 68
    -- upvalues: u15 (copy), u2 (ref)
    u15.Visible = p16;

    if u2 then
        u2.Visible = p16;
    end;
end;

local function resetHoverLayoutState() -- Line: 77
    -- upvalues: u11 (ref), u12 (ref)
    u11 = nil;
    u12 = nil;
end;

local function disconnectTemplateConnections() -- Line: 84
    -- upvalues: u14 (copy)
    for _, v in ipairs(u14) do
        v:Disconnect();
    end;

    table.clear(u14);
end;

local function isWearType(p17: string) -- Line: 94
    return (p17 == "Weapon" or (p17 == "Melee" or p17 == "Glove")) and true or p17 == "Zeus x27";
end;

local function isPointInGui(p18: userdata, p19) -- Line: 100
    local AbsolutePosition = p18.AbsolutePosition;
    local AbsoluteSize = p18.AbsoluteSize;
    local v20;

    if p19.X >= AbsolutePosition.X and (p19.X <= AbsolutePosition.X + AbsoluteSize.X and p19.Y >= AbsolutePosition.Y) then
        v20 = p19.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v20 = false;
    end;

    return v20;
end;

local function findCaseCollectionName(p21: string) -- Line: 112
    -- upvalues: u1 (ref)
    for _, v in ipairs(u1) do
        local v22 = v;

        for _, v2 in ipairs(v.cases or {}) do
            if v2 == p21 then
                return v22.name;
            end;
        end;
    end;

    return nil;
end;

local function getHoverPosition(p23: userdata) -- Line: 126
    -- upvalues: u2 (ref), Workspace (copy), GuiService (copy)
    local v24 = u2;
    local Parent = v24.Parent;
    local Vector2_zero = Vector2.zero;
    local v25 = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080);

    if Parent and Parent:IsA("GuiObject") then
        Vector2_zero = Parent.AbsolutePosition;
        v25 = Parent.AbsoluteSize;
    end;

    local AbsolutePosition = p23.AbsolutePosition;
    local AbsoluteSize = p23.AbsoluteSize;
    local AbsoluteSize2 = v24.AbsoluteSize;
    local GuiInset = GuiService:GetGuiInset();
    local v26 = AbsolutePosition.X + AbsoluteSize.X + 8;
    local v27 = AbsolutePosition.X - AbsoluteSize2.X - 8;

    if v26 + AbsoluteSize2.X <= Vector2_zero.X + v25.X - 8 then
        v27 = v26;
    end;

    local v28 = Vector2_zero.X + 8;
    local math_max_ret = math.max(v28, Vector2_zero.X + v25.X - AbsoluteSize2.X - 8);
    local math_max_ret2 = math.max(Vector2_zero.Y + 8, GuiInset.Y + 8);
    local math_max_ret3 = math.max(math_max_ret2, Vector2_zero.Y + v25.Y - AbsoluteSize2.Y - 8);
    local v29 = AbsolutePosition.Y + AbsoluteSize.Y / 2;
    local AnchorPoint = v24.AnchorPoint;
    local Vector2_new_ret = Vector2.new(math.clamp(v27, v28, math_max_ret), (math.clamp(v29, math_max_ret2, math_max_ret3)));

    return UDim2.fromOffset(math.floor(Vector2_new_ret.X - Vector2_zero.X + AbsoluteSize2.X * AnchorPoint.X + 0.5), (math.floor(Vector2_new_ret.Y - Vector2_zero.Y + AbsoluteSize2.Y * AnchorPoint.Y + 0.5)));
end;

local function clearCollectionEntries() -- Line: 165
    -- upvalues: u7 (ref)
    for _, child in ipairs(u7.Collection:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "UIListLayout" then
            child:Destroy();
        end;
    end;
end;

local function setCollectionVisible(p30: boolean, p31: string?) -- Line: 175
    -- upvalues: u7 (ref)
    u7.CollectionName.Visible = p30;
    u7.CollectionName.Text = p30 and `{p31}:` or "";
    u7.CollectionSpacer.Visible = p30;
    u7.Collection.Visible = p30;
end;

local function getPackageDescription(p32) -- Line: 184
    -- upvalues: GetSkinDisplayName (copy)
    local v33 = "This package contains the ";

    for i, v in ipairs(p32.contents) do
        local weaponName = v.skin.weaponName;

        if v.skin.type == "Melee" then
            weaponName = `★ {weaponName}`;
        end;

        local SkinDisplayName = GetSkinDisplayName.GetSkinDisplayName(v.skin.skinName, true);

        if SkinDisplayName ~= "" then
            weaponName = `{weaponName} | {SkinDisplayName}`;
        end;

        if i > 1 then
            v33 = v33 .. " and ";
        end;

        v33 = v33 .. weaponName;
    end;

    return v33 .. ".";
end;

local function getDescription(p34, p35, p36) -- Line: 210
    -- upvalues: getPackageDescription (copy), Skins (copy)
    if p35 then
        if p35.caseType == "Package" then
            return getPackageDescription(p35);
        end;

        return p35.description;
    end;

    local Type = p34.Type;

    if Type ~= "Weapon" and (Type ~= "Melee" and Type ~= "Glove") and Type ~= "Zeus x27" then
        return not p36 and "" or p36.description;
    end;

    local SkinInformation = Skins.GetSkinInformation(p34.Type == "Melee" and "T Knife" or (p34.Type == "Glove" and "T Glove" or p34.Name), "Stock");

    return not SkinInformation and "" or SkinInformation.description;
end;

local function formatPrice(p37) -- Line: 233
    -- upvalues: CommaNumber (copy)
    return CommaNumber((math.floor(p37.recentAveragePriceTradeTokens)));
end;

local function resolveHoverData(p38) -- Line: 239
    -- upvalues: Cases (copy), GetSkinDisplayName (copy), findCaseCollectionName (copy), Skins (copy), MarketPlacePrices (copy), CommaNumber (copy), getDescription (copy)
    local v39 = nil;
    local v40 = nil;
    local v41 = nil;
    local v42, v43, v44, v45;

    if p38.Type == "Case" or (p38.Type == "Package" or (p38.Type == "Charm Capsule" or p38.Type == "Sticker Capsule")) then
        v39 = Cases.GetCaseByName(p38.Skin);

        if not v39 then
            warn((`Failed to find case info for {p38.Name} | {p38.Skin}`));

            return nil;
        end;

        v41 = v39.caseType;
        v42 = v41 == "Charm Capsule" and "Charm Pack" or v41;
        v43 = GetSkinDisplayName.GetSkinDisplayName(v39.name, true);
        v44 = v39.caseRarity;

        if v41 == "Case" then
            v45 = findCaseCollectionName(v39.name) or nil;
        else
            v45 = nil;
        end;
    else
        v40 = Skins.GetSkinInformation(p38.Name, p38.Skin);

        if not v40 then
            warn((`Failed to find skin info for {p38.Name} | {p38.Skin}`));

            return nil;
        end;

        v42 = GetSkinDisplayName.GetWeaponDisplayName(p38.Name, p38.NameTag);

        if p38.StatTrack then
            v42 = `KillTrak™ {v42}` or v42;
        end;

        v43 = GetSkinDisplayName.GetSkinDisplayName(p38.Skin, true);
        v44 = v40.rarity;
        v45 = v40.collection;
    end;

    if p38.Type == "Melee" then
        v42 = `★ {v42}`;
    end;

    local v46 = nil;
    local v47 = p38.StatTrack and true or false;

    if p38.ShowFullPriceRange then
        local ItemPrice = MarketPlacePrices.GetItemPrice(p38.Name, p38.Skin, v40 and v40.floatRange.min or p38.Float, v47);
        local ItemPrice2 = MarketPlacePrices.GetItemPrice(p38.Name, p38.Skin, v40 and v40.floatRange.max or p38.Float, v47);

        if ItemPrice and (ItemPrice2 and ItemPrice.recentAveragePriceTradeTokens ~= ItemPrice2.recentAveragePriceTradeTokens) then
            v46 = `{CommaNumber((math.floor(ItemPrice2.recentAveragePriceTradeTokens)))} - {CommaNumber((math.floor(ItemPrice.recentAveragePriceTradeTokens)))}`;
        elseif ItemPrice or ItemPrice2 then
            v46 = CommaNumber((math.floor((ItemPrice or ItemPrice2).recentAveragePriceTradeTokens)));
        end;
    else
        local ItemPrice = MarketPlacePrices.GetItemPrice(p38.Name, p38.Skin, p38.Float, v47);

        if ItemPrice then
            v46 = CommaNumber((math.floor(ItemPrice.recentAveragePriceTradeTokens)));
        end;
    end;

    return {
        skinInfo = v40,
        isCase = v41 == "Case" and true or v41 == "Package",
        isCaseLike = v39 ~= nil,
        displayName = v42,
        skinName = v43,
        description = getDescription(p38, v39, v40),
        rarityName = v44,
        collectionName = v45,
        itemValue = v46
    };
end;

local function buildCollectionList(p48: string?, p49: boolean) -- Line: 332
    -- upvalues: clearCollectionEntries (copy), Collections (copy), u7 (ref), DataController (copy), LocalPlayer (copy), Skins (copy), table_freeze_ret (copy), u4 (ref), Rarities (copy)
    clearCollectionEntries();
    local v50 = not p49;

    if v50 then
        if p48 then
            v50 = Collections.GetCollectionByName(p48);
        else
            v50 = p48;
        end;
    end;

    if not v50 then
        u7.CollectionName.Visible = false;
        u7.CollectionName.Text = "";
        u7.CollectionSpacer.Visible = false;
        u7.Collection.Visible = false;

        return;
    end;

    local v51 = DataController.Get(LocalPlayer, "Inventory") or {};
    local v52 = {};

    for _, v in ipairs(v50.items) do
        local itemName = v.itemName;
        local skinName = v.skinName;
        local SkinInformation = Skins.GetSkinInformation(itemName, skinName);
        local v53 = SkinInformation and SkinInformation.rarity or "Stock";
        local v54 = false;

        for _, v2 in v51 do
            if v2.Name == itemName and v2.Skin == skinName then
                v54 = true;
                break;
            end;
        end;

        table.insert(v52, {
            itemName = itemName,
            skinName = skinName,
            rarity = v53,
            rarityOrder = table_freeze_ret[v53],
            isOwned = v54
        });
    end;

    table.sort(v52, function(p55, p56) -- Line: 368
        if p55.rarity == "Stock" or p56.rarity == "Stock" then
            return p55.rarity ~= "Stock";
        end;

        if p55.rarityOrder == p56.rarityOrder then
            return p55.itemName < p56.itemName;
        end;

        return p55.rarityOrder < p56.rarityOrder;
    end);

    for i, v in v52 do
        local v57 = u4:Clone();
        v57.Parent = u7.Collection;
        v57.LayoutOrder = i;
        v57.Visible = true;
        v57.gun.Text = `[{v.itemName}] | {v.skinName}`;
        v57.gun.TextColor3 = Rarities[v.rarity].Color;
        v57.ImageLabel.Visible = v.isOwned;
    end;

    u7.CollectionName.Visible = true;
    u7.CollectionName.Text = `{p48}:` or "";
    u7.CollectionSpacer.Visible = true;
    u7.Collection.Visible = true;
end;

local function setTeamDisplay(p58: boolean, p59: boolean, p60: string?) -- Line: 395
    -- upvalues: u7 (ref)
    local Team = u7.Team;
    Team.CT.Visible = p58;
    Team.T.Visible = p59;
    Team.Label.Visible = p60 ~= nil;

    if p60 then
        Team.Label.Text = p60;
    end;
end;

local function updateTeamDisplay(p61) -- Line: 407
    -- upvalues: u7 (ref), GetWeaponProperties (copy)
    u7.TeamTitle.Text = "Team:";

    if p61.Type == "Melee" or (p61.Type == "Glove" or (p61.Type == "Badge" or (p61.Type == "Charm" or p61.Type == "Zeus x27"))) then
        local Team = u7.Team;
        Team.CT.Visible = true;
        Team.T.Visible = true;
        Team.Label.Visible = true;
        Team.Label.Text = "Both";

        return;
    end;

    local v62;

    if p61.Type == "Weapon" then
        v62 = GetWeaponProperties(p61.Name);
    else
        v62 = false;
    end;

    if v62 then
        local Team = v62.Team;

        if Team == "Counter-Terrorists" then
            local Team2 = u7.Team;
            Team2.CT.Visible = true;
            Team2.T.Visible = false;
            Team2.Label.Visible = Team ~= nil;

            if Team then
                Team2.Label.Text = Team;

                return;
            end;
        elseif Team == "Terrorists" then
            local Team2 = u7.Team;
            Team2.CT.Visible = false;
            Team2.T.Visible = true;
            Team2.Label.Visible = Team ~= nil;

            if Team then
                Team2.Label.Text = Team;

                return;
            end;
        else
            local Team2 = u7.Team;
            Team2.CT.Visible = true;
            Team2.T.Visible = true;
            Team2.Label.Visible = true;
            Team2.Label.Text = "Both";
        end;

        return;
    end;

    local Team = u7.Team;
    Team.CT.Visible = false;
    Team.T.Visible = false;
    Team.Label.Visible = false;
end;

local function updateFloatDisplay(p63) -- Line: 439
    -- upvalues: u7 (ref)
    if p63.HideWearDetails then
        u7.Team.Visible = false;
        u7.TeamTitle.Visible = false;

        return;
    end;

    u7.TeamTitle.Text = "Float:";
    u7.TeamTitle.Visible = true;
    local v64 = p63.Float and string.format("%.14f", p63.Float) or "N/A";
    local Team = u7.Team;
    Team.CT.Visible = false;
    Team.T.Visible = false;
    Team.Label.Visible = v64 ~= nil;

    if v64 then
        Team.Label.Text = v64;
    end;

    u7.Team.Visible = true;
end;

local function applyHoverData(p65: any, p66: any, p67: boolean) -- Line: 454
    -- upvalues: GetSkinDisplayName (copy), u7 (ref), u6 (ref), Collections (copy), buildCollectionList (copy), Rarities (copy), Skins (copy), updateTeamDisplay (copy)
    local v68 = p66.skinName == "Vanilla" and "" or ` | {p66.skinName}`;
    local collectionName = p66.collectionName;
    GetSkinDisplayName.ApplyNameLabel(u7.ItemName, p66.displayName .. v68, p65.NameTag);
    u7.PriceLabel.Text = p66.itemValue or "N/A";
    u7.Information.Visible = not p66.isCaseLike;

    if p67 then
        u7.CollectionLabel.Visible = false;
        u7.Description.Visible = false;
        u7.CollectionName.Visible = false;
        u7.CollectionName.Text = "";
        u7.CollectionSpacer.Visible = false;
        u7.Collection.Visible = false;
        u6 = nil;
    else
        u7.CollectionLabel.Text = collectionName or "";
        u7.CollectionLabel.Visible = collectionName ~= nil;
        u7.Description.Text = p66.description;
        u7.Description.Visible = p66.description ~= "";
        local v69;

        if collectionName then
            v69 = Collections.GetCollectionByName(collectionName);
        else
            v69 = collectionName;
        end;

        if v69 then
            u7.CollectionIcon.Image = v69.imageAssetId;
        end;

        u7.CollectionIcon.Visible = v69 ~= nil;
        local v70 = `{collectionName or ""}|{p66.isCase}`;

        if u6 ~= v70 then
            buildCollectionList(collectionName, p66.isCase);
            u6 = v70;
        end;
    end;

    u7.Rarity.Text = (p66.rarityName == "Special" or p66.rarityName == "Forbidden") and "★ Special" or p66.rarityName;
    u7.Rarity.TextColor3 = Rarities[p66.rarityName].Color;
    local skinInfo = p66.skinInfo;

    if skinInfo then
        local Type = p65.Type;
        skinInfo = (Type == "Weapon" or (Type == "Melee" or Type == "Glove")) and true or Type == "Zeus x27";
    end;

    if skinInfo then
        local _, v71 = Skins.GetWearNameForFloat(p66.skinInfo, p65.Float or p66.skinInfo.floatRange.max);
        u7.ExteriorLabel.Text = v71;
    end;

    u7.Exterior.Visible = skinInfo == true;

    if not p67 then
        updateTeamDisplay(p65);

        return;
    end;

    if p65.HideWearDetails then
        u7.Team.Visible = false;
        u7.TeamTitle.Visible = false;

        return;
    end;

    u7.TeamTitle.Text = "Float:";
    u7.TeamTitle.Visible = true;
    local v72 = p65.Float and string.format("%.14f", p65.Float) or "N/A";
    local Team = u7.Team;
    Team.CT.Visible = false;
    Team.T.Visible = false;
    Team.Label.Visible = v72 ~= nil;

    if v72 then
        Team.Label.Text = v72;
    end;

    u7.Team.Visible = true;
end;

local function prepareCurrentHoverContent() -- Line: 508
    -- upvalues: u2 (ref), u8 (ref), resolveHoverData (copy), u11 (ref), u15 (copy), u10 (ref), applyHoverData (copy)
    if not (u2 and u8) then
        return false;
    end;

    local v73 = resolveHoverData(u8);

    if v73 then
        local v74 = u10 == "TradeInfo";
        local table_concat_ret = table.concat({
            u8._id,
            v73.displayName,
            v73.skinName,
            v73.description,
            v73.rarityName or "",
            v73.collectionName or "",
            tostring(v73.itemValue or ""),
            tostring(v73.isCase),
            tostring(v73.isCaseLike),
            (tostring(v74))
        }, "\0");

        if u11 ~= table_concat_ret then
            u15.Visible = false;

            if u2 then
                u2.Visible = false;
            end;

            applyHoverData(u8, v73, v74);
            u11 = table_concat_ret;
        end;

        return true;
    end;

    u11 = nil;
    u15.Visible = false;

    if u2 then
        u2.Visible = false;
    end;

    return false;
end;

local function updateHoverPosition(p75: userdata) -- Line: 544
    -- upvalues: getHoverPosition (copy), u12 (ref), u2 (ref)
    local v76 = getHoverPosition(p75);

    if u12 == v76 then
        return;
    end;

    u2.Position = v76;
    u12 = v76;
end;

local function canShowCurrentHover(p77: boolean) -- Line: 556
    -- upvalues: u2 (ref), u8 (ref), u9 (ref), u15 (copy), u3 (ref)
    if not (u2 and (u8 and u9)) then
        u15.Visible = false;

        if u2 then
            u2.Visible = false;
        end;

        return false;
    end;

    if u9.Parent == nil or not u9.Visible then
        u15:Close(u9);

        return false;
    end;

    if p77 or u3 and u3.Visible then
        return true;
    end;

    u15:Close();

    return false;
end;

local function showCurrentHover(p78: boolean) -- Line: 577
    -- upvalues: canShowCurrentHover (copy), u11 (ref), prepareCurrentHoverContent (copy), u9 (ref), getHoverPosition (copy), u12 (ref), u2 (ref), u15 (copy)
    if not canShowCurrentHover(p78) then
        return false;
    end;

    if u11 == nil and not prepareCurrentHoverContent() then
        return false;
    end;

    if u9 then
        local v79 = getHoverPosition(u9);

        if u12 ~= v79 then
            u2.Position = v79;
            u12 = v79;
        end;
    end;

    u15.Visible = true;

    if u2 then
        u2.Visible = true;
    end;

    return true;
end;

local function bindTemplateInvalidation(u80: userdata) -- Line: 596
    -- upvalues: u14 (copy), u15 (copy)
    for _, v in ipairs(u14) do
        v:Disconnect();
    end;

    table.clear(u14);
    u14[1] = u80:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- Line: 600
        -- upvalues: u15 (ref), u80 (copy)
        u15:Close(u80);
    end);
    u14[2] = u80:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 604
        -- upvalues: u80 (copy), u15 (ref)
        if not u80.Visible then
            u15:Close(u80);
        end;
    end);
    u14[3] = u80.AncestryChanged:Connect(function() -- Line: 610
        -- upvalues: u80 (copy), u15 (ref)
        if u80.Parent == nil then
            u15:Close(u80);
        end;
    end);
end;

local function closeTradeInfoFromInput(p81: userdata) -- Line: 619
    -- upvalues: u10 (ref), u15 (copy), u2 (ref), u9 (ref)
    if u10 ~= "TradeInfo" or not (u15.Visible and u2) then
        return;
    end;

    local UserInputType = p81.UserInputType;

    if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    local Vector2_new_ret = Vector2.new(p81.Position.X, p81.Position.Y);
    local v82 = u2;
    local AbsolutePosition = v82.AbsolutePosition;
    local AbsoluteSize = v82.AbsoluteSize;
    local v83;

    if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
        v83 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v83 = false;
    end;

    if v83 then
        return;
    end;

    if u9 and u9.Parent then
        local v84 = u9;
        local AbsolutePosition2 = v84.AbsolutePosition;
        local AbsoluteSize2 = v84.AbsoluteSize;
        local v85;

        if Vector2_new_ret.X >= AbsolutePosition2.X and (Vector2_new_ret.X <= AbsolutePosition2.X + AbsoluteSize2.X and Vector2_new_ret.Y >= AbsolutePosition2.Y) then
            v85 = Vector2_new_ret.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y;
        else
            v85 = false;
        end;

        if v85 then
            return;
        end;
    end;

    u15:Close();
end;

function u15.Initialize(p86, p87, p88) -- Line: 644
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), ReplicatedStorage (copy), u7 (ref), u15 (copy), Collections (copy), u1 (ref), Router (copy)
    u2 = p87;
    u3 = p88;
    u4 = ReplicatedStorage.Assets.TradingUI.Templates:WaitForChild("CollectionNameTemplate");
    u7 = {
        ItemName = u2.ItemName.Frame.ItemName,
        CollectionLabel = u2.ItemName.Frame.Collection,
        CollectionIcon = u2.ItemName.CollectionIcon,
        Description = u2.Description,
        PriceLabel = u2.Price.PriceHolder.Team.Label,
        Information = u2.Information,
        Rarity = u2.Information.Rarity.Label,
        Exterior = u2.Information.Exterior,
        ExteriorLabel = u2.Information.Exterior.Label,
        Team = u2.Information.Team.Team,
        TeamTitle = u2.Information.Team.Team.Label.Parent.Parent.Title,
        Collection = u2.Collection,
        CollectionName = u2.CollectionName,
        CollectionSpacer = u2.CollectionSpacer
    };
    u15.Visible = false;

    if u2 then
        u2.Visible = false;
    end;

    Collections.ObserveAvailableCollections(function(p89) -- Line: 668
        -- upvalues: u1 (ref)
        u1 = p89;
    end);
    Router.observerRouter("OpenTradeInfo", function(p90: any, p91: userdata) -- Line: 672
        -- upvalues: u15 (ref)
        u15:OpenTradeInfo(p90, p91);
    end);
end;

function u15.Start() -- Line: 679
    -- upvalues: u5 (ref), UserInputService (copy), closeTradeInfoFromInput (copy)
    if u5 then
        return;
    end;

    u5 = UserInputService.InputBegan:Connect(closeTradeInfoFromInput);
end;

function u15.Open(p92: any, p93: any, u94: userdata) -- Line: 689
    -- upvalues: u13 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u12 (ref), bindTemplateInvalidation (copy), prepareCurrentHoverContent (copy), canShowCurrentHover (copy), u15 (copy), getHoverPosition (copy), u2 (ref)
    u13 = u13 + 1;
    local u95 = u13;
    u8 = p93;
    u9 = u94;
    u10 = "Inventory";
    u11 = nil;
    u12 = nil;
    bindTemplateInvalidation(u94);

    if not (prepareCurrentHoverContent() and canShowCurrentHover(false)) then
        u15:Close(u94);

        return;
    end;

    local v96 = getHoverPosition(u94);

    if u12 ~= v96 then
        u2.Position = v96;
        u12 = v96;
    end;

    u15.Visible = false;

    if u2 then
        u2.Visible = false;
    end;

    task.delay(0.33, function() -- Line: 707
        -- upvalues: u13 (ref), u95 (copy), u9 (ref), u94 (copy), u10 (ref), canShowCurrentHover (ref), u11 (ref), prepareCurrentHoverContent (ref), getHoverPosition (ref), u12 (ref), u2 (ref), u15 (ref)
        if u13 ~= u95 or (u9 ~= u94 or u10 ~= "Inventory") then
            return;
        end;

        if not canShowCurrentHover(false) then
            return;
        end;

        if u11 == nil and not prepareCurrentHoverContent() then
            return;
        end;

        if u9 then
            local v97 = getHoverPosition(u9);

            if u12 ~= v97 then
                u2.Position = v97;
                u12 = v97;
            end;
        end;

        u15.Visible = true;

        if u2 then
            u2.Visible = true;
        end;
    end);
end;

function u15.OpenTradeInfo(p98: any, p99: any, p100: userdata) -- Line: 718
    -- upvalues: u15 (copy), u10 (ref), u8 (ref), u9 (ref), u13 (ref), u11 (ref), u12 (ref), bindTemplateInvalidation (copy), u2 (ref), prepareCurrentHoverContent (copy), getHoverPosition (copy)
    if u15.Visible and (u10 == "TradeInfo" and (u8 == p99 and u9 == p100)) then
        u15:Close(p100);

        return;
    end;

    u13 = u13 + 1;
    u8 = p99;
    u9 = p100;
    u10 = "TradeInfo";
    u11 = nil;
    u12 = nil;
    bindTemplateInvalidation(p100);
    u15.Visible = false;

    if u2 then
        u2.Visible = false;
    end;

    local v101;

    if u2 and (u8 and u9) then
        if u9.Parent == nil or not u9.Visible then
            u15:Close(u9);
            v101 = false;
        else
            v101 = true;
        end;
    else
        u15.Visible = false;

        if u2 then
            u2.Visible = false;
            v101 = false;
        else
            v101 = false;
        end;
    end;

    local v102;

    if v101 and (u11 ~= nil or prepareCurrentHoverContent()) then
        if u9 then
            local v103 = getHoverPosition(u9);

            if u12 ~= v103 then
                u2.Position = v103;
                u12 = v103;
            end;
        end;

        u15.Visible = true;

        if u2 then
            u2.Visible = true;
            v102 = true;
        else
            v102 = true;
        end;
    else
        v102 = false;
    end;

    if not v102 then
        u15:Close(p100);
    end;
end;

function u15.Close(p104: any, p105: userdata?) -- Line: 739
    -- upvalues: u9 (ref), u13 (ref), u8 (ref), u10 (ref), u6 (ref), u14 (copy), u11 (ref), u12 (ref), u15 (copy), u2 (ref)
    if p105 and u9 ~= p105 then
        return;
    end;

    u13 = u13 + 1;
    u8 = nil;
    u9 = nil;
    u10 = nil;
    u6 = nil;

    for _, v in ipairs(u14) do
        v:Disconnect();
    end;

    table.clear(u14);
    u11 = nil;
    u12 = nil;
    u15.Visible = false;

    if u2 then
        u2.Visible = false;
    end;
end;

return u15;