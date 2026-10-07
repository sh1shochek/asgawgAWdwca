-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.flatten
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.flatten
-- Decompile time: 0.35 ms

local flatten

function flatten(a1, a2) -- Line: 24 -- upvalues: flatten (val) -- types: a1: table, a2: number?
    if type(a2) ~= "number" then
        a2 = (1 / 0)
    end
    local v1 = {}
    for i, v in ipairs(a1) do
        if type(v) ~= "table" or not (a2 > 0) then
            table.insert(v1, v)
        else
            for i2, i3 in ipairs((flatten(v, a2 - 1))) do
                table.insert(v1, i3)
            end
        end
    end
    return v1
end

return flatten