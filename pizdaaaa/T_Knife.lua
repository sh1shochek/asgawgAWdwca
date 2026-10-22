-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Knives.T Knife
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Character.Knives.T Knife
-- Decompile time: 7.19 ms

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
                                                            -0.266235352,
                                                            0.0874321461,
                                                            -0.398986816,
                                                            -0.0000338325262,
                                                            1.29139693e-7,
                                                            -1,
                                                            1,
                                                            0.000100454512,
                                                            -0.0000338328064,
                                                            0.000100454505,
                                                            -1,
                                                            1.29139664e-7
                                                        ),
                                                        c1 = CFrame.new(
                                                            2.38418579e-7,
                                                            -0.299987793,
                                                            0,
                                                            1,
                                                            0,
                                                            -1.28908509e-10,
                                                            0,
                                                            1,
                                                            -1.32538261e-7,
                                                            -1.41881187e-10,
                                                            -1.32538275e-7,
                                                            1
                                                        )
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
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
                            }
                        }
                    }
                }
            }
        }
    }
};