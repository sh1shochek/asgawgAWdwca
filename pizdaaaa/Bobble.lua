-- ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel.Classes.Bobble
-- Script path: ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel.Classes.Bobble
-- Decompile time: 11.18 ms

-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Spring = require(ReplicatedStorage.Shared.Spring);
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics);
local SpeedProfile = require(ReplicatedStorage.MovementV2.SpeedProfile);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local IsSurvivalMode = require(ReplicatedStorage.Components.Common.IsSurvivalMode);
local LocalFootsteps = require(ReplicatedStorage.Components.Common.LocalFootsteps);
local workspace_CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local u2 = Vector2.new(0.02, 0.015) / 50;
local Vector2_new_ret = Vector2.new(0.68, 7);
local Vector2_new_ret2 = Vector2.new(1, 9);
local Vector2_new_ret3 = Vector2.new(1, 18);
local Vector2_new_ret4 = Vector2.new(5, 3.5);
local u3 = {
    Primary = {
        Hand = Vector3.new(0.002, -0.25, -0.343),
        Rotation = Vector3.new(0, 55, 20),
        Bob = 1,
        Pump = 0
    },
    Secondary = {
        Hand = Vector3.new(0.023, -0.14, -0.239),
        Rotation = Vector3.new(-5, 30, 15),
        Bob = 1.1,
        Pump = 0.35
    },
    Melee = {
        Hand = Vector3.new(0.051, -0.118, -0.303),
        Rotation = Vector3.new(-5, 30, 15),
        Bob = 1.25,
        Pump = 1
    },
    Grenade = {
        Hand = Vector3.new(0.056, -0.165, -0.217),
        Rotation = Vector3.new(-5, 30, 15),
        Bob = 1.15,
        Pump = 0.6
    },
    C4 = {
        Hand = Vector3.new(0.023, -0.14, -0.239),
        Rotation = Vector3.new(-5, 30, 15),
        Bob = 1.1,
        Pump = 0.4
    }
};
local Primary = u3.Primary;
local u4 = setmetatable({}, {
    __mode = "k"
});

local function recordSprintState(p5: userdata, p6: number, p7: number, p8: number) -- Line: 106
    -- upvalues: u4 (copy)
    local v9 = u4[p5];

    if not v9 then
        u4[p5] = {
            Alpha = p6,
            Phase = p7,
            At = p8
        };

        return;
    end;

    v9.Alpha = p6;
    v9.Phase = p7;
    v9.At = p8;
end;

local u10 = {};
local u11 = IsSurvivalMode();
workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 121
    -- upvalues: u11 (ref), IsSurvivalMode (copy)
    u11 = IsSurvivalMode();
end);

local function removeY(p12: vector) -- Line: 133
    return p12 * Vector3.new(1, 0, 1);
end;

local function toVector3(p13) -- Line: 137
    return Vector3.new(p13.X, p13.Y, 0);
end;

local function degreesToCFrame(p14: vector) -- Line: 141
    return CFrame.Angles(math.rad(p14.X), math.rad(p14.Y), (math.rad(p14.Z)));
end;

local function aboutPivot(p15: vector, p16: vector) -- Line: 145
    return CFrame.new(p15) * CFrame.Angles(math.rad(p16.X), math.rad(p16.Y), (math.rad(p16.Z))) * CFrame.new(-p15);
end;

local function setSpringResponse(p17: any, p18) -- Line: 149
    p17:setDampingRatio(p18.X);
    p17:setFrequency(p18.Y);
end;

local function toggleScopeVisibility(p19: userdata, p20: boolean) -- Line: 154
    for _, descendant in pairs(p19:GetDescendants()) do
        if descendant:IsA("MeshPart") then
            descendant.Transparency = p20 == true and 0 or 1;
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = p20;
        end;
    end;
end;

local function applySkinToScope(p21: userdata, p22: userdata) -- Line: 164
    if p21.ClassName ~= "Model" or p22.ClassName ~= "Model" then
        return;
    end;

    local function clearSurfaceAppearances(p23: userdata) -- Line: 167
        for _, child in pairs(p23:GetChildren()) do
            if child.ClassName == "SurfaceAppearance" then
                child:Destroy();
            end;
        end;
    end;

    for _, child in pairs(p21:GetChildren()) do
        local v24 = p22:FindFirstChild(child.Name);

        if v24 then
            local v25 = v24:FindFirstChildWhichIsA("SurfaceAppearance");

            if v25 then
                local v26 = v25:Clone();
                v26.Name = v24.Name;
                clearSurfaceAppearances(child);
                v26.Parent = child;
            end;
        end;
    end;
