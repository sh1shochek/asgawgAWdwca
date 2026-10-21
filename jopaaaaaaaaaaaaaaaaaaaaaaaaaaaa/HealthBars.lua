-- ReplicatedStorage.Controllers.HordeController.HealthBars
-- Script path: ReplicatedStorage.Controllers.HordeController.HealthBars
-- Decompile time: 4.50 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Linear);
local TweenInfo_new_ret2 = TweenInfo.new(0.25);
local u2 = {};
local u3 = {};

local function collectFadeTargets(p4: userdata) -- Line: 60
    local v5 = {};

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("GuiObject") then
            v5[#v5 + 1] = {
                Property = "BackgroundTransparency",
                Instance = descendant,
                Base = descendant.BackgroundTransparency
            };

            if descendant:IsA("TextLabel") then
                v5[#v5 + 1] = {
                    Property = "TextTransparency",
                    Instance = descendant,
                    Base = descendant.TextTransparency
                };
            elseif descendant:IsA("ImageLabel") then
                v5[#v5 + 1] = {
                    Property = "ImageTransparency",
                    Instance = descendant,
                    Base = descendant.ImageTransparency
                };
            end;
        elseif descendant:IsA("UIStroke") then
            v5[#v5 + 1] = {
                Property = "Transparency",
                Instance = descendant,
                Base = descendant.Transparency
            };
        end;
    end;

    return v5;
end;

local function makeBar(p6: userdata) -- Line: 77
    -- upvalues: ReplicatedStorage (copy), Players (copy), collectFadeTargets (copy)
    local v7 = ReplicatedStorage.Assets.UI.Survival.ZombieHealth:Clone();
    v7.ResetOnSpawn = false;
    v7.Enabled = false;
    v7.Adornee = p6;
    v7.Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    return {
        Fraction = -1,
        Generation = 0,
        Gui = v7,
        Head = p6,
        Fill = v7.Track.Bar,
        Fade = collectFadeTargets(v7),
        Fading = {}
    };
end;

local function takeBar(p8: userdata, p9: number) -- Line: 96
    -- upvalues: u3 (copy), makeBar (copy)
    local v10 = table.remove(u3) or makeBar(p8);

    if v10.Head ~= p8 then
        v10.Head = p8;
        v10.Gui.Adornee = p8;
    end;

    v10.Gui.StudsOffsetWorldSpace = Vector3.new(0, p8.Size.Y / 2 + 0.8, 0);
    v10.Fraction = p9;
    v10.Fill.Size = UDim2.fromScale(p9, 1);
    v10.Gui.Enabled = true;

    return v10;
end;

local function stopFade(p11: table) -- Line: 109
    if #p11.Fading == 0 then
        return;
    end;

    for _, v in p11.Fading do
        v:Cancel();
    end;

    table.clear(p11.Fading);

    for _, v in p11.Fade do
        v.Instance[v.Property] = v.Base;
    end;
end;

local function hide(u12: number, u13: number) -- Line: 122
    -- upvalues: u2 (copy), TweenService (copy), TweenInfo_new_ret2 (copy), u1 (copy)
    local u14 = u2[u12];

    if not u14 or u14.Generation ~= u13 then
        return;
    end;

    for _, v in u14.Fade do
        local v15 = TweenService:Create(v.Instance, TweenInfo_new_ret2, {
            [v.Property] = 1
        });
        v15:Play();
        u14.Fading[#u14.Fading + 1] = v15;
    end;

    task.delay(0.25, function() -- Line: 132
        -- upvalues: u2 (ref), u12 (copy), u14 (copy), u13 (copy), u1 (ref)
        if u2[u12] == u14 and u14.Generation == u13 then
            u1.Remove(u12);
        end;
    end);
end;

function u1.Show(p16: number, p17: userdata, p18: number) -- Line: 143
    -- upvalues: u2 (copy), u1 (copy), takeBar (copy), stopFade (copy), hide (copy)
    local v19 = u2[p16];

    if v19 and v19.Head.Parent ~= p17 then
        u1.Remove(p16);
        v19 = nil;
    end;

    if not v19 then
        local Head = p17:FindFirstChild("Head");

        if not (Head and Head:IsA("BasePart")) then
            return;
        end;

        v19 = takeBar(Head, p18);
        u2[p16] = v19;
    end;

    stopFade(v19);
    v19.Generation = v19.Generation + 1;
    task.delay(3, hide, p16, v19.Generation);
end;

function u1.SetHealth(p20: number, p21: number) -- Line: 165
    -- upvalues: u2 (copy), TweenService (copy), TweenInfo_new_ret (copy)
    local v22 = u2[p20];

    if v22 and v22.Fraction ~= p21 then
        v22.Fraction = p21;
        TweenService:Create(v22.Fill, TweenInfo_new_ret, {
            Size = UDim2.fromScale(p21, 1)
        }):Play();
    end;
end;

function u1.Remove(p23: number) -- Line: 173
    -- upvalues: u2 (copy), stopFade (copy), u3 (copy)
    local v24 = u2[p23];

    if v24 then
        u2[p23] = nil;
        v24.Generation = v24.Generation + 1;
        stopFade(v24);

        if #u3 < 24 and v24.Gui.Parent then
            v24.Gui.Enabled = false;
            u3[#u3 + 1] = v24;

            return;
        end;

        v24.Gui:Destroy();
    end;
end;

function u1.Clear() -- Line: 189
    -- upvalues: u2 (copy), u1 (copy), u3 (copy)
    for i in u2 do
        u1.Remove(i);
    end;

    for _, v in u3 do
        v.Gui:Destroy();
    end;

    table.clear(u3);
end;

return u1;