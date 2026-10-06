-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local CurrentCamera = Workspace.CurrentCamera;
local Debris = Workspace:WaitForChild("Debris");
local CaptureController = require(ReplicatedStorage.Controllers.CaptureController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Color3_new_ret = Color3.new(1, 1, 1);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.CollisionGroup = "Barriers";
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = 0;
local u15 = nil;
local u16 = Signal.new();
local u17 = Signal.new();

local function QuadTween(p18: userdata, p19: number, p20: table) -- Line: 78
    -- upvalues: TweenService (copy)
    return TweenService:Create(p18, TweenInfo.new(p19, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p20);
end;

local function CancelTweens() -- Line: 86
    -- upvalues: u4 (ref), u5 (ref)
    if u4 then
        u4:Cancel();
        u4 = nil;
    end;

    if u5 then
        u5:Cancel();
        u5 = nil;
    end;
end;

local function CancelScreenshotFade() -- Line: 98
    -- upvalues: u8 (ref)
    if u8 then
        u8:Cancel();
        u8 = nil;
    end;
end;

local function DestroyScreenshotGui() -- Line: 105
    -- upvalues: u6 (ref), u7 (ref)
    if u6 then
        u6:Destroy();
        u6 = nil;
        u7 = nil;
    end;
end;

local function FadeScreenshot(p21: userdata, p22: number) -- Line: 113
    -- upvalues: TweenService (copy), u8 (ref), u6 (ref), u7 (ref)
    local u23 = TweenService:Create(p21, TweenInfo.new(p22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 1
    });
    u8 = u23;
    u23:Play();
    u23.Completed:Connect(function() -- Line: 118
        -- upvalues: u6 (ref), u7 (ref), u8 (ref), u23 (copy)
        if u6 then
            u6:Destroy();
            u6 = nil;
            u7 = nil;
        end;

        if u8 == u23 then
            u8 = nil;
        end;
    end);
end;

local function StopFlashSound() -- Line: 126
    -- upvalues: u10 (ref), u9 (ref)
    if u10 then
        u10:Disconnect();
        u10 = nil;
    end;

    if u9 and u9.Parent then
        u9:Stop();
        u9:Destroy();
    end;

    u9 = nil;
end;

local function CleanupFlash() -- Line: 138
    -- upvalues: u4 (ref), u5 (ref), u1 (ref), u2 (ref), u3 (ref), u8 (ref), u6 (ref), u7 (ref), u11 (ref), u12 (ref), u13 (ref), u17 (copy)
    if u4 then
        u4:Cancel();
        u4 = nil;
    end;

    if u5 then
        u5:Cancel();
        u5 = nil;
    end;

    if u1 then
        u1:Destroy();
        u1 = nil;
        u2 = nil;
    end;

    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    if u8 then
        u8:Cancel();
        u8 = nil;
    end;

    if u6 then
        u6:Destroy();
        u6 = nil;
        u7 = nil;
    end;

    u11 = nil;
    u12 = nil;
    u13 = nil;
    u17:Fire();
end;

local function CreateFlashGui() -- Line: 162
    -- upvalues: Color3_new_ret (copy), PlayerGui (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "FlashbangEffect";
    ScreenGui.DisplayOrder = 999;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "FlashOverlay";
    Frame.Size = UDim2.new(1, 0, 1, 0);
    Frame.BackgroundColor3 = Color3_new_ret;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 999;
    Frame.Parent = ScreenGui;
    ScreenGui.Parent = PlayerGui;

    return ScreenGui, Frame;
end;

local function EnsureFlashInstances() -- Line: 183
    -- upvalues: u1 (ref), u2 (ref), u3 (ref), CreateFlashGui (copy), Lighting (copy)
    local v24 = u1;
    local v25 = u2;
    local v26 = u3;

    if not (v24 and v25) then
        v24, v25 = CreateFlashGui();
        u1 = v24;
        u2 = v25;
    end;

    if not v26 then
        v26 = Instance.new("ColorCorrectionEffect");
        v26.Name = "FlashbangColorCorrection";
        v26.Parent = Lighting;
        u3 = v26;
    end;

    return v24, v25, v26;
end;

local function StartDriver(p27: number) -- Line: 204
    -- upvalues: u14 (ref), u11 (ref), u12 (ref), u13 (ref), u1 (ref), u2 (ref), u3 (ref), CreateFlashGui (copy), Lighting (copy), u4 (ref), u5 (ref), u16 (copy), TweenService (copy), CleanupFlash (copy)
    task.wait(0.05);

    while u14 == p27 do
        local v28 = u11;
        local v29 = u12;
        local v30 = u13;

        if not (v28 and (v29 and v30)) then
            break;
        end;

        local os_clock_ret = os.clock();

        if v28 <= os_clock_ret then
            break;
        end;

        local v31 = u1;
        local v32 = u2;
        local v33 = u3;

        if not (v31 and v32) then
            v31, v32 = CreateFlashGui();
            u1 = v31;
            u2 = v32;
        end;

        if not v33 then
            v33 = Instance.new("ColorCorrectionEffect");
            v33.Name = "FlashbangColorCorrection";
            v33.Parent = Lighting;
            u3 = v33;
        end;

        if os_clock_ret < v29 then
            if u4 then
                u4:Cancel();
                u4 = nil;
            end;

            if u5 then
                u5:Cancel();
                u5 = nil;
            end;

            v32.BackgroundTransparency = 1 - v30;
            v33.Brightness = v30;
            v33.Saturation = -v30;
            task.wait();
        else
            local v34 = v28 - os_clock_ret;
            u16:Fire();

            if u4 then
                u4:Cancel();
                u4 = nil;
            end;

            if u5 then
                u5:Cancel();
                u5 = nil;
            end;

            u4 = TweenService:Create(v32, TweenInfo.new(v34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            });
            u5 = TweenService:Create(v33, TweenInfo.new(v34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Brightness = 0,
                Saturation = 0
            });
            u4:Play();
            u5:Play();

            while u14 == p27 do
                local os_clock_ret2 = os.clock();

                if v28 <= os_clock_ret2 or u12 and os_clock_ret2 < u12 then
                    break;
                end;

                task.wait(0.05);
            end;
        end;
    end;

    if u14 == p27 then
        CleanupFlash();
    end;
end;

local function CalculateFlashDuration(p35: vector, p36: vector, p37: number) -- Line: 266
    if p36.Magnitude <= 0 then
        return 0;
    end;

    local v38 = 3 - p37 * 0.01309090909090909;

    if v38 <= 0 then
        return 0;
    end;

    local v39 = p35:Dot(p36.Unit);
    local math_clamp_ret = math.clamp(v39, -1, 1);

    return v38 * (math_clamp_ret >= 0.6 and 2.5 or (math_clamp_ret >= 0.3 and 1.75 or (math_clamp_ret >= -0.2 and 1 or 0.5))) / 1.4;
end;

local u40 = { -0.5, 0, 0.5 };
local u41 = nil;

local function GetMapBarriers() -- Line: 295
    -- upvalues: u41 (ref), Workspace (copy)
    if u41 ~= nil and u41.Parent ~= nil then
        return u41;
    end;

    local Map = Workspace:FindFirstChild("Map");
    local v42;

    if Map then
        v42 = Map:FindFirstChild("Barriers");
    else
        v42 = nil;
    end;

    u41 = v42;

    return u41;
end;

local function HasLineOfSight(p43: vector, p44: vector) -- Line: 304
    -- upvalues: Debris (copy), CharacterResolver (copy), u41 (ref), Workspace (copy), RaycastParams_new_ret (copy), u40 (copy)
    debug.profilebegin("VFX.Flash.HasLineOfSight");
    local v45 = { Debris };
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        table.insert(v45, LocalCharacter);
    end;

    local v46;

    if u41 == nil or u41.Parent == nil then
        local Map = Workspace:FindFirstChild("Map");
        local v47;

        if Map then
            v47 = Map:FindFirstChild("Barriers");
        else
            v47 = nil;
        end;

        u41 = v47;
        v46 = u41;
    else
        v46 = u41;
    end;

    if v46 then
        table.insert(v45, v46);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v45;

    for _, v in ipairs(u40) do
        local v48 = v;

        for _, v2 in ipairs(u40) do
            local v49 = v2;

            for _, v3 in ipairs(u40) do
                local v50 = p43 + Vector3.new(v48, v49, v3);
                local v51 = p44 - v50;
                local Magnitude = v51.Magnitude;

                if Magnitude < 0.1 then
                    return true;
                end;

                local v52 = Workspace:Raycast(v50, v51, RaycastParams_new_ret);

                if not v52 or v52.Distance >= Magnitude - 0.5 then
                    debug.profileend();

                    return true;
                end;
            end;
        end;
    end;

    debug.profileend();

    return false;
end;

return {
    OnFlashRecoveryStarted = u16,
    OnFlashCleared = u17,

    Flash = function(p53: table) -- Line: 353, Name: Flash
        -- upvalues: CurrentCamera (copy), HasLineOfSight (copy), u10 (ref), u9 (ref), Sound (copy), RunServiceController (copy), u11 (ref), u15 (ref), u13 (ref), u12 (ref), u7 (ref), u8 (ref), FadeScreenshot (copy), u1 (ref), u2 (ref), u3 (ref), CreateFlashGui (copy), Lighting (copy), u4 (ref), u5 (ref), TweenService (copy), u14 (ref), StartDriver (copy), CaptureController (copy), u6 (ref), PlayerGui (copy)
        debug.profilebegin("VFX.Flash");
        local Position = p53.Position;
        local Position2 = CurrentCamera.CFrame.Position;
        local u54;

        if p53.Duration then
            u54 = p53.Duration;
        else
            local v55 = Position - Position2;
            local Magnitude = v55.Magnitude;

            if Magnitude > 229.16666666666669 or not HasLineOfSight(Position, Position2) then
                debug.profileend();

                return false;
            end;

            debug.profilebegin("VFX.Flash.CalculateDuration");
            local LookVector = CurrentCamera.CFrame.LookVector;

            if v55.Magnitude <= 0 then
                u54 = 0;
            else
                local v56 = 3 - Magnitude * 0.01309090909090909;

                if v56 <= 0 then
                    u54 = 0;
                else
                    local v57 = LookVector:Dot(v55.Unit);
                    local math_clamp_ret = math.clamp(v57, -1, 1);
                    u54 = v56 * (math_clamp_ret >= 0.6 and 2.5 or (math_clamp_ret >= 0.3 and 1.75 or (math_clamp_ret >= -0.2 and 1 or 0.5))) / 1.4;
                end;
            end;

            debug.profileend();
        end;

        if u54 < 0.01 then
            debug.profileend();

            return false;
        end;

        debug.profilebegin("VFX.Flash.Sound");

        if u10 then
            u10:Disconnect();
            u10 = nil;
        end;

        if u9 and u9.Parent then
            u9:Stop();
            u9:Destroy();
        end;

        u9 = nil;
        local u58 = Sound.new("Flashbang"):play({
            Name = "Flashed",
            Parent = CurrentCamera
        });

        if u58 then
            u9 = u58;
            local u59 = tick();
            local Volume = u58.Volume;
            u10 = RunServiceController.BindToHeartbeat("VFX.FlashEffect.SoundFade", function() -- Line: 397
                -- upvalues: u59 (copy), u58 (copy), Volume (copy), u10 (ref), u9 (ref)
                local v60 = tick() - u59;

                if v60 < 4 and u58.Parent then
                    u58.Volume = Volume * (1 - v60 * 0.225);

                    return;
                end;

                if u10 then
                    u10:Disconnect();
                    u10 = nil;
                end;

                if u58.Parent then
                    u58:Stop();
                    u58:Destroy();
                end;

                if u9 == u58 then
                    u9 = nil;
                end;
            end);
        end;

        debug.profileend();

        local function applyFlashEffect() -- Line: 422
            -- upvalues: u11 (ref), u54 (ref), u15 (ref), u13 (ref), u12 (ref), u7 (ref), u8 (ref), FadeScreenshot (ref), u1 (ref), u2 (ref), u3 (ref), CreateFlashGui (ref), Lighting (ref), u4 (ref), u5 (ref), TweenService (ref), u14 (ref), StartDriver (ref)
            debug.profilebegin("VFX.Flash.Apply");
            local os_clock_ret = os.clock();
            local v61 = u11 and (math.max(0, u11 - os_clock_ret) or 0) or 0;
            local math_max_ret = math.max(v61, u54);
            local math_max_ret2 = math.max(0, math_max_ret - 3);
            local v62 = math_max_ret > 3 and 1 or math.clamp((math_max_ret / 3) ^ 0.6, 0, 1);
            u15 = os_clock_ret;
            u11 = os_clock_ret + math_max_ret;
            u13 = v62;
            local math_max_ret3 = math.max(u12 or 0, os_clock_ret + 0.05 + math_max_ret2);
            u12 = math.min(u11, math_max_ret3);

            if u54 >= 4 and u7 then
                if u8 then
                    u8:Cancel();
                    u8 = nil;
                end;

                u7.ImageTransparency = 0;
                FadeScreenshot(u7, math_max_ret);
            end;

            local v63 = u1;
            local v64 = u2;
            local v65 = u3;

            if not (v63 and v64) then
                v63, v64 = CreateFlashGui();
                u1 = v63;
                u2 = v64;
            end;

            if not v65 then
                v65 = Instance.new("ColorCorrectionEffect");
                v65.Name = "FlashbangColorCorrection";
                v65.Parent = Lighting;
                u3 = v65;
            end;

            debug.profilebegin("VFX.Flash.Apply.CreateTweens");

            if u4 then
                u4:Cancel();
                u4 = nil;
            end;

            if u5 then
                u5:Cancel();
                u5 = nil;
            end;

            local v66 = {
                BackgroundTransparency = 1 - v62
            };
            local v67 = TweenService:Create(v64, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v66);
            local v68 = {
                Brightness = v62,
                Saturation = -v62
            };
            local v69 = TweenService:Create(v65, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v68);
            v67:Play();
            v69:Play();
            debug.profileend();
            u14 = u14 + 1;
            task.spawn(StartDriver, u14);
            debug.profileend();
        end;

        if u54 >= 4 then
            debug.profilebegin("VFX.Flash.CaptureScreenshot");
            CaptureController.CaptureScreenshot(function(p70: string) -- Line: 472
                -- upvalues: u8 (ref), u6 (ref), PlayerGui (ref), u7 (ref), u11 (ref), FadeScreenshot (ref)
                debug.profilebegin("VFX.Flash.CaptureScreenshot.Callback");

                if u8 then
                    u8:Cancel();
                    u8 = nil;
                end;

                if u6 then
                    if u7 then
                        u7.Image = p70;
                        u7.ImageTransparency = 0;
                    end;
                else
                    local ScreenGui = Instance.new("ScreenGui");
                    ScreenGui.Name = "FlashScreenshot";
                    ScreenGui.DisplayOrder = 998;
                    ScreenGui.IgnoreGuiInset = true;
                    ScreenGui.ResetOnSpawn = false;
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                    local ImageLabel = Instance.new("ImageLabel");
                    ImageLabel.Name = "ScreenshotImage";
                    ImageLabel.Size = UDim2.new(1, 0, 1, 0);
                    ImageLabel.BackgroundTransparency = 1;
                    ImageLabel.BorderSizePixel = 0;
                    ImageLabel.Image = p70;
                    ImageLabel.ScaleType = Enum.ScaleType.Fit;
                    ImageLabel.ZIndex = 998;
                    ImageLabel.Parent = ScreenGui;
                    ScreenGui.Parent = PlayerGui;
                    u6 = ScreenGui;
                    u7 = ImageLabel;
                end;

                if u7 then
                    local v71;

                    if u11 then
                        local v72 = u11 - os.clock();
                        v71 = math.max(0, v72) or 0;
                    else
                        v71 = 0;
                    end;

                    FadeScreenshot(u7, (math.max(v71, 0.01)));
                end;

                debug.profileend();
            end):catch(function() -- Line: 509
            end);
            debug.profileend();
            task.delay(0.01, applyFlashEffect);
        else
            applyFlashEffect();
        end;

        debug.profileend();

        return true;
    end,

    CancelFlash = function() -- Line: 524, Name: CancelFlash
        -- upvalues: u14 (ref), CleanupFlash (copy), u15 (ref), u10 (ref), u9 (ref)
        debug.profilebegin("VFX.Flash.Cancel");
        u14 = u14 + 1;
        CleanupFlash();
        u15 = nil;

        if u10 then
            u10:Disconnect();
            u10 = nil;
        end;

        if u9 and u9.Parent then
            u9:Stop();
            u9:Destroy();
        end;

        u9 = nil;
        debug.profileend();
    end,

    IsFlashed = function() -- Line: 535, Name: IsFlashed
        -- upvalues: u11 (ref)
        local v73;

        if u11 == nil then
            v73 = false;
        else
            v73 = os.clock() < u11;
        end;

        return v73;
    end,

    GetAudioFadeMultiplier = function() -- Line: 540, Name: GetAudioFadeMultiplier
        -- upvalues: u15 (ref)
        if not u15 then
            return 1;
        end;

        local v74 = os.clock() - u15;

        return v74 >= 1.5 and 1 or (v74 < 0.5 and 0 or math.clamp(v74 - 0.5, 0, 1));
    end
};