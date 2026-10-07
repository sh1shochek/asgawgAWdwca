-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.zip
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.zip
-- Decompile time: 0.38 ms

local reduce = require(script.Parent.reduce)
return function(...) -- Line: 20 -- upvalues: reduce (val)
    local v1
    local v2 = select("#", ...)
    local v3 = {...}
    local v4 = {}
    if v2 == 0 then
        return v4
    end
    for i = 1, (reduce(v3, function(a1, a2) -- Line: 30
        local v4
        return (math.min(a1, #a2))
    end, #v3[1])) do
        v1 = {}
        for i2, v in ipairs(v3) do
            table.insert(v1, v[i])
        end
        table.insert(v4, v1)
    end
    return v4
end