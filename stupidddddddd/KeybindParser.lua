-- ReplicatedStorage.Controllers.InputController.KeybindParser
-- Script path: ReplicatedStorage.Controllers.InputController.KeybindParser
-- Decompile time: 0.40 ms

return {
    parse = function(a1) -- Line: 11 -- types: a1: string
        local u4 = string.split(a1, ".")
        if a1 ~= "" and #u4 == 3 then
            local success, result = pcall(function() -- Line: 18 -- upvalues: u4 (val)
                if u4[2] == "KeyCode" then
                    return Enum.KeyCode[u4[3]]
                end
                if u4[2] == "UserInputType" then
                    return Enum.UserInputType[u4[3]]
                end
                if u4[2] ~= "CustomInputType" then
                    return nil
                end
                if u4[3] ~= "ScrollWheelUp" and u4[3] ~= "ScrollWheelDown" then
                    return nil
                end
                return u4[3]
            end)
            return success and result or nil
        end
        return nil
    end,
}