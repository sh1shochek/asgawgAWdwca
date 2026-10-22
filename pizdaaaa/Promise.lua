-- ReplicatedStorage.Packages.Promise
-- Script path: ReplicatedStorage.Packages.Promise
-- Decompile time: 22.24 ms

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
    assert(u32 ~= nil, "traceback is nil");

    return packResult(xpcall(p33, function(p34) -- Line: 151
        -- upvalues: u10 (ref), u32 (copy)
        if type(p34) == "table" then
            return p34;
        end;

        return u10.new({
            error = p34,
            kind = u10.Kind.ExecutionError,
            trace = debug.traceback(tostring(p34), 2),
            context = "Promise created at:\n\n" .. u32
        });
    end, ...));
end;

local function createAdvancer(u35, u36, u37, u38) -- Line: 179
    -- upvalues: runExecutor (copy)
    return function(...) -- Line: 180
        -- upvalues: runExecutor (ref), u35 (copy), u36 (copy), u37 (copy), u38 (copy)
        local v39, v40, v41 = runExecutor(u35, u36, ...);

        if v39 then
            u37(unpack(v41, 1, v40));

            return;
        end;

        u38(v41[1]);
    end;
end;

local function isEmpty(p42) -- Line: 191
    return next(p42) == nil;
end;

local u43 = {
    TEST = nil,
    Error = u10,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    _unhandledRejectionCallbacks = {},
    prototype = {}
};
u43.__index = u43.prototype;

function u43._new(p44, u45, p46) -- Line: 231
    -- upvalues: u43 (copy), u1 (copy), runExecutor (copy)
    if p46 ~= nil and not u43.is(p46) then
        error("Argument #2 to Promise.new must be a promise or nil", 2);
    end;

    local u47 = {
        _thread = nil,
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p44,
        _status = u43.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p46,
        _consumers = setmetatable({}, u1)
    };

    if p46 and p46._status == u43.Status.Started then
        p46._consumers[u47] = true;
    end;

    setmetatable(u47, u43);

    local function resolve(...) -- Line: 279
        -- upvalues: u47 (copy)
        u47:_resolve(...);
    end;

    local function reject(...) -- Line: 283
        -- upvalues: u47 (copy)
        u47:_reject(...);
    end;

    local function onCancel(p48) -- Line: 287
        -- upvalues: u47 (copy), u43 (ref)
        if p48 then
            if u47._status == u43.Status.Cancelled then
                p48();
            else
                u47._cancellationHook = p48;
            end;
        end;

        return u47._status == u43.Status.Cancelled;
    end;

    u47._thread = coroutine.create(function() -- Line: 299
        -- upvalues: runExecutor (ref), u47 (copy), u45 (copy), resolve (copy), reject (copy), onCancel (copy)
        local v49, _, v50 = runExecutor(u47._source, u45, resolve, reject, onCancel);

        if not v49 then
            reject(v50[1]);
        end;
    end);
    task.spawn(u47._thread);

    return u47;
end;

function u43.new(p51) -- Line: 350
    -- upvalues: u43 (copy)
    return u43._new(debug.traceback(nil, 2), p51);
end;

function u43.__tostring(p52) -- Line: 354
    return string.format("Promise(%s)", p52._status);
end;

function u43.defer(u53) -- Line: 376
    -- upvalues: u43 (copy), runExecutor (copy)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u43._new(debug_traceback_ret, function(u54, u55, u56) -- Line: 379
        -- upvalues: u43 (ref), runExecutor (ref), debug_traceback_ret (copy), u53 (copy)
        local u57 = nil;
        u57 = u43._timeEvent:Connect(function() -- Line: 381
            -- upvalues: u57 (ref), runExecutor (ref), debug_traceback_ret (ref), u53 (ref), u54 (copy), u55 (copy), u56 (copy)
            u57:Disconnect();
            local v58, _, v59 = runExecutor(debug_traceback_ret, u53, u54, u55, u56);

            if not v58 then
                u55(v59[1]);
            end;
        end);
    end);
end;

u43.async = u43.defer;

function u43.resolve(...) -- Line: 419
    -- upvalues: pack (copy), u43 (copy)
    local u60, u61 = pack(...);

    return u43._new(debug.traceback(nil, 2), function(p62) -- Line: 421
        -- upvalues: u61 (copy), u60 (copy)
        p62(unpack(u61, 1, u60));
    end);
end;

function u43.reject(...) -- Line: 436
    -- upvalues: pack (copy), u43 (copy)
    local u63, u64 = pack(...);

    return u43._new(debug.traceback(nil, 2), function(p65, p66) -- Line: 438
        -- upvalues: u64 (copy), u63 (copy)
        p66(unpack(u64, 1, u63));
    end);
end;

