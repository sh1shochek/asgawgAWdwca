-- ReplicatedStorage.Interface.Screens.Menu.Store.StarterPack
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Store.StarterPack
-- Decompile time: 9.72 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local DataController = require(ReplicatedStorage.Controllers.DataController);
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber);
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration);
local Profiler = require(ReplicatedStorage.Shared.Profiler);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts);
local NormalizeUnixTimestamp = require(script.Parent.Timestamps).NormalizeUnixTimestamp;
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = false;
local u11 = 0;
local u12 = false;
local u13 = false;
local u14 = nil;

local function NormalizeOpenShopTime(p15) -- Line: 63
    -- upvalues: NormalizeUnixTimestamp (copy)
    if typeof(p15) ~= "number" then
        if typeof(p15) == "string" then
            p15 = tonumber(p15);
        else
            p15 = nil;
        end;
    end;

    if p15 == nil then
        return nil;
    end;

    return NormalizeUnixTimestamp(p15);
end;

local function GetStarterPackRemainingSeconds(p16: any, p17: number?) -- Line: 73
    -- upvalues: NormalizeUnixTimestamp (copy)
    if typeof(p16) ~= "number" then
        if typeof(p16) == "string" then
            p16 = tonumber(p16);
        else
            p16 = nil;
        end;
    end;

    local v18;

    if p16 == nil then
        v18 = nil;
    else
        v18 = NormalizeUnixTimestamp(p16);
    end;

    if v18 == nil then
        return 0;
    end;

    local v19 = p17 or workspace:GetServerTimeNow();
    local v20 = 86400 - math.max(0, v19 - v18);
    local math_floor_ret = math.floor(v20);

    return math.max(0, math_floor_ret);
end;

local function PlayerOwnsStarterPack() -- Line: 87
    -- upvalues: DataController (copy), LocalPlayer (copy)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return false;
    end;

    local v21 = DataController.Get(LocalPlayer, "Gamepasses");
    local v22;

    if typeof(v21) == "table" then
        v22 = table.find(v21, "Credits StarterPack") ~= nil;
    else
        v22 = false;
    end;

    return v22;
end;

local function GetStarterPackState(p23: number?) -- Line: 104
    -- upvalues: DataController (copy), LocalPlayer (copy), NormalizeUnixTimestamp (copy)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return {
            IsDataLoaded = false,
            OpenShopTime = nil,
            OwnsStarterPack = false,
            RemainingSeconds = 0
        };
    end;

    local v24 = DataController.Get(LocalPlayer, "Statistics.OpenShopTime");

    if typeof(v24) ~= "number" then
        if typeof(v24) == "string" then
            v24 = tonumber(v24);
        else
            v24 = nil;
        end;
    end;

    local v25;

    if v24 == nil then
        v25 = nil;
    else
        v25 = NormalizeUnixTimestamp(v24);
    end;

    local v26 = {
        IsDataLoaded = true,
        OpenShopTime = v25
    };
    local v27;

    if DataController.IsDataLoaded(LocalPlayer) then
        local v28 = DataController.Get(LocalPlayer, "Gamepasses");

        if typeof(v28) == "table" then
            v27 = table.find(v28, "Credits StarterPack") ~= nil;
        else
            v27 = false;
        end;
    else
        v27 = false;
    end;

    v26.OwnsStarterPack = v27;

    if typeof(v25) ~= "number" then
        if typeof(v25) == "string" then
            v25 = tonumber(v25);
        else
            v25 = nil;
        end;
    end;

    local v29;

    if v25 == nil then
        v29 = nil;
    else
        v29 = NormalizeUnixTimestamp(v25);
    end;

    local v30;

    if v29 == nil then
        v30 = 0;
    else
        local v31 = p23 or workspace:GetServerTimeNow();
        local v32 = 86400 - math.max(0, v31 - v29);
        local math_floor_ret = math.floor(v32);
        v30 = math.max(0, math_floor_ret);
    end;

    v26.RemainingSeconds = v30;

    return v26;
end;

local function RefreshStarterPackState(p33: number?) -- Line: 125
    -- upvalues: Profiler (copy), GetStarterPackState (copy), u9 (ref), FormatDuration (copy), u5 (ref), u6 (ref)
    Profiler.mark("UI.Store.RefreshStarterPackState");
    local v34 = GetStarterPackState(p33);
    local v35;

    if v34.RemainingSeconds > 0 then
        v35 = not v34.OwnsStarterPack;
    else
        v35 = false;
    end;

    if u9 then
        u9.Text = not v35 and "NEW!" or FormatDuration(v34.RemainingSeconds, "Never");
    end;

    u5.Visible = v35;
    u6.Text = v35 and FormatDuration(v34.RemainingSeconds, "Never") or "00:00:00";
end;

function u1.IsAvailable() -- Line: 140
    -- upvalues: GetStarterPackState (copy)
    local v36 = GetStarterPackState();

    if v36.IsDataLoaded and not v36.OwnsStarterPack then
        return v36.OpenShopTime == nil and true or v36.RemainingSeconds > 0;
    end;

    return false;
end;

function u1.IsShown() -- Line: 153
    -- upvalues: u1 (copy)
    return u1.IsAvailable();
end;

