-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Observers = require(ReplicatedStorage.Packages.Observers);
local script_Bomb = require(script.Bomb);

return Observers.observeTag("Bomb", function(p1) -- Line: 13
    -- upvalues: script_Bomb (copy)
    local u2 = script_Bomb.new(p1);

    return function() -- Line: 15
        -- upvalues: u2 (copy)
        u2:destroy();
    end;
end);