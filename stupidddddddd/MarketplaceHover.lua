-- ReplicatedStorage.Components.Common.MarketplaceHover
-- Script path: ReplicatedStorage.Components.Common.MarketplaceHover
-- Decompile time: 18.13 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
require(ReplicatedStorage.Database.Custom.Types)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local MarketPlacePrices = require(ReplicatedStorage.Database.Components.MarketPlacePrices)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local u85 = table.freeze({
    Stock = 0,
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5,
    Forbidden = 6,
})
local u86 = {}
local u87 = nil
local u88 = nil
local u89 = nil
local u90 = nil
local u91 = nil
local u92 = {}
local u93 = nil
local u94 = nil
local u95 = nil
local u96 = nil
local u97 = nil
local u98 = 0
local u99 = {}
local u100 = {Visible = false}
local LocalPlayer = Players.LocalPlayer

local function setHoverVisible(a1) -- Line: 68 -- upvalues: u100 (val), u87 (ref) -- types: a1: boolean
    u100.Visible = a1
    if u87 then
        u87.Visible = a1
    end
end

local function resetHoverLayoutState() -- Line: 77 -- upvalues: u96 (ref), u97 (ref)
    u96 = nil
    u97 = nil
end

local function disconnectTemplateConnections() -- Line: 84 -- upvalues: u99 (val)
    for i, v in ipairs(u99) do
        v:Disconnect()
    end
    table.clear(u99)
end

local function isWearType(a1) -- Line: 94 -- types: a1: string
    local v1 = true
    if a1 ~= "Weapon" then
        v1 = true
        if a1 ~= "Melee" then
            v1 = true
            if a1 ~= "Glove" then
                v1 = a1 == "Zeus x27"
            end
        end
    end
    return v1
end

local function isPointInGui(a1, a2) -- Line: 100 -- types: a1: userdata, a2: userdata
    local AbsolutePosition = a1.AbsolutePosition
    local AbsoluteSize = a1.AbsoluteSize
    local v1 = false
    if AbsolutePosition.X <= a2.X then
        v1 = false
        if a2.X <= AbsolutePosition.X + AbsoluteSize.X then
            v1 = false
            if AbsolutePosition.Y <= a2.Y then
                v1 = a2.Y <= AbsolutePosition.Y + AbsoluteSize.Y
            end
        end
    end
    return v1
end

local function findCaseCollectionName(a1) -- Line: 112 -- upvalues: u86 (ref) -- types: a1: string
    local cases, v1
    for i, v in ipairs(u86) do
        v1 = ipairs
        cases = v.cases or {}
        for i2, i3 in v1(cases) do
            if i3 == v2 then
                return v.name
            end
        end
    end
    return nil
end

local function getHoverPosition(a1) -- Line: 126
    -- upvalues: u87 (ref), Workspace (val), GuiService (val)
    local v1 = u87
    local Parent = v1.Parent
    local zero = Vector2.zero
    local ViewportSize = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    if Parent and Parent:IsA("GuiObject") then
        zero = Parent.AbsolutePosition
        ViewportSize = Parent.AbsoluteSize
    end
    local AbsolutePosition = a1.AbsolutePosition
    local AbsoluteSize = a1.AbsoluteSize
    local AbsoluteSize_2 = v1.AbsoluteSize
    local GuiInset = GuiService:GetGuiInset()
    local v2 = AbsolutePosition.X + AbsoluteSize.X + 8
    local v3 = AbsolutePosition.X - AbsoluteSize_2.X - 8
    local v4 = v2
    local v5 = v2 + AbsoluteSize_2.X
    if zero.X + ViewportSize.X - 8 < v5 then
        v4 = v3
    end
    v5 = zero.X + 8
    local v6 = math.max(v5, zero.X + ViewportSize.X - AbsoluteSize_2.X - 8)
    local v7 = math.max(zero.Y + 8, GuiInset.Y + 8)
    local v8 = math.max(v7, zero.Y + ViewportSize.Y - AbsoluteSize_2.Y - 8)
    local v9 = AbsolutePosition.Y + AbsoluteSize.Y / 2
    local AnchorPoint = v1.AnchorPoint
    local v10 = Vector2.new(math.clamp(v4, v5, v6), (math.clamp(v9, v7, v8)))
    return UDim2.fromOffset(
        math.floor(v10.X - zero.X + AbsoluteSize_2.X * AnchorPoint.X + 0.5),
        (math.floor(v10.Y - zero.Y + AbsoluteSize_2.Y * AnchorPoint.Y + 0.5))
    )
