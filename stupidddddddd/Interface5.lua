-- ReplicatedStorage.Packages.DebugTools.Client.Interface
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Interface
-- Decompile time: 3.98 ms

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GuiInset = GuiService:GetGuiInset()
local Parent = script.Parent
local Shared = Parent.Parent.Shared
local Tab = require(Parent.Tab)
local Style = require(Parent.Style)
local Constants = require(Shared.Constants)
local TabFrame = require(script.TabFrame)
local u35 = {
    internal = {Tabs = {}},
    private = {Dragging = false, InterfaceCreated = false, InterfaceElements = {}, Tabs = {}},
    interface = {},
}

function u35.internal.focusModule(a1) -- Line: 43 -- upvalues: u35 (val), Tab (val) -- types: a1: string
    local ActiveTab = u35.internal.ActiveTab
    if ActiveTab and ActiveTab.Name == a1 then
        return
    end
    local v1 = Tab.getTabConstructor(a1)
    if not v1 then
        return
    end
    local ActiveContentTabFrame = u35.internal.ActiveContentTabFrame
    if not ActiveContentTabFrame then
        return
    end
    if ActiveTab then
        u35.internal.Tabs[ActiveTab.Name]:Unfocus()
        ActiveTab.Destructor()
        local Children = ActiveContentTabFrame:GetChildren()
        if #Children > 0 then
            warn((("Tab '%*' didn't cleanup unmounted interface properly, there are leftover elements:"):format(ActiveTab.Name)))
            for i, j in Children do
                warn((("  ╠ %*(%*)"):format(j.Name, j.ClassName)))
                j:Destroy()
            end
        end
    end
    u35.internal.ActiveTab = {Name = a1, Destructor = v1(ActiveContentTabFrame)}
    u35.internal.Tabs[a1]:Focus()
end

function u35.internal.tabAdded(a1) -- Line: 83 -- upvalues: TabFrame (val), u35 (val) -- types: a1: string
    local v1 = TabFrame.new(a1, u35.private.InterfaceElements.Tabs, u35.private.InterfaceElements.ContentFrame)
    v1.TabActivated:Connect(function() -- Line: 90 -- upvalues: u35 (upval), a1 (val)
        u35.internal.focusModule(a1)
    end)
    u35.internal.Tabs[a1] = v1
    if not u35.internal.ActiveTab then
        u35.internal.focusModule(a1)
    end
end

