-- ReplicatedStorage.Interface.Screens.Menu.Dashboard.EditMobile
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Dashboard.EditMobile
-- Decompile time: 53.84 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local ApplyMobileButtonLayout = require(ReplicatedStorage.Components.Common.ApplyMobileButtonLayout)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local u69 = {
    ["Counter-Terrorists"] = {Primary = "M4A4", Secondary = "USP-S", Melee = "CT Knife"},
    Terrorists = {Primary = "AK-47", Secondary = "Glock-18", Melee = "T Knife"},
}
local u72 = {Primary = "Rifles", Secondary = "Pistols"}
local u73 = {
    Bomb = "C4",
    Grenade1 = "HE Grenade",
    Grenade2 = "Flashbang",
    Grenade3 = "Smoke Grenade",
    Grenade4 = "Molotov",
}
local MAX_TRANSPARENCY = Mobile.MAX_TRANSPARENCY

local function TransparencyToSlider(a1) -- Line: 50 -- upvalues: MAX_TRANSPARENCY (val) -- types: a1: number
    return (math.clamp(a1 / MAX_TRANSPARENCY, 0, 1))
end

local function SliderToTransparency(a1) -- Line: 54 -- upvalues: MAX_TRANSPARENCY (val) -- types: a1: number
    return (math.clamp(a1, 0, 1)) * MAX_TRANSPARENCY
end

local u81 = Color3.fromRGB(255, 255, 255)
local u86 = Color3.fromRGB(40, 40, 40)
local u91 = Color3.fromRGB(255, 255, 255)
local u96 = Color3.fromRGB(255, 200, 0)
local u97 = {}
local v2 = {Name = "TopLeft", Cursor = "rbxasset://SystemCursors/SizeNWSE", Anchor = Vector2.new(0, 0)}
local v3 = {Name = "TopRight", Cursor = "rbxasset://SystemCursors/SizeNESW", Anchor = Vector2.new(1, 0)}
local v4 = {Name = "BottomLeft", Cursor = "rbxasset://SystemCursors/SizeNESW", Anchor = Vector2.new(0, 1)}
local v5 = {
    Name = "BottomRight",
    Cursor = "rbxasset://SystemCursors/SizeNWSE",
    Anchor = Vector2.new(1, 1),
}
local v6 = {Name = "Top", Cursor = "rbxasset://SystemCursors/SizeNS", Anchor = Vector2.new(0.5, 0)}
local v7 = {Name = "Bottom", Cursor = "rbxasset://SystemCursors/SizeNS", Anchor = Vector2.new(0.5, 1)}
local v8 = {Name = "Left", Cursor = "rbxasset://SystemCursors/SizeEW", Anchor = Vector2.new(0, 0.5)}
local v9 = {Name = "Right", Cursor = "rbxasset://SystemCursors/SizeEW", Anchor = Vector2.new(1, 0.5)}
u97[1] = v2
u97[2] = v3
u97[3] = v4
u97[4] = v5
u97[5] = v6
u97[6] = v7
u97[7] = v8
u97[8] = v9
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local LocalPlayer = Players.LocalPlayer
local u153 = nil
local u154 = nil
local u155 = nil
local u156 = false
local u157 = false
local u159 = Mobile.GetDefaultLayout()
local u161 = Mobile.GetDefaultLayout()
local u162 = false
local u163 = {}
local u164 = {}
local u165 = {}
local u166 = {}
local u167 = nil
local u168 = nil
local u169 = nil
local u170 = nil
local u171 = nil
local u172 = nil
local u173 = nil

local function IsTouchInputType(a1) -- Line: 139
    return a1 == Enum.UserInputType.Touch
end

local function IsPointerPress(a1) -- Line: 147 -- types: a1: userdata
    local v1
    if a1.UserInputType == Enum.UserInputType.Touch then
        v1 = a1.UserInputState == Enum.UserInputState.Begin
    else
        v1 = false
        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
            v1 = a1.UserInputState == Enum.UserInputState.Begin
        end
    end
    return v1
end

local function IsPointerMove(a1) -- Line: 152 -- types: a1: userdata
    local v1 = true
    if a1.UserInputType ~= Enum.UserInputType.Touch then
        v1 = a1.UserInputType == Enum.UserInputType.MouseMovement
    end
    return v1
end

local function IsPointerRelease(a1) -- Line: 156 -- types: a1: userdata
    local v1 = true
    if a1.UserInputType ~= Enum.UserInputType.Touch then
        v1 = a1.UserInputType == Enum.UserInputType.MouseButton1
    end
    return v1
end

local function IsSamePointer(a1, a2) -- Line: 162 -- types: a1: userdata, a2: userdata
    if a1 == a2 then
        return true
    end
    local UserInputType_2 = a1.UserInputType
    local UserInputType = a2.UserInputType
    local v1 = true
    if UserInputType_2 ~= Enum.UserInputType.MouseMovement then
        v1 = UserInputType_2 == Enum.UserInputType.MouseButton1
    end
    local v2 = true
    if UserInputType ~= Enum.UserInputType.MouseMovement then
        v2 = UserInputType == Enum.UserInputType.MouseButton1
    end
    return v1 and v2
end

local u179 = nil
local u180 = nil
local u181 = nil

local function RefreshMouseCursor() -- Line: 183 -- upvalues: u180 (ref), u181 (ref), u179 (ref), UserInputService (val)
    local v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
end

local function SetHoveredCursor(a1) -- Line: 190
    -- upvalues: u179 (ref), u180 (ref), u181 (ref), UserInputService (val)
    local v1 = u180 or u181 or a1 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
end

local function SetActiveResizeCursor(a1) -- Line: 195
    -- upvalues: u180 (ref), u181 (ref), u179 (ref), UserInputService (val)
    local v1 = a1 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
end

local function SetActiveDragCursor(a1) -- Line: 200
    -- upvalues: u181 (ref), u180 (ref), u179 (ref), UserInputService (val)
    local v1 = u180 or a1 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
end

local function IsMobilePlatform() -- Line: 205 -- upvalues: GetUserPlatform (val)
    local v1 = GetUserPlatform()
    local v2 = false
    if table.find(v1, "Mobile") ~= nil then
        v2 = #v1 <= 1
    end
    return v2
end

local function ShouldShowMobileHUDEditor(a1) -- Line: 210 -- upvalues: GetUserPlatform (val), UserInputService (val)
    local v1 = GetUserPlatform()
    local v2 = false
    if table.find(v1, "Mobile") ~= nil then
        v2 = #v1 <= 1
    end
    if not v2 then
        v2 = (a1 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch
    end
    return v2
end

local function CopyPositionAndSize(a1) -- Line: 217
    return {
        Position = {X = a1.Position.X, Y = a1.Position.Y},
        Size = {X = a1.Size.X, Y = a1.Size.Y},
    }
end

local function DeepCopyLayout(a1) -- Line: 224 -- upvalues: Mobile (val), CopyPositionAndSize (val)
    local v1, v2
    local v3 = {}
    for i, v in ipairs(Mobile.GetButtonNames()) do
        v1 = a1[v] or Mobile.GetDefaultButtonLayout(v)
        v2 = CopyPositionAndSize(v1)
        v2.Transparency = v1.Transparency
        v2.Enabled = v1.Enabled
        v3[v] = v2
    end
    return v3
end

local function GetInputGuiPosition(a1) -- Line: 238 -- upvalues: GuiService (val) -- types: a1: userdata
    local GuiInset = GuiService:GetGuiInset()
    return Vector2.new(a1.Position.X - GuiInset.X, a1.Position.Y - GuiInset.Y)
end

local function GetInputScreenPosition(a1) -- Line: 245 -- types: a1: userdata
    return Vector2.new(a1.Position.X, a1.Position.Y)
end

local function SetChildFrameVisible(a1, a2, a3) -- Line: 251 -- types: a1: userdata?, a2: string, a3: boolean
    if not a1 then
        return
    end
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("Frame") then
        v1.Visible = a3
    end
end

local function PlayUIClick() -- Line: 263 -- upvalues: Router (val)
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
end

local function GetEditMobileEntryButton() -- Line: 269 -- upvalues: u154 (ref)
    local Holder = u154 and u154:FindFirstChild("Holder")
    local EditMobile = Holder and Holder:IsA("Frame") and Holder:FindFirstChild("EditMobile")
    if EditMobile and EditMobile:IsA("Frame") then
        return (EditMobile:FindFirstChild("EditMobile"))
    end
    return nil
end

local function GetEditMobileFrame() -- Line: 281 -- upvalues: u155 (ref), u154 (ref)
    local v1 = u155
    if v1 and v1.Parent then
        return v1
    end
    local v2 = u154
    if not v2 then
        return nil
    end
    v1 = v2:FindFirstChild("EditMobile")
    if not v1 and v2.Name == "EditMobile" then
        v1 = v2
    end
    u155 = v1
    return v1
end

local function GetMenuTopFrame() -- Line: 302 -- upvalues: u153 (ref)
    local Menu = u153 and u153:FindFirstChild("Menu")
    local Top = Menu and Menu:IsA("Frame") and Menu:FindFirstChild("Top")
    if Top and Top:IsA("Frame") then
        return Top
    end
    return nil
end

local function GetEditorButtonsFrame() -- Line: 310 -- upvalues: u155 (ref), u154 (ref)
    local v1
    local v2 = u155
    if not v2 or not v2.Parent then
        local v3 = u154
        if v3 then
            v2 = v3:FindFirstChild("EditMobile")
            if not v2 and v3.Name == "EditMobile" then
                v2 = v3
            end
            u155 = v2
            v1 = v2
        else
            v1 = nil
        end
    else
        v1 = v2
    end
    if not v1 then
        return nil
    end
    return (v1:FindFirstChild("MobileButtons"))
end

local function GetGameplayMobileButtonsFrame() -- Line: 320 -- upvalues: u153 (ref)
    if not u153 then
        return nil
    end
    local Parent = u153.Parent
    local MobileControlsGui = Parent and Parent:FindFirstChild("MobileControlsGui")
    local MobileButtons = MobileControlsGui and MobileControlsGui:FindFirstChild("MobileButtons")
    if MobileButtons and MobileButtons:IsA("Frame") then
        return MobileButtons
    end
    local Gameplay = u153:FindFirstChild("Gameplay")
    local Middle = Gameplay and Gameplay:FindFirstChild("Middle")
    local MobileButtons_2 = Middle and Middle:FindFirstChild("MobileButtons")
    if MobileButtons_2 and MobileButtons_2:IsA("Frame") then
        return MobileButtons_2
    end
    return nil
end

local function ApplyEditorButtonLayout(a1) -- Line: 341
    -- upvalues: u155 (ref), u154 (ref), u161 (ref), ApplyMobileButtonLayout (val)
    local v1, v2, v3
    local v4 = u155
    if not v4 or not v4.Parent then
        v3 = u154
        if v3 then
            v4 = v3:FindFirstChild("EditMobile")
            if not v4 and v3.Name == "EditMobile" then
                v4 = v3
            end
            u155 = v4
            v2 = v4
        else
            v2 = nil
        end
    else
        v2 = v4
    end
    if not (if v2 then v2:FindFirstChild("MobileButtons") else nil) then
        return
    end
    v2 = v1:FindFirstChild(a1)
    v4 = u161[a1]
    if v2 and v2:IsA("GuiObject") and v4 then
        v3 = v4
        if not v4.Enabled then
            v3 = table.clone(v4)
            v3.Transparency = math.max(v4.Transparency, 0.75)
        end
        ApplyMobileButtonLayout(v2, v3)
        return
    end
end

local function ApplyEditorLayout() -- Line: 365 -- upvalues: Mobile (val), ApplyEditorButtonLayout (val)
    for i, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v)
    end
