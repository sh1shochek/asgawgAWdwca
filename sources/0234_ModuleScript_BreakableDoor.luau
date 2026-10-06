-- Decompiled with Potassium's decompiler.

local Debris = game:GetService("Debris");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local MoverTrajectory = require(ReplicatedStorage.MovementV2.MoverTrajectory);
local DiagnosticProtocol = require(ReplicatedStorage.MovementV2.DiagnosticProtocol);
local DoorSwing = require(ReplicatedStorage.MovementV2.DoorSwing);
local Serial = require(ReplicatedStorage.MovementV2.Serial);
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Sound = require(ReplicatedStorage.Classes.Sound);
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local u1 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
local u2 = {};
local u3 = nil;
local SwingRate = DoorSwing.SwingRate;

local function diagnosticsEnabled() -- Line: 37
    -- upvalues: DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy)
    local v4 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

    return v4;
end;

local u5 = {};

local function setPose(p6: userdata, p7) -- Line: 70
    if p6.Parent == nil then
        return;
    end;

    local BreakableDoorHingePivot = p6:FindFirstChild("BreakableDoorHingePivot");

    if BreakableDoorHingePivot == nil or not BreakableDoorHingePivot:IsA("BasePart") then
        return;
    end;

    if p6.PrimaryPart ~= BreakableDoorHingePivot then
        p6.PrimaryPart = BreakableDoorHingePivot;
    end;

    p6:PivotTo(p7);
end;

local function rotationDistance(p8, p9) -- Line: 85
    local _, v10 = p8.Rotation:ToObjectSpace(p9.Rotation):ToAxisAngle();

    return math.abs(v10);
end;

local function posesDiffer(p11, p12) -- Line: 90
    local _, v13 = p11.Rotation:ToObjectSpace(p12.Rotation):ToAxisAngle();

    return math.abs(v13) > 0.0001 and true or (p11.Position - p12.Position).Magnitude > 0.0001;
end;

local function swingRate(p14) -- Line: 95
    -- upvalues: SwingRate (copy)
    if not p14.Moving then
        return SwingRate;
    end;

    local _, v15 = p14.StartPose.Rotation:ToObjectSpace(p14.TargetPose.Rotation):ToAxisAngle();
    local v16 = math.abs(v15) / math.max(p14.DurationSeconds, 0.001);

    return math.max(v16, SwingRate);
end;

local function presentationTarget(p17: any, p18: number) -- Line: 104
    -- upvalues: MoverTrajectory (copy), Serial (copy)
    local ClientPresentation = MoverTrajectory.GetClientPresentation(p17.Id);
    local ClientPresentationClock, v19 = MoverTrajectory.GetClientPresentationClock();

    if ClientPresentation == nil or ClientPresentationClock == nil then
        local v20 = MoverTrajectory.EvaluateTime(p17, p18);

        return {
            Predicted = false,
            Discontinuity = 0,
            Pose = v20,
            RestPose = v20,
            Moving = MoverTrajectory.PresentationMoving(p17, p18),
            Descriptor = p17
        };
    end;

    local v21 = Serial.deltaUInt32(ClientPresentationClock, ClientPresentation.ServerTick);
    local v22;

    if v21 == 0 then
        v22 = ClientPresentation.PreviousPose:Lerp(ClientPresentation.Pose, v19);
    elseif v21 < 0 then
        v22 = ClientPresentation.PreviousPose;
    else
        v22 = ClientPresentation.Pose;
    end;

    return {
        Predicted = true,
        Pose = v22,
        RestPose = ClientPresentation.Pose,
        Moving = ClientPresentation.PreviousPose ~= ClientPresentation.Pose,
        Discontinuity = ClientPresentation.Discontinuity,
        Descriptor = ClientPresentation.Descriptor
    };
end;

local function stepTowardPose(p23, p24, p25: any, p26: number) -- Line: 134
    -- upvalues: SwingRate (copy)
    local _, v27 = p23.Rotation:ToObjectSpace(p24.Rotation):ToAxisAngle();
    local math_abs_ret = math.abs(v27);
    local Magnitude = (p24.Position - p23.Position).Magnitude;

    if math_abs_ret <= 0.0001 and Magnitude <= 0.0001 then
        return p24;
    end;

    local Magnitude2 = (p25.TargetPose.Position - p25.StartPose.Position).Magnitude;
    local math_max_ret = math.max(p25.DurationSeconds, 0.001);
    local v28;

    if p25.Moving then
        local _, v29 = p25.StartPose.Rotation:ToObjectSpace(p25.TargetPose.Rotation):ToAxisAngle();
        local v30 = math.abs(v29) / math.max(p25.DurationSeconds, 0.001);
        v28 = math.max(v30, SwingRate);
    else
        v28 = SwingRate;
    end;

    local math_max_ret2 = math.max(Magnitude2 / math_max_ret, 8);
    local v31 = 1;

    if math_abs_ret > 0.0001 then
        local v32 = v28 * 1.5 * math.max(p26, 0);
        local v33 = math.min(v32, 0.20943951023931956) / math_abs_ret;
        v31 = math.min(v31, v33);
    end;

    if Magnitude > 0.0001 then
        local v34 = math_max_ret2 * 1.5 * math.max(p26, 0) / Magnitude;
        v31 = math.min(v31, v34);
    end;

    return p23:Lerp(p24, (math.clamp(v31, 0, 1)));