function u43._try(p67, u68, ...) -- Line: 447
    -- upvalues: pack (copy), u43 (copy)
    local u69, u70 = pack(...);

    return u43._new(p67, function(p71) -- Line: 450
        -- upvalues: u68 (copy), u70 (copy), u69 (copy)
        p71(u68(unpack(u70, 1, u69)));
    end);
end;

function u43.try(p72, ...) -- Line: 478
    -- upvalues: u43 (copy)
    return u43._try(debug.traceback(nil, 2), p72, ...);
end;

function u43._all(p73, u74, u75) -- Line: 487
    -- upvalues: u43 (copy)
    if type(u74) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
    end;

    for i, v in pairs(u74) do
        if not u43.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(i))), 3);
        end;
    end;

    if #u74 == 0 or u75 == 0 then
        return u43.resolve({});
    end;

    return u43._new(p73, function(u76, u77, p78) -- Line: 505
        -- upvalues: u75 (copy), u74 (copy)
        local u79 = {};
        local u80 = {};
        local u81 = 0;
        local u82 = 0;
        local u83 = false;

        local function resolveOne(p84, ...) -- Line: 523
            -- upvalues: u83 (ref), u81 (ref), u75 (ref), u79 (copy), u74 (ref), u76 (copy), u80 (copy)
            if u83 then
                return;
            end;

            u81 = u81 + 1;

            if u75 == nil then
                u79[p84] = ...;
            else
                u79[u81] = ...;
            end;

            if u81 >= (u75 or #u74) then
                u83 = true;
                u76(u79);

                for _, v in ipairs(u80) do
                    v:cancel();
                end;
            end;
        end;

        p78(function() -- Line: 516, Name: cancel
            -- upvalues: u80 (copy)
            for _, v in ipairs(u80) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u74) do
            u80[i] = v:andThen(function(...) -- Line: 548
                -- upvalues: resolveOne (copy), i (copy)
                resolveOne(i, ...);
            end, function(...) -- Line: 550
                -- upvalues: u82 (ref), u75 (ref), u74 (ref), u80 (copy), u83 (ref), u77 (copy)
                u82 = u82 + 1;

                if u75 == nil or #u74 - u82 < u75 then
                    for _, v2 in ipairs(u80) do
                        v2:cancel();
                    end;

                    u83 = true;
                    u77(...);
                end;
            end);
        end;

        if u83 then
            for _, v in ipairs(u80) do
                v:cancel();
            end;
        end;
    end);
end;

function u43.all(p85) -- Line: 592
    -- upvalues: u43 (copy)
    return u43._all(debug.traceback(nil, 2), p85);
end;

function u43.fold(p86, u87, p88) -- Line: 621
    -- upvalues: u43 (copy)
    local v89 = type(p86) == "table";
    assert(v89, "Bad argument #1 to Promise.fold: must be a table");
    local v90;

    if type(u87) == "function" then
        v90 = true;
    elseif type(u87) == "table" then
        local v91 = getmetatable(u87);

        if v91 then
            local v92 = rawget(v91, "__call");
            v90 = type(v92) == "function";
        else
            v90 = false;
        end;
    else
        v90 = false;
    end;

    assert(v90, "Bad argument #2 to Promise.fold: must be a function");
    local u93 = u43.resolve(p88);

    return u43.each(p86, function(u94, u95) -- Line: 626
        -- upvalues: u93 (ref), u87 (copy)
        u93 = u93:andThen(function(p96) -- Line: 627
            -- upvalues: u87 (ref), u94 (copy), u95 (copy)
            return u87(p96, u94, u95);
        end);
    end):andThen(function() -- Line: 630
        -- upvalues: u93 (ref)
        return u93;
    end);
end;

function u43.some(p97, p98) -- Line: 654
    -- upvalues: u43 (copy)
    local v99 = type(p98) == "number";
    assert(v99, "Bad argument #2 to Promise.some: must be a number");

    return u43._all(debug.traceback(nil, 2), p97, p98);
end;

function u43.any(p100) -- Line: 678
    -- upvalues: u43 (copy)
    return u43._all(debug.traceback(nil, 2), p100, 1):andThen(function(p101) -- Line: 679
        return p101[1];
    end);
end;

function u43.allSettled(u102) -- Line: 700
    -- upvalues: u43 (copy)
    if type(u102) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
    end;

    for i, v in pairs(u102) do
        if not u43.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(i))), 2);
        end;
    end;

    if #u102 == 0 then
        return u43.resolve({});
    end;

    return u43._new(debug.traceback(nil, 2), function(u103, p104, p105) -- Line: 718
        -- upvalues: u102 (copy)
        local u106 = {};
        local u107 = {};
        local u108 = 0;

        local function u110(p109, ...) -- Line: 728
            -- upvalues: u108 (ref), u106 (copy), u102 (ref), u103 (copy)
            u108 = u108 + 1;
            u106[p109] = ...;

            if u108 >= #u102 then
                u103(u106);
            end;
        end;

        p105(function() -- Line: 738
            -- upvalues: u107 (copy)
            for _, v in ipairs(u107) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u102) do
            u107[i] = v:finally(function(...) -- Line: 747
                -- upvalues: u110 (copy), i (copy)
                u110(i, ...);
            end);
        end;
    end);
