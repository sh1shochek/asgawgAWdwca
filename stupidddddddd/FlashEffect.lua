-- ReplicatedStorage.Components.Common.VFXLibary.FlashEffect
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.FlashEffect
-- Decompile time: 14.81 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = Workspace.CurrentCamera
local Debris = Workspace:WaitForChild("Debris")
local CaptureController = require(ReplicatedStorage.Controllers.CaptureController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Sound = require(ReplicatedStorage.Classes.Sound)
local u60 = Color3.new(1, 1, 1)
local u62 = RaycastParams.new()
u62.CollisionGroup = "Barriers"
u62.FilterType = Enum.RaycastFilterType.Exclude
u62.IgnoreWater = true
local u66 = nil
local u67 = nil
local u68 = nil
local u69 = nil
local u70 = nil
local u71 = nil
local u72 = nil
local u73 = nil
local u74 = nil
local u75 = nil
local u76 = nil
local u77 = nil
local u78 = nil
local u79 = 0
local u80 = nil
local u82 = Signal.new()
local u84 = Signal.new()

local function QuadTween(a1, a2, a3) -- Line: 78
    -- upvalues: TweenService (val)
    return TweenService:Create(a1, TweenInfo.new(a2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), a3)
end

local function CancelTweens() -- Line: 86 -- upvalues: u69 (ref), u70 (ref)
    if u69 then
        u69:Cancel()
        u69 = nil
    end
    if u70 then
        u70:Cancel()
        u70 = nil
    end
end

local function CancelScreenshotFade() -- Line: 98 -- upvalues: u73 (ref)
    if u73 then
        u73:Cancel()
        u73 = nil
    end
end

local function DestroyScreenshotGui() -- Line: 105 -- upvalues: u71 (ref), u72 (ref)
    if u71 then
        u71:Destroy()
        u71 = nil
        u72 = nil
    end
end

local function FadeScreenshot(a1, a2) -- Line: 113
    -- upvalues: TweenService (val), u73 (ref), u71 (ref), u72 (ref)
    local u14 = TweenService:Create(a1, TweenInfo.new(a2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1})
    u73 = u14
    u14:Play()
    u14.Completed:Connect(function() -- Line: 118 -- upvalues: u71 (upval), u72 (upval), u73 (upval), u14 (val)
        if u71 then
            u71:Destroy()
            u71 = nil
            u72 = nil
        end
        if u73 == u14 then
            u73 = nil
        end
    end)
end

local function StopFlashSound() -- Line: 126 -- upvalues: u75 (ref), u74 (ref)
    if u75 then
        u75:Disconnect()
        u75 = nil
    end
    if u74 and u74.Parent then
        u74:Stop()
        u74:Destroy()
    end
    u74 = nil
end

local function CleanupFlash() -- Line: 138
    -- upvalues: u69 (ref), u70 (ref), u66 (ref), u67 (ref), u68 (ref), u73 (ref), u71 (ref), u72 (ref), u76 (ref)
    -- upvalues: u77 (ref), u78 (ref), u84 (val)
    if u69 then
        u69:Cancel()
        u69 = nil
    end
    if u70 then
        u70:Cancel()
        u70 = nil
    end
    if u66 then
        u66:Destroy()
        u66 = nil
        u67 = nil
    end
    if u68 then
        u68:Destroy()
        u68 = nil
    end
    if u73 then
        u73:Cancel()
        u73 = nil
    end
    if u71 then
        u71:Destroy()
        u71 = nil
        u72 = nil
    end
    u76 = nil
    u77 = nil
    u78 = nil
    u84:Fire()
end

local function CreateFlashGui() -- Line: 162 -- upvalues: u60 (val), PlayerGui (val)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlashbangEffect"
    ScreenGui.DisplayOrder = 999
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    local Frame = Instance.new("Frame")
    Frame.Name = "FlashOverlay"
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = u60
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 999
    Frame.Parent = ScreenGui
    ScreenGui.Parent = PlayerGui
    return ScreenGui, Frame
end

local function EnsureFlashInstances() -- Line: 183
    -- upvalues: u66 (ref), u67 (ref), u68 (ref), CreateFlashGui (val), Lighting (val)
    local v1 = u66
    local v2 = u67
    local v3 = u68
    if not v1 or not v2 then
        local v4, v5 = CreateFlashGui()
        u66 = v4
        u67 = v5
    end
    if not v3 then
        v3 = Instance.new("ColorCorrectionEffect")
        v3.Name = "FlashbangColorCorrection"
        v3.Parent = Lighting
        u68 = v3
    end
    return v1, v2, v3
end

local function StartDriver(a1) -- Line: 204
    -- upvalues: u79 (ref), u76 (ref), u77 (ref), u78 (ref), u66 (ref), u67 (ref), u68 (ref), CreateFlashGui (val)
    -- upvalues: Lighting (val), u69 (ref), u70 (ref), u82 (val), TweenService (val), CleanupFlash (val)
    local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
    task.wait(0.05)
    local v12 = a1
    while u79 == v12 do
        v1 = u76
        v5 = u77
        v6 = u78
        if not v1 or not v5 or not v6 then
            break
        end
        v7 = os.clock()
        if v1 <= v7 then
            break
        end
        v10 = u66
        v11 = u67
        v2 = u68
        if not v10 or not v11 then
            v3, v4 = CreateFlashGui()
            u66 = v3
            u67 = v4
        end
        if not v2 then
            v2 = Instance.new("ColorCorrectionEffect")
            v2.Name = "FlashbangColorCorrection"
            v2.Parent = Lighting
            u68 = v2
        end
        v8 = v11
        v9 = v2
        if not (v7 < v5) then
            v10 = v1 - v7
            u82:Fire()
            if u69 then
                u69:Cancel()
                u69 = nil
            end
            if u70 then
                u70:Cancel()
                u70 = nil
            end
            u69 = TweenService:Create(v8, TweenInfo.new(v10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
            u70 = TweenService:Create(v9, TweenInfo.new(v10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Brightness = 0, Saturation = 0})
            u69:Play()
            u70:Play()
            while u79 == v12 do
                v7 = os.clock()
                if v1 <= v7 then
                    break
                end
                if u77 and v7 < u77 then
                    break
                end
                task.wait(0.05)
            end
        else
            if u69 then
                u69:Cancel()
                u69 = nil
            end
            if u70 then
                u70:Cancel()
                u70 = nil
            end
            v8.BackgroundTransparency = 1 - v6
            v9.Brightness = v6
            v9.Saturation = -v6
            task.wait()
        end
    end
    if u79 == v12 then
        CleanupFlash()
    end
end

local function CalculateFlashDuration(a1, a2, a3) -- Line: 266 -- types: a1: vector, a2: vector, a3: number
    if a2.Magnitude <= 0 then
        return 0
    end
    local v1 = 3 - a3 * 0.01309090909090909
    if v1 <= 0 then
        return 0
    end
    local v2 = math.clamp(a1:Dot(a2.Unit), -1, 1)
    local v3 = 0.5
    if v2 >= 0.6 then
        v3 = 2.5
    elseif v2 >= 0.3 then
        v3 = 1.75
    elseif v2 >= -0.2 then
        v3 = 1
    end
    return v1 * v3 / 1.4
end

local u96 = {-0.5, 0, 0.5}
local u100 = nil

local function GetMapBarriers() -- Line: 295 -- upvalues: u100 (ref), Workspace (val)
    if u100 ~= nil and u100.Parent ~= nil then
        return u100
    end
    local Map = Workspace:FindFirstChild("Map")
    u100 = if not Map then nil else Map:FindFirstChild("Barriers")
    return u100
end

local function HasLineOfSight(a1, a2) -- Line: 304
    -- upvalues: Debris (val), CharacterResolver (val), u100 (ref), Workspace (val), u62 (val), u96 (val)
    local Distance, Magnitude, v1, v2, v3
    debug.profilebegin("VFX.Flash.HasLineOfSight")
    local v4 = {Debris}
    local v5 = CharacterResolver.getLocalCharacter()
    if v5 then
        table.insert(v4, v5)
    end
    if u100 == nil or u100.Parent == nil then
        local Map = Workspace:FindFirstChild("Map")
        u100 = if not Map then nil else Map:FindFirstChild("Barriers")
    end
    local v6 = u100
    if v6 then
        table.insert(v4, v6)
    end
    u62.FilterDescendantsInstances = v4
    local v7, v8 = a1, a2
    for i, v in ipairs(u96) do
        for i2, i3 in ipairs(u96) do
            for i4, j in ipairs(u96) do
                v1 = v7 + Vector3.new(v, i3, j)
                v2 = v8 - v1
                Magnitude = v2.Magnitude
                if Magnitude < 0.1 then
                    return true
                end
                v3 = Workspace:Raycast(v1, v2, u62)
                if v3 then
                    Distance = v3.Distance
                    if not (Magnitude - 0.5 <= Distance) then
                        continue
                    end
                end
                debug.profileend()
                return true
            end
        end
    end
    debug.profileend()
    return false
end

return {
    OnFlashRecoveryStarted = u82,
    OnFlashCleared = u84,
    Flash = function(a1) -- Line: 353
        -- upvalues: CurrentCamera (val), HasLineOfSight (val), u75 (ref), u74 (ref), Sound (val)
        -- upvalues: RunServiceController (val), u76 (ref), u80 (ref), u78 (ref), u77 (ref), u72 (ref), u73 (ref)
        -- upvalues: FadeScreenshot (val), u66 (ref), u67 (ref), u68 (ref), CreateFlashGui (val), Lighting (val)
        -- upvalues: u69 (ref), u70 (ref), TweenService (val), u79 (ref), StartDriver (val), CaptureController (val)
        -- upvalues: u71 (ref), PlayerGui (val)
        local Duration, Volume, applyFlashEffect, u87, u89
        debug.profilebegin("VFX.Flash")
        local Position = a1.Position
        local Position_2 = CurrentCamera.CFrame.Position
        if a1.Duration then
            Duration = a1.Duration
            if Duration < 0.01 then
                debug.profileend()
                return false
            end
            debug.profilebegin("VFX.Flash.Sound")
            if u75 then
                u75:Disconnect()
                u75 = nil
            end
            if u74 and u74.Parent then
                u74:Stop()
                u74:Destroy()
            end
            u74 = nil
            u87 = (Sound.new("Flashbang")):play({Name = "Flashed", Parent = CurrentCamera})
            if u87 then
                u74 = u87
                u89 = tick()
                Volume = u87.Volume
                u75 = RunServiceController.BindToHeartbeat("VFX.FlashEffect.SoundFade", function() -- Line: 397 -- upvalues: u89 (val), u87 (val), Volume (val), u75 (upval), u74 (upval)
                    local v1 = tick() - u89
                    if v1 < 4 and u87.Parent then
                        u87.Volume = Volume * (1 - v1 * 0.225)
                        return
                    end
                    if u75 then
                        u75:Disconnect()
                        u75 = nil
                    end
                    if u87.Parent then
                        u87:Stop()
                        u87:Destroy()
                    end
                    if u74 == u87 then
                        u74 = nil
                    end
                end)
            end
            debug.profileend()

            function applyFlashEffect() -- Line: 422
                -- upvalues: u76 (upval), Duration (ref), u80 (upval), u78 (upval), u77 (upval), u72 (upval)
                -- upvalues: u73 (upval), FadeScreenshot (upval), u66 (upval), u67 (upval), u68 (upval)
                -- upvalues: CreateFlashGui (upval), Lighting (upval), u69 (upval), u70 (upval), TweenService (upval)
                -- upvalues: u79 (upval), StartDriver (upval)
                debug.profilebegin("VFX.Flash.Apply")
                local v1 = os.clock()
                local v2 = math.max(u76 and math.max(0, u76 - v1) or 0, Duration)
                local v3 = math.max(0, v2 - 3)
                local v4 = if not (v2 > 3) then math.clamp((v2 / 3) ^ 0.6, 0, 1) else 1
                u80 = v1
                u76 = v1 + v2
                u78 = v4
                local v5 = v1 + 0.05 + v3
                u77 = math.min(u76, (math.max(u77 or 0, v5)))
                if Duration >= 4 and u72 then
                    if u73 then
                        u73:Cancel()
                        u73 = nil
                    end
                    u72.ImageTransparency = 0
                    FadeScreenshot(u72, v2)
                end
                local v6 = u67
                local v7 = u68
                if not u66 or not v6 then
                    local v8, v9 = CreateFlashGui()
                    u66 = v8
                    u67 = v9
                end
                if not v7 then
                    v7 = Instance.new("ColorCorrectionEffect")
                    v7.Name = "FlashbangColorCorrection"
                    v7.Parent = Lighting
                    u68 = v7
                end
                local v10 = v6
                local v11 = v7
                debug.profilebegin("VFX.Flash.Apply.CreateTweens")
                if u69 then
                    u69:Cancel()
                    u69 = nil
                end
                if u70 then
                    u70:Cancel()
                    u70 = nil
                end
                v6 = {BackgroundTransparency = 1 - v4}
                local v12 = TweenService:Create(v10, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v6)
                v7 = {Brightness = v4, Saturation = -v4}
                v6 = TweenService:Create(v11, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v7)
                v12:Play()
                v6:Play()
                debug.profileend()
                u79 = u79 + 1
                task.spawn(StartDriver, u79)
                debug.profileend()
            end

            if not (Duration >= 4) then
                applyFlashEffect()
            else
                debug.profilebegin("VFX.Flash.CaptureScreenshot")
                CaptureController.CaptureScreenshot(function(a1) -- Line: 472
                    -- upvalues: u73 (upval), u71 (upval), PlayerGui (upval), u72 (upval), u76 (upval)
                    -- upvalues: FadeScreenshot (upval)
                    debug.profilebegin("VFX.Flash.CaptureScreenshot.Callback")
                    if u73 then
                        u73:Cancel()
                        u73 = nil
                    end
                    if not u71 then
                        local ScreenGui = Instance.new("ScreenGui")
                        ScreenGui.Name = "FlashScreenshot"
                        ScreenGui.DisplayOrder = 998
                        ScreenGui.IgnoreGuiInset = true
                        ScreenGui.ResetOnSpawn = false
                        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        local ImageLabel = Instance.new("ImageLabel")
                        ImageLabel.Name = "ScreenshotImage"
                        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
                        ImageLabel.BackgroundTransparency = 1
                        ImageLabel.BorderSizePixel = 0
                        ImageLabel.Image = a1
                        ImageLabel.ScaleType = Enum.ScaleType.Fit
                        ImageLabel.ZIndex = 998
                        ImageLabel.Parent = ScreenGui
                        ScreenGui.Parent = PlayerGui
                        u71 = ScreenGui
                        u72 = ImageLabel
                    elseif u72 then
                        u72.Image = a1
                        u72.ImageTransparency = 0
                    end
                    if u72 then
                        local v1 = u76 and math.max(0, u76 - (os.clock())) or 0
                        FadeScreenshot(u72, (math.max(v1, 0.01)))
                    end
                    debug.profileend()
                end):catch(function() end)
                debug.profileend()
                task.delay(0.01, applyFlashEffect)
            end
            debug.profileend()
            return true
        end
        local v1 = Position - Position_2
        local Magnitude = v1.Magnitude
        if not (Magnitude > 229.16666666666669) and HasLineOfSight(Position, Position_2) then
            debug.profilebegin("VFX.Flash.CalculateDuration")
            local LookVector = CurrentCamera.CFrame.LookVector
            if not (v1.Magnitude <= 0) then
                local v2 = 3 - Magnitude * 0.01309090909090909
                if not (v2 <= 0) then
                    local v3 = math.clamp(LookVector:Dot(v1.Unit), -1, 1)
                    local v4 = 0.5
                    if v3 >= 0.6 then
                        v4 = 2.5
                    elseif v3 >= 0.3 then
                        v4 = 1.75
                    elseif v3 >= -0.2 then
                        v4 = 1
                    end
                    Duration = v2 * v4 / 1.4
                else
                    Duration = 0
                end
            else
                Duration = 0
            end
            debug.profileend()
            if Duration < 0.01 then
                debug.profileend()
                return false
            end
            debug.profilebegin("VFX.Flash.Sound")
            if u75 then
                u75:Disconnect()
                u75 = nil
            end
            if u74 and u74.Parent then
                u74:Stop()
                u74:Destroy()
            end
            u74 = nil
            u87 = (Sound.new("Flashbang")):play({Name = "Flashed", Parent = CurrentCamera})
            if u87 then
                u74 = u87
                u89 = tick()
                Volume = u87.Volume
                u75 = RunServiceController.BindToHeartbeat("VFX.FlashEffect.SoundFade", function() -- Line: 397 -- upvalues: u89 (val), u87 (val), Volume (val), u75 (upval), u74 (upval)
                    local v1 = tick() - u89
                    if v1 < 4 and u87.Parent then
                        u87.Volume = Volume * (1 - v1 * 0.225)
                        return
                    end
                    if u75 then
                        u75:Disconnect()
                        u75 = nil
                    end
                    if u87.Parent then
                        u87:Stop()
                        u87:Destroy()
                    end
                    if u74 == u87 then
                        u74 = nil
                    end
                end)
            end
            debug.profileend()

            function applyFlashEffect() -- Line: 422
                -- upvalues: u76 (upval), Duration (ref), u80 (upval), u78 (upval), u77 (upval), u72 (upval)
                -- upvalues: u73 (upval), FadeScreenshot (upval), u66 (upval), u67 (upval), u68 (upval)
                -- upvalues: CreateFlashGui (upval), Lighting (upval), u69 (upval), u70 (upval), TweenService (upval)
                -- upvalues: u79 (upval), StartDriver (upval)
                debug.profilebegin("VFX.Flash.Apply")
                local v1 = os.clock()
                local v2 = math.max(u76 and math.max(0, u76 - v1) or 0, Duration)
                local v3 = math.max(0, v2 - 3)
                local v4 = if not (v2 > 3) then math.clamp((v2 / 3) ^ 0.6, 0, 1) else 1
                u80 = v1
                u76 = v1 + v2
                u78 = v4
                local v5 = v1 + 0.05 + v3
                u77 = math.min(u76, (math.max(u77 or 0, v5)))
                if Duration >= 4 and u72 then
                    if u73 then
                        u73:Cancel()
                        u73 = nil
                    end
                    u72.ImageTransparency = 0
                    FadeScreenshot(u72, v2)
                end
                local v6 = u67
                local v7 = u68
                if not u66 or not v6 then
                    local v8, v9 = CreateFlashGui()
                    u66 = v8
                    u67 = v9
                end
                if not v7 then
                    v7 = Instance.new("ColorCorrectionEffect")
                    v7.Name = "FlashbangColorCorrection"
                    v7.Parent = Lighting
                    u68 = v7
                end
                local v10 = v6
                local v11 = v7
                debug.profilebegin("VFX.Flash.Apply.CreateTweens")
                if u69 then
                    u69:Cancel()
                    u69 = nil
                end
                if u70 then
                    u70:Cancel()
                    u70 = nil
                end
                v6 = {BackgroundTransparency = 1 - v4}
                local v12 = TweenService:Create(v10, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v6)
                v7 = {Brightness = v4, Saturation = -v4}
                v6 = TweenService:Create(v11, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v7)
                v12:Play()
                v6:Play()
                debug.profileend()
                u79 = u79 + 1
                task.spawn(StartDriver, u79)
                debug.profileend()
            end

            if not (Duration >= 4) then
                applyFlashEffect()
            else
                debug.profilebegin("VFX.Flash.CaptureScreenshot")
                CaptureController.CaptureScreenshot(function(a1) -- Line: 472
                    -- upvalues: u73 (upval), u71 (upval), PlayerGui (upval), u72 (upval), u76 (upval)
                    -- upvalues: FadeScreenshot (upval)
                    debug.profilebegin("VFX.Flash.CaptureScreenshot.Callback")
                    if u73 then
                        u73:Cancel()
                        u73 = nil
                    end
                    if not u71 then
                        local ScreenGui = Instance.new("ScreenGui")
                        ScreenGui.Name = "FlashScreenshot"
                        ScreenGui.DisplayOrder = 998
                        ScreenGui.IgnoreGuiInset = true
                        ScreenGui.ResetOnSpawn = false
                        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                        local ImageLabel = Instance.new("ImageLabel")
                        ImageLabel.Name = "ScreenshotImage"
                        ImageLabel.Size = UDim2.new(1, 0, 1, 0)
                        ImageLabel.BackgroundTransparency = 1
                        ImageLabel.BorderSizePixel = 0
                        ImageLabel.Image = a1
                        ImageLabel.ScaleType = Enum.ScaleType.Fit
                        ImageLabel.ZIndex = 998
                        ImageLabel.Parent = ScreenGui
                        ScreenGui.Parent = PlayerGui
                        u71 = ScreenGui
                        u72 = ImageLabel
                    elseif u72 then
                        u72.Image = a1
                        u72.ImageTransparency = 0
                    end
                    if u72 then
                        local v1 = u76 and math.max(0, u76 - (os.clock())) or 0
                        FadeScreenshot(u72, (math.max(v1, 0.01)))
                    end
                    debug.profileend()
                end):catch(function() end)
                debug.profileend()
                task.delay(0.01, applyFlashEffect)
            end
            debug.profileend()
            return true
        end
        debug.profileend()
        return false
    end,
    CancelFlash = function() -- Line: 524 -- upvalues: u79 (ref), CleanupFlash (val), u80 (ref), u75 (ref), u74 (ref)
        debug.profilebegin("VFX.Flash.Cancel")
        u79 = u79 + 1
        CleanupFlash()
        u80 = nil
        if u75 then
            u75:Disconnect()
            u75 = nil
        end
        if u74 and u74.Parent then
            u74:Stop()
            u74:Destroy()
        end
        u74 = nil
        debug.profileend()
    end,
    IsFlashed = function() -- Line: 535 -- upvalues: u76 (ref)
        local v1 = false
        if u76 ~= nil then
            v1 = os.clock() < u76
        end
        return v1
    end,
    GetAudioFadeMultiplier = function() -- Line: 540 -- upvalues: u80 (ref)
        if not u80 then
            return 1
        end
        local v1 = os.clock() - u80
        if v1 >= 1.5 then
            return 1
        end
        if v1 < 0.5 then
            return 0
        end
        return (math.clamp(v1 - 0.5, 0, 1))
    end,
}