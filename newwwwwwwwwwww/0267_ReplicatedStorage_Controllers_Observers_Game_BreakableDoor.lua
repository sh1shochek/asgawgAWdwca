-- BreakableDoor (ModuleScript)
-- full path: ReplicatedStorage.Controllers.Observers.Game.BreakableDoor

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

local function diagnosticsEnabled() -- Line: 38
    -- upvalues: DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy)
    local v4 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

    return v4;
end;

local u5 = {};

local function captureLayout(p6: userdata, p7: table) -- Line: 75
    local BreakableDoorHingePivot = p6:FindFirstChild("BreakableDoorHingePivot");

    if BreakableDoorHingePivot == nil or not BreakableDoorHingePivot:IsA("BasePart") then
        return false;
    end;

    local Attribute = p6:GetAttribute("DoorClosedPivot");
    local v8;

    if typeof(Attribute) == "CFrame" then
        v8 = Attribute.Position;
    else
        v8 = BreakableDoorHingePivot.Position;
    end;

    p7.HingePosition = v8;
    table.clear(p7.LayoutParts);
    table.clear(p7.LayoutOffsets);

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("BasePart") then
            p7.LayoutParts[#p7.LayoutParts + 1] = descendant;
            p7.LayoutOffsets[#p7.LayoutOffsets + 1] = BreakableDoorHingePivot.CFrame:ToObjectSpace(descendant.CFrame);
        end;
    end;

    return true;
end;

local function setPose(p9: userdata, p10: table, p11) -- Line: 95
    -- upvalues: captureLayout (copy)
    if p9.Parent == nil then
        return;
    end;

    if p10.HingePosition == nil and not captureLayout(p9, p10) then
        return;
    end;

    local HingePosition = p10.HingePosition;
    local Magnitude = (p11.Position - HingePosition).Magnitude;

    if Magnitude > 0.25 and not p10.WarnedDrift then
        p10.WarnedDrift = true;
        local Descriptor = p10.Descriptor;
        local v12 = warn;
        local string_format = string.format;
        local FullName = p9:GetFullName();
        local v13;

        if Descriptor then
            v13 = Descriptor.Id;
        else
            v13 = Descriptor;
        end;

        local v14 = tostring(v13);
        local v15;

        if Descriptor then
            v15 = Descriptor.Revision;
        else
            v15 = Descriptor;
        end;

        local v16 = tostring(v15);

        if Descriptor then
            Descriptor = Descriptor.Moving;
        end;

        v12(string_format("[BreakableDoor] presented pose left its hinge by %.2f studs model=%s id=%s revision=%s moving=%s", Magnitude, FullName, v14, v16, (tostring(Descriptor))));
    end;

    local v17 = CFrame.new(HingePosition) * p11.Rotation;
    local v18 = {};
    local v19 = {};

    for i, v in p10.LayoutParts do
        if v.Parent ~= nil then
            v18[#v18 + 1] = v;
            v19[#v19 + 1] = v17 * p10.LayoutOffsets[i];
        end;
    end;

    workspace:BulkMoveTo(v18, v19, Enum.BulkMoveMode.FireCFrameChanged);
end;

local function rotationDistance(p20, p21) -- Line: 131
    local _, v22 = p20.Rotation:ToObjectSpace(p21.Rotation):ToAxisAngle();

    return math.abs(v22);
end;

local function posesDiffer(p23, p24) -- Line: 136
    local _, v25 = p23.Rotation:ToObjectSpace(p24.Rotation):ToAxisAngle();

    return math.abs(v25) > 0.0001 and true or (p23.Position - p24.Position).Magnitude > 0.0001;
end;

local function swingRate(p26) -- Line: 141
    -- upvalues: SwingRate (copy)
    if not p26.Moving then
        return SwingRate;
    end;

    local _, v27 = p26.StartPose.Rotation:ToObjectSpace(p26.TargetPose.Rotation):ToAxisAngle();
    local v28 = math.abs(v27) / math.max(p26.DurationSeconds, 0.001);

    return math.max(v28, SwingRate);
end;

local function presentationTarget(p29: any, p30: number) -- Line: 150
    -- upvalues: MoverTrajectory (copy), Serial (copy)
    local ClientPresentation = MoverTrajectory.GetClientPresentation(p29.Id);
    local ClientPresentationClock, v31 = MoverTrajectory.GetClientPresentationClock();

    if ClientPresentation == nil or ClientPresentationClock == nil then
        local v32 = MoverTrajectory.EvaluateTime(p29, p30);

        return {
            Predicted = false,
            Discontinuity = 0,
            Pose = v32,
            RestPose = v32,
            Moving = MoverTrajectory.PresentationMoving(p29, p30),
            Descriptor = p29
        };
    end;

    local v33 = Serial.deltaUInt32(ClientPresentationClock, ClientPresentation.ServerTick);
    local v34;

    if v33 == 0 then
        v34 = ClientPresentation.PreviousPose:Lerp(ClientPresentation.Pose, v31);
    elseif v33 < 0 then
        v34 = ClientPresentation.PreviousPose;
    else
        v34 = ClientPresentation.Pose;
    end;

    return {
        Predicted = true,
        Pose = v34,
        RestPose = ClientPresentation.Pose,
        Moving = ClientPresentation.PreviousPose ~= ClientPresentation.Pose,
        Discontinuity = ClientPresentation.Discontinuity,
        Descriptor = ClientPresentation.Descriptor
    };
end;

local function stepTowardPose(p35, p36, p37: any, p38: number) -- Line: 180
    -- upvalues: SwingRate (copy)
    local _, v39 = p35.Rotation:ToObjectSpace(p36.Rotation):ToAxisAngle();
    local math_abs_ret = math.abs(v39);
    local Magnitude = (p36.Position - p35.Position).Magnitude;

    if math_abs_ret <= 0.0001 and Magnitude <= 0.0001 then
        return p36;
    end;

    local Magnitude2 = (p37.TargetPose.Position - p37.StartPose.Position).Magnitude;
    local math_max_ret = math.max(p37.DurationSeconds, 0.001);
    local v40;

    if p37.Moving then
        local _, v41 = p37.StartPose.Rotation:ToObjectSpace(p37.TargetPose.Rotation):ToAxisAngle();
        local v42 = math.abs(v41) / math.max(p37.DurationSeconds, 0.001);
        v40 = math.max(v42, SwingRate);
    else
        v40 = SwingRate;
    end;

    local math_max_ret2 = math.max(Magnitude2 / math_max_ret, 8);
    local v43 = 1;

    if math_abs_ret > 0.0001 then
        local v44 = v40 * 1.5 * math.max(p38, 0);
        local v45 = math.min(v44, 0.20943951023931956) / math_abs_ret;
        v43 = math.min(v43, v45);
    end;

    if Magnitude > 0.0001 then
        local v46 = math_max_ret2 * 1.5 * math.max(p38, 0) / Magnitude;
        v43 = math.min(v43, v46);
    end;

    return p35:Lerp(p36, (math.clamp(v43, 0, 1)));
end;

local function correctedPose(p47: table, p48: table, p49: number) -- Line: 209
    -- upvalues: SwingRate (copy)
    if p47.SeenDiscontinuity ~= p48.Discontinuity then
        p47.SeenDiscontinuity = p48.Discontinuity;
        local CurrentPose = p47.CurrentPose;
        p47.CorrectionOffset = nil;

        if CurrentPose ~= nil then
            local Pose = p48.Pose;
            local _, v50 = CurrentPose.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle();

            if math.abs(v50) > 0.0001 and true or (CurrentPose.Position - Pose.Position).Magnitude > 0.0001 then
                local v51 = p48.Pose:ToObjectSpace(CurrentPose);
                local _, v52 = v51:ToAxisAngle();
                local math_abs_ret = math.abs(v52);
                local Descriptor = p48.Descriptor;
                local v53;

                if Descriptor.Moving then
                    local _, v54 = Descriptor.StartPose.Rotation:ToObjectSpace(Descriptor.TargetPose.Rotation):ToAxisAngle();
                    local v55 = math.abs(v54) / math.max(Descriptor.DurationSeconds, 0.001);
                    v53 = math.max(v55, SwingRate);
                else
                    v53 = SwingRate;
                end;

                local math_max_ret = math.max(math_abs_ret / v53, v51.Position.Magnitude / 8);
                p47.CorrectionOffset = v51;
                p47.CorrectionElapsed = 0;
                p47.CorrectionSeconds = math.min(0.1, math_max_ret);
            end;
        end;
    end;

    local CorrectionOffset = p47.CorrectionOffset;

    if CorrectionOffset == nil then
        return p48.Pose;
    end;

    p47.CorrectionElapsed = p47.CorrectionElapsed + math.max(p49, 0);
    local v56 = 1 - p47.CorrectionElapsed / math.max(p47.CorrectionSeconds, 0.001);

    if v56 > 0 then
        return p48.Pose * CFrame.identity:Lerp(CorrectionOffset, v56);
    end;

    p47.CorrectionOffset = nil;

    return p48.Pose;
end;

local function stepVisuals(p57: number) -- Line: 239
    -- upvalues: u5 (copy), presentationTarget (copy), correctedPose (copy), stepTowardPose (copy), DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy), setPose (copy), MoverTrajectory (copy), u3 (ref)
    local ServerTimeNow = workspace:GetServerTimeNow();
    local v58 = false;

    for i, v in u5 do
        local Descriptor = v.Descriptor;

        if i.Parent == nil then
            u5[i] = nil;
        elseif Descriptor ~= nil then
            local v59 = presentationTarget(Descriptor, ServerTimeNow);
            local v60 = v.CurrentPose or i:GetPivot();
            local v61;

            if v59.Predicted then
                v61 = correctedPose(v, v59, p57);
            else
                v61 = stepTowardPose(v60, v59.Pose, Descriptor, p57);
            end;

            local v62 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

            if v62 and (Descriptor.Moving and v.LoggedMotionRevision ~= Descriptor.Revision) then
                local _, v63 = v61.Rotation:ToObjectSpace(v60.Rotation):ToAxisAngle();

                if math.abs(v63) > 0.0001 and true or (v61.Position - v60.Position).Magnitude > 0.0001 then
                    v.LoggedMotionRevision = Descriptor.Revision;
                    print(string.format("[MovementV2.Door] visual-start id=%d revision=%d clientTime=%.6f descriptorAge=%.4f", Descriptor.Id, Descriptor.Revision, ServerTimeNow, ServerTimeNow - Descriptor.StartServerTime));
                end;
            end;

            v.CurrentPose = v61;
            setPose(i, v, v61);

            if v59.Moving or (v.CorrectionOffset ~= nil or MoverTrajectory.PresentationMoving(Descriptor, ServerTimeNow)) then
                v58 = true;
            else
                local RestPose = v59.RestPose;
                local _, v64 = v61.Rotation:ToObjectSpace(RestPose.Rotation):ToAxisAngle();

                if math.abs(v64) > 0.0001 and true or (v61.Position - RestPose.Position).Magnitude > 0.0001 then
                    v58 = true;
                end;
            end;
        end;
    end;

    if not v58 and u3 ~= nil then
        u3:Disconnect();
        u3 = nil;
    end;
end;

local function ensureRenderConnection() -- Line: 287
    -- upvalues: u3 (ref), RunServiceController (copy), stepVisuals (copy)
    if u3 == nil then
        u3 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals);
    end;
end;

local function refreshTrajectory(p65: userdata) -- Line: 298
    -- upvalues: u5 (copy), MoverTrajectory (copy), presentationTarget (copy), DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy), setPose (copy), u3 (ref), RunServiceController (copy), stepVisuals (copy)
    local v66 = u5[p65];

    if v66 == nil then
        return;
    end;

    local v67 = MoverTrajectory.Read(p65);

    if v67 == nil then
        return;
    end;

    local v68 = v66.Descriptor == nil;
    local v69;

    if v66.Descriptor == nil then
        v69 = nil;
    else
        v69 = v66.Descriptor.Revision;
    end;

    v66.Descriptor = v67;
    local ServerTimeNow = workspace:GetServerTimeNow();
    local v70 = presentationTarget(v67, ServerTimeNow);
    local v71 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

    if v71 and v67.Revision ~= v69 then
        print(string.format("[MovementV2.Door] descriptor id=%d revision=%d moving=%s clientTime=%.6f startTime=%.6f descriptorAge=%.4f", v67.Id, v67.Revision, tostring(v67.Moving), ServerTimeNow, v67.StartServerTime, ServerTimeNow - v67.StartServerTime));
    end;

    if v68 then
        v66.CurrentPose = v70.Pose;
        v66.SeenDiscontinuity = v70.Discontinuity;
        setPose(p65, v66, v70.Pose);
    end;

    local v72 = v66.CurrentPose or p65:GetPivot();

    if v67.Moving or (v70.Moving or v70.Discontinuity ~= v66.SeenDiscontinuity) then
        if u3 == nil then
            u3 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals);
        end;
    else
        local Pose = v70.Pose;
        local _, v73 = v72.Rotation:ToObjectSpace(Pose.Rotation):ToAxisAngle();

        if math.abs(v73) > 0.0001 and true or (v72.Position - Pose.Position).Magnitude > 0.0001 then
            if u3 == nil then
                u3 = RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", Enum.RenderPriority.Last.Value, stepVisuals);
            end;
        end;
    end;
