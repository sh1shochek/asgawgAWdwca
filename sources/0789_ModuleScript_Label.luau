-- Decompiled with Potassium's decompiler.

local Imgui = require(script.Parent.Parent.Parent.Imgui);
Imgui:NewWidgetDefinition("Label", {
    Construct = function(p1: any, p2: userdata, p3: string) -- Line: 8, Name: Construct
        -- upvalues: Imgui (copy)
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = `Label ({p1.ID})`;
        TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
        TextLabel.Text = p3;
        TextLabel.RichText = true;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.BorderSizePixel = 0;
        Imgui.applyTextStyle(TextLabel);
        TextLabel.Parent = p2;

        return TextLabel;
    end,

    Update = function(p4: any, p5: string) -- Line: 24, Name: Update
        p4.TopInstance.Text = p5;
    end
});

return nil;