end

local function GetConfigureRefs() -- Line: 386 -- upvalues: u168 (ref)
    local v1 = u168
    if not v1 then
        return nil
    end
    local Button = v1:FindFirstChild("Button", true)
    local Enabled = v1:FindFirstChild("Enabled")
    if Enabled then
        local Header = Enabled:FindFirstChild("Header")
        Button = Header and Header:FindFirstChild("Button") or Button
    end
    local Transparency = v1:FindFirstChild("Transparency")
    local Slider = Transparency and Transparency:FindFirstChild("Slider", true)
    if Slider and not Slider:IsA("GuiButton") then
        Slider = Slider:FindFirstChild("Slider")
    end
    if Button and Button:IsA("GuiButton") and Slider and Slider:IsA("GuiButton") then
        local Button_3 = Slider:FindFirstChild("Button")
        local Bar = Slider:FindFirstChild("Bar")
        if Button_3 and Button_3:IsA("GuiObject") and Bar and Bar:IsA("GuiObject") then
            local Amount = Transparency and Transparency:FindFirstChild("Amount", true)
            local Title = Amount and Amount:FindFirstChild("Title")
            local v2 = {
                Frame = v1,
                EnabledButton = Button,
                EnabledCheck = Button:FindFirstChildWhichIsA("ImageLabel"),
                SliderTrack = Slider,
                SliderKnob = Button_3,
                SliderBar = Bar,
            }
            v2.ValueBox = if not Title then nil else if not Title:IsA("TextBox") then nil else Title
            return v2
        end
        return nil
    end
    return nil
end

local function GetSelectedButtonLayout() -- Line: 431 -- upvalues: u167 (ref), u161 (ref)
    local v1 = u167
    if not v1 then
        return nil, nil
    end
    return v1, u161[v1]
end

local function RefreshConfigurePanel() -- Line: 441
    -- upvalues: GetConfigureRefs (val), u167 (ref), u161 (ref), u156 (ref), MAX_TRANSPARENCY (val)
    local v1, v2
    local v3 = GetConfigureRefs()
    if not v3 then
        return
    end
    local v4 = u167
    if v4 then
        v1 = v4
        v2 = u161[v4]
    else
        v1 = nil
        v2 = nil
    end
    if u156 and v1 and v2 then
        v3.Frame.Visible = true
        if v3.EnabledCheck then
            v3.EnabledCheck.Visible = v2.Enabled
        end
        v4 = math.clamp(v2.Transparency / MAX_TRANSPARENCY, 0, 1)
        v3.SliderBar.Size = UDim2.new(v4, 0, v3.SliderBar.Size.Y.Scale, v3.SliderBar.Size.Y.Offset)
        v3.SliderKnob.Position = UDim2.new(v4, 0, v3.SliderKnob.Position.Y.Scale, v3.SliderKnob.Position.Y.Offset)
        if v3.ValueBox and not v3.ValueBox:IsFocused() then
            v3.ValueBox.Text = string.format("%d%%", (math.round(v4 * 100)))
        end
        return
    end
    v3.Frame.Visible = false
end

local function SetSelectedButtonTransparency(a1) -- Line: 470
    -- upvalues: u167 (ref), u161 (ref), MAX_TRANSPARENCY (val), ApplyEditorButtonLayout (val)
    -- upvalues: RefreshConfigurePanel (val)
    local v1, v2
    local v3 = u167
    if v3 then
        v1 = v3
        v2 = u161[v3]
    else
        v1 = nil
        v2 = nil
    end
    if v1 and v2 then
        local v4 = (math.clamp((math.round((math.clamp(a1, 0, 1)) / 0.01)) * 0.01, 0, 1)) * MAX_TRANSPARENCY
        if v2.Transparency == v4 then
            return
        end
        v2.Transparency = v4
        ApplyEditorButtonLayout(v1)
        RefreshConfigurePanel()
        return
    end
end

local function SetSelectedButtonEnabled(a1) -- Line: 487
    -- upvalues: u167 (ref), u161 (ref), ApplyEditorButtonLayout (val), RefreshConfigurePanel (val)
    local v1, v2
    local v3 = u167
    if v3 then
        v1 = v3
        v2 = u161[v3]
    else
        v1 = nil
        v2 = nil
    end
    if v1 and v2 then
        v2.Enabled = a1
        ApplyEditorButtonLayout(v1)
        RefreshConfigurePanel()
        return
    end
end

local u206 = nil
local u207 = nil

local function CreateSelectionHandle(a1, a2) -- Line: 504
    -- upvalues: u81 (val), u86 (val), u156 (ref), u179 (ref), u180 (ref), u181 (ref), UserInputService (val)
    -- upvalues: u167 (ref), u171 (ref), u173 (ref), u206 (ref)
    local Frame = Instance.new("Frame")
    Frame.Name = a2.Name
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(a2.Anchor.X, a2.Anchor.Y)
    Frame.Size = UDim2.fromOffset(17, 17)
    Frame.ZIndex = a1.ZIndex + 2
    Frame.Active = true
    local Frame_2 = Instance.new("Frame")
    Frame_2.Name = "Square"
    Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame_2.Position = UDim2.fromScale(0.5, 0.5)
    Frame_2.Size = UDim2.fromOffset(7, 7)
    Frame_2.BackgroundColor3 = u81
    Frame_2.BorderSizePixel = 0
    Frame_2.ZIndex = Frame.ZIndex
    Frame_2.Parent = Frame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = u86
    UIStroke.Parent = Frame_2
    Frame.MouseEnter:Connect(function() -- Line: 538
        -- upvalues: u156 (upval), a2 (val), u179 (upval), u180 (upval), u181 (upval), UserInputService (upval)
        if u156 then
            u179 = a2.Cursor
            local v1 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v1 then
                UserInputService.MouseIcon = v1
            end
        end
    end)
    Frame.MouseLeave:Connect(function() -- Line: 543 -- upvalues: u179 (upval), a2 (val), u180 (upval), u181 (upval), UserInputService (upval)
        if u179 == a2.Cursor then
            u179 = nil
            local v1 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v1 then
                UserInputService.MouseIcon = v1
            end
        end
    end)
    Frame.InputBegan:Connect(function(a1) -- Line: 549
        -- upvalues: u156 (upval), u167 (upval), u171 (upval), u173 (upval), u206 (upval), a2 (val), u180 (upval)
        -- upvalues: u181 (upval), u179 (upval), UserInputService (upval)
        if u156 and u167 then
            local v1
            if a1.UserInputType == Enum.UserInputType.Touch then
                v1 = a1.UserInputState == Enum.UserInputState.Begin
            else
                v1 = false
                if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                    v1 = a1.UserInputState == Enum.UserInputState.Begin
                end
            end
            if not v1 then
                return
            end
            if not u171 and not u173 then
                u206(u167, a2.Anchor, a1)
                u180 = a2.Cursor
                local v2 = u180 or u181 or u179 or ""
                if UserInputService.MouseIcon ~= v2 then
                    UserInputService.MouseIcon = v2
                end
                return
            end
            return
        end
    end)
    Frame.Parent = a1
end

local function GetOrCreateSelectionOutline() -- Line: 566
    -- upvalues: u169 (ref), u155 (ref), u154 (ref), u91 (val), u97 (val), CreateSelectionHandle (val), u156 (ref)
    -- upvalues: u167 (ref), u179 (ref), u180 (ref), u181 (ref), UserInputService (val), u207 (ref), u96 (val)
    local v1, v2
    if u169 and u169.Parent then
        return u169
    end
    local v3 = u155
    if not v3 or not v3.Parent then
        local v4 = u154
        if v4 then
            v3 = v4:FindFirstChild("EditMobile")
            if not v3 and v4.Name == "EditMobile" then
                v3 = v4
            end
            u155 = v3
            v2 = v3
        else
            v2 = nil
        end
    else
        v2 = v3
    end
    if not (if v2 then v2:FindFirstChild("MobileButtons") else nil) then
        return nil
    end
    local Frame = Instance.new("Frame")
    Frame.Name = "Selection"
    Frame.AnchorPoint = Vector2.new(0, 0)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 50
    Frame.Visible = false
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "Stroke"
    UIStroke.Thickness = 2
    UIStroke.Color = u91
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
    UIStroke.Parent = Frame
    for i, v in ipairs(u97) do
        CreateSelectionHandle(Frame, v)
    end
    Frame.Active = true
    Frame.MouseEnter:Connect(function() -- Line: 600
        -- upvalues: u156 (upval), u167 (upval), u179 (upval), u180 (upval), u181 (upval), UserInputService (upval)
        if u156 and u167 then
            u179 = "rbxasset://SystemCursors/SizeAll"
            local v1 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v1 then
                UserInputService.MouseIcon = v1
            end
        end
    end)
    Frame.MouseLeave:Connect(function() -- Line: 605 -- upvalues: u179 (upval), u180 (upval), u181 (upval), UserInputService (upval)
        if u179 == "rbxasset://SystemCursors/SizeAll" then
            u179 = nil
            local v1 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v1 then
                UserInputService.MouseIcon = v1
            end
        end
    end)
    Frame.InputBegan:Connect(function(a1) -- Line: 610 -- upvalues: u156 (upval), u167 (upval), u207 (upval) -- types: a1: userdata
        if u156 and u167 then
            local v1
            if a1.UserInputType == Enum.UserInputType.Touch then
                v1 = a1.UserInputState == Enum.UserInputState.Begin
            else
                v1 = false
                if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                    v1 = a1.UserInputState == Enum.UserInputState.Begin
                end
            end
            if v1 then
                u207(u167, a1)
                return
            end
        end
    end)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "SizeLabel"
    TextLabel.AnchorPoint = Vector2.new(1, 0)
    TextLabel.Position = UDim2.new(1, 0, 1, 7)
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY
    TextLabel.Size = UDim2.fromOffset(0, 0)
    TextLabel.BackgroundColor3 = u96
    TextLabel.BorderSizePixel = 0
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.TextSize = 12
    TextLabel.Text = ""
    TextLabel.ZIndex = Frame.ZIndex + 1
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 6)
    UIPadding.PaddingRight = UDim.new(0, 6)
    UIPadding.PaddingTop = UDim.new(0, 2)
    UIPadding.PaddingBottom = UDim.new(0, 2)
    UIPadding.Parent = TextLabel
    TextLabel.Parent = Frame
    Frame.Parent = v1
    u169 = Frame
    return Frame
end