end

local function clearCollectionEntries() -- Line: 165 -- upvalues: u92 (ref)
    for i, v in ipairs(u92.Collection:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "UIListLayout" then
            v:Destroy()
        end
    end
end

local function setCollectionVisible(a1, a2) -- Line: 175 -- upvalues: u92 (ref) -- types: a1: boolean, a2: string?
    u92.CollectionName.Visible = a1
    u92.CollectionName.Text = a1 and ("%*:"):format(a2) or ""
    u92.CollectionSpacer.Visible = a1
    u92.Collection.Visible = a1
end

local function getPackageDescription(a1) -- Line: 184 -- upvalues: GetSkinDisplayName (val)
    local v1, weaponName
    local v2 = "This package contains the "
    for i, v in ipairs(a1.contents) do
        weaponName = v.skin.weaponName
        if v.skin.type == "Melee" then
            weaponName = ("★ %*"):format(weaponName)
        end
        v1 = GetSkinDisplayName.GetSkinDisplayName(v.skin.skinName, true)
        if v1 ~= "" then
            weaponName = ("%* | %*"):format(weaponName, v1)
        end
        if i > 1 then
            v2 = v2 .. " and "
        end
        v2 = v2 .. weaponName
    end
    return v2 .. "."
end

local function getDescription(a1, a2, a3) -- Line: 210 -- upvalues: getPackageDescription (val), Skins (val)
    if a2 then
        if a2.caseType == "Package" then
            return (getPackageDescription(a2))
        end
        return a2.description
    end
    local Type = a1.Type
    local v1 = true
    if Type ~= "Weapon" then
        v1 = true
        if Type ~= "Melee" then
            v1 = true
            if Type ~= "Glove" then
                v1 = Type == "Zeus x27"
            end
        end
    end
    if not v1 then
        if a3 then
            return a3.description
        end
        return ""
    end
    local v2 = Skins.GetSkinInformation(if a1.Type ~= "Melee" then if a1.Type ~= "Glove" then a1.Name else "T Glove" else "T Knife", "Stock")
    if v2 then
        return v2.description
    end
    return ""
end

local function formatPrice(a1) -- Line: 233 -- upvalues: CommaNumber (val)
    return CommaNumber((math.floor(a1.recentAveragePriceTradeTokens)))
end

local function resolveHoverData(a1) -- Line: 239
    -- upvalues: Cases (val), GetSkinDisplayName (val), findCaseCollectionName (val), Skins (val)
    -- upvalues: MarketPlacePrices (val), CommaNumber (val), getDescription (val)
    local collection, rarity, v1, v2, v3, v4, v5, v6
    local v7 = nil
    local v8 = nil
    local caseType = nil
    if a1.Type ~= "Case" and a1.Type ~= "Package" and a1.Type ~= "Charm Capsule" and a1.Type ~= "Sticker Capsule" then
        v8 = Skins.GetSkinInformation(a1.Name, a1.Skin)
        if not v8 then
            warn((("Failed to find skin info for %* | %*"):format(a1.Name, a1.Skin)))
            return nil
        end
        v5 = GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag)
        v3 = a1.StatTrack and ("KillTrak™ %*"):format(v5) or v5
        v4 = GetSkinDisplayName.GetSkinDisplayName(a1.Skin, true)
        rarity = v8.rarity
        collection = v8.collection
        if a1.Type == "Melee" then
            v3 = ("★ %*"):format(v3)
        end
        v5 = nil
        v6 = not not a1.StatTrack
        if not a1.ShowFullPriceRange then
            v1 = MarketPlacePrices.GetItemPrice(a1.Name, a1.Skin, a1.Float, v6)
            if v1 then
                v5 = CommaNumber((math.floor(v1.recentAveragePriceTradeTokens)))
            end
        else
            v1 = MarketPlacePrices.GetItemPrice(a1.Name, a1.Skin, v8 and v8.floatRange.min or a1.Float, v6)
            v2 = MarketPlacePrices.GetItemPrice(a1.Name, a1.Skin, v8 and v8.floatRange.max or a1.Float, v6)
            if not v1 or not v2 then
                if v1 or v2 then
                    v5 = CommaNumber((math.floor((v1 or v2).recentAveragePriceTradeTokens)))
                end
            elseif v1.recentAveragePriceTradeTokens ~= v2.recentAveragePriceTradeTokens then
                v5 = ("%* - %*"):format(
                    CommaNumber((math.floor(v2.recentAveragePriceTradeTokens))),
                    (CommaNumber((math.floor(v1.recentAveragePriceTradeTokens))))
                )
            elseif v1 or v2 then
                v5 = CommaNumber((math.floor((v1 or v2).recentAveragePriceTradeTokens)))
            end
        end
        v1 = {skinInfo = v8}
        v2 = true
        if caseType ~= "Case" then
            v2 = caseType == "Package"
        end
        v1.isCase = v2
        v1.isCaseLike = v7 ~= nil
        v1.displayName = v3
        v1.skinName = v4
        v1.description = getDescription(a1, v7, v8)
        v1.rarityName = rarity
        v1.collectionName = collection
        v1.itemValue = v5
        return v1
    end
    v7 = Cases.GetCaseByName(a1.Skin)
    if not v7 then
        warn((("Failed to find case info for %* | %*"):format(a1.Name, a1.Skin)))
        return nil
    end
    caseType = v7.caseType
    v3 = if caseType ~= "Charm Capsule" then caseType else "Charm Pack"
    v4 = GetSkinDisplayName.GetSkinDisplayName(v7.name, true)
    rarity = v7.caseRarity
    collection = not (caseType ~= "Case") and findCaseCollectionName(v7.name) or nil
    if a1.Type == "Melee" then
        v3 = ("★ %*"):format(v3)
    end
    v5 = nil
    v6 = not not a1.StatTrack
    if not a1.ShowFullPriceRange then
        v1 = MarketPlacePrices.GetItemPrice(a1.Name, a1.Skin, a1.Float, v6)
        if v1 then
            v5 = CommaNumber((math.floor(v1.recentAveragePriceTradeTokens)))
        end
    else
        v1 = MarketPlacePrices.GetItemPrice(a1.Name, a1.Skin, v8 and v8.floatRange.min or a1.Float, v6)
        v2 = MarketPlacePrices.GetItemPrice(a1.Name, a1.Skin, v8 and v8.floatRange.max or a1.Float, v6)
        if not v1 or not v2 then
            if v1 or v2 then
                v5 = CommaNumber((math.floor((v1 or v2).recentAveragePriceTradeTokens)))
            end
        elseif v1.recentAveragePriceTradeTokens ~= v2.recentAveragePriceTradeTokens then
            v5 = ("%* - %*"):format(
                CommaNumber((math.floor(v2.recentAveragePriceTradeTokens))),
                (CommaNumber((math.floor(v1.recentAveragePriceTradeTokens))))
            )
        elseif v1 or v2 then
            v5 = CommaNumber((math.floor((v1 or v2).recentAveragePriceTradeTokens)))
        end
    end
    v1 = {skinInfo = v8}
    v2 = true
    if caseType ~= "Case" then
        v2 = caseType == "Package"
    end
    v1.isCase = v2
    v1.isCaseLike = v7 ~= nil
    v1.displayName = v3
    v1.skinName = v4
    v1.description = getDescription(a1, v7, v8)
    v1.rarityName = rarity
    v1.collectionName = collection
    v1.itemValue = v5
    return v1
