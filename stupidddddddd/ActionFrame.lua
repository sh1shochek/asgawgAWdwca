-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionFrame
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionFrame
-- Decompile time: 1.83 ms

local TweenService = game:GetService("TweenService")
local Parent = script.Parent.Parent.Parent.Parent.Parent
local Shared = Parent.Parent.Shared
local Action = require(Shared.Action)
local Console = require(Parent.Builtin.Tabs.Console)
local Style = require(Parent.Style)
local ActionArgument = require(script.Parent.ActionArgument)
return function(a1, a2, a3) -- Line: 21
    -- upvalues: Style (val), ActionArgument (val), TweenService (val), Action (val), Console (val)
    local Frame = Instance.new("Frame")
    Frame.Name = a1.RawName
    Frame.Size = UDim2.fromScale(1, 0)
    Frame.AutomaticSize = Enum.AutomaticSize.Y
    Frame.BackgroundColor3 = Style.BACKGROUND
    Frame.BorderSizePixel = 0
    Frame.LayoutOrder = a3 or 0
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Header"
    TextLabel.AutoLocalize = false
    TextLabel.Size = UDim2.new(1, 0, 0, 16)
    TextLabel.FontFace = Style.FONT_BOLD
    TextLabel.Text = a1.Name
    TextLabel.TextColor3 = Style.COLOR_WHITE
    TextLabel.TextSize = 16
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.LayoutOrder = -2
    local TextLabel_2 = Instance.new("TextLabel")
    TextLabel_2.Name = "Side"
    TextLabel_2.AutoLocalize = false
    TextLabel_2.Size = UDim2.new(1, 0, 0, 14)
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.FontFace = Style.FONT
    TextLabel_2.Text = if not a1.ServerAction then "Client" else "Server"
    local COLOR_RED = a1.ServerAction and Style.COLOR_RED or Style.COLOR_GREEN
    TextLabel_2.TextColor3 = COLOR_RED
    TextLabel_2.TextSize = 12
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel_2.BackgroundColor3 = Style.COLOR_WHITE
    TextLabel_2.Parent = TextLabel
    TextLabel.Parent = Frame
    if a1.Description then
        local TextLabel_3 = Instance.new("TextLabel")
        TextLabel_3.Name = "Description"
        TextLabel_3.AutoLocalize = false
        TextLabel_3.AutomaticSize = Enum.AutomaticSize.Y
        TextLabel_3.Position = UDim2.fromOffset(0, 14)
        TextLabel_3.Size = UDim2.new(1, 0, 0, 12)
        TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
        TextLabel_3.Text = a1.Description
        TextLabel_3.TextColor3 = Style.TAB_NORMAL_TEXT
        TextLabel_3.TextSize = 12
        TextLabel_3.TextStrokeTransparency = 0.75
        TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel_3.TextWrapped = true
        TextLabel_3.BackgroundTransparency = 1
        TextLabel_3.BorderSizePixel = 0
        TextLabel_3.LayoutOrder = -1
        TextLabel_3.Parent = Frame
    end
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingBottom = UDim.new(0, 4)
    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.PaddingRight = UDim.new(0, 4)
    UIPadding.PaddingTop = UDim.new(0, 4)
    UIPadding.Parent = Frame
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "Execute"
    TextButton.AutoLocalize = false
    TextButton.AnchorPoint = Vector2.new(1, 0)
    TextButton.Position = UDim2.new(1, 0, 0, 30)
    TextButton.Size = UDim2.new(1, 0, 0, 14)
    TextButton.FontFace = Style.FONT
    TextButton.Text = "Execute"
    TextButton.TextColor3 = Style.PRIMARY_TEXT
    TextButton.TextSize = 12
    TextButton.BackgroundColor3 = Style.PRIMARY
    TextButton.BorderSizePixel = 0
    TextButton.LayoutOrder = 100
    TextButton.Parent = Frame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame
    Frame.Parent = a2
    local u174 = {}
    local u175 = {}
    if a1.Arguments then
        for i, j in a1.Arguments do
            u174[i] = j.Default
            j.Index = i
            table.insert(u175, (ActionArgument(Frame, j, function(a1) -- Line: 122 -- upvalues: u174 (val), i (val)
                u174[i] = a1
            end)))
        end
    end

    local function flashActionFrame(a1) -- Line: 129
        -- upvalues: Frame (val), TweenService (upval), Style (upval)
        Frame.BorderColor3 = a1
        Frame.BorderSizePixel = 3
        TweenService:Create(
            Frame,
            TweenInfo.new(0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
            {BorderSizePixel = 0, BorderColor3 = Style.BACKGROUND}
        ):Play()
    end

    local u211 = TextButton.Activated:Connect(function() -- Line: 138
        -- upvalues: Action (upval), a1 (val), u174 (val), flashActionFrame (val), Style (upval), Console (upval)
        local v1 = Action:Execute(a1.RawName, u174)
        if v1 == nil then
            v1 = true
        end
        if v1 == true then
            flashActionFrame(Style.COLOR_GREEN)
            return
        end
        if not v1 then
            flashActionFrame(Style.COLOR_RED)
            return
        end
        if typeof(v1) == "string" then
            flashActionFrame(Style.COLOR_ORANGE)
            Console:AddMessage(("Action '%*' outcome: %*"):format(a1.RawName, v1), Enum.MessageType.MessageInfo, false)
        end
    end)
    return function() -- Line: 160 -- upvalues: Frame (val), u211 (val), u175 (val)
        Frame:Destroy()
        u211:Disconnect()
        for i, j in u175 do
            j()
        end
    end
end