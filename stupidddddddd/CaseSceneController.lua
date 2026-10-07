-- ReplicatedStorage.Controllers.CaseSceneController
-- Script path: ReplicatedStorage.Controllers.CaseSceneController
-- Decompile time: 21.36 ms

local u0 = {}
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MainGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui", (1 / 0))
local SceneRegistry = require(script:WaitForChild("SceneRegistry"))
local ConsoleBoardAnimator = require(script:WaitForChild("ConsoleBoardAnimator"))
require(ReplicatedStorage.Database.Custom.ConsoleTypes)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local SceneParking = require(ReplicatedStorage.Components.Common.SceneParking)
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Router = require(ReplicatedStorage.Database.Security.Router)
local MenuState = require(ReplicatedStorage.Interface.MenuState)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local CurrentCamera = workspace.CurrentCamera
local u102 = false
local u103 = {}
local u104 = nil
local u105 = nil
local u106 = nil
local u108 = Janitor.new()
local u109 = false
local u110 = nil
local u111 = {}
local u112 = false
local u113 = nil
local u114 = nil
local u115 = 0
local u116 = nil
local u117 = {}
local u118 = nil
local u119 = nil

local function DebugLog(...) end

local u121 = false
local u122 = nil
local u123 = nil
local u124 = nil
local u125 = 0
local u126 = 1
local u127 = 0
local u128 = nil
local u129 = false
local u130 = false

local function getSceneSound(a1, a2) -- Line: 107 -- upvalues: u106 (ref) -- types: a1: string, a2: string
    local Sounds = u106 and u106.Sounds
    return Sounds and Sounds[a1] or a2
end

local function getDragSettings() -- Line: 112 -- upvalues: u106 (ref)
    return u106 and u106.DragSettings
end

local function clearConsoleOpeningState() -- Line: 116 -- upvalues: u118 (ref), u108 (val)
    if u118 then
        u108:Remove("ConsoleAnimator")
        u118 = nil
    end
end

local function hideMenuFrames() -- Line: 123 -- upvalues: MenuState (val), u102 (ref), MenuSceneController (val)
    MenuState.EnterCaseScene()
    local v1 = MenuState.GetMenuFrame()
    if not v1 then
        return
    end
    u102 = MenuSceneController.IsActive()
    if u102 then
        MenuSceneController.HideMenuScene(true, true)
        MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5)
    end
    MenuState.SetBlurEnabled(false)
    v1.BackgroundTransparency = 1
    local Pattern = v1:FindFirstChild("Pattern")
    if Pattern then
        Pattern.Visible = false
    end
    local Top = v1:FindFirstChild("Top")
    if Top then
        Top.Visible = false
    end
    local Store = v1:FindFirstChild("Store")
    if Store then
        Store.Visible = true
    end
    for i, j in v1:GetChildren() do
        if j:IsA("Frame") and j.Name ~= "Top" and j.Name ~= "Store" and j.Name ~= "OpenCase" then
            j.Visible = false
        end
    end
end

local function hideViewmodel(a1) -- Line: 166 -- upvalues: u111 (ref) -- types: a1: userdata
    local Transparency
    for i, j in a1:GetDescendants() do
        if j:IsA("BasePart") then
            if j.Transparency < 1 then
                Transparency = j.Transparency
                j:SetAttribute("_CaseScenePrevTransparency", Transparency)
                j.Transparency = 1
            end
        elseif not j:IsA("Texture") then
            if j:IsA("SurfaceGui") and j.Enabled then
                j:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", true)
                j.Enabled = false
            end
        elseif j.Transparency < 1 then
            Transparency = j.Transparency
            j:SetAttribute("_CaseScenePrevTransparency", Transparency)
            j.Transparency = 1
        end
    end
    table.insert(u111, a1)
end

local function hideViewmodels() -- Line: 184
    -- upvalues: u111 (ref), u106 (ref), CurrentCamera (val), hideViewmodel (val)
    u111 = {}
    local AssetFolder = u106 and u106.AssetFolder or nil
    for i, j in CurrentCamera:GetChildren() do
        if j:IsA("Model") and j.Name ~= AssetFolder then
            hideViewmodel(j)
        end
    end
end

local function showViewmodels() -- Line: 194 -- upvalues: u111 (ref)
    local Attribute
    local v1 = nil
    local v2 = nil
    for i, j in u111, v1, v2 do
        if j and j.Parent then
            for k, n in j:GetDescendants() do
                if n:IsA("BasePart") or n:IsA("Texture") then
                    Attribute = n:GetAttribute("_CaseScenePrevTransparency")
                    if Attribute ~= nil then
                        n.Transparency = Attribute
                        n:SetAttribute("_CaseScenePrevTransparency", nil)
                    elseif n:IsA("Texture") then
                        n.Transparency = 0.3
                    end
                elseif n:IsA("SurfaceGui") and n:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") ~= nil then
                    n.Enabled = true
                    n:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil)
                end
            end
        end
    end
    u111 = {}
end

local function applyCaseFog(a1) -- Line: 220 -- upvalues: Lighting (val) -- types: a1: userdata
    local CaseFog = a1:FindFirstChild("CaseFog", true)
    if CaseFog and CaseFog:IsA("Atmosphere") then
        for i, j in Lighting:GetChildren() do
            if j:IsA("Atmosphere") then
                j:Destroy()
            end
        end
        local v1 = CaseFog:Clone()
        v1.Parent = Lighting
        return
    end
end

local function restoreLightingAfterSkippedFrameRestore() -- Line: 235 -- upvalues: MenuSceneController (val), u102 (ref)
    if workspace:FindFirstChild("Map") then
        MenuSceneController.ApplyMapLighting()
        return
    end
    if u102 then
        MenuSceneController.ApplyMenuSceneLighting()
    end
end

