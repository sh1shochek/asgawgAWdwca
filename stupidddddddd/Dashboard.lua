-- ReplicatedStorage.Interface.Screens.Menu.Dashboard
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Dashboard
-- Decompile time: 5.95 ms

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local FormatDuration = require(ReplicatedStorage.Components.Common.FormatDuration)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local AnimateDashboardCard = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateDashboardCard)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Store = require(ReplicatedStorage.Interface.Screens.Menu.Store)
local Top = require(ReplicatedStorage.Interface.Screens.Menu.Top)
local TutorialPrompt = require(ReplicatedStorage.Interface.Screens.Menu.TutorialPrompt)
local UpdateLogs = require(ReplicatedStorage.Database.Custom.UpdateLogs)
local LocalPlayer = Players.LocalPlayer
local u88 = nil
local u89 = nil
local u90 = nil
local EditMobile = require(script:WaitForChild("EditMobile"))
local u102 = Color3.fromRGB(255, 255, 255)
local u107 = Color3.fromRGB(201, 201, 201)
local u112 = Color3.fromRGB(50, 46, 46)
local u117 = Color3.fromRGB(50, 46, 46)
local u118 = nil

local function SetupNewsSection(a1) -- Line: 60
    -- upvalues: UpdateLogs (val), ActivateButton (val), Router (val), u118 (ref)
    local Container = a1.Container
    local Information = Container.Bottom.Container.Information
    local v1 = UpdateLogs[1]
    Container.ImageContent.Image.Image = v1.Banner
    Information.Label.Text = v1.Title
    Information.Description.Text = v1.Date
    local Button = Information.Buttons.Button
    ActivateButton(Button)
    Button.Title.Text = "View Updates"
    Button.MouseButton1Click:Connect(function() -- Line: 72 -- upvalues: Router (upval), u118 (upval)
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u118.Parent.UpdateLog.Visible = true
    end)
end

