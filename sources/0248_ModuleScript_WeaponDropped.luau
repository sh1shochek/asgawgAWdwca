-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local script_Weapon = require(script.Weapon);

return Observers.observeTag("WeaponDropped", function(p1: userdata) -- Line: 13
    -- upvalues: script_Weapon (copy)
    local u2 = script_Weapon.new(p1);

    return function() -- Line: 15
        -- upvalues: u2 (copy)
        u2:destroy();
    end;
end);