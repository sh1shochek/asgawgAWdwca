-- Decompiled with Potassium's decompiler.

local Imgui = require(script.Parent.Parent.Parent.Imgui);
Imgui:NewWidgetDefinition("Button", {
    Events = {
        activated = {
            Evaluate = function(p1) -- Line: 16
                local Pressed = p1.Pressed;
                p1.Pressed = false;

                return Pressed;
            end
        },
        hovered = {
            Evaluate = function(p2) -- Line: 25
                return p2.Hovering;
            end
        }
    },

    Construct = function(u3: any, p4: userdata, p5: string) -- Line: 31, Name: Construct
        -- upvalues: Imgui (copy)
        local TextButton = Instance.new("TextButton");
        TextButton.Name = `Button ({u3.ID})`;
        TextButton.AutomaticSize = Enum.AutomaticSize.XY;
        TextButton.Text = p5;
        TextButton.BackgroundColor3 = Color3.fromRGB(98, 114, 164);
        TextButton.BorderSizePixel = 0;
        TextButton.AutoButtonColor = false;
        Imgui.applyTextStyle(TextButton);
        Imgui.applyFrameStyle(TextButton);
        TextButton.Parent = p4;
        Imgui.applyMouseDownStyle(TextButton, function() -- Line: 45
        end);
        Imgui.applyMouseUpStyle(TextButton, function() -- Line: 46
        end);
        u3.PressConnection = TextButton.Activated:Connect(function() -- Line: 48
            -- upvalues: u3 (copy)
            u3.Pressed = true;
        end);
        u3.MouseEnterConnection = Imgui.applyMouseHoverStyle(TextButton, function() -- Line: 52
            -- upvalues: u3 (copy)
            u3.Hovering = true;
        end);
        u3.MouseLeaveConnection = Imgui.applyMouseHoverEndStyle(TextButton, function() -- Line: 56
            -- upvalues: u3 (copy)
            u3.Hovering = false;
        end);
        u3.Button = TextButton;

        return TextButton;
    end,

    Deconstruct = function(p6) -- Line: 65, Name: Deconstruct
        p6.PressConnection:Disconnect();
        p6.MouseEnterConnection:Disconnect();
        p6.MouseLeaveConnection:Disconnect();
    end,

    Update = function(p7: any, p8: string) -- Line: 71, Name: Update
        p7.TopInstance.Text = p8;
    end
});

return nil;