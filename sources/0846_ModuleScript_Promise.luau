-- Decompiled with Potassium's decompiler.

local u1 = {
    __mode = "k"
};

local function isCallable(p2) -- Line: 10
    if type(p2) == "function" then
        return true;
    end;

    local v3 = type(p2) == "table" and getmetatable(p2);

    if v3 then
        local v4 = rawget(v3, "__call");

        if type(v4) == "function" then
            return true;
        end;
    end;

    return false;
end;

local function makeEnum(u5, p6) -- Line: 28
    local v7 = {};

    for _, v in ipairs(p6) do
        v7[v] = v;
    end;

    return setmetatable(v7, {
        __index = function(p8, p9) -- Line: 36, Name: __index
            -- upvalues: u5 (copy)
            error(string.format("%s is not in %s!", p9, u5), 2);
        end,

        __newindex = function() -- Line: 39, Name: __newindex
            -- upvalues: u5 (copy)
            error(string.format("Creating new members in %s is not allowed!", u5), 2);
        end
    });
end;

local u10 = {
    Kind = makeEnum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" })
};
u10.__index = u10;

function u10.new(p11, p12) -- Line: 64
    -- upvalues: u10 (ref)
    local v13 = p11 or {};
    local v14 = {
        error = tostring(v13.error) or "[This error has no error text.]",
        trace = v13.trace,
        context = v13.context,
        kind = v13.kind,
        parent = p12,
        createdTick = os.clock(),
        createdTrace = debug.traceback()
    };

    return setmetatable(v14, u10);
end;

function u10.is(p15) -- Line: 77
    if type(p15) == "table" then
        local v16 = getmetatable(p15);

        if type(v16) == "table" then
            local v17;

            if rawget(p15, "error") == nil then
                v17 = false;
            else
                local v18 = rawget(v16, "extend");
                v17 = type(v18) == "function";
            end;

            return v17;
        end;
    end;

    return false;
end;

