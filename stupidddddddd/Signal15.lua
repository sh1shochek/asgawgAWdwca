-- ReplicatedStorage.Packages.DebugTools.Shared.Signal
-- Script path: ReplicatedStorage.Packages.DebugTools.Shared.Signal
-- Decompile time: 2.14 ms

local u0 = nil

local function acquireRunnerThreadAndCallEventHandler(a1, ...) -- Line: 53 -- upvalues: u0 (ref)
    local v1 = u0
    u0 = nil
    a1(...)
    u0 = v1
end

local function runEventHandlerInFreeThread(...) -- Line: 64 -- upvalues: acquireRunnerThreadAndCallEventHandler (val)
    acquireRunnerThreadAndCallEventHandler(...)
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local u3 = {}
u3.__index = u3

function u3.new(a1, a2) -- Line: 90 -- upvalues: u3 (val)
    return (setmetatable({Connected = true, _next = false, _signal = a1, _fn = a2}, u3))
end

function u3:Disconnect() -- Line: 99
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
    __index = function(a1, a2) -- Line: 126
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
    __newindex = function(a1, a2, a3) -- Line: 129
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
}
setmetatable(u3, v1)
local u13 = {}
u13.__index = u13

function u13.new() -- Line: 165 -- upvalues: u13 (val)
    return (setmetatable({_handlerListHead = false}, u13))
end

function u13.Wrap(a1) -- Line: 186 -- upvalues: u13 (val) -- types: a1: userdata
    local v1 = "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. (typeof(a1))
    assert(typeof(a1) == "RBXScriptSignal", v1)
    local u17 = u13.new()
    u17._proxyHandler = a1:Connect(function(...) -- Line: 192 -- upvalues: u17 (val)
        u17:Fire(...)
    end)
    return u17
end

function u13.Is(a1) -- Line: 204 -- upvalues: u13 (val)
    local v1 = false
    if type(a1) == "table" then
        v1 = (getmetatable(a1)) == u13
    end
    return v1
end

function u13:Connect(a2) -- Line: 221 -- upvalues: u3 (val)
    local v1 = u3.new(self, a2)
    if not self._handlerListHead then
        self._handlerListHead = v1
        return v1
    end
    v1._next = self._handlerListHead
    self._handlerListHead = v1
    return v1
end

function u13.ConnectOnce(a1, a2) -- Line: 237
    return a1:Once(a2)
end

function u13:Once(a2) -- Line: 256
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

function u13.GetConnections(a1) -- Line: 270
    local v1 = {}
    local _handlerListHead = a1._handlerListHead
    while _handlerListHead do
        table.insert(v1, _handlerListHead)
        _handlerListHead = _handlerListHead._next
    end
    return v1
end

function u13:DisconnectAll() -- Line: 288
    local _handlerListHead = self._handlerListHead
    while _handlerListHead do
        _handlerListHead.Connected = false
        _handlerListHead = _handlerListHead._next
    end
    self._handlerListHead = false
end

function u13:Fire(...) -- Line: 312 -- upvalues: u0 (ref), runEventHandlerInFreeThread (val)
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

function u13.FireDeferred(a1, ...) -- Line: 333
    local _handlerListHead = a1._handlerListHead
    while _handlerListHead do
        task.defer(_handlerListHead._fn, ...)
        _handlerListHead = _handlerListHead._next
    end
end

function u13.Wait(a1) -- Line: 356
    local u2 = coroutine.running()
    local u3 = nil
    local u4 = false
    local v1 = a1:Connect(function(...) -- Line: 360 -- upvalues: u4 (ref), u3 (ref), u2 (val)
        if u4 then
            return
        end
        u4 = true
        u3:Disconnect()
        task.spawn(u2, ...)
    end)
    return (coroutine.yield())
end

function u13.Destroy(a1) -- Line: 383
    a1:DisconnectAll()
    local v1 = rawget(a1, "_proxyHandler")
    if v1 then
        v1:Disconnect()
    end
end

local v2 = {
    __index = function(a1, a2) -- Line: 393
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
    __newindex = function(a1, a2, a3) -- Line: 396
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
}
setmetatable(u13, v2)
return {new = u13.new, Wrap = u13.Wrap, Is = u13.Is}