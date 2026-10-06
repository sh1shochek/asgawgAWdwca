-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.Database.Custom.Types);
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = require(ReplicatedStorage.Packages.Signal).new();
u1.OnServerBrowserUpdated = u2;
local u3 = {};
local u4 = {};

function u1.GetServerNameFromMatchId(p5: string) -- Line: 31
    return p5:gsub("[^%a]", ""):upper();
end;

function u1.GetActiveGameServers() -- Line: 37
    -- upvalues: u4 (ref)
    return u4;
end;

function u1.GetServerByMatchId(p6: string) -- Line: 43
    -- upvalues: u3 (copy)
    return u3[p6];
end;

function u1.UpdateActiveGameServers(p7: table) -- Line: 49
    -- upvalues: RemoveFromArray (copy), HttpService (copy), RunService (copy), u3 (copy), u4 (ref), u2 (copy)
    local v10 = RemoveFromArray(HttpService:JSONDecode(p7 or "[]"), function(p8, p9) -- Line: 54
        -- upvalues: RunService (ref)
        return not RunService:IsStudio() and p9.JobId == "Studio" and true or false;
    end);
    local v11 = {};

    for _, v in ipairs(v10) do
        v11[v.MatchId] = v;
    end;

    for i in u3 do
        if not v11[i] then
            u3[i] = nil;
        end;
    end;

    for i, v in v11 do
        u3[i] = v;
    end;

    u4 = v10;
    u2:Fire(u4);
end;

function u1.ObserverServerBrowser(p12: function) -- Line: 76
    -- upvalues: u2 (copy), u4 (ref)
    local u13 = u2:Connect(p12);

    if #u4 > 0 then
        p12(u4);
    end;

    return function() -- Line: 81
        -- upvalues: u13 (copy)
        if u13 and u13.Connected then
            u13:Disconnect();
        end;
    end;
end;

Remotes.Modes.FetchServers.Listen(function(p14) -- Line: 91
    -- upvalues: u1 (copy)
    u1.UpdateActiveGameServers(p14);
end);

return u1;