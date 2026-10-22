-- ReplicatedStorage.Shared.Promise
-- Script path: ReplicatedStorage.Shared.Promise
-- Decompile time: 17.24 ms

-- Decompiled with Potassium's decompiler.

local u1 = {
    __mode = "k"
};
local Profiler = require(game:GetService("ReplicatedStorage").Shared.Profiler);

local function makeEnum(u2, p3) -- Line: 15
    local v4 = {};

    for _, v in ipairs(p3) do
        v4[v] = v;
    end;

    return setmetatable(v4, {
        __index = function(p5, p6) -- Line: 23, Name: __index
            -- upvalues: u2 (copy)
            error(string.format("%s is not in %s!", p6, u2), 2);
        end,

        __newindex = function() -- Line: 26, Name: __newindex
            -- upvalues: u2 (copy)
            error(string.format("Creating new members in %s is not allowed!", u2), 2);
        end
    });
end;

local u7 = {
    Kind = makeEnum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" })
};
u7.__index = u7;

function u7.new(p8, p9) -- Line: 48
    -- upvalues: u7 (ref)
    local v10 = p8 or {};
    local v11 = {
        error = tostring(v10.error) or "[This error has no error text.]",
        trace = v10.trace,
        context = v10.context,
        kind = v10.kind,
        parent = p9,
        createdTick = os.clock(),
        createdTrace = debug.traceback()
    };

    return setmetatable(v11, u7);
end;

function u7.is(p12) -- Line: 61
    if type(p12) == "table" then
        local v13 = getmetatable(p12);

        if type(v13) == "table" then
            local v14;

            if rawget(p12, "error") == nil then
                v14 = false;
            else
                local v15 = rawget(v13, "extend");
                v14 = type(v15) == "function";
            end;

            return v14;
        end;
    end;

    return false;
end;

