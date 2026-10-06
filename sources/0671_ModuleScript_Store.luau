-- Decompiled with Potassium's decompiler.

local u1 = {};
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local PolicyService = game:GetService("PolicyService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
require(ReplicatedStorage.Database.Custom.ConsoleTypes);
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
local TradeTokens = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Spring = require(ReplicatedStorage.Shared.Spring);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local script_CaseScroll = require(script.CaseScroll);
local script_Hover = require(script.Hover);
local script_StarterPack = require(script.StarterPack);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local Gamepasses = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.Gamepasses);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Cases2 = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.Cases);
local u2 = Spring.new(1, 8, 0);
local u3 = Spring.new(1, 8, 0);
local u4 = Spring.new(1, 8, 0);
local LocalPlayer = Players.LocalPlayer;
local u5 = true;
local u6 = nil;
local u7 = 1;
local u8 = -1;
local u9 = nil;
local u10 = nil;
local u11 = "Console";
local u12 = {
    TAB_ORDER = { "Console", "Cases", "Credits", "TradeTokens", "CreatorCode" },
    TRADE_TOKEN_PACKAGES = table.freeze({ {
            Amount = 400,
            ProductName = "+ 400 Trade Tokens"
        }, {
            Amount = 800,
            ProductName = "+ 800 Trade Tokens"
        }, {
            Amount = 1700,
            ProductName = "+ 1,700 Trade Tokens"
        }, {
            Amount = 4500,
            ProductName = "+ 4,500 Trade Tokens"
        }, {
            Amount = 10000,
            ProductName = "+ 10,000 Trade Tokens"
        }, {
            Amount = 22500,
            ProductName = "+ 22,500 Trade Tokens"
        } }),
    TRADE_TOKEN_CASE_MARKUP = 1.15,
    CASE_SCROLL_ITEM_COUNT = 75,
    CASE_SCROLL_WINNING_INDEX = 55,
    CASE_SCROLL_DURATION = 7,
    CASE_SCROLL_ITEM_PADDING = 8,
    CASE_SCROLL_ITEM_WIDTH = 215,
    OPEN_CASE_REQUEST_TIMEOUT = 12,
    PROGRESS_BAR_LOOPS = 4,
    MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO = 0.738575,
    INSPECTABLE_ITEM_TAGS = { "StoreBonusItem", "ConsoleItemTemplate" },
    STORE_HOVER_BUTTON_TAG = "StoreHoverButton",
    STORE_HOVER_MOUSE_OFFSET = Vector2.new(16, 16),
    STORE_HOVER_PADDING = 8,
    DEFAULT_CASE_ICON = "rbxassetid://132217734282843",
    SPECIAL_CASE_ICONS = {
        apex_case = "rbxassetid://110520095994318",
        chrysalis = "rbxassetid://127888213250008"
    },
    RARITY_PRIORITY = {
        Blue = 1,
        Purple = 2,
        Pink = 3,
        Red = 4,
        Special = 5
    }
};
local u13 = nil;
local u14 = nil;
local u15 = {
    Source = "FeaturedConsoleTimer",
    Label = nil,
    Tick = 0,
    ReceivedAt = 0
};
local u16 = {};
local u17 = {
    isOpening = false,
    isPendingOpenRequest = false,
    isQuickUnlock = false,
    currentTween = nil,
    currentZoomTween = nil,
    renderConnection = nil,
    viewportConnection = nil,
    currentInventoryItem = nil,
    currentCaseIdentifier = nil,
    pendingOpenRequestId = nil,
    progressRightTween = nil,
    progressRightProxy = nil
};
local u18 = 0;
local u19 = {};
local u20 = {};
local u21 = nil;
local u22 = nil;
local u23 = {};
local u24 = nil;
u12.RARITY_TO_DROP_SOUND = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue"
};
local u25 = {
    inventoryItems = nil,
    bulkIdentifier = nil,
    caseId = nil,
    isBulkOpening = false,
    currentIndex = 0,
    skipped = false,
    total = 0
};
local Color3_fromRGB_ret = Color3.fromRGB(255, 244, 200);
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;

local function LoadProductInfo(u31, p32) -- Line: 229
    -- upvalues: u16 (copy), MarketplaceService (copy)
    if u16[u31] then
        table.insert(u16[u31], p32);

        return;
    end;

    u16[u31] = { p32 };
    task.spawn(function() -- Line: 236
        -- upvalues: MarketplaceService (ref), u31 (copy), u16 (ref)
        local success, result = pcall(function() -- Line: 237
            -- upvalues: MarketplaceService (ref), u31 (ref)
            return MarketplaceService:GetProductInfoAsync(u31, Enum.InfoType.Product);
        end);
        local v33 = u16[u31];
        u16[u31] = nil;

        for _, v in v33 do
            task.defer(v, success and result and result or nil);
        end;
    end);
end;

local function LoadProductPrice(u34, u35) -- Line: 248
    -- upvalues: LoadProductInfo (copy)
    if u34.Price and u35 then
        u35(u34.Price);
    end;

    LoadProductInfo(u34.DevProductId, function(p36) -- Line: 252
        -- upvalues: u34 (copy), u35 (copy)
        if not (p36 and p36.PriceInRobux) then
            return;
        end;

        u34.BasePrice = p36.UserBasePriceInRobux or u34.Price;
        u34.Price = p36.PriceInRobux;

        if u35 then
            u35(u34.Price);
        end;
    end);
end;

local function GetCaseTokenPrice(p37) -- Line: 264
    -- upvalues: u12 (copy)
    local BasePrice = p37.BasePrice;

    return math.floor(((not BasePrice or BasePrice <= 0) and (p37.Price or 0) or BasePrice) * u12.TRADE_TOKEN_CASE_MARKUP);
end;

local function DoCreditPurchase(u38: string, p39: table, u40: number?, u41: number?) -- Line: 271
    -- upvalues: u13 (ref), DataController (copy), LocalPlayer (copy), CommaNumber (copy), u12 (copy), TradeTokens (copy), ActivateButton (copy), MarketplaceService (copy), Remotes (copy), u10 (ref)
    if u13:FindFirstChild("CurrentConfirm") then
        return;
    end;

    local u42 = p39.DevProductId or p39.ID;

    if u42 == nil then
        return;
    end;

    local v43 = DataController.Get(LocalPlayer, "TradeTokens") or 0;
    local u44 = u13.Purchase:Clone();
    u44.Name = "CurrentConfirm";
    u44.Main.Header.Title.Text = u38;
    u44.Main.Info.Frame.Credits.TextLabel.Text = CommaNumber(v43);
    u44.Main.Info.Robux.Credits.Amount.Text = CommaNumber(p39.Price or 0);
    local Amount = u44.Main.Info.TradeTokens.Credits.Amount;
    local v45;

    if u40 or u41 then
        local BasePrice = p39.BasePrice;
        v45 = CommaNumber((math.floor(((not BasePrice or BasePrice <= 0) and (p39.Price or 0) or BasePrice) * u12.TRADE_TOKEN_CASE_MARKUP))) or u44.Main.Info.Robux.Credits.Amount.Text;
    else
        v45 = u44.Main.Info.Robux.Credits.Amount.Text;
    end;

    Amount.Text = v45;
    u44.Visible = true;
    u44.Parent = u13;

    if TradeTokens[u38] and TradeTokens[u38].Price then
        u44.Main.Info.TradeTokens.Credits.Amount.Text = CommaNumber(TradeTokens[u38].Price);
    end;

    ActivateButton(u44.Main.Action.Frame.Close);
    u44.Main.Action.Frame.Close.MouseButton1Click:Connect(function() -- Line: 296
        -- upvalues: u44 (copy)
        u44:Destroy();
    end);
    ActivateButton(u44.Main.Info.Robux);
    u44.Main.Info.Robux.MouseButton1Click:Connect(function() -- Line: 301
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u42 (copy), u44 (copy)
        MarketplaceService:PromptProductPurchase(LocalPlayer, u42);
        u44:Destroy();
    end);
    ActivateButton(u44.Main.Info.TradeTokens);
    u44.Main.Info.TradeTokens.MouseButton1Click:Connect(function() -- Line: 307
        -- upvalues: u41 (copy), Remotes (ref), u38 (copy), u40 (copy), u10 (ref), u44 (copy)
        if u41 then
            Remotes.Store.PurchaseConsoleTradeTokens.Send({
                ProductName = u38,
                Quantity = u41
            });
        elseif u40 then
            Remotes.Store.PurchaseTradeTokensCase.Send({
                ProductName = u10.name,
                Quantity = u40
            });
        else
            Remotes.Store.PurchaseTradeTokensProduct.Send({
                ProductName = u38
            });
        end;

        u44:Destroy();
    end);
end;

local function MultiplyUdim2(p46, p47: number) -- Line: 321
    return UDim2.fromScale(p46.X.Scale * p47, p46.Y.Scale * p47);
end;

local function ClearFrame(p48: any, p49: table) -- Line: 327
    for _, child in ipairs(p48:GetChildren()) do
        if not table.find(p49, child.Name) then
            child:Destroy();
        end;
    end;
end;

local function CreateSpecialShimmer(p50: userdata) -- Line: 338
    -- upvalues: Color3_fromRGB_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Shimmer";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3_fromRGB_ret;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 3;
    Frame.Visible = false;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = 25;
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.38, 1),
        NumberSequenceKeypoint.new(0.5, 0.55),
        NumberSequenceKeypoint.new(0.62, 1),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame;
    Frame.Parent = p50;

    return Frame, UIGradient;
end;

local function CreateSpecialGlint(p51: userdata) -- Line: 365
    -- upvalues: Color3_fromRGB_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Glint";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Size = UDim2.fromOffset(11, 11);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = 4;
    Frame.Visible = false;
    local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) });

    for _, v in { false, true } do
        local Frame2 = Instance.new("Frame");
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame2.Position = UDim2.fromScale(0.5, 0.5);
        local v52;

        if v then
            v52 = UDim2.new(0, 2, 1, 0);
        else
            v52 = UDim2.new(1, 0, 0, 2);
        end;

        Frame2.Size = v52;
        Frame2.BackgroundColor3 = Color3_fromRGB_ret;
        Frame2.BorderSizePixel = 0;
        Frame2.ZIndex = 4;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Rotation = v and 90 or 0;
        UIGradient.Transparency = NumberSequence_new_ret;
        UIGradient.Parent = Frame2;
        Frame2.Parent = Frame;
    end;

    Frame.Parent = p51;

    return Frame;
end;

local function ApplySpecialCardEffect(p53: userdata) -- Line: 408
    -- upvalues: CreateSpecialShimmer (copy), CreateSpecialGlint (copy), RunServiceController (copy), u13 (ref), GuiService (copy)
    local Content = p53:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local u54 = Content:FindFirstChildOfClass("UIGradient");
    local u55;

    if u54 then
        u55 = u54.Transparency;
    else
        u55 = NumberSequence.new(0);
    end;

    local Rarity = Content:FindFirstChild("Rarity");
    local u56 = not Rarity and 0 or Rarity.Rotation;

    if Rarity and not Rarity:FindFirstChildOfClass("UIAspectRatioConstraint") then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
        UIAspectRatioConstraint.AspectRatio = 1;
        UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize;
        UIAspectRatioConstraint.Parent = Rarity;
    end;

    local u57, u58 = CreateSpecialShimmer(Content);
    local Random_new_ret = Random.new();
    local u59 = {};

    for i = 1, 4 do
        local v60 = {
            Frame = CreateSpecialGlint(Content),
            CycleStart = os.clock() + (i - 1) * 0.45
        };
        table.insert(u59, v60);
        local _ = i;
    end;

    local v61 = RunServiceController.CreateBindingName("UI.Store.SpecialCardEffect");
    local u68 = RunServiceController.BindToRenderStep(v61, function() -- Line: 439
        -- upvalues: u13 (ref), GuiService (ref), u57 (copy), u59 (copy), u54 (copy), u55 (copy), Rarity (copy), u56 (copy), u58 (copy), Random_new_ret (copy)
        if not (u13.Visible and (u13.CaseContent.Visible and u13.CaseContent.Main.CaseContent.Visible)) then
            return;
        end;

        if GuiService.ReducedMotionEnabled then
            u57.Visible = false;

            for _, v in u59 do
                v.Frame.Visible = false;
            end;

            return;
        end;

        local os_clock_ret = os.clock();

        if u54 then
            local v62 = (1 - math.cos(os_clock_ret * 2 * 3.141592653589793 / 2.5)) / 2;
            local v63 = {};

            for _, v in u55.Keypoints do
                table.insert(v63, NumberSequenceKeypoint.new(v.Time, v.Value + (1 - v.Value) * 0.15 * v62));
            end;

            u54.Transparency = NumberSequence.new(v63);
        end;

        if Rarity then
            Rarity.Rotation = u56 + os_clock_ret * 30 % 360;
        end;

        local v64 = os_clock_ret % 2.8 / 0.9;
        u57.Visible = v64 <= 1;

        if u57.Visible then
            u58.Offset = Vector2.new(-1 + 2 * v64, 0);
        end;

        for _, v in u59 do
            local v65 = os_clock_ret - v.CycleStart;

            if v65 >= 1.8 then
                v.CycleStart = os_clock_ret;
                v.Frame.Position = UDim2.fromScale(Random_new_ret:NextNumber(0.12, 0.88), Random_new_ret:NextNumber(0.12, 0.8));
                v65 = 0;
            end;

            local v66 = v65 / 1.1;
            local v67;

            if v66 >= 0 then
                v67 = v66 <= 1;
            else
                v67 = false;
            end;

            v.Frame.Visible = v67;

            if v.Frame.Visible then
                local math_sin_ret = math.sin(v66 * 3.141592653589793);
                v.Frame.Size = UDim2.fromOffset(math_sin_ret * 11, math_sin_ret * 11);
                v.Frame.Rotation = v66 * 45;
            end;
        end;
    end);
    p53.Destroying:Connect(function() -- Line: 492
        -- upvalues: u68 (copy)
        u68:Disconnect();
    end);
end;

local function UpdateCreatorCodeResponse(p69: string, p70: string) -- Line: 499
    -- upvalues: HttpService (copy), u13 (ref)
    local u71 = HttpService:GenerateGUID(false);
    local Response = u13.CreatorCode.Container.Body.Response;
    local v72 = p69 == "Success" and Color3.fromRGB(86, 228, 21);

    if not v72 then
        if p69 == "Error" then
            v72 = Color3.fromRGB(232, 59, 82);
        else
            v72 = false;
        end;
    end;

    Response.TextColor3 = v72;
    u13.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
    u13.CreatorCode:SetAttribute("ResponseId", u71);
    u13.CreatorCode.Container.Body.Response.Text = p70;
    task.delay(5, function() -- Line: 508
        -- upvalues: u13 (ref), u71 (copy)
        if u13.CreatorCode:GetAttribute("ResponseId") == u71 then
            u13.CreatorCode.Container.Body.CreatorName.TextBox.Text = "";
            u13.CreatorCode.Container.Body.Response.Text = "";
        end;
    end);
end;

local function ScrollToBottom(u73: userdata) -- Line: 518
    -- upvalues: Profiler (copy)
    Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 519
        -- upvalues: u73 (copy)
        local math_max_ret = math.max(0, u73.AbsoluteCanvasSize.Y - u73.AbsoluteWindowSize.Y);
        u73.CanvasPosition = Vector2.new(u73.CanvasPosition.X, math_max_ret);
    end);
end;

local function ScrollToFeaturedSection(p74: string) -- Line: 527
    -- upvalues: u13 (ref), TweenService (copy)
    local Container = u13.Tabs.Container.Featured.Container;
    local v75 = Container:FindFirstChild(p74);

    if not v75 then
        return false;
    end;

    local math_max_ret = math.max(0, Container.CanvasPosition.Y + (v75.AbsolutePosition.Y - Container.AbsolutePosition.Y));
    local v76 = TweenService:Create(Container, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, math_max_ret)
    });
    v76:Play();
    v76.Completed:Wait();
    v76:Destroy();

    return true;
end;

local function NotifyCaseOpenSequenceFinished() -- Line: 553
    -- upvalues: u17 (copy), Remotes (copy)
    local currentCaseIdentifier = u17.currentCaseIdentifier;

    if currentCaseIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = currentCaseIdentifier
        });
        u17.currentCaseIdentifier = nil;
    end;
end;

local function ClearPendingOpenRequest() -- Line: 563
    -- upvalues: u17 (copy)
    u17.isPendingOpenRequest = false;
    u17.pendingOpenRequestId = nil;
    u17.isQuickUnlock = false;
end;

local function CreateOpenCaseRequestId() -- Line: 571
    -- upvalues: u18 (ref)
    u18 = u18 + 1;

    return tostring(u18);
end;

local function FailOpenCaseRequest(p77: string?) -- Line: 578
    -- upvalues: u17 (copy), u19 (copy)
    if not p77 then
        return;
    end;

    if u17.pendingOpenRequestId == p77 then
        u17.isPendingOpenRequest = false;
        u17.pendingOpenRequestId = nil;
        u17.isQuickUnlock = false;
    end;

    u19[p77] = nil;
end;

local function CompleteOpenCaseRequest(p78: string?) -- Line: 592
    -- upvalues: u19 (copy), u17 (copy)
    local v79;

    if p78 then
        v79 = u19[p78];
    else
        v79 = p78;
    end;

    if not v79 then
        return nil;
    end;

    if not p78 then
        return v79;
    end;

    if u17.pendingOpenRequestId == p78 then
        u17.isPendingOpenRequest = false;
        u17.pendingOpenRequestId = nil;
        u17.isQuickUnlock = false;
    end;

    u19[p78] = nil;

    return v79;
end;

local function BeginOpenCaseRequest(p80: boolean) -- Line: 604
    -- upvalues: u18 (ref), u19 (copy), u17 (copy)
    u18 = u18 + 1;
    local v81 = tostring(u18);
    u19[v81] = {
        IsQuickUnlock = p80
    };
    u17.isPendingOpenRequest = true;
    u17.pendingOpenRequestId = v81;
    u17.isQuickUnlock = p80;

    return v81;
end;

