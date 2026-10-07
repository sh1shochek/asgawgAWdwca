-- ReplicatedStorage.Shared.Promise
-- Script path: ReplicatedStorage.Shared.Promise
-- Decompile time: 19.02 ms

local u0 = {__mode = "k"}
local Profiler = require(game:GetService("ReplicatedStorage").Shared.Profiler)

local function makeEnum(a1, a2) -- Line: 15
    local v1 = {}
    for i, v in ipairs(a2) do
        v1[v] = v
    end
    return (setmetatable(v1, {
        __index = function(a1_2, a2) -- Line: 23 -- upvalues: a1 (val)
            error(string.format("%s is not in %s!", a2, a1), 2)
        end,
        __newindex = function() -- Line: 26 -- upvalues: a1 (val)
            error(string.format("Creating new members in %s is not allowed!", a1), 2)
        end,
    }))
end

local u21 = {
    Kind = makeEnum("Promise.Error.Kind", {"ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut"}),
}
u21.__index = u21

function u21.new(a1, a2) -- Line: 48 -- upvalues: u21 (ref)
    local v1 = a1 or {}
    return (setmetatable({
        error = tostring(v1.error) or "[This error has no error text.]",
        trace = v1.trace,
        context = v1.context,
        kind = v1.kind,
        parent = a2,
        createdTick = os.clock(),
        createdTrace = debug.traceback(),
    }, u21))
end

function u21.is(a1) -- Line: 61
    if type(a1) == "table" then
        local v1 = getmetatable(a1)
        if type(v1) == "table" then
            local v2 = false
            if rawget(a1, "error") ~= nil then
                v2 = type((rawget(v1, "extend"))) == "function"
            end
            return v2
        end
    end
    return false
end

