-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = (1 / 0);
local u4 = nil;
local u5 = (1 / 0);
local u6 = nil;
local u7 = false;

function u1.mark(p8: string) -- Line: 14
    debug.profilebegin(p8);
    debug.profileend();
end;

local function returnProtectedResults(p9: boolean, ...) -- Line: 19
    if not p9 then
        error(select(1, ...), 3);
    end;

    return ...;
end;

function u1.scope(p10: string, p11: function, ...) -- Line: 26
    -- upvalues: u1 (copy), returnProtectedResults (copy)
    u1.mark(p10);

    return returnProtectedResults(pcall(p11, ...));
end;

function u1.setSlowScopeReporter(p12: number, p13: function?) -- Line: 32
    -- upvalues: u3 (ref), u4 (ref)
    u3 = math.max(0, p12);
    u4 = p13;
end;

function u1.setTimedScopeObserver(p14: number, p15: function?) -- Line: 38
    -- upvalues: u5 (ref), u6 (ref), u7 (ref)
    u5 = math.max(0, p14);
    u6 = p15;
    u7 = false;
end;

function u1.timedScope(u16: string, p17: function, ...) -- Line: 45
    -- upvalues: u6 (ref), u4 (ref), u1 (copy), u5 (ref), u7 (ref), u3 (ref)
    if u6 == nil and u4 == nil then
        return u1.scope(u16, p17, ...);
    end;

    local os_clock_ret = os.clock();
    local table_pack_ret = table.pack(u1.scope(u16, p17, ...));
    local os_clock_ret2 = os.clock();
    local u18 = os_clock_ret2 - os_clock_ret;
    local v19 = u6;

    if v19 ~= nil and u5 <= u18 then
        local success, result = pcall(v19, u16, u18, os_clock_ret, os_clock_ret2);

        if not (success or u7) then
            u7 = true;
            warn((`[Profiler] timed-scope observer failed: {tostring(result)}`));
        end;
    end;

    local u20 = u4;

    if u20 ~= nil and u3 <= u18 then
        task.defer(function() -- Line: 63
            -- upvalues: u20 (copy), u16 (copy), u18 (copy)
            local success, result = pcall(u20, u16, u18);

            if not success then
                warn((`[Profiler] slow-scope reporter failed: {tostring(result)}`));
            end;
        end);
    end;

    return table.unpack(table_pack_ret, 1, table_pack_ret.n);
end;

function u1.wrapTimed(u21: string, u22: function) -- Line: 73
    -- upvalues: u1 (copy)
    return function(...) -- Line: 74
        -- upvalues: u1 (ref), u21 (copy), u22 (copy)
        return u1.timedScope(u21, u22, ...);
    end;
end;

function u1.getInstancePath(p23: userdata, p24: userdata?) -- Line: 79
    local v25 = {};

    while p23 and p23 ~= p24 do
        table.insert(v25, 1, p23.Name);
        p23 = p23.Parent;
    end;

    return table.concat(v25, ".");
end;

function u1.getCallbackLabel(p26: string, p27: function) -- Line: 91
    -- upvalues: u2 (copy)
    local v28 = u2[p27];

    if not v28 then
        v28 = {};
        u2[p27] = v28;
    end;

    local v29 = v28[p26];

    if v29 then
        return v29;
    end;

    local debug_info_ret = debug.info(p27, "s");
    local v30 = `{p26}.{(not debug_info_ret or debug_info_ret == "") and "Unknown" or string.gsub(debug_info_ret, "^@", "")}`;
    v28[p26] = v30;

    return v30;
end;

function u1.defer(u31: string, u32: function, ...) -- Line: 115
    -- upvalues: u1 (copy)
    local table_pack_ret = table.pack(...);
    task.defer(function() -- Line: 117
        -- upvalues: u31 (copy), u1 (ref), u32 (copy), table_pack_ret (copy)
        debug.setmemorycategory(u31);
        u1.mark(u31);
        u32(table.unpack(table_pack_ret, 1, table_pack_ret.n));
    end);
end;

function u1.spawn(u33: string, u34: function, ...) -- Line: 124
    -- upvalues: u1 (copy)
    local table_pack_ret = table.pack(...);
    task.spawn(function() -- Line: 126
        -- upvalues: u33 (copy), u1 (ref), u34 (copy), table_pack_ret (copy)
        debug.setmemorycategory(u33);
        u1.mark(u33);
        u34(table.unpack(table_pack_ret, 1, table_pack_ret.n));
    end);
end;

return u1;