-- Decompiled with Potassium's decompiler.

local Imgui = require(script.Parent.Parent.Parent.Parent.Imgui);
local ClassIndex = require(script.Parent.Parent.Parent.Parent.Vendor.ClassIndex);
Imgui:NewWidgetDefinition("ExplorerClassIcon", {
    Construct = function(p1: any, p2: userdata, p3, p4: userdata) -- Line: 9, Name: Construct
        -- upvalues: ClassIndex (copy)
        local ImageLabel = Instance.new("ImageLabel");
        ImageLabel.Name = `Label ({p1.ID})`;
        ImageLabel.AutomaticSize = Enum.AutomaticSize.XY;
        ImageLabel.BackgroundTransparency = 1;
        ImageLabel.BorderSizePixel = 0;
        ImageLabel.Size = p3;

        for i, v in ClassIndex.FetchClassIcon(p4.ClassName) do
            ImageLabel[i] = v;
        end;

        ImageLabel.Parent = p2;

        return ImageLabel;
    end,

    Update = function(p5: any, p6, p7: userdata) -- Line: 26, Name: Update
        -- upvalues: ClassIndex (copy)
        p5.TopInstance.Size = p6;

        for i, v in ClassIndex.FetchClassIcon(p7.ClassName) do
            p5.TopInstance[i] = v;
        end;
    end
});

return nil;