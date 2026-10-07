-- ReplicatedStorage.Shared.Zone.Enum
-- Script path: ReplicatedStorage.Shared.Zone.Enum
-- Decompile time: 1.45 ms

local v1
local v2 = {}
local u1 = {}
v2.enums = u1

function v2.createEnum(a1, a2) -- Line: 20 -- upvalues: u1 (val)
    local v1, v2, v3, v4, v5, v6, v7
    assert(typeof(a1) == "string", "bad argument #1 - enums must be created using a string name!")
    assert(typeof(a2) == "table", "bad argument #2 - enums must be created using a table!")
    assert(not u1[a1], (("enum '%s' already exists!"):format(a1)))
    local v8 = {}
    local u176 = {}
    local u177 = {}
    local u178 = {}
    local u169 = {}

    function u169.getName(a1) -- Line: 30 -- upvalues: u177 (val), u178 (val), a2 (val)
        local v1 = tostring(a1)
        local v2 = u177[v1] or u178[v1]
        if v2 then
            return a2[v2][1]
        end
    end

    function u169.getValue(a1) -- Line: 40 -- upvalues: u176 (val), u178 (val), a2 (val)
        local v1 = tostring(a1)
        local v2 = u176[v1] or u178[v1]
        if v2 then
            return a2[v2][2]
        end
    end

    function u169.getProperty(a1) -- Line: 50 -- upvalues: u176 (val), u177 (val), a2 (val)
        local v1 = tostring(a1)
        local v2 = u176[v1] or u177[v1]
        if v2 then
            return a2[v2][3]
        end
    end

    for k, v in pairs(a2) do
        v3 = ("bad argument #2.%s - details must only be comprised of tables!"):format(k)
        assert(typeof(v) == "table", v3)
        v1 = v[1]
        v4 = ("bad argument #2.%s.1 - detail name must be a string!"):format(k)
        assert(typeof(v1) == "string", v4)
        assert(typeof(not u176[v1]), (("bad argument #2.%s.1 - the detail name '%s' already exists!"):format(k, v1)))
        assert(typeof(not u169[v1]), (("bad argument #2.%s.1 - that name is reserved."):format(k, v1)))
        u176[tostring(v1)] = k
        v2 = v[2]
        v3 = tostring(v2)
        assert(typeof(not u177[v3]), (("bad argument #2.%s.2 - the detail value '%s' already exists!"):format(k, v3)))
        u177[v3] = k
        v4 = v[3]
        if v4 then
            v5 = typeof(not u178[v4])
            v7 = tostring(v4)
            assert(v5, (("bad argument #2.%s.3 - the detail property '%s' already exists!"):format(k, v7)))
            u178[tostring(v4)] = k
        end
        v8[v1] = v2
        v6 = {
            __index = function(a1, a2) -- Line: 80 -- upvalues: u169 (val)
                return u169[a2]
            end,
        }
        setmetatable(v8, v6)
    end
    u1[a1] = v8
    return v8
end

function v2.getEnums() -- Line: 90 -- upvalues: u1 (val)
    return u1
end

local createEnum = v2.createEnum
for k, v in pairs(script:GetChildren()) do
    if v:IsA("ModuleScript") then
        v1 = require(v)
        createEnum(v.Name, v1)
    end
end
return v2