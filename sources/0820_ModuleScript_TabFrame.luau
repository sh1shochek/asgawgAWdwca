-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
local Signal = require(Parent.Parent.Shared.Signal);
local Style = require(Parent.Style);
local u1 = {
    prototype = {},
    interface = {}
};

function u1.prototype.Focus(p2) -- Line: 13
    -- upvalues: Style (copy)
    p2.TabButton.TextColor3 = Style.TAB_FOCUSED_TEXT;
    p2.TabButton.BackgroundColor3 = Style.TAB_FOCUSED_BACKGROUND;
end;

function u1.prototype.Unfocus(p3) -- Line: 18
    -- upvalues: Style (copy)
    p3.TabButton.TextColor3 = Style.TAB_NORMAL_TEXT;
    p3.TabButton.BackgroundColor3 = Style.TAB_NORMAL_BACKGROUND;
end;

function u1.prototype.Destroy(p4) -- Line: 23
    p4.TabActivated:Destroy();
    p4.TabButton:Destroy();
    p4.ButtonActivatedConnection:Disconnect();
end;

function u1.interface.new(p5: string, p6: userdata) -- Line: 30
    -- upvalues: Style (copy), Signal (copy), u1 (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = p5;
    TextButton.AutoLocalize = false;
    TextButton.Size = UDim2.fromScale(0, 1);
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextButton.Text = p5;
    TextButton.TextColor3 = Style.TAB_NORMAL_TEXT;
    TextButton.TextSize = 14;
    TextButton.AutomaticSize = Enum.AutomaticSize.X;
    TextButton.BackgroundColor3 = Style.TAB_NORMAL_BACKGROUND;
    TextButton.BorderSizePixel = 0;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.Parent = TextButton;
    TextButton.Parent = p6;
    local u7 = Signal.new();
    local v8 = {
        Module = p5,
        TabActivated = u7,
        TabButton = TextButton,
        ButtonActivatedConnection = TextButton.Activated:Connect(function() -- Line: 59
            -- upvalues: u7 (copy)
            u7:Fire();
        end)
    };

    return setmetatable(v8, {
        __index = u1.prototype
    });
end;

return u1.interface;