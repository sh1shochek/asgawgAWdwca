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
    local v31 = xpcall;
    assert(u29 ~= nil);
    local v33 = table_pack(v31(p30, function(p32) -- Line: 133
        -- upvalues: u7 (ref), u29 (copy)
        if type(p32) == "table" then
            return p32;
        end;

        return u7.new({
            error = p32,
            kind = u7.Kind.ExecutionError,
            trace = debug.traceback(tostring(p32), 2),
            context = "Promise created at:\n\n" .. u29
        });
    end, ...));

    return packResult(unpack(v33, 1, v33.n));
end;

local function createAdvancer(u34, u35, u36, u37) -- Line: 166
    -- upvalues: runExecutor (copy)
    return function(...) -- Line: 167
        -- upvalues: runExecutor (ref), u34 (copy), u35 (copy), u36 (copy), u37 (copy)
        local v38, v39, v40 = runExecutor(u34, u35, ...);

        if v38 then
            u36(unpack(v40, 1, v39));

            return;
        end;

        u37(v40[1]);
    end;
end;

local function isEmpty(p41) -- Line: 178
    return next(p41) == nil;
end;

local u42 = {
    Error = u7,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    prototype = {}
};
u42.__index = u42.prototype;

function u42._new(p43, u44, p45) -- Line: 203
    -- upvalues: u42 (copy), u1 (copy), runExecutor (copy)
    if p45 ~= nil and not u42.is(p45) then
        error("Argument #2 to Promise.new must be a promise or nil", 2);
    end;

    local u46 = {
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p43,
        _status = u42.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p45,
        _consumers = setmetatable({}, u1)
    };

    if p45 and p45._status == u42.Status.Started then
        p45._consumers[u46] = true;
    end;

    setmetatable(u46, u42);

    local function resolve(...) -- Line: 248
        -- upvalues: u46 (copy)
        u46:_resolve(...);
    end;

    local function reject(...) -- Line: 252
        -- upvalues: u46 (copy)
        u46:_reject(...);
    end;

    local function onCancel(p47) -- Line: 256
        -- upvalues: u46 (copy), u42 (ref)
        if p47 then
            if u46._status == u42.Status.Cancelled then
                p47();
            else
                u46._cancellationHook = p47;
            end;
        end;

        return u46._status == u42.Status.Cancelled;
    end;

    coroutine.wrap(function() -- Line: 268
        -- upvalues: runExecutor (ref), u46 (copy), u44 (copy), resolve (copy), reject (copy), onCancel (copy)
        local v48, _, v49 = runExecutor(u46._source, u44, resolve, reject, onCancel);

        if not v48 then
            reject(v49[1]);
        end;
    end)();

    return u46;
end;

function u42.new(p50) -- Line: 285
    -- upvalues: u42 (copy)
    return u42._new(debug.traceback(nil, 2), p50);
end;

function u42.__tostring(p51) -- Line: 289
    return string.format("Promise(%s)", p51:getStatus());
end;

function u42.defer(u52) -- Line: 296
    -- upvalues: u42 (copy), runExecutor (copy)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u42._new(debug_traceback_ret, function(u53, u54, u55) -- Line: 299
        -- upvalues: u42 (ref), runExecutor (ref), debug_traceback_ret (copy), u52 (copy)
        local u56 = nil;
        u56 = u42._timeEvent:Connect(function() -- Line: 301
            -- upvalues: u56 (ref), runExecutor (ref), debug_traceback_ret (ref), u52 (ref), u53 (copy), u54 (copy), u55 (copy)
            u56:Disconnect();
            local v57, _, v58 = runExecutor(debug_traceback_ret, u52, u53, u54, u55);

            if not v57 then
                u54(v58[1]);
            end;
        end);
    end);
end;

u42.async = u42.defer;

function u42.resolve(...) -- Line: 320
    -- upvalues: pack (copy), u42 (copy)
    local u59, u60 = pack(...);

    return u42._new(debug.traceback(nil, 2), function(p61) -- Line: 322
        -- upvalues: u60 (copy), u59 (copy)
        p61(unpack(u60, 1, u59));
    end);