function u7.isKind(p16, p17) -- Line: 73
    -- upvalues: u7 (ref)
    assert(p17 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil");
    local v18 = u7.is(p16) and p16.kind == p17;

    return v18;
end;

function u7.extend(p19, p20) -- Line: 79
    -- upvalues: u7 (ref)
    local v21 = p20 or {};
    v21.kind = v21.kind or p19.kind;

    return u7.new(v21, p19);
end;

function u7.getErrorChain(p22) -- Line: 87
    local v23 = { p22 };

    while v23[#v23].parent do
        table.insert(v23, v23[#v23].parent);
    end;

    return v23;
end;

function u7.__tostring(p24) -- Line: 97
    local v25 = { string.format("-- Promise.Error(%s) --", p24.kind or "?") };

    for _, v in ipairs(p24:getErrorChain()) do
        table.insert(v25, table.concat({ v.trace or v.error, v.context }, "\n"));
    end;

    return table.concat(v25, "\n");
end;

local function pack(...) -- Line: 118
    return select("#", ...), { ... };
end;

local function packResult(p26, ...) -- Line: 125
    return p26, select("#", ...), { ... };
end;

local function makeErrorHandler(u27) -- Line: 130
    -- upvalues: u7 (ref)
    assert(u27 ~= nil);

    return function(p28) -- Line: 133
        -- upvalues: u7 (ref), u27 (copy)
        if type(p28) == "table" then
            return p28;
        end;

        return u7.new({
            error = p28,
            kind = u7.Kind.ExecutionError,
            trace = debug.traceback(tostring(p28), 2),
            context = "Promise created at:\n\n" .. u27
        });
    end;
end;

local function runExecutor(u29, p30, ...) -- Line: 153
    -- upvalues: Profiler (copy), u7 (ref), packResult (copy)
    local CallbackLabel = Profiler.getCallbackLabel("Promise.Callback", p30);
    Profiler.mark(CallbackLabel);
    local table_pack = table.pack;
    assert(u29 ~= nil);
    local v32 = table_pack(xpcall(p30, function(p31) -- Line: 133
        -- upvalues: u7 (ref), u29 (copy)
        if type(p31) == "table" then
            return p31;
        end;

        return u7.new({
            error = p31,
            kind = u7.Kind.ExecutionError,
            trace = debug.traceback(tostring(p31), 2),
            context = "Promise created at:\n\n" .. u29
        });
    end, ...));

    return packResult(unpack(v32, 1, v32.n));
end;

local function createAdvancer(u33, u34, u35, u36) -- Line: 166
    -- upvalues: runExecutor (copy)
    return function(...) -- Line: 167
        -- upvalues: runExecutor (ref), u33 (copy), u34 (copy), u35 (copy), u36 (copy)
        local v37, v38, v39 = runExecutor(u33, u34, ...);

        if v37 then
            u35(unpack(v39, 1, v38));

            return;
        end;

        u36(v39[1]);
    end;
end;

local function isEmpty(p40) -- Line: 178
    return next(p40) == nil;
end;

local u41 = {
    Error = u7,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    prototype = {}
};
u41.__index = u41.prototype;

function u41._new(p42, u43, p44) -- Line: 203
    -- upvalues: u41 (copy), u1 (copy), runExecutor (copy)
    if p44 ~= nil and not u41.is(p44) then
        error("Argument #2 to Promise.new must be a promise or nil", 2);
    end;

    local u45 = {
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p42,
        _status = u41.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p44,
        _consumers = setmetatable({}, u1)
    };

    if p44 and p44._status == u41.Status.Started then
        p44._consumers[u45] = true;
    end;

    setmetatable(u45, u41);

    local function resolve(...) -- Line: 248
        -- upvalues: u45 (copy)
        u45:_resolve(...);
    end;

    local function reject(...) -- Line: 252
        -- upvalues: u45 (copy)
        u45:_reject(...);
    end;

    local function onCancel(p46) -- Line: 256
        -- upvalues: u45 (copy), u41 (ref)
        if p46 then
            if u45._status == u41.Status.Cancelled then
                p46();
            else
                u45._cancellationHook = p46;
            end;
        end;

        return u45._status == u41.Status.Cancelled;
    end;

    coroutine.wrap(function() -- Line: 268
        -- upvalues: runExecutor (ref), u45 (copy), u43 (copy), resolve (copy), reject (copy), onCancel (copy)
        local v47, _, v48 = runExecutor(u45._source, u43, resolve, reject, onCancel);

        if not v47 then
            reject(v48[1]);
        end;
    end)();

    return u45;
end;

function u41.new(p49) -- Line: 285
    -- upvalues: u41 (copy)
    return u41._new(debug.traceback(nil, 2), p49);
end;

function u41.__tostring(p50) -- Line: 289
    return string.format("Promise(%s)", p50:getStatus());
end;

function u41.defer(u51) -- Line: 296
    -- upvalues: u41 (copy), runExecutor (copy)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u41._new(debug_traceback_ret, function(u52, u53, u54) -- Line: 299
        -- upvalues: u41 (ref), runExecutor (ref), debug_traceback_ret (copy), u51 (copy)
        local u55 = nil;
        u55 = u41._timeEvent:Connect(function() -- Line: 301
            -- upvalues: u55 (ref), runExecutor (ref), debug_traceback_ret (ref), u51 (ref), u52 (copy), u53 (copy), u54 (copy)
            u55:Disconnect();
            local v56, _, v57 = runExecutor(debug_traceback_ret, u51, u52, u53, u54);

            if not v56 then
                u53(v57[1]);
            end;
        end);
    end);
end;

u41.async = u41.defer;

function u41.resolve(...) -- Line: 320
    -- upvalues: pack (copy), u41 (copy)
    local u58, u59 = pack(...);

    return u41._new(debug.traceback(nil, 2), function(p60) -- Line: 322
        -- upvalues: u59 (copy), u58 (copy)
        p60(unpack(u59, 1, u58));
    end);
end;

function u41.reject(...) -- Line: 330
    -- upvalues: pack (copy), u41 (copy)
    local u61, u62 = pack(...);

    return u41._new(debug.traceback(nil, 2), function(p63, p64) -- Line: 332
        -- upvalues: u62 (copy), u61 (copy)
        p64(unpack(u62, 1, u61));
    end);
end;

function u41._try(p65, u66, ...) -- Line: 341
    -- upvalues: pack (copy), u41 (copy)
    local u67, u68 = pack(...);

    return u41._new(p65, function(p69) -- Line: 344
        -- upvalues: u66 (copy), u68 (copy), u67 (copy)
        p69(u66(unpack(u68, 1, u67)));
    end);
end;

function u41.try(...) -- Line: 352
    -- upvalues: u41 (copy)
    return u41._try(debug.traceback(nil, 2), ...);
end;

function u41._all(p70, u71, u72) -- Line: 361
    -- upvalues: u41 (copy)
    if type(u71) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
    end;

    for i, v in pairs(u71) do
        if not u41.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(i))), 3);
        end;
    end;

    if #u71 == 0 or u72 == 0 then
        return u41.resolve({});
    end;

    return u41._new(p70, function(u73, u74, p75) -- Line: 379
        -- upvalues: u72 (copy), u71 (copy)
        local u76 = {};
        local u77 = {};
        local u78 = 0;
        local u79 = 0;
        local u80 = false;

        local function resolveOne(p81, ...) -- Line: 397
            -- upvalues: u80 (ref), u78 (ref), u72 (ref), u76 (copy), u71 (ref), u73 (copy), u77 (copy)
            if u80 then
                return;
            end;

            u78 = u78 + 1;

            if u72 == nil then
                u76[p81] = ...;
            else
                u76[u78] = ...;
            end;

            if u78 >= (u72 or #u71) then
                u80 = true;
                u73(u76);

                for _, v in ipairs(u77) do
                    v:cancel();
                end;
            end;
        end;

        p75(function() -- Line: 390, Name: cancel
            -- upvalues: u77 (copy)
            for _, v in ipairs(u77) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u71) do
            u77[i] = v:andThen(function(...) -- Line: 423
                -- upvalues: resolveOne (copy), i (copy)
                resolveOne(i, ...);
            end, function(...) -- Line: 426
                -- upvalues: u79 (ref), u72 (ref), u71 (ref), u77 (copy), u80 (ref), u74 (copy)
                u79 = u79 + 1;

                if u72 == nil or #u71 - u79 < u72 then
                    for _, v2 in ipairs(u77) do
                        v2:cancel();
                    end;

                    u80 = true;
                    u74(...);
                end;
            end);
        end;

        if u80 then
            for _, v in ipairs(u77) do
                v:cancel();
            end;
        end;
    end);
end;

function u41.all(p82) -- Line: 445
    -- upvalues: u41 (copy)
    return u41._all(debug.traceback(nil, 2), p82);
end;

function u41.some(p83, p84) -- Line: 449
    -- upvalues: u41 (copy)
    local v85 = type(p84) == "number";
    assert(v85, "Bad argument #2 to Promise.some: must be a number");

    return u41._all(debug.traceback(nil, 2), p83, p84);
end;

function u41.any(p86) -- Line: 455
    -- upvalues: u41 (copy)
    return u41._all(debug.traceback(nil, 2), p86, 1):andThen(function(p87) -- Line: 456
        return p87[1];
    end);
end;

function u41.allSettled(u88) -- Line: 461
    -- upvalues: u41 (copy)
    if type(u88) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
    end;

    for i, v in pairs(u88) do
        if not u41.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(i))), 2);
        end;
    end;

    if #u88 == 0 then
        return u41.resolve({});
    end;

    return u41._new(debug.traceback(nil, 2), function(u89, p90, p91) -- Line: 479
        -- upvalues: u88 (copy)
        local u92 = {};
        local u93 = {};
        local u94 = 0;

        local function u96(p95, ...) -- Line: 489
            -- upvalues: u94 (ref), u92 (copy), u88 (ref), u89 (copy)
            u94 = u94 + 1;
            u92[p95] = ...;

            if u94 >= #u88 then
                u89(u92);
            end;
        end;

        p91(function() -- Line: 499
            -- upvalues: u93 (copy)
            for _, v in ipairs(u93) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u88) do
            u93[i] = v:finally(function(...) -- Line: 509
                -- upvalues: u96 (copy), i (copy)
                u96(i, ...);
            end);
        end;
    end);
