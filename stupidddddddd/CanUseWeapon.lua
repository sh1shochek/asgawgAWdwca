-- ReplicatedStorage.Components.Common.CanUseWeapon
-- Script path: ReplicatedStorage.Components.Common.CanUseWeapon
-- Decompile time: 0.26 ms

return function(a1) -- Line: 3 -- types: a1: userdata?
    local v1 = false
    if a1 ~= nil then
        v1 = false
        if a1:GetAttribute("IsPlantingBomb") ~= true then
            v1 = false
            if a1:GetAttribute("IsDefusingBomb") ~= true then
                v1 = a1:GetAttribute("IsRescuingHostage") ~= true
            end
        end
    end
    return v1
end