end;

function u43.race(u111) -- Line: 778
    -- upvalues: u43 (copy)
    local v112 = type(u111) == "table";
    assert(v112, string.format("Please pass a list of promises to %s", "Promise.race"));

    for i, v in pairs(u111) do
        local v113 = u43.is(v);
        local string_format = string.format;
        local v114 = tostring(i);
        assert(v113, string_format("Non-promise value passed into %s at index %s", "Promise.race", v114));
    end;

    return u43._new(debug.traceback(nil, 2), function(u115, u116, p117) -- Line: 785
        -- upvalues: u111 (copy)
        local u118 = {};
        local u119 = false;

        local function cancel() -- Line: 789
            -- upvalues: u118 (copy)
            for _, v in ipairs(u118) do
                v:cancel();
            end;
        end;

        local function finalize(u120) -- Line: 795
            -- upvalues: u118 (copy), u119 (ref)
            return function(...) -- Line: 796
                -- upvalues: u118 (ref), u119 (ref), u120 (copy)
                for _, v in ipairs(u118) do
                    v:cancel();
                end;

                u119 = true;

                return u120(...);
            end;
        end;

        if p117(function(...) -- Line: 796
            -- upvalues: u118 (copy), u119 (ref), u116 (copy)
            for _, v in ipairs(u118) do
                v:cancel();
            end;

            u119 = true;

            return u116(...);
        end) then
            return;
        end;

        for i, v in ipairs(u111) do
            u118[i] = v:andThen(function(...) -- Line: 796
                -- upvalues: u118 (copy), u119 (ref), u115 (copy)
                for _, v2 in ipairs(u118) do
                    v2:cancel();
                end;

                u119 = true;

                return u115(...);
            end, function(...) -- Line: 796
                -- upvalues: u118 (copy), u119 (ref), u116 (copy)
                for _, v2 in ipairs(u118) do
                    v2:cancel();
                end;

                u119 = true;

                return u116(...);
            end);
        end;

        if u119 then
            for _, v in ipairs(u118) do
                v:cancel();
            end;
        end;
    end);
end;

function u43.each(u121, u122) -- Line: 873
    -- upvalues: u43 (copy), u10 (ref)
    local v123 = type(u121) == "table";
    assert(v123, string.format("Please pass a list of promises to %s", "Promise.each"));
    local v124;

    if type(u122) == "function" then
        v124 = true;
    elseif type(u122) == "table" then
        local v125 = getmetatable(u122);

        if v125 then
            local v126 = rawget(v125, "__call");
            v124 = type(v126) == "function";
        else
            v124 = false;
        end;
    else
        v124 = false;
    end;

    assert(v124, string.format("Please pass a handler function to %s!", "Promise.each"));

    return u43._new(debug.traceback(nil, 2), function(p127, p128, p129) -- Line: 877
        -- upvalues: u121 (copy), u43 (ref), u10 (ref), u122 (copy)
        local v130 = {};
        local u131 = {};
        local u132 = false;

        local function _() -- Line: 883
            -- upvalues: u131 (copy)
            for _, v in ipairs(u131) do
                v:cancel();
            end;
        end;

        p129(function() -- Line: 889
            -- upvalues: u132 (ref), u131 (copy)
            u132 = true;

            for _, v in ipairs(u131) do
                v:cancel();
            end;
        end);
        local v133 = {};

        for i, v in ipairs(u121) do
            if u43.is(v) then
                if v:getStatus() == u43.Status.Cancelled then
                    for _, v2 in ipairs(u131) do
                        v2:cancel();
                    end;

                    return p128(u10.new({
                        error = "Promise is cancelled",
                        kind = u10.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
                    }));
                end;

                if v:getStatus() == u43.Status.Rejected then
                    for _, v2 in ipairs(u131) do
                        v2:cancel();
                    end;

                    return p128(select(2, v:await()));
                end;

                local v134 = v:andThen(function(...) -- Line: 922
                    return ...;
                end);
                table.insert(u131, v134);
                v133[i] = v134;
            else
                v133[i] = v;
            end;
        end;

        for i, v in ipairs(v133) do
            local v135;

            if u43.is(v) then
                local v136;
                v136, v135 = v:await();

                if not v136 then
                    for _, v2 in ipairs(u131) do
                        v2:cancel();
                    end;

                    return p128(v135);
                end;
            else
                v135 = v;
            end;

            if u132 then
                return;
            end;

            local v137 = u43.resolve(u122(v135, i));
            table.insert(u131, v137);
            local v138, v139 = v137:await();

            if not v138 then
                for _, v2 in ipairs(u131) do
                    v2:cancel();
                end;

                return p128(v139);
            end;

            v130[i] = v139;
        end;

        p127(v130);
    end);
