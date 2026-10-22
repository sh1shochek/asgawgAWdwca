-- ReplicatedStorage.GameClient.Spectate
-- Script path: ReplicatedStorage.GameClient.Spectate
-- Decompile time: 27.33 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local GameStats = ReplicatedStorage.GameStats;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
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

local function IsOpeningCase() -- Line: 26
    -- upvalues: u24 (ref), u14 (ref)
    if not u24 and u14 then
        u24 = u14.GetComponent("CaseInspect");
    end;

    return u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false;
end;

local function IsCameraLockedToScene() -- Line: 33
    -- upvalues: u24 (ref), u14 (ref), u6 (ref)
    if not u24 and u14 then
        u24 = u14.GetComponent("CaseInspect");
    end;

    if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
        return true;
    end;

    local v25 = u6 and u6.GetTarget and u6.GetTarget();

    return typeof(v25) == "Instance";
end;

local u26 = "Freecam";
local u27 = nil;
local u28 = nil;
local Characters = workspace:WaitForChild("Characters");
local u29 = 0;
local u30 = 0;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = false;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = 1;
local u39 = nil;
local u40 = 1;
local u41 = true;
local u42 = 3;
local u43 = nil;
local u44 = {
    Velocity = Vector3.new(0, 0, 0),
    Ducking = false,
    Ducked = false,
    OnGround = false,
    _AimPunchAngle = nil
};

local function FindCharacterModel(p45: number) -- Line: 95
    -- upvalues: u11 (ref), Characters (copy)
    local v46 = u11 and u11.GetEntity("Character", p45);

    return v46 and v46.Model or Characters:FindFirstChild((tostring(p45)));
end;

function u1.IsFirstPersonTarget(p47: number) -- Line: 114
    -- upvalues: u26 (ref), u32 (ref), u29 (ref)
    local v48;

    if u26 == "FirstPerson" and u32 ~= nil then
        v48 = p47 == u29;
    else
        v48 = false;
    end;

    return v48;
end;

function u1.IsHiddenTarget(p49: number) -- Line: 120
    -- upvalues: u1 (copy), u39 (ref)
    local v50 = u1.IsFirstPersonTarget(p49) and u39 == nil;

    return v50;
end;

local function GetPlantedBombPart() -- Line: 137
    -- upvalues: u11 (ref)
    local _, v51 = next(u11.GetAllCategoryEntities("Bomb") or {});

    if not v51 or (v51.Defused or v51.Exploded) then
        return nil;
    end;

    return v51.Model and v51.Model.PrimaryPart;
end;

local function CleanupSpectateTarget(p52: boolean?) -- Line: 147
    -- upvalues: u24 (ref), u14 (ref), u6 (ref), u31 (ref), u41 (ref), u26 (ref), u39 (ref), u40 (ref), u10 (ref), u28 (ref), u36 (ref), u37 (ref), u38 (ref), u43 (ref), u15 (ref), u2 (ref), u30 (ref), u33 (ref), u8 (ref), u32 (ref), u29 (ref)
    if not u24 and u14 then
        u24 = u14.GetComponent("CaseInspect");
    end;

    local v53;

    if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
        v53 = true;
    else
        local v54 = u6 and u6.GetTarget and u6.GetTarget();
        v53 = typeof(v54) == "Instance";
    end;

    if u31 then
        if p52 and (u41 and (u26 == "FirstPerson" and not v53)) then
            u39 = u6.GetCFrame();
            u40 = 0;
        else
            u39 = nil;
        end;
    end;

    u10.Reset();
    u28:Clear();
    u36 = nil;
    u37 = nil;
    u38 = 1;
    u43.Spectate(nil);

    if u31 then
        if not v53 then
            u6.SetTarget(nil);
            u6.SetZoom(0);
        end;

        u15.SetWeapon(0);
        u15.Clear();
        u2:Removes(u30 .. "_CharacterModel", u30 .. "_CameraCFrame", u30 .. "_CurrentWeaponChanged", u30 .. "_CurrentWeaponStateChanged");

        if u33 then
            u8.Destroy(u33);
            table.clear(u33);
            u33 = nil;
        end;
    end;

    u31 = nil;
    u32 = nil;
    u33 = nil;
    u29 = nil;
    u30 = nil;