end;

function u1.addScopeKick(p27) -- Line: 190
    if p27.IsDestroyed or not p27.ScopeSpring then
        return;
    end;

    p27.ScopeSpring:impulse(Vector2.new(5, 1));
end;

function u1.getMovementVelocity(p28) -- Line: 199
    -- upvalues: RuntimeKinematics (copy), workspace_CurrentCamera (copy)
    local Character = p28.Character;

    if not Character then
        p28.IsInAir = false;

        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v29, _, _, _, v30 = RuntimeKinematics.resolve(Character, Character.PrimaryPart);
    p28.IsInAir = not v30;

    if v29.Magnitude <= 0.1 then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v31 = v29.Unit * math.min(v29.Magnitude, 50);

    return v31, workspace_CurrentCamera.CFrame:VectorToObjectSpace(v31);
end;

function u1.wantsSprintGrip(p32) -- Line: 218
    -- upvalues: u11 (ref)
    local v33 = u11 and not p32.IsDestroyed;

    if v33 then
        if p32.SprintSpring:getGoal() == 0 then
            local Position = p32.SprintSpring:getPosition();
            v33 = math.abs(Position) < 0.001;
        else
            v33 = false;
        end;
    end;

    return v33;
end;

function u1.setSprintGrip(p34: any, p35: vector) -- Line: 225
    -- upvalues: u10 (copy)
    p34.SprintPivot = p35;
    u10[p34.SprintWeaponName] = p35;
end;