end;

function u43.is(p140) -- Line: 973
    -- upvalues: u43 (copy)
    if type(p140) ~= "table" then
        return false;
    end;

    local v141 = getmetatable(p140);

    if v141 == u43 then
        return true;
    end;

    if v141 ~= nil then
        if type(v141) == "table" then
            local v142 = rawget(v141, "__index");

            if type(v142) == "table" then
                local v143 = rawget(v141, "__index");
                local v144 = rawget(v143, "andThen");
                local v145;

                if type(v144) == "function" then
                    v145 = true;
                else
                    local v146 = type(v144) == "table" and getmetatable(v144);

                    if v146 then
                        local v147 = rawget(v146, "__call");
                        v145 = type(v147) == "function";
                    else
                        v145 = false;
                    end;
                end;

                if v145 then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    local andThen = p140.andThen;

    if type(andThen) == "function" then
        return true;
    end;

    local v148 = type(andThen) == "table" and getmetatable(andThen);

    if v148 then
        local v149 = rawget(v148, "__call");

        if type(v149) == "function" then
            return true;
        end;
    end;

    return false;
end;

function u43.promisify(u150) -- Line: 1022
    -- upvalues: u43 (copy)
    return function(...) -- Line: 1023
        -- upvalues: u43 (ref), u150 (copy)
        return u43._try(debug.traceback(nil, 2), u150, ...);
    end;
end;

local u151 = nil;
local u152 = nil;

function u43.delay(p153) -- Line: 1053
    -- upvalues: u43 (copy), u152 (ref), u151 (ref)
    local v154 = type(p153) == "number";
    assert(v154, "Bad argument #1 to Promise.delay, must be a number.");
    local u155 = (p153 < 0.016666666666666666 or p153 == (1 / 0)) and 0.016666666666666666 or p153;

    return u43._new(debug.traceback(nil, 2), function(p156, p157, p158) -- Line: 1061
        -- upvalues: u43 (ref), u155 (ref), u152 (ref), u151 (ref)
        local v159 = u43._getTime();
        local v160 = v159 + u155;
        local u161 = {
            resolve = p156,
            startTime = v159,
            endTime = v160
        };

        if u152 == nil then
            u151 = u161;
            u152 = u43._timeEvent:Connect(function() -- Line: 1073
                -- upvalues: u43 (ref), u151 (ref), u152 (ref)
                local v162 = u43._getTime();

                while u151 ~= nil and u151.endTime < v162 do
                    local v163 = u151;
                    u151 = v163.next;

                    if u151 == nil then
                        u152:Disconnect();
                        u152 = nil;
                    else
                        u151.previous = nil;
                    end;

                    v163.resolve(u43._getTime() - v163.startTime);
                end;
            end);
        elseif u151.endTime < v160 then
            local v164 = u151;
            local next2 = v164.next;

            while next2 ~= nil and next2.endTime < v160 do
                v164 = next2;
                next2 = next2.next;
            end;

            v164.next = u161;
            u161.previous = v164;

            if next2 ~= nil then
                u161.next = next2;
                next2.previous = u161;
            end;
        else
            u161.next = u151;
            u151.previous = u161;
            u151 = u161;
        end;

        p158(function() -- Line: 1118
            -- upvalues: u161 (copy), u151 (ref), u152 (ref)
            local next2 = u161.next;

            if u151 == u161 then
                if next2 == nil then
                    u152:Disconnect();
                    u152 = nil;
                else
                    next2.previous = nil;
                end;

                u151 = next2;

                return;
            end;

            local previous = u161.previous;
            previous.next = next2;

            if next2 ~= nil then
                next2.previous = previous;
            end;
        end);
    end);
end;

function u43.prototype.timeout(p165, u166, u167) -- Line: 1182
    -- upvalues: u43 (copy), u10 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    return u43.race({ u43.delay(u166):andThen(function() -- Line: 1186
            -- upvalues: u43 (ref), u167 (copy), u10 (ref), u166 (copy), debug_traceback_ret (copy)
            return u43.reject(u167 == nil and u10.new({
                error = "Timed out",
                kind = u10.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", u166, debug_traceback_ret)
            }) or u167);
        end), p165 });
end;

function u43.prototype.getStatus(p168) -- Line: 1206
    return p168._status;
end;

