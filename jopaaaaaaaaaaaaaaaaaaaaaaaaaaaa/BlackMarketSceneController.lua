-- ReplicatedStorage.Controllers.BlackMarketSceneController
-- Script path: ReplicatedStorage.Controllers.BlackMarketSceneController
-- Decompile time: 23.55 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local BakedViewmodelMirror = require(ReplicatedStorage.Shared.BakedViewmodelMirror);
local SceneParking = require(ReplicatedStorage.Components.Common.SceneParking);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
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
local u37 = nil;
local u38 = nil;

local function applySceneLighting() -- Line: 243
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

local function setPerspectiveSinksInput(p39: boolean) -- Line: 270
    -- upvalues: Players (copy)
    local v40 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v40 then
        v40 = v40:FindFirstChild("MainGui");
    end;

    if v40 then
        v40 = v40:FindFirstChild("CameraPerspective");
    end;

    if not (v40 and v40:IsA("GuiButton")) then
        warn("[BlackMarketSceneController]: MainGui.CameraPerspective was not found, card clicks may be swallowed");

        return false;
    end;

    v40.Active = p39;
    v40.Interactable = p39;

    return true;
end;

local u41 = {};
local u42 = {};

local function hideInstance(p43: userdata) -- Line: 300
    -- upvalues: u41 (copy), u42 (copy)
    if not (p43:IsA("BasePart") or p43:IsA("Decal")) then
        if p43:IsA("SurfaceGui") and p43.Enabled then
            p43.Enabled = false;
            table.insert(u42, p43);
        end;

        return;
    end;

    if u41[p43] == nil then
        u41[p43] = p43.LocalTransparencyModifier;
    end;

    p43.LocalTransparencyModifier = 1;
end;

local function hideViewmodel(p44: userdata) -- Line: 313
    -- upvalues: hideInstance (copy)
    hideInstance(p44);

    for _, descendant in p44:GetDescendants() do
        hideInstance(descendant);
    end;
end;

local function showViewmodels() -- Line: 320
    -- upvalues: u41 (copy), u42 (copy)
    for i, v in u41 do
        if i.Parent then
            i.LocalTransparencyModifier = v;
        end;
    end;

    table.clear(u41);

    for _, v in u42 do
        if v.Parent then
            v.Enabled = true;
        end;
    end;

    table.clear(u42);
end;

local function isCameraAttachment(p45: userdata) -- Line: 336
    return p45:IsA("Model") or p45:IsA("BasePart");
end;

local function applyCardVisibility(p46: userdata, p47: boolean) -- Line: 351
    for _, child in p46:GetChildren() do
        if child:IsA("SurfaceGui") then
            child.Enabled = p47;
        end;
    end;
end;

local function isCardShown(p48: userdata) -- Line: 370
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    if u17[p48] == true and not (u18 or u19) then
        return not (u22 or u23) or u24[p48] == true;
    end;

    return false;
end;

local function refreshCardFaces(p49: userdata) -- Line: 380
    -- upvalues: applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    local v50;

    if u17[p49] == true and not (u18 or u19) then
        v50 = not (u22 or u23) or u24[p49] == true;
    else
        v50 = false;
    end;

    applyCardVisibility(p49, v50);
end;

local function syncCardVisibility() -- Line: 390
    -- upvalues: u5 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    for _, v in u5 do
        local v51;

        if u17[v] == true and not (u18 or u19) then
            v51 = not (u22 or u23) or u24[v] == true;
        else
            v51 = false;
        end;

        applyCardVisibility(v, v51);
    end;
end;

local function captureGameplayAim() -- Line: 403
    -- upvalues: CharacterResolver (copy), workspace_CurrentCamera (copy), Players (copy)
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if not (LocalCharacter and CharacterResolver.isAliveCharacter(LocalCharacter)) then
        return nil;
    end;

    local CameraSubject = workspace_CurrentCamera.CameraSubject;
    local CameraPart = CharacterResolver.getCameraPart(LocalCharacter);

    return workspace_CurrentCamera.CameraType == Enum.CameraType.Custom and (CameraSubject and (CameraSubject:IsDescendantOf(LocalCharacter) and (CameraPart and (workspace_CurrentCamera.CFrame.Position - CameraPart.Position).Magnitude <= Players.LocalPlayer.CameraMaxZoomDistance + 4))) and {
        Character = LocalCharacter,
        Rotation = workspace_CurrentCamera.CFrame.Rotation
    } or nil;
end;

local function restoreGameplayAim() -- Line: 424
    -- upvalues: u37 (ref), CharacterResolver (copy), workspace_CurrentCamera (copy), CameraController (copy)
    local v52 = u37;
    u37 = nil;

    if not v52 then
        return;
    end;

    local Character = v52.Character;

    if Character ~= CharacterResolver.getLocalCharacter() or not CharacterResolver.isAliveCharacter(Character) then
        return;
    end;

    local CameraPart = CharacterResolver.getCameraPart(Character);
    local v53;

    if CameraPart then
        v53 = CameraPart.Position;
    else
        v53 = workspace_CurrentCamera.CFrame.Position;
    end;

    workspace_CurrentCamera.CFrame = CFrame.new(v53) * v52.Rotation;
    workspace_CurrentCamera.Focus = workspace_CurrentCamera.CFrame;
    CameraController.setBaseCameraCFrame(workspace_CurrentCamera.CFrame);
end;

local function getMarker(p54: string) -- Line: 445
    -- upvalues: u4 (ref)
    local v55 = u4;

    if v55 then
        v55 = v55:FindFirstChild("Camera");
    end;

    if v55 then
        v55 = v55:FindFirstChild(p54);
    end;

    if not (v55 and (v55:IsA("BasePart") and v55)) then
        v55 = nil;
    end;

    return v55;
