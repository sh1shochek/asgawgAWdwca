-- Decompiled with Potassium's decompiler.

local u1 = {};
local ContextActionService = game:GetService("ContextActionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local MainGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui", (1 / 0));
local SceneRegistry = require(script:WaitForChild("SceneRegistry"));
local ConsoleBoardAnimator = require(script:WaitForChild("ConsoleBoardAnimator"));
require(ReplicatedStorage.Database.Custom.ConsoleTypes);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local SceneParking = require(ReplicatedStorage.Components.Common.SceneParking);
local MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Router = require(ReplicatedStorage.Database.Security.Router);
local MenuState = require(ReplicatedStorage.Interface.MenuState);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = false;
local u3 = {};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = Janitor.new();
local u8 = false;
local u9 = nil;
local u10 = {};
local u11 = false;
local u12 = nil;
local u13 = nil;
local u14 = 0;
local u15 = nil;
local u16 = {};
local u17 = nil;
local u18 = nil;

local function DebugLog(...) -- Line: 86
end;

local u19 = false;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = 0;
local u24 = 1;
local u25 = 0;
local u26 = nil;
local u27 = false;
local u28 = false;

local function getSceneSound(p29: string, p30: string) -- Line: 107
    -- upvalues: u6 (ref)
    local v31 = u6 and u6.Sounds;

    if v31 then
        p30 = v31[p29] or p30;
    end;

    return p30;
end;

local function getDragSettings() -- Line: 112
    -- upvalues: u6 (ref)
    return u6 and u6.DragSettings;
end;

local function clearConsoleOpeningState() -- Line: 116
    -- upvalues: u17 (ref), u7 (copy)
    if u17 then
        u7:Remove("ConsoleAnimator");
        u17 = nil;
    end;
end;

local function hideMenuFrames() -- Line: 123
    -- upvalues: MenuState (copy), u2 (ref), MenuSceneController (copy)
    MenuState.EnterCaseScene();
    local MenuFrame = MenuState.GetMenuFrame();

    if not MenuFrame then
        return;
    end;

    u2 = MenuSceneController.IsActive();

    if u2 then
        MenuSceneController.HideMenuScene(true, true);
        MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5);
    end;

    MenuState.SetBlurEnabled(false);
    MenuFrame.BackgroundTransparency = 1;
    local Pattern = MenuFrame:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = false;
    end;

    local Top = MenuFrame:FindFirstChild("Top");

    if Top then
        Top.Visible = false;
    end;

    local Store = MenuFrame:FindFirstChild("Store");

    if Store then
        Store.Visible = true;
    end;

    for _, child in MenuFrame:GetChildren() do
        if child:IsA("Frame") and (child.Name ~= "Top" and (child.Name ~= "Store" and child.Name ~= "OpenCase")) then
            child.Visible = false;
        end;
    end;
end;

local function hideViewmodel(p32: userdata) -- Line: 166
    -- upvalues: u10 (ref)
    for _, descendant in p32:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Texture") then
            if descendant.Transparency < 1 then
                descendant:SetAttribute("_CaseScenePrevTransparency", descendant.Transparency);
                descendant.Transparency = 1;
            end;
        elseif descendant:IsA("SurfaceGui") and descendant.Enabled then
            descendant:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", true);
            descendant.Enabled = false;
        end;
    end;

    table.insert(u10, p32);
end;

local function hideViewmodels() -- Line: 184
    -- upvalues: u10 (ref), u6 (ref), workspace_CurrentCamera (copy), hideViewmodel (copy)
    u10 = {};
    local v33 = u6 and u6.AssetFolder or nil;

    for _, child in workspace_CurrentCamera:GetChildren() do
        if child:IsA("Model") and child.Name ~= v33 then
            hideViewmodel(child);
        end;
    end;
end;

local function showViewmodels() -- Line: 194
    -- upvalues: u10 (ref)
    for _, v in u10 do
        if v and v.Parent then
            for _, descendant in v:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Texture") then
                    local Attribute = descendant:GetAttribute("_CaseScenePrevTransparency");

                    if Attribute == nil then
                        if descendant:IsA("Texture") then
                            descendant.Transparency = 0.3;
                        end;
                    else
                        descendant.Transparency = Attribute;
                        descendant:SetAttribute("_CaseScenePrevTransparency", nil);
                    end;
                elseif descendant:IsA("SurfaceGui") and descendant:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") ~= nil then
                    descendant.Enabled = true;
                    descendant:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil);
                end;
            end;
        end;
    end;

    u10 = {};
end;

local function applyCaseFog(p34: userdata) -- Line: 220
    -- upvalues: Lighting (copy)
    local CaseFog = p34:FindFirstChild("CaseFog", true);

    if not (CaseFog and CaseFog:IsA("Atmosphere")) then
        return;
    end;

    for _, child in Lighting:GetChildren() do
        if child:IsA("Atmosphere") then
            child:Destroy();
        end;
    end;

    CaseFog:Clone().Parent = Lighting;
end;

local function restoreLightingAfterSkippedFrameRestore() -- Line: 235
    -- upvalues: MenuSceneController (copy), u2 (ref)
    if workspace:FindFirstChild("Map") then
        MenuSceneController.ApplyMapLighting();

        return;
    end;

    if u2 then
        MenuSceneController.ApplyMenuSceneLighting();
    end;
end;

