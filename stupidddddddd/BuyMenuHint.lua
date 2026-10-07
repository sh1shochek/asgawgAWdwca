-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenuHint
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenuHint
-- Decompile time: 17.96 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local IsInBuyArea = require(ReplicatedStorage.Database.Components.Common.IsInBuyArea)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local IsBotLobby = require(ReplicatedStorage.Components.Common.IsBotLobby)
local TutorialPurchaseLock = require(ReplicatedStorage.Components.Common.TutorialPurchaseLock)
local Tips = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips)
local HoverBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.HoverBomb)
local Notification = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification)
require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Notification.Types)
local u107 = UDim2.fromScale(0.225, 0.054)
local u112 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u124 = false
if table.find(GetUserPlatform(), "Mobile") ~= nil then
    u124 = #GetUserPlatform() <= 1
end
local u125 = false
local u126 = false
local u127 = false
local u128 = (1 / 0)
local u129 = nil
local u131 = RaycastParams.new()
u131.FilterType = Enum.RaycastFilterType.Exclude
u131.IgnoreWater = true
local u134 = nil
local u135 = nil
local u136 = nil
local u137 = nil
local u138 = false
local u139 = 0
local u140 = (-1 / 0)

local function IsBuyMenuScreenOpen() -- Line: 112 -- upvalues: u134 (ref)
    local BuyMenu = u134 and u134:FindFirstChild("BuyMenu")
    local Visible = false
    if BuyMenu ~= nil then
        Visible = BuyMenu:IsA("GuiObject") and BuyMenu.Visible
    end
    return Visible
end

local function IsTouchInput() -- Line: 117 -- upvalues: UserInputService (val)
    return UserInputService.PreferredInput == Enum.PreferredInput.Touch
end

local function DecodeAttribute(a1) -- Line: 123 -- upvalues: LocalPlayer (val), HttpService (val) -- types: a1: string
    local Attribute = LocalPlayer:GetAttribute(a1)
    if typeof(Attribute) ~= "string" then
        return nil
    end
    local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
    if success and typeof(result) == "table" then
        return result
    end
    return nil
end

local function IsCarryingBomb() -- Line: 133 -- upvalues: LocalPlayer (val), HttpService (val)
    local v1
    local Attribute = LocalPlayer:GetAttribute("Slot5")
    if typeof(Attribute) == "string" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
    else
        v1 = nil
    end
    local v2 = false
    if v1 ~= nil then
        v2 = v1.Weapon == "C4"
    end
    return v2
end

local function IsBombEquipped() -- Line: 138 -- upvalues: LocalPlayer (val), HttpService (val)
    local v1
    local Attribute = LocalPlayer:GetAttribute("CurrentEquipped")
    if typeof(Attribute) == "string" then
        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
        v1 = if not success then nil else if typeof(result) ~= "table" then nil else result
    else
        v1 = nil
    end
    local v2 = false
    if v1 ~= nil then
        v2 = v1.Name == "C4"
    end
    return v2
end

local function CanPromptBomb() -- Line: 144 -- upvalues: IsTutorialMode (val), LocalPlayer (val), HttpService (val)
    local v1 = IsTutorialMode()
    if v1 then
        local v2
        local Attribute = LocalPlayer:GetAttribute("Slot5")
        if typeof(Attribute) == "string" then
            local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
            v2 = if not success then nil else if typeof(result) ~= "table" then nil else result
        else
            v2 = nil
        end
        v1 = false
        if v2 ~= nil then
            v1 = v2.Weapon == "C4"
        end
        if not v1 then
            local Attribute_2 = LocalPlayer:GetAttribute("CurrentEquipped")
            if typeof(Attribute_2) == "string" then
                local success_2, result_2 = pcall(HttpService.JSONDecode, HttpService, Attribute_2)
                v2 = if not success_2 then nil else if typeof(result_2) ~= "table" then nil else result_2
            else
                v2 = nil
            end
            v1 = false
            if v2 ~= nil then
                v1 = v2.Name == "C4"
            end
        end
    end
    return v1
end

local function IsOnTutorialStep(a1) -- Line: 148
    -- upvalues: IsTutorialMode (val), LocalPlayer (val)
    return IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == a1
end

