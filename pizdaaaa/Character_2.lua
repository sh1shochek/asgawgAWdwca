-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Character
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Character
-- Decompile time: 4.80 ms

-- Decompiled with Potassium's decompiler.

local v1 = {};

for _, child in ipairs(script:GetChildren()) do
    if child:IsA("ModuleScript") then
        table.insert(v1, child);
    end;
end;

return {
    Animations = v1,
    Rig = {
        name = "HumanoidRootPart",
        c0 = CFrame.identity,
        c1 = CFrame.identity,
        children = {
            {
                name = "LowerTorso",
                c0 = CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                c1 = CFrame.new(0, -0.19997, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                children = {
                    {
                        name = "LeftUpperLeg",
                        c0 = CFrame.new(-0.5, -0.19997, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        c1 = CFrame.new(0, 0.42078, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        children = {
                            {
                                name = "LeftLowerLeg",
                                c0 = CFrame.new(0, -0.4011, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(0, 0.37902, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "LeftFoot",
                                        c0 = CFrame.new(0, -0.54716, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(0, 0.10194, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                                    }
                                }
                            }
                        }
                    },
                    {
                        name = "UpperTorso",
                        c0 = CFrame.new(0, 0.20002, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        c1 = CFrame.new(0, -0.79999, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        children = {
                            {
                                name = "Head",
                                c0 = CFrame.new(0, 0.80002, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(0, -0.5, -0.00027, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                            },
                            {
                                name = "LeftUpperArm",
                                c0 = CFrame.new(-1, 0.56302, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(0.5, 0.39433, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "LeftLowerArm",
                                        c0 = CFrame.new(0.00048, -0.33406, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(0.00048, 0.25869, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        children = {
                                            {
                                                name = "LeftHand",
                                                c0 = CFrame.new(0.00048, -0.50093, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                c1 = CFrame.new(0.00048, 0.12505, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                name = "RightUpperArm",
                                c0 = CFrame.new(1, 0.56302, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(-0.5, 0.39433, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "RightLowerArm",
                                        c0 = CFrame.new(0, -0.33417, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(0, 0.25858, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        children = {
                                            {
                                                name = "RightHand",
                                                c0 = CFrame.new(0, -0.50093, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                c1 = CFrame.new(0, 0.12505, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                children = {
                                                    {
                                                        name = "Handle",
                                                        c0 = CFrame.new(-0.30487, -0.11006, -0.47034, 1, 0, 0, 0, 0, 1, 0, -1, 0),
                                                        c1 = CFrame.identity,
                                                        children = {
                                                            {
                                                                name = "Slide1",
                                                                c0 = CFrame.new(0.00146, 0.23004, -0.0043, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                                c1 = CFrame.identity
                                                            },
                                                            {
                                                                name = "Mag",
                                                                c0 = CFrame.new(0.00085, -0.10638, 0.31068, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                                c1 = CFrame.identity
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        name = "RightUpperLeg",
                        c0 = CFrame.new(0.5, -0.19997, -0.00002, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        c1 = CFrame.new(0, 0.42078, -0.00007, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        children = {
                            {
                                name = "RightLowerLeg",
                                c0 = CFrame.new(0, -0.40095, -0.00002, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(0, 0.37917, 0.00003, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "RightFoot",
                                        c0 = CFrame.new(0, -0.54716, 0.00008, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(0, 0.10194, 0.00008, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
};