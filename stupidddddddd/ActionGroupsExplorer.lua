-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionGroupsExplorer
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionGroupsExplorer
-- Decompile time: 0.75 ms

local ActionGroupButton = require(script.Parent.ActionGroupButton)
return function(a1, a2, a3, a4) -- Line: 4 -- upvalues: ActionGroupButton (val) -- types: a1: userdata, a4: function
    local Frame = Instance.new("Frame")
    Frame.Name = "Actions Explorer"
    Frame.BackgroundColor3 = Color3.fromRGB(172, 195, 245)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(0.25, 1)
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Gradient"
    Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BackgroundTransparency = 0.8
    Frame_2.BorderSizePixel = 0
    Frame_2.Position = UDim2.fromScale(1, 0)
    Frame_2.Size = UDim2.fromScale(0.05, 1)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Name = "UIGradient"
    UIGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), (NumberSequenceKeypoint.new(1, 1))})
    UIGradient.Parent = Frame_2
    Frame_2.Parent = Frame
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.Parent = ScrollingFrame
    ScrollingFrame.Parent = Frame
    Frame.Parent = a1
    local u82 = {}
    a2:Observe(function(a1) -- Line: 54 -- upvalues: u82 (ref), ActionGroupButton (upval), ScrollingFrame (val), a3 (val), a4 (val)
        for i, j in a1 do
            if not u82[j] then
                u82[j] = (ActionGroupButton(j, ScrollingFrame, a3, function() -- Line: 64 -- upvalues: a4 (upval), j (val)
                    a4(j)
                end))
            end
        end
    end)
    return function() -- Line: 71 -- upvalues: Frame (ref), u82 (ref)
        Frame:Destroy()
        Frame = nil
        for i, j in u82 do
            j()
        end
        u82 = nil
    end
end