end;

function u42.reject(...) -- Line: 330
    -- upvalues: pack (copy), u42 (copy)
    local u62, u63 = pack(...);

    return u42._new(debug.traceback(nil, 2), function(p64, p65) -- Line: 332
        -- upvalues: u63 (copy), u62 (copy)
        p65(unpack(u63, 1, u62));
    end);
end;

function u42._try(p66, u67, ...) -- Line: 341
    -- upvalues: pack (copy), u42 (copy)
    local u68, u69 = pack(...);

    return u42._new(p66, function(p70) -- Line: 344
        -- upvalues: u67 (copy), u69 (copy), u68 (copy)
        p70(u67(unpack(u69, 1, u68)));
    end);
end;

function u42.try(...) -- Line: 352
    -- upvalues: u42 (copy)
    return u42._try(debug.traceback(nil, 2), ...);
end;

function u42._all(p71, u72, u73) -- Line: 361
    -- upvalues: u42 (copy)
    if type(u72) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
    end;

    for i, v in pairs(u72) do
        if not u42.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(i))), 3);
        end;
    end;

    if #u72 == 0 or u73 == 0 then
        return u42.resolve({});
    end;

    return u42._new(p71, function(u74, u75, p76) -- Line: 379
        -- upvalues: u73 (copy), u72 (copy)
        local u77 = {};
        local u78 = {};
        local u79 = 0;
        local u80 = 0;
        local u81 = false;

        local function resolveOne(p82, ...) -- Line: 397
            -- upvalues: u81 (ref), u79 (ref), u73 (ref), u77 (copy), u72 (ref), u74 (copy), u78 (copy)
            if u81 then
                return;
            end;

            u79 = u79 + 1;

            if u73 == nil then
                u77[p82] = ...;
            else
                u77[u79] = ...;
            end;

            if u79 >= (u73 or #u72) then
                u81 = true;
                u74(u77);

                for _, v in ipairs(u78) do
                    v:cancel();
                end;
            end;
        end;

        p76(function() -- Line: 390, Name: cancel
            -- upvalues: u78 (copy)
            for _, v in ipairs(u78) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u72) do
            u78[i] = v:andThen(function(...) -- Line: 423
                -- upvalues: resolveOne (copy), i (copy)
                resolveOne(i, ...);
            end, function(...) -- Line: 426
                -- upvalues: u80 (ref), u73 (ref), u72 (ref), u78 (copy), u81 (ref), u75 (copy)
                u80 = u80 + 1;

                if u73 == nil or #u72 - u80 < u73 then
                    for _, v2 in ipairs(u78) do
                        v2:cancel();
                    end;

                    u81 = true;
                    u75(...);
                end;
            end);
        end;

        if u81 then
            for _, v in ipairs(u78) do
                v:cancel();
            end;
        end;
    end);
end;

function u42.all(p83) -- Line: 445
    -- upvalues: u42 (copy)
    return u42._all(debug.traceback(nil, 2), p83);
end;

function u42.some(p84, p85) -- Line: 449
    -- upvalues: u42 (copy)
    local v86 = type(p85) == "number";
    assert(v86, "Bad argument #2 to Promise.some: must be a number");

    return u42._all(debug.traceback(nil, 2), p84, p85);
end;

function u42.any(p87) -- Line: 455
    -- upvalues: u42 (copy)
    return u42._all(debug.traceback(nil, 2), p87, 1):andThen(function(p88) -- Line: 456
        return p88[1];
    end);
end;

function u42.allSettled(u89) -- Line: 461
    -- upvalues: u42 (copy)
    if type(u89) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
    end;

    for i, v in pairs(u89) do
        if not u42.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(i))), 2);
        end;
    end;

    if #u89 == 0 then
        return u42.resolve({});
    end;

    return u42._new(debug.traceback(nil, 2), function(u90, p91, p92) -- Line: 479
        -- upvalues: u89 (copy)
        local u93 = {};
        local u94 = {};
        local u95 = 0;

        local function u97(p96, ...) -- Line: 489
            -- upvalues: u95 (ref), u93 (copy), u89 (ref), u90 (copy)
            u95 = u95 + 1;
            u93[p96] = ...;

            if u95 >= #u89 then
                u90(u93);
            end;
        end;

        p92(function() -- Line: 499
            -- upvalues: u94 (copy)
            for _, v in ipairs(u94) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u89) do
            u94[i] = v:finally(function(...) -- Line: 509
                -- upvalues: u97 (copy), i (copy)
                u97(i, ...);
            end);
        end;
    end);
