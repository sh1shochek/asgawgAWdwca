-- ReplicatedStorage.Shared.Utility.Signal
-- Script path: ReplicatedStorage.Shared.Utility.Signal
-- Decompile time: 6.01 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};
u1.__index = u1;
u2.__index = u2;
local u3 = nil;

function u1.new() -- Line: 13
    -- upvalues: u1 (copy)
    local v4 = setmetatable({}, u1);
    v4.Next = v4;
    v4.Previous = v4;

    return v4;
end;

function u1.Connect(p5, p6, p7) -- Line: 24
    -- upvalues: u2 (copy)
    local v8 = setmetatable({}, u2);
    v8.Function = p6;
    v8.Parameter = p7;
    v8.Next = p5;
    v8.Previous = p5.Previous;
    p5.Previous.Next = v8;
    p5.Previous = v8;

    return v8;
end;

function u1.Fire(p9, ...) -- Line: 38
    -- upvalues: u3 (ref)
    local Previous = p9.Previous;

    while Previous ~= p9 do
        u3:Spawn(Previous.Function, ...);
        Previous = Previous.Previous;
    end;
end;

function u1.FastFire(p10, ...) -- Line: 48
    local Previous = p10.Previous;

    while Previous ~= p10 do
        Previous.Function(...);
        Previous = Previous.Previous;
    end;
end;

function u1.Once(p11, u12) -- Line: 58
    local u13 = nil;
    u13 = p11:Connect(function(...) -- Line: 60
        -- upvalues: u13 (ref), u12 (copy)
        u13:Disconnect();
        u13 = nil;
        u12(...);
    end);

    return u13;
end;

function u1.Wait(p14) -- Line: 70
    local coroutine_running_ret = coroutine.running();
    local u15 = nil;
    u15 = p14:Connect(function(...) -- Line: 76
        -- upvalues: u15 (ref), coroutine_running_ret (copy)
        u15:Disconnect();
        task.spawn(coroutine_running_ret, ...);
    end);

    return coroutine.yield();
end;

function u1.Destroy(p16) -- Line: 85
    while p16.Next ~= p16 do
        p16.Next:Disconnect();
    end;

    table.clear(p16);
end;

function u2.Disconnect(p17) -- Line: 96
    if not p17.Function then
        return;
    end;

    p17.Previous.Next = p17.Next;
    p17.Next.Previous = p17.Previous;
    p17.Function = nil;
    p17.Parameter = nil;
end;

function u1.Init(p18) -- Line: 109
    -- upvalues: u3 (ref)
    u3 = p18:GetModule("Threads");
end;

return u1;