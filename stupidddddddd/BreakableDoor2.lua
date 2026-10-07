-- ReplicatedStorage.Controllers.Observers.Game.BreakableDoor
-- Script path: ReplicatedStorage.Controllers.Observers.Game.BreakableDoor
-- Decompile time: 11.09 ms

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local MoverTrajectory = require(ReplicatedStorage.MovementV2.MoverTrajectory)
local DiagnosticProtocol = require(ReplicatedStorage.MovementV2.DiagnosticProtocol)
local DoorSwing = require(ReplicatedStorage.MovementV2.DoorSwing)
local Serial = require(ReplicatedStorage.MovementV2.Serial)
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Sound = require(ReplicatedStorage.Classes.Sound)
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local TouchEnabled = UserInputService.TouchEnabled
if TouchEnabled then
    TouchEnabled = not UserInputService.KeyboardEnabled
end
local u73 = {}
local u74 = nil
local SwingRate = DoorSwing.SwingRate

local function diagnosticsEnabled() -- Line: 37
    -- upvalues: DiagnosticProtocol (val), LocalPlayer (val), Workspace (val)
    return DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true
end

local u81 = {}

local function setPose(a1, a2) -- Line: 70 -- types: a1: userdata, a2: userdata
    if a1.Parent == nil then
        return
    end
    local BreakableDoorHingePivot = a1:FindFirstChild("BreakableDoorHingePivot")
    if BreakableDoorHingePivot ~= nil and BreakableDoorHingePivot:IsA("BasePart") then
        if a1.PrimaryPart ~= BreakableDoorHingePivot then
            a1.PrimaryPart = BreakableDoorHingePivot
        end
        a1:PivotTo(a2)
        return
    end
end

local function rotationDistance(a1, a2) -- Line: 85 -- types: a1: userdata, a2: userdata
    local v1
    _, v1 = a1.Rotation:ToObjectSpace(a2.Rotation):ToAxisAngle()
    return (math.abs(v1))
end

local function posesDiffer(a1, a2) -- Line: 90 -- types: a1: userdata, a2: userdata
    local v1
    local v2 = true
    _, v1 = a1.Rotation:ToObjectSpace(a2.Rotation):ToAxisAngle()
    if not (0.0001 < math.abs(v1)) then
        v2 = 0.0001 < (a1.Position - a2.Position).Magnitude
    end
    return v2
end

local function swingRate(a1) -- Line: 95 -- upvalues: SwingRate (val)
    local v1
    if not a1.Moving then
        return SwingRate
    end
    _, v1 = a1.StartPose.Rotation:ToObjectSpace(a1.TargetPose.Rotation):ToAxisAngle()
    return (math.max((math.abs(v1)) / math.max(a1.DurationSeconds, 0.001), SwingRate))
end

local function presentationTarget(a1, a2) -- Line: 104
    -- upvalues: MoverTrajectory (val), Serial (val)
    local v1
    local v2 = MoverTrajectory.GetClientPresentation(a1.Id)
    local v3, v4 = MoverTrajectory.GetClientPresentationClock()
    if v2 ~= nil and v3 ~= nil then
        v1 = Serial.deltaUInt32(v3, v2.ServerTick)
        local PreviousPose_2 = if v1 ~= 0 then if not (v1 < 0) then v2.Pose else v2.PreviousPose else v2.PreviousPose:Lerp(v2.Pose, v4)
        return {
            Predicted = true,
            Pose = PreviousPose_2,
            RestPose = v2.Pose,
            Moving = v2.PreviousPose ~= v2.Pose,
            Discontinuity = v2.Discontinuity,
            Descriptor = v2.Descriptor,
        }
    end
    v1 = MoverTrajectory.EvaluateTime(a1, a2)
    return {
        Predicted = false,
        Discontinuity = 0,
        Pose = v1,
        RestPose = v1,
        Moving = MoverTrajectory.PresentationMoving(a1, a2),
        Descriptor = a1,
    }
end

local function stepTowardPose(a1, a2, a3, a4) -- Line: 134
    -- upvalues: SwingRate (val)
    local v1, v2
    _, v1 = a1.Rotation:ToObjectSpace(a2.Rotation):ToAxisAngle()
    local v3 = math.abs(v1)
    local Magnitude = (a2.Position - a1.Position).Magnitude
    if v3 <= 0.0001 and Magnitude <= 0.0001 then
        return a2
    end
    local Magnitude_2 = (a3.TargetPose.Position - a3.StartPose.Position).Magnitude
    local v4 = math.max(a3.DurationSeconds, 0.001)
    if a3.Moving then
        local v5
        _, v5 = a3.StartPose.Rotation:ToObjectSpace(a3.TargetPose.Rotation):ToAxisAngle()
        v2 = math.max((math.abs(v5)) / math.max(a3.DurationSeconds, 0.001), SwingRate)
    else
        v2 = SwingRate
    end
    local v6 = math.max(Magnitude_2 / v4, 8)
    local v7 = 1
    if v3 > 0.0001 then
        v7 = math.min(v7, (math.min(v2 * 1.5 * math.max(a4, 0), 0.20943951023931956)) / v3)
    end
    if Magnitude > 0.0001 then
        v7 = math.min(v7, v6 * 1.5 * (math.max(a4, 0)) / Magnitude)
    end
    return a1:Lerp(a2, (math.clamp(v7, 0, 1)))
