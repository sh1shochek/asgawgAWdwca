-- Store (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Menu.Store

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
local Glints = require(ReplicatedStorage.Components.Common.InterfaceAnimations.Glints);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration);
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
    TimerLabel = nil,
    RestockAt = nil,
    LastRequestAt = (-1 / 0),
    Fx = nil
};
local u13 = {
    TAB_ORDER = { "Console", "Cases", "Credits", "TradeTokens", "CreatorCode" },
    BLACKMARKET_DEAL_REQUEST_INTERVAL = 10,
    BLACKMARKET_BURST_SPIN_SPEED = 25,
    BLACKMARKET_ICON_FLOAT_PERIOD = 5,
    BLACKMARKET_ICON_FLOAT_HEIGHT = 0.02,
    BLACKMARKET_ICON_TILT = 2,
    BLACKMARKET_GLOW_PULSE_PERIOD = 2.5,
    BLACKMARKET_GLOW_PULSE_TRANSPARENCY = 0.4,
    BLACKMARKET_GLINT_COUNT = 12,
    BLACKMARKET_GLINT_WAIT = NumberRange.new(0.4, 3),
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
local u14 = nil;
local u15 = nil;
local u16 = {
    Source = "FeaturedConsoleTimer",
    Label = nil,
    Tick = 0,
    ReceivedAt = 0
};
local u17 = {};
local u18 = {
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
local u19 = 0;
local u20 = {};
local u21 = {};
local u22 = nil;
local u23 = nil;
local u24 = {};
local u25 = nil;
u13.RARITY_TO_DROP_SOUND = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue"
};
local u26 = {
    inventoryItems = nil,
    bulkIdentifier = nil,
    caseId = nil,
    isBulkOpening = false,
    currentIndex = 0,
    skipped = false,
    total = 0
};
local Color3_fromRGB_ret = Color3.fromRGB(255, 244, 200);
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;

local function LoadProductInfo(u32, p33) -- Line: 256
    -- upvalues: u17 (copy), MarketplaceService (copy)
    if u17[u32] then
        table.insert(u17[u32], p33);

        return;
    end;

    u17[u32] = { p33 };
    task.spawn(function() -- Line: 263
        -- upvalues: MarketplaceService (ref), u32 (copy), u17 (ref)
        local success, result = pcall(function() -- Line: 264
            -- upvalues: MarketplaceService (ref), u32 (ref)
            return MarketplaceService:GetProductInfoAsync(u32, Enum.InfoType.Product);
        end);
        local v34 = u17[u32];
        u17[u32] = nil;

        for _, v in v34 do
            task.defer(v, success and result and result or nil);
        end;
    end);
end;

local function LoadProductPrice(u35, u36) -- Line: 275
    -- upvalues: LoadProductInfo (copy)
    if u35.Price and u36 then
        u36(u35.Price);
    end;

    LoadProductInfo(u35.DevProductId, function(p37) -- Line: 279
        -- upvalues: u35 (copy), u36 (copy)
        if not (p37 and p37.PriceInRobux) then
            return;
        end;

        u35.BasePrice = p37.UserBasePriceInRobux or u35.Price;
        u35.Price = p37.PriceInRobux;

        if u36 then
            u36(u35.Price);
        end;
    end);
end;

local function GetCaseTokenPrice(p38) -- Line: 291
    -- upvalues: u13 (copy)
    local BasePrice = p38.BasePrice;

    return math.floor(((not BasePrice or BasePrice <= 0) and (p38.Price or 0) or BasePrice) * u13.TRADE_TOKEN_CASE_MARKUP);
end;

local function DoCreditPurchase(u39: string, p40: table, u41: number?, u42: number?) -- Line: 298
    -- upvalues: u14 (ref), DataController (copy), LocalPlayer (copy), CommaNumber (copy), u13 (copy), TradeTokens (copy), ActivateButton (copy), MarketplaceService (copy), Remotes (copy), u10 (ref)
    if u14:FindFirstChild("CurrentConfirm") then
        return;
    end;

    local u43 = p40.DevProductId or p40.ID;

    if u43 == nil then
        return;
    end;

    local v44 = u14:FindFirstChild("PurchaseType") or u14:FindFirstChild("Purchase");

    if not v44 then
        return;
    end;

    local v45 = DataController.Get(LocalPlayer, "TradeTokens") or 0;
    local u46 = v44:Clone();
    u46.Name = "CurrentConfirm";
    u46.Main.Header.Title.Text = u39;
    u46.Main.Info.Frame.Credits.TextLabel.Text = CommaNumber(v45);
    u46.Main.Info.Robux.Credits.Amount.Text = CommaNumber(p40.Price or 0);
    local Amount = u46.Main.Info.TradeTokens.Credits.Amount;
    local v47;

    if u41 or u42 then
        local BasePrice = p40.BasePrice;
        v47 = CommaNumber((math.floor(((not BasePrice or BasePrice <= 0) and (p40.Price or 0) or BasePrice) * u13.TRADE_TOKEN_CASE_MARKUP))) or u46.Main.Info.Robux.Credits.Amount.Text;
    else
        v47 = u46.Main.Info.Robux.Credits.Amount.Text;
    end;

    Amount.Text = v47;
    u46.Visible = true;
    u46.Parent = u14;

    if TradeTokens[u39] and TradeTokens[u39].Price then
        u46.Main.Info.TradeTokens.Credits.Amount.Text = CommaNumber(TradeTokens[u39].Price);
    end;

    ActivateButton(u46.Main.Action.Frame.Close);
    u46.Main.Action.Frame.Close.MouseButton1Click:Connect(function() -- Line: 329
        -- upvalues: u46 (copy)
        u46:Destroy();
    end);
    ActivateButton(u46.Main.Info.Robux);
    u46.Main.Info.Robux.MouseButton1Click:Connect(function() -- Line: 334
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u43 (copy), u46 (copy)
        MarketplaceService:PromptProductPurchase(LocalPlayer, u43);
        u46:Destroy();
    end);
    ActivateButton(u46.Main.Info.TradeTokens);
    u46.Main.Info.TradeTokens.MouseButton1Click:Connect(function() -- Line: 340
        -- upvalues: u42 (copy), Remotes (ref), u39 (copy), u41 (copy), u10 (ref), u46 (copy)
        if u42 then
            Remotes.Store.PurchaseConsoleTradeTokens.Send({
                ProductName = u39,
                Quantity = u42
            });
        elseif u41 then
            Remotes.Store.PurchaseTradeTokensCase.Send({
                ProductName = u10.name,
                Quantity = u41
            });
        else
            Remotes.Store.PurchaseTradeTokensProduct.Send({
                ProductName = u39
            });
        end;

        u46:Destroy();
    end);
end;

local function MultiplyUdim2(p48, p49: number) -- Line: 354
    return UDim2.fromScale(p48.X.Scale * p49, p48.Y.Scale * p49);
end;

local function ClearFrame(p50: any, p51: table) -- Line: 360
    for _, child in ipairs(p50:GetChildren()) do
        if not table.find(p51, child.Name) then
            child:Destroy();
        end;
    end;
end;

local function CreateSpecialShimmer(p52: userdata) -- Line: 371
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
    Frame.Parent = p52;

    return Frame, UIGradient;
end;

local function StepSpecialShimmer(p53: userdata, p54: userdata, p55: number) -- Line: 398
    local v56 = p55 % 2.8 / 0.9;
    p53.Visible = v56 <= 1;

    if p53.Visible then
        p54.Offset = Vector2.new(v56 * 2 + -1, 0);
    end;
end;

local function ApplySpecialCardEffect(p57: userdata) -- Line: 414
    -- upvalues: CreateSpecialShimmer (copy), Glints (copy), RunServiceController (copy), u14 (ref), GuiService (copy)
    local Content = p57:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local u58 = Content:FindFirstChildOfClass("UIGradient");
    local u59;

    if u58 then
        u59 = u58.Transparency;
    else
        u59 = NumberSequence.new(0);
    end;

    local Rarity = Content:FindFirstChild("Rarity");
    local u60 = not Rarity and 0 or Rarity.Rotation;

    if Rarity and not Rarity:FindFirstChildOfClass("UIAspectRatioConstraint") then
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
        UIAspectRatioConstraint.AspectRatio = 1;
        UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize;
        UIAspectRatioConstraint.Parent = Rarity;
    end;

    local u61, u62 = CreateSpecialShimmer(Content);
    local Random_new_ret = Random.new();
    local u63 = Glints.Create(Content, 4);
    local v64 = RunServiceController.CreateBindingName("UI.Store.SpecialCardEffect");
    local u70 = RunServiceController.BindToRenderStep(v64, function() -- Line: 438
        -- upvalues: u14 (ref), GuiService (ref), u61 (copy), u63 (copy), u58 (copy), u59 (copy), Rarity (copy), u60 (copy), u62 (copy), Glints (ref), Random_new_ret (copy)
        if not (u14.Visible and (u14.CaseContent.Visible and u14.CaseContent.Main.CaseContent.Visible)) then
            return;
        end;

        if GuiService.ReducedMotionEnabled then
            u61.Visible = false;

            for _, v in u63 do
                v.Frame.Visible = false;
            end;

            return;
        end;

        local os_clock_ret = os.clock();

        if u58 then
            local v65 = (1 - math.cos(os_clock_ret * 2 * 3.141592653589793 / 2.5)) / 2;
            local v66 = {};

            for _, v in u59.Keypoints do
                table.insert(v66, NumberSequenceKeypoint.new(v.Time, v.Value + (1 - v.Value) * 0.15 * v65));
            end;

            u58.Transparency = NumberSequence.new(v66);
        end;

        if Rarity then
            Rarity.Rotation = u60 + os_clock_ret * 30 % 360;
        end;

        local v67 = u61;
        local v68 = u62;
        local v69 = os_clock_ret % 2.8 / 0.9;
        v67.Visible = v69 <= 1;

        if v67.Visible then
            v68.Offset = Vector2.new(v69 * 2 + -1, 0);
        end;

        Glints.Step(u63, Random_new_ret, os_clock_ret);
    end);
    p57.Destroying:Connect(function() -- Line: 470
        -- upvalues: u70 (copy)
        u70:Disconnect();
    end);
end;

local function UpdateCreatorCodeResponse(p71: string, p72: string) -- Line: 477
    -- upvalues: HttpService (copy), u14 (ref)
    local u73 = HttpService:GenerateGUID(false);
    local Response = u14.CreatorCode.Container.Body.Response;
    local v74 = p71 == "Success" and Color3.fromRGB(86, 228, 21);

    if not v74 then
        if p71 == "Error" then
            v74 = Color3.fromRGB(232, 59, 82);
        else
            v74 = false;
        end;
    end;

    Response.TextColor3 = v74;
    u14.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
    u14.CreatorCode:SetAttribute("ResponseId", u73);
    u14.CreatorCode.Container.Body.Response.Text = p72;
    task.delay(5, function() -- Line: 486
        -- upvalues: u14 (ref), u73 (copy)
        if u14.CreatorCode:GetAttribute("ResponseId") == u73 then
            u14.CreatorCode.Container.Body.CreatorName.TextBox.Text = "";
            u14.CreatorCode.Container.Body.Response.Text = "";
        end;
    end);
end;

local function ScrollToBottom(u75: userdata) -- Line: 496
    -- upvalues: Profiler (copy)
    Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 497
        -- upvalues: u75 (copy)
        local math_max_ret = math.max(0, u75.AbsoluteCanvasSize.Y - u75.AbsoluteWindowSize.Y);
        u75.CanvasPosition = Vector2.new(u75.CanvasPosition.X, math_max_ret);
    end);
end;

local function ScrollToFeaturedSection(p76: string) -- Line: 505
    -- upvalues: u14 (ref), TweenService (copy)
    local Container = u14.Tabs.Container.Featured.Container;
    local v77 = Container:FindFirstChild(p76);

    if not v77 then
        return false;
    end;

    local math_max_ret = math.max(0, Container.CanvasPosition.Y + (v77.AbsolutePosition.Y - Container.AbsolutePosition.Y));
    local v78 = TweenService:Create(Container, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, math_max_ret)
    });
    v78:Play();
    v78.Completed:Wait();
    v78:Destroy();

    return true;
end;

local function NotifyCaseOpenSequenceFinished() -- Line: 531
    -- upvalues: u18 (copy), Remotes (copy)
    local currentCaseIdentifier = u18.currentCaseIdentifier;

    if currentCaseIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = currentCaseIdentifier
        });
        u18.currentCaseIdentifier = nil;
    end;
end;

local function ClearPendingOpenRequest() -- Line: 541
    -- upvalues: u18 (copy)
    u18.isPendingOpenRequest = false;
    u18.pendingOpenRequestId = nil;
    u18.isQuickUnlock = false;
end;

local function CreateOpenCaseRequestId() -- Line: 549
    -- upvalues: u19 (ref)
    u19 = u19 + 1;

    return tostring(u19);
end;

local function FailOpenCaseRequest(p79: string?) -- Line: 556
    -- upvalues: u18 (copy), u20 (copy)
    if not p79 then
        return;
    end;

    if u18.pendingOpenRequestId == p79 then
        u18.isPendingOpenRequest = false;
        u18.pendingOpenRequestId = nil;
        u18.isQuickUnlock = false;
    end;

    u20[p79] = nil;
end;

local function CompleteOpenCaseRequest(p80: string?) -- Line: 570
    -- upvalues: u20 (copy), u18 (copy)
    local v81;

    if p80 then
        v81 = u20[p80];
    else
        v81 = p80;
    end;

    if not v81 then
        return nil;
    end;

    if not p80 then
        return v81;
    end;

    if u18.pendingOpenRequestId == p80 then
        u18.isPendingOpenRequest = false;
        u18.pendingOpenRequestId = nil;
        u18.isQuickUnlock = false;
    end;

    u20[p80] = nil;

    return v81;
end;

local function BeginOpenCaseRequest(p82: boolean) -- Line: 582
    -- upvalues: u19 (ref), u20 (copy), u18 (copy)
    u19 = u19 + 1;
    local v83 = tostring(u19);
    u20[v83] = {
        IsQuickUnlock = p82
    };
    u18.isPendingOpenRequest = true;
    u18.pendingOpenRequestId = v83;
    u18.isQuickUnlock = p82;

    return v83;
end;

local function IsResolvedCaseOpenBusy() -- Line: 593
    -- upvalues: u18 (copy), u26 (copy), MenuState (copy)
    return u18.isPendingOpenRequest or u18.isOpening or (u26.isBulkOpening or MenuState.IsInspectActive());
end;

local function StartResolvedCaseOpenJob(p84: table) -- Line: 602
    -- upvalues: u31 (ref), u25 (ref), u30 (ref), u28 (ref)
    if p84.IsConsole then
        if #p84.InventoryItems > 1 then
            u31(p84.CaseId, p84.InventoryItems, p84.ConsoleOutcomes or {}, p84.CaseIdentifier);

            return;
        end;

        u25(p84.InventoryItems[1], p84.CaseIdentifier);

        return;
    end;

    if #p84.InventoryItems > 1 then
        u30(p84.CaseId, p84.InventoryItems, p84.CaseIdentifier);

        return;
    end;

    u28(p84.CaseId, p84.InventoryItems[1], p84.CaseIdentifier, p84.IsQuickUnlock, p84.RequestId);
end;

local function TryProcessResolvedCaseOpenQueue() -- Line: 627
    -- upvalues: Profiler (copy), u18 (copy), u26 (copy), MenuState (copy), u21 (copy), StartResolvedCaseOpenJob (copy)
    Profiler.mark("UI.Store.TryProcessResolvedCaseOpenQueue");

    if u18.isPendingOpenRequest or u18.isOpening or (u26.isBulkOpening or MenuState.IsInspectActive()) then
        return false;
    end;

    local v85 = false;

    while true do
        local v86 = not (u18.isPendingOpenRequest or u18.isOpening or (u26.isBulkOpening or MenuState.IsInspectActive())) and table.remove(u21, 1);

        if not v86 then
            break;
        end;

        StartResolvedCaseOpenJob(v86);
        v85 = true;
    end;

    return v85;
end;

local function ReturnToStoreTabs() -- Line: 650
    -- upvalues: u14 (ref), u15 (ref)
    u14.Tabs.Container.Visible = true;
    u14.CaseContent.Visible = false;
    u15.Menu.Top.Visible = true;
    u14.Top.Visible = true;
    u14.Visible = false;
end;

local function ShowCaseContentView() -- Line: 658
    -- upvalues: u14 (ref), u15 (ref)
    u14.Visible = true;
    u14.Tabs.Container.Visible = false;
    u14.CaseContent.Visible = true;
    u15.Menu.Top.Visible = false;
    u14.Top.Visible = false;
end;

local function InspectInventoryItem(p87) -- Line: 666
    -- upvalues: Router (copy)
    Router.broadcastRouter("WeaponInspect", p87.Name, p87.Skin, p87.Float, p87.StatTrack, p87.NameTag, p87.Charm, p87.Stickers, p87.Type, p87.Pattern, p87._id, p87.Serial, p87.IsTradeable);
end;

local function InspectStoreSkin(p88: string, p89: string, p90: string?) -- Line: 684
    -- upvalues: Router (copy)
    Router.broadcastRouter("WeaponInspect", p88, p89, 0, nil, nil, nil, nil, p90, 1, nil, 1, nil, true, true);
end;

local function SetConsoleOverlay(p91: boolean) -- Line: 688
    -- upvalues: u15 (ref), u23 (ref)
    local OpenCase = u15.Menu.OpenCase;
    local Contents = OpenCase.Contents;
    local Close = Contents.Close;

    if not p91 then
        if u23 then
            for _, v in ipairs(u23) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u23 = nil;
        end;

        return;
    end;

    if u23 then
        return;
    end;

    local v92 = {};

    for _, v in ipairs({ OpenCase, Contents }) do
        for _, child in ipairs(v:GetChildren()) do
            if child:IsA("GuiObject") and (child ~= Contents and (child ~= Close and child.Visible)) then
                table.insert(v92, child);
                child.Visible = false;
            end;
        end;
    end;

    u23 = v92;
    Close.TextLabel.Text = "SKIP";
    Close.Visible = true;
    Contents.Visible = true;
    OpenCase.Visible = true;
end;

