-- ReplicatedStorage.Controllers.InputController
-- Script path: ReplicatedStorage.Controllers.InputController
-- Decompile time: 6.21 ms

local u0 = {}
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local DataController = require(ReplicatedStorage.Controllers.DataController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Router = require(ReplicatedStorage.Database.Security.Router)
local Pages = require(ReplicatedStorage.Database.Custom.GameStats.UI.Settings.Pages)
local KeybindParser = require(script:WaitForChild("KeybindParser"))
local Actions = script:WaitForChild("Actions")
local LocalPlayer = Players.LocalPlayer
local u67 = {}
local u68 = {}
local u69 = {}
local u70 = {}
local u71 = {"Computer", "Console"}

local function handleInput(a1, a2, a3) -- Line: 46
    -- upvalues: u69 (val), MenuState (val), u68 (val)
    local v1 = u69[a1]
    if not v1 then
        return
    end
    local v2 = MenuState.GetMenuFrame()
    local v3 = MenuState.GetCurrentScreen()
    local v4 = MenuState.GetMainGui()
    local Gameplay = v4 and v4:FindFirstChild("Gameplay")
    local Bottom = Gameplay and Gameplay:FindFirstChild("Bottom")
    local Middle = Gameplay and Gameplay:FindFirstChild("Middle")
    local TeamSelection = Middle and Middle:FindFirstChild("TeamSelection")
    local Visible = TeamSelection and TeamSelection:IsA("GuiObject") and TeamSelection.Visible and Bottom and Bottom:IsA("GuiObject") and not Bottom.Visible
    local v5 = true
    if v3 == nil then
        if not v2 then
            v5 = Visible == true
        else
            v5 = true
            if v2.Visible ~= true then
                v5 = Visible == true
            end
        end
    end
    local v6 = true
    if v1.Category ~= "UI Keys" then
        v6 = v1.Category == "Communication Options"
    end
    if v5 and not v6 and a2 == Enum.UserInputState.Begin then
        v1.IsActive = false
        return
    end
    if u68[v1.Group] == true then
        v1.IsActive = a2 == Enum.UserInputState.Begin
        task.spawn(v1.Callback, a2, a3)
        return
    end
    if a2 ~= Enum.UserInputState.Begin and v1.IsActive then
        v1.IsActive = false
        task.spawn(v1.Callback, a2, a3)
    end
end

local function newWheelInput(a1) -- Line: 89 -- types: a1: number
    return {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, a1, 0),
    }
end

local function handleScrollWheelInput(a1, a2) -- Line: 97
    -- upvalues: handleInput (val)
    if not a1 then
        return
    end
    handleInput(a1, Enum.UserInputState.Begin, {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, a2, 0),
    })
    task.defer(handleInput, a1, Enum.UserInputState.End, {
        UserInputType = Enum.UserInputType.MouseWheel,
        Delta = Vector3.new(0, a2, 0),
    })
end

local function unbindActionKeys(a1) -- Line: 105
    -- upvalues: u69 (val), ContextActionService (val), u70 (val), u67 (val)
    local v1 = u69[a1]
    if not v1 then
        return
    end
    ContextActionService:UnbindAction(a1)
    for i, v in ipairs(v1.Keybinds) do
        if typeof(v) ~= "string" then
            if u67[v] == a1 then
                u67[v] = nil
            end
        elseif u70[v] == a1 then
            u70[v] = nil
        end
    end
    v1.Keybinds = {}
end

function u0.registerAction(a1) -- Line: 130 -- upvalues: u69 (val)
    u69[a1.Name] = {
        IsActive = false,
        Category = a1.Category,
        Callback = a1.Callback,
        Group = a1.Group,
        BindPriority = a1.BindPriority,
        Name = a1.Name,
        Keybinds = {},
    }
end

