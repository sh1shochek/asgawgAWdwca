-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.zipAll
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.zipAll
-- Decompile time: 0.47 ms

local Parent_2 = script.Parent.Parent
local reduce = require(script.Parent.reduce)
local None = require(Parent_2.None)
return function(...) -- Line: 24 -- upvalues: reduce (val), None (val)
    local v1, v2
    local v3 = select("#", ...)
    local v4 = {...}
    local v5 = {}
    if v3 == 0 then
        return v5
    end
    for i = 1, (reduce(v4, function(a1, a2) -- Line: 33
        local v4
        return (math.max(a1, #a2))
    end, #v4[1])) do
        v2 = {}
        for i2, v in ipairs(v4) do
            v1 = v[i]
            table.insert(v2, if v1 ~= nil then v1 else None)
        end
        table.insert(v5, v2)
    end
    return v5
end