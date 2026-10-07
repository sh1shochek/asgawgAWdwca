-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Properties.PropertyLabel
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Properties.PropertyLabel
-- Decompile time: 0.70 ms

local Imgui = require(script.Parent.Parent.Parent.Parent.Imgui)
local u8 = {
    string = "#adf195",
    number = "#ffc600",
    Vector3 = "#ffc600",
    CFrame = "#ffc600",
    Instance = "#61a1f1",
    EnumItem = "#61a1f1",
    boolean = "#ff1a1a",
    ["nil"] = "#ffc600",
}
Imgui:NewWidgetDefinition("PropertyLabel", {
    Construct = function(a1, a2, a3, a4) -- Line: 19 -- upvalues: u8 (val), Imgui (val) -- types: a2: userdata, a3: userdata, a4: string
        local v1 = a3[a4]
        local v2 = tostring(v1)
        local v3 = typeof(v1)
        if v3 == "string" then
            v2 = ("\"%*\""):format(v2)
        end
        if u8[v3] then
            v2 = ("<font color=\"%*\">%*</font>"):format(u8[v3], v2)
        end
        local Frame = Instance.new("Frame")
        Frame.Name = ("ExplorerHorizontal (%*)"):format(a1.ID)
        Frame.Size = UDim2.new(1, 0, 0, 15)
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.Active = true
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Name = "UIListLayout"
        UIListLayout.Padding = UDim.new(0, 2)
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = ("Label (%*)"):format(a1.ID)
        TextLabel.Size = UDim2.fromScale(0.35, 1)
        TextLabel.Text = ("<b>%*</b>"):format(a4)
        TextLabel.RichText = true
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.Parent = Frame
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        local TextLabel_2 = Instance.new("TextLabel")
        TextLabel_2.Name = ("Label (%*)"):format(a1.ID)
        TextLabel_2.Size = UDim2.fromScale(0.65, 1)
        TextLabel_2.Position = UDim2.fromScale(0.35, 0)
        TextLabel_2.Text = ("<i>%*</i> [%*]"):format(v3, v2)
        TextLabel_2.RichText = true
        TextLabel_2.BackgroundTransparency = 1
        TextLabel_2.BorderSizePixel = 0
        TextLabel_2.Parent = Frame
        TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
        Imgui.applyTextStyle(TextLabel)
        Imgui.applyTextStyle(TextLabel_2)
        a1.TopInstance = Frame
        Frame.Parent = a2
        return Frame
    end,
    Update = function(a1, a2, a3) end,
})
return nil