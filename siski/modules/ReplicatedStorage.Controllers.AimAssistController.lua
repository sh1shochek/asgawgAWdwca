-- ReplicatedStorage.Controllers.AimAssistController
-- class: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local HordeController = require(ReplicatedStorage.Controllers.HordeController);
local FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect);
local GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local v2 = GetUserPlatform();
local u3;

if table.find(v2, "Mobile") == nil then
    u3 = false;
else
    u3 = #v2 <= 1;
end;

local CurrentCamera = Workspace.CurrentCamera;
local u4 = true;
local u5 = true;
local PLAYER = Constants.AIM_ASSIST_CONFIGS.PLAYER;
local u6 = {
    ["Counter-Terrorists"] = true,
    Terrorists = true
};
local u7 = {
    AimHeight = 0.6,
    PullAngle = 0.17453292519943295,
    PullRate = 3.2,
    IdlePullShare = 0.25,
    MaxPullSpeed = 0.5235987755982988,
    SettleAngle = 0.002617993877991494,
    TrackingStrength = 0.55,
    TrackingAngle = 0.12217304763960307,
    MaxTrackingSpeed = 3,
    StickDeadzone = 0.15
};
local u8 = nil;
local u9 = (-1 / 0);
local u10 = nil;
local u11 = nil;
local u12 = 0;
local u13 = 0;

local function clipSlab(p14: number, p15: number, p16: number, p17: number, p18: number, p19: number) -- Line: 98
    if math.abs(p15) < 0.0001 then
        if p14 < p16 or p17 < p14 then
            return nil, p19;
        end;

        return p18, p19;
    end;

    local v20 = 1 / p15;
    local v21 = (p16 - p14) * v20;
    local v22 = (p17 - p14) * v20;

    if v22 >= v21 then
        local v23 = v21;
        v21 = v22;
        v22 = v23;
    end;

    if p18 >= v22 then
        v22 = p18;
    end;

    if v21 >= p19 then
        v21 = p19;
    end;

    if v21 < v22 then
        return nil, v21;
    end;

    return v22, v21;
end;

local function rayIntersectsAABB(p24: vector, p25: vector, p26: vector, p27: vector, p28: number) -- Line: 130
    local X = p24.X;
    local X2 = p25.X;
    local X3 = p26.X;
    local X4 = p27.X;
    local v29 = 0;
    local v30, v31;

    if math.abs(X2) < 0.0001 then
        if X < X3 or X4 < X then
            v30 = p28;
            v31 = nil;
        else
            v30 = p28;
            v31 = v29;
        end;
    else
        local v32 = 1 / X2;
        v30 = (X3 - X) * v32;
        v31 = (X4 - X) * v32;

        if v31 >= v30 then
            local v33 = v30;
            v30 = v31;
            v31 = v33;
        end;

        if v29 >= v31 then
            v31 = v29;
        end;

        if v30 >= p28 then
            v30 = p28;
        end;

        if v30 < v31 then
            v31 = nil;
        end;
    end;

    if not v31 then
        return false;
    end;

    local Y = p24.Y;
    local Y2 = p25.Y;
    local Y3 = p26.Y;
    local Y4 = p27.Y;

    if math.abs(Y2) < 0.0001 then
        if Y < Y3 or Y4 < Y then
            v31 = nil;
        end;
    else
        local v34 = 1 / Y2;
        local v35 = (Y3 - Y) * v34;
        local v36 = (Y4 - Y) * v34;

        if v36 >= v35 then
            local v37 = v35;
            v35 = v36;
            v36 = v37;
        end;

        if v31 >= v36 then
            v36 = v31;
        end;

        if v35 >= v30 then
            v35 = v30;
        end;

        if v35 < v36 then
            v30 = v35;
            v31 = nil;
        else
            v30 = v35;
            v31 = v36;
        end;
    end;

    if not v31 then
        return false;
    end;

    local Z = p24.Z;
    local Z2 = p25.Z;
    local Z3 = p26.Z;
    local Z4 = p27.Z;

    if math.abs(Z2) < 0.0001 then
        if Z < Z3 or Z4 < Z then
            v31 = nil;
        end;
    else
        local v38 = 1 / Z2;
        local v39 = (Z3 - Z) * v38;
        local v40 = (Z4 - Z) * v38;

        if v40 >= v39 then
            local v41 = v39;
            v39 = v40;
            v40 = v41;
        end;

        if v31 >= v40 then
            v40 = v31;
        end;

        if v39 >= v30 then
            v39 = v30;
        end;

        if v39 < v40 then
            v30 = v39;
            v31 = nil;
        else
            v30 = v39;
            v31 = v40;
        end;
    end;

    local v42;

    if v31 == nil or v31 < 0 then
        v42 = false;
    else
        v42 = v31 <= p28;
    end;

    return v42;