local function restoreMenuFrames() -- Line: 246 -- upvalues: MenuState (val), u102 (ref), MenuSceneController (val)
    local v1 = MenuState.GetMenuFrame()
    if v1 and v1.Visible then
        local Pattern, v2
        local v3 = MenuState.GetScreenBeforeCaseScene()
        local v4 = u102
        u102 = false
        MenuState.ExitCaseScene()
        if not v4 then
            MenuSceneController.ApplyMapLighting()
        else
            MenuSceneController.ShowMenuScene()
            MenuSceneController.SetMusicVolumeMultiplier(1, 0.5)
        end
        local Top = v1:FindFirstChild("Top")
        if Top then
            Top.Visible = true
        end
        local v5 = v1:FindFirstChild(v3 or "Dashboard")
        if v5 then
            v5.Visible = true
            v2 = false
            if v3 ~= nil then
                v2 = false
                if v3 ~= "Dashboard" then
                    v2 = v3 ~= "Play"
                end
            end
            MenuState.SetBlurEnabled(v2)
            v1.BackgroundTransparency = if not v2 then 1 else 0.15
            Pattern = v1:FindFirstChild("Pattern")
            if Pattern then
                Pattern.Visible = not v2
            end
            return
        end
        if v3 then
            return
        end
        v2 = false
        if v3 ~= nil then
            v2 = false
            if v3 ~= "Dashboard" then
                v2 = v3 ~= "Play"
            end
        end
        MenuState.SetBlurEnabled(v2)
        v1.BackgroundTransparency = if not v2 then 1 else 0.15
        Pattern = v1:FindFirstChild("Pattern")
        if Pattern then
            Pattern.Visible = not v2
        end
        return
    end
    u102 = false
    MenuState.ExitCaseScene()
    MenuSceneController.ApplyMapLighting()
end

local function cleanupCaseModel(a1) -- Line: 295 -- types: a1: userdata
    local CaseMod = a1:FindFirstChild("CaseMod")
    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy()
    end
end

local function setupCaseModel(a1, a2) -- Line: 305
    -- upvalues: ReplicatedStorage (val)
    local CaseMod = a1:FindFirstChild("CaseMod")
    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy()
    end
    local CaseModels = ReplicatedStorage.Assets:FindFirstChild("CaseModels")
    if not CaseModels then
        warn("[CaseSceneController]: CaseModels folder not found in ReplicatedStorage.Assets")
        return nil
    end
    local v1 = CaseModels:FindFirstChild(a2)
    if not v1 then
        warn("[CaseSceneController]: Case model not found for case: " .. a2)
        return nil
    end
    local v2 = v1:Clone()
    v2.Name = "CaseMod"
    v2:SetAttribute("IsDynamicModel", true)
    local CasePivot = a1:FindFirstChild("CasePivot")
    if not CasePivot then
        warn("[CaseSceneController]: CasePivot not found in CaseScene")
    else
        v2:PivotTo(CasePivot.CFrame)
    end
    v2.Parent = a1
    return v2
end

local function getCameraPosition(a1) -- Line: 337 -- upvalues: u104 (ref) -- types: a1: string?
    local Camera = u104 and u104:FindFirstChild("Camera")
    if not Camera then
        return nil
    end
    if a1 ~= "Inspecting" and a1 ~= "Unboxing" then
        return nil
    end
    return (Camera:FindFirstChild(a1))
end

local function startCameraLerp(a1, a2) -- Line: 347
    -- upvalues: u110 (ref), u104 (ref), u112 (ref), u113 (ref), CurrentCamera (val), u114 (ref), u115 (ref), u116 (ref)
    local v1 = u110
    local Camera = u104 and u104:FindFirstChild("Camera")
    local v2 = if not Camera then nil else if v1 == "Inspecting" then Camera:FindFirstChild(v1) else if v1 ~= "Unboxing" then nil else Camera:FindFirstChild(v1)
    u112 = true
    u113 = if not v2 then CurrentCamera.CFrame else v2.CFrame
    u114 = a1.CFrame
    u115 = tick()
    u116 = a2
end

local function ensureAnimator(a1) -- Line: 360 -- types: a1: userdata
    local Animator = a1:FindFirstChildOfClass("Animator")
    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = a1
    end
    return Animator
end

local function findAnimationController(a1, a2) -- Line: 369 -- types: a1: userdata
    local v1
    local ConsoleLaptop = if not (a2.AssetFolder == "ConsoleScene") then if a2.InteractionType ~= "Drag" then a1:FindFirstChild("CaseMod") else a1:FindFirstChild("Pack") else a1:FindFirstChild("ConsoleLaptop", true)
    if not ConsoleLaptop then
        return nil
    end
    local Animator = if not v1 then ConsoleLaptop:FindFirstChildOfClass("AnimationController") else ConsoleLaptop:FindFirstChildWhichIsA("AnimationController", true)
    if Animator then
        local AnimationController
        Animator = AnimationController:FindFirstChildOfClass("Animator")
        if not Animator then
            Animator = Instance.new("Animator")
            Animator.Parent = AnimationController
        end
    end
    return Animator
end

local function loadAnimations(a1, a2, a3) -- Line: 385
    -- upvalues: findAnimationController (val), u117 (ref)
    local Animation, Animator
    local AnimationController = false
    if a2.InteractionType == "Click" then
        AnimationController = a3 and a3:FindFirstChildOfClass("AnimationController")
    end
    if not AnimationController then
        Animator = findAnimationController(a1, a2)
    else
        Animator = AnimationController:FindFirstChildOfClass("Animator")
        if not Animator then
            Animator = Instance.new("Animator")
            Animator.Parent = AnimationController
        end
    end
    if not Animator then
        warn("[CaseSceneController]: No animator found for scene")
        return
    end
    for i, j in a2.Animations do
        if j then
            Animation = Instance.new("Animation")
            Animation.AnimationId = j
            u117[i] = (Animator:LoadAnimation(Animation))
            Animation:Destroy()
        end
    end
end

local function setEffectsEnabled(a1, a2) -- Line: 410 -- types: a1: userdata?, a2: boolean
    if not a1 then
        return
    end
    for i, j in a1:GetDescendants() do
        if j:IsA("Beam") or j:IsA("ParticleEmitter") then
            j.Enabled = a2
        end
    end
end

local function setCaseEffects(a1, a2, a3) -- Line: 422
    -- upvalues: u104 (ref), setEffectsEnabled (val)
    local CaseMod = u104 and u104:FindFirstChild("CaseMod")
    if not CaseMod then
        return
    end
    setEffectsEnabled(CaseMod:FindFirstChild("IdleEffect"), a1)
    setEffectsEnabled(CaseMod:FindFirstChild("OpeningEffect"), a2)
    if a3 ~= nil then
        setEffectsEnabled(CaseMod:FindFirstChild("EffectsPart"), a3)
    end
end

