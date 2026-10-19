-- HalloweenEvent (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Menu.HalloweenEvent

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local PolicyService = game:GetService("PolicyService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local TimerController = require(ReplicatedStorage.Controllers.TimerController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local AnimateHalloweenWheel = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateHalloweenWheel);
local AnimateHalloweenInfoPanel = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateHalloweenInfoPanel);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration);
local GuiShown = require(ReplicatedStorage.Components.Common.InterfaceAnimations.GuiShown);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Spring = require(ReplicatedStorage.Shared.Spring);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local TradeTokens = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens);
local HalloweenEvent = require(ReplicatedStorage.Database.Custom.GameStats.HalloweenEvent);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top);
local LocalPlayer = Players.LocalPlayer;
local CANDY_FIELD = HalloweenEvent.CANDY_FIELD;
local SPIN_CANDY_PRICE = HalloweenEvent.SPIN_CANDY_PRICE;
local u2 = {
    ["120311691702295"] = "Glock-18 | Revenant",
    ["81207915486255"] = "Charm | Pumpkin",
    ["109503427239906"] = "Sawed-Off | Coffin",
    ["87922752480721"] = "AWP | Vampire"
};
local u3 = {
    Offer1 = "+ 1,000 Candy",
    Offer2 = "+ 4,500 Candy",
    Offer3 = "+ 11,000 Candy"
};
local TweenInfo_new_ret = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local utf8_char_ret = utf8.char(57346);
local u4 = { "Purchase", "PurchaseType" };
local u5 = nil;
local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = nil;
local u12 = 0;
local u13 = false;
local u14 = nil;
local u15 = 0;

local function getTimerText() -- Line: 150
    -- upvalues: TimerController (copy), FormatDuration (copy)
    local SecondsRemaining = TimerController.GetSecondsRemaining("Halloween2026EventTimer");

    return not SecondsRemaining and "--:--:--" or FormatDuration(SecondsRemaining, "IfNeeded");
end;

local function close() -- Line: 157
    -- upvalues: Top (copy), u5 (ref), GamepadNavigation (copy)
    Top.openFrame("Dashboard");

    if u5 then
        GamepadNavigation.Focus(u5);
        u5 = nil;
    end;
end;

local function notifyError(p16: string) -- Line: 168
    -- upvalues: Router (copy)
    Router.broadcastRouter("CreateMenuNotification", "Error", p16);
end;

local function closePurchaseDialog() -- Line: 174
    -- upvalues: u9 (ref)
    if u9 then
        u9:Destroy();
        u9 = nil;
    end;
end;

local function loadRobuxPrice(u17: any, u18: function) -- Line: 185
    -- upvalues: u10 (copy), MarketplaceService (copy)
    if u17.Price then
        u18(u17.Price);
    end;

    if u10[u17.DevProductId] then
        return;
    end;

    u10[u17.DevProductId] = true;
    task.spawn(function() -- Line: 193
        -- upvalues: MarketplaceService (ref), u17 (copy), u18 (copy), u10 (ref)
        local success, result = pcall(function() -- Line: 194
            -- upvalues: MarketplaceService (ref), u17 (ref)
            return MarketplaceService:GetProductInfoAsync(u17.DevProductId, Enum.InfoType.Product);
        end);

        if not (success and (result and result.PriceInRobux)) then
            u10[u17.DevProductId] = nil;

            return;
        end;

        u17.BasePrice = result.UserBasePriceInRobux or result.PriceInRobux;
        u17.Price = result.PriceInRobux;
        u18(result.PriceInRobux);
    end);
end;

local function getPurchaseDialogTemplate() -- Line: 210
    -- upvalues: u7 (ref), u4 (copy)
    local v19 = u7:FindFirstChild("Menu") and u7.Menu:FindFirstChild("Store");

    if not v19 then
        return nil;
    end;

    for _, v in u4 do
        local v20 = v19:FindFirstChild(v);

        if v20 then
            return v20;
        end;
    end;

    return nil;
