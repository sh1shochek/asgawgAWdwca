-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Parent.Imgui):NewWidgetDefinition("ScrollingFrameY", {
    Construct = function(p1: any, p2: userdata, p3, p4: any) -- Line: 8, Name: Construct
        local ScrollingFrame = Instance.new("ScrollingFrame");
        ScrollingFrame.Name = `ScrollingFrameY ({p1.ID})`;
        ScrollingFrame.Size = p3;
        ScrollingFrame.BackgroundTransparency = 1;
        ScrollingFrame.BorderSizePixel = 0;
        ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0);
        ScrollingFrame.ScrollBarThickness = 5;
        ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
        ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
        ScrollingFrame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Name = "UIListLayout";
        UIListLayout.Padding = UDim.new(0, 2);
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.HorizontalAlignment = p4 or Enum.HorizontalAlignment.Left;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Parent = ScrollingFrame;
        p1.UIListLayout = UIListLayout;
        ScrollingFrame.Parent = p2;

        return ScrollingFrame, ScrollingFrame;
    end,

    Update = function(p5: any, p6, p7: any) -- Line: 41, Name: Update
        p5.TopInstance.Size = p6;
        p5.UIListLayout.HorizontalAlignment = p7 or Enum.HorizontalAlignment.Left;
    end
});

return nil;