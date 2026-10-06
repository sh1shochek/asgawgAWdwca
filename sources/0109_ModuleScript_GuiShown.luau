-- Decompiled with Potassium's decompiler.

local u2 = {
    IsShown = function(p1: userdata) -- Line: 7, Name: IsShown
        while p1 and p1:IsA("GuiObject") do
            if not p1.Visible then
                return false;
            end;

            p1 = p1.Parent;
        end;

        return true;
    end
};

function u2.Observe(p3: userdata, u4: function) -- Line: 19
    -- upvalues: u2 (copy)
    local u5 = u2.IsShown(p3);
    local u6 = p3;
    local u7 = {};

    while p3 and p3:IsA("GuiObject") do
        local PropertyChangedSignal = p3:GetPropertyChangedSignal("Visible");
        table.insert(u7, PropertyChangedSignal:Connect(function() -- Line: 26
            -- upvalues: u2 (ref), u6 (copy), u5 (ref), u4 (copy)
            local v8 = u2.IsShown(u6);

            if v8 ~= u5 then
                u5 = v8;
                u4(u5);
            end;
        end));
        p3 = p3.Parent;
    end;

    u4(u5);

    return function() -- Line: 37
        -- upvalues: u7 (copy)
        for _, v in u7 do
            v:Disconnect();
        end;

        table.clear(u7);
    end;
end;

return table.freeze(u2);