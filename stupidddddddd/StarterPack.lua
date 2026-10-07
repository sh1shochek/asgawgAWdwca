-- ReplicatedStorage.Interface.Screens.Menu.Store.StarterPack
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Store.StarterPack
-- Decompile time: 3.73 ms

local u0 = {}
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local CommaNumber = require(ReplicatedStorage.Components.Common.CommaNumber)
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local DevProducts = require(ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts)
local NormalizeUnixTimestamp = require(script.Parent.Timestamps).NormalizeUnixTimestamp
local LocalPlayer = Players.LocalPlayer
local u64 = nil
local u65 = nil
local u66 = nil
local u67 = nil
local u68 = nil
local u69 = nil
local u70 = nil
local u71 = false
local u72 = 0
local u73 = false
local u74 = false
local u75 = nil

local function NormalizeOpenShopTime(a1) -- Line: 62 -- upvalues: NormalizeUnixTimestamp (val)
    local v1
    if (if typeof(a1) ~= "number" then if typeof(a1) ~= "string" then nil else tonumber(a1) else a1) == nil then
        return nil
    end
    return (NormalizeUnixTimestamp(v1))
end

local function GetStarterPackRemainingSeconds(a1, a2) -- Line: 72
    -- upvalues: NormalizeUnixTimestamp (val)
    local v1
    local v2 = if typeof(a1) ~= "number" then if typeof(a1) ~= "string" then nil else tonumber(a1) else a1
    if (if v2 ~= nil then NormalizeUnixTimestamp(v2) else nil) == nil then
        return 0
    end
    return (math.max(0, (math.floor(86400 - (math.max(0, (a2 or workspace:GetServerTimeNow()) - v1))))))
end

local function PlayerOwnsStarterPack() -- Line: 86 -- upvalues: DataController (val), LocalPlayer (val)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return false
    end
    local v1 = DataController.Get(LocalPlayer, "Gamepasses")
    local v2 = false
    if typeof(v1) == "table" then
        v2 = table.find(v1, "Credits StarterPack") ~= nil
    end
    return v2
end

local function GetStarterPackState(a1) -- Line: 103
    -- upvalues: DataController (val), LocalPlayer (val), NormalizeUnixTimestamp (val)
    local v1, v2
    if not DataController.IsDataLoaded(LocalPlayer) then
        return {IsDataLoaded = false, OwnsStarterPack = false, RemainingSeconds = 0}
    end
    local v3 = DataController.Get(LocalPlayer, "Statistics.OpenShopTime")
    local v4 = if typeof(v3) ~= "number" then if typeof(v3) ~= "string" then nil else tonumber(v3) else v3
    v3 = {
        IsDataLoaded = true,
        OpenShopTime = if v4 ~= nil then NormalizeUnixTimestamp(v4) else nil,
    }
    if DataController.IsDataLoaded(LocalPlayer) then
        v2 = DataController.Get(LocalPlayer, "Gamepasses")
        v4 = false
        if typeof(v2) == "table" then
            v4 = table.find(v2, "Credits StarterPack") ~= nil
        end
    else
        v4 = false
    end
    v3.OwnsStarterPack = v4
    local v5 = if typeof(v1) ~= "number" then if typeof(v1) ~= "string" then nil else tonumber(v1) else v1
    v2 = if v5 ~= nil then NormalizeUnixTimestamp(v5) else nil
    v3.RemainingSeconds = if v2 ~= nil then math.max(0, (math.floor(86400 - (math.max(0, (a1 or workspace:GetServerTimeNow()) - v2))))) else 0
    return v3
end

local function RefreshStarterPackState(a1) -- Line: 124
    -- upvalues: Profiler (val), GetStarterPackState (val), u70 (ref), FormatDuration (val), u67 (ref), u68 (ref)
    Profiler.mark("UI.Store.RefreshStarterPackState")
    local v1 = GetStarterPackState(a1)
    local v2 = false
    if 0 < v1.RemainingSeconds then
        v2 = not v1.OwnsStarterPack
    end
    if u70 then
        u70.Text = if not v2 then "NEW!" else FormatDuration(v1.RemainingSeconds, "Never")
    end
    if v1.OwnsStarterPack then
        u67.Visible = false
        return
    end
    u67.Visible = v2
    u68.Text = v2 and FormatDuration(v1.RemainingSeconds, "Never") or "00:00:00"
end

function u0.IsAvailable() -- Line: 147 -- upvalues: GetStarterPackState (val)
    local v1 = GetStarterPackState()
    if v1.IsDataLoaded and not v1.OwnsStarterPack then
        local v2 = true
        if v1.OpenShopTime ~= nil then
            v2 = 0 < v1.RemainingSeconds
        end
        return v2
    end
    return false
