-- ReplicatedStorage.Packages.Promise
-- Script path: ReplicatedStorage.Packages.Promise
-- Decompile time: 19.58 ms

local u0 = {__mode = "k"}

local function isCallable(a1) -- Line: 10
    if type(a1) == "function" then
        return true
    end
    if type(a1) == "table" then
        local v1 = getmetatable(a1)
        if v1 and type((rawget(v1, "__call"))) == "function" then
            return true
        end
    end
    return false
end

local function makeEnum(a1, a2) -- Line: 28
    local v1 = {}
    for i, v in ipairs(a2) do
        v1[v] = v
    end
    return (setmetatable(v1, {
        __index = function(a1_2, a2) -- Line: 36 -- upvalues: a1 (val)
            error(string.format("%s is not in %s!", a2, a1), 2)
        end,
        __newindex = function() -- Line: 39 -- upvalues: a1 (val)
            error(string.format("Creating new members in %s is not allowed!", a1), 2)
        end,
    }))
end

local u13 = {
    Kind = makeEnum("Promise.Error.Kind", {"ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut"}),
}
u13.__index = u13

function u13.new(a1, a2) -- Line: 64 -- upvalues: u13 (ref)
    local v1 = a1 or {}
    return (setmetatable({
        error = tostring(v1.error) or "[This error has no error text.]",
        trace = v1.trace,
        context = v1.context,
        kind = v1.kind,
        parent = a2,
        createdTick = os.clock(),
        createdTrace = debug.traceback(),
    }, u13))
end

function u13.is(a1) -- Line: 77
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