end;

local function correctedPose(p35: table, p36: table, p37: number) -- Line: 163
    -- upvalues: SwingRate (copy)
    if p35.SeenDiscontinuity ~= p36.Discontinuity then
        p35.SeenDiscontinuity = p36.Discontinuity;
        local CurrentPose = p35.CurrentPose;
        p35.CorrectionOffset = nil;

        if CurrentPose ~= nil then
            local Pose = p36.Pose;
            local _, v38 = CurrentPose.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle();

            if math.abs(v38) > 0.0001 and true or (CurrentPose.Position - Pose.Position).Magnitude > 0.0001 then
                local v39 = p36.Pose:ToObjectSpace(CurrentPose);
                local _, v40 = v39:ToAxisAngle();
                local math_abs_ret = math.abs(v40);
                local Descriptor = p36.Descriptor;
                local v41;

                if Descriptor.Moving then
                    local _, v42 = Descriptor.StartPose.Rotation:ToObjectSpace(Descriptor.TargetPose.Rotation):ToAxisAngle();
                    local v43 = math.abs(v42) / math.max(Descriptor.DurationSeconds, 0.001);
                    v41 = math.max(v43, SwingRate);
                else
                    v41 = SwingRate;
                end;

                local math_max_ret = math.max(math_abs_ret / v41, v39.Position.Magnitude / 8);
                p35.CorrectionOffset = v39;
                p35.CorrectionElapsed = 0;
                p35.CorrectionSeconds = math.min(0.1, math_max_ret);
            end;
        end;
    end;

    local CorrectionOffset = p35.CorrectionOffset;

    if CorrectionOffset == nil then
        return p36.Pose;
    end;

    p35.CorrectionElapsed = p35.CorrectionElapsed + math.max(p37, 0);
    local v44 = 1 - p35.CorrectionElapsed / math.max(p35.CorrectionSeconds, 0.001);

    if v44 > 0 then
        return p36.Pose * CFrame.identity:Lerp(CorrectionOffset, v44);
    end;

    p35.CorrectionOffset = nil;

    return p36.Pose;
end;

local function stepVisuals(p45: number) -- Line: 193
    -- upvalues: u5 (copy), presentationTarget (copy), correctedPose (copy), stepTowardPose (copy), DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy), MoverTrajectory (copy), u3 (ref)
    local ServerTimeNow = workspace:GetServerTimeNow();
    local v46 = false;

    for i, v in u5 do
        local Descriptor = v.Descriptor;

        if i.Parent == nil then
            u5[i] = nil;
        elseif Descriptor ~= nil then
            local v47 = presentationTarget(Descriptor, ServerTimeNow);
            local v48 = v.CurrentPose or i:GetPivot();
            local v49;

            if v47.Predicted then
                v49 = correctedPose(v, v47, p45);
            else
                v49 = stepTowardPose(v48, v47.Pose, Descriptor, p45);
            end;

            local v50 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

            if v50 and (Descriptor.Moving and v.LoggedMotionRevision ~= Descriptor.Revision) then
                local _, v51 = v49.Rotation:ToObjectSpace(v48.Rotation):ToAxisAngle();

                if math.abs(v51) > 0.0001 and true or (v49.Position - v48.Position).Magnitude > 0.0001 then
                    v.LoggedMotionRevision = Descriptor.Revision;
                    print(string.format("[MovementV2.Door] visual-start id=%d revision=%d clientTime=%.6f descriptorAge=%.4f", Descriptor.Id, Descriptor.Revision, ServerTimeNow, ServerTimeNow - Descriptor.StartServerTime));
                end;
            end;

            v.CurrentPose = v49;

            if i.Parent ~= nil then
                local BreakableDoorHingePivot = i:FindFirstChild("BreakableDoorHingePivot");

                if BreakableDoorHingePivot ~= nil and BreakableDoorHingePivot:IsA("BasePart") then
                    if i.PrimaryPart ~= BreakableDoorHingePivot then
                        i.PrimaryPart = BreakableDoorHingePivot;
                    end;

                    i:PivotTo(v49);
                end;
            end;

            if v47.Moving or (v.CorrectionOffset ~= nil or MoverTrajectory.PresentationMoving(Descriptor, ServerTimeNow)) then
                v46 = true;
            else
                local RestPose = v47.RestPose;
                local _, v52 = v49.Rotation:ToObjectSpace(RestPose.Rotation):ToAxisAngle();

                if math.abs(v52) > 0.0001 and true or (v49.Position - RestPose.Position).Magnitude > 0.0001 then
                    v46 = true;
                end;
            end;
        end;
    end;

    if not v46 and u3 ~= nil then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function ensureRenderConnection() -- Line: 241
    -- upvalues: u3 (ref), RunServiceController (copy), stepVisuals (copy)
    if u3 == nil then
        u3 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals);
    end;