function u35.private:CreateInterface() -- Line: 101
    -- upvalues: Style (val), Constants (val), GuiInset (val), UserInputService (val), Players (val), u35 (val)
    assert(not self.InterfaceCreated, "Tried to create interface when it was already created!")
    self.InterfaceCreated = true
    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(624, 375)
    Frame.BackgroundTransparency = 0.15
    Frame.BackgroundColor3 = Style.BACKGROUND
    Frame.BorderSizePixel = 0
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.Color = Color3.fromRGB(98, 114, 164)
    UIStroke.Parent = Frame
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Header"
    TextLabel.AutoLocalize = false
    TextLabel.Size = UDim2.new(1, 0, 0, 18)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextLabel.Text = "DEBUG TOOLS"
    TextLabel.TextColor3 = Style.TEXT
    TextLabel.TextSize = 18
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BackgroundColor3 = Style.COLOR_WHITE
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.Parent = Frame
    local TextLabel_2 = Instance.new("TextLabel")
    TextLabel_2.Name = "Version"
    TextLabel_2.AutoLocalize = false
    TextLabel_2.Size = UDim2.new(1, 0, 0, 18)
    TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextLabel_2.Text = Constants.VERSION
    TextLabel_2.TextColor3 = Style.TEXT
    TextLabel_2.TextSize = 10
    TextLabel_2.TextTransparency = 0.75
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel_2.TextYAlignment = Enum.TextYAlignment.Bottom
    TextLabel_2.BackgroundColor3 = Style.COLOR_WHITE
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.Parent = Frame
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)
    UIPadding.Parent = Frame
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Frame
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Content Frame"
    Frame_2.Position = UDim2.fromOffset(0, 24)
    Frame_2.Size = UDim2.new(1, 0, 1, -24)
    Frame_2.BackgroundTransparency = 1
    Frame_2.BorderSizePixel = 0
    local Frame_3 = Instance.new("Frame")
    Frame_3.Name = "Active Tab Content"
    Frame_3.AnchorPoint = Vector2.new(0, 1)
    Frame_3.Position = UDim2.fromScale(0, 1)
    Frame_3.Size = UDim2.new(1, 0, 1, -16)
    Frame_3.BackgroundTransparency = 1
    Frame_3.BorderSizePixel = 0
    Frame_3.ClipsDescendants = true
    Frame_3.ZIndex = 2
    Frame_3.Parent = Frame_2
    local Frame_4 = Instance.new("Frame")
    Frame_4.Name = "Tabs"
    Frame_4.Size = UDim2.new(1, 0, 0, 16)
    Frame_4.BackgroundTransparency = 1
    Frame_4.BorderSizePixel = 0
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.Name
    UIListLayout.Parent = Frame_4
    Frame_4.Parent = Frame_2
    Frame_2.Parent = Frame
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "Drag Detector"
    TextButton.Position = UDim2.new(0, -8, 0, -8)
    TextButton.Size = UDim2.new(1, 16, 0, 30)
    TextButton.BorderSizePixel = 0
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Modal = true
    TextButton.Parent = Frame
    TextButton.InputBegan:Connect(function(a1) -- Line: 210
        -- upvalues: self (val), Frame (val), GuiInset (upval), UserInputService (upval)
        if self.Dragging then
            return
        end
        if a1.UserInputType ~= Enum.UserInputType.MouseButton1 and a1.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local v1 = (Vector2.new(Frame.AbsolutePosition.X, Frame.AbsolutePosition.Y)) + GuiInset
        self.Dragging = true
        self.DragOffset = v1 - UserInputService:GetMouseLocation()
        self.InputChangedConnection = UserInputService.InputChanged:Connect(function(a1) -- Line: 229 -- upvalues: Frame (upval), self (upval), GuiInset (upval) -- types: a1: userdata
            if a1.UserInputType ~= Enum.UserInputType.MouseMovement
                and a1.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local v1 = -(Frame.AbsoluteSize * -Frame.AnchorPoint)
            local v2 = (Vector2.new(a1.Position.X, a1.Position.Y)) + self.DragOffset + GuiInset + v1
            v2 = Vector2.new(math.max(0, v2.X), (math.max(0, v2.Y)))
            Frame.Position = UDim2.fromOffset(v2.X, v2.Y)
        end)
        self.InputEndedConnection = UserInputService.InputEnded:Connect(function(a1) -- Line: 249 -- upvalues: self (upval) -- types: a1: userdata
            if a1.UserInputType ~= Enum.UserInputType.MouseButton1
                and a1.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            self.Dragging = false
            self.InputEndedConnection:Disconnect()
            self.InputChangedConnection:Disconnect()
        end)
    end)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "[DEBUG] Main Interface"
    ScreenGui.DisplayOrder = Constants.DEBUG_TOOL_DISPLAY_ORDER
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = false
    Frame.Parent = ScreenGui
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    self.InterfaceElements.ContentFrame = Frame_2
    self.InterfaceElements.Tabs = Frame_4
    self.InterfaceElements.ScreenGui = ScreenGui
    u35.internal.ActiveContentTabFrame = Frame_3
    ScreenGui.DescendantAdded:Connect(function(a1) -- Line: 283 -- types: a1: userdata
        if not a1:IsA("TextLabel") and not a1:IsA("TextButton") and not a1:IsA("TextBox") then
            return
        end
        if a1.AutoLocalize then
            warn((("A descendant was added to Debug Tools interface that has AutoLocalize enabled, every Instance that inherits GuiBase2d should have it's AutoLocalize property set to false!\n%*"):format((a1:GetFullName()))))
        end
        a1.AutoLocalize = false
    end)
end

function u35.private.ListenToModules(a1) -- Line: 302 -- upvalues: Tab (val), u35 (val)
    for i, j in Tab.getAllTabs() do
        u35.internal.tabAdded(j)
    end
    Tab.TabAdded:Connect(function(a1) -- Line: 307 -- upvalues: u35 (upval)
        u35.internal.tabAdded(a1)
    end)
end

function u35.interface.init() -- Line: 312 -- upvalues: u35 (val)
    u35.private:CreateInterface()
    u35.private:ListenToModules()
end

function u35.interface.switchVisibility() -- Line: 317 -- upvalues: u35 (val)
    local ScreenGui = u35.private.InterfaceElements.ScreenGui
    if not ScreenGui then
        return
    end
    ScreenGui.Enabled = not ScreenGui.Enabled
end

return u35.interface