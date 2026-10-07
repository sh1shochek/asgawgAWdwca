-- ReplicatedStorage.Components.Weapon.Classes.Bullet
-- Script path: ReplicatedStorage.Components.Weapon.Classes.Bullet
-- Decompile time: 6.70 ms

local u0 = {}
u0.__index = u0
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local RunServiceController = require((ReplicatedStorage:WaitForChild("Controllers")):WaitForChild("RunServiceController"))
local LocalPlayer = Players.LocalPlayer
local GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Raycast = require(ReplicatedStorage.Shared.Raycast)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local Spring = require(ReplicatedStorage.Shared.Spring)
local RuntimeKinematics = require(ReplicatedStorage.MovementV2.RuntimeKinematics)
local castThroughDistance = Raycast.castThroughDistance
local CurrentCamera = workspace.CurrentCamera
local min = math.min
local rad = math.rad
local max = math.max
local abs = math.abs

local function getSpreadConfig(a1) -- Line: 52
    return a1.ActiveSpreadConfig or a1.Properties.Spread
end

local function getCharacterSpeedForSpread(a1) -- Line: 56
    if 6.4 <= a1.CharacterSpeed then
        return a1.CharacterSpeed
    end
    return 0
end

local function getRawBaseSpread(a1) -- Line: 61
    local v1 = a1.Spread:getPosition()
    if type(v1) == "number" then
        return v1
    end
    return 0
end

local function clampBaseSpreadForConfig(a1, a2) -- Line: 66 -- types: a1: number
    if not a2 then
        return a1
    end
    return (math.clamp(a1, a2.Range.Min, a2.Range.Max))
end

local function getNoScopeMinSpread(a1) -- Line: 75
    local MovementMultiplier = a1 and a1.MovementMultiplier or 1
    if MovementMultiplier == 2 then
        return 6
    end
    if MovementMultiplier == 3 then
        return 12
    end
    return 15
end

local function resetMovementSpreadState(a1) -- Line: 80
    a1.CharacterSpeed = 0
    a1.isInAir = false
    a1.jumpStartSpeed = nil
    a1.verticalVelocity = 0
    a1.isAtJumpPeak = false
end

local function updateCharacterSpeed(a1) -- Line: 88 -- upvalues: CharacterResolver (val), RuntimeKinematics (val)
    local v1, v2, v3, v4
    local v5 = CharacterResolver.getLocalCharacter()
    if not v5 then
        a1.CharacterSpeed = 0
        a1.isInAir = false
        a1.jumpStartSpeed = nil
        a1.verticalVelocity = 0
        a1.isAtJumpPeak = false
        return
    end
    v1, _, v2, v3, v4 = RuntimeKinematics.resolve(v5, v5.PrimaryPart)
    a1.verticalVelocity = v3
    local isInAir = a1.isInAir
    a1.isInAir = not v4
    local Properties = a1.Properties
    local ActiveSpreadConfig = a1.ActiveSpreadConfig or a1.Properties.Spread
    local Range = ActiveSpreadConfig and ActiveSpreadConfig.Range
    local Min = Range and Range.Min
    local PerShot = ActiveSpreadConfig and ActiveSpreadConfig.PerShot
    local MovementMultiplier = ActiveSpreadConfig and ActiveSpreadConfig.MovementMultiplier
    local v6 = false
    if Properties.AimingOptions == "SniperScope" then
        v6 = false
        if Properties.MuzzleType == "Sniper" then
            v6 = false
            if Min == 0 then
                v6 = false
                if PerShot == 0 then
                    v6 = MovementMultiplier == 2
                end
            end
        end
    end
    a1.isAtJumpPeak = v6 and a1.isInAir and (math.abs(a1.verticalVelocity)) <= 3
    if not a1.isInAir then
        if not a1.isInAir and isInAir then
            a1.jumpStartSpeed = nil
            a1.isAtJumpPeak = false
        end
    elseif not isInAir then
        a1.jumpStartSpeed = v1.Magnitude + (ActiveSpreadConfig and ActiveSpreadConfig.JumpShotMinimum or 100)
    elseif not a1.isInAir and isInAir then
        a1.jumpStartSpeed = nil
        a1.isAtJumpPeak = false
    end
    if a1.isInAir and a1.jumpStartSpeed then
        if v6 and a1.isAtJumpPeak then
            a1.CharacterSpeed = v2
            return
        end
        a1.CharacterSpeed = a1.jumpStartSpeed
        return
    end
    a1.CharacterSpeed = v1.Magnitude
