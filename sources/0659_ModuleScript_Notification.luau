-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local GamepadNavigation = require(ReplicatedStorage.Interface.GamepadNavigation);
local CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = nil;
local u3 = nil;

local function BlockClickThrough(p4: userdata) -- Line: 35
    p4.Active = true;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "ClickBlocker";
    TextButton.Size = UDim2.fromScale(1, 1);
    TextButton.BackgroundTransparency = 1;
    TextButton.Text = "";
    TextButton.AutoButtonColor = false;
    TextButton.Selectable = false;
    TextButton.ZIndex = 0;
    TextButton.Parent = p4;
end;

local function IsUsableSelection(p5: userdata?) -- Line: 51
    if not (p5 and (p5.Parent and (p5.Selectable and p5.Interactable))) then
        return false;
    end;

    while p5 and p5:IsA("GuiObject") do
        if not p5.Visible then
            return false;
        end;

        p5 = p5.Parent;
    end;

    return true;
end;

local function SelectCloseButton() -- Line: 67
    -- upvalues: u2 (ref), GamepadNavigation (copy), IsUsableSelection (copy), GuiService (copy)
    local Close = u2.Footer.Close;

    if GamepadNavigation.IsGamepadActive() and IsUsableSelection(Close) then
        GuiService.SelectedObject = Close;
    end;
end;

function u1.CreateNotification(p6: string, p7: string) -- Line: 79
    -- upvalues: Router (copy), u2 (ref), GuiService (copy), u3 (ref), CloseButtonRegistry (copy), GamepadNavigation (copy), IsUsableSelection (copy)
    Router.broadcastRouter("RunInterfaceSound", "Notification " .. p6);
    u2.TextLabel.Text = p7;

    if not u2.Visible then
        local SelectedObject = GuiService.SelectedObject;

        if not SelectedObject or SelectedObject:IsDescendantOf(u2) then
            SelectedObject = nil;
        end;

        u3 = SelectedObject;
    end;

    u2.Visible = true;
    CloseButtonRegistry.BringToFront(u2);
    local Close = u2.Footer.Close;

    if GamepadNavigation.IsGamepadActive() and IsUsableSelection(Close) then
        GuiService.SelectedObject = Close;
    end;
end;

function u1.CloseNotification() -- Line: 95
    -- upvalues: u2 (ref), u3 (ref), GuiService (copy), GamepadNavigation (copy), IsUsableSelection (copy)
    u2.Visible = false;
    local u8 = u3;
    u3 = nil;
    task.defer(function() -- Line: 101
        -- upvalues: u2 (ref), u3 (ref), u8 (copy), GuiService (ref), GamepadNavigation (ref), IsUsableSelection (ref)
        if u2.Visible then
            u3 = u3 or u8;

            return;
        end;

        local SelectedObject = GuiService.SelectedObject;

        if SelectedObject == nil or SelectedObject:IsDescendantOf(u2) then
            local v9;

            if GamepadNavigation.IsGamepadActive() and IsUsableSelection(u8) then
                v9 = u8;
            else
                v9 = nil;
            end;

            GuiService.SelectedObject = v9;
        end;
    end);
end;

function u1.IsMenuOpen() -- Line: 118
    -- upvalues: MenuState (copy)
    local MenuFrame = MenuState.GetMenuFrame();
    local v10;

    if MenuFrame == nil then
        v10 = false;
    else
        v10 = MenuFrame.Visible;
    end;

    return v10;
end;

function u1.Initialize(p11, p12) -- Line: 126
    -- upvalues: u2 (ref), CloseButtonRegistry (copy), u1 (copy), GuiService (copy), SelectCloseButton (copy), Router (copy), Remotes (copy)
    u2 = p12;
    p12.Active = true;
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "ClickBlocker";
    TextButton.Size = UDim2.fromScale(1, 1);
    TextButton.BackgroundTransparency = 1;
    TextButton.Text = "";
    TextButton.AutoButtonColor = false;
    TextButton.Selectable = false;
    TextButton.ZIndex = 0;
    TextButton.Parent = p12;
    CloseButtonRegistry.Add(u2, u2.Footer.Close, function() -- Line: 131
        -- upvalues: u1 (ref)
        u1.CloseNotification();
    end);
    GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 135
        -- upvalues: GuiService (ref), u2 (ref), SelectCloseButton (ref)
        local SelectedObject = GuiService.SelectedObject;

        if not u2.Visible or SelectedObject and SelectedObject:IsDescendantOf(u2) then
            return;
        end;

        task.defer(SelectCloseButton);
    end);
    Router.observerRouter("CreateMenuNotification", function(p13: string, p14: string) -- Line: 143
        -- upvalues: u1 (ref)
        u1.CreateNotification(p13, p14);
    end);
    Remotes.UI.CreateMenuNotification.Listen(function(p15) -- Line: 147
        -- upvalues: u1 (ref)
        if p15.skipWhenMenuClosed and not u1.IsMenuOpen() then
            return;
        end;

        u1.CreateNotification(p15.notificationType, p15.text);
    end);
end;

return u1;