local function restoreMenuFrames() -- Line: 246
    -- upvalues: MenuState (copy), u2 (ref), MenuSceneController (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if not (MenuFrame and MenuFrame.Visible) then
        u2 = false;
        MenuState.ExitCaseScene();
        MenuSceneController.ApplyMapLighting();

        return;
    end;

    local ScreenBeforeCaseScene = MenuState.GetScreenBeforeCaseScene();
    local v35 = u2;
    u2 = false;
    MenuState.ExitCaseScene();

    if v35 then
        MenuSceneController.ShowMenuScene();
        MenuSceneController.SetMusicVolumeMultiplier(1, 0.5);
    else
        MenuSceneController.ApplyMapLighting();
    end;

    local Top = MenuFrame:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    local v36 = MenuFrame:FindFirstChild(ScreenBeforeCaseScene or "Dashboard");

    if v36 then
        v36.Visible = true;
    elseif ScreenBeforeCaseScene then
        return;
    end;

    local v37;

    if ScreenBeforeCaseScene == nil or ScreenBeforeCaseScene == "Dashboard" then
        v37 = false;
    else
        v37 = ScreenBeforeCaseScene ~= "Play";
    end;

    MenuState.SetBlurEnabled(v37);
    MenuFrame.BackgroundTransparency = v37 and 0.15 or 1;
    local Pattern = MenuFrame:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = not v37;
    end;
end;

local function cleanupCaseModel(p38: userdata) -- Line: 295
    local CaseMod = p38:FindFirstChild("CaseMod");

    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy();
    end;
end;

local function setupCaseModel(p39: userdata, p40: string) -- Line: 305
    -- upvalues: ReplicatedStorage (copy)
    local CaseMod = p39:FindFirstChild("CaseMod");

    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy();
    end;

    local CaseModels = ReplicatedStorage.Assets:FindFirstChild("CaseModels");

    if not CaseModels then
        warn("[CaseSceneController]: CaseModels folder not found in ReplicatedStorage.Assets");

        return nil;
    end;

    local v41 = CaseModels:FindFirstChild(p40);

    if not v41 then
        warn("[CaseSceneController]: Case model not found for case: " .. p40);

        return nil;
    end;

    local v42 = v41:Clone();
    v42.Name = "CaseMod";
    v42:SetAttribute("IsDynamicModel", true);
    local CasePivot = p39:FindFirstChild("CasePivot");

    if CasePivot then
        v42:PivotTo(CasePivot.CFrame);
    else
        warn("[CaseSceneController]: CasePivot not found in CaseScene");
    end;

    v42.Parent = p39;

    return v42;
end;

local function getCameraPosition(p43: string?) -- Line: 337
    -- upvalues: u4 (ref)
    local v44 = u4 and u4:FindFirstChild("Camera");

    if v44 and (p43 == "Inspecting" or p43 == "Unboxing") then
        return v44:FindFirstChild(p43);
    end;

    return nil;
end;

local function startCameraLerp(p45: userdata, p46: function?) -- Line: 347
    -- upvalues: u9 (ref), u4 (ref), u11 (ref), u12 (ref), workspace_CurrentCamera (copy), u13 (ref), u14 (ref), u15 (ref)
    local v47 = u9;
    local v48 = u4 and u4:FindFirstChild("Camera");
    local v49;

    if v48 and (v47 == "Inspecting" or v47 == "Unboxing") then
        v49 = v48:FindFirstChild(v47);
    else
        v49 = nil;
    end;

    u11 = true;
    local v50;

    if v49 then
        v50 = v49.CFrame;
    else
        v50 = workspace_CurrentCamera.CFrame;
    end;

    u12 = v50;
    u13 = p45.CFrame;
    u14 = tick();
    u15 = p46;
end;

local function ensureAnimator(p51: userdata) -- Line: 360
    local v52 = p51:FindFirstChildOfClass("Animator");

    if not v52 then
        v52 = Instance.new("Animator");
        v52.Parent = p51;
    end;

    return v52;
end;

local function findAnimationController(p53: userdata, p54: any) -- Line: 369
    local v55 = p54.AssetFolder == "ConsoleScene";
    local v56;

    if v55 then
        v56 = p53:FindFirstChild("ConsoleLaptop", true);
    elseif p54.InteractionType == "Drag" then
        v56 = p53:FindFirstChild("Pack");
    else
        v56 = p53:FindFirstChild("CaseMod");
    end;

    if not v56 then
        return nil;
    end;

    local v57;

    if v55 then
        v57 = v56:FindFirstChildWhichIsA("AnimationController", true);
    else
        v57 = v56:FindFirstChildOfClass("AnimationController");
    end;

    local v58;

    if v57 then
        v58 = v57:FindFirstChildOfClass("Animator");

        if not v58 then
            v58 = Instance.new("Animator");
            v58.Parent = v57;
        end;
    else
        v58 = v57;
    end;

    return v58;
end;

local function loadAnimations(p59: userdata, p60: any, p61: userdata?) -- Line: 385
    -- upvalues: findAnimationController (copy), u16 (ref)
    if p60.InteractionType == "Click" then
        if p61 then
            p61 = p61:FindFirstChildOfClass("AnimationController");
        end;
    else
        p61 = false;
    end;

    local v62;

    if p61 then
        v62 = p61:FindFirstChildOfClass("Animator");

        if not v62 then
            v62 = Instance.new("Animator");
            v62.Parent = p61;
        end;
    else
        v62 = findAnimationController(p59, p60);
    end;

    if v62 then
        for i, v in p60.Animations do
            if v then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = v;
                u16[i] = v62:LoadAnimation(Animation);
                Animation:Destroy();
            end;
        end;

        return;
    end;

    warn("[CaseSceneController]: No animator found for scene");
end;

local function setEffectsEnabled(p63: userdata?, p64: boolean) -- Line: 410
    if not p63 then
        return;
    end;

    for _, descendant in p63:GetDescendants() do
        if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p64;
        end;
    end;
end;

local function setCaseEffects(p65: boolean, p66: boolean, p67: boolean?) -- Line: 422
    -- upvalues: u4 (ref), setEffectsEnabled (copy)
    local v68 = u4 and u4:FindFirstChild("CaseMod");

    if not v68 then
        return;
    end;

    setEffectsEnabled(v68:FindFirstChild("IdleEffect"), p65);
    setEffectsEnabled(v68:FindFirstChild("OpeningEffect"), p66);

    if p67 ~= nil then
        setEffectsEnabled(v68:FindFirstChild("EffectsPart"), p67);
    end;
end;

local function getKeyframeSounds(p69: string) -- Line: 435
    -- upvalues: u6 (ref)
    local v70 = u6 and u6.AnimationKeyframeSounds;

    if v70 then
        v70 = v70[p69];
    end;

    return v70;
end;

local function setupKeyframeSounds(p71: userdata, p72: table) -- Line: 440
    -- upvalues: Router (copy), u7 (copy)
    for i, v in p72 do
        u7:Add((p71:GetMarkerReachedSignal(i):Connect(function() -- Line: 442
            -- upvalues: Router (ref), v (copy)
            Router.broadcastRouter("RunStoreSound", v);
        end)));
    end;
end;

local function playConsoleAnimationSound(p73: string, u74: string) -- Line: 451
    -- upvalues: u7 (copy), Router (copy)
    u7:Remove(u74);
    local v75 = Router.broadcastRouter("RunStoreSound", p73);

    if not v75 then
        return;
    end;

    u7:Add(v75, "Destroy", u74);
    v75.Destroying:Once(function() -- Line: 458
        -- upvalues: u7 (ref), u74 (copy)
        u7:RemoveNoClean(u74);
    end);
end;

local function freezeAtEnd(u76: userdata, p77: string, p78: string?) -- Line: 464
    -- upvalues: RunServiceController (copy), u7 (copy)
    local u79 = nil;
    u79 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName(p77), function() -- Line: 468
        -- upvalues: u76 (copy), u79 (ref)
        if u76.Length > 0 and u76.TimePosition >= u76.Length - 0.05 then
            u76:AdjustSpeed(0);
            u79:Disconnect();
        end;
    end);
    u7:Add(u79, "Disconnect", p78);
