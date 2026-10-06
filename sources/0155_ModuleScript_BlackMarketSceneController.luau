-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local BakedViewmodelMirror = require(ReplicatedStorage.Shared.BakedViewmodelMirror);
local SceneParking = require(ReplicatedStorage.Components.Common.SceneParking);
u1.OnActiveChanged = require(ReplicatedStorage.Packages.Signal).new();
local Router = require(ReplicatedStorage.Database.Security.Router);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local script_DealerLines = require(script.DealerLines);
local u2 = Enum.RenderPriority.Camera.Value + 10;
local Sine = Enum.EasingStyle.Sine;
local Random_new_ret = Random.new();
local Cubic = Enum.EasingStyle.Cubic;
local Back = Enum.EasingStyle.Back;
local u3 = {
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
    Ambient = Color3.fromRGB(68, 68, 68),
    OutdoorAmbient = Color3.fromRGB(120, 128, 143),
    ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
    ColorShift_Top = Color3.fromRGB(208, 168, 108)
};
local workspace_CurrentCamera = workspace.CurrentCamera;
local u4 = nil;
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = nil;
local u14 = nil;
local u15 = 1;
local u16 = {};
local u17 = {};
local u18 = false;
local u19 = false;
local u20 = Janitor.new();
local u21 = false;
local u22 = false;
local u23 = false;
local u24 = {};
local u25 = true;
local u26 = 0;
local u27 = nil;
local u28 = {};
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = 0;

local function applySceneLighting() -- Line: 226
    -- upvalues: u3 (copy), Lighting (copy)
    for i, v in u3 do
        Lighting[i] = v;
    end;

    for _, child in Lighting:GetChildren() do
        if child.Name ~= "Menu" then
            child:Destroy();
        end;
    end;
end;

local function setPerspectiveSinksInput(p37: boolean) -- Line: 253
    -- upvalues: Players (copy)
    local v38 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v38 then
        v38 = v38:FindFirstChild("MainGui");
    end;

    if v38 then
        v38 = v38:FindFirstChild("CameraPerspective");
    end;

    if not (v38 and v38:IsA("GuiButton")) then
        warn("[BlackMarketSceneController]: MainGui.CameraPerspective was not found, card clicks may be swallowed");

        return false;
    end;

    v38.Active = p37;
    v38.Interactable = p37;

    return true;
end;

local u39 = {};
local u40 = {};

local function hideInstance(p41: userdata) -- Line: 283
    -- upvalues: u39 (copy), u40 (copy)
    if not (p41:IsA("BasePart") or p41:IsA("Decal")) then
        if p41:IsA("SurfaceGui") and p41.Enabled then
            p41.Enabled = false;
            table.insert(u40, p41);
        end;

        return;
    end;

    if u39[p41] == nil then
        u39[p41] = p41.LocalTransparencyModifier;
    end;

    p41.LocalTransparencyModifier = 1;
end;

local function hideViewmodel(p42: userdata) -- Line: 296
    -- upvalues: hideInstance (copy)
    hideInstance(p42);

    for _, descendant in p42:GetDescendants() do
        hideInstance(descendant);
    end;
end;

local function showViewmodels() -- Line: 303
    -- upvalues: u39 (copy), u40 (copy)
    for i, v in u39 do
        if i.Parent then
            i.LocalTransparencyModifier = v;
        end;
    end;

    table.clear(u39);

    for _, v in u40 do
        if v.Parent then
            v.Enabled = true;
        end;
    end;

    table.clear(u40);
end;

local function isCameraAttachment(p43: userdata) -- Line: 319
    return p43:IsA("Model") or p43:IsA("BasePart");
end;

local function applyCardVisibility(p44: userdata, p45: boolean) -- Line: 334
    for _, child in p44:GetChildren() do
        if child:IsA("SurfaceGui") then
            child.Enabled = p45;
        end;
    end;
end;

local function isCardShown(p46: userdata) -- Line: 353
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    if u17[p46] == true and not (u18 or u19) then
        return not (u22 or u23) or u24[p46] == true;
    end;

    return false;
end;

local function refreshCardFaces(p47: userdata) -- Line: 363
    -- upvalues: applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    local v48;

    if u17[p47] == true and not (u18 or u19) then
        v48 = not (u22 or u23) or u24[p47] == true;
    else
        v48 = false;
    end;

    applyCardVisibility(p47, v48);
end;

local function syncCardVisibility() -- Line: 373
    -- upvalues: u5 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    for _, v in u5 do
        local v49;

        if u17[v] == true and not (u18 or u19) then
            v49 = not (u22 or u23) or u24[v] == true;
        else
            v49 = false;
        end;

        applyCardVisibility(v, v49);
    end;
end;

local function getMarker(p50: string) -- Line: 381
    -- upvalues: u4 (ref)
    local v51 = u4;

    if v51 then
        v51 = v51:FindFirstChild("Camera");
    end;

    if v51 then
        v51 = v51:FindFirstChild(p50);
    end;

    if not (v51 and (v51:IsA("BasePart") and v51)) then
        v51 = nil;
    end;

    return v51;
end;

local function moveCameraTo(p52: string) -- Line: 394
    -- upvalues: u4 (ref), u33 (ref), u34 (ref), u35 (ref)
    local v53 = u4;

    if v53 then
        v53 = v53:FindFirstChild("Camera");
    end;

    if v53 then
        v53 = v53:FindFirstChild(p52);
    end;

    if not (v53 and (v53:IsA("BasePart") and v53)) then
        v53 = nil;
    end;

    if not v53 then
        warn((`[BlackMarketSceneController]: scene is missing Camera.{p52}`));

        return;
    end;

    u33 = v53.CFrame;
    u34 = nil;
    u35 = nil;
end;

