-- ReplicatedStorage.GameClient.CameraController
-- Script path: ReplicatedStorage.GameClient.CameraController
-- Decompile time: 16.12 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local UserInputService = game:GetService("UserInputService");
local GameSettings = UserSettings().GameSettings;
local workspace_CurrentCamera = workspace.CurrentCamera;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = false;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;

local function IsOpeningCase() -- Line: 52
    -- upvalues: u23 (ref), u19 (ref)
    if not u23 and u19 then
        u23 = u19.GetComponent("CaseInspect");
    end;

    return u23 and (u23.IsOpeningCase and u23.IsOpeningCase()) or false;
end;

local u25 = nil;
local u26 = false;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = 0;
local CFrame_identity = CFrame.identity;
local CFrame_identity2 = CFrame.identity;
local CFrame2 = workspace_CurrentCamera.CFrame;
local CFrame_identity3 = CFrame.identity;
local CFrame_identity4 = CFrame.identity;
local u31 = true;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local u32 = nil;

local function CollideZoom(p33) -- Line: 83
    -- upvalues: u32 (ref), RaycastParams_new_ret (copy), CFrame_identity4 (ref)
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Geometry");
    end;

    if Map ~= u32 then
        u32 = Map;
        RaycastParams_new_ret.FilterDescendantsInstances = Map and ({ Map } or {}) or {};
    end;

    if Map then
        Map = workspace:Spherecast(p33.Position, 0.5, p33.ZVector * CFrame_identity4.Z, RaycastParams_new_ret);
    end;

    return Map and p33 + p33.ZVector * Map.Distance or p33 * CFrame_identity4;
end;

local u34 = 70;
local u35 = 1;
local u36 = 70;
local u37 = 1;
local u38 = 70;
local u39 = {};
local u40 = 0;
local u41 = Vector3.new(0, 0, 0);
local u42 = 0;
local u43 = false;

local function CalcShake(p44: number) -- Line: 113
    -- upvalues: u40 (ref), u39 (copy), u43 (ref), u41 (ref), u42 (ref)
    u40 = u40 + p44;
    local v45 = #u39;

    if v45 == 0 then
        u43 = false;

        return;
    end;

    local v46 = Vector3.new(0, 0, 0);
    local v47 = 0;

    for i = v45, 1, -1 do
        local v48 = u39[i];
        local v49;

        if u40 > v48.EndTime or v48.Amplitude <= 0 then
            table.remove(u39, i);
            v49 = i;
        else
            if u40 > v48.NextShake then
                local Amplitude = v48.Amplitude;
                v48.NextShake = u40 + 1 / v48.Frequency;
                local v50 = (math.random() * 2 - 1) * Amplitude;
                local v51 = (math.random() * 2 - 1) * Amplitude;
                local v52 = (math.random() * 2 - 1) * Amplitude;
                v48.Offset = vector.create(v50, v51, v52);
                v48.Angle = (math.random() * 2 - 1) * Amplitude * 0.25;
            end;

            local v53 = (v48.EndTime - u40) / v48.Duration;
            local math_min_ret = math.min(u40 * (v53 == 0 and 0 or (v48.Frequency / v53 or 0)), 100000000);
            local v54 = v53 * v53 * math.sin(math_min_ret);
            v46 = v46 + v48.Offset * v54;
            v47 = v47 + v48.Angle * v54;
            v48.Amplitude = v48.Amplitude - v48.Amplitude * (p44 / (v48.Duration * v48.Frequency));
            v49 = i;
        end;
    end;

    u41 = v46 * 0.0694;
    u42 = v47 * 0.017453292519943295;
    u43 = #u39 > 0;
end;