function u10.isKind(p19, p20) -- Line: 89
    -- upvalues: u10 (ref)
    assert(p20 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil");
    local v21 = u10.is(p19) and p19.kind == p20;

    return v21;
end;

function u10.extend(p22, p23) -- Line: 95
    -- upvalues: u10 (ref)
    local v24 = p23 or {};
    v24.kind = v24.kind or p22.kind;

    return u10.new(v24, p22);
end;

function u10.getErrorChain(p25) -- Line: 103
    local v26 = { p25 };

    while v26[#v26].parent do
        table.insert(v26, v26[#v26].parent);
    end;

    return v26;
end;

function u10.__tostring(p27) -- Line: 113
    local v28 = { string.format("-- Promise.Error(%s) --", p27.kind or "?") };

    for _, v in ipairs(p27:getErrorChain()) do
        table.insert(v28, table.concat({ v.trace or v.error, v.context }, "\n"));
    end;

    return table.concat(v28, "\n");
end;

local function pack(...) -- Line: 137
    return select("#", ...), { ... };
end;

local function packResult(p29, ...) -- Line: 144
    return p29, select("#", ...), { ... };
end;

local function makeErrorHandler(u30) -- Line: 148
    -- upvalues: u10 (ref)
    assert(u30 ~= nil, "traceback is nil");

    return function(p31) -- Line: 151
        -- upvalues: u10 (ref), u30 (copy)
        if type(p31) == "table" then
            return p31;
        end;

        return u10.new({
            error = p31,
            kind = u10.Kind.ExecutionError,
            trace = debug.traceback(tostring(p31), 2),
            context = "Promise created at:\n\n" .. u30
        });
    end;
end;

local function runExecutor(u32, p33, ...) -- Line: 171
    -- upvalues: packResult (copy), u10 (ref)
    local v34 = xpcall;
    assert(u32 ~= nil, "traceback is nil");

    return packResult(v34(p33, function(p35) -- Line: 151
        -- upvalues: u10 (ref), u32 (copy)
        if type(p35) == "table" then
            return p35;
        end;

        return u10.new({
            error = p35,
            kind = u10.Kind.ExecutionError,
            trace = debug.traceback(tostring(p35), 2),
            context = "Promise created at:\n\n" .. u32
        });
    end, ...));
end;

local function createAdvancer(u36, u37, u38, u39) -- Line: 179
    -- upvalues: runExecutor (copy)
    return function(...) -- Line: 180
        -- upvalues: runExecutor (ref), u36 (copy), u37 (copy), u38 (copy), u39 (copy)
        local v40, v41, v42 = runExecutor(u36, u37, ...);

        if v40 then
            u38(unpack(v42, 1, v41));

            return;
        end;

        u39(v42[1]);
    end;
end;

local function isEmpty(p43) -- Line: 191
    return next(p43) == nil;
end;

local u44 = {
    TEST = nil,
    Error = u10,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    _unhandledRejectionCallbacks = {},
    prototype = {}
};
u44.__index = u44.prototype;

function u44._new(p45, u46, p47) -- Line: 231
    -- upvalues: u44 (copy), u1 (copy), runExecutor (copy)
    if p47 ~= nil and not u44.is(p47) then
        error("Argument #2 to Promise.new must be a promise or nil", 2);
    end;

    local u48 = {
        _thread = nil,
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p45,
        _status = u44.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p47,
        _consumers = setmetatable({}, u1)
    };

    if p47 and p47._status == u44.Status.Started then
        p47._consumers[u48] = true;
    end;

    setmetatable(u48, u44);

    local function resolve(...) -- Line: 279
        -- upvalues: u48 (copy)
        u48:_resolve(...);
    end;

    local function reject(...) -- Line: 283
        -- upvalues: u48 (copy)
        u48:_reject(...);
    end;

    local function onCancel(p49) -- Line: 287
        -- upvalues: u48 (copy), u44 (ref)
        if p49 then
            if u48._status == u44.Status.Cancelled then
                p49();
            else
                u48._cancellationHook = p49;
            end;
        end;

        return u48._status == u44.Status.Cancelled;
    end;

    u48._thread = coroutine.create(function() -- Line: 299
        -- upvalues: runExecutor (ref), u48 (copy), u46 (copy), resolve (copy), reject (copy), onCancel (copy)
        local v50, _, v51 = runExecutor(u48._source, u46, resolve, reject, onCancel);

        if not v50 then
            reject(v51[1]);
        end;
    end);
    task.spawn(u48._thread);

    return u48;
end;

function u44.new(p52) -- Line: 350
    -- upvalues: u44 (copy)
    return u44._new(debug.traceback(nil, 2), p52);
end;

function u44.__tostring(p53) -- Line: 354
    return string.format("Promise(%s)", p53._status);
end;

function u44.defer(u54) -- Line: 376
    -- upvalues: u44 (copy), runExecutor (copy)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u44._new(debug_traceback_ret, function(u55, u56, u57) -- Line: 379
        -- upvalues: u44 (ref), runExecutor (ref), debug_traceback_ret (copy), u54 (copy)
        local u58 = nil;
        u58 = u44._timeEvent:Connect(function() -- Line: 381
            -- upvalues: u58 (ref), runExecutor (ref), debug_traceback_ret (ref), u54 (ref), u55 (copy), u56 (copy), u57 (copy)
            u58:Disconnect();
            local v59, _, v60 = runExecutor(debug_traceback_ret, u54, u55, u56, u57);

            if not v59 then
                u56(v60[1]);
            end;
        end);
    end);
end;

u44.async = u44.defer;

function u44.resolve(...) -- Line: 419
    -- upvalues: pack (copy), u44 (copy)
    local u61, u62 = pack(...);

    return u44._new(debug.traceback(nil, 2), function(p63) -- Line: 421
        -- upvalues: u62 (copy), u61 (copy)
        p63(unpack(u62, 1, u61));
    end);
end;

function u44.reject(...) -- Line: 436
    -- upvalues: pack (copy), u44 (copy)
    local u64, u65 = pack(...);

    return u44._new(debug.traceback(nil, 2), function(p66, p67) -- Line: 438
        -- upvalues: u65 (copy), u64 (copy)
        p67(unpack(u65, 1, u64));
    end);
end;

function u44._try(p68, u69, ...) -- Line: 447
    -- upvalues: pack (copy), u44 (copy)
    local u70, u71 = pack(...);

    return u44._new(p68, function(p72) -- Line: 450
        -- upvalues: u69 (copy), u71 (copy), u70 (copy)
        p72(u69(unpack(u71, 1, u70)));
    end);
end;

function u44.try(p73, ...) -- Line: 478
    -- upvalues: u44 (copy)
    return u44._try(debug.traceback(nil, 2), p73, ...);
end;

function u44._all(p74, u75, u76) -- Line: 487
    -- upvalues: u44 (copy)
    if type(u75) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
    end;

    for i, v in pairs(u75) do
        if not u44.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(i))), 3);
        end;
    end;

    if #u75 == 0 or u76 == 0 then
        return u44.resolve({});
    end;

    return u44._new(p74, function(u77, u78, p79) -- Line: 505
        -- upvalues: u76 (copy), u75 (copy)
        local u80 = {};
        local u81 = {};
        local u82 = 0;
        local u83 = 0;
        local u84 = false;

        local function resolveOne(p85, ...) -- Line: 523
            -- upvalues: u84 (ref), u82 (ref), u76 (ref), u80 (copy), u75 (ref), u77 (copy), u81 (copy)
            if u84 then
                return;
            end;

            u82 = u82 + 1;

            if u76 == nil then
                u80[p85] = ...;
            else
                u80[u82] = ...;
            end;

            if u82 >= (u76 or #u75) then
                u84 = true;
                u77(u80);

                for _, v in ipairs(u81) do
                    v:cancel();
                end;
            end;
        end;

        p79(function() -- Line: 516, Name: cancel
            -- upvalues: u81 (copy)
            for _, v in ipairs(u81) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u75) do
            u81[i] = v:andThen(function(...) -- Line: 548
                -- upvalues: resolveOne (copy), i (copy)
                resolveOne(i, ...);
            end, function(...) -- Line: 550
                -- upvalues: u83 (ref), u76 (ref), u75 (ref), u81 (copy), u84 (ref), u78 (copy)
                u83 = u83 + 1;

                if u76 == nil or #u75 - u83 < u76 then
                    for _, v2 in ipairs(u81) do
                        v2:cancel();
                    end;

                    u84 = true;
                    u78(...);
                end;
            end);
        end;

        if u84 then
            for _, v in ipairs(u81) do
                v:cancel();
            end;
        end;
    end);
end;

function u44.all(p86) -- Line: 592
    -- upvalues: u44 (copy)
    return u44._all(debug.traceback(nil, 2), p86);
end;

function u44.fold(p87, u88, p89) -- Line: 621
    -- upvalues: u44 (copy)
    local v90 = type(p87) == "table";
    assert(v90, "Bad argument #1 to Promise.fold: must be a table");
    local v91;

    if type(u88) == "function" then
        v91 = true;
    elseif type(u88) == "table" then
        local v92 = getmetatable(u88);

        if v92 then
            local v93 = rawget(v92, "__call");
            v91 = type(v93) == "function";
        else
            v91 = false;
        end;
    else
        v91 = false;
    end;

    assert(v91, "Bad argument #2 to Promise.fold: must be a function");
    local u94 = u44.resolve(p89);

    return u44.each(p87, function(u95, u96) -- Line: 626
        -- upvalues: u94 (ref), u88 (copy)
        u94 = u94:andThen(function(p97) -- Line: 627
            -- upvalues: u88 (ref), u95 (copy), u96 (copy)
            return u88(p97, u95, u96);
        end);
    end):andThen(function() -- Line: 630
        -- upvalues: u94 (ref)
        return u94;
    end);
end;

function u44.some(p98, p99) -- Line: 654
    -- upvalues: u44 (copy)
    local v100 = type(p99) == "number";
    assert(v100, "Bad argument #2 to Promise.some: must be a number");

    return u44._all(debug.traceback(nil, 2), p98, p99);
end;

function u44.any(p101) -- Line: 678
    -- upvalues: u44 (copy)
    return u44._all(debug.traceback(nil, 2), p101, 1):andThen(function(p102) -- Line: 679
        return p102[1];
    end);
end;

function u44.allSettled(u103) -- Line: 700
    -- upvalues: u44 (copy)
    if type(u103) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
    end;

    for i, v in pairs(u103) do
        if not u44.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(i))), 2);
        end;
    end;

    if #u103 == 0 then
        return u44.resolve({});
    end;

    return u44._new(debug.traceback(nil, 2), function(u104, p105, p106) -- Line: 718
        -- upvalues: u103 (copy)
        local u107 = {};
        local u108 = {};
        local u109 = 0;

        local function u111(p110, ...) -- Line: 728
            -- upvalues: u109 (ref), u107 (copy), u103 (ref), u104 (copy)
            u109 = u109 + 1;
            u107[p110] = ...;

            if u109 >= #u103 then
                u104(u107);
            end;
        end;

        p106(function() -- Line: 738
            -- upvalues: u108 (copy)
            for _, v in ipairs(u108) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u103) do
            u108[i] = v:finally(function(...) -- Line: 747
                -- upvalues: u111 (copy), i (copy)
                u111(i, ...);
            end);
        end;
    end);