end;

local function OnPlayerAdded(u55: userdata) -- Line: 200
    -- upvalues: LocalPlayer (copy), u2 (ref), u11 (ref), u31 (ref), u1 (copy)
    if u55 == LocalPlayer then
        return;
    end;

    local UserId = u55.UserId;
    u2:Add(UserId .. "_Health", u11.OnHealthUpdate:Connect(function(p56, p57) -- Line: 206
        -- upvalues: UserId (copy), u2 (ref), u31 (ref), u55 (copy), u1 (ref)
        if p56 ~= UserId then
            return;
        end;

        if p57 <= 0 then
            u2:Removes(UserId .. "_CharacterModel", UserId .. "_Viewmodel");

            if u31 == u55 then
                u1.Next();
            end;
        end;
    end));
end;

local function OnPlayerRemoving(p58: userdata) -- Line: 224
    -- upvalues: LocalPlayer (copy), u2 (ref), u31 (ref), CleanupSpectateTarget (copy), u1 (copy)
    if p58 == LocalPlayer then
        return;
    end;

    local UserId = p58.UserId;
    u2:Removes(UserId .. "_Health", UserId .. "_ChangedTeam");

    if u31 == p58 then
        CleanupSpectateTarget(true);
        u1.Next();
    end;
end;

local function GetLoadoutGloves(p59, p60) -- Line: 240
    -- upvalues: HttpService (copy)
    local v61 = HttpService:JSONDecode(p59:GetAttribute("WeaponLoadout"));

    if not v61 then
        return;
    end;

    local v62 = v61[p60];

    if v62 then
        local v63 = v62["16"];

        return {
            WeaponName = v63.WeaponName,
            SkinName = v63.SkinName,
            SkinId = v63.SkinId
        };
    end;
end;

local function GetLoadoutAgent(p64, p65) -- Line: 262
    -- upvalues: HttpService (copy)
    local v66 = HttpService:JSONDecode(p64:GetAttribute("WeaponLoadout"))[p65];

    if v66 then
        v66 = v66["15"].SkinName;
    end;

    return v66;
end;

local function ApplySpectateWeaponState(p67, p68) -- Line: 268
    -- upvalues: u24 (ref), u14 (ref), u6 (ref), u15 (ref), u8 (ref)
    local Mode = p68.Mode;

    if Mode == 1 or Mode == 2 then
        p67.Mode = Mode;
    elseif not p67.Mode then
        p67.Mode = Mode == 4 and 2 or 1;
    end;

    p67.Reloading = p68.Reloading or false;
    p67.Firing = p68.Firing or false;
    p67.ZoomLevel = p68.ZoomLevel or 0;
    local AltFunction = p67.Data.AltFunction;
    local v69;

    if AltFunction then
        v69 = AltFunction.Zoom;
    else
        v69 = AltFunction;
    end;

    if not u24 and u14 then
        u24 = u14.GetComponent("CaseInspect");
    end;

    local v70;

    if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
        v70 = true;
    else
        local v71 = u6 and u6.GetTarget and u6.GetTarget();
        v70 = typeof(v71) == "Instance";
    end;

    local v72;

    if v69 then
        v72 = v69.First;
    else
        v72 = v69;
    end;

    local v73;

    if v69 then
        v73 = v69.Second;
    else
        v73 = v69;
    end;

    u15.SetWeapon((v70 or not v69) and 0 or (p67.ZoomLevel or 0), v72, v73);

    if not AltFunction then
        return;
    end;

    if AltFunction.Name == "Silencer" then
        local Silencer = p67.Viewmodel.Weapon:FindFirstChild("Silencer", true);

        if Silencer and (Silencer:IsA("BasePart") and (p67.Mode == 1 or p67.Mode == 2)) then
            Silencer.Transparency = p67.Mode == 1 and 0 or 1;
        end;
    elseif v69 then
        u8.SetVisible(p67, p67.ZoomLevel == 0);
    end;
end;