local function IsResolvedCaseOpenBusy() -- Line: 615
    -- upvalues: u17 (copy), u25 (copy), MenuState (copy)
    return u17.isPendingOpenRequest or u17.isOpening or (u25.isBulkOpening or MenuState.IsInspectActive());
end;

local function StartResolvedCaseOpenJob(p82: table) -- Line: 624
    -- upvalues: u30 (ref), u24 (ref), u29 (ref), u27 (ref)
    if p82.IsConsole then
        if #p82.InventoryItems > 1 then
            u30(p82.CaseId, p82.InventoryItems, p82.ConsoleOutcomes or {}, p82.CaseIdentifier);

            return;
        end;

        u24(p82.InventoryItems[1], p82.CaseIdentifier);

        return;
    end;

    if #p82.InventoryItems > 1 then
        u29(p82.CaseId, p82.InventoryItems, p82.CaseIdentifier);

        return;
    end;

    u27(p82.CaseId, p82.InventoryItems[1], p82.CaseIdentifier, p82.IsQuickUnlock, p82.RequestId);
end;

local function TryProcessResolvedCaseOpenQueue() -- Line: 649
    -- upvalues: Profiler (copy), u17 (copy), u25 (copy), MenuState (copy), u20 (copy), StartResolvedCaseOpenJob (copy)
    Profiler.mark("UI.Store.TryProcessResolvedCaseOpenQueue");

    if u17.isPendingOpenRequest or u17.isOpening or (u25.isBulkOpening or MenuState.IsInspectActive()) then
        return false;
    end;

    local v83 = false;

    while true do
        local v84 = not (u17.isPendingOpenRequest or u17.isOpening or (u25.isBulkOpening or MenuState.IsInspectActive())) and table.remove(u20, 1);

        if not v84 then
            break;
        end;

        StartResolvedCaseOpenJob(v84);
        v83 = true;
    end;

    return v83;
end;

local function ReturnToStoreTabs() -- Line: 672
    -- upvalues: u13 (ref), u14 (ref)
    u13.Tabs.Container.Visible = true;
    u13.CaseContent.Visible = false;
    u14.Menu.Top.Visible = true;
    u13.Top.Visible = true;
    u13.Visible = false;
end;

local function ShowCaseContentView() -- Line: 680
    -- upvalues: u13 (ref), u14 (ref)
    u13.Visible = true;
    u13.Tabs.Container.Visible = false;
    u13.CaseContent.Visible = true;
    u14.Menu.Top.Visible = false;
    u13.Top.Visible = false;
end;

local function InspectInventoryItem(p85) -- Line: 688
    -- upvalues: Router (copy)
    Router.broadcastRouter("WeaponInspect", p85.Name, p85.Skin, p85.Float, p85.StatTrack, p85.NameTag, p85.Charm, p85.Stickers, p85.Type, p85.Pattern, p85._id, p85.Serial, p85.IsTradeable);
end;

local function InspectStoreSkin(p86: string, p87: string, p88: string?) -- Line: 706
    -- upvalues: Router (copy)
    Router.broadcastRouter("WeaponInspect", p86, p87, 0, nil, nil, nil, nil, p88, 1, nil, 1, nil, true, true);
end;

local function SetConsoleOverlay(p89: boolean) -- Line: 710
    -- upvalues: u14 (ref), u22 (ref)
    local OpenCase = u14.Menu.OpenCase;
    local Contents = OpenCase.Contents;
    local Close = Contents.Close;

    if not p89 then
        if u22 then
            for _, v in ipairs(u22) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u22 = nil;
        end;

        return;
    end;

    if u22 then
        return;
    end;

    local v90 = {};

    for _, v in ipairs({ OpenCase, Contents }) do
        for _, child in ipairs(v:GetChildren()) do
            if child:IsA("GuiObject") and (child ~= Contents and (child ~= Close and child.Visible)) then
                table.insert(v90, child);
                child.Visible = false;
            end;
        end;
    end;

    u22 = v90;
    Close.TextLabel.Text = "SKIP";
    Close.Visible = true;
    Contents.Visible = true;
    OpenCase.Visible = true;
end;

local function ResetConsoleOpening() -- Line: 741
    -- upvalues: u17 (copy), CaseSceneController (copy), u14 (ref), u22 (ref), u13 (ref), Profiler (copy), TryProcessResolvedCaseOpenQueue (copy)
    u17.isOpening = false;
    u17.currentInventoryItem = nil;
    u17.currentCaseIdentifier = nil;
    CaseSceneController.CancelConsoleOpening();
    local Close = u14.Menu.OpenCase.Contents.Close;

    if u22 then
        for _, v in ipairs(u22) do
            v.Visible = true;
        end;

        Close.TextLabel.Text = "CLOSE";
        u22 = nil;
    end;

    u14.Menu.OpenCase.Visible = false;
    u13.Visible = true;
    u13.Tabs.Container.Visible = false;
    u13.CaseContent.Visible = true;
    u14.Menu.Top.Visible = false;
    u13.Top.Visible = false;
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

function u1._RunConsoleInspectSweep(p91: function) -- Line: 752
    -- upvalues: u14 (ref), TweenService (copy), RunService (copy)
    local ConsoleInspectSweep = u14:FindFirstChild("ConsoleInspectSweep");

    if ConsoleInspectSweep then
        ConsoleInspectSweep:Destroy();
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "ConsoleInspectSweep";
    Frame.Active = true;
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.BackgroundColor3 = Color3.new(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Position = UDim2.fromScale(-0.8, 0.5);
    Frame.Rotation = 4;
    Frame.Size = UDim2.fromScale(1.2, 1.25);
    Frame.ZIndex = 1000000;
    Frame.Parent = u14;
    local v92 = TweenService:Create(Frame, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Position = UDim2.fromScale(0.5, 0.5)
    });
    v92:Play();
    v92.Completed:Wait();
    local success, result = pcall(p91);
    RunService.RenderStepped:Wait();
    local v93 = TweenService:Create(Frame, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Position = UDim2.fromScale(1.8, 0.5)
    });
    v93:Play();
    v93.Completed:Wait();
    Frame:Destroy();

    if not success then
        error(result);
    end;
end;

local function GetInventoryItemDropSound(p94) -- Line: 795
    -- upvalues: u12 (copy)
    return u12.RARITY_TO_DROP_SOUND[(p94.Type == "Melee" or p94.Type == "Glove") and "Special" or (p94.Rarity or "Blue")] or "Drop Blue";
end;

u24 = function(u95: any, p96: string) -- Line: 802
    -- upvalues: u21 (ref), u17 (copy), Remotes (copy), CaseSceneController (copy), u14 (ref), u22 (ref), u13 (ref), MenuState (copy), Router (copy), u12 (copy), u1 (copy), Profiler (copy), TryProcessResolvedCaseOpenQueue (copy)
    u21 = nil;
    u17.isOpening = false;
    u17.currentInventoryItem = nil;
    u17.currentCaseIdentifier = p96;
    local currentCaseIdentifier = u17.currentCaseIdentifier;

    if currentCaseIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = currentCaseIdentifier
        });
        u17.currentCaseIdentifier = nil;
    end;

    u1._RunConsoleInspectSweep(function() -- Line: 809, Name: showInspect
        -- upvalues: CaseSceneController (ref), u14 (ref), u22 (ref), u13 (ref), MenuState (ref), u95 (copy), Router (ref), u12 (ref)
        CaseSceneController.HideCaseScene();
        local Close = u14.Menu.OpenCase.Contents.Close;

        if u22 then
            for _, v in ipairs(u22) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u22 = nil;
        end;

        u14.Menu.OpenCase.Visible = false;
        u13.Tabs.Container.Visible = true;
        u13.CaseContent.Visible = false;
        u14.Menu.Top.Visible = true;
        u13.Top.Visible = true;
        u13.Visible = false;
        MenuState.SetScreen("Inventory");
        local v97 = u95;
        Router.broadcastRouter("WeaponInspect", v97.Name, v97.Skin, v97.Float, v97.StatTrack, v97.NameTag, v97.Charm, v97.Stickers, v97.Type, v97.Pattern, v97._id, v97.Serial, v97.IsTradeable);

        if MenuState.IsInspectActive() then
            local v98 = u95;
            Router.broadcastRouter("RunStoreSound", u12.RARITY_TO_DROP_SOUND[(v98.Type == "Melee" or v98.Type == "Glove") and "Special" or (v98.Rarity or "Blue")] or "Drop Blue");
        end;
    end);
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

local function CleanupCaseOpeningTweens() -- Line: 827
    -- upvalues: u17 (copy)
    if u17.currentTween then
        u17.currentTween:Cancel();
        u17.currentTween = nil;
    end;

    if u17.currentZoomTween then
        u17.currentZoomTween:Cancel();
        u17.currentZoomTween = nil;
    end;

    if u17.renderConnection then
        u17.renderConnection:Disconnect();
        u17.renderConnection = nil;
    end;

    if u17.viewportConnection then
        u17.viewportConnection:Disconnect();
        u17.viewportConnection = nil;
    end;
end;

u12.CREDIT_PACKAGE_TIERS = { 400, 950, 3100, 6500, 13250 };

local function GetDeveloperProductNameForAmount(p99: number) -- Line: 850
    -- upvalues: u12 (copy), CommaNumber (copy)
    for _, v in u12.CREDIT_PACKAGE_TIERS do
        if p99 <= v then
            return `+ {CommaNumber(v)} Credits`;
        end;
    end;

    return "+ 27,000 Credits";
end;

function u1.IsStarterPackAvailable() -- Line: 861
    -- upvalues: script_StarterPack (copy)
    return script_StarterPack.IsAvailable();
end;

function u1.GetStarterPackRemainingSeconds() -- Line: 865
    -- upvalues: script_StarterPack (copy)
    return script_StarterPack.GetState().RemainingSeconds;
end;

function u1.GetStarterPackWindowSeconds() -- Line: 869
    -- upvalues: script_StarterPack (copy)
    return script_StarterPack.WINDOW_SECONDS;
end;

function u1.GetActiveBundleRemainingSeconds(p100: number?) -- Line: 873
    -- upvalues: ReplicatedStorage (copy), u15 (copy)
    local TimerController = require(ReplicatedStorage.Controllers.TimerController);

    if not p100 then
        local ServerTimeNow = workspace:GetServerTimeNow();
        p100 = math.floor(ServerTimeNow);
    end;

    local Tick = u15.Tick;

    if Tick <= 0 then
        Tick = TimerController.GetTimer(u15.Source);

        if Tick <= 0 then
            return 0;
        end;

        u15.Tick = Tick;
        u15.ReceivedAt = p100;
    end;

    if Tick > 1000000000000 then
        local math_floor_ret = math.floor(Tick / 1000 - p100);

        return math.max(0, math_floor_ret);
    end;

    if Tick > 1000000000 then
        local math_floor_ret = math.floor(Tick - p100);

        return math.max(0, math_floor_ret);
    end;

    local ReceivedAt = u15.ReceivedAt;

    if ReceivedAt <= 0 then
        u15.ReceivedAt = p100;
        ReceivedAt = p100;
    end;

    local math_floor_ret = math.floor(Tick - (p100 - ReceivedAt));

    return math.max(0, math_floor_ret);
end;

function u1.GetFeaturedConsoleTimerText(p101: number?) -- Line: 905
    -- upvalues: u1 (copy), FormatDuration (copy)
    local ActiveBundleRemainingSeconds = u1.GetActiveBundleRemainingSeconds(p101);

    return ActiveBundleRemainingSeconds <= 0 and "LIMITED TIME!" or FormatDuration(ActiveBundleRemainingSeconds, "Always");
end;

function u1.RefreshFeaturedConsoleTimer(p102: number?) -- Line: 915
    -- upvalues: u15 (copy), u1 (copy)
    if u15.Label then
        u15.Label.Text = u1.GetFeaturedConsoleTimerText(p102);
    end;
end;

local function ActivateCategoryButton(u103) -- Line: 923
    -- upvalues: TweenService (copy), Router (copy)
    local Size = u103.Size;
    local TweenInfo_new_ret = TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut);
    u103.MouseEnter:Connect(function() -- Line: 926
        -- upvalues: TweenService (ref), u103 (copy), TweenInfo_new_ret (copy), Size (copy), Router (ref)
        local v104 = {};
        local v105 = Size;
        v104.Size = UDim2.fromScale(v105.X.Scale * 0.9, v105.Y.Scale * 0.9);
        TweenService:Create(u103, TweenInfo_new_ret, v104):Play();
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
    end);
    u103.MouseLeave:Connect(function() -- Line: 930
        -- upvalues: TweenService (ref), u103 (copy), TweenInfo_new_ret (copy), Size (copy)
        TweenService:Create(u103, TweenInfo_new_ret, {
            Size = Size
        }):Play();
    end);
    u103.MouseButton1Click:Connect(function() -- Line: 933
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
end;

local function IsLimitedSpecialCase(p106) -- Line: 941
    -- upvalues: Cases (copy)
    local v107;

    if p106.caseRarity == "Special" then
        v107 = Cases.IsLimited(p106);
    else
        v107 = false;
    end;

    return v107;
end;

local function CountMatchingCases(p108: string) -- Line: 947
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v109 = 0;

    for _, v in ipairs(DataController.Get(LocalPlayer, "Inventory") or {}) do
        if (v.Type == "Case" or v.Type == "Package") and v.Skin == p108 then
            v109 = v109 + 1;
        end;
    end;

    return v109;
end;

local function CollectCaseIdentifiers(p110: string, p111: number) -- Line: 959
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v112 = DataController.Get(LocalPlayer, "Inventory");
    local v113 = {};

    for _, v in ipairs(v112 or {}) do
        if p111 <= #v113 then
            break;
        end;

        if (v.Type == "Case" or v.Type == "Package") and v.Skin == p110 then
            table.insert(v113, v._id);
        end;
    end;

    return v113;
end;

local function FilterAmountButtons(p114: userdata, p115: number) -- Line: 975
    for _, child in ipairs(p114:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = (tonumber(child.Name) or 0) <= p115;
        end;
    end;
end;

local function SelectAmountButton(p116: userdata, p117: any) -- Line: 985
    for _, child in ipairs(p116:GetChildren()) do
        if child:IsA("TextButton") then
            local v118 = child == p117 and true or child.Name == p117;
            child.Frame.BackgroundTransparency = v118 and 0 or 1;
            child:SetAttribute("Selected", v118);
        end;
    end;
end;

local function RefreshCaseAmountButtons() -- Line: 997
    -- upvalues: u10 (ref), u13 (ref), CountMatchingCases (copy), DataController (copy), LocalPlayer (copy), FilterAmountButtons (copy), SelectAmountButton (copy)
    local v119 = u10;

    if not (v119 and u13.CaseContent.Visible) then
        return;
    end;

    local Amount = u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount;
    local Scroll = Amount.Container.Scroll;
    local v120;

    if u13.CaseContent:GetAttribute("State") == "Open" then
        v120 = CountMatchingCases(v119.name);
    else
        local v121 = (tonumber(DataController.Get(LocalPlayer, "Credits")) or 0) / math.max(v119.price, 1);
        local math_floor_ret = math.floor(v121);
        v120 = math.max(1, math_floor_ret);
    end;

    FilterAmountButtons(Scroll, v120);
    local v122 = nil;

    for _, child in Scroll:GetChildren() do
        if child:IsA("TextButton") and child:GetAttribute("Selected") then
            v122 = child;
            break;
        end;
    end;

    if v122 and not v122.Visible then
        SelectAmountButton(Scroll, "1");
        Amount.Header.TextLabel.Text = "1";
    end;
end;

local function ResetBulkOpeningState() -- Line: 1034
    -- upvalues: u25 (copy)
    u25.isBulkOpening = false;
    u25.inventoryItems = nil;
    u25.bulkIdentifier = nil;
    u25.currentIndex = 0;
    u25.skipped = false;
    u25.caseId = nil;
    u25.total = 0;
end;

local function GetUnboxedItemRarity(p123, p124) -- Line: 1046
    if p123.Type == "Melee" or p123.Type == "Glove" then
        return "Special";
    end;

    for _, v in ipairs(p124.contents) do
        if v.skin.skinName == p123.Skin and v.skin.weaponName == p123.Name then
            return v.rarity or "Blue";
        end;
    end;

    return "Blue";
end;

local function purchaseCase(p125: any, p126: number) -- Line: 1061
    -- upvalues: DataController (copy), LocalPlayer (copy), Remotes (copy), u5 (ref), GetDeveloperProductNameForAmount (copy), MarketplaceService (copy), DevProducts (copy), u26 (ref), u1 (copy)
    local v127 = DataController.Get(LocalPlayer, "Credits");
    local v128 = p125.price * p126;

    if v128 <= v127 then
        Remotes.Store.PurchaseCase.Send({
            CaseId = p125.caseId,
            Amount = p126
        });

        return;
    end;

    if u5 then
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[GetDeveloperProductNameForAmount(v128 - v127)].DevProductId);
        u26("Store");
        u1.OpenTab("Credits");
    end;
end;

local function createCaseTemplate(u129: any, p130: userdata, p131: number, p132: boolean) -- Line: 1076
    -- upvalues: Profiler (copy), Rarities (copy), ReplicatedStorage (copy), Cases2 (copy), Cases (copy), ActivateButton (copy), Router (copy), u1 (copy), u28 (ref)
    if p130:FindFirstChild(u129.caseId) then
        return;
    end;

    Profiler.mark("UI.Store.CreateCaseTemplate");
    local v133 = Rarities[u129.caseRarity];

    if v133 then
        local v134 = ReplicatedStorage.Assets.UI.Store.CaseTemplate:Clone();
        local v135;

        if Cases2[u129.name] then
            v135 = Cases2[u129.name].Amounts[1] or nil;
        else
            v135 = nil;
        end;

        if v135 and (v135.BasePrice and v135.Price < v135.BasePrice) then
            local math_floor_ret = math.floor((v135.BasePrice - v135.Price) / ((v135.BasePrice + v135.Price) / 2) * 100);
            v134.Discount.Discount.Title.Text = `-{math_floor_ret}%`;
        end;

        v134.Discount.Visible = false;
        local v136;

        if u129.caseRarity == "Special" then
            v136 = Cases.IsLimited(u129);
        else
            v136 = false;
        end;

        if v136 then
            v134.Discount.Discount.Title.Text = "LIMITED";
            v134.Discount.Visible = true;
        elseif p132 then
            v134.Discount.Discount.Title.Text = "NEW";
            v134.Discount.Visible = true;
        end;

        v134.Contents.Glow.ImageColor3 = v133.Color;
        v134.Contents.Pattern.ImageColor3 = v133.Color;
        v134.Contents.Rarity.BackgroundColor3 = v133.Color;
        v134.Contents.Icon.Image = u129.imageAssetId;
        v134.Footer.CaseName.Text = u129.name;
        v134.LayoutOrder = p131;
        v134.Parent = p130;
        v134.Name = u129.caseId;
        ActivateButton(v134.Purchase);
        v134.Purchase.MouseButton1Click:Connect(function() -- Line: 1113
            -- upvalues: Router (ref), u1 (ref), u129 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.OpenCaseContent(u129.caseId, "Inspect");
        end);
        ActivateButton(v134.Gift);
        v134.Gift.MouseButton1Click:Connect(function() -- Line: 1118
            -- upvalues: u28 (ref), u129 (copy)
            u28(u129.caseId, "Case");
        end);
    end;
end;

local function activateGiftTemplate(u137, u138) -- Line: 1126
    -- upvalues: Router (copy), TweenService (copy), LocalPlayer (copy), u13 (ref), DataController (copy), Cases (copy), Remotes (copy), MarketplaceService (copy), Gamepasses (copy), DevProducts (copy), DoCreditPurchase (copy)
    local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    u137.Button.MouseEnter:Connect(function() -- Line: 1128
        -- upvalues: Router (ref), TweenService (ref), u137 (copy), TweenInfo_new_ret (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        TweenService:Create(u137.Player.Username, TweenInfo_new_ret, {
            TextColor3 = Color3.fromRGB(255, 200, 0)
        }):Play();
    end);
    u137.Button.MouseLeave:Connect(function() -- Line: 1134
        -- upvalues: TweenService (ref), u137 (copy), TweenInfo_new_ret (copy)
        TweenService:Create(u137.Player.Username, TweenInfo_new_ret, {
            TextColor3 = Color3.fromRGB(190, 190, 190)
        }):Play();
    end);
    u137.Button.MouseButton1Click:Connect(function() -- Line: 1139
        -- upvalues: u138 (copy), LocalPlayer (ref), u13 (ref), Router (ref), DataController (ref), Cases (ref), Remotes (ref), MarketplaceService (ref), Gamepasses (ref), DevProducts (ref), DoCreditPurchase (ref)
        if u138 == LocalPlayer.UserId then
            return;
        end;

        local Attribute = u13:GetAttribute("GiftProductName");
        local Attribute2 = u13:GetAttribute("GiftProductType");
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if Attribute2 ~= "Case" then
            Remotes.Store.CreateGift.Send({
                RecipientUserId = tostring(u138),
                ProductName = Attribute,
                ProductType = Attribute2
            });

            if Attribute2 == "Gamepass" then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, Gamepasses[Attribute].GamepassId);

                return;
            end;

            if Attribute2 == "DevProduct" then
                local v139 = DataController.Get(LocalPlayer, "TradeTokens");

                if string.find(Attribute, "Trade Tokens", 1, true) == nil and (DevProducts[Attribute].Price and DevProducts[Attribute].Price <= v139) then
                    DoCreditPurchase(Attribute, DevProducts[Attribute]);

                    return;
                end;

                MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[Attribute].DevProductId);
            end;

            return;
        end;

        local v140 = DataController.Get(LocalPlayer, "Credits");
        local Case = Cases.GetCase(Attribute);
        local v141 = tonumber(u13.Gift.Amount.Header.TextLabel.Text) or 1;

        if v140 < Case.price * v141 then
            return;
        end;

        u13.Gift.Visible = false;
        Remotes.Store.GiftCase.Send({
            RecipientUserId = tostring(u138),
            CaseId = Attribute,
            Amount = v141
        });
    end);
