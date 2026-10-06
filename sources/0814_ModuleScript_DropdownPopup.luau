-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local GuiInset = GuiService:GetGuiInset();
local Parent = script.Parent.Parent;
local Signal = require(Parent.Parent.Shared.Signal);
local Constants = require(Parent.Parent.Shared.Constants);
local Style = require(Parent.Style);
local u1 = {
    prototype = {},
    interface = {}
};

function u1.prototype.IsPointInDropdown(p2: table, p3) -- Line: 19
    -- upvalues: GuiInset (copy)
    local AbsoluteSize = p2.DropdownFrame.AbsoluteSize;
    local v4 = p3 - (p2.DropdownFrame.AbsolutePosition + GuiInset);
    local v5;

    if v4.X >= 0 and (v4.X <= AbsoluteSize.X and v4.Y >= 0) then
        v5 = v4.Y <= AbsoluteSize.Y;
    else
        v5 = false;
    end;

    return v5;
end;

function u1.prototype.Destroy(p6) -- Line: 31
    p6.Closed:Fire();
    p6.Closed:Destroy();
    p6.ScreenGui:Destroy();
    p6.InputEndedConnection:Disconnect();
    p6.EntrySelected:Destroy();

    for _, v in p6.OptionSelectedConnections do
        v:Disconnect();
    end;
end;

function u1.interface.new(p7: userdata, p8: table, p9: string) -- Line: 44
    -- upvalues: Signal (copy), GuiInset (copy), Constants (copy), Style (copy), Players (copy), u1 (copy), UserInputService (copy)
    local u10 = Signal.new();
    local v11 = Signal.new();
    local v12 = p7.AbsolutePosition + GuiInset;
    local AbsoluteSize = p7.AbsoluteSize;
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "Dropdown";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.DisplayOrder = Constants.DROPDOWN_DISPLAY_ORDER;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    local Frame = Instance.new("Frame");
    Frame.Name = "Frame";
    Frame.AutomaticSize = Enum.AutomaticSize.Y;
    Frame.Position = UDim2.fromOffset(v12.X, v12.Y + AbsoluteSize.Y);
    Frame.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = ScreenGui;
    Instance.new("UIListLayout").Parent = Frame;
    local table_create_ret = table.create(#p8);
    local u13 = nil;

    for _, v in p8 do
        local TextButton = Instance.new("TextButton");
        TextButton.AutoLocalize = false;
        TextButton.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y);
        TextButton.BackgroundColor3 = Style.BACKGROUND_DARK;
        TextButton.BorderSizePixel = 0;
        TextButton.Text = v;
        TextButton.TextColor3 = Style.COLOR_WHITE;
        TextButton.FontFace = Style.FONT;
        TextButton.TextSize = 12;
        TextButton.Parent = Frame;
        table.insert(table_create_ret, TextButton.Activated:Connect(function() -- Line: 86
            -- upvalues: u10 (copy), v (copy), u13 (ref)
            u10:Fire(v);
            u13:Destroy();
        end));
    end;

    ScreenGui.Parent = Players.LocalPlayer.PlayerGui;
    local u14 = setmetatable({
        Value = p9,
        Parent = p7,
        Options = p8,
        ScreenGui = ScreenGui,
        DropdownFrame = Frame,
        EntrySelected = u10,
        OptionSelectedConnections = table_create_ret,
        Closed = v11
    }, {
        __index = u1.prototype
    });
    task.defer(function() -- Line: 109
        -- upvalues: u14 (ref), UserInputService (ref), GuiInset (ref)
        local u15 = true;
        u14.InputEndedConnection = UserInputService.InputEnded:Connect(function(p16: userdata) -- Line: 111
            -- upvalues: GuiInset (ref), u15 (ref), u14 (ref)
            if p16.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return;
            end;

            if not (u15 or u14:IsPointInDropdown(Vector2.new(p16.Position.X, p16.Position.Y) + GuiInset)) then
                u14:Destroy();
            end;

            u15 = false;
        end);
    end);

    return u14;
end;

return u1.interface;