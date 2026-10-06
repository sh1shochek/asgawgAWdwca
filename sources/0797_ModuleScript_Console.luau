-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local LogService = game:GetService("LogService");
local Parent = script.Parent.Parent.Parent;
local Shared = Parent.Parent.Shared;
local Tab = require(Parent.Tab);
local Style = require(Parent.Style);
local Networking = require(Parent.Networking);
local Signal = require(Shared.Signal);
local script_Message = require(script.Message);
local script_OutputModal = require(script.OutputModal);
local u1 = {
    [Enum.MessageType.MessageError] = "ERROR",
    [Enum.MessageType.MessageWarning] = "WARNING",
    [Enum.MessageType.MessageOutput] = "INFO",
    Default = "INFO"
};
table.freeze(u1);
local u2 = {
    internal = {
        LatestMessage = nil,
        ParsingMessageStack = false,
        BreakpointNumber = 0,
        Messages = {},
        Interface = {
            ConsoleFrame = nil,
            MessagesScrollingFrame = nil
        }
    },
    interface = {
        MessageAdded = Signal.new()
    }
};

function u2.internal.mergeLatestExactMessages() -- Line: 45
    -- upvalues: u2 (copy)
    local Messages = u2.internal.Messages;
    local v3 = #Messages;

    if v3 < 2 then
        return;
    end;

    local v4 = Messages[v3 - 1];
    local v5 = Messages[v3];

    if v5.ContentType == v4.ContentType and v5.Content == v4.Content then
        v4:IncreaseCount();
        v5:Destroy();
        table.remove(Messages, table.find(Messages, v5));
        u2.internal.LatestMessage = v4;
    end;
end;

function u2.internal.createModuleInterface() -- Line: 69
    -- upvalues: Style (copy), u2 (copy), script_OutputModal (copy)
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Parent = script;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Messages";
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -20);
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.BackgroundColor3 = Style.COLOR_BLACK;
    ScrollingFrame.BackgroundTransparency = 0.5;
    ScrollingFrame.TopImage = ScrollingFrame.MidImage;
    ScrollingFrame.BottomImage = ScrollingFrame.MidImage;
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 1);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = ScrollingFrame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 8);
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.Parent = ScrollingFrame;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingBottom = UDim.new(0, 8);
    UIPadding2.PaddingLeft = UDim.new(0, 8);
    UIPadding2.PaddingRight = UDim.new(0, 8);
    UIPadding2.PaddingTop = UDim.new(0, 10);
    UIPadding2.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Bottom Buttons";
    Frame2.AnchorPoint = Vector2.new(0, 1);
    Frame2.Position = UDim2.new(0, 0, 1, 0);
    Frame2.Size = UDim2.new(1, 0, 0, 12);
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.Name = "UIListLayout";
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    UIListLayout2.Padding = UDim.new(0, 8);
    UIListLayout2.Parent = Frame2;
    local TextButton = Instance.new("TextButton");
    TextButton.Size = UDim2.fromOffset(0, 12);
    TextButton.AutoLocalize = false;
    TextButton.BackgroundColor3 = Style.COLOR_RED;
    TextButton.AutomaticSize = Enum.AutomaticSize.X;
    TextButton.BorderSizePixel = 0;
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextButton.Text = "Clear";
    TextButton.TextSize = 12;
    TextButton.LayoutOrder = 3;
    TextButton.Parent = Frame2;
    local UIPadding3 = Instance.new("UIPadding");
    UIPadding3.Name = "UIPadding";
    UIPadding3.PaddingLeft = UDim.new(0, 8);
    UIPadding3.PaddingRight = UDim.new(0, 8);
    UIPadding3.Parent = TextButton;
    TextButton.Activated:Connect(function() -- Line: 147
        -- upvalues: u2 (ref)
        u2.interface:ClearOutput();
    end);
    local TextButton2 = Instance.new("TextButton");
    TextButton2.AutoLocalize = false;
    TextButton2.Size = UDim2.fromOffset(0, 12);
    TextButton2.BackgroundColor3 = Style.TAB_FOCUSED_BACKGROUND;
    TextButton2.AutomaticSize = Enum.AutomaticSize.X;
    TextButton2.BorderSizePixel = 0;
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextButton2.Text = "Breakpoint (1)";
    TextButton2.TextSize = 12;
    TextButton2.LayoutOrder = 1;
    TextButton2.Parent = Frame2;
    local UIPadding4 = Instance.new("UIPadding");
    UIPadding4.Name = "UIPadding";
    UIPadding4.PaddingLeft = UDim.new(0, 8);
    UIPadding4.PaddingRight = UDim.new(0, 8);
    UIPadding4.Parent = TextButton2;
    TextButton2.Activated:Connect(function() -- Line: 169
        -- upvalues: u2 (ref), TextButton2 (copy)
        local internal = u2.internal;
        internal.BreakpointNumber = internal.BreakpointNumber + 1;
        TextButton2.Text = `Breakpoint ({u2.internal.BreakpointNumber + 1})`;
        u2.interface:AddMessage(`Breakpoint {u2.internal.BreakpointNumber}`, Enum.MessageType.MessageInfo, false);
    end);
    local TextButton3 = Instance.new("TextButton");
    TextButton3.AutoLocalize = false;
    TextButton3.Size = UDim2.fromOffset(0, 12);
    TextButton3.BackgroundColor3 = Style.TAB_FOCUSED_BACKGROUND;
    TextButton3.AutomaticSize = Enum.AutomaticSize.X;
    TextButton3.BorderSizePixel = 0;
    TextButton3.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextButton3.Text = "Output Log";
    TextButton3.TextSize = 12;
    TextButton3.LayoutOrder = 2;
    TextButton3.Parent = Frame2;
    local UIPadding5 = Instance.new("UIPadding");
    UIPadding5.Name = "UIPadding";
    UIPadding5.PaddingLeft = UDim.new(0, 8);
    UIPadding5.PaddingRight = UDim.new(0, 8);
    UIPadding5.Parent = TextButton3;
    TextButton3.Activated:Connect(function() -- Line: 199
        -- upvalues: script_OutputModal (ref), u2 (ref), Frame (copy)
        local u6 = script_OutputModal.new(u2.interface:GetOutputLog());
        u6:ParentTo(Frame);
        u6.CloseActivated:Connect(function() -- Line: 202
            -- upvalues: u6 (ref)
            u6:Destroy();
            u6 = nil;
        end);
    end);
    u2.internal.Interface.ConsoleFrame = Frame;
    u2.internal.Interface.MessagesScrollingFrame = ScrollingFrame;
