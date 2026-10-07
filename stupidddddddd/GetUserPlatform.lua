-- ReplicatedStorage.Components.Common.GetUserPlatform
-- Script path: ReplicatedStorage.Components.Common.GetUserPlatform
-- Decompile time: 0.39 ms

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
return function() -- Line: 11 -- upvalues: UserInputService (val), RunService (val)
    local v1 = {}
    if UserInputService.GamepadEnabled then
        table.insert(v1, "Console")
    end
    if UserInputService.VREnabled then
        table.insert(v1, "VR")
    end
    local v2 = RunService:IsStudio() and UserInputService.PreferredInput == Enum.PreferredInput.Touch
    if UserInputService.MouseEnabled then
        if not v2 then
            table.insert(v1, "PC")
        end
    elseif UserInputService.KeyboardEnabled and not v2 then
        table.insert(v1, "PC")
    end
    if UserInputService.TouchEnabled and not table.find(v1, "PC") then
        table.insert(v1, "Mobile")
    end
    return v1
end