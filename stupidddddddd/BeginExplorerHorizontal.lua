-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Explorer.BeginExplorerHorizontal
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Explorer.BeginExplorerHorizontal
-- Decompile time: 0.64 ms

local Imgui = require(script.Parent.Parent.Parent.Parent.Imgui)
local u8 = {[Enum.UserInputType.MouseButton1] = true, [Enum.UserInputType.Touch] = true}
Imgui:NewWidgetDefinition("BeginExplorerHorizontal", {
    Events = {
        activated = {
            Setup = function(a1) -- Line: 18 -- upvalues: u8 (val)
                a1.TopInstance.InputBegan:Connect(function(a1_2) -- Line: 19 -- upvalues: u8 (upval), a1 (val) -- types: a1_2: userdata
                    if not u8[a1_2.UserInputType] then
                        return
                    end
                    a1.WasPressed = true
                end)
            end,
            Evaluate = function(a1) -- Line: 28
                local WasPressed = a1.WasPressed
                a1.WasPressed = false
                return WasPressed
            end,
        },
    },
    Construct = function(a1, a2, a3, a4) -- Line: 37 -- types: a2: userdata, a3: boolean?
        local Frame = Instance.new("Frame")
        Frame.Name = ("ExplorerHorizontal (%*)"):format(a1.ID)
        Frame.Size = UDim2.fromScale(1, 0)
        Frame.AutomaticSize = Enum.AutomaticSize.XY
        Frame.BackgroundTransparency = if not a3 then 1 else 0.5
        Frame.BorderSizePixel = 0
        Frame.Active = true
        Frame.BackgroundColor3 = Color3.fromHex("#0b5aaf")
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Name = "UIListLayout"
        UIListLayout.Padding = UDim.new(0, 2)
        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.HorizontalAlignment = a4 or Enum.HorizontalAlignment.Left
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame
        a1.TopInstance = Frame
        a1.UIListLayout = UIListLayout
        Frame.Parent = a2
        return Frame, Frame
    end,
    Update = function(a1, a2, a3) -- Line: 69 -- types: a2: boolean?
        a1.UIListLayout.HorizontalAlignment = a3 or Enum.HorizontalAlignment.Left
        local v1 = if not a2 then 1 else 0
        a1.TopInstance.BackgroundTransparency = v1
    end,
})
return nil