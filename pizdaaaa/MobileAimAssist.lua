-- ReplicatedStorage.GameClient.CameraController.MobileAimAssist
-- Script path: ReplicatedStorage.GameClient.CameraController.MobileAimAssist
-- Decompile time: 12.05 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GameStats = ReplicatedStorage:WaitForChild("GameStats");
local u2 = {
    TargetSelection = {
        MaxDistance = 300
    },
    Friction = {
        Enabled = true,
        Radius = 4,
        MinAngle = 0.05235987755982989,
        MaxAngle = 0.3141592653589793,
        MinSensitivity = 0.45,
        MaxSensitivity = 1
    },
    Magnetism = {
        Enabled = true,
        Radius = 4,
        MinAngle = 0.05235987755982989,
        MaxAngle = 0.2617993877991494,
        StopRadius = 0.6,
        PullStrength = 0.3490658503988659,
        VerticalScale = 0.5,
        ActiveLookSpeed = 0.5235987755982988,
        ActivityDecay = 0.15,
        IdleActivity = 0.35
    },
    RecoilAssist = {
        Enabled = true,
        ReductionAmount = 0.45,
        RequiresTarget = false
    }
};
local LocalPlayer = Players.LocalPlayer;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = false;
local u8 = false;
local u9 = 0;
local u10 = 0;
local u11 = nil;
local u12 = 0;
local u13 = "PC";

local function AssistPlatform() -- Line: 89
    -- upvalues: u13 (ref)
    return u13 == "Mobile" and true or u13 == "Console";
end;

local function IsDeathmatch() -- Line: 93
    -- upvalues: GameStats (copy)
    return GameStats:GetAttribute("Gamemode") == "Deathmatch";
end;

local function LocalTeam() -- Line: 97
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("Team");
end;

local function IsEnemy(p14) -- Line: 103
    -- upvalues: LocalPlayer (copy), GameStats (copy)
    if not (p14 and (not p14.Culled and p14.PrimaryPart)) then
        return false;
    end;

    if p14.UserId == LocalPlayer.UserId then
        return false;
    end;

    local v15 = p14.Data and p14.Data.Team;
    local Attribute = LocalPlayer:GetAttribute("Team");

    if GameStats:GetAttribute("Gamemode") == "Deathmatch" then
        return true;
    end;

    if v15 and Attribute then
        return v15 ~= Attribute;
    end;

    return false;
end;

local function LocalCharacterModel() -- Line: 121
    -- upvalues: u3 (ref), LocalPlayer (copy)
    local CharacterByUserId = u3.GetCharacterByUserId(LocalPlayer.UserId);

    if CharacterByUserId then
        CharacterByUserId = CharacterByUserId.Model;
    end;

    return CharacterByUserId;
end;

local function AimPoint(p16) -- Line: 126
    return p16.CFrame.Position + Vector3.new(0, 0.5, 0);
end;

local function ConeAngle(p17: number, p18: number, p19: number, p20: number) -- Line: 131
    local math_atan_ret = math.atan(p17 / p18);

    return math.clamp(math_atan_ret, p19, p20);
end;

local function AngleTo(p21: vector, p22: vector) -- Line: 135
    local vector_normalize_ret = vector.normalize(p22);
    local vector_dot_ret = vector.dot(p21, vector_normalize_ret);
    local math_clamp_ret = math.clamp(vector_dot_ret, -1, 1);

    return math.acos(math_clamp_ret);
end;

local function IsVisible(p23: any, p24: vector) -- Line: 141
    -- upvalues: u3 (ref), LocalPlayer (copy), Workspace (copy)
    local v25 = p23.CFrame.Position - p24;

    if vector.magnitude(v25) < 0.001 then
        return true;
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    local CharacterByUserId = u3.GetCharacterByUserId(LocalPlayer.UserId);

    if CharacterByUserId then
        CharacterByUserId = CharacterByUserId.Model;
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = CharacterByUserId and { CharacterByUserId } or {};
    local v26 = Workspace:Raycast(p24, v25, RaycastParams_new_ret);

    return v26 == nil and true or p23.Model:IsAncestorOf(v26.Instance);
end;

