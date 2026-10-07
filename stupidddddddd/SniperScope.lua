-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.SniperScope
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.SniperScope
-- Decompile time: 5.95 ms

local u0 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local CharacterController = require(ReplicatedStorage.Controllers.CharacterController)
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Spring = require(ReplicatedStorage.Shared.Spring)
local u52 = Spring.new(1, 2.5, 1)
local u57 = Spring.new(0.85, 0.5, Vector2.zero)
local u58 = false
local u59 = 0
local u60 = nil
local u61 = nil
local u62 = nil

local function getMovementSpeed(a1) -- Line: 50 -- upvalues: RuntimeKinematics (val) -- types: a1: userdata
    local v1 = RuntimeKinematics.getVelocity(a1, a1.PrimaryPart)
    return Vector3.new(v1.X, 0, v1.Z).Magnitude
end

local function isCharacterMoving(a1) -- Line: 55 -- upvalues: RuntimeKinematics (val) -- types: a1: userdata
    local v1 = RuntimeKinematics.getVelocity(a1, a1.PrimaryPart)
    return 0.1 < Vector3.new(v1.X, 0, v1.Z).Magnitude
end

local function isCharacterJumping(a1) -- Line: 59 -- upvalues: RuntimeKinematics (val) -- types: a1: userdata
    return not RuntimeKinematics.isOnGround(a1)
end

function u0.toggle(a1) -- Line: 66
    -- upvalues: u60 (ref), u61 (ref), u62 (ref), u52 (val), u59 (ref)
    u60.Visible = a1
    u60.Blur.Visible = true
    local v1 = if not a1 then 1 else 3
    local v2 = if not a1 then 2 else 4
    if u61 and u61.Parent then
        u61.ZIndex = v1
    end
    if u62 and u62.Parent then
        u62.ZIndex = v2
    end
    if not a1 then
        u59 = 0
        return
    end
    u52:setPosition(1)
    u52:setGoal(0)
    u59 = tick()
end

function u0.updateMovementSharpness(a1, a2) -- Line: 84
    -- upvalues: RuntimeKinematics (val), InventoryController (val), u52 (val), u59 (ref)
    local v1 = RuntimeKinematics.getVelocity(a1, a1.PrimaryPart)
    local v2 = math.min((Vector3.new(v1.X, 0, v1.Z)).Magnitude, 3) / 3
    v1 = InventoryController.getCurrentEquipped()
    local Properties = v1
    if Properties then
        Properties = v1.Properties
        if Properties then
            Properties = false
            if v1.Properties.AimingOptions == "SniperScope" then
                Properties = false
                if v1.Properties.MuzzleType == "Sniper" then
                    Properties = false
                    if v1.Properties.Spread.Range.Min == 0 then
                        Properties = false
                        if v1.Properties.Spread.PerShot == 0 then
                            Properties = v1.Properties.Spread.MovementMultiplier == 2
                        end
                    end
                end
            end
        end
    end
    local v3 = false
    if Properties and not RuntimeKinematics.isOnGround(a1) then
        v3 = (math.abs((RuntimeKinematics.getVelocity(a1, a1.PrimaryPart)).Y)) <= 3
    end
    if a2 then
        u52:setPosition(1)
        u52:setGoal(0)
        u59 = tick()
        return
    end
    if RuntimeKinematics.isOnGround(a1) then
        if v2 > 0.1 then
            u52:setPosition(v2)
            return
        end
        if 1.2 < tick() - u59 then
            u52:reset(0)
        end
        return
    end
    if Properties and v3 then
        u52:setPosition(0)
        u52:setGoal(0)
        return
    end
    u52:setPosition(1)
end

