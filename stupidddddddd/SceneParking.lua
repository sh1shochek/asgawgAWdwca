-- ReplicatedStorage.Components.Common.SceneParking
-- Script path: ReplicatedStorage.Components.Common.SceneParking
-- Decompile time: 0.60 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local v1 = {}
local u11 = nil

local function getParking() -- Line: 12 -- upvalues: u11 (ref), ReplicatedStorage (val)
    local v1 = u11
    if v1 and v1.Parent == ReplicatedStorage then
        return v1
    end
    local Folder = Instance.new("Folder")
    Folder.Name = "ParkedScenes"
    Folder.Archivable = false
    Folder.Parent = ReplicatedStorage
    u11 = Folder
    return Folder
end

function v1.Park(a1) -- Line: 25 -- upvalues: u11 (ref), ReplicatedStorage (val) -- types: a1: userdata
    pcall(function() -- Line: 27 -- upvalues: a1 (val), u11 (upval), ReplicatedStorage (upval)
        local v1
        local v2 = u11
        if not v2 or v2.Parent ~= ReplicatedStorage then
            local Folder = Instance.new("Folder")
            Folder.Name = "ParkedScenes"
            Folder.Archivable = false
            Folder.Parent = ReplicatedStorage
            u11 = Folder
            v1 = Folder
        else
            v1 = v2
        end
        a1.Parent = v1
    end)
end

function v1.Unpark(a1) -- Line: 32 -- upvalues: Workspace (val) -- types: a1: userdata
    if a1.Parent ~= Workspace then
        a1.Parent = Workspace
    end
end

return (table.freeze(v1))