end;

local function doesRaycastIntersectSmoke(p43: vector, p44: vector, p45: number) -- Line: 149
    -- upvalues: Workspace (copy), rayIntersectsAABB (copy)
    local Debris = Workspace:FindFirstChild("Debris");

    if not Debris then
        return false;
    end;

    for _, child in ipairs(Debris:GetChildren()) do
        if child.Name:match("^VoxelSmoke_") and child:IsA("Folder") then
            for _, child2 in ipairs(child:GetChildren()) do
                if child2:IsA("BasePart") and child2.Name == "SmokeVoxel" then
                    local Size = child2.Size;
                    local Position = child2.Position;

                    if rayIntersectsAABB(p43, p44, Position - Size / 2, Position + Size / 2, p45) then
                        return true;
                    end;
                end;
            end;
        end;
    end;

    return false;
end;

local function isEnemyTeam(p46) -- Line: 174
    -- upvalues: IsSurvivalMode (copy), LocalPlayer (copy), u6 (copy)
    if IsSurvivalMode() then
        return false;
    end;

    local Attribute = LocalPlayer:GetAttribute("Team");

    if u6[Attribute] and u6[p46] then
        return workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Attribute ~= p46;
    end;

    return false;
end;

local function isEnemyValid(p47: userdata) -- Line: 185
    -- upvalues: IsSurvivalMode (copy), LocalPlayer (copy), u6 (copy)
    local Attribute = p47:GetAttribute("Team");

    if IsSurvivalMode() then
        return false;
    end;

    local Attribute2 = LocalPlayer:GetAttribute("Team");

    if u6[Attribute2] and u6[Attribute] then
        return workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Attribute2 ~= Attribute;
    end;

    return false;
end;

local function isBotTarget(p48: userdata) -- Line: 194
    -- upvalues: IsSurvivalMode (copy), LocalPlayer (copy), u6 (copy)
    local v49 = p48:IsA("Model");

    if v49 then
        if p48:GetAttribute("Bot") == true and (p48:GetAttribute("Dead") ~= true and ((tonumber(p48:GetAttribute("Health")) or 1) > 0 and (p48:GetAttribute("ClientCharacterPresentationVisible") ~= false and p48.PrimaryPart ~= nil))) then
            local Attribute = p48:GetAttribute("Team");

            if IsSurvivalMode() then
                return false;
            end;

            local Attribute2 = LocalPlayer:GetAttribute("Team");

            if not (u6[Attribute2] and u6[Attribute]) then
                return false;
            end;

            v49 = workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Attribute2 ~= Attribute;
        else
            v49 = false;
        end;
    end;

    return v49;
end;

local function getTargetCandidates() -- Line: 206
    -- upvalues: IsSurvivalMode (copy), HordeController (copy), Players (copy), LocalPlayer (copy), u6 (copy), CharacterResolver (copy), Workspace (copy), isBotTarget (copy)
    if IsSurvivalMode() then
        return HordeController.GetLiveShells();
    end;

    local v50 = {};

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local Attribute = v:GetAttribute("Team");
            local v51;

            if IsSurvivalMode() then
                v51 = false;
            else
                local Attribute2 = LocalPlayer:GetAttribute("Team");

                if u6[Attribute2] and u6[Attribute] then
                    v51 = workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Attribute2 ~= Attribute;
                else
                    v51 = false;
                end;
            end;

            if v51 then
                local PlayerCharacter = CharacterResolver.getPlayerCharacter(v);

                if PlayerCharacter and (PlayerCharacter.PrimaryPart and CharacterResolver.isAliveCharacter(PlayerCharacter)) then
                    table.insert(v50, PlayerCharacter);
                end;
            end;
        end;
    end;

    local Characters = Workspace:FindFirstChild("Characters");

    if Characters then
        for _, child in ipairs(Characters:GetChildren()) do
            if isBotTarget(child) then
                table.insert(v50, child);
            end;
        end;
    end;

    return v50;
