-- CharacterAnimator (ModuleScript)
-- full path: ReplicatedStorage.Classes.Character.Classes.CharacterAnimator

-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
local SurvivalDowned = require(ReplicatedStorage.Components.Common.SurvivalDowned);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local CharacterAnimations = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("CharacterAnimations");
local u1 = {};
u1.__index = u1;
local u2 = {
    ["Add Suppressor"] = "AddSuppressor",
    ["Remove Suppressor"] = "RemoveSuppressor",
    ["Switch Fire Mode"] = "Switch"
};
local u3 = {
    FR = "ForwardRight",
    FL = "ForwardLeft",
    F = "Forward",
    BR = "BackwardRight",
    BL = "BackwardLeft",
    B = "Backward",
    R = "Right",
    L = "Left"
};
local u4 = nil;

local function getMovementAnimationNames() -- Line: 73
    -- upvalues: u4 (ref), CharacterAnimations (copy)
    if u4 then
        return u4;
    end;

    local v5 = {
        CharacterIdle = true
    };

    for _, v in ipairs({ "Crouch", "Movement" }) do
        local v6 = CharacterAnimations:FindFirstChild(v);

        if v6 then
            for _, descendant in ipairs(v6:GetDescendants()) do
                if descendant:IsA("Animation") then
                    v5[descendant.Name] = true;
                end;
            end;
        end;
    end;

    u4 = v5;

    return v5;
end;

function u1.play(p7: any, p8: string, ...) -- Line: 97
    local v9 = p7.Animations[p8];

    if v9 then
        v9:Play(...);
    end;

    return v9;
end;

function u1.stop(p10: any, p11: string, ...) -- Line: 106
    local v12 = p10.Animations[p11];

    if v12 and v12.IsPlaying then
        v12:Stop(...);
    end;
end;

function u1.setBlinded(p13: any, p14: boolean) -- Line: 115
    local Blinded = p13.Animations.Blinded;

    if not Blinded then
        return;
    end;

    if p14 then
        if not Blinded.Looped then
            Blinded.Looped = true;
        end;

        if not Blinded.IsPlaying then
            Blinded:Play(0.2);
        end;
    elseif Blinded.IsPlaying then
        Blinded:Stop(0.2);
    end;
end;

function u1.setDowned(u15: any, p16: boolean) -- Line: 142
    -- upvalues: SurvivalDowned (copy), RunService (copy)
    if p16 == (u15.DownedConnection ~= nil) or u15.IsDestroyed then
        return;
    end;

    local PoseJoints = SurvivalDowned.GetPoseJoints(u15.Character);

    if not p16 then
        u15.DownedConnection:Disconnect();
        u15.DownedConnection = nil;

        for _, v in PoseJoints do
            v.Transform = CFrame.identity;
        end;

        local Idle = u15.Animations.Idle;

        if Idle and not Idle.IsPlaying then
            Idle:Play(0.2);
        end;

        return;
    end;

    u15:stopAnimations(0.2, "Idle");
    local Idle = u15.Animations.Idle;

    if Idle and not Idle.IsPlaying then
        Idle:Play(0.2);
    end;

    local u17 = {};
    local u18 = {};
    local u19 = {};

    for i, v in PoseJoints do
        u17[i] = v.Part1.Name;
        u18[i] = v.Transform;
        u19[i] = v.Transform;
    end;

    local RightHand = u15.Character:FindFirstChild("RightHand");
    local os_clock_ret = os.clock();
    u15.DownedConnection = RunService.PreSimulation:Connect(function(p20: number) -- Line: 176
        -- upvalues: u15 (copy), SurvivalDowned (ref), os_clock_ret (copy), PoseJoints (copy), u17 (copy), u19 (copy), u18 (copy), RightHand (copy)
        local DownedAimPitch = u15.DownedAimPitch;
        local v21;

        if DownedAimPitch and u15.WeaponSlot == SurvivalDowned.LAST_STAND_SLOT then
            v21 = SurvivalDowned.GetAimPose(DownedAimPitch);
        else
            v21 = nil;
        end;

        local v22 = (os.clock() - os_clock_ret) / 0.35;
        local math_clamp_ret = math.clamp(v22, 0, 1);
        local v23 = 1 - math.exp(p20 * -12);

        for i, v in PoseJoints do
            local v24 = u17[i];
            local v25 = v21 and v21[v24] or SurvivalDowned.POSE[v24];
            local v26;

            if math_clamp_ret < 1 then
                v26 = u18[i]:Lerp(v25, math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2));
            else
                v26 = u19[i]:Lerp(v25, v23);
            end;

            u19[i] = v26;
            v.Transform = u19[i];
        end;

        local v27;

        if v21 and RightHand then
            v27 = RightHand:FindFirstChild("WeaponAttachment");
        else
            v27 = nil;
        end;

        if v27 and v27:IsA("Motor6D") then
            v27.Transform = CFrame.identity;
        end;
    end);