local function FirstPersonApplyViewmodel(p74) -- Line: 307
    -- upvalues: u33 (ref), u8 (ref), u12 (ref), u31 (ref), GetLoadoutGloves (copy), HttpService (copy), workspace_CurrentCamera (copy), ApplySpectateWeaponState (copy)
    if u33 then
        u8.Destroy(u33);
        table.clear(u33);
        u33 = nil;
    end;

    local v75 = u12.Get(p74.Name);
    local v76 = {
        Name = p74.Name,
        Skin = p74.Skin,
        Mode = (p74.Mode == 2 or p74.Mode == 4) and 2 or 1,
        Reloading = p74.Reloading or false,
        ZoomLevel = p74.ZoomLevel or 0,
        Firing = p74.Firing or false,
        KillTrack = p74.KillTrack,
        KillTrackColor = p74.KillTrackColor,
        NameTag = p74.NameTag,
        Stickers = p74.Stickers,
        SilentEvents = true,
        Data = table.clone(v75.Data)
    };
    v76.IsSniper = v76.Data.AltFunction and v76.Data.AltFunction.Type == "Sniper" and true or false;
    v76.Emissive = p74.Emissive;
    local AltFunction = v76.Data.AltFunction;

    if v76.Mode == 2 and (AltFunction and AltFunction.Name == "ScopeRifle") then
        v76.IronSightAmount = 1;
    end;

    local new = u8.new;
    local v77 = {
        Scale = 0.15,
        Team = u31:GetAttribute("Team"),
        Gloves = GetLoadoutGloves(u31, u31:GetAttribute("Team"))
    };
    local Attribute = u31:GetAttribute("Team");
    local v78 = HttpService:JSONDecode(u31:GetAttribute("WeaponLoadout"))[Attribute];

    if v78 then
        v78 = v78["15"].SkinName;
    end;

    v77.Agent = v78;
    v77.Parent = workspace_CurrentCamera;
    u33 = new(v76, v77);
    u8.RestoreScale(u33);
    u8.SetVisible(v76, true);
    ApplySpectateWeaponState(v76, p74);
end;

local function ApplySpectateAnimation(p79, p80, p81) -- Line: 368
    -- upvalues: u36 (ref), u37 (ref), u38 (ref)
    local Animators = p79.Animators;

    if not Animators then
        return;
    end;

    local v82;

    if p80 then
        v82 = Animators[p80];
    else
        v82 = p80;
    end;

    local v83;

    if p80 == nil then
        v83 = false;
    else
        v83 = p80:sub(1, 7) == "Inspect";
    end;

    local v84 = p80 ~= u36;

    if v84 then
        if v82 and not (v82.Looped or v83) then
            for i, v in Animators do
                if i ~= p80 then
                    v:Stop();
                end;
            end;
        end;

        u36 = p80;
        u37 = nil;
    end;

    if v82 then
        local v85 = p81 or 0;
        local v86;

        if v82.Looped then
            v86 = v85 % 1;
        else
            v86 = math.clamp(v85, 0, 1);
        end;

        local v87 = u37 and (v86 - u37 or 0) or 0;
        local v88 = not (v83 and u37) and 1 or (v87 ~= 0 and (v87 < 0 and v87 > -0.5 and -1 or 1) or u38);
        local v89 = not v82.Looped;

        if v89 then
            if v88 > 0 then
                v89 = v87 < 0;
            else
                v89 = false;
            end;
        end;

        u37 = v86;
        u38 = v88;

        if v84 or (v89 or not v82.Playing) then
            v82.Track.Alpha = v86;
        else
            local math_abs_ret = math.abs(v86 - v82.Track.Alpha);

            if v82.Looped then
                math_abs_ret = math.min(math_abs_ret, 1 - math_abs_ret);
            end;

            if math_abs_ret > 0.15 then
                v82.Track.Alpha = v86;
            end;
        end;

        v82.Direction = v88;
        local Looped = v82.Looped;

        if not Looped then
            if v88 > 0 and v82.Track.Alpha < 1 then
                Looped = true;
            elseif v88 < 0 then
                Looped = v82.Track.Alpha > 0;
            else
                Looped = false;
            end;
        end;

        v82:SetPlaying(Looped);
    end;
