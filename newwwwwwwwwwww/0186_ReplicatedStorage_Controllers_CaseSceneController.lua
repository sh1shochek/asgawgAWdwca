-- CaseSceneController (ModuleScript)
-- full path: ReplicatedStorage.Controllers.CaseSceneController

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
require(script:WaitForChild("ConsoleItemRoller"));
require(ReplicatedStorage.Database.Custom.ConsoleTypes);
require(ReplicatedStorage.Database.Custom.Types);
local Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases);
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

local function DebugLog(...) -- Line: 91
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

local function getSceneSound(p29: string, p30: string) -- Line: 112
    -- upvalues: u6 (ref)
    local v31 = u6 and u6.Sounds;

    if v31 then
        p30 = v31[p29] or p30;
    end;

    return p30;
end;

local function getDragSettings() -- Line: 117
    -- upvalues: u6 (ref)
    return u6 and u6.DragSettings;
end;

local function isConsoleScene() -- Line: 121
    -- upvalues: u6 (ref)
    local v32;

    if u6 == nil then
        v32 = false;
    else
        v32 = u6.ConsoleColumnCount ~= nil;
    end;

    return v32;
end;

local function clearConsoleOpeningState() -- Line: 125
    -- upvalues: u17 (ref), u7 (copy)
    if u17 then
        u7:Remove("ConsoleAnimator");
        u17 = nil;
    end;
end;

local function hideMenuFrames() -- Line: 132
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

local function hideViewmodel(p33: userdata) -- Line: 175
    -- upvalues: u10 (ref)
    for _, descendant in p33:GetDescendants() do
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

    table.insert(u10, p33);
end;

local function hideViewmodels() -- Line: 193
    -- upvalues: u10 (ref), u6 (ref), workspace_CurrentCamera (copy), hideViewmodel (copy)
    u10 = {};
    local v34 = u6 and u6.AssetFolder or nil;

    for _, child in workspace_CurrentCamera:GetChildren() do
        if child:IsA("Model") and child.Name ~= v34 then
            hideViewmodel(child);
        end;
    end;
end;

local function showViewmodels() -- Line: 203
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

local function applyCaseFog(p35: userdata) -- Line: 229
    -- upvalues: Lighting (copy)
    local CaseFog = p35:FindFirstChild("CaseFog", true);

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

local function restoreLightingAfterSkippedFrameRestore() -- Line: 244
    -- upvalues: MenuSceneController (copy), u2 (ref)
    if workspace:FindFirstChild("Map") then
        MenuSceneController.ApplyMapLighting();

        return;
    end;

    if u2 then
        MenuSceneController.ApplyMenuSceneLighting();
    end;
end;

local function restoreMenuFrames() -- Line: 255
    -- upvalues: MenuState (copy), u2 (ref), MenuSceneController (copy)
    local MenuFrame = MenuState.GetMenuFrame();

    if not (MenuFrame and MenuFrame.Visible) then
        u2 = false;
        MenuState.ExitCaseScene();
        MenuSceneController.ApplyMapLighting();

        return;
    end;

    local ScreenBeforeCaseScene = MenuState.GetScreenBeforeCaseScene();
    local v36 = u2;
    u2 = false;
    MenuState.ExitCaseScene();

    if v36 then
        MenuSceneController.ShowMenuScene();
        MenuSceneController.SetMusicVolumeMultiplier(1, 0.5);
    else
        MenuSceneController.ApplyMapLighting();
    end;

    local Top = MenuFrame:FindFirstChild("Top");

    if Top then
        Top.Visible = true;
    end;

    local v37 = MenuFrame:FindFirstChild(ScreenBeforeCaseScene or "Dashboard");

    if v37 then
        v37.Visible = true;
    elseif ScreenBeforeCaseScene then
        return;
    end;

    local v38;

    if ScreenBeforeCaseScene == nil or ScreenBeforeCaseScene == "Dashboard" then
        v38 = false;
    else
        v38 = ScreenBeforeCaseScene ~= "Play";
    end;

    MenuState.SetBlurEnabled(v38);
    MenuFrame.BackgroundTransparency = v38 and 0.15 or 1;
    local Pattern = MenuFrame:FindFirstChild("Pattern");

    if Pattern then
        Pattern.Visible = not v38;
    end;
end;

local function cleanupCaseModel(p39: userdata) -- Line: 304
    local CaseMod = p39:FindFirstChild("CaseMod");

    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy();
    end;
end;

local function setupCaseModel(p40: userdata, p41: string) -- Line: 314
    -- upvalues: ReplicatedStorage (copy)
    local CaseMod = p40:FindFirstChild("CaseMod");

    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy();
    end;

    local CaseModels = ReplicatedStorage.Assets:FindFirstChild("CaseModels");

    if not CaseModels then
        warn("[CaseSceneController]: CaseModels folder not found in ReplicatedStorage.Assets");

        return nil;
    end;

    local v42 = CaseModels:FindFirstChild(p41);

    if not v42 then
        warn("[CaseSceneController]: Case model not found for case: " .. p41);

        return nil;
    end;

    local v43 = v42:Clone();
    v43.Name = "CaseMod";
    v43:SetAttribute("IsDynamicModel", true);
    local CasePivot = p40:FindFirstChild("CasePivot");

    if CasePivot then
        v43:PivotTo(CasePivot.CFrame);
    else
        warn("[CaseSceneController]: CasePivot not found in CaseScene");
    end;

    v43.Parent = p40;

    return v43;
end;

local function getCameraPosition(p44: string?) -- Line: 346
    -- upvalues: u4 (ref)
    local v45 = u4 and u4:FindFirstChild("Camera");

    if v45 and (p44 == "Inspecting" or p44 == "Unboxing") then
        return v45:FindFirstChild(p44);
    end;

    return nil;
end;