function u43.prototype._andThen(u169, u170, u171, u172) -- Line: 1215
    -- upvalues: u43 (copy), runExecutor (copy)
    u169._unhandledRejection = false;

    if u169._status ~= u43.Status.Cancelled then
        return u43._new(u170, function(u173, u174, p175) -- Line: 1227
            -- upvalues: u171 (copy), u170 (copy), runExecutor (ref), u172 (copy), u169 (copy), u43 (ref)
            local u176;

            if u171 then
                local u177 = u170;
                local u178 = u171;

                u176 = function(...) -- Line: 180
                    -- upvalues: runExecutor (ref), u177 (copy), u178 (copy), u173 (copy), u174 (copy)
                    local v179, v180, v181 = runExecutor(u177, u178, ...);

                    if v179 then
                        u173(unpack(v181, 1, v180));

                        return;
                    end;

                    u174(v181[1]);
                end;
            else
                u176 = u173;
            end;

            if u172 then
                local u182 = u170;
                local u183 = u172;

                u174 = function(...) -- Line: 180
                    -- upvalues: runExecutor (ref), u182 (copy), u183 (copy), u173 (copy), u174 (copy)
                    local v184, v185, v186 = runExecutor(u182, u183, ...);

                    if v184 then
                        u173(unpack(v186, 1, v185));

                        return;
                    end;

                    u174(v186[1]);
                end;
            end;

            if u169._status == u43.Status.Started then
                table.insert(u169._queuedResolve, u176);
                table.insert(u169._queuedReject, u174);
                p175(function() -- Line: 1246
                    -- upvalues: u169 (ref), u43 (ref), u176 (ref), u174 (ref)
                    if u169._status == u43.Status.Started then
                        table.remove(u169._queuedResolve, table.find(u169._queuedResolve, u176));
                        table.remove(u169._queuedReject, table.find(u169._queuedReject, u174));
                    end;
                end);
            elseif u169._status == u43.Status.Resolved then
                u176(unpack(u169._values, 1, u169._valuesLength));
            elseif u169._status == u43.Status.Rejected then
                u174(unpack(u169._values, 1, u169._valuesLength));
            end;
        end, u169);
    end;

    local v187 = u43.new(function() -- Line: 1220
    end);
    v187:cancel();

    return v187;
end;

function u43.prototype.andThen(p188, p189, p190) -- Line: 1285
    local v191;

    if p189 == nil or type(p189) == "function" then
        v191 = true;
    elseif type(p189) == "table" then
        local v192 = getmetatable(p189);

        if v192 then
            local v193 = rawget(v192, "__call");
            v191 = type(v193) == "function";
        else
            v191 = false;
        end;
    else
        v191 = false;
    end;

    assert(v191, string.format("Please pass a handler function to %s!", "Promise:andThen"));
    local v194;

    if p190 == nil or type(p190) == "function" then
        v194 = true;
    elseif type(p190) == "table" then
        local v195 = getmetatable(p190);

        if v195 then
            local v196 = rawget(v195, "__call");
            v194 = type(v196) == "function";
        else
            v194 = false;
        end;
    else
        v194 = false;
    end;

    assert(v194, string.format("Please pass a handler function to %s!", "Promise:andThen"));

    return p188:_andThen(debug.traceback(nil, 2), p189, p190);
end;

function u43.prototype.catch(p197, p198) -- Line: 1312
    local v199;

    if p198 == nil or type(p198) == "function" then
        v199 = true;
    elseif type(p198) == "table" then
        local v200 = getmetatable(p198);

        if v200 then
            local v201 = rawget(v200, "__call");
            v199 = type(v201) == "function";
        else
            v199 = false;
        end;
    else
        v199 = false;
    end;

    assert(v199, string.format("Please pass a handler function to %s!", "Promise:catch"));

    return p197:_andThen(debug.traceback(nil, 2), nil, p198);
end;

function u43.prototype.tap(p202, u203) -- Line: 1333
    -- upvalues: u43 (copy), pack (copy)
    local v204;

    if type(u203) == "function" then
        v204 = true;
    elseif type(u203) == "table" then
        local v205 = getmetatable(u203);

        if v205 then
            local v206 = rawget(v205, "__call");
            v204 = type(v206) == "function";
        else
            v204 = false;
        end;
    else
        v204 = false;
    end;

    assert(v204, string.format("Please pass a handler function to %s!", "Promise:tap"));

    return p202:_andThen(debug.traceback(nil, 2), function(...) -- Line: 1335
        -- upvalues: u203 (copy), u43 (ref), pack (ref)
        local v207 = u203(...);

        if not u43.is(v207) then
            return ...;
        end;

        local u208, u209 = pack(...);

        return v207:andThen(function() -- Line: 1340
            -- upvalues: u209 (copy), u208 (copy)
            return unpack(u209, 1, u208);
        end);
    end);