function u21.isKind(a1, a2) -- Line: 73 -- upvalues: u21 (ref)
    assert(a2 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")
    return u21.is(a1) and a1.kind == a2
end

function u21:extend(a2) -- Line: 79 -- upvalues: u21 (ref)
    local v1 = a2 or {}
    local kind = v1.kind or self.kind
    v1.kind = kind
    return u21.new(v1, self)
end

function u21.getErrorChain(a1) -- Line: 87
    local v1 = {a1}
    while v1[#v1].parent do
        table.insert(v1, v1[#v1].parent)
    end
    return v1
end

function u21.__tostring(a1) -- Line: 97
    local v1 = {string.format("-- Promise.Error(%s) --", a1.kind or "?")}
    for i, v in ipairs(a1:getErrorChain()) do
        table.insert(v1, (table.concat({v.trace or v.error, v.context}, "\n")))
    end
    return table.concat(v1, "\n")
end

local function pack(...) -- Line: 118
    return (select("#", ...)), {...}
end

local function packResult(a1, ...) -- Line: 125
    return a1, (select("#", ...)), {...}
end

local function makeErrorHandler(a1) -- Line: 130 -- upvalues: u21 (ref)
    assert(a1 ~= nil)
    return function(a1_2) -- Line: 133 -- upvalues: u21 (upval), a1 (val)
        if type(a1_2) == "table" then
            return a1_2
        end
        return u21.new({
            error = a1_2,
            kind = u21.Kind.ExecutionError,
            trace = debug.traceback(tostring(a1_2), 2),
            context = "Promise created at:\n\n" .. a1,
        })
    end
end

local function runExecutor(a1, a2, ...) -- Line: 153 -- upvalues: Profiler (val), u21 (ref), packResult (val)
    Profiler.mark((Profiler.getCallbackLabel("Promise.Callback", a2)))
    local pack = table.pack
    local v1 = xpcall
    assert(a1 ~= nil)
    local v2 = pack(v1(a2, function(a1_2) -- Line: 133 -- upvalues: u21 (upval), a1 (val)
        if type(a1_2) == "table" then
            return a1_2
        end
        return u21.new({
            error = a1_2,
            kind = u21.Kind.ExecutionError,
            trace = debug.traceback(tostring(a1_2), 2),
            context = "Promise created at:\n\n" .. a1,
        })
    end, ...))
    return packResult(unpack(v2, 1, v2.n))
end

local function createAdvancer(a1, a2, a3, a4) -- Line: 166 -- upvalues: runExecutor (val)
    return function(...) -- Line: 167 -- upvalues: runExecutor (upval), a1 (val), a2 (val), a3 (val), a4 (val)
        local v1, v2, v3 = runExecutor(a1, a2, ...)
        if v1 then
            a3(unpack(v3, 1, v2))
            return
        end
        a4(v3[1])
    end
end

local function isEmpty(a1) -- Line: 178
    return next(a1) == nil
end

local u34 = {Error = u21}
u34.Status = makeEnum("Promise.Status", {"Started", "Resolved", "Rejected", "Cancelled"})
u34._getTime = os.clock
u34._timeEvent = game:GetService("RunService").Heartbeat
u34.prototype = {}
u34.__index = u34.prototype

function u34._new(a1, a2, a3) -- Line: 203 -- upvalues: u34 (val), u0 (val), runExecutor (val)
    if a3 ~= nil and not u34.is(a3) then
        error("Argument #2 to Promise.new must be a promise or nil", 2)
    end
    local u11 = {_valuesLength = -1, _unhandledRejection = true, _source = a1}
    u11._status = u34.Status.Started
    u11._queuedResolve = {}
    u11._queuedReject = {}
    u11._queuedFinally = {}
    u11._parent = a3
    u11._consumers = setmetatable({}, u0)
    if a3 and a3._status == u34.Status.Started then
        a3._consumers[u11] = true
    end
    local v1 = u34
    setmetatable(u11, v1)

    local function resolve(...) -- Line: 248 -- upvalues: u11 (val)
        u11:_resolve(...)
    end

    local function reject(...) -- Line: 252 -- upvalues: u11 (val)
        u11:_reject(...)
    end

    local function onCancel(a1) -- Line: 256 -- upvalues: u11 (val), u34 (upval)
        if a1 then
            if u11._status ~= u34.Status.Cancelled then
                u11._cancellationHook = a1
            else
                a1()
            end
        end
        return u11._status == u34.Status.Cancelled
    end

    coroutine.wrap(function() -- Line: 268
        -- upvalues: runExecutor (upval), u11 (val), a2 (val), resolve (val), reject (val), onCancel (val)
        local v1, v2
        v1, _, v2 = runExecutor(u11._source, a2, resolve, reject, onCancel)
        if not v1 then
            reject(v2[1])
        end
    end)()
    return u11
end

function u34.new(a1) -- Line: 285 -- upvalues: u34 (val)
    return u34._new(debug.traceback(nil, 2), a1)
end

function u34.__tostring(a1) -- Line: 289
    return string.format("Promise(%s)", a1:getStatus())
end

function u34.defer(a1) -- Line: 296 -- upvalues: u34 (val), runExecutor (val)
    local u4 = debug.traceback(nil, 2)
    return (u34._new(u4, function(a1_2, a2, a3) -- Line: 299 -- upvalues: u34 (upval), runExecutor (upval), u4 (val), a1 (val)
        local u3 = nil
        local v1 = u34._timeEvent:Connect(function() -- Line: 301
            -- upvalues: u3 (ref), runExecutor (upval), u4 (upval), a1 (upval), a1_2 (val), a2 (val), a3 (val)
            local v1, v2
            u3:Disconnect()
            v1, _, v2 = runExecutor(u4, a1, a1_2, a2, a3)
            if not v1 then
                a2(v2[1])
            end
        end)
    end))
end

u34.async = u34.defer

function u34.resolve(...) -- Line: 320 -- upvalues: pack (val), u34 (val)
    local u2, u3 = pack(...)
    return u34._new(debug.traceback(nil, 2), function(a1) -- Line: 322 -- upvalues: u3 (val), u2 (val)
        a1(unpack(u3, 1, u2))
    end)
end

function u34.reject(...) -- Line: 330 -- upvalues: pack (val), u34 (val)
    local u2, u3 = pack(...)
    return u34._new(debug.traceback(nil, 2), function(a1, a2) -- Line: 332 -- upvalues: u3 (val), u2 (val)
        a2(unpack(u3, 1, u2))
    end)
end

function u34._try(a1, a2, ...) -- Line: 341 -- upvalues: pack (val), u34 (val)
    local u4, u5 = pack(...)
    return u34._new(a1, function(a1) -- Line: 344 -- upvalues: a2 (val), u5 (val), u4 (val)
        a1(a2(unpack(u5, 1, u4)))
    end)
end

function u34.try(...) -- Line: 352 -- upvalues: u34 (val)
    return u34._try(debug.traceback(nil, 2), ...)
end

function u34._all(a1, a2, a3) -- Line: 361 -- upvalues: u34 (val)
    if type(a2) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
    end
    for k, v in pairs(a2) do
        if not u34.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(k))), 3)
        end
    end
    if #a2 ~= 0 and a3 ~= 0 then
        return u34._new(a1, function(a1, a2_2, a3_2) -- Line: 379 -- upvalues: a3 (val), a2 (val)
            local u3 = {}
            local u4 = {}
            local u5 = 0
            local u6 = 0
            local u7 = false

            local function resolveOne(a1_2, ...) -- Line: 397
                -- upvalues: u7 (ref), u5 (ref), a3 (upval), u3 (val), a2 (upval), a1 (val), u4 (val)
                if u7 then
                    return
                end
                u5 = u5 + 1
                if a3 ~= nil then
                    u3[u5] = (...)
                else
                    u3[a1_2] = (...)
                end
                local v1 = u5
                if (a3 or #a2) <= v1 then
                    u7 = true
                    a1(u3)
                    for i, v in ipairs(u4) do
                        v:cancel()
                    end
                end
            end

            a3_2(function() -- Line: 390 -- upvalues: u4 (val)
                for i, v in ipairs(u4) do
                    v:cancel()
                end
            end)
            for i, v in ipairs(a2) do
                u4[i] = (v:andThen(function(...) -- Line: 423 -- upvalues: resolveOne (val), i (val)
                    resolveOne(i, ...)
                end, function(...) -- Line: 426 -- upvalues: u6 (ref), a3 (upval), a2 (upval), u4 (val), u7 (ref), a2_2 (val)
                    u6 = u6 + 1
                    if a3 == nil then
                        for i, v in ipairs(u4) do
                            v:cancel()
                        end
                        u7 = true
                        a2_2(...)
                    elseif #a2 - u6 < a3 then
                        for i2, i3 in ipairs(u4) do
                            i3:cancel()
                        end
                        u7 = true
                        a2_2(...)
                    end
                end))
            end
            if u7 then
                for i2, i3 in ipairs(u4) do
                    i3:cancel()
                end
            end
        end)
    end
    return u34.resolve({})
end

function u34.all(a1) -- Line: 445 -- upvalues: u34 (val)
    return u34._all(debug.traceback(nil, 2), a1)
end

function u34.some(a1, a2) -- Line: 449 -- upvalues: u34 (val)
    assert(type(a2) == "number", "Bad argument #2 to Promise.some: must be a number")
    return u34._all(debug.traceback(nil, 2), a1, a2)
end

function u34.any(a1) -- Line: 455 -- upvalues: u34 (val)
    return (u34._all(debug.traceback(nil, 2), a1, 1)):andThen(function(a1) -- Line: 456
        return a1[1]
    end)
end

function u34.allSettled(a1) -- Line: 461 -- upvalues: u34 (val)
    if type(a1) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
    end
    for k, v in pairs(a1) do
        if not u34.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(k))), 2)
        end
    end
    if #a1 == 0 then
        return u34.resolve({})
    end
    return u34._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 479 -- upvalues: a1 (val)
        local u3 = {}
        local u4 = {}
        local u5 = 0

        local function resolveOne(a1_3, ...) -- Line: 489 -- upvalues: u5 (ref), u3 (val), a1 (upval), a1_2 (val)
            u5 = u5 + 1
            u3[a1_3] = (...)
            local v1 = u5
            if #a1 <= v1 then
                a1_2(u3)
            end
        end

        a3(function() -- Line: 499 -- upvalues: u4 (val)
            for i, v in ipairs(u4) do
                v:cancel()
            end
        end)
        for i, v in ipairs(a1) do
            u4[i] = (v:finally(function(...) -- Line: 509 -- upvalues: resolveOne (val), i (val)
                resolveOne(i, ...)
            end))
        end
    end)