end

local function correctedPose(a1, a2, a3) -- Line: 163
    -- upvalues: SwingRate (val)
    local v1
    if a1.SeenDiscontinuity ~= a2.Discontinuity then
        a1.SeenDiscontinuity = a2.Discontinuity
        local CurrentPose = a1.CurrentPose
        a1.CorrectionOffset = nil
        if CurrentPose ~= nil then
            local v2
            local Pose = a2.Pose
            v1 = true
            _, v2 = CurrentPose.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle()
            if not (0.0001 < math.abs(v2)) then
                v1 = 0.0001 < (CurrentPose.Position - Pose.Position).Magnitude
            end
            if v1 then
                local v3, v4
                v1 = a2.Pose:ToObjectSpace(CurrentPose)
                _, v4 = v1:ToAxisAngle()
                local v5 = math.abs(v4)
                local Descriptor = a2.Descriptor
                if Descriptor.Moving then
                    local v6
                    _, v6 = Descriptor.StartPose.Rotation:ToObjectSpace(Descriptor.TargetPose.Rotation):ToAxisAngle()
                    v3 = math.max((math.abs(v6)) / math.max(Descriptor.DurationSeconds, 0.001), SwingRate)
                else
                    v3 = SwingRate
                end
                local v7 = math.max(v5 / v3, v1.Position.Magnitude / 8)
                a1.CorrectionOffset = v1
                a1.CorrectionElapsed = 0
                a1.CorrectionSeconds = math.min(0.1, v7)
            end
        end
    end
    local CorrectionOffset = a1.CorrectionOffset
    if CorrectionOffset == nil then
        return a2.Pose
    end
    a1.CorrectionElapsed = a1.CorrectionElapsed + math.max(a3, 0)
    v1 = 1 - a1.CorrectionElapsed / math.max(a1.CorrectionSeconds, 0.001)
    if not (v1 <= 0) then
        return a2.Pose * CFrame.identity:Lerp(CorrectionOffset, v1)
    end
    a1.CorrectionOffset = nil
    return a2.Pose
end

local function stepVisuals(a1) -- Line: 193
    -- upvalues: u81 (val), presentationTarget (val), correctedPose (val), stepTowardPose (val)
    -- upvalues: DiagnosticProtocol (val), LocalPlayer (val), Workspace (val), MoverTrajectory (val), u74 (ref)
    local BreakableDoorHingePivot, CurrentPose, Descriptor, RestPose, v1, v2, v3, v4, v5
    local v6 = false
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v7 = nil
    local v8 = nil
    local v9 = a1
    for i, j in u81, v7, v8 do
        Descriptor = j.Descriptor
        if i.Parent == nil then
            u81[i] = nil
        elseif Descriptor ~= nil then
            v5 = presentationTarget(Descriptor, ServerTimeNow)
            CurrentPose = j.CurrentPose or i:GetPivot()
            v1 = if not v5.Predicted then stepTowardPose(CurrentPose, v5.Pose, Descriptor, v9) else correctedPose(j, v5, v9)
            v2 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true
            if v2 and Descriptor.Moving and j.LoggedMotionRevision ~= Descriptor.Revision then
                v2 = true
                _, v3 = v1.Rotation:ToObjectSpace(CurrentPose.Rotation):ToAxisAngle()
                if not (0.0001 < math.abs(v3)) then
                    v2 = 0.0001 < (v1.Position - CurrentPose.Position).Magnitude
                end
                if v2 then
                    j.LoggedMotionRevision = Descriptor.Revision
                    print(string.format(
                        "[MovementV2.Door] visual-start id=%d revision=%d clientTime=%.6f descriptorAge=%.4f",
                        Descriptor.Id,
                        Descriptor.Revision,
                        ServerTimeNow,
                        ServerTimeNow - Descriptor.StartServerTime
                    ))
                end
            end
            j.CurrentPose = v1
            if i.Parent ~= nil then
                BreakableDoorHingePivot = i:FindFirstChild("BreakableDoorHingePivot")
                if BreakableDoorHingePivot ~= nil and BreakableDoorHingePivot:IsA("BasePart") then
                    if i.PrimaryPart ~= BreakableDoorHingePivot then
                        i.PrimaryPart = BreakableDoorHingePivot
                    end
                    i:PivotTo(v1)
                end
            end
            if v5.Moving
                or j.CorrectionOffset ~= nil
                or MoverTrajectory.PresentationMoving(Descriptor, ServerTimeNow) then
                v6 = true
            else
                RestPose = v5.RestPose
                v2 = true
                _, v4 = v1.Rotation:ToObjectSpace(RestPose.Rotation):ToAxisAngle()
                if not (0.0001 < math.abs(v4)) then
                    v2 = 0.0001 < (v1.Position - RestPose.Position).Magnitude
                end
                if v2 then
                    v6 = true
                end
            end
        end
    end
    if not v6 and u74 ~= nil then
        u74:Disconnect()
        u74 = nil
    end
