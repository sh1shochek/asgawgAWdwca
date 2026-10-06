-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local GuiService = game:GetService("GuiService");
local AssetService = game:GetService("AssetService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PolicyService = game:GetService("PolicyService");
local GuiInset = GuiService:GetGuiInset();
local LocalPlayer = Players.LocalPlayer;
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Store = require(ReplicatedStorage.Interface.Screens.Menu.Store);
local MarketplaceButton = require(ReplicatedStorage.Components.Common.MarketplaceButton);
local MarketplaceDropdown = require(ReplicatedStorage.Components.Common.MarketplaceDropdown);
local MarketplaceHover = require(ReplicatedStorage.Components.Common.MarketplaceHover);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local FuzzySearch = require(ReplicatedStorage.Shared.FuzzySearch);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GuiShown = require(ReplicatedStorage.Components.Common.InterfaceAnimations.GuiShown);
local CollectionServiceUtility = require(ReplicatedStorage.Shared.CollectionServiceUtility);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local InspectController = require(ReplicatedStorage.Controllers.InspectController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices);
local UserCache = require(ReplicatedStorage.Database.Custom.UserCache);
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GlobalMarketplace = Remotes.GlobalMarketplace;
require(ReplicatedStorage.Database.Custom.Types);
local u1 = {};

for i, v in { "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine" } do
    u1[Enum.KeyCode[v]] = tostring(i - 1);
    u1[Enum.KeyCode[`Keypad{v}`]] = tostring(i - 1);
end;

local table_freeze_ret = table.freeze({
    Badge = true,
    Booth = true
});
local table_freeze_ret2 = table.freeze({
    Package = true,
    Console = true,
    Case = true
});
local table_freeze_ret3 = table.freeze({ "Karambit | Wemby", "Butterfly Knife | Lebron James", "CT Knife | Lebron James", "Wemby", "Lebron James" });
local u2 = { 0, Constants.MARKETPLACE_MAX_LISTING_PRICE };
local u3 = { {
        scale = 0.5,
        valueRatio = 0.001
    }, {
        scale = 0.85,
        valueRatio = 0.01
    }, {
        scale = 1,
        valueRatio = 1
    } };
local u4 = { { "ITEM_NOT_MARKETABLE", "This item is not available on the marketplace" }, { "ITEM_HAS_CHARM", "Remove the charm before listing this item" }, { "ITEM_IS_CHARM", "Charms cannot be listed on the marketplace" } };
local Color3_fromRGB_ret = Color3.fromRGB(32, 255, 28);
local u5 = false;
local u6 = false;
local u7 = 0;
local u8 = {
    search_bar_query = "",
    statTrak = nil,
    rarity = nil,
    Collection = nil,
    page = 1,
    price_range = { u2[1], u2[2] },
    pattern_range = { 0, 11 },
    wear_range = { 0, 1 }
};
local u9 = {};
local u10 = nil;
local u11 = {};
local u12 = 1;
local u13 = false;
local u14 = {};
local u15 = { {
        key = "FactoryNew",
        max = 0.07,
        wear = "Factory New"
    }, {
        key = "MinimalWear",
        max = 0.15,
        wear = "Minimal Wear"
    }, {
        key = "FieldTested",
        max = 0.38,
        wear = "Field-Tested"
    }, {
        key = "WellWorn",
        max = 0.45,
        wear = "Well-Worn"
    }, {
        key = "BattleScarred",
        max = 1,
        wear = "Battle-Scarred"
    } };
local u16 = nil;
local u17 = {};
local u18 = false;
local u19 = nil;
local u20 = { "Market", "Sell", "Profile" };
local u21 = {
    pageSize = 10,
    sort = "Quality",
    searchTerm = nil,
    sortReversed = false,
    filters = { "Tradable", "MarketplaceListable", "All" }
};
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = {};
local u26 = 0;
local u27 = nil;
local u28 = nil;
local u29 = false;
local u30 = nil;
local u31 = false;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = nil;
local v47 = {
    tweenVisibility = false
};

local function setLoading(p48: boolean) -- Line: 227
    -- upvalues: u36 (ref), u43 (ref)
    u36.Parent.Parent.Loading.Visible = p48;

    if p48 then
        u43:Play();

        return;
    end;

    u43:Pause();
end;

local function getHeadshot(p49: number, p50: any) -- Line: 236
    -- upvalues: Players (copy)
    return Players:GetUserThumbnailAsync(p49, Enum.ThumbnailType.HeadShot, p50 or Enum.ThumbnailSize.Size180x180);
end;

local function itemTypeHidesInspect(p51: string?) -- Line: 241
    return p51 == "Case" and true or p51 == "Package";
end;

local function showInspect(p52) -- Line: 245
    -- upvalues: u36 (ref), MenuState (copy), u32 (ref), GuiService (copy), CloseButtonRegistry (copy), InspectController (copy)
    local Type = p52.Type;

    if Type == "Case" and true or Type == "Package" then
        return;
    end;

    local Market = u36.Market;
    local v53;

    if MenuState.IsSelectionWithin(Market.PurchaseMenu) or MenuState.IsSelectionWithin(Market.Header.Guns) then
        v53 = GuiService.SelectedObject;
    else
        v53 = nil;
    end;

    u32 = v53;
    local Inspect = u36.Parent:FindFirstChild("Inspect");

    if Inspect then
        CloseButtonRegistry.BringToFront(Inspect);
    end;

    InspectController.ShowInspect(p52);
end;

local function openTradeTokensStore() -- Line: 265
    -- upvalues: ReplicatedStorage (copy), MenuState (copy), Store (copy)
    require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Store");

    if MenuState.GetCurrentScreen() == "Store" then
        Store.OpenTab("TradeTokens");
    end;
end;

local function showNewItemsNotification(p54: table) -- Line: 273
    -- upvalues: Router (copy)
    local v55 = #p54;
    Router.broadcastRouter("CreateNotification", "Marketplace", v55 == 1 and "Your marketplace item was added to your inventory." or `{v55} marketplace items were added to your inventory.`, 4);
end;

local function sendMarketSearch() -- Line: 285
    -- upvalues: u8 (copy), GlobalMarketplace (copy), u33 (ref)
    local pattern_range = u8.pattern_range;

    if pattern_range and pattern_range[1] <= 0 then
        u8.pattern_range = nil;
    end;

    GlobalMarketplace.SearchMarket.Send(u8);
    u8.pattern_range = pattern_range;
    u33();
end;

u33 = function() -- Line: 297, Name: abandonSearchAfterTimeout
    -- upvalues: u26 (ref), u36 (ref), u13 (ref), u43 (ref)
    u26 = u26 + 1;
    local u56 = u26;
    task.delay(15, function() -- Line: 301
        -- upvalues: u56 (copy), u26 (ref), u36 (ref), u13 (ref), u43 (ref)
        if u56 ~= u26 or not u36 then
            return;
        end;

        u13 = false;
        u36.Parent.Parent.Loading.Visible = false;
        u43:Pause();
    end);
end;

local function hydrateSellerNameAsync(u57: any, u58: number) -- Line: 334
    -- upvalues: UserCache (copy)
    u57.Text = "Seller: ...";
    task.spawn(function() -- Line: 337
        -- upvalues: UserCache (ref), u58 (copy), u57 (copy)
        local success, result = pcall(UserCache.Fetch, u58);
        local v59 = not (success and (result and result.Username)) and "Unknown User" or result.Username;

        if u57.Parent then
            u57.Text = `Seller: {v59}`;
        end;
    end);
end;

local function stopOnlineStatusPulse(p60: userdata) -- Line: 347
    -- upvalues: u46 (ref), u45 (ref)
    if u46 then
        u46();
        u46 = nil;
    end;

    if u45 then
        u45:Cancel();
        u45 = nil;
    end;

    p60.TextTransparency = 0;
    local OnlinePulseDot = p60:FindFirstChild("OnlinePulseDot");

    if OnlinePulseDot and OnlinePulseDot:IsA("GuiObject") then
        OnlinePulseDot.Visible = false;
    end;
end;

local function getOnlineStatusDot(p61: userdata) -- Line: 365
    local OnlinePulseDot = p61:FindFirstChild("OnlinePulseDot");

    if OnlinePulseDot and not OnlinePulseDot:IsA("Frame") then
        OnlinePulseDot:Destroy();
        OnlinePulseDot = nil;
    end;

    if not OnlinePulseDot then
        OnlinePulseDot = Instance.new("Frame");
        OnlinePulseDot.Name = "OnlinePulseDot";
        OnlinePulseDot.BorderSizePixel = 0;
        OnlinePulseDot.Parent = p61;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(1, 0);
        UICorner.Parent = OnlinePulseDot;
    end;

    OnlinePulseDot.AnchorPoint = Vector2.new(0.5, 0.5);
    OnlinePulseDot.Position = UDim2.new(0, -7, 0.5, 0);
    OnlinePulseDot.Size = UDim2.fromOffset(6, 6);
    OnlinePulseDot.ZIndex = p61.ZIndex + 1;

    return OnlinePulseDot;
end;

local function setOnlineStatus(p62: userdata) -- Line: 393
    -- upvalues: u46 (ref), u45 (ref), Color3_fromRGB_ret (copy), getOnlineStatusDot (copy), TweenService (copy), GuiShown (copy)
    if u46 then
        u46();
        u46 = nil;
    end;

    if u45 then
        u45:Cancel();
        u45 = nil;
    end;

    p62.TextTransparency = 0;
    local OnlinePulseDot = p62:FindFirstChild("OnlinePulseDot");

    if OnlinePulseDot and OnlinePulseDot:IsA("GuiObject") then
        OnlinePulseDot.Visible = false;
    end;

    p62.Text = "Online";
    p62.TextColor3 = Color3_fromRGB_ret;
    local v63 = getOnlineStatusDot(p62);
    v63.Visible = true;
    v63.BackgroundColor3 = Color3_fromRGB_ret;
    v63.BackgroundTransparency = 0.05;
    local u64 = TweenService:Create(v63, TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.42,
        BackgroundColor3 = Color3_fromRGB_ret
    });
    u45 = u64;
    u46 = GuiShown.Observe(v63, function(p65: boolean) -- Line: 413
        -- upvalues: u64 (copy)
        if p65 then
            u64:Play();

            return;
        end;

        u64:Pause();
    end);
end;

local function prepareMarketplaceListingReveal(p66) -- Line: 422
    p66:SetAttribute("StaggerRevealReady", false);
    p66.Visible = false;
end;

local function revealMarketplaceListings(u67: table, u68: function) -- Line: 427
    task.spawn(function() -- Line: 431
        -- upvalues: u67 (copy), u68 (copy)
        for _, v in u67 do
            if v.Parent then
                v:SetAttribute("StaggerRevealReady", true);
                v.Visible = u68(v);
            end;

            task.wait(0.018);
        end;
    end);
end;

local function pruneOldestListingFrames(p69: userdata, p70: number) -- Line: 312
    local v71 = {};

    for _, child in p69:GetChildren() do
        if child:IsA("GuiObject") and child.Name ~= ".space" then
            table.insert(v71, child);
        end;
    end;

    if #v71 <= p70 then
        return;
    end;

    table.sort(v71, function(p72, p73) -- Line: 324
        return p72.LayoutOrder < p73.LayoutOrder;
    end);

    for i = 1, #v71 - p70 do
        v71[i]:Destroy();
        local _ = i;
    end;
end;

for _, child in ReplicatedStorage.Assets.Skins:GetChildren() do
    local v74 = GetSkinDisplayName.GetWeaponDisplayName(child.Name):lower();
    table.insert(u25, v74);

    for _, child2 in child:GetChildren() do
        table.insert(u25, child2.Name:lower());
        local v75 = `{v74} {child2.Name:lower()}`;
        table.insert(u25, v75);
    end;
end;

local PredictSearch = require(ReplicatedStorage.Components.Common.PredictSearch);

local function predictSearch() -- Line: 455
    -- upvalues: u36 (ref), PredictSearch (copy), u25 (copy), u23 (ref)
    local v76 = u36.Market.Filters.Container.Search.Frame.SearchBox.Text:lower();
    u36.Market.Filters.Container.Search.Frame.SearchBox.Text = v76;
    local v77 = PredictSearch(u25, v76, 3);

    if not v77 then
        u23 = nil;
        u36.Market.Filters.Container.Search.Frame.Auto.Text = "";

        return;
    end;

    local v78 = v77:gsub("m9", ""):gsub("TKnife", "Knife"):gsub("CTKnife", "Knife"):gsub("_PATTERN_%d+", ""):gsub("The", ""):gsub("_pattern_%d+", "");
    u23 = v78;
    u36.Market.Filters.Container.Search.Frame.Auto.Text = v78;
end;

local u79 = 0;

local function schedulePredictSearch() -- Line: 477
    -- upvalues: u79 (ref), predictSearch (copy)
    u79 = u79 + 1;
    local u80 = u79;
    task.delay(0.12, function() -- Line: 481
        -- upvalues: u80 (copy), u79 (ref), predictSearch (ref)
        if u80 ~= u79 then
            return;
        end;

        predictSearch();
    end);
end;

local function getSkinValue(p81: string, p82: string, p83: number, p84: boolean) -- Line: 490
    -- upvalues: MarketPlacePrices (copy)
    local ItemPrice = MarketPlacePrices.GetItemPrice(p81, p82, p83, p84);

    if ItemPrice then
        ItemPrice = ItemPrice.recentAveragePriceTradeTokens;
    end;

    if ItemPrice and ItemPrice > 0 then
        return math.floor(ItemPrice);
    end;

    return nil;
end;

local function formatSkinValue(p85: number?) -- Line: 496
    -- upvalues: CommaNumber (copy)
    return not p85 and "N/A" or CommaNumber(p85);
end;

local function getRarityData(p86: string?) -- Line: 500
    -- upvalues: Rarities (copy)
    local v87 = nil;

    for i, v in Rarities do
        if tostring(i) == "Stock" then
            v87 = v;
        end;

        if tostring(i) == p86 then
            return v;
        end;
    end;

    return v87;
end;

local function itemTypeShowsFloat(p88: string?) -- Line: 514
    local v89;

    if p88 == "Case" or (p88 == "Charm Capsule" or p88 == "Sticker Capsule") then
        v89 = false;
    else
        v89 = p88 ~= "Package";
    end;

    return v89;
end;

local function formatSaleDate(p90: number) -- Line: 522
    return `{`{os.date("%B", p90)} {os.date("%d", p90)}, {os.date("%Y", p90)}`}, {os.date("%I:%M %p", p90)}`;
end;

local function isPurchaseRestrictedForItem(p91: string?) -- Line: 527
    -- upvalues: u6 (ref), table_freeze_ret2 (copy)
    local v92 = u6;

    if v92 then
        if p91 == nil then
            v92 = false;
        else
            v92 = table_freeze_ret2[p91] == true;
        end;
    end;

    return v92;
end;

local function getMarketplaceErrorMessage(p93) -- Line: 531
    -- upvalues: u4 (copy), getMarketplaceErrorMessage (copy)
    if type(p93) ~= "table" then
        return nil;
    end;

    for _, v in { "code", "errorCode", "error_code", "errorMessage", "error_message", "error", "message", "detail", "details" } do
        local v94 = p93[v];

        for _, v2 in u4 do
            if v94 == v2[1] or v94 == v2[2] then
                return v2[2];
            end;
        end;

        if type(v94) == "table" then
            local v95 = getMarketplaceErrorMessage(v94);

            if v95 then
                return v95;
            end;
        end;
    end;

    if type(p93.results) == "table" then
        for _, v in p93.results do
            local v96 = getMarketplaceErrorMessage(v);

            if v96 then
                return v96;
            end;
        end;
    end;

    return nil;
end;

local function showMarketplaceError(p97) -- Line: 566
    -- upvalues: getMarketplaceErrorMessage (copy), Router (copy)
    local v98 = getMarketplaceErrorMessage(p97);

    if not v98 then
        return false;
    end;

    Router.broadcastRouter("CreateNotification", "Error", v98);

    return true;
end;

local function openTradeTokensStoreFromMarketplace(u99: number) -- Line: 576
    -- upvalues: ReplicatedStorage (copy), MenuState (copy), Store (copy)
    task.spawn(function() -- Line: 577
        -- upvalues: ReplicatedStorage (ref), MenuState (ref), Store (ref), u99 (copy)
        local Error = ReplicatedStorage.Assets.Sounds:FindFirstChild("Error");

        if Error and Error:IsA("Sound") then
            Error:Play();
        end;

        task.wait(0.1);
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Store");

        if MenuState.GetCurrentScreen() == "Store" then
            Store.OpenTab("TradeTokens");
        end;

        task.wait(0.3);
        Store.PromptTradeTokenPackageForItemPrice(u99);
    end);
end;

local function hideQuickPick() -- Line: 590
    -- upvalues: u10 (ref), u36 (ref)
    u10 = nil;
    u36.Market.Header.Guns.Visible = false;

    for _, child in u36.Market.Header.Filters:GetChildren() do
        if child:IsA("TextButton") then
            child.ImageLabel.Rotation = 0;
        end;
    end;
end;

local function closeSellPopups() -- Line: 601
    -- upvalues: u36 (ref), u42 (ref)
    u36.Sell.Confirm.Visible = false;

    if u42 then
        u42:Destroy();
    end;
end;

local function switchTab(p100: string) -- Line: 608
    -- upvalues: u20 (copy), u36 (ref), hideQuickPick (copy), u42 (ref)
    for _, v in u20 do
        u36[v].Visible = v == p100;
    end;

    if p100 ~= "Market" then
        hideQuickPick();
    end;

    if p100 ~= "Sell" then
        u36.Sell.Confirm.Visible = false;

        if u42 then
            u42:Destroy();
        end;
    end;
end;

local function destroyListingCard(p101: userdata) -- Line: 624
    -- upvalues: MenuState (copy), GamepadNavigation (copy), GuiService (copy), u36 (ref)
    local v102 = MenuState.IsSelectionWithin(p101) and GamepadNavigation.IsUsable(GuiService.SelectedObject);
    local v103;

    if p101:IsA("GuiObject") then
        v103 = p101.AbsolutePosition + p101.AbsoluteSize / 2;
    else
        v103 = nil;
    end;

    p101:Destroy();

    if not v102 then
        return;
    end;

    local Container = u36.Market.Container;
    local v104 = nil;
    local v105 = (1 / 0);

    if v103 then
        for _, descendant in Container:GetDescendants() do
            if descendant:IsA("GuiObject") and GamepadNavigation.IsUsable(descendant) then
                local Magnitude = (descendant.AbsolutePosition + descendant.AbsoluteSize / 2 - v103).Magnitude;

                if Magnitude < v105 then
                    v104 = descendant;
                    v105 = Magnitude;
                end;
            end;
        end;
    end;

    if v104 and GamepadNavigation.Focus(v104) then
        return;
    end;

    if not GamepadNavigation.Focus(Container) then
        GamepadNavigation.Focus(u36.Top.Frame:FindFirstChild("Market"));
    end;
end;

local function roundToDecimals(p106: number) -- Line: 653
    return math.floor(p106 * 1000000 + 0.5) / 1000000;
end;

local function deepCopy(p107) -- Line: 658
    -- upvalues: deepCopy (copy)
    if type(p107) ~= "table" then
        return p107;
    end;

    local v108 = {};

    for i, v in p107 do
        v108[i] = deepCopy(v);
    end;

    return v108;
end;

