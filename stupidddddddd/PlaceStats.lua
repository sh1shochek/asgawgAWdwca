-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Widgets.PlaceStats
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Widgets.PlaceStats
-- Decompile time: 1.46 ms

local RunService = game:GetService("RunService")
local Parent = script.Parent.Parent.Parent
if not require(Parent.Parent.Shared.Constants).DEFAULT_WIDGETS_ENABLED then
    return nil
end
local Style = require(Parent.Style)
local Widget = require(Parent.Widget)
local Performance = require(Parent.Builtin.Tabs.Performance)
Widget.new("Place Stats", function(a1) -- Line: 16 -- upvalues: Style (val), RunService (val), Performance (val) -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = "Content"
    Frame.AnchorPoint = Vector2.new(0, 1)
    Frame.Position = UDim2.new(0, 8, 1, -8)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.AutomaticSize = Enum.AutomaticSize.XY
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "FPSLabel"
    TextLabel.AutoLocalize = false
    TextLabel.Size = UDim2.fromOffset(0, 24)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextLabel.Text = "FPS: 0"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 24
    TextLabel.TextTransparency = 0.33
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.BackgroundTransparency = 1
    TextLabel.LayoutOrder = 1
    TextLabel.Parent = Frame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)
    UIPadding.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.Parent = Frame
    local TextLabel_2 = Instance.new("TextLabel")
    TextLabel_2.Name = "FPSCapLabel"
    TextLabel_2.AutoLocalize = false
    TextLabel_2.Size = UDim2.fromOffset(0, 14)
    TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    TextLabel_2.Text = "FPS Cap: 0"
    TextLabel_2.TextColor3 = Style.COLOR_RED
    TextLabel_2.TextSize = 14
    TextLabel_2.TextTransparency = 0.33
    TextLabel_2.AutomaticSize = Enum.AutomaticSize.X
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.LayoutOrder = 2
    TextLabel_2.Parent = Frame
    local TextLabel_3 = Instance.new("TextLabel")
    TextLabel_3.Name = "PhysicsFPSLabel"
    TextLabel_3.AutoLocalize = false
    TextLabel_3.Size = UDim2.fromOffset(0, 14)
    TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    TextLabel_3.Text = "Physics FPS: 0"
    TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_3.TextSize = 14
    TextLabel_3.TextTransparency = 0.33
    TextLabel_3.AutomaticSize = Enum.AutomaticSize.X
    TextLabel_3.BackgroundTransparency = 1
    TextLabel_3.LayoutOrder = 3
    TextLabel_3.Parent = Frame
    local TextLabel_4 = Instance.new("TextLabel")
    TextLabel_4.Name = "PlaceVersionLabel"
    TextLabel_4.AutoLocalize = false
    TextLabel_4.Size = UDim2.fromOffset(0, 14)
    TextLabel_4.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    TextLabel_4.Text = ("Version: %*"):format(game.PlaceVersion)
    TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_4.TextSize = 14
    TextLabel_4.TextTransparency = 0.33
    TextLabel_4.AutomaticSize = Enum.AutomaticSize.X
    TextLabel_4.BackgroundTransparency = 1
    TextLabel_4.LayoutOrder = 4
    TextLabel_4.Parent = Frame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame
    Frame.Parent = a1
    local u151 = {}
    local u153 = os.clock()
    local u159 = RunService.Heartbeat:Connect(function() -- Line: 104
        -- upvalues: u151 (val), u153 (val), Performance (upval), TextLabel_2 (val), TextLabel (val), TextLabel_3 (val)
        local v1, v2
        local v3 = os.clock()
        for i = #u151, 1, -1 do
            v1 = i + 1
            v2 = u151[i]
            u151[v1] = v3 - 1 <= v2 and u151[i] or nil
        end
        u151[1] = v3
        local v4 = math.floor(1 <= os.clock() - u153 and #u151 or #u151 / (os.clock() - u153))
        local FPSCap = Performance:GetFPSCap()
        TextLabel_2.Visible = FPSCap > 0
        TextLabel_2.Text = ("FPS Cap: %*"):format(FPSCap)
        TextLabel.Text = ("FPS: %*"):format(v4)
        TextLabel_3.Text = ("Physics FPS: %*"):format((math.floor((workspace:GetRealPhysicsFPS()))))
    end)
    return function() -- Line: 129 -- upvalues: Frame (ref), u159 (ref)
        Frame:Destroy()
        Frame = nil
        u159:Disconnect()
        u159 = nil
    end
end)
return nil