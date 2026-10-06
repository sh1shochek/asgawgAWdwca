-- Decompiled with Potassium's decompiler.

local Style = require(script.Parent.Parent.Parent.Parent.Parent.Style);
local ActionFrame = require(script.Parent.ActionFrame);

return function(p1: userdata, u2: any, u3: any) -- Line: 8
    -- upvalues: Style (copy), ActionFrame (copy)
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Actions";
    ScrollingFrame.AnchorPoint = Vector2.new(1, 0);
    ScrollingFrame.Position = UDim2.fromScale(1, 0);
    ScrollingFrame.Size = UDim2.fromScale(0.75, 1);
    ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
    ScrollingFrame.ScrollBarImageColor3 = Style.COLOR_BLACK;
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
    ScrollingFrame.Active = true;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.CanvasSize = UDim2.new();
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 8);
    UIPadding.PaddingLeft = UDim.new(0, 8);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.PaddingTop = UDim.new(0, 8);
    UIPadding.Parent = ScrollingFrame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "UIListLayout";
    UIListLayout.Padding = UDim.new(0, 8);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = ScrollingFrame;
    ScrollingFrame.Parent = p1;
    local u4 = {};

    local function refreshActions() -- Line: 42
        -- upvalues: u2 (copy), u3 (copy), u4 (ref), ActionFrame (ref), ScrollingFrame (ref)
        local v5 = u2:Get();
        local v6 = u3:Get();

        if not v5 then
            return;
        end;

        local v7 = {};

        for i in v6 do
            table.sort(v6[i], function(p8, p9) -- Line: 53
                return p8.Name < p9.Name;
            end);
        end;

        for i, v in v6[v5] do
            table.insert(v7, v.RawName);

            if not u4[v.RawName] then
                u4[v.RawName] = ActionFrame(v, ScrollingFrame, i);
            end;
        end;

        for i, v in u4 do
            if not table.find(v7, i) then
                v();
                u4[i] = nil;
            end;
        end;
    end;

    local u10 = u2:Observe(function() -- Line: 78
        -- upvalues: refreshActions (copy)
        refreshActions();
    end);
    local u11 = u3:Observe(function() -- Line: 82
        -- upvalues: refreshActions (copy)
        refreshActions();
    end);
    refreshActions();

    return function() -- Line: 88
        -- upvalues: u10 (ref), u11 (ref), ScrollingFrame (ref), u4 (ref)
        u10:Disconnect();
        u10 = nil;
        u11:Disconnect();
        u11 = nil;
        ScrollingFrame:Destroy();
        ScrollingFrame = nil;

        for _, v in u4 do
            v();
        end;

        u4 = nil;
    end;
end;