end

function u34.race(a1) -- Line: 521 -- upvalues: u34 (val)
    local v1 = string.format("Please pass a list of promises to %s", "Promise.race")
    assert(type(a1) == "table", v1)
    for k, v in pairs(a1) do
        assert(u34.is(v), (string.format("Non-promise value passed into %s at index %s", "Promise.race", (tostring(k)))))
    end
    return u34._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 528 -- upvalues: a1 (val)
        local u3 = {}
        local u4 = false

        local function cancel() -- Line: 532 -- upvalues: u3 (val)
            for i, v in ipairs(u3) do
                v:cancel()
            end
        end

        local function finalize(a1) -- Line: 538 -- upvalues: u3 (val), u4 (ref)
            return function(...) -- Line: 539 -- upvalues: u3 (upval), u4 (upval), a1 (val)
                for i, v in ipairs(u3) do
                    v:cancel()
                end
                u4 = true
                return a1(...)
            end
        end

        if a3(function(...) -- Line: 539 -- upvalues: u3 (val), u4 (ref), a2 (val)
            local v3, v4, v5, v6
            for i, v in ipairs(u3) do
                v:cancel()
            end
            u4 = true
            return a2(...)
        end) then
            return
        end
        for i, v in ipairs(a1) do
            u3[i] = (v:andThen(function(...) -- Line: 539 -- upvalues: u3 (val), u4 (ref), a1_2 (val)
                for i, v in ipairs(u3) do
                    v:cancel()
                end
                u4 = true
                return a1_2(...)
            end, function(...) -- Line: 539 -- upvalues: u3 (val), u4 (ref), a2 (val)
                for i, v in ipairs(u3) do
                    v:cancel()
                end
                u4 = true
                return a2(...)
            end))
        end
        if u4 then
            for i2, i3 in ipairs(u3) do
                i3:cancel()
            end
        end
    end)
