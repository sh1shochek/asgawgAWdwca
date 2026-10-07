-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.BeginVertical
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.BeginVertical
-- Decompile time: 0.40 ms

(require(script.Parent.Parent.Parent.Imgui)):NewWidgetDefinition("BeginVertical", {
    Construct = function(a1, a2, a3) -- Line: 8 -- types: a2: userdata
        local Frame = Instance.new("Frame")
        Frame.Name = ("Horizontal (%*)"):format(a1.ID)
        Frame.Size = UDim2.fromScale(1, 0)
        Frame.AutomaticSize = Enum.AutomaticSize.XY
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Name = "UIListLayout"
        UIListLayout.Padding = UDim.new(0, 2)
        UIListLayout.FillDirection = Enum.FillDirection.Vertical
        UIListLayout.HorizontalAlignment = a3 or Enum.HorizontalAlignment.Left
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame
        a1.UIListLayout = UIListLayout
        Frame.Parent = a2
        return Frame, Frame
    end,
    Update = function(a1, a2) -- Line: 31
        a1.UIListLayout.HorizontalAlignment = a2 or Enum.HorizontalAlignment.Left
    end,
})
return nil