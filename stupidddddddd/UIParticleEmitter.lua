-- ReplicatedStorage.Packages.UIParticleEmitter
-- Script path: ReplicatedStorage.Packages.UIParticleEmitter
-- Decompile time: 1.63 ms

local UIParticle = require(script.UIParticle)
local u4 = {}
u4.__index = u4

local function toSize2D(a1) -- Line: 39
    return {X = a1, Y = a1}
end

local function createParticleElement(a1) -- Line: 46 -- types: a1: string
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Particle"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = a1
    ImageLabel.Size = UDim2.fromOffset(1, 1)
    return ImageLabel
end

local function syncRuntime(a1) -- Line: 56 -- types: a1: table
    local _runtimeEmitter = a1._runtimeEmitter
    if not _runtimeEmitter then
        return
    end
    _runtimeEmitter.Rate = a1.Rate
    _runtimeEmitter.Color = a1.Color
    local Size = a1.Size
    _runtimeEmitter.Size = {X = Size, Y = Size}
    _runtimeEmitter.Transparency = a1.Transparency
    _runtimeEmitter.ZOffset = a1.ZOffset
    _runtimeEmitter.Speed = a1.Speed
    _runtimeEmitter.SpreadAngle = a1.SpreadAngle
    _runtimeEmitter.RotSpeed = a1.RotSpeed
    _runtimeEmitter.Lifetime = a1.Lifetime
    _runtimeEmitter.Acceleration = a1.Acceleration
    _runtimeEmitter.Drag = a1.Drag
    _runtimeEmitter.Rotation = a1.Rotation
    _runtimeEmitter.EmissionDirection = a1.EmissionDirection
    _runtimeEmitter.EmitterMode = a1.EmitterMode or "Fill"
    _runtimeEmitter.MaxParticles = a1.MaxParticles or 24
    _runtimeEmitter.UpdateInterval = a1.UpdateInterval or 0
    _runtimeEmitter.OnUpdate = a1.OnUpdate
    if a1._particleElement then
        a1._particleElement.Image = a1.Texture
    end
end

function u4.SetParent(a1, a2) -- Line: 85
    -- upvalues: UIParticle (val), syncRuntime (val)
    if a1._runtimeEmitter then
        a1._runtimeEmitter:Destroy()
        a1._runtimeEmitter = nil
    end
    a1.Parent = a2
    if not a2 then
        return
    end
    local Texture = a1.Texture
    local v1 = Instance.new("ImageLabel")
    v1.Name = "Particle"
    v1.BackgroundTransparency = 1
    v1.Image = Texture
    v1.Size = UDim2.fromOffset(1, 1)
    local v2 = UIParticle.new(a2, v1)
    a1._particleElement = v1
    a1._runtimeEmitter = v2
    syncRuntime(a1)
    local SetEnabled = v2.SetEnabled
    if typeof(SetEnabled) ~= "function" then
        v2.Enabled = true
    else
        SetEnabled(v2, true)
    end
    local v3 = a1.MaxParticles or 24
    if 0 < a1.Rate and v3 > 0 then
        v2:Emit((math.min(v3, (math.max(1, (math.floor(a1.Rate / 4)))))))
    end
end

function u4:Emit(a2) -- Line: 118 -- upvalues: syncRuntime (val) -- types: self: table, a2: number
    if self._runtimeEmitter then
        syncRuntime(self)
        self._runtimeEmitter:Emit(a2)
    end
end

function u4.Update(a1, a2) -- Line: 125 -- upvalues: syncRuntime (val) -- types: a1: table, a2: number
    syncRuntime(a1)
end

function u4.SetEnabled(a1, a2) -- Line: 129 -- types: a1: table, a2: boolean
    local _runtimeEmitter = a1._runtimeEmitter
    if not _runtimeEmitter then
        return
    end
    local SetEnabled = _runtimeEmitter.SetEnabled
    if typeof(SetEnabled) == "function" then
        SetEnabled(_runtimeEmitter, a2 == true)
        return
    end
    _runtimeEmitter.Enabled = a2 == true
end

function u4:Destroy() -- Line: 145 -- types: self: table
    if self._runtimeEmitter then
        self._runtimeEmitter:Destroy()
        self._runtimeEmitter = nil
    end
    if self._particleElement then
        self._particleElement:Destroy()
        self._particleElement = nil
    end
    self.Parent = nil
end

function u4.new() -- Line: 159 -- upvalues: u4 (val)
    local v1 = setmetatable({}, u4)
    v1.Color = Color3.new(1, 1, 1)
    v1.Size = NumberSequence.new(12)
    v1.Transparency = NumberSequence.new(0)
    v1.Texture = ""
    v1.EmissionDirection = "Top"
    v1.Lifetime = NumberRange.new(1)
    v1.Rate = 20
    v1.Rotation = 0
    v1.RotSpeed = 0
    v1.Speed = 0
    v1.SpreadAngle = 0
    v1.Acceleration = Vector2.zero
    v1.Drag = 0
    v1.ZOffset = 0
    v1.EmitterMode = nil
    v1.MaxParticles = nil
    v1.UpdateInterval = nil
    v1.OnUpdate = nil
    v1._runtimeEmitter = nil
    v1._particleElement = nil
    v1.SetParent = u4.SetParent
    v1.SetEnabled = u4.SetEnabled
    v1.Emit = u4.Emit
    v1.Update = u4.Update
    v1.Destroy = u4.Destroy
    return v1
end

return u4