end;

local function moveCameraTo(p56: string) -- Line: 458
    -- upvalues: u4 (ref), u33 (ref), u34 (ref), u35 (ref)
    local v57 = u4;

    if v57 then
        v57 = v57:FindFirstChild("Camera");
    end;

    if v57 then
        v57 = v57:FindFirstChild(p56);
    end;

    if not (v57 and (v57:IsA("BasePart") and v57)) then
        v57 = nil;
    end;

    if not v57 then
        warn((`[BlackMarketSceneController]: scene is missing Camera.{p56}`));

        return;
    end;

    u33 = v57.CFrame;
    u34 = nil;
    u35 = nil;
end;

local function startIntroArc() -- Line: 477
    -- upvalues: u33 (ref), u34 (ref), u35 (ref), u36 (ref)
    local v58 = u33;

    if not v58 then
        return;
    end;

    u34 = -v58.LookVector * 6;
    u35 = Vector3.new(0, 4, 0);
    u36 = os.clock();
end;

local u59 = {
    face = "TopMost",
    ["Cube.002"] = "Tie",
    ["Cube.012"] = "UpperBody.001",
    UpperTorso = "UpperBody.001",
    ["Cube.003"] = "UpperLeg.L"
};

local function attachUnskinnedParts(p60: userdata) -- Line: 500
    -- upvalues: u59 (copy)
    for i, v in u59 do
        local v61 = p60:FindFirstChild(i);
        local v62 = p60:FindFirstChild(v, true);

        if v61 and (v61:IsA("MeshPart") and (v62 and (v62:IsA("Bone") and not v61.HasSkinnedMesh))) then
            for _, child in v61:GetChildren() do
                if child:IsA("Motor6D") and child.Part1 == v61 then
                    child.Enabled = false;
                end;
            end;

            local Attachment = Instance.new("Attachment");
            Attachment.Name = "BoneFollow";
            Attachment.CFrame = v61.CFrame:ToObjectSpace(v62.WorldCFrame);
            Attachment.Parent = v61;
            local RigidConstraint = Instance.new("RigidConstraint");
            RigidConstraint.Name = "BoneFollow";
            RigidConstraint.Attachment0 = Attachment;
            RigidConstraint.Attachment1 = v62;
            RigidConstraint.Parent = v61;
            v61.Anchored = false;
        end;
    end;
end;

local function bindDealer(p63: userdata) -- Line: 542
    -- upvalues: u27 (ref), attachUnskinnedParts (copy)
    local v64 = p63:FindFirstChildWhichIsA("AnimationController", true);
    local v65;

    if v64 then
        v65 = v64:FindFirstChildOfClass("Animator");
    else
        v65 = v64;
    end;

    if not v65 then
        warn("[BlackMarketSceneController]: the scene\'s dealer has no Animator, so he will not move");

        return;
    end;

    u27 = v65;
    attachUnskinnedParts(v64.Parent);
end;

local function getDealerTrack(p66: string) -- Line: 562
    -- upvalues: u27 (ref), u28 (copy)
    local v67 = u27;

    if not v67 then
        return nil;
    end;

    local v68 = u28[p66];

    if v68 then
        return v68;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p66;
    local v69 = v67:LoadAnimation(Animation);
    u28[p66] = v69;

    return v69;
end;

local function startDealerIdle() -- Line: 587
    -- upvalues: script_DealerLines (copy), u27 (ref), u28 (copy), u29 (ref)
    local IDLE_ANIMATION = script_DealerLines.IDLE_ANIMATION;
    local v70 = u27;
    local v71;

    if v70 then
        v71 = u28[IDLE_ANIMATION];

        if not v71 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = IDLE_ANIMATION;
            v71 = v70:LoadAnimation(Animation);
            u28[IDLE_ANIMATION] = v71;
        end;
    else
        v71 = nil;
    end;

    if not v71 then
        return;
    end;

    v71.Looped = true;
    v71.Priority = Enum.AnimationPriority.Idle;

    if not v71.IsPlaying then
        v71:Play(0.15);
    end;

    u29 = v71;
end;

local function stopDealerBody() -- Line: 604
    -- upvalues: u32 (ref)
    local v72 = u32;
    u32 = nil;

    if v72 and v72.IsPlaying then
        v72:Stop(0.15);
    end;
end;

local function playDealerBody(p73: string) -- Line: 625
    -- upvalues: u27 (ref), u28 (copy), u32 (ref)
    local v74 = u27;
    local v75;

    if v74 then
        v75 = u28[p73];

        if not v75 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = p73;
            v75 = v74:LoadAnimation(Animation);
            u28[p73] = v75;
        end;
    else
        v75 = nil;
    end;

    if not v75 then
        return;
    end;

    local v76 = u32;
    u32 = nil;

    if v76 and v76.IsPlaying then
        v76:Stop(0.15);
    end;

    v75.Looped = false;
    v75.Priority = Enum.AnimationPriority.Movement;
    v75:Stop(0);
    v75:Play(0.15);
    u32 = v75;
end;

local function stopCurrentLine() -- Line: 649
    -- upvalues: u31 (ref), u30 (ref)
    local v77 = u31;
    u31 = nil;

    if v77 and v77.Parent then
        v77:Stop();

        if v77:GetAttribute("Persistent") ~= true then
            v77:Destroy();
        end;
    end;

    local v78 = u30;
    u30 = nil;

    if v78 and v78.IsPlaying then
        v78:Stop(0.15);
    end;
end;

