-- ReplicatedStorage.Components.Common.BotWeaponEffects
-- Script path: ReplicatedStorage.Components.Common.BotWeaponEffects
-- Decompile time: 1.02 ms

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EmitParticles = require(script.Parent.VFXLibary.CreateMuzzleFlash.EmitParticles)
local CreateTracer = require(script.Parent.VFXLibary.CreateTracer)
local Sound = require(ReplicatedStorage.Classes.Sound)
local FlashEffect = require(script.Parent.VFXLibary.FlashEffect)
local v1 = {}

local function playSound(a1, a2, a3, a4) -- Line: 14
    -- upvalues: ReplicatedStorage (val), Sound (val), Players (val), FlashEffect (val)
    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")
    local v1 = if not Sounds then nil else Sounds:FindFirstChild(a1)
    if v1 ~= nil and v1:FindFirstChild(a2) ~= nil then
        local v2 = Sound.new(a1)
        if not a4 then
            v2:PlaySoundAtPosition({Class = a1, Name = a2, Position = a3}, nil, (FlashEffect.GetAudioFadeMultiplier()))
            return
        end
        v2:play({Parent = Players.LocalPlayer.PlayerGui, Name = a2}, (FlashEffect.GetAudioFadeMultiplier()))
        v2:destroy()
        return
    end
end

function v1.shoot(a1, a2, a3, a4) -- Line: 33
    -- upvalues: EmitParticles (val), CreateTracer (val), playSound (val)
    local v1 = #a1.Muzzles
    if v1 == 0 then
        return
    end
    local v2 = a1.Muzzles[a3 % v1 + 1]
    local v3 = if not a1.MuzzleType then nil else v2:FindFirstChild(a1.MuzzleType)
    if v3 and not a4 then
        EmitParticles(v3)
    end
    local v4 = a2 - v2.Position
    if 0.0001 < v4.Magnitude and not a4 then
        CreateTracer(v4.Magnitude, v2.Position, v4.Unit, true)
    end
    playSound(a1.Name, "Shoot", v2.Position, a4)
end

function v1.reloadSound(a1, a2, a3) -- Line: 50 -- upvalues: playSound (val) -- types: a2: userdata, a3: boolean?
    playSound(a1.Name, "MagOut", a2.Position, a3)
end

return table.freeze(v1)