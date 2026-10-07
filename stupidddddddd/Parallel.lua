-- ReplicatedStorage.Packages.Parallel
-- Script path: ReplicatedStorage.Packages.Parallel
-- Decompile time: 3.54 ms

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")
local Promise = require(script.Parent.Promise)
local ClientActor = script.ClientActor
local ServerActor = script.ServerActor
local u29 = nil

local function getOrFindWorkerFolder() -- Line: 30
    -- upvalues: u29 (ref), RunService (val), ServerScriptService (val), Players (val)
    if u29 == nil then
        if not RunService:IsServer() then
            local PlayerScripts = Players.LocalPlayer:FindFirstChild("PlayerScripts")
            u29 = PlayerScripts:FindFirstChild("ParallelWorkers") or Instance.new("Folder")
            u29.Name = "ParallelWorkers"
            u29.Parent = PlayerScripts
        else
            u29 = ServerScriptService:FindFirstChild("ParallelWorkers") or Instance.new("Folder")
            u29.Name = "ParallelWorkers"
            u29.Parent = ServerScriptService
        end
    end
    return u29
end

local function createTemplatedActor(a1) -- Line: 47
    -- upvalues: RunService (val), ServerActor (val), ClientActor (val)
    local v1 = if not RunService:IsServer() then ClientActor:Clone() else ServerActor:Clone()
    local v2 = a1:Clone()
    v2.Name = "Runnable"
    v2.Parent = v1
    return v1, v1:FindFirstChild("Worker")
end

local function waitForActorInit(a1) -- Line: 61 -- upvalues: Promise (val) -- types: a1: userdata
    return Promise.new(function(a1_2) -- Line: 62 -- upvalues: a1 (val)
        while a1:GetAttribute("Initialized") == nil do
            task.wait()
        end
        a1_2(a1)
    end)
end

local u33 = {}
u33.__index = u33

function u33.of(a1) -- Line: 74 -- upvalues: u33 (val), getOrFindWorkerFolder (val) -- types: a1: userdata
    local v1 = false
    if typeof(a1) == "Instance" then
        v1 = a1:IsA("ModuleScript")
    end
    assert(v1, "Runnable must be a ModuleScript reference")
    v1 = {
        _name = "ParallelWorker",
        _actorCount = 1,
        _actorIndex = 1,
        _destroyed = false,
        _runnable = a1,
        _bindableEvent = Instance.new("BindableEvent"),
        _folder = Instance.new("Folder"),
        _actors = {},
        _actorState = {},
        _results = {},
    }
    local u26 = setmetatable(v1, u33)
    u26._connection = u26._bindableEvent.Event:Connect(function(a1, ...) -- Line: 92 -- upvalues: u26 (val) -- types: a1: string
        u26._results[a1] = {...}
    end)
    u26._bindableEvent.Parent = u26._folder
    u26._folder.Parent = getOrFindWorkerFolder()
    u26:_createActors()
    return u26
end

function u33.withName(a1, a2) -- Line: 101 -- types: a1: table, a2: string
    assert(not a1._destroyed, "Parallel destroyed")
    assert(type(a2) == "string", "Name must be a string")
    assert(#a2 > 0, "Name must be non-empty")
    a1._name = a2
    a1._folder.Name = a2
    return a1
end

function u33.withActors(a1, a2) -- Line: 110 -- types: a1: table, a2: number
    assert(not a1._destroyed, "Parallel destroyed")
    assert(type(a2) == "number", "Actor count must be a number")
    assert(a2 > 0, "Actor count must be greater than 0")
    a1._actorCount = a2
    a1._actorIndex = math.min(a1._actorIndex, a2)
    a1:_createActors()
    return a1
end

function u33.run(a1, ...) -- Line: 120 -- upvalues: Promise (val), waitForActorInit (val)
    assert(not a1._destroyed, "Parallel destroyed")
    local u6 = {}
    u6[1] = ...
    return ((Promise.promisify(a1._findActor)(a1)):andThen(waitForActorInit)):andThen(function(a1) -- Line: 123 -- upvalues: u6 (val) -- types: a1: userdata
        a1:SendMessage("Parallel:Run", (table.unpack(u6)))
    end)
end

function u33.submit(a1, ...) -- Line: 128 -- upvalues: HttpService (val), Promise (val)
    assert(not a1._destroyed, "Parallel destroyed")
    local u6 = {}
    u6[1] = ...
    local u10 = a1:_findActor()
    local u15 = HttpService:GenerateGUID(false)
    local u16 = nil
    u16 = (((Promise.new(function(a1) -- Line: 62 -- upvalues: u10 (val)
        while u10:GetAttribute("Initialized") == nil do
            task.wait()
        end
        a1(u10)
    end)):andThen(function() -- Line: 146 -- upvalues: u10 (val), u15 (val), u6 (val)
        u10:SendMessage("Parallel:SubmitTask", u15, (table.unpack(u6)))
    end)):andThen(function() -- Line: 149 -- upvalues: a1 (val), u15 (val)
        while a1._results[u15] == nil do
            task.wait()
        end
        return table.unpack(a1._results[u15])
    end)):finally(function(a1_2) -- Line: 135 -- upvalues: u10 (val), u15 (val), a1 (val), u16 (ref) -- types: a1_2: string
        if a1_2 == "Cancelled" or a1_2 == "Rejected" then
            u10:SendMessage("Parallel:CancelTask", u15)
        end
        a1._results[u15] = nil
        local v1 = a1._actorState[u10]
        v1.count = v1.count - 1
        a1._actorState[u10].running[u16] = nil
    end)
    local v1 = a1._actorState[u10]
    v1.count = v1.count + 1
    a1._actorState[u10].running[u16] = true
    return u16
end

function u33.destroy(a1) -- Line: 162
    assert(not a1._destroyed, "Parallel already destroyed")
    a1._destroyed = true
    a1._connection:Disconnect()
    a1._connection = nil
    local v1 = nil
    local v2 = nil
    local v3 = a1
    for i, j in a1._actors, v1, v2 do
        for k, n in v3._actorState[j].running do
            k:cancel()
        end
        j:SendMessage("Parallel:Destroy")
    end
    v3._actors = {}
    v3._actorState = {}
    v3._results = {}
    v3._bindableEvent:Destroy()
    v3._bindableEvent = nil
    v3._folder:Destroy()
    v3._folder = nil
end

function u33:_findActor() -- Line: 185
    assert(#self._actors > 0, "No actors")
    local v1 = self._actors[self._actorIndex]
    self._actorIndex = self._actorIndex + 1
    local _actorIndex = self._actorIndex
    if #self._actors < _actorIndex then
        self._actorIndex = 1
    end
    return v1
end

function u33:_createActors() -- Line: 197 -- upvalues: RunService (val), ServerActor (val), ClientActor (val)
    local Worker, _runnable, v1, v2, v3
    local v4 = self._actorCount - #self._actors
    local v5 = self
    for i = 1, v4 do
        _runnable = v5._runnable
        v2 = if not RunService:IsServer() then ClientActor:Clone() else ServerActor:Clone()
        v3 = _runnable:Clone()
        v3.Name = "Runnable"
        v3.Parent = v2
        v1 = v2
        Worker = v2:FindFirstChild("Worker")
        v1.Parent = v5._folder
        Worker.Disabled = false
        v5._actorState[v1] = {count = 0, running = {}}
        table.insert(v5._actors, v1)
    end
end

function u33.__tostring(a1) -- Line: 211
    return string.format("Parallel<%s>", a1._name)
end

return u33