local function ProcessFrame(p55: number, p56: number) -- Line: 165
    -- upvalues: u18 (ref), u25 (ref), u9 (ref), u16 (ref), CalcShake (copy), u27 (ref), u11 (ref), u29 (ref), u28 (ref), u1 (copy), u14 (ref), u30 (ref), u22 (ref), CFrame_identity2 (ref), u21 (ref), u17 (ref), u2 (ref), CFrame_identity3 (ref), u37 (ref), u4 (ref), u13 (ref), u3 (ref), u15 (ref), CFrame_identity (ref), CFrame2 (ref), u31 (ref), CollideZoom (copy), CFrame_identity4 (ref), workspace_CurrentCamera (copy), u24 (ref), u34 (ref)
    if u18 and (u25 == 1 and u9.IsAlive()) then
        local MagnetismRotation = u18.GetMagnetismRotation(p55);

        if MagnetismRotation.X ~= 0 or MagnetismRotation.Y ~= 0 then
            u16.ApplyAimAssist(MagnetismRotation.X, -MagnetismRotation.Y);
        end;
    end;

    local Angles, v57 = u16.GetAngles();
    CalcShake(p55);

    if u27 then
        local v58 = u27;

        if u11.FramePriority.MainMenu or u11.FramePriority.MatchEnd then
            u27 = nil;
            u29 = nil;
            u28 = nil;
        elseif v58.Parent then
            local v59 = (os.clock() - u30 - 0.15) / 0.85;
            local math_clamp_ret = math.clamp(v59, 0, 1);
            local v60 = u22 and u22.GetEntity("Character", u28);
            local v61 = v60 and v60.CFrame or v58.CFrame;
            local _, v62 = v61:ToEulerAnglesYXZ();
            local v63 = CFrame.fromEulerAnglesYXZ(0, v62, 0) + (v61.Position + Vector3.new(0, 1.5, 0));

            if math_clamp_ret >= 1 then
                local v64 = u28;
                u27 = nil;
                u29 = nil;
                u28 = nil;
                CFrame_identity2 = v63;
                u1.SetAngles(v62, 0);
                u21.SpectateTarget(v64);
            else
                CFrame_identity2 = u29:Lerp(v63 * CFrame.new(0, 0, 10), math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2));
            end;
        else
            u27 = nil;
            u29 = nil;
            u28 = nil;
            u1.SetTarget(2);
            u14.Begin();
        end;
    end;

    if u25 == 1 and u9.IsAlive() then
        local v65 = u17:Update(CFrame_identity2, u2, v57, Angles, p55, p56);
        CFrame_identity3 = v65;

        if u37 ~= 1 then
            v65 = CFrame.fromMatrix(v65.Position, v65.XVector, v65.YVector * u37, v65.ZVector);
        end;

        CFrame_identity2 = v65;

        if u4 then
            u13.Render(v65, u3, u4, p55, u4:GetInaccuracy(u3) / u4.GetSpreadScale());
        end;
    elseif typeof(u25) == "Instance" then
        CFrame_identity2 = u25.CFrame;
    elseif u25 == 2 then
        CFrame_identity2 = u14:Update(CFrame_identity2, v57, Angles, p55);
    elseif u25 == 3 then
        CFrame_identity2 = u15:Update(CFrame_identity2, v57, Angles, p55);
    end;

    if u25 ~= 1 then
        CFrame_identity3 = CFrame_identity2;
    end;

    if CFrame_identity2 then
        CFrame_identity2 = u1.ApplyShake(CFrame_identity2, 1);
    end;

    if CFrame_identity2 and CFrame_identity2 ~= CFrame_identity then
        CFrame2 = u31 and CFrame_identity2 or (u25 == 3 and CollideZoom(CFrame_identity2) or CFrame_identity2 * CFrame_identity4);
        workspace_CurrentCamera.CFrame = CFrame2;
        CFrame_identity = CFrame_identity2;
    end;

    u24:UpdateFrustum(CFrame2, u34, workspace_CurrentCamera.ViewportSize, workspace_CurrentCamera.NearPlaneZ);
end;

function u1.StartShake(p66: number, p67: number, p68: number) -- Line: 276
    -- upvalues: u39 (copy), u40 (ref)
    if p66 <= 0 or (p67 <= 0 or p68 <= 0) then
        return;
    end;

    table.insert(u39, {
        Amplitude = p66,
        Frequency = p67,
        Duration = p68,
        EndTime = u40 + p68,
        NextShake = 0,
        Offset = Vector3.new(0, 0, 0),
        Angle = 0
    });