end

local function buildCollectionList(a1, a2) -- Line: 332
    -- upvalues: clearCollectionEntries (val), Collections (val), u92 (ref), DataController (val), LocalPlayer (val)
    -- upvalues: Skins (val), u85 (val), u89 (ref), Rarities (val)
    local itemName_2, rarity, skinName_2, v1, v2, v3
    clearCollectionEntries()
    local v4 = not a2 and a1 and Collections.GetCollectionByName(a1)
    if not v4 then
        u92.CollectionName.Visible = false
        u92.CollectionName.Text = ""
        u92.CollectionSpacer.Visible = false
        u92.Collection.Visible = false
        return
    end
    local v5 = DataController.Get(LocalPlayer, "Inventory") or {}
    local v6 = {}
    for i, v in ipairs(v4.items) do
        itemName_2 = v.itemName
        skinName_2 = v.skinName
        v2 = Skins.GetSkinInformation(itemName_2, skinName_2)
        rarity = v2 and v2.rarity or "Stock"
        v3 = false
        for i2, j in v5 do
            if j.Name == itemName_2 and j.Skin == skinName_2 then
                v3 = true
                break
            end
        end
        table.insert(v6, {
            itemName = itemName_2,
            skinName = skinName_2,
            rarity = rarity,
            rarityOrder = u85[rarity],
            isOwned = v3,
        })
    end
    table.sort(v6, function(a1, a2) -- Line: 368
        if a1.rarity ~= "Stock" and a2.rarity ~= "Stock" then
            if a1.rarityOrder ~= a2.rarityOrder then
                return a1.rarityOrder < a2.rarityOrder
            end
            return a1.itemName < a2.itemName
        end
        return a1.rarity ~= "Stock"
    end)
    for k, n in v6 do
        v1 = u89:Clone()
        v1.Parent = u92.Collection
        v1.LayoutOrder = k
        v1.Visible = true
        v1.gun.Text = ("[%*] | %*"):format(n.itemName, n.skinName)
        v1.gun.TextColor3 = Rarities[n.rarity].Color
        v1.ImageLabel.Visible = n.isOwned
    end
    u92.CollectionName.Visible = true
    local CollectionName = u92.CollectionName
    local v7 = ("%*:"):format(a1) or ""
    CollectionName.Text = v7
    u92.CollectionSpacer.Visible = true
    u92.Collection.Visible = true
