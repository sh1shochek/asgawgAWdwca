-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Console.OutputModal
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Console.OutputModal
-- Decompile time: 1.19 ms

local Shared = script.Parent.Parent.Parent.Parent.Parent.Shared
local Signal = require(Shared.Signal)
local u10 = {internal = {}, prototype = {}, interface = {}}

function u10.internal.createModalInterface(a1, a2) -- Line: 12 -- types: a2: string
    local Frame = Instance.new("Frame")
    Frame.Name = "Output Modal"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.fromRGB(79, 88, 105)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderColor3 = Color3.fromRGB(79, 88, 105)
    Frame.BorderSizePixel = 10
    Frame.ZIndex = 10
    local TextButton = Instance.new("TextButton")
    TextButton.AutoLocalize = false
    TextButton.Position = UDim2.fromOffset(-8, -8)
    TextButton.Size = UDim2.new(1, 16, 1, 16)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = ""
    TextButton.ZIndex = -1
    TextButton.Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.AutoLocalize = false
    TextLabel.Name = "TextLabel"
    TextLabel.AnchorPoint = Vector2.new(0, 1)
    TextLabel.Position = UDim2.fromScale(0, 1)
    TextLabel.Size = UDim2.new(1, 0, 0, 12)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextLabel.Text = "Copy the above message and paste it into a file."
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 12
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Parent = Frame
    local TextBox = Instance.new("TextBox")
    TextBox.AutoLocalize = false
    TextBox.Name = "TextBox"
    TextBox.Position = UDim2.fromOffset(0, 16)
    TextBox.Size = UDim2.new(1, 0, 1, -30)
    TextBox.ClearTextOnFocus = false
    TextBox.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextBox.Text = a2
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 12
    TextBox.TextTruncate = Enum.TextTruncate.AtEnd
    TextBox.TextWrapped = true
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.TextYAlignment = Enum.TextYAlignment.Top
    TextBox.Active = false
    TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextBox.BackgroundTransparency = 0.5
    TextBox.BorderSizePixel = 0
    TextBox.TextEditable = false
    TextBox.ZIndex = 10
    TextBox.Parent = Frame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)
    UIPadding.Parent = Frame
    local TextButton_2 = Instance.new("TextButton")
    TextButton_2.AutoLocalize = false
    TextButton_2.Name = "Close Button"
    TextButton_2.AnchorPoint = Vector2.new(1, 0)
    TextButton_2.Position = UDim2.new(1, 8, 0, -8)
    TextButton_2.Size = UDim2.fromOffset(32, 16)
    TextButton_2.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextButton_2.Text = "X"
    TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextButton_2.TextSize = 16
    TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 81, 70)
    TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton_2.BorderSizePixel = 0
    TextButton_2.Parent = Frame
    a1.CloseButtonActivatedConnection = TextButton_2.Activated:Connect(function() -- Line: 96 -- upvalues: a1 (val)
        a1.CloseActivated:Fire()
    end)
    return Frame
end

function u10.prototype.ParentTo(a1, a2) -- Line: 103 -- types: a1: table, a2: userdata
    a1.ModalFrame.Parent = a2
end

function u10.prototype:Destroy() -- Line: 107
    self.ModalFrame:Destroy()
    self.ModalFrame = nil
    self.CloseActivated:Destroy()
    self.CloseActivated = nil
    self.CloseButtonActivatedConnection:Disconnect()
    self.CloseButtonActivatedConnection = nil
end

function u10.interface.new(a1) -- Line: 118 -- upvalues: Signal (val), u10 (val) -- types: a1: string
    local v1 = {CloseActivated = Signal.new()}
    local v2 = {__index = u10.prototype}
    local v3 = setmetatable(v1, v2)
    v3.ModalFrame = u10.internal.createModalInterface(v3, a1)
    return v3
end

return u10.interface