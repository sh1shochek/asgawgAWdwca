-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Imgui):NewWidgetDefinition("BeginGroup", {
    Construct = function(p1: any, p2: userdata, p3, p4: any) -- Line: 8, Name: Construct
        local Frame = Instance.new("Frame");
        Frame.Name = `Group ({p1.ID})`;
        Frame.Size = p3;
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Name = "UIListLayout";
        UIListLayout.Padding = UDim.new(0, 2);
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.HorizontalAlignment = p4 or Enum.HorizontalAlignment.Left;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Parent = Frame;
        p1.UIListLayout = UIListLayout;
        Frame.Parent = p2;

        return Frame, Frame;
    end,

    Update = function(p5: any, p6, p7: any) -- Line: 30, Name: Update
        p5.TopInstance.Size = p6;
        p5.UIListLayout.HorizontalAlignment = p7 or Enum.HorizontalAlignment.Left;
    end
});

return nil;