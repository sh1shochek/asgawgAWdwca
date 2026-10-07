-- ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Monetization.DevProducts
-- Decompile time: 1.82 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Database.Custom.Types)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Router = require(ReplicatedStorage.Database.Security.Router)
local u27 = RunService:IsServer()

local function RoutedPurchase(a1, ...) -- Line: 30 -- upvalues: u27 (val), Router (val) -- types: a1: string
    local u3 = table.pack(...)
    return function(a1_2, a2) -- Line: 32 -- upvalues: u27 (upval), Router (upval), a1 (val), u3 (val) -- types: a1_2: userdata
        assert(u27, "This function should only be called on the server.")
        return Router.broadcastRouter(a1, a1_2, table.unpack(u3, 1, u3.n))
    end
end

local function ReceiptPurchase(a1, ...) -- Line: 39 -- upvalues: u27 (val), Router (val) -- types: a1: string
    local u3 = table.pack(...)
    return function(a1_2, a2) -- Line: 41 -- upvalues: u27 (upval), Router (upval), a1 (val), u3 (val) -- types: a1_2: userdata
        assert(u27, "This function should only be called on the server.")
        return Router.broadcastRouter(a1, a1_2, a2, table.unpack(u3, 1, u3.n))
    end
end

local function DisabledPurchase(a1, a2) -- Line: 48 -- upvalues: u27 (val) -- types: a1: userdata
    assert(u27, "This function should only be called on the server.")
    return {success = true, skipPurchaseEffects = true}
end