end;

local function playInspectAnimations() -- Line: 480
    -- upvalues: u16 (ref), u5 (ref), setCaseEffects (copy), playConsoleAnimationSound (copy), u6 (ref), RunServiceController (copy), u7 (copy), setupKeyframeSounds (copy), Router (copy), u4 (ref)
    if not (u16.CaseFall and (u5 == "Console" or u16.CloseIdle)) then
        return;
    end;

    setCaseEffects(true, false, true);
    local CaseFall = u16.CaseFall;

    if u5 == "Console" then
        local v80 = u6 and u6.Sounds;
        playConsoleAnimationSound(v80 and v80.Enter or "Console Enter Animation", "ConsoleEnterSound");
        CaseFall:Play();
        local u81 = nil;
        u81 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName("CaseSceneController.ConsoleEnterAnimationFreeze"), function() -- Line: 468
            -- upvalues: CaseFall (copy), u81 (ref)
            if CaseFall.Length > 0 and CaseFall.TimePosition >= CaseFall.Length - 0.05 then
                CaseFall:AdjustSpeed(0);
                u81:Disconnect();
            end;
        end);
        u7:Add(u81, "Disconnect", "ConsoleEnterAnimationFreeze");

        return;
    end;

    local v82 = u6 and u6.AnimationKeyframeSounds;

    if v82 then
        v82 = v82.CaseFall;
    end;

    if v82 then
        setupKeyframeSounds(CaseFall, v82);
    else
        local v83 = u6 and u6.Sounds;
        local u84 = v83 and v83.Drop or "Case Fall";
        u7:Add((CaseFall:GetMarkerReachedSignal("Dropped"):Connect(function() -- Line: 500
            -- upvalues: Router (ref), u84 (copy)
            Router.broadcastRouter("RunStoreSound", u84);
        end)));
    end;

    u7:Add((CaseFall:GetMarkerReachedSignal(v82 and v82.Drop and "Drop" or "Dropped"):Connect(function() -- Line: 509
        -- upvalues: u4 (ref)
        local v85 = u4 and u4:FindFirstChild("DropParticle");

        if not v85 then
            return;
        end;

        for _, child in v85:GetChildren() do
            if child:IsA("ParticleEmitter") then
                local Attribute = child:GetAttribute("EmitCount");

                if typeof(Attribute) == "number" and Attribute > 0 then
                    child:Emit(Attribute);
                end;
            end;
        end;
    end)));
    CaseFall:Play();
    u16.CloseIdle.Looped = true;
    u16.CloseIdle:Play();
end;

local function playOpeningAnimations() -- Line: 532
    -- upvalues: u16 (ref), u5 (ref), u7 (copy), playConsoleAnimationSound (copy), u6 (ref), u4 (ref), setEffectsEnabled (copy), RunServiceController (copy), setupKeyframeSounds (copy), Router (copy)
    if not u16.CaseOpening then
        return;
    end;

    if u16.CloseIdle then
        u16.CloseIdle:Stop();
    end;

    local CaseOpening = u16.CaseOpening;

    if u5 ~= "Console" then
        local v86 = u6 and u6.AnimationKeyframeSounds;

        if v86 then
            v86 = v86.CaseOpening;
        end;

        if v86 then
            setupKeyframeSounds(CaseOpening, v86);
        else
            local v87 = u6 and u6.Sounds;
            Router.broadcastRouter("RunStoreSound", v87 and v87.Opening or "Case Opening");
        end;

        local v88 = u4 and u4:FindFirstChild("CaseMod");

        if v88 then
            setEffectsEnabled(v88:FindFirstChild("IdleEffect"), false);
            setEffectsEnabled(v88:FindFirstChild("OpeningEffect"), true);
        end;

        CaseOpening:Play();

        if u16.OpenIdle then
            u16.OpenIdle.Looped = true;
            u16.OpenIdle:Play();
        end;

        return;
    end;

    u7:Remove("ConsoleEnterSound");
    local v89 = u6 and u6.Sounds;
    playConsoleAnimationSound(v89 and v89.Opening or "Console Open Animation", "ConsoleOpenSound");
    local v90 = u4 and u4:FindFirstChild("CaseMod");

    if v90 then
        setEffectsEnabled(v90:FindFirstChild("IdleEffect"), false);
        setEffectsEnabled(v90:FindFirstChild("OpeningEffect"), true);
    end;

    CaseOpening:Play(0.1, 1, 1);
    local u91 = nil;
    u91 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName("CaseSceneController.ConsoleAnimationFreeze"), function() -- Line: 468
        -- upvalues: CaseOpening (copy), u91 (ref)
        if CaseOpening.Length > 0 and CaseOpening.TimePosition >= CaseOpening.Length - 0.05 then
            CaseOpening:AdjustSpeed(0);
            u91:Disconnect();
        end;
    end);
    u7:Add(u91, "Disconnect", nil);
end;

local function stopAllAnimations() -- Line: 570
    -- upvalues: u16 (ref), u18 (ref)
    for _, v in u16 do
        if v.IsPlaying then
            v:Stop();
        end;
    end;

    if u18 then
        u18:Stop();
        u18:Destroy();
        u18 = nil;
    end;
