-- ReplicatedStorage.Database.Components.Libraries.Collections
-- Script path: ReplicatedStorage.Database.Components.Libraries.Collections
-- Decompile time: 0.95 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
require(ReplicatedStorage.Database.Custom.Types)
local u21 = require(ReplicatedStorage.Packages.Signal).new()
v1.OnAvailableCollectionsUpdated = u21
local u22 = {}
local u23 = false

local function UpdateAvailableCollections(a1) -- Line: 26
    -- upvalues: u22 (ref), HttpService (val), u23 (ref), u21 (val)
    u22 = HttpService:JSONDecode(a1)
    u23 = true
    u21:Fire(u22)
end

function v1.GetCollectionByName(a1) -- Line: 35 -- upvalues: u22 (ref) -- types: a1: string
    for i, v in ipairs(u22) do
        if v.name == a1 then
            return v
        end
    end
    return nil
end

function v1.GetAllCollections() -- Line: 46 -- upvalues: u22 (ref)
    return u22
end

function v1.ObserveAvailableCollections(a1) -- Line: 52
    -- upvalues: u21 (val), u23 (ref), u22 (ref)
    local u5 = u21:Connect(a1)
    if u23 then
        a1(u22)
    end
    return function() -- Line: 57 -- upvalues: u5 (val)
        u5:Disconnect()
    end
end

local Attribute = ReplicatedStorage:GetAttribute("AvailableCollections")
if typeof(Attribute) == "string" then
    u22 = (HttpService:JSONDecode(Attribute))
    u21:Fire(u22)
end
;(ReplicatedStorage:GetAttributeChangedSignal("AvailableCollections")):Connect(function() -- Line: 65 -- upvalues: ReplicatedStorage (val), u22 (ref), HttpService (val), u23 (ref), u21 (val)
    local Attribute = ReplicatedStorage:GetAttribute("AvailableCollections")
    if typeof(Attribute) == "string" then
        u22 = HttpService:JSONDecode(Attribute)
        u23 = true
        u21:Fire(u22)
    end
end)
return v1