local function stopDealer() -- Line: 668
    -- upvalues: stopCurrentLine (copy), u32 (ref), u29 (ref)
    stopCurrentLine();
    local v79 = u32;
    u32 = nil;

    if v79 and v79.IsPlaying then
        v79:Stop(0.15);
    end;

    if u29 then
        u29:Stop(0.15);
        u29 = nil;
    end;
end;

local function playDealerLine(p80: table?) -- Line: 690
    -- upvalues: script_DealerLines (copy), stopCurrentLine (copy), u32 (ref), Router (copy), u31 (ref), u27 (ref), u28 (copy), u30 (ref)
    local v81 = script_DealerLines.Pick(p80);

    if not v81 then
        return nil;
    end;

    stopCurrentLine();
    local v82 = u32;
    u32 = nil;

    if v82 and v82.IsPlaying then
        v82:Stop(0.15);
    end;

    local v83 = Router.broadcastRouter("RunArmsDealerSound", v81.Sound);

    if typeof(v83) == "Instance" and v83:IsA("Sound") then
        u31 = v83;
    end;

    local Animation = v81.Animation;
    local v84 = u27;
    local v85;

    if v84 then
        v85 = u28[Animation];

        if not v85 then
            local Animation2 = Instance.new("Animation");
            Animation2.AnimationId = Animation;
            v85 = v84:LoadAnimation(Animation2);
            u28[Animation] = v85;
        end;
    else
        v85 = nil;
    end;

    if v85 then
        v85.Looped = false;
        v85.Priority = Enum.AnimationPriority.Action;
        v85:Stop(0);
        v85:Play(0.15);
        u30 = v85;
    end;

    return u31;
end;

local function getSettledPose(p86: userdata) -- Line: 727
    -- upvalues: u6 (ref), u7 (ref)
    local v87 = u6[p86];

    if not v87 then
        return nil;
    end;

    if u7[p86] then
        return v87;
    end;

    return v87 * CFrame.Angles(0, 3.141592653589793, 0);
end;

local function floatTowardLens(p88, p89: number) -- Line: 739
    -- upvalues: u14 (ref)
    local v90 = u14;

    if v90 then
        return p88 - p88.Position + (v90 + (p88.Position - v90) * p89);
    end;

    return p88;
end;

local function setCardScale(p91: userdata, p92: number) -- Line: 754
    -- upvalues: u11 (copy), u12 (copy)
    local v93 = u11[p91];

    if not v93 then
        return;
    end;

    p91.Size = Vector3.new(v93.X * p92, v93.Y * p92, v93.Z);

    for _, child in p91:GetChildren() do
        if child:IsA("SurfaceGui") then
            local v94 = u12[child];

            if v94 then
                child.PixelsPerStud = v94 / p92;
            end;
        end;
    end;
end;

local function getCardSpin(u95: userdata) -- Line: 774
    -- upvalues: u8 (ref), u7 (ref), u6 (ref)
    local v96 = u8[u95];

    if v96 then
        return v96;
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = u7[u95] and 0 or 3.141592653589793;
    local u97 = {
        IsTurning = false,
        Direction = -1,
        Angle = NumberValue,
        Target = NumberValue.Value
    };
    NumberValue.Changed:Connect(function(p98: number) -- Line: 784
        -- upvalues: u6 (ref), u95 (copy), u97 (copy)
        local v99 = u6[u95];

        if u97.IsTurning and v99 then
            u95.CFrame = v99 * CFrame.Angles(0, p98, 0);
        end;
    end);
    u8[u95] = u97;

    return u97;
end;

local function settleCardSpin(p100: userdata) -- Line: 798
    -- upvalues: u20 (copy), u9 (ref), u8 (ref), u7 (ref)
    u20:Remove((`CardFlip_{u9[p100] or 0}`));
    local v101 = u8[p100];

    if v101 then
        v101.IsTurning = false;
        v101.Target = u7[p100] and 0 or 3.141592653589793;
        v101.Angle.Value = v101.Target;
    end;
end;

local function isDealInProgress() -- Line: 811
    -- upvalues: u22 (ref), u23 (ref)
    return u22 or u23;
end;

