-- ReplicatedStorage.Interface.Screens.Menu.Store
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Store
-- Decompile time: 98.74 ms

local u0 = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local PolicyService = game:GetService("PolicyService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
require(ReplicatedStorage.Database.Custom.ConsoleTypes)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local TradeTokens = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Spring = require(ReplicatedStorage.Shared.Spring)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation)
local CaseScroll = require(script.CaseScroll)
local Hover = require(script.Hover)
local StarterPack = require(script.StarterPack)
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts)
local Gamepasses = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.Gamepasses)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Cases_2 = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.Cases)
local u195 = Spring.new(1, 8, 0)
local u200 = Spring.new(1, 8, 0)
local u205 = Spring.new(1, 8, 0)
local LocalPlayer = Players.LocalPlayer
local u207 = true
local u208 = nil
local u209 = 1
local u210 = -1
local u211 = nil
local u212 = nil
local u213 = "Console"
local u214 = {TAB_ORDER = {"Console", "Cases", "Credits", "TradeTokens", "CreatorCode"}}
u214.TRADE_TOKEN_PACKAGES = table.freeze({
    {Amount = 400, ProductName = "+ 400 Trade Tokens"},
    {Amount = 800, ProductName = "+ 800 Trade Tokens"},
    {Amount = 1700, ProductName = "+ 1,700 Trade Tokens"},
    {Amount = 4500, ProductName = "+ 4,500 Trade Tokens"},
    {Amount = 10000, ProductName = "+ 10,000 Trade Tokens"},
    {Amount = 22500, ProductName = "+ 22,500 Trade Tokens"},
})
u214.TRADE_TOKEN_CASE_MARKUP = 1.15
u214.CASE_SCROLL_ITEM_COUNT = 75
u214.CASE_SCROLL_WINNING_INDEX = 55
u214.CASE_SCROLL_DURATION = 7
u214.CASE_SCROLL_ITEM_PADDING = 8
u214.CASE_SCROLL_ITEM_WIDTH = 215
u214.OPEN_CASE_REQUEST_TIMEOUT = 12
u214.PROGRESS_BAR_LOOPS = 4
u214.MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO = 0.738575
u214.INSPECTABLE_ITEM_TAGS = {"StoreBonusItem", "ConsoleItemTemplate"}
u214.STORE_HOVER_BUTTON_TAG = "StoreHoverButton"
u214.STORE_HOVER_MOUSE_OFFSET = Vector2.new(16, 16)
u214.STORE_HOVER_PADDING = 8
u214.DEFAULT_CASE_ICON = "rbxassetid://132217734282843"
u214.SPECIAL_CASE_ICONS = {apex_case = "rbxassetid://110520095994318", chrysalis = "rbxassetid://127888213250008"}
u214.RARITY_PRIORITY = {
    Blue = 1,
    Purple = 2,
    Pink = 3,
    Red = 4,
    Special = 5,
}
local u253 = nil
local u254 = nil
local u255 = {Source = "FeaturedConsoleTimer", Tick = 0, ReceivedAt = 0}
local u256 = {}
local u257 = {isOpening = false, isPendingOpenRequest = false, isQuickUnlock = false}
local u258 = 0
local u259 = {}
local u260 = {}
local u261 = nil
local u262 = nil
local u263 = {}
local u264 = nil
u214.RARITY_TO_DROP_SOUND = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue",
}
local u266 = {isBulkOpening = false, currentIndex = 0, skipped = false, total = 0}
local u271 = Color3.fromRGB(255, 244, 200)
local u272 = nil
local u273 = nil
local u274 = nil
local u275 = nil
local u276 = nil

local function LoadProductInfo(a1, a2) -- Line: 229 -- upvalues: u256 (val), MarketplaceService (val)
    if u256[a1] then
        table.insert(u256[a1], a2)
        return
    end
    u256[a1] = {a2}
    task.spawn(function() -- Line: 236 -- upvalues: MarketplaceService (upval), a1 (val), u256 (upval)
        local success, result = pcall(function() -- Line: 237 -- upvalues: MarketplaceService (upval), a1 (upval)
            return MarketplaceService:GetProductInfoAsync(a1, Enum.InfoType.Product)
        end)
        local v1 = u256[a1]
        u256[a1] = nil
        local v2 = nil
        local v3 = nil
        for i, j in v1, v2, v3 do
            task.defer(j, success and result or nil)
        end
    end)
end

local function LoadProductPrice(a1, a2) -- Line: 248 -- upvalues: LoadProductInfo (val)
    if a1.Price and a2 then
        a2(a1.Price)
    end
    LoadProductInfo(a1.DevProductId, function(a1_2) -- Line: 252 -- upvalues: a1 (val), a2 (val)
        if a1_2 and a1_2.PriceInRobux then
            local UserBasePriceInRobux = a1_2.UserBasePriceInRobux or a1.Price
            a1.BasePrice = UserBasePriceInRobux
            a1.Price = a1_2.PriceInRobux
            if a2 then
                a2(a1.Price)
            end
            return
        end
    end)
end

local function GetCaseTokenPrice(a1) -- Line: 264 -- upvalues: u214 (val)
    local BasePrice = a1.BasePrice
    return (math.floor((if not BasePrice then a1.Price or 0 else if not (BasePrice > 0) then a1.Price or 0 else BasePrice) * u214.TRADE_TOKEN_CASE_MARKUP))
end

local function DoCreditPurchase(a1, a2, a3, a4) -- Line: 271
    -- upvalues: u253 (ref), DataController (val), LocalPlayer (val), CommaNumber (val), u214 (val), TradeTokens (val)
    -- upvalues: ActivateButton (val), MarketplaceService (val), Remotes (val), u212 (ref)
    local BasePrice, Text
    if u253:FindFirstChild("CurrentConfirm") then
        return
    end
    local DevProductId = a2.DevProductId
    if not DevProductId then
        DevProductId = a2.ID
    end
    if DevProductId == nil then
        return
    end
    local v1 = DataController.Get(LocalPlayer, "TradeTokens") or 0
    local u22 = u253.Purchase:Clone()
    u22.Name = "CurrentConfirm"
    u22.Main.Header.Title.Text = a1
    u22.Main.Info.Frame.Credits.TextLabel.Text = CommaNumber(v1)
    u22.Main.Info.Robux.Credits.Amount.Text = CommaNumber(a2.Price or 0)
    local Amount = u22.Main.Info.TradeTokens.Credits.Amount
    if a3 then
        BasePrice = a2.BasePrice
        Text = CommaNumber((math.floor((if not BasePrice then a2.Price or 0 else if not (BasePrice > 0) then a2.Price or 0 else BasePrice) * u214.TRADE_TOKEN_CASE_MARKUP))) or u22.Main.Info.Robux.Credits.Amount.Text
    elseif not a4 then
        Text = u22.Main.Info.Robux.Credits.Amount.Text
    else
        BasePrice = a2.BasePrice
        Text = CommaNumber((math.floor((if not BasePrice then a2.Price or 0 else if not (BasePrice > 0) then a2.Price or 0 else BasePrice) * u214.TRADE_TOKEN_CASE_MARKUP))) or u22.Main.Info.Robux.Credits.Amount.Text
    end
    Amount.Text = Text
    u22.Visible = true
    u22.Parent = u253
    if TradeTokens[a1] and TradeTokens[a1].Price then
        u22.Main.Info.TradeTokens.Credits.Amount.Text = CommaNumber(TradeTokens[a1].Price)
    end
    ActivateButton(u22.Main.Action.Frame.Close)
    u22.Main.Action.Frame.Close.MouseButton1Click:Connect(function() -- Line: 296 -- upvalues: u22 (val)
        u22:Destroy()
    end)
    ActivateButton(u22.Main.Info.Robux)
    u22.Main.Info.Robux.MouseButton1Click:Connect(function() -- Line: 301 -- upvalues: MarketplaceService (upval), LocalPlayer (upval), DevProductId (val), u22 (val)
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProductId)
        u22:Destroy()
    end)
    ActivateButton(u22.Main.Info.TradeTokens)
    u22.Main.Info.TradeTokens.MouseButton1Click:Connect(function() -- Line: 307 -- upvalues: a4 (val), Remotes (upval), a1 (val), a3 (val), u212 (upval), u22 (val)
        if a4 then
            Remotes.Store.PurchaseConsoleTradeTokens.Send({ProductName = a1, Quantity = a4})
        elseif not a3 then
            Remotes.Store.PurchaseTradeTokensProduct.Send({ProductName = a1})
        else
            Remotes.Store.PurchaseTradeTokensCase.Send({ProductName = u212.name, Quantity = a3})
        end
        u22:Destroy()
    end)
end

local function MultiplyUdim2(a1, a2) -- Line: 321 -- types: a1: userdata, a2: number
    return UDim2.fromScale(a1.X.Scale * a2, a1.Y.Scale * a2)
end

local function ClearFrame(a1, a2) -- Line: 327 -- types: a2: table
    for i, v in ipairs(a1:GetChildren()) do
        if not table.find(a2, v.Name) then
            v:Destroy()
        end
    end
end

local function CreateSpecialShimmer(a1) -- Line: 338 -- upvalues: u271 (val) -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = "Shimmer"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = u271
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 3
    Frame.Visible = false
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = 25
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.38, 1),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(0.62, 1),
        (NumberSequenceKeypoint.new(1, 1)),
    })
    UIGradient.Parent = Frame
    Frame.Parent = a1
    return Frame, UIGradient
end

local function CreateSpecialGlint(a1) -- Line: 365 -- upvalues: u271 (val) -- types: a1: userdata
    local Frame_2, UIGradient, v1
    local Frame = Instance.new("Frame")
    Frame.Name = "Glint"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(11, 11)
    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 4
    Frame.Visible = false
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
        v1 = if not j then UDim2.new(1, 0, 0, 2) else UDim2.new(0, 2, 1, 0)
        Frame_2.Size = v1
        Frame_2.BackgroundColor3 = u271
        Frame_2.BorderSizePixel = 0
        Frame_2.ZIndex = 4
        UIGradient = Instance.new("UIGradient")
        UIGradient.Rotation = if not j then 0 else 90
        UIGradient.Transparency = v2
        UIGradient.Parent = Frame_2
        Frame_2.Parent = Frame
    end
    Frame.Parent = a1
    return Frame
end

local function ApplySpecialCardEffect(a1) -- Line: 408
    -- upvalues: CreateSpecialShimmer (val), CreateSpecialGlint (val), RunServiceController (val), u253 (ref)
    -- upvalues: GuiService (val)
    local Content = a1:FindFirstChild("Content")
    if not Content then
        return
    end
    local UIGradient = Content:FindFirstChildOfClass("UIGradient")
    local Transparency = if not UIGradient then NumberSequence.new(0) else UIGradient.Transparency
    local Rarity = Content:FindFirstChild("Rarity")
    local Rotation = if not Rarity then 0 else Rarity.Rotation
    if Rarity and not Rarity:FindFirstChildOfClass("UIAspectRatioConstraint") then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
        UIAspectRatioConstraint.Parent = Rarity
    end
    local u34, u35 = CreateSpecialShimmer(Content)
    local u37 = Random.new()
    local u38 = {}
    for i = 1, 4 do
        table.insert(u38, {
            Frame = CreateSpecialGlint(Content),
            CycleStart = os.clock() + (i - 1) * 0.45,
        })
    end
    local u95 = RunServiceController.BindToRenderStep(RunServiceController.CreateBindingName("UI.Store.SpecialCardEffect"), function() -- Line: 439
        -- upvalues: u253 (upval), GuiService (upval), u34 (val), u38 (val), UIGradient (val), Transparency (val)
        -- upvalues: Rarity (val), Rotation (val), u35 (val), u37 (val)
        if u253.Visible and u253.CaseContent.Visible and u253.CaseContent.Main.CaseContent.Visible then
            local Frame_2, v1, v2, v3, v4, v5
            if GuiService.ReducedMotionEnabled then
                u34.Visible = false
                for m, i5 in u38 do
                    i5.Frame.Visible = false
                end
                return
            end
            local v6 = os.clock()
            if UIGradient then
                v1 = (1 - math.cos(v6 * 2 * 3.141592653589793 / 2.5)) / 2
                local v7 = {}
                for i, j in Transparency.Keypoints do
                    v4 = j.Value + (1 - j.Value) * 0.15 * v1
                    table.insert(v7, (NumberSequenceKeypoint.new(j.Time, v4)))
                end
                UIGradient.Transparency = NumberSequence.new(v7)
            end
            if Rarity then
                Rarity.Rotation = Rotation + v6 * 30 % 360
            end
            v1 = v6 % 2.8 / 0.9
            u34.Visible = v1 <= 1
            if u34.Visible then
                u35.Offset = Vector2.new(-1 + 2 * v1, 0)
            end
            local v8 = nil
            local v9 = nil
            for k, n in u38, v8, v9 do
                v3 = v6 - n.CycleStart
                if v3 >= 1.8 then
                    n.CycleStart = v6
                    n.Frame.Position = UDim2.fromScale(u37:NextNumber(0.12, 0.88), u37:NextNumber(0.12, 0.8))
                    v3 = 0
                end
                v4 = v3 / 1.1
                Frame_2 = n.Frame
                v2 = false
                if v4 >= 0 then
                    v2 = v4 <= 1
                end
                Frame_2.Visible = v2
                if n.Frame.Visible then
                    v5 = math.sin(v4 * 3.141592653589793)
                    n.Frame.Size = UDim2.fromOffset(v5 * 11, v5 * 11)
                    n.Frame.Rotation = v4 * 45
                end
            end
            return
        end
    end)
    a1.Destroying:Connect(function() -- Line: 492 -- upvalues: u95 (val)
        u95:Disconnect()
    end)
end

local function UpdateCreatorCodeResponse(a1, a2) -- Line: 499
    -- upvalues: HttpService (val), u253 (ref)
    local v1
    local u6 = HttpService:GenerateGUID(false)
    local Response = u253.CreatorCode.Container.Body.Response
    if a1 ~= "Success" then
        v1 = false
        if a1 == "Error" then
            v1 = Color3.fromRGB(232, 59, 82)
        end
    else
        v1 = Color3.fromRGB(86, 228, 21)
        if not v1 then
            v1 = false
            if a1 == "Error" then
                v1 = Color3.fromRGB(232, 59, 82)
            end
        end
    end
    Response.TextColor3 = v1
    u253.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM"
    u253.CreatorCode:SetAttribute("ResponseId", u6)
    u253.CreatorCode.Container.Body.Response.Text = a2
    task.delay(5, function() -- Line: 508 -- upvalues: u253 (upval), u6 (val)
        if (u253.CreatorCode:GetAttribute("ResponseId")) == u6 then
            u253.CreatorCode.Container.Body.CreatorName.TextBox.Text = ""
            u253.CreatorCode.Container.Body.Response.Text = ""
        end
    end)
end

local function ScrollToBottom(a1) -- Line: 518 -- upvalues: Profiler (val) -- types: a1: userdata
    Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 519 -- upvalues: a1 (val)
        a1.CanvasPosition = Vector2.new(a1.CanvasPosition.X, (math.max(0, a1.AbsoluteCanvasSize.Y - a1.AbsoluteWindowSize.Y)))
    end)
end

local function ScrollToFeaturedSection(a1) -- Line: 527 -- upvalues: u253 (ref), TweenService (val) -- types: a1: string
    local Container = u253.Tabs.Container.Featured.Container
    local v1 = Container:FindFirstChild(a1)
    if not v1 then
        return false
    end
    local v2 = math.max(0, Container.CanvasPosition.Y + (v1.AbsolutePosition.Y - Container.AbsolutePosition.Y))
    local v3 = TweenService:Create(
        Container,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {CanvasPosition = Vector2.new(0, v2)}
    )
    v3:Play()
    v3.Completed:Wait()
    v3:Destroy()
    return true
end

local function NotifyCaseOpenSequenceFinished() -- Line: 553 -- upvalues: u257 (val), Remotes (val)
    local currentCaseIdentifier = u257.currentCaseIdentifier
    if currentCaseIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({CaseIdentifier = currentCaseIdentifier})
        u257.currentCaseIdentifier = nil
    end
end

local function ClearPendingOpenRequest() -- Line: 563 -- upvalues: u257 (val)
    u257.isPendingOpenRequest = false
    u257.pendingOpenRequestId = nil
    u257.isQuickUnlock = false
end

local function CreateOpenCaseRequestId() -- Line: 571 -- upvalues: u258 (ref)
    u258 = u258 + 1
    return (tostring(u258))
end

local function FailOpenCaseRequest(a1) -- Line: 578 -- upvalues: u257 (val), u259 (val) -- types: a1: string?
    if not a1 then
        return
    end
    if u257.pendingOpenRequestId == a1 then
        u257.isPendingOpenRequest = false
        u257.pendingOpenRequestId = nil
        u257.isQuickUnlock = false
    end
    u259[a1] = nil
end

local function CompleteOpenCaseRequest(a1) -- Line: 592 -- upvalues: u259 (val), u257 (val) -- types: a1: string?
    local v1 = a1 and u259[a1]
    if not v1 then
        return nil
    end
    if not a1 then
        return v1
    end
    if u257.pendingOpenRequestId == a1 then
        u257.isPendingOpenRequest = false
        u257.pendingOpenRequestId = nil
        u257.isQuickUnlock = false
    end
    u259[a1] = nil
    return v1
end

local function BeginOpenCaseRequest(a1) -- Line: 604
    -- upvalues: u258 (ref), u259 (val), u257 (val)
    u258 = u258 + 1
    local v1 = tostring(u258)
    u259[v1] = {IsQuickUnlock = a1}
    u257.isPendingOpenRequest = true
    u257.pendingOpenRequestId = v1
    u257.isQuickUnlock = a1
    return v1
end

local function IsResolvedCaseOpenBusy() -- Line: 615 -- upvalues: u257 (val), u266 (val), MenuState (val)
    return u257.isPendingOpenRequest or u257.isOpening or u266.isBulkOpening or MenuState.IsInspectActive()
end

local function StartResolvedCaseOpenJob(a1) -- Line: 624
    -- upvalues: u276 (ref), u264 (ref), u275 (ref), u273 (ref)
    if a1.IsConsole then
        if #a1.InventoryItems > 1 then
            u276(a1.CaseId, a1.InventoryItems, a1.ConsoleOutcomes or {}, a1.CaseIdentifier)
            return
        end
        u264(a1.InventoryItems[1], a1.CaseIdentifier)
        return
    end
    if #a1.InventoryItems > 1 then
        u275(a1.CaseId, a1.InventoryItems, a1.CaseIdentifier)
        return
    end
    u273(a1.CaseId, a1.InventoryItems[1], a1.CaseIdentifier, a1.IsQuickUnlock, a1.RequestId)
end

