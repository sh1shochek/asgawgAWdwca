-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local v1 = {};
local u2 = nil;

local function getParking() -- Line: 12
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    local v3 = u2;

    if v3 and v3.Parent == ReplicatedStorage then
        return v3;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "ParkedScenes";
    Folder.Archivable = false;
    Folder.Parent = ReplicatedStorage;
    u2 = Folder;

    return Folder;
end;

function v1.Park(u4: userdata) -- Line: 25
    -- upvalues: u2 (ref), ReplicatedStorage (copy)
    pcall(function() -- Line: 27
        -- upvalues: u4 (copy), u2 (ref), ReplicatedStorage (ref)
        local v5 = u2;

        if not v5 or v5.Parent ~= ReplicatedStorage then
            v5 = Instance.new("Folder");
            v5.Name = "ParkedScenes";
            v5.Archivable = false;
            v5.Parent = ReplicatedStorage;
            u2 = v5;
        end;

        u4.Parent = v5;
    end);
end;

function v1.Unpark(p6: userdata) -- Line: 32
    -- upvalues: Workspace (copy)
    if p6.Parent ~= Workspace then
        p6.Parent = Workspace;
    end;
end;

return table.freeze(v1);