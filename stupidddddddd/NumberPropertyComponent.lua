-- ReplicatedStorage.Packages.DebugTools.Client.Components.NumberPropertyComponent
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Components.NumberPropertyComponent
-- Decompile time: 0.71 ms

local Parent_2 = script.Parent.Parent
local Style = require(Parent_2.Style)
return function(a1, a2) -- Line: 15 -- upvalues: Style (val) -- types: a1: table, a2: function
    local u3 = a1.Value or 0
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Argument [number]"
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
    local v1 = a1.Default and tostring(a1.Default) or "number"
    TextBox.PlaceholderText = v1
    TextBox.Text = tostring(u3)
    TextBox.TextColor3 = Style.COLOR_WHITE
    TextBox.TextSize = 12
    TextBox.TextWrapped = true
    TextBox.AutomaticSize = Enum.AutomaticSize.Y
    TextBox.BackgroundColor3 = Style.BACKGROUND_DARK
    TextBox.BorderSizePixel = 0
    TextBox.AutoLocalize = false
    TextBox.Parent = TextLabel
    local u78 = (TextBox:GetPropertyChangedSignal("Text")):Connect(function() -- Line: 51 -- upvalues: TextBox (val), u3 (ref), a2 (val)
        local v1 = tonumber(TextBox.Text)
        if not v1 then
            TextBox.Text = tostring(u3)
            return
        end
        u3 = v1
        a2(v1)
    end)
    TextLabel.Parent = a1.Parent
    return function() -- Line: 65 -- upvalues: TextLabel (val), u78 (val)
        TextLabel:Destroy()
        u78:Disconnect()
    end
end