end;

function u42.race(u98) -- Line: 521
    -- upvalues: u42 (copy)
    local v99 = type(u98) == "table";
    assert(v99, string.format("Please pass a list of promises to %s", "Promise.race"));

    for i, v in pairs(u98) do
        local v100 = u42.is(v);
        local string_format = string.format;
        local v101 = tostring(i);
        assert(v100, string_format("Non-promise value passed into %s at index %s", "Promise.race", v101));
    end;

    return u42._new(debug.traceback(nil, 2), function(u102, u103, p104) -- Line: 528
        -- upvalues: u98 (copy)
        local u105 = {};
        local u106 = false;

        local function cancel() -- Line: 532
            -- upvalues: u105 (copy)
            for _, v in ipairs(u105) do
                v:cancel();
            end;
        end;

        local function finalize(u107) -- Line: 538
            -- upvalues: u105 (copy), u106 (ref)
            return function(...) -- Line: 539
                -- upvalues: u105 (ref), u106 (ref), u107 (copy)
                for _, v in ipairs(u105) do
                    v:cancel();
                end;

                u106 = true;

                return u107(...);
            end;
        end;

        if p104(function(...) -- Line: 539
            -- upvalues: u105 (copy), u106 (ref), u103 (copy)
            for _, v in ipairs(u105) do
                v:cancel();
            end;

            u106 = true;

            return u103(...);
        end) then
            return;
        end;

        for i, v in ipairs(u98) do
            u105[i] = v:andThen(function(...) -- Line: 539
                -- upvalues: u105 (copy), u106 (ref), u102 (copy)
                for _, v2 in ipairs(u105) do
                    v2:cancel();
                end;

                u106 = true;

                return u102(...);
            end, function(...) -- Line: 539
                -- upvalues: u105 (copy), u106 (ref), u103 (copy)
                for _, v2 in ipairs(u105) do
                    v2:cancel();
                end;

                u106 = true;

                return u103(...);
            end);
        end;

        if u106 then
            for _, v in ipairs(u105) do
                v:cancel();
            end;
        end;
    end);
end;

function u42.each(u108, u109) -- Line: 568
    -- upvalues: u42 (copy), u7 (ref)
    local v110 = type(u108) == "table";
    assert(v110, string.format("Please pass a list of promises to %s", "Promise.each"));
    local v111 = type(u109) == "function";
    assert(v111, string.format("Please pass a handler function to %s!", "Promise.each"));

    return u42._new(debug.traceback(nil, 2), function(p112, p113, p114) -- Line: 572
        -- upvalues: u108 (copy), u42 (ref), u7 (ref), u109 (copy)
        local v115 = {};
        local u116 = {};
        local u117 = false;

        local function _() -- Line: 578
            -- upvalues: u116 (copy)
            for _, v in ipairs(u116) do
                v:cancel();
            end;
        end;

        p114(function() -- Line: 584
            -- upvalues: u117 (ref), u116 (copy)
            u117 = true;

            for _, v in ipairs(u116) do
                v:cancel();
            end;
        end);
        local v118 = {};

        for i, v in ipairs(u108) do
            if u42.is(v) then
                if v:getStatus() == u42.Status.Cancelled then
                    for _, v2 in ipairs(u116) do
                        v2:cancel();
                    end;

                    return p113(u7.new({
                        error = "Promise is cancelled",
                        kind = u7.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
                    }));
                end;

                if v:getStatus() == u42.Status.Rejected then
                    for _, v2 in ipairs(u116) do
                        v2:cancel();
                    end;

                    return p113(select(2, v:await()));
                end;

                local v119 = v:andThen(function(...) -- Line: 617
                    return ...;
                end);
                table.insert(u116, v119);
                v118[i] = v119;
            else
                v118[i] = v;
            end;
        end;

        for i, v in ipairs(v118) do
            local v120;

            if u42.is(v) then
                local v121;
                v121, v120 = v:await();

                if not v121 then
                    for _, v2 in ipairs(u116) do
                        v2:cancel();
                    end;

                    return p113(v120);
                end;
            else
                v120 = v;
            end;

            if u117 then
                return;
            end;

            local v122 = u42.resolve(u109(v120, i));
            table.insert(u116, v122);
            local v123, v124 = v122:await();

            if not v123 then
                for _, v2 in ipairs(u116) do
                    v2:cancel();
                end;

                return p113(v124);
            end;

            v115[i] = v124;
        end;

        p112(v115);
    end);
