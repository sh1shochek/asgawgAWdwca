-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {
    private = {
        ProcessedInstance = nil,
        WidgetDefinitions = {},
        Instances = {},
        CurrentConfig = table.freeze({
            Font = Font.new("rbxasset://fonts/families/Inconsolata.json"),
            Transparency = {
                Window = 0.15
            },
            Sizes = {
                TextSize = 12,
                FrameCornerRadius = 4,
                ItemPadding = Vector2.new(4, 4),
                FramePadding = Vector2.new(5, 3)
            },
            Colors = {
                WindowBackground = Color3.fromRGB(26, 26, 33),
                Text = Color3.new(1, 1, 1),
                TextDisabled = Color3.new(0.5, 0.5, 0.5),
                Button = Color3.fromRGB(98, 114, 164),
                ButtonHovered = Color3.new(0.19, 0.2, 0.25),
                ButtonActive = Color3.new(0.16, 0.16, 0.21),
                Checkbox = Color3.fromRGB(255, 184, 108)
            }
        })
    },
    public = {}
};

function u1.private.GetLineUniqueID() -- Line: 94
    -- upvalues: u1 (copy)
    local ProcessedInstance = u1.private.ProcessedInstance;

    if not ProcessedInstance then
        error("Tried to get line unique id but instance is not running!");
    end;

    local v2 = 4;
    local debug_info_ret = debug.info(v2, "l");
    local v3 = {};

    while debug_info_ret ~= -1 and debug_info_ret ~= nil do
        table.insert(v3, debug_info_ret);
        v2 = v2 + 1;
        debug_info_ret = debug.info(v2, "l");
    end;

    local table_concat_ret = table.concat(v3);

    if ProcessedInstance.FrameData.WidgetIDs[table_concat_ret] then
        local WidgetIDs = ProcessedInstance.FrameData.WidgetIDs;
        WidgetIDs[table_concat_ret] = WidgetIDs[table_concat_ret] + 1;
    else
        ProcessedInstance.FrameData.WidgetIDs[table_concat_ret] = 1;
    end;

    return table_concat_ret .. "/" .. ProcessedInstance.FrameData.WidgetIDs[table_concat_ret];
end;

function u1.private.GetStackParent() -- Line: 121
    -- upvalues: u1 (copy)
    if not u1.private.ProcessedInstance then
        error("Tried to get stack parent but no instance is active");
    end;

    local v4 = #u1.private.ProcessedInstance.FrameData.Stack;

    if v4 == 0 then
        return u1.private.ProcessedInstance.Parent;
    end;

    return u1.private.ProcessedInstance.FrameData.Stack[v4].TopInstance;
end;

function u1.private.ProcessFrame() -- Line: 135
    -- upvalues: u1 (copy)
    for _, v in u1.private.Instances do
        u1.private.ProcessedInstance = v;
        v.Tick = v.Tick + 1;
        v.FrameData.CurrentWidget = nil;
        v.FrameData.PreviousWidget = nil;
        v.FrameData.WidgetIndex = 0;
        v.FrameData.Stack = {};
        v.FrameData.WidgetIDs = {};
        u1.public:BeginVertical();
        v.TickLoop();
        u1.public:End();
        local v5 = v;

        for _, v2 in v.Widgets do
            if v2.LastUpdateTick < v5.Tick then
                u1.private.DestroyWidget(v2);
                v5.Widgets[v2.ID] = nil;
            end;
        end;
    end;

    u1.private.ProcessedInstance = nil;
end;

function u1.private.DestroyImguiInstance(p6: table) -- Line: 162
    -- upvalues: u1 (copy)
    table.remove(u1.private.Instances, table.find(u1.private.Instances, p6));

    for _, v in p6.Widgets do
        u1.private.DestroyWidget(v);
    end;

    p6.Widgets = nil;
end;

function u1.private.DestroyWidget(p7: table) -- Line: 172
    -- upvalues: u1 (copy)
    local v8 = u1.private.WidgetDefinitions[p7.Definition];

    if v8.Deconstruct then
        v8.Deconstruct(p7);
    end;

    p7.TopInstance:Destroy();

    if p7.ChildrenInstance then
        p7.ChildrenInstance:Destroy();
    end;
end;

function u1.private.CreateWidgetFromDefinition(p9: string, ...) -- Line: 186
    -- upvalues: u1 (copy)
    local ProcessedInstance = u1.private.ProcessedInstance;

    if not ProcessedInstance then
        error("Tried to create widget but no instance is active");
    end;

    local FrameData = ProcessedInstance.FrameData;
    FrameData.WidgetIndex = FrameData.WidgetIndex + 1;
    local v10 = u1.private.WidgetDefinitions[p9];
    local LineUniqueID = u1.private.GetLineUniqueID();
    local u11 = ProcessedInstance.Widgets[LineUniqueID];

    if u11 then
        local v12 = { ... };

        for i, v in u11.Args do
            if v12[i] ~= v then
                u11.Args = v12;
                v10.Update(u11, ...);
                break;
            end;
        end;
    else
        local StackParent = u1.private.GetStackParent();

        if not StackParent then
            error("No stack parent");
        end;

        u11 = {
            ID = LineUniqueID,
            Definition = p9,
            LastUpdateTick = ProcessedInstance.Tick,
            Args = { ... }
        };
        local v13, v14 = v10.Construct(u11, StackParent, ...);
        u11.TopInstance = v13;

        if v14 then
            u11.ChildrenInstance = v14;
        end;

        if v10.Events then
            for i, v in v10.Events do
                if v.Setup then
                    v.Setup(u11);
                end;

                u11[i] = function() -- Line: 228
                    -- upvalues: v (copy), u11 (copy)
                    return v.Evaluate(u11);
                end;
            end;
        end;

        ProcessedInstance.Widgets[LineUniqueID] = u11;
    end;

    if u11 and u11.ChildrenInstance then
        table.insert(ProcessedInstance.FrameData.Stack, u11);
    end;

    if u1.private.ProcessedInstance then
        u11.LastUpdateTick = u1.private.ProcessedInstance.Tick;
        u11.TopInstance.LayoutOrder = ProcessedInstance.FrameData.WidgetIndex;
    end;

    return u11;
