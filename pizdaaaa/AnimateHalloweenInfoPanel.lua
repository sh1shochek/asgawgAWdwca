-- ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateHalloweenInfoPanel
-- Script path: ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateHalloweenInfoPanel
-- Decompile time: 7.90 ms

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GuiService = game:GetService("GuiService");
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local GuiShown = require(script.Parent.GuiShown);
local Glints = require(script.Parent.Glints);
local NumberRange_new_ret = NumberRange.new(0.4, 3);

local function scaleOn(p1: userdata, p2: string) -- Line: 63
    local v3 = p1:FindFirstChild(p2);

    if not v3 then
        v3 = Instance.new("UIScale");
        v3.Name = p2;
        v3.Parent = p1;
    end;

    return v3;
end;

local function glowsIn(p4: userdata) -- Line: 75
    local v5 = {};

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

local function wave(p6: number, p7: number, p8: number) -- Line: 88
    return math.sin((p6 / p7 + p8) * 2 * 3.141592653589793);
end;

local function inReadingOrder(p9: userdata) -- Line: 95
    local v10 = {};

    for _, child in p9:GetChildren() do
        if child:IsA("GuiObject") then
            table.insert(v10, child);
        end;
    end;

    table.sort(v10, function(p11, p12) -- Line: 102
        return p11.AbsolutePosition.X < p12.AbsolutePosition.X;
    end);

    return v10;
end;

return function(p13: userdata) -- Line: 111
    -- upvalues: Router (copy), inReadingOrder (copy), glowsIn (copy), Glints (copy), GuiService (copy), NumberRange_new_ret (copy), RunServiceController (copy), GuiShown (copy)
    local u14 = {};
    local u15 = {};
    local u16 = {};
    local Random_new_ret = Random.new();

    local function hoverable(p17: userdata, p18: userdata, p19: number, p20: userdata?) -- Line: 117
        -- upvalues: Router (ref), u14 (copy)
        local u21 = {
            Hovered = false,
            Value = 0
        };
        local HoverScale = p18:FindFirstChild("HoverScale");

        if not HoverScale then
            HoverScale = Instance.new("UIScale");
            HoverScale.Name = "HoverScale";
            HoverScale.Parent = p18;
        end;

        u21.Scale = HoverScale;
        u21.Amount = p19;

        local function hover() -- Line: 119
            -- upvalues: u21 (copy), Router (ref)
            u21.Hovered = true;
            Router.broadcastRouter("RunInterfaceSound", "UI Highlight");
        end;

        local function unhover() -- Line: 123
            -- upvalues: u21 (copy)
            u21.Hovered = false;
        end;

        p17.MouseEnter:Connect(hover);
        p17.MouseLeave:Connect(unhover);

        if p20 then
            p20.SelectionGained:Connect(hover);
            p20.SelectionLost:Connect(unhover);
        end;

        table.insert(u14, u21);

        return u21;
    end;

    local Rewards = p13:FindFirstChild("Rewards");

    if Rewards then
        for _, v in inReadingOrder(Rewards) do
            local v22 = hoverable(v, v:FindFirstChild("Icon") or v, 0.14, v);
            local v23 = {
                Glows = glowsIn(v),
                Hover = v22
            };
            table.insert(u15, v23);

            for _, v2 in Glints.Create(v, 2, Random_new_ret) do
                table.insert(u16, v2);
            end;
        end;
    end;

    local BuyCandy = p13:FindFirstChild("BuyCandy");

    if BuyCandy then
        for _, v in inReadingOrder(BuyCandy) do
            local Amount = v:FindFirstChild("Amount");
            local Buy = v:FindFirstChild("Buy");
            local v24 = {
                Glows = glowsIn(v),
                Hover = hoverable(v, Amount or v, 0.1, Buy)
            };
            table.insert(u15, v24);
        end;
    end;

    local CandyCounter = p13:FindFirstChild("CandyCounter");

    if CandyCounter then
        local v25 = {
            Hover = nil,
            Glows = glowsIn(CandyCounter)
        };
        table.insert(u15, v25);

        for _, v in Glints.Create(CandyCounter, 4, Random_new_ret, 6) do
            table.insert(u16, v);
        end;
    end;

    local function step(p26: number) -- Line: 165
        -- upvalues: GuiService (ref), Glints (ref), u16 (copy), Random_new_ret (copy), NumberRange_new_ret (ref), u14 (copy), u15 (copy)
        if GuiService.ReducedMotionEnabled then
            Glints.Hide(u16);

            return;
        end;

        local os_clock_ret = os.clock();
        Glints.Step(u16, Random_new_ret, os_clock_ret, NumberRange_new_ret);
        local v27 = 1 - math.exp(p26 * -14);

        for _, v in u14 do
            local v28 = v.Hovered and 1 or 0;

            if v.Value ~= v28 then
                v.Value = v.Value + (v28 - v.Value) * v27;

                if math.abs(v28 - v.Value) < 0.001 then
                    v.Value = v28;
                end;

                v.Scale.Scale = v.Amount * v.Value + 1;
            end;
        end;

        for i, v in u15 do
            local v29 = not v.Hover and 0 or v.Hover.Value;
            local v30 = i;

            for i2, v2 in v.Glows do
                local v31 = (math.sin((os_clock_ret / 2.2 + (v30 * 0.23 + i2 * 0.15)) * 2 * 3.141592653589793) + 1) / 2 * 0.22;
                v2.Image.ImageTransparency = math.clamp(v2.Transparency + v31 - 0.2 * v29, 0, 1);
            end;
        end;
    end;

    local u32 = RunServiceController.CreateBindingName("UI.HalloweenInfoPanel");
    local u33 = nil;
    GuiShown.Observe(p13, function(p34: boolean) -- Line: 198
        -- upvalues: u33 (ref), RunServiceController (ref), u32 (copy), step (copy)
        if p34 then
            u33 = RunServiceController.BindToRenderStep(u32, step);

            return;
        end;

        if u33 then
            u33:Disconnect();
            u33 = nil;
        end;
    end);
end;