end;

local function getLocalRaycastParams() -- Line: 237
    -- upvalues: CharacterResolver (copy), Workspace (copy)
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    local v52 = {};
    local LocalCharacter = CharacterResolver.getLocalCharacter();

    if LocalCharacter then
        table.insert(v52, LocalCharacter);
    end;

    local Map = Workspace:FindFirstChild("Map");
    local v53;

    if Map then
        v53 = Map:FindFirstChild("Barriers");
    else
        v53 = nil;
    end;

    if v53 then
        table.insert(v52, v53);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v52;

    return RaycastParams_new_ret;
end;

local function isTargetVisible(p54: userdata, p55: vector) -- Line: 256
    -- upvalues: doesRaycastIntersectSmoke (copy), Workspace (copy), getLocalRaycastParams (copy)
    local Position = p54.PrimaryPart.Position;
    local Unit = (Position - p55).Unit;
    local Magnitude = (Position - p55).Magnitude;

    if doesRaycastIntersectSmoke(p55, Unit, Magnitude) then
        return false;
    end;

    local v56 = Workspace:Raycast(p55, Unit * Magnitude, (getLocalRaycastParams()));

    return v56 == nil and true or p54:IsAncestorOf(v56.Instance);
end;

local function findBestTarget(p57) -- Line: 272
    -- upvalues: u9 (ref), u8 (ref), getTargetCandidates (copy), PLAYER (copy), isTargetVisible (copy), u10 (ref)
    local os_clock_ret = os.clock();

    if os_clock_ret - u9 < 0.004166666666666667 then
        return u8;
    end;

    local v58 = 0;
    local v59 = nil;

    for _, v in ipairs(getTargetCandidates()) do
        local Position = v.PrimaryPart.Position;
        local Position2 = p57.Position;
        local Magnitude = (Position - Position2).Magnitude;

        if PLAYER.TargetSelection.MaxDistance >= Magnitude then
            local v60 = p57.LookVector:Dot((Position - Position2).Unit);
            local math_clamp_ret = math.clamp(v60, -1, 1);
            local math_acos_ret = math.acos(math_clamp_ret);

            if PLAYER.TargetSelection.MaxAngle >= math_acos_ret and isTargetVisible(v, Position2) then
                local v61 = 1 / (Magnitude + 1) * (1 - math_acos_ret / PLAYER.TargetSelection.MaxAngle);

                if v == u10 then
                    v61 = v61 * 1.6;
                end;

                if v58 < v61 then
                    v59 = v;
                    v58 = v61;
                end;
            end;
        end;
    end;

    u10 = v59;
    u8 = v59;
    u9 = os_clock_ret;

    return v59;
end;

local function calculateFrictionMultiplier(p62, p63: userdata?) -- Line: 320
    -- upvalues: PLAYER (copy), CurrentCamera (copy)
    if not p63 then
        return PLAYER.Friction.MaxSensitivity;
    end;

    local Position = p63.PrimaryPart.Position;
    local v64, v65 = CurrentCamera:WorldToViewportPoint(Position);

    if not v65 or v64.Z < 0 then
        return PLAYER.Friction.MaxSensitivity;
    end;

    local v66 = CurrentCamera.ViewportSize / 2;
    local Vector2_new_ret = Vector2.new(v66.X, v66.Y);
    local Magnitude = (Vector2.new(v64.X, v64.Y) - Vector2_new_ret).Magnitude;
    local Magnitude2 = (Position - p62.Position).Magnitude;
    local v67 = 2 / Magnitude2 * v66.Y * 2;
    local v68 = PLAYER.Friction.BubbleRadius * (v66.Y / Magnitude2) * 2;

    if v68 + v67 / 2 < Magnitude then
        return PLAYER.Friction.MaxSensitivity;
    end;

    local v69 = math.max(0, Magnitude - v67 / 2) / math.max(v68, 1);
    local math_clamp_ret = math.clamp(v69, 0, 1);
    local MinSensitivity = PLAYER.Friction.MinSensitivity;

    return MinSensitivity + (PLAYER.Friction.MaxSensitivity - MinSensitivity) * (math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2));
