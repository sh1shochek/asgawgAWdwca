-- ReplicatedStorage.Packages.DebugTools.Client
-- Script path: ReplicatedStorage.Packages.DebugTools.Client
-- Decompile time: 1.30 ms

local UserInputService = game:GetService("UserInputService")
local Authorization = require(script.Authorization)
local Interface = require(script.Interface)
if not Authorization:isLocalPlayerAuthorized() then
    return {Authorized = false}
end
local u17 = {}
u17.internal = {SwitchKey = Enum.KeyCode.F6}
u17.interface = {
    Authorized = true,
    Accessible = true,
    Tab = require(script.Tab),
    Widget = require(script.Widget),
    Action = require(script.Parent.Shared.Action),
    Networking = require(script.Networking),
    Imgui = require(script.Imgui),
    BuiltinTabs = {
        Console = require(script.Builtin.Tabs.Console),
        Widgets = require(script.Builtin.Tabs.Widgets),
        Actions = require(script.Builtin.Tabs.Actions),
        Explorer = require(script.Builtin.Tabs.Explorer),
        Properties = require(script.Builtin.Tabs.Properties),
        Performance = require(script.Builtin.Tabs.Performance),
    },
    BuiltinWidgets = {
        PlaceStats = require(script.Builtin.Widgets.PlaceStats),
        Coordinates = require(script.Builtin.Widgets.Coordinates),
        KeyboardInput = require(script.Builtin.Widgets.KeyboardInput),
        CodeWarnings = require(script.Builtin.Widgets.CodeWarnings),
    },
    Style = require(script.Style),
}

function u17.internal.observeKeyBinds() -- Line: 52 -- upvalues: UserInputService (val), u17 (val), Interface (val)
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 53 -- upvalues: u17 (upval), Interface (upval) -- types: a1: userdata, a2: boolean
        if a2 or a1.KeyCode ~= u17.internal.SwitchKey then
            return
        end
        Interface.switchVisibility()
    end)
end

function u17.internal.observeMobileGesture() -- Line: 66 -- upvalues: UserInputService (val), Interface (val)
    local u0 = {}

    local function removeTouchPoint(a1) -- Line: 69 -- upvalues: u0 (val) -- types: a1: userdata
        for i, j in u0 do
            if j == a1 then
                table.remove(u0, i)
                return
            end
        end
    end

    UserInputService.InputBegan:Connect(function(a1) -- Line: 78 -- upvalues: u0 (val), removeTouchPoint (val), Interface (upval) -- types: a1: userdata
        if a1.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v1 = math.abs((ViewportSize.X / 2 - a1.Position.X) / ViewportSize.X)
        if not (0 < a1.Position.Y / ViewportSize.Y) and not (v1 >= 0.1) then
            table.insert(u0, a1)
            if #u0 >= 3 then
                for i, j in u0 do
                    removeTouchPoint(j)
                end
                Interface.switchVisibility()
            end
            task.delay(0.75, function() -- Line: 102 -- upvalues: removeTouchPoint (upval), a1 (val)
                removeTouchPoint(a1)
            end)
            return
        end
    end)
end

function u17.internal.init() -- Line: 108 -- upvalues: Interface (val), u17 (val)
    Interface.init()
    u17.internal.observeKeyBinds()
    u17.internal.observeMobileGesture()
    for i, j in script.Builtin.ImguiWidgets:GetChildren() do
        if j:IsA("ModuleScript") then
            require(j)
        end
    end
end

u17.internal.init()
return u17.interface