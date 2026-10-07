-- ReplicatedStorage.Interface
-- Script path: ReplicatedStorage.Interface
-- Decompile time: 8.78 ms

local loadInterfaceTree
local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Sound = require(ReplicatedStorage.Classes.Sound)
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Profiler = require(ReplicatedStorage.Shared.Profiler)
local Promise = require(ReplicatedStorage.Shared.Promise)
local DataController = require(ReplicatedStorage.Controllers.DataController)
local MenuState = require(script.MenuState)
local GamepadNavigation = require(script.GamepadNavigation)
local Screens = script:WaitForChild("Screens")
local Mobile = require(ReplicatedStorage.Database.Custom.GameStats.UI.Mobile)
local MainGui_2 = StarterGui:FindFirstChild("MainGui") or ReplicatedStorage.Assets.UI:FindFirstChild("MainGui")
if MainGui_2 then
    Mobile.CaptureDefaults(MainGui_2)
end
local MainGui = PlayerGui:WaitForChild("MainGui", (1 / 0))
if not MainGui_2 then
    Mobile.CaptureDefaults(MainGui)
end
local u99 = 1
local u100 = nil
local u101 = nil
local u102 = nil
local u103 = {"Ammo", "Armor", "Health", "Inventory", "Money"}
local u109 = {
    ["Screens.Gameplay.Middle.RoundWon"] = true,
    ["Screens.Gameplay.Top.PlayerInfo"] = true,
    ["Screens.Gameplay.Middle.TutorialDiaklogue"] = true,
}
local u113 = 0
local u114 = 0

local function resetInterfaceLoadBudget() -- Line: 90 -- upvalues: u113 (ref), u114 (ref)
    u113 = os.clock()
    u114 = 0
end

local function maybeYieldInterfaceLoad() -- Line: 95 -- upvalues: u114 (ref), u113 (ref), RunService (val)
    u114 = u114 + 1
    if u114 < 4 and os.clock() - u113 < 0.00125 then
        return
    end
    RunService.Heartbeat:Wait()
    u113 = os.clock()
    u114 = 0
end

local function runInterfacePhase(a1, a2, a3, ...) -- Line: 108
    -- upvalues: Profiler (val)
    debug.setmemorycategory((("Interface.%*"):format(a1)))
    Profiler.mark((("Interface.Module.%*"):format(a1)))
    Profiler.mark((("Interface.Phase.%*"):format(a2)))
    return Profiler.scope(("Interface.Callback.%*"):format(a2), a3, ...)
end

local function promiseRequire(a1, a2) -- Line: 116
    -- upvalues: Promise (val), runInterfacePhase (val)
    return (Promise.try(runInterfacePhase, a2, "Require", require, a1)):catch(warn)
end

local function loadInterfaceModule(a1, a2, a3) -- Line: 120
    -- upvalues: Promise (val), runInterfacePhase (val), MainGui (val)
    ((Promise.try(runInterfacePhase, a2, "Require", require, a1)):catch(warn)):andThen(function(a1) -- Line: 121 -- upvalues: Promise (upval), runInterfacePhase (upval), a2 (val), MainGui (upval), a3 (val)
        if typeof(a1) ~= "table" then
            return
        end
        ;((if not a1.Initialize then Promise.resolve() else Promise.try(runInterfacePhase, a2, "Initialize", a1.Initialize, MainGui, a3)):andThen(function() -- Line: 135 -- upvalues: a1 (val), Promise (upval), runInterfacePhase (upval), a2 (upval)
            if not a1.Start then
                return
            end
            return Promise.try(runInterfacePhase, a2, "Start", a1.Start)
        end)):catch(warn)
    end)
end

