-- Decompiled with Potassium's decompiler.

local Color3_fromRGB_ret = Color3.fromRGB(125, 206, 243);

local function createHighlight(p1: userdata) -- Line: 18
    local Frame = Instance.new("Frame");
    Frame.Name = "Selected";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = -2;
    Frame.ClipsDescendants = true;
    Frame.Visible = false;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Rotation = -90;
    UIGradient.Color = ColorSequence.new(Color3.fromRGB(195, 195, 195), Color3.fromRGB(53, 53, 53));
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.34375),
        NumberSequenceKeypoint.new(0.0857143, 0.46875),
        NumberSequenceKeypoint.new(0.32, 0.7),
        NumberSequenceKeypoint.new(0.704762, 0.88125),
        NumberSequenceKeypoint.new(1, 1)
    });
    UIGradient.Parent = Frame;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Pattern";
    ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Image = "rbxassetid://102274428506900";
    ImageLabel.ImageTransparency = 0.21;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.fromScale(1.69762695, 3.10517287);
    ImageLabel.Position = UDim2.fromScale(-0.348813593, -0.50142777);
    ImageLabel.ZIndex = 0;
    ImageLabel.Parent = Frame;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Rotation = -90;
    UIGradient2.Transparency = NumberSequence.new(0, 1);
    UIGradient2.Parent = ImageLabel;
    Frame.Parent = p1;

    return Frame;
end;

return function(p2: userdata, p3: boolean) -- Line: 66
    -- upvalues: createHighlight (copy), Color3_fromRGB_ret (copy)
    if p2:GetAttribute("UnselectedColor") == nil then
        p2:SetAttribute("UnselectedColor", p2.BackgroundColor3);
    end;

    local Selected = p2:FindFirstChild("Selected");

    if not (Selected and Selected:IsA("GuiObject")) then
        Selected = createHighlight(p2);
    end;

    Selected.Visible = p3;
    local v4;

    if p3 then
        v4 = Color3_fromRGB_ret;
    else
        v4 = p2:GetAttribute("UnselectedColor");
    end;

    p2.BackgroundColor3 = v4;
end;