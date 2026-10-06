-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Shared = script.Parent.Parent.Shared;
local Signal = require(Shared.Signal);
local Constants = require(Shared.Constants);
local u1 = {
    internal = {
        WidgetData = {}
    },
    interface = {
        WidgetAdded = Signal.new(),
        WidgetMounted = Signal.new(),
        WidgetUnmounted = Signal.new()
    }
};

function u1.internal.createWidgetScreenGui(p2: table) -- Line: 37
    -- upvalues: u1 (copy), Constants (copy), Players (copy)
    local v3 = u1.internal.WidgetData[p2.Name];

    if not v3 then
        return nil;
    end;

    if v3.ScreenGui then
        return v3.ScreenGui;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = `[DEBUG] {p2.Name}`;
    ScreenGui.DisplayOrder = Constants.WIDGET_DISPLAY_ORDER;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui;
    v3.ScreenGui = ScreenGui;

    return ScreenGui;
end;

function u1.internal.addWidget(p4: table) -- Line: 60
    -- upvalues: u1 (copy)
    u1.internal.WidgetData[p4.Name] = {
        Mounted = false,
        Widget = p4
    };
    u1.interface.WidgetAdded:Fire(p4.Name);
    u1.internal.mountWidget(p4);
end;

function u1.internal.removeWidget(p5: string) -- Line: 73
    -- upvalues: u1 (copy)
    local v6 = u1.internal.WidgetData[p5];

    if not v6 then
        return;
    end;

    if v6.ScreenGui then
        v6.ScreenGui:Destroy();
        v6.ScreenGui = nil;
    end;

    u1.internal.WidgetData[p5] = nil;
end;

function u1.internal.mountWidget(p7: table) -- Line: 88
    -- upvalues: u1 (copy)
    local v8 = u1.internal.createWidgetScreenGui(p7);
    local v9 = `Widget parent doesn't exist for '{p7.Name}'`;
    assert(v8, v9);
    local v10 = u1.internal.WidgetData[p7.Name];
    v10.DestroyFunction = p7.CreateFunction(v8);

    if typeof(v10.DestroyFunction) ~= "function" then
        u1.internal.removeWidget(p7.Name);
        warn((`Widget '{p7.Name}' needs to return a destructor of a type 'function' got '{typeof(v10.DestroyFunction)}'`));

        return;
    end;

    if #v8:GetChildren() == 0 then
        u1.internal.removeWidget(p7.Name);
        warn((`Widget '{p7.Name}' didn't create any interface elements.`));

        return;
    end;

    v10.Mounted = true;
    u1.interface.WidgetMounted:Fire(p7.Name, v8);
end;

function u1.internal.unmountWidget(p11: table) -- Line: 117
    -- upvalues: u1 (copy)
    local v12 = u1.internal.WidgetData[p11.Name];

    if not (v12 and v12.Mounted) then
        return;
    end;

    if v12.DestroyFunction then
        v12.DestroyFunction();
    end;

    if v12.ScreenGui then
        local Children = v12.ScreenGui:GetChildren();

        if #Children > 0 then
            warn((`Widget '{p11.Name}' didn't cleanup unmounted interface properly, there are leftover elements:`));

            for _, v in Children do
                warn((`  ╠ {v.Name}({v.ClassName})`));
            end;
        end;

        v12.ScreenGui:Destroy();
        v12.ScreenGui = nil;
    end;

    v12.Mounted = false;
    u1.interface.WidgetUnmounted:Fire(p11.Name);
end;

function u1.internal.getWidgetData(p13: string) -- Line: 147
    -- upvalues: u1 (copy)
    return u1.internal.WidgetData[p13];
end;

function u1.interface.new(p14: string, p15: function) -- Line: 151
    -- upvalues: u1 (copy)
    local v16 = type(p14) == "string";
    local v17 = `Expected parameter #1 'widgetName' to be a string, got {type(p14)}`;
    assert(v16, v17);
    local v18 = type(p15) == "function";
    local v19 = `Expected parameter #2 'widgetCreateFunction' to be a function, got {type(p15)}`;
    assert(v18, v19);
    u1.internal.addWidget({
        Name = p14,
        CreateFunction = p15
    });
end;

function u1.interface.GetAll(p20) -- Line: 167
    -- upvalues: u1 (copy)
    local v21 = {};

    for i, v in u1.internal.WidgetData do
        v21[i] = {
            Mounted = v.Mounted,
            ScreenGui = v.ScreenGui
        };
    end;

    return v21;
end;

function u1.interface.Hide(p22: table, p23: string) -- Line: 183
    -- upvalues: u1 (copy)
    local WidgetData = u1.internal.getWidgetData(p23);

    if not (WidgetData and WidgetData.Mounted) then
        return;
    end;

    u1.internal.unmountWidget(WidgetData.Widget);
end;

function u1.interface.Show(p24: table, p25: string) -- Line: 192
    -- upvalues: u1 (copy)
    local WidgetData = u1.internal.getWidgetData(p25);

    if not WidgetData or WidgetData.Mounted then
        return;
    end;

    u1.internal.mountWidget(WidgetData.Widget);
end;

function u1.interface.IsVisible(p26: table, p27: string) -- Line: 201
    -- upvalues: u1 (copy)
    local WidgetData = u1.internal.getWidgetData(p27);

    return WidgetData and WidgetData.Mounted or false;
end;

function u1.interface.SwitchVisibility(p28: table, p29: string) -- Line: 207
    -- upvalues: u1 (copy)
    if u1.interface:IsVisible(p29) then
        u1.interface:Hide(p29);

        return;
    end;

    u1.interface:Show(p29);
end;

return u1.interface;