-- Decompiled with Potassium's decompiler.

local u1 = {};

local function GetHorizontalPosition(p2: userdata) -- Line: 10
    return p2.Position.X.Scale;
end;

function u1.Caption(p3: userdata) -- Line: 18
    local v4 = p3:FindFirstChild("Left") or p3;
    local Label = v4:FindFirstChild("Label");

    for _, child in ipairs(v4:GetChildren()) do
        if child:IsA("TextLabel") and (Label == nil or child.Position.X.Scale < Label.Position.X.Scale) then
            Label = child;
        end;
    end;

    return Label;
end;

function u1.Value(p5: userdata) -- Line: 34
    local v6 = p5:FindFirstChild("Left") or p5;
    local Value = v6:FindFirstChild("Value");

    if Value and Value:IsA("TextLabel") then
        return Value;
    end;

    local v7 = nil;

    for _, child in ipairs(v6:GetChildren()) do
        if child:IsA("TextLabel") and (v7 == nil or child.Position.X.Scale > v7.Position.X.Scale) then
            v7 = child;
        end;
    end;

    return v7;
end;

function u1.Row(p8: userdata, p9: string, p10: string) -- Line: 55
    -- upvalues: u1 (copy)
    local v11 = p8:FindFirstChild(p9);

    if v11 and v11:IsA("GuiObject") then
        return v11;
    end;

    for _, child in ipairs(p8:GetChildren()) do
        if child:IsA("GuiObject") then
            local v12 = u1.Caption(child);

            if v12 and string.upper(v12.Text) == p10 then
                return child;
            end;
        end;
    end;

    return nil;
end;

function u1.SetRow(p13: userdata, p14: string, p15: string, p16: string) -- Line: 76
    -- upvalues: u1 (copy)
    local v17 = u1.Row(p13, p14, p15);

    if not v17 then
        return;
    end;

    local v18 = u1.Caption(v17);
    local v19 = u1.Value(v17);

    if v18 and v18 ~= v19 then
        v18.Text = p15;
    end;

    if v19 then
        v19.Text = p16;
    end;
end;

return u1;