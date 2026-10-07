-- ReplicatedStorage.Interface.Screens.Menu.Blackmarket
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Blackmarket
-- Decompile time: 40.91 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local BlackMarketSceneController = require(ReplicatedStorage.Controllers.BlackMarketSceneController)
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local InspectController = require(ReplicatedStorage.Controllers.InspectController)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local BlackMarketDealer = Remotes.BlackMarketDealer
local u123 = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, (1 / 0))
local u124 = {
    [Enum.KeyCode.DPadUp] = true,
    [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true,
    [Enum.KeyCode.DPadRight] = true,
}
local u133 = {case = true, package = true, console = true}
local u138 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u143 = Color3.fromRGB(255, 244, 200)
local u148 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u153 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local u158 = TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local u159 = nil
local u160 = nil
local u161 = nil
local u162 = nil
local u163 = nil
local u164 = nil
local u165 = {}
local u166 = nil
local u167 = nil
local u168 = {}
local u169 = {}
local u170 = {}
local u171 = {}
local u172 = nil
local u173 = nil
local u174 = {}
local u176 = Random.new()
local u177 = nil
local u178 = false
local u179 = nil
local u180 = nil
local u181 = 0
local u182 = nil
local u183 = nil
local u184 = {}
local u185 = nil
local u186 = (-1 / 0)
local u187 = true
local u188 = false
local u189 = false
local u190 = false
local u191 = {}
local u192 = {}
local u193 = {}
local u194 = {}
local u195 = false
local u196 = false
local u197 = 0
local u198 = nil
local u199 = false

local function notify(a1) -- Line: 318 -- upvalues: Router (val) -- types: a1: string
    Router.broadcastRouter("CreateNotification", "Black Market", a1, 5)
end

local function isPointerBlocked() -- Line: 329 -- upvalues: u195 (ref), u196 (ref), GuiService (val)
    return u195 or u196 or GuiService.MenuIsOpen
end

local function setWaitingForDeal(a1) -- Line: 343
    -- upvalues: u161 (ref), u199 (ref), u163 (ref), u162 (ref)
    local v1 = u161
    if v1 and a1 ~= u199 then
        u199 = a1
        v1.Visible = a1
        local v2 = u163
        if not v2 then
            return
        end
        if a1 then
            v2:Play()
            return
        end
        if u162 then
            v2:Cancel()
            u162.Rotation = 0
        end
        return
    end
end

local function setNavigationVisible(a1) -- Line: 372 -- upvalues: u160 (ref) -- types: a1: boolean
    local v1
    local Top = u160 and u160:FindFirstChild("Top")
    if not Top then
        return
    end
    for i, v in ipairs({"Top", "Bottom"}) do
        v1 = Top:FindFirstChild(v)
        if v1 and v1:IsA("GuiObject") then
            v1.Visible = a1
        end
    end
end

local function escapeRichText(a1) -- Line: 389 -- types: a1: string
    return (((a1:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;"))
end

local function getRarityColor(a1) -- Line: 395 -- upvalues: Rarities (val) -- types: a1: string?
    local v1 = a1 and Rarities[a1]
    return v1 and v1.Color or Rarities.Stock.Color
end

local function formatCountdown(a1) -- Line: 402 -- types: a1: number
    local v1 = math.max(math.floor(a1), 0)
    return string.format("%02d:%02d:%02d", v1 // 3600, v1 % 3600 // 60, v1 % 60)
end

local function canInspectCard(a1) -- Line: 414 -- upvalues: u133 (val), Skins (val)
    if not u133[tostring(a1.offerKind)] and typeof(a1.float) == "number" then
        return Skins.GetSkinInformation(a1.name, a1.skin) ~= nil
    end
    return false
end

local function isCardPurchased(a1) -- Line: 432 -- upvalues: u192 (val), u179 (ref)
    if u192[tostring(a1.cardId)] then
        return true
    end
    local v1 = false
    if typeof(u179) == "table" then
        v1 = u179.buyEnabled == false
    end
    v1 = not v1 and a1.status ~= "available"
    return v1
end

local function toPreviewItem(a1) -- Line: 448 -- upvalues: LocalPlayer (val)
    return {
        Serial = 0,
        IsTradeable = true,
        NameTag = false,
        Charm = false,
        _id = a1.cardId,
        Type = a1.type,
        Name = a1.name,
        Skin = a1.skin,
        Rarity = a1.rarity,
        Float = a1.float,
        StatTrack = if not a1.isStattrak then false else 0,
        Stickers = {},
        MetaData = {
            LastTradeAt = 0,
            Origin = "Other",
            Owner = LocalPlayer.UserId,
            OriginalOwner = LocalPlayer.UserId,
            CreatedAt = os.time(),
            TradeHistory = {},
        },
    }
end

local function resolveCardImage(a1, a2, a3) -- Line: 484 -- upvalues: Skins (val), Cases (val) -- types: a3: boolean
    if a2 then
        return a3 and Skins.GetWearImageForFloat(a2, a1.float) or nil or a2.imageAssetId or ""
    end
    local v1 = Cases.GetCaseByName(a1.skin)
    return v1 and v1.imageAssetId or ""
end

local function tintCard(a1, a2) -- Line: 496 -- upvalues: Rarities (val) -- types: a1: userdata, a2: string?
    local v1 = a2 and Rarities[a2]
    local Color = v1 and v1.Color or Rarities.Stock.Color
    local BG = a1:FindFirstChild("BG")
    if BG and BG:IsA("ImageLabel") then
        BG.ImageColor3 = Color
    end
    local Pattern = a1:FindFirstChild("Pattern")
    if Pattern and Pattern:IsA("ImageLabel") then
        Pattern.ImageColor3 = Color
    end
    local Effects = a1:FindFirstChild("Effects")
    local Effect = Effects and Effects:FindFirstChild("Effect")
    if Effect and Effect:IsA("ImageLabel") then
        Effect.ImageColor3 = Color
    end
    local ItemTemplate = a1:FindFirstChild("ItemTemplate")
    if not ItemTemplate then
        return
    end
    local UIShadow = ItemTemplate:FindFirstChildOfClass("UIShadow")
    if UIShadow then
        UIShadow.Color = Color
    end
    local Glow = ItemTemplate:FindFirstChild("Glow")
    if Glow and Glow:IsA("ImageLabel") then
        Glow.ImageColor3 = Color
    end
    local ItemContent = ItemTemplate:FindFirstChild("ItemContent")
    local Content = ItemContent and ItemContent:FindFirstChild("Content")
    local Rarity = Content and Content:FindFirstChild("Rarity")
    if Rarity and Rarity:IsA("ImageLabel") then
        Rarity.ImageColor3 = Color
    end
end

local function renderSlot(a1, a2) -- Line: 540
    -- upvalues: BlackMarketSceneController (val), Skins (val), u133 (val), tintCard (val), Cases (val)
    -- upvalues: GetSkinDisplayName (val), CommaNumber (val), u179 (ref), u192 (val), u193 (val)
    local v1, v2, v3
    a1.Card = a2
    if not a2 then
        BlackMarketSceneController.SetCardVisible(a1.Part, false)
        return
    end
    BlackMarketSceneController.SetCardVisible(a1.Part, true)
    local Back = a1.Back
    local v4 = Skins.GetSkinInformation(a2.name, a2.skin)
    local v5 = not u133[tostring(a2.offerKind)] and typeof(a2.float) == "number"
    tintCard(Back, a2.rarity)
    local ItemTemplate = Back:FindFirstChild("ItemTemplate")
    local ItemContent = ItemTemplate and ItemTemplate:FindFirstChild("ItemContent")
    local Content = ItemContent and ItemContent:FindFirstChild("Content")
    local Icon = Content and Content:FindFirstChild("Icon")
    if Icon and Icon:IsA("ImageLabel") then
        local imageAssetId
        if not v4 then
            local v6 = Cases.GetCaseByName(a2.skin)
            imageAssetId = v6 and v6.imageAssetId or ""
        else
            imageAssetId = v5 and Skins.GetWearImageForFloat(v4, a2.float) or nil or v4.imageAssetId or ""
        end
        Icon.Image = imageAssetId
    end
    local Inspect = ItemContent and ItemContent:FindFirstChild("Inspect")
    if Inspect and Inspect:IsA("GuiObject") then
        Inspect.Visible = if u133[tostring(a2.offerKind)] then false else if typeof(a2.float) == "number" then Skins.GetSkinInformation(a2.name, a2.skin) ~= nil else false
    end
    local Bottom = Back:FindFirstChild("Bottom")
    if Bottom then
        local v7
        local Skin = Bottom:FindFirstChild("Skin")
        if Skin and Skin:IsA("TextLabel") then
            local name = GetSkinDisplayName.GetFullItemDisplayName(a2.name, a2.skin, false, true)
            if name == "" then
                v1 = Cases.GetCaseByName(a2.skin)
                name = if not v1 then ("%* | %*"):format(GetSkinDisplayName.GetWeaponDisplayName(a2.name), (GetSkinDisplayName.GetSkinDisplayName(a2.skin, true))) else v1.name
            end
            Skin.RichText = true
            v1 = ((name:gsub("&", "&amp;")):gsub("<", "&lt;")):gsub(">", "&gt;")
            if a2.isStattrak then
                v1 = ("<font color=\"rgb(255,132,32)\">KillTrak™</font> %*"):format(v1)
            end
            Skin.Text = v1
        end
        local RAP = Bottom:FindFirstChild("RAP")
        if RAP and RAP:IsA("TextLabel") then
            RAP.Text = ("RAP: %*"):format((CommaNumber((math.floor((tonumber(a2.rapPrice)) or 0)))))
        end
        local FloatNumber = Bottom:FindFirstChild("FloatNumber")
        if FloatNumber and FloatNumber:IsA("TextLabel") then
            FloatNumber.Visible = true
            FloatNumber.Text = if not v5 then "" else string.format("%.13f", a2.float)
        end
        if RAP and FloatNumber then
            RAP.LayoutOrder = if not v5 then 1 else 3
            FloatNumber.LayoutOrder = if not v5 then 3 else 1
        end
        v3 = false
        if typeof(u179) == "table" then
            v3 = u179.buyEnabled == false
        end
        v2 = not v3
        v3 = false
        if a2.status == "available" then
            v3 = v2
        end
        local v8 = u192
        if not v8[tostring(a2.cardId)] then
            v8 = false
            if typeof(u179) == "table" then
                v8 = u179.buyEnabled == false
            end
            v7 = not v8 and a2.status ~= "available"
        else
            v7 = true
        end
        local Interact = Bottom:FindFirstChild("Interact")
        local Buy = Interact and Interact:FindFirstChild("Buy")
        local Amount = Buy and Buy:FindFirstChild("Amount")
        if Amount and Amount:IsA("TextLabel") then
            Amount.Text = if not v7 then ("BUY (%*)"):format((CommaNumber((math.floor((tonumber(a2.price)) or 0))))) else "PURCHASED"
        end
        local Decline = Interact and Interact:FindFirstChild("Decline")
        if Decline and Decline:IsA("GuiObject") then
            Decline.Visible = false
        end
        local BuyWideLayout = a1.BuyWideLayout
        if Buy and Buy:IsA("GuiObject") then
            if BuyWideLayout then
                Buy.Position = BuyWideLayout.Position
                Buy.Size = BuyWideLayout.Size
            end
            Buy.Visible = v3 or v7
        end
    end
    local Discount = Back:FindFirstChild("Discount")
    local Title = Discount and Discount:FindFirstChild("Title")
    v1 = tonumber(a2.discount) or 0
    if Discount and Discount:IsA("GuiObject") then
        Discount.Visible = v1 > 0
    end
    if Title and Title:IsA("TextLabel") then
        Title.Text = ("- %*%%"):format((math.floor(v1 * 100 + 0.5)))
    end
    v2 = u193[tostring(a2.cardId)]
    if v2 == nil then
        local v9 = u192
        if not v9[tostring(a2.cardId)] then
            v9 = false
            if typeof(u179) == "table" then
                v9 = u179.buyEnabled == false
            end
            v3 = not v9 and a2.status ~= "available"
        else
            v3 = true
        end
        if v3 then
            v2 = true
        end
    end
    if v2 ~= nil then
        BlackMarketSceneController.SetCardFaceUp(a1.Part, v2, false)
    end
end

local function updateCountdown() -- Line: 682 -- upvalues: u180 (ref), u182 (ref), u159 (ref), u165 (val)
    local Card, TextLabel
    local v1 = u180
    if not v1 then
        return
    end
    local v2 = math.max(math.floor(v1 - (os.clock())), 0)
    local v3 = string.format("%02d:%02d:%02d", v2 // 3600, v2 % 3600 // 60, v2 % 60)
    if v3 == u182 then
        return
    end
    u182 = v3
    local Title = u159:FindFirstChild("Title")
    if Title and Title:IsA("TextLabel") then
        Title.Text = ("<font color=\"rgb(255,223,0)\">%*</font> LEFT"):format(v3)
    end
    local v4 = nil
    local v5 = nil
    for i, j in u165, v4, v5 do
        Card = j.Card and j.Back:FindFirstChild("Expires")
        TextLabel = Card and Card:FindFirstChild("TextLabel")
        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = ("<font color=\"rgb(167,167,167)\">EXPIRES IN</font> <font color=\"rgb(255,255,255)\">%*</font>"):format(v3)
        end
    end
end

local function setDealDeadline(a1) -- Line: 722 -- upvalues: u180 (ref), u182 (ref)
    local v1 = typeof(a1) == "table" and tonumber(a1.msRemaining) or nil
    u180 = if not v1 then nil else os.clock() + v1 / 1000
    u182 = nil
end

local function preloadCardArt() -- Line: 735 -- upvalues: u165 (val), ContentProvider (val)
    local Content, Icon, ItemContent, ItemTemplate
    local u47 = {}
    local v1 = nil
    local v2 = nil
    for i, j in u165, v1, v2 do
        ItemTemplate = j.Back:FindFirstChild("ItemTemplate")
        ItemContent = ItemTemplate and ItemTemplate:FindFirstChild("ItemContent")
        Content = ItemContent and ItemContent:FindFirstChild("Content")
        Icon = Content and Content:FindFirstChild("Icon")
        if Icon and Icon:IsA("ImageLabel") and Icon.Image ~= "" then
            table.insert(u47, Icon)
        end
    end
    if #u47 > 0 then
        task.spawn(function() -- Line: 748 -- upvalues: ContentProvider (upval), u47 (val)
            ContentProvider:PreloadAsync(u47)
        end)
    end
end

local function dealSignature(a1) -- Line: 761
    if typeof(a1) == "table" and typeof(a1.cards) == "table" then
        local cardId
        local v1 = {}
        local v2 = nil
        local v3 = nil
        for i, j in a1.cards, v2, v3 do
            cardId = not (typeof(j) ~= "table") and j.cardId or ""
            v1[i] = (tostring(cardId))
        end
        return table.concat(v1, "|")
    end
    return ""
end

local function renderDeal(a1) -- Line: 775
    -- upvalues: u179 (ref), u165 (val), renderSlot (val), BlackMarketSceneController (val), preloadCardArt (val)
    -- upvalues: u182 (ref), updateCountdown (val)
    u179 = a1
    local cards_2 = typeof(a1) == "table" and not (typeof(a1.cards) ~= "table") and a1.cards or {}
    for i, j in u165 do
        renderSlot(j, cards_2[i])
    end
    BlackMarketSceneController.NotifyDealRendered()
    preloadCardArt()
    u182 = nil
    updateCountdown()
end

local function requestDeal() -- Line: 802 -- upvalues: u180 (ref), u186 (ref), BlackMarketDealer (val)
    local v1 = u180
    if v1 and 0 < v1 - os.clock() then
        return
    end
    local v2 = os.clock()
    if v2 - u186 < 10 then
        return
    end
    u186 = v2
    BlackMarketDealer.RequestDeal.Send()
end

local function regionRect(a1) -- Line: 827 -- types: a1: table
    local Element = a1.Element
    local AbsolutePosition = Element.AbsolutePosition
    local AbsoluteSize = Element.AbsoluteSize
    local Scale = a1.Scale.Scale
    if not (Scale <= 0) and not (Scale >= 1) then
        local AnchorPoint = Element.AnchorPoint
        local v1 = AbsoluteSize / Scale
        return AbsolutePosition + AbsoluteSize * AnchorPoint - v1 * AnchorPoint, v1
    end
    return AbsolutePosition, AbsoluteSize
end

local function regionBounds(a1, a2) -- Line: 847 -- types: a1: table, a2: table
    local AbsoluteSize = a1.Back.AbsoluteSize
    if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
        local v1, v2
        local Element = a2.Element
        local AbsolutePosition = Element.AbsolutePosition
        local AbsoluteSize_2 = Element.AbsoluteSize
        local Scale = a2.Scale.Scale
        if Scale <= 0 then
            v1 = AbsolutePosition
            v2 = AbsoluteSize_2
        elseif not (Scale >= 1) then
            local AnchorPoint = Element.AnchorPoint
            local v3 = AbsoluteSize_2 / Scale
            v1 = AbsolutePosition + AbsoluteSize_2 * AnchorPoint - v3 * AnchorPoint
            v2 = v3
        else
            v1 = AbsolutePosition
            v2 = AbsoluteSize_2
        end
        local v4 = v1 - a1.Back.AbsolutePosition
        return v4 / AbsoluteSize, (v4 + v2) / AbsoluteSize
    end
    return nil, nil
end

local function isRegionVisible(a1, a2) -- Line: 861 -- types: a1: userdata, a2: userdata
    local Parent = a1
    while Parent do
        if Parent == a2 then
            break
        end
        if Parent:IsA("GuiObject") and not Parent.Visible then
            return false
        end
        Parent = Parent.Parent
    end
    return true
end

local function projectCardRect(a1, a2, a3, a4) -- Line: 892
    -- upvalues: 
    local X, Y, v1, v2, v3
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return nil, nil, false
    end
    local Size = a1.Size
    local v4 = (1 / 0)
    local v5 = (1 / 0)
    local v6 = (-1 / 0)
    local v7 = (-1 / 0)
    local X_4 = 0
    local X_5 = 0
    for i = 1, 4 do
        v1 = true
        if i ~= 2 then
            v1 = i == 3
        end
        v2 = true
        if i ~= 3 then
            v2 = i == 4
        end
        X = if not v1 then v8.X else v9.X
        Y = if not v2 then v8.Y else v9.Y
        v3 = CurrentCamera:WorldToViewportPoint((a1.CFrame:PointToWorldSpace((Vector3.new((if not v10 then X - 0.5 else 0.5 - X) * Size.X, (0.5 - Y) * Size.Y, 0)))))
        if v3.Z <= 0 then
            return nil, nil, false
        end
        v4 = math.min(v4, v3.X)
        v6 = math.max(v6, v3.X)
        v5 = math.min(v5, v3.Y)
        v7 = math.max(v7, v3.Y)
        if i == 1 then
            X_4 = v3.X
        elseif i == 2 then
            X_5 = v3.X
        end
    end
    return (Vector2.new(v4, v5)), (Vector2.new(v6 - v4, v7 - v5)), X_4 < X_5
end

local function setHoveredRegion(a1) -- Line: 943 -- upvalues: u185 (ref), Router (val) -- types: a1: table?
    if u185 == a1 then
        return
    end
    local v1 = u185
    u185 = a1
    if v1 then
        v1.HoverOut:Play()
    end
    if a1 then
        a1.HoverIn:Play()
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
    end
end

local function clearCardHover() -- Line: 964 -- upvalues: u165 (val), u185 (ref)
    local FlipRegion

    local function rest(a1) -- Line: 965 -- types: a1: table
        a1.HoverIn:Cancel()
        a1.HoverOut:Cancel()
        a1.Press:Cancel()
        a1.Scale.Scale = 1
    end

    local v1 = nil
    local v2 = nil
    for i, j in u165, v1, v2 do
        for k, n in j.Regions do
            n.HoverIn:Cancel()
            n.HoverOut:Cancel()
            n.Press:Cancel()
            n.Scale.Scale = 1
        end
        if j.FlipRegion then
            FlipRegion = j.FlipRegion
            FlipRegion.HoverIn:Cancel()
            FlipRegion.HoverOut:Cancel()
            FlipRegion.Press:Cancel()
            FlipRegion.Scale.Scale = 1
        end
    end
    u185 = nil
end

local function pressRegion(a1) -- Line: 993 -- upvalues: u185 (ref) -- types: a1: table
    a1.Press:Play()
    task.delay(0.15, function() -- Line: 995 -- upvalues: u185 (upval), a1 (val)
        if u185 == a1 then
            a1.HoverIn:Play()
            return
        end
        a1.HoverOut:Play()
    end)
end

local function isCardDiscontinued(a1) -- Line: 1011 -- upvalues: Cases (val)
    if typeof(a1) ~= "table" then
        return false
    end
    local v1 = Cases.GetCaseByName(a1.skin)
    if not v1 then
        return false
    end
    return not Cases.IsCaseForSale(v1.caseId)
end

local function flipCardUp(a1) -- Line: 1027
    -- upvalues: BlackMarketSceneController (val), u194 (val), Cases (val)
    BlackMarketSceneController.SetCardFaceUp(a1.Part, true, true)
    local v1 = tostring(a1.Card.cardId)
    if BlackMarketSceneController.IsCardFaceUp(a1.Part) and not u194[v1] then
        local v2
        u194[v1] = true
        local Card_2 = a1.Card
        if typeof(Card_2) == "table" then
            local v3 = Cases.GetCaseByName(Card_2.skin)
            v2 = if v3 then not Cases.IsCaseForSale(v3.caseId) else false
        else
            v2 = false
        end
        if v2 then
            BlackMarketSceneController.PlayDiscontinuedLine()
            return
        end
        BlackMarketSceneController.PlayRarityLine(a1.Card.rarity)
        return
    end
end

local function promptRefresh() -- Line: 1052
    -- upvalues: u195 (ref), u196 (ref), DevProducts (val), Router (val), u179 (ref), u185 (ref)
    -- upvalues: MarketplaceService (val), LocalPlayer (val)
    if not u195 and not u196 then
        local v1 = DevProducts["Black Market Refresh"]
        if v1 and v1.DevProductId and 0 < v1.DevProductId then
            if u179 and u179.refreshEnabled == false then
                Router.broadcastRouter("CreateNotification", "Black Market", "The dealer is not taking refreshes right now.", 5)
                return
            end
            u195 = true
            if u185 ~= nil then
                local v2 = u185
                u185 = nil
                if v2 then
                    v2.HoverOut:Play()
                end
            end
            MarketplaceService:PromptProductPurchase(LocalPlayer, v1.DevProductId)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            return
        end
        Router.broadcastRouter("CreateNotification", "Black Market", "Refreshing the deal is not available yet.", 5)
        return
    end
end

local function ensureTargetLayer() -- Line: 1089
    -- upvalues: u167 (ref), LocalPlayer (val), u159 (ref), GamepadNavigation (val), u166 (ref)
    if u167 then
        return u167
    end
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not PlayerGui then
        return nil
    end
    local v1 = u159:FindFirstAncestorWhichIsA("ScreenGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlackmarketCardTargets"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = (if not v1 then 0 else v1.DisplayOrder) - 1
    ScreenGui.Enabled = false
    ScreenGui:SetAttribute(GamepadNavigation.NO_FALLBACK_ATTRIBUTE, true)
    ScreenGui.Parent = PlayerGui
    local Frame = Instance.new("Frame")
    Frame.Name = "Targets"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = ScreenGui
    u166 = ScreenGui
    u167 = Frame
    return Frame
end

local function isCanvasMirrored(a1) -- Line: 1133 -- types: a1: userdata
    local v1 = a1:FindFirstAncestorOfClass("SurfaceGui")
    local v2 = false
    if v1 ~= nil then
        v2 = v1.Face == Enum.NormalId.Front
    end
    return v2
end

local function getPressPoint(a1, a2) -- Line: 1147
    -- upvalues: GuiService (val), UserInputService (val)
    if not a2 then
        if not a2 and UserInputService.MouseEnabled then
            return UserInputService:GetMouseLocation()
        end
        return a1.AbsolutePosition + a1.AbsoluteSize / 2
    end
    if a2.UserInputType ~= Enum.UserInputType.MouseButton1 and a2.UserInputType ~= Enum.UserInputType.Touch then
        if not a2 and UserInputService.MouseEnabled then
            return UserInputService:GetMouseLocation()
        end
        return a1.AbsolutePosition + a1.AbsoluteSize / 2
    end
    return (Vector2.new(a2.Position.X, a2.Position.Y)) + GuiService:GetGuiInset()
end

local function createCircle(a1, a2) -- Line: 1162 -- types: a1: userdata, a2: string
    local Frame = Instance.new("Frame")
    Frame.Name = a2
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame
    Frame.Parent = a1
    return Frame
end

local function createFlipBurst(a1) -- Line: 1187
    -- upvalues: createCircle (val), TweenService (val), u148 (val), u153 (val), u176 (val), u158 (val)
    local Frame_2, UICorner, UIGradient, v1, v2, v3, v4, v5, v6
    local Frame = Instance.new("Frame")
    Frame.Name = "FlipBurst"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 5
    Frame.Visible = false
    local v7 = createCircle(Frame, "Flash")
    v7.BackgroundColor3 = Color3.new(1, 1, 1)
    local v8 = createCircle(Frame, "Ring")
    v8.BackgroundTransparency = 1
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = v8
    local v9 = {
        TweenService:Create(v7, u148, {BackgroundTransparency = 1, Size = UDim2.fromScale(0.4, 0.4)}),
        (TweenService:Create(v8, u153, {Size = UDim2.fromScale(1, 1)})),
    }
    local v10 = TweenService:Create(UIStroke, u153, {Thickness = 0, Transparency = 1})
    table.insert(v9, v10)
    local v11 = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.6, 0.15),
        (NumberSequenceKeypoint.new(1, 0)),
    })
    local v12 = {}
    for i = 1, 10 do
        v1 = i / 10 * 3.141592653589793 * 2 + u176:NextNumber(-0.25, 0.25)
        v2 = Vector2.new(math.cos(v1), (math.sin(v1)))
        v3 = u176:NextNumber(0.9, 1.5) / 2
        v4 = u176:NextNumber(0.35, 0.6) / 2
        Frame_2 = Instance.new("Frame")
        Frame_2.Name = "Streak"
        Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame_2.BorderSizePixel = 0
        Frame_2.Rotation = math.deg(v1)
        UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame_2
        UIGradient = Instance.new("UIGradient")
        UIGradient.Transparency = v11
        UIGradient.Parent = Frame_2
        Frame_2.Parent = Frame
        v5 = v2 * 0.1
        v6 = v2 * v3
        table.insert(v12, {
            Frame = Frame_2,
            Start = UDim2.fromScale(0.5 + v5.X, 0.5 + v5.Y),
            StartSize = UDim2.fromScale(v4, 0.03),
        })
        table.insert(v9, (TweenService:Create(Frame_2, u158, {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5 + v6.X, 0.5 + v6.Y),
            Size = UDim2.fromScale(v4 * 0.15, 0.015),
        })))
    end
    local v13 = TweenService:Create(UIStroke, u153, {Transparency = 1})
    local u196 = {
        IsBusy = false,
        Holder = Frame,
        Flash = v7,
        Ring = v8,
        RingStroke = UIStroke,
        Streaks = v12,
        Tweens = v9,
        FadeTween = v13,
    }

    local function release() -- Line: 1273 -- upvalues: Frame (val), u196 (val)
        Frame.Visible = false
        u196.IsBusy = false
    end

    v10.Completed:Connect(release)
    v13.Completed:Connect(release)
    Frame.Parent = a1
    return u196
end

local function acquireFlipBurst(a1) -- Line: 1287 -- upvalues: u174 (val), createFlipBurst (val) -- types: a1: userdata
    for i, j in u174 do
        if not j.IsBusy then
            return j
        end
    end
    local v1 = createFlipBurst(a1)
    table.insert(u174, v1)
    return v1
end

local function playFlipBurst(a1, a2, a3, a4) -- Line: 1307
    -- upvalues: u167 (ref), u174 (val), createFlipBurst (val), u176 (val)
    local Holder, RingStroke, v1, v2, v3
    local v4 = u167
    if not v4 then
        return
    end
    for i, j in u174 do
        if not j.IsBusy then
            j.IsBusy = true
            Holder = v2.Holder
            Holder.Position = UDim2.fromOffset(a1.X, a1.Y)
            Holder.Size = UDim2.fromOffset(a2 * 2, a2 * 2)
            Holder.Rotation = if not a4 then u176:NextNumber(0, 360) else 0
            RingStroke = v2.RingStroke
            RingStroke.Transparency = 0
            v2.Flash.Visible = not a4
            for k, n in v2.Streaks do
                n.Frame.Visible = not a4
            end
            if a4 then
                v2.Ring.Size = UDim2.fromScale(0.6, 0.6)
                RingStroke.Color = a3
                RingStroke.Thickness = 2
                Holder.Visible = true
                v2.FadeTween:Play()
                return
            end
            v2.Flash.Size = UDim2.fromScale(0.125, 0.125)
            v2.Flash.BackgroundTransparency = 0.05
            v2.Ring.Size = UDim2.fromScale(0.15, 0.15)
            RingStroke.Color = a3:Lerp(Color3.new(1, 1, 1), 0.25)
            RingStroke.Thickness = math.max(a2 * 0.09, 2)
            v3 = nil
            v1 = nil
            for m, i5 in v2.Streaks, v3, v1 do
                i5.Frame.Position = i5.Start
                i5.Frame.Size = i5.StartSize
                i5.Frame.BackgroundTransparency = 0
                i5.Frame.BackgroundColor3 = if m % 2 ~= 0 then a3 else Color3.new(1, 1, 1)
            end
            Holder.Visible = true
            for i6, i7 in v2.Tweens do
                i7:Play()
            end
            return
        end
    end
    local v5 = createFlipBurst(v4)
    table.insert(u174, v5)
    v5.IsBusy = true
    Holder = v2.Holder
    Holder.Position = UDim2.fromOffset(a1.X, a1.Y)
    Holder.Size = UDim2.fromOffset(a2 * 2, a2 * 2)
    Holder.Rotation = if not a4 then u176:NextNumber(0, 360) else 0
    RingStroke = v2.RingStroke
    RingStroke.Transparency = 0
    v2.Flash.Visible = not a4
    for i8, i9 in v2.Streaks do
        i9.Frame.Visible = not a4
    end
    if a4 then
        v2.Ring.Size = UDim2.fromScale(0.6, 0.6)
        RingStroke.Color = a3
        RingStroke.Thickness = 2
        Holder.Visible = true
        v2.FadeTween:Play()
        return
    end
    v2.Flash.Size = UDim2.fromScale(0.125, 0.125)
    v2.Flash.BackgroundTransparency = 0.05
    v2.Ring.Size = UDim2.fromScale(0.15, 0.15)
    RingStroke.Color = a3:Lerp(Color3.new(1, 1, 1), 0.25)
    RingStroke.Thickness = math.max(a2 * 0.09, 2)
    v3 = nil
    v1 = nil
    for i10, i11 in v2.Streaks, v3, v1 do
        i11.Frame.Position = i11.Start
        i11.Frame.Size = i11.StartSize
        i11.Frame.BackgroundTransparency = 0
        i11.Frame.BackgroundColor3 = if i10 % 2 ~= 0 then a3 else Color3.new(1, 1, 1)
    end
    Holder.Visible = true
    for i12, i13 in v2.Tweens do
        i13:Play()
    end
end

local function getCardPointUnder(a1, a2) -- Line: 1360 -- types: a1: userdata, a2: userdata
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return a1.Position
    end
    local v1 = CurrentCamera:ViewportPointToRay(a2.X, a2.Y)
    local LookVector = a1.CFrame.LookVector
    local v2 = v1.Direction:Dot(LookVector)
    if (math.abs(v2)) < 0.001 then
        return a1.Position
    end
    return v1.Origin + v1.Direction * (((a1.Position - v1.Origin):Dot(LookVector)) / v2)
end

local function playFlipEffect(a1, a2, a3) -- Line: 1384
    -- upvalues: Rarities (val), getPressPoint (val), GuiService (val), playFlipBurst (val), getCardPointUnder (val)
    local Card = a1.Card and a1.Card.rarity
    local v1 = Card and Rarities[Card]
    local Color = v1 and v1.Color or Rarities.Stock.Color
    local v2 = getPressPoint(a2, a3)
    v1 = math.clamp(a2.AbsoluteSize.Y * 0.28, 36, 110)
    local ReducedMotionEnabled = GuiService.ReducedMotionEnabled
    playFlipBurst(v2, v1, Color, ReducedMotionEnabled)
    if ReducedMotionEnabled then
        return
    end
    local Sparkles = a1.Sparkles
    local Parent = Sparkles and Sparkles.Parent
    if not Sparkles or not Parent or not Parent:IsA("Attachment") or not Parent.Parent then
        local v3 = a1.Part.Size.Y * 0.075
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "FlipSparkleOrigin"
        Attachment.Parent = a1.Part
        Parent = Attachment
        Sparkles = Instance.new("ParticleEmitter")
        Sparkles.Name = "FlipSparkles"
        Sparkles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        Sparkles.Rate = 0
        Sparkles.Lifetime = NumberRange.new(0.35, 0.7)
        Sparkles.Speed = NumberRange.new(a1.Part.Size.Y * 1.2, a1.Part.Size.Y * 2.4)
        Sparkles.SpreadAngle = Vector2.new(180, 180)
        Sparkles.Drag = 6
        Sparkles.Rotation = NumberRange.new(0, 360)
        Sparkles.RotSpeed = NumberRange.new(-240, 240)
        Sparkles.LightEmission = 1
        Sparkles.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v3),
            NumberSequenceKeypoint.new(0.25, v3 * 1.2),
            (NumberSequenceKeypoint.new(1, 0)),
        })
        Sparkles.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.7, 0.2),
            (NumberSequenceKeypoint.new(1, 1)),
        })
        Sparkles.Parent = Attachment
        a1.Sparkles = Sparkles
    end
    if Parent and Parent:IsA("Attachment") then
        Parent.WorldPosition = getCardPointUnder(a1.Part, v2)
    end
    Sparkles.Color = ColorSequence.new(Color3.new(1, 1, 1), Color)
    Sparkles:Emit(14)
