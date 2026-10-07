-- ReplicatedStorage.Controllers.RunServiceController
-- Script path: ReplicatedStorage.Controllers.RunServiceController
-- Decompile time: 4.02 ms

local u0 = {}
local RunService = game:GetService("RunService")
local Profiler = require(game:GetService("ReplicatedStorage").Shared.Profiler)
local u15 = {}
local u16 = 0
local u17 = 0

local function newScheduler(a1) -- Line: 53 -- types: a1: string
    return {
        NeedsCompact = false,
        NeedsSort = false,
        Stepping = false,
        EventName = a1,
        ProfileLabel = ("RunServiceController.%*"):format(a1),
        Bindings = {},
        BindingsByName = {},
        StepBindings = {},
        RenderPriorityBindings = {},
        RenderStepNames = {},
    }
end

local u19 = {}
u19.Heartbeat = newScheduler("Heartbeat")
u19.RenderStepped = newScheduler("RenderStepped")
u19.Stepped = newScheduler("Stepped")
u19.PostSimulation = newScheduler("PostSimulation")

local function getTraceback(a1) -- Line: 79
    return debug.traceback(tostring(a1), 2)
end

local function isDynamicNameSegment(a1) -- Line: 83 -- types: a1: string
    local v1 = true
    if tonumber(a1) == nil then
        v1 = true
        if string.find(a1, "-", 1, true) == nil then
            v1 = false
            if #a1 >= 8 then
                v1 = string.find(a1, "%d") ~= nil
            end
        end
    end
    return v1
end

local function getBindingProfileLabel(a1, a2) -- Line: 89 -- types: a1: string, a2: string
    local v1
    local v2 = table.create(8)
    for i, v in ipairs(string.split(a2, ".")) do
        v1 = true
        if tonumber(v) == nil then
            v1 = true
            if string.find(v, "-", 1, true) == nil then
                v1 = false
                if #v >= 8 then
                    v1 = string.find(v, "%d") ~= nil
                end
            end
        end
        table.insert(v2, if not v1 then v else "#")
    end
    return (("RunService.%*.%*"):format(a1, (table.concat(v2, "."))))
end

local function syncSchedulerConnections(a1) -- Line: 99 -- upvalues: RunService (val) -- types: a1: table
    local v1
    if #a1.StepBindings == 0 and a1.Connection then
        a1.Connection:Disconnect()
        a1.Connection = nil
    end
    local v2 = a1
    for k, v in pairs(a1.RenderStepNames) do
        v1 = v2.RenderPriorityBindings[k]
        if not v1 or #v1 == 0 then
            RunService:UnbindFromRenderStep(v)
            v2.RenderStepNames[k] = nil
        end
    end
end

local function rebuildScheduler(a1) -- Line: 114 -- upvalues: syncSchedulerConnections (val) -- types: a1: table
    local v1, v2
    local v3 = 1
    local v4 = #a1.Bindings
    for i = 1, v4 do
        v1 = a1.Bindings[i]
        if v1.Connected then
            a1.Bindings[v3] = v1
            v3 = v3 + 1
        end
    end
    v4 = #a1.Bindings
    for j = v3, v4 do
        a1.Bindings[j] = nil
    end
    table.sort(a1.Bindings, function(a1, a2) -- Line: 129
        if a1.Priority == a2.Priority then
            return a1.Sequence < a2.Sequence
        end
        return a1.Priority < a2.Priority
    end)
    table.clear(a1.StepBindings)
    table.clear(a1.RenderPriorityBindings)
    for i2, v in ipairs(a1.Bindings) do
        if not v.UsesRenderPriority then
            table.insert(a1.StepBindings, v)
        else
            v2 = a1.RenderPriorityBindings[v.Priority]
            if not v2 then
                a1.RenderPriorityBindings[v.Priority] = {}
            end
            table.insert(v2, v)
        end
    end
    a1.NeedsCompact = false
    a1.NeedsSort = false
    syncSchedulerConnections(a1)
end

local u37 = 0

local function invokeBinding(a1, ...) -- Line: 163 -- upvalues: u37 (ref), getTraceback (val)
    debug.profilebegin(a1.ProfileLabel)
    local v1 = u37
    local success, result = xpcall(a1.Callback, getTraceback, ...)
    if v1 == u37 then
        debug.profileend()
    end
    if not success then
        warn((("[RunServiceController] %* binding \"%*\" failed:\n%*"):format(a1.EventName, a1.Name, result)))
    end
end

local function stepScheduler(a1, a2, ...) -- Line: 175
    -- upvalues: u37 (ref), Profiler (val), rebuildScheduler (val), u15 (val), invokeBinding (val)
    local v1
    u37 = u37 + 1
    Profiler.mark(a1.ProfileLabel)
    if a1.NeedsCompact or a1.NeedsSort then
        rebuildScheduler(a1)
    end
    a1.Stepping = true
    local StepBindings = if a2 ~= nil then a1.RenderPriorityBindings[a2] or u15 else a1.StepBindings
    local v2 = #StepBindings
    for i = 1, v2 do
        v1 = StepBindings[i]
        if v1 and v1.Connected then
            invokeBinding(v1, ...)
        end
    end
    a1.Stepping = false
    if a1.NeedsCompact or a1.NeedsSort then
        rebuildScheduler(a1)
    end
end