end

local function setTeamDisplay(a1, a2, a3) -- Line: 395
    -- upvalues: u92 (ref)
    local Team = u92.Team
    Team.CT.Visible = a1
    Team.T.Visible = a2
    Team.Label.Visible = a3 ~= nil
    if a3 then
        Team.Label.Text = a3
    end
end

local function updateTeamDisplay(a1) -- Line: 407 -- upvalues: u92 (ref), GetWeaponProperties (val)
    u92.TeamTitle.Text = "Team:"
    if a1.Type ~= "Melee"
        and a1.Type ~= "Glove"
        and a1.Type ~= "Badge"
        and a1.Type ~= "Charm"
        and a1.Type ~= "Zeus x27" then
        local v1 = false
        if a1.Type == "Weapon" then
            v1 = GetWeaponProperties(a1.Name)
        end
        if not v1 then
            local Team = u92.Team
            Team.CT.Visible = false
            Team.T.Visible = false
            Team.Label.Visible = false
            return
        end
        local Team_2 = v1.Team
        if Team_2 == "Counter-Terrorists" then
            local Team_3 = u92.Team
            Team_3.CT.Visible = true
            Team_3.T.Visible = false
            Team_3.Label.Visible = Team_2 ~= nil
            if not Team_2 then
                return
            end
            Team_3.Label.Text = Team_2
            return
        end
        if Team_2 ~= "Terrorists" then
            local Team_5 = u92.Team
            Team_5.CT.Visible = true
            Team_5.T.Visible = true
            Team_5.Label.Visible = true
            Team_5.Label.Text = "Both"
            return
        end
        local Team_4 = u92.Team
        Team_4.CT.Visible = false
        Team_4.T.Visible = true
        Team_4.Label.Visible = Team_2 ~= nil
        if not Team_2 then
            return
        end
        Team_4.Label.Text = Team_2
        return
    end
    local Team_6 = u92.Team
    Team_6.CT.Visible = true
    Team_6.T.Visible = true
    Team_6.Label.Visible = true
    Team_6.Label.Text = "Both"
end

local function updateFloatDisplay(a1) -- Line: 439 -- upvalues: u92 (ref)
    if a1.HideWearDetails then
        u92.Team.Visible = false
        u92.TeamTitle.Visible = false
        return
    end
    u92.TeamTitle.Text = "Float:"
    u92.TeamTitle.Visible = true
    local v1 = a1.Float and string.format("%.14f", a1.Float) or "N/A"
    local Team = u92.Team
    Team.CT.Visible = false
    Team.T.Visible = false
    Team.Label.Visible = v1 ~= nil
    if v1 then
        Team.Label.Text = v1
    end
    u92.Team.Visible = true
end

