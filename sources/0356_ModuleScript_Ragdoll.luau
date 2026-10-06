-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Classes.Ragdoll.Types);
local Ragdoll = require(ReplicatedStorage.Classes.Ragdoll);

return {
    Replication = "All",

    Finisher = function(p1: userdata, p2: any) -- Line: 17, Name: Finisher
        -- upvalues: Ragdoll (copy)
        local u3 = Ragdoll.new(p1, p2);

        return {
            OnDestroy = u3.OnDestroy,

            Destroy = function() -- Line: 21, Name: Destroy
                -- upvalues: u3 (copy)
                u3:Destroy();
            end
        };
    end
};