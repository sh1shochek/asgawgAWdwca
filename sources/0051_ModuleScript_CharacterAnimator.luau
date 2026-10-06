-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver);
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

local function getMovementAnimationNames() -- Line: 62
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

function u1.play(p7: any, p8: string, ...) -- Line: 86
    local v9 = p7.Animations[p8];

    if v9 then
        v9:Play(...);
    end;

    return v9;
end;

function u1.stop(p10: any, p11: string, ...) -- Line: 95
    local v12 = p10.Animations[p11];

    if v12 and v12.IsPlaying then
        v12:Stop(...);
    end;
end;

function u1.stopAnimations(p13: any, p14: number?) -- Line: 102
    for _, v in pairs(p13.Animations) do
        if v.IsPlaying then
            v:Stop(p14 or 0);
        end;
    end;

    p13.CurrentMovementAnimation = nil;
    p13.LastMovementAnimationSpeed = nil;
    p13.IsJumping = false;
end;

function u1.freezeAnimations(p15) -- Line: 114
    for _, v in pairs(p15.Animations) do
        if v.IsPlaying then
            v:AdjustSpeed(0);
        end;
    end;
end;

function u1.adjustAnimationSpeed(p16: any, p17: string, p18: number) -- Line: 122
    local v19 = p16.Animations[p17];

    if v19 then
        v19:AdjustSpeed(v19.Length / p18);
    end;
end;

function u1.unregister(p20: any, p21: string) -- Line: 129
    local v22 = p20.Animations[p21];

    if not v22 then
        return;
    end;

    if v22.IsPlaying then
        v22:Stop();
    end;

    p20.Animations[p21] = nil;
    p20.WeaponAnimationNames[p21] = nil;
    v22:Destroy();
end;

function u1.register(p23: any, p24: string, p25: userdata) -- Line: 143
    local Animator = p23.Animator;

    if not Animator then
        return;
    end;

    p23:unregister(p24);
    local success, result = pcall(Animator.LoadAnimation, Animator, p25);

    if success then
        p23.Animations[p24] = result;
    end;
end;

local function stopActionAnimations(p26) -- Line: 159
    for i in pairs(p26.WeaponAnimationNames) do
        if i ~= "Idle" then
            p26:stop(i, 0.2);
        end;
    end;
end;

function u1.setWeapon(p27: any, p28: string?, p29: string?, p30: boolean?) -- Line: 168
    -- upvalues: GetWeaponProperties (copy)
    if p27.WeaponName == p28 and p27.WeaponIdentifier == p29 then
        local Idle = p27.Animations.Idle;

        if Idle and not Idle.IsPlaying then
            Idle:Play();
        end;

        return;
    end;

    for i in pairs(p27.WeaponAnimationNames) do
        p27:unregister(i);
    end;

    p27.WeaponName = p28;
    p27.WeaponIdentifier = p29;

    if not p28 then
        return;
    end;

    local v31 = GetWeaponProperties(p28);

    if v31 then
        v31 = v31.CharacterAnimations;
    end;

    if not v31 then
        return;
    end;

    for _, child in ipairs(v31:GetChildren()) do
        if child:IsA("Animation") then
            p27:register(child.Name, child);
            p27.WeaponAnimationNames[child.Name] = true;
        end;
    end;

    if p27.Animations.Idle then
        p27:play("Idle");
    end;

    if p30 and p27.Animations.Equip then
        p27:play("Equip", 0.2);
    end;
end;

local function resolveActionAnimationName(p32: any, p33: string) -- Line: 213
    -- upvalues: u2 (copy), GetWeaponProperties (copy)
    local v34 = p33 == "NoSuppressorShoot" and "Shoot" or p33;
    local v35 = u2[v34];

    if v35 then
        return v35;
    end;

    if v34 == "Swing1" or v34 == "Swing2" then
        return not p32.Animations[v34] and "Swing" or v34;
    end;

    if v34 == "Shoot" and p32.WeaponName then
        local v36 = GetWeaponProperties(p32.WeaponName);
        local v37;

        if p32.Player then
            v37 = p32.Player:GetAttribute("ScopeIncrement");
        else
            v37 = nil;
        end;

        if v36 and (v36.AimingOptions == "AutomaticScope" and (v37 or 0) > 0) then
            return "AimShoot";
        end;
    end;

    return v34;