function loadInterfaceTree(a1, a2) -- Line: 147
    -- upvalues: loadInterfaceTree (val), Profiler (val), u109 (val), RunService (val), Promise (val)
    -- upvalues: runInterfacePhase (val), MainGui (val), u114 (ref), u113 (ref)
    if not a2 then
        warn((("Pointer: \"%*\" is not apart of interface."):format(a1.Name)))
        return
    end
    for i, v in ipairs(a1:GetChildren()) do
        local u27 = a2:FindFirstChild(v.Name)
        if not v:IsA("Folder") then
            if v:IsA("ModuleScript") then
                local u55 = Profiler.getInstancePath(v, script)
                if not u109[u55] then
                    if u27 then
                        ((Promise.try(runInterfacePhase, u55, "Require", require, v)):catch(warn)):andThen(function(a1) -- Line: 121 -- upvalues: Promise (upval), runInterfacePhase (upval), u55 (val), MainGui (upval), u27 (val)
                            if typeof(a1) ~= "table" then
                                return
                            end
                            ;((if not a1.Initialize then Promise.resolve() else Promise.try(runInterfacePhase, u55, "Initialize", a1.Initialize, MainGui, u27)):andThen(function() -- Line: 135 -- upvalues: a1 (val), Promise (upval), runInterfacePhase (upval), u55 (upval)
                                if not a1.Start then
                                    return
                                end
                                return Promise.try(runInterfacePhase, u55, "Start", a1.Start)
                            end)):catch(warn)
                        end)
                        u114 = u114 + 1
                        if not (u114 < 4) or not (os.clock() - u113 < 0.00125) then
                            RunService.Heartbeat:Wait()
                            u113 = os.clock()
                            u114 = 0
                        end
                    elseif RunService:IsStudio() then
                        warn((("Missing corresponding interface module for : \"%*\""):format((string.lower((v:GetFullName()))))))
                    end
                end
            end
        elseif not u27 then
            warn((("Missing corresponding interface folder : \"%*\""):format((string.lower((v:GetFullName()))))))
        else
            loadInterfaceTree(v, u27)
        end
    end
end

local function getInterfaceSoundGroup(a1) -- Line: 180
    -- upvalues: u100 (ref), Sound (val), u102 (ref), u101 (ref)
    if a1 == "Interface" then
        if not u100 or not u100.Sounds then
            u100 = Sound.new("Interface")
        end
        return u100
    end
    if a1 == "ArmsDealer" then
        if not u102 or not u102.Sounds then
            u102 = Sound.new("ArmsDealer")
        end
        return u102
    end
    if not u101 or not u101.Sounds then
        u101 = Sound.new("Store")
    end
    return u101
end

local function playInterfaceSound(a1, a2) -- Line: 204
    -- upvalues: getInterfaceSoundGroup (val), PlayerGui (val), u99 (ref)
    local v1 = getInterfaceSoundGroup(a1)
    if not v1 then
        return
    end
    return v1:playOneTime({Parent = PlayerGui, Name = a2}, u99)
end

function u0.guarantee(a1) -- Line: 219 -- types: a1: function
    local result, success
    local v1 = nil
    for i = 1, 15 do
        success, result = pcall(a1)
        if success then
            return true
        end
        v1 = result
        if i < 15 then
            task.wait(0.1)
        end
    end
    warn((("[Interface] Core GUI initialization failed after 15 attempts: %*"):format((tostring(v1)))))
    return false, v1
end