local function startIntroArc() -- Line: 413
    -- upvalues: u33 (ref), u34 (ref), u35 (ref), u36 (ref)
    local v54 = u33;

    if not v54 then
        return;
    end;

    u34 = -v54.LookVector * 6;
    u35 = Vector3.new(0, 4, 0);
    u36 = os.clock();
end;

local u55 = {
    face = "TopMost",
    ["Cube.002"] = "Tie",
    ["Cube.012"] = "UpperBody.001",
    UpperTorso = "UpperBody.001",
    ["Cube.003"] = "UpperLeg.L"
};

local function attachUnskinnedParts(p56: userdata) -- Line: 436
    -- upvalues: u55 (copy)
    for i, v in u55 do
        local v57 = p56:FindFirstChild(i);
        local v58 = p56:FindFirstChild(v, true);

        if v57 and (v57:IsA("MeshPart") and (v58 and (v58:IsA("Bone") and not v57.HasSkinnedMesh))) then
            for _, child in v57:GetChildren() do
                if child:IsA("Motor6D") and child.Part1 == v57 then
                    child.Enabled = false;
                end;
            end;

            local Attachment = Instance.new("Attachment");
            Attachment.Name = "BoneFollow";
            Attachment.CFrame = v57.CFrame:ToObjectSpace(v58.WorldCFrame);
            Attachment.Parent = v57;
            local RigidConstraint = Instance.new("RigidConstraint");
            RigidConstraint.Name = "BoneFollow";
            RigidConstraint.Attachment0 = Attachment;
            RigidConstraint.Attachment1 = v58;
            RigidConstraint.Parent = v57;
            v57.Anchored = false;
        end;
    end;
end;

local function bindDealer(p59: userdata) -- Line: 478
    -- upvalues: u27 (ref), attachUnskinnedParts (copy)
    local v60 = p59:FindFirstChildWhichIsA("AnimationController", true);
    local v61;

    if v60 then
        v61 = v60:FindFirstChildOfClass("Animator");
    else
        v61 = v60;
    end;

    if not v61 then
        warn("[BlackMarketSceneController]: the scene\'s dealer has no Animator, so he will not move");

        return;
    end;

    u27 = v61;
    attachUnskinnedParts(v60.Parent);
end;

local function getDealerTrack(p62: string) -- Line: 498
    -- upvalues: u27 (ref), u28 (copy)
    local v63 = u27;

    if not v63 then
        return nil;
    end;

    local v64 = u28[p62];

    if v64 then
        return v64;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p62;
    local v65 = v63:LoadAnimation(Animation);
    u28[p62] = v65;

    return v65;
end;

local function startDealerIdle() -- Line: 523
    -- upvalues: script_DealerLines (copy), u27 (ref), u28 (copy), u29 (ref)
    local IDLE_ANIMATION = script_DealerLines.IDLE_ANIMATION;
    local v66 = u27;
    local v67;

    if v66 then
        v67 = u28[IDLE_ANIMATION];

        if not v67 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = IDLE_ANIMATION;
            v67 = v66:LoadAnimation(Animation);
            u28[IDLE_ANIMATION] = v67;
        end;
    else
        v67 = nil;
    end;

    if not v67 then
        return;
    end;

    v67.Looped = true;
    v67.Priority = Enum.AnimationPriority.Idle;

    if not v67.IsPlaying then
        v67:Play(0.15);
    end;

    u29 = v67;
end;

local function stopDealerBody() -- Line: 540
    -- upvalues: u32 (ref)
    local v68 = u32;
    u32 = nil;

    if v68 and v68.IsPlaying then
        v68:Stop(0.15);
    end;
end;

local function playDealerBody(p69: string) -- Line: 561
    -- upvalues: u27 (ref), u28 (copy), u32 (ref)
    local v70 = u27;
    local v71;

    if v70 then
        v71 = u28[p69];

        if not v71 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = p69;
            v71 = v70:LoadAnimation(Animation);
            u28[p69] = v71;
        end;
    else
        v71 = nil;
    end;

    if not v71 then
        return;
    end;

    local v72 = u32;
    u32 = nil;

    if v72 and v72.IsPlaying then
        v72:Stop(0.15);
    end;

    v71.Looped = false;
    v71.Priority = Enum.AnimationPriority.Movement;
    v71:Stop(0);
    v71:Play(0.15);
    u32 = v71;
end;

local function stopCurrentLine() -- Line: 585
    -- upvalues: u31 (ref), u30 (ref)
    local v73 = u31;
    u31 = nil;

    if v73 and v73.Parent then
        v73:Stop();

        if v73:GetAttribute("Persistent") ~= true then
            v73:Destroy();
        end;
    end;

    local v74 = u30;
    u30 = nil;

    if v74 and v74.IsPlaying then
        v74:Stop(0.15);
    end;
end;

local function stopDealer() -- Line: 604
    -- upvalues: stopCurrentLine (copy), u32 (ref), u29 (ref)
    stopCurrentLine();
    local v75 = u32;
    u32 = nil;

    if v75 and v75.IsPlaying then
        v75:Stop(0.15);
    end;

    if u29 then
        u29:Stop(0.15);
        u29 = nil;
    end;
end;

