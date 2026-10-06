-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local script_Authorization = require(script.Authorization);
local script_Interface = require(script.Interface);

if not script_Authorization:isLocalPlayerAuthorized() then
    return {
        Authorized = false
    };
end;

local u1 = {
    internal = {
        SwitchKey = Enum.KeyCode.F6
    },
    interface = {
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
            Performance = require(script.Builtin.Tabs.Performance)
        },
        BuiltinWidgets = {
            PlaceStats = require(script.Builtin.Widgets.PlaceStats),
            Coordinates = require(script.Builtin.Widgets.Coordinates),
            KeyboardInput = require(script.Builtin.Widgets.KeyboardInput),
            CodeWarnings = require(script.Builtin.Widgets.CodeWarnings)
        },
        Style = require(script.Style)
    }
};

function u1.internal.observeKeyBinds() -- Line: 52
    -- upvalues: UserInputService (copy), u1 (copy), script_Interface (copy)
    UserInputService.InputBegan:Connect(function(p2: userdata, p3: boolean) -- Line: 53
        -- upvalues: u1 (ref), script_Interface (ref)
        if p3 then
            return;
        end;

        if p2.KeyCode ~= u1.internal.SwitchKey then
            return;
        end;

        script_Interface.switchVisibility();
    end);
end;

function u1.internal.observeMobileGesture() -- Line: 66
    -- upvalues: UserInputService (copy), script_Interface (copy)
    local u4 = {};

    local function removeTouchPoint(p5: userdata) -- Line: 69
        -- upvalues: u4 (copy)
        for i, v in u4 do
            if v == p5 then
                table.remove(u4, i);

                return;
            end;
        end;
    end;

    UserInputService.InputBegan:Connect(function(u6: userdata) -- Line: 78
        -- upvalues: u4 (copy), removeTouchPoint (copy), script_Interface (ref)
        if u6.UserInputType ~= Enum.UserInputType.Touch then
            return;
        end;

        local ViewportSize = workspace.CurrentCamera.ViewportSize;
        local math_abs_ret = math.abs((ViewportSize.X / 2 - u6.Position.X) / ViewportSize.X);

        if u6.Position.Y / ViewportSize.Y > 0 or math_abs_ret >= 0.1 then
            return;
        end;

        table.insert(u4, u6);

        if #u4 >= 3 then
            for _, v in u4 do
                removeTouchPoint(v);
            end;

            script_Interface.switchVisibility();
        end;

        task.delay(0.75, function() -- Line: 102
            -- upvalues: removeTouchPoint (ref), u6 (copy)
            removeTouchPoint(u6);
        end);
    end);
end;

function u1.internal.init() -- Line: 108
    -- upvalues: script_Interface (copy), u1 (copy)
    script_Interface.init();
    u1.internal.observeKeyBinds();
    u1.internal.observeMobileGesture();

    for _, child in script.Builtin.ImguiWidgets:GetChildren() do
        if child:IsA("ModuleScript") then
            require(child);
        end;
    end;
end;

u1.internal.init();

return u1.interface;