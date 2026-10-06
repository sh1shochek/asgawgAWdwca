-- Decompiled with Potassium's decompiler.

local Imgui = require(script.Parent.Parent.Parent.Imgui);
Imgui:NewWidgetDefinition("Checkbox", {
    Events = {
        activated = {
            Evaluate = function(p1) -- Line: 20
                local Pressed = p1.Pressed;
                p1.Pressed = false;

                return Pressed;
            end
        }
    },

    Construct = function(u2: any, p3: userdata, p4: string, p5: boolean) -- Line: 29, Name: Construct
        -- upvalues: Imgui (copy)
        local Frame = Instance.new("Frame");
        Frame.Name = `Checkbox ({u2.ID})`;
        Frame.AutomaticSize = Enum.AutomaticSize.XY;
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Text";
        TextLabel.Text = p4;
        TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.BorderSizePixel = 0;
        TextLabel.LayoutOrder = 1;
        Imgui.applyTextStyle(TextLabel);
        TextLabel.Parent = Frame;
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Name = "UIListLayout";
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Parent = Frame;
        UIListLayout.Padding = UDim.new(0, Imgui:GetConfig().Sizes.ItemPadding.X);
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "TextButton";
        TextButton.AutoLocalize = false;
        TextButton.Size = UDim2.fromOffset(18, 18);
        TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
        TextButton.Text = "";
        TextButton.TextSize = 14;
        TextButton.BackgroundColor3 = Color3.fromRGB(54, 54, 54);
        TextButton.BorderSizePixel = 0;
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
        UIAspectRatioConstraint.Name = "UIAspectRatioConstraint";
        UIAspectRatioConstraint.Parent = TextButton;
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = "Status ImageLabel";
        ImageLabel.Size = UDim2.fromScale(1, 1);
        ImageLabel.Image = "rbxassetid://15225522557";
        ImageLabel.ImageColor3 = Imgui:GetConfig().Colors.Checkbox;
        ImageLabel.Visible = p5;
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.BorderSizePixel = 0;
        ImageLabel.Parent = TextButton;
        TextButton.Parent = Frame;
        Frame.Parent = p3;
        u2.CheckboxButton = TextButton;
        u2.TextLabel = TextLabel;
        u2.StatusImageLabel = ImageLabel;
        u2.Status = p5 or true;
        u2.PressConnection = TextButton.Activated:Connect(function() -- Line: 89
            -- upvalues: u2 (copy)
            u2.Pressed = true;
            u2.Status = not u2.Status;
        end);

        return Frame;
    end,

    Deconstruct = function(p6) -- Line: 98, Name: Deconstruct
        p6.PressConnection:Disconnect();
    end,

    Update = function(p7: any, p8: string, p9: boolean) -- Line: 102, Name: Update
        p7.Status = p9;
        p7.TextLabel.Text = p8;
        p7.StatusImageLabel.Visible = p9;
    end
});

return nil;