local function playDealerLine(p76: table?) -- Line: 626
    -- upvalues: script_DealerLines (copy), stopCurrentLine (copy), u32 (ref), Router (copy), u31 (ref), u27 (ref), u28 (copy), u30 (ref)
    local v77 = script_DealerLines.Pick(p76);

    if not v77 then
        return nil;
    end;

    stopCurrentLine();
    local v78 = u32;
    u32 = nil;

    if v78 and v78.IsPlaying then
        v78:Stop(0.15);
    end;

    local v79 = Router.broadcastRouter("RunArmsDealerSound", v77.Sound);

    if typeof(v79) == "Instance" and v79:IsA("Sound") then
        u31 = v79;
    end;

    local Animation = v77.Animation;
    local v80 = u27;
    local v81;

    if v80 then
        v81 = u28[Animation];

        if not v81 then
            local Animation2 = Instance.new("Animation");
            Animation2.AnimationId = Animation;
            v81 = v80:LoadAnimation(Animation2);
            u28[Animation] = v81;
        end;
    else
        v81 = nil;
    end;

    if v81 then
        v81.Looped = false;
        v81.Priority = Enum.AnimationPriority.Action;
        v81:Stop(0);
        v81:Play(0.15);
        u30 = v81;
    end;

    return u31;
end;

local function getSettledPose(p82: userdata) -- Line: 663
    -- upvalues: u6 (ref), u7 (ref)
    local v83 = u6[p82];

    if not v83 then
        return nil;
    end;

    if u7[p82] then
        return v83;
    end;

    return v83 * CFrame.Angles(0, 3.141592653589793, 0);
end;

local function floatTowardLens(p84, p85: number) -- Line: 675
    -- upvalues: u14 (ref)
    local v86 = u14;

    if v86 then
        return p84 - p84.Position + (v86 + (p84.Position - v86) * p85);
    end;

    return p84;
end;

local function setCardScale(p87: userdata, p88: number) -- Line: 690
    -- upvalues: u11 (copy), u12 (copy)
    local v89 = u11[p87];

    if not v89 then
        return;
    end;

    p87.Size = Vector3.new(v89.X * p88, v89.Y * p88, v89.Z);

    for _, child in p87:GetChildren() do
        if child:IsA("SurfaceGui") then
            local v90 = u12[child];

            if v90 then
                child.PixelsPerStud = v90 / p88;
            end;
        end;
    end;
end;

local function getCardSpin(u91: userdata) -- Line: 710
    -- upvalues: u8 (ref), u7 (ref), u6 (ref)
    local v92 = u8[u91];

    if v92 then
        return v92;
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = u7[u91] and 0 or 3.141592653589793;
    local u93 = {
        IsTurning = false,
        Direction = -1,
        Angle = NumberValue,
        Target = NumberValue.Value
    };
    NumberValue.Changed:Connect(function(p94: number) -- Line: 720
        -- upvalues: u6 (ref), u91 (copy), u93 (copy)
        local v95 = u6[u91];

        if u93.IsTurning and v95 then
            u91.CFrame = v95 * CFrame.Angles(0, p94, 0);
        end;
    end);
    u8[u91] = u93;

    return u93;
end;

local function settleCardSpin(p96: userdata) -- Line: 734
    -- upvalues: u20 (copy), u9 (ref), u8 (ref), u7 (ref)
    u20:Remove((`CardFlip_{u9[p96] or 0}`));
    local v97 = u8[p96];

    if v97 then
        v97.IsTurning = false;
        v97.Target = u7[p96] and 0 or 3.141592653589793;
        v97.Angle.Value = v97.Target;
    end;
end;

local function isDealInProgress() -- Line: 747
    -- upvalues: u22 (ref), u23 (ref)
    return u22 or u23;
end;

