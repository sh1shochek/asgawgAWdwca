-- ReplicatedStorage.Controllers.Observers.Game.WeaponDropped
-- Script path: ReplicatedStorage.Controllers.Observers.Game.WeaponDropped
-- Decompile time: 0.26 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Weapon = require(script.Weapon)
return Observers.observeTag("WeaponDropped", function(a1) -- Line: 13 -- upvalues: Weapon (val) -- types: a1: userdata
    local u4 = Weapon.new(a1)
    return function() -- Line: 15 -- upvalues: u4 (val)
        u4:destroy()
    end
end)