local function getKeyframeSounds(a1) -- Line: 435 -- upvalues: u106 (ref) -- types: a1: string
    local AnimationKeyframeSounds = u106 and u106.AnimationKeyframeSounds
    return AnimationKeyframeSounds and AnimationKeyframeSounds[a1]
end

local function setupKeyframeSounds(a1, a2) -- Line: 440
    -- upvalues: Router (val), u108 (val)
    for i, j in a2 do
        u108:Add(((a1:GetMarkerReachedSignal(i)):Connect(function() -- Line: 442 -- upvalues: Router (upval), j (val)
            Router.broadcastRouter("RunStoreSound", j)
        end)))
    end
end

local function playConsoleAnimationSound(a1, a2) -- Line: 451
    -- upvalues: u108 (val), Router (val)
    u108:Remove(a2)
    local v1 = Router.broadcastRouter("RunStoreSound", a1)
    if not v1 then
        return
    end
    u108:Add(v1, "Destroy", a2)
    v1.Destroying:Once(function() -- Line: 458 -- upvalues: u108 (upval), a2 (val)
        u108:RemoveNoClean(a2)
    end)
end

local function freezeAtEnd(a1, a2, a3) -- Line: 464
    -- upvalues: RunServiceController (val), u108 (val)
    local u3 = nil
    u3 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName(a2), function() -- Line: 468 -- upvalues: a1 (val), u3 (ref)
        if 0 < a1.Length then
            local TimePosition = a1.TimePosition
            if a1.Length - 0.05 <= TimePosition then
                a1:AdjustSpeed(0)
                u3:Disconnect()
            end
        end
    end)
    u108:Add(u3, "Disconnect", a3)
end

local function playInspectAnimations() -- Line: 480
    -- upvalues: u117 (ref), u105 (ref), setCaseEffects (val), playConsoleAnimationSound (val), u106 (ref)
    -- upvalues: RunServiceController (val), u108 (val), setupKeyframeSounds (val), Router (val), u104 (ref)
    if not u117.CaseFall then
        return
    end
    if u105 ~= "Console" and not u117.CloseIdle then
        return
    end
    setCaseEffects(true, false, true)
    local CaseFall = u117.CaseFall
    if u105 == "Console" then
        local Sounds = u106 and u106.Sounds
        playConsoleAnimationSound(Sounds and Sounds.Enter or "Console Enter Animation", "ConsoleEnterSound")
        CaseFall:Play()
        local u32 = nil
        u32 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName("CaseSceneController.ConsoleEnterAnimationFreeze"), function() -- Line: 468 -- upvalues: CaseFall (val), u32 (ref)
            if 0 < CaseFall.Length then
                local TimePosition = CaseFall.TimePosition
                if CaseFall.Length - 0.05 <= TimePosition then
                    CaseFall:AdjustSpeed(0)
                    u32:Disconnect()
                end
            end
        end)
        u108:Add(u32, "Disconnect", "ConsoleEnterAnimationFreeze")
        return
    end
    local AnimationKeyframeSounds = u106 and u106.AnimationKeyframeSounds
    local CaseFall_2 = AnimationKeyframeSounds and AnimationKeyframeSounds.CaseFall
    if not CaseFall_2 then
        local Drop
        local Sounds_2 = u106 and u106.Sounds
        if not Sounds_2 then
            Drop = "Case Fall"
        else
            Drop = Sounds_2.Drop
            if not Drop then
                Drop = "Case Fall"
            end
        end
        u108:Add(((CaseFall:GetMarkerReachedSignal("Dropped")):Connect(function() -- Line: 500 -- upvalues: Router (upval), Drop (val)
            Router.broadcastRouter("RunStoreSound", Drop)
        end)))
    else
        setupKeyframeSounds(CaseFall, CaseFall_2)
    end
    u108:Add(((CaseFall:GetMarkerReachedSignal(if not CaseFall_2 then "Dropped" else if not CaseFall_2.Drop then "Dropped" else "Drop")):Connect(function() -- Line: 509 -- upvalues: u104 (upval)
        local Attribute
        local DropParticle = u104 and u104:FindFirstChild("DropParticle")
        if not DropParticle then
            return
        end
        for i, j in DropParticle:GetChildren() do
            if j:IsA("ParticleEmitter") then
                Attribute = j:GetAttribute("EmitCount")
                if typeof(Attribute) == "number" and Attribute > 0 then
                    j:Emit(Attribute)
                end
            end
        end
    end)))
    CaseFall:Play()
    u117.CloseIdle.Looped = true
    u117.CloseIdle:Play()
end

local function playOpeningAnimations() -- Line: 532
    -- upvalues: u117 (ref), u105 (ref), u108 (val), playConsoleAnimationSound (val), u106 (ref), u104 (ref)
    -- upvalues: setEffectsEnabled (val), RunServiceController (val), setupKeyframeSounds (val), Router (val)
    if not u117.CaseOpening then
        return
    end
    if u117.CloseIdle then
        u117.CloseIdle:Stop()
    end
    local CaseOpening = u117.CaseOpening
    if u105 == "Console" then
        u108:Remove("ConsoleEnterSound")
        local Sounds = u106 and u106.Sounds
        playConsoleAnimationSound(Sounds and Sounds.Opening or "Console Open Animation", "ConsoleOpenSound")
        local CaseMod = u104 and u104:FindFirstChild("CaseMod")
        if CaseMod then
            setEffectsEnabled(CaseMod:FindFirstChild("IdleEffect"), false)
            setEffectsEnabled(CaseMod:FindFirstChild("OpeningEffect"), true)
        end
        CaseOpening:Play(0.1, 1, 1)
        local u62 = nil
        u62 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName("CaseSceneController.ConsoleAnimationFreeze"), function() -- Line: 468 -- upvalues: CaseOpening (val), u62 (ref)
            if 0 < CaseOpening.Length then
                local TimePosition = CaseOpening.TimePosition
                if CaseOpening.Length - 0.05 <= TimePosition then
                    CaseOpening:AdjustSpeed(0)
                    u62:Disconnect()
                end
            end
        end)
        u108:Add(u62, "Disconnect", nil)
        return
    end
    local AnimationKeyframeSounds = u106 and u106.AnimationKeyframeSounds
    local CaseOpening_2 = AnimationKeyframeSounds and AnimationKeyframeSounds.CaseOpening
    if not CaseOpening_2 then
        local broadcastRouter = Router.broadcastRouter
        local Sounds_2 = u106 and u106.Sounds
        broadcastRouter("RunStoreSound", Sounds_2 and Sounds_2.Opening or "Case Opening")
    else
        setupKeyframeSounds(CaseOpening, CaseOpening_2)
    end
    local CaseMod_2 = u104 and u104:FindFirstChild("CaseMod")
    if CaseMod_2 then
        setEffectsEnabled(CaseMod_2:FindFirstChild("IdleEffect"), false)
        setEffectsEnabled(CaseMod_2:FindFirstChild("OpeningEffect"), true)
    end
    CaseOpening:Play()
    if u117.OpenIdle then
        u117.OpenIdle.Looped = true
        u117.OpenIdle:Play()
    end
