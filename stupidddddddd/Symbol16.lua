-- ReplicatedStorage.Shared.Janitor.Symbol
-- Script path: ReplicatedStorage.Shared.Janitor.Symbol
-- Decompile time: 0.14 ms

return function(a1) -- Line: 2 -- types: a1: string
    local v1 = newproxy(true)
    local v2 = getmetatable(v1)

    function v2.__tostring() -- Line: 5 -- upvalues: a1 (val)
        return a1
    end

    return v1
end