local function getPriceSliderSegments(p109: number) -- Line: 670
    -- upvalues: u3 (copy)
    if p109 <= 1 then
        return {
            {
                scale = 1,
                value = p109
            }
        };
    end;

    local v110 = {};

    for _, v in u3 do
        local math_floor_ret = math.floor(p109 * v.valueRatio + 0.5);
        local math_max_ret = math.max(1, math_floor_ret);
        local math_min_ret = math.min(math_max_ret, p109);

        if #v110 == 0 or v110[#v110].value < math_min_ret then
            table.insert(v110, {
                scale = v.scale,
                value = math_min_ret
            });
        end;

        if p109 <= math_min_ret then
            break;
        end;
    end;

    if v110[#v110].value < p109 then
        table.insert(v110, {
            scale = 1,
            value = p109
        });
    end;

    return v110;
end;

local function sliderScaleToValue(p111: number, p112: number) -- Line: 696
    -- upvalues: getPriceSliderSegments (copy)
    if p112 <= 1 then
        return p111 * p112;
    end;

    local math_clamp_ret = math.clamp(p111, 0, 1);
    local v113 = 0;
    local v114 = 0;

    for _, v in getPriceSliderSegments(p112) do
        if math_clamp_ret <= v.scale or v.scale >= 1 then
            local v115 = v.scale - v113;

            if v115 == 0 then
                return v.value;
            end;

            return math.floor(v114 + (v.value - v114) * ((math_clamp_ret - v113) / v115) + 0.5);
        end;

        v113 = v.scale;
        v114 = v.value;
    end;

    return p112;
end;

local function sliderValueToScale(p116: number, p117: number) -- Line: 718
    -- upvalues: getPriceSliderSegments (copy)
    if p117 <= 1 then
        return p116 / p117;
    end;

    local math_clamp_ret = math.clamp(p116, 0, p117);
    local v118 = 0;
    local v119 = 0;

    for _, v in getPriceSliderSegments(p117) do
        if v.value <= v118 then
            v119 = v.scale;
            v118 = v.value;
        else
            if math_clamp_ret <= v.value or v.scale >= 1 then
                return v119 + (v.scale - v119) * (math_clamp_ret - v118) / (v.value - v118);
            end;

            v119 = v.scale;
            v118 = v.value;
        end;
    end;

    return 1;
end;

local function setDrag(p120: any, p121: number, p122: string, p123: number) -- Line: 740
    -- upvalues: u8 (copy), sliderValueToScale (copy), sliderScaleToValue (copy), CollectionService (copy), CommaNumber (copy), u18 (ref), u19 (ref)
    local v124 = tonumber(p121);

    if not v124 then
        return;
    end;

    local Name = p120.Name;
    local v125 = u8[Name];

    if type(v125) ~= "table" then
        return;
    end;

    local math_clamp_ret = math.clamp(v124, p122 == "StartPin" and 0 or v125[1], p122 == "EndPin" and p123 and p123 or v125[2]);
    p120.Slider[p122].Position = UDim2.fromScale(sliderValueToScale(math_clamp_ret, p123), 1.2);
    u8[Name] = { sliderScaleToValue(p120.Slider.StartPin.Position.X.Scale, p123), (sliderScaleToValue(p120.Slider.EndPin.Position.X.Scale, p123)) };
    local v126 = u8[Name];

    for _, v in CollectionService:GetTagged(Name) do
        local Slider = v:FindFirstChild("Slider");
        local Content2 = v:FindFirstChild("Content");

        if Slider and Content2 then
            local Inputs = Content2:FindFirstChild("Inputs");

            if Inputs then
                local StartPin = Slider:FindFirstChild("StartPin");
                local EndPin = Slider:FindFirstChild("EndPin");
                local v127 = Slider:FindFirstChild(p122);
                local StartPin2 = Inputs:FindFirstChild("StartPin");
                local EndPin2 = Inputs:FindFirstChild("EndPin");

                if v127 and (StartPin and (EndPin and (StartPin2 and EndPin2))) then
                    v127.Position = p120.Slider[p122].Position;
                    StartPin2.TextBox.Text = p123 > 1 and CommaNumber((math.floor(v126[1]))) or math.floor(v126[1] * 1000000 + 0.5) / 1000000;
                    EndPin2.TextBox.Text = p123 > 1 and CommaNumber((math.floor(v126[2]))) or math.floor(v126[2] * 1000000 + 0.5) / 1000000;
                    local Span = Slider:FindFirstChild("Span");

                    if Span then
                        local Scale = StartPin.Position.X.Scale;
                        local Scale2 = EndPin.Position.X.Scale;
                        Span.Position = UDim2.new(Scale, 0, Span.Position.Y.Scale, Span.Position.Y.Offset);
                        Span.Size = UDim2.new(math.max(Scale2 - Scale, 0), 0, Span.Size.Y.Scale, Span.Size.Y.Offset);
                    end;
                end;
            end;
        end;
    end;

    if Name == "wear_range" and not u18 then
        u19();
    end;
end;

local function getWearTierMin(p128: number) -- Line: 801
    -- upvalues: u15 (copy)
    return p128 == 1 and 0 or u15[p128 - 1].max;
end;

local function isFullWearRange(p129: number, p130: number) -- Line: 805
    local v131;

    if p129 <= 1e-9 then
        v131 = p130 >= 0.999999999;
    else
        v131 = false;
    end;

    return v131;
end;

local function setWearTierVisual(p132: string, p133: boolean) -- Line: 809
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged("wear_range") do
        local v134 = v.List:FindFirstChild(p132);

        if v134 and v134:FindFirstChild("Button") then
            local ImageLabel = v134.Button:FindFirstChild("ImageLabel");

            if ImageLabel then
                ImageLabel.Visible = p133;
            end;
        end;
    end;
end;

local function setWearRange(p135: number, p136: number) -- Line: 821
    -- upvalues: u36 (ref), u18 (ref), u8 (copy), setDrag (copy)
    if not u36 then
        return;
    end;

    local wear_range = u36.Market.Filters.Container:FindFirstChild("wear_range");

    if not wear_range then
        return;
    end;

    u18 = true;
    u8.wear_range = { p135, p136 };
    setDrag(wear_range, p135, "StartPin", 1);
    setDrag(wear_range, p136, "EndPin", 1);
    u18 = false;
end;

u19 = function() -- Line: 838
    -- upvalues: u8 (copy), u15 (copy), u17 (copy), setWearTierVisual (copy)
    local v137 = u8.wear_range[1];
    local v138 = u8.wear_range[2];
    local v139;

    if v137 <= 1e-9 then
        v139 = v138 >= 0.999999999;
    else
        v139 = false;
    end;

    if v139 then
        for _, v in u15 do
            u17[v.key] = false;
            setWearTierVisual(v.key, false);
        end;

        return;
    end;

    for i, v in u15 do
        local max = v.max;
        local v140;

        if v137 <= (i == 1 and 0 or u15[i - 1].max) + 1e-9 then
            v140 = max - 1e-9 <= v138;
        else
            v140 = false;
        end;

        u17[v.key] = v140;
        setWearTierVisual(v.key, v140);
    end;
end;

local function getWearSearchRangeFromSelection() -- Line: 858
    -- upvalues: u15 (copy), u17 (copy)
    local v141 = 1;
    local v142 = 0;
    local v143 = false;

    for i, v in u15 do
        if u17[v.key] then
            v141 = math.min(v141, i == 1 and 0 or u15[i - 1].max);
            v142 = math.max(v142, v.max);
            v143 = true;
        end;
    end;

    if not v143 then
        return { 0, 1 };
    end;

    if v142 < 1 then
        v142 = v142 - 1e-12;
    end;

    return { v141, v142 };
end;

local function refreshWearRangeInSearchPayload() -- Line: 882
    -- upvalues: u8 (copy), getWearSearchRangeFromSelection (copy)
    u8.wear_range = getWearSearchRangeFromSelection();
end;

local function anyWearTiersSelected() -- Line: 886
    -- upvalues: u15 (copy), u17 (copy)
    for _, v in u15 do
        if u17[v.key] then
            return true;
        end;
    end;

    return false;
end;

local function wearNameMatchesSelectedTiers(p144: string) -- Line: 895
    -- upvalues: u15 (copy), u17 (copy)
    for _, v in u15 do
        if u17[v.key] and v.wear == p144 then
            return true;
        end;
    end;

    return false;
end;

local function listingFrameMatchesSelectedWearTiers(p145: userdata) -- Line: 904
    -- upvalues: u15 (copy), u17 (copy)
    local v146 = false;

    for _, v in u15 do
        if u17[v.key] then
            v146 = true;
            break;
        end;
    end;

    if not v146 then
        return true;
    end;

    local Attribute = p145:GetAttribute("Wear");
    local v147;

    if typeof(Attribute) == "string" then
        for _, v in u15 do
            if u17[v.key] and v.wear == Attribute then
                return true;
            end;
        end;

        v147 = false;
    else
        v147 = false;
    end;

    return v147;
end;

local function listingMatchesSelectedWearTiers(p148: table) -- Line: 913
    -- upvalues: u15 (copy), u17 (copy), Skins (copy)
    local v149 = false;

    for _, v in u15 do
        if u17[v.key] then
            v149 = true;
            break;
        end;
    end;

    if not v149 then
        return true;
    end;

    local inventoryItem = p148.inventoryItem;

    if not inventoryItem or inventoryItem.Float == nil then
        return false;
    end;

    local SkinInformation = Skins.GetSkinInformation(inventoryItem.Name, inventoryItem.Skin);

    if not SkinInformation then
        return false;
    end;

    local WearNameForFloat = Skins.GetWearNameForFloat(SkinInformation, inventoryItem.Float);

    if not WearNameForFloat then
        return false;
    end;

    for _, v in u15 do
        if u17[v.key] and v.wear == WearNameForFloat then
            return true;
        end;
    end;

    return false;
end;

local function syncWearRangeFromTierSelection() -- Line: 936
    -- upvalues: getWearSearchRangeFromSelection (copy), setWearRange (copy)
    local v150 = getWearSearchRangeFromSelection();
    local v151 = v150[2];

    if v151 < 1 then
        v151 = v151 + 1e-12;
    end;

    setWearRange(v150[1], v151);
end;

local function toggleWearTier(p152: string) -- Line: 946
    -- upvalues: u17 (copy), setWearTierVisual (copy), getWearSearchRangeFromSelection (copy), setWearRange (copy), u16 (ref)
    u17[p152] = not u17[p152];
    setWearTierVisual(p152, u17[p152]);
    local v153 = getWearSearchRangeFromSelection();
    local v154 = v153[2];

    if v154 < 1 then
        v154 = v154 + 1e-12;
    end;

    setWearRange(v153[1], v154);
    u16();
end;

local function setupWearTierButtons() -- Line: 953
    -- upvalues: u15 (copy), u17 (copy), setWearTierVisual (copy), CollectionService (copy), MarketplaceButton (copy), getWearSearchRangeFromSelection (copy), setWearRange (copy), u16 (ref)
    for _, v in u15 do
        u17[v.key] = false;
        setWearTierVisual(v.key, false);
        local u155 = v;

        for _, v2 in CollectionService:GetTagged("wear_range") do
            local v156 = v2.List:FindFirstChild(u155.key);

            if v156 and v156:FindFirstChild("Button") then
                MarketplaceButton.new(v156.Button, {
                    hoverSizeMultiplier = 0.9,

                    onActivated = function() -- Line: 964, Name: onActivated
                        -- upvalues: u155 (copy), u17 (ref), setWearTierVisual (ref), getWearSearchRangeFromSelection (ref), setWearRange (ref), u16 (ref)
                        local key = u155.key;
                        u17[key] = not u17[key];
                        setWearTierVisual(key, u17[key]);
                        local v157 = getWearSearchRangeFromSelection();
                        local v158 = v157[2];

                        if v158 < 1 then
                            v158 = v158 + 1e-12;
                        end;

                        setWearRange(v157[1], v158);
                        u16();
                    end
                });
            end;
        end;
    end;
end;

local function dragSlider(p159: any, p160: userdata, p161: number, p162: userdata) -- Line: 973
    -- upvalues: UserInputService (copy), GuiInset (copy), setDrag (copy), sliderScaleToValue (copy), RunService (copy)
    while true do
        local v163;

        if p162.UserInputType == Enum.UserInputType.Touch then
            v163 = Vector2.new(p162.Position.X, p162.Position.Y);
        else
            v163 = UserInputService:GetMouseLocation();
        end;

        local math_clamp_ret = math.clamp(((v163 - GuiInset).X - p159.AbsolutePosition.X) / p159.AbsoluteSize.X, 0, 1);
        local math_clamp_ret2 = math.clamp(math_clamp_ret, p160.Name ~= "EndPin" and 0 or p159.StartPin.Position.X.Scale, p160.Name ~= "StartPin" and 1 or p159.EndPin.Position.X.Scale);
        setDrag(p159.Parent, sliderScaleToValue(math_clamp_ret2, p161), p160.Name, p161);
        RunService.RenderStepped:Wait();

        if p162.UserInputState == Enum.UserInputState.End or p162.UserInputState == Enum.UserInputState.Cancel then
            return;
        end;
    end;
end;

local u164 = {};
local u165 = 0;
local u166 = 0;

local function nudgeSliderPin(p167: userdata, p168: number) -- Line: 1004
    -- upvalues: u164 (copy), sliderScaleToValue (copy), setDrag (copy)
    local v169 = u164[p167];

    if not v169 then
        return;
    end;

    local maxValue = v169.maxValue;
    local Scale = p167.Position.X.Scale;
    local v170;

    if maxValue <= 1 then
        local v171 = sliderScaleToValue(Scale, maxValue) + p168 * 0.01;
        v170 = math.clamp(v171, 0, maxValue);
    elseif maxValue <= 20 then
        local v172 = sliderScaleToValue(Scale, maxValue) + 0.5;
        local v173 = math.floor(v172) + p168;
        v170 = math.clamp(v173, 0, maxValue);
    else
        v170 = sliderScaleToValue(math.clamp(Scale + p168 * 0.01, 0, 1), maxValue);
    end;

    setDrag(v169.fill.Parent, v170, p167.Name, maxValue);
end;

local function startSliderNudge(u174: number, u175: function) -- Line: 1027
    -- upvalues: GuiService (copy), u164 (copy), u165 (ref), nudgeSliderPin (copy), GamepadNavigation (copy)
    local SelectedObject = GuiService.SelectedObject;

    if not (SelectedObject and u164[SelectedObject]) then
        return;
    end;

    u165 = u165 + 1;
    local u176 = u165;
    nudgeSliderPin(SelectedObject, u174);
    task.delay(0.35, function() -- Line: 1037
        -- upvalues: u176 (copy), u165 (ref), u175 (copy), GuiService (ref), SelectedObject (copy), GamepadNavigation (ref), nudgeSliderPin (ref), u174 (copy)
        while u176 == u165 and (u175() and (GuiService.SelectedObject == SelectedObject and GamepadNavigation.IsUsable(SelectedObject))) do
            nudgeSliderPin(SelectedObject, u174);
            task.wait(0.05);
        end;
    end);
end;

UserInputService.InputBegan:Connect(function(p177: userdata) -- Line: 1051
    -- upvalues: startSliderNudge (copy), UserInputService (copy)
    local KeyCode = p177.KeyCode;

    if KeyCode ~= Enum.KeyCode.DPadLeft and KeyCode ~= Enum.KeyCode.DPadRight then
        return;
    end;

    local UserInputType = p177.UserInputType;
    startSliderNudge(KeyCode == Enum.KeyCode.DPadLeft and -1 or 1, function() -- Line: 1058
        -- upvalues: UserInputService (ref), UserInputType (copy), KeyCode (copy)
        return UserInputService:IsGamepadButtonDown(UserInputType, KeyCode);
    end);
end);
UserInputService.InputChanged:Connect(function(p178: userdata) -- Line: 1063
    -- upvalues: u166 (ref), startSliderNudge (copy)
    if p178.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return;
    end;

    local X = p178.Position.X;
    local u179 = X > 0.6 and 1 or (X < -0.6 and -1 or 0);

    if u179 == u166 then
        return;
    end;

    u166 = u179;

    if u179 ~= 0 then
        startSliderNudge(u179, function() -- Line: 1079
            -- upvalues: u166 (ref), u179 (copy)
            return u166 == u179;
        end);
    end;
end);
UserInputService.InputEnded:Connect(function(p180: userdata) -- Line: 1087
    -- upvalues: u166 (ref)
    if p180.KeyCode == Enum.KeyCode.Thumbstick1 then
        u166 = 0;
    end;
end);
UserInputService.GamepadDisconnected:Connect(function() -- Line: 1093
    -- upvalues: u166 (ref), u165 (ref)
    u166 = 0;
    u165 = u165 + 1;
end);

local function bindSliderPin(u181: any, u182: userdata, u183: number) -- Line: 1098
    -- upvalues: MarketplaceButton (copy), u164 (copy), dragSlider (copy)
    MarketplaceButton.new(u182, {
        hoverSizeMultiplier = 0.9
    });
    u164[u182] = {
        fill = u181,
        maxValue = u183
    };
    u182.NextSelectionLeft = u182;
    u182.NextSelectionRight = u182;
    u182.InputBegan:Connect(function(p184: userdata) -- Line: 1103
        -- upvalues: dragSlider (ref), u181 (copy), u182 (copy), u183 (copy)
        if p184.UserInputType ~= Enum.UserInputType.MouseButton1 and p184.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        dragSlider(u181, u182, u183, p184);
    end);
end;

local function createMarketListing(p185: userdata, p186: string, p187: any, u188: table, p189: number?) -- Line: 1115
    -- upvalues: Skins (copy), GetWeaponProperties (copy), getRarityData (copy), GetSkinDisplayName (copy), CommaNumber (copy), UserCache (copy), MarketPlacePrices (copy), MarketplaceButton (copy), u36 (ref), showInspect (copy), MarketplaceHover (copy), UserInputService (copy)
    if type(p186) ~= "string" then
        return;
    end;

    if not p187 then
        return;
    end;

    local v190 = p185:FindFirstChild(p186);

    if v190 then
        return v190;
    end;

    if not (u188 and u188.inventoryItem) then
        return;
    end;

    local SkinInformation = Skins.GetSkinInformation(u188.inventoryItem.Name, u188.inventoryItem.Skin);

    if SkinInformation then
        local v191 = GetWeaponProperties(u188.inventoryItem.Name);
        local v192;

        if v191 then
            v192 = v191.Type;
        else
            v192 = u188.inventoryItem.Type;
        end;

        local WearNameForFloat, v193 = Skins.GetWearNameForFloat(SkinInformation, u188.inventoryItem.Float);
        local AbbreviatedWearName = Skins.GetAbbreviatedWearName(v193);
        local v194 = getRarityData(SkinInformation.rarity);
        local v195 = u188.inventoryItem.StatTrack and true or false;
        local FullItemDisplayName = GetSkinDisplayName.GetFullItemDisplayName(u188.inventoryItem.Name, u188.inventoryItem.Skin, v195, true, u188.inventoryItem.NameTag);
        local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(u188.inventoryItem.Name, u188.inventoryItem.NameTag);
        local u196 = p187:Clone();
        u196.Name = p186;
        u196.Main.ItemIcon.Image = Skins.GetItemIconImage(SkinInformation, u188.inventoryItem);
        GetSkinDisplayName.ApplyNameLabel(u196.Main.Skin, FullItemDisplayName, u188.inventoryItem.NameTag);
        u196.Main.Status.Text = v193 or "";
        u196.Main.FloatNumber.Text = u188.inventoryItem.Float;
        u196.Main.FloatBar.Frame.Position = UDim2.fromScale(u188.inventoryItem.Float, 0.5);
        u196.Main.RarityFrame.Serial.SerialText.Text = `#{CommaNumber(u188.inventoryItem.Serial)}`;

        if u188.inventoryItem.MetaData then
            for i, v in u188.inventoryItem.MetaData do
                if type(v) ~= "table" then
                    u196:SetAttribute(i, v);
                end;
            end;
        end;

        u196:SetAttribute("Gun", WeaponDisplayName);
        u196:SetAttribute("InternalGun", u188.inventoryItem.Name);
        u196:SetAttribute("Skin", u188.inventoryItem.Skin);
        u196:SetAttribute("InventoryItemId", u188.inventoryItem._id);
        u196:SetAttribute("Wear", WearNameForFloat);
        u196:SetAttribute("Type", v192);
        u196:SetAttribute("OtherType", SkinInformation.type);
        u196:SetAttribute("Float", u188.inventoryItem.Float);
        u196:SetAttribute("Collection", SkinInformation.collection);
        local Seller = u196.Main.Seller;
        local Owner = u188.inventoryItem.MetaData.Owner;
        Seller.Text = "Seller: ...";
        task.spawn(function() -- Line: 337
            -- upvalues: UserCache (ref), Owner (copy), Seller (copy)
            local success, result = pcall(UserCache.Fetch, Owner);
            local v197 = not (success and (result and result.Username)) and "Unknown User" or result.Username;

            if Seller.Parent then
                Seller.Text = `Seller: {v197}`;
            end;
        end);

        if u196.Main:FindFirstChild("RAP") and SkinInformation.paintId then
            local ItemPrice = MarketPlacePrices.GetItemPrice(u188.inventoryItem.Name, u188.inventoryItem.Skin, u188.inventoryItem.Float, v195);

            if ItemPrice then
                ItemPrice = ItemPrice.recentAveragePriceTradeTokens;
            end;

            local v198;

            if ItemPrice and ItemPrice > 0 then
                v198 = math.floor(ItemPrice);
            else
                v198 = nil;
            end;

            u196.Main.RAP.TextLabel.Text = `RAP: {not v198 and "N/A" or CommaNumber(v198)}`;
            u196:SetAttribute("RAP", v198 or 0);
        end;

        local MarketPlaceItem = MarketPlacePrices.GetMarketPlaceItem(u188.inventoryItem.Name, u188.inventoryItem.Skin);

        if MarketPlaceItem and u196.Main:FindFirstChild("Projected") then
            local v199;

            if v195 then
                v199 = MarketPlaceItem.statTrack;
            else
                v199 = MarketPlaceItem.standard;
            end;

            local v200 = v199[WearNameForFloat] or v199.Default;
            local v201;

            if v200 == nil then
                v201 = false;
            else
                v201 = v200.projected;
            end;

            u196.Main.Projected.Visible = v201;
            u196.Main.Projected.MouseEnter:Connect(function() -- Line: 1202
                -- upvalues: u196 (copy)
                u196.Main.Projected.Display.Visible = true;
            end);
            u196.Main.Projected.MouseLeave:Connect(function() -- Line: 1206
                -- upvalues: u196 (copy)
                u196.Main.Projected.Display.Visible = false;
            end);
            u196.Main.Projected.SelectionGained:Connect(function() -- Line: 1211
                -- upvalues: u196 (copy)
                u196.Main.Projected.Display.Visible = true;
            end);
            u196.Main.Projected.SelectionLost:Connect(function() -- Line: 1215
                -- upvalues: u196 (copy)
                u196.Main.Projected.Display.Visible = false;
            end);
        end;

        local Type = u188.inventoryItem.Type;
        local v202;

        if Type == "Case" or (Type == "Charm Capsule" or Type == "Sticker Capsule") then
            v202 = false;
        else
            v202 = Type ~= "Package";
        end;

        if not v202 then
            u196.Main.FloatNumber.Visible = false;
            u196.Main.FloatBar.Visible = false;
        end;

        if u196.Main.ItemIcon:FindFirstChild("Worth") and SkinInformation.paintId then
            local SerialText = u196.Main.ItemIcon.Worth.SerialText;
            local ItemPrice = MarketPlacePrices.GetItemPrice(u188.inventoryItem.Name, u188.inventoryItem.Skin, u188.inventoryItem.Float, v195);

            if ItemPrice then
                ItemPrice = ItemPrice.recentAveragePriceTradeTokens;
            end;

            local v203;

            if ItemPrice and ItemPrice > 0 then
                v203 = math.floor(ItemPrice);
            else
                v203 = nil;
            end;

            SerialText.Text = `RAP: {not v203 and "N/A" or CommaNumber(v203)}`;
        end;

        if v194 and v194.ColorSequence then
            u196.Main.RarityFrame.RarityBarGradient.Color = v194.ColorSequence;
            u196.Main.RarityBG.RarityBarGradient.Color = v194.ColorSequence;
        end;

        u196.Main.RarityFrame.Condition.Tag.Text = AbbreviatedWearName;
        u196.Main.RarityFrame.Condition[`{AbbreviatedWearName}Gradient`].Enabled = true;
        u196.Main.Credits.Visible = u188.priceTradeTokens ~= nil;
        u196.Main.Credits.TextLabel.Text = not u188.priceTradeTokens and "" or CommaNumber(u188.priceTradeTokens);

        if p189 ~= nil then
            u196.LayoutOrder = p189;
        end;

        u196.Parent = p185;
        local v204 = u196:FindFirstChild("Main") and u196.Main:FindFirstChild("Tools");
        local v205;

        if v204 then
            v205 = v204:FindFirstChild("Inspect") or nil;
        else
            v205 = nil;
        end;

        if v205 then
            MarketplaceButton.new(v205, {
                hoverSizeMultiplier = 0.9,

                onActivated = function() -- Line: 1251, Name: onActivated
                    -- upvalues: u36 (ref), showInspect (ref), u188 (copy)
                    if u36.Market.PurchaseMenu.Visible then
                        return;
                    end;

                    showInspect(u188.inventoryItem);
                end
            });
            local Type2 = u188.inventoryItem.Type;

            if Type2 == "Case" and true or Type2 == "Package" then
                v205.Visible = false;
            end;
        end;

        local v206 = v204 and v204:FindFirstChild("UserDescription") or nil;

        if v206 then
            MarketplaceButton.new(v206, {
                hoverSizeMultiplier = 0.9,

                onActivated = function() -- Line: 1268, Name: onActivated
                    -- upvalues: u36 (ref), MarketplaceHover (ref), u188 (copy), u196 (copy)
                    if not u36.Market.PurchaseMenu.Visible then
                        MarketplaceHover:OpenTradeInfo(u188.inventoryItem, u196);
                    end;
                end
            });

            if not UserInputService.TouchEnabled then
                v206.MouseEnter:Connect(function() -- Line: 1276
                    -- upvalues: MarketplaceHover (ref), u188 (copy), u196 (copy)
                    MarketplaceHover:Open(u188.inventoryItem, u196);
                end);
                v206.MouseLeave:Connect(function() -- Line: 1279
                    -- upvalues: MarketplaceHover (ref), u196 (copy)
                    MarketplaceHover:Close(u196);
                end);
            end;
        end;

        return u196;
    end;
end;

local function removeYourListingByInventoryItemId(p207: string) -- Line: 1288
    -- upvalues: u36 (ref)
    for _, child in u36.Profile.Main.Frame.YourListings.YourListings:GetChildren() do
        if child:IsA("Frame") and child:GetAttribute("InventoryItemId") == p207 then
            child:Destroy();

            return;
        end;
    end;
end;

local function addYourListing(p208: table) -- Line: 1298
    -- upvalues: u37 (ref), Skins (copy), u36 (ref), createMarketListing (copy), CommaNumber (copy), LocalPlayer (copy), MarketplaceButton (copy), u43 (ref), GlobalMarketplace (copy)
    if not (p208.inventoryItem and (p208.listing_reference_id and u37)) then
        return;
    end;

    if not Skins.HasSkinTextures(p208.inventoryItem.Name, p208.inventoryItem.Skin) then
        return;
    end;

    local YourListings = u36.Profile.Main.Frame.YourListings.YourListings;

    if YourListings:FindFirstChild(p208.listing_reference_id) then
        return;
    end;

    local u209 = createMarketListing(YourListings, p208.listing_reference_id, u37, p208);

    if u209 then
        local v210 = p208.priceTradeTokens or p208.tradeTokens;
        u209.Main.Credits.TextLabel.Text = not v210 and "N/A" or CommaNumber(v210);
        u209.Main.Credits.Visible = true;
        u209.Main.Delist.Visible = true;
        u209.Main.Delist.Visible = p208.inventoryItem.MetaData.Owner == LocalPlayer.UserId;
        local _id = p208.inventoryItem._id;
        MarketplaceButton.new(u209.Main.Delist, {
            hoverSizeMultiplier = 0.9,

            onActivated = function() -- Line: 1326, Name: onActivated
                -- upvalues: u36 (ref), u43 (ref), GlobalMarketplace (ref), _id (copy), u209 (copy)
                u36.Parent.Parent.Loading.Visible = true;
                u43:Play();
                GlobalMarketplace.DelistItem.Send(_id);
                u209:Destroy();
                local v211 = u36.Sell.Container:FindFirstChild(_id);

                if v211 then
                    v211.Visible = true;
                    v211.Main.Sell.Visible = true;
                    v211.Main.Delist.Visible = false;
                end;
            end
        });

        return u209;
    end;
end;

local function getInventoryItemById(p212: string) -- Line: 1343
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v213 = DataController.Get(LocalPlayer, "Inventory");

    if not v213 then
        return nil;
    end;

    for _, v in v213 do
        if v._id == p212 then
            return v;
        end;
    end;

    return nil;
end;

local function withListingReference(p214: any, p215: string) -- Line: 1358
    if p214.MetaData and p214.MetaData.GlobalMarketPlaceListingReference == p215 then
        return p214;
    end;

    local table_clone_ret = table.clone(p214);
    table_clone_ret.MetaData = table.clone(p214.MetaData or {});
    table_clone_ret.MetaData.GlobalMarketPlaceListingReference = p215;

    return table_clone_ret;
end;

local function syncListedItemToProfile(p216) -- Line: 1369
    -- upvalues: u14 (copy), DataController (copy), LocalPlayer (copy), addYourListing (copy), withListingReference (copy)
    local v217 = p216.inventoryItemId or p216.inventory_item_id;

    if typeof(v217) ~= "string" then
        return false;
    end;

    local v218 = u14[v217];
    local v219 = p216.listing_reference_id or p216.listingReferenceId;

    if not v219 then
        if v218 then
            v219 = v218.listingReferenceId;
        else
            v219 = v218;
        end;
    end;

    local inventoryItem = p216.inventoryItem;

    if not inventoryItem then
        inventoryItem = v218 and v218.inventoryItem;

        if not inventoryItem then
            local v220 = DataController.Get(LocalPlayer, "Inventory");

            if v220 then
                inventoryItem = nil;

                for _, v in v220 do
                    if v._id == v217 then
                        inventoryItem = v;
                        break;
                    end;
                end;
            else
                inventoryItem = nil;
            end;
        end;
    end;

    if inventoryItem and (not v219 and inventoryItem.MetaData) then
        v219 = inventoryItem.MetaData.GlobalMarketPlaceListingReference;
    end;

    if typeof(inventoryItem) ~= "table" or (typeof(v219) ~= "string" or v219 == "") then
        return false;
    end;

    local v221 = p216.priceTradeTokens or p216.price_trade_tokens;

    if v221 then
        v218 = v221;
    elseif v218 then
        v218 = v218.Price;
    end;

    return addYourListing({
        listing_reference_id = v219,
        priceTradeTokens = v218,
        tradeTokens = v218 or 0,
        date = os.time(),
        inventoryItem = withListingReference(inventoryItem, v219)
    }) ~= nil;
end;

local function setupMarket() -- Line: 1402
    -- upvalues: u37 (ref), u36 (ref), MarketplaceButton (copy), openTradeTokensStore (copy), u44 (ref), TweenService (copy), u22 (ref), AssetService (copy), CommaNumber (copy), formatSaleDate (copy), UserInputService (copy), GuiService (copy), UserCache (copy), Players (copy), hideQuickPick (copy), u24 (ref), GlobalMarketplace (copy), u40 (ref), showInspect (copy), deepCopy (copy), Skins (copy), u39 (ref), Router (copy), getMarketplaceErrorMessage (copy), u6 (ref), table_freeze_ret2 (copy), DataController (copy), LocalPlayer (copy), ReplicatedStorage (copy), MenuState (copy), Store (copy), u43 (ref), CloseButtonRegistry (copy), GamepadNavigation (copy), CollectionServiceUtility (copy), GetSkinDisplayName (copy), FuzzySearch (copy), u15 (copy), u17 (copy), u16 (ref), u26 (ref), u13 (ref), u12 (ref), u8 (copy), listingMatchesSelectedWearTiers (copy), createMarketListing (copy), removeYourListingByInventoryItemId (copy), destroyListingCard (copy), addYourListing (copy), pruneOldestListingFrames (copy), getWearSearchRangeFromSelection (copy), u33 (ref), bindSliderPin (copy), setDrag (copy), CollectionService (copy), Constants (copy), u2 (copy), setupWearTierButtons (copy), u30 (ref), schedulePredictSearch (copy), u7 (ref), MarketplaceDropdown (copy)
    u37 = u36.Market.Container.Template:Clone();
    u36.Market.Container.Template:Destroy();
    MarketplaceButton.new(u36.Top.TradeTokens.PurchaseMore, {
        hoverSizeMultiplier = 0.9,
        onActivated = openTradeTokensStore
    });
    local u222 = nil;
    local Main = u36.Market.PurchaseMenu.Main;

    local function clearPurchaseMenuTransactions() -- Line: 1415
        -- upvalues: Main (copy)
        for _, child in Main.Main.Transactions.Listings:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        for _, child in Main.Main.Similar.Listings:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;
    end;

    u44 = TweenService:Create(Main.Main.SalesGraph.Loading, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, (1 / 0)), {
        Rotation = 359
    });
    Main.Main.Template.Projected.MouseEnter:Connect(function() -- Line: 1437
        -- upvalues: Main (copy)
        Main.Main.Template.Projected.Display.Visible = true;
    end);
    Main.Main.Template.Projected.MouseLeave:Connect(function() -- Line: 1441
        -- upvalues: Main (copy)
        Main.Main.Template.Projected.Display.Visible = false;
    end);
    Main.Main.Template.Projected.SelectionGained:Connect(function() -- Line: 1445
        -- upvalues: Main (copy)
        Main.Main.Template.Projected.Display.Visible = true;
    end);
    Main.Main.Template.Projected.SelectionLost:Connect(function() -- Line: 1449
        -- upvalues: Main (copy)
        Main.Main.Template.Projected.Display.Visible = false;
    end);

    local function getSalesGraphDotted() -- Line: 1453
        -- upvalues: Main (copy)
        local SalesGraph = Main.Main.SalesGraph;
        local Dotted = SalesGraph:FindFirstChild("Dotted");

        if Dotted and Dotted:IsA("GuiObject") then
            return Dotted;
        end;

        local Dotted2 = SalesGraph.GraphVisual:FindFirstChild("Dotted");

        if Dotted2 and Dotted2:IsA("GuiObject") then
            return Dotted2;
        end;

        return nil;
    end;

    local function hideSalesGraphHover() -- Line: 1466
        -- upvalues: Main (copy)
        local SaleInfo = Main.Main.SalesGraph:FindFirstChild("SaleInfo");

        if SaleInfo and SaleInfo:IsA("GuiObject") then
            SaleInfo.Visible = false;
        end;

        local SalesGraph = Main.Main.SalesGraph;
        local Dotted = SalesGraph:FindFirstChild("Dotted");

        if not (Dotted and Dotted:IsA("GuiObject")) then
            Dotted = SalesGraph.GraphVisual:FindFirstChild("Dotted");

            if not (Dotted and Dotted:IsA("GuiObject")) then
                Dotted = nil;
            end;
        end;

        if Dotted then
            Dotted.Visible = false;
        end;
    end;

    local function clearGraphVisual() -- Line: 1477
        -- upvalues: Main (copy)
        local SaleInfo = Main.Main.SalesGraph:FindFirstChild("SaleInfo");

        if SaleInfo and SaleInfo:IsA("GuiObject") then
            SaleInfo.Visible = false;
        end;

        local SalesGraph = Main.Main.SalesGraph;
        local Dotted = SalesGraph:FindFirstChild("Dotted");

        if not (Dotted and Dotted:IsA("GuiObject")) then
            Dotted = SalesGraph.GraphVisual:FindFirstChild("Dotted");

            if not (Dotted and Dotted:IsA("GuiObject")) then
                Dotted = nil;
            end;
        end;

        if Dotted then
            Dotted.Visible = false;
        end;

        local GraphVisual = Main.Main.SalesGraph.GraphVisual;

        for _, child in GraphVisual:GetChildren() do
            if child.Name ~= "Dotted" then
                child:Destroy();
            end;
        end;

        GraphVisual.ImageContent = Content.none;
    end;

    local function alignDottedToGraphX(p223: number) -- Line: 1488
        -- upvalues: Main (copy)
        local SalesGraph = Main.Main.SalesGraph;
        local Dotted = SalesGraph:FindFirstChild("Dotted");

        if not (Dotted and Dotted:IsA("GuiObject")) then
            Dotted = SalesGraph.GraphVisual:FindFirstChild("Dotted");

            if not (Dotted and Dotted:IsA("GuiObject")) then
                Dotted = nil;
            end;
        end;

        if not Dotted then
            return;
        end;

        local Parent = Dotted.Parent;
        local GraphVisual = Main.Main.SalesGraph.GraphVisual;

        if Parent == GraphVisual then
            Dotted.Position = UDim2.new(p223, 0, Dotted.Position.Y.Scale, Dotted.Position.Y.Offset);
        elseif Parent and (Parent:IsA("GuiObject") and Parent.AbsoluteSize.X > 0) then
            Dotted.Position = UDim2.new((GraphVisual.AbsolutePosition.X + p223 * GraphVisual.AbsoluteSize.X - Parent.AbsolutePosition.X) / Parent.AbsoluteSize.X, 0, Dotted.Position.Y.Scale, Dotted.Position.Y.Offset);
        end;

        Dotted.ZIndex = math.max(Dotted.ZIndex, 21);
        Dotted.Visible = true;
    end;

    local function plotGraph(u224: table, p225: userdata) -- Line: 1506
        -- upvalues: u22 (ref), clearGraphVisual (copy), Main (copy), AssetService (ref), alignDottedToGraphX (copy), CommaNumber (ref), formatSaleDate (ref), UserInputService (ref), GuiService (ref)
        if u22 then
            u22:Destroy();
            u22 = nil;
        end;

        clearGraphVisual();

        if #u224 == 0 then
            return;
        end;

        local Vector2_new_ret = Vector2.new(math.clamp(Main.Main.SalesGraph.GraphVisual.AbsoluteSize.X, 0, 1024), (math.clamp(Main.Main.SalesGraph.GraphVisual.AbsoluteSize.Y, 0, 1024)));
        local success, result = pcall(function() -- Line: 1521
            -- upvalues: AssetService (ref), Vector2_new_ret (copy)
            return AssetService:CreateEditableImage({
                Size = Vector2_new_ret
            });
        end);

        if not success then
            result = nil;
        end;

        u22 = result;
        local AbsoluteSize = Main.Main.SalesGraph.GraphVisual.AbsoluteSize;
        local v226 = (-1 / 0);
        local v227;

        if p225 and type(p225.priorAverageTradeTokens) == "number" then
            v227 = p225.priorAverageTradeTokens or nil;
        else
            v227 = nil;
        end;

        for _, v in u224 do
            v226 = math.max(v226, v.averageTradeTokens);
        end;

        if v227 then
            v226 = math.max(v226, v227);
        end;

        local function roundUpTo5(p228: number) -- Line: 1547
            return math.ceil(p228 / 5) * 5;
        end;

        local v229 = math.ceil(v226 / 5) * 5;
        local v230 = v229 - 0;
        local u231 = v230 == 0 and 1 or v230;

        local function toScreen(p232: number, p233: number, p234: number) -- Line: 1557
            -- upvalues: Vector2_new_ret (copy), u231 (ref)
            local v235 = Vector2_new_ret;
            local v236 = v235.X - 10;
            local v237;

            if p233 <= 1 then
                v237 = 5 + v236 / 2;
            else
                v237 = 5 + (p232 - 1) / (p233 - 1) * v236;
            end;

            return Vector2.new(v237, v235.Y - 5 - (p234 - 0) / u231 * (v235.Y - 10));
        end;

        local u238 = #u224;
        local u239 = {};

        for i, v in u224 do
            local v240 = Vector2_new_ret.X - 10;
            local v241;

            if u238 <= 1 then
                v241 = 5 + v240 / 2;
            else
                v241 = 5 + (i - 1) / (u238 - 1) * v240;
            end;

            u239[i] = Vector2.new(v241, Vector2_new_ret.Y - 5 - (v.averageTradeTokens - 0) / u231 * (Vector2_new_ret.Y - 10));
        end;

        local Size = u22.Size;
        local X = Size.X;
        local Y = Size.Y;
        local v242 = Y - 5;

        if u22 then
            local buffer_create_ret = buffer.create(X * Y * 4);

            for i = 0, X * Y * 4 - 1 do
                buffer.writeu8(buffer_create_ret, i, 0);
                local _ = i;
            end;

            local Color3_new_ret = Color3.new(0, 0.8, 1);

            for i = 1, #u239 - 1 do
                local v243 = u239[i];
                local v244 = u239[i + 1];
                local math_floor_ret = math.floor(v243.X);
                local math_floor_ret2 = math.floor(v244.X);

                if math_floor_ret2 >= math_floor_ret then
                    local v245 = math_floor_ret;
                    math_floor_ret = math_floor_ret2;
                    math_floor_ret2 = v245;
                    v245 = v244;
                    v244 = v243;
                    v243 = v245;
                end;

                local v246 = v243.X - v244.X;
                local v247;

                if v246 == 0 then
                    v247 = i;
                else
                    v247 = i;

                    for i2 = math_floor_ret2, math_floor_ret do
                        local v248 = (i2 - v244.X) / v246;
                        local v249;

                        if v248 >= 0 and v248 <= 1 then
                            v249 = i2;

                            for i3 = math.floor(v244.Y + (v243.Y - v244.Y) * v248), v242 do
                                local v250;

                                if i3 >= 0 and i3 < Y then
                                    local v251 = (i3 * X + v249) * 4;
                                    buffer.writeu8(buffer_create_ret, v251, Color3_new_ret.R * 255);
                                    buffer.writeu8(buffer_create_ret, v251 + 1, Color3_new_ret.G * 255);
                                    buffer.writeu8(buffer_create_ret, v251 + 2, Color3_new_ret.B * 255);
                                    buffer.writeu8(buffer_create_ret, v251 + 3, 80);
                                    v250 = i3;
                                else
                                    v250 = i3;
                                end;
                            end;
                        else
                            v249 = i2;
                        end;
                    end;
                end;
            end;

            if pcall(function() -- Line: 1633
                -- upvalues: u22 (ref), Size (copy), buffer_create_ret (copy)
                u22:WritePixelsBuffer(Vector2.zero, Size, buffer_create_ret);
            end) then
                clearGraphVisual();
            else
                u22:Destroy();
                u22 = nil;
            end;
        end;

        local function createPointFrame(p252) -- Line: 1644
            -- upvalues: Vector2_new_ret (copy), Main (ref)
            local Vector2_new_ret2 = Vector2.new(p252.X / Vector2_new_ret.X, p252.Y / Vector2_new_ret.Y);
            local Frame = Instance.new("Frame");
            Frame.Name = "GraphPoint";
            Frame.AnchorPoint = Vector2.new(0.5, 0.5);
            Frame.Position = UDim2.fromScale(Vector2_new_ret2.X, Vector2_new_ret2.Y);
            Frame.Size = UDim2.fromOffset(12, 12);
            Frame.BackgroundColor3 = Color3.new(0, 0.403921, 0.733333);
            Frame.BackgroundTransparency = 0;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = 6;
            local UICorner = Instance.new("UICorner");
            UICorner.CornerRadius = UDim.new(1, 0);
            UICorner.Parent = Frame;
            Frame.Parent = Main.Main.SalesGraph.GraphVisual;
        end;

        local function createLineFrame(p253, p254, p255: number) -- Line: 1663
            -- upvalues: Vector2_new_ret (copy), AbsoluteSize (copy), Main (ref)
            local Vector2_new_ret2 = Vector2.new(p253.X / Vector2_new_ret.X, p253.Y / Vector2_new_ret.Y);
            local Vector2_new_ret3 = Vector2.new(p254.X / Vector2_new_ret.X, p254.Y / Vector2_new_ret.Y);
            local math_sqrt_ret = math.sqrt(((Vector2_new_ret3.X - Vector2_new_ret2.X) * AbsoluteSize.X) ^ 2 + ((Vector2_new_ret3.Y - Vector2_new_ret2.Y) * AbsoluteSize.Y) ^ 2);

            if math_sqrt_ret == 0 then
                return;
            end;

            local Vector2_new_ret4 = Vector2.new((Vector2_new_ret2.X + Vector2_new_ret3.X) / 2, (Vector2_new_ret2.Y + Vector2_new_ret3.Y) / 2);
            local math_atan2_ret = math.atan2((Vector2_new_ret3.Y - Vector2_new_ret2.Y) * AbsoluteSize.Y, (Vector2_new_ret3.X - Vector2_new_ret2.X) * AbsoluteSize.X);
            local math_deg_ret = math.deg(math_atan2_ret);
            local Frame = Instance.new("Frame");
            Frame.Name = "GraphLine";
            Frame.AnchorPoint = Vector2.new(0.5, 0.5);
            Frame.Position = UDim2.fromScale(Vector2_new_ret4.X, Vector2_new_ret4.Y);
            Frame.Size = UDim2.new(UDim.new(math_sqrt_ret / AbsoluteSize.X, 0), UDim.new(0, p255 * 2 + 1));
            Frame.Rotation = math_deg_ret;
            Frame.BackgroundColor3 = Color3.new(0, 0.349019, 0.631372);
            Frame.BackgroundTransparency = 0;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = 5;
            Frame.Parent = Main.Main.SalesGraph.GraphVisual;
        end;

        for i = 1, #u239 - 1 do
            createLineFrame(u239[i], u239[i + 1], 2);
            local _ = i;
        end;

        for _, v in u239 do
            createPointFrame(v);
        end;

        local SaleInfo = Main.Main.SalesGraph.SaleInfo;
        local Info = SaleInfo.Info;
        local SaleInfo2 = Main.Main.SalesGraph:FindFirstChild("SaleInfo");

        if SaleInfo2 and SaleInfo2:IsA("GuiObject") then
            SaleInfo2.Visible = false;
        end;

        local SalesGraph = Main.Main.SalesGraph;
        local Dotted = SalesGraph:FindFirstChild("Dotted");

        if not (Dotted and Dotted:IsA("GuiObject")) then
            Dotted = SalesGraph.GraphVisual:FindFirstChild("Dotted");

            if not (Dotted and Dotted:IsA("GuiObject")) then
                Dotted = nil;
            end;
        end;

        if Dotted then
            Dotted.Visible = false;
        end;

        local ImageButton = Instance.new("ImageButton");
        ImageButton.Name = "HoverCatch";
        ImageButton.BackgroundTransparency = 1;
        ImageButton.ImageTransparency = 1;
        ImageButton.AutoButtonColor = false;
        ImageButton.Size = UDim2.fromScale(1, 1);
        ImageButton.ZIndex = 20;
        ImageButton.Parent = Main.Main.SalesGraph.GraphVisual;
        local u256 = nil;

        local function showNearestPoint(p257: number) -- Line: 1715
            -- upvalues: u239 (copy), u224 (copy), Vector2_new_ret (copy), alignDottedToGraphX (ref), u256 (ref), SaleInfo (copy), Main (ref), Info (copy), CommaNumber (ref), formatSaleDate (ref)
            local v258 = u239[p257];
            local v259 = u224[p257];

            if not (v258 and v259) then
                return;
            end;

            local v260 = v258.X / Vector2_new_ret.X;
            alignDottedToGraphX(v260);

            if u256 == p257 and SaleInfo.Visible then
                return;
            end;

            u256 = p257;
            local SalesGraph2 = Main.Main.SalesGraph;
            local GraphVisual = SalesGraph2.GraphVisual;
            local Vector2_new_ret2 = Vector2.new(v260 * GraphVisual.AbsoluteSize.X, v258.Y / Vector2_new_ret.Y * GraphVisual.AbsoluteSize.Y);
            local v261 = GraphVisual.AbsolutePosition + Vector2_new_ret2 - SalesGraph2.AbsolutePosition;
            local AbsoluteSize2 = SaleInfo.AbsoluteSize;
            local v262 = v261.X < SalesGraph2.AbsoluteSize.X / 2;
            local v263;

            if v262 then
                v263 = v261.X + AbsoluteSize2.X + 10;
            else
                v263 = v261.X - AbsoluteSize2.X - 10;
            end;

            SaleInfo.AnchorPoint = Vector2.new(v262 and 1 or 0, 1);
            SaleInfo.Position = UDim2.fromOffset(v263, v261.Y + 10);
            Info.Amount.Text = `Sold {v259.amount_sold}`;
            Info.Credits.TextLabel.Text = CommaNumber((math.floor(v259.averageTradeTokens)));
            Info.Date.Text = formatSaleDate(v259.date);
            SaleInfo.Visible = true;
        end;

        ImageButton.MouseMoved:Connect(function() -- Line: 1749
            -- upvalues: u239 (copy), Vector2_new_ret (copy), Main (ref), UserInputService (ref), GuiService (ref), showNearestPoint (copy)
            if #u239 == 0 or (Vector2_new_ret.X <= 0 or Vector2_new_ret.Y <= 0) then
                return;
            end;

            local GraphVisual = Main.Main.SalesGraph.GraphVisual;
            local AbsoluteSize2 = GraphVisual.AbsoluteSize;

            if AbsoluteSize2.X <= 0 or AbsoluteSize2.Y <= 0 then
                return;
            end;

            local v264 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
            local v265 = (1 / 0);
            local v266 = 1;

            for i, v in u239 do
                local v267 = v264 - (GraphVisual.AbsolutePosition + Vector2.new(v.X / Vector2_new_ret.X * AbsoluteSize2.X, v.Y / Vector2_new_ret.Y * AbsoluteSize2.Y));
                local v268 = v267.X * v267.X + v267.Y * v267.Y;

                if v268 < v265 then
                    v266 = i;
                    v265 = v268;
                end;
            end;

            showNearestPoint(v266);
        end);
        ImageButton.MouseLeave:Connect(function() -- Line: 1776
            -- upvalues: u256 (ref), Main (ref)
            u256 = nil;
            local SaleInfo3 = Main.Main.SalesGraph:FindFirstChild("SaleInfo");

            if SaleInfo3 and SaleInfo3:IsA("GuiObject") then
                SaleInfo3.Visible = false;
            end;

            local SalesGraph2 = Main.Main.SalesGraph;
            local Dotted2 = SalesGraph2:FindFirstChild("Dotted");

            if not (Dotted2 and Dotted2:IsA("GuiObject")) then
                Dotted2 = SalesGraph2.GraphVisual:FindFirstChild("Dotted");

                if not (Dotted2 and Dotted2:IsA("GuiObject")) then
                    Dotted2 = nil;
                end;
            end;

            if Dotted2 then
                Dotted2.Visible = false;
            end;
        end);

        local function getIndex(p269: number) -- Line: 1782
            -- upvalues: u238 (copy)
            if p269 == 1 then
                return 1;
            end;

            if p269 == 6 then
                return u238;
            end;

            return math.floor((p269 - 1) / 5 * (u238 - 1) + 1 + 0.5);
        end;

        local function createAxisLabel(p270: string, p271: number) -- Line: 1794
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "AxisLabel";
            TextLabel.BackgroundTransparency = 1;
            TextLabel.Text = p270;
            TextLabel.TextSize = 10;
            TextLabel.TextColor3 = Color3.new(1, 1, 1);
            TextLabel.Size = UDim2.fromOffset(p271, 15);

            return TextLabel;
        end;

        for i = 1, 6 do
            local v272;

            if i == 1 then
                v272 = 1;
            elseif i == 6 then
                v272 = u238;
            else
                v272 = math.floor((i - 1) / 5 * (u238 - 1) + 1 + 0.5);
            end;

            local v273 = u239[v272];
            local v274;

            if v273 then
                local os_date_ret = os.date("%x", u224[v272].date);
                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "AxisLabel";
                TextLabel.BackgroundTransparency = 1;
                TextLabel.Text = os_date_ret;
                TextLabel.TextSize = 10;
                TextLabel.TextColor3 = Color3.new(1, 1, 1);
                TextLabel.Size = UDim2.fromOffset(60, 15);
                TextLabel.AnchorPoint = Vector2.new(0.5, 1);
                TextLabel.Position = UDim2.new(UDim.new(v273.X / Vector2_new_ret.X, 0), UDim.new(1, 0));
                TextLabel.Parent = Main.Main.SalesGraph.GraphVisual;
                v274 = i;
            else
                v274 = i;
            end;
        end;

        for i = 0, 5 do
            local v275 = math.floor((i / 5 * v229 + 2.5) / 5) * 5;
            local v276 = CommaNumber(v275);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "AxisLabel";
            TextLabel.BackgroundTransparency = 1;
            TextLabel.Text = v276;
            TextLabel.TextSize = 10;
            TextLabel.TextColor3 = Color3.new(1, 1, 1);
            TextLabel.Size = UDim2.fromOffset(30, 15);
            TextLabel.AnchorPoint = Vector2.new(1, 0.5);
            TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
            TextLabel.Position = UDim2.fromOffset(1, Y - 5 - (v275 - 0) / u231 * (Y - 10));
            TextLabel.Parent = Main.Main.SalesGraph.GraphVisual;
            local v277;

            if v275 > 99 then
                TextLabel.AnchorPoint = Vector2.new(0, 0.5);
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
                v277 = i;
            else
                v277 = i;
            end;
        end;

        if u22 then
            Main.Main.SalesGraph.GraphVisual.ImageContent = Content.fromObject(u22);
        end;
    end;

    local function confirmBuy(p278) -- Line: 1843
        -- upvalues: UserCache (ref), u222 (ref), Main (copy), CommaNumber (ref), Players (ref), hideQuickPick (ref), u22 (ref), clearPurchaseMenuTransactions (copy), clearGraphVisual (copy), u44 (ref), u24 (ref), GlobalMarketplace (ref)
        local v279 = UserCache.Fetch(u222.inventoryItem.MetaData.Owner);
        Main.Main.Credits.TextLabel.Text = u222.priceTradeTokens and CommaNumber(u222.priceTradeTokens) or "N/A";
        Main.Main.FloatBar.Frame.Position = UDim2.fromScale(u222.inventoryItem.Float, 0.5);
        Main.Main.FloatNum.Text = u222.inventoryItem.Float;
        Main.Main.SerialNum.Text = `#{CommaNumber(u222.inventoryItem.Serial)}`;
        Main.Main.Info.Status.Text = p278.Main.Status.Text;
        Main.Main.Info.Skin.Text = p278.Main.Skin.Text;
        Main.Main.Player.Player.Image = Players:GetUserThumbnailAsync(u222.inventoryItem.MetaData.Owner, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
        Main.Main.Player.DisplayName.Text = v279.DisplayName;
        Main.Main.Player.Username.Text = v279.Username;
        Main.Main.Template.ItemIcon.Image = p278.Main.ItemIcon.Image;
        Main.Main.Template.Projected.Visible = p278.Main.Projected.Visible;
        Main.Main.Template.RarityBG.RarityBarGradient.Color = p278.Main.RarityBG.RarityBarGradient.Color;
        local v280 = p278.Main.RarityFrame:Clone();
        v280.Size = Main.Main.Template.RarityFrame.Size;
        v280.Position = Main.Main.Template.RarityFrame.Position;
        Main.Main.Template.RarityFrame:Destroy();
        v280.Parent = Main.Main.Template;
        hideQuickPick();
        Main.Parent.Visible = true;
        Main.Main.Purchase.Visible = u222.priceTradeTokens ~= nil;

        if u22 then
            u22:Destroy();
        end;

        clearPurchaseMenuTransactions();
        clearGraphVisual();
        Main.Main.SalesGraph.Loading.Visible = true;
        u44:Play();
        u24 = u222.inventoryItem._id;
        GlobalMarketplace.FetchRAP.Send(u24);
    end;

    local function fillSimilarListingRow(p281: any, p282: any, p283: number) -- Line: 1883
        -- upvalues: UserCache (ref), CommaNumber (ref), Players (ref)
        local v284 = UserCache.Fetch(p283);
        p281.Name = p282.listing_reference_id;
        local Type = p282.inventoryItem.Type;
        local v285;

        if Type == "Case" or (Type == "Charm Capsule" or Type == "Sticker Capsule") then
            v285 = false;
        else
            v285 = Type ~= "Package";
        end;

        p281.Float.Text = not v285 and "N/A" or tostring(p282.inventoryItem.Float);
        p281.Serial.Text = not p282.inventoryItem.Serial and "N/A" or `#{CommaNumber(p282.inventoryItem.Serial)}`;
        p281.Credits.TextLabel.Text = CommaNumber(p282.priceTradeTokens);
        p281.Player.DisplayName.Text = v284.DisplayName;
        p281.Player.Player.Image = Players:GetUserThumbnailAsync(p283, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
        local Type2 = p282.inventoryItem.Type;
        p281.Inspect.Visible = Type2 ~= "Case" and Type2 ~= "Package";
    end;

    GlobalMarketplace.FetchedRAP.Listen(function(p286) -- Line: 1896
        -- upvalues: u24 (ref), clearPurchaseMenuTransactions (copy), u40 (ref), fillSimilarListingRow (copy), Main (copy), MarketplaceButton (ref), showInspect (ref), deepCopy (ref), u222 (ref), UserCache (ref), CommaNumber (ref), Players (ref), Skins (ref), u39 (ref), formatSaleDate (ref), plotGraph (copy), u44 (ref)
        if not p286 or p286.inventoryItemId ~= u24 then
            return;
        end;

        local itemData = p286.itemData;
        clearPurchaseMenuTransactions();

        if itemData and itemData.next_inventory_items then
            for i, v in itemData.next_inventory_items do
                local u287 = u40:Clone();
                fillSimilarListingRow(u287, v, v.sellerUserId);
                u287.Parent = Main.Main.Similar.Listings;
                MarketplaceButton.new(u287.Inspect, {
                    hoverSizeMultiplier = 0.9,

                    onActivated = function() -- Line: 1913, Name: onActivated
                        -- upvalues: showInspect (ref), v (copy)
                        showInspect(v.inventoryItem);
                    end
                });
                MarketplaceButton.new(u287.View, {
                    hoverSizeMultiplier = 0.9,

                    onActivated = function() -- Line: 1921, Name: onActivated
                        -- upvalues: deepCopy (ref), u222 (ref), itemData (copy), i (copy), fillSimilarListingRow (ref), u287 (copy), UserCache (ref), Main (ref), CommaNumber (ref), Players (ref), Skins (ref)
                        local v288 = deepCopy(u222);
                        v288.sellerUserId = u222.inventoryItem.MetaData.Owner;
                        u222 = deepCopy(itemData.next_inventory_items[i]);
                        itemData.next_inventory_items[i] = v288;
                        fillSimilarListingRow(u287, v288, v288.inventoryItem.MetaData.Owner);
                        local v289 = UserCache.Fetch(u222.inventoryItem.MetaData.Owner);
                        Main.Main.Template.RarityFrame.Serial.SerialText.Text = `#{CommaNumber(u222.inventoryItem.Serial)}`;
                        Main.Main.SerialNum.Text = `#{CommaNumber(u222.inventoryItem.Serial)}`;
                        Main.Main.Credits.TextLabel.Text = not u222.priceTradeTokens and "N/A" or CommaNumber(u222.priceTradeTokens);
                        Main.Main.Player.DisplayName.Text = v289.DisplayName;
                        Main.Main.Player.Username.Text = v289.Username;
                        Main.Main.Player.Player.Image = Players:GetUserThumbnailAsync(u222.inventoryItem.MetaData.Owner, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
                        local SkinInformation = Skins.GetSkinInformation(u222.inventoryItem.Name, u222.inventoryItem.Skin);
                        local _, v290 = Skins.GetWearNameForFloat(SkinInformation, u222.inventoryItem.Float);
                        local AbbreviatedWearName = Skins.GetAbbreviatedWearName(v290);

                        for _, child in Main.Main.Template.RarityFrame.Condition:GetChildren() do
                            if child:IsA("UIGradient") then
                                child.Enabled = false;
                            end;
                        end;

                        Main.Main.Template.RarityFrame.Condition.Tag.Text = AbbreviatedWearName;
                        Main.Main.Template.RarityFrame.Condition[`{AbbreviatedWearName}Gradient`].Enabled = true;
                        Main.Main.FloatBar.Frame.Position = UDim2.fromScale(u222.inventoryItem.Float, 0.5);
                        Main.Main.FloatNum.Text = tostring(u222.inventoryItem.Float);
                        Main.Main.Purchase.Visible = u222.priceTradeTokens ~= nil;
                    end
                });
            end;
        end;

        if itemData and itemData.latest_sales then
            for _, v in itemData.latest_sales do
                local v291 = u39:Clone();
                v291.Name = v.listingReferenceId;
                v291.Float.Text = v.float and (v.float or 0) or 0;
                local v292 = u222.inventoryItem and u222.inventoryItem.Type;
                local v293;

                if v292 == "Case" or (v292 == "Charm Capsule" or v292 == "Sticker Capsule") then
                    v293 = false;
                else
                    v293 = v292 ~= "Package";
                end;

                v291.Float.Visible = v293;
                v291.Date.Text = formatSaleDate(v.date);
                v291.Serial.Text = not v.serial and "N/A" or CommaNumber(v.serial);
                v291.Credits.TextLabel.Text = CommaNumber(v.tradeTokens);
                v291.Parent = Main.Main.Transactions.Listings;
                local v294 = v;
                local u295 = {};

                for i, v2 in u222.inventoryItem do
                    if i ~= "Float" then
                        u295[i] = v2;
                    end;
                end;

                u295.Float = v294.float and (v294.float or 0) or 0;
                u295.Serial = v294.serial and v294.serial or 0;
                local Type = u295.Type;
                v291.Inspect.Visible = Type ~= "Case" and Type ~= "Package";
                MarketplaceButton.new(v291.Inspect, {
                    hoverSizeMultiplier = 0.9,

                    onActivated = function() -- Line: 1989, Name: onActivated
                        -- upvalues: showInspect (ref), u295 (copy)
                        showInspect(u295);
                    end
                });
            end;
        end;

        if itemData and itemData.sales_graph then
            plotGraph(itemData.sales_graph, itemData.rapGraphReference);
        end;

        Main.Main.SalesGraph.Loading.Visible = false;
        u44:Pause();
    end);
    GlobalMarketplace.NewItem.Listen(function(p296: table) -- Line: 2004
        -- upvalues: Router (ref)
        local v297 = #p296;
        Router.broadcastRouter("CreateNotification", "Marketplace", v297 == 1 and "Your marketplace item was added to your inventory." or `{v297} marketplace items were added to your inventory.`, 4);
    end);
    GlobalMarketplace.PurchaseItemResult.Listen(function(p298) -- Line: 2008
        -- upvalues: getMarketplaceErrorMessage (ref), Router (ref)
        local v299 = getMarketplaceErrorMessage(p298);

        if not v299 then
            return;
        end;

        Router.broadcastRouter("CreateNotification", "Error", v299);
    end);
    MarketplaceButton.new(u36.Market.PurchaseMenu.Confirm.Action.Frame.Accept, {
        hoverSizeMultiplier = 0.95,

        onActivated = function() -- Line: 2014, Name: onActivated
            -- upvalues: u222 (ref), u6 (ref), table_freeze_ret2 (ref), Router (ref), DataController (ref), LocalPlayer (ref), ReplicatedStorage (ref), MenuState (ref), Store (ref), u36 (ref), u43 (ref), GlobalMarketplace (ref), u24 (ref)
            local v300 = u222.inventoryItem and u222.inventoryItem.Type;
            local v301 = u6;

            if v301 then
                if v300 == nil then
                    v301 = false;
                else
                    v301 = table_freeze_ret2[v300] == true;
                end;
            end;

            if v301 then
                Router.broadcastRouter("CreateNotification", "Error", "Paid random items are not allowed in your region.");

                return;
            end;

            local v302 = DataController.Get(LocalPlayer, "TradeTokens") or 0;
            local u303 = u222.priceTradeTokens or (1 / 0);

            if v302 < u303 then
                task.spawn(function() -- Line: 577
                    -- upvalues: ReplicatedStorage (ref), MenuState (ref), Store (ref), u303 (copy)
                    local Error = ReplicatedStorage.Assets.Sounds:FindFirstChild("Error");

                    if Error and Error:IsA("Sound") then
                        Error:Play();
                    end;

                    task.wait(0.1);
                    require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Store");

                    if MenuState.GetCurrentScreen() == "Store" then
                        Store.OpenTab("TradeTokens");
                    end;

                    task.wait(0.3);
                    Store.PromptTradeTokenPackageForItemPrice(u303);
                end);

                return;
            end;

            if not LocalPlayer:GetAttribute("PinVerified") then
                return;
            end;

            u36.Parent.Parent.Loading.Visible = true;
            u43:Play();
            GlobalMarketplace.PurchaseItem.Send(u222);
            u24 = nil;
            u36.Market.PurchaseMenu.Visible = false;
            u36.Market.PurchaseMenu.Confirm.Visible = false;
        end
    });
    local PurchaseMenu = u36.Market.PurchaseMenu;
    local Confirm = PurchaseMenu.Confirm;
    local Confirm2 = u36.Market.Confirm;

    local function closePurchaseConfirm() -- Line: 2043
        -- upvalues: Confirm (copy)
        Confirm.Visible = false;
    end;

    local function closePurchaseMenu() -- Line: 2047
        -- upvalues: u24 (ref), u22 (ref), clearPurchaseMenuTransactions (copy), clearGraphVisual (copy), u44 (ref), Main (copy), Confirm (copy), PurchaseMenu (copy)
        u24 = nil;

        if u22 then
            u22:Destroy();
            u22 = nil;
        end;

        clearPurchaseMenuTransactions();
        clearGraphVisual();
        u44:Pause();
        Main.Main.SalesGraph.Loading.Visible = false;
        Confirm.Visible = false;
        PurchaseMenu.Visible = false;
    end;

    local function closeLegacyConfirm() -- Line: 2062
        -- upvalues: Confirm2 (copy)
        Confirm2.Visible = false;
    end;

    MarketplaceButton.new(Confirm.Action.Frame.Decline, {
        hoverSizeMultiplier = 0.9,
        onActivated = closePurchaseConfirm
    });
    MarketplaceButton.new(PurchaseMenu.Main.Main.Purchase, {
        hoverSizeMultiplier = 0.9,

        onActivated = function() -- Line: 2073, Name: onActivated
            -- upvalues: Confirm (copy)
            Confirm.Visible = true;
        end
    });
    MarketplaceButton.new(PurchaseMenu.Main.Header.Close, {
        hoverSizeMultiplier = 0.9,
        onActivated = closePurchaseMenu
    });
    MarketplaceButton.new(Confirm2.Action.Frame.Decline, {
        hoverSizeMultiplier = 0.9,
        onActivated = closeLegacyConfirm
    });
    local Main2 = PurchaseMenu.Main.Main;
    local Container = Main2.Header.TopSelect.Container;
    local u304 = { { "SalesGraph", "SalesGraph" }, { "SimilarListings", "Similar" }, { "LatestSales", "Transactions" } };

    local function showPurchaseMenuTab(p305: table) -- Line: 2093
        -- upvalues: u304 (copy), Main2 (copy), Container (copy)
        for _, v in u304 do
            Main2[v[2]].Visible = v == p305;
            Container[v[1]].Frame.Visible = v == p305;
        end;
    end;

    for _, v in u304 do
        MarketplaceButton.new(Container[v[1]], {
            hoverSizeMultiplier = 0.9,

            onActivated = function() -- Line: 2104, Name: onActivated
                -- upvalues: showPurchaseMenuTab (copy), v (copy)
                showPurchaseMenuTab(v);
            end
        });
    end;

    CloseButtonRegistry.Add(PurchaseMenu, nil, closePurchaseMenu);
    CloseButtonRegistry.Add(Confirm, nil, closePurchaseConfirm);
    CloseButtonRegistry.Add(Confirm2, nil, closeLegacyConfirm);
    GamepadNavigation.TrapPopup(PurchaseMenu, function() -- Line: 2119
        -- upvalues: PurchaseMenu (copy), Container (copy)
        local Purchase = PurchaseMenu.Main.Main.Purchase;

        if Purchase.Visible then
            return Purchase;
        end;

        return Container.SalesGraph;
    end);
    GamepadNavigation.TrapPopup(Confirm, function() -- Line: 2124
        -- upvalues: Confirm (copy)
        return Confirm.Action.Frame.Decline;
    end);
    GamepadNavigation.TrapPopup(Confirm2, function() -- Line: 2127
        -- upvalues: Confirm2 (copy)
        return Confirm2.Action.Frame.Decline;
    end);
    MenuState.RegisterBumperOverride(PurchaseMenu, function(p306: boolean) -- Line: 2132
        -- upvalues: Confirm (copy), u304 (copy), Main2 (copy), showPurchaseMenuTab (copy), GamepadNavigation (ref), Container (copy)
        if Confirm.Visible then
            return true;
        end;

        local v307 = 1;

        for i, v in u304 do
            if Main2[v[2]].Visible then
                v307 = i;
                break;
            end;
        end;

        local v308 = u304[(v307 - 1 + (p306 and -1 or 1)) % #u304 + 1];
        showPurchaseMenuTab(v308);
        GamepadNavigation.Focus(Container[v308[1]]);

        return true;
    end, PurchaseMenu);
    local u309 = CollectionServiceUtility.FindDescendantWithTag(u36.Market.Header.Filters, "SearchBox");
    local v310 = CollectionServiceUtility.FindDescendantWithTag(u36.Market.Header.Filters, "Dropdown_Category");
    local u311 = "All";
    local u312 = "Quality";
    local u313 = true;
    local u314 = {
        ["Factory New"] = 0,
        ["Minimal Wear"] = 1,
        ["Field-Tested"] = 2,
        ["Well-Worn"] = 3,
        ["Battle-Scarred"] = 4
    };
    local u315 = {
        ["Sticker Capsule"] = 14,
        ["Charm Capsule"] = 13,
        ["Music Kit"] = 8,
        Graffiti = 11,
        Grenade = 16,
        Sticker = 10,
        ["Zeus x27"] = 3,
        Charm = 9,
        Melee = 1,
        Glove = 2,
        Badge = 7,
        Case = 12,
        C4 = 15,
        Miscellaneous = 18,
        Equipment = 17,
        Pistol = 3,
        Rifle = 6,
        Heavy = 5,
        SMG = 4
    };

    local function getMarketHeaderSearchTerm() -- Line: 2190
        -- upvalues: u309 (copy)
        if not u309 then
            return nil;
        end;

        local Text = u309.Text;

        if Text == "" then
            return nil;
        end;

        return Text;
    end;

    local function listingMatchesHeaderSearch(p316) -- Line: 2199
        -- upvalues: u309 (copy), GetSkinDisplayName (ref), FuzzySearch (ref)
        local v317;

        if u309 then
            v317 = u309.Text;

            if v317 == "" then
                v317 = nil;
            end;
        else
            v317 = nil;
        end;

        if not v317 then
            return true;
        end;

        local Attribute = p316:GetAttribute("InternalGun");
        local Attribute2 = p316:GetAttribute("Skin");

        if typeof(Attribute) ~= "string" or typeof(Attribute2) ~= "string" then
            return false;
        end;

        local v318 = GetSkinDisplayName.GetSearchIdentity(Attribute, Attribute2):lower();
        local string_lower = string.lower;
        local v319 = p316:GetAttribute("Wear") or "";
        local v320 = string_lower((tostring(v319)));
        local string_lower2 = string.lower;
        local v321 = p316:GetAttribute("Type") or "";
        local v322 = string_lower2((tostring(v321)));
        local string_lower3 = string.lower;
        local v323 = p316:GetAttribute("OtherType") or "";
        local v324 = string_lower3((tostring(v323)));
        local string_lower4 = string.lower;
        local v325 = p316:GetAttribute("Collection") or "";
        local v326 = v318 .. " " .. v320 .. " " .. v322 .. " " .. v324 .. " " .. string_lower4((tostring(v325)));

        return FuzzySearch.MatchesQuery(v326, v317);
    end;

    local function shouldShowMarketListing(p327) -- Line: 2224
        -- upvalues: u311 (ref), listingMatchesHeaderSearch (copy), u15 (ref), u17 (ref)
        local v328 = (u311 == "All" and true or u311 == p327:GetAttribute("Type")) and listingMatchesHeaderSearch(p327);

        if v328 then
            if p327:GetAttribute("StaggerRevealReady") == false then
                v328 = false;
            else
                local v329 = false;

                for _, v in u15 do
                    if u17[v.key] then
                        v329 = true;
                        break;
                    end;
                end;

                if not v329 then
                    return true;
                end;

                local Attribute = p327:GetAttribute("Wear");

                if typeof(Attribute) == "string" then
                    for _, v in u15 do
                        if u17[v.key] and v.wear == Attribute then
                            return true;
                        end;
                    end;

                    v328 = false;
                else
                    v328 = false;
                end;
            end;
        end;

        return v328;
    end;

    local function showCategory(p330: boolean?) -- Line: 2232
        -- upvalues: u312 (ref), u314 (copy), GetSkinDisplayName (ref), u315 (copy), u36 (ref), u311 (ref), listingMatchesHeaderSearch (copy), u15 (ref), u17 (ref), u313 (ref)
        local v331 = p330 ~= false;

        local function getSortValue(p332: userdata) -- Line: 2235
            -- upvalues: u312 (ref), u314 (ref), GetSkinDisplayName (ref), u315 (ref)
            if u312 == "Quality" then
                local Attribute = p332:GetAttribute("Wear");

                return typeof(Attribute) == "string" and (u314[Attribute] or 0) or 0;
            end;

            if u312 == "Newest" then
                local Attribute = p332:GetAttribute("CreatedAt");

                return typeof(Attribute) ~= "number" and 0 or Attribute;
            end;

            if u312 == "RAP" then
                local Attribute = p332:GetAttribute("RAP");

                return typeof(Attribute) ~= "number" and 0 or Attribute;
            end;

            if u312 == "Alphabetical" then
                local Attribute = p332:GetAttribute("InternalGun");
                local Attribute2 = p332:GetAttribute("Skin");

                return (typeof(Attribute) ~= "string" or typeof(Attribute2) ~= "string") and "" or GetSkinDisplayName.GetSearchIdentity(Attribute, Attribute2):lower();
            end;

            if u312 == "Float" then
                local Attribute = p332:GetAttribute("Float");

                return typeof(Attribute) ~= "number" and 0 or Attribute;
            end;

            if u312 == "Serial" then
                local Attribute = p332:GetAttribute("Serial");

                return typeof(Attribute) ~= "number" and 0 or Attribute;
            end;

            if u312 == "Type" then
                local Attribute = p332:GetAttribute("OtherType");

                return typeof(Attribute) == "string" and (u315[Attribute] or 0) or 0;
            end;

            if u312 ~= "Collection" then
                return 0;
            end;

            local Attribute = p332:GetAttribute("Collection");

            return typeof(Attribute) ~= "string" and "" or Attribute:lower();
        end;

        local v333 = {};

        for _, child in u36.Market.Container:GetChildren() do
            if child:IsA("Frame") then
                local v334 = u311 == "All" and true or u311 == child:GetAttribute("Type");
                local v335;

                if v334 then
                    v334 = listingMatchesHeaderSearch(child);

                    if v334 then
                        if child:GetAttribute("StaggerRevealReady") == false then
                            v335 = child;
                            v334 = false;
                        else
                            v335 = child;
                            local v336 = false;

                            for _, v in u15 do
                                if u17[v.key] then
                                    v336 = true;
                                    break;
                                end;
                            end;

                            if v336 then
                                local Attribute = v335:GetAttribute("Wear");

                                if typeof(Attribute) == "string" then
                                    v334 = false;

                                    for _, v in u15 do
                                        if u17[v.key] and v.wear == Attribute then
                                            v334 = true;
                                            break;
                                        end;
                                    end;
                                else
                                    v334 = false;
                                end;
                            else
                                v334 = true;
                            end;
                        end;
                    else
                        v335 = child;
                    end;
                else
                    v335 = child;
                end;

                v335.Visible = v334;

                if v335.Visible and v331 then
                    table.insert(v333, v335);
                end;
            end;
        end;

        table.sort(v333, function(p337, p338) -- Line: 2281
            -- upvalues: getSortValue (copy), u313 (ref)
            local v339 = getSortValue(p337);
            local v340 = getSortValue(p338);

            if v339 == v340 then
                return p337.Name < p338.Name;
            end;

            if u313 then
                return v340 < v339;
            end;

            return v339 < v340;
        end);

        for i, v in v333 do
            v.LayoutOrder = i;
        end;
    end;

    u16 = function() -- Line: 2293
        -- upvalues: showCategory (copy)
        showCategory(true);
    end;

    local function getNextMarketLayoutOrder() -- Line: 2297
        -- upvalues: u36 (ref)
        local v341 = 0;

        for _, child in u36.Market.Container:GetChildren() do
            if child:IsA("GuiObject") then
                v341 = math.max(v341, child.LayoutOrder);
            end;
        end;

        return v341 + 1;
    end;

    local function captureMarketScrollAnchor() -- Line: 2307
        -- upvalues: u36 (ref)
        local Container2 = u36.Market.Container;
        local Y = Container2.AbsolutePosition.Y;
        local v342 = Y + Container2.AbsoluteSize.Y;
        local v343 = nil;
        local v344 = 0;

        for _, child in Container2:GetChildren() do
            if child:IsA("GuiObject") and child.Visible then
                local Y2 = child.AbsolutePosition.Y;

                if Y2 < v342 and (Y < Y2 + child.AbsoluteSize.Y and (not v343 or v343.AbsolutePosition.Y <= Y2)) then
                    v344 = Y2 - Y;
                    v343 = child;
                end;
            end;
        end;

        return {
            canvas = Container2.CanvasPosition,
            anchor = v343,
            offsetInView = v344
        };
    end;

    local function restoreMarketScrollAnchor(p345: table) -- Line: 2336
        -- upvalues: u36 (ref)
        local Container2 = u36.Market.Container;
        local anchor = p345.anchor;

        if anchor and anchor.Parent then
            Container2.CanvasPosition = Vector2.new(p345.canvas.X, Container2.CanvasPosition.Y + (anchor.AbsolutePosition.Y - Container2.AbsolutePosition.Y - p345.offsetInView));

            return;
        end;

        Container2.CanvasPosition = p345.canvas;
    end;

    GlobalMarketplace.SearchMarketResults.Listen(function(p346) -- Line: 2350
        -- upvalues: u26 (ref), u36 (ref), u43 (ref), u13 (ref), showCategory (copy), u12 (ref), u8 (ref), captureMarketScrollAnchor (copy), getNextMarketLayoutOrder (copy), Skins (ref), listingMatchesSelectedWearTiers (ref), createMarketListing (ref), u37 (ref), LocalPlayer (ref), MarketplaceButton (ref), GlobalMarketplace (ref), removeYourListingByInventoryItemId (ref), destroyListingCard (ref), addYourListing (ref), Main (copy), u6 (ref), table_freeze_ret2 (ref), Router (ref), u222 (ref), confirmBuy (copy), MenuState (ref), pruneOldestListingFrames (ref), shouldShowMarketListing (copy)
        u26 = u26 + 1;
        local v347;

        if p346 then
            v347 = p346.Listings;
        else
            v347 = p346;
        end;

        local v348;

        if p346 then
            v348 = p346.TotalPages;
        else
            v348 = p346;
        end;

        if p346 then
            p346 = p346.OnCooldown;
        end;

        if v347 == nil then
            u36.Parent.Parent.Loading.Visible = false;
            u43:Pause();
            u13 = false;

            return;
        end;

        if p346 then
            u36.Parent.Parent.Loading.Visible = false;
            u43:Pause();
            u13 = false;
            showCategory();

            return;
        end;

        if v348 then
            u12 = v348;
        end;

        local u349;

        if u8.page == nil then
            u349 = false;
        else
            u349 = u8.page > 1;
        end;

        local u350;

        if u349 then
            u350 = captureMarketScrollAnchor();
        else
            u350 = nil;
        end;

        local v351;

        if u349 then
            v351 = getNextMarketLayoutOrder();
        else
            v351 = nil;
        end;

        if not u349 then
            for _, child in u36.Market.Container:GetChildren() do
                if child:IsA("Frame") then
                    child:Destroy();
                end;
            end;
        end;

        local u352 = {};

        for _, v in v347 do
            if v.inventoryItem and (Skins.HasSkinTextures(v.inventoryItem.Name, v.inventoryItem.Skin) and (v.ForceConfirm or listingMatchesSelectedWearTiers(v))) and not u36.Market.Container:FindFirstChild(v.inventoryItem._id) then
                local v353;

                if v351 then
                    v353 = v351 + 1;
                else
                    v353 = v351;
                    v351 = nil;
                end;

                local u354 = createMarketListing(u36.Market.Container, v.inventoryItem._id, u37, v, v351);

                if u354 then
                    if u349 then
                        u354:SetAttribute("StaggerRevealReady", true);
                    else
                        u354:SetAttribute("StaggerRevealReady", false);
                        u354.Visible = false;
                    end;

                    table.insert(u352, u354);

                    if v.inventoryItem.MetaData.GlobalMarketPlaceListingReference then
                        if LocalPlayer.UserId == v.inventoryItem.MetaData.Owner then
                            u354.Main.Delist.Visible = true;
                            MarketplaceButton.new(u354.Main.Delist, {
                                hoverSizeMultiplier = 0.9,

                                onActivated = function() -- Line: 2438, Name: onActivated
                                    -- upvalues: LocalPlayer (ref), v (copy), u36 (ref), u43 (ref), GlobalMarketplace (ref), removeYourListingByInventoryItemId (ref), destroyListingCard (ref), u354 (copy)
                                    if LocalPlayer.UserId ~= v.inventoryItem.MetaData.Owner then
                                        return;
                                    end;

                                    if not LocalPlayer:GetAttribute("PinVerified") then
                                        return;
                                    end;

                                    u36.Parent.Parent.Loading.Visible = true;
                                    u43:Play();
                                    GlobalMarketplace.DelistItem.Send(v.inventoryItem._id);
                                    local v355 = u36.Sell.Container:FindFirstChild(v.inventoryItem._id);

                                    if v355 then
                                        v355.Visible = true;
                                        v355.Main.Sell.Visible = true;
                                        v355.Main.Delist.Visible = false;
                                    end;

                                    removeYourListingByInventoryItemId(v.inventoryItem._id);
                                    destroyListingCard(u354);
                                end
                            });

                            if not u36.Profile.Main.Frame.YourListings.YourListings:FindFirstChild(v.listing_reference_id) then
                                addYourListing(v);
                            end;
                        else
                            u354.Main.Purchase.Visible = true;
                            MarketplaceButton.new(u354.Main.Purchase, {
                                hoverSizeMultiplier = 0.9,

                                onActivated = function() -- Line: 2474, Name: onActivated
                                    -- upvalues: LocalPlayer (ref), v (copy), Main (ref), u6 (ref), table_freeze_ret2 (ref), Router (ref), u222 (ref), confirmBuy (ref), u354 (copy)
                                    if LocalPlayer.UserId == v.inventoryItem.MetaData.Owner or Main.Parent.Visible then
                                        return;
                                    end;

                                    local Type = v.inventoryItem.Type;
                                    local v356 = u6;

                                    if v356 then
                                        if Type == nil then
                                            v356 = false;
                                        else
                                            v356 = table_freeze_ret2[Type] == true;
                                        end;
                                    end;

                                    if v356 then
                                        Router.broadcastRouter("CreateNotification", "Error", "Paid random items are not allowed in your region.");

                                        return;
                                    end;

                                    u222 = v;
                                    confirmBuy(u354);
                                end
                            });
                        end;

                        if v.ForceConfirm then
                            u222 = v;
                            confirmBuy(u354);
                            u36.Visible = true;
                            MenuState.SetScreen("GlobalMarketPlace");
                            v351 = v353;
                        else
                            v351 = v353;
                        end;
                    else
                        u354.Visible = false;
                        v351 = v353;
                    end;
                else
                    v351 = v353;
                end;
            end;
        end;

        (function() -- Line: 2500, Name: finishResults
            -- upvalues: showCategory (ref), u349 (copy), pruneOldestListingFrames (ref), u36 (ref), u43 (ref), u352 (copy), shouldShowMarketListing (ref), u350 (copy), u13 (ref)
            showCategory(not u349);

            if u349 then
                pruneOldestListingFrames(u36.Market.Container, 96);
            end;

            u36.Parent.Parent.Loading.Visible = false;
            u43:Pause();

            if u349 then
                if u350 then
                    local function restoreScroll() -- Line: 2513
                        -- upvalues: u350 (ref), u36 (ref)
                        local v357 = u350;
                        local Container2 = u36.Market.Container;
                        local anchor = v357.anchor;

                        if anchor and anchor.Parent then
                            Container2.CanvasPosition = Vector2.new(v357.canvas.X, Container2.CanvasPosition.Y + (anchor.AbsolutePosition.Y - Container2.AbsolutePosition.Y - v357.offsetInView));

                            return;
                        end;

                        Container2.CanvasPosition = v357.canvas;
                    end;

                    local v358 = u350;
                    local Container2 = u36.Market.Container;
                    local anchor = v358.anchor;

                    if anchor and anchor.Parent then
                        Container2.CanvasPosition = Vector2.new(v358.canvas.X, Container2.CanvasPosition.Y + (anchor.AbsolutePosition.Y - Container2.AbsolutePosition.Y - v358.offsetInView));
                    else
                        Container2.CanvasPosition = v358.canvas;
                    end;

                    local u359 = u36.Market.Container:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(restoreScroll);
                    task.delay(0.15, function() -- Line: 2522
                        -- upvalues: u359 (ref), u350 (ref), u36 (ref)
                        if u359 then
                            u359:Disconnect();
                        end;

                        local v360 = u350;
                        local Container3 = u36.Market.Container;
                        local anchor2 = v360.anchor;

                        if anchor2 and anchor2.Parent then
                            Container3.CanvasPosition = Vector2.new(v360.canvas.X, Container3.CanvasPosition.Y + (anchor2.AbsolutePosition.Y - Container3.AbsolutePosition.Y - v360.offsetInView));

                            return;
                        end;

                        Container3.CanvasPosition = v360.canvas;
                    end);
                end;
            else
                local u361 = u352;
                local u362 = shouldShowMarketListing;
                task.spawn(function() -- Line: 431
                    -- upvalues: u361 (copy), u362 (copy)
                    for _, v in u361 do
                        if v.Parent then
                            v:SetAttribute("StaggerRevealReady", true);
                            v.Visible = u362(v);
                        end;

                        task.wait(0.018);
                    end;
                end);
            end;

            u13 = false;
        end)();
    end);
    local os_clock_ret = os.clock();
    u36.Market.Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 2537
        -- upvalues: u36 (ref), os_clock_ret (ref), u8 (ref), u12 (ref), u13 (ref), getWearSearchRangeFromSelection (ref), u43 (ref), GlobalMarketplace (ref), u33 (ref)
        local Container2 = u36.Market.Container;
        local math_max_ret = math.max(0, Container2.AbsoluteCanvasSize.Y - Container2.AbsoluteSize.Y);
        local math_max_ret2 = math.max(1, Container2.AbsoluteSize.Y * 0.05);

        if Container2.CanvasPosition.Y >= math_max_ret - math_max_ret2 and (os.clock() - os_clock_ret > 0.75 and (u8.page < u12 and not u13)) then
            u13 = true;
            local v363 = u8;
            v363.page = v363.page + 1;
            u8.wear_range = getWearSearchRangeFromSelection();
            u36.Parent.Parent.Loading.Visible = true;
            u43:Play();
            local pattern_range = u8.pattern_range;

            if pattern_range and pattern_range[1] <= 0 then
                u8.pattern_range = nil;
            end;

            GlobalMarketplace.SearchMarket.Send(u8);
            u8.pattern_range = pattern_range;
            u33();
            os_clock_ret = os.clock();
        end;
    end);
    GlobalMarketplace.ClearListing.Listen(function(p364: string) -- Line: 2560
        -- upvalues: u36 (ref), destroyListingCard (ref), removeYourListingByInventoryItemId (ref)
        local v365 = u36.Market.Container:FindFirstChild(p364, true);

        if v365 then
            destroyListingCard(v365);
        end;

        removeYourListingByInventoryItemId(p364);
    end);

    local function bindRangeFilter(u366: any, u367: any, u368: number, u369: function?) -- Line: 2571
        -- upvalues: bindSliderPin (ref), setDrag (ref)
        bindSliderPin(u366.Slider, u366.Slider.StartPin, u368);
        bindSliderPin(u366.Slider, u366.Slider.EndPin, u368);
        u366.Content.Inputs.StartPin.TextBox.FocusLost:Connect(function() -- Line: 2580
            -- upvalues: setDrag (ref), u367 (copy), u366 (copy), u368 (copy)
            setDrag(u367, u366.Content.Inputs.StartPin.TextBox.Text, "StartPin", u368);
        end);
        u366.Content.Inputs.EndPin.TextBox.FocusLost:Connect(function() -- Line: 2584
            -- upvalues: u366 (copy), setDrag (ref), u367 (copy), u369 (copy), u368 (copy)
            local Text = u366.Content.Inputs.EndPin.TextBox.Text;

            if u369 then
                Text = u369(Text);
            end;

            setDrag(u367, Text, "EndPin", u368);
        end);
    end;

    local function parseMaxInput(u370: number) -- Line: 2591
        return function(p371: string) -- Line: 2592
            -- upvalues: u370 (copy)
            local string_gsub_ret = string.gsub(p371, ",", "");

            return tonumber(string_gsub_ret) or u370;
        end;
    end;

    for _, v in CollectionService:GetTagged("pattern_range") do
        local u372 = 11;
        bindRangeFilter(v, v, 11, function(p373: string) -- Line: 2592
            -- upvalues: u372 (copy)
            local string_gsub_ret = string.gsub(p373, ",", "");

            return tonumber(string_gsub_ret) or u372;
        end);
    end;

    local price_range = u36.Market.Filters.Container.price_range;

    for _, v in CollectionService:GetTagged("price_range") do
        local u374 = u2[2];
        bindRangeFilter(v, price_range, Constants.MARKETPLACE_MAX_LISTING_PRICE, function(p375: string) -- Line: 2592
            -- upvalues: u374 (copy)
            local string_gsub_ret = string.gsub(p375, ",", "");

            return tonumber(string_gsub_ret) or u374;
        end);
    end;

    setDrag(price_range, u2[2], "EndPin", Constants.MARKETPLACE_MAX_LISTING_PRICE);
    setDrag(price_range, u2[1], "StartPin", Constants.MARKETPLACE_MAX_LISTING_PRICE);

    for _, v in CollectionService:GetTagged("wear_range") do
        bindRangeFilter(v, v, 1);
    end;

    setupWearTierButtons();
    local special_dropdown = u36.Market.Filters.Container:FindFirstChild("special_dropdown");

    if special_dropdown then
        special_dropdown = special_dropdown:FindFirstChild("List");
    end;

    if special_dropdown then
        special_dropdown = special_dropdown:FindFirstChild("Killtrack");
    end;

    if special_dropdown then
        special_dropdown = special_dropdown:FindFirstChild("Button");
    end;

    local u376;

    if special_dropdown then
        u376 = special_dropdown:FindFirstChild("ImageLabel");
    else
        u376 = special_dropdown;
    end;

    if special_dropdown and (special_dropdown:IsA("GuiButton") and (u376 and u376:IsA("GuiObject"))) then
        MarketplaceButton.new(special_dropdown, {
            hoverSizeMultiplier = 0.9,

            onActivated = function() -- Line: 2624, Name: onActivated
                -- upvalues: u376 (copy), u8 (ref)
                u376.Visible = not u376.Visible;
                u8.statTrak = u376.Visible and true or nil;
            end
        });
        u30 = u376;
    end;

    for _, v in CollectionService:GetTagged("Dropdown_Category") do
        if v:IsDescendantOf(u36.Market.Filters.Container) then
            local Attribute = v:GetAttribute("category");

            if Attribute then
                Attribute = v.Parent:FindFirstChild(Attribute);
            end;

            if Attribute and Attribute:IsA("GuiObject") then
                v.Activated:Connect(function() -- Line: 2644
                    -- upvalues: Attribute (copy), v (copy)
                    Attribute.Visible = not Attribute.Visible;
                    local ImageLabel = v:FindFirstChild("ImageLabel");

                    if ImageLabel and ImageLabel:IsA("GuiObject") then
                        ImageLabel.Rotation = Attribute.Visible and 180 or 0;
                    end;
                end);
            end;
        end;
    end;

    u36.Market.Filters.Container.Search.Frame.SearchBox:GetPropertyChangedSignal("Text"):Connect(schedulePredictSearch);
    u36.Market.Filters.Container.Search.Frame.SearchBox.FocusLost:Connect(function() -- Line: 2656
        -- upvalues: u36 (ref), u8 (ref)
        u36.Market.Filters.Container.Search.Frame.Auto.Text = "";
        u8.search_bar_query = u36.Market.Filters.Container.Search.Frame.SearchBox.Text;
    end);
    MarketplaceButton.new(u36.Market.Filters.Container.ApplyFilter, {
        hoverSizeMultiplier = 0.9,

        onActivated = function() -- Line: 2664, Name: onActivated
            -- upvalues: u8 (ref), getWearSearchRangeFromSelection (ref), showCategory (copy), u7 (ref), u36 (ref), u13 (ref), GlobalMarketplace (ref), u33 (ref), u43 (ref)
            u8.wear_range = getWearSearchRangeFromSelection();
            showCategory();

            if os.clock() - u7 < 10 then
                return;
            end;

            if u36.Market.Filters.Container.ApplyFilter.Frame.Timer.Visible then
                return;
            end;

            u7 = os.clock();
            u8.page = 1;
            u13 = true;
            local pattern_range = u8.pattern_range;

            if pattern_range and pattern_range[1] <= 0 then
                u8.pattern_range = nil;
            end;

            GlobalMarketplace.SearchMarket.Send(u8);
            u8.pattern_range = pattern_range;
            u33();
            u36.Parent.Parent.Loading.Visible = true;
            u43:Play();
            u36.Market.Filters.Container.ApplyFilter.Frame.Timer.Visible = true;

            for i = 10, 0, -1 do
                u36.Market.Filters.Container.ApplyFilter.Frame.Timer.Text = i;
                task.wait(1);
                local _ = i;
            end;

            u36.Market.Filters.Container.ApplyFilter.Frame.Timer.Visible = false;
        end
    });

    if v310 then
        MarketplaceDropdown.new(v310, Constants.ITEM_CATEGORIES).OptionSelected:Connect(function(p377) -- Line: 2694
            -- upvalues: u311 (ref), showCategory (copy)
            u311 = tostring(p377);
            showCategory();
        end);
    end;

    local v378 = CollectionServiceUtility.FindDescendantWithTag(u36.Market.Header.Filters, "Dropdown_SortType");

    if v378 then
        local v379 = {};

        for _, v in Constants.MARKETPLACE_SORTING_OPTIONS do
            if v ~= "Equipped" then
                table.insert(v379, v);
            end;
        end;

        MarketplaceDropdown.new(v378, v379).OptionSelected:Connect(function(p380) -- Line: 2716
            -- upvalues: u312 (ref), showCategory (copy)
            u312 = tostring(p380);
            showCategory();
        end);
    end;

    local u381 = CollectionServiceUtility.FindDescendantWithTag(u36.Market.Header.Filters, "ReverseSort");

    if u381 then
        u381.Activated:Connect(function() -- Line: 2725, Name: toggleReverseSorting
            -- upvalues: u313 (ref), u381 (copy), showCategory (copy)
            u313 = not u313;
            local v382 = u381:FindFirstChildOfClass("ImageLabel");

            if v382 then
                v382.Rotation = u313 and 180 or 0;
            end;

            showCategory();
        end);
    end;

    if u309 then
        local u383 = 0;
        u309:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 2739
            -- upvalues: u383 (ref), showCategory (copy)
            u383 = u383 + 1;
            local u384 = u383;
            task.delay(0.12, function() -- Line: 2742
                -- upvalues: u384 (copy), u383 (ref), showCategory (ref)
                if u384 ~= u383 then
                    return;
                end;

                showCategory();
            end);
        end);
        u309.FocusLost:Connect(function(p385) -- Line: 2750
            -- upvalues: showCategory (copy)
            showCategory();
        end);
    end;
end;

local function setupSell() -- Line: 2756
    -- upvalues: u38 (ref), u36 (ref), u42 (ref), MarketplaceButton (copy), u14 (copy), LocalPlayer (copy), u43 (ref), GlobalMarketplace (copy), u13 (ref), u8 (copy), getWearSearchRangeFromSelection (copy), u33 (ref), CloseButtonRegistry (copy), GamepadNavigation (copy), u21 (copy), InventoryController (copy), createMarketListing (copy), u37 (ref), GetSkinDisplayName (copy), CommaNumber (copy), Constants (copy), removeYourListingByInventoryItemId (copy), MenuState (copy), pruneOldestListingFrames (copy), syncListedItemToProfile (copy), getMarketplaceErrorMessage (copy), Router (copy), CollectionServiceUtility (copy), MarketplaceDropdown (copy)
    u38 = u36.Sell.SellInfo.Container.Template:Clone();
    u36.Sell.SellInfo.Container.Template:Destroy();

    local function confirmSell() -- Line: 2760
        -- upvalues: u36 (ref)
        u36.Sell.Confirm.Visible = true;
    end;

    local function isSetPriceOpen() -- Line: 2764
        -- upvalues: u42 (ref)
        local v386;

        if u42 == nil then
            v386 = false;
        else
            v386 = u42.Parent ~= nil;
        end;

        return v386;
    end;

    MarketplaceButton.new(u36.Sell.Confirm.Action.Frame.Accept, {
        hoverSizeMultiplier = 0.9,

        onActivated = function() -- Line: 2771, Name: onActivated
            -- upvalues: u14 (ref), LocalPlayer (ref), u36 (ref), u43 (ref), GlobalMarketplace (ref), u13 (ref), u8 (ref), getWearSearchRangeFromSelection (ref), u33 (ref)
            local v387 = {};

            for _, v in u14 do
                table.insert(v387, v);
            end;

            if #v387 < 1 then
                return;
            end;

            if not LocalPlayer:GetAttribute("PinVerified") then
                return;
            end;

            u36.Parent.Parent.Loading.Visible = true;
            u43:Play();
            GlobalMarketplace.ListItem.Send(v387);
            u13 = true;
            u8.page = 1;
            u8.wear_range = getWearSearchRangeFromSelection();
            local pattern_range = u8.pattern_range;

            if pattern_range and pattern_range[1] <= 0 then
                u8.pattern_range = nil;
            end;

            GlobalMarketplace.SearchMarket.Send(u8);
            u8.pattern_range = pattern_range;
            u33();
            u36.Sell.Confirm.Visible = false;
        end
    });

    local function closeSellConfirm() -- Line: 2796
        -- upvalues: u36 (ref)
        u36.Sell.Confirm.Visible = false;
    end;

    MarketplaceButton.new(u36.Sell.Confirm.Action.Frame.Decline, {
        hoverSizeMultiplier = 0.9,
        onActivated = closeSellConfirm
    });
    CloseButtonRegistry.Add(u36.Sell.Confirm, nil, closeSellConfirm);
    GamepadNavigation.TrapPopup(u36.Sell.Confirm, function() -- Line: 2808
        -- upvalues: u36 (ref)
        return u36.Sell.Confirm.Action.Frame.Decline;
    end);
    local u388 = 1;
    local u389 = false;
    local u390 = 0;

    local function generatePage(p391: number) -- Line: 2816
        -- upvalues: u389 (ref), u390 (ref), u21 (ref), InventoryController (ref), LocalPlayer (ref), u36 (ref), createMarketListing (ref), u37 (ref), u14 (ref), u38 (ref), GetSkinDisplayName (ref), CommaNumber (ref), Constants (ref), MarketplaceButton (ref), u42 (ref), CloseButtonRegistry (ref), GamepadNavigation (ref), u43 (ref), GlobalMarketplace (ref), removeYourListingByInventoryItemId (ref), MenuState (ref), u388 (ref), pruneOldestListingFrames (ref)
        if u389 then
            return;
        end;

        u389 = true;
        local v392 = u390;
        local v393 = {
            page = p391
        };

        for i, v in u21 do
            v393[i] = v;
        end;

        local TradableInventoryPage = InventoryController:GetTradableInventoryPage(LocalPlayer, v393);

        if v392 ~= u390 or #TradableInventoryPage == 0 then
            u389 = false;

            return;
        end;

        for _, v in TradableInventoryPage do
            if v._id then
                local v394 = u36.Sell.Container:FindFirstChild(v._id) ~= nil;
                local u395 = createMarketListing(u36.Sell.Container, v._id, u37, {
                    inventoryItem = v
                });

                if u395 then
                    local function listItem(p396: number) -- Line: 2850
                        -- upvalues: u14 (ref), v (copy), u395 (copy), u38 (ref), GetSkinDisplayName (ref), CommaNumber (ref), u36 (ref), Constants (ref), MarketplaceButton (ref)
                        if u14[v._id] then
                            return;
                        end;

                        u14[v._id] = {
                            ItemID = v._id,
                            Price = p396,
                            inventoryItem = v
                        };
                        u395.Visible = false;
                        local v397 = v.Skin:split("_PATTERN_")[1];
                        local u398 = u38:Clone();
                        u398.Name = v._id;
                        u398.Skin.Text = v397;
                        GetSkinDisplayName.ApplyNameLabel(u398.Gun, GetSkinDisplayName.GetWeaponDisplayName(v.Name, v.NameTag), v.NameTag);
                        u398.Min.TextBox.Text = CommaNumber(p396);
                        u398.GunSkin.ItemIcon.Image = u395.Main.ItemIcon.Image;
                        u398.GunSkin.RarityFrame.RarityBarGradient.Color = u395.Main.RarityFrame.RarityBarGradient.Color;
                        u398.GunSkin.Serial.SerialText.Text = u395.Main.RarityFrame.Serial.SerialText.Text;
                        u398.GunSkin.Condition.Tag.Text = u395.Main.RarityFrame.Condition.Tag.Text;
                        u398.GunSkin.Condition[`{u395.Main.RarityFrame.Condition.Tag.Text}Gradient`].Enabled = true;
                        u398.Parent = u36.Sell.SellInfo.Container;
                        u398.Min.TextBox.FocusLost:Connect(function() -- Line: 2880
                            -- upvalues: u398 (copy), CommaNumber (ref), u14 (ref), v (ref), Constants (ref)
                            local v399 = tonumber(u398.Min.TextBox.Text);

                            if not v399 then
                                u398.Min.TextBox.Text = CommaNumber(u14[v._id].Price);

                                return;
                            end;

                            local math_clamp_ret = math.clamp(v399, 1, Constants.MARKETPLACE_MAX_LISTING_PRICE);
                            u14[v._id].Price = math_clamp_ret;
                            u398.Min.TextBox.Text = CommaNumber(u14[v._id].Price);
                        end);
                        MarketplaceButton.new(u398.Return, {
                            hoverSizeMultiplier = 0.9,

                            onActivated = function() -- Line: 2895, Name: onActivated
                                -- upvalues: u14 (ref), v (ref), u398 (copy), u36 (ref)
                                u14[v._id] = nil;
                                u398:Destroy();
                                local v400 = u36.Sell.Container:FindFirstChild(v._id);

                                if v400 then
                                    v400.Visible = true;
                                end;
                            end
                        });
                    end;

                    u395.Visible = u14[v._id] == nil;
                    u395.Main.Sell.Visible = not (v.MetaData and v.MetaData.GlobalMarketPlaceListingReference);
                    u395.Main.Delist.Visible = not u395.Main.Sell.Visible;

                    if not (v394 or u395:GetAttribute("_sellActionsWired")) then
                        u395:SetAttribute("_sellActionsWired", true);
                        MarketplaceButton.new(u395.Main.Sell, {
                            hoverSizeMultiplier = 0.9,

                            onActivated = function() -- Line: 2918, Name: onActivated
                                -- upvalues: u42 (ref), u14 (ref), v (copy), u36 (ref), MarketplaceButton (ref), CloseButtonRegistry (ref), GamepadNavigation (ref), listItem (copy), Constants (ref), CommaNumber (ref)
                                local v401;

                                if u42 == nil then
                                    v401 = false;
                                else
                                    v401 = u42.Parent ~= nil;
                                end;

                                if v401 then
                                    return;
                                end;

                                if u14[v._id] then
                                    return;
                                end;

                                if u42 then
                                    u42:Destroy();
                                end;

                                local u402 = 25;
                                local u403 = u36.Sell.SetPrice:Clone();
                                u42 = u403;
                                u403.Visible = true;
                                u403.Parent = u36.Sell;

                                local function declineSetPrice() -- Line: 2937
                                    -- upvalues: u403 (copy)
                                    u403:Destroy();
                                end;

                                MarketplaceButton.new(u403.Action.Frame.Decline, {
                                    hoverSizeMultiplier = 0.9,
                                    onActivated = declineSetPrice
                                });
                                CloseButtonRegistry.Add(u403, nil, declineSetPrice);
                                u403.Destroying:Connect(function() -- Line: 2950
                                    -- upvalues: CloseButtonRegistry (ref), u403 (copy)
                                    CloseButtonRegistry.Remove(u403);
                                end);
                                GamepadNavigation.TrapPopup(u403, function() -- Line: 2953
                                    -- upvalues: u403 (copy)
                                    return u403.Action.Frame.Accept;
                                end);
                                MarketplaceButton.new(u42.Action.Frame.Accept, {
                                    hoverSizeMultiplier = 0.9,

                                    onActivated = function() -- Line: 2960, Name: onActivated
                                        -- upvalues: listItem (ref), u402 (ref), u42 (ref), GamepadNavigation (ref), u36 (ref)
                                        listItem(u402);
                                        u42:Destroy();
                                        GamepadNavigation.Focus(u36.Sell.SellInfo.Sell);
                                    end
                                });

                                local function applyTypedPrice(p404: number, p405: boolean) -- Line: 2970
                                    -- upvalues: u402 (ref), Constants (ref), u42 (ref), CommaNumber (ref)
                                    u402 = math.clamp(p404, 1, Constants.MARKETPLACE_MAX_LISTING_PRICE);
                                    local math_floor_ret = math.floor(u402 * (Constants.MARKET_TAX_PERCENT / 100));

                                    if p405 then
                                        u42.Price.Frame.SearchBox.Text = CommaNumber(u402);
                                    end;

                                    u42.List.ListedPrice.TextLabel.Text = CommaNumber(u402);
                                    u42.List.Tax.TextLabel.Text = `-{CommaNumber(math_floor_ret)}`;
                                    u42.List.Total.TextLabel.Text = CommaNumber(u402 - math_floor_ret);
                                end;

                                u42.Price.Frame.SearchBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 2981
                                    -- upvalues: u42 (ref), applyTypedPrice (copy)
                                    local v406 = tonumber(u42.Price.Frame.SearchBox.Text);

                                    if v406 then
                                        applyTypedPrice(v406, false);
                                    end;
                                end);
                                u42.Price.Frame.SearchBox.FocusLost:Connect(function() -- Line: 2988
                                    -- upvalues: u42 (ref), CommaNumber (ref), u402 (ref), applyTypedPrice (copy)
                                    local v407 = tonumber(u42.Price.Frame.SearchBox.Text);

                                    if v407 then
                                        applyTypedPrice(v407, true);

                                        return;
                                    end;

                                    u42.Price.Frame.SearchBox.Text = CommaNumber(u402);
                                end);
                            end
                        });
                        MarketplaceButton.new(u395.Main.Delist, {
                            hoverSizeMultiplier = 0.9,

                            onActivated = function() -- Line: 3002, Name: onActivated
                                -- upvalues: LocalPlayer (ref), u36 (ref), u43 (ref), GlobalMarketplace (ref), v (copy), removeYourListingByInventoryItemId (ref), MenuState (ref), u395 (copy), GamepadNavigation (ref)
                                if not LocalPlayer:GetAttribute("PinVerified") then
                                    return;
                                end;

                                u36.Parent.Parent.Loading.Visible = true;
                                u43:Play();
                                GlobalMarketplace.DelistItem.Send(v._id);
                                removeYourListingByInventoryItemId(v._id);
                                local v408 = MenuState.IsSelectionWithin(u395.Main.Delist);
                                u395.Main.Sell.Visible = true;
                                u395.Main.Delist.Visible = false;

                                if v408 then
                                    GamepadNavigation.Focus(u395.Main.Sell);
                                end;
                            end
                        });
                    end;
                end;
            end;
        end;

        u388 = p391 + 1;
        pruneOldestListingFrames(u36.Sell.Container, 96);

        if v392 == u390 then
            u389 = false;
        end;
    end;

    u36.Sell.SetPrice.List.Tax.text.Text = `Tax ({Constants.MARKET_TAX_PERCENT}%)`;
    local os_clock_ret = os.clock();
    u36.Sell.Container:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 3030
        -- upvalues: u36 (ref), os_clock_ret (ref), generatePage (copy), u388 (ref)
        local math_max_ret = math.max(0, u36.Sell.Container.AbsoluteCanvasSize.Y - u36.Sell.Container.AbsoluteSize.Y);

        if u36.Sell.Container.CanvasPosition.Y >= math_max_ret - 5 and os.clock() - os_clock_ret > 0.25 then
            generatePage(u388);
            os_clock_ret = os.clock();
        end;
    end);
    MarketplaceButton.new(u36.Sell.SellInfo.Sell, {
        hoverSizeMultiplier = 0.9,

        onActivated = function() -- Line: 3048, Name: onActivated
            -- upvalues: u42 (ref), u36 (ref)
            local v409;

            if u42 == nil then
                v409 = false;
            else
                v409 = u42.Parent ~= nil;
            end;

            if v409 then
                return;
            end;

            u36.Sell.Confirm.Visible = true;
        end
    });
    GlobalMarketplace.ListItemResult.Listen(function(p410) -- Line: 3057
        -- upvalues: u36 (ref), u14 (ref), syncListedItemToProfile (ref), GlobalMarketplace (ref), LocalPlayer (ref), getMarketplaceErrorMessage (ref), Router (ref)
        local v411 = false;

        if p410 and p410.results then
            for _, v in p410.results do
                if v.success then
                    v411 = true;
                    local v412 = v.inventoryItemId or v.inventory_item_id;

                    if typeof(v412) == "string" then
                        if u36.Sell.SellInfo.Container:FindFirstChild(v412) then
                            u36.Sell.SellInfo.Container[v412]:Destroy();
                        end;

                        local v413 = v.listing_reference_id or v.listingReferenceId;

                        if typeof(v413) == "string" and u14[v412] then
                            u14[v412].listingReferenceId = v413;
                        end;

                        syncListedItemToProfile(v);
                        u14[v412] = nil;
                        local v414 = u36.Sell.Container:FindFirstChild(v412);

                        if v414 then
                            v414.Visible = true;
                            v414.Main.Sell.Visible = false;
                            v414.Main.Delist.Visible = true;
                        end;
                    end;
                end;
            end;
        end;

        if v411 then
            GlobalMarketplace.RequestProfileInfo.Send(LocalPlayer.UserId);
        end;

        local v415 = getMarketplaceErrorMessage(p410);

        if not v415 then
            return;
        end;

        Router.broadcastRouter("CreateNotification", "Error", v415);
    end);

    local function refreshInventory() -- Line: 3101
        -- upvalues: u390 (ref), u389 (ref), u36 (ref), u388 (ref), generatePage (copy)
        u390 = u390 + 1;
        u389 = false;
        u36.Sell.Container.CanvasPosition = Vector2.new(0, 0);

        for _, child in u36.Sell.Container:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        u388 = 1;
        generatePage(u388);
    end;

    local v416 = CollectionServiceUtility.FindDescendantWithTag(u36.Sell.Header.Filters, "Dropdown_Category");

    if v416 then
        MarketplaceDropdown.new(v416, Constants.ITEM_CATEGORIES).OptionSelected:Connect(function(p417) -- Line: 3122
            -- upvalues: u21 (ref), refreshInventory (copy)
            u21.filters = { "Tradable", "MarketplaceListable", p417 };
            refreshInventory();
        end);
    end;

    local v418 = CollectionServiceUtility.FindDescendantWithTag(u36.Sell.Header.Filters, "Dropdown_SortType");

    if v418 then
        MarketplaceDropdown.new(v418, Constants.INVENTORY_SORTING_OPTIONS).OptionSelected:Connect(function(p419) -- Line: 3133
            -- upvalues: u21 (ref), refreshInventory (copy)
            u21.sort = p419;
            refreshInventory();
        end);
    end;

    local u420 = CollectionServiceUtility.FindDescendantWithTag(u36.Sell.Header.Filters, "ReverseSort");

    if u420 then
        u420.Activated:Connect(function() -- Line: 3142, Name: toggleReverseSorting
            -- upvalues: u21 (ref), u420 (copy), refreshInventory (copy)
            u21.sortReversed = not u21.sortReversed;
            local v421 = u420:FindFirstChildOfClass("ImageLabel");

            if v421 then
                v421.Rotation = u21.sortReversed and 180 or 0;
            end;

            refreshInventory();
        end);
        local v422 = u420:FindFirstChildOfClass("ImageLabel");

        if v422 then
            v422.Rotation = u21.sortReversed and 180 or 0;
        end;
    end;

    local u423 = CollectionServiceUtility.FindDescendantWithTag(u36.Sell.Header.Filters, "SearchBox");

    if u423 then
        u423.FocusLost:Connect(function(p424) -- Line: 3161
            -- upvalues: u21 (ref), u423 (copy), refreshInventory (copy)
            u21.searchTerm = u423.Text;
            refreshInventory();
        end);
    end;

    GlobalMarketplace.RefreshInventory.Listen(function() -- Line: 3167
        -- upvalues: refreshInventory (copy)
        refreshInventory();
    end);
    u36.Sell:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3171
        -- upvalues: u36 (ref), refreshInventory (copy)
        if u36.Sell.Visible then
            refreshInventory();
        end;
    end);
    refreshInventory();
