-- Decompiled with Potassium's decompiler.

local ActionGroupButton = require(script.Parent.ActionGroupButton);

return function(p1: userdata, p2: any, u3: any, u4: function) -- Line: 4
    -- upvalues: ActionGroupButton (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Actions Explorer";
    Frame.BackgroundColor3 = Color3.fromRGB(172, 195, 245);
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(0.25, 1);
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Gradient";
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    Frame2.BackgroundTransparency = 0.8;
    Frame2.BorderSizePixel = 0;
    Frame2.Position = UDim2.fromScale(1, 0);
    Frame2.Size = UDim2.fromScale(0.05, 1);
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "UIGradient";
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) });
    UIGradient.Parent = Frame2;
    Frame2.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "ScrollingFrame";
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.Size = UDim2.fromScale(1, 1);
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.Parent = ScrollingFrame;
    ScrollingFrame.Parent = Frame;
    Frame.Parent = p1;
    local u5 = {};
    p2:Observe(function(p6) -- Line: 54
        -- upvalues: u5 (ref), ActionGroupButton (ref), ScrollingFrame (copy), u3 (copy), u4 (copy)
        for _, v in p6 do
            if not u5[v] then
                u5[v] = ActionGroupButton(v, ScrollingFrame, u3, function() -- Line: 64
                    -- upvalues: u4 (ref), v (copy)
                    u4(v);
                end);
            end;
        end;
    end);

    return function() -- Line: 71
        -- upvalues: Frame (ref), u5 (ref)
        Frame:Destroy();
        Frame = nil;

        for _, v in u5 do
            v();
        end;

        u5 = nil;
    end;
end;