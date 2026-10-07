-- ReplicatedStorage.MovementV2.Transport
-- Script path: ReplicatedStorage.MovementV2.Transport
-- Decompile time: 1.44 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local v1 = {}
local u13 = table.freeze({
    Commands = "UnreliableRemoteEvent",
    OwnerSnapshot = "UnreliableRemoteEvent",
    RemoteSnapshot = "UnreliableRemoteEvent",
    BotCombat = "UnreliableRemoteEvent",
    Control = "RemoteEvent",
    Trace = "RemoteEvent",
    Diagnostics = "RemoteEvent",
})

local function validateRemote(a1, a2, a3) -- Line: 32 -- types: a1: userdata, a2: string, a3: string
    if a1.ClassName ~= a3 then
        error(("MovementV2 transport %* must be %*, found %*"):format(a2, a3, a1.ClassName), 3)
    end
    return a1
end

local function getOrCreateServerFolder() -- Line: 39 -- upvalues: ReplicatedStorage (val)
    local MovementV2Remotes = ReplicatedStorage:FindFirstChild("MovementV2Remotes")
    if MovementV2Remotes ~= nil then
        assert(MovementV2Remotes:IsA("Folder"), "ReplicatedStorage.MovementV2Remotes must be a Folder")
        return MovementV2Remotes
    end
    local Folder = Instance.new("Folder")
    Folder.Name = "MovementV2Remotes"
    Folder.Parent = ReplicatedStorage
    return Folder
end

local function resolveServerChannels() -- Line: 52 -- upvalues: RunService (val), ReplicatedStorage (val), u13 (val)
    local ClassName, v1, v2, v3, v4
    assert(RunService:IsServer(), "Transport.getServerChannels is server-only")
    local MovementV2Remotes = ReplicatedStorage:FindFirstChild("MovementV2Remotes")
    if MovementV2Remotes == nil then
        local Folder = Instance.new("Folder")
        Folder.Name = "MovementV2Remotes"
        Folder.Parent = ReplicatedStorage
        v1 = Folder
    else
        assert(MovementV2Remotes:IsA("Folder"), "ReplicatedStorage.MovementV2Remotes must be a Folder")
        v1 = MovementV2Remotes
    end
    local v5 = {}
    local v6 = nil
    local v7 = nil
    for i, j in u13, v6, v7 do
        v2 = v1:FindFirstChild(i)
        if v2 == nil then
            v2 = Instance.new(j)
            v2.Name = i
            v2.Parent = v1
        end
        v3 = v2
        if v3.ClassName ~= j then
            v4 = error
            ClassName = v3.ClassName
            v4(("MovementV2 transport %* must be %*, found %*"):format(i, j, ClassName), 3)
        end
        v5[i] = v3
    end
    return (table.freeze(v5))
end

local function resolveClientChannels() -- Line: 70 -- upvalues: RunService (val), ReplicatedStorage (val), u13 (val)
    local ClassName, v1, v2
    assert(RunService:IsClient(), "Transport.getClientChannels is client-only")
    local MovementV2Remotes = ReplicatedStorage:WaitForChild("MovementV2Remotes")
    assert(MovementV2Remotes:IsA("Folder"), "ReplicatedStorage.MovementV2Remotes must be a Folder")
    local v3 = {}
    local v4 = nil
    local v5 = nil
    for i, j in u13, v4, v5 do
        v1 = MovementV2Remotes:WaitForChild(i)
        if v1.ClassName ~= j then
            v2 = error
            ClassName = v1.ClassName
            v2(("MovementV2 transport %* must be %*, found %*"):format(i, j, ClassName), 3)
        end
        v3[i] = v1
    end
    return (table.freeze(v3))
end

local u18 = nil
local u19 = nil

function v1.getServerChannels() -- Line: 87 -- upvalues: u18 (ref), resolveServerChannels (val)
    if u18 == nil then
        u18 = resolveServerChannels()
    end
    return u18
end

function v1.getClientChannels() -- Line: 94 -- upvalues: u19 (ref), resolveClientChannels (val)
    if u19 == nil then
        u19 = resolveClientChannels()
    end
    return u19
end

return (table.freeze(v1))