local function HasShotPracticeRifle() -- Line: 153 -- upvalues: LocalPlayer (val)
    local Attribute = LocalPlayer:GetAttribute("TutorialObjective")
    local v1 = false
    if typeof(Attribute) == "string" then
        v1 = string.find(Attribute, "^Reload") ~= nil
    end
    return v1
end

local function IsStoodOnPlantArea() -- Line: 163 -- upvalues: LocalPlayer (val), u131 (val)
    local Character = LocalPlayer.Character
    local PrimaryPart = Character and (Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart"))
    if Character and PrimaryPart then
        local v1 = {Character, workspace.CurrentCamera}
        local Debris = workspace:FindFirstChild("Debris")
        if Debris then
            table.insert(v1, Debris)
        end
        u131.FilterDescendantsInstances = v1
        local v2 = workspace:Raycast(PrimaryPart.Position, Vector3.new(-0, -5, -0), u131)
        local v3 = false
        if v2 ~= nil then
            v3 = v2.Instance:HasTag("PlantArea") and v2.Instance:GetAttribute("Site") ~= nil
        end
        return v3
    end
    return false
end

local u154 = {}
local v2 = {
    Text = "EQUIP BOMB",
    Action = "Explosives & Traps",
    GamepadAction = "Cycle Weapons Right",
    GamepadText = "CYCLE TO THE BOMB",
    MobileText = "TAP HERE TO EQUIP BOMB",
    OnTap = function() -- Line: 200 -- upvalues: InventoryController (val)
        InventoryController.equip(5, 1)
    end,
    IsAvailable = function() -- Line: 203 -- upvalues: u127 (ref), LocalPlayer (val), HttpService (val)
        local v1 = u127
        if v1 then
            local v2
            local Attribute = LocalPlayer:GetAttribute("Slot5")
            if typeof(Attribute) == "string" then
                local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
                v2 = if not success then nil else if typeof(result) ~= "table" then nil else result
            else
                v2 = nil
            end
            v1 = false
            if v2 ~= nil then
                v1 = v2.Weapon == "C4"
            end
            if v1 then
                local v3
                local Attribute_2 = LocalPlayer:GetAttribute("CurrentEquipped")
                if typeof(Attribute_2) == "string" then
                    local success_2, result_2 = pcall(HttpService.JSONDecode, HttpService, Attribute_2)
                    v3 = if not success_2 then nil else if typeof(result_2) ~= "table" then nil else result_2
                else
                    v3 = nil
                end
                v2 = false
                if v3 ~= nil then
                    v2 = v3.Name == "C4"
                end
                v1 = not v2
            end
        end
        return v1
    end,
}
local v3 = {
    Text = "HOLD TO PLANT BOMB",
    Action = "Fire",
    MobileButton = "Shoot",
    IsAvailable = function() -- Line: 212 -- upvalues: u127 (ref), LocalPlayer (val), HttpService (val)
        local v1 = u127
        if v1 then
            local v2
            local Attribute = LocalPlayer:GetAttribute("CurrentEquipped")
            if typeof(Attribute) == "string" then
                local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
                v2 = if not success then nil else if typeof(result) ~= "table" then nil else result
            else
                v2 = nil
            end
            v1 = false
            if v2 ~= nil then
                v1 = v2.Name == "C4"
            end
        end
        return v1
    end,
}
local v4 = {
    Text = "HOLD TO DEFUSE BOMB",
    Action = "Use",
    MobileButton = "Interact",
    IsAvailable = function() -- Line: 220 -- upvalues: IsTutorialMode (val), LocalPlayer (val), HoverBomb (val)
        local v1 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "DefuseB"
        if v1 then
            v1 = false
            if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
                v1 = HoverBomb.GetHoverState()
            end
        end
        return v1
    end,
}
local v5 = {
    Text = "LOOK AT THE BOMB",
    IsAvailable = function() -- Line: 230 -- upvalues: IsTutorialMode (val), LocalPlayer (val), HoverBomb (val)
        local v1 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "DefuseB"
        if v1 then
            v1 = false
            if LocalPlayer:GetAttribute("IsDefusingBomb") ~= true then
                v1 = HoverBomb.IsInDefuseRange()
            end
        end
        return v1
    end,
}
local v6 = {
    Text = "GO TO THE BOMB",
    IsAvailable = function() -- Line: 239 -- upvalues: IsTutorialMode (val), LocalPlayer (val)
        return IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "DefuseB" and LocalPlayer:GetAttribute("IsDefusingBomb") ~= true
    end,
}
local v7 = {
    Text = "SHOOT",
    Action = "Fire",
    MobileButton = "Shoot",
    IsAvailable = function() -- Line: 248 -- upvalues: IsTutorialMode (val), LocalPlayer (val)
        local v1 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "PracticeAK"
        if v1 then
            local Attribute = LocalPlayer:GetAttribute("TutorialObjective")
            local v2 = false
            if typeof(Attribute) == "string" then
                v2 = string.find(Attribute, "^Reload") ~= nil
            end
            v1 = not v2
        end
        return v1
    end,
}
local v8 = {
    Text = "RELOAD",
    Action = "Reload",
    MobileButton = "Reload",
    IsAvailable = function() -- Line: 256 -- upvalues: IsTutorialMode (val), LocalPlayer (val)
        local v1 = IsTutorialMode() and LocalPlayer:GetAttribute("TutorialStep") == "PracticeAK"
        if v1 then
            local Attribute = LocalPlayer:GetAttribute("TutorialObjective")
            v1 = false
            if typeof(Attribute) == "string" then
                v1 = string.find(Attribute, "^Reload") ~= nil
            end
        end
        return v1
    end,
}
local v9 = {
    Text = "BUY MENU",
    Action = "Buy Menu",
    MobileButton = "Shop",
    MobileText = "TAP THE SHOP BUTTON",
    IsAvailable = function() -- Line: 266 -- upvalues: u126 (ref), LocalPlayer (val), u134 (ref), TutorialPurchaseLock (val)
        local v1 = u126
        if v1 then
            v1 = false
            if LocalPlayer:GetAttribute("BuyMenu") == true then
                local BuyMenu = u134 and u134:FindFirstChild("BuyMenu")
                local Visible = false
                if BuyMenu ~= nil then
                    Visible = BuyMenu:IsA("GuiObject") and BuyMenu.Visible
                end
                v1 = not Visible and not TutorialPurchaseLock.isBuyMenuLocked(LocalPlayer)
            end
        end
        return v1
    end,
}
u154[1] = v2
u154[2] = v3
u154[3] = v4
u154[4] = v5
u154[5] = v6
u154[6] = v7
u154[7] = v8
u154[8] = v9

local function ResolvePromptBinding(a1) -- Line: 278 -- upvalues: Tips (val) -- types: a1: table
    if not a1.Action then
        return nil
    end
    local v1 = Tips.ResolveActionBinding(a1.Action)
    if not v1 and a1.GamepadAction and Tips.IsGamepadPreferred() then
        v1 = Tips.ResolveActionBinding(a1.GamepadAction)
    end
    return v1
end

local u177 = nil
local u178 = nil
local u179 = nil

local function GetPromptParts() -- Line: 296 -- upvalues: u137 (ref), u177 (ref), u178 (ref), u179 (ref)
    local v1 = u137
    if v1 and v1.Parent then
        local Keybind, TextLabel
        if v1 == u177 and u178 and u178.Parent == v1 then
            if u179 ~= nil and u179.Parent ~= v1 then
                TextLabel = v1:FindFirstChild("TextLabel")
                Keybind = v1:FindFirstChild("Keybind")
                if TextLabel and TextLabel:IsA("TextLabel") then
                    u177 = v1
                    u179 = if not Keybind then nil else if not Keybind:IsA("ImageButton") then nil else Keybind
                    return TextLabel, u179
                end
                warn((("[BuyMenuHint]: %* has no TextLabel child; the prompt cannot render"):format((v1:GetFullName()))))
                return nil, nil
            end
            return u178, u179
        end
        TextLabel = v1:FindFirstChild("TextLabel")
        Keybind = v1:FindFirstChild("Keybind")
        if TextLabel and TextLabel:IsA("TextLabel") then
            u177 = v1
            u179 = if not Keybind then nil else if not Keybind:IsA("ImageButton") then nil else Keybind
            return TextLabel, u179
        end
        warn((("[BuyMenuHint]: %* has no TextLabel child; the prompt cannot render"):format((v1:GetFullName()))))
        return nil, nil
    end
    return nil, nil
end

local function RefreshPrompt() -- Line: 321
    -- upvalues: u129 (ref), GetPromptParts (val), UserInputService (val), Tips (val), u137 (ref)
    local v1 = u129
    local v2, v3 = GetPromptParts()
    if v1 and v2 then
        local v4, v5
        v2.Text = string.upper(if not (UserInputService.PreferredInput == Enum.PreferredInput.Touch) then if not Tips.IsGamepadPreferred() then v1.Text else if not v1.GamepadText then v1.Text else v1.GamepadText else if not v1.MobileText then if not Tips.IsGamepadPreferred() then v1.Text else if not v1.GamepadText then v1.Text else v1.GamepadText else v1.MobileText)
        if v3 then
            v5 = false
            if v1.Action ~= nil then
                v5 = not v4
                if v5 then
                    local v6
                    local ApplyBindingToKeybind = Tips.ApplyBindingToKeybind
                    if v1.Action then
                        local v7 = Tips.ResolveActionBinding(v1.Action)
                        if not v7 and v1.GamepadAction and Tips.IsGamepadPreferred() then
                            v7 = Tips.ResolveActionBinding(v1.GamepadAction)
                        end
                        v6 = v7
                    else
                        v6 = nil
                    end
                    v5 = ApplyBindingToKeybind(v3, v6)
                end
            end
            v3.Visible = v5
        end
        v5 = u137
        local TapTarget = v5 and v5:FindFirstChild("TapTarget")
        if TapTarget and TapTarget:IsA("GuiObject") then
            TapTarget.Visible = v4 and v1.OnTap ~= nil
        end
        return
    end
end

local function HighlightMobileButton(a1) -- Line: 351
    -- upvalues: u140 (ref), UserInputService (val), ReplicatedStorage (val)
    if not a1.MobileButton then
        return
    end
    u140 = os.clock()
    if not (UserInputService.PreferredInput == Enum.PreferredInput.Touch) then
        return
    end
    require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons).HighlightButton(a1.MobileButton, 2)