end;

function u42.is(p125) -- Line: 664
    -- upvalues: u42 (copy)
    if type(p125) ~= "table" then
        return false;
    end;

    local v126 = getmetatable(p125);

    if v126 == u42 then
        return true;
    end;

    if v126 == nil then
        return type(p125.andThen) == "function";
    end;

    if type(v126) == "table" then
        local v127 = rawget(v126, "__index");

        if type(v127) == "table" then
            local v128 = rawget(v126, "__index");
            local v129 = rawget(v128, "andThen");

            if type(v129) == "function" then
                return true;
            end;
        end;
    end;

    return false;
end;

function u42.promisify(u130) -- Line: 692
    -- upvalues: u42 (copy)
    return function(...) -- Line: 693
        -- upvalues: u42 (ref), u130 (copy)
        return u42._try(debug.traceback(nil, 2), u130, ...);
    end;
end;

local u131 = nil;
local u132 = nil;

function u42.delay(p133) -- Line: 708
    -- upvalues: u42 (copy), u132 (ref), u131 (ref)
    local v134 = type(p133) == "number";
    assert(v134, "Bad argument #1 to Promise.delay, must be a number.");
    local u135 = (p133 < 0.016666666666666666 or p133 == (1 / 0)) and 0.016666666666666666 or p133;

    return u42._new(debug.traceback(nil, 2), function(p136, p137, p138) -- Line: 716
        -- upvalues: u42 (ref), u135 (ref), u132 (ref), u131 (ref)
        local v139 = u42._getTime();
        local v140 = v139 + u135;
        local u141 = {
            resolve = p136,
            startTime = v139,
            endTime = v140
        };

        if u132 == nil then
            u131 = u141;
            u132 = u42._timeEvent:Connect(function() -- Line: 728
                -- upvalues: u42 (ref), u131 (ref), u132 (ref)
                local v142 = u42._getTime();

                while u131 ~= nil and u131.endTime < v142 do
                    local v143 = u131;
                    u131 = v143.next;

                    if u131 == nil then
                        u132:Disconnect();
                        u132 = nil;
                    else
                        u131.previous = nil;
                    end;

                    v143.resolve(u42._getTime() - v143.startTime);
                end;
            end);
        elseif u131.endTime < v140 then
            local v144 = u131;
            local next2 = v144.next;

            while next2 ~= nil and next2.endTime < v140 do
                v144 = next2;
                next2 = next2.next;
            end;

            v144.next = u141;
            u141.previous = v144;

            if next2 ~= nil then
                u141.next = next2;
                next2.previous = u141;
            end;
        else
            u141.next = u131;
            u131.previous = u141;
            u131 = u141;
        end;

        p138(function() -- Line: 773
            -- upvalues: u141 (copy), u131 (ref), u132 (ref)
            local next2 = u141.next;

            if u131 == u141 then
                if next2 == nil then
                    u132:Disconnect();
                    u132 = nil;
                else
                    next2.previous = nil;
                end;

                u131 = next2;

                return;
            end;

            local previous = u141.previous;
            previous.next = next2;

            if next2 ~= nil then
                next2.previous = previous;
            end;
        end);
    end);
end;