end;

function u44.race(u112) -- Line: 778
    -- upvalues: u44 (copy)
    local v113 = type(u112) == "table";
    assert(v113, string.format("Please pass a list of promises to %s", "Promise.race"));

    for i, v in pairs(u112) do
        local v114 = u44.is(v);
        local string_format = string.format;
        local v115 = tostring(i);
        assert(v114, string_format("Non-promise value passed into %s at index %s", "Promise.race", v115));
    end;

    return u44._new(debug.traceback(nil, 2), function(u116, u117, p118) -- Line: 785
        -- upvalues: u112 (copy)
        local u119 = {};
        local u120 = false;

        local function cancel() -- Line: 789
            -- upvalues: u119 (copy)
            for _, v in ipairs(u119) do
                v:cancel();
            end;
        end;

        local function finalize(u121) -- Line: 795
            -- upvalues: u119 (copy), u120 (ref)
            return function(...) -- Line: 796
                -- upvalues: u119 (ref), u120 (ref), u121 (copy)
                for _, v in ipairs(u119) do
                    v:cancel();
                end;

                u120 = true;

                return u121(...);
            end;
        end;

        if p118(function(...) -- Line: 796
            -- upvalues: u119 (copy), u120 (ref), u117 (copy)
            for _, v in ipairs(u119) do
                v:cancel();
            end;

            u120 = true;

            return u117(...);
        end) then
            return;
        end;

        for i, v in ipairs(u112) do
            u119[i] = v:andThen(function(...) -- Line: 796
                -- upvalues: u119 (copy), u120 (ref), u116 (copy)
                for _, v2 in ipairs(u119) do
                    v2:cancel();
                end;

                u120 = true;

                return u116(...);
            end, function(...) -- Line: 796
                -- upvalues: u119 (copy), u120 (ref), u117 (copy)
                for _, v2 in ipairs(u119) do
                    v2:cancel();
                end;

                u120 = true;

                return u117(...);
            end);
        end;

        if u120 then
            for _, v in ipairs(u119) do
                v:cancel();
            end;
        end;
    end);
