-- ReplicatedStorage.Packages.DebugTools.Client.Imgui
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Imgui
-- Decompile time: 4.01 ms

local RunService = game:GetService("RunService")
local u5 = {}
u5.private = {
    WidgetDefinitions = {},
    Instances = {},
    CurrentConfig = table.freeze({
        Font = Font.new("rbxasset://fonts/families/Inconsolata.json"),
        Transparency = {Window = 0.15},
        Sizes = {
            TextSize = 12,
            FrameCornerRadius = 4,
            ItemPadding = Vector2.new(4, 4),
            FramePadding = Vector2.new(5, 3),
        },
        Colors = {
            WindowBackground = Color3.fromRGB(26, 26, 33),
            Text = Color3.new(1, 1, 1),
            TextDisabled = Color3.new(0.5, 0.5, 0.5),
            Button = Color3.fromRGB(98, 114, 164),
            ButtonHovered = Color3.new(0.19, 0.2, 0.25),
            ButtonActive = Color3.new(0.16, 0.16, 0.21),
            Checkbox = Color3.fromRGB(255, 184, 108),
        },
    }),
}
u5.public = {}

function u5.private.GetLineUniqueID() -- Line: 94 -- upvalues: u5 (val)
    local ProcessedInstance = u5.private.ProcessedInstance
    if not ProcessedInstance then
        error("Tried to get line unique id but instance is not running!")
    end
    local v1 = 4
    local v2 = {}
    local v3 = debug.info(v1, "l")
    while v3 ~= -1 do
        if v3 == nil then
            break
        end
        table.insert(v2, v3)
        v1 = v1 + 1
        v3 = debug.info(v1, "l")
    end
    local v4 = table.concat(v2)
    if ProcessedInstance.FrameData.WidgetIDs[v4] then
        local WidgetIDs = ProcessedInstance.FrameData.WidgetIDs
        WidgetIDs[v4] = WidgetIDs[v4] + 1
    else
        ProcessedInstance.FrameData.WidgetIDs[v4] = 1
    end
    return v4 .. "/" .. ProcessedInstance.FrameData.WidgetIDs[v4]
end

function u5.private.GetStackParent() -- Line: 121 -- upvalues: u5 (val)
    if not u5.private.ProcessedInstance then
        error("Tried to get stack parent but no instance is active")
    end
    local v1 = #u5.private.ProcessedInstance.FrameData.Stack
    if v1 == 0 then
        return u5.private.ProcessedInstance.Parent
    end
    return u5.private.ProcessedInstance.FrameData.Stack[v1].TopInstance
end

function u5.private.ProcessFrame() -- Line: 135 -- upvalues: u5 (val)
    local v1 = nil
    local v2 = nil
    for i, j in u5.private.Instances, v1, v2 do
        u5.private.ProcessedInstance = j
        j.Tick = j.Tick + 1
        j.FrameData.CurrentWidget = nil
        j.FrameData.PreviousWidget = nil
        j.FrameData.WidgetIndex = 0
        j.FrameData.Stack = {}
        j.FrameData.WidgetIDs = {}
        u5.public:BeginVertical()
        j.TickLoop()
        u5.public:End()
        for k, n in j.Widgets do
            if n.LastUpdateTick < j.Tick then
                u5.private.DestroyWidget(n)
                j.Widgets[n.ID] = nil
            end
        end
    end
    u5.private.ProcessedInstance = nil
end

function u5.private.DestroyImguiInstance(a1) -- Line: 162 -- upvalues: u5 (val) -- types: a1: table
    table.remove(u5.private.Instances, table.find(u5.private.Instances, a1))
    for i, j in a1.Widgets do
        u5.private.DestroyWidget(j)
    end
    a1.Widgets = nil
end

function u5.private.DestroyWidget(a1) -- Line: 172 -- upvalues: u5 (val) -- types: a1: table
    local v1 = u5.private.WidgetDefinitions[a1.Definition]
    if v1.Deconstruct then
        v1.Deconstruct(a1)
    end
    a1.TopInstance:Destroy()
    if a1.ChildrenInstance then
        a1.ChildrenInstance:Destroy()
    end
end

function u5.private.CreateWidgetFromDefinition(a1, ...) -- Line: 186 -- upvalues: u5 (val) -- types: a1: string
    local v1
    local ProcessedInstance = u5.private.ProcessedInstance
    if not ProcessedInstance then
        error("Tried to create widget but no instance is active")
    end
    local FrameData = ProcessedInstance.FrameData
    FrameData.WidgetIndex = FrameData.WidgetIndex + 1
    local v2 = u5.private.WidgetDefinitions[a1]
    local v3 = u5.private.GetLineUniqueID()
    local v4 = ProcessedInstance.Widgets[v3]
    if v4 then
        v1 = {...}
        for i, j in v4.Args do
            if v1[i] ~= j then
                v4.Args = v1
                v2.Update(v4, ...)
                break
            end
        end
    else
        v1 = u5.private.GetStackParent()
        if not v1 then
            error("No stack parent")
        end
        local u63 = {ID = v3, Definition = a1, LastUpdateTick = ProcessedInstance.Tick}
        u63.Args = {...}
        local v5, v6 = v2.Construct(u63, v1, ...)
        u63.TopInstance = v5
        if v6 then
            u63.ChildrenInstance = v6
        end
        if v2.Events then
            local v7 = nil
            local v8 = nil
            for k, n in v2.Events, v7, v8 do
                if n.Setup then
                    n.Setup(u63)
                end

                u63[k] = function() -- Line: 228 -- upvalues: n (val), u63 (val)
                    return n.Evaluate(u63)
                end
            end
        end
        ProcessedInstance.Widgets[v3] = u63
    end
    if v4 and v4.ChildrenInstance then
        table.insert(ProcessedInstance.FrameData.Stack, v4)
    end
    if u5.private.ProcessedInstance then
        v4.LastUpdateTick = u5.private.ProcessedInstance.Tick
        v4.TopInstance.LayoutOrder = ProcessedInstance.FrameData.WidgetIndex
    end
    return v4
