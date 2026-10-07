-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Console
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Console
-- Decompile time: 4.27 ms

local Players = game:GetService("Players")
local LogService = game:GetService("LogService")
local Parent = script.Parent.Parent.Parent
local Shared = Parent.Parent.Shared
local Tab = require(Parent.Tab)
local Style = require(Parent.Style)
local Networking = require(Parent.Networking)
local Signal = require(Shared.Signal)
local Message = require(script.Message)
local OutputModal = require(script.OutputModal)
local u36 = {
    [Enum.MessageType.MessageError] = "ERROR",
    [Enum.MessageType.MessageWarning] = "WARNING",
    [Enum.MessageType.MessageOutput] = "INFO",
    ["Default"] = "INFO",
}
table.freeze(u36)
local u47 = {internal = {ParsingMessageStack = false, BreakpointNumber = 0, Messages = {}, Interface = {}}}
u47.interface = {MessageAdded = Signal.new()}

function u47.internal.mergeLatestExactMessages() -- Line: 45 -- upvalues: u47 (val)
    local Messages = u47.internal.Messages
    local v1 = #Messages
    if v1 < 2 then
        return
    end
    local v2 = Messages[v1 - 1]
    local v3 = Messages[v1]
    local v4 = v3.Content == v2.Content
    if v3.ContentType == v2.ContentType and v4 then
        v2:IncreaseCount()
        v3:Destroy()
        table.remove(Messages, table.find(Messages, v3))
        u47.internal.LatestMessage = v2
    end
end

function u47.internal.createModuleInterface() -- Line: 69 -- upvalues: Style (val), u47 (val), OutputModal (val)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = script
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Messages"
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -20)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.BackgroundColor3 = Style.COLOR_BLACK
    ScrollingFrame.BackgroundTransparency = 0.5
    ScrollingFrame.TopImage = ScrollingFrame.MidImage
    ScrollingFrame.BottomImage = ScrollingFrame.MidImage
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Parent = Frame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 1)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.Parent = ScrollingFrame
    local UIPadding_2 = Instance.new("UIPadding")
    UIPadding_2.Name = "UIPadding"
    UIPadding_2.PaddingBottom = UDim.new(0, 8)
    UIPadding_2.PaddingLeft = UDim.new(0, 8)
    UIPadding_2.PaddingRight = UDim.new(0, 8)
    UIPadding_2.PaddingTop = UDim.new(0, 10)
    UIPadding_2.Parent = Frame
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Bottom Buttons"
    Frame_2.AnchorPoint = Vector2.new(0, 1)
    Frame_2.Position = UDim2.new(0, 0, 1, 0)
    Frame_2.Size = UDim2.new(1, 0, 0, 12)
    Frame_2.BackgroundTransparency = 1
    Frame_2.BorderSizePixel = 0
    Frame_2.Parent = Frame
    local UIListLayout_2 = Instance.new("UIListLayout")
    UIListLayout_2.Name = "UIListLayout"
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout_2.Padding = UDim.new(0, 8)
    UIListLayout_2.Parent = Frame_2
    local TextButton_2 = Instance.new("TextButton")
    TextButton_2.Size = UDim2.fromOffset(0, 12)
    TextButton_2.AutoLocalize = false
    TextButton_2.BackgroundColor3 = Style.COLOR_RED
    TextButton_2.AutomaticSize = Enum.AutomaticSize.X
    TextButton_2.BorderSizePixel = 0
    TextButton_2.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextButton_2.Text = "Clear"
    TextButton_2.TextSize = 12
    TextButton_2.LayoutOrder = 3
    TextButton_2.Parent = Frame_2
    local UIPadding_3 = Instance.new("UIPadding")
    UIPadding_3.Name = "UIPadding"
    UIPadding_3.PaddingLeft = UDim.new(0, 8)
    UIPadding_3.PaddingRight = UDim.new(0, 8)
    UIPadding_3.Parent = TextButton_2
    TextButton_2.Activated:Connect(function() -- Line: 147 -- upvalues: u47 (upval)
        u47.interface:ClearOutput()
    end)
    local TextButton = Instance.new("TextButton")
    TextButton.AutoLocalize = false
    TextButton.Size = UDim2.fromOffset(0, 12)
    TextButton.BackgroundColor3 = Style.TAB_FOCUSED_BACKGROUND
    TextButton.AutomaticSize = Enum.AutomaticSize.X
    TextButton.BorderSizePixel = 0
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextButton.Text = "Breakpoint (1)"
    TextButton.TextSize = 12
    TextButton.LayoutOrder = 1
    TextButton.Parent = Frame_2
    local UIPadding_4 = Instance.new("UIPadding")
    UIPadding_4.Name = "UIPadding"
    UIPadding_4.PaddingLeft = UDim.new(0, 8)
    UIPadding_4.PaddingRight = UDim.new(0, 8)
    UIPadding_4.Parent = TextButton
    TextButton.Activated:Connect(function() -- Line: 169 -- upvalues: u47 (upval), TextButton (val)
        local internal = u47.internal
        internal.BreakpointNumber = internal.BreakpointNumber + 1
        TextButton.Text = ("Breakpoint (%*)"):format(u47.internal.BreakpointNumber + 1)
        u47.interface:AddMessage(("Breakpoint %*"):format(u47.internal.BreakpointNumber), Enum.MessageType.MessageInfo, false)
    end)
    local TextButton_3 = Instance.new("TextButton")
    TextButton_3.AutoLocalize = false
    TextButton_3.Size = UDim2.fromOffset(0, 12)
    TextButton_3.BackgroundColor3 = Style.TAB_FOCUSED_BACKGROUND
    TextButton_3.AutomaticSize = Enum.AutomaticSize.X
    TextButton_3.BorderSizePixel = 0
    TextButton_3.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
    TextButton_3.Text = "Output Log"
    TextButton_3.TextSize = 12
    TextButton_3.LayoutOrder = 2
    TextButton_3.Parent = Frame_2
    local UIPadding_5 = Instance.new("UIPadding")
    UIPadding_5.Name = "UIPadding"
    UIPadding_5.PaddingLeft = UDim.new(0, 8)
    UIPadding_5.PaddingRight = UDim.new(0, 8)
    UIPadding_5.Parent = TextButton_3
    TextButton_3.Activated:Connect(function() -- Line: 199 -- upvalues: OutputModal (upval), u47 (upval), Frame (val)
        local u7 = OutputModal.new(u47.interface:GetOutputLog())
        u7:ParentTo(Frame)
        u7.CloseActivated:Connect(function() -- Line: 202 -- upvalues: u7 (ref)
            u7:Destroy()
            u7 = nil
        end)
    end)
    u47.internal.Interface.ConsoleFrame = Frame
    u47.internal.Interface.MessagesScrollingFrame = ScrollingFrame
