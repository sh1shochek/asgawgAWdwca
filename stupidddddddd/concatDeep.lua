-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.concatDeep
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.concatDeep
-- Decompile time: 0.52 ms

local Parent_2 = script.Parent.Parent
local copyDeep = require(script.Parent.copyDeep)
local None = require(Parent_2.None)
return function(...) -- Line: 28 -- upvalues: None (val), copyDeep (val)
    local v1
    local v2 = {}
    for i = 1, (select("#", ...)) do
        v1 = select(i, ...)
        if type(v1) == "table" then
            for i2, v in ipairs(v1) do
                if v ~= None then
                    if type(v) ~= "table" then
                        table.insert(v2, v)
                    else
                        table.insert(v2, (copyDeep(v)))
                    end
                end
            end
        end
    end
    return v2
end