end;

local function CanInspect() -- Line: 1189
    -- upvalues: u19 (copy)
    return next(u19) == nil;
end;

local function WireCaseItemInspect(p142: userdata, u143: string, u144: string, u145: string?) -- Line: 1195
    -- upvalues: u19 (copy), Router (copy), ActivateButton (copy)
    local function inspectItem() -- Line: 1196
        -- upvalues: u19 (ref), Router (ref), u143 (copy), u144 (copy), u145 (copy)
        if next(u19) ~= nil then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        Router.broadcastRouter("WeaponInspect", u143, u144, 0, nil, nil, nil, nil, u145, 1, nil, 1, nil, true, true);
    end;

    local ItemContent = p142:FindFirstChild("ItemContent");

    if ItemContent then
        ItemContent = ItemContent:FindFirstChild("Inspect");
    end;

    if ItemContent and ItemContent:IsA("GuiButton") then
        ItemContent.Visible = true;
        ItemContent.Active = true;
        ItemContent.Selectable = false;
        ActivateButton(ItemContent);
        ItemContent.MouseButton1Click:Connect(inspectItem);
    end;

    if p142:IsA("GuiButton") then
        p142.Active = true;
        p142.Selectable = true;
        p142.Activated:Connect(inspectItem);
    end;

    return inspectItem;
end;

local function SetupTaggedInspectButtons(p146: string) -- Line: 1225
    -- upvalues: CollectionService (copy), u13 (ref), ActivateButton (copy), u19 (copy), Router (copy)
    for _, v in ipairs(CollectionService:GetTagged(p146)) do
        if v:IsDescendantOf(u13) then
            local Attribute = v:GetAttribute("WeaponName");
            local Attribute2 = v:GetAttribute("SkinName");

            if typeof(Attribute) == "string" and typeof(Attribute2) == "string" then
                local Inspect = v:FindFirstChild("Inspect");

                if Inspect and Inspect:IsA("GuiButton") then
                    ActivateButton(Inspect);
                    Inspect.MouseButton1Click:Connect(function() -- Line: 1246
                        -- upvalues: u19 (ref), Router (ref), Attribute (copy), Attribute2 (copy)
                        if next(u19) == nil then
                            Router.broadcastRouter("RunInterfaceSound", "UI Click");
                            Router.broadcastRouter("WeaponInspect", Attribute, Attribute2, 0, nil, nil, nil, nil, nil, 1, nil, 1, nil, true, true);
                        end;
                    end);
                    local HoverFrame = v:FindFirstChild("HoverFrame");

                    if HoverFrame and HoverFrame:IsA("GuiButton") then
                        HoverFrame.Activated:Connect(function() -- Line: 1257
                            -- upvalues: u19 (ref), Router (ref), Attribute (copy), Attribute2 (copy)
                            if next(u19) == nil then
                                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                                Router.broadcastRouter("WeaponInspect", Attribute, Attribute2, 0, nil, nil, nil, nil, nil, 1, nil, 1, nil, true, true);
                            end;
                        end);
                    end;
                else
                    warn((`[Store] {v:GetFullName()} is missing its Inspect button.`));
                end;
            else
                warn((`[Store] {v:GetFullName()} is missing WeaponName/SkinName attributes.`));
            end;
        end;
    end;
end;

local function setupCurrencyFrame(u147: userdata, u148: boolean) -- Line: 1269
    -- upvalues: DevProducts (copy), CommaNumber (copy), LoadProductInfo (copy), ActivateButton (copy), u5 (ref), DataController (copy), LocalPlayer (copy), DoCreditPurchase (copy), MarketplaceService (copy), Router (copy), u28 (ref)
    local u149 = DevProducts[u147.Name];
    local Purchase_Button = u147:FindFirstChild("Purchase_Button", true);

    if Purchase_Button and Purchase_Button:IsA("GuiButton") then
        local function u151(p150) -- Line: 1274
            -- upvalues: u148 (copy), Purchase_Button (copy), CommaNumber (ref)
            if u148 then
                local Title = Purchase_Button:FindFirstChild("Title", true);

                if Title and Title:IsA("TextLabel") then
                    Title.Text = `{utf8.char(57346)}{CommaNumber(p150)}`;
                end;
            else
                Purchase_Button.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(p150)}`;
            end;
        end;

        if u149.Price and u151 then
            u151(u149.Price);
        end;

        LoadProductInfo(u149.DevProductId, function(p152) -- Line: 252
            -- upvalues: u149 (copy), u151 (copy)
            if not (p152 and p152.PriceInRobux) then
                return;
            end;

            u149.BasePrice = p152.UserBasePriceInRobux or u149.Price;
            u149.Price = p152.PriceInRobux;

            if u151 then
                u151(u149.Price);
            end;
        end);
        ActivateButton(Purchase_Button);
        Purchase_Button.MouseButton1Click:Connect(function() -- Line: 1286
            -- upvalues: u5 (ref), DataController (ref), LocalPlayer (ref), u148 (copy), u149 (copy), DoCreditPurchase (ref), u147 (copy), MarketplaceService (ref), Router (ref)
            if u5 then
                local v153 = DataController.Get(LocalPlayer, "TradeTokens");

                if u148 or (not u149.Price or u149.Price > v153) then
                    MarketplaceService:PromptProductPurchase(LocalPlayer, u149.DevProductId);
                else
                    DoCreditPurchase(u147.Name, u149);
                end;

                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end;
        end);
    end;

    local Gift_Button = u147:FindFirstChild("Gift_Button", true);

    if Gift_Button and Gift_Button:IsA("GuiButton") then
        ActivateButton(Gift_Button);
        Gift_Button.MouseButton1Click:Connect(function() -- Line: 1302
            -- upvalues: u28 (ref), u147 (copy), Router (ref)
            u28("Gift " .. u147.Name, "DevProduct");
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
    end;
end;

local function sortCasesByNewest(p154, p155) -- Line: 1315
    -- upvalues: Cases (copy)
    local v156;

    if p154.caseRarity == "Special" then
        v156 = Cases.IsLimited(p154);
    else
        v156 = false;
    end;

    local v157;

    if p155.caseRarity == "Special" then
        v157 = Cases.IsLimited(p155);
    else
        v157 = false;
    end;

    if v156 ~= v157 then
        return v156;
    end;

    local CreationTimestamp = Cases.GetCreationTimestamp(p154);
    local CreationTimestamp2 = Cases.GetCreationTimestamp(p155);

    if CreationTimestamp and CreationTimestamp2 then
        if CreationTimestamp ~= CreationTimestamp2 then
            return CreationTimestamp2 < CreationTimestamp;
        end;
    elseif CreationTimestamp or CreationTimestamp2 then
        return CreationTimestamp ~= nil;
    end;

    if p154.displayOrder == p155.displayOrder then
        return Cases.GetBackendOrder(p154) < Cases.GetBackendOrder(p155);
    end;

    return p154.displayOrder < p155.displayOrder;
end;

local u158 = nil;

local function fitCaseGrid(p159: userdata) -- Line: 1357
    -- upvalues: u158 (ref)
    local v160 = p159:FindFirstChildOfClass("UIGridLayout");
    local Parent = p159.Parent;
    local Parent2 = Parent.Parent;
    local Frame = Parent2:FindFirstChild("Frame");
    local v161 = Parent2:FindFirstChildOfClass("UIListLayout");
    local v162 = Parent:FindFirstChildOfClass("UIPadding");
    local AbsoluteSize = p159.AbsoluteSize;

    if not (v160 and (v161 and (v162 and AbsoluteSize.X > 0))) then
        return;
    end;

    local u163 = v160.CellSize.X.Scale * AbsoluteSize.X + v160.CellSize.X.Offset;

    if u163 <= 0 then
        return;
    end;

    local v164 = u158;

    if not v164 then
        if AbsoluteSize.Y <= 0 then
            return;
        end;

        local function pixels(p165, p166: number) -- Line: 1380
            -- upvalues: u163 (copy)
            return (p165.Scale * p166 + p165.Offset) / u163;
        end;

        v164 = {};
        local Y = v160.CellSize.Y;
        v164.cellAspect = (Y.Scale * AbsoluteSize.Y + Y.Offset) / u163;
        local Y2 = v160.CellPadding.Y;
        v164.rowPadding = (Y2.Scale * AbsoluteSize.Y + Y2.Offset) / u163;
        v164.header = not Frame and 0 or Frame.AbsoluteSize.Y / u163;
        local Padding = v161.Padding;
        v164.sectionPadding = (Padding.Scale * Parent2.AbsoluteSize.Y + Padding.Offset) / u163;
        local PaddingTop = v162.PaddingTop;
        v164.holderPaddingTop = (PaddingTop.Scale * Parent.AbsoluteSize.Y + PaddingTop.Offset) / u163;
        local PaddingBottom = v162.PaddingBottom;
        v164.holderPaddingBottom = (PaddingBottom.Scale * Parent.AbsoluteSize.Y + PaddingBottom.Offset) / u163;
        u158 = v164;
    end;

    local v167 = 0;

    for _, child in ipairs(p159:GetChildren()) do
        if child:IsA("GuiObject") then
            v167 = v167 + 1;
        end;
    end;

    local v168 = v160.CellPadding.X.Scale * AbsoluteSize.X + v160.CellPadding.X.Offset;
    local math_floor_ret = math.floor((AbsoluteSize.X + v168) / (u163 + v168) + 0.001);
    local math_max_ret = math.max(1, math_floor_ret);
    local math_ceil_ret = math.ceil(v167 / math_max_ret);
    local math_max_ret2 = math.max(1, math_ceil_ret);
    local math_round_ret = math.round(u163 * v164.cellAspect);
    local math_round_ret2 = math.round(u163 * v164.rowPadding);
    local v169 = math_max_ret2 * math_round_ret + (math_max_ret2 - 1) * math_round_ret2;
    local math_round_ret3 = math.round(u163 * v164.holderPaddingTop);
    local math_round_ret4 = math.round(u163 * v164.holderPaddingBottom);
    v160.CellSize = UDim2.new(v160.CellSize.X, UDim.new(0, math_round_ret));
    v160.CellPadding = UDim2.new(v160.CellPadding.X, UDim.new(0, math_round_ret2));
    p159.Size = UDim2.new(p159.Size.X, UDim.new(0, v169));
    v162.PaddingTop = UDim.new(0, math_round_ret3);
    v162.PaddingBottom = UDim.new(0, math_round_ret4);
    Parent.AutomaticSize = Enum.AutomaticSize.None;
    Parent.Size = UDim2.new(Parent.Size.X, UDim.new(0, v169 + math_round_ret3 + math_round_ret4));
    local math_round_ret5 = math.round(u163 * v164.sectionPadding);
    local v170 = not Frame and 0 or math.round(u163 * v164.header);
    v161.Padding = UDim.new(0, math_round_ret5);

    if Frame then
        Frame.Size = UDim2.new(Frame.Size.X, UDim.new(0, v170));
    end;

    Parent2.AutomaticSize = Enum.AutomaticSize.None;
    Parent2.Size = UDim2.new(Parent2.Size.X, UDim.new(0, v169 + math_round_ret3 + math_round_ret4 + (not Frame and 0 or v170 + math_round_ret5)));
end;

local function updateCases() -- Line: 1438
    -- upvalues: Profiler (copy), u13 (ref), ClearFrame (copy), Cases (copy), sortCasesByNewest (copy), createCaseTemplate (copy)
    Profiler.mark("UI.Store.UpdateCases");
    local Cases3 = u13.Tabs.Container.Featured.Container.Cases.Container.Cases;
    ClearFrame(Cases3, { "UIListLayout", "UIGridLayout" });
    local v171 = {};

    for _, v in ipairs(Cases.GetCases()) do
        if v.caseType ~= "Package" and v.caseType ~= "Console" then
            table.insert(v171, v);
        end;
    end;

    table.sort(v171, sortCasesByNewest);
    local v172 = (-1 / 0);
    local v173 = nil;

    for _, v in ipairs(v171) do
        local CreationTimestamp = Cases.GetCreationTimestamp(v);

        if CreationTimestamp and v172 < CreationTimestamp then
            local v174;

            if v.caseRarity == "Special" then
                v174 = Cases.IsLimited(v);
            else
                v174 = false;
            end;

            if not v174 then
                v173 = v;
                v172 = CreationTimestamp;
            end;
        end;
    end;

    for i, v in ipairs(v171) do
        local v175;

        if v173 then
            v175 = v == v173;
        else
            v175 = v.isFeatured;
        end;

        createCaseTemplate(v, Cases3, i, v175);
    end;
end;

local function GetRarityChance(p176: string, p177: userdata) -- Line: 1471
    for _, v in p177 do
        if v.rarity == p176 then
            return v.chance;
        end;
    end;

    return 0;
end;

local function RoundToNearestThousandsth(p178) -- Line: 1480
    return string.format("%.4f", math.floor(p178 * 10000) / 10000);
end;

local function GetBaseSkinName(p179: string) -- Line: 1485
    if p179:find("_PATTERN_") then
        return p179:split("_PATTERN_")[1];
    end;

    return p179;
end;

local function buildItemOdds(p180: any, p181: table, p182: table) -- Line: 1493
    -- upvalues: u13 (ref)
    local ItemOddsFrame = u13.CaseContent.Main.ItemOddsFrame;
    local Container = ItemOddsFrame.Container;

    if ItemOddsFrame:FindFirstChild("List") then
        ItemOddsFrame.List.Visible = false;
    end;

    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    Container.CanvasSize = UDim2.fromScale(0, 0);
    Container.ScrollingDirection = Enum.ScrollingDirection.Y;
    local v183 = {
        KillTrakHeader = Container.KillTrakHeader,
        ConditionsHeader = Container.ConditionsHeader,
        PatternsHeader = Container.PatternsHeader,
        KillTrakTemplate = Container.KillTrakTemplate,
        PatternTemplate = Container.PatternTemplate,
        FactoryNew = Container:FindFirstChild("Factory New"),
        MinimalWear = Container:FindFirstChild("Minimal Wear"),
        FieldTested = Container:FindFirstChild("Field-Tested"),
        WellWorn = Container:FindFirstChild("Well-Worn"),
        BattleScarred = Container:FindFirstChild("Battle-Scarred")
    };
    local v184 = {};

    for _, v in pairs(v183) do
        if v and v:IsA("Frame") then
            v184[v] = true;
            v.Visible = false;
        end;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Frame") and not v184[child] then
            child:Destroy();
        end;
    end;

    local u185 = 0;

    local function nextLayoutOrder() -- Line: 1533
        -- upvalues: u185 (ref)
        u185 = u185 + 10;

        return u185;
    end;

    local function setOddsRow(p186: userdata, p187: string, p188: number, p189) -- Line: 1538
        p186.Visible = true;
        local Left = p186:FindFirstChild("Left");

        if Left then
            local v190 = Left:FindFirstChild("Label") or Left:FindFirstChild("Title");

            if v190 and v190:IsA("TextLabel") then
                v190.Text = p187;
                v190.TextColor3 = p189;
            end;

            local Percent = Left:FindFirstChild("Percent");

            if Percent and Percent:IsA("TextLabel") then
                Percent.Text = string.format("%.2f%%", p188);
            end;
        end;

        local Bar = p186:FindFirstChild("Bar");

        if Bar then
            Bar = Bar:FindFirstChild("Current");
        end;

        if Bar and Bar:IsA("Frame") then
            Bar.Size = UDim2.new(math.clamp(p188 / 100, 0, 1), 0, 1, 0);
            Bar.BackgroundColor3 = p189;
        end;
    end;

    local function cloneTemplate(p191: userdata, p192: string) -- Line: 1563
        -- upvalues: u185 (ref), Container (copy)
        local v193 = p191:Clone();
        v193.Name = p192;
        u185 = u185 + 10;
        v193.LayoutOrder = u185;
        v193.Visible = true;
        v193.Parent = Container;

        return v193;
    end;

    local function setHeaderText(p194: userdata, p195: string) -- Line: 1572
        local v196 = p194:FindFirstChildWhichIsA("TextLabel", true);

        if v196 then
            v196.Text = p195;
        end;
    end;

    if p180.type ~= "Glove" then
        local v197 = v183.KillTrakHeader:Clone();
        v197.Name = "KillTrakHeader";
        u185 = u185 + 10;
        v197.LayoutOrder = u185;
        v197.Visible = true;
        v197.Parent = Container;
        local v198 = v197:FindFirstChildWhichIsA("TextLabel", true);

        if v198 then
            v198.Text = "General:";
        end;

        local v199 = v183.KillTrakTemplate:Clone();
        v199.Name = "KillTrak";
        u185 = u185 + 10;
        v199.LayoutOrder = u185;
        v199.Visible = true;
        v199.Parent = Container;
        setOddsRow(v199, "KillTrak™", p180.statTrakChance, Color3.fromRGB(255, 132, 32));
    end;

    local v200 = v183.ConditionsHeader:Clone();
    v200.Name = "ConditionsHeader";
    u185 = u185 + 10;
    v200.LayoutOrder = u185;
    v200.Visible = true;
    v200.Parent = Container;
    local v201 = v200:FindFirstChildWhichIsA("TextLabel", true);

    if v201 then
        v201.Text = "Conditions:";
    end;

    local v202 = {
        ["Factory New"] = { v183.FactoryNew, "Mint Condition", Color3.fromRGB(0, 255, 127) },
        ["Minimal Wear"] = { v183.MinimalWear, "Near-Mint", Color3.fromRGB(0, 170, 255) },
        ["Field-Tested"] = { v183.FieldTested, "Standard-Grade", Color3.fromRGB(255, 255, 0) },
        ["Well-Worn"] = { v183.WellWorn, "Combat-Worn", Color3.fromRGB(255, 85, 0) },
        ["Battle-Scarred"] = { v183.BattleScarred, "War-Torn", Color3.fromRGB(255, 0, 0) }
    };

    for _, v in ipairs(p180.floatChances) do
        local v203 = v202[v.wear];

        if v203 and (v203[1] and v.chance > 0) then
            local wear = v.wear;
            local v204 = v203[1]:Clone();
            v204.Name = wear;
            u185 = u185 + 10;
            v204.LayoutOrder = u185;
            v204.Visible = true;
            v204.Parent = Container;
            setOddsRow(v204, v203[2], v.chance, v203[3]);
        end;
    end;

    local v205 = {};
    local v206 = 0;

    for _, v in p181 do
        if v.skin.skinName:find("_PATTERN_") and p182.representativeSkinName:find("_PATTERN_") then
            v205[v.skin.skinName] = true;
            v206 = v206 + 1;
        end;
    end;

    if v206 > 0 then
        local v207 = v183.PatternsHeader:Clone();
        v207.Name = "PatternsHeader";
        u185 = u185 + 10;
        v207.LayoutOrder = u185;
        v207.Visible = true;
        v207.Parent = Container;
        local v208 = v207:FindFirstChildWhichIsA("TextLabel", true);

        if v208 then
            v208.Text = "Patterns:";
        end;

        local v209 = 1 / v206 * 100;
        local v210 = u185;

        for i in v205 do
            local _, v211 = table.unpack(i:split("_PATTERN_"));
            local v212 = v183.PatternTemplate:Clone();
            v212.Name = "PatternTemplate";
            u185 = u185 + 10;
            v212.LayoutOrder = u185;
            v212.Visible = true;
            v212.Parent = Container;
            v212.LayoutOrder = v210 + (tonumber(v211) or 0);
            setOddsRow(v212, `Pattern #{v211}`, v209, Color3.fromRGB(255, 255, 255));
        end;
    end;

    local Title = ItemOddsFrame.Header.Title;
    local weaponName = p182.weaponName;
    local representativeSkinName = p182.representativeSkinName;

    if representativeSkinName:find("_PATTERN_") then
        representativeSkinName = representativeSkinName:split("_PATTERN_")[1];
    end;

    Title.Text = `ITEM ODDS - "{weaponName} | {representativeSkinName}"`;
    ItemOddsFrame.Visible = true;