end;

local function runCharmDragCallback() -- Line: 586
    -- upvalues: u20 (ref)
    local v92 = u20;

    if v92 then
        u20 = nil;
        v92();
    end;
end;

local function finishCharmOpeningAndStartRoll() -- Line: 594
    -- upvalues: DebugLog (copy), u18 (ref), u22 (ref), u26 (ref), MainGui (copy), u16 (ref), u20 (ref), Router (copy), u6 (ref)
    DebugLog("finishCharmOpeningAndStartRoll called");

    if u18 then
        u18:Stop();
    end;

    u22 = nil;

    if u26 then
        u26.Enabled = false;
    end;

    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective");

    if CameraPerspective then
        CameraPerspective.Interactable = true;
    end;

    local PackOpening = u16.PackOpening;
    DebugLog("  packOpeningTrack:", PackOpening and "exists" or "nil");
    DebugLog("  CharmDragCallback:", u20 and "exists" or "nil");

    if not PackOpening then
        DebugLog("  No packOpeningTrack, calling callback directly");

        if u20 then
            DebugLog("  Calling CharmDragCallback");
        end;

        local v93 = u20;

        if v93 then
            u20 = nil;
            v93();
        end;

        return;
    end;

    local v94 = u6 and u6.Sounds;
    Router.broadcastRouter("RunStoreSound", v94 and v94.DragLoop or "Charm Drag Loop");

    if not PackOpening.IsPlaying then
        PackOpening:Play();
    end;

    PackOpening:AdjustSpeed(1);
    PackOpening.Looped = false;
    local math_max_ret = math.max(0, PackOpening.Length - PackOpening.TimePosition - 0.1);
    task.delay(math_max_ret, function() -- Line: 632
        -- upvalues: PackOpening (copy), u20 (ref)
        if not PackOpening.IsPlaying then
            return;
        end;

        PackOpening:AdjustSpeed(0);
        PackOpening.TimePosition = PackOpening.Length * 0.99;
        local v95 = u20;

        if v95 then
            u20 = nil;
            v95();
        end;
    end);
end;

local function updateCharmAnimationProgress(p96: number, p97: vector?) -- Line: 645
    -- upvalues: u16 (ref), u25 (ref), u19 (ref), finishCharmOpeningAndStartRoll (copy), u18 (ref), u22 (ref), u23 (ref)
    local PackOpening = u16.PackOpening;

    if not PackOpening then
        return;
    end;

    local math_clamp_ret = math.clamp(p96, 0, 1);
    local v98;

    if u25 > 0 then
        v98 = u25;
    else
        v98 = PackOpening.Length;
    end;

    if not PackOpening.IsPlaying then
        PackOpening:Play();
        PackOpening:AdjustSpeed(0);
    end;

    PackOpening.TimePosition = v98 * math_clamp_ret;

    if math_clamp_ret >= 1 then
        u19 = false;
        finishCharmOpeningAndStartRoll();
    end;

    if u18 and p97 then
        local v99 = not u22 and 0 or (p97 - u22).Magnitude;
        u22 = p97;

        if v99 > 0.001 then
            u23 = tick();

            if not u18.IsPlaying then
                u18:Play();
            end;

            u18.PlaybackSpeed = math.clamp(v99 * 20, 0, 0.7) + 0.8;
        end;
    end;
end;

