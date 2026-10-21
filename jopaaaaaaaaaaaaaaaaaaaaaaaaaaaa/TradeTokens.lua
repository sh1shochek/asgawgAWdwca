-- ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens
-- Script path: ReplicatedStorage.Database.Custom.GameStats.Monetization.TradeTokens
-- Decompile time: 7.52 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Router = require(ReplicatedStorage.Database.Security.Router);
local u1 = RunService:IsServer();

local function TokenPurchase(u2: string, u3: number?) -- Line: 23
    -- upvalues: u1 (copy), Router (copy)
    return function(p4: userdata, p5: number) -- Line: 24
        -- upvalues: u1 (ref), u3 (copy), Router (ref), u2 (copy)
        assert(u1, "This function should only be called on the server.");

        if u3 == nil then
            return Router.broadcastRouter(u2, p4, p5);
        end;

        return Router.broadcastRouter(u2, p4, u3, p5);
    end;
end;

local function DisabledPurchase(p6: userdata, p7: number) -- Line: 34
    -- upvalues: u1 (copy)
    assert(u1, "This function should only be called on the server.");

    return false;
end;

local table_freeze = table.freeze;
local v8 = {};
local v9 = {
    Price = 57
};
local u10 = nil;
local u11 = "Purchase Credits Starter Pack With Tokens";

function v9.OnPurchased(p12: userdata, p13: number) -- Line: 24
    -- upvalues: u1 (copy), u10 (copy), Router (copy), u11 (copy)
    assert(u1, "This function should only be called on the server.");

    if u10 == nil then
        return Router.broadcastRouter(u11, p12, p13);
    end;

    return Router.broadcastRouter(u11, p12, u10, p13);
end;

v8["Credits Starter Pack"] = v9;
local v14 = {
    Price = 90
};
local u15 = 1000;
local u16 = "Purchase Candy With Tokens";

function v14.OnPurchased(p17: userdata, p18: number) -- Line: 24
    -- upvalues: u1 (copy), u15 (copy), Router (copy), u16 (copy)
    assert(u1, "This function should only be called on the server.");

    if u15 == nil then
        return Router.broadcastRouter(u16, p17, p18);
    end;

    return Router.broadcastRouter(u16, p17, u15, p18);
end;

v8["+ 1,000 Candy"] = v14;
local v19 = {
    Price = 343
};
local u20 = 4500;
local u21 = "Purchase Candy With Tokens";

function v19.OnPurchased(p22: userdata, p23: number) -- Line: 24
    -- upvalues: u1 (copy), u20 (copy), Router (copy), u21 (copy)
    assert(u1, "This function should only be called on the server.");

    if u20 == nil then
        return Router.broadcastRouter(u21, p22, p23);
    end;

    return Router.broadcastRouter(u21, p22, u20, p23);
end;

v8["+ 4,500 Candy"] = v19;
local v24 = {
    Price = 746
};
local u25 = 11000;
local u26 = "Purchase Candy With Tokens";

function v24.OnPurchased(p27: userdata, p28: number) -- Line: 24
    -- upvalues: u1 (copy), u25 (copy), Router (copy), u26 (copy)
    assert(u1, "This function should only be called on the server.");

    if u25 == nil then
        return Router.broadcastRouter(u26, p27, p28);
    end;

    return Router.broadcastRouter(u26, p27, u25, p28);
end;

v8["+ 11,000 Candy"] = v24;
local v29 = {
    Price = 229
};
local u30 = 400;
local u31 = "Purchase Credits With Tokens";

function v29.OnPurchased(p32: userdata, p33: number) -- Line: 24
    -- upvalues: u1 (copy), u30 (copy), Router (copy), u31 (copy)
    assert(u1, "This function should only be called on the server.");

    if u30 == nil then
        return Router.broadcastRouter(u31, p32, p33);
    end;

    return Router.broadcastRouter(u31, p32, u30, p33);
end;

v8["+ 400 Credits"] = v29;
local v34 = {
    Price = 517
};
local u35 = 950;
local u36 = "Purchase Credits With Tokens";

