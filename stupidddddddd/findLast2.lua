-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.findLast
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.findLast
-- Decompile time: 0.27 ms

return function(a1, a2, a3) -- Line: 20 -- types: a1: table, a3: number?
    local v1 = #a1
    if type(a3) ~= "number" then
        a3 = v1
    elseif a3 < 1 then
        a3 = v1 + a3
    end
    for i = a3, 1, -1 do
        if a1[i] == a2 then
            return i
        end
    end
end