end

local function stopAllAnimations() -- Line: 570 -- upvalues: u117 (ref), u119 (ref)
    for i, j in u117 do
        if j.IsPlaying then
            j:Stop()
        end
    end
    if u119 then
        u119:Stop()
        u119:Destroy()
        u119 = nil
    end
end

local function runCharmDragCallback() -- Line: 586 -- upvalues: u122 (ref)
    local v1 = u122
    if v1 then
        u122 = nil
        v1()
    end
end

local function finishCharmOpeningAndStartRoll() -- Line: 594
    -- upvalues: DebugLog (val), u119 (ref), u124 (ref), u128 (ref), MainGui (val), u117 (ref), u122 (ref), Router (val)
    -- upvalues: u106 (ref)
    DebugLog("finishCharmOpeningAndStartRoll called")
    if u119 then
        u119:Stop()
    end
    u124 = nil
    if u128 then
        u128.Enabled = false
    end
    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective then
        CameraPerspective.Interactable = true
    end
    local PackOpening = u117.PackOpening
    DebugLog("  packOpeningTrack:", if not PackOpening then "nil" else "exists")
    DebugLog("  CharmDragCallback:", if not u122 then "nil" else "exists")
    if not PackOpening then
        DebugLog("  No packOpeningTrack, calling callback directly")
        if u122 then
            DebugLog("  Calling CharmDragCallback")
        end
        local v1 = u122
        if v1 then
            u122 = nil
            v1()
        end
        return
    end
    local broadcastRouter = Router.broadcastRouter
    local Sounds = u106 and u106.Sounds
    broadcastRouter("RunStoreSound", Sounds and Sounds.DragLoop or "Charm Drag Loop")
    if not PackOpening.IsPlaying then
        PackOpening:Play()
    end
    PackOpening:AdjustSpeed(1)
    PackOpening.Looped = false
    task.delay(math.max(0, PackOpening.Length - PackOpening.TimePosition - 0.1), function() -- Line: 632 -- upvalues: PackOpening (val), u122 (upval)
        if not PackOpening.IsPlaying then
            return
        end
        PackOpening:AdjustSpeed(0)
        PackOpening.TimePosition = PackOpening.Length * 0.99
        local v1 = u122
        if v1 then
            u122 = nil
            v1()
        end
    end)
end

local function updateCharmAnimationProgress(a1, a2) -- Line: 645
    -- upvalues: u117 (ref), u127 (ref), u121 (ref), finishCharmOpeningAndStartRoll (val), u119 (ref), u124 (ref)
    -- upvalues: u125 (ref)
    local PackOpening = u117.PackOpening
    if not PackOpening then
        return
    end
    local v1 = math.clamp(a1, 0, 1)
    local Length = if not (u127 > 0) then PackOpening.Length else u127
    if not PackOpening.IsPlaying then
        PackOpening:Play()
        PackOpening:AdjustSpeed(0)
    end
    PackOpening.TimePosition = Length * v1
    if v1 >= 1 then
        u121 = false
        finishCharmOpeningAndStartRoll()
    end
    if u119 and a2 then
        local Magnitude = 0
        if u124 then
            Magnitude = (a2 - u124).Magnitude
        end
        u124 = a2
        if Magnitude > 0.001 then
            u125 = tick()
            if not u119.IsPlaying then
                u119:Play()
            end
            u119.PlaybackSpeed = math.clamp(Magnitude * 20, 0, 0.7) + 0.8
        end
    end
end