end

function u34.each(a1, a2) -- Line: 568 -- upvalues: u34 (val), u21 (ref)
    local v1 = string.format("Please pass a list of promises to %s", "Promise.each")
    assert(type(a1) == "table", v1)
    v1 = string.format("Please pass a handler function to %s!", "Promise.each")
    assert(type(a2) == "function", v1)
    return u34._new(debug.traceback(nil, 2), function(a1_2, a2_2, a3) -- Line: 572 -- upvalues: a1 (val), u34 (upval), u21 (upval), a2 (val)
        local v1, v2, v3
        local v4 = {}
        local u85 = {}
        local u5 = false

        local function cancel() -- Line: 578 -- upvalues: u85 (val)
            for i, v in ipairs(u85) do
                v:cancel()
            end
        end

        a3(function() -- Line: 584 -- upvalues: u5 (ref), u85 (val)
            u5 = true
            for i, v in ipairs(u85) do
                v:cancel()
            end
        end)
        local v5 = {}
        for i, v in ipairs(a1) do
            if not u34.is(v) then
                v5[i] = v
            else
                if (v:getStatus()) == u34.Status.Cancelled then
                    for i4, j in ipairs(u85) do
                        j:cancel()
                    end
                    return (a2_2((u21.new({
                        error = "Promise is cancelled",
                        kind = u21.Kind.AlreadyCancelled,
                        context = string.format(
                            "The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
                            i,
                            v._source
                        ),
                    }))))
                end
                if (v:getStatus()) == u34.Status.Rejected then
                    for i2, i3 in ipairs(u85) do
                        i3:cancel()
                    end
                    return (a2_2((select(2, (v:await())))))
                end
                v1 = v:andThen(function(...) -- Line: 617
                    return ...
                end)
                table.insert(u85, v1)
                v5[i] = v1
            end
        end
        for i5, k in ipairs(v5) do
            if u34.is(k) then
                v2, v3 = k:await()
                if not v2 then
                    for i6, n in ipairs(u85) do
                        n:cancel()
                    end
                    return (v6(v3))
                end
            end
            if u5 then
                return
            end
            v1 = u34.resolve(a2(k, i5))
            table.insert(u85, v1)
            v2, v3 = v1:await()
            if not v2 then
                for i7, m in ipairs(u85) do
                    m:cancel()
                end
                return (v6(v3))
            end
            v4[i5] = v3
        end
        a1_2(v4)
    end)
end

function u34.is(a1) -- Line: 664 -- upvalues: u34 (val)
    if type(a1) ~= "table" then
        return false
    end
    local v1 = getmetatable(a1)
    if v1 == u34 then
        return true
    end
    if v1 == nil then
        return type(a1.andThen) == "function"
    end
    if type(v1) == "table" and type((rawget(v1, "__index"))) == "table" then
        local v2 = rawget(v1, "__index")
        if type((rawget(v2, "andThen"))) == "function" then
            return true
        end
    end
    return false
end

function u34.promisify(a1) -- Line: 692 -- upvalues: u34 (val)
    return function(...) -- Line: 693 -- upvalues: u34 (upval), a1 (val)
        return u34._try(debug.traceback(nil, 2), a1, ...)
    end
end

local u70 = nil
local u71 = nil

