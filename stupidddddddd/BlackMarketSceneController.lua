-- ReplicatedStorage.Controllers.BlackMarketSceneController
-- Script path: ReplicatedStorage.Controllers.BlackMarketSceneController
-- Decompile time: 29.84 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local BakedViewmodelMirror = require(ReplicatedStorage.Shared.BakedViewmodelMirror)
local SceneParking = require(ReplicatedStorage.Components.Common.SceneParking)
u0.OnActiveChanged = require(ReplicatedStorage.Packages.Signal).new()
local Router = require(ReplicatedStorage.Database.Security.Router)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local CameraController = require(ReplicatedStorage.Controllers.CameraController)
local Constants = require(ReplicatedStorage.Database.Custom.Constants)
local DealerLines = require(script.DealerLines)
local u64 = Enum.RenderPriority.Camera.Value + 10
local Sine = Enum.EasingStyle.Sine
local u67 = Random.new()
local Cubic = Enum.EasingStyle.Cubic
local Back = Enum.EasingStyle.Back
local u70 = {
    Brightness = 4.5,
    EnvironmentDiffuseScale = 1,
    EnvironmentSpecularScale = 1,
    GlobalShadows = true,
    ShadowSoftness = 0.06,
    ClockTime = 9.8,
    GeographicLatitude = 50,
    ExposureCompensation = 0,
    FogStart = 100000,
    FogEnd = 100000,
}
u70.Ambient = Color3.fromRGB(68, 68, 68)
u70.OutdoorAmbient = Color3.fromRGB(120, 128, 143)
u70.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
u70.ColorShift_Top = Color3.fromRGB(208, 168, 108)
local CurrentCamera = workspace.CurrentCamera
local u93 = nil
local u94 = {}
local u95 = {}
local u96 = {}
local u97 = {}
local u98 = {}
local u99 = {}
local u100 = {}
local u101 = {}
local u102 = nil
local u103 = nil
local u104 = 1
local u105 = {}
local u106 = {}
local u107 = false
local u108 = false
local u110 = Janitor.new()
local u111 = false
local u112 = false
local u113 = false
local u114 = {}
local u115 = true
local u116 = 0
local u117 = nil
local u118 = {}
local u119 = nil
local u120 = nil
local u121 = nil
local u122 = nil
local u123 = nil
local u124 = nil
local u125 = nil
local u126 = 0

local function applySceneLighting() -- Line: 226 -- upvalues: u70 (val), Lighting (val)
    for i, j in u70 do
        Lighting[i] = j
    end
    for k, n in Lighting:GetChildren() do
        if n.Name ~= "Menu" then
            n:Destroy()
        end
    end
end

local function setPerspectiveSinksInput(a1) -- Line: 253 -- upvalues: Players (val) -- types: a1: boolean
    local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local MainGui = PlayerGui and PlayerGui:FindFirstChild("MainGui")
    local CameraPerspective = MainGui and MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective and CameraPerspective:IsA("GuiButton") then
        CameraPerspective.Active = a1
        CameraPerspective.Interactable = a1
        return true
    end
    warn("[BlackMarketSceneController]: MainGui.CameraPerspective was not found, card clicks may be swallowed")
    return false
end

local u129 = {}
local u130 = {}

local function hideInstance(a1) -- Line: 283 -- upvalues: u129 (val), u130 (val) -- types: a1: userdata
    if not a1:IsA("BasePart") and not a1:IsA("Decal") then
        if a1:IsA("SurfaceGui") and a1.Enabled then
            a1.Enabled = false
            table.insert(u130, a1)
        end
        return
    end
    if u129[a1] == nil then
        u129[a1] = a1.LocalTransparencyModifier
    end
    a1.LocalTransparencyModifier = 1
end

local function hideViewmodel(a1) -- Line: 296 -- upvalues: hideInstance (val) -- types: a1: userdata
    hideInstance(a1)
    for i, j in a1:GetDescendants() do
        hideInstance(j)
    end
end

local function showViewmodels() -- Line: 303 -- upvalues: u129 (val), u130 (val)
    for i, j in u129 do
        if i.Parent then
            i.LocalTransparencyModifier = j
        end
    end
    table.clear(u129)
    for k, n in u130 do
        if n.Parent then
            n.Enabled = true
        end
    end
    table.clear(u130)
end

local function isCameraAttachment(a1) -- Line: 319 -- types: a1: userdata
    return a1:IsA("Model") or a1:IsA("BasePart")
end

local function applyCardVisibility(a1, a2) -- Line: 334 -- types: a1: userdata, a2: boolean
    for i, j in a1:GetChildren() do
        if j:IsA("SurfaceGui") then
            j.Enabled = a2
        end
    end
end

local function isCardShown(a1) -- Line: 353
    -- upvalues: u106 (ref), u107 (ref), u108 (ref), u112 (ref), u113 (ref), u114 (val)
    if u106[a1] == true and not u107 and not u108 then
        return not (u112 or u113) or u114[a1] == true
    end
    return false
end

local function refreshCardFaces(a1) -- Line: 363
    -- upvalues: applyCardVisibility (val), u106 (ref), u107 (ref), u108 (ref), u112 (ref), u113 (ref), u114 (val)
    applyCardVisibility(a1, if u106[a1] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[a1] == true else false)
end

local function syncCardVisibility() -- Line: 373
    -- upvalues: u94 (ref), applyCardVisibility (val), u106 (ref), u107 (ref), u108 (ref), u112 (ref), u113 (ref)
    -- upvalues: u114 (val)
    local v1
    local v2 = nil
    local v3 = nil
    for i, j in u94, v2, v3 do
        v1 = if u106[j] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[j] == true else false
        applyCardVisibility(j, v1)
    end
end

local function getMarker(a1) -- Line: 381 -- upvalues: u93 (ref) -- types: a1: string
    local v1 = u93
    local Camera = v1 and v1:FindFirstChild("Camera")
    local v2 = Camera and Camera:FindFirstChild(a1)
    return v2 and v2:IsA("BasePart") and v2 or nil
end

