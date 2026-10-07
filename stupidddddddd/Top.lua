-- ReplicatedStorage.Interface.Screens.Menu.Top
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Top
-- Decompile time: 30.58 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local InputController = require(ReplicatedStorage.Controllers.InputController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local IsBotLobby = require(ReplicatedStorage.Components.Common.IsBotLobby)
local GameState = require(ReplicatedStorage.Database.Components.GameState)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local TeamSelection = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection)
local CurrentCamera = workspace.CurrentCamera
local v1 = Instance.new("BlurEffect", Lighting)
v1.Enabled = false
v1.Name = "Menu"
v1.Size = 20
local u128 = false
local u129 = false
local u130 = false
local u131 = false
local u132 = nil
local u133 = nil
local u134 = nil
local u135 = nil
local u136 = 0
local u137 = nil
local u142 = Color3.fromRGB(255, 255, 255)
local u147 = Color3.fromRGB(150, 220, 239)
local u152 = Color3.fromRGB(175, 175, 175)
local u153 = nil
local u154 = nil

local function tweenButton(a1, a2) -- Line: 94
    -- upvalues: TweenService (val), u147 (val), u152 (val)
    if a1:IsA("ImageButton") then
        TweenService:Create(a1, TweenInfo.new(0.15), {ImageColor3 = a2}):Play()
        return
    end
    if a1:IsA("TextButton") then
        local Attribute = a1:GetAttribute("DefaultSize") or a1.Size
        local v1 = if a2 ~= u147 then if a2 ~= u152 then 1 else 1.06 else 1.12
        TweenService:Create(a1, TweenInfo.new(0.15), {
            Size = UDim2.new(Attribute.X.Scale * v1, Attribute.X.Offset * v1, Attribute.Y.Scale * v1, Attribute.Y.Offset * v1),
        }):Play()
    end
end

local function animateBlackmarketButton(a1, a2) -- Line: 122
    -- upvalues: RunServiceController (val), GuiService (val)
    local Icon = a1:FindFirstChild("Icon")
    if not Icon then
        return
    end
    local Position = Icon.Position
    local Rotation = Icon.Rotation
    local u8 = false
    local u9 = 0
    a1.MouseEnter:Connect(function() -- Line: 133 -- upvalues: u8 (ref)
        u8 = true
    end)
    a1.MouseLeave:Connect(function() -- Line: 136 -- upvalues: u8 (ref)
        u8 = false
    end)
    RunServiceController.BindToRenderStep("UI.Top.BlackmarketButton", function(a1) -- Line: 140
        -- upvalues: a2 (val), GuiService (upval), Icon (val), Position (val), Rotation (val), u8 (ref), u9 (ref)
        if not a2() then
            return
        end
        if GuiService.ReducedMotionEnabled then
            Icon.Position = Position
            Icon.Rotation = Rotation
            return
        end
        u9 = u9 + ((if not u8 then 0 else 1) - u9) * (1 - math.exp(a1 * -14))
        local v1 = os.clock() * 1.4
        Icon.Position = Position + UDim2.fromScale(0, math.sin(v1) * 0.035)
        Icon.Rotation = Rotation + math.cos(v1) * 2 + u9 * -8
    end)
end

local u157 = nil

local function fitTopButtonsBesideTabs() -- Line: 171 -- upvalues: u153 (ref), u154 (ref), u157 (ref)
    local Buttons = u153.Top.Buttons
    local Store = u154.Menu:FindFirstChild("Store")
    local Top = Store and Store:FindFirstChild("Top")
    local Categories = Top and Top:FindFirstChild("Categories")
    local v1 = u157
    if Categories and v1 then
        if Categories:IsA("GuiObject") and not Categories.Visible then
            Buttons.Size = UDim2.new(Buttons.Size.X, v1)
            return
        end
        local v2 = (-1 / 0)
        for i, j in Categories:GetChildren() do
            if j:IsA("GuiObject") and j.Visible then
                v2 = math.max(v2, j.AbsolutePosition.X + j.AbsoluteSize.X)
            end
        end
        local v3 = 0
        local v4 = 0
        for k, n in Buttons:GetChildren() do
            if n:IsA("GuiButton") and n.Visible then
                v3 = v3 + 1
                v4 = math.max(v4, n.Size.Y.Scale)
            end
        end
        local Y = Buttons.Parent.AbsoluteSize.Y
        if v2 ~= (-1 / 0) and v3 ~= 0 and not (v4 <= 0) and not (Y <= 0) then
            local X = Buttons.AbsoluteSize.X
            local UIPadding = Buttons:FindFirstChildOfClass("UIPadding")
            local UIListLayout = Buttons:FindFirstChildOfClass("UIListLayout")
            local v5 = if not UIPadding then 0 else UIPadding.PaddingRight.Scale * X + UIPadding.PaddingRight.Offset
            local v6 = if not UIListLayout then 0 else UIListLayout.Padding.Scale * X + UIListLayout.Padding.Offset
            local v7 = Buttons.AbsolutePosition.X + X - v5 - (v2 + 8) - v6 * (v3 - 1)
            local v8 = v4 * (math.min(X, v1.Scale * Y + v1.Offset))
            local v9 = math.clamp(v7 / v3 / v8, 0, 1)
            Buttons.Size = UDim2.new(Buttons.Size.X, UDim.new(v1.Scale * v9, v1.Offset * v9))
            return
        end
        return
    end
end