local function startCameraLerp(p46: userdata, p47: function?) -- Line: 356
    -- upvalues: u9 (ref), u4 (ref), u11 (ref), u12 (ref), workspace_CurrentCamera (copy), u13 (ref), u14 (ref), u15 (ref)
    local v48 = u9;
    local v49 = u4 and u4:FindFirstChild("Camera");
    local v50;

    if v49 and (v48 == "Inspecting" or v48 == "Unboxing") then
        v50 = v49:FindFirstChild(v48);
    else
        v50 = nil;
    end;

    u11 = true;
    local v51;

    if v50 then
        v51 = v50.CFrame;
    else
        v51 = workspace_CurrentCamera.CFrame;
    end;

    u12 = v51;
    u13 = p46.CFrame;
    u14 = tick();
    u15 = p47;
end;

local function ensureAnimator(p52: userdata) -- Line: 369
    local v53 = p52:FindFirstChildOfClass("Animator");

    if not v53 then
        v53 = Instance.new("Animator");
        v53.Parent = p52;
    end;

    return v53;
end;

local function findAnimationController(p54: userdata, p55: any) -- Line: 378
    local v56 = p55.ConsoleColumnCount ~= nil;
    local v57;

    if v56 then
        v57 = p54:FindFirstChild("ConsoleLaptop", true);
    elseif p55.InteractionType == "Drag" then
        v57 = p54:FindFirstChild("Pack");
    else
        v57 = p54:FindFirstChild("CaseMod");
    end;

    if not v57 then
        return nil;
    end;

    local v58;

    if v56 then
        v58 = v57:FindFirstChildWhichIsA("AnimationController", true);
    else
        v58 = v57:FindFirstChildOfClass("AnimationController");
    end;

    local v59;

    if v58 then
        v59 = v58:FindFirstChildOfClass("Animator");

        if not v59 then
            v59 = Instance.new("Animator");
            v59.Parent = v58;
        end;
    else
        v59 = v58;
    end;

    return v59;
end;

local function loadAnimations(p60: userdata, p61: any, p62: userdata?) -- Line: 394
    -- upvalues: findAnimationController (copy), u16 (ref)
    if p61.InteractionType == "Click" then
        if p62 then
            p62 = p62:FindFirstChildOfClass("AnimationController");
        end;
    else
        p62 = false;
    end;

    local v63;

    if p62 then
        v63 = p62:FindFirstChildOfClass("Animator");

        if not v63 then
            v63 = Instance.new("Animator");
            v63.Parent = p62;
        end;
    else
        v63 = findAnimationController(p60, p61);
    end;

    if v63 then
        for i, v in p61.Animations do
            if v then
                local Animation = Instance.new("Animation");
                Animation.AnimationId = v;
                u16[i] = v63:LoadAnimation(Animation);
                Animation:Destroy();
            end;
        end;

        return;
    end;

    warn("[CaseSceneController]: No animator found for scene");
end;

local function setEffectsEnabled(p64: userdata?, p65: boolean) -- Line: 419
    if not p64 then
        return;
    end;

    for _, descendant in p64:GetDescendants() do
        if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = p65;
        end;
    end;
end;

local function setCaseEffects(p66: boolean, p67: boolean, p68: boolean?) -- Line: 431
    -- upvalues: u4 (ref), setEffectsEnabled (copy)
    local v69 = u4 and u4:FindFirstChild("CaseMod");

    if not v69 then
        return;
    end;

    setEffectsEnabled(v69:FindFirstChild("IdleEffect"), p66);
    setEffectsEnabled(v69:FindFirstChild("OpeningEffect"), p67);

    if p68 ~= nil then
        setEffectsEnabled(v69:FindFirstChild("EffectsPart"), p68);
    end;
end;

local function getKeyframeSounds(p70: string) -- Line: 444
    -- upvalues: u6 (ref)
    local v71 = u6 and u6.AnimationKeyframeSounds;

    if v71 then
        v71 = v71[p70];
    end;

    return v71;
end;

local function setupKeyframeSounds(p72: userdata, p73: table) -- Line: 449
    -- upvalues: Router (copy), u7 (copy)
    for i, v in p73 do
        u7:Add((p72:GetMarkerReachedSignal(i):Connect(function() -- Line: 451
            -- upvalues: Router (ref), v (copy)
            Router.broadcastRouter("RunStoreSound", v);
        end)));
    end;
end;

local function playConsoleAnimationSound(p74: string, u75: string) -- Line: 460
    -- upvalues: u7 (copy), Router (copy)
    u7:Remove(u75);
    local v76 = Router.broadcastRouter("RunStoreSound", p74);

    if not v76 then
        return;
    end;

    u7:Add(v76, "Destroy", u75);
    v76.Destroying:Once(function() -- Line: 467
        -- upvalues: u7 (ref), u75 (copy)
        u7:RemoveNoClean(u75);
    end);
end;

local function freezeAtEnd(u77: userdata, p78: string, p79: string?) -- Line: 473
    -- upvalues: RunServiceController (copy), u7 (copy)
    local u80 = nil;
    u80 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName(p78), function() -- Line: 477
        -- upvalues: u77 (copy), u80 (ref)
        if u77.Length > 0 and u77.TimePosition >= u77.Length - 0.05 then
            u77:AdjustSpeed(0);
            u80:Disconnect();
        end;
    end);
    u7:Add(u80, "Disconnect", p79);
end;

