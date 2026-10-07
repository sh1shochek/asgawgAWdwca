-- ReplicatedStorage.Packages._Index.sleitnick_signal@2.0.3.signal
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_signal@2.0.3.signal
-- Decompile time: 3.44 ms

local u0 = nil

local function acquireRunnerThreadAndCallEventHandler(a1, ...) -- Line: 44 -- upvalues: u0 (ref)
    local v1 = u0
    u0 = nil
    a1(...)
    u0 = v1
end

local function runEventHandlerInFreeThread(...) -- Line: 55 -- upvalues: acquireRunnerThreadAndCallEventHandler (val)
    acquireRunnerThreadAndCallEventHandler(...)
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local u3 = {}
u3.__index = u3

function u3:Disconnect() -- Line: 81
    if not self.Connected then
        return
    end
    self.Connected = false
    if self._signal._handlerListHead == self then
        self._signal._handlerListHead = self._next
        return
    end
    local _handlerListHead = self._signal._handlerListHead
    while _handlerListHead do
        if _handlerListHead._next == self then
            break
        end
        _handlerListHead = _handlerListHead._next
    end
    if _handlerListHead then
        _handlerListHead._next = self._next
    end
end

u3.Destroy = u3.Disconnect
local v1 = {
    __index = function(a1, a2) -- Line: 108
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
    __newindex = function(a1, a2, a3) -- Line: 111
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
}
setmetatable(u3, v1)
local u12 = {}
u12.__index = u12

function u12.new() -- Line: 153 -- upvalues: u12 (val)
    return (setmetatable({_handlerListHead = false}, u12))
end

function u12.Wrap(a1) -- Line: 176 -- upvalues: u12 (val) -- types: a1: userdata
    local v1 = "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. (typeof(a1))
    assert(typeof(a1) == "RBXScriptSignal", v1)
    local u17 = u12.new()
    u17._proxyHandler = a1:Connect(function(...) -- Line: 183 -- upvalues: u17 (val)
        u17:Fire(...)
    end)
    return u17
end

function u12.Is(a1) -- Line: 196 -- upvalues: u12 (val)
    local v1 = false
    if type(a1) == "table" then
        v1 = (getmetatable(a1)) == u12
    end
    return v1
end

function u12:Connect(a2) -- Line: 213 -- upvalues: u3 (val)
    local v1 = {Connected = true, _next = false, _signal = self, _fn = a2}
    local v2 = setmetatable(v1, u3)
    if not self._handlerListHead then
        self._handlerListHead = v2
        return v2
    end
    v2._next = self._handlerListHead
    self._handlerListHead = v2
    return v2
end

function u12.ConnectOnce(a1, a2) -- Line: 236
    return a1:Once(a2)
end

function u12:Once(a2) -- Line: 255
    local u2 = nil
    local u3 = false
    u2 = (self:Connect(function(...) -- Line: 259 -- upvalues: u3 (ref), u2 (ref), a2 (val)
        if u3 then
            return
        end
        u3 = true
        u2:Disconnect()
        a2(...)
    end))
    return u2
end

function u12.GetConnections(a1) -- Line: 272
    local v1 = {}
    local _handlerListHead = a1._handlerListHead
    while _handlerListHead do
        table.insert(v1, _handlerListHead)
        _handlerListHead = _handlerListHead._next
    end
    return v1
end

function u12:DisconnectAll() -- Line: 292
    local _handlerListHead = self._handlerListHead
    while _handlerListHead do
        _handlerListHead.Connected = false
        _handlerListHead = _handlerListHead._next
    end
    self._handlerListHead = false
    local v1 = rawget(self, "_yieldedThreads")
    if v1 then
        for i in v1 do
            if coroutine.status(i) == "suspended" then
                warn(debug.traceback(i, "signal disconnected; yielded thread cancelled", 2))
                task.cancel(i)
            end
        end
        table.clear(self._yieldedThreads)
    end
end

function u12:Fire(...) -- Line: 327 -- upvalues: u0 (ref), runEventHandlerInFreeThread (val)
    local _handlerListHead = self._handlerListHead
    while _handlerListHead do
        if _handlerListHead.Connected then
            if not u0 then
                u0 = coroutine.create(runEventHandlerInFreeThread)
            end
            task.spawn(u0, _handlerListHead._fn, ...)
        end
        _handlerListHead = _handlerListHead._next
    end
end

function u12.FireDeferred(a1, ...) -- Line: 348
    local _handlerListHead = a1._handlerListHead
    while _handlerListHead do
        local u3 = _handlerListHead
        task.defer(function(...) -- Line: 352 -- upvalues: u3 (val)
            if u3.Connected then
                u3._fn(...)
            end
        end, ...)
        _handlerListHead = _handlerListHead._next
    end
end

function u12.Wait(a1) -- Line: 376
    local u5 = rawget(a1, "_yieldedThreads")
    if not u5 then
        u5 = {}
        local v1 = u5
        rawset(a1, "_yieldedThreads", v1)
    end
    local u12 = coroutine.running()
    u5[u12] = true
    a1:Once(function(...) -- Line: 386 -- upvalues: u5 (ref), u12 (val)
        u5[u12] = nil
        if coroutine.status(u12) == "suspended" then
            task.spawn(u12, ...)
        end
    end)
    return (coroutine.yield())
end

function u12.Destroy(a1) -- Line: 409
    a1:DisconnectAll()
    local v1 = rawget(a1, "_proxyHandler")
    if v1 then
        v1:Disconnect()
    end
end

local v2 = {
    __index = function(a1, a2) -- Line: 420
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
    __newindex = function(a1, a2, a3) -- Line: 423
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
}
setmetatable(u12, v2)
return (table.freeze({new = u12.new, Wrap = u12.Wrap, Is = u12.Is}))