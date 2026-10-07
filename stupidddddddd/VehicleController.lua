-- Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.VehicleController
-- Script path: Players.Caelclaw404.PlayerScripts.PlayerModule.ControlModule.VehicleController
-- Decompile time: 3.90 ms

local ContextActionService = game:GetService("ContextActionService")
local u5 = {}
u5.__index = u5

function u5.new(a1) -- Line: 27 -- upvalues: u5 (val)
    local v1 = setmetatable({}, u5)
    v1.CONTROL_ACTION_PRIORITY = a1
    v1.enabled = false
    v1.vehicleSeat = nil
    v1.throttle = 0
    v1.steer = 0
    v1.acceleration = 0
    v1.decceleration = 0
    v1.turningRight = 0
    v1.turningLeft = 0
    v1.vehicleMoveVector = Vector3.new(0, 0, 0)
    v1.autoPilot = {}
    v1.autoPilot.MaxSpeed = 0
    v1.autoPilot.MaxSteeringAngle = 0
    return v1
end

function u5:BindContextActions() -- Line: 51 -- upvalues: ContextActionService (val)
    local v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY = self.CONTROL_ACTION_PRIORITY
    local ButtonR2 = Enum.KeyCode.ButtonR2
    v1:BindActionAtPriority("throttleAccel", function(a1, a2, a3) -- Line: 53 -- upvalues: self (val)
        self:OnThrottleAccel(a1, a2, a3)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY, ButtonR2)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_2 = self.CONTROL_ACTION_PRIORITY
    local ButtonL2 = Enum.KeyCode.ButtonL2
    v1:BindActionAtPriority("throttleDeccel", function(a1, a2, a3) -- Line: 57 -- upvalues: self (val)
        self:OnThrottleDeccel(a1, a2, a3)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY_2, ButtonL2)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_3 = self.CONTROL_ACTION_PRIORITY
    local Right = Enum.KeyCode.Right
    v1:BindActionAtPriority("arrowSteerRight", function(a1, a2, a3) -- Line: 62 -- upvalues: self (val)
        self:OnSteerRight(a1, a2, a3)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY_3, Right)
    v1 = ContextActionService
    local CONTROL_ACTION_PRIORITY_4 = self.CONTROL_ACTION_PRIORITY
    local Left = Enum.KeyCode.Left
    v1:BindActionAtPriority("arrowSteerLeft", function(a1, a2, a3) -- Line: 66 -- upvalues: self (val)
        self:OnSteerLeft(a1, a2, a3)
        return Enum.ContextActionResult.Pass
    end, false, CONTROL_ACTION_PRIORITY_4, Left)
end

function u5.Enable(a1, a2, a3) -- Line: 72
    -- upvalues: ContextActionService (val)
    if a2 == a1.enabled and a3 == a1.vehicleSeat then
        return
    end
    a1.enabled = a2
    a1.vehicleMoveVector = Vector3.new(0, 0, 0)
    if a2 then
        if not a3 then
            return
        end
        a1.vehicleSeat = a3
        a1:SetupAutoPilot()
        a1:BindContextActions()
        return
    end
    ContextActionService:UnbindAction("throttleAccel")
    ContextActionService:UnbindAction("throttleDeccel")
    ContextActionService:UnbindAction("arrowSteerRight")
    ContextActionService:UnbindAction("arrowSteerLeft")
    a1.vehicleSeat = nil
end

function u5:OnThrottleAccel(a2, a3, a4) -- Line: 98
    if a3 == Enum.UserInputState.End then
        self.acceleration = 0
    elseif a3 ~= Enum.UserInputState.Cancel then
        self.acceleration = -1
    else
        self.acceleration = 0
    end
    self.throttle = self.acceleration + self.decceleration
end

function u5:OnThrottleDeccel(a2, a3, a4) -- Line: 107
    if a3 == Enum.UserInputState.End then
        self.decceleration = 0
    elseif a3 ~= Enum.UserInputState.Cancel then
        self.decceleration = 1
    else
        self.decceleration = 0
    end
    self.throttle = self.acceleration + self.decceleration
end

function u5:OnSteerRight(a2, a3, a4) -- Line: 116
    if a3 == Enum.UserInputState.End then
        self.turningRight = 0
    elseif a3 ~= Enum.UserInputState.Cancel then
        self.turningRight = 1
    else
        self.turningRight = 0
    end
    self.steer = self.turningRight + self.turningLeft
end

function u5:OnSteerLeft(a2, a3, a4) -- Line: 125
    if a3 == Enum.UserInputState.End then
        self.turningLeft = 0
    elseif a3 ~= Enum.UserInputState.Cancel then
        self.turningLeft = -1
    else
        self.turningLeft = 0
    end
    self.steer = self.turningRight + self.turningLeft
end

function u5.Update(a1, a2, a3, a4) -- Line: 135 -- types: a1: table, a2: vector, a3: boolean, a4: boolean
    if not a1.vehicleSeat then
        return a2, false
    end
    if not a3 then
        local v1 = a1.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(a2)
        a1.vehicleSeat.ThrottleFloat = a1:ComputeThrottle(v1)
        a1.vehicleSeat.SteerFloat = a1:ComputeSteer(v1)
        return Vector3.new(0, 0, 0), true
    end
    local v2 = a2 + Vector3.new(a1.steer, 0, a1.throttle)
    if not a4 then end
    a1.vehicleSeat.ThrottleFloat = -v2.Z
    a1.vehicleSeat.SteerFloat = v2.X
    return v2, true
end

function u5.ComputeThrottle(a1, a2) -- Line: 161
    if a2 ~= Vector3.new(0, 0, 0) then
        return -a2.Z
    end
    return 0
end

function u5:ComputeSteer(a2) -- Line: 170
    if a2 ~= Vector3.new(0, 0, 0) then
        return -math.atan2(-a2.x, -a2.z) * 57.29577951308232 / self.autoPilot.MaxSteeringAngle
    end
    return 0
end

function u5:SetupAutoPilot() -- Line: 179
    self.autoPilot.MaxSpeed = self.vehicleSeat.MaxSpeed
    self.autoPilot.MaxSteeringAngle = 35
end

return u5