end;

function u41.race(u97) -- Line: 521
    -- upvalues: u41 (copy)
    local v98 = type(u97) == "table";
    assert(v98, string.format("Please pass a list of promises to %s", "Promise.race"));

    for i, v in pairs(u97) do
        local v99 = u41.is(v);
        local string_format = string.format;
        local v100 = tostring(i);
        assert(v99, string_format("Non-promise value passed into %s at index %s", "Promise.race", v100));
    end;

    return u41._new(debug.traceback(nil, 2), function(u101, u102, p103) -- Line: 528
        -- upvalues: u97 (copy)
        local u104 = {};
        local u105 = false;

        local function cancel() -- Line: 532
            -- upvalues: u104 (copy)
            for _, v in ipairs(u104) do
                v:cancel();
            end;
        end;

        local function finalize(u106) -- Line: 538
            -- upvalues: u104 (copy), u105 (ref)
            return function(...) -- Line: 539
                -- upvalues: u104 (ref), u105 (ref), u106 (copy)
                for _, v in ipairs(u104) do
                    v:cancel();
                end;

                u105 = true;

                return u106(...);
            end;
        end;

        if p103(function(...) -- Line: 539
            -- upvalues: u104 (copy), u105 (ref), u102 (copy)
            for _, v in ipairs(u104) do
                v:cancel();
            end;

            u105 = true;

            return u102(...);
        end) then
            return;
        end;

        for i, v in ipairs(u97) do
            u104[i] = v:andThen(function(...) -- Line: 539
                -- upvalues: u104 (copy), u105 (ref), u101 (copy)
                for _, v2 in ipairs(u104) do
                    v2:cancel();
                end;

                u105 = true;

                return u101(...);
            end, function(...) -- Line: 539
                -- upvalues: u104 (copy), u105 (ref), u102 (copy)
                for _, v2 in ipairs(u104) do
                    v2:cancel();
                end;

                u105 = true;

                return u102(...);
            end);
        end;

        if u105 then
            for _, v in ipairs(u104) do
                v:cancel();
            end;
        end;
    end);