local function getDealPose(p102: userdata, p103: number) -- Line: 831
    -- upvalues: u16 (ref), u11 (copy), u15 (ref), u7 (ref), u33 (ref), workspace_CurrentCamera (copy), TweenService (copy), Cubic (copy), Back (copy), u14 (ref)
    local v104 = u16[p102];
    local v105 = u11[p102];

    if not (v104 and v105) then
        return nil, u15;
    end;

    if not u7[p102] then
        v104 = v104 * CFrame.Angles(0, 3.141592653589793, 0);
    end;

    local v106 = v105 * u15;
    local v107 = u33 or workspace_CurrentCamera.CFrame;
    local Vector3_new_ret = Vector3.new(v107.RightVector.X, 0, v107.RightVector.Z);
    local v108 = Vector3_new_ret.Magnitude <= 0.001 and Vector3.new(1, 0, 0) or Vector3_new_ret.Unit;
    local v109 = (Vector3.new(0, 1, 0)):Cross(v108);
    local v110 = -v108 * (v106.X * 1.4) + v109 * 3;
    local v111 = v104.Position - Vector3.new(0, 4, 0) + v110;
    local Value = TweenService:GetValue(p103, Cubic, Enum.EasingDirection.Out);
    local Value2 = TweenService:GetValue(math.min(Value / 0.4, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local Value3 = TweenService:GetValue(math.clamp((Value - 0.3) / 0.7, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
    local v112 = v106.Y * 0.3 * math.sin(3.141592653589793 * Value3);
    local v113 = 1 - TweenService:GetValue(p103, Back, Enum.EasingDirection.Out);
    local v114 = CFrame.fromAxisAngle(v109, -0.4188790204786391 * v113) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -0.6108652381980153 * v113);
    local v115 = math.clamp((Value - 0.4) / 0.6, 0, 1) * -0.30000000000000004 + 1;
    local v116 = CFrame.new(v111 + Vector3.new(0, 1, 0) * (4 * Value2 + v112) - v110 * Value3) * v114 * v104.Rotation;
    local v117 = u14;

    if v117 then
        v116 = v116 - v116.Position + (v117 + (v116.Position - v117) * v115);
    end;

    return v116, u15 * v115;
end;

local function settleDeal() -- Line: 879
    -- upvalues: u26 (ref), u22 (ref), u23 (ref), u5 (ref), u20 (copy), u9 (ref), u6 (ref), u7 (ref), setCardScale (copy), u15 (ref), u24 (copy), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref)
    u26 = u26 + 1;
    u22 = false;
    u23 = false;

    for _, v in u5 do
        u20:Remove((`CardDeal_{u9[v] or 0}`));
        local v118 = u6[v];

        if v118 then
            if not u7[v] then
                v118 = v118 * CFrame.Angles(0, 3.141592653589793, 0);
            end;
        else
            v118 = nil;
        end;

        if v118 then
            setCardScale(v, u15 * 0.7);
            v.CFrame = v118;
        end;

        u24[v] = true;
    end;

    for _, v in u5 do
        local v119;

        if u17[v] == true and not (u18 or u19) then
            v119 = not (u22 or u23) or u24[v] == true;
        else
            v119 = false;
        end;

        applyCardVisibility(v, v119);
    end;
end;

local function runDeal() -- Line: 910
    -- upvalues: u26 (ref), u25 (ref), u22 (ref), u23 (ref), u5 (ref), u24 (copy), getDealPose (copy), setCardScale (copy), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), playDealerLine (copy), script_DealerLines (copy), u6 (ref), u7 (ref), TweenService (copy), u20 (copy), u9 (ref), settleDeal (copy)
    u26 = u26 + 1;
    local u120 = u26;
    local u121 = u25;
    u22 = true;
    u23 = false;
    u25 = true;

    for _, v in u5 do
        u24[v] = false;
        local v122, v123 = getDealPose(v, 0);

        if v122 then
            setCardScale(v, v123);
            v.CFrame = v122;
        end;
    end;

    for _, v in u5 do
        local v124;

        if u17[v] == true and not (u18 or u19) then
            v124 = not (u22 or u23) or u24[v] == true;
        else
            v124 = false;
        end;

        applyCardVisibility(v, v124);
    end;

    task.spawn(function() -- Line: 931
        -- upvalues: u121 (copy), playDealerLine (ref), script_DealerLines (ref), u26 (ref), u120 (copy), u5 (ref), u6 (ref), u7 (ref), u24 (ref), applyCardVisibility (ref), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), getDealPose (ref), setCardScale (ref), TweenService (ref), u20 (ref), u9 (ref), settleDeal (ref)
        if u121 then
            playDealerLine(script_DealerLines.Open);
        end;

        task.wait(0.25);

        if u26 ~= u120 then
            return;
        end;

        for i, v in u5 do
            if u26 ~= u120 then
                return;
            end;

            local v125 = u6[v];

            if v125 then
                if not u7[v] then
                    v125 = v125 * CFrame.Angles(0, 3.141592653589793, 0);
                end;
            else
                v125 = nil;
            end;

            if v125 then
                u24[v] = true;
                local v126;

                if u17[v] == true and not (u18 or u19) then
                    v126 = not (u22 or u23) or u24[v] == true;
                else
                    v126 = false;
                end;

                applyCardVisibility(v, v126);
                local NumberValue = Instance.new("NumberValue");
                NumberValue.Changed:Connect(function(p127: number) -- Line: 956
                    -- upvalues: getDealPose (ref), v (copy), setCardScale (ref)
                    local v128, v129 = getDealPose(v, p127);

                    if v128 then
                        setCardScale(v, v129);
                        v.CFrame = v128;
                    end;
                end);
                local u130 = TweenService:Create(NumberValue, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {
                    Value = 1
                });
                u20:Add(function() -- Line: 968
                    -- upvalues: u130 (copy), NumberValue (copy)
                    u130:Destroy();
                    NumberValue:Destroy();
                end, true, (`CardDeal_{u9[v] or i}`));
                u130:Play();
            end;

            if i < #u5 then
                task.wait(0.14);
            end;
        end;

        task.wait(0.8);

        if u26 ~= u120 then
            return;
        end;

        settleDeal();
    end);
end;

local function startDealIfReady() -- Line: 999
    -- upvalues: u23 (ref), u21 (ref), u18 (ref), u19 (ref), u5 (ref), u17 (ref), runDeal (copy)
    if not (u23 and (u21 and not (u18 or u19))) then
        return;
    end;

    local v131 = false;

    for _, v in u5 do
        if u17[v] == true then
            v131 = true;
            break;
        end;
    end;

    if not v131 then
        return;
    end;

    runDeal();
end;

local function makeSceneInert(p132: userdata) -- Line: 1036
    local Cards = p132:FindFirstChild("Cards");

    for _, descendant in p132:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = descendant.Parent == Cards;
        end;
    end;
end;

