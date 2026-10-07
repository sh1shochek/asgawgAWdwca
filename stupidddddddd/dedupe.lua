-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.dedupe
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.dedupe
-- Decompile time: 0.13 ms

local fromArray = require(script.Parent.Parent.Set.fromArray)
local toArray = require(script.Parent.Parent.Set.toArray)
return function(a1) -- Line: 4 -- upvalues: toArray (val), fromArray (val) -- types: a1: table
    return toArray(fromArray(a1))
end