function v34.OnPurchased(p37: userdata, p38: number) -- Line: 24
    -- upvalues: u1 (copy), u35 (copy), Router (copy), u36 (copy)
    assert(u1, "This function should only be called on the server.");

    if u35 == nil then
        return Router.broadcastRouter(u36, p37, p38);
    end;

    return Router.broadcastRouter(u36, p37, u35, p38);
end;

v8["+ 950 Credits"] = v34;
local v39 = {
    Price = 1437
};
local u40 = 3100;
local u41 = "Purchase Credits With Tokens";

function v39.OnPurchased(p42: userdata, p43: number) -- Line: 24
    -- upvalues: u1 (copy), u40 (copy), Router (copy), u41 (copy)
    assert(u1, "This function should only be called on the server.");

    if u40 == nil then
        return Router.broadcastRouter(u41, p42, p43);
    end;

    return Router.broadcastRouter(u41, p42, u40, p43);
end;

v8["+ 3,100 Credits"] = v39;
local v44 = {
    Price = 2874
};
local u45 = 6500;
local u46 = "Purchase Credits With Tokens";

function v44.OnPurchased(p47: userdata, p48: number) -- Line: 24
    -- upvalues: u1 (copy), u45 (copy), Router (copy), u46 (copy)
    assert(u1, "This function should only be called on the server.");

    if u45 == nil then
        return Router.broadcastRouter(u46, p47, p48);
    end;

    return Router.broadcastRouter(u46, p47, u45, p48);
end;

v8["+ 6,500 Credits"] = v44;
local v49 = {
    Price = 5749
};
local u50 = 13250;
local u51 = "Purchase Credits With Tokens";

function v49.OnPurchased(p52: userdata, p53: number) -- Line: 24
    -- upvalues: u1 (copy), u50 (copy), Router (copy), u51 (copy)
    assert(u1, "This function should only be called on the server.");

    if u50 == nil then
        return Router.broadcastRouter(u51, p52, p53);
    end;

    return Router.broadcastRouter(u51, p52, u50, p53);
end;

v8["+ 13,250 Credits"] = v49;
local v54 = {
    Price = 11499
};
local u55 = 27000;
local u56 = "Purchase Credits With Tokens";

function v54.OnPurchased(p57: userdata, p58: number) -- Line: 24
    -- upvalues: u1 (copy), u55 (copy), Router (copy), u56 (copy)
    assert(u1, "This function should only be called on the server.");

    if u55 == nil then
        return Router.broadcastRouter(u56, p57, p58);
    end;

    return Router.broadcastRouter(u56, p57, u55, p58);
end;

v8["+ 27,000 Credits"] = v54;
local v59 = {
    Price = 28749
};
local u60 = 67500;
local u61 = "Purchase Credits With Tokens";

function v59.OnPurchased(p62: userdata, p63: number) -- Line: 24
    -- upvalues: u1 (copy), u60 (copy), Router (copy), u61 (copy)
    assert(u1, "This function should only be called on the server.");

    if u60 == nil then
        return Router.broadcastRouter(u61, p62, p63);
    end;

    return Router.broadcastRouter(u61, p62, u60, p63);
end;

v8["+ 67,500 Credits"] = v59;
local v64 = {
    Price = 229
};
local u65 = 400;
local u66 = "Gift Credits With Tokens";

function v64.OnPurchased(p67: userdata, p68: number) -- Line: 24
    -- upvalues: u1 (copy), u65 (copy), Router (copy), u66 (copy)
    assert(u1, "This function should only be called on the server.");

    if u65 == nil then
        return Router.broadcastRouter(u66, p67, p68);
    end;

    return Router.broadcastRouter(u66, p67, u65, p68);
end;

v8["Gift + 400 Credits"] = v64;
local v69 = {
    Price = 517
};
local u70 = 950;
local u71 = "Gift Credits With Tokens";