function u13.isKind(a1, a2) -- Line: 89 -- upvalues: u13 (ref)
    assert(a2 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")
    return u13.is(a1) and a1.kind == a2
end

function u13:extend(a2) -- Line: 95 -- upvalues: u13 (ref)
    local v1 = a2 or {}
    local kind = v1.kind or self.kind
    v1.kind = kind
    return u13.new(v1, self)
end

function u13.getErrorChain(a1) -- Line: 103
    local v1 = {a1}
    while v1[#v1].parent do
        table.insert(v1, v1[#v1].parent)
    end
    return v1
end

function u13.__tostring(a1) -- Line: 113
    local v1 = {string.format("-- Promise.Error(%s) --", a1.kind or "?")}
    for i, v in ipairs(a1:getErrorChain()) do
        table.insert(v1, (table.concat({v.trace or v.error, v.context}, "\n")))
    end
    return table.concat(v1, "\n")
end

local function pack(...) -- Line: 137
    return (select("#", ...)), {...}
end

local function packResult(a1, ...) -- Line: 144
    return a1, (select("#", ...)), {...}
end

local function makeErrorHandler(a1) -- Line: 148 -- upvalues: u13 (ref)
    assert(a1 ~= nil, "traceback is nil")
    return function(a1_2) -- Line: 151 -- upvalues: u13 (upval), a1 (val)
        if type(a1_2) == "table" then
            return a1_2
        end
        return u13.new({
            error = a1_2,
            kind = u13.Kind.ExecutionError,
            trace = debug.traceback(tostring(a1_2), 2),
            context = "Promise created at:\n\n" .. a1,
        })
    end
end

local function runExecutor(a1, a2, ...) -- Line: 171 -- upvalues: packResult (val), u13 (ref)
    local v1 = xpcall
    assert(a1 ~= nil, "traceback is nil")
    return packResult(v1(a2, function(a1_2) -- Line: 151 -- upvalues: u13 (upval), a1 (val)
        if type(a1_2) == "table" then
            return a1_2
        end
        return u13.new({
            error = a1_2,
            kind = u13.Kind.ExecutionError,
            trace = debug.traceback(tostring(a1_2), 2),
            context = "Promise created at:\n\n" .. a1,
        })
    end, ...))
end

local function createAdvancer(a1, a2, a3, a4) -- Line: 179 -- upvalues: runExecutor (val)
    return function(...) -- Line: 180 -- upvalues: runExecutor (upval), a1 (val), a2 (val), a3 (val), a4 (val)
        local v1, v2, v3 = runExecutor(a1, a2, ...)
        if v1 then
            a3(unpack(v3, 1, v2))
            return
        end
        a4(v3[1])
    end
end

local function isEmpty(a1) -- Line: 191
    return next(a1) == nil
end

local u26 = {Error = u13}
u26.Status = makeEnum("Promise.Status", {"Started", "Resolved", "Rejected", "Cancelled"})
u26._getTime = os.clock
u26._timeEvent = game:GetService("RunService").Heartbeat
u26._unhandledRejectionCallbacks = {}
u26.prototype = {}
u26.__index = u26.prototype

function u26._new(a1, a2, a3) -- Line: 231 -- upvalues: u26 (val), u0 (val), runExecutor (val)
    if a3 ~= nil and not u26.is(a3) then
        error("Argument #2 to Promise.new must be a promise or nil", 2)
    end
    local u11 = {_valuesLength = -1, _unhandledRejection = true, _source = a1}
    u11._status = u26.Status.Started
    u11._queuedResolve = {}
    u11._queuedReject = {}
    u11._queuedFinally = {}
    u11._parent = a3
    u11._consumers = setmetatable({}, u0)
    if a3 and a3._status == u26.Status.Started then
        a3._consumers[u11] = true
    end
    local v1 = u26
    setmetatable(u11, v1)

    local function resolve(...) -- Line: 279 -- upvalues: u11 (val)
        u11:_resolve(...)
    end

    local function reject(...) -- Line: 283 -- upvalues: u11 (val)
        u11:_reject(...)
    end

    local function onCancel(a1) -- Line: 287 -- upvalues: u11 (val), u26 (upval)
        if a1 then
            if u11._status ~= u26.Status.Cancelled then
                u11._cancellationHook = a1
            else
                a1()
            end
        end
        return u11._status == u26.Status.Cancelled
    end

    u11._thread = coroutine.create(function() -- Line: 299
        -- upvalues: runExecutor (upval), u11 (val), a2 (val), resolve (val), reject (val), onCancel (val)
        local v1, v2
        v1, _, v2 = runExecutor(u11._source, a2, resolve, reject, onCancel)
        if not v1 then
            reject(v2[1])
        end
    end)
    task.spawn(u11._thread)
    return u11
end

function u26.new(a1) -- Line: 350 -- upvalues: u26 (val)
    return u26._new(debug.traceback(nil, 2), a1)
end

function u26.__tostring(a1) -- Line: 354
    return string.format("Promise(%s)", a1._status)
end

function u26.defer(a1) -- Line: 376 -- upvalues: u26 (val), runExecutor (val)
    local u4 = debug.traceback(nil, 2)
    return (u26._new(u4, function(a1_2, a2, a3) -- Line: 379 -- upvalues: u26 (upval), runExecutor (upval), u4 (val), a1 (val)
        local u3 = nil
        local v1 = u26._timeEvent:Connect(function() -- Line: 381
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

u26.async = u26.defer

function u26.resolve(...) -- Line: 419 -- upvalues: pack (val), u26 (val)
    local u2, u3 = pack(...)
    return u26._new(debug.traceback(nil, 2), function(a1) -- Line: 421 -- upvalues: u3 (val), u2 (val)
        a1(unpack(u3, 1, u2))
    end)
end

function u26.reject(...) -- Line: 436 -- upvalues: pack (val), u26 (val)
    local u2, u3 = pack(...)
    return u26._new(debug.traceback(nil, 2), function(a1, a2) -- Line: 438 -- upvalues: u3 (val), u2 (val)
        a2(unpack(u3, 1, u2))
    end)
end

function u26._try(a1, a2, ...) -- Line: 447 -- upvalues: pack (val), u26 (val)
    local u4, u5 = pack(...)
    return u26._new(a1, function(a1) -- Line: 450 -- upvalues: a2 (val), u5 (val), u4 (val)
        a1(a2(unpack(u5, 1, u4)))
    end)
end

function u26.try(a1, ...) -- Line: 478 -- upvalues: u26 (val)
    return u26._try(debug.traceback(nil, 2), a1, ...)
end

function u26._all(a1, a2, a3) -- Line: 487 -- upvalues: u26 (val)
    if type(a2) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
    end
    for k, v in pairs(a2) do
        if not u26.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(k))), 3)
        end
    end
    if #a2 ~= 0 and a3 ~= 0 then
        return u26._new(a1, function(a1, a2_2, a3_2) -- Line: 505 -- upvalues: a3 (val), a2 (val)
            local u3 = {}
            local u4 = {}
            local u5 = 0
            local u6 = 0
            local u7 = false

            local function resolveOne(a1_2, ...) -- Line: 523
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

            a3_2(function() -- Line: 516 -- upvalues: u4 (val)
                for i, v in ipairs(u4) do
                    v:cancel()
                end
            end)
            for i, v in ipairs(a2) do
                u4[i] = (v:andThen(function(...) -- Line: 548 -- upvalues: resolveOne (val), i (val)
                    resolveOne(i, ...)
                end, function(...) -- Line: 550 -- upvalues: u6 (ref), a3 (upval), a2 (upval), u4 (val), u7 (ref), a2_2 (val)
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
    return u26.resolve({})
end

function u26.all(a1) -- Line: 592 -- upvalues: u26 (val)
    return u26._all(debug.traceback(nil, 2), a1)
end

function u26.fold(a1, a2, a3) -- Line: 621 -- upvalues: u26 (val)
    local v1
    assert(type(a1) == "table", "Bad argument #1 to Promise.fold: must be a table")
    if type(a2) == "function" then
        v1 = true
    elseif type(a2) ~= "table" then
        v1 = false
    else
        local v2 = getmetatable(a2)
        v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
    end
    assert(v1, "Bad argument #2 to Promise.fold: must be a function")
    local u41 = u26.resolve(a3)
    return ((u26.each(a1, function(a1, a2_2) -- Line: 626 -- upvalues: u41 (ref), a2 (val)
        u41 = u41:andThen(function(a1_2) -- Line: 627 -- upvalues: a2 (upval), a1 (val), a2_2 (val)
            return a2(a1_2, a1, a2_2)
        end)
    end)):andThen(function() -- Line: 630 -- upvalues: u41 (ref)
        return u41
    end))
end

function u26.some(a1, a2) -- Line: 654 -- upvalues: u26 (val)
    assert(type(a2) == "number", "Bad argument #2 to Promise.some: must be a number")
    return u26._all(debug.traceback(nil, 2), a1, a2)
end

function u26.any(a1) -- Line: 678 -- upvalues: u26 (val)
    return (u26._all(debug.traceback(nil, 2), a1, 1)):andThen(function(a1) -- Line: 679
        return a1[1]
    end)
end

function u26.allSettled(a1) -- Line: 700 -- upvalues: u26 (val)
    if type(a1) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
    end
    for k, v in pairs(a1) do
        if not u26.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(k))), 2)
        end
    end
    if #a1 == 0 then
        return u26.resolve({})
    end
    return u26._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 718 -- upvalues: a1 (val)
        local u3 = {}
        local u4 = {}
        local u5 = 0

        local function resolveOne(a1_3, ...) -- Line: 728 -- upvalues: u5 (ref), u3 (val), a1 (upval), a1_2 (val)
            u5 = u5 + 1
            u3[a1_3] = (...)
            local v1 = u5
            if #a1 <= v1 then
                a1_2(u3)
            end
        end

        a3(function() -- Line: 738 -- upvalues: u4 (val)
            for i, v in ipairs(u4) do
                v:cancel()
            end
        end)
        for i, v in ipairs(a1) do
            u4[i] = (v:finally(function(...) -- Line: 747 -- upvalues: resolveOne (val), i (val)
                resolveOne(i, ...)
            end))
        end
    end)
end

function u26.race(a1) -- Line: 778 -- upvalues: u26 (val)
    local v1 = string.format("Please pass a list of promises to %s", "Promise.race")
    assert(type(a1) == "table", v1)
    for k, v in pairs(a1) do
        assert(u26.is(v), (string.format("Non-promise value passed into %s at index %s", "Promise.race", (tostring(k)))))
    end
    return u26._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 785 -- upvalues: a1 (val)
        local u3 = {}
        local u4 = false

        local function cancel() -- Line: 789 -- upvalues: u3 (val)
            for i, v in ipairs(u3) do
                v:cancel()
            end
        end

        local function finalize(a1) -- Line: 795 -- upvalues: u3 (val), u4 (ref)
            return function(...) -- Line: 796 -- upvalues: u3 (upval), u4 (upval), a1 (val)
                for i, v in ipairs(u3) do
                    v:cancel()
                end
                u4 = true
                return a1(...)
            end
        end

        if a3(function(...) -- Line: 796 -- upvalues: u3 (val), u4 (ref), a2 (val)
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
            u3[i] = (v:andThen(function(...) -- Line: 796 -- upvalues: u3 (val), u4 (ref), a1_2 (val)
                for i, v in ipairs(u3) do
                    v:cancel()
                end
                u4 = true
                return a1_2(...)
            end, function(...) -- Line: 796 -- upvalues: u3 (val), u4 (ref), a2 (val)
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

function u26.each(a1, a2) -- Line: 873 -- upvalues: u26 (val), u13 (ref)
    local v1
    local v2 = string.format("Please pass a list of promises to %s", "Promise.each")
    assert(type(a1) == "table", v2)
    if type(a2) == "function" then
        v1 = true
    elseif type(a2) ~= "table" then
        v1 = false
    else
        v2 = getmetatable(a2)
        v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise.each")))
    return u26._new(debug.traceback(nil, 2), function(a1_2, a2_2, a3) -- Line: 877 -- upvalues: a1 (val), u26 (upval), u13 (upval), a2 (val)
        local v1, v2, v3
        local v4 = {}
        local u85 = {}
        local u5 = false

        local function cancel() -- Line: 883 -- upvalues: u85 (val)
            for i, v in ipairs(u85) do
                v:cancel()
            end
        end

        a3(function() -- Line: 889 -- upvalues: u5 (ref), u85 (val)
            u5 = true
            for i, v in ipairs(u85) do
                v:cancel()
            end
        end)
        local v5 = {}
        for i, v in ipairs(a1) do
            if not u26.is(v) then
                v5[i] = v
            else
                if (v:getStatus()) == u26.Status.Cancelled then
                    for i4, j in ipairs(u85) do
                        j:cancel()
                    end
                    return (a2_2((u13.new({
                        error = "Promise is cancelled",
                        kind = u13.Kind.AlreadyCancelled,
                        context = string.format(
                            "The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
                            i,
                            v._source
                        ),
                    }))))
                end
                if (v:getStatus()) == u26.Status.Rejected then
                    for i2, i3 in ipairs(u85) do
                        i3:cancel()
                    end
                    return (a2_2((select(2, (v:await())))))
                end
                v1 = v:andThen(function(...) -- Line: 922
                    return ...
                end)
                table.insert(u85, v1)
                v5[i] = v1
            end
        end
        for i5, k in ipairs(v5) do
            if u26.is(k) then
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
            v1 = u26.resolve(a2(k, i5))
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

function u26.is(a1) -- Line: 973 -- upvalues: u26 (val)
    local v1
    if type(a1) ~= "table" then
        return false
    end
    local v2 = getmetatable(a1)
    if v2 == u26 then
        return true
    end
    if v2 == nil then
        local andThen = a1.andThen
        if type(andThen) == "function" then
            return true
        end
        if type(andThen) == "table" then
            v1 = getmetatable(andThen)
            if v1 and type((rawget(v1, "__call"))) == "function" then
                return true
            end
        end
        return false
    end
    if type(v2) == "table" then
        local v3 = rawget(v2, "__index")
        if type(v3) == "table" then
            local v4
            v1 = rawget(v2, "__index")
            v3 = rawget(v1, "andThen")
            if type(v3) == "function" then
                v4 = true
            elseif type(v3) ~= "table" then
                v4 = false
            else
                v1 = getmetatable(v3)
                v4 = if not v1 then false else not (type((rawget(v1, "__call"))) ~= "function")
            end
            if v4 then
                return true
            end
        end
    end
    return false
end

function u26.promisify(a1) -- Line: 1022 -- upvalues: u26 (val)
    return function(...) -- Line: 1023 -- upvalues: u26 (upval), a1 (val)
        return u26._try(debug.traceback(nil, 2), a1, ...)
    end
end

local u64 = nil
local u65 = nil

function u26.delay(a1) -- Line: 1053 -- upvalues: u26 (val), u65 (ref), u64 (ref)
    assert(type(a1) == "number", "Bad argument #1 to Promise.delay, must be a number.")
    if not (a1 >= 0.016666666666666666) or a1 == (1 / 0) then
        a1 = 0.016666666666666666
    end
    return (u26._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 1061 -- upvalues: u26 (upval), a1 (ref), u65 (upval), u64 (upval)
        local v1 = u26._getTime()
        local v2 = v1 + a1
        local u8 = {resolve = a1_2, startTime = v1, endTime = v2}
        if u65 == nil then
            u64 = u8
            u65 = u26._timeEvent:Connect(function() -- Line: 1073 -- upvalues: u26 (upval), u64 (upval), u65 (upval)
                local v1
                local v2 = u26._getTime()
                while u64 ~= nil do
                    if not (u64.endTime < v2) then
                        break
                    end
                    v1 = u64
                    u64 = v1.next
                    if u64 ~= nil then
                        u64.previous = nil
                    else
                        u65:Disconnect()
                        u65 = nil
                    end
                    v1.resolve(u26._getTime() - v1.startTime)
                end
            end)
        elseif not (u64.endTime < v2) then
            u8.next = u64
            u64.previous = u8
            u64 = u8
        else
            local v3 = u64
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
        a3(function() -- Line: 1118 -- upvalues: u8 (val), u64 (upval), u65 (upval)
            local next = u8.next
            if u64 ~= u8 then
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
                u65:Disconnect()
                u65 = nil
            end
            u64 = next
        end)
    end))
end

function u26.prototype.timeout(a1, a2, a3) -- Line: 1182 -- upvalues: u26 (val), u13 (ref)
    local u6 = debug.traceback(nil, 2)
    return u26.race({
        (u26.delay(a2)):andThen(function() -- Line: 1186 -- upvalues: u26 (upval), a3 (val), u13 (upval), a2 (val), u6 (val)
            return u26.reject(a3 == nil and u13.new({
                error = "Timed out",
                kind = u13.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", a2, u6),
            }) or a3)
        end),
        a1,
    })
end

function u26.prototype:getStatus() -- Line: 1206
    return self._status
end

function u26.prototype:_andThen(a2, a3, a4) -- Line: 1215 -- upvalues: u26 (val), runExecutor (val)
    self._unhandledRejection = false
    if self._status ~= u26.Status.Cancelled then
        return u26._new(a2, function(a1, a2_2, a3_2) -- Line: 1227
            -- upvalues: a3 (val), a2 (val), runExecutor (upval), a4 (val), self (val), u26 (upval)
            local u7 = a1
            if a3 then
                local u5 = a2
                local u6 = a3

                function u7(...) -- Line: 180 -- upvalues: runExecutor (upval), u5 (val), u6 (val), a1 (val), a2_2 (val)
                    local v1, v2, v3 = runExecutor(u5, u6, ...)
                    if v1 then
                        a1(unpack(v3, 1, v2))
                        return
                    end
                    a2_2(v3[1])
                end
            end
            local u13 = a2_2
            if a4 then
                local u11 = a2
                local u12 = a4

                function u13(...) -- Line: 180
                    -- upvalues: runExecutor (upval), u11 (val), u12 (val), a1 (val), a2_2 (val)
                    local v1, v2, v3 = runExecutor(u11, u12, ...)
                    if v1 then
                        a1(unpack(v3, 1, v2))
                        return
                    end
                    a2_2(v3[1])
                end
            end
            if self._status == u26.Status.Started then
                local v1 = u7
                table.insert(self._queuedResolve, v1)
                v1 = u13
                table.insert(self._queuedReject, v1)
                a3_2(function() -- Line: 1246 -- upvalues: self (upval), u26 (upval), u7 (ref), u13 (ref)
                    if self._status == u26.Status.Started then
                        table.remove(self._queuedResolve, table.find(self._queuedResolve, u7))
                        table.remove(self._queuedReject, table.find(self._queuedReject, u13))
                    end
                end)
            else
                local v2
                if self._status == u26.Status.Resolved then
                    v2 = u7
                    local _values = self._values
                    local _valuesLength = self._valuesLength
                    v2(unpack(_values, 1, _valuesLength))
                elseif self._status == u26.Status.Rejected then
                    v2 = u13
                    local _values_2 = self._values
                    local _valuesLength_2 = self._valuesLength
                    v2(unpack(_values_2, 1, _valuesLength_2))
                end
            end
        end, self)
    end
    local v1 = u26.new(function() end)
    v1:cancel()
    return v1
end

function u26.prototype:andThen(a2, a3) -- Line: 1285
    local v1
    local v2 = true
    if a2 ~= nil then
        if type(a2) == "function" then
            v2 = true
        elseif type(a2) ~= "table" then
            v2 = false
        else
            v1 = getmetatable(a2)
            v2 = if not v1 then false else not (type((rawget(v1, "__call"))) ~= "function")
        end
    end
    assert(v2, (string.format("Please pass a handler function to %s!", "Promise:andThen")))
    v2 = true
    if a3 ~= nil then
        if type(a3) == "function" then
            v2 = true
        elseif type(a3) ~= "table" then
            v2 = false
        else
            v1 = getmetatable(a3)
            v2 = if not v1 then false else not (type((rawget(v1, "__call"))) ~= "function")
        end
    end
    assert(v2, (string.format("Please pass a handler function to %s!", "Promise:andThen")))
    return self:_andThen(debug.traceback(nil, 2), a2, a3)
end

function u26.prototype:catch(a2) -- Line: 1312
    local v1 = true
    if a2 ~= nil then
        if type(a2) == "function" then
            v1 = true
        elseif type(a2) ~= "table" then
            v1 = false
        else
            local v2 = getmetatable(a2)
            v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
        end
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:catch")))
    return self:_andThen(debug.traceback(nil, 2), nil, a2)
end

function u26.prototype.tap(a1, a2) -- Line: 1333 -- upvalues: u26 (val), pack (val)
    local v1
    if type(a2) == "function" then
        v1 = true
    elseif type(a2) ~= "table" then
        v1 = false
    else
        local v2 = getmetatable(a2)
        v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:tap")))
    return a1:_andThen(debug.traceback(nil, 2), function(...) -- Line: 1335 -- upvalues: a2 (val), u26 (upval), pack (upval)
        local v1 = a2(...)
        if not u26.is(v1) then
            return ...
        end
        local u9, u10 = pack(...)
        return v1:andThen(function() -- Line: 1340 -- upvalues: u10 (val), u9 (val)
            return unpack(u10, 1, u9)
        end)
    end)
end

function u26.prototype.andThenCall(a1, a2, ...) -- Line: 1368 -- upvalues: pack (val)
    local v1
    if type(a2) == "function" then
        v1 = true
    elseif type(a2) ~= "table" then
        v1 = false
    else
        local v2 = getmetatable(a2)
        v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:andThenCall")))
    local u29, u30 = pack(...)
    return a1:_andThen(debug.traceback(nil, 2), function() -- Line: 1371 -- upvalues: a2 (val), u30 (val), u29 (val)
        return a2(unpack(u30, 1, u29))
    end)
end

function u26.prototype.andThenReturn(a1, ...) -- Line: 1398 -- upvalues: pack (val)
    local u3, u4 = pack(...)
    return a1:_andThen(debug.traceback(nil, 2), function() -- Line: 1400 -- upvalues: u4 (val), u3 (val)
        return unpack(u4, 1, u3)
    end)
end

function u26.prototype:cancel() -- Line: 1416 -- upvalues: u26 (val)
    if self._status ~= u26.Status.Started then
        return
    end
    self._status = u26.Status.Cancelled
    if self._cancellationHook then
        self._cancellationHook()
    end
    coroutine.close(self._thread)
    if self._parent then
        self._parent:_consumerCancelled(self)
    end
    for k in pairs(self._consumers) do
        k:cancel()
    end
    self:_finalize()
end

function u26.prototype:_consumerCancelled(a2) -- Line: 1444 -- upvalues: u26 (val)
    if self._status ~= u26.Status.Started then
        return
    end
    self._consumers[a2] = nil
    if next(self._consumers) == nil then
        self:cancel()
    end
end

function u26.prototype:_finally(a2, a3) -- Line: 1460 -- upvalues: u26 (val)
    self._unhandledRejection = false
    return (u26._new(a2, function(a1, a2, a3_2) -- Line: 1463 -- upvalues: self (val), a3 (val), u26 (upval)
        local u3 = nil
        a3_2(function() -- Line: 1466 -- upvalues: self (upval), u3 (ref)
            self:_consumerCancelled(self)
            if u3 then
                u3:cancel()
            end
        end)
        local v1 = a1
        if a3 then
            function v1(...) -- Line: 1479
                -- upvalues: a3 (upval), u26 (upval), u3 (ref), a1 (val), self (upval), a2 (val)
                local v1 = a3(...)
                if not u26.is(v1) then
                    a1(self)
                    return
                end
                u3 = v1
                ;(v1:finally(function(a1_2) -- Line: 1486 -- upvalues: u26 (upval), a1 (upval), self (upval)
                    if a1_2 ~= u26.Status.Rejected then
                        a1(self)
                    end
                end)):catch(function(...) -- Line: 1491 -- upvalues: a2 (upval)
                    a2(...)
                end)
            end
        end
        if self._status ~= u26.Status.Started then
            v1(self._status)
        else
            table.insert(self._queuedFinally, v1)
        end
    end))
end

function u26.prototype:finally(a2) -- Line: 1561
    local v1 = true
    if a2 ~= nil then
        if type(a2) == "function" then
            v1 = true
        elseif type(a2) ~= "table" then
            v1 = false
        else
            local v2 = getmetatable(a2)
            v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
        end
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:finally")))
    return self:_finally(debug.traceback(nil, 2), a2)
end

function u26.prototype.finallyCall(a1, a2, ...) -- Line: 1575 -- upvalues: pack (val)
    local v1
    if type(a2) == "function" then
        v1 = true
    elseif type(a2) ~= "table" then
        v1 = false
    else
        local v2 = getmetatable(a2)
        v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
    end
    assert(v1, (string.format("Please pass a handler function to %s!", "Promise:finallyCall")))
    local u29, u30 = pack(...)
    return a1:_finally(debug.traceback(nil, 2), function() -- Line: 1578 -- upvalues: a2 (val), u30 (val), u29 (val)
        return a2(unpack(u30, 1, u29))
    end)
end

function u26.prototype.finallyReturn(a1, ...) -- Line: 1601 -- upvalues: pack (val)
    local u3, u4 = pack(...)
    return a1:_finally(debug.traceback(nil, 2), function() -- Line: 1603 -- upvalues: u4 (val), u3 (val)
        return unpack(u4, 1, u3)
    end)
end

function u26.prototype:awaitStatus() -- Line: 1615 -- upvalues: u26 (val)
    self._unhandledRejection = false
    if self._status == u26.Status.Started then
        local u7 = coroutine.running()
        ;(self:finally(function() -- Line: 1622 -- upvalues: u7 (val)
            task.spawn(u7)
        end)):catch(function() end)
        coroutine.yield()
    end
    if self._status == u26.Status.Resolved then
        local _status = self._status
        local _values = self._values
        local _valuesLength = self._valuesLength
        return _status, unpack(_values, 1, _valuesLength)
    end
    if self._status ~= u26.Status.Rejected then
        return self._status
    end
    local _status_2 = self._status
    local _values_2 = self._values
    local _valuesLength_2 = self._valuesLength
    return _status_2, unpack(_values_2, 1, _valuesLength_2)
end

local function awaitHelper(a1, ...) -- Line: 1643 -- upvalues: u26 (val)
    return a1 == u26.Status.Resolved, ...
end

function u26.prototype:await() -- Line: 1668 -- upvalues: awaitHelper (val)
    return awaitHelper(self:awaitStatus())
end

local function expectHelper(a1, ...) -- Line: 1672 -- upvalues: u26 (val)
    if a1 ~= u26.Status.Resolved then
        error(if (...) ~= nil then ... else "Expected Promise rejected with no value.", 3)
    end
    return ...
end

function u26.prototype.expect(a1) -- Line: 1705 -- upvalues: expectHelper (val)
    return expectHelper(a1:awaitStatus())
end

u26.prototype.awaitValue = u26.prototype.expect

function u26.prototype._unwrap(a1) -- Line: 1719 -- upvalues: u26 (val)
    if a1._status == u26.Status.Started then
        error("Promise has not resolved or rejected.", 2)
    end
    local v1 = a1._status == u26.Status.Resolved
    local _values = a1._values
    local _valuesLength = a1._valuesLength
    return v1, unpack(_values, 1, _valuesLength)
end

function u26.prototype:_resolve(...) -- Line: 1729 -- upvalues: u26 (val), u13 (ref), pack (val)
    local v1, v2
    if self._status ~= u26.Status.Started then
        if u26.is((...)) then
            ...:_consumerCancelled(self)
        end
        return
    end
    if not u26.is((...)) then
        self._status = u26.Status.Resolved
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
    v2 = u30:andThen(function(...) -- Line: 1750 -- upvalues: self (val)
        self:_resolve(...)
    end, function(...) -- Line: 1752 -- upvalues: u30 (val), u13 (upval), self (val)
        local v1 = u30._values[1]
        if u30._error then
            v1 = u13.new({
                context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                error = u30._error,
                kind = u13.Kind.ExecutionError,
            })
        end
        if u13.isKind(v1, u13.Kind.ExecutionError) then
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
    if v2._status == u26.Status.Cancelled then
        self:cancel()
        return
    end
    if v2._status == u26.Status.Started then
        self._parent = v2
        v2._consumers[self] = true
    end
end

function u26.prototype:_reject(...) -- Line: 1801 -- upvalues: u26 (val), pack (val)
    if self._status ~= u26.Status.Started then
        return
    end
    self._status = u26.Status.Rejected
    local v1, v2 = pack(...)
    self._valuesLength = v1
    self._values = v2
    if next(self._queuedReject) == nil then
        local u39 = tostring((...))
        coroutine.wrap(function() -- Line: 1823 -- upvalues: u26 (upval), self (val), u39 (val)
            local _values, _valuesLength, spawn, v1
            u26._timeEvent:Wait()
            if not self._unhandledRejection then
                return
            end
            local v2 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u39, self._source)
            for i, v in ipairs(u26._unhandledRejectionCallbacks) do
                spawn = task.spawn
                v1 = self
                _values = self._values
                _valuesLength = self._valuesLength
                spawn(v, v1, unpack(_values, 1, _valuesLength))
            end
            if u26.TEST then
                return
            end
            warn(v2)
        end)()
    else
        for i, v in ipairs(self._queuedReject) do
            coroutine.wrap(v)(...)
        end
    end
    self:_finalize()
end

function u26.prototype:_finalize() -- Line: 1855 -- upvalues: u26 (val)
    for i, v in ipairs(self._queuedFinally) do
        coroutine.wrap(v)(self._status)
    end
    self._queuedFinally = nil
    self._queuedReject = nil
    self._queuedResolve = nil
    if not u26.TEST then
        self._parent = nil
        self._consumers = nil
    end
    task.defer(coroutine.close, self._thread)
end

function u26.prototype.now(a1, a2) -- Line: 1892 -- upvalues: u26 (val), u13 (ref)
    local v1 = debug.traceback(nil, 2)
    if a1._status == u26.Status.Resolved then
        return a1:_andThen(v1, function(...) -- Line: 1895
            return ...
        end)
    end
    return u26.reject(a2 == nil and u13.new({
        error = "This Promise was not resolved in time for :now()",
        kind = u13.Kind.NotResolvedInTime,
        context = ":now() was called at:\n\n" .. v1,
    }) or a2)
end

function u26.retry(a1, a2, ...) -- Line: 1937 -- upvalues: u26 (val)
    local v1
    if type(a1) == "function" then
        v1 = true
    elseif type(a1) ~= "table" then
        v1 = false
    else
        local v2 = getmetatable(a1)
        v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
    end
    assert(v1, "Parameter #1 to Promise.retry must be a function")
    assert(type(a2) == "number", "Parameter #2 to Promise.retry must be a number")
    local u35 = {}
    u35[1] = ...
    local u40 = select("#", ...)
    return (u26.resolve((a1(...)))):catch(function(...) -- Line: 1943 -- upvalues: a2 (val), u26 (upval), a1 (val), u35 (val), u40 (val)
        if a2 > 0 then
            return u26.retry(a1, a2 - 1, unpack(u35, 1, u40))
        end
        return u26.reject(...)
    end)
end

function u26.retryWithDelay(a1, a2, a3, ...) -- Line: 1965 -- upvalues: u26 (val)
    local v1
    if type(a1) == "function" then
        v1 = true
    elseif type(a1) ~= "table" then
        v1 = false
    else
        local v2 = getmetatable(a1)
        v1 = if not v2 then false else not (type((rawget(v2, "__call"))) ~= "function")
    end
    assert(v1, "Parameter #1 to Promise.retry must be a function")
    assert(type(a2) == "number", "Parameter #2 (times) to Promise.retry must be a number")
    assert(type(a3) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")
    local u48 = {}
    u48[1] = ...
    local u53 = select("#", ...)
    return (u26.resolve((a1(...)))):catch(function(...) -- Line: 1972 -- upvalues: a2 (val), u26 (upval), a3 (val), a1 (val), u48 (val), u53 (val)
        if not (a2 > 0) then
            return u26.reject(...)
        end
        u26.delay(a3):await()
        return u26.retryWithDelay(a1, a2 - 1, a3, unpack(u48, 1, u53))
    end)
end

function u26.fromEvent(a1, a2) -- Line: 2007 -- upvalues: u26 (val)
    local u5 = a2 or function() -- Line: 2008
        return true
    end
    return (u26._new(debug.traceback(nil, 2), function(a1_2, a2, a3) -- Line: 2012 -- upvalues: a1 (val), u5 (ref)
        local u3 = nil
        local u4 = false

        local function disconnect() -- Line: 2016 -- upvalues: u3 (ref)
            u3:Disconnect()
            u3 = nil
        end

        u3 = (a1:Connect(function(...) -- Line: 2025 -- upvalues: u5 (upval), a1_2 (val), u3 (ref), u4 (ref)
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
        end))
        if u4 and u3 then
            return (disconnect())
        end
        a3(disconnect)
    end))
end

function u26.onUnhandledRejection(a1) -- Line: 2060 -- upvalues: u26 (val)
    table.insert(u26._unhandledRejectionCallbacks, a1)
    return function() -- Line: 2063 -- upvalues: u26 (upval), a1 (val)
        local v1 = table.find(u26._unhandledRejectionCallbacks, a1)
        if v1 then
            table.remove(u26._unhandledRejectionCallbacks, v1)
        end
    end
end

return u26