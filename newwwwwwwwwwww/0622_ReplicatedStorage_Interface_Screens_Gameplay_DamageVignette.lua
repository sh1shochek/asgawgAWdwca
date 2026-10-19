-- DamageVignette (ModuleScript)
-- full path: ReplicatedStorage.Interface.Screens.Gameplay.DamageVignette

-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local SoundService = game:GetService("SoundService");
local Lighting = game:GetService("Lighting");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local HudTarget = require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Ammo.HudTarget);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Sound = require(ReplicatedStorage.Classes.Sound);
local u2 = require(ReplicatedStorage.Shared.Janitor).new();
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_fromRGB_ret = Color3.fromRGB(255, 185, 185);
local u3 = false;
local u4 = nil;
local u5 = 0;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = 0;
local u10 = 1;
local u11 = nil;
local u12 = nil;
local u13 = (-1 / 0);
local u14 = 1;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;

local function smoothstep(p20: number, p21: number, p22: number) -- Line: 109
    local math_clamp_ret = math.clamp((p22 - p20) / (p21 - p20), 0, 1);

    return math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2);
end;

local function levelForRatio(p23: number) -- Line: 114
    return math.clamp((0.8 - p23) / 0.7000000000000001, 0, 1);
end;

local function getColorCorrection() -- Line: 119
    -- upvalues: u18 (ref), Lighting (copy)
    local v24 = u18;

    if v24 and v24.Parent == Lighting then
        return v24;
    end;

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "DamageColorCorrection";
    ColorCorrectionEffect.Parent = Lighting;
    u18 = ColorCorrectionEffect;

    return ColorCorrectionEffect;
end;

local function createLayer(p25: string, p26: string, p27: number) -- Line: 131
    -- upvalues: u15 (ref)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = p25;
    ImageLabel.Image = p26;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.ScaleType = Enum.ScaleType.Stretch;
    ImageLabel.Active = false;
    ImageLabel.ZIndex = p27;
    ImageLabel.Parent = u15;

    return ImageLabel;
end;

local function playHitSound() -- Line: 148
    -- upvalues: u4 (ref), LocalPlayer (copy), u12 (ref), u13 (ref)
    local os_clock_ret = os.clock();

    if u4 ~= LocalPlayer or (not u12 or os_clock_ret - u13 < 0.08) then
        return;
    end;

    u13 = os_clock_ret;
    u12:playOneTime({
        Name = "Blood Splatter",
        Parent = LocalPlayer.PlayerGui
    }, 0.7);
end;

local function setAudio(p28: number) -- Line: 157
    -- upvalues: u19 (ref), u14 (ref)
    if p28 > 0.002 then
        u19.Volume = p28 * 0.9 * u14;
        u19.PlaybackSpeed = p28 * 0.3 + 1;

        if not u19.IsPlaying then
            u19:Play();
        end;
    elseif u19.IsPlaying then
        u19:Stop();
    end;
end;

local function stopUpdating() -- Line: 171
    -- upvalues: u11 (ref), u16 (ref), u17 (ref), u18 (ref), Lighting (copy), u19 (ref)
    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    u16.ImageTransparency = 1;
    u17.ImageTransparency = 1;
    local v29 = u18;

    if v29 and v29.Parent == Lighting then
        v29.Enabled = false;
    end;

    if u19.IsPlaying then
        u19:Stop();
    end;
end;