end;

local function setupProfile() -- Line: 3180
    -- upvalues: u39 (ref), ReplicatedStorage (copy), u40 (ref), u41 (ref), u36 (ref), GlobalMarketplace (copy), CommaNumber (copy), GetSkinDisplayName (copy), formatSaleDate (copy), MarketplaceButton (copy), showInspect (copy), addYourListing (copy), LocalPlayer (copy), UserCache (copy), Players (copy), setOnlineStatus (copy), u46 (ref), u45 (ref), UserInputService (copy), u23 (ref)
    u39 = ReplicatedStorage.Assets.TradingUI.Templates.SaleTemplate:Clone();
    u40 = ReplicatedStorage.Assets.TradingUI.Templates.ListingTemplate:Clone();
    u41 = ReplicatedStorage.Assets.TradingUI.Templates.SaleTemplate_Old:Clone();
    u36.Profile.Main.Frame.YourListings.Transactions.Listings.Template:Destroy();
    local Header = u36.Profile.Main.Frame.Header;

    local function setProfileBadge(p425) -- Line: 3187
        -- upvalues: u36 (ref)
        local Badge = u36.Profile.Main.ProfileInfo.Player:FindFirstChild("Badge");

        if not (Badge and (Badge:IsA("ImageLabel") or Badge:IsA("ImageButton"))) then
            return;
        end;

        Badge.Image = not p425 and "" or `rbxassetid://{p425}`;
    end;

    local function filterListings(p426: string) -- Line: 3196
        -- upvalues: u36 (ref)
        for _, child in u36.Profile.Main.Frame.YourListings.Transactions.Listings:GetChildren() do
            if child:IsA("Frame") and child:FindFirstChild("State") then
                local v427;

                if p426 == "ALL" or p426 == "SOLD" and child.State.Text == "Sold" then
                    v427 = true;
                elseif p426 == "PURCHASED" then
                    v427 = child.State.Text == "Purchased";
                else
                    v427 = false;
                end;

                child.Visible = v427;
            end;
        end;

        for _, child in u36.Profile.Main.Frame.YourListings.Transactions.TopSelect.Container:GetChildren() do
            if child:IsA("TextButton") then
                child.Frame.Visible = child.Name == p426;
            end;
        end;
    end;

    GlobalMarketplace.ProfileInfo.Listen(function(p428: table) -- Line: 3221
        -- upvalues: u36 (ref), CommaNumber (ref), u41 (ref), GetSkinDisplayName (ref), formatSaleDate (ref), MarketplaceButton (ref), showInspect (ref), addYourListing (ref), LocalPlayer (ref), UserCache (ref), Players (ref), setProfileBadge (copy), setOnlineStatus (ref), u46 (ref), u45 (ref)
        if not p428.success then
            return;
        end;

        for _, child in u36.Profile.Main.Frame.YourListings.Transactions.Listings:GetChildren() do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        u36.Profile.Main.ProfileInfo.Earnings.List.Purchases.Credits.TextLabel.Text = CommaNumber(p428.purchases);
        u36.Profile.Main.ProfileInfo.Earnings.List.Sales.Credits.TextLabel.Text = CommaNumber(p428.sales_revenue);
        u36.Profile.Main.ProfileInfo.Earnings.List.Net.Credits.TextLabel.Text = CommaNumber(p428.net_revenue);
        u36.Profile.Main.ProfileInfo.Earnings.List.Net.Credits.TextLabel.TextColor3 = p428.net_revenue > 0 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0);

        for _, v in p428.transactions do
            if not u36.Profile.Main.Frame.YourListings.Transactions.Listings:FindFirstChild(v.listing_reference_id) then
                local v429 = u41:Clone();
                v429.Name = v.listing_reference_id;
                v429.State.Text = v.role == "seller" and "Sold" or "Purchased";
                local inventoryItem = v.inventoryItem;
                local listing_reference_id = v.listing_reference_id;

                if inventoryItem then
                    local v430 = inventoryItem.StatTrack and true or false;
                    listing_reference_id = GetSkinDisplayName.GetFullItemDisplayName(inventoryItem.Name, inventoryItem.Skin, v430, true, inventoryItem.NameTag);

                    if listing_reference_id == "" then
                        listing_reference_id = `{v430 and "KillTrak™ " or ""}{GetSkinDisplayName.GetWeaponDisplayName(inventoryItem.Name, inventoryItem.NameTag)} | {inventoryItem.Skin}`;
                    end;
                end;

                local v431;

                if inventoryItem then
                    v431 = inventoryItem.NameTag;
                else
                    v431 = inventoryItem;
                end;

                GetSkinDisplayName.ApplyNameLabel(v429.GunName, listing_reference_id, v431);
                v429.Serial.Text = not (inventoryItem and inventoryItem.Serial) and "N/A" or `#{CommaNumber(inventoryItem.Serial)}`;
                v429.Date.Text = formatSaleDate(v.date);
                v429.Credits.TextLabel.Text = CommaNumber(v.tradeTokens);
                v429.Parent = u36.Profile.Main.Frame.YourListings.Transactions.Listings;
                local v432;

                if inventoryItem == nil then
                    v432 = false;
                else
                    local Type = inventoryItem.Type;
                    v432 = not (Type == "Case" and true or Type == "Package");
                end;

                local Info = v429:FindFirstChild("Info");
                local ExtraHide = v429:FindFirstChild("ExtraHide");

                if Info and Info:IsA("GuiButton") then
                    Info.Visible = v432;

                    if inventoryItem and v432 then
                        MarketplaceButton.new(Info, {
                            hoverSizeMultiplier = 0.9,

                            onActivated = function() -- Line: 3297, Name: onActivated
                                -- upvalues: showInspect (ref), inventoryItem (copy)
                                showInspect(inventoryItem);
                            end
                        });
                    end;
                end;

                if ExtraHide and ExtraHide:IsA("GuiObject") then
                    ExtraHide.Visible = not v432;
                end;
            end;
        end;

        for _, v in p428.listings do
            if v.inventoryItem then
                addYourListing(v);
            end;
        end;

        local v433 = tonumber(p428.SearchedUser) or LocalPlayer.UserId;
        local v434 = UserCache.Fetch(v433);
        u36.Profile.Main.ProfileInfo.Player.Player.Image = Players:GetUserThumbnailAsync(v433, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420 or Enum.ThumbnailSize.Size180x180);
        u36.Profile.Main.ProfileInfo.Player.DisplayName.Text = v434.DisplayName;
        u36.Profile.Main.ProfileInfo.Player.Username.Text = `@{v434.Username}`;
        setProfileBadge(p428.equippedBadge and p428.equippedBadge.imageAssetId);
        local Last = u36.Profile.Main.ProfileInfo.Player.Last;
        local status = p428.status;

        if status and status.isActiveSession then
            setOnlineStatus(Last);

            return;
        end;

        if not (status and status.lastSessionAt) then
            if u46 then
                u46();
                u46 = nil;
            end;

            if u45 then
                u45:Cancel();
                u45 = nil;
            end;

            Last.TextTransparency = 0;
            local OnlinePulseDot = Last:FindFirstChild("OnlinePulseDot");

            if OnlinePulseDot and OnlinePulseDot:IsA("GuiObject") then
                OnlinePulseDot.Visible = false;
            end;

            Last.Text = "Never Active";
            Last.TextColor3 = Color3.fromRGB(100, 0, 0);

            return;
        end;

        local lastSessionAt = status.lastSessionAt;
        local v435 = `{os.date("%B", lastSessionAt)} {os.date("%d", lastSessionAt)}, {os.date("%Y", lastSessionAt)}`;

        if u46 then
            u46();
            u46 = nil;
        end;

        if u45 then
            u45:Cancel();
            u45 = nil;
        end;

        Last.TextTransparency = 0;
        local OnlinePulseDot = Last:FindFirstChild("OnlinePulseDot");

        if OnlinePulseDot and OnlinePulseDot:IsA("GuiObject") then
            OnlinePulseDot.Visible = false;
        end;

        Last.Text = `Last Online: {v435}`;
        Last.TextColor3 = Color3.fromRGB(136, 136, 136);
    end);

    for _, child in u36.Profile.Main.Frame.YourListings.Transactions.TopSelect.Container:GetChildren() do
        if child:IsA("TextButton") then
            MarketplaceButton.new(child, {
                hoverSizeMultiplier = 0.9,

                onActivated = function() -- Line: 3348, Name: onActivated
                    -- upvalues: filterListings (copy), child (copy)
                    filterListings(child.Name);
                end
            });
        end;
    end;

    GlobalMarketplace.PurchasedItem.Listen(function(p436: string) -- Line: 3354
        -- upvalues: GlobalMarketplace (ref), LocalPlayer (ref), u36 (ref)
        GlobalMarketplace.RequestProfileInfo.Send(LocalPlayer.UserId);
        local v437 = u36.Market.Container:FindFirstChild(p436);

        if v437 then
            v437:Destroy();
        end;
    end);
    u36.Profile.Main.ProfileInfo.Player.Player.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420 or Enum.ThumbnailSize.Size180x180);
    u36.Profile.Main.ProfileInfo.Player.DisplayName.Text = LocalPlayer.DisplayName;
    u36.Profile.Main.ProfileInfo.Player.Username.Text = `@{LocalPlayer.Name}`;
    local u438 = { "Transactions", "YourListings" };

    for _, v in u438 do
        MarketplaceButton.new(Header.TopSelect.Container[v], {
            hoverSizeMultiplier = 0.9,

            onActivated = function() -- Line: 3374, Name: onActivated
                -- upvalues: u438 (copy), Header (copy), v (copy), u36 (ref)
                for _, v2 in u438 do
                    Header.TopSelect.Container[v2].Frame.Visible = v2 == v;
                    u36.Profile.Main.Frame.YourListings[v2].Visible = v2 == v;
                end;

                for _, child in u36.Profile.Main.Frame.YourListings.Header:GetChildren() do
                    if child:IsA("TextLabel") then
                        child.Visible = v == "Transactions";
                    end;
                end;
            end
        });
    end;

    UserInputService.InputBegan:Connect(function(p439: userdata) -- Line: 3390
        -- upvalues: u23 (ref), u36 (ref)
        if p439.KeyCode == Enum.KeyCode.Tab and u23 then
            task.wait(0.1);
            u36.Market.Filters.Container.Search.Frame.SearchBox.Text = u23;
            u23 = nil;
        end;
    end);
