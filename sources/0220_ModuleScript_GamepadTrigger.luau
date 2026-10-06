-- Decompiled with Potassium's decompiler.

local u1 = {};
local UserInputService = game:GetService("UserInputService");
local table_freeze_ret = table.freeze({
    [Enum.UserInputType.Gamepad1] = true,
    [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true,
    [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true,
    [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true,
    [Enum.UserInputType.Gamepad8] = true
});

function u1.getInputBinding(p2: userdata) -- Line: 24
    if p2.KeyCode and p2.KeyCode ~= Enum.KeyCode.Unknown then
        return p2.KeyCode;
    end;

    if p2.UserInputType == Enum.UserInputType.MouseButton1 or (p2.UserInputType == Enum.UserInputType.MouseButton2 or p2.UserInputType == Enum.UserInputType.MouseButton3) then
        return p2.UserInputType;
    end;

    return nil;
end;

function u1.isGamepadInput(p3: userdata) -- Line: 40
    -- upvalues: table_freeze_ret (copy)
    return table_freeze_ret[p3.UserInputType] == true;
end;

function u1.isTrigger(p4: userdata, p5: table) -- Line: 46
    -- upvalues: table_freeze_ret (copy)
    local v6;

    if table_freeze_ret[p4.UserInputType] == true then
        v6 = p5[p4.KeyCode] == true;
    else
        v6 = false;
    end;

    return v6;
end;

function u1.isStillPressed(p7: userdata, p8: table) -- Line: 53
    -- upvalues: u1 (copy), UserInputService (copy)
    if not u1.isTrigger(p7, p8) then
        return false;
    end;

    local KeyCode = p7.KeyCode;

    for _, v in ipairs(UserInputService:GetGamepadState(p7.UserInputType)) do
        if v.KeyCode == KeyCode then
            return v.Position.Z > 0.3;
        end;
    end;

    return false;
end;

return u1;