end;

function u43.prototype.andThenCall(p210, u211, ...) -- Line: 1368
    -- upvalues: pack (copy)
    local v212;

    if type(u211) == "function" then
        v212 = true;
    elseif type(u211) == "table" then
        local v213 = getmetatable(u211);

        if v213 then
            local v214 = rawget(v213, "__call");
            v212 = type(v214) == "function";
        else
            v212 = false;
        end;
    else
        v212 = false;
    end;

    assert(v212, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
    local u215, u216 = pack(...);

    return p210:_andThen(debug.traceback(nil, 2), function() -- Line: 1371
        -- upvalues: u211 (copy), u216 (copy), u215 (copy)
        return u211(unpack(u216, 1, u215));
    end);
end;

function u43.prototype.andThenReturn(p217, ...) -- Line: 1398
    -- upvalues: pack (copy)
    local u218, u219 = pack(...);

    return p217:_andThen(debug.traceback(nil, 2), function() -- Line: 1400
        -- upvalues: u219 (copy), u218 (copy)
        return unpack(u219, 1, u218);
    end);
end;

function u43.prototype.cancel(p220) -- Line: 1416
    -- upvalues: u43 (copy)
    if p220._status ~= u43.Status.Started then
        return;
    end;

    p220._status = u43.Status.Cancelled;

    if p220._cancellationHook then
        p220._cancellationHook();
    end;

    coroutine.close(p220._thread);

    if p220._parent then
        p220._parent:_consumerCancelled(p220);
    end;

    for i in pairs(p220._consumers) do
        i:cancel();
    end;

    p220:_finalize();
end;

function u43.prototype._consumerCancelled(p221, p222) -- Line: 1444
    -- upvalues: u43 (copy)
    if p221._status ~= u43.Status.Started then
        return;
    end;

    p221._consumers[p222] = nil;

    if next(p221._consumers) == nil then
        p221:cancel();
    end;
end;

function u43.prototype._finally(u223, p224, u225) -- Line: 1460
    -- upvalues: u43 (copy)
    u223._unhandledRejection = false;

    return u43._new(p224, function(u226, u227, p228) -- Line: 1463
        -- upvalues: u223 (copy), u225 (copy), u43 (ref)
        local u229 = nil;
        p228(function() -- Line: 1466
            -- upvalues: u223 (ref), u229 (ref)
            u223:_consumerCancelled(u223);

            if u229 then
                u229:cancel();
            end;
        end);
        local v232 = u225 and function(...) -- Line: 1479
            -- upvalues: u225 (ref), u43 (ref), u229 (ref), u226 (copy), u223 (ref), u227 (copy)
            local v230 = u225(...);

            if not u43.is(v230) then
                u226(u223);

                return;
            end;

            u229 = v230;
            v230:finally(function(p231) -- Line: 1486
                -- upvalues: u43 (ref), u226 (ref), u223 (ref)
                if p231 ~= u43.Status.Rejected then
                    u226(u223);
                end;
            end):catch(function(...) -- Line: 1491
                -- upvalues: u227 (ref)
                u227(...);
            end);
        end or u226;

        if u223._status == u43.Status.Started then
            table.insert(u223._queuedFinally, v232);
        else
            v232(u223._status);
        end;
    end);
end;

function u43.prototype.finally(p233, p234) -- Line: 1561
    local v235;

    if p234 == nil or type(p234) == "function" then
        v235 = true;
    elseif type(p234) == "table" then
        local v236 = getmetatable(p234);

        if v236 then
            local v237 = rawget(v236, "__call");
            v235 = type(v237) == "function";
        else
            v235 = false;
        end;
    else
        v235 = false;
    end;

    assert(v235, string.format("Please pass a handler function to %s!", "Promise:finally"));

    return p233:_finally(debug.traceback(nil, 2), p234);
end;

function u43.prototype.finallyCall(p238, u239, ...) -- Line: 1575
    -- upvalues: pack (copy)
    local v240;

    if type(u239) == "function" then
        v240 = true;
    elseif type(u239) == "table" then
        local v241 = getmetatable(u239);

        if v241 then
            local v242 = rawget(v241, "__call");
            v240 = type(v242) == "function";
        else
            v240 = false;
        end;
    else
        v240 = false;
    end;

    assert(v240, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
    local u243, u244 = pack(...);

    return p238:_finally(debug.traceback(nil, 2), function() -- Line: 1578
        -- upvalues: u239 (copy), u244 (copy), u243 (copy)
        return u239(unpack(u244, 1, u243));
    end);
end;

function u43.prototype.finallyReturn(p245, ...) -- Line: 1601
    -- upvalues: pack (copy)
    local u246, u247 = pack(...);

    return p245:_finally(debug.traceback(nil, 2), function() -- Line: 1603
        -- upvalues: u247 (copy), u246 (copy)
        return unpack(u247, 1, u246);
    end);
end;

function u43.prototype.awaitStatus(p248) -- Line: 1615
    -- upvalues: u43 (copy)
    p248._unhandledRejection = false;

    if p248._status == u43.Status.Started then
        local coroutine_running_ret = coroutine.running();
        p248:finally(function() -- Line: 1622
            -- upvalues: coroutine_running_ret (copy)
            task.spawn(coroutine_running_ret);
        end):catch(function() -- Line: 1628
        end);
        coroutine.yield();
    end;

    if p248._status == u43.Status.Resolved then
        return p248._status, unpack(p248._values, 1, p248._valuesLength);
    end;

    if p248._status == u43.Status.Rejected then
        return p248._status, unpack(p248._values, 1, p248._valuesLength);
    end;

    return p248._status;
end;

local function awaitHelper(p249, ...) -- Line: 1643
    -- upvalues: u43 (copy)
    return p249 == u43.Status.Resolved, ...;
end;

function u43.prototype.await(p250) -- Line: 1668
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p250:awaitStatus());
end;

local function expectHelper(p251, ...) -- Line: 1672
    -- upvalues: u43 (copy)
    if p251 ~= u43.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3);
    end;

    return ...;