end;

local function fetchMarketOnOpen() -- Line: 3404
    -- upvalues: u5 (ref), u36 (ref), u43 (ref), u8 (copy), u13 (ref), getWearSearchRangeFromSelection (copy), GlobalMarketplace (copy), u33 (ref)
    if u5 or not (u36 and u43) then
        return;
    end;

    u5 = true;
    u8.page = 1;
    u36.Parent.Parent.Loading.Visible = true;
    u43:Play();
    u13 = true;
    u8.wear_range = getWearSearchRangeFromSelection();
    local pattern_range = u8.pattern_range;

    if pattern_range and pattern_range[1] <= 0 then
        u8.pattern_range = nil;
    end;

    GlobalMarketplace.SearchMarket.Send(u8);
    u8.pattern_range = pattern_range;
    u33();
end;

local function focusMarketplaceOnOpen() -- Line: 3425
    -- upvalues: u36 (ref), u32 (ref), MenuState (copy), GamepadNavigation (copy), u20 (copy)
    if not u36.Visible or u36.Pin.Visible then
        return;
    end;

    local v440 = u32;
    u32 = nil;

    if MenuState.IsNavigationSelectionHeld() or MenuState.IsSelectionWithin(u36) then
        return;
    end;

    if v440 and (GamepadNavigation.IsUsable(v440) and GamepadNavigation.Focus(v440)) then
        return;
    end;

    local PurchaseMenu = u36.Market.PurchaseMenu;

    if PurchaseMenu.Visible and GamepadNavigation.Focus(PurchaseMenu) then
        return;
    end;

    for _, v in u20 do
        if u36[v].Visible then
            GamepadNavigation.Focus(u36.Top.Frame:FindFirstChild(v));

            return;
        end;
    end;