function u34.delay(a1) -- Line: 708 -- upvalues: u34 (val), u71 (ref), u70 (ref)
    assert(type(a1) == "number", "Bad argument #1 to Promise.delay, must be a number.")
    if not (a1 >= 0.016666666666666666) or a1 == (1 / 0) then
        a1 = 0.016666666666666666
    end
    return (u34._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 716 -- upvalues: u34 (upval), a1 (ref), u71 (upval), u70 (upval)
        local v1 = u34._getTime()
        local v2 = v1 + a1
        local u8 = {resolve = a1_2, startTime = v1, endTime = v2}
        if u71 == nil then
            u70 = u8
            u71 = u34._timeEvent:Connect(function() -- Line: 728 -- upvalues: u34 (upval), u70 (upval), u71 (upval)
                local v1
                local v2 = u34._getTime()
                while u70 ~= nil do
                    if not (u70.endTime < v2) then
                        break
                    end
                    v1 = u70
                    u70 = v1.next
                    if u70 ~= nil then
                        u70.previous = nil
                    else
                        u71:Disconnect()
                        u71 = nil
                    end
                    v1.resolve(u34._getTime() - v1.startTime)
                end
            end)
        elseif not (u70.endTime < v2) then
            u8.next = u70
            u70.previous = u8
            u70 = u8
        else
            local v3 = u70
            local next = v3.next
            while next ~= nil do
                if not (next.endTime < v2) then
                    break
                end
                next = next.next
            end
            v3.next = u8
            u8.previous = v3
            if next ~= nil then
                u8.next = next
                next.previous = u8
            end
        end
        a3(function() -- Line: 773 -- upvalues: u8 (val), u70 (upval), u71 (upval)
            local next = u8.next
            if u70 ~= u8 then
                local previous = u8.previous
                previous.next = next
                if next ~= nil then
                    next.previous = previous
                end
                return
            end
            if next ~= nil then
                next.previous = nil
            else
                u71:Disconnect()
                u71 = nil
            end
            u70 = next
        end)
    end))
end

function u34.prototype.timeout(a1, a2, a3) -- Line: 802 -- upvalues: u34 (val), u21 (ref)
    local u6 = debug.traceback(nil, 2)
    return u34.race({
        (u34.delay(a2)):andThen(function() -- Line: 806 -- upvalues: u34 (upval), a3 (val), u21 (upval), a2 (val), u6 (val)
            return u34.reject(a3 == nil and u21.new({
                error = "Timed out",
                kind = u21.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", a2, u6),
            }) or a3)
        end),
        a1,
    })
end

function u34.prototype:getStatus() -- Line: 821
    return self._status
end

function u34.prototype:_andThen(a2, a3, a4) -- Line: 830 -- upvalues: u34 (val), runExecutor (val), u21 (ref)
    self._unhandledRejection = false
    return u34._new(a2, function(a1, a2_2) -- Line: 834
        -- upvalues: a3 (val), a2 (val), runExecutor (upval), a4 (val), self (val), u34 (upval), u21 (upval)
        local v1 = a1
        if a3 then
            local u4 = a2
            local u5 = a3

            function v1(...) -- Line: 167 -- upvalues: runExecutor (upval), u4 (val), u5 (val), a1 (val), a2_2 (val)
                local v1, v2, v3 = runExecutor(u4, u5, ...)
                if v1 then
                    a1(unpack(v3, 1, v2))
                    return
                end
                a2_2(v3[1])
            end
        end
        local v2 = a2_2
        if a4 then
            local u10 = a2
            local u11 = a4

            function v2(...) -- Line: 167 -- upvalues: runExecutor (upval), u10 (val), u11 (val), a1 (val), a2_2 (val)
                local v1, v2, v3 = runExecutor(u10, u11, ...)
                if v1 then
                    a1(unpack(v3, 1, v2))
                    return
                end
                a2_2(v3[1])
            end
        end
        if self._status == u34.Status.Started then
            table.insert(self._queuedResolve, v1)
            table.insert(self._queuedReject, v2)
            return
        end
        if self._status == u34.Status.Resolved then
            local _values = self._values
            local _valuesLength = self._valuesLength
            v1(unpack(_values, 1, _valuesLength))
            return
        end
        if self._status ~= u34.Status.Rejected then
            if self._status == u34.Status.Cancelled then
                a2_2(u21.new({
                    error = "Promise is cancelled",
                    kind = u21.Kind.AlreadyCancelled,
                    context = "Promise created at\n\n" .. a2,
                }))
            end
            return
        end
        local _values_2 = self._values
        local _valuesLength_2 = self._valuesLength
        v2(unpack(_values_2, 1, _valuesLength_2))
    end, self)