end

local u184 = nil
local u185 = 0
local u186 = 0
local u187 = 0

local function LayoutKeybind() -- Line: 377
    -- upvalues: u137 (ref), GetPromptParts (val), u184 (ref), u185 (ref), u186 (ref), u187 (ref)
    local v1 = u137
    if v1 and v1.Parent then
        local v2, v3 = GetPromptParts()
        if not v2 then
            return
        end
        local X = v1.AbsoluteSize.X
        if X <= 0 then
            return
        end
        local X_2 = v2.TextBounds.X
        local X_3 = if not v3 then -1 else if not v3.Visible then -1 else v3.AbsoluteSize.X
        if v2 == u184 and X == u185 and X_2 == u186 and X_3 == u187 then
            return
        end
        u184 = v2
        u185 = X
        u186 = X_2
        u187 = X_3
        local v4 = X_2 / X
        if v3 and not (X_3 < 0) then
            local v5 = X_3 / X
            local v6 = 0.5 - (v5 + 0.02 + v4) / 2
            v3.Position = UDim2.fromScale(v6 + v5 * v3.AnchorPoint.X, 0.5)
            v2.Position = UDim2.fromScale(v6 + v5 + 0.02 + v4 / 2, 0.5)
            return
        end
        v2.Position = UDim2.fromScale(0.5, 0.5)
        return
    end