end;

local function closeMarketPopups() -- Line: 3454
    -- upvalues: u32 (ref), u24 (ref), u22 (ref), u36 (ref), hideQuickPick (copy), u42 (ref)
    u32 = nil;
    u24 = nil;

    if u22 then
        u22:Destroy();
        u22 = nil;
    end;

    u36.Market.PurchaseMenu.Confirm.Visible = false;
    u36.Market.PurchaseMenu.Visible = false;
    u36.Market.Confirm.Visible = false;
    hideQuickPick();
    u36.Sell.Confirm.Visible = false;

    if u42 then
        u42:Destroy();
    end;
end;

local function onVisibilityChanged(p441: boolean) -- Line: 3468
    -- upvalues: u36 (ref), u28 (ref), u34 (ref), u5 (ref), u43 (ref), u8 (copy), u13 (ref), getWearSearchRangeFromSelection (copy), GlobalMarketplace (copy), u33 (ref), LocalPlayer (copy), focusMarketplaceOnOpen (copy), u27 (ref), u29 (ref), u35 (ref), MenuState (copy), u32 (ref), u24 (ref), u22 (ref), hideQuickPick (copy), u42 (ref), MarketplaceHover (copy)
    if not u36 then
        return;
    end;

    if p441 then
        local v442 = u28;
        u28 = nil;

        if not (v442 and u34(v442.ItemName, v442.SkinName, v442.Details) or (u5 or not (u36 and u43))) then
            u5 = true;
            u8.page = 1;
            u36.Parent.Parent.Loading.Visible = true;
            u43:Play();
            u13 = true;
            u8.wear_range = getWearSearchRangeFromSelection();
            local pattern_range = u8.pattern_range;

            if pattern_range and pattern_range[1] <= 0 then
                u8.pattern_range = nil;
            end;

            GlobalMarketplace.SearchMarket.Send(u8);
            u8.pattern_range = pattern_range;
            u33();
        end;

        u36.Pin.Visible = LocalPlayer:GetAttribute("PinVerified") == false;
        task.defer(focusMarketplaceOnOpen);

        return;
    end;

    u27 = nil;
    u28 = nil;

    if u29 then
        u29 = false;
        u35();
    end;

    if not MenuState.IsInspectActive() then
        u32 = nil;
        u24 = nil;

        if u22 then
            u22:Destroy();
            u22 = nil;
        end;

        u36.Market.PurchaseMenu.Confirm.Visible = false;
        u36.Market.PurchaseMenu.Visible = false;
        u36.Market.Confirm.Visible = false;
        hideQuickPick();
        u36.Sell.Confirm.Visible = false;

        if u42 then
            u42:Destroy();
        end;
    end;

    if u43 then
        u36.Pin.Visible = false;
        MarketplaceHover:Close();
        u36.Parent.Parent.Loading.Visible = false;
        u43:Pause();
    end;