end

local function createTarget(a1, a2, a3, a4) -- Line: 1454
    -- upvalues: ensureTargetLayer (val), BlackMarketSceneController (val), u185 (ref), Router (val), u195 (ref)
    -- upvalues: u196 (ref), GuiService (val), playFlipEffect (val), u168 (val)
    local v1 = ensureTargetLayer()
    if not v1 then
        return
    end
    local ImageButton = Instance.new("ImageButton")
    ImageButton.Name = a4
    ImageButton.BackgroundTransparency = 1
    ImageButton.ImageTransparency = 1
    ImageButton.AutoButtonColor = false
    ImageButton.AnchorPoint = Vector2.zero
    ImageButton.ZIndex = if not a3 then 1 else 0
    ImageButton.Visible = false
    ImageButton.Parent = v1

    local function hover() -- Line: 1474
        -- upvalues: a3 (val), BlackMarketSceneController (upval), a1 (val), a2 (val), u185 (upval), Router (upval)
        if a3 and BlackMarketSceneController.IsCardFaceUp(a1.Part) then
            return
        end
        local v1 = a2
        if u185 == v1 then
            return
        end
        local v2 = u185
        u185 = v1
        if v2 then
            v2.HoverOut:Play()
        end
        if v1 then
            v1.HoverIn:Play()
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
        end
    end

    ImageButton.MouseEnter:Connect(hover)
    ImageButton.SelectionGained:Connect(hover)

    local function release() -- Line: 1483 -- upvalues: u185 (upval), a2 (val)
        if u185 == a2 then
            if u185 == nil then
                return
            end
            local v1 = u185
            u185 = nil
            if v1 then
                v1.HoverOut:Play()
            end
        end
    end

    ImageButton.MouseLeave:Connect(release)
    ImageButton.SelectionLost:Connect(release)
    ImageButton.Activated:Connect(function(a1_2) -- Line: 1492
        -- upvalues: u195 (upval), u196 (upval), GuiService (upval), Router (upval), a2 (val), u185 (upval), a3 (val)
        -- upvalues: playFlipEffect (upval), a1 (val), ImageButton (val)
        if u195 or u196 or GuiService.MenuIsOpen then
            return
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        local u11 = a2
        u11.Press:Play()
        task.delay(0.15, function() -- Line: 995 -- upvalues: u185 (upval), u11 (val)
            if u185 == u11 then
                u11.HoverIn:Play()
                return
            end
            u11.HoverOut:Play()
        end)
        if a3 then
            playFlipEffect(a1, ImageButton, a1_2)
        end
        a2.Activate()
    end)
    local v2 = {Button = ImageButton, Slot = a1, Region = a2, IsFlip = a3}
    local v3 = (if not a3 then a1.Back else a1.Front):FindFirstAncestorOfClass("SurfaceGui")
    local v4 = false
    if v3 ~= nil then
        v4 = v3.Face == Enum.NormalId.Front
    end
    v2.IsMirrored = v4
    table.insert(u168, v2)