function u1.getSprintCFrame(p36: any, p37: number, p38: number, p39: boolean) -- Line: 234
    -- upvalues: u4 (copy), SpeedProfile (copy), Vector2_new_ret3 (copy), Vector2_new_ret (copy), Vector2_new_ret2 (copy), LocalFootsteps (copy), Vector2_new_ret4 (copy)
    local os_clock_ret = os.clock();
    local Character = p36.Character;
    local v40;

    if Character then
        v40 = u4[Character];
    else
        v40 = Character;
    end;

    if os_clock_ret - p36.SprintRenderedAt > 0.25 and (v40 and os_clock_ret - v40.At <= 0.25) then
        p36.SprintSpring:reset(v40.Alpha);
        p36.SprintPhase = v40.Phase;
    end;

    p36.SprintRenderedAt = os_clock_ret;

    if p39 or p36.IsAiming then
        p36.SprintBlockedUntil = os_clock_ret + 0.35;
    end;

    local v41 = os_clock_ret < p36.SprintBlockedUntil;
    local math_max_ret = math.max(p36.SprintRunSpeed, 1);
    local v42 = math_max_ret * 1.04;
    local math_max_ret2 = math.max(math_max_ret + (SpeedProfile.SprintSpeed - math_max_ret) * 0.75, v42 + 0.5);
    local v43 = (v41 or v42 >= p38) and 0 or math.clamp((p38 - v42) / (math_max_ret2 - v42), 0, 1);
    local SprintSpring = p36.SprintSpring;
    local Goal = SprintSpring:getGoal();

    if v41 then
        local v44 = Vector2_new_ret3;
        SprintSpring:setDampingRatio(v44.X);
        SprintSpring:setFrequency(v44.Y);
    elseif Goal < v43 then
        local v45 = Vector2_new_ret;
        SprintSpring:setDampingRatio(v45.X);
        SprintSpring:setFrequency(v45.Y);
    elseif v43 < Goal then
        local v46 = Vector2_new_ret2;
        SprintSpring:setDampingRatio(v46.X);
        SprintSpring:setFrequency(v46.Y);
    end;

    SprintSpring:setGoal(v43);
    SprintSpring:update(p37);
    p36.SprintGroundSpring:setGoal(p36.IsInAir and 0.25 or 1);
    p36.SprintGroundSpring:update(p37);
    local Position = SprintSpring:getPosition();

    if v43 == 0 and math.abs(Position) < 0.001 then
        p36.SprintPhase = 0;

        if Character then
            local v47 = u4[Character];

            if v47 then
                v47.Alpha = 0;
                v47.Phase = 0;
                v47.At = os_clock_ret;
            else
                u4[Character] = {
                    Alpha = 0,
                    Phase = 0,
                    At = os_clock_ret
                };
            end;
        end;

        return CFrame.identity;
    end;

    if p36.FollowsLocalStride then
        p36.SprintPhase = LocalFootsteps.getPhase() * 0.5;
    elseif not p36.IsInAir then
        p36.SprintPhase = (p36.SprintPhase + p37 * p38 * 0.06) % 1;
    end;

    if Character then
        local SprintPhase = p36.SprintPhase;
        local v48 = u4[Character];

        if v48 then
            v48.Alpha = Position;
            v48.Phase = SprintPhase;
            v48.At = os_clock_ret;
        else
            u4[Character] = {
                Alpha = Position,
                Phase = SprintPhase,
                At = os_clock_ret
            };
        end;
    end;

    p36.SprintNoiseTime = p36.SprintNoiseTime + p37 * 0.8;
    local SprintPose = p36.SprintPose;
    local v49 = p36.SprintPhase * 3.141592653589793 * 2;
    local math_sin_ret = math.sin(v49);
    local v50 = math.abs(math_sin_ret) - 0.5;
    local math_sin_ret2 = math.sin(v49 - 0.6);
    local v51 = math.sin(v49 - 0.3) * SprintPose.Pump;
    local v52 = math.max(Position, 0) * SprintPose.Bob * p36.SprintGroundSpring:getPosition();
    local SprintNoiseTime = p36.SprintNoiseTime;
    local SprintNoiseSeed = p36.SprintNoiseSeed;
    local math_noise_ret = math.noise(SprintNoiseTime, 0.5, SprintNoiseSeed);
    local math_noise_ret2 = math.noise(SprintNoiseTime, 7.5, SprintNoiseSeed);
    local v53 = Vector3.new(math_noise_ret, math_noise_ret2, math.noise(SprintNoiseTime, 13.5, SprintNoiseSeed)) * 2 * Vector3.new(1.2, 1, 1.5);
    local v54 = Vector3.new(math_sin_ret * 0.03, v50 * 0.033, v51 * 0.018) * v52;
    local v55 = (Vector3.new(v50 * 2.5 + v51 * 9, math_sin_ret2 * Vector2_new_ret4.X, math_sin_ret2 * Vector2_new_ret4.Y) + v53) * v52;
    local SprintPivot = p36.SprintPivot;
    local CFrame_new_ret = CFrame.new((SprintPose.Hand - SprintPivot) * Position + v54);
    local v56 = SprintPose.Rotation * Position + v55;

    return CFrame_new_ret * (CFrame.new(SprintPivot) * CFrame.Angles(math.rad(v56.X), math.rad(v56.Y), (math.rad(v56.Z))) * CFrame.new(-SprintPivot));
end;

