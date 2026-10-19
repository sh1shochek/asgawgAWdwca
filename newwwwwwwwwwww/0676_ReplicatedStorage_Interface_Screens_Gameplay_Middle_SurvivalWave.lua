-- SurvivalWave (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.SurvivalWave

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local LocalPlayer = Players.LocalPlayer;
local Sound = require(ReplicatedStorage.Classes.Sound);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local SurvivalState = require(ReplicatedStorage.Components.Common.SurvivalState);
local Color3_fromRGB_ret = Color3.fromRGB(165, 183, 212);
local Color3_fromRGB_ret2 = Color3.fromRGB(214, 41, 41);
local u2 = {
    Accent = Color3_fromRGB_ret,
    Background = Color3.fromRGB(29, 34, 45),
    Glow = Color3.fromRGB(101, 128, 170)
};
local u3 = {
    Accent = Color3_fromRGB_ret2,
    Background = Color3.fromRGB(45, 26, 26),
    Glow = Color3.fromRGB(170, 45, 45)
};
local u4 = {
    Name = "Wave Incoming",
    Drop = 3.45
};
local u5 = {
    Name = "Wave Survived",
    Drop = 0.5
};
local TweenInfo_new_ret = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
local UDim2_fromScale_ret = UDim2.fromScale(0.009, 1);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.009, 0);
local UDim2_fromScale_ret3 = UDim2.fromScale(0.7, 0.5);
local UDim2_fromScale_ret4 = UDim2.fromScale(0, 0.5);
local UDim2_fromScale_ret5 = UDim2.fromScale(0.5, 0.8);
local UDim2_fromScale_ret6 = UDim2.fromScale(0.5, 0.95);
local u6 = nil;
local u7 = nil;
local u8 = 0;
local u9 = "";
local u10 = false;

local function playSound(p11: table) -- Line: 91
    -- upvalues: u7 (ref), LocalPlayer (copy)
    local v12 = u7;

    if v12 then
        return v12:play({
            Parent = LocalPlayer.PlayerGui,
            Name = p11.Name
        });
    end;

    return nil;
end;

local function preloadStingers() -- Line: 101
    -- upvalues: u7 (ref), u10 (ref), IsSurvivalMode (copy), u4 (copy), u5 (copy), ContentProvider (copy)
    local v13 = u7;

    if u10 or not (IsSurvivalMode() and (v13 and v13.Sounds)) then
        return;
    end;

    u10 = true;
    local v14 = {};

    for _, v in { u4, u5 } do
        local v15 = v13.Sounds:FindFirstChild(v.Name);

        if v15 then
            for _, child in v15:GetChildren() do
                table.insert(v14, child);
            end;
        end;
    end;

    ContentProvider:PreloadAsync(v14);
end;

local function playStinger(p16: table) -- Line: 124
    -- upvalues: playSound (copy), u7 (ref), LocalPlayer (copy), RunService (copy)
    local v17 = p16.Drop - 0.65;

    if v17 < 0 then
        task.delay(-v17, playSound, p16);

        return;
    end;

    local v18 = u7;
    local v19;

    if v18 then
        v19 = v18:play({
            Parent = LocalPlayer.PlayerGui,
            Name = p16.Name
        });
    else
        v19 = nil;
    end;

    if not v19 then
        return;
    end;

    local os_clock_ret = os.clock();

    while os.clock() - os_clock_ret < 4 and (not v19.IsLoaded or v17 > v19.TimePosition) do
        RunService.Heartbeat:Wait();
    end;
end;