end;

local function FirstPersonCFrameChangedStep(p90: number) -- Line: 465
    -- upvalues: u10 (ref), u39 (ref), u40 (ref), u42 (ref), u33 (ref), u11 (ref), u29 (ref), u44 (copy), ApplySpectateAnimation (copy), u8 (ref), u6 (ref)
    local v91, v92, v93, v94, v95, v96 = u10.Sample();

    if not v91 then
        return;
    end;

    local v97 = v94 or 0;

    if u39 then
        u40 = math.min(1, u40 + p90 * u42);
        v91 = u10.BlendPose(u39, v91, u40 * u40 * (3 - u40 * 2));

        if u40 == 1 then
            u39 = nil;
        end;
    end;

    local v98 = u33;

    if v98 then
        local Entity = u11.GetEntity("Character", u29);
        local v99 = u44;
        v99.Velocity = v96 or Vector3.new(0, 0, 0);

        if Entity then
            v99.Ducking = Entity.Ducking;
            v99.Ducked = Entity.Ducked;
            v99.OnGround = Entity.OnGround;
        end;

        v99._AimPunchAngle = v95;
        ApplySpectateAnimation(v98, v92, v93);
        u8.Render(v91, v99, v98, p90, v97);

        if not (u8.SolveAnimation(v98) or v98.Reloading) then
            u8.ResetPose(v98);
        end;
    end;

    u6.SetCameraCFrame(v91);
    local v100, v101 = v91:ToEulerAnglesYXZ();
    u6.SetAngles(v101, -v100);
end;

local function ThirdPerson() -- Line: 550
    -- upvalues: u26 (ref), u15 (ref), u2 (ref), u30 (ref), u33 (ref), u8 (ref), u43 (ref), u32 (ref), u29 (ref), u11 (ref), Characters (copy), u7 (ref), u24 (ref), u14 (ref), u6 (ref)
    u26 = "ThirdPerson";
    u15.SetWeapon(0);
    u2:Removes(u30 .. "_CharacterModel", u30 .. "_CameraCFrame", u30 .. "_CurrentWeaponChanged", u30 .. "_CurrentWeaponStateChanged");

    if u33 then
        u8.Destroy(u33);
        table.clear(u33);
        u33 = nil;
    end;

    u43.Spectate(nil);
    local v102 = u32;

    if not v102 then
        local v103 = u29;
        local v104 = u11 and u11.GetEntity("Character", v103);
        v102 = v104 and v104.Model or Characters:FindFirstChild((tostring(v103)));
    end;

    if v102 then
        u32 = v102;
        u7.SetTarget(v102.PrimaryPart);

        if not u24 and u14 then
            u24 = u14.GetComponent("CaseInspect");
        end;

        local v105;

        if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
            v105 = true;
        else
            local v106 = u6 and u6.GetTarget and u6.GetTarget();
            v105 = typeof(v106) == "Instance";
        end;

        if not v105 then
            u6.SetZoom(10);
            u6.SetTarget(3);
        end;
    end;
end;