end;

local function useMouseDoor() -- Line: 341
    -- upvalues: Mouse (copy), u2 (copy), CharacterController (copy), DiagnosticProtocol (copy), LocalPlayer (copy), Workspace (copy), Remotes (copy)
    local Target = Mouse.Target;

    while Target ~= nil do
        if Target:IsA("Model") and u2[Target] then
            if not CharacterController.IsDoorInUseRange(Target) then
                return;
            end;

            local v74 = DiagnosticProtocol.shouldOutputForPlayer(LocalPlayer) and Workspace:GetAttribute("MovementV2DoorDebug") == true;

            if v74 then
                print(string.format("[MovementV2.Door] use-send source=Mouse model=%s clientTime=%.6f", Target:GetFullName(), workspace:GetServerTimeNow()));
            end;

            local v75 = CharacterController.PredictDoorUse(Target);
            local Send = Remotes.BreakableDoor.Use.Send;
            local v76 = {
                Model = Target
            };
            local v77;

            if v75 == nil then
                v77 = nil;
            else
                v77 = v75.ServerTick;
            end;

            v76.ServerTick = v77;
            local v78;

            if v75 == nil then
                v78 = nil;
            else
                v78 = v75.TargetAngle;
            end;

            v76.TargetAngle = v78;
            local v79;

            if v75 == nil then
                v79 = nil;
            else
                v79 = v75.RequestId;
            end;

            v76.RequestId = v79;
            Send(v76);

            return;
        end;

        Target = Target.Parent;
    end;