end;

local function getTradeTokens() -- Line: 226
    -- upvalues: DataController (copy), LocalPlayer (copy)
    return tonumber(DataController.Get(LocalPlayer, "TradeTokens")) or 0;
end;

local function buyWithTradeTokens(p21: string) -- Line: 232
    -- upvalues: TradeTokens (copy), DataController (copy), LocalPlayer (copy), Router (copy), Remotes (copy)
    local v22 = TradeTokens[p21] and TradeTokens[p21].Price;

    if not v22 then
        return;
    end;

    if (tonumber(DataController.Get(LocalPlayer, "TradeTokens")) or 0) < v22 then
        Router.broadcastRouter("CreateMenuNotification", "Error", "You do not have enough Trade Tokens.");

        return;
    end;

    Remotes.Store.PurchaseTradeTokensProduct.Send({
        ProductName = p21
    });
end;

local function openPurchaseDialog(u23: string, p24: any) -- Line: 249
    -- upvalues: DevProducts (copy), TradeTokens (copy), CommaNumber (copy), DataController (copy), LocalPlayer (copy), u8 (ref), u9 (ref), u10 (copy), MarketplaceService (copy), ActivateButton (copy), closePurchaseDialog (copy), buyWithTradeTokens (copy), GamepadNavigation (copy)
    local u25 = DevProducts[u23];
    local v26 = TradeTokens[u23];
    local u27 = p24:Clone();
    u27.Name = "CandyPurchase";
    local Info = u27.Main.Info;
    u27.Main.Header.Title.Text = u23;
    Info.Frame.Credits.TextLabel.Text = CommaNumber(tonumber(DataController.Get(LocalPlayer, "TradeTokens")) or 0);
    Info.Robux.Credits.Amount.Text = not u25.Price and "..." or CommaNumber(u25.Price);
    Info.TradeTokens.Credits.Amount.Text = CommaNumber(v26.Price);
    u27.ZIndex = u8.ZIndex + 1;
    u27.Visible = true;
    u27.Parent = u8.Parent;
    u9 = u27;

    local function u29(p28: number) -- Line: 266
        -- upvalues: u27 (copy), Info (copy), CommaNumber (ref)
        if u27.Parent then
            Info.Robux.Credits.Amount.Text = CommaNumber(p28);
        end;
    end;

    if u25.Price then
        local Price = u25.Price;

        if u27.Parent then
            Info.Robux.Credits.Amount.Text = CommaNumber(Price);
        end;
    end;

    if not u10[u25.DevProductId] then
        u10[u25.DevProductId] = true;
        task.spawn(function() -- Line: 193
            -- upvalues: MarketplaceService (ref), u25 (copy), u29 (copy), u10 (ref)
            local success, result = pcall(function() -- Line: 194
                -- upvalues: MarketplaceService (ref), u25 (ref)
                return MarketplaceService:GetProductInfoAsync(u25.DevProductId, Enum.InfoType.Product);
            end);

            if not (success and (result and result.PriceInRobux)) then
                u10[u25.DevProductId] = nil;

                return;
            end;

            u25.BasePrice = result.UserBasePriceInRobux or result.PriceInRobux;
            u25.Price = result.PriceInRobux;
            u29(result.PriceInRobux);
        end);
    end;

    ActivateButton(u27.Main.Action.Frame.Close);
    u27.Main.Action.Frame.Close.MouseButton1Click:Connect(closePurchaseDialog);
    ActivateButton(Info.Robux);
    Info.Robux.MouseButton1Click:Connect(function() -- Line: 276
        -- upvalues: u9 (ref), MarketplaceService (ref), LocalPlayer (ref), u25 (copy)
        if u9 then
            u9:Destroy();
            u9 = nil;
        end;

        MarketplaceService:PromptProductPurchase(LocalPlayer, u25.DevProductId);
    end);
    ActivateButton(Info.TradeTokens);
    Info.TradeTokens.MouseButton1Click:Connect(function() -- Line: 282
        -- upvalues: u9 (ref), buyWithTradeTokens (ref), u23 (copy)
        if u9 then
            u9:Destroy();
            u9 = nil;
        end;

        buyWithTradeTokens(u23);
    end);
    GamepadNavigation.Focus(Info.Robux);
