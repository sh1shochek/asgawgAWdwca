-- ReplicatedStorage.Interface.Screens.Menu.Settings
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Settings
-- Decompile time: 123.08 ms

local DeepCopy, DeepEqual
local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
require(script:WaitForChild("Types"))
local BindDisplay = require(script:WaitForChild("BindDisplay"))
local LocalPlayer = Players.LocalPlayer
local Settings = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Settings")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local EditMobile = require(ReplicatedStorage.Interface.Screens.Menu.Dashboard.EditMobile)
local CrosshairPreview = require(script.Templates.CrosshairPreview)
local Dropdown = require(script.Templates.Dropdown)
local Keybind = require(script.Templates.Keybind)
local Number = require(script.Templates.Number)
local Toggle = require(script.Templates.Toggle)
local Slider = require(script.Templates.Slider)
local u148 = Color3.fromRGB(34, 38, 47)
local u153 = Color3.fromRGB(125, 206, 243)
local u154 = {"Global Shadows", "Glass Shatter", "First Person Tracers", "Muzzle Flash", "Ragdolls"}
local u164 = Color3.fromRGB(255, 255, 255)
local u165 = {"Info"}
local u185 = {
    Keybinds = {"Keyboard & Mouse Settings", "Movement Keys", "Weapon Keys", "UI Keys", "Communication Options"},
    Game = {"Item", "HUD", "Crosshair", "Viewmodel", "Radar/Tablet", "Other"},
    Audio = {"Audio", "Music", "Voice Chat", "Other"},
}
local u186 = {"Video", "Audio", "Game", "Keybinds"}
local u191 = {Video = "Video", Audio = "Audio", Game = "Game", Keybinds = "Keyboard/Mouse"}
local u196 = nil
local u197 = {}
local u198 = nil
local u199 = 0
local u200 = nil
local u201 = {}
local u202 = {}
local u203 = {}
local u204 = {}
local u205 = nil
local u206 = {}
local u207 = nil
local u208 = nil
local u209 = nil
local u210 = nil
local u211 = nil
local u212 = 0
local u213 = nil
local u214 = "Video"
local u215 = {}

local function NOOP() end

function DeepCopy(a1) -- Line: 219 -- upvalues: DeepCopy (val)
    if type(a1) ~= "table" then
        return a1
    end
    local v1 = {}
    for k, v in pairs(a1) do
        v1[k] = (DeepCopy(v))
    end
    return v1
end

local function ResolveSettingPath(a1, a2) -- Line: 232 -- types: a2: string
    local v1
    local v2 = string.split(a2, ".")
    local v3 = a1
    local v4 = #v2 - 1
    for i = 2, v4 do
        v1 = v2[i]
        if type(v3[v1]) ~= "table" then
            v3[v1] = {}
        end
        v3 = v3[v1]
    end
    return v3, v2[#v2]
end

function DeepEqual(a1, a2) -- Line: 247 -- upvalues: DeepEqual (val)
    local v1
    if a1 == a2 then
        return true
    end
    if (type(a1)) ~= type(a2) or type(a1) ~= "table" then
        return false
    end
    local v2 = {}
    for k, v in pairs(a1) do
        v1 = a2[k]
        if not DeepEqual(v, v1) then
            return false
        end
        v2[k] = true
    end
    for k2 in pairs(a2) do
        if not v2[k2] then
            return false
        end
    end
    return true
end

local function GetDatabasePageName(a1) -- Line: 282 -- upvalues: u191 (val) -- types: a1: string
    return u191[a1] or a1
end

local function BuildSettingPath(a1, a2, a3) -- Line: 287
    -- upvalues: u191 (val)
    return (("Settings.%*.%*.%*"):format(u191[a1] or a1, a2, a3))
end

local function RegisterSettingMetadata(a1, a2, a3) -- Line: 293
    -- upvalues: u191 (val), u202 (val)
    u202[a3] = {
        pageName = a1,
        categoryName = a2,
        settingName = a3,
        settingPath = ("Settings.%*.%*.%*"):format(u191[a1] or a1, a2, a3),
    }
end

local function CaptureSelectedControl(a1) -- Line: 307 -- upvalues: GuiService (val) -- types: a1: userdata
    local SelectedObject = GuiService.SelectedObject
    if SelectedObject and SelectedObject:IsDescendantOf(a1) then
        local v1 = {}
        local Parent = SelectedObject
        while Parent do
            if Parent.Parent == a1 then
                break
            end
            table.insert(v1, 1, Parent.Name)
            Parent = Parent.Parent
        end
        if not Parent then
            return nil
        end
        return {row = Parent.Name, path = v1}
    end
    return nil
end

local function RestoreSelectedControl(a1, a2) -- Line: 327
    -- upvalues: GuiService (val)
    if not a2 then
        return
    end
    local v1 = a1:FindFirstChild(a2.row)
    if not v1 then
        return
    end
    local v2 = v1
    for i, v in ipairs(a2.path) do
        v2 = v2 and v2:FindFirstChild(v)
    end
    if v2 and v2:IsA("GuiObject") and v2.Selectable and v2.Visible then
        GuiService.SelectedObject = v2
        return
    end
    for i2, i3 in ipairs(v1:GetDescendants()) do
        if i3:IsA("GuiObject") and i3.Selectable and i3.Visible then
            GuiService.SelectedObject = i3
            return
        end
    end
end

local function ClearContainer(a1) -- Line: 356
    -- upvalues: u214 (ref), u203 (val), u204 (val), u196 (ref)
    local v1 = u214
    if u203[v1] then
        u203[v1]:Cleanup()
        u203[v1] = nil
    end
    if v1 == "Keybinds" then
        table.clear(u204)
        u196 = nil
    end
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("GuiObject") and v.Name ~= "Header" and v.Name ~= "Title" then
            v:Destroy()
        end
    end
end

local function GetSettingValue(a1, a2) -- Line: 380 -- upvalues: u205 (ref), u191 (val) -- types: a1: string, a2: string
    local searchInTable
    if not u205 then
        return nil
    end
    local v1 = u191[a1]
    v1 = u205[v1 or a1]
    if not v1 then
        return nil
    end

    function searchInTable(a1) -- Line: 394 -- upvalues: a2 (val), searchInTable (val)
        local v1
        for k, v in pairs(a1) do
            if k == a2 then
                return v
            end
            if type(v) == "table" then
                v1 = searchInTable(v)
                if v1 ~= nil then
                    return v1
                end
            end
        end
        return nil
    end

    return (searchInTable(v1))
end

local function CreateCategoryHeader(a1, a2, a3) -- Line: 411
    -- upvalues: u153 (val)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = ("Category_%*"):format(a1)
    TextLabel.Text = string.upper(a1)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 14
    TextLabel.TextColor3 = u153
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 0, 35)
    TextLabel.LayoutOrder = a3
    TextLabel.Parent = a2
    return TextLabel
end

local function CreateDivider(a1, a2) -- Line: 427 -- upvalues: Settings (val) -- types: a1: userdata, a2: number
    local v1 = Settings:WaitForChild("Divider"):Clone()
    v1.LayoutOrder = a2
    v1.Parent = a1
    return v1
end

local function UpdateCanvasSize(a1) -- Line: 434 -- types: a1: userdata
    local UIListLayout = a1:FindFirstChildOfClass("UIListLayout")
    if UIListLayout then
        a1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 50)
    end
end

local function CheckKeybindConflict(a1, a2, a3) -- Line: 442
    -- upvalues: u204 (val)
    if a1 ~= "" and a1 ~= "None" then
        local v1 = u204[(("%*:%*"):format(a3, a1))]
        if v1 and v1 ~= a2 then
            return v1
        end
        return nil
    end
    return nil
end

local function RegisterKeybind(a1, a2, a3) -- Line: 457
    -- upvalues: u204 (val)
    if a1 ~= "" and a1 ~= "None" then
        u204[(("%*:%*"):format(a3, a1))] = a2
        return
    end
end

local function UnregisterKeybind(a1, a2) -- Line: 466 -- upvalues: u204 (val) -- types: a1: string, a2: string
    if a1 ~= "" and a1 ~= "None" then
        u204[(("%*:%*"):format(a2, a1))] = nil
        return
    end
end

local function GetKeybindPlatformFrame(a1, a2) -- Line: 475 -- types: a1: userdata, a2: string
    local Right = a1:FindFirstChild("Right")
    if Right and Right:IsA("Frame") then
        local v1 = Right:FindFirstChild(a2)
        if v1 and v1:IsA("GuiObject") then
            return v1
        end
        return nil
    end
    return nil
end

local function GetKeybindTextBox(a1) -- Line: 491 -- upvalues: BindDisplay (val) -- types: a1: userdata
    return BindDisplay.GetTextBox(a1)
end

local function GetKeybindPlatformFromTextBox(a1) -- Line: 496 -- types: a1: userdata
    local Parent_2
    local Parent = a1.Parent
    while Parent do
        Parent_2 = Parent.Parent
        if Parent_2 and Parent_2.Name == "Right" and Parent:IsA("GuiObject") then
            return Parent
        end
        Parent = Parent_2
    end
    return nil
end

local function GetKeybindSettingTemplate(a1) -- Line: 508 -- upvalues: u201 (val) -- types: a1: userdata
    local Parent = a1.Parent
    if Parent and Parent.Name == "Right" then
        local Parent_2 = Parent.Parent
        if Parent_2 and Parent_2:IsA("GuiObject") then
            local Keybinds = u201.Keybinds
            if Keybinds and Keybinds[Parent_2.Name] == Parent_2 then
                return Parent_2
            end
            return nil
        end
        return nil
    end
    return nil
end

local function GetRenderedKeybindBox(a1, a2) -- Line: 529
    -- upvalues: u201 (val), GetKeybindTextBox (val)
    if u201.Keybinds and u201.Keybinds[a1] then
        local v1
        local Right = u201.Keybinds[a1]:FindFirstChild("Right")
        if not Right then
            v1 = nil
        elseif Right:IsA("Frame") then
            local v2 = Right:FindFirstChild(a2)
            v1 = if not v2 then nil else if not v2:IsA("GuiObject") then nil else v2
        else
            v1 = nil
        end
        if not v1 then
            return nil, nil
        end
        return v1, GetKeybindTextBox(v1)
    end
    return nil, nil
end

local function RememberKeybindTextColor(a1) -- Line: 550 -- types: a1: userdata
    if a1:GetAttribute("DefaultTextColor") == nil then
        a1:SetAttribute("DefaultTextColor", a1.TextColor3)
    end
end

local function GetKeybindTextColor(a1) -- Line: 556 -- types: a1: userdata
    local Attribute = a1:GetAttribute("DefaultTextColor")
    if typeof(Attribute) == "Color3" then
        return Attribute
    end
    return a1.TextColor3
end

local function HighlightReplacedKeybind(a1, a2) -- Line: 562
    -- upvalues: u201 (val), BindDisplay (val)
    local v1, v2
    if not u201.Keybinds then
        v1 = nil
        v2 = nil
    elseif u201.Keybinds[a1] then
        local v3
        local Right = u201.Keybinds[a1]:FindFirstChild("Right")
        if not Right then
            v3 = nil
        elseif Right:IsA("Frame") then
            local v4 = Right:FindFirstChild(a2)
            v3 = if not v4 then nil else if not v4:IsA("GuiObject") then nil else v4
        else
            v3 = nil
        end
        if v3 then
            v1 = v3
            v2 = BindDisplay.GetTextBox(v3)
        else
            v1 = nil
            v2 = nil
        end
    else
        v1 = nil
        v2 = nil
    end
    if not v2 then
        return
    end
    if v2:GetAttribute("DefaultTextColor") == nil then
        v2:SetAttribute("DefaultTextColor", v2.TextColor3)
    end
    v2.TextColor3 = Color3.fromRGB(255, 90, 90)
    BindDisplay.SetConflict(v1, true)
end

local function ClearKeybindHighlight(a1, a2) -- Line: 574
    -- upvalues: u201 (val), BindDisplay (val), TweenService (val)
    local v1, v2, v3
    if not u201.Keybinds then
        v1 = nil
        v2 = nil
    elseif u201.Keybinds[a1] then
        local v4
        local Right = u201.Keybinds[a1]:FindFirstChild("Right")
        if not Right then
            v4 = nil
        elseif Right:IsA("Frame") then
            v3 = Right:FindFirstChild(a2)
            v4 = if not v3 then nil else if not v3:IsA("GuiObject") then nil else v3
        else
            v4 = nil
        end
        if v4 then
            v1 = v4
            v2 = BindDisplay.GetTextBox(v4)
        else
            v1 = nil
            v2 = nil
        end
    else
        v1 = nil
        v2 = nil
    end
    if not v2 then
        return
    end
    if v2:GetAttribute("DefaultTextColor") == nil then
        v2:SetAttribute("DefaultTextColor", v2.TextColor3)
    end
    v3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v5 = {}
    local Attribute = v2:GetAttribute("DefaultTextColor")
    v5.TextColor3 = if typeof(Attribute) ~= "Color3" then v2.TextColor3 else Attribute
    TweenService:Create(v2, v3, v5):Play()
    BindDisplay.SetConflict(v1, false)
end

local function ScrollToTemplate(a1) -- Line: 590 -- upvalues: u201 (val), TweenService (val) -- types: a1: string
    if u201.Keybinds and u201.Keybinds[a1] then
        local v1 = u201.Keybinds[a1]
        local Parent = v1.Parent
        if Parent and Parent:IsA("ScrollingFrame") then
            local Y = v1.AbsolutePosition.Y
            local Y_2 = Parent.AbsolutePosition.Y
            local Y_3 = Parent.AbsoluteSize.Y
            local v2 = Y - Y_2 + Parent.CanvasPosition.Y
            local Y_4 = v1.AbsoluteSize.Y
            local v3 = math.min(math.max(0, v2 - Y_3 / 2 + Y_4 / 2), Parent.CanvasSize.Y.Offset - Y_3)
            TweenService:Create(
                Parent,
                TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {CanvasPosition = Vector2.new(0, v3)}
            ):Play()
            return
        end
        return
    end
end