function u0.bindKeybinds(a1, a2) -- Line: 144
    -- upvalues: u69 (val), unbindActionKeys (val), u70 (val), u67 (val), handleInput (val), ContextActionService (val)
    local v1
    local v2 = u69[a1]
    if not v2 then
        return
    end
    unbindActionKeys(a1)
    local v3 = {}
    local v4 = {}
    for i, v in ipairs(a2) do
        if typeof(v) ~= "string" then
            v1 = u67[v]
            if not v1 then
                table.insert(v3, v)
                table.insert(v4, v)
                u67[v] = a1
            else
                warn((("[InputController] %*: %* is already bound to %*, keybind dropped"):format(a1, tostring(v), v1)))
            end
        elseif v == "ScrollWheelUp" or v == "ScrollWheelDown" then
            v1 = u70[v]
            if not v1 then
                table.insert(v3, v)
                u70[v] = a1
            else
                warn((("[InputController] %*: %* is already bound to %*, keybind dropped"):format(a1, v, v1)))
            end
        end
    end
    v2.Keybinds = v3
    if #v4 > 0 then
        local function v5(a1_2, a2, a3) -- Line: 186 -- upvalues: handleInput (upval), a1 (val) -- types: a3: userdata
            handleInput(a1, a2, a3)
        end

        if v2.BindPriority ~= nil then
            ContextActionService:BindActionAtPriority(a1, v5, false, v2.BindPriority, (table.unpack(v4)))
            return
        end
        ContextActionService:BindAction(a1, v5, false, (table.unpack(v4)))
    end
end

function u0.loadActionsFromDatabase(a1) -- Line: 206
    -- upvalues: Pages (val), unbindActionKeys (val), u71 (val), KeybindParser (val), u0 (val), u67 (val)
    local v1, v2, v3, v4, v5
    local v6 = {}
    for k, v in pairs(a1) do
        for k2, i in pairs(v) do
            if typeof(i) == "table" then
                v1 = Pages.GetSetting("Keybinds", k2)
                if not v1 then
                    v2 = {}
                    for i2, j in ipairs(u71) do
                        v3 = i[j]
                        if v3 and v3 ~= "" then
                            v5 = KeybindParser.parse(v3)
                            if v5 then
                                table.insert(v2, v5)
                            end
                        end
                    end
                    v6[k2] = v2
                elseif v1.IsEnabled ~= false then
                    v2 = {}
                    for i3, k3 in ipairs(u71) do
                        v3 = i[k3]
                        if v3 and v3 ~= "" then
                            v5 = KeybindParser.parse(v3)
                            if v5 then
                                table.insert(v2, v5)
                            end
                        end
                    end
                    v6[k2] = v2
                else
                    unbindActionKeys(k2)
                end
            end
        end
    end
    if v6["Switch Viewmodel Left/Right Hand"] == nil then
        unbindActionKeys("Switch Viewmodel Left/Right Hand")
    end
    for k4 in pairs(v6) do
        unbindActionKeys(k4)
    end
    for k5, n in pairs(v6) do
        u0.bindKeybinds(k5, n)
    end
    if v4 then
        local v7 = Pages.GetSetting("Keybinds", "Switch Viewmodel Left/Right Hand")
        local v8 = v7 and KeybindParser.parse(v7.Default.Computer)
        if typeof(v8) == "EnumItem" and u67[v8] == nil then
            u0.bindKeybinds("Switch Viewmodel Left/Right Hand", {v8})
        end
    end
end

function u0.isActionActive(a1) -- Line: 265 -- upvalues: u69 (val) -- types: a1: string
    local v1 = u69[a1]
    return v1 and v1.IsActive or false
end

function u0.enableGroup(a1) -- Line: 272 -- upvalues: u68 (val) -- types: a1: string
    u68[a1] = true
end

function u0.disableGroup(a1) -- Line: 278 -- upvalues: u68 (val) -- types: a1: string
    u68[a1] = nil
end

function u0.GetActionKeybind(a1) -- Line: 284 -- upvalues: u69 (val) -- types: a1: string
    local v1 = u69[a1]
    if v1 and #v1.Keybinds ~= 0 then
        local v2 = v1.Keybinds[1]
        if typeof(v2) == "string" then
            return v2
        end
        return tostring(v2):match("%.(%w+)$") or tostring(v2)
    end
    return nil
end

