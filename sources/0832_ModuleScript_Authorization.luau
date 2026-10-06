-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Shared = script.Parent.Parent.Shared;
local Signal = require(Shared.Signal);
local Constants = require(Shared.Constants);
local u1 = {
    internal = {
        Players = {}
    },
    interface = {
        PlayerAuthorized = Signal.new()
    }
};

function u1.internal.playerAdded(p2: userdata) -- Line: 24
    -- upvalues: u1 (copy), RunService (copy), Constants (copy)
    u1.internal.Players[p2] = {
        Authorized = false,
        Authorizing = true
    };
    local v3 = RunService:IsStudio() or p2:GetRankInGroup(Constants.GROUP_ID) >= Constants.GROUP_RANK;

    if not u1.internal.Players[p2] then
        return;
    end;

    u1.internal.Players[p2].Authorized = v3;
    u1.internal.Players[p2].Authorizing = false;

    if not v3 then
        return;
    end;

    u1.interface.PlayerAuthorized:Fire(p2);
end;

function u1.internal.playerRemoved(p4: userdata) -- Line: 48
    -- upvalues: u1 (copy)
    if not u1.internal.Players[p4] then
        return;
    end;

    u1.internal.Players[p4] = nil;
end;

function u1.internal.listenToPlayers() -- Line: 56
    -- upvalues: Players (copy), u1 (copy)
    Players.PlayerAdded:Connect(function(p5: userdata) -- Line: 57
        -- upvalues: u1 (ref)
        u1.internal.playerAdded(p5);
    end);

    for _, v in Players:GetPlayers() do
        u1.internal.playerAdded(v);
    end;

    Players.PlayerRemoving:Connect(function(p6: userdata) -- Line: 65
        -- upvalues: u1 (ref)
        u1.internal.playerRemoved(p6);
    end);
end;

function u1.interface.isPlayerAuthorized(p7: userdata) -- Line: 70
    -- upvalues: RunService (copy), u1 (copy)
    if RunService:IsStudio() then
        return true;
    end;

    local v8 = u1.internal.Players[p7];

    if not v8 then
        return false;
    end;

    while u1.internal.Players[p7] and v8.Authorizing do
        task.wait();
    end;

    return u1.internal.Players[p7] and v8.Authorized;
end;

u1.internal.listenToPlayers();

return u1.interface;