local function FindBestTarget(p27) -- Line: 160
    -- upvalues: u2 (copy), u3 (ref), LocalPlayer (copy), GameStats (copy), IsVisible (copy)
    local Friction = u2.Friction;
    local Position = p27.Position;
    local LookVector = p27.LookVector;
    local v28 = 0;
    local v29 = nil;

    for _, v in u3.GetAllCategoryEntities("Character") do
        local v30;

        if v and (not v.Culled and v.PrimaryPart) and v.UserId ~= LocalPlayer.UserId then
            local v31 = v.Data and v.Data.Team;
            local Attribute = LocalPlayer:GetAttribute("Team");

            if GameStats:GetAttribute("Gamemode") == "Deathmatch" then
                v30 = true;
            elseif v31 and Attribute then
                v30 = v31 ~= Attribute;
            else
                v30 = false;
            end;
        else
            v30 = false;
        end;

        if v30 then
            local v32 = v.CFrame.Position + Vector3.new(0, 0.5, 0) - Position;
            local vector_magnitude_ret = vector.magnitude(v32);

            if u2.TargetSelection.MaxDistance >= vector_magnitude_ret and vector_magnitude_ret >= 0.001 then
                local MinAngle = Friction.MinAngle;
                local MaxAngle = Friction.MaxAngle;
                local math_atan_ret = math.atan(Friction.Radius / vector_magnitude_ret);
                local math_clamp_ret = math.clamp(math_atan_ret, MinAngle, MaxAngle);
                local vector_normalize_ret = vector.normalize(v32);
                local vector_dot_ret = vector.dot(LookVector, vector_normalize_ret);
                local math_clamp_ret2 = math.clamp(vector_dot_ret, -1, 1);
                local v33 = 1 - math.acos(math_clamp_ret2) / math_clamp_ret;

                if v28 < v33 and IsVisible(v, Position) then
                    v29 = v;
                    v28 = v33;
                end;
            end;
        end;
    end;

    return v29;
end;

local function Magnetism(p34, p35: any, p36: number) -- Line: 193
    -- upvalues: u2 (copy), u10 (ref)
    local Magnetism = u2.Magnetism;
    local LookVector = p34.LookVector;
    local v37 = p35.CFrame.Position + Vector3.new(0, 0.5, 0) - p34.Position;
    local vector_magnitude_ret = vector.magnitude(v37);

    if vector_magnitude_ret < 0.001 then
        return Vector2.zero;
    end;

    local vector_normalize_ret = vector.normalize(v37);
    local vector_dot_ret = vector.dot(LookVector, vector_normalize_ret);
    local math_clamp_ret = math.clamp(vector_dot_ret, -1, 1);
    local math_acos_ret = math.acos(math_clamp_ret);
    local MinAngle = Magnetism.MinAngle;
    local MaxAngle = Magnetism.MaxAngle;
    local math_atan_ret = math.atan(Magnetism.Radius / vector_magnitude_ret);

    if math.clamp(math_atan_ret, MinAngle, MaxAngle) < math_acos_ret then
        return Vector2.zero;
    end;

    if math_acos_ret <= math.atan(Magnetism.StopRadius / vector_magnitude_ret) then
        return Vector2.zero;
    end;

    local v38 = v37 / vector_magnitude_ret;
    local v39 = math.atan2(-v38.X, -v38.Z) - math.atan2(-LookVector.X, -LookVector.Z);

    if v39 > 3.141592653589793 then
        v39 = v39 - 6.283185307179586;
    elseif v39 < -3.141592653589793 then
        v39 = v39 + 6.283185307179586;
    end;

    local math_clamp_ret2 = math.clamp(v38.Y, -1, 1);
    local math_asin_ret = math.asin(math_clamp_ret2);
    local math_clamp_ret3 = math.clamp(LookVector.Y, -1, 1);
    local v40 = math_asin_ret - math.asin(math_clamp_ret3);
    local v41 = math.min(math_acos_ret, Magnetism.PullStrength * u10 * p36) / math_acos_ret;

    return Vector2.new(v39 * v41, v40 * v41 * Magnetism.VerticalScale);
end;

function u1.IsActive() -- Line: 226
    -- upvalues: u13 (ref), u7 (ref)
    return (u13 == "Mobile" and true or u13 == "Console") and u7;
end;

function u1.ReportLook(p42: number) -- Line: 231
    -- upvalues: u9 (ref)
    u9 = u9 + p42;
end;

function u1.GetMagnetismRotation(p43: number) -- Line: 237
    -- upvalues: u2 (copy), u9 (ref), u10 (ref), u11 (ref), Workspace (copy), u1 (copy), FindBestTarget (copy), u12 (ref), Magnetism (copy)
    local Magnetism2 = u2.Magnetism;
    local v44 = u9 / math.max(p43, 0.001) / Magnetism2.ActiveLookSpeed;
    local math_min_ret = math.min(1, v44);
    u10 = math.max(math_min_ret, Magnetism2.IdleActivity, u10 - p43 / Magnetism2.ActivityDecay);
    u9 = 0;
    u11 = nil;
    local CurrentCamera = Workspace.CurrentCamera;

    if not (u1.IsActive() and CurrentCamera) then
        return Vector2.zero;
    end;

    local CFrame = CurrentCamera.CFrame;
    u11 = FindBestTarget(CFrame);
    u12 = os.clock();

    if u11 and (Magnetism2.Enabled and u10 > 0) then
        return Magnetism(CFrame, u11, p43);
    end;

    return Vector2.zero;