end;

function u1.playAction(p38: any, p39: string) -- Line: 239
    -- upvalues: stopActionAnimations (copy), resolveActionAnimationName (copy)
    if typeof(p39) ~= "string" or p39 == "" then
        return;
    end;

    if p39 == "Cancel Plant" or (p39 == "CancelThrow" or p39 == "RevolverChargeCancel") then
        stopActionAnimations(p38);

        return;
    end;

    local v40 = (p39 == "RevolverChargeStart" or p39 == "RevolverChargeRelease") and "Shoot" or p39;

    if v40 == "StartThrow" then
        stopActionAnimations(p38);

        if p38.Animations.StartThrow then
            p38:play("StartThrow", 0.2);
        end;

        if p38.Animations.ThrowIdle then
            p38:play("ThrowIdle");
        end;

        return;
    end;

    if v40 == "Throw" then
        p38:stop("StartThrow", 0.2);
        p38:stop("ThrowIdle", 0.2);
    end;

    local v41 = resolveActionAnimationName(p38, v40);

    if not (v41 and p38.Animations[v41]) then
        return;
    end;

    stopActionAnimations(p38);
    p38:play(v41, 0.2);
end;

local function stopMovementAnimations(p42) -- Line: 281
    -- upvalues: getMovementAnimationNames (copy)
    local v43 = getMovementAnimationNames();

    for i, v in pairs(p42.Animations) do
        if i ~= "Jump" and (v43[i] and v.IsPlaying) then
            p42:stop(i, 0.2);
        end;
    end;
end;

local function getMovementAnimationFromVelocity(p44: any, p45: vector) -- Line: 290
    -- upvalues: u3 (copy)
    local RootPart = p44.RootPart;

    if not RootPart then
        return nil;
    end;

    local v46 = p45 * Vector3.new(1, 0, 1);

    if v46.Magnitude < 0.1 then
        return nil;
    end;

    local CFrame = RootPart.CFrame;
    local Unit = v46.Unit;
    local v47 = CFrame.RightVector:Dot(Unit);
    local v48 = CFrame.LookVector:Dot(Unit);

    return u3[table.concat({
        v48 > 0.3 and "F" or "",
        v48 < -0.3 and "B" or "",
        v47 < -0.3 and "L" or "",
        v47 > 0.3 and "R" or ""
    })];
end;

local function enterJumpState(p49) -- Line: 316
    -- upvalues: stopMovementAnimations (copy)
    local Jump = p49.Animations.Jump;

    if Jump ~= nil then
        if not Jump.Looped then
            Jump.Looped = true;
        end;

        if not Jump.IsPlaying then
            p49:play("Jump", 0.2);
        end;
    end;

    p49.IsJumping = true;
    p49.CurrentMovementAnimation = nil;
    p49.LastMovementAnimationSpeed = nil;
    stopMovementAnimations(p49);
end;

function u1.noteJumpEvent(p50) -- Line: 333
    -- upvalues: stopMovementAnimations (copy)
    if p50.IsDestroyed then
        return;
    end;

    local Jump = p50.Animations.Jump;

    if Jump ~= nil then
        if not Jump.Looped then
            Jump.Looped = true;
        end;

        if not Jump.IsPlaying then
            p50:play("Jump", 0.2);
        end;
    end;

    p50.IsJumping = true;
    p50.CurrentMovementAnimation = nil;
    p50.LastMovementAnimationSpeed = nil;
    stopMovementAnimations(p50);
end;

