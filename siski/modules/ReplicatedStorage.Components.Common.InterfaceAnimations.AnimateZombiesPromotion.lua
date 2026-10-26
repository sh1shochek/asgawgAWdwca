-- ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateZombiesPromotion
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GuiShown = require(script.Parent.GuiShown);
local Glints = require(script.Parent.Glints);
local NumberRange_new_ret = NumberRange.new(0.4, 3);

local function scaleOn(p1: userdata, p2: string) -- Line: 74
    local v3 = p1:FindFirstChild(p2);

    if not v3 then
        v3 = Instance.new("UIScale");
        v3.Name = p2;
        v3.Parent = p1;
    end;

    return v3;
end;

local function glowsIn(p4: userdata?) -- Line: 86
    local v5 = {};

    if not p4 then
        return v5;
    end;

    for _, child in p4:GetChildren() do
        if child.Name == "Glow" and child:IsA("ImageLabel") then
            table.insert(v5, {
                Image = child,
                Transparency = child.ImageTransparency
            });
        end;
    end;

    return v5;
end;

local function wave(p6: number, p7: number, p8: number) -- Line: 102
    return math.sin((p6 / p7 + p8) * 2 * 3.141592653589793);
end;

local function easeOutBack(p9: number) -- Line: 109
    return (p9 - 1) ^ 3 * 2.70158 + 1 + (p9 - 1) ^ 2 * 1.70158;
end;

local function easeInOutQuad(p10: number) -- Line: 117
    if p10 < 0.5 then
        return p10 * 2 * p10;
    end;

    return 1 - (p10 * -2 + 2) ^ 2 / 2;
end;

local function inReadingOrder(p11: userdata) -- Line: 124
    local v12 = {};

    for _, child in p11:GetChildren() do
        if child:IsA("GuiObject") then
            table.insert(v12, child);
        end;
    end;

    table.sort(v12, function(p13, p14) -- Line: 131
        if p13.LayoutOrder == p14.LayoutOrder then
            return p13.AbsolutePosition.X < p14.AbsolutePosition.X;
        end;

        return p13.LayoutOrder < p14.LayoutOrder;
    end);

    return v12;
end;

