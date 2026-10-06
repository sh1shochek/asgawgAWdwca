-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function acquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 44
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function runEventHandlerInFreeThread(...) -- Line: 55
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...);

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u4 = {};
u4.__index = u4;

function u4.Disconnect(p5) -- Line: 81
    if not p5.Connected then
        return;
    end;

    p5.Connected = false;

    if p5._signal._handlerListHead == p5 then
        p5._signal._handlerListHead = p5._next;

        return;
    end;

    local _handlerListHead = p5._signal._handlerListHead;

    while _handlerListHead and _handlerListHead._next ~= p5 do
        _handlerListHead = _handlerListHead._next;
    end;

    if _handlerListHead then
        _handlerListHead._next = p5._next;
    end;
end;

u4.Destroy = u4.Disconnect;
setmetatable(u4, {
    __index = function(p6, p7) -- Line: 108, Name: __index
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p7))), 2);
    end,

    __newindex = function(p8, p9, p10) -- Line: 111, Name: __newindex
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p9))), 2);
    end
});
local u11 = {};
u11.__index = u11;

function u11.new() -- Line: 153
    -- upvalues: u11 (copy)
    return setmetatable({
        _handlerListHead = false,
        _proxyHandler = nil,
        _yieldedThreads = nil
    }, u11);
end;

function u11.Wrap(p12: userdata) -- Line: 176
    -- upvalues: u11 (copy)
    local v13 = typeof(p12) == "RBXScriptSignal";
    local v14 = "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(p12);
    assert(v13, v14);
    local u15 = u11.new();
    u15._proxyHandler = p12:Connect(function(...) -- Line: 183
        -- upvalues: u15 (copy)
        u15:Fire(...);
    end);

    return u15;
end;

function u11.Is(p16) -- Line: 196
    -- upvalues: u11 (copy)
    local v17;

    if type(p16) == "table" then
        v17 = getmetatable(p16) == u11;
    else
        v17 = false;
    end;

    return v17;
end;

function u11.Connect(p18, p19) -- Line: 213
    -- upvalues: u4 (copy)
    local v20 = setmetatable({
        Connected = true,
        _next = false,
        _signal = p18,
        _fn = p19
    }, u4);

    if not p18._handlerListHead then
        p18._handlerListHead = v20;

        return v20;
    end;

    v20._next = p18._handlerListHead;
    p18._handlerListHead = v20;

    return v20;
end;

function u11.ConnectOnce(p21, p22) -- Line: 236
    return p21:Once(p22);
end;

function u11.Once(p23, u24) -- Line: 255
    local u25 = nil;
    local u26 = false;
    u25 = p23:Connect(function(...) -- Line: 259
        -- upvalues: u26 (ref), u25 (ref), u24 (copy)
        if u26 then
            return;
        end;

        u26 = true;
        u25:Disconnect();
        u24(...);
    end);

    return u25;
end;

function u11.GetConnections(p27) -- Line: 272
    local _handlerListHead = p27._handlerListHead;
    local v28 = {};

    while _handlerListHead do
        table.insert(v28, _handlerListHead);
        _handlerListHead = _handlerListHead._next;
    end;

    return v28;
end;

function u11.DisconnectAll(p29) -- Line: 292
    local _handlerListHead = p29._handlerListHead;

    while _handlerListHead do
        _handlerListHead.Connected = false;
        _handlerListHead = _handlerListHead._next;
    end;

    p29._handlerListHead = false;
    local v30 = rawget(p29, "_yieldedThreads");

    if v30 then
        for i in v30 do
            if coroutine.status(i) == "suspended" then
                warn(debug.traceback(i, "signal disconnected; yielded thread cancelled", 2));
                task.cancel(i);
            end;
        end;

        table.clear(p29._yieldedThreads);
    end;
end;

function u11.Fire(p31, ...) -- Line: 327
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    local _handlerListHead = p31._handlerListHead;

    while _handlerListHead do
        if _handlerListHead.Connected then
            if not u1 then
                u1 = coroutine.create(runEventHandlerInFreeThread);
            end;

            task.spawn(u1, _handlerListHead._fn, ...);
        end;

        _handlerListHead = _handlerListHead._next;
    end;
end;

function u11.FireDeferred(p32, ...) -- Line: 348
    local _handlerListHead = p32._handlerListHead;

    while _handlerListHead do
        task.defer(function(...) -- Line: 352
            -- upvalues: _handlerListHead (copy)
            if _handlerListHead.Connected then
                _handlerListHead._fn(...);
            end;
        end, ...);
        _handlerListHead = _handlerListHead._next;
    end;
end;

function u11.Wait(p33) -- Line: 376
    local u34 = rawget(p33, "_yieldedThreads");

    if not u34 then
        u34 = {};
        rawset(p33, "_yieldedThreads", u34);
    end;

    local coroutine_running_ret = coroutine.running();
    u34[coroutine_running_ret] = true;
    p33:Once(function(...) -- Line: 386
        -- upvalues: u34 (ref), coroutine_running_ret (copy)
        u34[coroutine_running_ret] = nil;

        if coroutine.status(coroutine_running_ret) == "suspended" then
            task.spawn(coroutine_running_ret, ...);
        end;
    end);

    return coroutine.yield();
end;

function u11.Destroy(p35) -- Line: 409
    p35:DisconnectAll();
    local v36 = rawget(p35, "_proxyHandler");

    if v36 then
        v36:Disconnect();
    end;
end;

setmetatable(u11, {
    __index = function(p37, p38) -- Line: 420, Name: __index
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p38))), 2);
    end,

    __newindex = function(p39, p40, p41) -- Line: 423, Name: __newindex
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p40))), 2);
    end
});

return table.freeze({
    new = u11.new,
    Wrap = u11.Wrap,
    Is = u11.Is
});