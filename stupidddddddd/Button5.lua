-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.Button
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.ImguiWidgets.Button
-- Decompile time: 0.63 ms

local Imgui = require(script.Parent.Parent.Parent.Imgui)
Imgui:NewWidgetDefinition("Button", {
    Events = {
        activated = {
            Evaluate = function(a1) -- Line: 16
                local Pressed = a1.Pressed
                a1.Pressed = false
                return Pressed
            end,
        },
        hovered = {
            Evaluate = function(a1) -- Line: 25
                return a1.Hovering
            end,
        },
    },
    Construct = function(a1, a2, a3) -- Line: 31 -- upvalues: Imgui (val) -- types: a2: userdata, a3: string
        local TextButton = Instance.new("TextButton")
        TextButton.Name = ("Button (%*)"):format(a1.ID)
        TextButton.AutomaticSize = Enum.AutomaticSize.XY
        TextButton.Text = a3
        TextButton.BackgroundColor3 = Color3.fromRGB(98, 114, 164)
        TextButton.BorderSizePixel = 0
        TextButton.AutoButtonColor = false
        Imgui.applyTextStyle(TextButton)
        Imgui.applyFrameStyle(TextButton)
        TextButton.Parent = a2
        Imgui.applyMouseDownStyle(TextButton, function() end)
        Imgui.applyMouseUpStyle(TextButton, function() end)
        a1.PressConnection = TextButton.Activated:Connect(function() -- Line: 48 -- upvalues: a1 (val)
            a1.Pressed = true
        end)
        a1.MouseEnterConnection = Imgui.applyMouseHoverStyle(TextButton, function() -- Line: 52 -- upvalues: a1 (val)
            a1.Hovering = true
        end)
        a1.MouseLeaveConnection = Imgui.applyMouseHoverEndStyle(TextButton, function() -- Line: 56 -- upvalues: a1 (val)
            a1.Hovering = false
        end)
        a1.Button = TextButton
        return TextButton
    end,
    Deconstruct = function(a1) -- Line: 65
        a1.PressConnection:Disconnect()
        a1.MouseEnterConnection:Disconnect()
        a1.MouseLeaveConnection:Disconnect()
    end,
    Update = function(a1, a2) -- Line: 71 -- types: a2: string
        a1.TopInstance.Text = a2
    end,
})
return nil