local function UpdateSelectionOutline() -- Line: 647
    -- upvalues: GetOrCreateSelectionOutline (val), u155 (ref), u154 (ref), u167 (ref), u156 (ref), u161 (ref)
    local v1, v2
    local v3 = GetOrCreateSelectionOutline()
    local v4 = u155
    if not v4 or not v4.Parent then
        v2 = u154
        if v2 then
            v4 = v2:FindFirstChild("EditMobile")
            if not v4 and v2.Name == "EditMobile" then
                v4 = v2
            end
            u155 = v4
            v1 = v4
        else
            v1 = nil
        end
    else
        v1 = v4
    end
    local v5 = if v1 then v1:FindFirstChild("MobileButtons") else nil
    v1 = u167
    if v3 and v5 then
        v4 = v1 and v5:FindFirstChild(v1)
        if u156 and v4 and v4:IsA("GuiObject") then
            v2 = v4.AbsolutePosition - v5.AbsolutePosition
            v3.Position = UDim2.fromOffset(v2.X - 4, v2.Y - 4)
            v3.Size = UDim2.fromOffset(v4.AbsoluteSize.X + 8, v4.AbsoluteSize.Y + 8)
            local SizeLabel = v3:FindFirstChild("SizeLabel")
            if SizeLabel then
                local v6 = v1 and u161[v1]
                if not v6 then
                    SizeLabel.Text = ""
                else
                    SizeLabel.Text = string.format(("%%.%*f x %%.%*f"):format(3, 3), v6.Size.X, v6.Size.Y)
                end
            end
            v3.Visible = true
            return
        end
        v3.Visible = false
        return
    end
end

local u211 = nil

local function SelectEditorButton(a1) -- Line: 685
    -- upvalues: u167 (ref), RefreshConfigurePanel (val), u211 (ref), u156 (ref), GetOrCreateSelectionOutline (val)
    -- upvalues: UpdateSelectionOutline (val), RunService (val), u171 (ref), u180 (ref), u181 (ref), u179 (ref)
    -- upvalues: UserInputService (val), u169 (ref)
    u167 = a1
    RefreshConfigurePanel()
    if u211 then
        u211:Disconnect()
        u211 = nil
    end
    if a1 and u156 then
        if not GetOrCreateSelectionOutline() then
            return
        end
        UpdateSelectionOutline()
        u211 = RunService.RenderStepped:Connect(UpdateSelectionOutline)
        return
    end
    u171 = nil
    u180 = nil
    local v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
    if u169 then
        u169.Visible = false
    end
end

local function SetupConfigurePanel(a1) -- Line: 712
    -- upvalues: u168 (ref), GetConfigureRefs (val), ActivateButton (val), u167 (ref), u161 (ref), Router (val)
    -- upvalues: ApplyEditorButtonLayout (val), RefreshConfigurePanel (val), SetSelectedButtonTransparency (val)
    -- upvalues: u170 (ref), GuiService (val), UserInputService (val)
    local Configure = a1:FindFirstChild("Configure")
    if Configure and Configure:IsA("Frame") then
        u168 = Configure
        Configure.Visible = false
        local v1 = GetConfigureRefs()
        if not v1 then
            warn("[MobileHUDEditor] EditMobile.Configure is missing its Enabled button or slider parts")
            return
        end
        ActivateButton(v1.EnabledButton)
        v1.EnabledButton.MouseButton1Click:Connect(function() -- Line: 729
            -- upvalues: u167 (upval), u161 (upval), Router (upval), ApplyEditorButtonLayout (upval)
            -- upvalues: RefreshConfigurePanel (upval)
            local v1 = u167
            local v2 = if v1 then u161[v1] else nil
            if v2 then
                local v3, v4
                Router.broadcastRouter("RunInterfaceSound", "UI Click")
                v1 = not v2.Enabled
                local v5 = u167
                if v5 then
                    v3 = v5
                    v4 = u161[v5]
                else
                    v3 = nil
                    v4 = nil
                end
                if v3 then
                    if not v4 then
                        return
                    end
                    v4.Enabled = v1
                    ApplyEditorButtonLayout(v3)
                    RefreshConfigurePanel()
                end
            end
        end)
        local SliderTrack = v1.SliderTrack
        local SliderKnob = v1.SliderKnob
        SliderTrack.AutoButtonColor = false
        if SliderKnob:IsA("GuiButton") then
            SliderKnob.AutoButtonColor = false
        end

        local function IsPointerInput(a1) -- Line: 745 -- types: a1: userdata
            local v1 = true
            if a1.UserInputType ~= Enum.UserInputType.MouseButton1 then
                v1 = a1.UserInputType == Enum.UserInputType.Touch
            end
            return v1
        end

        local function SetFromScreenX(a1) -- Line: 749
            -- upvalues: SliderTrack (val), SetSelectedButtonTransparency (upval)
            local v1 = math.max(SliderTrack.AbsoluteSize.X, 1)
            local v2 = math.clamp((a1 - SliderTrack.AbsolutePosition.X) / v1, 0, 1)
            SetSelectedButtonTransparency(v2)
        end

        local function BeginSliderDrag(a1) -- Line: 755
            -- upvalues: u170 (upval), GuiService (upval), SliderTrack (val), SetSelectedButtonTransparency (upval)
            local v1 = true
            if a1.UserInputType ~= Enum.UserInputType.MouseButton1 then
                v1 = a1.UserInputType == Enum.UserInputType.Touch
            end
            if v1 and not u170 then
                u170 = a1
                local GuiInset = GuiService:GetGuiInset()
                local X = (Vector2.new(a1.Position.X - GuiInset.X, a1.Position.Y - GuiInset.Y)).X
                local v2 = math.max(SliderTrack.AbsoluteSize.X, 1)
                local v3 = math.clamp((X - SliderTrack.AbsolutePosition.X) / v2, 0, 1)
                SetSelectedButtonTransparency(v3)
                return
            end
        end

        SliderTrack.InputBegan:Connect(BeginSliderDrag)
        SliderKnob.InputBegan:Connect(BeginSliderDrag)
        UserInputService.InputChanged:Connect(function(a1) -- Line: 766
            -- upvalues: u170 (upval), GuiService (upval), SliderTrack (val), SetSelectedButtonTransparency (upval)
            local v1 = u170
            if not v1 then
                return
            end
            if a1 == v1
                or v1.UserInputType == Enum.UserInputType.MouseButton1 and a1.UserInputType == Enum.UserInputType.MouseMovement then
                local GuiInset = GuiService:GetGuiInset()
                local X = (Vector2.new(a1.Position.X - GuiInset.X, a1.Position.Y - GuiInset.Y)).X
                local v2 = math.max(SliderTrack.AbsoluteSize.X, 1)
                local v3 = math.clamp((X - SliderTrack.AbsolutePosition.X) / v2, 0, 1)
                SetSelectedButtonTransparency(v3)
            end
        end)
        UserInputService.InputEnded:Connect(function(a1) -- Line: 777 -- upvalues: u170 (upval) -- types: a1: userdata
            local v1 = u170
            if not v1 then
                return
            end
            if a1 == v1
                or v1.UserInputType == Enum.UserInputType.MouseButton1 and a1.UserInputType == Enum.UserInputType.MouseButton1 then
                u170 = nil
            end
        end)
        local ValueBox = v1.ValueBox
        if ValueBox then
            ValueBox.FocusLost:Connect(function() -- Line: 790
                -- upvalues: ValueBox (val), SetSelectedButtonTransparency (upval), RefreshConfigurePanel (upval)
                local v1 = tonumber((string.gsub(ValueBox.Text, "[^%d%.]", "")))
                if v1 then
                    SetSelectedButtonTransparency(v1 / 100)
                end
                RefreshConfigurePanel()
            end)
        end
        return
    end
    warn("[MobileHUDEditor] EditMobile.Configure frame not found; transparency / enabled editing unavailable")
end

local function HideDashboardPanels() -- Line: 802 -- upvalues: u154 (ref), u155 (ref), u163 (val)
    local v1
    local v2 = u154
    local v3 = u155
    if not v3 or not v3.Parent then
        local v4 = u154
        if v4 then
            v3 = v4:FindFirstChild("EditMobile")
            if not v3 and v4.Name == "EditMobile" then
                v3 = v4
            end
            u155 = v3
            v1 = v3
        else
            v1 = nil
        end
    else
        v1 = v3
    end
    if not v2 then
        return
    end
    for i, v in ipairs(v2:GetChildren()) do
        if v ~= v1 and v:IsA("GuiObject") and v.Visible then
            u163[v] = true
            v.Visible = false
        end
    end
end

local function RestoreDashboardPanels() -- Line: 821 -- upvalues: u163 (val)
    for k in pairs(u163) do
        if k.Parent then
            k.Visible = true
        end
    end
    table.clear(u163)
end

local function SetDashboardEditorVisibility(a1) -- Line: 833
    -- upvalues: u155 (ref), u154 (ref), u153 (ref), MenuState (val), HideDashboardPanels (val), u163 (val)
    local v1
    local v2 = u155
    if not v2 or not v2.Parent then
        local v3 = u154
        if v3 then
            v2 = v3:FindFirstChild("EditMobile")
            if not v2 and v3.Name == "EditMobile" then
                v2 = v3
            end
            u155 = v2
            v1 = v2
        else
            v1 = nil
        end
    else
        v1 = v2
    end
    if v1 then
        v1.Visible = a1
        if v1 then
            local Action = v1:FindFirstChild("Action")
            if Action and Action:IsA("Frame") then
                Action.Visible = a1
            end
        end
        if v1 then
            local MobileButtons = v1:FindFirstChild("MobileButtons")
            if MobileButtons and MobileButtons:IsA("Frame") then
                MobileButtons.Visible = a1
            end
        end
    end
    local Menu = u153 and u153:FindFirstChild("Menu")
    local Top = Menu and Menu:IsA("Frame") and Menu:FindFirstChild("Top")
    v2 = if not Top then nil else if not Top:IsA("Frame") then nil else Top
    if v2 then
        if a1 then
            v2.Visible = false
        elseif not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
            v2.Visible = true
        end
    end
    if a1 then
        HideDashboardPanels()
        return
    end
    for k in pairs(u163) do
        if k.Parent then
            k.Visible = true
        end
    end
    table.clear(u163)
end

local function EnforceEditorVisibilityLock() -- Line: 859 -- upvalues: u156 (ref), u153 (ref), u163 (val)
    if not u156 then
        return
    end
    local Menu = u153 and u153:FindFirstChild("Menu")
    local Top = Menu and Menu:IsA("Frame") and Menu:FindFirstChild("Top")
    local v1 = if not Top then nil else if not Top:IsA("Frame") then nil else Top
    if v1 and v1.Visible then
        v1.Visible = false
    end
    for k in pairs(u163) do
        if k.Visible then
            k.Visible = false
        end
    end
end

local function ConnectEditorVisibilityGuards() -- Line: 878
    -- upvalues: u162 (ref), u154 (ref), u153 (ref), EnforceEditorVisibilityLock (val), u155 (ref)
    if u162 then
        return
    end
    local v1 = u154
    local Menu = u153 and u153:FindFirstChild("Menu")
    local Top = Menu and Menu:IsA("Frame") and Menu:FindFirstChild("Top")
    local v2 = if not Top then nil else if not Top:IsA("Frame") then nil else Top
    if not v1 and not v2 then
        return
    end
    u162 = true
    if v2 then
        (v2:GetPropertyChangedSignal("Visible")):Connect(EnforceEditorVisibilityLock)
    end
    if v1 then
        local v3
        local v4 = u155
        if not v4 or not v4.Parent then
            local v5 = u154
            if v5 then
                v4 = v5:FindFirstChild("EditMobile")
                if not v4 and v5.Name == "EditMobile" then
                    v4 = v5
                end
                u155 = v4
                v3 = v4
            else
                v3 = nil
            end
        else
            v3 = v4
        end
        for i, v in ipairs(v1:GetChildren()) do
            if v ~= v3 and v:IsA("GuiObject") then
                (v:GetPropertyChangedSignal("Visible")):Connect(EnforceEditorVisibilityLock)
            end
        end
    end