local function moveCameraTo(a1) -- Line: 394
    -- upvalues: u93 (ref), u123 (ref), u124 (ref), u125 (ref)
    local v1 = u93
    local Camera = v1 and v1:FindFirstChild("Camera")
    local v2 = Camera and Camera:FindFirstChild(a1)
    local v3 = v2 and v2:IsA("BasePart") and v2 or nil
    if not v3 then
        warn((("[BlackMarketSceneController]: scene is missing Camera.%*"):format(a1)))
        return
    end
    u123 = v3.CFrame
    u124 = nil
    u125 = nil
end

local function startIntroArc() -- Line: 413 -- upvalues: u123 (ref), u124 (ref), u125 (ref), u126 (ref)
    local v1 = u123
    if not v1 then
        return
    end
    u124 = -v1.LookVector * 6
    u125 = Vector3.new(0, 4, 0)
    u126 = os.clock()
end

local u142 = {
    face = "TopMost",
    ["Cube.002"] = "Tie",
    ["Cube.012"] = "UpperBody.001",
    UpperTorso = "UpperBody.001",
    ["Cube.003"] = "UpperLeg.L",
}

local function attachUnskinnedParts(a1) -- Line: 436 -- upvalues: u142 (val) -- types: a1: userdata
    local Attachment, RigidConstraint, v1, v2
    local v3 = nil
    local v4 = nil
    local v5 = a1
    for i, j in u142, v3, v4 do
        v1 = v5:FindFirstChild(i)
        v2 = v5:FindFirstChild(j, true)
        if v1 and v1:IsA("MeshPart") and v2 and v2:IsA("Bone") and not v1.HasSkinnedMesh then
            for k, n in v1:GetChildren() do
                if n:IsA("Motor6D") and n.Part1 == v1 then
                    n.Enabled = false
                end
            end
            Attachment = Instance.new("Attachment")
            Attachment.Name = "BoneFollow"
            Attachment.CFrame = v1.CFrame:ToObjectSpace(v2.WorldCFrame)
            Attachment.Parent = v1
            RigidConstraint = Instance.new("RigidConstraint")
            RigidConstraint.Name = "BoneFollow"
            RigidConstraint.Attachment0 = Attachment
            RigidConstraint.Attachment1 = v2
            RigidConstraint.Parent = v1
            v1.Anchored = false
        end
    end
end

local function bindDealer(a1) -- Line: 478 -- upvalues: u117 (ref), attachUnskinnedParts (val) -- types: a1: userdata
    local AnimationController = a1:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = AnimationController and AnimationController:FindFirstChildOfClass("Animator")
    if not Animator then
        warn("[BlackMarketSceneController]: the scene's dealer has no Animator, so he will not move")
        return
    end
    u117 = Animator
    attachUnskinnedParts(AnimationController.Parent)
end

local function getDealerTrack(a1) -- Line: 498 -- upvalues: u117 (ref), u118 (val) -- types: a1: string
    local v1 = u117
    if not v1 then
        return nil
    end
    local v2 = u118[a1]
    if v2 then
        return v2
    end
    local Animation = Instance.new("Animation")
    Animation.AnimationId = a1
    local v3 = v1:LoadAnimation(Animation)
    u118[a1] = v3
    return v3
end

local function startDealerIdle() -- Line: 523 -- upvalues: DealerLines (val), u117 (ref), u118 (val), u119 (ref)
    local v1
    local IDLE_ANIMATION = DealerLines.IDLE_ANIMATION
    local v2 = u117
    if v2 then
        local v3 = u118[IDLE_ANIMATION]
        if not v3 then
            local Animation = Instance.new("Animation")
            Animation.AnimationId = IDLE_ANIMATION
            local v4 = v2:LoadAnimation(Animation)
            u118[IDLE_ANIMATION] = v4
            v1 = v4
        else
            v1 = v3
        end
    else
        v1 = nil
    end
    if not v1 then
        return
    end
    v1.Looped = true
    v1.Priority = Enum.AnimationPriority.Idle
    if not v1.IsPlaying then
        v1:Play(0.15)
    end
    u119 = v1
end

local function stopDealerBody() -- Line: 540 -- upvalues: u122 (ref)
    local v1 = u122
    u122 = nil
    if v1 and v1.IsPlaying then
        v1:Stop(0.15)
    end
end

local function playDealerBody(a1) -- Line: 561 -- upvalues: u117 (ref), u118 (val), u122 (ref) -- types: a1: string
    local v1
    local v2 = u117
    if v2 then
        local v3 = u118[a1]
        if not v3 then
            local Animation = Instance.new("Animation")
            Animation.AnimationId = a1
            local v4 = v2:LoadAnimation(Animation)
            u118[a1] = v4
            v1 = v4
        else
            v1 = v3
        end
    else
        v1 = nil
    end
    if not v1 then
        return
    end
    v2 = u122
    u122 = nil
    if v2 and v2.IsPlaying then
        v2:Stop(0.15)
    end
    v1.Looped = false
    v1.Priority = Enum.AnimationPriority.Movement
    v1:Stop(0)
    v1:Play(0.15)
    u122 = v1
end

local function stopCurrentLine() -- Line: 585 -- upvalues: u121 (ref), u120 (ref)
    local v1 = u121
    u121 = nil
    if v1 and v1.Parent then
        v1:Stop()
        if v1:GetAttribute("Persistent") ~= true then
            v1:Destroy()
        end
    end
    local v2 = u120
    u120 = nil
    if v2 and v2.IsPlaying then
        v2:Stop(0.15)
    end
end

local function stopDealer() -- Line: 604 -- upvalues: stopCurrentLine (val), u122 (ref), u119 (ref)
    stopCurrentLine()
    local v1 = u122
    u122 = nil
    if v1 and v1.IsPlaying then
        v1:Stop(0.15)
    end
    if u119 then
        u119:Stop(0.15)
        u119 = nil
    end
end