end;

function u1.ApplyShake(p69, p70: number) -- Line: 294
    -- upvalues: u43 (ref), u41 (ref), u42 (ref)
    if u43 then
        return (p69 + u41 * p70) * CFrame.Angles(0, 0, u42 * p70);
    end;

    return p69;
end;

function u1.SetTarget(p71) -- Line: 302
    -- upvalues: u23 (ref), u19 (ref), u25 (ref), u1 (copy)
    if not u23 and u19 then
        u23 = u19.GetComponent("CaseInspect");
    end;

    if u23 and (u23.IsOpeningCase and u23.IsOpeningCase()) or false then
        return;
    end;

    u25 = p71;

    if typeof(p71) == "Instance" then
        u1.SetZoom(0);
    end;

    u1.ApplyFov();
    u1.CameraTargetUpdate:Fire(u25);
end;

function u1.GetTarget() -- Line: 321
    -- upvalues: u25 (ref)
    return u25;
end;

function u1.SetCameraPosition(p72: vector) -- Line: 325
    -- upvalues: CFrame_identity2 (ref), CFrame2 (ref), workspace_CurrentCamera (copy)
    local v73, v74, v75 = CFrame_identity2:ToEulerAnglesYXZ();
    CFrame_identity2 = CFrame.new(p72) * CFrame.fromEulerAnglesYXZ(v73, v74, v75);
    CFrame2 = CFrame_identity2;
    workspace_CurrentCamera.CFrame = CFrame2;
end;

function u1.SetCameraCFrame(p76) -- Line: 334
    -- upvalues: CFrame_identity2 (ref)
    CFrame_identity2 = p76;
end;

function u1.StartDeathCam(p77: vector, p78: number) -- Line: 338
    -- upvalues: u22 (ref), u11 (ref), u14 (ref), u1 (copy), u27 (ref), u28 (ref), u29 (ref), u30 (ref)
    local v79 = u22 and u22.GetEntity("Character", p78);
    local v80;

    if v79 then
        v80 = v79.Model;
    else
        v80 = v79;
    end;

    if not (v80 and v80.PrimaryPart) then
        return;
    end;

    if u11.FramePriority.MainMenu or u11.FramePriority.MatchEnd then
        return;
    end;

    u14.End();
    local v81 = v79.CFrame or v80:GetPivot();
    local CFrame_lookAt_ret = CFrame.lookAt(p77, v81.Position + Vector3.new(0, 1.5, 0));
    u1.SetZoom(0);
    u1.SetTarget(4);
    u1.SetCameraCFrame(CFrame_lookAt_ret);
    u27 = v80.PrimaryPart;
    u28 = p78;
    u29 = CFrame_lookAt_ret;
    u30 = os.clock();
end;

function u1.SetZoom(p82: number) -- Line: 370
    -- upvalues: u31 (ref), CFrame_identity4 (ref)
    u31 = p82 == 0;
    CFrame_identity4 = CFrame.new(0, 0, p82);
end;

function u1.SetMouseLock(p83: boolean) -- Line: 375
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = p83 and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default;
end;

function u1.SetMouseIconVisibility(p84: boolean) -- Line: 379
    -- upvalues: UserInputService (copy)
    UserInputService.MouseIconEnabled = p84;
end;

function u1.SetFirstPerson(p85: boolean) -- Line: 383
    -- upvalues: u26 (ref), u8 (ref), u1 (copy), UserInputService (copy), u6 (ref)
    u26 = p85;

    if p85 then
        u8:Removes("CameraInputBegan", "CameraInputEnded");
        u1.SetZoom(0);
        u1.SetMouseLock(true);
    else
        u8:Add("CameraInputBegan", UserInputService.InputBegan:Connect(function(p86, p87) -- Line: 391
            -- upvalues: u6 (ref), u1 (ref)
            if p86.UserInputType == Enum.UserInputType.MouseButton2 then
                if p87 then
                    return;
                end;

                u6 = true;
                u1.UpdateMouseBehaviour();
            end;
        end));
        u8:Add("CameraInputEnded", UserInputService.InputEnded:Connect(function(p88) -- Line: 399
            -- upvalues: u6 (ref), u1 (ref)
            if p88.UserInputType == Enum.UserInputType.MouseButton2 then
                u6 = false;
                u1.UpdateMouseBehaviour();
            end;
        end));
        u1.SetZoom(16);
    end;

    u1.UpdateMouseBehaviour();
