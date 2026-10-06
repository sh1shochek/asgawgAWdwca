-- Decompiled with Potassium's decompiler.

local Imgui = require(script.Parent.Parent.Parent.Parent.Imgui);
local u1 = {
    string = "#adf195",
    number = "#ffc600",
    Vector3 = "#ffc600",
    CFrame = "#ffc600",
    Instance = "#61a1f1",
    EnumItem = "#61a1f1",
    boolean = "#ff1a1a",
    ["nil"] = "#ffc600"
};
Imgui:NewWidgetDefinition("PropertyLabel", {
    Construct = function(p2: any, p3: userdata, p4: userdata, p5: string) -- Line: 19, Name: Construct
        -- upvalues: u1 (copy), Imgui (copy)
        local v6 = p4[p5];
        local v7 = tostring(v6);
        local v8 = typeof(v6);

        if v8 == "string" then
            v7 = `"{v7}"`;
        end;

        if u1[v8] then
            v7 = `<font color="{u1[v8]}">{v7}</font>`;
        end;

        local Frame = Instance.new("Frame");
        Frame.Name = `ExplorerHorizontal ({p2.ID})`;
        Frame.Size = UDim2.new(1, 0, 0, 15);
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        Frame.Active = true;
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Name = "UIListLayout";
        UIListLayout.Padding = UDim.new(0, 2);
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Parent = Frame;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = `Label ({p2.ID})`;
        TextLabel.Size = UDim2.fromScale(0.35, 1);
        TextLabel.Text = `<b>{p5}</b>`;
        TextLabel.RichText = true;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.BorderSizePixel = 0;
        TextLabel.Parent = Frame;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
        local TextLabel2 = Instance.new("TextLabel");
        TextLabel2.Name = `Label ({p2.ID})`;
        TextLabel2.Size = UDim2.fromScale(0.65, 1);
        TextLabel2.Position = UDim2.fromScale(0.35, 0);
        TextLabel2.Text = `<i>{v8}</i> [{v7}]`;
        TextLabel2.RichText = true;
        TextLabel2.BackgroundTransparency = 1;
        TextLabel2.BorderSizePixel = 0;
        TextLabel2.Parent = Frame;
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
        Imgui.applyTextStyle(TextLabel);
        Imgui.applyTextStyle(TextLabel2);
        p2.TopInstance = Frame;
        Frame.Parent = p3;

        return Frame;
    end,

    Update = function(p9: any, p10: userdata, p11: string) -- Line: 80, Name: Update
    end
});

return nil;