-- ReplicatedStorage.Packages.DebugTools.Client.Networking
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Networking
-- Decompile time: 1.14 ms

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = script.Parent.Parent.Shared
local Constants = require(Shared.Constants)
local u17 = {internal = {TopicCallbacks = {}, MessageQueue = {}}, interface = {}}

function u17.internal.listenToNetworkTraffic() -- Line: 20
    -- upvalues: ReplicatedStorage (val), Constants (val), u17 (val)
    local v1 = ReplicatedStorage:WaitForChild(Constants.NETWORK_TRAFFIC_REMOTE_NAME)
    v1.OnClientEvent:Connect(function(a1) -- Line: 23 -- upvalues: u17 (upval) -- types: a1: table
        local v1, v2
        for i, j in a1 do
            v1 = j[1]
            v2 = j[2]
            if v1 and v2 then
                u17.internal.invokeTopic(v1, table.unpack(v2))
            end
        end
    end)
    u17.internal.NetworkTrafficRemote = v1
    v1:FireServer("_ready_")
end

function u17.internal.initiateTrafficHeartbeat() -- Line: 41 -- upvalues: u17 (val), RunService (val)
    if not u17.internal.NetworkTrafficRemote then
        return
    end
    RunService.Heartbeat:Connect(function() -- Line: 46 -- upvalues: u17 (upval)
        if #u17.internal.MessageQueue <= 0 then
            return
        end
        u17.internal.NetworkTrafficRemote:FireServer(u17.internal.MessageQueue)
        u17.internal.MessageQueue = {}
    end)
end

function u17.internal.invokeTopic(a1, ...) -- Line: 57 -- upvalues: u17 (val) -- types: a1: string
    local v1 = u17.internal.TopicCallbacks[a1]
    if not v1 then
        return
    end
    for i, j in v1 do
        j(...)
    end
end

function u17.interface.SendMessage(a1, a2, ...) -- Line: 69 -- upvalues: u17 (val) -- types: a1: table, a2: string
    table.insert(u17.internal.MessageQueue, {a2, {...}})
end

function u17.interface.SubscribeToTopic(a1, a2, a3) -- Line: 76
    -- upvalues: u17 (val)
    if not u17.internal.TopicCallbacks[a2] then
        u17.internal.TopicCallbacks[a2] = {}
    end
    local u15 = u17.internal.TopicCallbacks[a2]
    table.insert(u15, a3)
    return function() -- Line: 84 -- upvalues: u15 (val), a3 (val)
        table.remove(u15, (table.find(u15, a3)))
    end
end

u17.internal.listenToNetworkTraffic()
u17.internal.initiateTrafficHeartbeat()
return u17.interface