end

local function ClearEditorInteractionState() -- Line: 907
    -- upvalues: u164 (ref), u165 (ref), u166 (ref), u172 (ref), u173 (ref), u171 (ref), u180 (ref), u181 (ref)
    -- upvalues: u179 (ref), UserInputService (val)
    u164 = {}
    u165 = {}
    u166 = {}
    u172 = nil
    u173 = nil
    u171 = nil
    u180 = nil
    local v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
    u181 = nil
    v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
    u179 = nil
    v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
end

local function RemoveTouchFromButton(a1) -- Line: 921 -- upvalues: u164 (ref), u165 (ref) -- types: a1: userdata
    local v1 = u164[a1]
    if not v1 then
        return nil
    end
    u164[a1] = nil
    local v2 = u165[v1]
    if v2 then
        v2[a1] = nil
        if next(v2) == nil then
            u165[v1] = nil
        end
    end
    return v1
end

local function GetButtonTouches(a1) -- Line: 941 -- upvalues: u165 (ref) -- types: a1: string
    local v1 = u165[a1]
    if not v1 then
        return {}
    end
    local v2 = {}
    for k in pairs(v1) do
        table.insert(v2, k)
    end
    return v2
end

local function UpdateEditorButtonLayout(a1, a2) -- Line: 957
    -- upvalues: u161 (ref), Mobile (val), ApplyEditorButtonLayout (val)
    local v1 = u161[a1] or Mobile.GetDefaultButtonLayout(a1)
    local v2 = u161
    local ClampButtonLayout = Mobile.ClampButtonLayout
    local v3 = {Position = a2.Position, Size = a2.Size}
    local Transparency = if a2.Transparency == nil then v1.Transparency else a2.Transparency
    v3.Transparency = Transparency
    local Enabled = if a2.Enabled == nil then v1.Enabled else a2.Enabled
    v3.Enabled = Enabled
    v2[a1] = (ClampButtonLayout(v3))
    ApplyEditorButtonLayout(a1)
end

local function StartEditorDrag(a1, a2) -- Line: 970
    -- upvalues: u161 (ref), u173 (ref), u181 (ref), u180 (ref), u179 (ref), UserInputService (val), u172 (ref)
    -- upvalues: GuiService (val), CopyPositionAndSize (val)
    local v1
    local v2 = u161[a1]
    if not v2 then
        return
    end
    u173 = nil
    if a2.UserInputType == Enum.UserInputType.MouseButton1 then
        u181 = "rbxasset://SystemCursors/SizeAll"
        v1 = u180 or u181 or u179 or ""
        if UserInputService.MouseIcon ~= v1 then
            UserInputService.MouseIcon = v1
        end
    end
    v1 = {buttonName = a1, input = a2}
    local GuiInset = GuiService:GetGuiInset()
    v1.startPosition = Vector2.new(a2.Position.X - GuiInset.X, a2.Position.Y - GuiInset.Y)
    v1.startLayout = CopyPositionAndSize(v2)
    u172 = v1
end

