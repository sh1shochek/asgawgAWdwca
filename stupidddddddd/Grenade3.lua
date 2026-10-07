-- ReplicatedStorage.Controllers.Observers.Game.Grenade
-- Script path: ReplicatedStorage.Controllers.Observers.Game.Grenade
-- Decompile time: 6.03 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local GrenadeSimulator = require(ReplicatedStorage.Shared.GrenadeSimulator)
local Sound = require(ReplicatedStorage.Classes.Sound)
local Debris = workspace:WaitForChild("Debris")
local u40 = {}

local function hideAsDebris(a1) -- Line: 49 -- types: a1: userdata
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CollisionGroup = "Debris"
            v.Transparency = 1
            v.CanCollide = false
            v.CanTouch = false
            v.CanQuery = false
        end
    end
end

local function destroyAfter(a1, a2) -- Line: 61 -- types: a1: userdata, a2: number
    task.delay(a2, function() -- Line: 62 -- upvalues: a1 (val)
        if a1.Parent then
            a1:Destroy()
        end
    end)
end

local function spawnImpactParticles(a1, a2, a3, a4) -- Line: 69
    -- upvalues: Debris (val), Sound (val)
    local v1 = a1:Add((a2:Clone()))
    v1.CFrame = CFrame.new(a3)
    v1.Parent = Debris
    v1.Anchored = true
    if a4 then
        (Sound.new(a4)):playOneTime({Name = "Explode", Parent = v1})
    end
    for i, v in ipairs(v1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            task.delay(v:GetAttribute("EmitDelay") or 0, function() -- Line: 84 -- upvalues: v (val)
                v:Emit((v:GetAttribute("EmitCount")) or 1)
            end)
        end
    end
end

local u44 = {}

u44["Decoy Grenade"] = function(a1, a2, a3) -- Line: 93 -- upvalues: hideAsDebris (val)
    hideAsDebris(a3)
    task.delay(0.5, function() -- Line: 62 -- upvalues: a3 (val)
        if a3.Parent then
            a3:Destroy()
        end
    end)
end

function u44.Flashbang(a1, a2, a3) -- Line: 98
    -- upvalues: hideAsDebris (val), ReplicatedStorage (val), spawnImpactParticles (val)
    hideAsDebris(a3)
    local Flashbang = ReplicatedStorage.Assets.GrenadeParticles:FindFirstChild("Flashbang")
    if Flashbang then
        spawnImpactParticles(a1, Flashbang, a2, nil)
    end
    task.delay(3, function() -- Line: 62 -- upvalues: a3 (val)
        if a3.Parent then
            a3:Destroy()
        end
    end)
end

u44["HE Grenade"] = function(a1, a2, a3) -- Line: 106 -- upvalues: hideAsDebris (val), spawnImpactParticles (val), ReplicatedStorage (val)
    hideAsDebris(a3)
    spawnImpactParticles(a1, ReplicatedStorage.Assets.GrenadeParticles["HE Grenade"], a2, "HE Grenade")
    task.delay(3, function() -- Line: 62 -- upvalues: a3 (val)
        if a3.Parent then
            a3:Destroy()
        end
    end)
end

local function createRaycastParams(a1, a2) -- Line: 116
    -- upvalues: Debris (val), CharacterResolver (val)
    local v1 = RaycastParams.new()
    v1.FilterType = Enum.RaycastFilterType.Exclude
    local v2 = {a1, Debris}
    local v3 = CharacterResolver.getLocalCharacter()
    if v3 then
        table.insert(v2, v3)
    end
    v1.FilterDescendantsInstances = v2
    v1.RespectCanCollide = false
    v1.IgnoreWater = true
    if a2 then
        v1.CollisionGroup = a2
    end
    return v1
end

local function startClientPrediction(a1) -- Line: 135
    -- upvalues: RunServiceController (val), GrenadeSimulator (val)
    local u1 = nil
    u1 = RunServiceController.BindToRenderStep(("Observers.Game.Grenade.%*.Predict"):format(a1.id), function(a1_2) -- Line: 137 -- upvalues: a1 (val), u1 (ref), GrenadeSimulator (upval)
        if a1.isResolved then
            u1:Disconnect()
            return
        end
        if not a1.model.Parent then
            u1:Disconnect()
            a1.isResolved = true
            return
        end
        a1.state = (GrenadeSimulator.simulate(a1.state, a1.config, a1.raycastParams, a1_2)).state
        a1.visualPosition = a1.visualPosition:Lerp(a1.state.position, (math.min(1, a1_2 * 20)))
        local Magnitude = a1.state.velocity.Magnitude
        if Magnitude < 2 then
            a1.angularVelocity = a1.angularVelocity * math.max(0, 1 - a1_2 * 8)
        elseif Magnitude < 5 then
            a1.angularVelocity = a1.angularVelocity * math.max(0, 1 - a1_2 * 3)
        end
        if 0.01 < a1.angularVelocity.Magnitude then
            local angularVelocity_3 = a1.angularVelocity
            a1.visualRotation = a1.visualRotation * (CFrame.fromAxisAngle(angularVelocity_3.Unit, angularVelocity_3.Magnitude * a1_2))
        end
        if a1.model.PrimaryPart then
            a1.model:PivotTo((CFrame.new(a1.visualPosition)) * a1.visualRotation)
        end
    end)
    a1.janitor:Add(u1, "Disconnect")
end

local function reconcileState(a1, a2, a3) -- Line: 177 -- types: a1: table, a2: vector, a3: vector
    local Magnitude = (a1.state.position - a2).Magnitude
    if Magnitude > 8 then
        a1.state.position = a2
        a1.state.velocity = a3
        a1.visualPosition = a2
        return
    end
    if Magnitude > 2 then
        a1.state.position = a1.state.position:Lerp(a2, 0.08)
        a1.state.velocity = a1.state.velocity:Lerp(a3, 0.08)
    end
end

Remotes.Projectile.Spawn.Listen(function(a1) -- Line: 194
    -- upvalues: ReplicatedStorage (val), Debris (val), Janitor (val), createRaycastParams (val), u40 (val)
    -- upvalues: RunServiceController (val), GrenadeSimulator (val)
    local Id = a1.Id
    local State = a1.State
    local Physics = a1.Physics
    task.defer(function() -- Line: 200
        -- upvalues: ReplicatedStorage (upval), a1 (val), Id (val), State (val), Debris (upval), Janitor (upval)
        -- upvalues: Physics (val), createRaycastParams (upval), u40 (upval), RunServiceController (upval)
        -- upvalues: GrenadeSimulator (upval)
        local v1 = ReplicatedStorage.Assets.Weapons:FindFirstChild(a1.Weapon)
        local Character = v1 and v1:FindFirstChild("Character")
        if not Character then
            warn("[Client Grenade] Base model not found for:", a1.Weapon)
            return
        end
        local v2 = Character:Clone()
        v2.Name = Id
        v2:PivotTo((CFrame.new(State.Position)))
        v2:SetAttribute("GrenadeName", a1.Weapon)
        v2:AddTag("Grenade")
        v2.Parent = Debris
        for i, j in v2:GetDescendants() do
            if j:IsA("BasePart") then
                j.Anchored = true
                j.CanCollide = false
            end
        end
        local v3 = Janitor.new()
        v3:Add(v2, "Destroy")
        local v4 = {
            angularVelocity = Vector3.new(0, 0, 0),
            simulationTime = 0,
            bounceCount = 0,
            isGrounded = false,
            isAtRest = false,
            hasTouched = false,
            accumulatedTime = 0,
        }
        v4.position = State.Position
        v4.velocity = State.Velocity
        local StartTime = State.StartTime or workspace:GetServerTimeNow()
        v4.timestamp = StartTime
        v4.isJumpThrow = State.IsJumpThrow or false
        local v5 = true
        if a1.Weapon ~= "Molotov" then
            v5 = a1.Weapon == "Incendiary Grenade"
        end
        local v6 = {
            rangeScale = 1,
            isNearThrow = false,
            radius = Physics.Radius,
            restitution = Physics.Restitution,
            maxBounces = Physics.MaxBounces,
        }
        v6.fuseTime = if not (0 < Physics.FuseTime) then nil else Physics.FuseTime
        v6.minimumFuseTime = if not v5 then nil else 0.1
        v6.explodeOnFloorImpact = if not v5 then nil else true
        local Velocity = State.Velocity
        local v7 = Vector3.new(0, 0, 0)
        if 1 < Velocity.Magnitude then
            local v8 = Velocity:Cross((Vector3.new(0, 1, 0)))
            v7 = (if not (0.1 < v8.Magnitude) then Vector3.new(1, 0, 0) else v8.Unit) * Velocity.Magnitude * 0.5
        end
        local u129 = {
            isResolved = false,
            id = Id,
            model = v2,
            state = v4,
            config = v6,
        }
        u129.raycastParams = createRaycastParams(v2, Physics.CollisionGroup)
        u129.visualPosition = State.Position
        u129.visualRotation = CFrame.identity
        u129.angularVelocity = v7
        u129.janitor = v3
        u40[Id] = u129
        local u164 = nil
        u164 = RunServiceController.BindToRenderStep(("Observers.Game.Grenade.%*.Predict"):format(u129.id), function(a1) -- Line: 137 -- upvalues: u129 (val), u164 (ref), GrenadeSimulator (upval)
            if u129.isResolved then
                u164:Disconnect()
                return
            end
            if not u129.model.Parent then
                u164:Disconnect()
                u129.isResolved = true
                return
            end
            u129.state = (GrenadeSimulator.simulate(u129.state, u129.config, u129.raycastParams, a1)).state
            u129.visualPosition = u129.visualPosition:Lerp(u129.state.position, (math.min(1, a1 * 20)))
            local Magnitude = u129.state.velocity.Magnitude
            if Magnitude < 2 then
                u129.angularVelocity = u129.angularVelocity * math.max(0, 1 - a1 * 8)
            elseif Magnitude < 5 then
                u129.angularVelocity = u129.angularVelocity * math.max(0, 1 - a1 * 3)
            end
            if 0.01 < u129.angularVelocity.Magnitude then
                local angularVelocity_3 = u129.angularVelocity
                u129.visualRotation = u129.visualRotation * (CFrame.fromAxisAngle(angularVelocity_3.Unit, angularVelocity_3.Magnitude * a1))
            end
            if u129.model.PrimaryPart then
                u129.model:PivotTo((CFrame.new(u129.visualPosition)) * u129.visualRotation)
            end
        end)
        u129.janitor:Add(u164, "Disconnect")
    end)
end)
Remotes.Projectile.Bounce.Listen(function(a1) -- Line: 281 -- upvalues: u40 (val), reconcileState (val)
    local v1 = u40[a1.Id]
    if not v1 then
        return
    end
    reconcileState(v1, a1.Position, a1.Velocity)
    v1.state.bounceCount = a1.BounceIndex
    v1.state.hasTouched = true
    local Velocity = a1.Velocity
    local v2 = Velocity - v1.state.velocity
    if 1 < v2.Magnitude then
        local Unit
        local v3 = v2:Cross(Velocity)
        if not (0.1 < v3.Magnitude) then
            v3 = Velocity:Cross((Vector3.new(0, 1, 0)))
            Unit = if not (0.1 < v3.Magnitude) then Vector3.new(1, 0, 0) else v3.Unit
        else
            Unit = v3.Unit
        end
        v1.angularVelocity = v1.angularVelocity + Unit * v2.Magnitude * 0.5
    end
end)
Remotes.Projectile.Resolve.Listen(function(a1) -- Line: 308 -- upvalues: u40 (val)
    local v1 = u40[a1.Id]
    if not v1 then
        return
    end
    v1.state.position = a1.Position
    v1.state.isAtRest = true
    v1.isResolved = true
    v1.angularVelocity = Vector3.new(0, 0, 0)
    if v1.model.PrimaryPart then
        v1.model:PivotTo((CFrame.new(a1.Position)) * v1.visualRotation)
    end
    v1.model:SetAttribute("SimulationFinished", true)
    u40[a1.Id] = nil
end)
return Observers.observeTag("Grenade", function(a1) -- Line: 332 -- upvalues: u44 (val), Janitor (val), u40 (val) -- types: a1: userdata
    local Attribute = a1:GetAttribute("GrenadeName")
    if not Attribute then
        return
    end
    local u6 = u44[Attribute]
    local u9 = Janitor.new()
    u9:Add(((a1:GetAttributeChangedSignal("SimulationFinished")):Connect(function() -- Line: 341 -- upvalues: a1 (val), u6 (val), u9 (val)
        local PrimaryPart = a1.PrimaryPart
        if PrimaryPart and a1:GetAttribute("SimulationFinished") then
            if u6 then
                u6(u9, PrimaryPart.Position, a1)
                return
            end
            for i, j in a1:GetDescendants() do
                if j:IsA("BasePart") then
                    j.Transparency = 1
                    j.CanCollide = false
                end
            end
            local u26 = a1
            task.delay(0.5, function() -- Line: 62 -- upvalues: u26 (val)
                if u26.Parent then
                    u26:Destroy()
                end
            end)
            return
        end
    end)))
    return function() -- Line: 362 -- upvalues: u40 (upval), a1 (val), u9 (val)
        local v1 = u40[a1.Name]
        if v1 then
            v1.isResolved = true
            u40[a1.Name] = nil
        end
        u9:Destroy()
    end
end)