local function getDealPose(p98: userdata, p99: number) -- Line: 767
    -- upvalues: u16 (ref), u11 (copy), u15 (ref), u7 (ref), u33 (ref), workspace_CurrentCamera (copy), TweenService (copy), Cubic (copy), Back (copy), u14 (ref)
    local v100 = u16[p98];
    local v101 = u11[p98];

    if not (v100 and v101) then
        return nil, u15;
    end;

    if not u7[p98] then
        v100 = v100 * CFrame.Angles(0, 3.141592653589793, 0);
    end;

    local v102 = v101 * u15;
    local v103 = u33 or workspace_CurrentCamera.CFrame;
    local Vector3_new_ret = Vector3.new(v103.RightVector.X, 0, v103.RightVector.Z);
    local v104 = Vector3_new_ret.Magnitude <= 0.001 and Vector3.new(1, 0, 0) or Vector3_new_ret.Unit;
    local v105 = (Vector3.new(0, 1, 0)):Cross(v104);
    local v106 = -v104 * (v102.X * 1.4) + v105 * 3;
    local v107 = v100.Position - Vector3.new(0, 4, 0) + v106;
    local Value = TweenService:GetValue(p99, Cubic, Enum.EasingDirection.Out);
    local Value2 = TweenService:GetValue(math.min(Value / 0.4, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local Value3 = TweenService:GetValue(math.clamp((Value - 0.3) / 0.7, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
    local v108 = v102.Y * 0.3 * math.sin(3.141592653589793 * Value3);
    local v109 = 1 - TweenService:GetValue(p99, Back, Enum.EasingDirection.Out);
    local v110 = CFrame.fromAxisAngle(v105, -0.4188790204786391 * v109) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.6108652381980153 * v109);
    local v111 = math.clamp((Value - 0.4) / 0.6, 0, 1) * -0.30000000000000004 + 1;
    local v112 = CFrame.new(v107 + Vector3.new(0, 1, 0) * (4 * Value2 + v108) - v106 * Value3) * v110 * v100.Rotation;
    local v113 = u14;

    if v113 then
        v112 = v112 - v112.Position + (v113 + (v112.Position - v113) * v111);
    end;

    return v112, u15 * v111;
end;

local function settleDeal() -- Line: 815
    -- upvalues: u26 (ref), u22 (ref), u23 (ref), u5 (ref), u20 (copy), u9 (ref), u6 (ref), u7 (ref), setCardScale (copy), u15 (ref), u24 (copy), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref)
    u26 = u26 + 1;
    u22 = false;
    u23 = false;

    for _, v in u5 do
        u20:Remove((`CardDeal_{u9[v] or 0}`));
        local v114 = u6[v];

        if v114 then
            if not u7[v] then
                v114 = v114 * CFrame.Angles(0, 3.141592653589793, 0);
            end;
        else
            v114 = nil;
        end;

        if v114 then
            setCardScale(v, u15 * 0.7);
            v.CFrame = v114;
        end;

        u24[v] = true;
    end;

    for _, v in u5 do
        local v115;

        if u17[v] == true and not (u18 or u19) then
            v115 = not (u22 or u23) or u24[v] == true;
        else
            v115 = false;
        end;

        applyCardVisibility(v, v115);
    end;
end;

local function runDeal() -- Line: 846
    -- upvalues: u26 (ref), u25 (ref), u22 (ref), u23 (ref), u5 (ref), u24 (copy), getDealPose (copy), setCardScale (copy), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), playDealerLine (copy), script_DealerLines (copy), u6 (ref), u7 (ref), TweenService (copy), u20 (copy), u9 (ref), settleDeal (copy)
    u26 = u26 + 1;
    local u116 = u26;
    local u117 = u25;
    u22 = true;
    u23 = false;
    u25 = true;

    for _, v in u5 do
        u24[v] = false;
        local v118, v119 = getDealPose(v, 0);

        if v118 then
            setCardScale(v, v119);
            v.CFrame = v118;
        end;
    end;

    for _, v in u5 do
        local v120;

        if u17[v] == true and not (u18 or u19) then
            v120 = not (u22 or u23) or u24[v] == true;
        else
            v120 = false;
        end;

        applyCardVisibility(v, v120);
    end;

    task.spawn(function() -- Line: 867
        -- upvalues: u117 (copy), playDealerLine (ref), script_DealerLines (ref), u26 (ref), u116 (copy), u5 (ref), u6 (ref), u7 (ref), u24 (ref), applyCardVisibility (ref), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), getDealPose (ref), setCardScale (ref), TweenService (ref), u20 (ref), u9 (ref), settleDeal (ref)
        if u117 then
            playDealerLine(script_DealerLines.Open);
        end;

        task.wait(0.25);

        if u26 ~= u116 then
            return;
        end;

        for i, v in u5 do
            if u26 ~= u116 then
                return;
            end;

            local v121 = u6[v];

            if v121 then
                if not u7[v] then
                    v121 = v121 * CFrame.Angles(0, 3.141592653589793, 0);
                end;
            else
                v121 = nil;
            end;

            if v121 then
                u24[v] = true;
                local v122;

                if u17[v] == true and not (u18 or u19) then
                    v122 = not (u22 or u23) or u24[v] == true;
                else
                    v122 = false;
                end;

                applyCardVisibility(v, v122);
                local NumberValue = Instance.new("NumberValue");
                NumberValue.Changed:Connect(function(p123: number) -- Line: 892
                    -- upvalues: getDealPose (ref), v (copy), setCardScale (ref)
                    local v124, v125 = getDealPose(v, p123);

                    if v124 then
                        setCardScale(v, v125);
                        v.CFrame = v124;
                    end;
                end);
                local u126 = TweenService:Create(NumberValue, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {
                    Value = 1
                });
                u20:Add(function() -- Line: 904
                    -- upvalues: u126 (copy), NumberValue (copy)
                    u126:Destroy();
                    NumberValue:Destroy();
                end, true, (`CardDeal_{u9[v] or i}`));
                u126:Play();
            end;

            if i < #u5 then
                task.wait(0.14);
            end;
        end;

        task.wait(0.8);

        if u26 ~= u116 then
            return;
        end;

        settleDeal();
    end);
end;

local function startDealIfReady() -- Line: 935
    -- upvalues: u23 (ref), u21 (ref), u18 (ref), u19 (ref), u5 (ref), u17 (ref), runDeal (copy)
    if not (u23 and (u21 and not (u18 or u19))) then
        return;
    end;

    local v127 = false;

    for _, v in u5 do
        if u17[v] == true then
            v127 = true;
            break;
        end;
    end;

    if not v127 then
        return;
    end;

    runDeal();
end;

local function makeSceneInert(p128: userdata) -- Line: 972
    local Cards = p128:FindFirstChild("Cards");

    for _, descendant in p128:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = descendant.Parent == Cards;
        end;
    end;
end;