end;

function u1.public.End(p15) -- Line: 261
    -- upvalues: u1 (copy)
    local ProcessedInstance = u1.private.ProcessedInstance;

    if not ProcessedInstance then
        error("No active instance");
    end;

    local v16 = #ProcessedInstance.FrameData.Stack;

    if v16 <= 1 then
        return;
    end;

    table.remove(ProcessedInstance.FrameData.Stack, v16);
end;

function u1.public.Connect(p17: any, p18: userdata, p19: function) -- Line: 275
    -- upvalues: u1 (copy)
    local u20 = {
        Tick = 0,
        Parent = p18,
        FrameData = {
            WidgetIndex = 0,
            Stack = {},
            WidgetIDs = {}
        },
        Widgets = {},
        TickLoop = p19
    };
    table.insert(u1.private.Instances, u20);

    return function() -- Line: 294
        -- upvalues: u1 (ref), u20 (copy)
        u1.private.DestroyImguiInstance(u20);
    end;
end;

function u1.public.NewWidgetDefinition(p21: any, u22: string, p23: table) -- Line: 299
    -- upvalues: u1 (copy)
    if u1.public[u22] then
        error("Couldn\'t use identifier as already something else is using it");
    end;

    u1.private.WidgetDefinitions[u22] = p23;

    u1.public[u22] = function(p24, ...) -- Line: 306
        -- upvalues: u1 (ref), u22 (copy)
        return u1.private.CreateWidgetFromDefinition(u22, ...);
    end;
end;

function u1.public.GetTick() -- Line: 311
    -- upvalues: u1 (copy)
    return u1.private.ProcessedInstance and u1.private.ProcessedInstance.Tick or 0;
end;

function u1.public.applyFrameStyle(p25: userdata) -- Line: 315
    -- upvalues: u1 (copy)
    local CurrentConfig = u1.private.CurrentConfig;

    if CurrentConfig.Sizes.FramePadding.X > 0 or CurrentConfig.Sizes.FramePadding.Y > 0 then
        local UIPadding = Instance.new("UIPadding");
        UIPadding.PaddingLeft = UDim.new(0, CurrentConfig.Sizes.FramePadding.X);
        UIPadding.PaddingRight = UDim.new(0, CurrentConfig.Sizes.FramePadding.X);
        UIPadding.PaddingTop = UDim.new(0, CurrentConfig.Sizes.FramePadding.Y);
        UIPadding.PaddingBottom = UDim.new(0, CurrentConfig.Sizes.FramePadding.Y);
        UIPadding.Parent = p25;
    end;

    if CurrentConfig.Sizes.FrameCornerRadius > 0 then
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, CurrentConfig.Sizes.FrameCornerRadius);
        UICorner.Parent = p25;
    end;
end;

function u1.public.GetConfig(p26) -- Line: 334
    -- upvalues: u1 (copy)
    return u1.private.CurrentConfig;
end;

function u1.public.applyTextStyle(p27: userdata) -- Line: 338
    -- upvalues: u1 (copy)
    p27.FontFace = u1.private.CurrentConfig.Font;
    p27.TextSize = u1.private.CurrentConfig.Sizes.TextSize;
    p27.TextColor3 = u1.private.CurrentConfig.Colors.Text;
    p27.AutoLocalize = false;
end;

function u1.public.applyMouseDownStyle(u28: userdata, u29: function) -- Line: 348
    -- upvalues: u1 (copy)
    return u28.MouseButton1Down:Connect(function() -- Line: 349
        -- upvalues: u28 (copy), u1 (ref), u29 (copy)
        u28.BackgroundColor3 = u1.private.CurrentConfig.Colors.ButtonActive;
        u29();
    end);
end;

function u1.public.applyMouseUpStyle(u30: userdata, u31: function) -- Line: 356
    -- upvalues: u1 (copy)
    return u30.MouseButton1Up:Connect(function() -- Line: 357
        -- upvalues: u30 (copy), u1 (ref), u31 (copy)
        u30.BackgroundColor3 = u1.private.CurrentConfig.Colors.ButtonHovered;
        u31();
    end);
end;

function u1.public.applyMouseHoverStyle(u32: userdata, u33: function) -- Line: 364
    -- upvalues: u1 (copy)
    return u32.MouseEnter:Connect(function() -- Line: 365
        -- upvalues: u32 (copy), u1 (ref), u33 (copy)
        u32.BackgroundColor3 = u1.private.CurrentConfig.Colors.ButtonHovered;
        u33();
    end);
end;

function u1.public.applyMouseHoverEndStyle(u34: userdata, u35: function) -- Line: 372
    -- upvalues: u1 (copy)
    return u34.MouseLeave:Connect(function() -- Line: 376
        -- upvalues: u34 (copy), u1 (ref), u35 (copy)
        u34.BackgroundColor3 = u1.private.CurrentConfig.Colors.Button;
        u35();
    end);
end;

RunService.Heartbeat:Connect(u1.private.ProcessFrame);

return u1.public;