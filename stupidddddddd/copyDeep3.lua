-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.copyDeep
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.copyDeep
-- Decompile time: 0.23 ms

local copyDeep

function copyDeep(a1) -- Line: 20 -- upvalues: copyDeep (val) -- types: a1: table
    local v1 = table.clone(a1)
    for i, j in a1 do
        if type(j) == "table" then
            v1[i] = (copyDeep(j))
        end
    end
    return v1
end

return copyDeep