end;

function u1.InDeathCam() -- Line: 412
    -- upvalues: u27 (ref)
    return u27;
end;

function u1.InFirstPersonView() -- Line: 416
    -- upvalues: u25 (ref), u21 (ref)
    local v89;

    if u25 == 1 then
        v89 = true;
    elseif u25 == nil then
        v89 = u21.GetCurrentMode() == "FirstPerson";
    else
        v89 = false;
    end;

    return v89;
end;

function u1.IsLockedToScene() -- Line: 420
    -- upvalues: u25 (ref), u23 (ref), u19 (ref)
    local v90;

    if typeof(u25) == "Instance" then
        v90 = true;
    else
        if not u23 and u19 then
            u23 = u19.GetComponent("CaseInspect");
        end;

        v90 = u23 and (u23.IsOpeningCase and u23.IsOpeningCase()) or false;
    end;

    return v90;
end;

function u1.UpdateMouseBehaviour() -- Line: 426
    -- upvalues: u26 (ref), GameSettings (copy), u6 (ref), UserInputService (copy)
    if u26 then
        GameSettings.RotationType = Enum.RotationType.CameraRelative;

        return;
    end;

    if u6 then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition;

        return;
    end;

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
end;

function u1.GetAppliedCFrame() -- Line: 438
    -- upvalues: CFrame2 (ref)
    return CFrame2;
end;

function u1.GetCFrame() -- Line: 442
    -- upvalues: CFrame_identity2 (ref)
    return CFrame_identity2;
end;

function u1.GetRigidCFrame() -- Line: 446
    -- upvalues: CFrame_identity3 (ref)
    return CFrame_identity3;
end;

function u1.GetAppliedScretchAmount() -- Line: 450
    -- upvalues: u25 (ref), u37 (ref)
    return u25 == 1 and u37 or 1;
end;

function u1.GetFieldOfView() -- Line: 454
    -- upvalues: u34 (ref)
    return u34;
end;

function u1.GetFovDistanceScale() -- Line: 458
    -- upvalues: u35 (ref)
    return u35;
end;

function u1.GetSettingsFieldOfView() -- Line: 462
    -- upvalues: u38 (ref)
    return u38;
end;

function u1.GetAngles() -- Line: 466
    -- upvalues: u16 (ref)
    return u16.GetAngles();
end;

function u1.SetAngles(p91: number, p92: number) -- Line: 470
    -- upvalues: u16 (ref)
    u16.SetAngles(p91, p92);
end;

function u1.GetMapAngles() -- Line: 474
    -- upvalues: u16 (ref)
    return u16.GetMapAngles();
end;

function u1.AddTouchDelta(p93) -- Line: 478
    -- upvalues: u16 (ref)
    u16.AddTouchDelta(p93);
end;

function u1.StretchFov(p94: number) -- Line: 484
    -- upvalues: u25 (ref), u37 (ref)
    if u25 ~= 1 or u37 == 1 then
        return p94;
    end;

    local v95 = math.tan(p94 * 0.010471975511965976) * u37 * 0.75;

    return math.atan(v95) * 114.59155902616465;
end;

function u1.ApplyFov() -- Line: 492
    -- upvalues: u1 (copy), u36 (ref), u34 (ref), u35 (ref), workspace_CurrentCamera (copy)
    local v96 = u1.StretchFov(u36);
    u34 = v96;
    local v97 = math.rad(v96) * 0.5;
    u35 = math.tan(v97) / 0.7002075382097097;
    workspace_CurrentCamera.FieldOfView = v96;
end;

function u1.SetScretchAmount(p98) -- Line: 500
    -- upvalues: u37 (ref), u1 (copy)
    u37 = p98;
    u1.ApplyFov();
end;

