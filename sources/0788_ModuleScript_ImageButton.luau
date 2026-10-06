-- Decompiled with Potassium's decompiler.

local Imgui = require(script.Parent.Parent.Parent.Imgui);
Imgui:NewWidgetDefinition("ImageButton", {
    Events = {
        activated = {
            Evaluate = function(p1) -- Line: 17
                local Pressed = p1.Pressed;
                p1.Pressed = false;

                return Pressed;
            end
        },
        hovered = {
            Evaluate = function(p2) -- Line: 26
                return p2.Hovering;
            end
        }
    },

    Construct = function(u3: any, p4: userdata, p5, p6: string) -- Line: 32, Name: Construct
        -- upvalues: Imgui (copy)
        local ImageButton = Instance.new("ImageButton");
        ImageButton.Name = `ImageButton ({u3.ID})`;
        ImageButton.AutomaticSize = Enum.AutomaticSize.XY;
        ImageButton.BorderSizePixel = 0;
        ImageButton.BackgroundTransparency = 1;
        ImageButton.AutoButtonColor = false;
        ImageButton.Image = p6;
        ImageButton.Size = p5;
        ImageButton.Parent = p4;
        Imgui.applyMouseDownStyle(ImageButton, function() -- Line: 44
        end);
        Imgui.applyMouseUpStyle(ImageButton, function() -- Line: 45
        end);
        u3.PressConnection = ImageButton.Activated:Connect(function() -- Line: 47
            -- upvalues: u3 (copy)
            u3.Pressed = true;
        end);
        u3.MouseEnterConnection = Imgui.applyMouseHoverStyle(ImageButton, function() -- Line: 51
            -- upvalues: u3 (copy)
            u3.Hovering = true;
        end);
        u3.MouseLeaveConnection = Imgui.applyMouseHoverEndStyle(ImageButton, function() -- Line: 55
            -- upvalues: u3 (copy)
            u3.Hovering = false;
        end);
        u3.ImageButton = ImageButton;

        return ImageButton;
    end,

    Deconstruct = function(p7) -- Line: 64, Name: Deconstruct
        p7.PressConnection:Disconnect();
        p7.MouseEnterConnection:Disconnect();
        p7.MouseLeaveConnection:Disconnect();
    end,

    Update = function(p8: any, p9, p10: string) -- Line: 70, Name: Update
        p8.TopInstance.Image = p10;
        p8.TopInstance.Size = p9;
    end,

    Return = function(p11) -- Line: 75, Name: Return
        local Pressed = p11.Pressed;
        p11.Pressed = false;

        return Pressed or false;
    end
});

return nil;