local function captureDesignRow() -- Line: 990
    -- upvalues: u5 (ref), u10 (copy), u11 (copy), u12 (copy), u13 (ref), u4 (ref), u14 (ref)
    for _, v in u5 do
        if not u10[v] then
            u10[v] = v.CFrame;
            u11[v] = v.Size;

            for _, child in v:GetChildren() do
                if child:IsA("SurfaceGui") then
                    u12[child] = child.PixelsPerStud;
                end;
            end;
        end;
    end;

    local v129 = u5[1];
    local v130 = u5[#u5];
    local v131;

    if v129 then
        v131 = u10[v129];
    else
        v131 = v129;
    end;

    if v130 then
        v130 = u10[v130];
    end;

    if not (v131 and v130) then
        u13 = nil;

        return;
    end;

    u13 = (v131.Position + v130.Position) / 2 - v131.UpVector * (u11[v129].Y / 2);
    local v132 = u4;

    if v132 then
        v132 = v132:FindFirstChild("Camera");
    end;

    if v132 then
        v132 = v132:FindFirstChild("Cards");
    end;

    if not (v132 and (v132:IsA("BasePart") and v132)) then
        v132 = nil;
    end;

    if v132 then
        v132 = v132.Position;
    end;

    u14 = v132;
end;

local function applyRowFit() -- Line: 1029
    -- upvalues: u13 (ref), workspace_CurrentCamera (copy), u15 (ref), u5 (ref), u10 (copy), u16 (ref), u14 (ref), u6 (ref), u9 (ref), u20 (copy), u8 (ref), u7 (ref), setCardScale (copy), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    local v133 = u13;

    if not v133 then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if ViewportSize.Y <= 0 then
        return;
    end;

    local math_min_ret = math.min(1, ViewportSize.X / ViewportSize.Y / 1.7777777777777777);
    u15 = math_min_ret;

    for _, v in u5 do
        local v134 = u10[v];

        if v134 then
            local v135 = v134 - v134.Position + (v133 + (v134.Position - v133) * math_min_ret);
            u16[v] = v135;
            local v136 = u14;

            if v136 then
                v135 = v135 - v135.Position + (v136 + (v135.Position - v136) * 0.7);
            end;

            u6[v] = v135;
            local v137 = u9[v] or 0;
            u20:Remove((`CardFlip_{u9[v] or 0}`));
            local v138 = u8[v];

            if v138 then
                v138.IsTurning = false;
                v138.Target = u7[v] and 0 or 3.141592653589793;
                v138.Angle.Value = v138.Target;
            end;

            u20:Remove((`CardDeal_{v137}`));
            setCardScale(v, math_min_ret * 0.7);

            if not u7[v] then
                v135 = v135 * CFrame.Angles(0, 3.141592653589793, 0);
            end;

            v.CFrame = v135;
            local v139;

            if u17[v] == true and not (u18 or u19) then
                v139 = not (u22 or u23) or u24[v] == true;
            else
                v139 = false;
            end;

            applyCardVisibility(v, v139);
        end;
    end;
end;

local function collectCards(p140: userdata) -- Line: 1069
    -- upvalues: u5 (ref), u6 (ref), u16 (ref), u7 (ref), u8 (ref), u17 (ref), u9 (ref), captureDesignRow (copy), applyRowFit (copy)
    u5 = {};
    u6 = {};
    u16 = {};
    u7 = {};

    for _, v in u8 do
        v.Angle:Destroy();
    end;

    u8 = {};
    u17 = {};
    u9 = {};
    local Cards = p140:FindFirstChild("Cards");

    if not Cards then
        warn("[BlackMarketSceneController]: scene is missing its Cards folder");

        return;
    end;

    for _, child in Cards:GetChildren() do
        if child:IsA("BasePart") then
            table.insert(u5, child);
        end;
    end;

    table.sort(u5, function(p141, p142) -- Line: 1095
        return p141.Position.Z < p142.Position.Z;
    end);

    for i, v in u5 do
        u9[v] = i;
    end;

    captureDesignRow();
    applyRowFit();
end;

function u1.IsActive() -- Line: 1110
    -- upvalues: u21 (ref)
    return u21;
end;

function u1.GetCards() -- Line: 1116
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.GetCardFaces(p143: userdata) -- Line: 1126
    local Back2 = p143:FindFirstChild("Back");
    local Front = p143:FindFirstChild("Front");

    if Back2 then
        Back2 = Back2:FindFirstChild("Main");
    end;

    if Front then
        Front = Front:FindFirstChild("Main");
    end;

    return Back2, Front;
end;

function u1.IsCardFaceUp(p144: userdata) -- Line: 1134
    -- upvalues: u7 (ref)
    return u7[p144] == true;
end;

function u1.SetCardFaceUp(u145: userdata, p146: boolean, p147: boolean?) -- Line: 1146
    -- upvalues: u6 (ref), u7 (ref), u22 (ref), u23 (ref), u20 (copy), u9 (ref), u8 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u24 (copy), getCardSpin (copy), Random_new_ret (copy), TweenService (copy)
    local v148 = u6[u145];

    if not v148 then
        return;
    end;

    if u7[u145] == p146 then
        return;
    end;

    if p147 and (u22 or u23) then
        return;
    end;

    if not p147 then
        u7[u145] = p146;
        u20:Remove((`CardFlip_{u9[u145] or 0}`));
        local v149 = u8[u145];

        if v149 then
            v149.IsTurning = false;
            v149.Target = u7[u145] and 0 or 3.141592653589793;
            v149.Angle.Value = v149.Target;
        end;

        if not p146 then
            v148 = v148 * CFrame.Angles(0, 3.141592653589793, 0);
        end;

        u145.CFrame = v148;
        local v150;

        if u17[u145] == true and not (u18 or u19) then
            v150 = not (u22 or u23) or u24[u145] == true;
        else
            v150 = false;
        end;

        applyCardVisibility(u145, v150);

        return;
    end;

    local u151 = getCardSpin(u145);
    local IsTurning = u151.IsTurning;

    if not IsTurning then
        u151.Angle.Value = u7[u145] and 0 or 3.141592653589793;
        u151.Target = u151.Angle.Value;
        u151.Direction = Random_new_ret:NextInteger(0, 1) == 0 and -1 or 1;
    end;

    u151.Target = u151.Target + u151.Direction * 3.141592653589793;
    local math_abs_ret = math.abs(u151.Target - u151.Angle.Value);
    local v152;

    if IsTurning then
        v152 = Enum.EasingDirection.Out;
    else
        v152 = Enum.EasingDirection.InOut;
    end;

    local v153 = TweenService:Create(u151.Angle, TweenInfo.new(math_abs_ret * 0.42 / 3.141592653589793, Enum.EasingStyle.Quad, v152), {
        Value = u151.Target
    });
    v153.Completed:Once(function(p154) -- Line: 1196
        -- upvalues: u151 (copy), u7 (ref), u145 (copy)
        if p154 ~= Enum.PlaybackState.Completed then
            return;
        end;

        u151.IsTurning = false;
        u151.Target = u7[u145] and 0 or 3.141592653589793;
        u151.Angle.Value = u151.Target;
    end);
    u20:Add(v153, "Destroy", (`CardFlip_{u9[u145] or 0}`));
    u7[u145] = p146;
    u151.IsTurning = true;
    v153:Play();
end;

function u1.ResetCards() -- Line: 1227
    -- upvalues: u5 (ref), u8 (ref), u20 (copy), u9 (ref), u7 (ref), u6 (ref), u1 (copy)
    for _, v in u5 do
        local v155 = u8[v];

        if v155 and v155.IsTurning then
            u20:Remove((`CardFlip_{u9[v] or 0}`));
            local v156 = u8[v];

            if v156 then
                v156.IsTurning = false;
                v156.Target = u7[v] and 0 or 3.141592653589793;
                v156.Angle.Value = v156.Target;
            end;

            local v157 = u6[v];

            if v157 then
                if not u7[v] then
                    v157 = v157 * CFrame.Angles(0, 3.141592653589793, 0);
                end;
            else
                v157 = nil;
            end;

            if v157 then
                v.CFrame = v157;
            end;
        end;

        u1.SetCardFaceUp(v, false, false);
    end;
end;

function u1.SetCardVisible(p158: userdata, p159: boolean) -- Line: 1245
    -- upvalues: u17 (ref), applyCardVisibility (copy), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    u17[p158] = p159;
    local v160;

    if u17[p158] == true and not (u18 or u19) then
        v160 = not (u22 or u23) or u24[p158] == true;
    else
        v160 = false;
    end;

    applyCardVisibility(p158, v160);
end;

function u1.IsCardShown(p161: userdata) -- Line: 1257
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    if u17[p161] == true and not (u18 or u19) then
        return not (u22 or u23) or u24[p161] == true;
    end;

    return false;
end;

function u1.SetRevealHeld(p162: boolean) -- Line: 1268
    -- upvalues: u19 (ref), u5 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u22 (ref), u23 (ref), u24 (copy), startDealIfReady (copy)
    if u19 == p162 then
        return;
    end;

    u19 = p162;

    for _, v in u5 do
        local v163;

        if u17[v] == true and not (u18 or u19) then
            v163 = not (u22 or u23) or u24[v] == true;
        else
            v163 = false;
        end;

        applyCardVisibility(v, v163);
    end;

    startDealIfReady();
end;

function u1.ReplayIntro() -- Line: 1290
    -- upvalues: u21 (ref), u1 (copy), u18 (ref), u23 (ref), u25 (ref), u24 (copy), u5 (ref), applyCardVisibility (copy), u17 (ref), u19 (ref), u22 (ref), u4 (ref), u33 (ref), u34 (ref), u35 (ref), u36 (ref), script_DealerLines (copy), u27 (ref), u28 (copy), u32 (ref)
    if not u21 then
        return;
    end;

    u1.ResetCards();
    u18 = true;
    u23 = true;
    u25 = true;
    table.clear(u24);

    for _, v in u5 do
        local v164;

        if u17[v] == true and not (u18 or u19) then
            v164 = not (u22 or u23) or u24[v] == true;
        else
            v164 = false;
        end;

        applyCardVisibility(v, v164);
    end;

    local v165 = u4;

    if v165 then
        v165 = v165:FindFirstChild("Camera");
    end;

    if v165 then
        v165 = v165:FindFirstChild("Cards");
    end;

    if not (v165 and (v165:IsA("BasePart") and v165)) then
        v165 = nil;
    end;

    if v165 then
        u33 = v165.CFrame;
        u34 = nil;
        u35 = nil;
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
    end;

    local v166 = u33;

    if v166 then
        u34 = -v166.LookVector * 6;
        u35 = Vector3.new(0, 4, 0);
        u36 = os.clock();
    end;

    local INTRO_ANIMATION = script_DealerLines.INTRO_ANIMATION;
    local v167 = u27;
    local v168;

    if v167 then
        v168 = u28[INTRO_ANIMATION];

        if not v168 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = INTRO_ANIMATION;
            v168 = v167:LoadAnimation(Animation);
            u28[INTRO_ANIMATION] = v168;
        end;
    else
        v168 = nil;
    end;

    if not v168 then
        return;
    end;

    local v169 = u32;
    u32 = nil;

    if v169 and v169.IsPlaying then
        v169:Stop(0.15);
    end;

    v168.Looped = false;
    v168.Priority = Enum.AnimationPriority.Movement;
    v168:Stop(0);
    v168:Play(0.15);
    u32 = v168;
end;

function u1.Redeal() -- Line: 1321
    -- upvalues: u21 (ref), u1 (copy), u26 (ref), u5 (ref), u20 (copy), u9 (ref), u22 (ref), u23 (ref), u25 (ref), u24 (copy), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref)
    if not u21 then
        return;
    end;

    u1.ResetCards();
    u26 = u26 + 1;

    for _, v in u5 do
        u20:Remove((`CardDeal_{u9[v] or 0}`));
    end;

    u22 = false;
    u23 = true;
    u25 = false;
    table.clear(u24);

    for _, v in u5 do
        local v170;

        if u17[v] == true and not (u18 or u19) then
            v170 = not (u22 or u23) or u24[v] == true;
        else
            v170 = false;
        end;

        applyCardVisibility(v, v170);
    end;
