-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.Label
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.Label
-- Decompile time: 0.26 ms

local Imgui = require(script.Parent.Parent.Parent.Imgui)
Imgui:NewWidgetDefinition("Label", {
    Construct = function(a1, a2, a3) -- Line: 8 -- upvalues: Imgui (val) -- types: a2: userdata, a3: string
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = ("Label (%*)"):format(a1.ID)
        TextLabel.AutomaticSize = Enum.AutomaticSize.XY
        TextLabel.Text = a3
        TextLabel.RichText = true
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        Imgui.applyTextStyle(TextLabel)
        TextLabel.Parent = a2
        return TextLabel
    end,
    Update = function(a1, a2) -- Line: 24 -- types: a2: string
        a1.TopInstance.Text = a2
    end,
})
return nil