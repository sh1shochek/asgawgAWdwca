-- ReplicatedStorage.Packages._Index.sleitnick_table-util@1.2.1.table-util
-- Script path: ReplicatedStorage.Packages._Index.sleitnick_table-util@1.2.1.table-util
-- Decompile time: 5.41 ms

local Reconcile, Sync
local v1 = {}
local HttpService = game:GetService("HttpService")
local u7 = Random.new()

function Sync(a1, a2) -- Line: 84 -- upvalues: Sync (val)
    local v1
    assert(type(a1) == "table", "First argument must be a table")
    assert(type(a2) == "table", "Second argument must be a table")
    local v2 = table.clone(a1)
    for k, v in pairs(v2) do
        v1 = a2[k]
        if v1 == nil then
            v2[k] = nil
        elseif (type(v)) == type(v1) then
            if type(v) == "table" then
                v2[k] = (Sync(v, v1))
            end
        elseif type(v1) ~= "table" then
            v2[k] = v1
        else
            local function DeepCopy_2(a1) -- Line: 44 -- upvalues: DeepCopy_2 (val) -- types: a1: table
                local v1 = table.clone(a1)
                for i, j in v1 do
                    if type(j) == "table" then
                        v1[i] = (DeepCopy_2(j))
                    end
                end
                return v1
            end

            v2[k] = (DeepCopy_2(v1))
        end
    end
    for k2, i in pairs(a2) do
        if v2[k2] == nil then
            if type(i) ~= "table" then
                v2[k2] = i
            else
                local function DeepCopy(a1) -- Line: 44 -- upvalues: DeepCopy (val) -- types: a1: table
                    local v1 = table.clone(a1)
                    for i, j in v1 do
                        if type(j) == "table" then
                            v1[i] = (DeepCopy(j))
                        end
                    end
                    return v1
                end

                v2[k2] = (DeepCopy(i))
            end
        end
    end
    return v2
end

function Reconcile(a1, a2) -- Line: 156 -- upvalues: Reconcile (val)
    local v1
    assert(type(a1) == "table", "First argument must be a table")
    assert(type(a2) == "table", "Second argument must be a table")
    local v2 = table.clone(a1)
    for i, j in a2 do
        v1 = a1[i]
        if v1 ~= nil then
            if type(v1) == "table" then
                if type(j) ~= "table" then
                    local function DeepCopy_2(a1) -- Line: 44 -- upvalues: DeepCopy_2 (val) -- types: a1: table
                        local v1 = table.clone(a1)
                        for i, j in v1 do
                            if type(j) == "table" then
                                v1[i] = (DeepCopy_2(j))
                            end
                        end
                        return v1
                    end

                    v2[i] = (DeepCopy_2(v1))
                else
                    v2[i] = (Reconcile(v1, j))
                end
            end
        elseif type(j) ~= "table" then
            v2[i] = j
        else
            local function DeepCopy(a1) -- Line: 44 -- upvalues: DeepCopy (val) -- types: a1: table
                local v1 = table.clone(a1)
                for i, j in v1 do
                    if type(j) == "table" then
                        v1[i] = (DeepCopy(j))
                    end
                end
                return v1
            end

            v2[i] = (DeepCopy(j))
        end
    end
    return v2
end