end;

function u1.SkipIntro() -- Line: 1347
    -- upvalues: u21 (ref), u4 (ref), u33 (ref), u34 (ref), u35 (ref), u18 (ref), u5 (ref), applyCardVisibility (copy), u17 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy), startDealIfReady (copy)
    if not u21 then
        return;
    end;

    local v171 = u4;

    if v171 then
        v171 = v171:FindFirstChild("Camera");
    end;

    if v171 then
        v171 = v171:FindFirstChild("Cards");
    end;

    if not (v171 and (v171:IsA("BasePart") and v171)) then
        v171 = nil;
    end;

    if v171 then
        u33 = v171.CFrame;
        u34 = nil;
        u35 = nil;
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
    end;

    u18 = false;

    for _, v in u5 do
        local v172;

        if u17[v] == true and not (u18 or u19) then
            v172 = not (u22 or u23) or u24[v] == true;
        else
            v172 = false;
        end;

        applyCardVisibility(v, v172);
    end;

    startDealIfReady();
end;

function u1.IsPresenting() -- Line: 1366
    -- upvalues: u18 (ref), u22 (ref), u23 (ref)
    return u18 or (u22 or u23);
end;

function u1.SkipPresentation() -- Line: 1379
    -- upvalues: u21 (ref), u18 (ref), u34 (ref), u4 (ref), u33 (ref), u35 (ref), settleDeal (copy)
    if not u21 then
        return;
    end;

    if u18 or u34 then
        local v173 = u4;

        if v173 then
            v173 = v173:FindFirstChild("Camera");
        end;

        if v173 then
            v173 = v173:FindFirstChild("Cards");
        end;

        if not (v173 and (v173:IsA("BasePart") and v173)) then
            v173 = nil;
        end;

        if v173 then
            u33 = v173.CFrame;
            u34 = nil;
            u35 = nil;
        else
            warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
        end;

        u18 = false;
    end;

    settleDeal();