local function setupCharmDragDetector(p100: function?) -- Line: 688
    -- upvalues: u4 (ref), ContextActionService (copy), u27 (ref), u20 (ref), u19 (ref), u21 (ref), u24 (ref), u16 (ref), u6 (ref), u25 (ref), MainGui (copy), u26 (ref), u7 (copy), u28 (ref), RunServiceController (copy), u22 (ref), u23 (ref), u18 (ref), ReplicatedStorage (copy), finishCharmOpeningAndStartRoll (copy), updateCharmAnimationProgress (copy), UserInputService (copy), u8 (ref), u9 (ref), Router (copy)
    if not u4 then
        return;
    end;

    local Pack = u4:FindFirstChild("Pack");

    if not Pack then
        warn("[CaseSceneController]: Pack not found in CharmScene");

        return;
    end;

    local Drag = Pack:FindFirstChild("Drag");

    if not Drag then
        warn("[CaseSceneController]: Drag part not found in Pack");

        return;
    end;

    local u101 = Drag:FindFirstChildOfClass("DragDetector");

    if not u101 then
        warn("[CaseSceneController]: DragDetector not found on Drag part");

        return;
    end;

    ContextActionService:UnbindAction("Fire");
    ContextActionService:UnbindAction("Secondary Fire");
    u27 = true;
    u20 = p100;
    u19 = false;
    u21 = Drag.Position;
    u24 = u101.MaxDragTranslation.Magnitude;

    if u24 <= 0 then
        u24 = 1;
    end;

    local PackOpening = u16.PackOpening;

    if PackOpening then
        local v102 = u6 and u6.DragSettings;
        local u103 = v102 and v102.EndKeyframe or "DragEndPoint";
        local success, result = pcall(function() -- Line: 731
            -- upvalues: PackOpening (copy), u103 (copy)
            return PackOpening:GetTimeOfKeyframe(u103);
        end);

        if success and result then
            u25 = result;
        else
            u25 = PackOpening.Length;
            warn("[CaseSceneController]: " .. u103 .. " keyframe not found, using full animation length");
        end;
    end;

    u101.Enabled = true;
    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective");

    if CameraPerspective then
        CameraPerspective.Interactable = false;
    end;

    local v104 = Drag:FindFirstChildOfClass("SurfaceGui");

    if v104 then
        v104.Enabled = true;
        u26 = v104;
        local v105 = v104:FindFirstChildOfClass("Frame");
        local u106;

        if v105 then
            u106 = v105:FindFirstChildOfClass("ImageLabel");
        else
            u106 = v105;
        end;

        if v105 and u106 then
            u7:Add(v105.MouseEnter:Connect(function() -- Line: 758
                -- upvalues: u28 (ref), u106 (copy)
                u28 = true;
                u106.ImageTransparency = 1;
            end), "Disconnect", "CharmImageHoverEnter");
            u7:Add(v105.MouseLeave:Connect(function() -- Line: 767
                -- upvalues: u28 (ref), u106 (copy)
                u28 = false;
                u106.ImageTransparency = 0;
            end), "Disconnect", "CharmImageHoverLeave");
            local u107 = 0;
            u7:Add(RunServiceController.BindToRenderStep("CaseSceneController.CharmImageBreathing", function(p108) -- Line: 778
                -- upvalues: u28 (ref), u107 (ref), u106 (copy)
                if u28 then
                    return;
                end;

                u107 = u107 + p108 * 2;
                u106.ImageTransparency = (math.sin(u107) + 1) / 2 * 0.2;
            end), "Disconnect", "CharmImageBreathing");
        end;
    end;

    u7:Add(u101.DragStart:Connect(function() -- Line: 794
        -- upvalues: u19 (ref), u22 (ref), Drag (copy), u23 (ref), u18 (ref), ReplicatedStorage (ref), u6 (ref), Pack (copy), u7 (ref)
        u19 = true;
        u22 = Drag.Position;
        u23 = tick();

        if not u18 then
            local Store = require(ReplicatedStorage.Database.Audio.Store);
            local v109 = u6 and u6.Sounds;
            local v110 = Store[v109 and v109.DragStart or "Charm Drag Start"];

            if v110 and (v110.Identifiers and v110.Identifiers[1]) then
                local Sound = Instance.new("Sound");
                Sound.Name = "DragProgress";
                Sound.SoundId = "rbxassetid://" .. v110.Identifiers[1];
                Sound.Volume = v110.Properties.Volume or 1;
                Sound.Looped = true;
                Sound.PlaybackSpeed = 0.8;
                Sound.Parent = Pack;
                u18 = Sound;
                u7:Add(Sound, "Destroy");
            end;
        end;
    end), "Disconnect", "CharmDragStart");
    u7:Add(RunServiceController.BindToHeartbeat("CaseSceneController.CharmDragSoundCheck", function() -- Line: 821
        -- upvalues: u19 (ref), u18 (ref), u23 (ref)
        if u19 and (u18 and (u18.IsPlaying and tick() - u23 > 0.05)) then
            u18:Stop();
        end;
    end), "Disconnect", "CharmDragSoundCheck");
    u7:Add(u101.DragContinue:Connect(function() -- Line: 836
        -- upvalues: u19 (ref), u21 (ref), Drag (copy), u24 (ref), u6 (ref), u101 (copy), finishCharmOpeningAndStartRoll (ref), updateCharmAnimationProgress (ref)
        if not (u19 and u21) then
            return;
        end;

        local math_clamp_ret = math.clamp((Drag.Position - u21).Magnitude / u24, 0, 1);
        local v111 = u6 and u6.DragSettings;

        if (v111 and v111.Threshold or 0.5) > math_clamp_ret then
            updateCharmAnimationProgress(math_clamp_ret, Drag.Position);

            return;
        end;

        u19 = false;
        u101.Enabled = false;
        Drag.Position = u21;
        finishCharmOpeningAndStartRoll();
    end), "Disconnect", "CharmDragContinue");
    u7:Add(u101.DragEnd:Connect(function() -- Line: 861
        -- upvalues: u19 (ref), u21 (ref), u18 (ref), Drag (copy), u24 (ref), u6 (ref), u101 (copy), finishCharmOpeningAndStartRoll (ref), u16 (ref), u22 (ref)
        if not (u19 and u21) then
            return;
        end;

        u19 = false;

        if u18 then
            u18:Stop();
        end;

        local math_clamp_ret = math.clamp((Drag.Position - u21).Magnitude / u24, 0, 1);
        Drag.Position = u21;
        local v112 = u6 and u6.DragSettings;

        if math.max(v112 and v112.Threshold or 0.8, 0.8) <= math_clamp_ret then
            u101.Enabled = false;
            finishCharmOpeningAndStartRoll();

            return;
        end;

        if u16.PackOpening then
            u16.PackOpening.TimePosition = 0;
        end;

        u22 = nil;
    end), "Disconnect", "CharmDragEnd");
    u7:Add(UserInputService.InputBegan:Connect(function(p113, p114) -- Line: 895
        -- upvalues: u8 (ref), u9 (ref), u101 (copy), u19 (ref), u21 (ref), Drag (copy), u18 (ref), Router (ref), u6 (ref), finishCharmOpeningAndStartRoll (ref)
        if not u8 or u9 ~= "Unboxing" then
            return;
        end;

        local v115 = p113.UserInputType == Enum.UserInputType.Gamepad1;
        local v116 = p113.UserInputType == Enum.UserInputType.Keyboard;

        if v116 and p114 then
            return;
        end;

        if v115 then
            v115 = p113.KeyCode == Enum.KeyCode.ButtonX and true or p113.KeyCode == Enum.KeyCode.ButtonA;
        end;

        if v116 then
            v116 = p113.KeyCode == Enum.KeyCode.Return and true or p113.KeyCode == Enum.KeyCode.Space;
        end;

        if not (v115 or v116) then
            return;
        end;

        u101.Enabled = false;

        if u19 then
            u19 = false;

            if u21 then
                Drag.Position = u21;
            end;
        end;

        if u18 then
            u18:Stop();
        end;

        local v117 = u6 and u6.Sounds;
        Router.broadcastRouter("RunStoreSound", v117 and v117.DragStart or "Charm Drag Start");
        finishCharmOpeningAndStartRoll();
    end), "Disconnect", "CharmControllerSkip");
end;

local function rearmCharmDrag(p118: function?) -- Line: 939
    -- upvalues: u16 (ref), setupCharmDragDetector (copy)
    local PackOpening = u16.PackOpening;

    if PackOpening and PackOpening.IsPlaying then
        PackOpening:Stop();
    end;

    setupCharmDragDetector(p118);
end;