end

local function ensureRenderConnection() -- Line: 241
    -- upvalues: u74 (ref), RunServiceController (val), stepVisuals (val)
    if u74 == nil then
        u74 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals)
    end
end

local function refreshTrajectory(a1) -- Line: 252
    -- upvalues: u81 (val), MoverTrajectory (val), presentationTarget (val), DiagnosticProtocol (val), LocalPlayer (val)
    -- upvalues: Workspace (val), u74 (ref), RunServiceController (val), stepVisuals (val)
    local v1 = u81[a1]
    if v1 == nil then
        return
    end
    local v2 = MoverTrajectory.Read(a1)
    if v2 == nil then
        return
    end
    local v3 = v1.Descriptor == nil
    local Revision = if v1.Descriptor == nil then nil else v1.Descriptor.Revision
    v1.Descriptor = v2
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v4 = presentationTarget(v2, ServerTimeNow)
    local v5 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true
    if v5 and v2.Revision ~= Revision then
        print(string.format(
            "[MovementV2.Door] descriptor id=%d revision=%d moving=%s clientTime=%.6f startTime=%.6f descriptorAge=%.4f",
            v2.Id,
            v2.Revision,
            tostring(v2.Moving),
            ServerTimeNow,
            v2.StartServerTime,
            ServerTimeNow - v2.StartServerTime
        ))
    end
    if v3 then
        v1.CurrentPose = v4.Pose
        v1.SeenDiscontinuity = v4.Discontinuity
        local Pose = v4.Pose
        if a1.Parent ~= nil then
            local BreakableDoorHingePivot = a1:FindFirstChild("BreakableDoorHingePivot")
            if BreakableDoorHingePivot ~= nil and BreakableDoorHingePivot:IsA("BasePart") then
                if a1.PrimaryPart ~= BreakableDoorHingePivot then
                    a1.PrimaryPart = BreakableDoorHingePivot
                end
                a1:PivotTo(Pose)
            end
        end
    end
    local CurrentPose = v1.CurrentPose or a1:GetPivot()
    if v2.Moving or v4.Moving then
        if u74 == nil then
            u74 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals)
        end
    elseif v4.Discontinuity == v1.SeenDiscontinuity then
        local v6
        local Pose_2 = v4.Pose
        local v7 = true
        _, v6 = CurrentPose.Rotation:ToObjectSpace(Pose_2.Rotation):ToAxisAngle()
        if not (0.0001 < math.abs(v6)) then
            v7 = 0.0001 < (CurrentPose.Position - Pose_2.Position).Magnitude
        end
        if v7 and u74 == nil then
            u74 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals)
        end
    elseif u74 == nil then
        u74 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals)
    end
end

local function useMouseDoor() -- Line: 295
    -- upvalues: Mouse (val), u73 (val), CharacterController (val), DiagnosticProtocol (val), LocalPlayer (val)
    -- upvalues: Workspace (val), Remotes (val)
    local v1
    local Target = Mouse.Target
    while Target ~= nil do
        if Target:IsA("Model") and u73[Target] then
            if not CharacterController.IsDoorInUseRange(Target) then
                return
            end
            v1 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true
            if v1 then
                print(string.format(
                    "[MovementV2.Door] use-send source=Mouse model=%s clientTime=%.6f",
                    Target:GetFullName(),
                    workspace:GetServerTimeNow()
                ))
            end
            v1 = CharacterController.PredictDoorUse(Target)
            Remotes.BreakableDoor.Use.Send({
                Model = Target,
                ServerTick = if v1 == nil then nil else v1.ServerTick,
                TargetAngle = if v1 == nil then nil else v1.TargetAngle,
                RequestId = if v1 == nil then nil else v1.RequestId,
            })
            return
        end
        Target = Target.Parent
    end
end

Mouse.Button1Down:Connect(function() -- Line: 325 -- upvalues: TouchEnabled (val), useMouseDoor (val)
    if not TouchEnabled then
        useMouseDoor()
    end
end)

