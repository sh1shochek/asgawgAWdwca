-- ReplicatedStorage.Shared.Zone.Signal
-- Script path: ReplicatedStorage.Shared.Zone.Signal
-- Decompile time: 1.54 ms

local u0 = nil

local function acquireRunnerThreadAndCallEventHandler(a1, ...) -- Line: 34 -- upvalues: u0 (ref)
    local v1 = u0
    u0 = nil
    a1(...)
    u0 = v1
end

local function runEventHandlerInFreeThread(...) -- Line: 45 -- upvalues: acquireRunnerThreadAndCallEventHandler (val)
    acquireRunnerThreadAndCallEventHandler(...)
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    end
end

local u3 = {}
u3.__index = u3

function u3.new(a1, a2) -- Line: 56 -- upvalues: u3 (val)
    return (setmetatable({_connected = true, _next = false, _signal = a1, _fn = a2}, u3))
end

function u3:Disconnect() -- Line: 65
    assert(self._connected, "Can't disconnect a connection twice.", 2)
    self._connected = false
    local _signal = self._signal
    if _signal._handlerListHead ~= self then
        local _handlerListHead = _signal._handlerListHead
        while _handlerListHead do
            if _handlerListHead._next == self then
                break
            end
            _handlerListHead = _handlerListHead._next
        end
        if _handlerListHead then
            _handlerListHead._next = self._next
        end
    else
        _signal._handlerListHead = self._next
    end
    if _signal.connectionsChanged then
        _signal.totalConnections = _signal.totalConnections - 1
        _signal.connectionsChanged:Fire(-1)
    end
end

local v1 = {
    __index = function(a1, a2) -- Line: 94
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
    __newindex = function(a1, a2, a3) -- Line: 97
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(a2))), 2)
    end,
}
setmetatable(u3, v1)
local u12 = {}
u12.__index = u12

function u12.new(a1) -- Line: 106 -- upvalues: u12 (val)
    local v1 = setmetatable({_handlerListHead = false}, u12)
    if a1 then
        v1.totalConnections = 0
        v1.connectionsChanged = u12.new()
    end
    return v1
end

function u12:Connect(a2) -- Line: 117 -- upvalues: u3 (val)
    local v1 = u3.new(self, a2)
    if self._handlerListHead then
        v1._next = self._handlerListHead
    end
    self._handlerListHead = v1
    if self.connectionsChanged then
        self.totalConnections = self.totalConnections + 1
        self.connectionsChanged:Fire(1)
    end
    return v1
end

function u12.DisconnectAll(a1) -- Line: 135
    a1._handlerListHead = false
    if a1.connectionsChanged then
        a1.connectionsChanged:Fire(-a1.totalConnections)
        a1.connectionsChanged:Destroy()
        a1.connectionsChanged = nil
        a1.totalConnections = 0
    end
end

u12.Destroy = u12.DisconnectAll
u12.destroy = u12.DisconnectAll

function u12:Fire(...) -- Line: 152 -- upvalues: u0 (ref), runEventHandlerInFreeThread (val)
    local _handlerListHead = self._handlerListHead
    while _handlerListHead do
        if _handlerListHead._connected then
            if not u0 then
                u0 = coroutine.create(runEventHandlerInFreeThread)
            end
            task.spawn(u0, _handlerListHead._fn, ...)
        end
        _handlerListHead = _handlerListHead._next
    end
end

function u12.Wait(a1) -- Line: 167
    local u2 = coroutine.running()
    local u3 = nil
    local v1 = a1:Connect(function(...) -- Line: 170 -- upvalues: u3 (ref), u2 (val)
        u3:Disconnect()
        task.spawn(u2, ...)
    end)
    return (coroutine.yield())
end

return u12