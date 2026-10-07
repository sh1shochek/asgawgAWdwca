-- ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel.Classes.Bobble
-- Script path: ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel.Classes.Bobble
-- Decompile time: 4.44 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Spring = require(ReplicatedStorage.Shared.Spring)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local CurrentCamera = workspace.CurrentCamera
local u36 = Vector2.new(0.02, 0.015) / 50

local function removeY(a1) -- Line: 38 -- types: a1: vector
    return a1 * Vector3.new(1, 0, 1)
end

local function toVector3(a1) -- Line: 42 -- types: a1: userdata
    return (Vector3.new(a1.X, a1.Y, 0))
end

local function toggleScopeVisibility(a1, a2) -- Line: 46 -- types: a1: userdata, a2: boolean
    local v1
    local v2 = a2
    for k, v in pairs(a1:GetDescendants()) do
        if v:IsA("MeshPart") then
            v1 = if v2 ~= true then 1 else 0
            v.Transparency = v1
        elseif v:IsA("SurfaceGui") then
            v.Enabled = v2
        end
    end
end

local function applySkinToScope(a1, a2) -- Line: 56 -- types: a1: userdata, a2: userdata
    if a1.ClassName == "Model" and a2.ClassName == "Model" then
        local SurfaceAppearance, v1, v2

        local function clearSurfaceAppearances(a1) -- Line: 59 -- types: a1: userdata
            for k, v in pairs(a1:GetChildren()) do
                if v.ClassName == "SurfaceAppearance" then
                    v:Destroy()
                end
            end
        end

        for k, v in pairs(a1:GetChildren()) do
            v2 = a2:FindFirstChild(v.Name)
            if v2 then
                SurfaceAppearance = v2:FindFirstChildWhichIsA("SurfaceAppearance")
                if SurfaceAppearance then
                    v1 = SurfaceAppearance:Clone()
                    v1.Name = v2.Name
                    clearSurfaceAppearances(v)
                    v1.Parent = v
                end
            end
        end
        return
    end
end

function u0.addScopeKick(a1) -- Line: 82
    if not a1.IsDestroyed and a1.ScopeSpring then
        a1.ScopeSpring:impulse((Vector2.new(5, 1)))
        return
    end
end

function u0:getMovementVelocity() -- Line: 91 -- upvalues: RuntimeKinematics (val), CurrentCamera (val)
    local v1, v2
    local Character = self.Character
    if not Character then
        self.IsInAir = false
        return Vector3.new(0, 0, 0), (Vector3.new(0, 0, 0))
    end
    v1, _, _, _, v2 = RuntimeKinematics.resolve(Character, Character.PrimaryPart)
    self.IsInAir = not v2
    if not (0.1 < v1.Magnitude) then
        return Vector3.new(0, 0, 0), (Vector3.new(0, 0, 0))
    end
    local v3 = v1.Unit * math.min(v1.Magnitude, 50)
    return v3, CurrentCamera.CFrame:VectorToObjectSpace(v3)
end

function u0.getNextCFrame(a1, a2) -- Line: 108 -- upvalues: CurrentCamera (val), u36 (val) -- types: a2: number
    if a1.IsDestroyed then
        return CFrame.identity, Vector3.new(0, 0, 0), (Vector3.new(0, 0, 0))
    end
    if a2 <= 0 or a2 ~= a2 then
        a2 = 0.016666666666666666
    end
    local v1, v2 = a1:getMovementVelocity()
    local v3 = v1 * Vector3.new(1, 0, 1)
    local v4 = v2 * Vector3.new(1, 0, 1)
    local Magnitude_2 = v1.Magnitude
    local Magnitude = v3.Magnitude
    local CFrame_2 = CurrentCamera.CFrame
    local v5, v6 = CFrame_2:ToObjectSpace(a1.LastCameraCFrame):ToOrientation()
    local v7 = Vector2.new(v5, v6) / a2
    local v8 = a1.RenderTime + a2 * Magnitude_2 * 0.1
    local Y = v7.Y
    local v9 = -v7.X
    local v10 = Vector3.new(0.0011111111380159855, 0.0011111111380159855, 0) * Vector3.new(Y, v9, 0)
    if v10 ~= v10 then
        v10 = Vector3.new(0, 0, 0)
    end
    local X = v4.X
    local v11 = -Magnitude
    local v12 = math.max(math.abs(v4.X), (math.abs(v2.Z)))
    local v13 = Vector3.new(0.00039999998989515007, 0.000699999975040555, 0.0010999999940395355) * Vector3.new(X, v11, v12)
    local v14 = (Vector2.new(math.sin(v8 * 3.141592653589793 * 2), (math.sin(v8 * 3.141592653589793 * 4)))) * (u36 * 0.5) * Magnitude
    if a1.IsInAir then
        v13 = v13 + Vector3.new(0, -0.019999999552965164, 0)
        v14 = v14 * 0.3
    end
    a1.MovementShiftSpring:setGoal(v13)
    a1.CameraShiftSpring:setGoal(v10)
    a1.BobbleSpring:setGoal(v14)
    a1.ScopeSpring:setGoal(Vector2.zero)
    a1.MovementShiftSpring:update(a2)
    a1.CameraShiftSpring:update(a2)
    a1.BobbleSpring:update(a2)
    a1.ScopeSpring:update(a2)
    a1.LastCameraCFrame = CFrame_2
    a1.RenderTime = v8
    local v15 = a1.MovementShiftSpring:getPosition()
    v9 = a1.CameraShiftSpring:getPosition()
    v12 = a1.BobbleSpring:getPosition()
    v11 = Vector3.new(v12.X, v12.Y, 0)
    v12 = a1.ScopeSpring:getPosition()
    local v16 = math.rad(-v15.X * 250)
    local v17 = 0
    if a1.IsAiming then
        v17 = 0.08726646259971647
        v16 = 0
    end
    local v18 = v15 + v9 + v11
    local v19 = v11 + v15
    local v20 = Vector3.new(v12.X, v12.Y, 0)
    return (CFrame.new(v18)) * CFrame.Angles(0, v17, v16), v19, v20