local function cleanupCharmDrag() -- Line: 949
    -- upvalues: u27 (ref), Router (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u28 (ref)
    if u27 then
        Router.broadcastRouter("RebindKeybinds");
        u27 = false;
    end;

    u19 = false;
    u20 = nil;
    u21 = nil;
    u22 = nil;
    u23 = 0;
    u24 = 1;
    u25 = 0;
    u26 = nil;
    u28 = false;
end;

function u1.ShowCaseScene(p119: string?, p120: string?) -- Line: 969
    -- upvalues: DebugLog (copy), u8 (ref), SceneRegistry (copy), u3 (copy), SceneParking (copy), u5 (ref), u6 (ref), u4 (ref), u9 (ref), workspace_CurrentCamera (copy), hideMenuFrames (copy), u2 (ref), MenuSceneController (copy), applyCaseFog (copy), hideViewmodels (copy), u7 (copy), hideViewmodel (copy), setupCaseModel (copy), loadAnimations (copy), playInspectAnimations (copy), CameraController (copy), RunServiceController (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), TweenService (copy), u15 (ref), setCaseEffects (copy), u27 (ref), Router (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u28 (ref), stopAllAnimations (copy), u16 (ref)
    DebugLog("ShowCaseScene called");
    DebugLog("  caseType:", p119 or "nil");
    DebugLog("  caseName:", p120 or "nil");
    DebugLog("  IsCaseSceneActive:", u8);

    if u8 then
        DebugLog("  BLOCKED: Scene already active");

        return;
    end;

    local SceneForCaseType = SceneRegistry.GetSceneForCaseType(p119 or "Case");
    DebugLog("  sceneName:", SceneForCaseType);
    local Config = SceneRegistry.GetConfig(SceneForCaseType);

    if not Config then
        warn("[CaseSceneController]: No config found for scene: " .. SceneForCaseType);
        DebugLog("  BLOCKED: No config found");

        return;
    end;

    DebugLog("  config.AssetFolder:", Config.AssetFolder);
    DebugLog("  config.InteractionType:", Config.InteractionType);
    local v121 = u3[Config.AssetFolder];

    if not v121 then
        warn("[CaseSceneController]: Scene was never staged: " .. Config.AssetFolder);

        return;
    end;

    SceneParking.Unpark(v121);
    u5 = SceneForCaseType;
    u6 = Config;
    u4 = v121;

    if Config.InteractionType == "Drag" then
        local Pack = v121:FindFirstChild("Pack");

        if Pack then
            Pack = Pack:FindFirstChild("Drag");
        end;

        if Pack then
            Pack = Pack:FindFirstChildOfClass("SurfaceGui");
        end;

        if Pack then
            Pack.Enabled = false;
        end;
    end;

    u9 = "Inspecting";
    local v122 = u4 and u4:FindFirstChild("Camera");
    local v123;

    if v122 then
        v123 = v122:FindFirstChild("Inspecting");
    else
        v123 = nil;
    end;

    if not v123 then
        warn("[CaseSceneController]: Scene missing Camera.Inspecting");
        SceneParking.Park(v121);
        u4 = nil;
        u5 = nil;
        u6 = nil;
        u9 = nil;

        return;
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CFrame = v123.CFrame;
    workspace_CurrentCamera.Focus = v123.CFrame;
    hideMenuFrames();

    if not u2 then
        MenuSceneController.ApplyMenuSceneLighting();
    end;

    applyCaseFog(v121);
    hideViewmodels();
    u7:Add(workspace_CurrentCamera.ChildAdded:Connect(function(p124) -- Line: 1041
        -- upvalues: Config (copy), hideViewmodel (ref)
        if p124:IsA("Model") and p124.Name ~= Config.AssetFolder then
            hideViewmodel(p124);
        end;
    end), "Disconnect", "ViewmodelListener");
    local v125;

    if p120 and (Config.InteractionType == "Click" and u5 ~= "Console") then
        v125 = setupCaseModel(v121, p120);
    else
        v125 = nil;
    end;

    loadAnimations(v121, Config, v125);

    if Config.InteractionType == "Click" then
        playInspectAnimations();
    end;

    CameraController.setFOVLock("CaseScene", true, 50);
    CameraController.setForceLockOverride("CaseScene", true);
    RunServiceController.BindToRenderStep("CaseSceneController.CameraUpdate", Enum.RenderPriority.Camera.Value + 10, function() -- Line: 1066
        -- upvalues: u4 (ref), workspace_CurrentCamera (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), TweenService (ref), u15 (ref), u9 (ref)
        if not u4 then
            return;
        end;

        workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;

        if u11 and (u12 and u13) then
            local v126 = (tick() - u14) / 0.8;
            local math_min_ret = math.min(v126, 1);
            workspace_CurrentCamera.CFrame = u12:Lerp(u13, (TweenService:GetValue(math_min_ret, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)));
            workspace_CurrentCamera.Focus = workspace_CurrentCamera.CFrame;

            if math_min_ret >= 1 then
                u11 = false;
                workspace_CurrentCamera.CFrame = u13;

                if u15 then
                    local v127 = u15;
                    u15 = nil;
                    v127();
                end;

                u12 = nil;
                u13 = nil;
            end;
        else
            local v128 = u9;
            local v129 = u4 and u4:FindFirstChild("Camera");
            local v130;

            if v129 and (v128 == "Inspecting" or v128 == "Unboxing") then
                v130 = v129:FindFirstChild(v128);
            else
                v130 = nil;
            end;

            if v130 then
                workspace_CurrentCamera.CFrame = v130.CFrame;
                workspace_CurrentCamera.Focus = v130.CFrame;
            end;
        end;
    end);
    u7:Add(function() -- Line: 1103
        -- upvalues: RunServiceController (ref)
        RunServiceController.UnbindFromRenderStep("CaseSceneController.CameraUpdate");
    end, true, "CameraUpdate");
    u7:Add(function() -- Line: 1107
        -- upvalues: DebugLog (ref), u9 (ref), u11 (ref), u12 (ref), u13 (ref), u15 (ref), setCaseEffects (ref), u27 (ref), Router (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u28 (ref), u4 (ref), stopAllAnimations (ref), u16 (ref)
        DebugLog("CaseSceneCleanup running");
        u9 = nil;
        u11 = false;
        u12 = nil;
        u13 = nil;
        u15 = nil;
        setCaseEffects(false, false, false);

        if u27 then
            Router.broadcastRouter("RebindKeybinds");
            u27 = false;
        end;

        u19 = false;
        u20 = nil;
        u21 = nil;
        u22 = nil;
        u23 = 0;
        u24 = 1;
        u25 = 0;
        u26 = nil;
        u28 = false;

        if u4 then
            local CaseMod = u4:FindFirstChild("CaseMod");

            if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
                CaseMod:Destroy();
            end;
        end;

        stopAllAnimations();
        u16 = {};
        DebugLog("CaseSceneCleanup complete");
    end, true, "CaseSceneCleanup");
    u8 = true;
    DebugLog("ShowCaseScene complete, IsCaseSceneActive = true");
end;

function u1.TransitionToUnboxing(u131: function?) -- Line: 1133
    -- upvalues: DebugLog (copy), u8 (ref), u4 (ref), u6 (ref), u9 (ref), playOpeningAnimations (copy), u11 (ref), u12 (ref), workspace_CurrentCamera (copy), u13 (ref), u14 (ref), u15 (ref), setupCharmDragDetector (copy)
    DebugLog("TransitionToUnboxing called");
    DebugLog("  IsCaseSceneActive:", u8);
    DebugLog("  CurrentScene:", u4 and "exists" or "nil");
    DebugLog("  CurrentSceneConfig:", u6 and "exists" or "nil");
    DebugLog("  CurrentCaseSceneState:", u9 or "nil");
    DebugLog("  callback:", u131 and "provided" or "nil");

    if not (u8 and (u4 and u6)) then
        DebugLog("  BLOCKED: Scene not active or missing config");

        return;
    end;

    if u9 == "Unboxing" then
        DebugLog("  BLOCKED: Already in Unboxing state");

        return;
    end;

    local v132 = u4 and u4:FindFirstChild("Camera");
    local v133;

    if v132 then
        v133 = v132:FindFirstChild("Unboxing");
    else
        v133 = nil;
    end;

    if not v133 then
        warn("[CaseSceneController]: Scene missing Camera.Unboxing");
        DebugLog("  BLOCKED: Missing Camera.Unboxing");

        return;
    end;

    DebugLog("  InteractionType:", u6.InteractionType);

    if u6.InteractionType == "Click" then
        DebugLog("  Playing opening animations and starting camera lerp");
        playOpeningAnimations();
        local v134 = u9;
        local v135 = u4 and u4:FindFirstChild("Camera");
        local v136;

        if v135 and (v134 == "Inspecting" or v134 == "Unboxing") then
            v136 = v135:FindFirstChild(v134);
        else
            v136 = nil;
        end;

        u11 = true;
        local v137;

        if v136 then
            v137 = v136.CFrame;
        else
            v137 = workspace_CurrentCamera.CFrame;
        end;

        u12 = v137;
        u13 = v133.CFrame;
        u14 = tick();
        u15 = u131;
    else
        DebugLog("  Starting camera lerp, will setup drag detector after");

        local function v138() -- Line: 1164
            -- upvalues: DebugLog (ref), setupCharmDragDetector (ref), u131 (copy)
            DebugLog("  Camera lerp complete, setting up drag detector");
            setupCharmDragDetector(u131);
        end;

        local v139 = u9;
        local v140 = u4 and u4:FindFirstChild("Camera");
        local v141;

        if v140 and (v139 == "Inspecting" or v139 == "Unboxing") then
            v141 = v140:FindFirstChild(v139);
        else
            v141 = nil;
        end;

        u11 = true;
        local v142;

        if v141 then
            v142 = v141.CFrame;
        else
            v142 = workspace_CurrentCamera.CFrame;
        end;

        u12 = v142;
        u13 = v133.CFrame;
        u14 = tick();
        u15 = v138;
    end;

    u9 = "Unboxing";
    DebugLog("  TransitionToUnboxing complete, CurrentCaseSceneState = Unboxing");
end;

function u1.TransitionToInspecting(p143: function?) -- Line: 1176
    -- upvalues: u8 (ref), u4 (ref), u9 (ref), u11 (ref), u12 (ref), workspace_CurrentCamera (copy), u13 (ref), u14 (ref), u15 (ref)
    if not (u8 and u4) then
        return;
    end;

    if u9 == "Inspecting" then
        return;
    end;

    local v144 = u4 and u4:FindFirstChild("Camera");
    local v145;

    if v144 then
        v145 = v144:FindFirstChild("Inspecting");
    else
        v145 = nil;
    end;

    if not v145 then
        warn("[CaseSceneController]: Scene missing Camera.Inspecting");

        return;
    end;

    local v146 = u9;
    local v147 = u4 and u4:FindFirstChild("Camera");
    local v148;

    if v147 and (v146 == "Inspecting" or v146 == "Unboxing") then
        v148 = v147:FindFirstChild(v146);
    else
        v148 = nil;
    end;

    u11 = true;
    local v149;

    if v148 then
        v149 = v148.CFrame;
    else
        v149 = workspace_CurrentCamera.CFrame;
    end;

    u12 = v149;
    u13 = v145.CFrame;
    u14 = tick();
    u15 = p143;
    u9 = "Inspecting";
end;

function u1.BeginConsoleOpening() -- Line: 1198
    -- upvalues: u17 (ref), u7 (copy), ConsoleBoardAnimator (copy), u4 (ref), RunService (copy), u16 (ref), u9 (ref), u1 (copy), u6 (ref), setupCharmDragDetector (copy)
    if u17 then
        u7:Remove("ConsoleAnimator");
        u17 = nil;
    end;

    local u150 = ConsoleBoardAnimator.new(u4);
    u7:Add(u150, "Cancel", "ConsoleAnimator");
    u17 = u150;
    u150:Start();
    RunService.RenderStepped:Wait();
    local CaseFall = u16.CaseFall;
    u7:Remove("ConsoleEnterAnimationFreeze");

    if CaseFall and CaseFall.IsPlaying then
        CaseFall:Stop(0.1);
    end;

    u7:Remove("ConsoleEnterSound");

    local function setSceneReady() -- Line: 1213
        -- upvalues: u17 (ref), u150 (copy)
        if u17 == u150 then
            u150:SetSceneReady();
        end;
    end;

    if u9 ~= "Unboxing" then
        u1.TransitionToUnboxing(setSceneReady);

        return;
    end;

    if not u6 or u6.InteractionType ~= "Drag" then
        u150:SetSceneReady();

        return;
    end;

    local PackOpening = u16.PackOpening;

    if PackOpening and PackOpening.IsPlaying then
        PackOpening:Stop();
    end;

    setupCharmDragDetector(setSceneReady);
end;

function u1.ResolveConsoleOpening(p151: any, p152: function) -- Line: 1228
    -- upvalues: u17 (ref)
    local v153 = u17;

    if not v153 then
        return false;
    end;

    v153:Resolve(p151, p152);

    return true;
end;

function u1.SkipConsoleOpening() -- Line: 1238
    -- upvalues: u17 (ref)
    if u17 then
        u17:Skip();
    end;
end;

function u1.CancelConsoleOpening() -- Line: 1244
    -- upvalues: u17 (ref), u7 (copy), u16 (ref), u9 (ref), u1 (copy)
    if u17 then
        u7:Remove("ConsoleAnimator");
        u17 = nil;
    end;

    u7:Remove("ConsoleOpenSound");
    local CaseOpening = u16.CaseOpening;

    if CaseOpening and CaseOpening.IsPlaying then
        CaseOpening:Stop(0.1);
    end;

    if u9 == "Unboxing" then
        u1.TransitionToInspecting();
    end;
end;

function u1.IsConsoleOpening() -- Line: 1256
    -- upvalues: u17 (ref)
    return u17 ~= nil;
end;

function u1.ArmDragOpening(p154: function) -- Line: 1263
    -- upvalues: u8 (ref), u4 (ref), u6 (ref), u9 (ref), u16 (ref), setupCharmDragDetector (copy)
    if not (u8 and (u4 and (u6 and (u6.InteractionType == "Drag" and u9 == "Unboxing")))) then
        return false;
    end;

    local PackOpening = u16.PackOpening;

    if PackOpening and PackOpening.IsPlaying then
        PackOpening:Stop();
    end;

    setupCharmDragDetector(p154);

    return true;
end;

function u1.HideCaseScene(p155: boolean?) -- Line: 1279
    -- upvalues: DebugLog (copy), u8 (ref), u17 (ref), u7 (copy), workspace_CurrentCamera (copy), CameraController (copy), Constants (copy), ReplicatedStorage (copy), restoreMenuFrames (copy), MenuSceneController (copy), u2 (ref), MenuState (copy), showViewmodels (copy), u4 (ref), SceneParking (copy), u5 (ref), u6 (ref), u9 (ref)
    DebugLog("HideCaseScene called");
    DebugLog("  IsCaseSceneActive:", u8);
    DebugLog("  skipFrameRestore:", p155 or false);

    if not u8 then
        DebugLog("  BLOCKED: Scene not active");

        return;
    end;

    if u17 then
        u7:Remove("ConsoleAnimator");
        u17 = nil;
    end;

    DebugLog("  Running CaseSceneJanitor:Cleanup()");
    u7:Cleanup();
    workspace_CurrentCamera.CameraType = Enum.CameraType.Custom;
    CameraController.setFOVLock("CaseScene", false);
    CameraController.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
    local CurrentSpectateInstance = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance();

    if CurrentSpectateInstance then
        CurrentSpectateInstance:UpdateScopeState();
    end;

    CameraController.setForceLockOverride("CaseScene", false);

    if p155 then
        if workspace:FindFirstChild("Map") then
            MenuSceneController.ApplyMapLighting();
        elseif u2 then
            MenuSceneController.ApplyMenuSceneLighting();
        end;

        MenuState.ExitCaseScene();
        u2 = false;
    else
        restoreMenuFrames();
    end;

    showViewmodels();

    if u4 then
        SceneParking.Park(u4);
    end;

    u4 = nil;
    u5 = nil;
    u6 = nil;
    u8 = false;
    u9 = nil;
    DebugLog("HideCaseScene complete, IsCaseSceneActive = false");
end;

function u1.IsActive() -- Line: 1327
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.ApplyCaseSceneLighting() -- Line: 1333
    -- upvalues: u8 (ref), u4 (ref), MenuSceneController (copy), applyCaseFog (copy)
    if not (u8 and u4) then
        return;
    end;

    MenuSceneController.ApplyMenuSceneLighting();
    applyCaseFog(u4);
end;

function u1.WaitForOpeningAnimation() -- Line: 1345
    -- upvalues: u16 (ref)
    local CaseOpening = u16.CaseOpening;

    if CaseOpening and CaseOpening.IsPlaying then
        CaseOpening.Stopped:Wait();
    end;
end;

function u1.Initialize() -- Line: 1355
    -- upvalues: ReplicatedStorage (copy), SceneRegistry (copy), u3 (copy), SceneParking (copy), UserInputService (copy), u8 (ref), u1 (copy), Router (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if not Assets then
        warn("[CaseSceneController]: Assets folder not found in ReplicatedStorage");

        return;
    end;

    for _, v in SceneRegistry.GetAllSceneNames() do
        local Config = SceneRegistry.GetConfig(v);
        local v156;

        if Config then
            v156 = Assets:FindFirstChild(Config.AssetFolder);
        else
            v156 = Config;
        end;

        if Config and v156 then
            local v157 = v156:FindFirstChildWhichIsA("Model");

            if v157 then
                local v158 = v157:Clone();
                v158.Name = Config.AssetFolder;
                u3[Config.AssetFolder] = v158;
                SceneParking.Park(v158);
            else
                warn("[CaseSceneController]: No model found in Assets." .. Config.AssetFolder);
            end;
        end;
    end;

    UserInputService.InputBegan:Connect(function(p159, p160) -- Line: 1379
        -- upvalues: u8 (ref), u1 (ref)
        if p160 or (p159.KeyCode ~= Enum.KeyCode.Escape or not u8) then
            return;
        end;

        if u1.IsConsoleOpening() then
            u1.SkipConsoleOpening();

            return;
        end;

        u1.HideCaseScene();
    end);
    Router.observerRouter("CaseSceneCloseForGameEnd", function() -- Line: 1390
        -- upvalues: u1 (ref)
        u1.HideCaseScene(true);
    end);
end;

function u1.Start() -- Line: 1395
end;

Router.observerRouter("IsCaseSceneRolling", function() -- Line: 1401
    -- upvalues: u8 (ref), u9 (ref)
    return u8 and u9 == "Unboxing";
end);

return u1;