-- ReplicatedStorage.Components.Common.BotWeaponRecoil
-- Script path: ReplicatedStorage.Components.Common.BotWeaponRecoil
-- Decompile time: 1.24 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Spring = require(ReplicatedStorage.Shared.Spring)
local GetWeaponProperties = require(script.Parent.GetWeaponProperties)
local u14 = {}
u14.__index = u14

function u14.new(a1) -- Line: 9 -- upvalues: GetWeaponProperties (val), Spring (val), u14 (val) -- types: a1: string
    local v1 = GetWeaponProperties(a1)
    local Recoil = v1 and v1.Recoil
    if Recoil and type(Recoil.Pattern) == "function" then
        return (setmetatable({
            PatternTime = 0,
            RecoveryTime = 0,
            Properties = v1,
            Pattern = Recoil.Pattern(v1),
            Spring = Spring.new(Recoil.Damper, Recoil.Speed, Vector2.zero),
            Value = Vector2.zero,
        }, u14))
    end
    return nil
end

function u14:Step(a2) -- Line: 25 -- types: self: table, a2: number
    local v1 = if not self.LastUpdate then 0 else math.max(0, a2 - self.LastUpdate)
    local v2 = if not self.LastShot then a2 else self.LastShot + self.Properties.FireRate
    local v3 = math.max(0, a2 - (math.max(self.LastUpdate or a2, v2)))
    local RecoverySpeed = self.Properties.Recoil.RecoverySpeed
    if v3 > 0 then
        local Magnitude = self.Value.Magnitude
        local Value_2 = if not (Magnitude > 0) then self.Value else self.Value * math.max(0, 1 - RecoverySpeed * v3 / Magnitude)
        self.Value = Value_2
        self.PatternTime = math.max(0, self.PatternTime - self.RecoveryTime * RecoverySpeed * v3)
    end
    self.Spring:setGoal(self.Value)
    self.Spring:update(v1)
    self.LastUpdate = a2
    return (self.Spring:getPosition()) * math.rad(self.Properties.Recoil.Scale) * self.Properties.Recoil.CameraScale
end

function u14.OnShot(a1, a2) -- Line: 41 -- types: a1: table, a2: number
    a1:Step(a2)
    a1.LastShot = a2
    a1.PatternTime = a1.PatternTime + a1.Properties.FireRate
    a1.RecoveryTime = a1.PatternTime
    a1.Value = a1.Pattern(a1.PatternTime)
    a1.Spring:setGoal(a1.Value)
end

return table.freeze(u14)