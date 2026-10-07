-- ReplicatedStorage.Database.Components.ServerBrowser
-- Script path: ReplicatedStorage.Database.Components.ServerBrowser
-- Decompile time: 1.07 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Database.Custom.Types)
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local u37 = require(ReplicatedStorage.Packages.Signal).new()
u0.OnServerBrowserUpdated = u37
local u38 = {}
local u39 = {}

function u0.GetServerNameFromMatchId(a1) -- Line: 31 -- types: a1: string
    return a1:gsub("[^%a]", ""):upper()
end

function u0.GetActiveGameServers() -- Line: 37 -- upvalues: u39 (ref)
    return u39
end

function u0.GetServerByMatchId(a1) -- Line: 43 -- upvalues: u38 (val) -- types: a1: string
    return u38[a1]
end

function u0.UpdateActiveGameServers(a1) -- Line: 49
    -- upvalues: RemoveFromArray (val), HttpService (val), RunService (val), u38 (val), u39 (ref), u37 (val)
    local v1 = {}
    local v2 = RemoveFromArray(HttpService:JSONDecode(a1 or "[]"), function(a1, a2) -- Line: 54 -- upvalues: RunService (upval)
        local v1
        if RunService:IsStudio() then
            v1 = false
        else
            v1 = true
            if a2.JobId ~= "Studio" then
                v1 = false
            end
        end
        return v1
    end)
    for i, v in ipairs(v2) do
        v1[v.MatchId] = v
    end
    for i2 in u38 do
        if not v1[i2] then
            u38[i2] = nil
        end
    end
    for j, k in v1 do
        u38[j] = k
    end
    u37:Fire(v2)
end

function u0.ObserverServerBrowser(a1) -- Line: 76 -- upvalues: u37 (val), u39 (ref) -- types: a1: function
    local u5 = u37:Connect(a1)
    if #u39 > 0 then
        a1(u39)
    end
    return function() -- Line: 81 -- upvalues: u5 (val)
        if u5 and u5.Connected then
            u5:Disconnect()
        end
    end
end

Remotes.Modes.FetchServers.Listen(function(a1) -- Line: 91 -- upvalues: u0 (val)
    u0.UpdateActiveGameServers(a1)
end)
return u0