return table.freeze({
    ["1 Consoles"] = {
        Price = 79,
        Item = "hero_of_hell_console",
        DevProductId = 3707777138,
        OnPurchased = ReceiptPurchase("Purchase Featured Console", 1),
    },
    ["10 Consoles"] = {
        Price = 749,
        Item = "hero_of_hell_console",
        DevProductId = 3707777127,
        OnPurchased = ReceiptPurchase("Purchase Featured Console", 10),
    },
    ["25 Consoles"] = {
        Price = 1749,
        Item = "hero_of_hell_console",
        DevProductId = 3707777112,
        OnPurchased = ReceiptPurchase("Purchase Featured Console", 25),
    },
    ["100 Consoles"] = {
        Price = 6249,
        Item = "hero_of_hell_console",
        DevProductId = 3707777095,
        OnPurchased = ReceiptPurchase("Purchase Featured Console", 100),
    },
    ["Credits Starter Pack"] = {DevProductId = 3550800164, OnPurchased = RoutedPurchase("Purchase Credits Starter Pack")},
    ["Refresh Missions"] = {DevProductId = 3509753152, OnPurchased = ReceiptPurchase("Refresh Missions")},
    ["Black Market Refresh"] = {
        DevProductId = 3712170408,
        OnPurchased = function(a1, a2) -- Line: 102 -- upvalues: u27 (val), Router (val) -- types: a1: userdata
            assert(u27, "This function should only be called on the server.")
            return Router.broadcastRouter("Black Market Refresh", a1, a2)
        end,
    },
    ["+ 400 Credits"] = {DevProductId = 3543515479, OnPurchased = RoutedPurchase("Credits Purchased", 400)},
    ["+ 950 Credits"] = {DevProductId = 3543515926, OnPurchased = RoutedPurchase("Credits Purchased", 950)},
    ["+ 3,100 Credits"] = {DevProductId = 3543516192, OnPurchased = RoutedPurchase("Credits Purchased", 3100)},
    ["+ 6,500 Credits"] = {DevProductId = 3543516540, OnPurchased = RoutedPurchase("Credits Purchased", 6500)},
    ["+ 13,250 Credits"] = {DevProductId = 3543516770, OnPurchased = RoutedPurchase("Credits Purchased", 13250)},
    ["+ 27,000 Credits"] = {DevProductId = 3543517001, OnPurchased = RoutedPurchase("Credits Purchased", 27000)},
    ["+ 67,500 Credits"] = {DevProductId = 3543517199, OnPurchased = RoutedPurchase("Credits Purchased", 67500)},
    ["Gift + 400 Credits"] = {DevProductId = 3543518894, OnPurchased = RoutedPurchase("Gift Credits", 400)},
    ["Gift + 950 Credits"] = {DevProductId = 3543519307, OnPurchased = RoutedPurchase("Gift Credits", 950)},
    ["Gift + 3,100 Credits"] = {DevProductId = 3543519553, OnPurchased = RoutedPurchase("Gift Credits", 3100)},
    ["Gift + 6,500 Credits"] = {DevProductId = 3543519769, OnPurchased = RoutedPurchase("Gift Credits", 6500)},
    ["Gift + 13,250 Credits"] = {DevProductId = 3543520414, OnPurchased = RoutedPurchase("Gift Credits", 13250)},
    ["Gift + 27,000 Credits"] = {DevProductId = 3543520614, OnPurchased = RoutedPurchase("Gift Credits", 27000)},
    ["Gift + 67,500 Credits"] = {
        DevProductId = 3543520837,
        OnPurchased = function(a1, a2) -- Line: 177 -- upvalues: u27 (val), Constants (val), Router (val) -- types: a1: userdata
            assert(u27, "This function should only be called on the server.")
            assert(
                Constants.MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION <= (((require((game:GetService("ServerScriptService")).Services.DataService)).Get(a1, "Statistics.RobuxSpent")) or 0),
                "Player has not met the minimum spending requirement."
            )
            return Router.broadcastRouter("Gift Credits", a1, 67500)
        end,
    },
    ["+ 400 Trade Tokens"] = {DevProductId = 3583969640, OnPurchased = RoutedPurchase("Trade Tokens Purchased", 400)},
    ["+ 800 Trade Tokens"] = {DevProductId = 3583969774, OnPurchased = RoutedPurchase("Trade Tokens Purchased", 800)},
    ["+ 1,700 Trade Tokens"] = {DevProductId = 3583971349, OnPurchased = RoutedPurchase("Trade Tokens Purchased", 1700)},
    ["+ 4,500 Trade Tokens"] = {DevProductId = 3583971424, OnPurchased = RoutedPurchase("Trade Tokens Purchased", 4500)},
    ["+ 10,000 Trade Tokens"] = {DevProductId = 3583971510, OnPurchased = RoutedPurchase("Trade Tokens Purchased", 10000)},
    ["+ 22,500 Trade Tokens"] = {DevProductId = 3583971584, OnPurchased = RoutedPurchase("Trade Tokens Purchased", 22500)},
    ["Gift + 400 Trade Tokens"] = {
        DevProductId = 3583968287,
        OnPurchased = RoutedPurchase("Gift Trade Tokens", "Gift + 400 Trade Tokens", 400),
    },
    ["Gift + 800 Trade Tokens"] = {
        DevProductId = 3583968651,
        OnPurchased = RoutedPurchase("Gift Trade Tokens", "Gift + 800 Trade Tokens", 800),
    },
    ["Gift + 1,700 Trade Tokens"] = {
        DevProductId = 3583968837,
        OnPurchased = RoutedPurchase("Gift Trade Tokens", "Gift + 1,700 Trade Tokens", 1700),
    },
    ["Gift + 4,500 Trade Tokens"] = {
        DevProductId = 3583968960,
        OnPurchased = RoutedPurchase("Gift Trade Tokens", "Gift + 4,500 Trade Tokens", 4500),
    },
    ["Gift + 10,000 Trade Tokens"] = {
        DevProductId = 3583969134,
        OnPurchased = RoutedPurchase("Gift Trade Tokens", "Gift + 10,000 Trade Tokens", 10000),
    },
    ["Gift + 22,500 Trade Tokens"] = {
        DevProductId = 3583969448,
        OnPurchased = RoutedPurchase("Gift Trade Tokens", "Gift + 22,500 Trade Tokens", 22500),
    },
    ["Purchase Featured Bundle"] = {DevProductId = 3607995908, OnPurchased = DisabledPurchase},
    ["Gift Featured Bundle"] = {DevProductId = 3607996827, OnPurchased = DisabledPurchase},
    ["M4A4 | Freedom"] = {DevProductId = 3607997525, OnPurchased = DisabledPurchase},
    ["AWP | Freedom"] = {DevProductId = 3607997308, OnPurchased = DisabledPurchase},
    ["Desert Eagle | Freedom"] = {DevProductId = 3607996989, OnPurchased = DisabledPurchase},
    ["Gift M4A4 | Freedom"] = {DevProductId = 3607997581, OnPurchased = DisabledPurchase},
    ["Gift AWP | Freedom"] = {DevProductId = 3607997401, OnPurchased = DisabledPurchase},
    ["Gift Desert Eagle | Freedom"] = {DevProductId = 3607997209, OnPurchased = DisabledPurchase},
})