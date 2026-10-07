-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.freezeDeep
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.freezeDeep
-- Decompile time: 0.21 ms

local freezeDeep
require(script.Parent.Parent.Types)

function freezeDeep(a1) -- Line: 22 -- upvalues: freezeDeep (val)
    local v1 = {}
    for k, v in pairs(a1) do
        if type(v) ~= "table" then
            v1[k] = v
        else
            v1[k] = (freezeDeep(v))
        end
    end
    table.freeze(v1)
    return v1
end

return freezeDeep