local function playInspectAnimations() -- Line: 489
    -- upvalues: u16 (ref), u6 (ref), setCaseEffects (copy), playConsoleAnimationSound (copy), RunServiceController (copy), u7 (copy), setupKeyframeSounds (copy), Router (copy), u4 (ref)
    if u16.CaseFall then
        local v81;

        if u6 == nil then
            v81 = false;
        else
            v81 = u6.ConsoleColumnCount ~= nil;
        end;

        if v81 or u16.CloseIdle then
            setCaseEffects(true, false, true);
            local CaseFall = u16.CaseFall;
            local v82;

            if u6 == nil then
                v82 = false;
            else
                v82 = u6.ConsoleColumnCount ~= nil;
            end;

            if v82 then
                local v83 = u6 and u6.Sounds;
                playConsoleAnimationSound(v83 and v83.Enter or "Console Enter Animation", "ConsoleEnterSound");
                CaseFall:Play();
                local u84 = nil;
                u84 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName("CaseSceneController.ConsoleEnterAnimationFreeze"), function() -- Line: 477
                    -- upvalues: CaseFall (copy), u84 (ref)
                    if CaseFall.Length > 0 and CaseFall.TimePosition >= CaseFall.Length - 0.05 then
                        CaseFall:AdjustSpeed(0);
                        u84:Disconnect();
                    end;
                end);
                u7:Add(u84, "Disconnect", "ConsoleEnterAnimationFreeze");

                return;
            end;

            local v85 = u6 and u6.AnimationKeyframeSounds;

            if v85 then
                v85 = v85.CaseFall;
            end;

            if v85 then
                setupKeyframeSounds(CaseFall, v85);
            else
                local v86 = u6 and u6.Sounds;
                local u87 = v86 and v86.Drop or "Case Fall";
                u7:Add((CaseFall:GetMarkerReachedSignal("Dropped"):Connect(function() -- Line: 509
                    -- upvalues: Router (ref), u87 (copy)
                    Router.broadcastRouter("RunStoreSound", u87);
                end)));
            end;

            u7:Add((CaseFall:GetMarkerReachedSignal(v85 and v85.Drop and "Drop" or "Dropped"):Connect(function() -- Line: 518
                -- upvalues: u4 (ref)
                local v88 = u4 and u4:FindFirstChild("DropParticle");

                if not v88 then
                    return;
                end;

                for _, child in v88:GetChildren() do
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
    end;
end;

local function playOpeningAnimations() -- Line: 541
    -- upvalues: u16 (ref), u6 (ref), u7 (copy), playConsoleAnimationSound (copy), u4 (ref), setEffectsEnabled (copy), RunServiceController (copy), setupKeyframeSounds (copy), Router (copy)
    if not u16.CaseOpening then
        return;
    end;

    if u16.CloseIdle then
        u16.CloseIdle:Stop();
    end;

    local CaseOpening = u16.CaseOpening;
    local v89;

    if u6 == nil then
        v89 = false;
    else
        v89 = u6.ConsoleColumnCount ~= nil;
    end;

    if not v89 then
        local v90 = u6 and u6.AnimationKeyframeSounds;

        if v90 then
            v90 = v90.CaseOpening;
        end;

        if v90 then
            setupKeyframeSounds(CaseOpening, v90);
        else
            local v91 = u6 and u6.Sounds;
            Router.broadcastRouter("RunStoreSound", v91 and v91.Opening or "Case Opening");
        end;

        local v92 = u4 and u4:FindFirstChild("CaseMod");

        if v92 then
            setEffectsEnabled(v92:FindFirstChild("IdleEffect"), false);
            setEffectsEnabled(v92:FindFirstChild("OpeningEffect"), true);
        end;

        CaseOpening:Play();

        if u16.OpenIdle then
            u16.OpenIdle.Looped = true;
            u16.OpenIdle:Play();
        end;

        return;
    end;

    u7:Remove("ConsoleEnterSound");
    local v93 = u6 and u6.Sounds;
    playConsoleAnimationSound(v93 and v93.Opening or "Console Open Animation", "ConsoleOpenSound");
    local v94 = u4 and u4:FindFirstChild("CaseMod");

    if v94 then
        setEffectsEnabled(v94:FindFirstChild("IdleEffect"), false);
        setEffectsEnabled(v94:FindFirstChild("OpeningEffect"), true);
    end;

    CaseOpening:Play(0.1, 1, 1);
    local u95 = nil;
    u95 = RunServiceController.BindToHeartbeat(RunServiceController.CreateBindingName("CaseSceneController.ConsoleAnimationFreeze"), function() -- Line: 477
        -- upvalues: CaseOpening (copy), u95 (ref)
        if CaseOpening.Length > 0 and CaseOpening.TimePosition >= CaseOpening.Length - 0.05 then
            CaseOpening:AdjustSpeed(0);
            u95:Disconnect();
        end;
    end);
    u7:Add(u95, "Disconnect", nil);
end;

local function stopAllAnimations() -- Line: 579
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

local function runCharmDragCallback() -- Line: 595
    -- upvalues: u20 (ref)
    local v96 = u20;

    if v96 then
        u20 = nil;
        v96();
    end;
end;

local function finishCharmOpeningAndStartRoll() -- Line: 603
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

        local v97 = u20;

        if v97 then
            u20 = nil;
            v97();
        end;

        return;
    end;

    local v98 = u6 and u6.Sounds;
    Router.broadcastRouter("RunStoreSound", v98 and v98.DragLoop or "Charm Drag Loop");

    if not PackOpening.IsPlaying then
        PackOpening:Play();
    end;

    PackOpening:AdjustSpeed(1);
    PackOpening.Looped = false;
    local math_max_ret = math.max(0, PackOpening.Length - PackOpening.TimePosition - 0.1);
    task.delay(math_max_ret, function() -- Line: 641
        -- upvalues: PackOpening (copy), u20 (ref)
        if not PackOpening.IsPlaying then
            return;
        end;

        PackOpening:AdjustSpeed(0);
        PackOpening.TimePosition = PackOpening.Length * 0.99;
        local v99 = u20;

        if v99 then
            u20 = nil;
            v99();
        end;
    end);
end;

local function updateCharmAnimationProgress(p100: number, p101: vector?) -- Line: 654
    -- upvalues: u16 (ref), u25 (ref), u19 (ref), finishCharmOpeningAndStartRoll (copy), u18 (ref), u22 (ref), u23 (ref)
    local PackOpening = u16.PackOpening;

    if not PackOpening then
        return;
    end;

    local math_clamp_ret = math.clamp(p100, 0, 1);
    local v102;

    if u25 > 0 then
        v102 = u25;
    else
        v102 = PackOpening.Length;
    end;

    if not PackOpening.IsPlaying then
        PackOpening:Play();
        PackOpening:AdjustSpeed(0);
    end;

    PackOpening.TimePosition = v102 * math_clamp_ret;

    if math_clamp_ret >= 1 then
        u19 = false;
        finishCharmOpeningAndStartRoll();
    end;

    if u18 and p101 then
        local v103 = not u22 and 0 or (p101 - u22).Magnitude;
        u22 = p101;

        if v103 > 0.001 then
            u23 = tick();

            if not u18.IsPlaying then
                u18:Play();
            end;

            u18.PlaybackSpeed = math.clamp(v103 * 20, 0, 0.7) + 0.8;
        end;
    end;
end;

local function setupCharmDragDetector(p104: function?) -- Line: 697
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

    local u105 = Drag:FindFirstChildOfClass("DragDetector");

    if not u105 then
        warn("[CaseSceneController]: DragDetector not found on Drag part");

        return;
    end;

    ContextActionService:UnbindAction("Fire");
    ContextActionService:UnbindAction("Secondary Fire");
    u27 = true;
    u20 = p104;
    u19 = false;
    u21 = Drag.Position;
    u24 = u105.MaxDragTranslation.Magnitude;

    if u24 <= 0 then
        u24 = 1;
    end;

    local PackOpening = u16.PackOpening;

    if PackOpening then
        local v106 = u6 and u6.DragSettings;
        local u107 = v106 and v106.EndKeyframe or "DragEndPoint";
        local success, result = pcall(function() -- Line: 740
            -- upvalues: PackOpening (copy), u107 (copy)
            return PackOpening:GetTimeOfKeyframe(u107);
        end);

        if success and result then
            u25 = result;
        else
            u25 = PackOpening.Length;
            warn("[CaseSceneController]: " .. u107 .. " keyframe not found, using full animation length");
        end;
    end;

    u105.Enabled = true;
    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective");

    if CameraPerspective then
        CameraPerspective.Interactable = false;
    end;

    local v108 = Drag:FindFirstChildOfClass("SurfaceGui");

    if v108 then
        v108.Enabled = true;
        u26 = v108;
        local v109 = v108:FindFirstChildOfClass("Frame");
        local u110;

        if v109 then
            u110 = v109:FindFirstChildOfClass("ImageLabel");
        else
            u110 = v109;
        end;

        if v109 and u110 then
            u7:Add(v109.MouseEnter:Connect(function() -- Line: 767
                -- upvalues: u28 (ref), u110 (copy)
                u28 = true;
                u110.ImageTransparency = 1;
            end), "Disconnect", "CharmImageHoverEnter");
            u7:Add(v109.MouseLeave:Connect(function() -- Line: 776
                -- upvalues: u28 (ref), u110 (copy)
                u28 = false;
                u110.ImageTransparency = 0;
            end), "Disconnect", "CharmImageHoverLeave");
            local u111 = 0;
            u7:Add(RunServiceController.BindToRenderStep("CaseSceneController.CharmImageBreathing", function(p112) -- Line: 787
                -- upvalues: u28 (ref), u111 (ref), u110 (copy)
                if u28 then
                    return;
                end;

                u111 = u111 + p112 * 2;
                u110.ImageTransparency = (math.sin(u111) + 1) / 2 * 0.2;
            end), "Disconnect", "CharmImageBreathing");
        end;
    end;

    u7:Add(u105.DragStart:Connect(function() -- Line: 803
        -- upvalues: u19 (ref), u22 (ref), Drag (copy), u23 (ref), u18 (ref), ReplicatedStorage (ref), u6 (ref), Pack (copy), u7 (ref)
        u19 = true;
        u22 = Drag.Position;
        u23 = tick();

        if not u18 then
            local Store = require(ReplicatedStorage.Database.Audio.Store);
            local v113 = u6 and u6.Sounds;
            local v114 = Store[v113 and v113.DragStart or "Charm Drag Start"];

            if v114 and (v114.Identifiers and v114.Identifiers[1]) then
                local Sound = Instance.new("Sound");
                Sound.Name = "DragProgress";
                Sound.SoundId = "rbxassetid://" .. v114.Identifiers[1];
                Sound.Volume = v114.Properties.Volume or 1;
                Sound.Looped = true;
                Sound.PlaybackSpeed = 0.8;
                Sound.Parent = Pack;
                u18 = Sound;
                u7:Add(Sound, "Destroy");
            end;
        end;
    end), "Disconnect", "CharmDragStart");
    u7:Add(RunServiceController.BindToHeartbeat("CaseSceneController.CharmDragSoundCheck", function() -- Line: 830
        -- upvalues: u19 (ref), u18 (ref), u23 (ref)
        if u19 and (u18 and (u18.IsPlaying and tick() - u23 > 0.05)) then
            u18:Stop();
        end;
    end), "Disconnect", "CharmDragSoundCheck");
    u7:Add(u105.DragContinue:Connect(function() -- Line: 845
        -- upvalues: u19 (ref), u21 (ref), Drag (copy), u24 (ref), u6 (ref), u105 (copy), finishCharmOpeningAndStartRoll (ref), updateCharmAnimationProgress (ref)
        if not (u19 and u21) then
            return;
        end;

        local math_clamp_ret = math.clamp((Drag.Position - u21).Magnitude / u24, 0, 1);
        local v115 = u6 and u6.DragSettings;

        if (v115 and v115.Threshold or 0.5) > math_clamp_ret then
            updateCharmAnimationProgress(math_clamp_ret, Drag.Position);

            return;
        end;

        u19 = false;
        u105.Enabled = false;
        Drag.Position = u21;
        finishCharmOpeningAndStartRoll();
    end), "Disconnect", "CharmDragContinue");
    u7:Add(u105.DragEnd:Connect(function() -- Line: 870
        -- upvalues: u19 (ref), u21 (ref), u18 (ref), Drag (copy), u24 (ref), u6 (ref), u105 (copy), finishCharmOpeningAndStartRoll (ref), u16 (ref), u22 (ref)
        if not (u19 and u21) then
            return;
        end;

        u19 = false;

        if u18 then
            u18:Stop();
        end;

        local math_clamp_ret = math.clamp((Drag.Position - u21).Magnitude / u24, 0, 1);
        Drag.Position = u21;
        local v116 = u6 and u6.DragSettings;

        if math.max(v116 and v116.Threshold or 0.8, 0.8) <= math_clamp_ret then
            u105.Enabled = false;
            finishCharmOpeningAndStartRoll();

            return;
        end;

        if u16.PackOpening then
            u16.PackOpening.TimePosition = 0;
        end;

        u22 = nil;
    end), "Disconnect", "CharmDragEnd");
    u7:Add(UserInputService.InputBegan:Connect(function(p117, p118) -- Line: 904
        -- upvalues: u8 (ref), u9 (ref), u105 (copy), u19 (ref), u21 (ref), Drag (copy), u18 (ref), Router (ref), u6 (ref), finishCharmOpeningAndStartRoll (ref)
        if not u8 or u9 ~= "Unboxing" then
            return;
        end;

        local v119 = p117.UserInputType == Enum.UserInputType.Gamepad1;
        local v120 = p117.UserInputType == Enum.UserInputType.Keyboard;

        if v120 and p118 then
            return;
        end;

        if v119 then
            v119 = p117.KeyCode == Enum.KeyCode.ButtonX and true or p117.KeyCode == Enum.KeyCode.ButtonA;
        end;

        if v120 then
            v120 = p117.KeyCode == Enum.KeyCode.Return and true or p117.KeyCode == Enum.KeyCode.Space;
        end;

        if not (v119 or v120) then
            return;
        end;

        u105.Enabled = false;

        if u19 then
            u19 = false;

            if u21 then
                Drag.Position = u21;
            end;
        end;

        if u18 then
            u18:Stop();
        end;

        local v121 = u6 and u6.Sounds;
        Router.broadcastRouter("RunStoreSound", v121 and v121.DragStart or "Charm Drag Start");
        finishCharmOpeningAndStartRoll();
    end), "Disconnect", "CharmControllerSkip");
end;

local function rearmCharmDrag(p122: function?) -- Line: 948
    -- upvalues: u16 (ref), setupCharmDragDetector (copy)
    local PackOpening = u16.PackOpening;

    if PackOpening and PackOpening.IsPlaying then
        PackOpening:Stop();
    end;

    setupCharmDragDetector(p122);
end;

local function cleanupCharmDrag() -- Line: 958
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

function u1.ShowCaseScene(p123: string?, p124: string?) -- Line: 978
    -- upvalues: DebugLog (copy), u8 (ref), SceneRegistry (copy), Cases (copy), u3 (copy), SceneParking (copy), u5 (ref), u6 (ref), u4 (ref), u9 (ref), workspace_CurrentCamera (copy), hideMenuFrames (copy), u2 (ref), MenuSceneController (copy), applyCaseFog (copy), hideViewmodels (copy), u7 (copy), hideViewmodel (copy), setupCaseModel (copy), loadAnimations (copy), playInspectAnimations (copy), CameraController (copy), RunServiceController (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), TweenService (copy), u15 (ref), setCaseEffects (copy), u27 (ref), Router (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u28 (ref), stopAllAnimations (copy), u16 (ref)
    DebugLog("ShowCaseScene called");
    DebugLog("  caseType:", p123 or "nil");
    DebugLog("  caseName:", p124 or "nil");
    DebugLog("  IsCaseSceneActive:", u8);

    if u8 then
        DebugLog("  BLOCKED: Scene already active");

        return;
    end;

    local GetSceneForCase = SceneRegistry.GetSceneForCase;
    local v125;

    if p124 then
        v125 = Cases.GetCaseByName(p124);
    else
        v125 = nil;
    end;

    local v126 = GetSceneForCase(p123 or "Case", v125);
    DebugLog("  sceneName:", v126);
    local Config = SceneRegistry.GetConfig(v126);

    if not Config then
        warn("[CaseSceneController]: No config found for scene: " .. v126);
        DebugLog("  BLOCKED: No config found");

        return;
    end;

    DebugLog("  config.AssetFolder:", Config.AssetFolder);
    DebugLog("  config.InteractionType:", Config.InteractionType);
    local v127 = u3[Config.AssetFolder];

    if not v127 then
        warn("[CaseSceneController]: Scene was never staged: " .. Config.AssetFolder);

        return;
    end;

    SceneParking.Unpark(v127);
    u5 = v126;
    u6 = Config;
    u4 = v127;

    if Config.InteractionType == "Drag" then
        local Pack = v127:FindFirstChild("Pack");

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
    local v128 = u4 and u4:FindFirstChild("Camera");
    local v129;

    if v128 then
        v129 = v128:FindFirstChild("Inspecting");
    else
        v129 = nil;
    end;

    if not v129 then
        warn("[CaseSceneController]: Scene missing Camera.Inspecting");
        SceneParking.Park(v127);
        u4 = nil;
        u5 = nil;
        u6 = nil;
        u9 = nil;

        return;
    end;

    workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    workspace_CurrentCamera.CFrame = v129.CFrame;
    workspace_CurrentCamera.Focus = v129.CFrame;
    hideMenuFrames();

    if not u2 then
        MenuSceneController.ApplyMenuSceneLighting();
    end;

    applyCaseFog(v127);
    hideViewmodels();
    u7:Add(workspace_CurrentCamera.ChildAdded:Connect(function(p130) -- Line: 1051
        -- upvalues: Config (copy), hideViewmodel (ref)
        if p130:IsA("Model") and p130.Name ~= Config.AssetFolder then
            hideViewmodel(p130);
        end;
    end), "Disconnect", "ViewmodelListener");
    local v131 = nil;

    if p124 and Config.InteractionType == "Click" then
        local v132;

        if u6 == nil then
            v132 = false;
        else
            v132 = u6.ConsoleColumnCount ~= nil;
        end;

        if not v132 then
            v131 = setupCaseModel(v127, p124);
        end;
    end;

    loadAnimations(v127, Config, v131);

    if Config.InteractionType == "Click" then
        playInspectAnimations();
    end;

    CameraController.setFOVLock("CaseScene", true, 50);
    CameraController.setForceLockOverride("CaseScene", true);
    RunServiceController.BindToRenderStep("CaseSceneController.CameraUpdate", Enum.RenderPriority.Camera.Value + 10, function() -- Line: 1076
        -- upvalues: u4 (ref), workspace_CurrentCamera (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), TweenService (ref), u15 (ref), u9 (ref)
        if not u4 then
            return;
        end;

        workspace_CurrentCamera.CameraType = Enum.CameraType.Scriptable;

        if u11 and (u12 and u13) then
            local v133 = (tick() - u14) / 0.8;
            local math_min_ret = math.min(v133, 1);
            workspace_CurrentCamera.CFrame = u12:Lerp(u13, (TweenService:GetValue(math_min_ret, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)));
            workspace_CurrentCamera.Focus = workspace_CurrentCamera.CFrame;

            if math_min_ret >= 1 then
                u11 = false;
                workspace_CurrentCamera.CFrame = u13;

                if u15 then
                    local v134 = u15;
                    u15 = nil;
                    v134();
                end;

                u12 = nil;
                u13 = nil;
            end;
        else
            local v135 = u9;
            local v136 = u4 and u4:FindFirstChild("Camera");
            local v137;

            if v136 and (v135 == "Inspecting" or v135 == "Unboxing") then
                v137 = v136:FindFirstChild(v135);
            else
                v137 = nil;
            end;

            if v137 then
                workspace_CurrentCamera.CFrame = v137.CFrame;
                workspace_CurrentCamera.Focus = v137.CFrame;
            end;
        end;
    end);
    u7:Add(function() -- Line: 1113
        -- upvalues: RunServiceController (ref)
        RunServiceController.UnbindFromRenderStep("CaseSceneController.CameraUpdate");
    end, true, "CameraUpdate");
    u7:Add(function() -- Line: 1117
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

function u1.TransitionToUnboxing(u138: function?) -- Line: 1143
    -- upvalues: DebugLog (copy), u8 (ref), u4 (ref), u6 (ref), u9 (ref), playOpeningAnimations (copy), u11 (ref), u12 (ref), workspace_CurrentCamera (copy), u13 (ref), u14 (ref), u15 (ref), setupCharmDragDetector (copy)
    DebugLog("TransitionToUnboxing called");
    DebugLog("  IsCaseSceneActive:", u8);
    DebugLog("  CurrentScene:", u4 and "exists" or "nil");
    DebugLog("  CurrentSceneConfig:", u6 and "exists" or "nil");
    DebugLog("  CurrentCaseSceneState:", u9 or "nil");
    DebugLog("  callback:", u138 and "provided" or "nil");

    if not (u8 and (u4 and u6)) then
        DebugLog("  BLOCKED: Scene not active or missing config");

        return;
    end;

    if u9 == "Unboxing" then
        DebugLog("  BLOCKED: Already in Unboxing state");

        return;
    end;

    local v139 = u4 and u4:FindFirstChild("Camera");
    local v140;

    if v139 then
        v140 = v139:FindFirstChild("Unboxing");
    else
        v140 = nil;
    end;

    if not v140 then
        warn("[CaseSceneController]: Scene missing Camera.Unboxing");
        DebugLog("  BLOCKED: Missing Camera.Unboxing");

        return;
    end;

    DebugLog("  InteractionType:", u6.InteractionType);

    if u6.InteractionType == "Click" then
        DebugLog("  Playing opening animations and starting camera lerp");
        playOpeningAnimations();
        local v141 = u9;
        local v142 = u4 and u4:FindFirstChild("Camera");
        local v143;

        if v142 and (v141 == "Inspecting" or v141 == "Unboxing") then
            v143 = v142:FindFirstChild(v141);
        else
            v143 = nil;
        end;

        u11 = true;
        local v144;

        if v143 then
            v144 = v143.CFrame;
        else
            v144 = workspace_CurrentCamera.CFrame;
        end;

        u12 = v144;
        u13 = v140.CFrame;
        u14 = tick();
        u15 = u138;
    else
        DebugLog("  Starting camera lerp, will setup drag detector after");

        local function v145() -- Line: 1174
            -- upvalues: DebugLog (ref), setupCharmDragDetector (ref), u138 (copy)
            DebugLog("  Camera lerp complete, setting up drag detector");
            setupCharmDragDetector(u138);
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
        u13 = v140.CFrame;
        u14 = tick();
        u15 = v145;
    end;

    u9 = "Unboxing";
    DebugLog("  TransitionToUnboxing complete, CurrentCaseSceneState = Unboxing");
end;

function u1.TransitionToInspecting(p150: function?) -- Line: 1186
    -- upvalues: u8 (ref), u4 (ref), u9 (ref), u11 (ref), u12 (ref), workspace_CurrentCamera (copy), u13 (ref), u14 (ref), u15 (ref)
    if not (u8 and u4) then
        return;
    end;

    if u9 == "Inspecting" then
        return;
    end;

    local v151 = u4 and u4:FindFirstChild("Camera");
    local v152;

    if v151 then
        v152 = v151:FindFirstChild("Inspecting");
    else
        v152 = nil;
    end;

    if not v152 then
        warn("[CaseSceneController]: Scene missing Camera.Inspecting");

        return;
    end;

    local v153 = u9;
    local v154 = u4 and u4:FindFirstChild("Camera");
    local v155;

    if v154 and (v153 == "Inspecting" or v153 == "Unboxing") then
        v155 = v154:FindFirstChild(v153);
    else
        v155 = nil;
    end;

    u11 = true;
    local v156;

    if v155 then
        v156 = v155.CFrame;
    else
        v156 = workspace_CurrentCamera.CFrame;
    end;

    u12 = v156;
    u13 = v152.CFrame;
    u14 = tick();
    u15 = p150;
    u9 = "Inspecting";
end;

function u1.BeginConsoleOpening() -- Line: 1208
    -- upvalues: u17 (ref), u7 (copy), u6 (ref), ConsoleBoardAnimator (copy), u4 (ref), RunService (copy), u16 (ref), u9 (ref), u1 (copy), setupCharmDragDetector (copy)
    local v157 = u17;

    if v157 then
        v157:PlayReset();

        if u17 ~= v157 then
            return;
        end;
    end;

    if u17 then
        u7:Remove("ConsoleAnimator");
        u17 = nil;
    end;

    local u158 = ConsoleBoardAnimator.new(u4, u6.ConsoleColumnCount);
    u7:Add(u158, "Cancel", "ConsoleAnimator");
    u17 = u158;
    u158:Start();
    RunService.RenderStepped:Wait();
    local CaseFall = u16.CaseFall;
    u7:Remove("ConsoleEnterAnimationFreeze");

    if CaseFall and CaseFall.IsPlaying then
        CaseFall:Stop(0.1);
    end;

    u7:Remove("ConsoleEnterSound");

    local function setSceneReady() -- Line: 1233
        -- upvalues: u17 (ref), u158 (copy)
        if u17 == u158 then
            u158:SetSceneReady();
        end;
    end;

    if u9 ~= "Unboxing" then
        u1.TransitionToUnboxing(setSceneReady);

        return;
    end;

    if not u6 or u6.InteractionType ~= "Drag" then
        u158:SetSceneReady();

        return;
    end;

    local PackOpening = u16.PackOpening;

    if PackOpening and PackOpening.IsPlaying then
        PackOpening:Stop();
    end;

    setupCharmDragDetector(setSceneReady);
end;

local u159 = {
    Special = "Drop Gold",
    Red = "Drop Red",
    Pink = "Drop Pink",
    Purple = "Drop Purple",
    Blue = "Drop Blue"
};

local function getRollerItem(p160) -- Line: 1256
    -- upvalues: Skins (copy), Rarities (copy)
    local SkinInformation = Skins.GetSkinInformation(p160.skin.weaponName, p160.skin.skinName);
    local v161;

    if SkinInformation then
        if SkinInformation.wearImages and SkinInformation.wearImages[1] then
            v161 = SkinInformation.wearImages[1].assetId;
        elseif SkinInformation.charmImages and SkinInformation.charmImages[1] then
            v161 = SkinInformation.charmImages[1].assetId;
        else
            v161 = SkinInformation.imageAssetId or "";
        end;
    else
        v161 = "";
    end;

    return {
        Image = v161,
        Color = (Rarities[p160.isSpecial and "Special" or p160.rarity] or Rarities.Stock).Color
    };
end;

local function isConsoleRarity(p162, p163) -- Line: 1272
    if p163 == "Special" then
        return p162.isSpecial or p162.rarity == "Special";
    end;

    local v164;

    if p162.rarity == p163 then
        v164 = not p162.isSpecial;
    else
        v164 = false;
    end;

    return v164;
end;

local function findGrantedContent(p165, p166, p167) -- Line: 1281
    local v168;

    if p167 then
        v168 = string.lower((tostring(p167.Name)));
    else
        v168 = nil;
    end;

    local v169;

    if p167 then
        v169 = string.lower((tostring(p167.Skin)));
    else
        v169 = nil;
    end;

    local v170 = nil;

    for _, v in { p166.contents, p166.specialContents or {} } do
        for _, v2 in v do
            if p165.grantedSkinId ~= nil and v2.skinId == p165.grantedSkinId then
                return v2;
            end;

            if not (v170 or (string.lower(v2.skin.weaponName) ~= v168 or string.lower(v2.skin.skinName) ~= v169)) then
                v170 = v2;
            end;
        end;
    end;

    return v170;
end;

local function getConsoleRarity(p171) -- Line: 1307
    return (p171.isSpecial or p171.rarity == "Special") and "Special" or p171.rarity;
end;

local function buildRollerPlan(p172, p173) -- Line: 1313
    -- upvalues: getRollerItem (copy), u159 (copy)
    if not (p172 and p173) then
        return nil;
    end;

    local v174 = (p172.isSpecial or p172.rarity == "Special") and "Special" or p172.rarity;
    local v175 = {};
    local v176 = {};

    for _, v in { p173.contents, p173.specialContents or {} } do
        for _, v2 in v do
            local v177 = `{v2.skin.weaponName}|{v2.skin.skinName}`;
            local v178;

            if v174 == "Special" then
                v178 = v2.isSpecial or v2.rarity == "Special";
            elseif v2.rarity == v174 then
                v178 = not v2.isSpecial;
            else
                v178 = false;
            end;

            if v178 and not v175[v177] then
                v175[v177] = true;
                table.insert(v176, v2);
            end;
        end;
    end;

    if #v176 < 2 then
        return nil;
    end;

    local v179 = {};
    local v180 = nil;

    for _, v in v176 do
        local v181 = getRollerItem(v);
        table.insert(v179, v181);

        if v == p172 then
            v180 = v181;
        end;
    end;

    return v180 and {
        Pool = v179,
        Winner = v180,
        LandingSound = u159[v174]
    } or nil;
end;

function u1.ResolveConsoleOpening(p182: any, p183: function, p184: any, p185: any) -- Line: 1356
    -- upvalues: u17 (ref), u7 (copy), findGrantedContent (copy), buildRollerPlan (copy)
    local v186 = u17;

    if not v186 then
        return false;
    end;

    local v187;

    if p182.finalColumnIndex < v186.ColumnCount then
        v187 = p182.columnCount == nil and true or p182.columnCount == v186.ColumnCount;
    else
        v187 = false;
    end;

    for _, v in p182.path do
        if v.columnIndex >= v186.ColumnCount then
            v187 = false;
        end;
    end;

    if not v187 then
        warn((`[CaseSceneController]: Console outcome doesn't fit the {v186.ColumnCount}-column board (columnCount {p182.columnCount})`));

        if u17 then
            u7:Remove("ConsoleAnimator");
            u17 = nil;
        end;

        return false;
    end;

    local v188;

    if p184 then
        v188 = findGrantedContent(p182, p184, p185);
    else
        v188 = nil;
    end;

    local v189 = buildRollerPlan(v188, p184);
    local v190;

    if v188 then
        v190 = (v188.isSpecial or v188.rarity == "Special") and "Special" or v188.rarity;
    else
        v190 = nil;
    end;

    v186:Resolve(p182, p183, v189, v190);

    return true;
end;

function u1.SkipConsoleOpening() -- Line: 1393
    -- upvalues: u17 (ref)
    if u17 then
        u17:Skip();
    end;
end;

function u1.CancelConsoleOpening() -- Line: 1399
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

function u1.IsConsoleOpening() -- Line: 1411
    -- upvalues: u17 (ref)
    return u17 ~= nil;
end;

function u1.ArmDragOpening(p191: function) -- Line: 1418
    -- upvalues: u8 (ref), u4 (ref), u6 (ref), u9 (ref), u16 (ref), setupCharmDragDetector (copy)
    if not (u8 and (u4 and (u6 and (u6.InteractionType == "Drag" and u9 == "Unboxing")))) then
        return false;
    end;

    local PackOpening = u16.PackOpening;

    if PackOpening and PackOpening.IsPlaying then
        PackOpening:Stop();
    end;

    setupCharmDragDetector(p191);

    return true;
end;

function u1.HideCaseScene(p192: boolean?) -- Line: 1434
    -- upvalues: DebugLog (copy), u8 (ref), u17 (ref), u7 (copy), workspace_CurrentCamera (copy), CameraController (copy), Constants (copy), ReplicatedStorage (copy), restoreMenuFrames (copy), MenuSceneController (copy), u2 (ref), MenuState (copy), showViewmodels (copy), u4 (ref), SceneParking (copy), u5 (ref), u6 (ref), u9 (ref)
    DebugLog("HideCaseScene called");
    DebugLog("  IsCaseSceneActive:", u8);
    DebugLog("  skipFrameRestore:", p192 or false);

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

    if p192 then
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

function u1.IsActive() -- Line: 1482
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.ApplyCaseSceneLighting() -- Line: 1488
    -- upvalues: u8 (ref), u4 (ref), MenuSceneController (copy), applyCaseFog (copy)
    if not (u8 and u4) then
        return;
    end;

    MenuSceneController.ApplyMenuSceneLighting();
    applyCaseFog(u4);
end;

function u1.WaitForOpeningAnimation() -- Line: 1500
    -- upvalues: u16 (ref)
    local CaseOpening = u16.CaseOpening;

    if CaseOpening and CaseOpening.IsPlaying then
        CaseOpening.Stopped:Wait();
    end;
end;

function u1.Initialize() -- Line: 1510
    -- upvalues: ReplicatedStorage (copy), SceneRegistry (copy), u3 (copy), SceneParking (copy), UserInputService (copy), u8 (ref), u1 (copy), Router (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if not Assets then
        warn("[CaseSceneController]: Assets folder not found in ReplicatedStorage");

        return;
    end;

    for _, v in SceneRegistry.GetAllSceneNames() do
        local Config = SceneRegistry.GetConfig(v);
        local v193;

        if Config then
            v193 = Assets:FindFirstChild(Config.AssetFolder);
        else
            v193 = Config;
        end;

        if Config and v193 then
            local v194 = v193:FindFirstChildWhichIsA("Model");

            if v194 then
                local v195 = v194:Clone();
                v195.Name = Config.AssetFolder;
                u3[Config.AssetFolder] = v195;
                SceneParking.Park(v195);
            else
                warn("[CaseSceneController]: No model found in Assets." .. Config.AssetFolder);
            end;
        end;
    end;

    UserInputService.InputBegan:Connect(function(p196, p197) -- Line: 1534
        -- upvalues: u8 (ref), u1 (ref)
        if p197 or (p196.KeyCode ~= Enum.KeyCode.Escape or not u8) then
            return;
        end;

        if u1.IsConsoleOpening() then
            u1.SkipConsoleOpening();

            return;
        end;

        u1.HideCaseScene();
    end);
    Router.observerRouter("CaseSceneCloseForGameEnd", function() -- Line: 1545
        -- upvalues: u1 (ref)
        u1.HideCaseScene(true);
    end);
end;

function u1.Start() -- Line: 1550
end;

Router.observerRouter("IsCaseSceneRolling", function() -- Line: 1556
    -- upvalues: u8 (ref), u9 (ref)
    return u8 and u9 == "Unboxing";
end);

return u1;