function u0.Initialize() -- Line: 236
    -- upvalues: MenuState (val), MainGui (val), GamepadNavigation (val), u0 (val), StarterGui (val)
    -- upvalues: GetUserPlatform (val), Profiler (val), u103 (val), DataController (val), LocalPlayer (val), u99 (ref)
    -- upvalues: Router (val), u100 (ref), Sound (val), PlayerGui (val), playInterfaceSound (val)
    MenuState.Initialize(MainGui)
    GamepadNavigation.Initialize()
    u0.guarantee(function() -- Line: 240 -- upvalues: StarterGui (upval)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        StarterGui:SetCore("ResetButtonCallback", false)
    end)
    local Bottom = MainGui:WaitForChild("Gameplay"):WaitForChild("Bottom")
    local u20 = {}
    local u27 = table.find(GetUserPlatform(), "Mobile") ~= nil

    local function getOrCreateHUDScale(a1) -- Line: 252 -- types: a1: userdata
        local HUDScale = a1:FindFirstChild("HUDScale")
        if HUDScale and HUDScale:IsA("UIScale") then
            return HUDScale
        end
        local UIScale = a1:FindFirstChildOfClass("UIScale")
        if UIScale then
            UIScale.Name = "HUDScale"
            return UIScale
        end
        local UIScale_2 = Instance.new("UIScale")
        UIScale_2.Name = "HUDScale"
        UIScale_2.Parent = a1
        return UIScale_2
    end

    local function applyHUDScale(a1) -- Line: 271 -- upvalues: u27 (val), u20 (val) -- types: a1: number
        if u27 then
            a1 = 1
        end
        for i, v in ipairs(u20) do
            v.Scale = a1
        end
    end

    Profiler.spawn("Interface.Initialize.HUDScale", function() -- Line: 281
        -- upvalues: Profiler (upval), u103 (upval), Bottom (val), u20 (val), DataController (upval)
        -- upvalues: LocalPlayer (upval), u27 (val)
        local HUDScale, UIScale, UIScale_2, v1, v2
        task.wait(0.1)
        Profiler.mark("Interface.HUDScale.Setup")
        for i, v in ipairs(u103) do
            v1 = Bottom:FindFirstChild(v)
            if v1 and v1:IsA("Frame") then
                HUDScale = v1:FindFirstChild("HUDScale")
                if not HUDScale or not HUDScale:IsA("UIScale") then
                    UIScale = v1:FindFirstChildOfClass("UIScale")
                    if not UIScale then
                        UIScale_2 = Instance.new("UIScale")
                        UIScale_2.Name = "HUDScale"
                        UIScale_2.Parent = v1
                        v2 = UIScale_2
                    else
                        UIScale.Name = "HUDScale"
                        v2 = UIScale
                    end
                else
                    v2 = HUDScale
                end
                table.insert(u20, v2)
            end
        end
        local v3 = DataController.Get(LocalPlayer, "Settings.Game.HUD.Scale") or 1
        if u27 then
            v3 = 1
        end
        for i2, i3 in ipairs(u20) do
            i3.Scale = v3
        end
    end)
    local v1 = LocalPlayer
    DataController.CreateListener(v1, "Settings.Game.HUD.Scale", function(a1) -- Line: 296 -- upvalues: u27 (val), u20 (val) -- types: a1: number
        local v1 = a1 or 1
        if u27 then
            v1 = 1
        end
        for i, v in ipairs(u20) do
            v.Scale = v1
        end
    end)
    v1 = LocalPlayer
    DataController.CreateListener(v1, "Settings.Audio.Music.Main Menu Volume", function(a1) -- Line: 300 -- upvalues: u99 (upval) -- types: a1: number?
        u99 = (tonumber(a1) or 100) / 100
    end)
    Router.observerRouter("RunInterfaceSound", function(a1) -- Line: 304 -- upvalues: u100 (upval), Sound (upval), PlayerGui (upval), u99 (upval) -- types: a1: string
        if not u100 or not u100.Sounds then
            u100 = Sound.new("Interface")
        end
        local v1 = u100
        if not v1 then
            return
        end
        v1:playOneTime({Parent = PlayerGui, Name = a1}, u99)
    end)
    Router.observerRouter("RunStoreSound", function(a1) -- Line: 307 -- upvalues: playInterfaceSound (upval) -- types: a1: string
        return playInterfaceSound("Store", a1)
    end)
    Router.observerRouter("RunArmsDealerSound", function(a1) -- Line: 311 -- upvalues: playInterfaceSound (upval) -- types: a1: string
        return playInterfaceSound("ArmsDealer", a1)
    end)
end

function u0.Start() -- Line: 316
    -- upvalues: u113 (ref), u114 (ref), loadInterfaceTree (val), Screens (val), MainGui (val)
    u113 = os.clock()
    u114 = 0
    loadInterfaceTree(Screens, MainGui)
end

return u0