end

local function setupStarterPackFrame() -- Line: 185
    -- upvalues: u73 (ref), u67 (ref), ActivateButton (val), u69 (ref), DevProducts (val), u64 (ref), CommaNumber (val)
    -- upvalues: u74 (ref), u0 (val), RefreshStarterPackState (val), u66 (ref), u75 (ref), DataController (val)
    -- upvalues: LocalPlayer (val), u65 (ref), MarketplaceService (val), Router (val)
    if u73 then
        return
    end
    u73 = true
    u67.Visible = false
    ActivateButton(u69)
    local v1 = DevProducts["Credits Starter Pack"]
    if v1 then
        u64(v1, function(a1) -- Line: 198 -- upvalues: u69 (upval), CommaNumber (upval)
            u69.Container.Title.Text = ("%* %*"):format(utf8.char(57346), (CommaNumber(a1)))
        end)
    end
    u69.MouseButton1Click:Connect(function() -- Line: 203
        -- upvalues: u74 (upval), u0 (upval), RefreshStarterPackState (upval), u66 (upval), DevProducts (upval)
        -- upvalues: u75 (upval), DataController (upval), LocalPlayer (upval), u65 (upval), MarketplaceService (upval)
        -- upvalues: Router (upval)
        if not u74 and u0.IsAvailable() then
            if u66() then
                local v1 = DevProducts["Credits Starter Pack"]
                if not v1 then
                    warn("[Store] Missing dev product configuration for Credits Starter Pack")
                    return
                end
                u74 = true
                u75 = v1.DevProductId
                local v2 = DataController.Get(LocalPlayer, "TradeTokens") or 0
                if not v1.Price or not (v1.Price <= v2) then
                    MarketplaceService:PromptProductPurchase(LocalPlayer, v1.DevProductId)
                    task.delay(1, function() -- Line: 225 -- upvalues: u74 (upval)
                        u74 = false
                    end)
                else
                    u65("Credits Starter Pack", v1)
                    u74 = false
                end
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
            end
            return
        end
        RefreshStarterPackState()
    end)
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(a1, a2) -- Line: 233 -- upvalues: u75 (upval), LocalPlayer (upval), u74 (upval)
        if a2 == u75 and a1 == LocalPlayer.UserId then
            u74 = false
        end
    end)
end

function u0.Bind(a1, a2) -- Line: 243
    -- upvalues: u67 (ref), u68 (ref), u69 (ref), u70 (ref)
    u67 = a1.Tabs.Container.Featured.Container.StarterPack
    u68 = u67.Pack.Container.Top.Title.Top.Timer
    u69 = u67.Pack.Container.Bottom.Purchase
    u70 = a2.Menu.Top.Bottom.Buttons.Store.Timer.Timer
end

function u0.Setup(a1, a2, a3) -- Line: 250
    -- upvalues: u64 (ref), u65 (ref), u66 (ref), setupStarterPackFrame (val)
    u64 = a1
    u65 = a2
    u66 = a3
    setupStarterPackFrame()
end

function u0.OnOpenShopTimeChanged(a1) -- Line: 259
    -- upvalues: NormalizeUnixTimestamp (val), u71 (ref), RefreshStarterPackState (val)
    local v1 = if typeof(a1) ~= "number" then if typeof(a1) ~= "string" then nil else tonumber(a1) else a1
    if (if v1 ~= nil then NormalizeUnixTimestamp(v1) else nil) ~= nil then
        u71 = true
    end
    RefreshStarterPackState()
end

u0.WINDOW_SECONDS = 86400
u0.GetState = GetStarterPackState
u0.Refresh = RefreshStarterPackState

function u0.HandleStoreOpened() -- Line: 159
    -- upvalues: Profiler (val), GetStarterPackState (val), RefreshStarterPackState (val), u71 (ref), u72 (ref)
    -- upvalues: Remotes (val)
    Profiler.mark("UI.Store.HandleStoreOpened")
    local v1 = GetStarterPackState()
    if not v1.IsDataLoaded then
        RefreshStarterPackState()
        return
    end
    if v1.OpenShopTime ~= nil then
        u71 = true
        RefreshStarterPackState()
        return
    end
    local v2 = tick()
    if not u71 or 5 <= v2 - u72 then
        u71 = true
        u72 = v2
        Remotes.Store.OpenedShop.Send({})
    end
    RefreshStarterPackState()
end

return u0