function u1.getNextCFrame(p57: any, p58: number, p59: boolean?) -- Line: 323
    -- upvalues: workspace_CurrentCamera (copy), u2 (copy), u11 (ref)
    if p57.IsDestroyed then
        return CFrame.identity, Vector3.new(0, 0, 0), Vector3.new(0, 0, 0);
    end;

    local v60 = (p58 <= 0 or p58 ~= p58) and 0.016666666666666666 or p58;
    local MovementVelocity, v61 = p57:getMovementVelocity();
    local v62 = v61 * Vector3.new(1, 0, 1);
    local Magnitude = MovementVelocity.Magnitude;
    local Magnitude2 = (MovementVelocity * Vector3.new(1, 0, 1)).Magnitude;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local v63, v64, _ = CFrame2:ToObjectSpace(p57.LastCameraCFrame):ToOrientation();
    local v65 = Vector2.new(v63, v64) / v60;
    local v66 = p57.RenderTime + v60 * Magnitude * 0.1;
    local v67 = Vector3.new(0.0011111111, 0.0011111111, 0) * Vector3.new(v65.Y, -v65.X, 0);
    local X = v62.X;
    local math_abs_ret = math.abs(v62.X);
    local math_abs_ret2 = math.abs(v61.Z);
    local math_max_ret = math.max(math_abs_ret, math_abs_ret2);
    local v68 = Vector3.new(0.0004, 0.0007, 0.0011) * Vector3.new(X, -Magnitude2, math_max_ret);
    local v69 = Vector2.new(math.sin(v66 * 3.141592653589793 * 2), (math.sin(v66 * 3.141592653589793 * 4))) * (u2 * 0.5) * Magnitude2;

    if p57.IsInAir then
        v68 = v68 + Vector3.new(0, -0.02, 0);
        v69 = v69 * 0.3;
    end;

    local CFrame_identity = CFrame.identity;

    if u11 then
        CFrame_identity = p57:getSprintCFrame(v60, Magnitude2, p59 == true);
        local Position = p57.SprintSpring:getPosition();
        v69 = v69 * (1 - math.clamp(Position, 0, 1) * 0.6);
    end;

    p57.MovementShiftSpring:setGoal(v68);
    p57.CameraShiftSpring:setGoal(v67 ~= v67 and Vector3.new(0, 0, 0) or v67);
    p57.BobbleSpring:setGoal(v69);
    p57.ScopeSpring:setGoal(Vector2.zero);
    p57.LowerSpring:setGoal(p57.IsLowered and 1 or 0);
    p57.MovementShiftSpring:update(v60);
    p57.CameraShiftSpring:update(v60);
    p57.BobbleSpring:update(v60);
    p57.ScopeSpring:update(v60);
    p57.LowerSpring:update(v60);
    p57.LastCameraCFrame = CFrame2;
    p57.RenderTime = v66;
    local Position = p57.MovementShiftSpring:getPosition();
    local Position2 = p57.CameraShiftSpring:getPosition();
    local Position3 = p57.BobbleSpring:getPosition();
    local Vector3_new_ret = Vector3.new(Position3.X, Position3.Y, 0);
    local Position4 = p57.ScopeSpring:getPosition();
    local math_rad_ret = math.rad(-Position.X * 250);
    local v70;

    if p57.IsAiming then
        v70 = 0.08726646259971647;
        math_rad_ret = 0;
    else
        v70 = 0;
    end;

    local Vector3_new_ret2 = Vector3.new(Position4.X, Position4.Y, 0);

    return CFrame_identity * CFrame.new(Position + Position2 + Vector3_new_ret) * CFrame.Angles(0, v70, math_rad_ret), Vector3_new_ret + Position, Vector3_new_ret2;
end;

function u1.getLowered(p71) -- Line: 414
    return p71.LowerSpring:getPosition();
end;

function u1.setIsAiming(p72: any, p73: boolean) -- Line: 420
    -- upvalues: toggleScopeVisibility (copy)
    p72.IsAiming = p73;
    toggleScopeVisibility(p72.Scope, p73);
    toggleScopeVisibility(p72.ScopeReticlePart, p73);
end;

function u1.setLowered(p74: any, p75: boolean, p76: boolean?) -- Line: 429
    if p74.IsDestroyed then
        return;
    end;

    p74.IsLowered = p75;

    if p76 then
        p74.LowerSpring:reset(p75 and 1 or 0);
    end;
end;

