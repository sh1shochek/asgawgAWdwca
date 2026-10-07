-- ReplicatedStorage.Components.Common.ThirdPersonWeaponStash
-- Script path: ReplicatedStorage.Components.Common.ThirdPersonWeaponStash
-- Decompile time: 1.42 ms

local Workspace = game:GetService("Workspace")
local v1 = {}
local u10 = CFrame.new(0, 10000, 0)
local u11 = nil

local function getStash() -- Line: 12 -- upvalues: u11 (ref), Workspace (val)
    local v1 = u11
    if v1 and v1.Parent == Workspace then
        return v1
    end
    local Folder = Instance.new("Folder")
    Folder.Name = "ThirdPersonWeaponStash"
    Folder.Archivable = false
    Folder.Parent = Workspace
    u11 = Folder
    return Folder
end

function v1.Park(a1, a2) -- Line: 26
    -- upvalues: u10 (val), u11 (ref), Workspace (val)
    local Part1
    local v1 = a2
    for i, j in v1 do
        Part1 = j.Part1
        j:Destroy()
        if Part1 then
            Part1.Anchored = true
            Part1.CFrame = u10
        end
    end
    table.clear(a2)
    local v2 = u11
    if not v2 or v2.Parent ~= Workspace then
        local Folder = Instance.new("Folder")
        Folder.Name = "ThirdPersonWeaponStash"
        Folder.Archivable = false
        Folder.Parent = Workspace
        u11 = Folder
        v1 = Folder
    else
        v1 = v2
    end
    a1.Parent = v1
end

function v1.PoseForJoint(a1, a2, a3, a4) -- Line: 40 -- types: a1: userdata, a2: userdata, a3: userdata, a4: userdata
    if a1.Anchored then
        a1.CFrame = a2.CFrame * a3 * a4:Inverse()
    end
end

function v1.Release(a1) -- Line: 47 -- types: a1: table
    local Part1
    for i, j in a1 do
        Part1 = j.Part1
        if Part1 then
            Part1.Anchored = false
        end
    end
end

function v1.TryUnpark(a1, a2) -- Line: 57 -- types: a1: userdata, a2: userdata
    return pcall(function() -- Line: 58 -- upvalues: a1 (val), a2 (val)
        a1.Parent = a2
    end)
end

return (table.freeze(v1))