end;

local function RenderGroupedOdds(p213: table?, p214: function, p215: userdata, p216: string) -- Line: 1630
    -- upvalues: Rarities (copy), GetSkinDisplayName (copy), Skins (copy), script_CaseScroll (copy), ReplicatedStorage (copy), ActivateButton (copy), buildItemOdds (copy), WireCaseItemInspect (copy)
    if p213 == nil then
        return;
    end;

    if typeof(p213) ~= "table" then
        warn((`[Store.RenderGroupedOdds] Expected {p216} to be a table; no odds rows were rendered`));

        return;
    end;

    local v217 = {};
    local v218 = 0;
    local u219 = {};
    local v220 = {};

    for _, v in ipairs(p213) do
        local v221;

        if typeof(v) == "table" and typeof(v.skin) == "table" then
            v221 = v.skin;
        else
            v221 = nil;
        end;

        if v221 and (typeof(v221.weaponName) == "string" and (v221.weaponName ~= "" and (typeof(v221.skinName) == "string" and (v221.skinName ~= "" and Rarities[v.rarity])))) then
            table.insert(u219, v);
            local skinName = v221.skinName;

            if skinName:find("_PATTERN_") then
                skinName = skinName:split("_PATTERN_")[1];
            end;

            local v222 = `{v221.weaponName}|{skinName}`;

            if not v220[v222] then
                local v223 = {
                    weaponName = v221.weaponName,
                    baseSkinName = skinName,
                    representativeSkinName = v221.skinName,
                    rarity = v.rarity,
                    itemType = v221.type == "Charm" and "Charm" or nil
                };
                v220[v222] = v223;
                table.insert(v217, v223);
            end;
        else
            v218 = v218 + 1;
        end;
    end;

    if v218 > 0 then
        warn((`[Store.RenderGroupedOdds] Skipped {v218} malformed {p216}; each entry must contain skin.weaponName, skin.skinName, and a known rarity`));
    end;

    for _, v in ipairs(v217) do
        local v224 = p214(v, v217);
        local v225 = GetSkinDisplayName(v.baseSkinName, false);
        local v226 = Rarities[v.rarity];
        local SkinInformation = Skins.GetSkinInformation(v.weaponName, v.representativeSkinName);
        local StoreItemIcon = script_CaseScroll.GetStoreItemIcon(SkinInformation);
        local v227 = ReplicatedStorage.Assets.UI.Store.OddTemplate:Clone();
        v227.ItemTemplate.ItemContent.Content.Icon.Image = StoreItemIcon;
        v227.ItemTemplate.ItemContent.Content.Rarity.ImageColor3 = v226.Color;
        v227.ItemTemplate.ItemContent.Rarity.BackgroundColor3 = v226.Color;
        v227.ItemTemplate.ItemContent.SkinName.Text = v225;
        v227.ItemTemplate.ItemContent.WeaponName.Text = v.weaponName;
        v227.Label.Text = `{string.format("%.4f", math.floor(v224 * 10000) / 10000)}%`;
        v227.Label.UIGradient.Color = v226.ColorSequence;
        v227.LayoutOrder = 100 - v224;
        v227.Parent = p215;
        local ItemOdds = v227:FindFirstChild("ItemOdds");

        if ItemOdds and SkinInformation then
            ActivateButton(ItemOdds);
            ItemOdds.MouseButton1Click:Connect(function() -- Line: 1707
                -- upvalues: buildItemOdds (ref), SkinInformation (copy), u219 (copy), v (copy)
                buildItemOdds(SkinInformation, u219, v);
            end);
        elseif ItemOdds and ItemOdds:IsA("GuiObject") then
            ItemOdds.Visible = false;
        end;

        WireCaseItemInspect(v227.ItemTemplate, v.weaponName, v.representativeSkinName, v.itemType);
    end;
end;

local function UpdateCasePurchaseButtons(p228) -- Line: 1718
    -- upvalues: u13 (ref), Cases2 (copy), Cases (copy), u5 (ref), RunService (copy), CommaNumber (copy)
    local SubButtons = u13.CaseContent.Main.Bottom.SubButtons;
    local v229 = Cases2[p228.name];
    local v230 = Cases.IsCaseForSale(p228.caseId);
    local v231 = false;

    for _, child in ipairs(SubButtons.CenterButtons:GetChildren()) do
        if child:IsA("GuiButton") then
            child.Visible = false;
        end;
    end;

    if v229 and (u5 and (v230 or RunService:IsStudio())) then
        for i, v in v229.Amounts do
            local v232 = SubButtons.CenterButtons:FindFirstChild((tostring(i)));

            if v232 and v232:IsA("GuiButton") then
                v232.Visible = v.Offsale == false;
                v231 = v231 or v232.Visible;
                v232.Container.Title.Text = `{CommaNumber(v.Price)}`;
            end;
        end;
    end;

    SubButtons.Visible = v231;
end;

local function RefreshCaseListings() -- Line: 1744
    -- upvalues: updateCases (copy), u10 (ref), u13 (ref), UpdateCasePurchaseButtons (copy)
    updateCases();

    if u10 and u13.CaseContent.Visible then
        UpdateCasePurchaseButtons(u10);
    end;
end;

local function StartBackgroundProductLoading() -- Line: 1751
    -- upvalues: DevProducts (copy), LoadProductInfo (copy), updateCases (copy), u10 (ref), u13 (ref), UpdateCasePurchaseButtons (copy), Cases2 (copy)
    for _, v in DevProducts do
        local _ = v.Price;
        local u233 = nil;
        LoadProductInfo(v.DevProductId, function(p234) -- Line: 252
            -- upvalues: v (copy), u233 (copy)
            if not (p234 and p234.PriceInRobux) then
                return;
            end;

            v.BasePrice = p234.UserBasePriceInRobux or v.Price;
            v.Price = p234.PriceInRobux;

            if u233 then
                u233(v.Price);
            end;
        end);
    end;

    local u235 = 0;

    local function CompleteRequest() -- Line: 1757
        -- upvalues: u235 (ref), updateCases (ref), u10 (ref), u13 (ref), UpdateCasePurchaseButtons (ref)
        u235 = u235 - 1;

        if u235 == 0 then
            updateCases();

            if u10 and u13.CaseContent.Visible then
                UpdateCasePurchaseButtons(u10);
            end;
        end;
    end;

    for _, v in Cases2 do
        for _, v2 in v.Amounts do
            u235 = u235 + 1;
            LoadProductInfo(v2.ID, function(p236) -- Line: 1767
                -- upvalues: v2 (copy), u235 (ref), updateCases (ref), u10 (ref), u13 (ref), UpdateCasePurchaseButtons (ref)
                if p236 then
                    v2.Offsale = not (p236.IsForSale and p236.PriceInRobux);

                    if p236.IsForSale and p236.PriceInRobux then
                        v2.BasePrice = p236.UserBasePriceInRobux or v2.BasePrice;
                        v2.Price = p236.PriceInRobux;
                    end;
                end;

                u235 = u235 - 1;

                if u235 == 0 then
                    updateCases();

                    if u10 and u13.CaseContent.Visible then
                        UpdateCasePurchaseButtons(u10);
                    end;
                end;
            end);
        end;
    end;
end;

