-- ReplicatedStorage.Packages.DebugTools.Client.Components.DropdownPropertyComponent
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Components.DropdownPropertyComponent
-- Decompile time: 0.98 ms

local Parent_2 = script.Parent.Parent
local Style = require(Parent_2.Style)
local DropdownPopup = require(script.Parent.DropdownPopup)
return function(a1, a2) -- Line: 17 -- upvalues: Style (val), DropdownPopup (val) -- types: a1: table, a2: function
    local Value = a1.Value
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Dropdown"
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
    TextLabel.LayoutOrder = 4
    TextLabel.AutoLocalize = false
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "Dropdown Click Detector"
    TextButton.Position = UDim2.fromScale(0.5, 0)
    TextButton.Size = UDim2.fromScale(0.5, 1)
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextButton.Text = tostring(Value)
    TextButton.TextColor3 = Style.COLOR_WHITE
    TextButton.TextSize = 12
    TextButton.TextWrapped = true
    TextButton.AutoButtonColor = false
    TextButton.AutomaticSize = Enum.AutomaticSize.Y
    TextButton.BackgroundColor3 = Style.BACKGROUND_DARK
    TextButton.BorderSizePixel = 0
    TextButton.AutoLocalize = false
    TextButton.Parent = TextLabel
    local u56 = false
    local u61 = TextButton.Activated:Connect(function() -- Line: 53 -- upvalues: u56 (ref), a1 (val), Value (ref), DropdownPopup (upval), TextButton (val), a2 (val)
        if not u56 then
            local v1 = #a1.Options
            if not (v1 <= 1) then
                u56 = true
                v1 = table.clone(a1.Options)
                table.remove(v1, table.find(v1, Value))
                local v2 = DropdownPopup.new(TextButton, v1, a1.Value)
                v2.EntrySelected:Connect(function(a1) -- Line: 63 -- upvalues: Value (upval), TextButton (upval), a2 (upval) -- types: a1: string
                    if a1 == Value then
                        return
                    end
                    Value = a1
                    TextButton.Text = a1
                    a2(a1)
                end)
                v2.Closed:Connect(function() -- Line: 73 -- upvalues: u56 (upval)
                    u56 = false
                end)
                return
            end
        end
    end)
    TextLabel.Parent = a1.Parent
    return function() -- Line: 80 -- upvalues: TextLabel (val), u61 (val)
        TextLabel:Destroy()
        u61:Disconnect()
    end
end