end;

local function refreshTrajectory(p53: userdata) -- Line: 252
    -- upvalues: u5 (copy), MoverTrajectory (copy), presentationTarget (copy), DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy), u3 (ref), RunServiceController (copy), stepVisuals (copy)
    local v54 = u5[p53];

    if v54 == nil then
        return;
    end;

    local v55 = MoverTrajectory.Read(p53);

    if v55 == nil then
        return;
    end;

    local v56 = v54.Descriptor == nil;
    local v57;

    if v54.Descriptor == nil then
        v57 = nil;
    else
        v57 = v54.Descriptor.Revision;
    end;

    v54.Descriptor = v55;
    local ServerTimeNow = workspace:GetServerTimeNow();
    local v58 = presentationTarget(v55, ServerTimeNow);
    local v59 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

    if v59 and v55.Revision ~= v57 then
        print(string.format("[MovementV2.Door] descriptor id=%d revision=%d moving=%s clientTime=%.6f startTime=%.6f descriptorAge=%.4f", v55.Id, v55.Revision, tostring(v55.Moving), ServerTimeNow, v55.StartServerTime, ServerTimeNow - v55.StartServerTime));
    end;

    if v56 then
        v54.CurrentPose = v58.Pose;
        v54.SeenDiscontinuity = v58.Discontinuity;
        local Pose = v58.Pose;

        if p53.Parent ~= nil then
            local BreakableDoorHingePivot = p53:FindFirstChild("BreakableDoorHingePivot");

            if BreakableDoorHingePivot ~= nil and BreakableDoorHingePivot:IsA("BasePart") then
                if p53.PrimaryPart ~= BreakableDoorHingePivot then
                    p53.PrimaryPart = BreakableDoorHingePivot;
                end;

                p53:PivotTo(Pose);
            end;
        end;
    end;

    local v60 = v54.CurrentPose or p53:GetPivot();

    if v55.Moving or (v58.Moving or v58.Discontinuity ~= v54.SeenDiscontinuity) then
        if u3 == nil then
            u3 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals);
        end;
    else
        local Pose = v58.Pose;
        local _, v61 = v60.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle();

        if math.abs(v61) > 0.0001 and true or (v60.Position - Pose.Position).Magnitude > 0.0001 then
            if u3 == nil then
                u3 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals);
            end;
        end;
    end;
end;

local function useMouseDoor() -- Line: 295
    -- upvalues: Mouse (copy), u2 (copy), CharacterController (copy), DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy), Remotes (copy)
    local Target = Mouse.Target;

    while Target ~= nil do
        if Target:IsA("Model") and u2[Target] then
            if not CharacterController.IsDoorInUseRange(Target) then
                return;
            end;

            local v62 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

            if v62 then
                print(string.format("[MovementV2.Door] use-send source=Mouse model=%s clientTime=%.6f", Target:GetFullName(), workspace:GetServerTimeNow()));
            end;

            local v63 = CharacterController.PredictDoorUse(Target);
            local Send = Remotes.BreakableDoor.Use.Send;
            local v64 = {
                Model = Target
            };
            local v65;

            if v63 == nil then
                v65 = nil;
            else
                v65 = v63.ServerTick;
            end;

            v64.ServerTick = v65;
            local v66;

            if v63 == nil then
                v66 = nil;
            else
                v66 = v63.TargetAngle;
            end;

            v64.TargetAngle = v66;
            local v67;

            if v63 == nil then
                v67 = nil;
            else
                v67 = v63.RequestId;
            end;

            v64.RequestId = v67;
            Send(v64);

            return;
        end;

        Target = Target.Parent;
    end;
end;

Mouse.Button1Down:Connect(function() -- Line: 325
    -- upvalues: u1 (copy), useMouseDoor (copy)
    if not u1 then
        useMouseDoor();
    end;
end);

