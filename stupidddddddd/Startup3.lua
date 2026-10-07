-- Players.Caelclaw404.PlayerScripts.Startup
-- Script path: Players.Caelclaw404.PlayerScripts.Startup
-- Decompile time: 3.95 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
;(game:GetService("StarterGui")):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local u24 = {}
local u25 = 1
local u26 = 0
local u27 = false

local function getTraceback(a1) -- Line: 24
    return debug.traceback(tostring(a1), 2)
end

local function runPhase(a1, a2, a3, ...) -- Line: 28
    -- upvalues: Profiler (val), getTraceback (val)
    Profiler.mark((("Startup.Phase.%*"):format(a1)))
    local v1 = table.pack(xpcall(a3, getTraceback, ...))
    if v1[1] then
        return true, table.unpack(v1, 2, v1.n)
    end
    local v2 = warn
    local v3 = v1[2]
    v2((("[Startup] %* failed:\n%*"):format(if not a2 then a1 else ("%*.%*"):format(a1, a2), v3)))
    return false
end

local function runStartupThread(a1, a2, a3, a4) -- Line: 42
    -- upvalues: u26 (ref), u24 (val), u27 (ref), u25 (ref), Profiler (val), getTraceback (val), RunService (val)
    u26 = u26 + 1
    local v1 = u26
    u24[v1] = {
        label = if not a2 then a1 else ("%*.%*"):format(a1, a2),
        profileLabel = a3,
        callback = a4,
    }
    if u27 then
        return
    end
    u27 = true
    task.spawn(function() -- Line: 55
        -- upvalues: u25 (upval), u26 (upval), u24 (upval), Profiler (upval), getTraceback (upval), RunService (upval)
        -- upvalues: u27 (upval)
        local v1 = os.clock()
        local v2 = 0
        while u25 <= u26 do
            local u7 = u24[u25]
            u24[u25] = nil
            u25 = u25 + 1
            v2 = v2 + 1
            task.spawn(function() -- Line: 65 -- upvalues: u7 (val), Profiler (upval), getTraceback (upval)
                debug.setmemorycategory((("Startup.%*"):format(u7.label)))
                Profiler.mark(u7.profileLabel)
                local success, result = xpcall(u7.callback, getTraceback)
                if not success then
                    warn((("[Startup] %* failed:\n%*"):format(u7.label, result)))
                end
            end)
            if u25 <= u26 then
                if v2 >= 1 or 0.0015 <= os.clock() - v1 then
                    RunService.Heartbeat:Wait()
                    v1 = os.clock()
                end
            end
        end
        table.clear(u24)
        u25 = 1
        u26 = 0
        u27 = false
    end)
end

local function initialize(a1, a2) -- Line: 91 -- upvalues: runPhase (val) -- types: a1: string
    if typeof(a2) ~= "table" then
        return false
    end
    local Initialize = a2.Initialize
    if Initialize then
        return runPhase("Initialize", a1, Initialize)
    end
    return true
end

local function start(a1, a2, a3) -- Line: 103
    -- upvalues: runStartupThread (val), runPhase (val)
    if typeof(a3) ~= "table" then
        return
    end
    local Start = a3.Start
    if Start then
        runStartupThread("Start", a1, a2, function() -- Line: 111 -- upvalues: runPhase (upval), a1 (val), Start (val)
            runPhase("Start", a1, Start)
        end)
    end
end

local function loadController(a1) -- Line: 117
    -- upvalues: Profiler (val), ReplicatedStorage (val), runStartupThread (val), runPhase (val)
    local u5 = Profiler.getInstancePath(a1, ReplicatedStorage)
    local u10 = ("Startup.Module.%*"):format(u5)
    runStartupThread("Controller", u5, u10, function() -- Line: 122 -- upvalues: runPhase (upval), u5 (val), a1 (val), u10 (val), runStartupThread (upval)
        local v1
        local v2, v3 = runPhase("Require", u5, require, a1)
        if not v2 then
            return
        end
        if typeof(v3) == "table" then
            local Initialize = v3.Initialize
            v1 = if not Initialize then true else runPhase("Initialize", u5, Initialize)
        else
            v1 = false
        end
        if v1 then
            local u21 = u5
            if typeof(v3) ~= "table" then
                return
            end
            local Start = v3.Start
            if Start then
                runStartupThread("Start", u21, u10, function() -- Line: 111 -- upvalues: runPhase (upval), u21 (val), Start (val)
                    runPhase("Start", u21, Start)
                end)
            end
        end
    end)
