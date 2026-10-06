-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Router = require(ReplicatedStorage.Database.Security.Router);

local function MultiplyUdim2(p1, p2: number) -- Line: 14
    return UDim2.new(p1.X.Scale * p2, p1.X.Offset, p1.Y.Scale * p2, p1.Y.Offset);
end;

return function(p3: userdata, u4: boolean?, u5: userdata?) -- Line: 21
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), Router (copy)
    local Size = p3.Size;
    local u6 = TweenService:Create(p3, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 0.9, Size.X.Offset, Size.Y.Scale * 0.9, Size.Y.Offset)
    });
    local u7 = TweenService:Create(p3, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset)
    });
    local u8 = TweenService:Create(p3, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset)
    });
    local u9 = TweenService:Create(p3, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 1, Size.X.Offset, Size.Y.Scale * 1, Size.Y.Offset)
    });
    p3.MouseEnter:Connect(function() -- Line: 28
        -- upvalues: Router (ref), u8 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        u8:Play();
    end);
    p3.MouseLeave:Connect(function() -- Line: 32
        -- upvalues: u9 (copy)
        u9:Play();
    end);
    p3.MouseButton1Down:Connect(function() -- Line: 35
        -- upvalues: u4 (copy), u5 (copy), Router (ref), u6 (copy)
        if u4 and u5.Menu.GlobalMarketPlace.Visible then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u6:Play();
    end);
    p3.MouseButton1Up:Connect(function() -- Line: 40
        -- upvalues: u7 (copy)
        u7:Play();
    end);
end;