function v69.OnPurchased(p72: userdata, p73: number) -- Line: 24
    -- upvalues: u1 (copy), u70 (copy), Router (copy), u71 (copy)
    assert(u1, "This function should only be called on the server.");

    if u70 == nil then
        return Router.broadcastRouter(u71, p72, p73);
    end;

    return Router.broadcastRouter(u71, p72, u70, p73);
end;

v8["Gift + 950 Credits"] = v69;
local v74 = {
    Price = 1437
};
local u75 = 3100;
local u76 = "Gift Credits With Tokens";

function v74.OnPurchased(p77: userdata, p78: number) -- Line: 24
    -- upvalues: u1 (copy), u75 (copy), Router (copy), u76 (copy)
    assert(u1, "This function should only be called on the server.");

    if u75 == nil then
        return Router.broadcastRouter(u76, p77, p78);
    end;

    return Router.broadcastRouter(u76, p77, u75, p78);
end;

v8["Gift + 3,100 Credits"] = v74;
local v79 = {
    Price = 2874
};
local u80 = 6500;
local u81 = "Gift Credits With Tokens";

function v79.OnPurchased(p82: userdata, p83: number) -- Line: 24
    -- upvalues: u1 (copy), u80 (copy), Router (copy), u81 (copy)
    assert(u1, "This function should only be called on the server.");

    if u80 == nil then
        return Router.broadcastRouter(u81, p82, p83);
    end;

    return Router.broadcastRouter(u81, p82, u80, p83);
end;

v8["Gift + 6,500 Credits"] = v79;
local v84 = {
    Price = 5749
};
local u85 = 13250;
local u86 = "Gift Credits With Tokens";

function v84.OnPurchased(p87: userdata, p88: number) -- Line: 24
    -- upvalues: u1 (copy), u85 (copy), Router (copy), u86 (copy)
    assert(u1, "This function should only be called on the server.");

    if u85 == nil then
        return Router.broadcastRouter(u86, p87, p88);
    end;

    return Router.broadcastRouter(u86, p87, u85, p88);
end;

v8["Gift + 13,250 Credits"] = v84;
local v89 = {
    Price = 11499
};
local u90 = 27000;
local u91 = "Gift Credits With Tokens";

function v89.OnPurchased(p92: userdata, p93: number) -- Line: 24
    -- upvalues: u1 (copy), u90 (copy), Router (copy), u91 (copy)
    assert(u1, "This function should only be called on the server.");

    if u90 == nil then
        return Router.broadcastRouter(u91, p92, p93);
    end;

    return Router.broadcastRouter(u91, p92, u90, p93);
end;

v8["Gift + 27,000 Credits"] = v89;
local v94 = {
    Price = 28749
};
local u95 = 67500;
local u96 = "Gift Credits With Tokens";

function v94.OnPurchased(p97: userdata, p98: number) -- Line: 24
    -- upvalues: u1 (copy), u95 (copy), Router (copy), u96 (copy)
    assert(u1, "This function should only be called on the server.");

    if u95 == nil then
        return Router.broadcastRouter(u96, p97, p98);
    end;

    return Router.broadcastRouter(u96, p97, u95, p98);
end;

v8["Gift + 67,500 Credits"] = v94;
v8["Purchase Featured Bundle"] = {
    Price = 1149,
    OnPurchased = DisabledPurchase
};
v8["Gift Featured Bundle"] = {
    Price = 1149,
    OnPurchased = DisabledPurchase
};
v8["M4A4 | Freedom"] = {
    Price = 689,
    OnPurchased = DisabledPurchase
};
v8["AWP | Freedom"] = {
    Price = 459,
    OnPurchased = DisabledPurchase
};
v8["Desert Eagle | Freedom"] = {
    Price = 574,
    OnPurchased = DisabledPurchase
};
v8["Gift M4A4 | Freedom"] = {
    Price = 689,
    OnPurchased = DisabledPurchase
};
v8["Gift AWP | Freedom"] = {
    Price = 459,
    OnPurchased = DisabledPurchase
};
v8["Gift Desert Eagle | Freedom"] = {
    Price = 574,
    OnPurchased = DisabledPurchase
};

return table_freeze(v8);