end;

local function isUsingController() -- Line: 361
    -- upvalues: UserInputService (copy)
    return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad;
end;

local function isAssistEnabled() -- Line: 370
    -- upvalues: u3 (copy), UserInputService (copy), u4 (ref), u5 (ref)
    if u3 or UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        return u4;
    end;

    if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
        return u5;
    end;

    return false;
end;

local function isFeatureActive(p70: boolean) -- Line: 381
    -- upvalues: u3 (copy), UserInputService (copy), u4 (ref), u5 (ref), FlashEffect (copy)
    if p70 then
        if u3 or UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            p70 = u4;
        elseif UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            p70 = u5;
        else
            p70 = false;
        end;

        if p70 then
            p70 = not FlashEffect.IsFlashed();
        end;
    end;

    return p70;
end;

local function canTarget() -- Line: 385
    -- upvalues: CurrentCamera (copy), CharacterResolver (copy)
    local v71;

    if CurrentCamera == nil then
        v71 = false;
    else
        v71 = CharacterResolver.getLocalCharacter() ~= nil;
    end;

    return v71;
end;

function u1.GetFrictionMultiplier() -- Line: 393
    -- upvalues: PLAYER (copy), u3 (copy), UserInputService (copy), u4 (ref), u5 (ref), FlashEffect (copy), CurrentCamera (copy), CharacterResolver (copy), calculateFrictionMultiplier (copy), findBestTarget (copy)
    local Enabled = PLAYER.Friction.Enabled;

    if Enabled then
        if u3 or UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            Enabled = u4;
        elseif UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            Enabled = u5;
        else
            Enabled = false;
        end;

        if Enabled then
            Enabled = not FlashEffect.IsFlashed();
        end;
    end;

    if Enabled then
        local v72;

        if CurrentCamera == nil then
            v72 = false;
        else
            v72 = CharacterResolver.getLocalCharacter() ~= nil;
        end;

        if v72 then
            local CFrame2 = CurrentCamera.CFrame;

            return calculateFrictionMultiplier(CFrame2, (findBestTarget(CFrame2)));
        end;
    end;

    return PLAYER.Friction.MaxSensitivity;
end;

local function findTargetWithRaycast(p73) -- Line: 405
    -- upvalues: PLAYER (copy), getLocalRaycastParams (copy), Workspace (copy), IsSurvivalMode (copy), HordeController (copy), doesRaycastIntersectSmoke (copy), isBotTarget (copy), CharacterResolver (copy), LocalPlayer (copy), u6 (copy)
    local Position = p73.Position;
    local MaxDistance = PLAYER.Magnetism.MaxDistance;
    local v74 = getLocalRaycastParams();
    local v75 = PLAYER.Magnetism.MaxAngleHorizontal / 2;
    local v76 = PLAYER.Magnetism.MaxAngleVertical / 2;

    for i = -1, 1 do
        local v77 = i;

        for i2 = -1, 1 do
            local LookVector = (p73 * CFrame.Angles(i2 * v76, v77 * v75, 0)).LookVector;
            local v78 = Workspace:Raycast(Position, LookVector * MaxDistance, v74);
            local v79;

            if v78 then
                local v80;

                if IsSurvivalMode() then
                    v80 = HordeController.GetLiveShell(v78.Instance);
                else
                    v80 = nil;
                end;

                if v80 then
                    local Magnitude = (v78.Position - Position).Magnitude;

                    if Magnitude <= MaxDistance and not doesRaycastIntersectSmoke(Position, LookVector, Magnitude) then
                        return v80;
                    end;

                    v79 = i2;
                else
                    local v81 = v78.Instance:FindFirstAncestorOfClass("Model");

                    if v81 then
                        v79 = i2;
                        local v82 = v81;

                        while true do
                            if not (v81 and v81:IsA("Model")) then
                                v81 = v82;
                                break;
                            end;

                            if v81:GetAttribute("Bot") == true then
                                break;
                            end;

                            v81 = v81.Parent;
                        end;

                        local v83 = isBotTarget(v81);

                        if not v83 and CharacterResolver.isPlayerCharacter(v81) then
                            local PlayerFromCharacter = CharacterResolver.getPlayerFromCharacter(v81);

                            if PlayerFromCharacter == nil then
                                v83 = false;
                            else
                                local Attribute = PlayerFromCharacter:GetAttribute("Team");

                                if IsSurvivalMode() then
                                    v83 = false;
                                else
                                    local Attribute2 = LocalPlayer:GetAttribute("Team");

                                    if u6[Attribute2] and u6[Attribute] then
                                        v83 = workspace:GetAttribute("Gamemode") == "Deathmatch" and true or Attribute2 ~= Attribute;
                                    else
                                        v83 = false;
                                    end;
                                end;

                                if v83 then
                                    v83 = CharacterResolver.isAliveCharacter(v81);
                                end;
                            end;
                        end;

                        if v83 then
                            local Magnitude = (v78.Position - Position).Magnitude;

                            if Magnitude <= MaxDistance and not doesRaycastIntersectSmoke(Position, LookVector, Magnitude) then
                                return v81;
                            end;
                        end;
                    else
                        v79 = i2;
                    end;
                end;
            else
                v79 = i2;
            end;
        end;
    end;

    return nil;
