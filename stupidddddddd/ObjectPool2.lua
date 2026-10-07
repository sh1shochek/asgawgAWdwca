-- ReplicatedStorage.Shared.ObjectPool
-- Script path: ReplicatedStorage.Shared.ObjectPool
-- Decompile time: 2.00 ms

local v1 = {}
local u1 = {}
u1.__index = u1

local function asInstance(a1) -- Line: 41
    return a1
end

local function isPoolable(a1) -- Line: 45
    local v1 = false
    if typeof(a1) == "Instance" then
        v1 = a1:IsA("BasePart") or a1:IsA("Model")
    end
    return v1
end

local function destroy(a1) -- Line: 49 -- types: a1: userdata
    pcall(a1.Destroy, a1)
end

local function unparent(a1) -- Line: 53 -- types: a1: userdata
    return pcall(function() -- Line: 54 -- upvalues: a1 (val)
        a1.Parent = nil
    end)
end

local function park(a1, a2) -- Line: 59 -- types: a1: table
    return pcall(function() -- Line: 60 -- upvalues: a2 (val), a1 (val)
        a2.Parent = a1.Storage
    end)
end

local function clone(a1) -- Line: 65 -- types: a1: table
    return (a1.Template:Clone())
end

function u1.Acquire(a1) -- Line: 69 -- types: a1: table
    assert(not a1.Destroyed, "Cannot acquire from a destroyed ObjectPool")
    local v1 = table.remove(a1.Available)
    local v2 = a1
    while v1 do
        local u10 = v1
        if u10.Parent == v2.Storage
            and (v2.InPlace or pcall(function() -- Line: 54 -- upvalues: u10 (val)
                u10.Parent = nil
                return
            end)) then
            break
        end
        pcall(u10.Destroy, u10)
        v1 = table.remove(v2.Available)
    end
    v1 = v1 or v2.Template:Clone()
    v2.NextLease = v2.NextLease + 1
    v2.Active[v1] = v2.NextLease
    return v1, v2.NextLease
end

function u1.Release(a1, a2, a3) -- Line: 89 -- types: a1: table, a3: number
    if a1.Destroyed then
        return false
    end
    local v1 = a2
    if a1.Active[v1] ~= a3 then
        return false
    end
    a1.Active[v1] = nil
    if a1.MaxRetained <= #a1.Available
        or not pcall(function() -- Line: 60 -- upvalues: a2 (val), a1 (val)
            a2.Parent = a1.Storage
            return
        end) then
        pcall(v1.Destroy, v1)
        return true
    end
    if a1.Reset then
        local success, result = pcall(a1.Reset, a2)
        if not success then
            warn((("ObjectPool reset failed; discarding object: %*"):format((tostring(result)))))
            pcall(v1.Destroy, v1)
            return true
        end
    end
    table.insert(a1.Available, a2)
    return true
end

function u1.IsAcquired(a1, a2, a3) -- Line: 123 -- types: a1: table, a3: number
    return not a1.Destroyed and a1.Active[a2] == a3
end

function u1:Destroy() -- Line: 127 -- types: self: table
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    for k in pairs(self.Active) do
        pcall(k.Destroy, k)
    end
    self.Storage:Destroy()
    table.clear(self.Available)
    table.clear(self.Active)
end

function v1.new(a1, a2) -- Line: 142 -- upvalues: u1 (val) -- types: a2: table?
    local v1 = false
    if typeof(a1) == "Instance" then
        v1 = a1:IsA("BasePart") or a1:IsA("Model")
    end
    assert(v1, "ObjectPool template must be a BasePart, MeshPart, or Model")
    local v2 = a2 or {}
    v1 = math.max(0, (math.floor(v2.MaxRetained or 32)))
    local v3 = math.clamp(math.floor(v2.InitialSize or 0), 0, v1)
    local Folder = Instance.new("Folder")
    Folder.Name = v2.StorageName or "ObjectPool"
    if v2.StorageParent then
        Folder.Parent = v2.StorageParent
    end
    local v4 = {
        NextLease = 0,
        Destroyed = false,
        Template = a1,
        Storage = Folder,
        Available = {},
        Active = {},
        MaxRetained = v1,
        Reset = v2.Reset,
        InPlace = v2.InPlace == true,
    }
    local u93 = setmetatable(v4, u1)
    for i = 1, v3 do
        local u73 = u93.Template:Clone()
        if not pcall(function() -- Line: 60 -- upvalues: u73 (val), u93 (val)
            u73.Parent = u93.Storage
            return
        end) then
            pcall(u73.Destroy, u73)
        else
            table.insert(u93.Available, u73)
        end
    end
    return u93
end

return v1