local function SwapKeybinds(a1, a2, a3, a4, a5) -- Line: 620
    -- upvalues: u205 (ref), u191 (val), u0 (val), u204 (val), u201 (val), BindDisplay (val), ScrollToTemplate (val)
    local v1, v2, v3, v4, v5
    if a5 == a3 then
        a5 = nil
    end
    if u205 then
        local Keybinds = u191.Keybinds
        v3 = u205[Keybinds or "Keybinds"]
        if v3 then
            local searchInTable

            function searchInTable(a1) -- Line: 394 -- upvalues: a2 (val), searchInTable (val)
                local v1
                for k, v in pairs(a1) do
                    if k == a2 then
                        return v
                    end
                    if type(v) == "table" then
                        v1 = searchInTable(v)
                        if v1 ~= nil then
                            return v1
                        end
                    end
                end
                return nil
            end

            v2 = searchInTable(v3)
        else
            v2 = nil
        end
    else
        v2 = nil
    end
    local v6 = if type(v2) ~= "table" then {} else table.clone(v2)
    v6[a4] = a5 or ""
    u0.SettingChanged("Keybinds", a2, v6)
    if a5 and a5 ~= "" and a5 ~= "" and a5 ~= "None" then
        u204[(("%*:%*"):format(a4, a5))] = a2
    end
    if u201.Keybinds and u201.Keybinds[a2] then
        local Right = u201.Keybinds[a2]:FindFirstChild("Right")
        if not Right then
            v4 = nil
        elseif Right:IsA("Frame") then
            local v7 = Right:FindFirstChild(a4)
            v4 = if not v7 then nil else if not v7:IsA("GuiObject") then nil else v7
        else
            v4 = nil
        end
        if v4 then
            BindDisplay.Apply(v4, a5 or "")
        end
    end
    if not u201.Keybinds then
        v3 = nil
        v4 = nil
    elseif u201.Keybinds[a1] then
        local Right_2 = u201.Keybinds[a1]:FindFirstChild("Right")
        if not Right_2 then
            v5 = nil
        elseif Right_2:IsA("Frame") then
            v1 = Right_2:FindFirstChild(a4)
            v5 = if not v1 then nil else if not v1:IsA("GuiObject") then nil else v1
        else
            v5 = nil
        end
        if v5 then
            v3 = v5
            v4 = BindDisplay.GetTextBox(v5)
        else
            v3 = nil
            v4 = nil
        end
    else
        v3 = nil
        v4 = nil
    end
    if v4 then
        if v4:GetAttribute("DefaultTextColor") == nil then
            v4:SetAttribute("DefaultTextColor", v4.TextColor3)
        end
        v4.TextColor3 = Color3.fromRGB(255, 90, 90)
        BindDisplay.SetConflict(v3, true)
    end
    if not u201.Keybinds then
        v3 = nil
        v4 = nil
    elseif u201.Keybinds[a2] then
        local Right_3 = u201.Keybinds[a2]:FindFirstChild("Right")
        if not Right_3 then
            v5 = nil
        elseif Right_3:IsA("Frame") then
            v1 = Right_3:FindFirstChild(a4)
            v5 = if not v1 then nil else if not v1:IsA("GuiObject") then nil else v1
        else
            v5 = nil
        end
        if v5 then
            v3 = v5
            v4 = BindDisplay.GetTextBox(v5)
        else
            v3 = nil
            v4 = nil
        end
    else
        v3 = nil
        v4 = nil
    end
    if v4 then
        if v4:GetAttribute("DefaultTextColor") == nil then
            v4:SetAttribute("DefaultTextColor", v4.TextColor3)
        end
        v4.TextColor3 = Color3.fromRGB(255, 90, 90)
        BindDisplay.SetConflict(v3, true)
    end
    ScrollToTemplate(a2)
end

local function IsAnyGamepadButtonDown(a1) -- Line: 672 -- upvalues: UserInputService (val)
    for i, j in UserInputService:GetConnectedGamepads() do
        if UserInputService:IsGamepadButtonDown(j, a1) then
            return true
        end
    end
    return false
end

local function RestoreListeningSelection(a1) -- Line: 686
    -- upvalues: u213 (ref), IsAnyGamepadButtonDown (val), GuiService (val)
    local u1 = u213
    u213 = nil
    if not u1 then
        return
    end
    local u7 = a1
    if u7 then
        u7 = string.match(a1, "^Enum%.KeyCode%.(.+)$")
    end
    local success, result = pcall(function() -- Line: 694 -- upvalues: u7 (val)
        return Enum.KeyCode[u7]
    end)
    local u14 = if not u7 then nil else if not success then nil else result
    task.spawn(function() -- Line: 699 -- upvalues: u14 (val), IsAnyGamepadButtonDown (upval), u1 (val), GuiService (upval)
        local v1 = os.clock() + 1
        while u14 do
            if not (os.clock() < v1) or not IsAnyGamepadButtonDown(u14) then
                break
            end
            task.wait()
        end
        if u1.Parent and GuiService.SelectedObject == nil then
            GuiService.SelectedObject = u1
        end
    end)
end

local function ReenableScrolling() -- Line: 712 -- upvalues: u214 (ref), u209 (ref)
    if u214 ~= "Keybinds" then
        return
    end
    local Keybinds = u209.Frame.List:FindFirstChild("Keybinds")
    local Scroll = Keybinds and Keybinds.Bottom.Scroll
    if Scroll then
        Scroll.ScrollingEnabled = true
    end
end

local function HandleKeybindCapture(a1, a2) -- Line: 724
    -- upvalues: u211 (ref), u201 (val), u208 (ref), u214 (ref), u209 (ref), RestoreListeningSelection (val), u204 (val)
    -- upvalues: u205 (ref), u191 (val), BindDisplay (val), ClearKeybindHighlight (val), u199 (ref), u198 (ref)
    -- upvalues: u200 (ref), u0 (val), SwapKeybinds (val)
    local v1, v2, v3, v4, v5
    if not u211 then
        return
    end
    local Parent = a1.Parent
    if not Parent then
        v2 = nil
    elseif Parent.Name == "Right" then
        local Parent_2 = Parent.Parent
        if not Parent_2 then
            v2 = nil
        elseif Parent_2:IsA("GuiObject") then
            local Keybinds = u201.Keybinds
            v2 = if not Keybinds then nil else if Keybinds[Parent_2.Name] == Parent_2 then Parent_2 else nil
        else
            v2 = nil
        end
    else
        v2 = nil
    end
    if not v2 then
        local v6 = u211
        u208 = nil
        u211 = nil
        v6:ReleaseFocus()
        if u214 == "Keybinds" then
            local Keybinds_2 = u209.Frame.List:FindFirstChild("Keybinds")
            local Scroll = Keybinds_2 and Keybinds_2.Bottom.Scroll
            if Scroll then
                Scroll.ScrollingEnabled = true
            end
        end
        RestoreListeningSelection(a2)
        return
    end
    local Name = v2.Name
    local Name_2 = a1.Name
    if a2 == "" then
        v3 = nil
    elseif a2 ~= "None" then
        v5 = u204[(("%*:%*"):format(Name_2, a2))]
        v3 = if not v5 then nil else if v5 == Name then nil else v5
    else
        v3 = nil
    end
    local v7 = u214
    if u205 then
        v1 = u191[v7]
        v1 = u205[v1 or v7]
        if v1 then
            local searchInTable

            function searchInTable(a1) -- Line: 394 -- upvalues: Name (val), searchInTable (val)
                local v1
                for k, v in pairs(a1) do
                    if k == Name then
                        return v
                    end
                    if type(v) == "table" then
                        v1 = searchInTable(v)
                        if v1 ~= nil then
                            return v1
                        end
                    end
                end
                return nil
            end

            v5 = searchInTable(v1)
        else
            v5 = nil
        end
    else
        v5 = nil
    end
    if not v5 then
        v5 = {}
    end
    v7 = {Computer = if type(v5) ~= "table" then "" else v5.Computer}
    v7.Console = if type(v5) ~= "table" then "" else v5.Console
    local v8 = v7[Name_2]
    if v8 and v8 ~= "" and v8 ~= "" and v8 ~= "None" then
        u204[(("%*:%*"):format(Name_2, v8))] = nil
    end
    v7[Name_2] = a2
    if a2 ~= "" and a2 ~= "None" then
        u204[(("%*:%*"):format(Name_2, a2))] = Name
    end
    BindDisplay.Apply(a1, a2)
    BindDisplay.SetConflict(a1, v3 ~= nil)
    if not v4 then
        v1 = u211
        local v9 = u211
        local Attribute = v9:GetAttribute("DefaultTextColor")
        v1.TextColor3 = if typeof(Attribute) ~= "Color3" then v9.TextColor3 else Attribute
        ClearKeybindHighlight(Name, Name_2)
    else
        u211.TextColor3 = Color3.fromRGB(255, 90, 90)
    end
    if v4 then
        u199 = u199 + 1
        u198 = u199
        u200 = Name_2
    end
    u0.SettingChanged(u214, Name, v7, false, v4)
    if v4 and v3 then
        SwapKeybinds(Name, v3, a2, Name_2, v8)
    end
    u198 = nil
    u200 = nil
    v1 = u211
    u208 = nil
    u211 = nil
    v1:ReleaseFocus()
    if u214 == "Keybinds" then
        local Keybinds_3 = u209.Frame.List:FindFirstChild("Keybinds")
        local Scroll_2 = Keybinds_3 and Keybinds_3.Bottom.Scroll
        if Scroll_2 then
            Scroll_2.ScrollingEnabled = true
        end
    end
    RestoreListeningSelection(a2)
end

local function CancelKeybindListening() -- Line: 808
    -- upvalues: u211 (ref), GetKeybindPlatformFromTextBox (val), BindDisplay (val), u208 (ref), u214 (ref), u209 (ref)
    -- upvalues: RestoreListeningSelection (val)
    if not u211 then
        return
    end
    local v1 = u211
    local v2 = GetKeybindPlatformFromTextBox(v1)
    if not v2 then
        v1.Text = ""
    else
        BindDisplay.Apply(v2, u208 or "")
    end
    local Attribute = v1:GetAttribute("DefaultTextColor")
    v1.TextColor3 = if typeof(Attribute) ~= "Color3" then v1.TextColor3 else Attribute
    u208 = nil
    u211 = nil
    v1:ReleaseFocus()
    if u214 == "Keybinds" then
        local Keybinds = u209.Frame.List:FindFirstChild("Keybinds")
        local Scroll = Keybinds and Keybinds.Bottom.Scroll
        if Scroll then
            Scroll.ScrollingEnabled = true
        end
    end
    RestoreListeningSelection()
end

