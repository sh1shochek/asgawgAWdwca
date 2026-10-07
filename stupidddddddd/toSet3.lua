-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.toSet
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.toSet
-- Decompile time: 0.18 ms

local Parent_2 = script.Parent.Parent
require(Parent_2.Types)
return function(a1) -- Line: 20 -- types: a1: table
    local v1 = {}
    for i, v in ipairs(a1) do
        v1[v] = true
    end
    return v1
end