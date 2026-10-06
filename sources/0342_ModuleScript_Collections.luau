-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
require(ReplicatedStorage.Database.Custom.Types);
local u2 = require(ReplicatedStorage.Packages.Signal).new();
v1.OnAvailableCollectionsUpdated = u2;
local u3 = {};
local u4 = false;

local function UpdateAvailableCollections(p5: string) -- Line: 26
    -- upvalues: u3 (ref), HttpService (copy), u4 (ref), u2 (copy)
    u3 = HttpService:JSONDecode(p5);
    u4 = true;
    u2:Fire(u3);
end;

function v1.GetCollectionByName(p6: string) -- Line: 35
    -- upvalues: u3 (ref)
    for _, v in ipairs(u3) do
        if v.name == p6 then
            return v;
        end;
    end;

    return nil;
end;

function v1.GetAllCollections() -- Line: 46
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.ObserveAvailableCollections(p7: function) -- Line: 52
    -- upvalues: u2 (copy), u4 (ref), u3 (ref)
    local u8 = u2:Connect(p7);

    if u4 then
        p7(u3);
    end;

    return function() -- Line: 57
        -- upvalues: u8 (copy)
        u8:Disconnect();
    end;
end;

local function SyncAvailableCollections() -- Line: 65
    -- upvalues: ReplicatedStorage (copy), u3 (ref), HttpService (copy), u4 (ref), u2 (copy)
    local Attribute = ReplicatedStorage:GetAttribute("AvailableCollections");

    if typeof(Attribute) == "string" then
        u3 = HttpService:JSONDecode(Attribute);
        u4 = true;
        u2:Fire(u3);
    end;
end;

local Attribute = ReplicatedStorage:GetAttribute("AvailableCollections");

if typeof(Attribute) == "string" then
    u3 = HttpService:JSONDecode(Attribute);
    u4 = true;
    u2:Fire(u3);
end;

ReplicatedStorage:GetAttributeChangedSignal("AvailableCollections"):Connect(SyncAvailableCollections);

return v1;