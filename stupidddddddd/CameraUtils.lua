-- Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.CameraUtils
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.CameraModule.CameraUtils
-- Decompile time: 5.43 ms

local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local u11 = {}

local function round(a1) -- Line: 11 -- types: a1: number
    return (math.floor(a1 + 0.5))
end

local u13 = {}
u13.__index = u13

function u13.new(a1, a2) -- Line: 20 -- upvalues: u13 (val)
    return (setmetatable({vel = 0, freq = a1, goal = a2, pos = a2}, u13))
end

function u13.step(a1, a2) -- Line: 30 -- types: a1: table, a2: number
    local v1 = a1.freq * 2 * 3.141592653589793
    local goal = a1.goal
    local pos = a1.pos
    local vel = a1.vel
    local v2 = pos - goal
    local v3 = math.exp(-v1 * a2)
    local v4 = (v2 * (v1 * a2 + 1) + vel * a2) * v3 + goal
    local v5 = (vel * (1 - v1 * a2) - v2 * (v1 * v1 * a2)) * v3
    a1.pos = v4
    a1.vel = v5
    return v4
end

u11.Spring = u13

function u11.map(a1, a2, a3, a4, a5) -- Line: 52 -- types: a1: number, a2: number, a3: number, a4: number, a5: number
    return (a1 - a2) * (a5 - a4) / (a3 - a2) + a4
end

function u11.mapClamp(a1, a2, a3, a4, a5) -- Line: 57
    -- upvalues: 
    return (math.clamp((a1 - a2) * (a5 - a4) / (a3 - a2) + a4, math.min(a4, a5), (math.max(a4, a5))))
end

