-- StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.ConnectionUtil
-- Script path: StarterPlayer.StarterPlayerScripts.PlayerModule.CommonUtils.ConnectionUtil
-- Decompile time: 0.59 ms

local u0 = {}
u0.__index = u0

function u0.new() -- Line: 25 -- upvalues: u0 (val)
    local v1 = setmetatable({}, u0)
    v1._connections = {}
    return v1
end

function u0.trackConnection(a1, a2, a3) -- Line: 33
    if a1._connections[a2] then
        a1._connections[a2]()
    end

    a1._connections[a2] = function() -- Line: 38 -- upvalues: a3 (val)
        a3:Disconnect()
    end
end

function u0.trackBoundFunction(a1, a2, a3) -- Line: 41
    if a1._connections[a2] then
        a1._connections[a2]()
    end
    a1._connections[a2] = a3
end

function u0.disconnect(a1, a2) -- Line: 48
    if a1._connections[a2] then
        a1._connections[a2]()
        a1._connections[a2] = nil
    end
end

function u0.disconnectAll(a1) -- Line: 55
    for k, v in pairs(a1._connections) do
        v()
    end
    a1._connections = {}
end

return u0