local function FirstPerson() -- Line: 583
    -- upvalues: u26 (ref), u29 (ref), u11 (ref), Characters (copy), u43 (ref), u31 (ref), u32 (ref), u24 (ref), u14 (ref), u6 (ref), u2 (ref), u30 (ref), u1 (copy), u23 (ref), FirstPersonApplyViewmodel (copy), u33 (ref), ApplySpectateWeaponState (copy), u9 (ref), FirstPersonCFrameChangedStep (copy)
    u26 = "FirstPerson";
    local v107 = u29;
    local v108 = u11 and u11.GetEntity("Character", v107);
    local v109 = v108 and v108.Model or Characters:FindFirstChild((tostring(v107)));
    u43.Spectate(u31);

    if v109 then
        u32 = v109;

        if not u24 and u14 then
            u24 = u14.GetComponent("CaseInspect");
        end;

        local v110;

        if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
            v110 = true;
        else
            local v111 = u6 and u6.GetTarget and u6.GetTarget();
            v110 = typeof(v111) == "Instance";
        end;

        if not v110 then
            u6.SetTarget(nil);
            u6.SetZoom(0);
        end;

        u2:Add(u30 .. "_CharacterModel", v109.DescendantAdded:Connect(function(p112) -- Line: 607
            -- upvalues: u1 (ref), u29 (ref), u23 (ref)
            if u1.IsHiddenTarget(u29) then
                u23.SetObjectTransparency(p112, 1);
            end;
        end));

        local function OnSpectateWeaponEquip(p113, p114) -- Line: 615
            -- upvalues: u29 (ref), FirstPersonApplyViewmodel (ref)
            if u29 ~= p113 then
                return;
            end;

            FirstPersonApplyViewmodel(p114);
        end;

        local function OnSpectateWeaponState(p115, p116) -- Line: 622
            -- upvalues: u29 (ref), u33 (ref), ApplySpectateWeaponState (ref)
            if u29 ~= p115 then
                return;
            end;

            local v117 = u33;

            if v117 then
                ApplySpectateWeaponState(v117, p116);
            end;
        end;

        local v118 = u11 and u11.GetEntity("Character", u29);

        if v118 then
            v118 = v118.CharacterCurrentWeapon;
        end;

        if v118 then
            FirstPersonApplyViewmodel(v118);
        end;

        u2:Add(u30 .. "_CurrentWeaponChanged", u11.OnCharacterCurrentWeapon:Connect(function(p119, p120) -- Line: 638
            -- upvalues: u29 (ref), FirstPersonApplyViewmodel (ref)
            if u29 ~= p119 then
                return;
            end;

            FirstPersonApplyViewmodel(p120);
        end));
        u2:Add(u30 .. "_CurrentWeaponStateChanged", u11.OnCharacterCurrentWeaponInventoryData:Connect(function(p121, p122) -- Line: 642
            -- upvalues: u29 (ref), u33 (ref), ApplySpectateWeaponState (ref)
            if u29 ~= p121 then
                return;
            end;

            local v123 = u33;

            if v123 then
                ApplySpectateWeaponState(v123, p122);
            end;
        end));
        u2:Add(u30 .. "_CameraCFrame", u9.PostTick.Connect({
            Function = function(p124, p125) -- Line: 647
                -- upvalues: FirstPersonCFrameChangedStep (ref)
                FirstPersonCFrameChangedStep(p124);
            end,

            Priority = 1,
            SubPriority = 2
        }));
    end;
end;

function u1.Next() -- Line: 660
    -- upvalues: u35 (ref), GameStats (copy), u6 (ref), u34 (ref), u5 (ref)
    if u35 then
        return;
    end;

    if GameStats:GetAttribute("State") == "MatchEnded" then
        return;
    end;

    if u6.InDeathCam() then
        return;
    end;

    if u34 then
        return;
    end;

    u34 = true;
    u5.Spectate.SpectatePosition.Fire(1);
end;

function u1.SpectateTarget(p126: number?) -- Line: 686
    -- upvalues: u35 (ref), u34 (ref), GameStats (copy), u5 (ref)
    if not p126 or (u35 or u34) then
        return;
    end;

    if GameStats:GetAttribute("State") == "MatchEnded" then
        return;
    end;

    u34 = true;
    u5.Spectate.SpectateTarget.Fire(p126);
end;

function u1.Previous() -- Line: 699
    -- upvalues: u35 (ref), GameStats (copy), u6 (ref), u34 (ref), u5 (ref)
    if u35 then
        return;
    end;

    if GameStats:GetAttribute("State") == "MatchEnded" then
        return;
    end;

    if u6.InDeathCam() then
        return;
    end;

    if u34 then
        return;
    end;

    u34 = true;
    u5.Spectate.SpectatePosition.Fire(2);
end;

