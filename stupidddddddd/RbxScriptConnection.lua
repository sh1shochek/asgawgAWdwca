-- ReplicatedStorage.Shared.Janitor.RbxScriptConnection
-- Script path: ReplicatedStorage.Shared.Janitor.RbxScriptConnection
-- Decompile time: 0.33 ms

local u0 = {Connected = true}
u0.__index = u0

function u0:Disconnect() -- Line: 20
    if self.Connected then
        self.Connected = false
        self.Connection:Disconnect()
    end
end

function u0._new(a1) -- Line: 27 -- upvalues: u0 (val) -- types: a1: userdata
    return (setmetatable({Connection = a1}, u0))
end

function u0.__tostring(a1) -- Line: 33
    return "RbxScriptConnection<" .. (tostring(a1.Connected)) .. ">"
end

return u0