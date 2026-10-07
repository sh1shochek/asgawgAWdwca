-- ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionsList
-- Script path: ReplicatedStorage.Packages.DebugTools.Client.Builtin.Tabs.Actions.Interface.ActionsList
-- Decompile time: 1.10 ms

local Parent_5 = script.Parent.Parent.Parent.Parent.Parent
local Style = require(Parent_5.Style)
local ActionFrame = require(script.Parent.ActionFrame)
return function(a1, a2, a3) -- Line: 8 -- upvalues: Style (val), ActionFrame (val) -- types: a1: userdata
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Actions"
    ScrollingFrame.AnchorPoint = Vector2.new(1, 0)
    ScrollingFrame.Position = UDim2.fromScale(1, 0)
    ScrollingFrame.Size = UDim2.fromScale(0.75, 1)
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    ScrollingFrame.ScrollBarImageColor3 = Style.COLOR_BLACK
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local UIPadding = Instance.new("UIPadding")
    UIPadding.Name = "UIPadding"
    UIPadding.PaddingBottom = UDim.new(0, 8)
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)
    UIPadding.Parent = ScrollingFrame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Name = "UIListLayout"
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    ScrollingFrame.Parent = a1
    local u59 = {}

    local function refreshActions() -- Line: 42
        -- upvalues: a2 (val), a3 (val), u59 (ref), ActionFrame (upval), ScrollingFrame (ref)
        local v1 = a2:Get()
        local v2 = a3:Get()
        if not v1 then
            return
        end
        local v3 = {}
        for i in v2 do
            table.sort(v2[i], function(a1, a2) -- Line: 53
                return a1.Name < a2.Name
            end)
        end
        for j, k in v2[v1] do
            table.insert(v3, k.RawName)
            if not u59[k.RawName] then
                u59[k.RawName] = (ActionFrame(k, ScrollingFrame, j))
            end
        end
        for n, m in u59 do
            if not table.find(v3, n) then
                m()
                u59[n] = nil
            end
        end
    end

    local u64 = a2:Observe(function() -- Line: 78 -- upvalues: refreshActions (val)
        refreshActions()
    end)
    local u68 = a3:Observe(function() -- Line: 82 -- upvalues: refreshActions (val)
        refreshActions()
    end)
    refreshActions()
    return function() -- Line: 88 -- upvalues: u64 (ref), u68 (ref), ScrollingFrame (ref), u59 (ref)
        u64:Disconnect()
        u64 = nil
        u68:Disconnect()
        u68 = nil
        ScrollingFrame:Destroy()
        ScrollingFrame = nil
        for i, j in u59 do
            j()
        end
        u59 = nil
    end
end