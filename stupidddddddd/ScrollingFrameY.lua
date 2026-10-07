-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.ScrollingFrameY
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.ScrollingFrameY
-- Decompile time: 0.50 ms

(require(script.Parent.Parent.Parent.Imgui)):NewWidgetDefinition("ScrollingFrameY", {
    Construct = function(a1, a2, a3, a4) -- Line: 8 -- types: a2: userdata, a3: userdata
        local ScrollingFrame = Instance.new("ScrollingFrame")
        ScrollingFrame.Name = ("ScrollingFrameY (%*)"):format(a1.ID)
        ScrollingFrame.Size = a3
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0)
        ScrollingFrame.ScrollBarThickness = 5
        ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        ScrollingFrame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Name = "UIListLayout"
        UIListLayout.Padding = UDim.new(0, 2)
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = a4 or Enum.HorizontalAlignment.Left
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = ScrollingFrame
        a1.UIListLayout = UIListLayout
        ScrollingFrame.Parent = a2
        return ScrollingFrame, ScrollingFrame
    end,
    Update = function(a1, a2, a3) -- Line: 41 -- types: a2: userdata
        a1.TopInstance.Size = a2
        a1.UIListLayout.HorizontalAlignment = a3 or Enum.HorizontalAlignment.Left
    end,
})
return nil