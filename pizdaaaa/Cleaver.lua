-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Knives.Cleaver
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Knives.Cleaver
-- Decompile time: 11.80 ms

-- Decompiled with Potassium's decompiler.

return {
    Animations = script:GetChildren(),
    Rig = {
        name = "HumanoidRootPart",
        c0 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        c1 = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        children = {
            {
                name = "LowerTorso",
                c0 = CFrame.new(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                c1 = CFrame.new(-1.1920929e-7, -0.199972257, -0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                children = {
                    {
                        name = "RightUpperLeg",
                        c0 = CFrame.new(0.499999881, -0.199972257, -0.0000191208565, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        c1 = CFrame.new(-0, 0.420782268, -0.0000667300628, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        children = {
                            {
                                name = "RightLowerLeg",
                                c0 = CFrame.new(-0, -0.400946498, -0.0000218767891, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(-0, 0.379174292, 0.000025553607, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "RightFoot",
                                        c0 = CFrame.new(-0, -0.547157168, 0.0000762689815, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(-0, 0.101939559, 0.0000764477954, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                                    }
                                }
                            }
                        }
                    },
                    {
                        name = "LeftUpperLeg",
                        c0 = CFrame.new(-0.500000119, -0.199972257, -0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        c1 = CFrame.new(5.96046448e-8, 0.420782208, -1.63912773e-7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        children = {
                            {
                                name = "LeftLowerLeg",
                                c0 = CFrame.new(8.94069672e-8, -0.401102424, -4.29081496e-7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(2.98023224e-8, 0.379018486, -1.60860594e-7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "LeftFoot",
                                        c0 = CFrame.new(-1.1920929e-7, -0.547157228, -2.21401592e-6, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(-1.78813934e-7, 0.101939693, -1.7222776e-6, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                                    }
                                }
                            }
                        }
                    },
                    {
                        name = "UpperTorso",
                        c0 = CFrame.new(-1.1920929e-7, 0.200024918, 7.64462551e-20, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        c1 = CFrame.new(-5.96046448e-8, -0.799985707, 1.1920929e-7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                        children = {
                            {
                                name = "Head",
                                c0 = CFrame.new(-5.96046448e-8, 0.800017118, 1.1920929e-7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(-0, -0.500000119, -0.000272244215, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                            },
                            {
                                name = "LeftUpperArm",
                                c0 = CFrame.new(-1, 0.56301713, 1.1920929e-7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(0.500000358, 0.394326687, 8.94069672e-8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "LeftLowerArm",
                                        c0 = CFrame.new(0.000479221344, -0.334056377, 8.94069672e-8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(0.000478625298, 0.258688211, 7.64462551e-20, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        children = {
                                            {
                                                name = "LeftHand",
                                                c0 = CFrame.new(0.000478625298, -0.5009287, 7.64462551e-20, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                c1 = CFrame.new(0.000478982925, 0.125045404, 5.96046448e-8, 1, 0, 0, 0, 1, 0, 0, 0, 1)
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                name = "RightUpperArm",
                                c0 = CFrame.new(0.99999994, 0.56301713, 1.1920929e-7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                c1 = CFrame.new(-0.500000715, 0.394326687, 8.94069672e-8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                children = {
                                    {
                                        name = "RightLowerArm",
                                        c0 = CFrame.new(-5.96046448e-7, -0.334165096, 8.94069672e-8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        c1 = CFrame.new(1.1920929e-7, 0.258579493, 7.64462551e-20, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                        children = {
                                            {
                                                name = "RightHand",
                                                c0 = CFrame.new(1.1920929e-7, -0.5009287, -6.86244753e-18, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                c1 = CFrame.new(3.57627869e-7, 0.125045404, 5.96046448e-8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
                                                children = {
                                                    {
                                                        name = "HandleMotor",
                                                        c0 = CFrame.new(
                                                            -0.239349365,
                                                            -0.028585434,
                                                            -0.405975342,
                                                            -1,
                                                            1.08528479e-6,
                                                            -0.0000174532943,
                                                            0.0000174532943,
                                                            -2.71361529e-7,
                                                            -1,
                                                            -1.08528957e-6,
                                                            -1,
                                                            2.71342572e-7
                                                        ),
                                                        c1 = CFrame.new(
                                                            0,
                                                            -0.228988647,
                                                            -0.178726435,
                                                            1,
                                                            -1.64452263e-6,
                                                            3.93537362e-13,
                                                            1.64452263e-6,
                                                            1,
                                                            -4.1116121e-7,
                                                            2.82626624e-13,
                                                            4.1116121e-7,
                                                            1
                                                        )
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
            }
        }
    }
};