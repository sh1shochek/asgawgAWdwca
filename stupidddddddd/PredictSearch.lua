-- ReplicatedStorage.Components.Common.PredictSearch
-- Script path: ReplicatedStorage.Components.Common.PredictSearch
-- Decompile time: 1.52 ms

local function distanceWithin(a1, a2, a3) -- Line: 3 -- types: a1: string, a2: string, a3: number
    local v1, v2, v3, v4, v5, v6
    if a3 < math.abs(#a1 - #a2) then
        return a3 + 1
    end
    local v7 = {}
    local v8 = {}
    local v9 = #a2
    for i = 0, v9 do
        v7[i] = i
    end
    v9 = #a1
    for j = 1, v9 do
        v8[0] = j
        v5 = j
        v6 = #a2
        for k = 1, v6 do
            v1 = if (string.byte(a1, j)) ~= string.byte(a2, k) then 1 else 0
            v2 = v7[k] + 1
            v3 = v8[k - 1] + 1
            v4 = v7[k - 1] + v1
            v8[k] = (math.min(v2, v3, v4))
            v5 = math.min(v5, v8[k])
        end
        if a3 < v5 then
            return a3 + 1
        end
        v7 = v8
    end
    return v7[#a2]
end

return function(a1, a2, a3) -- Line: 28 -- upvalues: distanceWithin (val) -- types: a1: table, a2: string, a3: number
    local v1, v2, v3, v4
    if a2 == "" then
        return nil
    end
    local v5 = nil
    local v6 = (1 / 0)
    local v7 = (1 / 0)
    local v8 = nil
    local v9 = nil
    local v10, v11 = a2, a3
    for i, j in a1, v8, v9 do
        v1 = (1 / 0)
        v2 = (1 / 0)
        v3 = string.find(j, v10, 1, true)
        if v3 == 1 then
            v1 = 1
            v2 = #j
        elseif v3 then
            v1 = 2
            v2 = v3
        elseif v6 >= 3 and v11 <= #v10 then
            v4 = distanceWithin(v10, j, 3)
            if v4 <= 3 then
                v1 = 3
                v2 = v4
            end
        end
        if v1 < v6 or v1 == v6 and v2 < v7 then
            v5 = j
        end
    end
    return v5
end