end;

function u1.PlayPurchaseLine() -- Line: 1397
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Purchase);
end;

function u1.PlayDeclineLine() -- Line: 1401
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Declined);
end;

function u1.PlayRefreshLine() -- Line: 1411
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Refresh);
end;

function u1.PlayDiscontinuedLine() -- Line: 1415
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Discontinued);
end;

function u1.PlayRarityLine(p174: string?) -- Line: 1427
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    if typeof(p174) ~= "string" then
        return;
    end;

    playDealerLine(script_DealerLines.Rarity[p174]);
end;

function u1.NotifyDealRendered() -- Line: 1443
    -- upvalues: startDealIfReady (copy)
    startDealIfReady();
end;

function u1.Show(p175: boolean?) -- Line: 1449
    -- upvalues: u21 (ref), u4 (ref), SceneParking (copy), u19 (ref), collectCards (copy), u1 (copy), u5 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u22 (ref), u23 (ref), u24 (copy), applySceneLighting (copy), script_DealerLines (copy), u27 (ref), u28 (copy), u29 (ref), u25 (ref), workspace_CurrentCamera (copy), CameraController (copy), setPerspectiveSinksInput (copy), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u32 (ref), RunServiceController (copy), u2 (copy), TweenService (copy), Sine (copy), startDealIfReady (copy), u20 (copy), applyRowFit (copy), BakedViewmodelMirror (copy), hideInstance (copy)
    if u21 then
        return;
    end;

    local v176 = u4;

    if not v176 then
        warn("[BlackMarketSceneController]: scene was never staged");

        return;
    end;

    SceneParking.Unpark(v176);
    u21 = true;
    u19 = false;
    collectCards(v176);
    u1.ResetCards();

    for _, v in u5 do
        local v177;

        if u17[v] == true and not (u18 or u19) then
            v177 = not (u22 or u23) or u24[v] == true;
        else
            v177 = false;
        end;

        applyCardVisibility(v, v177);
    end;

    applySceneLighting();
    local IDLE_ANIMATION = script_DealerLines.IDLE_ANIMATION;
    local v178 = u27;
    local v179;

    if v178 then
        v179 = u28[IDLE_ANIMATION];

        if not v179 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = IDLE_ANIMATION;
            v179 = v178:LoadAnimation(Animation);
            u28[IDLE_ANIMATION] = v179;
        end;
    else
        v179 = nil;
    end;

    if v179 then
        v179.Looped = true;
        v179.Priority = Enum.AnimationPriority.Idle;

        if not v179.IsPlaying then
            v179:Play(0.15);
        end;

        u29 = v179;
    end;

    u23 = not p175;
    u25 = true;
    table.clear(u24);
    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CameraController.setFOVLock("BlackMarketScene", true, 70);
    CameraController.setForceLockOverride("BlackMarketScene", true);
    setPerspectiveSinksInput(false);
    u18 = not p175;
    local v180 = u4;

    if v180 then
        v180 = v180:FindFirstChild("Camera");
    end;

    if v180 then
        v180 = v180:FindFirstChild("Cards");
    end;

    if not (v180 and (v180:IsA("BasePart") and v180)) then
        v180 = nil;
    end;

    if v180 then
        u33 = v180.CFrame;
        u34 = nil;
        u35 = nil;
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
    end;

    if not p175 then
        local v181 = u33;

        if v181 then
            u34 = -v181.LookVector * 6;
            u35 = Vector3.new(0, 4, 0);
            u36 = os.clock();
        end;

        local INTRO_ANIMATION = script_DealerLines.INTRO_ANIMATION;
        local v182 = u27;
        local v183;

        if v182 then
            v183 = u28[INTRO_ANIMATION];

            if not v183 then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = INTRO_ANIMATION;
                v183 = v182:LoadAnimation(Animation);
                u28[INTRO_ANIMATION] = v183;
            end;
        else
            v183 = nil;
        end;

        if v183 then
            local v184 = u32;
            u32 = nil;

            if v184 and v184.IsPlaying then
                v184:Stop(0.15);
            end;

            v183.Looped = false;
            v183.Priority = Enum.AnimationPriority.Movement;
            v183:Stop(0);
            v183:Play(0.15);
            u32 = v183;
        end;
    end;

    RunServiceController.BindToRenderStep("BlackMarketSceneController.CameraUpdate", u2, function() -- Line: 1492
        -- upvalues: u33 (ref), workspace_CurrentCamera (ref), u34 (ref), u35 (ref), u36 (ref), TweenService (ref), Sine (ref), u18 (ref), u5 (ref), applyCardVisibility (ref), u17 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (ref), startDealIfReady (ref)
        local v185 = u33;

        if not v185 then
            return;
        end;

        workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        local v186 = u34;
        local v187 = u35;

        if v186 and v187 then
            local v188 = (os.clock() - u36 - 0.2) / 1.4;
            local math_clamp_ret = math.clamp(v188, 0, 1);
            local v189 = 1.5707963267948966 * TweenService:GetValue(math_clamp_ret, Sine, Enum.EasingDirection.InOut);
            workspace_CurrentCamera.CFrame = v185 + v186 * math.cos(v189) + v187 * (1 - math.sin(v189));

            if math_clamp_ret >= 1 then
                u34 = nil;
                u35 = nil;

                if u18 then
                    u18 = false;

                    for _, v in u5 do
                        local v190;

                        if u17[v] == true and not (u18 or u19) then
                            v190 = not (u22 or u23) or u24[v] == true;
                        else
                            v190 = false;
                        end;

                        applyCardVisibility(v, v190);
                    end;

                    startDealIfReady();
                end;
            end;
        else
            workspace_CurrentCamera.CFrame = v185;
        end;

        workspace_CurrentCamera.Focus = workspace_CurrentCamera.CFrame;
    end);
    u20:Add(function() -- Line: 1528
        -- upvalues: RunServiceController (ref)
        RunServiceController.UnbindFromRenderStep("BlackMarketSceneController.CameraUpdate");
    end, true, "CameraUpdate");
    u20:Add(workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyRowFit), "Disconnect", "ViewportFit");
    BakedViewmodelMirror.SetSuppressed(true);

    for _, child in workspace_CurrentCamera:GetChildren() do
        if child:IsA("Model") or child:IsA("BasePart") then
            hideInstance(child);

            for _, descendant in child:GetDescendants() do
                hideInstance(descendant);
            end;
        end;
    end;

    u20:Add(workspace_CurrentCamera.ChildAdded:Connect(function(p191) -- Line: 1549
        -- upvalues: hideInstance (ref)
        if p191:IsA("Model") or p191:IsA("BasePart") then
            hideInstance(p191);

            for _, descendant in p191:GetDescendants() do
                hideInstance(descendant);
            end;
        end;
    end), "Disconnect", "ViewmodelListener");
    u1.OnActiveChanged:Fire(true);