function u11.getLooseBoundingSphere(a1) -- Line: 66 -- types: a1: table
    local Magnitude, Magnitude_2, Magnitude_3
    local v1 = table.create(#a1)
    for k, v in pairs(a1) do
        v1[k] = v.Position
    end
    local v2 = v1[1]
    local v3 = v2
    local v4 = 0
    for i, i2 in ipairs(v1) do
        Magnitude_3 = (i2 - v2).Magnitude
        if v4 < Magnitude_3 then
            v3 = i2
        end
    end
    local v5 = v3
    local v6 = 0
    for i3, j in ipairs(v1) do
        Magnitude_2 = (j - v3).Magnitude
        if v6 < Magnitude_2 then
            v5 = j
        end
    end
    local v7 = (v3 + v5) * 0.5
    local v8 = (v3 - v5).Magnitude * 0.5
    for i4, k2 in ipairs(v1) do
        Magnitude = (k2 - v7).Magnitude
        if v8 < Magnitude then
            v7 = v7 + (Magnitude - v8) * 0.5 * (k2 - v7).Unit
            v8 = (Magnitude + v8) * 0.5
        end
    end
    return v7, v8
end

function u11.sanitizeAngle(a1) -- Line: 122 -- types: a1: number
    return (a1 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

function u11.Round(a1, a2) -- Line: 127 -- types: a1: number, a2: number
    local v1 = 10 ^ a2
    return math.floor(a1 * v1 + 0.5) / v1
end

function u11.IsFinite(a1) -- Line: 132 -- types: a1: number
    local v1 = false
    if a1 == a1 then
        v1 = false
        if a1 ~= (1 / 0) then
            v1 = a1 ~= (-1 / 0)
        end
    end
    return v1
end

function u11.IsFiniteVector3(a1) -- Line: 136 -- upvalues: u11 (val) -- types: a1: vector
    return u11.IsFinite(a1.X) and u11.IsFinite(a1.Y) and u11.IsFinite(a1.Z)
end

function u11.GetAngleBetweenXZVectors(a1, a2) -- Line: 141 -- types: a1: vector, a2: vector
    return (math.atan2(a2.X * a1.Z - a2.Z * a1.X, a2.X * a1.X + a2.Z * a1.Z))
end

function u11.RotateVectorByAngleAndRound(a1, a2, a3) -- Line: 145 -- types: a1: vector, a2: number, a3: number
    if not (0 < a1.Magnitude) then
        return 0
    end
    local Unit = a1.Unit
    local v1 = math.atan2(Unit.Z, Unit.X)
    return math.floor(((math.atan2(Unit.Z, Unit.X)) + a2) / a3 + 0.5) * a3 - v1
end

local function SCurveTranform(a1) -- Line: 159 -- types: a1: number
    local v1 = math.clamp(a1, -1, 1)
    if v1 >= 0 then
        return v1 * 0.35 / (0.35 - v1 + 1)
    end
    return -(-v1 * 0.8 / (v1 + 0.8 + 1))
end

local function toSCurveSpace(a1) -- Line: 168 -- types: a1: number
    return (math.abs(a1) * 2 - 1) * 1.1 - 0.1
end

local function fromSCurveSpace(a1) -- Line: 172 -- types: a1: number
    return a1 / 2 + 0.5
end

function u11.GamepadLinearToCurve(a1) -- Line: 176 -- types: a1: userdata
    local function onAxis(a1) -- Line: 177
        local v1 = 1
        if a1 < 0 then
            v1 = -1
        end
        local v2 = math.clamp(((math.abs((math.abs(a1)))) * 2 - 1) * 1.1 - 0.1, -1, 1)
        return (math.clamp(((if not (v2 >= 0) then -(-v2 * 0.8 / (v2 + 0.8 + 1)) else v2 * 0.35 / (0.35 - v2 + 1)) / 2 + 0.5) * v1, -1, 1))
    end

    local new = Vector2.new
    local X = a1.X
    local v1 = 1
    if X < 0 then
        v1 = -1
    end
    local v2 = math.clamp(((math.abs((math.abs(X)))) * 2 - 1) * 1.1 - 0.1, -1, 1)
    local v3 = math.clamp(((if not (v2 >= 0) then -(-v2 * 0.8 / (v2 + 0.8 + 1)) else v2 * 0.35 / (0.35 - v2 + 1)) / 2 + 0.5) * v1, -1, 1)
    local Y = a1.Y
    local v4 = 1
    if Y < 0 then
        v4 = -1
    end
    local v5 = math.clamp(((math.abs((math.abs(Y)))) * 2 - 1) * 1.1 - 0.1, -1, 1)
    return new(v3, (math.clamp(((if not (v5 >= 0) then -(-v5 * 0.8 / (v5 + 0.8 + 1)) else v5 * 0.35 / (0.35 - v5 + 1)) / 2 + 0.5) * v4, -1, 1)))
end

function u11.ConvertCameraModeEnumToStandard(a1) -- Line: 190
    if a1 == Enum.TouchCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Follow
    end
    if a1 == Enum.ComputerCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Classic
    end
    if a1 ~= Enum.TouchCameraMovementMode.Classic
        and a1 ~= Enum.DevTouchCameraMovementMode.Classic
        and a1 ~= Enum.DevComputerCameraMovementMode.Classic
        and a1 ~= Enum.ComputerCameraMovementMode.Classic then
        if a1 ~= Enum.TouchCameraMovementMode.Follow
            and a1 ~= Enum.DevTouchCameraMovementMode.Follow
            and a1 ~= Enum.DevComputerCameraMovementMode.Follow
            and a1 ~= Enum.ComputerCameraMovementMode.Follow then
            if a1 ~= Enum.TouchCameraMovementMode.Orbital
                and a1 ~= Enum.DevTouchCameraMovementMode.Orbital
                and a1 ~= Enum.DevComputerCameraMovementMode.Orbital
                and a1 ~= Enum.ComputerCameraMovementMode.Orbital then
                if a1 ~= Enum.ComputerCameraMovementMode.CameraToggle
                    and a1 ~= Enum.DevComputerCameraMovementMode.CameraToggle then
                    if a1 ~= Enum.DevTouchCameraMovementMode.UserChoice
                        and a1 ~= Enum.DevComputerCameraMovementMode.UserChoice then
                        return Enum.ComputerCameraMovementMode.Classic
                    end
                    return Enum.DevComputerCameraMovementMode.UserChoice
                end
                return Enum.ComputerCameraMovementMode.CameraToggle
            end
            return Enum.ComputerCameraMovementMode.Orbital
        end
        return Enum.ComputerCameraMovementMode.Follow
    end
    return Enum.ComputerCameraMovementMode.Classic
end

local u30 = ""
local u31 = nil

function u11.setMouseIconOverride(a1) -- Line: 241
    -- upvalues: UserInputService (val), u31 (ref), u30 (ref)
    if UserInputService.MouseIcon ~= u31 then
        u30 = UserInputService.MouseIcon
    end
    UserInputService.MouseIcon = a1
    u31 = a1
end

function u11.restoreMouseIcon() -- Line: 251 -- upvalues: u31 (ref), UserInputService (val), u30 (ref)
    if u31 == nil then
        return
    end
    if UserInputService.MouseIcon == u31 then
        UserInputService.MouseIcon = u30
    end
    u31 = nil
end

local Default = Enum.MouseBehavior.Default
local u35 = nil

function u11.setMouseBehaviorOverride(a1) -- Line: 265 -- upvalues: UserInputService (val), u35 (ref), Default (ref)
    if UserInputService.MouseBehavior ~= u35 then
        Default = UserInputService.MouseBehavior
    end
    UserInputService.MouseBehavior = a1
    u35 = a1
end

function u11.restoreMouseBehavior() -- Line: 274 -- upvalues: UserInputService (val), u35 (ref), Default (ref)
    if UserInputService.MouseBehavior == u35 then
        UserInputService.MouseBehavior = Default
    end
    u35 = nil
end

local MovementRelative = Enum.RotationType.MovementRelative
local u39 = nil

function u11.setRotationTypeOverride(a1) -- Line: 283
    -- upvalues: UserGameSettings (val), u39 (ref), MovementRelative (ref)
    if UserGameSettings.RotationType ~= u39 then
        MovementRelative = UserGameSettings.RotationType
    end
    UserGameSettings.RotationType = a1
    u39 = a1
end

function u11.restoreRotationType() -- Line: 292 -- upvalues: UserGameSettings (val), u39 (ref), MovementRelative (ref)
    if UserGameSettings.RotationType == u39 then
        UserGameSettings.RotationType = MovementRelative
    end
    u39 = nil
end

return u11