end

local function targetRect(a1) -- Line: 1525
    -- upvalues: BlackMarketSceneController (val), projectCardRect (val), isRegionVisible (val)
    local Slot = a1.Slot
    if Slot.Card ~= nil and BlackMarketSceneController.IsCardShown(Slot.Part) then
        local v1, v2
        if a1.IsFlip then
            v1, v2 = projectCardRect(Slot.Part, Vector2.zero, Vector2.one, false)
            if v1 and v2 and 0 < v2.Y then
                if v2.X < 12 then
                    v1 = Vector2.new(v1.X + (v2.X - 12) / 2, v1.Y)
                    v2 = Vector2.new(12, v2.Y)
                end
                return v1, v2
            end
            return nil, nil
        end
        if BlackMarketSceneController.IsCardFaceUp(Slot.Part) and isRegionVisible(a1.Region.Element, Slot.Back) then
            local v3
            local Region = a1.Region
            local AbsoluteSize_2 = Slot.Back.AbsoluteSize
            if AbsoluteSize_2.X <= 0 then
                v1 = nil
                v2 = nil
            elseif not (AbsoluteSize_2.Y <= 0) then
                local v4
                local Element = Region.Element
                local AbsolutePosition = Element.AbsolutePosition
                local AbsoluteSize = Element.AbsoluteSize
                local Scale = Region.Scale.Scale
                if Scale <= 0 then
                    v3 = AbsolutePosition
                    v4 = AbsoluteSize
                elseif not (Scale >= 1) then
                    local AnchorPoint = Element.AnchorPoint
                    local v5 = AbsoluteSize / Scale
                    v3 = AbsolutePosition + AbsoluteSize * AnchorPoint - v5 * AnchorPoint
                    v4 = v5
                else
                    v3 = AbsolutePosition
                    v4 = AbsoluteSize
                end
                local v6 = v3 - Slot.Back.AbsolutePosition
                v1 = v6 / AbsoluteSize_2
                v2 = (v6 + v4) / AbsoluteSize_2
            else
                v1 = nil
                v2 = nil
            end
            if v1 and v2 then
                local v7, v8
                v7, v8, v3 = projectCardRect(Slot.Part, v1, v2, a1.IsMirrored)
                if v7 and v8 and v3 and 12 <= v8.X and 0 < v8.Y then
                    return v7, v8
                end
                return nil, nil
            end
            return nil, nil
        end
        return nil, nil
    end
    return nil, nil