local function TryProcessResolvedCaseOpenQueue() -- Line: 649
    -- upvalues: Profiler (val), u257 (val), u266 (val), MenuState (val), u260 (val), StartResolvedCaseOpenJob (val)
    local isPendingOpenRequest_2, v1
    Profiler.mark("UI.Store.TryProcessResolvedCaseOpenQueue")
    local isPendingOpenRequest = u257.isPendingOpenRequest or u257.isOpening or u266.isBulkOpening or MenuState.IsInspectActive()
    if isPendingOpenRequest then
        return false
    end
    local v2 = false
    while true do
        isPendingOpenRequest_2 = u257.isPendingOpenRequest or u257.isOpening or u266.isBulkOpening or MenuState.IsInspectActive()
        if isPendingOpenRequest_2 then
            break
        end
        v1 = table.remove(u260, 1)
        if not v1 then
            break
        end
        v2 = true
        StartResolvedCaseOpenJob(v1)
    end
    return v2
end

local function ReturnToStoreTabs() -- Line: 672 -- upvalues: u253 (ref), u254 (ref)
    u253.Tabs.Container.Visible = true
    u253.CaseContent.Visible = false
    u254.Menu.Top.Visible = true
    u253.Top.Visible = true
    u253.Visible = false
end

local function ShowCaseContentView() -- Line: 680 -- upvalues: u253 (ref), u254 (ref)
    u253.Visible = true
    u253.Tabs.Container.Visible = false
    u253.CaseContent.Visible = true
    u254.Menu.Top.Visible = false
    u253.Top.Visible = false
end

local function InspectInventoryItem(a1) -- Line: 688 -- upvalues: Router (val)
    Router.broadcastRouter(
        "WeaponInspect",
        a1.Name,
        a1.Skin,
        a1.Float,
        a1.StatTrack,
        a1.NameTag,
        a1.Charm,
        a1.Stickers,
        a1.Type,
        a1.Pattern,
        a1._id,
        a1.Serial,
        a1.IsTradeable
    )
end

local function InspectStoreSkin(a1, a2, a3) -- Line: 706
    -- upvalues: Router (val)
    Router.broadcastRouter("WeaponInspect", a1, a2, 0, nil, nil, nil, nil, a3, 1, nil, 1, nil, true, true)
end

local function SetConsoleOverlay(a1) -- Line: 710 -- upvalues: u254 (ref), u262 (ref) -- types: a1: boolean
    local OpenCase = u254.Menu.OpenCase
    local Contents = OpenCase.Contents
    local Close = Contents.Close
    if not a1 then
        if u262 then
            for i, v in ipairs(u262) do
                v.Visible = true
            end
            Close.TextLabel.Text = "CLOSE"
            u262 = nil
        end
        return
    end
    if u262 then
        return
    end
    local v1 = {}
    for i2, i3 in ipairs({OpenCase, Contents}) do
        for i4, j in ipairs(i3:GetChildren()) do
            if j:IsA("GuiObject") and j ~= Contents and j ~= Close and j.Visible then
                table.insert(v1, j)
                j.Visible = false
            end
        end
    end
    u262 = v1
    Close.TextLabel.Text = "SKIP"
    Close.Visible = true
    Contents.Visible = true
    OpenCase.Visible = true
end

local function ResetConsoleOpening() -- Line: 741
    -- upvalues: u257 (val), CaseSceneController (val), u254 (ref), u262 (ref), u253 (ref), Profiler (val)
    -- upvalues: TryProcessResolvedCaseOpenQueue (val)
    u257.isOpening = false
    u257.currentInventoryItem = nil
    u257.currentCaseIdentifier = nil
    CaseSceneController.CancelConsoleOpening()
    local Close = u254.Menu.OpenCase.Contents.Close
    if u262 then
        for i, v in ipairs(u262) do
            v.Visible = true
        end
        Close.TextLabel.Text = "CLOSE"
        u262 = nil
    end
    u254.Menu.OpenCase.Visible = false
    u253.Visible = true
    u253.Tabs.Container.Visible = false
    u253.CaseContent.Visible = true
    u254.Menu.Top.Visible = false
    u253.Top.Visible = false
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
end

function u0._RunConsoleInspectSweep(a1) -- Line: 752
    -- upvalues: u254 (ref), TweenService (val), RunService (val)
    local ConsoleInspectSweep = u254:FindFirstChild("ConsoleInspectSweep")
    if ConsoleInspectSweep then
        ConsoleInspectSweep:Destroy()
    end
    local Frame = Instance.new("Frame")
    Frame.Name = "ConsoleInspectSweep"
    Frame.Active = true
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.fromScale(-0.8, 0.5)
    Frame.Rotation = 4
    Frame.Size = UDim2.fromScale(1.2, 1.25)
    Frame.ZIndex = 1000000
    Frame.Parent = u254
    local v1 = TweenService:Create(
        Frame,
        TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Position = UDim2.fromScale(0.5, 0.5)}
    )
    v1:Play()
    v1.Completed:Wait()
    local success, result = pcall(a1)
    RunService.RenderStepped:Wait()
    local v2 = TweenService:Create(
        Frame,
        TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Position = UDim2.fromScale(1.8, 0.5)}
    )
    v2:Play()
    v2.Completed:Wait()
    Frame:Destroy()
    if not success then
        error(result)
    end
end

local function GetInventoryItemDropSound(a1) -- Line: 795 -- upvalues: u214 (val)
    return u214.RARITY_TO_DROP_SOUND[if a1.Type == "Melee" then "Special" else if a1.Type ~= "Glove" then a1.Rarity or "Blue" else "Special"] or "Drop Blue"
end

function u264(a1, a2) -- Line: 802
    -- upvalues: u261 (ref), u257 (val), Remotes (val), CaseSceneController (val), u254 (ref), u262 (ref), u253 (ref)
    -- upvalues: MenuState (val), Router (val), u214 (val), u0 (val), Profiler (val)
    -- upvalues: TryProcessResolvedCaseOpenQueue (val)
    u261 = nil
    u257.isOpening = false
    u257.currentInventoryItem = nil
    u257.currentCaseIdentifier = a2
    local currentCaseIdentifier = u257.currentCaseIdentifier
    if currentCaseIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({CaseIdentifier = currentCaseIdentifier})
        u257.currentCaseIdentifier = nil
    end
    u0._RunConsoleInspectSweep(function() -- Line: 809
        -- upvalues: CaseSceneController (upval), u254 (upval), u262 (upval), u253 (upval), MenuState (upval), a1 (val)
        -- upvalues: Router (upval), u214 (upval)
        CaseSceneController.HideCaseScene()
        local Close = u254.Menu.OpenCase.Contents.Close
        if u262 then
            for i, v in ipairs(u262) do
                v.Visible = true
            end
            Close.TextLabel.Text = "CLOSE"
            u262 = nil
        end
        u254.Menu.OpenCase.Visible = false
        u253.Tabs.Container.Visible = true
        u253.CaseContent.Visible = false
        u254.Menu.Top.Visible = true
        u253.Top.Visible = true
        u253.Visible = false
        MenuState.SetScreen("Inventory")
        local v1 = a1
        Router.broadcastRouter(
            "WeaponInspect",
            v1.Name,
            v1.Skin,
            v1.Float,
            v1.StatTrack,
            v1.NameTag,
            v1.Charm,
            v1.Stickers,
            v1.Type,
            v1.Pattern,
            v1._id,
            v1.Serial,
            v1.IsTradeable
        )
        if MenuState.IsInspectActive() then
            local broadcastRouter = Router.broadcastRouter
            local v2 = a1
            local v3 = if v2.Type == "Melee" then "Special" else if v2.Type ~= "Glove" then v2.Rarity or "Blue" else "Special"
            broadcastRouter("RunStoreSound", u214.RARITY_TO_DROP_SOUND[v3] or "Drop Blue")
        end
    end)
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
end

local function CleanupCaseOpeningTweens() -- Line: 827 -- upvalues: u257 (val)
    if u257.currentTween then
        u257.currentTween:Cancel()
        u257.currentTween = nil
    end
    if u257.currentZoomTween then
        u257.currentZoomTween:Cancel()
        u257.currentZoomTween = nil
    end
    if u257.renderConnection then
        u257.renderConnection:Disconnect()
        u257.renderConnection = nil
    end
    if u257.viewportConnection then
        u257.viewportConnection:Disconnect()
        u257.viewportConnection = nil
    end
end

u214.CREDIT_PACKAGE_TIERS = {400, 950, 3100, 6500, 13250}

local function GetDeveloperProductNameForAmount(a1) -- Line: 850
    -- upvalues: u214 (val), CommaNumber (val)
    for i, j in u214.CREDIT_PACKAGE_TIERS do
        if a1 <= j then
            return (("+ %* Credits"):format((CommaNumber(j))))
        end
    end
    return "+ 27,000 Credits"
end

function u0.IsStarterPackAvailable() -- Line: 861 -- upvalues: StarterPack (val)
    return StarterPack.IsAvailable()
end

function u0.GetStarterPackRemainingSeconds() -- Line: 865 -- upvalues: StarterPack (val)
    return StarterPack.GetState().RemainingSeconds
end

function u0.GetStarterPackWindowSeconds() -- Line: 869 -- upvalues: StarterPack (val)
    return StarterPack.WINDOW_SECONDS
end

function u0.GetActiveBundleRemainingSeconds(a1) -- Line: 873
    -- upvalues: ReplicatedStorage (val), u255 (val)
    local TimerController = require(ReplicatedStorage.Controllers.TimerController)
    local v1 = a1 or math.floor((workspace:GetServerTimeNow()))
    local Tick = u255.Tick
    if Tick <= 0 then
        Tick = TimerController.GetTimer(u255.Source)
        if not (Tick > 0) then
            return 0
        else
            u255.Tick = Tick
            u255.ReceivedAt = v1
        end
    end
    if Tick > 1000000000000 then
        return (math.max(0, (math.floor(Tick / 1000 - v1))))
    end
    if Tick > 1000000000 then
        return (math.max(0, (math.floor(Tick - v1))))
    end
    local ReceivedAt = u255.ReceivedAt
    if ReceivedAt <= 0 then
        ReceivedAt = v1
        u255.ReceivedAt = v1
    end
    return (math.max(0, (math.floor(Tick - (v1 - ReceivedAt)))))
end

function u0.GetFeaturedConsoleTimerText(a1) -- Line: 905
    -- upvalues: u0 (val), FormatDuration (val)
    local v1 = u0.GetActiveBundleRemainingSeconds(a1)
    if v1 <= 0 then
        return "LIMITED TIME!"
    end
    return FormatDuration(v1, "Always")
end

function u0.RefreshFeaturedConsoleTimer(a1) -- Line: 915 -- upvalues: u255 (val), u0 (val) -- types: a1: number?
    if u255.Label then
        u255.Label.Text = u0.GetFeaturedConsoleTimerText(a1)
    end
end

local function ActivateCategoryButton(a1) -- Line: 923 -- upvalues: TweenService (val), Router (val)
    local Size = a1.Size
    local u6 = TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)
    a1.MouseEnter:Connect(function() -- Line: 926 -- upvalues: TweenService (upval), a1 (val), u6 (val), Size (val), Router (upval)
        local v1 = TweenService
        local v2 = a1
        local v3 = u6
        local v4 = {}
        local v5 = Size
        v4.Size = UDim2.fromScale(v5.X.Scale * 0.9, v5.Y.Scale * 0.9)
        v1:Create(v2, v3, v4):Play()
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
    end)
    a1.MouseLeave:Connect(function() -- Line: 930 -- upvalues: TweenService (upval), a1 (val), u6 (val), Size (val)
        TweenService:Create(a1, u6, {Size = Size}):Play()
    end)
    a1.MouseButton1Click:Connect(function() -- Line: 933 -- upvalues: Router (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
    end)
end

local function IsLimitedSpecialCase(a1) -- Line: 941 -- upvalues: Cases (val)
    local v1 = false
    if a1.caseRarity == "Special" then
        v1 = Cases.IsLimited(a1)
    end
    return v1
end

local function CountMatchingCases(a1) -- Line: 947
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = 0
    local v2 = ipairs
    local v3 = DataController.Get(LocalPlayer, "Inventory") or {}
    local v4 = a1
    for i, v in v2(v3) do
        if v.Type == "Case" then
            if v.Skin == v4 then
                v1 = v1 + 1
            end
        elseif v.Type == "Package" and v.Skin == v4 then
            v1 = v1 + 1
        end
    end
    return v1
end

local function CollectCaseIdentifiers(a1, a2) -- Line: 959
    -- upvalues: DataController (val), LocalPlayer (val)
    local v1 = DataController.Get(LocalPlayer, "Inventory")
    local v2 = {}
    local v3 = ipairs
    local v4, v5 = a2, a1
    for i, v in v3(v1 or {}) do
        if v4 <= #v2 then
            break
        end
        if v.Type == "Case" then
            if v.Skin == v5 then
                table.insert(v2, v._id)
            end
        elseif v.Type == "Package" and v.Skin == v5 then
            table.insert(v2, v._id)
        end
    end
    return v2
end

local function FilterAmountButtons(a1, a2) -- Line: 975 -- types: a1: userdata, a2: number
    local v1
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("TextButton") then
            v1 = (tonumber(v.Name) or 0) <= a2
            v.Visible = v1
        end
    end
end

local function SelectAmountButton(a1, a2) -- Line: 985 -- types: a1: userdata
    local v1, v2
    local v3 = a2
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("TextButton") then
            v1 = true
            if v ~= v3 then
                v1 = v.Name == v3
            end
            v2 = if not v1 then 1 else 0
            v.Frame.BackgroundTransparency = v2
            v:SetAttribute("Selected", v1)
        end
    end
end

local function RefreshCaseAmountButtons() -- Line: 997
    -- upvalues: u212 (ref), u253 (ref), CountMatchingCases (val), DataController (val), LocalPlayer (val)
    -- upvalues: FilterAmountButtons (val), SelectAmountButton (val)
    local v1 = u212
    if v1 and u253.CaseContent.Visible then
        local Amount = u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount
        local Scroll = Amount.Container.Scroll
        FilterAmountButtons(
            Scroll,
            if u253.CaseContent:GetAttribute("State") ~= "Open" then math.max(1, (math.floor(((tonumber((DataController.Get(LocalPlayer, "Credits")))) or 0) / (math.max(v1.price, 1))))) else CountMatchingCases(v1.name)
        )
        local v2 = nil
        for i, j in Scroll:GetChildren() do
            if j:IsA("TextButton") and j:GetAttribute("Selected") then
                v2 = j
                break
            end
        end
        if v2 and not v2.Visible then
            SelectAmountButton(Scroll, "1")
            Amount.Header.TextLabel.Text = "1"
        end
        return
    end
end

local function ResetBulkOpeningState() -- Line: 1034 -- upvalues: u266 (val)
    u266.isBulkOpening = false
    u266.inventoryItems = nil
    u266.bulkIdentifier = nil
    u266.currentIndex = 0
    u266.skipped = false
    u266.caseId = nil
    u266.total = 0
end

local function GetUnboxedItemRarity(a1, a2) -- Line: 1046
    if a1.Type ~= "Melee" and a1.Type ~= "Glove" then
        for i, v in ipairs(a2.contents) do
            if v.skin.skinName == a1.Skin and v.skin.weaponName == a1.Name then
                return v.rarity or "Blue"
            end
        end
        return "Blue"
    end
    return "Special"
end

local function purchaseCase(a1, a2) -- Line: 1061
    -- upvalues: DataController (val), LocalPlayer (val), Remotes (val), u207 (ref)
    -- upvalues: GetDeveloperProductNameForAmount (val), MarketplaceService (val), DevProducts (val), u272 (ref)
    -- upvalues: u0 (val)
    local v1 = DataController.Get(LocalPlayer, "Credits")
    local v2 = a1.price * a2
    if v2 <= v1 then
        Remotes.Store.PurchaseCase.Send({CaseId = a1.caseId, Amount = a2})
        return
    end
    if u207 then
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[(GetDeveloperProductNameForAmount(v2 - v1))].DevProductId)
        u272("Store")
        u0.OpenTab("Credits")
    end
end

local function createCaseTemplate(a1, a2, a3, a4) -- Line: 1076
    -- upvalues: Profiler (val), Rarities (val), ReplicatedStorage (val), Cases_2 (val), Cases (val)
    -- upvalues: ActivateButton (val), Router (val), u0 (val), u274 (ref)
    if a2:FindFirstChild(a1.caseId) then
        return
    end
    Profiler.mark("UI.Store.CreateCaseTemplate")
    local v1 = Rarities[a1.caseRarity]
    if v1 then
        local v2 = ReplicatedStorage.Assets.UI.Store.CaseTemplate:Clone()
        local v3 = Cases_2[a1.name] and Cases_2[a1.name].Amounts[1] or nil
        if v3 and v3.BasePrice and v3.Price < v3.BasePrice then
            local v4 = math.floor((v3.BasePrice - v3.Price) / ((v3.BasePrice + v3.Price) / 2) * 100)
            v2.Discount.Discount.Title.Text = ("-%*%%"):format(v4)
        end
        v2.Discount.Visible = false
        local v5 = false
        if a1.caseRarity == "Special" then
            v5 = Cases.IsLimited(a1)
        end
        if v5 then
            v2.Discount.Discount.Title.Text = "LIMITED"
            v2.Discount.Visible = true
        elseif a4 then
            v2.Discount.Discount.Title.Text = "NEW"
            v2.Discount.Visible = true
        end
        v2.Contents.Glow.ImageColor3 = v1.Color
        v2.Contents.Pattern.ImageColor3 = v1.Color
        v2.Contents.Rarity.BackgroundColor3 = v1.Color
        v2.Contents.Icon.Image = a1.imageAssetId
        v2.Footer.CaseName.Text = a1.name
        v2.LayoutOrder = a3
        v2.Parent = a2
        v2.Name = a1.caseId
        ActivateButton(v2.Purchase)
        v2.Purchase.MouseButton1Click:Connect(function() -- Line: 1113 -- upvalues: Router (upval), u0 (upval), a1 (val)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u0.OpenCaseContent(a1.caseId, "Inspect")
        end)
        ActivateButton(v2.Gift)
        v2.Gift.MouseButton1Click:Connect(function() -- Line: 1118 -- upvalues: u274 (upval), a1 (val)
            u274(a1.caseId, "Case")
        end)
    end
end

