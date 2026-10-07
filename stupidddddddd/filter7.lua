-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.filter
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.filter
-- Decompile time: 0.29 ms

local Parent_2 = script.Parent.Parent
local Util = require(Parent_2.Util)
return function(a1, a2) -- Line: 26 -- upvalues: Util (val) -- types: a1: table, a2: function?
    local v1 = {}
    if type(a2) ~= "function" then
        a2 = Util.func.truthy
    end
    for i, v in ipairs(a1) do
        if a2(v, i, a1) then
            table.insert(v1, v)
        end
    end
    return v1
end