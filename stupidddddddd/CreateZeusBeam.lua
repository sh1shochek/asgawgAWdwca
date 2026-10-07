-- ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam
-- Script path: ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam
-- Decompile time: 1.57 ms

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other")
local Debris_2 = workspace:WaitForChild("Debris")

local function getNumberAttribute(a1, a2, a3) -- Line: 13 -- types: a1: userdata, a2: string, a3: number
    local Attribute = a1:GetAttribute(a2)
    if typeof(Attribute) == "number" then
        return Attribute
    end
    return a3
end

local function getBeamUpVector(a1, a2) -- Line: 18 -- types: a1: vector, a2: vector
    local v1 = a2 - a1 * a2:Dot(a1)
    if v1.Magnitude <= 0.001 then
        v1 = Vector3.new(0, 1, 0) - a1 * Vector3.new(0, 1, 0):Dot(a1)
    end
    if v1.Magnitude <= 0.001 then
        v1 = Vector3.new(0, 0, 1) - a1 * Vector3.new(0, 0, 1):Dot(a1)
    end
    return v1.Unit
end

local function getBeamCleanupTime(a1) -- Line: 31 -- types: a1: userdata
    local Attribute
    local v1 = 5
    for i, v in ipairs(a1:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            Attribute = v:GetAttribute("EmitDelay")
            v1 = math.max(v1, (if typeof(Attribute) ~= "number" then 0 else Attribute) + (math.max(v.Lifetime.Max, 1)) + 1)
        end
    end
    return v1
end

return function(a1) -- Line: 44
    -- upvalues: Other (val), getBeamUpVector (val), Debris_2 (val), Debris (val), getBeamCleanupTime (val)
    local ZeusBeam = Other:FindFirstChild("ZeusBeam")
    if ZeusBeam and ZeusBeam:IsA("BasePart") then
        local Attribute
        local LookVector = a1.CFrame.LookVector
        if LookVector.Magnitude <= 0.001 then
            return nil
        end
        local Unit = LookVector.Unit
        local v1 = ZeusBeam:Clone()
        v1.CollisionGroup = "Debris"
        v1.CanCollide = false
        v1.CanQuery = false
        v1.CanTouch = false
        v1.Anchored = true
        v1.CFrame = CFrame.fromMatrix(a1.Position + Unit * (v1.Size.X * 0.5), Unit, (getBeamUpVector(Unit, a1.CFrame.UpVector)))
        v1.Parent = Debris_2
        for i, v in ipairs(v1:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                Attribute = v:GetAttribute("EmitDelay")
                task.delay(if typeof(Attribute) ~= "number" then 0 else Attribute, function() -- Line: 72 -- upvalues: v (val)
                    if not v.Parent then
                        return
                    end
                    local Attribute = v:GetAttribute("EmitCount")
                    local v1 = if typeof(Attribute) ~= "number" then 0 else Attribute
                    if v1 > 0 then
                        v:Emit(v1)
                        return
                    end
                    v.Enabled = true
                    task.delay(0.15, function() -- Line: 82 -- upvalues: v (upval)
                        if v.Parent then
                            v.Enabled = false
                        end
                    end)
                end)
            end
        end
        Debris:AddItem(v1, (getBeamCleanupTime(v1)))
        return v1
    end
    return nil
end