local function activateGiftTemplate(a1, a2) -- Line: 1126
    -- upvalues: Router (val), TweenService (val), LocalPlayer (val), u253 (ref), DataController (val), Cases (val)
    -- upvalues: Remotes (val), MarketplaceService (val), Gamepasses (val), DevProducts (val), DoCreditPurchase (val)
    local u6 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    a1.Button.MouseEnter:Connect(function() -- Line: 1128 -- upvalues: Router (upval), TweenService (upval), a1 (val), u6 (val)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
        TweenService:Create(a1.Player.Username, u6, {TextColor3 = Color3.fromRGB(255, 200, 0)}):Play()
    end)
    a1.Button.MouseLeave:Connect(function() -- Line: 1134 -- upvalues: TweenService (upval), a1 (val), u6 (val)
        TweenService:Create(a1.Player.Username, u6, {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
    end)
    a1.Button.MouseButton1Click:Connect(function() -- Line: 1139
        -- upvalues: a2 (val), LocalPlayer (upval), u253 (upval), Router (upval), DataController (upval), Cases (upval)
        -- upvalues: Remotes (upval), MarketplaceService (upval), Gamepasses (upval), DevProducts (upval)
        -- upvalues: DoCreditPurchase (upval)
        local v1
        if a2 == LocalPlayer.UserId then
            return
        end
        local Attribute = u253:GetAttribute("GiftProductName")
        local Attribute_2 = u253:GetAttribute("GiftProductType")
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        if Attribute_2 == "Case" then
            v1 = DataController.Get(LocalPlayer, "Credits")
            local v2 = Cases.GetCase(Attribute)
            local v3 = tonumber(u253.Gift.Amount.Header.TextLabel.Text) or 1
            if v1 < v2.price * v3 then
                return
            end
            u253.Gift.Visible = false
            Remotes.Store.GiftCase.Send({RecipientUserId = tostring(a2), CaseId = Attribute, Amount = v3})
            return
        end
        Remotes.Store.CreateGift.Send({RecipientUserId = tostring(a2), ProductName = Attribute, ProductType = Attribute_2})
        if Attribute_2 == "Gamepass" then
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, Gamepasses[Attribute].GamepassId)
            return
        end
        if Attribute_2 == "DevProduct" then
            v1 = DataController.Get(LocalPlayer, "TradeTokens")
            if not (string.find(Attribute, "Trade Tokens", 1, true) ~= nil)
                and DevProducts[Attribute].Price
                and DevProducts[Attribute].Price <= v1 then
                DoCreditPurchase(Attribute, DevProducts[Attribute])
                return
            end
            MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[Attribute].DevProductId)
        end
    end)
end

local function CanInspect() -- Line: 1189 -- upvalues: u259 (val)
    return next(u259) == nil
end

local function WireCaseItemInspect(a1, a2, a3, a4) -- Line: 1195
    -- upvalues: u259 (val), Router (val), ActivateButton (val)
    local function inspectItem() -- Line: 1196 -- upvalues: u259 (upval), Router (upval), a2 (val), a3 (val), a4 (val)
        if not (next(u259) == nil) then
            return
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        Router.broadcastRouter("WeaponInspect", a2, a3, 0, nil, nil, nil, nil, a4, 1, nil, 1, nil, true, true)
    end

    local ItemContent = a1:FindFirstChild("ItemContent")
    local Inspect = ItemContent and ItemContent:FindFirstChild("Inspect")
    if Inspect and Inspect:IsA("GuiButton") then
        Inspect.Visible = true
        Inspect.Active = true
        Inspect.Selectable = false
        ActivateButton(Inspect)
        Inspect.MouseButton1Click:Connect(inspectItem)
    end
    if a1:IsA("GuiButton") then
        a1.Active = true
        a1.Selectable = true
        a1.Activated:Connect(inspectItem)
    end
    return inspectItem
end

local function SetupTaggedInspectButtons(a1) -- Line: 1225
    -- upvalues: CollectionService (val), u253 (ref), ActivateButton (val), u259 (val), Router (val)
    local HoverFrame, Inspect
    for i, v in ipairs(CollectionService:GetTagged(a1)) do
        if v:IsDescendantOf(u253) then
            local Attribute = v:GetAttribute("WeaponName")
            local Attribute_2 = v:GetAttribute("SkinName")
            if typeof(Attribute) ~= "string" then
                warn((("[Store] %* is missing WeaponName/SkinName attributes."):format((v:GetFullName()))))
            elseif typeof(Attribute_2) == "string" then
                Inspect = v:FindFirstChild("Inspect")
                if not Inspect then
                    warn((("[Store] %* is missing its Inspect button."):format((v:GetFullName()))))
                elseif Inspect:IsA("GuiButton") then
                    ActivateButton(Inspect)
                    Inspect.MouseButton1Click:Connect(function() -- Line: 1246 -- upvalues: u259 (upval), Router (upval), Attribute (val), Attribute_2 (val)
                        if next(u259) == nil then
                            Router.broadcastRouter("RunInterfaceSound", "UI Click")
                            Router.broadcastRouter(
                                "WeaponInspect",
                                Attribute,
                                Attribute_2,
                                0,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                1,
                                nil,
                                1,
                                nil,
                                true,
                                true
                            )
                        end
                    end)
                    HoverFrame = v:FindFirstChild("HoverFrame")
                    if HoverFrame and HoverFrame:IsA("GuiButton") then
                        HoverFrame.Activated:Connect(function() -- Line: 1257 -- upvalues: u259 (upval), Router (upval), Attribute (val), Attribute_2 (val)
                            if next(u259) == nil then
                                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                                Router.broadcastRouter(
                                    "WeaponInspect",
                                    Attribute,
                                    Attribute_2,
                                    0,
                                    nil,
                                    nil,
                                    nil,
                                    nil,
                                    nil,
                                    1,
                                    nil,
                                    1,
                                    nil,
                                    true,
                                    true
                                )
                            end
                        end)
                    end
                else
                    warn((("[Store] %* is missing its Inspect button."):format((v:GetFullName()))))
                end
            else
                warn((("[Store] %* is missing WeaponName/SkinName attributes."):format((v:GetFullName()))))
            end
        end
    end
end

local function setupCurrencyFrame(a1, a2) -- Line: 1269
    -- upvalues: DevProducts (val), CommaNumber (val), LoadProductInfo (val), ActivateButton (val), u207 (ref)
    -- upvalues: DataController (val), LocalPlayer (val), DoCreditPurchase (val), MarketplaceService (val), Router (val)
    -- upvalues: u274 (ref)
    local u4 = DevProducts[a1.Name]
    local Purchase_Button = a1:FindFirstChild("Purchase_Button", true)
    if Purchase_Button and Purchase_Button:IsA("GuiButton") then
        local function u14(a1) -- Line: 1274 -- upvalues: a2 (val), Purchase_Button (val), CommaNumber (upval)
            if not a2 then
                Purchase_Button.Container.Title.Text = ("%* %*"):format(utf8.char(57346), (CommaNumber(a1)))
                return
            end
            local Title = Purchase_Button:FindFirstChild("Title", true)
            if Title and Title:IsA("TextLabel") then
                Title.Text = ("%*%*"):format(utf8.char(57346), (CommaNumber(a1)))
                return
            end
        end

        if u4.Price and u14 then
            u14(u4.Price)
        end
        LoadProductInfo(u4.DevProductId, function(a1) -- Line: 252 -- upvalues: u4 (val), u14 (val)
            if a1 and a1.PriceInRobux then
                local UserBasePriceInRobux = a1.UserBasePriceInRobux or u4.Price
                u4.BasePrice = UserBasePriceInRobux
                u4.Price = a1.PriceInRobux
                if u14 then
                    u14(u4.Price)
                end
                return
            end
        end)
        ActivateButton(Purchase_Button)
        Purchase_Button.MouseButton1Click:Connect(function() -- Line: 1286
            -- upvalues: u207 (upval), DataController (upval), LocalPlayer (upval), a2 (val), u4 (val)
            -- upvalues: DoCreditPurchase (upval), a1 (val), MarketplaceService (upval), Router (upval)
            if u207 then
                local v1 = DataController.Get(LocalPlayer, "TradeTokens")
                if a2 or not u4.Price or not (u4.Price <= v1) then
                    MarketplaceService:PromptProductPurchase(LocalPlayer, u4.DevProductId)
                else
                    DoCreditPurchase(a1.Name, u4)
                end
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
            end
        end)
    end
    local Gift_Button = a1:FindFirstChild("Gift_Button", true)
    if Gift_Button and Gift_Button:IsA("GuiButton") then
        ActivateButton(Gift_Button)
        Gift_Button.MouseButton1Click:Connect(function() -- Line: 1302 -- upvalues: u274 (upval), a1 (val), Router (upval)
            u274("Gift " .. a1.Name, "DevProduct")
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
        end)
    end
end

local function sortCasesByNewest(a1, a2) -- Line: 1315 -- upvalues: Cases (val)
    local v1, v2
    local v3 = false
    if a1.caseRarity == "Special" then
        v3 = Cases.IsLimited(a1)
    end
    local v4 = false
    if a2.caseRarity == "Special" then
        v4 = Cases.IsLimited(a2)
    end
    if v3 ~= v4 then
        return v3
    end
    local v5 = Cases.GetCreationTimestamp(a1)
    local v6 = Cases.GetCreationTimestamp(a2)
    if v5 and v6 then
        if v5 ~= v6 then
            return v6 < v5
        end
        v1, v2 = a1, a2
        if v1.displayOrder ~= v2.displayOrder then
            return v1.displayOrder < v2.displayOrder
        end
        return (Cases.GetBackendOrder(v1)) < Cases.GetBackendOrder(v2)
    end
    if not v5 and not v6 then
        v1, v2 = a1, a2
        if v1.displayOrder ~= v2.displayOrder then
            return v1.displayOrder < v2.displayOrder
        end
        return (Cases.GetBackendOrder(v1)) < Cases.GetBackendOrder(v2)
    end
    return v5 ~= nil
end

local u338 = nil

local function fitCaseGrid(a1) -- Line: 1357 -- upvalues: u338 (ref) -- types: a1: userdata
    local UIGridLayout = a1:FindFirstChildOfClass("UIGridLayout")
    local Parent = a1.Parent
    local Parent_2 = Parent.Parent
    local Frame = Parent_2:FindFirstChild("Frame")
    local UIListLayout = Parent_2:FindFirstChildOfClass("UIListLayout")
    local UIPadding = Parent:FindFirstChildOfClass("UIPadding")
    local AbsoluteSize = a1.AbsoluteSize
    if UIGridLayout and UIListLayout and UIPadding and not (AbsoluteSize.X <= 0) then
        local v1
        local u30 = UIGridLayout.CellSize.X.Scale * AbsoluteSize.X + UIGridLayout.CellSize.X.Offset
        if u30 <= 0 then
            return
        end
        local v2 = u338
        if not v2 then
            if AbsoluteSize.Y <= 0 then
                return
            end

            local function pixels(a1, a2) -- Line: 1380 -- upvalues: u30 (val) -- types: a1: UDim2, a2: number
                return (a1.Scale * a2 + a1.Offset) / u30
            end

            v1 = {}
            local Y = UIGridLayout.CellSize.Y
            v1.cellAspect = (Y.Scale * AbsoluteSize.Y + Y.Offset) / u30
            local Y_3 = UIGridLayout.CellPadding.Y
            v1.rowPadding = (Y_3.Scale * AbsoluteSize.Y + Y_3.Offset) / u30
            v1.header = if not Frame then 0 else Frame.AbsoluteSize.Y / u30
            local Padding = UIListLayout.Padding
            v1.sectionPadding = (Padding.Scale * Parent_2.AbsoluteSize.Y + Padding.Offset) / u30
            local PaddingTop = UIPadding.PaddingTop
            v1.holderPaddingTop = (PaddingTop.Scale * Parent.AbsoluteSize.Y + PaddingTop.Offset) / u30
            local PaddingBottom = UIPadding.PaddingBottom
            v1.holderPaddingBottom = (PaddingBottom.Scale * Parent.AbsoluteSize.Y + PaddingBottom.Offset) / u30
            u338 = v1
        end
        local v3 = 0
        for i, v in ipairs(a1:GetChildren()) do
            if v:IsA("GuiObject") then
                v3 = v3 + 1
            end
        end
        v1 = UIGridLayout.CellPadding.X.Scale * AbsoluteSize.X + UIGridLayout.CellPadding.X.Offset
        local v4 = math.max(1, (math.ceil(v3 / (math.max(1, (math.floor((AbsoluteSize.X + v1) / (u30 + v1) + 0.001)))))))
        local v5 = math.round(u30 * v2.cellAspect)
        local v6 = math.round(u30 * v2.rowPadding)
        local v7 = v4 * v5 + (v4 - 1) * v6
        local v8 = math.round(u30 * v2.holderPaddingTop)
        local v9 = math.round(u30 * v2.holderPaddingBottom)
        UIGridLayout.CellSize = UDim2.new(UIGridLayout.CellSize.X, UDim.new(0, v5))
        UIGridLayout.CellPadding = UDim2.new(UIGridLayout.CellPadding.X, UDim.new(0, v6))
        a1.Size = UDim2.new(a1.Size.X, UDim.new(0, v7))
        UIPadding.PaddingTop = UDim.new(0, v8)
        UIPadding.PaddingBottom = UDim.new(0, v9)
        Parent.AutomaticSize = Enum.AutomaticSize.None
        Parent.Size = UDim2.new(Parent.Size.X, UDim.new(0, v7 + v8 + v9))
        local v10 = math.round(u30 * v2.sectionPadding)
        local v11 = if not Frame then 0 else math.round(u30 * v2.header)
        UIListLayout.Padding = UDim.new(0, v10)
        if Frame then
            Frame.Size = UDim2.new(Frame.Size.X, UDim.new(0, v11))
        end
        Parent_2.AutomaticSize = Enum.AutomaticSize.None
        local new = UDim2.new
        local X = Parent_2.Size.X
        local new_2 = UDim.new
        local v12 = if not Frame then 0 else v11 + v10
        Parent_2.Size = new(X, new_2(0, v7 + v8 + v9 + v12))
        return
    end
end

local function updateCases() -- Line: 1438
    -- upvalues: Profiler (val), u253 (ref), ClearFrame (val), Cases (val), sortCasesByNewest (val)
    -- upvalues: createCaseTemplate (val)
    local isFeatured, v1, v2
    Profiler.mark("UI.Store.UpdateCases")
    local Cases_2 = u253.Tabs.Container.Featured.Container.Cases.Container.Cases
    ClearFrame(Cases_2, {"UIListLayout", "UIGridLayout"})
    local v3 = {}
    for i, v in ipairs(Cases.GetCases()) do
        if v.caseType ~= "Package" and v.caseType ~= "Console" then
            table.insert(v3, v)
        end
    end
    table.sort(v3, sortCasesByNewest)
    local v4 = nil
    local v5 = (-1 / 0)
    for i2, i3 in ipairs(v3) do
        v2 = Cases.GetCreationTimestamp(i3)
        if v2 and v5 < v2 then
            v1 = false
            if i3.caseRarity == "Special" then
                v1 = Cases.IsLimited(i3)
            end
            if not v1 then
                v4 = i3
            end
        end
    end
    for i4, j in ipairs(v3) do
        isFeatured = if not v4 then j.isFeatured else j == v4
        createCaseTemplate(j, Cases_2, i4, isFeatured)
    end
end

local function GetRarityChance(a1, a2) -- Line: 1471 -- types: a1: string, a2: userdata
    for i, j in a2 do
        if j.rarity == a1 then
            return j.chance
        end
    end
    return 0
end

local function RoundToNearestThousandsth(a1) -- Line: 1480
    return string.format("%.4f", math.floor(a1 * 10000) / 10000)
end

local function GetBaseSkinName(a1) -- Line: 1485 -- types: a1: string
    if a1:find("_PATTERN_") then
        return a1:split("_PATTERN_")[1]
    end
    return a1
end

local function buildItemOdds(a1, a2, a3) -- Line: 1493 -- upvalues: u253 (ref) -- types: a2: table, a3: table
    local v1, v2, v3, v4, wear
    local ItemOddsFrame = u253.CaseContent.Main.ItemOddsFrame
    local Container = ItemOddsFrame.Container
    if ItemOddsFrame:FindFirstChild("List") then
        ItemOddsFrame.List.Visible = false
    end
    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Container.CanvasSize = UDim2.fromScale(0, 0)
    Container.ScrollingDirection = Enum.ScrollingDirection.Y
    local v5 = {
        KillTrakHeader = Container.KillTrakHeader,
        ConditionsHeader = Container.ConditionsHeader,
        PatternsHeader = Container.PatternsHeader,
        KillTrakTemplate = Container.KillTrakTemplate,
        PatternTemplate = Container.PatternTemplate,
        FactoryNew = Container:FindFirstChild("Factory New"),
        MinimalWear = Container:FindFirstChild("Minimal Wear"),
        FieldTested = Container:FindFirstChild("Field-Tested"),
        WellWorn = Container:FindFirstChild("Well-Worn"),
        BattleScarred = Container:FindFirstChild("Battle-Scarred"),
    }
    local v6 = {}
    for k, v in pairs(v5) do
        if v and v:IsA("Frame") then
            v6[v] = true
            v.Visible = false
        end
    end
    for i, i2 in ipairs(Container:GetChildren()) do
        if i2:IsA("Frame") and not v6[i2] then
            i2:Destroy()
        end
    end
    local u107 = 0

    local function nextLayoutOrder() -- Line: 1533 -- upvalues: u107 (ref)
        u107 = u107 + 10
        return u107
    end

    local function setOddsRow(a1, a2, a3, a4) -- Line: 1538 -- types: a1: userdata, a2: string, a3: number, a4: UDim
        a1.Visible = true
        local Left = a1:FindFirstChild("Left")
        if Left then
            local Label = Left:FindFirstChild("Label") or Left:FindFirstChild("Title")
            if Label and Label:IsA("TextLabel") then
                Label.Text = a2
                Label.TextColor3 = a4
            end
            local Percent = Left:FindFirstChild("Percent")
            if Percent and Percent:IsA("TextLabel") then
                Percent.Text = string.format("%.2f%%", a3)
            end
        end
        local Bar = a1:FindFirstChild("Bar")
        local Current = Bar and Bar:FindFirstChild("Current")
        if Current and Current:IsA("Frame") then
            Current.Size = UDim2.new(math.clamp(a3 / 100, 0, 1), 0, 1, 0)
            Current.BackgroundColor3 = a4
        end
    end

    local function cloneTemplate(a1, a2) -- Line: 1563
        -- upvalues: u107 (ref), Container (val)
        local v1 = a1:Clone()
        v1.Name = a2
        u107 = u107 + 10
        v1.LayoutOrder = u107
        v1.Visible = true
        v1.Parent = Container
        return v1
    end

    local function setHeaderText(a1, a2) -- Line: 1572 -- types: a1: userdata, a2: string
        local TextLabel = a1:FindFirstChildWhichIsA("TextLabel", true)
        if TextLabel then
            TextLabel.Text = a2
        end
    end

    if a1.type ~= "Glove" then
        v1 = v5.KillTrakHeader:Clone()
        v1.Name = "KillTrakHeader"
        u107 = u107 + 10
        v1.LayoutOrder = u107
        v1.Visible = true
        v1.Parent = Container
        local TextLabel = v1:FindFirstChildWhichIsA("TextLabel", true)
        if TextLabel then
            TextLabel.Text = "General:"
        end
        v1 = v5.KillTrakTemplate:Clone()
        v1.Name = "KillTrak"
        u107 = u107 + 10
        v1.LayoutOrder = u107
        v1.Visible = true
        v1.Parent = Container
        setOddsRow(v1, "KillTrak™", a1.statTrakChance, Color3.fromRGB(255, 132, 32))
    end
    v1 = v5.ConditionsHeader:Clone()
    v1.Name = "ConditionsHeader"
    u107 = u107 + 10
    v1.LayoutOrder = u107
    v1.Visible = true
    v1.Parent = Container
    local TextLabel_2 = v1:FindFirstChildWhichIsA("TextLabel", true)
    if TextLabel_2 then
        TextLabel_2.Text = "Conditions:"
    end
    v1 = {
        ["Factory New"] = {v5.FactoryNew, "Mint Condition", Color3.fromRGB(0, 255, 127)},
        ["Minimal Wear"] = {v5.MinimalWear, "Near-Mint", Color3.fromRGB(0, 170, 255)},
        ["Field-Tested"] = {v5.FieldTested, "Standard-Grade", Color3.fromRGB(255, 255, 0)},
        ["Well-Worn"] = {v5.WellWorn, "Combat-Worn", Color3.fromRGB(255, 85, 0)},
        ["Battle-Scarred"] = {v5.BattleScarred, "War-Torn", Color3.fromRGB(255, 0, 0)},
    }
    for i3, j in ipairs(a1.floatChances) do
        v2 = v1[j.wear]
        if v2 and v2[1] and not (j.chance <= 0) then
            v4 = v2[1]
            wear = j.wear
            v3 = v4:Clone()
            v3.Name = wear
            u107 = u107 + 10
            v3.LayoutOrder = u107
            v3.Visible = true
            v3.Parent = Container
            setOddsRow(v3, v2[2], j.chance, v2[3])
        end
    end
    local v7 = 0
    local v8 = {}
    local v9 = a2
    for k2, n in v9 do
        if n.skin.skinName:find("_PATTERN_") and a3.representativeSkinName:find("_PATTERN_") then
            v8[n.skin.skinName] = true
            v7 = v7 + 1
        end
    end
    if v7 > 0 then
        local v10, v11
        v9 = v5.PatternsHeader:Clone()
        v9.Name = "PatternsHeader"
        u107 = u107 + 10
        v9.LayoutOrder = u107
        v9.Visible = true
        v9.Parent = Container
        local TextLabel_3 = v9:FindFirstChildWhichIsA("TextLabel", true)
        if TextLabel_3 then
            TextLabel_3.Text = "Patterns:"
        end
        v9 = 1 / v7 * 100
        for m in v8 do
            _, v10 = table.unpack((m:split("_PATTERN_")))
            v11 = v5.PatternTemplate:Clone()
            v11.Name = "PatternTemplate"
            u107 = u107 + 10
            v11.LayoutOrder = u107
            v11.Visible = true
            v11.Parent = Container
            v11.LayoutOrder = u107 + (tonumber(v10) or 0)
            setOddsRow(v11, ("Pattern #%*"):format(v10), v9, Color3.fromRGB(255, 255, 255))
        end
    end
    local Title = ItemOddsFrame.Header.Title
    local weaponName = a3.weaponName
    local representativeSkinName = a3.representativeSkinName
    Title.Text = ("ITEM ODDS - \"%* | %*\""):format(
        weaponName,
        if not representativeSkinName:find("_PATTERN_") then representativeSkinName else representativeSkinName:split("_PATTERN_")[1]
    )
    ItemOddsFrame.Visible = true