end

local function isSpreadSettled(a1) -- Line: 137
    local v1 = a1.Spread:getPosition()
    local v2 = a1.Spread:getGoal()
    local v3 = a1.Spread:getVelocity()
    if type(v1) == "number" and type(v2) == "number" and type(v3) == "number" then
        local v4 = false
        if (math.abs(v1 - v2)) <= 0.001 then
            v4 = (math.abs(v3)) <= 0.001
        end
        return v4
    end
    return false
end

local function stopSpreadRecovery(a1) -- Line: 149
    if a1.SpreadRecoveryConnection then
        a1.SpreadRecoveryConnection:Disconnect()
        a1.SpreadRecoveryConnection = nil
    end
end

local function ensureSpreadRecovery(a1) -- Line: 156 -- upvalues: RunServiceController (val)
    if not a1.IsDestroyed and not a1.SpreadRecoveryConnection then
        a1.SpreadRecoveryConnection = RunServiceController.BindToStepped(("%*.SpreadRecovery"):format(a1.BindingName), function(a1_2, a2) -- Line: 163 -- upvalues: a1 (val) -- types: a1_2: number, a2: number
            a1:updateSpread(a2)
        end)
        return
    end
end

function u0:_performRaycast(a2) -- Line: 172
    -- upvalues: GetRayIgnore (val), CurrentCamera (val), min (val), rad (val), abs (val), castThroughDistance (val)
    local v1, v2
    local v3 = GetRayIgnore()
    local v4 = CurrentCamera.ViewportSize * 0.5
    local v5 = CurrentCamera:ViewportPointToRay(v4.X, v4.Y)
    local v6 = min(a2, 69)
    local v7 = math.floor((os.clock()) * 1000000 % 2147483647)
    local v8 = Random.new(v7)
    local v9 = {Theta = v8:NextNumber(-3.141592653589793, 3.141592653589793)}
    v9.Phi = v8:NextNumber(0, (rad(v6 * 0.5)))
    local Direction = v5.Direction
    local Unit = 0 < Direction.Magnitude and Direction.Unit or Vector3.new(0, 0, 1)
    local v10 = if not (0.9999 < (abs(Unit.Y))) then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)
    local v11 = CFrame.lookAlong(Vector3.new(0, 0, 0), Unit, v10)
    local v12 = CFrame.Angles(0, 0, v9.Theta)
    local v13 = CFrame.Angles(v9.Phi, 0, 0)
    local LookVector = (v11 * v12 * v13).LookVector
    local Origin = v5.Origin
    local v14 = self.Properties.Penetration or 0
    local v15 = self.Properties.Range or 500
    local v16 = {Distance = 0, Origin = Origin, Direction = LookVector}
    v16.Hits = {}
    local v17 = castThroughDistance(Origin, LookVector * v15, v14, v3)
    local v18 = v17[1]
    if not v18 then
        v16.Distance = v15
        return v16
    end
    v16.Distance = (v18.position - Origin).Magnitude
    local Hits = v16.Hits
    local v19 = #v17
    for i = 1, v19 do
        v1 = v17[i]
        if v1.instance and v1.material then
            v2 = #Hits + 1
            Hits[v2] = {
                Position = v1.position,
                Instance = v1.instance,
                Material = v1.material.Name,
                Normal = v1.normal or Vector3.new(0, 0, 0),
                Exit = i % 2 == 0,
            }
        end
    end
    return v16
end

