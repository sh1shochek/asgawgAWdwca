-- ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens
-- Decompile time: 2.52 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Router = require(ReplicatedStorage.Database.Security.Router)
local u17 = RunService:IsServer()

local function TokenPurchase(a1, a2) -- Line: 23 -- upvalues: u17 (val), Router (val) -- types: a1: string, a2: number?
    return function(a1_2, a2_2) -- Line: 24
        -- upvalues: u17 (upval), a2 (val), Router (upval), a1 (val)
        assert(u17, "This function should only be called on the server.")
        if a2 == nil then
            return Router.broadcastRouter(a1, a1_2, a2_2)
        end
        return Router.broadcastRouter(a1, a1_2, a2, a2_2)
    end
end

local function DisabledPurchase(a1, a2) -- Line: 34 -- upvalues: u17 (val) -- types: a1: userdata, a2: number
    assert(u17, "This function should only be called on the server.")
    return false
end

local freeze = table.freeze
local v1 = {}
local v2 = {Price = 57}
local u23 = nil
local u24 = "Purchase Credits Starter Pack With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u23 (val), Router (val), u24 (val)
    assert(u17, "This function should only be called on the server.")
    if u23 == nil then
        return Router.broadcastRouter(u24, a1, a2)
    end
    return Router.broadcastRouter(u24, a1, u23, a2)
end

v1["Credits Starter Pack"] = v2
v2 = {Price = 229}
local u27 = 400
local u28 = "Purchase Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u27 (val), Router (val), u28 (val)
    assert(u17, "This function should only be called on the server.")
    if u27 == nil then
        return Router.broadcastRouter(u28, a1, a2)
    end
    return Router.broadcastRouter(u28, a1, u27, a2)
end

v1["+ 400 Credits"] = v2
v2 = {Price = 517}
local u31 = 950
local u32 = "Purchase Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u31 (val), Router (val), u32 (val)
    assert(u17, "This function should only be called on the server.")
    if u31 == nil then
        return Router.broadcastRouter(u32, a1, a2)
    end
    return Router.broadcastRouter(u32, a1, u31, a2)
end

v1["+ 950 Credits"] = v2
v2 = {Price = 1437}
local u35 = 3100
local u36 = "Purchase Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u35 (val), Router (val), u36 (val)
    assert(u17, "This function should only be called on the server.")
    if u35 == nil then
        return Router.broadcastRouter(u36, a1, a2)
    end
    return Router.broadcastRouter(u36, a1, u35, a2)
end

v1["+ 3,100 Credits"] = v2
v2 = {Price = 2874}
local u39 = 6500
local u40 = "Purchase Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u39 (val), Router (val), u40 (val)
    assert(u17, "This function should only be called on the server.")
    if u39 == nil then
        return Router.broadcastRouter(u40, a1, a2)
    end
    return Router.broadcastRouter(u40, a1, u39, a2)
end

v1["+ 6,500 Credits"] = v2
v2 = {Price = 5749}
local u43 = 13250
local u44 = "Purchase Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u43 (val), Router (val), u44 (val)
    assert(u17, "This function should only be called on the server.")
    if u43 == nil then
        return Router.broadcastRouter(u44, a1, a2)
    end
    return Router.broadcastRouter(u44, a1, u43, a2)
end

v1["+ 13,250 Credits"] = v2
v2 = {Price = 11499}
local u47 = 27000
local u48 = "Purchase Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u47 (val), Router (val), u48 (val)
    assert(u17, "This function should only be called on the server.")
    if u47 == nil then
        return Router.broadcastRouter(u48, a1, a2)
    end
    return Router.broadcastRouter(u48, a1, u47, a2)
end

v1["+ 27,000 Credits"] = v2
v2 = {Price = 28749}
local u51 = 67500
local u52 = "Purchase Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u51 (val), Router (val), u52 (val)
    assert(u17, "This function should only be called on the server.")
    if u51 == nil then
        return Router.broadcastRouter(u52, a1, a2)
    end
    return Router.broadcastRouter(u52, a1, u51, a2)