end

local function FindCommanderBox() -- Line: 415 -- upvalues: IsTutorialMode (val), u134 (ref)
    if not IsTutorialMode() then
        return nil
    end
    local v1 = u134
    local TutorialDialogue = v1 and v1:FindFirstChild("TutorialDialogue")
    if TutorialDialogue and TutorialDialogue:IsA("GuiObject") then
        return TutorialDialogue
    end
    return nil
end

local function GetLayoutOrigin() -- Line: 426 -- upvalues: u134 (ref)
    local v1 = u134
    if v1 and v1:IsA("GuiBase2d") then
        return v1.AbsolutePosition
    end
    return Vector2.zero
end

local function GetTutorialCardSlot() -- Line: 436 -- upvalues: IsTutorialMode (val), u134 (ref)
    local v1
    if IsTutorialMode() then
        local v2 = u134
        local TutorialDialogue = v2 and v2:FindFirstChild("TutorialDialogue")
        v1 = if not TutorialDialogue then nil else if not TutorialDialogue:IsA("GuiObject") then nil else TutorialDialogue
    else
        v1 = nil
    end
    if not v1 then
        return UDim2.fromScale(0.5, 0.74)
    end
    local v3 = u134
    local AbsolutePosition = if not v3 then Vector2.zero else if not v3:IsA("GuiBase2d") then Vector2.zero else v3.AbsolutePosition
    local Y = v1.AbsolutePosition.Y
    for i, j in v1:GetChildren() do
        if j:IsA("GuiObject") and j.Visible then
            Y = math.min(Y, j.AbsolutePosition.Y)
        end
    end
    return UDim2.fromOffset(v1.AbsolutePosition.X + v1.AbsoluteSize.X / 2 - AbsolutePosition.X, Y - AbsolutePosition.Y - 10)