end;

function u1.setDownedAim(p28: any, p29: number?) -- Line: 202
    p28.DownedAimPitch = p29;
end;

function u1.stopAnimations(p30: any, p31: number?, p32: string?) -- Line: 207
    for i, v in pairs(p30.Animations) do
        if v.IsPlaying and i ~= p32 then
            v:Stop(p31 or 0);
        end;
    end;

    p30.CurrentMovementAnimation = nil;
    p30.LastMovementAnimationSpeed = nil;
    p30.IsJumping = false;
end;

function u1.freezeAnimations(p33) -- Line: 219
    for _, v in pairs(p33.Animations) do
        if v.IsPlaying then
            v:AdjustSpeed(0);
        end;
    end;
end;

function u1.adjustAnimationSpeed(p34: any, p35: string, p36: number) -- Line: 227
    local v37 = p34.Animations[p35];

    if v37 then
        v37:AdjustSpeed(v37.Length / p36);
    end;
end;

function u1.unregister(p38: any, p39: string) -- Line: 234
    local v40 = p38.Animations[p39];

    if not v40 then
        return;
    end;

    if v40.IsPlaying then
        v40:Stop();
    end;

    p38.Animations[p39] = nil;
    p38.WeaponAnimationNames[p39] = nil;
    v40:Destroy();
end;

function u1.register(p41: any, p42: string, p43: userdata) -- Line: 248
    local Animator = p41.Animator;

    if not Animator then
        return;
    end;

    p41:unregister(p42);
    local success, result = pcall(Animator.LoadAnimation, Animator, p43);

    if success then
        p41.Animations[p42] = result;
    end;
end;

local function stopActionAnimations(p44) -- Line: 264
    for i in pairs(p44.WeaponAnimationNames) do
        if i ~= "Idle" then
            p44:stop(i, 0.2);
        end;
    end;
end;

function u1.setWeapon(p45: any, p46: string?, p47: string?, p48: boolean?) -- Line: 273
    -- upvalues: GetWeaponProperties (copy)
    if p45.WeaponName == p46 and p45.WeaponIdentifier == p47 then
        local Idle = p45.Animations.Idle;

        if Idle and not Idle.IsPlaying then
            Idle:Play();
        end;

        return;
    end;

    for i in pairs(p45.WeaponAnimationNames) do
        p45:unregister(i);
    end;

    p45.WeaponName = p46;
    p45.WeaponIdentifier = p47;
    p45.WeaponSlot = nil;

    if not p46 then
        return;
    end;

    local v49 = GetWeaponProperties(p46);
    local v50;

    if v49 then
        v50 = v49.Slot;
    else
        v50 = v49;
    end;

    p45.WeaponSlot = v50;

    if v49 then
        v49 = v49.CharacterAnimations;
    end;

    if not v49 then
        return;
    end;

    for _, child in ipairs(v49:GetChildren()) do
        if child:IsA("Animation") then
            p45:register(child.Name, child);
            p45.WeaponAnimationNames[child.Name] = true;
        end;
    end;

    if p45.Animations.Idle then
        p45:play("Idle");
    end;

    if p48 and p45.Animations.Equip then
        p45:play("Equip", 0.2);
    end;
end;