local function ensureSchedulerConnection(a1, a2, a3) -- Line: 203
    -- upvalues: RunService (val), stepScheduler (val)
    if not a3 then
        if not a1.Connection then
            a1.Connection = RunService[a1.EventName]:Connect(function(...) -- Line: 216 -- upvalues: stepScheduler (upval), a1 (val)
                stepScheduler(a1, nil, ...)
            end)
        elseif not a1.Connection.Connected then
            a1.Connection = RunService[a1.EventName]:Connect(function(...) -- Line: 216 -- upvalues: stepScheduler (upval), a1 (val)
                stepScheduler(a1, nil, ...)
            end)
        end
        return
    end
    if a1.RenderStepNames[a2] then
        return
    end
    local v1 = ("RunServiceController.RenderStepped.%*"):format(a2)
    a1.RenderStepNames[a2] = v1
    RunService:BindToRenderStep(v1, a2, function(a1_2) -- Line: 211 -- upvalues: stepScheduler (upval), a1 (val), a2 (val) -- types: a1_2: number
        stepScheduler(a1, a2, a1_2)
    end)
end

local function disconnectBinding(a1, a2) -- Line: 222 -- upvalues: rebuildScheduler (val) -- types: a1: table
    if not a2.Connected then
        return
    end
    a2.Connected = false
    if a1.BindingsByName[a2.Name] == a2 then
        a1.BindingsByName[a2.Name] = nil
    end
    a1.NeedsCompact = true
    if not a1.Stepping then
        rebuildScheduler(a1)
    end
end

local function createBinding(a1, a2, a3, a4, a5) -- Line: 238
    -- upvalues: u19 (val), rebuildScheduler (val), u16 (ref), getBindingProfileLabel (val)
    -- upvalues: ensureSchedulerConnection (val)
    local v1 = false
    if type(a2) == "string" then
        v1 = a2 ~= ""
    end
    assert(v1, "RunServiceController binding name must be a non-empty string")
    assert(type(a3) == "number", "RunServiceController binding priority must be a number")
    assert(type(a4) == "function", "RunServiceController callback must be a function")
    local u40 = u19[a1]
    v1 = u40.BindingsByName[a2]
    if v1 and v1.Connected then
        v1.Connected = false
        if u40.BindingsByName[v1.Name] == v1 then
            u40.BindingsByName[v1.Name] = nil
        end
        u40.NeedsCompact = true
        if not u40.Stepping then
            rebuildScheduler(u40)
        end
    end
    u16 = u16 + 1
    local u62 = {
        Connected = true,
        Name = a2,
        EventName = a1,
        Priority = a3,
        Callback = a4,
    }
    u62.ProfileLabel = getBindingProfileLabel(a1, a2)
    u62.Sequence = u16
    u62.UsesRenderPriority = a5

    function u62.Disconnect(a1) -- Line: 268 -- upvalues: u40 (val), u62 (val), rebuildScheduler (upval)
        local v1 = u40
        local v2 = u62
        if not v2.Connected then
            return
        end
        v2.Connected = false
        if v1.BindingsByName[v2.Name] == v2 then
            v1.BindingsByName[v2.Name] = nil
        end
        v1.NeedsCompact = true
        if not v1.Stepping then
            rebuildScheduler(v1)
        end
    end

    u62.Destroy = u62.Disconnect
    table.insert(u40.Bindings, u62)
    u40.BindingsByName[a2] = u62
    u40.NeedsSort = true
    ensureSchedulerConnection(u40, a3, a5)
    return u62
end

function u0.CreateBindingName(a1) -- Line: 285 -- upvalues: u17 (ref) -- types: a1: string
    local v1 = false
    if type(a1) == "string" then
        v1 = a1 ~= ""
    end
    assert(v1, "RunServiceController binding prefix must be a non-empty string")
    u17 = u17 + 1
    return (("%*.%*"):format(a1, u17))
end

function u0.BindToHeartbeat(a1, a2, a3) -- Line: 292
    -- upvalues: createBinding (val)
    return (createBinding("Heartbeat", a1, a3 or 0, a2, false))
end

function u0.BindToRenderStep(a1, a2, a3) -- Line: 296
    -- upvalues: createBinding (val)
    if a3 ~= nil then
        return (createBinding("RenderStepped", a1, a2, a3, true))
    end
    return (createBinding("RenderStepped", a1, 0, a2, false))
end

function u0.BindToRenderSteppedEvent(a1, a2, a3) -- Line: 307
    -- upvalues: createBinding (val)
    return (createBinding("RenderStepped", a1, a3 or 0, a2, false))
end

function u0.BindToStepped(a1, a2, a3) -- Line: 315
    -- upvalues: createBinding (val)
    return (createBinding("Stepped", a1, a3 or 0, a2, false))
end

function u0.BindToPostSimulation(a1, a2, a3) -- Line: 323
    -- upvalues: createBinding (val)
    return (createBinding("PostSimulation", a1, a3 or 0, a2, false))
end

function u0.Unbind(a1, a2) -- Line: 331 -- upvalues: u19 (val), rebuildScheduler (val) -- types: a1: string, a2: string
    local v1 = u19[a1].BindingsByName[a2]
    if v1 then
        local v2 = u19[a1]
        if not v1.Connected then
            return
        end
        v1.Connected = false
        if v2.BindingsByName[v1.Name] == v1 then
            v2.BindingsByName[v1.Name] = nil
        end
        v2.NeedsCompact = true
        if not v2.Stepping then
            rebuildScheduler(v2)
        end
    end
end

function u0.UnbindFromRenderStep(a1) -- Line: 338 -- upvalues: u0 (val) -- types: a1: string
    u0.Unbind("RenderStepped", a1)
end

return u0