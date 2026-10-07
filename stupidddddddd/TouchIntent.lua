-- ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons.TouchIntent
-- Script path: ReplicatedStorage.Interface.Screens.Gameplay.Middle.MobileButtons.TouchIntent
-- Decompile time: 2.54 ms

local v1 = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local CameraInput = require((((LocalPlayer:WaitForChild("PlayerScripts")):WaitForChild("PlayerModule")):WaitForChild("CameraModule")):WaitForChild("CameraInput"))
local u35 = {}
local u36 = {}

local function toVector2(a1) -- Line: 55 -- types: a1: vector
    return Vector2.new(a1.X, a1.Y)
end

local function getDragDistance() -- Line: 61 -- upvalues: Workspace (val)
    local CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then
        return 8
    end
    local ViewportSize = CurrentCamera.ViewportSize
    return (math.max(8, (math.min(ViewportSize.X, ViewportSize.Y)) * 0.03))
end

local function isInCore(a1, a2) -- Line: 72 -- types: a1: userdata, a2: userdata
    local v1 = a1.AbsoluteSize / 2
    local v2 = a2 - (a1.AbsolutePosition + v1)
    local v3 = v1 * 0.6
    local v4 = false
    if (math.abs(v2.X)) <= v3.X then
        v4 = (math.abs(v2.Y)) <= v3.Y
    end
    return v4
end

local function firePendingTap(a1) -- Line: 81 -- upvalues: u35 (val) -- types: a1: userdata
    local v1 = u35[a1]
    if v1 and not v1.isDrag and v1.pendingTap then
        local pendingTap = v1.pendingTap
        v1.pendingTap = nil
        pendingTap()
        return
    end
end

local function promoteToDrag(a1, a2, a3) -- Line: 93
    -- upvalues: u36 (val), CameraInput (val)
    a2.isDrag = true
    a2.pendingTap = nil
    u36[a2.button] = true
    if a2.onDrag then
        a2.onDrag(a1)
    end
    CameraInput.addTouchMove(a3)
end

function v1.track(a1, a2, a3) -- Line: 109
    -- upvalues: u35 (val), u36 (val)
    if a1.UserInputType == Enum.UserInputType.Touch and not u35[a1] then
        local v1 = u35
        local v2 = {isDrag = false, button = a2}
        local Position = a1.Position
        v2.startPosition = Vector2.new(Position.X, Position.Y)
        v2.onDrag = a3
        v1[a1] = v2
        u36[a2] = false
        return
    end
end

function v1.onTap(a1, a2) -- Line: 126 -- upvalues: u35 (val), firePendingTap (val) -- types: a1: userdata, a2: function
    local v1 = u35[a1]
    if v1 then
        local button = v1.button
        local startPosition = v1.startPosition
        local v2 = button.AbsoluteSize / 2
        local v3 = startPosition - (button.AbsolutePosition + v2)
        local v4 = v2 * 0.6
        local v5 = false
        if (math.abs(v3.X)) <= v4.X then
            v5 = (math.abs(v3.Y)) <= v4.Y
        end
        if not v5 then
            v1.pendingTap = a2
            task.delay(0.07, firePendingTap, a1)
            return
        end
    end
    a2()
end

function v1.lastTouchWasDrag(a1) -- Line: 138 -- upvalues: u36 (val) -- types: a1: userdata
    return u36[a1] == true
end

UserInputService.InputChanged:Connect(function(a1) -- Line: 145 -- upvalues: u35 (val), CameraInput (val), Workspace (val), u36 (val) -- types: a1: userdata
    local v1
    local v2 = u35[a1]
    if not v2 then
        return
    end
    if v2.isDrag then
        CameraInput.addTouchMove(Vector2.new(a1.Delta.X, a1.Delta.Y))
        return
    end
    local Position = a1.Position
    local v3 = Vector2.new(Position.X, Position.Y) - v2.startPosition
    local Magnitude = v3.Magnitude
    local CurrentCamera = Workspace.CurrentCamera
    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize
        v1 = math.max(8, (math.min(ViewportSize.X, ViewportSize.Y)) * 0.03)
    else
        v1 = 8
    end
    if v1 < Magnitude then
        v2.isDrag = true
        v2.pendingTap = nil
        u36[v2.button] = true
        if v2.onDrag then
            v2.onDrag(a1)
        end
        CameraInput.addTouchMove(v3)
    end
end)
UserInputService.InputEnded:Connect(function(a1) -- Line: 162 -- upvalues: u35 (val) -- types: a1: userdata
    if not u35[a1] then
        return
    end
    local v1 = u35[a1]
    if v1 and not v1.isDrag and v1.pendingTap then
        local pendingTap = v1.pendingTap
        v1.pendingTap = nil
        pendingTap()
    end
    task.defer(function() -- Line: 169 -- upvalues: u35 (upval), a1 (val)
        u35[a1] = nil
    end)
end)
return v1