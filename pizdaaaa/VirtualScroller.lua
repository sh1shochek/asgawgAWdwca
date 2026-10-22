-- ReplicatedStorage.ClientModules.VirtualScroller
-- Script path: ReplicatedStorage.ClientModules.VirtualScroller
-- Decompile time: 3.58 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2: userdata, p3: any) -- Line: 7
    -- upvalues: u1 (copy)
    local u4 = setmetatable({}, u1);
    u4.ScrollingFrame = p2;
    u4.LoadCallback = p3;
    u4.IsLoading = false;
    u4.HasMore = true;
    u4.CurrentPage = 1;
    u4.Threshold = 150;
    u4.Connection = u4.ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 19
        -- upvalues: u4 (copy)
        u4:CheckScroll();
    end);

    return u4;
end;

function u1.CheckScroll(p5) -- Line: 26
    if not p5.ScrollingFrame then
        return;
    end;

    if p5.IsLoading or not p5.HasMore then
        return;
    end;

    if p5.ScrollingFrame.CanvasPosition.Y + p5.ScrollingFrame.AbsoluteWindowSize.Y >= p5.ScrollingFrame.AbsoluteCanvasSize.Y - p5.Threshold then
        p5:LoadNextPage();
    end;
end;

function u1.LoadNextPage(u6) -- Line: 42
    u6.IsLoading = true;
    task.spawn(function() -- Line: 45
        -- upvalues: u6 (copy)
        local v7 = u6.LoadCallback(u6.CurrentPage);
        local v8 = u6;
        v8.CurrentPage = v8.CurrentPage + 1;

        if v7 == false then
            u6.HasMore = false;
        else
            u6.HasMore = true;
        end;

        u6.IsLoading = false;
        task.wait();
        u6:CheckScroll();
    end);
end;

function u1.Reset(p9) -- Line: 64
    p9.IsLoading = false;
    p9.HasMore = true;
    p9.CurrentPage = 1;
    p9.ScrollingFrame.CanvasPosition = Vector2.zero;

    for _, child in p9.ScrollingFrame:GetChildren() do
        if child:IsA("GuiObject") then
            child.Parent = nil;
        end;
    end;
end;

function u1.Destroy(p10) -- Line: 77
    if p10.Connection then
        p10.Connection:Disconnect();
    end;

    p10.LoadCallback = nil;
    p10.ScrollingFrame = nil;
end;

return u1;