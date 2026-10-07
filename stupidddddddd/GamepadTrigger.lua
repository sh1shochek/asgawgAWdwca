-- ReplicatedStorage.Controllers.InputController.GamepadTrigger
-- Script path: ReplicatedStorage.Controllers.InputController.GamepadTrigger
-- Decompile time: 0.68 ms

local u0 = {}
local UserInputService = game:GetService("UserInputService")
local u24 = table.freeze({
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true,
})

function u0.getInputBinding(a1) -- Line: 24 -- types: a1: userdata
    if a1.KeyCode and a1.KeyCode ~= Enum.KeyCode.Unknown then
        return a1.KeyCode
    end
    if a1.UserInputType ~= Enum.UserInputType.MouseButton1
        and a1.UserInputType ~= Enum.UserInputType.MouseButton2
        and a1.UserInputType ~= Enum.UserInputType.MouseButton3 then
        return nil
    end
    return a1.UserInputType
end

function u0.isGamepadInput(a1) -- Line: 40 -- upvalues: u24 (val) -- types: a1: userdata
    return u24[a1.UserInputType] == true
end

function u0.isTrigger(a1, a2) -- Line: 46 -- upvalues: u24 (val) -- types: a1: userdata, a2: table
    local v1 = false
    if u24[a1.UserInputType] == true then
        v1 = a2[a1.KeyCode] == true
    end
    return v1
end

function u0.isStillPressed(a1, a2) -- Line: 53
    -- upvalues: u0 (val), UserInputService (val)
    if not u0.isTrigger(a1, a2) then
        return false
    end
    local KeyCode = a1.KeyCode
    for i, v in ipairs(UserInputService:GetGamepadState(a1.UserInputType)) do
        if v.KeyCode == KeyCode then
            return 0.3 < v.Position.Z
        end
    end
    return false
end

return u0