end

local function refreshCardTargets() -- Line: 1591
    -- upvalues: u195 (ref), u196 (ref), GuiService (val), BlackMarketSceneController (val), u169 (val), u170 (val)
    -- upvalues: u171 (val), u168 (val), targetRect (val), u177 (ref), u185 (ref), u164 (ref), GamepadNavigation (val)
    -- upvalues: u178 (ref)
    local Button, Button_2, Slot, Slot_2, v1, v2, v3, v4, v5, v6
    local MenuIsOpen = u195 or u196 or GuiService.MenuIsOpen or BlackMarketSceneController.IsPresenting()
    local v7 = nil
    local v8 = nil
    local v9 = false
    table.clear(u169)
    table.clear(u170)
    table.clear(u171)
    local v10 = nil
    local v11 = nil
    for i, j in u168, v10, v11 do
        Slot_2 = j.Slot
        Button_2 = j.Button
        v1 = nil
        v2 = nil
        if not MenuIsOpen then
            v3, v4 = targetRect(j)
            v1 = v3
            v2 = v4
        end
        if not v1 or not v2 then
            Button_2.Visible = false
            if u185 == j.Region then
                v9 = true
            end
        else
            Button_2.Position = UDim2.fromOffset(v1.X, v1.Y)
            Button_2.Size = UDim2.fromOffset(v2.X, v2.Y)
            Button_2.Visible = true
            v7 = v7 or Button_2
            if Slot_2 == u177 then
                v8 = v8 or Button_2
            end
            if j.IsFlip then
                u169[Slot_2] = Button_2
            elseif v1.Y < (u171[Slot_2] or (1 / 0)) then
                u171[Slot_2] = v1.Y
                u170[Slot_2] = Button_2
            end
        end
    end
    for k, n in u169 do
        n.NextSelectionDown = u170[k]
    end
    v10 = nil
    v11 = nil
    for m, i5 in u168, v10, v11 do
        Button = i5.Button
        if not i5.IsFlip and Button.Visible then
            Slot = i5.Slot
            v1 = if u170[Slot] ~= Button then nil else u169[Slot]
            if Button.NextSelectionUp ~= v1 then
                Button.NextSelectionUp = v1
            end
        end
    end
    local v12 = nil
    v10 = u164
    v11 = false
    if v10 ~= nil then
        v11 = GamepadNavigation.IsUsable(v10)
    end
    if v10 and v11 then
        v5 = v10.AbsolutePosition.X + v10.AbsoluteSize.X / 2
        v6 = (1 / 0)
        for i6, i7 in u169 do
            v4 = math.abs(i7.AbsolutePosition.X + i7.AbsoluteSize.X / 2 - v5)
            if v4 < v6 then
                v12 = i7
                v6 = v4
            end
        end
    end
    v5 = u169
    v6 = nil
    local v13 = nil
    for i8, i9 in v5, v6, v13 do
        i9.NextSelectionUp = if not v11 then nil else v10
    end
    if v10 then
        v10.NextSelectionDown = v12
    end
    if v9 and u185 ~= nil then
        v5 = u185
        u185 = nil
        if v5 then
            v5.HoverOut:Play()
        end
    end
    if MenuIsOpen then
        return
    end
    if u178 and v7 then
        u178 = false
        GuiService.SelectedObject = v7
        return
    end
    local SelectedObject = GuiService.SelectedObject
    if SelectedObject then
        u177 = nil
        for i10, i11 in u168 do
            if i11.Button == SelectedObject then
                u177 = i11.Slot
                return
            end
        end
        return
    end
    if u177 then
        GuiService.SelectedObject = v8 or v7
        if not v8 and not v7 then
            u177 = nil
        end
    end
