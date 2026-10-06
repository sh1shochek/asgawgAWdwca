-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(script.Parent.Parent.Shared.Constants);
local u1 = {
    internal = {
        NetworkTrafficRemote = nil,
        TopicCallbacks = {},
        MessageQueue = {}
    },
    interface = {}
};

function u1.internal.listenToNetworkTraffic() -- Line: 20
    -- upvalues: ReplicatedStorage (copy), Constants (copy), u1 (copy)
    local v2 = ReplicatedStorage:WaitForChild(Constants.NETWORK_TRAFFIC_REMOTE_NAME);
    v2.OnClientEvent:Connect(function(p3: table) -- Line: 23
        -- upvalues: u1 (ref)
        for _, v in p3 do
            local v4 = v[1];
            local v5 = v[2];

            if v4 and v5 then
                u1.internal.invokeTopic(v4, table.unpack(v5));
            end;
        end;
    end);
    u1.internal.NetworkTrafficRemote = v2;
    v2:FireServer("_ready_");
end;

function u1.internal.initiateTrafficHeartbeat() -- Line: 41
    -- upvalues: u1 (copy), RunService (copy)
    if not u1.internal.NetworkTrafficRemote then
        return;
    end;

    RunService.Heartbeat:Connect(function() -- Line: 46
        -- upvalues: u1 (ref)
        if #u1.internal.MessageQueue <= 0 then
            return;
        end;

        u1.internal.NetworkTrafficRemote:FireServer(u1.internal.MessageQueue);
        u1.internal.MessageQueue = {};
    end);
end;

function u1.internal.invokeTopic(p6: string, ...) -- Line: 57
    -- upvalues: u1 (copy)
    local v7 = u1.internal.TopicCallbacks[p6];

    if not v7 then
        return;
    end;

    for _, v in v7 do
        v(...);
    end;
end;

function u1.interface.SendMessage(p8: table, p9: string, ...) -- Line: 69
    -- upvalues: u1 (copy)
    table.insert(u1.internal.MessageQueue, {
        p9,
        { ... }
    });
end;

function u1.interface.SubscribeToTopic(p10: table, p11: string, u12: function) -- Line: 76
    -- upvalues: u1 (copy)
    if not u1.internal.TopicCallbacks[p11] then
        u1.internal.TopicCallbacks[p11] = {};
    end;

    local u13 = u1.internal.TopicCallbacks[p11];
    table.insert(u13, u12);

    return function() -- Line: 84
        -- upvalues: u13 (copy), u12 (copy)
        local table_find_ret = table.find(u13, u12);
        table.remove(u13, table_find_ret);
    end;
end;

u1.internal.listenToNetworkTraffic();
u1.internal.initiateTrafficHeartbeat();

return u1.interface;