function u42.prototype.timeout(p145, u146, u147) -- Line: 802
    -- upvalues: u42 (copy), u7 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u42.race({ u42.delay(u146):andThen(function() -- Line: 806
            -- upvalues: u42 (ref), u147 (copy), u7 (ref), u146 (copy), debug_traceback_ret (copy)
            return u42.reject(u147 == nil and u7.new({
                error = "Timed out",
                kind = u7.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", u146, debug_traceback_ret)
            }) or u147);
        end), p145 });
end;

function u42.prototype.getStatus(p148) -- Line: 821
    return p148._status;
end;

function u42.prototype._andThen(u149, u150, u151, u152) -- Line: 830
    -- upvalues: u42 (copy), runExecutor (copy), u7 (ref)
    u149._unhandledRejection = false;

    return u42._new(u150, function(u153, u154) -- Line: 834
        -- upvalues: u151 (copy), u150 (copy), runExecutor (ref), u152 (copy), u149 (copy), u42 (ref), u7 (ref)
        local v155;

        if u151 then
            local u156 = u150;
            local u157 = u151;

            v155 = function(...) -- Line: 167
                -- upvalues: runExecutor (ref), u156 (copy), u157 (copy), u153 (copy), u154 (copy)
                local v158, v159, v160 = runExecutor(u156, u157, ...);

                if v158 then
                    u153(unpack(v160, 1, v159));

                    return;
                end;

                u154(v160[1]);
            end;
        else
            v155 = u153;
        end;

        local v161;

        if u152 then
            local u162 = u150;
            local u163 = u152;

            v161 = function(...) -- Line: 167
                -- upvalues: runExecutor (ref), u162 (copy), u163 (copy), u153 (copy), u154 (copy)
                local v164, v165, v166 = runExecutor(u162, u163, ...);

                if v164 then
                    u153(unpack(v166, 1, v165));

                    return;
                end;

                u154(v166[1]);
            end;
        else
            v161 = u154;
        end;

        if u149._status == u42.Status.Started then
            table.insert(u149._queuedResolve, v155);
            table.insert(u149._queuedReject, v161);

            return;
        end;

        if u149._status == u42.Status.Resolved then
            v155(unpack(u149._values, 1, u149._valuesLength));

            return;
        end;

        if u149._status == u42.Status.Rejected then
            v161(unpack(u149._values, 1, u149._valuesLength));

            return;
        end;

        if u149._status == u42.Status.Cancelled then
            u154(u7.new({
                error = "Promise is cancelled",
                kind = u7.Kind.AlreadyCancelled,
                context = "Promise created at\n\n" .. u150
            }));
        end;
    end, u149);
end;

function u42.prototype.andThen(p167, p168, p169) -- Line: 880
    local v170 = p168 == nil and true or type(p168) == "function";
    assert(v170, string.format("Please pass a handler function to %s!", "Promise:andThen"));
    local v171 = p169 == nil and true or type(p169) == "function";
    assert(v171, string.format("Please pass a handler function to %s!", "Promise:andThen"));

    return p167:_andThen(debug.traceback(nil, 2), p168, p169);
end;

function u42.prototype.catch(p172, p173) -- Line: 896
    local v174 = p173 == nil and true or type(p173) == "function";
    assert(v174, string.format("Please pass a handler function to %s!", "Promise:catch"));

    return p172:_andThen(debug.traceback(nil, 2), nil, p173);
end;

function u42.prototype.tap(p175, u176) -- Line: 908
    -- upvalues: u42 (copy), pack (copy)
    local v177 = type(u176) == "function";
    assert(v177, string.format("Please pass a handler function to %s!", "Promise:tap"));

    return p175:_andThen(debug.traceback(nil, 2), function(...) -- Line: 910
        -- upvalues: u176 (copy), u42 (ref), pack (ref)
        local v178 = u176(...);

        if not u42.is(v178) then
            return ...;
        end;

        local u179, u180 = pack(...);

        return v178:andThen(function() -- Line: 915
            -- upvalues: u180 (copy), u179 (copy)
            return unpack(u180, 1, u179);
        end);
    end);
end;

