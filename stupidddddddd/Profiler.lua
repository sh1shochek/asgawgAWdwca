-- ReplicatedStorage.Shared.Profiler
-- Script path: ReplicatedStorage.Shared.Profiler
-- Decompile time: 1.98 ms

local u0 = {}
local u4 = setmetatable({}, {__mode = "k"})
local u5 = (1 / 0)
local u6 = nil
local u7 = (1 / 0)
local u8 = nil
local u9 = false

function u0.mark(a1) -- Line: 14 -- types: a1: string
    debug.profilebegin(a1)
    debug.profileend()
end

local function returnProtectedResults(a1, ...) -- Line: 19 -- types: a1: boolean
    if not a1 then
        error(select(1, ...), 3)
    end
    return ...
end

function u0.scope(a1, a2, ...) -- Line: 26
    -- upvalues: u0 (val), returnProtectedResults (val)
    u0.mark(a1)
    return returnProtectedResults(pcall(a2, ...))
end

function u0.setSlowScopeReporter(a1, a2) -- Line: 32 -- upvalues: u5 (ref), u6 (ref) -- types: a1: number, a2: function?
    u5 = math.max(0, a1)
    u6 = a2
end

function u0.setTimedScopeObserver(a1, a2) -- Line: 38
    -- upvalues: u7 (ref), u8 (ref), u9 (ref)
    u7 = math.max(0, a1)
    u8 = a2
    u9 = false
end

function u0.timedScope(a1, a2, ...) -- Line: 45
    -- upvalues: u8 (ref), u6 (ref), u0 (val), u7 (ref), u9 (ref), u5 (ref)
    if u8 == nil and u6 == nil then
        return u0.scope(a1, a2, ...)
    end
    local v1 = os.clock()
    local v2 = table.pack(u0.scope(a1, a2, ...))
    local v3 = os.clock()
    local u24 = v3 - v1
    local v4 = u8
    if v4 ~= nil and u7 <= u24 then
        local success, result = pcall(v4, a1, u24, v1, v3)
        if not success and not u9 then
            u9 = true
            warn((("[Profiler] timed-scope observer failed: %*"):format((tostring(result)))))
        end
    end
    local u46 = u6
    if u46 ~= nil and u5 <= u24 then
        task.defer(function() -- Line: 63 -- upvalues: u46 (val), a1 (val), u24 (val)
            local success, result = pcall(u46, a1, u24)
            if not success then
                warn((("[Profiler] slow-scope reporter failed: %*"):format((tostring(result)))))
            end
        end)
    end
    return table.unpack(v2, 1, v2.n)
end

function u0.wrapTimed(a1, a2) -- Line: 73 -- upvalues: u0 (val) -- types: a1: string, a2: function
    return function(...) -- Line: 74 -- upvalues: u0 (upval), a1 (val), a2 (val)
        return u0.timedScope(a1, a2, ...)
    end
end

function u0.getInstancePath(a1, a2) -- Line: 79 -- types: a1: userdata, a2: userdata?
    local v1 = {}
    local Parent = a1
    while Parent do
        if Parent == a2 then
            break
        end
        table.insert(v1, 1, Parent.Name)
        Parent = Parent.Parent
    end
    return table.concat(v1, ".")
end

function u0.getCallbackLabel(a1, a2) -- Line: 91 -- upvalues: u4 (val) -- types: a1: string, a2: function
    local v1 = u4[a2]
    if not v1 then
        u4[a2] = {}
    end
    local v2 = v1[a1]
    if v2 then
        return v2
    end
    local v3 = debug.info(a2, "s")
    v3 = if not v3 then "Unknown" else if v3 ~= "" then string.gsub(v3, "^@", "") else "Unknown"
    local v4 = ("%*.%*"):format(a1, v3)
    v1[a1] = v4
    return v4
end

function u0.defer(a1, a2, ...) -- Line: 115 -- upvalues: u0 (val) -- types: a1: string, a2: function
    local u4 = table.pack(...)
    task.defer(function() -- Line: 117 -- upvalues: a1 (val), u0 (upval), a2 (val), u4 (val)
        debug.setmemorycategory(a1)
        u0.mark(a1)
        a2(table.unpack(u4, 1, u4.n))
    end)
end

function u0.spawn(a1, a2, ...) -- Line: 124 -- upvalues: u0 (val) -- types: a1: string, a2: function
    local u4 = table.pack(...)
    task.spawn(function() -- Line: 126 -- upvalues: a1 (val), u0 (upval), a2 (val), u4 (val)
        debug.setmemorycategory(a1)
        u0.mark(a1)
        a2(table.unpack(u4, 1, u4.n))
    end)
end

return u0