end

local function LayoutTutorialCard() -- Line: 454
    -- upvalues: u137 (ref), u138 (ref), u134 (ref), u139 (ref), GetTutorialCardSlot (val), IsTutorialMode (val)
    local v1 = u137
    if u138 and v1 and v1.Parent and u134 then
        local v2
        local v3 = (1 - math.clamp((os.clock() - u139) / 0.3, 0, 1)) ^ 2 * 12
        v1.AnchorPoint = Vector2.new(0.5, 1)
        v1.Position = GetTutorialCardSlot() + UDim2.fromOffset(0, v3)
        if IsTutorialMode() then
            local v4 = u134
            local TutorialDialogue = v4 and v4:FindFirstChild("TutorialDialogue")
            v2 = if not TutorialDialogue then nil else if not TutorialDialogue:IsA("GuiObject") then nil else TutorialDialogue
        else
            v2 = nil
        end
        if v2 then
            v1.ZIndex = v2.ZIndex
        end
        return
    end
end

local function CreateKeycap() -- Line: 473
    local ImageButton = Instance.new("ImageButton")
    ImageButton.Name = "Keybind"
    ImageButton.AutoButtonColor = false
    ImageButton.Active = false
    ImageButton.Image = ""
    ImageButton.BackgroundColor3 = Color3.new(1, 1, 1)
    ImageButton.BackgroundTransparency = 0
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.2, 0)
    UICorner.Parent = ImageButton
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Bind"
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel.Size = UDim2.fromScale(0.9, 0.7)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextScaled = true
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    TextLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
    TextLabel.ZIndex = 2
    TextLabel.Parent = ImageButton
    return ImageButton
end

local function EnsureKeycapImage(a1) -- Line: 505 -- types: a1: userdata
    for i, j in a1:GetChildren() do
        if j.Name == "Bind" and j:IsA("ImageLabel") then
            return
        end
    end
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Bind"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(0.9, 0.9)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Visible = false
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = a1
end

local function CreateTutorialCard() -- Line: 528
    -- upvalues: u134 (ref), ReplicatedStorage (val), u107 (val), u135 (ref), CreateKeycap (val)
    -- upvalues: EnsureKeycapImage (val), u129 (ref), UserInputService (val), GetPreferenceColor (val)
    -- upvalues: TweenService (val), u112 (val), u139 (ref)
    local v1 = u134
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local UI = Assets and Assets:FindFirstChild("UI")
    local Notification = UI and UI:FindFirstChild("Notification")
    local Keybind = Notification and (Notification:FindFirstChild("Keybind") or Notification:FindFirstChild("Default"))
    if v1 and Keybind and Keybind:IsA("GuiObject") then
        local v2
        local v3 = Keybind:Clone()
        v3.Name = "TutorialPrompt"
        v3.Size = u107
        v3.LayoutOrder = 0
        local Keybind_2 = v3:FindFirstChild("Keybind")
        if not Keybind_2 or not Keybind_2:IsA("ImageButton") then
            Keybind_2 = if not u135 then CreateKeycap() else u135:Clone()
            Keybind_2.Name = "Keybind"
            Keybind_2.AnchorPoint = Vector2.new(0, 0.5)
            Keybind_2.Size = UDim2.fromScale(0.7, 0.7)
            Keybind_2.SizeConstraint = Enum.SizeConstraint.RelativeYY
            Keybind_2.ZIndex = 3
            Keybind_2.Parent = v3
        end
        EnsureKeycapImage(Keybind_2)
        local TextLabel = v3:FindFirstChild("TextLabel")
        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.TextWrapped = false
        end
        local TextButton = Instance.new("TextButton")
        TextButton.Name = "TapTarget"
        TextButton.BackgroundTransparency = 1
        TextButton.Text = ""
        TextButton.Size = UDim2.fromScale(1, 1)
        TextButton.ZIndex = 10
        TextButton.Visible = false
        TextButton.Activated:Connect(function() -- Line: 569 -- upvalues: u129 (upval), UserInputService (upval)
            local v1 = u129
            if v1 and v1.OnTap and UserInputService.PreferredInput == Enum.PreferredInput.Touch then
                v1.OnTap()
            end
        end)
        TextButton.Parent = v3
        local v4 = GetPreferenceColor()
        for i, j in {"Left", "Right"} do
            v2 = v3:FindFirstChild(j)
            if v2 and v2:IsA("GuiObject") then
                v2.BackgroundColor3 = v4
            end
        end
        if v3:IsA("CanvasGroup") then
            v3.GroupTransparency = 1
            TweenService:Create(v3, u112, {GroupTransparency = 0}):Play()
        end
        u139 = os.clock()
        v3.Parent = v1
        return v3
    end
    return nil
