-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local CFrame_Angles_ret = CFrame.Angles(-1.5707963267948966, 0, 0);
local u1 = {
    ["Right Arm"] = "RightGlove",
    ["Left Arm"] = "LeftGlove"
};
local u2 = {
    ["Right Arm"] = "RightHand",
    ["Left Arm"] = "LeftHand"
};

local function applyGloveConfig(p3: userdata, p4: userdata, p5: userdata?, p6: userdata?, p7: userdata?) -- Line: 29
    -- upvalues: CFrame_Angles_ret (copy)
    if p5 then
        p5 = p5:FindFirstChild("Character");
    end;

    if p6 then
        p6 = p6:FindFirstChild("Character");
    end;

    if p7 then
        p7 = p7:FindFirstChild("Character");
    end;

    local v8 = p5 and p5.Value or Vector3.new(1, 1, 1);
    local v9 = p6 and p6.Value or Vector3.new(0, 0, -0.025);
    local v10 = p7 and p7.Value or Vector3.new(0, 0, 0);
    local math_rad_ret = math.rad(v10.X);
    local math_rad_ret2 = math.rad(v10.Y);
    local math_rad_ret3 = math.rad(v10.Z);
    local Vector3_new_ret = Vector3.new(math_rad_ret, math_rad_ret2, math_rad_ret3);
    local v11 = CFrame_Angles_ret * CFrame.Angles(Vector3_new_ret.X, Vector3_new_ret.Y, Vector3_new_ret.Z);
    p3.Size = v8;
    p4.C0 = CFrame.new(v9);
    p4.C1 = p3.PivotOffset * v11;
end;

return function(p12: table, p13: userdata, p14: userdata, p15: table?) -- Line: 46
    -- upvalues: u2 (copy), u1 (copy), applyGloveConfig (copy), RunService (copy)
    local v16 = {};

    for _, v in ipairs(p12) do
        if v:IsA("BasePart") then
            local v17 = u2[v.Name];

            if v17 then
                v17 = p13:FindFirstChild(v17);
            end;

            if v17 then
                local u18 = v:Clone();
                u18.Name = u1[v.Name];
                u18.CastShadow = false;
                u18.CanCollide = false;
                u18.CanTouch = false;
                u18.Anchored = false;
                u18.CanQuery = false;
                u18.Massless = true;

                if p15 and p15.collisionGroup then
                    u18.CollisionGroup = p15.collisionGroup;
                end;

                local Rotations = u18:FindFirstChild("Rotations");
                local Offsets = u18:FindFirstChild("Offsets");
                local Scales = u18:FindFirstChild("Scales");
                local Motor6D = Instance.new("Motor6D");
                Motor6D.Name = "GloveAttachment";
                Motor6D.Part0 = v17;
                Motor6D.Part1 = u18;
                Motor6D.Parent = u18;
                u18.Parent = p14;
                applyGloveConfig(u18, Motor6D, Scales, Offsets, Rotations);
                local v19 = RunService:IsStudio();
                local v20 = ipairs;
                local v21 = {};
                local v22;

                if Scales then
                    v22 = Scales:FindFirstChild("Character");
                else
                    v22 = Scales;
                end;

                local v23;

                if Offsets then
                    v23 = Offsets:FindFirstChild("Character");
                else
                    v23 = Offsets;
                end;

                local v24;

                if Rotations then
                    v24 = Rotations:FindFirstChild("Character");
                else
                    v24 = Rotations;
                end;

                v21[1], v21[2], v21[3] = v22, v23, v24;

                for _, v2 in v20(v21) do
                    if v19 then
                        v2:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 96
                            -- upvalues: applyGloveConfig (ref), u18 (copy), Motor6D (copy), Scales (copy), Offsets (copy), Rotations (copy)
                            applyGloveConfig(u18, Motor6D, Scales, Offsets, Rotations);
                        end);
                    else
                        v2:Destroy();
                    end;
                end;

                table.insert(v16, u18);
            end;
        end;
    end;

    return v16;
end;