local function playDealerLine(a1) -- Line: 626
    -- upvalues: DealerLines (val), stopCurrentLine (val), u122 (ref), Router (val), u121 (ref), u117 (ref), u118 (val)
    -- upvalues: u120 (ref)
    local v1
    local v2 = DealerLines.Pick(a1)
    if not v2 then
        return nil
    end
    stopCurrentLine()
    local v3 = u122
    u122 = nil
    if v3 and v3.IsPlaying then
        v3:Stop(0.15)
    end
    v3 = Router.broadcastRouter("RunArmsDealerSound", v2.Sound)
    if typeof(v3) == "Instance" and v3:IsA("Sound") then
        u121 = v3
    end
    local Animation = v2.Animation
    local v4 = u117
    if v4 then
        local v5 = u118[Animation]
        if not v5 then
            local Animation_2 = Instance.new("Animation")
            Animation_2.AnimationId = Animation
            local v6 = v4:LoadAnimation(Animation_2)
            u118[Animation] = v6
            v1 = v6
        else
            v1 = v5
        end
    else
        v1 = nil
    end
    if v1 then
        v1.Looped = false
        v1.Priority = Enum.AnimationPriority.Action
        v1:Stop(0)
        v1:Play(0.15)
        u120 = v1
    end
    return u121
end

local function getSettledPose(a1) -- Line: 663 -- upvalues: u95 (ref), u96 (ref) -- types: a1: userdata
    local v1 = u95[a1]
    if not v1 then
        return nil
    end
    if u96[a1] then
        return v1
    end
    return v1 * CFrame.Angles(0, 3.141592653589793, 0)
end

local function floatTowardLens(a1, a2) -- Line: 675 -- upvalues: u103 (ref) -- types: a1: userdata, a2: number
    local v1 = u103
    if not v1 then
        return a1
    end
    return a1 - a1.Position + (v1 + (a1.Position - v1) * a2)
end

local function setCardScale(a1, a2) -- Line: 690 -- upvalues: u100 (val), u101 (val) -- types: a1: userdata, a2: number
    local v1
    local v2 = u100[a1]
    if not v2 then
        return
    end
    a1.Size = Vector3.new(v2.X * a2, v2.Y * a2, v2.Z)
    for i, j in a1:GetChildren() do
        if j:IsA("SurfaceGui") then
            v1 = u101[j]
            if v1 then
                j.PixelsPerStud = v1 / a2
            end
        end
    end
end

local function getCardSpin(a1) -- Line: 710 -- upvalues: u97 (ref), u96 (ref), u95 (ref) -- types: a1: userdata
    local v1 = u97[a1]
    if v1 then
        return v1
    end
    local NumberValue = Instance.new("NumberValue")
    NumberValue.Value = if not u96[a1] then 3.141592653589793 else 0
    local u12 = {IsTurning = false, Direction = -1, Angle = NumberValue, Target = NumberValue.Value}
    NumberValue.Changed:Connect(function(a1_2) -- Line: 720 -- upvalues: u95 (upval), a1 (val), u12 (val) -- types: a1_2: number
        local v1 = u95[a1]
        if u12.IsTurning and v1 then
            a1.CFrame = v1 * CFrame.Angles(0, a1_2, 0)
        end
    end)
    u97[a1] = u12
    return u12
end

local function settleCardSpin(a1) -- Line: 734
    -- upvalues: u110 (val), u98 (ref), u97 (ref), u96 (ref)
    u110:Remove((("CardFlip_%*"):format(u98[a1] or 0)))
    local v1 = u97[a1]
    if v1 then
        v1.IsTurning = false
        v1.Target = if not u96[a1] then 3.141592653589793 else 0
        v1.Angle.Value = v1.Target
    end
end

local function isDealInProgress() -- Line: 747 -- upvalues: u112 (ref), u113 (ref)
    return u112 or u113
end

