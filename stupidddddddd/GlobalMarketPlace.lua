-- ReplicatedStorage.Interface.Screens.Menu.GlobalMarketPlace
-- Script path: ReplicatedStorage.Interface.Screens.Menu.GlobalMarketPlace
-- Decompile time: 123.32 ms

local deepCopy, getMarketplaceErrorMessage, v1, v2
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local AssetService = game:GetService("AssetService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PolicyService = game:GetService("PolicyService")
local GuiInset = GuiService:GetGuiInset()
local LocalPlayer = Players.LocalPlayer
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Store = require(ReplicatedStorage.Interface.Screens.Menu.Store)
local MarketplaceButton = require(ReplicatedStorage.Components.Common.MarketplaceButton)
local MarketplaceDropdown = require(ReplicatedStorage.Components.Common.MarketplaceDropdown)
local MarketplaceHover = require(ReplicatedStorage.Components.Common.MarketplaceHover)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local FuzzySearch = require(ReplicatedStorage.Shared.FuzzySearch)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local GuiShown = require(ReplicatedStorage.Components.Common.InterfaceAnimations.GuiShown)
local CollectionServiceUtility = require(ReplicatedStorage.Shared.CollectionServiceUtility)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local InspectController = require(ReplicatedStorage.Controllers.InspectController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices)
local UserCache = require(ReplicatedStorage.Database.Custom.UserCache)
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local GlobalMarketplace = Remotes.GlobalMarketplace
require(ReplicatedStorage.Database.Custom.Types)
local u612 = {}
for i, j in {"Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"} do
    v2 = Enum.KeyCode[j]
    u612[v2] = (tostring(i - 1))
    v2 = Enum.KeyCode[("Keypad%*"):format(j)]
    u612[v2] = (tostring(i - 1))
end
local u613 = table.freeze({Badge = true, Booth = true})
local u614 = table.freeze({Package = true, Console = true, Case = true})
local u615 = table.freeze({
    "Karambit | Wemby",
    "Butterfly Knife | Lebron James",
    "CT Knife | Lebron James",
    "Wemby",
    "Lebron James",
})
local u616 = {0, Constants.MARKETPLACE_MAX_LISTING_PRICE}
local u617 = {{scale = 0.5, valueRatio = 0.001}, {scale = 0.85, valueRatio = 0.01}, {scale = 1, valueRatio = 1}}
local u618 = {
    {"ITEM_NOT_MARKETABLE", "This item is not available on the marketplace"},
    {"ITEM_HAS_CHARM", "Remove the charm before listing this item"},
    {"ITEM_IS_CHARM", "Charms cannot be listed on the marketplace"},
}
local u235 = Color3.fromRGB(32, 255, 28)
local u619 = false
local u620 = false
local u621 = 0
local u622 = {search_bar_query = "", page = 1}
u622.price_range = {u616[1], u616[2]}
u622.pattern_range = {0, 11}
u622.wear_range = {0, 1}
local u623 = {}
local u624 = nil
local u625 = {}
local u626 = 1
local u627 = false
local u628 = {}
local u629 = {
    {key = "FactoryNew", max = 0.07, wear = "Factory New"},
    {key = "MinimalWear", max = 0.15, wear = "Minimal Wear"},
    {key = "FieldTested", max = 0.38, wear = "Field-Tested"},
    {key = "WellWorn", max = 0.45, wear = "Well-Worn"},
    {key = "BattleScarred", max = 1, wear = "Battle-Scarred"},
}
local u630 = nil
local u631 = {}
local u632 = false
local u633 = nil
local u634 = {"Market", "Sell", "Profile"}
local u635 = {
    pageSize = 10,
    sort = "Quality",
    sortReversed = false,
    filters = {"Tradable", "MarketplaceListable", "All"},
}
local u636 = nil
local u637 = nil
local u638 = nil
local u639 = {}
local u640 = 0
local u641 = nil
local u642 = nil
local u643 = false
local u644 = nil
local u645 = false
local u646 = nil
local abandonSearchAfterTimeout = nil
local selectQuickItem = nil
local resetQuickSearchFilters = nil
local u650 = nil
local u651 = nil
local u652 = nil
local u653 = nil
local u654 = nil
local u655 = nil
local u656 = nil
local u657 = nil
local u658 = nil
local u659 = nil
local u660 = nil
local v3 = {tweenVisibility = false}

local function setLoading(a1) -- Line: 227 -- upvalues: u650 (ref), u657 (ref) -- types: a1: boolean
    u650.Parent.Parent.Loading.Visible = a1
    if a1 then
        u657:Play()
        return
    end
    u657:Pause()
end

local function getHeadshot(a1, a2) -- Line: 236 -- upvalues: Players (val) -- types: a1: number
    local HeadShot = Enum.ThumbnailType.HeadShot
    return Players:GetUserThumbnailAsync(a1, HeadShot, a2 or Enum.ThumbnailSize.Size180x180)
end

local function itemTypeHidesInspect(a1) -- Line: 241 -- types: a1: string?
    local v1 = true
    if a1 ~= "Case" then
        v1 = a1 == "Package"
    end
    return v1
end

local function showInspect(a1) -- Line: 245
    -- upvalues: u650 (ref), MenuState (val), u646 (ref), GuiService (val), CloseButtonRegistry (val)
    -- upvalues: InspectController (val)
    local Type = a1.Type
    local v1 = true
    if Type ~= "Case" then
        v1 = Type == "Package"
    end
    if v1 then
        return
    end
    local Market = u650.Market
    local v2 = MenuState.IsSelectionWithin(Market.PurchaseMenu) or MenuState.IsSelectionWithin(Market.Header.Guns)
    u646 = if not v2 then nil else GuiService.SelectedObject
    local Inspect = u650.Parent:FindFirstChild("Inspect")
    if Inspect then
        CloseButtonRegistry.BringToFront(Inspect)
    end
    InspectController.ShowInspect(a1)
end

local function openTradeTokensStore() -- Line: 265 -- upvalues: ReplicatedStorage (val), MenuState (val), Store (val)
    require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Store")
    if MenuState.GetCurrentScreen() == "Store" then
        Store.OpenTab("TradeTokens")
    end
end

local function showNewItemsNotification(a1) -- Line: 273 -- upvalues: Router (val) -- types: a1: table
    local v1 = #a1
    Router.broadcastRouter(
        "CreateNotification",
        "Marketplace",
        if v1 ~= 1 then ("%* marketplace items were added to your inventory."):format(v1) else "Your marketplace item was added to your inventory.",
        4
    )
end

local function sendMarketSearch() -- Line: 285
    -- upvalues: u622 (val), GlobalMarketplace (val), abandonSearchAfterTimeout (ref)
    local pattern_range = u622.pattern_range
    if pattern_range and pattern_range[1] <= 0 then
        u622.pattern_range = nil
    end
    GlobalMarketplace.SearchMarket.Send(u622)
    u622.pattern_range = pattern_range
    abandonSearchAfterTimeout()
end

function abandonSearchAfterTimeout() -- Line: 297 -- upvalues: u640 (ref), u650 (ref), u627 (ref), u657 (ref)
    u640 = u640 + 1
    local u2 = u640
    task.delay(15, function() -- Line: 301 -- upvalues: u2 (val), u640 (upval), u650 (upval), u627 (upval), u657 (upval)
        if u2 == u640 and u650 then
            u627 = false
            u650.Parent.Parent.Loading.Visible = false
            u657:Pause()
            return
        end
    end)
end

local function pruneOldestListingFrames(a1, a2) -- Line: 312 -- types: a1: userdata, a2: number
    local v1 = {}
    for i, j in a1:GetChildren() do
        if j:IsA("GuiObject") and j.Name ~= ".space" then
            table.insert(v1, j)
        end
    end
    if #v1 <= a2 then
        return
    end
    table.sort(v1, function(a1, a2) -- Line: 324
        return a1.LayoutOrder < a2.LayoutOrder
    end)
    for k = 1, #v1 - a2 do
        v1[k]:Destroy()
    end
end

local function hydrateSellerNameAsync(a1, a2) -- Line: 334 -- upvalues: UserCache (val) -- types: a2: number
    a1.Text = "Seller: ..."
    task.spawn(function() -- Line: 337 -- upvalues: UserCache (upval), a2 (val), a1 (val)
        local success, result = pcall(UserCache.Fetch, a2)
        local Username = if not success then "Unknown User" else if not result then "Unknown User" else if not result.Username then "Unknown User" else result.Username
        if a1.Parent then
            a1.Text = ("Seller: %*"):format(Username)
        end
    end)
end

local function stopOnlineStatusPulse(a1) -- Line: 347 -- upvalues: u660 (ref), u659 (ref) -- types: a1: userdata
    if u660 then
        u660()
        u660 = nil
    end
    if u659 then
        u659:Cancel()
        u659 = nil
    end
    a1.TextTransparency = 0
    local OnlinePulseDot = a1:FindFirstChild("OnlinePulseDot")
    if OnlinePulseDot and OnlinePulseDot:IsA("GuiObject") then
        OnlinePulseDot.Visible = false
    end
end

local function getOnlineStatusDot(a1) -- Line: 365 -- types: a1: userdata
    local OnlinePulseDot = a1:FindFirstChild("OnlinePulseDot")
    if OnlinePulseDot and not OnlinePulseDot:IsA("Frame") then
        OnlinePulseDot:Destroy()
        OnlinePulseDot = nil
    end
    if not OnlinePulseDot then
        local Frame = Instance.new("Frame")
        Frame.Name = "OnlinePulseDot"
        Frame.BorderSizePixel = 0
        Frame.Parent = a1
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame
        OnlinePulseDot = Frame
    end
    OnlinePulseDot.AnchorPoint = Vector2.new(0.5, 0.5)
    OnlinePulseDot.Position = UDim2.new(0, -7, 0.5, 0)
    OnlinePulseDot.Size = UDim2.fromOffset(6, 6)
    OnlinePulseDot.ZIndex = a1.ZIndex + 1
    return OnlinePulseDot
end

local function setOnlineStatus(a1) -- Line: 393
    -- upvalues: u660 (ref), u659 (ref), u235 (val), getOnlineStatusDot (val), TweenService (val), GuiShown (val)
    if u660 then
        u660()
        u660 = nil
    end
    if u659 then
        u659:Cancel()
        u659 = nil
    end
    a1.TextTransparency = 0
    local OnlinePulseDot = a1:FindFirstChild("OnlinePulseDot")
    if OnlinePulseDot and OnlinePulseDot:IsA("GuiObject") then
        OnlinePulseDot.Visible = false
    end
    a1.Text = "Online"
    a1.TextColor3 = u235
    local v1 = getOnlineStatusDot(a1)
    v1.Visible = true
    v1.BackgroundColor3 = u235
    v1.BackgroundTransparency = 0.05
    local u45 = TweenService:Create(
        v1,
        TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundTransparency = 0.42, BackgroundColor3 = u235}
    )
    u659 = u45
    u660 = GuiShown.Observe(v1, function(a1) -- Line: 413 -- upvalues: u45 (val) -- types: a1: boolean
        if a1 then
            u45:Play()
            return
        end
        u45:Pause()
    end)
end

local function prepareMarketplaceListingReveal(a1) -- Line: 422
    a1:SetAttribute("StaggerRevealReady", false)
    a1.Visible = false
end

local function revealMarketplaceListings(a1, a2) -- Line: 427 -- types: a1: table, a2: function
    task.spawn(function() -- Line: 431 -- upvalues: a1 (val), a2 (val)
        local v1 = nil
        local v2 = nil
        for i, j in a1, v1, v2 do
            if j.Parent then
                j:SetAttribute("StaggerRevealReady", true)
                j.Visible = a2(j)
            end
            task.wait(0.018)
        end
    end)
end

for k, n in ReplicatedStorage.Assets.Skins:GetChildren() do
    v1 = GetSkinDisplayName.GetWeaponDisplayName(n.Name):lower()
    table.insert(u639, v1)
    for m, i5 in n:GetChildren() do
        table.insert(u639, (i5.Name:lower()))
        table.insert(u639, (("%* %*"):format(v1, (i5.Name:lower()))))
    end
end
local PredictSearch = require(ReplicatedStorage.Components.Common.PredictSearch)

local function predictSearch() -- Line: 455 -- upvalues: u650 (ref), PredictSearch (val), u639 (val), u637 (ref)
    local v1 = u650.Market.Filters.Container.Search.Frame.SearchBox.Text:lower()
    u650.Market.Filters.Container.Search.Frame.SearchBox.Text = v1
    local v2 = PredictSearch(u639, v1, 3)
    if not v2 then
        u637 = nil
        u650.Market.Filters.Container.Search.Frame.Auto.Text = ""
        return
    end
    v2 = (((((v2:gsub("m9", "")):gsub("TKnife", "Knife")):gsub("CTKnife", "Knife")):gsub("_PATTERN_%d+", "")):gsub("The", "")):gsub(
        "_pattern_%d+",
        ""
    )
    u637 = v2
    u650.Market.Filters.Container.Search.Frame.Auto.Text = v2
end

local u351 = 0

local function schedulePredictSearch() -- Line: 477 -- upvalues: u351 (ref), predictSearch (val)
    u351 = u351 + 1
    local u2 = u351
    task.delay(0.12, function() -- Line: 481 -- upvalues: u2 (val), u351 (upval), predictSearch (upval)
        if u2 ~= u351 then
            return
        end
        predictSearch()
    end)
end

local function v4(a1, a2, a3, a4) -- Line: 490
    -- upvalues: MarketPlacePrices (val)
    local v1 = MarketPlacePrices.GetItemPrice(a1, a2, a3, a4)
    local recentAveragePriceTradeTokens = v1 and v1.recentAveragePriceTradeTokens
    if recentAveragePriceTradeTokens and recentAveragePriceTradeTokens > 0 then
        return (math.floor(recentAveragePriceTradeTokens))
    end
    return nil
end

function v1(a1) -- Line: 496 -- upvalues: CommaNumber (val) -- types: a1: number?
    if a1 then
        return (CommaNumber(a1))
    end
    return "N/A"
end

local function getRarityData(a1) -- Line: 500 -- upvalues: Rarities (val) -- types: a1: string?
    local v1 = nil
    local v2 = nil
    local v3 = nil
    for i, j in Rarities, v2, v3 do
        if tostring(i) == "Stock" then
            v1 = j
        end
        if tostring(i) == v4 then
            return j
        end
    end
    return v1
end

local function v5(a1) -- Line: 514 -- types: a1: string?
    local v1 = false
    if a1 ~= "Case" then
        v1 = false
        if a1 ~= "Charm Capsule" then
            v1 = false
            if a1 ~= "Sticker Capsule" then
                v1 = a1 ~= "Package"
            end
        end
    end
    return v1
end

local function formatSaleDate(a1) -- Line: 522 -- types: a1: number
    return (("%*, %*"):format(("%* %*, %*"):format(os.date("%B", a1), os.date("%d", a1), (os.date("%Y", a1))), (os.date("%I:%M %p", a1))))
end

local function v6(a1) -- Line: 527 -- upvalues: u620 (ref), u614 (val) -- types: a1: string?
    local v1 = u620
    if v1 then
        v1 = false
        if a1 ~= nil then
            v1 = u614[a1] == true
        end
    end
    return v1
end

function getMarketplaceErrorMessage(a1) -- Line: 531 -- upvalues: u618 (val), getMarketplaceErrorMessage (val)
    local v1, v2
    if type(a1) ~= "table" then
        return nil
    end
    local v3 = {
        "code",
        "errorCode",
        "error_code",
        "errorMessage",
        "error_message",
        "error",
        "message",
        "detail",
        "details",
    }
    local v4 = nil
    local v5 = nil
    local v6 = a1
    for i, j in v3, v4, v5 do
        v1 = v6[j]
        v2 = u618
        for k, n in v2 do
            if v1 ~= n[1] and v1 ~= n[2] then
                continue
            end
            return n[2]
        end
        if type(v1) == "table" then
            v2 = getMarketplaceErrorMessage(v1)
            if v2 then
                return v2
            end
        end
    end
    if type(v6.results) == "table" then
        for m, i5 in v6.results do
            v1 = getMarketplaceErrorMessage(i5)
            if v1 then
                return v1
            end
        end
    end
    return nil
end

local function v7(a1) -- Line: 566 -- upvalues: getMarketplaceErrorMessage (val), Router (val)
    local v1 = getMarketplaceErrorMessage(a1)
    if not v1 then
        return false
    end
    Router.broadcastRouter("CreateNotification", "Error", v1)
    return true
end

local function v8(a1) -- Line: 576
    -- upvalues: ReplicatedStorage (val), MenuState (val), Store (val)
    task.spawn(function() -- Line: 577 -- upvalues: ReplicatedStorage (upval), MenuState (upval), Store (upval), a1 (val)
        local Error = ReplicatedStorage.Assets.Sounds:FindFirstChild("Error")
        if Error and Error:IsA("Sound") then
            Error:Play()
        end
        task.wait(0.1)
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Store")
        if MenuState.GetCurrentScreen() == "Store" then
            Store.OpenTab("TradeTokens")
        end
        task.wait(0.3)
        Store.PromptTradeTokenPackageForItemPrice(a1)
    end)
end

local function hideQuickPick() -- Line: 590 -- upvalues: u624 (ref), u650 (ref)
    u624 = nil
    u650.Market.Header.Guns.Visible = false
    for i, j in u650.Market.Header.Filters:GetChildren() do
        if j:IsA("TextButton") then
            j.ImageLabel.Rotation = 0
        end
    end
end

local function v9() -- Line: 601 -- upvalues: u650 (ref), u656 (ref)
    u650.Sell.Confirm.Visible = false
    if u656 then
        u656:Destroy()
    end
end

local function v10(a1) -- Line: 608
    -- upvalues: u634 (val), u650 (ref), hideQuickPick (val), u656 (ref)
    local v1
    local v2 = nil
    local v3 = nil
    local v4 = a1
    for i, j in u634, v2, v3 do
        v1 = u650[j]
        v1.Visible = j == v4
    end
    if v4 ~= "Market" then
        hideQuickPick()
    end
    if v4 ~= "Sell" then
        u650.Sell.Confirm.Visible = false
        if u656 then
            u656:Destroy()
        end
    end
end

local function destroyListingCard(a1) -- Line: 624
    -- upvalues: MenuState (val), GamepadNavigation (val), GuiService (val), u650 (ref)
    local v1 = MenuState.IsSelectionWithin(a1) and GamepadNavigation.IsUsable(GuiService.SelectedObject)
    local v2 = if not a1:IsA("GuiObject") then nil else a1.AbsolutePosition + a1.AbsoluteSize / 2
    a1:Destroy()
    if not v1 then
        return
    end
    local Container = u650.Market.Container
    local v3 = nil
    local v4 = (1 / 0)
    if v2 then
        local Magnitude
        for i, j in Container:GetDescendants() do
            if j:IsA("GuiObject") and GamepadNavigation.IsUsable(j) then
                Magnitude = (j.AbsolutePosition + j.AbsoluteSize / 2 - v2).Magnitude
                if Magnitude < v4 then
                    v3 = j
                end
            end
        end
    end
    if v3 and GamepadNavigation.Focus(v3) then
        return
    end
    if not GamepadNavigation.Focus(Container) then
        GamepadNavigation.Focus(u650.Top.Frame:FindFirstChild("Market"))
    end
end

local function v11(a1) -- Line: 653 -- types: a1: number
    return math.floor(a1 * 1000000 + 0.5) / 1000000
end

function deepCopy(a1) -- Line: 658 -- upvalues: deepCopy (val)
    if type(a1) ~= "table" then
        return a1
    end
    local v1 = {}
    for i, j in a1 do
        v1[i] = (deepCopy(j))
    end
    return v1
end