local function StartEditorPinch(a1, a2, a3) -- Line: 991
    -- upvalues: u161 (ref), u155 (ref), u154 (ref), u172 (ref), u173 (ref), CopyPositionAndSize (val)
    local v1, v2
    local v3 = u161[a1]
    if not v3 then
        return
    end
    local v4 = u155
    if not v4 or not v4.Parent then
        local v5 = u154
        if v5 then
            v4 = v5:FindFirstChild("EditMobile")
            if not v4 and v5.Name == "EditMobile" then
                v4 = v5
            end
            u155 = v4
            v2 = v4
        else
            v2 = nil
        end
    else
        v2 = v4
    end
    if not (if v2 then v2:FindFirstChild("MobileButtons") else nil) then
        return
    end
    local AbsoluteSize = v1.AbsoluteSize
    if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
        v4 = Vector2.new(a2.Position.X, a2.Position.Y)
        local AbsolutePosition = v1.AbsolutePosition
        local v6 = math.max(((Vector2.new(a3.Position.X, a3.Position.Y)) - v4).Magnitude, 1)
        local v7 = Vector2.new((v4.X - AbsolutePosition.X) / AbsoluteSize.X, (v4.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
        local v8 = if not (0 < v3.Size.X) then 0.5 else (v7.X - v3.Position.X) / v3.Size.X
        local v9 = if not (0 < v3.Size.Y) then 0.5 else (v7.Y - v3.Position.Y) / v3.Size.Y
        u172 = nil
        u173 = {
            buttonName = a1,
            anchorInput = a2,
            scaleInput = a3,
            anchorLocalScale = Vector2.new(math.clamp(v8, 0, 1), (math.clamp(v9, 0, 1))),
            lastDistance = v6,
            lastLayout = CopyPositionAndSize(v3),
        }
        return
    end
end

function u206(a1, a2, a3) -- Line: 1042
    -- upvalues: u161 (ref), u172 (ref), u173 (ref), u171 (ref), GuiService (val)
    local v1 = u161[a1]
    if not v1 then
        return
    end
    u172 = nil
    u173 = nil
    local v2 = {buttonName = a1, input = a3, handleAnchor = a2}
    local GuiInset = GuiService:GetGuiInset()
    v2.startPosition = Vector2.new(a3.Position.X - GuiInset.X, a3.Position.Y - GuiInset.Y)
    v2.startLayout = {
        Position = {X = v1.Position.X, Y = v1.Position.Y},
        Size = {X = v1.Size.X, Y = v1.Size.Y},
        Transparency = v1.Transparency,
        Enabled = v1.Enabled,
    }
    u171 = v2
end

local function UpdateResizeFromInput(a1) -- Line: 1064
    -- upvalues: u171 (ref), u155 (ref), u154 (ref), GuiService (val), Mobile (val), UpdateEditorButtonLayout (val)
    local v1 = u171
    if v1 then
        local v2
        local input = v1.input
        if a1 ~= input then
            local UserInputType = a1.UserInputType
            local UserInputType_2 = input.UserInputType
            local v3 = true
            if UserInputType ~= Enum.UserInputType.MouseMovement then
                v3 = UserInputType == Enum.UserInputType.MouseButton1
            end
            local v4 = true
            if UserInputType_2 ~= Enum.UserInputType.MouseMovement then
                v4 = UserInputType_2 == Enum.UserInputType.MouseButton1
            end
            v2 = v3 and v4
        else
            v2 = true
        end
        if v2 then
            local v5, v6
            local v7 = u155
            if not v7 or not v7.Parent then
                v6 = u154
                if v6 then
                    v7 = v6:FindFirstChild("EditMobile")
                    if not v7 and v6.Name == "EditMobile" then
                        v7 = v6
                    end
                    u155 = v7
                    v5 = v7
                else
                    v5 = nil
                end
            else
                v5 = v7
            end
            if not (if v5 then v5:FindFirstChild("MobileButtons") else nil) then
                return
            end
            local AbsoluteSize = v2.AbsoluteSize
            if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
                local GuiInset = GuiService:GetGuiInset()
                v7 = Vector2.new(a1.Position.X - GuiInset.X, a1.Position.Y - GuiInset.Y) - v1.startPosition
                v6 = Vector2.new(v7.X / AbsoluteSize.X, v7.Y / AbsoluteSize.Y)
                local startLayout = v1.startLayout
                local handleAnchor = v1.handleAnchor
                local v8 = v2:FindFirstChild(v1.buttonName)
                local AnchorPoint = if not v8 then Vector2.new(0.5, 0.5) else if not v8:IsA("GuiObject") then Vector2.new(0.5, 0.5) else v8.AnchorPoint

                local function resolveSize(a1, a2, a3) -- Line: 1091
                    -- upvalues: Mobile (upval)
                    if a1 >= 1 then
                        return (math.clamp(a2 + a3, Mobile.MIN_SIZE, Mobile.MAX_SIZE))
                    end
                    if a1 <= 0 then
                        return (math.clamp(a2 - a3, Mobile.MIN_SIZE, Mobile.MAX_SIZE))
                    end
                    return a2
                end

                local function resolvePosition(a1, a2, a3, a4, a5) -- Line: 1101
                    -- upvalues: 
                    if a1 >= 1 then
                        return a3 + a2 * (a5 - a4)
                    end
                    if a1 <= 0 then
                        return a3 + (1 - a2) * (a4 - a5)
                    end
                    return a3
                end

                local X = handleAnchor.X
                local X_2 = startLayout.Size.X
                local X_3 = v6.X
                local v9 = if X >= 1 then math.clamp(X_2 + X_3, Mobile.MIN_SIZE, Mobile.MAX_SIZE) else if not (X <= 0) then X_2 else math.clamp(X_2 - X_3, Mobile.MIN_SIZE, Mobile.MAX_SIZE)
                local Y = handleAnchor.Y
                local Y_2 = startLayout.Size.Y
                local Y_3 = v6.Y
                local v10 = if Y >= 1 then math.clamp(Y_2 + Y_3, Mobile.MIN_SIZE, Mobile.MAX_SIZE) else if not (Y <= 0) then Y_2 else math.clamp(Y_2 - Y_3, Mobile.MIN_SIZE, Mobile.MAX_SIZE)
                local v11 = false
                if v8 ~= nil then
                    v11 = v8:FindFirstChildWhichIsA("UIAspectRatioConstraint", true) ~= nil
                end
                if v11 and 0 < startLayout.Size.X and 0 < startLayout.Size.Y then
                    local v12 = startLayout.Size.Y / startLayout.Size.X
                    local v13 = handleAnchor.X ~= 0.5
                    local v14 = handleAnchor.Y ~= 0.5
                    local v15 = v13
                    if v15 then
                        v15 = not v14
                        if not v15 then
                            local v16 = math.abs(v7.X)
                            v15 = math.abs(v7.Y) <= v16
                        end
                    end
                    if not v15 then
                        v10 = (math.clamp(v10 / v12, Mobile.MIN_SIZE, Mobile.MAX_SIZE)) * v12
                    else
                        v9 = (math.clamp(v9 * v12, Mobile.MIN_SIZE, Mobile.MAX_SIZE)) / v12
                    end
                end
                local X_5 = handleAnchor.X
                local X_6 = AnchorPoint.X
                local X_7 = startLayout.Position.X
                local X_8 = startLayout.Size.X
                local Y_5 = handleAnchor.Y
                local Y_6 = AnchorPoint.Y
                local Y_7 = startLayout.Position.Y
                local Y_8 = startLayout.Size.Y
                UpdateEditorButtonLayout(v1.buttonName, {
                    Position = {
                        X = if not (X_5 >= 1) then if not (X_5 <= 0) then X_7 else X_7 + (1 - X_6) * (X_8 - v9) else X_7 + X_6 * (v9 - X_8),
                        Y = if not (Y_5 >= 1) then if not (Y_5 <= 0) then Y_7 else Y_7 + (1 - Y_6) * (Y_8 - v10) else Y_7 + Y_6 * (v10 - Y_8),
                    },
                    Size = {X = v9, Y = v10},
                })
                return
            end
            return
        end
    end
end

local function TryStartEditorPinchWithSecondTouch(a1) -- Line: 1143
    -- upvalues: u172 (ref), u173 (ref), StartEditorPinch (val)
    local v1 = u172
    if v1 and not u173 and v1.input ~= a1 then
        StartEditorPinch(v1.buttonName, v1.input, a1)
        return
    end
end

local function RefreshEditorInteraction(a1) -- Line: 1154
    -- upvalues: u173 (ref), GetButtonTouches (val), u172 (ref), StartEditorDrag (val), u181 (ref), u180 (ref)
    -- upvalues: u179 (ref), UserInputService (val)
    local v1
    if u173 and u173.buttonName == a1 then
        return
    end
    local v2 = GetButtonTouches(a1)
    if #v2 > 0 then
        v1 = v2[1]
        local v3 = u172
        if v3 and v3.buttonName == a1 then
            for i, v in ipairs(v2) do
                if v == v3.input then
                    v1 = v
                    break
                end
            end
        end
        StartEditorDrag(a1, v1)
        return
    end
    if u172 and u172.buttonName == a1 then
        u172 = nil
        u181 = nil
        v1 = u180 or u181 or u179 or ""
        if UserInputService.MouseIcon ~= v1 then
            UserInputService.MouseIcon = v1
        end
    end
    if u173 and u173.buttonName == a1 then
        u173 = nil
    end
end

local function UpdateDragFromInput(a1) -- Line: 1187
    -- upvalues: u172 (ref), u155 (ref), u154 (ref), u161 (ref), GuiService (val), UpdateEditorButtonLayout (val)
    local v1 = u172
    if v1 then
        local v2, v3, v4
        local input = v1.input
        if a1 ~= input then
            local UserInputType = a1.UserInputType
            local UserInputType_2 = input.UserInputType
            v3 = true
            if UserInputType ~= Enum.UserInputType.MouseMovement then
                v3 = UserInputType == Enum.UserInputType.MouseButton1
            end
            v4 = true
            if UserInputType_2 ~= Enum.UserInputType.MouseMovement then
                v4 = UserInputType_2 == Enum.UserInputType.MouseButton1
            end
            v2 = v3 and v4
        else
            v2 = true
        end
        if v2 then
            local v5
            local v6 = u155
            if not v6 or not v6.Parent then
                local v7 = u154
                if v7 then
                    v6 = v7:FindFirstChild("EditMobile")
                    if not v6 and v7.Name == "EditMobile" then
                        v6 = v7
                    end
                    u155 = v6
                    v5 = v6
                else
                    v5 = nil
                end
            else
                v5 = v6
            end
            v2 = if v5 then v5:FindFirstChild("MobileButtons") else nil
            v5 = u161[v1.buttonName]
            if v2 and v5 then
                local AbsoluteSize = v2.AbsoluteSize
                if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
                    local GuiInset = GuiService:GetGuiInset()
                    v3 = (Vector2.new(a1.Position.X - GuiInset.X, a1.Position.Y - GuiInset.Y)) - v1.startPosition
                    v4 = v3.X / AbsoluteSize.X
                    local v8 = v3.Y / AbsoluteSize.Y
                    UpdateEditorButtonLayout(v1.buttonName, {
                        Position = {
                            X = v1.startLayout.Position.X + v4,
                            Y = v1.startLayout.Position.Y + v8,
                        },
                        Size = {X = v5.Size.X, Y = v5.Size.Y},
                    })
                    return
                end
                return
            end
            return
        end
    end
end

local function UpdatePinchFromInput(a1) -- Line: 1217
    -- upvalues: u173 (ref), u155 (ref), u154 (ref), UpdateEditorButtonLayout (val), u161 (ref)
    -- upvalues: CopyPositionAndSize (val)
    local v1, v2, v3
    local v4 = u173
    if not v4 then
        return
    end
    if a1 ~= v4.scaleInput and a1 ~= v4.anchorInput then
        return
    end
    local anchorInput = v4.anchorInput
    local v5 = Vector2.new(anchorInput.Position.X, anchorInput.Position.Y)
    local scaleInput = v4.scaleInput
    local v6 = Vector2.new(scaleInput.Position.X, scaleInput.Position.Y)
    local v7 = math.max((v6 - v5).Magnitude, 1)
    local v8 = v7 / math.max(v4.lastDistance, 1)
    local v9 = v4.lastLayout.Size.X * v8
    local v10 = v4.lastLayout.Size.Y * v8
    local v11 = u155
    if not v11 or not v11.Parent then
        v1 = u154
        if v1 then
            v11 = v1:FindFirstChild("EditMobile")
            if not v11 and v1.Name == "EditMobile" then
                v11 = v1
            end
            u155 = v11
            v3 = v11
        else
            v3 = nil
        end
    else
        v3 = v11
    end
    if not (if v3 then v3:FindFirstChild("MobileButtons") else nil) then
        return
    end
    local AbsoluteSize = v2.AbsoluteSize
    if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
        local v12
        local AbsolutePosition = v2.AbsolutePosition
        v1 = Vector2.new((v5.X - AbsolutePosition.X) / AbsoluteSize.X, (v5.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
        local v13 = v1.X - v4.anchorLocalScale.X * v9
        local v14 = v1.Y - v4.anchorLocalScale.Y * v10
        if v13 ~= v13 or v14 ~= v14 then
            v12 = (v5 + v6) * 0.5
            local v15 = Vector2.new((v12.X - AbsolutePosition.X) / AbsoluteSize.X, (v12.Y - AbsolutePosition.Y) / AbsoluteSize.Y)
            v13 = v15.X - v9 / 2
            v14 = v15.Y - v10 / 2
        end
        UpdateEditorButtonLayout(v4.buttonName, {Position = {X = v13, Y = v14}, Size = {X = v9, Y = v10}})
        v12 = u161[v4.buttonName]
        if v12 then
            v4.lastLayout = CopyPositionAndSize(v12)
        end
        v4.lastDistance = v7
        return
    end
end

local function LoadEditorStateFromProfile() -- Line: 1274
    -- upvalues: DataController (val), LocalPlayer (val), u159 (ref), Mobile (val), u161 (ref), DeepCopyLayout (val)
    -- upvalues: ApplyEditorButtonLayout (val)
    u159 = Mobile.SanitizeLayout((DataController.Get(LocalPlayer, "MobileButtons")))
    u161 = DeepCopyLayout(u159)
    for i, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v)
    end
end

local function ConnectEditorButtonGesture(a1) -- Line: 1285
    -- upvalues: u156 (ref), u179 (ref), u180 (ref), u181 (ref), UserInputService (val), u207 (ref)
    local Name = a1.Name
    a1.Active = true
    a1.MouseEnter:Connect(function() -- Line: 1294 -- upvalues: u156 (upval), u179 (upval), u180 (upval), u181 (upval), UserInputService (upval)
        if u156 then
            u179 = "rbxasset://SystemCursors/SizeAll"
            local v1 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v1 then
                UserInputService.MouseIcon = v1
            end
        end
    end)
    a1.MouseLeave:Connect(function() -- Line: 1299 -- upvalues: u179 (upval), u180 (upval), u181 (upval), UserInputService (upval)
        if u179 == "rbxasset://SystemCursors/SizeAll" then
            u179 = nil
            local v1 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v1 then
                UserInputService.MouseIcon = v1
            end
        end
    end)
    a1.InputBegan:Connect(function(a1) -- Line: 1304 -- upvalues: u156 (upval), u207 (upval), Name (val) -- types: a1: userdata
        if u156 then
            local v1
            if a1.UserInputType == Enum.UserInputType.Touch then
                v1 = a1.UserInputState == Enum.UserInputState.Begin
            else
                v1 = false
                if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                    v1 = a1.UserInputState == Enum.UserInputState.Begin
                end
            end
            if v1 then
                u207(Name, a1)
                return
            end
        end
    end)
end

function u207(a1, a2) -- Line: 1314
    -- upvalues: u164 (ref), u171 (ref), u173 (ref), u172 (ref), u165 (ref), u166 (ref), GuiService (val), u167 (ref)
    -- upvalues: SelectEditorButton (val), RefreshEditorInteraction (val)
    if u164[a2] or u171 then
        return
    end
    local buttonName = u173 and u173.buttonName or u172 and u172.buttonName
    if buttonName and buttonName ~= a1 then
        return
    end
    u164[a2] = a1
    local v1 = u165
    local v2 = u165[a1] or {}
    v1[a1] = v2
    v1 = u165[a1]
    v1[a2] = true
    v1 = u166
    local GuiInset = GuiService:GetGuiInset()
    v1[a2] = (Vector2.new(a2.Position.X - GuiInset.X, a2.Position.Y - GuiInset.Y))
    if u167 ~= a1 then
        SelectEditorButton(a1)
    end
    RefreshEditorInteraction(a1)
end

local function IsPointInsideGuiObject(a1, a2) -- Line: 1342 -- types: a1: userdata?, a2: userdata
    if a1 and a1.Visible then
        local AbsolutePosition = a1.AbsolutePosition
        local v1 = AbsolutePosition + a1.AbsoluteSize
        local v2 = false
        if AbsolutePosition.X <= a2.X then
            v2 = false
            if a2.X <= v1.X then
                v2 = false
                if AbsolutePosition.Y <= a2.Y then
                    v2 = a2.Y <= v1.Y
                end
            end
        end
        return v2
    end
    return false
end

local function TryDeselectFromEmptyTouch(a1) -- Line: 1353
    -- upvalues: u156 (ref), u167 (ref), u164 (ref), u171 (ref), u173 (ref), u168 (ref), u155 (ref), u154 (ref)
    -- upvalues: RefreshConfigurePanel (val), u211 (ref), u180 (ref), u181 (ref), u179 (ref), UserInputService (val)
    -- upvalues: u169 (ref)
    if u156 and u167 then
        local AbsolutePosition, AbsolutePosition_2, Action, v1, v2, v3, v4, v5, v6
        if u164[a1] then
            return
        end
        local v7 = u171
        if v7 and v7.input == a1 then
            return
        end
        local v8 = u173
        if not v8 then
            v1 = Vector2.new(a1.Position.X, a1.Position.Y)
            v3 = u168
            if not v3 then
                v2 = false
            elseif v3.Visible then
                AbsolutePosition = v3.AbsolutePosition
                v5 = AbsolutePosition + v3.AbsoluteSize
                v2 = false
                if AbsolutePosition.X <= v1.X then
                    v2 = false
                    if v1.X <= v5.X then
                        v2 = false
                        if AbsolutePosition.Y <= v1.Y then
                            v2 = v1.Y <= v5.Y
                        end
                    end
                end
            else
                v2 = false
            end
            if v2 then
                return
            end
            v3 = u155
            if not v3 or not v3.Parent then
                v4 = u154
                if v4 then
                    v3 = v4:FindFirstChild("EditMobile")
                    if not v3 and v4.Name == "EditMobile" then
                        v3 = v4
                    end
                    u155 = v3
                    v2 = v3
                else
                    v2 = nil
                end
            else
                v2 = v3
            end
            Action = v2 and v2:FindFirstChild("Action")
            if Action and Action:IsA("GuiObject") then
                if not Action then
                    v4 = false
                elseif Action.Visible then
                    AbsolutePosition_2 = Action.AbsolutePosition
                    v6 = AbsolutePosition_2 + Action.AbsoluteSize
                    v4 = false
                    if AbsolutePosition_2.X <= v1.X then
                        v4 = false
                        if v1.X <= v6.X then
                            v4 = false
                            if AbsolutePosition_2.Y <= v1.Y then
                                v4 = v1.Y <= v6.Y
                            end
                        end
                    end
                else
                    v4 = false
                end
                if v4 then
                    return
                end
            end
            u167 = nil
            RefreshConfigurePanel()
            if u211 then
                u211:Disconnect()
                u211 = nil
            end
            u171 = nil
            u180 = nil
            v4 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v4 then
                UserInputService.MouseIcon = v4
            end
            if u169 then
                u169.Visible = false
            end
            return
        end
        if v8.anchorInput ~= a1 and v8.scaleInput ~= a1 then
            v1 = Vector2.new(a1.Position.X, a1.Position.Y)
            v3 = u168
            if not v3 then
                v2 = false
            elseif v3.Visible then
                AbsolutePosition = v3.AbsolutePosition
                v5 = AbsolutePosition + v3.AbsoluteSize
                v2 = false
                if AbsolutePosition.X <= v1.X then
                    v2 = false
                    if v1.X <= v5.X then
                        v2 = false
                        if AbsolutePosition.Y <= v1.Y then
                            v2 = v1.Y <= v5.Y
                        end
                    end
                end
            else
                v2 = false
            end
            if v2 then
                return
            end
            v3 = u155
            if not v3 or not v3.Parent then
                v4 = u154
                if v4 then
                    v3 = v4:FindFirstChild("EditMobile")
                    if not v3 and v4.Name == "EditMobile" then
                        v3 = v4
                    end
                    u155 = v3
                    v2 = v3
                else
                    v2 = nil
                end
            else
                v2 = v3
            end
            Action = v2 and v2:FindFirstChild("Action")
            if Action and Action:IsA("GuiObject") then
                if not Action then
                    v4 = false
                elseif Action.Visible then
                    AbsolutePosition_2 = Action.AbsolutePosition
                    v6 = AbsolutePosition_2 + Action.AbsoluteSize
                    v4 = false
                    if AbsolutePosition_2.X <= v1.X then
                        v4 = false
                        if v1.X <= v6.X then
                            v4 = false
                            if AbsolutePosition_2.Y <= v1.Y then
                                v4 = v1.Y <= v6.Y
                            end
                        end
                    end
                else
                    v4 = false
                end
                if v4 then
                    return
                end
            end
            u167 = nil
            RefreshConfigurePanel()
            if u211 then
                u211:Disconnect()
                u211 = nil
            end
            u171 = nil
            u180 = nil
            v4 = u180 or u181 or u179 or ""
            if UserInputService.MouseIcon ~= v4 then
                UserInputService.MouseIcon = v4
            end
            if u169 then
                u169.Visible = false
            end
            return
        end
        return
    end
end

local function FindEquippedLoadoutItem(a1, a2, a3) -- Line: 1386
    -- upvalues: DataController (val), LocalPlayer (val), u72 (val)
    local v1 = DataController.Get(LocalPlayer, "Loadout")
    local u12 = DataController.Get(LocalPlayer, "Inventory")
    local v2 = false
    if typeof(v1) == "table" then
        v2 = v1[a1]
    end
    if typeof(v2) == "table" and typeof(u12) == "table" then
        local function findInventoryItem(a1, a2) -- Line: 1394 -- upvalues: u12 (val) -- types: a2: string?
            if typeof(a1) == "string" and a1 ~= "" then
                for i, v in ipairs(u12) do
                    if typeof(v) == "table" and v._id == a1 then
                        if a2 ~= nil and v.Name ~= a2 then
                            continue
                        end
                        return v
                    end
                end
                return nil
            end
            return nil
        end

        if a2 == "Melee" then
            local Equipped = v2.Equipped
            return not (typeof(Equipped) ~= "table") and findInventoryItem(Equipped["Equipped Melee"], nil) or nil
        end
        local v3 = u72[a2]
        local v4 = false
        if typeof(v2.Loadout) == "table" then
            v4 = v3 and v2.Loadout[v3]
        end
        if typeof(v4) == "table" and typeof(v4.Options) == "table" then
            local v5
            for i, v in ipairs(v4.Options) do
                v5 = findInventoryItem(v, a3)
                if v5 then
                    return v5
                end
            end
            return nil
        end
        return nil
    end
    return nil
end

local function GetLoadoutPreviewIcon(a1, a2) -- Line: 1429
    -- upvalues: Skins (val), GetWeaponProperties (val)
    local Name = a2 and a2.Name or a1
    local v1 = Skins.GetSkinInformation(Name, a2 and not (typeof(a2.Skin) ~= "string") and a2.Skin or "Stock")
    if v1 then
        if v1.wearImages and v1.wearImages[1] then
            return v1.wearImages[1].assetId
        end
        if v1.imageAssetId then
            return v1.imageAssetId
        end
    end
    local v2 = GetWeaponProperties(Name)
    return v2 and v2.Icon or nil
end

local function SetEditorSlotIcon(a1, a2, a3) -- Line: 1448 -- types: a1: userdata, a2: string, a3: string?
    local v1 = a1:FindFirstChild(a2)
    local WeaponImage = v1 and v1:FindFirstChild("WeaponImage")
    if WeaponImage and WeaponImage:IsA("ImageLabel") then
        WeaponImage.Image = a3 or ""
        WeaponImage.Visible = a3 ~= nil
    end
end

local function ApplyEditorLoadoutPreview() -- Line: 1459
    -- upvalues: u155 (ref), u154 (ref), u73 (val), Skins (val), GetWeaponProperties (val), ReplicatedStorage (val)
    -- upvalues: u69 (val), LocalPlayer (val), DataController (val), FindEquippedLoadoutItem (val)
    -- upvalues: GetLoadoutPreviewIcon (val)
    local WeaponImage, WeaponImage_2, assetId, v1, v2, v3, v4, v5, v6, v7
    local v8 = u155
    if not v8 or not v8.Parent then
        local v9 = u154
        if v9 then
            v8 = v9:FindFirstChild("EditMobile")
            if not v8 and v9.Name == "EditMobile" then
                v8 = v9
            end
            u155 = v8
            v2 = v8
        else
            v2 = nil
        end
    else
        v2 = v8
    end
    if not (if v2 then v2:FindFirstChild("MobileButtons") else nil) then
        return
    end
    for k, v in pairs(u73) do
        v5 = v
        v6 = Skins.GetSkinInformation(v5, "Stock")
        if not v6 then
            v7 = GetWeaponProperties(v5)
            assetId = v7 and v7.Icon or nil
        elseif not v6.wearImages then
            if not v6.imageAssetId then
                v7 = GetWeaponProperties(v5)
                assetId = v7 and v7.Icon or nil
            else
                assetId = v6.imageAssetId
            end
        elseif v6.wearImages[1] then
            assetId = v6.wearImages[1].assetId
        elseif not v6.imageAssetId then
            v7 = GetWeaponProperties(v5)
            assetId = v7 and v7.Icon or nil
        else
            assetId = v6.imageAssetId
        end
        v5 = v1:FindFirstChild(k)
        WeaponImage_2 = v5 and v5:FindFirstChild("WeaponImage")
        if WeaponImage_2 and WeaponImage_2:IsA("ImageLabel") then
            WeaponImage_2.Image = assetId or ""
            WeaponImage_2.Visible = assetId ~= nil
        end
    end
    v8 = require(ReplicatedStorage.Controllers.MenuSceneController).GetMenuCharacterTeam()
    if not v8 or not u69[v8] then
        local Attribute = LocalPlayer:GetAttribute("Team")
        v8 = if typeof(Attribute) ~= "string" then "Counter-Terrorists" else if not u69[Attribute] then "Counter-Terrorists" else Attribute
    end
    for k2, i in pairs(u69[v8]) do
        v7 = if not DataController.IsDataLoaded(LocalPlayer) then nil else FindEquippedLoadoutItem(v8, k2, i)
        v3 = GetLoadoutPreviewIcon(i, v7)
        v4 = v1:FindFirstChild(k2)
        WeaponImage = v4 and v4:FindFirstChild("WeaponImage")
        if WeaponImage and WeaponImage:IsA("ImageLabel") then
            WeaponImage.Image = v3 or ""
            WeaponImage.Visible = v3 ~= nil
        end
    end
end

local function ConvertGuiButtonToFrame(a1) -- Line: 1494 -- types: a1: userdata
    local Frame = Instance.new("Frame")
    Frame.Name = a1.Name
    Frame.AnchorPoint = a1.AnchorPoint
    Frame.Position = a1.Position
    Frame.Size = a1.Size
    Frame.SizeConstraint = a1.SizeConstraint
    Frame.Rotation = a1.Rotation
    Frame.ZIndex = a1.ZIndex
    Frame.LayoutOrder = a1.LayoutOrder
    Frame.Visible = a1.Visible
    Frame.BackgroundColor3 = a1.BackgroundColor3
    Frame.BackgroundTransparency = a1.BackgroundTransparency
    Frame.BorderSizePixel = a1.BorderSizePixel
    Frame.ClipsDescendants = a1.ClipsDescendants
    for i, v in ipairs(a1:GetChildren()) do
        v.Parent = Frame
    end
    return Frame
end

local function ConvertTreeButtonsToFrames(a1) -- Line: 1515
    -- upvalues: ConvertGuiButtonToFrame (val)
    local v1
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("GuiButton") then
            v1 = ConvertGuiButtonToFrame(v)
            v1.Parent = v.Parent
            v:Destroy()
        end
    end
    if not a1:IsA("GuiButton") then
        return a1
    end
    local v2 = ConvertGuiButtonToFrame(a1)
    a1:Destroy()
    return v2
end

local function PopulateEditorButtons() -- Line: 1533
    -- upvalues: u155 (ref), u154 (ref), GetGameplayMobileButtonsFrame (val), Mobile (val)
    -- upvalues: ConvertTreeButtonsToFrames (val), ConnectEditorButtonGesture (val), ApplyEditorLoadoutPreview (val)
    local v1
    local v2 = u155
    if not v2 or not v2.Parent then
        local v3 = u154
        if v3 then
            v2 = v3:FindFirstChild("EditMobile")
            if not v2 and v3.Name == "EditMobile" then
                v2 = v3
            end
            u155 = v2
            v1 = v2
        else
            v1 = nil
        end
    else
        v1 = v2
    end
    local v4 = if v1 then v1:FindFirstChild("MobileButtons") else nil
    v1 = GetGameplayMobileButtonsFrame()
    if v4 and v1 then
        local Defuse, Equipped, Toggled, Use, v5, v6
        for i, v in ipairs(v4:GetChildren()) do
            if v:IsA("GuiObject") and Mobile.IsKnownButton(v.Name) then
                v:Destroy()
            end
        end
        for i2, i3 in ipairs(Mobile.GetButtonNames()) do
            v5 = v1:FindFirstChild(i3)
            if v5 and v5:IsA("GuiObject") then
                v6 = v5:Clone()
                v6.Visible = true
                Toggled = v6:FindFirstChild("Toggled")
                if Toggled and Toggled:IsA("GuiObject") then
                    Toggled.Visible = false
                end
                Equipped = v6:FindFirstChild("Equipped")
                if Equipped and Equipped:IsA("GuiObject") then
                    Equipped.Visible = false
                end
                Use = v6:FindFirstChild("Use")
                if Use and Use:IsA("GuiObject") then
                    Use.Visible = true
                end
                Defuse = v6:FindFirstChild("Defuse")
                if Defuse and Defuse:IsA("GuiObject") then
                    Defuse.Visible = false
                end
                v6 = ConvertTreeButtonsToFrames(v6)
                v6.Parent = v4
                ConnectEditorButtonGesture(v6)
            end
        end
        ApplyEditorLoadoutPreview()
        return
    end
end

local function SetEditorMode(a1) -- Line: 1588
    -- upvalues: u156 (ref), SetDashboardEditorVisibility (val), ClearEditorInteractionState (val), u167 (ref)
    -- upvalues: RefreshConfigurePanel (val), u211 (ref), u171 (ref), u180 (ref), u181 (ref), u179 (ref)
    -- upvalues: UserInputService (val), u169 (ref)
    u156 = a1
    SetDashboardEditorVisibility(a1)
    if a1 then
        RefreshConfigurePanel()
        return
    end
    ClearEditorInteractionState()
    u167 = nil
    RefreshConfigurePanel()
    if u211 then
        u211:Disconnect()
        u211 = nil
    end
    u171 = nil
    u180 = nil
    local v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
    if not u169 then
        return
    end
    u169.Visible = false
end

local function EnterMobileHUDEditor() -- Line: 1601
    -- upvalues: GetUserPlatform (val), UserInputService (val), u156 (ref), u157 (ref), DataController (val)
    -- upvalues: LocalPlayer (val), Router (val), ClearEditorInteractionState (val), u155 (ref), u154 (ref)
    -- upvalues: Mobile (val), PopulateEditorButtons (val), u159 (ref), u161 (ref), DeepCopyLayout (val)
    -- upvalues: ApplyEditorButtonLayout (val), ApplyEditorLoadoutPreview (val), u153 (ref), HideDashboardPanels (val)
    -- upvalues: RefreshConfigurePanel (val)
    local v1 = GetUserPlatform()
    local v2 = false
    if table.find(v1, "Mobile") ~= nil then
        v2 = #v1 <= 1
    end
    if not v2 then
        v2 = (UserInputService:GetLastInputType()) == Enum.UserInputType.Touch
    end
    if not v2 then
        return
    end
    if not u156 and not u157 then
        local v3, v4
        u157 = true
        v2 = pcall(function() -- Line: 1611 -- upvalues: DataController (upval), LocalPlayer (upval)
            DataController.WaitForDataLoaded(LocalPlayer)
        end)
        u157 = false
        if not v2 then
            Router.broadcastRouter("CreateMenuNotification", "Error", "Profile data is still loading. Please try again.")
            return
        end
        ClearEditorInteractionState()
        local v5 = u155
        if not v5 or not v5.Parent then
            v4 = u154
            if v4 then
                v5 = v4:FindFirstChild("EditMobile")
                if not v5 and v4.Name == "EditMobile" then
                    v5 = v4
                end
                u155 = v5
                v3 = v5
            else
                v3 = nil
            end
        else
            v3 = v5
        end
        v1 = if v3 then v3:FindFirstChild("MobileButtons") else nil
        v3 = false
        if v1 then
            for i, v in ipairs(Mobile.GetButtonNames()) do
                if v1:FindFirstChild(v) then
                    v3 = true
                    break
                end
            end
        end
        if not v1 or not v3 then
            PopulateEditorButtons()
        end
        u159 = Mobile.SanitizeLayout((DataController.Get(LocalPlayer, "MobileButtons")))
        u161 = DeepCopyLayout(u159)
        for i2, i3 in ipairs(Mobile.GetButtonNames()) do
            ApplyEditorButtonLayout(i3)
        end
        ApplyEditorLoadoutPreview()
        u156 = true
        v4 = u155
        if not v4 or not v4.Parent then
            local v6 = u154
            if v6 then
                v4 = v6:FindFirstChild("EditMobile")
                if not v4 and v6.Name == "EditMobile" then
                    v4 = v6
                end
                u155 = v4
                v5 = v4
            else
                v5 = nil
            end
        else
            v5 = v4
        end
        if v5 then
            v5.Visible = true
            if v5 then
                local Action = v5:FindFirstChild("Action")
                if Action and Action:IsA("Frame") then
                    Action.Visible = true
                end
            end
            if v5 then
                local MobileButtons = v5:FindFirstChild("MobileButtons")
                if MobileButtons and MobileButtons:IsA("Frame") then
                    MobileButtons.Visible = true
                end
            end
        end
        local Menu = u153 and u153:FindFirstChild("Menu")
        local Top = Menu and Menu:IsA("Frame") and Menu:FindFirstChild("Top")
        v4 = if not Top then nil else if not Top:IsA("Frame") then nil else Top
        if v4 then
            v4.Visible = false
        end
        HideDashboardPanels()
        RefreshConfigurePanel()
        return
    end
end

local function ExitMobileHUDEditor(a1) -- Line: 1645
    -- upvalues: u156 (ref), u161 (ref), DeepCopyLayout (val), u159 (ref), Mobile (val), ApplyEditorButtonLayout (val)
    -- upvalues: SetDashboardEditorVisibility (val), ClearEditorInteractionState (val), u167 (ref)
    -- upvalues: RefreshConfigurePanel (val), u211 (ref), u171 (ref), u180 (ref), u181 (ref), u179 (ref)
    -- upvalues: UserInputService (val), u169 (ref)
    if not u156 then
        return
    end
    if not a1 then
        u161 = DeepCopyLayout(u159)
        for i, v in ipairs(Mobile.GetButtonNames()) do
            ApplyEditorButtonLayout(v)
        end
    end
    u156 = false
    SetDashboardEditorVisibility(false)
    ClearEditorInteractionState()
    u167 = nil
    RefreshConfigurePanel()
    if u211 then
        u211:Disconnect()
        u211 = nil
    end
    u171 = nil
    u180 = nil
    local v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
    if u169 then
        u169.Visible = false
    end
end

local function UpdateEditMobileButtonVisibility(a1) -- Line: 1660
    -- upvalues: GetEditMobileEntryButton (val), GetUserPlatform (val), UserInputService (val), u156 (ref)
    -- upvalues: MenuState (val), SetDashboardEditorVisibility (val)
    local v1 = GetEditMobileEntryButton()
    local Parent = v1 and v1.Parent
    local v2 = GetUserPlatform()
    local v3 = false
    if table.find(v2, "Mobile") ~= nil then
        v3 = #v2 <= 1
    end
    if not v3 then
        v3 = (a1 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch
    end
    if v1 then
        v1.Visible = v3
    end
    if Parent and Parent:IsA("GuiObject") then
        Parent.Visible = v3
    end
    if not v3 and not u156 and not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
        SetDashboardEditorVisibility(false)
    end
end

local function ResetEditorToDefaults() -- Line: 1682
    -- upvalues: u161 (ref), Mobile (val), ApplyEditorButtonLayout (val), RefreshConfigurePanel (val)
    u161 = Mobile.GetDefaultLayout()
    for i, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v)
    end
    RefreshConfigurePanel()
end

local function ApplyLayoutToGameplayButtons(a1) -- Line: 1690
    -- upvalues: GetGameplayMobileButtonsFrame (val), Mobile (val), ApplyMobileButtonLayout (val)
    local v1, v2
    local v3 = GetGameplayMobileButtonsFrame()
    if not v3 then
        return
    end
    for i, v in ipairs(Mobile.GetButtonNames()) do
        v1 = v3:FindFirstChild(v)
        v2 = a1[v]
        if v1 and v1:IsA("GuiObject") and v2 then
            ApplyMobileButtonLayout(v1, v2)
        end
    end
end

local function CommitEditorChanges() -- Line: 1709
    -- upvalues: Mobile (val), u161 (ref), DeepCopyLayout (val), u159 (ref), ApplyLayoutToGameplayButtons (val)
    -- upvalues: Remotes (val)
    local v1 = Mobile.SanitizeLayout(u161)
    u161 = DeepCopyLayout(v1)
    u159 = DeepCopyLayout(v1)
    ApplyLayoutToGameplayButtons(v1)
    Remotes.Player.UpdateMobileButtons.Send({Layout = v1})
end

local function HasEditorLayoutChanges() -- Line: 1723 -- upvalues: Mobile (val), u161 (ref), u159 (ref)
    return not Mobile.AreLayoutsEqual(Mobile.SanitizeLayout(u161), (Mobile.SanitizeLayout(u159)))
end

local function ConnectActionButton(a1, a2, a3) -- Line: 1731
    -- upvalues: ActivateButton (val)
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("GuiButton") then
        ActivateButton(v1)
        v1.MouseButton1Click:Connect(a3)
        return
    end
end

local function HandleConfirmPressed() -- Line: 1743
    -- upvalues: u156 (ref), Router (val), Mobile (val), u161 (ref), u159 (ref), CommitEditorChanges (val)
    -- upvalues: SetDashboardEditorVisibility (val), ClearEditorInteractionState (val), u167 (ref)
    -- upvalues: RefreshConfigurePanel (val), u211 (ref), u171 (ref), u180 (ref), u181 (ref), u179 (ref)
    -- upvalues: UserInputService (val), u169 (ref)
    if not u156 then
        return
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
    if not Mobile.AreLayoutsEqual(Mobile.SanitizeLayout(u161), (Mobile.SanitizeLayout(u159))) then
        CommitEditorChanges()
    end
    if not u156 then
        return
    end
    u156 = false
    SetDashboardEditorVisibility(false)
    ClearEditorInteractionState()
    u167 = nil
    RefreshConfigurePanel()
    if u211 then
        u211:Disconnect()
        u211 = nil
    end
    u171 = nil
    u180 = nil
    local v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
    if u169 then
        u169.Visible = false
    end
end

local function HandleResetPressed() -- Line: 1757
    -- upvalues: u156 (ref), Router (val), u161 (ref), Mobile (val), ApplyEditorButtonLayout (val)
    -- upvalues: RefreshConfigurePanel (val)
    if not u156 then
        return
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
    u161 = Mobile.GetDefaultLayout()
    for i, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v)
    end
    RefreshConfigurePanel()
end

local function HandleBackPressed() -- Line: 1767
    -- upvalues: u156 (ref), Router (val), u161 (ref), DeepCopyLayout (val), u159 (ref), Mobile (val)
    -- upvalues: ApplyEditorButtonLayout (val), SetDashboardEditorVisibility (val), ClearEditorInteractionState (val)
    -- upvalues: u167 (ref), RefreshConfigurePanel (val), u211 (ref), u171 (ref), u180 (ref), u181 (ref), u179 (ref)
    -- upvalues: UserInputService (val), u169 (ref)
    if not u156 then
        return
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Click")
    if not u156 then
        return
    end
    u161 = DeepCopyLayout(u159)
    for i, v in ipairs(Mobile.GetButtonNames()) do
        ApplyEditorButtonLayout(v)
    end
    u156 = false
    SetDashboardEditorVisibility(false)
    ClearEditorInteractionState()
    u167 = nil
    RefreshConfigurePanel()
    if u211 then
        u211:Disconnect()
        u211 = nil
    end
    u171 = nil
    u180 = nil
    local v1 = u180 or u181 or u179 or ""
    if UserInputService.MouseIcon ~= v1 then
        UserInputService.MouseIcon = v1
    end
    if u169 then
        u169.Visible = false
    end
end

local function SetupEditMobileEntryButton() -- Line: 1777
    -- upvalues: GetEditMobileEntryButton (val), ActivateButton (val), Router (val), EnterMobileHUDEditor (val)
    local v1 = GetEditMobileEntryButton()
    if not v1 then
        return
    end
    ActivateButton(v1)
    v1.MouseButton1Click:Connect(function() -- Line: 1784 -- upvalues: Router (upval), EnterMobileHUDEditor (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        EnterMobileHUDEditor()
    end)
end

local function SetupEditorControls() -- Line: 1792
    -- upvalues: u155 (ref), u154 (ref), HandleConfirmPressed (val), ActivateButton (val), HandleResetPressed (val)
    -- upvalues: HandleBackPressed (val), SetupConfigurePanel (val), PopulateEditorButtons (val)
    local v1
    local v2 = u155
    if not v2 or not v2.Parent then
        local v3 = u154
        if v3 then
            v2 = v3:FindFirstChild("EditMobile")
            if not v2 and v3.Name == "EditMobile" then
                v2 = v3
            end
            u155 = v2
            v1 = v2
        else
            v1 = nil
        end
    else
        v1 = v2
    end
    if not v1 then
        return
    end
    local Action = v1:FindFirstChild("Action")
    if Action and Action:IsA("Frame") then
        local Confirm = Action:FindFirstChild("Confirm")
        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm)
            Confirm.MouseButton1Click:Connect(HandleConfirmPressed)
        end
        local Reset = Action:FindFirstChild("Reset")
        if Reset and Reset:IsA("GuiButton") then
            ActivateButton(Reset)
            Reset.MouseButton1Click:Connect(HandleResetPressed)
        end
        local Back = Action:FindFirstChild("Back")
        if Back and Back:IsA("GuiButton") then
            ActivateButton(Back)
            Back.MouseButton1Click:Connect(HandleBackPressed)
        end
    end
    SetupConfigurePanel(v1)
    PopulateEditorButtons()
end

local function ConnectGlobalInputHandlers() -- Line: 1812
    -- upvalues: UserInputService (val), UpdateEditMobileButtonVisibility (val), ReplicatedStorage (val)
    -- upvalues: ApplyEditorLoadoutPreview (val), DataController (val), LocalPlayer (val), Skins (val), u156 (ref)
    -- upvalues: u172 (ref), u173 (ref), StartEditorPinch (val), TryDeselectFromEmptyTouch (val), u171 (ref)
    -- upvalues: UpdateResizeFromInput (val), UpdatePinchFromInput (val), UpdateDragFromInput (val), u180 (ref)
    -- upvalues: u181 (ref), u179 (ref), u164 (ref), u165 (ref), u166 (ref), GuiService (val), SelectEditorButton (val)
    -- upvalues: StartEditorDrag (val), RefreshEditorInteraction (val)
    UserInputService.LastInputTypeChanged:Connect(function(a1) -- Line: 1813 -- upvalues: UpdateEditMobileButtonVisibility (upval)
        UpdateEditMobileButtonVisibility(a1)
    end)
    ;(require(ReplicatedStorage.Controllers.MenuSceneController)).MenuCharacterChanged:Connect(function() -- Line: 1819 -- upvalues: ApplyEditorLoadoutPreview (upval)
        ApplyEditorLoadoutPreview()
    end)
    DataController.CreateListener(LocalPlayer, "Loadout", function() -- Line: 1822 -- upvalues: ApplyEditorLoadoutPreview (upval)
        ApplyEditorLoadoutPreview()
    end)
    Skins.OnItemStockSchemasUpdated:Connect(function() -- Line: 1826 -- upvalues: ApplyEditorLoadoutPreview (upval)
        ApplyEditorLoadoutPreview()
    end)
    UserInputService.InputBegan:Connect(function(a1) -- Line: 1830
        -- upvalues: u156 (upval), u172 (upval), u173 (upval), StartEditorPinch (upval)
        -- upvalues: TryDeselectFromEmptyTouch (upval)
        local v1
        if not u156 then
            return
        end
        if a1.UserInputType == Enum.UserInputType.Touch then
            v1 = a1.UserInputState == Enum.UserInputState.Begin
        else
            v1 = false
            if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                v1 = a1.UserInputState == Enum.UserInputState.Begin
            end
        end
        if not v1 then
            return
        end
        if a1.UserInputType == Enum.UserInputType.Touch then
            v1 = u172
            if v1 and not u173 and v1.input ~= a1 then
                StartEditorPinch(v1.buttonName, v1.input, a1)
            end
        end
        task.defer(TryDeselectFromEmptyTouch, a1)
    end)
    UserInputService.InputChanged:Connect(function(a1) -- Line: 1845
        -- upvalues: u156 (upval), u171 (upval), UpdateResizeFromInput (upval), u173 (upval)
        -- upvalues: UpdatePinchFromInput (upval), u172 (upval), UpdateDragFromInput (upval)
        if u156 then
            local v1 = true
            if a1.UserInputType ~= Enum.UserInputType.Touch then
                v1 = a1.UserInputType == Enum.UserInputType.MouseMovement
            end
            if v1 then
                if u171 then
                    UpdateResizeFromInput(a1)
                    return
                end
                if u173 then
                    UpdatePinchFromInput(a1)
                    return
                end
                if u172 then
                    UpdateDragFromInput(a1)
                end
                return
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(a1) -- Line: 1861
        -- upvalues: u171 (upval), u180 (upval), u181 (upval), u179 (upval), UserInputService (upval), u173 (upval)
        -- upvalues: u164 (upval), u165 (upval), u166 (upval), GuiService (upval), SelectEditorButton (upval)
        -- upvalues: u172 (upval), StartEditorDrag (upval), RefreshEditorInteraction (upval)
        local v1, v2, v3, v4
        local v5 = true
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            v5 = a1.UserInputType == Enum.UserInputType.MouseButton1
        end
        if not v5 then
            return
        end
        v5 = u171
        if v5 then
            local v6
            local input = v5.input
            if a1 ~= input then
                local UserInputType = a1.UserInputType
                local UserInputType_2 = input.UserInputType
                v1 = true
                if UserInputType ~= Enum.UserInputType.MouseMovement then
                    v1 = UserInputType == Enum.UserInputType.MouseButton1
                end
                v2 = true
                if UserInputType_2 ~= Enum.UserInputType.MouseMovement then
                    v2 = UserInputType_2 == Enum.UserInputType.MouseButton1
                end
                v6 = v1 and v2
            else
                v6 = true
            end
            if v6 then
                u171 = nil
                u180 = nil
                v6 = u180 or u181 or u179 or ""
                if UserInputService.MouseIcon ~= v6 then
                    UserInputService.MouseIcon = v6
                end
                return
            end
        end
        local buttonName = nil
        local v7 = false
        local anchorInput = nil
        local v8 = u173
        if v8 then
            if a1 == v8.anchorInput or a1 == v8.scaleInput then
                buttonName = v8.buttonName
                if a1 == v8.scaleInput then
                    v7 = true
                    anchorInput = v8.anchorInput
                end
                u173 = nil
            end
        end
        v2 = u164[a1]
        if v2 then
            u164[a1] = nil
            v3 = u165[v2]
            if v3 then
                v3[a1] = nil
                if next(v3) == nil then
                    u165[v2] = nil
                end
            end
            v1 = v2
        else
            v1 = nil
        end
        v2 = u166[a1]
        u166[a1] = nil
        if v1 and not buttonName and v2 then
            local GuiInset = GuiService:GetGuiInset()
            if (Vector2.new(a1.Position.X - GuiInset.X, a1.Position.Y - GuiInset.Y) - v2).Magnitude <= 12 then
                SelectEditorButton(v1)
            end
        end
        v3 = u172
        if v3 then
            local input_2 = v3.input
            if a1 ~= input_2 then
                local UserInputType_3 = a1.UserInputType
                local UserInputType_4 = input_2.UserInputType
                local v9 = true
                if UserInputType_3 ~= Enum.UserInputType.MouseMovement then
                    v9 = UserInputType_3 == Enum.UserInputType.MouseButton1
                end
                local v10 = true
                if UserInputType_4 ~= Enum.UserInputType.MouseMovement then
                    v10 = UserInputType_4 == Enum.UserInputType.MouseButton1
                end
                v4 = v9 and v10
            else
                v4 = true
            end
            if v4 then
                u172 = nil
                u181 = nil
                v4 = u180 or u181 or u179 or ""
                if UserInputService.MouseIcon ~= v4 then
                    UserInputService.MouseIcon = v4
                end
            end
        end
        v4 = v1 or buttonName
        if v7 and anchorInput and v4 and u164[anchorInput] == v4 then
            StartEditorDrag(v4, anchorInput)
        end
        if v4 then
            RefreshEditorInteraction(v4)
        end
    end)
end

function v1.Initialize(a1, a2) -- Line: 1922
    -- upvalues: u153 (ref), u154 (ref), u155 (ref), ConnectEditorVisibilityGuards (val)
    -- upvalues: SetDashboardEditorVisibility (val), UpdateEditMobileButtonVisibility (val), UserInputService (val)
    -- upvalues: GetEditMobileEntryButton (val), ActivateButton (val), Router (val), EnterMobileHUDEditor (val)
    -- upvalues: SetupEditorControls (val), ConnectGlobalInputHandlers (val)
    u153 = a1
    local v1 = a2
    local EditMobile = a2:FindFirstChild("EditMobile")
    if a2.Name == "EditMobile" then
        EditMobile = a2
        local Parent = a2.Parent
        if Parent and Parent:IsA("Frame") then
            v1 = Parent
        end
    end
    u154 = v1
    u155 = EditMobile
    ConnectEditorVisibilityGuards()
    SetDashboardEditorVisibility(false)
    UpdateEditMobileButtonVisibility(UserInputService:GetLastInputType())
    local v2 = GetEditMobileEntryButton()
    if v2 then
        ActivateButton(v2)
        v2.MouseButton1Click:Connect(function() -- Line: 1784 -- upvalues: Router (upval), EnterMobileHUDEditor (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            EnterMobileHUDEditor()
        end)
    end
    SetupEditorControls()
    ConnectGlobalInputHandlers()
end

function v1.ShouldShowEntryButton(a1) -- Line: 1950 -- upvalues: GetUserPlatform (val), UserInputService (val)
    local v1 = GetUserPlatform()
    local v2 = false
    if table.find(v1, "Mobile") ~= nil then
        v2 = #v1 <= 1
    end
    if not v2 then
        v2 = (a1 or UserInputService:GetLastInputType()) == Enum.UserInputType.Touch
    end
    return v2
end

function v1.Open() -- Line: 1956 -- upvalues: EnterMobileHUDEditor (val)
    EnterMobileHUDEditor()
end

return v1