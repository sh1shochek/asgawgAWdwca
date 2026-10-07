-- ReplicatedStorage.Components.Common.FormatDuration
-- Script path: ReplicatedStorage.Components.Common.FormatDuration
-- Decompile time: 0.82 ms

return function(a1, a2) -- Line: 5 -- types: a1: number, a2: string?
    local v1 = a2 or "Never"
    local v2 = math.max(0, (math.floor(a1)))
    local v3 = math.floor(v2 / 86400)
    local v4 = if v1 ~= "Never" then math.floor(v2 % 86400 / 3600) else math.floor(v2 / 3600)
    local v5 = math.floor(v2 % 3600 / 60)
    local v6 = v2 % 60
    if v1 == "Always" then
        return string.format("%02d:%02d:%02d:%02d", v3, v4, v5, v6)
    end
    if v1 == "IfNeeded" and v3 > 0 then
        return string.format("%02d:%02d:%02d:%02d", v3, v4, v5, v6)
    end
    return string.format("%02d:%02d:%02d", v4, v5, v6)
end