end;

local function isExcludedIndexSchema(p443) -- Line: 3511
    -- upvalues: table_freeze_ret (copy)
    return table_freeze_ret[p443.name] == true and true or table_freeze_ret[p443.type] == true;
end;

local function setQuickFilterDropdownSelection(p444: string, p445: string) -- Line: 3515
    -- upvalues: u11 (copy)
    local v446 = u11[p444];

    if v446 then
        v446:SelectOption(p445);
    end;
end;

local function setQuickPatternRange(p447: string?) -- Line: 3522
    -- upvalues: u8 (copy), CollectionService (copy), setDrag (copy)
    local v448 = tonumber(p447);
    u8.pattern_range = v448 and { v448, v448 } or { 0, 11 };

    for _, v in CollectionService:GetTagged("pattern_range") do
        if v448 then
            setDrag(v, v448, "StartPin", 11);
            setDrag(v, v448, "EndPin", 11);
        else
            setDrag(v, 0, "StartPin", 11);
            setDrag(v, 11, "EndPin", 11);
        end;
    end;
end;

local function setQuickWearTier(p449: any, p450: number?) -- Line: 3539
    -- upvalues: Skins (copy), u15 (copy), u17 (copy), setWearTierVisual (copy), getWearSearchRangeFromSelection (copy), setWearRange (copy), u8 (copy)
    local v451;

    if p450 then
        v451 = Skins.GetWearNameForFloat(p449, p450);
    else
        v451 = nil;
    end;

    for _, v in u15 do
        local v452;

        if v451 == nil then
            v452 = false;
        else
            v452 = v.wear == v451;
        end;

        u17[v.key] = v452;
        setWearTierVisual(v.key, u17[v.key]);
    end;

    local v453 = getWearSearchRangeFromSelection();
    local v454 = v453[2];

    if v454 < 1 then
        v454 = v454 + 1e-12;
    end;

    setWearRange(v453[1], v454);
    u8.wear_range = getWearSearchRangeFromSelection();
