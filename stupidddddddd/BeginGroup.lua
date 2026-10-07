-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.BeginGroup
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.BeginGroup
-- Decompile time: 0.42 ms

(require(script.Parent.Parent.Parent.Imgui)):NewWidgetDefinition("BeginGroup", {
    Construct = function(a1, a2, a3, a4) -- Line: 8 -- types: a2: userdata, a3: userdata
        local Frame = Instance.new("Frame")
        Frame.Name = ("Group (%*)"):format(a1.ID)
        Frame.Size = a3
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Name = "UIListLayout"
        UIListLayout.Padding = UDim.new(0, 2)
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = a4 or Enum.HorizontalAlignment.Left
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame
        a1.UIListLayout = UIListLayout
        Frame.Parent = a2
        return Frame, Frame
    end,
    Update = function(a1, a2, a3) -- Line: 30 -- types: a2: userdata
        a1.TopInstance.Size = a2
        a1.UIListLayout.HorizontalAlignment = a3 or Enum.HorizontalAlignment.Left
    end,
})
return nil