local function applyHoverData(a1, a2, a3) -- Line: 454
    -- upvalues: GetSkinDisplayName (val), u92 (ref), u91 (ref), Collections (val), buildCollectionList (val)
    -- upvalues: Rarities (val), Skins (val), updateTeamDisplay (val)
    local v1
    local v2 = if a2.skinName ~= "Vanilla" then (" | %*"):format(a2.skinName) else ""
    local collectionName = a2.collectionName
    GetSkinDisplayName.ApplyNameLabel(u92.ItemName, a2.displayName .. v2, a1.NameTag)
    u92.PriceLabel.Text = a2.itemValue or "N/A"
    u92.Information.Visible = not a2.isCaseLike
    if not a3 then
        u92.CollectionLabel.Text = collectionName or ""
        u92.CollectionLabel.Visible = collectionName ~= nil
        u92.Description.Text = a2.description
        u92.Description.Visible = a2.description ~= ""
        local v3 = collectionName and Collections.GetCollectionByName(collectionName)
        if v3 then
            u92.CollectionIcon.Image = v3.imageAssetId
        end
        u92.CollectionIcon.Visible = v3 ~= nil
        v1 = ("%*|%*"):format(collectionName or "", a2.isCase)
        if u91 ~= v1 then
            buildCollectionList(collectionName, a2.isCase)
            u91 = v1
        end
    else
        u92.CollectionLabel.Visible = false
        u92.Description.Visible = false
        u92.CollectionName.Visible = false
        u92.CollectionName.Text = ""
        u92.CollectionSpacer.Visible = false
        u92.Collection.Visible = false
        u91 = nil
    end
    u92.Rarity.Text = if a2.rarityName == "Special" then "★ Special" else if a2.rarityName ~= "Forbidden" then a2.rarityName else "★ Special"
    u92.Rarity.TextColor3 = Rarities[a2.rarityName].Color
    local skinInfo = a2.skinInfo
    if skinInfo then
        local Type = a1.Type
        skinInfo = true
        if Type ~= "Weapon" then
            skinInfo = true
            if Type ~= "Melee" then
                skinInfo = true
                if Type ~= "Glove" then
                    skinInfo = Type == "Zeus x27"
                end
            end
        end
    end
    if skinInfo then
        local v4
        _, v4 = Skins.GetWearNameForFloat(a2.skinInfo, a1.Float or a2.skinInfo.floatRange.max)
        u92.ExteriorLabel.Text = v4
    end
    u92.Exterior.Visible = skinInfo == true
    if not a3 then
        updateTeamDisplay(a1)
        return
    end
    if a1.HideWearDetails then
        u92.Team.Visible = false
        u92.TeamTitle.Visible = false
        return
    end
    u92.TeamTitle.Text = "Float:"
    u92.TeamTitle.Visible = true
    v1 = a1.Float and string.format("%.14f", a1.Float) or "N/A"
    local Team = u92.Team
    Team.CT.Visible = false
    Team.T.Visible = false
    Team.Label.Visible = v1 ~= nil
    if v1 then
        Team.Label.Text = v1
    end
    u92.Team.Visible = true
end

local function prepareCurrentHoverContent() -- Line: 508
    -- upvalues: u87 (ref), u93 (ref), resolveHoverData (val), u96 (ref), u100 (val), u95 (ref), applyHoverData (val)
    if u87 and u93 then
        local v1 = resolveHoverData(u93)
        if not v1 then
            u96 = nil
            u100.Visible = false
            if u87 then
                u87.Visible = false
            end
            return false
        end
        local v2 = table.concat({
            u93._id,
            v1.displayName,
            v1.skinName,
            v1.description,
            v1.rarityName or "",
            v1.collectionName or "",
            tostring(v1.itemValue or ""),
            tostring(v1.isCase),
            tostring(v1.isCaseLike),
            (tostring(u95 == "TradeInfo")),
        }, "\000")
        if u96 ~= v2 then
            local v3
            u100.Visible = false
            if u87 then
                u87.Visible = false
            end
            applyHoverData(u93, v1, v3)
            u96 = v2
        end
        return true
    end
    return false
end

local function updateHoverPosition(a1) -- Line: 544
    -- upvalues: getHoverPosition (val), u97 (ref), u87 (ref)
    local v1 = getHoverPosition(a1)
    if u97 == v1 then
        return
    end
    u87.Position = v1
    u97 = v1
end

local function canShowCurrentHover(a1) -- Line: 556
    -- upvalues: u87 (ref), u93 (ref), u94 (ref), u100 (val), u88 (ref)
    if u87 and u93 and u94 then
        if u94.Parent ~= nil and u94.Visible then
            if a1 then
                return true
            end
            if u88 and u88.Visible then
                return true
            end
            u100:Close()
            return false
        end
        u100:Close(u94)
        return false
    end
    u100.Visible = false
    if u87 then
        u87.Visible = false
    end
    return false
end

