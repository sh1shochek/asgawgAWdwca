-- ReplicatedStorage.Interface.Screens.Menu.Notification
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Notification
-- Decompile time: 1.91 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation)
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local u33 = nil
local u34 = nil

local function BlockClickThrough(a1) -- Line: 35 -- types: a1: userdata
    a1.Active = true
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "ClickBlocker"
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.ZIndex = 0
    TextButton.Parent = a1
end

local function IsUsableSelection(a1) -- Line: 51 -- types: a1: userdata?
    if a1 and a1.Parent and a1.Selectable and a1.Interactable then
        local Parent = a1
        while Parent do
            if not Parent:IsA("GuiObject") then
                break
            end
            if not Parent.Visible then
                return false
            end
            Parent = Parent.Parent
        end
        return true
    end
    return false
end

local function SelectCloseButton() -- Line: 67
    -- upvalues: u33 (ref), GamepadNavigation (val), IsUsableSelection (val), GuiService (val)
    local Close = u33.Footer.Close
    if GamepadNavigation.IsGamepadActive() and IsUsableSelection(Close) then
        GuiService.SelectedObject = Close
    end
end

function u0.CreateNotification(a1, a2) -- Line: 79
    -- upvalues: Router (val), u33 (ref), GuiService (val), u34 (ref), CloseButtonRegistry (val)
    -- upvalues: GamepadNavigation (val), IsUsableSelection (val)
    Router.broadcastRouter("RunInterfaceSound", "Notification " .. a1)
    u33.TextLabel.Text = a2
    if not u33.Visible then
        local SelectedObject = GuiService.SelectedObject
        u34 = if not SelectedObject then nil else if SelectedObject:IsDescendantOf(u33) then nil else SelectedObject
    end
    u33.Visible = true
    CloseButtonRegistry.BringToFront(u33)
    local Close = u33.Footer.Close
    if GamepadNavigation.IsGamepadActive() and IsUsableSelection(Close) then
        GuiService.SelectedObject = Close
    end
end

function u0.CloseNotification() -- Line: 95
    -- upvalues: u33 (ref), u34 (ref), GuiService (val), GamepadNavigation (val), IsUsableSelection (val)
    u33.Visible = false
    local u2 = u34
    u34 = nil
    task.defer(function() -- Line: 101
        -- upvalues: u33 (upval), u34 (upval), u2 (val), GuiService (upval), GamepadNavigation (upval)
        -- upvalues: IsUsableSelection (upval)
        if u33.Visible then
            u34 = u34 or u2
            return
        end
        local SelectedObject = GuiService.SelectedObject
        if SelectedObject == nil or SelectedObject:IsDescendantOf(u33) then
            GuiService.SelectedObject = if not GamepadNavigation.IsGamepadActive() then nil else if not IsUsableSelection(u2) then nil else u2
        end
    end)
end

function u0.IsMenuOpen() -- Line: 118 -- upvalues: MenuState (val)
    local v1 = MenuState.GetMenuFrame()
    local Visible = false
    if v1 ~= nil then
        Visible = v1.Visible
    end
    return Visible
end

function u0.Initialize(a1, a2) -- Line: 126
    -- upvalues: u33 (ref), CloseButtonRegistry (val), u0 (val), GuiService (val), SelectCloseButton (val), Router (val)
    -- upvalues: Remotes (val)
    u33 = a2
    a2.Active = true
    local TextButton = Instance.new("TextButton")
    TextButton.Name = "ClickBlocker"
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.ZIndex = 0
    TextButton.Parent = a2
    CloseButtonRegistry.Add(u33, u33.Footer.Close, function() -- Line: 131 -- upvalues: u0 (upval)
        u0.CloseNotification()
    end)
    ;(GuiService:GetPropertyChangedSignal("SelectedObject")):Connect(function() -- Line: 135 -- upvalues: GuiService (upval), u33 (upval), SelectCloseButton (upval)
        local SelectedObject = GuiService.SelectedObject
        if not u33.Visible then
            return
        end
        if SelectedObject and SelectedObject:IsDescendantOf(u33) then
            return
        end
        task.defer(SelectCloseButton)
    end)
    Router.observerRouter("CreateMenuNotification", function(a1, a2) -- Line: 143 -- upvalues: u0 (upval) -- types: a1: string, a2: string
        u0.CreateNotification(a1, a2)
    end)
    Remotes.UI.CreateMenuNotification.Listen(function(a1) -- Line: 147 -- upvalues: u0 (upval)
        if a1.skipWhenMenuClosed and not u0.IsMenuOpen() then
            return
        end
        u0.CreateNotification(a1.notificationType, a1.text)
    end)
end

return u0