end;

Mouse.Button1Down:Connect(function() -- Line: 371
    -- upvalues: u1 (copy), useMouseDoor (copy)
    if not u1 then
        useMouseDoor();
    end;
end);

local function releaseVisualStage(u80: userdata, p81: number) -- Line: 377
    -- upvalues: u5 (copy), Sound (copy), Debris (copy)
    local v82 = u5[u80];

    if v82 == nil then
        return;
    end;

    local v83 = u80:GetAttribute("BreakDirectionX") or 0;
    local v84 = u80:GetAttribute("BreakDirectionY") or 0;
    local v85 = u80:GetAttribute("BreakDirectionZ") or 0;
    local Vector3_new_ret = Vector3.new(v83, v84, v85);
    local v86 = Vector3_new_ret.Magnitude <= 0 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;
    local v87 = workspace:FindFirstChild("Debris") or workspace;

    for _, v in v82.StageParts[p81] or {} do
        if v.Parent ~= nil then
            local u88 = v:Clone();
            u88.Transparency = v82.Transparencies[v] or 0;
            u88.Anchored = false;
            u88.CanCollide = true;
            u88.CanQuery = false;
            u88.CanTouch = true;
            u88.CFrame = v.CFrame;
            u88:SetAttribute("BreakableDoorDebris", true);
            local u89 = nil;
            u89 = u88.Touched:Connect(function(p90: userdata) -- Line: 403
                -- upvalues: u80 (copy), u89 (ref), Sound (ref), u88 (copy)
                if not (p90.CanCollide and (p90:GetAttribute("BreakableDoorDebris") ~= true and not p90:IsDescendantOf(u80))) then
                    return;
                end;

                if u89 ~= nil then
                    u89:Disconnect();
                    u89 = nil;
                end;

                Sound.new("BreakableDoor"):PlaySoundAtPosition({
                    Class = "BreakableDoor",
                    Name = "Part Hit Ground",
                    Position = u88.Position
                });
            end);
            u88.Parent = v87;
            Debris:AddItem(u88, 8);
            u88:ApplyImpulse((v86 + Vector3.new(0, 0.35, 0)) * u88.AssemblyMass * math.random(20, 35));
        end;
    end;
