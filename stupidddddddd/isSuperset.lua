-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.isSuperset
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.isSuperset
-- Decompile time: 0.09 ms

local isSubset = require(script.Parent.isSubset)
return function(a1, a2) -- Line: 21 -- upvalues: isSubset (val) -- types: a1: table, a2: table
    return isSubset(a2, a1)
end