-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local ServerScriptService = game:GetService("ServerScriptService");
local Promise = require(script.Parent.Promise);
local script_ClientActor = script.ClientActor;
local script_ServerActor = script.ServerActor;
local u1 = nil;

local function getOrFindWorkerFolder() -- Line: 30
    -- upvalues: u1 (ref), RunService (copy), ServerScriptService (copy), Players (copy)
    if u1 == nil then
        if RunService:IsServer() then
            u1 = ServerScriptService:FindFirstChild("ParallelWorkers") or Instance.new("Folder");
            u1.Name = "ParallelWorkers";
            u1.Parent = ServerScriptService;
        else
            local PlayerScripts = Players.LocalPlayer:FindFirstChild("PlayerScripts");
            u1 = PlayerScripts:FindFirstChild("ParallelWorkers") or Instance.new("Folder");
            u1.Name = "ParallelWorkers";
            u1.Parent = PlayerScripts;
        end;
    end;

    return u1;
end;

local function createTemplatedActor(p2: userdata) -- Line: 47
    -- upvalues: RunService (copy), script_ServerActor (copy), script_ClientActor (copy)
    local v3;

    if RunService:IsServer() then
        v3 = script_ServerActor:Clone();
    else
        v3 = script_ClientActor:Clone();
    end;

    local v4 = p2:Clone();
    v4.Name = "Runnable";
    v4.Parent = v3;

    return v3, v3:FindFirstChild("Worker");
end;

local function waitForActorInit(u5: userdata) -- Line: 61
    -- upvalues: Promise (copy)
    return Promise.new(function(p6) -- Line: 62
        -- upvalues: u5 (copy)
        while u5:GetAttribute("Initialized") == nil do
            task.wait();
        end;

        p6(u5);
    end);
end;

local u7 = {};
u7.__index = u7;

function u7.of(p8: userdata) -- Line: 74
    -- upvalues: u7 (copy), getOrFindWorkerFolder (copy)
    local v9;

    if typeof(p8) == "Instance" then
        v9 = p8:IsA("ModuleScript");
    else
        v9 = false;
    end;

    assert(v9, "Runnable must be a ModuleScript reference");
    local v10 = {
        _name = "ParallelWorker",
        _actorCount = 1,
        _actorIndex = 1,
        _connection = nil,
        _destroyed = false,
        _runnable = p8,
        _bindableEvent = Instance.new("BindableEvent"),
        _folder = Instance.new("Folder"),
        _actors = {},
        _actorState = {},
        _results = {}
    };
    local u11 = setmetatable(v10, u7);
    u11._connection = u11._bindableEvent.Event:Connect(function(p12: string, ...) -- Line: 92
        -- upvalues: u11 (copy)
        u11._results[p12] = { ... };
    end);
    u11._bindableEvent.Parent = u11._folder;
    u11._folder.Parent = getOrFindWorkerFolder();
    u11:_createActors();

    return u11;
end;

function u7.withName(p13: table, p14: string) -- Line: 101
    assert(not p13._destroyed, "Parallel destroyed");
    local v15 = type(p14) == "string";
    assert(v15, "Name must be a string");
    assert(#p14 > 0, "Name must be non-empty");
    p13._name = p14;
    p13._folder.Name = p14;

    return p13;
end;

function u7.withActors(p16: table, p17: number) -- Line: 110
    assert(not p16._destroyed, "Parallel destroyed");
    local v18 = type(p17) == "number";
    assert(v18, "Actor count must be a number");
    assert(p17 > 0, "Actor count must be greater than 0");
    p16._actorCount = p17;
    p16._actorIndex = math.min(p16._actorIndex, p17);
    p16:_createActors();

    return p16;
end;

function u7.run(p19, ...) -- Line: 120
    -- upvalues: Promise (copy), waitForActorInit (copy)
    assert(not p19._destroyed, "Parallel destroyed");
    local u20 = { ... };

    return Promise.promisify(p19._findActor)(p19):andThen(waitForActorInit):andThen(function(p21: userdata) -- Line: 123
        -- upvalues: u20 (copy)
        p21:SendMessage("Parallel:Run", table.unpack(u20));
    end);
end;

function u7.submit(u22, ...) -- Line: 128
    -- upvalues: HttpService (copy), Promise (copy)
    assert(not u22._destroyed, "Parallel destroyed");
    local u23 = { ... };
    local u24 = u22:_findActor();
    local u25 = HttpService:GenerateGUID(false);
    local u26 = nil;

    local function cleanup(p27: string) -- Line: 135
        -- upvalues: u24 (copy), u25 (copy), u22 (copy), u26 (ref)
        if p27 == "Cancelled" or p27 == "Rejected" then
            u24:SendMessage("Parallel:CancelTask", u25);
        end;

        u22._results[u25] = nil;
        local v28 = u22._actorState[u24];
        v28.count = v28.count - 1;
        u22._actorState[u24].running[u26] = nil;
    end;

    u26 = Promise.new(function(p29) -- Line: 62
        -- upvalues: u24 (copy)
        while u24:GetAttribute("Initialized") == nil do
            task.wait();
        end;

        p29(u24);
    end):andThen(function() -- Line: 146
        -- upvalues: u24 (copy), u25 (copy), u23 (copy)
        u24:SendMessage("Parallel:SubmitTask", u25, table.unpack(u23));
    end):andThen(function() -- Line: 149
        -- upvalues: u22 (copy), u25 (copy)
        while u22._results[u25] == nil do
            task.wait();
        end;

        return table.unpack(u22._results[u25]);
    end):finally(cleanup);
    local v30 = u22._actorState[u24];
    v30.count = v30.count + 1;
    u22._actorState[u24].running[u26] = true;

    return u26;
end;

function u7.destroy(p31) -- Line: 162
    assert(not p31._destroyed, "Parallel already destroyed");
    p31._destroyed = true;
    p31._connection:Disconnect();
    p31._connection = nil;

    for _, v in p31._actors do
        for i, _ in p31._actorState[v].running do
            i:cancel();
        end;

        v:SendMessage("Parallel:Destroy");
    end;

    p31._actors = {};
    p31._actorState = {};
    p31._results = {};
    p31._bindableEvent:Destroy();
    p31._bindableEvent = nil;
    p31._folder:Destroy();
    p31._folder = nil;
end;

function u7._findActor(p32) -- Line: 185
    assert(#p32._actors > 0, "No actors");
    local v33 = p32._actors[p32._actorIndex];
    p32._actorIndex = p32._actorIndex + 1;

    if p32._actorIndex > #p32._actors then
        p32._actorIndex = 1;
    end;

    return v33;
end;

function u7._createActors(p34) -- Line: 197
    -- upvalues: RunService (copy), script_ServerActor (copy), script_ClientActor (copy)
    for i = 1, p34._actorCount - #p34._actors do
        local _runnable = p34._runnable;
        local v35;

        if RunService:IsServer() then
            v35 = script_ServerActor:Clone();
        else
            v35 = script_ClientActor:Clone();
        end;

        local v36 = _runnable:Clone();
        v36.Name = "Runnable";
        v36.Parent = v35;
        local Worker = v35:FindFirstChild("Worker");
        v35.Parent = p34._folder;
        Worker.Disabled = false;
        p34._actorState[v35] = {
            count = 0,
            running = {}
        };
        table.insert(p34._actors, v35);
        local _ = i;
    end;
end;

function u7.__tostring(p37) -- Line: 211
    return string.format("Parallel<%s>", p37._name);
end;

return u7;