function u0.updateScope(a1, a2) -- Line: 127
    -- upvalues: CharacterResolver (val), RuntimeKinematics (val), u58 (ref), u0 (val), CharacterController (val)
    -- upvalues: u57 (val), u60 (ref), u52 (val)
    if not CharacterResolver.isAliveCharacter(a1) then
        return
    end
    local v1 = not RuntimeKinematics.isOnGround(a1)
    u0.updateMovementSharpness(a1, u58 and not v1)
    u58 = v1
    local v2 = RuntimeKinematics.getVelocity(a1, a1.PrimaryPart)
    local v3 = 0.1 < Vector3.new(v2.X, 0, v2.Z).Magnitude
    if not v3 then
        u57:reset(Vector2.zero)
        u60.Position = UDim2.fromScale(0.5, 0.5)
    else
        local v4
        v2 = RuntimeKinematics.getVelocity(a1, a1.PrimaryPart)
        v3 = math.min((Vector3.new(v2.X, 0, v2.Z)).Magnitude, 3)
        local v5 = CharacterController.GetCrouchState()
        v2 = CharacterController.GetWalkState()
        u57:setPosition(Vector2.new(
            math.sin((tick()) * 3.141592653589793 * 1.75 * (if not v5 then if not v2 then 1 else 0.75 else 0.5)),
            (math.sin((tick()) * 3.141592653589793 * 2.75 * v4))
        ) * v3 * 1.5)
        local v6 = u57:getPosition()
        u60.Position = UDim2.new(0.5, v6.X, 0.5, v6.Y)
    end
    u60.Blur.ImageTransparency = 1 - u52:getPosition()
    u60.Sharp.ImageTransparency = u52:getPosition()
end

function u0.Initialize(a1, a2) -- Line: 166
    -- upvalues: u60 (ref), u61 (ref), u62 (ref), RunServiceController (val), LocalPlayer (val), CharacterResolver (val)
    -- upvalues: InventoryController (val), SpectateController (val), u52 (val), u57 (val), u0 (val)
    u60 = a2
    local Parent = a2.Parent and a2.Parent.Parent
    if Parent then
        u61 = Parent:FindFirstChild("Bottom")
        u62 = Parent:FindFirstChild("Top")
        if u61 then
            u61.ZIndex = 1
        end
        if u62 then
            u62.ZIndex = 2
        end
    end
    RunServiceController.BindToRenderStep("UI.SniperScope.Update", function(a1) -- Line: 177
        -- upvalues: LocalPlayer (upval), CharacterResolver (upval), InventoryController (upval)
        -- upvalues: SpectateController (upval), u52 (upval), u57 (upval), u0 (upval), u60 (upval), u61 (upval)
        -- upvalues: u62 (upval)
        local v1 = LocalPlayer:GetAttribute("IsSpectating") == true
        local Character = LocalPlayer.Character
        if v1 or CharacterResolver.isAliveCharacter(Character) then
            local v2 = InventoryController.getCurrentEquipped()
            local v3 = SpectateController.GetCurrentSpectateInstance()
            local v4 = false
            if not v1 or not v3 then
                v4 = v2 and v2.IsAiming and v2.Properties.AimingOptions == "SniperScope"
            elseif v3.CurrentEquipped then
                local Name = v3.CurrentEquipped.Name
                local v5 = true
                if Name ~= "AWP" then
                    v5 = Name == "SSG 08"
                end
                if v5 and v3.PerspectiveState == "First-Person" then
                    v4 = 0 < (v3.Player:GetAttribute("ScopeIncrement") or 0)
                    Character = v3.Character
                end
            end
            u52:update(a1)
            u57:update(a1)
            if not v4 then
                if u60.Visible then
                    u0.toggle(false)
                end
            elseif Character then
                u0.updateScope(Character, a1)
                if not u60.Visible then
                    u0.toggle(true)
                end
            elseif u60.Visible then
                u0.toggle(false)
            end
        elseif u60.Visible then
            u0.toggle(false)
        end
        if not u60.Visible then
            if u61 and u61.Parent then
                u61.ZIndex = 1
            end
            if u62 and u62.Parent then
                u62.ZIndex = 2
            end
        end
    end)
end

return u0