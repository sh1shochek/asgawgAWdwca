-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.set
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.set
-- Decompile time: 0.12 ms

local copy = require(script.Parent.copy)
return function(a1, a2, a3) -- Line: 21 -- upvalues: copy (val) -- types: a1: table
    local v1 = copy(a1)
    v1[a2] = a3
    return v1
end