end

local function RenderGroupedOdds(a1, a2, a3, a4) -- Line: 1630
    -- upvalues: Rarities (val), GetSkinDisplayName (val), Skins (val), CaseScroll (val), ReplicatedStorage (val)
    -- upvalues: ActivateButton (val), buildItemOdds (val), WireCaseItemInspect (val)
    local ItemOdds, skinName_2, skin_2, v1, v2, v3, v4, v5, v6
    if a1 == nil then
        return
    end
    if typeof(a1) ~= "table" then
        warn((("[Store.RenderGroupedOdds] Expected %* to be a table; no odds rows were rendered"):format(a4)))
        return
    end
    local v7 = {}
    local v8 = {}
    local u194 = {}
    local v9 = 0
    local v10, v11, v12 = a4, a2, a3
    for i, v in ipairs(a1) do
        skin_2 = if typeof(v) ~= "table" then nil else if typeof(v.skin) ~= "table" then nil else v.skin
        if not skin_2
            or typeof(skin_2.weaponName) ~= "string"
            or skin_2.weaponName == ""
            or typeof(skin_2.skinName) ~= "string"
            or skin_2.skinName == "" then
            v9 = v9 + 1
        elseif Rarities[v.rarity] then
            table.insert(u194, v)
            skinName_2 = skin_2.skinName
            v3 = ("%*|%*"):format(skin_2.weaponName, if not skinName_2:find("_PATTERN_") then skinName_2 else skinName_2:split("_PATTERN_")[1])
            if not v8[v3] then
                v4 = {
                    weaponName = skin_2.weaponName,
                    baseSkinName = v2,
                    representativeSkinName = skin_2.skinName,
                    rarity = v.rarity,
                    itemType = if skin_2.type ~= "Charm" then nil else "Charm",
                }
                v8[v3] = v4
                table.insert(v7, v4)
            end
        else
            v9 = v9 + 1
        end
    end
    if v9 > 0 then
        warn((("[Store.RenderGroupedOdds] Skipped %* malformed %*; each entry must contain skin.weaponName, skin.skinName, and a known rarity"):format(
            v9,
            v10
        )))
    end
    for i2, i3 in ipairs(v7) do
        v1 = v11(i3, v7)
        v2 = GetSkinDisplayName(i3.baseSkinName, false)
        v3 = Rarities[i3.rarity]
        local u72 = Skins.GetSkinInformation(i3.weaponName, i3.representativeSkinName)
        v5 = CaseScroll.GetStoreItemIcon(u72)
        v6 = ReplicatedStorage.Assets.UI.Store.OddTemplate:Clone()
        v6.ItemTemplate.ItemContent.Content.Icon.Image = v5
        v6.ItemTemplate.ItemContent.Content.Rarity.ImageColor3 = v3.Color
        v6.ItemTemplate.ItemContent.Rarity.BackgroundColor3 = v3.Color
        v6.ItemTemplate.ItemContent.SkinName.Text = v2
        v6.ItemTemplate.ItemContent.WeaponName.Text = i3.weaponName
        v6.Label.Text = ("%*%%"):format((string.format("%.4f", (math.floor(v1 * 10000)) / 10000)))
        v6.Label.UIGradient.Color = v3.ColorSequence
        v6.LayoutOrder = 100 - v1
        v6.Parent = v12
        ItemOdds = v6:FindFirstChild("ItemOdds")
        if not ItemOdds then
            if ItemOdds and ItemOdds:IsA("GuiObject") then
                ItemOdds.Visible = false
            end
        elseif u72 then
            ActivateButton(ItemOdds)
            ItemOdds.MouseButton1Click:Connect(function() -- Line: 1707 -- upvalues: buildItemOdds (upval), u72 (val), u194 (val), i3 (val)
                buildItemOdds(u72, u194, i3)
            end)
        elseif ItemOdds and ItemOdds:IsA("GuiObject") then
            ItemOdds.Visible = false
        end
        WireCaseItemInspect(v6.ItemTemplate, i3.weaponName, i3.representativeSkinName, i3.itemType)
    end
end

local function UpdateCasePurchaseButtons(a1) -- Line: 1718
    -- upvalues: u253 (ref), Cases_2 (val), Cases (val), u207 (ref), RunService (val), CommaNumber (val)
    local SubButtons = u253.CaseContent.Main.Bottom.SubButtons
    local v1 = Cases_2[a1.name]
    local v2 = Cases.IsCaseForSale(a1.caseId)
    local v3 = false
    for i, v in ipairs(SubButtons.CenterButtons:GetChildren()) do
        if v:IsA("GuiButton") then
            v.Visible = false
        end
    end
    if v1 and u207 then
        local v4, v5, v6
        if v2 then
            v5 = nil
            v6 = nil
            for i2, j in v1.Amounts, v5, v6 do
                v4 = SubButtons.CenterButtons:FindFirstChild((tostring(i2)))
                if v4 and v4:IsA("GuiButton") then
                    v4.Visible = j.Offsale == false
                    v3 = v3 or v4.Visible
                    v4.Container.Title.Text = ("%*"):format((CommaNumber(j.Price)))
                end
            end
        elseif RunService:IsStudio() then
            v5 = nil
            v6 = nil
            for k, n in v1.Amounts, v5, v6 do
                v4 = SubButtons.CenterButtons:FindFirstChild((tostring(k)))
                if v4 and v4:IsA("GuiButton") then
                    v4.Visible = n.Offsale == false
                    v3 = v3 or v4.Visible
                    v4.Container.Title.Text = ("%*"):format((CommaNumber(n.Price)))
                end
            end
        end
    end
    SubButtons.Visible = v3
end

local function RefreshCaseListings() -- Line: 1744
    -- upvalues: updateCases (val), u212 (ref), u253 (ref), UpdateCasePurchaseButtons (val)
    updateCases()
    if u212 and u253.CaseContent.Visible then
        UpdateCasePurchaseButtons(u212)
    end
end

local function StartBackgroundProductLoading() -- Line: 1751
    -- upvalues: DevProducts (val), LoadProductInfo (val), updateCases (val), u212 (ref), u253 (ref)
    -- upvalues: UpdateCasePurchaseButtons (val), Cases_2 (val)
    local DevProductId, Price, v1
    for i, j in DevProducts do
        Price = j.Price
        v1 = LoadProductInfo
        DevProductId = j.DevProductId
        local u45 = nil
        v1(DevProductId, function(a1) -- Line: 252 -- upvalues: j (val), u45 (val)
            if a1 and a1.PriceInRobux then
                local UserBasePriceInRobux = a1.UserBasePriceInRobux or j.Price
                j.BasePrice = UserBasePriceInRobux
                j.Price = a1.PriceInRobux
                if u45 then
                    u45(j.Price)
                end
                return
            end
        end)
    end
    local u10 = 0

    local function CompleteRequest() -- Line: 1757
        -- upvalues: u10 (ref), updateCases (upval), u212 (upval), u253 (upval), UpdateCasePurchaseButtons (upval)
        u10 = u10 - 1
        if u10 == 0 then
            updateCases()
            if u212 and u253.CaseContent.Visible then
                UpdateCasePurchaseButtons(u212)
            end
        end
    end

    local v2 = nil
    local v3 = nil
    for k, n in Cases_2, v2, v3 do
        for m, i5 in n.Amounts do
            u10 = u10 + 1
            LoadProductInfo(i5.ID, function(a1) -- Line: 1767
                -- upvalues: i5 (val), u10 (ref), updateCases (upval), u212 (upval), u253 (upval)
                -- upvalues: UpdateCasePurchaseButtons (upval)
                if a1 then
                    local IsForSale = a1.IsForSale and a1.PriceInRobux
                    i5.Offsale = not IsForSale
                    if a1.IsForSale and a1.PriceInRobux then
                        local UserBasePriceInRobux = a1.UserBasePriceInRobux or i5.BasePrice
                        i5.BasePrice = UserBasePriceInRobux
                        i5.Price = a1.PriceInRobux
                    end
                end
                u10 = u10 - 1
                if u10 == 0 then
                    updateCases()
                    if u212 and u253.CaseContent.Visible then
                        UpdateCasePurchaseButtons(u212)
                    end
                end
            end)
        end
    end
end

