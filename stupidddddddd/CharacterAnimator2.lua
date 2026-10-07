-- ReplicatedStorage.Classes.Character.Classes.CharacterAnimator
-- Script path: ReplicatedStorage.Classes.Character.Classes.CharacterAnimator
-- Decompile time: 7.94 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local CharacterAnimations = (ReplicatedStorage:WaitForChild("Assets")):WaitForChild("CharacterAnimations")
local u27 = {}
u27.__index = u27
local u28 = {
    ["Add Suppressor"] = "AddSuppressor",
    ["Remove Suppressor"] = "RemoveSuppressor",
    ["Switch Fire Mode"] = "Switch",
}
local u32 = {
    FR = "ForwardRight",
    FL = "ForwardLeft",
    F = "Forward",
    BR = "BackwardRight",
    BL = "BackwardLeft",
    B = "Backward",
    R = "Right",
    L = "Left",
}
local u33 = nil

local function getMovementAnimationNames() -- Line: 62 -- upvalues: u33 (ref), CharacterAnimations (val)
    local v1
    if u33 then
        return u33
    end
    local v2 = {CharacterIdle = true}
    for i, v in ipairs({"Crouch", "Movement"}) do
        v1 = CharacterAnimations:FindFirstChild(v)
        if v1 then
            for i2, i3 in ipairs(v1:GetDescendants()) do
                if i3:IsA("Animation") then
                    v2[i3.Name] = true
                end
            end
        end
    end
    u33 = v2
    return v2
end

function u27:play(a2, ...) -- Line: 86 -- types: a2: string
    local v1 = self.Animations[a2]
    if v1 then
        v1:Play(...)
    end
    return v1
end

function u27:stop(a2, ...) -- Line: 95 -- types: a2: string
    local v1 = self.Animations[a2]
    if v1 and v1.IsPlaying then
        v1:Stop(...)
    end
end

function u27.stopAnimations(a1, a2) -- Line: 102 -- types: a2: number?
    for k, v in pairs(a1.Animations) do
        if v.IsPlaying then
            v:Stop(a2 or 0)
        end
    end
    a1.CurrentMovementAnimation = nil
    a1.LastMovementAnimationSpeed = nil
    a1.IsJumping = false
end

function u27.freezeAnimations(a1) -- Line: 114
    for k, v in pairs(a1.Animations) do
        if v.IsPlaying then
            v:AdjustSpeed(0)
        end
    end
end

function u27.adjustAnimationSpeed(a1, a2, a3) -- Line: 122 -- types: a2: string, a3: number
    local v1 = a1.Animations[a2]
    if v1 then
        v1:AdjustSpeed(v1.Length / a3)
    end
end

function u27:unregister(a2) -- Line: 129 -- types: a2: string
    local v1 = self.Animations[a2]
    if not v1 then
        return
    end
    if v1.IsPlaying then
        v1:Stop()
    end
    self.Animations[a2] = nil
    self.WeaponAnimationNames[a2] = nil
    v1:Destroy()
end

function u27:register(a2, a3) -- Line: 143 -- types: a2: string, a3: userdata
    local Animator = self.Animator
    if not Animator then
        return
    end
    self:unregister(a2)
    local success, result = pcall(Animator.LoadAnimation, Animator, a3)
    if success then
        self.Animations[a2] = result
    end
end

local function stopActionAnimations(a1) -- Line: 159
    for k in pairs(a1.WeaponAnimationNames) do
        if k ~= "Idle" then
            a1:stop(k, 0.2)
        end
    end
end

function u27.setWeapon(a1, a2, a3, a4) -- Line: 168
    -- upvalues: GetWeaponProperties (val)
    if a1.WeaponName == a2 and a1.WeaponIdentifier == a3 then
        local Idle = a1.Animations.Idle
        if Idle and not Idle.IsPlaying then
            Idle:Play()
        end
        return
    end
    for k in pairs(a1.WeaponAnimationNames) do
        a1:unregister(k)
    end
    a1.WeaponName = a2
    a1.WeaponIdentifier = a3
    if not a2 then
        return
    end
    local v1 = GetWeaponProperties(a2)
    local CharacterAnimations = v1 and v1.CharacterAnimations
    if not CharacterAnimations then
        return
    end
    for i, v in ipairs(CharacterAnimations:GetChildren()) do
        if v:IsA("Animation") then
            a1:register(v.Name, v)
            a1.WeaponAnimationNames[v.Name] = true
        end
    end
    if a1.Animations.Idle then
        a1:play("Idle")
    end
    if a4 and a1.Animations.Equip then
        a1:play("Equip", 0.2)
    end
end