local function releaseVisualStage(a1, a2) -- Line: 331
    -- upvalues: u81 (val), Sound (val), Debris (val)
    local v1
    local v2 = u81[a1]
    if v2 == nil then
        return
    end
    local v3 = a1:GetAttribute("BreakDirectionY") or 0
    local Attribute = a1:GetAttribute("BreakDirectionZ")
    local v4 = Vector3.new(a1:GetAttribute("BreakDirectionX") or 0, v3, Attribute or 0)
    local Unit = if not (0 < v4.Magnitude) then Vector3.new(0, 0, 1) else v4.Unit
    local Debris_2 = workspace:FindFirstChild("Debris") or workspace
    for i, j in v2.StageParts[a2] or {} do
        if j.Parent ~= nil then
            local u51 = j:Clone()
            u51.Transparency = v2.Transparencies[j] or 0
            u51.Anchored = false
            u51.CanCollide = true
            u51.CanQuery = false
            u51.CanTouch = true
            u51.CFrame = j.CFrame
            u51:SetAttribute("BreakableDoorDebris", true)
            local u66 = nil
            v1 = u51.Touched:Connect(function(a1_2) -- Line: 357 -- upvalues: a1 (val), u66 (ref), Sound (upval), u51 (val) -- types: a1_2: userdata
                if a1_2.CanCollide
                    and a1_2:GetAttribute("BreakableDoorDebris") ~= true
                    and not a1_2:IsDescendantOf(a1) then
                    if u66 ~= nil then
                        u66:Disconnect()
                        u66 = nil
                    end
                    ;(Sound.new("BreakableDoor")):PlaySoundAtPosition({Class = "BreakableDoor", Name = "Part Hit Ground", Position = u51.Position})
                    return
                end
            end)
            u51.Parent = Debris_2
            Debris:AddItem(u51, 8)
            u51:ApplyImpulse((Unit + Vector3.new(0, 0.3499999940395355, 0)) * u51.AssemblyMass * (math.random(20, 35)))
        end
    end
end

local function applyStage(a1) -- Line: 382 -- upvalues: u81 (val), releaseVisualStage (val) -- types: a1: userdata
    local v1 = u81[a1]
    if v1 == nil then
        return
    end
    local v2 = a1:GetAttribute("Stage") or 0
    for i = v1.Stage + 1, v2 do
        releaseVisualStage(a1, i)
    end
    v1.Stage = v2
end

return (Observers.observeTag("BreakableDoor", function(a1) -- Line: 394
    -- upvalues: Janitor (val), u73 (val), u81 (val), refreshTrajectory (val), MoverTrajectory (val), applyStage (val)
    -- upvalues: u74 (ref)
    local StageParts, v1, v2, v3
    if not a1:IsA("Model") then
        return nil
    end
    local u121 = Janitor.new()
    local v4 = {CorrectionElapsed = 0, CorrectionSeconds = 0, Stage = a1:GetAttribute("Stage") or 0}
    v4.StageParts = {}
    v4.Transparencies = {}
    u73[a1] = true
    u81[a1] = v4
    for i, j in a1:GetChildren() do
        if j:IsA("BasePart") then
            v2 = tonumber((j.Name:match("^Stage(%d)Break$")))
            if v2 ~= nil then
                StageParts = v4.StageParts
                v1 = v4.StageParts[v2] or {}
                StageParts[v2] = v1
                v3 = v4.StageParts[v2]
                v3[#v4.StageParts[v2] + 1] = j
                v4.Transparencies[j] = j.Transparency
            end
        end
    end
    refreshTrajectory(a1)
    u121:Add((MoverTrajectory.ClientDescriptorChanged:Connect(function(a1_2) -- Line: 419 -- upvalues: a1 (val), MoverTrajectory (upval), refreshTrajectory (upval)
        if a1:GetAttribute(MoverTrajectory.Attributes.Id) == a1_2 then
            refreshTrajectory(a1)
        end
    end)))
    for k, n in {MoverTrajectory.Attributes.Id, MoverTrajectory.Attributes.Revision} do
        u121:Add(((a1:GetAttributeChangedSignal(n)):Connect(function() -- Line: 425 -- upvalues: refreshTrajectory (upval), a1 (val)
            refreshTrajectory(a1)
        end)))
    end
    u121:Add(((a1:GetAttributeChangedSignal("Stage")):Connect(function() -- Line: 429 -- upvalues: applyStage (upval), a1 (val)
        applyStage(a1)
    end)))
    u121:Add(function() -- Line: 432 -- upvalues: u73 (upval), a1 (val), u81 (upval), u74 (upval)
        u73[a1] = nil
        u81[a1] = nil
        if next(u81) == nil and u74 ~= nil then
            u74:Disconnect()
            u74 = nil
        end
    end)
    return function() -- Line: 440 -- upvalues: u121 (val)
        u121:Destroy()
    end
end))