end;

local function calculateMagnetismRotation(p84, p85: userdata, p86: number) -- Line: 467
    -- upvalues: PLAYER (copy)
    if not p85.PrimaryPart then
        return Vector2.zero;
    end;

    local Position = p85.PrimaryPart.Position;
    local Position2 = p84.Position;
    local LookVector = p84.LookVector;

    if (Position - Position2).Magnitude > PLAYER.Magnetism.MaxDistance then
        return Vector2.zero;
    end;

    local Unit = (Position - Position2).Unit;
    local v87 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit:Dot(Vector3.new(Unit.X, 0, Unit.Z).Unit);
    local math_clamp_ret = math.clamp(v87, -1, 1);
    local math_acos_ret = math.acos(math_clamp_ret);

    if PLAYER.Magnetism.MaxAngleHorizontal < math_acos_ret or (math_acos_ret <= PLAYER.Magnetism.StopThreshold or math_acos_ret > 1.5707963267948966) then
        return Vector2.zero;
    end;

    local math_atan2_ret = math.atan2(-LookVector.X, -LookVector.Z);
    local v88 = math.atan2(-Unit.X, -Unit.Z) - math_atan2_ret;

    if v88 > 3.141592653589793 then
        v88 = v88 - 6.283185307179586;
    elseif v88 < -3.141592653589793 then
        v88 = v88 + 6.283185307179586;
    end;

    local math_abs_ret = math.abs(v88);

    if math_abs_ret < 0.001 then
        return Vector2.zero;
    end;

    local math_min_ret = math.min(PLAYER.Magnetism.PullStrength * p86, math_abs_ret);

    return Vector2.new((v88 > 0 and 1 or -1) * math_min_ret, 0);
end;

local function calculateVerticalMagnetismRotation(p89, p90: userdata, p91: number, p92: boolean) -- Line: 521
    -- upvalues: PLAYER (copy)
    local Head = p90:FindFirstChild("Head");

    if not Head then
        return 0;
    end;

    local Position = Head.Position;
    local VerticalMagnetism = PLAYER.VerticalMagnetism;
    local Position2 = p89.Position;

    if (Position - Position2).Magnitude > VerticalMagnetism.MaxDistance then
        return 0;
    end;

    local Unit = (Position - Position2).Unit;
    local math_clamp_ret = math.clamp(p89.LookVector.Y, -1, 1);
    local math_asin_ret = math.asin(math_clamp_ret);
    local math_clamp_ret2 = math.clamp(Unit.Y, -1, 1);
    local v93 = math.asin(math_clamp_ret2) - math_asin_ret;
    local math_abs_ret = math.abs(v93);

    if not p92 and VerticalMagnetism.MaxAngleVertical < math_abs_ret then
        return 0;
    end;

    if math_abs_ret <= VerticalMagnetism.StopThreshold or math_abs_ret < 0.001 then
        return 0;
    end;

    local math_min_ret = math.min(VerticalMagnetism.PullStrength * p91, math_abs_ret);

    return (v93 > 0 and 1 or -1) * math_min_ret;
end;

local function getYawPitch(p94: vector) -- Line: 565
    local math_atan2_ret = math.atan2(-p94.X, -p94.Z);
    local math_clamp_ret = math.clamp(p94.Y, -1, 1);

    return math_atan2_ret, math.asin(math_clamp_ret);
