-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Widgets.CodeWarnings
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Widgets.CodeWarnings
-- Decompile time: 1.50 ms

local RunService = game:GetService("RunService")
local Parent = script.Parent.Parent.Parent
if not require(Parent.Parent.Shared.Constants).DEFAULT_WIDGETS_ENABLED then
    return nil
end
local Console = require(Parent.Builtin.Tabs.Console)
local Widget = require(Parent.Widget)
local Style = require(Parent.Style)
local u27 = {internal = {OnScreenMessages = {}}}

function u27.internal.createOutputLabel() -- Line: 32 -- upvalues: Style (val)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "OutputLabel"
    TextLabel.AutoLocalize = false
    TextLabel.FontFace = Style.FONT_BOLD
    TextLabel.TextColor3 = Color3.fromRGB(255, 81, 70)
    TextLabel.TextSize = 14
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY
    TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BackgroundTransparency = 0.5
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingBottom = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.Parent = TextLabel
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.Parent = TextLabel
    local UISizeConstraint = Instance.new("UISizeConstraint")
    UISizeConstraint.Name = "UISizeConstraint"
    UISizeConstraint.MaxSize = Vector2.new(500, (1 / 0))
    UISizeConstraint.Parent = TextLabel
    return TextLabel
end

function u27.internal.getLatestMessageData() -- Line: 66 -- upvalues: u27 (val)
    local v1 = #u27.internal.OnScreenMessages
    if v1 == 0 then
        return
    end
    return u27.internal.OnScreenMessages[v1]
end

function u27.internal.addMessage(a1, a2) -- Line: 75
    -- upvalues: u27 (val), Style (val)
    local v1
    local v2 = u27.internal.getLatestMessageData()
    if v2 and v2.Message == a1 and v2.Type == a2 then
        v2.Amount = v2.Amount + 1
        v2.Lifetime = 6
        v1 = v2.Amount < 99 and tostring(v2.Amount) or "99+"
        v2.TextLabel.Text = ("(x%*) %*"):format(v1, v2.Message)
        return
    end
    v1 = u27.internal.createOutputLabel()
    v1.Text = a1
    if a2 == "WARNING" then
        v1.TextColor3 = Style.COLOR_ORANGE
    elseif a2 == "ERROR" then
        v1.TextColor3 = Style.COLOR_RED
    end
    v1.Parent = u27.internal.ContentFrame
    table.insert(u27.internal.OnScreenMessages, {
        Amount = 1,
        Lifetime = 6,
        Message = a1,
        Type = a2,
        TextLabel = v1,
    })
end

RunService.Heartbeat:Connect(function(a1) -- Line: 106 -- upvalues: u27 (val) -- types: a1: number
    for i, j in u27.internal.OnScreenMessages do
        j.Lifetime = j.Lifetime - a1
        if not (0 < j.Lifetime) then
            j.TextLabel:Destroy()
            table.remove(u27.internal.OnScreenMessages, i)
        end
    end
end)
Widget.new("Code Warnings", function(a1) -- Line: 119 -- upvalues: u27 (val), Console (val) -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = "Content"
    Frame.Position = UDim2.new(0, 8, 0, 48)
    Frame.Size = UDim2.fromOffset(32, 32)
    Frame.BackgroundTransparency = 1
    Frame.AutomaticSize = Enum.AutomaticSize.XY
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame
    Frame.Parent = a1
    u27.internal.ContentFrame = Frame
    local u33 = Console.MessageAdded:Connect(function(a1, a2) -- Line: 137 -- upvalues: u27 (upval) -- types: a1: string, a2: string
        if a2 == "INFO" then
            return
        end
        u27.internal.addMessage(a1, a2)
    end)
    return function() -- Line: 145 -- upvalues: u27 (upval), u33 (val), Frame (val)
        for i, j in u27.internal.OnScreenMessages do
            j.TextLabel:Destroy()
        end
        u27.internal.OnScreenMessages = {}
        u33:Disconnect()
        Frame:Destroy()
    end
end)
return nil