local function captureDesignRow() -- Line: 1054
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

    local v133 = u5[1];
    local v134 = u5[#u5];
    local v135;

    if v133 then
        v135 = u10[v133];
    else
        v135 = v133;
    end;

    if v134 then
        v134 = u10[v134];
    end;

    if not (v135 and v134) then
        u13 = nil;

        return;
    end;

    u13 = (v135.Position + v134.Position) / 2 - v135.UpVector * (u11[v133].Y / 2);
    local v136 = u4;

    if v136 then
        v136 = v136:FindFirstChild("Camera");
    end;

    if v136 then
        v136 = v136:FindFirstChild("Cards");
    end;

    if not (v136 and (v136:IsA("BasePart") and v136)) then
        v136 = nil;
    end;

    if v136 then
        v136 = v136.Position;
    end;

    u14 = v136;
end;

local function applyRowFit() -- Line: 1093
    -- upvalues: u13 (ref), workspace_CurrentCamera (copy), u15 (ref), u5 (ref), u10 (copy), u16 (ref), u14 (ref), u6 (ref), u9 (ref), u20 (copy), u8 (ref), u7 (ref), setCardScale (copy), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    local v137 = u13;

    if not v137 then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if ViewportSize.Y <= 0 then
        return;
    end;

    local math_min_ret = math.min(1, ViewportSize.X / ViewportSize.Y / 1.7777777777777777);
    u15 = math_min_ret;

    for _, v in u5 do
        local v138 = u10[v];

        if v138 then
            local v139 = v138 - v138.Position + (v137 + (v138.Position - v137) * math_min_ret);
            u16[v] = v139;
            local v140 = u14;

            if v140 then
                v139 = v139 - v139.Position + (v140 + (v139.Position - v140) * 0.7);
            end;

            u6[v] = v139;
            local v141 = u9[v] or 0;
            u20:Remove((`CardFlip_{u9[v] or 0}`));
            local v142 = u8[v];

            if v142 then
                v142.IsTurning = false;
                v142.Target = u7[v] and 0 or 3.141592653589793;
                v142.Angle.Value = v142.Target;
            end;

            u20:Remove((`CardDeal_{v141}`));
            setCardScale(v, math_min_ret * 0.7);

            if not u7[v] then
                v139 = v139 * CFrame.Angles(0, 3.141592653589793, 0);
            end;

            v.CFrame = v139;
            local v143;

            if u17[v] == true and not (u18 or u19) then
                v143 = not (u22 or u23) or u24[v] == true;
            else
                v143 = false;
            end;

            applyCardVisibility(v, v143);
        end;
    end;
end;

local function collectCards(p144: userdata) -- Line: 1133
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
    local Cards = p144:FindFirstChild("Cards");

    if not Cards then
        warn("[BlackMarketSceneController]: scene is missing its Cards folder");

        return;
    end;

    for _, child in Cards:GetChildren() do
        if child:IsA("BasePart") then
            table.insert(u5, child);
        end;
    end;

    table.sort(u5, function(p145, p146) -- Line: 1159
        return p145.Position.Z < p146.Position.Z;
    end);

    for i, v in u5 do
        u9[v] = i;
    end;

    captureDesignRow();
    applyRowFit();
end;

function u1.IsActive() -- Line: 1174
    -- upvalues: u21 (ref)
    return u21;
end;

function u1.GetCards() -- Line: 1180
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.GetCardFaces(p147: userdata) -- Line: 1190
    local Back2 = p147:FindFirstChild("Back");
    local Front = p147:FindFirstChild("Front");

    if Back2 then
        Back2 = Back2:FindFirstChild("Main");
    end;

    if Front then
        Front = Front:FindFirstChild("Main");
    end;

    return Back2, Front;
end;

function u1.IsCardFaceUp(p148: userdata) -- Line: 1198
    -- upvalues: u7 (ref)
    return u7[p148] == true;
end;

function u1.SetCardFaceUp(u149: userdata, p150: boolean, p151: boolean?) -- Line: 1210
    -- upvalues: u6 (ref), u7 (ref), u22 (ref), u23 (ref), u20 (copy), u9 (ref), u8 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u19 (ref), u24 (copy), getCardSpin (copy), Random_new_ret (copy), TweenService (copy)
    local v152 = u6[u149];

    if not v152 then
        return;
    end;

    if u7[u149] == p150 then
        return;
    end;

    if p151 and (u22 or u23) then
        return;
    end;

    if not p151 then
        u7[u149] = p150;
        u20:Remove((`CardFlip_{u9[u149] or 0}`));
        local v153 = u8[u149];

        if v153 then
            v153.IsTurning = false;
            v153.Target = u7[u149] and 0 or 3.141592653589793;
            v153.Angle.Value = v153.Target;
        end;

        if not p150 then
            v152 = v152 * CFrame.Angles(0, 3.141592653589793, 0);
        end;

        u149.CFrame = v152;
        local v154;

        if u17[u149] == true and not (u18 or u19) then
            v154 = not (u22 or u23) or u24[u149] == true;
        else
            v154 = false;
        end;

        applyCardVisibility(u149, v154);

        return;
    end;

    local u155 = getCardSpin(u149);
    local IsTurning = u155.IsTurning;

    if not IsTurning then
        u155.Angle.Value = u7[u149] and 0 or 3.141592653589793;
        u155.Target = u155.Angle.Value;
        u155.Direction = Random_new_ret:NextInteger(0, 1) == 0 and -1 or 1;
    end;

    u155.Target = u155.Target + u155.Direction * 3.141592653589793;
    local math_abs_ret = math.abs(u155.Target - u155.Angle.Value);
    local v156;

    if IsTurning then
        v156 = Enum.EasingDirection.Out;
    else
        v156 = Enum.EasingDirection.InOut;
    end;

    local v157 = TweenService:Create(u155.Angle, TweenInfo.new(math_abs_ret * 0.42 / 3.141592653589793, Enum.EasingStyle.Quad, v156), {
        Value = u155.Target
    });
    v157.Completed:Once(function(p158) -- Line: 1260
        -- upvalues: u155 (copy), u7 (ref), u149 (copy)
        if p158 ~= Enum.PlaybackState.Completed then
            return;
        end;

        u155.IsTurning = false;
        u155.Target = u7[u149] and 0 or 3.141592653589793;
        u155.Angle.Value = u155.Target;
    end);
    u20:Add(v157, "Destroy", (`CardFlip_{u9[u149] or 0}`));
    u7[u149] = p150;
    u155.IsTurning = true;
    v157:Play();
end;

function u1.ResetCards() -- Line: 1291
    -- upvalues: u5 (ref), u8 (ref), u20 (copy), u9 (ref), u7 (ref), u6 (ref), u1 (copy)
    for _, v in u5 do
        local v159 = u8[v];

        if v159 and v159.IsTurning then
            u20:Remove((`CardFlip_{u9[v] or 0}`));
            local v160 = u8[v];

            if v160 then
                v160.IsTurning = false;
                v160.Target = u7[v] and 0 or 3.141592653589793;
                v160.Angle.Value = v160.Target;
            end;

            local v161 = u6[v];

            if v161 then
                if not u7[v] then
                    v161 = v161 * CFrame.Angles(0, 3.141592653589793, 0);
                end;
            else
                v161 = nil;
            end;

            if v161 then
                v.CFrame = v161;
            end;
        end;

        u1.SetCardFaceUp(v, false, false);
    end;
end;

function u1.SetCardVisible(p162: userdata, p163: boolean) -- Line: 1309
    -- upvalues: u17 (ref), applyCardVisibility (copy), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    u17[p162] = p163;
    local v164;

    if u17[p162] == true and not (u18 or u19) then
        v164 = not (u22 or u23) or u24[p162] == true;
    else
        v164 = false;
    end;

    applyCardVisibility(p162, v164);
end;

function u1.IsCardShown(p165: userdata) -- Line: 1321
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy)
    if u17[p165] == true and not (u18 or u19) then
        return not (u22 or u23) or u24[p165] == true;
    end;

    return false;