function u0.setSpreadConfig(a1, a2) -- Line: 240
    local ActiveSpreadConfig = a1.ActiveSpreadConfig or a1.Properties.Spread
    a1.ActiveSpreadConfig = a2
    local ActiveSpreadConfig_2 = a1.ActiveSpreadConfig or a1.Properties.Spread
    assert(ActiveSpreadConfig_2, "Weapon properties missing spread configuration")
    a1.Spread:setFrequency(ActiveSpreadConfig_2.RecoverySpeed)
    if ActiveSpreadConfig == ActiveSpreadConfig_2 then
        return
    end
    local v1 = a1.Spread:getPosition()
    local Min = ActiveSpreadConfig_2.Range.Min
    local Max = ActiveSpreadConfig_2.Range.Max
    a1.Spread:reset((math.clamp(if type(v1) ~= "number" then 0 else v1, Min, Max)))
    a1.Spread:setGoal(ActiveSpreadConfig_2.Range.Min)
end

function u0.create(a1, a2, a3) -- Line: 261 -- upvalues: max (val) -- types: a2: string?, a3: boolean?
    local v1, v2
    a1.LastShotTick = tick()
    if a2 == "SniperScope" and not a3 then
        local ActiveSpreadConfig = a1.ActiveSpreadConfig or a1.Properties.Spread
        local MovementMultiplier = ActiveSpreadConfig and ActiveSpreadConfig.MovementMultiplier or 1
        v1 = if MovementMultiplier ~= 2 then if MovementMultiplier ~= 3 then 15 else 12 else 6
        v2 = a1.Spread:getPosition()
        if (if type(v2) ~= "number" then 0 else v2) < v1 then
            a1.Spread:setPosition(v1)
        end
    end
    v1 = a3
    local Weapon = a1.Weapon
    if a2 == "SniperScope" and a3 and Weapon.Name == "AWP" and tick() - (Weapon.ScopeStartTick or 0) < 0.2 then
        v1 = false
    end
    v2 = a1:getTrueSpread()
    if a3 and not v1 then
        local ActiveSpreadConfig_2 = a1.ActiveSpreadConfig or a1.Properties.Spread
        local MovementMultiplier_2 = ActiveSpreadConfig_2 and ActiveSpreadConfig_2.MovementMultiplier or 1
        v2 = max(v2, if MovementMultiplier_2 ~= 2 then if MovementMultiplier_2 ~= 3 then 15 else 12 else 6)
    end
    a1:_updateShotSpread(a2, v1)
    return a1:_performRaycast(v2)
end

function u0:getTrueSpread() -- Line: 298
    local ActiveSpreadConfig = self.ActiveSpreadConfig or self.Properties.Spread
    return self:getSpreadForConfig(ActiveSpreadConfig)
end

function u0.getBaseSpread(a1) -- Line: 302
    local v1 = a1.Spread:getPosition()
    if type(v1) == "number" then
        return v1
    end
    return 0
end

function u0:getBaseSpreadForConfig(a2) -- Line: 306
    local ActiveSpreadConfig = a2 or self.ActiveSpreadConfig or self.Properties.Spread
    local v1 = self.Spread:getPosition()
    local v2 = if type(v1) ~= "number" then 0 else v1
    if not ActiveSpreadConfig then
        return v2
    end
    return (math.clamp(v2, ActiveSpreadConfig.Range.Min, ActiveSpreadConfig.Range.Max))
end

function u0:getMovementSpreadForConfig(a2) -- Line: 311
    local CharacterSpeed = if not (6.4 <= self.CharacterSpeed) then 0 else self.CharacterSpeed
    local ActiveSpreadConfig = a2 or self.ActiveSpreadConfig or self.Properties.Spread
    return CharacterSpeed * (if not ActiveSpreadConfig then 1 else ActiveSpreadConfig.MovementMultiplier)
end

function u0:getSpreadForConfig(a2) -- Line: 318
    local ActiveSpreadConfig = a2 or self.ActiveSpreadConfig or self.Properties.Spread
    return (self:getBaseSpreadForConfig(ActiveSpreadConfig)) + self:getMovementSpreadForConfig(ActiveSpreadConfig)
end

function u0.setBaseSpreadForConfig(a1, a2, a3) -- Line: 324 -- types: a2: number
    local ActiveSpreadConfig = a3 or a1.ActiveSpreadConfig or a1.Properties.Spread
    assert(ActiveSpreadConfig, "Weapon properties missing spread configuration")
    a1.Spread:setPosition(if ActiveSpreadConfig then math.clamp(a2, ActiveSpreadConfig.Range.Min, ActiveSpreadConfig.Range.Max) else a2)