local function getPriceSliderSegments(a1) -- Line: 670 -- upvalues: u617 (val) -- types: a1: number
    local v1
    if a1 <= 1 then
        return {{scale = 1, value = a1}}
    end
    local v2 = {}
    local v3 = nil
    local v4 = nil
    local v5 = a1
    for i, j in u617, v3, v4 do
        v1 = math.min(math.max(1, (math.floor(v5 * j.valueRatio + 0.5))), v5)
        if #v2 == 0 or v2[#v2].value < v1 then
            table.insert(v2, {scale = j.scale, value = v1})
        end
        if v5 <= v1 then
            break
        end
    end
    if v2[#v2].value < v5 then
        table.insert(v2, {scale = 1, value = v5})
    end
    return v2
end

local function sliderScaleToValue(a1, a2) -- Line: 696
    -- upvalues: getPriceSliderSegments (val)
    local v1
    if a2 <= 1 then
        return a1 * a2
    end
    local v2 = math.clamp(a1, 0, 1)
    local scale = 0
    local value_2 = 0
    for i, j in (getPriceSliderSegments(a2)) do
        if not (v2 <= j.scale) and not (1 <= j.scale) then
            scale = j.scale
            value_2 = j.value
            continue
        end
        v1 = j.scale - scale
        if v1 == 0 then
            return j.value
        end
        return (math.floor(value_2 + (j.value - value_2) * ((v2 - scale) / v1) + 0.5))
    end
    return a2
end

local function sliderValueToScale(a1, a2) -- Line: 718
    -- upvalues: getPriceSliderSegments (val)
    if a2 <= 1 then
        return a1 / a2
    end
    local v1 = math.clamp(a1, 0, a2)
    local scale = 0
    local value = 0
    for i, j in (getPriceSliderSegments(a2)) do
        if not (j.value <= value) then
            if not (v1 <= j.value) and not (1 <= j.scale) then
                scale = j.scale
                value = j.value
                continue
            end
            return scale + (j.scale - scale) * (v1 - value) / (j.value - value)
        else
            scale = j.scale
            value = j.value
        end
    end
    return 1
end

local function setDrag(a1, a2, a3, a4) -- Line: 740
    -- upvalues: u622 (val), sliderValueToScale (val), sliderScaleToValue (val), CollectionService (val)
    -- upvalues: CommaNumber (val), u632 (ref), u633 (ref)
    local Content, EndPin, EndPin_2, Inputs, Scale, Scale_2, Slider, Span, StartPin, StartPin_2, TextBox, TextBox_2, v1, v2
    local v3 = tonumber(a2)
    if not v3 then
        return
    end
    local Name = a1.Name
    local v4 = u622[Name]
    if type(v4) ~= "table" then
        return
    end
    local v5 = math.clamp(v3, if a3 ~= "StartPin" then v4[1] else 0, not (a3 ~= "EndPin") and a4 or v4[2])
    local v6 = a1.Slider[a3]
    v6.Position = UDim2.fromScale(sliderValueToScale(v5, a4), 1.2)
    u622[Name] = {
        sliderScaleToValue(a1.Slider.StartPin.Position.X.Scale, a4),
        (sliderScaleToValue(a1.Slider.EndPin.Position.X.Scale, a4)),
    }
    v4 = u622[Name]
    local v7, v8, v9 = a3, a1, a4
    for i, j in CollectionService:GetTagged(Name) do
        Slider = j:FindFirstChild("Slider")
        Content = j:FindFirstChild("Content")
        if Slider and Content then
            Inputs = Content:FindFirstChild("Inputs")
            if Inputs then
                StartPin = Slider:FindFirstChild("StartPin")
                EndPin = Slider:FindFirstChild("EndPin")
                v1 = Slider:FindFirstChild(v7)
                StartPin_2 = Inputs:FindFirstChild("StartPin")
                EndPin_2 = Inputs:FindFirstChild("EndPin")
                if v1 and StartPin and EndPin and StartPin_2 and EndPin_2 then
                    v1.Position = v8.Slider[v7].Position
                    TextBox = StartPin_2.TextBox
                    v2 = v9 > 1 and CommaNumber((math.floor(v4[1]))) or math.floor(v4[1] * 1000000 + 0.5) / 1000000
                    TextBox.Text = v2
                    TextBox_2 = EndPin_2.TextBox
                    v2 = v9 > 1 and CommaNumber((math.floor(v4[2]))) or math.floor(v4[2] * 1000000 + 0.5) / 1000000
                    TextBox_2.Text = v2
                    Span = Slider:FindFirstChild("Span")
                    if Span then
                        Scale = StartPin.Position.X.Scale
                        Scale_2 = EndPin.Position.X.Scale
                        Span.Position = UDim2.new(Scale, 0, Span.Position.Y.Scale, Span.Position.Y.Offset)
                        Span.Size = UDim2.new(math.max(Scale_2 - Scale, 0), 0, Span.Size.Y.Scale, Span.Size.Y.Offset)
                    end
                end
            end
        end
    end
    if Name == "wear_range" and not u632 then
        u633()
    end
end

local function getWearTierMin(a1) -- Line: 801 -- upvalues: u629 (val) -- types: a1: number
    if a1 == 1 then
        return 0
    end
    return u629[a1 - 1].max
end

local function isFullWearRange(a1, a2) -- Line: 805 -- types: a1: number, a2: number
    local v1 = false
    if a1 <= 1e-09 then
        v1 = a2 >= 0.999999999
    end
    return v1
end

local function setWearTierVisual(a1, a2) -- Line: 809
    -- upvalues: CollectionService (val)
    local ImageLabel, v1
    for i, j in CollectionService:GetTagged("wear_range") do
        v1 = j.List:FindFirstChild(a1)
        if v1 and v1:FindFirstChild("Button") then
            ImageLabel = v1.Button:FindFirstChild("ImageLabel")
            if ImageLabel then
                ImageLabel.Visible = a2
            end
        end
    end
end

local function setWearRange(a1, a2) -- Line: 821
    -- upvalues: u650 (ref), u632 (ref), u622 (val), setDrag (val)
    if not u650 then
        return
    end
    local wear_range = u650.Market.Filters.Container:FindFirstChild("wear_range")
    if not wear_range then
        return
    end
    u632 = true
    u622.wear_range = {a1, a2}
    setDrag(wear_range, a1, "StartPin", 1)
    setDrag(wear_range, a2, "EndPin", 1)
    u632 = false
end

function u633() -- Line: 838 -- upvalues: u622 (val), u629 (val), u631 (val), setWearTierVisual (val)
    local max, v1
    local v2 = u622.wear_range[1]
    local v3 = u622.wear_range[2]
    local v4 = false
    if v2 <= 1e-09 then
        v4 = v3 >= 0.999999999
    end
    if v4 then
        for k, n in u629 do
            u631[n.key] = false
            setWearTierVisual(n.key, false)
        end
        return
    end
    local v5 = nil
    local v6 = nil
    for i, j in u629, v5, v6 do
        max = if i ~= 1 then u629[i - 1].max else 0
        v1 = false
        if v2 <= max + 1e-09 then
            v1 = j.max - 1e-09 <= v3
        end
        u631[j.key] = v1
        setWearTierVisual(j.key, v1)
    end
end

local function getWearSearchRangeFromSelection() -- Line: 858 -- upvalues: u629 (val), u631 (val)
    local v1 = false
    local v2 = 1
    local v3 = 0
    local v4 = nil
    local v5 = nil
    for i, j in u629, v4, v5 do
        if u631[j.key] then
            v1 = true
            v2 = math.min(v2, if i ~= 1 then u629[i - 1].max else 0)
            v3 = math.max(v3, j.max)
        end
    end
    if not v1 then
        return {0, 1}
    end
    if v3 < 1 then
        v3 = v3 - 1e-12
    end
    return {v2, v3}
end

local function refreshWearRangeInSearchPayload() -- Line: 882
    -- upvalues: u622 (val), getWearSearchRangeFromSelection (val)
    u622.wear_range = getWearSearchRangeFromSelection()
end

local function anyWearTiersSelected() -- Line: 886 -- upvalues: u629 (val), u631 (val)
    for i, j in u629 do
        if u631[j.key] then
            return true
        end
    end
    return false
end

local function wearNameMatchesSelectedTiers(a1) -- Line: 895 -- upvalues: u629 (val), u631 (val) -- types: a1: string
    for i, j in u629 do
        if u631[j.key] and j.wear == a1 then
            return true
        end
    end
    return false
end

local function listingFrameMatchesSelectedWearTiers(a1) -- Line: 904
    -- upvalues: u629 (val), u631 (val)
    local Attribute
    local v1 = u629
    for i, j in v1 do
        if u631[j.key] then
            if false then
                return true
            end
            Attribute = a1:GetAttribute("Wear")
            v1 = false
            if typeof(Attribute) == "string" then
                for k, n in u629 do
                    if u631[n.key] and n.wear == Attribute then
                        return true
                    end
                end
                v1 = false
            end
            return v1
        end
    end
    if true then
        return true
    end
    Attribute = a1:GetAttribute("Wear")
    v1 = false
    if typeof(Attribute) == "string" then
        for m, i5 in u629 do
            if u631[i5.key] and i5.wear == Attribute then
                return true
            end
        end
        v1 = false
    end
    return v1
end

local function listingMatchesSelectedWearTiers(a1) -- Line: 913
    -- upvalues: u629 (val), u631 (val), Skins (val)
    local inventoryItem
    local v1 = u629
    local v2 = nil
    for i, j in v1, v2 do
        if u631[j.key] then
            if false then
                return true
            end
            inventoryItem = a1.inventoryItem
            if inventoryItem and inventoryItem.Float ~= nil then
                v1 = Skins.GetSkinInformation(inventoryItem.Name, inventoryItem.Skin)
                if not v1 then
                    return false
                end
                v2 = Skins.GetWearNameForFloat(v1, inventoryItem.Float)
                if not v2 then
                    return false
                end
                for k, n in u629 do
                    if u631[n.key] and n.wear == v2 then
                        return true
                    end
                end
                return false
            end
            return false
        end
    end
    if true then
        return true
    end
    inventoryItem = a1.inventoryItem
    if inventoryItem and inventoryItem.Float ~= nil then
        v1 = Skins.GetSkinInformation(inventoryItem.Name, inventoryItem.Skin)
        if not v1 then
            return false
        end
        v2 = Skins.GetWearNameForFloat(v1, inventoryItem.Float)
        if not v2 then
            return false
        end
        for m, i5 in u629 do
            if u631[i5.key] and i5.wear == v2 then
                return true
            end
        end
        return false
    end
    return false
end

local function syncWearRangeFromTierSelection() -- Line: 936
    -- upvalues: getWearSearchRangeFromSelection (val), setWearRange (val)
    local v1 = getWearSearchRangeFromSelection()
    local v2 = v1[2]
    if v2 < 1 then
        v2 = v2 + 1e-12
    end
    setWearRange(v1[1], v2)
end

local function toggleWearTier(a1) -- Line: 946
    -- upvalues: u631 (val), setWearTierVisual (val), getWearSearchRangeFromSelection (val), setWearRange (val)
    -- upvalues: u630 (ref)
    u631[a1] = not u631[a1]
    setWearTierVisual(a1, u631[a1])
    local v1 = getWearSearchRangeFromSelection()
    local v2 = v1[2]
    if v2 < 1 then
        v2 = v2 + 1e-12
    end
    setWearRange(v1[1], v2)
    u630()
end

local function setupWearTierButtons() -- Line: 953
    -- upvalues: u629 (val), u631 (val), setWearTierVisual (val), CollectionService (val), MarketplaceButton (val)
    -- upvalues: getWearSearchRangeFromSelection (val), setWearRange (val), u630 (ref)
    local v1
    local v2 = nil
    local v3 = nil
    for i, j in u629, v2, v3 do
        u631[j.key] = false
        setWearTierVisual(j.key, false)
        for k, n in CollectionService:GetTagged("wear_range") do
            v1 = n.List:FindFirstChild(j.key)
            if v1 and v1:FindFirstChild("Button") then
                MarketplaceButton.new(v1.Button, {
                    hoverSizeMultiplier = 0.9,
                    onActivated = function() -- Line: 964
                        -- upvalues: j (val), u631 (upval), setWearTierVisual (upval)
                        -- upvalues: getWearSearchRangeFromSelection (upval), setWearRange (upval), u630 (upval)
                        local key = j.key
                        u631[key] = not u631[key]
                        setWearTierVisual(key, u631[key])
                        local v1 = getWearSearchRangeFromSelection()
                        local v2 = v1[2]
                        if v2 < 1 then
                            v2 = v2 + 1e-12
                        end
                        setWearRange(v1[1], v2)
                        u630()
                    end,
                })
            end
        end
    end
end

local function dragSlider(a1, a2, a3, a4) -- Line: 973
    -- upvalues: UserInputService (val), GuiInset (val), setDrag (val), sliderScaleToValue (val), RunService (val)
    local Scale, Scale_2, v1
    repeat
        v1 = math.clamp(
            (((if a4.UserInputType ~= Enum.UserInputType.Touch then UserInputService:GetMouseLocation() else Vector2.new(a4.Position.X, a4.Position.Y)) - GuiInset).X - a1.AbsolutePosition.X) / a1.AbsoluteSize.X,
            0,
            1
        )
        Scale = a1.StartPin.Position.X.Scale
        Scale_2 = a1.EndPin.Position.X.Scale
        setDrag(
            a1.Parent,
            sliderScaleToValue(math.clamp(v1, if a2.Name ~= "EndPin" then 0 else Scale, if a2.Name ~= "StartPin" then 1 else Scale_2), a3),
            a2.Name,
            a3
        )
        RunService.RenderStepped:Wait()
    until a4.UserInputState == Enum.UserInputState.End or a4.UserInputState == Enum.UserInputState.Cancel
end

local u414 = {}
local u415 = 0
local u416 = 0

local function nudgeSliderPin(a1, a2) -- Line: 1004
    -- upvalues: u414 (val), sliderScaleToValue (val), setDrag (val)
    local v1 = u414[a1]
    if not v1 then
        return
    end
    local maxValue = v1.maxValue
    local Scale = a1.Position.X.Scale
    setDrag(
        v1.fill.Parent,
        if maxValue <= 1 then math.clamp((sliderScaleToValue(Scale, maxValue)) + a2 * 0.01, 0, maxValue) else if not (maxValue <= 20) then sliderScaleToValue(math.clamp(Scale + a2 * 0.01, 0, 1), maxValue) else math.clamp(math.floor((sliderScaleToValue(Scale, maxValue)) + 0.5) + a2, 0, maxValue),
        a1.Name,
        maxValue
    )
end

local function startSliderNudge(a1, a2) -- Line: 1027
    -- upvalues: GuiService (val), u414 (val), u415 (ref), nudgeSliderPin (val), GamepadNavigation (val)
    local SelectedObject = GuiService.SelectedObject
    if SelectedObject and u414[SelectedObject] then
        u415 = u415 + 1
        local u8 = u415
        nudgeSliderPin(SelectedObject, a1)
        task.delay(0.35, function() -- Line: 1037
            -- upvalues: u8 (val), u415 (upval), a2 (val), GuiService (upval), SelectedObject (val)
            -- upvalues: GamepadNavigation (upval), nudgeSliderPin (upval), a1 (val)
            while u8 == u415 do
                if not a2()
                    or GuiService.SelectedObject ~= SelectedObject
                    or not GamepadNavigation.IsUsable(SelectedObject) then
                    break
                end
                nudgeSliderPin(SelectedObject, a1)
                task.wait(0.05)
            end
        end)
        return
    end
end

UserInputService.InputBegan:Connect(function(a1) -- Line: 1051 -- upvalues: startSliderNudge (val), UserInputService (val) -- types: a1: userdata
    local KeyCode = a1.KeyCode
    if KeyCode ~= Enum.KeyCode.DPadLeft and KeyCode ~= Enum.KeyCode.DPadRight then
        return
    end
    local UserInputType = a1.UserInputType
    startSliderNudge(if KeyCode ~= Enum.KeyCode.DPadLeft then 1 else -1, function() -- Line: 1058 -- upvalues: UserInputService (upval), UserInputType (val), KeyCode (val)
        return UserInputService:IsGamepadButtonDown(UserInputType, KeyCode)
    end)
end)
UserInputService.InputChanged:Connect(function(a1) -- Line: 1063 -- upvalues: u416 (ref), startSliderNudge (val) -- types: a1: userdata
    if a1.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return
    end
    local X = a1.Position.X
    local u9 = if not (X > 0.6) then if not (X < -0.6) then 0 else -1 else 1
    if u9 == u416 then
        return
    end
    u416 = u9
    if u9 ~= 0 then
        startSliderNudge(u9, function() -- Line: 1079 -- upvalues: u416 (upval), u9 (val)
            return u416 == u9
        end)
    end
end)
UserInputService.InputEnded:Connect(function(a1) -- Line: 1087 -- upvalues: u416 (ref) -- types: a1: userdata
    if a1.KeyCode == Enum.KeyCode.Thumbstick1 then
        u416 = 0
    end
end)
UserInputService.GamepadDisconnected:Connect(function() -- Line: 1093 -- upvalues: u416 (ref), u415 (ref)
    u416 = 0
    u415 = u415 + 1
end)

local function bindSliderPin(a1, a2, a3) -- Line: 1098
    -- upvalues: MarketplaceButton (val), u414 (val), dragSlider (val)
    MarketplaceButton.new(a2, {hoverSizeMultiplier = 0.9})
    u414[a2] = {fill = a1, maxValue = a3}
    a2.NextSelectionLeft = a2
    a2.NextSelectionRight = a2
    a2.InputBegan:Connect(function(a1_2) -- Line: 1103 -- upvalues: dragSlider (upval), a1 (val), a2 (val), a3 (val) -- types: a1_2: userdata
        if a1_2.UserInputType ~= Enum.UserInputType.MouseButton1
            and a1_2.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragSlider(a1, a2, a3, a1_2)
    end)
end

local function createMarketListing(a1, a2, a3, a4, a5) -- Line: 1115
    -- upvalues: Skins (val), GetWeaponProperties (val), getRarityData (val), GetSkinDisplayName (val)
    -- upvalues: CommaNumber (val), UserCache (val), MarketPlacePrices (val), MarketplaceButton (val), u650 (ref)
    -- upvalues: showInspect (val), MarketplaceHover (val), UserInputService (val)
    if type(a2) ~= "string" or not a3 then
        return
    end
    local v1 = a1:FindFirstChild(a2)
    if v1 then
        return v1
    end
    if a4 and a4.inventoryItem then
        local v2, v3
        local v4 = Skins.GetSkinInformation(a4.inventoryItem.Name, a4.inventoryItem.Skin)
        if not v4 then
            return
        end
        local v5 = GetWeaponProperties(a4.inventoryItem.Name)
        local Type = if not v5 then a4.inventoryItem.Type else v5.Type
        local v6, v7 = Skins.GetWearNameForFloat(v4, a4.inventoryItem.Float)
        local v8 = Skins.GetAbbreviatedWearName(v7)
        local v9 = getRarityData(v4.rarity)
        local v10 = GetSkinDisplayName.GetFullItemDisplayName(
            a4.inventoryItem.Name,
            a4.inventoryItem.Skin,
            not not a4.inventoryItem.StatTrack,
            true,
            a4.inventoryItem.NameTag
        )
        local v11 = GetSkinDisplayName.GetWeaponDisplayName(a4.inventoryItem.Name, a4.inventoryItem.NameTag)
        local u71 = a3:Clone()
        u71.Name = a2
        u71.Main.ItemIcon.Image = Skins.GetItemIconImage(v4, a4.inventoryItem)
        GetSkinDisplayName.ApplyNameLabel(u71.Main.Skin, v10, a4.inventoryItem.NameTag)
        u71.Main.Status.Text = v7 or ""
        u71.Main.FloatNumber.Text = a4.inventoryItem.Float
        u71.Main.FloatBar.Frame.Position = UDim2.fromScale(a4.inventoryItem.Float, 0.5)
        u71.Main.RarityFrame.Serial.SerialText.Text = ("#%*"):format((CommaNumber(a4.inventoryItem.Serial)))
        if a4.inventoryItem.MetaData then
            for i, j in a4.inventoryItem.MetaData do
                if type(j) ~= "table" then
                    u71:SetAttribute(i, j)
                end
            end
        end
        u71:SetAttribute("Gun", v11)
        u71:SetAttribute("InternalGun", a4.inventoryItem.Name)
        u71:SetAttribute("Skin", a4.inventoryItem.Skin)
        u71:SetAttribute("InventoryItemId", a4.inventoryItem._id)
        u71:SetAttribute("Wear", v6)
        u71:SetAttribute("Type", Type)
        u71:SetAttribute("OtherType", v4.type)
        u71:SetAttribute("Float", a4.inventoryItem.Float)
        u71:SetAttribute("Collection", v4.collection)
        local Seller = u71.Main.Seller
        local Owner = a4.inventoryItem.MetaData.Owner
        Seller.Text = "Seller: ..."
        task.spawn(function() -- Line: 337 -- upvalues: UserCache (upval), Owner (val), Seller (val)
            local success, result = pcall(UserCache.Fetch, Owner)
            local Username = if not success then "Unknown User" else if not result then "Unknown User" else if not result.Username then "Unknown User" else result.Username
            if Seller.Parent then
                Seller.Text = ("Seller: %*"):format(Username)
            end
        end)
        if u71.Main:FindFirstChild("RAP") and v4.paintId then
            local v12 = MarketPlacePrices.GetItemPrice(a4.inventoryItem.Name, a4.inventoryItem.Skin, a4.inventoryItem.Float, v2)
            local recentAveragePriceTradeTokens = v12 and v12.recentAveragePriceTradeTokens
            v3 = if not recentAveragePriceTradeTokens then nil else if not (recentAveragePriceTradeTokens > 0) then nil else math.floor(recentAveragePriceTradeTokens)
            u71.Main.RAP.TextLabel.Text = ("RAP: %*"):format(if not v3 then "N/A" else CommaNumber(v3))
            u71:SetAttribute("RAP", v3 or 0)
        end
        v3 = MarketPlacePrices.GetMarketPlaceItem(a4.inventoryItem.Name, a4.inventoryItem.Skin)
        if v3 and u71.Main:FindFirstChild("Projected") then
            local statTrack = if not v2 then v3.standard else v3.statTrack
            local Default = statTrack[v6] or statTrack.Default
            local Projected = u71.Main.Projected
            local projected = false
            if Default ~= nil then
                projected = Default.projected
            end
            Projected.Visible = projected
            u71.Main.Projected.MouseEnter:Connect(function() -- Line: 1202 -- upvalues: u71 (val)
                u71.Main.Projected.Display.Visible = true
            end)
            u71.Main.Projected.MouseLeave:Connect(function() -- Line: 1206 -- upvalues: u71 (val)
                u71.Main.Projected.Display.Visible = false
            end)
            u71.Main.Projected.SelectionGained:Connect(function() -- Line: 1211 -- upvalues: u71 (val)
                u71.Main.Projected.Display.Visible = true
            end)
            u71.Main.Projected.SelectionLost:Connect(function() -- Line: 1215 -- upvalues: u71 (val)
                u71.Main.Projected.Display.Visible = false
            end)
        end
        local Type_2 = a4.inventoryItem.Type
        local v13 = false
        if Type_2 ~= "Case" then
            v13 = false
            if Type_2 ~= "Charm Capsule" then
                v13 = false
                if Type_2 ~= "Sticker Capsule" then
                    v13 = Type_2 ~= "Package"
                end
            end
        end
        if not v13 then
            u71.Main.FloatNumber.Visible = false
            u71.Main.FloatBar.Visible = false
        end
        if u71.Main.ItemIcon:FindFirstChild("Worth") and v4.paintId then
            local SerialText_2 = u71.Main.ItemIcon.Worth.SerialText
            local v14 = MarketPlacePrices.GetItemPrice(a4.inventoryItem.Name, a4.inventoryItem.Skin, a4.inventoryItem.Float, v2)
            local recentAveragePriceTradeTokens_2 = v14 and v14.recentAveragePriceTradeTokens
            local v15 = if not recentAveragePriceTradeTokens_2 then nil else if not (recentAveragePriceTradeTokens_2 > 0) then nil else math.floor(recentAveragePriceTradeTokens_2)
            SerialText_2.Text = ("RAP: %*"):format(if not v15 then "N/A" else CommaNumber(v15))
        end
        if v9 and v9.ColorSequence then
            u71.Main.RarityFrame.RarityBarGradient.Color = v9.ColorSequence
            u71.Main.RarityBG.RarityBarGradient.Color = v9.ColorSequence
        end
        u71.Main.RarityFrame.Condition.Tag.Text = v8
        v13 = u71.Main.RarityFrame.Condition[("%*Gradient"):format(v8)]
        v13.Enabled = true
        u71.Main.Credits.Visible = a4.priceTradeTokens ~= nil
        u71.Main.Credits.TextLabel.Text = if not a4.priceTradeTokens then "" else CommaNumber(a4.priceTradeTokens)
        if a5 ~= nil then
            u71.LayoutOrder = a5
        end
        u71.Parent = a1
        local Main_5 = u71:FindFirstChild("Main") and u71.Main:FindFirstChild("Tools")
        local Inspect = Main_5 and Main_5:FindFirstChild("Inspect") or nil
        if Inspect then
            MarketplaceButton.new(Inspect, {
                hoverSizeMultiplier = 0.9,
                onActivated = function() -- Line: 1251 -- upvalues: u650 (upval), showInspect (upval), a4 (val)
                    if u650.Market.PurchaseMenu.Visible then
                        return
                    end
                    showInspect(a4.inventoryItem)
                end,
            })
            local Type_3 = a4.inventoryItem.Type
            local v16 = true
            if Type_3 ~= "Case" then
                v16 = Type_3 == "Package"
            end
            if v16 then
                Inspect.Visible = false
            end
        end
        local UserDescription = Main_5 and Main_5:FindFirstChild("UserDescription") or nil
        if UserDescription then
            MarketplaceButton.new(UserDescription, {
                hoverSizeMultiplier = 0.9,
                onActivated = function() -- Line: 1268 -- upvalues: u650 (upval), MarketplaceHover (upval), a4 (val), u71 (val)
                    if not u650.Market.PurchaseMenu.Visible then
                        MarketplaceHover:OpenTradeInfo(a4.inventoryItem, u71)
                    end
                end,
            })
            if not UserInputService.TouchEnabled then
                UserDescription.MouseEnter:Connect(function() -- Line: 1276 -- upvalues: MarketplaceHover (upval), a4 (val), u71 (val)
                    MarketplaceHover:Open(a4.inventoryItem, u71)
                end)
                UserDescription.MouseLeave:Connect(function() -- Line: 1279 -- upvalues: MarketplaceHover (upval), u71 (val)
                    MarketplaceHover:Close(u71)
                end)
            end
        end
        return u71
    end
end

local function removeYourListingByInventoryItemId(a1) -- Line: 1288 -- upvalues: u650 (ref) -- types: a1: string
    for i, j in u650.Profile.Main.Frame.YourListings.YourListings:GetChildren() do
        if j:IsA("Frame") and j:GetAttribute("InventoryItemId") == a1 then
            j:Destroy()
            return
        end
    end
end

local function addYourListing(a1) -- Line: 1298
    -- upvalues: u651 (ref), Skins (val), u650 (ref), createMarketListing (val), CommaNumber (val), LocalPlayer (val)
    -- upvalues: MarketplaceButton (val), u657 (ref), GlobalMarketplace (val)
    if a1.inventoryItem and a1.listing_reference_id and u651 then
        if not Skins.HasSkinTextures(a1.inventoryItem.Name, a1.inventoryItem.Skin) then
            return
        end
        local YourListings = u650.Profile.Main.Frame.YourListings.YourListings
        if YourListings:FindFirstChild(a1.listing_reference_id) then
            return
        end
        local u26 = createMarketListing(YourListings, a1.listing_reference_id, u651, a1)
        if not u26 then
            return
        end
        local priceTradeTokens = a1.priceTradeTokens or a1.tradeTokens
        u26.Main.Credits.TextLabel.Text = if not priceTradeTokens then "N/A" else CommaNumber(priceTradeTokens)
        u26.Main.Credits.Visible = true
        u26.Main.Delist.Visible = true
        u26.Main.Delist.Visible = a1.inventoryItem.MetaData.Owner == LocalPlayer.UserId
        local _id = a1.inventoryItem._id
        MarketplaceButton.new(u26.Main.Delist, {
            hoverSizeMultiplier = 0.9,
            onActivated = function() -- Line: 1326 -- upvalues: u650 (upval), u657 (upval), GlobalMarketplace (upval), _id (val), u26 (val)
                u650.Parent.Parent.Loading.Visible = true
                u657:Play()
                GlobalMarketplace.DelistItem.Send(_id)
                u26:Destroy()
                local v1 = u650.Sell.Container:FindFirstChild(_id)
                if v1 then
                    v1.Visible = true
                    v1.Main.Sell.Visible = true
                    v1.Main.Delist.Visible = false
                end
            end,
        })
        return u26
    end
end

local function getInventoryItemById(a1) -- Line: 1343
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Inventory")
    if not v1 then
        return nil
    end
    for i, j in v1 do
        if j._id == a1 then
            return j
        end
    end
    return nil
end

local function withListingReference(a1, a2) -- Line: 1358 -- types: a2: string
    if a1.MetaData and a1.MetaData.GlobalMarketPlaceListingReference == a2 then
        return a1
    end
    local v1 = table.clone(a1)
    v1.MetaData = table.clone(a1.MetaData or {})
    v1.MetaData.GlobalMarketPlaceListingReference = a2
    return v1
end

local function syncListedItemToProfile(a1) -- Line: 1369
    -- upvalues: u628 (val), DataController (val), LocalPlayer (val), addYourListing (val), withListingReference (val)
    local priceTradeTokens
    local inventoryItemId = a1.inventoryItemId or a1.inventory_item_id
    if typeof(inventoryItemId) ~= "string" then
        return false
    end
    local v1 = u628[inventoryItemId]
    local listing_reference_id = a1.listing_reference_id or a1.listingReferenceId or v1 and v1.listingReferenceId
    local inventoryItem = a1.inventoryItem
    if not inventoryItem then
        local v2
        if not v1 then
            v2 = DataController.Get(LocalPlayer, "Inventory")
            if v2 then
                for i, j in v2 do
                    if j._id == inventoryItemId then
                        inventoryItem = j
                        if inventoryItem and not listing_reference_id and inventoryItem.MetaData then
                            listing_reference_id = inventoryItem.MetaData.GlobalMarketPlaceListingReference
                        end
                        if typeof(inventoryItem) == "table"
                            and typeof(listing_reference_id) == "string"
                            and listing_reference_id ~= "" then
                            priceTradeTokens = a1.priceTradeTokens or a1.price_trade_tokens or v1 and v1.Price
                            return addYourListing({
                                listing_reference_id = listing_reference_id,
                                priceTradeTokens = priceTradeTokens,
                                tradeTokens = priceTradeTokens or 0,
                                date = os.time(),
                                inventoryItem = withListingReference(inventoryItem, listing_reference_id),
                            }) ~= nil
                        end
                        return false
                    end
                end
            end
            inventoryItem = nil
        else
            inventoryItem = v1.inventoryItem
            if not inventoryItem then
                v2 = DataController.Get(LocalPlayer, "Inventory")
                if v2 then
                    for k, n in v2 do
                        if n._id == inventoryItemId then
                            inventoryItem = n
                            if inventoryItem and not listing_reference_id and inventoryItem.MetaData then
                                listing_reference_id = inventoryItem.MetaData.GlobalMarketPlaceListingReference
                            end
                            if typeof(inventoryItem) == "table"
                                and typeof(listing_reference_id) == "string"
                                and listing_reference_id ~= "" then
                                priceTradeTokens = a1.priceTradeTokens or a1.price_trade_tokens or v1 and v1.Price
                                return addYourListing({
                                    listing_reference_id = listing_reference_id,
                                    priceTradeTokens = priceTradeTokens,
                                    tradeTokens = priceTradeTokens or 0,
                                    date = os.time(),
                                    inventoryItem = withListingReference(inventoryItem, listing_reference_id),
                                }) ~= nil
                            end
                            return false
                        end
                    end
                end
                inventoryItem = nil
            end
        end
    end
    if inventoryItem and not listing_reference_id and inventoryItem.MetaData then
        listing_reference_id = inventoryItem.MetaData.GlobalMarketPlaceListingReference
    end
    if typeof(inventoryItem) == "table"
        and typeof(listing_reference_id) == "string"
        and listing_reference_id ~= "" then
        priceTradeTokens = a1.priceTradeTokens or a1.price_trade_tokens or v1 and v1.Price
        return addYourListing({
            listing_reference_id = listing_reference_id,
            priceTradeTokens = priceTradeTokens,
            tradeTokens = priceTradeTokens or 0,
            date = os.time(),
            inventoryItem = withListingReference(inventoryItem, listing_reference_id),
        }) ~= nil
    end
    return false
end

local function setupMarket() -- Line: 1402
    -- upvalues: u651 (ref), u650 (ref), MarketplaceButton (val), openTradeTokensStore (val), u658 (ref)
    -- upvalues: TweenService (val), u636 (ref), AssetService (val), CommaNumber (val), formatSaleDate (val)
    -- upvalues: UserInputService (val), GuiService (val), UserCache (val), Players (val), hideQuickPick (val)
    -- upvalues: u638 (ref), GlobalMarketplace (val), u654 (ref), showInspect (val), deepCopy (val), Skins (val)
    -- upvalues: u653 (ref), Router (val), getMarketplaceErrorMessage (val), u620 (ref), u614 (val)
    -- upvalues: DataController (val), LocalPlayer (val), ReplicatedStorage (val), MenuState (val), Store (val)
    -- upvalues: u657 (ref), CloseButtonRegistry (val), GamepadNavigation (val), CollectionServiceUtility (val)
    -- upvalues: GetSkinDisplayName (val), FuzzySearch (val), u629 (val), u631 (val), u630 (ref), u640 (ref), u627 (ref)
    -- upvalues: u626 (ref), u622 (val), listingMatchesSelectedWearTiers (val), createMarketListing (val)
    -- upvalues: removeYourListingByInventoryItemId (val), destroyListingCard (val), addYourListing (val)
    -- upvalues: pruneOldestListingFrames (val), getWearSearchRangeFromSelection (val), abandonSearchAfterTimeout (ref)
    -- upvalues: bindSliderPin (val), setDrag (val), CollectionService (val), Constants (val), u616 (val)
    -- upvalues: setupWearTierButtons (val), u644 (ref), schedulePredictSearch (val), u621 (ref)
    -- upvalues: MarketplaceDropdown (val)
    local v1, v2, v3
    u651 = u650.Market.Container.Template:Clone()
    u650.Market.Container.Template:Destroy()
    MarketplaceButton.new(u650.Top.TradeTokens.PurchaseMore, {hoverSizeMultiplier = 0.9, onActivated = openTradeTokensStore})
    local u23 = nil
    local Main = u650.Market.PurchaseMenu.Main

    local function clearPurchaseMenuTransactions() -- Line: 1415 -- upvalues: Main (val)
        for i, j in Main.Main.Transactions.Listings:GetChildren() do
            if j:IsA("Frame") then
                j:Destroy()
            end
        end
        for k, n in Main.Main.Similar.Listings:GetChildren() do
            if n:IsA("Frame") then
                n:Destroy()
            end
        end
    end

    u658 = TweenService:Create(
        Main.Main.SalesGraph.Loading,
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, (1 / 0)),
        {Rotation = 359}
    )
    Main.Main.Template.Projected.MouseEnter:Connect(function() -- Line: 1437 -- upvalues: Main (val)
        Main.Main.Template.Projected.Display.Visible = true
    end)
    Main.Main.Template.Projected.MouseLeave:Connect(function() -- Line: 1441 -- upvalues: Main (val)
        Main.Main.Template.Projected.Display.Visible = false
    end)
    Main.Main.Template.Projected.SelectionGained:Connect(function() -- Line: 1445 -- upvalues: Main (val)
        Main.Main.Template.Projected.Display.Visible = true
    end)
    Main.Main.Template.Projected.SelectionLost:Connect(function() -- Line: 1449 -- upvalues: Main (val)
        Main.Main.Template.Projected.Display.Visible = false
    end)

    local function getSalesGraphDotted() -- Line: 1453 -- upvalues: Main (val)
        local SalesGraph = Main.Main.SalesGraph
        local Dotted = SalesGraph:FindFirstChild("Dotted")
        if Dotted and Dotted:IsA("GuiObject") then
            return Dotted
        end
        local v1 = SalesGraph.GraphVisual:FindFirstChild("Dotted")
        if v1 and v1:IsA("GuiObject") then
            return v1
        end
        return nil
    end

    local function hideSalesGraphHover() -- Line: 1466 -- upvalues: Main (val)
        local v1
        local SaleInfo = Main.Main.SalesGraph:FindFirstChild("SaleInfo")
        if SaleInfo and SaleInfo:IsA("GuiObject") then
            SaleInfo.Visible = false
        end
        local SalesGraph = Main.Main.SalesGraph
        local Dotted = SalesGraph:FindFirstChild("Dotted")
        if not Dotted or not Dotted:IsA("GuiObject") then
            local v2 = SalesGraph.GraphVisual:FindFirstChild("Dotted")
            v1 = if not v2 then nil else if not v2:IsA("GuiObject") then nil else v2
        else
            v1 = Dotted
        end
        if v1 then
            v1.Visible = false
        end
    end

    local function clearGraphVisual() -- Line: 1477 -- upvalues: Main (val)
        local v1
        local SaleInfo = Main.Main.SalesGraph:FindFirstChild("SaleInfo")
        if SaleInfo and SaleInfo:IsA("GuiObject") then
            SaleInfo.Visible = false
        end
        local SalesGraph = Main.Main.SalesGraph
        local Dotted = SalesGraph:FindFirstChild("Dotted")
        if not Dotted or not Dotted:IsA("GuiObject") then
            local v2 = SalesGraph.GraphVisual:FindFirstChild("Dotted")
            v1 = if not v2 then nil else if not v2:IsA("GuiObject") then nil else v2
        else
            v1 = Dotted
        end
        if v1 then
            v1.Visible = false
        end
        local GraphVisual = Main.Main.SalesGraph.GraphVisual
        for i, j in GraphVisual:GetChildren() do
            if j.Name ~= "Dotted" then
                j:Destroy()
            end
        end
        GraphVisual.ImageContent = Content.none
    end

    local function alignDottedToGraphX(a1) -- Line: 1488 -- upvalues: Main (val) -- types: a1: number
        local v1
        local SalesGraph = Main.Main.SalesGraph
        local Dotted = SalesGraph:FindFirstChild("Dotted")
        if not Dotted or not Dotted:IsA("GuiObject") then
            local v2 = SalesGraph.GraphVisual:FindFirstChild("Dotted")
            v1 = if not v2 then nil else if not v2:IsA("GuiObject") then nil else v2
        else
            v1 = Dotted
        end
        if not v1 then
            return
        end
        local Parent = v1.Parent
        local GraphVisual = Main.Main.SalesGraph.GraphVisual
        if Parent == GraphVisual then
            v1.Position = UDim2.new(a1, 0, v1.Position.Y.Scale, v1.Position.Y.Offset)
        elseif Parent and Parent:IsA("GuiObject") and 0 < Parent.AbsoluteSize.X then
            v1.Position = UDim2.new(
                (GraphVisual.AbsolutePosition.X + a1 * GraphVisual.AbsoluteSize.X - Parent.AbsolutePosition.X) / Parent.AbsoluteSize.X,
                0,
                v1.Position.Y.Scale,
                v1.Position.Y.Offset
            )
        end
        v1.ZIndex = math.max(v1.ZIndex, 21)
        v1.Visible = true
    end

    local function plotGraph(a1, a2) -- Line: 1506
        -- upvalues: u636 (upval), clearGraphVisual (val), Main (val), AssetService (upval), alignDottedToGraphX (val)
        -- upvalues: CommaNumber (upval), formatSaleDate (upval), UserInputService (upval), GuiService (upval)
        local averageTradeTokens, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
        if u636 then
            u636:Destroy()
            u636 = nil
        end
        clearGraphVisual()
        if #a1 == 0 then
            return
        end
        local u720 = Vector2.new(
            math.clamp(Main.Main.SalesGraph.GraphVisual.AbsoluteSize.X, 0, 1024),
            (math.clamp(Main.Main.SalesGraph.GraphVisual.AbsoluteSize.Y, 0, 1024))
        )
        local success, result = pcall(function() -- Line: 1521 -- upvalues: AssetService (upval), u720 (val)
            return AssetService:CreateEditableImage({Size = u720})
        end)
        u636 = if not success then nil else result
        local AbsoluteSize = Main.Main.SalesGraph.GraphVisual.AbsoluteSize
        local v12 = (-1 / 0)
        local priorAverageTradeTokens_2 = a2 and not (type(a2.priorAverageTradeTokens) ~= "number") and a2.priorAverageTradeTokens or nil
        for i, j in a1 do
            v12 = math.max(v12, j.averageTradeTokens)
        end
        if priorAverageTradeTokens_2 then
            v12 = math.max(v12, priorAverageTradeTokens_2)
        end

        local function roundUpTo5(a1) -- Line: 1547 -- types: a1: number
            return math.ceil(a1 / 5) * 5
        end

        v12 = math.ceil(v12 / 5) * 5
        local u747 = v12 - 0
        if u747 == 0 then
            u747 = 1
        end

        local function toScreen(a1, a2, a3) -- Line: 1557
            -- upvalues: u720 (val), u747 (ref)
            local v1 = u720
            local v2 = v1.X - 10
            return Vector2.new(if not (a2 <= 1) then 5 + (a1 - 1) / (a2 - 1) * v2 else 5 + v2 / 2, v1.Y - 5 - (a3 - 0) / u747 * (v1.Y - 10))
        end

        local u590 = {}
        local u761 = #a1
        local v13 = nil
        local v14 = nil
        for k, n in a1, v13, v14 do
            averageTradeTokens = n.averageTradeTokens
            v2 = u720.X - 10
            v3 = u720.Y - 10
            v4 = if not (u761 <= 1) then 5 + (k - 1) / (u761 - 1) * v2 else 5 + v2 / 2
            v5 = u720.Y - 5 - (averageTradeTokens - 0) / u747 * v3
            u590[k] = (Vector2.new(v4, v5))
        end
        local Size = u636.Size
        local X_2 = Size.X
        local Y_2 = Size.Y
        local v15 = Y_2 - 5
        if u636 then
            local v16, v17, v18, v19, v20
            local u322 = buffer.create(X_2 * Y_2 * 4)
            local v21 = X_2 * Y_2 * 4 - 1
            for m = 0, v21 do
                buffer.writeu8(u322, m, 0)
            end
            v21 = Color3.new(0, 0.8, 1)
            v1 = #u590 - 1
            for i5 = 1, v1 do
                v4 = u590[i5]
                v5 = u590[i5 + 1]
                v6 = math.floor(v4.X)
                v16 = math.floor(v5.X)
                if v16 < v6 then
                    v17 = v16
                    v16 = v6
                    v6 = v17
                    v17 = v5
                    v5 = v4
                    v4 = v17
                end
                v17 = v5.X - v4.X
                if v17 ~= 0 then
                    for i6 = v6, v16 do
                        v8 = (i6 - v4.X) / v17
                        if v8 >= 0 and v8 <= 1 then
                            for i7 = math.floor(v4.Y + (v5.Y - v4.Y) * v8), v15 do
                                if i7 >= 0 and i7 < Y_2 then
                                    v18 = (i7 * X_2 + i6) * 4
                                    v20 = v21.R * 255
                                    buffer.writeu8(u322, v18, v20)
                                    v19 = v18 + 1
                                    v20 = v21.G * 255
                                    buffer.writeu8(u322, v19, v20)
                                    v19 = v18 + 2
                                    v20 = v21.B * 255
                                    buffer.writeu8(u322, v19, v20)
                                    v19 = v18 + 3
                                    buffer.writeu8(u322, v19, 80)
                                end
                            end
                        end
                    end
                end
            end
            if not pcall(function() -- Line: 1633 -- upvalues: u636 (upval), Size (val), u322 (val)
                local v0, v1, v3, v4, zero
                v0 = u636
                zero = Vector2.zero
                v3 = Size
                v4 = u322
                v0:WritePixelsBuffer(zero, v3, v4)
                return
            end) then
                u636:Destroy()
                u636 = nil
            else
                clearGraphVisual()
            end
        end

        local function createPointFrame(a1) -- Line: 1644 -- upvalues: u720 (val), Main (upval) -- types: a1: userdata
            local v1 = Vector2.new(a1.X / u720.X, a1.Y / u720.Y)
            local Frame = Instance.new("Frame")
            Frame.Name = "GraphPoint"
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromScale(v1.X, v1.Y)
            Frame.Size = UDim2.fromOffset(12, 12)
            Frame.BackgroundColor3 = Color3.new(0, 0.403921, 0.733333)
            Frame.BackgroundTransparency = 0
            Frame.BorderSizePixel = 0
            Frame.ZIndex = 6
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Frame
            Frame.Parent = Main.Main.SalesGraph.GraphVisual
        end

        local function createLineFrame(a1, a2, a3) -- Line: 1663
            -- upvalues: u720 (val), AbsoluteSize (val), Main (upval)
            local v1 = Vector2.new(a1.X / u720.X, a1.Y / u720.Y)
            local v2 = Vector2.new(a2.X / u720.X, a2.Y / u720.Y)
            local v3 = v2.X - v1.X
            local v4 = v2.Y - v1.Y
            local v5 = math.sqrt((v3 * AbsoluteSize.X) ^ 2 + (v4 * AbsoluteSize.Y) ^ 2)
            if v5 == 0 then
                return
            end
            local v6 = Vector2.new((v1.X + v2.X) / 2, (v1.Y + v2.Y) / 2)
            local v7 = math.deg((math.atan2((v2.Y - v1.Y) * AbsoluteSize.Y, (v2.X - v1.X) * AbsoluteSize.X)))
            local Frame = Instance.new("Frame")
            Frame.Name = "GraphLine"
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromScale(v6.X, v6.Y)
            Frame.Size = UDim2.new(UDim.new(v5 / AbsoluteSize.X, 0), UDim.new(0, a3 * 2 + 1))
            Frame.Rotation = v7
            Frame.BackgroundColor3 = Color3.new(0, 0.349019, 0.631372)
            Frame.BackgroundTransparency = 0
            Frame.BorderSizePixel = 0
            Frame.ZIndex = 5
            Frame.Parent = Main.Main.SalesGraph.GraphVisual
        end

        v1 = #u590 - 1
        for i8 = 1, v1 do
            createLineFrame(u590[i8], u590[i8 + 1], 2)
        end
        for i9, i10 in u590 do
            createPointFrame(i10)
        end
        local SaleInfo = Main.Main.SalesGraph.SaleInfo
        local Info = SaleInfo.Info
        local SaleInfo_2 = Main.Main.SalesGraph:FindFirstChild("SaleInfo")
        if SaleInfo_2 and SaleInfo_2:IsA("GuiObject") then
            SaleInfo_2.Visible = false
        end
        local SalesGraph_3 = Main.Main.SalesGraph
        local Dotted = SalesGraph_3:FindFirstChild("Dotted")
        if not Dotted or not Dotted:IsA("GuiObject") then
            v6 = SalesGraph_3.GraphVisual:FindFirstChild("Dotted")
            v4 = if not v6 then nil else if not v6:IsA("GuiObject") then nil else v6
        else
            v4 = Dotted
        end
        if v4 then
            v4.Visible = false
        end
        local ImageButton = Instance.new("ImageButton")
        ImageButton.Name = "HoverCatch"
        ImageButton.BackgroundTransparency = 1
        ImageButton.ImageTransparency = 1
        ImageButton.AutoButtonColor = false
        ImageButton.Size = UDim2.fromScale(1, 1)
        ImageButton.ZIndex = 20
        ImageButton.Parent = Main.Main.SalesGraph.GraphVisual
        local u463 = nil

        local function showNearestPoint(a1_2) -- Line: 1715
            -- upvalues: u590 (val), a1 (val), u720 (val), alignDottedToGraphX (upval), u463 (ref), SaleInfo (val)
            -- upvalues: Main (upval), Info (val), CommaNumber (upval), formatSaleDate (upval)
            local v1 = u590[a1_2]
            local v2 = a1[a1_2]
            if v1 and v2 then
                local v3
                local v4 = v1.X / u720.X
                alignDottedToGraphX(v4)
                if u463 == a1_2 and SaleInfo.Visible then
                    return
                end
                u463 = a1_2
                local SalesGraph = Main.Main.SalesGraph
                local GraphVisual = SalesGraph.GraphVisual
                local v5 = GraphVisual.AbsolutePosition + (Vector2.new(v4 * GraphVisual.AbsoluteSize.X, v1.Y / u720.Y * GraphVisual.AbsoluteSize.Y)) - SalesGraph.AbsolutePosition
                local AbsoluteSize_2 = SaleInfo.AbsoluteSize
                local v6 = if not (v5.X < SalesGraph.AbsoluteSize.X / 2) then v5.X - AbsoluteSize_2.X - 10 else v5.X + AbsoluteSize_2.X + 10
                SaleInfo.AnchorPoint = Vector2.new(if not v3 then 0 else 1, 1)
                SaleInfo.Position = UDim2.fromOffset(v6, v5.Y + 10)
                Info.Amount.Text = ("Sold %*"):format(v2.amount_sold)
                Info.Credits.TextLabel.Text = CommaNumber((math.floor(v2.averageTradeTokens)))
                Info.Date.Text = formatSaleDate(v2.date)
                SaleInfo.Visible = true
                return
            end
        end

        ImageButton.MouseMoved:Connect(function() -- Line: 1749
            -- upvalues: u590 (val), u720 (val), Main (upval), UserInputService (upval), GuiService (upval)
            -- upvalues: showNearestPoint (val)
            if #u590 ~= 0 and not (u720.X <= 0) and not (u720.Y <= 0) then
                local GraphVisual = Main.Main.SalesGraph.GraphVisual
                local AbsoluteSize = GraphVisual.AbsoluteSize
                if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
                    local v1, v2
                    local v3 = (UserInputService:GetMouseLocation()) - GuiService:GetGuiInset()
                    local v4 = 1
                    local v5 = (1 / 0)
                    for i, j in u590 do
                        v1 = v3 - (GraphVisual.AbsolutePosition + Vector2.new(j.X / u720.X * AbsoluteSize.X, j.Y / u720.Y * AbsoluteSize.Y))
                        v2 = v1.X * v1.X + v1.Y * v1.Y
                        if v2 < v5 then
                            v4 = i
                        end
                    end
                    showNearestPoint(v4)
                    return
                end
                return
            end
        end)
        ImageButton.MouseLeave:Connect(function() -- Line: 1776 -- upvalues: u463 (ref), Main (upval)
            local v1
            u463 = nil
            local SaleInfo = Main.Main.SalesGraph:FindFirstChild("SaleInfo")
            if SaleInfo and SaleInfo:IsA("GuiObject") then
                SaleInfo.Visible = false
            end
            local SalesGraph = Main.Main.SalesGraph
            local Dotted = SalesGraph:FindFirstChild("Dotted")
            if not Dotted or not Dotted:IsA("GuiObject") then
                local v2 = SalesGraph.GraphVisual:FindFirstChild("Dotted")
                v1 = if not v2 then nil else if not v2:IsA("GuiObject") then nil else v2
            else
                v1 = Dotted
            end
            if v1 then
                v1.Visible = false
            end
        end)

        local function getIndex(a1) -- Line: 1782 -- upvalues: u761 (val) -- types: a1: number
            if a1 == 1 then
                return 1
            end
            if a1 == 6 then
                return u761
            end
            return (math.floor((a1 - 1) / 5 * (u761 - 1) + 1 + 0.5))
        end

        local function createAxisLabel(a1, a2) -- Line: 1794 -- types: a1: string, a2: number
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "AxisLabel"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = a1
            TextLabel.TextSize = 10
            TextLabel.TextColor3 = Color3.new(1, 1, 1)
            TextLabel.Size = UDim2.fromOffset(a2, 15)
            return TextLabel
        end

        for i11 = 1, 6 do
            v8 = u590[if i11 == 1 then 1 else if i11 ~= 6 then math.floor((i11 - 1) / 5 * (u761 - 1) + 1 + 0.5) else u761]
            if v8 then
                v10 = os.date("%x", a1[v7].date)
                v9 = Instance.new("TextLabel")
                v9.Name = "AxisLabel"
                v9.BackgroundTransparency = 1
                v9.Text = v10
                v9.TextSize = 10
                v9.TextColor3 = Color3.new(1, 1, 1)
                v9.Size = UDim2.fromOffset(60, 15)
                v9.AnchorPoint = Vector2.new(0.5, 1)
                v9.Position = UDim2.new(UDim.new(v8.X / u720.X, 0), UDim.new(1, 0))
                v9.Parent = Main.Main.SalesGraph.GraphVisual
            end
        end
        for i12 = 0, 5 do
            v7 = math.floor((i12 / 5 * v12 + 2.5) / 5) * 5
            v8 = (v7 - 0) / u747
            v9 = Y_2 - 5 - v8 * (Y_2 - 10)
            v11 = CommaNumber(v7)
            v10 = Instance.new("TextLabel")
            v10.Name = "AxisLabel"
            v10.BackgroundTransparency = 1
            v10.Text = v11
            v10.TextSize = 10
            v10.TextColor3 = Color3.new(1, 1, 1)
            v10.Size = UDim2.fromOffset(30, 15)
            v10.AnchorPoint = Vector2.new(1, 0.5)
            v10.TextXAlignment = Enum.TextXAlignment.Right
            v10.Position = UDim2.fromOffset(1, v9)
            v10.Parent = Main.Main.SalesGraph.GraphVisual
            if v7 > 99 then
                v10.AnchorPoint = Vector2.new(0, 0.5)
                v10.TextXAlignment = Enum.TextXAlignment.Left
            end
        end
        if u636 then
            Main.Main.SalesGraph.GraphVisual.ImageContent = Content.fromObject(u636)
        end
    end

    local function confirmBuy(a1) -- Line: 1843
        -- upvalues: UserCache (upval), u23 (ref), Main (val), CommaNumber (upval), Players (upval)
        -- upvalues: hideQuickPick (upval), u636 (upval), clearPurchaseMenuTransactions (val), clearGraphVisual (val)
        -- upvalues: u658 (upval), u638 (upval), GlobalMarketplace (upval)
        local v1 = UserCache.Fetch(u23.inventoryItem.MetaData.Owner)
        Main.Main.Credits.TextLabel.Text = u23.priceTradeTokens and CommaNumber(u23.priceTradeTokens) or "N/A"
        Main.Main.FloatBar.Frame.Position = UDim2.fromScale(u23.inventoryItem.Float, 0.5)
        Main.Main.FloatNum.Text = u23.inventoryItem.Float
        Main.Main.SerialNum.Text = ("#%*"):format((CommaNumber(u23.inventoryItem.Serial)))
        Main.Main.Info.Status.Text = a1.Main.Status.Text
        Main.Main.Info.Skin.Text = a1.Main.Skin.Text
        Main.Main.Player.Player.Image = Players:GetUserThumbnailAsync(u23.inventoryItem.MetaData.Owner, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
        Main.Main.Player.DisplayName.Text = v1.DisplayName
        Main.Main.Player.Username.Text = v1.Username
        Main.Main.Template.ItemIcon.Image = a1.Main.ItemIcon.Image
        Main.Main.Template.Projected.Visible = a1.Main.Projected.Visible
        Main.Main.Template.RarityBG.RarityBarGradient.Color = a1.Main.RarityBG.RarityBarGradient.Color
        local v2 = a1.Main.RarityFrame:Clone()
        v2.Size = Main.Main.Template.RarityFrame.Size
        v2.Position = Main.Main.Template.RarityFrame.Position
        Main.Main.Template.RarityFrame:Destroy()
        v2.Parent = Main.Main.Template
        hideQuickPick()
        Main.Parent.Visible = true
        Main.Main.Purchase.Visible = u23.priceTradeTokens ~= nil
        if u636 then
            u636:Destroy()
        end
        clearPurchaseMenuTransactions()
        clearGraphVisual()
        Main.Main.SalesGraph.Loading.Visible = true
        u658:Play()
        u638 = u23.inventoryItem._id
        GlobalMarketplace.FetchRAP.Send(u638)
    end

    local function fillSimilarListingRow(a1, a2, a3) -- Line: 1883
        -- upvalues: UserCache (upval), CommaNumber (upval), Players (upval)
        local v1 = UserCache.Fetch(a3)
        a1.Name = a2.listing_reference_id
        local Float = a1.Float
        local Type = a2.inventoryItem.Type
        local v2 = false
        if Type ~= "Case" then
            v2 = false
            if Type ~= "Charm Capsule" then
                v2 = false
                if Type ~= "Sticker Capsule" then
                    v2 = Type ~= "Package"
                end
            end
        end
        Float.Text = if not v2 then "N/A" else tostring(a2.inventoryItem.Float)
        a1.Serial.Text = if not a2.inventoryItem.Serial then "N/A" else ("#%*"):format((CommaNumber(a2.inventoryItem.Serial)))
        a1.Credits.TextLabel.Text = CommaNumber(a2.priceTradeTokens)
        a1.Player.DisplayName.Text = v1.DisplayName
        a1.Player.Player.Image = Players:GetUserThumbnailAsync(a3, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
        local Inspect = a1.Inspect
        local Type_2 = a2.inventoryItem.Type
        v2 = true
        if Type_2 ~= "Case" then
            v2 = Type_2 == "Package"
        end
        Inspect.Visible = not v2
    end

    GlobalMarketplace.FetchedRAP.Listen(function(a1) -- Line: 1896
        -- upvalues: u638 (upval), clearPurchaseMenuTransactions (val), u654 (upval), fillSimilarListingRow (val)
        -- upvalues: Main (val), MarketplaceButton (upval), showInspect (upval), deepCopy (upval), u23 (ref)
        -- upvalues: UserCache (upval), CommaNumber (upval), Players (upval), Skins (upval), u653 (upval)
        -- upvalues: formatSaleDate (upval), plotGraph (val), u658 (upval)
        if a1 and a1.inventoryItemId == u638 then
            local itemData = a1.itemData
            clearPurchaseMenuTransactions()
            if itemData and itemData.next_inventory_items then
                for i, j in itemData.next_inventory_items do
                    local u20 = u654:Clone()
                    fillSimilarListingRow(u20, j, j.sellerUserId)
                    u20.Parent = Main.Main.Similar.Listings
                    MarketplaceButton.new(u20.Inspect, {
                        hoverSizeMultiplier = 0.9,
                        onActivated = function() -- Line: 1913 -- upvalues: showInspect (upval), j (val)
                            showInspect(j.inventoryItem)
                        end,
                    })
                    MarketplaceButton.new(u20.View, {
                        hoverSizeMultiplier = 0.9,
                        onActivated = function() -- Line: 1921
                            -- upvalues: deepCopy (upval), u23 (upval), itemData (val), i (val)
                            -- upvalues: fillSimilarListingRow (upval), u20 (val), UserCache (upval), Main (upval)
                            -- upvalues: CommaNumber (upval), Players (upval), Skins (upval)
                            local v1
                            local v2 = deepCopy(u23)
                            v2.sellerUserId = u23.inventoryItem.MetaData.Owner
                            u23 = deepCopy(itemData.next_inventory_items[i])
                            itemData.next_inventory_items[i] = v2
                            fillSimilarListingRow(u20, v2, v2.inventoryItem.MetaData.Owner)
                            local v3 = UserCache.Fetch(u23.inventoryItem.MetaData.Owner)
                            Main.Main.Template.RarityFrame.Serial.SerialText.Text = ("#%*"):format((CommaNumber(u23.inventoryItem.Serial)))
                            Main.Main.SerialNum.Text = ("#%*"):format((CommaNumber(u23.inventoryItem.Serial)))
                            Main.Main.Credits.TextLabel.Text = if not u23.priceTradeTokens then "N/A" else CommaNumber(u23.priceTradeTokens)
                            Main.Main.Player.DisplayName.Text = v3.DisplayName
                            Main.Main.Player.Username.Text = v3.Username
                            Main.Main.Player.Player.Image = Players:GetUserThumbnailAsync(
                                u23.inventoryItem.MetaData.Owner,
                                Enum.ThumbnailType.HeadShot,
                                Enum.ThumbnailSize.Size180x180
                            )
                            local v4 = Skins.GetSkinInformation(u23.inventoryItem.Name, u23.inventoryItem.Skin)
                            _, v1 = Skins.GetWearNameForFloat(v4, u23.inventoryItem.Float)
                            local v5 = Skins.GetAbbreviatedWearName(v1)
                            for i2, j in Main.Main.Template.RarityFrame.Condition:GetChildren() do
                                if j:IsA("UIGradient") then
                                    j.Enabled = false
                                end
                            end
                            Main.Main.Template.RarityFrame.Condition.Tag.Text = v5
                            local v6 = Main.Main.Template.RarityFrame.Condition[("%*Gradient"):format(v5)]
                            v6.Enabled = true
                            Main.Main.FloatBar.Frame.Position = UDim2.fromScale(u23.inventoryItem.Float, 0.5)
                            Main.Main.FloatNum.Text = tostring(u23.inventoryItem.Float)
                            Main.Main.Purchase.Visible = u23.priceTradeTokens ~= nil
                        end,
                    })
                end
            end
            if itemData and itemData.latest_sales then
                local Float_2, Inspect_2, Type, inventoryItem, v1, v2, v3
                local v4 = nil
                local v5 = nil
                for k, n in itemData.latest_sales, v4, v5 do
                    v2 = u653:Clone()
                    v2.Name = n.listingReferenceId
                    v2.Float.Text = n.float and n.float or 0
                    Float_2 = v2.Float
                    inventoryItem = u23.inventoryItem and u23.inventoryItem.Type
                    v3 = false
                    if inventoryItem ~= "Case" then
                        v3 = false
                        if inventoryItem ~= "Charm Capsule" then
                            v3 = false
                            if inventoryItem ~= "Sticker Capsule" then
                                v3 = inventoryItem ~= "Package"
                            end
                        end
                    end
                    Float_2.Visible = v3
                    v2.Date.Text = formatSaleDate(n.date)
                    v2.Serial.Text = if not n.serial then "N/A" else CommaNumber(n.serial)
                    v2.Credits.TextLabel.Text = CommaNumber(n.tradeTokens)
                    v2.Parent = Main.Main.Transactions.Listings
                    local u113 = {}
                    for m, i5 in u23.inventoryItem do
                        if m ~= "Float" then
                            u113[m] = i5
                        end
                    end
                    u113.Float = n.float and n.float or 0
                    u113.Serial = n.serial and n.serial or 0
                    Inspect_2 = v2.Inspect
                    Type = u113.Type
                    v1 = true
                    if Type ~= "Case" then
                        v1 = Type == "Package"
                    end
                    Inspect_2.Visible = not v1
                    MarketplaceButton.new(v2.Inspect, {
                        hoverSizeMultiplier = 0.9,
                        onActivated = function() -- Line: 1989 -- upvalues: showInspect (upval), u113 (val)
                            showInspect(u113)
                        end,
                    })
                end
            end
            if itemData and itemData.sales_graph then
                plotGraph(itemData.sales_graph, itemData.rapGraphReference)
            end
            Main.Main.SalesGraph.Loading.Visible = false
            u658:Pause()
            return
        end
    end)
    GlobalMarketplace.NewItem.Listen(function(a1) -- Line: 2004 -- upvalues: Router (upval) -- types: a1: table
        local v1 = #a1
        Router.broadcastRouter(
            "CreateNotification",
            "Marketplace",
            if v1 ~= 1 then ("%* marketplace items were added to your inventory."):format(v1) else "Your marketplace item was added to your inventory.",
            4
        )
    end)
    GlobalMarketplace.PurchaseItemResult.Listen(function(a1) -- Line: 2008 -- upvalues: getMarketplaceErrorMessage (upval), Router (upval)
        local v1 = getMarketplaceErrorMessage(a1)
        if not v1 then
            return
        end
        Router.broadcastRouter("CreateNotification", "Error", v1)
    end)
    MarketplaceButton.new(u650.Market.PurchaseMenu.Confirm.Action.Frame.Accept, {
        hoverSizeMultiplier = 0.95,
        onActivated = function() -- Line: 2014
            -- upvalues: u23 (ref), u620 (upval), u614 (upval), Router (upval), DataController (upval)
            -- upvalues: LocalPlayer (upval), ReplicatedStorage (upval), MenuState (upval), Store (upval), u650 (upval)
            -- upvalues: u657 (upval), GlobalMarketplace (upval), u638 (upval)
            local inventoryItem = u23.inventoryItem and u23.inventoryItem.Type
            local v1 = u620
            if v1 then
                v1 = false
                if inventoryItem ~= nil then
                    v1 = u614[inventoryItem] == true
                end
            end
            if v1 then
                Router.broadcastRouter("CreateNotification", "Error", "Paid random items are not allowed in your region.")
                return
            end
            v1 = DataController.Get(LocalPlayer, "TradeTokens") or 0
            local u27 = u23.priceTradeTokens or (1 / 0)
            if v1 < u27 then
                task.spawn(function() -- Line: 577 -- upvalues: ReplicatedStorage (upval), MenuState (upval), Store (upval), u27 (val)
                    local Error = ReplicatedStorage.Assets.Sounds:FindFirstChild("Error")
                    if Error and Error:IsA("Sound") then
                        Error:Play()
                    end
                    task.wait(0.1)
                    require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Store")
                    if MenuState.GetCurrentScreen() == "Store" then
                        Store.OpenTab("TradeTokens")
                    end
                    task.wait(0.3)
                    Store.PromptTradeTokenPackageForItemPrice(u27)
                end)
                return
            end
            if not LocalPlayer:GetAttribute("PinVerified") then
                return
            end
            u650.Parent.Parent.Loading.Visible = true
            u657:Play()
            GlobalMarketplace.PurchaseItem.Send(u23)
            u638 = nil
            u650.Market.PurchaseMenu.Visible = false
            u650.Market.PurchaseMenu.Confirm.Visible = false
        end,
    })
    local PurchaseMenu = u650.Market.PurchaseMenu
    local Confirm = PurchaseMenu.Confirm
    local Confirm_2 = u650.Market.Confirm

    local function closePurchaseConfirm() -- Line: 2043 -- upvalues: Confirm (val)
        Confirm.Visible = false
    end

    local function closePurchaseMenu() -- Line: 2047
        -- upvalues: u638 (upval), u636 (upval), clearPurchaseMenuTransactions (val), clearGraphVisual (val)
        -- upvalues: u658 (upval), Main (val), Confirm (val), PurchaseMenu (val)
        u638 = nil
        if u636 then
            u636:Destroy()
            u636 = nil
        end
        clearPurchaseMenuTransactions()
        clearGraphVisual()
        u658:Pause()
        Main.Main.SalesGraph.Loading.Visible = false
        Confirm.Visible = false
        PurchaseMenu.Visible = false
    end

    local function closeLegacyConfirm() -- Line: 2062 -- upvalues: Confirm_2 (val)
        Confirm_2.Visible = false
    end

    MarketplaceButton.new(Confirm.Action.Frame.Decline, {hoverSizeMultiplier = 0.9, onActivated = closePurchaseConfirm})
    MarketplaceButton.new(PurchaseMenu.Main.Main.Purchase, {
        hoverSizeMultiplier = 0.9,
        onActivated = function() -- Line: 2073 -- upvalues: Confirm (val)
            Confirm.Visible = true
        end,
    })
    MarketplaceButton.new(PurchaseMenu.Main.Header.Close, {hoverSizeMultiplier = 0.9, onActivated = closePurchaseMenu})
    MarketplaceButton.new(Confirm_2.Action.Frame.Decline, {hoverSizeMultiplier = 0.9, onActivated = closeLegacyConfirm})
    local Main_2 = PurchaseMenu.Main.Main
    local Container = Main_2.Header.TopSelect.Container
    local u153 = {{"SalesGraph", "SalesGraph"}, {"SimilarListings", "Similar"}, {"LatestSales", "Transactions"}}

    local function showPurchaseMenuTab(a1) -- Line: 2093
        -- upvalues: u153 (val), Main_2 (val), Container (val)
        local Frame, v1
        local v2 = nil
        local v3 = nil
        local v4 = a1
        for i, j in u153, v2, v3 do
            v1 = Main_2[j[2]]
            v1.Visible = j == v4
            Frame = Container[j[1]].Frame
            Frame.Visible = j == v4
        end
    end

    for i, j in u153 do
        MarketplaceButton.new(Container[j[1]], {
            hoverSizeMultiplier = 0.9,
            onActivated = function() -- Line: 2104 -- upvalues: showPurchaseMenuTab (val), j (val)
                showPurchaseMenuTab(j)
            end,
        })
    end
    CloseButtonRegistry.Add(PurchaseMenu, nil, closePurchaseMenu)
    CloseButtonRegistry.Add(Confirm, nil, closePurchaseConfirm)
    CloseButtonRegistry.Add(Confirm_2, nil, closeLegacyConfirm)
    GamepadNavigation.TrapPopup(PurchaseMenu, function() -- Line: 2119 -- upvalues: PurchaseMenu (val), Container (val)
        local Purchase = PurchaseMenu.Main.Main.Purchase
        if Purchase.Visible then
            return Purchase
        end
        return Container.SalesGraph
    end)
    GamepadNavigation.TrapPopup(Confirm, function() -- Line: 2124 -- upvalues: Confirm (val)
        return Confirm.Action.Frame.Decline
    end)
    GamepadNavigation.TrapPopup(Confirm_2, function() -- Line: 2127 -- upvalues: Confirm_2 (val)
        return Confirm_2.Action.Frame.Decline
    end)
    MenuState.RegisterBumperOverride(PurchaseMenu, function(a1) -- Line: 2132
        -- upvalues: Confirm (val), u153 (val), Main_2 (val), showPurchaseMenuTab (val), GamepadNavigation (upval)
        -- upvalues: Container (val)
        if Confirm.Visible then
            return true
        end
        local v1 = 1
        for i, j in u153 do
            if Main_2[j[2]].Visible then
                v1 = i
                break
            end
        end
        local v2 = v1 - 1
        local v3 = u153[(v2 + (if not a1 then 1 else -1)) % #u153 + 1]
        showPurchaseMenuTab(v3)
        GamepadNavigation.Focus(Container[v3[1]])
        return true
    end, PurchaseMenu)
    local u596 = CollectionServiceUtility.FindDescendantWithTag(u650.Market.Header.Filters, "SearchBox")
    local v4 = CollectionServiceUtility.FindDescendantWithTag(u650.Market.Header.Filters, "Dropdown_Category")
    local u610 = "All"
    local u617 = "Quality"
    local u624 = true
    local u242 = {
        ["Factory New"] = 0,
        ["Minimal Wear"] = 1,
        ["Field-Tested"] = 2,
        ["Well-Worn"] = 3,
        ["Battle-Scarred"] = 4,
    }
    local u248 = {
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
        SMG = 4,
    }

    local function getMarketHeaderSearchTerm() -- Line: 2190 -- upvalues: u596 (val)
        if not u596 then
            return nil
        end
        local Text = u596.Text
        if Text == "" then
            return nil
        end
        return Text
    end

    local function listingMatchesHeaderSearch(a1) -- Line: 2199
        -- upvalues: u596 (val), GetSkinDisplayName (upval), FuzzySearch (upval)
        local v1
        if u596 then
            local Text = u596.Text
            v1 = if Text ~= "" then Text else nil
        else
            v1 = nil
        end
        if not v1 then
            return true
        end
        local Attribute = a1:GetAttribute("InternalGun")
        local Attribute_2 = a1:GetAttribute("Skin")
        if typeof(Attribute) == "string" and typeof(Attribute_2) == "string" then
            return FuzzySearch.MatchesQuery(
                (GetSkinDisplayName.GetSearchIdentity(Attribute, Attribute_2):lower()) .. " " .. (string.lower((tostring((a1:GetAttribute("Wear")) or "")))) .. " " .. (string.lower((tostring((a1:GetAttribute("Type")) or "")))) .. " " .. (string.lower((tostring((a1:GetAttribute("OtherType")) or "")))) .. " " .. string.lower((tostring((a1:GetAttribute("Collection")) or ""))),
                v1
            )
        end
        return false
    end

    local function shouldShowMarketListing(a1) -- Line: 2224
        -- upvalues: u610 (ref), listingMatchesHeaderSearch (val), u629 (upval), u631 (upval)
        local v1 = true
        if u610 ~= "All" then
            v1 = u610 == a1:GetAttribute("Type")
        end
        local v2 = v1
        if v2 then
            v2 = listingMatchesHeaderSearch(a1)
            if v2 then
                v2 = false
                if a1:GetAttribute("StaggerRevealReady") ~= false then
                    local Attribute
                    for i, j in u629 do
                        if u631[j.key] then
                            if false then
                                return true
                            end
                            Attribute = a1:GetAttribute("Wear")
                            v2 = false
                            if typeof(Attribute) == "string" then
                                for k, n in u629 do
                                    if u631[n.key] and n.wear == Attribute then
                                        return true
                                    end
                                end
                                v2 = false
                            end
                            return v2
                        end
                    end
                    if true then
                        return true
                    end
                    Attribute = a1:GetAttribute("Wear")
                    v2 = false
                    if typeof(Attribute) == "string" then
                        for m, i5 in u629 do
                            if u631[i5.key] and i5.wear == Attribute then
                                return true
                            end
                        end
                        v2 = false
                    end
                end
            end
        end
        return v2
    end

    local function showCategory(a1) -- Line: 2232
        -- upvalues: u617 (ref), u242 (val), GetSkinDisplayName (upval), u248 (val), u650 (upval), u610 (ref)
        -- upvalues: listingMatchesHeaderSearch (val), u629 (upval), u631 (upval), u624 (ref)
        local Attribute, v1, v2
        local v3 = a1 ~= false

        local function getSortValue(a1) -- Line: 2235
            -- upvalues: u617 (upval), u242 (upval), GetSkinDisplayName (upval), u248 (upval)
            if u617 == "Quality" then
                local Attribute = a1:GetAttribute("Wear")
                if typeof(Attribute) == "string" then
                    return u242[Attribute] or 0
                end
                return 0
            end
            if u617 == "Newest" then
                local Attribute_2 = a1:GetAttribute("CreatedAt")
                if typeof(Attribute_2) == "number" then
                    return Attribute_2
                end
                return 0
            end
            if u617 == "RAP" then
                local Attribute_3 = a1:GetAttribute("RAP")
                if typeof(Attribute_3) == "number" then
                    return Attribute_3
                end
                return 0
            end
            if u617 == "Alphabetical" then
                local Attribute_4 = a1:GetAttribute("InternalGun")
                local Attribute_5 = a1:GetAttribute("Skin")
                if typeof(Attribute_4) == "string" and typeof(Attribute_5) == "string" then
                    return (GetSkinDisplayName.GetSearchIdentity(Attribute_4, Attribute_5):lower())
                end
                return ""
            end
            if u617 == "Float" then
                local Attribute_6 = a1:GetAttribute("Float")
                if typeof(Attribute_6) == "number" then
                    return Attribute_6
                end
                return 0
            end
            if u617 == "Serial" then
                local Attribute_7 = a1:GetAttribute("Serial")
                if typeof(Attribute_7) == "number" then
                    return Attribute_7
                end
                return 0
            end
            if u617 == "Type" then
                local Attribute_8 = a1:GetAttribute("OtherType")
                if typeof(Attribute_8) == "string" then
                    return u248[Attribute_8] or 0
                end
                return 0
            end
            if u617 ~= "Collection" then
                return 0
            end
            local Attribute_9 = a1:GetAttribute("Collection")
            if typeof(Attribute_9) == "string" then
                return (Attribute_9:lower())
            end
            return ""
        end

        local v4 = {}
        for i, j in u650.Market.Container:GetChildren() do
            if j:IsA("Frame") then
                v1 = true
                if u610 ~= "All" then
                    v1 = u610 == j:GetAttribute("Type")
                end
                v2 = v1
                if v2 then
                    v2 = listingMatchesHeaderSearch(j)
                    if v2 then
                        v2 = false
                        if j:GetAttribute("StaggerRevealReady") ~= false then
                            for k, n in u629 do
                                if u631[n.key] then
                                    if true then
                                        Attribute = j:GetAttribute("Wear")
                                        v2 = false
                                        if typeof(Attribute) == "string" then
                                            for m, i5 in u629 do
                                                if u631[i5.key] and i5.wear == Attribute then
                                                    j.Visible = true
                                                    if j.Visible and v3 then
                                                        table.insert(v4, j)
                                                    end
                                                    -- [[ incomplete: control flow could not be represented ]]
                                                end
                                            end
                                            v2 = false
                                        end
                                    else
                                        v2 = true
                                    end
                                    j.Visible = v2
                                    if j.Visible and v3 then
                                        table.insert(v4, j)
                                    end
                                    break
                                end
                            end
                            if false then
                                Attribute = j:GetAttribute("Wear")
                                v2 = false
                                if typeof(Attribute) == "string" then
                                    for i6, i7 in u629 do
                                        if u631[i7.key] and i7.wear == Attribute then
                                            j.Visible = true
                                            if j.Visible and v3 then
                                                table.insert(v4, j)
                                            end
                                            break
                                        end
                                    end
                                    v2 = false
                                end
                            else
                                v2 = true
                            end
                        end
                    end
                end
                j.Visible = v2
                if j.Visible and v3 then
                    table.insert(v4, j)
                end
            end
        end
        table.sort(v4, function(a1, a2) -- Line: 2281 -- upvalues: getSortValue (val), u624 (upval)
            local v1 = getSortValue(a1)
            local v2 = getSortValue(a2)
            if v1 == v2 then
                return a1.Name < a2.Name
            end
            if u624 then
                return v2 < v1
            end
            return v1 < v2
        end)
        for i8, i9 in v4 do
            i9.LayoutOrder = i8
        end
    end

    function u630() -- Line: 2293 -- upvalues: showCategory (val)
        showCategory(true)
    end

    local function getNextMarketLayoutOrder() -- Line: 2297 -- upvalues: u650 (upval)
        local v1 = 0
        for i, j in u650.Market.Container:GetChildren() do
            if j:IsA("GuiObject") then
                v1 = math.max(v1, j.LayoutOrder)
            end
        end
        return v1 + 1
    end

    local function captureMarketScrollAnchor() -- Line: 2307 -- upvalues: u650 (upval)
        local Y_2, v1
        local Container = u650.Market.Container
        local Y = Container.AbsolutePosition.Y
        local v2 = Y + Container.AbsoluteSize.Y
        local v3 = nil
        local v4 = 0
        for i, j in Container:GetChildren() do
            if j:IsA("GuiObject") and j.Visible then
                Y_2 = j.AbsolutePosition.Y
                v1 = Y_2 + j.AbsoluteSize.Y
                if Y_2 < v2 and Y < v1 then
                    if not v3 or v3.AbsolutePosition.Y <= Y_2 then
                        v3 = j
                        v4 = Y_2 - Y
                    end
                end
            end
        end
        return {canvas = Container.CanvasPosition, anchor = v3, offsetInView = v4}
    end

    local function restoreMarketScrollAnchor(a1) -- Line: 2336 -- upvalues: u650 (upval) -- types: a1: table
        local Container = u650.Market.Container
        local anchor = a1.anchor
        if anchor and anchor.Parent then
            Container.CanvasPosition = Vector2.new(
                a1.canvas.X,
                Container.CanvasPosition.Y + (anchor.AbsolutePosition.Y - Container.AbsolutePosition.Y - a1.offsetInView)
            )
            return
        end
        Container.CanvasPosition = a1.canvas
    end

    GlobalMarketplace.SearchMarketResults.Listen(function(a1) -- Line: 2350
        -- upvalues: u640 (upval), u650 (upval), u657 (upval), u627 (upval), showCategory (val), u626 (upval)
        -- upvalues: u622 (upval), captureMarketScrollAnchor (val), getNextMarketLayoutOrder (val), Skins (upval)
        -- upvalues: listingMatchesSelectedWearTiers (upval), createMarketListing (upval), u651 (upval)
        -- upvalues: LocalPlayer (upval), MarketplaceButton (upval), GlobalMarketplace (upval)
        -- upvalues: removeYourListingByInventoryItemId (upval), destroyListingCard (upval), addYourListing (upval)
        -- upvalues: Main (val), u620 (upval), u614 (upval), Router (upval), u23 (ref), confirmBuy (val)
        -- upvalues: MenuState (upval), pruneOldestListingFrames (upval), shouldShowMarketListing (val)
        local v1
        u640 = u640 + 1
        local Listings = a1 and a1.Listings
        local TotalPages = a1 and a1.TotalPages
        local OnCooldown = a1 and a1.OnCooldown
        if Listings == nil then
            u650.Parent.Parent.Loading.Visible = false
            u657:Pause()
            u627 = false
            return
        end
        if OnCooldown then
            u650.Parent.Parent.Loading.Visible = false
            u657:Pause()
            u627 = false
            showCategory()
            return
        end
        if TotalPages then
            u626 = TotalPages
        end
        local u218 = false
        if u622.page ~= nil then
            u218 = 1 < u622.page
        end
        local u50 = if not u218 then nil else captureMarketScrollAnchor()
        local v2 = if not u218 then nil else getNextMarketLayoutOrder()
        if not u218 then
            for i, j in u650.Market.Container:GetChildren() do
                if j:IsA("Frame") then
                    j:Destroy()
                end
            end
        end
        local u152 = {}
        local v3 = nil
        local v4 = nil
        for k, n in Listings, v3, v4 do
            if n.inventoryItem and Skins.HasSkinTextures(n.inventoryItem.Name, n.inventoryItem.Skin) then
                if n.ForceConfirm then
                    if not u650.Market.Container:FindFirstChild(n.inventoryItem._id) then
                        v1 = nil
                        if v2 then
                            v1 = v2
                            v2 = v2 + 1
                        end
                        local u138 = createMarketListing(u650.Market.Container, n.inventoryItem._id, u651, n, v1)
                        if u138 then
                            if not u218 then
                                u138:SetAttribute("StaggerRevealReady", false)
                                u138.Visible = false
                            else
                                u138:SetAttribute("StaggerRevealReady", true)
                            end
                            table.insert(u152, u138)
                            if not n.inventoryItem.MetaData.GlobalMarketPlaceListingReference then
                                u138.Visible = false
                            else
                                if LocalPlayer.UserId ~= n.inventoryItem.MetaData.Owner then
                                    u138.Main.Purchase.Visible = true
                                    MarketplaceButton.new(u138.Main.Purchase, {
                                        hoverSizeMultiplier = 0.9,
                                        onActivated = function() -- Line: 2474
                                            -- upvalues: LocalPlayer (upval), n (val), Main (upval), u620 (upval)
                                            -- upvalues: u614 (upval), Router (upval), u23 (upval), confirmBuy (upval)
                                            -- upvalues: u138 (val)
                                            if LocalPlayer.UserId ~= n.inventoryItem.MetaData.Owner
                                                and not Main.Parent.Visible then
                                                local Type = n.inventoryItem.Type
                                                local v1 = u620
                                                if v1 then
                                                    v1 = false
                                                    if Type ~= nil then
                                                        v1 = u614[Type] == true
                                                    end
                                                end
                                                if v1 then
                                                    Router.broadcastRouter(
                                                        "CreateNotification",
                                                        "Error",
                                                        "Paid random items are not allowed in your region."
                                                    )
                                                    return
                                                end
                                                u23 = n
                                                confirmBuy(u138)
                                                return
                                            end
                                        end,
                                    })
                                else
                                    u138.Main.Delist.Visible = true
                                    MarketplaceButton.new(u138.Main.Delist, {
                                        hoverSizeMultiplier = 0.9,
                                        onActivated = function() -- Line: 2438
                                            -- upvalues: LocalPlayer (upval), n (val), u650 (upval), u657 (upval)
                                            -- upvalues: GlobalMarketplace (upval)
                                            -- upvalues: removeYourListingByInventoryItemId (upval)
                                            -- upvalues: destroyListingCard (upval), u138 (val)
                                            if LocalPlayer.UserId ~= n.inventoryItem.MetaData.Owner
                                                or not LocalPlayer:GetAttribute("PinVerified") then
                                                return
                                            end
                                            u650.Parent.Parent.Loading.Visible = true
                                            u657:Play()
                                            GlobalMarketplace.DelistItem.Send(n.inventoryItem._id)
                                            local v1 = u650.Sell.Container:FindFirstChild(n.inventoryItem._id)
                                            if v1 then
                                                v1.Visible = true
                                                v1.Main.Sell.Visible = true
                                                v1.Main.Delist.Visible = false
                                            end
                                            removeYourListingByInventoryItemId(n.inventoryItem._id)
                                            destroyListingCard(u138)
                                        end,
                                    })
                                    if not u650.Profile.Main.Frame.YourListings.YourListings:FindFirstChild(n.listing_reference_id) then
                                        addYourListing(n)
                                    end
                                end
                                if n.ForceConfirm then
                                    u23 = n
                                    confirmBuy(u138)
                                    u650.Visible = true
                                    MenuState.SetScreen("GlobalMarketPlace")
                                end
                            end
                        end
                    end
                elseif listingMatchesSelectedWearTiers(n)
                    and not u650.Market.Container:FindFirstChild(n.inventoryItem._id) then
                    v1 = nil
                    if v2 then
                        v1 = v2
                        v2 = v2 + 1
                    end
                    local u138 = createMarketListing(u650.Market.Container, n.inventoryItem._id, u651, n, v1)
                    if u138 then
                        if not u218 then
                            u138:SetAttribute("StaggerRevealReady", false)
                            u138.Visible = false
                        else
                            u138:SetAttribute("StaggerRevealReady", true)
                        end
                        table.insert(u152, u138)
                        if not n.inventoryItem.MetaData.GlobalMarketPlaceListingReference then
                            u138.Visible = false
                        else
                            if LocalPlayer.UserId ~= n.inventoryItem.MetaData.Owner then
                                u138.Main.Purchase.Visible = true
                                MarketplaceButton.new(u138.Main.Purchase, {
                                    hoverSizeMultiplier = 0.9,
                                    onActivated = function() -- Line: 2474
                                        -- upvalues: LocalPlayer (upval), n (val), Main (upval), u620 (upval)
                                        -- upvalues: u614 (upval), Router (upval), u23 (upval), confirmBuy (upval)
                                        -- upvalues: u138 (val)
                                        if LocalPlayer.UserId ~= n.inventoryItem.MetaData.Owner
                                            and not Main.Parent.Visible then
                                            local Type = n.inventoryItem.Type
                                            local v1 = u620
                                            if v1 then
                                                v1 = false
                                                if Type ~= nil then
                                                    v1 = u614[Type] == true
                                                end
                                            end
                                            if v1 then
                                                Router.broadcastRouter(
                                                    "CreateNotification",
                                                    "Error",
                                                    "Paid random items are not allowed in your region."
                                                )
                                                return
                                            end
                                            u23 = n
                                            confirmBuy(u138)
                                            return
                                        end
                                    end,
                                })
                            else
                                u138.Main.Delist.Visible = true
                                MarketplaceButton.new(u138.Main.Delist, {
                                    hoverSizeMultiplier = 0.9,
                                    onActivated = function() -- Line: 2438
                                        -- upvalues: LocalPlayer (upval), n (val), u650 (upval), u657 (upval)
                                        -- upvalues: GlobalMarketplace (upval)
                                        -- upvalues: removeYourListingByInventoryItemId (upval)
                                        -- upvalues: destroyListingCard (upval), u138 (val)
                                        if LocalPlayer.UserId ~= n.inventoryItem.MetaData.Owner
                                            or not LocalPlayer:GetAttribute("PinVerified") then
                                            return
                                        end
                                        u650.Parent.Parent.Loading.Visible = true
                                        u657:Play()
                                        GlobalMarketplace.DelistItem.Send(n.inventoryItem._id)
                                        local v1 = u650.Sell.Container:FindFirstChild(n.inventoryItem._id)
                                        if v1 then
                                            v1.Visible = true
                                            v1.Main.Sell.Visible = true
                                            v1.Main.Delist.Visible = false
                                        end
                                        removeYourListingByInventoryItemId(n.inventoryItem._id)
                                        destroyListingCard(u138)
                                    end,
                                })
                                if not u650.Profile.Main.Frame.YourListings.YourListings:FindFirstChild(n.listing_reference_id) then
                                    addYourListing(n)
                                end
                            end
                            if n.ForceConfirm then
                                u23 = n
                                confirmBuy(u138)
                                u650.Visible = true
                                MenuState.SetScreen("GlobalMarketPlace")
                            end
                        end
                    end
                end
            end
        end
        ;(function() -- Line: 2500
            -- upvalues: showCategory (upval), u218 (val), pruneOldestListingFrames (upval), u650 (upval), u657 (upval)
            -- upvalues: u152 (val), shouldShowMarketListing (upval), u50 (val), u627 (upval)
            showCategory(not u218)
            if u218 then
                pruneOldestListingFrames(u650.Market.Container, 96)
            end
            u650.Parent.Parent.Loading.Visible = false
            u657:Pause()
            if not u218 then
                local u21 = u152
                local u22 = shouldShowMarketListing
                task.spawn(function() -- Line: 431 -- upvalues: u21 (val), u22 (val)
                    local v1 = nil
                    local v2 = nil
                    for i, j in u21, v1, v2 do
                        if j.Parent then
                            j:SetAttribute("StaggerRevealReady", true)
                            j.Visible = u22(j)
                        end
                        task.wait(0.018)
                    end
                end)
            elseif u50 then
                local function restoreScroll() -- Line: 2513 -- upvalues: u50 (upval), u650 (upval)
                    local v1 = u50
                    local Container = u650.Market.Container
                    local anchor = v1.anchor
                    if anchor and anchor.Parent then
                        Container.CanvasPosition = Vector2.new(
                            v1.canvas.X,
                            Container.CanvasPosition.Y + (anchor.AbsolutePosition.Y - Container.AbsolutePosition.Y - v1.offsetInView)
                        )
                        return
                    end
                    Container.CanvasPosition = v1.canvas
                end

                local v1 = u50
                local Container = u650.Market.Container
                local anchor = v1.anchor
                if not anchor or not anchor.Parent then
                    Container.CanvasPosition = v1.canvas
                else
                    Container.CanvasPosition = Vector2.new(
                        v1.canvas.X,
                        Container.CanvasPosition.Y + (anchor.AbsolutePosition.Y - Container.AbsolutePosition.Y - v1.offsetInView)
                    )
                end
                local u65 = (u650.Market.Container:GetPropertyChangedSignal("AbsoluteCanvasSize")):Connect(restoreScroll)
                task.delay(0.15, function() -- Line: 2522 -- upvalues: u65 (ref), u50 (upval), u650 (upval)
                    if u65 then
                        u65:Disconnect()
                    end
                    local v1 = u50
                    local Container = u650.Market.Container
                    local anchor = v1.anchor
                    if anchor and anchor.Parent then
                        Container.CanvasPosition = Vector2.new(
                            v1.canvas.X,
                            Container.CanvasPosition.Y + (anchor.AbsolutePosition.Y - Container.AbsolutePosition.Y - v1.offsetInView)
                        )
                        return
                    end
                    Container.CanvasPosition = v1.canvas
                end)
            end
            u627 = false
        end)()
    end)
    local u285 = os.clock()
    ;(u650.Market.Container:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 2537
        -- upvalues: u650 (upval), u285 (ref), u622 (upval), u626 (upval), u627 (upval)
        -- upvalues: getWearSearchRangeFromSelection (upval), u657 (upval), GlobalMarketplace (upval)
        -- upvalues: abandonSearchAfterTimeout (upval)
        local Container = u650.Market.Container
        local v1 = math.max(0, Container.AbsoluteCanvasSize.Y - Container.AbsoluteSize.Y)
        local v2 = math.max(1, Container.AbsoluteSize.Y * 0.05)
        local Y_4 = Container.CanvasPosition.Y
        if v1 - v2 <= Y_4 then
            local v3 = os.clock() - u285
            if v3 > 0.75 and u622.page < u626 and not u627 then
                u627 = true
                v3 = u622
                v3.page = v3.page + 1
                u622.wear_range = getWearSearchRangeFromSelection()
                u650.Parent.Parent.Loading.Visible = true
                u657:Play()
                local pattern_range = u622.pattern_range
                if pattern_range and pattern_range[1] <= 0 then
                    u622.pattern_range = nil
                end
                GlobalMarketplace.SearchMarket.Send(u622)
                u622.pattern_range = pattern_range
                abandonSearchAfterTimeout()
                u285 = os.clock()
            end
        end
    end)
    GlobalMarketplace.ClearListing.Listen(function(a1) -- Line: 2560
        -- upvalues: u650 (upval), destroyListingCard (upval), removeYourListingByInventoryItemId (upval)
        local v1 = u650.Market.Container:FindFirstChild(a1, true)
        if v1 then
            destroyListingCard(v1)
        end
        removeYourListingByInventoryItemId(a1)
    end)

    local function bindRangeFilter(a1, a2, a3, a4) -- Line: 2571
        -- upvalues: bindSliderPin (upval), setDrag (upval)
        bindSliderPin(a1.Slider, a1.Slider.StartPin, a3)
        bindSliderPin(a1.Slider, a1.Slider.EndPin, a3)
        a1.Content.Inputs.StartPin.TextBox.FocusLost:Connect(function() -- Line: 2580 -- upvalues: setDrag (upval), a2 (val), a1 (val), a3 (val)
            setDrag(a2, a1.Content.Inputs.StartPin.TextBox.Text, "StartPin", a3)
        end)
        a1.Content.Inputs.EndPin.TextBox.FocusLost:Connect(function() -- Line: 2584 -- upvalues: a1 (val), setDrag (upval), a2 (val), a4 (val), a3 (val)
            local Text = a1.Content.Inputs.EndPin.TextBox.Text
            setDrag(a2, if not a4 then Text else a4(Text), "EndPin", a3)
        end)
    end

    local function parseMaxInput(a1) -- Line: 2591 -- types: a1: number
        return function(a1_2) -- Line: 2592 -- upvalues: a1 (val) -- types: a1_2: string
            return tonumber((string.gsub(a1_2, ",", ""))) or a1
        end
    end

    for k, n in CollectionService:GetTagged("pattern_range") do
        local u668 = 11
        bindRangeFilter(n, n, 11, function(a1) -- Line: 2592 -- upvalues: u668 (val) -- types: a1: string
            return tonumber((string.gsub(a1, ",", ""))) or u668
        end)
    end
    local price_range = u650.Market.Filters.Container.price_range
    for m, i5 in CollectionService:GetTagged("price_range") do
        v1 = Constants.MARKETPLACE_MAX_LISTING_PRICE
        local u654_2 = u616[2]
        bindRangeFilter(i5, price_range, v1, function(a1) -- Line: 2592 -- upvalues: u654_2 (val) -- types: a1: string
            return tonumber((string.gsub(a1, ",", ""))) or u654_2
        end)
    end
    setDrag(price_range, u616[2], "EndPin", Constants.MARKETPLACE_MAX_LISTING_PRICE)
    setDrag(price_range, u616[1], "StartPin", Constants.MARKETPLACE_MAX_LISTING_PRICE)
    for i6, i7 in CollectionService:GetTagged("wear_range") do
        bindRangeFilter(i7, i7, 1)
    end
    setupWearTierButtons()
    local special_dropdown = u650.Market.Filters.Container:FindFirstChild("special_dropdown")
    local List = special_dropdown and special_dropdown:FindFirstChild("List")
    local Killtrack = List and List:FindFirstChild("Killtrack")
    local Button = Killtrack and Killtrack:FindFirstChild("Button")
    local ImageLabel = Button
    if ImageLabel then
        ImageLabel = Button:FindFirstChild("ImageLabel")
    end
    if Button and Button:IsA("GuiButton") and ImageLabel and ImageLabel:IsA("GuiObject") then
        MarketplaceButton.new(Button, {
            hoverSizeMultiplier = 0.9,
            onActivated = function() -- Line: 2624 -- upvalues: ImageLabel (val), u622 (upval)
                ImageLabel.Visible = not ImageLabel.Visible
                u622.statTrak = if not ImageLabel.Visible then nil else true
            end,
        })
        u644 = ImageLabel
    end
    for i8, i9 in CollectionService:GetTagged("Dropdown_Category") do
        v3 = u650.Market.Filters.Container
        if i9:IsDescendantOf(v3) then
            v2 = i9:GetAttribute("category")
            local u578 = v2
            if u578 then
                u578 = i9.Parent:FindFirstChild(v2)
            end
            if u578 and u578:IsA("GuiObject") then
                i9.Activated:Connect(function() -- Line: 2644 -- upvalues: u578 (val), i9 (val)
                    u578.Visible = not u578.Visible
                    local ImageLabel = i9:FindFirstChild("ImageLabel")
                    if ImageLabel and ImageLabel:IsA("GuiObject") then
                        ImageLabel.Rotation = if not u578.Visible then 0 else 180
                    end
                end)
            end
        end
    end
    ;(u650.Market.Filters.Container.Search.Frame.SearchBox:GetPropertyChangedSignal("Text")):Connect(schedulePredictSearch)
    u650.Market.Filters.Container.Search.Frame.SearchBox.FocusLost:Connect(function() -- Line: 2656 -- upvalues: u650 (upval), u622 (upval)
        u650.Market.Filters.Container.Search.Frame.Auto.Text = ""
        u622.search_bar_query = u650.Market.Filters.Container.Search.Frame.SearchBox.Text
    end)
    MarketplaceButton.new(u650.Market.Filters.Container.ApplyFilter, {
        hoverSizeMultiplier = 0.9,
        onActivated = function() -- Line: 2664
            -- upvalues: u622 (upval), getWearSearchRangeFromSelection (upval), showCategory (val), u621 (upval)
            -- upvalues: u650 (upval), u627 (upval), GlobalMarketplace (upval), abandonSearchAfterTimeout (upval)
            -- upvalues: u657 (upval)
            u622.wear_range = getWearSearchRangeFromSelection()
            showCategory()
            if os.clock() - u621 < 10 or u650.Market.Filters.Container.ApplyFilter.Frame.Timer.Visible then
                return
            end
            u621 = os.clock()
            u622.page = 1
            u627 = true
            local pattern_range = u622.pattern_range
            if pattern_range and pattern_range[1] <= 0 then
                u622.pattern_range = nil
            end
            GlobalMarketplace.SearchMarket.Send(u622)
            u622.pattern_range = pattern_range
            abandonSearchAfterTimeout()
            u650.Parent.Parent.Loading.Visible = true
            u657:Play()
            u650.Market.Filters.Container.ApplyFilter.Frame.Timer.Visible = true
            for i = 10, 0, -1 do
                u650.Market.Filters.Container.ApplyFilter.Frame.Timer.Text = i
                task.wait(1)
            end
            u650.Market.Filters.Container.ApplyFilter.Frame.Timer.Visible = false
        end,
    })
    if v4 then
        (MarketplaceDropdown.new(v4, Constants.ITEM_CATEGORIES)).OptionSelected:Connect(function(a1) -- Line: 2694 -- upvalues: u610 (ref), showCategory (val)
            u610 = tostring(a1)
            showCategory()
        end)
    end
    local v5 = CollectionServiceUtility.FindDescendantWithTag(u650.Market.Header.Filters, "Dropdown_SortType")
    if v5 then
        local v6 = {}
        for i10, i11 in Constants.MARKETPLACE_SORTING_OPTIONS do
            if i11 ~= "Equipped" then
                table.insert(v6, i11)
            end
        end
        ;(MarketplaceDropdown.new(v5, v6)).OptionSelected:Connect(function(a1) -- Line: 2716 -- upvalues: u617 (ref), showCategory (val)
            u617 = tostring(a1)
            showCategory()
        end)
    end
    local u530 = CollectionServiceUtility.FindDescendantWithTag(u650.Market.Header.Filters, "ReverseSort")
    if u530 then
        u530.Activated:Connect(function() -- Line: 2725 -- upvalues: u624 (ref), u530 (val), showCategory (val)
            u624 = not u624
            local ImageLabel = u530:FindFirstChildOfClass("ImageLabel")
            if ImageLabel then
                ImageLabel.Rotation = if not u624 then 0 else 180
            end
            showCategory()
        end)
    end
    if u596 then
        local u547 = 0
        ;(u596:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 2739 -- upvalues: u547 (ref), showCategory (val)
            u547 = u547 + 1
            local u2 = u547
            task.delay(0.12, function() -- Line: 2742 -- upvalues: u2 (val), u547 (upval), showCategory (upval)
                if u2 ~= u547 then
                    return
                end
                showCategory()
            end)
        end)
        u596.FocusLost:Connect(function(a1) -- Line: 2750 -- upvalues: showCategory (val)
            showCategory()
        end)
    end
end

local function setupSell() -- Line: 2756
    -- upvalues: u652 (ref), u650 (ref), u656 (ref), MarketplaceButton (val), u628 (val), LocalPlayer (val), u657 (ref)
    -- upvalues: GlobalMarketplace (val), u627 (ref), u622 (val), getWearSearchRangeFromSelection (val)
    -- upvalues: abandonSearchAfterTimeout (ref), CloseButtonRegistry (val), GamepadNavigation (val), u635 (val)
    -- upvalues: InventoryController (val), createMarketListing (val), u651 (ref), GetSkinDisplayName (val)
    -- upvalues: CommaNumber (val), Constants (val), removeYourListingByInventoryItemId (val), MenuState (val)
    -- upvalues: pruneOldestListingFrames (val), syncListedItemToProfile (val), getMarketplaceErrorMessage (val)
    -- upvalues: Router (val), CollectionServiceUtility (val), MarketplaceDropdown (val)
    u652 = u650.Sell.SellInfo.Container.Template:Clone()
    u650.Sell.SellInfo.Container.Template:Destroy()

    local function confirmSell() -- Line: 2760 -- upvalues: u650 (upval)
        u650.Sell.Confirm.Visible = true
    end

    local function isSetPriceOpen() -- Line: 2764 -- upvalues: u656 (upval)
        local v1 = false
        if u656 ~= nil then
            v1 = u656.Parent ~= nil
        end
        return v1
    end

    MarketplaceButton.new(u650.Sell.Confirm.Action.Frame.Accept, {
        hoverSizeMultiplier = 0.9,
        onActivated = function() -- Line: 2771
            -- upvalues: u628 (upval), LocalPlayer (upval), u650 (upval), u657 (upval), GlobalMarketplace (upval)
            -- upvalues: u627 (upval), u622 (upval), getWearSearchRangeFromSelection (upval)
            -- upvalues: abandonSearchAfterTimeout (upval)
            local v1 = {}
            for i, j in u628 do
                table.insert(v1, j)
            end
            if #v1 < 1 or not LocalPlayer:GetAttribute("PinVerified") then
                return
            end
            u650.Parent.Parent.Loading.Visible = true
            u657:Play()
            GlobalMarketplace.ListItem.Send(v1)
            u627 = true
            u622.page = 1
            u622.wear_range = getWearSearchRangeFromSelection()
            local pattern_range = u622.pattern_range
            if pattern_range and pattern_range[1] <= 0 then
                u622.pattern_range = nil
            end
            GlobalMarketplace.SearchMarket.Send(u622)
            u622.pattern_range = pattern_range
            abandonSearchAfterTimeout()
            u650.Sell.Confirm.Visible = false
        end,
    })

    local function closeSellConfirm() -- Line: 2796 -- upvalues: u650 (upval)
        u650.Sell.Confirm.Visible = false
    end

    MarketplaceButton.new(u650.Sell.Confirm.Action.Frame.Decline, {hoverSizeMultiplier = 0.9, onActivated = closeSellConfirm})
    CloseButtonRegistry.Add(u650.Sell.Confirm, nil, closeSellConfirm)
    GamepadNavigation.TrapPopup(u650.Sell.Confirm, function() -- Line: 2808 -- upvalues: u650 (upval)
        return u650.Sell.Confirm.Action.Frame.Decline
    end)
    local u55 = 1
    local u56 = false
    local u57 = 0

    local function generatePage(a1) -- Line: 2816
        -- upvalues: u56 (ref), u57 (ref), u635 (upval), InventoryController (upval), LocalPlayer (upval), u650 (upval)
        -- upvalues: createMarketListing (upval), u651 (upval), u628 (upval), u652 (upval), GetSkinDisplayName (upval)
        -- upvalues: CommaNumber (upval), Constants (upval), MarketplaceButton (upval), u656 (upval)
        -- upvalues: CloseButtonRegistry (upval), GamepadNavigation (upval), u657 (upval), GlobalMarketplace (upval)
        -- upvalues: removeYourListingByInventoryItemId (upval), MenuState (upval), u55 (ref)
        -- upvalues: pruneOldestListingFrames (upval)
        if u56 then
            return
        end
        u56 = true
        local v1 = u57
        local v2 = {page = a1}
        for i, j in u635 do
            v2[i] = j
        end
        local TradableInventoryPage = InventoryController:GetTradableInventoryPage(LocalPlayer, v2)
        if v1 == u57 and #TradableInventoryPage ~= 0 then
            local MetaData, Sell_3, v3
            local v4 = nil
            local v5 = nil
            for k, n in TradableInventoryPage, v4, v5 do
                if n._id then
                    v3 = u650.Sell.Container:FindFirstChild(n._id) ~= nil
                    local u64 = createMarketListing(u650.Sell.Container, n._id, u651, {inventoryItem = n})
                    if u64 then
                        local function listItem(a1) -- Line: 2850
                            -- upvalues: u628 (upval), n (val), u64 (val), u652 (upval), GetSkinDisplayName (upval)
                            -- upvalues: CommaNumber (upval), u650 (upval), Constants (upval), MarketplaceButton (upval)
                            if u628[n._id] then
                                return
                            end
                            u628[n._id] = {ItemID = n._id, Price = a1, inventoryItem = n}
                            u64.Visible = false
                            local v1 = n.Skin:split("_PATTERN_")[1]
                            local u24 = u652:Clone()
                            u24.Name = n._id
                            u24.Skin.Text = v1
                            GetSkinDisplayName.ApplyNameLabel(
                                u24.Gun,
                                GetSkinDisplayName.GetWeaponDisplayName(n.Name, n.NameTag),
                                n.NameTag
                            )
                            u24.Min.TextBox.Text = CommaNumber(a1)
                            u24.GunSkin.ItemIcon.Image = u64.Main.ItemIcon.Image
                            u24.GunSkin.RarityFrame.RarityBarGradient.Color = u64.Main.RarityFrame.RarityBarGradient.Color
                            u24.GunSkin.Serial.SerialText.Text = u64.Main.RarityFrame.Serial.SerialText.Text
                            u24.GunSkin.Condition.Tag.Text = u64.Main.RarityFrame.Condition.Tag.Text
                            local v2 = u24.GunSkin.Condition[("%*Gradient"):format(u64.Main.RarityFrame.Condition.Tag.Text)]
                            v2.Enabled = true
                            u24.Parent = u650.Sell.SellInfo.Container
                            u24.Min.TextBox.FocusLost:Connect(function() -- Line: 2880 -- upvalues: u24 (val), CommaNumber (upval), u628 (upval), n (upval), Constants (upval)
                                local v1 = tonumber(u24.Min.TextBox.Text)
                                if not v1 then
                                    u24.Min.TextBox.Text = CommaNumber(u628[n._id].Price)
                                    return
                                end
                                v1 = math.clamp(v1, 1, Constants.MARKETPLACE_MAX_LISTING_PRICE)
                                u628[n._id].Price = v1
                                u24.Min.TextBox.Text = CommaNumber(u628[n._id].Price)
                            end)
                            MarketplaceButton.new(u24.Return, {
                                hoverSizeMultiplier = 0.9,
                                onActivated = function() -- Line: 2895 -- upvalues: u628 (upval), n (upval), u24 (val), u650 (upval)
                                    u628[n._id] = nil
                                    u24:Destroy()
                                    local v1 = u650.Sell.Container:FindFirstChild(n._id)
                                    if v1 then
                                        v1.Visible = true
                                    end
                                end,
                            })
                        end

                        u64.Visible = u628[n._id] == nil
                        Sell_3 = u64.Main.Sell
                        MetaData = n.MetaData and n.MetaData.GlobalMarketPlaceListingReference
                        Sell_3.Visible = not MetaData
                        u64.Main.Delist.Visible = not u64.Main.Sell.Visible
                        if not v3 and not u64:GetAttribute("_sellActionsWired") then
                            u64:SetAttribute("_sellActionsWired", true)
                            MarketplaceButton.new(u64.Main.Sell, {
                                hoverSizeMultiplier = 0.9,
                                onActivated = function() -- Line: 2918
                                    -- upvalues: u656 (upval), u628 (upval), n (val), u650 (upval)
                                    -- upvalues: MarketplaceButton (upval), CloseButtonRegistry (upval)
                                    -- upvalues: GamepadNavigation (upval), listItem (val), Constants (upval)
                                    -- upvalues: CommaNumber (upval)
                                    local v1 = false
                                    if u656 ~= nil then
                                        v1 = u656.Parent ~= nil
                                    end
                                    if v1 or u628[n._id] then
                                        return
                                    end
                                    if u656 then
                                        u656:Destroy()
                                    end
                                    local u16 = 25
                                    local u22 = u650.Sell.SetPrice:Clone()
                                    u656 = u22
                                    u22.Visible = true
                                    u22.Parent = u650.Sell

                                    local function declineSetPrice() -- Line: 2937 -- upvalues: u22 (val)
                                        u22:Destroy()
                                    end

                                    MarketplaceButton.new(
                                        u22.Action.Frame.Decline,
                                        {hoverSizeMultiplier = 0.9, onActivated = declineSetPrice}
                                    )
                                    CloseButtonRegistry.Add(u22, nil, declineSetPrice)
                                    u22.Destroying:Connect(function() -- Line: 2950 -- upvalues: CloseButtonRegistry (upval), u22 (val)
                                        CloseButtonRegistry.Remove(u22)
                                    end)
                                    GamepadNavigation.TrapPopup(u22, function() -- Line: 2953 -- upvalues: u22 (val)
                                        return u22.Action.Frame.Accept
                                    end)
                                    MarketplaceButton.new(u656.Action.Frame.Accept, {
                                        hoverSizeMultiplier = 0.9,
                                        onActivated = function() -- Line: 2960 -- upvalues: listItem (upval), u16 (ref), u656 (upval), GamepadNavigation (upval), u650 (upval)
                                            listItem(u16)
                                            u656:Destroy()
                                            GamepadNavigation.Focus(u650.Sell.SellInfo.Sell)
                                        end,
                                    })

                                    local function applyTypedPrice(a1, a2) -- Line: 2970
                                        -- upvalues: u16 (ref), Constants (upval), u656 (upval), CommaNumber (upval)
                                        u16 = math.clamp(a1, 1, Constants.MARKETPLACE_MAX_LISTING_PRICE)
                                        local v1 = math.floor(u16 * (Constants.MARKET_TAX_PERCENT / 100))
                                        if a2 then
                                            u656.Price.Frame.SearchBox.Text = CommaNumber(u16)
                                        end
                                        u656.List.ListedPrice.TextLabel.Text = CommaNumber(u16)
                                        u656.List.Tax.TextLabel.Text = ("-%*"):format((CommaNumber(v1)))
                                        u656.List.Total.TextLabel.Text = CommaNumber(u16 - v1)
                                    end

                                    ;(u656.Price.Frame.SearchBox:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 2981 -- upvalues: u656 (upval), applyTypedPrice (val)
                                        local v1 = tonumber(u656.Price.Frame.SearchBox.Text)
                                        if v1 then
                                            applyTypedPrice(v1, false)
                                        end
                                    end)
                                    u656.Price.Frame.SearchBox.FocusLost:Connect(function() -- Line: 2988 -- upvalues: u656 (upval), CommaNumber (upval), u16 (ref), applyTypedPrice (val)
                                        local v1 = tonumber(u656.Price.Frame.SearchBox.Text)
                                        if not v1 then
                                            u656.Price.Frame.SearchBox.Text = CommaNumber(u16)
                                            return
                                        end
                                        applyTypedPrice(v1, true)
                                    end)
                                end,
                            })
                            MarketplaceButton.new(u64.Main.Delist, {
                                hoverSizeMultiplier = 0.9,
                                onActivated = function() -- Line: 3002
                                    -- upvalues: LocalPlayer (upval), u650 (upval), u657 (upval)
                                    -- upvalues: GlobalMarketplace (upval), n (val)
                                    -- upvalues: removeYourListingByInventoryItemId (upval), MenuState (upval)
                                    -- upvalues: u64 (val), GamepadNavigation (upval)
                                    if not LocalPlayer:GetAttribute("PinVerified") then
                                        return
                                    end
                                    u650.Parent.Parent.Loading.Visible = true
                                    u657:Play()
                                    GlobalMarketplace.DelistItem.Send(n._id)
                                    removeYourListingByInventoryItemId(n._id)
                                    local v1 = MenuState.IsSelectionWithin(u64.Main.Delist)
                                    u64.Main.Sell.Visible = true
                                    u64.Main.Delist.Visible = false
                                    if v1 then
                                        GamepadNavigation.Focus(u64.Main.Sell)
                                    end
                                end,
                            })
                        end
                    end
                end
            end
            u55 = a1 + 1
            pruneOldestListingFrames(u650.Sell.Container, 96)
            if v1 == u57 then
                u56 = false
            end
            return
        end
        u56 = false
    end

    u650.Sell.SetPrice.List.Tax.text.Text = ("Tax (%*%%)"):format(Constants.MARKET_TAX_PERCENT)
    local u72 = os.clock()
    ;(u650.Sell.Container:GetPropertyChangedSignal("CanvasPosition")):Connect(function() -- Line: 3030 -- upvalues: u650 (upval), u72 (ref), generatePage (val), u55 (ref)
        local v1 = math.max(0, u650.Sell.Container.AbsoluteCanvasSize.Y - u650.Sell.Container.AbsoluteSize.Y)
        local Y_3 = u650.Sell.Container.CanvasPosition.Y
        if v1 - 5 <= Y_3 and 0.25 < os.clock() - u72 then
            generatePage(u55)
            u72 = os.clock()
        end
    end)
    MarketplaceButton.new(u650.Sell.SellInfo.Sell, {
        hoverSizeMultiplier = 0.9,
        onActivated = function() -- Line: 3048 -- upvalues: u656 (upval), u650 (upval)
            local v1 = false
            if u656 ~= nil then
                v1 = u656.Parent ~= nil
            end
            if v1 then
                return
            end
            u650.Sell.Confirm.Visible = true
        end,
    })
    GlobalMarketplace.ListItemResult.Listen(function(a1) -- Line: 3057
        -- upvalues: u650 (upval), u628 (upval), syncListedItemToProfile (upval), GlobalMarketplace (upval)
        -- upvalues: LocalPlayer (upval), getMarketplaceErrorMessage (upval), Router (upval)
        local v1 = false
        if a1 and a1.results then
            local inventoryItemId, listing_reference_id, v2
            local v3 = nil
            local v4 = nil
            for i, j in a1.results, v3, v4 do
                if j.success then
                    v1 = true
                    inventoryItemId = j.inventoryItemId or j.inventory_item_id
                    if typeof(inventoryItemId) == "string" then
                        if u650.Sell.SellInfo.Container:FindFirstChild(inventoryItemId) then
                            u650.Sell.SellInfo.Container[inventoryItemId]:Destroy()
                        end
                        listing_reference_id = j.listing_reference_id or j.listingReferenceId
                        if typeof(listing_reference_id) == "string" and u628[inventoryItemId] then
                            u628[inventoryItemId].listingReferenceId = listing_reference_id
                        end
                        syncListedItemToProfile(j)
                        u628[inventoryItemId] = nil
                        v2 = u650.Sell.Container:FindFirstChild(inventoryItemId)
                        if v2 then
                            v2.Visible = true
                            v2.Main.Sell.Visible = false
                            v2.Main.Delist.Visible = true
                        end
                    end
                end
            end
        end
        if v1 then
            GlobalMarketplace.RequestProfileInfo.Send(LocalPlayer.UserId)
        end
        local v5 = getMarketplaceErrorMessage(a1)
        if not v5 then
            return
        end
        Router.broadcastRouter("CreateNotification", "Error", v5)
    end)

    local function refreshInventory() -- Line: 3101
        -- upvalues: u57 (ref), u56 (ref), u650 (upval), u55 (ref), generatePage (val)
        u57 = u57 + 1
        u56 = false
        u650.Sell.Container.CanvasPosition = Vector2.new(0, 0)
        for i, j in u650.Sell.Container:GetChildren() do
            if j:IsA("Frame") then
                j:Destroy()
            end
        end
        u55 = 1
        generatePage(u55)
    end

    local v1 = CollectionServiceUtility.FindDescendantWithTag(u650.Sell.Header.Filters, "Dropdown_Category")
    if v1 then
        (MarketplaceDropdown.new(v1, Constants.ITEM_CATEGORIES)).OptionSelected:Connect(function(a1) -- Line: 3122 -- upvalues: u635 (upval), refreshInventory (val)
            u635.filters = {"Tradable", "MarketplaceListable", a1}
            refreshInventory()
        end)
    end
    local v2 = CollectionServiceUtility.FindDescendantWithTag(u650.Sell.Header.Filters, "Dropdown_SortType")
    if v2 then
        (MarketplaceDropdown.new(v2, Constants.INVENTORY_SORTING_OPTIONS)).OptionSelected:Connect(function(a1) -- Line: 3133 -- upvalues: u635 (upval), refreshInventory (val)
            u635.sort = a1
            refreshInventory()
        end)
    end
    local u145 = CollectionServiceUtility.FindDescendantWithTag(u650.Sell.Header.Filters, "ReverseSort")
    if u145 then
        u145.Activated:Connect(function() -- Line: 3142 -- upvalues: u635 (upval), u145 (val), refreshInventory (val)
            u635.sortReversed = not u635.sortReversed
            local ImageLabel = u145:FindFirstChildOfClass("ImageLabel")
            if ImageLabel then
                ImageLabel.Rotation = if not u635.sortReversed then 0 else 180
            end
            refreshInventory()
        end)
        local ImageLabel = u145:FindFirstChildOfClass("ImageLabel")
        if ImageLabel then
            ImageLabel.Rotation = if not u635.sortReversed then 0 else 180
        end
    end
    local u170 = CollectionServiceUtility.FindDescendantWithTag(u650.Sell.Header.Filters, "SearchBox")
    if u170 then
        u170.FocusLost:Connect(function(a1) -- Line: 3161 -- upvalues: u635 (upval), u170 (val), refreshInventory (val)
            u635.searchTerm = u170.Text
            refreshInventory()
        end)
    end
    GlobalMarketplace.RefreshInventory.Listen(function() -- Line: 3167 -- upvalues: refreshInventory (val)
        refreshInventory()
    end)
    ;(u650.Sell:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 3171 -- upvalues: u650 (upval), refreshInventory (val)
        if u650.Sell.Visible then
            refreshInventory()
        end
    end)
    refreshInventory()
end

local function setupProfile() -- Line: 3180
    -- upvalues: u653 (ref), ReplicatedStorage (val), u654 (ref), u655 (ref), u650 (ref), GlobalMarketplace (val)
    -- upvalues: CommaNumber (val), GetSkinDisplayName (val), formatSaleDate (val), MarketplaceButton (val)
    -- upvalues: showInspect (val), addYourListing (val), LocalPlayer (val), UserCache (val), Players (val)
    -- upvalues: setOnlineStatus (val), u660 (ref), u659 (ref), UserInputService (val), u637 (ref)
    local new_2, v1
    u653 = ReplicatedStorage.Assets.TradingUI.Templates.SaleTemplate:Clone()
    u654 = ReplicatedStorage.Assets.TradingUI.Templates.ListingTemplate:Clone()
    u655 = ReplicatedStorage.Assets.TradingUI.Templates.SaleTemplate_Old:Clone()
    u650.Profile.Main.Frame.YourListings.Transactions.Listings.Template:Destroy()
    local Header = u650.Profile.Main.Frame.Header

    local function setProfileBadge(a1) -- Line: 3187 -- upvalues: u650 (upval)
        local Badge = u650.Profile.Main.ProfileInfo.Player:FindFirstChild("Badge")
        if not Badge then
            return
        end
        if not Badge:IsA("ImageLabel") and not Badge:IsA("ImageButton") then
            return
        end
        Badge.Image = if not a1 then "" else ("rbxassetid://%*"):format(a1)
    end

    local function filterListings(a1) -- Line: 3196 -- upvalues: u650 (upval) -- types: a1: string
        local v1
        local v2 = a1
        for i, j in u650.Profile.Main.Frame.YourListings.Transactions.Listings:GetChildren() do
            if j:IsA("Frame") and j:FindFirstChild("State") then
                v1 = true
                if v2 ~= "ALL" then
                    if v2 ~= "SOLD" then
                        v1 = false
                        if v2 == "PURCHASED" then
                            v1 = j.State.Text == "Purchased"
                        end
                    else
                        v1 = true
                        if j.State.Text ~= "Sold" then
                            v1 = false
                            if v2 == "PURCHASED" then
                                v1 = j.State.Text == "Purchased"
                            end
                        end
                    end
                end
                j.Visible = v1
            end
        end
        for k, n in u650.Profile.Main.Frame.YourListings.Transactions.TopSelect.Container:GetChildren() do
            if n:IsA("TextButton") then
                n.Frame.Visible = n.Name == v2
            end
        end
    end

    GlobalMarketplace.ProfileInfo.Listen(function(a1) -- Line: 3221
        -- upvalues: u650 (upval), CommaNumber (upval), u655 (upval), GetSkinDisplayName (upval), formatSaleDate (upval)
        -- upvalues: MarketplaceButton (upval), showInspect (upval), addYourListing (upval), LocalPlayer (upval)
        -- upvalues: UserCache (upval), Players (upval), setProfileBadge (val), setOnlineStatus (upval), u660 (upval)
        -- upvalues: u659 (upval)
        local ExtraHide, Info, Type, listing_reference_id_2, v1, v2, v3
        if not a1.success then
            return
        end
        for i, j in u650.Profile.Main.Frame.YourListings.Transactions.Listings:GetChildren() do
            if j:IsA("Frame") then
                j:Destroy()
            end
        end
        u650.Profile.Main.ProfileInfo.Earnings.List.Purchases.Credits.TextLabel.Text = CommaNumber(a1.purchases)
        u650.Profile.Main.ProfileInfo.Earnings.List.Sales.Credits.TextLabel.Text = CommaNumber(a1.sales_revenue)
        u650.Profile.Main.ProfileInfo.Earnings.List.Net.Credits.TextLabel.Text = CommaNumber(a1.net_revenue)
        local TextLabel = u650.Profile.Main.ProfileInfo.Earnings.List.Net.Credits.TextLabel
        local v4 = 0 < a1.net_revenue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        TextLabel.TextColor3 = v4
        v4 = nil
        local v5 = nil
        local v6 = a1
        for k, n in a1.transactions, v4, v5 do
            if not u650.Profile.Main.Frame.YourListings.Transactions.Listings:FindFirstChild(n.listing_reference_id) then
                v2 = u655:Clone()
                v2.Name = n.listing_reference_id
                v2.State.Text = if n.role ~= "seller" then "Purchased" else "Sold"
                local inventoryItem = n.inventoryItem
                listing_reference_id_2 = n.listing_reference_id
                if inventoryItem then
                    v3 = not not inventoryItem.StatTrack
                    v1 = GetSkinDisplayName.GetFullItemDisplayName(inventoryItem.Name, inventoryItem.Skin, v3, true, inventoryItem.NameTag)
                    listing_reference_id_2 = if v1 == "" then ("%*%* | %*"):format(
                        if not v3 then "" else "KillTrak™ ",
                        GetSkinDisplayName.GetWeaponDisplayName(inventoryItem.Name, inventoryItem.NameTag),
                        inventoryItem.Skin
                    ) else v1
                end
                GetSkinDisplayName.ApplyNameLabel(v2.GunName, listing_reference_id_2, inventoryItem and inventoryItem.NameTag)
                v2.Serial.Text = if not inventoryItem or not inventoryItem.Serial then "N/A" else ("#%*"):format((CommaNumber(inventoryItem.Serial)))
                v2.Date.Text = formatSaleDate(n.date)
                v2.Credits.TextLabel.Text = CommaNumber(n.tradeTokens)
                v2.Parent = u650.Profile.Main.Frame.YourListings.Transactions.Listings
                v3 = false
                if inventoryItem ~= nil then
                    Type = inventoryItem.Type
                    v1 = true
                    if Type ~= "Case" then
                        v1 = Type == "Package"
                    end
                    v3 = not v1
                end
                Info = v2:FindFirstChild("Info")
                ExtraHide = v2:FindFirstChild("ExtraHide")
                if Info and Info:IsA("GuiButton") then
                    Info.Visible = v3
                    if inventoryItem and v3 then
                        MarketplaceButton.new(Info, {
                            hoverSizeMultiplier = 0.9,
                            onActivated = function() -- Line: 3297 -- upvalues: showInspect (upval), inventoryItem (val)
                                showInspect(inventoryItem)
                            end,
                        })
                    end
                end
                if ExtraHide and ExtraHide:IsA("GuiObject") then
                    ExtraHide.Visible = not v3
                end
            end
        end
        for m, i5 in v6.listings do
            if i5.inventoryItem then
                addYourListing(i5)
            end
        end
        local UserId = tonumber(v6.SearchedUser) or LocalPlayer.UserId
        v4 = UserCache.Fetch(UserId)
        local Player = u650.Profile.Main.ProfileInfo.Player.Player
        local Size420x420 = Enum.ThumbnailSize.Size420x420
        Player.Image = Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Size420x420 or Enum.ThumbnailSize.Size180x180)
        u650.Profile.Main.ProfileInfo.Player.DisplayName.Text = v4.DisplayName
        u650.Profile.Main.ProfileInfo.Player.Username.Text = ("@%*"):format(v4.Username)
        setProfileBadge(v6.equippedBadge and v6.equippedBadge.imageAssetId)
        local Last = u650.Profile.Main.ProfileInfo.Player.Last
        local status = v6.status
        if status and status.isActiveSession then
            setOnlineStatus(Last)
            return
        end
        if status and status.lastSessionAt then
            local lastSessionAt = status.lastSessionAt
            v2 = ("%* %*, %*"):format(os.date("%B", lastSessionAt), os.date("%d", lastSessionAt), (os.date("%Y", lastSessionAt)))
            if u660 then
                u660()
                u660 = nil
            end
            if u659 then
                u659:Cancel()
                u659 = nil
            end
            Last.TextTransparency = 0
            local OnlinePulseDot = Last:FindFirstChild("OnlinePulseDot")
            if OnlinePulseDot and OnlinePulseDot:IsA("GuiObject") then
                OnlinePulseDot.Visible = false
            end
            Last.Text = ("Last Online: %*"):format(v2)
            Last.TextColor3 = Color3.fromRGB(136, 136, 136)
            return
        end
        if u660 then
            u660()
            u660 = nil
        end
        if u659 then
            u659:Cancel()
            u659 = nil
        end
        Last.TextTransparency = 0
        local OnlinePulseDot_2 = Last:FindFirstChild("OnlinePulseDot")
        if OnlinePulseDot_2 and OnlinePulseDot_2:IsA("GuiObject") then
            OnlinePulseDot_2.Visible = false
        end
        Last.Text = "Never Active"
        Last.TextColor3 = Color3.fromRGB(100, 0, 0)
    end)
    for i, j in u650.Profile.Main.Frame.YourListings.Transactions.TopSelect.Container:GetChildren() do
        if j:IsA("TextButton") then
            new_2 = MarketplaceButton.new
            v1 = {
                hoverSizeMultiplier = 0.9,
                onActivated = function() -- Line: 3348 -- upvalues: filterListings (val), j (val)
                    filterListings(j.Name)
                end,
            }
            new_2(j, v1)
        end
    end
    GlobalMarketplace.PurchasedItem.Listen(function(a1) -- Line: 3354
        -- upvalues: GlobalMarketplace (upval), LocalPlayer (upval), u650 (upval)
        GlobalMarketplace.RequestProfileInfo.Send(LocalPlayer.UserId)
        local v1 = u650.Market.Container:FindFirstChild(a1)
        if v1 then
            v1:Destroy()
        end
    end)
    local Player = u650.Profile.Main.ProfileInfo.Player.Player
    local UserId = LocalPlayer.UserId
    local Size420x420 = Enum.ThumbnailSize.Size420x420
    Player.Image = Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Size420x420 or Enum.ThumbnailSize.Size180x180)
    u650.Profile.Main.ProfileInfo.Player.DisplayName.Text = LocalPlayer.DisplayName
    u650.Profile.Main.ProfileInfo.Player.Username.Text = ("@%*"):format(LocalPlayer.Name)
    local u115 = {"Transactions", "YourListings"}
    for k, n in u115 do
        MarketplaceButton.new(Header.TopSelect.Container[n], {
            hoverSizeMultiplier = 0.9,
            onActivated = function() -- Line: 3374 -- upvalues: u115 (val), Header (val), n (val), u650 (upval)
                local Frame, v1
                local v2 = nil
                local v3 = nil
                for i, j in u115, v2, v3 do
                    Frame = Header.TopSelect.Container[j].Frame
                    Frame.Visible = j == n
                    v1 = u650.Profile.Main.Frame.YourListings[j]
                    v1.Visible = j == n
                end
                for k, n2 in u650.Profile.Main.Frame.YourListings.Header:GetChildren() do
                    if n2:IsA("TextLabel") then
                        v1 = n == "Transactions"
                        n2.Visible = v1
                    end
                end
            end,
        })
    end
    UserInputService.InputBegan:Connect(function(a1) -- Line: 3390 -- upvalues: u637 (upval), u650 (upval) -- types: a1: userdata
        if a1.KeyCode == Enum.KeyCode.Tab and u637 then
            local v1 = u637
            task.wait(0.1)
            u650.Market.Filters.Container.Search.Frame.SearchBox.Text = v1
            u637 = nil
        end
    end)
end

local function fetchMarketOnOpen() -- Line: 3404
    -- upvalues: u619 (ref), u650 (ref), u657 (ref), u622 (val), u627 (ref), getWearSearchRangeFromSelection (val)
    -- upvalues: GlobalMarketplace (val), abandonSearchAfterTimeout (ref)
    if not u619 and u650 and u657 then
        u619 = true
        u622.page = 1
        u650.Parent.Parent.Loading.Visible = true
        u657:Play()
        u627 = true
        u622.wear_range = getWearSearchRangeFromSelection()
        local pattern_range = u622.pattern_range
        if pattern_range and pattern_range[1] <= 0 then
            u622.pattern_range = nil
        end
        GlobalMarketplace.SearchMarket.Send(u622)
        u622.pattern_range = pattern_range
        abandonSearchAfterTimeout()
        return
    end
end

local function focusMarketplaceOnOpen() -- Line: 3425
    -- upvalues: u650 (ref), u646 (ref), MenuState (val), GamepadNavigation (val), u634 (val)
    if u650.Visible and not u650.Pin.Visible then
        local v1 = u646
        u646 = nil
        if not MenuState.IsNavigationSelectionHeld() and not MenuState.IsSelectionWithin(u650) then
            if v1 and GamepadNavigation.IsUsable(v1) and GamepadNavigation.Focus(v1) then
                return
            end
            local PurchaseMenu = u650.Market.PurchaseMenu
            if PurchaseMenu.Visible and GamepadNavigation.Focus(PurchaseMenu) then
                return
            end
            for i, j in u634 do
                if u650[j].Visible then
                    GamepadNavigation.Focus(u650.Top.Frame:FindFirstChild(j))
                    return
                end
            end
            return
        end
        return
    end
end

local function closeMarketPopups() -- Line: 3454
    -- upvalues: u646 (ref), u638 (ref), u636 (ref), u650 (ref), hideQuickPick (val), u656 (ref)
    u646 = nil
    u638 = nil
    if u636 then
        u636:Destroy()
        u636 = nil
    end
    u650.Market.PurchaseMenu.Confirm.Visible = false
    u650.Market.PurchaseMenu.Visible = false
    u650.Market.Confirm.Visible = false
    hideQuickPick()
    u650.Sell.Confirm.Visible = false
    if u656 then
        u656:Destroy()
    end
end

local function onVisibilityChanged(a1) -- Line: 3468
    -- upvalues: u650 (ref), u642 (ref), selectQuickItem (ref), u619 (ref), u657 (ref), u622 (val), u627 (ref)
    -- upvalues: getWearSearchRangeFromSelection (val), GlobalMarketplace (val), abandonSearchAfterTimeout (ref)
    -- upvalues: LocalPlayer (val), focusMarketplaceOnOpen (val), u641 (ref), u643 (ref), resetQuickSearchFilters (ref)
    -- upvalues: MenuState (val), u646 (ref), u638 (ref), u636 (ref), hideQuickPick (val), u656 (ref)
    -- upvalues: MarketplaceHover (val)
    local pattern_range
    if not u650 then
        return
    end
    if not a1 then
        u641 = nil
        u642 = nil
        if u643 then
            u643 = false
            resetQuickSearchFilters()
        end
        if not MenuState.IsInspectActive() then
            u646 = nil
            u638 = nil
            if u636 then
                u636:Destroy()
                u636 = nil
            end
            u650.Market.PurchaseMenu.Confirm.Visible = false
            u650.Market.PurchaseMenu.Visible = false
            u650.Market.Confirm.Visible = false
            hideQuickPick()
            u650.Sell.Confirm.Visible = false
            if u656 then
                u656:Destroy()
            end
        end
        if u657 then
            u650.Pin.Visible = false
            MarketplaceHover:Close()
            u650.Parent.Parent.Loading.Visible = false
            u657:Pause()
        end
        return
    end
    local v1 = u642
    u642 = nil
    if not v1 then
        if not u619 and u650 and u657 then
            u619 = true
            u622.page = 1
            u650.Parent.Parent.Loading.Visible = true
            u657:Play()
            u627 = true
            u622.wear_range = getWearSearchRangeFromSelection()
            pattern_range = u622.pattern_range
            if pattern_range and pattern_range[1] <= 0 then
                u622.pattern_range = nil
            end
            GlobalMarketplace.SearchMarket.Send(u622)
            u622.pattern_range = pattern_range
            abandonSearchAfterTimeout()
        end
    elseif not selectQuickItem(v1.ItemName, v1.SkinName, v1.Details) and not u619 and u650 and u657 then
        u619 = true
        u622.page = 1
        u650.Parent.Parent.Loading.Visible = true
        u657:Play()
        u627 = true
        u622.wear_range = getWearSearchRangeFromSelection()
        pattern_range = u622.pattern_range
        if pattern_range and pattern_range[1] <= 0 then
            u622.pattern_range = nil
        end
        GlobalMarketplace.SearchMarket.Send(u622)
        u622.pattern_range = pattern_range
        abandonSearchAfterTimeout()
    end
    u650.Pin.Visible = LocalPlayer:GetAttribute("PinVerified") == false
    task.defer(focusMarketplaceOnOpen)
end

local function isExcludedIndexSchema(a1) -- Line: 3511 -- upvalues: u613 (val)
    local v1 = true
    if u613[a1.name] ~= true then
        v1 = u613[a1.type] == true
    end
    return v1
end

local function setQuickFilterDropdownSelection(a1, a2) -- Line: 3515
    -- upvalues: u625 (val)
    local v1 = u625[a1]
    if v1 then
        v1:SelectOption(a2)
    end
end

local function setQuickPatternRange(a1) -- Line: 3522
    -- upvalues: u622 (val), CollectionService (val), setDrag (val)
    local v1 = tonumber(a1)
    u622.pattern_range = if not v1 then {0, 11} else {v1, v1}
    for i, j in CollectionService:GetTagged("pattern_range") do
        if not v1 then
            setDrag(j, 0, "StartPin", 11)
            setDrag(j, 11, "EndPin", 11)
        else
            setDrag(j, v1, "StartPin", 11)
            setDrag(j, v1, "EndPin", 11)
        end
    end
end

local function setQuickWearTier(a1, a2) -- Line: 3539
    -- upvalues: Skins (val), u629 (val), u631 (val), setWearTierVisual (val), getWearSearchRangeFromSelection (val)
    -- upvalues: setWearRange (val), u622 (val)
    local key, v1
    local v2 = if not a2 then nil else Skins.GetWearNameForFloat(a1, a2)
    local v3 = nil
    local v4 = nil
    for i, j in u629, v3, v4 do
        key = j.key
        v1 = false
        if v2 ~= nil then
            v1 = j.wear == v2
        end
        u631[key] = v1
        setWearTierVisual(j.key, u631[j.key])
    end
    local v5 = getWearSearchRangeFromSelection()
    v3 = v5[2]
    if v3 < 1 then
        v3 = v3 + 1e-12
    end
    setWearRange(v5[1], v3)
    u622.wear_range = getWearSearchRangeFromSelection()
end

local function setQuickStatTrak(a1) -- Line: 3549 -- upvalues: u622 (val), u644 (ref) -- types: a1: boolean?
    u622.statTrak = if not a1 then nil else true
    if u644 then
        u644.Visible = a1 == true
    end
end

local function clearQuickNarrowing() -- Line: 3558
    -- upvalues: u645 (ref), u629 (val), u631 (val), setWearTierVisual (val), getWearSearchRangeFromSelection (val)
    -- upvalues: setWearRange (val), u622 (val), u644 (ref)
    if not u645 then
        return
    end
    u645 = false
    for i, j in u629 do
        u631[j.key] = false
        setWearTierVisual(j.key, u631[j.key])
    end
    local v1 = getWearSearchRangeFromSelection()
    local v2 = v1[2]
    if v2 < 1 then
        v2 = v2 + 1e-12
    end
    setWearRange(v1[1], v2)
    u622.wear_range = getWearSearchRangeFromSelection()
    u622.statTrak = nil
    if u644 then
        u644.Visible = false
    end
end

function resetQuickSearchFilters() -- Line: 3569
    -- upvalues: u622 (val), setQuickPatternRange (val), u645 (ref), u629 (val), u631 (val), setWearTierVisual (val)
    -- upvalues: getWearSearchRangeFromSelection (val), setWearRange (val), u644 (ref), u650 (ref), u625 (val)
    -- upvalues: u619 (ref)
    u622.search_bar_query = ""
    u622.rarity = nil
    u622.Collection = nil
    u622.page = 1
    setQuickPatternRange(nil)
    if u645 then
        u645 = false
        for i, j in u629 do
            u631[j.key] = false
            setWearTierVisual(j.key, u631[j.key])
        end
        local v1 = getWearSearchRangeFromSelection()
        local v2 = v1[2]
        if v2 < 1 then
            v2 = v2 + 1e-12
        end
        setWearRange(v1[1], v2)
        u622.wear_range = getWearSearchRangeFromSelection()
        u622.statTrak = nil
        if u644 then
            u644.Visible = false
        end
    end
    if u650 then
        u650.Market.Filters.Container.Search.Frame.SearchBox.Text = ""
        u650.Market.Filters.Container.Search.Frame.Auto.Text = ""
    end
    local collection_dropdown = u625.collection_dropdown
    if collection_dropdown then
        collection_dropdown:SelectOption("All")
    end
    local rarity_dropdown = u625.rarity_dropdown
    if rarity_dropdown then
        rarity_dropdown:SelectOption("All")
    end
    u619 = false
end

local function dispatchQuickSearch() -- Line: 3591
    -- upvalues: u622 (val), u627 (ref), u619 (ref), u643 (ref), MenuState (val), u650 (ref), u624 (ref)
    -- upvalues: hideQuickPick (val), GamepadNavigation (val), u657 (ref), GlobalMarketplace (val)
    -- upvalues: abandonSearchAfterTimeout (ref)
    u622.page = 1
    u622.uiCategorySearch = true
    u627 = true
    u619 = true
    u643 = true
    local v1 = MenuState.IsSelectionWithin(u650.Market.Header.Guns)
    local v2 = u624
    hideQuickPick()
    if v1 and v2 then
        GamepadNavigation.Focus(u650.Market.Header.Filters:FindFirstChild(v2))
    end
    u650.Parent.Parent.Loading.Visible = true
    u657:Play()
    local pattern_range = u622.pattern_range
    if pattern_range and pattern_range[1] <= 0 then
        u622.pattern_range = nil
    end
    GlobalMarketplace.SearchMarket.Send(u622)
    u622.pattern_range = pattern_range
    abandonSearchAfterTimeout()
    u622.uiCategorySearch = nil
end

local function requestQuickItemSearch(a1, a2, a3) -- Line: 3614
    -- upvalues: u622 (val), u625 (val), u650 (ref), setQuickPatternRange (val), u645 (ref), setQuickWearTier (val)
    -- upvalues: u644 (ref), u629 (val), u631 (val), setWearTierVisual (val), getWearSearchRangeFromSelection (val)
    -- upvalues: setWearRange (val), dispatchQuickSearch (val)
    u622.Collection = if not a1.collection then nil else if a1.collection == "" then nil else a1.collection
    local v1 = u622.Collection or "All"
    local collection_dropdown = u625.collection_dropdown
    if collection_dropdown then
        collection_dropdown:SelectOption(v1)
    end
    u622.search_bar_query = a1.paintId:gsub(" | ", " ")
    u650.Market.Filters.Container.Search.Frame.SearchBox.Text = u622.search_bar_query
    u622.rarity = a1.rarity
    local rarity = a1.rarity
    local rarity_dropdown = u625.rarity_dropdown
    if rarity_dropdown then
        rarity_dropdown:SelectOption(rarity)
    end
    setQuickPatternRange(a2)
    if a3 then
        u645 = true
        setQuickWearTier(a1, a3.Float)
        local StatTrak = a3.StatTrak
        u622.statTrak = if not StatTrak then nil else true
        if u644 then
            u644.Visible = StatTrak == true
        end
    elseif u645 then
        u645 = false
        for i, j in u629 do
            u631[j.key] = false
            setWearTierVisual(j.key, u631[j.key])
        end
        v1 = getWearSearchRangeFromSelection()
        local v2 = v1[2]
        if v2 < 1 then
            v2 = v2 + 1e-12
        end
        setWearRange(v1[1], v2)
        u622.wear_range = getWearSearchRangeFromSelection()
        u622.statTrak = nil
        if u644 then
            u644.Visible = false
        end
    end
    dispatchQuickSearch()
end

local function requestQuickCaseSearch(a1) -- Line: 3639
    -- upvalues: u622 (val), u625 (val), u650 (ref), u645 (ref), u629 (val), u631 (val), setWearTierVisual (val)
    -- upvalues: getWearSearchRangeFromSelection (val), setWearRange (val), u644 (ref), setQuickPatternRange (val)
    -- upvalues: dispatchQuickSearch (val)
    u622.Collection = nil
    local collection_dropdown = u625.collection_dropdown
    if collection_dropdown then
        collection_dropdown:SelectOption("All")
    end
    u622.search_bar_query = a1.name
    u650.Market.Filters.Container.Search.Frame.SearchBox.Text = u622.search_bar_query
    u622.rarity = nil
    local rarity_dropdown = u625.rarity_dropdown
    if rarity_dropdown then
        rarity_dropdown:SelectOption("All")
    end
    if u645 then
        u645 = false
        for i, j in u629 do
            u631[j.key] = false
            setWearTierVisual(j.key, u631[j.key])
        end
        local v1 = getWearSearchRangeFromSelection()
        local v2 = v1[2]
        if v2 < 1 then
            v2 = v2 + 1e-12
        end
        setWearRange(v1[1], v2)
        u622.wear_range = getWearSearchRangeFromSelection()
        u622.statTrak = nil
        if u644 then
            u644.Visible = false
        end
    end
    u622.statTrak = nil
    u622.wear_range = {0, 1}
    setQuickPatternRange(nil)
    dispatchQuickSearch()
end

local function isQuickSearchable(a1, a2) -- Line: 3658
    -- upvalues: Skins (val), Cases (val)
    local v1 = true
    if Skins.GetSkinInformation(a1, a2) == nil then
        v1 = Cases.GetCaseByName(a2) ~= nil
    end
    return v1
end

function selectQuickItem(a1, a2, a3) -- Line: 3662
    -- upvalues: Skins (val), requestQuickItemSearch (val), Cases (val), requestQuickCaseSearch (val)
    local v1 = Skins.GetSkinInformation(a1, a2)
    if v1 then
        local v2
        _, v2 = table.unpack((v1.skin:split("_PATTERN_")))
        requestQuickItemSearch(v1, v2, a3)
        return true
    end
    local v3 = Cases.GetCaseByName(a2)
    if not v3 then
        return false
    end
    requestQuickCaseSearch(v3)
    return true
end

function v3.SearchForItem(a1, a2, a3) -- Line: 3682
    -- upvalues: u650 (ref), Skins (val), Cases (val), selectQuickItem (ref), u642 (ref)
    if not u650 then
        return false
    end
    local v1 = true
    if Skins.GetSkinInformation(a1, a2) == nil then
        v1 = Cases.GetCaseByName(a2) ~= nil
    end
    if not v1 then
        return false
    end
    if u650.Visible then
        return selectQuickItem(a1, a2, a3)
    end
    u642 = {ItemName = a1, SkinName = a2, Details = a3}
    return true
end

function v3.SetReturnScreen(a1) -- Line: 3700 -- upvalues: u641 (ref) -- types: a1: string?
    u641 = a1
end

local function buildGuns(a1, a2) -- Line: 3704
    -- upvalues: u650 (ref), u623 (ref), MarketPlacePrices (val), Skins (val), getRarityData (val)
    -- upvalues: ReplicatedStorage (val), GetSkinDisplayName (val), CommaNumber (val), LocalPlayer (val)
    -- upvalues: MarketplaceButton (val), MarketplaceHover (val), UserInputService (val), selectQuickItem (ref)
    -- upvalues: showInspect (val)
    local Inspect, Status, Type, UserDescription, _id, recentAveragePriceTradeTokens, recentAveragePriceTradeTokens_2, v1, v2, v3, v4, v5, v6, v7, v8
    local Guns = u650.Market.Header.Guns
    local v9, v10 = a1, a2
    for i, j in Guns.TopSelect.Container:GetChildren() do
        if j:IsA("TextButton") then
            j.Frame.Visible = j.Name == v10
        end
    end
    for k, n in Guns.Frame:GetChildren() do
        if n:IsA("ImageButton") then
            n:Destroy()
        end
    end
    local v11 = {}
    local v12 = u623[v9]
    local v13 = nil
    local v14 = nil
    for m, i5 in v12, v13, v14 do
        if v10 == "ALL" then
            for i6, i7 in i5 do
                table.insert(v11, i7)
            end
        elseif m == v10 then
            for i8, i9 in i5 do
                table.insert(v11, i9)
            end
        end
    end
    local u333 = {}
    v14 = nil
    local v15 = nil
    for i10, i11 in v11, v14, v15 do
        _id = i11._id
        v6 = MarketPlacePrices.GetItemPrice(i11.Name, i11.Skin, i11.Float, false)
        recentAveragePriceTradeTokens_2 = v6 and v6.recentAveragePriceTradeTokens
        u333[_id] = (if not recentAveragePriceTradeTokens_2 then nil else if not (recentAveragePriceTradeTokens_2 > 0) then nil else math.floor(recentAveragePriceTradeTokens_2)) or 0
    end
    table.sort(v11, function(a1, a2) -- Line: 3733 -- upvalues: u333 (val)
        local v1 = u333[a1._id] or 0
        local v2 = u333[a2._id] or 0
        if v1 ~= v2 then
            return v2 < v1
        end
        return (string.lower((("%* | %*"):format(a1.Name, a1.Skin)))) < string.lower((("%* | %*"):format(a2.Name, a2.Skin)))
    end)
    v14 = nil
    v15 = nil
    for i12, i13 in v11, v14, v15 do
        v1 = Skins.GetSkinInformation(i13.Name, i13.Skin)
        if v1 then
            v2, v3 = table.unpack((v1.skin:split("_PATTERN_")))
            v4 = getRarityData(v1.rarity)
            local u98 = ReplicatedStorage.Assets.TradingUI.Templates.QuickTemplate:Clone()
            u98.Name = i13._id
            v5 = GetSkinDisplayName.GetWeaponDisplayName(i13.Name, i13.NameTag)
            GetSkinDisplayName.ApplyNameLabel(
                u98.Skin,
                if not v3 then ("%* | %*"):format(v5, v2) else ("%* | %* %*"):format(v5, v2, v3),
                i13.NameTag
            )
            u98.RarityBG.RarityBarGradient.Color = v4.ColorSequence
            u98.RarityFrame.RarityBarGradient.Color = v4.ColorSequence
            Status = u98.Status
            v8 = MarketPlacePrices.GetItemPrice(i13.Name, i13.Skin, i13.Float, false)
            recentAveragePriceTradeTokens = v8 and v8.recentAveragePriceTradeTokens
            v7 = if not recentAveragePriceTradeTokens then nil else if not (recentAveragePriceTradeTokens > 0) then nil else math.floor(recentAveragePriceTradeTokens)
            Status.Text = ("RAP: %*"):format(if not v7 then "N/A" else CommaNumber(v7))
            local u174 = {
                Charm = false,
                IsTradeable = true,
                Serial = 1,
                __v = 0,
                StatTrack = false,
                NameTag = false,
                HideWearDetails = true,
                ShowFullPriceRange = true,
            }
            u174.Float = i13.Float or 0
            u174.MetaData = {
                Origin = "Unboxed",
                CreatedAt = os.time(),
                LastTradeAt = os.time(),
                TradeHistory = {},
                OriginalOwner = LocalPlayer.UserId,
                Owner = LocalPlayer.UserId,
            }
            u174.Name = v1.name
            u174.Skin = v1.skin
            u174.Pattern = tonumber(v3) or 1
            u174.Rarity = v1.rarity
            u174.Type = v1.type
            u174._id = i13._id
            u174.Stickers = {}
            u98.ItemIcon.Image = Skins.GetItemIconImage(v1, u174)
            u98.Active = true
            u98.Selectable = true
            u98.Parent = Guns.Frame
            UserDescription = u98.Tools:FindFirstChild("UserDescription")
            if UserDescription and UserDescription:IsA("GuiButton") then
                UserDescription.Visible = true
                MarketplaceButton.new(UserDescription, {
                    hoverSizeMultiplier = 0.9,
                    onActivated = function() -- Line: 3801 -- upvalues: MarketplaceHover (upval), u174 (val), u98 (val)
                        MarketplaceHover:OpenTradeInfo(u174, u98)
                    end,
                })
                if not UserInputService.TouchEnabled then
                    UserDescription.MouseEnter:Connect(function() -- Line: 3806 -- upvalues: MarketplaceHover (upval), u174 (val), u98 (val)
                        MarketplaceHover:Open(u174, u98)
                    end)
                    UserDescription.MouseLeave:Connect(function() -- Line: 3809 -- upvalues: MarketplaceHover (upval), u98 (val)
                        MarketplaceHover:Close(u98)
                    end)
                end
            end
            Inspect = u98.Tools.Inspect
            Type = u174.Type
            v7 = true
            if Type ~= "Case" then
                v7 = Type == "Package"
            end
            Inspect.Visible = not v7
            u98.Activated:Connect(function() -- Line: 3818 -- upvalues: selectQuickItem (upval), i13 (val)
                selectQuickItem(i13.Name, i13.Skin)
            end)
            MarketplaceButton.new(u98.Tools.Inspect, {
                hoverSizeMultiplier = 0.9,
                onActivated = function() -- Line: 3825 -- upvalues: showInspect (upval), u174 (val)
                    showInspect(u174)
                end,
            })
        end
    end
end

local function switchQuickTab(a1) -- Line: 3832
    -- upvalues: u623 (ref), u650 (ref), ReplicatedStorage (val), MarketplaceButton (val), buildGuns (val)
    local v1
    if not u623[a1] then
        return
    end
    local Guns = u650.Market.Header.Guns
    for i, j in Guns.Frame:GetChildren() do
        if j:IsA("ImageButton") then
            j:Destroy()
        end
    end
    for k, n in Guns.TopSelect.Container:GetChildren() do
        if n:IsA("TextButton") then
            n:Destroy()
        end
    end
    local v2 = {}
    for m in u623[a1] do
        table.insert(v2, m)
    end
    table.sort(v2, function(a1, a2) -- Line: 3854
        if a1 == "ALL" then
            return true
        end
        if a2 == "ALL" then
            return false
        end
        return (a1:lower()) < a2:lower()
    end)
    local v3 = nil
    local v4 = nil
    for i5, i6 in v2, v3, v4 do
        v1 = ReplicatedStorage.Assets.TradingUI.Templates.GunTemplate:Clone()
        v1.LayoutOrder = if i6 ~= "ALL" then 1 else 0
        v1.Name = i6
        v1.Title.Text = i6
        v1.Parent = Guns.TopSelect.Container
        MarketplaceButton.new(v1, {
            hoverSizeMultiplier = 0.9,
            onActivated = function() -- Line: 3873 -- upvalues: buildGuns (upval), a1 (val), i6 (val)
                buildGuns(a1, i6)
            end,
        })
    end
    buildGuns(a1, "ALL")
    Guns.Frame.CanvasPosition = Vector2.zero
    Guns.Visible = true
end

local function openQuickCategory(a1) -- Line: 3884
    -- upvalues: u623 (ref), u624 (ref), switchQuickTab (val), u650 (ref)
    if not u623[a1] then
        return false
    end
    u624 = a1
    switchQuickTab(a1)
    for i, j in u650.Market.Header.Filters:GetChildren() do
        if j:IsA("TextButton") then
            j.ImageLabel.Rotation = if j.Name ~= a1 then 0 else 180
        end
    end
    return true
end

local function closeMarketplace() -- Line: 3899 -- upvalues: MarketplaceHover (val), ReplicatedStorage (val), u641 (ref)
    MarketplaceHover:Close()
    require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame(u641 or "Dashboard")
end

function v3.Initialize(a1, a2) -- Line: 3912
    -- upvalues: u650 (ref), CommaNumber (val), DataController (val), LocalPlayer (val), PolicyService (val), u620 (ref)
    -- upvalues: MarketplaceHover (val), u657 (ref), TweenService (val), GlobalMarketplace (val)
    -- upvalues: CloseButtonRegistry (val), closeMarketplace (val), setupProfile (val), setupMarket (val)
    -- upvalues: setupSell (val), Skins (val), u623 (ref), u613 (val), u615 (val), GetWeaponProperties (val), u624 (ref)
    -- upvalues: MenuState (val), hideQuickPick (val), GamepadNavigation (val), openQuickCategory (val), buildGuns (val)
    -- upvalues: u622 (val), Rarities (val), MarketplaceDropdown (val), u625 (val), Collections (val)
    -- upvalues: MarketplaceButton (val), u634 (val), u656 (ref), Players (val), Remotes (val), UserInputService (val)
    -- upvalues: u612 (val), onVisibilityChanged (val), u646 (ref), u638 (ref), u636 (ref)
    local new_2, v1
    u650 = a2
    local TextLabel = u650.Top.TradeTokens:FindFirstChild("TextLabel")
    assert(TextLabel and TextLabel:IsA("TextLabel"), "Marketplace TradeTokens is missing its balance label")
    local v2 = DataController.Get(LocalPlayer, "TradeTokens")
    TextLabel.Text = CommaNumber((math.floor((tonumber(v2)) or 0)))
    DataController.CreateListener(LocalPlayer, "TradeTokens", function(a1) -- Line: 3921 -- upvalues: TextLabel (val), CommaNumber (upval)
        TextLabel.Text = CommaNumber((math.floor((tonumber(a1)) or 0)))
    end)
    local success, result = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer)
    if success and result then
        u620 = result.ArePaidRandomItemsRestricted == true
    end
    local Parent = u650.Parent.Parent
    local Hover = Parent:FindFirstChild("Hover")
    if not Hover or not Hover:IsA("GuiObject") then
        warn("Marketplace hover UI is missing from MainGui")
    else
        MarketplaceHover:Initialize(Hover, u650)
        MarketplaceHover.Start()
    end
    u657 = TweenService:Create(
        Parent.Loading.Loading,
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, (1 / 0)),
        {Rotation = 359}
    )
    GlobalMarketplace.EndLoad.Listen(function() -- Line: 3951 -- upvalues: u650 (upval), u657 (upval)
        u650.Parent.Parent.Loading.Visible = false
        u657:Pause()
    end)
    CloseButtonRegistry.Add(u650, nil, closeMarketplace)
    setupProfile()
    setupMarket()
    setupSell()
    Skins.ObserveItemStockSchemas(function(a1) -- Line: 3964
        -- upvalues: u623 (upval), u613 (upval), u615 (upval), GetWeaponProperties (upval), Skins (upval)
        local Class, Type, name_2, v1, v2, v3, v4, v5, v6
        u623 = {}
        local v7 = nil
        local v8 = nil
        for i, j in a1, v7, v8 do
            v5 = nil
            v6 = nil
            for k, n in j, v5, v6 do
                v1 = true
                if u613[n.name] ~= true then
                    v1 = u613[n.type] == true
                end
                if not v1 and not table.find(u615, n.skin) then
                    v1 = GetWeaponProperties(n.name)
                    if not v1 then
                        if Skins.IsSkinAvailable(n.name, n.skin) then
                            Type = if not v1 then n.type else v1.Type
                            if n.type == "Glove" then
                                Type = "Glove"
                            end
                            if n.rarity ~= "Stock" and Type then
                                v2 = u623
                                v3 = u623[Type] or {ALL = {}}
                                v2[Type] = v3
                                v2 = u623[Type]
                                name_2 = n.name
                                v4 = u623[Type][n.name] or {}
                                v2[name_2] = v4
                                v3 = u623[Type][n.name]
                                v4 = {
                                    HideWearDetails = true,
                                    ShowFullPriceRange = true,
                                    _id = ("index_%*_%*"):format(n.name, n.skin),
                                    Float = n.floatRange.min,
                                    Rarity = n.rarity,
                                    Name = n.name,
                                    Skin = n.skin,
                                }
                                Class = if not v1 then n.type else v1.Class
                                v4.Type = Class
                                table.insert(v3, v4)
                            end
                        end
                    elseif v1.Class ~= "Grenade" and Skins.IsSkinAvailable(n.name, n.skin) then
                        Type = if not v1 then n.type else v1.Type
                        if n.type == "Glove" then
                            Type = "Glove"
                        end
                        if n.rarity ~= "Stock" and Type then
                            v2 = u623
                            v3 = u623[Type] or {ALL = {}}
                            v2[Type] = v3
                            v2 = u623[Type]
                            name_2 = n.name
                            v4 = u623[Type][n.name] or {}
                            v2[name_2] = v4
                            v3 = u623[Type][n.name]
                            v4 = {
                                HideWearDetails = true,
                                ShowFullPriceRange = true,
                                _id = ("index_%*_%*"):format(n.name, n.skin),
                                Float = n.floatRange.min,
                                Rarity = n.rarity,
                                Name = n.name,
                                Skin = n.skin,
                            }
                            Class = if not v1 then n.type else v1.Class
                            v4.Type = Class
                            table.insert(v3, v4)
                        end
                    end
                end
            end
        end
    end)
    local Guns = u650.Market.Header.Guns
    for i, j in u650.Market.Header.Filters:GetChildren() do
        if j:IsA("TextButton") then
            j.ImageLabel.Rotation = 0
            j.Activated:Connect(function() -- Line: 4027
                -- upvalues: u624 (upval), j (val), MenuState (upval), Guns (val), hideQuickPick (upval)
                -- upvalues: GamepadNavigation (upval), u650 (upval), openQuickCategory (upval)
                if u624 ~= j.Name then
                    if openQuickCategory(j.Name) then
                        task.defer(function() -- Line: 4033 -- upvalues: Guns (upval), GamepadNavigation (upval)
                            if Guns.Visible then
                                GamepadNavigation.Focus(GamepadNavigation.FindFirstSelectable(Guns.Frame))
                            end
                        end)
                    end
                    return
                end
                local v1 = u624
                local v2 = MenuState.IsSelectionWithin(Guns)
                hideQuickPick()
                if v2 and v1 then
                    GamepadNavigation.Focus(u650.Market.Header.Filters:FindFirstChild(v1))
                    return
                end
            end)
        end
    end
    CloseButtonRegistry.Add(Guns, nil, function() -- Line: 4007
        -- upvalues: u624 (upval), MenuState (upval), Guns (val), hideQuickPick (upval), GamepadNavigation (upval)
        -- upvalues: u650 (upval)
        local v1 = u624
        local v2 = MenuState.IsSelectionWithin(Guns)
        hideQuickPick()
        if v2 and v1 then
            GamepadNavigation.Focus(u650.Market.Header.Filters:FindFirstChild(v1))
        end
    end)
    Guns.SelectionGroup = true
    Guns.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
    Guns.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
    Guns.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
    Guns.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
    MenuState.RegisterBumperOverride(Guns, function(a1) -- Line: 4054
        -- upvalues: u624 (upval), Guns (val), buildGuns (upval), GamepadNavigation (upval)
        local v1 = u624
        if not v1 then
            return false
        end
        local v2 = {}
        for i, j in Guns.TopSelect.Container:GetChildren() do
            if j:IsA("TextButton") and j.Visible then
                table.insert(v2, j)
            end
        end
        if #v2 == 0 then
            return false
        end
        table.sort(v2, function(a1, a2) -- Line: 4069
            return a1.AbsolutePosition.X < a2.AbsolutePosition.X
        end)
        local v3 = 1
        for k, n in v2 do
            if n.Frame.Visible then
                v3 = k
                break
            end
        end
        local v4 = v3 - 1
        local v5 = v2[(v4 + (if not a1 then 1 else -1)) % #v2 + 1]
        buildGuns(v1, v5.Name)
        Guns.Frame.CanvasPosition = Vector2.zero
        GamepadNavigation.Focus(v5)
        return true
    end, Guns)
    GlobalMarketplace.RequestProfileInfo.Send(LocalPlayer.UserId)
    local TextBox = u650.Market.Filters.Container.seller_id.Inputs.Id.TextBox
    TextBox.FocusLost:Connect(function() -- Line: 4091 -- upvalues: TextBox (val), u622 (upval)
        if tonumber(TextBox.Text) then
            u622.sellerUserId = tonumber(TextBox.Text)
            return
        end
        if u622.sellerUserId then
            u622.sellerUserId = nil
        end
        TextBox.Text = ""
    end)

    local function buildCollectionOptions(a1) -- Line: 4103 -- types: a1: table
        local v1 = {"All"}
        for i, j in a1 do
            if j.name ~= "First Edition" then
                table.insert(v1, j.name)
            end
        end
        return v1
    end

    local Container = u650.Market.Filters.Container
    local rarity_dropdown = Container:FindFirstChild("rarity_dropdown")
    local Dropdown_2 = rarity_dropdown and rarity_dropdown:FindFirstChild("Dropdown")
    if Dropdown_2 and Dropdown_2:IsA("GuiButton") then
        local v3 = {"All"}
        for k in Rarities do
            table.insert(v3, k)
        end
        table.sort(v3, function(a1, a2) -- Line: 4124
            if a1 == "All" then
                return true
            end
            if a2 == "All" then
                return false
            end
            return (a1:lower()) < a2:lower()
        end)
        local v4 = MarketplaceDropdown.new(Dropdown_2, v3)
        u625.rarity_dropdown = v4
        v4.OptionSelected:Connect(function(a1) -- Line: 4135 -- upvalues: u622 (upval)
            u622.rarity = if a1 == "All" then nil else a1
        end)
    end
    local Dropdown = Container.collection_dropdown.Dropdown
    if Dropdown and Dropdown:IsA("GuiButton") then
        local function applyCollectionOptionLayoutOrder(a1) -- Line: 4143 -- upvalues: Dropdown (val)
            local v1
            local Dropdown_2 = Dropdown:FindFirstChild("Dropdown")
            if not Dropdown_2 then
                return
            end
            for i, j in a1 do
                v1 = Dropdown_2:FindFirstChild(j.name)
                if v1 and v1:IsA("GuiObject") then
                    v1.LayoutOrder = tonumber(j.createdAt) or 0
                end
            end
        end

        local v5 = Collections.GetAllCollections()
        local u241 = MarketplaceDropdown.new(Dropdown, (buildCollectionOptions(v5)))
        u625.collection_dropdown = u241
        applyCollectionOptionLayoutOrder(v5)
        u241.OptionSelected:Connect(function(a1) -- Line: 4163 -- upvalues: u622 (upval)
            u622.Collection = not (a1 == "All") and a1 or nil
        end)
        Collections.ObserveAvailableCollections(function(a1) -- Line: 4167 -- upvalues: u241 (val), buildCollectionOptions (val), applyCollectionOptionLayoutOrder (val)
            u241:SetOptions((buildCollectionOptions(a1)))
            applyCollectionOptionLayoutOrder(a1)
        end)
    end
    for n, m in u650.Top.Frame:GetChildren() do
        if m:IsA("TextButton") then
            new_2 = MarketplaceButton.new
            v1 = {
                hoverSizeMultiplier = 0.9,
                onActivated = function() -- Line: 4181 -- upvalues: m (val), u634 (upval), u650 (upval), hideQuickPick (upval), u656 (upval)
                    local Name, v1
                    local v2 = nil
                    local v3 = nil
                    for i, j in u634, v2, v3 do
                        v1 = u650[j]
                        v1.Visible = j == m.Name
                    end
                    if Name ~= "Market" then
                        hideQuickPick()
                    end
                    if Name ~= "Sell" then
                        u650.Sell.Confirm.Visible = false
                        if u656 then
                            u656:Destroy()
                        end
                    end
                end,
            }
            new_2(m, v1)
        end
    end
    u650.Profile.Main.ProfileInfo.Search.SearchBox.FocusLost:Connect(function() -- Line: 4187 -- upvalues: u650 (upval), Players (upval), GlobalMarketplace (upval)
        local Text = u650.Profile.Main.ProfileInfo.Search.SearchBox.Text
        local v1 = tonumber(Text)
        if not v1 and Text ~= "" then
            local success, result = pcall(Players.GetUserIdFromNameAsync, Players, Text)
            if success and result then
                v1 = result
            end
        end
        u650.Profile.Main.ProfileInfo.Search.SearchBox.Text = if not v1 then "Search User..." else tostring(v1)
        if v1 then
            GlobalMarketplace.RequestProfileInfo.Send(v1)
        end
    end)
    local u281 = 3
    local u282 = ""
    local Pin = u650.Pin
    Pin.Active = false
    local u298 = Pin.SetupCode.Main.Wrap.Settings_List.Pin_Setup_Template.Main.Pin_Setup.Wrap.Pin_Holder["1"]:Clone()

    local function formatPin(a1, a2) -- Line: 4213 -- upvalues: u298 (val) -- types: a2: string
        local v1
        for i, j in a1:GetChildren() do
            if j:IsA("Frame") and j.Name ~= "Ghost_Template" then
                j:Destroy()
            end
        end
        local Ghost_Template = a1.Ghost_Template
        local v2 = false
        if 4 <= (a2:len()) then
            v2 = (a2:len()) < 8
        end
        Ghost_Template.Visible = v2
        for k = 1, (math.clamp(a2:len(), 4, 8)) do
            v1 = u298:Clone()
            v1.Slot_Filled.Visible = k <= a2:len()
            v1.Slot_Empty.Visible = not v1.Slot_Filled.Visible
            if v1.Slot_Filled.Visible then
                v1.Slot_Filled.TextLabel.Text = "*"
            end
            v1.Parent = v3
        end
    end

    local function submitPin() -- Line: 4235
        -- upvalues: u282 (ref), Remotes (upval), u281 (ref), Pin (val), formatPin (val)
        if not ((u282:len()) < 4) and not (8 < (u282:len())) then
            Remotes.PlayerData.SubmitPin.Send(u282)
            u281 = u281 - 1
            local v1 = u281
            Pin.InputCode.Wrap.Title.Text = ("Enter your PIN number (%* attempts left)"):format(v1)
            u282 = ""
            formatPin(Pin.InputCode.Wrap.Pin_Holder, u282)
            return
        end
    end

    ;(function() -- Line: 4248 -- upvalues: Pin (val), MarketplaceButton (upval), u282 (ref), formatPin (val), submitPin (val)
        local new_2, v1
        for i, j in Pin.InputCode.Wrap.Number_Pad:GetChildren() do
            if j:IsA("TextButton") and j.Name ~= "Submit" then
                new_2 = MarketplaceButton.new
                v1 = {
                    onActivated = function() -- Line: 4254 -- upvalues: j (val), u282 (upval), formatPin (upval), Pin (upval)
                        if j.Name ~= "Backspace" then
                            if j.Name ~= "Backspace" and (u282:len()) < 8 then
                                u282 = u282 .. j.Title.Text
                            end
                        elseif 0 < (u282:len()) then
                            u282 = u282:sub(1, #u282 - 1)
                        elseif j.Name ~= "Backspace" and (u282:len()) < 8 then
                            u282 = u282 .. j.Title.Text
                        end
                        formatPin(Pin.InputCode.Wrap.Pin_Holder, u282)
                    end,
                }
                new_2(j, v1)
            end
        end
        MarketplaceButton.new(Pin.InputCode.Wrap.Number_Pad.Submit, {onActivated = submitPin})
    end)()
    UserInputService.InputBegan:Connect(function(a1) -- Line: 4270
        -- upvalues: Pin (val), u612 (upval), u282 (ref), formatPin (val), submitPin (val)
        if not Pin.Visible then
            return
        end
        if not u612[a1.KeyCode] and a1.KeyCode ~= Enum.KeyCode.Backspace then
            if a1.KeyCode == Enum.KeyCode.Return then
                if Pin.InputCode.Visible then
                    submitPin()
                end
            elseif a1.KeyCode == Enum.KeyCode.KeypadEnter and Pin.InputCode.Visible then
                submitPin()
            end
            return
        end
        if Enum.KeyCode.Backspace == a1.KeyCode and 0 < (u282:len()) then
            u282 = u282:sub(1, #u282 - 1)
            formatPin(Pin.InputCode.Wrap.Pin_Holder, u282)
            return
        end
        if Enum.KeyCode.Backspace ~= a1.KeyCode and (u282:len()) < 8 then
            u282 = u282 .. u612[a1.KeyCode]
            formatPin(Pin.InputCode.Wrap.Pin_Holder, u282)
            return
        end
    end)
    local Visible = u650.Visible and LocalPlayer:GetAttribute("PinVerified") == false
    Pin.Visible = Visible
    ;(LocalPlayer:GetAttributeChangedSignal("PinVerified")):Connect(function() -- Line: 4289 -- upvalues: Pin (val), u650 (upval), LocalPlayer (upval)
        local Visible = u650.Visible and LocalPlayer:GetAttribute("PinVerified") == false
        Pin.Visible = Visible
    end)
    GamepadNavigation.TrapPopup(Pin)
    local v6 = u650
    MenuState.RegisterBumperOverride(v6, function(a1) -- Line: 4306
        -- upvalues: u650 (upval), Pin (val), u656 (upval), u634 (upval), hideQuickPick (upval)
        -- upvalues: GamepadNavigation (upval)
        local v1, v2, v3, v4, v5, v6, v7
        local Sell = u650.Sell
        if Pin.Visible then
            return true
        end
        if not Sell.Visible then
            v1 = 1
            for m, i5 in u634 do
                if u650[i5].Visible then
                    v1 = m
                    break
                end
            end
            v3 = u634
            v6 = v1 - 1
            v2 = v3[(v6 + (if not a1 then 1 else -1)) % #u634 + 1]
            v4 = nil
            v5 = nil
            for i6, i7 in u634, v4, v5 do
                v7 = u650[i7]
                v7.Visible = i7 == v2
            end
            if v2 ~= "Market" then
                hideQuickPick()
            end
            if v2 ~= "Sell" then
                u650.Sell.Confirm.Visible = false
                if u656 then
                    u656:Destroy()
                end
            end
            GamepadNavigation.Focus(u650.Top.Frame:FindFirstChild(v2))
            return true
        end
        if Sell.Confirm.Visible then
            return true
        end
        if u656 ~= nil and u656.Parent ~= nil then
            return true
        end
        v1 = 1
        for i, j in u634 do
            if u650[j].Visible then
                v1 = i
                break
            end
        end
        v3 = u634
        v6 = v1 - 1
        v2 = v3[(v6 + (if not a1 then 1 else -1)) % #u634 + 1]
        v4 = nil
        v5 = nil
        for k, n in u634, v4, v5 do
            v7 = u650[n]
            v7.Visible = n == v2
        end
        if v2 ~= "Market" then
            hideQuickPick()
        end
        if v2 ~= "Sell" then
            u650.Sell.Confirm.Visible = false
            if u656 then
                u656:Destroy()
            end
        end
        GamepadNavigation.Focus(u650.Top.Frame:FindFirstChild(v2))
        return true
    end, u650)
    for i5, i6 in u650:GetDescendants() do
        if i6:IsA("TextButton") then
            if i6.Name == "Search" then
                if i6:FindFirstChildWhichIsA("TextBox", true) then
                    i6.Selectable = false
                end
            elseif i6.Name == "Price" and i6:FindFirstChildWhichIsA("TextBox", true) then
                i6.Selectable = false
            end
        end
    end
    ;(u650:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 4343 -- upvalues: onVisibilityChanged (upval), u650 (upval)
        onVisibilityChanged(u650.Visible)
    end)
    MenuState.OnInspectStateChanged:Connect(function(a1) -- Line: 4351
        -- upvalues: u650 (upval), MenuState (upval), u646 (upval), u638 (upval), u636 (upval), hideQuickPick (upval)
        -- upvalues: u656 (upval)
        if a1 then
            return
        end
        task.defer(function() -- Line: 4355
            -- upvalues: u650 (upval), MenuState (upval), u646 (upval), u638 (upval), u636 (upval)
            -- upvalues: hideQuickPick (upval), u656 (upval)
            if not u650.Visible and not MenuState.IsInspectActive() then
                u646 = nil
                u638 = nil
                if u636 then
                    u636:Destroy()
                    u636 = nil
                end
                u650.Market.PurchaseMenu.Confirm.Visible = false
                u650.Market.PurchaseMenu.Visible = false
                u650.Market.Confirm.Visible = false
                hideQuickPick()
                u650.Sell.Confirm.Visible = false
                if u656 then
                    u656:Destroy()
                end
            end
        end)
    end)
    onVisibilityChanged(u650.Visible)
end

return v3