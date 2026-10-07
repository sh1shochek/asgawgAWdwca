-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.at
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.at
-- Decompile time: 0.12 ms

return function(a1, a2) -- Line: 19 -- types: a1: table, a2: number
    local v1 = #a1
    if a2 < 1 then
        a2 = a2 + v1
    end
    return a1[a2]
end