local function resolveActionAnimationName(p51: any, p52: string) -- Line: 320
    -- upvalues: u2 (copy), GetWeaponProperties (copy)
    local v53 = p52 == "NoSuppressorShoot" and "Shoot" or p52;
    local v54 = u2[v53];

    if v54 then
        return v54;
    end;

    if v53 == "Swing1" or v53 == "Swing2" then
        return not p51.Animations[v53] and "Swing" or v53;
    end;

    if v53 == "Shoot" and p51.WeaponName then
        local v55 = GetWeaponProperties(p51.WeaponName);
        local v56;

        if p51.Player then
            v56 = p51.Player:GetAttribute("ScopeIncrement");
        else
            v56 = nil;
        end;

        if v55 and (v55.AimingOptions == "AutomaticScope" and (v56 or 0) > 0) then
            return "AimShoot";
        end;
    end;

    return v53;
end;

function u1.playAction(p57: any, p58: string) -- Line: 346
    -- upvalues: stopActionAnimations (copy), resolveActionAnimationName (copy)
    if typeof(p58) ~= "string" or p58 == "" then
        return;
    end;

    if p58 == "Cancel Plant" or (p58 == "CancelThrow" or p58 == "RevolverChargeCancel") then
        stopActionAnimations(p57);

        return;
    end;

    local v59 = (p58 == "RevolverChargeStart" or p58 == "RevolverChargeRelease") and "Shoot" or p58;

    if v59 == "StartThrow" then
        stopActionAnimations(p57);

        if p57.Animations.StartThrow then
            p57:play("StartThrow", 0.2);
        end;

        if p57.Animations.ThrowIdle then
            p57:play("ThrowIdle");
        end;

        return;
    end;

    if v59 == "Throw" then
        p57:stop("StartThrow", 0.2);
        p57:stop("ThrowIdle", 0.2);
    end;

    local v60 = resolveActionAnimationName(p57, v59);

    if not (v60 and p57.Animations[v60]) then
        return;
    end;

    stopActionAnimations(p57);
    p57:play(v60, 0.2);
end;

local function stopMovementAnimations(p61) -- Line: 388
    -- upvalues: getMovementAnimationNames (copy)
    local v62 = getMovementAnimationNames();

    for i, v in pairs(p61.Animations) do
        if i ~= "Jump" and (v62[i] and v.IsPlaying) then
            p61:stop(i, 0.2);
        end;
    end;
end;

local function getMovementAnimationFromVelocity(p63: any, p64: vector) -- Line: 397
    -- upvalues: u3 (copy)
    local RootPart = p63.RootPart;

    if not RootPart then
        return nil;
    end;

    local v65 = p64 * Vector3.new(1, 0, 1);

    if v65.Magnitude < 0.1 then
        return nil;
    end;

    local CFrame2 = RootPart.CFrame;
    local Unit = v65.Unit;
    local v66 = CFrame2.RightVector:Dot(Unit);
    local v67 = CFrame2.LookVector:Dot(Unit);

    return u3[table.concat({
        v67 > 0.3 and "F" or "",
        v67 < -0.3 and "B" or "",
        v66 < -0.3 and "L" or "",
        v66 > 0.3 and "R" or ""
    })];
end;

local function enterJumpState(p68) -- Line: 423
    -- upvalues: stopMovementAnimations (copy)
    local Jump = p68.Animations.Jump;

    if Jump ~= nil then
        if not Jump.Looped then
            Jump.Looped = true;
        end;

        if not Jump.IsPlaying then
            p68:play("Jump", 0.2);
        end;
    end;

    p68.IsJumping = true;
    p68.CurrentMovementAnimation = nil;
    p68.LastMovementAnimationSpeed = nil;
    stopMovementAnimations(p68);
end;

function u1.noteJumpEvent(p69) -- Line: 440
    -- upvalues: stopMovementAnimations (copy)
    if p69.IsDestroyed then
        return;
    end;

    local Jump = p69.Animations.Jump;

    if Jump ~= nil then
        if not Jump.Looped then
            Jump.Looped = true;
        end;

        if not Jump.IsPlaying then
            p69:play("Jump", 0.2);
        end;
    end;

    p69.IsJumping = true;
    p69.CurrentMovementAnimation = nil;
    p69.LastMovementAnimationSpeed = nil;
    stopMovementAnimations(p69);
end;