end;

function u43.prototype.expect(p252) -- Line: 1705
    -- upvalues: expectHelper (copy)
    return expectHelper(p252:awaitStatus());
end;

u43.prototype.awaitValue = u43.prototype.expect;

function u43.prototype._unwrap(p253) -- Line: 1719
    -- upvalues: u43 (copy)
    if p253._status == u43.Status.Started then
        error("Promise has not resolved or rejected.", 2);
    end;

    return p253._status == u43.Status.Resolved, unpack(p253._values, 1, p253._valuesLength);
end;

function u43.prototype._resolve(u254, ...) -- Line: 1729
    -- upvalues: u43 (copy), u10 (ref), pack (copy)
    if u254._status ~= u43.Status.Started then
        if u43.is((...)) then
            (...):_consumerCancelled(u254);
        end;

        return;
    end;

    if u43.is((...)) then
        if select("#", ...) > 1 then
            local string_format_ret = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", u254._source);
            warn(string_format_ret);
        end;

        local u255 = ...;
        local v257 = u255:andThen(function(...) -- Line: 1750
            -- upvalues: u254 (copy)
            u254:_resolve(...);
        end, function(...) -- Line: 1752
            -- upvalues: u255 (copy), u10 (ref), u254 (copy)
            local v256 = u255._values[1];

            if u255._error then
                v256 = u10.new({
                    context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    error = u255._error,
                    kind = u10.Kind.ExecutionError
                });
            end;

            if u10.isKind(v256, u10.Kind.ExecutionError) then
                return u254:_reject(v256:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", u254._source)
                }));
            end;

            u254:_reject(...);
        end);

        if v257._status == u43.Status.Cancelled then
            u254:cancel();

            return;
        end;

        if v257._status == u43.Status.Started then
            u254._parent = v257;
            v257._consumers[u254] = true;
        end;

        return;
    end;

    u254._status = u43.Status.Resolved;
    local v258, v259 = pack(...);
    u254._valuesLength = v258;
    u254._values = v259;

    for _, v in ipairs(u254._queuedResolve) do
        coroutine.wrap(v)(...);
    end;

    u254:_finalize();
end;

function u43.prototype._reject(u260, ...) -- Line: 1801
    -- upvalues: u43 (copy), pack (copy)
    if u260._status ~= u43.Status.Started then
        return;
    end;

    u260._status = u43.Status.Rejected;
    local v261, v262 = pack(...);
    u260._valuesLength = v261;
    u260._values = v262;

    if next(u260._queuedReject) == nil then
        local u263 = tostring((...));
        coroutine.wrap(function() -- Line: 1823
            -- upvalues: u43 (ref), u260 (copy), u263 (copy)
            u43._timeEvent:Wait();

            if not u260._unhandledRejection then
                return;
            end;

            local string_format_ret = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u263, u260._source);

            for _, v in ipairs(u43._unhandledRejectionCallbacks) do
                task.spawn(v, u260, unpack(u260._values, 1, u260._valuesLength));
            end;

            if u43.TEST then
                return;
            end;

            warn(string_format_ret);
        end)();
    else
        for _, v in ipairs(u260._queuedReject) do
            coroutine.wrap(v)(...);
        end;
    end;

    u260:_finalize();
end;