end;

function u44.each(u122, u123) -- Line: 873
    -- upvalues: u44 (copy), u10 (ref)
    local v124 = type(u122) == "table";
    assert(v124, string.format("Please pass a list of promises to %s", "Promise.each"));
    local v125;

    if type(u123) == "function" then
        v125 = true;
    elseif type(u123) == "table" then
        local v126 = getmetatable(u123);

        if v126 then
            local v127 = rawget(v126, "__call");
            v125 = type(v127) == "function";
        else
            v125 = false;
        end;
    else
        v125 = false;
    end;

    assert(v125, string.format("Please pass a handler function to %s!", "Promise.each"));

    return u44._new(debug.traceback(nil, 2), function(p128, p129, p130) -- Line: 877
        -- upvalues: u122 (copy), u44 (ref), u10 (ref), u123 (copy)
        local v131 = {};
        local u132 = {};
        local u133 = false;

        local function _() -- Line: 883
            -- upvalues: u132 (copy)
            for _, v in ipairs(u132) do
                v:cancel();
            end;
        end;

        p130(function() -- Line: 889
            -- upvalues: u133 (ref), u132 (copy)
            u133 = true;

            for _, v in ipairs(u132) do
                v:cancel();
            end;
        end);
        local v134 = {};

        for i, v in ipairs(u122) do
            if u44.is(v) then
                if v:getStatus() == u44.Status.Cancelled then
                    for _, v2 in ipairs(u132) do
                        v2:cancel();
                    end;

                    return p129(u10.new({
                        error = "Promise is cancelled",
                        kind = u10.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
                    }));
                end;

                if v:getStatus() == u44.Status.Rejected then
                    for _, v2 in ipairs(u132) do
                        v2:cancel();
                    end;

                    return p129(select(2, v:await()));
                end;

                local v135 = v:andThen(function(...) -- Line: 922
                    return ...;
                end);
                table.insert(u132, v135);
                v134[i] = v135;
            else
                v134[i] = v;
            end;
        end;

        for i, v in ipairs(v134) do
            local v136;

            if u44.is(v) then
                local v137;
                v137, v136 = v:await();

                if not v137 then
                    for _, v2 in ipairs(u132) do
                        v2:cancel();
                    end;

                    return p129(v136);
                end;
            else
                v136 = v;
            end;

            if u133 then
                return;
            end;

            local v138 = u44.resolve(u123(v136, i));
            table.insert(u132, v138);
            local v139, v140 = v138:await();

            if not v139 then
                for _, v2 in ipairs(u132) do
                    v2:cancel();
                end;

                return p129(v140);
            end;

            v131[i] = v140;
        end;

        p128(v131);
    end);
end;

function u44.is(p141) -- Line: 973
    -- upvalues: u44 (copy)
    if type(p141) ~= "table" then
        return false;
    end;

    local v142 = getmetatable(p141);

    if v142 == u44 then
        return true;
    end;

    if v142 ~= nil then
        if type(v142) == "table" then
            local v143 = rawget(v142, "__index");

            if type(v143) == "table" then
                local v144 = rawget(v142, "__index");
                local v145 = rawget(v144, "andThen");
                local v146;

                if type(v145) == "function" then
                    v146 = true;
                else
                    local v147 = type(v145) == "table" and getmetatable(v145);

                    if v147 then
                        local v148 = rawget(v147, "__call");
                        v146 = type(v148) == "function";
                    else
                        v146 = false;
                    end;
                end;

                if v146 then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    local andThen = p141.andThen;

    if type(andThen) == "function" then
        return true;
    end;

    local v149 = type(andThen) == "table" and getmetatable(andThen);

    if v149 then
        local v150 = rawget(v149, "__call");

        if type(v150) == "function" then
            return true;
        end;
    end;

    return false;
end;

function u44.promisify(u151) -- Line: 1022
    -- upvalues: u44 (copy)
    return function(...) -- Line: 1023
        -- upvalues: u44 (ref), u151 (copy)
        return u44._try(debug.traceback(nil, 2), u151, ...);
    end;
end;

local u152 = nil;
local u153 = nil;

