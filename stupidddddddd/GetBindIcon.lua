-- ReplicatedStorage.Components.Common.GetBindIcon
-- Script path: ReplicatedStorage.Components.Common.GetBindIcon
-- Decompile time: 0.50 ms

local UserInputService = game:GetService("UserInputService")

local function IsGamepadKeyCode(a1) -- Line: 9
    local Name = a1.Name
    local v1 = true
    if string.match(Name, "^Button") == nil then
        v1 = true
        if string.match(Name, "^DPad") == nil then
            v1 = string.match(Name, "^Thumbstick") ~= nil
        end
    end
    return v1
end

return function(a1) -- Line: 25 -- upvalues: UserInputService (val)
    if a1 ~= nil and a1.EnumType == Enum.KeyCode then
        local Name = a1.Name
        local v1 = true
        if string.match(Name, "^Button") == nil then
            v1 = true
            if string.match(Name, "^DPad") == nil then
                v1 = string.match(Name, "^Thumbstick") ~= nil
            end
        end
        if not v1 then
            return nil
        end
        local ImageForKeyCode = UserInputService:GetImageForKeyCode(a1)
        if ImageForKeyCode == "" then
            return nil
        end
        return ImageForKeyCode
    end
    return nil
end