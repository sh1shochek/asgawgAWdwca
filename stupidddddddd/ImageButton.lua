-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.ImageButton
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.ImageButton
-- Decompile time: 0.71 ms

local Imgui = require(script.Parent.Parent.Parent.Imgui)
Imgui:NewWidgetDefinition("ImageButton", {
    Events = {
        activated = {
            Evaluate = function(a1) -- Line: 17
                local Pressed = a1.Pressed
                a1.Pressed = false
                return Pressed
            end,
        },
        hovered = {
            Evaluate = function(a1) -- Line: 26
                return a1.Hovering
            end,
        },
    },
    Construct = function(a1, a2, a3, a4) -- Line: 32 -- upvalues: Imgui (val) -- types: a2: userdata, a3: userdata, a4: string
        local ImageButton = Instance.new("ImageButton")
        ImageButton.Name = ("ImageButton (%*)"):format(a1.ID)
        ImageButton.AutomaticSize = Enum.AutomaticSize.XY
        ImageButton.BorderSizePixel = 0
        ImageButton.BackgroundTransparency = 1
        ImageButton.AutoButtonColor = false
        ImageButton.Image = a4
        ImageButton.Size = a3
        ImageButton.Parent = a2
        Imgui.applyMouseDownStyle(ImageButton, function() end)
        Imgui.applyMouseUpStyle(ImageButton, function() end)
        a1.PressConnection = ImageButton.Activated:Connect(function() -- Line: 47 -- upvalues: a1 (val)
            a1.Pressed = true
        end)
        a1.MouseEnterConnection = Imgui.applyMouseHoverStyle(ImageButton, function() -- Line: 51 -- upvalues: a1 (val)
            a1.Hovering = true
        end)
        a1.MouseLeaveConnection = Imgui.applyMouseHoverEndStyle(ImageButton, function() -- Line: 55 -- upvalues: a1 (val)
            a1.Hovering = false
        end)
        a1.ImageButton = ImageButton
        return ImageButton
    end,
    Deconstruct = function(a1) -- Line: 64
        a1.PressConnection:Disconnect()
        a1.MouseEnterConnection:Disconnect()
        a1.MouseLeaveConnection:Disconnect()
    end,
    Update = function(a1, a2, a3) -- Line: 70 -- types: a2: userdata, a3: string
        a1.TopInstance.Image = a3
        a1.TopInstance.Size = a2
    end,
    Return = function(a1) -- Line: 75
        local Pressed = a1.Pressed
        a1.Pressed = false
        return Pressed or false
    end,
})
return nil