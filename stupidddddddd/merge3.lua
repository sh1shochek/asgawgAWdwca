-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.merge
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.merge
-- Decompile time: 0.40 ms

local Parent_2 = script.Parent.Parent
local None = require(Parent_2.None)
return function(...) -- Line: 27 -- upvalues: None (val)
    local v1, v2
    local v3 = {}
    for i = 1, (select("#", ...)) do
        v2 = select(i, ...)
        if type(v2) == "table" then
            for k, v in pairs(v2) do
                v1 = if v ~= None then v else nil
                v3[k] = v1
            end
        end
    end
    return v3
end