local function setupCharmDragDetector(a1) -- Line: 688
    -- upvalues: u104 (ref), ContextActionService (val), u129 (ref), u122 (ref), u121 (ref), u123 (ref), u126 (ref)
    -- upvalues: u117 (ref), u106 (ref), u127 (ref), MainGui (val), u128 (ref), u108 (val), u130 (ref)
    -- upvalues: RunServiceController (val), u124 (ref), u125 (ref), u119 (ref), ReplicatedStorage (val)
    -- upvalues: finishCharmOpeningAndStartRoll (val), updateCharmAnimationProgress (val), UserInputService (val)
    -- upvalues: u109 (ref), u110 (ref), Router (val)
    if not u104 then
        return
    end
    local Pack = u104:FindFirstChild("Pack")
    if not Pack then
        warn("[CaseSceneController]: Pack not found in CharmScene")
        return
    end
    local Drag = Pack:FindFirstChild("Drag")
    if not Drag then
        warn("[CaseSceneController]: Drag part not found in Pack")
        return
    end
    local DragDetector = Drag:FindFirstChildOfClass("DragDetector")
    if not DragDetector then
        warn("[CaseSceneController]: DragDetector not found on Drag part")
        return
    end
    ContextActionService:UnbindAction("Fire")
    ContextActionService:UnbindAction("Secondary Fire")
    u129 = true
    u122 = a1
    u121 = false
    u123 = Drag.Position
    u126 = DragDetector.MaxDragTranslation.Magnitude
    if u126 <= 0 then
        u126 = 1
    end
    local PackOpening = u117.PackOpening
    if PackOpening then
        local EndKeyframe
        local DragSettings = u106 and u106.DragSettings
        if not DragSettings then
            EndKeyframe = "DragEndPoint"
        else
            EndKeyframe = DragSettings.EndKeyframe
            if not EndKeyframe then
                EndKeyframe = "DragEndPoint"
            end
        end
        local success, result = pcall(function() -- Line: 731 -- upvalues: PackOpening (val), EndKeyframe (val)
            return PackOpening:GetTimeOfKeyframe(EndKeyframe)
        end)
        if not success or not result then
            u127 = PackOpening.Length
            warn("[CaseSceneController]: " .. EndKeyframe .. " keyframe not found, using full animation length")
        else
            u127 = result
        end
    end
    DragDetector.Enabled = true
    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective then
        CameraPerspective.Interactable = false
    end
    local SurfaceGui = Drag:FindFirstChildOfClass("SurfaceGui")
    if SurfaceGui then
        SurfaceGui.Enabled = true
        u128 = SurfaceGui
        local Frame = SurfaceGui:FindFirstChildOfClass("Frame")
        local ImageLabel = Frame
        if ImageLabel then
            ImageLabel = Frame:FindFirstChildOfClass("ImageLabel")
        end
        if Frame and ImageLabel then
            u108:Add(Frame.MouseEnter:Connect(function() -- Line: 758 -- upvalues: u130 (upval), ImageLabel (val)
                u130 = true
                ImageLabel.ImageTransparency = 1
            end), "Disconnect", "CharmImageHoverEnter")
            u108:Add(Frame.MouseLeave:Connect(function() -- Line: 767 -- upvalues: u130 (upval), ImageLabel (val)
                u130 = false
                ImageLabel.ImageTransparency = 0
            end), "Disconnect", "CharmImageHoverLeave")
            local u125_2 = 0
            u108:Add(RunServiceController.BindToRenderStep("CaseSceneController.CharmImageBreathing", function(a1) -- Line: 778 -- upvalues: u130 (upval), u125_2 (ref), ImageLabel (val)
                if u130 then
                    return
                end
                u125_2 = u125_2 + a1 * 2
                ImageLabel.ImageTransparency = (math.sin(u125_2) + 1) / 2 * 0.2
            end), "Disconnect", "CharmImageBreathing")
        end
    end
    u108:Add(DragDetector.DragStart:Connect(function() -- Line: 794
        -- upvalues: u121 (upval), u124 (upval), Drag (val), u125 (upval), u119 (upval), ReplicatedStorage (upval)
        -- upvalues: u106 (upval), Pack (val), u108 (upval)
        u121 = true
        u124 = Drag.Position
        u125 = tick()
        if not u119 then
            local Store = require(ReplicatedStorage.Database.Audio.Store)
            local Sounds = u106 and u106.Sounds
            local v1 = Store[Sounds and Sounds.DragStart or "Charm Drag Start"]
            if v1 and v1.Identifiers and v1.Identifiers[1] then
                local Sound = Instance.new("Sound")
                Sound.Name = "DragProgress"
                Sound.SoundId = "rbxassetid://" .. v1.Identifiers[1]
                Sound.Volume = v1.Properties.Volume or 1
                Sound.Looped = true
                Sound.PlaybackSpeed = 0.8
                Sound.Parent = Pack
                u119 = Sound
                u108:Add(Sound, "Destroy")
            end
        end
    end), "Disconnect", "CharmDragStart")
    u108:Add(RunServiceController.BindToHeartbeat("CaseSceneController.CharmDragSoundCheck", function() -- Line: 821 -- upvalues: u121 (upval), u119 (upval), u125 (upval)
        if u121 and u119 and u119.IsPlaying and 0.05 < tick() - u125 then
            u119:Stop()
        end
    end), "Disconnect", "CharmDragSoundCheck")
    u108:Add(DragDetector.DragContinue:Connect(function() -- Line: 836
        -- upvalues: u121 (upval), u123 (upval), Drag (val), u126 (upval), u106 (upval), DragDetector (val)
        -- upvalues: finishCharmOpeningAndStartRoll (upval), updateCharmAnimationProgress (upval)
        if u121 and u123 then
            local v1 = math.clamp((Drag.Position - u123).Magnitude / u126, 0, 1)
            local DragSettings = u106 and u106.DragSettings
            if not ((DragSettings and DragSettings.Threshold or 0.5) <= v1) then
                updateCharmAnimationProgress(v1, Drag.Position)
                return
            end
            u121 = false
            DragDetector.Enabled = false
            Drag.Position = u123
            finishCharmOpeningAndStartRoll()
            return
        end
    end), "Disconnect", "CharmDragContinue")
    u108:Add(DragDetector.DragEnd:Connect(function() -- Line: 861
        -- upvalues: u121 (upval), u123 (upval), u119 (upval), Drag (val), u126 (upval), u106 (upval)
        -- upvalues: DragDetector (val), finishCharmOpeningAndStartRoll (upval), u117 (upval), u124 (upval)
        if u121 and u123 then
            u121 = false
            if u119 then
                u119:Stop()
            end
            local v1 = math.clamp((Drag.Position - u123).Magnitude / u126, 0, 1)
            Drag.Position = u123
            local DragSettings = u106 and u106.DragSettings
            if math.max(DragSettings and DragSettings.Threshold or 0.8, 0.8) <= v1 then
                DragDetector.Enabled = false
                finishCharmOpeningAndStartRoll()
                return
            end
            if u117.PackOpening then
                u117.PackOpening.TimePosition = 0
            end
            u124 = nil
            return
        end
    end), "Disconnect", "CharmDragEnd")
    u108:Add(UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 895
        -- upvalues: u109 (upval), u110 (upval), DragDetector (val), u121 (upval), u123 (upval), Drag (val)
        -- upvalues: u119 (upval), Router (upval), u106 (upval), finishCharmOpeningAndStartRoll (upval)
        if u109 and u110 == "Unboxing" then
            local v1
            local v2 = a1.UserInputType == Enum.UserInputType.Gamepad1
            if a1.UserInputType == Enum.UserInputType.Keyboard and a2 then
                return
            end
            local v3 = v2
            if v3 then
                v3 = true
                if a1.KeyCode ~= Enum.KeyCode.ButtonX then
                    v3 = a1.KeyCode == Enum.KeyCode.ButtonA
                end
            end
            local v4 = v1
            if v4 then
                v4 = true
                if a1.KeyCode ~= Enum.KeyCode.Return then
                    v4 = a1.KeyCode == Enum.KeyCode.Space
                end
            end
            if not v3 and not v4 then
                return
            end
            DragDetector.Enabled = false
            if u121 then
                u121 = false
                if u123 then
                    Drag.Position = u123
                end
            end
            if u119 then
                u119:Stop()
            end
            local broadcastRouter = Router.broadcastRouter
            local Sounds = u106 and u106.Sounds
            broadcastRouter("RunStoreSound", Sounds and Sounds.DragStart or "Charm Drag Start")
            finishCharmOpeningAndStartRoll()
            return
        end
    end), "Disconnect", "CharmControllerSkip")