function u1.updateLocomotion(p70: any, p71: vector, p72: boolean, p73: boolean, p74: boolean) -- Line: 448
    -- upvalues: stopMovementAnimations (copy), getMovementAnimationFromVelocity (copy)
    if p70.DownedConnection then
        return;
    end;

    if not p74 and not p72 then
        local Jump = p70.Animations.Jump;

        if Jump ~= nil then
            if not Jump.Looped then
                Jump.Looped = true;
            end;

            if not Jump.IsPlaying then
                p70:play("Jump", 0.2);
            end;
        end;

        p70.IsJumping = true;
        p70.CurrentMovementAnimation = nil;
        p70.LastMovementAnimationSpeed = nil;
        stopMovementAnimations(p70);

        return;
    end;

    if p70.IsJumping then
        p70:stop("Jump", 0.2);
        p70.IsJumping = false;
    end;

    local Magnitude = (p71 * Vector3.new(1, 0, 1)).Magnitude;
    local v75 = getMovementAnimationFromVelocity(p70, p71);
    local CrouchIdle = p70.Animations.CrouchIdle;
    local v76;

    if p73 then
        if Magnitude <= 0.1 or not v75 then
            p70.LastMovementAnimationSpeed = nil;

            if CrouchIdle and not CrouchIdle.IsPlaying then
                p70.CurrentMovementAnimation = nil;
                stopMovementAnimations(p70);
                p70:play("CrouchIdle", 0.2);
            end;

            return;
        end;

        v76 = `Crouch{v75}`;

        if CrouchIdle and CrouchIdle.IsPlaying then
            p70:stop("CrouchIdle", 0.2);
        end;
    else
        if CrouchIdle and CrouchIdle.IsPlaying then
            p70:stop("CrouchIdle", 0.2);
        end;

        v76 = v75 or "CharacterIdle";
    end;

    local v77;

    if v76 then
        v77 = p70.Animations[v76];
    else
        v77 = nil;
    end;

    local v78 = p70.CurrentMovementAnimation ~= v76;

    if v77 and v76 ~= "CharacterIdle" then
        local v79 = Magnitude / (p73 and 12 or 16);
        local LastMovementAnimationSpeed = p70.LastMovementAnimationSpeed;

        if v78 or (LastMovementAnimationSpeed == nil or math.abs(v79 - LastMovementAnimationSpeed) >= 0.03) then
            v77:AdjustSpeed(v79);
            p70.LastMovementAnimationSpeed = v79;
        end;
    else
        p70.LastMovementAnimationSpeed = nil;
    end;

    if v78 then
        p70.CurrentMovementAnimation = v76;
        stopMovementAnimations(p70);
    end;

    if v77 and not v77.IsPlaying then
        v77:Play(0.15);
    end;
end;

function u1.new(p80: userdata, p81: table?) -- Line: 528
    -- upvalues: u1 (copy), Janitor (copy), CharacterResolver (copy), CharacterAnimations (copy)
    local v82 = setmetatable({}, u1);
    v82.Janitor = Janitor.new();
    v82.Character = p80;
    local RootPart = CharacterResolver.getRootPart(p80);
    local v83 = `{p80:GetFullName()} has no HumanoidRootPart`;
    v82.RootPart = assert(RootPart, v83);
    local Animator = CharacterResolver.getAnimator(p80);
    local v84 = `{p80:GetFullName()} has no Animator`;
    v82.Animator = assert(Animator, v84);
    v82.Animations = {};
    v82.WeaponAnimationNames = {};
    v82.IsJumping = false;
    v82.IsDestroyed = false;

    if not (p81 and p81.SkipBaseAnimations) then
        local Zombie = CharacterAnimations:FindFirstChild("Zombie");

        for _, descendant in ipairs(CharacterAnimations:GetDescendants()) do
            if descendant:IsA("Animation") and not (Zombie and descendant:IsDescendantOf(Zombie)) then
                v82:register(descendant.Name, descendant);
            end;
        end;
    end;

    return v82;
end;

function u1.destroy(p85) -- Line: 557
    if p85.IsDestroyed then
        return;
    end;

    p85.IsDestroyed = true;

    if p85.DownedConnection then
        p85.DownedConnection:Disconnect();
        p85.DownedConnection = nil;
    end;

    for _, v in pairs(p85.Animations) do
        if v.IsPlaying then
            v:Stop();
        end;

        v:Destroy();
    end;

    table.clear(p85.Animations);
    table.clear(p85.WeaponAnimationNames);
    p85.Janitor:Destroy();
    p85.Animator = nil;
    p85.RootPart = nil;
    p85.Player = nil;
end;

return u1;