local function HandleStoreOpened() -- Line: 159
    -- upvalues: Profiler (copy), GetStarterPackState (copy), RefreshStarterPackState (copy), u10 (ref), u11 (ref), Remotes (copy)
    Profiler.mark("UI.Store.HandleStoreOpened");
    local v37 = GetStarterPackState();

    if not v37.IsDataLoaded then
        RefreshStarterPackState();

        return;
    end;

    if v37.OpenShopTime ~= nil then
        u10 = true;
        RefreshStarterPackState();

        return;
    end;

    local v38 = tick();

    if not u10 or v38 - u11 >= 5 then
        u10 = true;
        u11 = v38;
        Remotes.Store.OpenedShop.Send({});
    end;

    RefreshStarterPackState();
end;

local function notifyError(p39: string) -- Line: 185
    -- upvalues: Router (copy)
    Router.broadcastRouter("CreateMenuNotification", "Error", p39);
end;

function u1.PromptPurchase() -- Line: 192
    -- upvalues: u13 (ref), u1 (copy), RefreshStarterPackState (copy), DataController (copy), LocalPlayer (copy), Router (copy), u4 (ref), DevProducts (copy), u14 (ref), u3 (ref), MarketplaceService (copy)
    if u13 then
        return;
    end;

    if not u1.IsAvailable() then
        RefreshStarterPackState();
        local v40;

        if DataController.IsDataLoaded(LocalPlayer) then
            local v41 = DataController.Get(LocalPlayer, "Gamepasses");

            if typeof(v41) == "table" then
                v40 = table.find(v41, "Credits StarterPack") ~= nil;
            else
                v40 = false;
            end;
        else
            v40 = false;
        end;

        Router.broadcastRouter("CreateMenuNotification", "Error", v40 and "You already own the Starter Pack." or "The Starter Pack offer has expired.");

        return;
    end;

    if not u4() then
        Router.broadcastRouter("CreateMenuNotification", "Error", "Paid random items are not allowed in your region.");

        return;
    end;

    local v42 = DevProducts["Credits Starter Pack"];

    if not v42 then
        warn("[Store] Missing dev product configuration for Credits Starter Pack");

        return;
    end;

    u13 = true;
    u14 = v42.DevProductId;
    local v43 = DataController.Get(LocalPlayer, "TradeTokens") or 0;

    if v42.Price and v42.Price <= v43 then
        u3("Credits Starter Pack", v42);
        u13 = false;

        return;
    end;

    MarketplaceService:PromptProductPurchase(LocalPlayer, v42.DevProductId);
    task.delay(1, function() -- Line: 226
        -- upvalues: u13 (ref)
        u13 = false;
    end);
end;

local function setupStarterPackFrame() -- Line: 234
    -- upvalues: u12 (ref), u5 (ref), ActivateButton (copy), u7 (ref), u8 (ref), DevProducts (copy), u2 (ref), CommaNumber (copy), u1 (copy), Router (copy), MarketplaceService (copy), u14 (ref), LocalPlayer (copy), u13 (ref)
    if u12 then
        return;
    end;

    u12 = true;
    u5.Visible = false;
    ActivateButton(u7);
    ActivateButton(u8);
    local v44 = DevProducts["Credits Starter Pack"];

    if v44 then
        u2(v44, function(p45) -- Line: 248
            -- upvalues: u7 (ref), CommaNumber (ref)
            u7.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(p45)}`;
        end);
    end;

    u7.MouseButton1Click:Connect(u1.PromptPurchase);
    u8.MouseButton1Click:Connect(function() -- Line: 255
        -- upvalues: Router (ref)
        Router.broadcastRouter("CreateMenuNotification", "Error", "The Starter Pack can\'t be gifted.");
    end);
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p46, p47) -- Line: 259
        -- upvalues: u14 (ref), LocalPlayer (ref), u13 (ref)
        if p47 == u14 and p46 == LocalPlayer.UserId then
            u13 = false;
        end;
    end);
end;

function u1.Bind(p48: userdata, p49: userdata) -- Line: 269
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref)
    u5 = p48.Tabs.Container.Featured.Container.StarterPack;
    u6 = u5.Pack.Container.Top.Title.Top.Timer;
    u7 = u5.Pack.Container.Bottom.Purchase;
    u8 = u5.Pack.Container.Bottom.Gift;
    u9 = p49.Menu.Top.Bottom.Buttons.Store.Timer.Timer;
end;

function u1.Setup(p50: function, p51: function, p52: function) -- Line: 277
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), setupStarterPackFrame (copy)
    u2 = p50;
    u3 = p51;
    u4 = p52;
    setupStarterPackFrame();
end;

function u1.OnOpenShopTimeChanged(p53) -- Line: 286
    -- upvalues: NormalizeUnixTimestamp (copy), u10 (ref), RefreshStarterPackState (copy)
    if typeof(p53) ~= "number" then
        if typeof(p53) == "string" then
            p53 = tonumber(p53);
        else
            p53 = nil;
        end;
    end;

    local v54;

    if p53 == nil then
        v54 = nil;
    else
        v54 = NormalizeUnixTimestamp(p53);
    end;

    if v54 ~= nil then
        u10 = true;
    end;

    RefreshStarterPackState();
end;

u1.WINDOW_SECONDS = 86400;
u1.GetState = GetStarterPackState;
u1.Refresh = RefreshStarterPackState;
u1.HandleStoreOpened = HandleStoreOpened;

return u1;