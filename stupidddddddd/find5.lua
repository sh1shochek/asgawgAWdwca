-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.find
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.find
-- Decompile time: 0.19 ms

return function(a1, a2, a3) -- Line: 25 -- types: a1: table, a3: number?
    local v1 = #a1
    if type(a3) ~= "number" then
        a3 = 1
    elseif a3 < 1 then
        a3 = v1 + a3
    end
    return table.find(a1, a2, a3)
end