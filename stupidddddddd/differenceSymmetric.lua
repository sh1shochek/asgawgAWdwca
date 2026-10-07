-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.differenceSymmetric
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.differenceSymmetric
-- Decompile time: 0.69 ms

require(script.Parent.Parent.Types)
local toSet = require(script.Parent.toSet)
local toArray = require(script.Parent.Parent.Set.toArray)
local differenceSymmetric = require(script.Parent.Parent.Set.differenceSymmetric)
return function(a1, ...) -- Line: 25 -- upvalues: toSet (val), differenceSymmetric (val), toArray (val)
    local v1 = toSet(a1)
    local v2 = {}
    for i, j in {...} do
        if typeof(j) == "table" then
            table.insert(v2, (toSet(j)))
        end
    end
    return toArray((differenceSymmetric(v1, unpack(v2))))
end