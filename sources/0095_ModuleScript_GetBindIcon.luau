-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");

local function IsGamepadKeyCode(p1) -- Line: 9
    local Name = p1.Name;

    return (string.match(Name, "^Button") ~= nil or string.match(Name, "^DPad") ~= nil) and true or string.match(Name, "^Thumbstick") ~= nil;
end;

return function(p2) -- Line: 25
    -- upvalues: UserInputService (copy)
    if p2 == nil or p2.EnumType ~= Enum.KeyCode then
        return nil;
    end;

    local Name = p2.Name;

    if string.match(Name, "^Button") == nil and string.match(Name, "^DPad") == nil and string.match(Name, "^Thumbstick") == nil then
        return nil;
    end;

    local ImageForKeyCode = UserInputService:GetImageForKeyCode(p2);

    if ImageForKeyCode == "" then
        return nil;
    end;

    return ImageForKeyCode;
end;