end;

function u41.each(u107, u108) -- Line: 568
    -- upvalues: u41 (copy), u7 (ref)
    local v109 = type(u107) == "table";
    assert(v109, string.format("Please pass a list of promises to %s", "Promise.each"));
    local v110 = type(u108) == "function";
    assert(v110, string.format("Please pass a handler function to %s!", "Promise.each"));

    return u41._new(debug.traceback(nil, 2), function(p111, p112, p113) -- Line: 572
        -- upvalues: u107 (copy), u41 (ref), u7 (ref), u108 (copy)
        local v114 = {};
        local u115 = {};
        local u116 = false;

        local function _() -- Line: 578
            -- upvalues: u115 (copy)
            for _, v in ipairs(u115) do
                v:cancel();
            end;
        end;

        p113(function() -- Line: 584
            -- upvalues: u116 (ref), u115 (copy)
            u116 = true;

            for _, v in ipairs(u115) do
                v:cancel();
            end;
        end);
        local v117 = {};

        for i, v in ipairs(u107) do
            if u41.is(v) then
                if v:getStatus() == u41.Status.Cancelled then
                    for _, v2 in ipairs(u115) do
                        v2:cancel();
                    end;

                    return p112(u7.new({
                        error = "Promise is cancelled",
                        kind = u7.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
                    }));
                end;

                if v:getStatus() == u41.Status.Rejected then
                    for _, v2 in ipairs(u115) do
                        v2:cancel();
                    end;

                    return p112(select(2, v:await()));
                end;

                local v118 = v:andThen(function(...) -- Line: 617
                    return ...;
                end);
                table.insert(u115, v118);
                v117[i] = v118;
            else
                v117[i] = v;
            end;
        end;

        for i, v in ipairs(v117) do
            local v119;

            if u41.is(v) then
                local v120;
                v120, v119 = v:await();

                if not v120 then
                    for _, v2 in ipairs(u115) do
                        v2:cancel();
                    end;

                    return p112(v119);
                end;
            else
                v119 = v;
            end;

            if u116 then
                return;
            end;

            local v121 = u41.resolve(u108(v119, i));
            table.insert(u115, v121);
            local v122, v123 = v121:await();

            if not v122 then
                for _, v2 in ipairs(u115) do
                    v2:cancel();
                end;

                return p112(v123);
            end;

            v114[i] = v123;
        end;

        p111(v114);
    end);
end;

function u41.is(p124) -- Line: 664
    -- upvalues: u41 (copy)
    if type(p124) ~= "table" then
        return false;
    end;

    local v125 = getmetatable(p124);

    if v125 == u41 then
        return true;
    end;

    if v125 == nil then
        return type(p124.andThen) == "function";
    end;

    if type(v125) == "table" then
        local v126 = rawget(v125, "__index");

        if type(v126) == "table" then
            local v127 = rawget(v125, "__index");
            local v128 = rawget(v127, "andThen");

            if type(v128) == "function" then
                return true;
            end;
        end;
    end;

    return false;
end;

function u41.promisify(u129) -- Line: 692
    -- upvalues: u41 (copy)
    return function(...) -- Line: 693
        -- upvalues: u41 (ref), u129 (copy)
        return u41._try(debug.traceback(nil, 2), u129, ...);
    end;
end;

local u130 = nil;
local u131 = nil;

