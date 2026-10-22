-- ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.P2000
-- Script path: ReplicatedStorage.Shared.Managers.AnimationManager.Rigs.Weapons.Pistols.P2000
-- Decompile time: 4.52 ms

-- Decompiled with Potassium's decompiler.

return {
    Animations = script:GetChildren(),
    Rig = {
        name = "RootPart",
        c0 = CFrame.identity,
        c1 = CFrame.identity,
        children = {
            {
                name = "Left Arm",
                c0 = CFrame.new(
                    1.16552,
                    -1.753506,
                    -2.801788,
                    0.8813658,
                    -0.2756662,
                    -0.3836698,
                    0.2125485,
                    0.9566541,
                    -0.1990884,
                    0.4219212,
                    0.09392131,
                    0.9017546
                ),
                c1 = CFrame.new(0.2730045, 4.768372e-7, -1.870987)
            },
            {
                name = "Right Arm",
                c0 = CFrame.new(
                    1.233957,
                    -1.568382,
                    -2.851444,
                    0.9996353,
                    -0.02590103,
                    -0.00764725,
                    0.02560207,
                    0.9989911,
                    -0.03689782,
                    0.008595225,
                    0.03668858,
                    0.9992899
                ),
                c1 = CFrame.new(-0.2680073, -3.814697e-6, -1.840008),
                children = {
                    {
                        name = "Handle",
                        c0 = CFrame.new(
                            -0.2032928,
                            0.2476187,
                            -1.944519,
                            0.9996352,
                            0.02560499,
                            0.008598058,
                            -0.02590411,
                            0.9989908,
                            0.03669521,
                            -0.0076498,
                            -0.03690455,
                            0.9992895
                        ),
                        c1 = CFrame.identity,
                        children = {
                            {
                                name = "Slide2",
                                c0 = CFrame.new(0.0002212524, 0.388278, 0.7301636),
                                c1 = CFrame.identity
                            },
                            {
                                name = "Slide1",
                                c0 = CFrame.new(-0.0005722046, 0.4597912, -0.01179504),
                                c1 = CFrame.identity
                            },
                            {
                                name = "Mag",
                                c0 = CFrame.new(0.0002365112, -0.1274242, 0.4876709),
                                c1 = CFrame.identity
                            }
                        }
                    }
                }
            }
        }
    }
};