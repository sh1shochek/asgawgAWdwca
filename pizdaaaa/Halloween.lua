-- ReplicatedStorage.Interface.Screens.Menu.Dashboard.Halloween
-- Script path: ReplicatedStorage.Interface.Screens.Menu.Dashboard.Halloween
-- Decompile time: 4.90 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton);
local AnimateHalloweenWheel = require(ReplicatedStorage.Components.Common.InterfaceAnimations.AnimateHalloweenWheel);
local GuiShown = require(ReplicatedStorage.Components.Common.InterfaceAnimations.GuiShown);
local HalloweenEvent = require(ReplicatedStorage.Interface.Screens.Menu.HalloweenEvent);
local u2 = {
    ["92344418364464"] = "Sawed-Off | Coffin",
    ["115432324849385"] = "AWP | Vampire",
    ["93159894183950"] = "Glock-18 | Revenant"
};

local function getSkinIndex(p3: userdata) -- Line: 58
    return tonumber(string.match(p3.Name, "^%a+(%d+)$"));
end;

local function createLoop(p4: userdata, p5: table, p6: number) -- Line: 65
    -- upvalues: TweenService (copy)
    return TweenService:Create(p4, TweenInfo.new(p6 / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), p5);
end;

local function createIdleLoops(p7) -- Line: 73
    -- upvalues: createLoop (copy)
    local v8 = {};

    for _, child in p7.Container.Preview.Info.Skins:GetChildren() do
        local v9 = tonumber(string.match(child.Name, "^%a+(%d+)$"));

        if v9 and child:IsA("GuiObject") then
            local v10 = {
                Position = child.Position - UDim2.fromScale(0, 0.06)
            };
            table.insert(v8, createLoop(child, v10, 2.4 + (v9 - 1) * 0.3));
        end;
    end;

    local Icon = p7.Header.Icon;
    local Rotation = Icon.Rotation;
    Icon.Rotation = Rotation - 6;
    table.insert(v8, createLoop(Icon, {
        Rotation = Rotation + 6
    }, 1.8));

    return v8;
end;

local function bindSkinInspect(p11: userdata) -- Line: 96
    -- upvalues: u2 (copy), HalloweenEvent (copy)
    for _, child in p11:GetChildren() do
        if child:IsA("ImageLabel") and string.match(child.Name, "^Skin%d+$") then
            local u12 = u2[string.match(child.Image, "%d+") or ""];

            if u12 then
                child.Active = true;
                child.InputBegan:Connect(function(p13: userdata) -- Line: 107
                    -- upvalues: HalloweenEvent (ref), u12 (copy)
                    local UserInputType = p13.UserInputType;

                    if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
                        HalloweenEvent.InspectPrize(u12);
                    end;
                end);
            end;
        end;
    end;
end;

function v1.Initialize(u14: userdata) -- Line: 119
    -- upvalues: AnimateHalloweenWheel (copy), HalloweenEvent (copy), ActivateButton (copy), bindSkinInspect (copy), createIdleLoops (copy), GuiShown (copy)
    local Preview = u14.Container.Preview;
    local Wheel = Preview.Wheel;
    Wheel.Position = Wheel.Position + UDim2.fromScale(0, 0.047);
    AnimateHalloweenWheel(Preview.Wheel, true);
    HalloweenEvent.BindCandyLabel(u14.Header.Candy.Amount);
    local Open = Preview.Info.Open;
    ActivateButton(Open);
    Open.MouseButton1Click:Connect(function() -- Line: 129
        -- upvalues: HalloweenEvent (ref), Open (copy)
        HalloweenEvent.Open(Open);
    end);
    bindSkinInspect(Preview.Info.Skins);
    HalloweenEvent.ObserveRunning(function(p15: boolean) -- Line: 136
        -- upvalues: u14 (copy)
        u14.Visible = p15;
    end);
    local u16 = createIdleLoops(u14);
    GuiShown.Observe(u14, function(p17: boolean) -- Line: 142
        -- upvalues: u16 (copy)
        for _, v in u16 do
            if p17 then
                v:Play();
            else
                v:Pause();
            end;
        end;
    end);
end;

return v1;