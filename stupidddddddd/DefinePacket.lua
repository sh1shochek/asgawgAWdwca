-- ReplicatedStorage.Database.Security.Remotes.DefinePacket
-- Script path: ReplicatedStorage.Database.Security.Remotes.DefinePacket
-- Decompile time: 0.30 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Database.Security.Network)
return function(a1, a2) -- Line: 9 -- upvalues: Network (val)
    local u3 = a2
    if not u3 then
        u3 = {}
    end
    return function(a1_2, a2) -- Line: 12 -- upvalues: Network (upval), a1 (val), u3 (val) -- types: a1_2: string, a2: string
        return Network.CreatePacket(a1_2, a2, a1, u3)
    end
end