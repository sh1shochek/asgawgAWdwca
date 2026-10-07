-- ReplicatedStorage.Controllers.InspectController
-- Script path: ReplicatedStorage.Controllers.InspectController
-- Decompile time: 49.76 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SceneLighting = require(ReplicatedStorage.Components.Common.SceneLighting)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
require(ReplicatedStorage.Database.Custom.Types)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local Viewmodel = require(ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel)
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local ApplyMobileButtonLayout = require(ReplicatedStorage.Components.Common.ApplyMobileButtonLayout)
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile)
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = GetUserPlatform()
local u158 = table.find(v1, "Mobile")
if u158 then
    u158 = #v1 <= 1
end
local CurrentCamera = workspace.CurrentCamera
local u161 = nil
local Lighting = ReplicatedStorage.Assets.Lighting
local PreviewTemplate = ReplicatedStorage.Assets.UI.Inspect:WaitForChild("PreviewTemplate")
local u172 = nil
local u173 = nil
local u174 = nil
local u175 = nil
local u176 = nil
local u177 = nil
local u178 = nil
local u179 = nil
local u180 = false
local u181 = nil
local u182 = nil
local u183 = nil
local u184 = {}
local u187 = Janitor.new()
local u188 = "Weapon"
local u189 = false
local u190 = nil
local u191 = false
local DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV
local u198 = CFrame.Angles(0, -1.5707963267948966, 0)
local u199 = {"FAMAS", "AK-47", "M4A1-S", "Glock-18", "USP-S"}
local u205 = {Weapon = true, Melee = true, Glove = true}
local u206 = {"HiddenTransparency", "_CaseScenePrevTransparency", "_InspectPrevTransparency"}
local u210 = false
local zero = Vector2.zero
local u212 = 40
local u213 = 40
local u214 = 0
local u215 = 0
local u216 = 0
local u217 = 0
local u221 = UDim2.fromScale(0.5, 0.075)
local u225 = UDim2.fromScale(0.317, 0.054)
local u229 = UDim2.fromScale(0.243, 0.054)
local u233 = UDim2.fromScale(0.5, 0.143)
local u238 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u239 = {}
local v2 = {
    Wear = "Factory New",
    Display = "Mint Condition",
    Min = 0,
    Max = 0.07,
    Color = Color3.fromRGB(0, 255, 127),
}
local v3 = {
    Wear = "Minimal Wear",
    Display = "Near-Mint",
    Min = 0.07,
    Max = 0.15,
    Color = Color3.fromRGB(0, 170, 255),
}
local v4 = {
    Wear = "Field-Tested",
    Display = "Standard-Grade",
    Min = 0.15,
    Max = 0.38,
    Color = Color3.fromRGB(255, 255, 0),
}
local v5 = {
    Wear = "Well-Worn",
    Display = "Combat-Worn",
    Min = 0.38,
    Max = 0.45,
    Color = Color3.fromRGB(255, 85, 0),
}
local v6 = {
    Wear = "Battle-Scarred",
    Display = "War-Torn",
    Min = 0.45,
    Max = 1,
    Color = Color3.fromRGB(255, 0, 0),
}
u239[1] = v2
u239[2] = v3
u239[3] = v4
u239[4] = v5
u239[5] = v6
local u270 = {}
local u271 = nil
local u272 = nil
local u273 = 1
local u274 = false