end

local function RemoveTutorialCard(a1) -- Line: 594 -- upvalues: TweenService (val), u112 (val) -- types: a1: userdata
    if not a1:IsA("CanvasGroup") then
        a1:Destroy()
        return
    end
    local v1 = TweenService:Create(a1, u112, {GroupTransparency = 1})
    v1.Completed:Once(function() -- Line: 600 -- upvalues: a1 (val)
        a1:Destroy()
    end)
    v1:Play()
end

local function ResolvePrompt() -- Line: 609 -- upvalues: u154 (val)
    for i, v in ipairs(u154) do
        if v.IsAvailable() then
            return v
        end
    end
    return nil
end

local function RemoveCard() -- Line: 621
    -- upvalues: u137 (ref), u138 (ref), RemoveTutorialCard (val), Notification (val)
    local v1 = u137
    u137 = nil
    if not u138 then
        Notification.removeNotification("BuyMenuHint")
        return
    end
    if v1 and v1.Parent then
        RemoveTutorialCard(v1)
        return
    end
end

local function ShowPrompt(a1) -- Line: 633
    -- upvalues: u129 (ref), u125 (ref), IsTutorialMode (val), IsBotLobby (val), u137 (ref), u138 (ref)
    -- upvalues: RemoveTutorialCard (val), Notification (val), u140 (ref), HighlightMobileButton (val)
    -- upvalues: RefreshPrompt (val), CreateTutorialCard (val)
    local v1
    local v2 = a1 ~= u129
    u129 = a1
    u125 = a1 ~= nil
    local v3 = IsTutorialMode() or IsBotLobby()
    if u137 and u138 ~= v3 then
        v1 = u137
        u137 = nil
        if not u138 then
            Notification.removeNotification("BuyMenuHint")
        elseif v1 and v1.Parent then
            RemoveTutorialCard(v1)
        end
    end
    if not a1 then
        if not u137 and not v2 then
            return
        end
        v1 = u137
        u137 = nil
        if not u138 then
            Notification.removeNotification("BuyMenuHint")
            return
        end
        if v1 and v1.Parent then
            RemoveTutorialCard(v1)
            return
        end
        return
    end
    if v2 or 2 <= os.clock() - u140 then
        HighlightMobileButton(a1)
    end
    if u137 and u137.Parent then
        if v2 then
            RefreshPrompt()
        end
        return
    end
    u137 = if not v3 then Notification.createNotification("Keybind", "BuyMenuHint", string.upper(a1.Text), 0) else CreateTutorialCard()
    RefreshPrompt()
end

local function ShouldRunUpdate() -- Line: 687
    -- upvalues: LocalPlayer (val), CharacterResolver (val), IsTutorialMode (val), u124 (val), IsBotLobby (val)
    if LocalPlayer:GetAttribute("IsSpectating") == true
        or not CharacterResolver.isAliveCharacter(LocalPlayer.Character) then
        return false
    end
    if IsTutorialMode() then
        return true
    end
    if u124 and not IsBotLobby() then
        return false
    end
    local v1 = false
    if LocalPlayer:GetAttribute("BuyMenu") == true then
        v1 = workspace:GetAttribute("Gamemode") ~= "Deathmatch"
    end
    return v1
end

local function StopUpdateConnection() -- Line: 707 -- upvalues: u136 (ref), u126 (ref), u127 (ref), u128 (ref)
    if u136 then
        u136:Disconnect()
        u136 = nil
    end
    u126 = false
    u127 = false
    u128 = (1 / 0)