function u1.ChangeMode() -- Line: 720
    -- upvalues: u35 (ref), u6 (ref), GameStats (copy), u34 (ref), u31 (ref), u26 (ref), ThirdPerson (copy), CleanupSpectateTarget (copy), u5 (ref), u24 (ref), u14 (ref), u21 (ref), u1 (copy)
    if u35 then
        return;
    end;

    if u6.InDeathCam() then
        return;
    end;

    if GameStats:GetAttribute("State") == "MatchEnded" then
        return;
    end;

    if u34 then
        return;
    end;

    if u31 then
        if u26 == "FirstPerson" then
            ThirdPerson();

            return;
        end;

        if u26 == "ThirdPerson" then
            u26 = "Freecam";
            CleanupSpectateTarget();
            u5.Spectate.SpectatePosition.Fire(0);

            if not u24 and u14 then
                u24 = u14.GetComponent("CaseInspect");
            end;

            local v127;

            if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
                v127 = true;
            else
                local v128 = u6 and u6.GetTarget and u6.GetTarget();
                v127 = typeof(v128) == "Instance";
            end;

            if not v127 then
                u21.Begin(u6.GetCFrame());
            end;
        end;
    else
        if u21.GetState() then
            u21.End();
            u1.Next();

            return;
        end;

        u26 = "Freecam";

        if not u24 and u14 then
            u24 = u14.GetComponent("CaseInspect");
        end;

        local v129;

        if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
            v129 = true;
        else
            local v130 = u6 and u6.GetTarget and u6.GetTarget();
            v129 = typeof(v130) == "Instance";
        end;

        if not v129 then
            u21.Begin(u6.GetCFrame());
        end;
    end;
end;

function u1.IsSpectating() -- Line: 763
    -- upvalues: u31 (ref)
    return u31;
end;

function u1.GetSpectateTargetModel() -- Line: 767
    -- upvalues: u29 (ref), u11 (ref), Characters (copy)
    local v131 = u29;
    local v132 = u11 and u11.GetEntity("Character", v131);

    return v132 and v132.Model or Characters:FindFirstChild((tostring(v131)));
end;

function u1.GetCurrentMode() -- Line: 773
    -- upvalues: u26 (ref)
    return u26;
end;

function u1.GetSpectateIdentifier() -- Line: 777
    -- upvalues: u29 (ref)
    return u29;
end;

function u1.GetSpectateTeam() -- Line: 784
    -- upvalues: u31 (ref)
    local v133 = u31 and u31:GetAttribute("Team");

    return v133;
end;

function u1.GetSpectateWeapon() -- Line: 788
    -- upvalues: u33 (ref)
    return u33;
end;

u1.CleanupSpectateTarget = CleanupSpectateTarget;

function u1.Init(p134) -- Line: 796
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u11 (ref), u13 (ref), u12 (ref), u14 (ref), u21 (ref), u18 (ref), u19 (ref), u20 (ref), u22 (ref), u23 (ref), u28 (ref)
    u2 = p134:GetModule("Maid").new();
    u3 = p134:GetModule("BindsController");
    u4 = p134:GetModule("CharacterController");
    u5 = p134:GetModule("Network");
    u6 = p134:GetModule("CameraController");
    u7 = p134:GetModule("FollowCamera");
    u8 = p134:GetModule("Viewmodel");
    u9 = p134:GetModule("Tick");
    u10 = p134:GetModule("SpectateInterp");
    u11 = p134:GetModule("Entities");
    u13 = p134:GetModule("Table");
    u12 = p134:GetModule("WeaponManager");
    u14 = p134:GetModule("Gui");
    u21 = p134:GetModule("Freecam");
    u18 = p134:GetModule("BufferScheme");
    u19 = p134:GetModule("Enums");
    u20 = p134:GetModule("SnapshotRing");
    WeaponEffects = p134:GetModule("WeaponEffects");
    u22 = p134:GetModule("ParticleHandler");
    u23 = p134:GetModule("CharacterModel");
    u28 = u20.new(32);
    u10.SetTickRate(p134:GetModule("GameConfiguration").Get("Game", "TickRate"));
end;