end

local function createGlint(a1) -- Line: 1742 -- upvalues: u143 (val) -- types: a1: userdata
    local Frame_2, UIGradient, v1
    local Frame = Instance.new("Frame")
    Frame.Name = "Glint"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = Frame
    local v2 = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        (NumberSequenceKeypoint.new(1, 1)),
    })
    local v3 = {false, true}
    local v4 = nil
    local v5 = nil
    for i, j in v3, v4, v5 do
        Frame_2 = Instance.new("Frame")
        Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame_2.Position = UDim2.fromScale(0.5, 0.5)
        v1 = if not j then UDim2.fromScale(1, 0.14) else UDim2.fromScale(0.14, 1)
        Frame_2.Size = v1
        Frame_2.BackgroundColor3 = u143
        Frame_2.BorderSizePixel = 0
        UIGradient = Instance.new("UIGradient")
        UIGradient.Rotation = if not j then 0 else 90
        UIGradient.Transparency = v2
        UIGradient.Parent = Frame_2
        Frame_2.Parent = Frame
    end
    Frame.Parent = a1
    return Frame
end

local function scheduleGlint(a1, a2, a3) -- Line: 1783
    -- upvalues: u176 (val)
    local v1, v2
    local zero = Vector2.zero
    local v3 = -1
    for i = 1, 12 do
        v1 = Vector2.new(u176:NextNumber(0.12, 0.88), u176:NextNumber(0.15, 0.85))
        v2 = (1 / 0)
        for j, k in a1.Glints do
            if k ~= a2 and 0 < k.Lifetime then
                v2 = math.min(v2, (k.Spot - v1).Magnitude)
            end
        end
        if v3 < v2 then
            zero = v1
        end
        if v2 >= 0.22 then
            break
        end
    end
    a2.StartsAt = a3
    a2.Lifetime = u176:NextNumber(1.4, 2.6)
    a2.Size = u176:NextNumber(0.09, 0.17)
    a2.Spot = zero
    a2.Frame.Position = UDim2.fromScale(zero.X, zero.Y)
