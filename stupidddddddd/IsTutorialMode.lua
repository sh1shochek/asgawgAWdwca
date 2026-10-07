-- ReplicatedStorage.Components.Common.IsTutorialMode
-- Script path: ReplicatedStorage.Components.Common.IsTutorialMode
-- Decompile time: 0.16 ms

return function() -- Line: 3
    local v1 = true
    if workspace:GetAttribute("ServerGamemode") ~= "Tutorial" then
        v1 = workspace:GetAttribute("Gamemode") == "Tutorial"
    end
    return v1
end