function u42.prototype.andThenCall(p181, u182, ...) -- Line: 927
    -- upvalues: pack (copy)
    local v183 = type(u182) == "function";
    assert(v183, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
    local u184, u185 = pack(...);

    return p181:_andThen(debug.traceback(nil, 2), function() -- Line: 930
        -- upvalues: u182 (copy), u185 (copy), u184 (copy)
        return u182(unpack(u185, 1, u184));
    end);
end;

function u42.prototype.andThenReturn(p186, ...) -- Line: 938
    -- upvalues: pack (copy)
    local u187, u188 = pack(...);

    return p186:_andThen(debug.traceback(nil, 2), function() -- Line: 940
        -- upvalues: u188 (copy), u187 (copy)
        return unpack(u188, 1, u187);
    end);
end;

function u42.prototype.cancel(p189) -- Line: 949
    -- upvalues: u42 (copy)
    if p189._status ~= u42.Status.Started then
        return;
    end;

    p189._status = u42.Status.Cancelled;

    if p189._cancellationHook then
        p189._cancellationHook();
    end;

    if p189._parent then
        p189._parent:_consumerCancelled(p189);
    end;

    for i in pairs(p189._consumers) do
        i:cancel();
    end;

    p189:_finalize();
end;

function u42.prototype._consumerCancelled(p190, p191) -- Line: 975
    -- upvalues: u42 (copy)
    if p190._status ~= u42.Status.Started then
        return;
    end;

    p190._consumers[p191] = nil;

    if next(p190._consumers) == nil then
        p190:cancel();
    end;
end;

function u42.prototype._finally(u192, u193, u194, u195) -- Line: 991
    -- upvalues: u42 (copy), runExecutor (copy)
    if not u195 then
        u192._unhandledRejection = false;
    end;

    return u42._new(u193, function(u196, u197) -- Line: 997
        -- upvalues: u194 (copy), u193 (copy), runExecutor (ref), u195 (copy), u192 (copy), u42 (ref)
        local u198;

        if u194 then
            local u199 = u193;
            local u200 = u194;

            u198 = function(...) -- Line: 167
                -- upvalues: runExecutor (ref), u199 (copy), u200 (copy), u196 (copy), u197 (copy)
                local v201, v202, v203 = runExecutor(u199, u200, ...);

                if v201 then
                    u196(unpack(v203, 1, v202));

                    return;
                end;

                u197(v203[1]);
            end;
        else
            u198 = u196;
        end;

        local v204 = u195 and function(...) -- Line: 1010
            -- upvalues: u192 (ref), u42 (ref), u196 (copy), u198 (copy)
            if u192._status == u42.Status.Rejected then
                return u196(u192);
            end;

            return u198(...);
        end or u198;

        if u192._status == u42.Status.Started then
            table.insert(u192._queuedFinally, v204);

            return;
        end;

        v204(u192._status);
    end, u192);
end;

function u42.prototype.finally(p205, p206) -- Line: 1029
    local v207 = p206 == nil and true or type(p206) == "function";
    assert(v207, string.format("Please pass a handler function to %s!", "Promise:finally"));

    return p205:_finally(debug.traceback(nil, 2), p206);
end;

function u42.prototype.finallyCall(p208, u209, ...) -- Line: 1040
    -- upvalues: pack (copy)
    local v210 = type(u209) == "function";
    assert(v210, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
    local u211, u212 = pack(...);

    return p208:_finally(debug.traceback(nil, 2), function() -- Line: 1043
        -- upvalues: u209 (copy), u212 (copy), u211 (copy)
        return u209(unpack(u212, 1, u211));
    end);
end;

function u42.prototype.finallyReturn(p213, ...) -- Line: 1051
    -- upvalues: pack (copy)
    local u214, u215 = pack(...);

    return p213:_finally(debug.traceback(nil, 2), function() -- Line: 1053
        -- upvalues: u215 (copy), u214 (copy)
        return unpack(u215, 1, u214);
    end);
end;

function u42.prototype.done(p216, p217) -- Line: 1061
    local v218 = p217 == nil and true or type(p217) == "function";
    assert(v218, string.format("Please pass a handler function to %s!", "Promise:done"));

    return p216:_finally(debug.traceback(nil, 2), p217, true);
end;

function u42.prototype.doneCall(p219, u220, ...) -- Line: 1072
    -- upvalues: pack (copy)
    local v221 = type(u220) == "function";
    assert(v221, string.format("Please pass a handler function to %s!", "Promise:doneCall"));
    local u222, u223 = pack(...);

    return p219:_finally(debug.traceback(nil, 2), function() -- Line: 1075
        -- upvalues: u220 (copy), u223 (copy), u222 (copy)
        return u220(unpack(u223, 1, u222));
    end, true);
end;

function u42.prototype.doneReturn(p224, ...) -- Line: 1083
    -- upvalues: pack (copy)
    local u225, u226 = pack(...);

    return p224:_finally(debug.traceback(nil, 2), function() -- Line: 1085
        -- upvalues: u226 (copy), u225 (copy)
        return unpack(u226, 1, u225);
    end, true);
end;

function u42.prototype.awaitStatus(p227) -- Line: 1095
    -- upvalues: u42 (copy)
    p227._unhandledRejection = false;

    if p227._status == u42.Status.Started then
        local BindableEvent = Instance.new("BindableEvent");
        p227:finally(function() -- Line: 1101
            -- upvalues: BindableEvent (copy)
            BindableEvent:Fire();
        end);
        BindableEvent.Event:Wait();
        BindableEvent:Destroy();
    end;

    if p227._status == u42.Status.Resolved then
        return p227._status, unpack(p227._values, 1, p227._valuesLength);
    end;

    if p227._status == u42.Status.Rejected then
        return p227._status, unpack(p227._values, 1, p227._valuesLength);
    end;

    return p227._status;
end;

local function awaitHelper(p228, ...) -- Line: 1118
    -- upvalues: u42 (copy)
    return p228 == u42.Status.Resolved, ...;
end;

function u42.prototype.await(p229) -- Line: 1125
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p229:awaitStatus());
end;

local function expectHelper(p230, ...) -- Line: 1129
    -- upvalues: u42 (copy)
    if p230 ~= u42.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3);
    end;

    return ...;
