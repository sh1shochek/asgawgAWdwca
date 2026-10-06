-- Decompiled with Potassium's decompiler.

return function(p1: table, p2: userdata) -- Line: 6
    local v3 = {};

    for _, v in ipairs(p1) do
        if v:IsA("BasePart") then
            local v4 = p2:FindFirstChild(v.Name);

            if v4 then
                local Scales = v:FindFirstChild("Scales");
                local Offsets = v:FindFirstChild("Offsets");
                local Rotations = v:FindFirstChild("Rotations");

                if Scales then
                    Scales = Scales:FindFirstChild("Camera");
                end;

                if Offsets then
                    Offsets = Offsets:FindFirstChild("Camera");
                end;

                if Rotations then
                    Rotations = Rotations:FindFirstChild("Camera");
                end;

                if Scales then
                    Scales = Scales.Value;
                end;

                local v5 = Offsets and Offsets.Value or Vector3.new(0, 0, 0);
                local v6 = Rotations and Rotations.Value or Vector3.new(0, 0, 0);
                local math_rad_ret = math.rad(v6.X);
                local math_rad_ret2 = math.rad(v6.Y);
                local math_rad_ret3 = math.rad(v6.Z);
                local Vector3_new_ret = Vector3.new(math_rad_ret, math_rad_ret2, math_rad_ret3);
                local v7 = v:Clone();
                v7.CastShadow = false;
                v7.CanCollide = false;
                v7.CanTouch = false;
                v7.Anchored = true;
                v7.CanQuery = false;
                v7.Name = "Glove";
                local Scales2 = v7:FindFirstChild("Scales");
                local Offsets2 = v7:FindFirstChild("Offsets");
                local Rotations2 = v7:FindFirstChild("Rotations");

                if Scales2 then
                    Scales2:Destroy();
                end;

                if Offsets2 then
                    Offsets2:Destroy();
                end;

                if Rotations2 then
                    Rotations2:Destroy();
                end;

                v7.Size = Vector3.new(v4.Size.X * (Scales and (Scales.X or 1) or 1), v4.Size.Y * (Scales and (Scales.Y or 1) or 1), v4.Size.Z * (Scales and Scales.Z or 1));
                local v8 = v4.Size.Z / 2 - v7.Size.Z / 2;
                local v9 = CFrame.new(v5) * CFrame.new(0, 0, -v8 * 1.035) * v7.PivotOffset * CFrame.Angles(Vector3_new_ret.X, Vector3_new_ret.Y, Vector3_new_ret.Z);
                v7.Parent = v4;
                local WeldConstraint = Instance.new("WeldConstraint", v7);
                WeldConstraint.Part0 = v4;
                WeldConstraint.Part1 = v7;
                v7.CFrame = v4.CFrame * v9;
                v7.Anchored = false;
                table.insert(v3, v7);
            end;
        end;
    end;

    return v3;
end;