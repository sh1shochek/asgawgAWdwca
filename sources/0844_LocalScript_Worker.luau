-- Decompiled with Potassium's decompiler.

local Actor = script:GetActor();
local Runnable = require(script.Parent.Runnable);
local Event = script.Parent.Parent.Event;
local u1 = false;
local u2 = {};
Actor:BindToMessageParallel("Parallel:Run", function(...) -- Line: 9
    -- upvalues: Runnable (ref), u1 (ref)
    assert(Runnable, "Parallel not initialized");
    assert(not u1, "Parallel destroyed");
    Runnable(...);
end);
Actor:BindToMessage("Parallel:SubmitTask", function(u3: string, ...) -- Line: 15
    -- upvalues: Runnable (ref), u1 (ref), u2 (ref), Event (ref)
    assert(Runnable, "Parallel not initialized");
    assert(not u1, "Parallel destroyed");
    local u4 = { ... };

    if u2[u3] ~= nil then
        task.cancel(u2[u3]);
        u2[u3] = nil;
    end;

    u2[u3] = task.spawn(function() -- Line: 24
        -- upvalues: Event (ref), u3 (copy), Runnable (ref), u4 (copy), u2 (ref)
        task.desynchronize();
        Event:Fire(u3, Runnable(table.unpack(u4)));
        u2[u3] = nil;
    end);
end);
Actor:BindToMessage("Parallel:CancelTask", function(p5: string) -- Line: 32
    -- upvalues: Runnable (ref), u1 (ref), u2 (ref)
    assert(Runnable, "Parallel not initialized");
    assert(not u1, "Parallel destroyed");

    if u2[p5] ~= nil then
        task.cancel(u2[p5]);
        u2[p5] = nil;
    end;
end);
Actor:BindToMessage("Parallel:Destroy", function() -- Line: 41
    -- upvalues: Runnable (ref), u1 (ref), u2 (ref), Event (ref)
    assert(Runnable, "Parallel not initialized");
    assert(not u1, "Parallel destroyed");
    u1 = true;

    for _, v in u2 do
        task.cancel(v);
    end;

    u2 = {};
    Runnable = nil;
    Event = nil;
end);
script.Parent:SetAttribute("Initialized", true);