local function setupButton(a1) -- Line: 227
    -- upvalues: u142 (val), u133 (ref), tweenButton (val), Router (val), u152 (val), u147 (val)
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("GuiObject") and not v:IsA("GuiButton") and v.Active then
            v.Active = false
        end
    end
    if a1:IsA("ImageButton") then
        a1.ImageColor3 = u142
    elseif a1:IsA("TextButton") then
        a1.TextLabel.TextColor3 = u142
        a1:SetAttribute("DefaultSize", a1.Size)
    end
    a1.MouseLeave:Connect(function() -- Line: 242 -- upvalues: u133 (upval), a1 (val), tweenButton (upval), u142 (upval)
        if u133 ~= a1 then
            tweenButton(a1, u142)
        end
    end)
    a1.MouseEnter:Connect(function() -- Line: 247 -- upvalues: Router (upval), u133 (upval), a1 (val), tweenButton (upval), u152 (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
        if u133 ~= a1 then
            tweenButton(a1, u152)
        end
    end)
    a1.MouseButton1Click:Connect(function() -- Line: 253 -- upvalues: u133 (upval), a1 (val), tweenButton (upval), u147 (upval), u142 (upval)
        local v1 = u133
        u133 = a1
        if v1 ~= a1 then
            tweenButton(a1, u147)
            if v1 then
                local Alert = v1:FindFirstChild("Alert")
                tweenButton(v1, u142)
                if Alert then
                    Alert.Visible = false
                end
            end
        end
    end)
end

local u160 = {
    Dashboard = true,
    Inventory = true,
    Loadout = true,
    Gamemodes = true,
    Settings = true,
    Store = true,
    Career = true,
    Progression = true,
    GlobalMarketPlace = true,
    GameDashboard = true,
    Blackmarket = true,
}

local function toMenuScreen(a1) -- Line: 285 -- upvalues: u160 (val) -- types: a1: string
    if u160[a1] then
        return a1
    end
    return nil
end

local function setButtonToggle(a1) -- Line: 290 -- upvalues: u133 (ref), tweenButton (val), u147 (val), u142 (val)
    local v1 = u133
    u133 = a1
    tweenButton(a1, u147)
    if v1 and v1 ~= a1 then
        tweenButton(v1, u142)
    end
end

local function setNavigationVisible(a1) -- Line: 300 -- upvalues: u153 (ref) -- types: a1: boolean
    local v1
    if not u153 then
        return
    end
    for i, v in ipairs({"Top", "Bottom"}) do
        v1 = u153:FindFirstChild(v)
        if v1 and v1:IsA("GuiObject") then
            v1.Visible = a1
        end
    end
end

local function syncControlLockWithMenuVisibility() -- Line: 313
    -- upvalues: u154 (ref), TeamSelection (val), u129 (ref), InputController (val), UserInputService (val)
    -- upvalues: GuiService (val)
    local Menu = u154 and u154.Menu and u154.Menu.Visible
    local v1 = TeamSelection.isVisible()
    local v2 = true
    if Menu ~= true then
        v2 = v1 == true
    end
    if not v2 then
        if not v2 and u129 then
            InputController.enableGroup("Gameplay")
            u129 = false
        end
    elseif not u129 then
        InputController.disableGroup("Gameplay")
        u129 = true
    elseif not v2 and u129 then
        InputController.enableGroup("Gameplay")
        u129 = false
    end
    if UserInputService.TouchEnabled then
        local v3 = not v2
        if GuiService.TouchControlsEnabled ~= v3 then
            GuiService.TouchControlsEnabled = v3
        end
    end
end

local function syncCameraWithTeamSelection() -- Line: 337
    -- upvalues: TeamSelection (val), u154 (ref), ReplicatedStorage (val), u0 (val)
    local v1 = TeamSelection.shouldUseMapCamera()
    if not u154.Menu.Visible and v1 then
        local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
        if MenuSceneController.ShowTeamSelectScene() then
            return
        end
        if MenuSceneController.IsActive() then
            MenuSceneController.HideMenuScene(true, false)
        end
        local Map = workspace:FindFirstChild("Map")
        if Map then
            u0.UpdateBackground(Map)
        end
        return
    end
end

function u0.UpdateBackground(a1) -- Line: 367
    -- upvalues: Profiler (val), TeamSelection (val), u154 (ref), ReplicatedStorage (val), MenuState (val)
    -- upvalues: LocalPlayer (val), CurrentCamera (val), CameraController (val)
    Profiler.mark("UI.Top.UpdateBackground")
    local v1 = TeamSelection.shouldUseMapCamera()
    if not u154.Menu.Visible and v1 then
        local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
        if not MenuSceneController.IsActive() and not MenuSceneController.IsTeamSelectSceneActive() then
            if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
                if LocalPlayer:GetAttribute("IsSpectating") then
                    return
                end
                local Cameras = a1:FindFirstChild("Cameras")
                if Cameras then
                    local Children = Cameras:GetChildren()
                    assert(Children[1], "Current map doesnt contain any cameras.")
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CameraSubject = nil
                    local v2 = Children[math.random(1, #Children)]
                    LocalPlayer.ReplicationFocus = v2
                    CurrentCamera.CFrame = v2.CFrame
                    CameraController.updateCameraFOV(80)
                end
                return
            end
            return
        end
        return
    end
end

function u0.ToggleMenu() -- Line: 412
    -- upvalues: Profiler (val), MenuState (val), GameState (val), u154 (ref), CameraController (val), LocalPlayer (val)
    -- upvalues: GetUserPlatform (val), TeamSelection (val), u0 (val), u132 (ref)
    Profiler.mark("UI.Top.ToggleMenu")
    if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
        local v1 = GameState.GetState()
        if v1 and v1 ~= "Map Voting" and v1 ~= "Game Ending" then
            if u154.Menu.Visible then
                MenuState.SetWantsMainMenu(false)
                CameraController.setForceLockOverride("Menu", false)
                if not LocalPlayer:GetAttribute("IsSpectating") then
                    CameraController.setPerspective(true, false)
                end
                MenuState.SetBlurEnabled(false)
                u154.Gameplay.Visible = true
                u154.Gameplay.Top.Visible = true
                local v2 = table.find(GetUserPlatform(), "Mobile") == nil
                u154.Gameplay.Middle.SessionStats.Visible = v2
                u154.Gameplay.Middle.Chat.Visible = v2
                MenuState.HideMenu()
                return
            end
            if u154.Gameplay.Middle.TeamSelection.Visible then
                TeamSelection.closeFrame()
            end
            CameraController.setForceLockOverride("Menu", true)
            if not LocalPlayer:GetAttribute("IsSpectating") then
                CameraController.setPerspective(true, true)
            end
            u154.Gameplay.Visible = false
            u154.Menu.Visible = true
            if LocalPlayer.Character then
                u0.openFrame("GameDashboard")
            elseif u132 and not u132.Visible then
                u0.openFrame(u132.Name)
            end
            if u132 and u132.Name ~= "Dashboard" then
                MenuState.SetBlurEnabled(true)
            end
            return
        end
        return
    end
end

function u0.openFrame(a1, a2) -- Line: 474
    -- upvalues: Profiler (val), MenuState (val), Router (val), u137 (ref), u154 (ref), setNavigationVisible (val)
    -- upvalues: GameState (val), ReplicatedStorage (val), u0 (val), CameraController (val), u132 (ref)
    -- upvalues: LocalPlayer (val), IsTutorialMode (val), Remotes (val), GetUserPlatform (val), u160 (val), u128 (ref)
    local v1
    Profiler.mark("UI.Top.OpenFrame")
    if MenuState.IsInspectActive() or MenuState.IsCaseSceneActive() then
        return
    end
    if a1 == "Store" and not MenuState.IsStoreEnabled() then
        Router.broadcastRouter("RunInterfaceSound", "UI Store Click")
        return
    end
    if a1 == "Store" then
        u137()
    end
    local v2 = MenuState.IsSceneScreen(a1)
    local v3 = false
    if a1 ~= "Dashboard" then
        v3 = false
        if a1 ~= "Play" then
            v3 = not v2
        end
    end
    MenuState.SetBlurEnabled(v3)
    local Pattern = u154.Menu:FindFirstChild("Pattern")
    local v4 = if not v3 then 1 else 0.15
    u154.Menu.BackgroundTransparency = v4
    if Pattern then
        Pattern.Visible = not v3 and not v2
    end
    setNavigationVisible(not v2)
    if a1 ~= "Play" then
        if a1 == "Inventory" then
            Router.broadcastRouter("ResetInventoryToGrid")
        end
        v1 = u154.Menu:FindFirstChild(a1)
        if v1 then
            if v1 ~= u132 or not v1.Visible then
                v1.Visible = true
                if u132 and u132 ~= v1 then
                    u132.Visible = false
                end
                u132 = v1
                MenuState.SetScreen(if not u160[a1] then nil else a1)
            end
        end
        if u128 then
            Router.broadcastRouter("RunInterfaceSound", (("UI %* Click"):format(a1)))
            return
        end
        u128 = a1 == "Dashboard"
        return
    end
    v1 = GameState.GetState()
    local EndScreenController_2 = require(ReplicatedStorage.Controllers.EndScreenController)
    if v1 then
        if v1 == "Game Ending" and EndScreenController_2.IsActive() then
            return
        end
        local v5 = nil
        Router.broadcastRouter("RunInterfaceSound", "UI Play Click")
        if a2 then
            u0.reportPressedPlay()
            MenuState.SetWantsMainMenu(false)
        end
        CameraController.resetForceLockOverride()
        CameraController.setPerspective(true, false)
        if u132 and u132.Name ~= "Dashboard" then
            u132.Visible = false
            local Dashboard = u154.Menu:FindFirstChild("Dashboard")
            if Dashboard then
                Dashboard.Visible = true
                u132 = Dashboard
            end
        end
        u154.Gameplay.Bottom.Visible = false
        u154.Gameplay.Top.Visible = true
        u154.Gameplay.Visible = true
        MenuState.HideMenu()
        if v1 ~= "Map Voting" then
            local Attribute = LocalPlayer:GetAttribute("Team")
            local Character = LocalPlayer.Character
            if not IsTutorialMode() then
                if not Character or not Attribute or Attribute == "Spectators" then
                    v5 = "TeamSelection"
                end
            elseif Attribute ~= "Terrorists" or not Character then
                Remotes.TeamSelection.SelectTeam.Send("Terrorists")
            end
        else
            v5 = "EndScreen"
        end
        if v5 then
            local v6
            CameraController.setForceLockOverride(v5, true)
            CameraController.setPerspective(true, true)
            for i, v in ipairs(u154.Gameplay.Middle:GetChildren()) do
                if v.Name ~= "Chat" then
                    v6 = true
                    if v.Name ~= "Notification" then
                        if v.Name ~= "Votekick" then
                            v6 = v.Name == v5
                        else
                            v6 = true
                            if v:GetAttribute("IsVoteKickActive") ~= true then
                                v6 = v.Name == v5
                            end
                        end
                    end
                    v.Visible = v6
                else
                    v.Visible = not table.find(GetUserPlatform(), "Mobile")
                end
            end
            return
        else
            local v7 = table.find(GetUserPlatform(), "Mobile") == nil
            u154.Gameplay.Middle.SessionStats.Visible = v7
            u154.Gameplay.Middle.Chat.Visible = v7
            u154.Gameplay.Middle.TeamSelection.Visible = false
            u154.Gameplay.Middle.Crosshair.Visible = true
            u154.Gameplay.Top.Visible = true
            u154.Gameplay.Bottom.Visible = true
            if LocalPlayer.Character then
                CameraController.setPerspective(true, false)
                return
            end
        end
    end
end

function u0.reportPressedPlay() -- Line: 612 -- upvalues: u131 (ref), Remotes (val)
    if u131 then
        return
    end
    u131 = true
    Remotes.Player.PressedPlay.Send()
end

function u0.CloseTeamSelection() -- Line: 623 -- upvalues: u154 (ref)
    u154.Gameplay.Middle.TeamSelection.Visible = false
    u154.Gameplay.Middle.Crosshair.Visible = true
    u154.Gameplay.Top.Visible = true
    u154.Gameplay.Bottom.Visible = true
end

local u171 = {"Loadout", "Inventory", "Gamemodes", "Play", "Store", "GlobalMarketPlace", "Progression"}

local function getControllerCurrentTab() -- Line: 636
    -- upvalues: GuiService (val), u171 (val), u153 (ref), MenuState (val), u133 (ref)
    local v1
    local SelectedObject = GuiService.SelectedObject
    for i, v in ipairs(u171) do
        v1 = u153.Bottom.Buttons:FindFirstChild(v)
        if v1 and SelectedObject then
            if SelectedObject ~= v1 and not SelectedObject:IsDescendantOf(v1) then
                continue
            end
            return v
        end
    end
    local v2 = MenuState.GetCurrentScreen()
    if v2 and table.find(u171, v2) then
        return v2
    end
    local Name = u133 and u133.Name or nil
    if Name and table.find(u171, Name) then
        return Name
    end
    return "Play"
end

local function getTabForBumper(a1, a2) -- Line: 659 -- upvalues: u171 (val) -- types: a1: string, a2: boolean
    local v1 = table.find(u171, a1)
    if not v1 then
        return nil
    end
    local v2 = #u171
    if a2 then
        return u171[(v1 - 2 + v2) % v2 + 1]
    end
    return u171[v1 % v2 + 1]
end

local function getTopButton(a1) -- Line: 668 -- upvalues: u153 (ref) -- types: a1: string
    local Buttons, v1, v2
    if not u153 then
        return nil
    end
    for i, v in ipairs({"Top", "Bottom"}) do
        v1 = u153:FindFirstChild(v)
        Buttons = v1 and v1:FindFirstChild("Buttons")
        v2 = Buttons and Buttons:FindFirstChild(v3)
        if v2 and v2:IsA("GuiButton") then
            return v2
        end
    end
    return nil
end

local function goToTab(a1, a2) -- Line: 685
    -- upvalues: getTopButton (val), GuiService (val), MenuState (val), u0 (val), u133 (ref), tweenButton (val)
    -- upvalues: u147 (val), u142 (val), Router (val)
    local v1 = getTopButton(a1)
    if not v1 then
        return
    end
    GuiService.SelectedObject = v1
    MenuState.HoldNavigationSelection(v1)
    if not a2 then
        u0.openFrame(a1)
    end
    local v2 = u133
    u133 = v1
    tweenButton(v1, u147)
    if v2 and v2 ~= v1 then
        tweenButton(v2, u142)
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
end

local function getVisibleUtilityButtons() -- Line: 701 -- upvalues: u153 (ref)
    local v1 = {}
    for i, v in ipairs(u153.Top.Buttons:GetChildren()) do
        if v:IsA("GuiButton") and v.Visible then
            table.insert(v1, v)
        end
    end
    table.sort(v1, function(a1, a2) -- Line: 708
        return a1.AbsolutePosition.X < a2.AbsolutePosition.X
    end)
    return v1
end

local function cycleUtilityButtons(a1) -- Line: 716
    -- upvalues: getVisibleUtilityButtons (val), GuiService (val), MenuState (val), u0 (val), u133 (ref)
    -- upvalues: tweenButton (val), u147 (val), u142 (val), Router (val)
    local v1 = getVisibleUtilityButtons()
    local v2 = #v1
    if v2 == 0 then
        return
    end
    local SelectedObject = GuiService.SelectedObject
    local v3 = 1
    for i, v in ipairs(v1) do
        if SelectedObject then
            if SelectedObject ~= v and not SelectedObject:IsDescendantOf(v) then
                continue
            end
            v3 = i
            break
        end
    end
    local v4 = v3 - 1
    local v5 = v1[(v4 + (if not a1 then 1 else -1)) % v2 + 1]
    GuiService.SelectedObject = v5
    MenuState.HoldNavigationSelection(v5)
    if v5.Name ~= "Blackmarket" then
        u0.openFrame(v5.Name)
        local v6 = u133
        u133 = v5
        tweenButton(v5, u147)
        if v6 and v6 ~= v5 then
            tweenButton(v6, u142)
        end
    end
    Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
end

local u185 = {}

function u185.Loadout(a1) -- Line: 746
    return {(a1:FindFirstChild("Ignore"))}
end

function u185.Inventory(a1) -- Line: 749
    return {(a1:FindFirstChild("Ignore"))}
end

function u185.Gamemodes(a1) -- Line: 752
    local Gamemodes = a1:FindFirstChild("Gamemodes")
    return {Gamemodes and Gamemodes:FindFirstChild("Prompt")}
end

function u185.Store(a1) -- Line: 757
    local v1
    local v2 = {}
    for i, j in {"CaseContent", "Gift", "CreatorCode", "CurrentConfirm"} do
        v1 = a1:FindFirstChild(j)
        if v1 then
            table.insert(v2, v1)
        end
    end
    return v2
end

function u185.Settings(a1) -- Line: 768
    local v1 = {}
    for i, j in a1:GetDescendants() do
        if j.Name == "Share" or j.Name == "ChangeColor" then
            table.insert(v1, j)
        end
    end
    return v1
end

local function getPageButtonForBack(a1) -- Line: 781
    -- upvalues: u185 (val), u154 (ref), getTopButton (val)
    local v1
    if not a1 then
        return nil
    end
    for k, v in pairs(u185) do
        v1 = u154.Menu:FindFirstChild(k)
        if v1 and v1:IsA("GuiObject") and v1.Visible and a1:IsDescendantOf(v1) then
            for i, i2 in ipairs(v(v1)) do
                if i2 and a1:IsDescendantOf(i2) then
                    return nil
                end
            end
            return (getTopButton(k))
        end
    end
    return nil
end

local function autoJoinMatch() -- Line: 799
    -- upvalues: u130 (ref), IsTutorialMode (val), IsBotLobby (val), MenuState (val), GameState (val), u0 (val)
    -- upvalues: ReplicatedStorage (val)
    if u130 then
        return
    end
    if not IsTutorialMode() and not IsBotLobby() then
        return
    end
    if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
        local v1 = GameState.GetState()
        if v1 ~= nil and v1 ~= "Game Ending" and v1 ~= "Map Voting" then
            if not workspace:FindFirstChild("Map") then
                return
            end
            u130 = true
            u0.openFrame("Play", true)
            local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
            if MenuSceneController.IsActive() then
                MenuSceneController.HideMenuScene(true, false)
            end
            return
        end
        return
    end
end

local function getStoreNewAlert() -- Line: 827 -- upvalues: getTopButton (val)
    local Store = getTopButton("Store")
    local NewAlert = Store and Store:FindFirstChild("NewAlert")
    if NewAlert and NewAlert:IsA("GuiObject") then
        return NewAlert
    end
    return nil
end

local function hasUnseenShopVersion() -- Line: 836 -- upvalues: DataController (val), LocalPlayer (val), Constants (val)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return false
    end
    return (DataController.Get(LocalPlayer, "LastShopVersionViewed")) ~= Constants.SHOP_VERSION
end

local function updateStoreNewAlert() -- Line: 843
    -- upvalues: getTopButton (val), DataController (val), LocalPlayer (val), Constants (val)
    local Store = getTopButton("Store")
    local NewAlert = Store and Store:FindFirstChild("NewAlert")
    local v1 = if not NewAlert then nil else if not NewAlert:IsA("GuiObject") then nil else NewAlert
    if v1 then
        v1.Visible = if DataController.IsDataLoaded(LocalPlayer) then (DataController.Get(LocalPlayer, "LastShopVersionViewed")) ~= Constants.SHOP_VERSION else false
    end
end

function u137() -- Line: 850
    -- upvalues: DataController (val), LocalPlayer (val), Constants (val), getTopButton (val), Remotes (val)
    if not (if DataController.IsDataLoaded(LocalPlayer) then (DataController.Get(LocalPlayer, "LastShopVersionViewed")) ~= Constants.SHOP_VERSION else false) then
        return
    end
    local Store = getTopButton("Store")
    local NewAlert = Store and Store:FindFirstChild("NewAlert")
    local v1 = if not NewAlert then nil else if not NewAlert:IsA("GuiObject") then nil else NewAlert
    if v1 then
        v1.Visible = false
    end
    Remotes.Player.MarkShopVersionViewed.Send()
end

local function shouldPreserveMenuFrame() -- Line: 862 -- upvalues: u154 (ref), MenuState (val)
    if not u154 then
        return false
    end
    local v1 = MenuState.GetCurrentScreen()
    if u154.Menu.Visible and v1 then
        if not MenuState.IsPreservableScreen(v1) then
            return false
        end
        local v2 = u154.Menu:FindFirstChild(v1)
        local Visible = false
        if v2 ~= nil then
            Visible = v2.Visible
        end
        return Visible
    end
    return false
end

function u0.ResetToMainMenu() -- Line: 880
    -- upvalues: Profiler (val), MenuState (val), u154 (ref), shouldPreserveMenuFrame (val), u132 (ref)
    -- upvalues: setNavigationVisible (val), u133 (ref), tweenButton (val), u142 (val), u153 (ref), u147 (val)
    Profiler.mark("UI.Top.ResetToMainMenu")
    if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
        if u154 and u154:FindFirstChild("Menu") then
            if shouldPreserveMenuFrame() then
                return
            end
            for i, v in ipairs(u154.Menu:GetChildren()) do
                if v:IsA("Frame")
                    and v.Name ~= "Top"
                    and v.Name ~= "Dashboard"
                    and v.Name ~= "Rewards"
                    and v.Name ~= "UpdateLog"
                    and v.Name ~= "TutorialPrompt" then
                    v.Visible = false
                end
            end
            local Dashboard = u154.Menu:FindFirstChild("Dashboard")
            if Dashboard then
                Dashboard.Visible = true
                u132 = Dashboard
            end
            local Top = u154.Menu:FindFirstChild("Top")
            if Top then
                Top.Visible = true
            end
            setNavigationVisible(true)
            MenuState.SetBlurEnabled(false)
            u154.Menu.BackgroundTransparency = 1
            local Pattern = u154.Menu:FindFirstChild("Pattern")
            if Pattern then
                Pattern.Visible = true
            end
            MenuState.SetScreen("Dashboard")
            if u133 then
                tweenButton(u133, u142)
            end
            u133 = u153.Top.Buttons.Dashboard
            tweenButton(u133, u147)
            return
        end
        return
    end
end

function u0.ShowMainMenu() -- Line: 946
    -- upvalues: MenuState (val), CameraController (val), LocalPlayer (val), u154 (ref), u0 (val)
    -- upvalues: ReplicatedStorage (val)
    if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
        MenuState.SetWantsMainMenu(true)
        CameraController.setForceLockOverride("Menu", true)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            CameraController.setPerspective(true, true)
        end
        u154.Gameplay.Visible = false
        u154.Gameplay.Bottom.Visible = false
        u154.Menu.Visible = true
        u0.ResetToMainMenu()

        local function tryMenuScene() -- Line: 962 -- upvalues: u154 (upval), ReplicatedStorage (upval)
            if u154.Menu.Visible and not u154.Gameplay.Visible then
                require(ReplicatedStorage.Controllers.MenuSceneController).ShowMenuScene()
            end
        end

        if u154.Menu.Visible and not u154.Gameplay.Visible then
            require(ReplicatedStorage.Controllers.MenuSceneController).ShowMenuScene()
        end
        if LocalPlayer.Character then
            task.delay(0.15, tryMenuScene)
            task.delay(0.5, tryMenuScene)
        end
        return
    end
end

function u0.Initialize(a1, a2) -- Line: 978
    -- upvalues: Profiler (val), u154 (ref), u153 (ref), setupButton (val), ActivateButton (val), MenuState (val)
    -- upvalues: u0 (val), u157 (ref), Constants (val), animateBlackmarketButton (val), fitTopButtonsBesideTabs (val)
    -- upvalues: TeamSelection (val)
    Profiler.mark("UI.Top.Initialize")
    u154 = a1
    u153 = a2
    local v1 = {u153.Top.Buttons, u153.Bottom.Buttons}
    local v2 = nil
    local v3 = nil
    for i, j in v1, v2, v3 do
        for i2, v in ipairs(j:GetChildren()) do
            if v:IsA("ImageButton") then
                setupButton(v)
                ActivateButton(v)
                v.MouseButton1Click:Connect(function() -- Line: 988 -- upvalues: MenuState (upval), u0 (upval), v (val)
                    MenuState.HoldNavigationSelection(nil)
                    u0.openFrame(v.Name, v.Name == "Play")
                end)
            end
        end
    end
    local Buttons = u153.Top.Buttons
    u157 = Buttons.Size.Y
    local Blackmarket = Buttons:FindFirstChild("Blackmarket")
    if not Blackmarket or not Blackmarket:IsA("GuiButton") then
        if Blackmarket and Blackmarket:IsA("GuiButton") then
            animateBlackmarketButton(Blackmarket, function() -- Line: 1004 -- upvalues: u154 (upval), u153 (upval), Blackmarket (val)
                return u154.Enabled and u154.Menu.Visible and u153.Visible and Blackmarket.Visible
            end)
        end
    elseif not Constants.BLACK_MARKET_ENABLED then
        Blackmarket.Visible = false
    elseif Blackmarket and Blackmarket:IsA("GuiButton") then
        animateBlackmarketButton(Blackmarket, function() -- Line: 1004 -- upvalues: u154 (upval), u153 (upval), Blackmarket (val)
            return u154.Enabled and u154.Menu.Visible and u153.Visible and Blackmarket.Visible
        end)
    end
    local u47 = false

    local function queueTopButtonsFit() -- Line: 1009 -- upvalues: u47 (ref), fitTopButtonsBesideTabs (upval)
        if u47 then
            return
        end
        u47 = true
        task.defer(function() -- Line: 1015 -- upvalues: u47 (upval), fitTopButtonsBesideTabs (upval)
            u47 = false
            fitTopButtonsBesideTabs()
        end)
    end

    local Store = u154.Menu:FindFirstChild("Store")
    local Top = Store and Store:FindFirstChild("Top")
    local Categories = Top and Top:FindFirstChild("Categories")
    if Categories and Categories:IsA("GuiObject") then
        (Categories:GetPropertyChangedSignal("AbsoluteSize")):Connect(queueTopButtonsFit)
        ;(Categories:GetPropertyChangedSignal("AbsolutePosition")):Connect(queueTopButtonsFit)
        ;(Categories:GetPropertyChangedSignal("Visible")):Connect(queueTopButtonsFit)
    end
    ;(Buttons.Parent:GetPropertyChangedSignal("AbsoluteSize")):Connect(queueTopButtonsFit)
    if not u47 then
        u47 = true
        task.defer(function() -- Line: 1015 -- upvalues: u47 (ref), fitTopButtonsBesideTabs (upval)
            u47 = false
            fitTopButtonsBesideTabs()
        end)
    end
    workspace.ChildAdded:Connect(function(a1) -- Line: 1033 -- upvalues: u154 (upval), TeamSelection (upval), u0 (upval)
        if a1.Name == "Map" then
            task.delay(0.25, function() -- Line: 1035 -- upvalues: u154 (upval), TeamSelection (upval), u0 (upval), a1 (val)
                if not u154.Menu.Visible and TeamSelection.shouldUseMapCamera() then
                    u0.UpdateBackground(a1)
                    return
                end
            end)
        end
    end)
end

function u0.Start() -- Line: 1047
    -- upvalues: Profiler (val), u133 (ref), u153 (ref), tweenButton (val), u147 (val), u154 (ref)
    -- upvalues: CameraController (val), syncControlLockWithMenuVisibility (val), syncCameraWithTeamSelection (val)
    -- upvalues: LocalPlayer (val), IsTutorialMode (val), UserInputService (val), MenuState (val)
    -- upvalues: cycleUtilityButtons (val), getControllerCurrentTab (val), u171 (val), goToTab (val), GuiService (val)
    -- upvalues: u136 (ref), u135 (ref), getPageButtonForBack (val), CloseButtonRegistry (val), Router (val), u134 (ref)
    -- upvalues: getTopButton (val), u0 (val), u142 (val), u132 (ref), Observers (val), GameState (val)
    -- upvalues: ReplicatedStorage (val), shouldPreserveMenuFrame (val), TeamSelection (val), DataController (val)
    -- upvalues: updateStoreNewAlert (val), Constants (val), autoJoinMatch (val)
    debug.setmemorycategory("UI.Top.Start")
    Profiler.mark("UI.Top.Start")
    u133 = u153.Top.Buttons.Dashboard
    tweenButton(u133, u147)
    local Pattern = u154.Menu:FindFirstChild("Pattern")
    u154.Menu.BackgroundTransparency = 1
    if Pattern then
        Pattern.Visible = false
    end
    if u154.Menu.Visible then
        CameraController.setForceLockOverride("Menu", true)
    end
    ;(u154.Menu:GetPropertyChangedSignal("Visible")):Connect(syncControlLockWithMenuVisibility)
    local Gameplay = u154:FindFirstChild("Gameplay")
    local Middle = Gameplay and Gameplay:FindFirstChild("Middle")
    local TeamSelection_2 = Middle and Middle:FindFirstChild("TeamSelection")
    local Bottom = Gameplay and Gameplay:FindFirstChild("Bottom")
    if TeamSelection_2 and TeamSelection_2:IsA("GuiObject") then
        (TeamSelection_2:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 1067 -- upvalues: syncControlLockWithMenuVisibility (upval), syncCameraWithTeamSelection (upval)
            syncControlLockWithMenuVisibility()
            syncCameraWithTeamSelection()
        end)
    end
    if Bottom and Bottom:IsA("GuiObject") then
        (Bottom:GetPropertyChangedSignal("Visible")):Connect(syncControlLockWithMenuVisibility)
    end
    syncControlLockWithMenuVisibility()
    local Attribute = LocalPlayer:GetAttribute("Team")
    local v1 = true
    if Attribute ~= "Counter-Terrorists" then
        v1 = Attribute == "Terrorists"
    end
    if not LocalPlayer.Character and not v1 and not IsTutorialMode() then
        if not CameraController.isForceLockOverrideActive() then
            CameraController.setForceLockOverride("Menu", true)
        end
        if not u154.Menu.Visible then
            u154.Menu.Visible = true
        end
        u154.Gameplay.Visible = false
        u154.Gameplay.Bottom.Visible = false
    end
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 1105
        -- upvalues: u154 (upval), MenuState (upval), LocalPlayer (upval), u153 (upval), cycleUtilityButtons (upval)
        -- upvalues: getControllerCurrentTab (upval), u171 (upval), goToTab (upval)
        if u154 and u154.Menu.Visible then
            if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
                local v1
                if LocalPlayer:GetAttribute("IsPlayerChatting") then
                    return
                end
                local v2 = a1.KeyCode == Enum.KeyCode.ButtonL1
                local v3 = a1.KeyCode == Enum.KeyCode.ButtonR1
                if not v2 and not v3 then
                    return
                end
                if MenuState.IsSelectionWithin(u153.Top.Buttons) then
                    cycleUtilityButtons(v2)
                    return
                end
                if MenuState.HandleBumperInput(v2) then
                    return
                end
                local v4 = getControllerCurrentTab()
                local v5 = table.find(u171, v4)
                if v5 then
                    local v6 = #u171
                    v1 = if not v2 then u171[v5 % v6 + 1] else u171[(v5 - 2 + v6) % v6 + 1]
                else
                    v1 = nil
                end
                if v1 then
                    goToTab(v1, v1 == "Play")
                end
                return
            end
            return
        end
    end)
    UserInputService.InputBegan:Connect(function(a1) -- Line: 1141
        -- upvalues: u154 (upval), MenuState (upval), LocalPlayer (upval), GuiService (upval), u136 (upval)
        -- upvalues: u135 (upval), getPageButtonForBack (upval), CloseButtonRegistry (upval), Router (upval)
        if a1.KeyCode == Enum.KeyCode.ButtonB and u154 and u154.Menu.Visible then
            if not MenuState.IsInspectActive()
                and not MenuState.IsCaseSceneActive()
                and not LocalPlayer:GetAttribute("IsPlayerChatting") then
                local SelectedObject = GuiService.SelectedObject
                if SelectedObject == nil and os.clock() - u136 < 0.1 then
                    SelectedObject = u135
                end
                local u29 = getPageButtonForBack(SelectedObject)
                if not u29 then
                    return
                end
                task.defer(function() -- Line: 1160 -- upvalues: CloseButtonRegistry (upval), GuiService (upval), u29 (val), Router (upval)
                    if CloseButtonRegistry.IsDoublePressed() then
                        return
                    end
                    GuiService.SelectedObject = u29
                    Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
                end)
                return
            end
            return
        end
    end)
    ;(GuiService:GetPropertyChangedSignal("SelectedObject")):Connect(function() -- Line: 1169 -- upvalues: u135 (upval), u134 (upval), GuiService (upval), u136 (upval)
        u135 = u134
        u134 = GuiService.SelectedObject
        u136 = os.clock()
    end)
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 1177
        -- upvalues: u154 (upval), MenuState (upval), LocalPlayer (upval), getTopButton (upval), GuiService (upval)
        -- upvalues: u0 (upval)
        if u154 and u154.Menu.Visible then
            if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
                if not LocalPlayer:GetAttribute("IsPlayerChatting")
                    and a1.UserInputType == Enum.UserInputType.Gamepad1
                    and a1.KeyCode == Enum.KeyCode.ButtonA then
                    local Play = getTopButton("Play")
                    if not Play then
                        return
                    end
                    local SelectedObject = GuiService.SelectedObject
                    if SelectedObject == Play then
                        u0.openFrame("Play", true)
                        return
                    end
                    if SelectedObject and SelectedObject:IsDescendantOf(Play) then
                        u0.openFrame("Play", true)
                        return
                    end
                    return
                end
                return
            end
            return
        end
    end)
    u0.openFrame("Dashboard")
    ;(GuiService:GetPropertyChangedSignal("SelectedObject")):Connect(function() -- Line: 1207
        -- upvalues: u154 (upval), GuiService (upval), MenuState (upval), u153 (upval), u171 (upval)
        -- upvalues: getTopButton (upval), u133 (upval), tweenButton (upval), u147 (upval), u142 (upval), Router (upval)
        if u154 and u154.Menu.Visible then
            local SelectedObject = GuiService.SelectedObject
            if not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() and u153 and SelectedObject then
                local v1
                local v2 = nil
                for i, v in ipairs(u171) do
                    v1 = getTopButton(v)
                    if v1 then
                        if SelectedObject ~= v1 and not SelectedObject:IsDescendantOf(v1) then
                            continue
                        end
                        v2 = v1
                        break
                    end
                end
                if not v2 then
                    local Dashboard = getTopButton("Dashboard")
                    if Dashboard then
                        if SelectedObject == Dashboard or SelectedObject:IsDescendantOf(Dashboard) then
                            v2 = Dashboard
                        end
                    end
                end
                if v2 and u133 ~= v2 then
                    local v3 = u133
                    u133 = v2
                    tweenButton(v2, u147)
                    if v3 and v3 ~= v2 then
                        tweenButton(v3, u142)
                    end
                    Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
                end
                return
            end
            return
        end
    end)
    MenuState.OnScreenChanged:Connect(function(a1, a2) -- Line: 1239
        -- upvalues: u154 (upval), u132 (upval), u153 (upval), u133 (upval), tweenButton (upval), u147 (upval)
        -- upvalues: u142 (upval)
        if not a2 then
            return
        end
        local v1 = u154.Menu:FindFirstChild(a2)
        if v1 and v1:IsA("Frame") then
            u132 = v1
        end
        local v2 = u153.Bottom.Buttons:FindFirstChild(a2) or u153.Top.Buttons:FindFirstChild(a2)
        if v2 and v2:IsA("GuiButton") and u133 ~= v2 then
            local v3 = u133
            u133 = v2
            tweenButton(v2, u147)
            if v3 and v3 ~= v2 then
                tweenButton(v3, u142)
            end
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function(a1) -- Line: 1261 -- upvalues: Profiler (upval), u154 (upval), MenuState (upval), CameraController (upval)
        Profiler.defer("UI.Top.CharacterAddedDeferred", function() -- Line: 1264 -- upvalues: u154 (upval), MenuState (upval), CameraController (upval)
            local Visible = u154.Menu.Visible
            local Visible_2 = u154.Gameplay.Middle.TeamSelection.Visible
            local v1 = MenuState.IsCaseSceneActive()
            local v2 = MenuState.IsInspectActive()
            if not Visible and not Visible_2 and not v1 and not v2 then
                CameraController.resetForceLockOverride()
                CameraController.setPerspective(true, false)
            end
        end)
    end)
    Observers.observeAttribute(LocalPlayer, "Team", function(a1) -- Line: 1278 -- upvalues: u0 (upval)
        if a1 == "Spectators" then
            u0.CloseTeamSelection()
        end
    end)
    GameState.ListenToState(function(a1, a2) -- Line: 1284
        -- upvalues: MenuState (upval), u154 (upval), CameraController (upval), IsTutorialMode (upval), u0 (upval)
        -- upvalues: ReplicatedStorage (upval), Router (upval), shouldPreserveMenuFrame (upval), LocalPlayer (upval)
        -- upvalues: TeamSelection (upval), Profiler (upval)
        local Attribute
        if MenuState.IsCaseSceneActive() then
            if a2 == "Game Ending" or a2 == "Map Voting" then
                u154.Gameplay.Bottom.Visible = false
                u154.Gameplay.Visible = false
            end
            return
        end
        if MenuState.IsInspectActive() then
            return
        end
        if MenuState.IsTradeUpActive() then
            if a2 == "Game Ending" or a2 == "Map Voting" then
                u154.Gameplay.Bottom.Visible = false
                u154.Gameplay.Visible = false
                if not u154.Menu.Visible then
                    CameraController.setForceLockOverride("Menu", true)
                    u154.Menu.Visible = true
                end
            end
            return
        end
        if a2 ~= "Game Ending" and a2 ~= "Map Voting" then
            if a2 ~= "Map Voting" then
                if a1 ~= "Game Ending" and a1 ~= "Map Voting" then
                    return
                end
                if a2 ~= "Game Ending" and a2 ~= "Map Voting" then
                    if IsTutorialMode() and u154.Menu.Visible then
                        return
                    end
                    if a1 == "Map Voting" then
                        if u154.Menu.Visible then
                            return
                        end
                        if MenuState.WantsMainMenu() then
                            u0.ResetToMainMenu()
                            CameraController.setForceLockOverride("Menu", true)
                            u154.Gameplay.Visible = false
                            u154.Gameplay.Bottom.Visible = false
                            u154.Menu.Visible = true
                            return
                        end
                        Attribute = LocalPlayer:GetAttribute("Team")
                        if LocalPlayer.Character and Attribute and Attribute ~= "Spectators" then
                            Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                                -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                                -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                                if MenuState.IsInspectActive() then
                                    return
                                end
                                if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                                    and not u154.Menu.Visible then
                                    if not shouldPreserveMenuFrame() then
                                        u0.ResetToMainMenu()
                                    end
                                    CameraController.setForceLockOverride("Menu", true)
                                    u154.Gameplay.Visible = false
                                    u154.Menu.Visible = true
                                end
                            end)
                            return
                        end
                        MenuState.HideMenu()
                        u154.Gameplay.Visible = true
                        u154.Gameplay.Top.Visible = true
                        TeamSelection.openFrame()
                        return
                    end
                    if u154.Menu.Visible and shouldPreserveMenuFrame() then
                        return
                    end
                    Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                        -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                        -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                        if MenuState.IsInspectActive() then
                            return
                        end
                        if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                            and not u154.Menu.Visible then
                            if not shouldPreserveMenuFrame() then
                                u0.ResetToMainMenu()
                            end
                            CameraController.setForceLockOverride("Menu", true)
                            u154.Gameplay.Visible = false
                            u154.Menu.Visible = true
                        end
                    end)
                end
                return
            end
            if not LocalPlayer:GetAttribute("FollowGamemode") and not LocalPlayer:GetAttribute("IsSpectating") then
                if not u154.Menu.Visible and not shouldPreserveMenuFrame() then
                    u0.openFrame("Dashboard")
                    u0.ToggleMenu()
                end
                if a1 ~= "Game Ending" and a1 ~= "Map Voting" then
                    return
                end
                if a2 ~= "Game Ending" and a2 ~= "Map Voting" then
                    if IsTutorialMode() and u154.Menu.Visible then
                        return
                    end
                    if a1 == "Map Voting" then
                        if u154.Menu.Visible then
                            return
                        end
                        if MenuState.WantsMainMenu() then
                            u0.ResetToMainMenu()
                            CameraController.setForceLockOverride("Menu", true)
                            u154.Gameplay.Visible = false
                            u154.Gameplay.Bottom.Visible = false
                            u154.Menu.Visible = true
                            return
                        end
                        Attribute = LocalPlayer:GetAttribute("Team")
                        if LocalPlayer.Character and Attribute and Attribute ~= "Spectators" then
                            Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                                -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                                -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                                if MenuState.IsInspectActive() then
                                    return
                                end
                                if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                                    and not u154.Menu.Visible then
                                    if not shouldPreserveMenuFrame() then
                                        u0.ResetToMainMenu()
                                    end
                                    CameraController.setForceLockOverride("Menu", true)
                                    u154.Gameplay.Visible = false
                                    u154.Menu.Visible = true
                                end
                            end)
                            return
                        end
                        MenuState.HideMenu()
                        u154.Gameplay.Visible = true
                        u154.Gameplay.Top.Visible = true
                        TeamSelection.openFrame()
                        return
                    end
                    if u154.Menu.Visible and shouldPreserveMenuFrame() then
                        return
                    end
                    Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                        -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                        -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                        if MenuState.IsInspectActive() then
                            return
                        end
                        if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                            and not u154.Menu.Visible then
                            if not shouldPreserveMenuFrame() then
                                u0.ResetToMainMenu()
                            end
                            CameraController.setForceLockOverride("Menu", true)
                            u154.Gameplay.Visible = false
                            u154.Menu.Visible = true
                        end
                    end)
                end
                return
            end
            if not u154.Menu.Visible then
                u0.openFrame("Play")
                return
            end
            if not MenuState.WantsMainMenu() and not shouldPreserveMenuFrame() then
                u0.openFrame("Play")
                return
            end
            return
        end
        if IsTutorialMode() then
            u0.ShowMainMenu()
            return
        end
        if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
            if MenuState.IsInspectActive() then
                Router.broadcastRouter("WeaponInspectCloseForGameEnd")
            end
            return
        end
        u154.Gameplay.Visible = false
        u154.Gameplay.Bottom.Visible = false
        if MenuState.IsInspectActive() then
            Router.broadcastRouter("WeaponInspectCloseForGameEnd")
        end
        if not shouldPreserveMenuFrame() then
            u0.ResetToMainMenu()
        end
        if not u154.Menu.Visible then
            CameraController.setForceLockOverride("Menu", true)
            u154.Menu.Visible = true
        end
        if a2 ~= "Map Voting" then
            if a1 ~= "Game Ending" and a1 ~= "Map Voting" then
                return
            end
            if a2 ~= "Game Ending" and a2 ~= "Map Voting" then
                if IsTutorialMode() and u154.Menu.Visible then
                    return
                end
                if a1 == "Map Voting" then
                    if u154.Menu.Visible then
                        return
                    end
                    if MenuState.WantsMainMenu() then
                        u0.ResetToMainMenu()
                        CameraController.setForceLockOverride("Menu", true)
                        u154.Gameplay.Visible = false
                        u154.Gameplay.Bottom.Visible = false
                        u154.Menu.Visible = true
                        return
                    end
                    Attribute = LocalPlayer:GetAttribute("Team")
                    if LocalPlayer.Character and Attribute and Attribute ~= "Spectators" then
                        Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                            -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                            -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                            if MenuState.IsInspectActive() then
                                return
                            end
                            if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                                and not u154.Menu.Visible then
                                if not shouldPreserveMenuFrame() then
                                    u0.ResetToMainMenu()
                                end
                                CameraController.setForceLockOverride("Menu", true)
                                u154.Gameplay.Visible = false
                                u154.Menu.Visible = true
                            end
                        end)
                        return
                    end
                    MenuState.HideMenu()
                    u154.Gameplay.Visible = true
                    u154.Gameplay.Top.Visible = true
                    TeamSelection.openFrame()
                    return
                end
                if u154.Menu.Visible and shouldPreserveMenuFrame() then
                    return
                end
                Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                    -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                    -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                    if MenuState.IsInspectActive() then
                        return
                    end
                    if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                        and not u154.Menu.Visible then
                        if not shouldPreserveMenuFrame() then
                            u0.ResetToMainMenu()
                        end
                        CameraController.setForceLockOverride("Menu", true)
                        u154.Gameplay.Visible = false
                        u154.Menu.Visible = true
                    end
                end)
            end
            return
        end
        if not LocalPlayer:GetAttribute("FollowGamemode") and not LocalPlayer:GetAttribute("IsSpectating") then
            if not u154.Menu.Visible and not shouldPreserveMenuFrame() then
                u0.openFrame("Dashboard")
                u0.ToggleMenu()
            end
            if a1 ~= "Game Ending" and a1 ~= "Map Voting" then
                return
            end
            if a2 ~= "Game Ending" and a2 ~= "Map Voting" then
                if IsTutorialMode() and u154.Menu.Visible then
                    return
                end
                if a1 == "Map Voting" then
                    if u154.Menu.Visible then
                        return
                    end
                    if MenuState.WantsMainMenu() then
                        u0.ResetToMainMenu()
                        CameraController.setForceLockOverride("Menu", true)
                        u154.Gameplay.Visible = false
                        u154.Gameplay.Bottom.Visible = false
                        u154.Menu.Visible = true
                        return
                    end
                    Attribute = LocalPlayer:GetAttribute("Team")
                    if LocalPlayer.Character and Attribute and Attribute ~= "Spectators" then
                        Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                            -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                            -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                            if MenuState.IsInspectActive() then
                                return
                            end
                            if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                                and not u154.Menu.Visible then
                                if not shouldPreserveMenuFrame() then
                                    u0.ResetToMainMenu()
                                end
                                CameraController.setForceLockOverride("Menu", true)
                                u154.Gameplay.Visible = false
                                u154.Menu.Visible = true
                            end
                        end)
                        return
                    end
                    MenuState.HideMenu()
                    u154.Gameplay.Visible = true
                    u154.Gameplay.Top.Visible = true
                    TeamSelection.openFrame()
                    return
                end
                if u154.Menu.Visible and shouldPreserveMenuFrame() then
                    return
                end
                Profiler.defer("UI.Top.StateTransitionDeferred", function() -- Line: 1416
                    -- upvalues: MenuState (upval), ReplicatedStorage (upval), u154 (upval)
                    -- upvalues: shouldPreserveMenuFrame (upval), u0 (upval), CameraController (upval)
                    if MenuState.IsInspectActive() then
                        return
                    end
                    if require(ReplicatedStorage.Controllers.MenuSceneController).IsActive()
                        and not u154.Menu.Visible then
                        if not shouldPreserveMenuFrame() then
                            u0.ResetToMainMenu()
                        end
                        CameraController.setForceLockOverride("Menu", true)
                        u154.Gameplay.Visible = false
                        u154.Menu.Visible = true
                    end
                end)
            end
            return
        end
        if not u154.Menu.Visible then
            u0.openFrame("Play")
            return
        end
        if not MenuState.WantsMainMenu() and not shouldPreserveMenuFrame() then
            u0.openFrame("Play")
            return
        end
    end)
    DataController.CreateListener(LocalPlayer, "LastShopVersionViewed", updateStoreNewAlert)
    local Store = getTopButton("Store")
    local NewAlert = Store and Store:FindFirstChild("NewAlert")
    local v2 = if not NewAlert then nil else if not NewAlert:IsA("GuiObject") then nil else NewAlert
    if v2 then
        v2.Visible = if DataController.IsDataLoaded(LocalPlayer) then (DataController.Get(LocalPlayer, "LastShopVersionViewed")) ~= Constants.SHOP_VERSION else false
    end
    GameState.ListenToState(function() -- Line: 1440 -- upvalues: Profiler (upval), autoJoinMatch (upval)
        Profiler.defer("UI.Top.AutoJoinTutorialDeferred", autoJoinMatch)
    end)
    ;(workspace:GetAttributeChangedSignal("ServerGamemode")):Connect(autoJoinMatch)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(autoJoinMatch)
    ;(workspace:GetAttributeChangedSignal("BotLobby")):Connect(autoJoinMatch)
    workspace.ChildAdded:Connect(function(a1) -- Line: 1446 -- upvalues: autoJoinMatch (upval)
        if a1.Name == "Map" then
            autoJoinMatch()
        end
    end)
    Profiler.defer("UI.Top.AutoJoinTutorialDeferred", autoJoinMatch)
    local u282 = workspace:GetAttribute("TutorialActive") == true
    ;(workspace:GetAttributeChangedSignal("TutorialActive")):Connect(function() -- Line: 1454 -- upvalues: u282 (ref), u0 (upval)
        local v1 = workspace:GetAttribute("TutorialActive") == true
        if u282 and not v1 then
            u0.ShowMainMenu()
        end
        u282 = v1
    end)
end

return u0