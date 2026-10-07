-- ReplicatedStorage.Classes.WeaponComponent.Classes.CharacterAnimator
-- Script path: ReplicatedStorage.Classes.WeaponComponent.Classes.CharacterAnimator
-- Decompile time: 1.39 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CharacterAnimator = require(ReplicatedStorage.Classes.Character.Classes.CharacterAnimator)
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local CharacterResolver = require(ReplicatedStorage.Components.Common.CharacterResolver)
local Janitor = require(ReplicatedStorage.Shared.Janitor)
local u25 = {}
u25.__index = u25

local function bind(a1, a2) -- Line: 30
    -- upvalues: CharacterAnimator (val), GetWeaponProperties (val)
    if a1._animator then
        a1._animator:destroy()
        a1._animator = nil
        a1.Animations = {}
    end
    if not a1.IsDestroyed and a2 then
        local v1 = CharacterAnimator.new(a2, {SkipBaseAnimations = true})
        v1.Player = a1.Player
        v1.WeaponName = a1.Weapon
        local v2 = GetWeaponProperties(a1.Weapon)
        local CharacterAnimations = v2 and v2.CharacterAnimations
        if CharacterAnimations then
            for i, v in ipairs(CharacterAnimations:GetChildren()) do
                if v:IsA("Animation") then
                    v1:register(v.Name, v)
                    v1.WeaponAnimationNames[v.Name] = true
                end
            end
        end
        a1._animator = v1
        a1.Animations = v1.Animations
        return
    end
end

function u25.getAnimation(a1, a2) -- Line: 63 -- types: a2: string
    return a1.Animations[a2]
end

function u25:play(a2, ...) -- Line: 67 -- types: a2: string
    local _animator = self._animator
    if _animator then
        return (_animator:play(a2, ...))
    end
    return nil
end

function u25:stop(a2, ...) -- Line: 72 -- types: a2: string
    local _animator = self._animator
    if _animator then
        _animator:stop(a2, ...)
    end
end

function u25:stopAnimations(a2) -- Line: 79 -- types: a2: number?
    local _animator = self._animator
    if _animator then
        _animator:stopAnimations(a2)
    end
end

function u25:adjustAnimationSpeed(a2, a3) -- Line: 86 -- types: a2: string, a3: number
    local _animator = self._animator
    if _animator then
        _animator:adjustAnimationSpeed(a2, a3)
    end
end

function u25.new(a1, a2, a3) -- Line: 96
    -- upvalues: u25 (val), Janitor (val), bind (val), CharacterResolver (val)
    local u6 = setmetatable({}, u25)
    u6.Janitor = Janitor.new()
    u6.IsDestroyed = false
    u6.Player = a1
    u6.Weapon = a2
    u6.Animations = {}
    if a3 then
        bind(u6, a3)
        return u6
    end
    u6.Janitor:Add((CharacterResolver.observeCharacter(a1, function(a1) -- Line: 108 -- upvalues: bind (upval), u6 (val)
        bind(u6, a1)
    end)))
    return u6
end

function u25:destroy() -- Line: 119
    if self.IsDestroyed then
        return
    end
    self.IsDestroyed = true
    if self._animator then
        self._animator:destroy()
        self._animator = nil
    end
    self.Animations = {}
    self.Janitor:Destroy()
end

return u25