end

local function scatterCardGlints() -- Line: 1814 -- upvalues: u165 (val), scheduleGlint (val), u176 (val)
    local v1 = os.clock()
    local v2 = nil
    local v3 = nil
    for i, j in u165, v2, v3 do
        for k, n in j.Glints do
            scheduleGlint(j, n, v1 + u176:NextNumber(0, 4.2))
        end
    end
end

local function updateCardGlints() -- Line: 1830
    -- upvalues: GuiService (val), u165 (val), BlackMarketSceneController (val), scheduleGlint (val), u176 (val)
    local v1, v2, v3, v4, v5, v6
    local v7 = os.clock()
    local v8 = nil
    local v9 = nil
    for i, j in u165, v8, v9 do
        v5 = not GuiService.ReducedMotionEnabled
        if v5 then
            v5 = false
            if j.Card ~= nil then
                v5 = BlackMarketSceneController.IsCardFaceUp(j.Part)
            end
        end
        v6 = nil
        v1 = nil
        for k, n in j.Glints, v6, v1 do
            if v5 then
                if n.StartsAt + n.Lifetime < v7 then
                    scheduleGlint(j, n, v7 + u176:NextNumber(0.2, 1.6))
                end
                v2 = (v7 - n.StartsAt) / n.Lifetime
                v3 = false
                if v2 >= 0 then
                    v3 = v2 <= 1
                end
                n.Frame.Visible = v3
                if v3 then
                    v4 = math.sin(v2 * 3.141592653589793)
                    n.Frame.Size = UDim2.fromScale(n.Size * v4, n.Size * v4)
                    n.Frame.Rotation = v2 * 45
                end
            else
                n.Frame.Visible = false
            end
        end
    end
end

local function shouldSelectOnOpen() -- Line: 1865 -- upvalues: UserInputService (val)
    if UserInputService.GamepadEnabled and not UserInputService.MouseEnabled then
        return true
    end
    return (UserInputService:GetLastInputType()) == Enum.UserInputType.Gamepad1
end

local function startCardInput() -- Line: 1883
    -- upvalues: ensureTargetLayer (val), u166 (ref), BlackMarketSceneController (val), u178 (ref), Router (val)
    -- upvalues: UserInputService (val), u195 (ref), u196 (ref), GuiService (val), u124 (val), u184 (val), u172 (ref)
    -- upvalues: RunServiceController (val), refreshCardTargets (val), scatterCardGlints (val), u173 (ref)
    -- upvalues: updateCardGlints (val)
    ensureTargetLayer()
    if u166 then
        u166.Enabled = true
    end

    local function skipForPad() -- Line: 1898
        -- upvalues: BlackMarketSceneController (upval), u178 (upval), Router (upval)
        BlackMarketSceneController.SkipPresentation()
        u178 = true
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end

    local u7 = os.clock()
    local u8 = false
    table.insert(u184, (UserInputService.InputBegan:Connect(function(a1) -- Line: 1909
        -- upvalues: BlackMarketSceneController (upval), u195 (upval), u196 (upval), GuiService (upval), u7 (val)
        -- upvalues: u124 (upval), u178 (upval), Router (upval)
        if BlackMarketSceneController.IsPresenting()
            and not u195
            and not u196
            and not GuiService.MenuIsOpen
            and not (os.clock() - u7 < 0.3) then
            local UserInputType = a1.UserInputType
            local KeyCode = a1.KeyCode
            if u124[KeyCode] then
                BlackMarketSceneController.SkipPresentation()
                u178 = true
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                return
            end
            if UserInputType == Enum.UserInputType.MouseButton1
                or UserInputType == Enum.UserInputType.Touch
                or KeyCode == Enum.KeyCode.ButtonA
                or KeyCode == Enum.KeyCode.Return
                or KeyCode == Enum.KeyCode.Space then
                BlackMarketSceneController.SkipPresentation()
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
            end
            return
        end
    end)))
    table.insert(u184, (UserInputService.InputChanged:Connect(function(a1) -- Line: 1935
        -- upvalues: u8 (ref), u7 (val), BlackMarketSceneController (upval), u195 (upval), u196 (upval)
        -- upvalues: GuiService (upval), u178 (upval), Router (upval)
        if a1.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end
        local Magnitude = Vector2.new(a1.Position.X, a1.Position.Y).Magnitude
        if Magnitude < 0.2 then
            u8 = true
            return
        end
        if u8
            and not (Magnitude < 0.5)
            and not (os.clock() - u7 < 0.3)
            and BlackMarketSceneController.IsPresenting()
            and not u195
            and not u196
            and not GuiService.MenuIsOpen then
            BlackMarketSceneController.SkipPresentation()
            u178 = true
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            return
        end
    end)))
    u178 = if not UserInputService.GamepadEnabled or UserInputService.MouseEnabled then (UserInputService:GetLastInputType()) == Enum.UserInputType.Gamepad1 else true
    u172 = RunServiceController.BindToHeartbeat("UI.Blackmarket.CardTargets", refreshCardTargets)
    refreshCardTargets()
    scatterCardGlints()
    u173 = RunServiceController.BindToRenderStep("UI.Blackmarket.CardGlints", updateCardGlints)
end

local function bindSlot(a1) -- Line: 1988
    -- upvalues: TweenService (val), u138 (val), createTarget (val), BlackMarketSceneController (val), flipCardUp (val)
    -- upvalues: u193 (val), createGlint (val), u190 (ref), InspectController (val), toPreviewItem (val)
    -- upvalues: ReplicatedStorage (val), u133 (val), u192 (val), u179 (ref), Router (val), BlackMarketDealer (val)
    local u1 = {}

    local function addRegion(a1_2, a2) -- Line: 1991
        -- upvalues: TweenService (upval), u138 (upval), u1 (val), createTarget (upval), a1 (val)
        if a1_2 and a1_2:IsA("GuiObject") then
            local UIScale = a1_2:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
            UIScale.Parent = a1_2
            local v1 = {
                Element = a1_2,
                Activate = a2,
                Scale = UIScale,
                HoverIn = TweenService:Create(UIScale, u138, {Scale = 0.95}),
                HoverOut = TweenService:Create(UIScale, u138, {Scale = 1}),
                Press = TweenService:Create(UIScale, u138, {Scale = 0.9}),
            }
            table.insert(u1, v1)
            createTarget(a1, v1, false, a1_2.Name)
            return
        end
    end

    if a1.Front.AnchorPoint == Vector2.zero
        and a1.Front.Position == UDim2.fromScale(0, 0)
        and a1.Front.Size == UDim2.fromScale(1, 1) then
        a1.Front.AnchorPoint = Vector2.new(0.5, 0.5)
        a1.Front.Position = UDim2.fromScale(0.5, 0.5)
    end
    local UIScale = a1.Front:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
    UIScale.Parent = a1.Front
    local v1 = {
        Element = a1.Front,
        Activate = function() -- Line: 2033 -- upvalues: BlackMarketSceneController (upval), a1 (val), flipCardUp (upval), u193 (upval)
            if not BlackMarketSceneController.IsCardFaceUp(a1.Part) then
                flipCardUp(a1)
            else
                BlackMarketSceneController.SetCardFaceUp(a1.Part, false, true)
            end
            if a1.Card then
                local v1 = u193
                local v2 = tostring(a1.Card.cardId)
                v1[v2] = (BlackMarketSceneController.IsCardFaceUp(a1.Part))
            end
        end,
        Scale = UIScale,
        HoverIn = TweenService:Create(UIScale, u138, {Scale = 0.95}),
        HoverOut = TweenService:Create(UIScale, u138, {Scale = 1}),
        Press = TweenService:Create(UIScale, u138, {Scale = 0.9}),
    }
    a1.FlipRegion = v1
    createTarget(a1, v1, true, "Flip")
    local ItemTemplate = a1.Back:FindFirstChild("ItemTemplate")
    local ItemContent = ItemTemplate and ItemTemplate:FindFirstChild("ItemContent")
    local Content = ItemContent and ItemContent:FindFirstChild("Content")
    local Icon = Content
    if Icon then
        Icon = Content:FindFirstChild("Icon")
    end
    local Parent = a1.Back.Parent
    if Icon and Icon:IsA("GuiObject") and Parent and Parent:IsA("SurfaceGui") then
        local Frame = Instance.new("Frame")
        Frame.Name = "Glints"
        Frame.BackgroundTransparency = 1
        Frame.Active = false
        Frame.ZIndex = a1.Back.ZIndex + 1
        Frame.Parent = Parent

        local function fitGlintLayer() -- Line: 2077 -- upvalues: Icon (val), Parent (val), Frame (val)
            local v1 = Icon.AbsolutePosition - Parent.AbsolutePosition
            Frame.Position = UDim2.fromOffset(v1.X, v1.Y)
            Frame.Size = UDim2.fromOffset(Icon.AbsoluteSize.X, Icon.AbsoluteSize.Y)
        end

        ;(Icon:GetPropertyChangedSignal("AbsolutePosition")):Connect(fitGlintLayer)
        ;(Icon:GetPropertyChangedSignal("AbsoluteSize")):Connect(fitGlintLayer)
        local v2 = Icon.AbsolutePosition - Parent.AbsolutePosition
        Frame.Position = UDim2.fromOffset(v2.X, v2.Y)
        Frame.Size = UDim2.fromOffset(Icon.AbsoluteSize.X, Icon.AbsoluteSize.Y)
        for i = 1, 6 do
            table.insert(a1.Glints, {
                StartsAt = (-1 / 0),
                Lifetime = 0,
                Size = 0,
                Frame = createGlint(Frame),
                Spot = Vector2.zero,
            })
        end
    end
    addRegion(ItemContent and ItemContent:FindFirstChild("Inspect"), function() -- Line: 2098 -- upvalues: a1 (val), u190 (upval), InspectController (upval), toPreviewItem (upval)
        local Card = a1.Card
        if Card then
            u190 = true
            InspectController.ShowInspect((toPreviewItem(Card)))
        end
    end)
    local Bottom = a1.Back:FindFirstChild("Bottom")
    local Interact = Bottom and Bottom:FindFirstChild("Interact")
    if Interact then
        local Buy = Interact:FindFirstChild("Buy")
        local View = Interact:FindFirstChild("View")
        local Title = View and View:FindFirstChild("Title")
        if Title and Title:IsA("TextLabel") then
            Title.Text = "VIEW ON MARKETPLACE"
        end
        if Buy and Buy:IsA("GuiObject") and View and View:IsA("GuiObject") then
            a1.BuyWideLayout = {
                Position = UDim2.new(View.Position.X.Scale, View.Position.X.Offset, Buy.Position.Y.Scale, Buy.Position.Y.Offset),
                Size = UDim2.new(View.Size.X.Scale, View.Size.X.Offset, Buy.Size.Y.Scale, Buy.Size.Y.Offset),
            }
        end
        addRegion(Interact:FindFirstChild("View"), function() -- Line: 2136 -- upvalues: a1 (val), ReplicatedStorage (upval), u190 (upval), u133 (upval)
            local Card = a1.Card
            if not Card then
                return
            end
            local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top)
            local GlobalMarketPlace = require(ReplicatedStorage.Interface.Screens.Menu.GlobalMarketPlace)
            u190 = true
            GlobalMarketPlace.SetReturnScreen("Blackmarket")
            GlobalMarketPlace.SearchForItem(Card.name, Card.skin, {
                Float = if u133[tostring(Card.offerKind)] or not (typeof(Card.float) == "number") then nil else Card.float,
                StatTrak = Card.isStattrak == true,
            })
            Top.openFrame("GlobalMarketPlace")
        end)
        addRegion(Interact:FindFirstChild("Buy"), function() -- Line: 2160 -- upvalues: a1 (val), u192 (upval), u179 (upval), Router (upval), BlackMarketDealer (upval)
            local Card = a1.Card
            if Card and Card.status == "available" and not u192[tostring(Card.cardId)] then
                if u179 and u179.buyEnabled == false then
                    Router.broadcastRouter("CreateNotification", "Black Market", "The dealer is not taking Trade Tokens right now.", 5)
                    return
                end
                BlackMarketDealer.BuyCard.Send(Card.cardId)
                return
            end
        end)
    end
    a1.Regions = u1