local function SetupFeaturedSection(a1) -- Line: 80
    -- upvalues: u89 (ref), u88 (ref), DataController (val), LocalPlayer (val), Store (val), u102 (val), u117 (val)
    -- upvalues: u107 (val), u112 (val), Router (val), ActivateButton (val), Top (val), MenuState (val), u90 (ref)
    local View
    local Container = a1.Container
    local u2 = {}
    local v1 = {Destination = "Bundle", Frame = Container.CurrentBundle}
    local v2 = {Destination = "StarterPack", Frame = Container.StarterPack}
    u2[1] = v1
    u2[2] = v2
    u89 = Container.CurrentBundle
    u88 = Container.StarterPack
    local u9 = 1
    for i, v in ipairs(u2) do
        if v.Frame.Visible then
            u9 = i
            break
        end
    end
    local Buttons = Container.Bottom.Buttons
    local Left = Buttons.Left
    local Right = Buttons.Right

    local function IsPageAvailable(a1) -- Line: 101
        -- upvalues: u2 (val), DataController (upval), LocalPlayer (upval), Store (upval)
        if u2[a1].Destination ~= "StarterPack" then
            return true
        end
        return not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable()
    end

    local function FindAvailablePage(a1, a2) -- Line: 110
        -- upvalues: u2 (val), DataController (upval), LocalPlayer (upval), Store (upval)
        local v1 = a1
        while v1 >= 1 do
            if not (v1 <= #u2) then
                break
            end
            if if u2[v1].Destination == "StarterPack" then not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable() else true then
                return v1
            end
            v1 = v1 + v2
        end
        return nil
    end

    local function UpdateFeaturedPage() -- Line: 121
        -- upvalues: u9 (ref), u2 (val), DataController (upval), LocalPlayer (upval), Store (upval)
        -- upvalues: FindAvailablePage (val), Left (val), u102 (upval), u117 (upval), Right (val), Buttons (val)
        -- upvalues: u107 (upval), u112 (upval)
        local v1
        if not (if u2[u9].Destination == "StarterPack" then not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable() else true) then
            u9 = FindAvailablePage(u9 + 1, 1) or FindAvailablePage(u9 - 1, -1) or u9
        end
        for i, v in ipairs(u2) do
            v.Frame.Visible = (if u2[i].Destination == "StarterPack" then not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable() else true) and i == u9
        end
        Left.ImageColor3 = FindAvailablePage(u9 - 1, -1) and u102 or u117
        Right.ImageColor3 = FindAvailablePage(u9 + 1, 1) and u102 or u117
        local v2 = #u2
        for i2 = 1, v2 do
            v1 = Buttons:FindFirstChild((tostring(i2)))
            if v1 and v1:IsA("Frame") then
                v1.Visible = if u2[i2].Destination == "StarterPack" then not DataController.IsDataLoaded(LocalPlayer) or Store.IsStarterPackAvailable() else true
                v1.BackgroundColor3 = not (i2 ~= u9) and u107 or u112
            end
        end
    end

    for i2, j in {[Left] = -1, [Right] = 1} do
        i2.MouseButton1Click:Connect(function() -- Line: 147
            -- upvalues: FindAvailablePage (val), u9 (ref), j (val), Router (upval), UpdateFeaturedPage (val)
            local v1 = FindAvailablePage(u9 + j, j)
            if not v1 then
                return
            end
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            u9 = v1
            UpdateFeaturedPage()
        end)
    end
    for i3, k in ipairs(u2) do
        View = k.Frame.Interact.View
        ActivateButton(View)
        View.MouseButton1Click:Connect(function() -- Line: 162 -- upvalues: Router (upval), Top (upval), MenuState (upval), k (val), Store (upval)
            Router.broadcastRouter("RunInterfaceSound", "UI Click")
            Top.openFrame("Store")
            if MenuState.GetCurrentScreen() ~= "Store" then
                return
            end
            if k.Destination == "StarterPack" then
                Store.OpenBundleSection()
                return
            end
            Store.OpenFeaturedBundleSection()
        end)
    end
    u90 = UpdateFeaturedPage
    UpdateFeaturedPage()
end

local function SetupToggleCollapse(a1, a2, a3) -- Line: 183
    -- upvalues: TweenService (val), ActivateButton (val)
    local TextLabel = a2:FindFirstChildOfClass("TextLabel")
    local u7 = false
    local Scale = a1.Size.X.Scale
    local Position = a1.Position
    local BackgroundTransparency = a1.BackgroundTransparency
    local u31 = UDim2.new(
        if not a3 then Position.X.Scale + Scale + 0.04 else Position.X.Scale - Scale - 0.04,
        Position.X.Offset,
        Position.Y.Scale,
        Position.Y.Offset
    )
    local u34 = if not a3 then ">" else "<"
    local u37 = if not a3 then "<" else ">"

    local function SetVisibleState(a1_2) -- Line: 204
        -- upvalues: a1 (val), BackgroundTransparency (val)
        local v1 = a1_2
        for i, j in a1:GetChildren() do
            if j:IsA("GuiObject") then
                j.Visible = v1
            elseif j:IsA("UIStroke") or j:IsA("UIGradient") or j:IsA("UIShadow") then
                j.Enabled = v1
            end
        end
        a1.BackgroundTransparency = if not v1 then 1 else BackgroundTransparency
    end

    local function UpdateCollapseState() -- Line: 216
        -- upvalues: TextLabel (val), u7 (ref), u37 (val), u34 (val), TweenService (upval), a1 (val), u31 (val)
        -- upvalues: Position (val), SetVisibleState (val)
        if TextLabel then
            TextLabel.Text = if not u7 then u34 else u37
        end
        local v1 = TweenService:Create(
            a1,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = if not u7 then Position else u31}
        )
        if not u7 then
            SetVisibleState(true)
        else
            v1.Completed:Once(function() -- Line: 226 -- upvalues: SetVisibleState (upval)
                SetVisibleState(false)
            end)
        end
        v1:Play()
    end

    UpdateCollapseState()
    ActivateButton(a2)
    a2.Activated:Connect(function() -- Line: 238 -- upvalues: u7 (ref), UpdateCollapseState (val)
        u7 = not u7
        UpdateCollapseState()
    end)
end

local function SetupToggleCollapses(a1, a2) -- Line: 246
    -- upvalues: SetupToggleCollapse (val)
    local v1
    for i, j in a1:QueryDescendants("#ToggleCollapsed") do
        if j:IsA("GuiButton") then
            v1 = j:FindFirstAncestorWhichIsA("GuiObject")
            if v1 then
                SetupToggleCollapse(v1, j, a2)
            end
        end
    end
end

local function SetupLeftDashboard(a1) -- Line: 261
    -- upvalues: SetupNewsSection (val), SetupFeaturedSection (val), SetupToggleCollapses (val)
    SetupNewsSection((a1:WaitForChild("News")))
    SetupFeaturedSection((a1:WaitForChild("Featured")))
    SetupToggleCollapses(a1, true)
end

