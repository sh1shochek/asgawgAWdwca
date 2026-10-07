-- ReplicatedStorage.Shared.FuzzySearch
-- Script path: ReplicatedStorage.Shared.FuzzySearch
-- Decompile time: 0.38 ms

return {
    MatchesQuery = function(a1, a2) -- Line: 5 -- types: a1: string, a2: string
        if a2 == "" then
            return true
        end
        local v1 = a1:lower():gsub("[^%w]", "")
        local v2 = a2:lower():gsub("[^%w]", "")
        local v3 = 1
        local v4 = 1
        while v3 <= #v1 do
            if not (v4 <= #v2) then
                break
            end
            if (v1:sub(v3, v3)) == v2:sub(v4, v4) then
                v4 = v4 + 1
            end
            v3 = v3 + 1
        end
        return #v2 < v4
    end,
}