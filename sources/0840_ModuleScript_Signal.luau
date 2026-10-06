-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function acquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 53
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function runEventHandlerInFreeThread(...) -- Line: 64
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...);

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u4 = {};
u4.__index = u4;

function u4.new(p5, p6) -- Line: 90
    -- upvalues: u4 (copy)
    return setmetatable({
        Connected = true,
        _next = false,
        _signal = p5,
        _fn = p6
    }, u4);
end;

function u4.Disconnect(p7) -- Line: 99
    if not p7.Connected then
        return;
    end;

    p7.Connected = false;

    if p7._signal._handlerListHead == p7 then
        p7._signal._handlerListHead = p7._next;

        return;
    end;

    local _handlerListHead = p7._signal._handlerListHead;

    while _handlerListHead and _handlerListHead._next ~= p7 do
        _handlerListHead = _handlerListHead._next;
    end;

    if _handlerListHead then
        _handlerListHead._next = p7._next;
    end;
end;

u4.Destroy = u4.Disconnect;
setmetatable(u4, {
    __index = function(p8, p9) -- Line: 126, Name: __index
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p9))), 2);
    end,

    __newindex = function(p10, p11, p12) -- Line: 129, Name: __newindex
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p11))), 2);
    end
});
local u13 = {};
u13.__index = u13;

function u13.new() -- Line: 165
    -- upvalues: u13 (copy)
    return setmetatable({
        _handlerListHead = false,
        _proxyHandler = nil
    }, u13);
end;

function u13.Wrap(p14: userdata) -- Line: 186
    -- upvalues: u13 (copy)
    local v15 = typeof(p14) == "RBXScriptSignal";
    local v16 = "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(p14);
    assert(v15, v16);
    local u17 = u13.new();
    u17._proxyHandler = p14:Connect(function(...) -- Line: 192
        -- upvalues: u17 (copy)
        u17:Fire(...);
    end);

    return u17;
end;

function u13.Is(p18) -- Line: 204
    -- upvalues: u13 (copy)
    local v19;

    if type(p18) == "table" then
        v19 = getmetatable(p18) == u13;
    else
        v19 = false;
    end;

    return v19;
end;

function u13.Connect(p20, p21) -- Line: 221
    -- upvalues: u4 (copy)
    local v22 = u4.new(p20, p21);

    if not p20._handlerListHead then
        p20._handlerListHead = v22;

        return v22;
    end;

    v22._next = p20._handlerListHead;
    p20._handlerListHead = v22;

    return v22;
end;

function u13.ConnectOnce(p23, p24) -- Line: 237
    return p23:Once(p24);
end;

function u13.Once(p25, u26) -- Line: 256
    local u27 = nil;
    local u28 = false;
    u27 = p25:Connect(function(...) -- Line: 259
        -- upvalues: u28 (ref), u27 (ref), u26 (copy)
        if u28 then
            return;
        end;

        u28 = true;
        u27:Disconnect();
        u26(...);
    end);

    return u27;
end;

function u13.GetConnections(p29) -- Line: 270
    local _handlerListHead = p29._handlerListHead;
    local v30 = {};

    while _handlerListHead do
        table.insert(v30, _handlerListHead);
        _handlerListHead = _handlerListHead._next;
    end;

    return v30;
end;

function u13.DisconnectAll(p31) -- Line: 288
    local _handlerListHead = p31._handlerListHead;

    while _handlerListHead do
        _handlerListHead.Connected = false;
        _handlerListHead = _handlerListHead._next;
    end;

    p31._handlerListHead = false;
end;

function u13.Fire(p32, ...) -- Line: 312
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    local _handlerListHead = p32._handlerListHead;

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

function u13.FireDeferred(p33, ...) -- Line: 333
    local _handlerListHead = p33._handlerListHead;

    while _handlerListHead do
        task.defer(_handlerListHead._fn, ...);
        _handlerListHead = _handlerListHead._next;
    end;
end;

function u13.Wait(p34) -- Line: 356
    local coroutine_running_ret = coroutine.running();
    local u35 = nil;
    local u36 = false;
    u35 = p34:Connect(function(...) -- Line: 360
        -- upvalues: u36 (ref), u35 (ref), coroutine_running_ret (copy)
        if u36 then
            return;
        end;

        u36 = true;
        u35:Disconnect();
        task.spawn(coroutine_running_ret, ...);
    end);

    return coroutine.yield();
end;

function u13.Destroy(p37) -- Line: 383
    p37:DisconnectAll();
    local v38 = rawget(p37, "_proxyHandler");

    if v38 then
        v38:Disconnect();
    end;
end;

setmetatable(u13, {
    __index = function(p39, p40) -- Line: 393, Name: __index
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p40))), 2);
    end,

    __newindex = function(p41, p42, p43) -- Line: 396, Name: __newindex
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p42))), 2);
    end
});

return {
    new = u13.new,
    Wrap = u13.Wrap,
    Is = u13.Is
};