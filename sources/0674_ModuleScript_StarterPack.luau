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
local u9 = false;
local u10 = 0;
local u11 = false;
local u12 = false;
local u13 = nil;

local function NormalizeOpenShopTime(p14) -- Line: 62
    -- upvalues: NormalizeUnixTimestamp (copy)
    if typeof(p14) ~= "number" then
        if typeof(p14) == "string" then
            p14 = tonumber(p14);
        else
            p14 = nil;
        end;
    end;

    if p14 == nil then
        return nil;
    end;

    return NormalizeUnixTimestamp(p14);
end;

local function GetStarterPackRemainingSeconds(p15: any, p16: number?) -- Line: 72
    -- upvalues: NormalizeUnixTimestamp (copy)
    if typeof(p15) ~= "number" then
        if typeof(p15) == "string" then
            p15 = tonumber(p15);
        else
            p15 = nil;
        end;
    end;

    local v17;

    if p15 == nil then
        v17 = nil;
    else
        v17 = NormalizeUnixTimestamp(p15);
    end;

    if v17 == nil then
        return 0;
    end;

    local v18 = p16 or workspace:GetServerTimeNow();
    local v19 = 86400 - math.max(0, v18 - v17);
    local math_floor_ret = math.floor(v19);

    return math.max(0, math_floor_ret);
end;

local function PlayerOwnsStarterPack() -- Line: 86
    -- upvalues: DataController (copy), LocalPlayer (copy)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return false;
    end;

    local v20 = DataController.Get(LocalPlayer, "Gamepasses");
    local v21;

    if typeof(v20) == "table" then
        v21 = table.find(v20, "Credits StarterPack") ~= nil;
    else
        v21 = false;
    end;

    return v21;
end;

local function GetStarterPackState(p22: number?) -- Line: 103
    -- upvalues: DataController (copy), LocalPlayer (copy), NormalizeUnixTimestamp (copy)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return {
            IsDataLoaded = false,
            OpenShopTime = nil,
            OwnsStarterPack = false,
            RemainingSeconds = 0
        };
    end;

    local v23 = DataController.Get(LocalPlayer, "Statistics.OpenShopTime");

    if typeof(v23) ~= "number" then
        if typeof(v23) == "string" then
            v23 = tonumber(v23);
        else
            v23 = nil;
        end;
    end;

    local v24;

    if v23 == nil then
        v24 = nil;
    else
        v24 = NormalizeUnixTimestamp(v23);
    end;

    local v25 = {
        IsDataLoaded = true,
        OpenShopTime = v24
    };
    local v26;

    if DataController.IsDataLoaded(LocalPlayer) then
        local v27 = DataController.Get(LocalPlayer, "Gamepasses");

        if typeof(v27) == "table" then
            v26 = table.find(v27, "Credits StarterPack") ~= nil;
        else
            v26 = false;
        end;
    else
        v26 = false;
    end;

    v25.OwnsStarterPack = v26;

    if typeof(v24) ~= "number" then
        if typeof(v24) == "string" then
            v24 = tonumber(v24);
        else
            v24 = nil;
        end;
    end;

    local v28;

    if v24 == nil then
        v28 = nil;
    else
        v28 = NormalizeUnixTimestamp(v24);
    end;

    local v29;

    if v28 == nil then
        v29 = 0;
    else
        local v30 = p22 or workspace:GetServerTimeNow();
        local v31 = 86400 - math.max(0, v30 - v28);
        local math_floor_ret = math.floor(v31);
        v29 = math.max(0, math_floor_ret);
    end;

    v25.RemainingSeconds = v29;

    return v25;
end;

local function RefreshStarterPackState(p32: number?) -- Line: 124
    -- upvalues: Profiler (copy), GetStarterPackState (copy), u8 (ref), FormatDuration (copy), u5 (ref), u6 (ref)
    Profiler.mark("UI.Store.RefreshStarterPackState");
    local v33 = GetStarterPackState(p32);
    local v34;

    if v33.RemainingSeconds > 0 then
        v34 = not v33.OwnsStarterPack;
    else
        v34 = false;
    end;

    if u8 then
        u8.Text = not v34 and "NEW!" or FormatDuration(v33.RemainingSeconds, "Never");
    end;

    if v33.OwnsStarterPack then
        u5.Visible = false;

        return;
    end;

    u5.Visible = v34;
    u6.Text = v34 and FormatDuration(v33.RemainingSeconds, "Never") or "00:00:00";
end;

function u1.IsAvailable() -- Line: 147
    -- upvalues: GetStarterPackState (copy)
    local v35 = GetStarterPackState();

    if v35.IsDataLoaded and not v35.OwnsStarterPack then
        return v35.OpenShopTime == nil and true or v35.RemainingSeconds > 0;
    end;

    return false;