function u44.delay(p154) -- Line: 1053
    -- upvalues: u44 (copy), u153 (ref), u152 (ref)
    local v155 = type(p154) == "number";
    assert(v155, "Bad argument #1 to Promise.delay, must be a number.");
    local u156 = (p154 < 0.016666666666666666 or p154 == (1 / 0)) and 0.016666666666666666 or p154;

    return u44._new(debug.traceback(nil, 2), function(p157, p158, p159) -- Line: 1061
        -- upvalues: u44 (ref), u156 (ref), u153 (ref), u152 (ref)
        local v160 = u44._getTime();
        local v161 = v160 + u156;
        local u162 = {
            resolve = p157,
            startTime = v160,
            endTime = v161
        };

        if u153 == nil then
            u152 = u162;
            u153 = u44._timeEvent:Connect(function() -- Line: 1073
                -- upvalues: u44 (ref), u152 (ref), u153 (ref)
                local v163 = u44._getTime();

                while u152 ~= nil and u152.endTime < v163 do
                    local v164 = u152;
                    u152 = v164.next;

                    if u152 == nil then
                        u153:Disconnect();
                        u153 = nil;
                    else
                        u152.previous = nil;
                    end;

                    v164.resolve(u44._getTime() - v164.startTime);
                end;
            end);
        elseif u152.endTime < v161 then
            local v165 = u152;
            local next2 = v165.next;

            while next2 ~= nil and next2.endTime < v161 do
                v165 = next2;
                next2 = next2.next;
            end;

            v165.next = u162;
            u162.previous = v165;

            if next2 ~= nil then
                u162.next = next2;
                next2.previous = u162;
            end;
        else
            u162.next = u152;
            u152.previous = u162;
            u152 = u162;
        end;

        p159(function() -- Line: 1118
            -- upvalues: u162 (copy), u152 (ref), u153 (ref)
            local next2 = u162.next;

            if u152 == u162 then
                if next2 == nil then
                    u153:Disconnect();
                    u153 = nil;
                else
                    next2.previous = nil;
                end;

                u152 = next2;

                return;
            end;

            local previous = u162.previous;
            previous.next = next2;

            if next2 ~= nil then
                next2.previous = previous;
            end;
        end);
    end);
end;

function u44.prototype.timeout(p166, u167, u168) -- Line: 1182
    -- upvalues: u44 (copy), u10 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u44.race({ u44.delay(u167):andThen(function() -- Line: 1186
            -- upvalues: u44 (ref), u168 (copy), u10 (ref), u167 (copy), debug_traceback_ret (copy)
            return u44.reject(u168 == nil and u10.new({
                error = "Timed out",
                kind = u10.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", u167, debug_traceback_ret)
            }) or u168);
        end), p166 });
end;

function u44.prototype.getStatus(p169) -- Line: 1206
    return p169._status;
end;

function u44.prototype._andThen(u170, u171, u172, u173) -- Line: 1215
    -- upvalues: u44 (copy), runExecutor (copy)
    u170._unhandledRejection = false;

    if u170._status ~= u44.Status.Cancelled then
        return u44._new(u171, function(u174, u175, p176) -- Line: 1227
            -- upvalues: u172 (copy), u171 (copy), runExecutor (ref), u173 (copy), u170 (copy), u44 (ref)
            local u177;

            if u172 then
                local u178 = u171;
                local u179 = u172;

                u177 = function(...) -- Line: 180
                    -- upvalues: runExecutor (ref), u178 (copy), u179 (copy), u174 (copy), u175 (copy)
                    local v180, v181, v182 = runExecutor(u178, u179, ...);

                    if v180 then
                        u174(unpack(v182, 1, v181));

                        return;
                    end;

                    u175(v182[1]);
                end;
            else
                u177 = u174;
            end;

            if u173 then
                local u183 = u171;
                local u184 = u173;

                u175 = function(...) -- Line: 180
                    -- upvalues: runExecutor (ref), u183 (copy), u184 (copy), u174 (copy), u175 (copy)
                    local v185, v186, v187 = runExecutor(u183, u184, ...);

                    if v185 then
                        u174(unpack(v187, 1, v186));

                        return;
                    end;

                    u175(v187[1]);
                end;
            end;

            if u170._status == u44.Status.Started then
                table.insert(u170._queuedResolve, u177);
                table.insert(u170._queuedReject, u175);
                p176(function() -- Line: 1246
                    -- upvalues: u170 (ref), u44 (ref), u177 (ref), u175 (ref)
                    if u170._status == u44.Status.Started then
                        table.remove(u170._queuedResolve, table.find(u170._queuedResolve, u177));
                        table.remove(u170._queuedReject, table.find(u170._queuedReject, u175));
                    end;
                end);
            elseif u170._status == u44.Status.Resolved then
                u177(unpack(u170._values, 1, u170._valuesLength));
            elseif u170._status == u44.Status.Rejected then
                u175(unpack(u170._values, 1, u170._valuesLength));
            end;
        end, u170);
    end;

    local v188 = u44.new(function() -- Line: 1220
    end);
    v188:cancel();

    return v188;
end;

function u44.prototype.andThen(p189, p190, p191) -- Line: 1285
    local v192;

    if p190 == nil or type(p190) == "function" then
        v192 = true;
    elseif type(p190) == "table" then
        local v193 = getmetatable(p190);

        if v193 then
            local v194 = rawget(v193, "__call");
            v192 = type(v194) == "function";
        else
            v192 = false;
        end;
    else
        v192 = false;
    end;

    assert(v192, string.format("Please pass a handler function to %s!", "Promise:andThen"));
    local v195;

    if p191 == nil or type(p191) == "function" then
        v195 = true;
    elseif type(p191) == "table" then
        local v196 = getmetatable(p191);

        if v196 then
            local v197 = rawget(v196, "__call");
            v195 = type(v197) == "function";
        else
            v195 = false;
        end;
    else
        v195 = false;
    end;

    assert(v195, string.format("Please pass a handler function to %s!", "Promise:andThen"));

    return p189:_andThen(debug.traceback(nil, 2), p190, p191);
end;

