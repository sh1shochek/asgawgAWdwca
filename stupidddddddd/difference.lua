-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.difference
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.difference
-- Decompile time: 0.35 ms

require(script.Parent.Parent.Types)
local toSet = require(script.Parent.toSet)
local toArray = require(script.Parent.Parent.Set.toArray)
local difference = require(script.Parent.Parent.Set.difference)
return function(a1, ...) -- Line: 25 -- upvalues: toSet (val), difference (val), toArray (val)
    local v1 = toSet(a1)
    local v2 = {}
    for i, j in {...} do
        if typeof(j) == "table" then
            table.insert(v2, (toSet(j)))
        end
    end
    return toArray((difference(v1, unpack(v2))))
end