function u41.delay(p132) -- Line: 708
    -- upvalues: u41 (copy), u131 (ref), u130 (ref)
    local v133 = type(p132) == "number";
    assert(v133, "Bad argument #1 to Promise.delay, must be a number.");
    local u134 = (p132 < 0.016666666666666666 or p132 == (1 / 0)) and 0.016666666666666666 or p132;

    return u41._new(debug.traceback(nil, 2), function(p135, p136, p137) -- Line: 716
        -- upvalues: u41 (ref), u134 (ref), u131 (ref), u130 (ref)
        local v138 = u41._getTime();
        local v139 = v138 + u134;
        local u140 = {
            resolve = p135,
            startTime = v138,
            endTime = v139
        };

        if u131 == nil then
            u130 = u140;
            u131 = u41._timeEvent:Connect(function() -- Line: 728
                -- upvalues: u41 (ref), u130 (ref), u131 (ref)
                local v141 = u41._getTime();

                while u130 ~= nil and u130.endTime < v141 do
                    local v142 = u130;
                    u130 = v142.next;

                    if u130 == nil then
                        u131:Disconnect();
                        u131 = nil;
                    else
                        u130.previous = nil;
                    end;

                    v142.resolve(u41._getTime() - v142.startTime);
                end;
            end);
        elseif u130.endTime < v139 then
            local v143 = u130;
            local next2 = v143.next;

            while next2 ~= nil and next2.endTime < v139 do
                v143 = next2;
                next2 = next2.next;
            end;

            v143.next = u140;
            u140.previous = v143;

            if next2 ~= nil then
                u140.next = next2;
                next2.previous = u140;
            end;
        else
            u140.next = u130;
            u130.previous = u140;
            u130 = u140;
        end;

        p137(function() -- Line: 773
            -- upvalues: u140 (copy), u130 (ref), u131 (ref)
            local next2 = u140.next;

            if u130 == u140 then
                if next2 == nil then
                    u131:Disconnect();
                    u131 = nil;
                else
                    next2.previous = nil;
                end;

                u130 = next2;

                return;
            end;

            local previous = u140.previous;
            previous.next = next2;

            if next2 ~= nil then
                next2.previous = previous;
            end;
        end);
    end);
end;

function u41.prototype.timeout(p144, u145, u146) -- Line: 802
    -- upvalues: u41 (copy), u7 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u41.race({ u41.delay(u145):andThen(function() -- Line: 806
            -- upvalues: u41 (ref), u146 (copy), u7 (ref), u145 (copy), debug_traceback_ret (copy)
            return u41.reject(u146 == nil and u7.new({
                error = "Timed out",
                kind = u7.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", u145, debug_traceback_ret)
            }) or u146);
        end), p144 });
end;

function u41.prototype.getStatus(p147) -- Line: 821
    return p147._status;
end;

function u41.prototype._andThen(u148, u149, u150, u151) -- Line: 830
    -- upvalues: u41 (copy), runExecutor (copy), u7 (ref)
    u148._unhandledRejection = false;

    return u41._new(u149, function(u152, u153) -- Line: 834
        -- upvalues: u150 (copy), u149 (copy), runExecutor (ref), u151 (copy), u148 (copy), u41 (ref), u7 (ref)
        local v154;

        if u150 then
            local u155 = u149;
            local u156 = u150;

            v154 = function(...) -- Line: 167
                -- upvalues: runExecutor (ref), u155 (copy), u156 (copy), u152 (copy), u153 (copy)
                local v157, v158, v159 = runExecutor(u155, u156, ...);

                if v157 then
                    u152(unpack(v159, 1, v158));

                    return;
                end;

                u153(v159[1]);
            end;
        else
            v154 = u152;
        end;

        local v160;

        if u151 then
            local u161 = u149;
            local u162 = u151;

            v160 = function(...) -- Line: 167
                -- upvalues: runExecutor (ref), u161 (copy), u162 (copy), u152 (copy), u153 (copy)
                local v163, v164, v165 = runExecutor(u161, u162, ...);

                if v163 then
                    u152(unpack(v165, 1, v164));

                    return;
                end;

                u153(v165[1]);
            end;
        else
            v160 = u153;
        end;

        if u148._status == u41.Status.Started then
            table.insert(u148._queuedResolve, v154);
            table.insert(u148._queuedReject, v160);

            return;
        end;

        if u148._status == u41.Status.Resolved then
            v154(unpack(u148._values, 1, u148._valuesLength));

            return;
        end;

        if u148._status == u41.Status.Rejected then
            v160(unpack(u148._values, 1, u148._valuesLength));

            return;
        end;

        if u148._status == u41.Status.Cancelled then
            u153(u7.new({
                error = "Promise is cancelled",
                kind = u7.Kind.AlreadyCancelled,
                context = "Promise created at\n\n" .. u149
            }));
        end;
    end, u148);
end;

