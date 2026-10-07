-- ReplicatedStorage.Packages.Parallel.ClientActor.Worker
-- Script path: ReplicatedStorage.Packages.Parallel.ClientActor.Worker
-- Decompile time: 0.81 ms

local Actor = script:GetActor()
local Runnable = require(script.Parent.Runnable)
local Event = script.Parent.Parent.Event
local u13 = false
local u14 = {}
Actor:BindToMessageParallel("Parallel:Run", function(...) -- Line: 9 -- upvalues: Runnable (ref), u13 (ref)
    assert(Runnable, "Parallel not initialized")
    assert(not u13, "Parallel destroyed")
    Runnable(...)
end)
Actor:BindToMessage("Parallel:SubmitTask", function(a1, ...) -- Line: 15 -- upvalues: Runnable (ref), u13 (ref), u14 (ref), Event (ref) -- types: a1: string
    assert(Runnable, "Parallel not initialized")
    assert(not u13, "Parallel destroyed")
    local u10 = {}
    u10[1] = ...
    if u14[a1] ~= nil then
        task.cancel(u14[a1])
        u14[a1] = nil
    end
    u14[a1] = (task.spawn(function() -- Line: 24 -- upvalues: Event (upval), a1 (val), Runnable (upval), u10 (val), u14 (upval)
        task.desynchronize()
        Event:Fire(a1, (Runnable((table.unpack(u10)))))
        u14[a1] = nil
    end))
end)
Actor:BindToMessage("Parallel:CancelTask", function(a1) -- Line: 32 -- upvalues: Runnable (ref), u13 (ref), u14 (ref) -- types: a1: string
    assert(Runnable, "Parallel not initialized")
    assert(not u13, "Parallel destroyed")
    if u14[a1] ~= nil then
        task.cancel(u14[a1])
        u14[a1] = nil
    end
end)
Actor:BindToMessage("Parallel:Destroy", function() -- Line: 41 -- upvalues: Runnable (ref), u13 (ref), u14 (ref), Event (ref)
    assert(Runnable, "Parallel not initialized")
    assert(not u13, "Parallel destroyed")
    u13 = true
    for i, j in u14 do
        task.cancel(j)
    end
    u14 = {}
    Runnable = nil
    Event = nil
end)
script.Parent:SetAttribute("Initialized", true)