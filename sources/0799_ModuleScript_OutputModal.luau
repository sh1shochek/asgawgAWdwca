-- Decompiled with Potassium's decompiler.

local Signal = require(script.Parent.Parent.Parent.Parent.Parent.Shared.Signal);
local u1 = {
    internal = {},
    prototype = {},
    interface = {}
};

function u1.internal.createModalInterface(u2: any, p3: string) -- Line: 12
    local Frame = Instance.new("Frame");
    Frame.Name = "Output Modal";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(79, 88, 105);
    Frame.BackgroundTransparency = 0.1;
    Frame.BorderColor3 = Color3.fromRGB(79, 88, 105);
    Frame.BorderSizePixel = 10;
    Frame.ZIndex = 10;
    local TextButton = Instance.new("TextButton");
    TextButton.AutoLocalize = false;
    TextButton.Position = UDim2.fromOffset(-8, -8);
    TextButton.Size = UDim2.new(1, 16, 1, 16);
    TextButton.BackgroundTransparency = 1;
    TextButton.Text = "";
    TextButton.ZIndex = -1;
    TextButton.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.AutoLocalize = false;
    TextLabel.Name = "TextLabel";
    TextLabel.AnchorPoint = Vector2.new(0, 1);
    TextLabel.Position = UDim2.fromScale(0, 1);
    TextLabel.Size = UDim2.new(1, 0, 0, 12);
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.Text = "Copy the above message and paste it into a file.";
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextSize = 12;
    TextLabel.TextStrokeTransparency = 0.5;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.BorderSizePixel = 0;
    TextLabel.Parent = Frame;
    local TextBox = Instance.new("TextBox");
    TextBox.AutoLocalize = false;
    TextBox.Name = "TextBox";
    TextBox.Position = UDim2.fromOffset(0, 16);
    TextBox.Size = UDim2.new(1, 0, 1, -30);
    TextBox.ClearTextOnFocus = false;
    TextBox.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json");
    TextBox.Text = p3;
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextBox.TextSize = 12;
    TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
    TextBox.TextWrapped = true;
    TextBox.TextXAlignment = Enum.TextXAlignment.Left;
    TextBox.TextYAlignment = Enum.TextYAlignment.Top;
    TextBox.Active = false;
    TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    TextBox.BackgroundTransparency = 0.5;
    TextBox.BorderSizePixel = 0;
    TextBox.TextEditable = false;
    TextBox.ZIndex = 10;
    TextBox.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 8);
    UIPadding.Parent = Frame;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.AutoLocalize = false;
    TextButton2.Name = "Close Button";
    TextButton2.AnchorPoint = Vector2.new(1, 0);
    TextButton2.Position = UDim2.new(1, 8, 0, -8);
    TextButton2.Size = UDim2.fromOffset(32, 16);
    TextButton2.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextButton2.Text = "X";
    TextButton2.TextColor3 = Color3.fromRGB(0, 0, 0);
    TextButton2.TextSize = 16;
    TextButton2.BackgroundColor3 = Color3.fromRGB(255, 81, 70);
    TextButton2.BorderColor3 = Color3.fromRGB(0, 0, 0);
    TextButton2.BorderSizePixel = 0;
    TextButton2.Parent = Frame;
    u2.CloseButtonActivatedConnection = TextButton2.Activated:Connect(function() -- Line: 96
        -- upvalues: u2 (copy)
        u2.CloseActivated:Fire();
    end);

    return Frame;
end;

function u1.prototype.ParentTo(p4: table, p5: userdata) -- Line: 103
    p4.ModalFrame.Parent = p5;
end;

function u1.prototype.Destroy(p6) -- Line: 107
    p6.ModalFrame:Destroy();
    p6.ModalFrame = nil;
    p6.CloseActivated:Destroy();
    p6.CloseActivated = nil;
    p6.CloseButtonActivatedConnection:Disconnect();
    p6.CloseButtonActivatedConnection = nil;
end;

function u1.interface.new(p7: string) -- Line: 118
    -- upvalues: Signal (copy), u1 (copy)
    local v8 = {
        ModalFrame = nil,
        CloseActivated = Signal.new()
    };
    local v9 = setmetatable(v8, {
        __index = u1.prototype
    });
    v9.ModalFrame = u1.internal.createModalInterface(v9, p7);

    return v9;
end;

return u1.interface;