function u41.prototype.andThen(p166, p167, p168) -- Line: 880
    local v169 = p167 == nil and true or type(p167) == "function";
    assert(v169, string.format("Please pass a handler function to %s!", "Promise:andThen"));
    local v170 = p168 == nil and true or type(p168) == "function";
    assert(v170, string.format("Please pass a handler function to %s!", "Promise:andThen"));

    return p166:_andThen(debug.traceback(nil, 2), p167, p168);
end;

function u41.prototype.catch(p171, p172) -- Line: 896
    local v173 = p172 == nil and true or type(p172) == "function";
    assert(v173, string.format("Please pass a handler function to %s!", "Promise:catch"));

    return p171:_andThen(debug.traceback(nil, 2), nil, p172);
end;

function u41.prototype.tap(p174, u175) -- Line: 908
    -- upvalues: u41 (copy), pack (copy)
    local v176 = type(u175) == "function";
    assert(v176, string.format("Please pass a handler function to %s!", "Promise:tap"));

    return p174:_andThen(debug.traceback(nil, 2), function(...) -- Line: 910
        -- upvalues: u175 (copy), u41 (ref), pack (ref)
        local v177 = u175(...);

        if not u41.is(v177) then
            return ...;
        end;

        local u178, u179 = pack(...);

        return v177:andThen(function() -- Line: 915
            -- upvalues: u179 (copy), u178 (copy)
            return unpack(u179, 1, u178);
        end);
    end);
end;

function u41.prototype.andThenCall(p180, u181, ...) -- Line: 927
    -- upvalues: pack (copy)
    local v182 = type(u181) == "function";
    assert(v182, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
    local u183, u184 = pack(...);

    return p180:_andThen(debug.traceback(nil, 2), function() -- Line: 930
        -- upvalues: u181 (copy), u184 (copy), u183 (copy)
        return u181(unpack(u184, 1, u183));
    end);
end;

function u41.prototype.andThenReturn(p185, ...) -- Line: 938
    -- upvalues: pack (copy)
    local u186, u187 = pack(...);

    return p185:_andThen(debug.traceback(nil, 2), function() -- Line: 940
        -- upvalues: u187 (copy), u186 (copy)
        return unpack(u187, 1, u186);
    end);
end;

function u41.prototype.cancel(p188) -- Line: 949
    -- upvalues: u41 (copy)
    if p188._status ~= u41.Status.Started then
        return;
    end;

    p188._status = u41.Status.Cancelled;

    if p188._cancellationHook then
        p188._cancellationHook();
    end;

    if p188._parent then
        p188._parent:_consumerCancelled(p188);
    end;

    for i in pairs(p188._consumers) do
        i:cancel();
    end;

    p188:_finalize();
end;

function u41.prototype._consumerCancelled(p189, p190) -- Line: 975
    -- upvalues: u41 (copy)
    if p189._status ~= u41.Status.Started then
        return;
    end;

    p189._consumers[p190] = nil;

    if next(p189._consumers) == nil then
        p189:cancel();
    end;
end;

function u41.prototype._finally(u191, u192, u193, u194) -- Line: 991
    -- upvalues: u41 (copy), runExecutor (copy)
    if not u194 then
        u191._unhandledRejection = false;
    end;

    return u41._new(u192, function(u195, u196) -- Line: 997
        -- upvalues: u193 (copy), u192 (copy), runExecutor (ref), u194 (copy), u191 (copy), u41 (ref)
        local u197;

        if u193 then
            local u198 = u192;
            local u199 = u193;

            u197 = function(...) -- Line: 167
                -- upvalues: runExecutor (ref), u198 (copy), u199 (copy), u195 (copy), u196 (copy)
                local v200, v201, v202 = runExecutor(u198, u199, ...);

                if v200 then
                    u195(unpack(v202, 1, v201));

                    return;
                end;

                u196(v202[1]);
            end;
        else
            u197 = u195;
        end;

        local v203 = u194 and function(...) -- Line: 1010
            -- upvalues: u191 (ref), u41 (ref), u195 (copy), u197 (copy)
            if u191._status == u41.Status.Rejected then
                return u195(u191);
            end;

            return u197(...);
        end or u197;

        if u191._status == u41.Status.Started then
            table.insert(u191._queuedFinally, v203);

            return;
        end;

        v203(u191._status);
    end, u191);
end;

function u41.prototype.finally(p204, p205) -- Line: 1029
    local v206 = p205 == nil and true or type(p205) == "function";
    assert(v206, string.format("Please pass a handler function to %s!", "Promise:finally"));

    return p204:_finally(debug.traceback(nil, 2), p205);
end;

function u41.prototype.finallyCall(p207, u208, ...) -- Line: 1040
    -- upvalues: pack (copy)
    local v209 = type(u208) == "function";
    assert(v209, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
    local u210, u211 = pack(...);

    return p207:_finally(debug.traceback(nil, 2), function() -- Line: 1043
        -- upvalues: u208 (copy), u211 (copy), u210 (copy)
        return u208(unpack(u211, 1, u210));
    end);
end;

function u41.prototype.finallyReturn(p212, ...) -- Line: 1051
    -- upvalues: pack (copy)
    local u213, u214 = pack(...);

    return p212:_finally(debug.traceback(nil, 2), function() -- Line: 1053
        -- upvalues: u214 (copy), u213 (copy)
        return unpack(u214, 1, u213);
    end);
end;

function u41.prototype.done(p215, p216) -- Line: 1061
    local v217 = p216 == nil and true or type(p216) == "function";
    assert(v217, string.format("Please pass a handler function to %s!", "Promise:done"));

    return p215:_finally(debug.traceback(nil, 2), p216, true);
end;

function u41.prototype.doneCall(p218, u219, ...) -- Line: 1072
    -- upvalues: pack (copy)
    local v220 = type(u219) == "function";
    assert(v220, string.format("Please pass a handler function to %s!", "Promise:doneCall"));
    local u221, u222 = pack(...);

    return p218:_finally(debug.traceback(nil, 2), function() -- Line: 1075
        -- upvalues: u219 (copy), u222 (copy), u221 (copy)
        return u219(unpack(u222, 1, u221));
    end, true);
end;

function u41.prototype.doneReturn(p223, ...) -- Line: 1083
    -- upvalues: pack (copy)
    local u224, u225 = pack(...);

    return p223:_finally(debug.traceback(nil, 2), function() -- Line: 1085
        -- upvalues: u225 (copy), u224 (copy)
        return unpack(u225, 1, u224);
    end, true);
end;

function u41.prototype.awaitStatus(p226) -- Line: 1095
    -- upvalues: u41 (copy)
    p226._unhandledRejection = false;

    if p226._status == u41.Status.Started then
        local BindableEvent = Instance.new("BindableEvent");
        p226:finally(function() -- Line: 1101
            -- upvalues: BindableEvent (copy)
            BindableEvent:Fire();
        end);
        BindableEvent.Event:Wait();
        BindableEvent:Destroy();
    end;

    if p226._status == u41.Status.Resolved then
        return p226._status, unpack(p226._values, 1, p226._valuesLength);
    end;

    if p226._status == u41.Status.Rejected then
        return p226._status, unpack(p226._values, 1, p226._valuesLength);
    end;

    return p226._status;
end;

local function awaitHelper(p227, ...) -- Line: 1118
    -- upvalues: u41 (copy)
    return p227 == u41.Status.Resolved, ...;
end;

function u41.prototype.await(p228) -- Line: 1125
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p228:awaitStatus());
end;

local function expectHelper(p229, ...) -- Line: 1129
    -- upvalues: u41 (copy)
    if p229 ~= u41.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3);
    end;

    return ...;