local function releaseVisualStage(u68: userdata, p69: number) -- Line: 331
    -- upvalues: u5 (copy), Sound (copy), Debris (copy)
    local v70 = u5[u68];

    if v70 == nil then
        return;
    end;

    local v71 = u68:GetAttribute("BreakDirectionX") or 0;
    local v72 = u68:GetAttribute("BreakDirectionY") or 0;
    local v73 = u68:GetAttribute("BreakDirectionZ") or 0;
    local Vector3_new_ret = Vector3.new(v71, v72, v73);
    local v74 = Vector3_new_ret.Magnitude <= 0 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;
    local v75 = workspace:FindFirstChild("Debris") or workspace;

    for _, v in v70.StageParts[p69] or {} do
        if v.Parent ~= nil then
            local u76 = v:Clone();
            u76.Transparency = v70.Transparencies[v] or 0;
            u76.Anchored = false;
            u76.CanCollide = true;
            u76.CanQuery = false;
            u76.CanTouch = true;
            u76.CFrame = v.CFrame;
            u76:SetAttribute("BreakableDoorDebris", true);
            local u77 = nil;
            u77 = u76.Touched:Connect(function(p78: userdata) -- Line: 357
                -- upvalues: u68 (copy), u77 (ref), Sound (ref), u76 (copy)
                if not (p78.CanCollide and (p78:GetAttribute("BreakableDoorDebris") ~= true and not p78:IsDescendantOf(u68))) then
                    return;
                end;

                if u77 ~= nil then
                    u77:Disconnect();
                    u77 = nil;
                end;

                Sound.new("BreakableDoor"):PlaySoundAtPosition({
                    Class = "BreakableDoor",
                    Name = "Part Hit Ground",
                    Position = u76.Position
                });
            end);
            u76.Parent = v75;
            Debris:AddItem(u76, 8);
            u76:ApplyImpulse((v74 + Vector3.new(0, 0.35, 0)) * u76.AssemblyMass * math.random(20, 35));
        end;
    end;
end;

local function applyStage(p79: userdata) -- Line: 382
    -- upvalues: u5 (copy), releaseVisualStage (copy)
    local v80 = u5[p79];

    if v80 == nil then
        return;
    end;

    local v81 = p79:GetAttribute("Stage") or 0;

    for i = v80.Stage + 1, v81 do
        releaseVisualStage(p79, i);
        local _ = i;
    end;

    v80.Stage = v81;
end;

return Observers.observeTag("BreakableDoor", function(u82: userdata) -- Line: 394
    -- upvalues: Janitor (copy), u2 (copy), u5 (copy), refreshTrajectory (copy), MoverTrajectory (copy), applyStage (copy), u3 (ref)
    if not u82:IsA("Model") then
        return nil;
    end;

    local u83 = Janitor.new();
    local v84 = {
        CorrectionElapsed = 0,
        CorrectionSeconds = 0,
        Stage = u82:GetAttribute("Stage") or 0,
        StageParts = {},
        Transparencies = {}
    };
    u2[u82] = true;
    u5[u82] = v84;

    for _, child in u82:GetChildren() do
        if child:IsA("BasePart") then
            local v85 = tonumber(child.Name:match("^Stage(%d)Break$"));

            if v85 ~= nil then
                v84.StageParts[v85] = v84.StageParts[v85] or {};
                v84.StageParts[v85][#v84.StageParts[v85] + 1] = child;
                v84.Transparencies[child] = child.Transparency;
            end;
        end;
    end;

    refreshTrajectory(u82);
    u83:Add(MoverTrajectory.ClientDescriptorChanged:Connect(function(p86) -- Line: 419
        -- upvalues: u82 (copy), MoverTrajectory (ref), refreshTrajectory (ref)
        if u82:GetAttribute(MoverTrajectory.Attributes.Id) == p86 then
            refreshTrajectory(u82);
        end;
    end));

    for _, v in { MoverTrajectory.Attributes.Id, MoverTrajectory.Attributes.Revision } do
        u83:Add(u82:GetAttributeChangedSignal(v):Connect(function() -- Line: 425
            -- upvalues: refreshTrajectory (ref), u82 (copy)
            refreshTrajectory(u82);
        end));
    end;

    u83:Add(u82:GetAttributeChangedSignal("Stage"):Connect(function() -- Line: 429
        -- upvalues: applyStage (ref), u82 (copy)
        applyStage(u82);
    end));
    u83:Add(function() -- Line: 432
        -- upvalues: u2 (ref), u82 (copy), u5 (ref), u3 (ref)
        u2[u82] = nil;
        u5[u82] = nil;

        if next(u5) == nil and u3 ~= nil then
            u3:Disconnect();
            u3 = nil;
        end;
    end);

    return function() -- Line: 440
        -- upvalues: u83 (copy)
        u83:Destroy();
    end;
end);