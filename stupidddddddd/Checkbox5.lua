-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.Checkbox
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.Checkbox
-- Decompile time: 1.00 ms

local Imgui = require(script.Parent.Parent.Parent.Imgui)
Imgui:NewWidgetDefinition("Checkbox", {
    Events = {
        activated = {
            Evaluate = function(a1) -- Line: 20
                local Pressed = a1.Pressed
                a1.Pressed = false
                return Pressed
            end,
        },
    },
    Construct = function(a1, a2, a3, a4) -- Line: 29 -- upvalues: Imgui (val) -- types: a2: userdata, a3: string, a4: boolean
        local Frame = Instance.new("Frame")
        Frame.Name = ("Checkbox (%*)"):format(a1.ID)
        Frame.AutomaticSize = Enum.AutomaticSize.XY
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "Text"
        TextLabel.Text = a3
        TextLabel.AutomaticSize = Enum.AutomaticSize.XY
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.LayoutOrder = 1
        Imgui.applyTextStyle(TextLabel)
        TextLabel.Parent = Frame
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Name = "UIListLayout"
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame
        UIListLayout.Padding = UDim.new(0, Imgui:GetConfig().Sizes.ItemPadding.X)
        local TextButton = Instance.new("TextButton")
        TextButton.Name = "TextButton"
        TextButton.AutoLocalize = false
        TextButton.Size = UDim2.fromOffset(18, 18)
        TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
        TextButton.Text = ""
        TextButton.TextSize = 14
        TextButton.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
        TextButton.BorderSizePixel = 0
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        UIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
        UIAspectRatioConstraint.Parent = TextButton
        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = "Status ImageLabel"
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.Image = "rbxassetid://15225522557"
        ImageLabel.ImageColor3 = Imgui:GetConfig().Colors.Checkbox
        ImageLabel.Visible = a4
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Parent = TextButton
        TextButton.Parent = Frame
        Frame.Parent = a2
        a1.CheckboxButton = TextButton
        a1.TextLabel = TextLabel
        a1.StatusImageLabel = ImageLabel
        a1.Status = a4 or true
        a1.PressConnection = TextButton.Activated:Connect(function() -- Line: 89 -- upvalues: a1 (val)
            a1.Pressed = true
            a1.Status = not a1.Status
        end)
        return Frame
    end,
    Deconstruct = function(a1) -- Line: 98
        a1.PressConnection:Disconnect()
    end,
    Update = function(a1, a2, a3) -- Line: 102 -- types: a2: string, a3: boolean
        a1.Status = a3
        a1.TextLabel.Text = a2
        a1.StatusImageLabel.Visible = a3
    end,
})
return nil