function u43.prototype._finalize(p264) -- Line: 1855
    -- upvalues: u43 (copy)
    for _, v in ipairs(p264._queuedFinally) do
        coroutine.wrap(v)(p264._status);
    end;

    p264._queuedFinally = nil;
    p264._queuedReject = nil;
    p264._queuedResolve = nil;

    if not u43.TEST then
        p264._parent = nil;
        p264._consumers = nil;
    end;

    task.defer(coroutine.close, p264._thread);
end;

function u43.prototype.now(p265, p266) -- Line: 1892
    -- upvalues: u43 (copy), u10 (ref)
    local debug_traceback_ret = debug.traceback(nil, 2);

    if p265._status == u43.Status.Resolved then
        return p265:_andThen(debug_traceback_ret, function(...) -- Line: 1895
            return ...;
        end);
    end;

    local reject = u43.reject;

    if p266 == nil then
        p266 = u10.new({
            error = "This Promise was not resolved in time for :now()",
            kind = u10.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. debug_traceback_ret
        }) or p266;
    end;

    return reject(p266);
end;

function u43.retry(u267, u268, ...) -- Line: 1937
    -- upvalues: u43 (copy)
    local v269;

    if type(u267) == "function" then
        v269 = true;
    elseif type(u267) == "table" then
        local v270 = getmetatable(u267);

        if v270 then
            local v271 = rawget(v270, "__call");
            v269 = type(v271) == "function";
        else
            v269 = false;
        end;
    else
        v269 = false;
    end;

    assert(v269, "Parameter #1 to Promise.retry must be a function");
    local v272 = type(u268) == "number";
    assert(v272, "Parameter #2 to Promise.retry must be a number");
    local u273 = { ... };
    local u274 = select("#", ...);

    return u43.resolve(u267(...)):catch(function(...) -- Line: 1943
        -- upvalues: u268 (copy), u43 (ref), u267 (copy), u273 (copy), u274 (copy)
        if u268 > 0 then
            return u43.retry(u267, u268 - 1, unpack(u273, 1, u274));
        end;

        return u43.reject(...);
    end);
end;

function u43.retryWithDelay(u275, u276, u277, ...) -- Line: 1965
    -- upvalues: u43 (copy)
    local v278;

    if type(u275) == "function" then
        v278 = true;
    elseif type(u275) == "table" then
        local v279 = getmetatable(u275);

        if v279 then
            local v280 = rawget(v279, "__call");
            v278 = type(v280) == "function";
        else
            v278 = false;
        end;
    else
        v278 = false;
    end;

    assert(v278, "Parameter #1 to Promise.retry must be a function");
    local v281 = type(u276) == "number";
    assert(v281, "Parameter #2 (times) to Promise.retry must be a number");
    local v282 = type(u277) == "number";
    assert(v282, "Parameter #3 (seconds) to Promise.retry must be a number");
    local u283 = { ... };
    local u284 = select("#", ...);

    return u43.resolve(u275(...)):catch(function(...) -- Line: 1972
        -- upvalues: u276 (copy), u43 (ref), u277 (copy), u275 (copy), u283 (copy), u284 (copy)
        if u276 <= 0 then
            return u43.reject(...);
        end;

        u43.delay(u277):await();

        return u43.retryWithDelay(u275, u276 - 1, u277, unpack(u283, 1, u284));
    end);
end;

function u43.fromEvent(u285, p286) -- Line: 2007
    -- upvalues: u43 (copy)
    local u287 = p286 or function() -- Line: 2008
        return true;
    end;

    return u43._new(debug.traceback(nil, 2), function(u288, p289, p290) -- Line: 2012
        -- upvalues: u285 (copy), u287 (ref)
        local u291 = nil;
        local u292 = false;

        local function disconnect() -- Line: 2016
            -- upvalues: u291 (ref)
            u291:Disconnect();
            u291 = nil;
        end;

        u291 = u285:Connect(function(...) -- Line: 2025
            -- upvalues: u287 (ref), u288 (copy), u291 (ref), u292 (ref)
            local v293 = u287(...);

            if v293 ~= true then
                if type(v293) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean");
                end;

                return;
            end;

            u288(...);

            if not u291 then
                u292 = true;

                return;
            end;

            u291:Disconnect();
            u291 = nil;
        end);

        if u292 and u291 then
            return disconnect();
        end;

        p290(disconnect);
    end);
end;

function u43.onUnhandledRejection(u294) -- Line: 2060
    -- upvalues: u43 (copy)
    table.insert(u43._unhandledRejectionCallbacks, u294);

    return function() -- Line: 2063
        -- upvalues: u43 (ref), u294 (copy)
        local table_find_ret = table.find(u43._unhandledRejectionCallbacks, u294);

        if table_find_ret then
            table.remove(u43._unhandledRejectionCallbacks, table_find_ret);
        end;
    end;
end;

return u43;