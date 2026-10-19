-- Glints (ModuleScript)
-- full path: ReplicatedStorage.Components.Common.InterfaceAnimations.Glints

-- Decompiled with Potassium's decompiler.

local v1 = {};
local Color3_fromRGB_ret = Color3.fromRGB(255, 244, 200);

local function createGlint(p2: userdata, p3: number) -- Line: 23
    -- upvalues: Color3_fromRGB_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Glint";
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Size = UDim2.fromOffset(11, 11);
    Frame.BackgroundTransparency = 1;
    Frame.ZIndex = p3;
    Frame.Visible = false;
    local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) });

    for _, v in { false, true } do
        local Frame2 = Instance.new("Frame");
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame2.Position = UDim2.fromScale(0.5, 0.5);
        local v4;

        if v then
            v4 = UDim2.new(0, 2, 1, 0);
        else
            v4 = UDim2.new(1, 0, 0, 2);
        end;

        Frame2.Size = v4;
        Frame2.BackgroundColor3 = Color3_fromRGB_ret;
        Frame2.BorderSizePixel = 0;
        Frame2.ZIndex = p3;
        local UIGradient = Instance.new("UIGradient");
        UIGradient.Rotation = v and 90 or 0;
        UIGradient.Transparency = NumberSequence_new_ret;
        UIGradient.Parent = Frame2;
        Frame2.Parent = Frame;
    end;

    Frame.Parent = p2;

    return Frame;
end;

function v1.Create(p5: userdata, p6: number, p7: userdata?, p8: number?) -- Line: 62
    -- upvalues: createGlint (copy)
    local v9 = {};

    for i = 1, p6 do
        local v10;

        if p7 then
            v10 = p7:NextNumber(0, 1.8);
        else
            v10 = (i - 1) * (1.8 / p6);
        end;

        local v11 = {
            Cycle = 1.8,
            Frame = createGlint(p5, p8 or 4),
            CycleStart = os.clock() + v10
        };
        table.insert(v9, v11);
        local _ = i;
    end;

    return v9;
end;

function v1.Step(p12: table, p13: userdata, p14: number, p15) -- Line: 82
    for _, v in p12 do
        local v16 = p14 - v.CycleStart;

        if v.Cycle <= v16 then
            if p15 then
                v.CycleStart = p14 + p13:NextNumber(p15.Min, p15.Max);
                v.Cycle = 1.1;
            else
                v.CycleStart = p14;
            end;

            v16 = p14 - v.CycleStart;
            v.Frame.Position = UDim2.fromScale(p13:NextNumber(0.12, 0.88), p13:NextNumber(0.12, 0.8));
        end;

        local v17 = v16 / 1.1;
        local v18;

        if v17 >= 0 then
            v18 = v17 <= 1;
        else
            v18 = false;
        end;

        v.Frame.Visible = v18;

        if v.Frame.Visible then
            local math_sin_ret = math.sin(v17 * 3.141592653589793);
            v.Frame.Size = UDim2.fromOffset(math_sin_ret * 11, math_sin_ret * 11);
            v.Frame.Rotation = v17 * 45;
        end;
    end;
end;

function v1.Hide(p19: table) -- Line: 108
    for _, v in p19 do
        v.Frame.Visible = false;
    end;
end;

return v1;