return function(p15: userdata) -- Line: 143
    -- upvalues: inReadingOrder (copy), glowsIn (copy), Router (copy), Glints (copy), GuiService (copy), NumberRange_new_ret (copy), RunServiceController (copy), GuiShown (copy)
    local u16 = {};
    local u17 = {};
    local Random_new_ret = Random.new();
    local Rewards = p15:FindFirstChild("Rewards");

    if Rewards then
        Rewards = Rewards:FindFirstChild("Items");
    end;

    if Rewards then
        for _, v in inReadingOrder(Rewards) do
            local Icon = v:FindFirstChild("Icon");
            local v18 = v:FindFirstChildOfClass("UIStroke");
            local u19 = {
                Hovered = false,
                Hover = 0
            };
            local v20;

            if Icon then
                v20 = Icon:FindFirstChild("PromotionScale");

                if not v20 then
                    v20 = Instance.new("UIScale");
                    v20.Name = "PromotionScale";
                    v20.Parent = Icon;
                end;
            else
                v20 = nil;
            end;

            u19.Scale = v20;
            u19.Stroke = v18;
            u19.StrokeThickness = not v18 and 0 or v18.Thickness;
            u19.Glows = glowsIn(v);
            v.MouseEnter:Connect(function() -- Line: 162
                -- upvalues: u19 (copy), Router (ref)
                u19.Hovered = true;
                Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
            end);
            v.MouseLeave:Connect(function() -- Line: 166
                -- upvalues: u19 (copy)
                u19.Hovered = false;
            end);
            table.insert(u16, u19);

            for _, v2 in Glints.Create(v, 2, Random_new_ret, 5) do
                table.insert(u17, v2);
            end;
        end;
    end;

    local u21 = glowsIn(p15:FindFirstChild("BG"));

    for _, v in glowsIn(p15:FindFirstChild("GlowEffect")) do
        table.insert(u21, v);
    end;

    local TitleGlow = p15:FindFirstChild("TitleGlow");

    if TitleGlow and TitleGlow:IsA("ImageLabel") then
        table.insert(u21, {
            Image = TitleGlow,
            Transparency = TitleGlow.ImageTransparency
        });
    end;

    local Join = p15:FindFirstChild("Join");
    local u22;

    if Join then
        u22 = Join:FindFirstChild("PromotionScale");

        if not u22 then
            u22 = Instance.new("UIScale");
            u22.Name = "PromotionScale";
            u22.Parent = Join;
        end;
    else
        u22 = nil;
    end;

    local u23 = {};
    local u24 = false;
    local u25 = 0;
    local u26 = (-1 / 0);
    local u27;

    if Join then
        for _, v in glowsIn(Join:FindFirstChild("GlowEffect")) do
            if v.Transparency < 1 then
                table.insert(u23, v);
            end;
        end;

        u27 = Join:FindFirstChild("Shine");
        Join.MouseEnter:Connect(function() -- Line: 201
            -- upvalues: u24 (ref), u26 (ref)
            u24 = true;
            local os_clock_ret = os.clock();

            if os_clock_ret - u26 > 0.75 then
                u26 = os_clock_ret;
            end;
        end);
        Join.MouseLeave:Connect(function() -- Line: 209
            -- upvalues: u24 (ref)
            u24 = false;
        end);
    else
        u27 = nil;
    end;

    local function setShineX(p28: number) -- Line: 214
        -- upvalues: u27 (ref)
        if u27 then
            u27.Position = UDim2.new(p28, u27.Position.X.Offset, u27.Position.Y.Scale, u27.Position.Y.Offset);
        end;
    end;

    local function rest() -- Line: 221
        -- upvalues: Glints (ref), u17 (copy), u16 (copy), u21 (copy), u23 (copy), u22 (copy), u27 (ref)
        Glints.Hide(u17);

        for _, v in u16 do
            if v.Scale then
                v.Scale.Scale = 1;
            end;

            if v.Stroke then
                v.Stroke.Thickness = v.StrokeThickness;
            end;

            for _, v2 in v.Glows do
                v2.Image.ImageTransparency = v2.Transparency;
            end;
        end;

        for _, v in u21 do
            v.Image.ImageTransparency = v.Transparency;
        end;

        for _, v in u23 do
            v.Image.ImageTransparency = v.Transparency;
        end;

        if u22 then
            u22.Scale = 1;
        end;

        if u27 then
            u27.Position = UDim2.new(-0.3, u27.Position.X.Offset, u27.Position.Y.Scale, u27.Position.Y.Offset);
        end;
    end;

    local u29 = 0;

    local function step(p30: number) -- Line: 247
        -- upvalues: GuiService (ref), rest (copy), Glints (ref), u17 (copy), Random_new_ret (copy), NumberRange_new_ret (ref), u16 (copy), u29 (ref), u21 (copy), u25 (ref), u24 (ref), u22 (copy), u23 (copy), u26 (ref), u27 (ref)
        if GuiService.ReducedMotionEnabled then
            rest();

            return;
        end;

        local os_clock_ret = os.clock();
        local v31 = 1 - math.exp(p30 * -14);
        Glints.Step(u17, Random_new_ret, os_clock_ret, NumberRange_new_ret);

        for i, v in u16 do
            local v32 = v.Hovered and 1 or 0;
            v.Hover = v.Hover + (v32 - v.Hover) * v31;

            if math.abs(v32 - v.Hover) < 0.001 then
                v.Hover = v32;
            end;

            local math_clamp_ret = math.clamp((os_clock_ret - u29 - 0.12 - (i - 1) * 0.08) / 0.4, 0, 1);

            if v.Scale then
                v.Scale.Scale = ((math_clamp_ret - 1) ^ 3 * 2.70158 + 1 + (math_clamp_ret - 1) ^ 2 * 1.70158) * (v.Hover * 0.15 + 1);
            end;

            if v.Stroke then
                v.Stroke.Thickness = v.StrokeThickness + v.Hover * 1;
            end;

            local v33 = v;
            local v34 = i;

            for i2, v2 in v.Glows do
                local v35 = (math.sin((os_clock_ret / 2.2 + (v34 * 0.23 + i2 * 0.15)) * 2 * 3.141592653589793) + 1) / 2 * 0.22;
                v2.Image.ImageTransparency = math.clamp(v2.Transparency + v35 - v33.Hover * 0.25, 0, 1);
            end;
        end;

        for i, v in u21 do
            local v36 = (math.sin((os_clock_ret / 3.6 + i * 0.37) * 2 * 3.141592653589793) + 1) / 2 * 0.15;
            v.Image.ImageTransparency = math.clamp(v.Transparency + v36, 0, 1);
        end;

        u25 = u25 + ((u24 and 1 or 0) - u25) * v31;

        if u22 then
            u22.Scale = (math.sin((os_clock_ret / 1.6 + 0) * 2 * 3.141592653589793) + 1) * 0.025 / 2 * (1 - u25) + 1;
        end;

        for _, v in u23 do
            local v37 = (math.sin((os_clock_ret / 1.6 + 0.5) * 2 * 3.141592653589793) + 1) / 2 * 0.22;
            v.Image.ImageTransparency = math.clamp(v.Transparency + v37 - u25 * 0.22, 0, 1);
        end;

        if os_clock_ret - u26 >= 3.2 then
            u26 = os_clock_ret;
        end;

        local math_clamp_ret = math.clamp((os_clock_ret - u26) / 0.75, 0, 1);
        local v38;

        if math_clamp_ret < 0.5 then
            v38 = math_clamp_ret * 2 * math_clamp_ret;
        else
            v38 = 1 - (math_clamp_ret * -2 + 2) ^ 2 / 2;
        end;

        local v39 = v38 * 1.6 + -0.3;

        if u27 then
            u27.Position = UDim2.new(v39, u27.Position.X.Offset, u27.Position.Y.Scale, u27.Position.Y.Offset);
        end;
    end;

    local u40 = RunServiceController.CreateBindingName("UI.Gamemodes.ZombiesPromotion");
    local u41 = nil;
    GuiShown.Observe(p15, function(p42: boolean) -- Line: 301
        -- upvalues: u29 (ref), u26 (ref), u16 (copy), u41 (ref), RunServiceController (ref), u40 (copy), step (copy)
        if not p42 then
            if u41 then
                u41:Disconnect();
                u41 = nil;
            end;

            return;
        end;

        u29 = os.clock();
        u26 = u29 + 0.12 + #u16 * 0.08 - 3.2;
        u41 = RunServiceController.BindToRenderStep(u40, step);
    end);
end;