end

local function SyncUpdateConnection() -- Line: 719
    -- upvalues: ShouldRunUpdate (val), u136 (ref), u128 (ref), RunServiceController (val), u129 (ref), u125 (ref)
    -- upvalues: IsTutorialMode (val), IsBotLobby (val), u137 (ref), u138 (ref), RemoveTutorialCard (val)
    -- upvalues: Notification (val), u126 (ref), u127 (ref), LocalPlayer (val), IsInBuyArea (val), HttpService (val)
    -- upvalues: IsStoodOnPlantArea (val), ShowPrompt (val), u154 (val), LayoutKeybind (val), LayoutTutorialCard (val)
    local v1
    if ShouldRunUpdate() then
        if u136 then
            return
        end
        u128 = (1 / 0)
        u136 = RunServiceController.BindToHeartbeat("UI.BuyMenuHint.Update", function(a1) -- Line: 726
            -- upvalues: ShouldRunUpdate (upval), u129 (upval), u125 (upval), IsTutorialMode (upval), IsBotLobby (upval)
            -- upvalues: u137 (upval), u138 (upval), RemoveTutorialCard (upval), Notification (upval), u136 (upval)
            -- upvalues: u126 (upval), u127 (upval), u128 (upval), LocalPlayer (upval), IsInBuyArea (upval)
            -- upvalues: HttpService (upval), IsStoodOnPlantArea (upval), ShowPrompt (upval), u154 (upval)
            -- upvalues: LayoutKeybind (upval), LayoutTutorialCard (upval)
            local v1, v2
            if not ShouldRunUpdate() then
                local v3
                v1 = u129 ~= nil
                u129 = nil
                u125 = false
                v2 = IsTutorialMode() or IsBotLobby()
                if u137 and u138 ~= v2 then
                    v3 = u137
                    u137 = nil
                    if not u138 then
                        Notification.removeNotification("BuyMenuHint")
                    elseif v3 and v3.Parent then
                        RemoveTutorialCard(v3)
                    end
                end
                if u137 or v1 then
                    v3 = u137
                    u137 = nil
                    if not u138 then
                        Notification.removeNotification("BuyMenuHint")
                    elseif v3 and v3.Parent then
                        RemoveTutorialCard(v3)
                    end
                end
                if u136 then
                    u136:Disconnect()
                    u136 = nil
                end
                u126 = false
                u127 = false
                u128 = (1 / 0)
                return
            end
            u128 = u128 + a1
            if u128 >= 0.2 then
                u128 = 0
                v1 = false
                if LocalPlayer:GetAttribute("BuyMenu") == true then
                    v1 = IsInBuyArea(LocalPlayer)
                end
                u126 = v1
                v1 = IsTutorialMode()
                if v1 then
                    local Attribute = LocalPlayer:GetAttribute("Slot5")
                    if typeof(Attribute) == "string" then
                        local success, result = pcall(HttpService.JSONDecode, HttpService, Attribute)
                        v2 = if not success then nil else if typeof(result) ~= "table" then nil else result
                    else
                        v2 = nil
                    end
                    v1 = false
                    if v2 ~= nil then
                        v1 = v2.Weapon == "C4"
                    end
                    if not v1 then
                        local Attribute_2 = LocalPlayer:GetAttribute("CurrentEquipped")
                        if typeof(Attribute_2) == "string" then
                            local success_2, result_2 = pcall(HttpService.JSONDecode, HttpService, Attribute_2)
                            v2 = if not success_2 then nil else if typeof(result_2) ~= "table" then nil else result_2
                        else
                            v2 = nil
                        end
                        v1 = false
                        if v2 ~= nil then
                            v1 = v2.Name == "C4"
                        end
                    end
                end
                if v1 then
                    v1 = IsStoodOnPlantArea()
                end
                u127 = v1
            end
            v1 = ShowPrompt
            for i, v in ipairs(u154) do
                if v.IsAvailable() then
                    v1(v)
                    if u125 then
                        LayoutKeybind()
                        LayoutTutorialCard()
                    end
                    return
                end
            end
            v1(nil)
            if u125 then
                LayoutKeybind()
                LayoutTutorialCard()
            end
        end)
        return
    end
    local v2 = u129 ~= nil
    u129 = nil
    u125 = false
    local v3 = IsTutorialMode() or IsBotLobby()
    if u137 and u138 ~= v3 then
        v1 = u137
        u137 = nil
        if not u138 then
            Notification.removeNotification("BuyMenuHint")
        elseif v1 and v1.Parent then
            RemoveTutorialCard(v1)
        end
    end
    if u137 or v2 then
        v1 = u137
        u137 = nil
        if not u138 then
            Notification.removeNotification("BuyMenuHint")
        elseif v1 and v1.Parent then
            RemoveTutorialCard(v1)
        end
    end
    if u136 then
        u136:Disconnect()
        u136 = nil
    end
    u126 = false
    u127 = false
    u128 = (1 / 0)