end;

function u1.SetRevealHeld(p166: boolean) -- Line: 1332
    -- upvalues: u19 (ref), u5 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u22 (ref), u23 (ref), u24 (copy), startDealIfReady (copy)
    if u19 == p166 then
        return;
    end;

    u19 = p166;

    for _, v in u5 do
        local v167;

        if u17[v] == true and not (u18 or u19) then
            v167 = not (u22 or u23) or u24[v] == true;
        else
            v167 = false;
        end;

        applyCardVisibility(v, v167);
    end;

    startDealIfReady();
end;

function u1.ReplayIntro() -- Line: 1354
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
        local v168;

        if u17[v] == true and not (u18 or u19) then
            v168 = not (u22 or u23) or u24[v] == true;
        else
            v168 = false;
        end;

        applyCardVisibility(v, v168);
    end;

    local v169 = u4;

    if v169 then
        v169 = v169:FindFirstChild("Camera");
    end;

    if v169 then
        v169 = v169:FindFirstChild("Cards");
    end;

    if not (v169 and (v169:IsA("BasePart") and v169)) then
        v169 = nil;
    end;

    if v169 then
        u33 = v169.CFrame;
        u34 = nil;
        u35 = nil;
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
    end;

    local v170 = u33;

    if v170 then
        u34 = -v170.LookVector * 6;
        u35 = Vector3.new(0, 4, 0);
        u36 = os.clock();
    end;

    local INTRO_ANIMATION = script_DealerLines.INTRO_ANIMATION;
    local v171 = u27;
    local v172;

    if v171 then
        v172 = u28[INTRO_ANIMATION];

        if not v172 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = INTRO_ANIMATION;
            v172 = v171:LoadAnimation(Animation);
            u28[INTRO_ANIMATION] = v172;
        end;
    else
        v172 = nil;
    end;

    if not v172 then
        return;
    end;

    local v173 = u32;
    u32 = nil;

    if v173 and v173.IsPlaying then
        v173:Stop(0.15);
    end;

    v172.Looped = false;
    v172.Priority = Enum.AnimationPriority.Movement;
    v172:Stop(0);
    v172:Play(0.15);
    u32 = v172;
end;

function u1.Redeal() -- Line: 1385
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
        local v174;

        if u17[v] == true and not (u18 or u19) then
            v174 = not (u22 or u23) or u24[v] == true;
        else
            v174 = false;
        end;

        applyCardVisibility(v, v174);
    end;
end;

function u1.SkipIntro() -- Line: 1411
    -- upvalues: u21 (ref), u4 (ref), u33 (ref), u34 (ref), u35 (ref), u18 (ref), u5 (ref), applyCardVisibility (copy), u17 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (copy), startDealIfReady (copy)
    if not u21 then
        return;
    end;

    local v175 = u4;

    if v175 then
        v175 = v175:FindFirstChild("Camera");
    end;

    if v175 then
        v175 = v175:FindFirstChild("Cards");
    end;

    if not (v175 and (v175:IsA("BasePart") and v175)) then
        v175 = nil;
    end;

    if v175 then
        u33 = v175.CFrame;
        u34 = nil;
        u35 = nil;
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
    end;

    u18 = false;

    for _, v in u5 do
        local v176;

        if u17[v] == true and not (u18 or u19) then
            v176 = not (u22 or u23) or u24[v] == true;
        else
            v176 = false;
        end;

        applyCardVisibility(v, v176);
    end;

    startDealIfReady();
end;

function u1.IsPresenting() -- Line: 1430
    -- upvalues: u18 (ref), u22 (ref), u23 (ref)
    return u18 or (u22 or u23);
end;