end

function u0:updateSpread(a2) -- Line: 335 -- upvalues: isSpreadSettled (val) -- types: a2: number
    self.Spread:update(a2)
    if not self.IsActive and isSpreadSettled(self) then
        self.Spread:reset((self.Spread:getGoal()))
        if self.SpreadRecoveryConnection then
            self.SpreadRecoveryConnection:Disconnect()
            self.SpreadRecoveryConnection = nil
        end
    end
end

function u0:setActive(a2) -- Line: 344
    -- upvalues: updateCharacterSpeed (val), RunServiceController (val)
    if not self.IsDestroyed and self.IsActive ~= a2 then
        self.IsActive = a2
        if a2 then
            updateCharacterSpeed(self)
            if not self.IsDestroyed and not self.SpreadRecoveryConnection then
                self.SpreadRecoveryConnection = RunServiceController.BindToStepped(("%*.SpreadRecovery"):format(self.BindingName), function(a1, a2) -- Line: 163 -- upvalues: self (val) -- types: a1: number, a2: number
                    self:updateSpread(a2)
                end)
            end
            self.CharacterSpeedConnection = RunServiceController.BindToHeartbeat(("%*.CharacterSpeed"):format(self.BindingName), function() -- Line: 366 -- upvalues: updateCharacterSpeed (upval), self (val)
                updateCharacterSpeed(self)
            end)
            return
        end
        if self.CharacterSpeedConnection then
            self.CharacterSpeedConnection:Disconnect()
            self.CharacterSpeedConnection = nil
        end
        self.CharacterSpeed = 0
        self.isInAir = false
        self.jumpStartSpeed = nil
        self.verticalVelocity = 0
        self.isAtJumpPeak = false
        return
    end
end

function u0:_updateShotSpread(a2, a3) -- Line: 372 -- types: a2: string?, a3: boolean?
    local ActiveSpreadConfig = self.ActiveSpreadConfig or self.Properties.Spread
    assert(ActiveSpreadConfig, "Weapon properties missing spread configuration")
    local Range = ActiveSpreadConfig.Range
    local Min = Range.Min
    local Max = Range.Max
    if a2 == "SniperScope" then
        if not a3 then
            local MovementMultiplier = ActiveSpreadConfig and ActiveSpreadConfig.MovementMultiplier or 1
            Min = if MovementMultiplier ~= 2 then if MovementMultiplier ~= 3 then 15 else 12 else 6
        else
            Min = 0
        end
    end
    local v1 = self.Spread:getPosition()
    self.Spread:setPosition((math.clamp((if type(v1) ~= "number" then 0 else v1) + ActiveSpreadConfig.PerShot, Min, Max)))
end

function u0.new(a1, a2) -- Line: 392 -- upvalues: u0 (val), Janitor (val), Spring (val), RunServiceController (val)
    local v1 = setmetatable({}, u0)
    v1.Janitor = Janitor.new()
    v1.IsDestroyed = false
    v1.Properties = a2
    v1.Weapon = a1
    v1.CharacterSpeed = 0
    v1.isInAir = false
    v1.jumpStartSpeed = nil
    v1.verticalVelocity = 0
    v1.isAtJumpPeak = false
    local Spread = a2.Spread
    assert(Spread, "Weapon properties missing spread configuration")
    v1.Spread = Spring.new(1, Spread.RecoverySpeed, Spread.Range.Min)
    v1.LastShotTick = 0
    v1.IsActive = false
    v1.BindingName = RunServiceController.CreateBindingName("Components.Bullet")
    return v1
end

function u0.destroy(a1) -- Line: 424
    if a1.IsDestroyed then
        return
    end
    a1:setActive(false)
    if a1.SpreadRecoveryConnection then
        a1.SpreadRecoveryConnection:Disconnect()
        a1.SpreadRecoveryConnection = nil
    end
    a1.IsDestroyed = true
    a1.Janitor:Destroy()
    a1.Properties = nil
    a1.Weapon = nil
    a1.Spread = nil
    a1.Janitor = nil
end

return u0