-- ReplicatedStorage.Components.Common.WeaponTimings
-- Script path: ReplicatedStorage.Components.Common.WeaponTimings
-- Decompile time: 2.31 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local u5 = {
    EQUIP_PULLOUT_FRACTION = 0.925,
    DEFAULT_EQUIP_PULLOUT = 0.5,
    EQUIP_ACTION_LOCKOUT = 1,
    MELEE_EQUIP_LOCKOUT = 1,
    BURST_SHOT_COUNT = 3,
    BURST_SHOT_INTERVAL = 0.075,
    BURST_COOLDOWN = 0.15,
}
local u13 = {}
local u14 = false

function u5.PulloutSeconds(a1) -- Line: 20 -- upvalues: u5 (val) -- types: a1: number?
    if a1 ~= nil and a1 > 0 then
        return a1 * u5.EQUIP_PULLOUT_FRACTION
    end
    return u5.DEFAULT_EQUIP_PULLOUT
end

local function clipLength(a1) -- Line: 27 -- types: a1: userdata
    local v1 = 0
    if not a1:IsA("KeyframeSequence") then
        for i, j in a1:GetDescendants() do
            if j:IsA("FloatCurve") then
                for k, n in j:GetKeys() do
                    v1 = math.max(v1, n.Time)
                end
            elseif j:IsA("RotationCurve") then
                for m, i5 in j:GetKeys() do
                    v1 = math.max(v1, i5.Time)
                end
            end
        end
    else
        for i6, i7 in a1:GetKeyframes() do
            v1 = math.max(v1, i7.Time)
        end
    end
    if v1 > 0 then
        return v1
    end
    return nil
end

local function fetchLength(a1, a2, a3, a4) -- Line: 45
    -- upvalues: clipLength (val)
    local v1 = a2:FindFirstChild(a3)
    if v1 ~= nil and v1:IsA("Animation") then
        local success, result = pcall(a1.GetAnimationClipAsync, a1, v1.AnimationId)
        if success and result ~= nil then
            local v2 = clipLength(result)
            result:Destroy()
            return v2
        end
        warn((("[WeaponTimings] %* %* clip unavailable: %*"):format(a4, a3, (tostring(result)))))
        return nil
    end
    return nil
end

function u5.Load() -- Line: 61 -- upvalues: u14 (ref), ReplicatedStorage (val), u13 (val), fetchLength (val)
    local CameraAnimations, v1
    if u14 then
        return
    end
    u14 = true
    local AnimationClipProvider = game:GetService("AnimationClipProvider")
    for i, j in ReplicatedStorage.Database.Custom.Weapons:GetChildren() do
        if j:IsA("ModuleScript") then
            v1 = require(j)
            CameraAnimations = v1.CameraAnimations
            if v1.Class == "Weapon" and typeof(CameraAnimations) == "Instance" then
                u13[j.Name] = {
                    Equip = fetchLength(AnimationClipProvider, CameraAnimations, "Equip", j.Name),
                    Reload = fetchLength(AnimationClipProvider, CameraAnimations, "Reload", j.Name),
                }
            end
        end
    end
end

function u5.DrawSeconds(a1) -- Line: 84 -- upvalues: u13 (val), u5 (val) -- types: a1: string
    local v1 = u13[a1]
    return u5.PulloutSeconds(if not v1 then nil else v1.Equip)
end

function u5.MinShotInterval(a1) -- Line: 90 -- upvalues: u5 (val)
    local v1 = a1.FireRate or 0
    local FireModes = a1.FireModes
    if FireModes ~= nil then
        if FireModes.Primary ~= nil and FireModes.Primary.FireRate ~= nil then
            v1 = math.min(v1, FireModes.Primary.FireRate)
        end
        if FireModes.Secondary ~= nil and FireModes.Secondary.FireRate ~= nil then
            v1 = math.min(v1, FireModes.Secondary.FireRate)
        end
    end
    if a1.ShootingOptions == "Burst" then
        v1 = math.min(v1, (u5.BURST_SHOT_INTERVAL * u5.BURST_SHOT_COUNT + u5.BURST_COOLDOWN) / u5.BURST_SHOT_COUNT)
    end
    return v1
end

function u5.ReloadSeconds(a1) -- Line: 109 -- upvalues: u13 (val) -- types: a1: string
    local v1 = u13[a1]
    if v1 then
        return v1.Reload
    end
    return nil
end

return (table.freeze(u5))