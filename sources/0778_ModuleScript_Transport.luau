-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local v1 = {};
local table_freeze_ret = table.freeze({
    Commands = "UnreliableRemoteEvent",
    OwnerSnapshot = "UnreliableRemoteEvent",
    RemoteSnapshot = "UnreliableRemoteEvent",
    BotCombat = "UnreliableRemoteEvent",
    Control = "RemoteEvent",
    Trace = "RemoteEvent",
    Diagnostics = "RemoteEvent"
});

local function validateRemote(p2: userdata, p3: string, p4: string) -- Line: 32
    if p2.ClassName ~= p4 then
        error(`MovementV2 transport {p3} must be {p4}, found {p2.ClassName}`, 3);
    end;

    return p2;
end;

local function getOrCreateServerFolder() -- Line: 39
    -- upvalues: ReplicatedStorage (copy)
    local MovementV2Remotes = ReplicatedStorage:FindFirstChild("MovementV2Remotes");

    if MovementV2Remotes ~= nil then
        local v5 = MovementV2Remotes:IsA("Folder");
        assert(v5, "ReplicatedStorage.MovementV2Remotes must be a Folder");

        return MovementV2Remotes;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "MovementV2Remotes";
    Folder.Parent = ReplicatedStorage;

    return Folder;
end;

local function resolveServerChannels() -- Line: 52
    -- upvalues: RunService (copy), ReplicatedStorage (copy), table_freeze_ret (copy)
    local v6 = RunService:IsServer();
    assert(v6, "Transport.getServerChannels is server-only");
    local MovementV2Remotes = ReplicatedStorage:FindFirstChild("MovementV2Remotes");

    if MovementV2Remotes == nil then
        MovementV2Remotes = Instance.new("Folder");
        MovementV2Remotes.Name = "MovementV2Remotes";
        MovementV2Remotes.Parent = ReplicatedStorage;
    else
        local v7 = MovementV2Remotes:IsA("Folder");
        assert(v7, "ReplicatedStorage.MovementV2Remotes must be a Folder");
    end;

    local v8 = {};

    for i, v in table_freeze_ret do
        local v9 = MovementV2Remotes:FindFirstChild(i);

        if v9 == nil then
            v9 = Instance.new(v);
            v9.Name = i;
            v9.Parent = MovementV2Remotes;
        end;

        if v9.ClassName ~= v then
            error(`MovementV2 transport {i} must be {v}, found {v9.ClassName}`, 3);
        end;

        v8[i] = v9;
    end;

    return table.freeze(v8);
end;

local function resolveClientChannels() -- Line: 70
    -- upvalues: RunService (copy), ReplicatedStorage (copy), table_freeze_ret (copy)
    local v10 = RunService:IsClient();
    assert(v10, "Transport.getClientChannels is client-only");
    local MovementV2Remotes = ReplicatedStorage:WaitForChild("MovementV2Remotes");
    local v11 = MovementV2Remotes:IsA("Folder");
    assert(v11, "ReplicatedStorage.MovementV2Remotes must be a Folder");
    local v12 = {};

    for i, v in table_freeze_ret do
        local v13 = MovementV2Remotes:WaitForChild(i);

        if v13.ClassName ~= v then
            error(`MovementV2 transport {i} must be {v}, found {v13.ClassName}`, 3);
        end;

        v12[i] = v13;
    end;

    return table.freeze(v12);
end;

local u14 = nil;
local u15 = nil;

function v1.getServerChannels() -- Line: 87
    -- upvalues: u14 (ref), resolveServerChannels (copy)
    if u14 == nil then
        u14 = resolveServerChannels();
    end;

    return u14;
end;

function v1.getClientChannels() -- Line: 94
    -- upvalues: u15 (ref), resolveClientChannels (copy)
    if u15 == nil then
        u15 = resolveClientChannels();
    end;

    return u15;
end;

return table.freeze(v1);