local function resolveActionAnimationName(a1, a2) -- Line: 213
    -- upvalues: u28 (val), GetWeaponProperties (val)
    if a2 == "NoSuppressorShoot" then
        a2 = "Shoot"
    end
    local v1 = u28[a2]
    if v1 then
        return v1
    end
    if a2 ~= "Swing1" and a2 ~= "Swing2" then
        if a2 == "Shoot" and a1.WeaponName then
            local v2 = GetWeaponProperties(a1.WeaponName)
            local Attribute = if not a1.Player then nil else a1.Player:GetAttribute("ScopeIncrement")
            if v2 and v2.AimingOptions == "AutomaticScope" and 0 < (Attribute or 0) then
                return "AimShoot"
            end
        end
        return a2
    end
    if a1.Animations[a2] then
        return a2
    end
    return "Swing"
end

function u27.playAction(a1, a2) -- Line: 239
    -- upvalues: stopActionAnimations (val), resolveActionAnimationName (val)
    if typeof(a2) == "string" and a2 ~= "" then
        if a2 ~= "Cancel Plant" and a2 ~= "CancelThrow" and a2 ~= "RevolverChargeCancel" then
            if a2 == "RevolverChargeStart" or a2 == "RevolverChargeRelease" then
                a2 = "Shoot"
            end
            if a2 == "StartThrow" then
                stopActionAnimations(a1)
                if a1.Animations.StartThrow then
                    a1:play("StartThrow", 0.2)
                end
                if a1.Animations.ThrowIdle then
                    a1:play("ThrowIdle")
                end
                return
            end
            if a2 == "Throw" then
                a1:stop("StartThrow", 0.2)
                a1:stop("ThrowIdle", 0.2)
            end
            local v1 = resolveActionAnimationName(a1, a2)
            if v1 and a1.Animations[v1] then
                stopActionAnimations(a1)
                a1:play(v1, 0.2)
                return
            end
            return
        end
        stopActionAnimations(a1)
        return
    end
end

local function stopMovementAnimations(a1) -- Line: 281 -- upvalues: getMovementAnimationNames (val)
    local v1 = getMovementAnimationNames()
    for k, v in pairs(a1.Animations) do
        if k ~= "Jump" and v1[k] and v.IsPlaying then
            a1:stop(k, 0.2)
        end
    end
end

local function getMovementAnimationFromVelocity(a1, a2) -- Line: 290 -- upvalues: u32 (val) -- types: a2: vector
    local RootPart = a1.RootPart
    if not RootPart then
        return nil
    end
    local v1 = a2 * Vector3.new(1, 0, 1)
    if v1.Magnitude < 0.1 then
        return nil
    end
    local CFrame = RootPart.CFrame
    local Unit = v1.Unit
    local v2 = CFrame.RightVector:Dot(Unit)
    local v3 = CFrame.LookVector:Dot(Unit)
    local concat = table.concat
    return u32[(concat({
        if not (v3 > 0.3) then "" else "F",
        if not (v3 < -0.3) then "" else "B",
        if not (v2 < -0.3) then "" else "L",
        if not (v2 > 0.3) then "" else "R",
    }))]
end

local function enterJumpState(a1) -- Line: 316 -- upvalues: stopMovementAnimations (val)
    local Jump = a1.Animations.Jump
    if Jump ~= nil then
        if not Jump.Looped then
            Jump.Looped = true
        end
        if not Jump.IsPlaying then
            a1:play("Jump", 0.2)
        end
    end
    a1.IsJumping = true
    a1.CurrentMovementAnimation = nil
    a1.LastMovementAnimationSpeed = nil
    stopMovementAnimations(a1)
end

function u27.noteJumpEvent(a1) -- Line: 333 -- upvalues: stopMovementAnimations (val)
    if a1.IsDestroyed then
        return
    end
    local Jump = a1.Animations.Jump
    if Jump ~= nil then
        if not Jump.Looped then
            Jump.Looped = true
        end
        if not Jump.IsPlaying then
            a1:play("Jump", 0.2)
        end
    end
    a1.IsJumping = true
    a1.CurrentMovementAnimation = nil
    a1.LastMovementAnimationSpeed = nil
    stopMovementAnimations(a1)
end

