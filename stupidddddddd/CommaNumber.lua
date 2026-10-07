-- ReplicatedStorage.Components.Common.CommaNumber
-- Script path: ReplicatedStorage.Components.Common.CommaNumber
-- Decompile time: 0.19 ms

return function(a1) -- Line: 3 -- types: a1: number
    local v1 = if a1 % 1 ~= 0 then string.format("%.2f", a1) else tostring(a1)
    return v1:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end