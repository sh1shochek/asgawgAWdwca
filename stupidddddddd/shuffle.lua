-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.shuffle
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.shuffle
-- Decompile time: 0.23 ms

local copy = require(script.Parent.copy)
return function(a1) -- Line: 19 -- upvalues: copy (val) -- types: a1: table
    local v1, v2
    local v3 = Random.new(os.time() * #a1)
    local v4 = copy(a1)
    for i = #v4, 1, -1 do
        v1 = v3:NextInteger(1, i)
        v2 = v4[i]
        v4[i] = v4[v1]
        v4[v1] = v2
    end
    return v4
end