function u27.updateLocomotion(a1, a2, a3, a4, a5) -- Line: 341
    -- upvalues: stopMovementAnimations (val), getMovementAnimationFromVelocity (val)
    local LastMovementAnimationSpeed, v1, v2, v3, v4, v5
    if not a5 and not a3 then
        local Jump = a1.Animations.Jump
        if Jump ~= nil then
            if not Jump.Looped then
                Jump.Looped = true
            end
            if not Jump.IsPlaying then
                a1:play("Jump", 0.2)
            end
        end
        a1.IsJumping = true
        a1.CurrentMovementAnimation = nil
        a1.LastMovementAnimationSpeed = nil
        stopMovementAnimations(a1)
        return
    end
    if a1.IsJumping then
        a1:stop("Jump", 0.2)
        a1.IsJumping = false
    end
    local Magnitude = (a2 * Vector3.new(1, 0, 1)).Magnitude
    local v6 = getMovementAnimationFromVelocity(a1, a2)
    local CrouchIdle = a1.Animations.CrouchIdle
    if not a4 then
        if CrouchIdle and CrouchIdle.IsPlaying then
            a1:stop("CrouchIdle", 0.2)
        end
        if not v6 then
            v6 = "CharacterIdle"
        end
        v1, v4 = a1, a4
        v5 = if not v6 then nil else v1.Animations[v6]
        v2 = v1.CurrentMovementAnimation ~= v6
        if not v5 or v6 == "CharacterIdle" then
            v1.LastMovementAnimationSpeed = nil
        else
            v3 = Magnitude / (if not v4 then 16 else 12)
            LastMovementAnimationSpeed = v1.LastMovementAnimationSpeed
            if v2 or LastMovementAnimationSpeed == nil or 0.03 <= (math.abs(v3 - LastMovementAnimationSpeed)) then
                v5:AdjustSpeed(v3)
                v1.LastMovementAnimationSpeed = v3
            end
        end
        if v2 then
            v1.CurrentMovementAnimation = v6
            stopMovementAnimations(v1)
        end
        if v5 and not v5.IsPlaying then
            v5:Play(0.15)
        end
        return
    end
    if Magnitude > 0.1 and v6 then
        v6 = ("Crouch%*"):format(v6)
        if CrouchIdle then
            if CrouchIdle.IsPlaying then
                a1:stop("CrouchIdle", 0.2)
            end
        end
        v1, v4 = a1, a4
        v5 = if not v6 then nil else v1.Animations[v6]
        v2 = v1.CurrentMovementAnimation ~= v6
        if not v5 or v6 == "CharacterIdle" then
            v1.LastMovementAnimationSpeed = nil
        else
            v3 = Magnitude / (if not v4 then 16 else 12)
            LastMovementAnimationSpeed = v1.LastMovementAnimationSpeed
            if v2 or LastMovementAnimationSpeed == nil or 0.03 <= (math.abs(v3 - LastMovementAnimationSpeed)) then
                v5:AdjustSpeed(v3)
                v1.LastMovementAnimationSpeed = v3
            end
        end
        if v2 then
            v1.CurrentMovementAnimation = v6
            stopMovementAnimations(v1)
        end
        if v5 and not v5.IsPlaying then
            v5:Play(0.15)
        end
        return
    end
    a1.LastMovementAnimationSpeed = nil
    if CrouchIdle and not CrouchIdle.IsPlaying then
        a1.CurrentMovementAnimation = nil
        stopMovementAnimations(a1)
        a1:play("CrouchIdle", 0.2)
    end
end

function u27.new(a1, a2) -- Line: 417
    -- upvalues: u27 (val), Janitor (val), CharacterResolver (val), CharacterAnimations (val)
    local v1 = setmetatable({}, u27)
    v1.Janitor = Janitor.new()
    v1.Character = a1
    v1.RootPart = assert(CharacterResolver.getRootPart(a1), (("%* has no HumanoidRootPart"):format((a1:GetFullName()))))
    v1.Animator = assert(CharacterResolver.getAnimator(a1), (("%* has no Animator"):format((a1:GetFullName()))))
    v1.Animations = {}
    v1.WeaponAnimationNames = {}
    v1.IsJumping = false
    v1.IsDestroyed = false
    if not a2 then
        for i, v in ipairs(CharacterAnimations:GetDescendants()) do
            if v:IsA("Animation") then
                v1:register(v.Name, v)
            end
        end
    elseif not a2.SkipBaseAnimations then
        for i2, i3 in ipairs(CharacterAnimations:GetDescendants()) do
            if i3:IsA("Animation") then
                v1:register(i3.Name, i3)
            end
        end
    end
    return v1
end

function u27.destroy(a1) -- Line: 444
    if a1.IsDestroyed then
        return
    end
    a1.IsDestroyed = true
    local v1 = a1
    for k, v in pairs(a1.Animations) do
        if v.IsPlaying then
            v:Stop()
        end
        v:Destroy()
    end
    table.clear(v1.Animations)
    table.clear(v1.WeaponAnimationNames)
    v1.Janitor:Destroy()
    v1.Animator = nil
    v1.RootPart = nil
    v1.Player = nil
end

return u27