end

function u34.prototype:andThen(a2, a3) -- Line: 880
    local v1 = true
    if a2 ~= nil then
        v1 = type(a2) == "function"
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:andThen")))
    v1 = true
    if a3 ~= nil then
        v1 = type(a3) == "function"
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:andThen")))
    return self:_andThen(debug.traceback(nil, 2), a2, a3)
end

function u34.prototype:catch(a2) -- Line: 896
    local v1 = true
    if a2 ~= nil then
        v1 = type(a2) == "function"
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:catch")))
    return self:_andThen(debug.traceback(nil, 2), nil, a2)
end

function u34.prototype.tap(a1, a2) -- Line: 908 -- upvalues: u34 (val), pack (val)
    local v1 = string.format("Please pass a handler function to %s!", "Promise:tap")
    assert(type(a2) == "function", v1)
    return a1:_andThen(debug.traceback(nil, 2), function(...) -- Line: 910 -- upvalues: a2 (val), u34 (upval), pack (upval)
        local v1 = a2(...)
        if not u34.is(v1) then
            return ...
        end
        local u9, u10 = pack(...)
        return v1:andThen(function() -- Line: 915 -- upvalues: u10 (val), u9 (val)
            return unpack(u10, 1, u9)
        end)
    end)
end

function u34.prototype.andThenCall(a1, a2, ...) -- Line: 927 -- upvalues: pack (val)
    local v1 = string.format("Please pass a handler function to %s!", "Promise:andThenCall")
    assert(type(a2) == "function", v1)
    local u16, u17 = pack(...)
    return a1:_andThen(debug.traceback(nil, 2), function() -- Line: 930 -- upvalues: a2 (val), u17 (val), u16 (val)
        return a2(unpack(u17, 1, u16))
    end)
end

function u34.prototype.andThenReturn(a1, ...) -- Line: 938 -- upvalues: pack (val)
    local u3, u4 = pack(...)
    return a1:_andThen(debug.traceback(nil, 2), function() -- Line: 940 -- upvalues: u4 (val), u3 (val)
        return unpack(u4, 1, u3)
    end)
end

function u34.prototype:cancel() -- Line: 949 -- upvalues: u34 (val)
    if self._status ~= u34.Status.Started then
        return
    end
    self._status = u34.Status.Cancelled
    if self._cancellationHook then
        self._cancellationHook()
    end
    if self._parent then
        self._parent:_consumerCancelled(self)
    end
    for k in pairs(self._consumers) do
        k:cancel()
    end
    self:_finalize()
end

function u34.prototype:_consumerCancelled(a2) -- Line: 975 -- upvalues: u34 (val)
    if self._status ~= u34.Status.Started then
        return
    end
    self._consumers[a2] = nil
    if next(self._consumers) == nil then
        self:cancel()
    end
end

function u34.prototype:_finally(a2, a3, a4) -- Line: 991 -- upvalues: u34 (val), runExecutor (val)
    if not a4 then
        self._unhandledRejection = false
    end
    return u34._new(a2, function(a1, a2_2) -- Line: 997 -- upvalues: a3 (val), a2 (val), runExecutor (upval), a4 (val), self (val), u34 (upval)
        local v1 = a1
        if a3 then
            local u4 = a2
            local u5 = a3

            function v1(...) -- Line: 167 -- upvalues: runExecutor (upval), u4 (val), u5 (val), a1 (val), a2_2 (val)
                local v1, v2, v3 = runExecutor(u4, u5, ...)
                if v1 then
                    a1(unpack(v3, 1, v2))
                    return
                end
                a2_2(v3[1])
            end
        end
        if a4 then
            local u9 = v1

            function v1(...) -- Line: 1010 -- upvalues: self (upval), u34 (upval), a1 (val), u9 (val)
                if self._status == u34.Status.Rejected then
                    return a1(self)
                end
                return u9(...)
            end
        end
        if self._status == u34.Status.Started then
            table.insert(self._queuedFinally, v1)
            return
        end
        v1(self._status)
    end, self)
end

function u34.prototype:finally(a2) -- Line: 1029
    local v1 = true
    if a2 ~= nil then
        v1 = type(a2) == "function"
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:finally")))
    return self:_finally(debug.traceback(nil, 2), a2)
end

