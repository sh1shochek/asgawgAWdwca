-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Router = require(ReplicatedStorage.Database.Security.Router);
local table_freeze_ret = table.freeze({
    hoverSizeMultiplier = 1.1
});
local Out = Enum.EasingDirection.Out;
local Quad = Enum.EasingStyle.Quad;
local u1 = {};
u1.__index = u1;

local function isPointInGui(p2: userdata, p3) -- Line: 18
    local AbsolutePosition = p2.AbsolutePosition;
    local AbsoluteSize = p2.AbsoluteSize;
    local v4;

    if p3.X >= AbsolutePosition.X and (p3.X <= AbsolutePosition.X + AbsoluteSize.X and p3.Y >= AbsolutePosition.Y) then
        v4 = p3.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v4 = false;
    end;

    return v4;
end;

local function isGuiVisible(p5: userdata) -- Line: 28
    while p5 do
        if p5:IsA("GuiObject") and not p5.Visible then
            return false;
        end;

        if p5:IsA("LayerCollector") and not p5.Enabled then
            return false;
        end;

        p5 = p5.Parent;
    end;

    return true;
end;

function u1.new(u6: userdata, p7: table?) -- Line: 45
    -- upvalues: table_freeze_ret (copy), u1 (copy), Out (copy), Quad (copy), isGuiVisible (copy), UserInputService (copy), Router (copy), Players (copy)
    local table_clone_ret = table.clone(p7 or {});

    for i, v in table_freeze_ret do
        if table_clone_ret[i] == nil then
            table_clone_ret[i] = v;
        end;
    end;

    local u8 = setmetatable({
        _isHovering = false,
        Instance = u6
    }, u1);
    local u9 = u6:GetAttribute("OriginalSize") or u6.Size;

    if u6:GetAttribute("OriginalSize") then
        u6.Size = u9;
    else
        u6:SetAttribute("OriginalSize", u9);
    end;

    local u10 = table_clone_ret.hoverSizeMultiplier and UDim2.new(u9.X.Scale * table_clone_ret.hoverSizeMultiplier, u9.X.Offset * table_clone_ret.hoverSizeMultiplier, u9.Y.Scale * table_clone_ret.hoverSizeMultiplier, u9.Y.Offset * table_clone_ret.hoverSizeMultiplier);
    u8._originalSize = u9;
    u8._hasHoverSize = u10 ~= nil;

    local function tweenSize(p11, p12: function?, p13: number?) -- Line: 75
        -- upvalues: u6 (copy), Out (ref), Quad (ref)
        u6:TweenSize(p11, Out, Quad, 0.15 * (p13 or 1), true, p12);
    end;

    local function shouldRestoreHoverState() -- Line: 80
        -- upvalues: u8 (copy), u6 (copy), isGuiVisible (ref), UserInputService (ref)
        if not (u8._isHovering and (u6:IsDescendantOf(game) and isGuiVisible(u6))) then
            return false;
        end;

        local MouseLocation = UserInputService:GetMouseLocation();
        local v14 = u6;
        local Vector2_new_ret = Vector2.new(MouseLocation.X, MouseLocation.Y);
        local AbsolutePosition = v14.AbsolutePosition;
        local AbsoluteSize = v14.AbsoluteSize;
        local v15;

        if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
            v15 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v15 = false;
        end;

        return v15;
    end;

    if u10 or table_clone_ret.onMouseEnter then
        u8._mouseEnter = u6.MouseEnter:Connect(function(p16, p17) -- Line: 90
            -- upvalues: u8 (copy), u10 (copy), u6 (copy), Out (ref), Quad (ref), table_clone_ret (copy), Router (ref)
            u8._isHovering = true;

            if u10 then
                u6:TweenSize(u10, Out, Quad, 0.15, true, nil);
            end;

            if table_clone_ret.onMouseEnter then
                table_clone_ret.onMouseEnter(p16, p17);
            end;

            Router.broadcastRouter("RunInterfaceSound", "Button Hover");
        end);
    end;

    if u10 or table_clone_ret.onMouseLeave then
        u8._mouseLeave = u6.MouseLeave:Connect(function(p18, p19) -- Line: 103
            -- upvalues: u8 (copy), u10 (copy), u9 (copy), u6 (copy), Out (ref), Quad (ref), table_clone_ret (copy)
            u8._isHovering = false;

            if u10 then
                u6:TweenSize(u9, Out, Quad, 0.15, true, nil);
            end;

            if table_clone_ret.onMouseLeave then
                table_clone_ret.onMouseLeave(p18, p19);
            end;
        end);
    end;

    if table_clone_ret.onActivated then
        u8._activated = u6.Activated:Connect(function() -- Line: 115
            -- upvalues: Router (ref), u10 (copy), u9 (copy), u8 (copy), shouldRestoreHoverState (copy), u6 (copy), Out (ref), Quad (ref), Players (ref), table_clone_ret (copy)
            Router.broadcastRouter("RunInterfaceSound", "Button Click");

            if u10 then
                u6:TweenSize(u9, Out, Quad, 0.075, true, function() -- Line: 119
                    -- upvalues: u8 (ref), shouldRestoreHoverState (ref), u10 (ref), u6 (ref), Out (ref), Quad (ref)
                    u8._isHovering = shouldRestoreHoverState();

                    if u8._isHovering then
                        u6:TweenSize(u10, Out, Quad, 0.075, true, nil);
                    end;
                end);
            end;

            local FullName = u6:GetFullName();

            if FullName:find("GlobalMarketPlace") and not (FullName:find("Close") or (FullName:find("Pin") or (FullName:find("Top") or Players.LocalPlayer:GetAttribute("PinVerified")))) then
                return;
            end;

            table_clone_ret.onActivated();
        end);
    end;

    u8._destroying = u6.Destroying:Once(function() -- Line: 136
        -- upvalues: u8 (copy)
        u8:Destroy();
    end);

    return u8;
end;

function u1.Destroy(p20: table) -- Line: 143
    if p20._hasHoverSize then
        p20.Instance.Size = p20._originalSize;
    end;

    for _, v in { "_mouseEnter", "_mouseLeave", "_activated", "_destroying" } do
        local v21 = p20[v];

        if v21 then
            v21:Disconnect();
        end;
    end;
end;

return u1;