end;

local function HandleStoreOpened() -- Line: 159
    -- upvalues: Profiler (copy), GetStarterPackState (copy), RefreshStarterPackState (copy), u9 (ref), u10 (ref), Remotes (copy)
    Profiler.mark("UI.Store.HandleStoreOpened");
    local v36 = GetStarterPackState();

    if not v36.IsDataLoaded then
        RefreshStarterPackState();

        return;
    end;

    if v36.OpenShopTime ~= nil then
        u9 = true;
        RefreshStarterPackState();

        return;
    end;

    local v37 = tick();

    if not u9 or v37 - u10 >= 5 then
        u9 = true;
        u10 = v37;
        Remotes.Store.OpenedShop.Send({});
    end;

    RefreshStarterPackState();
end;

local function setupStarterPackFrame() -- Line: 185
    -- upvalues: u11 (ref), u5 (ref), ActivateButton (copy), u7 (ref), DevProducts (copy), u2 (ref), CommaNumber (copy), u12 (ref), u1 (copy), RefreshStarterPackState (copy), u4 (ref), u13 (ref), DataController (copy), LocalPlayer (copy), u3 (ref), MarketplaceService (copy), Router (copy)
    if u11 then
        return;
    end;

    u11 = true;
    u5.Visible = false;
    ActivateButton(u7);
    local v38 = DevProducts["Credits Starter Pack"];

    if v38 then
        u2(v38, function(p39) -- Line: 198
            -- upvalues: u7 (ref), CommaNumber (ref)
            u7.Container.Title.Text = `{utf8.char(57346)} {CommaNumber(p39)}`;
        end);
    end;

    u7.MouseButton1Click:Connect(function() -- Line: 203
        -- upvalues: u12 (ref), u1 (ref), RefreshStarterPackState (ref), u4 (ref), DevProducts (ref), u13 (ref), DataController (ref), LocalPlayer (ref), u3 (ref), MarketplaceService (ref), Router (ref)
        if u12 or not u1.IsAvailable() then
            RefreshStarterPackState();

            return;
        end;

        if u4() then
            local v40 = DevProducts["Credits Starter Pack"];

            if not v40 then
                warn("[Store] Missing dev product configuration for Credits Starter Pack");

                return;
            end;

            u12 = true;
            u13 = v40.DevProductId;
            local v41 = DataController.Get(LocalPlayer, "TradeTokens") or 0;

            if v40.Price and v40.Price <= v41 then
                u3("Credits Starter Pack", v40);
                u12 = false;
            else
                MarketplaceService:PromptProductPurchase(LocalPlayer, v40.DevProductId);
                task.delay(1, function() -- Line: 225
                    -- upvalues: u12 (ref)
                    u12 = false;
                end);
            end;

            Router.broadcastRouter("RunInterfaceSound", "UI Click");
        end;
    end);
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(p42, p43) -- Line: 233
        -- upvalues: u13 (ref), LocalPlayer (ref), u12 (ref)
        if p43 == u13 and p42 == LocalPlayer.UserId then
            u12 = false;
        end;
    end);
end;

function u1.Bind(p44: userdata, p45: userdata) -- Line: 243
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    u5 = p44.Tabs.Container.Featured.Container.StarterPack;
    u6 = u5.Pack.Container.Top.Title.Top.Timer;
    u7 = u5.Pack.Container.Bottom.Purchase;
    u8 = p45.Menu.Top.Bottom.Buttons.Store.Timer.Timer;
end;

function u1.Setup(p46: function, p47: function, p48: function) -- Line: 250
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), setupStarterPackFrame (copy)
    u2 = p46;
    u3 = p47;
    u4 = p48;
    setupStarterPackFrame();
end;

function u1.OnOpenShopTimeChanged(p49) -- Line: 259
    -- upvalues: NormalizeUnixTimestamp (copy), u9 (ref), RefreshStarterPackState (copy)
    if typeof(p49) ~= "number" then
        if typeof(p49) == "string" then
            p49 = tonumber(p49);
        else
            p49 = nil;
        end;
    end;

    local v50;

    if p49 == nil then
        v50 = nil;
    else
        v50 = NormalizeUnixTimestamp(p49);
    end;

    if v50 ~= nil then
        u9 = true;
    end;

    RefreshStarterPackState();
end;

u1.WINDOW_SECONDS = 86400;
u1.GetState = GetStarterPackState;
u1.Refresh = RefreshStarterPackState;
u1.HandleStoreOpened = HandleStoreOpened;

return u1;