local function ResetConsoleOpening() -- Line: 719
    -- upvalues: u18 (copy), CaseSceneController (copy), u15 (ref), u23 (ref), u14 (ref), Profiler (copy), TryProcessResolvedCaseOpenQueue (copy)
    u18.isOpening = false;
    u18.currentInventoryItem = nil;
    u18.currentCaseIdentifier = nil;
    CaseSceneController.CancelConsoleOpening();
    local Close = u15.Menu.OpenCase.Contents.Close;

    if u23 then
        for _, v in ipairs(u23) do
            v.Visible = true;
        end;

        Close.TextLabel.Text = "CLOSE";
        u23 = nil;
    end;

    u15.Menu.OpenCase.Visible = false;
    u14.Visible = true;
    u14.Tabs.Container.Visible = false;
    u14.CaseContent.Visible = true;
    u15.Menu.Top.Visible = false;
    u14.Top.Visible = false;
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

function u1._RunConsoleInspectSweep(p93: function) -- Line: 730
    -- upvalues: u15 (ref), TweenService (copy), RunService (copy)
    local ConsoleInspectSweep = u15:FindFirstChild("ConsoleInspectSweep");

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
    Frame.Parent = u15;
    local v94 = TweenService:Create(Frame, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Position = UDim2.fromScale(0.5, 0.5)
    });
    v94:Play();
    v94.Completed:Wait();
    local success, result = pcall(p93);
    RunService.RenderStepped:Wait();
    local v95 = TweenService:Create(Frame, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Position = UDim2.fromScale(1.8, 0.5)
    });
    v95:Play();
    v95.Completed:Wait();
    Frame:Destroy();

    if not success then
        error(result);
    end;
end;

local function GetInventoryItemDropSound(p96) -- Line: 773
    -- upvalues: u13 (copy)
    return u13.RARITY_TO_DROP_SOUND[(p96.Type == "Melee" or p96.Type == "Glove") and "Special" or (p96.Rarity or "Blue")] or "Drop Blue";
end;

u25 = function(u97: any, p98: string, u99: boolean?) -- Line: 781
    -- upvalues: u22 (ref), u18 (copy), Remotes (copy), CaseSceneController (copy), u15 (ref), u23 (ref), u14 (ref), MenuState (copy), Router (copy), u13 (copy), u1 (copy), Profiler (copy), TryProcessResolvedCaseOpenQueue (copy)
    u22 = nil;
    u18.isOpening = false;
    u18.currentInventoryItem = nil;
    u18.currentCaseIdentifier = p98;
    local currentCaseIdentifier = u18.currentCaseIdentifier;

    if currentCaseIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = currentCaseIdentifier
        });
        u18.currentCaseIdentifier = nil;
    end;

    u1._RunConsoleInspectSweep(function() -- Line: 792, Name: showInspect
        -- upvalues: CaseSceneController (ref), u15 (ref), u23 (ref), u14 (ref), MenuState (ref), u97 (copy), Router (ref), u99 (copy), u13 (ref)
        CaseSceneController.HideCaseScene();
        local Close = u15.Menu.OpenCase.Contents.Close;

        if u23 then
            for _, v in ipairs(u23) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u23 = nil;
        end;

        u15.Menu.OpenCase.Visible = false;
        u14.Tabs.Container.Visible = true;
        u14.CaseContent.Visible = false;
        u15.Menu.Top.Visible = true;
        u14.Top.Visible = true;
        u14.Visible = false;
        MenuState.SetScreen("Inventory");
        local v100 = u97;
        Router.broadcastRouter("WeaponInspect", v100.Name, v100.Skin, v100.Float, v100.StatTrack, v100.NameTag, v100.Charm, v100.Stickers, v100.Type, v100.Pattern, v100._id, v100.Serial, v100.IsTradeable);

        if MenuState.IsInspectActive() and not u99 then
            local v101 = u97;
            Router.broadcastRouter("RunStoreSound", u13.RARITY_TO_DROP_SOUND[(v101.Type == "Melee" or v101.Type == "Glove") and "Special" or (v101.Rarity or "Blue")] or "Drop Blue");
        end;
    end);
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

local function CleanupCaseOpeningTweens() -- Line: 810
    -- upvalues: u18 (copy)
    if u18.currentTween then
        u18.currentTween:Cancel();
        u18.currentTween = nil;
    end;

    if u18.currentZoomTween then
        u18.currentZoomTween:Cancel();
        u18.currentZoomTween = nil;
    end;

    if u18.renderConnection then
        u18.renderConnection:Disconnect();
        u18.renderConnection = nil;
    end;

    if u18.viewportConnection then
        u18.viewportConnection:Disconnect();
        u18.viewportConnection = nil;
    end;
end;

u13.CREDIT_PACKAGE_TIERS = { 400, 950, 3100, 6500, 13250 };

local function GetDeveloperProductNameForAmount(p102: number) -- Line: 833
    -- upvalues: u13 (copy), CommaNumber (copy)
    for _, v in u13.CREDIT_PACKAGE_TIERS do
        if p102 <= v then
            return `+ {CommaNumber(v)} Credits`;
        end;
    end;

    return "+ 27,000 Credits";
end;

function u1.IsStarterPackAvailable() -- Line: 844
    -- upvalues: script_StarterPack (copy)
    return script_StarterPack.IsAvailable();
end;

function u1.IsStarterPackShown() -- Line: 848
    -- upvalues: script_StarterPack (copy)
    return script_StarterPack.IsShown();
end;

function u1.GetStarterPackRemainingSeconds() -- Line: 852
    -- upvalues: script_StarterPack (copy)
    return script_StarterPack.GetState().RemainingSeconds;
end;

function u1.GetStarterPackWindowSeconds() -- Line: 856
    -- upvalues: script_StarterPack (copy)
    return script_StarterPack.WINDOW_SECONDS;
end;

function u1.GetActiveBundleRemainingSeconds(p103: number?) -- Line: 860
    -- upvalues: ReplicatedStorage (copy), u16 (copy)
    local TimerController = require(ReplicatedStorage.Controllers.TimerController);

    if not p103 then
        local ServerTimeNow = workspace:GetServerTimeNow();
        p103 = math.floor(ServerTimeNow);
    end;

    local Tick = u16.Tick;

    if Tick <= 0 then
        Tick = TimerController.GetTimer(u16.Source);

        if Tick <= 0 then
            return 0;
        end;

        u16.Tick = Tick;
        u16.ReceivedAt = p103;
    end;

    if Tick > 1000000000000 then
        local math_floor_ret = math.floor(Tick / 1000 - p103);

        return math.max(0, math_floor_ret);
    end;

    if Tick > 1000000000 then
        local math_floor_ret = math.floor(Tick - p103);

        return math.max(0, math_floor_ret);
    end;

    local ReceivedAt = u16.ReceivedAt;

    if ReceivedAt <= 0 then
        u16.ReceivedAt = p103;
        ReceivedAt = p103;
    end;

    local math_floor_ret = math.floor(Tick - (p103 - ReceivedAt));

    return math.max(0, math_floor_ret);
end;

function u1.GetFeaturedConsoleTimerText(p104: number?) -- Line: 892
    -- upvalues: u1 (copy), FormatDuration (copy)
    local ActiveBundleRemainingSeconds = u1.GetActiveBundleRemainingSeconds(p104);

    return ActiveBundleRemainingSeconds <= 0 and "LIMITED TIME!" or FormatDuration(ActiveBundleRemainingSeconds, "Always");
end;

function u1.RefreshFeaturedConsoleTimer(p105: number?) -- Line: 902
    -- upvalues: u16 (copy), u1 (copy)
    if u16.Label then
        u16.Label.Text = u1.GetFeaturedConsoleTimerText(p105);
    end;
end;

function u1.RefreshBlackmarketDealerTimer() -- Line: 911
    -- upvalues: u12 (copy), u13 (copy), Remotes (copy), FormatDuration (copy)
    local TimerLabel = u12.TimerLabel;

    if not TimerLabel then
        return;
    end;

    local RestockAt = u12.RestockAt;
    local v106;

    if RestockAt then
        v106 = RestockAt - os.clock();
    else
        v106 = nil;
    end;

    if not v106 or v106 <= 0 then
        local os_clock_ret = os.clock();

        if os_clock_ret - u12.LastRequestAt >= u13.BLACKMARKET_DEAL_REQUEST_INTERVAL then
            u12.LastRequestAt = os_clock_ret;
            Remotes.BlackMarketDealer.RequestDeal.Send();
        end;
    end;

    TimerLabel.Text = `RESTOCKS IN {not v106 and "--:--:--" or FormatDuration(v106)}`;
end;

function u1.AnimateBlackmarketDealer() -- Line: 939
    -- upvalues: u12 (copy), GuiService (copy), u13 (copy), Glints (copy)
    local Fx = u12.Fx;

    if not Fx then
        return;
    end;

    if GuiService.ReducedMotionEnabled then
        for _, v in Fx.Glints do
            v.Frame.Visible = false;
        end;

        return;
    end;

    local os_clock_ret = os.clock();

    if Fx.Burst then
        Fx.Burst.Rotation = os_clock_ret * u13.BLACKMARKET_BURST_SPIN_SPEED % 360;
    end;

    if Fx.Icon then
        local math_sin_ret = math.sin(os_clock_ret * 2 * 3.141592653589793 / u13.BLACKMARKET_ICON_FLOAT_PERIOD);
        Fx.Icon.Position = Fx.IconPosition + UDim2.fromScale(0, math_sin_ret * u13.BLACKMARKET_ICON_FLOAT_HEIGHT);
        Fx.Icon.Rotation = math_sin_ret * u13.BLACKMARKET_ICON_TILT;
    end;

    if Fx.Glow then
        local v107 = (1 - math.cos(os_clock_ret * 2 * 3.141592653589793 / u13.BLACKMARKET_GLOW_PULSE_PERIOD)) / 2;
        Fx.Glow.ImageTransparency = Fx.GlowTransparency + (1 - Fx.GlowTransparency) * u13.BLACKMARKET_GLOW_PULSE_TRANSPARENCY * v107;
    end;

    Glints.Step(Fx.Glints, Fx.Random, os_clock_ret, u13.BLACKMARKET_GLINT_WAIT);
end;