end;

local function applyStage(p91: userdata) -- Line: 428
    -- upvalues: u5 (copy), releaseVisualStage (copy)
    local v92 = u5[p91];

    if v92 == nil then
        return;
    end;

    local v93 = p91:GetAttribute("Stage") or 0;

    for i = v92.Stage + 1, v93 do
        releaseVisualStage(p91, i);
        local _ = i;
    end;

    v92.Stage = v93;
end;

return Observers.observeTag("BreakableDoor", function(u94: userdata) -- Line: 440
    -- upvalues: Janitor (copy), u2 (copy), u5 (copy), refreshTrajectory (copy), MoverTrajectory (copy), applyStage (copy), u3 (ref)
    if not u94:IsA("Model") then
        return nil;
    end;

    local u95 = Janitor.new();
    local v96 = {
        CorrectionElapsed = 0,
        CorrectionSeconds = 0,
        WarnedDrift = false,
        Stage = u94:GetAttribute("Stage") or 0,
        StageParts = {},
        Transparencies = {},
        LayoutParts = {},
        LayoutOffsets = {}
    };
    u2[u94] = true;
    u5[u94] = v96;

    for _, child in u94:GetChildren() do
        if child:IsA("BasePart") then
            local v97 = tonumber(child.Name:match("^Stage(%d)Break$"));

            if v97 ~= nil then
                v96.StageParts[v97] = v96.StageParts[v97] or {};
                v96.StageParts[v97][#v96.StageParts[v97] + 1] = child;
                v96.Transparencies[child] = child.Transparency;
            end;
        end;
    end;

    refreshTrajectory(u94);
    u95:Add(MoverTrajectory.ClientDescriptorChanged:Connect(function(p98) -- Line: 468
        -- upvalues: u94 (copy), MoverTrajectory (ref), refreshTrajectory (ref)
        if u94:GetAttribute(MoverTrajectory.Attributes.Id) == p98 then
            refreshTrajectory(u94);
        end;
    end));

    for _, v in { MoverTrajectory.Attributes.Id, MoverTrajectory.Attributes.Revision } do
        u95:Add(u94:GetAttributeChangedSignal(v):Connect(function() -- Line: 474
            -- upvalues: refreshTrajectory (ref), u94 (copy)
            refreshTrajectory(u94);
        end));
    end;

    u95:Add(u94:GetAttributeChangedSignal("Stage"):Connect(function() -- Line: 478
        -- upvalues: applyStage (ref), u94 (copy)
        applyStage(u94);
    end));
    u95:Add(function() -- Line: 481
        -- upvalues: u2 (ref), u94 (copy), u5 (ref), u3 (ref)
        u2[u94] = nil;
        u5[u94] = nil;

        if next(u5) == nil and u3 ~= nil then
            u3:Disconnect();
            u3 = nil;
        end;
    end);

    return function() -- Line: 489
        -- upvalues: u95 (copy)
        u95:Destroy();
    end;
end);