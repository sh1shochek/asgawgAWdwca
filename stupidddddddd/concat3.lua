-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.concat
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.concat
-- Decompile time: 0.36 ms

local Parent_2 = script.Parent.Parent
local None = require(Parent_2.None)
return function(...) -- Line: 26 -- upvalues: None (val)
    local v1
    local v2 = {}
    for i = 1, (select("#", ...)) do
        v1 = select(i, ...)
        if type(v1) == "table" then
            for i2, v in ipairs(v1) do
                if v ~= None then
                    table.insert(v2, v)
                end
            end
        end
    end
    return v2
end