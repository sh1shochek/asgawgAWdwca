-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Widgets.KeyboardInput
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Widgets.KeyboardInput
-- Decompile time: 1.18 ms

local UserInputService = game:GetService("UserInputService")
local Parent = script.Parent.Parent.Parent
if not require(Parent.Parent.Shared.Constants).DEFAULT_WIDGETS_ENABLED then
    return nil
end
local Widget = require(Parent.Widget)
local u19 = {
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.Backspace] = "<-",
    [Enum.KeyCode.BackSlash] = "|",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Comma] = ".",
    [Enum.KeyCode.Period] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.Semicolon] = ";",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.LeftShift] = "LS",
    [Enum.KeyCode.LeftAlt] = "LA",
    [Enum.KeyCode.LeftControl] = "LC",
    [Enum.KeyCode.RightShift] = "RS",
    [Enum.KeyCode.RightAlt] = "RA",
    [Enum.KeyCode.RightControl] = "RC",
    [Enum.KeyCode.Space] = "⬆️",
}

local function createKeyVisual(a1) -- Line: 51 -- upvalues: u19 (val)
    local Frame = Instance.new("Frame")
    Frame.Name = "Key"
    Frame.Size = UDim2.fromOffset(32, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(49, 47, 40)
    Frame.BorderSizePixel = 0
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "KeyLabel"
    TextLabel.AutoLocalize = false
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    local v1 = u19[a1] or tostring(a1.Name)
    TextLabel.Text = v1
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 24
    TextLabel.BackgroundTransparency = 1
    TextLabel.LayoutOrder = 1
    TextLabel.Parent = Frame
    return Frame
end

Widget.new("Keyboard Input", function(a1) -- Line: 78 -- upvalues: UserInputService (val), createKeyVisual (val) -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = "MinimalContent"
    Frame.AnchorPoint = Vector2.new(0, 1)
    Frame.Position = UDim2.new(0, 8, 1, -88)
    Frame.Size = UDim2.fromOffset(48, 48)
    Frame.AutomaticSize = Enum.AutomaticSize.X
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Content"
    Frame_2.Size = UDim2.fromOffset(48, 48)
    Frame_2.AutomaticSize = Enum.AutomaticSize.XY
    Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BackgroundTransparency = 0.5
    Frame_2.Visible = false
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)
    UIPadding.Parent = Frame_2
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.Parent = Frame_2
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame_2
    Frame_2.Parent = Frame
    Frame.Parent = a1
    local u72 = 0
    local u78 = UserInputService.InputBegan:Connect(function(a1) -- Line: 122 -- upvalues: createKeyVisual (upval), Frame_2 (val), u72 (ref) -- types: a1: userdata
        if a1.KeyCode == Enum.KeyCode.Unknown then
            return
        end
        local u5 = createKeyVisual(a1.KeyCode)
        u5.Parent = Frame_2
        u72 = u72 + 1
        Frame_2.Visible = true
        task.delay(1.7, function() -- Line: 133 -- upvalues: u5 (val), u72 (upval), Frame_2 (upval)
            u5:Destroy()
            u72 = u72 - 1
            if u72 <= 0 and Frame_2 then
                Frame_2.Visible = false
            end
        end)
    end)
    return function() -- Line: 145 -- upvalues: Frame (ref), u78 (ref)
        Frame:Destroy()
        Frame = nil
        u78:Disconnect()
        u78 = nil
    end
end)
return nil