local function showBanner(p20: string, p21: string, p22: table, p23: table?) -- Line: 146
    -- upvalues: u6 (ref), u8 (ref), playStinger (copy), UDim2_fromScale_ret2 (copy), UDim2_fromScale_ret4 (copy), UDim2_fromScale_ret6 (copy), TweenService (copy), TweenInfo_new_ret (copy), UDim2_fromScale_ret (copy), UDim2_fromScale_ret3 (copy), UDim2_fromScale_ret5 (copy), TweenInfo_new_ret2 (copy)
    local Title = u6.Title;
    local Subtitle = u6.Subtitle;
    local LeftBar = u6.LeftBar;
    local RightBar = u6.RightBar;
    local UIStroke = u6.UIStroke;
    local Glow = u6.Glow;
    u8 = u8 + 1;
    local u24 = u8;

    if p23 then
        playStinger(p23);

        if u24 ~= u8 then
            return;
        end;
    end;

    Title.Text = p20;
    Title.TextColor3 = p22.Accent;
    local Accent = p22.Accent;
    LeftBar.BackgroundColor3 = p22.Accent;
    RightBar.BackgroundColor3 = Accent;
    u6.BackgroundColor3 = p22.Background;
    Glow.ImageColor3 = p22.Glow;
    Subtitle.Text = p21;

    local function holdFor(p25: number) -- Line: 165
        -- upvalues: u24 (copy), u8 (ref)
        task.wait(p25);

        return u24 == u8;
    end;

    u6.Visible = true;
    u6.BackgroundTransparency = 1;
    UIStroke.Transparency = 1;
    LeftBar.Size = UDim2_fromScale_ret2;
    RightBar.Size = UDim2_fromScale_ret2;
    Title.Size = UDim2_fromScale_ret4;
    Title.TextTransparency = 1;
    Subtitle.TextTransparency = 1;
    Subtitle.Position = UDim2_fromScale_ret6;
    TweenService:Create(LeftBar, TweenInfo_new_ret, {
        Size = UDim2_fromScale_ret
    }):Play();
    TweenService:Create(RightBar, TweenInfo_new_ret, {
        Size = UDim2_fromScale_ret
    }):Play();
    TweenService:Create(u6, TweenInfo_new_ret, {
        BackgroundTransparency = 0.35
    }):Play();
    TweenService:Create(UIStroke, TweenInfo_new_ret, {
        Transparency = 0.5
    }):Play();
    task.wait(0.2);

    if u24 ~= u8 then
        return;
    end;

    TweenService:Create(Title, TweenInfo_new_ret, {
        TextTransparency = 0,
        Size = UDim2_fromScale_ret3
    }):Play();
    task.wait(0.3);

    if u24 ~= u8 then
        return;
    end;

    TweenService:Create(Subtitle, TweenInfo_new_ret, {
        TextTransparency = 0,
        Position = UDim2_fromScale_ret5
    }):Play();
    task.wait(4);

    if u24 ~= u8 then
        return;
    end;

    TweenService:Create(Subtitle, TweenInfo_new_ret2, {
        TextTransparency = 1,
        Position = UDim2_fromScale_ret6
    }):Play();
    task.wait(0.2);

    if u24 ~= u8 then
        return;
    end;

    TweenService:Create(Title, TweenInfo_new_ret2, {
        TextTransparency = 1,
        Size = UDim2_fromScale_ret4
    }):Play();
    task.wait(0.3);

    if u24 ~= u8 then
        return;
    end;

    TweenService:Create(LeftBar, TweenInfo_new_ret2, {
        Size = UDim2_fromScale_ret2
    }):Play();
    TweenService:Create(RightBar, TweenInfo_new_ret2, {
        Size = UDim2_fromScale_ret2
    }):Play();
    TweenService:Create(UIStroke, TweenInfo_new_ret2, {
        Transparency = 1
    }):Play();
    local v26 = TweenService:Create(u6, TweenInfo_new_ret2, {
        BackgroundTransparency = 1
    });
    v26:Play();
    v26.Completed:Wait();

    if u24 == u8 then
        u6.Visible = false;
    end;
end;

local function evaluateWaveBanner() -- Line: 216
    -- upvalues: IsSurvivalMode (copy), SurvivalState (copy), GameState (copy), u9 (ref), showBanner (copy), u2 (copy), u5 (copy), u3 (copy), u4 (copy)
    if not IsSurvivalMode() then
        return;
    end;

    local Wave = SurvivalState.GetWave();
    local v27 = SurvivalState.IsResupply();

    if Wave < 1 or GameState.GetState() ~= "Round In Progress" then
        return;
    end;

    local v28 = `{Wave}:{v27}`;

    if v28 == u9 then
        return;
    end;

    u9 = v28;

    if not v27 then
        task.spawn(showBanner, `WAVE {Wave} INCOMING`, "HOLD THE GENERATORS", u3, u4);

        return;
    end;

    if Wave > 1 then
        task.spawn(showBanner, `WAVE {Wave - 1} SURVIVED`, "RESUPPLY AT A BUY STATION", u2, u5);

        return;
    end;

    task.spawn(showBanner, "RESUPPLY", "GEAR UP AT A BUY STATION", u2);
end;

function v1.Initialize(p29: any, p30: userdata) -- Line: 245
    -- upvalues: u6 (ref)
    u6 = p30;
    u6.Visible = false;
end;

function v1.Start() -- Line: 250
    -- upvalues: u7 (ref), Sound (copy), preloadStingers (copy), u9 (ref), evaluateWaveBanner (copy), SurvivalState (copy), GameState (copy)
    task.spawn(function() -- Line: 252
        -- upvalues: u7 (ref), Sound (ref), preloadStingers (ref)
        u7 = Sound.new("Survival");
        preloadStingers();
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 257
        -- upvalues: preloadStingers (ref), u9 (ref), evaluateWaveBanner (ref)
        task.spawn(preloadStingers);
        u9 = "";
        evaluateWaveBanner();
    end);
    workspace:GetAttributeChangedSignal(SurvivalState.WAVE_ATTRIBUTE):Connect(evaluateWaveBanner);
    workspace:GetAttributeChangedSignal(SurvivalState.RESUPPLY_ATTRIBUTE):Connect(evaluateWaveBanner);
    GameState.ListenToState(function() -- Line: 264
        -- upvalues: evaluateWaveBanner (ref)
        evaluateWaveBanner();

        return nil;
    end);
end;

return v1;