function u34.prototype.finallyCall(a1, a2, ...) -- Line: 1040 -- upvalues: pack (val)
    local v1 = string.format("Please pass a handler function to %s!", "Promise:finallyCall")
    assert(type(a2) == "function", v1)
    local u16, u17 = pack(...)
    return a1:_finally(debug.traceback(nil, 2), function() -- Line: 1043 -- upvalues: a2 (val), u17 (val), u16 (val)
        return a2(unpack(u17, 1, u16))
    end)
end

function u34.prototype.finallyReturn(a1, ...) -- Line: 1051 -- upvalues: pack (val)
    local u3, u4 = pack(...)
    return a1:_finally(debug.traceback(nil, 2), function() -- Line: 1053 -- upvalues: u4 (val), u3 (val)
        return unpack(u4, 1, u3)
    end)
end

function u34.prototype.done(a1, a2) -- Line: 1061
    local v1 = true
    if a2 ~= nil then
        v1 = type(a2) == "function"
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:done")))
    return a1:_finally(debug.traceback(nil, 2), a2, true)
end

function u34.prototype.doneCall(a1, a2, ...) -- Line: 1072 -- upvalues: pack (val)
    local v1 = string.format("Please pass a handler function to %s!", "Promise:doneCall")
    assert(type(a2) == "function", v1)
    local u16, u17 = pack(...)
    return a1:_finally(debug.traceback(nil, 2), function() -- Line: 1075 -- upvalues: a2 (val), u17 (val), u16 (val)
        return a2(unpack(u17, 1, u16))
    end, true)
end

function u34.prototype.doneReturn(a1, ...) -- Line: 1083 -- upvalues: pack (val)
    local u3, u4 = pack(...)
    return a1:_finally(debug.traceback(nil, 2), function() -- Line: 1085 -- upvalues: u4 (val), u3 (val)
        return unpack(u4, 1, u3)
    end, true)
end

function u34.prototype:awaitStatus() -- Line: 1095 -- upvalues: u34 (val)
    self._unhandledRejection = false
    if self._status == u34.Status.Started then
        local BindableEvent = Instance.new("BindableEvent")
        self:finally(function() -- Line: 1101 -- upvalues: BindableEvent (val)
            BindableEvent:Fire()
        end)
        BindableEvent.Event:Wait()
        BindableEvent:Destroy()
    end
    if self._status == u34.Status.Resolved then
        local _status = self._status
        local _values = self._values
        local _valuesLength = self._valuesLength
        return _status, unpack(_values, 1, _valuesLength)
    end
    if self._status ~= u34.Status.Rejected then
        return self._status
    end
    local _status_2 = self._status
    local _values_2 = self._values
    local _valuesLength_2 = self._valuesLength
    return _status_2, unpack(_values_2, 1, _valuesLength_2)
end

local function awaitHelper(a1, ...) -- Line: 1118 -- upvalues: u34 (val)
    return a1 == u34.Status.Resolved, ...
end

function u34.prototype:await() -- Line: 1125 -- upvalues: awaitHelper (val)
    return awaitHelper(self:awaitStatus())
end

local function expectHelper(a1, ...) -- Line: 1129 -- upvalues: u34 (val)
    if a1 ~= u34.Status.Resolved then
        error(if (...) ~= nil then ... else "Expected Promise rejected with no value.", 3)
    end
    return ...
end

function u34.prototype.expect(a1) -- Line: 1141 -- upvalues: expectHelper (val)
    return expectHelper(a1:awaitStatus())
end

u34.prototype.awaitValue = u34.prototype.expect

function u34.prototype._unwrap(a1) -- Line: 1155 -- upvalues: u34 (val)
    if a1._status == u34.Status.Started then
        error("Promise has not resolved or rejected.", 2)
    end
    local v1 = a1._status == u34.Status.Resolved
    local _values = a1._values
    local _valuesLength = a1._valuesLength
    return v1, unpack(_values, 1, _valuesLength)
end