local function SetupTutorialCard(a1) -- Line: 270
    -- upvalues: AnimateDashboardCard (val), TutorialPrompt (val), Constants (val), IsTutorialMode (val)
    -- upvalues: DataController (val), LocalPlayer (val)
    local Button = a1:FindFirstChild("Button")
    if Button then
        AnimateDashboardCard(a1, Button)
        Button.MouseButton1Click:Connect(TutorialPrompt.RequestTeleport)
    end

    local function updateVisibility() -- Line: 277
        -- upvalues: a1 (val), Constants (upval), IsTutorialMode (upval), DataController (upval), LocalPlayer (upval)
        local TUTORIAL_TELEPORT_ENABLED = Constants.TUTORIAL_TELEPORT_ENABLED and not IsTutorialMode() and DataController.Get(LocalPlayer, "TutorialCompleted") ~= true
        a1.Visible = TUTORIAL_TELEPORT_ENABLED
    end

    DataController.CreateListener(LocalPlayer, "TutorialCompleted", updateVisibility)
    ;(workspace:GetAttributeChangedSignal("ServerGamemode")):Connect(updateVisibility)
    ;(workspace:GetAttributeChangedSignal("Gamemode")):Connect(updateVisibility)
    local TUTORIAL_TELEPORT_ENABLED = Constants.TUTORIAL_TELEPORT_ENABLED and not IsTutorialMode() and DataController.Get(LocalPlayer, "TutorialCompleted") ~= true
    a1.Visible = TUTORIAL_TELEPORT_ENABLED
end

local function UpdateStarterPackTimer() -- Line: 290
    -- upvalues: DataController (val), LocalPlayer (val), Store (val), FormatDuration (val), u90 (ref), u88 (ref)
    if not DataController.IsDataLoaded(LocalPlayer) then
        return
    end
    local v1 = 0
    if Store.IsStarterPackAvailable() then
        v1 = math.max(0, (Store.GetStarterPackRemainingSeconds()))
        if v1 <= 0 then
            v1 = Store.GetStarterPackWindowSeconds()
        end
    end
    local v2 = FormatDuration(v1, "Never")
    if u90 then
        u90()
    end
    if u88 then
        u88.Extra.Title.Top.Timer.Text = v2
    end
end

local function UpdateCurrentBundleTimer() -- Line: 315 -- upvalues: u89 (ref), Store (val)
    if u89 then
        u89.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText()
    end
end

local function SetupDashboardHeartbeat() -- Line: 323
    -- upvalues: RunServiceController (val), u118 (ref), Profiler (val), UpdateStarterPackTimer (val), u89 (ref)
    -- upvalues: Store (val)
    local u0 = 1
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function(a1) -- Line: 325
        -- upvalues: u118 (upval), u0 (ref), Profiler (upval), UpdateStarterPackTimer (upval), u89 (upval)
        -- upvalues: Store (upval)
        if not u118.Visible then
            u0 = 1
            return
        end
        u0 = u0 + a1
        if u0 < 1 then
            return
        end
        u0 = u0 % 1
        Profiler.mark("UI.Dashboard.Heartbeat")
        UpdateStarterPackTimer()
        if u89 then
            u89.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText()
        end
    end)
end

function v1.Initialize(a1, a2) -- Line: 345
    -- upvalues: Profiler (val), u118 (ref), EditMobile (val), SetupNewsSection (val), SetupFeaturedSection (val)
    -- upvalues: SetupToggleCollapses (val), SetupTutorialCard (val)
    Profiler.mark("UI.Dashboard.Initialize")
    u118 = a2
    EditMobile.Initialize(a1, u118)
    local Left = u118.Left
    SetupNewsSection((Left:WaitForChild("News")))
    SetupFeaturedSection((Left:WaitForChild("Featured")))
    SetupToggleCollapses(Left, true)
    local Tutorial = u118:FindFirstChild("Tutorial")
    if Tutorial and Tutorial:IsA("Frame") then
        SetupTutorialCard(Tutorial)
    end
end

function v1.Start() -- Line: 362
    -- upvalues: Profiler (val), RunServiceController (val), u118 (ref), UpdateStarterPackTimer (val), u89 (ref)
    -- upvalues: Store (val)
    debug.setmemorycategory("UI.Dashboard.Start")
    Profiler.mark("UI.Dashboard.Start")
    local u7 = 1
    RunServiceController.BindToHeartbeat("UI.Dashboard.NewsAndTimers", function(a1) -- Line: 325
        -- upvalues: u118 (upval), u7 (ref), Profiler (upval), UpdateStarterPackTimer (upval), u89 (upval)
        -- upvalues: Store (upval)
        if not u118.Visible then
            u7 = 1
            return
        end
        u7 = u7 + a1
        if u7 < 1 then
            return
        end
        u7 = u7 % 1
        Profiler.mark("UI.Dashboard.Heartbeat")
        UpdateStarterPackTimer()
        if u89 then
            u89.Extra.Title.Top.Timer.Text = Store.GetFeaturedConsoleTimerText()
        end
    end)
end

return v1