function u44.prototype.catch(p198, p199) -- Line: 1312
    local v200;

    if p199 == nil or type(p199) == "function" then
        v200 = true;
    elseif type(p199) == "table" then
        local v201 = getmetatable(p199);

        if v201 then
            local v202 = rawget(v201, "__call");
            v200 = type(v202) == "function";
        else
            v200 = false;
        end;
    else
        v200 = false;
    end;

    assert(v200, string.format("Please pass a handler function to %s!", "Promise:catch"));

    return p198:_andThen(debug.traceback(nil, 2), nil, p199);
end;

function u44.prototype.tap(p203, u204) -- Line: 1333
    -- upvalues: u44 (copy), pack (copy)
    local v205;

    if type(u204) == "function" then
        v205 = true;
    elseif type(u204) == "table" then
        local v206 = getmetatable(u204);

        if v206 then
            local v207 = rawget(v206, "__call");
            v205 = type(v207) == "function";
        else
            v205 = false;
        end;
    else
        v205 = false;
    end;

    assert(v205, string.format("Please pass a handler function to %s!", "Promise:tap"));

    return p203:_andThen(debug.traceback(nil, 2), function(...) -- Line: 1335
        -- upvalues: u204 (copy), u44 (ref), pack (ref)
        local v208 = u204(...);

        if not u44.is(v208) then
            return ...;
        end;

        local u209, u210 = pack(...);

        return v208:andThen(function() -- Line: 1340
            -- upvalues: u210 (copy), u209 (copy)
            return unpack(u210, 1, u209);
        end);
    end);
end;

function u44.prototype.andThenCall(p211, u212, ...) -- Line: 1368
    -- upvalues: pack (copy)
    local v213;

    if type(u212) == "function" then
        v213 = true;
    elseif type(u212) == "table" then
        local v214 = getmetatable(u212);

        if v214 then
            local v215 = rawget(v214, "__call");
            v213 = type(v215) == "function";
        else
            v213 = false;
        end;
    else
        v213 = false;
    end;

    assert(v213, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
    local u216, u217 = pack(...);

    return p211:_andThen(debug.traceback(nil, 2), function() -- Line: 1371
        -- upvalues: u212 (copy), u217 (copy), u216 (copy)
        return u212(unpack(u217, 1, u216));
    end);
end;

function u44.prototype.andThenReturn(p218, ...) -- Line: 1398
    -- upvalues: pack (copy)
    local u219, u220 = pack(...);

    return p218:_andThen(debug.traceback(nil, 2), function() -- Line: 1400
        -- upvalues: u220 (copy), u219 (copy)
        return unpack(u220, 1, u219);
    end);
end;

function u44.prototype.cancel(p221) -- Line: 1416
    -- upvalues: u44 (copy)
    if p221._status ~= u44.Status.Started then
        return;
    end;

    p221._status = u44.Status.Cancelled;

    if p221._cancellationHook then
        p221._cancellationHook();
    end;

    coroutine.close(p221._thread);

    if p221._parent then
        p221._parent:_consumerCancelled(p221);
    end;

    for i in pairs(p221._consumers) do
        i:cancel();
    end;

    p221:_finalize();
end;

function u44.prototype._consumerCancelled(p222, p223) -- Line: 1444
    -- upvalues: u44 (copy)
    if p222._status ~= u44.Status.Started then
        return;
    end;

    p222._consumers[p223] = nil;

    if next(p222._consumers) == nil then
        p222:cancel();
    end;
end;

function u44.prototype._finally(u224, p225, u226) -- Line: 1460
    -- upvalues: u44 (copy)
    u224._unhandledRejection = false;

    return u44._new(p225, function(u227, u228, p229) -- Line: 1463
        -- upvalues: u224 (copy), u226 (copy), u44 (ref)
        local u230 = nil;
        p229(function() -- Line: 1466
            -- upvalues: u224 (ref), u230 (ref)
            u224:_consumerCancelled(u224);

            if u230 then
                u230:cancel();
            end;
        end);
        local v233 = u226 and function(...) -- Line: 1479
            -- upvalues: u226 (ref), u44 (ref), u230 (ref), u227 (copy), u224 (ref), u228 (copy)
            local v231 = u226(...);

            if not u44.is(v231) then
                u227(u224);

                return;
            end;

            u230 = v231;
            v231:finally(function(p232) -- Line: 1486
                -- upvalues: u44 (ref), u227 (ref), u224 (ref)
                if p232 ~= u44.Status.Rejected then
                    u227(u224);
                end;
            end):catch(function(...) -- Line: 1491
                -- upvalues: u228 (ref)
                u228(...);
            end);
        end or u227;

        if u224._status == u44.Status.Started then
            table.insert(u224._queuedFinally, v233);
        else
            v233(u224._status);
        end;
    end);
end;

function u44.prototype.finally(p234, p235) -- Line: 1561
    local v236;

    if p235 == nil or type(p235) == "function" then
        v236 = true;
    elseif type(p235) == "table" then
        local v237 = getmetatable(p235);

        if v237 then
            local v238 = rawget(v237, "__call");
            v236 = type(v238) == "function";
        else
            v236 = false;
        end;
    else
        v236 = false;
    end;

    assert(v236, string.format("Please pass a handler function to %s!", "Promise:finally"));

    return p234:_finally(debug.traceback(nil, 2), p235);
end;

function u44.prototype.finallyCall(p239, u240, ...) -- Line: 1575
    -- upvalues: pack (copy)
    local v241;

    if type(u240) == "function" then
        v241 = true;
    elseif type(u240) == "table" then
        local v242 = getmetatable(u240);

        if v242 then
            local v243 = rawget(v242, "__call");
            v241 = type(v243) == "function";
        else
            v241 = false;
        end;
    else
        v241 = false;
    end;

    assert(v241, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
    local u244, u245 = pack(...);

    return p239:_finally(debug.traceback(nil, 2), function() -- Line: 1578
        -- upvalues: u240 (copy), u245 (copy), u244 (copy)
        return u240(unpack(u245, 1, u244));
    end);
end;

function u44.prototype.finallyReturn(p246, ...) -- Line: 1601
    -- upvalues: pack (copy)
    local u247, u248 = pack(...);

    return p246:_finally(debug.traceback(nil, 2), function() -- Line: 1603
        -- upvalues: u248 (copy), u247 (copy)
        return unpack(u248, 1, u247);
    end);
end;

function u44.prototype.awaitStatus(p249) -- Line: 1615
    -- upvalues: u44 (copy)
    p249._unhandledRejection = false;

    if p249._status == u44.Status.Started then
        local coroutine_running_ret = coroutine.running();
        p249:finally(function() -- Line: 1622
            -- upvalues: coroutine_running_ret (copy)
            task.spawn(coroutine_running_ret);
        end):catch(function() -- Line: 1628
        end);
        coroutine.yield();
    end;

    if p249._status == u44.Status.Resolved then
        return p249._status, unpack(p249._values, 1, p249._valuesLength);
    end;

    if p249._status == u44.Status.Rejected then
        return p249._status, unpack(p249._values, 1, p249._valuesLength);
    end;

    return p249._status;
end;

local function awaitHelper(p250, ...) -- Line: 1643
    -- upvalues: u44 (copy)
    return p250 == u44.Status.Resolved, ...;
end;

function u44.prototype.await(p251) -- Line: 1668
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p251:awaitStatus());
end;

local function expectHelper(p252, ...) -- Line: 1672
    -- upvalues: u44 (copy)
    if p252 ~= u44.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3);
    end;

    return ...;