function u1.OpenCaseContent(p237: string, p238: string, p239: string?) -- Line: 1781
    -- upvalues: Profiler (copy), Cases (copy), u9 (ref), u10 (ref), UpdateCasePurchaseButtons (copy), u13 (ref), MenuState (copy), CommaNumber (copy), u14 (ref), SelectAmountButton (copy), RefreshCaseAmountButtons (copy), RenderGroupedOdds (copy), u12 (copy), CaseSceneController (copy), ClearFrame (copy), Skins (copy), Rarities (copy), script_CaseScroll (copy), GetSkinDisplayName (copy), ReplicatedStorage (copy), WireCaseItemInspect (copy), GetUserPlatform (copy), ActivateButton (copy), ApplySpecialCardEffect (copy)
    Profiler.mark("UI.Store.OpenCaseContent");
    local Case = Cases.GetCase(p237);
    u9 = p239;
    u10 = Case;

    if Case then
        UpdateCasePurchaseButtons(Case);
        local v240 = u13.Visible or MenuState.GetCurrentScreen() == "Store";

        if v240 then
            MenuState.SetScreen("Store");
        end;

        u13.CaseContent:SetAttribute("WasVisibleBeforeInspect", v240);
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Position = p238 == "Open" and UDim2.new(0.687, 0, 0.465, 0) or UDim2.new(0.575, 0, 0.465, 0);
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = `BUY <font color="#ffda0f">({CommaNumber(Case.price)})</font>`;
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Visible = Case.caseType ~= "Console" or p238 == "Open";
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = "1";
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Visible = p238 == "Inspect";
        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.Visible = p238 == "Open";
        u13.CaseContent:SetAttribute("State", p238);
        u13.Tabs.Container.Visible = false;
        u13.CaseContent.Visible = true;
        u14.Menu.Top.Visible = false;
        u13.Top.Visible = false;
        u13.Visible = true;
        SelectAmountButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll, "1");
        RefreshCaseAmountButtons();

        for _, child in ipairs(u13.CaseContent.Main.Odds.Frame.Container:GetChildren()) do
            if child.Name ~= "INVIS" and child:IsA("Frame") then
                if child.Name == "Special" then
                    child.Visible = false;
                else
                    child:Destroy();
                end;
            end;
        end;

        local v241 = {};
        local v242 = {};

        for _, v in Case.contents do
            v241[v.rarity] = (v241[v.rarity] or 0) + 1;
        end;

        local u243 = {};
        local v244 = false;

        for i in pairs(v241) do
            local v245 = i;
            local v246 = 0;

            for _, v in Case.rarityChances do
                if v.rarity == v245 then
                    v246 = v.chance;
                    break;
                end;
            end;

            local v247 = v246 or 0;
            u243[v245] = v247;

            if v247 > 0 then
                v244 = true;
            end;
        end;

        if not v244 then
            local v248 = 0;
            local v249 = {};

            for _, v in ipairs(Case.contents) do
                local v250 = v.weight or 0;
                v248 = v248 + v250;
                v249[v.rarity] = (v249[v.rarity] or 0) + v250;
            end;

            local v251 = #Case.contents;

            for i, v in pairs(v241) do
                if v248 > 0 then
                    u243[i] = (v249[i] or 0) / v248 * 100;
                else
                    u243[i] = v / math.max(v251, 1) * 100;
                end;
            end;
        end;

        local function GetDisplayRarityChance(p252) -- Line: 1858
            -- upvalues: u243 (copy)
            return u243[p252] or 0;
        end;

        local Container = u13.CaseContent.Main.Odds.Frame.Container;
        u13.CaseContent.Main.Odds.Visible = false;

        local function getContentGroupOdds(p253, p254) -- Line: 1866
            -- upvalues: u243 (copy)
            local v255 = 0;

            for _, v in ipairs(p254) do
                if v.rarity == p253.rarity then
                    v255 = v255 + 1;
                end;
            end;

            return (u243[p253.rarity] or 0) / math.max(v255, 1);
        end;

        local function getSpecialGroupOdds(p256, p257) -- Line: 1876
            -- upvalues: Case (copy)
            return Case.specialChance / math.max(#p257, 1);
        end;

        for _, v in ipairs(Case.contents) do
            v242[`{v.skin.weaponName}_{v.skin.skinName}`] = (u243[v.rarity] or 0) / v241[v.rarity];
        end;

        RenderGroupedOdds(Case.contents, getContentGroupOdds, Container, (`contents for case "{p237}"`));
        RenderGroupedOdds(Case.specialContents, getSpecialGroupOdds, Container, (`special contents for case "{p237}"`));
        local v258 = {};

        for _, v in ipairs(Case.contents) do
            if v.rarity then
                v258[v.rarity] = true;
            end;
        end;

        local function SetChanceRowText(p259, p260) -- Line: 1903
            local Right = p259:FindFirstChild("Right");

            if Right then
                Right = Right:FindFirstChild("Label");
            end;

            if Right then
                Right.Text = p260;
            end;
        end;

        for i in pairs(u12.RARITY_PRIORITY) do
            if i ~= "Special" then
                local v261 = u13.CaseContent.Main.CaseChances:FindFirstChild(i);

                if v261 then
                    v261.Visible = v258[i] == true;
                    local v262 = `{math.round((u243[i] or 0) * 100) / 100}%`;
                    local Right = v261:FindFirstChild("Right");

                    if Right then
                        Right = Right:FindFirstChild("Label");
                    end;

                    if Right then
                        Right.Text = v262;
                    end;
                end;
            end;
        end;

        local v263;

        if Case.specialContents == nil then
            v263 = false;
        else
            v263 = #Case.specialContents > 0;
        end;

        local Special = u13.CaseContent.Main.CaseChances:FindFirstChild("Special");

        if Special then
            Special.Visible = v263;
            local v264 = `{Case.specialChance or 0}%`;
            local Right = Special:FindFirstChild("Right");

            if Right then
                Right = Right:FindFirstChild("Label");
            end;

            if Right then
                Right.Text = v264;
            end;
        end;

        if u14 and u14.Menu then
            u14.Menu.Visible = true;
        end;

        CaseSceneController.ShowCaseScene(Case.caseType, Case.name);
        Profiler.defer("UI.Store.CaseContentVisibilityDeferred", function() -- Line: 1936
            -- upvalues: u13 (ref)
            u13.Visible = true;
            u13.CaseContent.Visible = true;
        end);
        ClearFrame(u13.CaseContent.Main.CaseContent.Container, { "UIGridLayout", "UIPadding" });

        if not u13.CaseContent.Main.CaseContent.Visible then
            u13.CaseContent.Main.CaseContent.Visible = true;
        end;

        local table_clone_ret = table.clone(Case.contents);
        table.sort(table_clone_ret, function(p265, p266) -- Line: 1948
            -- upvalues: u12 (ref)
            return (u12.RARITY_PRIORITY[p265.rarity] or 0) < (u12.RARITY_PRIORITY[p266.rarity] or 0);
        end);

        for _, v in ipairs(table_clone_ret) do
            local SkinInformation = Skins.GetSkinInformation(v.skin.weaponName, v.skin.skinName);
            local v267 = Rarities[v.rarity];
            local StoreItemIcon = script_CaseScroll.GetStoreItemIcon(SkinInformation);
            local v268 = GetSkinDisplayName(v.skin.skinName, true);
            local v269 = ReplicatedStorage.Assets.UI.Store.ItemTemplate:Clone();
            local Odds = v269.ItemContent.Content.Odds;
            local v270 = v242[`{v.skin.weaponName}_{v.skin.skinName}`] or 0;
            Odds.Text = `{string.format("%.4f", math.floor(v270 * 10000) / 10000)}%`;
            v269.Bottom.Footer.WeaponName.Text = GetSkinDisplayName.GetWeaponDisplayName(v.skin.weaponName);
            v269.ItemContent.Rarity.BackgroundColor3 = v267.Color;
            v269.ItemContent.Content.Rarity.ImageColor3 = v267.Color;
            v269.Bottom.Footer.SkinName.Text = v268;
            v269.Parent = u13.CaseContent.Main.CaseContent.Container;
            v269.ItemContent.Content.Icon.Image = StoreItemIcon;
            local Charm = v269.ItemContent:FindFirstChild("Charm");

            if Charm and Charm:IsA("ImageLabel") then
                Charm.Visible = false;
            end;

            local v271 = WireCaseItemInspect(v269, v.skin.weaponName, v.skin.skinName, v.skin.type == "Charm" and "Charm" or nil);
            local v272 = GetUserPlatform();
            local v273;

            if table.find(v272, "Mobile") == nil then
                v273 = false;
            else
                v273 = #v272 <= 1;
            end;

            local MobileInspect = v269.ItemContent:FindFirstChild("MobileInspect");

            if MobileInspect then
                if v273 then
                    ActivateButton(MobileInspect);
                    MobileInspect.Activated:Connect(v271);
                else
                    MobileInspect.Visible = false;
                end;
            end;
        end;

        if Case.caseType == "Case" then
            local v274 = ReplicatedStorage.Assets.UI.Store.GoldTemplate:Clone();
            v274.Selectable = true;
            v274.Content.Content.Odds.Text = "0.26%";
            v274.Content.Icon.Image = u12.SPECIAL_CASE_ICONS[Case.caseId] or u12.DEFAULT_CASE_ICON;
            v274.Parent = u13.CaseContent.Main.CaseContent.Container;
            ApplySpecialCardEffect(v274);
        end;
    end;
end;

local function GetGiftRecipientButtons() -- Line: 2005
    -- upvalues: u13 (ref)
    local v275 = {};

    for _, child in ipairs(u13.Gift.Container:GetChildren()) do
        local v276 = child:IsA("GuiObject") and child.Visible and child:FindFirstChild("Button");

        if v276 and v276:IsA("GuiButton") then
            table.insert(v275, v276);
        end;
    end;

    return v275;
end;

local function IsSelectionUsable(p277: userdata?) -- Line: 2018
    if not (p277 and (p277.Parent and p277.Selectable)) then
        return false;
    end;

    while p277 and not p277:IsA("ScreenGui") do
        if p277:IsA("GuiObject") and not p277.Visible then
            return false;
        end;

        p277 = p277.Parent;
    end;

    return p277 ~= nil;
end;

local function refreshGiftNavigation() -- Line: 2035
    -- upvalues: u13 (ref), GetGiftRecipientButtons (copy), u6 (ref), GuiService (copy), IsSelectionUsable (copy)
    local Gift = u13.Gift;
    local v278 = { Gift.Search.TextBox };

    for _, v in ipairs((GetGiftRecipientButtons())) do
        table.insert(v278, v);
    end;

    if Gift.Amount.Visible then
        table.insert(v278, Gift.Amount);

        if Gift.Amount.Container.Visible then
            for _, child in ipairs(Gift.Amount.Container:GetChildren()) do
                if child:IsA("TextButton") then
                    table.insert(v278, child);
                end;
            end;
        end;
    end;

    table.insert(v278, Gift.Close);

    for i, v in ipairs(v278) do
        v.NextSelectionUp = v278[i - 1] or v278[#v278];
        v.NextSelectionDown = v278[i + 1] or v278[1];
        v.NextSelectionLeft = v;
        v.NextSelectionRight = v;
    end;

    if not (u6 and Gift.Visible) then
        return;
    end;

    local SelectedObject = GuiService.SelectedObject;

    if not (SelectedObject and (SelectedObject:IsDescendantOf(Gift) and IsSelectionUsable(SelectedObject))) then
        GuiService.SelectedObject = GetGiftRecipientButtons()[1] or Gift.Search.TextBox;
    end;
end;

u28 = function(p279: string, p280: string) -- Line: 2076
    -- upvalues: u13 (ref), SelectAmountButton (copy), u6 (ref), GuiService (copy), refreshGiftNavigation (copy)
    u13:SetAttribute("GiftProductName", p279);
    u13:SetAttribute("GiftProductType", p280);
    local Amount = u13.Gift.Amount;
    Amount.Header.TextLabel.Text = "1";
    Amount.Visible = p280 == "Case";
    Amount.Container.Visible = false;
    SelectAmountButton(Amount.Container, "1");
    u13.Gift.Visible = true;
    u6 = GuiService.SelectedObject;
    refreshGiftNavigation();
end;

local function PopulateGiftSearchResult(p281: string) -- Line: 2092
    -- upvalues: u13 (ref), Players (copy), ReplicatedStorage (copy), activateGiftTemplate (copy)
    local SearchResult = u13.Gift.Container:FindFirstChild("SearchResult");

    if SearchResult then
        SearchResult:Destroy();
    end;

    local u282 = tonumber(p281);

    if p281 == "" or not u282 then
        return;
    end;

    for _, child in ipairs(u13.Gift.Container:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false;
        end;
    end;

    local success, result = pcall(function() -- Line: 2110
        -- upvalues: Players (ref), u282 (copy)
        return Players:GetNameFromUserIdAsync(u282);
    end);

    if success then
        local v283 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone();
        v283.Player.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={u282}&w=420&h=420`;
        v283.Player.Username.Text = `@{result}`;
        v283.Parent = u13.Gift.Container;
        v283.Name = "SearchResult";
        activateGiftTemplate(v283, u282);
    end;
end;

function u1.OpenTab(p284: string) -- Line: 2126
    -- upvalues: Profiler (copy), u5 (ref), Router (copy), u11 (ref), ScrollToFeaturedSection (copy)
    Profiler.mark("UI.Store.OpenTab");

    if not (p284 ~= "Credits" and p284 ~= "TradeTokens" or u5) then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are not allowed in your region.");

        return;
    end;

    u11 = p284;
    ScrollToFeaturedSection(p284);
end;

function u1.OpenBundleSection() -- Line: 2140
    -- upvalues: Profiler (copy), ScrollToFeaturedSection (copy)
    Profiler.mark("UI.Store.OpenBundleSection");
    ScrollToFeaturedSection("StarterPack");
end;

function u1.PromptTradeTokenPackageForItemPrice(p285: number) -- Line: 2145
    -- upvalues: u12 (copy), DataController (copy), LocalPlayer (copy), DevProducts (copy), MarketplaceService (copy)
    if u12.TRADE_TOKEN_PACKAGES[#u12.TRADE_TOKEN_PACKAGES].Amount < p285 then
        return;
    end;

    local v286 = p285 - (DataController.Get(LocalPlayer, "TradeTokens") or 0);

    if v286 <= 0 then
        return;
    end;

    for _, v in u12.TRADE_TOKEN_PACKAGES do
        if v286 <= v.Amount then
            local v287 = DevProducts[v.ProductName];

            if v287 then
                MarketplaceService:PromptProductPurchase(LocalPlayer, v287.DevProductId);
            end;

            return;
        end;
    end;
end;

function u1.OpenFeaturedBundleSection() -- Line: 2169
    -- upvalues: Profiler (copy), ScrollToFeaturedSection (copy)
    Profiler.mark("UI.Store.OpenFeaturedBundleSection");
    ScrollToFeaturedSection("Console");
end;

u27 = function(p288: string, u289: any, p290: string?, p291: boolean?, p292: string?) -- Line: 2176
    -- upvalues: Profiler (copy), u17 (copy), CleanupCaseOpeningTweens (copy), Cases (copy), Remotes (copy), CaseSceneController (copy), u13 (ref), u14 (ref), MenuState (copy), u12 (copy), GetUnboxedItemRarity (copy), Router (copy), TryProcessResolvedCaseOpenQueue (copy), script_CaseScroll (copy)
    Profiler.mark("UI.Store.OpenCase");

    if p291 == nil then
        p291 = u17.isQuickUnlock;
    end;

    u17.currentCaseIdentifier = p290;
    CleanupCaseOpeningTweens();
    local Case = Cases.GetCase(p288);

    if not Case then
        return;
    end;

    if not p291 then
        u17.isOpening = true;
        u17.currentInventoryItem = u289;
        u13.CaseContent.Visible = false;
        local v293 = Case.caseType == "Package";

        local function startRollAnimation() -- Line: 2211
            -- upvalues: u17 (ref), u14 (ref), Case (copy), u13 (ref), script_CaseScroll (ref), u289 (copy), Router (ref), Remotes (ref), CaseSceneController (ref), MenuState (ref), u12 (ref)
            if not u17.isOpening then
                return;
            end;

            u14.Menu.OpenCase.CaseName.Text = `Unlock {Case.name}`;
            u14.Menu.OpenCase.Visible = true;
            u13.Visible = false;
            u14.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";
            local v294 = script_CaseScroll.RunScrollAnimation(Case, u289);

            if not u17.isOpening then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Notification");
            task.wait(0.5);

            if not u17.isOpening then
                return;
            end;

            u17.isOpening = false;
            u17.currentInventoryItem = nil;
            local currentCaseIdentifier = u17.currentCaseIdentifier;

            if currentCaseIdentifier then
                Remotes.Store.CaseOpenSequenceFinished.Send({
                    CaseIdentifier = currentCaseIdentifier
                });
                u17.currentCaseIdentifier = nil;
            end;

            u14.Menu.OpenCase.Visible = false;
            CaseSceneController.HideCaseScene();
            u13.Tabs.Container.Visible = true;
            u13.CaseContent.Visible = false;
            u14.Menu.Top.Visible = true;
            u13.Top.Visible = true;
            u13.Visible = false;
            MenuState.SetScreen("Inventory");
            Router.broadcastRouter("RunStoreSound", u12.RARITY_TO_DROP_SOUND[v294 and v294.rarity or "Blue"] or "Drop Blue");
            Router.broadcastRouter("RunStoreSound", "Case Close");
            local v295 = u289;
            Router.broadcastRouter("WeaponInspect", v295.Name, v295.Skin, v295.Float, v295.StatTrack, v295.NameTag, v295.Charm, v295.Stickers, v295.Type, v295.Pattern, v295._id, v295.Serial, v295.IsTradeable);
        end;

        if Case.caseType == "Charm Capsule" then
            CaseSceneController.TransitionToUnboxing(startRollAnimation);

            return;
        end;

        if v293 then
            CaseSceneController.TransitionToUnboxing();
            CaseSceneController.WaitForOpeningAnimation();

            if u17.isOpening then
                u17.isOpening = false;
                u17.currentInventoryItem = nil;
                local currentCaseIdentifier = u17.currentCaseIdentifier;

                if currentCaseIdentifier then
                    Remotes.Store.CaseOpenSequenceFinished.Send({
                        CaseIdentifier = currentCaseIdentifier
                    });
                    u17.currentCaseIdentifier = nil;
                end;

                CaseSceneController.HideCaseScene();
                u13.Tabs.Container.Visible = true;
                u13.CaseContent.Visible = false;
                u14.Menu.Top.Visible = true;
                u13.Top.Visible = true;
                u13.Visible = false;
                MenuState.SetScreen("Inventory");
                local v296 = u12.RARITY_TO_DROP_SOUND[GetUnboxedItemRarity(u289, Case)] or "Drop Blue";
                Router.broadcastRouter("RunStoreSound", v296);
                Router.broadcastRouter("RunStoreSound", "Case Close");
                Router.broadcastRouter("WeaponInspect", u289.Name, u289.Skin, u289.Float, u289.StatTrack, u289.NameTag, u289.Charm, u289.Stickers, u289.Type, u289.Pattern, u289._id, u289.Serial, u289.IsTradeable);

                return;
            end;
        else
            CaseSceneController.TransitionToUnboxing();
            task.wait(0.8);
            startRollAnimation();
        end;

        return;
    end;

    if p290 then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = p290
        });
    end;

    CaseSceneController.HideCaseScene();
    u13.Tabs.Container.Visible = true;
    u13.CaseContent.Visible = false;
    u14.Menu.Top.Visible = true;
    u13.Top.Visible = true;
    u13.Visible = false;
    MenuState.SetScreen("Inventory");
    local v297 = u12.RARITY_TO_DROP_SOUND[GetUnboxedItemRarity(u289, Case)] or "Drop Blue";
    Router.broadcastRouter("RunStoreSound", v297);
    Router.broadcastRouter("RunStoreSound", "Case Close");
    Router.broadcastRouter("QuickOpenResolved", p292);
    Router.broadcastRouter("ShowNewItemNotification", u289);
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

local function stopCaseOpening() -- Line: 2266
    -- upvalues: u17 (copy), Router (copy), CleanupCaseOpeningTweens (copy), u25 (copy), script_CaseScroll (copy), CaseSceneController (copy)
    if u17.isOpening then
        Router.broadcastRouter("RunStoreSound", "Case Close");
    end;

    CleanupCaseOpeningTweens();
    u25.isBulkOpening = false;
    u25.inventoryItems = nil;
    u25.bulkIdentifier = nil;
    u25.currentIndex = 0;
    u25.skipped = false;
    u25.caseId = nil;
    u25.total = 0;
    script_CaseScroll.ResetProgressBar();
    local currentInventoryItem = u17.currentInventoryItem;
    u17.isOpening = false;
    u17.currentInventoryItem = nil;
    CaseSceneController.HideCaseScene();

    return currentInventoryItem;
end;

local function finishBulkOpening() -- Line: 2282
    -- upvalues: u25 (copy), CleanupCaseOpeningTweens (copy), script_CaseScroll (copy), u17 (copy), CaseSceneController (copy), u14 (ref), u22 (ref), u13 (ref), Router (copy), Remotes (copy), MenuState (copy), Profiler (copy), TryProcessResolvedCaseOpenQueue (copy)
    local v298 = u25.inventoryItems or {};
    local bulkIdentifier = u25.bulkIdentifier;
    CleanupCaseOpeningTweens();
    script_CaseScroll.ResetProgressBar();
    u17.isOpening = false;
    u17.currentInventoryItem = nil;
    CaseSceneController.HideCaseScene();
    local Close = u14.Menu.OpenCase.Contents.Close;

    if u22 then
        for _, v in ipairs(u22) do
            v.Visible = true;
        end;

        Close.TextLabel.Text = "CLOSE";
        u22 = nil;
    end;

    u14.Menu.OpenCase.Visible = false;
    u13.Tabs.Container.Visible = true;
    u13.CaseContent.Visible = false;
    u14.Menu.Top.Visible = true;
    u13.Top.Visible = true;
    u13.Visible = false;
    u14.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";
    Router.broadcastRouter("RunStoreSound", "Case Close");

    if bulkIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = bulkIdentifier
        });
    end;

    MenuState.SetScreen("Inventory");

    if v298[1] then
        Router.broadcastRouter("ShowNewItemNotification", v298[1]);
    end;

    u25.isBulkOpening = false;
    u25.inventoryItems = nil;
    u25.bulkIdentifier = nil;
    u25.currentIndex = 0;
    u25.skipped = false;
    u25.caseId = nil;
    u25.total = 0;
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

local function skipBulkOpening() -- Line: 2309
    -- upvalues: u25 (copy), CleanupCaseOpeningTweens (copy), finishBulkOpening (copy)
    u25.skipped = true;
    CleanupCaseOpeningTweens();
    finishBulkOpening();
end;

local function BeginBulkOpeningState(p299: string, p300: table, p301: string?) -- Line: 2317
    -- upvalues: u25 (copy)
    u25.isBulkOpening = true;
    u25.inventoryItems = p300;
    u25.bulkIdentifier = p301;
    u25.caseId = p299;
    u25.total = #p300;
    u25.currentIndex = 0;
    u25.skipped = false;
end;

local function IsBulkOpeningInterrupted() -- Line: 2331
    -- upvalues: u17 (copy), u25 (copy)
    return not u17.isOpening or u25.skipped;
end;

local function HoldBulkReveal(p302: number) -- Line: 2336
    -- upvalues: u17 (copy), u25 (copy)
    local v303 = tick();

    while tick() - v303 < p302 and (u17.isOpening and not u25.skipped) do
        task.wait(0.1);
    end;
end;

u29 = function(p304: string, p305: table, p306: string?) -- Line: 2346
    -- upvalues: Profiler (copy), Cases (copy), u25 (copy), CleanupCaseOpeningTweens (copy), u17 (copy), u13 (ref), CaseSceneController (copy), u14 (ref), script_CaseScroll (copy), Router (copy), u12 (copy), HoldBulkReveal (copy), finishBulkOpening (copy)
    Profiler.mark("UI.Store.StartBulkOpening");
    local Case = Cases.GetCase(p304);

    if not Case then
        return;
    end;

    u25.isBulkOpening = true;
    u25.inventoryItems = p305;
    u25.bulkIdentifier = p306;
    u25.caseId = p304;
    u25.total = #p305;
    u25.currentIndex = 0;
    u25.skipped = false;
    CleanupCaseOpeningTweens();
    u17.isOpening = true;
    u17.currentInventoryItem = nil;
    u13.CaseContent.Visible = false;
    local v307 = Case.caseType == "Charm Capsule";

    local function waitForDrag(p308: function) -- Line: 2359
        -- upvalues: u17 (ref), u25 (ref)
        local u309 = false;
        p308(function() -- Line: 2361
            -- upvalues: u309 (ref)
            u309 = true;
        end);

        while not (u309 or (not u17.isOpening or u25.skipped)) do
            task.wait();
        end;
    end;

    if v307 then
        waitForDrag(function(p310) -- Line: 2369
            -- upvalues: CaseSceneController (ref)
            CaseSceneController.TransitionToUnboxing(p310);
        end);
    else
        CaseSceneController.TransitionToUnboxing();
        task.wait(0.8);
    end;

    if not u17.isOpening or u25.skipped then
        return;
    end;

    u14.Menu.OpenCase.CaseName.Text = `Unlock {Case.name}`;
    u14.Menu.OpenCase.Visible = true;
    u13.Visible = false;

    for i = 1, #p305 do
        if not u17.isOpening or u25.skipped then
            break;
        end;

        u25.currentIndex = i;
        local v311 = p305[i];
        u14.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";

        if v307 and i > 1 then
            waitForDrag(function(p312) -- Line: 2392
                -- upvalues: CaseSceneController (ref)
                if not CaseSceneController.ArmDragOpening(p312) then
                    p312();
                end;
            end);

            if not u17.isOpening or u25.skipped then
                break;
            end;
        end;

        local v313 = script_CaseScroll.RunScrollAnimation(Case, v311);

        if not u17.isOpening or u25.skipped then
            break;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Notification");
        Router.broadcastRouter("RunStoreSound", u12.RARITY_TO_DROP_SOUND[v313 and v313.rarity or "Blue"] or "Drop Blue");
        local v314;

        if i == #p305 then
            task.wait(0.5);
            v314 = i;
        else
            HoldBulkReveal(1.5);
            v314 = i;
        end;
    end;

    if u17.isOpening and not u25.skipped then
        finishBulkOpening();
    end;
end;

u30 = function(p315: string, p316: table, p317: table, p318: string?) -- Line: 2421
    -- upvalues: Profiler (copy), u21 (ref), CaseSceneController (copy), u14 (ref), u22 (ref), u29 (ref), u25 (copy), CleanupCaseOpeningTweens (copy), u17 (copy), u13 (ref), SetConsoleOverlay (copy), Router (copy), u12 (copy), HoldBulkReveal (copy), finishBulkOpening (copy)
    Profiler.mark("UI.Store.StartBulkConsoleOpening");

    if #p317 ~= #p316 then
        u21 = nil;
        CaseSceneController.CancelConsoleOpening();
        local Close = u14.Menu.OpenCase.Contents.Close;

        if u22 then
            for _, v in ipairs(u22) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u22 = nil;
        end;

        u29(p315, p316, p318);

        return;
    end;

    u25.isBulkOpening = true;
    u25.inventoryItems = p316;
    u25.bulkIdentifier = p318;
    u25.caseId = p315;
    u25.total = #p316;
    u25.currentIndex = 0;
    u25.skipped = false;
    u21 = nil;
    CleanupCaseOpeningTweens();
    u17.isOpening = true;
    u17.currentInventoryItem = nil;
    u13.CaseContent.Visible = false;
    u13.Visible = false;
    SetConsoleOverlay(true);

    for i, v in ipairs(p316) do
        if not u17.isOpening or u25.skipped then
            break;
        end;

        u25.currentIndex = i;

        if i > 1 or not CaseSceneController.IsConsoleOpening() then
            CaseSceneController.BeginConsoleOpening();
        end;

        local u319 = false;

        if not CaseSceneController.ResolveConsoleOpening(p317[i], function() -- Line: 2456
            -- upvalues: u319 (ref)
            u319 = true;
        end) then
            break;
        end;

        local v320 = v;

        while u17.isOpening and not (u25.skipped or u319) do
            task.wait();
        end;

        if not u17.isOpening or u25.skipped then
            break;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Notification");
        Router.broadcastRouter("RunStoreSound", u12.RARITY_TO_DROP_SOUND[(v320.Type == "Melee" or v320.Type == "Glove") and "Special" or (v320.Rarity or "Blue")] or "Drop Blue");
        HoldBulkReveal(i == #p316 and 0.5 or 1.5);
    end;

    if u17.isOpening and not u25.skipped then
        finishBulkOpening();
    end;
end;

function u1.BeginOpenCaseRequest(p321: boolean) -- Line: 2481
    -- upvalues: u18 (ref), u19 (copy), u17 (copy)
    u18 = u18 + 1;
    local v322 = tostring(u18);
    u19[v322] = {
        IsQuickUnlock = p321
    };
    u17.isPendingOpenRequest = true;
    u17.pendingOpenRequestId = v322;
    u17.isQuickUnlock = p321;

    return v322;
end;

function u1.ClearPendingOpenCaseRequest(p323: string) -- Line: 2487
    -- upvalues: u17 (copy)
    if u17.pendingOpenRequestId ~= p323 then
        return false;
    end;

    u17.isPendingOpenRequest = false;
    u17.pendingOpenRequestId = nil;
    u17.isQuickUnlock = false;

    return true;
end;

local function openCreatorCode() -- Line: 2498
    -- upvalues: u13 (ref), DataController (copy), LocalPlayer (copy), TweenService (copy)
    u13.CreatorCode:SetAttribute("ResponseId", nil);
    u13.CreatorCode.Container.Body.Response.Text = "";
    u13.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
    u13.CreatorCode.Container.Body.CreatorName.TextBox.Text = DataController.Get(LocalPlayer, "CreatorCode") or "";
    u13.CreatorCode.Position = UDim2.fromScale(0.5, -1);
    u13.CreatorCode.Visible = true;
    u13.Tabs.Visible = false;
    TweenService:Create(u13.CreatorCode, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.5)
    }):Play();
end;

local function closeCreatorCode() -- Line: 2515
    -- upvalues: TweenService (copy), u13 (ref)
    TweenService:Create(u13.CreatorCode, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, -1)
    }):Play();
    task.wait(0.35);

    if u13.CreatorCode.Visible then
        u13.CreatorCode.Visible = false;
        u13.Tabs.Visible = true;
    end;
end;

u26 = function(p324: string) -- Line: 2528
    -- upvalues: CaseSceneController (copy), u10 (ref), u9 (ref), u13 (ref), MenuState (copy), u14 (ref)
    CaseSceneController.HideCaseScene();
    u10 = nil;
    u9 = nil;
    u13.CaseContent:SetAttribute("WasVisibleBeforeInspect", false);

    if p324 == "Inventory" then
        MenuState.SetScreen("Inventory");
    end;

    u13.Tabs.Container.Visible = true;
    u13.CaseContent.Visible = false;
    u14.Menu.Top.Visible = true;
    u13.Top.Visible = true;

    if p324 ~= "Inventory" then
        u13.Visible = true;

        return;
    end;

    u14.Menu.Inventory.Visible = true;
    u13.Visible = false;
end;

function u1.Initialize(p325, p326) -- Line: 2551
    -- upvalues: Profiler (copy), u14 (ref), u13 (ref), script_CaseScroll (copy), u17 (copy), u12 (copy), script_StarterPack (copy), u15 (copy), fitCaseGrid (copy), ActivateButton (copy), Router (copy), openCreatorCode (copy), CloseButtonRegistry (copy), u21 (ref), CaseSceneController (copy), u25 (copy), CleanupCaseOpeningTweens (copy), finishBulkOpening (copy), Remotes (copy), MenuState (copy), TryProcessResolvedCaseOpenQueue (copy), u10 (ref), Cases (copy), u9 (ref), CollectCaseIdentifiers (copy), u18 (ref), u19 (copy), SetConsoleOverlay (copy), u23 (copy), u22 (ref), purchaseCase (copy), u26 (ref), closeCreatorCode (copy), UpdateCreatorCodeResponse (copy), ClearFrame (copy), u6 (ref), GuiService (copy), IsSelectionUsable (copy), u1 (copy), RunService (copy), Cases2 (copy), DataController (copy), LocalPlayer (copy), DoCreditPurchase (copy), MarketplaceService (copy), setupCurrencyFrame (copy), LoadProductPrice (copy), u5 (ref), DevProducts (copy), CommaNumber (copy), LoadProductInfo (copy), script_Hover (copy), SetupTaggedInspectButtons (copy), updateCases (copy), StartBackgroundProductLoading (copy), RunServiceController (copy), CollectionService (copy), refreshGiftNavigation (copy), PopulateGiftSearchResult (copy), u8 (ref), u7 (ref), u2 (copy), u3 (copy), u4 (copy)
    Profiler.mark("UI.Store.Initialize");
    u14 = p325;
    u13 = p326;
    script_CaseScroll.Bind(u14, u17, u12);
    script_StarterPack.Bind(u13, u14);
    u15.Label = u13.Tabs.Container.Featured.Container.Console.Pack.Container.Top.Title.Top.Timer;
    local Cases3 = u13.Tabs.Container.Featured.Container.Cases.Container.Cases;
    local u327 = false;

    local function queueCaseGridFit() -- Line: 2563
        -- upvalues: u327 (ref), fitCaseGrid (ref), Cases3 (copy)
        if u327 then
            return;
        end;

        u327 = true;
        task.defer(function() -- Line: 2568
            -- upvalues: u327 (ref), fitCaseGrid (ref), Cases3 (ref)
            u327 = false;
            fitCaseGrid(Cases3);
        end);
    end;

    Cases3.ChildAdded:Connect(queueCaseGridFit);
    Cases3.ChildRemoved:Connect(queueCaseGridFit);
    Cases3:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueCaseGridFit);

    if not u327 then
        u327 = true;
        task.defer(function() -- Line: 2568
            -- upvalues: u327 (ref), fitCaseGrid (ref), Cases3 (copy)
            u327 = false;
            fitCaseGrid(Cases3);
        end);
    end;

    if u13.Top.Categories.Visible then
        u13.Top.Categories.Visible = false;
    end;

    local Container = u13.Tabs.Container.Featured.Container;
    local u328 = nil;
    u328 = u13:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2588
        -- upvalues: u13 (ref), u328 (ref), Container (copy)
        if u13.Visible and u328 then
            u328:Disconnect();
            u328 = nil;
            Container.CanvasPosition = Vector2.zero;
        end;
    end);
    ActivateButton(u13.Tabs.Container.Featured.Container.CreatorCode.CreatorCodeButton);
    u13.Tabs.Container.Featured.Container.CreatorCode.CreatorCodeButton.MouseButton1Click:Connect(function() -- Line: 2598
        -- upvalues: Router (ref), openCreatorCode (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        openCreatorCode();
    end);
    CloseButtonRegistry.Add(u14.Menu.OpenCase, u14.Menu.OpenCase.Contents.Close, function() -- Line: 2604
        -- upvalues: u21 (ref), CaseSceneController (ref), u25 (ref), CleanupCaseOpeningTweens (ref), finishBulkOpening (ref), u17 (ref), Router (ref), script_CaseScroll (ref), u14 (ref), Remotes (ref), u13 (ref), MenuState (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref)
        if u21 then
            CaseSceneController.SkipConsoleOpening();

            return;
        end;

        if u25.isBulkOpening then
            u25.skipped = true;
            CleanupCaseOpeningTweens();
            finishBulkOpening();

            return;
        end;

        if u17.isOpening then
            Router.broadcastRouter("RunStoreSound", "Case Close");
        end;

        CleanupCaseOpeningTweens();
        u25.isBulkOpening = false;
        u25.inventoryItems = nil;
        u25.bulkIdentifier = nil;
        u25.currentIndex = 0;
        u25.skipped = false;
        u25.caseId = nil;
        u25.total = 0;
        script_CaseScroll.ResetProgressBar();
        local currentInventoryItem = u17.currentInventoryItem;
        u17.isOpening = false;
        u17.currentInventoryItem = nil;
        CaseSceneController.HideCaseScene();
        u14.Menu.OpenCase.Visible = false;
        local currentCaseIdentifier = u17.currentCaseIdentifier;

        if currentCaseIdentifier then
            Remotes.Store.CaseOpenSequenceFinished.Send({
                CaseIdentifier = currentCaseIdentifier
            });
            u17.currentCaseIdentifier = nil;
        end;

        u13.Tabs.Container.Visible = true;
        u13.CaseContent.Visible = false;
        u14.Menu.Top.Visible = true;
        u13.Top.Visible = true;
        u13.Visible = false;
        MenuState.SetScreen("Inventory");

        if currentInventoryItem then
            Router.broadcastRouter("WeaponInspect", currentInventoryItem.Name, currentInventoryItem.Skin, currentInventoryItem.Float, currentInventoryItem.StatTrack, currentInventoryItem.NameTag, currentInventoryItem.Charm, currentInventoryItem.Stickers, currentInventoryItem.Type, currentInventoryItem.Pattern, currentInventoryItem._id, currentInventoryItem.Serial, currentInventoryItem.IsTradeable);

            return;
        end;

        u14.Menu.Inventory.Visible = true;
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Open);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.MouseButton1Click:Connect(function() -- Line: 2626
        -- upvalues: u10 (ref), u17 (ref), Cases (ref), Router (ref), u9 (ref), u13 (ref), CollectCaseIdentifiers (ref), u18 (ref), u19 (ref), u21 (ref), SetConsoleOverlay (ref), CaseSceneController (ref), Remotes (ref), u12 (ref), u23 (ref), u14 (ref), u22 (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref)
        if not u10 or (u17.isOpening or u17.isPendingOpenRequest) then
            return;
        end;

        if not Cases.HasCaseModel(u10.caseId) then
            Router.broadcastRouter("CreateMenuNotification", "Error", "This case can\'t be opened right now.");

            return;
        end;

        if not u9 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Case identifier missing. Please reopen the case.");

            return;
        end;

        local v329 = u10.caseType == "Console";
        local v330 = tonumber(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text) or 1;
        local v331;

        if v330 > 1 then
            v331 = CollectCaseIdentifiers(u10.name, v330);

            if #v331 < 2 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "Not enough cases in your inventory.");

                return;
            end;
        else
            v331 = { u9 };
        end;

        local v332 = not v329;

        if v332 then
            if v330 == 1 then
                v332 = u17.isQuickUnlock;
            else
                v332 = false;
            end;
        end;

        local v333 = v330 > 1 and "Bulk" or (v332 and "Quick Open" or "Standard");
        u18 = u18 + 1;
        local u334 = tostring(u18);
        u19[u334] = {
            IsQuickUnlock = v332
        };
        u17.isPendingOpenRequest = true;
        u17.pendingOpenRequestId = u334;
        u17.isQuickUnlock = v332;

        if v329 then
            u21 = u334;
            u17.isOpening = true;
            u17.currentCaseIdentifier = v331[1];
            u13.CaseContent.Visible = false;
            u13.Visible = false;
            SetConsoleOverlay(true);
            CaseSceneController.BeginConsoleOpening();
            Remotes.Store.OpenConsole.Send({
                CaseIdentifiers = v331,
                CaseId = u10.caseId,
                RequestId = u334
            });
        else
            Remotes.Store.OpenCase.Send({
                CaseIdentifiers = v331,
                OpenType = v333,
                CaseId = u10.caseId,
                RequestId = u334
            });
        end;

        task.delay(u12.OPEN_CASE_REQUEST_TIMEOUT * (v330 > 1 and 2 or 1), function() -- Line: 2677
            -- upvalues: u17 (ref), u334 (copy), u19 (ref), u21 (ref), u23 (ref), CaseSceneController (ref), u14 (ref), u22 (ref), u13 (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref), Router (ref)
            if u17.isPendingOpenRequest and u17.pendingOpenRequestId == u334 then
                local v335 = u334;

                if v335 then
                    if u17.pendingOpenRequestId == v335 then
                        u17.isPendingOpenRequest = false;
                        u17.pendingOpenRequestId = nil;
                        u17.isQuickUnlock = false;
                    end;

                    u19[v335] = nil;
                end;

                if u21 == u334 then
                    u23[u334] = true;
                    u21 = nil;
                    u17.isOpening = false;
                    u17.currentInventoryItem = nil;
                    u17.currentCaseIdentifier = nil;
                    CaseSceneController.CancelConsoleOpening();
                    local Close = u14.Menu.OpenCase.Contents.Close;

                    if u22 then
                        for _, v in ipairs(u22) do
                            v.Visible = true;
                        end;

                        Close.TextLabel.Text = "CLOSE";
                        u22 = nil;
                    end;

                    u14.Menu.OpenCase.Visible = false;
                    u13.Visible = true;
                    u13.Tabs.Container.Visible = false;
                    u13.CaseContent.Visible = true;
                    u14.Menu.Top.Visible = false;
                    u13.Top.Visible = false;
                    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
                else
                    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
                end;

                Router.broadcastRouter("CreateMenuNotification", "Error", "Opening case timed out. Please try again.");
            end;
        end);
    end);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.MouseButton1Click:Connect(function() -- Line: 2694
        -- upvalues: u10 (ref), purchaseCase (ref), u13 (ref)
        if u10 then
            purchaseCase(u10, (tonumber(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text)));
        end;
    end);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.Close);
    CloseButtonRegistry.Add(u13.CaseContent, u13.CaseContent.Main.Bottom.Buttons.Close, function() -- Line: 2705
        -- upvalues: u17 (ref), u26 (ref), u13 (ref)
        if not u17.isPendingOpenRequest then
            u26(u13.CaseContent:GetAttribute("State") == "Inspect" and "Store" or "Inventory");
        end;
    end);
    ActivateButton(u13.CreatorCode.Container.Action.Close);
    CloseButtonRegistry.Add(u13.CreatorCode, u13.CreatorCode.Container.Action.Close, closeCreatorCode);
    ActivateButton(u13.CreatorCode.Container.Body.CreatorName.Clear);
    u13.CreatorCode.Container.Body.CreatorName.Clear.MouseButton1Click:Connect(function() -- Line: 2717
        -- upvalues: u13 (ref), Remotes (ref)
        u13.CreatorCode.Container.Body.CreatorName.TextBox.Text = "";
        Remotes.UI.EquipCreatorCode.Send({
            CreatorCode = ""
        });
    end);
    ActivateButton(u13.CreatorCode.Container.Action.Confirm);
    u13.CreatorCode.Container.Action.Confirm.MouseButton1Click:Connect(function() -- Line: 2724
        -- upvalues: u13 (ref), Router (ref), UpdateCreatorCodeResponse (ref), Remotes (ref)
        local Text = u13.CreatorCode.Container.Body.CreatorName.TextBox.Text;
        u13.CreatorCode.Container.Action.Confirm.Title.Text = "SEARCHING..";
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if Text and Text ~= "" then
            Remotes.UI.EquipCreatorCode.Send({
                CreatorCode = Text
            });

            return;
        end;

        UpdateCreatorCodeResponse("Error", "Creator code cannot be empty.");
    end);
    ClearFrame(u13.Gift.Container, { "UICorner", "UIListLayout" });
    CloseButtonRegistry.Add(u13.Gift, u13.Gift.Close, function() -- Line: 2738
        -- upvalues: Router (ref), u13 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u13.Gift.Visible = false;
    end);
    u13.Gift:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2743
        -- upvalues: u13 (ref), u6 (ref), GuiService (ref), IsSelectionUsable (ref)
        if u13.Gift.Visible or not u6 then
            return;
        end;

        local v336;

        if IsSelectionUsable(u6) then
            v336 = u6;
        else
            v336 = u13.Top.Currency.Credits.Buy;
        end;

        GuiService.SelectedObject = v336;
        u6 = nil;
    end);
    ActivateButton(u13.Top.Currency.Credits.Buy);
    u13.Top.Currency.Credits.Buy.MouseButton1Click:Connect(function() -- Line: 2755
        -- upvalues: u1 (ref)
        u1.OpenTab("Credits");
    end);
    local TradeTokens2 = u13.Top.Currency.TradeTokens;
    TradeTokens2.Visible = true;
    local PurchaseMore = TradeTokens2.PurchaseMore;
    ActivateButton(PurchaseMore);
    PurchaseMore.MouseButton1Click:Connect(function() -- Line: 2763
        -- upvalues: u1 (ref)
        u1.OpenTab("TradeTokens");
    end);

    for _, child in u13.CaseContent.Main.Bottom.SubButtons.CenterButtons:GetChildren() do
        if child:IsA("ImageButton") then
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 2773
                -- upvalues: u10 (ref), Cases (ref), RunService (ref), Cases2 (ref), child (copy), DataController (ref), LocalPlayer (ref), u12 (ref), DoCreditPurchase (ref), MarketplaceService (ref)
                if not (u10 and (Cases.IsCaseForSale(u10.caseId) or RunService:IsStudio())) then
                    return;
                end;

                if not Cases.HasCaseModel(u10.caseId) then
                    return;
                end;

                local v337 = Cases2[u10.name];

                if not v337 then
                    return;
                end;

                local v338 = v337.Amounts[tonumber(child.Name)];

                if not v338 or v338.Offsale ~= false then
                    return;
                end;

                local v339 = DataController.Get(LocalPlayer, "TradeTokens");
                local BasePrice = v338.BasePrice;

                if math.floor(((not BasePrice or BasePrice <= 0) and (v338.Price or 0) or BasePrice) * u12.TRADE_TOKEN_CASE_MARKUP) <= v339 then
                    DoCreditPurchase(u10.name, v338, (tonumber(child.Name)));

                    return;
                end;

                MarketplaceService:PromptProductPurchase(LocalPlayer, v338.ID);
            end);
        end;
    end;

    for _, v in { "Credits", "TradeTokens" } do
        local v340 = v;

        for _, child in ipairs(u13.Tabs.Container.Featured.Container[v]:GetChildren()) do
            if child:IsA("Frame") then
                setupCurrencyFrame(child, v340 == "TradeTokens");
            end;
        end;
    end;

    script_StarterPack.Setup(LoadProductPrice, DoCreditPurchase, function() -- Line: 2809
        -- upvalues: u5 (ref)
        return u5;
    end);
    local Button = u13.Tabs.Container.Featured.Container.Console.Pack:FindFirstChild("Button");

    if Button and Button:IsA("GuiButton") then
        Button.Selectable = false;
        Button.Active = false;
    end;

    for _, child in u13.Tabs.Container.Featured.Container.Console.Pack.CenterButtons:GetChildren() do
        if child:IsA("ImageButton") then
            local u341 = DevProducts[`{child.Name} Consoles`];

            if u341 then
                local function u343(p342) -- Line: 2827
                    -- upvalues: child (copy), CommaNumber (ref)
                    child.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(p342)}`;
                end;

                if u341.Price and u343 then
                    local Price = u341.Price;
                    child.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(Price)}`;
                end;

                LoadProductInfo(u341.DevProductId, function(p344) -- Line: 252
                    -- upvalues: u341 (copy), u343 (copy)
                    if not (p344 and p344.PriceInRobux) then
                        return;
                    end;

                    u341.BasePrice = p344.UserBasePriceInRobux or u341.Price;
                    u341.Price = p344.PriceInRobux;

                    if u343 then
                        u343(u341.Price);
                    end;
                end);
                ActivateButton(child);
                child.MouseButton1Click:Connect(function() -- Line: 2832
                    -- upvalues: u5 (ref), DataController (ref), LocalPlayer (ref), u341 (copy), u12 (ref), DoCreditPurchase (ref), child (copy), MarketplaceService (ref), Router (ref)
                    if u5 then
                        local v345 = DataController.Get(LocalPlayer, "TradeTokens");
                        local v346 = u341;
                        local BasePrice = v346.BasePrice;

                        if math.floor(((not BasePrice or BasePrice <= 0) and (v346.Price or 0) or BasePrice) * u12.TRADE_TOKEN_CASE_MARKUP) <= v345 then
                            DoCreditPurchase(`{child.Name} Consoles`, u341, nil, (tonumber(child.Name)));
                        else
                            MarketplaceService:PromptProductPurchase(LocalPlayer, u341.DevProductId);
                        end;

                        Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    end;
                end);
            end;
        end;
    end;

    script_Hover.Setup(u13, u12);

    for _, v in ipairs(u12.INSPECTABLE_ITEM_TAGS) do
        SetupTaggedInspectButtons(v);
    end;

    updateCases();
    StartBackgroundProductLoading();
    RunServiceController.BindToHeartbeat("UI.Store.Rotaters", function(p347) -- Line: 2858
        -- upvalues: Profiler (ref), u14 (ref), u13 (ref), CollectionService (ref)
        Profiler.mark("UI.Store.RotaterHeartbeat");

        if not u14.Menu.Visible then
            return;
        end;

        if not (u13.Visible or u14.Menu.Dashboard.Visible) then
            return;
        end;

        for _, v in ipairs(CollectionService:GetTagged("StoreRotaterFrame")) do
            v.Rotation = v.Rotation + p347 * 25;
        end;
    end);
    u13.Gift.Search.TextBox.Focused:Connect(function() -- Line: 2872
        -- upvalues: u13 (ref), refreshGiftNavigation (ref)
        local SearchResult = u13.Gift.Container:FindFirstChild("SearchResult");

        if SearchResult then
            SearchResult:Destroy();
        end;

        for _, child in ipairs(u13.Gift.Container:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = true;
            end;
        end;

        refreshGiftNavigation();
    end);
    u13.Gift.Search.TextBox.FocusLost:Connect(function() -- Line: 2887
        -- upvalues: PopulateGiftSearchResult (ref), u13 (ref), refreshGiftNavigation (ref)
        PopulateGiftSearchResult(u13.Gift.Search.TextBox.Text);
        refreshGiftNavigation();
    end);
    RunServiceController.BindToHeartbeat("UI.Store.TimersAndCredits", function(p348) -- Line: 2893
        -- upvalues: u13 (ref), u14 (ref), u8 (ref), u7 (ref), u1 (ref), script_StarterPack (ref), Profiler (ref), CommaNumber (ref), u2 (ref), u3 (ref), u4 (ref)
        local Visible = u13.Visible;

        if not (Visible or u14 and u14.Menu and u14.Menu.Visible) then
            u8 = -1;
            u7 = 1;

            return;
        end;

        if Visible then
            local ServerTimeNow = workspace:GetServerTimeNow();
            local math_floor_ret = math.floor(ServerTimeNow);

            if math_floor_ret ~= u8 then
                u8 = math_floor_ret;
                u1.RefreshFeaturedConsoleTimer(math_floor_ret);
            end;
        end;

        u7 = u7 + p348;

        if u7 >= 1 then
            u7 = u7 % 1;
            local ServerTimeNow = workspace:GetServerTimeNow();
            local math_floor_ret = math.floor(ServerTimeNow);
            script_StarterPack.Refresh(math_floor_ret);
        end;

        if not Visible then
            return;
        end;

        Profiler.mark("UI.Store.CreditsHeartbeat");

        if not u14.Menu.Visible then
            return;
        end;

        local TextLabel = u13.Top.Currency.Credits.TextLabel;
        local Position = u2:getPosition();
        TextLabel.Text = CommaNumber((math.round(Position)));
        u2:update(p348);
        local TextLabel2 = u13.Top.Currency.TradeTokens.TextLabel;
        local Position2 = u3:getPosition();
        TextLabel2.Text = CommaNumber((math.round(Position2)));
        u3:update(p348);
        local TextLabel3 = u13.Top.Currency.Tickets.TextLabel;
        local Position3 = u4:getPosition();
        TextLabel3.Text = CommaNumber((math.round(Position3)));
        u4:update(p348);
    end);
end;

local function hidePaidCurrencyPurchaseEntryPoints() -- Line: 2939
    -- upvalues: u13 (ref)
    u13.Top.Categories.Credits.Visible = false;
    u13.Top.Currency.Credits.Buy.Visible = false;
    u13.Top.Categories.TradeTokens.Visible = false;
    u13.Top.Currency.TradeTokens.PurchaseMore.Visible = false;
    u13.Tabs.Container.Featured.Container.Credits.Visible = false;
    u13.Tabs.Container.Featured.Container.TradeTokens.Visible = false;
end;

function u1.GetConsoleVignetteGradient() -- Line: 2950
    -- upvalues: u1 (copy), u13 (ref)
    local v349 = rawget(u1, "ConsoleVignetteGradient");

    if v349 then
        return v349;
    end;

    local Console = u13.Tabs.Container.Featured.Container:FindFirstChild("Console");

    if Console then
        Console = Console:FindFirstChild("AnimatedVignette", true);
    end;

    if not (Console and Console:IsA("ImageLabel")) then
        return nil;
    end;

    local v350 = Console:FindFirstChildOfClass("UIGradient");

    if not v350 then
        return nil;
    end;

    rawset(u1, "ConsoleVignetteImage", Console);
    rawset(u1, "ConsoleVignetteGradient", v350);
    rawset(u1, "ConsoleVignetteDefaultRotation", v350.Rotation);
    rawset(u1, "ConsoleVignetteDefaultTransparency", v350.Transparency);
    rawset(u1, "ConsoleVignetteDefaultImageTransparency", Console.ImageTransparency);

    return v350;
end;

function u1.SetConsoleVignettePulse(p351: number) -- Line: 2977
    -- upvalues: u1 (copy)
    local v352 = rawget(u1, "ConsoleVignetteGradient");

    if v352 then
        v352.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, 0.9 - p351 * 0.1),
            NumberSequenceKeypoint.new(0.45, 0.55 - p351 * 0.3),
            NumberSequenceKeypoint.new(0.58, 0.38 - p351 * 0.22),
            NumberSequenceKeypoint.new(0.82, 0.78 - p351 * 0.16),
            NumberSequenceKeypoint.new(1, 1)
        });
    end;

    local v353 = rawget(u1, "ConsoleVignetteImage");

    if v353 then
        v353.ImageTransparency = 0.58 - p351 * 0.16;
    end;
end;

u12.CONSOLE_VIGNETTE_CLEANUP = { { "ConsoleVignetteTween", "Cancel" }, { "ConsoleVignettePulseTween", "Cancel" }, { "ConsoleVignettePulseConnection", "Disconnect" }, { "ConsoleVignettePulseValue", "Destroy" } };

function u1.StopConsoleVignetteTween() -- Line: 3005
    -- upvalues: u12 (copy), u1 (copy)
    for _, v in u12.CONSOLE_VIGNETTE_CLEANUP do
        local v354 = v[1];
        local v355 = v[2];
        local v356 = rawget(u1, v354);

        if v356 then
            v356[v355](v356);
            rawset(u1, v354, nil);
        end;
    end;

    local v357 = rawget(u1, "ConsoleVignetteGradient");

    if v357 then
        v357.Rotation = rawget(u1, "ConsoleVignetteDefaultRotation") or -180;
        v357.Transparency = rawget(u1, "ConsoleVignetteDefaultTransparency") or v357.Transparency;
    end;

    local v358 = rawget(u1, "ConsoleVignetteImage");

    if v358 then
        v358.ImageTransparency = rawget(u1, "ConsoleVignetteDefaultImageTransparency") or 0.5;
    end;
end;

function u1.UpdateConsoleVignetteTween() -- Line: 3029
    -- upvalues: u13 (ref), u1 (copy), TweenService (copy)
    if not u13.Visible then
        u1.StopConsoleVignetteTween();

        return;
    end;

    if rawget(u1, "ConsoleVignetteTween") then
        return;
    end;

    local ConsoleVignetteGradient = u1.GetConsoleVignetteGradient();

    if not ConsoleVignetteGradient then
        return;
    end;

    ConsoleVignetteGradient.Rotation = rawget(u1, "ConsoleVignetteDefaultRotation") or -180;
    local v359 = TweenService:Create(ConsoleVignetteGradient, TweenInfo.new(14, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = ConsoleVignetteGradient.Rotation + 360
    });
    rawset(u1, "ConsoleVignetteTween", v359);
    v359:Play();
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    rawset(u1, "ConsoleVignettePulseValue", NumberValue);
    local PropertyChangedSignal = NumberValue:GetPropertyChangedSignal("Value");
    rawset(u1, "ConsoleVignettePulseConnection", PropertyChangedSignal:Connect(function() -- Line: 3059
        -- upvalues: u1 (ref), NumberValue (copy)
        u1.SetConsoleVignettePulse(NumberValue.Value);
    end));
    u1.SetConsoleVignettePulse(0);
    local v360 = TweenService:Create(NumberValue, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Value = 1
    });
    rawset(u1, "ConsoleVignettePulseTween", v360);
    v360:Play();
end;

local function BindAmountButtonHover(u361: userdata) -- Line: 3076
    u361.MouseEnter:Connect(function() -- Line: 3077
        -- upvalues: u361 (copy)
        if not u361:GetAttribute("Selected") then
            u361.Frame.BackgroundTransparency = 0.5;
        end;
    end);
    u361.MouseLeave:Connect(function() -- Line: 3082
        -- upvalues: u361 (copy)
        if not u361:GetAttribute("Selected") then
            u361.Frame.BackgroundTransparency = 1;
        end;
    end);
end;

function u1.Start() -- Line: 3089
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), ReplicatedStorage (copy), u15 (copy), u1 (copy), PolicyService (copy), u5 (ref), hidePaidCurrencyPurchaseEntryPoints (copy), u13 (ref), ActivateCategoryButton (copy), MenuState (copy), u12 (copy), u11 (ref), GamepadNavigation (copy), ActivateButton (copy), BindAmountButtonHover (copy), u10 (ref), CommaNumber (copy), SelectAmountButton (copy), refreshGiftNavigation (copy), GuiService (copy), script_StarterPack (copy), u2 (copy), RefreshCaseAmountButtons (copy), u3 (copy), u4 (copy), Constants (copy), Cases (copy), RefreshCaseListings (copy), Remotes (copy), UpdateCreatorCodeResponse (copy), closeCreatorCode (copy), u19 (copy), u17 (copy), u20 (copy), TryProcessResolvedCaseOpenQueue (copy), u23 (copy), u21 (ref), u30 (ref), u24 (ref), CaseSceneController (copy), u14 (ref), u22 (ref), IsSelectionUsable (copy), Observers (copy), activateGiftTemplate (copy)
    debug.setmemorycategory("UI.Store.Start");
    Profiler.mark("UI.Store.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Store.Start.DataLoaded");
    require(ReplicatedStorage.Controllers.TimerController).ListenToTimerChanged(u15.Source, function(p362) -- Line: 3096
        -- upvalues: u15 (ref), u1 (ref)
        u15.Tick = p362;
        local ServerTimeNow = workspace:GetServerTimeNow();
        u15.ReceivedAt = math.floor(ServerTimeNow);
        u1.RefreshFeaturedConsoleTimer(u15.ReceivedAt);
    end);
    local success, result = pcall(function() -- Line: 3102
        -- upvalues: PolicyService (ref), LocalPlayer (ref)
        return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
    end);
    Profiler.mark("UI.Store.Start.PolicyLoaded");

    if success and result then
        u5 = not result.ArePaidRandomItemsRestricted;
    end;

    if not u5 then
        hidePaidCurrencyPurchaseEntryPoints();
    end;

    u13:GetPropertyChangedSignal("Visible"):Connect(u1.UpdateConsoleVignetteTween);
    u1.UpdateConsoleVignetteTween();

    for _, child in ipairs(u13.Top.Categories:GetChildren()) do
        if child:IsA("ImageButton") then
            ActivateCategoryButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 3123
                -- upvalues: u1 (ref), child (copy)
                u1.OpenTab(child.Name);
            end);
        end;
    end;

    MenuState.RegisterBumperOverride(u13, function(p363: boolean) -- Line: 3132
        -- upvalues: u13 (ref), MenuState (ref), u12 (ref), u11 (ref), u1 (ref), GamepadNavigation (ref)
        if not u13.Tabs.Visible then
            return false;
        end;

        local NextBumperTab = MenuState.GetNextBumperTab(u13.Top.Categories, u12.TAB_ORDER, u11, p363);

        if NextBumperTab and NextBumperTab ~= u11 then
            task.spawn(function() -- Line: 3141
                -- upvalues: u1 (ref), NextBumperTab (copy), u13 (ref), u11 (ref), MenuState (ref), GamepadNavigation (ref)
                u1.OpenTab(NextBumperTab);
                local v364 = u13.Tabs.Container.Featured.Container:FindFirstChild(NextBumperTab);

                if u11 == NextBumperTab and (v364 and (MenuState.IsSelectionWithin(u13.Tabs) and not MenuState.IsSelectionWithin(v364))) then
                    GamepadNavigation.Focus(v364);
                end;
            end);
        end;

        return true;
    end, u13, u13.Tabs);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.MouseButton1Click:Connect(function() -- Line: 3162
        -- upvalues: u13 (ref), Profiler (ref)
        local Container = u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container;
        Container.Visible = not Container.Visible;

        if not Container.Visible then
            u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 180;

            return;
        end;

        u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 0;
        local Scroll = Container.Scroll;
        Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 519
            -- upvalues: Scroll (copy)
            local math_max_ret = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteWindowSize.Y);
            Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, math_max_ret);
        end);
    end);
    ActivateButton(u13.CaseContent.Main.Odds.Frame.Close);
    ActivateButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds);
    u13.CaseContent.Main.Odds.Frame.Close.MouseButton1Click:Connect(function() -- Line: 3177
        -- upvalues: u13 (ref)
        u13.CaseContent.Main.Odds.Visible = false;
    end);
    u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds.MouseButton1Click:Connect(function() -- Line: 3181
        -- upvalues: u13 (ref)
        u13.CaseContent.Main.Odds.Visible = true;
    end);

    for _, child in ipairs(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            BindAmountButtonHover(child);
            child.MouseButton1Click:Connect(function() -- Line: 3191
                -- upvalues: u10 (ref), child (copy), u13 (ref), CommaNumber (ref), SelectAmountButton (ref)
                local v365 = u10.price * tonumber(child.Name);
                u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = `BUY <font color="#ffda0f">({CommaNumber(v365)})</font>`;
                u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = tostring(child.Name);
                u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Visible = false;
                SelectAmountButton(u13.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll, child);
            end);
        end;
    end;

    u13.Gift.Amount.MouseButton1Click:Connect(function() -- Line: 3204
        -- upvalues: u13 (ref), Profiler (ref), refreshGiftNavigation (ref)
        local Container = u13.Gift.Amount.Container;
        Container.Visible = not Container.Visible;

        if Container.Visible then
            u13.Gift.Amount.Header.ImageLabel.Rotation = 0;
            Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 519
                -- upvalues: Container (copy)
                local math_max_ret = math.max(0, Container.AbsoluteCanvasSize.Y - Container.AbsoluteWindowSize.Y);
                Container.CanvasPosition = Vector2.new(Container.CanvasPosition.X, math_max_ret);
            end);
        else
            u13.Gift.Amount.Header.ImageLabel.Rotation = 180;
        end;

        refreshGiftNavigation();
    end);

    for _, child in ipairs(u13.Gift.Amount.Container:GetChildren()) do
        if child:IsA("TextButton") then
            BindAmountButtonHover(child);
            child.MouseButton1Click:Connect(function() -- Line: 3220
                -- upvalues: u13 (ref), child (copy), GuiService (ref), SelectAmountButton (ref), refreshGiftNavigation (ref)
                u13.Gift.Amount.Header.TextLabel.Text = tostring(child.Name);
                local v366 = GuiService.SelectedObject == child;
                u13.Gift.Amount.Container.Visible = false;
                SelectAmountButton(u13.Gift.Amount.Container, child);

                if v366 then
                    GuiService.SelectedObject = u13.Gift.Amount;
                end;

                refreshGiftNavigation();
            end);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Statistics.OpenShopTime", function(p367) -- Line: 3233
        -- upvalues: script_StarterPack (ref)
        script_StarterPack.OnOpenShopTimeChanged(p367);
    end);
    DataController.CreateListener(LocalPlayer, "Gamepasses", function() -- Line: 3237
        -- upvalues: script_StarterPack (ref)
        script_StarterPack.Refresh();
    end);
    MenuState.OnScreenChanged:Connect(function(p368, p369) -- Line: 3241
        -- upvalues: script_StarterPack (ref)
        if p369 == "Store" then
            script_StarterPack.HandleStoreOpened();
        end;
    end);

    if MenuState.GetCurrentScreen() == "Store" then
        script_StarterPack.HandleStoreOpened();
    else
        script_StarterPack.Refresh();
    end;

    DataController.CreateListener(LocalPlayer, "Credits", function(p370) -- Line: 3254
        -- upvalues: u2 (ref), RefreshCaseAmountButtons (ref)
        u2:setGoal(p370);
        RefreshCaseAmountButtons();
    end);
    DataController.CreateListener(LocalPlayer, "TradeTokens", function(p371) -- Line: 3260
        -- upvalues: u3 (ref)
        u3:setGoal(p371);
    end);
    DataController.CreateListener(LocalPlayer, "Exclusive Raffle Ticket", function(p372) -- Line: 3265
        -- upvalues: u4 (ref)
        u4:setGoal(p372);
    end);
    task.defer(function() -- Line: 3270
        -- upvalues: u13 (ref), u12 (ref), DataController (ref), LocalPlayer (ref), Constants (ref)
        local Credits = u13.Tabs.Container.Featured.Container:WaitForChild("Credits");
        local u373 = Credits:FindFirstChild("+ 67,500 Credits");

        if not u373 then
            return;
        end;

        local Size = Credits.Size;
        local UDim2_new_ret = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * u12.MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO, Size.Y.Offset * u12.MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO);

        local function SetMintReserveVisible(p374: boolean) -- Line: 3285
            -- upvalues: Credits (copy), Size (copy), UDim2_new_ret (copy), u373 (copy)
            local v375;

            if p374 then
                v375 = Size;
            else
                v375 = UDim2_new_ret;
            end;

            Credits.Size = v375;
            u373.Visible = p374;
        end;

        Credits.Size = UDim2_new_ret;
        u373.Visible = false;
        DataController.CreateListener(LocalPlayer, "Statistics.RobuxSpent", function(p376) -- Line: 3291
            -- upvalues: Constants (ref), Credits (copy), Size (copy), UDim2_new_ret (copy), u373 (copy)
            local v377 = (tonumber(p376) or 0) >= Constants.MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION;
            local v378;

            if v377 then
                v378 = Size;
            else
                v378 = UDim2_new_ret;
            end;

            Credits.Size = v378;
            u373.Visible = v377;
        end);
    end);
    Cases.ObserveAvailableCases(RefreshCaseListings);
    Remotes.UI.UpdateCreatorCode.Listen(function(p379) -- Line: 3301
        -- upvalues: u13 (ref), UpdateCreatorCodeResponse (ref), closeCreatorCode (ref)
        u13.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
        UpdateCreatorCodeResponse(p379.Type, p379.Text);

        if p379.Type == "Success" and u13.CreatorCode.Visible then
            task.delay(1, function() -- Line: 3306
                -- upvalues: u13 (ref), closeCreatorCode (ref)
                if u13.CreatorCode.Visible then
                    closeCreatorCode();
                end;
            end);
        end;
    end);
    Remotes.Store.CaseOpened.Listen(function(p380) -- Line: 3315
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u19 (ref), u17 (ref), u20 (ref), TryProcessResolvedCaseOpenQueue (ref)
        Profiler.mark("UI.Store.CaseOpenedRemote");

        if p380.InventoryItems and #p380.InventoryItems > 0 then
            DataController.ApplyInventoryDelta(LocalPlayer, p380.InventoryItems, p380.DeletedCaseIds);
        end;

        local v381;

        if typeof(p380.RequestId) == "string" then
            v381 = p380.RequestId;
        else
            v381 = nil;
        end;

        local v382;

        if v381 then
            v382 = u19[v381];
        else
            v382 = v381;
        end;

        if v382 then
            if v381 then
                if u17.pendingOpenRequestId == v381 then
                    u17.isPendingOpenRequest = false;
                    u17.pendingOpenRequestId = nil;
                    u17.isQuickUnlock = false;
                end;

                u19[v381] = nil;
            end;
        else
            v382 = nil;
        end;

        if v381 and not v382 then
            return;
        end;

        table.insert(u20, {
            CaseId = p380.CaseId,
            InventoryItems = p380.InventoryItems,
            CaseIdentifier = p380.CaseIdentifier,
            IsQuickUnlock = v382 and v382.IsQuickUnlock or false,
            RequestId = v381
        });
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    Remotes.Store.ConsoleOpened.Listen(function(u383) -- Line: 3337
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u23 (ref), u21 (ref), u19 (ref), u17 (ref), u20 (ref), TryProcessResolvedCaseOpenQueue (ref), u30 (ref), u24 (ref), CaseSceneController (ref)
        Profiler.mark("UI.Store.ConsoleOpenedRemote");
        DataController.ApplyInventoryDelta(LocalPlayer, u383.InventoryItems, u383.DeletedCaseIds);
        local ConsoleOutcomes = u383.ConsoleOutcomes;

        if not ConsoleOutcomes or #ConsoleOutcomes == 0 then
            ConsoleOutcomes = u383.ConsoleOutcome and { u383.ConsoleOutcome } or ConsoleOutcomes;
        end;

        local RequestId = u383.RequestId;
        local v384;

        if RequestId then
            v384 = u23[RequestId] == true;
        else
            v384 = RequestId;
        end;

        if u21 ~= RequestId and not v384 then
            return;
        end;

        if v384 then
            u23[RequestId] = nil;
        else
            local v385;

            if RequestId then
                v385 = u19[RequestId];
            else
                v385 = RequestId;
            end;

            if v385 then
                if RequestId then
                    if u17.pendingOpenRequestId == RequestId then
                        u17.isPendingOpenRequest = false;
                        u17.pendingOpenRequestId = nil;
                        u17.isQuickUnlock = false;
                    end;

                    u19[RequestId] = nil;
                end;
            else
                v385 = nil;
            end;

            if not v385 then
                return;
            end;
        end;

        local u386 = u383.InventoryItems[1];

        if v384 then
            table.insert(u20, {
                IsQuickUnlock = false,
                IsConsole = true,
                CaseId = u383.CaseId,
                InventoryItems = u383.InventoryItems,
                CaseIdentifier = u383.CaseIdentifier,
                RequestId = RequestId,
                ConsoleOutcomes = ConsoleOutcomes
            });
            Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);

            return;
        end;

        if #u383.InventoryItems > 1 then
            u21 = nil;
            u30(u383.CaseId, u383.InventoryItems, ConsoleOutcomes or {}, u383.CaseIdentifier);

            return;
        end;

        u17.currentInventoryItem = u386;
        u17.currentCaseIdentifier = u383.CaseIdentifier;

        if ConsoleOutcomes then
            ConsoleOutcomes = ConsoleOutcomes[1];
        end;

        if ConsoleOutcomes then
            if not CaseSceneController.ResolveConsoleOpening(ConsoleOutcomes, function() -- Line: 3380
                -- upvalues: u24 (ref), u386 (copy), u383 (copy)
                u24(u386, u383.CaseIdentifier);
            end) then
                u24(u386, u383.CaseIdentifier);
            end;

            return;
        end;

        u24(u386, u383.CaseIdentifier);
    end);
    Remotes.Store.CaseOpenDenied.Listen(function(p387) -- Line: 3389
        -- upvalues: u17 (ref), u19 (ref), u23 (ref), u21 (ref), CaseSceneController (ref), u14 (ref), u22 (ref), u13 (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref)
        local RequestId = p387.RequestId;

        if RequestId then
            if u17.pendingOpenRequestId == RequestId then
                u17.isPendingOpenRequest = false;
                u17.pendingOpenRequestId = nil;
                u17.isQuickUnlock = false;
            end;

            u19[RequestId] = nil;
        end;

        if RequestId then
            u23[RequestId] = nil;
        end;

        if u21 ~= RequestId then
            Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);

            return;
        end;

        u21 = nil;
        u17.isOpening = false;
        u17.currentInventoryItem = nil;
        u17.currentCaseIdentifier = nil;
        CaseSceneController.CancelConsoleOpening();
        local Close = u14.Menu.OpenCase.Contents.Close;

        if u22 then
            for _, v in ipairs(u22) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u22 = nil;
        end;

        u14.Menu.OpenCase.Visible = false;
        u13.Visible = true;
        u13.Tabs.Container.Visible = false;
        u13.CaseContent.Visible = true;
        u14.Menu.Top.Visible = false;
        u13.Top.Visible = false;
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    MenuState.OnInspectStateChanged:Connect(function(p388) -- Line: 3404
        -- upvalues: Profiler (ref), TryProcessResolvedCaseOpenQueue (ref), MenuState (ref), u13 (ref), CaseSceneController (ref), u10 (ref), u14 (ref)
        if not p388 then
            Profiler.defer("UI.Store.InspectClosedDeferred", function() -- Line: 3406
                -- upvalues: TryProcessResolvedCaseOpenQueue (ref), MenuState (ref), u13 (ref), CaseSceneController (ref), u10 (ref), u14 (ref)
                if TryProcessResolvedCaseOpenQueue() then
                    return;
                end;

                local CurrentScreen = MenuState.GetCurrentScreen();
                local v389 = u13.CaseContent:GetAttribute("WasVisibleBeforeInspect") == true;
                local v390 = CaseSceneController.IsActive();

                if u10 and (CurrentScreen == "Store" and (v389 and v390)) then
                    u13.Visible = true;
                    u13.Tabs.Container.Visible = false;
                    u13.CaseContent.Visible = true;
                    u14.Menu.Top.Visible = false;
                    u13.Top.Visible = false;
                    MenuState.SetBlurEnabled(false);
                    local MenuFrame = MenuState.GetMenuFrame();

                    if MenuFrame then
                        MenuFrame.BackgroundTransparency = 1;
                    end;
                elseif u13.CaseContent.Visible and CurrentScreen == "Inventory" then
                    u13.Visible = true;
                    u13.Tabs.Container.Visible = false;
                    u13.CaseContent.Visible = true;
                    u14.Menu.Top.Visible = false;
                    u13.Top.Visible = false;
                    local Inventory = u14.Menu:FindFirstChild("Inventory");

                    if Inventory then
                        Inventory.Visible = false;
                    end;

                    MenuState.SetBlurEnabled(false);
                    local MenuFrame = MenuState.GetMenuFrame();

                    if MenuFrame then
                        MenuFrame.BackgroundTransparency = 1;
                    end;

                    if not CaseSceneController.IsActive() and u10 then
                        CaseSceneController.ShowCaseScene(u10.caseType, u10.name);
                    end;
                end;
            end);
        end;
    end);
    ActivateButton(u13.CaseContent.Main.ItemOddsFrame.Close);
    u13.CaseContent.Main.ItemOddsFrame.Close.MouseButton1Click:Connect(function() -- Line: 3446
        -- upvalues: u13 (ref)
        u13.CaseContent.Main.ItemOddsFrame.Visible = false;
    end);
    local Main = u13.CaseContent.Main;
    local Odds = Main.Odds;
    local ItemOddsFrame = Main.ItemOddsFrame;
    local Container = Odds.Frame.Container;
    local u391 = nil;
    ItemOddsFrame.Active = true;
    Odds:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3463, Name: refreshCoveredContent
        -- upvalues: Main (copy), Odds (copy), ItemOddsFrame (copy), Container (copy)
        Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
        Container.Interactable = not ItemOddsFrame.Visible;
    end);
    ItemOddsFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3469
        -- upvalues: GuiService (ref), ItemOddsFrame (copy), Container (copy), u391 (ref), Main (copy), Odds (copy), IsSelectionUsable (ref)
        local SelectedObject = GuiService.SelectedObject;

        if ItemOddsFrame.Visible then
            if SelectedObject and SelectedObject:IsDescendantOf(Container) then
                u391 = SelectedObject;
                GuiService.SelectedObject = ItemOddsFrame.Close;
            end;

            Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
            Container.Interactable = not ItemOddsFrame.Visible;

            return;
        end;

        Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
        Container.Interactable = not ItemOddsFrame.Visible;
        local v392 = u391;
        u391 = nil;

        if (SelectedObject == nil or SelectedObject:IsDescendantOf(ItemOddsFrame)) and IsSelectionUsable(v392) then
            GuiService.SelectedObject = v392;
        end;
    end);
    Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
    Container.Interactable = not ItemOddsFrame.Visible;
    Observers.observePlayer(function(p393) -- Line: 3491
        -- upvalues: LocalPlayer (ref), ReplicatedStorage (ref), u13 (ref), activateGiftTemplate (ref), refreshGiftNavigation (ref)
        if LocalPlayer == p393 then
            return function() -- Line: 3493
            end;
        end;

        local u394 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone();
        u394.Player.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={p393.UserId}&w=420&h=420`;
        u394.Player.Username.Text = `@{p393.Name}`;
        u394.Parent = u13.Gift.Container;
        u394.Name = tostring(p393.UserId);
        activateGiftTemplate(u394, p393.UserId);
        refreshGiftNavigation();

        return function() -- Line: 3502
            -- upvalues: u394 (copy), refreshGiftNavigation (ref)
            u394:Destroy();
            refreshGiftNavigation();
        end;
    end);
end;

return u1;