-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Parent = script.Parent.Parent;
local Shared = Parent.Shared;
local Signal = require(Shared.Signal);
local Constants = require(Shared.Constants);
local Authorization = require(Parent.Server.Authorization);
local u1 = {
    internal = {
        NetworkTrafficRemote = nil,
        TopicCallbacks = {},
        NetworkTargets = {}
    },
    interface = {
        NetworkTargetAdded = Signal.new(),
        NetworkTargetRemoved = Signal.new()
    }
};

function u1.internal.playerRemoving(p2: userdata) -- Line: 25
    -- upvalues: u1 (copy)
    if not u1.internal.NetworkTargets[p2] then
        return;
    end;

    u1.internal.NetworkTargets[p2] = nil;
    u1.interface.NetworkTargetRemoved:Fire(p2);
end;

function u1.internal.registerNetworkTarget(p3: userdata) -- Line: 35
    -- upvalues: u1 (copy), Authorization (copy)
    if u1.internal.NetworkTargets[p3] then
        return;
    end;

    if not Authorization.isPlayerAuthorized(p3) then
        return;
    end;

    u1.internal.NetworkTargets[p3] = {
        MessageQueue = {}
    };
    u1.interface.NetworkTargetAdded:Fire(p3);
end;

function u1.internal.createTrafficRemote() -- Line: 53
    -- upvalues: Constants (copy), ReplicatedStorage (copy), u1 (copy)
    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = Constants.NETWORK_TRAFFIC_REMOTE_NAME;
    RemoteEvent.Parent = ReplicatedStorage;
    u1.internal.NetworkTrafficRemote = RemoteEvent;
end;

function u1.internal.listenToNetworkTraffic() -- Line: 61
    -- upvalues: u1 (copy), Authorization (copy)
    u1.internal.NetworkTrafficRemote.OnServerEvent:Connect(function(p4: userdata, p5: any) -- Line: 63
        -- upvalues: Authorization (ref), u1 (ref)
        if not Authorization.isPlayerAuthorized(p4) then
            p4:Kick("Attempted to perform unauthorized action.");

            return;
        end;

        if p5 == "_ready_" then
            u1.internal.registerNetworkTarget(p4);

            return;
        end;

        if typeof(p5) ~= "table" then
            return;
        end;

        for _, v in p5 do
            local v6 = v[1];
            local v7 = v[2];

            if v6 and v7 then
                u1.internal.invokeTopic(v6, p4, table.unpack(v7));
            end;
        end;
    end);
end;

function u1.internal.initiateTrafficHeartbeat() -- Line: 92
    -- upvalues: RunService (copy), u1 (copy), Players (copy)
    RunService.Heartbeat:Connect(function() -- Line: 93
        -- upvalues: u1 (ref)
        for i, v in u1.internal.NetworkTargets do
            if #v.MessageQueue > 0 then
                u1.internal.NetworkTrafficRemote:FireClient(i, v.MessageQueue);
                v.MessageQueue = {};
            end;
        end;
    end);
    Players.PlayerRemoving:Connect(function(p8: userdata) -- Line: 105
        -- upvalues: u1 (ref)
        u1.internal.playerRemoving(p8);
    end);
end;

function u1.internal.invokeTopic(p9: string, p10: userdata, ...) -- Line: 110
    -- upvalues: u1 (copy)
    local v11 = u1.internal.TopicCallbacks[p9];

    if not v11 then
        return;
    end;

    for _, v in v11 do
        v(p10, ...);
    end;
end;

function u1.interface.SendMessageToPlayer(p12: table, p13: userdata, p14: string, ...) -- Line: 122
    -- upvalues: u1 (copy)
    if not u1.internal.NetworkTargets[p13] then
        return;
    end;

    table.insert(u1.internal.NetworkTargets[p13].MessageQueue, {
        p14,
        { ... }
    });
end;

function u1.interface.SendMessage(p15: table, p16: string, ...) -- Line: 133
    -- upvalues: u1 (copy)
    for i in u1.internal.NetworkTargets do
        u1.interface:SendMessageToPlayer(i, p16, ...);
    end;
end;

function u1.interface.SubscribeToTopic(p17: table, p18: string, u19: function) -- Line: 139
    -- upvalues: u1 (copy)
    if not u1.internal.TopicCallbacks[p18] then
        u1.internal.TopicCallbacks[p18] = {};
    end;

    local u20 = u1.internal.TopicCallbacks[p18];
    table.insert(u20, u19);

    return function() -- Line: 147
        -- upvalues: u20 (copy), u19 (copy)
        local table_find_ret = table.find(u20, u19);
        table.remove(u20, table_find_ret);
    end;
end;

function u1.interface.GetNetworkTargets(p21) -- Line: 153
    -- upvalues: u1 (copy)
    local v22 = {};

    for i in u1.internal.NetworkTargets do
        table.insert(v22, i);
    end;

    return v22;
end;

u1.internal.createTrafficRemote();
u1.internal.listenToNetworkTraffic();
u1.internal.initiateTrafficHeartbeat();

return u1.interface;