function u0.Initialize() -- Line: 301
    -- upvalues: Actions (val), u0 (val), CharacterResolver (val), LocalPlayer (val), ContextActionService (val)
    -- upvalues: DataController (val), Router (val)
    for i, v in ipairs(Actions:GetChildren()) do
        if v:IsA("ModuleScript") then
            u0.registerAction((require(v)))
        end
    end
    u0.enableGroup("Default")
    CharacterResolver.observeCharacter(LocalPlayer, function(a1) -- Line: 311 -- upvalues: ContextActionService (upval)
        if a1 then
            ContextActionService:UnbindAction("jumpAction")
        end
        return function() end
    end)
    local v1 = LocalPlayer
    DataController.CreateListener(v1, "Settings.Keyboard/Mouse", function(a1) -- Line: 318 -- upvalues: u0 (upval)
        if a1 then
            u0.loadActionsFromDatabase(a1)
        end
    end)
    Router.observerRouter("RebindKeybinds", function() -- Line: 325 -- upvalues: DataController (upval), LocalPlayer (upval), u0 (upval)
        local v1 = DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse")
        if not v1 then
            return false
        end
        u0.loadActionsFromDatabase(v1)
        return true
    end)
end

function u0.getActionKeybinds(a1) -- Line: 337 -- upvalues: u69 (val) -- types: a1: string
    local v1 = {}
    local v2 = u69[a1]
    if v2 then
        for i, v in ipairs(v2.Keybinds) do
            if typeof(v) ~= "string" then
                table.insert(v1, v)
            end
        end
    end
    return v1
end

function u0.isBindingPressed(a1) -- Line: 352 -- upvalues: UserInputService (val)
    if typeof(a1) ~= "EnumItem" then
        return false
    end
    if a1.EnumType ~= Enum.KeyCode then
        if a1.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(a1)
        end
        return false
    end
    local v1 = true
    if a1 ~= Enum.KeyCode.ButtonR2 then
        v1 = a1 == Enum.KeyCode.ButtonL2
    end
    if v1 then
        for k, n in UserInputService:GetConnectedGamepads() do
            for m, i5 in UserInputService:GetGamepadState(n) do
                if i5.KeyCode == v2 and 0.3 < i5.Position.Z then
                    return true
                end
            end
        end
        return false
    end
    local Name = a1.Name
    if not string.match(Name, "^Button") and not string.match(Name, "^DPad") then
        return UserInputService:IsKeyDown(a1)
    end
    for i, j in UserInputService:GetConnectedGamepads() do
        if UserInputService:IsGamepadButtonDown(j, a1) then
            return true
        end
    end
    return false
end

function u0.isActionPressed(a1, a2) -- Line: 397 -- upvalues: u0 (val) -- types: a1: string, a2: table?
    local v1 = u0.getActionKeybinds(a1)
    if #v1 == 0 and a2 then
        v1 = a2
    end
    for i, v in ipairs(v1) do
        if u0.isBindingPressed(v) then
            return true
        end
    end
    return false
end

function u0.Start() -- Line: 417 -- upvalues: UserInputService (val), u70 (val), handleInput (val)
    UserInputService.InputChanged:Connect(function(a1) -- Line: 418 -- upvalues: u70 (upval), handleInput (upval) -- types: a1: userdata
        if a1.UserInputType ~= Enum.UserInputType.MouseWheel then
            return
        end
        local Z = a1.Position.Z
        if Z > 0 then
            local ScrollWheelUp = u70.ScrollWheelUp
            if not ScrollWheelUp then
                return
            end
            handleInput(ScrollWheelUp, Enum.UserInputState.Begin, {
                Delta = Vector3.new(0, 1, 0),
                UserInputType = Enum.UserInputType.MouseWheel,
            })
            task.defer(handleInput, ScrollWheelUp, Enum.UserInputState.End, {
                Delta = Vector3.new(0, 1, 0),
                UserInputType = Enum.UserInputType.MouseWheel,
            })
            return
        end
        if Z < 0 then
            local ScrollWheelDown = u70.ScrollWheelDown
            if not ScrollWheelDown then
                return
            end
            handleInput(ScrollWheelDown, Enum.UserInputState.Begin, {
                Delta = Vector3.new(0, -1, 0),
                UserInputType = Enum.UserInputType.MouseWheel,
            })
            task.defer(handleInput, ScrollWheelDown, Enum.UserInputState.End, {
                Delta = Vector3.new(0, -1, 0),
                UserInputType = Enum.UserInputType.MouseWheel,
            })
        end
    end)
end

return u0