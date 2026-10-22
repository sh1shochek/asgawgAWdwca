-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.SurvivalAlert
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.SurvivalAlert
-- Decompile time: 5.40 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local GeneratorController = require(ReplicatedStorage.Controllers.GeneratorController);
local TweenInfo_new_ret = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u2 = nil;
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = nil;
local u7 = 0;

local function getLetterBox(p8: string) -- Line: 51
    -- upvalues: u5 (copy), ReplicatedStorage (copy), u2 (ref)
    local v9 = u5[p8];

    if v9 and v9.Parent then
        return v9;
    end;

    local v10 = ReplicatedStorage.Assets.UI.Survival.LetterTemplate:Clone();
    v10.Name = p8;
    v10.Visible = false;
    v10.Letter.Text = p8;
    v10.Parent = u2.Letters;
    u5[p8] = v10;

    return v10;
end;

local function refreshAlert() -- Line: 67
    -- upvalues: u2 (ref), u4 (copy), u5 (copy), ReplicatedStorage (copy), u7 (ref), TweenService (copy), TweenInfo_new_ret (copy), u6 (ref), TweenInfo_new_ret2 (copy)
    local Bar = u2.Bar;
    local Objective = u2.Bar.Objective;
    local Glow = u2.Bar.Glow;
    local os_clock_ret = os.clock();
    local v11 = false;
    local v12 = false;

    for i, v in u4 do
        local v13 = os_clock_ret < v.Until;
        local v14 = u5[i];

        if not (v14 and v14.Parent) then
            v14 = ReplicatedStorage.Assets.UI.Survival.LetterTemplate:Clone();
            v14.Name = i;
            v14.Visible = false;
            v14.Letter.Text = i;
            v14.Parent = u2.Letters;
            u5[i] = v14;
        end;

        v14.Visible = v13;
        v14.Letter.TextTransparency = v.Destroyed and 0.35 or 0;

        if v13 then
            v11 = v11 or v.Destroyed;
            v12 = true;
        else
            u4[i] = nil;
        end;
    end;

    Objective.Text = v11 and "GENERATOR DESTROYED" or "GENERATOR UNDER ATTACK";

    if not v12 or u2.Visible then
        if not v12 and u2.Visible then
            u7 = u7 + 1;
            local u15 = u7;
            local v16 = TweenService:Create(Bar, TweenInfo_new_ret, {
                BackgroundTransparency = 1
            });
            TweenService:Create(Objective, TweenInfo_new_ret, {
                TextTransparency = 1
            }):Play();
            v16:Play();
            v16.Completed:Once(function() -- Line: 105
                -- upvalues: u15 (copy), u7 (ref), u2 (ref), u6 (ref)
                if u15 == u7 then
                    u2.Visible = false;

                    if u6 then
                        u6:Cancel();
                        u6 = nil;
                    end;
                end;
            end);
        end;

        return;
    end;

    u7 = u7 + 1;
    u2.Visible = true;
    Bar.BackgroundTransparency = 1;
    Objective.TextTransparency = 1;
    TweenService:Create(Bar, TweenInfo_new_ret, {
        BackgroundTransparency = 0.44
    }):Play();
    TweenService:Create(Objective, TweenInfo_new_ret, {
        TextTransparency = 0
    }):Play();

    if u6 then
        u6:Cancel();
    end;

    Glow.ImageTransparency = 0.7;
    local v17 = TweenService:Create(Glow, TweenInfo_new_ret2, {
        ImageTransparency = 0.95
    });
    v17:Play();
    u6 = v17;
end;

local function showAlert(p18: string, p19: boolean) -- Line: 118
    -- upvalues: u4 (copy), refreshAlert (copy)
    local v20 = p19 and 4 or 3;
    u4[p18] = {
        Until = os.clock() + v20,
        Destroyed = p19
    };
    refreshAlert();
    task.delay(v20 + 0.05, refreshAlert);
end;

local function onGeneratorState(p21) -- Line: 125
    -- upvalues: u3 (copy), u4 (copy), refreshAlert (copy)
    if p21.Key == "" then
        table.clear(u3);

        return;
    end;

    local v22 = u3[p21.Key];
    u3[p21.Key] = p21.Destroyed;

    if not p21.Destroyed or v22 ~= false then
        if p21.Drop > 0 and not p21.Destroyed then
            u4[p21.Key] = {
                Destroyed = false,
                Until = os.clock() + 3
            };
            refreshAlert();
            task.delay(3.05, refreshAlert);
        end;

        return;
    end;

    u4[p21.Key] = {
        Destroyed = true,
        Until = os.clock() + 4
    };
    refreshAlert();
    task.delay(4.05, refreshAlert);
end;

function v1.Initialize(p23: any, p24: userdata) -- Line: 142
    -- upvalues: u2 (ref)
    u2 = p24;
    u2.Visible = false;
end;

function v1.Start() -- Line: 147
    -- upvalues: GeneratorController (copy), onGeneratorState (copy)
    GeneratorController.Bind(onGeneratorState);
end;

return v1;