local function commaNumber(a1) -- Line: 157 -- types: a1: number
    return tostring(a1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function applyMapLighting() -- Line: 163 -- upvalues: u178 (ref), SceneLighting (val)
    u178 = SceneLighting.RestoreMap(nil, u178)
end

local function applySceneLighting(a1) -- Line: 169
    -- upvalues: Lighting (val), u178 (ref), SceneLighting (val)
    local v1 = Lighting:FindFirstChild(a1)
    if not v1 and not (Lighting:FindFirstChild("Menu")) then
        return
    end
    u178 = SceneLighting.ApplyScene(a1, v1)
end

local function getInspectScenesFolder() -- Line: 184 -- upvalues: u161 (ref), ReplicatedStorage (val)
    if u161 then
        return u161
    end
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    if Assets then
        u161 = Assets:WaitForChild("InspectScenes", 10)
    end
    return u161
end

local function getRandomInspectScene() -- Line: 197 -- upvalues: u161 (ref), ReplicatedStorage (val)
    local v1
    if not u161 then
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        if Assets then
            u161 = Assets:WaitForChild("InspectScenes", 10)
        end
    end
    if not u161 then
        return nil
    end
    local v2 = {}
    for i, v in ipairs(v1:GetChildren()) do
        if v:IsA("Model") then
            table.insert(v2, v)
        end
    end
    if #v2 > 0 then
        return v2[math.random(1, #v2)]
    end
    return nil
end

local function activateInspectSceneFlags(a1) -- Line: 216 -- types: a1: userdata
    local csFlag
    for i, v in ipairs(a1:GetDescendants()) do
        csFlag = v:IsA("Model") and v:FindFirstChild("csFlag")
        if csFlag and csFlag:IsA("Model") and not v:HasTag("Flag") then
            v:AddTag("Flag")
        end
    end
end

local function pivotInspectWeapon(a1, a2, a3) -- Line: 228
    -- upvalues: u198 (val), u175 (ref)
    local v1 = a2.CFrame * a3 * u198
    if u175 then
        v1 = v1 * (a1:GetPivot()):ToObjectSpace(u175.WorldCFrame):Inverse()
    end
    a1:PivotTo(v1)
end

local function updateWeaponTransform() -- Line: 239
    -- upvalues: u181 (ref), u183 (ref), u215 (ref), u214 (ref), u198 (val), u175 (ref)
    if u181 and u183 then
        local WeaponPart = u183:FindFirstChild("WeaponPart")
        if WeaponPart then
            local Angles = CFrame.Angles
            local v1 = u181
            local v2 = WeaponPart.CFrame * (Angles(0, math.rad(u215), (math.rad(u214)))) * u198
            if u175 then
                v2 = v2 * (v1:GetPivot()):ToObjectSpace(u175.WorldCFrame):Inverse()
            end
            v1:PivotTo(v2)
        end
        return
    end
end

local function handleDragInput(a1) -- Line: 253 -- upvalues: u217 (ref), u216 (ref) -- types: a1: userdata
    u217 = u217 + a1.X * 0.5
    u216 = math.clamp(u216 + a1.Y * 0.5, -80, 80)
end

local function handleFOVInput(a1) -- Line: 261 -- upvalues: u188 (ref), u213 (ref) -- types: a1: number
    if u188 == "Viewmodel" then
        return
    end
    u213 = math.clamp(u213 - a1 * 2, 20, 70)
end

local function getTouchCount() -- Line: 272 -- upvalues: u270 (ref)
    local v1 = 0
    for k in pairs(u270) do
        v1 = v1 + 1
    end
    return v1
end

local function getPinchDistance() -- Line: 282 -- upvalues: u270 (ref)
    local v1 = {}
    for k, v in pairs(u270) do
        table.insert(v1, v)
    end
    if #v1 >= 2 then
        return (v1[1] - v1[2]).Magnitude
    end
    return nil
end

local function getInspectFrame() -- Line: 295 -- upvalues: MenuState (val)
    local v1 = MenuState.GetMenuFrame()
    return v1 and (v1:FindFirstChild("Inspect") or v1:FindFirstChild("InspectFrame"))
end

local function setMenuBackdrop(a1, a2, a3) -- Line: 302
    -- upvalues: MenuState (val)
    MenuState.SetBlurEnabled(a2)
    a1.BackgroundTransparency = if not a2 then 1 else 0.15
    local Pattern = a1:FindFirstChild("Pattern")
    if Pattern then
        Pattern.Visible = a3
    end
end

local function hideOtherMenuScreens(a1, a2) -- Line: 314 -- types: a1: userdata, a2: string
    for i, v in ipairs(a1:GetChildren()) do
        if v:IsA("Frame")
            and v.Name ~= "Top"
            and v.Name ~= a2
            and v.Name ~= "Inspect"
            and v.Name ~= "InspectFrame" then
            v.Visible = false
        end
    end
end

local function hideMenuFrames() -- Line: 330 -- upvalues: MenuState (val), u180 (ref), MenuSceneController (val)
    local v1
    MenuState.EnterInspect()
    local v2 = MenuState.GetMenuFrame()
    if not v2 then
        return
    end
    u180 = MenuSceneController.IsActive()
    if u180 then
        MenuSceneController.HideMenuScene(true)
        MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5)
    end
    MenuState.SetBlurEnabled(false)
    v2.BackgroundTransparency = 1
    local Pattern = v2:FindFirstChild("Pattern")
    if Pattern then
        Pattern.Visible = false
    end
    local Top = v2:FindFirstChild("Top")
    if Top then
        Top.Visible = false
    end
    for i, v in ipairs(v2:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "Top" then
            v1 = true
            if v.Name ~= "Inspect" then
                v1 = v.Name == "InspectFrame"
            end
            v.Visible = v1
        end
    end
end

local function getFloatPreviewClosedPosition(a1, a2) -- Line: 361 -- types: a1: userdata, a2: userdata
    local Position = a1.Position
    return UDim2.new(-(a1.Size.X.Scale * a2.Position.X.Scale), -(a1.Size.X.Offset + a2.Position.X.Offset), Position.Y.Scale, Position.Y.Offset)
end

local function setFloatPreviewArrowDirection(a1, a2) -- Line: 371 -- types: a1: userdata, a2: boolean
    local TextLabel = a1:FindFirstChild("TextLabel")
    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Rotation = if not a2 then 180 else 0
    end
end

local function storeFloatPreviewOpenPosition(a1) -- Line: 380 -- types: a1: userdata
    local Position = a1.Position
    a1:SetAttribute("OpenPositionXScale", Position.X.Scale)
    a1:SetAttribute("OpenPositionXOffset", Position.X.Offset)
    a1:SetAttribute("OpenPositionYScale", Position.Y.Scale)
    a1:SetAttribute("OpenPositionYOffset", Position.Y.Offset)
end

local function getStoredFloatPreviewOpenPosition(a1) -- Line: 390 -- types: a1: userdata
    return UDim2.new(
        a1:GetAttribute("OpenPositionXScale") or a1.Position.X.Scale,
        a1:GetAttribute("OpenPositionXOffset") or a1.Position.X.Offset,
        a1:GetAttribute("OpenPositionYScale") or a1.Position.Y.Scale,
        a1:GetAttribute("OpenPositionYOffset") or a1.Position.Y.Offset
    )
end

local function bindClickButton(a1, a2, a3) -- Line: 401
    -- upvalues: ActivateButton (val)
    local v1 = a1:FindFirstChild(a2)
    if v1 and v1:IsA("GuiButton") then
        ActivateButton(v1)
        v1.MouseButton1Click:Connect(a3)
    end
end

local function initializeInspectButtons() -- Line: 411
    -- upvalues: MenuState (val), ActivateButton (val), CloseButtonRegistry (val), u0 (val)
    -- upvalues: storeFloatPreviewOpenPosition (val), getFloatPreviewClosedPosition (val), TweenService (val)
    -- upvalues: u238 (val), DataController (val), LocalPlayer (val), Mobile (val), ApplyMobileButtonLayout (val)
    -- upvalues: Router (val)
    local v1 = MenuState.GetMenuFrame()
    local v2 = v1 and (v1:FindFirstChild("Inspect") or v1:FindFirstChild("InspectFrame"))
    local Bottom = v2 and v2:FindFirstChild("Bottom")
    if not Bottom then
        return
    end
    local Close = Bottom.Container.Buttons:FindFirstChild("Close")
    if Close and Close:IsA("GuiButton") then
        ActivateButton(Close)
        CloseButtonRegistry.Add(v2, Close, function() -- Line: 421 -- upvalues: u0 (upval)
            u0.HideInspect()
        end)
    end
    local Middle = Bottom:FindFirstChild("Middle")
    local Buttons = Middle and Middle:FindFirstChild("Buttons")
    if Buttons then
        local v3
        for i, v in ipairs({"Viewmodel", "Weapon"}) do
            v3 = Buttons:FindFirstChild(v)
            if v3 and v3:IsA("GuiButton") then
                ActivateButton(v3)
            end
        end
    end
    local FloatPreviews = v2:FindFirstChild("FloatPreviews")
    if FloatPreviews then
        FloatPreviews.Visible = false
        local ToggleButton = FloatPreviews:FindFirstChild("ToggleButton")
        if ToggleButton and ToggleButton:IsA("GuiButton") then
            ActivateButton(ToggleButton)
            storeFloatPreviewOpenPosition(FloatPreviews)
            local Position = FloatPreviews.Position
            local u105 = getFloatPreviewClosedPosition(FloatPreviews, ToggleButton)
            FloatPreviews:SetAttribute("IsOpen", true)
            local TextLabel = ToggleButton:FindFirstChild("TextLabel")
            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Rotation = 0
            end
            local u120 = nil
            ToggleButton.Activated:Connect(function() -- Line: 452
                -- upvalues: FloatPreviews (val), ToggleButton (val), u120 (ref), TweenService (upval), u238 (upval)
                -- upvalues: Position (val), u105 (val)
                local v1
                FloatPreviews:SetAttribute("IsOpen", FloatPreviews:GetAttribute("IsOpen") == false)
                local TextLabel = ToggleButton:FindFirstChild("TextLabel")
                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.Rotation = if not v1 then 180 else 0
                end
                if u120 then
                    u120:Cancel()
                end
                local v2 = TweenService:Create(FloatPreviews, u238, {Position = if not v1 then u105 else Position})
                u120 = v2
                v2:Play()
            end)
        end
    end
    local MobileButtons = v2:FindFirstChild("MobileButtons")
    if MobileButtons then
        local Inspect = MobileButtons:FindFirstChild("Inspect")
        if Inspect and Inspect:IsA("TextButton") then
            ActivateButton(Inspect)
            Inspect.MouseButton1Click:Connect(function() -- Line: 476 -- upvalues: u0 (upval)
                u0.PlayInspectAnimation()
            end)
            local Inspect_2 = Mobile.SanitizeLayout((DataController.Get(LocalPlayer, "MobileButtons"))).Inspect
            if Inspect_2 then
                ApplyMobileButtonLayout(Inspect, Inspect_2)
            end
        end
        MobileButtons.Visible = false
    end
    local Charm = Bottom.Middle:FindFirstChild("Charm")
    if Charm then
        local Next = Charm:FindFirstChild("Next")
        if Next and Next:IsA("GuiButton") then
            ActivateButton(Next)
            Next.MouseButton1Click:Connect(function() -- Line: 492 -- upvalues: u0 (upval)
                u0.CycleCharmPosition()
            end)
        end
        local Confirm = Charm:FindFirstChild("Confirm")
        if Confirm and Confirm:IsA("GuiButton") then
            ActivateButton(Confirm)
            Confirm.MouseButton1Click:Connect(function() -- Line: 495 -- upvalues: Router (upval)
                Router.broadcastRouter("ConfirmCharmAttachment")
            end)
        end
    end
end

local function updateInspectMobileButtonsVisibility() -- Line: 503
    -- upvalues: MenuState (val), u191 (ref), u188 (ref), u158 (val)
    local v1 = MenuState.GetMenuFrame()
    local v2 = v1 and (v1:FindFirstChild("Inspect") or v1:FindFirstChild("InspectFrame"))
    local MobileButtons = v2 and v2:FindFirstChild("MobileButtons")
    local Inspect = MobileButtons and MobileButtons:FindFirstChild("Inspect")
    if not Inspect then
        return
    end
    local v3 = u191
    if v3 then
        v3 = false
        if u188 == "Viewmodel" then
            v3 = u158
        end
    end
    MobileButtons.Visible = v3
    Inspect.Visible = v3
end

local u311 = {
    {Name = "Inspect", Action = "Inspect", Title = "Inspect"},
    {Name = "Cancel", Action = "Reload", Title = "Cancel"},
}

local function refreshInspectTips() -- Line: 527
    -- upvalues: MenuState (val), ReplicatedStorage (val), u191 (ref), u188 (ref), UserInputService (val), u311 (val)
    local v1 = MenuState.GetMenuFrame()
    local v2 = v1 and (v1:FindFirstChild("Inspect") or v1:FindFirstChild("InspectFrame"))
    local Tips = v2 and v2:FindFirstChild("Tips")
    if Tips and Tips:IsA("GuiObject") then
        local Keybind, Title, v3, v4
        local Tips_2 = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Tips)
        if not Tips:GetAttribute("Mirrored") then
            Tips:SetAttribute("Mirrored", true)
            Tips.AnchorPoint = Vector2.new(1, Tips.AnchorPoint.Y)
            local UIListLayout = Tips:FindFirstChildOfClass("UIListLayout")
            if UIListLayout then
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            end
            for i, j in Tips:GetChildren() do
                if j:IsA("GuiObject") then
                    Tips_2.MirrorRow(j)
                end
            end
        end
        local v5 = u191
        if v5 then
            v5 = false
            if u188 == "Viewmodel" then
                v5 = UserInputService.PreferredInput ~= Enum.PreferredInput.Touch
            end
        end
        local v6 = false
        local v7 = nil
        local v8 = nil
        for k, n in u311, v7, v8 do
            v3 = Tips:FindFirstChild(n.Name)
            if v3 and v3:IsA("GuiObject") then
                Title = v3:FindFirstChild("Title")
                if Title and Title:IsA("TextLabel") then
                    Title.Text = n.Title
                end
                Keybind = v3:FindFirstChild("Keybind")
                if Keybind and Keybind:IsA("GuiObject") then
                    Keybind.Selectable = false
                end
                v4 = v5
                if v4 then
                    v4 = false
                    if Keybind ~= nil then
                        v4 = Keybind:IsA("GuiButton") and Tips_2.ApplyBindingToKeybind(Keybind, Tips_2.ResolveActionBinding(n.Action))
                    end
                end
                v3.Visible = v4
                v6 = v6 or v4
            end
        end
        Tips.Visible = v6
        return
    end
end

local function updateCharmFrameVisibility() -- Line: 586 -- upvalues: MenuState (val), Router (val)
    local v1 = MenuState.GetMenuFrame()
    local v2 = v1 and (v1:FindFirstChild("Inspect") or v1:FindFirstChild("InspectFrame"))
    local Bottom = v2 and v2:FindFirstChild("Bottom")
    if not Bottom then
        return
    end
    local Charm = Bottom.Middle:FindFirstChild("Charm")
    local Buttons = Bottom.Middle:FindFirstChild("Buttons")
    if Charm then
        Charm.Visible = Router.broadcastRouter("HasPendingCharmAttachment") or false
        Buttons.Visible = not Charm.Visible
    end
end

local function getItemClass(a1) -- Line: 604 -- upvalues: GetWeaponProperties (val)
    if a1.Name then
        local success, result = pcall(GetWeaponProperties, a1.Name)
        if success and result then
            return result.Class
        end
    end
    return nil
end

local function isGloveInventoryItem(a1) -- Line: 616 -- upvalues: GetWeaponProperties (val)
    local v1 = false
    if a1 ~= nil then
        v1 = true
        if a1.Type ~= "Glove" then
            local Class
            if not a1.Name then
                Class = nil
            else
                local success, result = pcall(GetWeaponProperties, a1.Name)
                Class = if not success then nil else if not result then nil else result.Class
            end
            v1 = Class == "Glove"
        end
    end
    return v1
end

local function supportsViewmodelInspect(a1) -- Line: 622 -- upvalues: u205 (val), GetWeaponProperties (val)
    local v1 = true
    if u205[a1.Type] ~= true then
        local Class
        if not a1.Name then
            Class = nil
        else
            local success, result = pcall(GetWeaponProperties, a1.Name)
            Class = if not success then nil else if not result then nil else result.Class
        end
        v1 = u205[Class] == true
    end
    return v1
end

local function cleanupGloveViewmodelInspectAnimation() -- Line: 629 -- upvalues: u172 (ref), u173 (ref)
    if u172 then
        if u172.IsPlaying then
            u172:Stop(0)
        end
        u172:Destroy()
        u172 = nil
    end
    if u173 then
        u173:Destroy()
        u173 = nil
    end
end

local function playGloveViewmodelInspectAnimation() -- Line: 646 -- upvalues: u172 (ref), u174 (ref)
    if not u172 then
        return
    end
    if u174 and u174.Animation then
        u174.Animation:stopAnimations()
    end
    if u172.IsPlaying then
        u172:Stop(0)
    end
    u172.TimePosition = 0
    u172:Play(0, 1, 1)
end

local function setupGloveViewmodelInspectAnimation() -- Line: 665 -- upvalues: u172 (ref), u173 (ref), u174 (ref)
    if u172 then
        if u172.IsPlaying then
            u172:Stop(0)
        end
        u172:Destroy()
        u172 = nil
    end
    if u173 then
        u173:Destroy()
        u173 = nil
    end
    if u174 and u174.Animation then
        local Animator = u174.Animation.Animator
        if not Animator then
            return
        end
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://135926544677482"
        local success, result = pcall(function() -- Line: 680 -- upvalues: Animator (val), Animation (val)
            return Animator:LoadAnimation(Animation)
        end)
        if success and result then
            u173 = Animation
            u172 = result
            if not u172 then
                return
            end
            if u174 and u174.Animation then
                u174.Animation:stopAnimations()
            end
            if u172.IsPlaying then
                u172:Stop(0)
            end
            u172.TimePosition = 0
            u172:Play(0, 1, 1)
            return
        end
        Animation:Destroy()
        return
    end
end

local function resolveInspectViewmodelSkin(a1, a2) -- Line: 697
    -- upvalues: Skins (val)
    local v1 = a2 and not (a2 == "") and a2 or "Vanilla"
    for i, v in ipairs({v1, "Vanilla", "Default"}) do
        if Skins.GetSkinInformation(a1, v) then
            return v
        end
    end
    local v2 = Skins.GetAllSkinsForWeapon(a1)
    if v2 and v2[1] and v2[1].skin then
        return v2[1].skin
    end
    return v1
end

local function resolveGloveProxyWeapon() -- Line: 715 -- upvalues: u199 (val), Skins (val)
    local v1
    for i, v in ipairs(u199) do
        v1 = Skins.GetBaseWeaponModel(v, "Camera")
        if v1 then
            v1:Destroy()
            return v
        end
    end
    return "FAMAS"
end

local function clearViewmodelHorizontalOffset(a1) -- Line: 730
    local Stats = a1.Model:FindFirstChild("Stats")
    local Default = Stats and Stats:FindFirstChild("Default")
    local Value = Default and Default.Value
    if typeof(Value) == "Vector3" then
        Default.Value = Vector3.new(0.05, Value.Y, Value.Z)
    end
end

local function cleanupWeaponInspect() -- Line: 742 -- upvalues: u181 (ref), u175 (ref)
    if u181 then
        u181:Destroy()
        u181 = nil
    end
    u175 = nil
end

local function cleanupViewmodelInspect() -- Line: 750
    -- upvalues: u172 (ref), u173 (ref), u174 (ref), u177 (ref), InputController (val)
    if u172 then
        if u172.IsPlaying then
            u172:Stop(0)
        end
        u172:Destroy()
        u172 = nil
    end
    if u173 then
        u173:Destroy()
        u173 = nil
    end
    if u174 then
        u174:destroy()
        u174 = nil
    end
    if u177 then
        u177:Destroy()
        u177 = nil
    end
    InputController.enableGroup("Gameplay")
end

local function cleanupInspectMode() -- Line: 765
    -- upvalues: u188 (ref), u181 (ref), u175 (ref), u172 (ref), u173 (ref), u174 (ref), u177 (ref)
    -- upvalues: InputController (val)
    if u188 == "Weapon" then
        if u181 then
            u181:Destroy()
            u181 = nil
        end
        u175 = nil
        return
    end
    if u188 == "Viewmodel" then
        if u172 then
            if u172.IsPlaying then
                u172:Stop(0)
            end
            u172:Destroy()
            u172 = nil
        end
        if u173 then
            u173:Destroy()
            u173 = nil
        end
        if u174 then
            u174:destroy()
            u174 = nil
        end
        if u177 then
            u177:Destroy()
            u177 = nil
        end
        InputController.enableGroup("Gameplay")
    end
end

local function prepareInspectWeapon(a1, a2) -- Line: 775
    -- upvalues: u181 (ref), u175 (ref)
    local v1
    a1.Name = "InspectWeapon"
    u181 = a1
    u175 = a1:FindFirstChild("InspectPivot", true)
    local CharmBase = a1:FindFirstChild("CharmBase", true)
    local v2, v3 = a2, a1
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CastShadow = false
            if v2 then
                v.CanCollide = false
                v.CanQuery = false
                v.CanTouch = false
                v1 = v3.PrimaryPart == v
                v.Anchored = v1
            elseif not CharmBase or not v:IsDescendantOf(CharmBase) then
                v.CanCollide = v:IsA("MeshPart")
                v.CanQuery = false
                v.CanTouch = false
                v.Anchored = true
            else
                v.Anchored = false
            end
        end
    end
end

local function setupWeaponInspect(a1) -- Line: 805
    -- upvalues: u183 (ref), Skins (val), prepareInspectWeapon (val), u198 (val), u175 (ref)
    local v1, v2
    if not u183 then
        return
    end
    local WeaponPart = u183:FindFirstChild("WeaponPart")
    if not WeaponPart then
        warn("[InspectController]: Inspect scene missing WeaponPart")
        return
    end
    local v3 = a1.Type == "Glove"
    local v4 = a1.Type == "Charm"
    if not v3 then
        v1 = if not v4 then if a1.Type ~= "Badge" then Skins.GetCharacterModel(a1.Name, a1.Skin, a1.Float, a1.StatTrack, a1.NameTag, a1.Charm, a1.Stickers) else Skins.GetBadgeModel(a1.Skin) else Skins.GetCharmModel(a1.Skin, a1.Pattern or 1)
    else
        v2 = Skins.GetGloves(a1.Name, a1.Skin, a1.Float)
        if not v2 or not v2:IsA("BasePart") then
            v1 = v2
        else
            local Model = Instance.new("Model")
            Model.Name = a1.Name
            v2.Parent = Model
            Model.PrimaryPart = v2
            v1 = Model
        end
    end
    if not v1 then
        warn(("[InspectController]: Failed to get model for \"%*\""):format(a1.Name), a1)
        return
    end
    prepareInspectWeapon(v1, v4)
    if v3 then
        local RightGlove
        if a1.Name == "T Glove" then
            v2 = {}
            for i, v in ipairs(v1:GetChildren()) do
                if v:IsA("BasePart") then
                    table.insert(v2, v)
                end
            end
            if #v2 >= 2 then
                RightGlove = v1:FindFirstChild("RightGlove") or v2[1]
                for i2, i3 in ipairs(v2) do
                    if i3 ~= RightGlove then
                        i3:Destroy()
                    end
                end
            end
        elseif a1.Name == "CT Glove" then
            v2 = {}
            for i4, j in ipairs(v1:GetChildren()) do
                if j:IsA("BasePart") then
                    table.insert(v2, j)
                end
            end
            if #v2 >= 2 then
                RightGlove = v1:FindFirstChild("RightGlove") or v2[1]
                for i5, k in ipairs(v2) do
                    if k ~= RightGlove then
                        k:Destroy()
                    end
                end
            end
        end
    end
    v1.Parent = u183
    local v5 = WeaponPart.CFrame * CFrame.identity * u198
    if u175 then
        v5 = v5 * (v1:GetPivot()):ToObjectSpace(u175.WorldCFrame):Inverse()
    end
    v1:PivotTo(v5)
end

local function setupViewmodelInspect(a1) -- Line: 877
    -- upvalues: u172 (ref), u173 (ref), u174 (ref), u177 (ref), InputController (val), LocalPlayer (val)
    -- upvalues: GetWeaponProperties (val), MenuSceneController (val), HttpService (val), Router (val), u273 (ref)
    -- upvalues: resolveGloveProxyWeapon (val), resolveInspectViewmodelSkin (val), Viewmodel (val), CurrentCamera (val)
    -- upvalues: setupGloveViewmodelInspectAnimation (val), u206 (val)
    local u135
    if u172 then
        if u172.IsPlaying then
            u172:Stop(0)
        end
        u172:Destroy()
        u172 = nil
    end
    if u173 then
        u173:Destroy()
        u173 = nil
    end
    if u174 then
        u174:destroy()
        u174 = nil
    end
    if u177 then
        u177:Destroy()
        u177 = nil
    end
    InputController.enableGroup("Gameplay")
    local v1 = false
    if a1 ~= nil then
        v1 = true
        if a1.Type ~= "Glove" then
            local Class
            if not a1.Name then
                Class = nil
            else
                local success, result = pcall(GetWeaponProperties, a1.Name)
                Class = if not success then nil else if not result then nil else result.Class
            end
            v1 = Class == "Glove"
        end
    end
    local v2 = MenuSceneController.CreateStandaloneCharacter(if LocalPlayer:GetAttribute("Team") ~= "Counter-Terrorists" then "T" else "CT")
    if not v2 then
        warn("[InspectController]: Failed to create standalone character for viewmodel")
        return
    end
    if v1 then
        local v3 = {Name = a1.Name, Skin = a1.Skin, Float = a1.Float}
        if a1._id and a1._id ~= "" then
            v3.SkinIdentifier = a1._id
        end
        v2:SetAttribute("EquippedGloves", (HttpService:JSONEncode(v3)))
    end
    u177 = v2
    local Charm = a1.Charm
    if Router.broadcastRouter("HasPendingCharmAttachment") and type(Charm) == "table" then
        Charm = {_id = Charm._id, Position = tostring(u273)}
    end
    local u113 = {
        Player = LocalPlayer,
        Character = v2,
        StatTrack = a1.StatTrack,
        Stickers = a1.Stickers,
        NameTag = a1.NameTag,
        Float = a1.Float,
        Charm = Charm,
    }
    local Name = a1.Name
    if not v1 then
        u135 = resolveInspectViewmodelSkin(Name, a1.Skin)
    else
        Name = resolveGloveProxyWeapon()
        u135 = "Stock"
    end
    u113.ViewmodelCameraWeapon = Name
    u113.ViewmodelHideWeaponGeometry = v1
    local success_2, result_2 = pcall(function() -- Line: 939 -- upvalues: Viewmodel (upval), u113 (val), a1 (val), u135 (ref)
        return Viewmodel.new(u113, a1.Name, u135, true)
    end)
    if success_2 and result_2 then
        u174 = result_2
        u174:equip(v1)
        if not u174.Model then
            return
        end
        if u174.Model.Parent ~= CurrentCamera then
            u174.Model.Parent = CurrentCamera
        end
        if u174.Hidden then
            u174:unhide()
        end
        if v1 then
            local Stats = u174.Model:FindFirstChild("Stats")
            local Default = Stats and Stats:FindFirstChild("Default")
            local Value = Default and Default.Value
            if typeof(Value) == "Vector3" then
                Default.Value = Vector3.new(0.05, Value.Y, Value.Z)
            end
            setupGloveViewmodelInspectAnimation()
        end
        task.defer(function() -- Line: 971 -- upvalues: u174 (upval), u206 (upval)
            if u174 and u174.Model then
                local v1, v2
                for i, v in ipairs(u174.Model:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CastShadow = false
                        v1 = true
                        if v.Name ~= "HumanoidRootPart" then
                            v1 = true
                            if v.Name ~= "ViewmodelLight" then
                                v1 = true
                                if v.Name ~= "MuzzlePart" then
                                    v1 = true
                                    if v.Name ~= "MuzzlePartL" then
                                        v1 = v.Name == "MuzzlePartR"
                                    end
                                end
                            end
                        end
                        if not v1 then
                            v2 = nil
                            for i2, i3 in ipairs(u206) do
                                v2 = v:GetAttribute(i3)
                                if v2 ~= nil then
                                    v:SetAttribute(i3, nil)
                                    break
                                end
                            end
                            if v2 ~= nil then
                                v.Transparency = v2
                            elseif 1 <= v.Transparency then
                                if v.Name == "Right Arm" or v.Name == "Left Arm" then
                                    v.Transparency = 0
                                end
                            end
                        end
                    elseif v:IsA("SurfaceGui") then
                        if v:GetAttribute("_InspectPrevSurfaceGuiEnabled") then
                            v:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil)
                        end
                        if v:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") then
                            v:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil)
                        end
                        v.Enabled = true
                    end
                end
                return
            end
        end)
        return
    end
    warn(("[InspectController]: Failed to create viewmodel (%* | %*)"):format(Name, u135), result_2)
    if u172 then
        if u172.IsPlaying then
            u172:Stop(0)
        end
        u172:Destroy()
        u172 = nil
    end
    if u173 then
        u173:Destroy()
        u173 = nil
    end
    if u174 then
        u174:destroy()
        u174 = nil
    end
    if u177 then
        u177:Destroy()
        u177 = nil
    end
    InputController.enableGroup("Gameplay")
end

local function applyInspectMode(a1) -- Line: 1018
    -- upvalues: u176 (ref), u188 (ref), u181 (ref), u175 (ref), u172 (ref), u173 (ref), u174 (ref), u177 (ref)
    -- upvalues: InputController (val), MenuState (val), u191 (ref), u158 (val), refreshInspectTips (val)
    -- upvalues: setupWeaponInspect (val), u213 (ref), setupViewmodelInspect (val), DEFAULT_CAMERA_FOV (val)
    local v1 = u176
    if not v1 then
        return
    end
    if u188 == "Weapon" then
        if u181 then
            u181:Destroy()
            u181 = nil
        end
        u175 = nil
    elseif u188 == "Viewmodel" then
        if u172 then
            if u172.IsPlaying then
                u172:Stop(0)
            end
            u172:Destroy()
            u172 = nil
        end
        if u173 then
            u173:Destroy()
            u173 = nil
        end
        if u174 then
            u174:destroy()
            u174 = nil
        end
        if u177 then
            u177:Destroy()
            u177 = nil
        end
        InputController.enableGroup("Gameplay")
    end
    local v2 = MenuState.GetMenuFrame()
    local v3 = v2 and (v2:FindFirstChild("Inspect") or v2:FindFirstChild("InspectFrame"))
    local MobileButtons = v3 and v3:FindFirstChild("MobileButtons")
    local Inspect = MobileButtons and MobileButtons:FindFirstChild("Inspect")
    if Inspect then
        local v4 = u191
        if v4 then
            v4 = false
            if a1 == "Viewmodel" then
                v4 = u158
            end
        end
        MobileButtons.Visible = v4
        Inspect.Visible = v4
    end
    refreshInspectTips()
    if a1 == "Weapon" then
        setupWeaponInspect(v1)
        u213 = 40
        InputController.enableGroup("Gameplay")
        return
    end
    if a1 == "Viewmodel" then
        InputController.disableGroup("Gameplay")
        setupViewmodelInspect(v1)
        u213 = DEFAULT_CAMERA_FOV
    end
end

local function setInspectMode(a1) -- Line: 1043
    -- upvalues: u176 (ref), GetWeaponProperties (val), u188 (ref), u189 (ref), u190 (ref), applyInspectMode (val)
    -- upvalues: u191 (ref)
    local result_2, success_2
    local v1 = u176
    if not v1 then
        return
    end
    local v2 = false
    if v1 ~= nil then
        v2 = true
        if v1.Type ~= "Glove" then
            local Class
            if not v1.Name then
                Class = nil
            else
                local success, result = pcall(GetWeaponProperties, v1.Name)
                Class = if not success then nil else if not result then nil else result.Class
            end
            v2 = Class == "Glove"
        end
    end
    if v2 and a1 == "Weapon" then
        a1 = "Viewmodel"
    end
    if u188 == a1 then
        return
    end
    if u189 then
        u190 = a1
        return
    end
    u189 = true
    v2 = a1
    while v2 do
        success_2, result_2 = pcall(applyInspectMode, v2)
        if not success_2 then
            warn(("[InspectController]: Failed to apply inspect mode \"%*\""):format(v2), result_2)
        end
        v2 = u190
        u190 = nil
        if v2 == u188 or not u191 then
            v2 = nil
        end
    end
    u189 = false
end

local function tween(a1, a2) -- Line: 1085 -- upvalues: TweenService (val)
    if a1 then
        TweenService:Create(a1, TweenInfo.new(0.2), a2):Play()
    end
end

local function updateButtonVisuals(a1, a2, a3) -- Line: 1091
    -- upvalues: u188 (ref), TweenService (val)
    local v1
    local HoverFrame = a2:FindFirstChild("HoverFrame")
    local SelectFrame = a2:FindFirstChild("SelectFrame")
    local ImageLabel = a2:FindFirstChild("ImageLabel")
    local v2 = false
    if u188 == a1 then
        v2 = a1 ~= "Info"
    end
    if not v2 then
        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
        v1 = {ImageColor3 = Color3.fromRGB(255, 255, 255)}
        if ImageLabel then
            TweenService:Create(ImageLabel, TweenInfo.new(0.2), v1):Play()
        end
        v1 = {BackgroundTransparency = if not a3 then 1 else 0}
        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v1):Play()
        end
        return
    end
    if HoverFrame then
        TweenService:Create(HoverFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end
    v1 = {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(95, 95, 95)}
    if SelectFrame then
        TweenService:Create(SelectFrame, TweenInfo.new(0.2), v1):Play()
    end
    v1 = {ImageColor3 = Color3.fromRGB(210, 210, 210)}
    if not ImageLabel then
        return
    end
    TweenService:Create(ImageLabel, TweenInfo.new(0.2), v1):Play()
end

local function refreshAllButtons(a1, a2) -- Line: 1109
    -- upvalues: updateButtonVisuals (val)
    local v1
    for k, v in pairs(a1) do
        if v and v:IsA("GuiButton") then
            v1 = k == a2
            updateButtonVisuals(k, v, v1)
        end
    end
end

local function formatInfoText(a1, a2) -- Line: 1117 -- types: a1: string, a2: string
    return (("<b><font color=\"rgb(175,175,175)\">%*</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(a1, a2))
end

local function scaleInfoFrameToFit(a1, a2) -- Line: 1121
    -- upvalues: CurrentCamera (val), TextService (val)
    local TextSize
    local v1 = math.clamp(math.floor(CurrentCamera.ViewportSize.Y * 0.025), 8, 32)
    local X = 0
    local v2 = a1
    for i, v in ipairs(a2) do
        if v and v:IsA("TextLabel") and v.Text ~= "" then
            v.TextScaled = false
            TextSize = TextService:GetTextSize(v.Text:gsub("<[^>]*>", ""), v1, Enum.Font.Gotham, (Vector2.new((1 / 0), (1 / 0))))
            if X < TextSize.X then
                X = TextSize.X
            end
            v.TextSize = v1
            v.TextWrapped = false
        end
    end
    if X > 0 then
        v2.Size = UDim2.new(0.05, X, v2.Size.Y.Scale, v2.Size.Y.Offset)
    end
end

local function showInfoFrame(a1, a2, a3) -- Line: 1150
    -- upvalues: Skins (val), scaleInfoFrameToFit (val)
    local Information = a1:FindFirstChild("Information")
    if not Information then
        return
    end
    if a3 then
        Information.Position = UDim2.new(
            0,
            a3.AbsolutePosition.X + a3.AbsoluteSize.X / 2 - Information.Parent.AbsolutePosition.X + Information.AbsoluteSize.X / 2,
            Information.Position.Y.Scale,
            Information.Position.Y.Offset
        )
    end
    Information.Visible = true
    local v1 = Skins.GetSkinInformation(a2.Name, a2.Skin)
    local v2 = "Mint Condition"
    if v1 then
        local v3
        _, v3 = Skins.GetWearNameForFloat(v1, a2.Float or 0)
        v2 = v3 or "Mint Condition"
    end
    local v4 = a2.Type == "Charm"
    local Exterior = Information:FindFirstChild("Exterior")
    if Exterior then
        Exterior.Visible = not v4
        if not v4 then
            Exterior.RichText = true
            Exterior.Text = ("<b><font color=\"rgb(175,175,175)\">Exterior</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(v2)
        end
    end
    local Tradeable = Information:FindFirstChild("Tradeable")
    if Tradeable then
        Tradeable.RichText = true
        Tradeable.Text = ("<b><font color=\"rgb(175,175,175)\">Tradeable</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(if not a2.IsTradeable then "No" else "Yes")
    end
    local Serial = Information:FindFirstChild("Serial")
    if Serial then
        Serial.RichText = true
        local Serial_2 = a2.Serial
        Serial.Text = ("<b><font color=\"rgb(175,175,175)\">Serial</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(if typeof(Serial_2) ~= "number" then "N/A" else ("#%*"):format((tostring(Serial_2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))))
    end
    local Pattern = Information:FindFirstChild("Pattern")
    if Pattern then
        if v4 then
            Pattern.Visible = true
            Pattern.RichText = true
            Pattern.Text = ("<b><font color=\"rgb(175,175,175)\">Pattern</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format((tostring(a2.Pattern or 0)))
        elseif not a2.Skin:find("PATTERN") then
            Pattern.Visible = false
        else
            local v5
            _, v5 = table.unpack((a2.Skin:split("_PATTERN_")))
            Pattern.Text = ("<b><font color=\"rgb(175,175,175)\">Pattern</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(v5)
            Pattern.Visible = true
        end
    end
    local Float = Information:FindFirstChild("Float")
    if Float then
        Float.Visible = not v4
        if not v4 then
            Float.RichText = true
            Float.Text = ("<b><font color=\"rgb(175,175,175)\">Float</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format((string.format("%.14f", a2.Float or 0)))
        end
    end
    task.defer(function() -- Line: 1230
        -- upvalues: Exterior (val), Tradeable (val), Serial (val), Pattern (val), Float (val)
        -- upvalues: scaleInfoFrameToFit (upval), Information (val)
        local v1 = {}
        if Exterior and Exterior.Visible then
            table.insert(v1, Exterior)
        end
        if Tradeable then
            table.insert(v1, Tradeable)
        end
        if Serial then
            table.insert(v1, Serial)
        end
        if Pattern and Pattern.Visible then
            table.insert(v1, Pattern)
        end
        if Float and Float.Visible then
            table.insert(v1, Float)
        end
        scaleInfoFrameToFit(Information, v1)
    end)
end

local function hideInfoFrame(a1) -- Line: 1252 -- types: a1: userdata
    local Information = a1:FindFirstChild("Information")
    if Information then
        Information.Visible = false
    end
end

local function isStoreOriginInspect() -- Line: 1260 -- upvalues: MenuState (val), PlayerGui (val)
    if not MenuState.IsCaseSceneActive()
        and MenuState.GetScreenBeforeCaseScene() ~= "Store"
        and MenuState.GetCurrentScreen() ~= "Store" then
        local MainGui = PlayerGui:FindFirstChild("MainGui")
        local Menu = MainGui and MainGui:FindFirstChild("Menu")
        local Store = Menu and Menu:FindFirstChild("Store")
        local CaseContent = Store and Store:FindFirstChild("CaseContent")
        local v1 = false
        if CaseContent ~= nil then
            v1 = CaseContent:GetAttribute("WasVisibleBeforeInspect") == true
        end
        return v1
    end
    return true
end

local function shouldHideInfoButton() -- Line: 1277 -- upvalues: isStoreOriginInspect (val)
    return (isStoreOriginInspect())
end

local function tryShowInfoFrame(a1, a2) -- Line: 1281
    -- upvalues: u176 (ref), isStoreOriginInspect (val), showInfoFrame (val)
    if a1 and u176 and not isStoreOriginInspect() and u176.Type ~= "Badge" then
        showInfoFrame(a1, u176, a2)
    end
end

local function setupButtonEvents(a1, a2, a3, a4) -- Line: 1287
    -- upvalues: u187 (val), updateButtonVisuals (val), u176 (ref), isStoreOriginInspect (val), showInfoFrame (val)
    -- upvalues: u188 (ref), setInspectMode (val), refreshAllButtons (val)
    u187:Add(a1.MouseEnter:Connect(function() -- Line: 1294
        -- upvalues: updateButtonVisuals (upval), a2 (val), a1 (val), a4 (val), u176 (upval)
        -- upvalues: isStoreOriginInspect (upval), showInfoFrame (upval)
        updateButtonVisuals(a2, a1, true)
        if a2 == "Info" then
            local v1 = a4
            if v1 and u176 and not isStoreOriginInspect() and u176.Type ~= "Badge" then
                showInfoFrame(v1, u176, a1)
            end
        end
    end), "Disconnect", "InspectButton_Enter_" .. a2)
    u187:Add(a1.MouseLeave:Connect(function() -- Line: 1305 -- upvalues: updateButtonVisuals (upval), a2 (val), a1 (val), a4 (val)
        updateButtonVisuals(a2, a1, false)
        if a2 == "Info" and a4 then
            local Information = a4:FindFirstChild("Information")
            if Information then
                Information.Visible = false
            end
        end
    end), "Disconnect", "InspectButton_Leave_" .. a2)
    if a2 == "Info" then
        u187:Add(a1.Activated:Connect(function() -- Line: 1317
            -- upvalues: a4 (val), a1 (val), u176 (upval), isStoreOriginInspect (upval), showInfoFrame (upval)
            local v1 = a4
            if v1 and u176 and not isStoreOriginInspect() and u176.Type ~= "Badge" then
                showInfoFrame(v1, u176, a1)
            end
        end), "Disconnect", "InspectButton_Activated_Info")
        return
    end
    u187:Add(a1.MouseButton1Click:Connect(function() -- Line: 1325
        -- upvalues: u188 (upval), a2 (val), setInspectMode (upval), refreshAllButtons (upval), a3 (val)
        if u188 ~= a2 then
            setInspectMode(a2)
            refreshAllButtons(a3, a2)
        end
    end), "Disconnect", "InspectButton_Click_" .. a2)
end

local function setupInspectButtons(a1, a2) -- Line: 1339
    -- upvalues: u205 (val), GetWeaponProperties (val), isStoreOriginInspect (val), updateButtonVisuals (val)
    -- upvalues: setupButtonEvents (val)
    local Middle = a1:FindFirstChild("Bottom").Middle
    local Buttons = Middle and Middle:FindFirstChild("Buttons")
    if not Buttons then
        return
    end
    local v1 = true
    if u205[a2.Type] ~= true then
        local Class
        if not a2.Name then
            Class = nil
        else
            local success, result = pcall(GetWeaponProperties, a2.Name)
            Class = if not success then nil else if not result then nil else result.Class
        end
        v1 = u205[Class] == true
    end
    local v2 = false
    if a2 ~= nil then
        v2 = true
        if a2.Type ~= "Glove" then
            local Class_2
            if not a2.Name then
                Class_2 = nil
            else
                local success_2, result_2 = pcall(GetWeaponProperties, a2.Name)
                Class_2 = if not success_2 then nil else if not result_2 then nil else result_2.Class
            end
            v2 = Class_2 == "Glove"
        end
    end
    local v3 = {
        Info = Buttons:FindFirstChild("Info"),
        Viewmodel = Buttons:FindFirstChild("Viewmodel"),
        Weapon = Buttons:FindFirstChild("Weapon"),
    }
    local v4 = isStoreOriginInspect()
    local v5 = a2.Type == "Badge"
    for k, v in pairs(v3) do
        if v and v:IsA("GuiButton") then
            if k == "Info" then
                v.Visible = not v4 and not v5
            elseif k ~= "Weapon" then
                v.Visible = v1
            else
                v.Visible = v1 and not v2
            end
            updateButtonVisuals(k, v, false)
            setupButtonEvents(v, k, v3, a1)
        end
    end
end

local function getWearPreviewChance(a1, a2) -- Line: 1377 -- types: a2: string
    local v1 = ipairs
    local floatChances = a1.floatChances or {}
    for i, v in v1(floatChances) do
        if v.wear == a2 then
            return v.chance
        end
    end
    return nil
end

local function formatWearPreviewChance(a1) -- Line: 1387 -- types: a1: number?
    if a1 then
        return (string.format("%.2f%%", a1))
    end
    return ""
end

local function getWearPreviewFloat(a1, a2) -- Line: 1393
    local v1 = math.max(a1.floatRange.min, a2.Min)
    local v2 = math.min(a1.floatRange.max, a2.Max - 1e-12)
    if v2 < v1 then
        return nil
    end
    return (math.clamp((v1 + v2) / 2, 0, 1))
end

local function refreshActiveInspectItem(a1) -- Line: 1405
    -- upvalues: u176 (ref), u188 (ref), u181 (ref), u175 (ref), u172 (ref), u173 (ref), u174 (ref), u177 (ref)
    -- upvalues: InputController (val), setupWeaponInspect (val), setupViewmodelInspect (val)
    u176 = a1
    if u188 == "Weapon" then
        if u181 then
            u181:Destroy()
            u181 = nil
        end
        u175 = nil
    elseif u188 == "Viewmodel" then
        if u172 then
            if u172.IsPlaying then
                u172:Stop(0)
            end
            u172:Destroy()
            u172 = nil
        end
        if u173 then
            u173:Destroy()
            u173 = nil
        end
        if u174 then
            u174:destroy()
            u174 = nil
        end
        if u177 then
            u177:Destroy()
            u177 = nil
        end
        InputController.enableGroup("Gameplay")
    end
    if u188 == "Weapon" then
        setupWeaponInspect(a1)
        return
    end
    if u188 == "Viewmodel" then
        InputController.disableGroup("Gameplay")
        setupViewmodelInspect(a1)
    end
end

local function getStatTrakPreviewChance(a1) -- Line: 1420
    if a1.type ~= "Glove" and a1.supportsStatTrak ~= false then
        return a1.statTrakChance or 0
    end
    return 0
end

local function setKillTrakBadgeVisible(a1, a2) -- Line: 1430 -- types: a1: userdata, a2: boolean
    local v1 = a1
    for i, v in ipairs({"Bottom", "Middle", "Description", "Statrak"}) do
        v1 = v1 and v1:FindFirstChild(v)
    end
    if v1 and v1:IsA("GuiObject") then
        v1.Visible = a2
    end
end

local function updateStatTrakToggle(a1, a2, a3) -- Line: 1443
    -- upvalues: u274 (ref), u187 (val), setKillTrakBadgeVisible (val), u176 (ref), u188 (ref), u181 (ref), u175 (ref)
    -- upvalues: u172 (ref), u173 (ref), u174 (ref), u177 (ref), InputController (val), setupWeaponInspect (val)
    -- upvalues: setupViewmodelInspect (val)
    local KillTrak = a2:FindFirstChild("KillTrak")
    if not KillTrak then
        return
    end
    KillTrak.Visible = a3
    local Button = KillTrak:FindFirstChild("Button")
    if Button and Button:IsA("GuiButton") then
        local CheckmarkImage = Button:FindFirstChild("CheckmarkImage")
        if CheckmarkImage then
            CheckmarkImage.Visible = u274
        end
        u187:Add(Button.Activated:Connect(function() -- Line: 1467
            -- upvalues: u274 (upval), CheckmarkImage (val), setKillTrakBadgeVisible (upval), a1 (val), u176 (upval)
            -- upvalues: u188 (upval), u181 (upval), u175 (upval), u172 (upval), u173 (upval), u174 (upval)
            -- upvalues: u177 (upval), InputController (upval), setupWeaponInspect (upval)
            -- upvalues: setupViewmodelInspect (upval)
            u274 = not u274
            if CheckmarkImage then
                CheckmarkImage.Visible = u274
            end
            setKillTrakBadgeVisible(a1, u274)
            local v1 = u176
            if v1 then
                local v2 = table.clone(v1)
                v2.StatTrack = if not u274 then false else 0
                u176 = v2
                if u188 == "Weapon" then
                    if u181 then
                        u181:Destroy()
                        u181 = nil
                    end
                    u175 = nil
                elseif u188 == "Viewmodel" then
                    if u172 then
                        if u172.IsPlaying then
                            u172:Stop(0)
                        end
                        u172:Destroy()
                        u172 = nil
                    end
                    if u173 then
                        u173:Destroy()
                        u173 = nil
                    end
                    if u174 then
                        u174:destroy()
                        u174 = nil
                    end
                    if u177 then
                        u177:Destroy()
                        u177 = nil
                    end
                    InputController.enableGroup("Gameplay")
                end
                if u188 == "Weapon" then
                    setupWeaponInspect(v2)
                    return
                end
                if u188 == "Viewmodel" then
                    InputController.disableGroup("Gameplay")
                    setupViewmodelInspect(v2)
                end
            end
        end), "Disconnect", "FloatPreview_StatTrakToggle")
        return
    end
end

local function updateFloatPreviewRow(a1, a2, a3, a4, a5) -- Line: 1492
    -- upvalues: u239 (val), Skins (val), Rarities (val)
    a1.Name = a2.Wear
    a1.Visible = true
    a1.LayoutOrder = table.find(u239, a2) or 0
    a1:SetAttribute("Wear", a2.Wear)
    a1:SetAttribute("PreviewFloat", a4)
    local Left = a1:FindFirstChild("Left")
    local Label = Left and Left:FindFirstChild("Label")
    if Label and Label:IsA("TextLabel") then
        Label.Text = a2.Display
        Label.TextColor3 = a2.Color
    end
    local Percent = Left and Left:FindFirstChild("Percent")
    if Percent and Percent:IsA("TextLabel") then
        Percent.Text = if not a5 then "" else string.format("%.2f%%", a5)
    end
    local Bar = a1:FindFirstChild("Bar")
    local Current = Bar and Bar:FindFirstChild("Current")
    if Current and Current:IsA("Frame") then
        local Size = Current.Size
        Current.Size = UDim2.new(math.clamp((a5 or 0) / 100, 0, 1), 0, Size.Y.Scale, Size.Y.Offset)
        Current.BackgroundColor3 = a2.Color
    end
    local Icon = a1:FindFirstChild("Icon", true)
    if Icon and Icon:IsA("ImageLabel") then
        local imageAssetId = Skins.GetWearImageForFloat(a3, a4) or a3.imageAssetId or ""
        Icon.Image = imageAssetId
    end
    local v1 = Rarities[a3.rarity]
    if v1 then
        local RarityFrame = a1:FindFirstChild("RarityFrame", true)
        if RarityFrame and RarityFrame:IsA("Frame") then
            RarityFrame.BackgroundColor3 = v1.Color
        end
        local Rarity = a1:FindFirstChild("Rarity", true)
        if Rarity and Rarity:IsA("ImageLabel") then
            Rarity.ImageColor3 = v1.Color
        end
    end
end

local function updateFloatPreviewFrame(a1, a2, a3) -- Line: 1547
    -- upvalues: getStoredFloatPreviewOpenPosition (val), isStoreOriginInspect (val), u274 (ref)
    -- upvalues: updateStatTrakToggle (val), u239 (val), getWearPreviewChance (val), PreviewTemplate (val)
    -- upvalues: updateFloatPreviewRow (val), u176 (ref), u188 (ref), u181 (ref), u175 (ref), u172 (ref), u173 (ref)
    -- upvalues: u174 (ref), u177 (ref), InputController (val), setupWeaponInspect (val), setupViewmodelInspect (val)
    -- upvalues: ActivateButton (val), u187 (val)
    local FloatPreviews = a1:FindFirstChild("FloatPreviews")
    if not FloatPreviews then
        return
    end
    local Container = FloatPreviews:FindFirstChild("Container")
    if not Container then
        FloatPreviews.Visible = false
        return
    end
    for i, v in ipairs(Container:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    local v1 = false
    if a3 ~= nil then
        v1 = false
        if a2.HideWearDetails == true then
            v1 = a2.Type ~= "Charm"
        end
    end
    FloatPreviews.Visible = v1
    if v1 and a3 then
        local Button, Inspect, v2, v3
        Container.Visible = true
        FloatPreviews.Position = getStoredFloatPreviewOpenPosition(FloatPreviews)
        FloatPreviews:SetAttribute("IsOpen", true)
        local ToggleButton = FloatPreviews:FindFirstChild("ToggleButton")
        if ToggleButton and ToggleButton:IsA("GuiButton") then
            local TextLabel = ToggleButton:FindFirstChild("TextLabel")
            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Rotation = 0
            end
        end
        local v4 = not (a3.type == "Glove") and a3.supportsStatTrak ~= false and a3.statTrakChance or 0
        local v5 = false
        if v4 > 0 then
            v5 = isStoreOriginInspect()
        end
        if not v5 then
            u274 = false
        end
        updateStatTrakToggle(a1, FloatPreviews, v5)
        local v6 = a3
        for i2, i3 in ipairs(u239) do
            v2 = math.max(v6.floatRange.min, i3.Min)
            v3 = math.min(v6.floatRange.max, i3.Max - 1e-12)
            if not (v3 < v2) then
                u128 = math.clamp((v2 + v3) / 2, 0, 1)
            else
                local u128 = nil
            end
            v2 = getWearPreviewChance(v6, i3.Wear)
            if u128 and v2 and not (v2 <= 0) then
                v3 = PreviewTemplate:Clone()
                updateFloatPreviewRow(v3, i3, v6, u128, v2)
                Inspect = v3:FindFirstChild("Inspect")
                if Inspect and Inspect:IsA("GuiObject") then
                    Inspect.Visible = false
                end
                Button = v3:FindFirstChild("Button")
                if Button and Button:IsA("GuiButton") then
                    ActivateButton(Button)
                    u187:Add(Button.Activated:Connect(function() -- Line: 1604
                        -- upvalues: u176 (upval), u128 (val), u188 (upval), u181 (upval), u175 (upval), u172 (upval)
                        -- upvalues: u173 (upval), u174 (upval), u177 (upval), InputController (upval)
                        -- upvalues: setupWeaponInspect (upval), setupViewmodelInspect (upval)
                        local v1 = u176
                        if not v1 then
                            return
                        end
                        local v2 = table.clone(v1)
                        v2.Float = u128
                        v2.HideWearDetails = true
                        v2.ShowFullPriceRange = true
                        u176 = v2
                        if u188 == "Weapon" then
                            if u181 then
                                u181:Destroy()
                                u181 = nil
                            end
                            u175 = nil
                        elseif u188 == "Viewmodel" then
                            if u172 then
                                if u172.IsPlaying then
                                    u172:Stop(0)
                                end
                                u172:Destroy()
                                u172 = nil
                            end
                            if u173 then
                                u173:Destroy()
                                u173 = nil
                            end
                            if u174 then
                                u174:destroy()
                                u174 = nil
                            end
                            if u177 then
                                u177:Destroy()
                                u177 = nil
                            end
                            InputController.enableGroup("Gameplay")
                        end
                        if u188 == "Weapon" then
                            setupWeaponInspect(v2)
                            return
                        end
                        if u188 == "Viewmodel" then
                            InputController.disableGroup("Gameplay")
                            setupViewmodelInspect(v2)
                        end
                    end), "Disconnect", "FloatPreview_Button_" .. i3.Wear)
                end
                v3.Parent = Container
            end
        end
        return
    end
end

local function updateCollectionData(a1, a2) -- Line: 1639
    -- upvalues: Collections (val), u221 (val), u229 (val), u225 (val), u233 (val)
    local collection = a2 and a2.collection
    local v1 = collection and Collections.GetCollectionByName(collection)
    local v2 = v1 ~= nil
    local Collection = a1.Top.Frame.Frame.TextInfo:FindFirstChild("Collection")
    if Collection and Collection:IsA("TextLabel") then
        Collection.Visible = v2
        Collection.Text = collection or ""
    end
    local CollectionIcon = a1.Top.Frame.Frame:FindFirstChild("CollectionIcon")
    if CollectionIcon and CollectionIcon:IsA("ImageLabel") then
        CollectionIcon.Image = v1 and v1.imageAssetId or ""
        CollectionIcon.Visible = v2
    end
    local WeaponName = a1:FindFirstChild("WeaponName")
    if WeaponName and WeaponName:IsA("TextLabel") then
        WeaponName.Position = u221
        WeaponName.Size = if not v2 then u225 else u229
        WeaponName.TextXAlignment = Enum.TextXAlignment.Center
    end
    local Rarity = a1:FindFirstChild("Rarity")
    if Rarity and Rarity:IsA("Frame") then
        Rarity.Position = u233
    end
end

local function updateInspectFrameUI(a1) -- Line: 1670
    -- upvalues: PlayerGui (val), setupInspectButtons (val), isStoreOriginInspect (val), Skins (val)
    -- upvalues: updateFloatPreviewFrame (val), GetSkinDisplayName (val), updateCollectionData (val), Rarities (val)
    local v1
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    local Menu = MainGui and MainGui:FindFirstChild("Menu")
    local Inspect = Menu and (Menu:FindFirstChild("Inspect") or Menu:FindFirstChild("InspectFrame"))
    if not Inspect then
        return
    end
    setupInspectButtons(Inspect, a1)
    if isStoreOriginInspect() then
        local Information = Inspect:FindFirstChild("Information")
        if Information then
            Information.Visible = false
        end
    end
    local v2 = Skins.GetSkinInformation(a1.Name, a1.Skin)
    updateFloatPreviewFrame(Inspect, a1, v2)
    local Item = Inspect.Top.Frame.Frame.TextInfo:FindFirstChild("Item")
    if Item and Item:IsA("TextLabel") then
        local v3 = GetSkinDisplayName(a1.Skin)
        GetSkinDisplayName.ApplyNameLabel(
            Item,
            (if not v2 then "" else if v2.type ~= "Melee" then "" else "★ ") .. (GetSkinDisplayName.GetWeaponDisplayName(a1.Name, a1.NameTag)) .. " | " .. v3,
            a1.NameTag
        )
    end
    if v2 then
        updateCollectionData(Inspect, v2)
        local Rarity = Inspect.Top.Frame:FindFirstChild("Rarity")
        if Rarity and Rarity:IsA("Frame") and v2.rarity then
            v1 = Rarities[v2.rarity]
            if v1 then
                Rarity.BackgroundColor3 = v1.Color
            end
        end
    end
    local Description = Inspect.Bottom.Middle:FindFirstChild("Description")
    if Description then
        v1 = true
        if typeof(a1.StatTrack) ~= "number" then
            v1 = a1.StatTrack == true
        end
        Description.Statrak.Visible = v1
        Description.Description.Text = v2 and v2.description or ""
    end
end

local function hideViewmodels() -- Line: 1725 -- upvalues: u184 (ref), CurrentCamera (val), u174 (ref)
    local Transparency
    u184 = {}
    for i, v in ipairs(CurrentCamera:GetChildren()) do
        if v:IsA("Model") and v.Name ~= "InspectScene" then
            if not u174 then
                for i2, i3 in ipairs(v:GetDescendants()) do
                    if i3:IsA("BasePart") then
                        if i3.Transparency < 1 then
                            Transparency = i3.Transparency
                            i3:SetAttribute("_InspectPrevTransparency", Transparency)
                            i3.Transparency = 1
                        end
                    elseif not i3:IsA("Texture") then
                        if i3:IsA("SurfaceGui") and i3.Enabled then
                            i3:SetAttribute("_InspectPrevSurfaceGuiEnabled", true)
                            i3.Enabled = false
                        end
                    elseif i3.Transparency < 1 then
                        Transparency = i3.Transparency
                        i3:SetAttribute("_InspectPrevTransparency", Transparency)
                        i3.Transparency = 1
                    end
                end
                table.insert(u184, v)
            elseif u174.Model ~= v then
                for i4, j in ipairs(v:GetDescendants()) do
                    if j:IsA("BasePart") then
                        if j.Transparency < 1 then
                            Transparency = j.Transparency
                            j:SetAttribute("_InspectPrevTransparency", Transparency)
                            j.Transparency = 1
                        end
                    elseif not j:IsA("Texture") then
                        if j:IsA("SurfaceGui") and j.Enabled then
                            j:SetAttribute("_InspectPrevSurfaceGuiEnabled", true)
                            j.Enabled = false
                        end
                    elseif j.Transparency < 1 then
                        Transparency = j.Transparency
                        j:SetAttribute("_InspectPrevTransparency", Transparency)
                        j.Transparency = 1
                    end
                end
                table.insert(u184, v)
            end
        end
    end
end

local function showViewmodels() -- Line: 1752 -- upvalues: u184 (ref)
    local Attribute, Attribute_2
    for i, v in ipairs(u184) do
        if v and v.Parent then
            for i2, i3 in ipairs(v:GetDescendants()) do
                if i3:IsA("BasePart") then
                    Attribute = i3:GetAttribute("_InspectPrevTransparency")
                    if Attribute ~= nil then
                        i3.Transparency = Attribute
                        i3:SetAttribute("_InspectPrevTransparency", nil)
                    end
                elseif not i3:IsA("SurfaceGui") then
                    if i3:IsA("Texture") then
                        Attribute_2 = i3:GetAttribute("_InspectPrevTransparency")
                        if Attribute_2 == nil then
                            i3.Transparency = 0.3
                        else
                            i3.Transparency = Attribute_2
                            i3:SetAttribute("_InspectPrevTransparency", nil)
                        end
                    end
                elseif i3:GetAttribute("_InspectPrevSurfaceGuiEnabled") ~= nil then
                    i3.Enabled = true
                    i3:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil)
                end
            end
        end
    end
    u184 = {}
end

local function restoreMenuFrames() -- Line: 1787
    -- upvalues: MenuState (val), u180 (ref), MenuSceneController (val), hideOtherMenuScreens (val)
    local v1 = MenuState.GetMenuFrame()
    if v1 and v1.Visible then
        local Inspect = v1:FindFirstChild("Inspect") or v1:FindFirstChild("InspectFrame")
        if Inspect and Inspect:IsA("GuiObject") then
            local MobileButtons = Inspect:FindFirstChild("MobileButtons")
            Inspect.Visible = false
            if MobileButtons then
                MobileButtons.Visible = false
            end
        end
        local v2 = MenuState.GetScreenBeforeInspect()
        local v3 = u180
        u180 = false
        MenuState.ExitInspect()
        if v3 then
            MenuSceneController.ShowMenuScene()
            MenuSceneController.SetMusicVolumeMultiplier(1, 0.5)
        end
        local Top = v1:FindFirstChild("Top")
        if Top then
            Top.Visible = true
        end
        if not v2 then
            hideOtherMenuScreens(v1, "Dashboard")
            local Dashboard = v1:FindFirstChild("Dashboard")
            if Dashboard then
                Dashboard.Visible = true
            end
            MenuState.SetBlurEnabled(false)
            v1.BackgroundTransparency = 1
            local Pattern_3 = v1:FindFirstChild("Pattern")
            if Pattern_3 then
                Pattern_3.Visible = true
            end
            return
        end
        local v4 = v1:FindFirstChild(v2)
        if v4 then
            local Pattern
            hideOtherMenuScreens(v1, v2)
            v4.Visible = true
            if MenuState.IsCaseSceneActive() and v2 == "Store" then
                MenuState.SetBlurEnabled(false)
                v1.BackgroundTransparency = 1
                Pattern = v1:FindFirstChild("Pattern")
                if not Pattern then
                    return
                end
                Pattern.Visible = false
                return
            end
            if not MenuState.IsSceneScreen(v2) then
                local v5 = false
                if v2 ~= "Dashboard" then
                    v5 = v2 ~= "Play"
                end
                MenuState.SetBlurEnabled(v5)
                v1.BackgroundTransparency = if not v5 then 1 else 0.15
                local Pattern_2 = v1:FindFirstChild("Pattern")
                if Pattern_2 then
                    Pattern_2.Visible = not v5
                    return
                end
            else
                MenuState.SetBlurEnabled(false)
                v1.BackgroundTransparency = 1
                Pattern = v1:FindFirstChild("Pattern")
                if Pattern then
                    Pattern.Visible = false
                    return
                end
            end
        end
        return
    end
    u180 = false
    MenuState.ExitInspect()
end

local function abortInspectScene(a1) -- Line: 1854
    -- upvalues: u183 (ref), ReplicatedStorage (val), u178 (ref), SceneLighting (val), restoreMenuFrames (val)
    warn(a1)
    if u183 then
        u183.Parent = ReplicatedStorage
        u183 = nil
    end
    u178 = SceneLighting.RestoreMap(nil, u178)
    restoreMenuFrames()
end

local function resetInspectView(a1) -- Line: 1866
    -- upvalues: u214 (ref), u215 (ref), u216 (ref), u217 (ref), u212 (ref), u213 (ref)
    u214 = 0
    u215 = 0
    u216 = 0
    u217 = 0
    u212 = a1
    u213 = a1
end

function u0.ShowInspect(a1) -- Line: 1878
    -- upvalues: u191 (ref), u0 (val), Router (val), u272 (ref), u273 (ref), u176 (ref), u274 (ref), u188 (ref)
    -- upvalues: GetWeaponProperties (val), hideMenuFrames (val), hideViewmodels (val), updateCharmFrameVisibility (val)
    -- upvalues: updateInspectFrameUI (val), u179 (ref), restoreMenuFrames (val), u183 (ref)
    -- upvalues: activateInspectSceneFlags (val), u182 (ref), Lighting (val), u178 (ref), SceneLighting (val)
    -- upvalues: ReplicatedStorage (val), InputController (val), setupViewmodelInspect (val), setupWeaponInspect (val)
    -- upvalues: DEFAULT_CAMERA_FOV (val), u214 (ref), u215 (ref), u216 (ref), u217 (ref), u212 (ref), u213 (ref)
    -- upvalues: CurrentCamera (val), CameraController (val), u187 (val), RunServiceController (val)
    -- upvalues: UserInputService (val), u174 (ref), u181 (ref), u198 (val), u175 (ref), u210 (ref), zero (ref)
    -- upvalues: LocalPlayer (val), u270 (ref), u271 (ref), getPinchDistance (val), MenuState (val), u158 (val)
    -- upvalues: refreshInspectTips (val)
    if u191 then
        u0.HideInspect()
    end
    if not Router.broadcastRouter("HasPendingCharmAttachment") then
        u272 = nil
    else
        u272 = a1
        u273 = 1
    end
    u176 = a1
    u274 = false
    local v1 = false
    if a1 ~= nil then
        v1 = true
        if a1.Type ~= "Glove" then
            local Class
            if not a1.Name then
                Class = nil
            else
                local success, result = pcall(GetWeaponProperties, a1.Name)
                Class = if not success then nil else if not result then nil else result.Class
            end
            v1 = Class == "Glove"
        end
    end
    u188 = if not v1 then "Weapon" else "Viewmodel"
    hideMenuFrames()
    hideViewmodels()
    updateCharmFrameVisibility()
    updateInspectFrameUI(a1)
    if not u179 then
        warn("[InspectController]: No preloaded inspect scene available")
        restoreMenuFrames()
        return
    end
    if u179.Parent ~= workspace then
        u179.Parent = workspace
    end
    u183 = u179
    activateInspectSceneFlags(u183)
    if u182 then
        local v2 = u182
        v1 = Lighting:FindFirstChild(v2)
        if v1 then
            u178 = SceneLighting.ApplyScene(v2, v1)
        else
            v1 = Lighting:FindFirstChild("Menu")
            if v1 then
                u178 = SceneLighting.ApplyScene(v2, v1)
            end
        end
    end
    local CamPart = if not u183 then nil else u183:FindFirstChild("CamPart")
    if not CamPart then
        warn("[InspectController]: Inspect scene missing CamPart")
        if u183 then
            u183.Parent = ReplicatedStorage
            u183 = nil
        end
        u178 = SceneLighting.RestoreMap(nil, u178)
        restoreMenuFrames()
        return
    end
    if u183 and u183:FindFirstChild("WeaponPart") then
        if u188 ~= "Viewmodel" then
            InputController.enableGroup("Gameplay")
            setupWeaponInspect(a1)
        else
            InputController.disableGroup("Gameplay")
            setupViewmodelInspect(a1)
        end
        v1 = if u188 ~= "Viewmodel" then 40 else DEFAULT_CAMERA_FOV
        u214 = 0
        u215 = 0
        u216 = 0
        u217 = 0
        u212 = v1
        u213 = v1
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = CamPart.CFrame
        CurrentCamera.Focus = CamPart.CFrame
        CameraController.updateCameraFOV(if u188 ~= "Viewmodel" then 40 else DEFAULT_CAMERA_FOV)
        CameraController.setForceLockOverride("Inspect", true)
        u187:Add(RunServiceController.BindToRenderStep("InspectController.CameraUpdate", function(a1) -- Line: 1950
            -- upvalues: u212 (upval), u213 (upval), u183 (upval), CamPart (val), CurrentCamera (upval)
            -- upvalues: CameraController (upval), u188 (upval), UserInputService (upval), u217 (upval), u216 (upval)
            -- upvalues: u174 (upval), u214 (upval), u215 (upval), u181 (upval), u198 (upval), u175 (upval)
            local v1
            local v2 = math.min(1, a1 * 8)
            u212 = u212 + (u213 - u212) * v2
            if u183 and CamPart then
                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                CurrentCamera.CFrame = CamPart.CFrame
                CurrentCamera.Focus = CamPart.CFrame
                CurrentCamera.FieldOfView = CameraController.clampFOV(u212)
            end
            if u188 ~= "Weapon" or not UserInputService.GamepadEnabled then
                v1 = a1
            else
                local LastInputType = UserInputService:GetLastInputType()
                local Gamepad1 = if LastInputType == Enum.UserInputType.Gamepad1 then LastInputType or Enum.UserInputType.Gamepad1 else if LastInputType == Enum.UserInputType.Gamepad2 then LastInputType or Enum.UserInputType.Gamepad1 else if LastInputType == Enum.UserInputType.Gamepad3 then LastInputType or Enum.UserInputType.Gamepad1 else not (LastInputType ~= Enum.UserInputType.Gamepad4) and LastInputType or Enum.UserInputType.Gamepad1
                local GamepadState = UserInputService:GetGamepadState(Gamepad1)
                if not GamepadState then
                    v1 = a1
                else
                    local Z, v3, v4
                    v1 = a1
                    for k, v in pairs(GamepadState) do
                        if v.KeyCode == Enum.KeyCode.Thumbstick2 then
                            v3 = Vector2.new(v.Position.X, v.Position.Y)
                            if 0.1 < v3.Magnitude then
                                v4 = Vector2.new(v3.X * 0.5 * 60 * v1 * 4.75, v3.Y * 0.5 * 60 * v1 * 4.75)
                                u217 = u217 + v4.X * 0.5
                                u216 = math.clamp(u216 + v4.Y * 0.5, -80, 80)
                            end
                        elseif v.KeyCode == Enum.KeyCode.ButtonR2 then
                            if 0.1 < v.Position.Z then
                                Z = if v.KeyCode ~= Enum.KeyCode.ButtonR2 then v.Position.Z else -v.Position.Z
                                v4 = Z * 2 * 30 * v1 * 0.55
                                if u188 ~= "Viewmodel" then
                                    u213 = math.clamp(u213 - v4 * 2, 20, 70)
                                end
                            end
                        elseif v.KeyCode == Enum.KeyCode.ButtonL2 and 0.1 < v.Position.Z then
                            Z = if v.KeyCode ~= Enum.KeyCode.ButtonR2 then v.Position.Z else -v.Position.Z
                            v4 = Z * 2 * 30 * v1 * 0.55
                            if u188 ~= "Viewmodel" then
                                u213 = math.clamp(u213 - v4 * 2, 20, 70)
                            end
                        end
                    end
                end
            end
            if u188 == "Viewmodel" and u174 then
                u174:render(v1)
                return
            end
            if u188 == "Weapon" then
                local v5 = math.min(1, v1 * 10)
                u214 = u214 + (u216 - u214) * v5
                u215 = u215 + (u217 - u215) * v5
                if u181 then
                    if not u183 then
                        return
                    end
                    local WeaponPart = u183:FindFirstChild("WeaponPart")
                    if WeaponPart then
                        local Angles = CFrame.Angles
                        local v6 = u181
                        local v7 = WeaponPart.CFrame * (Angles(0, math.rad(u215), (math.rad(u214)))) * u198
                        if u175 then
                            v7 = v7 * (v6:GetPivot()):ToObjectSpace(u175.WorldCFrame):Inverse()
                        end
                        v6:PivotTo(v7)
                    end
                end
            end
        end), "Disconnect", "CameraUpdate")
        u187:Add(UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 2026
            -- upvalues: u210 (upval), zero (upval), InputController (upval), LocalPlayer (upval), u0 (upval)
            -- upvalues: u270 (upval), u271 (upval), getPinchDistance (upval)
            if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                u210 = true
                zero = Vector2.new(a1.Position.X, a1.Position.Y)
            end
            if table.find(InputController.getActionKeybinds("Inspect"), a1.KeyCode) then
                if LocalPlayer:GetAttribute("IsPlayerChatting") then
                    return
                end
                u0.PlayInspectAnimation()
            end
            if table.find(InputController.getActionKeybinds("Reload"), a1.KeyCode) then
                if LocalPlayer:GetAttribute("IsPlayerChatting") then
                    return
                end
                u0.CancelInspectAnimation()
            end
            if a1.UserInputType == Enum.UserInputType.Touch then
                u270[a1] = (Vector2.new(a1.Position.X, a1.Position.Y))
                local v1 = 0
                for k in pairs(u270) do
                    v1 = v1 + 1
                end
                if v1 == 1 then
                    u210 = true
                    zero = Vector2.new(a1.Position.X, a1.Position.Y)
                end
                u271 = getPinchDistance()
            end
        end), "Disconnect", "InputBegan")
        u187:Add(UserInputService.InputChanged:Connect(function(a1, a2) -- Line: 2061
            -- upvalues: u210 (upval), zero (upval), u217 (upval), u216 (upval), u270 (upval), getPinchDistance (upval)
            -- upvalues: u271 (upval), u188 (upval), u213 (upval)
            local v1, v2
            if a1.UserInputType == Enum.UserInputType.MouseMovement and u210 then
                v1 = Vector2.new(a1.Position.X, a1.Position.Y)
                v2 = v1 - zero
                u217 = u217 + v2.X * 0.5
                u216 = math.clamp(u216 + v2.Y * 0.5, -80, 80)
                zero = v1
            end
            if a1.UserInputType == Enum.UserInputType.Touch then
                local v3
                v1 = Vector2.new(a1.Position.X, a1.Position.Y)
                u270[a1] = v1
                v2 = 0
                for k in pairs(u270) do
                    v2 = v2 + 1
                end
                if v2 == 1 and u210 then
                    v3 = v1 - zero
                    u217 = u217 + v3.X * 0.5
                    u216 = math.clamp(u216 + v3.Y * 0.5, -80, 80)
                    zero = v1
                end
                if v2 >= 2 then
                    v3 = getPinchDistance()
                    if v3 and u271 then
                        local v4 = (v3 - u271) * 0.01
                        if u188 ~= "Viewmodel" then
                            u213 = math.clamp(u213 - v4 * 2, 20, 70)
                        end
                    end
                    u271 = v3
                end
            end
            if a1.UserInputType == Enum.UserInputType.MouseWheel then
                local Z = a1.Position.Z
                if u188 == "Viewmodel" then
                    return
                end
                u213 = math.clamp(u213 - Z * 2, 20, 70)
            end
        end), "Disconnect", "InputChanged")
        u187:Add(UserInputService.InputEnded:Connect(function(a1, a2) -- Line: 2102 -- upvalues: u210 (upval), u270 (upval), u271 (upval), getPinchDistance (upval)
            if a1.UserInputType == Enum.UserInputType.MouseButton1 then
                u210 = false
            end
            if a1.UserInputType == Enum.UserInputType.Touch then
                u270[a1] = nil
                local v1 = 0
                for k in pairs(u270) do
                    v1 = v1 + 1
                end
                if v1 == 0 then
                    u210 = false
                end
                u271 = getPinchDistance()
            end
        end), "Disconnect", "InputEnded")
        u187:Add(function() -- Line: 2119
            -- upvalues: u181 (upval), u175 (upval), u183 (upval), u179 (upval), ReplicatedStorage (upval), u210 (upval)
            -- upvalues: u270 (upval), u271 (upval), u214 (upval), u215 (upval), u216 (upval), u217 (upval)
            -- upvalues: u212 (upval), u213 (upval)
            if u181 then
                u181:Destroy()
                u181 = nil
            end
            u175 = nil
            if u183 then
                if u183 ~= u179 then
                    u183:Destroy()
                else
                    u183.Parent = ReplicatedStorage
                end
                u183 = nil
            end
            u210 = false
            u270 = {}
            u271 = nil
            u214 = 0
            u215 = 0
            u216 = 0
            u217 = 0
            u212 = 40
            u213 = 40
        end, true, "InspectCleanup")
        u191 = true
        local v3 = MenuState.GetMenuFrame()
        v1 = v3 and (v3:FindFirstChild("Inspect") or v3:FindFirstChild("InspectFrame"))
        local MobileButtons = v1 and v1:FindFirstChild("MobileButtons")
        local Inspect = MobileButtons and MobileButtons:FindFirstChild("Inspect")
        if Inspect then
            local v4 = u191
            if v4 then
                v4 = false
                if u188 == "Viewmodel" then
                    v4 = u158
                end
            end
            MobileButtons.Visible = v4
            Inspect.Visible = v4
        end
        refreshInspectTips()
        return
    end
    warn("[InspectController]: Inspect scene missing WeaponPart")
    if u183 then
        u183.Parent = ReplicatedStorage
        u183 = nil
    end
    u178 = SceneLighting.RestoreMap(nil, u178)
    restoreMenuFrames()
end

function u0.HideInspect(a1) -- Line: 2143
    -- upvalues: u191 (ref), u190 (ref), u187 (val), u172 (ref), u173 (ref), u174 (ref), u177 (ref)
    -- upvalues: InputController (val), u181 (ref), u175 (ref), MenuState (val), CaseSceneController (val), u178 (ref)
    -- upvalues: SceneLighting (val), CurrentCamera (val), CameraController (val), Constants (val)
    -- upvalues: restoreMenuFrames (val), u180 (ref), showViewmodels (val), u184 (ref), u272 (ref), u273 (ref)
    -- upvalues: u188 (ref), u158 (val), refreshInspectTips (val)
    if not u191 then
        return
    end
    u190 = nil
    u187:Cleanup()
    if u172 then
        if u172.IsPlaying then
            u172:Stop(0)
        end
        u172:Destroy()
        u172 = nil
    end
    if u173 then
        u173:Destroy()
        u173 = nil
    end
    if u174 then
        u174:destroy()
        u174 = nil
    end
    if u177 then
        u177:Destroy()
        u177 = nil
    end
    InputController.enableGroup("Gameplay")
    if u181 then
        u181:Destroy()
        u181 = nil
    end
    u175 = nil
    if not MenuState.IsCaseSceneActive() then
        u178 = SceneLighting.RestoreMap(nil, u178)
    else
        CaseSceneController.ApplyCaseSceneLighting()
    end
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
    CameraController.setForceLockOverride("Inspect", false)
    if a1 then
        MenuState.ExitInspect()
        u180 = false
    else
        restoreMenuFrames()
    end
    if MenuState.IsCaseSceneActive() then
        u184 = {}
    else
        showViewmodels()
    end
    u272 = nil
    u273 = 1
    u191 = false
    local v1 = MenuState.GetMenuFrame()
    local v2 = v1 and (v1:FindFirstChild("Inspect") or v1:FindFirstChild("InspectFrame"))
    local MobileButtons = v2 and v2:FindFirstChild("MobileButtons")
    local Inspect = MobileButtons and MobileButtons:FindFirstChild("Inspect")
    if Inspect then
        local v3 = u191
        if v3 then
            v3 = false
            if u188 == "Viewmodel" then
                v3 = u158
            end
        end
        MobileButtons.Visible = v3
        Inspect.Visible = v3
    end
    refreshInspectTips()
end

function u0.IsActive() -- Line: 2193 -- upvalues: u191 (ref)
    return u191
end

function u0.CycleCharmPosition() -- Line: 2199 -- upvalues: u191 (ref), u272 (ref), u273 (ref), u0 (val)
    if u191 and u272 then
        u273 = u273 % 4 + 1
        u0.RefreshWeaponWithCharm((tostring(u273)))
        return
    end
end

function u0.RefreshWeaponWithCharm(a1) -- Line: 2212
    -- upvalues: u191 (ref), u183 (ref), u272 (ref), u214 (ref), u215 (ref), u216 (ref), u217 (ref), u188 (ref)
    -- upvalues: u181 (ref), u175 (ref), Skins (val), prepareInspectWeapon (val), u198 (val), u174 (ref), u177 (ref)
    if u191 and u183 and u272 then
        local v1 = u183
        local v2 = u272
        if not v1:FindFirstChild("WeaponPart") then
            return
        end
        local v3 = u214
        local v4 = u215
        local v5 = u216
        local v6 = u217
        local Charm = v2.Charm
        local v7 = a1
        if type(Charm) == "table" then
            v7 = {_id = Charm._id, Position = a1}
        end
        if u188 == "Weapon" then
            if u181 then
                u181:Destroy()
                u181 = nil
            end
            u175 = nil
            local v8 = Skins.GetCharacterModel(v2.Name, v2.Skin, v2.Float, v2.StatTrack, v2.NameTag, v7, v2.Stickers)
            if not v8 then
                warn((("[InspectController]: Failed to refresh weapon model for charm position %*"):format(a1)))
                return
            end
            prepareInspectWeapon(v8, false)
            v8.Parent = v1
            u216 = v5
            u217 = v6
            if u181 and u183 then
                local WeaponPart = u183:FindFirstChild("WeaponPart")
                if WeaponPart then
                    local Angles = CFrame.Angles
                    local v9 = u181
                    local v10 = WeaponPart.CFrame * (Angles(0, math.rad(v4), (math.rad(v3)))) * u198
                    if u175 then
                        v10 = v10 * (v9:GetPivot()):ToObjectSpace(u175.WorldCFrame):Inverse()
                    end
                    v9:PivotTo(v10)
                end
            end
        end
        if u174 and u177 then
            u174.Charm = v7
            u174:construct(u177, nil)
        end
        return
    end
end

function u0.PlayInspectAnimation() -- Line: 2279
    -- upvalues: u188 (ref), u174 (ref), u176 (ref), GetWeaponProperties (val), u172 (ref)
    if u188 == "Viewmodel" and u174 then
        local v1 = u176
        local v2 = false
        if v1 ~= nil then
            v2 = true
            if v1.Type ~= "Glove" then
                local Class
                if not v1.Name then
                    Class = nil
                else
                    local success, result = pcall(GetWeaponProperties, v1.Name)
                    Class = if not success then nil else if not result then nil else result.Class
                end
                v2 = Class == "Glove"
            end
        end
        if not v2 then
            if u174.Animation then
                v2 = u174.Animation:pickInspectVariant()
                u174.Animation:stopAnimations()
                u174.Animation:play("Idle")
                u174.Animation:play(v2)
            end
            return
        end
        if not u172 then
            return
        end
        if u174 and u174.Animation then
            u174.Animation:stopAnimations()
        end
        if u172.IsPlaying then
            u172:Stop(0)
        end
        u172.TimePosition = 0
        u172:Play(0, 1, 1)
        return
    end
end

function u0.CancelInspectAnimation() -- Line: 2296
    -- upvalues: u188 (ref), u174 (ref), u176 (ref), GetWeaponProperties (val), u172 (ref)
    if u188 == "Viewmodel" and u174 then
        local v1 = u176
        local v2 = false
        if v1 ~= nil then
            v2 = true
            if v1.Type ~= "Glove" then
                local Class
                if not v1.Name then
                    Class = nil
                else
                    local success, result = pcall(GetWeaponProperties, v1.Name)
                    Class = if not success then nil else if not result then nil else result.Class
                end
                v2 = Class == "Glove"
            end
        end
        if not v2 then
            if u174.Animation then
                u174.Animation:markInspectCancel()
                u174.Animation:crossfadeTo("Idle", 0.25)
            end
            return
        end
        if u172 and u172.IsPlaying then
            u172:Stop(0.25)
            return
        end
        return
    end
end

function u0.Initialize() -- Line: 2314
    -- upvalues: DataController (val), LocalPlayer (val), SceneLighting (val), u178 (ref), refreshInspectTips (val)
    -- upvalues: UserInputService (val), getRandomInspectScene (val), u182 (ref), u179 (ref), ReplicatedStorage (val)
    -- upvalues: u191 (ref), u0 (val), Router (val), u273 (ref)
    DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 2315 -- upvalues: SceneLighting (upval), u178 (upval)
        SceneLighting.ApplyGlobalShadows(u178)
    end)
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", refreshInspectTips)
    ;(UserInputService:GetPropertyChangedSignal("PreferredInput")):Connect(refreshInspectTips)
    local v1 = getRandomInspectScene()
    if not v1 then
        warn("[InspectController]: No inspect scene found to preload in ReplicatedStorage.Assets.InspectScenes")
    else
        u182 = v1.Name
        u179 = v1
        v1.Name = "InspectScene"
        v1.Parent = ReplicatedStorage
    end
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 2336 -- upvalues: u191 (upval), u0 (upval)
        if a2 then
            return
        end
        if a1.KeyCode == Enum.KeyCode.Escape and u191 then
            u0.HideInspect()
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 2346 -- upvalues: u191 (upval), u0 (upval)
        if u191 then
            u0.HideInspect()
        end
    end)
    Router.observerRouter("WeaponInspect", function(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14) -- Line: 2354
        -- upvalues: ReplicatedStorage (upval), u0 (upval)
        if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
            return
        end
        local v1 = {
            _id = a10 or "inspect_" .. a1 .. "_" .. a2,
            Name = a1,
            Skin = a2,
            Float = a3,
            StatTrack = a4,
            NameTag = a5,
            Charm = a6,
            Stickers = a7,
            Type = a8,
            Pattern = a9,
            Serial = a11,
            IsTradeable = a12,
            HideWearDetails = a13,
            ShowFullPriceRange = a14,
        }
        u0.ShowInspect(v1)
    end)
    Router.observerRouter("WeaponInspectClose", function() -- Line: 2397 -- upvalues: u0 (upval)
        u0.HideInspect()
    end)
    Router.observerRouter("WeaponInspectCloseForGameEnd", function() -- Line: 2402 -- upvalues: u0 (upval)
        u0.HideInspect(true)
    end)
    Router.observerRouter("IsInspectActive", function() -- Line: 2406 -- upvalues: u191 (upval)
        return u191
    end)
    Router.observerRouter("GetCurrentCharmPosition", function() -- Line: 2410 -- upvalues: u273 (upval)
        return u273
    end)
end

function u0.Start() -- Line: 2415 -- upvalues: initializeInspectButtons (val)
    initializeInspectButtons()
end

return u0