end

function u5.public.End(a1) -- Line: 261 -- upvalues: u5 (val)
    local ProcessedInstance = u5.private.ProcessedInstance
    if not ProcessedInstance then
        error("No active instance")
    end
    local v1 = #ProcessedInstance.FrameData.Stack
    if v1 <= 1 then
        return
    end
    table.remove(ProcessedInstance.FrameData.Stack, v1)
end

function u5.public.Connect(a1, a2, a3) -- Line: 275 -- upvalues: u5 (val) -- types: a2: userdata, a3: function
    local u3 = {Tick = 0, Parent = a2}
    u3.FrameData = {WidgetIndex = 0, Stack = {}, WidgetIDs = {}}
    u3.Widgets = {}
    u3.TickLoop = a3
    table.insert(u5.private.Instances, u3)
    return function() -- Line: 294 -- upvalues: u5 (upval), u3 (val)
        u5.private.DestroyImguiInstance(u3)
    end
end

function u5.public.NewWidgetDefinition(a1, a2, a3) -- Line: 299 -- upvalues: u5 (val) -- types: a2: string, a3: table
    if u5.public[a2] then
        error("Couldn't use identifier as already something else is using it")
    end
    u5.private.WidgetDefinitions[a2] = a3

    u5.public[a2] = function(a1, ...) -- Line: 306 -- upvalues: u5 (upval), a2 (val)
        return u5.private.CreateWidgetFromDefinition(a2, ...)
    end
end

function u5.public.GetTick() -- Line: 311 -- upvalues: u5 (val)
    return u5.private.ProcessedInstance and u5.private.ProcessedInstance.Tick or 0
end

function u5.public.applyFrameStyle(a1) -- Line: 315 -- upvalues: u5 (val) -- types: a1: userdata
    local CurrentConfig = u5.private.CurrentConfig
    if 0 < CurrentConfig.Sizes.FramePadding.X or 0 < CurrentConfig.Sizes.FramePadding.Y then
        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingLeft = UDim.new(0, CurrentConfig.Sizes.FramePadding.X)
        UIPadding.PaddingRight = UDim.new(0, CurrentConfig.Sizes.FramePadding.X)
        UIPadding.PaddingTop = UDim.new(0, CurrentConfig.Sizes.FramePadding.Y)
        UIPadding.PaddingBottom = UDim.new(0, CurrentConfig.Sizes.FramePadding.Y)
        UIPadding.Parent = a1
    end
    if 0 < CurrentConfig.Sizes.FrameCornerRadius then
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, CurrentConfig.Sizes.FrameCornerRadius)
        UICorner.Parent = a1
    end
end

function u5.public.GetConfig(a1) -- Line: 334 -- upvalues: u5 (val)
    return u5.private.CurrentConfig
end

function u5.public.applyTextStyle(a1) -- Line: 338 -- upvalues: u5 (val) -- types: a1: userdata
    a1.FontFace = u5.private.CurrentConfig.Font
    a1.TextSize = u5.private.CurrentConfig.Sizes.TextSize
    a1.TextColor3 = u5.private.CurrentConfig.Colors.Text
    a1.AutoLocalize = false
end

function u5.public.applyMouseDownStyle(a1, a2) -- Line: 348 -- upvalues: u5 (val) -- types: a1: userdata, a2: function
    return a1.MouseButton1Down:Connect(function() -- Line: 349 -- upvalues: a1 (val), u5 (upval), a2 (val)
        a1.BackgroundColor3 = u5.private.CurrentConfig.Colors.ButtonActive
        a2()
    end)
end

function u5.public.applyMouseUpStyle(a1, a2) -- Line: 356 -- upvalues: u5 (val) -- types: a1: userdata, a2: function
    return a1.MouseButton1Up:Connect(function() -- Line: 357 -- upvalues: a1 (val), u5 (upval), a2 (val)
        a1.BackgroundColor3 = u5.private.CurrentConfig.Colors.ButtonHovered
        a2()
    end)
end

function u5.public.applyMouseHoverStyle(a1, a2) -- Line: 364 -- upvalues: u5 (val) -- types: a1: userdata, a2: function
    return a1.MouseEnter:Connect(function() -- Line: 365 -- upvalues: a1 (val), u5 (upval), a2 (val)
        a1.BackgroundColor3 = u5.private.CurrentConfig.Colors.ButtonHovered
        a2()
    end)
end

function u5.public.applyMouseHoverEndStyle(a1, a2) -- Line: 372
    -- upvalues: u5 (val)
    return a1.MouseLeave:Connect(function() -- Line: 376 -- upvalues: a1 (val), u5 (upval), a2 (val)
        a1.BackgroundColor3 = u5.private.CurrentConfig.Colors.Button
        a2()
    end)
end

RunService.Heartbeat:Connect(u5.private.ProcessFrame)
return u5.public