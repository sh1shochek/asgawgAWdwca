-- Decompiled with Potassium's decompiler.

local Imgui = require(script.Parent.Parent.Parent.Parent.Imgui);
local u1 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.Touch] = true
};
Imgui:NewWidgetDefinition("BeginExplorerHorizontal", {
    Events = {
        activated = {
            Setup = function(u2) -- Line: 18
                -- upvalues: u1 (copy)
                u2.TopInstance.InputBegan:Connect(function(p3: userdata) -- Line: 19
                    -- upvalues: u1 (ref), u2 (copy)
                    if not u1[p3.UserInputType] then
                        return;
                    end;

                    u2.WasPressed = true;
                end);
            end,

            Evaluate = function(p4) -- Line: 28
                local WasPressed = p4.WasPressed;
                p4.WasPressed = false;

                return WasPressed;
            end
        }
    },

    Construct = function(p5: any, p6: userdata, p7: boolean?, p8: any) -- Line: 37, Name: Construct
        local Frame = Instance.new("Frame");
        Frame.Name = `ExplorerHorizontal ({p5.ID})`;
        Frame.Size = UDim2.fromScale(1, 0);
        Frame.AutomaticSize = Enum.AutomaticSize.XY;
        Frame.BackgroundTransparency = p7 and 0.5 or 1;
        Frame.BorderSizePixel = 0;
        Frame.Active = true;
        Frame.BackgroundColor3 = Color3.fromHex("#0b5aaf");
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Name = "UIListLayout";
        UIListLayout.Padding = UDim.new(0, 2);
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.HorizontalAlignment = p8 or Enum.HorizontalAlignment.Left;
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Parent = Frame;
        p5.TopInstance = Frame;
        p5.UIListLayout = UIListLayout;
        Frame.Parent = p6;

        return Frame, Frame;
    end,

    Update = function(p9: any, p10: boolean?, p11: any) -- Line: 69, Name: Update
        p9.UIListLayout.HorizontalAlignment = p11 or Enum.HorizontalAlignment.Left;
        p9.TopInstance.BackgroundTransparency = p10 and 0 or 1;
    end
});

return nil;