local function update(p30: number) -- Line: 185
    -- upvalues: u8 (ref), u7 (ref), u6 (ref), u11 (ref), u16 (ref), u17 (ref), u18 (ref), Lighting (copy), u19 (ref), u9 (ref), u4 (ref), LocalPlayer (copy), SurvivalDowned (copy), u10 (ref), Color3_new_ret (copy), Color3_fromRGB_ret (copy), u14 (ref)
    u8 = u8 * math.exp(p30 * -3.2);

    if u7 < u6 then
        u7 = math.min(u6, u7 + p30 * 8);
    else
        u7 = math.max(u6, u7 - p30 * 1.2);
    end;

    if u7 < 0.002 and (u8 < 0.002 and u6 <= 0) then
        u7 = 0;
        u8 = 0;

        if u11 then
            u11:Disconnect();
            u11 = nil;
        end;

        u16.ImageTransparency = 1;
        u17.ImageTransparency = 1;
        local v31 = u18;

        if v31 and v31.Parent == Lighting then
            v31.Enabled = false;
        end;

        if u19.IsPlaying then
            u19:Stop();
        end;

        return;
    end;

    local v32;

    if u6 > 0 then
        local math_clamp_ret = math.clamp((u7 - 0.5) / 0.44999999999999996, 0, 1);
        v32 = math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2);
    else
        v32 = 0;
    end;

    local v33;

    if v32 > 0 then
        u9 = u9 + p30 * 1.6 * (v32 * 0.3 + 1);
        v33 = v32 * 0.15 * (math.cos(u9 * 2 * 3.141592653589793) * 0.5 + 0.5) ^ 6;
    else
        v33 = 0;
    end;

    local v34 = u4 == LocalPlayer;
    local v35;

    if v34 then
        v35 = SurvivalDowned.IsDowned(LocalPlayer);
    else
        v35 = v34;
    end;

    local v36 = p30 * 2.5;
    local v37;

    if v35 then
        v37 = math.max(0, u10 - v36);
    else
        v37 = math.min(1, u10 + v36);
    end;

    u10 = v37;
    local math_min_ret = math.min(1, u7 * 0.8 + u8 * 0.85 + v33);
    u16.ImageTransparency = 1 - math.clamp(u7 * 0.85 + u8 + v33, 0, 0.95) * u10;
    local v38 = 1.45 - math_min_ret * 0.44999999999999996;
    u16.Size = UDim2.fromScale(v38, v38);
    u17.ImageTransparency = 1 - math.clamp(u7 * 0.6 + v33 * 0.5, 0, 0.8) * u10;
    local v39 = 1.5 - u7 * 0.5;
    u17.Size = UDim2.fromScale(v39, v39);
    local v40 = u18;

    if not v40 or v40.Parent ~= Lighting then
        v40 = Instance.new("ColorCorrectionEffect");
        v40.Name = "DamageColorCorrection";
        v40.Parent = Lighting;
        u18 = v40;
    end;

    v40.Enabled = u10 > 0;
    v40.Saturation = -(u7 * 0.6 + u8 * 0.25) * u10;
    v40.Contrast = u7 * 0.08 * u10;
    v40.TintColor = Color3_new_ret:Lerp(Color3_fromRGB_ret, math.clamp(u8 * 0.4 + u7 * 0.15 + v33, 0, 1) * u10);
    local v41 = not v34 and 0 or v32;

    if v41 > 0.002 then
        u19.Volume = v41 * 0.9 * u14;
        u19.PlaybackSpeed = v41 * 0.3 + 1;

        if not u19.IsPlaying then
            u19:Play();
        end;
    elseif u19.IsPlaying then
        u19:Stop();
    end;
end;

local function startUpdating() -- Line: 233
    -- upvalues: u11 (ref), RunServiceController (copy), update (copy)
    if not u11 then
        u11 = RunServiceController.BindToHeartbeat("UI.DamageVignette.Update", update);
    end;
end;

local function readHealth(p42: userdata) -- Line: 239
    local Attribute = p42:GetAttribute("Health");
    local Attribute2 = p42:GetAttribute("MaxHealth");

    if typeof(Attribute) == "number" and (typeof(Attribute2) == "number" and Attribute2 > 0) then
        return math.max(Attribute, 0), Attribute2;
    end;

    return nil, nil;
end;

local function onHealthChanged(p43: userdata) -- Line: 248
    -- upvalues: u5 (ref), u3 (ref), u8 (ref), playHitSound (copy), u6 (ref), u7 (ref), u11 (ref), RunServiceController (copy), update (copy)
    local Attribute = p43:GetAttribute("Health");
    local Attribute2 = p43:GetAttribute("MaxHealth");
    local v44;

    if typeof(Attribute) == "number" and (typeof(Attribute2) == "number" and Attribute2 > 0) then
        v44 = math.max(Attribute, 0);
    else
        v44 = nil;
        Attribute2 = nil;
    end;

    if not (v44 and Attribute2) then
        return;
    end;

    if v44 < u5 and u3 then
        local math_max_ret = math.max(u8, 0.45 + (u5 - v44) / Attribute2 * 100 * 0.012);
        u8 = math.min(1, math_max_ret);
        playHitSound();
    end;

    u5 = v44;
    u6 = (not u3 or v44 <= 0) and 0 or math.clamp((0.8 - v44 / Attribute2) / 0.7000000000000001, 0, 1);

    if not (u6 <= 0 and (u8 <= 0 and u7 <= 0) or u11) then
        u11 = RunServiceController.BindToHeartbeat("UI.DamageVignette.Update", update);
    end;
