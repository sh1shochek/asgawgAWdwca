-- Decompiled with Potassium's decompiler.

local u1 = {};
local UserInputService = game:GetService("UserInputService");
local u2 = {};
local u3 = {};
local u4 = 0;

local function isOnScreen(p5: userdata) -- Line: 35
    while p5 do
        if p5:IsA("GuiObject") then
            if not p5.Visible then
                return false;
            end;
        elseif p5:IsA("LayerCollector") then
            return p5.Enabled;
        end;

        p5 = p5.Parent;
    end;

    return false;
end;

function u1.IsDoublePressed() -- Line: 53
    -- upvalues: u4 (ref)
    return tick() - u4 < 0.1;
end;

function u1.MarkUsed() -- Line: 61
    -- upvalues: u4 (ref)
    u4 = tick();
end;

function u1.Add(u6: userdata, u7: userdata?, u8: function) -- Line: 67
    -- upvalues: u2 (copy)
    table.insert(u2, {
        closeButton = u7,
        onClose = u8,
        frame = u6
    });

    if not u7 then
        return;
    end;

    u7.MouseButton1Click:Connect(function() -- Line: 70
        -- upvalues: u8 (copy), u6 (copy), u7 (copy)
        u8(u6, u7);
    end);
    u7.Activated:Connect(function(p9) -- Line: 73
        -- upvalues: u8 (copy), u6 (copy), u7 (copy)
        if p9 and p9.UserInputType == Enum.UserInputType.Gamepad1 then
            u8(u6, u7);
        end;
    end);
end;

function u1.Remove(p10: userdata) -- Line: 83
    -- upvalues: u2 (copy)
    for i = #u2, 1, -1 do
        local v11;

        if u2[i].frame == p10 then
            table.remove(u2, i);
            v11 = i;
        else
            v11 = i;
        end;
    end;
end;

function u1.BringToFront(p12: userdata) -- Line: 94
    -- upvalues: u2 (copy)
    for i = #u2, 1, -1 do
        if u2[i].frame == p12 then
            local table_remove_ret = table.remove(u2, i);
            table.insert(u2, table_remove_ret);

            return;
        end;

        local _ = i;
    end;
end;

function u1.AddHandler(p13: function, p14: function) -- Line: 107
    -- upvalues: u3 (copy)
    table.insert(u3, {
        isActive = p13,
        onClose = p14
    });
end;

function u1.CloseFrame() -- Line: 113
    -- upvalues: u1 (copy), u3 (copy), u4 (ref), u2 (copy), isOnScreen (copy)
    if u1.IsDoublePressed() then
        return true;
    end;

    for i = #u3, 1, -1 do
        local v15 = u3[i];

        if v15.isActive() then
            v15.onClose();
            u4 = tick();

            return true;
        end;

        local _ = i;
    end;

    for i = #u2, 1, -1 do
        local v16 = u2[i];

        if isOnScreen(v16.frame) then
            v16.onClose(v16.frame, v16.closeButton);
            u4 = tick();

            return true;
        end;

        local _ = i;
    end;

    return false;
end;

UserInputService.InputBegan:Connect(function(p17: userdata) -- Line: 144
    -- upvalues: u1 (copy)
    if p17.UserInputType == Enum.UserInputType.Gamepad1 and p17.KeyCode == Enum.KeyCode.ButtonB then
        u1.CloseFrame();
    end;
end);

return u1;