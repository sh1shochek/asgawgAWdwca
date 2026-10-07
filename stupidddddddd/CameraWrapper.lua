-- Players.Caelclaw404.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper
-- Decompile time: 0.86 ms

local ConnectionUtil = require(script.Parent.ConnectionUtil)
local u5 = {}
u5.__index = u5

function u5.new() -- Line: 42 -- upvalues: ConnectionUtil (val), u5 (val)
    return (setmetatable({
        _enabled = false,
        _camera = workspace.CurrentCamera,
        _callbacks = {},
        _connectionUtil = ConnectionUtil.new(),
    }, u5))
end

function u5:_connectCallbacks() -- Line: 55
    local _connectionUtil, v1
    self._camera = workspace.CurrentCamera
    if not self._camera then
        return
    end
    for i, j in self._callbacks do
        _connectionUtil = self._connectionUtil
        v1 = (self._camera:GetPropertyChangedSignal(i)):Connect(j)
        _connectionUtil:trackConnection(i, v1)
        j()
    end
end

function u5.Enable(a1) -- Line: 71
    if a1._enabled then
        return
    end
    a1._enabled = true
    a1._cameraChangedConnection = (workspace:GetPropertyChangedSignal("CurrentCamera")):Connect(function() -- Line: 78 -- upvalues: a1 (val)
        a1:_connectCallbacks()
    end)
    a1:_connectCallbacks()
end

function u5.Disable(a1) -- Line: 85
    if not a1._enabled then
        return
    end
    a1._enabled = false
    if a1._cameraChangedConnection then
        a1._cameraChangedConnection:Disconnect()
        a1._cameraChangedConnection = nil
    end
    a1._connectionUtil:disconnectAll()
end

function u5:Connect(a2, a3) -- Line: 100 -- types: self: table, a2: string, a3: function
    self._callbacks[a2] = a3
    if not self._camera then
        return
    end
    self._connectionUtil:trackConnection(a2, ((self._camera:GetPropertyChangedSignal(a2)):Connect(a3)))
end

function u5:Disconnect(a2) -- Line: 110 -- types: self: table, a2: string
    self._connectionUtil:disconnect(a2)
    self._callbacks[a2] = nil
end

function u5.getCamera(a1) -- Line: 116
    return a1._camera
end

return u5