end;

local function setQuickStatTrak(p455: boolean?) -- Line: 3549
    -- upvalues: u8 (copy), u30 (ref)
    u8.statTrak = p455 and true or nil;

    if u30 then
        u30.Visible = p455 == true;
    end;
end;

local function clearQuickNarrowing() -- Line: 3558
    -- upvalues: u31 (ref), u15 (copy), u17 (copy), setWearTierVisual (copy), getWearSearchRangeFromSelection (copy), setWearRange (copy), u8 (copy), u30 (ref)
    if not u31 then
        return;
    end;

    u31 = false;

    for _, v in u15 do
        u17[v.key] = false;
        setWearTierVisual(v.key, u17[v.key]);
    end;

    local v456 = getWearSearchRangeFromSelection();
    local v457 = v456[2];

    if v457 < 1 then
        v457 = v457 + 1e-12;
    end;

    setWearRange(v456[1], v457);
    u8.wear_range = getWearSearchRangeFromSelection();
    u8.statTrak = nil;

    if u30 then
        u30.Visible = false;
    end;
end;

u35 = function() -- Line: 3569, Name: resetQuickSearchFilters
    -- upvalues: u8 (copy), setQuickPatternRange (copy), u31 (ref), u15 (copy), u17 (copy), setWearTierVisual (copy), getWearSearchRangeFromSelection (copy), setWearRange (copy), u30 (ref), u36 (ref), u11 (copy), u5 (ref)
    u8.search_bar_query = "";
    u8.rarity = nil;
    u8.Collection = nil;
    u8.page = 1;
    setQuickPatternRange(nil);

    if u31 then
        u31 = false;

        for _, v in u15 do
            u17[v.key] = false;
            setWearTierVisual(v.key, u17[v.key]);
        end;

        local v458 = getWearSearchRangeFromSelection();
        local v459 = v458[2];

        if v459 < 1 then
            v459 = v459 + 1e-12;
        end;

        setWearRange(v458[1], v459);
        u8.wear_range = getWearSearchRangeFromSelection();
        u8.statTrak = nil;

        if u30 then
            u30.Visible = false;
        end;
    end;

    if u36 then
        u36.Market.Filters.Container.Search.Frame.SearchBox.Text = "";
        u36.Market.Filters.Container.Search.Frame.Auto.Text = "";
    end;

    local collection_dropdown = u11.collection_dropdown;

    if collection_dropdown then
        collection_dropdown:SelectOption("All");
    end;

    local rarity_dropdown = u11.rarity_dropdown;

    if rarity_dropdown then
        rarity_dropdown:SelectOption("All");
    end;

    u5 = false;
end;

local function dispatchQuickSearch() -- Line: 3591
    -- upvalues: u8 (copy), u13 (ref), u5 (ref), u29 (ref), MenuState (copy), u36 (ref), u10 (ref), hideQuickPick (copy), GamepadNavigation (copy), u43 (ref), GlobalMarketplace (copy), u33 (ref)
    u8.page = 1;
    u8.uiCategorySearch = true;
    u13 = true;
    u5 = true;
    u29 = true;
    local v460 = MenuState.IsSelectionWithin(u36.Market.Header.Guns);
    local v461 = u10;
    hideQuickPick();

    if v460 and v461 then
        GamepadNavigation.Focus(u36.Market.Header.Filters:FindFirstChild(v461));
    end;

    u36.Parent.Parent.Loading.Visible = true;
    u43:Play();
    local pattern_range = u8.pattern_range;

    if pattern_range and pattern_range[1] <= 0 then
        u8.pattern_range = nil;
    end;

    GlobalMarketplace.SearchMarket.Send(u8);
    u8.pattern_range = pattern_range;
    u33();
    u8.uiCategorySearch = nil;
end;

local function requestQuickItemSearch(p462: any, p463: string?, p464: table?) -- Line: 3614
    -- upvalues: u8 (copy), u11 (copy), u36 (ref), setQuickPatternRange (copy), u31 (ref), setQuickWearTier (copy), u30 (ref), u15 (copy), u17 (copy), setWearTierVisual (copy), getWearSearchRangeFromSelection (copy), setWearRange (copy), dispatchQuickSearch (copy)
    local v465;

    if p462.collection and p462.collection ~= "" then
        v465 = p462.collection;
    else
        v465 = nil;
    end;

    u8.Collection = v465;
    local v466 = u8.Collection or "All";
    local collection_dropdown = u11.collection_dropdown;

    if collection_dropdown then
        collection_dropdown:SelectOption(v466);
    end;

    u8.search_bar_query = p462.paintId:gsub(" | ", " ");
    u36.Market.Filters.Container.Search.Frame.SearchBox.Text = u8.search_bar_query;
    u8.rarity = p462.rarity;
    local rarity = p462.rarity;
    local rarity_dropdown = u11.rarity_dropdown;

    if rarity_dropdown then
        rarity_dropdown:SelectOption(rarity);
    end;

    setQuickPatternRange(p463);

    if p464 then
        u31 = true;
        setQuickWearTier(p462, p464.Float);
        local StatTrak = p464.StatTrak;
        u8.statTrak = StatTrak and true or nil;

        if u30 then
            u30.Visible = StatTrak == true;
        end;
    elseif u31 then
        u31 = false;

        for _, v in u15 do
            u17[v.key] = false;
            setWearTierVisual(v.key, u17[v.key]);
        end;

        local v467 = getWearSearchRangeFromSelection();
        local v468 = v467[2];

        if v468 < 1 then
            v468 = v468 + 1e-12;
        end;

        setWearRange(v467[1], v468);
        u8.wear_range = getWearSearchRangeFromSelection();
        u8.statTrak = nil;

        if u30 then
            u30.Visible = false;
        end;
    end;

    dispatchQuickSearch();
end;

local function requestQuickCaseSearch(p469) -- Line: 3639
    -- upvalues: u8 (copy), u11 (copy), u36 (ref), u31 (ref), u15 (copy), u17 (copy), setWearTierVisual (copy), getWearSearchRangeFromSelection (copy), setWearRange (copy), u30 (ref), setQuickPatternRange (copy), dispatchQuickSearch (copy)
    u8.Collection = nil;
    local collection_dropdown = u11.collection_dropdown;

    if collection_dropdown then
        collection_dropdown:SelectOption("All");
    end;

    u8.search_bar_query = p469.name;
    u36.Market.Filters.Container.Search.Frame.SearchBox.Text = u8.search_bar_query;
    u8.rarity = nil;
    local rarity_dropdown = u11.rarity_dropdown;

    if rarity_dropdown then
        rarity_dropdown:SelectOption("All");
    end;

    if u31 then
        u31 = false;

        for _, v in u15 do
            u17[v.key] = false;
            setWearTierVisual(v.key, u17[v.key]);
        end;

        local v470 = getWearSearchRangeFromSelection();
        local v471 = v470[2];

        if v471 < 1 then
            v471 = v471 + 1e-12;
        end;

        setWearRange(v470[1], v471);
        u8.wear_range = getWearSearchRangeFromSelection();
        u8.statTrak = nil;

        if u30 then
            u30.Visible = false;
        end;
    end;

    u8.statTrak = nil;
    u8.wear_range = { 0, 1 };
    setQuickPatternRange(nil);
    dispatchQuickSearch();
end;

local function isQuickSearchable(p472: string, p473: string) -- Line: 3658
    -- upvalues: Skins (copy), Cases (copy)
    return Skins.GetSkinInformation(p472, p473) ~= nil and true or Cases.GetCaseByName(p473) ~= nil;
end;

u34 = function(p474: string, p475: string, p476: table?) -- Line: 3662, Name: selectQuickItem
    -- upvalues: Skins (copy), requestQuickItemSearch (copy), Cases (copy), requestQuickCaseSearch (copy)
    local SkinInformation = Skins.GetSkinInformation(p474, p475);

    if SkinInformation then
        local _, v477 = table.unpack(SkinInformation.skin:split("_PATTERN_"));
        requestQuickItemSearch(SkinInformation, v477, p476);

        return true;
    end;

    local CaseByName = Cases.GetCaseByName(p475);

    if not CaseByName then
        return false;
    end;

    requestQuickCaseSearch(CaseByName);

    return true;
end;

function v47.SearchForItem(p478: string, p479: string, p480: table?) -- Line: 3682
    -- upvalues: u36 (ref), Skins (copy), Cases (copy), u34 (ref), u28 (ref)
    if not u36 then
        return false;
    end;

    if Skins.GetSkinInformation(p478, p479) == nil and Cases.GetCaseByName(p479) == nil then
        return false;
    end;

    if u36.Visible then
        return u34(p478, p479, p480);
    end;

    u28 = {
        ItemName = p478,
        SkinName = p479,
        Details = p480
    };

    return true;
end;

function v47.SetReturnScreen(p481: string?) -- Line: 3700
    -- upvalues: u27 (ref)
    u27 = p481;
end;

local function buildGuns(p482: string, p483: string) -- Line: 3704
    -- upvalues: u36 (ref), u9 (ref), MarketPlacePrices (copy), Skins (copy), getRarityData (copy), ReplicatedStorage (copy), GetSkinDisplayName (copy), CommaNumber (copy), LocalPlayer (copy), MarketplaceButton (copy), MarketplaceHover (copy), UserInputService (copy), u34 (ref), showInspect (copy)
    local Guns = u36.Market.Header.Guns;

    for _, child in Guns.TopSelect.Container:GetChildren() do
        if child:IsA("TextButton") then
            child.Frame.Visible = child.Name == p483;
        end;
    end;

    for _, child in Guns.Frame:GetChildren() do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    local v484 = {};

    for i, v in u9[p482] do
        if p483 == "ALL" or i == p483 then
            for _, v2 in v do
                table.insert(v484, v2);
            end;
        end;
    end;

    local u485 = {};

    for _, v in v484 do
        local _id = v._id;
        local ItemPrice = MarketPlacePrices.GetItemPrice(v.Name, v.Skin, v.Float, false);

        if ItemPrice then
            ItemPrice = ItemPrice.recentAveragePriceTradeTokens;
        end;

        local v486;

        if ItemPrice and ItemPrice > 0 then
            v486 = math.floor(ItemPrice);
        else
            v486 = nil;
        end;

        u485[_id] = v486 or 0;
    end;

    table.sort(v484, function(p487, p488) -- Line: 3733
        -- upvalues: u485 (copy)
        local v489 = u485[p487._id] or 0;
        local v490 = u485[p488._id] or 0;

        if v489 == v490 then
            return string.lower((`{p487.Name} | {p487.Skin}`)) < string.lower((`{p488.Name} | {p488.Skin}`));
        end;

        return v490 < v489;
    end);

    for _, v in v484 do
        local SkinInformation = Skins.GetSkinInformation(v.Name, v.Skin);

        if SkinInformation then
            local table_unpack_ret, v491 = table.unpack(SkinInformation.skin:split("_PATTERN_"));
            local v492 = getRarityData(SkinInformation.rarity);
            local u493 = ReplicatedStorage.Assets.TradingUI.Templates.QuickTemplate:Clone();
            u493.Name = v._id;
            local WeaponDisplayName = GetSkinDisplayName.GetWeaponDisplayName(v.Name, v.NameTag);
            local ApplyNameLabel = GetSkinDisplayName.ApplyNameLabel;
            local Skin = u493.Skin;
            local v494;

            if v491 then
                v494 = `{WeaponDisplayName} | {table_unpack_ret} {v491}`;
            else
                v494 = `{WeaponDisplayName} | {table_unpack_ret}`;
            end;

            ApplyNameLabel(Skin, v494, v.NameTag);
            u493.RarityBG.RarityBarGradient.Color = v492.ColorSequence;
            u493.RarityFrame.RarityBarGradient.Color = v492.ColorSequence;
            local Status = u493.Status;
            local ItemPrice = MarketPlacePrices.GetItemPrice(v.Name, v.Skin, v.Float, false);

            if ItemPrice then
                ItemPrice = ItemPrice.recentAveragePriceTradeTokens;
            end;

            local v495;

            if ItemPrice and ItemPrice > 0 then
                v495 = math.floor(ItemPrice);
            else
                v495 = nil;
            end;

            Status.Text = `RAP: {not v495 and "N/A" or CommaNumber(v495)}`;
            local u496 = {
                Charm = false,
                IsTradeable = true,
                Serial = 1,
                __v = 0,
                StatTrack = false,
                NameTag = false,
                HideWearDetails = true,
                ShowFullPriceRange = true,
                Float = v.Float or 0,
                MetaData = {
                    Origin = "Unboxed",
                    CreatedAt = os.time(),
                    LastTradeAt = os.time(),
                    TradeHistory = {},
                    OriginalOwner = LocalPlayer.UserId,
                    Owner = LocalPlayer.UserId
                },
                Name = SkinInformation.name,
                Skin = SkinInformation.skin,
                Pattern = tonumber(v491) or 1,
                Rarity = SkinInformation.rarity,
                Type = SkinInformation.type,
                _id = v._id,
                Stickers = {}
            };
            u493.ItemIcon.Image = Skins.GetItemIconImage(SkinInformation, u496);
            u493.Active = true;
            u493.Selectable = true;
            u493.Parent = Guns.Frame;
            local UserDescription = u493.Tools:FindFirstChild("UserDescription");

            if UserDescription and UserDescription:IsA("GuiButton") then
                UserDescription.Visible = true;
                MarketplaceButton.new(UserDescription, {
                    hoverSizeMultiplier = 0.9,

                    onActivated = function() -- Line: 3801, Name: onActivated
                        -- upvalues: MarketplaceHover (ref), u496 (copy), u493 (copy)
                        MarketplaceHover:OpenTradeInfo(u496, u493);
                    end
                });

                if not UserInputService.TouchEnabled then
                    UserDescription.MouseEnter:Connect(function() -- Line: 3806
                        -- upvalues: MarketplaceHover (ref), u496 (copy), u493 (copy)
                        MarketplaceHover:Open(u496, u493);
                    end);
                    UserDescription.MouseLeave:Connect(function() -- Line: 3809
                        -- upvalues: MarketplaceHover (ref), u493 (copy)
                        MarketplaceHover:Close(u493);
                    end);
                end;
            end;

            local Type = u496.Type;
            u493.Tools.Inspect.Visible = Type ~= "Case" and Type ~= "Package";
            u493.Activated:Connect(function() -- Line: 3818
                -- upvalues: u34 (ref), v (copy)
                u34(v.Name, v.Skin);
            end);
            MarketplaceButton.new(u493.Tools.Inspect, {
                hoverSizeMultiplier = 0.9,

                onActivated = function() -- Line: 3825, Name: onActivated
                    -- upvalues: showInspect (ref), u496 (copy)
                    showInspect(u496);
                end
            });
        end;
    end;
