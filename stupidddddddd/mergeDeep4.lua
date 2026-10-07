-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.mergeDeep
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.mergeDeep
-- Decompile time: 0.65 ms

local mergeDeep
local Parent_2 = script.Parent.Parent
local None = require(Parent_2.None)
local copyDeep = require(script.Parent.copyDeep)

function mergeDeep(...) -- Line: 28 -- upvalues: None (val), copyDeep (val), mergeDeep (val)
    local v1
    local v2 = {}
    for i = 1, (select("#", ...)) do
        v1 = select(i, ...)
        if type(v1) == "table" then
            for k, v in pairs(v1) do
                if v == None then
                    v2[k] = nil
                elseif type(v) ~= "table" then
                    v2[k] = v
                elseif v2[k] == nil then
                    v2[k] = (copyDeep(v))
                elseif type(v2[k]) == "table" then
                    v2[k] = (mergeDeep(v2[k], v))
                else
                    v2[k] = (copyDeep(v))
                end
            end
        end
    end
    return v2
end

return mergeDeep