end;

function u2.interface.GetOutputLog(p7) -- Line: 212
    -- upvalues: Players (copy), u2 (copy)
    local os_date_ret = os.date("*t");
    local v8 = `{string.format("%02d", os_date_ret.hour)}:{string.format("%02d", os_date_ret.min)}:{string.format("%02d", os_date_ret.sec)}/{string.format("%02d", os_date_ret.day)}.{string.format("%02d", os_date_ret.month)}.{os_date_ret.year}`;
    local v9 = `p{game.PlaceId}_v{game.PlaceVersion}_{os.time()}\nGenerated at [{v8}] by {Players.LocalPlayer.Name}@{Players.LocalPlayer.DisplayName}\n`;

    for _, v in u2.internal.Messages do
        local v10 = (v.Timestamp - math.floor(v.Timestamp)) * 1000;
        local math_floor_ret = math.floor(v10);
        local v11 = tostring(math_floor_ret);
        v9 = v9 .. `{v.Amount > 1 and (`[x{v.Amount}]` or "") or ""}[{v.ServerSide and "SERVER" or "CLIENT"}][{os.date("%X", v.Timestamp)}.{v11}][{v.ContentType}] {v.Content}\n`;
    end;

    return v9;
end;

function u2.internal.Init(p12) -- Line: 230
    -- upvalues: u2 (copy), LogService (copy), Networking (copy)
    u2.internal.createModuleInterface();

    for _, v in LogService:GetLogHistory() do
        u2.interface:AddMessage(v.message, v.messageType, false, v.timestamp);
    end;

    LogService.MessageOut:Connect(function(p13: string, p14: any) -- Line: 237
        -- upvalues: u2 (ref)
        u2.interface:AddMessage(p13, p14, false);
    end);
    Networking:SubscribeToTopic("console_messages", function(p15: any, p16: string, p17: number) -- Line: 243
        -- upvalues: u2 (ref)
        u2.interface:AddMessage(p16, p15, true, p17);
    end);
end;

function u2.internal.MountInterface(p18: table, p19: userdata) -- Line: 249
    -- upvalues: u2 (copy)
    if not u2.internal.Interface.ConsoleFrame then
        return;
    end;

    u2.internal.Interface.ConsoleFrame.Parent = p19;
end;

function u2.internal.UnmountInterface(p20) -- Line: 257
    -- upvalues: u2 (copy)
    if not u2.internal.Interface.ConsoleFrame then
        return;
    end;

    u2.internal.Interface.ConsoleFrame.Parent = script;
end;

function u2.interface.AddMessage(p21: table, p22: string, p23: any, p24: boolean, p25: number?) -- Line: 265
    -- upvalues: u2 (copy), u1 (copy), script_Message (copy)
    if u2.internal.LatestMessage and p23 == Enum.MessageType.MessageInfo then
        if p22 == "Stack Begin" then
            u2.internal.ParsingMessageStack = true;

            if u2.internal.LatestMessage.ContentType == "INFO" then
                u2.internal.LatestMessage:ChangeType("ERROR");
            end;

            return;
        end;

        if p22 == "Stack End" then
            u2.internal.ParsingMessageStack = false;

            return;
        end;

        if u2.internal.ParsingMessageStack then
            u2.internal.LatestMessage:Concatenate((`\n  ╠ {p22}`));
            u2.internal.mergeLatestExactMessages();

            return;
        end;
    end;

    local v26 = u1[p23] or u1.Default;
    local v27 = script_Message.new(p22, v26, p24, p25);
    v27:SetParent(u2.internal.Interface.MessagesScrollingFrame);
    table.insert(u2.internal.Messages, v27);

    if #u2.internal.Messages > 400 then
        u2.internal.Messages[1]:Destroy();
        table.remove(u2.internal.Messages, 1);
    end;

    u2.internal.LatestMessage = v27;
    u2.internal.mergeLatestExactMessages();
    u2.interface.MessageAdded:Fire(p22, v26);
end;

function u2.interface.ClearOutput(p28) -- Line: 312
    -- upvalues: u2 (copy)
    for _, v in u2.internal.Messages do
        v:Destroy();
    end;

    u2.internal.Messages = {};
    u2.internal.ParsingMessageStack = false;
end;

u2.internal:Init();
Tab.new("Console", function(p29: userdata) -- Line: 323
    -- upvalues: u2 (copy)
    u2.internal:MountInterface(p29);

    return function() -- Line: 326
        -- upvalues: u2 (ref)
        u2.internal:UnmountInterface();
    end;
end);

return u2.interface;