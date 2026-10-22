-- ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton
-- Script path: ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton
-- Decompile time: 4.28 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local Router = require(ReplicatedStorage.Database.Security.Router);

local function MultiplyUdim2(p1, p2: number) -- Line: 14
    return UDim2.new(p1.X.Scale * p2, p1.X.Offset, p1.Y.Scale * p2, p1.Y.Offset);
end;

return function(p3: userdata, u4: boolean?, u5: any, p6: number?, p7: number?) -- Line: 23
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), Router (copy)
    local v8 = p6 or 0.95;
    local Size = p3.Size;
    local v9 = {};
    local v10 = p7 or 0.9;
    v9.Size = UDim2.new(Size.X.Scale * v10, Size.X.Offset, Size.Y.Scale * v10, Size.Y.Offset);
    local u11 = TweenService:Create(p3, TweenInfo_new_ret, v9);
    local u12 = TweenService:Create(p3, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * v8, Size.X.Offset, Size.Y.Scale * v8, Size.Y.Offset)
    });
    local u13 = TweenService:Create(p3, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * v8, Size.X.Offset, Size.Y.Scale * v8, Size.Y.Offset)
    });
    local u14 = TweenService:Create(p3, TweenInfo_new_ret, {
        Size = UDim2.new(Size.X.Scale * 1, Size.X.Offset, Size.Y.Scale * 1, Size.Y.Offset)
    });
    p3.MouseEnter:Connect(function() -- Line: 32
        -- upvalues: Router (ref), u13 (copy)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        u13:Play();
    end);
    p3.MouseLeave:Connect(function() -- Line: 37
        -- upvalues: u14 (copy)
        u14:Play();
    end);
    p3.MouseButton1Down:Connect(function() -- Line: 41
        -- upvalues: u4 (copy), u5 (copy), Router (ref), u11 (copy)
        if u4 and (u5 and u5.Menu.GlobalMarketPlace.Visible) then
            return;
        end;

        Router.broadcastRouter("RunInterfaceSound", "UI Click");
        u11:Play();
    end);
    p3.MouseButton1Up:Connect(function() -- Line: 49
        -- upvalues: u12 (copy)
        u12:Play();
    end);
end;