local function ActivateCategoryButton(u108) -- Line: 975
    -- upvalues: TweenService (copy), Router (copy)
    local Size = u108.Size;
    local TweenInfo_new_ret = TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut);
    u108.MouseEnter:Connect(function() -- Line: 978
        -- upvalues: TweenService (ref), u108 (copy), TweenInfo_new_ret (copy), Size (copy), Router (ref)
        local v109 = {};
        local v110 = Size;
        v109.Size = UDim2.fromScale(v110.X.Scale * 0.9, v110.Y.Scale * 0.9);
        TweenService:Create(u108, TweenInfo_new_ret, v109):Play();
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
    end);
    u108.MouseLeave:Connect(function() -- Line: 982
        -- upvalues: TweenService (ref), u108 (copy), TweenInfo_new_ret (copy), Size (copy)
        TweenService:Create(u108, TweenInfo_new_ret, {
            Size = Size
        }):Play();
    end);
    u108.MouseButton1Click:Connect(function() -- Line: 985
        -- upvalues: Router (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
    end);
end;

local function IsLimitedSpecialCase(p111) -- Line: 993
    -- upvalues: Cases (copy)
    local v112;

    if p111.caseRarity == "Special" then
        v112 = Cases.IsLimited(p111);
    else
        v112 = false;
    end;

    return v112;
end;

local function CountMatchingCases(p113: string) -- Line: 999
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v114 = 0;

    for _, v in ipairs(DataController.Get(LocalPlayer, "Inventory") or {}) do
        if (v.Type == "Case" or v.Type == "Package") and v.Skin == p113 then
            v114 = v114 + 1;
        end;
    end;

    return v114;
end;

local function CollectCaseIdentifiers(p115: string, p116: number) -- Line: 1011
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local v117 = DataController.Get(LocalPlayer, "Inventory");
    local v118 = {};

    for _, v in ipairs(v117 or {}) do
        if p116 <= #v118 then
            break;
        end;

        if (v.Type == "Case" or v.Type == "Package") and v.Skin == p115 then
            table.insert(v118, v._id);
        end;
    end;

    return v118;
end;

local function FilterAmountButtons(p119: userdata, p120: number) -- Line: 1027
    for _, child in ipairs(p119:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = (tonumber(child.Name) or 0) <= p120;
        end;
    end;
end;

local function SelectAmountButton(p121: userdata, p122: any) -- Line: 1037
    for _, child in ipairs(p121:GetChildren()) do
        if child:IsA("TextButton") then
            local v123 = child == p122 and true or child.Name == p122;
            child.Frame.BackgroundTransparency = v123 and 0 or 1;
            child:SetAttribute("Selected", v123);
        end;
    end;
end;

local function RefreshCaseAmountButtons() -- Line: 1049
    -- upvalues: u10 (ref), u14 (ref), CountMatchingCases (copy), DataController (copy), LocalPlayer (copy), FilterAmountButtons (copy), SelectAmountButton (copy)
    local v124 = u10;

    if not (v124 and u14.CaseContent.Visible) then
        return;
    end;

    local Amount = u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount;
    local Scroll = Amount.Container.Scroll;
    local v125;

    if u14.CaseContent:GetAttribute("State") == "Open" then
        v125 = CountMatchingCases(v124.name);
    else
        local v126 = (tonumber(DataController.Get(LocalPlayer, "Credits")) or 0) / math.max(v124.price, 1);
        local math_floor_ret = math.floor(v126);
        v125 = math.max(1, math_floor_ret);
    end;

    FilterAmountButtons(Scroll, v125);
    local v127 = nil;

    for _, child in Scroll:GetChildren() do
        if child:IsA("TextButton") and child:GetAttribute("Selected") then
            v127 = child;
            break;
        end;
    end;

    if v127 and not v127.Visible then
        SelectAmountButton(Scroll, "1");
        Amount.Header.TextLabel.Text = "1";
    end;
end;

local function ResetBulkOpeningState() -- Line: 1086
    -- upvalues: u26 (copy)
    u26.isBulkOpening = false;
    u26.inventoryItems = nil;
    u26.bulkIdentifier = nil;
    u26.currentIndex = 0;
    u26.skipped = false;
    u26.caseId = nil;
    u26.total = 0;
end;

local function GetUnboxedItemRarity(p128, p129) -- Line: 1098
    if p128.Type == "Melee" or p128.Type == "Glove" then
        return "Special";
    end;

    for _, v in ipairs(p129.contents) do
        if v.skin.skinName == p128.Skin and v.skin.weaponName == p128.Name then
            return v.rarity or "Blue";
        end;
    end;

    return "Blue";
end;

local function purchaseCase(p130: any, p131: number) -- Line: 1113
    -- upvalues: DataController (copy), LocalPlayer (copy), Remotes (copy), u5 (ref), GetDeveloperProductNameForAmount (copy), MarketplaceService (copy), DevProducts (copy), u27 (ref), u1 (copy)
    local v132 = DataController.Get(LocalPlayer, "Credits");
    local v133 = p130.price * p131;

    if v133 <= v132 then
        Remotes.Store.PurchaseCase.Send({
            CaseId = p130.caseId,
            Amount = p131
        });

        return;
    end;

    if u5 then
        MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[GetDeveloperProductNameForAmount(v133 - v132)].DevProductId);
        u27("Store");
        u1.OpenTab("Credits");
    end;
end;

local function createCaseTemplate(u134: any, p135: userdata, p136: number, p137: boolean) -- Line: 1128
    -- upvalues: Profiler (copy), Rarities (copy), ReplicatedStorage (copy), Cases2 (copy), Cases (copy), ActivateButton (copy), Router (copy), u1 (copy), u29 (ref)
    if p135:FindFirstChild(u134.caseId) then
        return;
    end;

    Profiler.mark("UI.Store.CreateCaseTemplate");
    local v138 = Rarities[u134.caseRarity];

    if v138 then
        local v139 = ReplicatedStorage.Assets.UI.Store.CaseTemplate:Clone();
        local v140;

        if Cases2[u134.name] then
            v140 = Cases2[u134.name].Amounts[1] or nil;
        else
            v140 = nil;
        end;

        if v140 and (v140.BasePrice and v140.Price < v140.BasePrice) then
            local math_floor_ret = math.floor((v140.BasePrice - v140.Price) / ((v140.BasePrice + v140.Price) / 2) * 100);
            v139.Discount.Discount.Title.Text = `-{math_floor_ret}%`;
        end;

        v139.Discount.Visible = false;
        local v141;

        if u134.caseRarity == "Special" then
            v141 = Cases.IsLimited(u134);
        else
            v141 = false;
        end;

        if v141 then
            v139.Discount.Discount.Title.Text = "LIMITED";
            v139.Discount.Visible = true;
        elseif p137 then
            v139.Discount.Discount.Title.Text = "NEW";
            v139.Discount.Visible = true;
        end;

        v139.Contents.Glow.ImageColor3 = v138.Color;
        v139.Contents.Pattern.ImageColor3 = v138.Color;
        v139.Contents.Rarity.BackgroundColor3 = v138.Color;
        v139.Contents.Icon.Image = u134.imageAssetId;
        v139.Footer.CaseName.Text = u134.name;
        v139.LayoutOrder = p136;
        v139.Parent = p135;
        v139.Name = u134.caseId;
        ActivateButton(v139.Purchase);
        v139.Purchase.MouseButton1Click:Connect(function() -- Line: 1165
            -- upvalues: Router (ref), u1 (ref), u134 (copy)
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            u1.OpenCaseContent(u134.caseId, "Inspect");
        end);
        ActivateButton(v139.Gift);
        v139.Gift.MouseButton1Click:Connect(function() -- Line: 1170
            -- upvalues: u29 (ref), u134 (copy)
            u29(u134.caseId, "Case");
        end);
    end;
end;

local function activateGiftTemplate(u142, u143) -- Line: 1178
    -- upvalues: Router (copy), TweenService (copy), LocalPlayer (copy), u14 (ref), DataController (copy), Cases (copy), Remotes (copy), MarketplaceService (copy), Gamepasses (copy), DevProducts (copy), DoCreditPurchase (copy)
    local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    u142.Button.MouseEnter:Connect(function() -- Line: 1180
        -- upvalues: Router (ref), TweenService (ref), u142 (copy), TweenInfo_new_ret (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        TweenService:Create(u142.Player.Username, TweenInfo_new_ret, {
            TextColor3 = Color3.fromRGB(255, 200, 0)
        }):Play();
    end);
    u142.Button.MouseLeave:Connect(function() -- Line: 1186
        -- upvalues: TweenService (ref), u142 (copy), TweenInfo_new_ret (copy)
        TweenService:Create(u142.Player.Username, TweenInfo_new_ret, {
            TextColor3 = Color3.fromRGB(190, 190, 190)
        }):Play();
    end);
    u142.Button.MouseButton1Click:Connect(function() -- Line: 1191
        -- upvalues: u143 (copy), LocalPlayer (ref), u14 (ref), Router (ref), DataController (ref), Cases (ref), Remotes (ref), MarketplaceService (ref), Gamepasses (ref), DevProducts (ref), DoCreditPurchase (ref)
        if u143 == LocalPlayer.UserId then
            return;
        end;

        local Attribute = u14:GetAttribute("GiftProductName");
        local Attribute2 = u14:GetAttribute("GiftProductType");
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if Attribute2 ~= "Case" then
            Remotes.Store.CreateGift.Send({
                RecipientUserId = tostring(u143),
                ProductName = Attribute,
                ProductType = Attribute2
            });

            if Attribute2 == "Gamepass" then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, Gamepasses[Attribute].GamepassId);

                return;
            end;

            if Attribute2 == "DevProduct" then
                local v144 = DataController.Get(LocalPlayer, "TradeTokens");

                if string.find(Attribute, "Trade Tokens", 1, true) == nil and (DevProducts[Attribute].Price and DevProducts[Attribute].Price <= v144) then
                    DoCreditPurchase(Attribute, DevProducts[Attribute]);

                    return;
                end;

                MarketplaceService:PromptProductPurchase(LocalPlayer, DevProducts[Attribute].DevProductId);
            end;

            return;
        end;

        local v145 = DataController.Get(LocalPlayer, "Credits");
        local Case = Cases.GetCase(Attribute);
        local v146 = tonumber(u14.Gift.Amount.Header.TextLabel.Text) or 1;

        if v145 < Case.price * v146 then
            return;
        end;

        u14.Gift.Visible = false;
        Remotes.Store.GiftCase.Send({
            RecipientUserId = tostring(u143),
            CaseId = Attribute,
            Amount = v146
        });
    end);
end;

local function CanInspect() -- Line: 1241
    -- upvalues: u20 (copy)
    return next(u20) == nil;
end;

local function WireCaseItemInspect(p147: userdata, u148: string, u149: string, u150: string?) -- Line: 1247
    -- upvalues: u20 (copy), Router (copy)
    local ItemContent = p147:FindFirstChild("ItemContent");

    for _, v in { "Inspect", "MobileInspect" } do
        local v151;

        if ItemContent then
            v151 = ItemContent:FindFirstChild(v);
        else
            v151 = ItemContent;
        end;

        if v151 and v151:IsA("GuiObject") then
            v151.Visible = false;
        end;
    end;

    if p147:IsA("GuiButton") then
        p147.Active = true;
        p147.Selectable = true;
        p147.Activated:Connect(function() -- Line: 1259
            -- upvalues: u20 (ref), Router (ref), u148 (copy), u149 (copy), u150 (copy)
            if next(u20) ~= nil then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
            Router.broadcastRouter("WeaponInspect", u148, u149, 0, nil, nil, nil, nil, u150, 1, nil, 1, nil, true, true);
        end);
    end;
end;

local function GetItemArtBounds(p152: userdata) -- Line: 1271
    local Icon = p152:FindFirstChild("Icon");

    if not (Icon and Icon:IsA("GuiObject")) then
        return nil, nil;
    end;

    local v153 = Icon:FindFirstChild("Icon") or Icon:FindFirstChild("Placeholder");

    if v153 then
        if v153:IsA("GuiObject") then
            Icon = v153;
        end;
    end;

    local AbsoluteSize = Icon.AbsoluteSize;
    local math_min_ret = math.min(AbsoluteSize.X, AbsoluteSize.Y);

    if math_min_ret <= 0 then
        return nil, nil;
    end;

    return Icon.AbsolutePosition + AbsoluteSize / 2, Vector2.new(math_min_ret, math_min_ret) / 2;
end;

local function ResolvePressedItem(p154: any, p155: table, p156) -- Line: 1291
    -- upvalues: GetItemArtBounds (copy)
    local v157 = (1 / 0);

    for i, v in p155 do
        local v158, v159 = GetItemArtBounds(i);
        local v160 = i:IsA("GuiObject") and i.Visible;

        if v160 and (v158 and v159) then
            local v161 = (p156 - v158) / v159;
            local math_abs_ret = math.abs(v161.X);
            local math_abs_ret2 = math.abs(v161.Y);
            local math_max_ret = math.max(math_abs_ret, math_abs_ret2);

            if math_max_ret < v157 then
                p154 = v;
                v157 = math_max_ret;
            end;
        end;
    end;

    return p154;
end;

local function SetupTaggedInspectButtons(p162: string) -- Line: 1307
    -- upvalues: CollectionService (copy), u14 (ref), u20 (copy), ResolvePressedItem (copy), Router (copy)
    local v163 = {};

    for _, v in ipairs(CollectionService:GetTagged(p162)) do
        if v:IsDescendantOf(u14) then
            local Attribute = v:GetAttribute("WeaponName");
            local Attribute2 = v:GetAttribute("SkinName");

            if typeof(Attribute) == "string" and typeof(Attribute2) == "string" then
                local Inspect = v:FindFirstChild("Inspect");

                if Inspect and Inspect:IsA("GuiObject") then
                    Inspect.Visible = false;
                end;

                local HoverFrame = v:FindFirstChild("HoverFrame");

                if HoverFrame and HoverFrame:IsA("GuiButton") then
                    local u164 = {
                        WeaponName = Attribute,
                        SkinName = Attribute2
                    };
                    local Parent = v.Parent;
                    local u165 = v163[Parent];

                    if not u165 then
                        u165 = {};
                        v163[Parent] = u165;
                    end;

                    u165[v] = u164;
                    HoverFrame.Activated:Connect(function(p166: userdata?) -- Line: 1347
                        -- upvalues: u20 (ref), u164 (copy), ResolvePressedItem (ref), u165 (ref), Router (ref)
                        if next(u20) ~= nil then
                            return;
                        end;

                        local v167 = u164;
                        local v168;

                        if p166 == nil then
                            v168 = false;
                        else
                            v168 = p166.UserInputType == Enum.UserInputType.MouseButton1 and true or p166.UserInputType == Enum.UserInputType.Touch;
                        end;

                        if p166 and v168 then
                            v167 = ResolvePressedItem(u164, u165, Vector2.new(p166.Position.X, p166.Position.Y));
                        end;

                        Router.broadcastRouter("RunInterfaceSound", "UI Click");
                        Router.broadcastRouter("WeaponInspect", v167.WeaponName, v167.SkinName, 0, nil, nil, nil, nil, nil, 1, nil, 1, nil, true, true);
                    end);
                else
                    warn((`[Store] {v:GetFullName()} is missing its HoverFrame button.`));
                end;
            else
                warn((`[Store] {v:GetFullName()} is missing WeaponName/SkinName attributes.`));
            end;
        end;
    end;
end;

local function setupCurrencyFrame(u169: userdata, u170: boolean) -- Line: 1370
    -- upvalues: DevProducts (copy), CommaNumber (copy), LoadProductInfo (copy), ActivateButton (copy), u5 (ref), DataController (copy), LocalPlayer (copy), DoCreditPurchase (copy), MarketplaceService (copy), Router (copy), u29 (ref)
    local u171 = DevProducts[u169.Name];
    local Purchase_Button = u169:FindFirstChild("Purchase_Button", true);

    if Purchase_Button and Purchase_Button:IsA("GuiButton") then
        local function u173(p172) -- Line: 1375
            -- upvalues: u170 (copy), Purchase_Button (copy), CommaNumber (ref)
            if u170 then
                local Title = Purchase_Button:FindFirstChild("Title", true);

                if Title and Title:IsA("TextLabel") then
                    Title.Text = `{utf8.char(57346)}{CommaNumber(p172)}`;
                end;
            else
                Purchase_Button.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(p172)}`;
            end;
        end;

        if u171.Price and u173 then
            u173(u171.Price);
        end;

        LoadProductInfo(u171.DevProductId, function(p174) -- Line: 279
            -- upvalues: u171 (copy), u173 (copy)
            if not (p174 and p174.PriceInRobux) then
                return;
            end;

            u171.BasePrice = p174.UserBasePriceInRobux or u171.Price;
            u171.Price = p174.PriceInRobux;

            if u173 then
                u173(u171.Price);
            end;
        end);
        ActivateButton(Purchase_Button);
        Purchase_Button.MouseButton1Click:Connect(function() -- Line: 1387
            -- upvalues: u5 (ref), DataController (ref), LocalPlayer (ref), u170 (copy), u171 (copy), DoCreditPurchase (ref), u169 (copy), MarketplaceService (ref), Router (ref)
            if u5 then
                local v175 = DataController.Get(LocalPlayer, "TradeTokens");

                if u170 or (not u171.Price or u171.Price > v175) then
                    MarketplaceService:PromptProductPurchase(LocalPlayer, u171.DevProductId);
                else
                    DoCreditPurchase(u169.Name, u171);
                end;

                Router.broadcastRouter("RunInterfaceSound", "UI Click");
            end;
        end);
    end;

    local Gift_Button = u169:FindFirstChild("Gift_Button", true);

    if Gift_Button and Gift_Button:IsA("GuiButton") then
        ActivateButton(Gift_Button);
        Gift_Button.MouseButton1Click:Connect(function() -- Line: 1403
            -- upvalues: u29 (ref), u169 (copy), Router (ref)
            u29("Gift " .. u169.Name, "DevProduct");
            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end);
    end;
end;

local function sortCasesByNewest(p176, p177) -- Line: 1416
    -- upvalues: Cases (copy)
    local v178;

    if p176.caseRarity == "Special" then
        v178 = Cases.IsLimited(p176);
    else
        v178 = false;
    end;

    local v179;

    if p177.caseRarity == "Special" then
        v179 = Cases.IsLimited(p177);
    else
        v179 = false;
    end;

    if v178 ~= v179 then
        return v178;
    end;

    local CreationTimestamp = Cases.GetCreationTimestamp(p176);
    local CreationTimestamp2 = Cases.GetCreationTimestamp(p177);

    if CreationTimestamp and CreationTimestamp2 then
        if CreationTimestamp ~= CreationTimestamp2 then
            return CreationTimestamp2 < CreationTimestamp;
        end;
    elseif CreationTimestamp or CreationTimestamp2 then
        return CreationTimestamp ~= nil;
    end;

    if p176.displayOrder == p177.displayOrder then
        return Cases.GetBackendOrder(p176) < Cases.GetBackendOrder(p177);
    end;

    return p176.displayOrder < p177.displayOrder;
end;

local u180 = nil;

local function fitCaseGrid(p181: userdata) -- Line: 1458
    -- upvalues: u180 (ref)
    local v182 = p181:FindFirstChildOfClass("UIGridLayout");
    local Parent = p181.Parent;
    local Parent2 = Parent.Parent;
    local Frame = Parent2:FindFirstChild("Frame");
    local v183 = Parent2:FindFirstChildOfClass("UIListLayout");
    local v184 = Parent:FindFirstChildOfClass("UIPadding");
    local AbsoluteSize = p181.AbsoluteSize;

    if not (v182 and (v183 and (v184 and AbsoluteSize.X > 0))) then
        return;
    end;

    local u185 = v182.CellSize.X.Scale * AbsoluteSize.X + v182.CellSize.X.Offset;

    if u185 <= 0 then
        return;
    end;

    local v186 = u180;

    if not v186 then
        if AbsoluteSize.Y <= 0 then
            return;
        end;

        local function pixels(p187, p188: number) -- Line: 1481
            -- upvalues: u185 (copy)
            return (p187.Scale * p188 + p187.Offset) / u185;
        end;

        v186 = {};
        local Y = v182.CellSize.Y;
        v186.cellAspect = (Y.Scale * AbsoluteSize.Y + Y.Offset) / u185;
        local Y2 = v182.CellPadding.Y;
        v186.rowPadding = (Y2.Scale * AbsoluteSize.Y + Y2.Offset) / u185;
        v186.header = not Frame and 0 or Frame.AbsoluteSize.Y / u185;
        local Padding = v183.Padding;
        v186.sectionPadding = (Padding.Scale * Parent2.AbsoluteSize.Y + Padding.Offset) / u185;
        local PaddingTop = v184.PaddingTop;
        v186.holderPaddingTop = (PaddingTop.Scale * Parent.AbsoluteSize.Y + PaddingTop.Offset) / u185;
        local PaddingBottom = v184.PaddingBottom;
        v186.holderPaddingBottom = (PaddingBottom.Scale * Parent.AbsoluteSize.Y + PaddingBottom.Offset) / u185;
        u180 = v186;
    end;

    local v189 = 0;

    for _, child in ipairs(p181:GetChildren()) do
        if child:IsA("GuiObject") then
            v189 = v189 + 1;
        end;
    end;

    local v190 = v182.CellPadding.X.Scale * AbsoluteSize.X + v182.CellPadding.X.Offset;
    local math_floor_ret = math.floor((AbsoluteSize.X + v190) / (u185 + v190) + 0.001);
    local math_max_ret = math.max(1, math_floor_ret);
    local math_ceil_ret = math.ceil(v189 / math_max_ret);
    local math_max_ret2 = math.max(1, math_ceil_ret);
    local math_round_ret = math.round(u185 * v186.cellAspect);
    local math_round_ret2 = math.round(u185 * v186.rowPadding);
    local v191 = math_max_ret2 * math_round_ret + (math_max_ret2 - 1) * math_round_ret2;
    local math_round_ret3 = math.round(u185 * v186.holderPaddingTop);
    local math_round_ret4 = math.round(u185 * v186.holderPaddingBottom);
    v182.CellSize = UDim2.new(v182.CellSize.X, UDim.new(0, math_round_ret));
    v182.CellPadding = UDim2.new(v182.CellPadding.X, UDim.new(0, math_round_ret2));
    p181.Size = UDim2.new(p181.Size.X, UDim.new(0, v191));
    v184.PaddingTop = UDim.new(0, math_round_ret3);
    v184.PaddingBottom = UDim.new(0, math_round_ret4);
    Parent.AutomaticSize = Enum.AutomaticSize.None;
    Parent.Size = UDim2.new(Parent.Size.X, UDim.new(0, v191 + math_round_ret3 + math_round_ret4));
    local math_round_ret5 = math.round(u185 * v186.sectionPadding);
    local v192 = not Frame and 0 or math.round(u185 * v186.header);
    v183.Padding = UDim.new(0, math_round_ret5);

    if Frame then
        Frame.Size = UDim2.new(Frame.Size.X, UDim.new(0, v192));
    end;

    Parent2.AutomaticSize = Enum.AutomaticSize.None;
    Parent2.Size = UDim2.new(Parent2.Size.X, UDim.new(0, v191 + math_round_ret3 + math_round_ret4 + (not Frame and 0 or v192 + math_round_ret5)));
end;

local function updateCases() -- Line: 1539
    -- upvalues: Profiler (copy), u14 (ref), ClearFrame (copy), Cases (copy), sortCasesByNewest (copy), createCaseTemplate (copy)
    Profiler.mark("UI.Store.UpdateCases");
    local Cases3 = u14.Tabs.Container.Featured.Container.Cases.Container.Cases;
    ClearFrame(Cases3, { "UIListLayout", "UIGridLayout" });
    local v193 = {};

    for _, v in ipairs(Cases.GetCases()) do
        if v.caseType ~= "Package" and v.caseType ~= "Console" then
            table.insert(v193, v);
        end;
    end;

    table.sort(v193, sortCasesByNewest);
    local v194 = (-1 / 0);
    local v195 = nil;

    for _, v in ipairs(v193) do
        local CreationTimestamp = Cases.GetCreationTimestamp(v);

        if CreationTimestamp and v194 < CreationTimestamp then
            local v196;

            if v.caseRarity == "Special" then
                v196 = Cases.IsLimited(v);
            else
                v196 = false;
            end;

            if not v196 then
                v195 = v;
                v194 = CreationTimestamp;
            end;
        end;
    end;

    for i, v in ipairs(v193) do
        local v197;

        if v195 then
            v197 = v == v195;
        else
            v197 = v.isFeatured;
        end;

        createCaseTemplate(v, Cases3, i, v197);
    end;
end;

local function GetRarityChance(p198: string, p199: userdata) -- Line: 1572
    for _, v in p199 do
        if v.rarity == p198 then
            return v.chance;
        end;
    end;

    return 0;
end;

local function FormatOdds(p200: number) -- Line: 1583
    local v201 = math.round(p200 * 10000) / 10000;

    if v201 == math.floor(v201) then
        return string.format("%.1f", v201);
    end;

    local v202 = v201 * 100 - math.round(v201 * 100);

    if math.abs(v202) < 1e-6 then
        return string.format("%.2f", v201);
    end;

    return string.gsub(string.format("%.4f", v201), "0+$", "");
end;

local function GetBaseSkinName(p203: string) -- Line: 1595
    if p203:find("_PATTERN_") then
        return p203:split("_PATTERN_")[1];
    end;

    return p203;
end;

local function buildItemOdds(p204: any, p205: table, p206: table) -- Line: 1603
    -- upvalues: u14 (ref)
    local ItemOddsFrame = u14.CaseContent.Main.ItemOddsFrame;
    local Container = ItemOddsFrame.Container;

    if ItemOddsFrame:FindFirstChild("List") then
        ItemOddsFrame.List.Visible = false;
    end;

    Container.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    Container.CanvasSize = UDim2.fromScale(0, 0);
    Container.ScrollingDirection = Enum.ScrollingDirection.Y;
    local v207 = {
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
    local v208 = {};

    for _, v in pairs(v207) do
        if v and v:IsA("Frame") then
            v208[v] = true;
            v.Visible = false;
        end;
    end;

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Frame") and not v208[child] then
            child:Destroy();
        end;
    end;

    local u209 = 0;

    local function nextLayoutOrder() -- Line: 1643
        -- upvalues: u209 (ref)
        u209 = u209 + 10;

        return u209;
    end;

    local function setOddsRow(p210: userdata, p211: string, p212: number, p213) -- Line: 1648
        p210.Visible = true;
        local Left = p210:FindFirstChild("Left");

        if Left then
            local v214 = Left:FindFirstChild("Label") or Left:FindFirstChild("Title");

            if v214 and v214:IsA("TextLabel") then
                v214.Text = p211;
                v214.TextColor3 = p213;
            end;

            local Percent = Left:FindFirstChild("Percent");

            if Percent and Percent:IsA("TextLabel") then
                Percent.Text = string.format("%.2f%%", p212);
            end;
        end;

        local Bar = p210:FindFirstChild("Bar");

        if Bar then
            Bar = Bar:FindFirstChild("Current");
        end;

        if Bar and Bar:IsA("Frame") then
            Bar.Size = UDim2.new(math.clamp(p212 / 100, 0, 1), 0, 1, 0);
            Bar.BackgroundColor3 = p213;
        end;
    end;

    local function cloneTemplate(p215: userdata, p216: string) -- Line: 1673
        -- upvalues: u209 (ref), Container (copy)
        local v217 = p215:Clone();
        v217.Name = p216;
        u209 = u209 + 10;
        v217.LayoutOrder = u209;
        v217.Visible = true;
        v217.Parent = Container;

        return v217;
    end;

    local function setHeaderText(p218: userdata, p219: string) -- Line: 1682
        local v220 = p218:FindFirstChildWhichIsA("TextLabel", true);

        if v220 then
            v220.Text = p219;
        end;
    end;

    if p204.type ~= "Glove" then
        local v221 = v207.KillTrakHeader:Clone();
        v221.Name = "KillTrakHeader";
        u209 = u209 + 10;
        v221.LayoutOrder = u209;
        v221.Visible = true;
        v221.Parent = Container;
        local v222 = v221:FindFirstChildWhichIsA("TextLabel", true);

        if v222 then
            v222.Text = "General:";
        end;

        local v223 = v207.KillTrakTemplate:Clone();
        v223.Name = "KillTrak";
        u209 = u209 + 10;
        v223.LayoutOrder = u209;
        v223.Visible = true;
        v223.Parent = Container;
        setOddsRow(v223, "KillTrak™", p204.statTrakChance, Color3.fromRGB(255, 132, 32));
    end;

    local v224 = v207.ConditionsHeader:Clone();
    v224.Name = "ConditionsHeader";
    u209 = u209 + 10;
    v224.LayoutOrder = u209;
    v224.Visible = true;
    v224.Parent = Container;
    local v225 = v224:FindFirstChildWhichIsA("TextLabel", true);

    if v225 then
        v225.Text = "Conditions:";
    end;

    local v226 = {
        ["Factory New"] = { v207.FactoryNew, "Mint Condition", Color3.fromRGB(0, 255, 127) },
        ["Minimal Wear"] = { v207.MinimalWear, "Near-Mint", Color3.fromRGB(0, 170, 255) },
        ["Field-Tested"] = { v207.FieldTested, "Standard-Grade", Color3.fromRGB(255, 255, 0) },
        ["Well-Worn"] = { v207.WellWorn, "Combat-Worn", Color3.fromRGB(255, 85, 0) },
        ["Battle-Scarred"] = { v207.BattleScarred, "War-Torn", Color3.fromRGB(255, 0, 0) }
    };

    for _, v in ipairs(p204.floatChances) do
        local v227 = v226[v.wear];

        if v227 and (v227[1] and v.chance > 0) then
            local wear = v.wear;
            local v228 = v227[1]:Clone();
            v228.Name = wear;
            u209 = u209 + 10;
            v228.LayoutOrder = u209;
            v228.Visible = true;
            v228.Parent = Container;
            setOddsRow(v228, v227[2], v.chance, v227[3]);
        end;
    end;

    local v229 = {};
    local v230 = 0;

    for _, v in p205 do
        if v.skin.skinName:find("_PATTERN_") and p206.representativeSkinName:find("_PATTERN_") then
            v229[v.skin.skinName] = true;
            v230 = v230 + 1;
        end;
    end;

    if v230 > 0 then
        local v231 = v207.PatternsHeader:Clone();
        v231.Name = "PatternsHeader";
        u209 = u209 + 10;
        v231.LayoutOrder = u209;
        v231.Visible = true;
        v231.Parent = Container;
        local v232 = v231:FindFirstChildWhichIsA("TextLabel", true);

        if v232 then
            v232.Text = "Patterns:";
        end;

        local v233 = 1 / v230 * 100;
        local v234 = u209;

        for i in v229 do
            local _, v235 = table.unpack(i:split("_PATTERN_"));
            local v236 = v207.PatternTemplate:Clone();
            v236.Name = "PatternTemplate";
            u209 = u209 + 10;
            v236.LayoutOrder = u209;
            v236.Visible = true;
            v236.Parent = Container;
            v236.LayoutOrder = v234 + (tonumber(v235) or 0);
            setOddsRow(v236, `Pattern #{v235}`, v233, Color3.fromRGB(255, 255, 255));
        end;
    end;

    local Title = ItemOddsFrame.Header.Title;
    local weaponName = p206.weaponName;
    local representativeSkinName = p206.representativeSkinName;

    if representativeSkinName:find("_PATTERN_") then
        representativeSkinName = representativeSkinName:split("_PATTERN_")[1];
    end;

    Title.Text = `ITEM ODDS - "{weaponName} | {representativeSkinName}"`;
    ItemOddsFrame.Visible = true;
