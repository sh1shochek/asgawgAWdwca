-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeKey
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeKey
-- Decompile time: 0.11 ms

local copy = require(script.Parent.copy)
return function(a1, a2) -- Line: 21 -- upvalues: copy (val) -- types: a1: table
    local v1 = copy(a1)
    v1[a2] = nil
    return v1
end