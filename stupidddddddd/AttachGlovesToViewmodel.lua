-- ReplicatedStorage.Database.Components.Common.AttachGlovesToViewmodel
-- Script path: ReplicatedStorage.Database.Components.Common.AttachGlovesToViewmodel
-- Decompile time: 1.88 ms

return function(a1, a2) -- Line: 6 -- types: a1: table, a2: userdata
    local Camera, Camera_2, Camera_3, Offsets, Offsets_2, Rotations, Rotations_2, Scales, Scales_2, Value, Value_2, Value_3, v1, v2, v3, v4, v5, v6
    local v7 = {}
    for i, v in ipairs(a1) do
        if v:IsA("BasePart") then
            v6 = a2:FindFirstChild(v.Name)
            if v6 then
                Scales = v:FindFirstChild("Scales")
                Offsets = v:FindFirstChild("Offsets")
                Rotations = v:FindFirstChild("Rotations")
                Camera = Scales and Scales:FindFirstChild("Camera")
                Camera_2 = Offsets and Offsets:FindFirstChild("Camera")
                Camera_3 = Rotations and Rotations:FindFirstChild("Camera")
                Value = Camera and Camera.Value
                Value_2 = Camera_2 and Camera_2.Value or Vector3.new(0, 0, 0)
                Value_3 = Camera_3 and Camera_3.Value or Vector3.new(0, 0, 0)
                v1 = Vector3.new(math.rad(Value_3.X), math.rad(Value_3.Y), (math.rad(Value_3.Z)))
                v2 = v:Clone()
                v2.CastShadow = false
                v2.CanCollide = false
                v2.CanTouch = false
                v2.Anchored = true
                v2.CanQuery = false
                v2.Name = "Glove"
                Scales_2 = v2:FindFirstChild("Scales")
                Offsets_2 = v2:FindFirstChild("Offsets")
                Rotations_2 = v2:FindFirstChild("Rotations")
                if Scales_2 then
                    Scales_2:Destroy()
                end
                if Offsets_2 then
                    Offsets_2:Destroy()
                end
                if Rotations_2 then
                    Rotations_2:Destroy()
                end
                v2.Size = Vector3.new(
                    v6.Size.X * (Value and Value.X or 1),
                    v6.Size.Y * (Value and Value.Y or 1),
                    v6.Size.Z * (Value and Value.Z or 1)
                )
                v3 = v6.Size.Z / 2 - v2.Size.Z / 2
                v4 = (CFrame.new(Value_2)) * CFrame.new(0, 0, -v3 * 1.035) * v2.PivotOffset * CFrame.Angles(v1.X, v1.Y, v1.Z)
                v2.Parent = v6
                v5 = Instance.new("WeldConstraint", v2)
                v5.Part0 = v6
                v5.Part1 = v2
                v2.CFrame = v6.CFrame * v4
                v2.Anchored = false
                table.insert(v7, v2)
            end
        end
    end
    return v7
end