end;

local function wrapAngle(p95: number) -- Line: 569
    return (p95 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;
end;

local function getStickActivity() -- Line: 574
    -- upvalues: UserInputService (copy)
    local v96 = 0;

    for _, v in UserInputService:GetConnectedGamepads() do
        for _, v3 in UserInputService:GetGamepadState(v) do
            if v3.KeyCode == Enum.KeyCode.Thumbstick1 or v3.KeyCode == Enum.KeyCode.Thumbstick2 then
                local Magnitude = Vector2.new(v3.Position.X, v3.Position.Y).Magnitude;
                v96 = math.max(v96, Magnitude);
            end;
        end;
    end;

    return math.clamp((v96 - 0.15) / 0.85 * 1.5, 0, 1);
end;

local function getAimPoint(p97: userdata) -- Line: 589
    local PrimaryPart = p97.PrimaryPart;

    if not PrimaryPart then
        return nil;
    end;

    local Head = p97:FindFirstChild("Head");

    if Head and Head:IsA("BasePart") then
        return PrimaryPart.Position:Lerp(Head.Position, 0.6);
    end;

    return PrimaryPart.Position;
end;

local function calculateControllerMagnetism(p98, p99: userdata, p100: number) -- Line: 602
    -- upvalues: u7 (copy), u11 (ref), PLAYER (copy), getStickActivity (copy), u12 (ref), u13 (ref)
    local PrimaryPart = p99.PrimaryPart;
    local v101;

    if PrimaryPart then
        local Head = p99:FindFirstChild("Head");

        if Head and Head:IsA("BasePart") then
            v101 = PrimaryPart.Position:Lerp(Head.Position, u7.AimHeight);
        else
            v101 = PrimaryPart.Position;
        end;
    else
        v101 = nil;
    end;

    if not v101 then
        u11 = nil;

        return Vector2.zero;
    end;

    local v102 = v101 - p98.Position;
    local Magnitude = v102.Magnitude;

    if Magnitude < 1 or PLAYER.Magnetism.MaxDistance < Magnitude then
        u11 = nil;

        return Vector2.zero;
    end;

    local v103 = v102 / Magnitude;
    local math_atan2_ret = math.atan2(-v103.X, -v103.Z);
    local math_clamp_ret = math.clamp(v103.Y, -1, 1);
    local math_asin_ret = math.asin(math_clamp_ret);
    local LookVector = p98.LookVector;
    local math_atan2_ret2 = math.atan2(-LookVector.X, -LookVector.Z);
    local math_clamp_ret2 = math.clamp(LookVector.Y, -1, 1);
    local math_asin_ret2 = math.asin(math_clamp_ret2);
    local v104 = p98.LookVector:Dot(v103);
    local math_clamp_ret3 = math.clamp(v104, -1, 1);
    local math_acos_ret = math.acos(math_clamp_ret3);
    local v105 = getStickActivity();
    local v106 = 0;
    local v107 = 0;

    if u11 == p99 and math_acos_ret < 0.12217304763960307 then
        local v108 = (math_atan2_ret - u12 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;
        local v109 = math_asin_ret - u13;
        local v110 = 3 * p100;

        if math.abs(v108) < v110 and math.abs(v109) < v110 then
            local v111 = 0.55 * v105 * (1 - math_acos_ret / 0.12217304763960307);
            v106 = v108 * v111;
            v107 = v109 * v111;
        end;
    end;

    u11 = p99;
    u12 = math_atan2_ret;
    u13 = math_asin_ret;
    local v112, v113;

    if math_acos_ret > 0.002617993877991494 and math_acos_ret < 0.17453292519943295 then
        local v114 = (1 - math.exp(-3.2 * p100)) * (1 - (math_acos_ret / 0.17453292519943295) ^ 2) * (0.25 + 0.75 * v105);
        v112 = ((math_atan2_ret - math_atan2_ret2 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v114;
        v113 = (math_asin_ret - math_asin_ret2) * v114;
        local math_sqrt_ret = math.sqrt(v112 * v112 + v113 * v113);
        local v115 = 0.5235987755982988 * p100;

        if v115 < math_sqrt_ret then
            v112 = v112 * v115 / math_sqrt_ret;
            v113 = v113 * v115 / math_sqrt_ret;
        end;
    else
        v112 = 0;
        v113 = 0;
    end;

    return Vector2.new(v112 + v106, v113 + v107);
end;

function u1.GetMagnetismRotation(p116: number?) -- Line: 656
    -- upvalues: PLAYER (copy), u3 (copy), UserInputService (copy), u4 (ref), u5 (ref), FlashEffect (copy), CurrentCamera (copy), CharacterResolver (copy), u11 (ref), findBestTarget (copy), findTargetWithRaycast (copy), calculateControllerMagnetism (copy), calculateMagnetismRotation (copy), calculateVerticalMagnetismRotation (copy)
    local Enabled = PLAYER.Magnetism.Enabled;

    if Enabled then
        if u3 or UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            Enabled = u4;
        elseif UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            Enabled = u5;
        else
            Enabled = false;
        end;

        if Enabled then
            Enabled = not FlashEffect.IsFlashed();
        end;
    end;

    if Enabled then
        local v117;

        if CurrentCamera == nil then
            v117 = false;
        else
            v117 = CharacterResolver.getLocalCharacter() ~= nil;
        end;

        if v117 then
            local v118 = p116 or 0.016666666666666666;
            local CFrame2 = CurrentCamera.CFrame;
            local v119 = findBestTarget(CFrame2) or findTargetWithRaycast(CFrame2);

            if not v119 then
                u11 = nil;

                return Vector2.zero;
            end;

            if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                return calculateControllerMagnetism(CFrame2, v119, v118);
            end;

            u11 = nil;
            local v120 = calculateMagnetismRotation(CFrame2, v119, v118);
            local v121 = math.abs(v120.X) > 0.0001;
            local v122 = not PLAYER.VerticalMagnetism.Enabled and 0 or calculateVerticalMagnetismRotation(CFrame2, v119, v118, v121);

            return Vector2.new(v120.X, v122);
        end;
    end;

    u11 = nil;

    return Vector2.zero;
end;

function u1.GetRecoilAssistMultiplier() -- Line: 691
    -- upvalues: PLAYER (copy), u3 (copy), UserInputService (copy), u4 (ref), u5 (ref), FlashEffect (copy), CurrentCamera (copy), CharacterResolver (copy), findBestTarget (copy)
    local Enabled = PLAYER.RecoilAssist.Enabled;

    if Enabled then
        if u3 or UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            Enabled = u4;
        elseif UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            Enabled = u5;
        else
            Enabled = false;
        end;

        if Enabled then
            Enabled = not FlashEffect.IsFlashed();
        end;
    end;

    if not Enabled then
        return 0;
    end;

    if PLAYER.RecoilAssist.RequiresTarget then
        local v123;

        if CurrentCamera == nil then
            v123 = false;
        else
            v123 = CharacterResolver.getLocalCharacter() ~= nil;
        end;

        if not (v123 and findBestTarget(CurrentCamera.CFrame)) then
            return 0;
        end;
    end;

    return PLAYER.RecoilAssist.ReductionAmount;
end;

function u1.GetRecoilAssistScale() -- Line: 705
    -- upvalues: u1 (copy), u3 (copy), PLAYER (copy)
    local RecoilAssistMultiplier = u1.GetRecoilAssistMultiplier();

    if RecoilAssistMultiplier <= 0 then
        return Vector3.new(1, 1, 1);
    end;

    local v124;

    if u3 then
        v124 = math.max(RecoilAssistMultiplier, PLAYER.RecoilAssist.HorizontalReductionAmount);
    else
        v124 = RecoilAssistMultiplier;
    end;

    return Vector3.new(1 - RecoilAssistMultiplier, 1 - v124, 1);
end;

local u125 = false;

function u1.Initialize() -- Line: 727
    -- upvalues: u125 (ref), DataController (copy), LocalPlayer (copy), u4 (ref), u5 (ref)
    if u125 then
        return;
    end;

    u125 = true;
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Mobile Aim Assist", function(p126: boolean?) -- Line: 733
        -- upvalues: u4 (ref)
        u4 = p126 ~= false;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Controller Aim Assist", function(p127: boolean?) -- Line: 736
        -- upvalues: u5 (ref)
        u5 = p127 ~= false;
    end);
end;

return u1;