end

function u0.setIsAiming(a1, a2) -- Line: 189 -- upvalues: toggleScopeVisibility (val) -- types: a2: boolean
    a1.IsAiming = a2
    toggleScopeVisibility(a1.Scope, a2)
    toggleScopeVisibility(a1.ScopeReticlePart, a2)
end

function u0.setModel(a1, a2) -- Line: 198
    -- upvalues: CurrentCamera (val), toggleScopeVisibility (val), applySkinToScope (val)
    if not a2 then
        return
    end
    if a1.Scope then
        a1.Scope:Destroy()
        a1.Scope = nil
    end
    if a1.ScopeReticlePart then
        a1.ScopeReticlePart:Destroy()
        a1.ScopeReticlePart = nil
    end
    local Name = a2.Name
    if Name == "AUG" or Name == "SG 553" then
        local Weapon = a2:FindFirstChild("Weapon")
        if Weapon and Weapon:FindFirstChild("ScopeSplit") then
            local ScopeSplit = Weapon.ScopeSplit
            local Part = ScopeSplit:FindFirstChild("Part")
            if Part then
                a1.ScopeReticlePart = a1.Janitor:Add((Part:Clone()))
                a1.ScopeReticlePart.Parent = CurrentCamera
            end
            local v1 = a1.Janitor:Add((ScopeSplit:Clone()))
            a1.Scope = v1
            v1.Parent = CurrentCamera
            toggleScopeVisibility(v1, false)
            if Name == "AUG" then
                local Part_2 = v1:FindFirstChild("Part")
                local SurfaceGui = Part_2 and Part_2:FindFirstChild("SurfaceGui")
                local Frame = SurfaceGui and SurfaceGui:FindFirstChild("Frame")
                if Frame then
                    Frame.Visible = false
                end
            end
            applySkinToScope(v1, Weapon)
            ScopeSplit:Destroy()
        end
    end
end

function u0.new(a1) -- Line: 247
    -- upvalues: u0 (val), Janitor (val), CharacterResolver (val), Spring (val), CurrentCamera (val)
    local u4 = setmetatable({}, u0)
    u4.Janitor = Janitor.new()
    u4.IsDestroyed = false
    local Character = a1.Character or CharacterResolver.getPlayerCharacter(a1.Player)
    u4.Character = Character
    u4.IsAiming = false
    u4.CameraShiftSpring = Spring.new(0.7, 18, (Vector3.new(0, 0, 0)))
    u4.MovementShiftSpring = Spring.new(1, 15, (Vector3.new(0, 0, 0)))
    u4.BobbleSpring = Spring.new(1, 20, Vector2.zero)
    u4.ScopeSpring = Spring.new(1, 20, Vector2.zero)
    u4.LastCameraCFrame = CurrentCamera.CFrame
    u4.RenderTime = 0
    u4.IsInAir = false
    if not a1.Character then
        u4.Janitor:Add((CharacterResolver.observeCharacter(a1.Player, function(a1) -- Line: 277 -- upvalues: u4 (val)
            u4.Character = a1
            return function() end
        end)))
    end
    return u4
end

function u0.destroy(a1) -- Line: 290
    if a1.IsDestroyed then
        return
    end
    a1.IsDestroyed = true
    a1.Janitor:Destroy()
    a1.Janitor = nil
    a1.CameraShiftSpring = nil
    a1.MovementShiftSpring = nil
    a1.BobbleSpring = nil
    a1.ScopeSpring = nil
    a1.Character = nil
    a1.Scope = nil
    a1.ScopeReticlePart = nil
end

return u0