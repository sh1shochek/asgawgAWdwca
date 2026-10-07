-- ReplicatedStorage.Interface.Screens.Menu.Career.Resolve
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Career.Resolve
-- Decompile time: 0.94 ms

local u0 = {}

local function GetHorizontalPosition(a1) -- Line: 10 -- types: a1: userdata
    return a1.Position.X.Scale
end

function u0.Caption(a1) -- Line: 18 -- types: a1: userdata
    local v1 = a1:FindFirstChild("Left") or a1
    local Label = v1:FindFirstChild("Label")
    for i, v in ipairs(v1:GetChildren()) do
        if v:IsA("TextLabel") then
            if Label == nil or v.Position.X.Scale < Label.Position.X.Scale then
                Label = v
            end
        end
    end
    return Label
end

function u0.Value(a1) -- Line: 34 -- types: a1: userdata
    local v1 = a1:FindFirstChild("Left") or a1
    local Value = v1:FindFirstChild("Value")
    if Value and Value:IsA("TextLabel") then
        return Value
    end
    local v2 = nil
    for i, v in ipairs(v1:GetChildren()) do
        if v:IsA("TextLabel") then
            if v2 == nil or v2.Position.X.Scale < v.Position.X.Scale then
                v2 = v
            end
        end
    end
    return v2
end

function u0.Row(a1, a2, a3) -- Line: 55 -- upvalues: u0 (val) -- types: a1: userdata, a2: string, a3: string
    local v1
    local v2 = a1:FindFirstChild(a2)
    if v2 and v2:IsA("GuiObject") then
        return v2
    end
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("GuiObject") then
            v1 = u0.Caption(v)
            if v1 and string.upper(v1.Text) == a3 then
                return v
            end
        end
    end
    return nil
end

function u0.SetRow(a1, a2, a3, a4) -- Line: 76
    -- upvalues: u0 (val)
    local v1 = u0.Row(a1, a2, a3)
    if not v1 then
        return
    end
    local v2 = u0.Caption(v1)
    local v3 = u0.Value(v1)
    if v2 and v2 ~= v3 then
        v2.Text = a3
    end
    if v3 then
        v3.Text = a4
    end
end

return u0