end;

function u41.prototype.expect(p230) -- Line: 1141
    -- upvalues: expectHelper (copy)
    return expectHelper(p230:awaitStatus());
end;

u41.prototype.awaitValue = u41.prototype.expect;

function u41.prototype._unwrap(p231) -- Line: 1155
    -- upvalues: u41 (copy)
    if p231._status == u41.Status.Started then
        error("Promise has not resolved or rejected.", 2);
    end;

    return p231._status == u41.Status.Resolved, unpack(p231._values, 1, p231._valuesLength);
end;

function u41.prototype._resolve(u232, ...) -- Line: 1165
    -- upvalues: u41 (copy), u7 (ref), pack (copy)
    if u232._status ~= u41.Status.Started then
        if u41.is((...)) then
            (...):_consumerCancelled(u232);
        end;

        return;
    end;

    if u41.is((...)) then
        if select("#", ...) > 1 then
            local string_format_ret = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", u232._source);
            warn(string_format_ret);
        end;

        local u233 = ...;
        local v235 = u233:andThen(function(...) -- Line: 1188
            -- upvalues: u232 (copy)
            u232:_resolve(...);
        end, function(...) -- Line: 1191
            -- upvalues: u233 (copy), u7 (ref), u232 (copy)
            local v234 = u233._values[1];

            if u233._error then
                v234 = u7.new({
                    context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    error = u233._error,
                    kind = u7.Kind.ExecutionError
                });
            end;

            if u7.isKind(v234, u7.Kind.ExecutionError) then
                return u232:_reject(v234:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", u232._source)
                }));
            end;

            u232:_reject(...);
        end);

        if v235._status == u41.Status.Cancelled then
            u232:cancel();

            return;
        end;

        if v235._status == u41.Status.Started then
            u232._parent = v235;
            v235._consumers[u232] = true;
        end;

        return;
    end;

    u232._status = u41.Status.Resolved;
    local v236, v237 = pack(...);
    u232._valuesLength = v236;
    u232._values = v237;

    for _, v in ipairs(u232._queuedResolve) do
        coroutine.wrap(v)(...);
    end;

    u232:_finalize();
