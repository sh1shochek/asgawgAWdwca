-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.flatten
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.flatten
-- Decompile time: 0.36 ms

local flatten
require(script.Parent.Parent.Types)

function flatten(a1, a2) -- Line: 30 -- upvalues: flatten (val) -- types: a2: number?
    local v1
    if type(a2) ~= "number" then
        a2 = (1 / 0)
    end
    local v2 = {}
    for k, v in pairs(a1) do
        if type(v) ~= "table" or not (a2 > 0) then
            v2[k] = v
        else
            v1 = flatten(v, a2 - 1)
            for k2, i in pairs(v2) do
                v1[k2] = i
            end
            v2 = v1
        end
    end
    return v2
end

return flatten