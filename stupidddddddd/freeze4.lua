-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.freeze
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.freeze
-- Decompile time: 0.14 ms

require(script.Parent.Parent.Types)
local copy = require(script.Parent.copy)
return function(a1) -- Line: 23 -- upvalues: copy (val)
    local v1 = copy(a1)
    table.freeze(v1)
    return v1
end