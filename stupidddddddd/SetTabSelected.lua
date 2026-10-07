-- ReplicatedStorage.Components.Common.InterfaceAnimations.SetTabSelected
-- Script path: ReplicatedStorage.Components.Common.InterfaceAnimations.SetTabSelected
-- Decompile time: 0.91 ms

local u4 = Color3.fromRGB(125, 206, 243)

local function createHighlight(a1) -- Line: 18 -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = "Selected"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = -2
    Frame.ClipsDescendants = true
    Frame.Visible = false
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = -90
    UIGradient.Color = ColorSequence.new(Color3.fromRGB(195, 195, 195), Color3.fromRGB(53, 53, 53))
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.34375),
        NumberSequenceKeypoint.new(0.0857143, 0.46875),
        NumberSequenceKeypoint.new(0.32, 0.7),
        NumberSequenceKeypoint.new(0.704762, 0.88125),
        (NumberSequenceKeypoint.new(1, 1)),
    })
    UIGradient.Parent = Frame
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Pattern"
    ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Image = "rbxassetid://102274428506900"
    ImageLabel.ImageTransparency = 0.21
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromScale(1.69762695, 3.10517287)
    ImageLabel.Position = UDim2.fromScale(-0.348813593, -0.50142777)
    ImageLabel.ZIndex = 0
    ImageLabel.Parent = Frame
    local UIGradient_2 = Instance.new("UIGradient")
    UIGradient_2.Rotation = -90
    UIGradient_2.Transparency = NumberSequence.new(0, 1)
    UIGradient_2.Parent = ImageLabel
    Frame.Parent = a1
    return Frame
end

return function(a1, a2) -- Line: 66 -- upvalues: createHighlight (val), u4 (val) -- types: a1: userdata, a2: boolean
    if a1:GetAttribute("UnselectedColor") == nil then
        a1:SetAttribute("UnselectedColor", a1.BackgroundColor3)
    end
    local Selected = a1:FindFirstChild("Selected")
    if not Selected or not Selected:IsA("GuiObject") then
        Selected = createHighlight(a1)
    end
    Selected.Visible = a2
    a1.BackgroundColor3 = if not a2 then a1:GetAttribute("UnselectedColor") else u4
end