end;

local function canSellPaidRandomItems() -- Line: 299
    -- upvalues: u14 (ref), PolicyService (copy), LocalPlayer (copy)
    if u14 == nil then
        local success, result = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer);

        if success and result then
            u14 = result.ArePaidRandomItemsRestricted ~= true;
        end;
    end;

    return u14 == true;
end;

local function buyCandy(p30: string) -- Line: 315
    -- upvalues: u9 (ref), DevProducts (copy), TradeTokens (copy), Router (copy), u14 (ref), PolicyService (copy), LocalPlayer (copy), getPurchaseDialogTemplate (copy), DataController (copy), openPurchaseDialog (copy), MarketplaceService (copy)
    if u9 then
        return;
    end;

    local v31 = DevProducts[p30];
    local v32 = TradeTokens[p30];

    if not (v31 and v32) then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Candy is not available right now.");

        return;
    end;

    if u14 == nil then
        local success, result = pcall(PolicyService.GetPolicyInfoForPlayerAsync, PolicyService, LocalPlayer);

        if success and result then
            u14 = result.ArePaidRandomItemsRestricted ~= true;
        end;
    end;

    if u14 ~= true then
        Router.broadcastRouter("CreateMenuNotification", "Error", "You cannot purchase candy in a restricted region.");

        return;
    end;

    local v33 = getPurchaseDialogTemplate();

    if v33 and (tonumber(DataController.Get(LocalPlayer, "TradeTokens")) or 0) >= v32.Price then
        openPurchaseDialog(p30, v33);

        return;
    end;

    MarketplaceService:PromptProductPurchase(LocalPlayer, v31.DevProductId);
end;

local function bindCandyOffers(p34: table) -- Line: 342
    -- upvalues: u3 (copy), u8 (ref), DevProducts (copy), utf8_char_ret (copy), CommaNumber (copy), u10 (copy), MarketplaceService (copy), ActivateButton (copy), Router (copy), buyCandy (copy)
    for i, v in u3 do
        local u35 = u8.InfoPanel.BuyCandy:FindFirstChild(i);
        local u36 = DevProducts[v];

        if u35 and u36 then
            local function u38(p37: number) -- Line: 350
                -- upvalues: u35 (copy), utf8_char_ret (ref), CommaNumber (ref)
                u35.Buy.Container.Title.Text = `{utf8_char_ret}{CommaNumber(p37)}`;
            end;

            if u36.Price then
                u35.Buy.Container.Title.Text = `{utf8_char_ret}{CommaNumber(u36.Price)}`;
            end;

            if not u10[u36.DevProductId] then
                u10[u36.DevProductId] = true;
                task.spawn(function() -- Line: 193
                    -- upvalues: MarketplaceService (ref), u36 (copy), u38 (copy), u10 (ref)
                    local success, result = pcall(function() -- Line: 194
                        -- upvalues: MarketplaceService (ref), u36 (ref)
                        return MarketplaceService:GetProductInfoAsync(u36.DevProductId, Enum.InfoType.Product);
                    end);

                    if not (success and (result and result.PriceInRobux)) then
                        u10[u36.DevProductId] = nil;

                        return;
                    end;

                    u36.BasePrice = result.UserBasePriceInRobux or result.PriceInRobux;
                    u36.Price = result.PriceInRobux;
                    u38(result.PriceInRobux);
                end);
            end;

            ActivateButton(u35.Buy);
            u35.Buy.MouseButton1Click:Connect(function() -- Line: 356
                -- upvalues: Router (ref), buyCandy (ref), v (copy)
                Router.broadcastRouter("RunInterfaceSound", "UI Click");
                buyCandy(v);
            end);
            table.insert(p34, u35.Buy);
        end;
    end;