end;

local function switchQuickTab(u497: string) -- Line: 3832
    -- upvalues: u9 (ref), u36 (ref), ReplicatedStorage (copy), MarketplaceButton (copy), buildGuns (copy)
    if not u9[u497] then
        return;
    end;

    local Guns = u36.Market.Header.Guns;

    for _, child in Guns.Frame:GetChildren() do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    for _, child in Guns.TopSelect.Container:GetChildren() do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;

    local v498 = {};

    for i in u9[u497] do
        table.insert(v498, i);
    end;

    table.sort(v498, function(p499, p500) -- Line: 3854
        if p499 == "ALL" then
            return true;
        end;

        if p500 == "ALL" then
            return false;
        end;

        return p499:lower() < p500:lower();
    end);

    for _, v in v498 do
        local v501 = ReplicatedStorage.Assets.TradingUI.Templates.GunTemplate:Clone();
        v501.LayoutOrder = v == "ALL" and 0 or 1;
        v501.Name = v;
        v501.Title.Text = v;
        v501.Parent = Guns.TopSelect.Container;
        MarketplaceButton.new(v501, {
            hoverSizeMultiplier = 0.9,

            onActivated = function() -- Line: 3873, Name: onActivated
                -- upvalues: buildGuns (ref), u497 (copy), v (copy)
                buildGuns(u497, v);
            end
        });
    end;

    buildGuns(u497, "ALL");
    Guns.Frame.CanvasPosition = Vector2.zero;
    Guns.Visible = true;
end;

local function openQuickCategory(p502: string) -- Line: 3884
    -- upvalues: u9 (ref), u10 (ref), switchQuickTab (copy), u36 (ref)
    if not u9[p502] then
        return false;
    end;

    u10 = p502;
    switchQuickTab(p502);

    for _, child in u36.Market.Header.Filters:GetChildren() do
        if child:IsA("TextButton") then
            child.ImageLabel.Rotation = child.Name == p502 and 180 or 0;
        end;
    end;

    return true;
end;

local function closeMarketplace() -- Line: 3899
    -- upvalues: MarketplaceHover (copy), ReplicatedStorage (copy), u27 (ref)
    MarketplaceHover:Close();
    require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame(u27 or "Dashboard");
end;

function v47.Initialize(p503: userdata, p504: userdata) -- Line: 3912
    -- upvalues: u36 (ref), CommaNumber (copy), DataController (copy), LocalPlayer (copy), PolicyService (copy), u6 (ref), MarketplaceHover (copy), u43 (ref), TweenService (copy), GlobalMarketplace (copy), CloseButtonRegistry (copy), closeMarketplace (copy), setupProfile (copy), setupMarket (copy), setupSell (copy), Skins (copy), u9 (ref), table_freeze_ret (copy), table_freeze_ret3 (copy), GetWeaponProperties (copy), u10 (ref), MenuState (copy), hideQuickPick (copy), GamepadNavigation (copy), openQuickCategory (copy), buildGuns (copy), u8 (copy), Rarities (copy), MarketplaceDropdown (copy), u11 (copy), Collections (copy), MarketplaceButton (copy), u20 (copy), u42 (ref), Players (copy), Remotes (copy), UserInputService (copy), u1 (copy), onVisibilityChanged (copy), u32 (ref), u24 (ref), u22 (ref)
    u36 = p504;
    local TextLabel = u36.Top.TradeTokens:FindFirstChild("TextLabel");
    local v505;

    if TextLabel then
        v505 = TextLabel:IsA("TextLabel");
    else
        v505 = TextLabel;
    end;

    assert(v505, "Marketplace TradeTokens is missing its balance label");

    local function updateTradeTokensBalance(p506) -- Line: 3921
        -- upvalues: TextLabel (copy), CommaNumber (ref)
        local v507 = tonumber(p506) or 0;
        TextLabel.Text = CommaNumber((math.floor(v507)));
    end;

    local v508 = DataController.Get(LocalPlayer, "TradeTokens");
    local v509 = tonumber(v508) or 0;
    TextLabel.Text = CommaNumber((math.floor(v509)));
    DataController.CreateListener(LocalPlayer, "TradeTokens", updateTradeTokensBalance);
    local success, result = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer);

    if success and result then
        u6 = result.ArePaidRandomItemsRestricted == true;
    end;

    local Parent = u36.Parent.Parent;
    local Hover = Parent:FindFirstChild("Hover");

    if Hover and Hover:IsA("GuiObject") then
        MarketplaceHover:Initialize(Hover, u36);
        MarketplaceHover.Start();
    else
        warn("Marketplace hover UI is missing from MainGui");
    end;

    u43 = TweenService:Create(Parent.Loading.Loading, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, (1 / 0)), {
        Rotation = 359
    });
    GlobalMarketplace.EndLoad.Listen(function() -- Line: 3951
        -- upvalues: u36 (ref), u43 (ref)
        u36.Parent.Parent.Loading.Visible = false;
        u43:Pause();
    end);
    CloseButtonRegistry.Add(u36, nil, closeMarketplace);
    setupProfile();
    setupMarket();
    setupSell();
    Skins.ObserveItemStockSchemas(function(p510) -- Line: 3964
        -- upvalues: u9 (ref), table_freeze_ret (ref), table_freeze_ret3 (ref), GetWeaponProperties (ref), Skins (ref)
        u9 = {};

        for _, v in p510 do
            for _, v2 in v do
                if not (table_freeze_ret[v2.name] == true or table_freeze_ret[v2.type] == true or table.find(table_freeze_ret3, v2.skin)) then
                    local v511 = GetWeaponProperties(v2.name);

                    if (not v511 or v511.Class ~= "Grenade") and Skins.IsSkinAvailable(v2.name, v2.skin) then
                        local v512;

                        if v511 then
                            v512 = v511.Type;
                        else
                            v512 = v2.type;
                        end;

                        local v513 = v2.type == "Glove" and "Glove" or v512;

                        if v2.rarity ~= "Stock" and v513 then
                            u9[v513] = u9[v513] or {
                                ALL = {}
                            };
                            u9[v513][v2.name] = u9[v513][v2.name] or {};
                            local v514 = u9[v513][v2.name];
                            local v515 = {
                                HideWearDetails = true,
                                ShowFullPriceRange = true,
                                _id = `index_{v2.name}_{v2.skin}`,
                                Float = v2.floatRange.min,
                                Rarity = v2.rarity,
                                Name = v2.name,
                                Skin = v2.skin
                            };
                            local v516;

                            if v511 then
                                v516 = v511.Class;
                            else
                                v516 = v2.type;
                            end;

                            v515.Type = v516;
                            table.insert(v514, v515);
                        end;
                    end;
                end;
            end;
        end;
    end);
    local Guns = u36.Market.Header.Guns;

    local function closeQuickPick() -- Line: 4007
        -- upvalues: u10 (ref), MenuState (ref), Guns (copy), hideQuickPick (ref), GamepadNavigation (ref), u36 (ref)
        local v517 = u10;
        local v518 = MenuState.IsSelectionWithin(Guns);
        hideQuickPick();

        if v518 and v517 then
            GamepadNavigation.Focus(u36.Market.Header.Filters:FindFirstChild(v517));
        end;
    end;

    for _, child in u36.Market.Header.Filters:GetChildren() do
        if child:IsA("TextButton") then
            child.ImageLabel.Rotation = 0;
            child.Activated:Connect(function() -- Line: 4027
                -- upvalues: u10 (ref), child (copy), MenuState (ref), Guns (copy), hideQuickPick (ref), GamepadNavigation (ref), u36 (ref), openQuickCategory (ref)
                if u10 == child.Name then
                    local v519 = u10;
                    local v520 = MenuState.IsSelectionWithin(Guns);
                    hideQuickPick();

                    if v520 and v519 then
                        GamepadNavigation.Focus(u36.Market.Header.Filters:FindFirstChild(v519));
                    end;
                elseif openQuickCategory(child.Name) then
                    task.defer(function() -- Line: 4033
                        -- upvalues: Guns (ref), GamepadNavigation (ref)
                        if Guns.Visible then
                            GamepadNavigation.Focus(GamepadNavigation.FindFirstSelectable(Guns.Frame));
                        end;
                    end);
                end;
            end);
        end;
    end;

    CloseButtonRegistry.Add(Guns, nil, closeQuickPick);
    Guns.SelectionGroup = true;
    Guns.SelectionBehaviorUp = Enum.SelectionBehavior.Escape;
    Guns.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
    Guns.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
    Guns.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
    MenuState.RegisterBumperOverride(Guns, function(p521: boolean) -- Line: 4054
        -- upvalues: u10 (ref), Guns (copy), buildGuns (ref), GamepadNavigation (ref)
        local v522 = u10;

        if not v522 then
            return false;
        end;

        local v523 = {};

        for _, child in Guns.TopSelect.Container:GetChildren() do
            if child:IsA("TextButton") and child.Visible then
                table.insert(v523, child);
            end;
        end;

        if #v523 == 0 then
            return false;
        end;

        table.sort(v523, function(p524, p525) -- Line: 4069
            return p524.AbsolutePosition.X < p525.AbsolutePosition.X;
        end);
        local v526 = 1;

        for i, v in v523 do
            if v.Frame.Visible then
                v526 = i;
                break;
            end;
        end;

        local v527 = v523[(v526 - 1 + (p521 and -1 or 1)) % #v523 + 1];
        buildGuns(v522, v527.Name);
        Guns.Frame.CanvasPosition = Vector2.zero;
        GamepadNavigation.Focus(v527);

        return true;
    end, Guns);
    GlobalMarketplace.RequestProfileInfo.Send(LocalPlayer.UserId);
    local TextBox = u36.Market.Filters.Container.seller_id.Inputs.Id.TextBox;
    TextBox.FocusLost:Connect(function() -- Line: 4091
        -- upvalues: TextBox (copy), u8 (ref)
        if tonumber(TextBox.Text) then
            u8.sellerUserId = tonumber(TextBox.Text);

            return;
        end;

        if u8.sellerUserId then
            u8.sellerUserId = nil;
        end;

        TextBox.Text = "";
    end);

    local function buildCollectionOptions(p528: table) -- Line: 4103
        local v529 = { "All" };

        for _, v in p528 do
            if v.name ~= "First Edition" then
                table.insert(v529, v.name);
            end;
        end;

        return v529;
    end;

    local Container = u36.Market.Filters.Container;
    local rarity_dropdown = Container:FindFirstChild("rarity_dropdown");

    if rarity_dropdown then
        rarity_dropdown = rarity_dropdown:FindFirstChild("Dropdown");
    end;

    if rarity_dropdown and rarity_dropdown:IsA("GuiButton") then
        local v530 = { "All" };

        for i in Rarities do
            table.insert(v530, i);
        end;

        table.sort(v530, function(p531, p532) -- Line: 4124
            if p531 == "All" then
                return true;
            end;

            if p532 == "All" then
                return false;
            end;

            return p531:lower() < p532:lower();
        end);
        local v533 = MarketplaceDropdown.new(rarity_dropdown, v530);
        u11.rarity_dropdown = v533;
        v533.OptionSelected:Connect(function(p534) -- Line: 4135
            -- upvalues: u8 (ref)
            if p534 == "All" then
                p534 = nil;
            end;

            u8.rarity = p534;
        end);
    end;

    local Dropdown = Container.collection_dropdown.Dropdown;

    if Dropdown and Dropdown:IsA("GuiButton") then
        local function applyCollectionOptionLayoutOrder(p535) -- Line: 4143
            -- upvalues: Dropdown (copy)
            local Dropdown2 = Dropdown:FindFirstChild("Dropdown");

            if not Dropdown2 then
                return;
            end;

            for _, v in p535 do
                local v536 = Dropdown2:FindFirstChild(v.name);

                if v536 and v536:IsA("GuiObject") then
                    v536.LayoutOrder = tonumber(v.createdAt) or 0;
                end;
            end;
        end;

        local AllCollections = Collections.GetAllCollections();
        local u537 = MarketplaceDropdown.new(Dropdown, (buildCollectionOptions(AllCollections)));
        u11.collection_dropdown = u537;
        applyCollectionOptionLayoutOrder(AllCollections);
        u537.OptionSelected:Connect(function(p538) -- Line: 4163
            -- upvalues: u8 (ref)
            if p538 == "All" or not p538 then
                p538 = nil;
            end;

            u8.Collection = p538;
        end);
        Collections.ObserveAvailableCollections(function(p539) -- Line: 4167
            -- upvalues: u537 (copy), buildCollectionOptions (copy), applyCollectionOptionLayoutOrder (copy)
            u537:SetOptions((buildCollectionOptions(p539)));
            applyCollectionOptionLayoutOrder(p539);
        end);
    end;

    for _, child in u36.Top.Frame:GetChildren() do
        if child:IsA("TextButton") then
            MarketplaceButton.new(child, {
                hoverSizeMultiplier = 0.9,

                onActivated = function() -- Line: 4181, Name: onActivated
                    -- upvalues: child (copy), u20 (ref), u36 (ref), hideQuickPick (ref), u42 (ref)
                    local Name = child.Name;

                    for _, v in u20 do
                        u36[v].Visible = v == Name;
                    end;

                    if Name ~= "Market" then
                        hideQuickPick();
                    end;

                    if Name ~= "Sell" then
                        u36.Sell.Confirm.Visible = false;

                        if u42 then
                            u42:Destroy();
                        end;
                    end;
                end
            });
        end;
    end;

    u36.Profile.Main.ProfileInfo.Search.SearchBox.FocusLost:Connect(function() -- Line: 4187
        -- upvalues: u36 (ref), Players (ref), GlobalMarketplace (ref)
        local Text = u36.Profile.Main.ProfileInfo.Search.SearchBox.Text;
        local v540 = tonumber(Text);

        if not v540 and Text ~= "" then
            local success2, result2 = pcall(Players.GetUserIdFromNameAsync, Players, Text);

            if success2 then
                v540 = result2 or v540;
            end;
        end;

        u36.Profile.Main.ProfileInfo.Search.SearchBox.Text = not v540 and "Search User..." or tostring(v540);

        if v540 then
            GlobalMarketplace.RequestProfileInfo.Send(v540);
        end;
    end);
    local u541 = 3;
    local u542 = "";
    local Pin = u36.Pin;
    Pin.Active = false;
    local u543 = Pin.SetupCode.Main.Wrap.Settings_List.Pin_Setup_Template.Main.Pin_Setup.Wrap.Pin_Holder["1"]:Clone();

    local function formatPin(p544: any, p545: string) -- Line: 4213
        -- upvalues: u543 (copy)
        for _, child in p544:GetChildren() do
            if child:IsA("Frame") and child.Name ~= "Ghost_Template" then
                child:Destroy();
            end;
        end;

        local Ghost_Template = p544.Ghost_Template;
        local v546;

        if p545:len() >= 4 then
            v546 = p545:len() < 8;
        else
            v546 = false;
        end;

        Ghost_Template.Visible = v546;
        local v547 = p545:len();

        for i = 1, math.clamp(v547, 4, 8) do
            local v548 = u543:Clone();
            v548.Slot_Filled.Visible = i <= p545:len();
            v548.Slot_Empty.Visible = not v548.Slot_Filled.Visible;

            if v548.Slot_Filled.Visible then
                v548.Slot_Filled.TextLabel.Text = "*";
            end;

            v548.Parent = p544;
            local _ = i;
        end;
    end;

    local function submitPin() -- Line: 4235
        -- upvalues: u542 (ref), Remotes (ref), u541 (ref), Pin (copy), formatPin (copy)
        if u542:len() < 4 or u542:len() > 8 then
            return;
        end;

        Remotes.PlayerData.SubmitPin.Send(u542);
        u541 = u541 - 1;
        Pin.InputCode.Wrap.Title.Text = `Enter your PIN number ({u541} attempts left)`;
        u542 = "";
        formatPin(Pin.InputCode.Wrap.Pin_Holder, u542);
    end;

    (function() -- Line: 4248, Name: setupInput
        -- upvalues: Pin (copy), MarketplaceButton (ref), u542 (ref), formatPin (copy), submitPin (copy)
        for _, child in Pin.InputCode.Wrap.Number_Pad:GetChildren() do
            if child:IsA("TextButton") and child.Name ~= "Submit" then
                MarketplaceButton.new(child, {
                    onActivated = function() -- Line: 4254, Name: onActivated
                        -- upvalues: child (copy), u542 (ref), formatPin (ref), Pin (ref)
                        if child.Name == "Backspace" and u542:len() > 0 then
                            u542 = u542:sub(1, #u542 - 1);
                        elseif child.Name ~= "Backspace" and u542:len() < 8 then
                            u542 = u542 .. child.Title.Text;
                        end;

                        formatPin(Pin.InputCode.Wrap.Pin_Holder, u542);
                    end
                });
            end;
        end;

        MarketplaceButton.new(Pin.InputCode.Wrap.Number_Pad.Submit, {
            onActivated = submitPin
        });
    end)();
    UserInputService.InputBegan:Connect(function(p549: userdata) -- Line: 4270
        -- upvalues: Pin (copy), u1 (ref), u542 (ref), formatPin (copy), submitPin (copy)
        if not Pin.Visible then
            return;
        end;

        if not u1[p549.KeyCode] and p549.KeyCode ~= Enum.KeyCode.Backspace then
            if (p549.KeyCode == Enum.KeyCode.Return or p549.KeyCode == Enum.KeyCode.KeypadEnter) and Pin.InputCode.Visible then
                submitPin();
            end;

            return;
        end;

        if Enum.KeyCode.Backspace == p549.KeyCode and u542:len() > 0 then
            u542 = u542:sub(1, #u542 - 1);
        else
            if Enum.KeyCode.Backspace == p549.KeyCode or u542:len() >= 8 then
                return;
            end;

            u542 = u542 .. u1[p549.KeyCode];
        end;

        formatPin(Pin.InputCode.Wrap.Pin_Holder, u542);
    end);
    local v550 = u36.Visible and LocalPlayer:GetAttribute("PinVerified") == false;
    Pin.Visible = v550;
    LocalPlayer:GetAttributeChangedSignal("PinVerified"):Connect(function() -- Line: 4289
        -- upvalues: Pin (copy), u36 (ref), LocalPlayer (ref)
        local v551 = u36.Visible and LocalPlayer:GetAttribute("PinVerified") == false;
        Pin.Visible = v551;
    end);
    GamepadNavigation.TrapPopup(Pin);
    MenuState.RegisterBumperOverride(u36, function(p552: boolean) -- Line: 4306
        -- upvalues: u36 (ref), Pin (copy), u42 (ref), u20 (ref), hideQuickPick (ref), GamepadNavigation (ref)
        local Sell = u36.Sell;

        if Pin.Visible or Sell.Visible and (Sell.Confirm.Visible or u42 ~= nil and u42.Parent ~= nil) then
            return true;
        end;

        local v553 = 1;

        for i, v in u20 do
            if u36[v].Visible then
                v553 = i;
                break;
            end;
        end;

        local v554 = u20[(v553 - 1 + (p552 and -1 or 1)) % #u20 + 1];

        for _, v in u20 do
            u36[v].Visible = v == v554;
        end;

        if v554 ~= "Market" then
            hideQuickPick();
        end;

        if v554 ~= "Sell" then
            u36.Sell.Confirm.Visible = false;

            if u42 then
                u42:Destroy();
            end;
        end;

        GamepadNavigation.Focus(u36.Top.Frame:FindFirstChild(v554));

        return true;
    end, u36);

    for _, descendant in u36:GetDescendants() do
        if descendant:IsA("TextButton") and (descendant.Name == "Search" or descendant.Name == "Price") and descendant:FindFirstChildWhichIsA("TextBox", true) then
            descendant.Selectable = false;
        end;
    end;

    u36:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 4343
        -- upvalues: onVisibilityChanged (ref), u36 (ref)
        onVisibilityChanged(u36.Visible);
    end);
    MenuState.OnInspectStateChanged:Connect(function(p555: boolean) -- Line: 4351
        -- upvalues: u36 (ref), MenuState (ref), u32 (ref), u24 (ref), u22 (ref), hideQuickPick (ref), u42 (ref)
        if p555 then
            return;
        end;

        task.defer(function() -- Line: 4355
            -- upvalues: u36 (ref), MenuState (ref), u32 (ref), u24 (ref), u22 (ref), hideQuickPick (ref), u42 (ref)
            if not (u36.Visible or MenuState.IsInspectActive()) then
                u32 = nil;
                u24 = nil;

                if u22 then
                    u22:Destroy();
                    u22 = nil;
                end;

                u36.Market.PurchaseMenu.Confirm.Visible = false;
                u36.Market.PurchaseMenu.Visible = false;
                u36.Market.Confirm.Visible = false;
                hideQuickPick();
                u36.Sell.Confirm.Visible = false;

                if u42 then
                    u42:Destroy();
                end;
            end;
        end);
    end);
    onVisibilityChanged(u36.Visible);
end;

return v47;