end;

function u42.prototype.expect(p231) -- Line: 1141
    -- upvalues: expectHelper (copy)
    return expectHelper(p231:awaitStatus());
end;

u42.prototype.awaitValue = u42.prototype.expect;

function u42.prototype._unwrap(p232) -- Line: 1155
    -- upvalues: u42 (copy)
    if p232._status == u42.Status.Started then
        error("Promise has not resolved or rejected.", 2);
    end;

    return p232._status == u42.Status.Resolved, unpack(p232._values, 1, p232._valuesLength);
end;

function u42.prototype._resolve(u233, ...) -- Line: 1165
    -- upvalues: u42 (copy), u7 (ref), pack (copy)
    if u233._status ~= u42.Status.Started then
        if u42.is((...)) then
            (...):_consumerCancelled(u233);
        end;

        return;
    end;

    if u42.is((...)) then
        if select("#", ...) > 1 then
            local string_format_ret = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", u233._source);
            warn(string_format_ret);
        end;

        local u234 = ...;
        local v236 = u234:andThen(function(...) -- Line: 1188
            -- upvalues: u233 (copy)
            u233:_resolve(...);
        end, function(...) -- Line: 1191
            -- upvalues: u234 (copy), u7 (ref), u233 (copy)
            local v235 = u234._values[1];

            if u234._error then
                v235 = u7.new({
                    context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    error = u234._error,
                    kind = u7.Kind.ExecutionError
                });
            end;

            if u7.isKind(v235, u7.Kind.ExecutionError) then
                return u233:_reject(v235:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", u233._source)
                }));
            end;

            u233:_reject(...);
        end);

        if v236._status == u42.Status.Cancelled then
            u233:cancel();

            return;
        end;

        if v236._status == u42.Status.Started then
            u233._parent = v236;
            v236._consumers[u233] = true;
        end;

        return;
    end;

    u233._status = u42.Status.Resolved;
    local v237, v238 = pack(...);
    u233._valuesLength = v237;
    u233._values = v238;

    for _, v in ipairs(u233._queuedResolve) do
        coroutine.wrap(v)(...);
    end;

    u233:_finalize();