end;

function u41.prototype._reject(u238, ...) -- Line: 1240
    -- upvalues: u41 (copy), pack (copy)
    if u238._status ~= u41.Status.Started then
        return;
    end;

    u238._status = u41.Status.Rejected;
    local v239, v240 = pack(...);
    u238._valuesLength = v239;
    u238._values = v240;

    if next(u238._queuedReject) == nil then
        local u241 = tostring((...));
        coroutine.wrap(function() -- Line: 1262
            -- upvalues: u41 (ref), u238 (copy), u241 (copy)
            u41._timeEvent:Wait();

            if not u238._unhandledRejection then
                return;
            end;

            local string_format_ret = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u241, u238._source);

            if u41.TEST then
                return;
            end;

            warn(string_format_ret);
        end)();
    else
        for _, v in ipairs(u238._queuedReject) do
            coroutine.wrap(v)(...);
        end;
    end;

    u238:_finalize();
end;

function u41.prototype._finalize(p242) -- Line: 1294
    -- upvalues: u41 (copy)
    for _, v in ipairs(p242._queuedFinally) do
        coroutine.wrap(v)(p242._status);
    end;

    p242._queuedFinally = nil;
    p242._queuedReject = nil;
    p242._queuedResolve = nil;

    if not u41.TEST then
        p242._parent = nil;
        p242._consumers = nil;
    end;
end;

function u41.prototype.now(p243, p244) -- Line: 1317
    -- upvalues: u41 (copy), u7 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    if p243:getStatus() == u41.Status.Resolved then
        return p243:_andThen(debug_traceback_ret, function(...) -- Line: 1320
            return ...;
        end);
    end;

    local reject = u41.reject;

    if p244 == nil then
        p244 = u7.new({
            error = "This Promise was not resolved in time for :now()",
            kind = u7.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. debug_traceback_ret
        }) or p244;
    end;

    return reject(p244);
end;

function u41.retry(u245, u246, ...) -- Line: 1335
    -- upvalues: u41 (copy)
    local v247 = type(u245) == "function";
    assert(v247, "Parameter #1 to Promise.retry must be a function");
    local v248 = type(u246) == "number";
    assert(v248, "Parameter #2 to Promise.retry must be a number");
    local u249 = { ... };
    local u250 = select("#", ...);

    return u41.resolve(u245(...)):catch(function(...) -- Line: 1341
        -- upvalues: u246 (copy), u41 (ref), u245 (copy), u249 (copy), u250 (copy)
        if u246 > 0 then
            return u41.retry(u245, u246 - 1, unpack(u249, 1, u250));
        end;

        return u41.reject(...);
    end);
end;

function u41.fromEvent(u251, p252) -- Line: 1354
    -- upvalues: u41 (copy)
    local u253 = p252 or function() -- Line: 1355
        return true;
    end;

    return u41._new(debug.traceback(nil, 2), function(u254, p255, p256) -- Line: 1359
        -- upvalues: u251 (copy), u253 (ref)
        local u257 = nil;
        local u258 = false;

        local function disconnect() -- Line: 1363
            -- upvalues: u257 (ref)
            u257:Disconnect();
            u257 = nil;
        end;

        u257 = u251:Connect(function(...) -- Line: 1372
            -- upvalues: u253 (ref), u254 (copy), u257 (ref), u258 (ref)
            local v259 = u253(...);

            if v259 ~= true then
                if type(v259) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean");
                end;

                return;
            end;

            u254(...);

            if not u257 then
                u258 = true;

                return;
            end;

            u257:Disconnect();
            u257 = nil;
        end);

        if u258 and u257 then
            return disconnect();
        end;

        p256(function() -- Line: 1392
            -- upvalues: u257 (ref)
            u257:Disconnect();
            u257 = nil;
        end);
    end);
end;

return u41;