end

local function ensureSlots() -- Line: 2183
    -- upvalues: u188 (ref), BlackMarketSceneController (val), u165 (val), bindSlot (val)
    local v1, v2, v3
    if u188 then
        return
    end
    local v4 = BlackMarketSceneController.GetCards()
    if #v4 == 0 then
        return
    end
    for i, j in v4 do
        v1, v2 = BlackMarketSceneController.GetCardFaces(j)
        if v1 and v1:IsA("GuiObject") and v2 and v2:IsA("GuiObject") then
            v3 = {
                Part = j,
                Back = v1,
                Front = v2,
                Regions = {},
                Glints = {},
            }
            u165[i] = v3
            bindSlot(v3)
        end
    end
    u188 = #u165 > 0
end

local function beginPaidRoll() -- Line: 2218
    -- upvalues: u196 (ref), u189 (ref), u161 (ref), u199 (ref), u163 (ref), u197 (ref), u162 (ref)
    u196 = true
    if u189 then
        local v1 = u161
        if v1 and u199 ~= true then
            u199 = true
            v1.Visible = true
            local v2 = u163
            if v2 then
                v2:Play()
            end
        end
    end
    u197 = u197 + 1
    local u12 = u197
    task.delay(60, function() -- Line: 2230
        -- upvalues: u12 (val), u197 (upval), u196 (upval), u161 (upval), u199 (upval), u163 (upval), u162 (upval)
        if u12 ~= u197 then
            return
        end
        u196 = false
        local v1 = u161
        if v1 then
            if u199 == false then
                return
            end
            u199 = false
            v1.Visible = false
            local v2 = u163
            if not v2 then
                return
            end
            if u162 then
                v2:Cancel()
                u162.Rotation = 0
            end
        end
    end)
end

local function finishPaidRoll() -- Line: 2244
    -- upvalues: u197 (ref), u196 (ref), u161 (ref), u199 (ref), u163 (ref), u162 (ref)
    u197 = u197 + 1
    u196 = false
    local v1 = u161
    if v1 then
        if u199 == false then
            return
        end
        u199 = false
        v1.Visible = false
        local v2 = u163
        if not v2 then
            return
        end
        if u162 then
            v2:Cancel()
            u162.Rotation = 0
        end
    end
end

local function playPaidRoll() -- Line: 2263 -- upvalues: BlackMarketSceneController (val), clearCardHover (val)
    if not BlackMarketSceneController.IsActive() then
        return
    end
    clearCardHover()
    BlackMarketSceneController.Redeal()
    BlackMarketSceneController.PlayRefreshLine()
end

local function applyDeal(a1, a2) -- Line: 2280
    -- upvalues: dealSignature (val), u179 (ref), u192 (val), u193 (val), u194 (val), u197 (ref), u196 (ref), u161 (ref)
    -- upvalues: u199 (ref), u163 (ref), u162 (ref), BlackMarketSceneController (val), clearCardHover (val)
    -- upvalues: renderDeal (val)
    if (dealSignature(a1)) ~= dealSignature(u179) or a2 then
        table.clear(u192)
        table.clear(u193)
        table.clear(u194)
    end
    if a2 then
        u197 = u197 + 1
        u196 = false
        local v1 = u161
        if v1 and u199 ~= false then
            u199 = false
            v1.Visible = false
            local v2 = u163
            if v2 and u162 then
                v2:Cancel()
                u162.Rotation = 0
            end
        end
        if BlackMarketSceneController.IsActive() then
            clearCardHover()
            BlackMarketSceneController.Redeal()
            BlackMarketSceneController.PlayRefreshLine()
        end
    else
        local v3
        if v3 and BlackMarketSceneController.IsActive() then
            BlackMarketSceneController.ResetCards()
        end
    end
    renderDeal(a1)
end

local function openFrame() -- Line: 2310
    -- upvalues: u190 (ref), MenuSceneController (val), setNavigationVisible (val), BlackMarketSceneController (val)
    -- upvalues: u187 (ref), ensureSlots (val), u165 (val), u191 (val), startCardInput (val), renderDeal (val)
    -- upvalues: u179 (ref), u180 (ref), u186 (ref), BlackMarketDealer (val), u196 (ref), u161 (ref), u199 (ref)
    -- upvalues: u163 (ref), u162 (ref), u181 (ref), u183 (ref), RunServiceController (val), updateCountdown (val)
    local v1 = u190
    u190 = false
    MenuSceneController.HideMenuScene(true, true)
    setNavigationVisible(false)
    local v2 = v1 or not u187
    BlackMarketSceneController.Show(v2)
    ensureSlots()
    if v1 then
        for i, j in u165 do
            if u191[j.Part] then
                BlackMarketSceneController.SetCardFaceUp(j.Part, true, false)
            end
        end
    end
    table.clear(u191)
    startCardInput()
    renderDeal(u179)
    local v3 = u180
    if not v3 then
        v2 = os.clock()
        if not (v2 - u186 < 10) then
            u186 = v2
            BlackMarketDealer.RequestDeal.Send()
        end
    else
        v2 = v3 - os.clock()
        if not (v2 > 0) then
            v2 = os.clock()
            if not (v2 - u186 < 10) then
                u186 = v2
                BlackMarketDealer.RequestDeal.Send()
            end
        end
    end
    v3 = u196
    v2 = u161
    if v2 and v3 ~= u199 then
        u199 = v3
        v2.Visible = v3
        local v4 = u163
        if v4 then
            if v3 then
                v4:Play()
            elseif u162 then
                v4:Cancel()
                u162.Rotation = 0
            end
        end
    end
    u181 = (1 / 0)
    u183 = RunServiceController.BindToHeartbeat("UI.Blackmarket.Countdown", function(a1) -- Line: 2342
        -- upvalues: u181 (upval), updateCountdown (upval), u180 (upval), u186 (upval), BlackMarketDealer (upval)
        u181 = u181 + a1
        if u181 < 0.25 then
            return
        end
        u181 = 0
        updateCountdown()
        local v1 = u180
        if v1 and 0 < v1 - os.clock() then
            return
        end
        local v2 = os.clock()
        if v2 - u186 < 10 then
            return
        end
        u186 = v2
        BlackMarketDealer.RequestDeal.Send()
    end)
