-- ReplicatedStorage.Packages.DebugTools.Client.Components.StringPropertyComponent
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Components.StringPropertyComponent
-- Decompile time: 0.50 ms

local Parent_2 = script.Parent.Parent
local Style = require(Parent_2.Style)
return function(a1, a2) -- Line: 15 -- upvalues: Style (val) -- types: a1: table, a2: function
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Argument [string]"
    TextLabel.Size = UDim2.new(1, 0, 0, 16)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextLabel.Text = a1.PropertyText
    TextLabel.TextColor3 = Style.COLOR_WHITE
    TextLabel.TextSize = 12
    TextLabel.TextStrokeTransparency = 0.75
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.LayoutOrder = 1
    TextLabel.AutoLocalize = false
    local TextBox = Instance.new("TextBox")
    TextBox.Name = "Value [TextBox]"
    TextBox.Position = UDim2.fromScale(0.5, 0)
    TextBox.Size = UDim2.fromScale(0.5, 1)
    TextBox.ClearTextOnFocus = false
    TextBox.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextBox.PlaceholderText = a1.Default or "string"
    TextBox.Text = a1.Value or ""
    TextBox.TextColor3 = Style.COLOR_WHITE
    TextBox.TextSize = 12
    TextBox.TextWrapped = true
    TextBox.AutomaticSize = Enum.AutomaticSize.Y
    TextBox.BackgroundColor3 = Style.BACKGROUND_DARK
    TextBox.BorderSizePixel = 0
    TextBox.AutoLocalize = false
    TextBox.Parent = TextLabel
    local u63 = (TextBox:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 49 -- upvalues: a2 (val), TextBox (val)
        a2(TextBox.Text)
    end)
    TextLabel.Parent = a1.Parent
    return function() -- Line: 55 -- upvalues: TextLabel (val), u63 (val)
        TextLabel:Destroy()
        u63:Disconnect()
    end
end