end;

local function trackPlayer(u45: userdata) -- Line: 269
    -- upvalues: u2 (copy), u4 (ref), u5 (ref), u6 (ref), u3 (ref), u7 (ref), u8 (ref), onHealthChanged (copy), u11 (ref), RunServiceController (copy), update (copy), u16 (ref), u17 (ref), u18 (ref), Lighting (copy), u19 (ref)
    u2:Cleanup();
    u4 = u45;
    local Attribute = u45:GetAttribute("Health");
    local Attribute2 = u45:GetAttribute("MaxHealth");
    local v46;

    if typeof(Attribute) == "number" and (typeof(Attribute2) == "number" and Attribute2 > 0) then
        v46 = math.max(Attribute, 0);
    else
        v46 = nil;
        Attribute2 = nil;
    end;

    u5 = v46 or 0;
    u6 = not (u3 and (v46 and (Attribute2 and v46 > 0))) and 0 or math.clamp((0.8 - v46 / Attribute2) / 0.7000000000000001, 0, 1);
    u7 = u6;
    u8 = 0;

    local function onChanged() -- Line: 279
        -- upvalues: onHealthChanged (ref), u45 (copy)
        onHealthChanged(u45);
    end;

    u2:Add(u45:GetAttributeChangedSignal("Health"):Connect(onChanged));
    u2:Add(u45:GetAttributeChangedSignal("MaxHealth"):Connect(onChanged));

    if u7 > 0 then
        if not u11 then
            u11 = RunServiceController.BindToHeartbeat("UI.DamageVignette.Update", update);
        end;

        update(0);

        return;
    end;

    if u11 then
        u11:Disconnect();
        u11 = nil;
    end;

    u16.ImageTransparency = 1;
    u17.ImageTransparency = 1;
    local v47 = u18;

    if v47 and v47.Parent == Lighting then
        v47.Enabled = false;
    end;

    if u19.IsPlaying then
        u19:Stop();
    end;
end;

function v1.Initialize(p48: any, p49: userdata) -- Line: 296
    -- upvalues: u15 (ref), u17 (ref), createLayer (copy), u16 (ref), u19 (ref), SoundService (copy)
    u15 = p49;
    u15.Visible = true;
    u15.Active = false;
    u17 = createLayer("Dark", "rbxassetid://94360891669754", 1);
    u16 = createLayer("Red", "rbxassetid://118658715240881", 2);
    u19 = Instance.new("Sound");
    u19.Name = "LowHealthHeartbeat";
    u19.SoundId = "rbxassetid://9043365842";
    u19.Looped = true;
    u19.Volume = 0;
    u19.Parent = SoundService;
end;

function v1.Start() -- Line: 311
    -- upvalues: ContentProvider (copy), u16 (ref), u17 (ref), u19 (ref), u12 (ref), Sound (copy), u14 (ref), DataController (copy), LocalPlayer (copy), u3 (ref), IsSurvivalMode (copy), u4 (ref), trackPlayer (copy), HudTarget (copy)
    task.spawn(function() -- Line: 313
        -- upvalues: ContentProvider (ref), u16 (ref), u17 (ref), u19 (ref)
        ContentProvider:PreloadAsync({ u16, u17, u19 });
    end);
    task.spawn(function() -- Line: 317
        -- upvalues: u12 (ref), Sound (ref)
        u12 = Sound.new("Bullet");
    end);
    u14 = (tonumber(DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume")) or 100) / 100;
    DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p50) -- Line: 322
        -- upvalues: u14 (ref)
        u14 = (tonumber(p50) or 100) / 100;
    end);
    u3 = IsSurvivalMode();
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 328
        -- upvalues: u3 (ref), IsSurvivalMode (ref), u4 (ref), trackPlayer (ref)
        u3 = IsSurvivalMode();

        if u4 then
            trackPlayer(u4);
        end;
    end);
    HudTarget.Follow(trackPlayer);
end;

return v1;