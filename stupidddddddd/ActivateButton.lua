-- ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton
-- Script path: ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton
-- Decompile time: 1.35 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local u14 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local Router = require(ReplicatedStorage.Database.Security.Router)

local function MultiplyUdim2(a1, a2) -- Line: 14 -- types: a1: userdata, a2: number
    return UDim2.new(a1.X.Scale * a2, a1.X.Offset, a1.Y.Scale * a2, a1.Y.Offset)
end

return function(a1, a2, a3) -- Line: 21
    -- upvalues: TweenService (val), u14 (val), Router (val)
    local Size = a1.Size
    local u22 = TweenService:Create(a1, u14, {
        Size = UDim2.new(Size.X.Scale * 0.9, Size.X.Offset, Size.Y.Scale * 0.9, Size.Y.Offset),
    })
    local u41 = TweenService:Create(a1, u14, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset),
    })
    local u60 = TweenService:Create(a1, u14, {
        Size = UDim2.new(Size.X.Scale * 0.95, Size.X.Offset, Size.Y.Scale * 0.95, Size.Y.Offset),
    })
    local u79 = TweenService:Create(a1, u14, {
        Size = UDim2.new(Size.X.Scale * 1, Size.X.Offset, Size.Y.Scale * 1, Size.Y.Offset),
    })
    a1.MouseEnter:Connect(function() -- Line: 28 -- upvalues: Router (upval), u60 (val)
        Router.broadcastRouter("RunInterfaceSound", "UI Highlight")
        u60:Play()
    end)
    a1.MouseLeave:Connect(function() -- Line: 32 -- upvalues: u79 (val)
        u79:Play()
    end)
    a1.MouseButton1Down:Connect(function() -- Line: 35 -- upvalues: a2 (val), a3 (val), Router (upval), u22 (val)
        if a2 and a3.Menu.GlobalMarketPlace.Visible then
            return
        end
        Router.broadcastRouter("RunInterfaceSound", "UI Click")
        u22:Play()
    end)
    a1.MouseButton1Up:Connect(function() -- Line: 40 -- upvalues: u41 (val)
        u41:Play()
    end)
end