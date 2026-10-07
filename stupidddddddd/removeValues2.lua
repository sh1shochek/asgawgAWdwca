-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeValues
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeValues
-- Decompile time: 0.29 ms

local Parent_2 = script.Parent.Parent
local toSet = require(Parent_2.Array.toSet)
return function(a1, ...) -- Line: 23 -- upvalues: toSet (val) -- types: a1: table
    local v1 = toSet({...})
    local v2 = {}
    for k, v in pairs(a1) do
        if not v1[v] then
            v2[k] = v
        end
    end
    return v2
end