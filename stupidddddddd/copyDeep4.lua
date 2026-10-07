-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.copyDeep
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.copyDeep
-- Decompile time: 0.18 ms

local copyDeep

function copyDeep(a1) -- Line: 20 -- upvalues: copyDeep (val)
    local v1 = table.clone(a1)
    for k, v in pairs(a1) do
        if type(v) == "table" then
            v1[k] = (copyDeep(v))
        end
    end
    return v1
end

return copyDeep