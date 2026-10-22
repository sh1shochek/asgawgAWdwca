-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.MP9
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.SMG.MP9
-- Decompile time: 5.24 ms

-- Decompiled with Potassium's decompiler.

return {
    Animations = script:GetChildren(),
    Rig = {
        name = "RootPart",
        c0 = CFrame.identity,
        c1 = CFrame.identity,
        children = {
            {
                name = "Right Arm",
                c0 = CFrame.new(
                    1.322571,
                    -1.5684,
                    -2.870651,
                    0.9996351,
                    -0.02590543,
                    -0.00764983,
                    0.02560632,
                    0.9989908,
                    -0.03690286,
                    0.008598093,
                    0.03669351,
                    0.9992896
                ),
                c1 = CFrame.new(-0.2929916, -3.814697e-6, -1.859146),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.2299957,
                            0.4600067,
                            -1.752899,
                            0.9996352,
                            0.02560497,
                            0.008598033,
                            -0.02590409,
                            0.9989907,
                            0.03669589,
                            -0.007649758,
                            -0.03690523,
                            0.9992895
                        ),
                        c1 = CFrame.new(-0.00004577637, 0.1400738, 0.1099243),
                        children = {
                            {
                                name = "Slid",
                                c0 = CFrame.new(0.1225128, 0.2569361, 1.152496),
                                c1 = CFrame.new(0.0789566, 0.3971109, -1.027191)
                            },
                            {
                                name = "Slide",
                                c0 = CFrame.new(0.106041, 0.374258, -0.3276215),
                                c1 = CFrame.new(-0.00005340576, 0.00006484985, -0.3150787)
                            },
                            {
                                name = "Mag",
                                c0 = CFrame.new(0.00003814697, -0.5795918, 0.3276215),
                                c1 = CFrame.identity
                            }
                        }
                    }
                }
            },
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    1.399673,
                    -1.738089,
                    -3.674179,
                    0.9193099,
                    -0.004199215,
                    -0.3935119,
                    -0.08189648,
                    0.9760095,
                    -0.201739,
                    0.3849185,
                    0.2176879,
                    0.8969112
                ),
                c1 = CFrame.new(0.2740097, -3.814697e-6, -1.860062)
            }
        }
    }
};