end;

local function RenderGroupedOdds(p237: table?, p238: function, p239: userdata, p240: string) -- Line: 1740
    -- upvalues: Rarities (copy), GetSkinDisplayName (copy), Skins (copy), script_CaseScroll (copy), ReplicatedStorage (copy), FormatOdds (copy), ActivateButton (copy), buildItemOdds (copy), WireCaseItemInspect (copy)
    if p237 == nil then
        return;
    end;

    if typeof(p237) ~= "table" then
        warn((`[Store.RenderGroupedOdds] Expected {p240} to be a table; no odds rows were rendered`));

        return;
    end;

    local v241 = {};
    local v242 = 0;
    local u243 = {};
    local v244 = {};

    for _, v in ipairs(p237) do
        local v245;

        if typeof(v) == "table" and typeof(v.skin) == "table" then
            v245 = v.skin;
        else
            v245 = nil;
        end;

        if v245 and (typeof(v245.weaponName) == "string" and (v245.weaponName ~= "" and (typeof(v245.skinName) == "string" and (v245.skinName ~= "" and Rarities[v.rarity])))) then
            table.insert(u243, v);
            local skinName = v245.skinName;

            if skinName:find("_PATTERN_") then
                skinName = skinName:split("_PATTERN_")[1];
            end;

            local v246 = `{v245.weaponName}|{skinName}`;

            if not v244[v246] then
                local v247 = {
                    weaponName = v245.weaponName,
                    baseSkinName = skinName,
                    representativeSkinName = v245.skinName,
                    rarity = v.rarity,
                    itemType = v245.type == "Charm" and "Charm" or nil
                };
                v244[v246] = v247;
                table.insert(v241, v247);
            end;
        else
            v242 = v242 + 1;
        end;
    end;

    if v242 > 0 then
        warn((`[Store.RenderGroupedOdds] Skipped {v242} malformed {p240}; each entry must contain skin.weaponName, skin.skinName, and a known rarity`));
    end;

    for _, v in ipairs(v241) do
        local v248 = p238(v, v241);
        local v249 = GetSkinDisplayName(v.baseSkinName, false);
        local v250 = Rarities[v.rarity];
        local SkinInformation = Skins.GetSkinInformation(v.weaponName, v.representativeSkinName);
        local StoreItemIcon = script_CaseScroll.GetStoreItemIcon(SkinInformation);
        local v251 = ReplicatedStorage.Assets.UI.Store.OddTemplate:Clone();
        v251.ItemTemplate.ItemContent.Content.Icon.Image = StoreItemIcon;
        v251.ItemTemplate.ItemContent.Content.Rarity.ImageColor3 = v250.Color;
        v251.ItemTemplate.ItemContent.Rarity.BackgroundColor3 = v250.Color;
        v251.ItemTemplate.ItemContent.SkinName.Text = v249;
        v251.ItemTemplate.ItemContent.WeaponName.Text = v.weaponName;
        v251.Label.Text = `{FormatOdds(v248)}%`;
        v251.Label.UIGradient.Color = v250.ColorSequence;
        v251.LayoutOrder = 100 - v248;
        v251.Parent = p239;
        local ItemOdds = v251:FindFirstChild("ItemOdds");

        if ItemOdds and SkinInformation then
            ActivateButton(ItemOdds);
            ItemOdds.MouseButton1Click:Connect(function() -- Line: 1817
                -- upvalues: buildItemOdds (ref), SkinInformation (copy), u243 (copy), v (copy)
                buildItemOdds(SkinInformation, u243, v);
            end);
        elseif ItemOdds and ItemOdds:IsA("GuiObject") then
            ItemOdds.Visible = false;
        end;

        WireCaseItemInspect(v251.ItemTemplate, v.weaponName, v.representativeSkinName, v.itemType);
    end;
end;

local function UpdateCasePurchaseButtons(p252) -- Line: 1828
    -- upvalues: u14 (ref), Cases2 (copy), Cases (copy), u5 (ref), RunService (copy), CommaNumber (copy)
    local SubButtons = u14.CaseContent.Main.Bottom.SubButtons;
    local v253 = Cases2[p252.name];
    local v254 = Cases.IsCaseForSale(p252.caseId);
    local v255 = false;

    for _, child in ipairs(SubButtons.CenterButtons:GetChildren()) do
        if child:IsA("GuiButton") then
            child.Visible = false;
        end;
    end;

    if v253 and (u5 and (v254 or RunService:IsStudio())) then
        for i, v in v253.Amounts do
            local v256 = SubButtons.CenterButtons:FindFirstChild((tostring(i)));

            if v256 and v256:IsA("GuiButton") then
                v256.Visible = v.Offsale == false;
                v255 = v255 or v256.Visible;
                v256.Container.Title.Text = `{CommaNumber(v.Price)}`;
            end;
        end;
    end;

    SubButtons.Visible = v255;
end;

local function RefreshCaseListings() -- Line: 1854
    -- upvalues: updateCases (copy), u10 (ref), u14 (ref), UpdateCasePurchaseButtons (copy)
    updateCases();

    if u10 and u14.CaseContent.Visible then
        UpdateCasePurchaseButtons(u10);
    end;
end;

local function StartBackgroundProductLoading() -- Line: 1861
    -- upvalues: DevProducts (copy), LoadProductInfo (copy), updateCases (copy), u10 (ref), u14 (ref), UpdateCasePurchaseButtons (copy), Cases2 (copy)
    for _, v in DevProducts do
        local _ = v.Price;
        local u257 = nil;
        LoadProductInfo(v.DevProductId, function(p258) -- Line: 279
            -- upvalues: v (copy), u257 (copy)
            if not (p258 and p258.PriceInRobux) then
                return;
            end;

            v.BasePrice = p258.UserBasePriceInRobux or v.Price;
            v.Price = p258.PriceInRobux;

            if u257 then
                u257(v.Price);
            end;
        end);
    end;

    local u259 = 0;

    local function CompleteRequest() -- Line: 1867
        -- upvalues: u259 (ref), updateCases (ref), u10 (ref), u14 (ref), UpdateCasePurchaseButtons (ref)
        u259 = u259 - 1;

        if u259 == 0 then
            updateCases();

            if u10 and u14.CaseContent.Visible then
                UpdateCasePurchaseButtons(u10);
            end;
        end;
    end;

    for _, v in Cases2 do
        for _, v2 in v.Amounts do
            u259 = u259 + 1;
            LoadProductInfo(v2.ID, function(p260) -- Line: 1877
                -- upvalues: v2 (copy), u259 (ref), updateCases (ref), u10 (ref), u14 (ref), UpdateCasePurchaseButtons (ref)
                if p260 then
                    v2.Offsale = not (p260.IsForSale and p260.PriceInRobux);

                    if p260.IsForSale and p260.PriceInRobux then
                        v2.BasePrice = p260.UserBasePriceInRobux or v2.BasePrice;
                        v2.Price = p260.PriceInRobux;
                    end;
                end;

                u259 = u259 - 1;

                if u259 == 0 then
                    updateCases();

                    if u10 and u14.CaseContent.Visible then
                        UpdateCasePurchaseButtons(u10);
                    end;
                end;
            end);
        end;
    end;
end;