end;

function u42.prototype._reject(u239, ...) -- Line: 1240
    -- upvalues: u42 (copy), pack (copy)
    if u239._status ~= u42.Status.Started then
        return;
    end;

    u239._status = u42.Status.Rejected;
    local v240, v241 = pack(...);
    u239._valuesLength = v240;
    u239._values = v241;

    if next(u239._queuedReject) == nil then
        local u242 = tostring((...));
        coroutine.wrap(function() -- Line: 1262
            -- upvalues: u42 (ref), u239 (copy), u242 (copy)
            u42._timeEvent:Wait();

            if not u239._unhandledRejection then
                return;
            end;

            local string_format_ret = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u242, u239._source);

            if u42.TEST then
                return;
            end;

            warn(string_format_ret);
        end)();
    else
        for _, v in ipairs(u239._queuedReject) do
            coroutine.wrap(v)(...);
        end;
    end;

    u239:_finalize();
end;

function u42.prototype._finalize(p243) -- Line: 1294
    -- upvalues: u42 (copy)
    for _, v in ipairs(p243._queuedFinally) do
        coroutine.wrap(v)(p243._status);
    end;

    p243._queuedFinally = nil;
    p243._queuedReject = nil;
    p243._queuedResolve = nil;

    if not u42.TEST then
        p243._parent = nil;
        p243._consumers = nil;
    end;
end;

function u42.prototype.now(p244, p245) -- Line: 1317
    -- upvalues: u42 (copy), u7 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    if p244:getStatus() == u42.Status.Resolved then
        return p244:_andThen(debug_traceback_ret, function(...) -- Line: 1320
            return ...;
        end);
    end;

    local reject = u42.reject;

    if p245 == nil then
        p245 = u7.new({
            error = "This Promise was not resolved in time for :now()",
            kind = u7.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. debug_traceback_ret
        }) or p245;
    end;

    return reject(p245);
end;

function u42.retry(u246, u247, ...) -- Line: 1335
    -- upvalues: u42 (copy)
    local v248 = type(u246) == "function";
    assert(v248, "Parameter #1 to Promise.retry must be a function");
    local v249 = type(u247) == "number";
    assert(v249, "Parameter #2 to Promise.retry must be a number");
    local u250 = { ... };
    local u251 = select("#", ...);

    return u42.resolve(u246(...)):catch(function(...) -- Line: 1341
        -- upvalues: u247 (copy), u42 (ref), u246 (copy), u250 (copy), u251 (copy)
        if u247 > 0 then
            return u42.retry(u246, u247 - 1, unpack(u250, 1, u251));
        end;

        return u42.reject(...);
    end);
end;

function u42.fromEvent(u252, p253) -- Line: 1354
    -- upvalues: u42 (copy)
    local u254 = p253 or function() -- Line: 1355
        return true;
    end;

    return u42._new(debug.traceback(nil, 2), function(u255, p256, p257) -- Line: 1359
        -- upvalues: u252 (copy), u254 (ref)
        local u258 = nil;
        local u259 = false;

        local function disconnect() -- Line: 1363
            -- upvalues: u258 (ref)
            u258:Disconnect();
            u258 = nil;
        end;

        u258 = u252:Connect(function(...) -- Line: 1372
            -- upvalues: u254 (ref), u255 (copy), u258 (ref), u259 (ref)
            local v260 = u254(...);

            if v260 ~= true then
                if type(v260) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean");
                end;

                return;
            end;

            u255(...);

            if not u258 then
                u259 = true;

                return;
            end;

            u258:Disconnect();
            u258 = nil;
        end);

        if u259 and u258 then
            return disconnect();
        end;

        p257(function() -- Line: 1392
            -- upvalues: u258 (ref)
            u258:Disconnect();
            u258 = nil;
        end);
    end);
end;

return u42;