local function Map(a1, a2) -- Line: 262 -- types: a1: table, a2: function
    assert(type(a1) == "table", "First argument must be a table")
    assert(type(a2) == "function", "Second argument must be a function")
    local v1 = table.create(#a1)
    for i, j in a1 do
        v1[i] = (a2(j, i, a1))
    end
    return v1
end

function v1.Copy(a1, a2) -- Line: 40 -- types: a2: boolean?
    local DeepCopy
    if not a2 then
        return (table.clone(a1))
    end

    function DeepCopy(a1) -- Line: 44 -- upvalues: DeepCopy (val) -- types: a1: table
        local v1 = table.clone(a1)
        for i, j in v1 do
            if type(j) == "table" then
                v1[i] = (DeepCopy(j))
            end
        end
        return v1
    end

    return (DeepCopy(a1))
end

v1.Sync = Sync
v1.Reconcile = Reconcile

function v1.SwapRemove(a1, a2) -- Line: 209 -- types: a1: table, a2: number
    local v1 = #a1
    a1[a2] = a1[v1]
    a1[v1] = nil
end

function v1.SwapRemoveFirstValue(a1, a2) -- Line: 234 -- types: a1: table
    local v1 = table.find(a1, a2)
    if v1 then
        local v2 = #a1
        a1[v1] = a1[v2]
        a1[v2] = nil
    end
    return v1
end

v1.Map = Map

function v1.Filter(a1, a2) -- Line: 292 -- types: a1: table, a2: function
    assert(type(a1) == "table", "First argument must be a table")
    assert(type(a2) == "function", "Second argument must be a function")
    local v1 = table.create(#a1)
    if not (#a1 > 0) then
        for i, j in a1 do
            if a2(j, i, a1) then
                v1[i] = j
            end
        end
        return v1
    end
    local v2 = 0
    for k, n in a1 do
        if a2(n, k, a1) then
            v2 = v2 + 1
            v1[v2] = n
        end
    end
    return v1
end

function v1.Reduce(a1, a2, a3) -- Line: 335 -- types: a1: table, a2: function
    local v1
    assert(type(a1) == "table", "First argument must be a table")
    assert(type(a2) == "function", "Second argument must be a function")
    local v2 = a3
    if not (#a1 > 0) then
        v1 = nil
        if a3 == nil then
            v1 = (next(a1))
        end
        for i, j in next, a1, v1 do
            v2 = a2(v2, j, i, a1)
        end
        return v2
    end
    v1 = 1
    if a3 == nil then
        v2 = a1[1]
        v1 = 2
    end
    local v3 = #a1
    for k = v1, v3 do
        v2 = a2(v2, a1[k], k, a1)
    end
    return v2
end

function v1.Assign(a1, ...) -- Line: 378 -- types: a1: table
    local v1 = table.clone(a1)
    local v2 = {...}
    local v3 = nil
    local v4 = nil
    for i, j in v2, v3, v4 do
        for k, n in j do
            v1[k] = n
        end
    end
    return v1
end

function v1.Extend(a1, a2) -- Line: 407 -- types: a1: table, a2: table
    local v1 = table.clone(a1)
    for i, j in a2 do
        table.insert(v1, j)
    end
    return v1
end

function v1.Reverse(a1) -- Line: 432 -- types: a1: table
    local v1 = #a1
    local v2 = table.create(v1)
    for i = 1, v1 do
        v2[i] = a1[v1 - i + 1]
    end
    return v2
end

function v1.Shuffle(a1, a2) -- Line: 459 -- upvalues: u7 (val) -- types: a1: table, a2: userdata?
    local v1, v2, v3
    assert(type(a1) == "table", "First argument must be a table")
    local v4 = table.clone(a1)
    local v5 = if typeof(a2) ~= "Random" then u7 else a2
    for i = #a1, 2, -1 do
        v1 = v5:NextInteger(1, i)
        v2 = v4[v1]
        v3 = v4[i]
        v4[i] = v2
        v4[v1] = v3
    end
    return v4
end

function v1.Sample(a1, a2, a3) -- Line: 489 -- upvalues: u7 (val) -- types: a1: table, a2: number, a3: userdata?
    local v1, v2, v3
    assert(type(a1) == "table", "First argument must be a table")
    assert(type(a2) == "number", "Second argument must be a number")
    local v4 = #a1
    if v4 == 0 then
        return {}
    end
    local v5 = table.clone(a1)
    local v6 = table.create(a2)
    local v7 = if typeof(a3) ~= "Random" then u7 else a3
    local v8 = math.clamp(a2, 1, v4)
    for i = 1, v8 do
        v1 = v7:NextInteger(i, v4)
        v2 = v5[v1]
        v3 = v5[i]
        v5[i] = v2
        v5[v1] = v3
    end
    table.move(v5, 1, v8, 1, v6)
    return v6
end

function v1.Flat(a1, a2) -- Line: 537 -- types: a1: table, a2: number?
    local Scan
    local u6 = if type(a2) ~= "number" then 1 else a2
    local u10 = table.create(#a1)

    function Scan(a1, a2) -- Line: 540 -- upvalues: u6 (val), Scan (val), u10 (val) -- types: a1: table, a2: number
        local v1 = nil
        local v2 = nil
        local v3 = a2
        for i, j in a1, v1, v2 do
            if type(j) ~= "table" or not (v3 < u6) then
                table.insert(u10, j)
            else
                Scan(j, v3 + 1)
            end
        end
    end

    Scan(a1, 0)
    return u10
end

function v1.FlatMap(a1, a2) -- Line: 574 -- upvalues: Map (val) -- types: a1: table, a2: function
    local Scan
    local v1 = Map(a1, a2)
    local u9 = table.create(#v1)
    local u10 = 1

    function Scan(a1, a2) -- Line: 540 -- upvalues: u10 (val), Scan (val), u9 (val) -- types: a1: table, a2: number
        local v1 = nil
        local v2 = nil
        local v3 = a2
        for i, j in a1, v1, v2 do
            if type(j) ~= "table" or not (v3 < u10) then
                table.insert(u9, j)
            else
                Scan(j, v3 + 1)
            end
        end
    end

    Scan(v1, 0)
    return u9
end

function v1.Keys(a1) -- Line: 600 -- types: a1: table
    local v1 = table.create(#a1)
    for i in a1 do
        table.insert(v1, i)
    end
    return v1
end

function v1.Values(a1) -- Line: 630 -- types: a1: table
    local v1 = table.create(#a1)
    for i, j in a1 do
        table.insert(v1, j)
    end
    return v1
end

function v1.Find(a1, a2) -- Line: 669 -- types: a1: table, a2: function
    for i, j in a1 do
        if a2(j, i, a1) then
            return j, i
        end
    end
    return nil, nil
end

function v1.Every(a1, a2) -- Line: 698 -- types: a1: table, a2: function
    for i, j in a1 do
        if not a2(j, i, a1) then
            return false
        end
    end
    return true
end

function v1.Some(a1, a2) -- Line: 727 -- types: a1: table, a2: function
    for i, j in a1 do
        if a2(j, i, a1) then
            return true
        end
    end
    return false
end

function v1.Truncate(a1, a2) -- Line: 753 -- types: a1: table, a2: number
    local v1 = #a1
    local v2 = math.clamp(a2, 1, v1)
    if v2 == v1 then
        return (table.clone(a1))
    end
    return (table.move(a1, 1, v2, 1, table.create(v2)))
end

function v1.Zip(...) -- Line: 786
    assert(0 < (select("#", ...)), "Must supply at least 1 table")
    local v1 = {...}
    if #v1[1] > 0 then
        return function(a1, a2) -- Line: 788 -- types: a1: table, a2: number
            local v1
            local v2 = a2 + 1
            local v3 = {}
            for i, j in a1 do
                v1 = j[v2]
                if v1 == nil then
                    return nil, nil
                else
                    v3[i] = v1
                end
            end
            return v2, v3
        end, v1, 0
    end
    return function(a1, a2) -- Line: 801 -- types: a1: table
        local v1
        local v2 = {}
        for i, j in a1 do
            v1 = next(j, a2)
            if v1 == nil then
                return nil, nil
            else
                v2[i] = v1
            end
        end
        return a2, v2
    end, v1, nil
end

function v1.Lock(a1) -- Line: 839
    local Freeze

    function Freeze(a1) -- Line: 840 -- upvalues: Freeze (val) -- types: a1: table
        for k, v in pairs(a1) do
            if type(v) == "table" then
                a1[k] = (Freeze(v))
            end
        end
        return table.freeze(a1)
    end

    return Freeze(a1)
end

function v1.IsEmpty(a1) -- Line: 869 -- types: a1: table
    return next(a1) == nil
end

function v1.EncodeJSON(a1) -- Line: 881 -- upvalues: HttpService (val)
    return HttpService:JSONEncode(a1)
end

function v1.DecodeJSON(a1) -- Line: 893 -- upvalues: HttpService (val) -- types: a1: string
    return HttpService:JSONDecode(a1)
end

return v1