function u1.SetFOVAmount(p99) -- Line: 505
    -- upvalues: u36 (ref), u16 (ref), u38 (ref), u1 (copy)
    u36 = p99;
    u16.SetSensitivityFieldOfViewMultiplier(p99 / u38);
    u1.ApplyFov();
end;

function u1.Init(p100) -- Line: 514
    -- upvalues: u7 (ref), u8 (ref), u12 (ref), u11 (ref), u9 (ref), u13 (ref), u10 (ref), u19 (ref), u14 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u24 (ref), u1 (copy)
    u7 = p100:GetModule("Tick");
    u8 = p100:GetModule("Maid").new();
    u12 = p100:GetModule("Signal");
    u11 = p100:GetModule("BindsController");
    u9 = p100:GetModule("CharacterController");
    u13 = p100:GetModule("Viewmodel");
    u10 = p100:GetModule("WeaponController");
    u19 = p100:GetModule("Gui");
    u14 = p100:GetModule("Freecam");
    u15 = p100:GetModule("FollowCamera");
    u16 = p100:GetModule("CameraInput");
    u17 = p100:GetModule("PlayerCamera");
    u18 = p100:GetModule("MobileAimAssist");
    u24 = p100:GetModule("FrustumCuller").Shared();
    u1.CameraTargetUpdate = u12.new();
end;

function u1.Start(p101) -- Line: 536
    -- upvalues: u21 (ref), u22 (ref), u23 (ref), u19 (ref), u1 (copy), u17 (ref), u9 (ref), u27 (ref), u29 (ref), u28 (ref), u2 (ref), u3 (ref), u10 (ref), u5 (ref), u4 (ref), workspace_CurrentCamera (copy), u11 (ref), u38 (ref), u25 (ref), u14 (ref), CFrame_identity2 (ref), u7 (ref), ProcessFrame (copy), u20 (ref)
    u21 = p101:GetModule("Spectate");
    u22 = p101:GetModule("Entities");
    u23 = u19.GetComponent("CaseInspect");
    u1.RefreshRecoilConfig = u17.RefreshRecoilConfig;
    u9.OnPostCharacterSpawn:Connect(function(p102) -- Line: 545
        -- upvalues: u27 (ref), u29 (ref), u28 (ref), u2 (ref), u3 (ref), u10 (ref), u5 (ref), u4 (ref), workspace_CurrentCamera (ref), u11 (ref), u1 (ref), u38 (ref)
        u27 = nil;
        u29 = nil;
        u28 = nil;
        u2 = p102;
        u3 = p102.Simulation;
        u2.Maid:Add("OnWeaponChanged", u10.OnWeaponChanged:Connect(function(p103) -- Line: 550
            -- upvalues: u5 (ref), u4 (ref), workspace_CurrentCamera (ref)
            u5 = p103.Viewmodel;
            u4 = p103;
            u5.Parent = workspace_CurrentCamera;
        end));
        u2.Maid:Add("OnWeaponUnequip", u10.OnWeaponUnequip:Connect(function(p104) -- Line: 560
            -- upvalues: u4 (ref), u5 (ref)
            if u4 == p104 then
                u4 = nil;
                u5 = nil;
            end;
        end));

        if not u11.FramePriority.MainMenu then
            u1.SetTarget(1);
            u1.SetFOVAmount(u38);
        end;
    end);
    u9.OnCharacterDestroy:Connect(function() -- Line: 573
        -- upvalues: u25 (ref), u11 (ref), u14 (ref), CFrame_identity2 (ref)
        if u25 == 1 and not u11.FramePriority.MainMenu then
            u14.Begin(CFrame_identity2);
        end;
    end);
    u7.PostTick.Connect({
        Priority = 3,
        SubPriority = 1,
        Function = ProcessFrame
    });
    u20 = u19.GetComponent("Settings");
    u20:AddPlayerConnection("Game", "Gameplay", "Field Of View", function(p105) -- Line: 583
        -- upvalues: u38 (ref), u1 (ref)
        u38 = p105;

        if u1.InFirstPersonView() then
            u1.SetFOVAmount(p105);
        end;
    end);
end;

return u1;