end;

function u44.prototype.expect(p253) -- Line: 1705
    -- upvalues: expectHelper (copy)
    return expectHelper(p253:awaitStatus());
end;

u44.prototype.awaitValue = u44.prototype.expect;

function u44.prototype._unwrap(p254) -- Line: 1719
    -- upvalues: u44 (copy)
    if p254._status == u44.Status.Started then
        error("Promise has not resolved or rejected.", 2);
    end;

    return p254._status == u44.Status.Resolved, unpack(p254._values, 1, p254._valuesLength);
end;

function u44.prototype._resolve(u255, ...) -- Line: 1729
    -- upvalues: u44 (copy), u10 (ref), pack (copy)
    if u255._status ~= u44.Status.Started then
        if u44.is((...)) then
            (...):_consumerCancelled(u255);
        end;

        return;
    end;

    if u44.is((...)) then
        if select("#", ...) > 1 then
            local string_format_ret = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", u255._source);
            warn(string_format_ret);
        end;

        local u256 = ...;
        local v258 = u256:andThen(function(...) -- Line: 1750
            -- upvalues: u255 (copy)
            u255:_resolve(...);
        end, function(...) -- Line: 1752
            -- upvalues: u256 (copy), u10 (ref), u255 (copy)
            local v257 = u256._values[1];

            if u256._error then
                v257 = u10.new({
                    context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    error = u256._error,
                    kind = u10.Kind.ExecutionError
                });
            end;

            if u10.isKind(v257, u10.Kind.ExecutionError) then
                return u255:_reject(v257:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", u255._source)
                }));
            end;

            u255:_reject(...);
        end);

        if v258._status == u44.Status.Cancelled then
            u255:cancel();

            return;
        end;

        if v258._status == u44.Status.Started then
            u255._parent = v258;
            v258._consumers[u255] = true;
        end;

        return;
    end;

    u255._status = u44.Status.Resolved;
    local v259, v260 = pack(...);
    u255._valuesLength = v259;
    u255._values = v260;

    for _, v in ipairs(u255._queuedResolve) do
        coroutine.wrap(v)(...);
    end;

    u255:_finalize();
end;

function u44.prototype._reject(u261, ...) -- Line: 1801
    -- upvalues: u44 (copy), pack (copy)
    if u261._status ~= u44.Status.Started then
        return;
    end;

    u261._status = u44.Status.Rejected;
    local v262, v263 = pack(...);
    u261._valuesLength = v262;
    u261._values = v263;

    if next(u261._queuedReject) == nil then
        local u264 = tostring((...));
        coroutine.wrap(function() -- Line: 1823
            -- upvalues: u44 (ref), u261 (copy), u264 (copy)
            u44._timeEvent:Wait();

            if not u261._unhandledRejection then
                return;
            end;

            local string_format_ret = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u264, u261._source);

            for _, v in ipairs(u44._unhandledRejectionCallbacks) do
                task.spawn(v, u261, unpack(u261._values, 1, u261._valuesLength));
            end;

            if u44.TEST then
                return;
            end;

            warn(string_format_ret);
        end)();
    else
        for _, v in ipairs(u261._queuedReject) do
            coroutine.wrap(v)(...);
        end;
    end;

    u261:_finalize();