function u1.OpenCaseContent(p261: string, p262: string, p263: string?) -- Line: 1891
    -- upvalues: Profiler (copy), Cases (copy), u9 (ref), u10 (ref), UpdateCasePurchaseButtons (copy), u14 (ref), MenuState (copy), CommaNumber (copy), u15 (ref), SelectAmountButton (copy), RefreshCaseAmountButtons (copy), RenderGroupedOdds (copy), u13 (copy), CaseSceneController (copy), ClearFrame (copy), Skins (copy), Rarities (copy), script_CaseScroll (copy), GetSkinDisplayName (copy), ReplicatedStorage (copy), FormatOdds (copy), WireCaseItemInspect (copy), ApplySpecialCardEffect (copy)
    Profiler.mark("UI.Store.OpenCaseContent");
    local Case = Cases.GetCase(p261);
    u9 = p263;
    u10 = Case;

    if Case then
        UpdateCasePurchaseButtons(Case);
        local v264 = u14.Visible or MenuState.GetCurrentScreen() == "Store";

        if v264 then
            MenuState.SetScreen("Store");
        end;

        u14.CaseContent:SetAttribute("WasVisibleBeforeInspect", v264);
        u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Position = p262 == "Open" and UDim2.new(0.687, 0, 0.465, 0) or UDim2.new(0.575, 0, 0.465, 0);
        u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = `BUY <font color="#ffda0f">({CommaNumber(Case.price)})</font>`;
        u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Visible = Case.caseType ~= "Console" or p262 == "Open";
        u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = "1";
        u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Visible = p262 == "Inspect";
        u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.Visible = p262 == "Open";
        u14.CaseContent:SetAttribute("State", p262);
        u14.Tabs.Container.Visible = false;
        u14.CaseContent.Visible = true;
        u15.Menu.Top.Visible = false;
        u14.Top.Visible = false;
        u14.Visible = true;
        SelectAmountButton(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll, "1");
        RefreshCaseAmountButtons();

        for _, child in ipairs(u14.CaseContent.Main.Odds.Frame.Container:GetChildren()) do
            if child.Name ~= "INVIS" and child:IsA("Frame") then
                if child.Name == "Special" then
                    child.Visible = false;
                else
                    child:Destroy();
                end;
            end;
        end;

        local v265 = {};
        local v266 = {};

        for _, v in Case.contents do
            v265[v.rarity] = (v265[v.rarity] or 0) + 1;
        end;

        local u267 = {};
        local v268 = false;

        for i in pairs(v265) do
            local v269 = i;
            local v270 = 0;

            for _, v in Case.rarityChances do
                if v.rarity == v269 then
                    v270 = v.chance;
                    break;
                end;
            end;

            local v271 = v270 or 0;
            u267[v269] = v271;

            if v271 > 0 then
                v268 = true;
            end;
        end;

        if not v268 then
            local v272 = 0;
            local v273 = {};

            for _, v in ipairs(Case.contents) do
                local v274 = v.weight or 0;
                v272 = v272 + v274;
                v273[v.rarity] = (v273[v.rarity] or 0) + v274;
            end;

            local v275 = #Case.contents;

            for i, v in pairs(v265) do
                if v272 > 0 then
                    u267[i] = (v273[i] or 0) / v272 * 100;
                else
                    u267[i] = v / math.max(v275, 1) * 100;
                end;
            end;
        end;

        local function GetDisplayRarityChance(p276) -- Line: 1968
            -- upvalues: u267 (copy)
            return u267[p276] or 0;
        end;

        local Container = u14.CaseContent.Main.Odds.Frame.Container;
        u14.CaseContent.Main.Odds.Visible = false;

        local function getContentGroupOdds(p277, p278) -- Line: 1976
            -- upvalues: u267 (copy)
            local v279 = 0;

            for _, v in ipairs(p278) do
                if v.rarity == p277.rarity then
                    v279 = v279 + 1;
                end;
            end;

            return (u267[p277.rarity] or 0) / math.max(v279, 1);
        end;

        local function getSpecialGroupOdds(p280, p281) -- Line: 1986
            -- upvalues: Case (copy)
            return Case.specialChance / math.max(#p281, 1);
        end;

        for _, v in ipairs(Case.contents) do
            v266[`{v.skin.weaponName}_{v.skin.skinName}`] = (u267[v.rarity] or 0) / v265[v.rarity];
        end;

        RenderGroupedOdds(Case.contents, getContentGroupOdds, Container, (`contents for case "{p261}"`));
        RenderGroupedOdds(Case.specialContents, getSpecialGroupOdds, Container, (`special contents for case "{p261}"`));
        local v282 = {};

        for _, v in ipairs(Case.contents) do
            if v.rarity then
                v282[v.rarity] = true;
            end;
        end;

        local function SetChanceRowText(p283, p284) -- Line: 2013
            local Right = p283:FindFirstChild("Right");

            if Right then
                Right = Right:FindFirstChild("Label");
            end;

            if Right then
                Right.Text = p284;
            end;
        end;

        for i in pairs(u13.RARITY_PRIORITY) do
            if i ~= "Special" then
                local v285 = u14.CaseContent.Main.CaseChances:FindFirstChild(i);

                if v285 then
                    v285.Visible = v282[i] == true;
                    local v286 = `{math.round((u267[i] or 0) * 100) / 100}%`;
                    local Right = v285:FindFirstChild("Right");

                    if Right then
                        Right = Right:FindFirstChild("Label");
                    end;

                    if Right then
                        Right.Text = v286;
                    end;
                end;
            end;
        end;

        local v287;

        if Case.specialContents == nil then
            v287 = false;
        else
            v287 = #Case.specialContents > 0;
        end;

        local Special = u14.CaseContent.Main.CaseChances:FindFirstChild("Special");

        if Special then
            Special.Visible = v287;
            local v288 = `{Case.specialChance or 0}%`;
            local Right = Special:FindFirstChild("Right");

            if Right then
                Right = Right:FindFirstChild("Label");
            end;

            if Right then
                Right.Text = v288;
            end;
        end;

        if u15 and u15.Menu then
            u15.Menu.Visible = true;
        end;

        CaseSceneController.ShowCaseScene(Case.caseType, Case.name);
        Profiler.defer("UI.Store.CaseContentVisibilityDeferred", function() -- Line: 2046
            -- upvalues: u14 (ref)
            u14.Visible = true;
            u14.CaseContent.Visible = true;
        end);
        ClearFrame(u14.CaseContent.Main.CaseContent.Container, { "UIGridLayout", "UIPadding" });

        if not u14.CaseContent.Main.CaseContent.Visible then
            u14.CaseContent.Main.CaseContent.Visible = true;
        end;

        local table_clone_ret = table.clone(Case.contents);
        table.sort(table_clone_ret, function(p289, p290) -- Line: 2058
            -- upvalues: u13 (ref)
            return (u13.RARITY_PRIORITY[p289.rarity] or 0) < (u13.RARITY_PRIORITY[p290.rarity] or 0);
        end);

        for _, v in ipairs(table_clone_ret) do
            local SkinInformation = Skins.GetSkinInformation(v.skin.weaponName, v.skin.skinName);
            local v291 = Rarities[v.rarity];
            local StoreItemIcon = script_CaseScroll.GetStoreItemIcon(SkinInformation);
            local v292 = GetSkinDisplayName(v.skin.skinName, true);
            local v293 = ReplicatedStorage.Assets.UI.Store.ItemTemplate:Clone();
            v293.ItemContent.Content.Odds.Text = `{FormatOdds(v266[`{v.skin.weaponName}_{v.skin.skinName}`] or 0)}%`;
            v293.Bottom.Footer.WeaponName.Text = GetSkinDisplayName.GetWeaponDisplayName(v.skin.weaponName);
            v293.ItemContent.Rarity.BackgroundColor3 = v291.Color;
            v293.ItemContent.Content.Rarity.ImageColor3 = v291.Color;
            v293.Bottom.Footer.SkinName.Text = v292;
            v293.Parent = u14.CaseContent.Main.CaseContent.Container;
            v293.ItemContent.Content.Icon.Image = StoreItemIcon;
            local Charm = v293.ItemContent:FindFirstChild("Charm");

            if Charm and Charm:IsA("ImageLabel") then
                Charm.Visible = false;
            end;

            WireCaseItemInspect(v293, v.skin.weaponName, v.skin.skinName, v.skin.type == "Charm" and "Charm" or nil);
        end;

        local specialContents = Case.specialContents;
        local v294 = Case.caseType == "Case";

        if v294 or specialContents and #specialContents > 0 then
            local v295 = ReplicatedStorage.Assets.UI.Store.GoldTemplate:Clone();
            v295.Selectable = true;
            v295.Content.Content.Odds.Text = v294 and "0.26%" or `{FormatOdds(Case.specialChance or 0)}%`;
            v295.Content.Icon.Image = u13.SPECIAL_CASE_ICONS[Case.caseId] or u13.DEFAULT_CASE_ICON;
            v295.Parent = u14.CaseContent.Main.CaseContent.Container;
            ApplySpecialCardEffect(v295);
        end;
    end;
end;

local function GetGiftRecipientButtons() -- Line: 2108
    -- upvalues: u14 (ref)
    local v296 = {};

    for _, child in ipairs(u14.Gift.Container:GetChildren()) do
        local v297 = child:IsA("GuiObject") and child.Visible and child:FindFirstChild("Button");

        if v297 and v297:IsA("GuiButton") then
            table.insert(v296, v297);
        end;
    end;

    return v296;
end;

local function IsSelectionUsable(p298: userdata?) -- Line: 2121
    if not (p298 and (p298.Parent and p298.Selectable)) then
        return false;
    end;

    while p298 and not p298:IsA("ScreenGui") do
        if p298:IsA("GuiObject") and not p298.Visible then
            return false;
        end;

        p298 = p298.Parent;
    end;

    return p298 ~= nil;
end;

local function refreshGiftNavigation() -- Line: 2138
    -- upvalues: u14 (ref), GetGiftRecipientButtons (copy), u6 (ref), GuiService (copy), IsSelectionUsable (copy)
    local Gift = u14.Gift;
    local v299 = { Gift.Search.TextBox };

    for _, v in ipairs((GetGiftRecipientButtons())) do
        table.insert(v299, v);
    end;

    if Gift.Amount.Visible then
        table.insert(v299, Gift.Amount);

        if Gift.Amount.Container.Visible then
            for _, child in ipairs(Gift.Amount.Container:GetChildren()) do
                if child:IsA("TextButton") then
                    table.insert(v299, child);
                end;
            end;
        end;
    end;

    table.insert(v299, Gift.Close);

    for i, v in ipairs(v299) do
        v.NextSelectionUp = v299[i - 1] or v299[#v299];
        v.NextSelectionDown = v299[i + 1] or v299[1];
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

u29 = function(p300: string, p301: string) -- Line: 2179
    -- upvalues: u14 (ref), SelectAmountButton (copy), u6 (ref), GuiService (copy), refreshGiftNavigation (copy)
    u14:SetAttribute("GiftProductName", p300);
    u14:SetAttribute("GiftProductType", p301);
    local Amount = u14.Gift.Amount;
    Amount.Header.TextLabel.Text = "1";
    Amount.Visible = p301 == "Case";
    Amount.Container.Visible = false;
    SelectAmountButton(Amount.Container, "1");
    u14.Gift.Visible = true;
    u6 = GuiService.SelectedObject;
    refreshGiftNavigation();
end;

local function PopulateGiftSearchResult(p302: string) -- Line: 2195
    -- upvalues: u14 (ref), Players (copy), ReplicatedStorage (copy), activateGiftTemplate (copy)
    local SearchResult = u14.Gift.Container:FindFirstChild("SearchResult");

    if SearchResult then
        SearchResult:Destroy();
    end;

    local u303 = tonumber(p302);

    if p302 == "" or not u303 then
        return;
    end;

    for _, child in ipairs(u14.Gift.Container:GetChildren()) do
        if child:IsA("Frame") then
            child.Visible = false;
        end;
    end;

    local success, result = pcall(function() -- Line: 2213
        -- upvalues: Players (ref), u303 (copy)
        return Players:GetNameFromUserIdAsync(u303);
    end);

    if success then
        local v304 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone();
        v304.Player.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={u303}&w=420&h=420`;
        v304.Player.Username.Text = `@{result}`;
        v304.Parent = u14.Gift.Container;
        v304.Name = "SearchResult";
        activateGiftTemplate(v304, u303);
    end;
end;

function u1.OpenTab(p305: string) -- Line: 2229
    -- upvalues: Profiler (copy), u5 (ref), Router (copy), u11 (ref), ScrollToFeaturedSection (copy)
    Profiler.mark("UI.Store.OpenTab");

    if not (p305 ~= "Credits" and p305 ~= "TradeTokens" or u5) then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are not allowed in your region.");

        return;
    end;

    u11 = p305;
    ScrollToFeaturedSection(p305);
end;

function u1.CanBuyPaidCurrency() -- Line: 2245
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.OpenBundleSection() -- Line: 2251
    -- upvalues: Profiler (copy), ScrollToFeaturedSection (copy)
    Profiler.mark("UI.Store.OpenBundleSection");
    ScrollToFeaturedSection("StarterPack");
end;

u1.PromptStarterPackPurchase = script_StarterPack.PromptPurchase;

function u1.PromptTradeTokenPackageForItemPrice(p306: number) -- Line: 2258
    -- upvalues: u13 (copy), DataController (copy), LocalPlayer (copy), DevProducts (copy), MarketplaceService (copy)
    if u13.TRADE_TOKEN_PACKAGES[#u13.TRADE_TOKEN_PACKAGES].Amount < p306 then
        return;
    end;

    local v307 = p306 - (DataController.Get(LocalPlayer, "TradeTokens") or 0);

    if v307 <= 0 then
        return;
    end;

    for _, v in u13.TRADE_TOKEN_PACKAGES do
        if v307 <= v.Amount then
            local v308 = DevProducts[v.ProductName];

            if v308 then
                MarketplaceService:PromptProductPurchase(LocalPlayer, v308.DevProductId);
            end;

            return;
        end;
    end;
end;

function u1.OpenFeaturedBundleSection() -- Line: 2282
    -- upvalues: Profiler (copy), ScrollToFeaturedSection (copy)
    Profiler.mark("UI.Store.OpenFeaturedBundleSection");
    ScrollToFeaturedSection("Console");
end;

u28 = function(p309: string, u310: any, p311: string?, p312: boolean?, p313: string?) -- Line: 2289
    -- upvalues: Profiler (copy), u18 (copy), CleanupCaseOpeningTweens (copy), Cases (copy), Remotes (copy), CaseSceneController (copy), u14 (ref), u15 (ref), MenuState (copy), u13 (copy), GetUnboxedItemRarity (copy), Router (copy), TryProcessResolvedCaseOpenQueue (copy), script_CaseScroll (copy)
    Profiler.mark("UI.Store.OpenCase");

    if p312 == nil then
        p312 = u18.isQuickUnlock;
    end;

    u18.currentCaseIdentifier = p311;
    CleanupCaseOpeningTweens();
    local Case = Cases.GetCase(p309);

    if not Case then
        return;
    end;

    if not p312 then
        u18.isOpening = true;
        u18.currentInventoryItem = u310;
        u14.CaseContent.Visible = false;
        local v314 = Case.caseType == "Package";

        local function startRollAnimation() -- Line: 2324
            -- upvalues: u18 (ref), u15 (ref), Case (copy), u14 (ref), script_CaseScroll (ref), u310 (copy), Router (ref), Remotes (ref), CaseSceneController (ref), MenuState (ref), u13 (ref)
            if not u18.isOpening then
                return;
            end;

            u15.Menu.OpenCase.CaseName.Text = `Unlock {Case.name}`;
            u15.Menu.OpenCase.Visible = true;
            u14.Visible = false;
            u15.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";
            local v315 = script_CaseScroll.RunScrollAnimation(Case, u310);

            if not u18.isOpening then
                return;
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Notification");
            task.wait(0.5);

            if not u18.isOpening then
                return;
            end;

            u18.isOpening = false;
            u18.currentInventoryItem = nil;
            local currentCaseIdentifier = u18.currentCaseIdentifier;

            if currentCaseIdentifier then
                Remotes.Store.CaseOpenSequenceFinished.Send({
                    CaseIdentifier = currentCaseIdentifier
                });
                u18.currentCaseIdentifier = nil;
            end;

            u15.Menu.OpenCase.Visible = false;
            CaseSceneController.HideCaseScene();
            u14.Tabs.Container.Visible = true;
            u14.CaseContent.Visible = false;
            u15.Menu.Top.Visible = true;
            u14.Top.Visible = true;
            u14.Visible = false;
            MenuState.SetScreen("Inventory");
            Router.broadcastRouter("RunStoreSound", u13.RARITY_TO_DROP_SOUND[v315 and v315.rarity or "Blue"] or "Drop Blue");
            Router.broadcastRouter("RunStoreSound", "Case Close");
            local v316 = u310;
            Router.broadcastRouter("WeaponInspect", v316.Name, v316.Skin, v316.Float, v316.StatTrack, v316.NameTag, v316.Charm, v316.Stickers, v316.Type, v316.Pattern, v316._id, v316.Serial, v316.IsTradeable);
        end;

        if Case.caseType == "Charm Capsule" then
            CaseSceneController.TransitionToUnboxing(startRollAnimation);

            return;
        end;

        if v314 then
            CaseSceneController.TransitionToUnboxing();
            CaseSceneController.WaitForOpeningAnimation();

            if u18.isOpening then
                u18.isOpening = false;
                u18.currentInventoryItem = nil;
                local currentCaseIdentifier = u18.currentCaseIdentifier;

                if currentCaseIdentifier then
                    Remotes.Store.CaseOpenSequenceFinished.Send({
                        CaseIdentifier = currentCaseIdentifier
                    });
                    u18.currentCaseIdentifier = nil;
                end;

                CaseSceneController.HideCaseScene();
                u14.Tabs.Container.Visible = true;
                u14.CaseContent.Visible = false;
                u15.Menu.Top.Visible = true;
                u14.Top.Visible = true;
                u14.Visible = false;
                MenuState.SetScreen("Inventory");
                local v317 = u13.RARITY_TO_DROP_SOUND[GetUnboxedItemRarity(u310, Case)] or "Drop Blue";
                Router.broadcastRouter("RunStoreSound", v317);
                Router.broadcastRouter("RunStoreSound", "Case Close");
                Router.broadcastRouter("WeaponInspect", u310.Name, u310.Skin, u310.Float, u310.StatTrack, u310.NameTag, u310.Charm, u310.Stickers, u310.Type, u310.Pattern, u310._id, u310.Serial, u310.IsTradeable);

                return;
            end;
        else
            CaseSceneController.TransitionToUnboxing();
            task.wait(0.8);
            startRollAnimation();
        end;

        return;
    end;

    if p311 then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = p311
        });
    end;

    CaseSceneController.HideCaseScene();
    u14.Tabs.Container.Visible = true;
    u14.CaseContent.Visible = false;
    u15.Menu.Top.Visible = true;
    u14.Top.Visible = true;
    u14.Visible = false;
    MenuState.SetScreen("Inventory");
    local v318 = u13.RARITY_TO_DROP_SOUND[GetUnboxedItemRarity(u310, Case)] or "Drop Blue";
    Router.broadcastRouter("RunStoreSound", v318);
    Router.broadcastRouter("RunStoreSound", "Case Close");
    Router.broadcastRouter("QuickOpenResolved", p313);
    Router.broadcastRouter("ShowNewItemNotification", u310);
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

local function stopCaseOpening() -- Line: 2379
    -- upvalues: u18 (copy), Router (copy), CleanupCaseOpeningTweens (copy), u26 (copy), script_CaseScroll (copy), CaseSceneController (copy)
    if u18.isOpening then
        Router.broadcastRouter("RunStoreSound", "Case Close");
    end;

    CleanupCaseOpeningTweens();
    u26.isBulkOpening = false;
    u26.inventoryItems = nil;
    u26.bulkIdentifier = nil;
    u26.currentIndex = 0;
    u26.skipped = false;
    u26.caseId = nil;
    u26.total = 0;
    script_CaseScroll.ResetProgressBar();
    local currentInventoryItem = u18.currentInventoryItem;
    u18.isOpening = false;
    u18.currentInventoryItem = nil;
    CaseSceneController.HideCaseScene();

    return currentInventoryItem;
end;

local function finishBulkOpening() -- Line: 2395
    -- upvalues: u26 (copy), CleanupCaseOpeningTweens (copy), script_CaseScroll (copy), u18 (copy), CaseSceneController (copy), u15 (ref), u23 (ref), u14 (ref), Router (copy), Remotes (copy), MenuState (copy), Profiler (copy), TryProcessResolvedCaseOpenQueue (copy)
    local v319 = u26.inventoryItems or {};
    local bulkIdentifier = u26.bulkIdentifier;
    CleanupCaseOpeningTweens();
    script_CaseScroll.ResetProgressBar();
    u18.isOpening = false;
    u18.currentInventoryItem = nil;
    CaseSceneController.HideCaseScene();
    local Close = u15.Menu.OpenCase.Contents.Close;

    if u23 then
        for _, v in ipairs(u23) do
            v.Visible = true;
        end;

        Close.TextLabel.Text = "CLOSE";
        u23 = nil;
    end;

    u15.Menu.OpenCase.Visible = false;
    u14.Tabs.Container.Visible = true;
    u14.CaseContent.Visible = false;
    u15.Menu.Top.Visible = true;
    u14.Top.Visible = true;
    u14.Visible = false;
    u15.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";
    Router.broadcastRouter("RunStoreSound", "Case Close");

    if bulkIdentifier then
        Remotes.Store.CaseOpenSequenceFinished.Send({
            CaseIdentifier = bulkIdentifier
        });
    end;

    MenuState.SetScreen("Inventory");

    if v319[1] then
        Router.broadcastRouter("ShowNewItemNotification", v319[1]);
    end;

    u26.isBulkOpening = false;
    u26.inventoryItems = nil;
    u26.bulkIdentifier = nil;
    u26.currentIndex = 0;
    u26.skipped = false;
    u26.caseId = nil;
    u26.total = 0;
    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
end;

local function skipBulkOpening() -- Line: 2422
    -- upvalues: u26 (copy), CleanupCaseOpeningTweens (copy), finishBulkOpening (copy)
    u26.skipped = true;
    CleanupCaseOpeningTweens();
    finishBulkOpening();
end;

local function BeginBulkOpeningState(p320: string, p321: table, p322: string?) -- Line: 2430
    -- upvalues: u26 (copy)
    u26.isBulkOpening = true;
    u26.inventoryItems = p321;
    u26.bulkIdentifier = p322;
    u26.caseId = p320;
    u26.total = #p321;
    u26.currentIndex = 0;
    u26.skipped = false;
end;

local function IsBulkOpeningInterrupted() -- Line: 2444
    -- upvalues: u18 (copy), u26 (copy)
    return not u18.isOpening or u26.skipped;
end;

local function HoldBulkReveal(p323: number) -- Line: 2449
    -- upvalues: u18 (copy), u26 (copy)
    local v324 = tick();

    while tick() - v324 < p323 and (u18.isOpening and not u26.skipped) do
        task.wait(0.1);
    end;
end;

u30 = function(p325: string, p326: table, p327: string?) -- Line: 2459
    -- upvalues: Profiler (copy), Cases (copy), u26 (copy), CleanupCaseOpeningTweens (copy), u18 (copy), u14 (ref), CaseSceneController (copy), u15 (ref), script_CaseScroll (copy), Router (copy), u13 (copy), HoldBulkReveal (copy), finishBulkOpening (copy)
    Profiler.mark("UI.Store.StartBulkOpening");
    local Case = Cases.GetCase(p325);

    if not Case then
        return;
    end;

    u26.isBulkOpening = true;
    u26.inventoryItems = p326;
    u26.bulkIdentifier = p327;
    u26.caseId = p325;
    u26.total = #p326;
    u26.currentIndex = 0;
    u26.skipped = false;
    CleanupCaseOpeningTweens();
    u18.isOpening = true;
    u18.currentInventoryItem = nil;
    u14.CaseContent.Visible = false;
    local v328 = Case.caseType == "Charm Capsule";

    local function waitForDrag(p329: function) -- Line: 2472
        -- upvalues: u18 (ref), u26 (ref)
        local u330 = false;
        p329(function() -- Line: 2474
            -- upvalues: u330 (ref)
            u330 = true;
        end);

        while not (u330 or (not u18.isOpening or u26.skipped)) do
            task.wait();
        end;
    end;

    if v328 then
        waitForDrag(function(p331) -- Line: 2482
            -- upvalues: CaseSceneController (ref)
            CaseSceneController.TransitionToUnboxing(p331);
        end);
    else
        CaseSceneController.TransitionToUnboxing();
        task.wait(0.8);
    end;

    if not u18.isOpening or u26.skipped then
        return;
    end;

    u15.Menu.OpenCase.CaseName.Text = `Unlock {Case.name}`;
    u15.Menu.OpenCase.Visible = true;
    u14.Visible = false;

    for i = 1, #p326 do
        if not u18.isOpening or u26.skipped then
            break;
        end;

        u26.currentIndex = i;
        local v332 = p326[i];
        u15.Menu.OpenCase.Contents.Close.TextLabel.Text = "CLOSE";

        if v328 and i > 1 then
            waitForDrag(function(p333) -- Line: 2505
                -- upvalues: CaseSceneController (ref)
                if not CaseSceneController.ArmDragOpening(p333) then
                    p333();
                end;
            end);

            if not u18.isOpening or u26.skipped then
                break;
            end;
        end;

        local v334 = script_CaseScroll.RunScrollAnimation(Case, v332);

        if not u18.isOpening or u26.skipped then
            break;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Notification");
        Router.broadcastRouter("RunStoreSound", u13.RARITY_TO_DROP_SOUND[v334 and v334.rarity or "Blue"] or "Drop Blue");
        local v335;

        if i == #p326 then
            task.wait(0.5);
            v335 = i;
        else
            HoldBulkReveal(1.5);
            v335 = i;
        end;
    end;

    if u18.isOpening and not u26.skipped then
        finishBulkOpening();
    end;
end;

u31 = function(p336: string, p337: table, p338: table, p339: string?) -- Line: 2534
    -- upvalues: Profiler (copy), u22 (ref), CaseSceneController (copy), u15 (ref), u23 (ref), u30 (ref), u26 (copy), CleanupCaseOpeningTweens (copy), u18 (copy), u14 (ref), SetConsoleOverlay (copy), Cases (copy), Router (copy), u13 (copy), HoldBulkReveal (copy), finishBulkOpening (copy)
    Profiler.mark("UI.Store.StartBulkConsoleOpening");

    if #p338 ~= #p337 then
        u22 = nil;
        CaseSceneController.CancelConsoleOpening();
        local Close = u15.Menu.OpenCase.Contents.Close;

        if u23 then
            for _, v in ipairs(u23) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u23 = nil;
        end;

        u30(p336, p337, p339);

        return;
    end;

    u26.isBulkOpening = true;
    u26.inventoryItems = p337;
    u26.bulkIdentifier = p339;
    u26.caseId = p336;
    u26.total = #p337;
    u26.currentIndex = 0;
    u26.skipped = false;
    u22 = nil;
    CleanupCaseOpeningTweens();
    u18.isOpening = true;
    u18.currentInventoryItem = nil;
    u14.CaseContent.Visible = false;
    u14.Visible = false;
    SetConsoleOverlay(true);

    for i, v in ipairs(p337) do
        if not u18.isOpening or u26.skipped then
            break;
        end;

        u26.currentIndex = i;

        if i > 1 or not CaseSceneController.IsConsoleOpening() then
            CaseSceneController.BeginConsoleOpening();
        end;

        local u340 = false;
        local u341 = false;

        if not CaseSceneController.ResolveConsoleOpening(p338[i], function(p342) -- Line: 2570
            -- upvalues: u340 (ref), u341 (ref)
            u340 = true;
            u341 = p342;
        end, Cases.GetCase(p336), v) then
            break;
        end;

        local v343 = v;

        while u18.isOpening and not (u26.skipped or u340) do
            task.wait();
        end;

        if not u18.isOpening or u26.skipped then
            break;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Notification");

        if not u341 then
            Router.broadcastRouter("RunStoreSound", u13.RARITY_TO_DROP_SOUND[(v343.Type == "Melee" or v343.Type == "Glove") and "Special" or (v343.Rarity or "Blue")] or "Drop Blue");
        end;

        HoldBulkReveal(i == #p337 and 0.5 or 1.5);
    end;

    if u18.isOpening and not u26.skipped then
        finishBulkOpening();
    end;
end;

function u1.BeginOpenCaseRequest(p344: boolean) -- Line: 2598
    -- upvalues: u19 (ref), u20 (copy), u18 (copy)
    u19 = u19 + 1;
    local v345 = tostring(u19);
    u20[v345] = {
        IsQuickUnlock = p344
    };
    u18.isPendingOpenRequest = true;
    u18.pendingOpenRequestId = v345;
    u18.isQuickUnlock = p344;

    return v345;
end;

function u1.ClearPendingOpenCaseRequest(p346: string) -- Line: 2604
    -- upvalues: u18 (copy)
    if u18.pendingOpenRequestId ~= p346 then
        return false;
    end;

    u18.isPendingOpenRequest = false;
    u18.pendingOpenRequestId = nil;
    u18.isQuickUnlock = false;

    return true;
end;

local function openCreatorCode() -- Line: 2615
    -- upvalues: u14 (ref), DataController (copy), LocalPlayer (copy), TweenService (copy)
    u14.CreatorCode:SetAttribute("ResponseId", nil);
    u14.CreatorCode.Container.Body.Response.Text = "";
    u14.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
    u14.CreatorCode.Container.Body.CreatorName.TextBox.Text = DataController.Get(LocalPlayer, "CreatorCode") or "";
    u14.CreatorCode.Position = UDim2.fromScale(0.5, -1);
    u14.CreatorCode.Visible = true;
    u14.Tabs.Visible = false;
    TweenService:Create(u14.CreatorCode, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.5)
    }):Play();
end;

local function closeCreatorCode() -- Line: 2632
    -- upvalues: TweenService (copy), u14 (ref)
    TweenService:Create(u14.CreatorCode, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, -1)
    }):Play();
    task.wait(0.35);

    if u14.CreatorCode.Visible then
        u14.CreatorCode.Visible = false;
        u14.Tabs.Visible = true;
    end;
end;

u27 = function(p347: string) -- Line: 2645
    -- upvalues: CaseSceneController (copy), u10 (ref), u9 (ref), u14 (ref), MenuState (copy), u15 (ref)
    CaseSceneController.HideCaseScene();
    u10 = nil;
    u9 = nil;
    u14.CaseContent:SetAttribute("WasVisibleBeforeInspect", false);

    if p347 == "Inventory" then
        MenuState.SetScreen("Inventory");
    end;

    u14.Tabs.Container.Visible = true;
    u14.CaseContent.Visible = false;
    u15.Menu.Top.Visible = true;
    u14.Top.Visible = true;

    if p347 ~= "Inventory" then
        u14.Visible = true;

        return;
    end;

    u15.Menu.Inventory.Visible = true;
    u14.Visible = false;
end;

function u1.Initialize(p348, p349) -- Line: 2668
    -- upvalues: Profiler (copy), u15 (ref), u14 (ref), script_CaseScroll (copy), u18 (copy), u13 (copy), script_StarterPack (copy), u16 (copy), fitCaseGrid (copy), Constants (copy), ActivateButton (copy), Router (copy), openCreatorCode (copy), u12 (copy), ReplicatedStorage (copy), MenuState (copy), Remotes (copy), Glints (copy), CloseButtonRegistry (copy), u22 (ref), CaseSceneController (copy), u26 (copy), CleanupCaseOpeningTweens (copy), finishBulkOpening (copy), TryProcessResolvedCaseOpenQueue (copy), u10 (ref), Cases (copy), u9 (ref), CollectCaseIdentifiers (copy), u19 (ref), u20 (copy), SetConsoleOverlay (copy), u24 (copy), u23 (ref), purchaseCase (copy), u27 (ref), closeCreatorCode (copy), UpdateCreatorCodeResponse (copy), ClearFrame (copy), u6 (ref), GuiService (copy), IsSelectionUsable (copy), u1 (copy), RunService (copy), Cases2 (copy), DataController (copy), LocalPlayer (copy), DoCreditPurchase (copy), MarketplaceService (copy), setupCurrencyFrame (copy), LoadProductPrice (copy), u5 (ref), DevProducts (copy), CommaNumber (copy), LoadProductInfo (copy), script_Hover (copy), SetupTaggedInspectButtons (copy), updateCases (copy), StartBackgroundProductLoading (copy), RunServiceController (copy), CollectionService (copy), refreshGiftNavigation (copy), PopulateGiftSearchResult (copy), u8 (ref), u7 (ref), u2 (copy), u3 (copy), u4 (copy)
    Profiler.mark("UI.Store.Initialize");
    u15 = p348;
    u14 = p349;
    script_CaseScroll.Bind(u15, u18, u13);
    script_StarterPack.Bind(u14, u15);
    u16.Label = u14.Tabs.Container.Featured.Container.Console.Pack.Container.Top.Title.Top.Timer;
    local Cases3 = u14.Tabs.Container.Featured.Container.Cases.Container.Cases;
    local u350 = false;

    local function queueCaseGridFit() -- Line: 2680
        -- upvalues: u350 (ref), fitCaseGrid (ref), Cases3 (copy)
        if u350 then
            return;
        end;

        u350 = true;
        task.defer(function() -- Line: 2685
            -- upvalues: u350 (ref), fitCaseGrid (ref), Cases3 (ref)
            u350 = false;
            fitCaseGrid(Cases3);
        end);
    end;

    Cases3.ChildAdded:Connect(queueCaseGridFit);
    Cases3.ChildRemoved:Connect(queueCaseGridFit);
    Cases3:GetPropertyChangedSignal("AbsoluteSize"):Connect(queueCaseGridFit);

    if not u350 then
        u350 = true;
        task.defer(function() -- Line: 2685
            -- upvalues: u350 (ref), fitCaseGrid (ref), Cases3 (copy)
            u350 = false;
            fitCaseGrid(Cases3);
        end);
    end;

    if u14.Top.Categories.Visible then
        u14.Top.Categories.Visible = false;
    end;

    local Container = u14.Tabs.Container.Featured.Container;
    Container.ForeverPack.Visible = Constants.STORE_FOREVER_PACK_ENABLED;
    Container.Gamepass.Visible = Constants.STORE_GAMEPASSES_ENABLED;
    local u351 = nil;
    u351 = u14:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2710
        -- upvalues: u14 (ref), u351 (ref), Container (copy)
        if u14.Visible and u351 then
            u351:Disconnect();
            u351 = nil;
            Container.CanvasPosition = Vector2.zero;
        end;
    end);
    ActivateButton(u14.Tabs.Container.Featured.Container.CreatorCode.CreatorCodeButton);
    u14.Tabs.Container.Featured.Container.CreatorCode.CreatorCodeButton.MouseButton1Click:Connect(function() -- Line: 2720
        -- upvalues: Router (ref), openCreatorCode (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        openCreatorCode();
    end);
    local BlackmarketDealer = u14.Tabs.Container.Featured.Container:FindFirstChild("BlackmarketDealer");

    if BlackmarketDealer and BlackmarketDealer:IsA("GuiButton") then
        if Constants.BLACK_MARKET_ENABLED then
            local Timer = BlackmarketDealer:FindFirstChild("Timer", true);

            if not (Timer and Timer:IsA("TextLabel")) then
                Timer = nil;
            end;

            u12.TimerLabel = Timer;
            ActivateButton(BlackmarketDealer, nil, nil, 1, 0.98);
            BlackmarketDealer.MouseButton1Click:Connect(function() -- Line: 2734
                -- upvalues: ReplicatedStorage (ref), MenuState (ref)
                local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
                MenuState.HoldNavigationSelection(nil);
                Top.openFrame(MenuState.GetCurrentScreen() == "Blackmarket" and "Store" or "Blackmarket");
            end);
            Remotes.BlackMarketDealer.DealData.Listen(function(p352) -- Line: 2742
                -- upvalues: u12 (ref)
                local v353;

                if typeof(p352) == "table" then
                    v353 = p352.success and p352.deal;
                else
                    v353 = false;
                end;

                local v354;

                if typeof(v353) == "table" then
                    v354 = tonumber(v353.msRemaining);
                else
                    v354 = false;
                end;

                if v354 then
                    u12.RestockAt = os.clock() + v354 / 1000;
                end;
            end);
            local RewardBurst = BlackmarketDealer:FindFirstChild("RewardBurst");

            if RewardBurst and RewardBurst:IsA("GuiObject") then
                local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
                UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize;
                UIAspectRatioConstraint.Parent = RewardBurst;
            end;

            local Icon = BlackmarketDealer:FindFirstChild("Icon");
            local Skins2 = BlackmarketDealer:FindFirstChild("Skins");

            if Skins2 then
                Skins2 = Skins2:FindFirstChild("Glow");
            end;

            local Random_new_ret = Random.new();

            if Icon and Icon:IsA("GuiObject") then
                Icon.ZIndex = 3;
            end;

            local v355 = {};

            if not (RewardBurst and RewardBurst:IsA("GuiObject")) then
                RewardBurst = nil;
            end;

            v355.Burst = RewardBurst;
            local v356;

            if Icon and Icon:IsA("GuiObject") then
                v356 = Icon;
            else
                v356 = nil;
            end;

            v355.Icon = v356;
            local v357;

            if Icon and Icon:IsA("GuiObject") then
                v357 = Icon.Position;
            else
                v357 = UDim2.new();
            end;

            v355.IconPosition = v357;
            local v358;

            if Skins2 and Skins2:IsA("ImageLabel") then
                v358 = Skins2;
            else
                v358 = nil;
            end;

            v355.Glow = v358;
            v355.GlowTransparency = not (Skins2 and Skins2:IsA("ImageLabel")) and 0 or Skins2.ImageTransparency;
            v355.Glints = Glints.Create(BlackmarketDealer, u13.BLACKMARKET_GLINT_COUNT, Random_new_ret);
            v355.Random = Random_new_ret;
            u12.Fx = v355;
        else
            BlackmarketDealer.Visible = false;
        end;
    end;

    CloseButtonRegistry.Add(u15.Menu.OpenCase, u15.Menu.OpenCase.Contents.Close, function() -- Line: 2785
        -- upvalues: u22 (ref), CaseSceneController (ref), u26 (ref), CleanupCaseOpeningTweens (ref), finishBulkOpening (ref), u18 (ref), Router (ref), script_CaseScroll (ref), u15 (ref), Remotes (ref), u14 (ref), MenuState (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref)
        if u22 then
            CaseSceneController.SkipConsoleOpening();

            return;
        end;

        if u26.isBulkOpening then
            u26.skipped = true;
            CleanupCaseOpeningTweens();
            finishBulkOpening();

            return;
        end;

        if u18.isOpening then
            Router.broadcastRouter("RunStoreSound", "Case Close");
        end;

        CleanupCaseOpeningTweens();
        u26.isBulkOpening = false;
        u26.inventoryItems = nil;
        u26.bulkIdentifier = nil;
        u26.currentIndex = 0;
        u26.skipped = false;
        u26.caseId = nil;
        u26.total = 0;
        script_CaseScroll.ResetProgressBar();
        local currentInventoryItem = u18.currentInventoryItem;
        u18.isOpening = false;
        u18.currentInventoryItem = nil;
        CaseSceneController.HideCaseScene();
        u15.Menu.OpenCase.Visible = false;
        local currentCaseIdentifier = u18.currentCaseIdentifier;

        if currentCaseIdentifier then
            Remotes.Store.CaseOpenSequenceFinished.Send({
                CaseIdentifier = currentCaseIdentifier
            });
            u18.currentCaseIdentifier = nil;
        end;

        u14.Tabs.Container.Visible = true;
        u14.CaseContent.Visible = false;
        u15.Menu.Top.Visible = true;
        u14.Top.Visible = true;
        u14.Visible = false;
        MenuState.SetScreen("Inventory");

        if currentInventoryItem then
            Router.broadcastRouter("WeaponInspect", currentInventoryItem.Name, currentInventoryItem.Skin, currentInventoryItem.Float, currentInventoryItem.StatTrack, currentInventoryItem.NameTag, currentInventoryItem.Charm, currentInventoryItem.Stickers, currentInventoryItem.Type, currentInventoryItem.Pattern, currentInventoryItem._id, currentInventoryItem.Serial, currentInventoryItem.IsTradeable);

            return;
        end;

        u15.Menu.Inventory.Visible = true;
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    ActivateButton(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Open);
    u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Open.MouseButton1Click:Connect(function() -- Line: 2807
        -- upvalues: u10 (ref), u18 (ref), Cases (ref), Router (ref), u9 (ref), u14 (ref), CollectCaseIdentifiers (ref), u19 (ref), u20 (ref), u22 (ref), SetConsoleOverlay (ref), CaseSceneController (ref), Remotes (ref), u13 (ref), u24 (ref), u15 (ref), u23 (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref)
        if not u10 or (u18.isOpening or u18.isPendingOpenRequest) then
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

        local v359 = u10.caseType == "Console";
        local v360 = tonumber(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text) or 1;
        local v361;

        if v360 > 1 then
            v361 = CollectCaseIdentifiers(u10.name, v360);

            if #v361 < 2 then
                Router.broadcastRouter("CreateMenuNotification", "Error", "Not enough cases in your inventory.");

                return;
            end;
        else
            v361 = { u9 };
        end;

        local v362 = not v359;

        if v362 then
            if v360 == 1 then
                v362 = u18.isQuickUnlock;
            else
                v362 = false;
            end;
        end;

        local v363 = v360 > 1 and "Bulk" or (v362 and "Quick Open" or "Standard");
        u19 = u19 + 1;
        local u364 = tostring(u19);
        u20[u364] = {
            IsQuickUnlock = v362
        };
        u18.isPendingOpenRequest = true;
        u18.pendingOpenRequestId = u364;
        u18.isQuickUnlock = v362;

        if v359 then
            u22 = u364;
            u18.isOpening = true;
            u18.currentCaseIdentifier = v361[1];
            u14.CaseContent.Visible = false;
            u14.Visible = false;
            SetConsoleOverlay(true);
            CaseSceneController.BeginConsoleOpening();
            Remotes.Store.OpenConsole.Send({
                CaseIdentifiers = v361,
                CaseId = u10.caseId,
                RequestId = u364
            });
        else
            Remotes.Store.OpenCase.Send({
                CaseIdentifiers = v361,
                OpenType = v363,
                CaseId = u10.caseId,
                RequestId = u364
            });
        end;

        task.delay(u13.OPEN_CASE_REQUEST_TIMEOUT * (v360 > 1 and 2 or 1), function() -- Line: 2858
            -- upvalues: u18 (ref), u364 (copy), u20 (ref), u22 (ref), u24 (ref), CaseSceneController (ref), u15 (ref), u23 (ref), u14 (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref), Router (ref)
            if u18.isPendingOpenRequest and u18.pendingOpenRequestId == u364 then
                local v365 = u364;

                if v365 then
                    if u18.pendingOpenRequestId == v365 then
                        u18.isPendingOpenRequest = false;
                        u18.pendingOpenRequestId = nil;
                        u18.isQuickUnlock = false;
                    end;

                    u20[v365] = nil;
                end;

                if u22 == u364 then
                    u24[u364] = true;
                    u22 = nil;
                    u18.isOpening = false;
                    u18.currentInventoryItem = nil;
                    u18.currentCaseIdentifier = nil;
                    CaseSceneController.CancelConsoleOpening();
                    local Close = u15.Menu.OpenCase.Contents.Close;

                    if u23 then
                        for _, v in ipairs(u23) do
                            v.Visible = true;
                        end;

                        Close.TextLabel.Text = "CLOSE";
                        u23 = nil;
                    end;

                    u15.Menu.OpenCase.Visible = false;
                    u14.Visible = true;
                    u14.Tabs.Container.Visible = false;
                    u14.CaseContent.Visible = true;
                    u15.Menu.Top.Visible = false;
                    u14.Top.Visible = false;
                    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
                else
                    Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
                end;

                Router.broadcastRouter("CreateMenuNotification", "Error", "Opening case timed out. Please try again.");
            end;
        end);
    end);
    ActivateButton(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy);
    u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.MouseButton1Click:Connect(function() -- Line: 2875
        -- upvalues: u10 (ref), purchaseCase (ref), u14 (ref)
        if u10 then
            purchaseCase(u10, (tonumber(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text)));
        end;
    end);
    ActivateButton(u14.CaseContent.Main.Bottom.Buttons.Close);
    CloseButtonRegistry.Add(u14.CaseContent, u14.CaseContent.Main.Bottom.Buttons.Close, function() -- Line: 2886
        -- upvalues: u18 (ref), u27 (ref), u14 (ref)
        if not u18.isPendingOpenRequest then
            u27(u14.CaseContent:GetAttribute("State") == "Inspect" and "Store" or "Inventory");
        end;
    end);
    ActivateButton(u14.CreatorCode.Container.Action.Close);
    CloseButtonRegistry.Add(u14.CreatorCode, u14.CreatorCode.Container.Action.Close, closeCreatorCode);
    ActivateButton(u14.CreatorCode.Container.Body.CreatorName.Clear);
    u14.CreatorCode.Container.Body.CreatorName.Clear.MouseButton1Click:Connect(function() -- Line: 2898
        -- upvalues: u14 (ref), Remotes (ref)
        u14.CreatorCode.Container.Body.CreatorName.TextBox.Text = "";
        Remotes.UI.EquipCreatorCode.Send({
            CreatorCode = ""
        });
    end);
    ActivateButton(u14.CreatorCode.Container.Action.Confirm);
    u14.CreatorCode.Container.Action.Confirm.MouseButton1Click:Connect(function() -- Line: 2905
        -- upvalues: u14 (ref), Router (ref), UpdateCreatorCodeResponse (ref), Remotes (ref)
        local Text = u14.CreatorCode.Container.Body.CreatorName.TextBox.Text;
        u14.CreatorCode.Container.Action.Confirm.Title.Text = "SEARCHING..";
        Router.broadcastRouter("RunInterfaceSound", "UI Click");

        if Text and Text ~= "" then
            Remotes.UI.EquipCreatorCode.Send({
                CreatorCode = Text
            });

            return;
        end;

        UpdateCreatorCodeResponse("Error", "Creator code cannot be empty.");
    end);
    ClearFrame(u14.Gift.Container, { "UICorner", "UIListLayout" });
    CloseButtonRegistry.Add(u14.Gift, u14.Gift.Close, function() -- Line: 2919
        -- upvalues: Router (ref), u14 (ref)
        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u14.Gift.Visible = false;
    end);
    u14.Gift:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 2924
        -- upvalues: u14 (ref), u6 (ref), GuiService (ref), IsSelectionUsable (ref)
        if u14.Gift.Visible or not u6 then
            return;
        end;

        local v366;

        if IsSelectionUsable(u6) then
            v366 = u6;
        else
            v366 = u14.Top.Currency.Credits.Buy;
        end;

        GuiService.SelectedObject = v366;
        u6 = nil;
    end);
    ActivateButton(u14.Top.Currency.Credits.Buy);
    u14.Top.Currency.Credits.Buy.MouseButton1Click:Connect(function() -- Line: 2936
        -- upvalues: u1 (ref)
        u1.OpenTab("Credits");
    end);
    local TradeTokens2 = u14.Top.Currency.TradeTokens;
    TradeTokens2.Visible = true;
    local PurchaseMore = TradeTokens2.PurchaseMore;
    ActivateButton(PurchaseMore);
    PurchaseMore.MouseButton1Click:Connect(function() -- Line: 2944
        -- upvalues: u1 (ref)
        u1.OpenTab("TradeTokens");
    end);

    for _, child in u14.CaseContent.Main.Bottom.SubButtons.CenterButtons:GetChildren() do
        if child:IsA("ImageButton") then
            ActivateButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 2954
                -- upvalues: u10 (ref), Cases (ref), RunService (ref), Cases2 (ref), child (copy), DataController (ref), LocalPlayer (ref), u13 (ref), DoCreditPurchase (ref), MarketplaceService (ref)
                if not (u10 and (Cases.IsCaseForSale(u10.caseId) or RunService:IsStudio())) then
                    return;
                end;

                if not Cases.HasCaseModel(u10.caseId) then
                    return;
                end;

                local v367 = Cases2[u10.name];

                if not v367 then
                    return;
                end;

                local v368 = v367.Amounts[tonumber(child.Name)];

                if not v368 or v368.Offsale ~= false then
                    return;
                end;

                local v369 = DataController.Get(LocalPlayer, "TradeTokens");
                local BasePrice = v368.BasePrice;

                if math.floor(((not BasePrice or BasePrice <= 0) and (v368.Price or 0) or BasePrice) * u13.TRADE_TOKEN_CASE_MARKUP) <= v369 then
                    DoCreditPurchase(u10.name, v368, (tonumber(child.Name)));

                    return;
                end;

                MarketplaceService:PromptProductPurchase(LocalPlayer, v368.ID);
            end);
        end;
    end;

    for _, v in { "Credits", "TradeTokens" } do
        local v370 = v;

        for _, child in ipairs(u14.Tabs.Container.Featured.Container[v]:GetChildren()) do
            if child:IsA("Frame") then
                setupCurrencyFrame(child, v370 == "TradeTokens");
            end;
        end;
    end;

    script_StarterPack.Setup(LoadProductPrice, DoCreditPurchase, function() -- Line: 2990
        -- upvalues: u5 (ref)
        return u5;
    end);
    local Button = u14.Tabs.Container.Featured.Container.Console.Pack:FindFirstChild("Button");

    if Button and Button:IsA("GuiButton") then
        Button.Selectable = false;
        Button.Active = false;
    end;

    for _, child in u14.Tabs.Container.Featured.Container.Console.Pack.CenterButtons:GetChildren() do
        if child:IsA("ImageButton") then
            local u371 = DevProducts[`{child.Name} Consoles`];

            if u371 then
                local function u373(p372) -- Line: 3008
                    -- upvalues: child (copy), CommaNumber (ref)
                    child.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(p372)}`;
                end;

                if u371.Price and u373 then
                    local Price = u371.Price;
                    child.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(Price)}`;
                end;

                LoadProductInfo(u371.DevProductId, function(p374) -- Line: 279
                    -- upvalues: u371 (copy), u373 (copy)
                    if not (p374 and p374.PriceInRobux) then
                        return;
                    end;

                    u371.BasePrice = p374.UserBasePriceInRobux or u371.Price;
                    u371.Price = p374.PriceInRobux;

                    if u373 then
                        u373(u371.Price);
                    end;
                end);
                ActivateButton(child);
                child.MouseButton1Click:Connect(function() -- Line: 3013
                    -- upvalues: u5 (ref), DataController (ref), LocalPlayer (ref), u371 (copy), u13 (ref), DoCreditPurchase (ref), child (copy), MarketplaceService (ref), Router (ref)
                    if u5 then
                        local v375 = DataController.Get(LocalPlayer, "TradeTokens");
                        local v376 = u371;
                        local BasePrice = v376.BasePrice;

                        if math.floor(((not BasePrice or BasePrice <= 0) and (v376.Price or 0) or BasePrice) * u13.TRADE_TOKEN_CASE_MARKUP) <= v375 then
                            DoCreditPurchase(`{child.Name} Consoles`, u371, nil, (tonumber(child.Name)));
                        else
                            MarketplaceService:PromptProductPurchase(LocalPlayer, u371.DevProductId);
                        end;

                        Router.broadcastRouter("RunInterfaceSound", "UI Click");
                    end;
                end);
            end;
        end;
    end;

    script_Hover.Setup(u14, u13);

    for _, v in ipairs(u13.INSPECTABLE_ITEM_TAGS) do
        SetupTaggedInspectButtons(v);
    end;

    updateCases();
    StartBackgroundProductLoading();
    RunServiceController.BindToHeartbeat("UI.Store.Rotaters", function(p377) -- Line: 3039
        -- upvalues: Profiler (ref), u15 (ref), u14 (ref), CollectionService (ref)
        Profiler.mark("UI.Store.RotaterHeartbeat");

        if not u15.Menu.Visible then
            return;
        end;

        if not (u14.Visible or u15.Menu.Dashboard.Visible) then
            return;
        end;

        for _, v in ipairs(CollectionService:GetTagged("StoreRotaterFrame")) do
            v.Rotation = v.Rotation + p377 * 25;
        end;
    end);
    u14.Gift.Search.TextBox.Focused:Connect(function() -- Line: 3053
        -- upvalues: u14 (ref), refreshGiftNavigation (ref)
        local SearchResult = u14.Gift.Container:FindFirstChild("SearchResult");

        if SearchResult then
            SearchResult:Destroy();
        end;

        for _, child in ipairs(u14.Gift.Container:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = true;
            end;
        end;

        refreshGiftNavigation();
    end);
    u14.Gift.Search.TextBox.FocusLost:Connect(function() -- Line: 3068
        -- upvalues: PopulateGiftSearchResult (ref), u14 (ref), refreshGiftNavigation (ref)
        PopulateGiftSearchResult(u14.Gift.Search.TextBox.Text);
        refreshGiftNavigation();
    end);
    RunServiceController.BindToHeartbeat("UI.Store.TimersAndCredits", function(p378) -- Line: 3074
        -- upvalues: u14 (ref), u15 (ref), u8 (ref), u7 (ref), u1 (ref), script_StarterPack (ref), Profiler (ref), CommaNumber (ref), u2 (ref), u3 (ref), u4 (ref)
        local Visible = u14.Visible;

        if not (Visible or u15 and u15.Menu and u15.Menu.Visible) then
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
                u1.RefreshBlackmarketDealerTimer();
            end;
        end;

        u7 = u7 + p378;

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

        if not u15.Menu.Visible then
            return;
        end;

        local TextLabel = u14.Top.Currency.Credits.TextLabel;
        local Position = u2:getPosition();
        TextLabel.Text = CommaNumber((math.round(Position)));
        u2:update(p378);
        local TextLabel2 = u14.Top.Currency.TradeTokens.TextLabel;
        local Position2 = u3:getPosition();
        TextLabel2.Text = CommaNumber((math.round(Position2)));
        u3:update(p378);
        local TextLabel3 = u14.Top.Currency.Tickets.TextLabel;
        local Position3 = u4:getPosition();
        TextLabel3.Text = CommaNumber((math.round(Position3)));
        u4:update(p378);

        if u1.AnimateBlackmarketDealer then
            u1.AnimateBlackmarketDealer();
        end;
    end);
end;

local function hidePaidCurrencyPurchaseEntryPoints() -- Line: 3127
    -- upvalues: u14 (ref)
    u14.Top.Categories.Credits.Visible = false;
    u14.Top.Currency.Credits.Buy.Visible = false;
    u14.Top.Categories.TradeTokens.Visible = false;
    u14.Top.Currency.TradeTokens.PurchaseMore.Visible = false;
    u14.Tabs.Container.Featured.Container.Credits.Visible = false;
    u14.Tabs.Container.Featured.Container.TradeTokens.Visible = false;
end;

function u1.GetConsoleVignetteGradient() -- Line: 3138
    -- upvalues: u1 (copy), u14 (ref)
    local v379 = rawget(u1, "ConsoleVignetteGradient");

    if v379 then
        return v379;
    end;

    local Console = u14.Tabs.Container.Featured.Container:FindFirstChild("Console");

    if Console then
        Console = Console:FindFirstChild("AnimatedVignette", true);
    end;

    if not (Console and Console:IsA("ImageLabel")) then
        return nil;
    end;

    local v380 = Console:FindFirstChildOfClass("UIGradient");

    if not v380 then
        return nil;
    end;

    rawset(u1, "ConsoleVignetteImage", Console);
    rawset(u1, "ConsoleVignetteGradient", v380);
    rawset(u1, "ConsoleVignetteDefaultRotation", v380.Rotation);
    rawset(u1, "ConsoleVignetteDefaultTransparency", v380.Transparency);
    rawset(u1, "ConsoleVignetteDefaultImageTransparency", Console.ImageTransparency);

    return v380;
end;

function u1.SetConsoleVignettePulse(p381: number) -- Line: 3165
    -- upvalues: u1 (copy)
    local v382 = rawget(u1, "ConsoleVignetteGradient");

    if v382 then
        v382.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, 0.9 - p381 * 0.1),
            NumberSequenceKeypoint.new(0.45, 0.55 - p381 * 0.3),
            NumberSequenceKeypoint.new(0.58, 0.38 - p381 * 0.22),
            NumberSequenceKeypoint.new(0.82, 0.78 - p381 * 0.16),
            NumberSequenceKeypoint.new(1, 1)
        });
    end;

    local v383 = rawget(u1, "ConsoleVignetteImage");

    if v383 then
        v383.ImageTransparency = 0.58 - p381 * 0.16;
    end;
end;

u13.CONSOLE_VIGNETTE_CLEANUP = { { "ConsoleVignetteTween", "Cancel" }, { "ConsoleVignettePulseTween", "Cancel" }, { "ConsoleVignettePulseConnection", "Disconnect" }, { "ConsoleVignettePulseValue", "Destroy" } };

function u1.StopConsoleVignetteTween() -- Line: 3193
    -- upvalues: u13 (copy), u1 (copy)
    for _, v in u13.CONSOLE_VIGNETTE_CLEANUP do
        local v384 = v[1];
        local v385 = v[2];
        local v386 = rawget(u1, v384);

        if v386 then
            v386[v385](v386);
            rawset(u1, v384, nil);
        end;
    end;

    local v387 = rawget(u1, "ConsoleVignetteGradient");

    if v387 then
        v387.Rotation = rawget(u1, "ConsoleVignetteDefaultRotation") or -180;
        v387.Transparency = rawget(u1, "ConsoleVignetteDefaultTransparency") or v387.Transparency;
    end;

    local v388 = rawget(u1, "ConsoleVignetteImage");

    if v388 then
        v388.ImageTransparency = rawget(u1, "ConsoleVignetteDefaultImageTransparency") or 0.5;
    end;
end;

function u1.UpdateConsoleVignetteTween() -- Line: 3217
    -- upvalues: u14 (ref), u1 (copy), TweenService (copy)
    if not u14.Visible then
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
    local v389 = TweenService:Create(ConsoleVignetteGradient, TweenInfo.new(14, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = ConsoleVignetteGradient.Rotation + 360
    });
    rawset(u1, "ConsoleVignetteTween", v389);
    v389:Play();
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    rawset(u1, "ConsoleVignettePulseValue", NumberValue);
    local PropertyChangedSignal = NumberValue:GetPropertyChangedSignal("Value");
    rawset(u1, "ConsoleVignettePulseConnection", PropertyChangedSignal:Connect(function() -- Line: 3247
        -- upvalues: u1 (ref), NumberValue (copy)
        u1.SetConsoleVignettePulse(NumberValue.Value);
    end));
    u1.SetConsoleVignettePulse(0);
    local v390 = TweenService:Create(NumberValue, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Value = 1
    });
    rawset(u1, "ConsoleVignettePulseTween", v390);
    v390:Play();
end;

local function BindAmountButtonHover(u391: userdata) -- Line: 3264
    u391.MouseEnter:Connect(function() -- Line: 3265
        -- upvalues: u391 (copy)
        if not u391:GetAttribute("Selected") then
            u391.Frame.BackgroundTransparency = 0.5;
        end;
    end);
    u391.MouseLeave:Connect(function() -- Line: 3270
        -- upvalues: u391 (copy)
        if not u391:GetAttribute("Selected") then
            u391.Frame.BackgroundTransparency = 1;
        end;
    end);
end;

function u1.Start() -- Line: 3277
    -- upvalues: Profiler (copy), DataController (copy), LocalPlayer (copy), ReplicatedStorage (copy), u16 (copy), u1 (copy), PolicyService (copy), u5 (ref), hidePaidCurrencyPurchaseEntryPoints (copy), u14 (ref), ActivateCategoryButton (copy), MenuState (copy), u11 (ref), u13 (copy), GamepadNavigation (copy), ActivateButton (copy), BindAmountButtonHover (copy), u10 (ref), CommaNumber (copy), SelectAmountButton (copy), refreshGiftNavigation (copy), GuiService (copy), script_StarterPack (copy), u2 (copy), RefreshCaseAmountButtons (copy), u3 (copy), u4 (copy), Constants (copy), Cases (copy), RefreshCaseListings (copy), Remotes (copy), UpdateCreatorCodeResponse (copy), closeCreatorCode (copy), u20 (copy), u18 (copy), u21 (copy), TryProcessResolvedCaseOpenQueue (copy), u24 (copy), u22 (ref), u31 (ref), u25 (ref), CaseSceneController (copy), u15 (ref), u23 (ref), IsSelectionUsable (copy), Observers (copy), activateGiftTemplate (copy)
    debug.setmemorycategory("UI.Store.Start");
    Profiler.mark("UI.Store.Start.Begin");
    DataController.WaitForDataLoaded(LocalPlayer);
    Profiler.mark("UI.Store.Start.DataLoaded");
    require(ReplicatedStorage.Controllers.TimerController).ListenToTimerChanged(u16.Source, function(p392) -- Line: 3284
        -- upvalues: u16 (ref), u1 (ref)
        u16.Tick = p392;
        local ServerTimeNow = workspace:GetServerTimeNow();
        u16.ReceivedAt = math.floor(ServerTimeNow);
        u1.RefreshFeaturedConsoleTimer(u16.ReceivedAt);
    end);
    local success, result = pcall(function() -- Line: 3290
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

    u14:GetPropertyChangedSignal("Visible"):Connect(u1.UpdateConsoleVignetteTween);
    u1.UpdateConsoleVignetteTween();

    for _, child in ipairs(u14.Top.Categories:GetChildren()) do
        if child:IsA("ImageButton") then
            ActivateCategoryButton(child);
            child.MouseButton1Click:Connect(function() -- Line: 3311
                -- upvalues: u1 (ref), child (copy)
                u1.OpenTab(child.Name);
            end);
        end;
    end;

    MenuState.RegisterBumperOverride(u14, function(p393: boolean) -- Line: 3320
        -- upvalues: u14 (ref), u11 (ref), MenuState (ref), u13 (ref), u1 (ref), GamepadNavigation (ref)
        if not u14.Tabs.Visible then
            return false;
        end;

        local v394 = u11;
        local StarterPack = u14.Tabs.Container.Featured.Container:FindFirstChild("StarterPack");

        if StarterPack and MenuState.IsSelectionWithin(StarterPack) then
            v394 = nil;
        end;

        local NextBumperTab = MenuState.GetNextBumperTab(u14.Top.Categories, u13.TAB_ORDER, v394, p393);

        if NextBumperTab and NextBumperTab ~= v394 then
            task.spawn(function() -- Line: 3337
                -- upvalues: u1 (ref), NextBumperTab (copy), u14 (ref), u11 (ref), MenuState (ref), GamepadNavigation (ref)
                u1.OpenTab(NextBumperTab);
                local v395 = u14.Tabs.Container.Featured.Container:FindFirstChild(NextBumperTab);

                if u11 == NextBumperTab and (v395 and (MenuState.IsSelectionWithin(u14.Tabs) and not MenuState.IsSelectionWithin(v395))) then
                    GamepadNavigation.Focus(v395);
                end;
            end);
        end;

        return true;
    end, u14, u14.Tabs);
    ActivateButton(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount);
    u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.MouseButton1Click:Connect(function() -- Line: 3358
        -- upvalues: u14 (ref), Profiler (ref)
        local Container = u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container;
        Container.Visible = not Container.Visible;

        if not Container.Visible then
            u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 180;

            return;
        end;

        u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.ImageLabel.Rotation = 0;
        local Scroll = Container.Scroll;
        Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 497
            -- upvalues: Scroll (copy)
            local math_max_ret = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteWindowSize.Y);
            Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, math_max_ret);
        end);
    end);
    ActivateButton(u14.CaseContent.Main.Odds.Frame.Close);
    ActivateButton(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds);
    u14.CaseContent.Main.Odds.Frame.Close.MouseButton1Click:Connect(function() -- Line: 3373
        -- upvalues: u14 (ref)
        u14.CaseContent.Main.Odds.Visible = false;
    end);
    u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Odds.MouseButton1Click:Connect(function() -- Line: 3377
        -- upvalues: u14 (ref)
        u14.CaseContent.Main.Odds.Visible = true;
    end);

    for _, child in ipairs(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            BindAmountButtonHover(child);
            child.MouseButton1Click:Connect(function() -- Line: 3387
                -- upvalues: u10 (ref), child (copy), u14 (ref), CommaNumber (ref), SelectAmountButton (ref)
                local v396 = u10.price * tonumber(child.Name);
                u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Buy.Container.Title.Text = `BUY <font color="#ffda0f">({CommaNumber(v396)})</font>`;
                u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Header.TextLabel.Text = tostring(child.Name);
                u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Visible = false;
                SelectAmountButton(u14.CaseContent.Main.Bottom.Buttons.CenterButtons.Amount.Container.Scroll, child);
            end);
        end;
    end;

    u14.Gift.Amount.MouseButton1Click:Connect(function() -- Line: 3400
        -- upvalues: u14 (ref), Profiler (ref), refreshGiftNavigation (ref)
        local Container = u14.Gift.Amount.Container;
        Container.Visible = not Container.Visible;

        if Container.Visible then
            u14.Gift.Amount.Header.ImageLabel.Rotation = 0;
            Profiler.defer("UI.Store.ScrollToBottomDeferred", function() -- Line: 497
                -- upvalues: Container (copy)
                local math_max_ret = math.max(0, Container.AbsoluteCanvasSize.Y - Container.AbsoluteWindowSize.Y);
                Container.CanvasPosition = Vector2.new(Container.CanvasPosition.X, math_max_ret);
            end);
        else
            u14.Gift.Amount.Header.ImageLabel.Rotation = 180;
        end;

        refreshGiftNavigation();
    end);

    for _, child in ipairs(u14.Gift.Amount.Container:GetChildren()) do
        if child:IsA("TextButton") then
            BindAmountButtonHover(child);
            child.MouseButton1Click:Connect(function() -- Line: 3416
                -- upvalues: u14 (ref), child (copy), GuiService (ref), SelectAmountButton (ref), refreshGiftNavigation (ref)
                u14.Gift.Amount.Header.TextLabel.Text = tostring(child.Name);
                local v397 = GuiService.SelectedObject == child;
                u14.Gift.Amount.Container.Visible = false;
                SelectAmountButton(u14.Gift.Amount.Container, child);

                if v397 then
                    GuiService.SelectedObject = u14.Gift.Amount;
                end;

                refreshGiftNavigation();
            end);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Statistics.OpenShopTime", function(p398) -- Line: 3429
        -- upvalues: script_StarterPack (ref)
        script_StarterPack.OnOpenShopTimeChanged(p398);
    end);
    DataController.CreateListener(LocalPlayer, "Gamepasses", function() -- Line: 3433
        -- upvalues: script_StarterPack (ref)
        script_StarterPack.Refresh();
    end);
    MenuState.OnScreenChanged:Connect(function(p399, p400) -- Line: 3437
        -- upvalues: script_StarterPack (ref)
        if p400 == "Store" then
            script_StarterPack.HandleStoreOpened();
        end;
    end);

    if MenuState.GetCurrentScreen() == "Store" then
        script_StarterPack.HandleStoreOpened();
    else
        script_StarterPack.Refresh();
    end;

    DataController.CreateListener(LocalPlayer, "Credits", function(p401) -- Line: 3450
        -- upvalues: u2 (ref), RefreshCaseAmountButtons (ref)
        u2:setGoal(p401);
        RefreshCaseAmountButtons();
    end);
    DataController.CreateListener(LocalPlayer, "TradeTokens", function(p402) -- Line: 3456
        -- upvalues: u3 (ref)
        u3:setGoal(p402);
    end);
    DataController.CreateListener(LocalPlayer, "Exclusive Raffle Ticket", function(p403) -- Line: 3461
        -- upvalues: u4 (ref)
        u4:setGoal(p403);
    end);
    task.defer(function() -- Line: 3466
        -- upvalues: u14 (ref), u13 (ref), DataController (ref), LocalPlayer (ref), Constants (ref)
        local Credits = u14.Tabs.Container.Featured.Container:WaitForChild("Credits");
        local u404 = Credits:FindFirstChild("+ 67,500 Credits");

        if not u404 then
            return;
        end;

        local Size = Credits.Size;
        local UDim2_new_ret = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * u13.MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO, Size.Y.Offset * u13.MINT_RESERVE_HIDDEN_CREDITS_HEIGHT_RATIO);

        local function SetMintReserveVisible(p405: boolean) -- Line: 3481
            -- upvalues: Credits (copy), Size (copy), UDim2_new_ret (copy), u404 (copy)
            local v406;

            if p405 then
                v406 = Size;
            else
                v406 = UDim2_new_ret;
            end;

            Credits.Size = v406;
            u404.Visible = p405;
        end;

        Credits.Size = UDim2_new_ret;
        u404.Visible = false;
        DataController.CreateListener(LocalPlayer, "Statistics.RobuxSpent", function(p407) -- Line: 3487
            -- upvalues: Constants (ref), Credits (copy), Size (copy), UDim2_new_ret (copy), u404 (copy)
            local v408 = (tonumber(p407) or 0) >= Constants.MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION;
            local v409;

            if v408 then
                v409 = Size;
            else
                v409 = UDim2_new_ret;
            end;

            Credits.Size = v409;
            u404.Visible = v408;
        end);
    end);
    Cases.ObserveAvailableCases(RefreshCaseListings);
    Remotes.UI.UpdateCreatorCode.Listen(function(p410) -- Line: 3497
        -- upvalues: u14 (ref), UpdateCreatorCodeResponse (ref), closeCreatorCode (ref)
        u14.CreatorCode.Container.Action.Confirm.Title.Text = "CONFIRM";
        UpdateCreatorCodeResponse(p410.Type, p410.Text);

        if p410.Type == "Success" and u14.CreatorCode.Visible then
            task.delay(1, function() -- Line: 3502
                -- upvalues: u14 (ref), closeCreatorCode (ref)
                if u14.CreatorCode.Visible then
                    closeCreatorCode();
                end;
            end);
        end;
    end);
    Remotes.Store.CaseOpened.Listen(function(p411) -- Line: 3511
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u20 (ref), u18 (ref), u21 (ref), TryProcessResolvedCaseOpenQueue (ref)
        Profiler.mark("UI.Store.CaseOpenedRemote");

        if p411.InventoryItems and #p411.InventoryItems > 0 then
            DataController.ApplyInventoryDelta(LocalPlayer, p411.InventoryItems, p411.DeletedCaseIds);
        end;

        local v412;

        if typeof(p411.RequestId) == "string" then
            v412 = p411.RequestId;
        else
            v412 = nil;
        end;

        local v413;

        if v412 then
            v413 = u20[v412];
        else
            v413 = v412;
        end;

        if v413 then
            if v412 then
                if u18.pendingOpenRequestId == v412 then
                    u18.isPendingOpenRequest = false;
                    u18.pendingOpenRequestId = nil;
                    u18.isQuickUnlock = false;
                end;

                u20[v412] = nil;
            end;
        else
            v413 = nil;
        end;

        if v412 and not v413 then
            return;
        end;

        table.insert(u21, {
            CaseId = p411.CaseId,
            InventoryItems = p411.InventoryItems,
            CaseIdentifier = p411.CaseIdentifier,
            IsQuickUnlock = v413 and v413.IsQuickUnlock or false,
            RequestId = v412
        });
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    Remotes.Store.ConsoleOpened.Listen(function(u414) -- Line: 3533
        -- upvalues: Profiler (ref), DataController (ref), LocalPlayer (ref), u24 (ref), u22 (ref), u20 (ref), u18 (ref), u21 (ref), TryProcessResolvedCaseOpenQueue (ref), u31 (ref), u25 (ref), CaseSceneController (ref), Cases (ref)
        Profiler.mark("UI.Store.ConsoleOpenedRemote");
        DataController.ApplyInventoryDelta(LocalPlayer, u414.InventoryItems, u414.DeletedCaseIds);
        local ConsoleOutcomes = u414.ConsoleOutcomes;

        if not ConsoleOutcomes or #ConsoleOutcomes == 0 then
            ConsoleOutcomes = u414.ConsoleOutcome and { u414.ConsoleOutcome } or ConsoleOutcomes;
        end;

        local RequestId = u414.RequestId;
        local v415;

        if RequestId then
            v415 = u24[RequestId] == true;
        else
            v415 = RequestId;
        end;

        if u22 ~= RequestId and not v415 then
            return;
        end;

        if v415 then
            u24[RequestId] = nil;
        else
            local v416;

            if RequestId then
                v416 = u20[RequestId];
            else
                v416 = RequestId;
            end;

            if v416 then
                if RequestId then
                    if u18.pendingOpenRequestId == RequestId then
                        u18.isPendingOpenRequest = false;
                        u18.pendingOpenRequestId = nil;
                        u18.isQuickUnlock = false;
                    end;

                    u20[RequestId] = nil;
                end;
            else
                v416 = nil;
            end;

            if not v416 then
                return;
            end;
        end;

        local u417 = u414.InventoryItems[1];

        if v415 then
            table.insert(u21, {
                IsQuickUnlock = false,
                IsConsole = true,
                CaseId = u414.CaseId,
                InventoryItems = u414.InventoryItems,
                CaseIdentifier = u414.CaseIdentifier,
                RequestId = RequestId,
                ConsoleOutcomes = ConsoleOutcomes
            });
            Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);

            return;
        end;

        if #u414.InventoryItems > 1 then
            u22 = nil;
            u31(u414.CaseId, u414.InventoryItems, ConsoleOutcomes or {}, u414.CaseIdentifier);

            return;
        end;

        u18.currentInventoryItem = u417;
        u18.currentCaseIdentifier = u414.CaseIdentifier;

        if ConsoleOutcomes then
            ConsoleOutcomes = ConsoleOutcomes[1];
        end;

        if ConsoleOutcomes then
            if not CaseSceneController.ResolveConsoleOpening(ConsoleOutcomes, function(p418) -- Line: 3576
                -- upvalues: u25 (ref), u417 (copy), u414 (copy)
                u25(u417, u414.CaseIdentifier, p418);
            end, Cases.GetCase(u414.CaseId), u417) then
                u25(u417, u414.CaseIdentifier);
            end;

            return;
        end;

        u25(u417, u414.CaseIdentifier);
    end);
    Remotes.Store.CaseOpenDenied.Listen(function(p419) -- Line: 3585
        -- upvalues: u18 (ref), u20 (ref), u24 (ref), u22 (ref), CaseSceneController (ref), u15 (ref), u23 (ref), u14 (ref), Profiler (ref), TryProcessResolvedCaseOpenQueue (ref)
        local RequestId = p419.RequestId;

        if RequestId then
            if u18.pendingOpenRequestId == RequestId then
                u18.isPendingOpenRequest = false;
                u18.pendingOpenRequestId = nil;
                u18.isQuickUnlock = false;
            end;

            u20[RequestId] = nil;
        end;

        if RequestId then
            u24[RequestId] = nil;
        end;

        if u22 ~= RequestId then
            Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);

            return;
        end;

        u22 = nil;
        u18.isOpening = false;
        u18.currentInventoryItem = nil;
        u18.currentCaseIdentifier = nil;
        CaseSceneController.CancelConsoleOpening();
        local Close = u15.Menu.OpenCase.Contents.Close;

        if u23 then
            for _, v in ipairs(u23) do
                v.Visible = true;
            end;

            Close.TextLabel.Text = "CLOSE";
            u23 = nil;
        end;

        u15.Menu.OpenCase.Visible = false;
        u14.Visible = true;
        u14.Tabs.Container.Visible = false;
        u14.CaseContent.Visible = true;
        u15.Menu.Top.Visible = false;
        u14.Top.Visible = false;
        Profiler.defer("UI.Store.ResolvedQueueDeferred", TryProcessResolvedCaseOpenQueue);
    end);
    MenuState.OnInspectStateChanged:Connect(function(p420) -- Line: 3600
        -- upvalues: Profiler (ref), TryProcessResolvedCaseOpenQueue (ref), MenuState (ref), u14 (ref), CaseSceneController (ref), u10 (ref), u15 (ref)
        if not p420 then
            Profiler.defer("UI.Store.InspectClosedDeferred", function() -- Line: 3602
                -- upvalues: TryProcessResolvedCaseOpenQueue (ref), MenuState (ref), u14 (ref), CaseSceneController (ref), u10 (ref), u15 (ref)
                if TryProcessResolvedCaseOpenQueue() then
                    return;
                end;

                local CurrentScreen = MenuState.GetCurrentScreen();
                local v421 = u14.CaseContent:GetAttribute("WasVisibleBeforeInspect") == true;
                local v422 = CaseSceneController.IsActive();

                if u10 and (CurrentScreen == "Store" and (v421 and v422)) then
                    u14.Visible = true;
                    u14.Tabs.Container.Visible = false;
                    u14.CaseContent.Visible = true;
                    u15.Menu.Top.Visible = false;
                    u14.Top.Visible = false;
                    MenuState.SetBlurEnabled(false);
                    local MenuFrame = MenuState.GetMenuFrame();

                    if MenuFrame then
                        MenuFrame.BackgroundTransparency = 1;
                    end;
                elseif u14.CaseContent.Visible and CurrentScreen == "Inventory" then
                    u14.Visible = true;
                    u14.Tabs.Container.Visible = false;
                    u14.CaseContent.Visible = true;
                    u15.Menu.Top.Visible = false;
                    u14.Top.Visible = false;
                    local Inventory = u15.Menu:FindFirstChild("Inventory");

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
    ActivateButton(u14.CaseContent.Main.ItemOddsFrame.Close);
    u14.CaseContent.Main.ItemOddsFrame.Close.MouseButton1Click:Connect(function() -- Line: 3642
        -- upvalues: u14 (ref)
        u14.CaseContent.Main.ItemOddsFrame.Visible = false;
    end);
    local Main = u14.CaseContent.Main;
    local Odds = Main.Odds;
    local ItemOddsFrame = Main.ItemOddsFrame;
    local Container = Odds.Frame.Container;
    local u423 = nil;
    ItemOddsFrame.Active = true;
    Odds:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3659, Name: refreshCoveredContent
        -- upvalues: Main (copy), Odds (copy), ItemOddsFrame (copy), Container (copy)
        Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
        Container.Interactable = not ItemOddsFrame.Visible;
    end);
    ItemOddsFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 3665
        -- upvalues: GuiService (ref), ItemOddsFrame (copy), Container (copy), u423 (ref), Main (copy), Odds (copy), IsSelectionUsable (ref)
        local SelectedObject = GuiService.SelectedObject;

        if ItemOddsFrame.Visible then
            if SelectedObject and SelectedObject:IsDescendantOf(Container) then
                u423 = SelectedObject;
                GuiService.SelectedObject = ItemOddsFrame.Close;
            end;

            Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
            Container.Interactable = not ItemOddsFrame.Visible;

            return;
        end;

        Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
        Container.Interactable = not ItemOddsFrame.Visible;
        local v424 = u423;
        u423 = nil;

        if (SelectedObject == nil or SelectedObject:IsDescendantOf(ItemOddsFrame)) and IsSelectionUsable(v424) then
            GuiService.SelectedObject = v424;
        end;
    end);
    Main.CaseContent.Container.Interactable = not (Odds.Visible or ItemOddsFrame.Visible);
    Container.Interactable = not ItemOddsFrame.Visible;
    Observers.observePlayer(function(p425) -- Line: 3687
        -- upvalues: LocalPlayer (ref), ReplicatedStorage (ref), u14 (ref), activateGiftTemplate (ref), refreshGiftNavigation (ref)
        if LocalPlayer == p425 then
            return function() -- Line: 3689
            end;
        end;

        local u426 = ReplicatedStorage.Assets.UI.Store.PlayerTemplate:Clone();
        u426.Player.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={p425.UserId}&w=420&h=420`;
        u426.Player.Username.Text = `@{p425.Name}`;
        u426.Parent = u14.Gift.Container;
        u426.Name = tostring(p425.UserId);
        activateGiftTemplate(u426, p425.UserId);
        refreshGiftNavigation();

        return function() -- Line: 3698
            -- upvalues: u426 (copy), refreshGiftNavigation (ref)
            u426:Destroy();
            refreshGiftNavigation();
        end;
    end);
end;

return u1;