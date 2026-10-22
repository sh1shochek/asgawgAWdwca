-- ReplicatedStorage.Shared.Utility.Threads
-- Script path: ReplicatedStorage.Shared.Utility.Threads
-- Decompile time: 4.26 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};

local function Call(p3, ...) -- Line: 12
    p3(...);
end;

local function Thread() -- Line: 16
    -- upvalues: Call (copy), u2 (copy)
    while true do
        Call(coroutine.yield());
        table.insert(u2, coroutine.running());
    end;
end;

local function Get() -- Line: 23
    -- upvalues: u2 (copy), Thread (copy)
    local table_remove_ret = table.remove(u2);

    if not table_remove_ret then
        table_remove_ret = coroutine.create(Thread);
        coroutine.resume(table_remove_ret);
    end;

    return table_remove_ret;
end;

function v1.Defer(p4, p5, ...) -- Line: 34
    -- upvalues: u2 (copy), Thread (copy)
    local task_defer = task.defer;
    local table_remove_ret = table.remove(u2);

    if not table_remove_ret then
        table_remove_ret = coroutine.create(Thread);
        coroutine.resume(table_remove_ret);
    end;

    task_defer(table_remove_ret, p5, ...);
end;

function v1.Spawn(p6, p7, ...) -- Line: 38
    -- upvalues: u2 (copy), Thread (copy)
    local task_spawn = task.spawn;
    local table_remove_ret = table.remove(u2);

    if not table_remove_ret then
        table_remove_ret = coroutine.create(Thread);
        coroutine.resume(table_remove_ret);
    end;

    task_spawn(table_remove_ret, p7, ...);
end;

function v1.Delay(p8, p9, p10, ...) -- Line: 42
    -- upvalues: u2 (copy), Thread (copy)
    local task_delay = task.delay;
    local table_remove_ret = table.remove(u2);

    if not table_remove_ret then
        table_remove_ret = coroutine.create(Thread);
        coroutine.resume(table_remove_ret);
    end;

    task_delay(p9, table_remove_ret, p10, ...);
end;

return v1;