end

function u47.interface.GetOutputLog(a1) -- Line: 212 -- upvalues: Players (val), u47 (val)
    local v1, v2
    local v3 = os.date("*t")
    local v4 = ("%*:%*:%*/%*.%*.%*"):format(
        string.format("%02d", v3.hour),
        string.format("%02d", v3.min),
        string.format("%02d", v3.sec),
        string.format("%02d", v3.day),
        string.format("%02d", v3.month),
        v3.year
    )
    local v5 = ("p%*_v%*_%*\nGenerated at [%*] by %*@%*\n"):format(
        game.PlaceId,
        game.PlaceVersion,
        os.time(),
        v4,
        Players.LocalPlayer.Name,
        Players.LocalPlayer.DisplayName
    )
    local v6 = nil
    local v7 = nil
    for i, j in u47.internal.Messages, v6, v7 do
        v2 = tostring((math.floor((j.Timestamp - (math.floor(j.Timestamp))) * 1000)))
        v1 = 1 < j.Amount and ("[x%*]"):format(j.Amount) or ""
        v5 = v5 .. ("%*[%*][%*.%*][%*] %*\n"):format(
            v1,
            if not j.ServerSide then "CLIENT" else "SERVER",
            os.date("%X", j.Timestamp),
            v2,
            j.ContentType,
            j.Content
        )
    end
    return v5
end

function u47.internal.Init(a1) -- Line: 230 -- upvalues: u47 (val), LogService (val), Networking (val)
    u47.internal.createModuleInterface()
    for i, j in LogService:GetLogHistory() do
        u47.interface:AddMessage(j.message, j.messageType, false, j.timestamp)
    end
    LogService.MessageOut:Connect(function(a1, a2) -- Line: 237 -- upvalues: u47 (upval) -- types: a1: string
        u47.interface:AddMessage(a1, a2, false)
    end)
    Networking:SubscribeToTopic("console_messages", function(a1, a2, a3) -- Line: 243 -- upvalues: u47 (upval) -- types: a2: string, a3: number
        u47.interface:AddMessage(a2, a1, true, a3)
    end)
end

function u47.internal.MountInterface(a1, a2) -- Line: 249 -- upvalues: u47 (val) -- types: a1: table, a2: userdata
    if not u47.internal.Interface.ConsoleFrame then
        return
    end
    u47.internal.Interface.ConsoleFrame.Parent = a2
end

function u47.internal.UnmountInterface(a1) -- Line: 257 -- upvalues: u47 (val)
    if not u47.internal.Interface.ConsoleFrame then
        return
    end
    u47.internal.Interface.ConsoleFrame.Parent = script
end

function u47.interface.AddMessage(a1, a2, a3, a4, a5) -- Line: 265
    -- upvalues: u47 (val), u36 (val), Message (val)
    if u47.internal.LatestMessage and a3 == Enum.MessageType.MessageInfo then
        if a2 == "Stack Begin" then
            u47.internal.ParsingMessageStack = true
            if u47.internal.LatestMessage.ContentType == "INFO" then
                u47.internal.LatestMessage:ChangeType("ERROR")
            end
            return
        end
        if a2 == "Stack End" then
            u47.internal.ParsingMessageStack = false
            return
        end
        if u47.internal.ParsingMessageStack then
            u47.internal.LatestMessage:Concatenate((("\n  ╠ %*"):format(a2)))
            u47.internal.mergeLatestExactMessages()
            return
        end
    end
    local Default = u36[a3] or u36.Default
    local v1 = Message.new(a2, Default, a4, a5)
    v1:SetParent(u47.internal.Interface.MessagesScrollingFrame)
    table.insert(u47.internal.Messages, v1)
    if #u47.internal.Messages > 400 then
        u47.internal.Messages[1]:Destroy()
        table.remove(u47.internal.Messages, 1)
    end
    u47.internal.LatestMessage = v1
    u47.internal.mergeLatestExactMessages()
    u47.interface.MessageAdded:Fire(a2, Default)
end

function u47.interface.ClearOutput(a1) -- Line: 312 -- upvalues: u47 (val)
    for i, j in u47.internal.Messages do
        j:Destroy()
    end
    u47.internal.Messages = {}
    u47.internal.ParsingMessageStack = false
end

u47.internal:Init()
Tab.new("Console", function(a1) -- Line: 323 -- upvalues: u47 (val) -- types: a1: userdata
    u47.internal:MountInterface(a1)
    return function() -- Line: 326 -- upvalues: u47 (upval)
        u47.internal:UnmountInterface()
    end
end)
return u47.interface