local function getDealPose(a1, a2) -- Line: 767
    -- upvalues: u105 (ref), u100 (val), u104 (ref), u96 (ref), u123 (ref), CurrentCamera (val), TweenService (val)
    -- upvalues: Cubic (val), Back (val), u103 (ref)
    local v1 = u105[a1]
    local v2 = u100[a1]
    if v1 and v2 then
        local v3 = if not u96[a1] then v1 * CFrame.Angles(0, 3.141592653589793, 0) else v1
        local v4 = v2 * u104
        local CFrame_2 = u123 or CurrentCamera.CFrame
        local v5 = Vector3.new(CFrame_2.RightVector.X, 0, CFrame_2.RightVector.Z)
        local Unit = if not (0.001 < v5.Magnitude) then Vector3.new(1, 0, 0) else v5.Unit
        local v6 = Vector3.new(0, 1, 0):Cross(Unit)
        local Position = v3.Position
        local v7 = -Unit * (v4.X * 1.4) + v6 * 3
        local v8 = Position - Vector3.new(0, 4, 0) + v7
        local Value = TweenService:GetValue(a2, Cubic, Enum.EasingDirection.Out)
        local Value_2 = TweenService:GetValue(math.min(Value / 0.4, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Value_3 = TweenService:GetValue(math.clamp((Value - 0.3) / 0.7, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local v9 = v4.Y * 0.3 * (math.sin(3.141592653589793 * Value_3))
        local v10 = v8 + Vector3.new(0, 1, 0) * (4 * Value_2 + v9) - v7 * Value_3
        local v11 = 1 - TweenService:GetValue(a2, Back, Enum.EasingDirection.Out)
        local v12 = (CFrame.fromAxisAngle(v6, -0.4188790204786391 * v11)) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.6108652381980153 * v11)
        local v13 = math.clamp((Value - 0.4) / 0.6, 0, 1) * -0.30000000000000004 + 1
        local v14 = CFrame.new(v10) * v12 * v3.Rotation
        local v15 = u103
        return if v15 then v14 - v14.Position + (v15 + (v14.Position - v15) * v13) else v14, u104 * v13
    end
    return nil, u104
end

local function settleDeal() -- Line: 815
    -- upvalues: u116 (ref), u112 (ref), u113 (ref), u94 (ref), u110 (val), u98 (ref), u95 (ref), u96 (ref)
    -- upvalues: setCardScale (val), u104 (ref), u114 (val), applyCardVisibility (val), u106 (ref), u107 (ref)
    -- upvalues: u108 (ref)
    local v1, v2, v3
    u116 = u116 + 1
    u112 = false
    u113 = false
    local v4 = nil
    local v5 = nil
    for i, j in u94, v4, v5 do
        u110:Remove((("CardDeal_%*"):format(u98[j] or 0)))
        v2 = u95[j]
        v1 = if v2 then if not u96[j] then v2 * CFrame.Angles(0, 3.141592653589793, 0) else v2 else nil
        if v1 then
            setCardScale(j, u104 * 0.7)
            j.CFrame = v1
        end
        u114[j] = true
    end
    v4 = nil
    v5 = nil
    for k, n in u94, v4, v5 do
        v3 = if u106[n] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[n] == true else false
        applyCardVisibility(n, v3)
    end
end

local function runDeal() -- Line: 846
    -- upvalues: u116 (ref), u115 (ref), u112 (ref), u113 (ref), u94 (ref), u114 (val), getDealPose (val)
    -- upvalues: setCardScale (val), applyCardVisibility (val), u106 (ref), u107 (ref), u108 (ref), playDealerLine (val)
    -- upvalues: DealerLines (val), u95 (ref), u96 (ref), TweenService (val), u110 (val), u98 (ref), settleDeal (val)
    local v1, v2, v3
    u116 = u116 + 1
    local u59 = u116
    local u63 = u115
    u112 = true
    u113 = false
    u115 = true
    for i, j in u94 do
        u114[j] = false
        v1, v2 = getDealPose(j, 0)
        if v1 then
            setCardScale(j, v2)
            j.CFrame = v1
        end
    end
    local v4 = nil
    local v5 = nil
    for k, n in u94, v4, v5 do
        v1 = applyCardVisibility
        v3 = if u106[n] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[n] == true else false
        v1(n, v3)
    end
    task.spawn(function() -- Line: 867
        -- upvalues: u63 (val), playDealerLine (upval), DealerLines (upval), u116 (upval), u59 (val), u94 (upval)
        -- upvalues: u95 (upval), u96 (upval), u114 (upval), applyCardVisibility (upval), u106 (upval), u107 (upval)
        -- upvalues: u108 (upval), u112 (upval), u113 (upval), getDealPose (upval), setCardScale (upval)
        -- upvalues: TweenService (upval), u110 (upval), u98 (upval), settleDeal (upval)
        local v1, v2, v3, v4
        if u63 then
            playDealerLine(DealerLines.Open)
        end
        task.wait(0.25)
        if u116 ~= u59 then
            return
        end
        local v5 = nil
        local v6 = nil
        for i, j in u94, v5, v6 do
            if u116 ~= u59 then
                return
            end
            v3 = u95[j]
            v2 = if v3 then if not u96[j] then v3 * CFrame.Angles(0, 3.141592653589793, 0) else v3 else nil
            if v2 then
                u114[j] = true
                v2 = applyCardVisibility
                v4 = if u106[j] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[j] == true else false
                v2(j, v4)
                local NumberValue = Instance.new("NumberValue")
                NumberValue.Changed:Connect(function(a1) -- Line: 892 -- upvalues: getDealPose (upval), j (val), setCardScale (upval) -- types: a1: number
                    local v1, v2 = getDealPose(j, a1)
                    if v1 then
                        setCardScale(j, v2)
                        j.CFrame = v1
                    end
                end)
                local u88 = TweenService:Create(NumberValue, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Value = 1})
                v4 = u110
                v1 = ("CardDeal_%*"):format(u98[j] or i)
                v4:Add(function() -- Line: 904 -- upvalues: u88 (val), NumberValue (val)
                    u88:Destroy()
                    NumberValue:Destroy()
                end, true, v1)
                u88:Play()
            end
            if i < #u94 then
                task.wait(0.14)
            end
        end
        task.wait(0.8)
        if u116 ~= u59 then
            return
        end
        settleDeal()
    end)
end

local function startDealIfReady() -- Line: 935
    -- upvalues: u113 (ref), u111 (ref), u107 (ref), u108 (ref), u94 (ref), u106 (ref), runDeal (val)
    if u113 and u111 and not u107 and not u108 then
        local v1 = false
        for i, j in u94 do
            if u106[j] == true then
                v1 = true
                break
            end
        end
        if not v1 then
            return
        end
        runDeal()
        return
    end
end

local function makeSceneInert(a1) -- Line: 972 -- types: a1: userdata
    local v1
    local Cards = a1:FindFirstChild("Cards")
    for i, j in a1:GetDescendants() do
        if j:IsA("BasePart") then
            j.CanCollide = false
            j.CanTouch = false
            v1 = j.Parent == Cards
            j.CanQuery = v1
        end
    end
end

local function captureDesignRow() -- Line: 990
    -- upvalues: u94 (ref), u99 (val), u100 (val), u101 (val), u102 (ref), u93 (ref), u103 (ref)
    local v1 = nil
    local v2 = nil
    for i, j in u94, v1, v2 do
        if not u99[j] then
            u99[j] = j.CFrame
            u100[j] = j.Size
            for k, n in j:GetChildren() do
                if n:IsA("SurfaceGui") then
                    u101[n] = n.PixelsPerStud
                end
            end
        end
    end
    local v3 = u94[1]
    v1 = u94[#u94]
    v2 = v3 and u99[v3]
    local v4 = v1 and u99[v1]
    if v2 and v4 then
        u102 = (v2.Position + v4.Position) / 2 - v2.UpVector * (u100[v3].Y / 2)
        local v5 = u93
        local Camera = v5 and v5:FindFirstChild("Camera")
        local Cards = Camera and Camera:FindFirstChild("Cards")
        local v6 = Cards and Cards:IsA("BasePart") and Cards or nil
        u103 = v6 and v6.Position
        return
    end
    u102 = nil
end

local function applyRowFit() -- Line: 1029
    -- upvalues: u102 (ref), CurrentCamera (val), u104 (ref), u94 (ref), u99 (val), u105 (ref), u103 (ref), u95 (ref)
    -- upvalues: u98 (ref), u110 (val), u97 (ref), u96 (ref), setCardScale (val), applyCardVisibility (val), u106 (ref)
    -- upvalues: u107 (ref), u108 (ref), u112 (ref), u113 (ref), u114 (val)
    local v1, v2, v3, v4, v5, v6
    local v7 = u102
    if not v7 then
        return
    end
    local ViewportSize = CurrentCamera.ViewportSize
    if ViewportSize.Y <= 0 then
        return
    end
    local v8 = math.min(1, ViewportSize.X / ViewportSize.Y / 1.7777777777777777)
    u104 = v8
    local v9 = nil
    local v10 = nil
    for i, j in u94, v9, v10 do
        v5 = u99[j]
        if v5 then
            v6 = v5 - v5.Position + (v7 + (v5.Position - v7) * v8)
            u105[j] = v6
            v2 = u103
            v1 = if v2 then v6 - v6.Position + (v2 + (v6.Position - v2) * 0.7) else v6
            u95[j] = v1
            v2 = u98[j] or 0
            u110:Remove((("CardFlip_%*"):format(u98[j] or 0)))
            v3 = u97[j]
            if v3 then
                v3.IsTurning = false
                v3.Target = if not u96[j] then 3.141592653589793 else 0
                v3.Angle.Value = v3.Target
            end
            u110:Remove((("CardDeal_%*"):format(v2)))
            setCardScale(j, v8 * 0.7)
            v3 = if not u96[j] then v1 * CFrame.Angles(0, 3.141592653589793, 0) else v1
            j.CFrame = v3
            v4 = if u106[j] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[j] == true else false
            applyCardVisibility(j, v4)
        end
    end
end

local function collectCards(a1) -- Line: 1069
    -- upvalues: u94 (ref), u95 (ref), u105 (ref), u96 (ref), u97 (ref), u106 (ref), u98 (ref), captureDesignRow (val)
    -- upvalues: applyRowFit (val)
    u94 = {}
    u95 = {}
    u105 = {}
    u96 = {}
    for i, j in u97 do
        j.Angle:Destroy()
    end
    u97 = {}
    u106 = {}
    u98 = {}
    local Cards = a1:FindFirstChild("Cards")
    if not Cards then
        warn("[BlackMarketSceneController]: scene is missing its Cards folder")
        return
    end
    for k, n in Cards:GetChildren() do
        if n:IsA("BasePart") then
            table.insert(u94, n)
        end
    end
    table.sort(u94, function(a1, a2) -- Line: 1095
        return a1.Position.Z < a2.Position.Z
    end)
    for m, i5 in u94 do
        u98[i5] = m
    end
    captureDesignRow()
    applyRowFit()
end

function u0.IsActive() -- Line: 1110 -- upvalues: u111 (ref)
    return u111
end

function u0.GetCards() -- Line: 1116 -- upvalues: u94 (ref)
    return u94
end

function u0.GetCardFaces(a1) -- Line: 1126 -- types: a1: userdata
    local Back = a1:FindFirstChild("Back")
    local Front = a1:FindFirstChild("Front")
    return Back and Back:FindFirstChild("Main"), Front and Front:FindFirstChild("Main")
end

function u0.IsCardFaceUp(a1) -- Line: 1134 -- upvalues: u96 (ref) -- types: a1: userdata
    return u96[a1] == true
end

function u0.SetCardFaceUp(a1, a2, a3) -- Line: 1146
    -- upvalues: u95 (ref), u96 (ref), u112 (ref), u113 (ref), u110 (val), u98 (ref), u97 (ref)
    -- upvalues: applyCardVisibility (val), u106 (ref), u107 (ref), u108 (ref), u114 (val), getCardSpin (val), u67 (val)
    -- upvalues: TweenService (val)
    local Angle_3, IsTurning, Out, Quad, new, u77, v1, v2, v3
    local v4 = u95[a1]
    if not v4 or u96[a1] == a2 then
        return
    end
    if not a3 then
        if not a3 then
            u96[a1] = a2
            u110:Remove((("CardFlip_%*"):format(u98[a1] or 0)))
            v1 = u97[a1]
            if v1 then
                v1.IsTurning = false
                v1.Target = if not u96[a1] then 3.141592653589793 else 0
                v1.Angle.Value = v1.Target
            end
            a1.CFrame = if not a2 then v4 * CFrame.Angles(0, 3.141592653589793, 0) else v4
            applyCardVisibility(
                a1,
                if u106[a1] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[a1] == true else false
            )
            return
        end
        u77 = getCardSpin(a1)
        IsTurning = u77.IsTurning
        if not IsTurning then
            u77.Angle.Value = if not u96[a1] then 3.141592653589793 else 0
            u77.Target = u77.Angle.Value
            u77.Direction = if u67:NextInteger(0, 1) ~= 0 then 1 else -1
        end
        u77.Target = u77.Target + u77.Direction * 3.141592653589793
        v2 = math.abs(u77.Target - u77.Angle.Value)
        Angle_3 = u77.Angle
        new = TweenInfo.new
        Quad = Enum.EasingStyle.Quad
        Out = if not IsTurning then Enum.EasingDirection.InOut else Enum.EasingDirection.Out
        v3 = TweenService:Create(Angle_3, new(v2 * 0.42 / 3.141592653589793, Quad, Out), {Value = u77.Target})
        v3.Completed:Once(function(a1_2) -- Line: 1196 -- upvalues: u77 (val), u96 (upval), a1 (val)
            if a1_2 ~= Enum.PlaybackState.Completed then
                return
            end
            u77.IsTurning = false
            u77.Target = if not u96[a1] then 3.141592653589793 else 0
            u77.Angle.Value = u77.Target
        end)
        u110:Add(v3, "Destroy", (("CardFlip_%*"):format(u98[a1] or 0)))
        u96[a1] = a2
        u77.IsTurning = true
        v3:Play()
        return
    end
    if not u112 and not u113 then
        if not a3 then
            u96[a1] = a2
            u110:Remove((("CardFlip_%*"):format(u98[a1] or 0)))
            v1 = u97[a1]
            if v1 then
                v1.IsTurning = false
                v1.Target = if not u96[a1] then 3.141592653589793 else 0
                v1.Angle.Value = v1.Target
            end
            a1.CFrame = if not a2 then v4 * CFrame.Angles(0, 3.141592653589793, 0) else v4
            applyCardVisibility(
                a1,
                if u106[a1] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[a1] == true else false
            )
            return
        end
        u77 = getCardSpin(a1)
        IsTurning = u77.IsTurning
        if not IsTurning then
            u77.Angle.Value = if not u96[a1] then 3.141592653589793 else 0
            u77.Target = u77.Angle.Value
            u77.Direction = if u67:NextInteger(0, 1) ~= 0 then 1 else -1
        end
        u77.Target = u77.Target + u77.Direction * 3.141592653589793
        v2 = math.abs(u77.Target - u77.Angle.Value)
        Angle_3 = u77.Angle
        new = TweenInfo.new
        Quad = Enum.EasingStyle.Quad
        Out = if not IsTurning then Enum.EasingDirection.InOut else Enum.EasingDirection.Out
        v3 = TweenService:Create(Angle_3, new(v2 * 0.42 / 3.141592653589793, Quad, Out), {Value = u77.Target})
        v3.Completed:Once(function(a1_2) -- Line: 1196 -- upvalues: u77 (val), u96 (upval), a1 (val)
            if a1_2 ~= Enum.PlaybackState.Completed then
                return
            end
            u77.IsTurning = false
            u77.Target = if not u96[a1] then 3.141592653589793 else 0
            u77.Angle.Value = u77.Target
        end)
        u110:Add(v3, "Destroy", (("CardFlip_%*"):format(u98[a1] or 0)))
        u96[a1] = a2
        u77.IsTurning = true
        v3:Play()
        return
    end
end

function u0.ResetCards() -- Line: 1227
    -- upvalues: u94 (ref), u97 (ref), u110 (val), u98 (ref), u96 (ref), u95 (ref), u0 (val)
    local v1, v2, v3
    local v4 = nil
    local v5 = nil
    for i, j in u94, v4, v5 do
        v1 = u97[j]
        if v1 and v1.IsTurning then
            u110:Remove((("CardFlip_%*"):format(u98[j] or 0)))
            v2 = u97[j]
            if v2 then
                v2.IsTurning = false
                v2.Target = if not u96[j] then 3.141592653589793 else 0
                v2.Angle.Value = v2.Target
            end
            v3 = u95[j]
            v2 = if v3 then if not u96[j] then v3 * CFrame.Angles(0, 3.141592653589793, 0) else v3 else nil
            if v2 then
                j.CFrame = v2
            end
        end
        u0.SetCardFaceUp(j, false, false)
    end
end

function u0.SetCardVisible(a1, a2) -- Line: 1245
    -- upvalues: u106 (ref), applyCardVisibility (val), u107 (ref), u108 (ref), u112 (ref), u113 (ref), u114 (val)
    u106[a1] = a2
    applyCardVisibility(a1, if u106[a1] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[a1] == true else false)
end

function u0.IsCardShown(a1) -- Line: 1257
    -- upvalues: u106 (ref), u107 (ref), u108 (ref), u112 (ref), u113 (ref), u114 (val)
    if u106[a1] == true and not u107 and not u108 then
        return not (u112 or u113) or u114[a1] == true
    end
    return false
end

function u0.SetRevealHeld(a1) -- Line: 1268
    -- upvalues: u108 (ref), u94 (ref), applyCardVisibility (val), u106 (ref), u107 (ref), u112 (ref), u113 (ref)
    -- upvalues: u114 (val), startDealIfReady (val)
    local v1
    if u108 == a1 then
        return
    end
    local v2 = nil
    local v3 = nil
    for i, j in u94, v2, v3 do
        v1 = if u106[j] ~= true or u107 then false else if not a1 then not (u112 or u113) or u114[j] == true else false
        applyCardVisibility(j, v1)
    end
    startDealIfReady()
end

function u0.ReplayIntro() -- Line: 1290
    -- upvalues: u111 (ref), u0 (val), u107 (ref), u113 (ref), u115 (ref), u114 (val), u94 (ref)
    -- upvalues: applyCardVisibility (val), u106 (ref), u108 (ref), u112 (ref), u93 (ref), u123 (ref), u124 (ref)
    -- upvalues: u125 (ref), u126 (ref), DealerLines (val), u117 (ref), u118 (val), u122 (ref)
    local v1
    if not u111 then
        return
    end
    u0.ResetCards()
    u107 = true
    u113 = true
    u115 = true
    table.clear(u114)
    local v2 = nil
    local v3 = nil
    for i, j in u94, v2, v3 do
        v1 = if u106[j] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[j] == true else false
        applyCardVisibility(j, v1)
    end
    v2 = u93
    local Camera = v2 and v2:FindFirstChild("Camera")
    local Cards = Camera and Camera:FindFirstChild("Cards")
    local v4 = Cards and Cards:IsA("BasePart") and Cards or nil
    if v4 then
        u123 = v4.CFrame
        u124 = nil
        u125 = nil
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards")
    end
    v4 = u123
    if v4 then
        u124 = -v4.LookVector * 6
        u125 = Vector3.new(0, 4, 0)
        u126 = os.clock()
    end
    local INTRO_ANIMATION = DealerLines.INTRO_ANIMATION
    v3 = u117
    if v3 then
        local v5 = u118[INTRO_ANIMATION]
        if not v5 then
            local Animation = Instance.new("Animation")
            Animation.AnimationId = INTRO_ANIMATION
            local v6 = v3:LoadAnimation(Animation)
            u118[INTRO_ANIMATION] = v6
            v2 = v6
        else
            v2 = v5
        end
    else
        v2 = nil
    end
    if not v2 then
        return
    end
    v3 = u122
    u122 = nil
    if v3 and v3.IsPlaying then
        v3:Stop(0.15)
    end
    v2.Looped = false
    v2.Priority = Enum.AnimationPriority.Movement
    v2:Stop(0)
    v2:Play(0.15)
    u122 = v2
end

function u0.Redeal() -- Line: 1321
    -- upvalues: u111 (ref), u0 (val), u116 (ref), u94 (ref), u110 (val), u98 (ref), u112 (ref), u113 (ref), u115 (ref)
    -- upvalues: u114 (val), applyCardVisibility (val), u106 (ref), u107 (ref), u108 (ref)
    local v1
    if not u111 then
        return
    end
    u0.ResetCards()
    u116 = u116 + 1
    for i, j in u94 do
        u110:Remove((("CardDeal_%*"):format(u98[j] or 0)))
    end
    u112 = false
    u113 = true
    u115 = false
    table.clear(u114)
    local v2 = nil
    local v3 = nil
    for k, n in u94, v2, v3 do
        v1 = if u106[n] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[n] == true else false
        applyCardVisibility(n, v1)
    end
end

function u0.SkipIntro() -- Line: 1347
    -- upvalues: u111 (ref), u93 (ref), u123 (ref), u124 (ref), u125 (ref), u107 (ref), u94 (ref)
    -- upvalues: applyCardVisibility (val), u106 (ref), u108 (ref), u112 (ref), u113 (ref), u114 (val)
    -- upvalues: startDealIfReady (val)
    local v1
    if not u111 then
        return
    end
    local v2 = u93
    local Camera = v2 and v2:FindFirstChild("Camera")
    local Cards = Camera and Camera:FindFirstChild("Cards")
    local v3 = Cards and Cards:IsA("BasePart") and Cards or nil
    if v3 then
        u123 = v3.CFrame
        u124 = nil
        u125 = nil
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards")
    end
    u107 = false
    v2 = nil
    local v4 = nil
    for i, j in u94, v2, v4 do
        v1 = if u106[j] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[j] == true else false
        applyCardVisibility(j, v1)
    end
    startDealIfReady()
end

function u0.IsPresenting() -- Line: 1366 -- upvalues: u107 (ref), u112 (ref), u113 (ref)
    return u107 or u112 or u113
end

function u0.SkipPresentation() -- Line: 1379
    -- upvalues: u111 (ref), u107 (ref), u124 (ref), u93 (ref), u123 (ref), u125 (ref), settleDeal (val)
    if not u111 then
        return
    end
    if u107 or u124 then
        local v1 = u93
        local Camera = v1 and v1:FindFirstChild("Camera")
        local Cards = Camera and Camera:FindFirstChild("Cards")
        local v2 = Cards and Cards:IsA("BasePart") and Cards or nil
        if v2 then
            u123 = v2.CFrame
            u124 = nil
            u125 = nil
        else
            warn("[BlackMarketSceneController]: scene is missing Camera.Cards")
        end
        u107 = false
    end
    settleDeal()
end

function u0.PlayPurchaseLine() -- Line: 1397 -- upvalues: playDealerLine (val), DealerLines (val)
    playDealerLine(DealerLines.Purchase)
end

function u0.PlayDeclineLine() -- Line: 1401 -- upvalues: playDealerLine (val), DealerLines (val)
    playDealerLine(DealerLines.Declined)
end

function u0.PlayRefreshLine() -- Line: 1411 -- upvalues: playDealerLine (val), DealerLines (val)
    playDealerLine(DealerLines.Refresh)
end

function u0.PlayDiscontinuedLine() -- Line: 1415 -- upvalues: playDealerLine (val), DealerLines (val)
    playDealerLine(DealerLines.Discontinued)
end

function u0.PlayRarityLine(a1) -- Line: 1427 -- upvalues: playDealerLine (val), DealerLines (val) -- types: a1: string?
    if typeof(a1) ~= "string" then
        return
    end
    playDealerLine(DealerLines.Rarity[a1])
end

function u0.NotifyDealRendered() -- Line: 1443 -- upvalues: startDealIfReady (val)
    startDealIfReady()
end

function u0.Show(a1) -- Line: 1449
    -- upvalues: u111 (ref), u93 (ref), SceneParking (val), u108 (ref), collectCards (val), u0 (val), u94 (ref)
    -- upvalues: applyCardVisibility (val), u106 (ref), u107 (ref), u112 (ref), u113 (ref), u114 (val)
    -- upvalues: applySceneLighting (val), DealerLines (val), u117 (ref), u118 (val), u119 (ref), u115 (ref)
    -- upvalues: CurrentCamera (val), CameraController (val), setPerspectiveSinksInput (val), u123 (ref), u124 (ref)
    -- upvalues: u125 (ref), u126 (ref), u122 (ref), RunServiceController (val), u64 (val), TweenService (val)
    -- upvalues: Sine (val), startDealIfReady (val), u110 (val), applyRowFit (val), BakedViewmodelMirror (val)
    -- upvalues: hideInstance (val)
    local v1, v2, v3, v4
    if u111 then
        return
    end
    local v5 = u93
    if not v5 then
        warn("[BlackMarketSceneController]: scene was never staged")
        return
    end
    SceneParking.Unpark(v5)
    u111 = true
    u108 = false
    collectCards(v5)
    u0.ResetCards()
    local v6 = u94
    local v7 = nil
    local v8 = nil
    for i, j in v6, v7, v8 do
        v3 = applyCardVisibility
        v4 = if u106[j] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[j] == true else false
        v3(j, v4)
    end
    applySceneLighting()
    local IDLE_ANIMATION = DealerLines.IDLE_ANIMATION
    v8 = u117
    if v8 then
        v2 = u118[IDLE_ANIMATION]
        if not v2 then
            local Animation = Instance.new("Animation")
            Animation.AnimationId = IDLE_ANIMATION
            v3 = v8:LoadAnimation(Animation)
            u118[IDLE_ANIMATION] = v3
            v6 = v3
        else
            v6 = v2
        end
    else
        v6 = nil
    end
    if v6 then
        v6.Looped = true
        v6.Priority = Enum.AnimationPriority.Idle
        if not v6.IsPlaying then
            v6:Play(0.15)
        end
        u119 = v6
    end
    u113 = not v1
    u115 = true
    table.clear(u114)
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CameraController.setFOVLock("BlackMarketScene", true, 70)
    CameraController.setForceLockOverride("BlackMarketScene", true)
    setPerspectiveSinksInput(false)
    u107 = not v1
    v7 = u93
    local Camera = v7 and v7:FindFirstChild("Camera")
    local Cards = Camera and Camera:FindFirstChild("Cards")
    v6 = Cards and Cards:IsA("BasePart") and Cards or nil
    if v6 then
        u123 = v6.CFrame
        u124 = nil
        u125 = nil
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards")
    end
    if not v1 then
        v6 = u123
        if v6 then
            u124 = -v6.LookVector * 6
            u125 = Vector3.new(0, 4, 0)
            u126 = os.clock()
        end
        local INTRO_ANIMATION = DealerLines.INTRO_ANIMATION
        v8 = u117
        if v8 then
            v2 = u118[INTRO_ANIMATION]
            if not v2 then
                local Animation_2 = Instance.new("Animation")
                Animation_2.AnimationId = INTRO_ANIMATION
                v3 = v8:LoadAnimation(Animation_2)
                u118[INTRO_ANIMATION] = v3
                v7 = v3
            else
                v7 = v2
            end
        else
            v7 = nil
        end
        if v7 then
            v8 = u122
            u122 = nil
            if v8 and v8.IsPlaying then
                v8:Stop(0.15)
            end
            v7.Looped = false
            v7.Priority = Enum.AnimationPriority.Movement
            v7:Stop(0)
            v7:Play(0.15)
            u122 = v7
        end
    end
    RunServiceController.BindToRenderStep("BlackMarketSceneController.CameraUpdate", u64, function() -- Line: 1492
        -- upvalues: u123 (upval), CurrentCamera (upval), u124 (upval), u125 (upval), u126 (upval), TweenService (upval)
        -- upvalues: Sine (upval), u107 (upval), u94 (upval), applyCardVisibility (upval), u106 (upval), u108 (upval)
        -- upvalues: u112 (upval), u113 (upval), u114 (upval), startDealIfReady (upval)
        local v1 = u123
        if not v1 then
            return
        end
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        local v2 = u124
        local v3 = u125
        if not v2 or not v3 then
            CurrentCamera.CFrame = v1
        else
            local v4 = math.clamp((os.clock() - u126 - 0.2) / 1.4, 0, 1)
            local v5 = 1.5707963267948966 * TweenService:GetValue(v4, Sine, Enum.EasingDirection.InOut)
            CurrentCamera.CFrame = v1 + v2 * math.cos(v5) + v3 * (1 - math.sin(v5))
            if v4 >= 1 then
                u124 = nil
                u125 = nil
                if u107 then
                    local v6, v7
                    u107 = false
                    local v8 = nil
                    local v9 = nil
                    for i, j in u94, v8, v9 do
                        v6 = applyCardVisibility
                        v7 = if u106[j] ~= true or u107 then false else if not u108 then not (u112 or u113) or u114[j] == true else false
                        v6(j, v7)
                    end
                    startDealIfReady()
                end
            end
        end
        CurrentCamera.Focus = CurrentCamera.CFrame
    end)
    u110:Add(function() -- Line: 1528 -- upvalues: RunServiceController (upval)
        RunServiceController.UnbindFromRenderStep("BlackMarketSceneController.CameraUpdate")
    end, true, "CameraUpdate")
    u110:Add((CurrentCamera:GetPropertyChangedSignal("ViewportSize")):Connect(applyRowFit), "Disconnect", "ViewportFit")
    BakedViewmodelMirror.SetSuppressed(true)
    for k, n in CurrentCamera:GetChildren() do
        v3 = n:IsA("Model") or n:IsA("BasePart")
        if v3 then
            hideInstance(n)
            for m, i5 in n:GetDescendants() do
                hideInstance(i5)
            end
        end
    end
    u110:Add(CurrentCamera.ChildAdded:Connect(function(a1) -- Line: 1549 -- upvalues: hideInstance (upval)
        local v1 = a1:IsA("Model") or a1:IsA("BasePart")
        if v1 then
            hideInstance(a1)
            for i, j in a1:GetDescendants() do
                hideInstance(j)
            end
        end
    end), "Disconnect", "ViewmodelListener")
    u0.OnActiveChanged:Fire(true)
end

function u0.Hide() -- Line: 1563
    -- upvalues: u111 (ref), u107 (ref), u108 (ref), u116 (ref), u112 (ref), u113 (ref), stopCurrentLine (val)
    -- upvalues: u122 (ref), u119 (ref), u110 (val), u123 (ref), u124 (ref), u125 (ref), CurrentCamera (val)
    -- upvalues: CameraController (val), Constants (val), ReplicatedStorage (val), setPerspectiveSinksInput (val)
    -- upvalues: showViewmodels (val), BakedViewmodelMirror (val), u93 (ref), SceneParking (val), u0 (val)
    if not u111 then
        return
    end
    u111 = false
    u107 = false
    u108 = false
    u116 = u116 + 1
    u112 = false
    u113 = false
    stopCurrentLine()
    local v1 = u122
    u122 = nil
    if v1 and v1.IsPlaying then
        v1:Stop(0.15)
    end
    if u119 then
        u119:Stop(0.15)
        u119 = nil
    end
    u110:Cleanup()
    u123 = nil
    u124 = nil
    u125 = nil
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CameraController.setFOVLock("BlackMarketScene", false)
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV)
    local v2 = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance()
    if v2 then
        v2:UpdateScopeState()
    end
    CameraController.setForceLockOverride("BlackMarketScene", false)
    setPerspectiveSinksInput(true)
    showViewmodels()
    BakedViewmodelMirror.SetSuppressed(false)
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
    if not workspace:FindFirstChild("Map") then
        MenuSceneController.ApplyMenuSceneLighting()
    else
        MenuSceneController.ApplyMapLighting()
    end
    if u93 then
        SceneParking.Park(u93)
    end
    u0.OnActiveChanged:Fire(false)
end

function u0.Initialize() -- Line: 1615
    -- upvalues: Constants (val), ReplicatedStorage (val), SceneParking (val), u93 (ref), makeSceneInert (val)
    -- upvalues: u117 (ref), attachUnskinnedParts (val), collectCards (val), u0 (val)
    if not Constants.BLACK_MARKET_ENABLED then
        return
    end
    local BlackMarketScene = ReplicatedStorage.Assets:FindFirstChild("BlackMarketScene")
    if not BlackMarketScene then
        warn("[BlackMarketSceneController]: Assets.BlackMarketScene is missing")
        return
    end
    local Model = BlackMarketScene:FindFirstChildOfClass("Model")
    if not Model then
        warn("[BlackMarketSceneController]: no model inside Assets.BlackMarketScene")
        return
    end
    local v1 = Model:Clone()
    v1.Name = "BlackMarketScene"
    SceneParking.Park(v1)
    u93 = v1
    makeSceneInert(v1)
    local AnimationController = v1:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = AnimationController and AnimationController:FindFirstChildOfClass("Animator")
    if Animator then
        u117 = Animator
        attachUnskinnedParts(AnimationController.Parent)
    else
        warn("[BlackMarketSceneController]: the scene's dealer has no Animator, so he will not move")
    end
    collectCards(v1)
    u0.ResetCards()
end

return u0