function u1.Start(p135) -- Line: 823
    -- upvalues: u27 (ref), u18 (ref), u15 (ref), u14 (ref), u43 (ref), u16 (ref), u17 (ref), u24 (ref), u41 (ref), u39 (ref), u42 (ref), u4 (ref), u35 (ref), u34 (ref), CleanupSpectateTarget (copy), u5 (ref), u21 (ref), u6 (ref), Players (copy), LocalPlayer (copy), u2 (ref), u11 (ref), u31 (ref), u1 (copy), OnPlayerAdded (copy), OnPlayerRemoving (copy), u29 (ref), u26 (ref), GetPlantedBombPart (copy), u7 (ref), u30 (ref), FirstPerson (copy), ThirdPerson (copy), u33 (ref), u28 (ref), u13 (ref), u10 (ref), u19 (ref)
    u27 = u18.GetScheme("SpectateState");
    u15 = u14.GetComponent("Scope");
    u43 = u14.GetComponent("Settings");
    u16 = u14.GetComponent("Down");
    u17 = u14.GetComponent("MobileControls");
    u24 = u14.GetComponent("CaseInspect");
    u43:AddConnection("Game", "Gameplay", "Smooth Spectator Camera", function(p136) -- Line: 832
        -- upvalues: u41 (ref), u39 (ref)
        u41 = p136;

        if not p136 then
            u39 = nil;
        end;
    end);
    u43:AddConnection("Game", "Gameplay", "Smooth Spectator Camera Speed", function(p137) -- Line: 840
        -- upvalues: u42 (ref)
        u42 = p137;
    end);
    u4.OnCharacterSpawn:Connect(function(p138) -- Line: 844
        -- upvalues: u35 (ref), u17 (ref), u34 (ref), CleanupSpectateTarget (ref), u5 (ref), u21 (ref), u6 (ref)
        u35 = p138;
        u17.SetSpectating(false);
        u34 = false;
        CleanupSpectateTarget();
        u5.Spectate.SpectatePosition.Fire(0);
        u21.End();
        u6.SetZoom(0);
    end);
    u4.OnCharacterDestroy:Connect(function() -- Line: 854
        -- upvalues: u35 (ref), u17 (ref)
        u35 = nil;
        u17.SetSpectating(true);
    end);

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer then
            if v ~= LocalPlayer then
                local UserId = v.UserId;
                u2:Add(UserId .. "_Health", u11.OnHealthUpdate:Connect(function(p139, p140) -- Line: 206
                    -- upvalues: UserId (copy), u2 (ref), u31 (ref), v (copy), u1 (ref)
                    if p139 ~= UserId then
                        return;
                    end;

                    if p140 <= 0 then
                        u2:Removes(UserId .. "_CharacterModel", UserId .. "_Viewmodel");

                        if u31 == v then
                            u1.Next();
                        end;
                    end;
                end));
            end;
        end;
    end;

    Players.PlayerAdded:Connect(OnPlayerAdded);
    Players.PlayerRemoving:Connect(OnPlayerRemoving);
    u5.Spectate.SpectateIdentifier.On(function(p141, p142) -- Line: 874
        -- upvalues: u34 (ref), u35 (ref), u17 (ref), u29 (ref), u31 (ref), CleanupSpectateTarget (ref), u26 (ref), u39 (ref), GetPlantedBombPart (ref), u24 (ref), u14 (ref), u6 (ref), u21 (ref), u7 (ref), Players (ref), u30 (ref), u43 (ref), u16 (ref), u11 (ref), FirstPerson (ref), ThirdPerson (ref)
        u34 = false;

        if u35 then
            return;
        end;

        u17.SetSpectating(true);

        if p141 ~= 0 and (p141 == u29 and u31) then
            return;
        end;

        local v143 = u31 ~= nil;
        CleanupSpectateTarget(true);

        if p141 == 0 or p142 == 0 then
            u26 = "Freecam";
            u39 = nil;

            if v143 then
                v143 = GetPlantedBombPart();
            end;

            if v143 then
                if not u24 and u14 then
                    u24 = u14.GetComponent("CaseInspect");
                end;

                local v144;

                if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
                    v144 = true;
                else
                    local v145 = u6 and u6.GetTarget and u6.GetTarget();
                    v144 = typeof(v145) == "Instance";
                end;

                if not v144 then
                    u21.End();
                    u7.SetTarget(v143);
                    u6.SetZoom(10);
                    u6.SetTarget(3);

                    return;
                end;
            end;

            if not u24 and u14 then
                u24 = u14.GetComponent("CaseInspect");
            end;

            local v146;

            if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
                v146 = true;
            else
                local v147 = u6 and u6.GetTarget and u6.GetTarget();
                v146 = typeof(v147) == "Instance";
            end;

            if not v146 then
                u21.Begin(u6.GetCFrame());
            end;

            return;
        end;

        local PlayerByUserId = Players:GetPlayerByUserId(p142);

        if not PlayerByUserId then
            u26 = "Freecam";
            u39 = nil;

            if not u24 and u14 then
                u24 = u14.GetComponent("CaseInspect");
            end;

            local v148;

            if u24 and (u24.IsOpeningCase and u24.IsOpeningCase()) or false then
                v148 = true;
            else
                local v149 = u6 and u6.GetTarget and u6.GetTarget();
                v148 = typeof(v149) == "Instance";
            end;

            if not v148 then
                u21.Begin(u6.GetCFrame());
            end;

            return;
        end;

        u21.End();
        u29 = p141;
        u30 = p142;
        u31 = PlayerByUserId;
        u43.Spectate(u31);
        u16.SetTarget(PlayerByUserId);
        local v150 = u11 and u11.GetEntity("Character", p141);

        if v150 and v150.ApplyCull then
            v150:ApplyCull(false);
        end;

        if u26 == "FirstPerson" or u26 == "Freecam" then
            FirstPerson();

            return;
        end;

        if u26 == "ThirdPerson" then
            ThirdPerson();

            return;
        end;

        FirstPerson();
    end);
    u5.Spectate.SpectateData.On(function(p151) -- Line: 969
        -- upvalues: u33 (ref), u26 (ref), u28 (ref), u27 (ref), u13 (ref), u5 (ref), u10 (ref), u19 (ref)
        local v152 = u33;

        if p151.EndPosition and (u26 == "FirstPerson" and v152) then
            local AltFunction = v152.Data.AltFunction;
            local v153;

            if v152.Name == "Dual Berettas" then
                v153 = v152.Data.Ammo % 2 == 0;
            else
                v153 = false;
            end;

            if AltFunction then
                if AltFunction.Name == "Silencer" then
                    AltFunction = v152.Mode == 1;
                else
                    AltFunction = false;
                end;
            end;

            WeaponEffects.Muzzle(v152, v152.Viewmodel, v153, AltFunction);
            WeaponEffects.Tracer(v152, v152.Viewmodel, v153, AltFunction, p151.EndPosition);
        end;

        local LastServerTick = p151.LastServerTick;
        local v154;

        if LastServerTick == 0 then
            v154 = nil;
        else
            v154 = u28:GetByTick(LastServerTick) or nil;
        end;

        if LastServerTick ~= 0 and not v154 then
            return;
        end;

        local v155 = p151.State and u27:UnpackScheme(p151.State);

        if v154 then
            v154 = v154.Snapshot;
        end;

        local v156 = v155 and v154 and u13.ApplyDelta(v154, v155) or (v155 or v154);

        if not v156 then
            return;
        end;

        u28:Push(p151.CurrentServerTick, nil, v156);
        u5.Spectate.AckSpectate.Fire(p151.CurrentServerTick);
        local Push = u10.Push;
        local v157 = {
            Position = v156.Position,
            Velocity = v156.Velocity,
            Pitch = v156.Pitch,
            Yaw = v156.Yaw,
            Roll = v156.Roll,
            AnimationName = u19.Animations[v156.Animation]
        };
        local v158;

        if v156.Animation == 0 then
            v158 = nil;
        else
            v158 = v156.AnimationAlpha or nil;
        end;

        v157.AnimationAlpha = v158;
        v157.Inaccuracy = v156.Inaccuracy;
        v157.AimPunchAngle = v156.AimPunchAngle;
        Push(v157, p151.CurrentServerTick, v155 ~= nil);
    end);
end;

return u1;