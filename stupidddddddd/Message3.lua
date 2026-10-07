-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Console.Message
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Console.Message
-- Decompile time: 1.94 ms

local Parent_4 = script.Parent.Parent.Parent.Parent
local Style = require(Parent_4.Style)
local u8 = {INFO = Style.COLOR_WHITE}
u8.ERROR = Color3.fromRGB(255, 81, 70)
u8.WARNING = Color3.fromRGB(243, 173, 82)
local u20 = {internal = {}, prototype = {}, interface = {}}

function u20.internal.createMessageFrame(a1, a2) -- Line: 42
    -- upvalues: Style (val), u8 (val)
    local COLOR_GREEN = a2 and Style.COLOR_GREEN or Style.COLOR_BLUE
    local v1 = true
    if a1.ContentType ~= "WARNING" then
        v1 = a1.ContentType == "ERROR"
    end
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "Console Message"
    TextButton.AutoLocalize = false
    TextButton.Size = UDim2.new(1, 0, 0, 12)
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", v1 and Enum.FontWeight.Bold or Enum.FontWeight.Regular)
    TextButton.BackgroundColor3 = COLOR_GREEN
    TextButton.BackgroundTransparency = 0.8
    TextButton.Text = a1.ContentShort
    TextButton.TextSize = 12
    TextButton.TextTruncate = Enum.TextTruncate.AtEnd
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.TextColor3 = u8[a1.ContentType]
    TextButton.BorderSizePixel = 0
    TextButton.AutomaticSize = Enum.AutomaticSize.Y
    a1.MessageTextButton = TextButton
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.Transparency = 0.6
    UIStroke.Parent = TextButton
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "More"
    TextLabel.AutoLocalize = false
    TextLabel.AnchorPoint = Vector2.new(1, 0)
    TextLabel.Position = UDim2.fromScale(1, 0)
    TextLabel.Size = UDim2.fromOffset(0, 12)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextLabel.Text = "..."
    TextLabel.TextColor3 = Style.COLOR_WHITE
    TextLabel.TextSize = 14
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.Visible = false
    TextLabel.Parent = TextButton
    a1.MoreLabel = TextLabel
    local TextLabel_2 = Instance.new("TextLabel")
    TextLabel_2.Name = "TextLabel"
    TextLabel_2.AutoLocalize = false
    TextLabel_2.AnchorPoint = Vector2.new(1, 0)
    TextLabel_2.Position = UDim2.new(1, -24, 0, 0)
    TextLabel_2.Size = UDim2.fromScale(0, 1)
    TextLabel_2.FontFace = Style.FONT_BOLD
    TextLabel_2.Text = "x1"
    TextLabel_2.TextColor3 = Style.COLOR_WHITE
    TextLabel_2.TextSize = 12
    TextLabel_2.AutomaticSize = Enum.AutomaticSize.X
    TextLabel_2.BackgroundColor3 = Style.COLOR_BLACK
    TextLabel_2.BackgroundTransparency = 0.25
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.Visible = false
    TextLabel_2.Parent = TextButton
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.PaddingRight = UDim.new(0, 2)
    UIPadding.Parent = TextLabel_2
    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.AnchorPoint = Vector2.new(1, 0)
    Frame.BackgroundColor3 = COLOR_GREEN
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(0, 4, 1, 0)
    Frame.Parent = TextButton
    a1.CountLabel = TextLabel_2
end

function u20.prototype.SetParent(a1, a2) -- Line: 125 -- types: a1: table, a2: userdata
    a1.MessageTextButton.Parent = a2
end

function u20.prototype:Destroy() -- Line: 129
    self.MessageTextButton:Destroy()
    self.MessageTextButton = nil
    self._TextButtonActivatedConnection:Disconnect()
    self._TextButtonActivatedConnection = nil
end

function u20.prototype.Concatenate(a1, a2) -- Line: 137 -- types: a1: table, a2: string
    a1.Content = a1.Content .. a2
    local v1 = string.find(a1.Content, "\n") or 0
    local Content_2 = v1 > 0 and string.sub(a1.Content, 0, v1 - 1) or a1.Content
    a1.ContentShort = Content_2
    a1.CanExpand = v1 > 0
    a1.MoreLabel.Visible = v1 ~= nil
    local MessageTextButton = a1.MessageTextButton
    local Content_3 = a1.Expanded and a1.Content or a1.ContentShort
    MessageTextButton.Text = Content_3
end

function u20.prototype.IncreaseCount(a1, a2) -- Line: 151 -- types: a1: table, a2: number?
    a1.Amount = a1.Amount + (a2 or 1)
    a1.CountLabel.Visible = true
    a1.CountLabel.Text = ("x%*"):format(a1.Amount)
end

function u20.prototype.ChangeType(a1, a2) -- Line: 158
    -- upvalues: u8 (val), Style (val)
    a1.ContentType = a2
    local MessageTextButton = a1.MessageTextButton
    local PRIMARY_DARK = u8[a1.ContentType] or Style.PRIMARY_DARK
    MessageTextButton.BackgroundColor3 = PRIMARY_DARK
end

function u20.prototype:Expand() -- Line: 163
    if not self.CanExpand then
        return
    end
    self.Expanded = not self.Expanded
    local MessageTextButton = self.MessageTextButton
    local Content = self.Expanded and self.Content or self.ContentShort
    MessageTextButton.Text = Content
end

function u20.interface.new(a1, a2, a3, a4) -- Line: 173
    -- upvalues: u20 (val)
    local v1 = a3 or false
    local v2 = string.find(a1, "\n")
    local v3 = v2 and string.sub(a1, 0, v2 - 1) or a1
    local v4 = {
        Expanded = false,
        Amount = 1,
        Content = a1,
        ContentShort = v3,
        ContentType = a2,
        ServerSide = v1,
        CanExpand = v2 ~= nil,
        Timestamp = a4 or os.clock(),
    }
    local v5 = {__index = u20.prototype}
    local u41 = setmetatable(v4, v5)
    u20.internal.createMessageFrame(u41, v1)
    u41.MoreLabel.Visible = u41.CanExpand
    u41._TextButtonActivatedConnection = u41.MessageTextButton.Activated:Connect(function() -- Line: 202 -- upvalues: u41 (val)
        u41:Expand()
    end)
    return u41
end

return u20.interface