local function showCurrentHover(a1) -- Line: 577
    -- upvalues: canShowCurrentHover (val), u96 (ref), prepareCurrentHoverContent (val), u94 (ref)
    -- upvalues: getHoverPosition (val), u97 (ref), u87 (ref), u100 (val)
    if not canShowCurrentHover(a1) then
        return false
    end
    if u96 == nil and not prepareCurrentHoverContent() then
        return false
    end
    if u94 then
        local v1 = getHoverPosition(u94)
        if u97 ~= v1 then
            u87.Position = v1
            u97 = v1
        end
    end
    u100.Visible = true
    if u87 then
        u87.Visible = true
    end
    return true
end

local function bindTemplateInvalidation(a1) -- Line: 596 -- upvalues: u99 (val), u100 (val) -- types: a1: userdata
    for i, v in ipairs(u99) do
        v:Disconnect()
    end
    table.clear(u99)
    u99[1] = ((a1:GetPropertyChangedSignal("AbsolutePosition")):Connect(function() -- Line: 600 -- upvalues: u100 (upval), a1 (val)
        u100:Close(a1)
    end))
    u99[2] = ((a1:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 604 -- upvalues: a1 (val), u100 (upval)
        if not a1.Visible then
            u100:Close(a1)
        end
    end))
    u99[3] = (a1.AncestryChanged:Connect(function() -- Line: 610 -- upvalues: a1 (val), u100 (upval)
        if a1.Parent == nil then
            u100:Close(a1)
        end
    end))
end

local function closeTradeInfoFromInput(a1) -- Line: 619
    -- upvalues: u95 (ref), u100 (val), u87 (ref), u94 (ref)
    if u95 == "TradeInfo" and u100.Visible and u87 then
        local UserInputType = a1.UserInputType
        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local v1 = Vector2.new(a1.Position.X, a1.Position.Y)
        local v2 = u87
        local AbsolutePosition = v2.AbsolutePosition
        local AbsoluteSize = v2.AbsoluteSize
        local v3 = false
        if AbsolutePosition.X <= v1.X then
            v3 = false
            if v1.X <= AbsolutePosition.X + AbsoluteSize.X then
                v3 = false
                if AbsolutePosition.Y <= v1.Y then
                    v3 = v1.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                end
            end
        end
        if v3 then
            return
        end
        if u94 and u94.Parent then
            v2 = u94
            local AbsolutePosition_2 = v2.AbsolutePosition
            local AbsoluteSize_2 = v2.AbsoluteSize
            v3 = false
            if AbsolutePosition_2.X <= v1.X then
                v3 = false
                if v1.X <= AbsolutePosition_2.X + AbsoluteSize_2.X then
                    v3 = false
                    if AbsolutePosition_2.Y <= v1.Y then
                        v3 = v1.Y <= AbsolutePosition_2.Y + AbsoluteSize_2.Y
                    end
                end
            end
            if v3 then
                return
            end
        end
        u100:Close()
        return
    end
end

function u100.Initialize(a1, a2, a3) -- Line: 644
    -- upvalues: u87 (ref), u88 (ref), u89 (ref), ReplicatedStorage (val), u92 (ref), u100 (val), Collections (val)
    -- upvalues: u86 (ref), Router (val)
    u87 = a2
    u88 = a3
    u89 = ReplicatedStorage.Assets.TradingUI.Templates:WaitForChild("CollectionNameTemplate")
    u92 = {
        ItemName = u87.ItemName.Frame.ItemName,
        CollectionLabel = u87.ItemName.Frame.Collection,
        CollectionIcon = u87.ItemName.CollectionIcon,
        Description = u87.Description,
        PriceLabel = u87.Price.PriceHolder.Team.Label,
        Information = u87.Information,
        Rarity = u87.Information.Rarity.Label,
        Exterior = u87.Information.Exterior,
        ExteriorLabel = u87.Information.Exterior.Label,
        Team = u87.Information.Team.Team,
        TeamTitle = u87.Information.Team.Team.Label.Parent.Parent.Title,
        Collection = u87.Collection,
        CollectionName = u87.CollectionName,
        CollectionSpacer = u87.CollectionSpacer,
    }
    u100.Visible = false
    if u87 then
        u87.Visible = false
    end
    Collections.ObserveAvailableCollections(function(a1) -- Line: 668 -- upvalues: u86 (upval)
        u86 = a1
    end)
    Router.observerRouter("OpenTradeInfo", function(a1, a2) -- Line: 672 -- upvalues: u100 (upval) -- types: a2: userdata
        u100:OpenTradeInfo(a1, a2)
    end)