end;

function u44.prototype._finalize(p265) -- Line: 1855
    -- upvalues: u44 (copy)
    for _, v in ipairs(p265._queuedFinally) do
        coroutine.wrap(v)(p265._status);
    end;

    p265._queuedFinally = nil;
    p265._queuedReject = nil;
    p265._queuedResolve = nil;

    if not u44.TEST then
        p265._parent = nil;
        p265._consumers = nil;
    end;

    task.defer(coroutine.close, p265._thread);
end;

function u44.prototype.now(p266, p267) -- Line: 1892
    -- upvalues: u44 (copy), u10 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    if p266._status == u44.Status.Resolved then
        return p266:_andThen(debug_traceback_ret, function(...) -- Line: 1895
            return ...;
        end);
    end;

    local reject = u44.reject;

    if p267 == nil then
        p267 = u10.new({
            error = "This Promise was not resolved in time for :now()",
            kind = u10.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. debug_traceback_ret
        }) or p267;
    end;

    return reject(p267);
end;

function u44.retry(u268, u269, ...) -- Line: 1937
    -- upvalues: u44 (copy)
    local v270;

    if type(u268) == "function" then
        v270 = true;
    elseif type(u268) == "table" then
        local v271 = getmetatable(u268);

        if v271 then
            local v272 = rawget(v271, "__call");
            v270 = type(v272) == "function";
        else
            v270 = false;
        end;
    else
        v270 = false;
    end;

    assert(v270, "Parameter #1 to Promise.retry must be a function");
    local v273 = type(u269) == "number";
    assert(v273, "Parameter #2 to Promise.retry must be a number");
    local u274 = { ... };
    local u275 = select("#", ...);

    return u44.resolve(u268(...)):catch(function(...) -- Line: 1943
        -- upvalues: u269 (copy), u44 (ref), u268 (copy), u274 (copy), u275 (copy)
        if u269 > 0 then
            return u44.retry(u268, u269 - 1, unpack(u274, 1, u275));
        end;

        return u44.reject(...);
    end);
end;

function u44.retryWithDelay(u276, u277, u278, ...) -- Line: 1965
    -- upvalues: u44 (copy)
    local v279;

    if type(u276) == "function" then
        v279 = true;
    elseif type(u276) == "table" then
        local v280 = getmetatable(u276);

        if v280 then
            local v281 = rawget(v280, "__call");
            v279 = type(v281) == "function";
        else
            v279 = false;
        end;
    else
        v279 = false;
    end;

    assert(v279, "Parameter #1 to Promise.retry must be a function");
    local v282 = type(u277) == "number";
    assert(v282, "Parameter #2 (times) to Promise.retry must be a number");
    local v283 = type(u278) == "number";
    assert(v283, "Parameter #3 (seconds) to Promise.retry must be a number");
    local u284 = { ... };
    local u285 = select("#", ...);

    return u44.resolve(u276(...)):catch(function(...) -- Line: 1972
        -- upvalues: u277 (copy), u44 (ref), u278 (copy), u276 (copy), u284 (copy), u285 (copy)
        if u277 <= 0 then
            return u44.reject(...);
        end;

        u44.delay(u278):await();

        return u44.retryWithDelay(u276, u277 - 1, u278, unpack(u284, 1, u285));
    end);
end;

function u44.fromEvent(u286, p287) -- Line: 2007
    -- upvalues: u44 (copy)
    local u288 = p287 or function() -- Line: 2008
        return true;
    end;

    return u44._new(debug.traceback(nil, 2), function(u289, p290, p291) -- Line: 2012
        -- upvalues: u286 (copy), u288 (ref)
        local u292 = nil;
        local u293 = false;

        local function disconnect() -- Line: 2016
            -- upvalues: u292 (ref)
            u292:Disconnect();
            u292 = nil;
        end;

        u292 = u286:Connect(function(...) -- Line: 2025
            -- upvalues: u288 (ref), u289 (copy), u292 (ref), u293 (ref)
            local v294 = u288(...);

            if v294 ~= true then
                if type(v294) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean");
                end;

                return;
            end;

            u289(...);

            if not u292 then
                u293 = true;

                return;
            end;

            u292:Disconnect();
            u292 = nil;
        end);

        if u293 and u292 then
            return disconnect();
        end;

        p291(disconnect);
    end);
end;

function u44.onUnhandledRejection(u295) -- Line: 2060
    -- upvalues: u44 (copy)
    table.insert(u44._unhandledRejectionCallbacks, u295);

    return function() -- Line: 2063
        -- upvalues: u44 (ref), u295 (copy)
        local table_find_ret = table.find(u44._unhandledRejectionCallbacks, u295);

        if table_find_ret then
            table.remove(u44._unhandledRejectionCallbacks, table_find_ret);
        end;
    end;
end;

return u44;