end

local function rearmCharmDrag(a1) -- Line: 939
    -- upvalues: u117 (ref), setupCharmDragDetector (val)
    local PackOpening = u117.PackOpening
    if PackOpening and PackOpening.IsPlaying then
        PackOpening:Stop()
    end
    setupCharmDragDetector(a1)
end

local function cleanupCharmDrag() -- Line: 949
    -- upvalues: u129 (ref), Router (val), u121 (ref), u122 (ref), u123 (ref), u124 (ref), u125 (ref), u126 (ref)
    -- upvalues: u127 (ref), u128 (ref), u130 (ref)
    if u129 then
        Router.broadcastRouter("RebindKeybinds")
        u129 = false
    end
    u121 = false
    u122 = nil
    u123 = nil
    u124 = nil
    u125 = 0
    u126 = 1
    u127 = 0
    u128 = nil
    u130 = false
end

function u0.ShowCaseScene(a1, a2) -- Line: 969
    -- upvalues: DebugLog (val), u109 (ref), SceneRegistry (val), u103 (val), SceneParking (val), u105 (ref), u106 (ref)
    -- upvalues: u104 (ref), u110 (ref), CurrentCamera (val), hideMenuFrames (val), u102 (ref)
    -- upvalues: MenuSceneController (val), applyCaseFog (val), hideViewmodels (val), u108 (val), hideViewmodel (val)
    -- upvalues: setupCaseModel (val), loadAnimations (val), playInspectAnimations (val), CameraController (val)
    -- upvalues: RunServiceController (val), u112 (ref), u113 (ref), u114 (ref), u115 (ref), TweenService (val)
    -- upvalues: u116 (ref), setCaseEffects (val), u129 (ref), Router (val), u121 (ref), u122 (ref), u123 (ref)
    -- upvalues: u124 (ref), u125 (ref), u126 (ref), u127 (ref), u128 (ref), u130 (ref), stopAllAnimations (val)
    -- upvalues: u117 (ref)
    local v1
    DebugLog("ShowCaseScene called")
    DebugLog("  caseType:", a1 or "nil")
    DebugLog("  caseName:", a2 or "nil")
    DebugLog("  IsCaseSceneActive:", u109)
    if u109 then
        DebugLog("  BLOCKED: Scene already active")
        return
    end
    local v2 = SceneRegistry.GetSceneForCaseType(a1 or "Case")
    DebugLog("  sceneName:", v2)
    local u32 = SceneRegistry.GetConfig(v2)
    if not u32 then
        warn("[CaseSceneController]: No config found for scene: " .. v2)
        DebugLog("  BLOCKED: No config found")
        return
    end
    DebugLog("  config.AssetFolder:", u32.AssetFolder)
    DebugLog("  config.InteractionType:", u32.InteractionType)
    local v3 = u103[u32.AssetFolder]
    if not v3 then
        warn("[CaseSceneController]: Scene was never staged: " .. u32.AssetFolder)
        return
    end
    SceneParking.Unpark(v3)
    u105 = v2
    u106 = u32
    u104 = v3
    if u32.InteractionType == "Drag" then
        local Pack = v3:FindFirstChild("Pack")
        local Drag = Pack and Pack:FindFirstChild("Drag")
        local SurfaceGui = Drag and Drag:FindFirstChildOfClass("SurfaceGui")
        if SurfaceGui then
            SurfaceGui.Enabled = false
        end
    end
    u110 = "Inspecting"
    local Camera = u104 and u104:FindFirstChild("Camera")
    if not (if not Camera then nil else Camera:FindFirstChild("Inspecting")) then
        warn("[CaseSceneController]: Scene missing Camera.Inspecting")
        SceneParking.Park(v3)
        u104 = nil
        u105 = nil
        u106 = nil
        u110 = nil
        return
    end
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.CFrame = v1.CFrame
    CurrentCamera.Focus = v1.CFrame
    hideMenuFrames()
    if not u102 then
        MenuSceneController.ApplyMenuSceneLighting()
    end
    applyCaseFog(v3)
    hideViewmodels()
    u108:Add(CurrentCamera.ChildAdded:Connect(function(a1) -- Line: 1041 -- upvalues: u32 (val), hideViewmodel (upval)
        if a1:IsA("Model") and a1.Name ~= u32.AssetFolder then
            hideViewmodel(a1)
        end
    end), "Disconnect", "ViewmodelListener")
    local v4 = nil
    if a2 and u32.InteractionType == "Click" and u105 ~= "Console" then
        v4 = setupCaseModel(v3, a2)
    end
    loadAnimations(v3, u32, v4)
    if u32.InteractionType == "Click" then
        playInspectAnimations()
    end
    CameraController.setFOVLock("CaseScene", true, 50)
    CameraController.setForceLockOverride("CaseScene", true)
    local v5 = Enum.RenderPriority.Camera.Value + 10
    RunServiceController.BindToRenderStep("CaseSceneController.CameraUpdate", v5, function() -- Line: 1066
        -- upvalues: u104 (upval), CurrentCamera (upval), u112 (upval), u113 (upval), u114 (upval), u115 (upval)
        -- upvalues: TweenService (upval), u116 (upval), u110 (upval)
        local v1
        if not u104 then
            return
        end
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        if u112 and u113 and u114 then
            v1 = math.min(((tick()) - u115) / 0.8, 1)
            local Value = TweenService:GetValue(v1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            CurrentCamera.CFrame = u113:Lerp(u114, Value)
            CurrentCamera.Focus = CurrentCamera.CFrame
            if not (v1 >= 1) then
                return
            end
            u112 = false
            CurrentCamera.CFrame = u114
            if u116 then
                local v2 = u116
                u116 = nil
                v2()
            end
            u113 = nil
            u114 = nil
            return
        end
        v1 = u110
        local Camera = u104 and u104:FindFirstChild("Camera")
        local v3 = if not Camera then nil else if v1 == "Inspecting" then Camera:FindFirstChild(v1) else if v1 ~= "Unboxing" then nil else Camera:FindFirstChild(v1)
        if v3 then
            CurrentCamera.CFrame = v3.CFrame
            CurrentCamera.Focus = v3.CFrame
        end
    end)
    u108:Add(function() -- Line: 1103 -- upvalues: RunServiceController (upval)
        RunServiceController.UnbindFromRenderStep("CaseSceneController.CameraUpdate")
    end, true, "CameraUpdate")
    u108:Add(function() -- Line: 1107
        -- upvalues: DebugLog (upval), u110 (upval), u112 (upval), u113 (upval), u114 (upval), u116 (upval)
        -- upvalues: setCaseEffects (upval), u129 (upval), Router (upval), u121 (upval), u122 (upval), u123 (upval)
        -- upvalues: u124 (upval), u125 (upval), u126 (upval), u127 (upval), u128 (upval), u130 (upval), u104 (upval)
        -- upvalues: stopAllAnimations (upval), u117 (upval)
        DebugLog("CaseSceneCleanup running")
        u110 = nil
        u112 = false
        u113 = nil
        u114 = nil
        u116 = nil
        setCaseEffects(false, false, false)
        if u129 then
            Router.broadcastRouter("RebindKeybinds")
            u129 = false
        end
        u121 = false
        u122 = nil
        u123 = nil
        u124 = nil
        u125 = 0
        u126 = 1
        u127 = 0
        u128 = nil
        u130 = false
        if u104 then
            local CaseMod = u104:FindFirstChild("CaseMod")
            if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
                CaseMod:Destroy()
            end
        end
        stopAllAnimations()
        u117 = {}
        DebugLog("CaseSceneCleanup complete")
    end, true, "CaseSceneCleanup")
    u109 = true
    DebugLog("ShowCaseScene complete, IsCaseSceneActive = true")
end

function u0.TransitionToUnboxing(a1) -- Line: 1133
    -- upvalues: DebugLog (val), u109 (ref), u104 (ref), u106 (ref), u110 (ref), playOpeningAnimations (val), u112 (ref)
    -- upvalues: u113 (ref), CurrentCamera (val), u114 (ref), u115 (ref), u116 (ref), setupCharmDragDetector (val)
    DebugLog("TransitionToUnboxing called")
    DebugLog("  IsCaseSceneActive:", u109)
    DebugLog("  CurrentScene:", if not u104 then "nil" else "exists")
    DebugLog("  CurrentSceneConfig:", if not u106 then "nil" else "exists")
    DebugLog("  CurrentCaseSceneState:", u110 or "nil")
    DebugLog("  callback:", if not a1 then "nil" else "provided")
    if u109 and u104 and u106 then
        local v1, v2, v3
        if u110 == "Unboxing" then
            DebugLog("  BLOCKED: Already in Unboxing state")
            return
        end
        local Camera = u104 and u104:FindFirstChild("Camera")
        if not (if not Camera then nil else Camera:FindFirstChild("Unboxing")) then
            warn("[CaseSceneController]: Scene missing Camera.Unboxing")
            DebugLog("  BLOCKED: Missing Camera.Unboxing")
            return
        end
        DebugLog("  InteractionType:", u106.InteractionType)
        if u106.InteractionType ~= "Click" then
            DebugLog("  Starting camera lerp, will setup drag detector after")

            function v2() -- Line: 1164 -- upvalues: DebugLog (upval), setupCharmDragDetector (upval), a1 (val)
                DebugLog("  Camera lerp complete, setting up drag detector")
                setupCharmDragDetector(a1)
            end

            local v4 = u110
            local Camera_3 = u104 and u104:FindFirstChild("Camera")
            v3 = if not Camera_3 then nil else if v4 == "Inspecting" then Camera_3:FindFirstChild(v4) else if v4 ~= "Unboxing" then nil else Camera_3:FindFirstChild(v4)
            u112 = true
            u113 = if not v3 then CurrentCamera.CFrame else v3.CFrame
            u114 = v1.CFrame
            u115 = tick()
            u116 = v2
        else
            DebugLog("  Playing opening animations and starting camera lerp")
            playOpeningAnimations()
            v3 = u110
            local Camera_2 = u104 and u104:FindFirstChild("Camera")
            v2 = if not Camera_2 then nil else if v3 == "Inspecting" then Camera_2:FindFirstChild(v3) else if v3 ~= "Unboxing" then nil else Camera_2:FindFirstChild(v3)
            u112 = true
            u113 = if not v2 then CurrentCamera.CFrame else v2.CFrame
            u114 = v1.CFrame
            u115 = tick()
            u116 = a1
        end
        u110 = "Unboxing"
        DebugLog("  TransitionToUnboxing complete, CurrentCaseSceneState = Unboxing")
        return
    end
    DebugLog("  BLOCKED: Scene not active or missing config")
end

function u0.TransitionToInspecting(a1) -- Line: 1176
    -- upvalues: u109 (ref), u104 (ref), u110 (ref), u112 (ref), u113 (ref), CurrentCamera (val), u114 (ref), u115 (ref)
    -- upvalues: u116 (ref)
    if u109 and u104 then
        local v1
        if u110 == "Inspecting" then
            return
        end
        local Camera = u104 and u104:FindFirstChild("Camera")
        if not (if not Camera then nil else Camera:FindFirstChild("Inspecting")) then
            warn("[CaseSceneController]: Scene missing Camera.Inspecting")
            return
        end
        local v2 = u110
        local Camera_2 = u104 and u104:FindFirstChild("Camera")
        local v3 = if not Camera_2 then nil else if v2 == "Inspecting" then Camera_2:FindFirstChild(v2) else if v2 ~= "Unboxing" then nil else Camera_2:FindFirstChild(v2)
        u112 = true
        u113 = if not v3 then CurrentCamera.CFrame else v3.CFrame
        u114 = v1.CFrame
        u115 = tick()
        u116 = a1
        u110 = "Inspecting"
        return
    end
end

function u0.BeginConsoleOpening() -- Line: 1198
    -- upvalues: u118 (ref), u108 (val), ConsoleBoardAnimator (val), u104 (ref), RunService (val), u117 (ref)
    -- upvalues: u110 (ref), u0 (val), u106 (ref), setupCharmDragDetector (val)
    if u118 then
        u108:Remove("ConsoleAnimator")
        u118 = nil
    end
    local u10 = ConsoleBoardAnimator.new(u104)
    u108:Add(u10, "Cancel", "ConsoleAnimator")
    u118 = u10
    u10:Start()
    RunService.RenderStepped:Wait()
    local CaseFall = u117.CaseFall
    u108:Remove("ConsoleEnterAnimationFreeze")
    if CaseFall and CaseFall.IsPlaying then
        CaseFall:Stop(0.1)
    end
    u108:Remove("ConsoleEnterSound")

    local function setSceneReady() -- Line: 1213 -- upvalues: u118 (upval), u10 (val)
        if u118 == u10 then
            u10:SetSceneReady()
        end
    end

    if u110 ~= "Unboxing" then
        u0.TransitionToUnboxing(setSceneReady)
        return
    end
    if u106 and u106.InteractionType == "Drag" then
        local PackOpening = u117.PackOpening
        if PackOpening and PackOpening.IsPlaying then
            PackOpening:Stop()
        end
        setupCharmDragDetector(setSceneReady)
        return
    end
    u10:SetSceneReady()
end

function u0.ResolveConsoleOpening(a1, a2) -- Line: 1228 -- upvalues: u118 (ref) -- types: a2: function
    local v1 = u118
    if not v1 then
        return false
    end
    v1:Resolve(a1, a2)
    return true
end

function u0.SkipConsoleOpening() -- Line: 1238 -- upvalues: u118 (ref)
    if u118 then
        u118:Skip()
    end
end

function u0.CancelConsoleOpening() -- Line: 1244 -- upvalues: u118 (ref), u108 (val), u117 (ref), u110 (ref), u0 (val)
    if u118 then
        u108:Remove("ConsoleAnimator")
        u118 = nil
    end
    u108:Remove("ConsoleOpenSound")
    local CaseOpening = u117.CaseOpening
    if CaseOpening and CaseOpening.IsPlaying then
        CaseOpening:Stop(0.1)
    end
    if u110 == "Unboxing" then
        u0.TransitionToInspecting()
    end
end

function u0.IsConsoleOpening() -- Line: 1256 -- upvalues: u118 (ref)
    return u118 ~= nil
end

function u0.ArmDragOpening(a1) -- Line: 1263
    -- upvalues: u109 (ref), u104 (ref), u106 (ref), u110 (ref), u117 (ref), setupCharmDragDetector (val)
    if u109 and u104 and u106 and u106.InteractionType == "Drag" and u110 == "Unboxing" then
        local PackOpening = u117.PackOpening
        if PackOpening and PackOpening.IsPlaying then
            PackOpening:Stop()
        end
        setupCharmDragDetector(a1)
        return true
    end
    return false
end

function u0.HideCaseScene(a1) -- Line: 1279
    -- upvalues: DebugLog (val), u109 (ref), u118 (ref), u108 (val), CurrentCamera (val), CameraController (val)
    -- upvalues: Constants (val), ReplicatedStorage (val), restoreMenuFrames (val), MenuSceneController (val)
    -- upvalues: u102 (ref), MenuState (val), showViewmodels (val), u104 (ref), SceneParking (val), u105 (ref)
    -- upvalues: u106 (ref), u110 (ref)
    DebugLog("HideCaseScene called")
    DebugLog("  IsCaseSceneActive:", u109)
    DebugLog("  skipFrameRestore:", a1 or false)
    if not u109 then
        DebugLog("  BLOCKED: Scene not active")
        return
    end
    if u118 then
        u108:Remove("ConsoleAnimator")
        u118 = nil
    end
    DebugLog("  Running CaseSceneJanitor:Cleanup()")
    u108:Cleanup()
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CameraController.setFOVLock("CaseScene", false)
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
    local v1 = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance()
    if v1 then
        v1:UpdateScopeState()
    end
    CameraController.setForceLockOverride("CaseScene", false)
    if a1 then
        if workspace:FindFirstChild("Map") then
            MenuSceneController.ApplyMapLighting()
        elseif u102 then
            MenuSceneController.ApplyMenuSceneLighting()
        end
        MenuState.ExitCaseScene()
        u102 = false
    else
        restoreMenuFrames()
    end
    showViewmodels()
    if u104 then
        SceneParking.Park(u104)
    end
    u104 = nil
    u105 = nil
    u106 = nil
    u109 = false
    u110 = nil
    DebugLog("HideCaseScene complete, IsCaseSceneActive = false")
end

function u0.IsActive() -- Line: 1327 -- upvalues: u109 (ref)
    return u109
end

function u0.ApplyCaseSceneLighting() -- Line: 1333
    -- upvalues: u109 (ref), u104 (ref), MenuSceneController (val), applyCaseFog (val)
    if u109 and u104 then
        MenuSceneController.ApplyMenuSceneLighting()
        applyCaseFog(u104)
        return
    end
end

function u0.WaitForOpeningAnimation() -- Line: 1345 -- upvalues: u117 (ref)
    local CaseOpening = u117.CaseOpening
    if CaseOpening and CaseOpening.IsPlaying then
        CaseOpening.Stopped:Wait()
    end
end

function u0.Initialize() -- Line: 1355
    -- upvalues: ReplicatedStorage (val), SceneRegistry (val), u103 (val), SceneParking (val), UserInputService (val)
    -- upvalues: u109 (ref), u0 (val), Router (val)
    local Model, v1, v2, v3
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    if not Assets then
        warn("[CaseSceneController]: Assets folder not found in ReplicatedStorage")
        return
    end
    for i, j in SceneRegistry.GetAllSceneNames() do
        v1 = SceneRegistry.GetConfig(j)
        v2 = v1 and Assets:FindFirstChild(v1.AssetFolder)
        if v1 and v2 then
            Model = v2:FindFirstChildWhichIsA("Model")
            if not Model then
                warn("[CaseSceneController]: No model found in Assets." .. v1.AssetFolder)
            else
                v3 = Model:Clone()
                v3.Name = v1.AssetFolder
                u103[v1.AssetFolder] = v3
                SceneParking.Park(v3)
            end
        end
    end
    UserInputService.InputBegan:Connect(function(a1, a2) -- Line: 1379 -- upvalues: u109 (upval), u0 (upval)
        if not a2 and a1.KeyCode == Enum.KeyCode.Escape and u109 then
            if u0.IsConsoleOpening() then
                u0.SkipConsoleOpening()
                return
            end
            u0.HideCaseScene()
            return
        end
    end)
    Router.observerRouter("CaseSceneCloseForGameEnd", function() -- Line: 1390 -- upvalues: u0 (upval)
        u0.HideCaseScene(true)
    end)
end

function u0.Start() end

Router.observerRouter("IsCaseSceneRolling", function() -- Line: 1401 -- upvalues: u109 (ref), u110 (ref)
    return u109 and u110 == "Unboxing"
end)
return u0