function u0.OpenCaseContent(a1, a2, a3) -- Line: 1781
    -- upvalues: Profiler (val), Cases (val), u211 (ref), u212 (ref), UpdateCasePurchaseButtons (val), u253 (ref)
    -- upvalues: MenuState (val), CommaNumber (val), u254 (ref), SelectAmountButton (val)
    -- upvalues: RefreshCaseAmountButtons (val), RenderGroupedOdds (val), u214 (val), CaseSceneController (val)
    -- upvalues: ClearFrame (val), Skins (val), Rarities (val), CaseScroll (val), GetSkinDisplayName (val)
    -- upvalues: ReplicatedStorage (val), WireCaseItemInspect (val), GetUserPlatform (val), ActivateButton (val)
    -- upvalues: ApplySpecialCardEffect (val)
    Profiler.mark("UI.Store.OpenCaseContent")
    local u752 = Cases.GetCase(a1)
    u211 = a3
    u212 = u752
    if u752 then
        local Charm, Label_2, MobileInspect, Right_2, chance, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
        UpdateCasePurchaseButtons(u752)
        local Visible = u253.Visible
        local v15 = MenuState.GetCurrentScreen()
        local v16 = Visible or v15 == "Store"
        if v16 then
            MenuState.SetScreen("Store")
        end
        u253.CaseContent:SetAttribute("WasVisibleBeforeInspect", v16)
        local Amount = u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount
        local v17 = not (a2 ~= "Open") and UDim2.new(0.687, 0, 0.465, 0) or UDim2.new(0.575, 0, 0.465, 0)
        Amount.Position = v17
        u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = ("BUY <font color=\"#ffda0f\">(%*)</font>"):format((CommaNumber(u752.price)))
        local v18 = u752.caseType == "Console"
        u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Visible = not v18 or a2 == "Open"
        u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = "1"
        u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Visible = a2 == "Inspect"
        u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.Visible = a2 == "Open"
        u253.CaseContent:SetAttribute("State", a2)
        u253.Tabs.Container.Visible = false
        u253.CaseContent.Visible = true
        u254.Menu.Top.Visible = false
        u253.Top.Visible = false
        u253.Visible = true
        SelectAmountButton(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll, "1")
        RefreshCaseAmountButtons()
        for i, v in ipairs(u253.CaseContent.Main.Odds.Frame.Container:GetChildren()) do
            if v.Name ~= "INVIS" and v:IsA("Frame") then
                if v.Name ~= "Special" then
                    v:Destroy()
                else
                    v.Visible = false
                end
            end
        end
        v17 = {}
        local v19 = {}
        local v20 = nil
        for i2, j in u752.contents, nil, v20 do
            v19[j.rarity] = (v19[j.rarity] or 0) + 1
        end
        local u743 = {}
        local v21 = false
        local v22 = a1
        for k in pairs(v19) do
            for k2, n in u752.rarityChances do
                if n.rarity == k then
                    chance = n.chance
                    v1 = chance or 0
                    u743[k] = v1
                    if v1 > 0 then
                        v21 = true
                    end
                    break
                end
            end
            v1 = 0
            u743[k] = v1
            if v1 > 0 then
                v21 = true
            end
        end
        if not v21 then
            local v23
            v20 = 0
            local v24 = {}
            for i3, m in ipairs(u752.contents) do
                v23 = m.weight or 0
                v20 = v20 + v23
                v24[m.rarity] = (v24[m.rarity] or 0) + v23
            end
            local v25 = #u752.contents
            for k3, i5 in pairs(v19) do
                if not (v20 > 0) then
                    u743[k3] = i5 / math.max(v25, 1) * 100
                else
                    u743[k3] = (v24[k3] or 0) / v20 * 100
                end
            end
        end

        local function GetDisplayRarityChance(a1) -- Line: 1858 -- upvalues: u743 (val)
            return u743[a1] or 0
        end

        local Container_2 = u253.CaseContent.Main.Odds.Frame.Container
        u253.CaseContent.Main.Odds.Visible = false
        for i4, i6 in ipairs(u752.contents) do
            v3 = ("%*_%*"):format(i6.skin.weaponName, i6.skin.skinName)
            v17[v3] = (u743[i6.rarity] or 0) / v19[i6.rarity]
        end
        RenderGroupedOdds(u752.contents, function(a1, a2) -- Line: 1866 -- upvalues: u743 (val)
            local v1 = 0
            for i, v in ipairs(a2) do
                if v.rarity == a1.rarity then
                    v1 = v1 + 1
                end
            end
            return (u743[a1.rarity] or 0) / math.max(v1, 1)
        end, Container_2, (("contents for case \"%*\""):format(v22)))
        RenderGroupedOdds(u752.specialContents, function(a1, a2) -- Line: 1876 -- upvalues: u752 (val)
            return u752.specialChance / math.max(#a2, 1)
        end, Container_2, (("special contents for case \"%*\""):format(v22)))
        local v26 = {}
        for i7, i72 in ipairs(u752.contents) do
            if i72.rarity then
                v26[i72.rarity] = true
            end
        end

        local function SetChanceRowText(a1, a2) -- Line: 1903
            local Right = a1:FindFirstChild("Right")
            local Label = Right and Right:FindFirstChild("Label")
            if Label then
                Label.Text = a2
            end
        end

        for k4 in pairs(u214.RARITY_PRIORITY) do
            if k4 ~= "Special" then
                v4 = u253.CaseContent.Main.CaseChances:FindFirstChild(k4)
                if v4 then
                    v4.Visible = v26[k4] == true
                    v5 = ("%*%%"):format((math.round((u743[k4] or 0) * 100)) / 100)
                    Right_2 = v4:FindFirstChild("Right")
                    Label_2 = Right_2 and Right_2:FindFirstChild("Label")
                    if Label_2 then
                        Label_2.Text = v5
                    end
                end
            end
        end
        local v27 = false
        if u752.specialContents ~= nil then
            v27 = #u752.specialContents > 0
        end
        local Special = u253.CaseContent.Main.CaseChances:FindFirstChild("Special")
        if Special then
            Special.Visible = v27
            v2 = ("%*%%"):format(u752.specialChance or 0)
            local Right = Special:FindFirstChild("Right")
            local Label = Right and Right:FindFirstChild("Label")
            if Label then
                Label.Text = v2
            end
        end
        if u254 and u254.Menu then
            u254.Menu.Visible = true
        end
        CaseSceneController.ShowCaseScene(u752.caseType, u752.name)
        Profiler.defer("UI.Store.CaseContentVisibilityDeferred", function() -- Line: 1936 -- upvalues: u253 (upval)
            u253.Visible = true
            u253.CaseContent.Visible = true
        end)
        ClearFrame(u253.CaseContent.Main.CaseContent.Container, {"UIGridLayout", "UIPadding"})
        if not u253.CaseContent.Main.CaseContent.Visible then
            u253.CaseContent.Main.CaseContent.Visible = true
        end
        v2 = table.clone(u752.contents)
        table.sort(v2, function(a1, a2) -- Line: 1948 -- upvalues: u214 (upval)
            return (u214.RARITY_PRIORITY[a1.rarity] or 0) < (u214.RARITY_PRIORITY[a2.rarity] or 0)
        end)
        for i8, i82 in ipairs(v2) do
            v6 = Skins.GetSkinInformation(i82.skin.weaponName, i82.skin.skinName)
            v7 = Rarities[i82.rarity]
            v8 = CaseScroll.GetStoreItemIcon(v6)
            v9 = GetSkinDisplayName(i82.skin.skinName, true)
            v10 = ReplicatedStorage.Assets.UI.Store.ItemTemplate:Clone()
            v10.ItemContent.Content.Odds.Text = ("%*%%"):format((string.format("%.4f", (math.floor((v17[("%*_%*"):format(i82.skin.weaponName, i82.skin.skinName)] or 0) * 10000)) / 10000)))
            v10.Bottom.Footer.WeaponName.Text = GetSkinDisplayName.GetWeaponDisplayName(i82.skin.weaponName)
            v10.ItemContent.Rarity.BackgroundColor3 = v7.Color
            v10.ItemContent.Content.Rarity.ImageColor3 = v7.Color
            v10.Bottom.Footer.SkinName.Text = v9
            v10.Parent = u253.CaseContent.Main.CaseContent.Container
            v10.ItemContent.Content.Icon.Image = v8
            Charm = v10.ItemContent:FindFirstChild("Charm")
            if Charm and Charm:IsA("ImageLabel") then
                Charm.Visible = false
            end
            v11 = if i82.skin.type ~= "Charm" then nil else "Charm"
            v12 = WireCaseItemInspect(v10, i82.skin.weaponName, i82.skin.skinName, v11)
            v13 = GetUserPlatform()
            v14 = false
            if table.find(v13, "Mobile") ~= nil then
                v14 = #v13 <= 1
            end
            MobileInspect = v10.ItemContent:FindFirstChild("MobileInspect")
            if MobileInspect then
                if not v14 then
                    MobileInspect.Visible = false
                else
                    ActivateButton(MobileInspect)
                    MobileInspect.Activated:Connect(v12)
                end
            end
        end
        if u752.caseType == "Case" then
            v3 = ReplicatedStorage.Assets.UI.Store.GoldTemplate:Clone()
            v3.Selectable = true
            v3.Content.Content.Odds.Text = "0.26%"
            local Icon = v3.Content.Icon
            local DEFAULT_CASE_ICON = u214.SPECIAL_CASE_ICONS[u752.caseId] or u214.DEFAULT_CASE_ICON
            Icon.Image = DEFAULT_CASE_ICON
            v3.Parent = u253.CaseContent.Main.CaseContent.Container
            ApplySpecialCardEffect(v3)
        end
    end
end

local function GetGiftRecipientButtons() -- Line: 2005 -- upvalues: u253 (ref)
    local Visible
    local v1 = {}
    for i, v in ipairs(u253.Gift.Container:GetChildren()) do
        Visible = v:IsA("GuiObject") and v.Visible and v:FindFirstChild("Button")
        if Visible and Visible:IsA("GuiButton") then
            table.insert(v1, Visible)
        end
    end
    return v1
end

local function IsSelectionUsable(a1) -- Line: 2018 -- types: a1: userdata?
    if a1 and a1.Parent and a1.Selectable then
        local Parent = a1
        while Parent do
            if Parent:IsA("ScreenGui") then
                break
            end
            if Parent:IsA("GuiObject") and not Parent.Visible then
                return false
            end
            Parent = Parent.Parent
        end
        return Parent ~= nil
    end
    return false
end

local function refreshGiftNavigation() -- Line: 2035
    -- upvalues: u253 (ref), GetGiftRecipientButtons (val), u208 (ref), GuiService (val), IsSelectionUsable (val)
    local v1
    local Gift = u253.Gift
    local v2 = {Gift.Search.TextBox}
    for i, v in ipairs((GetGiftRecipientButtons())) do
        table.insert(v2, v)
    end
    if Gift.Amount.Visible then
        table.insert(v2, Gift.Amount)
        if Gift.Amount.Container.Visible then
            for i2, i3 in ipairs(Gift.Amount.Container:GetChildren()) do
                if i3:IsA("TextButton") then
                    table.insert(v2, i3)
                end
            end
        end
    end
    table.insert(v2, Gift.Close)
    for i4, j in ipairs(v2) do
        v1 = v2[i4 - 1] or v2[#v2]
        j.NextSelectionUp = v1
        v1 = v2[i4 + 1] or v2[1]
        j.NextSelectionDown = v1
        j.NextSelectionLeft = j
        j.NextSelectionRight = j
    end
    if u208 and Gift.Visible then
        local SelectedObject = GuiService.SelectedObject
        if not SelectedObject or not SelectedObject:IsDescendantOf(Gift) or not IsSelectionUsable(SelectedObject) then
            local TextBox = GetGiftRecipientButtons()[1] or Gift.Search.TextBox
            GuiService.SelectedObject = TextBox
        end
        return
    end
end

function u274(a1, a2) -- Line: 2076
    -- upvalues: u253 (ref), SelectAmountButton (val), u208 (ref), GuiService (val), refreshGiftNavigation (val)
    u253:SetAttribute("GiftProductName", a1)
    u253:SetAttribute("GiftProductType", a2)
    local Amount = u253.Gift.Amount
    Amount.Header.TextLabel.Text = "1"
    Amount.Visible = a2 == "Case"
    Amount.Container.Visible = false
    SelectAmountButton(Amount.Container, "1")
    u253.Gift.Visible = true
    u208 = GuiService.SelectedObject
    refreshGiftNavigation()
end

local function PopulateGiftSearchResult(a1) -- Line: 2092
    -- upvalues: u253 (ref), Players (val), ReplicatedStorage (val), activateGiftTemplate (val)
    local SearchResult = u253.Gift.Container:FindFirstChild("SearchResult")
    if SearchResult then
        SearchResult:Destroy()
    end
    local u14 = tonumber(a1)
    if a1 ~= "" and u14 then
        for i, v in ipairs(u253.Gift.Container:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = false
            end
        end
        local success, result = pcall(function() -- Line: 2110 -- upvalues: Players (upval), u14 (val)
            return Players:GetNameFromUserIdAsync(u14)
        end)
        if success then
            local v1 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone()
            v1.Player.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(u14)
            v1.Player.Username.Text = ("@%*"):format(result)
            v1.Parent = u253.Gift.Container
            v1.Name = "SearchResult"
            activateGiftTemplate(v1, u14)
        end
        return
    end
end

function u0.OpenTab(a1) -- Line: 2126
    -- upvalues: Profiler (val), u207 (ref), Router (val), u213 (ref), ScrollToFeaturedSection (val)
    Profiler.mark("UI.Store.OpenTab")
    if a1 ~= "Credits" and a1 ~= "TradeTokens" then
        u213 = a1
        ScrollToFeaturedSection(a1)
        return
    end
    if not u207 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are not allowed in your region.")
        return
    end
    u213 = a1
    ScrollToFeaturedSection(a1)
end

function u0.OpenBundleSection() -- Line: 2140 -- upvalues: Profiler (val), ScrollToFeaturedSection (val)
    Profiler.mark("UI.Store.OpenBundleSection")
    ScrollToFeaturedSection("StarterPack")
end

function u0.PromptTradeTokenPackageForItemPrice(a1) -- Line: 2145
    -- upvalues: u214 (val), DataController (val), LocalPlayer (val), DevProducts (val), MarketplaceService (val)
    local v1
    if u214.TRADE_TOKEN_PACKAGES[#u214.TRADE_TOKEN_PACKAGES].Amount < a1 then
        return
    end
    local v2 = a1 - (DataController.Get(LocalPlayer, "TradeTokens") or 0)
    if v2 <= 0 then
        return
    end
    for i, j in u214.TRADE_TOKEN_PACKAGES do
        if v2 <= j.Amount then
            v1 = DevProducts[j.ProductName]
            if v1 then
                MarketplaceService:PromptProductPurchase(LocalPlayer, v1.DevProductId)
            end
            return
        end
    end
end

function u0.OpenFeaturedBundleSection() -- Line: 2169 -- upvalues: Profiler (val), ScrollToFeaturedSection (val)
    Profiler.mark("UI.Store.OpenFeaturedBundleSection")
    ScrollToFeaturedSection("Console")
end

function u273(a1, a2, a3, a4, a5) -- Line: 2176
    -- upvalues: Profiler (val), u257 (val), CleanupCaseOpeningTweens (val), Cases (val), Remotes (val)
    -- upvalues: CaseSceneController (val), u253 (ref), u254 (ref), MenuState (val), u214 (val)
    -- upvalues: GetUnboxedItemRarity (val), Router (val), TryProcessResolvedCaseOpenQueue (val), CaseScroll (val)
    local v1
    Profiler.mark("UI.Store.OpenCase")
    local isQuickUnlock = if a4 == nil then u257.isQuickUnlock else a4
    u257.currentCaseIdentifier = a3
    CleanupCaseOpeningTweens()
    local u20 = Cases.GetCase(a1)
    if not u20 then
        return
    end
    if isQuickUnlock then
        if a3 then
            Remotes.Store.CaseOpenSequenceFinished.Send({CaseIdentifier = a3})
        end
        CaseSceneController.HideCaseScene()
        u253.Tabs.Container.Visible = true
        u253.CaseContent.Visible = false
        u254.Menu.Top.Visible = true
        u253.Top.Visible = true
        u253.Visible = false
        MenuState.SetScreen("Inventory")
        v1 = u214.RARITY_TO_DROP_SOUND[GetUnboxedItemRarity(a2, u20)] or "Drop Blue"
        Router.broadcastRouter("RunStoreSound", v1)
        Router.broadcastRouter("RunStoreSound", "Case Close")
        Router.broadcastRouter("QuickOpenResolved", a5)
        Router.broadcastRouter("ShowNewItemNotification", a2)
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
        return
    end
    u257.isOpening = true
    u257.currentInventoryItem = a2
    u253.CaseContent.Visible = false
    v1 = u20.caseType == "Charm Capsule"
    local v2 = u20.caseType == "Package"

    local function startRollAnimation() -- Line: 2211
        -- upvalues: u257 (upval), u254 (upval), u20 (val), u253 (upval), CaseScroll (upval), a2 (val), Router (upval)
        -- upvalues: Remotes (upval), CaseSceneController (upval), MenuState (upval), u214 (upval)
        if not u257.isOpening then
            return
        end
        u254.Menu.OpenCase.CaseName.Text = ("Unlock %*"):format(u20.name)
        u254.Menu.OpenCase.Visible = true
        u253.Visible = false
        u254.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE"
        local v1 = CaseScroll.RunScrollAnimation(u20, a2)
        if not u257.isOpening then
            return
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Notification")
        task.wait(0.5)
        if not u257.isOpening then
            return
        end
        u257.isOpening = false
        u257.currentInventoryItem = nil
        local currentCaseIdentifier = u257.currentCaseIdentifier
        if currentCaseIdentifier then
            Remotes.Store.CaseOpenSequenceFinished.Send({CaseIdentifier = currentCaseIdentifier})
            u257.currentCaseIdentifier = nil
        end
        u254.Menu.OpenCase.Visible = false
        CaseSceneController.HideCaseScene()
        u253.Tabs.Container.Visible = true
        u253.CaseContent.Visible = false
        u254.Menu.Top.Visible = true
        u253.Top.Visible = true
        u253.Visible = false
        MenuState.SetScreen("Inventory")
        local rarity = v1 and v1.rarity or "Blue"
        Router.broadcastRouter("RunStoreSound", u214.RARITY_TO_DROP_SOUND[rarity] or "Drop Blue")
        Router.broadcastRouter("RunStoreSound", "Case Close")
        local v2 = a2
        Router.broadcastRouter(
            "WeaponInspect",
            v2.Name,
            v2.Skin,
            v2.Float,
            v2.StatTrack,
            v2.NameTag,
            v2.Charm,
            v2.Stickers,
            v2.Type,
            v2.Pattern,
            v2._id,
            v2.Serial,
            v2.IsTradeable
        )
    end

    if v1 then
        CaseSceneController.TransitionToUnboxing(startRollAnimation)
        return
    end
    if not v2 then
        CaseSceneController.TransitionToUnboxing()
        task.wait(0.8)
        startRollAnimation()
        return
    end
    CaseSceneController.TransitionToUnboxing()
    CaseSceneController.WaitForOpeningAnimation()
    if not u257.isOpening then
        return
    end
    u257.isOpening = false
    u257.currentInventoryItem = nil
    local currentCaseIdentifier = u257.currentCaseIdentifier
    if currentCaseIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({CaseIdentifier = currentCaseIdentifier})
        u257.currentCaseIdentifier = nil
    end
    CaseSceneController.HideCaseScene()
    u253.Tabs.Container.Visible = true
    u253.CaseContent.Visible = false
    u254.Menu.Top.Visible = true
    u253.Top.Visible = true
    u253.Visible = false
    MenuState.SetScreen("Inventory")
    local v3 = u214.RARITY_TO_DROP_SOUND[GetUnboxedItemRarity(a2, u20)] or "Drop Blue"
    Router.broadcastRouter("RunStoreSound", v3)
    Router.broadcastRouter("RunStoreSound", "Case Close")
    Router.broadcastRouter(
        "WeaponInspect",
        a2.Name,
        a2.Skin,
        a2.Float,
        a2.StatTrack,
        a2.NameTag,
        a2.Charm,
        a2.Stickers,
        a2.Type,
        a2.Pattern,
        a2._id,
        a2.Serial,
        a2.IsTradeable
    )
end

local function stopCaseOpening() -- Line: 2266
    -- upvalues: u257 (val), Router (val), CleanupCaseOpeningTweens (val), u266 (val), CaseScroll (val)
    -- upvalues: CaseSceneController (val)
    if u257.isOpening then
        Router.broadcastRouter("RunStoreSound", "Case Close")
    end
    CleanupCaseOpeningTweens()
    u266.isBulkOpening = false
    u266.inventoryItems = nil
    u266.bulkIdentifier = nil
    u266.currentIndex = 0
    u266.skipped = false
    u266.caseId = nil
    u266.total = 0
    CaseScroll.ResetProgressBar()
    local currentInventoryItem = u257.currentInventoryItem
    u257.isOpening = false
    u257.currentInventoryItem = nil
    CaseSceneController.HideCaseScene()
    return currentInventoryItem
end

local function finishBulkOpening() -- Line: 2282
    -- upvalues: u266 (val), CleanupCaseOpeningTweens (val), CaseScroll (val), u257 (val), CaseSceneController (val)
    -- upvalues: u254 (ref), u262 (ref), u253 (ref), Router (val), Remotes (val), MenuState (val), Profiler (val)
    -- upvalues: TryProcessResolvedCaseOpenQueue (val)
    local inventoryItems = u266.inventoryItems or {}
    local bulkIdentifier = u266.bulkIdentifier
    CleanupCaseOpeningTweens()
    CaseScroll.ResetProgressBar()
    u257.isOpening = false
    u257.currentInventoryItem = nil
    CaseSceneController.HideCaseScene()
    local Close = u254.Menu.OpenCase.Contents.Close
    if u262 then
        for i, v in ipairs(u262) do
            v.Visible = true
        end
        Close.TextLabel.Text = "CLOSE"
        u262 = nil
    end
    u254.Menu.OpenCase.Visible = false
    u253.Tabs.Container.Visible = true
    u253.CaseContent.Visible = false
    u254.Menu.Top.Visible = true
    u253.Top.Visible = true
    u253.Visible = false
    u254.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE"
    Router.broadcastRouter("RunStoreSound", "Case Close")
    if bulkIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({CaseIdentifier = bulkIdentifier})
    end
    MenuState.SetScreen("Inventory")
    if inventoryItems[1] then
        Router.broadcastRouter("ShowNewItemNotification", inventoryItems[1])
    end
    u266.isBulkOpening = false
    u266.inventoryItems = nil
    u266.bulkIdentifier = nil
    u266.currentIndex = 0
    u266.skipped = false
    u266.caseId = nil
    u266.total = 0
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
end

local function skipBulkOpening() -- Line: 2309
    -- upvalues: u266 (val), CleanupCaseOpeningTweens (val), finishBulkOpening (val)
    u266.skipped = true
    CleanupCaseOpeningTweens()
    finishBulkOpening()
end

local function BeginBulkOpeningState(a1, a2, a3) -- Line: 2317
    -- upvalues: u266 (val)
    u266.isBulkOpening = true
    u266.inventoryItems = a2
    u266.bulkIdentifier = a3
    u266.caseId = a1
    u266.total = #a2
    u266.currentIndex = 0
    u266.skipped = false
end

local function IsBulkOpeningInterrupted() -- Line: 2331 -- upvalues: u257 (val), u266 (val)
    return not u257.isOpening or u266.skipped
end

local function HoldBulkReveal(a1) -- Line: 2336 -- upvalues: u257 (val), u266 (val) -- types: a1: number
    local v1 = tick()
    while tick() - v1 < a1 do
        if not u257.isOpening or u266.skipped then
            break
        end
        task.wait(0.1)
    end
end

function u275(a1, a2, a3) -- Line: 2346
    -- upvalues: Profiler (val), Cases (val), u266 (val), CleanupCaseOpeningTweens (val), u257 (val), u253 (ref)
    -- upvalues: CaseSceneController (val), u254 (ref), CaseScroll (val), Router (val), u214 (val), HoldBulkReveal (val)
    -- upvalues: finishBulkOpening (val)
    local v1, v2, v3
    Profiler.mark("UI.Store.StartBulkOpening")
    local v4 = Cases.GetCase(a1)
    if not v4 then
        return
    end
    u266.isBulkOpening = true
    u266.inventoryItems = a2
    u266.bulkIdentifier = a3
    u266.caseId = a1
    u266.total = #a2
    u266.currentIndex = 0
    u266.skipped = false
    CleanupCaseOpeningTweens()
    u257.isOpening = true
    u257.currentInventoryItem = nil
    u253.CaseContent.Visible = false
    local v5 = v4.caseType == "Charm Capsule"

    local function waitForDrag(a1) -- Line: 2359 -- upvalues: u257 (upval), u266 (upval) -- types: a1: function
        local u1 = false
        a1(function() -- Line: 2361 -- upvalues: u1 (ref)
            u1 = true
        end)
        while not u1 do
            if not u257.isOpening or u266.skipped then
                break
            end
            task.wait()
        end
    end

    if not v5 then
        CaseSceneController.TransitionToUnboxing()
        task.wait(0.8)
    else
        waitForDrag(function(a1) -- Line: 2369 -- upvalues: CaseSceneController (upval)
            CaseSceneController.TransitionToUnboxing(a1)
        end)
    end
    if not u257.isOpening or u266.skipped then
        return
    end
    u254.Menu.OpenCase.CaseName.Text = ("Unlock %*"):format(v4.name)
    u254.Menu.OpenCase.Visible = true
    u253.Visible = false
    local v6 = #a2
    for i = 1, v6 do
        if not u257.isOpening or u266.skipped then
            break
        end
        u266.currentIndex = i
        v3 = v7[i]
        v1 = i == #v7
        u254.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE"
        if v5 and i > 1 then
            waitForDrag(function(a1) -- Line: 2392 -- upvalues: CaseSceneController (upval)
                if not CaseSceneController.ArmDragOpening(a1) then
                    a1()
                end
            end)
            if not u257.isOpening or u266.skipped then
                break
            end
        end
        v2 = CaseScroll.RunScrollAnimation(v4, v3)
        if not u257.isOpening or u266.skipped then
            break
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Notification")
        Router.broadcastRouter("RunStoreSound", u214.RARITY_TO_DROP_SOUND[v2 and v2.rarity or "Blue"] or "Drop Blue")
        if v1 then
            task.wait(0.5)
        else
            HoldBulkReveal(1.5)
        end
    end
    if u257.isOpening and not u266.skipped then
        finishBulkOpening()
    end
end

function u276(a1, a2, a3, a4) -- Line: 2421
    -- upvalues: Profiler (val), u261 (ref), CaseSceneController (val), u254 (ref), u262 (ref), u275 (ref), u266 (val)
    -- upvalues: CleanupCaseOpeningTweens (val), u257 (val), u253 (ref), SetConsoleOverlay (val), Router (val)
    -- upvalues: u214 (val), HoldBulkReveal (val), finishBulkOpening (val)
    local v1
    Profiler.mark("UI.Store.StartBulkConsoleOpening")
    if #a3 ~= #a2 then
        u261 = nil
        CaseSceneController.CancelConsoleOpening()
        local Close = u254.Menu.OpenCase.Contents.Close
        if u262 then
            for i2, i3 in ipairs(u262) do
                i3.Visible = true
            end
            Close.TextLabel.Text = "CLOSE"
            u262 = nil
        end
        u275(a1, a2, a4)
        return
    end
    u266.isBulkOpening = true
    u266.inventoryItems = a2
    u266.bulkIdentifier = a4
    u266.caseId = a1
    u266.total = #a2
    u266.currentIndex = 0
    u266.skipped = false
    u261 = nil
    CleanupCaseOpeningTweens()
    u257.isOpening = true
    u257.currentInventoryItem = nil
    u253.CaseContent.Visible = false
    u253.Visible = false
    SetConsoleOverlay(true)
    for i, v in ipairs(a2) do
        if not u257.isOpening or u266.skipped then
            break
        end
        u266.currentIndex = i
        if i > 1 or not CaseSceneController.IsConsoleOpening() then
            CaseSceneController.BeginConsoleOpening()
        end
        local u101 = false
        if not CaseSceneController.ResolveConsoleOpening(v1[i], function() -- Line: 2456 -- upvalues: u101 (ref)
            u101 = true
            return
        end) then
            break
        end
        while u257.isOpening do
            if u266.skipped or u101 then
                break
            end
            task.wait()
        end
        if not u257.isOpening or u266.skipped then
            break
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Notification")
        Router.broadcastRouter(
            "RunStoreSound",
            u214.RARITY_TO_DROP_SOUND[if v.Type == "Melee" then "Special" else if v.Type ~= "Glove" then v.Rarity or "Blue" else "Special"] or "Drop Blue"
        )
        HoldBulkReveal(if i ~= #a2 then 1.5 else 0.5)
    end
    if u257.isOpening and not u266.skipped then
        finishBulkOpening()
    end
end

function u0.BeginOpenCaseRequest(a1) -- Line: 2481 -- upvalues: u258 (ref), u259 (val), u257 (val) -- types: a1: boolean
    u258 = u258 + 1
    local v1 = tostring(u258)
    u259[v1] = {IsQuickUnlock = a1}
    u257.isPendingOpenRequest = true
    u257.pendingOpenRequestId = v1
    u257.isQuickUnlock = a1
    return v1
end

function u0.ClearPendingOpenCaseRequest(a1) -- Line: 2487 -- upvalues: u257 (val) -- types: a1: string
    if u257.pendingOpenRequestId ~= a1 then
        return false
    end
    u257.isPendingOpenRequest = false
    u257.pendingOpenRequestId = nil
    u257.isQuickUnlock = false
    return true
end

local function openCreatorCode() -- Line: 2498
    -- upvalues: u253 (ref), DataController (val), LocalPlayer (val), TweenService (val)
    u253.CreatorCode:SetAttribute("ResponseId", nil)
    u253.CreatorCode.Container.Body.Response.Text = ""
    u253.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM"
    u253.CreatorCode.Container.Body.CreatorName.TextBox.Text = DataController.Get(LocalPlayer, "CreatorCode") or ""
    u253.CreatorCode.Position = UDim2.fromScale(0.5, -1)
    u253.CreatorCode.Visible = true
    u253.Tabs.Visible = false
    TweenService:Create(
        u253.CreatorCode,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.fromScale(0.5, 0.5)}
    ):Play()
end

local function closeCreatorCode() -- Line: 2515 -- upvalues: TweenService (val), u253 (ref)
    TweenService:Create(
        u253.CreatorCode,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.fromScale(0.5, -1)}
    ):Play()
    task.wait(0.35)
    if u253.CreatorCode.Visible then
        u253.CreatorCode.Visible = false
        u253.Tabs.Visible = true
    end
end

function u272(a1) -- Line: 2528
    -- upvalues: CaseSceneController (val), u212 (ref), u211 (ref), u253 (ref), MenuState (val), u254 (ref)
    CaseSceneController.HideCaseScene()
    u212 = nil
    u211 = nil
    u253.CaseContent:SetAttribute("WasVisibleBeforeInspect", false)
    if a1 == "Inventory" then
        MenuState.SetScreen("Inventory")
    end
    u253.Tabs.Container.Visible = true
    u253.CaseContent.Visible = false
    u254.Menu.Top.Visible = true
    u253.Top.Visible = true
    if a1 ~= "Inventory" then
        u253.Visible = true
        return
    end
    u254.Menu.Inventory.Visible = true
    u253.Visible = false
end

function u0.Initialize(a1, a2) -- Line: 2551
    -- upvalues: Profiler (val), u254 (ref), u253 (ref), CaseScroll (val), u257 (val), u214 (val), StarterPack (val)
    -- upvalues: u255 (val), fitCaseGrid (val), ActivateButton (val), Router (val), openCreatorCode (val)
    -- upvalues: CloseButtonRegistry (val), u261 (ref), CaseSceneController (val), u266 (val)
    -- upvalues: CleanupCaseOpeningTweens (val), finishBulkOpening (val), Remotes (val), MenuState (val)
    -- upvalues: TryProcessResolvedCaseOpenQueue (val), u212 (ref), Cases (val), u211 (ref)
    -- upvalues: CollectCaseIdentifiers (val), u258 (ref), u259 (val), SetConsoleOverlay (val), u263 (val), u262 (ref)
    -- upvalues: purchaseCase (val), u272 (ref), closeCreatorCode (val), UpdateCreatorCodeResponse (val)
    -- upvalues: ClearFrame (val), u208 (ref), GuiService (val), IsSelectionUsable (val), u0 (val), RunService (val)
    -- upvalues: Cases_2 (val), DataController (val), LocalPlayer (val), DoCreditPurchase (val)
    -- upvalues: MarketplaceService (val), setupCurrencyFrame (val), LoadProductPrice (val), u207 (ref)
    -- upvalues: DevProducts (val), CommaNumber (val), LoadProductInfo (val), Hover (val)
    -- upvalues: SetupTaggedInspectButtons (val), updateCases (val), StartBackgroundProductLoading (val)
    -- upvalues: RunServiceController (val), CollectionService (val), refreshGiftNavigation (val)
    -- upvalues: PopulateGiftSearchResult (val), u210 (ref), u209 (ref), u195 (val), u200 (val), u205 (val)
    local Price, v1
    Profiler.mark("UI.Store.Initialize")
    u254 = a1
    u253 = a2
    CaseScroll.Bind(u254, u257, u214)
    StarterPack.Bind(u253, u254)
    u255.Label = u253.Tabs.Container.Featured.Container.Console.Pack.Container.Top.Title.Top.Timer
    local Cases_3 = u253.Tabs.Container.Featured.Container.Cases.Container.Cases
    local u38 = false

    local function queueCaseGridFit() -- Line: 2563 -- upvalues: u38 (ref), fitCaseGrid (upval), Cases_3 (val)
        if u38 then
            return
        end
        u38 = true
        task.defer(function() -- Line: 2568 -- upvalues: u38 (upval), fitCaseGrid (upval), Cases_3 (upval)
            u38 = false
            fitCaseGrid(Cases_3)
        end)
    end

    Cases_3.ChildAdded:Connect(queueCaseGridFit)
    Cases_3.ChildRemoved:Connect(queueCaseGridFit)
    ;(Cases_3:GetPropertyChangedSignal("AbsoluteSize")):Connect(queueCaseGridFit)
    if not u38 then
        u38 = true
        task.defer(function() -- Line: 2568 -- upvalues: u38 (ref), fitCaseGrid (upval), Cases_3 (val)
            u38 = false
            fitCaseGrid(Cases_3)
        end)
    end
    if u253.Top.Categories.Visible then
        u253.Top.Categories.Visible = false
    end
    local Container = u253.Tabs.Container.Featured.Container
    local u75 = nil
    local v2 = (u253:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 2588 -- upvalues: u253 (upval), u75 (ref), Container (val)
        if u253.Visible and u75 then
            u75:Disconnect()
            u75 = nil
            Container.CanvasPosition = Vector2.zero
        end
    end)
    ActivateButton(u253.Tabs.Container.Featured.Container.CreatorCode.CreatorCodeButton)
    u253.Tabs.Container.Featured.Container.CreatorCode.CreatorCodeButton.MouseButton1Click:Connect(function() -- Line: 2598 -- upvalues: Router (upval), openCreatorCode (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        openCreatorCode()
    end)
    CloseButtonRegistry.Add(u254.Menu.OpenCase, u254.Menu.OpenCase.Contents.Close, function() -- Line: 2604
        -- upvalues: u261 (upval), CaseSceneController (upval), u266 (upval), CleanupCaseOpeningTweens (upval)
        -- upvalues: finishBulkOpening (upval), u257 (upval), Router (upval), CaseScroll (upval), u254 (upval)
        -- upvalues: Remotes (upval), u253 (upval), MenuState (upval), Profiler (upval)
        -- upvalues: TryProcessResolvedCaseOpenQueue (upval)
        if u261 then
            CaseSceneController.SkipConsoleOpening()
            return
        end
        if u266.isBulkOpening then
            u266.skipped = true
            CleanupCaseOpeningTweens()
            finishBulkOpening()
            return
        end
        if u257.isOpening then
            Router.broadcastRouter("RunStoreSound", "Case Close")
        end
        CleanupCaseOpeningTweens()
        u266.isBulkOpening = false
        u266.inventoryItems = nil
        u266.bulkIdentifier = nil
        u266.currentIndex = 0
        u266.skipped = false
        u266.caseId = nil
        u266.total = 0
        CaseScroll.ResetProgressBar()
        local currentInventoryItem = u257.currentInventoryItem
        u257.isOpening = false
        u257.currentInventoryItem = nil
        CaseSceneController.HideCaseScene()
        u254.Menu.OpenCase.Visible = false
        local currentCaseIdentifier = u257.currentCaseIdentifier
        if currentCaseIdentifier then
            Remotes.Store.CaseOpenSequenceFinished.Send({CaseIdentifier = currentCaseIdentifier})
            u257.currentCaseIdentifier = nil
        end
        u253.Tabs.Container.Visible = true
        u253.CaseContent.Visible = false
        u254.Menu.Top.Visible = true
        u253.Top.Visible = true
        u253.Visible = false
        MenuState.SetScreen("Inventory")
        if currentInventoryItem then
            Router.broadcastRouter(
                "WeaponInspect",
                currentInventoryItem.Name,
                currentInventoryItem.Skin,
                currentInventoryItem.Float,
                currentInventoryItem.StatTrack,
                currentInventoryItem.NameTag,
                currentInventoryItem.Charm,
                currentInventoryItem.Stickers,
                currentInventoryItem.Type,
                currentInventoryItem.Pattern,
                currentInventoryItem._id,
                currentInventoryItem.Serial,
                currentInventoryItem.IsTradeable
            )
            return
        end
        u254.Menu.Inventory.Visible = true
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
    end)
    ActivateButton(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Open)
    u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.MouseButton1Click:Connect(function() -- Line: 2626
        -- upvalues: u212 (upval), u257 (upval), Cases (upval), Router (upval), u211 (upval), u253 (upval)
        -- upvalues: CollectCaseIdentifiers (upval), u258 (upval), u259 (upval), u261 (upval), SetConsoleOverlay (upval)
        -- upvalues: CaseSceneController (upval), Remotes (upval), u214 (upval), u263 (upval), u254 (upval)
        -- upvalues: u262 (upval), Profiler (upval), TryProcessResolvedCaseOpenQueue (upval)
        if u212 and not u257.isOpening and not u257.isPendingOpenRequest then
            local isQuickUnlock, u75, v1, v2
            if not Cases.HasCaseModel(u212.caseId) then
                Router.broadcastRouter("CreateMenuNotification", "Error", "This case can't be opened right now.")
                return
            end
            if not u211 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "Case identifier missing. Please reopen the case.")
                return
            end
            local v3 = u212.caseType == "Console"
            local v4 = tonumber(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text) or 1
            if not (v4 > 1) then
                v1 = {u211}
                isQuickUnlock = not v3
                if isQuickUnlock then
                    isQuickUnlock = false
                    if v4 == 1 then
                        isQuickUnlock = u257.isQuickUnlock
                    end
                end
                v2 = if not (v4 > 1) then if not isQuickUnlock then "Standard" else "Quick Open" else "Bulk"
                u258 = u258 + 1
                u75 = tostring(u258)
                u259[u75] = {IsQuickUnlock = isQuickUnlock}
                u257.isPendingOpenRequest = true
                u257.pendingOpenRequestId = u75
                u257.isQuickUnlock = isQuickUnlock
                if not v3 then
                    Remotes.Store.OpenCase.Send({
                        CaseIdentifiers = v1,
                        OpenType = v2,
                        CaseId = u212.caseId,
                        RequestId = u75,
                    })
                else
                    u261 = u75
                    u257.isOpening = true
                    u257.currentCaseIdentifier = v1[1]
                    u253.CaseContent.Visible = false
                    u253.Visible = false
                    SetConsoleOverlay(true)
                    CaseSceneController.BeginConsoleOpening()
                    Remotes.Store.OpenConsole.Send({CaseIdentifiers = v1, CaseId = u212.caseId, RequestId = u75})
                end
                task.delay(u214.OPEN_CASE_REQUEST_TIMEOUT * (if not (v4 > 1) then 1 else 2), function() -- Line: 2677
                    -- upvalues: u257 (upval), u75 (val), u259 (upval), u261 (upval), u263 (upval)
                    -- upvalues: CaseSceneController (upval), u254 (upval), u262 (upval), u253 (upval), Profiler (upval)
                    -- upvalues: TryProcessResolvedCaseOpenQueue (upval), Router (upval)
                    if u257.isPendingOpenRequest and u257.pendingOpenRequestId == u75 then
                        local v1 = u75
                        if v1 then
                            if u257.pendingOpenRequestId == v1 then
                                u257.isPendingOpenRequest = false
                                u257.pendingOpenRequestId = nil
                                u257.isQuickUnlock = false
                            end
                            u259[v1] = nil
                        end
                        if u261 == u75 then
                            u263[u75] = true
                            u261 = nil
                            u257.isOpening = false
                            u257.currentInventoryItem = nil
                            u257.currentCaseIdentifier = nil
                            CaseSceneController.CancelConsoleOpening()
                            local Close = u254.Menu.OpenCase.Contents.Close
                            if u262 then
                                for i, v in ipairs(u262) do
                                    v.Visible = true
                                end
                                Close.TextLabel.Text = "CLOSE"
                                u262 = nil
                            end
                            u254.Menu.OpenCase.Visible = false
                            u253.Visible = true
                            u253.Tabs.Container.Visible = false
                            u253.CaseContent.Visible = true
                            u254.Menu.Top.Visible = false
                            u253.Top.Visible = false
                        end
                        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
                        Router.broadcastRouter("CreateMenuNotification", "Error", "Opening case timed out. Please try again.")
                    end
                end)
                return
            end
            v1 = CollectCaseIdentifiers(u212.name, v4)
            if #v1 < 2 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "Not enough cases in your inventory.")
                return
            end
            isQuickUnlock = not v3
            if isQuickUnlock then
                isQuickUnlock = false
                if v4 == 1 then
                    isQuickUnlock = u257.isQuickUnlock
                end
            end
            v2 = if not (v4 > 1) then if not isQuickUnlock then "Standard" else "Quick Open" else "Bulk"
            u258 = u258 + 1
            u75 = tostring(u258)
            u259[u75] = {IsQuickUnlock = isQuickUnlock}
            u257.isPendingOpenRequest = true
            u257.pendingOpenRequestId = u75
            u257.isQuickUnlock = isQuickUnlock
            if not v3 then
                Remotes.Store.OpenCase.Send({
                    CaseIdentifiers = v1,
                    OpenType = v2,
                    CaseId = u212.caseId,
                    RequestId = u75,
                })
            else
                u261 = u75
                u257.isOpening = true
                u257.currentCaseIdentifier = v1[1]
                u253.CaseContent.Visible = false
                u253.Visible = false
                SetConsoleOverlay(true)
                CaseSceneController.BeginConsoleOpening()
                Remotes.Store.OpenConsole.Send({CaseIdentifiers = v1, CaseId = u212.caseId, RequestId = u75})
            end
            task.delay(u214.OPEN_CASE_REQUEST_TIMEOUT * (if not (v4 > 1) then 1 else 2), function() -- Line: 2677
                -- upvalues: u257 (upval), u75 (val), u259 (upval), u261 (upval), u263 (upval)
                -- upvalues: CaseSceneController (upval), u254 (upval), u262 (upval), u253 (upval), Profiler (upval)
                -- upvalues: TryProcessResolvedCaseOpenQueue (upval), Router (upval)
                if u257.isPendingOpenRequest and u257.pendingOpenRequestId == u75 then
                    local v1 = u75
                    if v1 then
                        if u257.pendingOpenRequestId == v1 then
                            u257.isPendingOpenRequest = false
                            u257.pendingOpenRequestId = nil
                            u257.isQuickUnlock = false
                        end
                        u259[v1] = nil
                    end
                    if u261 == u75 then
                        u263[u75] = true
                        u261 = nil
                        u257.isOpening = false
                        u257.currentInventoryItem = nil
                        u257.currentCaseIdentifier = nil
                        CaseSceneController.CancelConsoleOpening()
                        local Close = u254.Menu.OpenCase.Contents.Close
                        if u262 then
                            for i, v in ipairs(u262) do
                                v.Visible = true
                            end
                            Close.TextLabel.Text = "CLOSE"
                            u262 = nil
                        end
                        u254.Menu.OpenCase.Visible = false
                        u253.Visible = true
                        u253.Tabs.Container.Visible = false
                        u253.CaseContent.Visible = true
                        u254.Menu.Top.Visible = false
                        u253.Top.Visible = false
                    end
                    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
                    Router.broadcastRouter("CreateMenuNotification", "Error", "Opening case timed out. Please try again.")
                end
            end)
            return
        end
    end)
    ActivateButton(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy)
    u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.MouseButton1Click:Connect(function() -- Line: 2694 -- upvalues: u212 (upval), purchaseCase (upval), u253 (upval)
        if u212 then
            purchaseCase(u212, (tonumber(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text)))
        end
    end)
    ActivateButton(u253.CaseContent.Main.Bottom.Buttons.Close)
    CloseButtonRegistry.Add(u253.CaseContent, u253.CaseContent.Main.Bottom.Buttons.Close, function() -- Line: 2705 -- upvalues: u257 (upval), u272 (upval), u253 (upval)
        if not u257.isPendingOpenRequest then
            u272(if u253.CaseContent:GetAttribute("State") ~= "Inspect" then "Inventory" else "Store")
        end
    end)
    ActivateButton(u253.CreatorCode.Container.Action.Close)
    CloseButtonRegistry.Add(u253.CreatorCode, u253.CreatorCode.Container.Action.Close, closeCreatorCode)
    ActivateButton(u253.CreatorCode.Container.Body.CreatorName.Clear)
    u253.CreatorCode.Container.Body.CreatorName.Clear.MouseButton1Click:Connect(function() -- Line: 2717 -- upvalues: u253 (upval), Remotes (upval)
        u253.CreatorCode.Container.Body.CreatorName.TextBox.Text = ""
        Remotes.UI.EquipCreatorCode.Send({CreatorCode = ""})
    end)
    ActivateButton(u253.CreatorCode.Container.Action.Confirm)
    u253.CreatorCode.Container.Action.Confirm.MouseButton1Click:Connect(function() -- Line: 2724 -- upvalues: u253 (upval), Router (upval), UpdateCreatorCodeResponse (upval), Remotes (upval)
        local Text = u253.CreatorCode.Container.Body.CreatorName.TextBox.Text
        u253.CreatorCode.Container.Action.Confirm.Title.Text = "SEARCHING.."
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        if Text and Text ~= "" then
            Remotes.UI.EquipCreatorCode.Send({CreatorCode = Text})
            return
        end
        UpdateCreatorCodeResponse("Error", "Creator code cannot be empty.")
    end)
    ClearFrame(u253.Gift.Container, {"UICorner", "UIListLayout"})
    CloseButtonRegistry.Add(u253.Gift, u253.Gift.Close, function() -- Line: 2738 -- upvalues: Router (upval), u253 (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u253.Gift.Visible = false
    end)
    ;(u253.Gift:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 2743 -- upvalues: u253 (upval), u208 (upval), GuiService (upval), IsSelectionUsable (upval)
        if not u253.Gift.Visible and u208 then
            GuiService.SelectedObject = if not IsSelectionUsable(u208) then u253.Top.Currency.Credits.Buy else u208
            u208 = nil
            return
        end
    end)
    ActivateButton(u253.Top.Currency.Credits.Buy)
    u253.Top.Currency.Credits.Buy.MouseButton1Click:Connect(function() -- Line: 2755 -- upvalues: u0 (upval)
        u0.OpenTab("Credits")
    end)
    local TradeTokens = u253.Top.Currency.TradeTokens
    TradeTokens.Visible = true
    local PurchaseMore = TradeTokens.PurchaseMore
    ActivateButton(PurchaseMore)
    PurchaseMore.MouseButton1Click:Connect(function() -- Line: 2763 -- upvalues: u0 (upval)
        u0.OpenTab("TradeTokens")
    end)
    for i, j in u253.CaseContent.Main.Bottom.SubButtons.CenterButtons:GetChildren() do
        if j:IsA("ImageButton") then
            ActivateButton(j)
            j.MouseButton1Click:Connect(function() -- Line: 2773
                -- upvalues: u212 (upval), Cases (upval), RunService (upval), Cases_2 (upval), j (val)
                -- upvalues: DataController (upval), LocalPlayer (upval), u214 (upval), DoCreditPurchase (upval)
                -- upvalues: MarketplaceService (upval)
                if not u212 then
                    return
                end
                if not Cases.IsCaseForSale(u212.caseId) and not RunService:IsStudio() then
                    return
                end
                if not Cases.HasCaseModel(u212.caseId) then
                    return
                end
                local v1 = Cases_2[u212.name]
                if not v1 then
                    return
                end
                local v2 = v1.Amounts[tonumber(j.Name)]
                if v2 and v2.Offsale == false then
                    local v3 = DataController.Get(LocalPlayer, "TradeTokens")
                    local BasePrice = v2.BasePrice
                    if math.floor((if not BasePrice then v2.Price or 0 else if not (BasePrice > 0) then v2.Price or 0 else BasePrice) * u214.TRADE_TOKEN_CASE_MARKUP) <= v3 then
                        DoCreditPurchase(u212.name, v2, (tonumber(j.Name)))
                        return
                    end
                    MarketplaceService:PromptProductPurchase(LocalPlayer, v2.ID)
                    return
                end
            end)
        end
    end
    local v3 = {"Credits", "TradeTokens"}
    local v4 = nil
    local v5 = nil
    for k, n in v3, v4, v5 do
        for i2, v in ipairs(u253.Tabs.Container.Featured.Container[n]:GetChildren()) do
            if v:IsA("Frame") then
                v1 = n == "TradeTokens"
                setupCurrencyFrame(v, v1)
            end
        end
    end
    v5 = DoCreditPurchase
    StarterPack.Setup(LoadProductPrice, v5, function() -- Line: 2809 -- upvalues: u207 (upval)
        return u207
    end)
    local Button = u253.Tabs.Container.Featured.Container.Console.Pack:FindFirstChild("Button")
    if Button and Button:IsA("GuiButton") then
        Button.Selectable = false
        Button.Active = false
    end
    for m, i5 in u253.Tabs.Container.Featured.Container.Console.Pack.CenterButtons:GetChildren() do
        if i5:IsA("ImageButton") then
            local u429 = DevProducts[("%* Consoles"):format(i5.Name)]
            if u429 then
                local function u430(a1) -- Line: 2827 -- upvalues: i5 (val), CommaNumber (upval)
                    i5.Container.Title.Text = ("%* %*"):format(utf8.char(57346), (CommaNumber(a1)))
                end

                if u429.Price and u430 then
                    Price = u429.Price
                    i5.Container.Title.Text = ("%* %*"):format(utf8.char(57346), (CommaNumber(Price)))
                end
                LoadProductInfo(u429.DevProductId, function(a1) -- Line: 252 -- upvalues: u429 (val), u430 (val)
                    if a1 and a1.PriceInRobux then
                        local UserBasePriceInRobux = a1.UserBasePriceInRobux or u429.Price
                        u429.BasePrice = UserBasePriceInRobux
                        u429.Price = a1.PriceInRobux
                        if u430 then
                            u430(u429.Price)
                        end
                        return
                    end
                end)
                ActivateButton(i5)
                i5.MouseButton1Click:Connect(function() -- Line: 2832
                    -- upvalues: u207 (upval), DataController (upval), LocalPlayer (upval), u429 (val), u214 (upval)
                    -- upvalues: DoCreditPurchase (upval), i5 (val), MarketplaceService (upval), Router (upval)
                    if u207 then
                        local v1 = DataController.Get(LocalPlayer, "TradeTokens")
                        local v2 = u429
                        local BasePrice = v2.BasePrice
                        if not (math.floor((if not BasePrice then v2.Price or 0 else if not (BasePrice > 0) then v2.Price or 0 else BasePrice) * u214.TRADE_TOKEN_CASE_MARKUP) <= v1) then
                            MarketplaceService:PromptProductPurchase(LocalPlayer, u429.DevProductId)
                        else
                            DoCreditPurchase(("%* Consoles"):format(i5.Name), u429, nil, (tonumber(i5.Name)))
                        end
                        Router.broadcastRouter("RunInterfaceSound", "UI Click")
                    end
                end)
            end
        end
    end
    Hover.Setup(u253, u214)
    for i3, i6 in ipairs(u214.INSPECTABLE_ITEM_TAGS) do
        SetupTaggedInspectButtons(i6)
    end
    updateCases()
    StartBackgroundProductLoading()
    RunServiceController.BindToHeartbeat("UI.Store.Rotaters", function(a1) -- Line: 2858 -- upvalues: Profiler (upval), u254 (upval), u253 (upval), CollectionService (upval)
        Profiler.mark("UI.Store.RotaterHeartbeat")
        if not u254.Menu.Visible then
            return
        end
        if not u253.Visible and not u254.Menu.Dashboard.Visible then
            return
        end
        for i, v in ipairs(CollectionService:GetTagged("StoreRotaterFrame")) do
            v.Rotation = v.Rotation + a1 * 25
        end
    end)
    u253.Gift.Search.TextBox.Focused:Connect(function() -- Line: 2872 -- upvalues: u253 (upval), refreshGiftNavigation (upval)
        local SearchResult = u253.Gift.Container:FindFirstChild("SearchResult")
        if SearchResult then
            SearchResult:Destroy()
        end
        for i, v in ipairs(u253.Gift.Container:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = true
            end
        end
        refreshGiftNavigation()
    end)
    u253.Gift.Search.TextBox.FocusLost:Connect(function() -- Line: 2887 -- upvalues: PopulateGiftSearchResult (upval), u253 (upval), refreshGiftNavigation (upval)
        PopulateGiftSearchResult(u253.Gift.Search.TextBox.Text)
        refreshGiftNavigation()
    end)
    RunServiceController.BindToHeartbeat("UI.Store.TimersAndCredits", function(a1) -- Line: 2893
        -- upvalues: u253 (upval), u254 (upval), u210 (upval), u209 (upval), u0 (upval), StarterPack (upval)
        -- upvalues: Profiler (upval), CommaNumber (upval), u195 (upval), u200 (upval), u205 (upval)
        local v1
        local Visible = u253.Visible
        local Menu = u254 and u254.Menu and u254.Menu.Visible
        if not Visible and not Menu then
            u210 = -1
            u209 = 1
            return
        end
        if Visible then
            v1 = math.floor((workspace:GetServerTimeNow()))
            if v1 ~= u210 then
                u210 = v1
                u0.RefreshFeaturedConsoleTimer(v1)
            end
        end
        u209 = u209 + a1
        if u209 >= 1 then
            u209 = u209 % 1
            v1 = math.floor((workspace:GetServerTimeNow()))
            StarterPack.Refresh(v1)
        end
        if not Visible then
            return
        end
        Profiler.mark("UI.Store.CreditsHeartbeat")
        if not u254.Menu.Visible then
            return
        end
        u253.Top.Currency.Credits.TextLabel.Text = CommaNumber((math.round((u195:getPosition()))))
        u195:update(a1)
        u253.Top.Currency.TradeTokens.TextLabel.Text = CommaNumber((math.round((u200:getPosition()))))
        u200:update(a1)
        u253.Top.Currency.Tickets.TextLabel.Text = CommaNumber((math.round((u205:getPosition()))))
        u205:update(a1)
    end)
end

local function hidePaidCurrencyPurchaseEntryPoints() -- Line: 2939 -- upvalues: u253 (ref)
    u253.Top.Categories.Credits.Visible = false
    u253.Top.Currency.Credits.Buy.Visible = false
    u253.Top.Categories.TradeTokens.Visible = false
    u253.Top.Currency.TradeTokens.PurchaseMore.Visible = false
    u253.Tabs.Container.Featured.Container.Credits.Visible = false
    u253.Tabs.Container.Featured.Container.TradeTokens.Visible = false
end

function u0.GetConsoleVignetteGradient() -- Line: 2950 -- upvalues: u0 (val), u253 (ref)
    local v1 = rawget(u0, "ConsoleVignetteGradient")
    if v1 then
        return v1
    end
    local Console = u253.Tabs.Container.Featured.Container:FindFirstChild("Console")
    local AnimatedVignette = Console and Console:FindFirstChild("AnimatedVignette", true)
    if AnimatedVignette and AnimatedVignette:IsA("ImageLabel") then
        local UIGradient = AnimatedVignette:FindFirstChildOfClass("UIGradient")
        if not UIGradient then
            return nil
        end
        rawset(u0, "ConsoleVignetteImage", AnimatedVignette)
        rawset(u0, "ConsoleVignetteGradient", UIGradient)
        local v2 = u0
        local Rotation = UIGradient.Rotation
        rawset(v2, "ConsoleVignetteDefaultRotation", Rotation)
        v2 = u0
        local Transparency = UIGradient.Transparency
        rawset(v2, "ConsoleVignetteDefaultTransparency", Transparency)
        v2 = u0
        local ImageTransparency = AnimatedVignette.ImageTransparency
        rawset(v2, "ConsoleVignetteDefaultImageTransparency", ImageTransparency)
        return UIGradient
    end
    return nil
end

function u0.SetConsoleVignettePulse(a1) -- Line: 2977 -- upvalues: u0 (val) -- types: a1: number
    local v1 = rawget(u0, "ConsoleVignetteGradient")
    if v1 then
        v1.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, 0.9 - a1 * 0.1),
            NumberSequenceKeypoint.new(0.45, 0.55 - a1 * 0.3),
            NumberSequenceKeypoint.new(0.58, 0.38 - a1 * 0.22),
            NumberSequenceKeypoint.new(0.82, 0.78 - a1 * 0.16),
            (NumberSequenceKeypoint.new(1, 1)),
        })
    end
    local v2 = rawget(u0, "ConsoleVignetteImage")
    if v2 then
        v2.ImageTransparency = 0.58 - a1 * 0.16
    end
end

u214.CONSOLE_VIGNETTE_CLEANUP = {
    {"ConsoleVignetteTween", "Cancel"},
    {"ConsoleVignettePulseTween", "Cancel"},
    {"ConsoleVignettePulseConnection", "Disconnect"},
    {"ConsoleVignettePulseValue", "Destroy"},
}

function u0.StopConsoleVignetteTween() -- Line: 3005 -- upvalues: u214 (val), u0 (val)
    local v1, v2, v3
    for i, j in u214.CONSOLE_VIGNETTE_CLEANUP do
        v1 = j[1]
        v2 = j[2]
        v3 = rawget(u0, v1)
        if v3 then
            v3[v2](v3)
            rawset(u0, v1, nil)
        end
    end
    local v4 = rawget(u0, "ConsoleVignetteGradient")
    if v4 then
        v4.Rotation = rawget(u0, "ConsoleVignetteDefaultRotation") or -180
        local Transparency = rawget(u0, "ConsoleVignetteDefaultTransparency") or v4.Transparency
        v4.Transparency = Transparency
    end
    local v5 = rawget(u0, "ConsoleVignetteImage")
    if v5 then
        v5.ImageTransparency = rawget(u0, "ConsoleVignetteDefaultImageTransparency") or 0.5
    end
end

function u0.UpdateConsoleVignetteTween() -- Line: 3029 -- upvalues: u253 (ref), u0 (val), TweenService (val)
    if not u253.Visible then
        u0.StopConsoleVignetteTween()
        return
    end
    local v1 = u0
    if rawget(v1, "ConsoleVignetteTween") then
        return
    end
    local v2 = u0.GetConsoleVignetteGradient()
    if not v2 then
        return
    end
    local v3 = u0
    v2.Rotation = rawget(v3, "ConsoleVignetteDefaultRotation") or -180
    v1 = TweenService:Create(v2, TweenInfo.new(14, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = v2.Rotation + 360})
    v3 = u0
    rawset(v3, "ConsoleVignetteTween", v1)
    v1:Play()
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = 0
    local v4 = u0
    rawset(v4, "ConsoleVignettePulseValue", NumberValue)
    v4 = u0
    local v5 = (NumberValue:GetPropertyChangedSignal("Value")):Connect(function() -- Line: 3059 -- upvalues: u0 (upval), NumberValue (val)
        u0.SetConsoleVignettePulse(NumberValue.Value)
    end)
    rawset(v4, "ConsoleVignettePulseConnection", v5)
    u0.SetConsoleVignettePulse(0)
    v3 = TweenService:Create(NumberValue, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Value = 1})
    local v6 = u0
    rawset(v6, "ConsoleVignettePulseTween", v3)
    v3:Play()
end

local function BindAmountButtonHover(a1) -- Line: 3076 -- types: a1: userdata
    a1.MouseEnter:Connect(function() -- Line: 3077 -- upvalues: a1 (val)
        if not a1:GetAttribute("Selected") then
            a1.Frame.BackgroundTransparency = 0.5
        end
    end)
    a1.MouseLeave:Connect(function() -- Line: 3082 -- upvalues: a1 (val)
        if not a1:GetAttribute("Selected") then
            a1.Frame.BackgroundTransparency = 1
        end
    end)
end

function u0.Start() -- Line: 3089
    -- upvalues: Profiler (val), DataController (val), LocalPlayer (val), ReplicatedStorage (val), u255 (val), u0 (val)
    -- upvalues: PolicyService (val), u207 (ref), hidePaidCurrencyPurchaseEntryPoints (val), u253 (ref)
    -- upvalues: ActivateCategoryButton (val), MenuState (val), u214 (val), u213 (ref), GamepadNavigation (val)
    -- upvalues: ActivateButton (val), BindAmountButtonHover (val), u212 (ref), CommaNumber (val)
    -- upvalues: SelectAmountButton (val), refreshGiftNavigation (val), GuiService (val), StarterPack (val), u195 (val)
    -- upvalues: RefreshCaseAmountButtons (val), u200 (val), u205 (val), Constants (val), Cases (val)
    -- upvalues: RefreshCaseListings (val), Remotes (val), UpdateCreatorCodeResponse (val), closeCreatorCode (val)
    -- upvalues: u259 (val), u257 (val), u260 (val), TryProcessResolvedCaseOpenQueue (val), u263 (val), u261 (ref)
    -- upvalues: u276 (ref), u264 (ref), CaseSceneController (val), u254 (ref), u262 (ref), IsSelectionUsable (val)
    -- upvalues: Observers (val), activateGiftTemplate (val)
    debug.setmemorycategory("UI.Store.Start")
    Profiler.mark("UI.Store.Start.Begin")
    DataController.WaitForDataLoaded(LocalPlayer)
    Profiler.mark("UI.Store.Start.DataLoaded")
    ;(require(ReplicatedStorage.Controllers.TimerController)).ListenToTimerChanged(u255.Source, function(a1) -- Line: 3096 -- upvalues: u255 (upval), u0 (upval)
        u255.Tick = a1
        u255.ReceivedAt = math.floor((workspace:GetServerTimeNow()))
        u0.RefreshFeaturedConsoleTimer(u255.ReceivedAt)
    end)
    local success, result = pcall(function() -- Line: 3102 -- upvalues: PolicyService (upval), LocalPlayer (upval)
        return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer)
    end)
    Profiler.mark("UI.Store.Start.PolicyLoaded")
    if success and result then
        u207 = not result.ArePaidRandomItemsRestricted
    end
    if not u207 then
        hidePaidCurrencyPurchaseEntryPoints()
    end
    ;(u253:GetPropertyChangedSignal("Visible")):Connect(u0.UpdateConsoleVignetteTween)
    u0.UpdateConsoleVignetteTween()
    for i, v in ipairs(u253.Top.Categories:GetChildren()) do
        if v:IsA("ImageButton") then
            ActivateCategoryButton(v)
            v.MouseButton1Click:Connect(function() -- Line: 3123 -- upvalues: u0 (upval), v (val)
                u0.OpenTab(v.Name)
            end)
        end
    end
    local v1 = u253
    MenuState.RegisterBumperOverride(v1, function(a1) -- Line: 3132
        -- upvalues: u253 (upval), MenuState (upval), u214 (upval), u213 (upval), u0 (upval), GamepadNavigation (upval)
        if not u253.Tabs.Visible then
            return false
        end
        local u14 = MenuState.GetNextBumperTab(u253.Top.Categories, u214.TAB_ORDER, u213, a1)
        if u14 and u14 ~= u213 then
            task.spawn(function() -- Line: 3141
                -- upvalues: u0 (upval), u14 (val), u253 (upval), u213 (upval), MenuState (upval)
                -- upvalues: GamepadNavigation (upval)
                u0.OpenTab(u14)
                local v1 = u253.Tabs.Container.Featured.Container:FindFirstChild(u14)
                if u213 == u14
                    and v1
                    and MenuState.IsSelectionWithin(u253.Tabs)
                    and not MenuState.IsSelectionWithin(v1) then
                    GamepadNavigation.Focus(v1)
                end
            end)
        end
        return true
    end, u253, u253.Tabs)
    ActivateButton(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount)
    u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.MouseButton1Click:Connect(function() -- Line: 3162 -- upvalues: u253 (upval), Profiler (upval)
        local Container = u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container
        Container.Visible = not Container.Visible
        if not Container.Visible then
            u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 180
            return
        end
        u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 0
        local Scroll = Container.Scroll
        Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 519 -- upvalues: Scroll (val)
            Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, (math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteWindowSize.Y)))
        end)
    end)
    ActivateButton(u253.CaseContent.Main.Odds.Frame.Close)
    ActivateButton(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds)
    u253.CaseContent.Main.Odds.Frame.Close.MouseButton1Click:Connect(function() -- Line: 3177 -- upvalues: u253 (upval)
        u253.CaseContent.Main.Odds.Visible = false
    end)
    u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds.MouseButton1Click:Connect(function() -- Line: 3181 -- upvalues: u253 (upval)
        u253.CaseContent.Main.Odds.Visible = true
    end)
    for i2, i3 in ipairs(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll:GetChildren()) do
        if i3:IsA("TextButton") then
            BindAmountButtonHover(i3)
            i3.MouseButton1Click:Connect(function() -- Line: 3191
                -- upvalues: u212 (upval), i3 (val), u253 (upval), CommaNumber (upval), SelectAmountButton (upval)
                local v1 = u212.price * tonumber(i3.Name)
                u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = ("BUY <font color=\"#ffda0f\">(%*)</font>"):format((CommaNumber(v1)))
                u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = tostring(i3.Name)
                u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Visible = false
                SelectAmountButton(u253.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll, i3)
            end)
        end
    end
    u253.Gift.Amount.MouseButton1Click:Connect(function() -- Line: 3204 -- upvalues: u253 (upval), Profiler (upval), refreshGiftNavigation (upval)
        local Container = u253.Gift.Amount.Container
        Container.Visible = not Container.Visible
        if not Container.Visible then
            u253.Gift.Amount.Header.ImageLabel.Rotation = 180
        else
            u253.Gift.Amount.Header.ImageLabel.Rotation = 0
            Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 519 -- upvalues: Container (val)
                Container.CanvasPosition = Vector2.new(Container.CanvasPosition.X, (math.max(0, Container.AbsoluteCanvasSize.Y - Container.AbsoluteWindowSize.Y)))
            end)
        end
        refreshGiftNavigation()
    end)
    for i4, j in ipairs(u253.Gift.Amount.Container:GetChildren()) do
        if j:IsA("TextButton") then
            BindAmountButtonHover(j)
            j.MouseButton1Click:Connect(function() -- Line: 3220
                -- upvalues: u253 (upval), j (val), GuiService (upval), SelectAmountButton (upval)
                -- upvalues: refreshGiftNavigation (upval)
                u253.Gift.Amount.Header.TextLabel.Text = tostring(j.Name)
                local v1 = GuiService.SelectedObject == j
                u253.Gift.Amount.Container.Visible = false
                SelectAmountButton(u253.Gift.Amount.Container, j)
                if v1 then
                    GuiService.SelectedObject = u253.Gift.Amount
                end
                refreshGiftNavigation()
            end)
        end
    end
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Statistics.OpenShopTime", function(a1) -- Line: 3233 -- upvalues: StarterPack (upval)
        StarterPack.OnOpenShopTimeChanged(a1)
    end)
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Gamepasses", function() -- Line: 3237 -- upvalues: StarterPack (upval)
        StarterPack.Refresh()
    end)
    MenuState.OnScreenChanged:Connect(function(a1, a2) -- Line: 3241 -- upvalues: StarterPack (upval)
        if a2 == "Store" then
            StarterPack.HandleStoreOpened()
        end
    end)
    if MenuState.GetCurrentScreen() ~= "Store" then
        StarterPack.Refresh()
    else
        StarterPack.HandleStoreOpened()
    end
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Credits", function(a1) -- Line: 3254 -- upvalues: u195 (upval), RefreshCaseAmountButtons (upval)
        u195:setGoal(a1)
        RefreshCaseAmountButtons()
    end)
    v1 = LocalPlayer
    DataController.CreateListener(v1, "TradeTokens", function(a1) -- Line: 3260 -- upvalues: u200 (upval)
        u200:setGoal(a1)
    end)
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Exclusive Raffle Ticket", function(a1) -- Line: 3265 -- upvalues: u205 (upval)
        u205:setGoal(a1)
    end)
    task.defer(function() -- Line: 3270
        -- upvalues: u253 (upval), u214 (upval), DataController (upval), LocalPlayer (upval), Constants (upval)
        local Credits = u253.Tabs.Container.Featured.Container:WaitForChild("Credits")
        local u12 = Credits:FindFirstChild("+ 67,500 Credits")
        if not u12 then
            return
        end
        local Size = Credits.Size
        local u29 = UDim2.new(
            Size.X.Scale,
            Size.X.Offset,
            Size.Y.Scale * u214.MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO,
            Size.Y.Offset * u214.MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO
        )

        local function SetMintReserveVisible(a1) -- Line: 3285
            -- upvalues: Credits (val), Size (val), u29 (val), u12 (val)
            Credits.Size = if not a1 then u29 else Size
            u12.Visible = a1
        end

        Credits.Size = u29
        u12.Visible = false
        local v1 = LocalPlayer
        DataController.CreateListener(v1, "Statistics.RobuxSpent", function(a1) -- Line: 3291 -- upvalues: Constants (upval), Credits (val), Size (val), u29 (val), u12 (val)
            local v1 = tonumber(a1)
            v1 = Constants.MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION <= (v1 or 0)
            Credits.Size = if not v1 then u29 else Size
            u12.Visible = v1
        end)
    end)
    Cases.ObserveAvailableCases(RefreshCaseListings)
    Remotes.UI.UpdateCreatorCode.Listen(function(a1) -- Line: 3301 -- upvalues: u253 (upval), UpdateCreatorCodeResponse (upval), closeCreatorCode (upval)
        u253.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM"
        UpdateCreatorCodeResponse(a1.Type, a1.Text)
        if a1.Type == "Success" and u253.CreatorCode.Visible then
            task.delay(1, function() -- Line: 3306 -- upvalues: u253 (upval), closeCreatorCode (upval)
                if u253.CreatorCode.Visible then
                    closeCreatorCode()
                end
            end)
        end
    end)
    Remotes.Store.CaseOpened.Listen(function(a1) -- Line: 3315
        -- upvalues: Profiler (upval), DataController (upval), LocalPlayer (upval), u259 (upval), u257 (upval)
        -- upvalues: u260 (upval), TryProcessResolvedCaseOpenQueue (upval)
        local v1
        Profiler.mark("UI.Store.CaseOpenedRemote")
        if a1.InventoryItems and #a1.InventoryItems > 0 then
            DataController.ApplyInventoryDelta(LocalPlayer, a1.InventoryItems, a1.DeletedCaseIds)
        end
        local RequestId_2 = if typeof(a1.RequestId) ~= "string" then nil else a1.RequestId
        local v2 = RequestId_2 and u259[RequestId_2]
        if v2 then
            if RequestId_2 then
                if u257.pendingOpenRequestId == RequestId_2 then
                    u257.isPendingOpenRequest = false
                    u257.pendingOpenRequestId = nil
                    u257.isQuickUnlock = false
                end
                u259[RequestId_2] = nil
            end
            v1 = v2
        else
            v1 = nil
        end
        if RequestId_2 and not v1 then
            return
        end
        local v3 = {
            CaseId = a1.CaseId,
            InventoryItems = a1.InventoryItems,
            CaseIdentifier = a1.CaseIdentifier,
        }
        v3.IsQuickUnlock = v1 and v1.IsQuickUnlock or false
        v3.RequestId = RequestId_2
        table.insert(u260, v3)
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
    end)
    Remotes.Store.ConsoleOpened.Listen(function(a1) -- Line: 3337
        -- upvalues: Profiler (upval), DataController (upval), LocalPlayer (upval), u263 (upval), u261 (upval)
        -- upvalues: u259 (upval), u257 (upval), u260 (upval), TryProcessResolvedCaseOpenQueue (upval), u276 (upval)
        -- upvalues: u264 (upval), CaseSceneController (upval)
        local u61, v1, v2
        Profiler.mark("UI.Store.ConsoleOpenedRemote")
        DataController.ApplyInventoryDelta(LocalPlayer, a1.InventoryItems, a1.DeletedCaseIds)
        local ConsoleOutcomes = a1.ConsoleOutcomes
        if not ConsoleOutcomes then
            if a1.ConsoleOutcome then
                ConsoleOutcomes = {a1.ConsoleOutcome}
            end
        elseif #ConsoleOutcomes == 0 and a1.ConsoleOutcome then
            ConsoleOutcomes = {a1.ConsoleOutcome}
        end
        local RequestId = a1.RequestId
        local v3 = RequestId and u263[RequestId] == true
        if u261 ~= RequestId and not v3 then
            return
        end
        if v3 then
            u263[RequestId] = nil
            u61 = a1.InventoryItems[1]
            if v3 then
                table.insert(u260, {
                    IsQuickUnlock = false,
                    IsConsole = true,
                    CaseId = a1.CaseId,
                    InventoryItems = a1.InventoryItems,
                    CaseIdentifier = a1.CaseIdentifier,
                    RequestId = RequestId,
                    ConsoleOutcomes = ConsoleOutcomes,
                })
                Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
                return
            end
            if #a1.InventoryItems > 1 then
                u261 = nil
                u276(a1.CaseId, a1.InventoryItems, ConsoleOutcomes or {}, a1.CaseIdentifier)
                return
            end
            u257.currentInventoryItem = u61
            u257.currentCaseIdentifier = a1.CaseIdentifier
            v2 = ConsoleOutcomes and ConsoleOutcomes[1]
            if not v2 then
                u264(u61, a1.CaseIdentifier)
                return
            end
            if not CaseSceneController.ResolveConsoleOpening(v2, function() -- Line: 3380 -- upvalues: u264 (upval), u61 (val), a1 (val)
                local v0
                u264(u61, a1.CaseIdentifier)
                return
            end) then
                u264(u61, a1.CaseIdentifier)
            end
            return
        end
        v2 = RequestId and u259[RequestId]
        if v2 then
            if RequestId then
                if u257.pendingOpenRequestId == RequestId then
                    u257.isPendingOpenRequest = false
                    u257.pendingOpenRequestId = nil
                    u257.isQuickUnlock = false
                end
                u259[RequestId] = nil
            end
            v1 = v2
        else
            v1 = nil
        end
        if not v1 then
            return
        end
        u61 = a1.InventoryItems[1]
        if v3 then
            table.insert(u260, {
                IsQuickUnlock = false,
                IsConsole = true,
                CaseId = a1.CaseId,
                InventoryItems = a1.InventoryItems,
                CaseIdentifier = a1.CaseIdentifier,
                RequestId = RequestId,
                ConsoleOutcomes = ConsoleOutcomes,
            })
            Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
            return
        end
        if #a1.InventoryItems > 1 then
            u261 = nil
            u276(a1.CaseId, a1.InventoryItems, ConsoleOutcomes or {}, a1.CaseIdentifier)
            return
        end
        u257.currentInventoryItem = u61
        u257.currentCaseIdentifier = a1.CaseIdentifier
        v2 = ConsoleOutcomes and ConsoleOutcomes[1]
        if not v2 then
            u264(u61, a1.CaseIdentifier)
            return
        end
        if not CaseSceneController.ResolveConsoleOpening(v2, function() -- Line: 3380 -- upvalues: u264 (upval), u61 (val), a1 (val)
            local v0
            u264(u61, a1.CaseIdentifier)
            return
        end) then
            u264(u61, a1.CaseIdentifier)
        end
    end)
    Remotes.Store.CaseOpenDenied.Listen(function(a1) -- Line: 3389
        -- upvalues: u257 (upval), u259 (upval), u263 (upval), u261 (upval), CaseSceneController (upval), u254 (upval)
        -- upvalues: u262 (upval), u253 (upval), Profiler (upval), TryProcessResolvedCaseOpenQueue (upval)
        local RequestId = a1.RequestId
        if RequestId then
            if u257.pendingOpenRequestId == RequestId then
                u257.isPendingOpenRequest = false
                u257.pendingOpenRequestId = nil
                u257.isQuickUnlock = false
            end
            u259[RequestId] = nil
        end
        if RequestId then
            u263[RequestId] = nil
        end
        if u261 ~= RequestId then
            Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
            return
        end
        u261 = nil
        u257.isOpening = false
        u257.currentInventoryItem = nil
        u257.currentCaseIdentifier = nil
        CaseSceneController.CancelConsoleOpening()
        local Close = u254.Menu.OpenCase.Contents.Close
        if u262 then
            for i, v in ipairs(u262) do
                v.Visible = true
            end
            Close.TextLabel.Text = "CLOSE"
            u262 = nil
        end
        u254.Menu.OpenCase.Visible = false
        u253.Visible = true
        u253.Tabs.Container.Visible = false
        u253.CaseContent.Visible = true
        u254.Menu.Top.Visible = false
        u253.Top.Visible = false
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue)
    end)
    MenuState.OnInspectStateChanged:Connect(function(a1) -- Line: 3404
        -- upvalues: Profiler (upval), TryProcessResolvedCaseOpenQueue (upval), MenuState (upval), u253 (upval)
        -- upvalues: CaseSceneController (upval), u212 (upval), u254 (upval)
        if not a1 then
            Profiler.defer("UI.Store.InspectClosedDeferred", function() -- Line: 3406
                -- upvalues: TryProcessResolvedCaseOpenQueue (upval), MenuState (upval), u253 (upval)
                -- upvalues: CaseSceneController (upval), u212 (upval), u254 (upval)
                if TryProcessResolvedCaseOpenQueue() then
                    return
                end
                local v1 = MenuState.GetCurrentScreen()
                local v2 = u253.CaseContent:GetAttribute("WasVisibleBeforeInspect") == true
                local v3 = CaseSceneController.IsActive()
                if u212 and v1 == "Store" and v2 and v3 then
                    u253.Visible = true
                    u253.Tabs.Container.Visible = false
                    u253.CaseContent.Visible = true
                    u254.Menu.Top.Visible = false
                    u253.Top.Visible = false
                    MenuState.SetBlurEnabled(false)
                    local v4 = MenuState.GetMenuFrame()
                    if not v4 then
                        return
                    end
                    v4.BackgroundTransparency = 1
                    return
                end
                if u253.CaseContent.Visible and v1 == "Inventory" then
                    u253.Visible = true
                    u253.Tabs.Container.Visible = false
                    u253.CaseContent.Visible = true
                    u254.Menu.Top.Visible = false
                    u253.Top.Visible = false
                    local Inventory = u254.Menu:FindFirstChild("Inventory")
                    if Inventory then
                        Inventory.Visible = false
                    end
                    MenuState.SetBlurEnabled(false)
                    local v5 = MenuState.GetMenuFrame()
                    if v5 then
                        v5.BackgroundTransparency = 1
                    end
                    if not CaseSceneController.IsActive() and u212 then
                        CaseSceneController.ShowCaseScene(u212.caseType, u212.name)
                    end
                end
            end)
        end
    end)
    ActivateButton(u253.CaseContent.Main.ItemOddsFrame.Close)
    u253.CaseContent.Main.ItemOddsFrame.Close.MouseButton1Click:Connect(function() -- Line: 3446 -- upvalues: u253 (upval)
        u253.CaseContent.Main.ItemOddsFrame.Visible = false
    end)
    local Main = u253.CaseContent.Main
    local Odds = Main.Odds
    local ItemOddsFrame = Main.ItemOddsFrame
    local Container = Odds.Frame.Container
    local u292 = nil
    ItemOddsFrame.Active = true
    ;(Odds:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 3463 -- upvalues: Main (val), Odds (val), ItemOddsFrame (val), Container (val)
        local Container_2 = Main.CaseContent.Container
        local Visible = Odds.Visible or ItemOddsFrame.Visible
        Container_2.Interactable = not Visible
        Container.Interactable = not ItemOddsFrame.Visible
    end)
    ;(ItemOddsFrame:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 3469
        -- upvalues: GuiService (upval), ItemOddsFrame (val), Container (val), u292 (ref), Main (val), Odds (val)
        -- upvalues: IsSelectionUsable (upval)
        local SelectedObject = GuiService.SelectedObject
        if ItemOddsFrame.Visible then
            if SelectedObject and SelectedObject:IsDescendantOf(Container) then
                u292 = SelectedObject
                GuiService.SelectedObject = ItemOddsFrame.Close
            end
            local Container_2 = Main.CaseContent.Container
            local Visible = Odds.Visible or ItemOddsFrame.Visible
            Container_2.Interactable = not Visible
            Container.Interactable = not ItemOddsFrame.Visible
            return
        end
        local Container_3 = Main.CaseContent.Container
        local Visible_2 = Odds.Visible or ItemOddsFrame.Visible
        Container_3.Interactable = not Visible_2
        Container.Interactable = not ItemOddsFrame.Visible
        local v1 = u292
        u292 = nil
        if SelectedObject == nil then
            if IsSelectionUsable(v1) then
                GuiService.SelectedObject = v1
            end
        elseif SelectedObject:IsDescendantOf(ItemOddsFrame) and IsSelectionUsable(v1) then
            GuiService.SelectedObject = v1
        end
    end)
    local Container_2 = Main.CaseContent.Container
    local Visible = Odds.Visible or ItemOddsFrame.Visible
    Container_2.Interactable = not Visible
    Container.Interactable = not ItemOddsFrame.Visible
    Observers.observePlayer(function(a1) -- Line: 3491
        -- upvalues: LocalPlayer (upval), ReplicatedStorage (upval), u253 (upval), activateGiftTemplate (upval)
        -- upvalues: refreshGiftNavigation (upval)
        if LocalPlayer == a1 then
            return function() end
        end
        local u10 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone()
        u10.Player.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(a1.UserId)
        u10.Player.Username.Text = ("@%*"):format(a1.Name)
        u10.Parent = u253.Gift.Container
        u10.Name = tostring(a1.UserId)
        activateGiftTemplate(u10, a1.UserId)
        refreshGiftNavigation()
        return function() -- Line: 3502 -- upvalues: u10 (val), refreshGiftNavigation (upval)
            u10:Destroy()
            refreshGiftNavigation()
        end
    end)
end

return u0