function u1.SkipPresentation() -- Line: 1443
    -- upvalues: u21 (ref), u18 (ref), u34 (ref), u4 (ref), u33 (ref), u35 (ref), settleDeal (copy)
    if not u21 then
        return;
    end;

    if u18 or u34 then
        local v177 = u4;

        if v177 then
            v177 = v177:FindFirstChild("Camera");
        end;

        if v177 then
            v177 = v177:FindFirstChild("Cards");
        end;

        if not (v177 and (v177:IsA("BasePart") and v177)) then
            v177 = nil;
        end;

        if v177 then
            u33 = v177.CFrame;
            u34 = nil;
            u35 = nil;
        else
            warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
        end;

        u18 = false;
    end;

    settleDeal();
end;

function u1.PlayPurchaseLine() -- Line: 1461
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Purchase);
end;

function u1.PlayDeclineLine() -- Line: 1465
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Declined);
end;

function u1.PlayRefreshLine() -- Line: 1475
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Refresh);
end;

function u1.PlayDiscontinuedLine() -- Line: 1479
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    playDealerLine(script_DealerLines.Discontinued);
end;

function u1.PlayRarityLine(p178: string?) -- Line: 1491
    -- upvalues: playDealerLine (copy), script_DealerLines (copy)
    if typeof(p178) ~= "string" then
        return;
    end;

    playDealerLine(script_DealerLines.Rarity[p178]);
end;

function u1.NotifyDealRendered() -- Line: 1507
    -- upvalues: startDealIfReady (copy)
    startDealIfReady();
end;