local function AddToHistory(a1, a2, a3) -- Line: 831 -- upvalues: u197 (val), u198 (ref) -- types: a1: string
    table.insert(u197, {path = a1, oldValue = a2, newValue = a3, batch = u198})
    while true do
        if not (#u197 > 50) then
            break
        end
        table.remove(u197, 1)
    end
end

function u0.RenderPage(a1) -- Line: 849
    -- upvalues: Profiler (val), Pages (val), u209 (ref), CaptureSelectedControl (val), ClearContainer (val), u185 (val)
    -- upvalues: u201 (val), u203 (val), Janitor (val), CreateCategoryHeader (val), u205 (ref), u191 (val), u0 (val)
    -- upvalues: u215 (val), GuiService (val), UserInputService (val), IsAnyGamepadButtonDown (val), RunService (val)
    -- upvalues: CloseButtonRegistry (val), ActivateButton (val), GetUserPlatform (val), u202 (val)
    -- upvalues: CrosshairPreview (val), NOOP (val), u214 (ref), Toggle (val), Number (val), Slider (val)
    -- upvalues: Dropdown (val), Settings (val), u210 (ref), u204 (val), u196 (ref), BindDisplay (val), Keybind (val)
    -- upvalues: GetKeybindPlatformFromTextBox (val), u211 (ref), u208 (ref), u212 (ref), u153 (val), u213 (ref)
    -- upvalues: CancelKeybindListening (val), RestoreSelectedControl (val)
    local Apply, Arrow, Close, FocusLost_2, Green, Hex, Label, Parent, Pick, bindChannelInput, bindDragStart, clampChannel, color3ToHex, commitColorChange, getMouseLocation, hideColorPopup, moveBrightness, movePicker, saveColors, setColorsFromColor3, setColorsFromHSV, setNextSelection, signalUpdateColorPicker, syncHSVFromRGB, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20
    Profiler.mark("UI.Settings.RenderPage")
    if not Pages.GetPage(a1) then
        warn((("[Settings] Page '%*' not found in configuration"):format(a1)))
        return
    end
    local u2850 = u209.Frame.List:FindFirstChild(a1)
    if not u2850 then
        warn((("[Settings] Page frame '%*' not found in UI"):format(a1)))
        return
    end
    local Scroll = u2850.Bottom.Scroll
    local v21 = CaptureSelectedControl(Scroll)
    ClearContainer(Scroll)
    local Header = u2850.Header.Heading.Header
    if Header then
        Header.Text = (string.upper(a1)) .. " SETTINGS"
    end
    local Title_2 = u2850.Header.Title
    if Title_2 then
        Title_2.Text = Pages.Descriptions[a1] or ""
    end
    local v22 = Pages.GetCategories(a1)
    local u60 = u185[a1]
    if u60 then
        table.sort(v22, function(a1, a2) -- Line: 884 -- upvalues: u60 (val)
            return (table.find(u60, a1) or 999) < (table.find(u60, a2) or 999)
        end)
    end
    u201[a1] = {}
    if not u203[a1] then
        u203[a1] = (Janitor.new())
    end
    local v23 = 0
    for i, v in ipairs(v22) do
        CreateCategoryHeader(v, Scroll, v23)
        v23 = v23 + 1
        v1 = {}
        for k, i2 in pairs((Pages.GetCategory(a1, v))) do
            if not k:match("^_Divider_") then
                table.insert(v1, {name = k, config = i2})
            end
        end
        table.sort(v1, function(a1, a2) -- Line: 919
            local v1 = a1.config.Order or 999
            local v2 = a2.config.Order or 999
            if v1 == v2 then
                return a1.name < a2.name
            end
            return v1 < v2
        end)
        local u2716 = nil
        if a1 == "Game" and v == "Crosshair" then
            if u2850:FindFirstChild("ChangeColor") then
                u2850.ChangeColor:Destroy()
            end
            if u2850.Bottom.Scroll:FindFirstChild("ColorPickerTemplate") then
                u2850.Bottom.Scroll.ColorPickerTemplate:Destroy()
            end

            function clampChannel(a1) -- Line: 940 -- types: a1: number
                return (math.clamp(math.round(a1), 0, 255))
            end

            local u1348 = {}
            if u205 then
                v3 = u191[a1]
                v3 = u205[v3 or a1]
                if v3 then
                    local u184 = "Red"

                    local function searchInTable(a1) -- Line: 394 -- upvalues: u184 (val), searchInTable (val)
                        local v1
                        for k, v in pairs(a1) do
                            if k == u184 then
                                return v
                            end
                            if type(v) == "table" then
                                v1 = searchInTable(v)
                                if v1 ~= nil then
                                    return v1
                                end
                            end
                        end
                        return nil
                    end

                    v2 = searchInTable(v3)
                else
                    v2 = nil
                end
            else
                v2 = nil
            end
            v2 = math.round((tonumber(v2)) or 0)
            u1348.Red = math.clamp(v2, 0, 255)
            if u205 then
                v3 = u191[a1]
                v3 = u205[v3 or a1]
                if v3 then
                    local u212_2 = "Green"

                    local function searchInTable_2(a1) -- Line: 394 -- upvalues: u212_2 (val), searchInTable_2 (val)
                        local v1
                        for k, v in pairs(a1) do
                            if k == u212_2 then
                                return v
                            end
                            if type(v) == "table" then
                                v1 = searchInTable_2(v)
                                if v1 ~= nil then
                                    return v1
                                end
                            end
                        end
                        return nil
                    end

                    v2 = searchInTable_2(v3)
                else
                    v2 = nil
                end
            else
                v2 = nil
            end
            v2 = math.round((tonumber(v2)) or 255)
            u1348.Green = math.clamp(v2, 0, 255)
            if u205 then
                v3 = u191[a1]
                v3 = u205[v3 or a1]
                if v3 then
                    local u240 = "Blue"

                    local function searchInTable_3(a1) -- Line: 394 -- upvalues: u240 (val), searchInTable_3 (val)
                        local v1
                        for k, v in pairs(a1) do
                            if k == u240 then
                                return v
                            end
                            if type(v) == "table" then
                                v1 = searchInTable_3(v)
                                if v1 ~= nil then
                                    return v1
                                end
                            end
                        end
                        return nil
                    end

                    v2 = searchInTable_3(v3)
                else
                    v2 = nil
                end
            else
                v2 = nil
            end
            v2 = math.round((tonumber(v2)) or 0)
            u1348.Blue = math.clamp(v2, 0, 255)

            function saveColors() -- Line: 950 -- upvalues: u0 (upval), a1 (val), u1348 (val)
                u0.SettingChanged(a1, "Red", u1348.Red)
                u0.SettingChanged(a1, "Green", u1348.Green)
                u0.SettingChanged(a1, "Blue", u1348.Blue)
            end

            function setColorsFromColor3(a1) -- Line: 956 -- upvalues: u1348 (val) -- types: a1: userdata
                u1348.Red = math.clamp(math.round(a1.R * 255), 0, 255)
                u1348.Green = math.clamp(math.round(a1.G * 255), 0, 255)
                u1348.Blue = math.clamp(math.round(a1.B * 255), 0, 255)
            end

            local u1155 = u215.ChangeColor:Clone()
            u1155.Parent = u2850
            u2716 = u215.ColorPickerTemplate:Clone()
            u2716.Parent = u2850.Bottom.Scroll
            Label = u2716:FindFirstChild("Label", true)
            if Label and Label:IsA("TextLabel") then
                Label.Text = "Crosshair Color"
            end
            local UpdateColorPicker = u1155:FindFirstChild("UpdateColorPicker", true)
            local ColorPicker = u1155:FindFirstChild("ColorPicker", true)
            local Hue = u1155:FindFirstChild("Hue", true)
            local u316 = nil
            local u327 = nil
            if ColorPicker then
                Pick = ColorPicker:FindFirstChild("Pick", true)
                if Pick and Pick:IsA("GuiObject") then
                    u316 = Pick
                end
            end
            if Hue then
                Arrow = Hue:FindFirstChild("Arrow", true)
                if Arrow and Arrow:IsA("GuiObject") then
                    u327 = Arrow
                end
            end

            function color3ToHex(a1) -- Line: 994 -- types: a1: userdata
                return string.format("#%02X%02X%02X", math.round(a1.R * 255), math.round(a1.G * 255), (math.round(a1.B * 255)))
            end

            u1355, u1362, u1369 = Color3.toHSV(Color3.fromRGB(u1348.Red, u1348.Green, u1348.Blue))

            function setColorsFromHSV() -- Line: 1005 -- upvalues: u1355 (ref), u1362 (ref), u1369 (ref), u1348 (val)
                local v1 = Color3.fromHSV(math.clamp(u1355, 0, 1), math.clamp(u1362, 0, 1), (math.clamp(u1369, 0, 1)))
                u1348.Red = math.clamp(math.round(v1.R * 255), 0, 255)
                u1348.Green = math.clamp(math.round(v1.G * 255), 0, 255)
                u1348.Blue = math.clamp(math.round(v1.B * 255), 0, 255)
            end

            function syncHSVFromRGB() -- Line: 1011 -- upvalues: u1348 (val), u1355 (ref), u1362 (ref), u1369 (ref)
                local v1, v2, v3 = Color3.toHSV(Color3.fromRGB(u1348.Red, u1348.Green, u1348.Blue))
                if v2 > 0 then
                    u1355 = v1
                end
                u1362 = v2
                u1369 = v3
            end

            function signalUpdateColorPicker() -- Line: 1023 -- upvalues: UpdateColorPicker (val), u1348 (val)
                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                end
            end

            local function setIndicatorFromAbsolutePoint(a1, a2, a3, a4, a5) -- Line: 1029
                -- upvalues: 
                local Parent = a1.Parent
                if Parent and Parent:IsA("GuiObject") then
                    local AbsolutePosition_2 = a2.AbsolutePosition
                    local AbsoluteSize = a2.AbsoluteSize
                    local AbsoluteSize_2 = a1.AbsoluteSize
                    local AbsolutePosition = Parent.AbsolutePosition
                    if not (AbsoluteSize.X <= 0)
                        and not (AbsoluteSize.Y <= 0)
                        and not (AbsoluteSize_2.X <= 0)
                        and not (AbsoluteSize_2.Y <= 0) then
                        local v1 = AbsoluteSize_2.X * 0.5
                        local v2 = AbsoluteSize_2.Y * 0.5
                        local v3 = math.clamp(a3.X, AbsolutePosition_2.X, AbsolutePosition_2.X + AbsoluteSize.X)
                        local v4 = math.clamp(a3.Y, AbsolutePosition_2.Y, AbsolutePosition_2.Y + AbsoluteSize.Y)
                        local v5 = v3 - v1 - AbsolutePosition.X
                        local v6 = v4 - v2 - AbsolutePosition.Y
                        a1.Position = UDim2.new(
                            if not a4 then a1.Position.X.Scale else 0,
                            if not a4 then a1.Position.X.Offset else v5,
                            if not a5 then a1.Position.Y.Scale else 0,
                            if not a5 then a1.Position.Y.Offset else v6
                        )
                        return
                    end
                    return
                end
            end

            local function updateColorPicker() -- Line: 1069
                -- upvalues: u1348 (val), u1155 (val), u1355 (ref), u1362 (ref), u2716 (ref), ColorPicker (val)
                -- upvalues: u316 (ref), setIndicatorFromAbsolutePoint (val), Hue (val), u327 (ref), u1369 (ref)
                local v1 = Color3.fromRGB(u1348.Red, u1348.Green, u1348.Blue)
                u1155.Hue.BackgroundColor3 = Color3.fromHSV(u1355, math.max(u1362, 0.01), 1)
                u2716.ColorPreview.BackgroundColor3 = v1
                u1155.Preview.BackgroundColor3 = v1
                u1155.Hex.Container.Left.Title.Text = string.format("#%02X%02X%02X", math.round(v1.R * 255), math.round(v1.G * 255), (math.round(v1.B * 255)))
                for i, j in u2716.Right:GetChildren() do
                    if u1348[j.Name] ~= nil then
                        j.Container.Left.Title.Text = tostring(u1348[j.Name])
                    end
                end
                for k, n in u1155.RGB:GetChildren() do
                    if n:IsA("Frame") then
                        n.Container.Left.Title.Text = tostring(u1348[n.Name])
                    end
                end
                if ColorPicker and ColorPicker:IsA("GuiObject") and u316 then
                    local AbsoluteSize = ColorPicker.AbsoluteSize
                    if 0 < AbsoluteSize.X and 0 < AbsoluteSize.Y then
                        local v2 = ColorPicker.AbsolutePosition + Vector2.new((math.clamp(u1355, 0, 1)) * AbsoluteSize.X, (1 - math.clamp(u1362, 0, 1)) * AbsoluteSize.Y)
                        setIndicatorFromAbsolutePoint(u316, ColorPicker, v2, true, true)
                    end
                end
                if Hue and Hue:IsA("GuiObject") and u327 then
                    local AbsoluteSize_2 = Hue.AbsoluteSize
                    if 0 < AbsoluteSize_2.Y then
                        local v3 = (1 - math.clamp(u1369, 0, 1)) * AbsoluteSize_2.Y
                        local v4 = Hue.AbsolutePosition + Vector2.new(AbsoluteSize_2.X * 0.5, v3)
                        setIndicatorFromAbsolutePoint(u327, Hue, v4, false, true)
                    end
                end
            end

            function commitColorChange() -- Line: 1112
                -- upvalues: updateColorPicker (val), UpdateColorPicker (val), u1348 (val)
                updateColorPicker()
                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                end
            end

            function getMouseLocation() -- Line: 1117 -- upvalues: GuiService (upval), UserInputService (upval)
                local GuiInset = GuiService:GetGuiInset()
                return UserInputService:GetMouseLocation() - GuiInset
            end

            local function setPickerFromMouse(a1) -- Line: 1122
                -- upvalues: ColorPicker (val), u1355 (ref), u1362 (ref), u1369 (ref), u1348 (val)
                -- upvalues: updateColorPicker (val), UpdateColorPicker (val)
                if ColorPicker and ColorPicker:IsA("GuiObject") then
                    local AbsoluteSize = ColorPicker.AbsoluteSize
                    if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
                        local AbsolutePosition = ColorPicker.AbsolutePosition
                        local v1 = math.clamp((a1.X - AbsolutePosition.X) / AbsoluteSize.X, 0, 1)
                        u1362 = 1 - (math.clamp((a1.Y - AbsolutePosition.Y) / AbsoluteSize.Y, 0, 1))
                        local v2 = Color3.fromHSV(math.clamp(v1, 0, 1), math.clamp(u1362, 0, 1), (math.clamp(u1369, 0, 1)))
                        u1348.Red = math.clamp(math.round(v2.R * 255), 0, 255)
                        u1348.Green = math.clamp(math.round(v2.G * 255), 0, 255)
                        u1348.Blue = math.clamp(math.round(v2.B * 255), 0, 255)
                        updateColorPicker()
                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                        end
                        return
                    end
                    return
                end
            end

            local function setHueFromMouse(a1) -- Line: 1143
                -- upvalues: Hue (val), u1369 (ref), u1355 (ref), u1362 (ref), u1348 (val), updateColorPicker (val)
                -- upvalues: UpdateColorPicker (val)
                if Hue and Hue:IsA("GuiObject") then
                    local AbsoluteSize = Hue.AbsoluteSize
                    if AbsoluteSize.Y <= 0 then
                        return
                    end
                    u1369 = 1 - math.clamp((a1.Y - Hue.AbsolutePosition.Y) / AbsoluteSize.Y, 0, 1)
                    local v1 = Color3.fromHSV(math.clamp(u1355, 0, 1), math.clamp(u1362, 0, 1), (math.clamp(u1369, 0, 1)))
                    u1348.Red = math.clamp(math.round(v1.R * 255), 0, 255)
                    u1348.Green = math.clamp(math.round(v1.G * 255), 0, 255)
                    u1348.Blue = math.clamp(math.round(v1.B * 255), 0, 255)
                    updateColorPicker()
                    if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                        UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                    end
                    return
                end
            end

            local u364 = false
            local u365 = false

            function bindDragStart(a1_2, a2) -- Line: 1164
                -- upvalues: u203 (upval), a1 (val)
                if a1_2 and a1_2:IsA("GuiObject") then
                    u203[a1]:Add(a1_2.InputBegan:Connect(function(a1) -- Line: 1167 -- upvalues: a2 (val) -- types: a1: userdata
                        if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                            a2()
                        end
                    end), "Disconnect")
                end
            end

            bindDragStart(ColorPicker, function() -- Line: 1177 -- upvalues: u364 (ref), setPickerFromMouse (val), GuiService (upval), UserInputService (upval)
                u364 = true
                local v1 = setPickerFromMouse
                local GuiInset = GuiService:GetGuiInset()
                v1(UserInputService:GetMouseLocation() - GuiInset)
            end)
            bindDragStart(Hue, function() -- Line: 1182 -- upvalues: u365 (ref), setHueFromMouse (val), GuiService (upval), UserInputService (upval)
                u365 = true
                local v1 = setHueFromMouse
                local GuiInset = GuiService:GetGuiInset()
                v1(UserInputService:GetMouseLocation() - GuiInset)
            end)
            u203[a1]:Add(UserInputService.InputChanged:Connect(function(a1) -- Line: 1188
                -- upvalues: GuiService (upval), UserInputService (upval), u364 (ref), setPickerFromMouse (val)
                -- upvalues: u365 (ref), setHueFromMouse (val)
                if a1.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return
                end
                local GuiInset = GuiService:GetGuiInset()
                local v1 = UserInputService:GetMouseLocation() - GuiInset
                if u364 then
                    setPickerFromMouse(v1)
                    return
                end
                if u365 then
                    setHueFromMouse(v1)
                end
            end), "Disconnect")
            u203[a1]:Add(UserInputService.InputEnded:Connect(function(a1) -- Line: 1204 -- upvalues: u364 (ref), u365 (ref) -- types: a1: userdata
                if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                    u364 = false
                    u365 = false
                end
            end), "Disconnect")
            updateColorPicker()

            function bindChannelInput(a1_2, a2) -- Line: 1216
                -- upvalues: u1348 (val), u0 (upval), a1 (val), u1355 (ref), u1362 (ref), u1369 (ref)
                -- upvalues: updateColorPicker (val), UpdateColorPicker (val)
                a1_2.Container.Left.Title.FocusLost:Connect(function() -- Line: 1217
                    -- upvalues: a1_2 (val), u1348 (upval), a2 (val), u0 (upval), a1 (upval), u1355 (upval)
                    -- upvalues: u1362 (upval), u1369 (upval), updateColorPicker (upval), UpdateColorPicker (upval)
                    local v1 = tonumber(a1_2.Container.Left.Title.Text) or u1348[a1_2.Name]
                    u1348[a1_2.Name] = (math.clamp(math.round(v1), 0, 255))
                    if a2 then
                        u0.SettingChanged(a1, "Red", u1348.Red)
                        u0.SettingChanged(a1, "Green", u1348.Green)
                        u0.SettingChanged(a1, "Blue", u1348.Blue)
                    end
                    local v2, v3, v4 = Color3.toHSV(Color3.fromRGB(u1348.Red, u1348.Green, u1348.Blue))
                    if v3 > 0 then
                        u1355 = v2
                    end
                    u1362 = v3
                    u1369 = v4
                    updateColorPicker()
                    if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                        UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                    end
                end)
            end

            local u1225 = {}
            u1225[u1155.Hex] = u1155.Hex.Container.Left.Title
            for j, k2 in u2716.Right:GetChildren() do
                if u1348[k2.Name] ~= nil then
                    v15 = k2.Container.Left.Title.FocusLost
                    local u1431 = true
                    v15:Connect(function() -- Line: 1217
                        -- upvalues: k2 (val), u1348 (val), u1431 (val), u0 (upval), a1 (val), u1355 (ref), u1362 (ref)
                        -- upvalues: u1369 (ref), updateColorPicker (val), UpdateColorPicker (val)
                        local v1 = tonumber(k2.Container.Left.Title.Text) or u1348[k2.Name]
                        u1348[k2.Name] = (math.clamp(math.round(v1), 0, 255))
                        if u1431 then
                            u0.SettingChanged(a1, "Red", u1348.Red)
                            u0.SettingChanged(a1, "Green", u1348.Green)
                            u0.SettingChanged(a1, "Blue", u1348.Blue)
                        end
                        local v2, v3, v4 = Color3.toHSV(Color3.fromRGB(u1348.Red, u1348.Green, u1348.Blue))
                        if v3 > 0 then
                            u1355 = v2
                        end
                        u1362 = v3
                        u1369 = v4
                        updateColorPicker()
                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                        end
                    end)
                    local Title = k2.Container.Left.Title
                    Title.Selectable = false
                    if k2:IsA("GuiButton") then
                        k2.Activated:Connect(function() -- Line: 1241 -- upvalues: Title (val)
                            Title:CaptureFocus()
                        end)
                    end
                end
            end
            for n, m in u1155.RGB:GetChildren() do
                if m:IsA("Frame") then
                    FocusLost_2 = m.Container.Left.Title.FocusLost
                    local u1405 = false
                    FocusLost_2:Connect(function() -- Line: 1217
                        -- upvalues: m (val), u1348 (val), u1405 (val), u0 (upval), a1 (val), u1355 (ref), u1362 (ref)
                        -- upvalues: u1369 (ref), updateColorPicker (val), UpdateColorPicker (val)
                        local v1 = tonumber(m.Container.Left.Title.Text) or u1348[m.Name]
                        u1348[m.Name] = (math.clamp(math.round(v1), 0, 255))
                        if u1405 then
                            u0.SettingChanged(a1, "Red", u1348.Red)
                            u0.SettingChanged(a1, "Green", u1348.Green)
                            u0.SettingChanged(a1, "Blue", u1348.Blue)
                        end
                        local v2, v3, v4 = Color3.toHSV(Color3.fromRGB(u1348.Red, u1348.Green, u1348.Blue))
                        if v3 > 0 then
                            u1355 = v2
                        end
                        u1362 = v3
                        u1369 = v4
                        updateColorPicker()
                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                        end
                    end)
                    u1225[m] = m.Container.Left.Title
                end
            end
            local GuiButton = u2716.ColorPreview:FindFirstChildWhichIsA("GuiButton")
            if not GuiButton then
                GuiButton = u2716.ColorPreview
            end
            if not ColorPicker or not ColorPicker:IsA("GuiObject") then
                u1308 = nil
            else
                local u1308 = ColorPicker
            end
            if not Hue or not Hue:IsA("GuiObject") then
                u462 = nil
            else
                local u462 = Hue
            end
            local Red = u1155.RGB:FindFirstChild("Red")
            Green = u1155.RGB:FindFirstChild("Green")
            local Blue = u1155.RGB:FindFirstChild("Blue")
            local u1187 = 0
            if u1308 then
                u1308.Selectable = true
            end
            if u462 then
                u462.Selectable = true
            end
            u1155.SelectionGroup = true
            u1155.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
            u1155.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
            u1155.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
            u1155.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

            local function getGamepadDirection() -- Line: 1289
                -- upvalues: UserInputService (upval), IsAnyGamepadButtonDown (upval)
                local v1
                local zero = Vector2.zero
                for i, j in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
                    if j.KeyCode == Enum.KeyCode.Thumbstick1 then
                        v1 = Vector2.new(j.Position.X, -j.Position.Y)
                        if 0.2 <= v1.Magnitude then
                            zero = zero + v1
                        end
                    end
                end
                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadLeft) then
                    zero = zero - Vector2.xAxis
                end
                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadRight) then
                    zero = zero + Vector2.xAxis
                end
                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadUp) then
                    zero = zero - Vector2.yAxis
                end
                if IsAnyGamepadButtonDown(Enum.KeyCode.DPadDown) then
                    zero = zero + Vector2.yAxis
                end
                if 1 < zero.Magnitude then
                    return zero.Unit
                end
                return zero
            end

            function setNextSelection(a1, a2, a3, a4, a5) -- Line: 1317
                -- upvalues: 
                if not a1 then
                    return
                end
                if a1.NextSelectionUp ~= a2 then
                    a1.NextSelectionUp = a2
                end
                if a1.NextSelectionDown ~= a3 then
                    a1.NextSelectionDown = a3
                end
                if a1.NextSelectionLeft ~= a4 then
                    a1.NextSelectionLeft = a4
                end
                if a1.NextSelectionRight ~= a5 then
                    a1.NextSelectionRight = a5
                end
            end

            Hex = u1155.Hex
            Apply = u1155.Buttons.Buttons.Apply
            Close = u1155.Buttons.Buttons.Close
            if Red then
                if Red.NextSelectionUp ~= u1308 then
                    Red.NextSelectionUp = u1308
                end
                if Red.NextSelectionDown ~= Hex then
                    Red.NextSelectionDown = Hex
                end
                if Red.NextSelectionLeft ~= Red then
                    Red.NextSelectionLeft = Red
                end
                if Red.NextSelectionRight ~= Green then
                    Red.NextSelectionRight = Green
                end
            end
            if Green then
                if Green.NextSelectionUp ~= u1308 then
                    Green.NextSelectionUp = u1308
                end
                if Green.NextSelectionDown ~= Hex then
                    Green.NextSelectionDown = Hex
                end
                if Green.NextSelectionLeft ~= Red then
                    Green.NextSelectionLeft = Red
                end
                if Green.NextSelectionRight ~= Blue then
                    Green.NextSelectionRight = Blue
                end
            end
            v16 = u462 or u1308
            if Blue then
                if Blue.NextSelectionUp ~= v16 then
                    Blue.NextSelectionUp = v16
                end
                if Blue.NextSelectionDown ~= Hex then
                    Blue.NextSelectionDown = Hex
                end
                if Blue.NextSelectionLeft ~= Green then
                    Blue.NextSelectionLeft = Green
                end
                if Blue.NextSelectionRight ~= Blue then
                    Blue.NextSelectionRight = Blue
                end
            end
            if Hex then
                if Hex.NextSelectionUp ~= Green then
                    Hex.NextSelectionUp = Green
                end
                if Hex.NextSelectionDown ~= Apply then
                    Hex.NextSelectionDown = Apply
                end
                if Hex.NextSelectionLeft ~= Hex then
                    Hex.NextSelectionLeft = Hex
                end
                if Hex.NextSelectionRight ~= Hex then
                    Hex.NextSelectionRight = Hex
                end
            end
            if Apply then
                if Apply.NextSelectionUp ~= Hex then
                    Apply.NextSelectionUp = Hex
                end
                if Apply.NextSelectionDown ~= Apply then
                    Apply.NextSelectionDown = Apply
                end
                if Apply.NextSelectionLeft ~= Apply then
                    Apply.NextSelectionLeft = Apply
                end
                if Apply.NextSelectionRight ~= Close then
                    Apply.NextSelectionRight = Close
                end
            end
            if Close then
                if Close.NextSelectionUp ~= Hex then
                    Close.NextSelectionUp = Hex
                end
                if Close.NextSelectionDown ~= Close then
                    Close.NextSelectionDown = Close
                end
                if Close.NextSelectionLeft ~= Apply then
                    Close.NextSelectionLeft = Apply
                end
                if Close.NextSelectionRight ~= Close then
                    Close.NextSelectionRight = Close
                end
            end

            function movePicker(a1) -- Line: 1355
                -- upvalues: u1355 (ref), u1362 (ref), u1369 (ref), u1348 (val), updateColorPicker (val)
                -- upvalues: UpdateColorPicker (val)
                u1355 = math.clamp(u1355 + a1.X, 0, 1)
                u1362 = math.clamp(u1362 - a1.Y, 0, 1)
                local v1 = Color3.fromHSV(math.clamp(u1355, 0, 1), math.clamp(u1362, 0, 1), (math.clamp(u1369, 0, 1)))
                u1348.Red = math.clamp(math.round(v1.R * 255), 0, 255)
                u1348.Green = math.clamp(math.round(v1.G * 255), 0, 255)
                u1348.Blue = math.clamp(math.round(v1.B * 255), 0, 255)
                updateColorPicker()
                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                end
            end

            function moveBrightness(a1) -- Line: 1362
                -- upvalues: u1369 (ref), u1355 (ref), u1362 (ref), u1348 (val), updateColorPicker (val)
                -- upvalues: UpdateColorPicker (val)
                u1369 = math.clamp(u1369 - a1.Y, 0, 1)
                local v1 = Color3.fromHSV(math.clamp(u1355, 0, 1), math.clamp(u1362, 0, 1), (math.clamp(u1369, 0, 1)))
                u1348.Red = math.clamp(math.round(v1.R * 255), 0, 255)
                u1348.Green = math.clamp(math.round(v1.G * 255), 0, 255)
                u1348.Blue = math.clamp(math.round(v1.B * 255), 0, 255)
                updateColorPicker()
                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                end
            end

            u203[a1]:Add(RunService.Heartbeat:Connect(function(a1) -- Line: 1369
                -- upvalues: GuiService (upval), u1155 (val), getGamepadDirection (val), u1308 (val), u1355 (ref)
                -- upvalues: u1362 (ref), u1369 (ref), u1348 (val), updateColorPicker (val), UpdateColorPicker (val)
                -- upvalues: Red (val), u462 (val), Blue (val)
                local SelectedObject = GuiService.SelectedObject
                if u1155.Visible and SelectedObject then
                    local v1, v2
                    local v3 = getGamepadDirection() * (a1 / 2)
                    if SelectedObject ~= u1308 then
                        if SelectedObject == u462 then
                            if v3.Y ~= 0 then
                                u1369 = math.clamp(u1369 - v3.Y, 0, 1)
                                v1 = Color3.fromHSV(math.clamp(u1355, 0, 1), math.clamp(u1362, 0, 1), (math.clamp(u1369, 0, 1)))
                                u1348.Red = math.clamp(math.round(v1.R * 255), 0, 255)
                                u1348.Green = math.clamp(math.round(v1.G * 255), 0, 255)
                                u1348.Blue = math.clamp(math.round(v1.B * 255), 0, 255)
                                updateColorPicker()
                                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                                    UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                                end
                            end
                            v1 = if not (u1369 > 0) then Blue else SelectedObject
                            v2 = u1308
                            if not SelectedObject then
                                return
                            end
                            if SelectedObject.NextSelectionUp ~= SelectedObject then
                                SelectedObject.NextSelectionUp = SelectedObject
                            end
                            if SelectedObject.NextSelectionDown ~= v1 then
                                SelectedObject.NextSelectionDown = v1
                            end
                            if SelectedObject.NextSelectionLeft ~= v2 then
                                SelectedObject.NextSelectionLeft = v2
                            end
                            if SelectedObject.NextSelectionRight ~= SelectedObject then
                                SelectedObject.NextSelectionRight = SelectedObject
                            end
                        end
                        return
                    end
                    if v3 ~= Vector2.zero then
                        u1355 = math.clamp(u1355 + v3.X, 0, 1)
                        u1362 = math.clamp(u1362 - v3.Y, 0, 1)
                        v1 = Color3.fromHSV(math.clamp(u1355, 0, 1), math.clamp(u1362, 0, 1), (math.clamp(u1369, 0, 1)))
                        u1348.Red = math.clamp(math.round(v1.R * 255), 0, 255)
                        u1348.Green = math.clamp(math.round(v1.G * 255), 0, 255)
                        u1348.Blue = math.clamp(math.round(v1.B * 255), 0, 255)
                        updateColorPicker()
                        if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                            UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                        end
                    end
                    v1 = if not (u1362 > 0) then Red else SelectedObject
                    v2 = if not (u1355 < 1) then u462 else SelectedObject
                    if not SelectedObject then
                        return
                    end
                    if SelectedObject.NextSelectionUp ~= SelectedObject then
                        SelectedObject.NextSelectionUp = SelectedObject
                    end
                    if SelectedObject.NextSelectionDown ~= v1 then
                        SelectedObject.NextSelectionDown = v1
                    end
                    if SelectedObject.NextSelectionLeft ~= SelectedObject then
                        SelectedObject.NextSelectionLeft = SelectedObject
                    end
                    if SelectedObject.NextSelectionRight == v2 then
                        return
                    end
                    SelectedObject.NextSelectionRight = v2
                    return
                end
            end), "Disconnect")

            function hideColorPopup() -- Line: 1398 -- upvalues: UserInputService (upval), u1155 (val)
                local FocusedTextBox = UserInputService:GetFocusedTextBox()
                if FocusedTextBox and FocusedTextBox:IsDescendantOf(u1155) then
                    FocusedTextBox:ReleaseFocus()
                end
                u1155.Visible = false
            end

            local function closeColorPopup() -- Line: 1407
                -- upvalues: GuiService (upval), UserInputService (upval), u1155 (val), GuiButton (val)
                local SelectedObject = GuiService.SelectedObject
                local v1 = false
                if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                    v1 = true
                    if SelectedObject ~= nil then
                        v1 = SelectedObject:IsDescendantOf(u1155)
                    end
                end
                local FocusedTextBox = UserInputService:GetFocusedTextBox()
                if FocusedTextBox and FocusedTextBox:IsDescendantOf(u1155) then
                    FocusedTextBox:ReleaseFocus()
                end
                u1155.Visible = false
                if v1 and GuiButton:IsA("GuiButton") and GuiButton:IsDescendantOf(game) then
                    GuiService.SelectedObject = GuiButton
                end
            end

            CloseButtonRegistry.Add(u1155, nil, closeColorPopup)
            u203[a1]:Add(function() -- Line: 1423 -- upvalues: CloseButtonRegistry (upval), u1155 (val)
                CloseButtonRegistry.Remove(u1155)
            end, true)
            Parent = u1155.Parent
            while Parent do
                if not Parent:IsA("GuiObject") then
                    break
                end
                local u1053 = Parent
                u203[a1]:Add((u1053:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 1437 -- upvalues: u1155 (val), u1053 (val), UserInputService (upval)
                    if u1155.Visible and not u1053.Visible then
                        local FocusedTextBox = UserInputService:GetFocusedTextBox()
                        if FocusedTextBox and FocusedTextBox:IsDescendantOf(u1155) then
                            FocusedTextBox:ReleaseFocus()
                        end
                        u1155.Visible = false
                    end
                end), "Disconnect")
                Parent = Parent.Parent
            end
            local u1136 = {}
            v17 = {u1308, u462, Red, Green, Blue, Hex, Apply}
            v18 = nil
            v19 = #v17
            for i5 = 1, v19 do
                v20 = v17[i5]
                if v20 then
                    if v18 then
                        u1136[v18] = v20
                    end
                end
            end
            local u1140 = nil
            u203[a1]:Add(UserInputService.InputBegan:Connect(function(a1) -- Line: 1465
                -- upvalues: u1155 (val), UserInputService (upval), GuiService (upval), u1140 (ref), u1187 (ref)
                -- upvalues: u1225 (val)
                if u1155.Visible and not UserInputService:GetFocusedTextBox() then
                    local SelectedObject = GuiService.SelectedObject
                    if a1.KeyCode == Enum.KeyCode.ButtonA then
                        u1140 = if not (0.1 <= os.clock() - u1187) then nil else SelectedObject
                        return
                    end
                    if a1.KeyCode == Enum.KeyCode.ButtonY and SelectedObject and u1225[SelectedObject] then
                        u1225[SelectedObject]:CaptureFocus()
                    end
                    return
                end
            end), "Disconnect")
            u203[a1]:Add(UserInputService.InputEnded:Connect(function(a1) -- Line: 1483 -- upvalues: u1140 (ref), u1136 (val), u1155 (val), GuiService (upval) -- types: a1: userdata
                if a1.KeyCode ~= Enum.KeyCode.ButtonA then
                    return
                end
                local u3 = u1140
                u1140 = nil
                local u7 = u3
                if u7 then
                    u7 = u1136[u3]
                end
                if not u7 then
                    return
                end
                task.defer(function() -- Line: 1496 -- upvalues: u1155 (upval), GuiService (upval), u3 (val), u7 (val)
                    if u1155.Visible and GuiService.SelectedObject == u3 then
                        GuiService.SelectedObject = u7
                    end
                end)
            end), "Disconnect")
            if GuiButton:IsA("GuiButton") then
                ActivateButton(GuiButton)
                GuiButton.MouseButton1Click:Connect(function() -- Line: 1507 -- upvalues: GuiService (upval), u2850 (val), updateColorPicker (val), u1308 (val), u1187 (ref)
                    local v1 = GuiService.SelectedObject ~= nil
                    u2850.ChangeColor.Visible = true
                    updateColorPicker()
                    if v1 and u1308 then
                        u1187 = os.clock()
                        GuiService.SelectedObject = u1308
                    end
                end)
            end
            ActivateButton(u2850.ChangeColor.Buttons.Buttons.Close)
            u2850.ChangeColor.Buttons.Buttons.Close.MouseButton1Click:Connect(closeColorPopup)
            u1155.Hex.Container.Left.Title.FocusLost:Connect(function() -- Line: 1522
                -- upvalues: u1155 (val), u1348 (val), u1355 (ref), u1362 (ref), u1369 (ref), updateColorPicker (val)
                -- upvalues: UpdateColorPicker (val)
                local success, result = pcall(Color3.fromHex, u1155.Hex.Container.Left.Title.Text)
                if success and result then
                    u1348.Red = math.clamp(math.round(result.R * 255), 0, 255)
                    u1348.Green = math.clamp(math.round(result.G * 255), 0, 255)
                    u1348.Blue = math.clamp(math.round(result.B * 255), 0, 255)
                    local v1, v2, v3 = Color3.toHSV(Color3.fromRGB(u1348.Red, u1348.Green, u1348.Blue))
                    if v2 > 0 then
                        u1355 = v1
                    end
                    u1362 = v2
                    u1369 = v3
                    updateColorPicker()
                    if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                        UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                    end
                end
            end)
            ActivateButton(u2850.ChangeColor.Buttons.Buttons.Apply)
            u2850.ChangeColor.Buttons.Buttons.Apply.MouseButton1Click:Connect(function() -- Line: 1532
                -- upvalues: closeColorPopup (val), updateColorPicker (val), UpdateColorPicker (val), u1348 (val)
                -- upvalues: u0 (upval), a1 (val)
                closeColorPopup()
                updateColorPicker()
                if UpdateColorPicker and UpdateColorPicker:IsA("BindableEvent") then
                    UpdateColorPicker:Fire(u1348.Red, u1348.Green, u1348.Blue)
                end
                u0.SettingChanged(a1, "Red", u1348.Red)
                u0.SettingChanged(a1, "Green", u1348.Green)
                u0.SettingChanged(a1, "Blue", u1348.Blue)
            end)
        end
        for i3, i6 in ipairs(v1) do
            if i6.name == "Red" or i6.name == "Green" then
                u2716.LayoutOrder = v23
                v23 = v23 + 1
            elseif i6.name ~= "Blue" then
                v2 = i6.config
                local name = i6.name
                v3 = nil
                v4 = nil
                if not v2.Platform then
                    v5 = ("Settings.%*.%*.%*"):format(u191[a1] or a1, v, name)
                    v7 = {pageName = a1, categoryName = v, settingName = name, settingPath = v5}
                    u202[name] = v7
                    if v2.Type ~= "CrosshairPreview" then
                        if v2.Type == "Toggle" then
                            assert(u215.ToggleTemplate, "ToggleTemplate not loaded")
                            v3 = u215.ToggleTemplate:Clone()
                            v6 = u214
                            if u205 then
                                v8 = u191[v6]
                                v8 = u205[v8 or v6]
                                if v8 then
                                    local function searchInTable_4(a1) -- Line: 394
                                        -- upvalues: name (val), searchInTable_4 (val)
                                        local v1
                                        for k, v in pairs(a1) do
                                            if k == name then
                                                return v
                                            end
                                            if type(v) == "table" then
                                                v1 = searchInTable_4(v)
                                                if v1 ~= nil then
                                                    return v1
                                                end
                                            end
                                        end
                                        return nil
                                    end

                                    v5 = searchInTable_4(v8)
                                else
                                    v5 = nil
                                end
                            else
                                v5 = nil
                            end
                            if v5 == nil then
                                v5 = v2.Default
                            end
                            v4 = Toggle(name, v2, Scroll, v23, v3, v5, u0.SettingChanged, u214)
                        elseif v2.Type == "Number" then
                            assert(u215.NumberTemplate, "NumberTemplate not loaded")
                            v3 = u215.NumberTemplate:Clone()
                            v6 = u214
                            if u205 then
                                v8 = u191[v6]
                                v8 = u205[v8 or v6]
                                if v8 then
                                    local function searchInTable_5(a1) -- Line: 394
                                        -- upvalues: name (val), searchInTable_5 (val)
                                        local v1
                                        for k, v in pairs(a1) do
                                            if k == name then
                                                return v
                                            end
                                            if type(v) == "table" then
                                                v1 = searchInTable_5(v)
                                                if v1 ~= nil then
                                                    return v1
                                                end
                                            end
                                        end
                                        return nil
                                    end

                                    v5 = searchInTable_5(v8)
                                else
                                    v5 = nil
                                end
                            else
                                v5 = nil
                            end
                            if not v5 then
                                v5 = v2.Default
                            end
                            v5 = tonumber(v5) or v2.Default
                            v4 = Number(name, v2, Scroll, v23, v3, v5, u0.SettingChanged, u214)
                        elseif v2.Type == "Slider" then
                            assert(u215.SliderTemplate, "SliderTemplate not loaded")
                            v3 = u215.SliderTemplate:Clone()
                            v6 = nil
                            if not v2.HasEnabledToggle then
                                v8 = u214
                                if u205 then
                                    v9 = u191[v8]
                                    v9 = u205[v9 or v8]
                                    if v9 then
                                        local function searchInTable_7(a1) -- Line: 394
                                            -- upvalues: name (val), searchInTable_7 (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == name then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable_7(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v7 = searchInTable_7(v9)
                                    else
                                        v7 = nil
                                    end
                                else
                                    v7 = nil
                                end
                                if not v7 then
                                    v7 = v2.Default
                                end
                                v7 = tonumber(v7) or v2.Default
                                v5 = v7
                            else
                                v8 = u214
                                if u205 then
                                    v9 = u191[v8]
                                    v9 = u205[v9 or v8]
                                    if v9 then
                                        local function searchInTable_6(a1) -- Line: 394
                                            -- upvalues: name (val), searchInTable_6 (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == name then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable_6(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v7 = searchInTable_6(v9)
                                    else
                                        v7 = nil
                                    end
                                else
                                    v7 = nil
                                end
                                if type(v7) ~= "table" then
                                    v5 = tonumber(v7) or v2.Default
                                    v6 = if v2.DefaultEnabled == nil then true else v2.DefaultEnabled
                                else
                                    v5 = tonumber(v7.Value) or v2.Default
                                    v6 = v7.Enabled
                                    if v6 == nil then
                                        v6 = if v2.DefaultEnabled == nil then true else v2.DefaultEnabled
                                    end
                                end
                            end
                            v4 = Slider(name, v2, Scroll, v23, v3, v5, v6, u0.SettingChanged, u214)
                        elseif v2.Type == "Dropdown" then
                            assert(u215.DropdownTemplate, "DropdownTemplate not loaded")
                            v3 = u215.DropdownTemplate:Clone()
                            v6 = u214
                            if u205 then
                                v8 = u191[v6]
                                v8 = u205[v8 or v6]
                                if v8 then
                                    local function searchInTable_8(a1) -- Line: 394
                                        -- upvalues: name (val), searchInTable_8 (val)
                                        local v1
                                        for k, v in pairs(a1) do
                                            if k == name then
                                                return v
                                            end
                                            if type(v) == "table" then
                                                v1 = searchInTable_8(v)
                                                if v1 ~= nil then
                                                    return v1
                                                end
                                            end
                                        end
                                        return nil
                                    end

                                    v5 = searchInTable_8(v8)
                                else
                                    v5 = nil
                                end
                            else
                                v5 = nil
                            end
                            if not v5 then
                                v5 = v2.Default
                            end
                            v4 = Dropdown(name, v2, Scroll, v23, v3, v5, u0.SettingChanged, u214, Settings, function() -- Line: 1684 -- upvalues: u210 (upval)
                                return u210
                            end, function(a1) -- Line: 1687 -- upvalues: u210 (upval) -- types: a1: userdata?
                                u210 = a1
                            end)
                        elseif v2.Type == "Keybind" then
                            assert(u215.KeybindTemplate, "KeybindTemplate not loaded")
                            v3 = u215.KeybindTemplate:Clone()
                            v6 = u214
                            if u205 then
                                v8 = u191[v6]
                                v8 = u205[v8 or v6]
                                if v8 then
                                    local function searchInTable_9(a1) -- Line: 394
                                        -- upvalues: name (val), searchInTable_9 (val)
                                        local v1
                                        for k, v in pairs(a1) do
                                            if k == name then
                                                return v
                                            end
                                            if type(v) == "table" then
                                                v1 = searchInTable_9(v)
                                                if v1 ~= nil then
                                                    return v1
                                                end
                                            end
                                        end
                                        return nil
                                    end

                                    v5 = searchInTable_9(v8)
                                else
                                    v5 = nil
                                end
                            else
                                v5 = nil
                            end
                            if not v5 then
                                v5 = {}
                            end
                            if type(v5) == "table" then
                                for i4, i7 in ipairs({"Computer", "Console"}) do
                                    v10 = v5[i7]
                                    if v10 and v10 ~= "" then
                                        if v10 == "" then
                                            v11 = nil
                                        elseif v10 ~= "None" then
                                            v13 = u204[(("%*:%*"):format(i7, v10))]
                                            v11 = if not v13 then nil else if v13 == name then nil else v13
                                        else
                                            v11 = nil
                                        end
                                        if v11 then
                                            v12 = u196 or {}
                                            u196 = v12
                                            v13 = v12[i7] or {}
                                            v12[i7] = v13
                                            table.insert(v12[i7], {action = name, keybind = v10})
                                            table.insert(v12[i7], {action = v11, keybind = v10})
                                        end
                                        if v10 ~= "" and v10 ~= "None" then
                                            u204[(("%*:%*"):format(i7, v10))] = name
                                        end
                                    end
                                end
                            end
                            local u2032 = v3
                            v14 = u214
                            v4 = Keybind(name, v2, Scroll, v23, v3, v5, function(a1, a2, a3) -- Line: 1728
                                -- upvalues: u205 (upval), u191 (upval), u2032 (val), BindDisplay (upval), u0 (upval)
                                local Right, v1, v2, v3, v4, v5, v6
                                if u205 then
                                    v6 = u191[a1]
                                    v6 = u205[v6 or a1]
                                    if v6 then
                                        local searchInTable

                                        function searchInTable(a1) -- Line: 394
                                            -- upvalues: a2 (val), searchInTable (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == a2 then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v5 = searchInTable(v6)
                                    else
                                        v5 = nil
                                    end
                                else
                                    v5 = nil
                                end
                                local v7 = {}
                                v6 = ipairs
                                local v8, v9 = a1, a3
                                for i, v in v6({"Computer", "Console"}) do
                                    Right = u2032:FindFirstChild("Right")
                                    if not Right then
                                        v1 = nil
                                    elseif Right:IsA("Frame") then
                                        v4 = Right:FindFirstChild(v)
                                        v1 = if not v4 then nil else if not v4:IsA("GuiObject") then nil else v4
                                    else
                                        v1 = nil
                                    end
                                    v2 = if not v1 then nil else BindDisplay.GetReset(v1)
                                    v3 = if type(v5) ~= "table" then nil else v5[v]
                                    if v9[v] ~= "" or not v2 then
                                        if v3 == nil then
                                            v7[v] = v9[v]
                                        else
                                            v7[v] = v3
                                        end
                                    elseif not v2.Visible then
                                        v7[v] = ""
                                    elseif v3 == nil then
                                        v7[v] = v9[v]
                                    else
                                        v7[v] = v3
                                    end
                                end
                                u0.SettingChanged(v8, a2, v7)
                            end, v14, function(a1, a2, a3) -- Line: 1756
                                -- upvalues: GetKeybindPlatformFromTextBox (upval), u214 (upval), name (val)
                                -- upvalues: u205 (upval), u191 (upval), u211 (upval), u208 (upval), u212 (upval)
                                -- upvalues: u153 (upval), BindDisplay (upval), Scroll (val), UserInputService (upval)
                                -- upvalues: u213 (upval), GuiService (upval), CancelKeybindListening (upval)
                                local v1
                                local v2 = GetKeybindPlatformFromTextBox(a1)
                                local v3 = u214
                                local u7 = name
                                if u205 then
                                    local v4 = u191[v3]
                                    v4 = u205[v4 or v3]
                                    if v4 then
                                        local searchInTable

                                        function searchInTable(a1) -- Line: 394
                                            -- upvalues: u7 (val), searchInTable (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == u7 then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v1 = searchInTable(v4)
                                    else
                                        v1 = nil
                                    end
                                else
                                    v1 = nil
                                end
                                v3 = if not v2 then nil else if type(v1) ~= "table" then nil else v1[v2.Name]
                                u211 = a1
                                u208 = if type(v3) ~= "string" then a2 else v3
                                u212 = a3
                                a1.Text = "Press a key..."
                                if a1:GetAttribute("DefaultTextColor") == nil then
                                    a1:SetAttribute("DefaultTextColor", a1.TextColor3)
                                end
                                a1.TextColor3 = u153
                                if v2 then
                                    BindDisplay.HideIcon(v2)
                                end
                                Scroll.ScrollingEnabled = false
                                if not string.match(UserInputService:GetLastInputType().Name, "^Gamepad%d+$") then
                                    a1.FocusLost:Once(function() -- Line: 1798 -- upvalues: u211 (upval), a1 (val), CancelKeybindListening (upval)
                                        task.defer(function() -- Line: 1799 -- upvalues: u211 (upval), a1 (upval), CancelKeybindListening (upval)
                                            if u211 == a1 then
                                                CancelKeybindListening()
                                            end
                                        end)
                                    end)
                                    return
                                end
                                u213 = GuiService.SelectedObject
                                GuiService.SelectedObject = nil
                                a1:ReleaseFocus()
                            end, NOOP)
                        end
                        if v3 then
                            u201[a1][name] = v3
                            v23 = v23 + 1
                        end
                        if v4 then
                            u203[a1]:Add(v4, true, (("Template_%*"):format(name)))
                        end
                        v6 = Settings:WaitForChild("Divider"):Clone()
                        v6.LayoutOrder = v23
                        v6.Parent = Scroll
                        v23 = v23 + 1
                    elseif u215.CrosshairPreviewTemplate then
                        v3 = u215.CrosshairPreviewTemplate:Clone()
                        v4 = CrosshairPreview(Scroll, v23, v3, u209.Share, function() -- Line: 1576 -- upvalues: u205 (upval)
                            return u205 and u205.Game and u205.Game.Crosshair
                        end, NOOP, NOOP, NOOP)
                        if v3 then
                            u201[a1][name] = v3
                            v23 = v23 + 1
                        end
                        if v4 then
                            u203[a1]:Add(v4, true, (("Template_%*"):format(name)))
                        end
                        v6 = Settings:WaitForChild("Divider"):Clone()
                        v6.LayoutOrder = v23
                        v6.Parent = Scroll
                        v23 = v23 + 1
                    else
                        warn("[Settings] CrosshairPreviewTemplate not loaded")
                    end
                else
                    v6 = table.find(GetUserPlatform(), v2.Platform) ~= nil
                    if v6 then
                        v5 = ("Settings.%*.%*.%*"):format(u191[a1] or a1, v, name)
                        v7 = {pageName = a1, categoryName = v, settingName = name, settingPath = v5}
                        u202[name] = v7
                        if v2.Type ~= "CrosshairPreview" then
                            if v2.Type == "Toggle" then
                                assert(u215.ToggleTemplate, "ToggleTemplate not loaded")
                                v3 = u215.ToggleTemplate:Clone()
                                v6 = u214
                                if u205 then
                                    v8 = u191[v6]
                                    v8 = u205[v8 or v6]
                                    if v8 then
                                        local function searchInTable_4(a1) -- Line: 394
                                            -- upvalues: name (val), searchInTable_4 (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == name then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable_4(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v5 = searchInTable_4(v8)
                                    else
                                        v5 = nil
                                    end
                                else
                                    v5 = nil
                                end
                                if v5 == nil then
                                    v5 = v2.Default
                                end
                                v4 = Toggle(name, v2, Scroll, v23, v3, v5, u0.SettingChanged, u214)
                            elseif v2.Type == "Number" then
                                assert(u215.NumberTemplate, "NumberTemplate not loaded")
                                v3 = u215.NumberTemplate:Clone()
                                v6 = u214
                                if u205 then
                                    v8 = u191[v6]
                                    v8 = u205[v8 or v6]
                                    if v8 then
                                        local function searchInTable_5(a1) -- Line: 394
                                            -- upvalues: name (val), searchInTable_5 (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == name then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable_5(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v5 = searchInTable_5(v8)
                                    else
                                        v5 = nil
                                    end
                                else
                                    v5 = nil
                                end
                                if not v5 then
                                    v5 = v2.Default
                                end
                                v5 = tonumber(v5) or v2.Default
                                v4 = Number(name, v2, Scroll, v23, v3, v5, u0.SettingChanged, u214)
                            elseif v2.Type == "Slider" then
                                assert(u215.SliderTemplate, "SliderTemplate not loaded")
                                v3 = u215.SliderTemplate:Clone()
                                v6 = nil
                                if not v2.HasEnabledToggle then
                                    v8 = u214
                                    if u205 then
                                        v9 = u191[v8]
                                        v9 = u205[v9 or v8]
                                        if v9 then
                                            local function searchInTable_7(a1) -- Line: 394
                                                -- upvalues: name (val), searchInTable_7 (val)
                                                local v1
                                                for k, v in pairs(a1) do
                                                    if k == name then
                                                        return v
                                                    end
                                                    if type(v) == "table" then
                                                        v1 = searchInTable_7(v)
                                                        if v1 ~= nil then
                                                            return v1
                                                        end
                                                    end
                                                end
                                                return nil
                                            end

                                            v7 = searchInTable_7(v9)
                                        else
                                            v7 = nil
                                        end
                                    else
                                        v7 = nil
                                    end
                                    if not v7 then
                                        v7 = v2.Default
                                    end
                                    v7 = tonumber(v7) or v2.Default
                                    v5 = v7
                                else
                                    v8 = u214
                                    if u205 then
                                        v9 = u191[v8]
                                        v9 = u205[v9 or v8]
                                        if v9 then
                                            local function searchInTable_6(a1) -- Line: 394
                                                -- upvalues: name (val), searchInTable_6 (val)
                                                local v1
                                                for k, v in pairs(a1) do
                                                    if k == name then
                                                        return v
                                                    end
                                                    if type(v) == "table" then
                                                        v1 = searchInTable_6(v)
                                                        if v1 ~= nil then
                                                            return v1
                                                        end
                                                    end
                                                end
                                                return nil
                                            end

                                            v7 = searchInTable_6(v9)
                                        else
                                            v7 = nil
                                        end
                                    else
                                        v7 = nil
                                    end
                                    if type(v7) ~= "table" then
                                        v5 = tonumber(v7) or v2.Default
                                        v6 = if v2.DefaultEnabled == nil then true else v2.DefaultEnabled
                                    else
                                        v5 = tonumber(v7.Value) or v2.Default
                                        v6 = v7.Enabled
                                        if v6 == nil then
                                            v6 = if v2.DefaultEnabled == nil then true else v2.DefaultEnabled
                                        end
                                    end
                                end
                                v4 = Slider(name, v2, Scroll, v23, v3, v5, v6, u0.SettingChanged, u214)
                            elseif v2.Type == "Dropdown" then
                                assert(u215.DropdownTemplate, "DropdownTemplate not loaded")
                                v3 = u215.DropdownTemplate:Clone()
                                v6 = u214
                                if u205 then
                                    v8 = u191[v6]
                                    v8 = u205[v8 or v6]
                                    if v8 then
                                        local function searchInTable_8(a1) -- Line: 394
                                            -- upvalues: name (val), searchInTable_8 (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == name then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable_8(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v5 = searchInTable_8(v8)
                                    else
                                        v5 = nil
                                    end
                                else
                                    v5 = nil
                                end
                                if not v5 then
                                    v5 = v2.Default
                                end
                                v4 = Dropdown(name, v2, Scroll, v23, v3, v5, u0.SettingChanged, u214, Settings, function() -- Line: 1684 -- upvalues: u210 (upval)
                                    return u210
                                end, function(a1) -- Line: 1687 -- upvalues: u210 (upval) -- types: a1: userdata?
                                    u210 = a1
                                end)
                            elseif v2.Type == "Keybind" then
                                assert(u215.KeybindTemplate, "KeybindTemplate not loaded")
                                v3 = u215.KeybindTemplate:Clone()
                                v6 = u214
                                if u205 then
                                    v8 = u191[v6]
                                    v8 = u205[v8 or v6]
                                    if v8 then
                                        local function searchInTable_9(a1) -- Line: 394
                                            -- upvalues: name (val), searchInTable_9 (val)
                                            local v1
                                            for k, v in pairs(a1) do
                                                if k == name then
                                                    return v
                                                end
                                                if type(v) == "table" then
                                                    v1 = searchInTable_9(v)
                                                    if v1 ~= nil then
                                                        return v1
                                                    end
                                                end
                                            end
                                            return nil
                                        end

                                        v5 = searchInTable_9(v8)
                                    else
                                        v5 = nil
                                    end
                                else
                                    v5 = nil
                                end
                                if not v5 then
                                    v5 = {}
                                end
                                if type(v5) == "table" then
                                    for i8, i82 in ipairs({"Computer", "Console"}) do
                                        v10 = v5[i82]
                                        if v10 and v10 ~= "" then
                                            if v10 == "" then
                                                v11 = nil
                                            elseif v10 ~= "None" then
                                                v13 = u204[(("%*:%*"):format(i82, v10))]
                                                v11 = if not v13 then nil else if v13 == name then nil else v13
                                            else
                                                v11 = nil
                                            end
                                            if v11 then
                                                v12 = u196 or {}
                                                u196 = v12
                                                v13 = v12[i82] or {}
                                                v12[i82] = v13
                                                table.insert(v12[i82], {action = name, keybind = v10})
                                                table.insert(v12[i82], {action = v11, keybind = v10})
                                            end
                                            if v10 ~= "" and v10 ~= "None" then
                                                u204[(("%*:%*"):format(i82, v10))] = name
                                            end
                                        end
                                    end
                                end
                                local u2032 = v3
                                v14 = u214
                                v4 = Keybind(name, v2, Scroll, v23, v3, v5, function(a1, a2, a3) -- Line: 1728
                                    -- upvalues: u205 (upval), u191 (upval), u2032 (val), BindDisplay (upval)
                                    -- upvalues: u0 (upval)
                                    local Right, v1, v2, v3, v4, v5, v6
                                    if u205 then
                                        v6 = u191[a1]
                                        v6 = u205[v6 or a1]
                                        if v6 then
                                            local searchInTable

                                            function searchInTable(a1) -- Line: 394
                                                -- upvalues: a2 (val), searchInTable (val)
                                                local v1
                                                for k, v in pairs(a1) do
                                                    if k == a2 then
                                                        return v
                                                    end
                                                    if type(v) == "table" then
                                                        v1 = searchInTable(v)
                                                        if v1 ~= nil then
                                                            return v1
                                                        end
                                                    end
                                                end
                                                return nil
                                            end

                                            v5 = searchInTable(v6)
                                        else
                                            v5 = nil
                                        end
                                    else
                                        v5 = nil
                                    end
                                    local v7 = {}
                                    v6 = ipairs
                                    local v8, v9 = a1, a3
                                    for i, v in v6({"Computer", "Console"}) do
                                        Right = u2032:FindFirstChild("Right")
                                        if not Right then
                                            v1 = nil
                                        elseif Right:IsA("Frame") then
                                            v4 = Right:FindFirstChild(v)
                                            v1 = if not v4 then nil else if not v4:IsA("GuiObject") then nil else v4
                                        else
                                            v1 = nil
                                        end
                                        v2 = if not v1 then nil else BindDisplay.GetReset(v1)
                                        v3 = if type(v5) ~= "table" then nil else v5[v]
                                        if v9[v] ~= "" or not v2 then
                                            if v3 == nil then
                                                v7[v] = v9[v]
                                            else
                                                v7[v] = v3
                                            end
                                        elseif not v2.Visible then
                                            v7[v] = ""
                                        elseif v3 == nil then
                                            v7[v] = v9[v]
                                        else
                                            v7[v] = v3
                                        end
                                    end
                                    u0.SettingChanged(v8, a2, v7)
                                end, v14, function(a1, a2, a3) -- Line: 1756
                                    -- upvalues: GetKeybindPlatformFromTextBox (upval), u214 (upval), name (val)
                                    -- upvalues: u205 (upval), u191 (upval), u211 (upval), u208 (upval), u212 (upval)
                                    -- upvalues: u153 (upval), BindDisplay (upval), Scroll (val)
                                    -- upvalues: UserInputService (upval), u213 (upval), GuiService (upval)
                                    -- upvalues: CancelKeybindListening (upval)
                                    local v1
                                    local v2 = GetKeybindPlatformFromTextBox(a1)
                                    local v3 = u214
                                    local u7 = name
                                    if u205 then
                                        local v4 = u191[v3]
                                        v4 = u205[v4 or v3]
                                        if v4 then
                                            local searchInTable

                                            function searchInTable(a1) -- Line: 394
                                                -- upvalues: u7 (val), searchInTable (val)
                                                local v1
                                                for k, v in pairs(a1) do
                                                    if k == u7 then
                                                        return v
                                                    end
                                                    if type(v) == "table" then
                                                        v1 = searchInTable(v)
                                                        if v1 ~= nil then
                                                            return v1
                                                        end
                                                    end
                                                end
                                                return nil
                                            end

                                            v1 = searchInTable(v4)
                                        else
                                            v1 = nil
                                        end
                                    else
                                        v1 = nil
                                    end
                                    v3 = if not v2 then nil else if type(v1) ~= "table" then nil else v1[v2.Name]
                                    u211 = a1
                                    u208 = if type(v3) ~= "string" then a2 else v3
                                    u212 = a3
                                    a1.Text = "Press a key..."
                                    if a1:GetAttribute("DefaultTextColor") == nil then
                                        a1:SetAttribute("DefaultTextColor", a1.TextColor3)
                                    end
                                    a1.TextColor3 = u153
                                    if v2 then
                                        BindDisplay.HideIcon(v2)
                                    end
                                    Scroll.ScrollingEnabled = false
                                    if not string.match(UserInputService:GetLastInputType().Name, "^Gamepad%d+$") then
                                        a1.FocusLost:Once(function() -- Line: 1798 -- upvalues: u211 (upval), a1 (val), CancelKeybindListening (upval)
                                            task.defer(function() -- Line: 1799 -- upvalues: u211 (upval), a1 (upval), CancelKeybindListening (upval)
                                                if u211 == a1 then
                                                    CancelKeybindListening()
                                                end
                                            end)
                                        end)
                                        return
                                    end
                                    u213 = GuiService.SelectedObject
                                    GuiService.SelectedObject = nil
                                    a1:ReleaseFocus()
                                end, NOOP)
                            end
                            if v3 then
                                u201[a1][name] = v3
                                v23 = v23 + 1
                            end
                            if v4 then
                                u203[a1]:Add(v4, true, (("Template_%*"):format(name)))
                            end
                            v6 = Settings:WaitForChild("Divider"):Clone()
                            v6.LayoutOrder = v23
                            v6.Parent = Scroll
                            v23 = v23 + 1
                        elseif u215.CrosshairPreviewTemplate then
                            v3 = u215.CrosshairPreviewTemplate:Clone()
                            v4 = CrosshairPreview(Scroll, v23, v3, u209.Share, function() -- Line: 1576 -- upvalues: u205 (upval)
                                return u205 and u205.Game and u205.Game.Crosshair
                            end, NOOP, NOOP, NOOP)
                            if v3 then
                                u201[a1][name] = v3
                                v23 = v23 + 1
                            end
                            if v4 then
                                u203[a1]:Add(v4, true, (("Template_%*"):format(name)))
                            end
                            v6 = Settings:WaitForChild("Divider"):Clone()
                            v6.LayoutOrder = v23
                            v6.Parent = Scroll
                            v23 = v23 + 1
                        else
                            warn("[Settings] CrosshairPreviewTemplate not loaded")
                        end
                    end
                end
            else
                u2716.LayoutOrder = v23
                v23 = v23 + 1
            end
        end
    end
    local UIListLayout = Scroll:FindFirstChildOfClass("UIListLayout")
    if UIListLayout then
        Scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 50)
    end
    RestoreSelectedControl(Scroll, v21)
    if a1 == "Keybinds" and u196 then
        Profiler.defer("UI.Settings.HighlightDuplicateKeybindsDeferred", function() -- Line: 1835 -- upvalues: u196 (upval), u201 (upval), BindDisplay (upval)
            local Right, action_2, v1, v2, v3, v4, v5
            local v6 = {}
            for k, v in pairs(u196) do
                for i, i2 in ipairs(v) do
                    v1 = ("%*:%*"):format(i2.action, k)
                    if not v6[v1] then
                        action_2 = i2.action
                        if not u201.Keybinds then
                            v2 = nil
                            v3 = nil
                        elseif u201.Keybinds[action_2] then
                            Right = u201.Keybinds[action_2]:FindFirstChild("Right")
                            if not Right then
                                v4 = nil
                            elseif Right:IsA("Frame") then
                                v5 = Right:FindFirstChild(k)
                                v4 = if not v5 then nil else if not v5:IsA("GuiObject") then nil else v5
                            else
                                v4 = nil
                            end
                            if v4 then
                                v2 = v4
                                v3 = BindDisplay.GetTextBox(v4)
                            else
                                v2 = nil
                                v3 = nil
                            end
                        else
                            v2 = nil
                            v3 = nil
                        end
                        if v3 then
                            if v3:GetAttribute("DefaultTextColor") == nil then
                                v3:SetAttribute("DefaultTextColor", v3.TextColor3)
                            end
                            v3.TextColor3 = Color3.fromRGB(255, 90, 90)
                            BindDisplay.SetConflict(v2, true)
                        end
                        v6[v1] = true
                    end
                end
            end
            u196 = nil
        end)
    end
end

local function UpdateTabHighlight(a1, a2) -- Line: 1856
    -- upvalues: u153 (val), u148 (val), u164 (val)
    a1:SetAttribute("Selected", if not a2 then nil else true)
    local Selected = a1:FindFirstChild("Selected")
    if Selected and Selected:IsA("GuiObject") then
        Selected.Visible = a2
        a1.BackgroundColor3 = if not a2 then u148 else u153
        return
    end
    local v1 = if not a2 then u164 else u153
    local Title = a1:FindFirstChild("Title", true)
    if Title and Title:IsA("TextLabel") then
        Title.TextColor3 = v1
    end
    local Icon = a1:FindFirstChild("Icon", true)
    if Icon and Icon:IsA("ImageLabel") then
        Icon.ImageColor3 = v1
    end
    local UIStroke = a1:FindFirstChildOfClass("UIStroke")
    if UIStroke then
        UIStroke.Color = v1
    end
end

local function GetSidebarColumn() -- Line: 1885 -- upvalues: u209 (ref)
    local Categories = u209.Frame:FindFirstChild("Categories")
    if Categories and Categories:IsA("GuiObject") then
        return Categories
    end
    return nil
end

local function GetTabContainers() -- Line: 1891 -- upvalues: u209 (ref)
    return {u209.Top.Categories}
end

function u0.Open(a1) -- Line: 1903
    -- upvalues: Profiler (val), u214 (ref), u209 (ref), u201 (val), u0 (val), UpdateTabHighlight (val)
    local v1
    Profiler.mark("UI.Settings.Open")
    u214 = a1
    for i, v in ipairs(u209.Frame.List:GetChildren()) do
        if v:IsA("Frame") then
            v.Visible = false
        end
    end
    local v2 = u209.Frame.List:FindFirstChild(a1)
    if v2 then
        v2.Visible = true
        if not u201[a1] then
            u0.RenderPage(a1)
        end
    end
    for i2, i3 in ipairs({u209.Top.Categories}) do
        for i4, j in ipairs(i3:GetChildren()) do
            if j:IsA("ImageButton") then
                v1 = j.Name == a1
                UpdateTabHighlight(j, v1)
            end
        end
    end
end

function u0.SettingChanged(a1, a2, a3, a4, a5) -- Line: 1936
    -- upvalues: Profiler (val), u205 (ref), u202 (val), Pages (val), u191 (val), ReplicatedStorage (val), u154 (val)
    -- upvalues: Router (val), u214 (ref), u201 (val), u0 (val), DeepEqual (val), u204 (val), u200 (ref)
    -- upvalues: ClearKeybindHighlight (val), AddToHistory (val), u206 (val), DeepCopy (val), u207 (ref)
    -- upvalues: ResolveSettingPath (val), Remotes (val), u199 (ref), u198 (ref), u197 (val)
    local Video, searchInTable, searchInTable_2, settingPath, u82, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
    Profiler.mark("UI.Settings.SettingChanged")
    if not u205 then
        warn("[Settings] CurrentSettings is nil")
        return
    end
    local v13 = u202[a2]
    if v13 then
        settingPath = v13.settingPath
        if settingPath == "Settings.Audio.Music.Bomb/Hostage Volume" then
            require(ReplicatedStorage.Controllers.SoundController).SetBombPlantedMusicVolume(a3)
        elseif settingPath == "Settings.Video.Advanced.Aspect Ratio" then
            require(ReplicatedStorage.Controllers.CameraController).SetAspectRatio(a3)
        end
        if a4 then
            return
        end
        if a1 == "Video" and a3 == true and table.find(u154, a2) then
            if u205 then
                Video = u191.Video
                v12 = u205[Video or "Video"]
                if v12 then
                    u82 = "Potato Mode"

                    function searchInTable(a1) -- Line: 394 -- upvalues: u82 (val), searchInTable (val)
                        local v1
                        for k, v in pairs(a1) do
                            if k == u82 then
                                return v
                            end
                            if type(v) == "table" then
                                v1 = searchInTable(v)
                                if v1 ~= nil then
                                    return v1
                                end
                            end
                        end
                        return nil
                    end

                    v11 = searchInTable(v12)
                else
                    v11 = nil
                end
            else
                v11 = nil
            end
            if v11 == true then
                Router.broadcastRouter("CreateMenuNotification", "Error", "You can't turn this on while Potato Mode is enabled")
                if u214 == "Video" and u201[u214] then
                    task.defer(u0.RenderPage, u214)
                end
                return
            end
        end
        if u205 then
            v12 = u191[a1]
            v12 = u205[v12 or a1]
            if v12 then
                function searchInTable_2(a1) -- Line: 394 -- upvalues: a2 (val), searchInTable_2 (val)
                    local v1
                    for k, v in pairs(a1) do
                        if k == a2 then
                            return v
                        end
                        if type(v) == "table" then
                            v1 = searchInTable_2(v)
                            if v1 ~= nil then
                                return v1
                            end
                        end
                    end
                    return nil
                end

                v11 = searchInTable_2(v12)
            else
                v11 = nil
            end
        else
            v11 = nil
        end
        if DeepEqual(v11, a3) and not a5 then
            return
        end
        v12 = u205
        v2 = u191[a1] or a1
        if not v12[v2] then
            v12[v2] = {}
        end
        v12 = v12[v2]
        v3 = v13
        if not v12[v3.categoryName] then
            v12[v3.categoryName] = {}
        end
        v12[v3.categoryName][a2] = a3
        if a1 ~= "Keybinds" or type(v11) ~= "table" or type(a3) ~= "table" then
            v1 = a1
        else
            v4 = ipairs
            v9, v1 = a3, a1
            for i5, k in v4({"Computer", "Console"}) do
                v6 = v11[k]
                v7 = false
                if type(v6) == "string" then
                    v7 = v6 ~= v9[k]
                end
                if v7 and u204[("%*:%*"):format(k, v6)] == a2 and v6 ~= "" and v6 ~= "None" then
                    u204[(("%*:%*"):format(k, v6))] = nil
                end
            end
        end
        if v1 == "Keybinds" then
            v4 = u205[v2]
            if v4 then
                require(ReplicatedStorage.Controllers.InputController).loadActionsFromDatabase(v4)
            end
        end
        if v1 == "Keybinds" and type(v9) == "table" then
            for i6, n in ipairs({"Computer", "Console"}) do
                v6 = v9[n]
                v8 = v6 and v6 ~= ""
                v7 = not v8
                if not v7 then
                    if v6 == "" then
                        v8 = nil
                    elseif v6 ~= "None" then
                        v10 = u204[(("%*:%*"):format(n, v6))]
                        v8 = if not v10 then nil else if v10 == a2 then nil else v10
                    else
                        v8 = nil
                    end
                    v7 = not v8
                end
                if v7 and n ~= u200 then
                    Profiler.defer("UI.Settings.ClearKeybindHighlightDeferred", ClearKeybindHighlight, a2, n)
                end
            end
        end
        AddToHistory(settingPath, v11, v9)
        v4 = u206
        v5 = {Value = DeepCopy(v9), SentAt = os.clock()}
        v4[settingPath] = v5
        if u207 then
            v4, v5 = ResolveSettingPath(u207, settingPath)
            v4[v5] = (DeepCopy(v9))
        end
        Remotes.Player.UpdatePlayerSettings.Send({Value = v9, Path = settingPath})
        if v1 == "Video" and a2 == "Potato Mode" and v9 == true and v11 ~= true then
            u199 = u199 + 1
            u198 = u199
            v4 = u197[#u197]
            v4.batch = u198
            for i7, m in ipairs(u154) do
                u0.SettingChanged("Video", m, false)
            end
            u198 = nil
            if u214 == "Video" and u201[u214] then
                u0.RenderPage(u214)
            end
        end
        if v1 == "Video" and a2 == "Potato Mode" and v9 == false and v11 == true then
            Router.broadcastRouter(
                "CreateMenuNotification",
                "Error",
                "Potato mode has been disabled. Please rejoin for this change to take effect"
            )
        end
        return
    end
    local v14 = Pages.GetSetting(a1, a2)
    if v14 and v14.Category then
        v11 = {
            pageName = a1,
            categoryName = v14.Category,
            settingName = a2,
            settingPath = ("Settings.%*.%*.%*"):format(u191[a1] or a1, v14.Category, a2),
        }
        settingPath = v11.settingPath
        if settingPath == "Settings.Audio.Music.Bomb/Hostage Volume" then
            require(ReplicatedStorage.Controllers.SoundController).SetBombPlantedMusicVolume(a3)
        elseif settingPath == "Settings.Video.Advanced.Aspect Ratio" then
            require(ReplicatedStorage.Controllers.CameraController).SetAspectRatio(a3)
        end
        if a4 then
            return
        end
        if a1 == "Video" and a3 == true and table.find(u154, a2) then
            if u205 then
                Video = u191.Video
                v12 = u205[Video or "Video"]
                if v12 then
                    u82 = "Potato Mode"

                    function searchInTable(a1) -- Line: 394 -- upvalues: u82 (val), searchInTable (val)
                        local v1
                        for k, v in pairs(a1) do
                            if k == u82 then
                                return v
                            end
                            if type(v) == "table" then
                                v1 = searchInTable(v)
                                if v1 ~= nil then
                                    return v1
                                end
                            end
                        end
                        return nil
                    end

                    v11 = searchInTable(v12)
                else
                    v11 = nil
                end
            else
                v11 = nil
            end
            if v11 == true then
                Router.broadcastRouter("CreateMenuNotification", "Error", "You can't turn this on while Potato Mode is enabled")
                if u214 == "Video" and u201[u214] then
                    task.defer(u0.RenderPage, u214)
                end
                return
            end
        end
        if u205 then
            v12 = u191[a1]
            v12 = u205[v12 or a1]
            if v12 then
                function searchInTable_2(a1) -- Line: 394 -- upvalues: a2 (val), searchInTable_2 (val)
                    local v1
                    for k, v in pairs(a1) do
                        if k == a2 then
                            return v
                        end
                        if type(v) == "table" then
                            v1 = searchInTable_2(v)
                            if v1 ~= nil then
                                return v1
                            end
                        end
                    end
                    return nil
                end

                v11 = searchInTable_2(v12)
            else
                v11 = nil
            end
        else
            v11 = nil
        end
        if DeepEqual(v11, a3) and not a5 then
            return
        end
        v12 = u205
        v2 = u191[a1] or a1
        if not v12[v2] then
            v12[v2] = {}
        end
        v12 = v12[v2]
        v3 = v13
        if not v12[v3.categoryName] then
            v12[v3.categoryName] = {}
        end
        v12[v3.categoryName][a2] = a3
        if a1 ~= "Keybinds" or type(v11) ~= "table" or type(a3) ~= "table" then
            v1 = a1
        else
            v4 = ipairs
            v9, v1 = a3, a1
            for i, v in v4({"Computer", "Console"}) do
                v6 = v11[v]
                v7 = false
                if type(v6) == "string" then
                    v7 = v6 ~= v9[v]
                end
                if v7 and u204[("%*:%*"):format(v, v6)] == a2 and v6 ~= "" and v6 ~= "None" then
                    u204[(("%*:%*"):format(v, v6))] = nil
                end
            end
        end
        if v1 == "Keybinds" then
            v4 = u205[v2]
            if v4 then
                require(ReplicatedStorage.Controllers.InputController).loadActionsFromDatabase(v4)
            end
        end
        if v1 == "Keybinds" and type(v9) == "table" then
            for i2, i3 in ipairs({"Computer", "Console"}) do
                v6 = v9[i3]
                v8 = v6 and v6 ~= ""
                v7 = not v8
                if not v7 then
                    if v6 == "" then
                        v8 = nil
                    elseif v6 ~= "None" then
                        v10 = u204[(("%*:%*"):format(i3, v6))]
                        v8 = if not v10 then nil else if v10 == a2 then nil else v10
                    else
                        v8 = nil
                    end
                    v7 = not v8
                end
                if v7 and i3 ~= u200 then
                    Profiler.defer("UI.Settings.ClearKeybindHighlightDeferred", ClearKeybindHighlight, a2, i3)
                end
            end
        end
        AddToHistory(settingPath, v11, v9)
        v4 = u206
        v5 = {Value = DeepCopy(v9), SentAt = os.clock()}
        v4[settingPath] = v5
        if u207 then
            v4, v5 = ResolveSettingPath(u207, settingPath)
            v4[v5] = (DeepCopy(v9))
        end
        Remotes.Player.UpdatePlayerSettings.Send({Value = v9, Path = settingPath})
        if v1 == "Video" and a2 == "Potato Mode" and v9 == true and v11 ~= true then
            u199 = u199 + 1
            u198 = u199
            v4 = u197[#u197]
            v4.batch = u198
            for i4, j in ipairs(u154) do
                u0.SettingChanged("Video", j, false)
            end
            u198 = nil
            if u214 == "Video" and u201[u214] then
                u0.RenderPage(u214)
            end
        end
        if v1 == "Video" and a2 == "Potato Mode" and v9 == false and v11 == true then
            Router.broadcastRouter(
                "CreateMenuNotification",
                "Error",
                "Potato mode has been disabled. Please rejoin for this change to take effect"
            )
        end
        return
    end
    warn((("[Settings] Could not find metadata or config for setting: %*"):format(a2)))
end

function u0.UpdateSettings(a1) -- Line: 2115
    -- upvalues: Profiler (val), u205 (ref), u206 (val), ResolveSettingPath (val), DeepEqual (val), DeepCopy (val)
    -- upvalues: u207 (ref), u214 (ref), u201 (val), u0 (val)
    local v1, v2
    Profiler.mark("UI.Settings.UpdateSettings")
    u205 = a1
    local v3 = os.clock()
    local v4 = nil
    local v5 = nil
    local v6 = a1
    for i, j in u206, v4, v5 do
        v1, v2 = ResolveSettingPath(v6, i)
        if DeepEqual(v1[v2], j.Value) then
            u206[i] = nil
        elseif not (5 < v3 - j.SentAt) then
            v1[v2] = (DeepCopy(j.Value))
        else
            u206[i] = nil
        end
    end
    if u207 and DeepEqual(v6, u207) then
        return
    end
    u207 = DeepCopy(v6)
    if u214 and u201[u214] then
        u0.RenderPage(u214)
    end
end

function u0.ResetCrosshair() -- Line: 2143 -- upvalues: u0 (val)
    for k, v in pairs({
        ["Crosshair Style"] = "Classic",
        ["Crosshair Image"] = 0,
        ["Follow Recoil"] = true,
        ["Center Dot"] = true,
        ["T Style"] = false,
        Red = 0,
        Green = 255,
        Blue = 0,
        Length = 5,
        Thickness = 1,
        Gap = 0,
        Outline = {Enabled = true, Value = 1},
        Alpha = {Enabled = false, Value = 200},
        ["Friendly Fire Reticle Warning"] = true,
        ["Use Crosshair Color for Scope Dot"] = true,
        ["Show my crosshair when spectating bots"] = false,
        ["Show Player Crosshairs"] = false,
    }) do
        u0.SettingChanged("Game", k, v)
    end
    u0.RenderPage("Game")
end

function u0.ShareCrosshair() -- Line: 2172 -- upvalues: u205 (ref), u209 (ref)
    if u205 and u205.Game and u205.Game.Crosshair then
        local HttpService = game:GetService("HttpService")
        local Crosshair = u205.Game.Crosshair
        local success, result = pcall(function() -- Line: 2182 -- upvalues: HttpService (val), Crosshair (val)
            return HttpService:JSONEncode(Crosshair)
        end)
        if success and result then
            u209.Share.Visible = true
            u209.Share.TextBox.Text = result
            u209.Share.TextBox:CaptureFocus()
            u209.Share.TextBox.CursorPosition = #result + 1
            return
        end
        warn("[Settings] Failed to encode crosshair settings:", result)
        return
    end
    warn("[Settings] No crosshair settings to share")
end

function u0.ImportCrosshair(a1) -- Line: 2197 -- upvalues: u0 (val), u209 (ref) -- types: a1: string
    local HttpService = game:GetService("HttpService")
    local success, result = pcall(function() -- Line: 2200 -- upvalues: HttpService (val), a1 (val)
        return HttpService:JSONDecode(a1)
    end)
    if success and result and type(result) == "table" then
        for k, v in pairs(result) do
            u0.SettingChanged("Game", k, v)
        end
        u0.RenderPage("Game")
        u209.Share.Visible = false
        return
    end
    warn("[Settings] Failed to import crosshair settings - invalid code")
end

function u0.ResetPage(a1) -- Line: 2218 -- upvalues: Pages (val), u0 (val) -- types: a1: string
    local v1 = Pages.GetPage(a1)
    if not v1 then
        warn((("[Settings] Page '%*' not found"):format(a1)))
        return
    end

    local function resetSetting(a1_2, a2) -- Line: 2225 -- upvalues: u0 (upval), a1 (val) -- types: a1_2: string
        if not a1_2:match("^_Divider_") and a2.Default ~= nil then
            local Default = a2.Default
            if a2.HasEnabledToggle then
                Default = {Enabled = a2.DefaultEnabled or false, Value = a2.Default}
            end
            u0.SettingChanged(a1, a1_2, Default)
        end
    end

    local v2 = if a1 ~= "Video" then nil else v1["Potato Mode"]
    if v2 then
        resetSetting("Potato Mode", v2)
    end
    for k, v in pairs(v1) do
        if not v2 or k ~= "Potato Mode" then
            resetSetting(k, v)
        end
    end
    u0.RenderPage(a1)
end

function u0.UndoLastChange() -- Line: 2258
    -- upvalues: u197 (val), Remotes (val), u205 (ref), ReplicatedStorage (val), Router (val), u214 (ref), u0 (val)
    if #u197 == 0 then
        warn("[Settings] No changes to undo")
        return
    end
    local v1 = table.remove(u197)
    if not v1 then
        return
    end

    local function undoChange(a1) -- Line: 2269
        -- upvalues: Remotes (upval), u205 (upval), ReplicatedStorage (upval), Router (upval)
        local Send = Remotes.Player.UpdatePlayerSettings.Send
        local v1 = {Path = a1.path, Value = a1.oldValue}
        Send(v1)
        local v2 = string.split(a1.path, ".")
        if #v2 >= 3 then
            local v3
            v1 = u205
            local v4 = #v2 - 1
            for i = 2, v4 do
                v3 = v2[i]
                if not v1[v3] then
                    return
                end
                v1 = v1[v3]
            end
            v4 = v2[#v2]
            v1[v4] = a1.oldValue
        end
        if a1.path == "Settings.Video.Advanced.Aspect Ratio" then
            require(ReplicatedStorage.Controllers.CameraController).SetAspectRatio(a1.oldValue)
        end
        if a1.path == "Settings.Video.Presets.Potato Mode" and a1.newValue == true and a1.oldValue ~= true then
            Router.broadcastRouter(
                "CreateMenuNotification",
                "Error",
                "Potato mode has been disabled. Please rejoin for this change to take effect"
            )
        end
    end

    undoChange(v1)
    while v1.batch do
        if not (#u197 > 0) or u197[#u197].batch ~= v1.batch then
            break
        end
        undoChange((table.remove(u197)))
    end
    if u214 then
        u0.RenderPage(u214)
    end
end

local function SetupEditMobileTabButton(a1) -- Line: 2318
    -- upvalues: EditMobile (val), UserInputService (val), ActivateButton (val), ReplicatedStorage (val)
    -- upvalues: MenuState (val)
    a1.Visible = EditMobile.ShouldShowEntryButton(nil)
    UserInputService.LastInputTypeChanged:Connect(function(a1_2) -- Line: 2319 -- upvalues: a1 (val), EditMobile (upval)
        a1.Visible = EditMobile.ShouldShowEntryButton(a1_2)
    end)
    ActivateButton(a1)
    a1.MouseButton1Click:Connect(function() -- Line: 2327 -- upvalues: ReplicatedStorage (upval), MenuState (upval), EditMobile (upval)
        require(ReplicatedStorage.Interface.Screens.Menu.Top).openFrame("Dashboard")
        if MenuState.GetCurrentScreen() ~= "Dashboard" then
            return
        end
        EditMobile.Open()
    end)
end

function u0.Initialize(a1, a2) -- Line: 2338
    -- upvalues: Profiler (val), u209 (ref), u215 (val), Settings (val), u165 (val), SetupEditMobileTabButton (val)
    -- upvalues: ActivateButton (val), u0 (val), MenuState (val), u211 (ref), u186 (val), u214 (ref), GuiService (val)
    -- upvalues: UserInputService (val), u212 (ref), u208 (ref), RestoreListeningSelection (val)
    -- upvalues: GetKeybindPlatformFromTextBox (val), CancelKeybindListening (val), CloseButtonRegistry (val)
    -- upvalues: HandleKeybindCapture (val), u210 (ref)
    local v1
    Profiler.mark("UI.Settings.Initialize")
    u209 = a2
    u215.CrosshairPreviewTemplate = Settings:WaitForChild("CrosshairPreviewTemplate")
    u215.ColorPickerTemplate = Settings:WaitForChild("ColorPickerTemplate")
    u215.ChangeColor = Settings:WaitForChild("ChangeColor")
    u215.ToggleTemplate = Settings:WaitForChild("ToggleTemplate")
    u215.DropdownTemplate = Settings:WaitForChild("DropdownTemplate")
    u215.NumberTemplate = Settings:WaitForChild("NumberTemplate")
    u215.SliderTemplate = Settings:WaitForChild("SliderTemplate")
    u215.KeybindTemplate = Settings:WaitForChild("KeybindTemplate")
    local Categories = u209.Frame:FindFirstChild("Categories")
    local v2 = if not Categories then nil else if not Categories:IsA("GuiObject") then nil else Categories
    if v2 then
        v2.Visible = false
    end
    for i, v in ipairs(u165) do
        v1 = u209.Frame:FindFirstChild(v)
        if v1 and v1:IsA("GuiObject") then
            v1.Visible = false
        end
    end
    for i2, i3 in ipairs({u209.Top.Categories}) do
        for i4, j in ipairs(i3:GetChildren()) do
            if j:IsA("ImageButton") then
                if j.Name ~= "EditMobile" then
                    ActivateButton(j)
                    j.MouseButton1Click:Connect(function() -- Line: 2379 -- upvalues: u0 (upval), j (val)
                        u0.Open(j.Name)
                    end)
                else
                    SetupEditMobileTabButton(j)
                end
            end
        end
    end
    local v3 = u209
    MenuState.RegisterBumperOverride(v3, function(a1) -- Line: 2386
        -- upvalues: u211 (upval), MenuState (upval), u209 (upval), u186 (upval), u214 (upval), u0 (upval)
        -- upvalues: GuiService (upval)
        if u211 then
            return true
        end
        local v1 = MenuState.GetNextBumperTab(u209.Top.Categories, u186, u214, a1)
        if v1 and v1 ~= u214 then
            u0.Open(v1)
        end
        local v2 = u214
        local v3 = u209.Top.Categories:FindFirstChild(v2)
        if v3 and v3:IsA("GuiObject") then
            GuiService.SelectedObject = v3
        end
        return true
    end)
    u209.Reset.MouseButton1Click:Connect(function() -- Line: 2407 -- upvalues: u0 (upval), u214 (upval)
        u0.ResetPage(u214)
    end)
    if u209:FindFirstChild("Share") then
        u209.Share.Visible = false
        u209.Share.List.Cancel.MouseButton1Click:Connect(function() -- Line: 2415 -- upvalues: u209 (upval)
            u209.Share.Visible = false
        end)
        u209.Share.List.Copy.MouseButton1Click:Connect(function() -- Line: 2419 -- upvalues: u209 (upval)
            u209.Share.TextBox:CaptureFocus()
            u209.Share.TextBox.CursorPosition = #u209.Share.TextBox.Text + 1
        end)
        u209.Share.List.Import.MouseButton1Click:Connect(function() -- Line: 2425 -- upvalues: u0 (upval), u209 (upval)
            u0.ImportCrosshair(u209.Share.TextBox.Text)
        end)
    end
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 2431
        -- upvalues: u211 (upval), u212 (upval), u208 (upval), u214 (upval), u209 (upval)
        -- upvalues: RestoreListeningSelection (upval), GetKeybindPlatformFromTextBox (upval)
        -- upvalues: CancelKeybindListening (upval), CloseButtonRegistry (upval), HandleKeybindCapture (upval)
        if not u211 or a1.UserInputState ~= Enum.UserInputState.Begin or tick() - u212 < 0.1 then
            return
        end
        if not u211.Parent then
            u211 = nil
            u208 = nil
            if u214 == "Keybinds" then
                local Keybinds = u209.Frame.List:FindFirstChild("Keybinds")
                local Scroll = Keybinds and Keybinds.Bottom.Scroll
                if Scroll then
                    Scroll.ScrollingEnabled = true
                end
            end
            RestoreListeningSelection()
            return
        end
        local v1 = GetKeybindPlatformFromTextBox(u211)
        if not v1 then
            CancelKeybindListening()
            return
        end
        local v2 = ""
        if a1.UserInputType == Enum.UserInputType.Keyboard then
            if a1.KeyCode == Enum.KeyCode.Escape then
                CancelKeybindListening()
                return
            end
            v2 = ("Enum.KeyCode.%*"):format(a1.KeyCode.Name)
            if v2 ~= "" then
                HandleKeybindCapture(v1, v2)
            end
            return
        end
        if a1.UserInputType == Enum.UserInputType.MouseButton1
            or a1.UserInputType == Enum.UserInputType.MouseButton2
            or a1.UserInputType == Enum.UserInputType.MouseButton3 then
            v2 = ("Enum.UserInputType.%*"):format(a1.UserInputType.Name)
        elseif string.match(a1.UserInputType.Name, "^Gamepad%d+$") then
            v2 = ("Enum.KeyCode.%*"):format(a1.KeyCode.Name)
            CloseButtonRegistry.MarkUsed()
        end
        if v2 ~= "" then
            HandleKeybindCapture(v1, v2)
        end
    end)
    UserInputService.InputChanged:Connect(function(a1, a2) -- Line: 2487
        -- upvalues: u211 (upval), u212 (upval), u208 (upval), u214 (upval), u209 (upval)
        -- upvalues: RestoreListeningSelection (upval), GetKeybindPlatformFromTextBox (upval)
        -- upvalues: CancelKeybindListening (upval), HandleKeybindCapture (upval)
        if not u211 or a1.UserInputType ~= Enum.UserInputType.MouseWheel or tick() - u212 < 0.1 then
            return
        end
        if not u211.Parent then
            u208 = nil
            u211 = nil
            if u214 == "Keybinds" then
                local Keybinds = u209.Frame.List:FindFirstChild("Keybinds")
                local Scroll = Keybinds and Keybinds.Bottom.Scroll
                if Scroll then
                    Scroll.ScrollingEnabled = true
                end
            end
            RestoreListeningSelection()
            return
        end
        local v1 = GetKeybindPlatformFromTextBox(u211)
        if not v1 then
            CancelKeybindListening()
            return
        end
        local Z = a1.Position.Z
        if Z > 0 then
            HandleKeybindCapture(v1, "Enum.CustomInputType.ScrollWheelUp")
            return
        end
        if Z < 0 then
            HandleKeybindCapture(v1, "Enum.CustomInputType.ScrollWheelDown")
        end
    end)
    UserInputService.InputBegan:Connect(function(a1) -- Line: 2527
        -- upvalues: u211 (upval), u210 (upval), CloseButtonRegistry (upval), GuiService (upval)
        if a1.KeyCode == Enum.KeyCode.ButtonB and not u211 then
            local v1 = u210
            if v1 and v1.Visible then
                CloseButtonRegistry.MarkUsed()
                v1.Visible = false
                local Parent = v1.Parent
                if Parent then
                    Parent.Visible = false
                end
                for i, v in ipairs(v1:GetChildren()) do
                    if v:IsA("TextButton") then
                        v:Destroy()
                    end
                end
                u210 = nil
                local Parent_2 = Parent and Parent.Parent
                if Parent_2 and Parent_2:IsA("GuiButton") then
                    GuiService.SelectedObject = Parent_2
                end
                return
            end
            return
        end
    end)
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 2556 -- upvalues: u210 (upval) -- types: a1: userdata, a2: boolean
        if a1.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        local v1 = u210
        if v1 and v1.Visible then
            local Position = a1.Position
            if v1.Parent and v1.Parent.Parent then
                local Options = v1.Parent.Parent:FindFirstChild("Options")
                if not Options then
                    return
                end
                local Button = Options.Button
                if not Button then
                    return
                end

                local function isInside(a1) -- Line: 2585 -- upvalues: Position (val) -- types: a1: userdata
                    local AbsolutePosition = a1.AbsolutePosition
                    local AbsoluteSize = a1.AbsoluteSize
                    local v1 = false
                    if AbsolutePosition.X <= Position.X then
                        v1 = false
                        if Position.X <= AbsolutePosition.X + AbsoluteSize.X then
                            v1 = false
                            if AbsolutePosition.Y <= Position.Y then
                                v1 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                            end
                        end
                    end
                    return v1
                end

                local AbsolutePosition = Button.AbsolutePosition
                local AbsoluteSize = Button.AbsoluteSize
                local v2 = false
                if AbsolutePosition.X <= Position.X then
                    v2 = false
                    if Position.X <= AbsolutePosition.X + AbsoluteSize.X then
                        v2 = false
                        if AbsolutePosition.Y <= Position.Y then
                            v2 = Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y
                        end
                    end
                end
                if not v2 then
                    local AbsolutePosition_2 = v1.AbsolutePosition
                    local AbsoluteSize_2 = v1.AbsoluteSize
                    v2 = false
                    if AbsolutePosition_2.X <= Position.X then
                        v2 = false
                        if Position.X <= AbsolutePosition_2.X + AbsoluteSize_2.X then
                            v2 = false
                            if AbsolutePosition_2.Y <= Position.Y then
                                v2 = Position.Y <= AbsolutePosition_2.Y + AbsoluteSize_2.Y
                            end
                        end
                    end
                    if not v2 then
                        v1.Visible = false
                        u210 = nil
                    end
                end
                return
            end
            return
        end
    end)
end

function u0.Start() -- Line: 2600 -- upvalues: Profiler (val), u0 (val), DataController (val), LocalPlayer (val)
    debug.setmemorycategory("UI.Settings.Start")
    Profiler.mark("UI.Settings.Start")
    u0.Open("Video")
    DataController.CreateListener(LocalPlayer, "Settings", function(a1) -- Line: 2606 -- upvalues: u0 (upval)
        u0.UpdateSettings(a1)
    end)
end

return u0