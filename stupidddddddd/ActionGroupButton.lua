-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionGroupButton
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionGroupButton
-- Decompile time: 0.54 ms

local Parent_5 = script.Parent.Parent.Parent.Parent.Parent
local Style = require(Parent_5.Style)
return function(a1, a2, a3, a4) -- Line: 6 -- upvalues: Style (val) -- types: a1: string, a2: userdata, a4: function
    local TextButton = Instance.new("TextButton")
    TextButton.Name = ("Action Group (%*)"):format(a1)
    TextButton.AutoLocalize = false
    TextButton.Size = UDim2.new(1, 0, 0, 18)
    TextButton.FontFace = Style.FONT_BOLD
    TextButton.Text = (" %*"):format(a1)
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 12
    TextButton.TextStrokeTransparency = 0
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.BackgroundColor3 = Style.PRIMARY_DARK
    TextButton.BorderSizePixel = 0
    TextButton.Parent = a2
    local u41 = TextButton.Activated:Connect(function() -- Line: 22 -- upvalues: a4 (val)
        a4()
    end)
    local u45 = a3:Observe(function(a1_2) -- Line: 26 -- upvalues: TextButton (ref), a1 (val), Style (upval) -- types: a1_2: string
        local v1 = TextButton
        local PRIMARY_TEXT = not (a1 ~= a1_2) and Style.PRIMARY_TEXT or Style.PRIMARY_DARK
        v1.BackgroundColor3 = PRIMARY_TEXT
    end)
    return function() -- Line: 30 -- upvalues: u45 (ref), u41 (ref), TextButton (ref)
        u45:Disconnect()
        u45 = nil
        u41:Disconnect()
        u41 = nil
        TextButton:Destroy()
        TextButton = nil
    end
end