end;

function u1.GetFrictionMultiplier() -- Line: 262
    -- upvalues: u2 (copy), u11 (ref), u1 (copy), u12 (ref), LocalPlayer (copy), GameStats (copy), Workspace (copy)
    local Friction = u2.Friction;
    local v45 = u11;

    if u1.IsActive() and (Friction.Enabled and (v45 and os.clock() - u12 <= 0.1)) then
        local v46;

        if v45 and (not v45.Culled and v45.PrimaryPart) and v45.UserId ~= LocalPlayer.UserId then
            local v47 = v45.Data and v45.Data.Team;
            local Attribute = LocalPlayer:GetAttribute("Team");

            if GameStats:GetAttribute("Gamemode") == "Deathmatch" then
                v46 = true;
            elseif v47 and Attribute then
                v46 = v47 ~= Attribute;
            else
                v46 = false;
            end;
        else
            v46 = false;
        end;

        if v46 then
            local CurrentCamera = Workspace.CurrentCamera;

            if not CurrentCamera then
                return Friction.MaxSensitivity;
            end;

            local v48 = v45.CFrame.Position + Vector3.new(0, 0.5, 0) - CurrentCamera.CFrame.Position;
            local vector_magnitude_ret = vector.magnitude(v48);

            if vector_magnitude_ret < 0.001 then
                return Friction.MinSensitivity;
            end;

            local MinAngle = Friction.MinAngle;
            local MaxAngle = Friction.MaxAngle;
            local math_atan_ret = math.atan(Friction.Radius / vector_magnitude_ret);
            local math_clamp_ret = math.clamp(math_atan_ret, MinAngle, MaxAngle);
            local LookVector = CurrentCamera.CFrame.LookVector;
            local vector_normalize_ret = vector.normalize(v48);
            local vector_dot_ret = vector.dot(LookVector, vector_normalize_ret);
            local math_clamp_ret2 = math.clamp(vector_dot_ret, -1, 1);
            local v49 = math.acos(math_clamp_ret2) / math_clamp_ret;
            local math_min_ret = math.min(1, v49);

            return Friction.MinSensitivity + (Friction.MaxSensitivity - Friction.MinSensitivity) * math_min_ret;
        end;
    end;

    return Friction.MaxSensitivity;
end;

function u1.GetRecoilAssistMultiplier() -- Line: 287
    -- upvalues: u13 (ref), u8 (ref), u2 (copy), Workspace (copy), FindBestTarget (copy)
    if not ((u13 == "Mobile" or u13 == "Console") and (u8 and u2.RecoilAssist.Enabled)) then
        return 0;
    end;

    if u2.RecoilAssist.RequiresTarget then
        local CurrentCamera = Workspace.CurrentCamera;

        if not (CurrentCamera and FindBestTarget(CurrentCamera.CFrame)) then
            return 0;
        end;
    end;

    return u2.RecoilAssist.ReductionAmount;
end;

function u1.Init(p50) -- Line: 304
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), u13 (ref), UserInputService (copy)
    u3 = p50:GetModule("Entities");
    u4 = p50:GetModule("GetUserPlatform");
    u5 = p50:GetModule("Gui");
    u13 = u4();
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 310
        -- upvalues: u13 (ref), u4 (ref)
        u13 = u4();
    end);
end;

function u1.Start(p51) -- Line: 315
    -- upvalues: u6 (ref), u5 (ref), u7 (ref), u8 (ref)
    u6 = u5.GetComponent("Settings");
    local v52 = u6 and u6:GetPlayerSettings();
    local v53 = v52 and v52.Game and v52.Game.Gameplay;

    if v53 then
        if v53["Aim Assist"] ~= nil then
            u7 = v53["Aim Assist"];
        end;

        if v53["Recoil Assist"] ~= nil then
            u8 = v53["Recoil Assist"];
        end;
    end;

    u6:AddConnection("Game", "Gameplay", "Aim Assist", function(p54) -- Line: 331
        -- upvalues: u7 (ref)
        u7 = p54;
    end);
    u6:AddConnection("Game", "Gameplay", "Recoil Assist", function(p55) -- Line: 334
        -- upvalues: u8 (ref)
        u8 = p55;
    end);
end;

return u1;