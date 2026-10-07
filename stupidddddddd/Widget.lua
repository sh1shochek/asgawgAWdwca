-- ReplicatedStorage.Packages.DebugTools.Client.Widget
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Widget
-- Decompile time: 2.87 ms

local Players = game:GetService("Players")
local Shared = script.Parent.Parent.Shared
local Signal = require(Shared.Signal)
local Constants = require(Shared.Constants)
local u15 = {internal = {WidgetData = {}}}
u15.interface = {
    WidgetAdded = Signal.new(),
    WidgetMounted = Signal.new(),
    WidgetUnmounted = Signal.new(),
}

function u15.internal.createWidgetScreenGui(a1) -- Line: 37
    -- upvalues: u15 (val), Constants (val), Players (val)
    local v1 = u15.internal.WidgetData[a1.Name]
    if not v1 then
        return nil
    end
    if v1.ScreenGui then
        return v1.ScreenGui
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = ("[DEBUG] %*"):format(a1.Name)
    ScreenGui.DisplayOrder = Constants.WIDGET_DISPLAY_ORDER
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    v1.ScreenGui = ScreenGui
    return ScreenGui
end

function u15.internal.addWidget(a1) -- Line: 60 -- upvalues: u15 (val) -- types: a1: table
    local v1 = {Mounted = false, Widget = a1}
    u15.internal.WidgetData[a1.Name] = v1
    u15.interface.WidgetAdded:Fire(a1.Name)
    u15.internal.mountWidget(a1)
end

function u15.internal.removeWidget(a1) -- Line: 73 -- upvalues: u15 (val) -- types: a1: string
    local v1 = u15.internal.WidgetData[a1]
    if not v1 then
        return
    end
    if v1.ScreenGui then
        v1.ScreenGui:Destroy()
        v1.ScreenGui = nil
    end
    u15.internal.WidgetData[a1] = nil
end

function u15.internal.mountWidget(a1) -- Line: 88 -- upvalues: u15 (val) -- types: a1: table
    local v1 = u15.internal.createWidgetScreenGui(a1)
    assert(v1, (("Widget parent doesn't exist for '%*'"):format(a1.Name)))
    local v2 = u15.internal.WidgetData[a1.Name]
    v2.DestroyFunction = a1.CreateFunction(v1)
    if typeof(v2.DestroyFunction) ~= "function" then
        u15.internal.removeWidget(a1.Name)
        warn((("Widget '%*' needs to return a destructor of a type 'function' got '%*'"):format(a1.Name, (typeof(v2.DestroyFunction)))))
        return
    end
    if #v1:GetChildren() == 0 then
        u15.internal.removeWidget(a1.Name)
        warn((("Widget '%*' didn't create any interface elements."):format(a1.Name)))
        return
    end
    v2.Mounted = true
    u15.interface.WidgetMounted:Fire(a1.Name, v1)
end

function u15.internal.unmountWidget(a1) -- Line: 117 -- upvalues: u15 (val) -- types: a1: table
    local v1 = u15.internal.WidgetData[a1.Name]
    if v1 and v1.Mounted then
        if v1.DestroyFunction then
            v1.DestroyFunction()
        end
        if v1.ScreenGui then
            local Children = v1.ScreenGui:GetChildren()
            if #Children > 0 then
                warn((("Widget '%*' didn't cleanup unmounted interface properly, there are leftover elements:"):format(a1.Name)))
                for i, j in Children do
                    warn((("  ╠ %*(%*)"):format(j.Name, j.ClassName)))
                end
            end
            v1.ScreenGui:Destroy()
            v1.ScreenGui = nil
        end
        v1.Mounted = false
        u15.interface.WidgetUnmounted:Fire(a1.Name)
        return
    end
end

function u15.internal.getWidgetData(a1) -- Line: 147 -- upvalues: u15 (val) -- types: a1: string
    return u15.internal.WidgetData[a1]
end

function u15.interface.new(a1, a2) -- Line: 151 -- upvalues: u15 (val) -- types: a1: string, a2: function
    local v1 = ("Expected parameter #1 'widgetName' to be a string, got %*"):format((type(a1)))
    assert(type(a1) == "string", v1)
    v1 = ("Expected parameter #2 'widgetCreateFunction' to be a function, got %*"):format((type(a2)))
    assert(type(a2) == "function", v1)
    u15.internal.addWidget({Name = a1, CreateFunction = a2})
end

function u15.interface.GetAll(a1) -- Line: 167 -- upvalues: u15 (val)
    local v1
    local v2 = {}
    for i, j in u15.internal.WidgetData do
        v1 = {Mounted = j.Mounted, ScreenGui = j.ScreenGui}
        v2[i] = v1
    end
    return v2
end

function u15.interface.Hide(a1, a2) -- Line: 183 -- upvalues: u15 (val) -- types: a1: table, a2: string
    local v1 = u15.internal.getWidgetData(a2)
    if v1 and v1.Mounted then
        u15.internal.unmountWidget(v1.Widget)
        return
    end
end

function u15.interface.Show(a1, a2) -- Line: 192 -- upvalues: u15 (val) -- types: a1: table, a2: string
    local v1 = u15.internal.getWidgetData(a2)
    if v1 and not v1.Mounted then
        u15.internal.mountWidget(v1.Widget)
        return
    end
end

function u15.interface.IsVisible(a1, a2) -- Line: 201 -- upvalues: u15 (val) -- types: a1: table, a2: string
    local v1 = u15.internal.getWidgetData(a2)
    return v1 and v1.Mounted or false
end

function u15.interface.SwitchVisibility(a1, a2) -- Line: 207 -- upvalues: u15 (val) -- types: a1: table, a2: string
    if u15.interface:IsVisible(a2) then
        u15.interface:Hide(a2)
        return
    end
    u15.interface:Show(a2)
end

return u15.interface