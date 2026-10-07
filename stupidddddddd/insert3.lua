-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.insert
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.insert
-- Decompile time: 0.42 ms

return function(a1, a2, ...) -- Line: 21 -- types: a1: table, a2: number
    local v1 = #a1
    if a2 < 1 then
        a2 = a2 + (v1 + 1)
    end
    if v1 < a2 then
        if v1 + 1 < a2 then
            return a1
        end
        a2 = v1 + 1
        v1 = v1 + 1
    end
    local v2 = {}
    for i = 1, v1 do
        if i == a2 then
            for i2, v in ipairs({...}) do
                table.insert(v2, v)
            end
        end
        table.insert(v2, a1[i])
    end
    return v2
end