function u1.setModel(p77: any, p78: userdata) -- Line: 442
    -- upvalues: GetWeaponProperties (copy), u3 (copy), Primary (copy), SpeedProfile (copy), u10 (copy), workspace_CurrentCamera (copy), toggleScopeVisibility (copy), applySkinToScope (copy)
    if not p78 then
        return;
    end;

    if p77.Scope then
        p77.Scope:Destroy();
        p77.Scope = nil;
    end;

    if p77.ScopeReticlePart then
        p77.ScopeReticlePart:Destroy();
        p77.ScopeReticlePart = nil;
    end;

    local Name = p78.Name;
    local v79 = GetWeaponProperties(Name);
    p77.SprintPose = v79 and u3[v79.Slot] or Primary;

    if v79 then
        v79 = v79.WalkSpeed;
    end;

    p77.SprintRunSpeed = SpeedProfile.resolveWeaponSpeeds(Name, v79);
    p77.SprintWeaponName = Name;
    p77.SprintPivot = u10[Name] or Vector3.new(0.13, -0.14, -0.24);

    if Name == "AUG" or Name == "SG 553" then
        local Weapon = p78:FindFirstChild("Weapon");

        if Weapon and Weapon:FindFirstChild("ScopeSplit") then
            local ScopeSplit = Weapon.ScopeSplit;
            local Part = ScopeSplit:FindFirstChild("Part");

            if Part then
                p77.ScopeReticlePart = p77.Janitor:Add(Part:Clone());
                p77.ScopeReticlePart.Parent = workspace_CurrentCamera;
            end;

            local v80 = p77.Janitor:Add(ScopeSplit:Clone());
            p77.Scope = v80;
            v80.Parent = workspace_CurrentCamera;
            toggleScopeVisibility(v80, false);

            if Name == "AUG" then
                local Part2 = v80:FindFirstChild("Part");

                if Part2 then
                    Part2 = Part2:FindFirstChild("SurfaceGui");
                end;

                if Part2 then
                    Part2 = Part2:FindFirstChild("Frame");
                end;

                if Part2 then
                    Part2.Visible = false;
                end;
            end;

            applySkinToScope(v80, Weapon);
            ScopeSplit:Destroy();
        end;
    end;
end;

function u1.new(p81) -- Line: 497
    -- upvalues: u1 (copy), Janitor (copy), CharacterResolver (copy), Spring (copy), Vector2_new_ret2 (copy), Primary (copy), SpeedProfile (copy), workspace_CurrentCamera (copy), LocalPlayer (copy)
    local u82 = setmetatable({}, u1);
    u82.Janitor = Janitor.new();
    u82.IsDestroyed = false;
    u82.Character = p81.Character or CharacterResolver.getPlayerCharacter(p81.Player);
    u82.IsAiming = false;
    u82.CameraShiftSpring = Spring.new(0.7, 18, Vector3.new(0, 0, 0));
    u82.MovementShiftSpring = Spring.new(1, 15, Vector3.new(0, 0, 0));
    u82.BobbleSpring = Spring.new(1, 20, Vector2.zero);
    u82.ScopeSpring = Spring.new(1, 20, Vector2.zero);
    u82.SprintSpring = Spring.new(Vector2_new_ret2.X, Vector2_new_ret2.Y, 0);
    u82.SprintGroundSpring = Spring.new(1, 12, 1);
    u82.LowerSpring = Spring.new(1, 12, 0);
    u82.SprintPose = Primary;
    u82.SprintPivot = Vector3.new(0.13, -0.14, -0.24);
    u82.SprintWeaponName = "";
    u82.SprintRunSpeed = SpeedProfile.DefaultBaseSpeed;
    u82.SprintPhase = 0;
    u82.SprintBlockedUntil = 0;
    u82.SprintNoiseTime = 0;
    u82.SprintNoiseSeed = Random.new():NextNumber(0, 1000);
    u82.SprintRenderedAt = (-1 / 0);
    u82.FollowsLocalStride = false;
    u82.LastCameraCFrame = workspace_CurrentCamera.CFrame;
    u82.RenderTime = 0;
    u82.IsInAir = false;
    u82.IsLowered = false;

    if not p81.Character then
        u82.Janitor:Add(CharacterResolver.observeCharacter(p81.Player, function(p83) -- Line: 543
            -- upvalues: u82 (copy)
            u82.Character = p83;

            return function() -- Line: 545
            end;
        end));
        u82.FollowsLocalStride = p81.Player == LocalPlayer;
    end;

    return u82;
end;

function u1.destroy(p84) -- Line: 558
    if p84.IsDestroyed then
        return;
    end;

    p84.IsDestroyed = true;
    p84.Janitor:Destroy();
    p84.Janitor = nil;
    p84.CameraShiftSpring = nil;
    p84.MovementShiftSpring = nil;
    p84.BobbleSpring = nil;
    p84.ScopeSpring = nil;
    p84.SprintSpring = nil;
    p84.SprintGroundSpring = nil;
    p84.LowerSpring = nil;
    p84.Character = nil;
    p84.Scope = nil;
    p84.ScopeReticlePart = nil;
end;

return u1;