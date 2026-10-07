-- ReplicatedStorage.Components.Common.IsPlayingTeam
-- Script path: ReplicatedStorage.Components.Common.IsPlayingTeam
-- Decompile time: 0.14 ms

return function(a1) -- Line: 3
    local v1 = true
    if a1 ~= "Counter-Terrorists" then
        v1 = a1 == "Terrorists"
    end
    return v1
end