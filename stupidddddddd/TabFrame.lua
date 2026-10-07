-- ReplicatedStorage.Packages.DebugTools.Client.Interface.TabFrame
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Interface.TabFrame
-- Decompile time: 0.67 ms

local Parent = script.Parent.Parent
local Shared = Parent.Parent.Shared
local Signal = require(Shared.Signal)
local Style = require(Parent.Style)
local u11 = {prototype = {}, interface = {}}

function u11.prototype.Focus(a1) -- Line: 13 -- upvalues: Style (val)
    a1.TabButton.TextColor3 = Style.TAB_FOCUSED_TEXT
    a1.TabButton.BackgroundColor3 = Style.TAB_FOCUSED_BACKGROUND
end

function u11.prototype.Unfocus(a1) -- Line: 18 -- upvalues: Style (val)
    a1.TabButton.TextColor3 = Style.TAB_NORMAL_TEXT
    a1.TabButton.BackgroundColor3 = Style.TAB_NORMAL_BACKGROUND
end

function u11.prototype:Destroy() -- Line: 23
    self.TabActivated:Destroy()
    self.TabButton:Destroy()
    self.ButtonActivatedConnection:Disconnect()
end

function u11.interface.new(a1, a2) -- Line: 30
    -- upvalues: Style (val), Signal (val), u11 (val)
    local TextButton = Instance.new("TextButton")
    TextButton.Name = a1
    TextButton.AutoLocalize = false
    TextButton.Size = UDim2.fromScale(0, 1)
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextButton.Text = a1
    TextButton.TextColor3 = Style.TAB_NORMAL_TEXT
    TextButton.TextSize = 14
    TextButton.AutomaticSize = Enum.AutomaticSize.X
    TextButton.BackgroundColor3 = Style.TAB_NORMAL_BACKGROUND
    TextButton.BorderSizePixel = 0
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.Parent = TextButton
    TextButton.Parent = a2
    local u34 = Signal.new()
    return (setmetatable({
        Module = a1,
        TabActivated = u34,
        TabButton = TextButton,
        ButtonActivatedConnection = TextButton.Activated:Connect(function() -- Line: 59 -- upvalues: u34 (val)
            u34:Fire()
        end),
    }, {__index = u11.prototype}))
end

return u11.interface