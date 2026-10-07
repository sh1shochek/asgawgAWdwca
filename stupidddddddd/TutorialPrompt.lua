-- ReplicatedStorage.Interface.Screens.Menu.TutorialPrompt
-- Script path: ReplicatedStorage.Interface.Screens.Menu.TutorialPrompt
-- Decompile time: 1.51 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataController = require(ReplicatedStorage.Controllers.DataController)
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local IsTutorialMode = require(ReplicatedStorage.Components.Common.IsTutorialMode)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local LocalPlayer = Players.LocalPlayer
local u41 = nil
local u42 = nil
local u43 = false
local u44 = 0

local function isOwed() -- Line: 49
    -- upvalues: Constants (val), IsTutorialMode (val), DataController (val), LocalPlayer (val)
    if Constants.TUTORIAL_TELEPORT_ENABLED and not IsTutorialMode() and DataController.IsDataLoaded(LocalPlayer) then
        local v1 = false
        if DataController.Get(LocalPlayer, "TutorialPrompted") ~= true then
            v1 = DataController.Get(LocalPlayer, "TutorialCompleted") ~= true
        end
        return v1
    end
    return false
end

local function hidePrompt() -- Line: 59 -- upvalues: u41 (ref)
    if u41 then
        u41.Visible = false
    end
end

local function tryShowPrompt() -- Line: 67
    -- upvalues: u43 (ref), u41 (ref), isOwed (val), u42 (ref), MenuState (val), Remotes (val)
    if not u43 and u41 and isOwed() then
        if u42.Menu.Visible and not MenuState.IsInspectActive() and not MenuState.IsCaseSceneActive() then
            local v1 = MenuState.GetCurrentScreen()
            if v1 ~= nil and v1 ~= "Dashboard" then
                return
            end
            u43 = true
            u41.Visible = true
            Remotes.Player.MarkTutorialPrompted.Send()
            return
        end
        return
    end
end

function u0.IsPending() -- Line: 89 -- upvalues: u43 (ref), isOwed (val)
    return u43 or isOwed()
end

function u0.RequestTeleport() -- Line: 95 -- upvalues: Constants (val), u44 (ref), Remotes (val)
    if not Constants.TUTORIAL_TELEPORT_ENABLED then
        return
    end
    local v1 = os.clock()
    if v1 - u44 < 1 then
        return
    end
    u44 = v1
    Remotes.Modes.SelectGamemode.Send("Tutorial")
end

function u0.Initialize(a1, a2) -- Line: 110
    -- upvalues: u42 (ref), u41 (ref), ActivateButton (val), u0 (val), hidePrompt (val)
    u42 = a1
    u41 = a2
    u41.Visible = false
    local Join = u41:FindFirstChild("Join")
    if Join then
        ActivateButton(Join, true, u42)
        Join.MouseButton1Click:Connect(u0.RequestTeleport)
    end
    local Title = u41:FindFirstChild("Title")
    local Close = Title and Title:FindFirstChild("Close")
    if Close then
        ActivateButton(Close, true, u42)
        Close.MouseButton1Click:Connect(hidePrompt)
    end
end

function u0.Start() -- Line: 131
    -- upvalues: DataController (val), LocalPlayer (val), tryShowPrompt (val), u42 (ref), u41 (ref), MenuState (val)
    DataController.CreateListener(LocalPlayer, "TutorialPrompted", tryShowPrompt)
    DataController.CreateListener(LocalPlayer, "TutorialCompleted", tryShowPrompt)
    ;(u42.Menu:GetPropertyChangedSignal("Visible")):Connect(function() -- Line: 135 -- upvalues: u42 (upval), tryShowPrompt (upval), u41 (upval)
        if u42.Menu.Visible then
            tryShowPrompt()
            return
        end
        if u41 then
            u41.Visible = false
        end
    end)
    MenuState.OnScreenChanged:Connect(function(a1, a2) -- Line: 142 -- upvalues: tryShowPrompt (upval), u41 (upval)
        if a2 == "Dashboard" then
            tryShowPrompt()
            return
        end
        if u41 then
            u41.Visible = false
        end
    end)
    tryShowPrompt()
end

return u0