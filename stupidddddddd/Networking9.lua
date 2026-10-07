-- ReplicatedStorage.Packages.DebugTools.Server.Networking
-- Script path: ReplicatedStorage.Packages.DebugTools.Server.Networking
-- Decompile time: 1.94 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Parent = script.Parent.Parent
local Shared = Parent.Shared
local Signal = require(Shared.Signal)
local Constants = require(Shared.Constants)
local Authorization = require(Parent.Server.Authorization)
local u29 = {internal = {TopicCallbacks = {}, NetworkTargets = {}}}
u29.interface = {NetworkTargetAdded = Signal.new(), NetworkTargetRemoved = Signal.new()}

function u29.internal.playerRemoving(a1) -- Line: 25 -- upvalues: u29 (val) -- types: a1: userdata
    if not u29.internal.NetworkTargets[a1] then
        return
    end
    u29.internal.NetworkTargets[a1] = nil
    u29.interface.NetworkTargetRemoved:Fire(a1)
end

function u29.internal.registerNetworkTarget(a1) -- Line: 35
    -- upvalues: u29 (val), Authorization (val)
    if u29.internal.NetworkTargets[a1] or not Authorization.isPlayerAuthorized(a1) then
        return
    end
    u29.internal.NetworkTargets[a1] = {MessageQueue = {}}
    u29.interface.NetworkTargetAdded:Fire(a1)
end

function u29.internal.createTrafficRemote() -- Line: 53 -- upvalues: Constants (val), ReplicatedStorage (val), u29 (val)
    local RemoteEvent = Instance.new("RemoteEvent")
    RemoteEvent.Name = Constants.NETWORK_TRAFFIC_REMOTE_NAME
    RemoteEvent.Parent = ReplicatedStorage
    u29.internal.NetworkTrafficRemote = RemoteEvent
end

function u29.internal.listenToNetworkTraffic() -- Line: 61 -- upvalues: u29 (val), Authorization (val)
    u29.internal.NetworkTrafficRemote.OnServerEvent:Connect(function(a1, a2) -- Line: 63 -- upvalues: Authorization (upval), u29 (upval) -- types: a1: userdata
        local v1, v2
        if not Authorization.isPlayerAuthorized(a1) then
            a1:Kick("Attempted to perform unauthorized action.")
            return
        end
        if a2 == "_ready_" then
            u29.internal.registerNetworkTarget(a1)
            return
        end
        if typeof(a2) ~= "table" then
            return
        end
        for i, j in a2 do
            v1 = j[1]
            v2 = j[2]
            if v1 and v2 then
                u29.internal.invokeTopic(v1, a1, table.unpack(v2))
            end
        end
    end)
end

function u29.internal.initiateTrafficHeartbeat() -- Line: 92 -- upvalues: RunService (val), u29 (val), Players (val)
    RunService.Heartbeat:Connect(function() -- Line: 93 -- upvalues: u29 (upval)
        local MessageQueue, NetworkTrafficRemote
        for i, j in u29.internal.NetworkTargets do
            if not (#j.MessageQueue <= 0) then
                NetworkTrafficRemote = u29.internal.NetworkTrafficRemote
                MessageQueue = j.MessageQueue
                NetworkTrafficRemote:FireClient(i, MessageQueue)
                j.MessageQueue = {}
            end
        end
    end)
    Players.PlayerRemoving:Connect(function(a1) -- Line: 105 -- upvalues: u29 (upval) -- types: a1: userdata
        u29.internal.playerRemoving(a1)
    end)
end

function u29.internal.invokeTopic(a1, a2, ...) -- Line: 110 -- upvalues: u29 (val) -- types: a1: string, a2: userdata
    local v1 = u29.internal.TopicCallbacks[a1]
    if not v1 then
        return
    end
    for i, j in v1 do
        j(a2, ...)
    end
end

function u29.interface.SendMessageToPlayer(a1, a2, a3, ...) -- Line: 122
    -- upvalues: u29 (val)
    if not u29.internal.NetworkTargets[a2] then
        return
    end
    table.insert(u29.internal.NetworkTargets[a2].MessageQueue, {a3, {...}})
end

function u29.interface.SendMessage(a1, a2, ...) -- Line: 133 -- upvalues: u29 (val) -- types: a1: table, a2: string
    for i in u29.internal.NetworkTargets do
        u29.interface:SendMessageToPlayer(i, a2, ...)
    end
end

function u29.interface.SubscribeToTopic(a1, a2, a3) -- Line: 139
    -- upvalues: u29 (val)
    if not u29.internal.TopicCallbacks[a2] then
        u29.internal.TopicCallbacks[a2] = {}
    end
    local u15 = u29.internal.TopicCallbacks[a2]
    table.insert(u15, a3)
    return function() -- Line: 147 -- upvalues: u15 (val), a3 (val)
        table.remove(u15, (table.find(u15, a3)))
    end
end

function u29.interface.GetNetworkTargets(a1) -- Line: 153 -- upvalues: u29 (val)
    local v1 = {}
    for i in u29.internal.NetworkTargets do
        table.insert(v1, i)
    end
    return v1
end

u29.internal.createTrafficRemote()
u29.internal.listenToNetworkTraffic()
u29.internal.initiateTrafficHeartbeat()
return u29.interface