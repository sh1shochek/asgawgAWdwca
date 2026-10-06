-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Imgui):NewWidgetDefinition("BeginHorizontal", {
    Construct = function(p1: any, p2: userdata, p3: any) -- Line: 8, Name: Construct
        local Frame = Instance.new("Frame");
        Frame.Name = `Horizontal ({p1.ID})`;
        Frame.Size = UDim2.fromScale(1, 0);
        Frame.AutomaticSize = Enum.AutomaticSize.XY;
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Name = "UIListLayout";
        UIListLayout.Padding = UDim.new(0, 2);
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.HorizontalAlignment = p3 or Enum.HorizontalAlignment.Left;
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Parent = Frame;
        p1.UIListLayout = UIListLayout;
        Frame.Parent = p2;

        return Frame, Frame;
    end,

    Update = function(p4, p5) -- Line: 32, Name: Update
        p4.UIListLayout.HorizontalAlignment = p5 or Enum.HorizontalAlignment.Left;
    end
});

return nil;