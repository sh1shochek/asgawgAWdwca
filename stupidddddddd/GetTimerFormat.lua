-- ReplicatedStorage.Components.Common.GetTimerFormat
-- Script path: ReplicatedStorage.Components.Common.GetTimerFormat
-- Decompile time: 0.24 ms

local function format(a1) -- Line: 2 -- types: a1: number
    return string.format("%02i", a1)
end

return function(a1) -- Line: 9 -- types: a1: number
    return (string.format("%02i", (math.floor(a1 / 60)))) .. ":" .. string.format("%02i", a1 % 60)
end