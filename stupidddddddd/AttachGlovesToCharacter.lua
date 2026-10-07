-- ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter
-- Script path: ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter
-- Decompile time: 1.75 ms

local RunService = game:GetService("RunService")
local u9 = CFrame.Angles(-1.5707963267948966, 0, 0)
local u10 = {["Right Arm"] = "RightGlove", ["Left Arm"] = "LeftGlove"}
local u13 = {["Right Arm"] = "RightHand", ["Left Arm"] = "LeftHand"}

local function applyGloveConfig(a1, a2, a3, a4, a5) -- Line: 29
    -- upvalues: u9 (val)
    local Character = a3 and a3:FindFirstChild("Character")
    local Character_2 = a4 and a4:FindFirstChild("Character")
    local Character_3 = a5 and a5:FindFirstChild("Character")
    local Value = Character and Character.Value or Vector3.new(1, 1, 1)
    local Value_2 = Character_2 and Character_2.Value or Vector3.new(0, 0, -0.02500000037252903)
    local Value_3 = Character_3 and Character_3.Value or Vector3.new(0, 0, 0)
    local v1 = Vector3.new(math.rad(Value_3.X), math.rad(Value_3.Y), (math.rad(Value_3.Z)))
    local v2 = u9 * CFrame.Angles(v1.X, v1.Y, v1.Z)
    a1.Size = Value
    a2.C0 = CFrame.new(Value_2)
    a2.C1 = a1.PivotOffset * v2
end

return function(a1, a2, a3, a4) -- Line: 46
    -- upvalues: u13 (val), u10 (val), applyGloveConfig (val), RunService (val)
    local v1, v2, v3, v4
    local v5 = {}
    local v6, v7, v8 = a2, a4, a3
    for i, v in ipairs(a1) do
        if v:IsA("BasePart") then
            v1 = u13[v.Name]
            v2 = v1 and v6:FindFirstChild(v1)
            if v2 then
                local u35 = v:Clone()
                u35.Name = u10[v.Name]
                u35.CastShadow = false
                u35.CanCollide = false
                u35.CanTouch = false
                u35.Anchored = false
                u35.CanQuery = false
                u35.Massless = true
                if v7 and v7.collisionGroup then
                    u35.CollisionGroup = v7.collisionGroup
                end
                local Rotations = u35:FindFirstChild("Rotations")
                local Offsets = u35:FindFirstChild("Offsets")
                local Scales = u35:FindFirstChild("Scales")
                local Motor6D = Instance.new("Motor6D")
                Motor6D.Name = "GloveAttachment"
                Motor6D.Part0 = v2
                Motor6D.Part1 = u35
                Motor6D.Parent = u35
                u35.Parent = v8
                applyGloveConfig(u35, Motor6D, Scales, Offsets, Rotations)
                v3 = RunService:IsStudio()
                v4 = ipairs
                for i2, i3 in v4({
                    Scales and Scales:FindFirstChild("Character"),
                    Offsets and Offsets:FindFirstChild("Character"),
                    Rotations and Rotations:FindFirstChild("Character"),
                }) do
                    if not v3 then
                        i3:Destroy()
                    else
                        (i3:GetPropertyChangedSignal("Value")):Connect(function() -- Line: 96
                            -- upvalues: applyGloveConfig (upval), u35 (val), Motor6D (val), Scales (val), Offsets (val)
                            -- upvalues: Rotations (val)
                            applyGloveConfig(u35, Motor6D, Scales, Offsets, Rotations)
                        end)
                    end
                end
                table.insert(v5, u35)
            end
        end
    end
    return v5
end