end;

function u1.Hide() -- Line: 1563
    -- upvalues: u21 (ref), u18 (ref), u19 (ref), u26 (ref), u22 (ref), u23 (ref), stopCurrentLine (copy), u32 (ref), u29 (ref), u20 (copy), u33 (ref), u34 (ref), u35 (ref), workspace_CurrentCamera (copy), CameraController (copy), Constants (copy), ReplicatedStorage (copy), setPerspectiveSinksInput (copy), showViewmodels (copy), BakedViewmodelMirror (copy), u4 (ref), SceneParking (copy), u1 (copy)
    if not u21 then
        return;
    end;

    u21 = false;
    u18 = false;
    u19 = false;
    u26 = u26 + 1;
    u22 = false;
    u23 = false;
    stopCurrentLine();
    local v192 = u32;
    u32 = nil;

    if v192 and v192.IsPlaying then
        v192:Stop(0.15);
    end;

    if u29 then
        u29:Stop(0.15);
        u29 = nil;
    end;

    u20:Cleanup();
    u33 = nil;
    u34 = nil;
    u35 = nil;
    workspace_CurrentCamera.CameraType = Enum.CameraType.Custom;
    CameraController.setFOVLock("BlackMarketScene", false);
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    local CurrentSpectateInstance = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance();

    if CurrentSpectateInstance then
        CurrentSpectateInstance:UpdateScopeState();
    end;

    CameraController.setForceLockOverride("BlackMarketScene", false);
    setPerspectiveSinksInput(true);
    showViewmodels();
    BakedViewmodelMirror.SetSuppressed(false);
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);

    if workspace:FindFirstChild("Map") then
        MenuSceneController.ApplyMapLighting();
    else
        MenuSceneController.ApplyMenuSceneLighting();
    end;

    if u4 then
        SceneParking.Park(u4);
    end;

    u1.OnActiveChanged:Fire(false);
end;

function u1.Initialize() -- Line: 1615
    -- upvalues: Constants (copy), ReplicatedStorage (copy), SceneParking (copy), u4 (ref), makeSceneInert (copy), u27 (ref), attachUnskinnedParts (copy), collectCards (copy), u1 (copy)
    if not Constants.BLACK_MARKET_ENABLED then
        return;
    end;

    local BlackMarketScene = ReplicatedStorage.Assets:FindFirstChild("BlackMarketScene");

    if not BlackMarketScene then
        warn("[BlackMarketSceneController]: Assets.BlackMarketScene is missing");

        return;
    end;

    local v193 = BlackMarketScene:FindFirstChildOfClass("Model");

    if not v193 then
        warn("[BlackMarketSceneController]: no model inside Assets.BlackMarketScene");

        return;
    end;

    local v194 = v193:Clone();
    v194.Name = "BlackMarketScene";
    SceneParking.Park(v194);
    u4 = v194;
    makeSceneInert(v194);
    local v195 = v194:FindFirstChildWhichIsA("AnimationController", true);
    local v196;

    if v195 then
        v196 = v195:FindFirstChildOfClass("Animator");
    else
        v196 = v195;
    end;

    if v196 then
        u27 = v196;
        attachUnskinnedParts(v195.Parent);
    else
        warn("[BlackMarketSceneController]: the scene\'s dealer has no Animator, so he will not move");
    end;

    collectCards(v194);
    u1.ResetCards();
end;

return u1;