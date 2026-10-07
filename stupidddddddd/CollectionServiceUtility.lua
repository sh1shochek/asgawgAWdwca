-- ReplicatedStorage.Shared.CollectionServiceUtility
-- Script path: ReplicatedStorage.Shared.CollectionServiceUtility
-- Decompile time: 0.15 ms

return {
    FindDescendantWithTag = function(a1, a2) -- Line: 5 -- types: a1: userdata, a2: string
        return a1:QueryDescendants(((".%*"):format(a2)))[1]
    end,
}