function u34.prototype:_resolve(...) -- Line: 1165 -- upvalues: u34 (val), u21 (ref), pack (val)
    local v1, v2
    if self._status ~= u34.Status.Started then
        if u34.is((...)) then
            ...:_consumerCancelled(self)
        end
        return
    end
    if not u34.is((...)) then
        self._status = u34.Status.Resolved
        v1, v2 = pack(...)
        self._valuesLength = v1
        self._values = v2
        for i, v in ipairs(self._queuedResolve) do
            coroutine.wrap(v)(...)
        end
        self:_finalize()
        return
    end
    v1 = select("#", ...)
    if v1 > 1 then
        v1 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", self._source)
        warn(v1)
    end
    local u30 = ...
    v2 = u30:andThen(function(...) -- Line: 1188 -- upvalues: self (val)
        self:_resolve(...)
    end, function(...) -- Line: 1191 -- upvalues: u30 (val), u21 (upval), self (val)
        local v1 = u30._values[1]
        if u30._error then
            v1 = u21.new({
                context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                error = u30._error,
                kind = u21.Kind.ExecutionError,
            })
        end
        if u21.isKind(v1, u21.Kind.ExecutionError) then
            return self:_reject((v1:extend({
                error = "This Promise was chained to a Promise that errored.",
                trace = "",
                context = string.format(
                    "The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n",
                    self._source
                ),
            })))
        end
        self:_reject(...)
    end)
    if v2._status == u34.Status.Cancelled then
        self:cancel()
        return
    end
    if v2._status == u34.Status.Started then
        self._parent = v2
        v2._consumers[self] = true
    end
end

function u34.prototype:_reject(...) -- Line: 1240 -- upvalues: u34 (val), pack (val)
    if self._status ~= u34.Status.Started then
        return
    end
    self._status = u34.Status.Rejected
    local v1, v2 = pack(...)
    self._valuesLength = v1
    self._values = v2
    if next(self._queuedReject) == nil then
        local u39 = tostring((...))
        coroutine.wrap(function() -- Line: 1262 -- upvalues: u34 (upval), self (val), u39 (val)
            u34._timeEvent:Wait()
            if not self._unhandledRejection then
                return
            end
            local v1 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u39, self._source)
            if u34.TEST then
                return
            end
            warn(v1)
        end)()
    else
        for i, v in ipairs(self._queuedReject) do
            coroutine.wrap(v)(...)
        end
    end
    self:_finalize()
end

function u34.prototype:_finalize() -- Line: 1294 -- upvalues: u34 (val)
    for i, v in ipairs(self._queuedFinally) do
        coroutine.wrap(v)(self._status)
    end
    self._queuedFinally = nil
    self._queuedReject = nil
    self._queuedResolve = nil
    if not u34.TEST then
        self._parent = nil
        self._consumers = nil
    end
end

function u34.prototype.now(a1, a2) -- Line: 1317 -- upvalues: u34 (val), u21 (ref)
    local v1 = debug.traceback(nil, 2)
    if (a1:getStatus()) == u34.Status.Resolved then
        return a1:_andThen(v1, function(...) -- Line: 1320
            return ...
        end)
    end
    return u34.reject(a2 == nil and u21.new({
        error = "This Promise was not resolved in time for :now()",
        kind = u21.Kind.NotResolvedInTime,
        context = ":now() was called at:\n\n" .. v1,
    }) or a2)
end

function u34.retry(a1, a2, ...) -- Line: 1335 -- upvalues: u34 (val)
    assert(type(a1) == "function", "Parameter #1 to Promise.retry must be a function")
    assert(type(a2) == "number", "Parameter #2 to Promise.retry must be a number")
    local u21 = {}
    u21[1] = ...
    local u26 = select("#", ...)
    return (u34.resolve((a1(...)))):catch(function(...) -- Line: 1341 -- upvalues: a2 (val), u34 (upval), a1 (val), u21 (val), u26 (val)
        if a2 > 0 then
            return u34.retry(a1, a2 - 1, unpack(u21, 1, u26))
        end
        return u34.reject(...)
    end)
end

function u34.fromEvent(a1, a2) -- Line: 1354 -- upvalues: u34 (val)
    local u5 = a2 or function() -- Line: 1355
        return true
    end
    return (u34._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 1359 -- upvalues: a1 (val), u5 (ref)
        local u3 = nil
        local u4 = false

        local function disconnect() -- Line: 1363 -- upvalues: u3 (ref)
            u3:Disconnect()
            u3 = nil
        end

        u3 = a1:Connect(function(...) -- Line: 1372 -- upvalues: u5 (upval), a1_2 (val), u3 (ref), u4 (ref)
            local v1 = u5(...)
            if v1 ~= true then
                if type(v1) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean")
                end
                return
            end
            a1_2(...)
            if not u3 then
                u4 = true
                return
            end
            u3:Disconnect()
            u3 = nil
        end)
        if u4 and u3 then
            return (disconnect())
        end
        a3(function() -- Line: 1392 -- upvalues: u3 (ref)
            u3:Disconnect()
            u3 = nil
        end)
    end))
end

return u34