end

local function loadObserver(a1) -- Line: 134
    -- upvalues: Profiler (val), ReplicatedStorage (val), runStartupThread (val), runPhase (val)
    local u5 = Profiler.getInstancePath(a1, ReplicatedStorage)
    runStartupThread("Observer", u5, ("Startup.Module.%*"):format(u5), function() -- Line: 138 -- upvalues: u5 (val), runPhase (upval), a1 (val)
        debug.setmemorycategory((("Startup.Observer.%*"):format(u5)))
        runPhase("Require", u5, require, a1)
    end)
end

local function loadInterface(a1) -- Line: 144 -- upvalues: runStartupThread (val), runPhase (val) -- types: a1: userdata
    runStartupThread("Interface", nil, "Startup.Module.Interface", function() -- Line: 145 -- upvalues: runPhase (upval), a1 (val)
        local v1, v2 = runPhase("Require", "Interface", require, a1)
        if not v1 or typeof(v2) ~= "table" then
            return
        end
        if v2.Initialize and not runPhase("Initialize", "Interface", v2.Initialize) then
            return
        end
        if v2.Start then
            runPhase("Start", "Interface", v2.Start)
        end
    end)
end

for i, v in ipairs(ReplicatedStorage.Controllers:GetChildren()) do
    if v:IsA("ModuleScript") then
        local u155 = Profiler.getInstancePath(v, ReplicatedStorage)
        local u160 = ("Startup.Module.%*"):format(u155)
        runStartupThread("Controller", u155, u160, function() -- Line: 122 -- upvalues: runPhase (val), u155 (val), v (val), u160 (val), runStartupThread (val)
            local v1
            local v2, v3 = runPhase("Require", u155, require, v)
            if not v2 then
                return
            end
            if typeof(v3) == "table" then
                local Initialize = v3.Initialize
                v1 = if not Initialize then true else runPhase("Initialize", u155, Initialize)
            else
                v1 = false
            end
            if v1 then
                local u21 = u155
                if typeof(v3) ~= "table" then
                    return
                end
                local Start = v3.Start
                if Start then
                    runStartupThread("Start", u21, u160, function() -- Line: 111 -- upvalues: runPhase (upval), u21 (val), Start (val)
                        runPhase("Start", u21, Start)
                    end)
                end
            end
        end)
    end
end
for i2, i3 in ipairs(ReplicatedStorage.Controllers.Observers:GetChildren()) do
    if i3:IsA("ModuleScript") then
        local u89 = Profiler.getInstancePath(i3, ReplicatedStorage)
        runStartupThread("Observer", u89, ("Startup.Module.%*"):format(u89), function() -- Line: 138 -- upvalues: u89 (val), runPhase (val), i3 (val)
            debug.setmemorycategory((("Startup.Observer.%*"):format(u89)))
            runPhase("Require", u89, require, i3)
        end)
    elseif i3:IsA("Folder") then
        for i4, j in ipairs(i3:GetChildren()) do
            if j:IsA("ModuleScript") then
                local u136 = Profiler.getInstancePath(j, ReplicatedStorage)
                runStartupThread("Observer", u136, ("Startup.Module.%*"):format(u136), function() -- Line: 138 -- upvalues: u136 (val), runPhase (val), j (val)
                    debug.setmemorycategory((("Startup.Observer.%*"):format(u136)))
                    runPhase("Require", u136, require, j)
                end)
            end
        end
    end
end
local Interface = ReplicatedStorage:WaitForChild("Interface")
runStartupThread("Interface", nil, "Startup.Module.Interface", function() -- Line: 145 -- upvalues: runPhase (val), Interface (val)
    local v1, v2 = runPhase("Require", "Interface", require, Interface)
    if not v1 or typeof(v2) ~= "table" then
        return
    end
    if v2.Initialize and not runPhase("Initialize", "Interface", v2.Initialize) then
        return
    end
    if v2.Start then
        runPhase("Start", "Interface", v2.Start)
    end
end)