end

v1["+ 67,500 Credits"] = v2
v2 = {Price = 229}
local u55 = 400
local u56 = "Gift Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u55 (val), Router (val), u56 (val)
    assert(u17, "This function should only be called on the server.")
    if u55 == nil then
        return Router.broadcastRouter(u56, a1, a2)
    end
    return Router.broadcastRouter(u56, a1, u55, a2)
end

v1["Gift + 400 Credits"] = v2
v2 = {Price = 517}
local u59 = 950
local u60 = "Gift Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u59 (val), Router (val), u60 (val)
    assert(u17, "This function should only be called on the server.")
    if u59 == nil then
        return Router.broadcastRouter(u60, a1, a2)
    end
    return Router.broadcastRouter(u60, a1, u59, a2)
end

v1["Gift + 950 Credits"] = v2
v2 = {Price = 1437}
local u63 = 3100
local u64 = "Gift Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u63 (val), Router (val), u64 (val)
    assert(u17, "This function should only be called on the server.")
    if u63 == nil then
        return Router.broadcastRouter(u64, a1, a2)
    end
    return Router.broadcastRouter(u64, a1, u63, a2)
end

v1["Gift + 3,100 Credits"] = v2
v2 = {Price = 2874}
local u67 = 6500
local u68 = "Gift Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u67 (val), Router (val), u68 (val)
    assert(u17, "This function should only be called on the server.")
    if u67 == nil then
        return Router.broadcastRouter(u68, a1, a2)
    end
    return Router.broadcastRouter(u68, a1, u67, a2)
end

v1["Gift + 6,500 Credits"] = v2
v2 = {Price = 5749}
local u71 = 13250
local u72 = "Gift Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u71 (val), Router (val), u72 (val)
    assert(u17, "This function should only be called on the server.")
    if u71 == nil then
        return Router.broadcastRouter(u72, a1, a2)
    end
    return Router.broadcastRouter(u72, a1, u71, a2)
end

v1["Gift + 13,250 Credits"] = v2
v2 = {Price = 11499}
local u75 = 27000
local u76 = "Gift Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u75 (val), Router (val), u76 (val)
    assert(u17, "This function should only be called on the server.")
    if u75 == nil then
        return Router.broadcastRouter(u76, a1, a2)
    end
    return Router.broadcastRouter(u76, a1, u75, a2)
end

v1["Gift + 27,000 Credits"] = v2
v2 = {Price = 28749}
local u79 = 67500
local u80 = "Gift Credits With Tokens"

function v2.OnPurchased(a1, a2) -- Line: 24
    -- upvalues: u17 (val), u79 (val), Router (val), u80 (val)
    assert(u17, "This function should only be called on the server.")
    if u79 == nil then
        return Router.broadcastRouter(u80, a1, a2)
    end
    return Router.broadcastRouter(u80, a1, u79, a2)
end

v1["Gift + 67,500 Credits"] = v2
v1["Purchase Featured Bundle"] = {Price = 1149, OnPurchased = DisabledPurchase}
v1["Gift Featured Bundle"] = {Price = 1149, OnPurchased = DisabledPurchase}
v1["M4A4 | Freedom"] = {Price = 689, OnPurchased = DisabledPurchase}
v1["AWP | Freedom"] = {Price = 459, OnPurchased = DisabledPurchase}
v1["Desert Eagle | Freedom"] = {Price = 574, OnPurchased = DisabledPurchase}
v1["Gift M4A4 | Freedom"] = {Price = 689, OnPurchased = DisabledPurchase}
v1["Gift AWP | Freedom"] = {Price = 459, OnPurchased = DisabledPurchase}
v1["Gift Desert Eagle | Freedom"] = {Price = 574, OnPurchased = DisabledPurchase}
return freeze(v1)