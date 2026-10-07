-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.ZoomController
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.ZoomController
-- Decompile time: 1.79 ms

local Popper = require(script:WaitForChild("Popper"))
local clamp = math.clamp
local exp = math.exp
local min = math.min
local max = math.max
local CameraMinZoomDistance = nil
local CameraMaxZoomDistance = nil
local LocalPlayer = game:GetService("Players").LocalPlayer
assert(LocalPlayer)

local function updateBounds() -- Line: 23
    -- upvalues: CameraMinZoomDistance (ref), LocalPlayer (val), CameraMaxZoomDistance (ref)
    CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
    CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
end

CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
;(LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance")):Connect(updateBounds)
;(LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance")):Connect(updateBounds)
local u41 = {}
u41.__index = u41

function u41.new(a1, a2, a3, a4) -- Line: 37
    -- upvalues: clamp (val), u41 (val)
    local v1 = clamp(a2, a3, a4)
    return (setmetatable({
        v = 0,
        freq = a1,
        x = v1,
        minValue = a3,
        maxValue = a4,
        goal = v1,
    }, u41))
end

function u41:Step(a2) -- Line: 49 -- upvalues: exp (val) -- types: self: table, a2: number
    local v1 = self.freq * 2 * 3.141592653589793
    local x = self.x
    local v = self.v
    local minValue = self.minValue
    local maxValue = self.maxValue
    local goal = self.goal
    local v2 = goal - x
    local v3 = v1 * a2
    local v4 = exp(-v3)
    local v5 = goal + (v * a2 - v2 * (v3 + 1)) * v4
    local v6 = ((v2 * v1 - v) * v3 + v) * v4
    if v5 < minValue then
        v5 = minValue
        v6 = 0
    elseif maxValue < v5 then
        v5 = maxValue
        v6 = 0
    end
    self.x = v5
    self.v = v6
    return v5
end

local u49 = u41.new(4.5, 12.5, 0.5, CameraMaxZoomDistance)

local function stepTargetZoom(a1, a2, a3, a4) -- Line: 87
    -- upvalues: clamp (val)
    local v1 = clamp(a1 + a2 * (a1 * 0.0375 + 1), a3, a4)
    if v1 < 1 then
        v1 = a2 <= 0 and a3 or 1
    end
    return v1
end

local u51 = 0
return {
    Update = function(a1, a2, a3) -- Line: 98
        -- upvalues: u49 (val), u51 (ref), CameraMinZoomDistance (ref), CameraMaxZoomDistance (ref), clamp (val)
        -- upvalues: max (val), Popper (val), min (val)
        local v1 = (1 / 0)
        if 1 < u49.goal then
            local x = u49.x
            local goal = u49.goal
            local v2 = u51
            local v3 = CameraMinZoomDistance
            local v4 = CameraMaxZoomDistance
            local v5 = clamp(goal + v2 * (goal * 0.0375 + 1), v3, v4)
            if v5 < 1 then
                v5 = v2 <= 0 and v3 or 1
            end
            local v6 = max(x, v5)
            v1 = Popper(a2 * CFrame.new(0, 0, 0.5), v6 - 0.5, a3) + 0.5
        end
        u49.minValue = 0.5
        u49.maxValue = min(CameraMaxZoomDistance, v1)
        return u49:Step(a1)
    end,
    GetZoomRadius = function() -- Line: 122 -- upvalues: u49 (val)
        return u49.x
    end,
    SetZoomParameters = function(a1, a2) -- Line: 126 -- upvalues: u49 (val), u51 (ref)
        u49.goal = a1
        u51 = a2
    end,
    ReleaseSpring = function() -- Line: 131 -- upvalues: u49 (val)
        u49.x = u49.goal
        u49.v = 0
    end,
}