function u1.updateLocomotion(p51: any, p52: vector, p53: boolean, p54: boolean, p55: boolean) -- Line: 341
    -- upvalues: stopMovementAnimations (copy), getMovementAnimationFromVelocity (copy)
    if not p55 and not p53 then
        local Jump = p51.Animations.Jump;

        if Jump ~= nil then
            if not Jump.Looped then
                Jump.Looped = true;
            end;

            if not Jump.IsPlaying then
                p51:play("Jump", 0.2);
            end;
        end;

        p51.IsJumping = true;
        p51.CurrentMovementAnimation = nil;
        p51.LastMovementAnimationSpeed = nil;
        stopMovementAnimations(p51);

        return;
    end;

    if p51.IsJumping then
        p51:stop("Jump", 0.2);
        p51.IsJumping = false;
    end;

    local Magnitude = (p52 * Vector3.new(1, 0, 1)).Magnitude;
    local v56 = getMovementAnimationFromVelocity(p51, p52);
    local CrouchIdle = p51.Animations.CrouchIdle;
    local v57;

    if p54 then
        if Magnitude <= 0.1 or not v56 then
            p51.LastMovementAnimationSpeed = nil;

            if CrouchIdle and not CrouchIdle.IsPlaying then
                p51.CurrentMovementAnimation = nil;
                stopMovementAnimations(p51);
                p51:play("CrouchIdle", 0.2);
            end;

            return;
        end;

        v57 = `Crouch{v56}`;

        if CrouchIdle and CrouchIdle.IsPlaying then
            p51:stop("CrouchIdle", 0.2);
        end;
    else
        if CrouchIdle and CrouchIdle.IsPlaying then
            p51:stop("CrouchIdle", 0.2);
        end;

        v57 = v56 or "CharacterIdle";
    end;

    local v58;

    if v57 then
        v58 = p51.Animations[v57];
    else
        v58 = nil;
    end;

    local v59 = p51.CurrentMovementAnimation ~= v57;

    if v58 and v57 ~= "CharacterIdle" then
        local v60 = Magnitude / (p54 and 12 or 16);
        local LastMovementAnimationSpeed = p51.LastMovementAnimationSpeed;

        if v59 or (LastMovementAnimationSpeed == nil or math.abs(v60 - LastMovementAnimationSpeed) >= 0.03) then
            v58:AdjustSpeed(v60);
            p51.LastMovementAnimationSpeed = v60;
        end;
    else
        p51.LastMovementAnimationSpeed = nil;
    end;

    if v59 then
        p51.CurrentMovementAnimation = v57;
        stopMovementAnimations(p51);
    end;

    if v58 and not v58.IsPlaying then
        v58:Play(0.15);
    end;
end;

function u1.new(p61: userdata, p62: table?) -- Line: 417
    -- upvalues: u1 (copy), Janitor (copy), CharacterResolver (copy), CharacterAnimations (copy)
    local v63 = setmetatable({}, u1);
    v63.Janitor = Janitor.new();
    v63.Character = p61;
    local RootPart = CharacterResolver.getRootPart(p61);
    local v64 = `{p61:GetFullName()} has no HumanoidRootPart`;
    v63.RootPart = assert(RootPart, v64);
    local Animator = CharacterResolver.getAnimator(p61);
    local v65 = `{p61:GetFullName()} has no Animator`;
    v63.Animator = assert(Animator, v65);
    v63.Animations = {};
    v63.WeaponAnimationNames = {};
    v63.IsJumping = false;
    v63.IsDestroyed = false;

    if not (p62 and p62.SkipBaseAnimations) then
        for _, descendant in ipairs(CharacterAnimations:GetDescendants()) do
            if descendant:IsA("Animation") then
                v63:register(descendant.Name, descendant);
            end;
        end;
    end;

    return v63;
end;

function u1.destroy(p66) -- Line: 444
    if p66.IsDestroyed then
        return;
    end;

    p66.IsDestroyed = true;

    for _, v in pairs(p66.Animations) do
        if v.IsPlaying then
            v:Stop();
        end;

        v:Destroy();
    end;

    table.clear(p66.Animations);
    table.clear(p66.WeaponAnimationNames);
    p66.Janitor:Destroy();
    p66.Animator = nil;
    p66.RootPart = nil;
    p66.Player = nil;
end;

return u1;