end

local function closeFrame() -- Line: 2359
    -- upvalues: u184 (val), u172 (ref), u173 (ref), clearCardHover (val), u166 (ref), u168 (val), u161 (ref)
    -- upvalues: u199 (ref), u163 (ref), u162 (ref), u178 (ref), u177 (ref), u183 (ref), u191 (val), u190 (ref)
    -- upvalues: u165 (val), BlackMarketSceneController (val), setNavigationVisible (val), u160 (ref)
    -- upvalues: MenuSceneController (val)
    for i, j in u184 do
        j:Disconnect()
    end
    table.clear(u184)
    if u172 then
        u172:Disconnect()
        u172 = nil
    end
    if u173 then
        u173:Disconnect()
        u173 = nil
    end
    clearCardHover()
    if u166 then
        u166.Enabled = false
    end
    local v1 = nil
    for k, n in u168, v1 do
        n.Button.Visible = false
    end
    local v2 = u161
    if v2 and u199 ~= false then
        u199 = false
        v2.Visible = false
        v1 = u163
        if v1 and u162 then
            v1:Cancel()
            u162.Rotation = 0
        end
    end
    u178 = false
    u177 = nil
    if u183 then
        u183:Disconnect()
        u183 = nil
    end
    table.clear(u191)
    if u190 then
        for m, i5 in u165 do
            u191[i5.Part] = (BlackMarketSceneController.IsCardFaceUp(i5.Part))
        end
    end
    BlackMarketSceneController.Hide()
    if not u190 then
        setNavigationVisible(true)
    end
    if u160 and u160.Visible then
        MenuSceneController.ShowMenuScene()
    end
end

local function syncScreenState() -- Line: 2432
    -- upvalues: u159 (ref), u160 (ref), u189 (ref), openFrame (val), closeFrame (val)
    local Visible = u159.Visible
    if Visible then
        Visible = true
        if u160 ~= nil then
            Visible = u160.Visible
        end
    end
    if Visible == u189 then
        return
    end
    u189 = Visible
    if Visible then
        openFrame()
        return
    end
    closeFrame()
end

function v1.SetIntroEnabled(a1) -- Line: 2453 -- upvalues: u187 (ref) -- types: a1: boolean
    u187 = a1 ~= false
end

function v1.Initialize(a1, a2) -- Line: 2460
    -- upvalues: u159 (ref), Constants (val), u160 (ref), u161 (ref), u162 (ref), u163 (ref), TweenService (val)
    -- upvalues: u123 (val), ReplicatedStorage (val), ActivateButton (val), CloseButtonRegistry (val)
    -- upvalues: promptRefresh (val), u164 (ref), syncScreenState (val), u189 (ref), openFrame (val), closeFrame (val)
    if not Constants.BLACK_MARKET_ENABLED then
        a2.Visible = false
        return
    end
    local Parent = a2.Parent
    u160 = Parent and Parent:IsA("GuiObject") and Parent or nil
    local Loading = a1:FindFirstChild("Loading")
    local Loading_2 = Loading and Loading:FindFirstChild("Loading")
    if Loading and Loading:IsA("GuiObject") and Loading_2 and Loading_2:IsA("GuiObject") then
        u161 = Loading
        u162 = Loading_2
        u163 = TweenService:Create(Loading_2, u123, {Rotation = 359})
    end

    local function goBack() -- Line: 2481 -- upvalues: ReplicatedStorage (upval)
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Dashboard")
    end

    local Back = a2:FindFirstChild("Back")
    if Back and Back:IsA("GuiButton") then
        ActivateButton(Back)
        Back.Activated:Connect(goBack)
    end
    CloseButtonRegistry.Add(a2, nil, goBack)
    local Refresh = a2:FindFirstChild("Refresh")
    if Refresh and Refresh:IsA("GuiButton") then
        ActivateButton(Refresh)
        Refresh.Activated:Connect(promptRefresh)
        u164 = Refresh
    end
    ;(a2:GetPropertyChangedSignal("Visible")):Connect(syncScreenState)
    if u160 then
        (u160:GetPropertyChangedSignal("Visible")):Connect(syncScreenState)
    end
    local Visible = a2.Visible
    if Visible then
        Visible = true
        if u160 ~= nil then
            Visible = u160.Visible
        end
    end
    if Visible == u189 then
        return
    end
    u189 = Visible
    if Visible then
        openFrame()
        return
    end
    closeFrame()
end

function v1.Start() -- Line: 2513
    -- upvalues: Constants (val), MarketplaceService (val), DevProducts (val), u195 (ref), u198 (ref), applyDeal (val)
    -- upvalues: u196 (ref), u189 (ref), u161 (ref), u199 (ref), u163 (ref), u197 (ref), u162 (ref)
    -- upvalues: BlackMarketDealer (val), Router (val), u180 (ref), u182 (ref), dealSignature (val), u179 (ref)
    -- upvalues: u192 (val), u165 (val), renderSlot (val), BlackMarketSceneController (val)
    if not Constants.BLACK_MARKET_ENABLED then
        return
    end
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(a1, a2, a3) -- Line: 2524
        -- upvalues: DevProducts (upval), u195 (upval), u198 (upval), applyDeal (upval), u196 (upval), u189 (upval)
        -- upvalues: u161 (upval), u199 (upval), u163 (upval), u197 (upval), u162 (upval)
        local v1 = DevProducts["Black Market Refresh"]
        if v1 and a2 == v1.DevProductId then
            u195 = false
            local v2 = u198
            u198 = nil
            if v2 then
                if not v2.success then
                    return
                end
                applyDeal(v2.deal, true)
                return
            end
            if a3 then
                u196 = true
                if u189 then
                    local v3 = u161
                    if v3 and u199 ~= true then
                        u199 = true
                        v3.Visible = true
                        local v4 = u163
                        if v4 then
                            v4:Play()
                        end
                    end
                end
                u197 = u197 + 1
                local u26 = u197
                task.delay(60, function() -- Line: 2230
                    -- upvalues: u26 (val), u197 (upval), u196 (upval), u161 (upval), u199 (upval), u163 (upval)
                    -- upvalues: u162 (upval)
                    if u26 ~= u197 then
                        return
                    end
                    u196 = false
                    local v1 = u161
                    if v1 then
                        if u199 == false then
                            return
                        end
                        u199 = false
                        v1.Visible = false
                        local v2 = u163
                        if not v2 then
                            return
                        end
                        if u162 then
                            v2:Cancel()
                            u162.Rotation = 0
                        end
                    end
                end)
            end
            return
        end
    end)
    BlackMarketDealer.DealData.Listen(function(a1) -- Line: 2546
        -- upvalues: u195 (upval), u196 (upval), u198 (upval), u197 (upval), u161 (upval), u199 (upval), u163 (upval)
        -- upvalues: u162 (upval), Router (upval), u180 (upval), u182 (upval), dealSignature (upval), u179 (upval)
        -- upvalues: applyDeal (upval)
        local v1, v2
        local v3 = false
        if typeof(a1) == "table" then
            v3 = a1.isRefresh == true
        end
        local v4 = v3 and u195 and not u196
        if v4 then
            if a1.success or not u198 or not u198.success then
                u198 = a1
            end
        end
        if typeof(a1) == "table" and a1.success then
            local deal = a1.deal
            v2 = typeof(deal) == "table" and tonumber(deal.msRemaining) or nil
            u180 = if not v2 then nil else os.clock() + v2 / 1000
            u182 = nil
            if v4 then
                return
            end
            v1 = (dealSignature(a1.deal)) ~= dealSignature(u179)
            applyDeal(a1.deal, v3 and (u196 or v1))
            return
        end
        if u196 and v3 then
            u197 = u197 + 1
            u196 = false
            v1 = u161
            if v1 and u199 ~= false then
                u199 = false
                v1.Visible = false
                v2 = u163
                if v2 and u162 then
                    v2:Cancel()
                    u162.Rotation = 0
                end
            end
        end
        local message = not (typeof(a1) ~= "table") and a1.message or "The Black Market is unavailable."
        Router.broadcastRouter("CreateNotification", "Black Market", message, 5)
    end)
    BlackMarketDealer.BuyCardResult.Listen(function(a1) -- Line: 2598
        -- upvalues: Router (upval), u192 (upval), u165 (upval), renderSlot (upval), BlackMarketSceneController (upval)
        if typeof(a1) == "table" and a1.success then
            local cardId = a1.cardId
            if cardId ~= nil then
                u192[(tostring(cardId))] = true
                for i, j in u165 do
                    if j.Card and (tostring(j.Card.cardId)) == tostring(cardId) then
                        renderSlot(j, j.Card)
                    end
                end
            end
            Router.broadcastRouter("RunStoreSound", "Successful Purchase")
            BlackMarketSceneController.PlayPurchaseLine()
            return
        end
        local message = not (typeof(a1) ~= "table") and a1.message or "The purchase failed."
        Router.broadcastRouter("CreateNotification", "Black Market", message, 5)
    end)
end

return v1