end;

local function samePaint(p39: string, p40: string) -- Line: 367
    local function squash(p41: string) -- Line: 368
        return string.gsub(string.lower(p41), "%s", "");
    end;

    return string.gsub(string.lower(p39), "%s", "") == string.gsub(string.lower(p40), "%s", "");
end;

local function getPrizeShown(p42: userdata) -- Line: 377
    -- upvalues: u2 (copy)
    local Icon = p42:FindFirstChild("Icon");

    if not (Icon and Icon:IsA("ImageLabel")) then
        return nil;
    end;

    local string_match_ret = string.match(Icon.Image, "%d+");

    if string_match_ret then
        return u2[string_match_ret];
    end;

    return nil;
end;

local function findSlice(p43: string) -- Line: 389
    -- upvalues: u11 (ref), u2 (copy)
    local v44 = {};

    for _, v in u11.GetSlices() do
        local Icon = v:FindFirstChild("Icon");
        local v45;

        if Icon and Icon:IsA("ImageLabel") then
            local string_match_ret = string.match(Icon.Image, "%d+");

            if string_match_ret then
                v45 = u2[string_match_ret];
            else
                v45 = nil;
            end;
        else
            v45 = nil;
        end;

        if v45 then
            local function _(p46: string) -- Line: 368
                return string.gsub(string.lower(p46), "%s", "");
            end;

            if string.gsub(string.lower(v45), "%s", "") == string.gsub(string.lower(p43), "%s", "") then
                table.insert(v44, v);
            end;
        end;
    end;

    if #v44 > 0 then
        return v44[math.random(1, #v44)];
    end;

    return nil;
end;

local function setSpinButtonBusy(p47: boolean) -- Line: 402
    -- upvalues: u8 (ref)
    local Title = u8.WheelPanel.Spin:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        Title.Text = p47 and "SPINNING..." or "SPIN";
    end;
end;

local function getWonItem(p48: table) -- Line: 412
    -- upvalues: DataController (copy), LocalPlayer (copy)
    local item = p48.item;

    if typeof(item) == "table" and (item.Name and item.Skin) then
        return item;
    end;

    local v49 = typeof(item) == "table" and item._id or p48.inventoryItemId;

    if v49 then
        for _, v in DataController.Get(LocalPlayer, "Inventory") or {} do
            if v._id == v49 then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function revealPrize(p50: table, p51: boolean) -- Line: 433
    -- upvalues: Router (copy), getWonItem (copy)
    Router.broadcastRouter("RunInterfaceSound", "New Item Reveal");

    if p51 then
        return;
    end;

    local v52 = getWonItem(p50);
    local v53;

    if v52 then
        v53 = `{v52.Skin} {v52.Name}`;
    else
        v53 = tostring(p50.paintId or "a prize");
    end;

    Router.broadcastRouter("CreateMenuNotification", "Success", (`You won {v53}!`));
end;

local function onSpinResult(u54) -- Line: 445
    -- upvalues: u13 (ref), u12 (ref), findSlice (copy), u11 (ref), u8 (ref), Router (copy), revealPrize (copy)
    if typeof(u54) ~= "table" then
        return;
    end;

    local v55 = u13;
    u13 = false;
    u12 = u12 + 1;

    if u54.success ~= true then
        u11.Stop();
        local Title = u8.WheelPanel.Spin:FindFirstChild("Title");

        if Title and Title:IsA("TextLabel") then
            Title.Text = "SPIN";
        end;

        local v56 = typeof(u54.message) ~= "string" and "Your spin is still being processed. Try again in a moment." or u54.message;
        Router.broadcastRouter("CreateMenuNotification", "Error", v56);

        return;
    end;

    local v57;

    if typeof(u54.paintId) == "string" then
        v57 = findSlice(u54.paintId);
    else
        v57 = nil;
    end;

    if v57 and v55 then
        u11.LandOn(v57, function() -- Line: 457
            -- upvalues: u8 (ref), u54 (copy), Router (ref)
            local Title = u8.WheelPanel.Spin:FindFirstChild("Title");

            if Title and Title:IsA("TextLabel") then
                Title.Text = "SPIN";
            end;

            Router.broadcastRouter("RunInterfaceSound", "New Item Reveal");
        end);

        return;
    end;

    u11.Stop();
    local Title = u8.WheelPanel.Spin:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        Title.Text = "SPIN";
    end;

    revealPrize(u54, false);
end;

local function requestSpin() -- Line: 477
    -- upvalues: u13 (ref), u11 (ref), DataController (copy), LocalPlayer (copy), CANDY_FIELD (copy), SPIN_CANDY_PRICE (copy), CommaNumber (copy), Router (copy), u12 (ref), u8 (ref), Remotes (copy)
    if u13 or u11.IsSpinning() then
        return;
    end;

    if (tonumber(DataController.Get(LocalPlayer, CANDY_FIELD)) or 0) < SPIN_CANDY_PRICE then
        local v58 = `You need {CommaNumber(SPIN_CANDY_PRICE)} candy to spin.`;
        Router.broadcastRouter("CreateMenuNotification", "Error", v58);

        return;
    end;

    u13 = true;
    u12 = u12 + 1;
    local u59 = u12;
    local Title = u8.WheelPanel.Spin:FindFirstChild("Title");

    if Title and Title:IsA("TextLabel") then
        Title.Text = "SPINNING...";
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    u11.Spin();
    Remotes.Halloween.Spin.Send();
    task.delay(20, function() -- Line: 495
        -- upvalues: u13 (ref), u12 (ref), u59 (copy), u11 (ref), u8 (ref), Router (ref)
        if u13 and u12 == u59 then
            u13 = false;
            u11.Stop();
            local Title2 = u8.WheelPanel.Spin:FindFirstChild("Title");

            if Title2 and Title2:IsA("TextLabel") then
                Title2.Text = "SPIN";
            end;

            Router.broadcastRouter("CreateMenuNotification", "Error", "Your spin is still being processed. Try again in a moment.");
        end;
    end);
end;

local function playZombies() -- Line: 509
    -- upvalues: Router (copy), IsSurvivalMode (copy), u15 (ref), Remotes (copy)
    Router.broadcastRouter("RunInterfaceSound", "UI Click");

    if IsSurvivalMode() then
        Router.broadcastRouter("CreateMenuNotification", "Error", "You are already playing Zombie Survival.");

        return;
    end;

    local os_clock_ret = os.clock();

    if os_clock_ret - u15 < 0.75 then
        return;
    end;

    u15 = os_clock_ret;
    Remotes.Modes.SelectGamemode.Send("Survival");
end;

local function limitSelectionTo(p60: table) -- Line: 528
    -- upvalues: u8 (ref)
    for _, descendant in u8:GetDescendants() do
        if descendant:IsA("GuiButton") and not table.find(p60, descendant) then
            descendant.Selectable = false;
        end;
    end;
end;

function u1.ObserveRunning(p61: function) -- Line: 540
    -- upvalues: TimerController (copy)
    TimerController.ObserveRunning("Halloween2026EventTimer", p61);
end;

function u1.Open(p62: userdata?) -- Line: 548
    -- upvalues: u6 (ref), u5 (ref), MenuState (copy), Top (copy)
    if not u6 then
        return;
    end;

    u5 = p62;
    MenuState.HoldNavigationSelection(nil);
    Top.openFrame("HalloweenEvent");
end;

function u1.InspectPrize(p63: string) -- Line: 562
    -- upvalues: Router (copy)
    local string_match_ret, v64 = string.match(p63, "^(.-) | (.+)$");

    if not (string_match_ret and v64) then
        return;
    end;

    Router.broadcastRouter("RunInterfaceSound", "UI Click");
    Router.broadcastRouter("WeaponInspect", string_match_ret, v64, 0, nil, nil, nil, nil, string_match_ret == "Charm" and "Charm" or nil, 1, nil, 1, nil, true, true);
end;

function u1.BindCandyLabel(u65: userdata) -- Line: 598
    -- upvalues: Spring (copy), RunServiceController (copy), CommaNumber (copy), DataController (copy), LocalPlayer (copy), CANDY_FIELD (copy), GuiService (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local u66 = Spring.new(1, 8, 0);
    local u67 = RunServiceController.CreateBindingName("UI.HalloweenEvent.CandyCount");
    local u68 = nil;
    local u69 = false;
    local u70 = true;
    local CandyPop = u65:FindFirstChild("CandyPop");

    if not CandyPop then
        CandyPop = Instance.new("UIScale");
        CandyPop.Name = "CandyPop";
        CandyPop.Parent = u65;
    end;

    local function show(p71: number) -- Line: 613
        -- upvalues: u65 (copy), CommaNumber (ref)
        u65.Text = CommaNumber((math.round(p71)));
    end;

    local function step(p72: number) -- Line: 617
        -- upvalues: u66 (copy), u70 (ref), u65 (copy), CommaNumber (ref), u68 (ref)
        local Goal = u66:getGoal();
        local v73 = u66:update(p72);
        local v74;

        if u70 then
            v74 = math.min(v73, Goal);
        else
            v74 = math.max(v73, Goal);
        end;

        u65.Text = CommaNumber((math.round(v74)));

        if math.abs(Goal - v74) < 0.5 then
            local Velocity = u66:getVelocity();

            if math.abs(Velocity) < 1 then
                u66:reset(Goal);
                u65.Text = CommaNumber((math.round(Goal)));

                if u68 then
                    u68:Disconnect();
                    u68 = nil;
                end;
            end;
        end;
    end;

    DataController.CreateListener(LocalPlayer, CANDY_FIELD, function(p75) -- Line: 634
        -- upvalues: u69 (ref), u66 (copy), u65 (copy), CommaNumber (ref), GuiService (ref), CandyPop (copy), TweenService (ref), TweenInfo_new_ret (ref), u70 (ref), u68 (ref), RunServiceController (ref), u67 (copy), step (copy)
        local v76 = tonumber(p75) or 0;
        local math_floor_ret = math.floor(v76);
        local math_max_ret = math.max(0, math_floor_ret);

        if not u69 then
            u69 = true;
            u66:reset(math_max_ret);
            u65.Text = CommaNumber((math.round(math_max_ret)));

            return nil;
        end;

        if u66:getGoal() < math_max_ret and not GuiService.ReducedMotionEnabled then
            CandyPop.Scale = 1.18;
            TweenService:Create(CandyPop, TweenInfo_new_ret, {
                Scale = 1
            }):Play();
        end;

        u70 = u66:getPosition() <= math_max_ret;
        u66:setGoal(math_max_ret);

        if not u68 then
            u68 = RunServiceController.BindToHeartbeat(u67, step);
        end;

        return nil;
    end);
end;

function u1.Initialize(p77: userdata, u78: any) -- Line: 661
    -- upvalues: u7 (ref), u8 (ref), u11 (ref), AnimateHalloweenWheel (copy), canSellPaidRandomItems (copy), AnimateHalloweenInfoPanel (copy), CommaNumber (copy), SPIN_CANDY_PRICE (copy), ActivateButton (copy), requestSpin (copy), Remotes (copy), onSpinResult (copy), u1 (copy), bindCandyOffers (copy), u2 (copy), playZombies (copy), CloseButtonRegistry (copy), close (copy), limitSelectionTo (copy), u6 (ref), Top (copy), u5 (ref), GamepadNavigation (copy), RunServiceController (copy), GuiShown (copy), u9 (ref), TimerController (copy), FormatDuration (copy)
    u7 = p77;
    u8 = u78;
    u11 = AnimateHalloweenWheel(u78.WheelPanel.Wheel, false, true);
    task.spawn(canSellPaidRandomItems);
    AnimateHalloweenInfoPanel(u78.InfoPanel);
    local v79 = { u78.WheelPanel.Spin, u78.Title.Close };
    u78.WheelPanel.Cost.Text.Text = `{CommaNumber(SPIN_CANDY_PRICE)} PER SPIN`;
    ActivateButton(u78.WheelPanel.Spin);
    u78.WheelPanel.Spin.MouseButton1Click:Connect(requestSpin);
    Remotes.Halloween.SpinResult.Listen(onSpinResult);
    u1.BindCandyLabel(u78.InfoPanel.CandyCounter.Amount);
    bindCandyOffers(v79);
    local Rewards = u78.InfoPanel:FindFirstChild("Rewards");

    if Rewards then
        for _, child in Rewards:GetChildren() do
            local Icon = child:FindFirstChild("Icon");
            local u80;

            if Icon and Icon:IsA("ImageLabel") then
                local string_match_ret = string.match(Icon.Image, "%d+");

                if string_match_ret then
                    u80 = u2[string_match_ret];
                else
                    u80 = nil;
                end;
            else
                u80 = nil;
            end;

            if u80 and child:IsA("GuiButton") then
                child.Activated:Connect(function() -- Line: 685
                    -- upvalues: u1 (ref), u80 (copy)
                    u1.InspectPrize(u80);
                end);
                table.insert(v79, child);
            end;
        end;
    end;

    local JoinServer = u78.InfoPanel:FindFirstChild("JoinServer");

    if JoinServer and JoinServer:IsA("GuiButton") then
        ActivateButton(JoinServer);
        JoinServer.MouseButton1Click:Connect(playZombies);
        table.insert(v79, JoinServer);
    end;

    ActivateButton(u78.Title.Close);
    CloseButtonRegistry.Add(u78, u78.Title.Close, close);
    limitSelectionTo(v79);
    u1.ObserveRunning(function(p81: boolean) -- Line: 707
        -- upvalues: u6 (ref), u78 (copy), Top (ref), u5 (ref), GamepadNavigation (ref)
        u6 = p81;

        if not p81 and u78.Visible then
            Top.openFrame("Dashboard");

            if u5 then
                GamepadNavigation.Focus(u5);
                u5 = nil;
            end;
        end;
    end);
    local TextLabel = u78.Timer.TextLabel;
    local u82 = RunServiceController.CreateBindingName("UI.HalloweenEvent.Timer");
    local u83 = nil;
    GuiShown.Observe(u78, function(p84: boolean) -- Line: 718
        -- upvalues: u9 (ref), u83 (ref), GamepadNavigation (ref), u78 (copy), TextLabel (copy), TimerController (ref), FormatDuration (ref), RunServiceController (ref), u82 (copy)
        if not p84 then
            if u9 then
                u9:Destroy();
                u9 = nil;
            end;

            if u83 then
                u83:Disconnect();
                u83 = nil;
            end;

            return;
        end;

        GamepadNavigation.Focus(u78.WheelPanel.Spin);
        local SecondsRemaining = TimerController.GetSecondsRemaining("Halloween2026EventTimer");
        TextLabel.Text = not SecondsRemaining and "--:--:--" or FormatDuration(SecondsRemaining, "IfNeeded");
        local u85 = 0;
        u83 = RunServiceController.BindToHeartbeat(u82, function(p86: number) -- Line: 732
            -- upvalues: u85 (ref), TextLabel (ref), TimerController (ref), FormatDuration (ref)
            u85 = u85 + p86;

            if u85 >= 1 then
                u85 = u85 % 1;
                local SecondsRemaining2 = TimerController.GetSecondsRemaining("Halloween2026EventTimer");
                TextLabel.Text = not SecondsRemaining2 and "--:--:--" or FormatDuration(SecondsRemaining2, "IfNeeded");
            end;
        end);
    end);
end;

return u1;