-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function acquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 34
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function runEventHandlerInFreeThread(...) -- Line: 45
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...);

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u4 = {};
u4.__index = u4;

function u4.new(p5, p6) -- Line: 56
    -- upvalues: u4 (copy)
    return setmetatable({
        _connected = true,
        _next = false,
        _signal = p5,
        _fn = p6
    }, u4);
end;

function u4.Disconnect(p7) -- Line: 65
    assert(p7._connected, "Can\'t disconnect a connection twice.", 2);
    p7._connected = false;
    local _signal = p7._signal;

    if _signal._handlerListHead == p7 then
        _signal._handlerListHead = p7._next;
    else
        local _handlerListHead = _signal._handlerListHead;

        while _handlerListHead and _handlerListHead._next ~= p7 do
            _handlerListHead = _handlerListHead._next;
        end;

        if _handlerListHead then
            _handlerListHead._next = p7._next;
        end;
    end;

    if _signal.connectionsChanged then
        _signal.totalConnections = _signal.totalConnections - 1;
        _signal.connectionsChanged:Fire(-1);
    end;
end;

setmetatable(u4, {
    __index = function(p8, p9) -- Line: 94, Name: __index
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p9))), 2);
    end,

    __newindex = function(p10, p11, p12) -- Line: 97, Name: __newindex
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p11))), 2);
    end
});
local u13 = {};
u13.__index = u13;

function u13.new(p14) -- Line: 106
    -- upvalues: u13 (copy)
    local v15 = setmetatable({
        _handlerListHead = false
    }, u13);

    if p14 then
        v15.totalConnections = 0;
        v15.connectionsChanged = u13.new();
    end;

    return v15;
end;

function u13.Connect(p16, p17) -- Line: 117
    -- upvalues: u4 (copy)
    local v18 = u4.new(p16, p17);

    if p16._handlerListHead then
        v18._next = p16._handlerListHead;
        p16._handlerListHead = v18;
    else
        p16._handlerListHead = v18;
    end;

    if p16.connectionsChanged then
        p16.totalConnections = p16.totalConnections + 1;
        p16.connectionsChanged:Fire(1);
    end;

    return v18;
end;

function u13.DisconnectAll(p19) -- Line: 135
    p19._handlerListHead = false;

    if p19.connectionsChanged then
        p19.connectionsChanged:Fire(-p19.totalConnections);
        p19.connectionsChanged:Destroy();
        p19.connectionsChanged = nil;
        p19.totalConnections = 0;
    end;
end;

u13.Destroy = u13.DisconnectAll;
u13.destroy = u13.DisconnectAll;

function u13.Fire(p20, ...) -- Line: 152
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    local _handlerListHead = p20._handlerListHead;

    while _handlerListHead do
        if _handlerListHead._connected then
            if not u1 then
                u1 = coroutine.create(runEventHandlerInFreeThread);
            end;

            task.spawn(u1, _handlerListHead._fn, ...);
        end;

        _handlerListHead = _handlerListHead._next;
    end;
end;

function u13.Wait(p21) -- Line: 167
    local coroutine_running_ret = coroutine.running();
    local u22 = nil;
    u22 = p21:Connect(function(...) -- Line: 170
        -- upvalues: u22 (ref), coroutine_running_ret (copy)
        u22:Disconnect();
        task.spawn(coroutine_running_ret, ...);
    end);

    return coroutine.yield();
end;

return u13;