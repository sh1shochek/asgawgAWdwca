-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.update
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.update
-- Decompile time: 0.24 ms

local copy = require(script.Parent.copy)
return function(a1, a2, a3, a4) -- Line: 30 -- upvalues: copy (val) -- types: a1: table, a3: function?, a4: function?
    local v1 = copy(a1)
    if not v1[a2] then
        if typeof(a4) == "function" then
            v1[a2] = (a4(a2))
        end
        return v1
    end
    if not a3 then
        return v1
    end
    v1[a2] = (a3(v1[a2], a2))
    return v1
end