function u1.Show(p179: boolean?) -- Line: 1513
    -- upvalues: u21 (ref), u4 (ref), SceneParking (copy), u19 (ref), collectCards (copy), u1 (copy), u5 (ref), applyCardVisibility (copy), u17 (ref), u18 (ref), u22 (ref), u23 (ref), u24 (copy), applySceneLighting (copy), script_DealerLines (copy), u27 (ref), u28 (copy), u29 (ref), u25 (ref), u37 (ref), u38 (ref), captureGameplayAim (copy), workspace_CurrentCamera (copy), CameraController (copy), setPerspectiveSinksInput (copy), u33 (ref), u34 (ref), u35 (ref), u36 (ref), u32 (ref), RunServiceController (copy), u2 (copy), TweenService (copy), Sine (copy), startDealIfReady (copy), u20 (copy), applyRowFit (copy), BakedViewmodelMirror (copy), hideInstance (copy)
    if u21 then
        return;
    end;

    local v180 = u4;

    if not v180 then
        warn("[BlackMarketSceneController]: scene was never staged");

        return;
    end;

    SceneParking.Unpark(v180);
    u21 = true;
    u19 = false;
    collectCards(v180);
    u1.ResetCards();

    for _, v in u5 do
        local v181;

        if u17[v] == true and not (u18 or u19) then
            v181 = not (u22 or u23) or u24[v] == true;
        else
            v181 = false;
        end;

        applyCardVisibility(v, v181);
    end;

    applySceneLighting();
    local IDLE_ANIMATION = script_DealerLines.IDLE_ANIMATION;
    local v182 = u27;
    local v183;

    if v182 then
        v183 = u28[IDLE_ANIMATION];

        if not v183 then
            local Animation = Instance.new("Animation");
            Animation.AnimationId = IDLE_ANIMATION;
            v183 = v182:LoadAnimation(Animation);
            u28[IDLE_ANIMATION] = v183;
        end;
    else
        v183 = nil;
    end;

    if v183 then
        v183.Looped = true;
        v183.Priority = Enum.AnimationPriority.Idle;

        if not v183.IsPlaying then
            v183:Play(0.15);
        end;

        u29 = v183;
    end;

    u23 = not p179;
    u25 = true;
    table.clear(u24);

    if not p179 then
        u37 = nil;
        u38 = nil;
    end;

    u37 = captureGameplayAim() or u37;
    u38 = u38 or workspace_CurrentCamera.CameraType;
    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CameraController.setFOVLock("BlackMarketScene", true, 70);
    CameraController.setForceLockOverride("BlackMarketScene", true);
    setPerspectiveSinksInput(false);
    u18 = not p179;
    local v184 = u4;

    if v184 then
        v184 = v184:FindFirstChild("Camera");
    end;

    if v184 then
        v184 = v184:FindFirstChild("Cards");
    end;

    if not (v184 and (v184:IsA("BasePart") and v184)) then
        v184 = nil;
    end;

    if v184 then
        u33 = v184.CFrame;
        u34 = nil;
        u35 = nil;
    else
        warn("[BlackMarketSceneController]: scene is missing Camera.Cards");
    end;

    if not p179 then
        local v185 = u33;

        if v185 then
            u34 = -v185.LookVector * 6;
            u35 = Vector3.new(0, 4, 0);
            u36 = os.clock();
        end;

        local INTRO_ANIMATION = script_DealerLines.INTRO_ANIMATION;
        local v186 = u27;
        local v187;

        if v186 then
            v187 = u28[INTRO_ANIMATION];

            if not v187 then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = INTRO_ANIMATION;
                v187 = v186:LoadAnimation(Animation);
                u28[INTRO_ANIMATION] = v187;
            end;
        else
            v187 = nil;
        end;

        if v187 then
            local v188 = u32;
            u32 = nil;

            if v188 and v188.IsPlaying then
                v188:Stop(0.15);
            end;

            v187.Looped = false;
            v187.Priority = Enum.AnimationPriority.Movement;
            v187:Stop(0);
            v187:Play(0.15);
            u32 = v187;
        end;
    end;

    RunServiceController.BindToRenderStep("BlackMarketSceneController.CameraUpdate", u2, function() -- Line: 1563
        -- upvalues: u33 (ref), workspace_CurrentCamera (ref), u34 (ref), u35 (ref), u36 (ref), TweenService (ref), Sine (ref), u18 (ref), u5 (ref), applyCardVisibility (ref), u17 (ref), u19 (ref), u22 (ref), u23 (ref), u24 (ref), startDealIfReady (ref)
        local v189 = u33;

        if not v189 then
            return;
        end;

        workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
        local v190 = u34;
        local v191 = u35;

        if v190 and v191 then
            local v192 = (os.clock() - u36 - 0.2) / 1.4;
            local math_clamp_ret = math.clamp(v192, 0, 1);
            local v193 = 1.5707963267948966 * TweenService:GetValue(math_clamp_ret, Sine, Enum.EasingDirection.InOut);
            workspace_CurrentCamera.CFrame = v189 + v190 * math.cos(v193) + v191 * (1 - math.sin(v193));

            if math_clamp_ret >= 1 then
                u34 = nil;
                u35 = nil;

                if u18 then
                    u18 = false;

                    for _, v in u5 do
                        local v194;

                        if u17[v] == true and not (u18 or u19) then
                            v194 = not (u22 or u23) or u24[v] == true;
                        else
                            v194 = false;
                        end;

                        applyCardVisibility(v, v194);
                    end;

                    startDealIfReady();
                end;
            end;
        else
            workspace_CurrentCamera.CFrame = v189;
        end;

        workspace_CurrentCamera.Focus = workspace_CurrentCamera.CFrame;
    end);
    u20:Add(function() -- Line: 1599
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

    u20:Add(workspace_CurrentCamera.ChildAdded:Connect(function(p195) -- Line: 1620
        -- upvalues: hideInstance (ref)
        if p195:IsA("Model") or p195:IsA("BasePart") then
            hideInstance(p195);

            for _, descendant in p195:GetDescendants() do
                hideInstance(descendant);
            end;
        end;
    end), "Disconnect", "ViewmodelListener");
    u1.OnActiveChanged:Fire(true);
end;

function u1.Hide() -- Line: 1634
    -- upvalues: u21 (ref), u18 (ref), u19 (ref), u26 (ref), u22 (ref), u23 (ref), stopCurrentLine (copy), u32 (ref), u29 (ref), u20 (copy), u33 (ref), u34 (ref), u35 (ref), ReplicatedStorage (copy), restoreGameplayAim (copy), u38 (ref), workspace_CurrentCamera (copy), CameraController (copy), Constants (copy), setPerspectiveSinksInput (copy), showViewmodels (copy), BakedViewmodelMirror (copy), u4 (ref), SceneParking (copy), u1 (copy)
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
    local v196 = u32;
    u32 = nil;

    if v196 and v196.IsPlaying then
        v196:Stop(0.15);
    end;

    if u29 then
        u29:Stop(0.15);
        u29 = nil;
    end;

    u20:Cleanup();
    u33 = nil;
    u34 = nil;
    u35 = nil;
    local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
    local MenuState = require(ReplicatedStorage.Interface.MenuState);
    local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
    local Custom = Enum.CameraType.Custom;

    if not MenuState.IsInspectActive() then
        restoreGameplayAim();

        if u38 and SpectateController.IsSpectatingNow() then
            Custom = u38;
        end;

        u38 = nil;
    end;

    workspace_CurrentCamera.CameraType = Custom;
    CameraController.setFOVLock("BlackMarketScene", false);
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    local CurrentSpectateInstance = SpectateController.GetCurrentSpectateInstance();

    if CurrentSpectateInstance then
        CurrentSpectateInstance:UpdateScopeState();
    end;

    CameraController.setForceLockOverride("BlackMarketScene", false);
    setPerspectiveSinksInput(true);
    showViewmodels();
    BakedViewmodelMirror.SetSuppressed(false);

    if not MenuState.IsInspectActive() then
        if workspace:FindFirstChild("Map") then
            MenuSceneController.ApplyMapLighting();
        else
            MenuSceneController.ApplyMenuSceneLighting();
        end;
    end;

    if u4 then
        SceneParking.Park(u4);
    end;

    u1.OnActiveChanged:Fire(false);
end;

function u1.Initialize() -- Line: 1701
    -- upvalues: Constants (copy), ReplicatedStorage (copy), SceneParking (copy), u4 (ref), makeSceneInert (copy), u27 (ref), attachUnskinnedParts (copy), collectCards (copy), u1 (copy)
    if not Constants.BLACK_MARKET_ENABLED then
        return;
    end;

    local BlackMarketScene = ReplicatedStorage.Assets:FindFirstChild("BlackMarketScene");

    if not BlackMarketScene then
        warn("[BlackMarketSceneController]: Assets.BlackMarketScene is missing");

        return;
    end;

    local v197 = BlackMarketScene:FindFirstChildOfClass("Model");

    if not v197 then
        warn("[BlackMarketSceneController]: no model inside Assets.BlackMarketScene");

        return;
    end;

    local v198 = v197:Clone();
    v198.Name = "BlackMarketScene";
    SceneParking.Park(v198);
    u4 = v198;
    makeSceneInert(v198);
    local v199 = v198:FindFirstChildWhichIsA("AnimationController", true);
    local v200;

    if v199 then
        v200 = v199:FindFirstChildOfClass("Animator");
    else
        v200 = v199;
    end;

    if v200 then
        u27 = v200;
        attachUnskinnedParts(v199.Parent);
    else
        warn("[BlackMarketSceneController]: the scene\'s dealer has no Animator, so he will not move");
    end;

    collectCards(v198);
    u1.ResetCards();
end;

return u1;