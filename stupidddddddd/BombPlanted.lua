-- ReplicatedStorage.Controllers.Observers.Game.BombPlanted
-- Script path: ReplicatedStorage.Controllers.Observers.Game.BombPlanted
-- Decompile time: 0.25 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Bomb = require(script.Bomb)
return Observers.observeTag("Bomb", function(a1) -- Line: 13 -- upvalues: Bomb (val)
    local u4 = Bomb.new(a1)
    return function() -- Line: 15 -- upvalues: u4 (val)
        u4:destroy()
    end
end)