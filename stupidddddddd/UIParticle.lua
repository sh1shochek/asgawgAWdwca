-- ReplicatedStorage.Packages.UIParticleEmitter.UIParticle
-- Script path: ReplicatedStorage.Packages.UIParticleEmitter.UIParticle
-- Decompile time: 6.70 ms

local RunService = game:GetService("RunService")
local u5 = 0
local u6 = {}
u6.__index = u6
local u7 = {}
u7.__index = u7
local u8 = {}
local u9 = nil

local function rotate(a1, a2) -- Line: 75 -- types: a1: userdata, a2: number
    local v1 = math.rad(a2)
    local v2 = math.sin(v1)
    local v3 = math.cos(v1)
    return Vector2.new(v3 * a1.X - v2 * a1.Y, v2 * a1.X + v3 * a1.Y)
end

local function alphaBetween(a1, a2, a3) -- Line: 83 -- types: a1: number, a2: number, a3: number
    if a2 <= a1 then
        return 1
    end
    return (math.clamp((a3 - a1) / (a2 - a1), 0, 1))
end

local function evalColor(a1, a2) -- Line: 91 -- types: a2: number
    local v1, v2
    if typeof(a1) ~= "ColorSequence" then
        return a1
    end
    if a2 <= 0 then
        return a1.Keypoints[1].Value
    end
    if a2 >= 1 then
        return a1.Keypoints[#a1.Keypoints].Value
    end
    local v3 = #a1.Keypoints - 1
    local v4 = a2
    for i = 1, v3 do
        v1 = a1.Keypoints[i]
        v2 = a1.Keypoints[i + 1]
        if v1.Time <= v4 and v4 < v2.Time then
            return v1.Value:Lerp(v2.Value, (v4 - v1.Time) / (v2.Time - v1.Time))
        end
    end
    return a1.Keypoints[#a1.Keypoints].Value
end

local function evalNumber(a1, a2) -- Line: 117 -- types: a2: number
    local v1, v2, v3
    if typeof(a1) ~= "NumberSequence" then
        return a1
    end
    if a2 <= 0 then
        return a1.Keypoints[1].Value
    end
    if a2 >= 1 then
        return a1.Keypoints[#a1.Keypoints].Value
    end
    local v4 = #a1.Keypoints - 1
    local v5 = a2
    for i = 1, v4 do
        v1 = a1.Keypoints[i]
        v2 = a1.Keypoints[i + 1]
        if v1.Time <= v5 and v5 < v2.Time then
            v3 = (v5 - v1.Time) / (v2.Time - v1.Time)
            return (v2.Value - v1.Value) * v3 + v1.Value
        end
    end
    return a1.Keypoints[#a1.Keypoints].Value
end

local function sampleNumber(a1) -- Line: 143
    local v1 = typeof(a1)
    if v1 == "NumberRange" then
        return math.random() * (a1.Max - a1.Min) + a1.Min
    end
    if v1 ~= "NumberSequence" then
        return a1
    end
    local Value = a1.Keypoints[1].Value
    local Value_2 = a1.Keypoints[#a1.Keypoints].Value
    return math.random() * (Value_2 - Value) + Value
end

local function getSpreadAngle(a1) -- Line: 160 -- upvalues: sampleNumber (val)
    if typeof(a1) == "NumberRange" then
        return (sampleNumber(a1))
    end
    if a1 == 0 then
        return 0
    end
    return math.random() * a1 - a1 / 2
end

local function getDirectionVector(a1, a2) -- Line: 173 -- types: a1: string, a2: number
    if a1 == "Bottom" then
        return Vector2.new(0, a2)
    end
    if a1 == "Left" then
        return Vector2.new(-a2, 0)
    end
    if a1 == "Right" then
        return Vector2.new(a2, 0)
    end
    return Vector2.new(0, -a2)
end

local function getSpawnPosition(a1, a2) -- Line: 185 -- types: a1: userdata, a2: string
    local AbsoluteSize = a1.AbsoluteSize
    if a2 == "Fill" then
        return Vector2.new(math.random() * AbsoluteSize.X, math.random() * AbsoluteSize.Y)
    end
    return Vector2.new(AbsoluteSize.X / 2, AbsoluteSize.Y / 2)
end

local function applyVisual(a1, a2, a3, a4, a5, a6, a7) -- Line: 195
    -- upvalues: 
    a1.Size = UDim2.fromOffset(math.max(0, a4), (math.max(0, a5)))
    a1.Position = UDim2.fromOffset(a6.X, a6.Y)
    a1.Rotation = a7
    if not a1:IsA("ImageLabel") and not a1:IsA("ImageButton") then
        if a1:IsA("CanvasGroup") then
            a1.GroupColor3 = a2
            a1.GroupTransparency = a3
        end
        return
    end
    a1.ImageColor3 = a2
    a1.ImageTransparency = a3
end

local function stepEmitter(a1, a2) -- Line: 219 -- upvalues: u5 (ref), u6 (val) -- types: a1: table, a2: number
    local v1
    if not a1.Enabled then
        return
    end
    if 0 < a1.UpdateInterval then
        a1.__updateAccumulator = a1.__updateAccumulator + a2
        if a1.__updateAccumulator < a1.UpdateInterval then
            return
        end
        a2 = a1.__updateAccumulator
        a1.__updateAccumulator = 0
    end
    a1.__elapsedTime = a1.__elapsedTime + a2
    local v2 = a1
    for i = #a1.particles, 1, -1 do
        v1 = v2.particles[i]
        if not v1.isDead then
            v1:Update(a2)
        else
            table.remove(v2.particles, i)
        end
    end
    if v2.Rate <= 0 then
        return
    end
    local v3 = 1 / v2.Rate
    while v3 <= v2.__elapsedTime do
        if not (v2.MaxParticles <= #v2.particles) and not (u5 >= 180) then
            table.insert(v2.particles, (u6.new(v2)))
            v2.__elapsedTime = v2.__elapsedTime - v3
            continue
        end
        v2.__elapsedTime = 0
        return
    end
end

local function stopHeartbeatIfIdle() -- Line: 263 -- upvalues: u9 (ref), u8 (val)
    if u9 and next(u8) == nil then
        u9:Disconnect()
        u9 = nil
    end
end

local function startHeartbeat() -- Line: 270 -- upvalues: u9 (ref), RunService (val), u8 (val), stepEmitter (val)
    if u9 then
        return
    end
    u9 = RunService.Heartbeat:Connect(function(a1) -- Line: 275 -- upvalues: u8 (upval), stepEmitter (upval), u9 (upval)
        for k in pairs(u8) do
            if not k.__dead then
                stepEmitter(k, a1)
            else
                u8[k] = nil
            end
        end
        if u9 and next(u8) == nil then
            u9:Disconnect()
            u9 = nil
        end
    end)
end

local function acquireElement(a1) -- Line: 288 -- types: a1: table
    local v1 = table.remove(a1.__pool)
    if v1 then
        return v1
    end
    return a1.Element:Clone()
end

local function releaseElement(a1, a2) -- Line: 297 -- types: a1: table, a2: userdata
    a2.Parent = nil
    if #a1.__pool < a1.MaxParticles then
        table.insert(a1.__pool, a2)
        return
    end
    a2:Destroy()
end

function u6.new(a1) -- Line: 308
    -- upvalues: getSpawnPosition (val), sampleNumber (val), applyVisual (val), u6 (val), getDirectionVector (val)
    -- upvalues: u5 (ref)
    local v1 = table.remove(a1.__pool)
    local v2 = if not v1 then a1.Element:Clone() else v1
    v1 = getSpawnPosition(a1.Hook, a1.EmitterMode)
    local v3 = sampleNumber(a1.Speed)
    local SpreadAngle = a1.SpreadAngle
    local v4 = sampleNumber(a1.Rotation)
    local Color = a1.Color
    local Value = if typeof(Color) == "ColorSequence" then Color.Keypoints[1].Value else Color
    local Transparency = a1.Transparency
    local Value_2 = if typeof(Transparency) == "NumberSequence" then Transparency.Keypoints[1].Value else Transparency
    local X = a1.Size.X
    local Value_3 = if typeof(X) == "NumberSequence" then X.Keypoints[1].Value else X
    local Y = a1.Size.Y
    local Value_4 = if typeof(Y) == "NumberSequence" then Y.Keypoints[1].Value else Y
    v2.Name = "UIParticle"
    v2.AnchorPoint = Vector2.new(0.5, 0.5)
    v2.BackgroundTransparency = 1
    v2.ZIndex = a1.Hook.ZIndex + a1.ZOffset
    applyVisual(v2, Value, Value_2, Value_3, Value_4, v1, v4)
    v2.Parent = a1.Hook
    if a1.PreSpawn then
        a1.PreSpawn(v2)
    end
    local v5 = setmetatable({}, u6)
    v5.Element = v2
    v5.Position = v1
    local v6 = getDirectionVector(a1.EmissionDirection, v3)
    local v7 = math.rad(if typeof(SpreadAngle) == "NumberRange" then sampleNumber(SpreadAngle) else if SpreadAngle ~= 0 then math.random() * SpreadAngle - SpreadAngle / 2 else 0)
    local v8 = math.sin(v7)
    local v9 = math.cos(v7)
    v5.Velocity = Vector2.new(v9 * v6.X - v8 * v6.Y, v8 * v6.X + v9 * v6.Y)
    v5.Acceleration = a1.Acceleration
    v5.Drag = a1.Drag
    v5.Age = 0
    v5.MaxAge = sampleNumber(a1.Lifetime)
    v5.Size = a1.Size
    v5.Color = a1.Color
    v5.Transparency = a1.Transparency
    v5.RotSpeed = sampleNumber(a1.RotSpeed)
    v5.isDead = false
    v5._emitter = a1
    v5._rotation = v4
    u5 = u5 + 1
    return v5
end

function u6:Update(a2) -- Line: 351
    -- upvalues: evalNumber (val), evalColor (val), applyVisual (val)
    local v1
    if self.MaxAge <= self.Age and 0 < self.MaxAge then
        self:Destroy()
        return
    end
    self.Age = self.Age + a2
    local MaxAge = self.MaxAge
    local Age_2 = self.Age
    local v2 = evalNumber(self.Size.X, if not (MaxAge <= 0) then math.clamp((Age_2 - 0) / (MaxAge - 0), 0, 1) else 1)
    local v3 = evalNumber(self.Size.Y, v1)
    local v4 = evalColor(self.Color, v1)
    local v5 = evalNumber(self.Transparency, v1)
    if 0 < self.Drag then
        self.Velocity = self.Velocity * (math.max(0, 1 - self.Drag * a2))
    end
    self.Velocity = self.Velocity + self.Acceleration * a2
    self.Position = self.Position + self.Velocity * a2
    self._rotation = self._rotation + self.RotSpeed * a2
    applyVisual(self.Element, v4, v5, v2, v3, self.Position, self._rotation)
    local _emitter = self._emitter
    if _emitter.OnUpdate then
        _emitter.OnUpdate(self.Element)
    end
end

function u6:Destroy() -- Line: 382 -- upvalues: u5 (ref)
    if self.isDead then
        return
    end
    self.isDead = true
    u5 = math.max(0, u5 - 1)
    local _emitter = self._emitter
    if _emitter and not _emitter.__dead then
        local Element = self.Element
        Element.Parent = nil
        if #_emitter.__pool < _emitter.MaxParticles then
            table.insert(_emitter.__pool, Element)
            return
        end
        Element:Destroy()
        return
    end
    self.Element:Destroy()
end

function u7.new(a1, a2) -- Line: 398 -- upvalues: u7 (val) -- types: a1: userdata, a2: userdata
    local v1 = setmetatable({}, u7)
    v1.particles = {}
    v1.Enabled = false
    v1.Element = a2
    v1.Hook = a1
    v1.Rate = 20
    v1.Color = Color3.new(1, 1, 1)
    v1.Size = {X = NumberSequence.new(12), Y = NumberSequence.new(12)}
    v1.Transparency = NumberSequence.new(0)
    v1.ZOffset = 0
    v1.Speed = NumberRange.new(150, 500)
    v1.SpreadAngle = NumberRange.new(-15, 15)
    v1.RotSpeed = NumberRange.new(0)
    v1.Lifetime = NumberRange.new(5, 10)
    v1.Acceleration = Vector2.new(0, -500)
    v1.Drag = 0
    v1.Rotation = 0
    v1.EmissionDirection = "Top"
    v1.EmitterMode = "Point"
    v1.MaxParticles = 24
    v1.UpdateInterval = 0
    v1.PreSpawn = nil
    v1.OnUpdate = nil
    v1.__dead = false
    v1.__elapsedTime = 0
    v1.__updateAccumulator = 0
    v1.__pool = {}
    v1.__runServiceConnection = nil
    v1.Emit = u7.Emit
    v1.SetEnabled = u7.SetEnabled
    v1.Destroy = u7.Destroy
    return v1
end

function u7.fromEmitter3D(a1, a2, a3) -- Line: 437
    -- upvalues: u7 (val)
    local v1 = a3 or 1
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = a2.Texture
    ImageLabel.Size = UDim2.fromOffset(1, 1)
    local v2 = u7.new(a1, ImageLabel)
    v2.Rate = a2.Rate
    v2.Color = a2.Color
    v2.Size = {X = a2.Size, Y = a2.Size}
    v2.Transparency = a2.Transparency
    v2.ZOffset = a2.ZOffset
    v2.Speed = NumberRange.new(a2.Speed.Min * v1, a2.Speed.Max * v1)
    v2.SpreadAngle = NumberRange.new(a2.SpreadAngle.X, a2.SpreadAngle.Y)
    v2.RotSpeed = a2.RotSpeed
    v2.Lifetime = a2.Lifetime
    v2.Acceleration = Vector2.new(a2.Acceleration.X * v1, a2.Acceleration.Y * v1)
    v2.EmitterMode = if a2.ShapeStyle ~= Enum.ParticleEmitterShapeStyle.Volume then "Point" else "Fill"
    return v2
end

function u7.Emit(a1, a2) -- Line: 463 -- upvalues: u5 (ref), u6 (val) -- types: a1: table, a2: number
    for i = 1, a2 do
        if a1.MaxParticles <= #a1.particles or u5 >= 180 then
            break
        end
        table.insert(a1.particles, (u6.new(a1)))
    end
end

function u7.SetEnabled(a1, a2) -- Line: 477
    -- upvalues: u8 (val), u9 (ref), RunService (val), stepEmitter (val)
    if a1.__dead then
        return
    end
    local v1 = a2 == true
    if a1.Enabled == v1 then
        if v1 then
            u8[a1] = true
            if u9 then
                return
            end
            u9 = RunService.Heartbeat:Connect(function(a1) -- Line: 275 -- upvalues: u8 (upval), stepEmitter (upval), u9 (upval)
                for k in pairs(u8) do
                    if not k.__dead then
                        stepEmitter(k, a1)
                    else
                        u8[k] = nil
                    end
                end
                if u9 and next(u8) == nil then
                    u9:Disconnect()
                    u9 = nil
                end
            end)
        end
        return
    end
    a1.Enabled = v1
    if v1 then
        u8[a1] = true
        if u9 then
            return
        end
        u9 = RunService.Heartbeat:Connect(function(a1) -- Line: 275 -- upvalues: u8 (upval), stepEmitter (upval), u9 (upval)
            for k in pairs(u8) do
                if not k.__dead then
                    stepEmitter(k, a1)
                else
                    u8[k] = nil
                end
            end
            if u9 and next(u8) == nil then
                u9:Disconnect()
                u9 = nil
            end
        end)
        return
    end
    u8[a1] = nil
    for i = #a1.particles, 1, -1 do
        a1.particles[i]:Destroy()
        table.remove(a1.particles, i)
    end
    if u9 and next(u8) == nil then
        u9:Disconnect()
        u9 = nil
    end
end

function u7:Destroy() -- Line: 509 -- upvalues: u8 (val), u9 (ref)
    if self.__dead then
        return
    end
    self.__dead = true
    self.Enabled = false
    u8[self] = nil
    if u9 and next(u8) == nil then
        u9:Disconnect()
        u9 = nil
    end
    for i, v in ipairs(self.particles) do
        v:Destroy()
    end
    table.clear(self.particles)
    for i2, i3 in ipairs(self.__pool) do
        i3:Destroy()
    end
    table.clear(self.__pool)
end

return u7