end

function u100.Start() -- Line: 679 -- upvalues: u90 (ref), UserInputService (val), closeTradeInfoFromInput (val)
    if u90 then
        return
    end
    u90 = UserInputService.InputBegan:Connect(closeTradeInfoFromInput)
end

function u100.Open(a1, a2, a3) -- Line: 689
    -- upvalues: u98 (ref), u93 (ref), u94 (ref), u95 (ref), u96 (ref), u97 (ref), bindTemplateInvalidation (val)
    -- upvalues: prepareCurrentHoverContent (val), canShowCurrentHover (val), u100 (val), getHoverPosition (val)
    -- upvalues: u87 (ref)
    u98 = u98 + 1
    local u5 = u98
    u93 = a2
    u94 = a3
    u95 = "Inventory"
    u96 = nil
    u97 = nil
    bindTemplateInvalidation(a3)
    if prepareCurrentHoverContent() and canShowCurrentHover(false) then
        local v1 = getHoverPosition(a3)
        if u97 ~= v1 then
            u87.Position = v1
            u97 = v1
        end
        u100.Visible = false
        if u87 then
            u87.Visible = false
        end
        task.delay(0.33, function() -- Line: 707
            -- upvalues: u98 (upval), u5 (val), u94 (upval), a3 (val), u95 (upval), canShowCurrentHover (upval)
            -- upvalues: u96 (upval), prepareCurrentHoverContent (upval), getHoverPosition (upval), u97 (upval)
            -- upvalues: u87 (upval), u100 (upval)
            if u98 == u5 and u94 == a3 and u95 == "Inventory" then
                if not canShowCurrentHover(false) then
                    return
                end
                if u96 == nil and not prepareCurrentHoverContent() then
                    return
                end
                if u94 then
                    local v1 = getHoverPosition(u94)
                    if u97 ~= v1 then
                        u87.Position = v1
                        u97 = v1
                    end
                end
                u100.Visible = true
                if u87 then
                    u87.Visible = true
                end
                return
            end
        end)
        return
    end
    u100:Close(a3)
end

function u100.OpenTradeInfo(a1, a2, a3) -- Line: 718
    -- upvalues: u100 (val), u95 (ref), u93 (ref), u94 (ref), u98 (ref), u96 (ref), u97 (ref)
    -- upvalues: bindTemplateInvalidation (val), u87 (ref), prepareCurrentHoverContent (val), getHoverPosition (val)
    local v1, v2
    if u100.Visible and u95 == "TradeInfo" and u93 == a2 and u94 == a3 then
        u100:Close(a3)
        return
    end
    u98 = u98 + 1
    u94 = a3
    u95 = "TradeInfo"
    u96 = nil
    u97 = nil
    bindTemplateInvalidation(a3)
    u100.Visible = false
    if u87 then
        u87.Visible = false
    end
    if not u87 or not a2 or not u94 then
        u100.Visible = false
        if u87 then
            u87.Visible = false
        end
        v2 = false
    elseif u94.Parent == nil then
        u100:Close(u94)
        v2 = false
    elseif u94.Visible then
        v2 = true
    else
        u100:Close(u94)
        v2 = false
    end
    if not v2 then
        v1 = false
    elseif u96 ~= nil or prepareCurrentHoverContent() then
        if u94 then
            local v3 = getHoverPosition(u94)
            if u97 ~= v3 then
                u87.Position = v3
                u97 = v3
            end
        end
        u100.Visible = true
        if u87 then
            u87.Visible = true
        end
        v1 = true
    else
        v1 = false
    end
    if not v1 then
        u100:Close(a3)
    end
end

function u100.Close(a1, a2) -- Line: 739
    -- upvalues: u94 (ref), u98 (ref), u93 (ref), u95 (ref), u91 (ref), u99 (val), u96 (ref), u97 (ref), u100 (val)
    -- upvalues: u87 (ref)
    if a2 and u94 ~= a2 then
        return
    end
    u98 = u98 + 1
    u93 = nil
    u94 = nil
    u95 = nil
    u91 = nil
    for i, v in ipairs(u99) do
        v:Disconnect()
    end
    table.clear(u99)
    u96 = nil
    u97 = nil
    u100.Visible = false
    if u87 then
        u87.Visible = false
    end
end

return u100