end

function v1.GetHintState() -- Line: 756 -- upvalues: u125 (ref)
    return u125
end

function v1.GetFloatingSlot() -- Line: 765
    -- upvalues: IsTutorialMode (val), IsBotLobby (val), u137 (ref), u138 (ref), u134 (ref), GetTutorialCardSlot (val)
    if not IsTutorialMode() and not IsBotLobby() then
        return nil
    end
    local v1 = u137
    if u138 and v1 and v1.Parent then
        local v2 = u134
        local AbsolutePosition = if not v2 then Vector2.zero else if not v2:IsA("GuiBase2d") then Vector2.zero else v2.AbsolutePosition
        return UDim2.fromOffset(
            v1.AbsolutePosition.X + v1.AbsoluteSize.X / 2 - AbsolutePosition.X,
            v1.AbsolutePosition.Y - AbsolutePosition.Y - 10
        )
    end
    return GetTutorialCardSlot()
end

function v1.Initialize(a1, a2) -- Line: 786
    -- upvalues: u134 (ref), u135 (ref), u129 (ref), u125 (ref), IsTutorialMode (val), IsBotLobby (val), u137 (ref)
    -- upvalues: u138 (ref), RemoveTutorialCard (val), Notification (val), DataController (val), LocalPlayer (val)
    -- upvalues: RefreshPrompt (val), UserInputService (val), SyncUpdateConnection (val)
    local v1
    u134 = a2.Parent
    local Keybind = a2:FindFirstChild("Keybind")
    u135 = if not Keybind then nil else if not Keybind:IsA("ImageButton") then nil else Keybind
    a2.Visible = false
    local v2 = u129 ~= nil
    u129 = nil
    u125 = false
    local v3 = IsTutorialMode() or IsBotLobby()
    if u137 and u138 ~= v3 then
        v1 = u137
        u137 = nil
        if not u138 then
            Notification.removeNotification("BuyMenuHint")
        elseif v1 and v1.Parent then
            RemoveTutorialCard(v1)
        end
    end
    if u137 or v2 then
        v1 = u137
        u137 = nil
        if not u138 then
            Notification.removeNotification("BuyMenuHint")
        elseif v1 and v1.Parent then
            RemoveTutorialCard(v1)
        end
    end
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(a1) -- Line: 795 -- upvalues: RefreshPrompt (upval)
        if a1 then
            task.defer(RefreshPrompt)
        end
    end)
    ;(UserInputService:GetPropertyChangedSignal("PreferredInput")):Connect(RefreshPrompt)
    ;(LocalPlayer:GetAttributeChangedSignal("BuyMenu")):Connect(SyncUpdateConnection)
    ;(LocalPlayer:GetAttributeChangedSignal("IsSpectating")):Connect(SyncUpdateConnection)
    ;(LocalPlayer:GetAttributeChangedSignal("Team")):Connect(SyncUpdateConnection)
    LocalPlayer.CharacterAdded:Connect(SyncUpdateConnection)
    LocalPlayer.CharacterRemoving:Connect(SyncUpdateConnection)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(SyncUpdateConnection)
    ;(LocalPlayer:GetAttributeChangedSignal("Slot5")):Connect(SyncUpdateConnection)
    ;(LocalPlayer:GetAttributeChangedSignal("CurrentEquipped")):Connect(SyncUpdateConnection)
    ;(workspace:GetAttributeChangedSignal("ServerGamemode")):Connect(SyncUpdateConnection)
    ;(workspace:GetAttributeChangedSignal("BotLobby")):Connect(SyncUpdateConnection)
    SyncUpdateConnection()
end

return v1